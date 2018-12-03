mutable struct SimulatedCamera <: Camera
    isrunning::Bool
    trigger_source::Channel
    image_source::Channel
    SimulatedCamera(image_source::Channel) = new(false, Channel(Inf), image_source)
    SimulatedCamera(trigger_source::Channel, image_source::Channel) = new(false, trigger_source, image_source)
    function SimulatedCamera(trigger_period::Real, image_source::Channel)
        function produce_triggers!(trigger_source::Channel)
            while true
                sleep(trigger_period)
                put!(trigger_source, nothing)
            end
        end
        trigger_source = Channel(produce_triggers!)
        new(false, trigger_source, image_source)
    end
end

isrunning(camera::SimulatedCamera) = camera.isrunning

function start!(camera::SimulatedCamera)
    camera.isrunning = true
end

function stop!(camera::SimulatedCamera)
    camera.isrunning = false
end

function take!(camera::SimulatedCamera)
    image = take!(camera.image_source)
    take!(camera.trigger_source)
    return image
end

function trigger!(camera::SimulatedCamera)
    put!(camera.trigger_source, nothing)
end
