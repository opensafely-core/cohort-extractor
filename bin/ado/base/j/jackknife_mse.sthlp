{smcl}
{* *! version 1.1.2  14may2018}{...}
{* this file gotten to from clickable output produced by _coef_table.ado}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[R] vce_option" "help vce_option"}{...}
{viewerjumpto "What does Jknife * mean?" "jackknife_mse##intro"}{...}
{viewerjumpto "What does Jknife * mean with survey data?" "jackknife_mse##intro_svy"}{...}
{marker intro}{...}
{title:What does "Jknife *" mean?}

{pstd}
Your estimation results have "{bf:Jknife *}" in the table header above the
column of standard errors.

{pstd}
The {bf:Jknife} in  "{bf:Jknife *}" indicates that the standard errors were
computed using the jackknife resampling method.  This means that you specified
the {help vce_option:vce(jackknife)} option of an estimation command or
computed the estimation results using {helpb jackknife}.  By default,
{cmd:vce(jackknife)} and {cmd:jackknife} compute the variance using deviations
of the jackknife pseudovalues from their mean.

{pstd}
The {bf:*} in "{bf:Jknife *}" indicates that the standard errors were
calculated using the mean squared error formula (MSE) of the jackknife
variance estimator.  This means that you specified {cmd:vce(jackknife, mse)}
or the {cmd:mse} option of {cmd:jackknife}.

{pstd}
See {bf:[R] jackknife} for a detailed discussion of the jackknife resampling
method for variance (and standard error) estimation.


{marker intro_svy}{...}
{title:What does "Jknife *" mean with survey data?}

{pstd}
Your survey data estimation results have "{bf:Jknife *}" in the table header
above the column of standard errors.

{pstd}
The {bf:Jknife} in  "{bf:Jknife *}" indicates that the standard errors were
computed using the jackknife resampling method for survey data.  This
means that you specified the {cmd:vce(jackknife)} option of {helpb svyset}
or computed the estimation results using {helpb svy jackknife}.
By default, {cmd:vce(jackknife)} and {cmd:svy} {cmd:jackknife} compute the
variance using deviations of the jackknife pseudovalues from their mean.

{pstd}
The {bf:*} in "{bf:Jknife *}" indicates that the standard errors were
calculated using the mean squared error formula (MSE) of the jackknife
variance estimator.  This means that you specified the {cmd:mse} option with
{cmd:svyset} or {cmd:svy} {cmd:jackknife}.

{pstd}
See {bf:[SVY] Variance estimation} for a detailed discussion of the jackknife
method for variance (and standard error) estimation with survey data.
{p_end}
