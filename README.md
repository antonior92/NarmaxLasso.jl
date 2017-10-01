# NarmaxLasso

[![Build Status](https://travis-ci.org/antonior92/NarmaxLasso.jl.svg?branch=master)](https://travis-ci.org/antonior92/NarmaxLasso.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/g4qop766kli0ukrj?svg=true)](https://ci.appveyor.com/project/antonior92/narmaxlasso-jl)
[![Coverage Status](https://coveralls.io/repos/antonior92/NarmaxLasso.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/antonior92/NarmaxLasso.jl?branch=master)
[![codecov.io](http://codecov.io/github/antonior92/NarmaxLasso.jl/coverage.svg?branch=master)](http://codecov.io/github/antonior92/NarmaxLasso.jl?branch=master)

This package provides a method for computing the parameters of NARMAX
(*Nonlinear autoregressive moving average model with exogenous inputs*)
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

## Overview

This package allows the estimation of parameters of discrete
dynamic models from observed data.

For instance, consider vectors of observed inputs and
outputs: ``u`` and ``y``. Assume, for instance, we want
to fit the following model to the observed data:
```
y[k] = β[1]*y[k-1] + β[2]*u[k-1] + β[3]*v[k-1] + v[k]
```
this can be done by the following command sequence:
```JULIA
julia> using NarmaxLasso
julia> mdl = generate_all(NarmaxRegressors, Monomial, 1, 1, 1, 1)
    u[k-1]
    y[k-1]
    v[k-1]
julia> result = narmax_lasso(y, u, mdl); # Assuming predefined u and y
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
julia> plotlyjs()
julia> plot(result)
```
A possible output would be:
![example.png](example.png)

Usually the value of λ is chosen by testing on a validation set.
Folder ``examples`` contains two complete usage examples.

So far the above estimation procedure is implemented
only for linear and polynomial models. More options should
be included latter.
