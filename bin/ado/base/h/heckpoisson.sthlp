{smcl}
{* *! version 1.0.5  12dec2018}{...}
{viewerdialog heckpoisson "dialog heckpoisson"}{...}
{viewerdialog "svy: heckpoisson" "dialog heckpoisson, message(-svy-) name(svy_heckpoisson)"}{...}
{vieweralsosee "[R] heckpoisson" "mansection R heckpoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckpoisson postestimation" "help heckpoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etpoisson" "help etpoisson"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] heckoprobit" "help heckoprobit"}{...}
{vieweralsosee "[R] heckprobit" "help heckprobit"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "heckpoisson##syntax"}{...}
{viewerjumpto "Menu" "heckpoisson##menu"}{...}
{viewerjumpto "Description" "heckpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "heckpoisson##linkspdf"}{...}
{viewerjumpto "Options" "heckpoisson##options"}{...}
{viewerjumpto "Examples" "heckpoisson##examples"}{...}
{viewerjumpto "Stored results" "heckpoisson##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[R] heckpoisson} {hline 2}}Poisson regression with sample selection{p_end}
{p2col:}({mansection R heckpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:heckpoisson}
{depvar} 
{indepvars}
{ifin}
[{it:{help heckpoisson##weight:weight}}]{cmd:,}
{cmdab:sel:ect(}[{it:{help depvar:depvar_s}} {cmd:=}]
               {it:{help indepvars:indepvars_s}}
[{cmd:,} {opt nocons:tant} {opth off:set(varname:varname_os)}]{cmd:)}
[{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {opt sel:ect()}}specify selection equation: dependent and
independent variables; whether to have constant term and offset
variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model
with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation_options##constraints():constraints}}{cmd:)}}apply specified
linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap}, or
  {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help heckpoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opt intp:oints(#)}}set the number of integration (quadrature) points; default is {cmd:intpoints(25)}{p_end}

{syntab:Maximization}
{synopt :{it:{help heckpoisson##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt select()} is required. The full specification is{break}
{cmdab:sel:ect(}[{it:depvar_s} {cmd:=}] {it:indepvars_s}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_os)}]{cmd:)}.{p_end}
{p 4 6 2}{it:indepvars} and {it:indepvars_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:indepvars} and {it:indepvars_s} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bootstrap}, {opt by}, {opt jackknife}, {opt rolling},
{opt statsby}, and {opt svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{opt vce()} and weights are not allowed with the {helpb svy}
prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp heckpoisson_postestimation R:heckpoisson postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Sample-selection models > Poisson model with sample selection}


{marker description}{...}
{title:Description}

{pstd}
{cmd:heckpoisson} fits a Poisson regression model with endogenous sample
selection.  This is sometimes called nonignorability of selection,
missing not at random, or selection bias.  Unlike the standard Poisson model,
there is no assumption of equidispersion.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R heckpoissonQuickstart:Quick start}

        {mansection R heckpoissonRemarksandexamples:Remarks and examples}

        {mansection R heckpoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:select(}[{it:{help depvar:depvar_s}} {cmd:=}] {it:{help indepvars:indepvars_s}}
[{cmd:,} {opt noconstant} {opth offset:(varname:varname_os)}]{cmd:)}
specifies the variables and options for the selection equation.  It is an
integral part of specifying a sample-selection model and is required.

{pmore}
If {it:depvar_s} is specified, it should be coded as 0 or 1, with 0
indicating an observation not selected and 1 indicating a selected
observation.  If {it:depvar_s} is not specified, then observations for which
{it:depvar} is not missing are assumed selected and those for which
{it:depvar} is missing are assumed not selected.

{pmore}
{opt noconstant} suppresses the selection constant term (intercept).

{pmore}
{opt offset(varname_os)} specifies that selection offset
{it:varname_os} be included in the model with the coefficient constrained to
be 1.

{phang}
{opt noconstant}, {opt exposure(varname_e)}, {opt offset(varname_o)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
     {helpb estimation options:[R] Estimation options}.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios, that is, e^{beta_i} rather than beta_i.  Standard errors and
confidence intervals are similarly transformed.  This option affects how
results are displayed, not how they are estimated or stored.  {opt irr} may
be specified at estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

{marker display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{opt intpoints(#)} specifies the number of integration points to use
for quadrature.  The default is {cmd:intpoints(25)}, which means that 25
quadrature points are used. The maximum number of allowed integration points is
128.

{pmore}
The more integration points, the more accurate the approximation to the log
likelihood.  However, computation time increases with the number
of quadrature points and is roughly proportional to the number of points used.

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
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following options are available with {opt heckpoisson} but are not shown
in the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse patent}{p_end}

{pstd}Fit a poisson model with endogenous sample selection{p_end}
{phang2}{cmd:. heckpoisson npatents expenditure i.tech, select(applied = expenditure size i.tech)}
{p_end}

{pstd}Replay results, but display legend of coefficients rather than the
statistics for the coefficients{p_end}
{phang2}{cmd:. heckpoisson, coeflegend}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:heckpoisson} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt:{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison, rho=0 test{p_end}
{synopt:{cmd:e(n_quad)}}number of quadrature points{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:heckpoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for regression equation{p_end}
{synopt:{cmd:e(offset2)}}offset for selection equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald}; type of comparison chi-squared test{p_end}
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
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}} model-based variance{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
	
