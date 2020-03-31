{smcl}
{* *! version 1.3.3  19oct2017}{...}
{viewerdialog tsreport "dialog tsreport"}{...}
{vieweralsosee "[TS] tsreport" "mansection TS tsreport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "tsreport##syntax"}{...}
{viewerjumpto "Menu" "tsreport##menu"}{...}
{viewerjumpto "Description" "tsreport##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsreport##linkspdf"}{...}
{viewerjumpto "Options" "tsreport##options"}{...}
{viewerjumpto "Examples" "tsreport##examples"}{...}
{viewerjumpto "Video example" "tsreport##video"}{...}
{viewerjumpto "Stored results" "tsreport##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] tsreport} {hline 2}}Report time-series aspects of a dataset 
or estimation sample{p_end}
{p2col:}({mansection TS tsreport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:tsreport} [{varlist}] {ifin} [{cmd:,} {it:options}]

{synoptset 15 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt d:etail}}list periods for each gap{p_end}
{synopt :{opt c:asewise}}treat a period as a gap if any of the specified
              variables are missing{p_end}
{synopt :{opt p:anel}}do not count panel changes as gaps{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Setup and utilities >}
    {bf:Report time-series aspects of dataset}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsreport} reports time gaps in a dataset or in a subset of variables.  By
default, {cmd:tsreport} reports periods in which no information is recorded in
the dataset; the time variable does not include these periods.  When you
specify {varlist}, {cmd:tsreport} reports periods in which either
no information is recorded in the dataset or the time variable is present, but
one or more variables in {it:varlist} contain a missing value.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsreportQuickstart:Quick start}

        {mansection TS tsreportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt detail} reports the beginning and ending times of each gap.

{phang}
{opt casewise} specifies that a period for which any of the specified
variables are missing be counted as a gap.  By default, gaps are reported for 
each variable individually.

{phang}
{opt panel} specifies that panel changes not be counted as gaps.  Whether
panel changes are counted as gaps usually depends on how the calling command
handles panels.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tsrptxmpl}{p_end}

{pstd}Report gaps in time series{p_end}
{phang2}{cmd:. tsreport}{p_end}

{pstd}Report start and end times of each gap in time series{p_end}
{phang2}{cmd:. tsreport, detail}

{pstd}Report start and end times of each gap in time series, ignoring
panel changes{p_end}
{phang2}{cmd:. tsreport, panel detail}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hotelprice}{p_end}

{pstd}Report gaps in time series{p_end}
{phang2}{cmd:. tsreport}{p_end}

{pstd}Report start and end times of each gap where variables are not observed{p_end}
{phang2}{cmd:. tsreport price1 price2, detail}{p_end}

{pstd}Report start and end times of each gap where variables are not observed,
using casewise selection{p_end}
{phang2}{cmd:. tsreport price1 price2, casewise detail}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=SOQvXICIRNY":Formatting and managing dates}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsreport}, when no {it:varlist} is specified or when {cmd:casewise} is specified,
stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:r(N_obs)}}number of observations{p_end}
{synopt:{cmd:r(start)}}first time in series{p_end}
{synopt:{cmd:r(end)}}last time in series{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(panelvar)}}name of panel variable{p_end}
{synopt:{cmd:r(timevar)}}name of time variable{p_end}
{synopt:{cmd:r(tsfmt)}}{cmd:%}{it:fmt} of time variable{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing start and end times of each gap, if {cmd:detail} is specified{p_end}
{p2colreset}{...}


{pstd}
{cmd:tsreport}, when a {it:varlist} is specified and {cmd:casewise} is not
specified, stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_gaps}{it:#}{cmd:)}}number of gaps for variable {it:#}{p_end}
{synopt:{cmd:r(N_obs}{it:#}{cmd:)}}number of observations for variable {it:#}{p_end}
{synopt:{cmd:r(start}{it:#}{cmd:)}}first time in series for variable {it:#}{p_end}
{synopt:{cmd:r(end}{it:#}{cmd:)}}last time in series for variable {it:#}{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(panelvar)}}name of panel variable{p_end}
{synopt:{cmd:r(timevar)}}name of time variable{p_end}
{synopt:{cmd:r(tsfmt)}}{cmd:%}{it:fmt} of time variable{p_end}
{synopt:{cmd:r(var}{it:#}{cmd:)}}name of variable {it:#}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(table}{it:#}{cmd:)}}matrix containing start and end times of
each gap for variable {it:#}, if {cmd:detail} is specified{p_end}
{p2colreset}{...}

{pstd}
When {it:k} variables are specified in {it:varlist}, {it:#} ranges from 1 to k.
{p_end}
