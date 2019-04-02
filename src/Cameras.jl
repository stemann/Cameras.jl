module Cameras

using ResourcePools

import Base: isopen, take!

import ResourcePools:
    ref_count,
    release!,
    resource,
    retain!

export Camera,
    open!,
    close!,
    isopen,
    isrunning,
    start!,
    stop!,
    take!,
    trigger!
include("camera.jl")

export AbstractAcquiredImage,
    id,
    timestamp,
    ref_count,
    release!,
    resource,
    retain!
include("acquired_image.jl")

import Base: iterate, IteratorSize
export iterate,
    IteratorSize
include("iteration.jl")

export SimulatedCamera,
    AcquiredImage
include("simulated_camera.jl")

end # module
