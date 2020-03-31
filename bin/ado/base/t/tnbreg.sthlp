{smcl}
{* *! version 1.2.18  19apr2019}{...}
{viewerdialog tnbreg "dialog tnbreg"}{...}
{viewerdialog "svy: tnbreg" "dialog tnbreg, message(-svy-) name(svy_tnbreg)"}{...}
{vieweralsosee "[R] tnbreg" "mansection R tnbreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tnbreg postestimation" "help tnbreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: tnbreg" "help bayes tnbreg"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tpoisson" "help tpoisson"}{...}
{vieweralsosee "[XT] xtnbreg" "help xtnbreg"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{viewerjumpto "Syntax" "tnbreg##syntax"}{...}
{viewerjumpto "Menu" "tnbreg##menu"}{...}
{viewerjumpto "Description" "tnbreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "tnbreg##linkspdf"}{...}
{viewerjumpto "Options" "tnbreg##options"}{...}
{viewerjumpto "Remarks" "tnbreg##remarks"}{...}
{viewerjumpto "Examples" "tnbreg##examples"}{...}
{viewerjumpto "Stored results" "tnbreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] tnbreg} {hline 2}}Truncated negative binomial regression
{p_end}
{p2col:}({mansection R tnbreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:tnbreg} {depvar} [{indepvars}] {ifin}
[{it:{help tnbreg##weight:weight}}]
   [{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt:{cmd:ll(}{it:#}|{varname}{cmd:)}}truncation point;
default value is {cmd:ll(0)}, zero truncation{p_end}
{synopt :{opt d:ispersion}{cmd:(}{opt m:ean}{cmd:)}}parameterization of
dispersion; the default{p_end}
{synopt :{opt d:ispersion}{cmd:(}{opt c:onstant}{cmd:)}}constant dispersion
for all observations{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e})
in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient
constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}
{synopt :{opt nolr:test}}suppress likelihood-ratio test{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help tnbreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help tnbreg##tnbreg_maximize:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators;
see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife},
{cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_tnbreg BAYES:bayes: tnbreg}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp tnbreg_postestimation R:tnbreg postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Truncated negative binomial regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tnbreg} estimates the parameters of a truncated negative binomial
model by maximum likelihood.  The dependent variable
{depvar} is regressed on {indepvars}, where {it:depvar} is a
positive count variable whose values are all above the truncation point.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tnbregQuickstart:Quick start}

        {mansection R tnbregRemarksandexamples:Remarks and examples}

        {mansection R tnbregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{cmd:ll(}{it:#}|{varname}{cmd:)} specifies the truncation point, which is
a nonnegative integer.  The default is zero truncation, {cmd:ll(0)}.

{phang}
{cmd:dispersion(mean}{c |}{cmd:constant)} specifies the parameterization of
the model.  {cmd:dispersion(mean)}, the default, yields a model with
dispersion equal to 1 + alpha*exp(xb + offset); that is, the dispersion
is a function of the expected mean: exp(xb + offset).
{cmd:dispersion(constant)} has dispersion equal to 1 + delta; that is, it is a
constant for all observations.

{phang}
{opth exposure:(varname:varname_e)}, {opt offset(varname_o)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt nolrtest} suppresses fitting the Poisson model.  Without this option, a
comparison Poisson model is fit, and the likelihood is used in a
likelihood-ratio test of the null hypothesis that the dispersion parameter is
zero.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated or stored.  {opt irr} may be specified
at estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker tnbreg_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt tnbreg} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:tnbreg} fits the mean-dispersion and the constant-dispersion
parameterizations of truncated negative binomial models.  These
parameterizations extend those implemented in {cmd:nbreg} to the
truncated-data case; see {manhelp nbreg R}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse medpar}{p_end}

{pstd}Truncated negative binomial regression with default truncation point of 0
{p_end}
{phang2}{cmd:. tnbreg los died hmo type2-type3}{p_end}

{pstd}Same as above, but cluster on {cmd:provnum}{p_end}
{phang2}{cmd:. tnbreg los died hmo type2-type3, vce(cluster provnum)}{p_end}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rod93}{p_end}

{pstd}Truncated negative binomial regression with truncation point of 9 and
constant dispersion{p_end}
{phang2}{cmd:. tnbreg deaths i.cohort, ll(9) dispersion(constant)}{p_end}

{pstd}Same as above, but specify exposure variable{p_end}
{phang2}{cmd:. tnbreg deaths i.cohort, ll(9) dispersion(constant) exp(exposure)}
{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tnbreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(alpha)}}value of alpha{p_end}
{synopt:{cmd:e(delta)}}value of delta{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:tnbreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(llopt)}}contents of {cmd:ll()}, or {cmd:0} if not specified{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(dispers)}}{cmd:mean} or {cmd:constant}{p_end}
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
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

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
