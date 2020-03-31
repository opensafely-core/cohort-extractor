{smcl}
{* *! version 1.0.3  12jun2011}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate using"}{...}
{title:Monte Carlo error estimates are not reported for confidence intervals}

{pstd}
Monte Carlo error estimates are not reported for confidence intervals with
the command {cmd:mi estimate, mcerror} upon replay.  This happens when the
confidence level being used to report confidence intervals differs from the
confidence level used to compute Monte Carlo error estimates of confidence
interval estimates.  (The confidence level used to compute Monte Carlo error
estimates of confidence intervals is stored in the {bf:e(cilevel_mi)} scalar.)

{pstd}
Most likely, you used the {cmd:mcerror} option with either 
{helpb mi estimate} or {helpb mi estimate using} during estimation and then
specified the {cmd:level()} option, containing a confidence level other than
the default 95, upon replay:

{phang2}{cmd:  . mi estimate, mcerror:}{it: ...}{p_end}
{phang2}{cmd:  . mi estimate, mcerror level(90)}{p_end}

{pstd}
By default, {cmd:mcerror} obtains Monte Carlo error estimates for 95%
confidence intervals.  To obtain Monte Carlo error estimates, for example, for
90% confidence intervals, specify the {cmd:level()} option during estimation:

{phang2}{cmd:  . mi estimate, mcerror level(90):}{it: ...}{p_end}

{pstd}
If you wish to obtain Monte Carlo error estimates of confidence intervals for
a number of different confidence levels, a more computationally efficient way
of doing this is to use {cmd: mi estimate using}.

{pstd}
First, use {cmd:mi estimate} to save individual estimation results from a
model fit to an estimation file:

{phang2}{cmd:  . mi estimate, saving(miest):}{it: ...}{p_end}

{pstd}
Then use {cmd:mi estimate using} to obtain Monte Carlo error estimates for
different confidence intervals without refitting the model:
{p_end}

{phang2}{cmd:  . mi estimate using miest, mcerror level(90)}{it: ...}{p_end}
{phang2}{cmd:  . mi estimate using miest, mcerror level(80)}{it: ...}{p_end}
