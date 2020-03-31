{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast query" "mansection TS forecastquery"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast describe" "help forecast describe"}{...}
{viewerjumpto "Syntax" "forecast_query##syntax"}{...}
{viewerjumpto "Description" "forecast_query##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_query##linkspdf"}{...}
{viewerjumpto "Examples" "forecast_query##examples"}{...}
{viewerjumpto "Stored results" "forecast_query##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[TS] forecast query} {hline 2}}Check whether a forecast model
has been started{p_end}
{p2col:}({mansection TS forecastquery:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:q:uery}  


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast query} issues a message indicating whether a forecast model has
been started.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastqueryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Check if there are any forecast models in memory{p_end}
{phang2}{cmd:. forecast query}

{pstd}Create a forecast model named {cmd:fcmodel}{p_end}
{phang2}{cmd:. forecast create fcmodel}

{pstd}Recheck for forecast models in memory{p_end}
{phang2}{cmd:. forecast query}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast query} stores the following in {cmd:r()}:

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Scalars}{p_end}
{synopt:{cmd:r(found)}}{cmd:1} if model started, {cmd:0} otherwise{p_end}

{p2col 5 14 18 2: Macros}{p_end}
{synopt:{cmd:r(name)}}model name{p_end}
{p2colreset}{...}
