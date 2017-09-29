## Test nonlinear function
function nonlinear_function(y, u, v)
    return ((0.8 - 0.5*exp(-y[1]^2))*y[1] - (0.3 + 0.9*exp(-y[1]^2))*y[2] + u[1]
            + 0.2*u[2] + 0.1*u[1]*u[2] + 0.1*v[1] + 0.3*v[2])
end

@testset "Test simulation for arbitrary nonlinear function" begin
    u = NarmaxLasso.generate_random_input(10, 5)
    y = NarmaxLasso.simulate(u, nonlinear_function, [1, 2], [1, 2], [1, 2], σv=0.1)
    @test y ≈ [0.0, 0.0, 0.318563, 0.480975, 0.134545, -0.139843, 0.458256,
                   0.603922, 0.422271, -0.0208464] rtol=1e-2
        @test length(y) == length(u)
end

## Test one step ahead
m1 = NarmaxLasso.Monomial([1, 0, 0])
m2 = NarmaxLasso.Monomial([0, 0, 1])
m3 = NarmaxLasso.Monomial([0, 2, 0])

@testset "Test one-step-ahead" begin
    @test NarmaxLasso.one_step_ahead([1.0], [2.0], [3.0],
                                     [m1, m2, m3],
                                     [1.0, 2.0, 3.0]) ≈ 19.0
    @test NarmaxLasso.one_step_ahead([1.0], [2.0, 3.0],
                                     [m1, m2, m3],
                                     [1.0, 2.0, 3.0]) ≈ 19.0
end

# simulate
@testset "Test simulate" begin
    mdl1 = NarmaxLasso.NarmaxRegressors([m1, m2, m3], [1], [1], [1])
    mdl2 = NarmaxLasso.NarmaxRegressors([m1, m2, m3], [1], [1, 2])

    u = NarmaxLasso.generate_random_input(20, 20)
    y = NarmaxLasso.simulate(u, mdl1, [0.5, 1, 0])
    @test (1-0.5)*y[end]/(u[end]^2) ≈ 1.0 rtol=1e-2

    y = NarmaxLasso.simulate(u, mdl2, [0.5, 1, 0.2])
    @test (1-0.5)*y[end]/(0.2*u[end]^2+u[end]) ≈ 1.0 rtol=1e-2
end
