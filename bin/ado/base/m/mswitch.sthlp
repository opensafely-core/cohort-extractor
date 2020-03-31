{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog mswitch "dialog mswitch"}{...}
{vieweralsosee "[TS] mswitch" "mansection TS mswitch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mswitch postestimation" "help mswitch postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] threshold" "help threshold"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] ucm" "help ucm"}{...}
{viewerjumpto "Syntax" "mswitch##syntax"}{...}
{viewerjumpto "Menu" "mswitch##menu"}{...}
{viewerjumpto "Description" "mswitch##description"}{...}
{viewerjumpto "Links to PDF documentation" "mswitch##linkspdf"}{...}
{viewerjumpto "Options" "mswitch##options"}{...}
{viewerjumpto "Examples" "mswitch##examples"}{...}
{viewerjumpto "Video example" "mswitch##video"}{...}
{viewerjumpto "Stored results" "mswitch##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] mswitch} {hline 2}}Markov-switching regression models{p_end}
{p2col:}({mansection TS mswitch:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Markov-switching dynamic regression

{p 8 16 2}{cmd:mswitch}
{cmd:dr}
{depvar} [{it:nonswitch_varlist}]
{ifin}
[{cmd:,} {help mswitch##mswitch_options:{it:options}}]


{phang}
Markov-switching autoregression (AR)

{p 8 16 2}{cmd:mswitch}
{cmd:ar}
{depvar} [{it:nonswitch_varlist}]{cmd:,} {opth ar(numlist)}
[{help mswitch##msar_options:{it:msar_options}}
{help mswitch##mswitch_options:{it:options}}]


{phang}
{it:nonswitch_varlist} is a list of variables with state-invariant
coefficients.

{marker mswitch_options}{...}
{synoptset 32 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt states(#)}}specify number of states; default is
{cmd:states(2)}{p_end}
{synopt :{cmd:switch(}[{it:varlist}][{cmd:,} {opt nocons:tant}]{cmd:)}}specify variables with switching coefficients; by default, the constant term is state dependent unless {cmd:switch(, noconstant)} is specified{p_end}
{synopt :{opt con:stant}}allow a state-invariant constant term; may be specified only with {cmd:switch(, noconstant)}{p_end}
{synopt :{opt varsw:itch}}specify state-dependent variance parameters; by default, the variance parameter is constant across all states{p_end}
{synopt :{opt p0(type)}}specify initial unconditional probabilities where {it:type} is one of {cmdab:tr:ansition}, {cmdab:fi:xed}, or {cmdab:sm:oothed}; the default is {cmd:p0(transition)}{p_end}
{synopt :{opth const:raints(numlist)}}apply specified linear
constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim} or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help mswitch##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:EM options}
{synopt :{opt emiter:ate(#)}}specify the number of expectation-maximization (EM) iterations; default is {cmd:emiterate(10)}{p_end}
{synopt :{opt emlog}}show EM iteration log{p_end}
{synopt :{opt emdot:s}}show EM iterations as dots{p_end}

{syntab:Maximization}
{synopt :{it:{help mswitch##maximize_options:maximize_options}}}control the maximization process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker msar_options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:msar_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opth ar(numlist)}}specify the number of AR terms{p_end}
{synopt :{cmdab:arsw:itch}}specify state-dependent AR coefficients{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt ar(numlist)} is required.

{p 4 6 2}
You must {opt tsset} your data before using {opt mswitch}; see
{manhelp tsset TS}.{p_end}
{p 4 6 2}{it:varlist} and {it:nonswitch_varlist} may contain factor variables;
see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:nonswitch_varlist}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt rolling}, and {opt statsby} are allowed; see {help prefix}.
{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mswitch_postestimation TS:mswitch postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Markov-switching model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mswitch} fits dynamic regression models that exhibit different dynamics
across unobserved states using state-dependent parameters to accommodate
structural breaks or other multiple-state phenomena.  These models are known
as Markov-switching models because the transitions between the unobserved
states follow a Markov chain.

{pstd}
Two models are available: Markov-switching dynamic regression models that
allow a quick adjustment after the process changes state and Markov-switching
autoregression models that allow a more gradual adjustment.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mswitchQuickstart:Quick start}

        {mansection TS mswitchRemarksandexamples:Remarks and examples}

        {mansection TS mswitchMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth ar(numlist)} specifies the number of AR terms.  This option may be
specified only with command {cmd:mswitch ar}.  {cmd:ar()} is required
to fit AR models.

{phang}
{cmd:arswitch} specifies that the AR coefficients vary over the states.
{cmd:arswitch} may be specified only with option {cmd:ar()}.

{dlgtab:Main}

{phang}
{opt states(#)} specifies the number of states.  The default is
{cmd:states(2)}.

{phang}
{cmd:switch(}[{varlist}][{cmd:, noconstant}]{cmd:)} specifies variables whose
coefficients vary over the states.  By default, the constant term is state
dependent and is included in the regression model.  You may suppress the
constant term by specifying {cmd:switch(, noconstant)}.

{phang}
{cmd:constant} specifies that a state-invariant constant term be included in
the model.  This option may be specified only  with 
{cmd:switch(, noconstant)}.

{phang}
{cmd:varswitch} specifies that the variance parameters are state dependent.
The default is constant variance across all states.

{phang}
{opt p0(type)} is rarely used.  This option specifies the method for obtaining
values for the unconditional transition probabilities.  {it:type} is one of
{cmd:transition}, {cmd:fixed}, or {cmd:smoothed}.  The default is
{cmd:p0(transition)}, which specifies that the values be computed using the
matrix of conditional transition probabilities.  Type {cmd:fixed} specifies
that each unconditional probability is 1/k, where k is the number of states.
Type {cmd:smoothed} specifies that the unconditional probabilities be
estimated as extra parameters of the model. 

{phang}
{opth constraints(numlist)} specifies the linear constraints to be applied to
the parameter estimates.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim})
and that are robust to some kinds of misspecification ({cmd:robust});
see {helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {cmd:nocnsreport}; see 
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:EM options}

{phang}
{opt emiterate(#)}, {cmd:emlog}, and {cmd:emdots} control the EM iterations
that take place before estimation switches to a quasi-Newton method.  EM is
used to obtain starting values.

{phang2}
{opt emiterate(#)} specifies the number of EM iterations; the default is
{cmd:emiterate(10)}.

{phang2}
{cmd:emlog} specifies that the EM iteration log be shown.  The default is to
not display the EM iteration log.

{phang2}
{cmd:emdots} specifies that the EM iterations be shown as dots.  The default
is to not display the dots.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace}, 
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(matname)};
see {helpb maximize:[R] Maximize} for all options except {opt from()}, and see
below for information on {opt from()}.

{phang2}
{opt from(matname)} specifies initial values for the maximization process.  If
{cmd:from()} is specified, the initial values are used in the EM step to
improve the likelihood unless {cmd:emiterate(0)} is also specified.  The
coefficients obtained at the end of the EM iterations serve as initial values
for the quasi-Newton method.

{pmore2}
{it:matname} must be a row vector.  The number of columns must equal the
number of parameters in the model, and the values must be in the same order as
the parameters in {cmd:e(b)}.

{pstd}
The following option is available with {cmd:mswitch} but is not shown in the
dialog box:

{phang}
{cmd:coeflegend}; see
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse usmacro}

{pstd}
Estimate the parameters of a Markov-switching dynamic regression model{p_end}
{phang2}{cmd:. mswitch dr fedfunds}

{pstd}
Estimate the switching coefficient by including the {cmd:switch()} option{p_end}
{phang2}{cmd:. mswitch dr fedfunds, switch(L.fedfunds)}

    {hline}
{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse rgnp}

{pstd}
Fit a Markov-switching autoregression model with two lags and state-dependent
autoregressive coefficients{p_end}
{phang2}{cmd:. mswitch ar rgnp, ar(1/2) arswitch}

    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=Vex5VEtVcsw":Markov-switching models in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mswitch} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(states)}}number of states{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:e(hqic)}}Hannan-Quinn information criterion{p_end}
{synopt:{cmd:e(sbic)}}Schwarz-Bayesian information criterion{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(emiter)}}number of EM iterations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mswitch}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(switchvars)}}list of switching variables{p_end}
{synopt:{cmd:e(nonswitchvars)}}list of nonswitching variables{p_end}
{synopt:{cmd:e(model)}}{cmd:dr} or {cmd:ar}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tsfmt)}}format for the current time variable{p_end}
{synopt:{cmd:e(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title use to label Std. Err.{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(p0)}}unconditional probabilities{p_end}
{synopt:{cmd:e(varswitch)}}{cmd:varswitch}, if specified{p_end}
{synopt:{cmd:e(arswitch)}}{cmd:arswitch}, if specified{p_end}
{synopt:{cmd:e(ar)}}list of AR lags, if {cmd:ar()} is specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(initvals)}}matrix of initial values{p_end}
{synopt:{cmd:e(uncprob)}}matrix of unconditional probabilities{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
