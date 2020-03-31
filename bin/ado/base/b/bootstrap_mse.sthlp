{smcl}
{* *! version 1.1.4  19oct2017}{...}
{* this file gotten to from clickable output produced by _coef_table.ado}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] vce_option" "help vce_option"}{...}
{title:What does "Bstrap *" mean?}

{pstd}
Your estimation results have "{bf:Bstrap *}" in the table header above the
column of standard errors.

{pstd}
The {bf:Bstrap} in "{bf:Bstrap *}" indicates that the standard errors were
computed using the bootstrap resampling method.  This means that you specified
the {help vce_option:vce(bootstrap)} option of an estimation command or
computed the estimation results using {helpb bootstrap}.  By default,
{cmd:vce(bootstrap)} and {cmd:bootstrap} compute the variance using deviations
of the bootstrap replicates from their mean.

{pstd}
The {bf:*} in "{bf:Bstrap *}" indicates that the standard errors were
calculated using the mean squared error (MSE) formula of the bootstrap
variance estimator.  This means that you specified {cmd:vce(bootstrap, mse)}
or the {cmd:mse} option of {cmd:bootstrap}.

{pstd}
See {manlink R bootstrap} for a detailed discussion of the bootstrap resampling
method for variance (and standard error) estimation.
{p_end}
