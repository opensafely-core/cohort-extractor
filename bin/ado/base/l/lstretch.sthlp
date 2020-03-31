{smcl}
{* *! version 1.1.0  20mar2015}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "lstretch##syntax"}{...}
{viewerjumpto "Description" "lstretch##description"}{...}
{viewerjumpto "Option" "lstretch##option"}{...}
{viewerjumpto "Examples" "lstretch##examples"}{...}
{title:Title}

{phang}
Specify whether to automatically widen the coefficient table


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set lstretch} [ {cmd:on} | {cmd:off} ]
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set lstretch} specifies whether to automatically widen the coefficient
table up to the width of the Results window to accommodate longer variable
names. The default behavior is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Prevent coefficient tables from widening to accommodate longer variable names

{phang2}
{cmd:. set lstretch off}
{p_end}

{pstd}
Reset the behavior to the default

{phang2}
{cmd:. set lstretch}
{p_end}
