{smcl}
{* *! version 1.2.1  19sep2018}{...}
{viewerdialog xtpcse "dialog xtpcse"}{...}
{vieweralsosee "[XT] xtpcse" "mansection XT xtpcse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtpcse postestimation" "help xtpcse postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] newey" "help newey"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xtgls" "help xtgls"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtpcse##syntax"}{...}
{viewerjumpto "Menu" "xtpcse##menu"}{...}
{viewerjumpto "Description" "xtpcse##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtpcse##linkspdf"}{...}
{viewerjumpto "Options" "xtpcse##options"}{...}
{viewerjumpto "Examples" "xtpcse##examples"}{...}
{viewerjumpto "Stored results" "xtpcse##results"}{...}
{viewerjumpto "Reference" "xtpcse##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[XT] xtpcse} {hline 2}}Linear regression with panel-corrected standard errors{p_end}
{p2col:}({mansection XT xtpcse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:xtpcse} {depvar} [{indepvars}] {ifin}
[{it:{help xtpcse##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt c:orrelation}{cmd:({ul:i}ndependent)}}use independent autocorrelation structure{p_end}
{synopt :{opt c:orrelation}{cmd:({ul:a}r1)}}use AR1 autocorrelation structure{p_end}
{synopt :{opt c:orrelation}{cmd:({ul:p}sar1)}}use panel-specific AR1 autocorrelation structure{p_end}
{synopt :{opth rho:type(xtpcse##calc:calc)}}specify method to compute autocorrelation parameter; seldom used{p_end}
{synopt :{opt np1}}weight panel-specific autocorrelations by panel sizes{p_end}
{synopt :{opt het:only}}assume panel-level heteroskedastic errors{p_end}
{synopt :{opt i:ndependent}}assume independent errors across panels{p_end}

{syntab:by/if/in}
{synopt :{opt ca:sewise}}include only observations with complete cases{p_end}
{synopt :{opt p:airwise}}include all available observations with nonmissing pairs{p_end}

{syntab:SE}
{synopt :{opt nmk}}normalize standard errors by N-k instead of N{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt d:etail}}report list of gaps in time series{p_end}
{synopt :{it:{help xtpcse##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable and a time variable must be specified; use {helpb xtset}.
{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see 
{help tsvarlist}.{p_end}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt iweight}s and {opt aweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtpcse_postestimation XT:xtpcse postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Contemporaneous correlation >}
     {bf:Regression with panel-corrected standard errors (PCSE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtpcse} calculates panel-corrected standard error (PCSE) estimates for
linear cross-sectional time-series models where the parameters are estimated
by either OLS or Prais-Winsten regression.  When computing the standard errors
and the variance-covariance estimates, {cmd:xtpcse} assumes that the
disturbances are, by default, heteroskedastic and contemporaneously correlated
across panels.

{pstd}
See {helpb xtgls:[XT] xtgls} for the generalized least-squares estimator for
these models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtpcseQuickstart:Quick start}

        {mansection XT xtpcseRemarksandexamples:Remarks and examples}

        {mansection XT xtpcseMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt correlation(corr)} specifies the form of assumed autocorrelation within
panels.

{pmore}
{cmd:correlation(independent)}, the default, specifies that there is no
autocorrelation.

{pmore}
{cmd:correlation(ar1)} specifies that, within panels, there is first-order
autocorrelation AR(1) and that the coefficient of the AR(1) process is common
to all the panels.

{pmore}
{cmd:correlation(psar1)} specifies that, within panels, there is
first-order autocorrelation and that the coefficient of the AR(1) process is
specific to each panel.  {opt psar1} stands for panel-specific AR(1).

{marker calc}{...}
{phang}
{opt rhotype(calc)} specifies the method to be used to calculate the
autocorrelation parameter.  Allowed strings for {it:calc} are

{center:{opt reg:ress}    regression using lags; the default    }
 {center:{opt freg}       regression using leads                 }
 {center:{opt tsc:orr}     time-series autocorrelation calculation}
 {center:{opt dw}         Durbin-Watson calculation              }

{pmore}
All the above methods are consistent and asymptotically equivalent; this is
a rarely used option.

{phang}
{opt np1} specifies that the panel-specific autocorrelations be weighted by
T_i rather than by the default T_i-1 when estimating a common rho for all
panels, where T_i is the number of observations in panel i.  This option has
an effect only when panels are unbalanced and the {cmd:correlation(ar1)} option
is specified.

{phang}
{opt hetonly} and {opt independent} specify alternative forms for the assumed
covariance of the disturbances across the panels.  If neither is specified,
the disturbances are assumed to be heteroskedastic (each panel has its own
variance) and contemporaneously correlated across the panels (each pair of
panels has its own covariance).  This is the standard PCSE model.

{pmore}
{opt hetonly} specifies that the disturbances are assumed to be panel-level
heteroskedastic only with no contemporaneous correlation across panels.

{pmore}
{opt independent} specifies that the disturbances are assumed to be
independent across panels; that is, there is one disturbance variance
common to all observations.

{dlgtab:by/if/in}

{phang}
{opt casewise} and {opt pairwise} specify how missing observations in
unbalanced panels are to be treated when estimating the interpanel covariance
matrix of the disturbances.  The default is {opt casewise} selection.

{pmore}
{opt casewise} specifies that the entire covariance matrix be computed
only on the observations (periods) that are available for all panels.  If
an observation has missing data, all observations of that period are
excluded when estimating the covariance matrix of disturbances.  Specifying
{opt casewise} ensures that the estimated covariance matrix will be of full
rank and will be positive definite.

{pmore}
{opt pairwise} specifies that, for each element in the covariance matrix,
all available observations (periods) that are common to the two panels
contributing to the covariance be used to compute the covariance.

{pmore}
The {opt casewise} and {opt pairwise} options have an effect only when the
panels are unbalanced and neither {opt hetonly} nor {opt independent} is
specified.

{dlgtab:SE}

{phang}
{opt nmk} specifies that standard errors be normalized by N-k, where k is the
number of parameters estimated, rather than N, the number of observations.
Different authors have used one or the other normalization.
{help xtpcse##G2018:Greene (2018, 313)}
remarks that whether a degree-of-freedom correction improves the 
small-sample properties is an open question.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt detail} specifies that a detailed list of any gaps in the series
be reported.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtpcse} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse grunfeld}{p_end}
{phang2}{cmd:. xtset company year, yearly}{p_end}

{pstd}Fit linear regression with panel-corrected standard errors, assuming no autocorrelation within panels{p_end}
{phang2}{cmd:. xtpcse invest mvalue kstock}{p_end}

{pstd}Specify first-order autocorrelation within panels{p_end}
{phang2}{cmd:. xtpcse invest mvalue kstock, correlation(ar1)}{p_end}

{pstd}Specify panel-specific first-order autocorrelation; use time-series
method to estimate autocorrelation parameters{p_end}
{phang2}{cmd:. xtpcse invest mvalue kstock, correlation(psar1) rhotype(tscorr)}
{p_end}

{pstd}Specify first-order autocorrelation within panels; allow panel-level disturbances to be heteroskedastic but not contemporaneously correlated{p_end}
{phang2}{cmd:. xtpcse invest mvalue kstock, correlation(ar1) hetonly}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtpcse} stores the following in {cmd:e()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(n_cf)}}number of estimated coefficients{p_end}
{synopt:{cmd:e(n_cv)}}number of estimated covariances{p_end}
{synopt:{cmd:e(n_cr)}}number of estimated correlations{p_end}
{synopt:{cmd:e(n_sigma)}}observations used to estimate elements of {cmd:Sigma}{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df)}}degrees of freedom{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtpcse}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(panels)}}contemporaneous covariance structure{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(rhotype)}}type of estimated correlation{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant} or ""{p_end}
{synopt:{cmd:e(missmeth)}}{cmd:casewise} or {cmd:pairwise}{p_end}
{synopt:{cmd:e(balance)}}{cmd:balanced} or {cmd:unbalanced}{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(rhomat)}}vector of autocorrelation parameter estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker G2018}{...}
{phang}
Greene, W. H. 2018. {browse "http://www.stata.com/bookstore/ea.html":{it:Econometric Analysis}. 8th ed.}
New York: Pearson.
{p_end}
