## Monomial
struct Monomial <: Basis
    exponents::Vector{Int}
    n::Int
end

# Constructor
function Monomial(exponents::Vector{Int})
    n = length(exponents)
    Monomial(exponents, n)
end


# evaluate: Vector -> scalar
function evaluate(X::Vector{Float64}, monomial::Monomial)
    y = 1.0
    @inbounds @fastmath @simd for i = 1:monomial.n
        y *= X[i]^monomial.exponents[i]
    end
    return y
end

# evaluate!: Vector of Vectors -> Vector
function evaluate!(
        Y::Vector{Float64}, X::Vector{Vector{Float64}}, monomial::Monomial,
        N::Int, p::Int, update!::Function=identity!, args::Tuple=())

    @inbounds for i = 1:N
        Y[i] = 1.0
    end
    @inbounds for i = 1:p
        if monomial.exponents[i] == 1
            update!(X, i, N, args...)
            x = X[i]
            @simd for j = 1:N
                Y[j] *= x[j]
            end
        elseif monomial.exponents[i] > 0
            update!(X, i, N, args...)
            x = X[i]
            @simd for j = 1:N
                Y[j] *= x[j]^monomial.exponents[i]
            end
        end
    end
end

## Generate Monomials
function generate_all(::Type{Monomial}, n::Int, order::Int;)
    n_monomials = binomial(n+order-1, n-1)
    monomials = Vector{Monomial}(n_monomials)
    for (i, c) in enumerate(combinations(1:(n+order-1), n-1))
        combin = [0; c-collect(1:(n-1)); order]
        monomials[i] = Monomial(diff(combin))
    end
    return monomials
end

function generate_all(::Type{Monomial}, n::Int, order_list; kwargs...)
    vcat([generate_all(Monomial, n, order; kwargs...) for order in order_list]...)
end


# Print Monomial
function function_display(monomial::Monomial, names::Vector{String})
    str =""
    first_term = true
    for i = 1:monomial.n
        exp = monomial.exponents[i]
        if exp == 0
            continue
        end
        if ~first_term
            str = string(str, " * ")
        end
        first_term = false
        if exp == 1
            str = string(str, names[i])
        else
            str = string(str, names[i], "^", exp)
        end
    end
    return str
end

# Function Compare Monomials
Base.isequal(x::Monomial, y::Monomial) = x.exponents == y.exponents

# Check if contains input
function contains_inputs(m::Monomial, list_of_inputs::BitVector)
    return all(m.exponents[list_of_inputs] .== 0)
end
