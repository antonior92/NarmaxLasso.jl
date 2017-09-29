## Narmax regressors
struct NarmaxRegressors{T<:Basis}
    basis::Vector{T}
    noise_components_starts::Int
    yterms::Vector{Int}
    n_yterms::Int
    uterms::Vector{Int}
    n_uterms::Int
    vterms::Vector{Int}
    n_vterms::Int
    noise_terms_starts::Int
end

function NarmaxRegressors{T<:Basis}(basis::Vector{T},
                                    yterms::Vector{Int},
                                    uterms::Vector{Int},
                                    vterms::Vector{Int}=Vector{Int}(0))
    # Get dimensions
    n_yterms = length(yterms)
    n_uterms = length(uterms)
    n_vterms = length(vterms)
    # Order terms acording to the presence of noise terms
    m1, m2 = detach_terms(basis, [falses(n_uterms+n_yterms); trues(n_vterms)])
    basis = [m2; m1]
    noise_components_starts = length(m2) + 1
    noise_terms_start = n_uterms+n_yterms+1
    NarmaxRegressors(basis, noise_components_starts,
                     yterms, n_yterms, uterms, n_uterms,
                     vterms, n_vterms, noise_terms_start)
end

## Generate lagged terms matrix
function lag_matrix(reg::NarmaxRegressors,
                    y::Vector{Float64},
                    u::Vector{Float64},
                    v::Vector{Float64})
    # Construct signals
    signals = isempty(v) ? [y u] : [y u v]
    # Construct time lags
    if isempty(reg.vterms)
        time_lags = [reg.yterms, reg.uterms]
    else
        time_lags = [reg.yterms, reg.uterms, reg.vterms]
    end
    # Generate lag matrix
    lag(signals, time_lags)
end

## Generate regressors matrix
function regressor_matrix(reg::NarmaxRegressors,
                          y::Vector{Float64},
                          u::Vector{Float64},
                          v::Vector{Float64})
    # Construct signals
    M = lag_matrix(reg, y, u, v)
    evaluate(M, reg.basis)
end

## Generate all terms
function generate_all{T<:Basis}(::Type{NarmaxRegressors}, ::Type{T},
                                ny::Int, nu::Int, nv::Int, args...; kwargs...)
    basis = generate_all(T, ny+nu+nv, args...; kwargs...)
    return NarmaxRegressors(basis, collect(1:ny), collect(1:nu), collect(1:nv))
end

## Print regressors
function name_regressors(reg::NarmaxRegressors)
    ynames = [string("y[k-", k, "]") for k in reg.yterms]
    unames = [string("u[k-", k, "]") for k in reg.uterms]
    vnames = [string("v[k-", k, "]") for k in reg.vterms]
    names = [ynames; unames; vnames]
    n = length(reg.basis)
    str = Vector{String}(n)
    for i = 1:n
        str[i] = function_display(reg.basis[i], names)
    end
    return str
end

function Base.show(io::IO, reg::NarmaxRegressors)
    str = name_regressors(reg)
    n = length(str)
    for i = 1:n
        print(io, string(str[i], "\n"))
    end
end
