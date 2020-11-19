using Test
using AndTraits
using AndTraits: Trait

# Make a trait
Err = Trait{:Err}
Whut = Trait{:Whut}

# Construct a new type
struct MyType{T}
  x::T
end

AndTraits.traits(::MyType{T}) where T = traits(T)

const a = MyType((Err = 10,))
const b = MyType((Whut = 10,))
const c = MyType((Whut = 10, Err = 10))

f(x) = f(traits(x), x)
f(::trait(Err), x) = "Hello" 
f(::trait(Whut), x) = 2 
f(::trait(Err, Whut), x) = :Howdy

@test f(a) == "Hello"
@test f(b) == 2
@test f(c) == :Howdy

@inferred f(a)
@inferred f(b)
@inferred f(c)