{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frames dir" "mansection D framesdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "frames_dir##syntax"}{...}
{viewerjumpto "Menu" "frames_dir##menu"}{...}
{viewerjumpto "Description" "frames_dir##description"}{...}
{viewerjumpto "Links to PDF documentation" "frames_dir##linkspdf"}{...}
{viewerjumpto "Example" "frames_dir##example"}{...}
{viewerjumpto "Stored results" "frames_dir##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] frames dir} {hline 2}}Display names of all frames in memory{p_end}
{p2col:}({mansection D framesdir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:frames} {cmd:dir}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
{cmd:frames} {cmd:dir} lists all frames in memory, along with the dimensions
of the data, the label of the data in each (if any), and an indicator of
whether the data in the frame have changed since last saved.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D framesdirRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}See frames in memory{p_end}
{phang2}{cmd:. frames dir}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:frames} {cmd:dir} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(frames)}}names of frames in memory{p_end}
{synopt:{cmd:r(changed)}}{cmd:1} or {cmd:0} for each frame in memory: {cmd:1}
means the data in the frame have changed since last save; {cmd:0} means they
have not changed{p_end}
{p2colreset}{...}
