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
        if isempty(mdl.vterms)
            path = glmnet(X, y, intercept=false,
                          standardize=false, tol=1e-8; kwargs...)
            β = Matrix{Float64}(path.betas)
            λ = path.lambda
            df_matrix = [sum(β[:, i].==0) for i = 1:length(λ)]
            total_iter = path.npasses
        else
            throw(ArgumentError("GLMNet can only be used when there ",
                                 "is no noise terms present"))
        end
    else
        β, λ, df_matrix, total_iter = pathwise_coordinate_optimization(
                X, y, update_basis_matrix!,
                (mdl.noise_components_starts, mdl.noise_terms_starts, mdl.vterms,
                 mdl.basis, Y_views, n); kwargs...)
    end
    time = toc()
    return LassoResult(mdl, β, λ, df_matrix,
                       time, total_iter)
end
