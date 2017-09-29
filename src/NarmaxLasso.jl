module NarmaxLasso

export # Auxiliar functions
       generate_random_input,
       simulate,
       # Lasso regressors
       NarmaxRegressors,
       generate_all,
       # Lasso estimation
       narmax_lasso,
       LassoResult

using RecipesBase
using Combinatorics
if isdir(Pkg.dir("GLMNet"))
    eval(Expr(:import, :GLMNet))
    const glmnet_loaded = true
else
    const glmnet_loaded = false
end

include("util.jl")
include("basis_functions.jl")
include("monomials.jl")
include("narmax_regressors.jl")
include("simulate.jl")
include("pathwise_coordinate_optimization.jl")
include("narmax_lasso.jl")
include("plot_recipes.jl")

end # module
