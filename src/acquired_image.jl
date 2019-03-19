abstract type AcquiredImage{T,N} <: AbstractPooledArray{T,N}
end

"""
    image_number(image::AcquiredImage)

Return image number.
"""
image_number(image::AcquiredImage) = error("No implementation for $(typeof(image))")

"""
    timestamp(image::AcquiredImage)

Return image timestamp.
"""
timestamp(image::AcquiredImage) = error("No implementation for $(typeof(image))")
