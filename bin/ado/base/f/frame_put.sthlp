{smcl}
{* *! version 1.0.1  13jan2020}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame put" "mansection D frameput"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] drop" "help drop"}{...}
{vieweralsosee "[D] frame copy" "help frame_copy"}{...}
{vieweralsosee "[P] frame post" "help frame_post"}{...}
{viewerjumpto "Syntax" "frame_put##syntax"}{...}
{viewerjumpto "Menu" "frame_put##menu"}{...}
{viewerjumpto "Description" "frame_put##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_put##linkspdf"}{...}
{viewerjumpto "Examples" "frame_put##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] frame put} {hline 2}}Copy selected variables or observations to a new frame{p_end}
{p2col:}({mansection D frameput:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Copy selected variables from the current frame to a new frame

{p 8 16 2}
{cmd:frame} {cmd:put} {varlist}, {opt into(newframename)}


{pstd}
Copy observations that satisfy specified condition from the current frame to
a new frame

{p 8 16 2}
{cmd:frame} {cmd:put} [{varlist}] {it:{help if}}{cmd:,}
{opt into(newframename)}


{pstd}
Copy a range of observations from the current frame to a new frame

{p 8 16 2}
{cmd:frame} {cmd:put} [{varlist}] {it:{help in}}
[{it:{help if}}]{cmd:,} {opt into(newframename)}


{phang}
{cmd:by} is allowed with the second syntax of {cmd:frame} {cmd:put};
see {manhelp by D}.


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:put} copies a subset of variables or observations
from the current frame to the specified frame.  It works much like
Stata's {cmd:keep} command (see {manhelp drop D}), except that the
data in the current frame are left unchanged, while the selected
variables or observations are copied to a new frame.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D frameputQuickstart:Quick start}

        {mansection D frameputRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse census}{p_end}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}{p_end}

{pstd}Put data from several variables for all states with a population greater than
5,000,000 into new frame {cmd:pop5}{p_end}
{phang2}{cmd:. frame put state region pop* medage death if pop > 5000000, into(pop5)}{p_end}

{pstd}Describe the data in frame {cmd:pop5}{p_end}
{phang2}{cmd:. frame pop5: describe}{p_end}
