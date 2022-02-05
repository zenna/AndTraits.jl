# AndTraits.jl

A system for dispatching on conjunctions of traits.

Basic idea:
1. Type hierarchies are oppresive — we'd rather simply specify that values and types have particular properties.  For instance that the type is indexable.  Sometimes these kinds of properties are called [traits](https://en.wikipedia.org/wiki/Trait_(computer_programming)).
2. Often we want to write methods that are specific to particular combinations of traits.  That is, we want to say:
  1. do something if type has trait A
  2. do something else if type has trait A and B
  3. do something else if type has trait A and B and C

There are many implementations of traits in Julia which do 1 but as far as I am aware this is the first approach that supports conjunctions of traits.

## How to use it

First make some traits

```julia
# This is a trait
const SomeTrait = Trait{:Err}

# This is another trait
const SomeOtherTrait = Trait{:Whut}
```

Now let's give some types these traits

```julia
sup(::Type{Array{Int, 1}}, ::SomeTrait) = true
sup(::Type{Array{Int, 1}}, ::SomeOtherTrait) = true

AndTraits.traits(::Array{Int, 1}) = SomeTrait
AndTraits.traits(::Array{Int, 1}) = SomeOtherTrait


abstract type AbstractTrait end
struct Dog <: Smelly end
struct Cat <: Smelly end
struct LLama <: Smelly end

hastrait(::Type{Array{Int, 1}}, ::Type{Cat}) = true
hastrait(::Type{Array{Int, 1}}, ::Type{Dog}) = true
hastrait(::Type{Array{Int, 1}}, ::Type{LLama}) = true
hastrait(t, x) = false

function thatraits(::Type{T}) where T
  types = filter(t->sup(T, t), subtypes(Smelly))
  Union{types...}
end

x(::trait(Cat, Dog)) = traits()
```

Now let's write some methods:

```julia
f(x) = f(traits(x), x)
f(::trait(SomeTrait)) = :ok
f(::trait(SomeTrait)) = :ok
```

# How does this compare to?

## Abstract Types

1. A type can belong to many
2. types can be made part of traits after they have been defined

## Holy Traits

Holy traits (which have been syntactically sugared in [SimpleTraits.jl](https://github.com/mauro3/SimpleTraits.jl)) allow you to add multiple traits to a type.
But, when you use the traits, you have to decide at the point of dispatch which trait you care about.

So for example we can define the trait `SomeTrait` as above, but we also need to define a trait dispatch method `hasSomeTrait`, such that `hasSomeTrait(t)`
So you right methods of the form:

```
f(x) = f(hasSomeTrait(x), x) 
f(::SomeTrait, x) = ...
```

This is fine, but it inhibits extensibility.