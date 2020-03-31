{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] rmsg" "help rmsg"}{...}
{vieweralsosee "[P] timer" "help timer"}{...}
{vieweralsosee "[P] trace" "help trace"}{...}
{viewerjumpto "Syntax" "profiler##syntax"}{...}
{viewerjumpto "Description" "profiler##description"}{...}
{viewerjumpto "Examples" "profiler##examples"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] profiler} {hline 2} Profile Stata programs by recording and reporting
time spent in each program


{marker syntax}{...}
{title:Syntax}

	{cmd:profiler} {cmd:on}

	{cmd:profiler} {cmd:off}

	{cmd:profiler} {cmd:clear}

	{cmd:profiler} {cmd:report}


{marker description}{...}
{title:Description}

{pstd}
{cmd:profiler} is a programmer's command that can help in optimizing ado-files
and other Stata programs.  When profiling is turned on, {cmd:profiler on},
Stata begins keeping a record of each time a program is run and how much time
is spent in the program.  The record includes only the time spent directly in
a program and not time spent in other programs that are themselves invoked by
the program -- these latter times are recorded with the invoked program.

{pstd}
{cmd:profiler report} produces a report of the number of times each program
has been invoked and a running total of the amount of time spent in that
program while profiling is on.

{pstd}
{cmd:profiler off} turns off profiling, counting program invocations and
times, but does not clear the registers.  If {cmd:profiler on} is typed after
turning profiling off, the original record is retained and new timings are
added into this record.

{pstd}
{cmd:profiler clear} clears the profiling record; that is, it sets all
timings and counters to 0.  If profiling is on, it remains on; if profiling is
off, it remains off.


{marker examples}{...}
{title:Examples}

{pstd}To profile heckman.ado and all programs it invokes:

{phang2}{cmd:. profiler on}{p_end}
{phang2}{cmd:. heckman ...}{p_end}
{phang2}{cmd:. profiler off}{p_end}
{phang2}{cmd:. profiler report}{p_end}
