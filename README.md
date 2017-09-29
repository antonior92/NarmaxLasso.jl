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
