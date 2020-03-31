{smcl}
{* *! version 1.0.6  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast" "mansection TS forecast"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "forecast##syntax"}{...}
{viewerjumpto "Description" "forecast##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast##linkspdf"}{...}
{viewerjumpto "Examples" "forecast##examples"}{...}
{viewerjumpto "Video example" "forecast##video"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] forecast} {hline 2}}Econometric model forecasting{p_end}
{p2col:}({mansection TS forecast:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:forecast} {it:subcommand} ... [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{helpb forecast create:create}}create a new model{p_end}
{synopt :{helpb forecast estimates:estimates}}add estimation result to current
model{p_end}
{synopt :{helpb forecast identity:identity}}specify an identity (nonstochastic
equation){p_end}
{synopt :{helpb forecast coefvector:coefvector}}specify an equation via a
coefficient vector{p_end}
{synopt :{helpb forecast exogenous:exogenous}}declare exogenous
variables{p_end}
{synopt :{helpb forecast solve:solve}}obtain one-step-ahead or dynamic
forecasts{p_end}
{synopt :{helpb forecast adjust:adjust}}adjust a variable by add factoring,
replacing, etc.{p_end}
{synopt :{helpb forecast describe:describe}}describe a model{p_end}
{synopt :{helpb forecast list:list}}list all {cmd:forecast} commands composing
current model{p_end}
{synopt :{helpb forecast clear:clear}}clear current model from memory{p_end}
{synopt :{helpb forecast drop:drop}}drop forecast variables{p_end}
{synopt :{helpb forecast query:query}}check whether a forecast model has been
started{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} is a suite of commands for obtaining forecasts by solving
models, collections of equations that jointly determine the outcomes of one or
more variables.  Equations can be stochastic relationships fit using
estimation commands such as {cmd:regress}, {cmd:ivregress}, {cmd:var}, or
{cmd:reg3}; or they can be nonstochastic relationships, called identities, that
express one variable as a deterministic function of other variables.
Forecasting models may also include exogenous variables whose values are
already known or determined by factors outside the purview of the system being
examined.  The {cmd:forecast} commands can also be used to obtain dynamic
forecasts in single-equation models.

{pstd}
The {cmd:forecast} suite lets you incorporate outside information into your
forecasts through the use of add factors and similar devices, and you can
specify the future path for some model variables and obtain forecasts for
other variables conditional on that path.  Each set of forecast variables has
its own name prefix or suffix, so you can compare forecasts based on
alternative scenarios.  Confidence intervals for forecasts can be obtained via
stochastic simulation and can incorporate both parameter uncertainty and
additive error terms.

{pstd}
{cmd:forecast} works with both time-series and panel datasets.  Time-series
datasets may not contain any gaps, and panel datasets must be strongly
balanced.

{pstd}
This manual entry provides an overview of forecasting models and several
examples showing how the {cmd:forecast} commands are used together.  See the
individual subcommands' manual entries for detailed discussions of the various
options available and specific remarks about those subcommands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastQuickstart:Quick start}

        {mansection TS forecastRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
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

{pstd}Obtain dynamic forecasts{p_end}
{phang2}{cmd:. forecast solve, prefix(bl_) begin(1939)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse hardware}{p_end}
{phang2}{cmd:. generate lndim = ln(dim)}{p_end}
{phang2}{cmd:. generate lngdp = ln(gdp)}{p_end}
{phang2}{cmd:. generate lnstarts = ln(starts)}{p_end}
{phang2}{cmd:. regress D.lndim lnstarts D.lngdp unrate if qdate <=}
           {cmd:tq(2009q4)}{p_end}
{phang2}{cmd:. estimates store dim}{p_end}
{phang2}{cmd:. regress sheet dim D.lngdp unrate if qdate <= tq(2009q4)}{p_end}
{phang2}{cmd:. estimates store sheet}{p_end}
{phang2}{cmd:. regress misc dim D.lngdp unrate if qdate <= tq(2009q4)}{p_end}
{phang2}{cmd:. estimates store misc}{p_end}

{pstd}Create a new forecast model named {cmd:salesfcast} and add those two
equations{p_end}
{phang2}{cmd:. forecast create salesfcast}{p_end}
{phang2}{cmd:. forecast estimates sheet}{p_end}
{phang2}{cmd:. forecast estimates misc}{p_end}

{pstd}Use the {cmd:names()} option of {cmd:forecast} {cmd:estimates} to
specify a valid name for the endogenous variable being added{p_end}
{phang2}{cmd:. forecast estimates dim, names(dlndim)}

{pstd}Specify an identity to reverse the first-differencing{p_end}
{phang2}{cmd:. forecast identity lndim = L.lndim + dlndim}

{pstd}Specify another identity to obtain {cmd:dim} from {cmd:lndim}{p_end}
{phang2}{cmd:. forecast identity dim = exp(lndim)}

{pstd}Solve the model, obtaining dynamic forecasts starting in the
first quarter of 2010 and suppressing the iteration log with the use of
{cmd:log(off)}{p_end}
{phang2}{cmd:. forecast solve, begin(tq(2010q1)) log(off)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse statehardware}{p_end}
{phang2}{cmd:. generate lndim = ln(dim)}{p_end}
{phang2}{cmd:. generate lnstarts = ln(starts)}{p_end}
{phang2}{cmd:. xtreg D.lndim lnstarts rgspgrowth unrate if qdate <= tq(2009q4),}
           {cmd:fe}{p_end}
{phang2}{cmd:. predict dlndim_u, u}{p_end}
{phang2}{cmd:. estimates store dim}{p_end}
{phang2}{cmd:. xtreg sheet dim rgspgrowth unrate if qdate <= tq(2009q4),}
           {cmd:fe}{p_end}
{phang2}{cmd:. predict sheet_u, u}{p_end}
{phang2}{cmd:. estimates store sheet}{p_end}
{phang2}{cmd:. xtreg misc dim rgspgrowth unrate if qdate <= tq(2009q4),}
           {cmd:fe}{p_end}
{phang2}{cmd:. predict misc_u, u}{p_end}
{phang2}{cmd:. estimates store misc}

{pstd}Extend the estimates of the panel-level effects into the forecast
horizon{p_end}
{phang2}{cmd:. by state: egen dlndim_u2 = mean(dlndim_u)}{p_end}
{phang2}{cmd:. by state: egen sheet_u2 = mean(sheet_u)}{p_end}
{phang2}{cmd:. by state: egen misc_u2 = mean(misc_u)}

{pstd}Define the forecast model, including the estimated panel-specific
terms{p_end}
{phang2}{cmd:. forecast create statemodel}{p_end}
{phang2}{cmd:. forecast estimates dim, name(dlndim)}{p_end}
{phang2}{cmd:. forecast adjust dlndim = dlndim + dlndim_u2}{p_end}
{phang2}{cmd:. forecast identity lndim = L.lndim + dlndim}{p_end}
{phang2}{cmd:. forecast identity dim = exp(lndim)}{p_end}
{phang2}{cmd:. forecast estimates sheet}{p_end}
{phang2}{cmd:. forecast adjust sheet = sheet + sheet_u2}{p_end}
{phang2}{cmd:. forecast estimates misc}{p_end}
{phang2}{cmd:. forecast adjust misc = misc + misc_u2}

{pstd}Solve the model, obtaining dynamic forecasts beginning in the
first quarter of 2010{p_end}
{phang2}{cmd:. forecast solve, begin(tq(2010q1))}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=wx3lyVGYDic&feature=youtu.be":Tour of forecasting}
{p_end}
