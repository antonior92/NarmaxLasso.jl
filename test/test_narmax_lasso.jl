## Test ARX model
function arx_mdl(y, u)
    return (0.5*y[1] - 0.5*u[1])
end

@testset "Test on ARX model" begin
    yterms0 = [1]
    uterms0 = [1]
    u = NarmaxLasso.generate_random_input(100, 5)
    y = NarmaxLasso.simulate(u, arx_mdl, yterms0, uterms0;
                             σv=0)
    mdl = NarmaxLasso.generate_all(NarmaxLasso.NarmaxRegressors,
                                   NarmaxLasso.Monomial,
                                   2, 2, 0, 1)
    result = NarmaxLasso.narmax_lasso(y, u, mdl; nλ=5, λ_min_ratio=1e-6)

    @test result.β ≈ [0.0         -0.0398   0.0        0.1998   0.24836;
                      -1.552e-16  -0.4788  -0.49886  -0.4998  -0.499996;
                      0.0          0.0       0.0       -0.1996  -0.2484;
                      0.0          0.43622   0.49973   0.89964   0.99671] rtol=1e-4

    if NarmaxLasso.glmnet_loaded
        result_glmnet = NarmaxLasso.narmax_lasso(y, u, mdl;
            intercept=false, standardize=false, use_glmnet=true, nlambda=5)
        @test result_glmnet.β ≈ [0.0 -0.13385 -0.010741 0.0 0.0349759;
                                 0.0 -0.432755 -0.493341 -0.498908 -0.499592;
                                 0.0 0.0 0.0 0.0 -0.0340471;
                                 0.0 0.289839 0.481891 0.499722 0.569338] rtol=1e-4
    else
        @test_throws(ArgumentError,
         result_glmnet = NarmaxLasso.narmax_lasso(y, u, mdl; use_glmnet=true))
    end
end

## Test ARMAX model
function armax_mdl(y, u, v)
    return (0.5*y[1] - 0.5*u[1] + 0.5*v[1])
end

@testset "Test on ARMAX model" begin
    yterms0 = [1]
    uterms0 = [1]
    vterms0 = [1]
    u = NarmaxLasso.generate_random_input(1000, 5)
    y = NarmaxLasso.simulate(u, armax_mdl, yterms0, uterms0, vterms0;
                             σv=1.0, seed=1)
    mdl = NarmaxLasso.generate_all(NarmaxLasso.NarmaxRegressors,
                                   NarmaxLasso.Monomial,
                                   1, 1, 1, 1)
    result = NarmaxLasso.narmax_lasso(y, u, mdl; nλ=5)
    @test result.β ≈ [0.0  -0.204043  -0.457963  -0.4847    -0.487381;
                      0.0   0.555936   0.478094   0.469134   0.468238;
                      0.0   0.240684   0.514044   0.546466   0.549734] rtol=1e-3
end
