{smcl}
{* *! version 1.0.11  04apr2019}{...}
{viewerdialog eoprobit "dialog eoprobit"}{...}
{viewerdialog xteoprobit "dialog xteoprobit"}{...}
{viewerdialog "svy: eoprobit" "dialog eoprobit, message(-svy-) name(svy_eoprobit)"}{...}
{vieweralsosee "[ERM] eoprobit" "mansection ERM eoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eoprobit postestimation" "help eoprobit postestimation"}{...}
{vieweralsosee "[ERM] eoprobit predict" "help eoprobit predict"}{...}
{vieweralsosee "[ERM] predict advanced" "help erm predict advanced"}{...}
{vieweralsosee "[ERM] predict treatment" "help erm predict treatment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] estat teffects" "help erm estat teffects"}{...}
{vieweralsosee "[ERM] Intro 9" "mansection ERM Intro9"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckoprobit" "help heckoprobit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[XT] xtoprobit" "help xtoprobit"}{...}
{viewerjumpto "Syntax" "eoprobit##syntax"}{...}
{viewerjumpto "Menu" "eoprobit##menu"}{...}
{viewerjumpto "Description" "eoprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "eoprobit##linkspdf"}{...}
{viewerjumpto "Options" "eoprobit##options"}{...}
{viewerjumpto "Examples" "eoprobit##examples"}{...}
{viewerjumpto "Stored results" "eoprobit##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[ERM] eoprobit} {hline 2}}Extended ordered probit regression{p_end}
{p2col:}({mansection ERM eoprobit:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic ordered probit regression with endogenous covariates

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:endog:enous(}{help eoprobit##enspec:{it:depvars}_en} {cmd:=}
    {help eoprobit##enspec:{it:varlist}_en}{cmd:)}
[{help eoprobit##synoptions:{it:options}}]


{pstd}
Basic ordered probit regression with endogenous treatment assignment

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:entr:eat(}{help eoprobit##entrspec:{it:depvar}_tr}
   [{cmd:=} {help eoprobit##entrspec:{it:varlist}_tr}]{cmd:)}
[{help eoprobit##synoptions:{it:options}}]


{pstd}
Basic ordered probit regression with exogenous treatment assignment

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:extr:eat(}{help eoprobit##extrspec:{it:tvar}}{cmd:)}
[{help eoprobit##synoptions:{it:options}}]


{pstd}
Basic ordered probit regression with sample selection

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:sel:ect(}{help eoprobit##selspec:{it:depvar}_s} {cmd:=}
    {help eoprobit##selspec:{it:varlist}_s}{cmd:)}
[{help eoprobit##synoptions:{it:options}}]


{pstd}
Basic ordered probit regression with tobit sample selection

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:tobitsel:ect(}{help eoprobit##tselspec:{it:depvar}_s} {cmd:=}
    {help eoprobit##tselspec:{it:varlist}_s}{cmd:)}
[{help eoprobit##synoptions:{it:options}}]


{pstd}
Basic ordered probit regression with random effects

{p 8 15 2}
{cmd:xteoprobit}
{depvar}
[{indepvars}]
[{cmd:,} {help eoprobit##synoptions:{it:options}}]



{pstd}
Ordered probit regression combining endogenous covariates, treatment, and
selection

{p 8 15 2}
{cmd:eoprobit}
{depvar}
[{indepvars}]
{ifin}
[{help eoprobit##weight:{it:weight}}]
[{cmd:,} {help eoprobit##extensions:{it:extensions}}
{help eoprobit##synoptions:{it:options}}]


{pstd}
Ordered probit regression combining random effects, endogenous covariates,
treatment, and selection

{p 8 15 2}
{cmd:xteoprobit}
{depvar}
[{indepvars}]
{ifin}
[{cmd:,} {help eoprobit##extensions:{it:extensions}}
{help eoprobit##synoptions:{it:options}}]


{marker extensions}{...}
{synoptset 25 tabbed}{...}
{synopthdr:extensions}
{synoptline}
{syntab:Model}
{synopt :{opth endog:enous(eoprobit##enspec:enspec)}}model for endogenous covariates; may be repeated{p_end}
{synopt :{opth entr:eat(eoprobit##entrspec:entrspec)}}model for endogenous treatment assignment{p_end}
{synopt :{opth extr:eat(eoprobit##extrspec:extrspec)}}exogenous treatment{p_end}
{synopt :{opth sel:ect(eoprobit##selspec:selspec)}}probit model for selection{p_end}
{synopt :{opth tobitsel:ect(eoprobit##tselspec:tselspec)}}tobit model for selection{p_end}
{synoptline}

{marker synoptions}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{cmdab:off:set(}{varname}_o{cmd:)}}include {it:varname}_o in model with
coefficient constrained to 1{p_end}
{synopt :{opth const:raints(numlist)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
INCLUDE help erm_vce_tab

{syntab :Reporting}
INCLUDE help erm_report_tab
{synopt :{it:{help eoprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
INCLUDE help erm_integration_tab

{syntab :Maximization}
{synopt :{it:{help eoprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker enspec}{...}
{phang}
{it:enspec} is {depvars}_en {cmd:=} {varlist}_en
    [{cmd:,} {help eoprobit##enopts:{it:enopts}}]

{pmore}
where {it:depvars}_en is a list of endogenous covariates.  Each variable in
{it:depvars}_en specifies an endogenous covariate model using the
common {it:varlist}_en and options.

{marker entrspec}{...}
{phang}
{it:entrspec} is {depvar}_tr [{cmd:=} {varlist}_tr]
    [{cmd:,} {help eoprobit##entropts:{it:entropts}}]

{pmore}
where {it:depvar}_tr is a variable indicating treatment assignment.
{it:varlist}_tr is a list of covariates predicting treatment assignment.

{marker extrspec}{...}
{phang}
{it:extrspec} is {it:tvar}
    [{cmd:,} {help eoprobit##extropts:{it:extropts}}]

{pmore}
where {it:tvar} is a variable indicating treatment assignment.

{marker selspec}{...}
{phang}
{it:selspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help eoprobit##selopts:{it:selopts}}]

{pmore}
where {it:depvar}_s is a variable indicating selection status.
{it:depvar}_s must be coded as 0, indicating that the
observation was not selected, or 1, indicating that the observation was
selected.  {it:varlist}_s is a list of covariates predicting selection.

{marker tselspec}{...}
{phang}
{it:tselspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help eoprobit##tselopts:{it:tselopts}}]

{pmore}
where {it:depvar}_s is a continuous variable.
{it:varlist}_s is a list of covariates predicting {it:depvar}_s.
The censoring status of {it:depvar}_s indicates selection, where a censored
{it:depvar}_s indicates that the observation was not selected and a
noncensored {it:depvar}_s indicates that the observation was selected.

{synoptset 26 tabbed}{...}
{marker enopts}{...}
{synopthdr:enopts}
{synoptline}
{syntab :Model}
{synopt :{opt prob:it}}treat endogenous covariate as binary{p_end}
{synopt :{opt oprob:it}}treat endogenous covariate as ordinal{p_end}
{synopt :{opt pocorr:elation}}estimate different correlations for each level of a binary or an ordinal endogenous covariate{p_end}
{synopt :{opt nom:ain}}do not add endogenous covariate to main equation{p_end}
{synopt :{opt nore}}do not include random effects in model for endogenous covariate{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synoptline}
{p 4 6 2}
{opt nore} is available only with {cmd:xteoprobit}.

{marker entropts}{...}
{synopthdr:entropts}
{synoptline}
{syntab :Model}
{synopt :{opt pocorr:elation}}estimate different correlations for each potential outcome{p_end}
{synopt :{opt nom:ain}}do not add treatment indicator to main equation{p_end}
{synopt :{opt nocutsint:eract}}do not interact treatment with cutpoints{p_end}
{synopt :{opt noint:eract}}do not interact treatment with covariates in main equation{p_end}
{synopt :{opt nore}}do not include random effects in model for endogenous treatment{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synoptline}
{p 4 6 2}
{opt nore} is available only with {cmd:xteoprobit}.

{marker extropts}{...}
{synopthdr:extropts}
{synoptline}
{syntab :Model}
{synopt :{opt pocorr:elation}}estimate different correlations for each potential outcome{p_end}
{synopt :{opt nom:ain}}do not add treatment indicator to main equation{p_end}
{synopt :{opt nocutsint:eract}}do not interact treatment with cutpoints{p_end}
{synopt :{opt noint:eract}}do not interact treatment with covariates in main equation{p_end}
{synoptline}

INCLUDE help erm_selopts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteoprobit}.

INCLUDE help erm_tselopts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteoprobit}.
{p2colreset}{...}

{p 4 6 2}
{it:indepvars},
{it:varlist}_en,
{it:varlist}_tr,
and
{it:varlist_s}
may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar},
{it:indepvars},
{it:depvars}_en,
{it:varlist}_en,
{it:depvar}_tr, 
{it:varlist}_tr,
{it:tvar},
{it:depvar_s},
and
{it:varlist_s}
may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, and {opt statsby}
are allowed with {cmd:eoprobit} and {cmd:xteoprobit}.
{cmd:rolling} and {opt svy} are allowed with {cmd:eoprobit}.
See {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed with {cmd:eoprobit}; see {help weight}.{p_end}
{p 4 6 2}
{cmd:reintpoints()} and {cmd:reintmethod()} are available only with
{cmd:xteoprobit}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp eoprobit_postestimation ERM:eoprobit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{pstd}
{bf:eoprobit}

{phang2}
{bf:Statistics > Endogenous covariates > Models adding selection and treatment >}
{bf:Ordered probit regression}

{pstd}
{bf:xteoprobit}

{phang2}
{bf:Statistics > Longitudinal/panel data > Endogenous covariates > Models adding selection and treatment >}
{bf:Ordered probit regression (RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:eoprobit} fits an ordered probit regression  model that accommodates any
combination of endogenous covariates, nonrandom treatment assignment, and
endogenous sample selection.  Continuous, binary, and ordinal endogenous
covariates are allowed.  Treatment assignment may be endogenous or exogenous.
A probit or tobit model may be used to account for endogenous sample
selection.

{pstd}
{cmd:xteoprobit} fits a random-effects ordered probit regression  model that
accommodates endogenous covariates, treatment, and sample selection in the
same way as {cmd:eoprobit} and also accounts for correlation of observations
within panels or within groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eoprobitQuickstart:Quick start}

        {mansection ERM eoprobitRemarksandexamples:Remarks and examples}

        {mansection ERM eoprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt endogenous(enspec)}, 
{opt entreat(entrspec)}, 
{opt extreat(extrspec)}, 
{opt select(selspec)}, 
{opt tobitselect(tselspec)}, {cmd:re};
see {manhelp erm_options ERM:ERM options}. 

{phang}
{opt offset(varname_o)}, 
{opth constraints(numlist)}; 
see {manhelp estimation_options R:Estimation options}. 

{dlgtab:SE/Robust}

INCLUDE help erm_vce_optdes

{dlgtab:Reporting}

INCLUDE help erm_reporting_optdes

{dlgtab:Integration}

INCLUDE help erm_int_optdes

{marker maximize_options}{...}
{dlgtab:Maximization}

INCLUDE help erm_max_optdes

{pmore}
The default technique for {cmd:eoprobit} is {cmd:technique(nr)}.  The default
technique for {cmd:xteoprobit} is {cmd:technique(bhhh 10 nr 2)}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt eoprobit} and {opt xteoprobit}
but are not shown in the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse womenhlth}

{pstd}
Ordered probit regression with endogenous treatment{p_end}
{phang2}
{cmd:. eoprobit health i.exercise grade, entreat(insured = grade i.workschool)}

{pstd}
With robust standard errors{p_end}
{phang2}
{cmd:. eoprobit health i.exercise grade, entreat(insured = grade i.workschool)}
{cmd:vce(robust)}

{pstd}
As above, and account for endogenous sample selection{p_end}
{phang2}
{cmd:. eoprobit health i.exercise c.grade,}
{cmd:entreat(insured = grade i.workschool)}
{cmd:select(select = i.insured i.regcheck) vce(robust)}

    {hline}
{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse womenhlthre}{p_end}
{phang2}
{cmd:. xtset personid year}

{pstd}
Random-effects ordered probit regression{p_end}
{phang2}
{cmd:. xteoprobit health exercise grade}

{pstd}
Random-effects ordered probit with endogenous treatment{p_end}
{phang2}
{cmd:. xteoprobit health exercise grade, entreat(insured = grade i.workschool)}

{pstd}
Random-effects ordered probit with endogenous sample selection{p_end}
{phang2}
{cmd:. xteoprobit health exercise grade, select(select = grade i.regcheck)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:eoprobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt :{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(n_quad)}}number of integration points for multivariate
normal{p_end}
{synopt :{cmd:e(n_quad3)}}number of integration points for trivariate
normal{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:eoprobit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt :{cmd:e(tsel_ll)}}left-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(tsel_ul)}}right-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar},
where {it:#} is determined by equation order in output{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsdefault)}}default {cmd:predict()} specification for {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar},
ordinal{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xteoprobit} stores the following in {cmd:e()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_g)}}number of groups{p_end}
{synopt :{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt :{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(n_quad)}}number of integration points for multivariate
normal{p_end}
{synopt :{cmd:e(n_quad3)}}number of integration points for trivariate
normal{p_end}
{synopt :{cmd:e(n_requad)}}number of integration points for random
effects{p_end}
{synopt :{cmd:e(g_min)}}smallest group size{p_end}
{synopt :{cmd:e(g_avg)}}average group size{p_end}
{synopt :{cmd:e(g_max)}}largest group size{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:xteoprobit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt :{cmd:e(tsel_ll)}}left-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(tsel_ul)}}right-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar},
where {it:#} is determined by equation order in output{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(reintmethod)}}integration method for random effects{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsdefault)}}default {cmd:predict()} specification for {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar},
ordinal{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
