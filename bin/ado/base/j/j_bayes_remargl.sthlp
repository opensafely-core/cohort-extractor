{smcl}
{* *! version 1.0.1  25apr2019}{...}
{title:Why is log marginal-likelihood not reported for multilevel models?}

{pstd}
The {cmd:bayes} prefix does not report the log marginal-likelihood (LML) by
default for multilevel models.  Bayesian multilevel models contain many
parameters because, in addition to regression coefficients and variance
components, they also estimate individual random effects.  The computation of
the LML involves the inverse of the determinant of the sample covariance
matrix of all parameters, and loses its accuracy as the number of parameters
grows.  For high-dimensional models such as multilevel models, the computation
of the LML can be time consuming, and its accuracy may become unacceptably
low.  Because it is difficult to access the levels of accuracy of the
computation for all multilevel models, the LML is not reported by default.

{pstd}
For multilevel models containing a small number of random effects, you can use
the {cmd:remargl} option to compute and display the LML.  When you specify the
{cmd:remargl} option, the LML may still not be available for some models; see
{it:{help j_bayesmh_marglmiss:Why is log marginal-likelihood reported missing?}} for details.
