## Test lag function
@testset "Test lag" begin
    x = collect(1.0:5.0)
    y = collect(10.0:10.0:50.0)

    @test NarmaxLasso.lag(x, 2) == [1, 1, 1, 2, 3]
    @test NarmaxLasso.lag(y, 1) == [10, 10, 20, 30, 40]
    @test NarmaxLasso.lag(x, [1, 2]) == [1 1 2 3 4
                             1 1 1 2 3]'
    @test NarmaxLasso.lag([x y], [[1, 2], [2]]) == [1 1 2 3 4
                                        1 1 1 2 3
                                        10 10 10 20 30]'
end

## Test matrix2subviews
@testset "Test matrix2subviews" begin
    x, N, p = NarmaxLasso.matrix2subviews(ones(10, 10))
    @test x[1] == ones(10)
    @test length(x) == 10
end

## Test subviews2matrix
@testset "Test subviews2matrix" begin
    x, N, p = NarmaxLasso.matrix2subviews(ones(10, 10))
    X = NarmaxLasso.subviews2matrix(x, N, p)
    @test X == ones(10, 10)
end

## Test random input generation
@testset "Test random input generation" begin
    u = NarmaxLasso.generate_random_input(100, 5)
    @test length(u) == 100
    @test u[1] == u[2] == u[3] == u[4] == u[5]
    @test u[6] == u[7] == u[8] == u[9] == u[10]
    @test u[1] != u[6]
end
