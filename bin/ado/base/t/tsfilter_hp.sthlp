{smcl}
{* *! version 1.0.15  19sep2018}{...}
{viewerdialog "tsfilter hp" "dialog tsfilter, message(-hp-)"}{...}
{vieweralsosee "[TS] tsfilter hp" "mansection TS tsfilterhp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsfilter" "help tsfilter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "tsfilter hp##syntax"}{...}
{viewerjumpto "Menu" "tsfilter hp##menu"}{...}
{viewerjumpto "Description" "tsfilter hp##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsfilter_hp##linkspdf"}{...}
{viewerjumpto "Options" "tsfilter hp##options"}{...}
{viewerjumpto "Example" "tsfilter hp##example"}{...}
{viewerjumpto "Stored results" "tsfilter hp##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] tsfilter hp} {hline 2}}Hodrick-Prescott time-series 
      filter{p_end}
{p2col:}({mansection TS tsfilterhp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Filter one variable

{p 8 18 2}
{cmd:tsfilter hp}
{dtype}
{newvar} {cmd:=} {help varname:{it:varname}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, unique names

{p 8 18 2}
{cmd:tsfilter hp}
{dtype}
{help newvarlist:{it:newvarlist}} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, common name stub

{p 8 18 2}
{cmd:tsfilter hp}
{dtype}
{it:{help newvarlist##stub*:stub}}{cmd:*} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]
{p_end}


{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt s:mooth(#)}}smoothing parameter for the Hodrick-Prescott
    filter{p_end}

{syntab:Trend}
{p2col 7 32 32 2:{cmdab:t:rend(}{newvar} | {it:{help newvarlist}} | {it:{help newvarlist##stub*:stub}}{cmd:*)}}{break}save the trend component(s)
    in new variable(s){p_end}

{syntab:Gain}
{synopt:{opt g:ain(gainvar anglevar)}}save the gain and angular frequency{p_end}
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
    {bf:Hodrick-Prescott}
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsfilter hp} uses the Hodrick-Prescott high-pass filter to separate a
time series into trend and cyclical components.  The trend component may
contain a deterministic or a stochastic trend.  The smoothing parameter
determines the periods of the stochastic cycles that drive the stationary cyclical
component.

{pstd}
See {manlink TS tsfilter} for an introduction to the methods implemented in
{cmd:tsfilter hp}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsfilterhpQuickstart:Quick start}

        {mansection TS tsfilterhpRemarksandexamples:Remarks and examples}

        {mansection TS tsfilterhpMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt smooth(#)} sets the smoothing parameter for the Hodrick-Prescott filter.
By default, if the units of the time variable are set to daily, weekly, monthly,
quarterly, half-yearly, or yearly, then the Ravn-Uhlig rule is used to set the
smoothing parameter; otherwise, the default value is {cmd:smooth(1600)}.  The
Ravn-Uhlig rule sets {it:#} to 1600p^4, where p is the number of periods per
quarter.  The smoothing parameter must be greater than 0.

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


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gdp2}{p_end}

{pstd}Use the Hodrick-Prescott high-pass filter to estimate the cyclical
component of the log of quarterly U.S. GDP{p_end}
{phang2}{cmd:. tsfilter hp gdp_hp = gdp_ln}{p_end}

{pstd}Plot the cyclical component{p_end}
{phang2}{cmd:. tsline gdp_hp}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsfilter hp} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(smooth)}}smoothing parameter lambda{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}original time-series variables{p_end}
{synopt:{cmd:r(filterlist)}}variables containing
  estimates of the cyclical components{p_end}
{synopt:{cmd:r(trendlist)}}variables containing estimates of the
  trend components, if {cmd:trend()} was specified{p_end}
{synopt:{cmd:r(method)}}{cmd:Hodrick-Prescott}{p_end}
{synopt:{cmd:r(unit)}}units of time variable set using {cmd:tsset} or
  {cmd:xtset}{p_end}
{p2colreset}{...}
