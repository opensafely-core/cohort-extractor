{smcl}
{* *! version 1.0.4  18apr2011}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate using"}{...}
{title:The residual degrees of freedom has been reported as missing}

{pstd}
The individual or model residual degrees of freedom is reported to be
missing.  This may happen when the estimated (average) relative variance
increase due to nonresponse is close enough to zero (low fraction of
missings) such that the degrees of freedom approaches infinity.  In this case,
the normal distribution is used to compute the significance levels of the
reported t tests and the chi-squared distribution is used to compute the
significance level of the F test.
{p_end}
