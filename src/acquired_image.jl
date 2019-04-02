abstract type AbstractAcquiredImage{T,N} <: AbstractPooledDenseArray{T,N}
end

"""
    id(image::AcquiredImage)

Return image ID.
"""
id(image::AbstractAcquiredImage) = error("No implementation for $(typeof(image))")

"""
    timestamp(image::AcquiredImage)

Return image timestamp.
"""
timestamp(image::AbstractAcquiredImage) = error("No implementation for $(typeof(image))")


mutable struct AcquiredImage{T,N} <: AbstractAcquiredImage{T,N}
    # Inherits behaviour of AbstractPooledDenseArray, by having the same fields
    array::Array{T,N}
    ref_count::Int
    dispose::Function

    id::Int
    timestamp::Int
    function AcquiredImage(a::Array{T,N}, id, timestamp) where {T,N}
        function dispose(img)
            @debug "Disposing $img"
        end
        new{T,N}(a, 1, dispose, id, timestamp)
    end
end

id(img::AcquiredImage) = img.id
timestamp(img::AcquiredImage) = img.timestamp

function Base.show(io::IO, image::AcquiredImage)
    write(io, "$(nameof(AcquiredImage))(id:$(image.id), timestamp:$(image.timestamp), ref_count:$(image.ref_count), array:$(image.array))")
end
