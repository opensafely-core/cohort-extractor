{smcl}
{* *! version 1.1.3  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "floatwindows##syntax"}{...}
{viewerjumpto "Description" "floatwindows##description"}{...}
{title:Title}

{phang}
Specify whether to enable floating window behavior for Windows (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set floatwindows} {c -(} {cmd:on} | {cmd:off} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set floatwindows} specifies whether to enable floating window behavior 
for dialog boxes and dockable windows. 
The term "float" in this context means that a window will always float over
the main Stata window. When floating, these windows cannot be placed 
behind the main Stata window.

{pstd}
{cmd:on} specifies that windows will float above the main Stata window.
{cmd:off} specifies that windows will not be constrained to float above the
main Stata window.  The default value of {cmd:floatwindows} is {cmd:off}.
{p_end}
