{smcl}
{* *! version 1.1.9  25mar2019}{...}
{viewerdialog "mgarch vcc" "dialog mgarch"}{...}
{vieweralsosee "[TS] mgarch vcc" "mansection TS mgarchvcc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] mgarch vcc postestimation" "help mgarch vcc postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch" "help arch"}{...}
{vieweralsosee "[TS] mgarch" "help mgarch"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "mgarch vcc##syntax"}{...}
{viewerjumpto "Menu" "mgarch vcc##menu"}{...}
{viewerjumpto "Description" "mgarch vcc##description"}{...}
{viewerjumpto "Links to PDF documentation" "mgarch_vcc##linkspdf"}{...}
{viewerjumpto "Options" "mgarch vcc##options"}{...}
{viewerjumpto "Eqoptions" "mgarch vcc##eqoptions"}{...}
{viewerjumpto "Examples" "mgarch vcc##examples"}{...}
{viewerjumpto "Stored results" "mgarch vcc##results"}{...}
{viewerjumpto "Reference" "mgarch vcc##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TS] mgarch vcc} {hline 2}}Varying conditional correlation
multivariate GARCH models{p_end}
{p2col:}({mansection TS mgarchvcc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mgarch vcc}
{it:eq} [{it:eq} ... {it:eq}] 
{ifin} 
[{cmd:,} {it:options}]

{pstd}
where each {it:eq} has the form

{phang2}
          {cmd:(}{depvars} {cmd:=} [{indepvars}]
          [{cmd:,} {it:{help mgarch_vcc##eqoptions_tbl:eqoptions}}]{cmd:)}

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth ar:ch(numlist)}}ARCH terms for all equations{p_end}
{synopt :{opth ga:rch(numlist)}}GARCH terms for all equations{p_end}
{synopt :{opth het(varlist)}}include {it:varlist} in the specification
of the conditional variance for all equations{p_end}
{synopt:{opt dist:ribution(dist [#])}}use {it:dist} distribution for errors
[may be {cmdab:gau:ssian} (synonym {cmdab:nor:mal}) or {cmd:t};
default is {cmd:gaussian}]{p_end}
{synopt :{opth const:raints(numlist)}}apply linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}
	or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help mgarch_vcc##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help mgarch_vcc##maximize:maximize_options}}}control the
	maximization process; seldom used{p_end}
{synopt :{opt from(matname)}}initial values for the coefficients;
         seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker eqoptions_tbl}{...}
{synoptset 25 tabbed}{...}
{synopthdr:eqoptions}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term in the mean equation{p_end}
{synopt :{opth ar:ch(numlist)}}ARCH terms{p_end}
{synopt :{opth ga:rch(numlist)}}GARCH terms{p_end}
{synopt :{opth het(varlist)}}include {it:varlist} in the specification
of the conditional variance{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {opt tsset} your data before using {opt mgarch vcc}; see
         {manhelp tsset TS}.{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist} may contain factor variables; 
	see {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvars}, {it:indepvars}, and {it:varlist} may contain time-series
	operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by}, {opt fp}, {opt rolling}, and {opt statsby} are allowed; see
         {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp mgarch_vcc_postestimation TS:mgarch vcc postestimation}
	for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Multivariate GARCH}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mgarch vcc} estimates the parameters of varying conditional
correlation (VCC) multivariate generalized autoregressive
conditionally heteroskedastic (MGARCH) models in which the
conditional variances are modeled as univariate generalized autoregressive
conditionally heteroskedastic (GARCH) models and the conditional
covariances are modeled as nonlinear functions of the conditional variances.
The conditional correlation parameters that weight the nonlinear
combinations of the conditional variance follow the GARCH-like
process specified in {help mgarch vcc##TT2002:Tse and Tsui (2002)}.

{pstd}
The VCC MGARCH model is about as flexible as the closely related
dynamic conditional correlation MGARCH model (see
{helpb mgarch dcc:[TS] mgarch dcc}), more flexible than the conditional
correlation MGARCH model (see {helpb mgarch ccc:[TS] mgarch ccc}), and more
parsimonious than the diagonal vech model
(see {helpb mgarch dvech:[TS] mgarch dvech}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mgarchvccQuickstart:Quick start}

        {mansection TS mgarchvccRemarksandexamples:Remarks and examples}

        {mansection TS mgarchvccMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth arch(numlist)} specifies the ARCH terms for all equations in the model.
By default, no ARCH terms are specified.

{phang}
{opth garch(numlist)} specifies the GARCH terms for all equations in the model.
By default, no GARCH terms are specified.

{phang}
{opth het(varlist)} specifies that {it:varlist} be included in the
specification of the conditional variance for all equations.  This varlist
enters the variance specification collectively as multiplicative
heteroskedasticity.

{phang}
{cmd:distribution(}{it:dist} [{it:#}]{cmd:)} specifies the assumed distribution
for the errors.  {it:dist} may be {cmd:gaussian}, {cmd:normal},
or {cmd:t}.

{phang2}
{opt gaussian} and {opt normal} are synonyms; each causes {cmd:mgarch vcc} to
assume that the errors come from a multivariate normal distribution. {it:#}
may not be specified with either of them.

{phang2}
{cmd:t} causes {cmd:mgarch vcc} to assume that the errors follow a multivariate
Student t distribution, and the degree-of-freedom parameter is estimated
along with the other parameters of the model.  If {cmd:distribution(t}
{it:#}{cmd:)} is specified, then {cmd:mgarch vcc} uses a multivariate Student t
distribution with {it:#} degrees of freedom.  {it:#} must be greater than 2.

{phang}
{opth constraints(numlist)} specifies linear constraints to apply to the
parameter estimates.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the estimator for the variance-covariance matrix
of the estimator.

{phang2}
{cmd:vce(oim)}, the default, specifies to use the observed information matrix
(OIM) estimator.

{phang2}
{cmd:vce(robust)} specifies to use the Huber/White/sandwich estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize}{...}
{dlgtab:Maximization}

{marker maximize_options}{...}
{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)}, {opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(matname)};
see {helpb maximize:[R] Maximize} for all options except {opt from()}, and see
below for information on {opt from()}.  These options are seldom used.

{phang}
{opt from(matname)} specifies initial values for the coefficients.
{cmd:from(b0)} causes {opt mgarch vcc} to begin the optimization algorithm with
the values in {opt b0}.  {opt b0} must be a row vector, and the number of
columns must equal the number of parameters in the model.

{pstd}
The following option is available with {cmd:mgarch vcc} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see 
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker eqoptions}{...}
{title:Eqoptions}

{phang}
{opt noconstant} suppresses the constant term in the mean equation.

{phang}
{opth arch(numlist)} specifies the ARCH terms in the equation.  By default,
no ARCH terms are specified.  This option may not be specified with model-level
{bf:arch()}.

{phang}
{opth garch(numlist)} specifies the GARCH terms in the equation.  By default,
no GARCH terms are specified.  This option may not be specified with model-level
{bf:garch()}.

{phang}
{opth het(varlist)} specifies that {it:varlist} be included in the
specification of the conditional variance.  This varlist enters the variance
specification collectively as multiplicative heteroskedasticity.  This option
may not be specified with model-level {bf:het()}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stocks}{p_end}

{pstd}Fit a VAR(1) model of stock returns on {cmd:toyota}, {cmd:nissan}
and {cmd:honda}, allowing for ARCH(1) and GARCH(1) errors{p_end}
{phang2}{cmd:. mgarch vcc (toyota nissan honda = L.toyota L.nissan L.honda,}
        {cmd:noconstant), arch(1) garch(1)}

{pstd}Drop the insignificant terms from the above model and reestimate
the model{p_end}
{phang2}{cmd:. mgarch vcc (toyota nissan = , noconstant)}
        {cmd:(honda = L.nissan, noconstant), arch(1) garch(1)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. constraint 1 _b[ARCH_toyota:L.arch] = _b[ARCH_nissan:L.arch]}{p_end}
{phang2}{cmd:. constraint 2 _b[ARCH_toyota:L.garch] = _b[ARCH_nissan:L.garch]}{p_end}

{pstd}Fit a bivariate GARCH model of stock returns on {cmd:toyota} and
{cmd:nissan}, constraining the two variables' ARCH coefficients to be equal, as
well as their GARCH coefficients to be equal{p_end}

{phang2}{cmd:. mgarch vcc (toyota nissan = , noconstant), arch(1) garch(1)}
    {cmd:constraints(1 2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse acmeh}{p_end}

{pstd}Fit a bivariate GARCH model in which the variance equations for
{cmd:acme} and {cmd:anvil} follow different processes{p_end}
{phang2}{cmd:. mgarch vcc (acme = afrelated, noconstant arch(1) garch(1))}
	{cmd:(anvil = afinputs, arch(1/2) het(L.apex))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mgarch vcc} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_extra)}}number of extra estimates added to {cmd:_b}{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(estdf)}}{cmd:1} if distribution parameter was estimated, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(usr)}}user-provided distribution parameter{p_end}
{synopt:{cmd:e(tmin)}}minimum time in sample{p_end}
{synopt:{cmd:e(tmax)}}maximum time in sample{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mgarch}{p_end}
{synopt:{cmd:e(model)}}{cmd:vcc}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(dv_eqs)}}dependent variables with mean equations{p_end}
{synopt:{cmd:e(indeps)}}independent variables in each equation{p_end}
{synopt:{cmd:e(tvar)}}time variable{p_end}
{synopt:{cmd:e(hetvars)}}variables included in the conditional variance equations{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(dist)}}distribution for error term: {cmd:gaussian} or {cmd:t}{p_end}
{synopt:{cmd:e(arch)}}specified ARCH terms{p_end}
{synopt:{cmd:e(garch)}}specified GARCH terms{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{opt b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(hessian)}}Hessian matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(pinfo)}}parameter information, used by {cmd:predict}{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{marker reference}{...}
{title:Reference}

{marker TT2002}{...}
{phang}
Tse, Y. K., and A. K. C. Tsui. 2002.
A multivariate generalized autoregressive conditional heteroskedasticity model
with time-varying correlations.
{it:Journal of Business & Economic Statistics} 20: 351-362.
{p_end}
