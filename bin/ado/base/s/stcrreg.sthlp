{smcl}
{* *! version 1.3.1  12dec2018}{...}
{viewerdialog stcrreg "dialog stcrreg"}{...}
{vieweralsosee "[ST] stcrreg" "mansection ST stcrreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcrreg postestimation" "help stcrreg postestimation"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] stcox PH-assumption tests" "help stcox_diagnostics"}{...}
{vieweralsosee "[ST] stcox postestimation" "help stcox_postestimation"}{...}
{vieweralsosee "[ST] stintreg" "help stintreg"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stcrreg##syntax"}{...}
{viewerjumpto "Menu" "stcrreg##menu"}{...}
{viewerjumpto "Description" "stcrreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "stcrreg##linkspdf"}{...}
{viewerjumpto "Options" "stcrreg##options"}{...}
{viewerjumpto "Examples" "stcrreg##examples"}{...}
{viewerjumpto "Stored results" "stcrreg##results"}{...}
{viewerjumpto "Reference" "stcrreg##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[ST] stcrreg} {hline 2}}Competing-risks regression{p_end}
{p2col:}({mansection ST stcrreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:stcrr:eg} [{indepvars}] {ifin}{cmd:,}
{cmdab:comp:ete(}{it:crvar}[{cmd:==}{it:{help numlist}}]{cmd:)} 
[{it:options}] 

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {cmdab:comp:ete(}{it:crvar}[{cmd:==}{it:{help numlist}}]{cmd:)}}specify competing-risks
event(s){p_end}
{synopt :{cmd:tvc({help varlist:{it:tvarlist}})}}time-varying covariates{p_end}
{synopt :{opth texp(exp)}}multiplier for time-varying covariates; default is {cmd:texp(_t)}{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints:(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
  {opt jack:knife}{p_end}
{synopt :{opt noadj:ust}}do not use standard degree-of-freedom adjustment{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt noshr}}report coefficients, not subhazard ratios{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt nohead:er}}suppress header from coefficient table{p_end}
{synopt :{opt notable}}suppress coefficient table{p_end}
{synopt :{opt nodisplay}}suppress output; iteration log is still displayed{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help stcrreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help stcrreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{cmdab:col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt compete(crvar[==numlist])} is required.{p_end}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stcrreg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:varlist} and {it:tvarlist}
may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, {cmd:mfp}, 
{cmd:mi estimate}, {cmd:nestreg}, {cmd:statsby}, and {cmd:stepwise} are
allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}
Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s may be specified using 
{cmd:stset}; see {manhelp stset ST}. In multiple-record data, weights
are applied to subjects as a whole, not to individual observations.
{cmd:iweight}s are treated as {cmd:fweight}s that can be noninteger, 
but not negative.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp stcrreg_postestimation ST:stcrreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Regression models >}
     {bf:Competing-risks regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stcrreg} fits, via maximum likelihood, competing-risks regression models
on st data, according to the method of 
{help stcrreg##FG1999:Fine and Gray (1999)}.  Competing-risks
regression posits a model for the subhazard function of a failure event of
primary interest.  In the presence of competing failure events that impede the
event of interest, a standard analysis using Cox regression (see {helpb stcox})
is able to produce incidence-rate curves that either 1) are appropriate only
for a hypothetical universe where competing events do not occur or 2) are
appropriate for the data at hand, yet the effects of covariates on these curves
are not easily quantified.  Competing-risks regression, as performed using
{cmd:stcrreg}, provides an alternative model that can produce incidence curves
that represent the observed data and for which describing covariate effects is
straightforward.

{pstd}
{cmd:stcrreg} can be used with single- or multiple-record data.
{cmd:stcrreg} cannot be used when you have multiple failures per subject.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stcrregQuickstart:Quick start}

        {mansection ST stcrregRemarksandexamples:Remarks and examples}

        {mansection ST stcrregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:compete(}{it:crvar}[{cmd:==}{it:{help numlist}}{cmd:])} is required and
specifies the events that are associated with failure due to competing risks.

{pmore}
If {opt compete(crvar)} is specified, {it:crvar} is interpreted as an 
indicator variable; any nonzero, nonmissing values are interpreted as 
representing competing events.

{pmore}
If {opt compete(crvar==numlist)} is specified, records with {it:crvar} taking
on any of the values in {it:numlist} are assumed to be competing
events.

{pmore}
The syntax for {cmd:compete()} is the same as that for {cmd:stset}'s
{cmd:failure()} option.  Use {cmd:stset, failure()} to specify the failure
event of interest, that is, the failure event you wish to model using
{cmd:stcox}, {cmd:streg}, {cmd:stcrreg}, or whatever.  Use
{cmd:stcrreg, compete()} to specify the event or events that compete with the
failure event of interest.  Competing events, because they are not the failure
event of primary interest, must be {cmd:stset} as censored.  

{pmore}
If you have multiple records per subject, only the value of {it:crvar} for 
the last chronological record for each subject is used to determine the 
event type for that subject.

{phang}
{cmd:tvc({help varlist:{it:tvarlist}})} specifies those variables that vary
continuously with respect to time, that is, time-varying covariates.  These
variables are multiplied by the function of time specified in {cmd:texp()}.

{phang}
{opth texp(exp)} is used in conjunction with 
{cmd:tvc({help varlist:{it:tvarlist}})} to specify the function of analysis
time that should be multiplied by the time-varying covariates. For example,
specifying {cmd:texp(ln(_t))} would cause the time-varying covariates to be
multiplied by the logarithm of analysis time. If {opt tvc(tvarlist)} is used
without {opt texp(exp)}, Stata understands that you mean {cmd:texp(_t)}, and
thus multiplies the time-varying covariates by the analysis time.

{pmore}
Both {opt tvc(tvarlist)} and {opt texp(exp)} are explained more in
{mansection ST stcrregRemarksandexamplesOptiontvc()andtestingtheproportional-subhazardsassumption:{it:Option tvc() and testing the proportional-subhazards assumption}}
in {bf:[ST] stcrreg}.

{phang}
{opth offset(varname)}, {opt constraints(constraints)}; see
         {helpb estimation options##offset():[R] Estimation options}.

{dlgtab: SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which 
includes types that are robust to some kinds of misspecification
({cmd:robust}), that allow for intragroup correlation ({cmd:cluster}
{it:clustvar}), and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.
{cmd:vce(robust)} is the default in single-record-per-subject st data.  For
multiple-record st data, {cmd:vce(cluster }{it:idvar}{cmd:)} is the default,
where {it:idvar} is the ID variable previously {cmd:stset}.

{pmore}
Standard Hessian-based standard errors -- {it:vcetype}
{cmd:oim} -- are not statistically appropriate for this model and 
thus are not allowed.

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
{opt noshr} specifies that coefficients be displayed rather than exponentiated
coefficients or subhazard ratios.  This option affects only how results are
displayed and not how they are estimated.  {opt noshr} may be specified at
estimation time or when redisplaying previously estimated results (which you
do by typing {cmd:stcrreg} without a variable list).

{phang}
{opt noshow} prevents {cmd:stcrreg} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of the output of every st command; see {manhelp stset ST}.

{phang}
{opt noheader} suppresses the header information from the output.  The 
coefficient table is still displayed. {opt noheader} may be specified at 
estimation time or when redisplaying previously estimated results.

{phang}
{opt notable} suppresses the table of coefficients from the output.  The
header information is still displayed.  {opt notable} may be specified at
estimation time or when redisplaying previously estimated results.

{phang}
{opt nodisplay} suppresses the output.  The iteration log is still 
displayed.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

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
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.
 
{pstd}
The following options are available with {opt stcrreg} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.

 
{marker examples}{...}
{title:Examples}
 
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hypoxia}{p_end}

{pstd}Declare data to be survival-time data and declare the failure event 
of interest, that is, the event to be modeled{p_end}
{phang2}{cmd:. stset dftime, failure(failtype==1)}{p_end}

{pstd}Fit competing-risks model with {cmd:failtype==2} as the competing 
event{p_end}
{phang2}{cmd:. stcrreg ifp tumsize pelnode, compete(failtype==2)}{p_end}

{pstd}Replay results, but show coefficients rather than subhazard ratios{p_end}
{phang2}{cmd:. stcrreg, noshr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stcrreg} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_sub)}}number of subjects{p_end}
{synopt:{cmd:e(N_fail)}}number of failures{p_end}
{synopt:{cmd:e(N_compete)}}number of competing events{p_end}
{synopt:{cmd:e(N_censor)}}number of censored subjects{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log pseudolikelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(fmult)}}{cmd:1} if > 1 failure events, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(crmult)}}{cmd:1} if > 1 competing events, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(fnz)}}{cmd:1} if nonzero indicates failure, {cmd:0}
otherwise{p_end}
{synopt:{cmd:e(crnz)}}{cmd:1} if nonzero indicates competing, {cmd:0} 
otherwise{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:stcrreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(mainvars)}}variables in main equation{p_end}
{synopt:{cmd:e(tvc)}}time-varying covariates{p_end}
{synopt:{cmd:e(texp)}}function used for time-varying covariates{p_end}
{synopt:{cmd:e(fevent)}}failure event(s) in estimation output{p_end}
{synopt:{cmd:e(crevent)}}competing event(s) in estimation output{p_end}
{synopt:{cmd:e(compete)}}competing event(s) as typed{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log{p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker FG1999}{...}
{phang}
Fine, J. P., and R. J. Gray. 1999. A proportional hazards model for the
subdistribution of a competing risk.
{it:Journal of the American Statistical Association} 94: 496-509.
{p_end}
