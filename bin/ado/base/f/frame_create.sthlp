{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frame create" "mansection D framecreate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[P] frame post" "help frame_post"}{...}
{viewerjumpto "Syntax" "frame_create##syntax"}{...}
{viewerjumpto "Menu" "frame_create##menu"}{...}
{viewerjumpto "Description" "frame_create##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_create##linkspdf"}{...}
{viewerjumpto "Examples" "frame_create##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frame create} {hline 2}}Create a new frame{p_end}
{p2col:}({mansection D framecreate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Create new, empty frame

{p 8 16 2}
{cmd:frame} {cmd:create} {it:newframename}

{p 8 16 2}
{cmd:mkf} {it:newframename}


{pstd}
Create new frame with specified variables

{p 8 16 2}
{cmd:frame} {cmd:create} {it:newframename} {it:{help newvarlist}}
{bind:         }(see {manhelp frame_post P:frame post})


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frame} {cmd:create} creates a new, empty frame.

{pstd}
{cmd:mkf} (make frame) is a synonym for {cmd:frame} {cmd:create}. 

{pstd}
{cmd:frame} {cmd:create} with a {it:{help newvarlist}} creates a
new frame with the specified variables.  This syntax is most often used
in combination with {cmd:frame post} for posting results in a new
frame, see {manhelp frame_post P:frame post}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framecreateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Create a new frame named {cmd:cars}{p_end}
{phang2}{cmd:. frame create cars}{p_end}

{pstd}Load the 1978 Automobile Data into the new frame{p_end}
{phang2}{cmd:. frame cars: use auto.dta}{p_end}

{pstd}
We could have typed {helpb webuse} or {helpb sysuse} in place of {cmd:use}
above.
{p_end}
