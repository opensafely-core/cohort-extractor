{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[R] level" "mansection R level"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "level##syntax"}{...}
{viewerjumpto "Description" "level##description"}{...}
{viewerjumpto "Links to PDF documentation" "level##linkspdf"}{...}
{viewerjumpto "Option" "level##option"}{...}
{viewerjumpto "Remarks" "level##remarks"}{...}
{viewerjumpto "Note concerning estimation commands" "level##note"}{...}
{viewerjumpto "Examples" "level##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] level} {hline 2}}Set default confidence level{p_end}
{p2col:}({mansection R level:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:set} {opt l:evel} {it:#} [{cmd:,} {opt perm:anently}]

{phang}
{it:#} is any number between 10.00 and 99.99 and may be specified with at most
two digits after the decimal point.

{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:level} specifies the default confidence level for confidence
intervals for all commands that report confidence intervals.  The initial
value is 95, meaning 95% confidence intervals.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R levelRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the {cmd:level} setting be remembered and become the default setting when you
invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
To change the level of confidence intervals reported by a particular command,
you need not reset the default confidence level.  All commands that report
confidence intervals have a {opt level(#)} option.  When you do not
specify the option, the confidence intervals are calculated for the default
level set by {cmd:set} {cmd:level} or for 95% if you have not reset it.


{marker note}{...}
{title:Note concerning estimation commands}

{pstd}
All estimation commands can redisplay results when they are typed
without arguments; see {help estcom}.  The width of the reported confidence
intervals is a property of the display, not the estimation.  For example,

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight displ}{break}
        (output appears)

{phang2}{cmd:. regress, level(90)}{break}
       (output reappears, this time with 90% confidence intervals)


{marker examples}{...}
{title:Examples}

{phang}{cmd:. set level 90}

{phang}{cmd:. set level 99, permanently}
{p_end}
