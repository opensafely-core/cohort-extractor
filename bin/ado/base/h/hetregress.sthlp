{smcl}
{* *! version 1.0.13  12dec2018}{...}
{viewerdialog hetregress "dialog hetregress"}{...}
{viewerdialog "svy: hetregress" "dialog hetregress, message(-svy-) name(svy_hetregress)"}{...}
{vieweralsosee "[R] hetregress" "mansection R hetregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hetregress postestimation" "help hetregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: hetregress" "help bayes hetregress"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "hetregress##syntax"}{...}
{viewerjumpto "Menu" "hetregress##menu"}{...}
{viewerjumpto "Description" "hetregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "hetregress##linkspdf"}{...}
{viewerjumpto "Options for maximum likelihood estimation" "hetregress##options_ml"}{...}
{viewerjumpto "Options for two-step GLS estimation" "hetregress##options_twostep"}{...}
{viewerjumpto "Examples" "hetregress##examples"}{...}
{viewerjumpto "Stored results" "hetregress##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] hetregress} {hline 2}}Heteroskedastic linear regression{p_end}
{p2col:}({mansection R hetregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Maximum likelihood estimation

{p 8 16 2}
{cmd:hetregress} {depvar} [{indepvars}] {ifin}
[{it:{help hetregress##weight:weight}}]
[{cmd:,} 
{it:{help hetregress##hetregress_ml_options:ml_options}}]


{phang}Two-step GLS estimation

{p 8 16 2}
{cmd:hetregress} {depvar} [{indepvars}] {ifin}{cmd:,}
{cmdab:two:step} {cmd:het(}{varlist}{cmd:)} 
[{it:{help hetregress##hetregress_ts_options:ts_options}}]


{synoptset 28 tabbed}{...}
{marker hetregress_ml_options}{...}
{synopthdr :ml_options}
{synoptline}
{syntab :Model}
{synopt :{opt ml:e}}use maximum likelihood estimator; the default{p_end}
{synopt :{cmd:het(}{varlist}{cmd:)}}independent variables to model the variance{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {cmd:opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lrmodel}}perform the LR model test instead of the
default Wald model test{p_end}
{synopt:{opt waldhet}}perform Wald test on variance instead of LR test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help hetregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help hetregress##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}

{marker hetregress_ts_options}{...}
{synopthdr :ts_options}
{synoptline}
{syntab :Model}
{p2coldent :* {cmdab:two:step}}use two-step GLS estimator; default is
maximum likelihood{p_end}
{p2coldent :* {cmd:het(}{varlist}{cmd:)}}independent variables to model the variance{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab :SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help hetregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:twostep} and {opt het()} are required.{p_end}


{p2colreset}{...}
INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife},
{cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_hetregress BAYES:bayes: hetregress}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{opt aweight}s are not allowed with the {helpb jackknife} prefix.{p_end}
{p 4 6 2}
{opt vce()}, {opt lrmodel}, {opt twostep}, and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt aweight}s, {opt fweight}s, {opt iweight}s, and {opt pweight}s
are allowed with maximum likelihood estimation; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp hetregress_postestimation R:hetregress postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Heteroskedastic linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:hetregress} fits a multiplicative heteroskedastic linear regression by
modeling the variance as an exponential function of the specified variables
using either maximum likelihood (ML; the default) or Harvey's two-step
generalized least-squares (GLS) method.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R hetregressQuickstart:Quick start}

        {mansection R hetregressRemarksandexamples:Remarks and examples}

        {mansection R hetregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_ml}{...}
{title:Options for maximum likelihood estimation}

{dlgtab:Model}

{phang}
{opt mle} requests that the maximum likelihood estimator be used.  This is the
default.

{phang}
{cmd:het(}{varlist}{cmd:)} specifies the independent variables in the variance
function.  When the {opt het()} option is not specified, homoskedasticity is
assumed and the {opt waldhet} option is not allowed.
 
{phang}
{opt noconstant}, {opt constraints(constraints)}; see 
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt lrmodel}; see 
{helpb estimation options:[R] Estimation options}.

{phang}
{opt waldhet} specified that the Wald test of whether {cmd:lnsigma2} = 0 be
performed instead of the LR test.

{phang}
{opt nocnsreport}; see {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab :Maximization}

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
The following options are available with {opt hetregress} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker options_twostep}{...}
{title:Options for two-step GLS estimation}

{dlgtab:Model}

{phang}
{opt twostep} specifies that the model be fit using Harvey's two-step GLS
estimator.  This option requires that the independent variables be specified
in the {opt het()} option to model the variance.

{phang}
{cmd:het(}{varlist}{cmd:)} specifies the independent variables in the variance
function.
 
{phang}
{opt noconstant}; see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory
({cmd:conventional}) and that use bootstrap or jackknife methods
({cmd:bootstrap}, {cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(conventional)}, the default, uses the two-step variance estimator
derived by Heckman.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt hetregress} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit multiplicative heteroskedastic regression model and use {cmd:length}
to model the variance{p_end}
{phang2}{cmd:. hetregress price length i.foreign, het(length)}{p_end}

{pstd}Perform LR test instead of Wald test for the mean function{p_end}
{phang2}{cmd:. hetregress price length i.foreign, het(length) lrmodel}{p_end}

{pstd}Fit heteroskedastic regression model using Harvey's two-step GLS
method{p_end}
{phang2}{cmd:. hetregress price length i.foreign, het(length) twostep}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:hetregress} (ML) stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood, full model{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared for mean model test{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for heteroskedasticity test{p_end}
{synopt:{cmd:e(p_c)}}p-value for heteroskedasticity test{p_end}
{synopt:{cmd:e(df_m_c)}}degrees of freedom for heteroskedasticity test{p_end}
{synopt:{cmd:e(p)}}p-value for the mean model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:hetregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of heteroskedastic chi-squared test corresponding to {cmd:e(chi2_c)}{p_end}
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
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
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


{pstd}
{cmd:hetregress} (two-step GLS) stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}chi-squared for mean model test{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for heteroskedasticity test{p_end}
{synopt:{cmd:e(p_c)}}p-value for heteroskedasticity test{p_end}
{synopt:{cmd:e(df_m_c)}}degrees of freedom for heteroskedasticity test{p_end}
{synopt:{cmd:e(p)}}p-value for the mean model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:hetregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald}; type of heteroskedastic chi-squared test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(method)}}{cmd:twostep}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
