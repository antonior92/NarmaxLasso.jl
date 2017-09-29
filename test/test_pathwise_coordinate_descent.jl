## Testing: Compare it GLMNet on toy problem
@testset "Compare with GLMNet" begin
    N = 100
    srand(1)
    y = collect(1:N) + randn(N)*10
    X = [1:N (1:N)+randn(N)*5 (1:N)+randn(N)*10 (1:N)+randn(N)*20]
    X = X .- mean(X, 1)
    y = y .- mean(y)
    norm_x = sqrt(N)*std(X, 1, corrected=false)
    std_y = std(y, corrected=false)
    yn = y./std_y
    Xn = X./norm_x

    # Test for a single value
    λ = 0.001
    path = GLMNet.glmnet(Xn, yn; lambda=[λ], intercept=false, standardize=false,
              tol=1e-20)
    β, _ = NarmaxLasso.pathwise_coordinate_optimization(Xn, yn, λ, tol=1e-20)
    @test vec(Matrix{Float64}(path.betas)) ≈ β atol=1e-5

    # Test for multiple value
    λ_list = collect(100:-1:1)*0.01
    path = GLMNet.glmnet(Xn, yn; lambda=λ_list, intercept=false,
              standardize=false, tol=1e-20)
    β, _ = NarmaxLasso.pathwise_coordinate_optimization(Xn, yn, λ_list, tol=1e-20)
    @test Matrix{Float64}(path.betas) ≈ β atol=1e-5
end

## Generate nonlinear System Inputs
function nonlinear_function(y, u, v)
    return ((0.8 - 0.5*exp(-y[1]^2))*y[1] - (0.3 + 0.9*exp(-y[1]^2))*y[2] + u[1]
            + 0.2*u[2] + 0.1*u[1]*u[2] + 0.1*v[1] + 0.3*v[2])
end

## Testing: Compare it GLMNet on dynamic example
@testset "Compare with GLMNet on Dynamic Data" begin
    # Generate input
    u = NarmaxLasso.generate_random_input(1000, 5);
    y = NarmaxLasso.simulate(u, nonlinear_function, [1, 2], [1, 2], [1, 2];
                             σv=0.1, σw=0.5);
    # Generate Regressor matrix
    X = NarmaxLasso.lag([u y], [collect(1:30),
                    collect(1:30)])
    N, p = size(X)
    # Normalize
    X = X .- mean(X, 1)
    y = y .- mean(y)
    norm_x = sqrt(N)*std(X, 1, corrected=false)
    std_y = std(y, corrected=false)
    y = y./std_y
    X = X./norm_x
    # Test single point
    λ = 1e-5
    path = GLMNet.glmnet(X, y, lambda=[λ], intercept=false,
                        standardize=false, tol=1e-20)
    β, λ= NarmaxLasso.pathwise_coordinate_optimization(X, y, λ, tol=1e-15)
    @test vec(Matrix{Float64}(path.betas)) ≈ β atol=1e-5
    # Test sequence of points
    λ = collect(100:-1:1)*0.00001
    path = GLMNet.glmnet(X, y, lambda=λ, intercept=false,
                         standardize=false, tol=1e-20)
    β, λ= NarmaxLasso.pathwise_coordinate_optimization(X, y, λ, tol=1e-15)
    @test Matrix{Float64}(path.betas) ≈ β atol=1e-5
end
