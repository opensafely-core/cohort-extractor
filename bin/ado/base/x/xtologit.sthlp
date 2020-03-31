{smcl}
{* *! version 1.0.20  12dec2018}{...}
{viewerdialog xtologit "dialog xtologit"}{...}
{vieweralsosee "[XT] xtologit" "mansection XT xtologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtologit postestimation" "help xtologit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[ME] meologit" "help meologit"}{...}
{vieweralsosee "[XT] quadchk" "help quadchk"}{...}
{vieweralsosee "[XT] xtoprobit" "help xtoprobit"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtologit##syntax"}{...}
{viewerjumpto "Menu" "xtologit##menu"}{...}
{viewerjumpto "Description" "xtologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtologit##linkspdf"}{...}
{viewerjumpto "Options" "xtologit##options"}{...}
{viewerjumpto "Technical note" "xtologit##technote"}{...}
{viewerjumpto "Example" "xtologit##example"}{...}
{viewerjumpto "Video example" "xtologit##video"}{...}
{viewerjumpto "Stored results" "xtologit##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[XT] xtologit} {hline 2}}Random-effects ordered logistic models{p_end}
{p2col:}({mansection XT xtologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:xtologit} {depvar} [{indepvars}] {ifin}
[{it:{help xtologit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 27 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Model}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opth const:raints(estimation options##constraints():constraints)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
   {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{opt lrmodel}}perform the likelihood-ratio model test instead of the
default Wald test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help xtologit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help intpts1
 
{syntab :Maximization}
{synopt :{it:{help xtologit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opth startg:rid(numlist)}}improve starting value of the
random-intercept parameter by performing a grid search{p_end}
{synopt:{opt nodis:play}}suppress display of header and coefficients{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable must be specified; see {helpb xtset}. {p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt fp}, and {opt statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed;
see {help weight}.{p_end}
{p 4 6 2}
{opt startgrid()}, {opt nodisplay}, {opt collinear}, and {opt coeflegend}
do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtologit_postestimation XT:xtologit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Ordinal outcomes >}
    {bf:Logistic regression (RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtologit} fits random-effects ordered logistic models.  The actual values
taken on by the dependent variable are irrelevant, although larger values are
assumed to correspond to "higher" outcomes.  The conditional distribution of
the dependent variable given the random effects is assumed to be multinomial
with success probability determined by the logistic cumulative distribution
function.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtologitQuickstart:Quick start}

        {mansection XT xtologitRemarksandexamples:Remarks and examples}

        {mansection XT xtologitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth offset(varname)}, {opt constraints(constraints)}; see 
{helpb estimation options##offset():[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}),
and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb xt_vce_options:[XT] {it:vce_options}}.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtologitMethodsandformulasxtologitandtherobustVCEestimator:{it:xtologit and the robust VCE estimator}} in
{it:Methods and formulas} of {bf:[XT] xtologit}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}. 

{phang}
{opt or} reports the estimated coefficients transformed to odds ratios, that
is, e^b rather than b.  Standard errors and confidence intervals are similarly
transformed.  This option affects how results are displayed, not how they are
estimated.  {opt or} may be specified at estimation or when replaying
previously estimated results.

{phang}
{opt lrmodel}, {opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

{marker display_options}{...}
INCLUDE help displayopts_list

INCLUDE help intpts4

{dlgtab:Maximization}

{phang}
{marker maximize_options}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)}, 
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, {opt grad:ient}, 
{opt showstep}, {opt hess:ian}, {opt showtol:erance}, {opt tol:erance(#)}, 
{opt ltol:erance(#)}, {opt nrtol:erance(#)}, 
{opt nonrtol:erance}, and {opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {cmd:xtologit} but are not shown in the
dialog box:

{phang}
{opth startgrid(numlist)} performs a grid search to improve the starting value
of the random-intercept parameter. No grid search is performed by default
unless the starting value is found to not be feasible; in this case,
{cmd:xtologit} runs {cmd:startgrid(0.1 1 10)} and chooses the value that works
best. You may already be using a default form of {cmd:startgrid()} without
knowing it. If you see {cmd:xtologit} displaying Grid node 1, Grid node 2,
... following Grid node 0 in the iteration log, that is {cmd:xtologit}
doing a default search because the original starting value was not feasible.

{phang}
{opt nodisplay} is for programmers.  It suppresses the display of the header
and the coefficients.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker technote}{...}
{title:Technical note}

{pstd}
The random-effects logit model is calculated using quadrature, which is an
approximation whose accuracy depends partially on the number of integration
points used.  We can use the {cmd:quadchk} command to see if changing the
number of integration points affects the results.  If the results change, the
quadrature approximation is not accurate given the number of integration
points.  Try increasing the number of integration points using the
{cmd:intpoints()} option and again run {cmd:quadchk}.  Do not attempt to
interpret the results of estimates when the coefficients reported by
{cmd:quadchk} differ substantially.  See {manhelp quadchk XT} for details and
{bf:[XT] xtprobit} for an 
{mansection XT xtprobitRemarksandexamplestechnote:example}.

{pstd}
Because the {cmd:xtologit} likelihood function is calculated by
Gauss-Hermite quadrature, on large problems, the computations can be slow.
Computation time is roughly proportional to the number of points used for the
quadrature.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tvsfpors}{p_end}
{phang2}{cmd:. xtset school}{p_end}

{pstd}Random-effects ordered logit regression{p_end}
{phang2}{cmd:. xtologit thk prethk cc##tv}{p_end}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=O_8DgkBEFMo":Ordered logistic and probit for panel data}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtologit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_cat)}}number of categories{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(n_quad)}}number of quadrature points{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:meglm}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:xtologit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(distrib)}}{cmd:Gaussian}; the distribution of the random
	effect{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
	maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log{p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(cat)}}category values{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
