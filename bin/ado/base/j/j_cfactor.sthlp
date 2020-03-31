{smcl}
{* *! version 1.0.0  15feb2020}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "[ME] meglm" "mansection ME meglm"}{...}
{vieweralsosee "[ME] mixed" "mansection ME mixed"}{...}
{title:Specifying factor variables for crossed-effects models}

{pstd}
The crossed-effects factor-variable specification, {cmd:R.}{it:varname},
is typically used for fitting crossed-effects models.  Indicator variables
are included for all levels of the crossed-effects factor variable, and
the constant is omitted.  The variances of the random coefficients for 
these indicators are constrained to be equal.
{p_end}
