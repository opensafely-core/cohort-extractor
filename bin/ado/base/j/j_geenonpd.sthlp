{smcl}
{* *! version 1.1.4  28apr2011}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: xtgee reports convergence not achieved" "browse http://www.stata.com/support/faqs/stat/xtgee.html"}{...}
{title:When estimating with {cmd:xtgee} you have received a "convergence not achieved" message}

{pstd}
GEE estimation is via iteratively reweighted least squares where the
observations within a panel are weighted by the inverse of an estimated
correlation matrix {bf:R} (see {it:Methods and formulas} in {hi:[XT] xtgee}). 
Because {bf:R} can take many different forms (for example, autocorrelated,
stationary, unstructured, etc.), and because the estimation procedure
must adapt nicely to unbalanced panels, GEE estimates of the elements of
this matrix are moment-based.  Unlike a standard correlation matrix, GEE
estimation of {bf:R} is not guaranteed to result in a positive-definite
matrix.  ({bf:R} cannot be estimated as a standard correlation matrix,
because that estimator requires all elements of the matrix to be free
parameters, whereas the specified forms allowed by {cmd:xtgee} constrain
the structure of the matrix.)

{pstd}
When {bf:R} is not positive definite, we have a contradiction.  GEE weights
the data by a correlation matrix, but because {bf:R} is not positive definite it
is not a correlation matrix.  Operationally, when {bf:R} is not positive
definite, its G2 inverse will produce weights that completely exclude some
observations from the estimation of the main model coefficients.

{pstd}
In such cases, your model does not fit the data sufficiently well for the
correlation matrix {bf:R} to be properly identified, and {cmd:xtgee} declares
nonconvergence.

{pstd}
To redress the problem, carefully review the science underpinning your
specification, and consider changing your model specification or estimating on
a subset of the data.

{p 8 11 2}
1) Change the covariates, family, or link in your main model
   specification.

{p 8 11 2}
2) Change the correlation structure.  In extreme cases, you can specify your
   own estimate of {bf:R} using the {cmd:fixed} structure of option
   {cmd:correlation()}.  Alternatively, {cmd:correlation(independent)} is
   always positive definite.

{p 8 11 2}
3) Restrict estimation to a subset of the data that produces balanced panels.
(This can help, but it is not guaranteed to produce convergence.)

{pstd}
Remember that correct specification of the correlation structure affects only
the efficiency of the parameter estimates.  The estimates are consistent
regardless of correlation structure.  While correct coverage by the default
standard error estimates requires a correct correlation structure, this
requirement can be relaxed by adding the {cmd:robust} option.  When
{cmd:robust} is specified, not only are the parameter estimates
consistent, their standard error estimates have correct coverage, regardless
of whether the "true" correlation structure is specified.
{p_end}
