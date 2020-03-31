{smcl}
{* *! version 1.1.3  28apr2011}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: xtgee reports convergence not achieved" "browse http://www.stata.com/support/faqs/stat/xtgee.html"}{...}
{title:When estimating via {cmd:xtgee, corr(exchangeable)}} 
{sf:     }{title:you have received a "convergence not achieved" message}

{pstd}
GEE estimation is via iteratively reweighted least squares where the
observations within a panel are weighted by the inverse of an estimated
correlation matrix {bf:R} (see {it:Methods and formulas} in {hi:[XT] xtgee}).
With {cmd:correlation(exchangeable)}, GEE uses the method of moments to
estimate a single correlation value {bf:p} for all off-diagonal elements of
{bf:R}.  Unlike a standard correlation matrix, this estimate of {bf:R} is not
guaranteed to result in a positive-definite matrix.  ({bf:R} cannot be
estimated as a standard correlation matrix, because that estimator requires
all elements of the matrix to be free parameters, whereas the exchangeable
form constrains the structure of the matrix.)

{pstd}
When {bf:R} is not positive definite, we have a contradiction.  GEE weights
the data by a correlation matrix, but because {bf:R} is not positive definite it
is not a correlation matrix.  Operationally, when {bf:R} is not positive
definite, its G2 inverse will produce weights that completely exclude some
observations from the estimation of the main model coefficients.

{pstd}
In such cases, your model does not fit the data sufficiently well for the
correlation matrix {bf:R} to be properly identified and {cmd:xtgee} declares
nonconvergence.

{pstd}
With {cmd:correlation(exchangeable)}, {bf:R} is guaranteed to be positive
definite if {bind:{bf:p} >= 0}.  Only in unusual cases where the common
correlation among the observations in the panel is negative can {bf:R} be
nonpositive definite.  The degree to which {bf:p} can be negative and {bf:R}
remain positive definite is inversely related to the size of the largest panel.
For a detailed discussion of this issue, see the FAQ {browse "http://www.stata.com/support/faqs/stat/xtgee.html":xtgee reports convergence not achieved}.

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

{p 11 11 2}
   You may decide to accept the estimate of {bf:R} from the nonconverged
   results.  If {cmd:xtgee} has declared nonconvergence it is because the
   moment-based estimate of {bf:p} exceeds the lower threshold for {cmd:R} to
   be positive definite.  The final estimates use a value of {bf:p} that is 99%
   of the smallest {bf:p} that will keep {bf:R} positive definite.

{p 8 11 2}
3) Restrict estimation to a subset of the data that produces balanced panels.
(This can help, but is not guaranteed to produce convergence.)

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
