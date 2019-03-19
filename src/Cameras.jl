module Cameras

using ResourcePools

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
take!(camera::Camera)::AcquiredImage = error("No implementation for $(typeof(camera))")

"""
    trigger!(camera::Camera)

Trigger image acquisition.
"""
trigger!(camera::Camera) = error("No implementation for $(typeof(camera))")

export AcquiredImage,
    image_number,
    timestamp
include("acquired_image.jl")

import Base: iterate, IteratorSize
export iterate,
    IteratorSize
include("iteration.jl")

export SimulatedCamera
include("simulated_camera.jl")

end # module
