using Cameras
using Test

@testset "Acquisition" begin
    image_size = (2, 2)

    function produce_images!(image_source::Channel)
        while true
            put!(image_source, zeros(image_size))
        end
    end

    @testset "Manually triggered" begin
        image_source = Channel(produce_images!)
        camera = SimulatedCamera(image_source)

        @test !isopen(camera)
        open!(camera)
        @test isopen(camera)

        @test !isrunning(camera)
        start!(camera)
        @test isrunning(camera)

        @testset "Synchronous" begin
            trigger!(camera)
            img = take!(camera)
            @test size(img) == image_size
        end

        @testset "Asynchronous" begin
            let img = zeros(0, 0)
                @sync begin
                    @async img = take!(camera)
                    @async trigger!(camera)
                end
                @test size(img) == image_size
            end
        end

        @assert isrunning(camera)
        stop!(camera)
        @test !isrunning(camera)

        @assert isopen(camera)
        close!(camera)
        @test !isopen(camera)
    end

    @testset "Continuously triggered" begin
        period = 0.04 # seconds

        function produce_triggers!(trigger_source::Channel{UInt64})
            while true
                put!(trigger_source, time_ns())
                sleep(period)
            end
        end
        trigger_source = Channel(produce_triggers!; ctype = UInt64)
        image_source = Channel(produce_images!)

        continuous_camera = SimulatedCamera(trigger_source, image_source)

        start!(continuous_camera)

        let i = 0
            while i < 5
                i += 1
                img = take!(continuous_camera)
                @assert size(img) == image_size
            end
            @test i == 5
        end

        @testset "Stopping camera terminates acquisition task" begin
            acquisition_task_started = Condition()
            acquisition_task_terminated = Condition()
            acquisition_task = @task begin
                notify(acquisition_task_started)
                try
                    while true
                        take!(continuous_camera)
                    end
                finally
                    notify(acquisition_task_terminated)
                end
            end
            schedule(acquisition_task)
            wait(acquisition_task_started)
            @assert istaskstarted(acquisition_task)

            @assert isrunning(continuous_camera)
            stop!(continuous_camera)
            @test !isrunning(continuous_camera)
            @test !isopen(trigger_source)
            @test !isopen(image_source)

            wait(acquisition_task_terminated)
            @test istaskdone(acquisition_task)
            @static if VERSION >= v"1.3"
                @test_throws TaskFailedException wait(acquisition_task)
                (e, _) = first(Base.catch_stack(acquisition_task))
                @test e isa InvalidStateException
            else
                @test_throws InvalidStateException wait(acquisition_task)
            end
        end
    end
end
