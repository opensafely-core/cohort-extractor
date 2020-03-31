{smcl}
{* *! version 1.4.9  21may2018}{...}
{viewerdialog predict "dialog ivregress_p"}{...}
{viewerdialog estat "dialog ivregress_estat"}{...}
{vieweralsosee "[R] ivregress postestimation" "mansection R ivregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{viewerjumpto "Postestimation commands" "ivregress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivregress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ivregress postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "ivregress postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "ivregress postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "ivregress postestimation##examples"}{...}
{viewerjumpto "Stored results" "ivregress postestimation##results"}{...}
{viewerjumpto "References" "ivregress postestimation##references"}{...}
{p2colset 1 33 33 2}{...}
{p2col:{bf:[R] ivregress postestimation} {hline 2}}Postestimation tools for ivregress{p_end}
{p2col:}({mansection R ivregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:ivregress}:

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb ivregress postestimation##syntax_estat:estat endogenous}}perform tests of endogeneity{p_end}
{synopt :{helpb ivregress postestimation##syntax_estat:estat firststage}}report "first-stage" regression statistics{p_end}
{synopt :{helpb ivregress postestimation##syntax_estat:estat overid}}perform tests of overidentifying restrictions{p_end}
{p2coldent:* {helpb estat sbknown}}perform tests for a structural break with a
known break date{p_end}
{p2coldent:* {helpb estat sbsingle}}perform tests for a structural break with
an unknown break date{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the {cmd:svy} prefix.
{p_end}
{p 4 6 2}
* {cmd:estat} {cmd:sbknown} and {cmd:estat} {cmd:sbsingle} work only after
  {cmd:ivregress} {cmd:2sls}.
{p_end}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star2
INCLUDE help post_hausman_star2
INCLUDE help post_lincom
{synopt:{helpb ivregress_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb ivregress postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{phang}
+ {cmd:forecast} and {cmd:hausman} are not appropriate with {cmd:svy}
estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivregresspostestimationRemarksandexamples:Remarks and examples}

        {mansection R ivregresspostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{p 8 16 2}
{cmd:predict} {dtype} 
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin} {cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{p2col :{opt stdp}}standard error of the prediction{p_end}
{p2col :{opt stdf}}standard error of the forecast{p_end}
{p2col :{opt pr(a,b)}}Pr({it:a} < y < {it:b}) under exogeneity and normal errors{p_end}
{p2col :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}) under exogeneity and normal errors{p_end}
{p2col :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-} under exogeneity and normal errors{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.
{p_end}

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, residuals, standard errors, probabilities, and expected
values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt residuals} calculates the residuals, that is, y - xb.  These are
based on the estimated equation when the observed values of the endogenous
variables are used -- not the projections of the instruments
onto the endogenous variables.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  This is also referred to as the standard
error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{it:{mansection R regresspostestimationMethodsandformulas:Methods and formulas}} in
{hi:[R] regress postestimation}. 

{phang}
{opt pr(a,b)} calculates {bind:Pr({it:a} < xb + u < {it:b})}, the
probability that y|x would be observed in the interval ({it:a},{it:b})
under exogeneity and assuming errors are normally distributed.

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names; {it:lb} and 
{it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates
{bind:Pr({it:lb} < xb + u < {it:ub})}; and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(20 < xb + u < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} .)} means minus infinity;
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates
{bind:Pr(-infinity < xb + u < 30)} in
observations for which {bind:{it:lb} {ul:>} .}{break} 
and calculates {bind:Pr({it:lb} < xb + u < 30)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity; {cmd:pr(20,.)} 
calculates {bind:Pr(+infinity > xb + u > 20)}; {break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(+infinity > xb + u > 20)} in
observations for which {bind:{it:ub} {ul:>} .}{break}
and calculates {bind:Pr(20 < xb + u < {it:ub})} elsewhere.
{p_end}

{phang}
{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:E(xb + u | {it:a} < xb + u < {it:b})}, the expected value of
y|x conditional on y|x being in the interval ({it:a},{it:b}), meaning
y|x is truncated.  {it:a} and {it:b} are specified as they are for
{opt pr()}.  Exogeneity and normally distributed errors are assumed.

{phang}
{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} calculates E(y*), where 
{bind:y* = {it:a}} if {bind:xb + u {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb + u {ul:>} {it:b}}, and {bind:y* = xb + u} otherwise, meaning
that y* is censored.  {it:a} and {it:b} are specified as they are for
{opt pr()}.  Exogeneity and normally distributed errors are assumed.

{phang}{opt scores} calculates the scores for the model.  A new score
variable is created for each endogenous regressor, as well as an
equation-level score that applies to all exogenous variables 
and constant term (if present).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{p2col :{opt pr(a,b)}}Pr({it:a} < y < {it:b}) under exogeneity and normal errors{p_end}
{p2col :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}) under exogeneity and normal errors{p_end}
{p2col :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-} under exogeneity and normal errors{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions, probabilities, and expected values.


{marker syntax_estat}{...}
{marker estatendog}{marker estatfirst}{marker estatoverid}{...}
{title:Syntax for estat}

{pstd}Perform tests of endogeneity

{p 8 16 2}
{cmd:estat} {cmdab:endog:enous} [{varlist}] [{cmd:,} 
{cmdab:l:ags}{cmd:(}{it:#}{cmd:)} {cmd:forceweights} {cmd:forcenonrobust}]


{pstd}Report "first-stage" regression statistics

{p 8 16 2}
{cmd:estat} {cmdab:first:stage} [{cmd:,} {cmd:all} {cmd:forcenonrobust}]


{pstd}Perform tests of overidentifying restrictions

{p 8 16 2}
{cmd:estat} {cmdab:over:id} [{cmd:,} {cmdab:l:ags}{cmd:(}{it:#}{cmd:)} 
{cmd:forceweights} {cmd:forcenonrobust}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd} 
{cmd:estat endogenous} performs tests to determine whether endogenous 
regressors in the model are in fact exogenous.  After GMM estimation, 
the C (difference-in-Sargan) statistic is reported.  After 2SLS 
estimation with an unadjusted VCE, the 
{help ivregress postestimation##D1954:Durbin (1954)} and
Wu-Hausman ({help ivregress postestimation##W1974:Wu 1974};
{help ivregress postestimation##H1978:Hausman 1978})
statistics are reported.  After 2SLS with a robust or VCE,
Wooldridge's {help ivregress postestimation##W1995:(1995)}
robust score test and a 
robust regression-based test are reported.  In all cases, if the test 
statistic is significant, then the variables being tested must be 
treated as endogenous.  {cmd:estat endogenous} is not available after
LIML estimation.

{pstd}
{cmd:estat firststage} reports various statistics that measure the
relevance of the excluded exogenous variables.  By default, whether the
equation has one or more than one endogenous regressor determines what
statistics are reported.

{pstd}
{cmd:estat overid} performs tests of overidentifying restrictions.  If
the 2SLS estimator was used, 
Sargan's {help ivregress postestimation##S1958:(1958)} and
Basmann's {help ivregress postestimation##B1960:(1960)} chi-squared
tests are reported, as is 
Wooldridge's {help ivregress postestimation##W1995:(1995)} robust score test;
if the LIML estimator was used, 
Anderson and Rubin's {help ivregress postestimation##AR1950:(1950)}
chi-squared test and Basmann's F test are reported; and if the GMM estimator
was used, Hansen's {help ivregress postestimation##H1982:(1982)} J statistic
chi-squared test is reported.  A statistically significant
test statistic always indicates that the instruments may not be valid.


{marker options_estat_endog}{...}
{title:Options for estat endogenous}

{phang}
{opt lags(#)} specifies the number of lags to use for prewhitening when
computing the heteroskedasticity- and autocorrelation-consistent (HAC)
version of the score test of endogeneity.  Specifying
{cmd:lags(0)} requests no prewhitening.  This option is valid only when
the model was fit via 2SLS and an HAC covariance matrix was requested
when the model was fit.  The default is {cmd:lags(1)}.

{phang}
{opt forceweights} requests that the tests of endogeneity
be computed even though {cmd:aweight}s, {cmd:pweight}s, or
{cmd:iweight}s were used in the previous estimation.  By default, these
tests are conducted only after unweighted or frequency-weighted
estimation.  The reported critical values may be inappropriate for
weighted data, so the user must determine whether the critical values
are appropriate for a given application.

{phang}
{opt forcenonrobust} requests that the Durbin and Wu-Hausman tests be 
performed after 2SLS estimation even though a robust VCE was used at estimation
time.  This option is available only if the model was fit by 2SLS.


{marker options_estat_firststage}{...}
{title:Options for estat firststage}

{phang}
{opt all} requests that all first-stage goodness-of-fit statistics be
reported regardless of whether the model contains one or more endogenous
regressors.  By default, if the model contains one endogenous regressor,
then the first-stage R-squared, adjusted R-squared, partial R-squared, 
and F statistics are reported, whereas if the model contains multiple 
endogenous regressors, then Shea's partial R-squared and adjusted 
partial R-squared are reported instead.

{phang}
{opt forcenonrobust} requests that the minimum eigenvalue statistic and 
its critical values be reported even though a robust VCE was used at 
estimation time.  The reported critical values assume that the errors are
independent and identically distributed normal, so the user must
determine whether the critical values are appropriate for a given
application.


{marker options_estat_overid}{...}
{title:Options for estat overid}

{phang} 
{opt lags(#)} specifies the number of lags to use for prewhitening when
computing the heteroskedasticity- and autocorrelation-consistent (HAC)
version of the score test of overidentifying restrictions.  Specifying
{cmd:lags(0)} requests no prewhitening.  This option is valid only when
the model was fit via 2SLS and an HAC covariance matrix was requested
when the model was fit.  The default is {cmd:lags(1)}.

{phang}
{opt forceweights} requests that the tests of overidentifying
restrictions be computed even though {cmd:aweight}s, {cmd:pweight}s, or
{cmd:iweight}s were used in the previous estimation.  By default, these
tests are conducted only after unweighted or frequency-weighted
estimation.  The reported critical values may be inappropriate for
weighted data, so the user must determine whether the critical values
are appropriate for a given application.

{phang}
{opt forcenonrobust} requests that the Sargan and Basmann tests of
overidentifying restrictions be performed after 2SLS or LIML estimation
even though a robust VCE was used at estimation time.  These tests
assume that the errors are independent and identically distributed normal,
so the user must determine whether the critical values are appropriate
for a given application.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hsng2}{p_end}

{pstd}Fit a model via 2SLS and obtain first-stage regression diagnostics{p_end}
{phang2}{cmd:. ivregress 2sls rent pcturban (hsngval = faminc i.region)}{p_end}
{phang2}{cmd:. estat firststage}{p_end}

{pstd}Obtain the Sargan and Basmann tests of overidentifying restrictions{p_end}
{phang2}{cmd:. estat overid}

{pstd}Test whether {cmd:hsngval} can be treated as exogenous{p_end}
{phang2}{cmd:. estat endogenous}

{pstd}Fit a model with two endogenous regressors via GMM and obtain all first-stage regression diagnostics{p_end}
{phang2}{cmd:. ivregress gmm rent (hsngval pcturban = faminc i.region)}{p_end}
{phang2}{cmd:. estat firststage, all}{p_end}

{pstd}Obtain Hansen's J statistic{p_end}
{phang2}{cmd:. estat overid}

{pstd}Test whether {cmd:hsngval} can be treated as exogenous{p_end}
{phang2}{cmd:. estat endogenous hsngval}


{marker results}{...}
{title:Stored results}

{pstd}
After 2SLS estimation, {cmd:estat endogenous} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(durbin)}}Durbin chi-squared statistic{p_end}
{synopt:{cmd:r(p_durbin)}}p-value for Durbin chi-squared statistic{p_end}
{synopt:{cmd:r(wu)}}Wu-Hausman F statistic{p_end}
{synopt:{cmd:r(p_wu)}}p-value for Wu-Hausman F statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(wudf_r)}}denominator degrees of freedom for Wu-Hausman F{p_end}
{synopt:{cmd:r(r_score)}}robust score statistic{p_end}
{synopt:{cmd:r(p_r_score)}}p-value for robust score statistic{p_end}
{synopt:{cmd:r(hac_score)}}HAC score statistic{p_end}
{synopt:{cmd:r(p_hac_score)}}p-value for HAC score statistic{p_end}
{synopt:{cmd:r(lags)}}lags used in prewhitening{p_end}
{synopt:{cmd:r(regF)}}regression-based F statistic{p_end}
{synopt:{cmd:r(p_regF)}}p-value for regression-based F statistic{p_end}
{synopt:{cmd:r(regFdf_n)}}regression-based F numerator degrees of freedom{p_end}
{synopt:{cmd:r(regFdf_r)}}regression-based F denominator degrees of freedom{p_end}

{pstd}
After GMM estimation, {cmd:estat endogenous} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(C)}}C chi-squared statistic{p_end}
{synopt:{cmd:r(p_C)}}p-value for C chi-squared statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}

{pstd}
{cmd:estat firststage} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(mineig)}}minimum eigenvalue statistic{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(mineigcv)}}critical values for minimum eigenvalue statistic{p_end}
{synopt:{cmd:r(multiresults)}}Shea's partial R-squared statistics{p_end}
{synopt:{cmd:r(singleresults)}}first-stage R-squared and F statistics{p_end}

{pstd}
After 2SLS estimation, {cmd:estat overid} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(lags)}}lags used in prewhitening{p_end}
{synopt:{cmd:r(df)}}chi-squared degrees of freedom{p_end}
{synopt:{cmd:r(score)}}score chi-squared statistic{p_end}
{synopt:{cmd:r(p_score)}}p-value for score chi-squared statistic{p_end}
{synopt:{cmd:r(basmann)}}Basmann chi-squared statistic{p_end}
{synopt:{cmd:r(p_basmann)}}p-value for Basmann chi-squared statistic{p_end}
{synopt:{cmd:r(sargan)}}Sargan chi-squared statistic{p_end}
{synopt:{cmd:r(p_sargan)}}p-value for Sargan chi-squared statistic{p_end}

{pstd}
After LIML estimation, {cmd:estat overid} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(ar)}}Anderson-Rubin chi-squared statistic{p_end}
{synopt:{cmd:r(p_ar)}}p-value for Anderson-Rubin chi-squared statistic{p_end}
{synopt:{cmd:r(ar_df)}}chi-squared degrees of freedom{p_end}
{synopt:{cmd:r(basmann)}}Basmann F statistic{p_end}
{synopt:{cmd:r(p_basmann)}}p-value for Basmann F statistic{p_end}
{synopt:{cmd:r(basmann_df_n)}}F numerator degrees of freedom{p_end}
{synopt:{cmd:r(basmann_df_d)}}F denominator degrees of freedom{p_end}

{pstd}
After GMM estimation, {cmd:estat overid} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(HansenJ)}}Hansen's J chi-squared statistic{p_end}
{synopt:{cmd:r(p_HansenJ)}}p-value for Hansen's J chi-squared statistic{p_end}
{synopt:{cmd:r(J_df)}}chi-squared degrees of freedom{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker AR1950}{...}
{phang}
Anderson, T. W., and H. Rubin. 1950.
The asymptotic properties of estimates of the parameters
of a single equation in a complete system of stochastic equations.
{it:Annals of Mathematical Statistics} 21: 570-582.

{marker B1960}{...}
{phang}
Basmann, R. L. 1960.
On finite sample distributions of generalized classical linear
identifiability test statistics.
{it:Journal of the American Statistical Association} 55: 650-659.

{marker D1954}{...}
{phang}
Durbin, J. 1954.
Errors in variables.
{it:Review of the International Statistical Institute} 22: 23-32.

{marker H1982}{...}
{phang}
Hansen, L. P. 1982.
Large sample properties of generalized method of moments estimators.
{it:Econometrica} 50: 1029-1054.

{marker H1978}{...}
{phang}
Hausman, J. A. 1978.
Specification tests in econometrics.
{it:Econometrica} 46: 1251-1271.

{marker S1958}{...}
{phang}
Sargan, J. D. 1958.
The estimation of economic relationships using instrumental variables.
{it:Econometrica} 26: 393-415.

{marker W1995}{...}
{phang}
Wooldridge, J. M. 1995.
Score diagnostics for linear models estimated by two stage least
squares.
In {it:Advances in Econometrics and Quantitative Economics: Essays in Honor}
{it:of Professor C. R. Rao},
ed. G. S. Maddala, P. C. B. Phillips, and T. N. Srinivasan, 66-87.
Oxford: Blackwell.

{marker W1974}{...}
{phang}
Wu, D.-M. 1974.
Alternative tests of independence between stochastic regressors and
disturbances: Finite sample results.
{it: Econometrica} 42: 529-546.
{p_end}
