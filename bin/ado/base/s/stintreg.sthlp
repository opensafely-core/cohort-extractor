{smcl}
{* *! version 1.0.11  12dec2018}{...}
{viewerdialog stintreg "dialog stintreg"}{...}
{viewerdialog "svy: stintreg" "dialog stintreg, message(-svy-) name(svy_stintreg)"}{...}
{vieweralsosee "[ST] stintreg" "mansection ST stintreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stintreg postestimation" "help stintreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "[ME] meintreg" "help meintreg"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[XT] xtintreg" "help xtintreg"}{...}
{viewerjumpto "Syntax" "stintreg##syntax"}{...}
{viewerjumpto "Menu" "stintreg##menu"}{...}
{viewerjumpto "Description" "stintreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "stintreg##linkspdf"}{...}
{viewerjumpto "Options" "stintreg##options"}{...}
{viewerjumpto "Examples" "stintreg##examples"}{...}
{viewerjumpto "Stored results" "stintreg##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ST] stintreg} {hline 2}}Parametric models for
interval-censored survival-time data{p_end}
{p2col:}({mansection ST stintreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:stintreg}
[{indepvars}] {ifin} [{it:{help stintreg##weight:weight}}]{cmd:,} 
{opth int:erval(stintreg##timevars:t_l t_u)} {opth dist:ribution(stintreg##distname:distname)}
[{it:options}]

{marker options_table}{...}
{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth int:erval(stintreg##timevars:t_l t_u)}}lower and upper endpoints for
the censoring interval{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{p2coldent:* {opth dist:ribution(stintreg##distname:distname)}}specify survival distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}

{syntab:Model 2}
{synopt :{opth st:rata(varname)}}strata ID variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opth anc:illary(varlist)}}use {it:varlist} to model the first ancillary parameter{p_end}
{synopt :{opth anc2(varlist)}}use {it:varlist} to model the second ancillary parameter{p_end}
{synopt :{cmdab:const:raints:(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt eps:ilon(#)}}tolerance to treat observations as uncensored; default is {cmd:epsilon(1e-6)}{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{opt nohead:er}}suppress header from coefficient table{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help stintreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help stintreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt interval(t_l t_u)} and {opt distribution(distname)} are required.

{marker distname}{...}
{synoptset 27}{...}
{synopthdr:distname}
{synoptline}
{synopt :{opt e:xponential}}exponential survival distribution{p_end}
{synopt :{opt gom:pertz}}Gompertz survival distribution{p_end}
{synopt :{opt logl:ogistic}}loglogistic survival distribution{p_end}
{synopt :{opt ll:ogistic}}synonym for {cmd:loglogistic}{p_end}
{synopt :{opt w:eibull}}Weibull survival distribution{p_end}
{synopt :{opt logn:ormal}}lognormal survival distribution{p_end}
{synopt :{opt ln:ormal}}synonym for {cmd:lognormal}{p_end}
{synopt :{opt ggam:ma}}generalized gamma survival distribution{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife},
{opt nestreg}, {opt statsby},
{opt stepwise}, and {opt svy} are allowed; see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and {cmd:noheader} are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp stintreg_postestimation ST:stintreg postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Regression models >}
    {bf:Interval-censored parametric survival models}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stintreg} fits parametric models to survival-time data that can be
uncensored, right-censored, left-censored, or interval-censored.  These models
are generalizations of the models fit by {helpb streg} to support
interval-censored data.  The supported survival models are exponential,
Weibull, Gompertz, lognormal, loglogistic, and generalized gamma.
Proportional-hazards (PH) and accelerated failure-time (AFT) parameterizations
are provided.

{pstd}
With interval-censored data, the survival-time variables are specified with
the {cmd:stintreg} command instead of using {helpb stset}.  Any {cmd:st}
settings are ignored by {cmd:stintreg}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stintregQuickstart:Quick start}

        {mansection ST stintregRemarksandexamples:Remarks and examples}

        {mansection ST stintregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt interval(t_l t_u)} specifies two time variables that contain the
endpoints of the censoring interval.  {it:t_l} represents the lower endpoint,
and {it:t_u} represents the upper endpoint.  {opt interval()} is required.

{marker timevars}{...}
{pmore}
The interval time variables {it:t_l} and {it:t_u} should have the following
form:

             Type of data{space 24}{it:t_l}{space 4}{it:t_u}
             {hline 50}
             uncensored data{space 9}{it:a} = [{it:a},{it:a}]{space 4}{it:a}{space 6}{it:a} 
             interval-censored data{space 6}({it:a},{it:b}]{space 4}{it:a}{space 6}{it:b}
             left-censored data{space 10}(0,{it:b}]{space 4}{cmd:.}{space 6}{it:b}
             left-censored data{space 10}(0,{it:b}]{space 4}0{space 6}{it:b}
             right-censored data{space 6}[{it:a},+inf){space 4}{it:a}{space 6}{cmd:.} 
	     missing{space 30}{cmd:.}{space 6}{cmd:.}
	     missing{space 30}0{space 6}{cmd:.}
             {hline 50}
	     
{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opth distribution:(stintreg##distname:distname)} specifies the survival model
to be fit.  {opt distribution()} is required.

{phang}
{cmd:time} specifies that the model be fit in the accelerated failure-time
metric rather than in the log relative-hazard metric or proportional hazards
metric.  This option is valid only for the exponential and Weibull models,
because these are the only models that have both a proportional hazards and an
accelerated failure-time parameterization.  Regardless of metric, the
likelihood function is the same, and models are equally appropriate viewed in
either metric; it is just a matter of changing the interpretation.

{dlgtab:Model 2}

{phang}
{opth strata(varname)} specifies the stratification ID variable.  Observations
with equal values of the variable are assumed to be in the same stratum.
Stratified estimates (with equal coefficients across strata but intercepts and
ancillary parameters unique to each stratum) are then obtained.  {it:varname}
may be a factor variable; see {help fvvarlist}.

{phang}
{opth offset(varname)}; see
      {helpb estimation options##offset():[R] Estimation options}.

{phang}
{opth ancillary(varlist)} specifies that the ancillary parameter for the
Weibull, lognormal, Gompertz, and loglogistic distributions and that the first
ancillary parameter (sigma) of the generalized log-gamma distribution be
estimated as a linear combination of {it:varlist}.

{pmore}
When an ancillary parameter is constrained to be strictly positive,
the logarithm of the ancillary parameter is modeled as a linear combination
of {it:varlist}

{phang}
{opth anc2(varlist)} specifies that the second ancillary parameter (kappa) for
the generalized log-gamma distribution be estimated as a linear combination of
{it:varlist}.

{phang}
{opt constraints(constraints)}; see
       {helpb estimation options##constraints():[R] Estimation options}.

{phang}
{opt epsilon(#)} specifies that observations with {it:t_u} - {it:t_l} < {it:#}
be treated as uncensored.  The default is {cmd:epsilon(1e-6)}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
       {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt nohr}, which may be specified at estimation or upon redisplaying
results, specifies that coefficients rather than exponentiated coefficients be
displayed, that is, that coefficients rather than hazard ratios be
displayed.  This option affects only how coefficients are displayed, not how
they are estimated.

{pmore}
This option is valid only for models with a natural proportional hazards
parameterization: exponential, Weibull, and Gompertz.  These three models, by
default, report hazards ratios (exponentiated coefficients).

{phang}
{opt tratio} specifies that exponentiated coefficients, which are interpreted
as time ratios, be displayed.  {opt tratio} is appropriate only for the
loglogistic, lognormal, and generalized gamma models, or for the exponential
and Weibull models when fit in the accelerated failure-time metric.

{pmore}
{opt tratio} may be specified at estimation or upon replay.

{phang}
{opt noheader} suppresses the output header, either at estimation or upon
replay.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}
 
{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)}, 
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, {opt grad:ient}, 
{opt showstep}, {opt hess:ian}, {opt showtol:erance}, {opt tol:erance(#)}, 
{opt ltol:erance(#)}, {opt nrtol:erance(#)}, 
{opt nonrtol:erance}, and {opt from(init_specs)}; see
{helpb maximize:[R] Maximize}.  These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt stintreg} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse aids}{p_end}

{pstd}Fit a Weibull survival model{p_end}
{phang2}{cmd:. stintreg i.stage, interval(ltime rtime) distribution(weibull)}

{pstd}Replay results, but display coefficients rather than hazard
ratios{p_end}
{phang2}{cmd:. stintreg, nohr}

{pstd}Fit a Weibull survival model in the accelerated failure-time
metric{p_end}
{phang2}{cmd:. stintreg i.stage, interval(ltime rtime) distribution(weibull) time}

{pstd}Fit a Weibull survival model, using {cmd:dose} to model the 
ancillary parameter{p_end}
{phang2}{cmd:. stintreg i.stage, interval(ltime rtime) distribution(weibull) ancillary(i.dose)}

{pstd}Fit a stratified Weibull survival model{p_end}
{phang2}{cmd:. stintreg i.stage, interval(ltime rtime) distribution(weibull) strata(dose)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stintreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt:{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt:{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt:{cmd:e(N_int)}}number of interval-censored observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(aux_p)}}ancillary parameter ({cmd:weibull}){p_end}
{synopt:{cmd:e(gamma)}}ancillary parameter ({cmd:gompertz, loglogistic}){p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:ggamma, lnormal}){p_end}
{synopt:{cmd:e(kappa)}}ancillary parameter ({cmd:ggamma}){p_end}
{synopt:{cmd:e(epsilon)}}tolerance for uncensored observations{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)}, constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}model or regression name{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:stintreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of time interval variables specified in {cmd:interval()}{p_end}
{synopt:{cmd:e(distribution)}}distribution{p_end}
{synopt:{cmd:e(strata)}}stratum variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(frm2)}}{cmd:hazard} or {cmd:time}{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(offset1)}}offset for main equation{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(predict_sub)}}{cmd:predict} subprogram{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
