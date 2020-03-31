{smcl}
{* *! version 1.3.9  10feb2020}{...}
{viewerdialog xtreg "dialog xtreg"}{...}
{vieweralsosee "[XT] xtreg" "mansection XT xtreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtreg postestimation" "help xtreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] areg" "help areg"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SP] spxtregress" "help spxtregress"}{...}
{vieweralsosee "[XT] xteregress" "help xteregress"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "[XT] xtgls" "help xtgls"}{...}
{vieweralsosee "[XT] xtheckman" "help xtheckman"}{...}
{vieweralsosee "[XT] xtivreg" "help xtivreg"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtreg##syntax"}{...}
{viewerjumpto "Menu" "xtreg##menu"}{...}
{viewerjumpto "Description" "xtreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtreg##linkspdf"}{...}
{viewerjumpto "Options for RE model" "xtreg##options_re"}{...}
{viewerjumpto "Options for BE model" "xtreg##options_be"}{...}
{viewerjumpto "Options for FE model" "xtreg##options_fe"}{...}
{viewerjumpto "Options for MLE model" "xtreg##options_mle"}{...}
{viewerjumpto "Options for PA model" "xtreg##options_pa"}{...}
{viewerjumpto "Examples" "xtreg##examples"}{...}
{viewerjumpto "Stored results" "xtreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtreg} {hline 2}}Fixed-, between-, and random-effects and population-averaged linear models{p_end}
{p2col:}({mansection XT xtreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
GLS random-effects (RE) model

{p 8 16 2}{cmd:xtreg} {depvar} [{indepvars}] {ifin}
[{cmd:, re} {it:{help xtreg##reoptions:RE_options}}]


{phang}
Between-effects (BE) model

{p 8 16 2}{cmd:xtreg} {depvar} [{indepvars}] {ifin}
{cmd:, be} [{it:{help xtreg##beoptions:BE_options}}]


{phang}
Fixed-effects (FE) model

{p 8 16 2}{cmd:xtreg} {depvar} [{indepvars}] {ifin}
[{it:{help xtreg##weight:weight}}]
{cmd:, fe} [{it:{help xtreg##feoptions:FE_options}}]


{phang}
ML random-effects (MLE) model

{p 8 16 2}{cmd:xtreg} {depvar} [{indepvars}] {ifin}
[{it:{help xtreg##weight:weight}}]
{cmd:, mle} [{it:{help xtreg##mleoptions:MLE_options}}]


{phang}
Population-averaged (PA) model

{p 8 16 2}{cmd:xtreg} {depvar} [{indepvars}] {ifin}
[{it:{help xtreg##weight:weight}}]
{cmd:, pa} [{it:{help xtreg##paoptions:PA_options}}]


{marker reoptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr :RE_options}
{synoptline}
{syntab:Model}
{synopt :{opt re}}use random-effects estimator; the default{p_end}
{synopt :{opt sa}}use Swamy-Arora estimator of the variance components{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
    {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
    {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt th:eta}}report theta{p_end}
{synopt :{it:{help xtreg##re_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker beoptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr :BE_options}
{synoptline}
{syntab:Model}
{synopt :{opt be}}use between-effects estimator{p_end}
{synopt :{opt w:ls}}use weighted least squares{p_end}

{syntab:SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
      {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xtreg##be_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker feoptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr :FE_options}
{synoptline}
{syntab:Model}
{synopt :{opt fe}}use fixed-effects estimator{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional}, {opt r:obust},
   {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xtreg##fe_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker mleoptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr :MLE_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt mle}}use ML random-effects estimator{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
   {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xtreg##mle_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help xtreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker paoptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr:PA_options}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt pa}}use population-averaged estimator{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}

{syntab :Correlation}
{synopt :{cmdab:c:orr(}{it:{help xtreg##correlation:correlation}}{cmd:)}}within-panel correlation structure{p_end}
{synopt :{opt force}}estimate even if observations unequally spaced in time{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
    {opt r:obust}, {opt boot:strap}, or {opt jack:knife}{p_end}
{synopt :{opt nmp}}use divisor N-P instead of the default N{p_end}
{synopt :{opt rgf}}multiply the robust variance estimate by (N-1)/(N-P){p_end}
{synopt :{opt s:cale(parm)}}override the default scale parameter; {it:parm}
                  may be {cmd:x2}, {cmd:dev}, {cmd:phi}, or {it:#}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help xtreg##pa_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Optimization}
{synopt :{it:{help xtreg##optimize_options:optimize_options}}}control the optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 20}{...}
{marker correlation}{...}
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

{p 4 6 2}
A panel variable must be specified. For {cmd:xtreg, pa}, correlation
structures other than {cmd:exchangeable} and {cmd:independent} require that a
time variable also be specified.  Use {helpb xtset}. {p_end}
{p 4 6 2}{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt mi estimate}, and {opt statsby} are allowed; see {help prefix}.
{opt fp} is allowed for the between-effects, fixed-effects, and
maximum-likelihood random-effects models.{p_end}
INCLUDE help vce_mi
{marker weight}{...}
{p 4 6 2}
{opt aweight}s, {opt fweight}s, and {opt pweight}s are allowed for the
fixed-effects model.  {opt iweight}s, {opt fweight}s, and {opt pweight}s are
allowed for the population-averaged model. {opt iweight}s are allowed for
the maximum-likelihood random-effects (MLE) model.  {help weight:Weights} must
be constant within panel.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtreg_postestimation XT:xtreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Linear models >}
      {bf:Linear regression (FE, RE, PA, BE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtreg} fits regression models to panel data.  In
particular, {cmd:xtreg} with the {opt be} option fits random-effects models
by using the between regression estimator; with the {opt fe} option, it fits
fixed-effects models (by using the within regression estimator); and with the
{opt re} option, it fits random-effects models by using the GLS estimator
(producing a matrix-weighted average of the between and within results).  See
{manhelp xtdata XT} for a faster way to fit fixed- and random-effects models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtregQuickstart:Quick start}

        {mansection XT xtregRemarksandexamples:Remarks and examples}

        {mansection XT xtregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_re}{...}
{title:Options for RE model}

{dlgtab:Model}

{phang}
{opt re}, the default, requests the GLS random-effects estimator. 

{phang}
{opt sa} specifies that the small-sample Swamy-Arora estimator
individual-level variance component be used instead of the default consistent
estimator.  See
{mansection XT xtregMethodsandformulasxtreg,re:{it:xtreg, re}} in
{it:Methods and formulas} of {bf:[XT] xtreg} for details.

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,re:{it:xtreg, re}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt theta} specifies that the output should include the estimated value of
theta used in combining the between and fixed estimators.  For balanced data,
this is a constant, and for unbalanced data, a summary of the values is
presented in the header of the output.

{marker re_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_be}{...}
{title:Options for BE model}

{dlgtab:Model}

{phang}
{opt be} requests the between regression estimator.

{phang}
{opt wls} specifies that, for unbalanced data, weighted least
squares be used rather than the default OLS.  Both methods produce consistent
estimates.    The true variance of the between-effects residual is
sigma^2_{nu}+T_i sigma^2_{epsilon} (see
{mansection XT xtregMethodsandformulasxtreg,be:{it:xtreg, be}} in
{it:Methods and formulas} of {bf:[XT] xtreg}).  WLS produces a "stabilized"
variance of sigma^2_{nu}/T_i + sigma^2_{epsilon}, which is also not constant.
Thus the choice between OLS and WLS amounts to which is more stable.

{pmore}
Comment:  {cmd:xtreg,} {cmd:be} is rarely used anyway, but between estimates
are an ingredient in the random-effects estimate.  Our implementation of
{cmd:xtreg,} {cmd:re} uses the OLS estimates for this ingredient, based
on our judgment that sigma^2_{nu} is large relative to sigma^2_{epsilon} in
most models.  Formally, only a consistent estimate of the between estimates is
required.

{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:conventional})
and that use bootstrap or jackknife methods ({cmd:bootstrap},
{cmd:jackknife}); see {helpb xt_vce_options:[XT] {it:vce_options}}.
{p_end}

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{marker be_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_fe}{...}
{title:Options for FE model}

{dlgtab:Model}

{phang}
{opt fe} requests the fixed-effects (within) regression estimator.  

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,fe:{it:xtreg, fe}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{marker fe_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_mle}{...}
{title:Options for MLE model}

{dlgtab:Model}

{phang}
{opt noconstant}; see
 {helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt mle} requests the maximum-likelihood random-effects estimator.

{dlgtab:SE/Robust}

{* INCLUDE help xt_vce_asymptall * -- modify -conventional- to -oim-}{...}
{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb xt_vce_options:[XT] {it:vce_options}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{marker mle_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{phang}
{marker maximize_options}
{it:maximize_options}:
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, {opt tol:erance(#)},
{opt ltol:erance(#)}, and {opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following option is available with {opt xtreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_pa}{...}
{title:Options for PA model}

{dlgtab:Model}

{phang}
{opt noconstant}; see
 {helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt pa} requests the population-averaged estimator.  For linear regression, this is the same as a random-effects estimator (both interpretations hold).

{pmore}
{cmd:xtreg, pa} is equivalent to
{cmd:xtgee, family(gaussian) link(id) corr(exchangeable)}, which are 
the defaults for the {cmd:xtgee} command.  {cmd:xtreg, pa} allows all the
relevant {cmd:xtgee} options such as {cmd:vce(robust)}.  Whether you use
{cmd:xtreg, pa} or {cmd:xtgee} makes no difference.  See {manhelp xtgee XT}.

{phang}
{opth offset(varname)}; see
{helpb estimation options##offset():[R] Estimation options}.

{dlgtab:Correlation}

{phang}
{opt corr(correlation)} specifies the within-panel correlation
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

{phang}
{opt nmp}; see {helpb xt_vce_options:[XT] {it:vce_options}}. 

{phang}
{opt rgf} specifies that the robust variance estimate is multiplied by
(N-1)/(N-P), where N is the total number of observations and P is the number
of coefficients estimated.  This option can be used with
{cmd:family(gaussian)} only when {cmd:vce(robust)} is either specified or
implied by the use of {opt pweight}s.  Using this option implies that the
robust variance estimate is not invariant to the scale of any weights used.

{phang}
{cmd:scale(x2}|{cmd:dev}|{cmd:phi}|{it:#}{cmd:)}; see
{helpb xt_vce_options:[XT] {it:vce_options}}.

{dlgtab:Reporting} 

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{marker pa_display_options}{...}
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
The following option is available with {opt xtreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}
{phang2}{cmd:. xtset idcode}{p_end}

{pstd}Between-effects model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, be}

{pstd}Additional setup if not using factor variables{p_end}
{phang2}{cmd:. generate age2 = age^2}{p_end}
{phang2}{cmd:. generate ttl_exp2 = ttl_exp^2}{p_end}
{phang2}{cmd:. generate tenure2 = tenure^2}{p_end}
{phang2}{cmd:. generate byte black = (race==2)}{p_end}

{pstd}Between-effects model same as above, but not using factor variables{p_end}
{phang2}{cmd:. xtreg ln_w grade age* ttl_exp* tenure* black not_smsa south, be}
{p_end}

{pstd}Fixed-effects model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, fe}

{pstd}Fixed-effects model with robust variance{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, fe vce(robust)}

{pstd}Random-effects model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, re theta}

{pstd}Random-effects model using maximum likelihood estimator{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, mle}

{pstd}Population-averaged model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
    {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, pa}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtreg, re} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if T is constant{p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:gamma}, {cmd:lnormal}){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2_w)}}R-squared within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared between model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(thta_min)}}minimum theta{p_end}
{synopt:{cmd:e(thta_5)}}theta, 5th percentile{p_end}
{synopt:{cmd:e(thta_50)}}theta, 50th percentile{p_end}
{synopt:{cmd:e(thta_95)}}theta, 95th percentile{p_end}
{synopt:{cmd:e(thta_max)}}maximum theta{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error of GLS regression{p_end}
{synopt:{cmd:e(Tbar)}}harmonic mean of group sizes{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(model)}}{cmd:re}{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(sa)}}{cmd:sa}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(bf)}}coefficient vector for fixed-effects model{p_end}
{synopt:{cmd:e(theta)}}theta{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(VCEf)}}VCE for fixed-effects model{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{pstd}
{cmd:xtreg, be} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if T is constant{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(r2_w)}}R-squared within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared between model{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(Tbar)}}harmonic mean of group sizes{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(model)}}{cmd:be}{p_end}
{synopt:{cmd:e(typ)}}{cmd:WLS}, if {cmd:wls} specified{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
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


{pstd}
{cmd:xtreg, fe} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(tss)}}total sum of squares{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if T is constant{p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:gamma}, {cmd:lnormal}){p_end}
{synopt:{cmd:e(corr)}}corr(u_i, Xb){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(r2_w)}}R-squared within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared between model{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(F_f)}}F statistic for test of u_i=0{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_f)}}p-value for test of u_i=0{p_end}
{synopt:{cmd:e(df_a)}}degrees of freedom for absorbed effect{p_end}
{synopt:{cmd:e(df_b)}}numerator degrees of freedom for F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(Tbar)}}harmonic mean of group sizes{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(model)}}{cmd:fe}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{pstd}
{cmd:xtreg, mle} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(model)}}{cmd:ml}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(distrib)}}{cmd:Gaussian}; the distribution of the RE{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
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


{pstd}
{cmd:xtreg, pa} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(tol)}}target tolerance{p_end}
{synopt:{cmd:e(dif)}}achieved tolerance{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtgee}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:xtreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(model)}}{cmd:pa}{p_end}
{synopt:{cmd:e(family)}}{cmd:Gaussian}{p_end}
{synopt:{cmd:e(link)}}{cmd:identity}; link function{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(scale)}}{cmd:x2}, {cmd:dev}, {cmd:phi}, or {it:#}; scale
               parameter{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(rgf)}}{cmd:rgf}, if {cmd:rgf} specified{p_end}
{synopt:{cmd:e(nmp)}}{cmd:nmp}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
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
