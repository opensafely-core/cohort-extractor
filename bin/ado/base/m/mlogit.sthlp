{smcl}
{* *! version 1.3.10  12dec2018}{...}
{viewerdialog mlogit "dialog mlogit"}{...}
{viewerdialog "svy: mlogit" "dialog mlogit, message(-svy-) name(svy_mlogit)"}{...}
{vieweralsosee "[R] mlogit" "mansection R mlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mlogit postestimation" "help mlogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: mlogit" "help bayes mlogit"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[CM] cmrologit" "help cmrologit"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[FMM] fmm: mlogit" "help fmm mlogit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{vieweralsosee "[CM] nlogit" "help nlogit"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "mlogit##syntax"}{...}
{viewerjumpto "Menu" "mlogit##menu"}{...}
{viewerjumpto "Description" "mlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "mlogit##linkspdf"}{...}
{viewerjumpto "Options" "mlogit##options"}{...}
{viewerjumpto "Examples" "mlogit##examples"}{...}
{viewerjumpto "Stored results" "mlogit##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] mlogit} {hline 2}}Multinomial (polytomous) logistic
regression{p_end}
{p2col:}({mansection R mlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:mlogit}
{depvar}
[{indepvars}]
{ifin}
[{it:{help mlogit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt b:aseoutcome(#)}}value of {depvar} that will be the base outcome{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
   {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt rr:r}}report relative-risk ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help mlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help mlogit##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp}, {opt jackknife},
{opt mfp}, {opt mi estimate}, {opt rolling}, {opt statsby}, and {opt svy} are
allowed; see {help prefix}.
For more details, see {manhelp bayes_mlogit BAYES:bayes: mlogit} and
{manhelp fmm_mlogit FMM:fmm: mlogit}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed;
see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mlogit_postestimation R:mlogit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Multinomial logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mlogit} fits a multinomial logit model for a categorical dependent
variable with outcomes that have no natural ordering.  The actual values taken
by the dependent variable are irrelevant.  The multinomial logit model is also
known as the polytomous logistic regression model.  Some people refer to
conditional logistic regression as multinomial logistic regression.  If you
are one of them, see {manhelp clogit R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mlogitQuickstart:Quick start}

        {mansection R mlogitRemarksandexamples:Remarks and examples}

        {mansection R mlogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt baseoutcome(#)} specifies the value of {depvar}
to be treated as the base outcome.  The default is to choose the most
frequent outcome.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
If specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, you must also
specify {cmd:baseoutcome()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt rrr} reports the estimated coefficients transformed to relative-risk
ratios, that is, exp(b) rather than b; see
{mansection R mlogitRemarksandexamplesDescriptionofthemodel:{it:Description of the model}}
in {bf:[R] mlogit}.
Standard errors and confidence intervals are similarly transformed.  This
option affects how results are displayed, not how they are estimated.
{opt rrr} may be specified at estimation or when replaying previously estimated
results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {opt mlogit} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}

{pstd}Fit multinomial logistic regression model{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site}{p_end}

{pstd}Same as above, but use 2 as the base outcome{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site, base(2)}{p_end}

{pstd}Replay, reporting relative-risk ratios{p_end}
{phang2}{cmd:. mlogit, rrr}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. constraint 1 [Uninsure]}{p_end}
{phang2}{cmd:. constraint 2 [Prepaid]: 2.site 3.site}{p_end}

{pstd}Fit multinomial logistic regression model with constraints{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site, constraint(1)}{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site, constraint(2)}{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site, constraint(1/2)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mlogit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cd)}}number of completely determined observations{p_end}
{synopt:{cmd:e(k_out)}}number of outcomes{p_end}
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
{synopt:{cmd:e(k_eq_base)}}equation number of the base outcome{p_end}
{synopt:{cmd:e(baseout)}}the value of {it:depvar} to be treated as the base
	outcome{p_end}
{synopt:{cmd:e(ibaseout)}}index of the base outcome{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mlogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(baselab)}}value label corresponding to base outcome{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(out)}}outcome values{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
