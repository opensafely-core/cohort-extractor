{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "xptheme##syntax"}{...}
{viewerjumpto "Description" "xptheme##description"}{...}
{viewerjumpto "Option" "xptheme##option"}{...}
{title:Title}

{pstd}Determine how visual styles are implemented in Stata on Windows XP
(Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set xptheme} {c -(} {cmd:on} | {cmd:off} {c )-}
	{cmd:,} {cmdab:perm:anently}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set xptheme} determines how visual styles are implemented in Stata when
running in Windows XP.  This command applies only to Windows computers and has
no effect on versions of Windows before Windows XP.

{pstd}
{cmd:on} specifies that the XP visual style be applied to Stata.
{cmd:off} specifies that the Windows Classic visual style be applied to Stata,
which allows programmable dialogs to load faster.

{pstd}
Stata must be restarted for the setting to take effect.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{cmd:permanently} is required.
{p_end}
