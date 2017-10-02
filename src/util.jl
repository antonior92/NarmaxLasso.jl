function identity!(args...); end;

"""
    generate_random_input(n [, nrep=5][; σ=1, seed=1]) -> u

Generate a vector ``u`` containing a random signal. The values are draw from a
zero-mean Gaussian distribution with standard deviation `σ` and held for `nrep`
samples. The random number generator is initialized with `seed`, during the
generation.
"""
function generate_random_input(n, nrep=5; σ=1, seed=1)
    srand(seed)
    u = σ*randn(Int(n//nrep));
    return repeat(u; inner=(nrep));
end

## Lag function
function lag!(result::Vector{Float64},
              x::Vector{Float64}, n::Int, N::Int)
    for i = 1:n
        @inbounds result[i] = x[1]
    end
    for i = (n+1):N
        @inbounds result[i] = x[i-n]
    end
end

function lag(x::Vector{Float64}, n::Int)
    N = length(x)
    result = copy(x)
    lag!(result, x, n, N)
    return result
end

function lag(x::Vector{Float64}, list_n::Vector{Int})
    hcat((lag(x, n) for n in list_n)...)
end

function lag(x::Matrix{Float64}, llist_n::Vector{Vector{Int}})
    hcat((lag(x[:, i], list_n) for (i, list_n) in enumerate(llist_n))...)
end

## matrix2subviews
function matrix2subviews{T<:Any}(X::Matrix{T})
    N, p = size(X)
    X_views = Vector{Vector{T}}(p)
    for i = 1:p
        X_views[i] = X[:, i]
    end
    return X_views, N, p
end

function subviews2matrix{T<:Any}(X_views::Vector{Vector{T}}, N, p)
    X = Matrix{T}(N, p)
    for i = 1:p
        for j = 1:N
            X[j, i] = X_views[i][j]
        end
    end
    return X
end

# Convert Compressed Predictor Matrix to matrix
if glmnet_loaded
    function Base.convert(::Type{Matrix{Float64}},
                          X::GLMNet.CompressedPredictorMatrix)
        mat = zeros(X.ni, length(X.nin))
        for b = 1:size(mat, 2), i = 1:X.nin[b]
            mat[X.ia[i], b] = X.ca[i, b]
        end
        return mat
    end
end
