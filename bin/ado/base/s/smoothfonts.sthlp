{smcl}
{* *! version 1.1.2  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "smoothfonts##syntax"}{...}
{viewerjumpto "Description" "smoothfonts##description"}{...}
{title:Title}

{phang}Set font smoothing for Stata windows (Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set} {cmdab:smoothf:onts} {c -(} {cmd:on} | {cmd:off} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set smoothfonts} enables or disables font smoothing (antialiased text)
in the Results, Viewer, and Data Editor windows.

{pstd}
Disabling font smoothing does not work well for all fonts.  Fonts that do
not contain an italic variant will render especially poorly because the
operating system has to simulate italics by slanting the text.

{pstd}
The default value of {cmd:smoothfonts} is {cmd:on}.
{p_end}
