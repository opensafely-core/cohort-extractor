{smcl}
{* *! version 1.3.7  14may2018}{...}
{viewerdialog mvreg "dialog mvreg"}{...}
{vieweralsosee "[MV] mvreg" "mansection MV mvreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mvreg postestimation" "help mvreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: mvreg" "help bayes mvreg"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] regress postestimation" "help regress_postestimation"}{...}
{vieweralsosee "[R] sureg" "help sureg"}{...}
{viewerjumpto "Syntax" "mvreg##syntax"}{...}
{viewerjumpto "Menu" "mvreg##menu"}{...}
{viewerjumpto "Description" "mvreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "mvreg##linkspdf"}{...}
{viewerjumpto "Options" "mvreg##options"}{...}
{viewerjumpto "Examples" "mvreg##examples"}{...}
{viewerjumpto "Stored results" "mvreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[MV] mvreg} {hline 2}}Multivariate regression{p_end}
{p2col:}({mansection MV mvreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mvreg} {it:{help varlist:depvars}} {cmd:=} {indepvars} {ifin}
[{it:{help mvreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt cor:r}}report correlation matrix{p_end}
{synopt :{it:{help mvreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{synopt:{opt noh:eader}}suppress header table from above coefficient table{p_end}
{synopt:{opt not:able}}suppress coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvars} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt jackknife}, {opt mi estimate},
{opt rolling}, and {opt statsby} are allowed; see {help prefix}.
For more details, see {manhelp bayes_mvreg BAYES:bayes: mvreg}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}{opt noheader}, {opt notable}, and {opt coeflegend} do not appear 
in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mvreg_postestimation MV:mvreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > MANOVA, multivariate regression,}
     {bf:and related > Multivariate regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvreg} fits a multivariate regression model for several dependent
variables with the same independent variables.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mvregQuickstart:Quick start}

        {mansection MV mvregRemarksandexamples:Remarks and examples}

        {mansection MV mvregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant term (intercept) in the model.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{phang}
{opt corr} displays the correlation matrix of the residuals between
equations.

INCLUDE help displayopts_list

{pstd}
The following options are available with {cmd:mvreg} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses display of the table reporting F statistics,
R-squared, and root mean squared error above the coefficient table.

{phang}
{opt notable} suppresses display of the coefficient table.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit multivariate regression model{p_end}
{phang2}{cmd:. mvreg headroom trunk turn = price mpg displ gear_ratio length weight}{p_end}

{pstd}Replay results, suppressing header and coefficient tables but 
reporting correlation matrix{p_end}
{phang2}{cmd:. mvreg, notable noheader corr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mvreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters in each equation{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}Breusch-Pagan chi-squared ({cmd:corr} only){p_end}
{synopt:{cmd:e(df_chi2)}}degrees of freedom for Breusch-Pagan chi-squared
	({cmd:corr} only){p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mvreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(r2)}}R-squared for each equation{p_end}
{synopt:{cmd:e(rmse)}}RMSE for each equation{p_end}
{synopt:{cmd:e(F)}}F statistic for each equation{p_end}
{synopt:{cmd:e(p_F)}}p-value for F test for each equation{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
