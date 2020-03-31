{smcl}
{* *! version 1.3.1  12dec2018}{...}
{viewerdialog biprobit "dialog biprobit_notsu"}{...}
{viewerdialog "seemingly unrelated biprobit" "dialog biprobit_su"}{...}
{viewerdialog "svy: biprobit" "dialog biprobit_notsu, message(-svy-) name(svy_biprobit_notsu)"}{...}
{viewerdialog "svy: seemingly unrelated biprobit" "dialog biprobit_su, message(-svy-) name(svy_biprobit_su)"}{...}
{vieweralsosee "[R] biprobit" "mansection R biprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] biprobit postestimation" "help biprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: biprobit" "help bayes biprobit"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "biprobit##syntax"}{...}
{viewerjumpto "Menu" "biprobit##menu"}{...}
{viewerjumpto "Description" "biprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "biprobit##linkspdf"}{...}
{viewerjumpto "Options" "biprobit##options"}{...}
{viewerjumpto "Examples" "biprobit##examples"}{...}
{viewerjumpto "Stored results" "biprobit##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] biprobit} {hline 2}}Bivariate probit regression
{p_end}
{p2col:}({mansection R biprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Bivariate probit regression

{p 8 17 2}
{cmd:biprobit}
{it:{help depvar:depvar1}} {it:{help depvar:depvar2}}
[{indepvars}]
{ifin}
[{it:{help biprobit##weight:weight}}]
[{cmd:,}
{it:{help biprobit##options_table:options}}]


{phang}Seemingly unrelated bivariate probit regression

{p 8 17 2}
{cmd:biprobit}
{it:equation1} {it:equation2}
{ifin}
[{it:{help biprobit##weight:weight}}]
[{cmd:,} {it:{help biprobit##su_options:su_options}}]


{pstd}where {it:equation1} and {it:equation2} are specified as

{p 8 12 2}{cmd:(} [{it:eqname}{cmd:: }] {depvar} [{cmd:=}] [{indepvars}]
		[{cmd:,} {opt nocons:tant}
                {opth off:set(varname)} ] {cmd:)}

{synoptset 28 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt par:tial}}fit partial observability model{p_end}
{synopt :{opth offset1(varname)}}offset variable for first equation{p_end}
{synopt :{opth offset2(varname)}}offset variable for second equation{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lrmodel}}perform likelihood-ratio model test instead of the default
Wald test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help biprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help biprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker su_options}{...}
{synopthdr :su_options}
{synoptline}
{syntab:Model}
{synopt :{opt par:tial}}fit partial observability model{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lrmodel}}perform the likelihood-ratio model test instead of the
default Wald test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help biprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help biprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

INCLUDE help fvvarlist
{p 4 6 2}{it:depvar1}, {it:depvar2}, {it:indepvars}, and {it:depvar} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bayes}, {opt bootstrap}, {opt by}, {opt fp}, {opt jackknife},
{opt rolling}, {opt statsby}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_biprobit BAYES:bayes: biprobit}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()}, {cmd:lrmodel}, and weights are not allowed with the {helpb svy}
prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s, {opt fweight}s, and {opt iweight}s are allowed; see 
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp biprobit_postestimation R:biprobit postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

    {title:biprobit}

{phang2}
{bf:Statistics > Binary outcomes > Bivariate probit regression}

    {title:seemingly unrelated biprobit}

{phang2}
{bf:Statistics > Binary outcomes >}
     {bf:Seemingly unrelated bivariate probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:biprobit} fits maximum-likelihood two-equation probit
models -- either a bivariate probit or a seemingly unrelated probit
(limited to two equations).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R biprobitQuickstart:Quick start}

        {mansection R biprobitRemarksandexamples:Remarks and examples}

        {mansection R biprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt partial} specifies that the partial observability model be fit.  This
particular model commonly has poor convergence properties, so we recommend
that you use the {helpb maximize##difficult:difficult} option if you want to
fit the Poirier partial observability model; see {helpb maximize:[R] Maximize}.

{pmore}
This model computes the product of the two dependent variables so
that you do not have to replace each with the product.

{phang}
{opth offset1(varname)}, {opt offset2(varname)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt lrmodel},
{opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep}, {opt hess:ian},
{opt showtol:erance}, {opt tol:erance(#)}, {opt ltol:erance(#)}, 
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt biprobit} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse school}{p_end}

{pstd}Bivariate probit regression{p_end}
{phang2}{cmd:. biprobit private vote logptax loginc years}{p_end}

{pstd}Seemingly unrelated bivariate probit regression{p_end}
{phang2}{cmd:. biprobit (private = logptax loginc years)}
            {cmd:(vote = logptax years)}{p_end}

{pstd}Seemingly unrelated bivariate probit regression with robust standard
errors{p_end}
{phang2}{cmd:. biprobit (private = logptax loginc years)}
            {cmd:(vote = logptax years), vce(robust)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:biprobit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model ({cmd:lrmodel}
	only){p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:biprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for first equation{p_end}
{synopt:{cmd:e(offset2)}}offset for second equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared test
	corresponding to {cmd:e(chi2_c)}{p_end}
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

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
