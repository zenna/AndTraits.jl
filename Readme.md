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
const Iterable = Trait{:Iterable}
```

```julia
# This is another trait
const Indexable = Trait{:Indexable}
```


Now let's give some types these traits

```julia
AndTraits.traits(::Vector) = Iterable ∧ Indexable
AndTraits.traits(::Set) = Iterable
```

Now let's define some methods that use these trarts

```
g(x) = g(traits(x), x)
g(::traitmatch(Iterable), x) = "This is a string"
g(::traitmatch(Iterable, Indexable), x) = 21
```

Now let's evaluate `g` on some different inputs

```julia
@test g(x) == 21
@test g(Set([1,2,3])) == "This is a string"
```

# How does this compare to?

## Abstract Types

A type can belong to many traits

## Holy Traits

Holy traits (which have been syntactically sugared in [SimpleTraits.jl](https://github.com/mauro3/SimpleTraits.jl)) allow you to add multiple traits to a type.
But, when you use the traits, you have to decide at the point of dispatch which trait you care about.

So for example we can define the trait `SomeTrait` as above, but we also need to define a trait dispatch method `hasSomeTrait`, such that `hasSomeTrait(t)`
So you right methods of the form:

```julia
f(x) = f(hasSomeTrait(x), x) 
f(::SomeTrait, x) = ...
```

This is fine, but it inhibits extensibility.