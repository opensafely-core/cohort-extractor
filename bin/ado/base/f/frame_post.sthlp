{smcl}
{* *! version 1.0.0  14jun2019}{...}
{vieweralsosee "[P] frame post" "mansection P framepost"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frame create" "help frame_create"}{...}
{vieweralsosee "[P] postfile" "help postfile"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] simulate" "help simulate"}{...}
{viewerjumpto "Syntax" "frame_post##syntax"}{...}
{viewerjumpto "Description" "frame_post##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_post##linkspdf"}{...}
{viewerjumpto "Remarks" "frame_post##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] frame post} {hline 2}}Post results to dataset in another frame{p_end}
{p2col:}({mansection P framepost:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Create new frame with specified variables for use with {cmd:frame} {cmd:post}

{p 8 16 2}
{cmd:frame} {cmd:create} {it:newframename} {it:{help newvarlist}}


{pstd}
Add new observation to declared frame

{p 8 16 2}
{cmd:frame} {cmd:post} {it:framename} {cmd:(}{it:{help exp}}{cmd:)}
{cmd:(}{it:exp}{cmd:)} {it:...} {cmd:(}{it:exp}{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
These commands are utilities to assist Stata programmers in performing
Monte Carlo-type experiments.  They are similar to Stata's {cmd:postfile}
facilities (see {manhelp postfile P}) but operate on a dataset in a frame
in memory rather than on disk.

{pstd}
{cmd:frame} {cmd:create} declares the variable names and frame name
of a new Stata frame where results will be stored.  

{pstd}
{cmd:frame} {cmd:post} adds a new observation to the dataset in the
declared frame.

{pstd}
After you have posted all the observations you wish to the declared
frame, you should {cmd:save} the data in it to disk; see {manhelp save D}.

{pstd}
These commands manipulate the data in the new frame without disturbing
the data in memory in the current frame.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P framepostRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The typical use of the {cmd:frame} {cmd:post} command is

	{cmd:tempname memhold}
	{it:...}
	{cmd:frame create `memhold'} {it:...}
	{it:...}
	{cmd:while} {it:...} {cmd:{c -(}}
		{it:...}
		{cmd:frame post `memhold'} {it:...}
		{it:...}
	{cmd:{c )-}}
	{cmd:save} {it:...}
	{it:...}

{pstd}
In our example, we obtain the new frame name from Stata's temporary name
facility (see {helpb macro:[P] macro}).
We recommend that {it:newframename} usually be obtained from {cmd:tempname}.
This ensures that your program can be nested within any other
program and ensures that the memory used by {cmd:frame} {cmd:post} is freed
if anything goes wrong.  You can of course substitute a hard-coded
{it:newframename} for some programming situations.

{pstd}
Because {cmd:frame} {cmd:create} accepts a {it:{help newvarlist}}, storage
types may be interspersed, so you could have

{phang2}
        {cmd:frame create `memhold' a b str20 c double(d e f)}

{pstd}
Note that {cmd:frame} {cmd:create} allows {cmd:strL} as a variable storage
type, unlike {helpb postfile}.
{p_end}
