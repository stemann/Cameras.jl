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

    trigger!(camera)
    img = take!(camera)
    @test typeof(img) <: AcquiredImage
    @assert size(img) == image_size

    @test ref_count(img) == 1

    retain!(img)
    @test ref_count(img) == 2

    release!(img)
    @test ref_count(img) == 1

    @assert !img.is_disposed
    release!(img)
    @test img.is_disposed

    @test id(img) == 1
    @test timestamp(img) == 1000

    trigger!(camera)
    img = take!(camera)
    @test id(img) == 2
    @test timestamp(img) == 2000
end
