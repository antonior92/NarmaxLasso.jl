## Testing Evaluate Monomial
@testset "Test evaluate monomials" begin
    # Test single point
    x = collect(1.0:3.0)
    m = NarmaxLasso.Monomial([2, 2, 2])
    @test NarmaxLasso.evaluate(x, m) ≈ 36.0
    # Test vector of points
    x = [1.0 2.0 3.0; 1.0 2.0 3.0; 1.0 2.0 3.0]
    m = NarmaxLasso.Monomial([2, 2, 2])
    @test NarmaxLasso.evaluate(x, m) ≈ [36.0, 36.0, 36.0]
    # Test vector of monomials
    m = [NarmaxLasso.Monomial([2, 2, 2]), NarmaxLasso.Monomial([2, 2, 2])]
    @test NarmaxLasso.evaluate(x, m) ≈ 36*ones(3, 2)
end

## Test print monomials
@testset "Test print monomials list" begin
    @test string(NarmaxLasso.Monomial([1, 0])) == "x_1"
    @test string(NarmaxLasso.Monomial([1, 2])) == "x_1 * x_2^2"
    @test string(NarmaxLasso.Monomial([1, 0, 3, 0])) == "x_1 * x_3^3"
    @test string(NarmaxLasso.Monomial([1, 0, 3, 1])) == "x_1 * x_3^3 * x_4"
end

## Test generate monomials
@testset "Test generate monomials" begin
    # Test first order monomials
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 3, 1)
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 0, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 1, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 0, 1]))
    @test ~contains(isequal, l, NarmaxLasso.Monomial([0, 1, 1]))
    # Test second order monomials
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 3, 2)
    @test contains(isequal, l, NarmaxLasso.Monomial([2, 0, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 1, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 2, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 1, 1]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 0, 2]))
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 0, 1]))
    @test ~contains(isequal, l, NarmaxLasso.Monomial([0, 0, 1]))
    # Test maximum order 2
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 3, 1:2)
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 0, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 1, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 0, 1]))
    @test contains(isequal, l, NarmaxLasso.Monomial([2, 0, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 1, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 2, 0]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 1, 1]))
    @test contains(isequal, l, NarmaxLasso.Monomial([0, 0, 2]))
    @test contains(isequal, l, NarmaxLasso.Monomial([1, 0, 1]))
end

## Test split monomial list
@testset "Test detach terms" begin
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 3, 1:2)
    l1, l2 = NarmaxLasso.detach_terms(l, BitVector([false, true, true]))
    @test length(l2) == 2
    @test length(l1) == 7
    @test contains(isequal, l2, NarmaxLasso.Monomial([1, 0, 0]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([0, 1, 0]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([0, 0, 1]))
    @test contains(isequal, l2, NarmaxLasso.Monomial([2, 0, 0]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([1, 1, 0]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([0, 2, 0]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([0, 1, 1]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([0, 0, 2]))
    @test contains(isequal, l1, NarmaxLasso.Monomial([1, 0, 1]))
end
