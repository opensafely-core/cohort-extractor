{smcl}
{* *! version 1.0.1  11feb2011}{...}
{* this hlp file called by nlcom.dlg}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{title:Examples of nonlinear expressions for {cmd:nlcom}}

    {title:Specification for single-equation models:}

{pmore}
Coefficients are referred to as {cmd:_b[}{it:varname}{cmd:]}.

{phang3}
{cmd:_b[x]/_b[y]}

{phang3}
{cmd:exp(_b[x] + _b[y])}


    {title:Specification for multiple-equation models:}

{pmore}
To specify a coefficient of an equation, use
{cmd:[}{it:equation}{cmd:]_b[}{it:varname}{cmd:]}.  In these
examples, A is an equation, and x and y are variable names.  

{phang3}
{cmd:[A]_b[x]/[A]_b[y]} 

{phang3}
{cmd:exp([A]_b[x] + [A]_b[y])}{p_end}
