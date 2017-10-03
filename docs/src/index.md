# NarmaxLasso

*Algorithms for Lasso estimation of NARMAX models.*

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

## Manual Outline

This package provides methods for computing the parameters of NARMAX (Nonlinear autoregressive moving average with exogenous inputs) models subject to L1 penalty using pathwise coordinate optimization algorithm.

```@contents
Pages = [
    "installation.md",
    "guide.md",
    "library.md"
]
Depth = 2
```
