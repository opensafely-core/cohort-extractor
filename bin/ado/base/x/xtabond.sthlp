{smcl}
{* *! version 1.3.6  19sep2018}{...}
{viewerdialog xtabond "dialog xtabond"}{...}
{vieweralsosee "[XT] xtabond" "mansection XT xtabond"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtabond postestimation" "help xtabond postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdpd" "help xtdpd"}{...}
{vieweralsosee "[XT] xtdpdsys" "help xtdpdsys"}{...}
{vieweralsosee "[XT] xtivreg" "help xtivreg"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtabond##syntax"}{...}
{viewerjumpto "Menu" "xtabond##menu"}{...}
{viewerjumpto "Description" "xtabond##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtabond##linkspdf"}{...}
{viewerjumpto "Options" "xtabond##options"}{...}
{viewerjumpto "Examples" "xtabond##examples"}{...}
{viewerjumpto "Stored results" "xtabond##results"}{...}
{viewerjumpto "References" "xtabond##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[XT] xtabond} {hline 2}}Arellano-Bond linear dynamic panel-data estimation{p_end}
{p2col:}({mansection XT xtabond:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:xtabond} {depvar} [{indepvars}] {ifin} [{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth diff:vars(varlist)}}already-differenced exogenous variables{p_end}
{synopt :{opth inst(varlist)}}additional instrument variables{p_end}
{synopt :{opt la:gs(#)}}use {it:#} lags of dependent variable as covariates; default is {cmd:lags(1)}{p_end}
{synopt :{opt maxld:ep(#)}}maximum lags of dependent variable for use as instruments{p_end}
{synopt :{opt maxlag:s(#)}}maximum lags of predetermined and endogenous variables for use as instruments{p_end}
{synopt :{opt two:step}}compute the two-step estimator instead of the one-step estimator{p_end}

{syntab:Predetermined}
{synopt :{cmd:pre(}{varlist}[{it:...}]{cmd:)}}predetermined variables; can be specified more than once{p_end}

{syntab:Endogenous}
{synopt :{cmdab:end:ogenous(}{varlist}[{it:...}]{cmd:)}}endogenous variables; can be specified more than once{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt gmm} or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ar:tests(#)}}use {it:#} as maximum order for AR tests; default is {cmd:artests(2)}{p_end}
{synopt :{it:{help xtabond##display_options:display_options}}}control spacing
       and line width{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable and a time variable must be specified; use {cmd:xtset}; see
{manhelp xtset XT}.
{p_end}
{p 4 6 2}
{it:indepvars} and all {it:varlists}, except
{cmd:pre(}{it:varlist}[{it:...}]{cmd:)} and
{cmd:endogenous(}{it:varlist}[{it:...}]{cmd:)}, may contain time-series
operators; see
{help tsvarlist}.  The specification of {it:depvar} may not contain time-series
operators.{p_end}
{p 4 6 2}
{opt by}, {opt statsby}, and {cmd:xi} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtabond_postestimation XT:xtabond postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Dynamic panel data (DPD) >}
     {bf:Arellano-Bond estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtabond} fits a linear dynamic panel-data model where the unobserved
panel-level effects are correlated with the lags of the dependent variable,
known as the Arellano-Bond estimator.  This estimator is designed for
datasets with many panels and few periods, and it requires that there be no
autocorrelation in the idiosyncratic errors.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtabondQuickstart:Quick start}

        {mansection XT xtabondRemarksandexamples:Remarks and examples}

        {mansection XT xtabondMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant};
see {helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opth diffvars(varlist)} specifies a set of variables that already have been
differenced to be included as strictly exogenous covariates.
{opt diffvars()} may not be used for models with a constant or models for
which level-equation instruments are specified.

{phang}
{opth inst(varlist)} specifies a set of variables to be used as additional
instruments.  These instruments are not differenced by {cmd:xtabond} before
including them in the instrument matrix.

{phang}
{opt lags(#)} sets p, the number of lags of the dependent variable to be
included in the model.  The default is p=1.

{phang}
{opt maxldep(#)} sets the maximum number of lags of the dependent variable
that can be used as instruments.  The default is to use all T_i-p-2 lags.

{phang}
{opt maxlags(#)} sets the maximum number of lags of the predetermined
and endogenous variables that can be used as instruments.  
For predetermined variables, the default is to use all T_i-p-1 lags.
For endogenous variables, the default is to use all T_i-p-2 lags.

{phang}
{opt twostep} specifies that the two-step estimator be calculated.

{dlgtab:Predetermined}

{marker options}{...}
{phang}
{cmd:pre(}{varlist} [{cmd:,} {opt lag:struct(prelags, premaxlags)}]{cmd:)}
specifies that a set of predetermined variables be included in the model.
Optionally, one may specify that {it:prelags} lags of the specified
variables also be included.  The default for {it:prelags} is 0.  Specifying
{it:premaxlags} sets the maximum number of further lags of the predetermined
variables that can be used as instruments.  The default is to include
T_i-p-1 lagged levels as instruments for predetermined variables.  You may
specify as many sets of predetermined variables as you need within the
standard Stata limits on matrix size.  Each set of predetermined variables
may have its own number of {it:prelags} and {it:premaxlags}.

{dlgtab:Endogenous}

{marker options}{...}
{phang}
{cmdab:end:ogenous(}{varlist} [{cmd:,} 
{opt lag:struct(endlags, endmaxlags)}]{cmd:)} specifies that a set of
endogenous variables be included in the model.  Optionally, one may
specify that {it:endlags} lags of the specified variables also be included.
The default for {it:endlags} is 0.  Specifying {it:endmaxlags} sets the
maximum number of further lags of the endogenous variables that can be used
as instruments.  The default is to include T_i-p-2 lagged levels as
instruments for endogenous variables.  You may specify as many sets of
endogenous variables as you need within the standard Stata limits on matrix
size.  Each set of endogenous variables may have its own number of
{it:endlags} and {it:endmaxlags}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory and that are robust
to some kinds of misspecification; see
{mansection XT xtabondRemarksandexamples:{it:Remarks and examples}} in
{bf:[XT] xtabond}.

{pmore}
{cmd:vce(gmm)}, the default, uses the conventionally derived variance
estimator for generalized method of moments estimation.

{pmore}
{cmd:vce(robust)} uses the robust estimator.  After one-step estimation,
this is the Arellano-Bond robust VCE estimator.  After two-step estimation,
this is the {help xtabond##W2005:Windmeijer (2005)} WC-robust estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt artests(#)} specifies the maximum order of the autocorrelation test to
be calculated.  The tests are reported by {cmd:estat} {cmd:abond};
see {helpb xtabond postestimation:[XT] xtabond postestimation}.  Specifying the
order of the highest test at estimation time is more efficient than
specifying it to {cmd:estat} {cmd:abond}, because {cmd:estat} {cmd:abond}
must refit the model to obtain the test statistics.  The maximum order must
be less than or equal to the number of periods in the longest panel.
The default is {cmd:artests(2)}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish} and {opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following option is available with {opt xtabond} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse abdata}{p_end}

{pstd}Basic model with two lags of dependent variable included as regressors
{p_end}
{phang2}{cmd:. xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984, lags(2)}{p_end}
{phang2}{cmd:. xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984, lags(2)}
              {cmd:vce(robust)}{p_end}
{phang2}{cmd:. xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984, lags(2) twostep}
{p_end}

{pstd}Treat {cmd:w} and {cmd:k} as predetermined and include
{cmd:w}, {cmd:L.w}, {cmd:k}, {cmd:L.k}, and {cmd:L2.k} as additional
regressors{p_end}
{phang2}{cmd:. xtabond n l(0/2).ys yr1980-yr1984, lags(2)}
{cmd:pre(w, lag(1,.)) pre(k, lag(2,.))}{p_end}

{pstd}Treat {cmd:L.w} and {cmd:L2.k} as endogenous and include
{cmd:w}, {cmd:L.w}, {cmd:k}, {cmd:L.k}, and {cmd:L2.k} as additional
regressors{p_end}
{phang2}{cmd:. xtabond n l(0/2).ys yr1980-yr1984, lags(2)}
              {cmd:endogenous(w, lag(1,.)) endogenous(k, lag(2,.))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtabond} stores the following in {cmd:e()}:

{synoptset 19 tabbed}{...}
{p2col 5 19 23 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(t_min)}}minimum time in sample{p_end}
{synopt:{cmd:e(t_max)}}maximum time in sample{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(arm}{it:#}{cmd:)}}test for autocorrelation of order #{p_end}
{synopt:{cmd:e(artests)}}number of AR tests computed{p_end}
{synopt:{cmd:e(sig2)}}estimate of sigma_epsilon^2{p_end}
{synopt:{cmd:e(rss)}}sum of squared differenced residuals{p_end}
{synopt:{cmd:e(sargan)}}Sargan test statistic{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(zrank)}}rank of instrument matrix{p_end}

{synoptset 19 tabbed}{...}
{p2col 5 19 23 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtabond}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(twostep)}}{cmd:twostep}, if specified{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(system)}}{cmd:system}, if system estimator{p_end}
{synopt:{cmd:e(transform)}}specified transform{p_end}
{synopt:{cmd:e(diffvars)}}already-differenced exogenous variables{p_end}
{synopt:{cmd:e(datasignature)}}checksum from {cmd:datasignature}{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}

{synoptset 19 tabbed}{...}
{p2col 5 19 23 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 19 tabbed}{...}
{p2col 5 19 23 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker AB1991}{...}
{phang}
Arellano, M., and S. Bond. 1991.
Some tests of specification for panel data: Monte Carlo evidence and an
application to employment equations.
{it:Review of Economic Studies} 58: 277-297.

{marker W2005}{...}
{phang}
Windmeijer, F. 2005. A finite sample correction for the variance of linear
efficient two-step GMM estimators. {it:Journal of Econometrics} 126: 25-51.
{p_end}
