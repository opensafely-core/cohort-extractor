{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[P] trace" "mansection P trace"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] profiler" "help profiler"}{...}
{viewerjumpto "Syntax" "trace##syntax"}{...}
{viewerjumpto "Description" "trace##description"}{...}
{viewerjumpto "Links to PDF documentation" "trace##linkspdf"}{...}
{viewerjumpto "Options" "trace##options"}{...}
{viewerjumpto "Examples" "trace##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] trace} {hline 2}}Debug Stata programs{p_end}
{p2col:}({mansection P trace:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Whether to trace execution of programs

{phang2}{cmd:set} {cmdab:tr:ace} {c -(} {cmd:on} | {cmd:off} {c )-}


    Show {it:#} levels in tracing nested programs

{phang2}{cmd:set} {cmdab:traced:epth} {it:#}


    Whether to show the lines after macro expansion

{phang2}{cmd:set} {cmdab:tracee:xpand} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently} ]


    Whether to display horizontal separator lines

{phang2}{cmd:set} {cmdab:traces:ep} {c -(} {cmd:on} |
	{cmd:off} {c )-} [{cmd:,} {cmdab:perm:anently} ]


    Whether to indent lines according to nesting level

{phang2}{cmd:set} {cmdab:tracei:ndent} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently} ]


    Whether to display nesting level

{phang2}{cmd:set} {cmdab:tracen:umber} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently} ]


    Highlight pattern in trace output

{phang2}{cmd:set} {cmdab:traceh:ilite} {cmd:"}{it:pattern}{cmd:"}
	[{cmd:,} {cmd:word} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:trace} {cmd:on} traces the execution of programs for debugging.
{cmd:set} {cmd:trace} {cmd:off} turns off tracing after it has been set on.
                                                                                
{pstd}
{cmd:set} {cmd:tracedepth} specifies how many levels to descend in
tracing nested programs.  The default is {cmd:32000}, which is equivalent to
infinity.
                                                                                
{pstd}
{cmd:set} {cmd:traceexpand} indicates whether the lines before and after macro
expansion are to be shown.  The default is {cmd:on}.
                                                                                
{pstd}
{cmd:set} {cmd:tracesep} indicates whether to display a horizontal separator
line that displays the name of the subroutine whenever a subroutine is entered
or exited.  The default is {cmd:on}.
                                                                                
{pstd}
{cmd:set} {cmd:traceindent} indicates whether displayed lines of code should
be indented according to the nesting level.  The default is {cmd:on}.
                                                                                
{pstd}
{cmd:set} {cmd:tracenumber} indicates whether the nesting level should be
displayed at the beginning of the line.  Lines in the main program are
preceded with 01; lines in subroutines called by the main program, with 02;
etc.  The default is {cmd:off}.

{pstd}
{cmd:set} {cmd:tracehilite} causes the specified {it:pattern} to be
highlighted in the trace output.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P traceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the {cmd:traceexpand}, {cmd:tracesep}, {cmd:traceindent}, and 
{cmd:tracenumber} settings be remembered and become the default
settings when you invoke Stata.

{phang}
{cmd:word} highlights only tokens that are delimited by nonalphanumeric
characters.  These would include tokens at the beginning or end of each line
that are delimited by nonalphanumeric characters.


{marker examples}{...}
{title:Examples}

        {cmd:. cii proportions 10 1}

{pstd}Trace execution of programs{p_end}
{phang2}{cmd:. set trace on}

        {cmd:. cii proportions 10 1}

{pstd}Suppress printing of trace separator lines{p_end}
{phang2}{cmd:. set tracesep off}

        {cmd:. cii proportions 10 1}

{pstd}Turn on {cmd:tracesep}{p_end}
{phang2}{cmd:. set tracesep on}

{pstd}Suppress printing of lines after macro expansion{p_end}
{phang2}{cmd:. set traceexpand off}

        {cmd:. cii proportions 10 1}

{pstd}Turn on {cmd:traceexpand}{p_end}
{phang2}{cmd:. set traceexpand on}

{pstd}Display the nesting level{p_end}
{phang2}{cmd:. set tracenumber on}

        {cmd:. cii means 1 27, poisson}

{pstd}Do not indent lines of code according to their nesting level{p_end}
{phang2}{cmd:. set traceindent off}

        {cmd:. cii means 1 27, poisson}

{pstd}Turn off {cmd:tracenumber}{p_end}
{phang2}{cmd:. set tracenumber off}

{pstd}Turn on {cmd:traceindent}{p_end}
{phang2}{cmd:. set traceindent on}

{pstd}Highlight {cmd:poisson} in the code{p_end}
{phang2}{cmd:. set tracehilite poisson}

        {cmd:. cii means 1 27, poisson}

{pstd}Turn off {cmd:trace}{p_end}
{phang2}{cmd:. set trace off}{p_end}
