{smcl}
{* *! version 1.0.2  14may2019}{...}
{vieweralsosee "[R] npregress kernel" "mansection R npregresskernel"}{...}
{title:Expected kernel observations}

{pstd}
The expected number of kernel observations rounds the product of the
continuous kernel bandwidth values and the number of observations used for
estimation.

{pstd}
Nonparametric kernel regression performs a regression for each observation in
your data.  Each one of these regressions uses, on average, the expected
number of kernel observations reported in the output table.  For example, if
the number of observations is 10,000 and the bandwidth is 0.08, each
regression uses, on average, 800 observations.


{title:Relationship between expected kernel observations and convergence rate}

{pstd}
The square root of the expected kernel observations is also a measure of the
nonparametric kernel regression rate of convergence.  This rate is slower than
the parametric rate, which is the square root of the number of observations.
The difference between the two measures comes from the product of the
bandwidths, which is in most cases less than 1.

{pstd}
Because not all observations are used for estimation, the convergence rate of
nonparametric kernel regression is always slower than the parametric rate, as
long as the function is nonlinear.  When the function is linear, the number of
observations is the same as the expected kernel observations, and the
convergence rates are equal.  In this case, linear regression and
nonparametric kernel regression give equivalent results.
{p_end}
