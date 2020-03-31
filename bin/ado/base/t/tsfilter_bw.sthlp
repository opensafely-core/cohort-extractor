{smcl}
{* *! version 1.0.15  19sep2018}{...}
{viewerdialog "tsfilter bw" "dialog tsfilter, message(-bw-)"}{...}
{vieweralsosee "[TS] tsfilter bw" "mansection TS tsfilterbw"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsfilter" "help tsfilter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "tsfilter bw##syntax"}{...}
{viewerjumpto "Menu" "tsfilter bw##menu"}{...}
{viewerjumpto "Description" "tsfilter bw##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsfilter_bw##linkspdf"}{...}
{viewerjumpto "Options" "tsfilter bw##options"}{...}
{viewerjumpto "Examples" "tsfilter bw##examples"}{...}
{viewerjumpto "Stored results" "tsfilter bw##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] tsfilter bw} {hline 2}}Butterworth time-series filter{p_end}
{p2col:}({mansection TS tsfilterbw:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Filter one variable

{p 8 18 2}
{cmd:tsfilter bw}
{dtype}
{newvar} {cmd:=} {help varname:{it:varname}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, unique names

{p 8 18 2}
{cmd:tsfilter bw}
{dtype}
{help newvarlist:{it:newvarlist}} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, common name stub

{p 8 18 2}
{cmd:tsfilter bw}
{dtype}
{it:{help newvarlist##stub*:stub}}{cmd:*} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]
{p_end}


{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt max:period(#)}}filter out stochastic cycles at periods larger than {it:#}
    {p_end}
{synopt:{opt or:der(#)}}set the order of the filter; default is
   {cmd:order(2)}{p_end}

{syntab:Trend}
{p2col 7 32 32 2:{cmdab:t:rend(}{newvar} | {it:{help newvarlist}} | {it:{help newvarlist##stub*:stub}}{cmd:*)}}{break}save the trend component(s) in new variable(s){p_end}

{syntab:Gain}
{synopt:{opt g:ain(gainvar anglevar)}}save the gain and angular
frequency{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset}  or {opt xtset} your data before using {opt tsfilter};
see {manhelp tsset TS} and {manhelp xtset XT}.{p_end}
{p 4 6 2}
{it:varname} and {it:varlist} may contain time-series operators; see
{help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Filters for cyclical components >}
    {bf:Butterworth}
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsfilter bw} uses the Butterworth high-pass filter to separate a time
series into trend and cyclical components.  The trend component may contain a
deterministic or a stochastic trend.  The stationary cyclical component is
driven by stochastic cycles at the specified periods.

{pstd}
See {manlink TS tsfilter} for an introduction to the methods implemented in
{cmd:tsfilter bw}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsfilterbwQuickstart:Quick start}

        {mansection TS tsfilterbwRemarksandexamples:Remarks and examples}

        {mansection TS tsfilterbwMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt maxperiod(#)} filters out stochastic cycles at periods larger than {it:#}, where
{it:#} must be greater than 2.  By default, if the units of the time variable
are set to daily, weekly, monthly, quarterly, half-yearly, or yearly, then {it:#}
is set to the number of periods equivalent to 8 years; otherwise, the
default value is {cmd:maxperiod(32)}.

{phang}
{opt order(#)} sets the order of the Butterworth filter, which must be an
integer.  The default is {cmd:order(2)}.

{dlgtab:Trend}

{phang}
{cmd:trend(}{newvar} | {it:{help newvarlist}} | {it:{help newvarlist##stub*:stub}}{cmd:*)} saves the
trend component(s) in the new variable(s) specified by {it:newvar},
{it:newvarlist}, or {it:stub}{cmd:*}.

{dlgtab:Gain}

{phang}
{opt gain(gainvar anglevar)} saves the gain in {it:gainvar} and its
associated angular frequency in {it:anglevar}.  Gains are calculated at the
N angular frequencies that uniformly partition the interval (0, pi], where N
is the sample size.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gdp2}{p_end}

{pstd}Use the Butterworth filter to estimate the components of
the log of quarterly U.S. GDP driven by stochastic cycles of less than
the default 32 periods{p_end}
{phang2}{cmd:. tsfilter bw gdp_bw = gdp_ln}{p_end}

{pstd}Plot the cyclical component{p_end}
{phang2}{cmd:. tsline gdp_bw}{p_end}

{pstd}Specify a maximum period of 6{p_end}
{phang2}{cmd:. tsfilter bw gdp_bwb = gdp_ln, maxperiod(6)}{p_end}

{pstd}Specify an order of 8 and save the trend component{p_end}
{phang2}{cmd:. tsfilter bw gdp_bw8 = gdp_ln, order(8) trend(gdp_bwc8)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsfilter bw} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(order)}}order of the filter{p_end}
{synopt:{cmd:r(maxperiod)}}maximum period of stochastic cycles{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}original time-series variables{p_end}
{synopt:{cmd:r(filterlist)}}variables containing
  estimates of the cyclical components{p_end}
{synopt:{cmd:r(trendlist)}}variables containing estimates of the
  trend components, if {cmd:trend()} was specified{p_end}
{synopt:{cmd:r(method)}}{cmd:Butterworth}{p_end}
{synopt:{cmd:r(unit)}}units of time variable set using {cmd:tsset} or
  {cmd:xtset}{p_end}
{p2colreset}{...}
