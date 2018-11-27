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
end
