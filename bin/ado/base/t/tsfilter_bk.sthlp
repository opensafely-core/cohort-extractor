{smcl}
{* *! version 1.0.16  19sep2018}{...}
{viewerdialog "tsfilter bk" "dialog tsfilter, message(-bk-)"}{...}
{vieweralsosee "[TS] tsfilter bk" "mansection TS tsfilterbk"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsfilter" "help tsfilter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "tsfilter bk##syntax"}{...}
{viewerjumpto "Menu" "tsfilter bk##menu"}{...}
{viewerjumpto "Description" "tsfilter bk##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsfilter_bk##linkspdf"}{...}
{viewerjumpto "Options" "tsfilter bk##options"}{...}
{viewerjumpto "Examples" "tsfilter bk##examples"}{...}
{viewerjumpto "Stored results" "tsfilter bk##results"}{...}
{viewerjumpto "Reference" "tsfilter bk##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] tsfilter bk} {hline 2}}Baxter-King time-series filter{p_end}
{p2col:}({mansection TS tsfilterbk:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Filter one variable

{p 8 18 2}
{cmd:tsfilter bk}
{dtype}
{newvar} {cmd:=} {help varname:{it:varname}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, unique names

{p 8 18 2}
{cmd:tsfilter bk}
{dtype}
{help newvarlist:{it:newvarlist}} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]


{pstd}
Filter multiple variables, common name stub

{p 8 18 2}
{cmd:tsfilter bk}
{dtype}
{it:{help newvarlist##stub*:stub}}{cmd:*} {cmd:=} {help varlist:{it:varlist}}
{ifin} [{cmd:,} {it:options}]
{p_end}


{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt min:period(#)}}filter out stochastic cycles at periods smaller than {it:#}
    {p_end}
{synopt:{opt max:period(#)}}filter out stochastic cycles at periods larger than {it:#}
    {p_end}
{synopt:{opt sma:order(#)}}number of observations in each direction that
    contribute to each filtered value{p_end}
{synopt:{opt stat:ionary}}use calculations for a stationary time series{p_end}

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
    {bf:Baxter-King}
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsfilter bk} uses the {help tsfilter_bk##BK1999:Baxter and King (1999)}
band-pass filter to separate a time series into trend and cyclical components.
The trend component may contain a deterministic or a stochastic trend.  The
stationary cyclical component is driven by stochastic cycles at the specified
periods.

{pstd}
See {manlink TS tsfilter} for an introduction to the methods implemented in
{cmd:tsfilter bk}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsfilterbkQuickstart:Quick start}

        {mansection TS tsfilterbkRemarksandexamples:Remarks and examples}

        {mansection TS tsfilterbkMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt minperiod(#)} filters out stochastic cycles at periods smaller than
{it:#}, where {it:#} must be at least 2 and less than {opt maxperiod()}.  By
default, if the units of the time variable are set to daily, weekly, monthly,
quarterly, or half-yearly, then {it:#} is set to the number of periods
equivalent to 1.5 years; yearly data use {cmd:minperiod(2)}; otherwise, the
default value is {cmd:minperiod(6)}.

{phang}
{opt maxperiod(#)} filters out stochastic cycles at periods larger than {it:#},
where {it:#} must be greater than {opt minperiod()}.  By default, if the units
of the time variable are set to daily, weekly, monthly, quarterly, half-yearly,
or yearly, then {it:#} is set to the number of periods equivalent to 8 years;
otherwise, the default value is {cmd:maxperiod(32)}.

{phang}
{opt smaorder(#)} sets the order of the symmetric moving average, denoted by q.
The order is an integer that specifies the number of observations in each
direction used in calculating the symmetric moving average estimate of the
cyclical component.  This number must be an integer greater than zero and less
than (T-1)/2.  The estimate of the cyclical component for the {it:t}th
observation, y_t, is based upon the 2q+1 values y_{t-q}, y_{t-q+1}, ..., y_t,
y_{t+1}, ..., y_{t+q}.  By default, if the units of the time variable are set
to daily, weekly, monthly, quarterly, half-yearly, or yearly, then {it:#} is
set to the number of periods equivalent to 3 years; otherwise, the default
value is {cmd:smaorder(12)}.

{phang}
{opt stationary} modifies the filter calculations to those appropriate for a
stationary series.  By default, the series is assumed nonstationary.

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

{pstd}Use the Baxter-King filter to estimate the cyclical component of
the log of quarterly U.S. GDP{p_end}

{phang2}{cmd:. tsfilter bk gdp_bk = gdp_ln}{p_end}

{pstd}Plot the cyclical component{p_end}
{phang2}{cmd:. tsline gdp_bk}{p_end}

{pstd}Specify a symmetric moving average of order 20{p_end}
{phang2}{cmd:. tsfilter bk gdp_bk20 = gdp_ln, smaorder(20)}{p_end}

{pstd}Save the gain and angular frequency{p_end}
{phang2}{cmd:. tsfilter bk gdp_bkb = gdp_ln, gain(g a)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsfilter bk} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(smaorder)}}order of the symmetric moving average{p_end}
{synopt:{cmd:r(minperiod)}}minimum period of stochastic cycles{p_end}
{synopt:{cmd:r(maxperiod)}}maximum period of stochastic cycles{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}original time-series variables{p_end}
{synopt:{cmd:r(filterlist)}}variables containing
  estimates of the cyclical components{p_end}
{synopt:{cmd:r(trendlist)}}variables containing estimates of the
  trend components, if {cmd:trend()} was specified{p_end}
{synopt:{cmd:r(method)}}{cmd:Baxter-King}{p_end}
{synopt:{cmd:r(stationary)}}{cmd:yes} or {cmd:no}, indicating whether the
  calculations assumed the series was or was not stationary{p_end}
{synopt:{cmd:r(unit)}}units of time variable set using {cmd:tsset} or
  {cmd:xtset}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(filter)}}(q+1) x 1 matrix of filter weights, where q is
  the order of the symmetric moving average{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker BK1999}{...}
{phang}
Baxter, M., and R. G. King. 1999. Measuring business cycles: Approximate
band-pass filters for economic time series.
{it:Review of Economics and Statistics} 81: 575-593.
{p_end}
