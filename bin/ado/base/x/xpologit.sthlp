{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog xpologit "dialog xpologit"}{...}
{vieweralsosee "[LASSO] xpologit" "mansection lasso xpologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] dslogit" "help dslogit"}{...}
{vieweralsosee "[LASSO] pologit" "help pologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{viewerjumpto "Syntax" "xpologit##syntax"}{...}
{viewerjumpto "Menu" "xpologit##menu"}{...}
{viewerjumpto "Description" "xpologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "xpologit##linkspdf"}{...}
{viewerjumpto "Options" "xpologit##options"}{...}
{viewerjumpto "Examples" "xpologit##examples"}{...}
{viewerjumpto "Stored results" "xpologit##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[LASSO] xpologit} {hline 2}}Cross-fit partialing-out lasso
logistic regression{p_end}
{p2col:}({mansection LASSO xpologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt xpologit}
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
{synopt :{opt xfold:s(#)}}use {it:#} folds for cross-fitting{p_end}
{synopt :{opt resample}[{cmd:(}{it:#}{cmd:)}]}repeat sample splitting {it:#} times and average results{p_end}
INCLUDE help technique_short
INCLUDE help missingok_short
{synopt :{opth off:set(varname)}}include {it:varname} in the lasso and model for {it:depvar} with its coefficient constrained to be 1{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmd:or}}report odds ratios; the default{p_end}
{synopt :{cmd:coef}}report estimated coefficients{p_end}
{synopt :{it:{help xpologit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :[{opt no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{cmd:verbose}}display a verbose iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:{help xpologit##lasso_options:lasso_options}}{cmd:)}}specify options for the lassos for variables in {it:varlist}; may be repeated{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:{help xpologit##sqrtlasso_options:lasso_options}}{cmd:)}}specify options for square-root lassos for variables in {it:varlist}; may be repeated{p_end}

INCLUDE help robust_short
INCLUDE help reestimate_short
{synopt :{opt nohead:er}}do not display the header on the coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help footnotes_po


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso inferential models > Binary outcomes > Cross-fit partialing-out logit model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xpologit} fits a lasso logistic regression model and reports odds ratios
along with standard errors, test statistics, and confidence intervals for
specified covariates of interest.  The cross-fit partialing-out method is used
to estimate effects for these variables and to select from potential control
variables to be included in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO xpologitQuickstart:Quick start}

        {mansection LASSO xpologitRemarksandexamples:Remarks and examples}

        {mansection LASSO xpologitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:controls(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)} specifies
the set of control variables, which control for omitted variables.  Control
variables are also known as confounding variables.  {cmd:xpologit} fits lassos
for {it:depvar} and each of the {it:varsofinterest}.  {it:alwaysvars} are
variables that are always to be included in these lassos.  {it:alwaysvars} are
optional.  {it:othervars} are variables that each lasso will choose to include
or exclude.  That is, each lasso will select a subset of {it:othervars} and
other lassos will potentially select different subsets of {it:othervars}.
{cmd:controls()} is required.

INCLUDE help selection_long

{phang}
{cmd:sqrtlasso} specifies that square-root lassos be done rather than regular
lassos for the {it:varsofinterest}.  This option does not apply to
{it:depvar}.  Square-root lassos are linear models, and the lasso for
{it:depvar} is always a logit lasso.  The option {cmd:lasso()} can be used
with {cmd:sqrtlasso} to specify that regular lasso be done for some variables,
overriding the global {cmd:sqrtlasso} setting for these variables.  See
{manhelp lasso_options LASSO:lasso options}.

{phang}
{opt xfolds(#)} specifies the number of folds for cross-fitting.  The default
is {cmd:xfolds(10)}.

INCLUDE help resample_long

INCLUDE help technique_long
See
{mansection LASSO xpologitMethodsandformulas:Methods and formulas} in
{bf:[LASSO] xpologit}.

INCLUDE help missingok_long

{phang}
{opth offset(varname)} specifies that {it:varname} be included in the lasso
and model for {it:depvar} with its coefficient constrained to be 1.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

INCLUDE help or_long

INCLUDE help displayopts_list

{dlgtab:Optimization}

INCLUDE help log_long

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results.  {opt rseed(#)} is equivalent to typing {cmd:set}
{cmd:seed} {it:#} prior to running {cmd:xpologit}.  Random numbers are used to
produce split samples for cross-fitting.  So for all {cmd:selection()}
options, if you want to reproduce your results, you must either use this
option or use {cmd:set} {cmd:seed}.  See {manhelp set_seed R:set seed}.

{dlgtab:Advanced}

INCLUDE help lasso_opt_long

INCLUDE help sqrtlasso_opt_nonlinear_long

{pstd}
The following options are available with {cmd:xpologit} but are not shown in 
the dialog box:

INCLUDE help robust_long

{phang}
{cmd:reestimate} is an advanced option that refits the {cmd:xpologit} model
based on changes made to the underlying lassos using {helpb lassoselect}.
After running {cmd:xpologit}, you can select a different lambda* for one or
more of the lassos estimated by {cmd:xpologit}.  After selecting lambda*, you
type {cmd:xpologit,} {cmd:reestimate} to refit the {cmd:xpologit} model based
on the newly selected lambdas.

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
{phang2}{cmd:. webuse cattaneo2}

{pstd}Cross-fit partialing-out logistic regression for outcome low birthweight
and inference on whether mother smoked during pregnancy{p_end}
{phang2}{cmd:. xpologit lbweight i.mbsmoke,}
    {cmd:controls(i.(alcohol mmarried prenatal1)}
    {cmd:c.mage#i.foreign c.medu##c.fedu)}
	
{pstd}Cross-fit partialing-out logistic regression for outcome low birthweight
and inference on whether mother smoked during pregnancy using 5 folds for
cross-fitting{p_end}
{phang2}{cmd:. xpologit lbweight i.mbsmoke,}
    {cmd: controls(i.(alcohol mmarried prenatal1)}
    {cmd:c.mage#i.foreign c.medu##c.fedu) xfolds(5)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xpologit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_varsofinterest)}}number of variables of interest{p_end}
{synopt:{cmd:e(k_controls)}}number of potential control variables{p_end}
{synopt:{cmd:e(k_controls_sel)}}number of selected control variables{p_end}
{synopt:{cmd:e(df)}}degrees of freedom for test of variables of
interest{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for test of variables of
interest{p_end}
{synopt:{cmd:e(n_xfolds)}}number of folds for cross-fitting{p_end}
{synopt:{cmd:e(n_resample)}}number of resamples{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xpologit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(lasso_depvars)}}names of dependent variables for all
lassos{p_end}
{synopt:{cmd:e(varsofinterest)}}variables of interest{p_end}
{synopt:{cmd:e(controls)}}potential control variables{p_end}
{synopt:{cmd:e(controls_sel)}}selected control variables{p_end}
{synopt:{cmd:e(model)}}{cmd:logit}{p_end}
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
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
