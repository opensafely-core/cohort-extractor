{* *! version 1.0.0  22jun2019}{...}
{marker lasso_options}{...}
{phang}
{cmd:lasso(}{it:varlist}{cmd:,} {it:lasso_options}{cmd:)} lets you set different
options for different lassos, or advanced options for all lassos.  You specify
a {it:varlist} followed by the options you want to apply to the lassos for
these variables, where {it:varlist} consists of one or more variables from
{it:depvar}, {it:exovars}, or {it:endovars}.  {cmd:_all} or {cmd:*} may be
used to specify {it:depvar} and all {it:exovars} and {it:endovars}.  This
option is repeatable as long as different variables are given in each
specification.  {it:lasso_options} are {cmd:selection(}...{cmd:)},
{cmd:grid(}...{cmd:)}, {opt stop(#)}, {opt tolerance(#)}, {opt dtolerance(#)},
and {opt cvtolerance(#)}.  When {cmd:lasso(}{it:varlist}{cmd:,}
{cmd:selection(}...{cmd:))} is specified, it overrides any global
{cmd:selection()} option for the variables in {it:varlist}.  It also overrides
the global {cmd:sqrtlasso} option for these variables.  See 
{manhelp lasso_options LASSO:lasso options}.
