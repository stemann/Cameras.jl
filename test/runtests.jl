using Test

@testset "Cameras" begin
    include("acquisition.jl")
    include("iteration.jl")
    include("acquired_image.jl")
end
