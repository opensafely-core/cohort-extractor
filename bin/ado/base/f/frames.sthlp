{smcl}
{* *! version 1.0.0  14jun2019}{...}
{viewerdialog "frames" "dialog frames"}{...}
{vieweralsosee "[D] frames" "mansection D frames"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[M-5] st_frame*()" "help mf_st_frame"}{...}
{viewerjumpto "Syntax" "frames##syntax"}{...}
{viewerjumpto "Menu" "frames##menu"}{...}
{viewerjumpto "Description" "frames##description"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] frames} {hline 2}}Data frames{p_end}
{p2col:}({mansection D frames:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{pstd}
If you are new to data frames in Stata, please start by reading
{helpb frames intro:[D] frames intro}.


{marker syntax}{...}
{title:Syntax}

{pstd}
{cmd:frame} and {cmd:frames} are synonyms.  Below, we will use one or
the other depending on which one is more natural given the context.


{pstd}
Display name of current (working) frame

{p 8 16 2}
{cmd:frame} {cmd:pwf}
{dup 36:{bind: }}(see {manhelp frame_pwf D:frame pwf})

{p 8 16 2}
{cmd:frame}

{p 8 16 2}
{cmd:pwf}


{pstd}
Display names of all frames in memory

{p 8 16 2}
{cmd:frames} {cmd:dir}
{dup 35:{bind: }}(see {manhelp frames_dir D:frames dir})


{pstd}
Create new, empty frame

{p 8 16 2}
{cmd:frame} {cmd:create} {it:newframename}
{bind:                    }(see {manhelp frame_create D:frame create})


{pstd}
Create new frame with specified variables for use with {cmd:frame} {cmd:post}

{p 8 16 2}
{cmd:frame} {cmd:create} {it:newframename} {it:{help newvarlist}}
{bind:         }(see {manhelp frame_post P:frame post})


{pstd}
Change identity of current (working) frame

{p 8 16 2}
{cmd:frame} {cmd:change} {it:framename}
{dup 23:{bind: }}(see {manhelp frame_change D:frame change})

{p 8 16 2}
{cmd:cwf} {it:framename}


{pstd}
Execute command on data in specified frame

{p 8 16 2}
{cmd:frame} {it:framename}{cmd::} {it:stata_command}
{dup 15:{bind: }}(see {manhelp frame_prefix D:frame prefix})

{p 8 16 2}
{cmd:frame} {it:framename} {cmd:{c -(}}
{p_end}
{p 16 24 2}
{it:commands to execute in context of framename}
{p_end}
{p 8 16 2}
{cmd:{c )-}}
{p_end}


{pstd}
Make a copy of a frame

{p 8 16 2}
{cmd:frame} {cmd:copy} {it:frame_from} {it:frame_to}
[{cmd:,}
{cmd:replace}]
{bind:   }(see {manhelp frame_copy D:frame copy})


{pstd}
Copy subset of variables or observations to a new frame

{p 8 16 2}
{cmd:frame} {cmd:put}
{dup 36:{bind: }}(see {manhelp frame_put D:frame put})


{pstd}
Add new observation to frame

{p 8 16 2}
{cmd:frame} {cmd:post} {it:framename} {cmd:(}{it:{help exp}}{cmd:)}
{cmd:(}{it:exp}{cmd:)} {it:...} {cmd:(}{it:exp}{cmd:)}
{bind:   }(see {manhelp frame_post P:frame post})


{pstd}
Drop (eliminate) frame that is not the current frame

{p 8 16 2}
{cmd:frame} {cmd:drop} {it:framename}
{dup 25:{bind: }}(see {manhelp frame_drop D:frame drop})


{pstd}
Rename existing frame (which can be the current frame)

{p 8 16 2}
{cmd:frame} {cmd:rename} {it:oldframename} {it:newframename}
{dup 7:{bind: }}(see {manhelp frame_rename D:frame rename})


{pstd}
Reestablish initial state of having a single, empty frame named {cmd:default}

{p 8 16 2}
{cmd:frames} {cmd:reset}
{dup 33:{bind: }}(see {manhelp frames_reset D:frames reset})


{pstd}
Link frames

{p 8 16 2}
{cmd:frlink}
{dup 39:{bind: }}(see {manhelp frlink D:frlink})


{pstd}
Get variables from linked frame

{p 8 16 2}
{cmd:frget}
{dup 40:{bind: }}(see {manhelp frget D:frget})


{pstd}
Functions to access variables in another frame

{p 8 16 2}
{cmd:frval(}{it:linkvar}{cmd:,} {varname}{cmd:)}
{dup 23:{bind: }}(see {helpb f_frval:help frval()})

{p 8 16 2}
{cmd:_frval(}{it:framename}{cmd:,} {varname}{cmd:,} {it:i}{cmd:)}


INCLUDE help menu_frames


{marker description}{...}
{title:Description}

{pstd}
This entry provides a quick reference to each of the individual commands and
functions related to data frames.

{pstd}
Data frames are discussed in detail in {helpb frames intro:[D] frames intro}.

{pstd}
There is also a set of Mata functions to work with frames.
See {manhelp mf_st_frame M-5:st_frame*()}.
{p_end}
