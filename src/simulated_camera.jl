mutable struct SimulatedCamera <: Camera
    isrunning::Bool
    trigger_source::Channel
    image_source::Channel
    SimulatedCamera(image_source::Channel) = new(false, Channel(Inf), image_source)
    SimulatedCamera(trigger_source::Channel, image_source::Channel) = new(false, trigger_source, image_source)
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
