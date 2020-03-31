{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast drop" "mansection TS forecastdrop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast solve" "help forecast solve"}{...}
{viewerjumpto "Syntax" "forecast_drop##syntax"}{...}
{viewerjumpto "Description" "forecast_drop##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_drop##linkspdf"}{...}
{viewerjumpto "Options" "forecast_drop##options"}{...}
{viewerjumpto "Example" "forecast_drop##example"}{...}
{viewerjumpto "Stored results" "forecast_drop##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TS] forecast drop} {hline 2}}Drop forecast variables{p_end}
{p2col:}({mansection TS forecastdrop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:dr:op}
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent:* {opt pre:fix(string)}}specify prefix for forecast
variables{p_end}
{p2coldent:* {opt suf:fix(string)}}specify suffix for forecast
variables{p_end}
{synoptline}
{p 4 6 2}* You can specify {cmd:prefix()} or {cmd:suffix()} but not both.


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast drop} drops variables previously created by {cmd:forecast}
{cmd:solve}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastdropQuickstart:Quick start}

        {mansection TS forecastdropRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt prefix(string)} and {opt suffix(string)} specify either a
name prefix or a name suffix that will be used to identify forecast variables
to be dropped.  You may specify {cmd:prefix()} or {cmd:suffix()} but not
both.  By default, {cmd:forecast drop} removes all forecast variables produced
by the previous invocation of {cmd:forecast solve}.

{pmore}
Suppose, however, that you previously specified the {cmd:simulate()} option
with {cmd:forecast solve} and wish to remove variables containing simulation
results but retain the variables containing the point forecasts.  Then you can
use the {cmd:prefix()} or {cmd:suffix()} option to identify the simulation
variables you want dropped.


{marker example}{...}
{title:Example}

{pstd}
{cmd:forecast drop} safely removes variables previously created using
{cmd:forecast} {cmd:solve}.  Say you previously solved your model and created
forecast variables that were suffixed with {cmd:_f}.  Do not type

{phang2}
{cmd:. drop *_f}

{pstd}
to remove those variables from the dataset.  Rather, type

{phang2}
{cmd:. forecast drop}

{pstd}
The former command is dangerous: Suppose you were given the dataset and asked
to produce the forecast.  The person who previously worked with the dataset
created other variables that ended with {cmd:_f}.  Using {cmd:drop} would
remove those variables as well.  {cmd:forecast} {cmd:drop} removes only those
variables that were previously created by {cmd:forecast} {cmd:solve} based on
the model in memory.
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast drop} stores the following in {cmd:r()}:

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Scalars}{p_end}
{synopt:{cmd:r(n_dropped)}}number of variables dropped{p_end}
{p2colreset}{...}
