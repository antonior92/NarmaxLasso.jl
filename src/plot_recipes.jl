@recipe function plot(lasso::LassoResult)
    yguide --> "parameter"
    xguide --> "lambda"
    xflip --> true
    lab := hcat(name_regressors(lasso.mdl)...)
    (lasso.λ, lasso.β')
end
