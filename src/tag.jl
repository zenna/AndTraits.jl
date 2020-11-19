export traits, Trait

"Returns the traits of an objec"
function traits end

"Meta data to attach to ω::Ω"
const Tags = NamedTuple

struct Trait{T} end

symtotrait(x::Symbol) = Trait{x}

@generated function traits(k::Tags{K, V}) where {K, V}
  traits_ = map(symtotrait, K)
  AndTrait{Union{traits_...}}()
end

@generated function traits(k::Type{Tags{K, V}}) where {K, V}
  traits_ = map(symtotrait, K)
  AndTrait{Union{traits_...}}()
end