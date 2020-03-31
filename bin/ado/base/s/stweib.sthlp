{smcl}
{* *! version 1.0.2  11feb2011}{...}
{title:Out-of-date command}

{pstd}
As of Stata 6.0, the commands listed above are out of date.

{pstd}
The replacement is {cmd:streg}; see {manhelp streg ST}.

{pstd}
{cmd:stereg} can now be done as
{cmd:streg} {it:...} {cmd:, dist(exponential)} {it:...}

{pstd}
{cmd:stweib} can now be done as
{cmd:streg} {it:...} {cmd:, dist(weibull)} {it:...}
{p_end}
