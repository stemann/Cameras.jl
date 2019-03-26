abstract type AcquiredImage{T,N} <: AbstractPooledDenseArray{T,N}
end

"""
    id(image::AcquiredImage)

Return image ID.
"""
id(image::AcquiredImage) = error("No implementation for $(typeof(image))")

"""
    timestamp(image::AcquiredImage)

Return image timestamp.
"""
timestamp(image::AcquiredImage) = error("No implementation for $(typeof(image))")
