{smcl}
{* *! version 1.0.2  20nov2018}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{title:Why is log marginal-likelihood reported missing?}

{pstd}
The log marginal-likelihood (LML) could not be computed.  This will often be
the case when the size of the MCMC sample is very small.  The computation of
the LML involves the inverse of the determinant of the sample covariance
matrix of the parameters.  When the MCMC sample size is small, which often
leads to having very few distinct simulated parameter values in the sample,
the determinant of the matrix evaluates to 0, and the LML value becomes
missing.  The remedy is to specify a larger MCMC sample size in option
{cmd:mcmcsize()}.

{pstd}
Also, estimation of the LML becomes unstable for high-dimensional models such
as multilevel models and may result in a missing value.

{pstd}
A missing value is also reported when you specify the {cmd:exclude()} option
with {cmd:bayesmh} and when you use the Laplace-Metropolis approximation,
because this approximation requires simulation results for all parameters.

{pstd}
When an LML is missing, Bayes factors computed by 
{helpb bayesstats ic} and posterior model probabilities computed by
{helpb bayestest model} will also be missing.  You can try using the
{cmd:marglmethod(hmean)} option with these commands to use the harmonic-mean
approximation of the LML, although this approximation is typically less
precise.
{p_end}
