using Documenter, NarmaxLasso, Plots
println("Generating plots")

plotsDir = (pwd()[end-3:end] == "docs") ? "src/plots" : "docs/src/plots"
if ~isdir(plotsDir)
    mkdir(plotsDir)
end
Plots.pyplot()

## ARMAX example
u = generate_random_input(2000, 5);
armax_mdl(y, u, v) = 0.5*y[1] - 0.5*u[1] + 0.5*v[1];
yterms0 = [1]; uterms0 = [1]; vterms0 = [1];
y = simulate(u, armax_mdl, yterms0, uterms0, vterms0;
             σv=0.3);
ny = 1; nu = 1; nv = 1; order = 1;
mdl = generate_all(NarmaxRegressors, Monomial, ny, nu, nv, order);
result = narmax_lasso(y, u, mdl);
Plots.plot(result)
Plots.savefig(plotsDir*"/ARMAXPaths.png")


## NARMAX example
u = generate_random_input(2000, 5);
narmax_mdl(y, u, v) = 0.1*y[1]^2 - 0.5*u[1] + 0.5*v[1];
yterms0 = [1, 2]; uterms0 = [1]; vterms0 = [1];
y = simulate(u, narmax_mdl, yterms0, uterms0, vterms0;
             σv=0.3);
ny = 2; nu = 1; nv = 1; order = 1:2;
mdl = generate_all(NarmaxRegressors, Monomial, ny, nu, nv, order);
result = narmax_lasso(y, u, mdl);
Plots.plot(result, xscale=:log10)
Plots.savefig(plotsDir*"/NARMAXPaths.png")
