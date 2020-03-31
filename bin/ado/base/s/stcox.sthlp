{smcl}
{* *! version 2.2.2  12dec2018}{...}
{viewerdialog stcox "dialog stcox"}{...}
{viewerdialog "svy: stcox" "dialog stcox, message(-svy-) name(svy_stcox)"}{...}
{vieweralsosee "[ST] stcox" "mansection ST stcox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox postestimation" "help stcox postestimation"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[PSS-2] power cox" "help power cox"}{...}
{vieweralsosee "[ST] stcox PH-assumption tests" "help stcox_diagnostics"}{...}
{vieweralsosee "[ST] stcrreg" "help stcrreg"}{...}
{vieweralsosee "[ST] stintreg" "help stintreg"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "stcox##syntax"}{...}
{viewerjumpto "Menu" "stcox##menu"}{...}
{viewerjumpto "Description" "stcox##description"}{...}
{viewerjumpto "Links to PDF documentation" "stcox##linkspdf"}{...}
{viewerjumpto "Options" "stcox##options"}{...}
{viewerjumpto "Examples" "stcox##examples"}{...}
{viewerjumpto "Stored results" "stcox##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] stcox} {hline 2}}Cox proportional hazards model{p_end}
{p2col:}({mansection ST stcox:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:stcox} [{indepvars}] {ifin} [{cmd:,}
{it:options}] 

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt esti:mate}}fit model without covariates{p_end}
{synopt :{opth st:rata(varlist:varnames)}}strata ID variables{p_end}
{synopt :{opth sh:ared(varname)}}shared-frailty ID variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opt bre:slow}}use Breslow method to handle tied failures; the default{p_end}
{synopt :{opt efr:on}}use Efron method to handle tied failures{p_end}
{synopt :{opt exactm}}use exact marginal-likelihood method to handle tied failures{p_end}
{synopt :{opt exactp}}use exact partial-likelihood method to handle tied failures{p_end}

{syntab:Time varying}
{synopt :{opth tvc(varlist)}}time-varying covariates{p_end}
{synopt :{opth texp(exp)}}multiplier for time-varying covariates; default is {cmd:texp(_t)}{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
  {opt jack:knife}{p_end}
{synopt :{opt noadj:ust}}do not use standard degree-of-freedom adjustment{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nohr}}report coefficients, not hazard ratios{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{it:{help stcox##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help stcox##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stcox}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {opt fp}, {cmd:jackknife}, {opt mfp},
{cmd:mi estimate}, {cmd:nestreg}, {cmd:statsby}, {cmd:stepwise}, and {cmd:svy}
are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}
{opt estimate},
{opt shared()},
{opt efron},
{opt exactm},
{opt exactp},
{opt tvc()},
{opt texp()},
{opt vce()},
and
{opt noadjust}
are not allowed with the {helpb svy} prefix.
{p_end}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s may be specified using 
{cmd:stset}; see {manhelp stset ST}. Weights are not supported with 
{cmd:efron} and {cmd:exactp}.  Also weights may not be specified if
you are using the {cmd:bootstrap} prefix with the {cmd:stcox} command.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp stcox_postestimation ST:stcox postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Regression models >}
     {bf:Cox proportional hazards model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stcox} fits, via maximum likelihood, proportional hazards models on 
st data.  {cmd:stcox} can be used with single- or multiple-record or 
single- or multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stcoxQuickstart:Quick start}

        {mansection ST stcoxRemarksandexamples:Remarks and examples}

        {mansection ST stcoxMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt estimate} forces fitting of the null model.  All Stata estimation
commands redisplay results when the command name is typed without arguments.
So does {cmd:stcox}.  What if you wish to fit a Cox model on xb, where xb is 
defined as 0?  Logic says that you would type {cmd:stcox}.  There are no 
explanatory variables, so there is nothing to type after the command.
Unfortunately, this looks the same as {cmd:stcox} typed without 
arguments, which is a request to redisplay results.

{pmore}
To fit the null model, type {cmd:stcox, estimate}.

{marker strata()}{...}
{phang}
{opth strata:(varlist:varnames)} specifies up to five strata variables.
Observations with equal values of the strata variables are assumed to be in 
the same stratum. Stratified estimates (equal coefficients across strata but 
with a baseline hazard unique to each stratum) are then obtained.

{phang}
{opth shared(varname)} specifies that a Cox model with shared frailty be 
fit.  Observations with equal value of {it:varname} are assumed to have
shared (the same) frailty.  Across groups, the frailties are assumed to be
gamma-distributed latent random effects that affect the hazard multiplicatively,
or, equivalently, the logarithm of the frailty enters the linear predictor as 
a random offset.  Think of a shared-frailty model as a Cox model for panel data.
{it:varname} is a variable in the data that identifies the groups.
{cmd:shared()} is not allowed in the presence of delayed entries or gaps.

{pmore}
Shared-frailty models are discussed more in
{mansection ST stcoxRemarksandexamplesCoxregressionwithsharedfrailty:{it:Cox regression with shared frailty}} of {bf:[ST] stcox}.

{phang}
{opth offset(varname)}; see
{helpb estimation options##offset():[R] Estimation options}.

{phang}
{opt breslow}, {opt efron}, {opt exactm}, and {opt exactp} specify the
 method for handling tied failures in the calculation of the log partial 
likelihood (and residuals). {opt breslow} is the default.  
Each method is described in 
{mansection ST stcoxRemarksandexamplesTreatmentoftiedfailuretimes:{it:Treatment of tied failure times}} in {bf:[ST] stcox}.
{opt efron} and the exact methods require substantially more computer time than
the default {opt breslow} option. {opt exactm} and {opt exactp} may not be 
specified with {opt tvc()}, {cmd:vce(robust)}, or {cmd:vce(cluster}
{it:clustvar}{cmd:)}.

{dlgtab: Time varying}

{phang}
{opth tvc(varlist)} specifies those variables that vary continuously with 
respect to time, that is, time-varying covariates.  This is a convenience
option used to speed up calculations and to avoid having to {helpb stsplit} the
data over many failure times.

{pmore}
Most predictions are not available after estimation with {opt tvc()}. 
These predictions require that the data be {cmd:stsplit} to generate
the requested information; see {help tvc_note:tvc note}.

{phang}
{opth texp(exp)} is used in conjunction with {opth tvc(varlist)} to specify 
the function of analysis time that should be multiplied by the time-varying 
covariates. For example, specifying {cmd:texp(ln(_t))} would cause the 
time-varying covariates to be multiplied by the logarithm of analysis time. If 
{opt tvc(varlist)} is used without {opt texp(exp)}, Stata understands 
that you mean {cmd:texp(_t)} and thus multiplies the time-varying covariates 
by the analysis time.

{pmore}
Both {opt tvc(varlist)} and {opt texp(exp)} are explained more in the 
section on {mansection ST stcoxRemarksandexamplesCoxregressionwithcontinuoustime-varyingcovariates:{it:Cox regression with continuous time-varying covariates}}
in {bf:[ST] stcox}.

{dlgtab: SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{phang}
{opt noadjust} is for use with {cmd:vce(robust)} or {cmd:vce(cluster}
{it:clustvar}{cmd:)}. {opt noadjust} prevents the estimated variance matrix
from being multiplied by N/(N-1) or g/(g-1), where g is the number of
clusters.  The default adjustment is somewhat arbitrary because it is not
always clear how to count observations or clusters.  In such cases, however,
the adjustment is likely to be biased toward 1, so we would still recommend
making it.

{dlgtab: Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt nohr} specifies that coefficients be displayed rather than exponentiated
coefficients or hazard ratios.  This option affects only how results are
displayed and not how they are estimated.  {opt nohr} may be specified at
estimation time or when redisplaying previously estimated results (which you
do by typing {cmd:stcox} without a variable list).

{phang}
{opt noshow} prevents {cmd:stcox} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of the output of every st command; see {manhelp stset ST}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}
 
{phang}
{it:maximize_options}: {opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt tol:erance(#)}, {opt ltol:erance(#)}, and {opt nrtol:erance(#)},
{opt nonrtol:erance}; see {helpb maximize:[R] Maximize}.  These
options are seldom used.
 
{pstd}
The following option is available with {opt stcox} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.

 
{marker examples}{...}
{title:Example of Cox regression with uncensored data}
 
{pstd}Setup{p_end}
{phang2}{cmd:. webuse kva}{p_end}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset failtime}{p_end}

{pstd}Fit Cox proportional hazards model{p_end}
{phang2}{cmd:. stcox load bearings}{p_end}

{pstd}Replay results, but show coefficients rather than hazard ratios{p_end}
{phang2}{cmd:. stcox, nohr}{p_end}


{title:Example of Cox regression with censored data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drugtr}{p_end}

{pstd}Show st settings{p_end}
{phang2}{cmd:. stset}

{pstd}Fit Cox proportional hazards model{p_end}
{phang2}{cmd:. stcox drug age}


{title:Example of Cox regression with discrete time-varying covariates}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}{p_end}
{phang2}{cmd:. stset}

{pstd}Fit Cox model{p_end}
{phang2}{cmd:. stcox age posttran surg year}

{pstd}Obtain robust estimate of variance{p_end}
{phang2}{cmd:. stcox age posttran surg year, vce(robust)}


{title:Example of Cox regression with continuous time-varying covariates}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drugtr2}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/12, sep(0)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, failure(cured)}

{pstd}Fit Cox model{p_end}
{phang2}{cmd:. stcox age drug1 drug2}

{pstd}Refit model taking into account that the actual level of the drug
remaining in the body diminishes exponentially with time{p_end}
{phang2}{cmd:. stcox age, tvc(drug1 drug2) texp(exp(-0.35*_t))}


{title:Example of Cox regression with multiple-failure data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail}

{pstd}Fit model with robust estimate of variance{p_end}
{phang2}{cmd:. stcox x1 x2, vce(robust)}


{title:Example of stratified estimation}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Modify data to reflect changes in treatment 1970 and 1973{p_end}
{phang2}{cmd:. generate pgroup = year}{p_end}
{phang2}{cmd:. recode pgroup min/69=1 70/72=2 73/max=3}

{pstd}Fit Cox model{p_end}
{phang2}{cmd:. stcox age posttran surg year, strata(pgroup)}


{title:Example of Cox regression with shared frailty}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter, clear}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/10}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, fail(infect)}

{pstd}Fit Cox model{p_end}
{phang2}{cmd:. stcox age female, shared(patient)}


{title:Example of Cox regression with survey data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhefs}

{pstd}Declare survey design for data{p_end}
{phang2}{cmd:. svyset psu2 [pw=swgt2], strata(strata2)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset age_lung_cancer if age_lung_cancer < . [pw=swgt2],}
                   {cmd:fail(lung_cancer)}

{pstd}Fit Cox model taking into account that data are survey data{p_end}
{phang2}{cmd:. svy: stcox former_smoker smoker male urban1 rural}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stcox} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_sub)}}number of subjects{p_end}
{synopt:{cmd:e(N_fail)}}number of failures{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt:{cmd:e(risk)}}total time at risk{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(theta)}}frailty parameter{p_end}
{synopt:{cmd:e(se_theta)}}standard error of theta{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:cox} or {cmd:stcox_fr}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:stcox}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}{cmd:_t}{p_end}
{synopt:{cmd:e(t0)}}{cmd:_t0}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(texp)}}function used for time-varying covariates{p_end}
{synopt:{cmd:e(ties)}}method used for handling ties{p_end}
{synopt:{cmd:e(strata)}}strata variables{p_end}
{synopt:{cmd:e(shared)}}frailty grouping variable{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(method)}}requested estimation method{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance estimator{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
