{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame pwf" "mansection D framepwf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{viewerjumpto "Syntax" "frame_pwf##syntax"}{...}
{viewerjumpto "Menu" "frame_pwf##menu"}{...}
{viewerjumpto "Description" "frame_pwf##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_pwf##linkspdf"}{...}
{viewerjumpto "Example" "frame_pwf##example"}{...}
{viewerjumpto "Stored results" "frame_pwf##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] frame pwf} {hline 2}}Display name of current (working) frame{p_end}
{p2col:}({mansection D framesdir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:frame} {cmd:pwf}

{p 8 16 2}
{cmd:frame}

{p 8 16 2}
{cmd:pwf}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:pwf} displays the name of the current frame, also
known as the working frame.  {cmd:frame} by itself and {cmd:pwf}
(print working frame) by itself are synonyms for {cmd:frame} {cmd:pwf}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framepwfRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Display current frame{p_end}

{phang2}{cmd:. frame pwf}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:frame pwf} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(currentframe)}}name of current (working) frame{p_end}
