{* *! version 1.0.0  22jun2019}{...}
{marker sqrtlasso_options}{...}
{phang}
{cmd:sqrtlasso(}{it:varlist}{cmd:,} {it:lasso_options}{cmd:)} works like the
option {cmd:lasso()}, except square-root lassos for the variables in
{it:varlist} are done rather than regular lassos.  {it:varlist} consists of
one or more variables from {it:depvar}, {it:exovars}, or {it:endovars}.  This
option is repeatable as long as different variables are given in each
specification.  {it:lasso_options} are {cmd:selection(}...{cmd:)},
{cmd:grid(}...{cmd:)}, {opt stop(#)}, {opt tolerance(#)}, {opt dtolerance(#)},
and {opt cvtolerance(#)}.  When {cmd:sqrtlasso(}{it:varlist}{cmd:,}
{cmd:selection(}...{cmd:))} is specified, it overrides any global
{cmd:selection()} option for the variables in {it:varlist}.  See 
{manhelp lasso_options LASSO:lasso options}.
