{smcl}
{* *! version 1.1.3  29jan2019}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "varkeyboard##syntax"}{...}
{viewerjumpto "Description" "varkeyboard##description"}{...}
{viewerjumpto "Option" "varkeyboard##option"}{...}
{title:Title}

{phang}Set the keyboard navigation behavior for the Variables and History windows
(Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set varkeyboard} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]

{p 8 22 2}
	{cmd:set revkeyboard} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set varkeyboard} sets the keyboard navigation behavior for the Variables
window.  {cmd:set revkeyboard} sets the keyboard navigation behavior for the
History window.  These commands apply only to Mac computers.

{pstd}
{cmd:on} indicates that you can use the keyboard to navigate and enter items
from the Variables or History window into the Command window.  {cmd:off}
indicates that all keyboard input be directed at the Command window; items
can only be entered from the Variables or History window by using the mouse.
The default value for {cmd:varkeyboard} and {cmd:revkeyboard} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
