{smcl}
{* *! version 1.1.3  13jun2019}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "pinnable##syntax"}{...}
{viewerjumpto "Description" "pinnable##description"}{...}
{viewerjumpto "Option" "pinnable##option"}{...}
{title:Title}

{phang}Specify whether to enable pinnable window behavior for Windows
(Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set pinnable} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set pinnable} specifies whether to enable the use of pinnable window 
characteristics for certain windows in Stata.  This command 
applies only to Windows computers.

{pstd}
{cmd:on} specifies that the user can pin or unpin certain windows.
{cmd:off} specifies that the user cannot pin or unpin windows.  
The default value of {cmd:pinnable} is {cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Stata.
{p_end}
