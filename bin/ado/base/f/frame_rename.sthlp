{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame rename" "mansection D framerename"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frame copy" "help frame_copy"}{...}
{viewerjumpto "Syntax" "frame_rename##syntax"}{...}
{viewerjumpto "Menu" "frame_rename##menu"}{...}
{viewerjumpto "Description" "frame_rename##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_rename##linkspdf"}{...}
{viewerjumpto "Examples" "frame_rename##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frame rename} {hline 2}}Rename existing frame{p_end}
{p2col:}({mansection D framerename:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:frame} {cmd:rename} {it:oldframename} {it:newframename}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd: rename} changes the name of an existing frame.  You can
even rename the current frame.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framerenameRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Rename the {cmd:default} frame to a new frame named {cmd:counties}{p_end}
{phang2}{cmd:. frame rename default counties}{p_end}

{pstd}Rename existing frame {cmd:cars} to {cmd:automobiles}{p_end}
{phang2}{cmd:. frame rename cars automobiles}{p_end}
