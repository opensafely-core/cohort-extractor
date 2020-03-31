{smcl}
{* *! version 1.3.12  22mar2019}{...}
{viewerdialog ivprobit "dialog ivprobit"}{...}
{viewerdialog "svy: ivprobit" "dialog ivprobit, message(-svy-) name(svy_ivprobit)"}{...}
{vieweralsosee "[R] ivprobit" "mansection R ivprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivprobit postestimation" "help ivprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eprobit" "help eprobit"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation " "help svy_estimation"}{...}
{vieweralsosee "[XT] xtprobit" "help xtprobit"}{...}
{viewerjumpto "Syntax" "ivprobit##syntax"}{...}
{viewerjumpto "Menu" "ivprobit##menu"}{...}
{viewerjumpto "Description" "ivprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivprobit##linkspdf"}{...}
{viewerjumpto "Options for ML estimator" "ivprobit##options_ml"}{...}
{viewerjumpto "Options for two-step estimator" "ivprobit##options_twostep"}{...}
{viewerjumpto "Examples" "ivprobit##examples"}{...}
{viewerjumpto "Stored results" "ivprobit##results"}{...}
{viewerjumpto "Reference" "ivprobit##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] ivprobit} {hline 2}}Probit model with continuous endogenous
covariates{p_end}
{p2col:}({mansection R ivprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Maximum likelihood estimator

{p 8 17 2}
{cmd:ivprobit} {depvar} [{it:{help varlist:varlist1}}] 
{cmd:(}{it:{help varlist:varlist2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin}
       [{it:{help ivprobit##weight:weight}}]
       [{cmd:,} {it:{help ivprobit##mle_options:mle_options}}] 


{phang}
Two-step estimator

{p 8 17 2}
{cmd:ivprobit} {depvar} [{it:{help varlist:varlist1}}]
{cmd:(}{it:{help varlist:varlist2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin}
       [{it:{help ivprobit##weight:weight}}]
{cmd:,} {opt two:step} [{it:{help ivprobit##tse_options:tse_options}}]


{phang}
{it:varlist1} is the list of exogenous variables.{p_end}

{phang}
{it:varlist2} is the list of endogenous variables.{p_end}

{phang}
{it:varlist_iv} is the list of exogenous variables used with {it:varlist1}
   as instruments for {it:varlist2}.


{synoptset 28 tabbed}{...}
{marker mle_options}{...}
{synopthdr :mle_options}
{synoptline}
{syntab :Model}
{synopt :{opt m:le}}use conditional maximum-likelihood estimator; the default{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage regression{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help ivprobit##ml_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help ivprobit##maximize_options:maximize_options}}}control the maximization process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker tse_options}{...}
{synopthdr :tse_options}
{synoptline}
{syntab :Model}
{p2coldent :* {opt two:step}}use Newey's two-step estimator; the default
is {opt mle}{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt twostep}, 
         {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage regression{p_end}
{synopt :{it:{help ivprobit##ts_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt twostep} is required.{p_end}

{p 4 6 2}{it:varlist1} and {it:varlist_iv} may
contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:varlist1}, {it:varlist2}, and {it:varlist_iv} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
{cmd:fp} is allowed with the maximum likelihood estimator.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()},
{opt first},
{opt twostep},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed with
the maximum likelihood estimator.  {cmd:fweight}s are allowed with Newey's
two-step estimator.  See {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp ivprobit_postestimation R:ivprobit postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Endogenous covariates > Probit model with endogenous covariates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ivprobit} fits models for binary dependent variables where one or more
of the covariates are endogenous and errors are normally distributed.  By
default, {cmd:ivprobit} uses maximum likelihood estimation, but Newey's
({help ivprobit##N1987:1987}) minimum chi-squared (two-step) estimator can be
requested.  Both estimators assume that the endogenous covariates are
continuous and so are not appropriate for use with discrete endogenous
covariates.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivprobitQuickstart:Quick start}

        {mansection R ivprobitRemarksandexamples:Remarks and examples}

        {mansection R ivprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_ml}{...}
{title:Options for ML estimator}

{dlgtab:Model}

{phang}
{opt mle} requests that the conditional maximum-likelihood estimator be
used.  This is the default.

{phang}
{opt asis} requests that all specified variables and observations be retained
in the maximization process.  This option is typically not used and may
introduce numerical instability.  Normally, {cmd:ivprobit} drops any endogenous
or exogenous variables that perfectly predict success or failure in the
dependent variable.  The associated observations are also dropped.  For more
information, see 
{mansection R probitRemarksandexamplesModelidentification:{it:Model identification}} in
{bf:[R] probit}.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} requests that the parameters for the reduced-form equations
showing the relationships between the endogenous variables and instruments be
displayed.  For the two-step estimator, {opt first} shows the first-stage
regressions.  For the maximum likelihood estimator, these parameters are
estimated jointly with the parameters of the probit equation.  The default is
not to show these parameter estimates.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker ml_display_options}{...}
INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.

{pstd}
The following option is available with {opt ivprobit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_twostep}{...}
{title:Options for two-step estimator}

{dlgtab:Model}

{phang}
{opt twostep} is required and requests that Newey's
({help ivprobit##N1987:1987})
efficient two-step estimator be used to obtain the coefficient estimates.

{phang}
{opt asis} requests that all specified variables and observations be retained
in the maximization process.  This option is typically not used and may
introduce numerical instability.  Normally, {cmd:ivprobit} drops any endogenous
or exogenous variables that perfectly predict success or failure in the
dependent variable.  The associated observations are also dropped.  For more
information, see
{mansection R probitRemarksandexamplesModelidentification:{it:Model identification}} in
{bf:[R] probit}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:twostep})
and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} requests that the parameters for the reduced-form equations
showing the relationships between the endogenous variables and instruments be
displayed.  For the two-step estimator, {opt first} shows the first-stage
regressions.  For the maximum likelihood estimator, these parameters are
estimated jointly with the parameters of the probit equation.  The default is
not to show these parameter estimates.

{marker ts_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt ivprobit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse laborsup}{p_end}

{pstd}Maximum likelihood estimator{p_end}
{phang2}{cmd:. ivprobit fem_work fem_educ kids (other_inc = male_educ)}{p_end}

{pstd}Two-step estimator{p_end}
{phang2}{cmd:. ivprobit fem_work fem_educ kids (other_inc = male_educ), twostep}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ivprobit, mle} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cds)}}number of completely determined successes{p_end}
{synopt:{cmd:e(N_cdf)}}number of completely determined failures{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(endog_ct)}}number of endogenous covariates{p_end}
{synopt:{cmd:e(p)}}model Wald p-value{p_end}
{synopt:{cmd:e(p_exog)}}exogeneity test Wald p-value{p_end}
{synopt:{cmd:e(chi2)}}model Wald chi-squared{p_end}
{synopt:{cmd:e(chi2_exog)}}Wald chi-squared test of exogeneity{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ivprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(asis)}}{cmd:asis}, if specified{p_end}
{synopt:{cmd:e(method)}}{cmd:ml}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsprop)}}signals to the {cmd:margins} command{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(rules)}}information about perfect predictors{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
{cmd:ivprobit, twostep} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cds)}}number of completely determined successes{p_end}
{synopt:{cmd:e(N_cdf)}}number of completely determined failures{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_exog)}}degrees of freedom for chi-squared test of exogeneity{p_end}
{synopt:{cmd:e(p)}}model Wald p-value{p_end}
{synopt:{cmd:e(p_exog)}}exogeneity test Wald p-value{p_end}
{synopt:{cmd:e(chi2)}}model Wald chi-squared{p_end}
{synopt:{cmd:e(chi2_exog)}}Wald chi-squared test of exogeneity{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ivprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(asis)}}{cmd:asis}, if specified{p_end}
{synopt:{cmd:e(method)}}{cmd:twostep}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsprop)}}signals to the {cmd:margins} command{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(rules)}}information about perfect predictors{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker N1987}{...}
{phang}
Newey, W. K. 1987. Efficient estimation of limited dependent variable models
with endogenous explanatory variables. {it:Journal of Econometrics} 36:
231-250.
{p_end}
