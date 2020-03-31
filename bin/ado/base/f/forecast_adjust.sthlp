{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast adjust" "mansection TS forecastadjust"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast solve" "help forecast solve"}{...}
{viewerjumpto "Syntax" "forecast_adjust##syntax"}{...}
{viewerjumpto "Description" "forecast_adjust##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_adjust##linkspdf"}{...}
{viewerjumpto "Examples" "forecast_adjust##examples"}{...}
{viewerjumpto "Stored results" "forecast_adjust##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[TS] forecast adjust} {hline 2}}Adjust a variable by add
factoring, replacing, etc.{p_end}
{p2col:}({mansection TS forecastadjust:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:ad:just}
{it:varname} {cmd:=} {it:exp}
{ifin}

{phang}
{it:varname} is the name of an endogenous variable that has been
previously added to the model using {cmd:forecast estimates} or
{cmd:forecast coefvector}.

{phang}
{it:exp} represents a Stata expression; see {help exp:help exp}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast adjust} specifies an adjustment to be applied to an
endogenous variable in the model.  Adjustments are typically used to produce
alternative forecast scenarios or to incorporate outside information into a
model.  For example, you could use {cmd:forecast adjust} with a macroeconomic
model to simulate the effect of an oil price shock whereby the price of oil
spikes $50 higher than your model otherwise predicts in a given quarter.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastadjustQuickstart:Quick start}

        {mansection TS forecastadjustRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


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

{pstd}Identify the four exogenous variables{p_end}
{phang2}{cmd:. forecast exogenous wg}{p_end}
{phang2}{cmd:. forecast exogenous g}{p_end}
{phang2}{cmd:. forecast exogenous t}{p_end}
{phang2}{cmd:. forecast exogenous yr}{p_end}

{pstd}Obtain one-step-ahead forecasts{p_end}
{phang2}{cmd:. forecast solve, prefix(bl_) begin(1939)}{p_end}

{pstd}Model the increase in investment in 1939{p_end}
{phang2}{cmd:. forecast adjust i = i + 1 if year == 1939}

{pstd}Model the investment tax credit over two years instead of one{p_end}
{phang2}{cmd:. forecast adjust i = i + 1 if year == 1939}{p_end}
{phang2}{cmd:. forecast adjust i = i + 1 if year == 1940}{p_end}

{pstd}Same as above but specified in one command{p_end}
{phang2}{cmd:. forecast adjust i = i + 1 if year == 1939 | year == 1940}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast adjust} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2:Macros}{p_end}
{synopt:{cmd:r(lhs)}}left-hand-side (endogenous) variable{p_end}
{synopt:{cmd: r(rhs)}}right-hand side of identity{p_end}
{synopt:{cmd:r(basenames)}}base names of variables found on right-hand
side{p_end}
{synopt:{cmd:r(fullnames)}}full names of variables found on right-hand
side{p_end}
{p2colreset}{...}
