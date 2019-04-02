mutable struct SimulatedCamera <: Camera
    trigger_source::Channel{UInt64}
    image_source::Channel
    isopen::Bool
    isrunning::Bool
    current_id::Int
    SimulatedCamera(image_source::Channel) = new(Channel{UInt64}(Inf), image_source, false, false, 0)
    SimulatedCamera(trigger_source::Channel{UInt64}, image_source::Channel) = new(trigger_source, image_source, false, false, 0)
    function SimulatedCamera(trigger_period::Real, image_source::Channel)
        function produce_triggers!(trigger_source::Channel{UInt64})
            while true
                sleep(trigger_period)
                put!(trigger_source, time_ns())
            end
        end
        trigger_source = Channel(produce_triggers!; ctype = UInt64)
        new(trigger_source, image_source, false, false, 0)
    end
end

isopen(camera::SimulatedCamera) = camera.isopen
open!(camera::SimulatedCamera) = camera.isopen = true
close!(camera::SimulatedCamera) = camera.isopen = false

isrunning(camera::SimulatedCamera) = camera.isrunning
start!(camera::SimulatedCamera) = camera.isrunning = true
stop!(camera::SimulatedCamera) = camera.isrunning = false

function take!(camera::SimulatedCamera)
    @debug "Taking image from $(camera.image_source)"
    image = take!(camera.image_source)
    id = camera.current_id += 1
    @debug "Taking trigger from $(camera.trigger_source)"
    timestamp = take!(camera.trigger_source)
    return AcquiredImage(image, id, timestamp)
end

function trigger!(camera::SimulatedCamera)
    put!(camera.trigger_source, time_ns())
end

function Base.show(io::IO, camera::SimulatedCamera)
    write(io, "$(nameof(SimulatedCamera))(trigger_source:$(camera.trigger_source), image_source:$(camera.image_source), current_id:$(camera.current_id))")
end
