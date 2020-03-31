{smcl}
{* *! version 1.2.13  12dec2018}{...}
{viewerdialog tobit "dialog tobit"}{...}
{viewerdialog "svy: tobit" "dialog tobit, message(-svy-) name(svy_tobit)"}{...}
{vieweralsosee "[R] tobit" "mansection R tobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tobit postestimation" "help tobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: tobit" "help bayes tobit"}{...}
{vieweralsosee "[ERM] eintreg" "help eintreg"}{...}
{vieweralsosee "[FMM] fmm: tobit" "help fmm tobit"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[ME] metobit" "help metobit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] truncreg" "help truncreg"}{...}
{vieweralsosee "[XT] xtintreg" "help xtintreg"}{...}
{vieweralsosee "[XT] xttobit" "help xttobit"}{...}
{viewerjumpto "Syntax" "tobit##syntax"}{...}
{viewerjumpto "Menu" "tobit##menu"}{...}
{viewerjumpto "Description" "tobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "tobit##linkspdf"}{...}
{viewerjumpto "Options" "tobit##options"}{...}
{viewerjumpto "Examples" "tobit##examples"}{...}
{viewerjumpto "Stored results" "tobit##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] tobit} {hline 2}}Tobit regression{p_end}
{p2col:}({mansection R tobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:tobit}
{depvar} [{indepvars}]
{ifin}
[{it:{help tobit##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt ll}[{cmd:(}{varname}|{it:#}{cmd:)}]}left-censoring variable or limit{p_end}
{synopt :{opt ul}[{cmd:(}{varname}|{it:#}{cmd:)}]}right-censoring variable or limit{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
  {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help tobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help tobit##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp}, {opt jackknife},
{opt nestreg}, {opt rolling}, {opt statsby}, {opt stepwise}, and {opt svy}
are allowed; see {help prefix}.
For more details, see {manhelp bayes_tobit BAYES:bayes: tobit} and
{manhelp fmm_tobit FMM:fmm: tobit}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s, {opt fweight}s, {opt iweight}s, and {opt pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp tobit_postestimation R:tobit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Censored regression >}
      {bf:Tobit regression}


{marker description}{...}
{title:Description}

{pstd}
{opt tobit} fits models for continuous responses where the outcome variable is
censored.  Censoring limits may be fixed for all observations or vary across
observations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tobitQuickstart:Quick start}

        {mansection R tobitRemarksandexamples:Remarks and examples}

        {mansection R tobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}. 

{phang}
{opt ll}[{cmd:(}{varname}|{it:#}{cmd:)}] and
{opt ul}[{cmd:(}{varname}|{it:#}{cmd:)}]
   indicate the lower and upper limits for censoring, respectively.
   Observations with {depvar} {ul:<} {opt ll()} are left-censored; observations
   with {it:depvar} {ul:>} {opt ul()} are right-censored; and remaining
   observations are not censored.  You do not have to specify the censoring
   value.  If you specify {opt ll}, the lower limit is the minimum of
   {it:depvar}.  If you specify {opt ul}, the upper limit is the maximum of
   {it:depvar}.

{phang}
{opth offset(varname)}, {opt constraints(constraints)}; see
{helpb estimation options##offset():[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, 
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following options are available with {opt tobit} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate wgt=weight/1000}{p_end}

{pstd}Censored from below{p_end}
{phang2}{cmd:. tobit mpg wgt, ll(17)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. generate wgt=weight/100}{p_end}

{pstd}Censored from above{p_end}
{phang2}{cmd:. tobit mpg wgt, ul(24)}

{pstd}Clustered on foreign{p_end}
{phang2}{cmd:. tobit mpg wgt, ul(24) vce(cluster foreign)}

{pstd}Two-limit tobit{p_end}
{phang2}{cmd:. tobit mpg wgt, ll(17) ul(24)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}
{cmd:. webuse gpa, clear}

{pstd}Censored at the minimum of {cmd:gpa2}{p_end}
{phang2}
{cmd:. tobit gpa2 hsgpa pincome program, ll}

    {hline}
{pstd}Setup{p_end}
{phang2}
{cmd:. webuse mroz87}

{pstd}Censored from below at zero{p_end}
{phang2}
{cmd:. tobit whrs75 nwinc wedyrs wexper c.wexper#c.wexper wifeage kl6 k618, ll(0)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt:{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt:{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:tobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(llopt)}}minimum of {it:depvar} or contents of {cmd:ll()}{p_end}
{synopt:{cmd:e(ulopt)}}maximum of {it:depvar} or contents of {cmd:ul()}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(method)}}estimation method: {cmd:ml}{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
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
