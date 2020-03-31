{smcl}
{* *! version 1.4.11  30nov2018}{...}
{viewerdialog predict "dialog regres_p"}{...}
{viewerdialog dfbeta "dialog dfbeta"}{...}
{viewerdialog estat "dialog regress_estat"}{...}
{vieweralsosee "[R] regress postestimation" "mansection R regresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] regress postestimation diagnostic plots" "help regress postestimation plots"}{...}
{vieweralsosee "[R] regress postestimation ts" "help regress postestimation ts"}{...}
{viewerjumpto "Postestimation commands" "regress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "regress_postestimation##linkspdf"}{...}
{viewerjumpto "Predictions" "regress postestimation##syntax_predict"}{...}
{viewerjumpto "Margins" "regress postestimation##syntax_margins"}{...}
{viewerjumpto "DFBETA influence statistics" "regress postestimation##syntax_dfbeta"}{...}
{viewerjumpto "Tests for violation of assumptions" "regress postestimation##syntax_estat"}{...}
{viewerjumpto "Variance inflation factors" "regress postestimation##syntax_estat_vif"}{...}
{viewerjumpto "Measures of effect size" "regress postestimation##syntax_estat_esize"}{...}
{viewerjumpto "Examples" "regress postestimation##examples"}{...}
{viewerjumpto "Stored results" "regress postestimation##results"}{...}
{viewerjumpto "References" "regress postestimation##references"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] regress postestimation} {hline 2}}Postestimation tools 
for regress{p_end}
{p2col:}({mansection R regresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:regress}: 

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb regress postestimation##syntax_dfbeta:dfbeta}}DFBETA influence statistics{p_end}
{synopt :{helpb regress postestimation##estathett:estat hettest}}tests for heteroskedasticity{p_end}
{synopt :{helpb regress postestimation##estatimtest:estat imtest}}information matrix test{p_end}
{synopt :{helpb regress postestimation##estatovt:estat ovtest}}Ramsey regression specification-error test for 
omitted variables{p_end}
{synopt :{helpb regress postestimation##estatszroeter:estat szroeter}}Szroeter's rank test for heteroskedasticity{p_end}
{synopt :{helpb regress postestimation##estatvif:estat vif}}variance inflation factors for the independent
variables{p_end}
{synopt :{helpb regress postestimation##syntax_estat_esize:estat esize}}eta-squared, epsilon-squared, and omega-squared effect sizes{p_end}
{synopt :{helpb estat moran}}Moran's test of residual correlation with nearby residuals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the {cmd:svy} prefix.
{p_end}


{pstd}
The following standard postestimation commands are also available:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb regress_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb regress postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.  {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R regresspostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:Predictions}

{title:Syntax for predict}

{p 8 19 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt sc:ore}}score; equivalent to {opt residuals}{p_end}
{synopt :{opt rsta:ndard}}standardized residuals{p_end}
{synopt :{opt rstu:dent}}Studentized (jackknifed) residuals{p_end}
{synopt :{opt c:ooksd}}Cook's distance{p_end}
{synopt :{opt l:everage} | {opt h:at}}leverage (diagonal elements of 
hat matrix){p_end}
{synopt :{opt pr}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}}Pr(y | {it:a} < y < {it:b}){p_end}
{synopt :{opt e(a,b)}}{it:E}(y | {it:a} < y < {it:b}){p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{cmd:(}{it:a},min(y,{it:b}){cmd:)}{p_end}
{p2coldent:* {opth dfb:eta(varname)}}DFBETA for {it:varname}{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt stdf}}standard error of the forecast{p_end}
{synopt :{opt stdr}}standard error of the residual{p_end}
{p2coldent:* {opt cov:ratio}}COVRATIO{p_end}
{p2coldent:* {opt dfi:ts}}DFITS{p_end}
{p2coldent:* {opt w:elsch}}Welsch distance{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Unstarred statistics are available both in and out of sample; 
{cmd:type predict ... if e(sample) ...} if wanted only for the estimation
sample.  Starred statistics are calculated only for the estimation sample,
even when {cmd:if} {cmd:e(sample)} is not specified.{p_end}
{p 4 6 2}
{opt rstandard},
{opt rstudent},
{opt cooksd},
{opt leverage},
{opt dfbeta()},
{opt stdf},
{opt stdr},
{opt covratio},
{opt dfits},
and {opt welsch} are not available if any
{opt vce()} other than {cmd:vce(ols)} was specified with {cmd:regress}.
{p_end}
{p 4 6 2}
{opt xb},
{opt residuals},
{opt score},
and
{opt stdp}
are the only options allowed with {cmd:svy} estimation results.
{p_end}

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, residuals, standardized residuals, Studentized
residuals, Cook's distance, leverage, probabilities, expected values,
DFBETAs for {it:varname}, standard errors, COVRATIOs, DFITS, and Welsch
distances.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt score} is equivalent to {opt residuals} in linear regression.

{phang}
{opt rstandard} calculates the standardized residuals.

{phang}
{opt rstudent} calculates the Studentized (jackknifed) residuals.

{phang}
{opt cooksd} calculates the Cook's D influence statistic
({help regress postestimation##C1977:Cook 1977}).

{phang}
{opt leverage} or {opt hat} calculates the diagonal elements of the
projection ("hat") matrix.

INCLUDE help pr_opt

{phang}
{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:{it:E}(xb+u | {it:a} < xb+u < {it:b})}, the expected value of y|x
conditional on y|x being in the interval ({it:a},{it:b}), meaning that y|x is
truncated. {it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} calculates {it:E}(y*),
where {bind:y* = {it:a}} if {bind:xb+u {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb+u {ul:>} {it:b}}, and {bind:y* = xb+u} otherwise, meaning that y* is
censored.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{opth dfbeta(varname)} calculates the DFBETA for {it:varname}, the difference
between the regression coefficient when the jth observation is included and
excluded, said difference being scaled by the estimated standard error of the
coefficient.  {it:varname} must have been included among the regressors in the
previously fitted model.  The calculation is automatically restricted to the
estimation subsample.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{mansection R regresspostestimationMethodsandformulas:{it:Methods and formulas}} in {bf:[R] regress postestimation}.

{phang}
{opt stdr} calculates the standard error of the residuals.

{phang}
{opt covratio} calculates COVRATIO
({help regress postestimation##BKW1980:Belsley, Kuh, and Welsch 1980}),
a measure
of the influence of the jth observation based on considering the effect on the
variance-covariance matrix of the estimates.  The calculation is automatically
restricted to the estimation subsample.

{phang}
{opt dfits} calculates DFITS
({help regress postestimation##WK1977:Welsch and Kuh 1977})
and attempts to summarize
the information in the leverage versus residual-squared plot into one
statistic.  The calculation is automatically restricted to the estimation
subsample.

{phang}
{opt welsch} calculates Welsch distance
({help regress postestimation##W1982:Welsch 1982}) and is a variation on
{opt dfits}.  The calculation is automatically restricted to the estimation
subsample.


{marker margins}{...}
{marker syntax_margins}{...}
{title:Margins}

INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt e(a,b)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ys:tar(a,b)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rsta:ndard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rstu:dent}}not allowed with {cmd:margins}{p_end}
{synopt :{opt c:ooksd}}not allowed with {cmd:margins}{p_end}
{synopt :{opt l:everage} | {opt h:at}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dfb:eta(varname)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdr}}not allowed with {cmd:margins}{p_end}
{synopt :{opt cov:ratio}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dfi:ts}}not allowed with {cmd:margins}{p_end}
{synopt :{opt w:elsch}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker syntax_dfbeta}{...}
{title:DFBETA influence statistics}

{title:Syntax for dfbeta}

{p 8 18 2}
{cmd:dfbeta} [{it:{help indepvars:indepvar}}
		[{it:{help indepvars:indepvar}} [...]]]
		[{cmd:,} {opt stub(name)}]


{title:Menu for dfbeta}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
            {bf:DFBETAs}


{title:Description for dfbeta}

{pstd}
{opt dfbeta} will calculate one, more than one, or all the DFBETAs after 
{cmd:regress}.  Although {opt predict} will also calculate DFBETAs, 
{cmd:predict} can do this for only one variable at a time.  {opt dfbeta} is
a convenience tool for those who want to calculate DFBETAs for multiple
variables.  The names for the new variables created are chosen automatically
and begin with the letters {cmd:_dfbeta_}.


{marker option_dfbeta}{...}
{title:Option for dfbeta}

{phang}
{opt stub(name)} specifies the leading characters {cmd:dfbeta} uses to name
the new variables to be generated.  The default is {cmd:stub(_dfbeta_)}.


{marker estathett}{marker estatimtest}{marker estatovt}{...}
{marker estatszroeter}{marker syntax_estat}{...}
{title:Tests for violation of assumptions}

{title:Syntax for estat hettest}

{p 8 17 2}
{cmd:estat} {opt hett:est} [{varlist}] 
   [{cmd:,} {opt r:hs} [{opt no:rmal} | {opt ii:d} | 
   {opt fs:tat}] {opt m:test}[{cmd:(}{it:spec}{cmd:)}]]


INCLUDE help menu_estat


{title:Description for estat hettest}

{pstd}
{opt estat hettest} performs three versions of the 
{help regress postestimation##BP1979:Breusch-Pagan (1979)} and
{help regress postestimation##CW1983:Cook-Weisberg (1983)}
test for heteroskedasticity.  All three
versions of this test present evidence against the null hypothesis that
t=0 in Var(e)=sigma^2 exp(zt).  In
the {cmd:normal} version, performed by default, the null hypothesis also
includes the assumption that the regression disturbances are
independent-normal draws with variance sigma^2.  The normality assumption
is dropped from the null hypothesis in the {cmd:iid} and {cmd:fstat}
versions, which respectively produce the score and F tests discussed in
{mansection R regresspostestimationMethodsandformulas:{it:Methods and formulas}} in {bf:[R] regress postestimation}.
If {varlist} is not specified, the fitted values are used for z.  If
{it:varlist} or the {opt rhs} option is specified, the variables specified are
used for z.


{marker options_estat_hettest}{...}
{title:Options for estat hettest}

{phang}
{opt rhs} specifies that tests for heteroskedasticity be performed for the
right-hand-side (explanatory) variables of the fitted regression model.
The {opt rhs} option may be combined with a {varlist}, in which case the
the variables in {it:varlist} are included in the model for the variance along
with the explanatory variables.

{phang}
{opt normal}, the default, causes {opt estat hettest} to compute the
original Breusch-Pagan/Cook-Weisberg test, which assumes that the regression
disturbances are normally distributed.

{phang}
{opt iid} causes {opt estat hettest} to compute the N*R2 version of the
score test that drops the normality assumption.

{phang}
{opt fstat} causes {opt estat hettest} to compute the F-statistic version
that drops the normality assumption.

{phang}
{opt mtest}[{cmd:(}{it:spec}{cmd:)}] specifies that multiple testing be
performed.  The argument specifies how p-values are adjusted.  The following
specifications, {it:spec}, are supported:

        {opt b:onferroni}    Bonferroni's multiple testing adjustment
        {opt h:olm}          Holm's multiple testing adjustment
        {opt s:idak}         Sidak's multiple testing adjustment
        {opt noadj:ust}      no adjustment is made for multiple testing

{pmore}
{opt mtest} may be specified without an argument.  This is equivalent to
specifying {cmd:mtest(noadjust)}; that is, tests for the individual variables
should be performed with unadjusted p-values.  By default, {opt estat hettest}
does not perform multiple testing.
{opt mtest} may not be specified with {opt iid} or {opt fstat}.


{title:Syntax for estat imtest}

{p 8 17 2}
{cmd:estat} {opt imt:est} [{cmd:,} {opt p:reserve} {opt wh:ite}]


INCLUDE help menu_estat


{title:Description for estat imtest}

{pstd}
{opt estat imtest} performs an information matrix test for the regression
model and an orthogonal decomposition into tests for heteroskedasticity,
skewness, and kurtosis due to 
{help regress postestimation##CT1990:Cameron and Trivedi (1990)};
White's test for homoskedasticity against unrestricted forms of
heteroskedasticity ({help regress postestimation##W1980:1980}) is
available as an option.  White's test is usually similar to the first term of
the Cameron-Trivedi decomposition.


{marker options_estat_imtest}{...}
{title:Options for estat imtest}

{phang}
{opt preserve} specifies that the data in memory be preserved, all variables
and cases that are not needed in the calculations be dropped, and at the
conclusion the original data be restored.  This option is costly for large
datasets.  However, because {opt estat imtest} has to perform an auxiliary
regression on k(k+1)/2 temporary variables, where k is the number of
regressors, it may not be able to perform the test otherwise.

{phang}
{opt white} specifies that White's original heteroskedasticity test also be
performed.


{title:Syntax for estat ovtest}

{p 8 17 2}
{cmd:estat} {opt ovt:est} [{cmd:,} {opt r:hs}]


INCLUDE help menu_estat


{title:Description for estat ovtest}

{pstd}
{opt estat ovtest} performs two versions of the 
{help regress postestimation##R1969:Ramsey (1969)} regression
specification-error test (RESET) for omitted variables.  This test amounts to
fitting {bind:y=xb+zt+u} and then testing {bind:t=0}.  If the {opt rhs} option
is not specified, powers of the fitted values are used for z.  If {opt rhs} is
specified, powers of the individual elements of x are used.


{marker option_estat_ovtest}{...}
{title:Option for estat ovtest}

{phang}
{opt rhs} specifies that powers of the right-hand-side (explanatory) variables
be used in the test rather than powers of the fitted values.


{title:Syntax for estat szroeter}

{p 8 17 2}
{cmd:estat} {opt szr:oeter} [{varlist}] 
   [{cmd:,} {opt r:hs} {opt m:test}{cmd:(}{it:spec}{cmd:)}]

{phang2}
Either {it:varlist} or {cmd:rhs} must be specified.
 

INCLUDE help menu_estat


{title:Description for estat szroeter}

{pstd}
{opt estat szroeter} performs Szroeter's rank test for heteroskedasticity for
each of the variables in {it:varlist} or for the explanatory variables of the
regression if {opt rhs} is specified.


{marker options_estat_szroeter}{...}
{title:Options for estat szroeter}

{phang}
{opt rhs} specifies that tests for heteroskedasticity be performed for the
right-hand-side (explanatory) variables of the fitted regression model.
The {opt rhs} option may be combined with a {varlist}.

{phang}
{opt mtest}{cmd:(}{it:spec}{cmd:)} specifies that multiple testing be
performed.  The argument specifies how p-values are adjusted.  The following
specifications, {it:spec}, are supported:

        {opt b:onferroni}    Bonferroni's multiple testing adjustment
        {opt h:olm}          Holm's multiple testing adjustment
        {opt s:idak}         Sidak's multiple testing adjustment
        {opt noadj:ust}      no adjustment is made for multiple testing

{pmore}
{opt estat szroeter} always performs multiple testing.  By default, it does
not adjust the p-values.


{marker syntax_estat_vif}{...}
{title:Variance inflation factors}

{title:Syntax for estat vif}

{marker estatvif}{...}
{p 8 17 2}
{cmd:estat vif} [{cmd:,} {opt unc:entered}]


INCLUDE help menu_estat


{title:Description for estat vif}

{pstd}
{opt estat vif} calculates the centered or uncentered variance inflation
factors (VIFs) for the independent variables specified in a linear regression
model.


{marker option_estat_vif}{...}
{title:Option for estat vif}

{phang}
{opt uncentered} requests that the computation of the uncentered variance
inflation factors.  This option is often used to detect the collinearity of
the regressors with the constant.  {cmd:estat vif, uncentered} may be used
after regression models fit without the constant term.


{marker syntax_estat_esize}{...}
{title:Measures of effect size}

{title:Syntax for estat esize}

{p 8 14 2}
{cmd:estat esize}
[{cmd:,}
{opt eps:ilon} {opt om:ega} {opt l:evel(#)}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description for estat esize}

{pstd}
{cmd:estat} {cmd:esize} calculates effect sizes for linear models after
{helpb regress} or {helpb anova}.  By default, {cmd:estat} {cmd:esize} reports
eta-squared estimates (Kerlinger {help regress postestimation##K1964:1964}),
which are equivalent to R-squared estimates.  If the option {opt epsilon}
is specified, {cmd:estat} {cmd:esize} reports epsilon-squared estimates
(Grisson and Kim {help regress postestimation##GK2012:2012}).
If the option {opt omega} is
specified, {cmd:estat} {cmd:esize} reports omega-squared estimates
(Grisson and Kim {help regress postestimation##GK2012:2012}).
Both epsilon-squared and omega-squared are adjusted R-squared estimates.
Confidence intervals for eta-squared estimates are estimated
by using the noncentral F distribution
(Smithson {help regress postestimation##S2001:2001}).  See
Kline ({help regress postestimation##K2013:2013}) or
Thompson ({help regress postestimation##T2006:2006}) for further information.


{marker option_estat_esize}{...}
{title:Options for estat esize}

{phang}
{opt epsilon} specifies that the epsilon-squared estimates of effect size be
reported.  The default is eta-squared estimates.

{phang}
{opt omega} specifies that the omega-squared estimates of effect size be
	reported.  The default is eta-squared estimates.

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight foreign}{p_end}

{pstd}Obtain predicted values{p_end}
{phang2}{cmd:. predict pmpg}{p_end}
{phang2}{cmd:. summarize pmpg mpg}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse newautos, clear}{p_end}

{pstd}Obtain out-of-sample prediction{p_end}
{phang2}{cmd:. predict mpg}{p_end}

{pstd}Obtain standard error of the forecast{p_end}
{phang2}{cmd:. predict se_mpg, stdf}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. regress mpg weight c.weight#c.weight foreign}{p_end}

{pstd}Diagonal elements of projection matrix{p_end}
{phang2}{cmd:. predict xdist, hat}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. regress price weight foreign##c.mpg}{p_end}

{pstd}Leverage-versus-residual-squared plot{p_end}
{phang2}{cmd:. lvr2plot}{p_end}

{pstd}Standardized residuals{p_end}
{phang2}{cmd:. predict esta if e(sample), rstandard}{p_end}

{pstd}Studentized residuals{p_end}
{phang2}{cmd:. predict estu if e(sample), rstudent}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. regress price weight foreign##c.mpg}{p_end}

{pstd}DFITS influence measure{p_end}
{phang2}{cmd:. predict dfits, dfits}{p_end}

{pstd}Cook's distance{p_end}
{phang2}{cmd:. predict cooksd if e(sample), cooksd}{p_end}

{pstd}Welsch distance{p_end}
{phang2}{cmd:. predict wd, welsch}{p_end}

{pstd}COVRATIO influence measure{p_end}
{phang2}{cmd:. predict covr, covratio}{p_end}

{pstd}DFBETAs influence measure{p_end}
{phang2}{cmd:. sort foreign make}{p_end}
{phang2}{cmd:. predict dfor, dfbeta(1.foreign)}{p_end}

{pstd}DFBETAs for all variables in regression{p_end}
{phang2}{cmd:. dfbeta}{p_end}

{pstd}Ramsey's test for omitted variables{p_end}
{phang2}{cmd:. estat ovtest}{p_end}

{pstd}Test for heteroskedasticity{p_end}
{phang2}{cmd:. estat hettest}{p_end}
{phang2}{cmd:. estat hettest weight foreign##c.mpg, mtest(b)}{p_end}

{pstd}Rank test for heteroskedasticity{p_end}
{phang2}{cmd:. estat szroeter, rhs mtest(holm)}{p_end}

{pstd}Tests for heteroskedasticity, skewness, and kurtosis{p_end}
{phang2}{cmd:. estat imtest}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse bodyfat, clear}{p_end}
{phang2}{cmd:. regress bodyfat tricep thigh midarm}{p_end}

{pstd}Variance inflation factors{p_end}
{phang2}{cmd:. estat vif}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2}

{pstd}Regress systolic blood pressure on age group, sex, and their interaction{p_end}
{phang2}{cmd:. regress bpsystol agegrp##sex}

{pstd}Predictive margins of blood pressure for age groups{p_end}
{phang2}{cmd:. margins agegrp}

{pstd}Profile plot of margins{p_end}
{phang2}{cmd:. marginsplot}

{pstd}Margins for interaction between age group and sex{p_end}
{phang2}{cmd:. margins agegrp#sex}

{pstd}Interaction plot{p_end}
{phang2}{cmd:. marginsplot}

{pstd}Estimate for each age group a contrast comparing men and women{p_end}
{phang2}{cmd:. margins r.sex@agegrp}

{pstd}Plot contrasts and confidence intervals against age group{p_end}
{phang2}{cmd:. marginsplot}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}{p_end}

{pstd}Effect size for linear models after {cmd:regress}{p_end}
{phang2}{cmd:. regress bwt smoke i.race}{p_end}
{phang2}{cmd:. estat esize}{p_end}
{phang2}{cmd:. estat esize, level(90)}{p_end}
{phang2}{cmd:. estat esize, omega}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat hettest} stores the following results for the (multivariate) score
test in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared test statistic{p_end}
{synopt:{cmd:r(df)}}#df for the asymptotic chi-squared distribution under
	H_0{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}

{pstd}
{cmd:estat hettest, fstat} stores the results for the (multivariate) score test
in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(F)}}test statistic{p_end}
{synopt:{cmd:r(df_m)}}#df of the test for the F distribution under H_0{p_end}
{synopt:{cmd:r(df_r)}}#df of the residuals for the F distribution under
        H_0{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}

{pstd}
{cmd:estat hettest} (if {cmd:mtest} is specified) and {cmd:estat szroeter}
stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(mtest)}}a matrix of test results, with rows corresponding to
the univariate tests{p_end}

       {cmd:mtest[.,1]}    chi-squared test statistic
       {cmd:mtest[.,2]}    #df
       {cmd:mtest[.,3]}    unadjusted p-value
       {cmd:mtest[.,4]}    adjusted p-value (if an {cmd:mtest()} adjustment
                             method is specified)

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(mtmethod)}}adjustment method for p-value{p_end}

{pstd}
{cmd:estat imtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2_t)}}IM-test statistic (= {cmd:r(chi2_h)} + {cmd:r(chi2_s)}
+ {cmd:r(chi2_k)}){p_end}
{synopt:{cmd:r(df_t)}}df for limiting chi-squared distribution under H_0 (=
{cmd:r(df_h)} + {cmd:r(df_s)} + {cmd:r(df_k)}){p_end}
{synopt:{cmd:r(chi2_h)}}heteroskedasticity test statistic{p_end}
{synopt:{cmd:r(df_h)}}df for limiting chi-squared distribution under H_0{p_end}
{synopt:{cmd:r(chi2_s)}}skewness test statistic{p_end}
{synopt:{cmd:r(df_s)}}df for limiting chi-squared distribution under H_0{p_end}
{synopt:{cmd:r(chi2_k)}}kurtosis test statistic{p_end}
{synopt:{cmd:r(df_k)}}df for limiting chi-squared distribution under H_0{p_end}
{synopt:{cmd:r(chi2_w)}}White's heteroskedasticity test (if {cmd:white}
specified){p_end}
{synopt:{cmd:r(df_w)}}df for limiting chi-squared distribution under H_0{p_end}

{pstd}
{cmd:estat ovtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{p2colreset}{...}

{pstd}
{cmd:estat esize} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}
{synoptset 15 tabbed}{...}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(esize)}}a matrix of effect sizes, confidence intervals, degrees
of freedom, and F statistics with rows corresponding to each term in the
model{p_end}
{p2colreset}{...}

       {cmd:esize[.,1]}    eta-squared
       {cmd:esize[.,2]}    lower confidence bound for eta-squared
       {cmd:esize[.,3]}    upper confidence bound for eta-squared
       {cmd:esize[.,4]}    epsilon-squared
       {cmd:esize[.,5]}    omega-squared
       {cmd:esize[.,6]}    numerator degrees of freedom
       {cmd:esize[.,7]}    denominator degrees of freedom
       {cmd:esize[.,8]}    F statistic


{marker references}{...}
{title:References}

{marker BKW1980}{...}
{phang}
Belsley, D. A., E. Kuh, and R. E. Welsch. 1980. {it:Regression Diagnostics:}
{it:Identifying Influential Data and Sources of Collinearity}.
New York: Wiley.

{marker BP1979}{...}
{phang}
Breusch, T. S., and A. R. Pagan. 1979. A simple test for heteroscedasticity and
random coefficient variation. {it:Econometrica} 47: 1287-1294.

{marker CT1990}{...}
{phang}
Cameron, A. C., and P. K. Trivedi. 1990. The information matrix test and its
applied alternative hypotheses. Working Paper 372, University of
California-Davis, Institute of Governmental Affairs.

{marker C1977}{...}
{phang}
Cook, R. D. 1977. Detection of influential observations in linear regression.
{it:Technometrics} 19: 15-18.

{marker CW1983}{...}
{phang}
Cook, R. D., and S. Weisberg. 1983.  Diagnostics for heteroscedasticity in
regression. {it:Biometrika} 70: 1-10.

{marker GK2012}{...}
{phang}
Grissom, R. J., and J. J. Kim. 2012.
{it:Effect Sizes for Research: Univariate and Multivariate Applications.}
2nd ed.  New York: Routledge.

{marker K1964}{...}
{phang}
Kerlinger, F. N. 1964.
{it:Foundations of Behavioral Research}.
New York: Holt, Rinehart & Winston.

{marker K2013}{...}
{phang}
Kline, R. B. 2013.
{it:Beyond Significance Testing: Statistics Reform in the Behavioral Sciences}.
2nd ed.  Washington, DC: American Psychological Association.

{marker M1986}{...}
{phang}
Mallows, C. L. 1986. Augmented partial residuals. {it:Technometrics} 28:
313-319.

{marker R1969}{...}
{phang}
Ramsey, J. B. 1969.  Tests for specification errors in classical linear
least-squares regression analysis.  {it:Journal of the Royal Statistical}
{it:Society, Series B} 31: 350-371.

{marker S2001}{...}
{phang}
Smithson, M. 2001.
Correct confidence intervals for various regression effect sizes and
parameters: The importance of noncentral distributions in computing intervals.
{it:Educational and Psychological Measurement} 61: 605-632.

{marker T2006}{...}
{phang}
Thompson, B. 2006.
{it:Foundations of Behavioral Statistics: An Insight-Based Approach}.
New York: Guilford Press.

{marker W1982}{...}
{phang}
Welsch, R. E. 1982. Influence functions and regression diagnostics. In 
{it:Modern Data Analysis}, ed. R. L. Launer and A. F. Siegel, 149-169.
New York: Academic Press.

{marker WK1977}{...}
{phang}
Welsch, R. E., and E. Kuh. 1977.  Linear Regression Diagnostics.
Technical Report 923-77, Massachusetts Institute of Technology,
Cambridge, MA.

{marker W1980}{...}
{phang}
White, H. 1980. A heteroskedasticity-consistent covariance matrix estimator and
a direct test for heteroskedasticity. {it:Econometrica} 48: 817-838.
{p_end}
