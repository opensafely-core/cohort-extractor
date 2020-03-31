{* *! version 1.0.0  22jun2019}{...}
{phang}
{cmd:selection(plugin}|{cmd:cv}|{cmd:adaptive)} specifies the selection method
for choosing an optimal value of the lasso penalty parameter lambda* for each
lasso or square-root lasso estimation.  Separate lassos are estimated for
{it:depvar} and each variable in {it:varsofinterest}.  Specifying
{cmd:selection()} changes the selection method for all of these lassos.  You
can specify different selection methods for different lassos using the option
{cmd:lasso()} or {cmd:sqrtlasso()}.  When {cmd:lasso()} or {cmd:sqrtlasso()} is
used to specify a different selection method for the lassos of some variables,
they override the global setting made using {cmd:selection()} for the
specified variables.

{phang2}
{cmd:selection(plugin)} is the default.  It selects lambda* based on a
"plugin" iterative formula dependent on the data.  See
{manhelp lasso_options LASSO:lasso options}.

{phang2}
{cmd:selection(cv)} 
selects the lambda* that gives the minimum of the CV function.
See {manhelp lasso_options LASSO:lasso options}.

{phang2}
{cmd:selection(adaptive)}
selects lambda* using the adaptive lasso selection method.
It cannot be specified when {cmd:sqrtlasso} is specified.
See {manhelp lasso_options LASSO:lasso options}.
