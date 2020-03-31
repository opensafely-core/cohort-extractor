{smcl}
{* *! version 1.0.0  19jun2019}{...}
{vieweralsosee "[D] frame prefix" "mansection D frameprefix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{viewerjumpto "Syntax" "frame_prefix##syntax"}{...}
{viewerjumpto "Description" "frame_prefix##description"}{...}
{viewerjumpto "Links to PDF documentation" "frame_prefix##linkspdf"}{...}
{viewerjumpto "Remarks" "frame_prefix##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frame prefix} {hline 2}}The frame prefix command{p_end}
{p2col:}({mansection D frameprefix:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:frame} {it:framename}{cmd::} {it:stata_command}


{p 8 16 2}
{cmd:frame} {it:framename} {cmd:{c -(}}
{p_end}
{p 16 24 2}
{it:commands to execute in context of framename}
{p_end}
{p 8 16 2}
{cmd:{c )-}}
{p_end}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:frame} prefix allows you to execute one or more Stata commands
in another frame, leaving the current frame unchanged.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D frameprefixQuickstart:Quick start}

        {mansection D frameprefixRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help frame_prefix##interactive:Example of interactive use}
	{help frame_prefix##program:Example of use in programs}


{marker interactive}{...}
{title:Example of interactive use}

{pstd}
You have data in two frames.  In your current frame you have data
containing detailed information on sales for your company across four
regions.  A colleague just sent you an email with a summary dataset
named {cmd:sales.dta}, which is supposed to contain the total sales
for each region.  You want to make sure the summary dataset was created
from the same base sales information as the detailed dataset.

{pstd}
In your current dataset, you know from {cmd:summarize} that the total
sales for the South region were $532,399 and the total cost of the goods
sold was $330,499.  You check that the dataset you just received matches
these totals:

{phang2}{cmd:. frame create summary}{p_end}
{phang2}{cmd:. frame summary: use sales}{p_end}
{phang2}{cmd:. frame summary: list if region=="South"}{p_end}

{pstd}
The {cmd:frame} prefix command allowed you to load a dataset in frame
{cmd:summary} and run a command on that data without affecting anything
in your current frame.


{marker program}{...}
{title:Example of use in programs}

{pstd}
The {cmd:frame} prefix can be used for one-liners, such as above, or
it can be used to execute a whole series of commands on the data
in another frame.  The nice thing in either case is that no matter
what happens when those commands are executed, whether they
complete successfully or exit with error, the current frame will
come back to what it was before you called the {cmd:frame} prefix
command.  In programs, this means that you do not have to hold on
to the current frame name and change back to it after working
in another frame.

{pstd}
You are writing a program that takes a subset of the current data,
performs some manipulations on that subset, and then graphs the result.
The required manipulations would damage the original dataset.  One
way to do this would be to

{pstd}
1. create a temporary frame:

{phang2}{cmd:tempname tmpframe}{p_end}

{pstd}
2. put a subset of data into it:

{phang2}{cmd:frame put if} ... {cmd:, into(`tmpframe')}{p_end}

{pstd}
3. perform the needed manipulations and graph the result:

{phang2}{cmd:frame `tmpframe' {c -(}}{p_end}
{phang3}{it:some commands which manipulate the data}{p_end}
{phang3}{cmd:graph twoway} ...{p_end}
{phang2}{c )-}{p_end}

{pstd}
At the end of this block of code, any commands that appear next
will work against the original frame, not {cmd:`tmpframe'}.  You
could add a line to drop {cmd:`tmpframe'}, but there is
no need.  Because it has a temporary name, the frame and the data in it
will automatically be dropped when your program or do-file completes.

{pstd}
An alternative workflow for the above would be to first {cmd:preserve}
your data, then manipulate them in place and obtain your graph.  You
could then {cmd:restore} the original data.  Whether you should use
the {cmd:frame} prefix approach or the {cmd:preserve} and {cmd:restore}
approach is up to you.  The {cmd:frame} approach is often faster,
but if your dataset in memory is extremely large, you may not want to
make another entire copy of it in memory, even temporarily, and thus, the
second approach may be better in such a case.
{p_end}
