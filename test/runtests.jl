import NarmaxLasso
using Base.Test
using GLMNet

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
    include("test_pathwise_coordinate_descent.jl")
end

## Test Narmax Lasso estimation
@testset "Test Narmax Lasso estimation" begin
    include("test_narmax_lasso.jl")
end
