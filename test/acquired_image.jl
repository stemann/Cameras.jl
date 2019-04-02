using Cameras
using Test

@testset "Acquired Image" begin
    image_size = (2, 2)

    function produce_images!(image_source::Channel)
        while true
            put!(image_source, zeros(image_size))
        end
    end
    image_source = Channel(produce_images!)

    camera = SimulatedCamera(image_source)

    t_1 = time_ns()
    trigger!(camera)
    img = take!(camera)
    @test typeof(img) <: AbstractAcquiredImage
    @assert size(img) == image_size

    @test ref_count(img) == 1

    retain!(img)
    @test ref_count(img) == 2

    release!(img)
    @test ref_count(img) == 1

    @test id(img) == 1
    @test timestamp(img) >= t_1

    t_2 = time_ns()
    trigger!(camera)
    img = take!(camera)
    @test id(img) == 2
    @test timestamp(img) >= t_2
end
