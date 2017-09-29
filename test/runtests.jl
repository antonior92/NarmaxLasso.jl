if isdir(Pkg.dir("GLMNet"))
    eval(Expr(:import, :GLMNet))
    const glmnet_loaded = true
else
    const glmnet_loaded = false
end
import NarmaxLasso
using Base.Test


## Test utility functions
@testset "Test utility functions" begin
    include("test_util.jl")
end

## Test basis functions
@testset "Test monomials" begin
    include("test_monomials.jl")
end

## Test narmax generated regressors
@testset "Test narmax generated regressors" begin
    include("test_monomials.jl")
end

## Test dynamic system simulation
@testset "Test simulate" begin
    include("test_simulate.jl")
end

## Test pathwise coordinate descent
@testset "Test pathwise coordinate descent algorithm" begin
    if glmnet_loaded
        include("test_pathwise_coordinate_descent.jl")
    end
end

## Test Narmax Lasso estimation
@testset "Test Narmax Lasso estimation" begin
    include("test_narmax_lasso.jl")
end
