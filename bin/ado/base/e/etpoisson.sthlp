{smcl}
{* *! version 1.0.20  12dec2018}{...}
{viewerdialog etpoisson "dialog etpoisson"}{...}
{viewerdialog "svy: etpoisson" "dialog etpoisson, message(-svy-) name(svy_etpoisson)"}{...}
{vieweralsosee "[TE] etpoisson" "mansection TE etpoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etpoisson postestimation" "help etpoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckpoisson" "help heckpoisson"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etregress" "help etregress"}{...}
{vieweralsosee "[R] ivpoisson" "help ivpoisson"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "etpoisson##syntax"}{...}
{viewerjumpto "Menu" "etpoisson##menu"}{...}
{viewerjumpto "Description" "etpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "etpoisson##linkspdf"}{...}
{viewerjumpto "Options" "etpoisson##options"}{...}
{viewerjumpto "Examples" "etpoisson##examples"}{...}
{viewerjumpto "Stored results" "etpoisson##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TE] etpoisson} {hline 2}}Poisson regression with endogenous
treatment effects{p_end}
{p2col:}({mansection TE etpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:etpoisson} {depvar} [{indepvars}] {ifin}
[{it:{help etpoisson##weight:weight}}]{cmd:,}
{opt tr:eat}{cmd:(}{it:{help depvar:depvar_t}} {cmd:=}
{it:{help varlist:indepvars_t}}
[{cmd:,} {opt nocons:tant}
{opth off:set(varname:varname_o)}]{cmd:)} [{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {opt tr:eat()}}equation for treatment effects{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help etpoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Integration}
{synopt :{opt intp:oints(#)}}use {it:#} Gauss-Hermite quadrature points; default is {cmd:intpoints(24)}{p_end}

{syntab :Maximization}
{synopt :{it:{help etpoisson##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt treat()} is required. The full specification is{p_end}
{p 10 10 2}
{cmdab:tr:eat(}{it:depvar_t} {cmd:=} {it:indepvars_t}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_o)}]{cmd:)}.
{p_end}

{p 4 6 2}{it:indepvars} and {it:indepvars_t} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:depvar_t}, {it:indepvars}, and {it:indepvars_t} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bootstrap}, {opt by}, {opt jackknife}, {opt rolling}, {opt statsby}, and {opt svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt aweight}s, {opt iweight}s, and {opt pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp etpoisson_postestimation TE:etpoisson postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
  {bf:Maximum likelihood estimator > Count outcomes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:etpoisson} estimates the parameters of a Poisson regression model in
which one of the regressors is an endogenous binary treatment.  Both the
average treatment effect and the average treatment effect on the treated can
be estimated with {cmd:etpoisson}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE etpoissonQuickstart:Quick start}

        {mansection TE etpoissonRemarksandexamples:Remarks and examples}

        {mansection TE etpoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:treat(}{depvar:_t} {cmd:=} {indepvars:_t}[{cmd:,} {opt noconstant}
{cmd:offset(}{it:{help varname:varname_o}}{cmd:)}]{cmd:)}
 specifies the variables and options for the treatment equation.  It is an
 integral part of specifying a treatment-effects model and is required.

{pmore}
The indicator of treatment, {it:{help depvar:depvar_t}}, should be coded as 0
or 1.

{phang}
{opt noconstant},
{opth "exposure(varname:varname_e)"},
{opth "offset(varname:varname_o)"}, 
{opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated or stored.  {opt irr} may be specified at
estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{opt intpoints(#)} specifies the number of integration points to use for
integration by quadrature.  The default is {cmd:intpoints(24)};
the maximum is {cmd:intpoints(128)}. Increasing this value improves the
accuracy but also increases computation time.  Computation time is roughly
proportional to its value.

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
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt etpoisson} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse trip1}{p_end}

{pstd}Fit a Poisson regression with endogenous treatment{p_end}
{phang2}{cmd:. etpoisson trips cbd ptn worker weekend,}
{cmd:  treat(owncar = cbd ptn worker realinc) vce(robust)}{p_end}

{phang}Estimate average treatment effect{p_end}
{phang2}{cmd:. margins r.owncar, vce(unconditional)}{p_end}

{phang}Estimate average treatment effect on the treated{p_end}
{phang2}{cmd:. margins, predict(cte) vce(unconditional) subpop(owncar)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:etpoisson} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
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

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:etpoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for regression equation{p_end}
{synopt:{cmd:e(offset2)}}offset for treatment equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared
        test{p_end}
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
