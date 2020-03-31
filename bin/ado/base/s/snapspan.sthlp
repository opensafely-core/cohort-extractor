{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog snapspan "dialog snapspan"}{...}
{vieweralsosee "[ST] snapspan" "mansection ST snapspan"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "snapspan##syntax"}{...}
{viewerjumpto "Menu" "snapspan##menu"}{...}
{viewerjumpto "Description" "snapspan##description"}{...}
{viewerjumpto "Links to PDF documentation" "snapspan##linkspdf"}{...}
{viewerjumpto "Options" "snapspan##options"}{...}
{viewerjumpto "Examples" "snapspan##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ST] snapspan} {hline 2}}Convert snapshot data to time-span data{p_end}
{p2col:}({mansection ST snapspan:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:snapspan} {it:idvar} {it:timevar} {varlist} [{cmd:,}
	{opt g:enerate(newt0var)} {opt replace}]


{phang}
{it:idvar} records the subject ID and may be string or numeric.

{phang}
{it:timevar} records the time of the snapshot; it must be numeric and may
be recorded on any scale:  date, hour, minute, second, etc.

{phang}
{varlist} are the "event" variables, meaning that they occur at the
instant of {it:timevar}.  {it:varlist} can also include retrospective
variables that are to apply to the time span ending at the time of
the current snapshot.  The other variables are assumed to be measured at the
time of the snapshot and thus apply from the time of the snapshot forward.
See {mansection ST snapspanRemarksandexamplesSpecifyingvarlist:{it:Specifying varlist}}
in {bf:[ST] snapspan}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
        {bf:Convert snapshot data to time-span data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:snapspan} converts snapshot data for a given subject to time-span data
required for use with survival analysis commands, such as {cmd:stcox},
{cmd:streg}, and {cmd:stset}.  {cmd:snapspan} replaces the data in the
specified variables. Transformed variables may be "events" that occur at the
instant of the snapshot or retrospective variables that are to apply to the
time span ending at the time of the current snapshot.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST snapspanQuickstart:Quick start}

        {mansection ST snapspanRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt generate(newt0var)} adds {it:newt0var} to the dataset containing the
entry time for each converted time-span record.

{phang}
{opt replace} specifies that it is okay to change the data in memory,
even though the dataset has not been saved on disk in its current form.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse snapspan}{p_end}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Convert snapshot data to time-span data{p_end}
{phang2}{cmd:. snapspan id time event}

{pstd}List the resulting data{p_end}
{phang2}{cmd:. list, sepby(id)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse snapspan, clear}

{pstd}Convert snapshot data to time-span data, creating {cmd:time0} containing
the entry time for each converted time-span record{p_end}
{phang2}{cmd:. snapspan id time event, generate(time0)}

{pstd}List the resulting data{p_end}
{phang2}{cmd:. list id time0 time x1 x2 event, sepby(id)}{p_end}
    {hline}
