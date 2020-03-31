{smcl}
{* *! version 1.3.3  14apr2019}{...}
{viewerdialog streg "dialog streg"}{...}
{viewerdialog "svy: streg" "dialog streg, message(-svy-) name(svy_streg)"}{...}
{vieweralsosee "[ST] streg" "mansection ST streg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] streg postestimation" "help streg postestimation"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: streg" "help bayes streg"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[FMM] fmm: streg" "help fmm streg"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "[PSS-2] power exponential" "help power exponential"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] stcrreg" "help stcrreg"}{...}
{vieweralsosee "[ST] stintreg" "help stintreg"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[XT] xtstreg" "help xtstreg"}{...}
{viewerjumpto "Syntax" "streg##syntax"}{...}
{viewerjumpto "Menu" "streg##menu"}{...}
{viewerjumpto "Description" "streg##description"}{...}
{viewerjumpto "Links to PDF documentation" "streg##linkspdf"}{...}
{viewerjumpto "Options" "streg##options"}{...}
{viewerjumpto "Examples" "streg##examples"}{...}
{viewerjumpto "Stored results" "streg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] streg} {hline 2}}Parametric survival models{p_end}
{p2col:}({mansection ST streg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:streg} [{indepvars}] {ifin} [{cmd:,} {it:options}]

{marker options_table}{...}
{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:e:xponential)}}exponential survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:gom:pertz)}}Gompertz survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:logl:ogistic)}}loglogistic survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ll:ogistic)}}synonym for {cmd:distribution(loglogistic)}{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:w:eibull)}}Weibull survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:logn:ormal)}}lognormal survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ln:ormal)}}synonym for {cmd:distribution(lognormal)}{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ggam:ma)}}generalized gamma survival distribution{p_end}
{synopt :{cmdab:fr:ailty(}{cmdab:g:amma)}}gamma frailty distribution{p_end}
{synopt :{cmdab:fr:ailty(}{cmdab:i:nvgaussian)}}inverse-Gaussian distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}

{syntab:Model 2}
{synopt :{opth st:rata(varname)}}strata ID variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opth sh:ared(varname)}}shared frailty ID variable{p_end}
{synopt :{opth anc:illary(varlist)}}use {it:varlist} to model the first ancillary parameter{p_end}
{synopt :{opth anc2(varlist)}}use {it:varlist} to model the second ancillary parameter{p_end}
{synopt :{cmdab:const:raints:(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{opt nos:how}}do not show st setting information{p_end}
{synopt :{opt nohead:er}}suppress header from coefficient table{p_end}
{synopt :{opt nolr:test}}do not perform likelihood-ratio test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help streg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help streg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:streg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp}, {opt jackknife},
{opt mfp}, {opt mi estimate}, {opt nestreg}, {opt statsby},
{opt stepwise}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_streg BAYES:bayes: streg} and
{manhelp fmm_streg FMM:fmm: streg}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}
{opt shared()},
{opt vce()},
and
{opt noheader}
are not allowed with the {helpb svy} prefix.
{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using
{cmd:stset}; see {manhelp stset ST}.  However, weights may not be specified
if you are using the {cmd:bootstrap} prefix with the {cmd:streg} command.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp streg_postestimation ST:streg postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Regression models >}
    {bf:Parametric survival models}


{marker description}{...}
{title:Description}

{pstd}
{cmd:streg} performs maximum likelihood estimation for parametric regression
survival-time models.  {cmd:streg} can be used with single- or multiple-record
or single- or multiple-failure st data.  Survival models currently supported
are exponential, Weibull, Gompertz, lognormal, loglogistic, and generalized
gamma.  Parametric frailty models and shared-frailty models are also fit
using {cmd:streg}.

{pstd}
Also see {manhelp stcox ST} for proportional hazards models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stregQuickstart:Quick start}

        {mansection ST stregRemarksandexamples:Remarks and examples}

        {mansection ST stregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt distribution(distname)} specifies the survival model to be fit.  A
specified {opt distribution()} is remembered from one estimation to the next
when {opt distribution()} is not specified.

{pmore}
For instance, typing {cmd:streg} {cmd:x1} {cmd:x2,}
{cmd:distribution(weibull)} fits a Weibull model.  Subsequently, you do
not need to specify {cmd:distribution(weibull)} to fit other Weibull
regression models.

{pmore}
All Stata estimation commands, including {cmd:streg}, redisplay results when
you type the command name without arguments.  To fit a model with no
explanatory variables, type {cmd:streg,} {opt distribution(distname)} ....

{phang}
{cmd:frailty(gamma} | {cmd:invgaussian)} specifies the assumed distribution of
the frailty, or heterogeneity.  The estimation results, in addition to the
standard parameter estimates, will contain an estimate of the variance of the
frailties and a likelihood-ratio test of the null hypothesis that this
variance is zero.  When this null hypothesis is true, the model reduces to the
model with {opt frailty(distname)} not specified.

{pmore}
A specified {opt frailty()} is remembered from one estimation to the next when
{opt distribution()} is not specified.  When you specify {opt distribution()},
the previously remembered specification of {opt frailty()} is forgotten.

{phang}
{cmd:time} specifies that the model be fit in the accelerated failure-time
metric rather than in the log relative-hazard metric.  This option is
valid only for the exponential and Weibull models because these are the only
models that have both a proportional hazards and an accelerated failure-time
parameterization.  Regardless of metric, the likelihood function is the same,
and models are equally appropriate viewed in either metric; it is just a matter
of changing interpretation.

{pmore}
{opt time} must be specified at estimation.

{dlgtab:Model 2}

{phang}
{opth strata(varname)} specifies the stratification ID variable.  Observations
with equal values of the variable are assumed to be in the same stratum.
Stratified estimates (with equal coefficients across strata but intercepts and
ancillary parameters unique to each stratum) are then obtained.  This option
is not available if {opt frailty(distname)} is specified.

{phang}
{opth offset(varname)}; see
      {helpb estimation options##offset():[R] Estimation options}.

{phang}
{opth shared(varname)} is valid with {opt frailty()} and specifies a variable
defining those groups over which the frailty is shared, analogous to a
random-effects model for panel data where {it:varname} defines the panels.
{opt frailty()} specified without {opt shared()} treats the frailties as
occurring at the observation level.

{pmore}
A specified {opt shared()} is remembered from one estimation to the next when
{opt distribution()} is not specified.  When you specify {opt distribution()},
the previously remembered specification of {opt shared()} is forgotten.

{pmore}
{cmd:shared()} may not be used with {cmd:distribution(ggamma)},
{cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)}, {cmd:vce(opg)},
the {cmd:svy} prefix, or in the presence of delayed entries or gaps.

{pmore}
If {opt shared()} is specified without {opt frailty()} and there is no
remembered {opt frailty()} from the previous estimation, {cmd:frailty(gamma)}
is assumed to provide behavior analogous to {cmd:stcox}; see {manhelp stcox ST}.

{phang}
{opth ancillary(varlist)} specifies that the ancillary
parameter for the Weibull, lognormal, Gompertz, and loglogistic distributions
and that the first ancillary parameter (sigma) of the generalized log-gamma
distribution be estimated as a linear combination of {it:varlist}.
This option may not be used with {opt frailty(distname)}.

{pmore}
When an ancillary parameter is constrained to be strictly positive,
the logarithm of the ancillary parameter is modeled as a linear combination
of {it:varlist}.

{phang}
{opth anc2(varlist)} specifies that the second ancillary parameter (kappa) for
the generalized log-gamma distribution be estimated as a linear combination of
{it:varlist}.  This option may not be used with {opt frailty(distname)}.

{phang}
{opt constraints(constraints)}; see
       {helpb estimation options##constraints():[R] Estimation options}.

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
This option is valid only for models with a natural proportional-hazards
parameterization: exponential, Weibull, and Gompertz.  These three models, by
default, report hazards ratios (exponentiated coefficients).

{phang}
{opt tratio} specifies that exponentiated coefficients, which are
interpreted as time ratios, be displayed.  {opt tratio} is appropriate only for the
loglogistic, lognormal, and generalized gamma models, or for the exponential
and Weibull models when fit in the accelerated failure-time metric.

{pmore}
{opt tratio} may be specified at estimation or upon replay.

{phang}
{opt noshow} prevents {cmd:streg} from showing the key st variables.  This
option is rarely used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set once and for all whether they want to see these
variables mentioned at the top of the output of every st command; see 
{manhelp stset ST}.

{phang}
{opt noheader} suppresses the output header, either at estimation or upon
replay.  

{phang}
{opt nolrtest} is valid only with frailty models, in which case it suppresses
the likelihood-ratio test for significant frailty.

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
{helpb maximize:[R] Maximize} These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt streg} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse kva}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset failtime}

{pstd}Fit a Weibull survival model{p_end}
{phang2}{cmd:. streg load bearings, distribution(weibull)}

{pstd}Replay results, but display coefficients rather than hazard
ratios{p_end}
{phang2}{cmd:. streg, nohr}

{pstd}Fit a Weibull survival model in the accelerated failure-time
metric{p_end}
{phang2}{cmd:. streg load bearings, distribution(weibull) time}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail}

{pstd}Fit a Weibull survival model using data that has multiple failures per
subject, and specify robust standard errors{p_end}
{phang2}{cmd:. streg x1 x2, distribution(weibull) vce(robust)}

{pstd}Same as above, but fit exponential model rather than Weibull{p_end}
{phang2}{cmd:. streg x1 x2, distribution(exp) vce(robust)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cancer}

{pstd}Map values for {cmd:drug} into 0 for placebo and 1 for nonplacebo{p_end}
{phang2}{cmd:. replace drug = drug == 2 | drug == 3}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset studytime, failure(died)}

{pstd}Fit a generalized gamma survival model{p_end}
{phang2}{cmd:. streg drug age, distribution(ggamma)}

{pstd}Test for appropriateness of Weibull model{p_end}
{phang2}{cmd:. test [/kappa] = 1}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hip3, clear}

{pstd}Fit a Weibull survival model, using {cmd:male} to model the 
ancillary parameter{p_end}
{phang2}{cmd:. streg protect age, dist(weibull) ancillary(male)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cancer}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset studytime died}

{pstd}Fit a stratified Weibull survival model{p_end}
{phang2}{cmd:. streg age, dist(weibull) strata(drug)}

{pstd}Produce a "less-stratified" model than above{p_end}
{phang2}{cmd:. streg age, dist(weibull) ancillary(i.drug)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bc}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/12}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset t, fail(dead)}

{pstd}Fit Weibull survival model with gamma-distributed frailty{p_end}
{phang2}{cmd:. streg age smoking, dist(weibull) frailty(gamma)}

{pstd}Fit Weibull survival model with inverse-Gaussian-distributed frailty
{p_end}
{phang2}{cmd:. streg age smoking, dist(weibull) frailty(invgauss)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/10}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, fail(infect)}

{pstd}Fit Weibull survival model with inverse-Gaussian-distributed shared
frailty{p_end}
{phang2}{cmd:. streg age female, dist(weibull) frailty(invgauss) shared(patient)}

{pstd}Same as above, but fit lognormal model rather than Weibull{p_end}
{phang2}{cmd:. streg age female, dist(lnormal) frailty(invgauss) shared(patient)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhefs}

{pstd}Declare survey design for data{p_end}
{phang2}{cmd:. svyset psu2 [pw=swgt2], strata(strata2)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset age_lung_cancer if age_lung_cancer < . [pw=swgt2],}
             {cmd:fail(lung_cancer)}

{pstd}Fit exponential survival model taking into account data are survey
data{p_end}
{phang2}{cmd:. svy: streg former_smoker smoker male urban1 rural, dist(exp)}
{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:streg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_sub)}}number of subjects{p_end}
{synopt:{cmd:e(N_fail)}}number of failures{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison model{p_end}
{synopt:{cmd:e(risk)}}total time at risk{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(theta)}}frailty parameter{p_end}
{synopt:{cmd:e(aux_p)}}ancillary parameter ({cmd:weibull}){p_end}
{synopt:{cmd:e(gamma)}}ancillary parameter ({cmd:gompertz, loglogistic}){p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:ggamma, lnormal}){p_end}
{synopt:{cmd:e(kappa)}}ancillary parameter ({cmd:ggamma}){p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)}, constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}model or regression name{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:streg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(dead)}}{cmd:_d}{p_end}
{synopt:{cmd:e(depvar)}}{cmd:_t}{p_end}
{synopt:{cmd:e(strata)}}stratum variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(shared)}}frailty grouping variable{p_end}
{synopt:{cmd:e(fr_title)}}title in output identifying frailty{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(t0)}}{cmd:_t0}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(frm2)}}{cmd:hazard} or {cmd:time}{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(offset1)}}offset for main equation{p_end}
{synopt:{cmd:e(stcurve)}}{cmd:stcurve}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(predict_sub)}}{cmd:predict} subprogram{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
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
