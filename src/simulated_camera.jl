mutable struct SimulatedCamera <: Camera
    isrunning::Bool
    trigger_source::Channel
    image_source::Channel
    next_id::Int
    next_timestamp::Int
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
        new(false, trigger_source, image_source, 0, 0)
    end
end

mutable struct SimulatedAcquiredImage{T,N} <: AcquiredImage{T,N}
    # Inherits behaviour of AbstractPooledDenseArray, by having the same fields
    array::Array{T,N}
    ref_count::Int
    dispose::Function

    is_disposed::Bool
    id::Int
    timestamp::Int
    function SimulatedAcquiredImage(a::Array{T,N}, id, timestamp) where {T,N}
        function dispose(img)
            @debug "Disposing $img"
            img.is_disposed = true
        end
        new{T,N}(a, 1, dispose, false, id, timestamp)
    end
end

id(img::SimulatedAcquiredImage) = img.id
timestamp(img::SimulatedAcquiredImage) = img.timestamp

isrunning(camera::SimulatedCamera) = camera.isrunning

function start!(camera::SimulatedCamera)
    camera.isrunning = true
end

function stop!(camera::SimulatedCamera)
    camera.isrunning = false
end

function take!(camera::SimulatedCamera)
    image = take!(camera.image_source)
    id = camera.next_id += 1
    timestamp = camera.next_timestamp += 1000
    take!(camera.trigger_source)
    return SimulatedAcquiredImage(image, id, timestamp)
end

function trigger!(camera::SimulatedCamera)
    put!(camera.trigger_source, nothing)
end
