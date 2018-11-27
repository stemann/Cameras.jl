using Cameras
using Test

@testset "Iteration" begin
    period = 0.04 # seconds
    image_size = (2, 2)

    function produce_triggers!(trigger_source::Channel)
        while true
            sleep(period)
            put!(trigger_source, nothing)
        end
    end
    trigger_source = Channel(produce_triggers!)

    function produce_images!(image_source::Channel)
        while true
            put!(image_source, zeros(image_size))
        end
    end
    image_source = Channel(produce_images!)

    camera = SimulatedCamera(trigger_source, image_source)

    start!(camera)

    iterations = 5
    let i = 0
        t_0 = time()
        for img in camera
            i += 1
            if i >= iterations
                break
            end
        end
        t_1 = time()
        @test i == iterations
        @test t_1 - t_0 >= iterations * period
    end

    t_0 = time()
    for img in Iterators.take(camera, iterations)
    end
    t_1 = time()
    @test t_1 - t_0 >= iterations * period

    t_0 = time()
    images = [img for img in Iterators.take(camera, iterations)]
    t_1 = time()
    @test t_1 - t_0 >= iterations * period
end
