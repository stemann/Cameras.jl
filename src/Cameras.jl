module Cameras

export Camera,
    isrunning,
    start!,
    stop!

abstract type Camera end

isrunning(camera::Camera) = error("No implementation for $(typeof(camera))")
start!(camera::Camera) = error("No implementation for $(typeof(camera))")
stop!(camera::Camera) = error("No implementation for $(typeof(camera))")

end # module
