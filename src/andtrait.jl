export traitmatch, AndTrait

"And (Intersection) Trait"
struct AndTrait{T} end 

"Produces type which will only match those which have trait"
@inline traitmatch(x::Type{AndTrait{X}}) where X = Type{AndTrait{T}} where {T >: X}
@inline traitmatch(x1, x2) = traitmatch(x1 ∧ x2)
@inline traitmatch(x1, x2, x3) = traitmatch(x1 ∧ x2 ∧ x3)
@inline traitmatch(x1, xs...) = traitmatch(conjointraits(x1, xs...))

# @inline trait(x1, x2) = trait(Union{x1, x2})
# @inline trait(x1, x2, x3) = trait(Union{x1, x2, x3})
# @inline trait(x1, x2, x3, x4) = trait(Union{x1, x2, x3, x4})
# @inline trait(x1, x2, x3, x4, x5) = trait(Union{x1, x2, x3, x4, x5})
# @inline trait(x1, x2, x3, x4, x5, xs...) = trait(Union{x1, x2, x3, x4, x5, xs...})

"`traits(::Type{T}` traits of `T`"
function traits end