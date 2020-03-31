{smcl}
{* *! version 1.1.2  28feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "dockable##syntax"}{...}
{viewerjumpto "Description" "dockable##description"}{...}
{viewerjumpto "Option" "dockable##option"}{...}
{title:Title}

{phang}
Specify whether to enable dockable window behavior for Windows (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set dockable} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set dockable} specifies whether to enable the use of dockable window 
characteristics for certain windows in Stata.  Specifically, this includes the
ability to dock or tab a window into another window.  This command 
applies only to Windows computers.

{pstd}
{cmd:on} specifies that the user can use dockable characteristics of windows.
{cmd:off} specifies that the user cannot manipulate normal 
docking behavior.  The default value of {cmd:dockable} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Stata.
{p_end}
