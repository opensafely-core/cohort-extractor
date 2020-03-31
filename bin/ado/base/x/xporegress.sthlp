{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog xporegress "dialog xporegress"}{...}
{vieweralsosee "[LASSO] xporegress" "mansection lasso xporegress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] dsregress" "help dsregress"}{...}
{vieweralsosee "[LASSO] poregress" "help poregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "xporegress##syntax"}{...}
{viewerjumpto "Menu" "xporegress##menu"}{...}
{viewerjumpto "Description" "xporegress##description"}{...}
{viewerjumpto "Links to PDF documentation" "xporegress##linkspdf"}{...}
{viewerjumpto "Options" "xporegress##options"}{...}
{viewerjumpto "Examples" "xporegress##examples"}{...}
{viewerjumpto "Stored results" "xporegress##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[LASSO] xporegress} {hline 2}}Cross-fit partialing-out lasso
linear regression{p_end}
{p2col:}({mansection LASSO xporegress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{opt xporegress}
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
{synopt :{cmdab:sqrt:lasso}}use square-root lassos{p_end}
{synopt :{opt xfold:s(#)}}use {it:#} folds for cross-fitting{p_end}
{synopt :{opt resample}[{cmd:(}{it:#}{cmd:)}]}repeat sample splitting {it:#} times and average results{p_end}
INCLUDE help technique_short
{synopt :{opt semi}}use semi partialing-out lasso regression estimator{p_end}
INCLUDE help missingok_short

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xpoivregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :[{opt no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{cmd:verbose}}display a verbose iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:{help xporegress##lasso_options:lasso_options}}{cmd:)}}specify options for the
lassos for variables in {it:varlist}; may be repeated{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:{help xporegress##sqrtlasso_options:lasso_options}}{cmd:)}}specify options for
square-root lassos for variables in {it:varlist}; may be repeated{p_end}

INCLUDE help robust_short
INCLUDE help reestimate_short
{synopt :{opt nohead:er}}do not display the header on the coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help footnotes_po


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso inferential models > Continuous outcomes > Cross-fit partialing-out model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xporegress} fits a lasso linear regression model and reports coefficients
along with standard errors, test statistics, and confidence intervals for
specified covariates of interest.  The cross-fit partialing-out method is used
to estimate effects for these variables and to select from potential control
variables to be included in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO xporegressQuickstart:Quick start}

        {mansection LASSO xporegressRemarksandexamples:Remarks and examples}

        {mansection LASSO xporegressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:controls(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)} specifies
the set of control variables, which control for omitted variables.  Control
variables are also known as confounding variables.  {cmd:xporegress} fits
lassos for {it:depvar} and each of the {it:varsofinterest}.  {it:alwaysvars}
are variables that are always to be included in these lassos.  {it:alwaysvars}
are optional.  {it:othervars} are variables that each lasso will choose to
include or exclude.  That is, each lasso will select a subset of {it:othervars}
and other lassos will potentially select different subsets of {it:othervars}.
{cmd:controls()} is required.

INCLUDE help selection_long

{phang}
{cmd:sqrtlasso} specifies that square-root lassos be done rather than regular
lassos.  The option {cmd:lasso()} can be used with {cmd:sqrtlasso} to specify
that regular lasso be done for some variables, overriding the global
{cmd:sqrtlasso} setting for these variables.  See 
{manhelp lasso_options LASSO:lasso options}.

{phang}
{opt xfolds(#)} specifies the number of folds for cross-fitting.  The default
is {cmd:xfolds(10)}.

INCLUDE help resample_long

INCLUDE help technique_long
See
{mansection LASSO xporegressMethodsandformulas:Methods and formulas} in
{bf:[LASSO] xporegress}.

{phang}
{cmd:semi}
specifies that the semi partialing-out lasso regression estimator be used
instead of the fully partialing-out lasso estimator, which is the default.
See {mansection LASSO xporegressMethodsandformulas:Methods and formulas} in
{bf:[LASSO] xporegress}.

INCLUDE help missingok_long

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

INCLUDE help log_long

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results.  {opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed}
{it:#} prior to running {cmd:xporegress}.  Random numbers are used to produce
split samples for cross-fitting.  So for all {cmd:selection()} options, if you
want to reproduce your results, you must either use this option or use
{cmd:set} {cmd:seed}.  See {manhelp set_seed R:set seed}.

{dlgtab:Advanced}

INCLUDE help lasso_opt_long

INCLUDE help sqrtlasso_opt_linear_long

{pstd}
The following options are available with {cmd:xporegress} but are not shown in 
the dialog box:

INCLUDE help robust_long

{phang}
{cmd:reestimate} is an advanced option that refits the {cmd:xporegress} model
based on changes made to the underlying lassos using {helpb lassoselect}.
After running {cmd:xporegress}, you can select a different lambda* for one or
more of the lassos estimated by {cmd:xporegress}.  After selecting lambda*, you
type {cmd:xporegress,} {cmd:reestimate} to refit the {cmd:xporegress} model
based on the newly selected lambdas.

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
	
{pstd}Cross-fit partialing-out lasso linear regression for outcome reaction
time and inference on classroom and home nitrogen oxide{p_end}
{phang2}{cmd:. xporegress react no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}

{pstd}Cross-fit partialing-out lasso linear regression for outcome reaction
time and inference on classroom and home nitrogen oxide using 5 folds for
cross-fitting{p_end}
{phang2}{cmd:. xporegress react no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
	{cmd:xfolds(5)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xporegress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_varsofinterest)}}number of variables of interest{p_end}
{synopt:{cmd:e(k_controls)}}number of potential control variables{p_end}
{synopt:{cmd:e(k_controls_sel)}}number of selected control variables{p_end}
{synopt:{cmd:e(df)}}degrees of freedom for test of variables of interest{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for test of variables of interest{p_end}
{synopt:{cmd:e(n_xfolds)}}number of folds for cross-fitting{p_end}
{synopt:{cmd:e(n_resample)}}number of resamples{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xporegress}{p_end}
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
