{smcl}
{* *! version 1.0.0  01oct2015}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{title:Average predictions with multiple-record survival data}

{pstd}
When there are multiple records per individual in survival analysis,
average predictions over the dataset (usually computed by 
{helpb margins}) may not be appropriate. A valid alternative is to use
the {cmd:at()} option to compute predictions at fixed values of the
covariates.

{pstd}
The command {helpb margins} computes, by default, predictive margins,
also called adjusted predictions.  When there is only one record per
subject, the average prediction over the sample is an estimate of such
prediction for the population.  However, when there are multiple
observations per individual, different individuals may have different
numbers of observations.  If we average those values, some individuals 
will be represented one time, and some individuals will be represented 
many times. This average value will not have a useful interpretation 
with respect to the population.

{pstd} 
With multiple-record survival-time data, an alternative is to use 
{helpb margins} with the {cmd:at()} option to compute predictions 
at specific covariate patterns of interest.  
{p_end}
