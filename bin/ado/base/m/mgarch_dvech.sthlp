{smcl}
{* *! version 2.1.9  12dec2018}{...}
{viewerdialog "mgarch dvech" "dialog mgarch"}{...}
{vieweralsosee "[TS] mgarch dvech" "mansection TS mgarchdvech"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] mgarch dvech postestimation" "help mgarch dvech postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch" "help arch"}{...}
{vieweralsosee "[TS] mgarch" "help mgarch"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "mgarch dvech##syntax"}{...}
{viewerjumpto "Menu" "mgarch dvech##menu"}{...}
{viewerjumpto "Description" "mgarch dvech##description"}{...}
{viewerjumpto "Links to PDF documentation" "mgarch_dvech##linkspdf"}{...}
{viewerjumpto "Options" "mgarch dvech##options"}{...}
{viewerjumpto "Examples" "mgarch dvech##examples"}{...}
{viewerjumpto "Stored results" "mgarch dvech##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[TS] mgarch dvech} {hline 2}}Diagonal vech multivariate GARCH models
{p_end}
{p2col:}({mansection TS mgarchdvech:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mgarch dvech}
{it:eq} [{it:eq} ... {it:eq}] 
{ifin} 
[{cmd:,} {it:options}]

{pstd}
where each {it:eq} has the form

{phang2}
          {cmd:(}{depvars} {cmd:=} [{indepvars}]
          [{cmd:,} {opt nocons:tant}]{cmd:)}

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth ar:ch(numlist)}}ARCH terms{p_end}
{synopt :{opth ga:rch(numlist)}}GARCH terms{p_end}
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
{synopt :{it:{help mgarch_dvech##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help mgarch_dvech##maximize:maximize_options}}}control the
	maximization process; seldom used{p_end}
{synopt :{opt from(matname)}}initial values for the coefficients;
         seldom used{p_end}
{synopt :{opth svtech:nique(maximize##algorithm_spec:algorithm_spec)}}starting-value
           maximization algorithm{p_end}
{synopt :{opt sviter:ate(#)}}number of starting-value iterations; default is
          {cmd:sviterate(25)}{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {opt tsset} your data before using {opt mgarch dvech}; see
         {manhelp tsset TS}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvars} and {it:indepvars} may contain time-series operators;
         see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by}, {opt fp}, {opt rolling}, and {opt statsby} are allowed; see
         {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp mgarch_dvech_postestimation TS:mgarch dvech postestimation}
	for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Multivariate GARCH}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mgarch dvech} estimates the parameters of diagonal vech (DVECH)
multivariate generalized autoregressive conditionally heteroskedastic
(MGARCH) models in which each element of the conditional correlation
matrix is parameterized as a linear function of its own past and past
shocks.

{pstd}
DVECH MGARCH models are less parsimonious than the
conditional correlation models discussed in {helpb mgarch ccc:[TS] mgarch ccc},
{helpb mgarch dcc:[TS] mgarch dcc}, and {helpb mgarch vcc:[TS] mgarch vcc}
because the number of parameters in DVECH MGARCH models increases more rapidly
with the number of series modeled. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mgarchdvechQuickstart:Quick start}

        {mansection TS mgarchdvechRemarksandexamples:Remarks and examples}

        {mansection TS mgarchdvechMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant term(s).

{phang}
{opth arch(numlist)} specifies the ARCH terms in the model.
By default, no ARCH terms are specified.

{phang}
{opth garch(numlist)} specifies the GARCH terms in the model.
By default, no GARCH terms are specified.

{phang}
{cmd:distribution(}{it:dist} [{it:#}]{cmd:)} specifies the assumed distribution
for the errors.  {it:dist} may be {cmd:gaussian}, {cmd:normal},
or {cmd:t}.

{phang2}
{opt gaussian} and {opt normal} are synonyms; each causes {cmd:mgarch dvech} to
assume that the errors come from a multivariate normal distribution. {it:#}
cannot be specified with either of them.

{phang2}
{cmd:t} causes {cmd:mgarch dvech} to assume that the errors follow a
multivariate Student t distribution, and the degree-of-freedom parameter is
estimated along with the other parameters of the model.  If
{cmd:distribution(t} {it:#}{cmd:)} is specified, then {cmd:mgarch dvech} uses a
multivariate Student t distribution with {it:#} degrees of freedom.  {it:#} must
be greater than 2.

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
{cmd:from(b0)} causes {opt mgarch dvech} to begin the optimization algorithm with
the values in {opt b0}.  {opt b0} must be a row vector, and the number of
columns must equal the number of parameters in the model.

{phang}
{opth svtechnique:(maximize##algorithm_spec:algorithm_spec)} and
{opt sviterate(#)} specify options for the starting-value search process.

{phang2}
{opt svtechnique(algorithm_spec)} specifies the algorithm used
to search for initial values.  The syntax for {it:algorithm_spec} is the
same as for the {opt technique()} option; see {helpb maximize:[R] Maximize}.
{cmd:svtechnique(bhhh 5 nr 16000)} is the default.  This option may not be
specified with {cmd:from()}.

{phang2}
{opt sviterate(#)} specifies the maximum number of iterations
that the search algorithm may perform.  The default is {cmd:sviterate(25)}.
This option may not be specified with {cmd:from()}.

{pstd}
The following option is available with {cmd:mgarch dvech} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see 
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse irates4}{p_end}

{pstd}Fit a VAR(1) model of changes in {cmd:bond} and {cmd:tbill},
allowing for ARCH(1) errors{p_end}
{phang2}{cmd:. mgarch dvech (D.bond D.tbill = LD.bond LD.tbill), arch(1)}{p_end}

{pstd}Same as above, but constraining the lagged effect of {cmd:D.bond} on
{cmd:D.tbill} to be zero and suppressing the constants{p_end}
{phang2}{cmd:. mgarch dvech (D.bond = LD.bond LD.tbill, noconstant)}
        {cmd:(D.tbill = LD.tbill, noconstant), arch(1)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse acme}{p_end}
{phang2}{cmd:. constraint 1 [L.ARCH]1_1  = [L.ARCH]2_2}{p_end}
{phang2}{cmd:. constraint 2 [L.GARCH]1_1 = [L.GARCH]2_2}{p_end}

{pstd}Fit a bivariate GARCH model, constraining the two variables' ARCH
coefficients to be equal, as well as their GARCH coefficients to be equal{p_end}
{phang2}{cmd:. mgarch dvech (acme = L.acme) (anvil = L.anvil),}
        {cmd:arch(1) garch(1) constraints(1 2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse aacmer}{p_end}

{pstd}Fit a bivariate GARCH model with no regressors or constant terms,
including two ARCH terms and one GARCH term{p_end}
{phang2}{cmd:. mgarch dvech (acme anvil = , noconstant), arch(1/2) garch(1)}
{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mgarch dvech} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(model)}}{cmd:dvech}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(dv_eqs)}}dependent variables with mean equations{p_end}
{synopt:{cmd:e(indeps)}}independent variables in each equation{p_end}
{synopt:{cmd:e(tvar)}}time variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(dist)}}distribution for error term: {cmd:gaussian} or {cmd:t}{p_end}
{synopt:{cmd:e(arch)}}specified ARCH terms{p_end}
{synopt:{cmd:e(garch)}}specified GARCH terms{p_end}
{synopt:{cmd:e(svtechnique)}}maximization technique(s) for starting values{p_end}
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
{synopt:{cmd:e(A)}}estimates of {cmd:A} matrices{p_end}
{synopt:{cmd:e(B)}}estimates of {cmd:B} matrices{p_end}
{synopt:{cmd:e(S)}}estimates of {cmd:Sigma0} matrix{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(pinfo)}}parameter information, used by {cmd:predict}{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
