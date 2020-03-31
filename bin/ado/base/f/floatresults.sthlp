{smcl}
{* *! version 1.1.2  04feb2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "floatresults##syntax"}{...}
{viewerjumpto "Description" "floatresults##description"}{...}
{title:Title}

{phang}
Specify whether to enable a floating Results window (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set floatresults} {c -(} {cmd:on} | {cmd:off} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set floatresults} specifies whether to enable floating window behavior 
for the Results window.  The term "float" in this context means the Results
window will always float over the main Stata window.  When floating, the 
Results window can never be placed behind the main Stata window but is not 
bounded by the main Stata window.  

{pstd}
{cmd:on} specifies that the Results window floats above the main Stata window.
{cmd:off} specifies that the Results window will not float above the
main Stata window.  The default value of {cmd:floatresults} is {cmd:off}.
{p_end}
