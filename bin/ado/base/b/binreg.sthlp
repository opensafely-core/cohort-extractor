{smcl}
{* *! version 1.2.2  09apr2019}{...}
{viewerdialog binreg "dialog binreg"}{...}
{vieweralsosee "[R] binreg" "mansection R binreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] binreg postestimation" "help binreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: binreg" "help bayes binreg"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{viewerjumpto "Syntax" "binreg##syntax"}{...}
{viewerjumpto "Menu" "binreg##menu"}{...}
{viewerjumpto "Description" "binreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "binreg##linkspdf"}{...}
{viewerjumpto "Options" "binreg##options"}{...}
{viewerjumpto "Examples" "binreg##examples"}{...}
{viewerjumpto "Stored results" "binreg##results"}{...}
{viewerjumpto "Reference" "binreg##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] binreg} {hline 2}}Generalized linear models: Extensions to the binomial family{p_end}
{p2col:}({mansection R binreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:binreg}
{depvar}
[{indepvars}]
{ifin}
[{it:{help binreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt or}}use logit link and report odds ratios{p_end}
{synopt :{opt rr}}use log link and report risk ratios{p_end}
{synopt :{opt hr}}use log-complement link and report health ratios{p_end}
{synopt :{opt rd}}use identity link and report risk differences{p_end}
{synopt :{cmd:n(}{it:#}|{it:{help varname}}{cmd:)}}use {it:#} or {it:varname} for number of
trials{p_end}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opth mu(varname)}}use {it:varname} as the initial estimate for the
mean of {depvar}{p_end}
{synopt :{opth ini:t(varname)}}synonym for {opt mu(varname)}{p_end}

{syntab:SE/Robust}
{synopt :{cmd:vce(}{it:{help binreg##vcetype:vcetype}}{cmd:)}}{it:vcetype} may
be {opt eim}, {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt oim}, {opt opg},
{opt boot:strap}, {opt jack:knife}, {opt hac} {help binreg##kernel:{it:kernel}}, {opt jackknife1},
or {opt unb:iased}{p_end}
{synopt :{opth t(varname)}}variable name corresponding to time{p_end}
{synopt :{opt vf:actor(#)}}multiply variance matrix by scalar {it:#}{p_end}
{synopt :{opt disp(#)}}quasilikelihood multiplier{p_end}
{p2col :{cmdab:sca:le:(x2}|{cmd:dev}|{it:#}{cmd:)}}set the scale parameter; default is {cmd:scale(1)}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmdab:coef:ficients}}report nonexponentiated coefficients{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help binreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{opt irls}}use iterated, reweighted least-squares optimization; the default{p_end}
{synopt :{opt ml}}use maximum likelihood optimization{p_end}
{synopt :{it:{help binreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
{synopt :{opt fisher(#)}}Fisher scoring steps{p_end}
{synopt :{opt search}}search for good starting values{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators;
see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fp}, {opt jackknife},
{opt mi estimate}, {opt rolling},
and {opt statsby} are allowed; see {help prefix}.
For more details, see {manhelp bayes_binreg BAYES:bayes: binreg}.{p_end}
{p 4 6 2}
{cmd:vce(bootstrap)}, {cmd:vce(jackknife)}, and {cmd:vce(jackknife1)} are not
allowed with the {helpb mi estimate} prefix.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp binreg_postestimation R:binreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Generalized linear models > GLM for the binomial family}


{marker description}{...}
{title:Description}

{pstd}
{opt binreg} fits generalized linear models for the binomial family.  It
estimates odds ratios, risk ratios, health ratios, and risk differences.  The
available links are

{center:Option    Implied link                Parameter}
{center:{hline 47}}
{center:{opt or}               logit     odds ratios = exp(b)}
{center:{opt rr}                 log     risk ratios = exp(b)}
{center:{opt hr}      log complement   health ratios = exp(b)}
{center:{opt rd}            identity     risk differences = b}

{pstd}
Estimates of odds, risk, and health ratios are obtained by
exponentiating the appropriate coefficients.  The {opt or} option produces
the same results as Stata's {cmd:logistic} command, and
{opt or coefficients} yields the same results as the {cmd:logit} command.
When no link is specified, {opt or} is assumed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R binregQuickstart:Quick start}

        {mansection R binregRemarksandexamples:Remarks and examples}

        {mansection R binregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt or} requests the logit link and results in odds ratios if
{opt coefficients} is not specified.

{phang}
{opt rr} requests the log link and results in risk ratios if {opt coefficients}
is not specified.

{phang}
{opt hr} requests the log-complement link and results in health ratios
if {opt coefficients} is not specified.

{phang}
{opt rd} requests the identity link and results in risk differences.

{phang}
{cmd:n(}{it:#}|{it:{help varname}}{cmd:)} specifies either a constant integer
to use as the denominator for the binomial family or a variable that holds
the denominator for each observation.

{phang}
{opth exposure(varname)}, {opt offset(varname)},
{opt constraints(constraints)}; see 
{helpb estimation options:[R] Estimation options}.
{opt constraints(constraints)} is not allowed with {opt irls}.

{phang}
{opth mu(varname)} specifies {it:varname} containing an initial estimate for
the mean of {depvar}. This option can be useful if you encounter convergence
difficulties.  {opt init(varname)} is a synonym.

{marker vcetype}{...}
{dlgtab:SE/Robust}

INCLUDE help vce_all

{pmore}
{cmd:vce(eim)}, the default, uses the expected information matrix for the
variance estimator.

{pmore}
{opt binreg} also allows the following:

{marker kernel}{...}
{phang2}
{cmd:vce(hac} {it:kernel} [{it:#}]{cmd:)} specifies that a
heteroskedasticity- and autocorrelation-consistent (HAC) variance estimate be
used.  HAC refers to the general form for combining weighted matrices
to form the variance estimate.  There are three kernels built into
{opt binreg}. {it:kernel} is a user-written program or one of

{center:{opt nw:est} | {opt ga:llant} | {opt an:derson}}

{pmore2}
If {it:#} not specified, N - 2 is assumed.

{phang2}
{cmd:vce(jackknife1)} specifies that the one-step jackknife estimate of
variance be used.

{phang2}
{cmd:vce(unbiased)} specifies that the unbiased sandwich estimate of variance
be used.

{phang}
{opth t(varname)} specifies the variable name corresponding to time; see 
{manhelp tsset TS}.  {cmd:binreg} does not always need to know {opt t()},
though it does if {cmd:vce(hac} ... {cmd:)} is specified.  Then you
can either specify the time variable with {opt t()}, or you can {cmd:tsset}
your data before calling {cmd:binreg}.  When the time variable is required,
{cmd:binreg} assumes that the observations are spaced equally over time.

{phang}
{opt vfactor(#)} specifies a scalar by which to multiply the resulting
variance matrix.  This option allows users to match output with other
packages, which may apply degrees of freedom or other small-sample corrections
to estimates of variance.

{phang}
{opt disp(#)} multiplies the variance of {depvar} by {it:#} and
divides the deviance by {it:#}.  The resulting distributions are members of
the quasilikelihood family.  This option is not allowed with option {cmd:ml}.

{phang}
{cmd:scale(x2}|{cmd:dev}|{it:#}{cmd:)} overrides the default scale
parameter.  This option is allowed only with Hessian (information matrix)
variance estimates.

{pmore}
By default, {cmd:scale(1)} is assumed for discrete distributions
(binomial, Poisson, and negative binomial), and {cmd:scale(x2)} is assumed
for continuous distributions (Gaussian, gamma, and inverse Gaussian).

{pmore}
{cmd:scale(x2)} specifies that the scale parameter be set to the Pearson
chi-squared (or generalized chi-squared) statistic divided by the residual
degrees of freedom, which is recommended by 
{help binreg##MN1989:McCullagh and Nelder (1989)} as a good
general choice for continuous distributions.

{pmore}
{cmd:scale(dev)} sets the scale parameter to the deviance divided by the
residual degrees of freedom.  This option provides an alternative to
{cmd:scale(x2)} for continuous distributions and overdispersed or
underdispersed discrete distributions.  This option is not allowed with option
{cmd:ml}.

{pmore}
{opt scale(#)} sets the scale parameter to {it:#}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt noconstant}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt coefficients} displays the nonexponentiated coefficients and corresponding
standard errors and confidence intervals.  This option has no effect when the
{opt rd} option is specified, because it always presents the nonexponentiated
coefficients.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{opt irls} requests iterated, reweighted least-squares (IRLS) optimization of
the deviance instead of Newton-Raphson optimization of the
log likelihood.  This option is the default.

{phang}
{opt ml} requests that optimization be carried out by using Stata's
{helpb ml} command.

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
Setting the optimization method to {cmd:ml}, with {cmd:technique()} set to
something other than BHHH, changes the {it:vcetype} to {cmd:vce(oim)}.
Specifying {cmd:technique(bhhh)} changes {it:vcetype} to {cmd:vce(opg)}.

{pmore}
Unless option {cmd:ml} is specified, only {it:maximize_options}
{cmd:iterate()}, {cmd:nolog}, {cmd:trace}, and {cmd:ltolerance()} are allowed.
With IRLS optimization, the convergence criterion is satisfied when the
absolute change in deviance from one iteration to the next is less than or
equal to {cmd:ltolerance()}, where {cmd:ltolerance(1e-6)} is the default.

{phang}
{opt fisher(#)} specifies the number of Newton-Raphson steps that should use
the Fisher scoring Hessian or expected information matrix (EIM) before
switching to the observed information matrix (OIM).  This option is available
only if {opt ml} is specified and is useful only for Newton-Raphson
optimization.

{phang}
{opt search} specifies that the command search for good starting values.  This
option is available only if {opt ml} is specified and is useful only for
Newton-Raphson optimization.

{pstd}
The following options are available with {opt binreg} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.
{opt collinear} is not allowed with {opt irls}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}{p_end}

{pstd}Report odds ratios{p_end}
{phang2}{cmd:. binreg low age lwt i.race smoke ptl ht ui, or}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse binreg}{p_end}

{pstd}Report risk ratios{p_end}
{phang2}{cmd:. binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) rr}{p_end}

{pstd}Obtain nonexponentiated coefficients{p_end}
{phang2}{cmd:. binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) rr coeff}{p_end}

{pstd}Report risk differences{p_end}
{phang2}{cmd:. binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) rd}{p_end}

{pstd}Report health ratios{p_end}
{phang2}{cmd:. binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:binreg, irls} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2 : Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(phi)}}model scale parameter{p_end}
{synopt:{cmd:e(disp)}}dispersion parameter{p_end}
{synopt:{cmd:e(bic)}}model BIC{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(deviance)}}deviance{p_end}
{synopt:{cmd:e(deviance_s)}}scaled deviance{p_end}
{synopt:{cmd:e(deviance_p)}}Pearson deviance{p_end}
{synopt:{cmd:e(deviance_ps)}}scaled Pearson deviance{p_end}
{synopt:{cmd:e(dispers)}}dispersion{p_end}
{synopt:{cmd:e(dispers_s)}}scaled dispersion{p_end}
{synopt:{cmd:e(dispers_p)}}Pearson dispersion{p_end}
{synopt:{cmd:e(dispers_ps)}}scaled Pearson dispersion{p_end}
{synopt:{cmd:e(vf)}}factor set by {cmd:vfactor()}, {cmd:1} if not set{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{p2col 5 20 24 2 : Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:binreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(eform)}}{cmd:eform()} option implied by {cmd:or}, {cmd:rr},
               {cmd:hr}, or {cmd:rd}{p_end}
{synopt:{cmd:e(varfunc)}}program to calculate variance function{p_end}
{synopt:{cmd:e(varfunct)}}variance title{p_end}
{synopt:{cmd:e(varfuncf)}}variance function{p_end}
{synopt:{cmd:e(link)}}program to calculate link function{p_end}
{synopt:{cmd:e(linkt)}}link title{p_end}
{synopt:{cmd:e(linkf)}}link function{p_end}
{synopt:{cmd:e(m)}}number of binomial trials{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title_fl)}}family-link title{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant} or not set{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(opt1)}}optimization title, line 1{p_end}
{synopt:{cmd:e(opt2)}}optimization title, line 2{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2 : Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2 : Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
{cmd:binreg, ml} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2 : Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(phi)}}model scale parameter{p_end}
{synopt:{cmd:e(aic)}}model AIC, if {cmd:ml}{p_end}
{synopt:{cmd:e(bic)}}model BIC{p_end}
{synopt:{cmd:e(ll)}}log likelihood, if {cmd:ml}{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(deviance)}}deviance{p_end}
{synopt:{cmd:e(deviance_s)}}scaled deviance{p_end}
{synopt:{cmd:e(deviance_p)}}Pearson deviance{p_end}
{synopt:{cmd:e(deviance_ps)}}scaled Pearson deviance{p_end}
{synopt:{cmd:e(dispers)}}dispersion{p_end}
{synopt:{cmd:e(dispers_s)}}scaled dispersion{p_end}
{synopt:{cmd:e(dispers_p)}}Pearson dispersion{p_end}
{synopt:{cmd:e(dispers_ps)}}scaled Pearson dispersion{p_end}
{synopt:{cmd:e(vf)}}factor set by {cmd:vfactor()}, {cmd:1} if not set{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2 : Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:binreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(eform)}}{cmd:eform()} option implied by {cmd:or}, {cmd:rr},
               {cmd:hr}, or {cmd:rd}{p_end}
{synopt:{cmd:e(varfunc)}}program to calculate variance function{p_end}
{synopt:{cmd:e(varfunct)}}variance title{p_end}
{synopt:{cmd:e(varfuncf)}}variance function{p_end}
{synopt:{cmd:e(link)}}program to calculate link function{p_end}
{synopt:{cmd:e(linkt)}}link title{p_end}
{synopt:{cmd:e(linkf)}}link function{p_end}
{synopt:{cmd:e(m)}}number of binomial trials{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title_fl)}}family-link title{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant} or not set{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(opt1)}}optimization title, line 1{p_end}
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

{p2col 5 20 24 2 : Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2 : Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models. 2nd ed.}}
London: Chapman & Hall/CRC.
{p_end}
