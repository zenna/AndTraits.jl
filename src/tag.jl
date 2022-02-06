export Trait, ∧, conjointraits

# "Returns the traits of an objec"
# function traits end
struct ATrait{T} end

Trait{T} = AndTrait{Union{ATrait{T}}}

(∧)(t1::Type{AndTrait{T1}}, t2::Type{AndTrait{T2}}) where {T1, T2} =
  conjointraits(t1, t2)

conjointraits(::Type{AndTrait{T1}}, ::Type{AndTrait{T2}}) where {T1, T2} =
  AndTrait{Union{T1, T2}}

  conjointraits(t1::Type{<:AndTrait}, t2::Type{<:AndTrait}, ts...) =
  conjointraits(conjointraits(t1, t2), ts...)