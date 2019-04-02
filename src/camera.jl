abstract type Camera end

"""
    open!(camera::Camera)

Open camera.
"""
open!(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    close!(camera::Camera)

Close camera.
"""
close!(camera::Camera) = error("No implementation for $(typeof(camera))")

"""
    isopen(camera::Camera)

Return if the camera is open.
"""
isopen(camera::Camera) = error("No implementation for $(typeof(camera))")

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

Take an image, i.e. an [`AbstractAcquiredImage`](@ref). Blocks until an image is available.
"""
take!(camera::Camera)::AbstractAcquiredImage = error("No implementation for $(typeof(camera))")

"""
    trigger!(camera::Camera)

Trigger image acquisition.
"""
trigger!(camera::Camera) = error("No implementation for $(typeof(camera))")
