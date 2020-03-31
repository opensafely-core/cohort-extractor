{smcl}
{* *! version 1.1.2  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "fastscroll##syntax"}{...}
{viewerjumpto "Description" "fastscroll##description"}{...}
{viewerjumpto "Option" "fastscroll##option"}{...}
{title:Title}

{phang}
Set the Results window scrolling method


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}{cmd:set fastscroll} { c -(} {cmd:on} | {cmd:off} {c )-}
		[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set fastscroll} sets the scrolling method for new output in the Results
window and is relevant only if you are using Stata for Windows or X-Windows in
Unix.  Stata for Mac always uses the {cmd:fastscroll} scrolling method and it
cannot be turned off.  The default value of {cmd:fastscroll} is {cmd:on}.

{pstd}
Setting {cmd:fastscroll} to {cmd:on} causes Stata to draw new output
several lines at a time resulting in very fast, but jumpy output.  Setting
{cmd:fastscroll} to {cmd:off} causes Stata to immediately draw new output
one line at a time, resulting in smoother but slower output.

{pstd}
Stata's performance is 5 to 10 times faster if {cmd:fastscroll} is {cmd:on}
because Stata spends less time waiting for output to be displayed.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
