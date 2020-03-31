{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog dspoisson "dialog dspoisson"}{...}
{vieweralsosee "[LASSO] dspoisson" "mansection lasso dspoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] popoisson" "help popoisson"}{...}
{vieweralsosee "[LASSO] xpopoisson" "help xpopoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{viewerjumpto "Syntax" "dspoisson##syntax"}{...}
{viewerjumpto "Menu" "dspoisson##menu"}{...}
{viewerjumpto "Description" "dspoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "dspoisson##linkspdf"}{...}
{viewerjumpto "Options" "dspoisson##options"}{...}
{viewerjumpto "Examples" "dspoisson##examples"}{...}
{viewerjumpto "Stored results" "dspoisson##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[LASSO] dspoisson} {hline 2}}Double-selection lasso Poisson regression{p_end}
{p2col:}({mansection LASSO dspoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:dspoisson}
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
{synopt :{opt sqrt:lasso}}use square-root lassos for {it:varsofinterest}{p_end}
INCLUDE help missingok_short
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in the lasso and model for {it:depvar} with its coefficient constrained to be 1{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname}_e) in the lasso and model for {it:depvar} with its coefficient constrained to be 1{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust} (the default) 
or {cmd:oim}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmd:irr}}report incidence-rate ratios; the default{p_end}
{synopt :{cmd:coef}}report estimated coefficients{p_end}
{synopt :{it:{help dspoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :[{cmd:no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{cmd:verbose}}display a verbose iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:{help dspoisson##lasso_options:lasso_options}}{cmd:)}}specify options for the lassos for variables in {it:varlist}; may be repeated{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:{help dspoisson##sqrtlasso_options:lasso_options}}{cmd:)}}specify options for square-root lassos for variables in {it:varlist}; may be repeated{p_end}

INCLUDE help reestimate_short
{synopt :{opt nohead:er}}do not display the header on the coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help footnotes_inference


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso inferential models > Count outcomes > Double-selection Poisson model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dspoisson} fits a lasso Poisson regression model and reports
incidence-rate ratios along with standard errors, test statistics, and
confidence intervals for specified covariates of interest.  The
double-selection method is used to estimate effects for these variables and
to select from potential control variables to be included in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO dspoissonQuickstart:Quick start}

        {mansection LASSO dspoissonRemarksandexamples:Remarks and examples}

        {mansection LASSO dspoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:controls(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)} specifies
the set of control variables, which control for omitted variables.  Control
variables are also known as confounding variables.  {cmd:dspoisson} fits lassos
for {it:depvar} and each of the {it:varsofinterest}.  {it:alwaysvars} are
variables that are always to be included in these lassos.  {it:alwaysvars} are
optional.  {it:othervars} are variables that each lasso will choose to include
or exclude.  That is, each lasso will select a subset of {it:othervars}.  The
selected subset of {it:othervars} may differ across lassos.  {cmd:controls()}
is required.

INCLUDE help selection_long

{phang}
{cmd:sqrtlasso} specifies that square-root lassos be done rather than regular
lassos for the {it:varsofinterest}.  This option does not apply to {it:depvar}.
Square-root lassos are linear models, and the lasso for {it:depvar} is always a
Poisson lasso.  The option {cmd:lasso()} can be used with {cmd:sqrtlasso} to
specify that regular lasso be done for some variables, overriding the global
{cmd:sqrtlasso} setting for these variables.  See
{manhelp lasso_options LASSO:lasso options}.

INCLUDE help missingok_long

{phang}
{opth "offset(varname:varname_o)"} specifies that {it:varname_o} be included
in the lasso and model for {it:depvar} with its coefficient constrained to be
1.

{phang}
{opth "exposure(varname:varname_e)"} specifies that ln({it:varname_e}) be
included in the lasso and model for {it:depvar} with its coefficient
constrained to be 1.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported.  The default
is {cmd:vce(robust)}, which is robust to some kinds of misspecification.  Also
available is {cmd:vce(oim)}, the observed information matrix (OIM).  See
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

INCLUDE help irr_long

INCLUDE help displayopts_list

{dlgtab:Optimization}

INCLUDE help log_long

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)} and {cmd:selection(adaptive)}.  The
default selection method {cmd:selection(plugin)} does not use random numbers.
{opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed} {it:#} prior to
running {cmd:dspoisson}.  See {manhelp set_seed R:set seed}.

{dlgtab:Advanced}

INCLUDE help lasso_opt_long

INCLUDE help sqrtlasso_opt_nonlinear_long

{pstd}
The following options are available with {cmd:dspoisson} but are not shown in 
the dialog box:

{phang}
{cmd:reestimate} is an advanced option that refits the {cmd:dspoisson} model
based on changes made to the underlying lassos using {helpb lassoselect}.
After running {cmd:dspoisson}, you can select a different lambda* for one or
more of the lassos estimated by {cmd:dspoisson}.  After selecting lambda*, you
type {cmd:dspoisson,} {cmd:reestimate} to refit the {cmd:dspoisson} model based
on the newly selected lambda*s.

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

{pstd}Double-selection lasso Poisson regression for outcome correct number of
responses and inference on classroom and home nitrogen oxide{p_end}
{phang2}{cmd:. dspoisson correct no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}

{pstd}Double-selection lasso Poisson regression for outcome correct number of
responses and inference on classroom and home nitrogen oxide using
cross-validation to select controls{p_end}
{phang2}{cmd:. dspoisson correct no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
	{cmd:selection(cv)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dspoisson} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(cmd)}}{cmd:dspoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(lasso_depvars)}}names of dependent variables for all lassos{p_end}
{synopt:{cmd:e(varsofinterest)}}variables of interest{p_end}
{synopt:{cmd:e(controls)}}potential control variables{p_end}
{synopt:{cmd:e(controls_sel)}}selected control variables{p_end}
{synopt:{cmd:e(model)}}{cmd:poisson}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
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
