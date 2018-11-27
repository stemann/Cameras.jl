module Cameras

import Base: take!

export Camera,
    isrunning,
    start!,
    stop!,
    take!,
    trigger!

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

Take an image, i.e. an [`AcquiredImage`](@ref). Blocks until an image is available.
"""
take!(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    trigger!(camera::Camera)

Trigger image acquisition.
"""
trigger!(camera::Camera) = error("No implementation for $(typeof(camera))")

export AcquiredImage,
    id,
    timestamp

abstract type AcquiredImage{T,N} <: AbstractArray{T,N}
end

"""
    id(image::AcquiredImage)

Return image ID.
"""
id(image::AcquiredImage) = error("No implementation for $(typeof(image))")

"""
    id(image::AcquiredImage)

Return image timestamp.
"""
timestamp(image::AcquiredImage) = error("No implementation for $(typeof(image))")

import Base: iterate, IteratorSize
export iterate,
    IteratorSize
include("iteration.jl")

export SimulatedCamera
include("simulated_camera.jl")

end # module
