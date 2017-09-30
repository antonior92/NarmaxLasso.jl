## Example 2 from paper
# "Lasso Regularization Paths for NARMAX Models via Coordinate Descent"
# Antonio H. Ribeiro and Luis A. Aguirre
using NarmaxLasso
using Plots
using LaTeXStrings
plotlyjs()

## Signal generation
# Defining nonlinear system
function nonlinear_function(y, u, v)
    #return 0.5*y[1] + 0.2*u[1] + 0.1*v[1]
    return ((0.8 - 0.5*exp(-y[1]^2))*y[1] - (0.3 + 0.9*exp(-y[1]^2))*y[2] + u[1]
            + 0.2*u[2] + 0.1*u[1]*u[2] + 0.3*v[1] + 0.3*v[2])
end
yterms0 = [1, 2]
uterms0 = [1, 2]
vterms0 = [1, 2]

# Generate signals
u = generate_random_input(1000, 5)
y = simulate(u, nonlinear_function, yterms0, uterms0, vterms0;
             σv=0.5, seed=1)

## Model Estimation
# Generate all candidate terms
ny = 3
nu = 3
nv = 2
order = collect(1:2)
mdl = NarmaxLasso.generate_all(NarmaxLasso.NarmaxRegressors,
                                NarmaxLasso.Monomial,
                                ny, nu, nv, order)

# Lasso regression
result = NarmaxLasso.narmax_lasso(y, u, mdl; λ_min_ratio=1e-6)

# Plot result
p1 = plot(result, xscale=:log10, ylims=(-1.2, 1.2))

## Validation
# Generate signals
uv = generate_random_input(500, 5, seed=10)
yv = simulate(uv, nonlinear_function, yterms0, uterms0, vterms0;
                σv=0.5, seed=6)

# Compute Mean Absolute Erro
n = length(result.λ)
mae = Vector{Float64}(n)
for i = 1:n
    ysv = NarmaxLasso.simulate(uv, result.mdl, result.β[:, i])
    mae[i] = mean(abs(ysv-yv))
end
vline!(p1, [result.λ[indmin(mae)]], color=:black, line=:dash)

## Plot number of nonzero parameters
p2 = plot(result.λ, result.df, line=:steppost,
          xscale=:log10, lab="non-zero terms", xflip=true, legend=false,
          ylabel="Non-zero terms",
          xlabel="lambda", grid=false, lw=0.7,
          size=(550, 300))
vline!(p2, [result.λ[indmin(mae)]], color=:black, line=:dash)

## Mean Absolut Error
p3 = plot(result.λ, mae, xscale=:log10, lab="test set", ylims=(1, 1.3),
         legend=false, ylabel="MAE", xlabel="lambda",
         grid=false, lw=0.7, size=(550, 300), xflip=true)
vline!(p3, [result.λ[indmin(mae)]], color=:black, line=:dash)

plot(p1, p2, p3, layout=(3, 1))
