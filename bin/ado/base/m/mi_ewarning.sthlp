{smcl}
{* *! version 1.0.4  10aug2012}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Estimation sample varies across imputations" "mi_ewarning##remarks1"}{...}
{viewerjumpto "Note about a varying estimation sample with mi estimate using" "mi_ewarning##remarks2"}{...}
{marker remarks1}{...}
{title:Estimation sample varies across imputations}

{pstd}
There is something about the specified model that causes the estimation sample
to be different between imputations.  Here are several situations when this
can happen:

{phang}
1.  You are fitting a model on a subsample that changes from one imputation to
another.  For example, you specified the {cmd:if} expression containing
imputed variables.

{phang}
2.  Variables used by model-specific estimators contain values varying 
    across imputations.  This results in different sets of observations being
    used for completed-data analysis.

{phang}
3.  Variables used in the model (specified directly or used indirectly by
the estimator) contain missing values in sets of observations that vary among
imputations.  Verify that your {cmd:mi} data are proper and, if necessary, use
{helpb mi_update:mi update} to update them.

{pstd}
A varying estimation sample can lead to biased or less efficient estimates.
We recommend that you evaluate the differences in records leading to a varying
estimation sample before continuing your analysis.  To identify the sets of
observations varying across imputations, you can specify the {cmd:esampvaryok}
option and save the estimation sample as an extra variable in your data (in
the flong or flongsep styles only) by using {cmd:mi} {cmd:estimate}'s
{cmd:esample()} option.


{marker remarks2}{...}
{title:Note about a varying estimation sample with {cmd:mi} {cmd:estimate} {cmd:using}}

{pstd}
{cmd:mi} {cmd:estimate} checks for a varying estimation sample during
estimation and stores the result in {cmd:e(esampvary_mi)} equal to {cmd:1} if
{cmd:e(sample)} varies and {cmd:0} otherwise.  If {opt saving(miestfile)} is
used with {cmd:mi} {cmd:estimate}, the varying-sample flag
{cmd:e(esampvary_mi)} is also saved to {it:miestfile}.  {cmd:mi} {cmd:estimate}
{cmd:using} checks that flag and displays a warning message if its value is
1.  Thus {cmd:mi} {cmd:estimate} {cmd:using} displays the warning message
even if you are consolidating results from a subset of imputations for which
the estimation sample may be constant; you can suppress the message by
specifying the {cmd:nowarning} option.

{pstd}
To check whether the estimation sample changes for the selected subset of
imputations, you can use {cmd:mi} {cmd:estimate} to refit the model on the
specified subset.  You can also save the estimation sample as an extra
variable by using {cmd:mi} {cmd:estimate}'s {cmd:esample()} option during
estimation.
{p_end}
