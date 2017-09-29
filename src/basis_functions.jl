## Basis
abstract type Basis end

# evaluate : Matrix -> vector
function evaluate(X::Matrix{Float64}, basis::Basis)
    X_views, N, p = matrix2subviews(X)
    y = Vector{Float64}(N)
    evaluate!(y, X_views, basis, N, p)
    return y
end

# evaluate : Matrix -> Matrix
function evaluate{T<:Basis}(X::Matrix{Float64}, basis::Vector{T})
    X_views, N, p = matrix2subviews(X)
    q = length(basis)
    Y = Matrix{Float64}(N, q)
    Y_views, _, _ = matrix2subviews(Y)
    aux = Vector{Float64}(p)
    evaluate!(Y_views, X_views, basis, N, p)
    Y = subviews2matrix(Y_views, N, q)
    return Y
end

# evaluate! : Matrix -> Matrix (With Overide)
function evaluate!{T <: Basis}(
        Y::Vector{Vector{Float64}}, X::Vector{Vector{Float64}},
        basis::Vector{T}, N::Int, p::Int)
    for (i, y) in enumerate(Y)
        evaluate!(y, X, basis[i], N, p)
    end
end

# Print basis
function Base.show(io::IO, basis::Basis)
    names = [string("x_", i) for i=1:basis.n]
    str = function_display(basis, names)
    print(io, str)
end

# Separate basis terms containing certain terms
function detach_terms{T<:Basis}(basis::Vector{T},
                      list_of_inputs::BitVector)
    n_basis = length(basis)
    basis_containing_inputs = trues(n_basis)
    for (i, m) in enumerate(basis)
        if contains_inputs(basis[i], list_of_inputs)
            basis_containing_inputs[i] = false
        end
    end
    return (basis[basis_containing_inputs],
            basis[.~basis_containing_inputs])
end
