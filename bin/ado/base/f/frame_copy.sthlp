{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame copy" "mansection D framecopy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frame put" "help frame_put"}{...}
{vieweralsosee "[D] frame rename" "help frame_rename"}{...}
{viewerjumpto "Syntax" "frame_copy##syntax"}{...}
{viewerjumpto "Menu" "frame_copy##menu"}{...}
{viewerjumpto "Description" "frame_copy##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_copy##linkspdf"}{...}
{viewerjumpto "Option" "frame_copy##option"}{...}
{viewerjumpto "Examples" "frame_copy##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] frame copy} {hline 2}}Make a copy of a frame{p_end}
{p2col:}({mansection D framecopy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:frame} {cmd:copy} {it:frame_from} {it:frame_to}
[{cmd:,} {cmd:replace}]


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:copy} copies an existing frame to a frame with a new
name or to an existing frame, replacing its contents.  All data and
metadata from {it:frame_from} are copied.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framecopyQuickstart:Quick start}

        {mansection D framecopyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt replace} specifies that {it:frame_to} be replaced if it already
exists.


{marker examples}{...}
{title:Examples}

{pstd}Copy the {cmd:default} frame to a new frame named {cmd:counties}{p_end}
{phang2}{cmd:. frame copy default counties}{p_end}

{pstd}Copy a frame to an existing frame named {cmd:cars}, replacing it{p_end}
{phang2}{cmd:. frame copy automobiles cars, replace}{p_end}

{pstd}Copy a frame in a program to a temporary name{p_end}
{phang2}{cmd:. tempname newframe}{p_end}
{phang2}{cmd:. frame copy counties `newframe'}{p_end}
