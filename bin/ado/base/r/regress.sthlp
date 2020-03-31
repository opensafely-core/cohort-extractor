{smcl}
{* *! version 1.4.19  19jun2019}{...}
{viewerdialog regress "dialog regress"}{...}
{viewerdialog "svy: regress" "dialog regress, message(-svy-) name(svy_regress)"}{...}
{vieweralsosee "[R] regress" "mansection R regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress postestimation" "help regress postestimation"}{...}
{vieweralsosee "[R] regress postestimation diagnostic plots" "help regress postestimation plots"}{...}
{vieweralsosee "[R] regress postestimation ts" "help regress postestimation ts"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[BAYES] bayes: regress" "help bayes regress"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{findalias assemreg}{...}
{vieweralsosee "[FMM] fmm: regress" "help fmm regress"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[R] hetregress" "help hetregress"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{vieweralsosee "[LASSO] Lasso intro" "help lasso intro"}{...}
{vieweralsosee "[META] meta regress" "help meta_regress"}{...}
{vieweralsosee "[TS] mswitch" "help mswitch"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "regress##syntax"}{...}
{viewerjumpto "Menu" "regress##menu"}{...}
{viewerjumpto "Description" "regress##description"}{...}
{viewerjumpto "Links to PDF documentation" "regress##linkspdf"}{...}
{viewerjumpto "Options" "regress##options"}{...}
{viewerjumpto "Examples" "regress##examples"}{...}
{viewerjumpto "Video example" "regress##video"}{...}
{viewerjumpto "Stored results" "regress##results"}{...}
{viewerjumpto "References" "regress##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] regress} {hline 2}}Linear regression{p_end}
{p2col:}({mansection R regress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt regress} {depvar} [{indepvars}] {ifin} 
[{it:{help regress##weight:weight}}]
   [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt h:ascons}}has user-supplied constant{p_end}
{synopt :{opt tsscons}}compute total sum of squares with constant; 
seldom used{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt ols},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, 
   {opt jack:knife}, {opt hc2}, or {opt hc3}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt b:eta}}report standardized beta coefficients{p_end}
{synopt :{opth ef:orm(strings:string)}}report exponentiated coefficients and
    label as {it:string}{p_end}
{synopt :{opth dep:name(varname)}}substitute dependent variable name;
programmer's option{p_end}
{synopt :{it:{help regress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{synopt :{opt nohe:ader}}suppress output header{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt plus}}make table extendable{p_end}
{synopt :{opt ms:e1}}force mean squared error to {cmd:1}{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {opt fmm}, {opt fp}, {cmd:jackknife},
{opt mfp}, {cmd:mi estimate}, {cmd:nestreg}, {cmd:rolling}, {cmd:statsby},
{cmd:stepwise}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_regress BAYES:bayes: regress} and
{manhelp fmm_regress FMM:fmm: regress}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt hascons},
{opt tsscons},
{opt vce()},
{opt beta},
{opt noheader},
{opt notable},
{opt plus},
{opt depname()},
{opt mse1},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt noheader}, {opt notable}, {opt plus}, {opt mse1}, and {opt coeflegend}
do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp regress_postestimation R:regress postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:regress} performs ordinary least-squares linear regression.
{cmd:regress} can also perform weighted estimation, compute robust and
cluster-robust standard errors, and adjust results for complex survey
designs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R regressQuickstart:Quick start}

        {mansection R regressRemarksandexamples:Remarks and examples}

        {mansection R regressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}. 

{phang}
{opt hascons} indicates that a user-defined constant or its equivalent
is specified among the independent variables in {indepvars}.  Some caution is
recommended when specifying this option, as resulting estimates may not be as
accurate as they otherwise would be.  Use of this option requires "sweeping"
the constant last, so the moment matrix must be accumulated in absolute rather
than deviation form.  This option may be safely specified when the means of
the dependent and independent variables are all reasonable and there is not
much collinearity between the independent variables.  The best
procedure is to view {opt hascons} as a reporting option -- estimate with
and without {opt hascons} and verify that the coefficients and standard errors
of the variables not affected by the identity of the constant are unchanged.

{phang}
{opt tsscons} forces the total sum of squares to be computed as though
the model has a constant, that is, as deviations from the mean of the
dependent variable.  This is a rarely used option that has an effect only when
specified with {opt noconstant}.  It affects the total sum of squares and
all results derived from the total sum of squares.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:ols}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(ols)}, the default, uses the standard variance estimator for ordinary
least-squares regression.

{pmore}
{cmd:regress} also allows the following:

{phang2}
{cmd:vce(hc2)} and {cmd:vce(hc3)} specify alternative bias corrections for
the robust variance calculation.  {cmd:vce(hc2)} and {cmd:vce(hc3)} may not be
specified with the {cmd:svy} prefix.  In the unclustered case,
{cmd:vce(robust)} uses (sigma-hat_j)^2={n/(n-k)}(u_j)^2 as an estimate of the
variance of the jth observation, where u_j is the calculated residual and
n/(n-k) is included to improve the overall estimate's small-sample properties.

{pmore2}
{cmd:vce(hc2)} instead uses u_j^2/(1-h_jj) as the observation's variance
estimate, where h_jj is the diagonal element of the hat (projection) matrix.
This estimate is unbiased if the model really is homoskedastic.
{cmd:vce(hc2)} tends to produce slightly more conservative confidence
intervals.

{pmore2}
{cmd:vce(hc3)} uses u_j^2/(1-h_jj)^2 as suggested by 
{help regress##DM1993:Davidson and MacKinnon (1993)},
who report that this method tends to produce better results when the
model really is heteroskedastic.  {cmd:vce(hc3)} produces confidence intervals
that tend to be even more conservative.

{pmore2}
See {help regress##DM1993:Davidson and MacKinnon (1993, 554-556)} and
{help regress##AP2009:Angrist and Pischke (2009, 294-308)} for more discussion
on these two bias corrections.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt beta} asks that standardized beta coefficients be reported instead of
confidence intervals.  The beta coefficients are the regression
coefficients obtained by first standardizing all variables to have a mean of 0
and a standard deviation of 1.  {opt beta} may not be specified with 
{cmd:vce(cluster} {it:clustvar}{cmd:)} or the {cmd:svy} prefix.

{phang}
{opth eform:(strings:string)} is used only in programs and ado-files that use 
{cmd:regress} to fit models other than linear regression.  {opt eform()}
specifies that the coefficient table be displayed in exponentiated form as
defined in {helpb maximize:[R] Maximize} and that {it:string} be used to label the
exponentiated coefficients in the table.

{phang}
{opth depname(varname)} is used only in programs and ado-files that use 
{cmd:regress} to fit models other than linear regression.  {opt depname()} may
be specified only at estimation time.  {it:varname} is recorded as the
identity of the dependent variable, even though the estimates are calculated
using {depvar}.  This method affects the labeling of the output -- not
the results calculated -- but could affect subsequent calculations made
by {cmd:predict}, where the residual would be calculated as deviations from
{it:varname} rather than {it:depvar}.  {opt depname()} is most typically used
when {it:depvar} is a temporary variable (see  {manhelp macro P}) used as a
proxy for {it:varname}.

{pmore}
{opt depname()} is not allowed with the {cmd:svy} prefix.

INCLUDE help displayopts_list

{pstd}
The following options are available with {cmd:regress} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses the display of the ANOVA table and summary
statistics at the top of the output; only the coefficient table is displayed.
This option is often used in programs and ado-files.

{phang}
{opt notable} suppresses display of the coefficient table.

{phang}
{opt plus} specifies that the output table be made extendable.  This option is
often used in programs and ado-files.

{phang}
{opt mse1} is used only in programs and ado-files that use {cmd:regress} to
fit models other than linear regression and is not allowed with the
{helpb svy} prefix.  {opt mse1} sets the mean squared
error to {cmd:1}, forcing the variance-covariance matrix of the
estimators to be (X'X)^-1 (see 
{mansection R regressMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] regress}) and affecting calculated standard errors.  Degrees of freedom
for t statistics is calculated as n rather than n-k.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples:  linear regression}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit a linear regression{p_end}
{phang2}{cmd:. regress mpg weight foreign}{p_end}

{pstd}Fit a better linear regression, from a physics standpoint{p_end}
{phang2}{cmd:. gen gp100m = 100/mpg}{p_end}
{phang2}{cmd:. regress gp100m weight foreign}{p_end}

{pstd}Obtain beta coefficients without refitting model{p_end}
{phang2}{cmd:. regress, beta}{p_end}

{pstd}Suppress intercept term{p_end}
{phang2}{cmd:. regress weight length, noconstant}{p_end}

{pstd}Model already has constant{p_end}
{phang2}{cmd:. regress weight length bn.foreign, hascons}{p_end}


{title:Examples:  regression with robust standard errors}

        {hline}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. generate gpmw = ((1/mpg)/weight)*100*1000}{p_end}
{phang2}{cmd:. regress gpmw foreign}{p_end}
{phang2}{cmd:. regress gpmw foreign, vce(robust)}{p_end}
{phang2}{cmd:. regress gpmw foreign, vce(hc2)}{p_end}
{phang2}{cmd:. regress gpmw foreign, vce(hc3)}{p_end}
        {hline}
{phang2}{cmd:. webuse regsmpl, clear}{p_end}
{phang2}{cmd:. regress ln_wage age c.age#c.age tenure, vce(cluster id)}{p_end}
        {hline}


{title:Example:  weighted regression}

{phang2}{cmd:. sysuse census}{p_end}
{phang2}{cmd:. regress death medage i.region [aw=pop]}{p_end}


{title:Examples:  linear regression with survey data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse highschool}

{pstd}Perform linear regression using survey data{p_end}
{phang2}{cmd:. svy: regress weight height}

{pstd}Setup{p_end}
{phang2}{cmd:. generate male = sex == 1 if !missing(sex)}

{pstd}Perform linear regression using survey data for a subpopulation{p_end}
{phang2}{cmd:. svy, subpop(male): regress weight height}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=HafqFSB9x70":Simple linear regression in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:regress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(ll)}}log likelihood under additional assumption of i.i.d. normal errors{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:regress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(model)}}{cmd:ols}{p_end}
{synopt:{cmd:e(title)}}title in estimation output when {cmd:vce()} is not
             {cmd:ols}{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
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
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker AP2009}{...}
{phang}
Angrist, J. D., and J.-S. Pischke. 2009.
{browse "http://www.stata.com/bookstore/mhe.html":{it:Mostly Harmless Econometrics: An Empiricist's Companion}.}
Princeton, NJ: Princeton University Press.

{marker DM1993}{...}
{phang}
Davidson, R., and J. G. MacKinnon. 1993.
{browse "http://www.stata.com/bookstore/eie.html":{it:Estimation and Inference in Econometrics}.}
New York: Oxford University Press.
{p_end}
