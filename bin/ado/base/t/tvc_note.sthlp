{smcl}
{* *! version 1.1.5  06mar2015}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] stcox postestimation" "help stcox_postestimation"}{...}
{vieweralsosee "[ST] stsplit" "help stsplit"}{...}
{viewerjumpto "Description" "tvc_note##description"}{...}
{viewerjumpto "Remarks" "tvc_note##remarks"}{...}
{viewerjumpto "Example" "tvc_note##example"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{hi: tvc note} {hline 2}}Splitting
the data at failure times to reproduce the results from {cmd:stcox}
with the {opt tvc()} option
{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry shows, by an example, an alternative way to produce the results 
from {helpb stcox} with the {opt tvc()} option.
We will split the data at failure times (using {cmd:stsplit}) and generate
interaction terms manually.
In general, using {opt tvc()} is the most efficient way to 
fit a model with time-varying covariates.  However, doing the process
manually allows the use of some extra features.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {opt tvc()} option provides a quick and convenient way to model
time-varying covariates.  A new predictor is added to the model for each
variable specified in {opt tvc()}.  Each new predictor is equivalent to the
product of the corresponding variable with a function of the study time.  We
will refer to these new predictors as interaction terms.

{pstd}
The Cox model is fit by evaluating the partial likelihood at each failure
time.
We will need to generate new variables if we want to manually include the
above interaction terms in the model fit.
Because the interaction terms are a function of the study time, this will
require us to split the dataset at the failure times.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drugtr}

{pstd}See the setting for survival data{p_end}
{phang2}{cmd:. stset}{p_end}

{pstd}
Fit a Cox model with the following covariates:
{cmd:drug},
{cmd:drug} as a time-varying covariate, and
{cmd:age} only as a time-varying covariate.
Use the square of study time in the interaction terms.

{phang2}
{cmd:. stcox drug, tvc(drug age) texp(_t^2)}

{pstd}
Now we'll produce the same results by using {cmd:stsplit}.  This will take four
steps:

{phang}
1.  Generate a subject identifier variable if we don't already have one.  Make
sure to include this variable in the {opt id()} option of {cmd:stset}.

{phang2}{cmd:. generate id = _n}{p_end}
{phang2}{cmd:. streset, id(id)}{p_end}

{phang}
2.  Use {cmd:stsplit} to split the data at the failure times.

{phang2}{cmd:. stsplit, at(failures)}{p_end}

{phang}
3.  Generate the variables representing the interaction terms.

{phang2}{cmd:. generate agetvc = age*(_t^2)}{p_end}
{phang2}{cmd:. generate drugtvc = drug*(_t^2)}{p_end}

{phang}
4.  Fit the Cox model, including the variable drug and the two variables
interacted with the study time.

{phang2}{cmd:. stcox drug drugtvc agetvc}{p_end}
