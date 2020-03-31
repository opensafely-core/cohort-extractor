{smcl}
{* *! version 1.0.17  19dec2018}{...}
{viewerdialog xtstreg "dialog xtstreg"}{...}
{vieweralsosee "[XT] xtstreg" "mansection XT xtstreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtstreg postestimation" "help xtstreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "[XT] quadchk" "help quadchk"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtstreg##syntax"}{...}
{viewerjumpto "Menu" "xtstreg##menu"}{...}
{viewerjumpto "Description" "xtstreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtstreg##linkspdf"}{...}
{viewerjumpto "Options" "xtstreg##options"}{...}
{viewerjumpto "Examples" "xtstreg##examples"}{...}
{viewerjumpto "Stored results" "xtstreg##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[XT] xtstreg} {hline 2}}Random-effects parametric survival models{p_end}
{p2col:}({mansection XT xtstreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:xtstreg} [{indepvars}] {ifin} {weight}{cmd:,}
	{opth dist:ribution(xtstreg##distname:distname)}
        [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{p2coldent :* {cmdab:dist:ribution(}{it:{help xtstreg##distname:distname}}{cmd:)}}specify survival distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opth const:raints(estimation options##constraints():constraints)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
   {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt lrmodel}}perform the likelihood-ratio model test instead of the
default Wald test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{it:{help xtstreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help intpts1
 
{syntab :Maximization}
{synopt :{it:{help xtstreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opth startg:rid(numlist)}}improve starting value of the
random-intercept parameter by performing a grid search{p_end}
{synopt:{opt nodis:play}}suppress display the header and coefficients{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt distribution(distname)} is required.{p_end}

{marker distname}{...}
{synoptset 29}{...}
{synopthdr:distname}
{synoptline}
{synopt:{cmdab:e:xponential}}exponential survival distribution{p_end}
{synopt:{cmdab:logl:ogistic}}loglogistic survival distribution{p_end}
{synopt:{cmdab:ll:ogistic}}synonym for {cmd:loglogistic}{p_end}
{synopt:{cmdab:w:eibull}}Weibull survival distribution{p_end}
{synopt:{cmdab:logn:ormal}}lognormal survival distribution{p_end}
{synopt:{cmdab:ln:ormal}}synonym for {cmd:lognormal}{p_end}
{synopt:{cmdab:gam:ma}}gamma survival distribution{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:stset} your data before using {cmd:xtstreg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
A panel variable must be specified; see {helpb xtset}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt fp}, and {opt statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.
Weights must be constant within panel.{p_end}
{p 4 6 2}
{opt startgrid()}, {opt nodisplay}, {opt collinear}, and {opt coeflegend} do not
appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtstreg_postestimation XT:xtstreg postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Survival models >}
    {bf:Parametric survival models (RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtstreg} fits random-effects parametric survival-time models.
The conditional distribution of the response given the random effects is
assumed to be an exponential, a Weibull, a lognormal, a loglogistic, or a
gamma distribution.  {cmd:xtstreg} can be used with single- or multiple-record
st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtstregQuickstart:Quick start}

        {mansection XT xtstregRemarksandexamples:Remarks and examples}

        {mansection XT xtstregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant};
see {helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt distribution(distname)} specifies the survival model to be fit.
{it:distname} is one of the following: {opt exponential}, {opt loglogistic},
{opt llogistic}, {opt weibull}, {opt lognormal}, {opt lnormal}, or {opt gamma}.
This option is required.

{phang}
{cmd:time} specifies that the model be fit in the accelerated failure-time
metric rather than in the log relative-hazard metric.  This option is
valid only for the exponential and Weibull models because these are the only
models that have both a proportional-hazards and an accelerated failure-time
parameterization.  Regardless of metric, the likelihood function is the same,
and models are equally appropriate in either metric; it is just a matter
of changing interpretation.

{pmore}
{opt time} must be specified at estimation.

{phang}
{opth offset(varname)} specifies that {it:varname} be included
in the fixed-effects portion of the model with the coefficient
constrained to be 1.

{phang}
{opt constraints(constraints)}; see
       {helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), and
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}); see
{helpb vce_option:[R] {it:vce_option}}.  If {cmd:vce(robust)} is specified,
robust variances are clustered at the highest level in the multilevel model.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtstregMethodsandformulasxtstregandtherobustVCEestimator:{it:xtstreg and the robust VCE estimator}} under
{it:Methods and formulas} in {bf:[XT] xtstreg}.

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
This option is valid only for the exponential and Weibull models because they
have a natural proportional-hazards parameterization.
These two models, by default, report hazards ratios
(exponentiated coefficients).

{phang}
{opt noshow} prevents {cmd:xtstreg} from showing the key st variables.  This
option is rarely used because most users type {cmd:stset, show} or 
{cmd:stset, noshow} to set once and for all whether they want to see these
variables mentioned at the top of the output of every st command; see 
{manhelp stset ST}.

{phang}
{opt lrmodel},
{opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

{phang}
{opt tratio} specifies that exponentiated coefficients, which are
interpreted as time ratios, be displayed.  {opt tratio} is appropriate only
for the loglogistic, lognormal, and gamma models or for the exponential
and Weibull models when fit in the accelerated failure-time metric.

{pmore}
{opt tratio} may be specified at estimation or upon replay.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{opt intmethod(intmethod)},
{opt intpoints(#)}; see
     {helpb estimation options:[R] Estimation options}.

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
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {opt xtstreg} but are not shown in the
dialog box:

{phang}
{opth startgrid(numlist)} performs a grid search to improve the starting
value of the random-intercept parameter.  No grid search is performed by
default unless the starting value is found to be not feasible, in which case
{opt xtstreg} runs {cmd:startgrid(0.1 1 10)} and chooses the value that works
best.  You may already be using a default form of {opt startgrid()} without
knowing it.  If you see {opt xtstreg} displaying Grid node 1, Grid node 2,
... following Grid node 0 in the iteration log, that is {opt xtstreg}
doing a default search because the original starting value was not
feasible.

{phang}
{opt nodisplay} is for programmers.  It suppresses the display of the header
and the coefficients.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter}{p_end}
{phang2}{cmd:. xtset patient}{p_end}

{pstd}Random-effects Weibull survival model{p_end}
{phang2}{cmd:. xtstreg age female, distribution(weibull)}

{pstd}Replay results, but display coefficients rather than hazard ratios{p_end}
{phang2}{cmd:. xtstreg, nohr}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtstreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison model{p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(n_quad)}}number of quadrature points{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:xtstreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}{cmd:_t}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(model)}}model name{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(distribution)}}distribution{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(frm2)}}{cmd:hazard} or {cmd:time}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
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
