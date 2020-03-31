{smcl}
{* *! version 1.1.6  11may2018}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast identity" "mansection TS forecastidentity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{viewerjumpto "Syntax" "forecast_identity##syntax"}{...}
{viewerjumpto "Description" "forecast_identity##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_identity##linkspdf"}{...}
{viewerjumpto "Options" "forecast_identity##options"}{...}
{viewerjumpto "Examples" "forecast_identity##examples"}{...}
{viewerjumpto "Stored results" "forecast_identity##results"}{...}
{p2colset 1 27 26 2}{...}
{p2col:{bf:[TS] forecast identity} {hline 2}}Add an identity to a forecast
model{p_end}
{p2col:}({mansection TS forecastidentity:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:id:entity} {it:varname} {cmd:=} {it:{help exp}}
    [{cmd:,} {it:options}]

{synoptset 12 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{synopt :{opt gen:erate}}create new variable {it:varname}{p_end}
{p2coldent :* {opt do:uble}}store new variable as a {cmd:double} instead of as a {cmd:float}{p_end}
{synoptline}
{p 4 6 2}{it:varname} is the name of an endogenous variable to be added to the
forecast model.{p_end}
{p 4 6 2}* You can only specify {opt double} if you also specify {opt generate}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} {cmd:identity} adds an identity to the forecast model currently
in memory.  You must first create a new model using {cmd:forecast} {cmd:create}
before you can add an identity with {cmd:forecast} {cmd:identity}.  An
identity is a nonstochastic equation that expresses an endogenous variable in
the model as a function of other variables in the model.  Identities often
describe the behavior of endogenous variables that are based on accounting
identities or adding-up conditions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastidentityQuickstart:Quick start}

        {mansection TS forecastidentityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt generate} specifies that the new variable {it:varname} be created equal
to {it:{help exp}} for all observations in the current dataset.

{phang}
{opt double}, for use in conjunction with the {opt generate} option, requests
that the new variable be created as a {cmd:double} instead of as a
{cmd:float}.  See {helpb data types:[D] Data types}.


{marker examples}{...}
{title:Examples}

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


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast} {cmd:identity} stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:r(lhs)}}left-hand-side (endogenous) variable{p_end}
{synopt:{cmd:r(rhs)}}right-hand side of identity{p_end}
{synopt:{cmd:r(basenames)}}base names of variables found on right-hand
side{p_end}
{synopt:{cmd:r(fullnames)}}full names of variables found on right-hand
side{p_end}
{p2colreset}{...}
