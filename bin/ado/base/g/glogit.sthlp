{smcl}
{* *! version 1.2.1  15jan2015}{...}
{viewerdialog blogit "dialog blogit"}{...}
{viewerdialog bprobit "dialog bprobit"}{...}
{viewerdialog glogit "dialog glogit"}{...}
{viewerdialog gprobit "dialog gprobit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] glogit postestimation" "help glogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] scobit" "help scobit"}{...}
{viewerjumpto "Syntax" "glogit##syntax"}{...}
{viewerjumpto "Menu" "glogit##menu"}{...}
{viewerjumpto "Description" "glogit##description"}{...}
{viewerjumpto "Options for blogit and bprobit" "glogit##options_blogit"}{...}
{viewerjumpto "Options for glogit and gprobit" "glogit##options_glogit"}{...}
{viewerjumpto "Examples" "glogit##examples"}{...}
{viewerjumpto "Stored results" "glogit##results"}{...}
{pstd}
{cmd:blogit}, {cmd:bprobit}, {cmd:glogit}, and {cmd:gprobit} continue to work
but, as of Stata 14, are no longer an official part of Stata.  This is the
original help file, which we will no longer update, so some links may no
longer work.

{pstd}
See {helpb glm} for a recommended alternative.   Logistic and probit models
for grouped data can be fit via maximum likelihood estimation using {cmd:glm}
if {it:pos_var} is specified as the dependent variable and the
{cmd:family(binomial} {it:pop_var}{cmd:)} option is specified, where
{it:pos_var} and {it:pop_var} are defined as below.  For a logistic model,
specify the {cmd:link(logit)} option.  For a probit model, specify the
{cmd:link(probit)} option.

{hline}

{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{hi:[R] glogit} {hline 2}}Logit and probit estimation for grouped data{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Logistic regression for grouped data

{p 8 16 2}{cmd:blogit}{space 2}{it:pos_var} {it:pop_var} [{indepvars}]
		{ifin} [{cmd:,}
		{it:{help glogit##blogit_options:blogit_options}}]


{phang}
Probit regression for grouped data

{p 8 16 2}{cmd:bprobit} {it:pos_var} {it:pop_var} [{indepvars}]
		{ifin} [{cmd:,}
		{it:{help glogit##bprobit_options:bprobit_options}}]


{phang}
Weighted least-squares logistic regression for grouped data

{p 8 16 2}{cmd:glogit}{space 2}{it:pos_var} {it:pop_var} [{indepvars}]
	{ifin} [{cmd:,}
	{it:{help glogit##glogit_options:glogit_options}}]


{phang}
Weighted least-squares probit regression for grouped data

{p 8 16 2}{cmd:gprobit} {it:pos_var} {it:pop_var} [{indepvars}]
	{ifin} [{cmd:,}
	{it:{help glogit##gprobit_options:gprobit_options}}]
	

{synoptset 28 tabbed}{...}
{marker blogit_options}{...}
{synopthdr :blogit_options}
{synoptline}
{syntab :Model}
{synopt :{opt nocon:stant}}suppress constant term{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
{opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help glogit##b_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help glogit##maximize_options:maximize_options}}}control the maximization process; seldom
used{p_end}

{synopt :{opt nocoe:f}}do not display coefficient table; seldom
used{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker bprobit_options}{...}
{synopthdr :bprobit_options}
{synoptline}
{syntab :Model}
{synopt :{opt nocon:stant}}suppress constant term{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
{opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help glogit##b_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help glogit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
	
{synopt :{opt nocoe:f}}do not display coefficient table; seldom
used{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker glogit_options}{...}
{synopthdr :glogit_options}
{synoptline}
{syntab :SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt ols}, 
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{it:{help glogit##g_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 28 tabbed}{...}
{marker gprobit_options}{...}
{synopthdr :gprobit_options}
{synoptline}
{syntab :SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt ols}, 
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{it:{help glogit##g_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, {opt rolling},
and {opt statsby} are allowed; see {help prefix}.
{opt fp} is allowed with {cmd:blogit} and {cmd:bprobit}.
{p_end}
{p 4 6 2}
{opt nocoef} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp glogit_postestimation R:glogit postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

    {title:blogit}

{phang2}
{bf:Statistics > Binary outcomes > Grouped data >}
     {bf:Logit regression for grouped data}

    {title:bprobit}

{phang2}
{bf:Statistics > Binary outcomes > Grouped data >}
     {bf:Probit regression for grouped data}

    {title:glogit}

{phang2}
{bf:Statistics > Binary outcomes > Grouped data >}
      {bf:Weighted least-squares logit regression}

    {title:gprobit}

{phang2}
{bf:Statistics > Binary outcomes > Grouped data >}
      {bf:Weighted least-squares probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:blogit} and {cmd:bprobit} produce maximum-likelihood logit and probit
estimates on grouped ("blocked") data; {cmd:glogit} and {cmd:gprobit} produce
weighted least-squares estimates.  In the
{help glogit##syntax:syntax diagrams} above, {it:pos_var} and {it:pop_var}
refer to variables containing the total number of positive responses and the
total population.

{pstd}
See {help logistic estimation commands} for a list of related estimation
commands.


{marker options_blogit}{...}
{title:Options for blogit and bprobit}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] estimation options}.

{phang}
{opt asis} forces retention of perfect predictor variables and their
associated perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.

{phang}
{opth offset(varname)},
{opt constraints(constraints)}, {opt collinear}; see
{helpb estimation options##offset():[R] estimation options}.

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
{opt level(#)}; see 
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt or} ({opt blogit} only) reports the estimated coefficients transformed to
odds ratios, that is, exp(b) rather than b.
Standard errors and confidence intervals
are similarly transformed.  This option affects how results are displayed, not
how they are estimated.  {opt or} may be specified at estimation or when
replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] estimation options}.

{marker b_display_options}{...}
INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pstd}
The following options are available with {opt blogit} and {opt bprobit} but are 
not shown in the dialog box:

{phang}
{opt nocoef} specifies that the coefficient table not be displayed.  This
option is sometimes used by program writers but is useless interactively.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker options_glogit}{...}
{title:Options for glogit and gprobit}

{marker glvcetype}{...}
{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:ols})
and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(ols)}, the default, uses the standard variance estimator for ordinary
least-squares regression.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt or} ({cmd:glogit} only) reports the estimated coefficients transformed to
odds ratios, that is, e^b rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated.  {opt or} may be specified at
estimation or when replaying previously estimated results.

{marker g_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt glogit} and {opt gprobit} but is
not shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse xmpl2}{p_end}

{pstd}Logistic regression for grouped data{p_end}
{phang2}{cmd:. blogit deaths pop agecat exposed}{p_end}

{pstd}Same as above, but report odds ratios rather than coefficients{p_end}
{phang2}{cmd:. blogit deaths pop agecat exposed, or}

{pstd}Weighted least-squares logistic regression for grouped data{p_end}
{phang2}{cmd:. glogit deaths pop agecat exposed}{p_end}

{pstd}Same as above, but report odds ratios rather than coefficients{p_end}
{phang2}{cmd:. glogit deaths pop agecat exposed, or}

{pstd}Probit regression for grouped data{p_end}
{phang2}{cmd:. bprobit deaths pop agecat exposed}

{pstd}Replay with 99% confidence intervals{p_end}
{phang2}{cmd:. bprobit, level(99)}

{pstd}Weighted least-squares probit regression for grouped data{p_end}
{phang2}{cmd:. gprobit deaths pop agecat exposed}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:blogit} and {cmd:bprobit} store the following in {cmd:e()}:

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
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:blogit} or {cmd:bprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}variable containing number of positive responses and variable containing population size{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
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
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(mns)}}vector of means of the independent variables{p_end}
{synopt:{cmd:e(rules)}}information about perfect predictors{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{pstd}
{cmd:glogit} and {cmd:gprobit} store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:glogit} or {cmd:gprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}variable containing number of positive responses and variable containing population size{p_end}
{synopt:{cmd:e(model)}}{cmd:ols}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
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
