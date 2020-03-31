{smcl}
{* *! version 1.1.24  12dec2018}{...}
{viewerdialog prais "dialog prais"}{...}
{vieweralsosee "[TS] prais" "mansection TS prais"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] prais postestimation" "help prais postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] mswitch" "help mswitch"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] regress postestimation time series" "help regress_postestimation_ts"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "prais##syntax"}{...}
{viewerjumpto "Menu" "prais##menu"}{...}
{viewerjumpto "Description" "prais##description"}{...}
{viewerjumpto "Links to PDF documentation" "prais##linkspdf"}{...}
{viewerjumpto "Options" "prais##options"}{...}
{viewerjumpto "Examples" "prais##examples"}{...}
{viewerjumpto "Stored results" "prais##results"}{...}
{viewerjumpto "References" "prais##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] prais} {hline 2}}Prais-Winsten and Cochrane-Orcutt regression{p_end}
{p2col:}({mansection TS prais:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:prais}
{depvar}
[{indepvars}]
{ifin}
[{cmd:,}
{it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{cmdab:rho:type:(}{opt reg:ress}{cmd:)}}base rho on single-lag OLS of
residuals; the default{p_end}
{synopt:{cmdab:rho:type:(freg)}}base rho on single-lead OLS of residuals{p_end}
{synopt:{cmdab:rho:type:(}{opt tsc:orr}{cmd:)}}base rho on autocorrelation of
residuals{p_end}
{synopt:{cmdab:rho:type:(dw)}}base rho on autocorrelation based on
Durbin-Watson {p_end}
{synopt:{cmdab:rho:type:(}{opt th:eil}{cmd:)}}base rho on adjusted
autocorrelation{p_end}
{synopt:{cmdab:rho:type:(}{opt nag:ar}{cmd:)}}base rho on adjusted
Durbin-Watson{p_end}
{synopt:{opt corc}}use Cochrane-Orcutt transformation{p_end}
{synopt:{opt sse:search}}search for rho that minimizes SSE{p_end}
{synopt:{opt two:step}}stop after the first iteration{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt h:ascons}}has user-defined constant{p_end}
{synopt:{opt save:space}}conserve memory during estimation{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt ols}, {opt r:obust},
       {opt cl:uster} {it:clustvar}, {opt hc2}, or {opt hc3}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt nodw}}do not report the Durbin-Watson statistic{p_end}
{synopt :{it:{help prais##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt:{it:{help prais##optimize_options:optimize_options}}}control the
optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt prais}; see
{helpb tsset:[TS] tsset}.
{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.
{p_end}
{p 4 6 2}
{opt by}, {opt fp}, {opt rolling}, and {opt statsby} are allowed; see
{help prefix}.
{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp prais_postestimation TS:prais postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Prais-Winsten regression}


{marker description}{...}
{title:Description}

{pstd}
{opt prais} uses the generalized least-squares method to estimate the
parameters in a linear regression model in which the errors are serially
correlated.  Specifically, the errors are assumed to follow a first-order
autoregressive process.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS praisQuickstart:Quick start}

        {mansection TS praisRemarksandexamples:Remarks and examples}

        {mansection TS praisMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt rhotype(rhomethod)} selects a specific computation for
the autocorrelation parameter rho, where {it:rhomethod} can be

{p 12 34 2}{cmdab:reg:ress}{space 2}rho_reg {space 2} = B from the residual
        regression e_t = B * e_(t-1){p_end}
{p 12 34 2}{cmd:freg} {space 3} rho_freg {space 1} = B from the residual
        regression e_t = B * e_(t+1){p_end}
{p 12 34 2}{cmdab:tsc:orr} {space 1} rho_tscorr = e'e_(t-1)/e'e, where e is the
        vector of residuals{p_end}
{p 12 34 2}{cmd:dw} {space 5} rho_dw {space 3} = 1 - dw/2, where dw is the
        Durbin-Watson d statistic{p_end}
{p 12 34 2}{cmdab:th:eil} {space 2} rho_theil{space 2}= rho_tscorr * (N - k)/N{p_end}
{p 12 34 2}{cmdab:nag:ar} {space 2} rho_nagar{space 2}= (rho_dw * N^2 + k^2)/(N^2 - k^2)

{pmore}
   The {opt prais} estimator can use any consistent estimate of rho to
   transform the equation, and each of these estimates meets that requirement.
   The default is {opt regress}, which produces the minimum sum-of-squares
   solution ({opt ssesearch} option) for the Cochrane-Orcutt
   transformation -- none of these computations will produce the minimum
   sum-of-square solution for the full Prais-Winsten transformation.
   See {help prais##J1985:Judge et al. (1985)} for a discussion of each
   estimate of rho.

{phang}
{opt corc} specifies that the Cochrane-Orcutt transformation be used to
   estimate the equation.  With this option, the Prais-Winsten transformation
   of the first observation is not performed, and the first observation is
   dropped when estimating the transformed equation; see
   {mansection TS praisMethodsandformulas:{it:Methods and formulas}} in
   {bf:[TS] prais}.

{phang}
{opt ssesearch} specifies that a search be performed for the value of
   rho that minimizes the sum-of-squared errors of the transformed equation
   (Cochrane-Orcutt or Prais-Winsten transformation).  The search method is a
   combination of quadratic and modified bisection searches using golden
   sections.

{phang}
{opt twostep} specifies that {opt prais} stop on the first iteration after the
equation is transformed by rho -- the two-step efficient estimator.
Although iterating these estimators to convergence is customary, they are
efficient at each step.

{phang}
{opt noconstant}; see
{bf:{help estimation options##noconstant:[R] Estimation options}}.

{phang}
{opt hascons} indicates that a user-defined constant, or a set of
   variables that in linear combination forms a constant, has been included in
   the regression.  For some computational concerns, see the discussion in
   {helpb regress:[R] regress}.

{phang}
{opt savespace} specifies that {opt prais} attempt to save as much
   space as possible by retaining only those variables required for
   estimation.  The original data are restored after estimation.  This option
   is rarely used and should be used only if there is insufficient space to
   fit a model without the option.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the estimator for the variance-covariance matrix
of the estimator; see {helpb vce_options:[R] {it:vce_options}}.

{phang2}
{cmd:vce(ols)}, the default, uses the standard variance estimator for ordinary
least-squares regression.

{phang2}
{cmd:vce(robust)} specifies to use the Huber/White/sandwich estimator.

{phang2}
{cmd:vce(cluster} {it:clustvar}{cmd:)} specifies to use the intragroup
correlation estimator.

{phang2}
{cmd:vce(hc2)} and {cmd:vce(hc3)} specify an alternative bias correction for
the {cmd:vce(robust)} variance calculation; for more information, see
{helpb regress:[R] regress}.  You may specify only one of {cmd:vce(hc2)},
{cmd:vce(hc3)}, or {cmd:vce(robust)}.

{pmore}
   All estimates from {opt prais} are conditional on the estimated
   value of rho.  Robust variance estimates here are
   robust only to heteroskedasticity and are not generally robust to
   misspecification of the functional form or omitted variables.  The
   estimation of the functional form is intertwined with the estimation of
   rho, and all estimates are conditional on rho. Thus estimates cannot be
   robust to misspecification of functional form.  For these reasons, it is
   probably best to interpret {cmd:vce(robust)} in the spirit of White's
   {help prais##W1980:(1980)} original paper on estimation of
   heteroskedastic-consistent covariance matrices.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt nodw} suppresses reporting of the Durbin-Watson statistic.

INCLUDE help displayopts_list

{marker optimize_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimize_options}:
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tol:erance(#)}.
{opt iterate()} specifies the maximum number of iterations.
{opt log}/{opt nolog} specifies whether to show the iteration log
(see {cmd:set iterlog} in {manhelpi set_iter R:set iter}).
{opt tolerance()} specifies the tolerance for the coefficient vector;
{cmd:tolerance(1e-6)} is the default.  These options are seldom used.

{pstd}
The following option is available with {opt prais} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse idle}{p_end}
{phang2}{cmd:. tsset t}{p_end}

{pstd}Perform Prais-Winsten AR(1) regression{p_end}
{phang2}{cmd:. prais usr idle}

{pstd}Perform Cochrane-Orcutt AR(1) regression{p_end}
{phang2}{cmd:. prais usr idle, corc}

{pstd}Same as above, but request robust standard errors{p_end}
{phang2}{cmd:. prais usr idle, corc vce(robust)}

    {hline}
    Setup
{phang2}{cmd:. webuse qsales}

{pstd}Perform Cochrane-Orcutt AR(1) regression and search for rho that
minimizes SSE{p_end}
{phang2}{cmd:. prais csales isales, corc ssesearch}

{pstd}Replay result with 99% confidence interval{p_end}
{phang2}{cmd:. prais, level(99)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:prais} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rho)}}autocorrelation parameter rho{p_end}
{synopt:{cmd:e(dw)}}Durbin-Watson d statistic for transformed regression{p_end}
{synopt:{cmd:e(dw_0)}}Durbin-Watson d statistic for untransformed regression{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(tol)}}target tolerance{p_end}
{synopt:{cmd:e(max_ic)}}maximum number of iterations{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:prais}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant} or not reported{p_end}
{synopt:{cmd:e(method)}}{cmd:twostep}, {cmd:iterated}, or {cmd:SSE search}{p_end}
{synopt:{cmd:e(tranmeth)}}{cmd:corc} or {cmd:prais}{p_end}
{synopt:{cmd:e(rhotype)}}method specified in {cmd:rhotype()} option{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker J1985}{...}
{phang}
Judge, G. G., W. E. Griffiths, R. C. Hill, H. L{c u:}tkepohl, and T.-C. Lee.
1985. {it:The Theory and Practice of Econometrics}. 2nd ed. New York: Wiley.

{marker W1980}{...}
{phang}
White, H. 1980. A heteroskedasticity-consistent covariance matrix estimator and
a direct test for heteroskedasticity. {it:Econometrica} 48: 817-838.
{p_end}
