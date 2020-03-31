{smcl}
{* *! version 1.2.5  12dec2018}{...}
{viewerdialog "tssmooth shwinters" "dialog tssmooth_shwinters"}{...}
{vieweralsosee "[TS] tssmooth shwinters" "mansection TS tssmoothshwinters"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth shwinters##syntax"}{...}
{viewerjumpto "Menu" "tssmooth shwinters##menu"}{...}
{viewerjumpto "Description" "tssmooth shwinters##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_shwinters##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth shwinters##options"}{...}
{viewerjumpto "Examples" "tssmooth shwinters##examples"}{...}
{viewerjumpto "Stored results" "tssmooth shwinters##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[TS] tssmooth shwinters} {hline 2}}Holt-Winters seasonal smoothing{p_end}
{p2col:}({mansection TS tssmoothshwinters:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 30 2}
{cmd:tssmooth} {opt s:hwinters} {dtype} {newvar} {cmd:=} 
  {it:{help exp}} {ifin} [{cmd:,} {it:options}]

{synoptset tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:replace}}replace {newvar} if it already exists{p_end}
{synopt :{opt p:arms(#a #b #g)}}use {it:#a}, {it:#b}, and {it:#g} as smoothing parameters{p_end}
{synopt :{opt sa:mp0(#)}}use {it:#} observations to obtain initial values for
  recursions{p_end}
{synopt :{cmd:s0(}{it:#}cons {it:#}1t{cmd:)}}use {it:#}cons and {it:#}lt as initial values for
  recursions{p_end}
{synopt :{opt f:orecast(#)}}use {it:#} periods for the out-of-sample
  forecast{p_end}
{synopt :{opt per:iod(#)}}use {it:#} period of the seasonality{p_end}
{synopt :{opt add:itive}}use additive seasonal Holt-Winters method{p_end}

{syntab:Options}
{synopt :{opth sn0_0(varname)}}use initial seasonal values in {it:varname}{p_end}
{synopt :{opth sn0_v(newvar)}}store estimated initial values for seasonal
  terms in {it:newvar}{p_end}
{synopt :{opth snt_v(newvar)}}store final year's estimated seasonal terms in
  {it:newvar}{p_end}
{synopt :{opt n:ormalize}}normalize seasonal values{p_end}
{synopt :{opt alt:starts}}use alternative method for computing the starting
values{p_end}

{syntab:Maximization}
{synopt :{it:{help tssmooth shwinters##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
{synopt :{opt fr:om(#a #b #g)}}use {it:#a}, {it:#b}, and {it:#g} as starting values for the parameters{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:tsset} your data before using 
{cmd:tssmooth shwinters}; see {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see 
{help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
    {bf:Holt-Winters seasonal smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth shwinters} performs the seasonal Holt-Winters method on a
user-specified expression, which is usually just a variable name, and
generates a new variable containing the forecasted series.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothshwintersQuickstart:Quick start}

        {mansection TS tssmoothshwintersRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothshwintersMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt replace} replaces {newvar} if it already exists.

{phang}
{opt parms(#a #b #g)}, 
{bind:{cmd:0} {ul:<} {it:#a} {ul:<} {cmd:1}},
{bind:{cmd:0} {ul:<} {it:#b} {ul:<} {cmd:1}}, and 
{bind:{cmd:0} {ul:<} {it:#g} {ul:<} {cmd:1}}, specifies the parameters.  If
{opt parms()} is not specified, the values are chosen by an iterative process
to minimize the in-sample sum-of-squared prediction errors.

{pmore}
If you experience difficulty converging (many iterations and "not concave"
messages), try using {opt from()} to provide better starting values.

{phang}
{opt samp0(#)} and {cmd:s0(}{it:#}cons {it:#}lt{cmd:)} have to do with how the
initial values {it:#}cons and {it:#}lt for the recursion are obtained.

{pmore}
{cmd:s0(}{it:#}cons {it:#}lt{cmd:)} specifies the initial values to be used.

{pmore}
{opt samp0(#)} specifies that the initial values be obtained using the first
{it:#} observations of the sample.  This calculation is described under
{it:{mansection TS tssmoothshwintersMethodsandformulas:Methods and formulas}}
in {hi:[TS] tssmooth shwinters} and depends on whether the {cmd:altstart} and
{cmd:additive} options are also specified.

{pmore}
If neither option is specified, the first half of the sample is used to obtain
initial values.

{phang}
{opt forecast(#)} specifies the number of periods for the out-of-sample
prediction;  {bind:{cmd:0} {ul:<} {it:#} {ul:<} {cmd:500}}.  The default is
{cmd:forecast(0)}, which is equivalent to not performing an out-of-sample
forecast.

{phang}
{opt period(#)} specifies the period of the seasonality.  If {opt period()} is
not specified, the seasonality is obtained from the {helpb tsset} options 
{opt daily}, {opt weekly}, ..., {opt yearly}.  If you did not specify one of
those options when you {cmd:tsset} the data, you must specify the 
{opt period()} option.  For instance, if your data are quarterly and you did
not specify {cmd:tsset}'s {opt quarterly} option, you must now specify 
{cmd:period(4)}.

{pmore}
By default, seasonal values are calculated, but you may specify the initial
seasonal values to be used via the {opth sn0_0(varname)} option.  The first
{opt period()} observations of {it:varname} are to contain the initial
seasonal values.

{phang}
{opt additive} uses the additive seasonal Holt-Winters method instead of the
default multiplicative seasonal Holt-Winters method.

{dlgtab:Options}

{phang}
{opth sn0_0(varname)} specifies the initial seasonal values to use.
{it:varname} must contain a complete year's worth of seasonal values,
beginning with the first observation in the estimation sample.  For example,
if you have monthly data, the first 12 observations of {it:varname} must
contain nonmissing data.  {opt sn0_0()} cannot be used with {opt sn0_v()}.

{phang}
{opth sn0_v(newvar)} stores in {it:newvar} the initial seasonal values after
they have been estimated.  {opt sn0_v()} cannot be used with {opt sn0_0()}. 

{phang}
{opth snt_v(newvar)} stores in {it:newvar} the seasonal values for the final
year's worth of data.

{phang}
{opt normalize} specifies that the seasonal values be normalized.  In the
multiplicative model, they are normalized to sum to one.  In the additive
model, the seasonal values are normalized to sum to zero.

{phang}
{cmd:altstarts} uses an alternative method to compute the starting values for
the constant, the linear, and the seasonal terms.
The default and the alternative methods
are described in 
{mansection TS tssmoothshwintersMethodsandformulas:{it:Methods and formulas}}
in {bf:[TS] tssmooth shwinters}.
{cmd:altstarts} may not be specified with {cmd:s0()}.

{dlgtab:Maximization}

{phang}
{marker maximize_options}{...}
{it:maximize_options} controls the process for solving for the optimal alpha,
beta, and gamma when the {opt parms()} option is not specified.

{pmore}
{it:maximize_options}: {opt nodif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep}, {opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, and {opt nonrtol:erance};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{phang}
{opt from(#a #b #g)}, {bind:{cmd:0} < {it:#a} < {cmd:1}},
{bind:{cmd:0} < {it:#b} < {cmd:1}}, and
{bind:{cmd:0} < {it:#g} < {cmd:1}}, specifies starting values from which the
optimal values of alpha, beta, and gamma will be obtained.  If {opt from()} is
not specified, {cmd:from(.5 .5 .5)} is used.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse turksales}{p_end}

{pstd}Perform Holt-Winters seasonal smoothing on {cmd:sales}{p_end}
{phang2}{cmd:. tssmooth shwinters shw1=sales}

{pstd}Same as above, but perform out-of-sample forecast using 4 periods{p_end}
{phang2}{cmd:. tssmooth shwinters shw2=sales, forecast(4)}

{pstd}Same as above, but use additive seasonal Holt-Winters method{p_end}
{phang2}{cmd:. tssmooth shwinters shw3=sales, forecast(4) additive}

{pstd}Same as above, but normalize seasonal values{p_end}
{phang2}{cmd:. tssmooth shwinters shw4=sales, forecast(4) additive normalize}

{pstd}Same as above, but store final year's estimated seasonal terms in
{cmd:seas}{p_end}
{phang2}{cmd:. tssmooth shwinters shw5=sales, forecast(4) additive normalize}
              {cmd:snt_v(seas)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth shwinters} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(alpha)}}alpha smoothing parameter{p_end}
{synopt:{cmd:r(beta)}}beta smoothing parameter{p_end}
{synopt:{cmd:r(gamma)}}gamma smoothing parameter{p_end}
{synopt:{cmd:r(prss)}}penalized sum-of-squared errors{p_end}
{synopt:{cmd:r(rss)}}sum-of-squared errors{p_end}
{synopt:{cmd:r(rmse)}}root mean squared error{p_end}
{synopt:{cmd:r(N_pre)}}number of seasons used in calculating starting
values{p_end}
{synopt:{cmd:r(s2_0)}}initial value for linear term{p_end}
{synopt:{cmd:r(s1_0)}}initial value for constant term{p_end}
{synopt:{cmd:r(linear)}}final value of linear term{p_end}
{synopt:{cmd:r(constant)}}final value of constant term{p_end}
{synopt:{cmd:r(period)}}{cmd:period}, if filter is seasonal{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}{cmd:shwinters, additive} or {cmd:shwinters, multiplicative}{p_end}
{synopt:{cmd:r(normalize)}}{cmd:normalize}, if specified{p_end}
{synopt:{cmd:r(exp)}}expression specified{p_end}
{synopt:{cmd:r(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variable specified in {cmd:tsset}{p_end}
{p2colreset}{...}
