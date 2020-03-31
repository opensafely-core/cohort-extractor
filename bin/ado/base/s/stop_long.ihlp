{* *! version 1.0.0  22jun2019}{...}
{phang}
{opt stop(#)} specifies a tolerance that is the stopping criterion for the
lambda iterations.  The default is 1e-5.  This suboption does not apply when
the selection method is {cmd:selection(plugin)}.  Estimation starts with the
maximum grid value, lambda_{gmax}, and iterates toward the minimum grid value,
lambda_{gmin}.  When the relative difference in the deviance produced by two
adjacent lambda grid values is less than {opt stop(#)}, the iteration stops
and no smaller lambdas are evaluated.  The value of lambda that meets this
tolerance is denoted by lambda_{stop}.  Typically, this stopping criterion is
met before the iteration reaches lambda_{gmin}.

{pmore}
Setting {opt stop(#)} to a larger value means that iterations are stopped
earlier at a larger lambda_{stop}.  To produce coefficient estimates for all
values of the lambda grid, {cmd:stop(0)} can be specified.  Note, however,
that computations for small lambdas can be extremely time consuming.  In
terms of time, when using {cmd:selection(cv)} and {cmd:selection(adaptive)},
the optimal value of {opt stop(#)} is the largest value that allows estimates
for just enough lambdas to be computed to identify the minimum of the CV
function.  When setting {opt stop(#)} to larger values, be aware of the
consequences of the default lambda* selection procedure given by the default
{cmd:stopok}.  You may want to override the {cmd:stopok} behavior by using
{cmd:strict}.
