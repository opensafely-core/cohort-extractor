{smcl}
{* *! version 1.0.6  14may2018}{...}
{* this file gotten to from clickable output produced by _coef_table.ado}{...}
{vieweralsosee "[SVY] svy sdr" "mansection SVY svysdr"}{...}
{vieweralsosee "[SVY] svyset" "mansection SVY svyset"}{...}
{vieweralsosee "[SVY] Variance estimation" "mansection SVY Varianceestimation"}{...}
{title:What does "SDR *" mean?}

{pstd}
Your estimation results have "{bf:SDR *}" in the table header above the column
of standard errors.

{pstd}
The {bf:SDR} in "{bf:SDR *}" indicates that the standard errors were computed
using the method of successive difference replication.  This
means that you specified the {cmd:vce(sdr)} option of {helpb svyset} or
computed the estimation results using {helpb svy sdr}.  By default,
{cmd:vce(sdr)} and {cmd:svy} {cmd:sdr} compute the variance using deviations
of the replicates from their mean.

{pstd}
The {bf:*} in "{bf:SDR *}" indicates that the standard errors were calculated
using the mean squared error formula (MSE) of the SDR variance estimator.
This means that you also specified the {cmd:mse} option with {cmd:svyset} or
{cmd:svy} {cmd:sdr}.

{pstd}
See {manlink SVY Variance estimation} for a detailed discussion of the SDR
method for variance (and standard error) estimation.
{p_end}
