{smcl}
{* *! version 1.2.6  19sep2018}{...}
{viewerdialog xtregar "dialog xtregar"}{...}
{vieweralsosee "[XT] xtregar" "mansection XT xtregar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtregar postestimation" "help xtregar postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] newey" "help newey"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "[XT] xtgls" "help xtgls"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtregar##syntax"}{...}
{viewerjumpto "Menu" "xtregar##menu"}{...}
{viewerjumpto "Description" "xtregar##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtregar##linkspdf"}{...}
{viewerjumpto "Options" "xtregar##options"}{...}
{viewerjumpto "Examples" "xtregar##examples"}{...}
{viewerjumpto "Stored results" "xtregar##results"}{...}
{viewerjumpto "References" "xtregar##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[XT] xtregar} {hline 2}}Fixed- and random-effects linear models with an AR(1) disturbance{p_end}
{p2col:}({mansection XT xtregar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
GLS random-effects (RE) model

{p 8 16 2}
{cmd:xtregar} {depvar} [{indepvars}] {ifin} [{cmd:, re} {it:options}]


{phang}
Fixed-effects (FE) model

{p 8 16 2}
{cmd:xtregar} {depvar} [{indepvars}] {ifin}
[{it:{help xtregar##weight:weight}}]
{cmd:, fe} [{it:options}]


{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt re}}use random-effects estimator; the default{p_end}
{synopt :{opt fe}}use fixed-effects estimator{p_end}
{synopt :{opth rhot:ype(xtregar##rhomethod:rhomethod)}}specify method to compute autocorrelation; seldom used{p_end}
{synopt :{opt rhof(#)}}use # for p and do not estimate p{p_end}
{synopt :{opt two:step}}perform two-step estimate of correlation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lbi}}perform Baltagi-Wu LBI test{p_end}
{synopt :{it:{help xtregar##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable and a time variable must be specified; use {helpb xtset}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s and {opt aweight}s are allowed for the fixed-effects model with
{cmd:rhotype(regress)} or {cmd:rhotype(freg)}, or with a fixed rho; see
{help weight}.  Weights must be constant within panel.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtregar_postestimation XT:xtregar postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Linear models >}
     {bf:Linear regression with AR(1) disturbance (FE, RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtregar} fits cross-sectional time-series regression models when the
disturbance term is first-order autoregressive.  {cmd:xtregar} offers a within
estimator for fixed-effects models and a GLS estimator for random-effects
models.  {cmd:xtregar} can accommodate unbalanced panels whose observations
are unequally spaced over time.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtregarQuickstart:Quick start}

        {mansection XT xtregarRemarksandexamples:Remarks and examples}

        {mansection XT xtregarMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt re} requests the GLS estimator of the random-effects model, which is the
default.

{phang}
{opt fe} requests the within estimator of the fixed-effects model.

{marker rhomethod}{...}
{phang}
{opt rhotype(rhomethod)} allows the user to specify any of the following
estimators of rho:

{p 12 25 2}{cmd:dw} {space 7} rho_dw = 1 - d/2, where d is the Durbin-Watson d
		statistic{p_end}
{p 12 25 2}{cmdab:reg:ress} {space 2} rho_reg = B from the residual regression
		e_t = B*e_(t-1){p_end}
{p 12 25 2}{cmd:freg} {space 5} rho_freg = B from the residual regression
		e_t = B*e_(t+1){p_end}
{p 12 25 2}{cmdab:tsc:orr} {space 3} rho_tscorr = e'e_(t-1)/e'e, where e is the
		vector of residuals and e_(t-1) is the vector of lagged
		residuals{p_end}
{p 12 25 2}{cmdab:th:eil} {space 4} rho_theil = rho_tscorr * (N-k)/N{p_end}
{p 12 25 2}{cmdab:nag:ar} {space 4} rho_nagar = (rho_dw * N*N+k*k)/(N*N-k*k){p_end}
{p 12 25 2}{cmdab:one:step} {space 2} rho_onestep = (n/m_c)*rho_tscorr, where n
		is the number of observations and m_c is the number of
		consecutive pairs of residuals

{pmore}
{opt dw} is the default method.  Except for {opt onestep}, the details of
these methods are given in {manlink TS prais}.  {opt prais} handles unequally
spaced data.  {cmd:onestep} is the one-step method proposed by
{help xtregar##BW1999:Baltagi and Wu (1999)}.  More details on this method are
available in
{it:{mansection XT xtregarMethodsandformulas:Methods and formulas}} of
{bf:[XT] xtregar}.

{phang}
{opt rhof(#)} specifies that the given number be used for rho and that rho
not be estimated.

{phang}
{opt twostep} requests that a two-step implementation of the
{it:rhomethod} estimator of rho be used.  Unless a fixed value of
rho is specified (with the {opt rhof()} option), rho is estimated by
running {cmd:prais} on the de-meaned data.  When {opt twostep} is specified,
{cmd:prais} will stop on the first iteration after the equation is transformed
by rho -- the two-step efficient estimator.  Although it is customary to
iterate these estimators to convergence, they are efficient at each step.
When {opt twostep} is not specified, the FGLS process iterates to convergence
as described in the 
{mansection TS praisMethodsandformulastwostep:{it:Methods and formulas}}
of {bf:[TS] prais}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt lbi} requests that the Baltagi-Wu ({help xtregar##BW1999:1999}) locally
best invariant (LBI) test statistic that rho = 0 and a modified version of the
{help xtregar##BFN1982:Bhargava, Franzini, and Narendranathan (1982)}
Durbin-Watson statistic be calculated and reported.  The default is not to
report them.  p-values are not reported for either statistic.  Although
{help xtregar##BFN1982:Bhargava, Franzini, and Narendranathan (1982)} published
critical values for their statistic, no tables are currently available for the
Baltagi-Wu LBI.  {help xtregar##BW1999:Baltagi and Wu (1999)} derive a
normalized version of their statistic, but this statistic cannot be computed
for datasets of moderate size.  You can also specify these options upon reply.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtregar} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse grunfeld}{p_end}
{phang2}{cmd:. xtset company time}{p_end}

{pstd}Random-effects model{p_end}
{phang2}{cmd:. xtregar invest mvalue kstock}{p_end}

{pstd}Fixed-effects model{p_end}
{phang2}{cmd:. xtregar invest mvalue kstock, fe}{p_end}

{pstd}Random-effects model and report Baltagi-Wu LBI test{p_end}
{phang2}{cmd:. xtregar invest mvalue kstock, re lbi}

{pstd}Fixed-effects model and perform two-step estimate of correlation{p_end}
{phang2}{cmd:. xtregar invest mvalue kstock, fe twostep}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtregar, re} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(d1)}}Bhargava et al. Durbin-Watson{p_end}
{synopt:{cmd:e(LBI)}}Baltagi-Wu LBI statistic{p_end}
{synopt:{cmd:e(N_LBI)}}number of obs used in {cmd:e(LBI)}{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if T is constant{p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of z_it{p_end}
{synopt:{cmd:e(r2_w)}}R-squared within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared between model{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(rho_ar)}}autocorrelation coefficient{p_end}
{synopt:{cmd:e(rho_fov)}}u_i fraction of variance{p_end}
{synopt:{cmd:e(thta_min)}}minimum theta{p_end}
{synopt:{cmd:e(thta_5)}}theta, 5th percentile{p_end}
{synopt:{cmd:e(thta_50)}}theta, 50th percentile{p_end}
{synopt:{cmd:e(thta_95)}}theta, 95th percentile{p_end}
{synopt:{cmd:e(thta_max)}}maximum theta{p_end}
{synopt:{cmd:e(Tbar)}}harmonic mean of group sizes{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtregar}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(model)}}{cmd:re}{p_end}
{synopt:{cmd:e(rhotype)}}method of estimating rho_ar{p_end}
{synopt:{cmd:e(dw)}}{cmd:lbi}, if {cmd:lbi} specified{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}VCE for random-effects model{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xtregar, fe} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(d1)}}Bhargava et al. Durbin-Watson{p_end}
{synopt:{cmd:e(LBI)}}Baltagi-Wu LBI statistic{p_end}
{synopt:{cmd:e(N_LBI)}}number of obs used in {cmd:e(LBI)}{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if T is constant{p_end}
{synopt:{cmd:e(corr)}}corr(u_i, Xb){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(r2_w)}}R-squared within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared between model{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(rho_ar)}}autocorrelation coefficient{p_end}
{synopt:{cmd:e(rho_fov)}}u_i fraction of variance{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(F_f)}}F for u_i=0{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df_a)}}degrees of freedom for absorbed effect{p_end}
{synopt:{cmd:e(df_b)}}numerator degrees of freedom for F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(Tbar)}}harmonic mean of group sizes{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtregar}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(model)}}{cmd:fe}{p_end}
{synopt:{cmd:e(rhotype)}}method of estimating rho_ar{p_end}
{synopt:{cmd:e(dw)}}{cmd:lbi}, if {cmd:lbi} specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BW1999}{...}
{phang}
Baltagi, B. H., and P. X. Wu. 1999. Unequally spaced panel data regressions
with AR(1) disturbances. {it:Econometric Theory} 15: 814-823.

{marker BFN1982}{...}
{phang}
Bhargava, A., L. Franzini, and W. Narendranathan. 1982. Serial correlation
and the fixed effects model. {it:Review of Economic Studies} 49: 533-549.
{p_end}
