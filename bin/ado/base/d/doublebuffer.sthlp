{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "doublebuffer##syntax"}{...}
{viewerjumpto "Description" "doublebuffer##description"}{...}
{viewerjumpto "Option" "doublebuffer##option"}{...}
{title:Title}

{phang}
Set double buffering for Stata windows (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set} {cmdab:doublebuffer} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set doublebuffer} enables or disables double buffering of the Results,
Viewer, and Data Editor windows.  Double buffering prevents the windows from
flickering when redrawn or resized.  Users who encounter performance problems
such as the Results window outputting very slowly should disable double
buffering.

{pstd}
The default value of {cmd:doublebuffer} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
