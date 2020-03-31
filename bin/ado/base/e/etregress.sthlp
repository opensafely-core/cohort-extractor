{smcl}
{* *! version 1.1.19  12dec2018}{...}
{viewerdialog "etregress cfunction" "dialog etregress, message(-cfunc-)"}{...}
{viewerdialog "etregress ml" "dialog etregress, message(-ml-)"}{...}
{viewerdialog "etregress two-step"  "dialog etregress, message(-2step-)"}{...}
{viewerdialog "svy: etregress ml" "dialog etregress, message(-svy-) name(svy_etregress_ml)"}{...}
{vieweralsosee "[TE] etregress" "mansection TE etregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etregress postestimation" "help etregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{vieweralsosee "[TE] etpoisson" "help etpoisson"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "etregress##syntax"}{...}
{viewerjumpto "Menu" "etregress##menu"}{...}
{viewerjumpto "Description" "etregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "etregress##linkspdf"}{...}
{viewerjumpto "Options for maximum likelihood estimates" "etregress##options_ml"}{...}
{viewerjumpto "Options for two-step consistent estimates" "etregress##options_twostep"}{...}
{viewerjumpto "Options for control-function estimates" "etregress##options_cfunction"}{...}
{viewerjumpto "Examples" "etregress##examples"}{...}
{viewerjumpto "Stored results" "etregress##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TE] etregress} {hline 2}}Linear regression with endogenous
treatment effects{p_end}
{p2col:}({mansection TE etregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 17 2}
{cmd:etregress}
{depvar}
[{indepvars}]{cmd:,}
{cmdab:tr:eat:(}{depvar:_t} {cmd:=} {indepvars:_t}{cmd:)}
[{opt two:step}{c |}{opt cfunc:tion}]


{phang}
Full syntax for maximum likelihood estimates only

{p 8 17 2}
{cmd:etregress}
{depvar}
[{indepvars}]
{ifin}
[{it:{help etregress##weight:weight}}]{cmd:,}
{cmdab:tr:eat:(}{depvar:_t} {cmd:=} {indepvars:_t} [{cmd:,}
{opt nocons:tant}]{cmd:)}
[{it:{help etregress##etregress_ml_options:etregress_ml_options}}]


{phang}
Full syntax for two-step consistent estimates only

{p 8 17 2}
{cmd:etregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmdab:tr:eat:(}{depvar:_t} {cmd:=} {indepvars:_t} [{cmd:,}
{opt nocons:tant}]{cmd:)}
{opt two:step}
[{it:{help etregress##etregress_ts_options:etregress_ts_options}}]


{phang}
Full syntax for control-function estimates only

{p 8 17 2}
{cmd:etregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmdab:tr:eat:(}{depvar:_t} {cmd:=} {indepvars:_t} [{cmd:,}
{opt nocons:tant}]{cmd:)}
{opt cfunc:tion}
[{it:{help etregress##etregress_cf_options:etregress_cf_options}}]


{marker etregress_ml_options}{...}
{synoptset 26 tabbed}{...}
{synopthdr:etregress_ml_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt tr:eat()}}equation for treatment effects{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt po:utcomes}}use potential-outcome model with separate treatment
and control group variance and correlation parameters{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
    {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
    or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is
	{cmd:level(95)}{p_end}
{synopt :{opt fir:st}}report first-step probit estimates{p_end}
{synopt :{opth ha:zard(newvar)}}create {it:newvar} containing hazard from
	treatment equation{p_end}
{synopt :{opt lrmodel}}perform the likelihood-ratio model test instead of the
default Wald test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help etregress##ml_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help etregress##ml_maximize_options:maximize_options}}}control
	maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt treat}{cmd:(}{it:depvar_t} {cmd:=} {it:indepvars_t}[{cmd:,}
{opt nocons:tant}]{cmd:)} is required.{p_end}


{marker etregress_ts_options}{...}
{synopthdr:etregress_ts_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt tr:eat()}}equation for treatment effects{p_end}
{p2coldent :* {opt two:step}}produce two-step consistent estimate{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}

{syntab:SE}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
	{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is
	{cmd:level(95)}{p_end}
{synopt:{opt fir:st}}report first-step probit estimates{p_end}
{synopt:{opth ha:zard(newvar)}}create {it:newvar} containing hazard from
	treatment equation{p_end}
{synopt :{it:{help etregress##ts_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt treat}{cmd:(}{it:depvar_t} {cmd:=} {it:indepvars_t}[{cmd:,}
{opt nocons:tant}]{cmd:)} and {opt twostep} are required.{p_end}


{marker etregress_cf_options}{...}
{synoptset 26 tabbed}{...}
{synopthdr:etregress_cf_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt tr:eat()}}equation for treatment effects{p_end}
{p2coldent :* {opt cfunc:tion}}produce control-function estimate{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt po:utcomes}}use potential-outcome model with separate treatment
	and control group variance and correlation parameters{p_end}

{syntab:SE}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust},
	{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is
	{cmd:level(95)}{p_end}
{synopt:{opt fir:st}}report first-step probit estimates{p_end}
{synopt:{opth ha:zard(newvar)}}create {it:newvar} containing hazard from
	treatment equation{p_end}
{synopt :{it:{help etregress##cf_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help etregress##cf_maximize_options:maximize_options}}}control
	maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt treat}{cmd:(}{it:depvar_t} {cmd:=} {it:indepvars_t}[{cmd:,}
{opt nocons:tant}]{cmd:)} and {opt cfunction} are required.{p_end}


{p 4 6 2}{it:indepvars} and {it:indepvars_t} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:indepvars}, {it:depvar_t}, and {it:indepvars_t} may contain
time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, {opt rolling},
{opt statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt twostep},
{opt cfunction},
{opt vce()},
{opt first},
{opt hazard()},
{opt lrmodel},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt pweight}s, {opt aweight}s, {opt fweight}s, and {opt iweight}s are
allowed with both maximum likelihood and control-function estimation; see
{help weight}.  No weights are allowed if {opt twostep} is specified.
{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp etregress_postestimation TE:etregress postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
  {bf:Maximum likelihood estimator > Continuous outcomes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:etregress} estimates an average treatment effect and the
other parameters of a linear regression model augmented with an endogenous
binary-treatment variable.  Estimation is by full maximum likelihood,
a two-step consistent estimator, or a control-function estimator.

{pstd}
In addition to the average treatment effect, {cmd:etregress} can be used to
estimate the average treatment effect on the treated when the
outcome may not be conditionally independent of the treatment.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE etregressQuickstart:Quick start}

        {mansection TE etregressRemarksandexamples:Remarks and examples}

        {mansection TE etregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_ml}{...}
{title:Options for maximum likelihood estimates}

{dlgtab:Model}

{phang}
{cmd:treat(}{depvar:_t} {cmd:=} {indepvars:_t}[{cmd:,} {opt noconstant}]{cmd:)}
   specifies the variables and options for the
   treatment equation.  It is an integral part of specifying a treatment-effects
   model and is required.

{phang}
{opt noconstant}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt poutcomes} specifies that a potential-outcome model with separate
variance and correlation parameters for each of the treatment and control
groups be used.

{phang}
{opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-step probit estimates of the treatment
   equation be displayed before estimation.

{phang}
{opth hazard(newvar)} will create a new variable containing the
   hazard from the treatment equation.  The hazard is computed from the
   estimated parameters of the treatment equation.

{phang}
{opt lrmodel}, {opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

{marker ml_display_options}{...}
INCLUDE help displayopts_list

{marker ml_maximize_options}{...}
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
{opt nonrtol:erance(#)}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt etregress} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker options_twostep}{...}
{title:Options for two-step consistent estimates}

{dlgtab:Model}

{phang}
{cmd:treat(}{depvar:_t} {cmd:=} {indepvars:_t}[{cmd:,} {opt noconstant}]{cmd:)}
   specifies the variables and options for the
   treatment equation.  It is an integral part of specifying a treatment-effects
   model and is required.

{phang}
{opt twostep} specifies that two-step consistent estimates
   of the parameters, standard errors, and covariance matrix be
   produced, instead of the default maximum likelihood estimates.

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:conventional})
and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.
{p_end}

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for the two-step estimator of the treatment-effects model.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-step probit estimates of the treatment
   equation be displayed before estimation.

{phang}
{opth hazard(newvar)} will create a new variable containing the
   hazard from the treatment equation.  The hazard is computed from the
   estimated parameters of the treatment equation.

{marker ts_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt etregress} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_cfunction}{...}
{title:Options for control-function estimates}

{dlgtab:Model}

{phang}
{cmd:treat(}{depvar:_t} {cmd:=} {indepvars:_t}[{cmd:,} {opt noconstant}]{cmd:)}
   specifies the variables and options for the
   treatment equation.  It is an integral part of specifying a treatment-effects
   model and is required.

{phang}
{opt cfunction} specifies that control-function estimates of the
parameters, standard errors, and covariance matrix be produced instead of the
default maximum likelihood estimates.  {opt cfunction} is required.

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt poutcomes} specifies that a potential-outcome model with separate
variance and correlation parameters for each of the treatment and control
groups be used.

{dlgtab:SE}

INCLUDE help vce_rbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-step probit estimates of the treatment
   equation be displayed before estimation.

{phang}
{opth hazard(newvar)} will create a new variable containing the
   hazard from the treatment equation.  The hazard is computed from the
   estimated parameters of the treatment equation.

{marker cf_display_options}{...}
INCLUDE help displayopts_list

{marker cf_maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt iter:ate(#)},
[{cmd:no}]{opt log},
and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
{it:init_specs} is one of

{pmore2}
{it:matname} [{cmd:,} {cmd:skip} {cmd:copy}]

{pmore2}
{it:#} [{cmd:} {it:#} ...]{cmd:} {cmd:copy}

{pstd}
The following option is available with {opt etregress} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse union3}{p_end}

{pstd}Obtain full ML estimates{p_end}
{phang2}{cmd:. etregress wage age grade smsa black tenure,}
           {cmd:treat(union = south black tenure)}

{pstd}Obtain two-step consistent estimates{p_end}
{phang2}{cmd:. etregress wage age grade smsa black tenure,}
           {cmd:treat(union = south black tenure) twostep}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse drugexp}{p_end}

{pstd}Obtain control-function estimates for potential-outcome model{p_end}
{phang2}{cmd:. etregress lndrug chron age lninc, }
{cmd:treat(ins=age married lninc work) poutcomes cfunction}

    {hline}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:etregress} (maximum likelihood) stores the following in {cmd:e()}:

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
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model ({cmd:lrmodel}
	only){p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(lambda)}}estimate of lambda in constrained model{p_end}
{synopt:{cmd:e(selambda)}}standard error of lambda in constrained model{p_end}
{synopt:{cmd:e(sigma)}}estimate of sigma in constrained model{p_end}
{synopt:{cmd:e(lambda0)}}estimate of lambda0 in potential-outcome model{p_end}
{synopt:{cmd:e(selambda0)}}standard error of lambda0 in potential-outcome model{p_end}
{synopt:{cmd:e(sigma0)}}estimate of sigma0 in potential-outcome model{p_end}
{synopt:{cmd:e(lambda1)}}estimate of lambda1 in potential-outcome model{p_end}
{synopt:{cmd:e(selambda1)}}standard error of lambda1 in potential-outcome model{p_end}
{synopt:{cmd:e(sigma1)}}estimate of sigma1 in potential-outcome model{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rho)}}estimate of rho in constrained model{p_end}
{synopt:{cmd:e(rho0)}}estimate of rho0 in potential-outcome model{p_end}
{synopt:{cmd:e(rho1)}}estimate of rho1 in potential-outcome model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:etregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(hazard)}}variable containing hazard{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(method)}}{cmd:ml}{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
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


{pstd}
{cmd:etregress} (two-step) stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(lambda)}}lambda{p_end}
{synopt:{cmd:e(selambda)}}standard error of lambda{p_end}
{synopt:{cmd:e(sigma)}}estimate of sigma{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:etregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(hazard)}}variable containing hazard{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(method)}}{cmd:twostep}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
{cmd:etregress} (control-function) stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(lambda)}}estimate of lambda in constrained model{p_end}
{synopt:{cmd:e(selambda)}}standard error of lambda in constrained model{p_end}
{synopt:{cmd:e(sigma)}}estimate of sigma in constrained model{p_end}
{synopt:{cmd:e(lambda0)}}estimate of lambda0 in potential-outcome model{p_end}
{synopt:{cmd:e(selambda0)}}standard error of lambda0 in potential-outcome model{p_end}
{synopt:{cmd:e(sigma0)}}estimate of sigma0 in potential-outcome model{p_end}
{synopt:{cmd:e(lambda1)}}estimate of lambda1 in potential-outcome model{p_end}
{synopt:{cmd:e(selambda1)}}standard error of lambda1 in potential-outcome model{p_end}
{synopt:{cmd:e(sigma1)}}estimate of sigma1 in potential-outcome model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rho)}}estimate of rho in constrained model{p_end}
{synopt:{cmd:e(rho0)}}estimate of rho0 in potential-outcome model{p_end}
{synopt:{cmd:e(rho1)}}estimate of rho1 in potential-outcome model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:etregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(hazard)}}variable containing hazard{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(method)}}{cmd:cfunction}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
