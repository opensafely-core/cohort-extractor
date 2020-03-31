{smcl}
{* *! version 1.0.2  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frames reset" "mansection D framesreset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frame drop" "help frame_drop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{viewerjumpto "Syntax" "frames_reset##syntax"}{...}
{viewerjumpto "Menu" "frames_reset##menu"}{...}
{viewerjumpto "Description" "frames_reset##description"}{...}
{viewerjumpto "Links to PDF documentation" "frames_reset##linkspdf"}{...}
{viewerjumpto "Example" "frames_reset##example"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frames reset} {hline 2}}Drop all frames from memory{p_end}
{p2col:}({mansection D framesreset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:frames} {cmd:reset}


{p 8 16 2}
{cmd:clear} {cmd:frames}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frames} {cmd:reset} eliminates from memory all frames, including any
data in them.  It restores Stata to its initial state of having a single,
empty frame named {cmd:default}.  {cmd:clear} {cmd:frames} is a synonym
for {cmd:frames} {cmd:reset}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framesresetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Drop all frames{p_end}
{phang2}{cmd:. frames reset}{p_end}
