"""
    LassoResult

Result of lasso estimation for a grid of values of regularization
parameter. Contains:

| Atributes | Type               | Brief Description                                            |
|:--------- |:------------------ |:------------------------------------------------------------ |
| mdl       | `NarmaxRegressors` | Regressors                                                   |
| λ         | `Matrix{Float64}`  | Sequence of regularization parameters λ                      |
| β         | `Matrix{Float64}`  | Parameter vectors arranged columnwise, for the sequence of λ |
| df        | `Matrix{Int}`      | Number of nonzero terms for the sequence of λ                |
| time      | `Float64`          | Execution time                                               |
| total_iter| `Int`              | Total number of internal iterations                          |
"""
struct LassoResult
    mdl::NarmaxRegressors
    β::Matrix{Float64}
    λ::Vector{Float64}
    df::Vector{Int}
    time::Float64
    total_iter::Int
end

# Update noise terms
function update_noise_terms!(
        X::Vector{Vector{Float64}}, i::Int, N::Int, r::Vector{Float64},
        noise_terms_start::Int, noise_lags::Vector{Int})
    if i >= noise_terms_start
        lag!(X[i], r, noise_lags[i-noise_terms_start+1], N)
    end
end

# Update basis matrix
function update_basis_matrix!{T<:Basis}(
    X::Vector{Vector{Float64}}, i::Int, N::Int, r::Vector{Float64},
    noise_components_start::Int,
    noise_terms_start::Int,
    noise_lags::Vector{Int},
    basis::Vector{T},
    Y::Vector{Vector{Float64}},
    p::Int)
    if i >= noise_components_start
        evaluate!(X[i], Y, basis[i], N, p, update_noise_terms!,
                  (r, noise_terms_start, noise_lags))
    end
end

## Narmax Lasso function
"""
    narmax_lasso(y, u, mdl::NarmaxRegressors[; use_glmnet]) -> r::LassoResult

Given input and output signals `u` and `y`, and a structure `mdl` specifying
the regressors through a structure [`NarmaxRegressors`](@ref). Find the solution
of the lasso problem:
```math
\\min_\\beta ||\\mathbf{e}||^2 + \\lambda * \\sum_{i} |\\beta_i|
```
for a grid of values of the regularization parameter ``\\lambda``. Return
a [`LassoResult`](@ref) structure containing the obtained values. The option
`use_glmnet=true` changes the internal solver to GLMNet (only available
when no noise term is present).
"""
function narmax_lasso(y::Vector{Float64}, u::Vector{Float64},
                      mdl::NarmaxRegressors; use_glmnet=false,
                      kwargs...)
    # Lag matrix
    v = copy(y)
    Y = lag_matrix(mdl, y, u, v)
    Y_views, N, n = matrix2subviews(Y)
    # Generate regressor matrix
    X = regressor_matrix(mdl, y, u, v)
    # Pathwise coordinate descent
    tic()
    if use_glmnet
        if isempty(mdl.vterms) && glmnet_loaded
            path = GLMNet.glmnet(X, y, intercept=false,
                          standardize=false, tol=1e-8; kwargs...)
            β = Matrix{Float64}(path.betas)
            λ = path.lambda
            df_matrix = [sum(β[:, i].==0) for i = 1:length(λ)]
            total_iter = path.npasses
        elseif ~glmnet_loaded
            throw(ArgumentError(string("GlMNet not installed. Run:\n",
                                "\tjulia> Pkg.add(\"GLMNet\")\n",
                                "\tjulia> Pkg.build(\"GLMNet\")")))
        else
            throw(ArgumentError(string("GLMNet can only be used when there ",
                                 "is no noise terms present")))
        end
    else
        β, λ, df_matrix, total_iter = pathwise_coordinate_optimization(
                X, y, update_basis_matrix!,
                (mdl.noise_components_starts, mdl.noise_terms_starts, mdl.vterms,
                 mdl.basis, Y_views, n); kwargs...)
    end
    time = toq()
    return LassoResult(mdl, β, λ, df_matrix,
                       time, total_iter)
end
