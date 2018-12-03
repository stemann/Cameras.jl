using Cameras
using Test

@testset "Acquisition" begin
    image_size = (2, 2)

    function produce_images!(image_source::Channel)
        while true
            put!(image_source, zeros(image_size))
        end
    end
    image_source = Channel(produce_images!)

    @testset "Manually triggered" begin
        camera = SimulatedCamera(image_source)

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
    end

    @testset "Continuously triggered" begin
        period = 0.04 # seconds

        function produce_triggers!(trigger_source::Channel)
            while true
                put!(trigger_source, nothing)
                sleep(period)
            end
        end
        trigger_source = Channel(produce_triggers!)

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
    end
end
