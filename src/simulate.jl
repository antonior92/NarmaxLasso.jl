## Simulate general function
"""
    simulate(u, f, yterms, uterms[, vterms][; σv=0.0, σw=0.0, seed=1] ) -> y

Be `u` the input vector applied to a discrete system and `y` the
correspondent output vector for a system described
by the difference equations:

```math
y^*[k] = f([ y^*[k-\\text{yterms}[1]], y^*[k-\\text{yterms}[2]],..., y^*[k-\\text{yterms}[\\text{end}]] ],\\\\
         [ u[k-\\text{uterms}[1]], u[k-\\text{uterms}[2]],..., u[k-\\text{uterms}[\\text{end}]] ],\\\\
         [ v[k-\\text{vterms}[1]], v[k-\\text{vterms}[2]],..., v[k-\\text{vterms}[\\text{end}]] ]) + v[k]\\\\
```
and
```math
y[k] = y^*[k] + w[k]
```

where `yterms` , `uterms` and `vterms` are vector containing dependencies
on previous terms of ``y``, ``u`` and ``v``;
``v[k]`` and ``w[k]`` are random variables
with zero mean and standard deviation `σv` and `σw`, respectively. The random
number generator is initialized with `seed`, during the generation.
Furthermore, `f` is the function that describe the system dynamics:
`f(yvec, uvec, vvec) -> y`.
"""
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
"""
    simulate(u, mdl::NarmaxRegressors, β) -> y

Be `u` the input vector applied to a discrete system and `y` the
correspondent output vector for a system described
by a basis expansion model `mdl` and the parameter vector `β`.
"""
function simulate(u::Vector{Float64}, mdl::NarmaxRegressors,
                  β::Vector{Float64})
    simulate(u, one_step_ahead, mdl.yterms, mdl.uterms, mdl.vterms,
             mdl.basis, β)
end
