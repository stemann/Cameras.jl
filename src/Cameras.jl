module Cameras

import Base: take!

export Camera,
    isrunning,
    start!,
    stop!,
    take!

abstract type Camera end

"""
    isrunning(camera::Camera)

Return if the camera is running.
"""
isrunning(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    start!(camera::Camera)

Start camera, i.e. start image acquisition.
"""
start!(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    stop!(camera::Camera)

Stop camera, i.e. stop image acquisition.
"""
stop!(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    take!(camera::Camera)

Take an image, i.e. an [`AbstractArray`](@ref). Blocks until an image is available.
"""
take!(camera::Camera) = error("No implementation for $(typeof(camera))")

import Base: iterate, IteratorSize
export iterate,
    IteratorSize
include("iteration.jl")

end # module
