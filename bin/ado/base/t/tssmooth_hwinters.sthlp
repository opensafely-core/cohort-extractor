{smcl}
{* *! version 1.1.15  12dec2018}{...}
{viewerdialog "tssmooth hwinters"  "dialog tssmooth_hwinters"}{...}
{vieweralsosee "[TS] tssmooth hwinters" "mansection TS tssmoothhwinters"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth hwinters##syntax"}{...}
{viewerjumpto "Menu" "tssmooth hwinters##menu"}{...}
{viewerjumpto "Description" "tssmooth hwinters##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_hwinters##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth hwinters##options"}{...}
{viewerjumpto "Examples" "tssmooth hwinters##examples"}{...}
{viewerjumpto "Stored results" "tssmooth hwinters##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[TS] tssmooth hwinters} {hline 2}}Holt-Winters nonseasonal smoothing{p_end}
{p2col:}({mansection TS tssmoothhwinters:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 27 2}
{cmd:tssmooth} {opt h:winters} {dtype} {newvar} {cmd:=} {it:{help exp}} 
   {ifin} [{cmd:,} {it:options}]

{synoptset tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:replace}}replace {newvar} if it already exists{p_end}
{synopt :{opt p:arms(#a #b)}}use {it:#a} and {it:#b} as smoothing parameters{p_end}
{synopt :{opt sa:mp0(#)}}use {it:#} observations to obtain initial values for 
  recursion{p_end}
{synopt :{cmd:s0(}{it:#}cons {it:#}lt{cmd:)}}use {it:#}cons and {it:#}lt as initial values for recursion{p_end}
{synopt :{opt f:orecast(#)}}use {it:#} periods for the out-of-sample
  forecast{p_end}

{syntab:Options}
{synopt :{opt d:iff}}alternative initial-value specification; see
          {it:{help tssmooth hwinters##diff:Options}}{p_end}

{syntab:Maximization}
{synopt :{it:{help tssmooth hwinters##maximize_options:maximize_options}}}control the maximization process; seldom used
{p_end}
{synopt :{opt fr:om(#a #b)}}use {it:#a} and {it:#b} as starting values for the parameters{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:tsset} your data before using 
{cmd:tssmooth hwinters}; {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see 
{help tsvarlist}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
     {bf:Holt-Winters nonseasonal smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth hwinters} is used in smoothing or forecasting a series that can
be modeled as a linear trend in which the intercept and the coefficient on
time vary over time.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothhwintersQuickstart:Quick start}

        {mansection TS tssmoothhwintersRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothhwintersMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt replace} replaces {newvar} if it already exists.

{phang}
{opt parms(#a #b)}, {cmd:0} {ul:<} {it:#a} {ul:<} {cmd:1} and 
{bind:{cmd:0} {ul:<} {it:#b} {ul:<} {cmd:1}}, specifies the parameters.  If
{opt parms()} is not specified, the values are chosen by an iterative process
to minimize the in-sample sum-of-squared prediction errors.

{pmore}
If you experience difficulty converging (many iterations and "not concave"
messages), try using {opt from()} to provide better starting values.

{phang}
{opt samp0(#)} and {cmd:s0(}{it:#}cons {it:#}lt{cmd:)} specify how the initial
values {it:#}cons and {it:#}lt for the recursion are obtained.

{pmore}
By default, initial values are obtained by fitting a linear regression with a
time trend using the first half of the observations in the dataset.

{pmore}
{opt samp0(#)} specifies that the first {it:#} observations be used in that
regression.

{pmore}
{cmd:s0(}{it:#}cons {it:#}lt{cmd:)} specifies that {it:#}cons and {it:#}lt
be used as initial values.

{phang}
{opt forecast(#)} specifies the number of periods for the out-of-sample
prediction;  {bind:{cmd:0} {ul:<} {it:#} {ul:<} {cmd:500}}.  The default is
{cmd:forecast(0)}, which is equivalent to not performing an out-of-sample
forecast.


{dlgtab:Options}

{phang}
{marker diff}{...}
{opt diff} specifies that the linear term is obtained by averaging the
first difference of {it:exp_t} and the intercept is obtained as the difference
of {it:exp} in the first observation and the mean of {opt D}.{it:exp_t}.

{pmore}
If the {opt diff} option is not specified, a linear regression of {it:exp_t}
on a constant and {it:t} is fit.

{dlgtab:Maximization}

{phang}
{marker maximize_options}{...}
{it:maximize_options} controls the process for solving for the optimal alpha
and beta when {opt parms()} is not specified.

{pmore}
{it:maximize_options}: {opt nodif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep}, {opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)}, 
{opt nrtol:erance(#)}, and {opt nonrtol:erance};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{phang}
{opt from(#a #b)}, {cmd:0} < {it:#a} < {cmd:1} and {cmd:0} < {it:#b} < {cmd:1},
specifies starting values from which the optimal values of 
alpha and beta will be obtained.  If {opt from()} is not specified, 
{cmd:from(.5 .5)} is used.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bsales}

{pstd}Perform Holt-Winters nonseasonal smoothing on {cmd:sales}{p_end}
{phang2}{cmd:. tssmooth hwinters hw1=sales}

{pstd}Same as above, but use .7 and .3 as smoothing parameters{p_end}
{phang2}{cmd:. tssmooth hwinters hw2=sales, parms(.7 .3)}

{pstd}Same as above, but perform out-of-sample forecast using 3 periods{p_end}
{phang2}{cmd:. tssmooth hwinters hw3=sales, parms(.7 .3) forecast(3)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth hwinters} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(alpha)}}alpha smoothing parameter{p_end}
{synopt:{cmd:r(beta)}}beta smoothing parameter{p_end}
{synopt:{cmd:r(rss)}}sum-of-squared errors{p_end}
{synopt:{cmd:r(prss)}}penalized sum-of-squared errors, if {cmd:parms()} not
specified{p_end}
{synopt:{cmd:r(rmse)}}root mean squared error{p_end}
{synopt:{cmd:r(N_pre)}}number of observations used in calculating starting
values{p_end}
{synopt:{cmd:r(s2_0)}}initial value for linear term{p_end}
{synopt:{cmd:r(s1_0)}}initial value for constant term{p_end}
{synopt:{cmd:r(linear)}}final value of linear term{p_end}
{synopt:{cmd:r(constant)}}final value of constant term{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}smoothing method{p_end}
{synopt:{cmd:r(exp)}}expression specified{p_end}
{synopt:{cmd:r(timevar)}}time variables specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variables specified in {cmd:tsset}{p_end}
{p2colreset}{...}
