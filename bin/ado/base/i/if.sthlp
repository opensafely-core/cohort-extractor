{smcl}
{* *! version 1.1.3  07sep2011}{...}
{findalias asfrif}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11 Language syntax (the by prefix)" "help by"}{...}
{vieweralsosee "[U] 11.1.4 in range (the in qualifier)" "help in"}{...}
{viewerjumpto "Syntax" "if##syntax"}{...}
{viewerjumpto "Description" "if##description"}{...}
{viewerjumpto "Examples" "if##examples"}{...}
{title:Title}

{pstd}
{findalias frif}


{marker syntax}{...}
{title:Syntax}

	{it:command} {cmd:if} {it:exp}

{pstd}
{it:exp} in the syntax diagram means an expression, such as {hi:age>21}.
See {help exp} for an explanation of expressions.

{pstd}
There is another {cmd:if} used in Stata programming; see {manhelp ifcmd P:if}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:if} at the end of a command means the command is to use only the data
specified.  {cmd:if} is allowed with most Stata commands.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. list make mpg if mpg>25}{p_end}
{phang}{cmd:. list make mpg if mpg>25 & mpg<30}{p_end}
{phang}{cmd:. list make mpg if mpg>25 | mpg<10}{p_end}
{phang}{cmd:. regress mpg weight displ if foreign==1}


{pstd}
Equality tests are performed by two equal signs ({cmd:==}), not one {cmd:=};
see {help operators}.
{p_end}
