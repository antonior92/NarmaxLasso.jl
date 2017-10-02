var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#NarmaxLasso-1",
    "page": "Home",
    "title": "NarmaxLasso",
    "category": "section",
    "text": "Algorithms for Lasso estimation of NARMAX models."
},

{
    "location": "index.html#Manual-Outline-1",
    "page": "Home",
    "title": "Manual Outline",
    "category": "section",
    "text": "This package provides methods for computing the parameters of NARMAX (Nonlinear autoregressive moving average with exogenous inputs) models subject to L1 penalty using pathwise coordinate optimization algorithm.Pages = [\n    \"installation.md\",\n    \"guide.md\",\n    \"library.md\"\n]\nDepth = 2"
},

{
    "location": "installation.html#",
    "page": "Installation",
    "title": "Installation",
    "category": "page",
    "text": ""
},

{
    "location": "installation.html#Installation-1",
    "page": "Installation",
    "title": "Installation",
    "category": "section",
    "text": "Within Julia, use the package manager:julia> Pkg.clone(\"https://github.com/antonior92/NarmaxLasso.jl\")The package installation can be tested using the command:julia> Pkg.test(\"NarmaxLasso\")"
},

{
    "location": "guide.html#",
    "page": "Guide",
    "title": "Guide",
    "category": "page",
    "text": "DocTestSetup = quote\n    using NarmaxLasso\n    # Generate input\n    u = generate_random_input(2000, 5);\n    # Defining nonlinear system\n    armax_mdl(y, u, v) = 0.5*y[1] - 0.5*u[1] + 0.5*v[1];\n    yterms0 = [1]; uterms0 = [1]; vterms0 = [1];\n    # Generate Output\n    y = simulate(u, armax_mdl, yterms0, uterms0, vterms0;\n                 σv=0.3);         \nend"
},

{
    "location": "guide.html#Package-Guide-1",
    "page": "Guide",
    "title": "Package Guide",
    "category": "section",
    "text": "This package allows the estimation of parameters of discrete dynamic models from observed data."
},

{
    "location": "guide.html#Linear-Model-1",
    "page": "Guide",
    "title": "Linear Model",
    "category": "section",
    "text": "Consider vectors of observed inputs and outputs: u and y. Assume, for instance, we want to fit the following model to the observed data:yk = beta_1 yk-1 + beta_2 uk-1 + beta_3 vk-1where the parameters beta_1, beta_2 and beta_3 are unknown. The noise term vk-1 is included to model the random effects that affects the observation.The estimation can be done in two steps. The first step consists of generating the regressors to the problem, which can be done using the command generate_all by the following command sequence:julia> ny = 1; nu = 1; nv = 1; order = 1;\njulia> mdl = generate_all(NarmaxRegressors, Monomial, ny, nu, nv, order)\nu[k-1]\ny[k-1]\nv[k-1]Next the command narmax_lasso can be used to solve, for a grid of values of lambda, the following minimization problem:min_beta mathbfe^2 + lambda * sum_i=1^3 beta_iwhere mathbfe is the error between the model prediction and the observed values, subject to an L_1-norm penalty. The above minimization problem can be solved using the following command:julia> result = narmax_lasso(y, u, mdl);The output can be visualized using:julia> using Plots\njulia> plot(result)A possible output would be:(Image: )The value of λ may be chosen by testing the models on a validation set."
},

{
    "location": "guide.html#Polynomial-Model-1",
    "page": "Guide",
    "title": "Polynomial Model",
    "category": "section",
    "text": "Now assume that the following polynomial model:  yk = sum_ibeta_i left(yk-q_i right)^l_i left(uk-t_i right)^r_i\n  left(ek-w_i right)^s_iis to be adjusted to a data set. For which the monomials included as regressors are all possible monomials for which: 1le q_i le n_y; 1 le t_i le n_u; 1 le w_i le n_e; and, l_i + r_i + s_i le textorder.All possible monomials can be generated using the command generate_all. For n_y=2, n_u=1, n_v=1 and textorder=2 the generated terms are:julia> ny = 2; nu = 1; nv = 1; order = 1:2;\njulia> mdl = generate_all(NarmaxRegressors, Monomial, ny, nu, nv, order)\nu[k-1]\ny[k-2]\ny[k-1]\nu[k-1]^2\ny[k-2] * u[k-1]\ny[k-2]^2\ny[k-1] * u[k-1]\ny[k-1] * y[k-2]\ny[k-1]^2\nv[k-1]\nv[k-1]^2\nu[k-1] * v[k-1]\ny[k-2] * v[k-1]\ny[k-1] * v[k-1]Again the command narmax_lasso can be used to solve the lasso regression problem  for a grid of values of lambda:julia> result = narmax_lasso(y, u, mdl);The output can be visualized (in logscale) using:julia> using Plots\njulia> plot(result, xscale=:log10)A possible output would be:(Image: )Again, the value of λ may be chosen by testing the models on a validation set."
},

{
    "location": "library.html#",
    "page": "Library",
    "title": "Library",
    "category": "page",
    "text": ""
},

{
    "location": "library.html#Library-1",
    "page": "Library",
    "title": "Library",
    "category": "section",
    "text": ""
},

{
    "location": "library.html#NarmaxLasso.simulate",
    "page": "Library",
    "title": "NarmaxLasso.simulate",
    "category": "Function",
    "text": "simulate(u, f, yterms, uterms[, vterms][; σv=0.0, σw=0.0, seed=1] ) -> y\n\nBe u the input vector applied to a discrete system and y the correspondent output vector for a system described by the difference equations:\n\ny^*k = f( y^*k-textyterms1 y^*k-textyterms2 y^*k-textytermstextend \n          uk-textuterms1 uk-textuterms2 uk-textutermstextend \n          vk-textvterms1 vk-textvterms2 vk-textvtermstextend ) + vk\n\nand\n\nyk = y^*k + wk\n\nwhere yterms , uterms and vterms are vector containing dependencies on previous terms of y, u and v; vk and wk are random variables with zero mean and standard deviation σv and σw, respectively. The random number generator is initialized with seed, during the generation. Furthermore, f is the function that describe the system dynamics: f(yvec, uvec, vvec) -> y.\n\n\n\nsimulate(u, mdl::NarmaxRegressors, β) -> y\n\nBe u the input vector applied to a discrete system and y the correspondent output vector for a system described by a basis expansion model mdl and the parameter vector β.\n\n\n\n"
},

{
    "location": "library.html#NarmaxLasso.generate_random_input",
    "page": "Library",
    "title": "NarmaxLasso.generate_random_input",
    "category": "Function",
    "text": "generate_random_input(n [, nrep=5][; σ=1, seed=1]) -> u\n\nGenerate a vector u containing a random signal. The values are draw from a zero-mean Gaussian distribution with standard deviation σ and held for nrep samples. The random number generator is initialized with seed, during the generation.\n\n\n\n"
},

{
    "location": "library.html#Auxiliar-Functions-1",
    "page": "Library",
    "title": "Auxiliar Functions",
    "category": "section",
    "text": "simulate\ngenerate_random_input"
},

{
    "location": "library.html#NarmaxLasso.Basis",
    "page": "Library",
    "title": "NarmaxLasso.Basis",
    "category": "Type",
    "text": "Basis\n\nA basis function is an element of a particular basis for a function space. Every continuous function in the function space can be represented as a linear combination of basis functions:\n\nf(x_1 cdots x_n) = sum_i beta_itextbasis_i(x_1 cdots x_n)\n\nSo far the only implemented basis is Monomial.\n\n\n\n"
},

{
    "location": "library.html#NarmaxLasso.Monomial",
    "page": "Library",
    "title": "NarmaxLasso.Monomial",
    "category": "Type",
    "text": "Monomial(exponents)\n\nA Monomial function is a product of powers of variables with nonnegative integer exponents.\n\nx_1^p_1 * x_2^p_2 *cdots * x_n^p_n\n\nThe Monomial is defined using a vector of integers exponents. This vector contains the correspondent exponents p for all the inputs from 1 to n.\n\n\n\n"
},

{
    "location": "library.html#Basis-Expansion-1",
    "page": "Library",
    "title": "Basis Expansion",
    "category": "section",
    "text": "Basis\nMonomial"
},

{
    "location": "library.html#NarmaxLasso.NarmaxRegressors",
    "page": "Library",
    "title": "NarmaxLasso.NarmaxRegressors",
    "category": "Type",
    "text": "NarmaxRegressors{T<:Basis}(basis::Vector{T}, yterms, uterms[, vterms])\n\nDescribe regressors to be used on a NARMAX estimation problem.\n\n\n\n"
},

{
    "location": "library.html#NarmaxLasso.generate_all",
    "page": "Library",
    "title": "NarmaxLasso.generate_all",
    "category": "Function",
    "text": "generate_all(::Type{NarmaxRegressors}, ::Type{Monomials}, ny, nu, nv, order)\n\nGenerate a set of regressors containing all monomials:\n\nleft(yk-q_i right)^l_i left(uk-t_i right)^r_i\nleft(ek-w_i right)^s_i\n\nfor which: 1le q_i le n_y; 1 le t_i le n_u;  1 le w_i le n_e; and, l_i + r_i + s_i = textorderi.\n\n\n\n"
},

{
    "location": "library.html#Regressors-1",
    "page": "Library",
    "title": "Regressors",
    "category": "section",
    "text": "NarmaxRegressors\ngenerate_all"
},

{
    "location": "library.html#NarmaxLasso.narmax_lasso",
    "page": "Library",
    "title": "NarmaxLasso.narmax_lasso",
    "category": "Function",
    "text": "narmax_lasso(y, u, mdl::NarmaxRegressors[; use_glmnet]) -> r::LassoResult\n\nGiven input and output signals u and y, and a structure mdl specifying the regressors through a structure NarmaxRegressors. Find the solution of the lasso problem:\n\nmin_beta mathbfe^2 + lambda * sum_i beta_i\n\nfor a grid of values of the regularization parameter lambda. Return a LassoResult structure containing the obtained values. The option use_glmnet=true changes the internal solver to GLMNet (only available when no noise term is present).\n\n\n\n"
},

{
    "location": "library.html#NarmaxLasso.LassoResult",
    "page": "Library",
    "title": "NarmaxLasso.LassoResult",
    "category": "Type",
    "text": "LassoResult\n\nResult of lasso estimation for a grid of values of regularization parameter. Contains:\n\nAtributes Type Brief Description\nmdl NarmaxRegressors Regressors\nλ Matrix{Float64} Sequence of regularization parameters λ\nβ Matrix{Float64} Parameter vectors arranged columnwise, for the sequence of λ\ndf Matrix{Int} Number of nonzero terms for the sequence of λ\ntime Float64 Execution time\ntotal_iter Int Total number of internal iterations\n\n\n\n"
},

{
    "location": "library.html#LassoEstimation-1",
    "page": "Library",
    "title": "LassoEstimation",
    "category": "section",
    "text": "narmax_lasso\nLassoResult"
},

]}
