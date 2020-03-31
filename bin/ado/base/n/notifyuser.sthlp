{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "notifyuser##syntax"}{...}
{viewerjumpto "Description" "notifyuser##description"}{...}
{viewerjumpto "Option" "notifyuser##option"}{...}
{title:Title}

{phang}
Set the Notification Manager behavior for Stata (Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set notifyuser} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set notifyuser} sets the Notification Manager behavior for Stata.  When
a command has finished executing in Stata and the Stata application is in the
background, Stata uses the Notification Manager to alert the user by bouncing
the Stata icon in the Dock if {cmd:notifyuser} is enabled.  When
{cmd:notifyuser} is disabled, Stata does not attempt to alert the user by
bouncing the Stata icon in the Dock.

{pstd}
The default value of {cmd:notifyuser} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
