function iterate(camera::Camera, state=nothing)
    try
        return take!(camera), camera
    catch e
        if isa(e, InvalidStateException)
            return nothing
        else
            throw(e)
        end
    end
end

IteratorSize(camera::Camera) = Base.IsInfinite()
