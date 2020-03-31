{smcl}
{* *! version 1.0.2  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast exogenous" "mansection TS forecastexogenous"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{viewerjumpto "Syntax" "forecast_exogenous##syntax"}{...}
{viewerjumpto "Description" "forecast_exogenous##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_exogenous##linkspdf"}{...}
{viewerjumpto "Examples" "forecast_exogenous##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[TS] forecast exogenous} {hline 2}}Declare exogenous
variables{p_end}
{p2col:}({mansection TS forecastexogenous:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:ex:ogenous} {varlist}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast exogenous} declares exogenous variables in the current forecast
model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastexogenousRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse forecastex1}{p_end}
{phang2}{cmd:. regress y L.y x1 x2}{p_end}
{phang2}{cmd:. estimates store exregression}{p_end}
{phang2}{cmd:. forecast create myexample}{p_end}
{phang2}{cmd:. forecast estimates exregression}{p_end}

{pstd}Fit the single-equation dynamic model with two exogenous variables,
{cmd:x1} and {cmd:x2}{p_end}
{phang2}{cmd:. forecast exogenous x1}{p_end}
{phang2}{cmd:. forecast exogenous x2}{p_end}

{pstd}Same as the above two commands but typed as one command{p_end}
{phang2}{cmd:. forecast exogenous x1 x2}{p_end}
