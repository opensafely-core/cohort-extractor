{smcl}
{* *! version 1.1.28  18feb2020}{...}
{viewerdialog areg "dialog areg"}{...}
{vieweralsosee "[R] areg" "mansection R areg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] areg postestimation" "help areg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Syntax" "areg##syntax"}{...}
{viewerjumpto "Menu" "areg##menu"}{...}
{viewerjumpto "Description" "areg##description"}{...}
{viewerjumpto "Links to PDF documentation" "areg##linkspdf"}{...}
{viewerjumpto "Options" "areg##options"}{...}
{viewerjumpto "Examples" "areg##examples"}{...}
{viewerjumpto "Stored results" "areg##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] areg} {hline 2}}Linear regression with a large dummy-variable set{p_end}
{p2col:}({mansection R areg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:areg} 
{depvar} 
[{indepvars}] 
{ifin}
[{it:{help areg##weight:weight}}]{cmd:,}
{opth a:bsorb(varname)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth a:bsorb(varname)}}categorical variable to be absorbed{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt ols}, {opt r:obust},
   {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help areg##display_options:display_options}}}control 
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt absorb(varname)} is required.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife},
{cmd:mi estimate},
{cmd:rolling}, and {cmd:statsby} are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp areg_postestimation R:areg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Other >}
      {bf:Linear regression absorbing one cat. variable}


{marker description}{...}
{title:Description}

{pstd}
{cmd:areg} fits a linear regression absorbing one categorical factor.
{cmd:areg} is designed for datasets with many groups, but not a number of
groups that increases with the sample size.  See the {cmd:xtreg, fe} command
in {helpb xtreg:[XT] xtreg} for an estimator that handles the case in which
the number of groups increases with the sample size.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R aregQuickstart:Quick start}

        {mansection R aregRemarksandexamples:Remarks and examples}

        {mansection R aregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opth absorb(varname)} specifies the categorical variable,
which is to be included in the regression as if it were specified by dummy
variables.  {cmd:absorb()} is required.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:ols}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(ols)}, the default, uses the standard variance estimator
for ordinary least-squares regression.

{pmore}Exercise caution when using the {cmd:vce(cluster} {it:clustvar}{cmd:)}
option with {cmd:areg}.  The effective number of degrees of freedom for the
robust variance estimator is n_g - 1, where n_g is the number of clusters.
Thus, the number of levels of the {opt absorb()} variable should not exceed the
number of clusters.

{dlgtab:Reporting}

{phang}{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt areg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.
 

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Regression with fixed effects for {cmd:rep78}{p_end}
{phang2}{cmd:. areg price weight length, absorb(rep78)}{p_end}

{pstd}Same as above, but also compute the bootstrap standard errors{p_end}
{phang2}{cmd:. areg price weight length, absorb(rep78) vce(bootstrap, reps(200))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:areg} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_absorb)}}number of absorbed categories{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(tss)}}total sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(df_a)}}degrees of freedom for absorbed effect{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(F_absorb)}}F statistic for absorbed effect (when
        {cmd:vce(robust)} is not specified){p_end}
{synopt:{cmd:e(p)}}p-value for model F test{p_end}
{synopt:{cmd:e(p_absorb)}}p-value for F test of absorbed effect{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:areg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(absvar)}}name of {cmd:absorb} variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum {p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
