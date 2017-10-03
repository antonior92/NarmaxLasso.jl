# NarmaxLasso

[![Build Status](https://travis-ci.org/antonior92/NarmaxLasso.jl.svg?branch=master)](https://travis-ci.org/antonior92/NarmaxLasso.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/g4qop766kli0ukrj?svg=true)](https://ci.appveyor.com/project/antonior92/narmaxlasso-jl)
[![Coverage Status](https://coveralls.io/repos/antonior92/NarmaxLasso.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/antonior92/NarmaxLasso.jl?branch=master)
[![codecov.io](http://codecov.io/github/antonior92/NarmaxLasso.jl/coverage.svg?branch=master)](http://codecov.io/github/antonior92/NarmaxLasso.jl?branch=master)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://antonior92.github.io/NarmaxLasso.jl/latest)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://antonior92.github.io/NarmaxLasso.jl/latest)

This package provides a method for computing the parameters of NARMAX
(*Nonlinear autoregressive moving average with exogenous inputs*)
models subject to L1 penalty using pathwise coordinate optimization algorithm.


## Installation

Within [Julia](https://julialang.org/downloads/), use the package manager:

```JULIA
julia> Pkg.clone("https://github.com/antonior92/NarmaxLasso.jl")
```

The package installation can be tested using the command:

```JULIA
julia> Pkg.test("NarmaxLasso")
```

## Documentation

View the [full documentation](https://antonior92.github.io/NarmaxLasso.jl/latest).

## Examples

Folder [``examples``](https://github.com/antonior92/NarmaxLasso.jl/tree/master/examples) contains two complete usage examples.

## Reference

Both the implementation and the examples are originally from the paper:
```
"Lasso Regularization Paths for NARMAX Models via Coordinate Descent"
Antonio H. Ribeiro and Luis A. Aguirre
```
Preprint available in arXiv ([here](https://arxiv.org/abs/1710.00598))

BibTeX entry:
```
@article{ribeiro_lasso_2017,
  title = {Lasso {{Regularization Paths}} for {{NARMAX Models}} via {{Coordinate Descent}}},
  abstract = {We propose a new algorithm for estimating NARMAX models with L1 regularization for models represented as a linear combination of basis functions. Due to the L1-norm penalty the Lasso estimation tends to produce some coefficients that are exactly zero and hence gives interpretable models. The proposed algorithm uses cyclical coordinate descent to compute the parameters of the NARMAX models for the entire regularization path and, to the best of the authors knowledge, it is first the algorithm to allow the inclusion of error regressors in the Lasso estimation. This is made possible by updating the regressor matrix along with the parameter vector. In comparative timings we find that this modification does not harm the global efficiency of the algorithm and can provide the most important regressors in very few inexpensive iterations. The method is illustrated for linear and polynomial models by means of two examples.},
  timestamp = {2017-10-03T01:54:30Z},
  archivePrefix = {arXiv},
  eprinttype = {arxiv},
  eprint = {1710.00598},
  primaryClass = {cs, stat},
  journal = {arXiv:1710.00598 [cs, stat]},
  author = {Ribeiro, Ant{\^o}nio H. and Aguirre, Luis A.},
  month = oct,
  year = {2017},
  keywords = {Computer Science - Systems and Control,Statistics - Machine Learning}
}
```

## Overview

This package allows the estimation of parameters of discrete dynamic models from observed data.

For instance, consider vectors of observed inputs and
outputs: ``u`` and ``y``. Assume, for instance, we want
to fit the following model to the observed data:
```
y[k] = β[1]*y[k-1] + β[2]*u[k-1] + β[3]*v[k-1]
```
where the noise term ``v[k-1]`` is included to model the random effects that
affects the observation. The estimation can be done by the following command
sequence:
```JULIA
julia> using NarmaxLasso
julia> ny = 1; nu = 1; nv = 1; order = 1;
julia> mdl = generate_all(NarmaxRegressors, Monomial, ny, nu, nv, order)
    u[k-1]
    y[k-1]
    v[k-1]
julia> result = narmax_lasso(y, u, mdl);
```

Be ``e`` the error between the model prediction and the observed values,
the result of the above command sequence provides the solution of
the following minimization problem:
```
min_β ||e||^2 + λ * ∑ |β[i]|
```
for a grid of values of λ.

The output can be visualized using:
```JULIA
julia> using Plots
julia> plot(result)
```
A possible output would be:
![example.png](example.png)

Usually, the value of λ is chosen by testing on a validation set.

So far the above estimation procedure is implemented
only for linear and polynomial models. More options should
be included latter.
