{smcl}
{* *! version 1.3.9  27feb2019}{...}
{viewerdialog nbreg "dialog nbreg"}{...}
{viewerdialog gnbreg "dialog gnbreg"}{...}
{viewerdialog "svy: nbreg" "dialog nbreg, message(-svy-) name(svy_nbreg)"}{...}
{viewerdialog "svy: gnbreg" "dialog gnbreg, message(-svy-) name(svy_gnbreg)"}{...}
{vieweralsosee "[R] nbreg" "mansection R nbreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nbreg postestimation" "help nbreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: gnbreg" "help bayes gnbreg"}{...}
{vieweralsosee "[BAYES] bayes: nbreg" "help bayes nbreg"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[FMM] fmm: nbreg" "help fmm nbreg"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[ME] menbreg" "help menbreg"}{...}
{vieweralsosee "[R] npregress kernel" "help npregress kernel"}{...}
{vieweralsosee "[R] npregress series" "help npregress series"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tnbreg" "help tnbreg"}{...}
{vieweralsosee "[XT] xtnbreg" "help xtnbreg"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{viewerjumpto "Syntax" "nbreg##syntax"}{...}
{viewerjumpto "Menu" "nbreg##menu"}{...}
{viewerjumpto "Description" "nbreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "nbreg##linkspdf"}{...}
{viewerjumpto "Options for nbreg" "nbreg##options_nbreg"}{...}
{viewerjumpto "Options for gnbreg" "nbreg##options_gnbreg"}{...}
{viewerjumpto "Remarks" "nbreg##remarks"}{...}
{viewerjumpto "Examples" "nbreg##examples"}{...}
{viewerjumpto "Stored results" "nbreg##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] nbreg} {hline 2}}Negative binomial regression{p_end}
{p2col:}({mansection R nbreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Negative binomial regression model

{p 8 14 2}
{cmd:nbreg} {depvar} [{indepvars}] {ifin}
[{it:{help nbreg##weight:weight}}]
[{cmd:,} {it:{help nbreg##nbreg_options:nbreg_options}}]


{phang}
Generalized negative binomial model

{p 8 15 2}
{cmd:gnbreg} {depvar} [{indepvars}] {ifin} 
[{it:{help nbreg##weight:weight}}]
[{cmd:,} {it:{help nbreg##gnbreg_options:gnbreg_options}}]


{synoptset 28 tabbed}{...}
{marker nbreg_options}{...}
{synopthdr :nbreg_options}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:d:ispersion(}{opt m:ean}{cmd:)}}parameterization of dispersion; the default{p_end}
{synopt :{cmdab:d:ispersion(}{opt c:onstant}{cmd:)}}constant dispersion for all observations{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nolr:test}}suppress likelihood-ratio test{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help nbreg##nbreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help nbreg##nbreg_maximize:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker gnbreg_options}{...}
{synopthdr :gnbreg_options}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth lna:lpha(varlist)}}dispersion model variables{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg},
  {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help nbreg##gnbreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
        
{syntab :Maximization}
{synopt :{it:{help nbreg##gnbreg_maximize:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:varname_e}, and {it:varname_o} may
contain time-series operators ({cmd:nbreg} only); see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bayes}, {opt bootstrap}, {opt by} ({cmd:nbreg} only),
{opt fmm} ({cmd:nbreg} only), {opt fp} ({cmd:nbreg} only), {opt jackknife},
{opt mfp} ({cmd:nbreg} only), {opt mi estimate},
{opt nestreg} ({cmd:nbreg} only), {opt rolling},
{opt statsby}, {opt stepwise}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_gnbreg BAYES:bayes: gnbreg},
{manhelp bayes_nbreg BAYES:bayes: nbreg}, and
{manhelp fmm_nbreg FMM:fmm: nbreg}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2} {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp nbreg_postestimation R:nbreg postestimation} for features
available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

    {title:nbreg} 

{phang2}
{bf:Statistics > Count outcomes > Negative binomial regression}

    {title:gnbreg}

{phang2}
{bf:Statistics > Count outcomes > Generalized negative binomial regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nbreg} fits a negative binomial regression model for a nonnegative count
dependent variable.  In this model, the count variable is believed to be
generated by a Poisson-like process, except that the variation is allowed to
be greater than that of a true Poisson.  This extra variation is referred to
as overdispersion.

{pstd}
{cmd:gnbreg} fits a generalization of the negative binomial mean-dispersion
model; the shape parameter alpha may also be parameterized.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nbregQuickstart:Quick start}

        {mansection R nbregRemarksandexamples:Remarks and examples}

        {mansection R nbregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_nbreg}{...}
{title:Options for nbreg}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{cmd:dispersion(mean}{c |}{cmd:constant)} specifies the parameterization of
the model.  {cmd:dispersion(mean)}, the default, yields a model with
dispersion equal to 1 + alpha*exp(xb + offset); that is, the dispersion
is a function of the expected mean: exp(xb + offset).
{cmd:dispersion(constant)} has dispersion equal to 1 + delta; that is, it is a
constant for all observations.

{phang}
{opth "exposure(varname:varname_e)"}, {opt offset(varname_o)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

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

{marker nbreg_display_options}{...}
INCLUDE help displayopts_list

{marker nbreg_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep}, {opt hess:ian},
{opt showtol:erance}, {opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt nbreg} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker options_gnbreg}{...}
{title:Options for gnbreg}

{dlgtab: Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opth lnalpha(varlist)} allows you to specify a linear equation for ln(alpha).
Specifying {cmd:lnalpha(male old)} means that ln(alpha)=a_0 + a_1{cmd:male} +
a_2{cmd:old}, where a_0, a_1, and a_2 are parameters to be estimated along
with the other model coefficients.  If this option is not specified,
{cmd:gnbreg} and {cmd:nbreg} will produce the same results because the shape
parameter will be parameterized as a constant.

{phang}
{opth "exposure(varname:varname_e)"}, {opt offset(varname_o)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated or stored.  {opt irr} may be specified
at estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker gnbreg_display_options}{...}
INCLUDE help displayopts_list

{marker gnbreg_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep}, {opt hess:ian},
{opt showtol:erance}, {opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt gnbreg} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:nbreg} will fit two different parameterizations of the negative
binomial model.  The default, given by the {cmd:dispersion(mean)} option,
has dispersion for the ith observation equal to 1 + alpha*exp(x_jb +
offset_j); that is, the dispersion is a function of the expected mean of the
counts for the jth observation.  The alternative parameterization, given by the
{cmd:dispersion(constant)} option, has dispersion equal to 1 + delta; that is,
it is a constant for all observations.

{pstd}
For the default model, alpha = 0 (or ln(alpha) = -infinity) corresponds to
dispersion = 1, and, thus, it is simply a Poisson model.  Likewise, for the
alternative parameterization, delta = 0 (or ln(delta) = -infinity) corresponds
to dispersion = 1, and it is simply a Poisson model.

{pstd}
Users may want to fit both parameterizations and choose the one with the
larger (least negative) log likelihood.  Both parameterizations will yield
similar results, and the parameterizations will usually not significantly
differ from each other.  Hence, the choice of parameterization is usually not
important.

{pstd}
See {manhelp xtpoisson XT} and {manhelp xtnbreg XT} for closely related panel
estimators.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rod93}{p_end}
{phang2}{cmd:. generate logexp=ln(exposure)}{p_end}

{pstd}Fit a negative binomial regression model{p_end}
{phang2}{cmd:. nbreg deaths i.cohort, exposure(exp)}{p_end}

{pstd}Same as above command{p_end}
{phang2}{cmd:. nbreg deaths i.cohort, offset(logexp)}{p_end}

{pstd}Same as above command, but change dispersion from {cmd:mean} to
{cmd:constant}{p_end}
{phang2}{cmd:. nbreg deaths i.cohort, offset(logexp) dispersion(constant)}{p_end}

{pstd}Fit a generalized negative binomial model{p_end}
{phang2}{cmd:. gnbreg deaths age_mos, lnalpha(i.cohort) offset(logexp)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nbreg} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(cmd)}}{cmd:nbreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
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
{cmd:gnbreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gnbreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
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
