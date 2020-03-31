{smcl}
{* *! version 1.1.5  11may2018}{...}
{findalias asfrexp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[FN] Functions by category" "help functions"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 13.2 Operators" "help operators"}{...}
{vieweralsosee "[U] 13.7 Explicit subscripting" "help subscripting"}{...}
{vieweralsosee "[U] 18.3.5 Double quotes" "help quotes"}{...}
{viewerjumpto "Remarks" "exp##remarks"}{...}
{viewerjumpto "Examples" "exp##examples"}{...}
{title:Title}

{pstd}
{findalias frexp}


{marker remarks}{...}
{title:Remarks}

{pstd}
Algebraic and string expressions are specified in a natural way using the
standard rules of hierarchy.  You may use parentheses freely to force a
different order of evaluation.

{pstd}
For example:

{phang2}{cmd:. generate new = myv+2/oth}

{pstd}
is interpreted as

{phang2}{cmd:. generate new = myv+(2/oth)}

{pstd}
If you wanted (myv+2)/oth, you could type

{phang2}{cmd:. generate new = (myv+2)/oth}


{pstd}
Expressions are found in several places in the Stata language; see
{help language}.  The "{cmd:=}{it:exp}" language element is demonstrated above
with the {helpb generate} command.  The "{cmd:if} {it:exp}" language element is
another place where expressions are allowed.  Almost all Stata commands allow
the "{cmd:if} {it:exp}".  For instance, in

{phang2}{cmd:. summarize mrg dvc if region=="West" & mrg>.02}

{pstd}
the {cmd:region=="West" & mrg>.02} is a logical expression.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. generate weight2 = weight^2}

{phang}{cmd:. webuse census12, clear}{p_end}
{phang}{cmd:. summarize marriage_rate divorce_rate if region == "West" &}
          {cmd:marriage_rate > .015}

{phang}{cmd:. drop _all}{p_end}
{phang}{cmd:. set obs 10}{p_end}
{phang}{cmd:. generate x = _n^3 - 10*_n^2 + 5*_n}{p_end}
{phang}{cmd:. generate z = x + 50*rnormal()}{p_end}
