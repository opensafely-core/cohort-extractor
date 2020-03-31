{smcl}
{* *! version 1.1.4  14may2018}{...}
{* this file gotten to from clickable output produced by _coef_table.ado}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{title:What does "BRR *" mean?}

{pstd}
Your estimation results have "{bf:BRR *}" in the table header above the column
of standard errors.

{pstd}
The {bf:BRR} in "{bf:BRR *}" indicates that the standard errors were computed
using the method of {ul:b}alanced {ul:r}epeated {ul:r}eplication.  This means
that you specified the {cmd:vce(brr)} option of {helpb svyset} or computed the
estimation results using {helpb svy brr}.  By default, {cmd:vce(brr)} and
{cmd:svy} {cmd:brr} compute the variance using deviations of the replicates
from their mean.

{pstd}
The {bf:*} in "{bf:BRR *}" indicates that the standard errors were calculated
using the mean squared error formula (MSE) of the BRR variance estimator.
This means that you also specified the {cmd:mse} option with {cmd:svyset} or
{cmd:svy} {cmd:brr}.

{pstd}
See {manlink SVY Variance estimation} for a detailed discussion of the BRR
method for variance (and standard error) estimation.{p_end}
