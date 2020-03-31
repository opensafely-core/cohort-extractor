{smcl}
{* *! version 1.0.0  14jun2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frlink" "help frlink"}{...}
{vieweralsosee "[D] frget" "help frlink"}{...}
{vieweralsosee "[FN] Programming functions" "help f_frval"}{...}
{vieweralsosee "[M-5] st_frame*()" "help mf_st_frame"}{...}
{viewerjumpto "Syntax" "_frames##syntax"}{...}
{viewerjumpto "Description" "_frames##description"}{...}
{viewerjumpto "Stored results" "_frames##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] _frames} {hline 2}}Utilities for manipulation of data frames{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{cmd:_frame} and {cmd:_frames} are synonyms.  Below, we will use one or
the other depending on which one is more natural given the context.


{pstd}
Display name of current (working) frame

{p 8 16 2}
{cmd:_frame}


{pstd}
Display names of all existing frames

{p 8 16 2}
{cmd:_frames} {cmd:dir} 


{pstd}
Create new frame (without making it the current frame)

{p  8 16 2}
{cmd:_frame} {cmd:create} {it:newframename}


{pstd}
Change identity of current (working) frame

{p 8 16 2}
{cmd:_frame} {cmd:change} {it:framename}


{pstd}
Rename existing frame (which can be the current frame)

{p 8 16 2}
{cmd:_frame} {cmd:rename} {it:oldframename} {it:newframename}


{pstd}
Drop (eliminate) frame that is not the current frame

{p 8 16 2}
{cmd:_frame} {cmd:drop} {it:framename}


{pstd}
Drop (eliminate) all frames except the current frame

{p 8 16 2}
{cmd:_frames} {cmd:dropabc}{bind:        }({cmd:abc}
stands for "all but current")


{pstd}
Reset Stata to contain one empty frame named {cmd:default}

{p 8 16 2}
{cmd:_frames} {cmd:reset}


{pstd}
Copy (duplicate) complete contents from one frame to another 
frame, clearing the previous contents of the target frame if necessary

{p 8 16 2}
{cmd:_frame} {cmd:copy} {it:framename_from} {it:framename_to}


{pstd}
Copy selected variables from the current frame to a new frame

{p 8 16 2}
{cmd:_frame} {cmd:put} {varlist}, {opt frame(framename)}


{pstd}
Copy observations that satisfy specified condition from the current frame to
a new frame

{p 8 16 2}
{cmd:_frame} {cmd:put} {help if:{bf:if} {it:exp}}{cmd:,} {opt frame(framename)}


{pstd}
Copy a range of observations from the current frame to a new frame

{p 8 16 2}
{cmd:_frame} {cmd:put} {help in:{bf:in} {it:range}}
[{help if:{bf:if} {it:exp}}]{cmd:,} {opt frame(framename)}


{phang}
{cmd:by} is allowed with the second syntax of {cmd:_frame} {cmd:put};
see {manhelp by D}.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:_frames} commands are used by StataCorp in 
certifying and debugging Stata and are used by some of 
Stata's ado-files, such as {helpb frames}. 

{pstd}
{cmd:_frame} is a synonym for {cmd:_frames}.  You may code either.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_frames} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(Nused)}}{it:#} of frame slots used{p_end}
{synopt:{cmd:r(Ntmp)}}{it:#} of frames with temporary names{p_end}
{synopt:{cmd:r(Nfree)}}{it:#} of frame slots still available{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(current)}}name of current frame{p_end}

{pstd}
{cmd:_frames dir} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(contents)}}names of existing frames{p_end}
{p2colreset}{...}
