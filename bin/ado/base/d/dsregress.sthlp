{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog dsregress "dialog dsregress"}{...}
{vieweralsosee "[LASSO] dsregress" "mansection lasso dsregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] poregress" "help poregress"}{...}
{vieweralsosee "[LASSO] xporegress" "help xporegress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "dsregress##syntax"}{...}
{viewerjumpto "Menu" "dsregress##menu"}{...}
{viewerjumpto "Description" "dsregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsregress##linkspdf"}{...}
{viewerjumpto "Options" "dsregress##options"}{...}
{viewerjumpto "Examples" "dsregress##examples"}{...}
{viewerjumpto "Stored results" "dsregress##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[LASSO] dsregress} {hline 2}}Double-selection lasso linear regression{p_end}
{p2col:}({mansection LASSO dsregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{opt dsregress}
{depvar}
{it:varsofinterest}
{ifin}{cmd:,}
INCLUDE help controls_syntax

{pstd}
{it:varsofinterest} are variables for which coefficients and their 
standard errors are estimated.

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
INCLUDE help controls_short
INCLUDE help selection_short
{synopt :{opt sqrt:lasso}}use square-root lassos{p_end}
INCLUDE help missingok_short

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust} (the default), 
{cmd:ols}, {cmd:hc2}, or {cmd:hc3}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help dsregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :[{opt no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{opt verbose}}display a verbose iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:{help dsregress##lasso_options:lasso_options}}{cmd:)}}specify options for the lassos
for variables in {it:varlist}; may be repeated{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:{help dsregress##sqrtlasso_options:lasso_options}}{cmd:)}}specify options for
square-root lassos for variables in {it:varlist}; may be repeated{p_end}

INCLUDE help reestimate_short
{synopt :{opt nohead:er}}do not display the header on the coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help footnotes_inference


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso inferential models > Continuous outcomes > Double-selection model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dsregress} fits a lasso linear regression model and reports
coefficients along with standard errors, test statistics, and
confidence intervals for specified covariates of interest.  The
double-selection method is used to estimate effects for these variables and
to select from potential control variables to be included in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO dsregressQuickstart:Quick start}

        {mansection LASSO dsregressRemarksandexamples:Remarks and examples}

        {mansection LASSO dsregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:controls(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)} specifies
the set of control variables, which control for omitted variables.  Control
variables are also known as confounding variables.  {cmd:dsregress} fits
lassos for {it:depvar} and each of the {it:varsofinterest}.  {it:alwaysvars}
are variables that are always to be included in these lassos.  {it:alwaysvars}
are optional.  {it:othervars} are variables that each lasso will choose to
include or exclude.  That is, each lasso will select a subset of
{it:othervars}.  The selected subset of {it:othervars} may differ across
lassos.  {cmd:controls()} is required.

INCLUDE help selection_long

{phang}
{cmd:sqrtlasso} specifies that square-root lassos be done rather than regular
lassos.  The option {cmd:lasso()} can be used with {cmd:sqrtlasso} to specify
that regular lasso be done for some variables, overriding the global
{cmd:sqrtlasso} setting for these variables.  See
{manhelp lasso_options LASSO:lasso options}.

INCLUDE help missingok_long

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported.
The default is {cmd:vce(robust)}, which is robust to some kinds of 
misspecification.  Also available are {cmd:vce(ols)}, the standard variance 
estimator for ordinary least-squares regression, and {cmd:vce(hc2)} and 
{cmd:vce(hc3)}, which specify alternative bias corrections for the
robust variance calculation.
See {helpb vce_option:[R] {it:vce_option}} and 
{helpb regress##options:[R] regress}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

INCLUDE help log_long

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)} and {cmd:selection(adaptive)}.  The
default selection method {cmd:selection(plugin)} does not use random numbers.
{opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed} {it:#} prior to
running {cmd:dsregress}.  See {manhelp set_seed R:set seed}.

{dlgtab:Advanced}

INCLUDE help lasso_opt_long

INCLUDE help sqrtlasso_opt_linear_long

{pstd}
The following options are available with {cmd:dsregress} but are not shown in 
the dialog box:

{phang}
{cmd:reestimate} is an advanced option that refits the {cmd:dsregress} model
based on changes made to the underlying lassos using {helpb lassoselect}.
After running {cmd:dsregress}, you can select a different lambda* for one
or more of the lassos estimated by {cmd:dsregress}.  After selecting
lambda*, you type {cmd:dsregress,} {cmd:reestimate} to refit the
{cmd:dsregress} model based on the newly selected lambdas.

{pmore}
{cmd:reestimate} may be combined only with reporting options.

{phang}
{cmd:noheader} prevents the coefficient table header from being displayed.

{phang}
{cmd:coeflegend}; see
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe}

{pstd}Double-selection lasso linear regression for outcome reaction time and
inference on classroom and home nitrogen oxide{p_end}
{phang2}{cmd:. dsregress react no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}

{pstd}Double-selection lasso linear regression for outcome reaction time and
inference on classroom and home nitrogen oxide using cross-validation  to
select controls{p_end}
{phang2}{cmd:. dsregress react no2_class no2_home,}
    {cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
    {cmd:selection(cv)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dsregress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_varsofinterest)}}number of variables of interest{p_end}
{synopt:{cmd:e(k_controls)}}number of potential control variables{p_end}
{synopt:{cmd:e(k_controls_sel)}}number of selected control variables{p_end}
{synopt:{cmd:e(df)}}degrees of freedom for test of variables of interest{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for test of variables of interest{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:dsregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(lasso_depvars)}}names of dependent variables for all lassos{p_end}
{synopt:{cmd:e(varsofinterest)}}variables of interest{p_end}
{synopt:{cmd:e(controls)}}potential control variables{p_end}
{synopt:{cmd:e(controls_sel)}}selected control variables{p_end}
{synopt:{cmd:e(model)}}{cmd:linear}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(select_cmd)}}program used to implement {cmd:lassoselect}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
