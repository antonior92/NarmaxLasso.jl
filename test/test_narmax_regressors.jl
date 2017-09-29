## Test NarmaxRegressors constructor
@testset "Test NarmaxRegressors constructor" begin
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 4, 1:2)
    yterms = [1]
    uterms = [1]
    vterms = [1, 2]
    reg = NarmaxLasso.NarmaxRegressors(l, yterms, uterms, vterms)
    @test reg.n_vterms == 2
    @test reg.n_yterms == 1
    @test reg.n_uterms == 1
    for i = 1:(reg.noise_components_starts-1)
        @test all(reg.basis[i].exponents[3:4] .== 0)
    end
    for i = (reg.noise_components_starts):length(reg.basis)
        @test any(reg.basis[i].exponents[3:4] .> 0)
    end
end

## Test generate lag matrix
@testset "Test generate lag matrix" begin
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 4, 1:2)
    yterms = [1]
    uterms = [1]
    vterms = [1, 2]
    reg = NarmaxLasso.NarmaxRegressors(l, yterms, uterms, vterms)
    y = [1.0, 2.0, 3.0, 4.0]
    u = [10.0, 20.0, 30.0, 40.0]
    v = [100.0, 200.0, 300.0, 400.0]
    M = NarmaxLasso.lag_matrix(reg, y, u, v)
    @test M ≈ [1.0  10.0  100.0  100.0;
               1.0  10.0  100.0  100.0;
               2.0  20.0  200.0  100.0;
               3.0  30.0  300.0  200.0]
end

## Test generate regressor matrix
@testset "Test generate regressor matrix" begin
    l = NarmaxLasso.generate_all(NarmaxLasso.Monomial, 3, 1)
    yterms = [1]
    uterms = [1]
    vterms = [1]
    reg = NarmaxLasso.NarmaxRegressors(l, yterms, uterms, vterms)
    y = [1.0, 2.0, 3.0, 4.0]
    u = [10.0, 20.0, 30.0, 40.0]
    v = [100.0, 200.0, 300.0, 400.0]
    M = NarmaxLasso.lag_matrix(reg, y, u, v)
    @test M ≈ [1.0  10.0  100.0;
               1.0  10.0  100.0;
               2.0  20.0  200.0;
               3.0  30.0  300.0]
end

## Test generate all monomial terms
@testset "Test generate all monomial terms" begin
    reg = NarmaxLasso.generate_all(NarmaxLasso.NarmaxRegressors,
                                NarmaxLasso.Monomial, 2, 2, 2, 1:2)
    @test length(reg.basis) == 27
    reg = NarmaxLasso.generate_all(NarmaxLasso.NarmaxRegressors,
                                NarmaxLasso.Monomial, 2, 2, 2, 1:3)
    @test length(reg.basis) == 83
end
