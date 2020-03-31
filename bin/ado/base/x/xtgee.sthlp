{smcl}
{* *! version 1.4.2  30may2019}{...}
{viewerdialog xtgee "dialog xtgee"}{...}
{vieweralsosee "[XT] xtgee" "mansection XT xtgee"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtgee postestimation" "help xtgee postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xtcloglog" "help xtcloglog"}{...}
{vieweralsosee "[XT] xtlogit" "help xtlogit"}{...}
{vieweralsosee "[XT] xtnbreg" "help xtnbreg"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[XT] xtprobit" "help xtprobit"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtgee##syntax"}{...}
{viewerjumpto "Menu" "xtgee##menu"}{...}
{viewerjumpto "Description" "xtgee##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtgee##linkspdf"}{...}
{viewerjumpto "Options" "xtgee##options"}{...}
{viewerjumpto "Examples" "xtgee##examples"}{...}
{viewerjumpto "Correlation structures and the allowed spacing of observations within panel" "xtgee##remarks1"}{...}
{viewerjumpto "Stored results" "xtgee##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtgee} {hline 2}}Fit population-averaged panel-data models by using GEE{p_end}
{p2col:}({mansection XT xtgee:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:xtgee} {depvar} [{indepvars}] {ifin}
[{it:{help xtgee##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmdab:f:amily(}{it:{help xtgee##family:family}}{cmd:)}}distribution of {depvar}{p_end}
{synopt :{cmdab:l:ink(}{it:{help xtgee##link:link}}{cmd:)}}link function{p_end}

{syntab:Model 2}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opt force}}estimate even if observations unequally spaced in time{p_end}

{syntab:Correlation}
{synopt :{cmdab:c:orr(}{it:{help xtgee##correlation:correlation}}{cmd:)}}within-group correlation structure{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
       {opt r:obust}, {opt boot:strap}, or {opt jack:knife}{p_end}
{synopt :{opt nmp}}use divisor N-P instead of the default N{p_end}
{synopt :{opt rgf}}multiply the robust variance estimate by (N-1)/(N-P){p_end}
{synopt :{opt s:cale(parm)}}override the default scale parameter; {it:parm}
                  may be {cmd:x2}, {cmd:dev}, {cmd:phi}, or {it:#}{p_end}

{syntab:Reporting}
{synopt :{opt le:vel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ef:orm}}report exponentiated coefficients{p_end}
{synopt :{it:{help xtgee##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{it:{help xtgee##optimize_options:optimize_options}}}control the optimization process; seldom used{p_end}

{synopt:{opt nodis:play}}suppress display of header and coefficients{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable must be specified.  Correlation structures
other than {cmd:exchangeable} and {cmd:independent} require that a time
variable also be specified.  Use {helpb xtset}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by}, {opt mfp}, {opt mi estimate}, and
{opt statsby} are allowed; see {help prefix}.
{p_end}
INCLUDE help vce_mi
{marker weight}{...}
{p 4 6 2} {opt iweight}s, {opt fweight}s, and {opt pweight}s are allowed; see
{help weight}.  Weights must be constant within panel.{p_end}
{p 4 6 2}{opt nodisplay} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtgee_postestimation XT:xtgee postestimation} for features
available after estimation.{p_end}

{marker family}{...}
{synoptset 23}{...}
{synopthdr :family}
{synoptline}
{synopt :{opt gau:ssian}}Gaussian (normal); {cmd:family(normal)} is a synonym{p_end}
{synopt :{opt ig:aussian}}inverse Gaussian{p_end}
{synopt :{opt b:inomial}[{it:#}|{varname}]}Bernoulli/binomial{p_end}
{synopt :{opt p:oisson}}Poisson{p_end}
{synopt :{opt nb:inomial}[{it:#}]}negative binomial{p_end}
{synopt :{opt gam:ma}}gamma{p_end}
{synoptline}
{p2colreset}{...}

{marker link}{...}
{synoptset 23}{...}
{synopthdr :link}
{synoptline}
{synopt :{opt i:dentity}}identity; y=y{p_end}
{synopt :{opt log}}log; ln(y){p_end}
{synopt :{opt logi:t}}logit; ln{y/(1-y)}, natural log of the odds{p_end}
{synopt :{opt p:robit}}probit; inverse Gaussian cumulative{p_end}
{synopt :{opt cl:oglog}}clog-log; ln{-ln(1-y)}{p_end}
{synopt :{opt pow:er}[{it:#}]}power; y^k with k=#; #=1 if not specified{p_end}
{synopt :{opt opo:wer}[{it:#}]}odds power; [{y/(1-y)}^k - 1]/k with k=#; #=1 if not specified{p_end}
{synopt :{opt nb:inomial}}negative binomial{p_end}
{synopt :{opt rec:iprocal}}reciprocal; 1/y{p_end}
{synoptline}
{p2colreset}{...}

{marker correlation}{...}
{synoptset 23}{...}
{synopthdr :correlation}
{synoptline}
{synopt :{opt exc:hangeable}}exchangeable{p_end}
{synopt :{opt ind:ependent}}independent{p_end}
{synopt :{opt uns:tructured}}unstructured{p_end}
{synopt :{opt fix:ed} {it:matname}}user-specified{p_end}
{synopt :{opt ar} {it:#}}autoregressive of order {it:#}{p_end}
{synopt :{opt sta:tionary} {it:#}}stationary of order {it:#}{p_end}
{synopt :{opt non:stationary} {it:#}}nonstationary of order {it:#}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data >}
   {bf:Generalized estimating equations (GEE) >}
   {bf:Generalized estimating equations (GEE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtgee} fits population-averaged panel-data models.  In particular,
{cmd:xtgee} fits generalized linear models and allows you to specify the
within-group correlation structure for the panels.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtgeeQuickstart:Quick start}

        {mansection XT xtgeeRemarksandexamples:Remarks and examples}

        {mansection XT xtgeeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt family(family)} specifies the distribution of {depvar};
{cmd:family(gaussian)} is the default.

{phang}
{opt link(link)} specifies the link function; the default is
the canonical link for the {opt family()} specified (except for 
{cmd:family(nbinomial)}).

{dlgtab:Model 2}

{phang}
{opth exposure(varname)} and {opt offset(varname)} are different ways of
specifying the same thing.  {opt exposure()} specifies a variable that reflects
the amount of exposure over which the {depvar} events were observed for each
observation; ln({it:varname}) with coefficient constrained to be 1 is entered
into the regression equation.  {opt offset()} specifies a variable that is to
be entered directly into the log-link function with its coefficient
constrained to be 1; thus, exposure is assumed to be e^varname.  If you were
fitting a Poisson regression model, {cmd:family(poisson) link(log)}, for
instance, you would account for exposure time by specifying {opt offset()}
containing the log of exposure time.

{phang}
{opt noconstant} specifies that the linear predictor has no intercept term,
thus forcing it through the origin on the scale defined by the link function.

{phang}
{opt asis} forces retention of perfect predictor variables and their
associated, perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.
This option is only allowed with option {cmd:family(binomial)}
with a denominator of 1.

{phang}
{opt force} specifies that estimation be forced even though the time variable
is not equally spaced.  This is relevant only for correlation structures
that require knowledge of the time variable.  These correlation structures
require that observations be equally spaced so that calculations based on lags
correspond to a constant time change.  If you specify a time variable
indicating that observations are not equally spaced, the (time dependent)
model will not be fit.  If you also specify {opt force}, the model will be
fit, and it will be assumed that the lags based on the data ordered by the
time variable are appropriate.

{dlgtab:Correlation}

{phang}
{opt corr(correlation)} specifies the within-group correlation
structure; the default corresponds to the equal-correlation model,
{cmd:corr(exchangeable)}.

{pmore}
When you specify a correlation structure that requires a lag, you indicate the
lag after the structure's name with or without a blank; for example,
{cmd:corr(ar 1)} or {cmd:corr(ar1)}.

{pmore}
If you specify the fixed correlation structure, you specify the name of the
matrix containing the assumed correlations following the word {cmd:fixed},
for example, {cmd:corr(fixed myr)}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:conventional}),
that are robust to some kinds of misspecification ({cmd:robust}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb xt_vce_options:[XT] {it:vce_options}}.

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
{cmd:vce(robust)} specifies that the Huber/White/sandwich estimator of
variance is to be used in place of the default conventional variance estimator
(see {it:{mansection XT xtgeeMethodsandformulas:Methods and formulas}} in
{bf:[XT] xtgee}).  Use of this option causes {cmd:xtgee} to produce valid
standard errors even if the correlations within group are not as hypothesized
by the specified correlation structure.  Under a noncanonical link, it does,
however, require that the model correctly specifies the mean.  The resulting
standard errors are thus labeled "semirobust" instead of "robust" in this
case.  Although there is no {cmd:vce(cluster} {it:clustvar}{cmd:)} option,
results are as if this option were included and you specified clustering on
the panel variable.

{phang}
{opt nmp}; see {helpb xt_vce_options:[XT] {it:vce_options}}. 

{phang}
{opt rgf} specifies that the robust variance estimate is multiplied by
(N-1)/(N-P), where N is the total number of observations and P is the number
of coefficients estimated.  This option can be used only with
{cmd:family(gaussian)} when {cmd:vce(robust)} is either specified or implied
by the use of {opt pweight}s.  Using this option implies that the robust
variance estimate is not invariant to the scale of any weights used.

{phang}
{cmd:scale(x2}|{cmd:dev}|{cmd:phi}|{it:#}{cmd:)}; see
{helpb xt_vce_options:[XT] {it:vce_options}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt eform} displays the exponentiated coefficients and corresponding standard
errors and confidence intervals as described in {helpb maximize:[R] Maximize}.
For {cmd:family(binomial) link(logit)} (that is, logistic regression),
exponentiation results in odds ratios; for {cmd:family(poisson) link(log)}
(that is, Poisson regression), exponentiated coefficients are incidence-rate
ratios.

INCLUDE help displayopts_list

{dlgtab:Optimization}

{phang}
{marker optimize_options}
{it:optimize_options} control the iterative optimization process.  These options
are seldom used.

{pmore}
{opt iter:ate(#)} specifies the maximum number of iterations.  When the number 
of iterations equals #, the optimization stops and presents the current results,
even if the convergence tolerance has not been reached.  The default is
{cmd:iterate(100)}.

{pmore}
{opt tol:erance(#)} specifies the tolerance for the coefficient vector.  When 
the relative change in the coefficient vector from one iteration to the next is
less than or equal to #, the optimization process is stopped.  
{cmd:tolerance(1e-6)} is the default.

{pmore}
INCLUDE help lognolog

{pmore}
{opt tr:ace} specifies that the current estimates be printed at each
iteration.

{pstd}
The following options are available with {cmd:xtgee} but are not shown in the
dialog box:

{phang}
{opt nodisplay} is for programmers.  It suppresses the display of the header
and coefficients.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse union}{p_end}
{phang2}{cmd:. xtset id year}{p_end}

{pstd}Fit a logit model{p_end}
{phang2}{cmd:. xtgee union age grade not_smsa south, family(binomial)}
              {cmd:link(logit)}{p_end}

{pstd}Fit a probit model with AR(1) correlation{p_end}
{phang2}{cmd:. xtgee union age grade not_smsa south, family(binomial)}
              {cmd:link(probit) corr(ar1)}{p_end}


{marker remarks1}{...}
{title:Correlation structures and the allowed spacing of observations within panel}

{center:{space 16}{hline 2}characteristics allowed{hline 2}}
{center:{space 29}Unequal       }
{center:Correlation     Unbalanced   spacing   Gaps}
{center:{hline 43}}
{center:independent        yes         yes      yes}
{center:exchangeable       yes         yes      yes}
{center:ar k               yes (*)     no       no }
{center:stationary k       yes (*)     no       no }
{center:nonstationary k    yes (*)     no       no }
{center:unstructured       yes         yes      yes}
{center:fixed              yes         yes      yes}
{center:{hline 43}}
{center:(*) All panels must have at least k+1 obs. }


    Definitions:

{phang2}1.  Panels are balanced if each has the same number of observations.

{phang2}2.  Panels are equally spaced if the interval between observations is
constant.

{phang2}3.  Panels have gaps if some observations are missing.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtgee} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(df_pear)}}degrees of freedom for Pearson chi-squared{p_end}
{synopt:{cmd:e(chi2_dev)}}chi-squared test of deviance{p_end}
{synopt:{cmd:e(chi2_dis)}}chi-squared test of deviance dispersion{p_end}
{synopt:{cmd:e(deviance)}}deviance{p_end}
{synopt:{cmd:e(dispers)}}deviance dispersion{p_end}
{synopt:{cmd:e(phi)}}scale parameter{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(tol)}}target tolerance{p_end}
{synopt:{cmd:e(dif)}}achieved tolerance{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtgee}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(model)}}{cmd:pa}{p_end}
{synopt:{cmd:e(family)}}distribution family{p_end}
{synopt:{cmd:e(link)}}link function{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(scale)}}{cmd:x2}, {cmd:dev}, {cmd:phi}, or {it:#};
                   scale parameter{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(nmp)}}{cmd:nmp}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(R)}}estimated working correlation matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
