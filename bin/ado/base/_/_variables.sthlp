{smcl}
{* *! version 1.1.5  21jan2020}{...}
{findalias asfrusvars}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] by" "help by"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[U] 13.7 Explicit subscripting" "help subscripting"}{...}
{viewerjumpto "Description" "_variables##description"}{...}
{viewerjumpto "Examples" "_variables##examples"}{...}
{title:Title}

{pstd}
{findalias frusvars}


{marker description}{...}
{title:Description}

{pstd}
Expressions may also contain {it:_variables} (pronounced "underscore
variables"), which are built-in system variables that are created and updated
by Stata.  They are called {it:_variables} because their names all begin with
the underscore character, "{cmd:_}".

{pstd}
The {it:_variables} are

{phang}{cmd:[}{it:eqno}{cmd:]_b[}{it:varname}{cmd:]} (synonym:
{cmd:[}{it:eqno}{cmd:]_coef[}{it:varname}{cmd:]}) contains the value (to
machine precision) of the coefficient on {it:varname} from the most recently
fitted model (such as ANOVA, regression, Cox, logit, probit, and multinomial
logit).  See {findalias frcoefficients} for a description.

{phang}{cmd:_cons} is always equal to the number 1 when used directly and
refers to the intercept term when used indirectly, as in {cmd:_b[_cons]}.

{phang}{cmd:_n} contains the number of the current observation.

{phang}{cmd:_N} contains the total number of observations in the dataset or
the number of observations in the current {cmd:by()} group.

{phang}{cmd:_pi} contains the value of pi to machine precision.

{phang}{cmd:_rc} contains the value of the return code from the most recent
{cmd:capture} command; see {manhelp capture P}.

{phang}{cmd:[}{it:eqno}{cmd:]_se[}{it:varname}{cmd:]} contains the value (to
machine precision) of the standard error of the coefficient on {it:varname}
from the most recently fit model (such as ANOVA, regression, Cox, logit,
probit, and multinomial logit).  See
{findalias frcoefficients} for a complete description.

{pstd}
The {cmd:_n} and {cmd:_N} variables are useful for indexing observations or
generating sequences of numbers.  {cmd:_n} can act as a running counter within
a by-group, and {cmd:_N} acts as the total number within each by-group.

{pstd}
{cmd:_rc} is useful for programmers, particularly if you want to test a
command internal to a program without having the program terminate.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. display _pi}{p_end}
{phang}{cmd:. display cos(_pi)}{p_end}
{phang}{cmd:. range x 0 4*_pi 100}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. generate price2 = price[_n-1]}{p_end}
{phang}{cmd:. regress price mpg foreign rep78}{p_end}
{phang}{cmd:. display _b[mpg]}

{phang}{cmd:. mlogit rep78 gear_ratio displacement foreign}{p_end}
{phang}{cmd:. display [5]_b[foreign]}

{phang}{cmd:. webuse dollhill2, clear}{p_end}
{phang}{cmd:. by age (smokes), sort: generate wgt=pyears[_N]}{p_end}
