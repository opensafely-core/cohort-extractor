{* *! version 1.0.0  22jun2019}{...}
{phang}
{opt cvtolerance(#)} is a rarely used option that changes the tolerance for
identifying the minimum CV function.  For linear models, a minimum is declared
identified when the CV function rises above a nominal minimum for at least
three smaller lambdas with a relative difference in the CV function greater
than {it:#}.  For nonlinear models, at least five smaller lambdas are
required.  The default is 1e-3.  Setting {it:#} to a bigger value makes a
stricter criterion for identifying a minimum and brings more assurance that a
declared minimum is a true minimum, but it also means that models may need to
be fit for additional smaller lambda, and this can be time consuming.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} for
{bf:[LASSO] lasso} for more information about this tolerance and the other
tolerances.

{phang}
{opt tolerance(#)} is a rarely used option that specifies the convergence
tolerance for the coefficients.  Convergence is achieved when the relative
change in each coefficient is less than this tolerance.  The default is
{cmd:tolerance(1e-7)}.

{phang}
{opt dtolerance(#)} is a rarely used option that changes the convergence
criterion for the coefficients.  When {opt dtolerance(#)} is specified, the
convergence criterion is based on the change in deviance instead of the change
in the values of coefficient estimates.  Convergence is declared when the
relative change in the deviance is less than {it:#}.  More accurate
coefficient estimates are typically achieved by not specifying this option
and instead using the default {cmd:tolerance(1e-7)} criterion or specifying a
smaller value for {opt tolerance(#)}.
