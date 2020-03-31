{smcl}
{* *! version 1.2.6  19dec2018}{...}
{viewerdialog xtdpd "dialog xtdpd"}{...}
{vieweralsosee "[XT] xtdpd" "mansection XT xtdpd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdpd postestimation" "help xtdpd postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[XT] xtabond" "help xtabond"}{...}
{vieweralsosee "[XT] xtdpdsys" "help xtdpdsys"}{...}
{vieweralsosee "[XT] xtivreg" "help xtivreg"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtdpd##syntax"}{...}
{viewerjumpto "Menu" "xtdpd##menu"}{...}
{viewerjumpto "Description" "xtdpd##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtdpd##linkspdf"}{...}
{viewerjumpto "Options" "xtdpd##options"}{...}
{viewerjumpto "Examples" "xtdpd##examples"}{...}
{viewerjumpto "Stored results" "xtdpd##results"}{...}
{viewerjumpto "Reference" "xtdpd##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtdpd} {hline 2}}Linear dynamic panel-data estimation{p_end}
{p2col:}({mansection XT xtdpd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:xtdpd} {depvar} [{indepvars}] {ifin}
      {cmd:,} {cmdab:dg:mmiv(}{varlist} [...]{cmd:)} [{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt dg:mmiv}{cmd:(}{varlist}[{it:...}]{cmd:)}}GMM-type instruments
for the difference equation; can be specified more than once{p_end}
{synopt :{opt lg:mmiv}{cmd:(}{varlist}[{it:...}]{cmd:)}}GMM-type instruments for
the level equation; can be specified more than once{p_end}
{synopt :{cmd:iv(}{varlist}[{it:...}]{cmd:)}}standard instruments for
the difference and level equations; can be specified more than once{p_end}
{synopt :{cmd:div(}{varlist}[{it:...}]{cmd:)}}standard instruments for
the difference equation only; can be specified more than once{p_end}
{synopt :{cmd:liv(}{varlist}{cmd:)}}standard instruments for
the level equation only; can be specified more than once{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt two:step}}compute the two-step estimator instead of the one-step estimator{p_end}
{synopt :{opt h:ascons}}check for collinearity only among levels
of independent variables; by default checks occur among levels and
differences{p_end}
{synopt :{opt fod:eviation}}use forward-orthogonal deviations 
       instead of first differences{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt gmm} or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ar:tests(#)}}use {it:#} as maximum order for AR tests; default is {cmd:artests(2)}{p_end}
{synopt :{it:{help xtdpd##display_options:display_options}}}control spacing
        and line width{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:dgmmiv()} is required.{p_end}
{p 4 6 2}
A panel variable and a time variable must be specified; use {cmd:xtset};
see {manhelp xtset XT}.
{p_end}
{p 4 6 2}
{it:depvar}, {it:indepvars}, and all {it:varlists} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt statsby}, and {opt xi} are allowed; see {help prefix}.
{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {helpb xtdpd postestimation:[XT] xtdpd postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Dynamic panel data (DPD) >}
    {bf:Linear DPD estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtdpd} fits a linear dynamic panel-data model where the unobserved
panel-level effects are correlated with the lags of the dependent variable.
The command can fit Arellano-Bond and Arellano-Bover/Blundell-Bond models like
those fit by {helpb xtabond} and {helpb xtdpdsys}.  However, it also allows
models with low-order moving-average correlation in the idiosyncratic errors
or predetermined variables with a more complicated structure than allowed for
{cmd:xtabond} or {cmd:xtdpdsys}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtdpdQuickstart:Quick start}

        {mansection XT xtdpdRemarksandexamples:Remarks and examples}

        {mansection XT xtdpdMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:dgmmiv(}{varlist} [{cmd:,} {opt l:agrange}{cmd:(}{it:flag}
[{it:llag}]{cmd:)}]{cmd:)} specifies GMM-type instruments for the
difference equation.  Levels of the variables are used to form GMM-type
instruments for the difference equation.  All possible lags are used,
unless {opt lagrange}{cmd:(}{it:flag} {it:llag}{cmd:)} restricts the lags to
begin with {it:flag} and end with {it:llag}.  You may specify as many sets
of GMM-type instruments for the difference equation as you need within the
standard Stata limits on matrix size.  Each set may have its own {it:flag}
and {it:llag}.  {cmd:dgmmiv()} is required. 

{phang}
{cmd:lgmmiv(}{varlist} [{cmd:,} {opt l:ag}{cmd:(}{it:#}{cmd:)}]{cmd:)}
specifies GMM-type instruments for the level equation.  Differences of the
variables are used to form GMM-type instruments for the level equation.
The first lag of the differences is used unless 
{opt lag}{cmd:(}{it:#}{cmd:)} is specified, indicating that {it:#}th lag of
the differences be used.  You may specify as many sets of GMM-type
instruments for the level equation as you need within the standard Stata
limits on matrix size.  Each set may have its own {it:lag}.

{phang}
{cmd:iv(}{varlist} [{cmd:,} {opt nodi:fference}]{cmd:)} specifies standard
instruments for both the difference and level equations.  Differences of
the variables are used as instruments for the difference equation, unless
{opt nodifference} is specified, which requests that levels be used.  Levels
of the variables are used as instruments for the level equation.  You may
specify as many sets of standard instruments for both the difference and
level equations as you need within the standard Stata limits on matrix size.

{phang}
{cmd:div(}{varlist} [{cmd:,} {opt nodi:fference}]{cmd:)} specifies
additional standard instruments for the difference equation.  Specified
variables may not be included in {opt iv()} or in {opt liv()}.  Differences of
the variables are used, unless {opt nodifference} is specified, which requests
that levels of the variables be used as instruments for the
difference equation.  You may specify as many additional sets of standard
instruments for the difference equation as you need within the standard Stata
limits on matrix size.

{phang}
{cmd:liv(}{varlist}{cmd:)} specifies additional standard instruments
for the level equation.  Specified variables may not be included in {opt iv()}
or in {opt div()}.  Levels of the variables are used as instruments for the
level equation.  You may specify as many additional sets of standard
instruments for the level equation as you need within the standard Stata
limits on matrix size.

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt twostep} specifies that the two-step estimator be calculated.

{phang}
{opt hascons} specifies that {cmd:xtdpd} check for collinearity only among
levels of independent variables; by default checks occur among levels and
differences.

{phang}
{opt fodeviation} specifies that forward-orthogonal deviations be
used instead of first differences.  {cmd:fodeviation} is not allowed when
there are gaps in the data or when {cmd:lgmmiv()} is specified.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory and that are robust
to some kinds of misspecification; see
{mansection XT xtdpdMethodsandformulas:{it:Methods and formulas}} in
{bf:[XT] xtdpd}. 

{pmore}
{cmd:vce(gmm)}, the default, uses the conventionally derived variance
estimator for generalized method of moments estimation.

{pmore}
{cmd:vce(robust)} uses the robust estimator.  For the one-step estimator,
this is the Arellano-Bond robust VCE estimator.  For the two-step estimator,
this is the {help xtdpd##W2005:Windmeijer (2005)} WC-robust estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt artests(#)} specifies the maximum order of the autocorrelation test to
be calculated.  The tests are reported by {cmd:estat} {cmd:abond};
see {helpb xtdpd postestimation:[XT] xtdpd postestimation}.  Specifying the
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
The following option is available with {opt xtdpd} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse abdata}{p_end}

{pstd}Arellano-Bond estimator with two lags of dependent variable included 
as regressors and strictly exogenous covariates{p_end}
{phang2}{cmd:. xtdpd l(0/2).n l(0/1).(w ys) k, dgmmiv(n) div(l(0/1).(w ys) k)}{p_end}
{phang2}{cmd:. xtdpd l(0/2).n l(0/1).(w ys) k year yr1980-yr1984, dgmmiv(n) div(l(0/1).(w ys) k year)  div(yr1980-yr1984) nocons hascons}{p_end}

{pstd}Arellano-Bond estimator with two lags of dependent variable included 
as regressors, strictly exogenous covariates and robust VCE{p_end}
{phang2}{cmd:. xtdpd l(0/2).n l(0/1).(w ys) k year yr1980-yr1984, dgmmiv(n) div(l(0/1).(w ys) k year)  div(yr1980-yr1984) nocons hascons twostep vce(robust)}{p_end}

{pstd}Arellano-Bover/Blundell-Bond system estimator with two lags of 
dependent variable included as regressors and strictly exogenous covariates{p_end}
{phang2}{cmd:. xtdpd l(0/2).n l(0/1).(w ys) k, dgmmiv(n) lgmmiv(n) div(l(0/1).(w ys) k )}{p_end}

{pstd}Arellano-Bond estimator with two lags of dependent variable included 
as regressors, endogenous covariates and a robust VCE{p_end}
{phang2}{cmd:. xtdpd L(0/1).(n w k) year yr1979-yr1984, dgmmiv(n w k) div(year yr1979-yr1984) nocons hascons vce(robust)}{p_end}

{pstd}Arellano-Bover/Blundell-Bond system estimator with two lags of 
dependent variable included as regressors, endogenous covariates and a robust
VCE{p_end}
{phang2}{cmd:. xtdpd L(0/1).(n w k) year yr1979-yr1984, dgmmiv(n w k) lgmmiv(n w k) div(year yr1979-yr1984) nocons hascons vce(robust)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtdpd} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(arm}{it:#}{cmd:)}}test for autocorrelation of order {it:#}{p_end}
{synopt:{cmd:e(artests)}}number of AR tests computed{p_end}
{synopt:{cmd:e(sig2)}}estimate of sigma_epsilon^2{p_end}
{synopt:{cmd:e(rss)}}sum of squared differenced residuals{p_end}
{synopt:{cmd:e(sargan)}}Sargan test statistic{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(zrank)}}rank of instrument matrix{p_end}

{synoptset 19 tabbed}{...}
{p2col 5 19 23 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtdpd}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(twostep)}}{cmd:twostep}, if specified{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(system)}}{cmd:system}, if system estimator{p_end}
{synopt:{cmd:e(hascons)}}{cmd:hascons}, if specified{p_end}
{synopt:{cmd:e(transform)}}specified transform{p_end}
{synopt:{cmd:e(diffvars)}}already differenced variables{p_end}
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


{marker reference}{...}
{title:Reference}

{marker W2005}{...}
{phang}
Windmeijer, F. 2005. A finite sample correction for the variance of linear
efficient two-step GMM estimators. {it:Journal of Econometrics} 126: 25-51.
{p_end}
