{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "doublebuffer##syntax"}{...}
{viewerjumpto "Description" "doublebuffer##description"}{...}
{viewerjumpto "Option" "doublebuffer##option"}{...}
{title:Title}

{phang}Set the sound behavior for the Notification Manager in Stata
(Mac only)


{title:Syntax}

{p 8 22 2}
	{cmd:set playsnd} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently} ]


{title:Description}

{pstd}
{cmd:set playsnd} sets the sound behavior for the Notification Manager in
Stata.  When a command has finished executing in Stata and the Stata
application is in the background, Stata uses the Notification Manager to alert
the user by bouncing the Stata icon in the Dock.  When {cmd:playsnd} is
enabled, Stata plays a sound in addition to bouncing the Stata icon in the
Dock.

{pstd}
The default value of {cmd:playsnd} is {cmd:on}.


{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
