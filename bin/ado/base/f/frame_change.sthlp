{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame change" "mansection D framechange"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frame prefix" "help frame_prefix"}{...}
{viewerjumpto "Syntax" "frame_change##syntax"}{...}
{viewerjumpto "Menu" "frame_change##menu"}{...}
{viewerjumpto "Description" "frame_change##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_change##linkspdf"}{...}
{viewerjumpto "Examples" "frame_change##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frame change} {hline 2}}Change identity of current (working) frame{p_end}
{p2col:}({mansection D framechange:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:frame} {cmd:change} {it:framename}


{p 8 16 2}
{cmd:cwf} {it:framename}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:change} makes the named frame current.  This means that
any commands you issue after {cmd:frame} {cmd:change} will run on the data
in that frame.

{pstd}
{cmd:cwf} (change working frame) is a synonym for
{cmd:frame} {cmd:change}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framechangeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Change to an existing frame named {cmd:cars}{p_end}
{phang2}{cmd:. frame change cars}{p_end}

{pstd}Look at the data in that frame{p_end}
{phang2}{cmd:. describe}{p_end}

{pstd}Change back to the {cmd:default} frame{p_end}
{phang2}{cmd:. frame change default}{p_end}
