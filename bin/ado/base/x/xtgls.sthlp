{smcl}
{* *! version 1.2.25  13dec2018}{...}
{viewerdialog xtgls "dialog xtgls"}{...}
{vieweralsosee "[XT] xtgls" "mansection XT xtgls"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtgls postestimation" "help xtgls postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] newey" "help newey"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xtpcse" "help xtpcse"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtgls##syntax"}{...}
{viewerjumpto "Menu" "xtgls##menu"}{...}
{viewerjumpto "Description" "xtgls##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtgls##linkspdf"}{...}
{viewerjumpto "Options" "xtgls##options"}{...}
{viewerjumpto "Examples" "xtgls##examples"}{...}
{viewerjumpto "Stored results" "xtgls##results"}{...}
{viewerjumpto "Reference" "xtgls##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtgls} {hline 2}}Fit panel-data models by using GLS{p_end}
{p2col:}({mansection XT xtgls:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:xtgls} {depvar} [{indepvars}] {ifin}
[{it:{help xtgls##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:p:anels:(}{cmdab:i:id)}}use i.i.d. error structure{p_end}
{synopt :{cmdab:p:anels:(}{cmdab:h:eteroskedastic)}}use heteroskedastic but uncorrelated error structure{p_end}
{synopt :{cmdab:p:anels:(}{cmdab:c:orrelated)}}use heteroskedastic and correlated error structure{p_end}
{synopt :{cmdab:c:orr:(}{cmdab:i:ndependent)}}use independent autocorrelation structure{p_end}
{synopt :{cmdab:c:orr:(}{cmdab:a:r1)}}use AR1 autocorrelation structure{p_end}
{synopt :{cmdab:c:orr:(}{cmdab:p:sar1)}}use panel-specific AR1 autocorrelation structure{p_end}
{synopt :{opt rho:type(calc)}}specify method to compute autocorrelation parameter; see {it:{help xtgls##options:Options}} for details; seldom used{p_end}
{synopt :{opt igls}}use iterated GLS estimator instead of two-step GLS estimator{p_end}
{synopt :{opt force}}estimate even if observations unequally spaced in time{p_end}

{syntab:SE}
{synopt :{opt nmk}}normalize standard error by N-k instead of N{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xtgls##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{it:{help xtgls##optimize_options:optimize_options}}}control the optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable must be specified. For correlation structures other than
{cmd:independent}, a time variable must be specified.  A time variable must
also be specified if {cmd:panels(correlated)} is specified.  Use {helpb xtset}.
{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtgls_postestimation XT:xtgls postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Contemporaneous correlation >}
    {bf:GLS regression with correlated disturbances}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtgls} fits panel-data linear models by using feasible
generalized least squares.  This command allows estimation in the presence of
AR(1) autocorrelation within panels and cross-sectional correlation and
heteroskedasticity across panels.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtglsQuickstart:Quick start}

        {mansection XT xtglsRemarksandexamples:Remarks and examples}

        {mansection XT xtglsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt panels(pdist)} specifies the error structure across panels.

{pmore}
{cmd:panels(iid)} specifies a homoskedastic error structure with no
cross-sectional correlation.  This is the default.

{pmore}
{cmd:panels(heteroskedastic)} specifies a heteroskedastic error structure with
no cross-sectional correlation.

{pmore}
{cmd:panels(correlated)} specifies a 
heteroskedastic error structure with cross-sectional correlation.  If
{cmd:p(c)} is specified, you must also specify a time variable (use 
{cmd:xtset}).  The results will be based on a generalized inverse of a
singular matrix unless T>=m (the number of periods is greater than or
equal to the number of panels).

{phang}
{opt corr(corr)} specifies the assumed autocorrelation within panels.

{pmore}
{cmd:corr(independent)} specifies that there is no
autocorrelation.  This is the default.

{pmore}
{cmd:corr(ar1)} specifies that, within panels, there is AR(1) autocorrelation
and that the coefficient of the AR(1) process is common to all the panels.  If
{cmd:c(ar1)} is specified, you must also specify a time variable (use
{cmd:xtset}).

{pmore}
{cmd:corr(psar1)} specifies that, within
panels, there is AR(1) autocorrelation and that the coefficient of the AR(1)
process is specific to each panel.  {opt psar1} stands for panel-specific
AR(1).  If {cmd:c(psar1)} is specified, a time variable must also be specified;
use {cmd:xtset}.

{phang}
{opt rhotype(calc)} specifies the method to be used to calculate the
autocorrelation parameter: 

{p 12 24 2}{opt regress} {space 1} regression using lags; the default{p_end}
{p 12 24 2}{opt dw} {space 6} Durbin-Watson calculation{p_end}
{p 12 24 2}{opt freg} {space 4} regression using leads{p_end}
{p 12 24 2}{opt nagar} {space 3} Nagar calculation{p_end}
{p 12 24 2}{opt theil} {space 3} Theil calculation{p_end}
{p 12 24 2}{opt tscorr} {space 2} time-series autocorrelation calculation

{pmore}
All the calculations are asymptotically equivalent and consistent;
this is a rarely used option.

{phang}
{opt igls} requests an iterated GLS estimator instead of the two-step
GLS estimator for a nonautocorrelated model or instead of the
three-step GLS estimator for an autocorrelated model.  The iterated
GLS estimator converges to the MLE for the {cmd:corr(independent)}
models but does not for the other {opt corr()} models.

{phang}
{marker force}
{opt force} specifies that estimation be forced even though the time variable
is not equally spaced.  This is relevant only for correlation structures
that require knowledge of the time variable.  These correlation structures
require that observations be equally spaced so that calculations based on lags
correspond to a constant time change.  If you specify a time variable
indicating that observations are not equally spaced, the (time dependent)
model will not be fit.  If you also specify {opt force}, the model will be
fit, and it will be assumed that the lags based on the data ordered by the
time variable are appropriate.

{dlgtab:SE}

{phang}
{opt nmk} specifies that standard errors normalized by N-k, where k is
the number of parameters estimated, rather than N, the number of observations.
Different authors have used one or the other normalization.
{help xtgls##G2018:Greene (2018, 313)}
remarks that whether a degree-of-freedom correction improves the 
small-sample properties is an open question.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

{phang}
{marker optimize_options}
{it:optimize_options} control the iterative optimization process.  These options
are seldom used.

{pmore}
{opt iter:ate(#)} specifies the maximum number of iterations.  When the number 
of iterations equals #, the optimization stops and presents the current results,
even if convergence has not been reached.  The default is
{cmd:iterate(100)}.

{pmore}
{opt tol:erance(#)} specifies the tolerance for the coefficient vector.  When 
the relative change in the coefficient vector from one iteration to the next is
less than or equal to #, the optimization process is stopped.  
{cmd:tolerance(1e-7)} is the default.

{pmore}
INCLUDE help lognolog

{pstd}
The following option is available with {opt xtgls} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse invest2}{p_end}
{phang2}{cmd:. xtset company time}{p_end}

{pstd}Fit panel-data model with heteroskedasticity across panels{p_end}
{phang2}{cmd:. xtgls invest market stock, panels(hetero)}{p_end}

{pstd}Correlation and heteroskedasticity across panels{p_end}
{phang2}{cmd:. xtgls invest market stock, panels(correlated)}

{pstd}Heteroskedasticity across panels and autocorrelation within panels{p_end}
{phang2}{cmd:. xtgls invest market stock, panels(hetero) corr(ar1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtgls} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_ic)}}number of observations used to compute information criteria{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(N_t)}}number of periods{p_end}
{synopt:{cmd:e(N_miss)}}number of missing observations{p_end}
{synopt:{cmd:e(n_cf)}}number of estimated coefficients{p_end}
{synopt:{cmd:e(n_cv)}}number of estimated covariances{p_end}
{synopt:{cmd:e(n_cr)}}number of estimated correlations{p_end}
{synopt:{cmd:e(df)}}degrees of freedom{p_end}
{synopt:{cmd:e(df_pear)}}degrees of freedom for Pearson chi-squared{p_end}
{synopt:{cmd:e(df_ic)}}degrees of freedom for information criteria{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtgls}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(coefftype)}}estimation scheme{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(vt)}}panel option{p_end}
{synopt:{cmd:e(rhotype)}}type of estimated correlation{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker G2018}{...}
{phang}
Greene, W. H. 2018.
{browse "http://www.stata.com/bookstore/ea.html":{it:Econometric Analysis}. 8th ed.}
New York: Pearson.
{p_end}
