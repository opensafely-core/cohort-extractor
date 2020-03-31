{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast list" "mansection TS forecastlist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{viewerjumpto "Syntax" "forecast_list##syntax"}{...}
{viewerjumpto "Description" "forecast_list##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_list##linkspdf"}{...}
{viewerjumpto "Options" "forecast_list##options"}{...}
{viewerjumpto "Example" "forecast_list##example"}{...}
{viewerjumpto "Technical note" "forecast_list##technote"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TS] forecast list} {hline 2}}List forecast commands composing
current model{p_end}
{p2col:}({mansection TS forecastlist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:l:ist}
[{cmd:,} {it:options}]

{synoptset 28}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:sav:ing(}{it:filename}[{cmd:, replace}]{cmd:)}}save list of
commands to file{p_end}
{synopt:{opt notr:im}}do not remove extraneous white space{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} {cmd:list} produces a list of {cmd:forecast} commands that
compose the current model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastlistQuickstart:Quick start}

        {mansection TS forecastlistRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:saving(}{it:filename}[{cmd:, replace}]{cmd:)} requests that
{cmd:forecast} {cmd:list} write the list of commands to disk with
{it:filename}.  If no extension is specified, {cmd:.do} is assumed.  If
{it:filename} already exists, an error is issued unless you specify
{cmd:replace}, in which case the file is overwritten. 

{phang}
{cmd:notrim} requests that {cmd:forecast} {cmd:list} not remove any extraneous
spaces and that commands be shown exactly as they were originally entered.  By
default, superfluous white space is removed.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein2}{p_end}
{phang2}{cmd:. reg3 (c p L.p w) (i p L.p L.k) (wp y L.y yr)}
        {cmd:if year < 1939, endog(w p y) exog(t wg g)}{p_end}
{phang2}{cmd:. estimates store klein}{p_end}

{pstd}Create a new forecast model{p_end}
{phang2}{cmd:. forecast create kleinmodel}

{pstd}Add the stochastic equations fit using {cmd:reg3} to the
{cmd:kleinmodel}{p_end}
{phang2}{cmd:. forecast estimates klein}{p_end}

{pstd}Specify the four identities that determine the other four
endogenous variables in our model{p_end}
{phang2}{cmd:. forecast identity y = c + i + g}{p_end}
{phang2}{cmd:. forecast identity p = y - t - wp}{p_end}
{phang2}{cmd:. forecast identity k = L.k + i}{p_end}
{phang2}{cmd:. forecast identity w = wg + wp}{p_end}

{pstd}Identify the four exogenous variables{p_end}
{phang2}{cmd:. forecast exogenous wg}{p_end}
{phang2}{cmd:. forecast exogenous g}{p_end}
{phang2}{cmd:. forecast exogenous t}{p_end}
{phang2}{cmd:. forecast exogenous yr}{p_end}

{pstd}Obtain one-step-ahead forecasts{p_end}
{phang2}{cmd:. forecast solve, prefix(bl_) begin(1939)}{p_end}

{pstd}Obtain a list of {cmd:forecast} commands that compose the current model
{p_end}
{phang2}{cmd:. forecast list}{p_end}


{marker technote}{...}
{title:Technical note}

{pstd}
To prevent you from accidentally destroying the model in memory,
{cmd:forecast} {cmd:list} does not add the {cmd:replace} option to
{cmd:forecast} {cmd:create} even if you specified {cmd:replace} when you
originally called {cmd:forecast} {cmd:create}.
{p_end}
