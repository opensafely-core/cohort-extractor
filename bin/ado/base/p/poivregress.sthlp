{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog poivregress "dialog poivregress"}{...}
{vieweralsosee "[LASSO] poivregress" "mansection lasso poivregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{vieweralsosee "[LASSO] xpoivregress" "help xpoivregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{viewerjumpto "Syntax" "poivregress##syntax"}{...}
{viewerjumpto "Menu" "poivregress##menu"}{...}
{viewerjumpto "Description" "poivregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "poivregress##linkspdf"}{...}
{viewerjumpto "Options" "poivregress##options"}{...}
{viewerjumpto "Examples" "poivregress##examples"}{...}
{viewerjumpto "Stored results" "poivregress##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[LASSO] poivregress} {hline 2}}Partialing-out lasso instrumental-variables regression{p_end}
{p2col:}({mansection LASSO poivregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt poivregress}
{depvar}
[{it:exovars}]
{cmd:(}{it:endovars} {cmd:=} {it:instrumvars}{cmd:)}
{ifin}{cmd:,}
INCLUDE help controls_syntax

{pstd}
Coefficients and standard errors are estimated for the exogenous variables,  
{it:exovars}, and the endogenous variables, {it:endovars}.
The set of instrumental variables, {it:instrumvars}, may be high dimensional.

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {cmdab:cont:rols(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)}}{it:alwaysvars} and {it:othervars} are control variables for {it:depvar},
{it:exovars}, and {it:endovars}; {it:instrumvars} are an additional set
of control variables that apply only to the {it:endovars};
{it:alwaysvars} are always included; lassos choose
whether to include or exclude {it:othervars}{p_end}
INCLUDE help selection_short
{synopt :{opt sqrt:lasso}}use square-root lasso{p_end}
INCLUDE help missingok_iv_short

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help poivregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :[{opt no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{cmd:verbose}}display a verbose iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:{help poivregress##lasso_options:lasso_options}}{cmd:)}}specify options for the lassos for variables in {it:varlist}; may be repeated{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:{help poivregress##sqrtlasso_options:lasso_options}}{cmd:)}}specify options for square-root lassos for variables in {it:varlist}; may be repeated{p_end}

INCLUDE help robust_short
INCLUDE help reestimate_short
{synopt :{opt nohead:er}}do not display the header on the coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help footnotes_iv


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso inferential models > Continuous outcomes > Partialing-out IV model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:poivregress} fits a lasso instrumental-variables linear regression model
and reports coefficients along with standard errors, test statistics, and
confidence intervals for specified covariates of interest.  The covariates of
interest may be endogenous or exogenous.  The partialing-out method is used to
estimate effects for these variables and to select from potential control
variables and instruments to be included in the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO poivregressQuickstart:Quick start}

        {mansection LASSO poivregressRemarksandexamples:Remarks and examples}

        {mansection LASSO poivregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:controls(}[{cmd:(}{it:alwaysvars}{cmd:)}] {it:othervars}{cmd:)}
specifies the set of control variables, which control for omitted variables.
Control variables are also known as confounding variables.  {it:alwaysvars}
are variables that are always to be included in lassos.  {it:alwaysvars} are
optional.  {it:othervars} are variables that lassos will choose to include or
exclude.  The instrumental variables, {it:instrumvars}, are an additional set
of control variables, but they apply only to the {it:endovars}.
{cmd:controls()} is required.

{pmore}
{cmd:poivregress} fits lassos for {it:depvar} and each one of the 
{it:exovars} and {it:endovars}.
The control variables for the lassos for {it:depvar} and {it:exovars}
are {it:alwaysvars} (always included) and {it:othervars} 
(lasso will include or exclude).
The control variables for lassos for {it:endovars}
are {it:exovars} (always included), {it:alwaysvars} (always included),
{it:instrumvars} (lasso will include or exclude), and {it:othervars}
(lasso will include or exclude).

INCLUDE help selection_long

{phang}
{cmd:sqrtlasso}
specifies that square-root lassos be done rather than regular lassos.  The
option {cmd:lasso()} can be used with {cmd:sqrtlasso} to specify that regular
lasso be done for some variables, overriding the global {cmd:sqrtlasso}
setting for these variables.  See {manhelp lasso_options LASSO:lasso options}.

INCLUDE help missingok_iv_long

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

{phang}
[{cmd:no}]{cmd:log} displays or suppresses a log showing the progress of the
estimation.  By default, one-line messages indicating when each lasso
estimation begins are shown.  Specify {cmd:verbose} to see a more detailed
log.

{phang}
{cmd:verbose} displays a verbose log showing the iterations of each lasso
estimation.  This option is useful when doing {cmd:selection(cv)} or
{cmd:selection(adaptive)}.  It allows you to monitor the progress of the lasso
estimations for these selection methods, which can be time consuming when
there are many {it:othervars} specified in {cmd:controls()} or many
{it:instrumvars}.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)} and {cmd:selection(adaptive)}.  The
default selection method {cmd:selection(plugin)} does not use random numbers.
{opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed} {it:#} prior to
running {cmd:poivregress}.  See {manhelp set_seed R:set seed}.

{dlgtab:Advanced}

INCLUDE help lasso_opt_iv_long

INCLUDE help sqrtlasso_opt_iv_long

{pstd}
The following options are available with {cmd:poivregress} but are not shown in 
the dialog box:

INCLUDE help robust_long

{phang}
{cmd:reestimate} is an advanced option that refits the {cmd:poivregress} model
based on changes made to the underlying lassos using {helpb lassoselect}.
After running {cmd:poivregress}, you can select a different lambda* for one or
more of the lassos estimated by {cmd:poivregress}.  After selecting lambda*,
you type {cmd:poivregress,} {cmd:reestimate} to refit the {cmd:poivregress}
model based on the newly selected lambdas.

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
{phang2}{cmd:. webuse nlsy80}

{pstd}Partialing-out lasso instrumental-variables regression for outcome
{cmd:wage} and inference on {cmd:exper} and instrumented endogenous
{cmd:educ}{p_end}
{phang2}{cmd:. poivregress wage exper}
    {cmd:(educ = i.pcollege##c.(meduc feduc) i.urban sibs iq),}
    {cmd:controls(c.age##c.age tenure kww i.(married black south urban))}

{pstd}Partialing-out lasso instrumental-variables regression for outcome
{cmd:wage} and inference on {cmd:exper} and instrumented endogenous {cmd:educ}
using cross-validation to select instruments and controls{p_end}
{phang2}{cmd:. poivregress wage exper}
    {cmd:(educ = i.pcollege##c.(meduc feduc) i.urban sibs iq),}
    {cmd:controls(c.age##c.age tenure kww i.(married black south urban))}
    {cmd:selection(cv)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:poivregress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_varsofinterest)}}number of variables of interest{p_end}
{synopt:{cmd:e(k_controls)}}number of potential control variables{p_end}
{synopt:{cmd:e(k_controls_sel)}}number of selected control variables{p_end}
{synopt:{cmd:e(k_inst)}}number of potential instruments{p_end}
{synopt:{cmd:e(k_inst_sel)}}number of selected instruments{p_end}
{synopt:{cmd:e(df)}}degrees of freedom for test of variables of interest{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for test of variables of interest{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:poivregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(lasso_depvars)}}names of dependent variables for all lassos{p_end}
{synopt:{cmd:e(varsofinterest)}}variables of interest{p_end}
{synopt:{cmd:e(controls)}}potential control variables{p_end}
{synopt:{cmd:e(controls_sel)}}selected control variables{p_end}
{synopt:{cmd:e(exog)}}exogenous variables{p_end}
{synopt:{cmd:e(endog)}}endogenous variables{p_end}
{synopt:{cmd:e(inst)}}potential instruments{p_end}
{synopt:{cmd:e(inst_sel)}}selected instruments{p_end}
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
