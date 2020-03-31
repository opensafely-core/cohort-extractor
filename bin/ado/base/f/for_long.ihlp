{* *! version 1.0.0  22jun2019}{...}
{phang}
{opt for(varspec)} specifies a particular lasso after a {cmd:ds}, a {cmd:po},
or an {cmd:xpo} estimation command fit using the option {cmd:selection(cv)} or
{cmd:selection(adaptive)}.  For all commands except {cmd:poivregress} and
{cmd:xpoivregress}, {it:varspec} is always a {varname}; it is either
{it:depvar}, the dependent variable, or one of {it:varsofinterest} for which
inference is done.

{pmore} 
For {cmd:poivregress} and {cmd:xpoivregress}, {it:varspec} is either
{it:varname} or {opt pred(varname)}.  The lasso for {it:depvar} is specified
with its {it:varname}.  Each of the endogenous variables have two lassos,
specified by {it:varname} and {opt pred(varname)}.  The exogenous variables of
interest each have only one lasso, and it is specified by {opt pred(varname)}.

{pmore} 
This option is required after {cmd:ds}, {cmd:po}, and {cmd:xpo} commands.

{phang}
{opt xfold(#)} specifies a particular lasso after an {cmd:xpo} estimation
command.  For each variable to be fit with a lasso, K lassos are done, one for
each cross-fit fold, where K is the number of folds.  This option specifies
which fold, where {it:#} = 1, 2, ..., K.  It is required after an {cmd:xpo}
command.

{phang}
{opt resample(#)} specifies a particular lasso after an {cmd:xpo} estimation
command fit using the option {opt resample(#)}.  For each variable to be fit
with a lasso, R x K lassos are done, where R is the number of resamples and K
is the number of cross-fitting folds.  This option specifies which resample,
where {it:#} = 1, 2, ..., R.  This option, along with {opt xfold(#)}, is
required after an {cmd:xpo} command with resampling.
