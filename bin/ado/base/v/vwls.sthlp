{smcl}
{* *! version 1.1.23  14may2018}{...}
{viewerdialog vwls "dialog vwls"}{...}
{vieweralsosee "[R] vwls" "mansection R vwls"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] vwls postestimation" "help vwls postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "vwls##syntax"}{...}
{viewerjumpto "Menu" "vwls##menu"}{...}
{viewerjumpto "Description" "vwls##description"}{...}
{viewerjumpto "Links to PDF documentation" "vwls##linkspdf"}{...}
{viewerjumpto "Options" "vwls##options"}{...}
{viewerjumpto "Examples" "vwls##examples"}{...}
{viewerjumpto "Stored results" "vwls##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] vwls} {hline 2}}Variance-weighted least squares{p_end}
{p2col:}({mansection R vwls:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:vwls} {depvar} {indepvars} {ifin} 
[{it:{help vwls##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 17 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth sd(varname)}}variable containing estimate of conditional
standard deviation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help vwls##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp vwls_postestimation R:vwls postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Other >}
         {bf:Variance-weighted least squares}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vwls} estimates a linear regression using variance-weighted least
squares.  It differs from ordinary least-squares (OLS) regression in that it
does not assume homogeneity of variance, but requires that the conditional
variance of {depvar} be estimated prior to the regression.  The estimated
variance need not be constant across observations.  {cmd:vwls} treats the
estimated variance as if it were the true variance when it computes standard
errors of the coefficients.

{pstd}
You must supply an estimate of the conditional standard deviation of {it:depvar}
to {cmd:vwls} by using the {opth sd(varname)} option, or you must have grouped
data with groups defined by the {indepvars} variables.  In the latter case,
{cmd:vwls} treats all {it:indepvars} as categorical variables, computes the
mean and standard deviation of {it:depvar} separately for each subgroup, and 
computes the regression of the subgroup means on {it:indepvars}. 

{pstd}
{cmd:regress} with analytic weights can be used to produce another kind of
"variance-weighted least squares"; see 
{mansection R vwlsRemarksandexamples:{it:Remarks and examples}} in
{bf:[R] vwls} for an explanation of the difference.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R vwlsQuickstart:Quick start}

        {mansection R vwlsRemarksandexamples:Remarks and examples}

        {mansection R vwlsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}. 

{phang}
{opth sd(varname)} is an estimate of the conditional standard deviation
of {depvar} (that is, it can vary observation by observation).  All values of
{it:varname} must be > 0.  If you specify {opt sd()}, you cannot use
{cmd:fweight}s.

{pmore}
If {opt sd()} is not given, the data will be grouped by {indepvars}.  Here 
{it:indepvars} are treated as categorical variables, and the means and
standard deviations of {it:depvar} for each subgroup are calculated and used
for the regression.  Any subgroup for which the standard deviation is zero is
dropped.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}. 

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt vwls} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bp}{p_end}

{pstd}Fit variance-weighted least-squares linear regression{p_end}
{phang2}{cmd:. vwls bp gender race}

{pstd}Replay results, showing coefficients, standard errors, and CIs with
4 decimal places{p_end}
{phang2}{cmd:. vwls, cformat(%8.4f)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vwls} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}model chi-squared{p_end}
{synopt:{cmd:e(df_gf)}}goodness-of-fit degrees of freedom{p_end}
{synopt:{cmd:e(chi2_gf)}}goodness-of-fit chi-squared{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:vwls}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
