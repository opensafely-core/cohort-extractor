{smcl}
{* *! version 1.1.4  14may2018}{...}
{* this file gotten to from svyset.dlg}{...}
{vieweralsosee "[SVY] svy jackknife" "mansection SVY svyjackknife"}{...}
{vieweralsosee "[SVY] svyset" "mansection SVY svyset"}{...}
{vieweralsosee "[SVY] Variance estimation" "mansection SVY Varianceestimation"}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{title:What are all the different types of weight variables allowed by svyset?}

{phang}
{bf:sampling weight}.
Given a survey design, the sampling weight for an individual is the reciprocal
of the probability of being sampled.  The probability for being sampled is
derived from stratification and clustering in the survey design.  A sampling
weight is typically considered to be the number of individuals in the
population represented by the sampled individual it is attached to.

{phang}
{bf:importance weight}.
Importance weights are sampling weights that are allowed to have negative
values.
Negative sampling weights can arise from various postsampling
adjustment procedures.
Importance weights should rarely be used.

{phang}
{bf:replicate weight variable}.
A replicate weight variable contains sampling weight values that were adjusted
for resampling the data.

{pmore}
{it:balanced repeated replicate weight variables} are copies of the
sampling weights that were adjusted for resampling the data using BRR.

{pmore}
{it:jackknife replicate weight variables} are copies of the sampling weights
that were adjusted for resampling the data using the jackknife.

{pmore}
See {manlink SVY Variance estimation} for a detailed discussion of the BRR
and jackknife replicate weight variables.
{p_end}
