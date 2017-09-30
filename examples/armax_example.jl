## Example 1 from paper
# "Lasso Regularization Paths for NARMAX Models via Coordinate Descent"
# Antonio H. Ribeiro and Luis A. Aguirre
using NarmaxLasso
using Plots
plotlyjs()

## Signal generation
# Defining nonlinear system
function armax_mdl(y, u, v)
    return (0.5*y[1] - 0.5*u[1] + 0.5*v[1] )
end
yterms0 = [1]
uterms0 = [1]
vterms0 = [1]

# Generate signals
u = generate_random_input(2000, 5)
y = simulate(u, armax_mdl, yterms0, uterms0, vterms0;
             σv=0.3, seed=1)

## Model Estimation
# Generate all candidate terms
ny = 10
nu = 10
nv = 10
mdl = generate_all(NarmaxLasso.NarmaxRegressors,
                                NarmaxLasso.Monomial,
                                ny, nu, nv, 1)

# Lasso regression
result = narmax_lasso(y, u, mdl; λ_min_ratio=1e-6)

# Plot result
plot(result, xscale=:log10)

## Validation
# Generate signals
uv = generate_random_input(1000, 5, seed=14)
yv = simulate(uv, armax_mdl, yterms0, uterms0, vterms0;
                σv=0.3, seed=11)

# Compute Mean Absolute Erro
n = length(result.λ)
mae = Vector{Float64}(n)
for i = 1:n
    ysv = simulate(uv, result.mdl, result.β[:, i])
    mae[i] = mean(abs(ysv-yv))
end
vline!([result.λ[indmin(mae)]], color=:black, line=:dash)
