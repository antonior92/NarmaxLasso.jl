## Simulate general function
function simulate(u::Vector{Float64}, f::Function,
                  yterms::Vector{Int}, uterms::Vector{Int},
                  vterms::Vector{Int}=Vector{Int}(0), args...;
                  σv=0.0, σw=0.0, seed=1, kwargs...)
    srand(seed)
    N = length(u)
    v = σv*randn(N)
    w = σw*randn(N)
    y = zeros(N)
    ny = maximum(yterms)
    nu = maximum(uterms)
    if isempty(vterms)
        nv = 0
    else
        nv = maximum(vterms)
    end
    for k = max(ny, nu, nv)+1:(N)
        yvec = y[k.-yterms]
        uvec = u[k.-uterms]
        if isempty(vterms)
            y[k] = f(yvec, uvec, args...; kwargs...) + v[k]
        else
            vvec = v[k.-yterms]
            y[k] = f(yvec, uvec, vvec, args...; kwargs...) + v[k]
        end
    end
    return y + w
end

## One step ahead evaluation
function one_step_ahead{T<:Basis}(yvec::Vector{Float64},
                                  uvec::Vector{Float64},
                                  vvec::Vector{Float64},
                                  basis::Vector{T},
                                  β::Vector{Float64})
    input = [yvec; uvec; vvec]
    output = 0
    for i = 1:length(basis)
        output += β[i]*evaluate(input, basis[i])
    end
    return output
end

function one_step_ahead{T<:Basis}(yvec::Vector{Float64},
                                  uvec::Vector{Float64},
                                  basis::Vector{T},
                                  β::Vector{Float64})
    input = [yvec; uvec]
    output = 0
    for i = 1:length(basis)
        output += β[i]*evaluate(input, basis[i])
    end
    return output
end

## Simulate Narmax Regressors
function simulate(u::Vector{Float64}, mdl::NarmaxRegressors,
                  β::Vector{Float64})
    simulate(u, one_step_ahead, mdl.yterms, mdl.uterms, mdl.vterms,
             mdl.basis, β)
end
