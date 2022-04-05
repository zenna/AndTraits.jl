using Test
using AndTraits
using AndTraits: Trait

const Iterable = Trait{:Iterable}
const Indexable = Trait{:Indexable}
const Smelly = Trait{:Smelly}
AndTraits.traits(::Vector) = Iterable ∧ Indexable
AndTraits.traits(::Set) = Iterable

g(x) = g(traits(x), x)
g(::traitmatch(Iterable), x) = "This is a string"
g(::traitmatch(Iterable, Indexable), x) = 21

const x = [1, 2, 3]
@inferred g(x)
@inferred g(Set([1,2,3]))
@test g(x) == 21
@test g(Set([1,2,3])) == "This is a string"
@test_throws MethodError g(12)