{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame drop" "mansection D framedrop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frames reset" "help frames_reset"}{...}
{viewerjumpto "Syntax" "frame_drop##syntax"}{...}
{viewerjumpto "Menu" "frame_drop##menu"}{...}
{viewerjumpto "Description" "frame_drop##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_drop##linkspdf"}{...}
{viewerjumpto "Example" "frame_drop##example"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] frame drop} {hline 2}}Drop frame from memory{p_end}
{p2col:}({mansection D framedrop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{cmd:frame} {cmd:drop} {it:framename}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:drop} eliminates from memory the specified frame, including
any data that are in that frame.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framedropRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Drop a frame named {cmd:counties}{p_end}
{phang2}{cmd:. frame drop counties}{p_end}
