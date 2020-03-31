{smcl}
{* *! version 1.2.12  12dec2018}{...}
{viewerdialog heckoprobit "dialog heckoprobit"}{...}
{viewerdialog "svy: heckoprobit" "dialog heckoprobit, message(-svy-) name(svy_heckoprobit)"}{...}
{vieweralsosee "[R] heckoprobit" "mansection R heckoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckoprobit postestimation" "help heckoprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: heckoprobit" "help bayes heckoprobit"}{...}
{vieweralsosee "[ERM] eoprobit" "help eoprobit"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] heckpoisson" "help heckpoisson"}{...}
{vieweralsosee "[R] heckprobit" "help heckprobit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{viewerjumpto "Syntax" "heckoprobit##syntax"}{...}
{viewerjumpto "Menu" "heckoprobit##menu"}{...}
{viewerjumpto "Description" "heckoprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "heckoprobit##linkspdf"}{...}
{viewerjumpto "Options" "heckoprobit##options"}{...}
{viewerjumpto "Example" "heckoprobit##example"}{...}
{viewerjumpto "Stored results" "heckoprobit##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[R] heckoprobit} {hline 2}}Ordered probit model with sample selection{p_end}
{p2col:}({mansection R heckoprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:heckoprobit} {depvar} {indepvars} {ifin}
[{help heckoprobit##weight:{it:weight}}]{cmd:,}
{opt sel:ect}{cmd:(}[{it:{help depvar:depvar_s}} {cmd:=}]
                     {it:{help varlist:varlist_s}}
[{cmd:,} {opt nocons:tant} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {opt sel:ect()}}specify selection equation:  dependent and independent variables; whether to have constant term and offset variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {cmd:opg}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt fir:st}}report first-step probit estimates{p_end}
{synopt :{opt nohead:er}}do not display header above parameter table{p_end}
{synopt :{opt nofoot:note}}do not display footnotes below parameter table{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help heckoprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help heckoprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt select()} is required.  The full specification is{p_end}
{p 10 10 2}
{opt sel:ect}{cmd:(}[{it:depvar_s} {cmd:=}] {it:varlist_s}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_o)}]{cmd:)}
{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:depvar_s}, and {it:varlist_s} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:jackknife},
{cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_heckoprobit BAYES:bayes: heckoprobit}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()}, {opt first}, and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s, {opt fweight}s, and {opt iweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp heckoprobit_postestimation R:heckoprobit postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Sample-selection models > Ordered probit model with selection}


{marker description}{...}
{title:Description}

{pstd}
{cmd:heckoprobit} fits maximum-likelihood ordered probit models with sample 
selection.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R heckoprobitQuickstart:Quick start}

        {mansection R heckoprobitRemarksandexamples:Remarks and examples}

        {mansection R heckoprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:select(}[{it:{help depvar:depvar_s}} {cmd:=}] {it:{help varlist:varlist_s}}
[{cmd:,} {opt noconstant} {opth offset:(varname:varname_o)}]{cmd:)}
specifies the variables and options for the
selection equation.  It is an integral part of specifying a selection model
and is required.  The selection equation should contain at least one variable
that is not in the outcome equation.

{pmore}
If {it:depvar_s} is specified, it should be coded as 0 or 1, 0
indicating an observation not selected and 1 indicating a selected observation.
If {it:depvar_s} is not specified, observations for which {it:depvar} is not
missing are assumed selected, and those for which {it:depvar_s} is missing are
assumed not selected.

{pmore}
{cmd:noconstant} suppresses the selection constant term (intercept).

{pmore}
{opt offset(varname_o)} specifies that selection offset {it:varname_o} be
included in the model with the coefficient constrained to be 1.

{phang}
{opth offset(varname)}, {opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-step probit estimates of the selection
equation be displayed before estimation.

{phang}
{opt noheader} suppresses the header above the parameter table.

{phang}
{opt nofootnote} suppresses the footnotes displayed below the parameter table.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt heckoprobit} but are not shown
in the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker example}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse womensat}{p_end}

{pstd}Fit an ordered probit model with sample selection based on employment{p_end}
{phang2}{cmd:. heckoprobit satisfaction educ age, select(work=educ age i.married##c.children)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:heckoprobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt:{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt:{cmd:e(N_cd)}}number of completely determined observations{p_end}
{synopt:{cmd:e(k_cat)}}number of categories{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:heckoprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for regression equation{p_end}
{synopt:{cmd:e(offset2)}}offset for selection equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}type of comparison chi-squared test{p_end}
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
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(cat)}}category values{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
