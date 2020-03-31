{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta bias" "mansection META metabias"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta funnelplot" "help meta funnelplot"}{...}
{vieweralsosee "[META] meta regress" "help meta regress"}{...}
{vieweralsosee "[META] meta summarize" "help meta summarize"}{...}
{vieweralsosee "[META] meta trimfill" "help meta trimfill"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_bias##syntax"}{...}
{viewerjumpto "Menu" "meta_bias##menu"}{...}
{viewerjumpto "Description" "meta_bias##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_bias##linkspdf"}{...}
{viewerjumpto "Options" "meta_bias##options"}{...}
{viewerjumpto "Examples" "meta_bias##examples"}{...}
{viewerjumpto "Stored results" "meta_bias##results"}{...}
{viewerjumpto "References" "meta_bias##references"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[META] meta bias} {hline 2}}Tests for small-study effects in
meta-analysis{p_end}
{p2col:}({mansection META metabias:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Regression-based tests for small-study effects

{pmore}
Test using meta-analysis model as declared with meta set or meta esize

{p 12 16 2}
{cmd:meta bias}
[{help varlist:{it:moderators}}]
{ifin}{cmd:,}
{help meta_bias##regtest:{it:regtest}}
[{help meta_bias##modelopts:{it:modelopts}}]


{pmore}
Random-effects meta-analysis model

{p 12 16 2}
{cmd:meta bias}
[{help varlist:{it:moderators}}]
{ifin}{cmd:,}
{help meta_bias##regtest:{it:regtest}}
{cmd:random}[{cmd:(}{help meta_funnelplot##remethod:{it:remethod}}{cmd:)}]
[{opth se:(meta_bias##seadj:seadj)}
{help meta_bias##optstbl:{it:options}}]


{pmore}
Common-effect meta-analysis model

{p 12 16 2}
{cmd:meta bias}
{ifin}{cmd:,}
{help meta_bias##regtest:{it:regtest}}
{cmd:common}
[{help meta_bias##optstbl:{it:options}}]


{pmore}
Fixed-effects meta-analysis model

{p 12 16 2}
{cmd:meta bias}
[{help varlist:{it:moderators}}]
{ifin}{cmd:,}
{help meta_bias##regtest:{it:regtest}}
{cmd:fixed}
[{opt mult:iplicative}
{help meta_bias##optstbl:{it:options}}]


{pmore}
Traditional test

{p 12 16 2}
{cmd:meta bias}
{ifin}{cmd:,}
{help meta_bias##regtest:{it:regtest}}
{opt trad:itional}
[{help meta_bias##optstbl:{it:options}}]



{pstd}
Nonparametric rank correlation test for small-study effects

{p 12 16 2}
{cmd:meta bias}
{ifin}{cmd:,} {cmd:begg}
[[{cmd:no}]{opt metashow} {opt detail}]


{marker regtest}{...}
{synoptset 22}{...}
{synopthdr:regtest}
{synoptline}
{synopt :{opt egger}}Egger's test{p_end}
{synopt :{opt harb:ord}}Harbord's test{p_end}
{synopt :{opt peters}}Peters's test{p_end}
{synoptline}

{marker modelopts}{...}
{pstd}
{it:modelopts} is any option relevant for the declared model.

{synoptset 22}{...}
INCLUDE help meta_remethod

{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt tdist:ribution}}report t test instead of z test{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}
{synopt :{opt detail}}display intermediate estimation results{p_end}

{syntab:Maximization}
{synopt :{help meta_bias##maxopts:{it:maximize_options}}}control the maximization process of the between-study variance{p_end}
{synoptline}
{p 4 6 2}
{it:moderators} may contain factor variables; see {help fvvarlist}.


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta bias} performs tests for the presence of 
{help meta_glossary##small_study_effects:small-study effects}
in a meta-analysis, also known as tests for funnel-plot asymmetry and
publication-bias tests.  Three regression-based tests and a nonparametric rank
correlation test are available.  For regression-based tests, you can include
moderators to account for potential between-study heterogeneity.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metabiasQuickstart:Quick start}

        {mansection META metabiasRemarksandexamples:Remarks and examples}

        {mansection META metabiasMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{pstd}
One of {cmd:egger}, {cmd:harbord}, {cmd:peters}, or {cmd:begg} (or their
synonyms) must be specified.  In addition to the traditional versions of the
regression-based tests, their random-effects versions and extensions to allow
for moderators are also available.

{phang}
{cmd:egger} (synonym {cmd:esphillips}) specifies that the regression-based
test of {help meta_bias##eggeretal1997:Egger et al. (1997)} be performed.
This test is known as the Egger test in the literature.  This is the test of
the slope in a weighted regression of the effect size, {cmd:_meta_es}, on its
standard error, {cmd:_meta_se}, optionally adjusted for {it:moderators}.  This
test tends to have an inflated type I error rate for binary outcomes.

{phang}
{cmd:harbord} (synonym {cmd:hesterne}) specifies that the regression-based
test of
{help meta_bias##harbordeggersterne2006:Harbord, Egger, and Sterne (2006)}
be performed.  This test is known as the Harbord test.  This is the test of
the slope in a weighted regression of Z_j/V_j on 1/√(V_j), optionally
adjusting for {it:moderators}, where Z_j is the score of the likelihood
function and V_j is the score variance.  This test is used for binary data
with effect sizes log odds-ratio and log risk-ratio.  It was designed to
reduce the correlation between the effect-size estimates and their
corresponding standard errors, which is inherent to the Egger test with binary
data.

{phang}
{cmd:peters} (synonym {cmd:petersetal}) specifies that the regression-based
test of {help meta_bias##petersetal2006:Peters et al. (2006)} be performed.
This test is known as the Peters test in the literature.  This is the test of
the slope in a weighted regression of the effect size, {cmd:_meta_es}, on the
inverse sample size, 1/n_j, optionally adjusted for {it:moderators}.  The
Peters test is used with binary data for log odds-ratios.  Because it
regresses effect sizes on inverse sample sizes, they are independent by
construction.

{phang}
{cmd:begg} (synonym {cmd:bmazumdar}) specifies that the nonparametric rank
correlation test of
{help meta_bias##beggmazumdar1994:Begg and Mazumdar (1994)} be performed.
This is not a regression-based test, so only options {cmd:metashow},
{cmd:nometashow}, and {cmd:detail} are allowed with it.  This test is known as
the Begg test in the literature.  This test is no longer recommended in the
literature and provided for completeness.

{pstd}
Options {cmd:random()}, {cmd:common}, and {cmd:fixed}, when specified with
{cmd:meta bias} for regression-based tests, temporarily override the global
model declared by {helpb meta set} or {helpb meta esize} during the
computation.  Options {cmd:random()}, {cmd:common}, and {cmd:fixed} may not be
combined.  If these options are omitted, the declared meta-analysis model is
assumed; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  Also see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
in {bf:[META] Intro}.

{phang}
{opt random} and {opt random(remethod)} specify that a random-effects model be
assumed for regression-based test; see
{mansection META IntroRemarksandexamplesRandom-effectsmodel:{it:Random-effects model}}
in {bf:[META] Intro}.

{marker remethoddes}{...}
{phang2}
{it:remethod} specifies the type of estimator for the between-study variance
τ^2.  {it:remethod} is one of {cmd:reml}, {cmd:mle}, {cmd:ebayes},
{cmd:dlaird}, {cmd:sjonkman}, {cmd:hedges}, or {cmd:hschmidt}.  {cmd:random}
is a synonym for {cmd:random(reml)}.  See
{help meta_esize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{cmd:common} specifies that a common-effect model be assumed for
regression-based test; see
{mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.
{cmd:common} is not allowed in the presence of {it:moderators}.

{phang}
{cmd:fixed} specifies that a fixed-effects model be assumed for
regression-based test; see
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{marker seadj}{...}
{phang}
{opt se(seadj)} specifies that the adjustment {it:seadj} be applied to the
standard errors of the coefficients.  Additionally, the tests of significance
of the coefficients are based on a Student's t distribution instead of the
normal distribution.  {cmd:se()} is allowed only with random-effects models.

{phang2}
{it:seadj} is {opt kh:artung}[{cmd:,} {opt trunc:ated}].  Adjustment
{cmd:khartung} specifies that the Knapp–Hartung adjustment
({help meta_bias##hartungknapp2001a:Hartung and Knapp 2001a},
{help meta_bias##hartungknapp2001b:2001b};
{help meta_bias##knapphartung2003:Knapp and Hartung 2003}),
also known as the Sidik–Jonkman adjustment
({help meta_bias##sidikjonkman2002:Sidik and Jonkman 2002}),
be applied to the standard errors of the coefficients.  {cmd:hknapp} and
{cmd:sjonkman} are synonyms for {cmd:khartung}.  {cmd:truncated} specifies that
the truncated Knapp–Hartung adjustment
{help meta_bias##knapphartung2003:Knapp and Hartung 2003}),
also known as the modified Knapp–Hartung adjustment, be used.

{phang}
{opt traditional} specifies that the traditional version of the selected
regression-based test be performed.  This option is equivalent to specifying
options {cmd:fixed}, {cmd:multiplicative}, and {cmd:tdistribution}.  It may
not be specified with {it:moderators}.

{phang}
{opt multiplicative} performs a fixed-effects regression-based test that
accounts for residual heterogeneity by including a multiplicative variance
parameter φ.  φ is referred to as an "(over)dispersion parameter".  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
in {bf:[META] meta regress} for details.

{phang}
{opt tdistribution} reports a t test instead of a z test.  This option may not
be combined with option {opt se()}.

{phang}
{opt metashow} and {opt nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {opt nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

{phang}
{opt detail} specifies that intermediate estimation results be displayed.  For
regression-based tests, the results from the regression estimation will be
displayed.  For the nonparametric test, the results from {cmd:ktau}
({helpb spearman:[R] spearman}) will be displayed.

{dlgtab:Maximization}
 
{marker maxopts}{...}
{phang}
{it:maximize_options}: {opt iterate(#)}, {opt tolerance(#)},
{opt nrtolerance(#)}, {opt nonrtolerance}
(see {helpb maximize:[R] Maximize}), {opt from(#)}, and {opt showtrace}.
These options control the iterative estimation of the between-study variance
parameter, τ^2, with random-effects methods {cmd:reml}, {cmd:mle}, and
{cmd:ebayes}.  These options are seldom used.

{phang2}
{opt from(#)} specifies the initial value for τ^2 during estimation.  By
default, the initial value for τ^2 is the noniterative Hedges estimator.

{phang2}
{opt showtrace} displays the iteration log that contains the estimated
parameter τ^2, its relative difference with the value from the previous
iteration, and the scaled gradient.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pupiliqset}{p_end}

{pstd}Test for small-study effects by using the Egger regression-based test
{p_end}
{phang2}{cmd:. meta bias, egger}

{pstd}As above, but include a moderator {cmd:week1} to account for the
between-study heterogeneity induced by {cmd:week1}{p_end}
{phang2}{cmd:. meta bias i.week1, egger}

{pstd}As above, but assume an empirical Bayes random-effects method for
estimating the random-effects variance in the regression-based test{p_end}
{phang2}{cmd:. meta bias i.week1, egger random(ebayes)}

{pstd}Request the traditional version of the Egger test{p_end}
{phang2}{cmd:. meta bias, egger traditional}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nsaidsset, clear}

{pstd}Test for small-study effects by using the Harbord regression-based test
and show detailed output of the performed meta-regression{p_end}
{phang2}{cmd:. meta bias, harbord detail}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
For regression-based tests, {cmd:meta bias} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(beta1)}}estimate of the main slope coefficient{p_end}
{synopt:{cmd:r(se)}}standard error for the slope estimate{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(t)}}t statistic{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(testtype)}}type of test: {cmd:egger}, {cmd:harbord}, or {cmd:peters}{p_end}
{synopt:{cmd:r(model)}}meta-analysis model{p_end}
{synopt:{cmd:r(method)}}meta-analysis estimation method{p_end}
{synopt:{cmd:r(moderators)}}moderators used in regression-based tests{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}regression results{p_end}


{pstd}
For Begg's test, {cmd:meta bias} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(score)}}Kendall's score estimate{p_end}
{synopt:{cmd:r(se_score)}}standard error of Kendall's score{p_end}
{synopt:{cmd:r(z)}}z test statistic{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(testtype)}}{cmd:begg}{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker beggmazumdar1994}{...}
{phang}
Begg, C. B., and M. Mazumdar. 1994. Operating characteristics of a rank
correlation test for publication bias.  {it:Biometrics} 50: 1088–1101.

{marker eggeretal1997}{...}
{phang}
Egger, M., G. Davey Smith, and A. N. Phillips. 1997. Meta-analysis: Principles
and procedures.  {it:British Medical Journal} 315: 1533–1537.

{marker harbordeggersterne2006}{...}
{phang}
Harbord, R. M., M. Egger, and J. A. C. Sterne. 2006. A modified test for
small-study effects in meta-analyses of controlled trials with binary
endpoints.  {it:Statistics in Medicine} 25: 3443–3457.

{marker hartungknapp2001a}{...}
{phang}
Hartung, J., and G. Knapp. 2001a. On tests of the overall treatment effect in
meta-analysis with normally distributed responses.
{it:Statistics in Medicine} 20: 1771–1782.

{marker hartungknapp2001b}{...}
{phang}
------. 2001b. A refined method for the meta-analysis of controlled clinical
trials with binary outcome.  {it:Statistics in Medicine} 20: 3875–3889.

{marker knapphartung2003}{...}
{phang}
Knapp, G., and J. Hartung. 2003. Improved tests for a random effects
meta-regression with a single covariate.
{it:Statistics in Medicine} 22: 2693–2710.

{marker petersetal2006}{...}
{phang}
Peters, J. L., A. J. Sutton, D. R. Jones, K. R. Abrams, and L. Rushton. 2006.
Comparison of two methods to detect publication bias in meta-analysis.
{it:Journal of the American Medical Association} 295: 676–680.

{marker sidikjonkman2002}{...}
{phang}
Sidik, K., and J. N. Jonkman. 2002. A simple confidence interval for
meta-analysis. {it:Statistics in Medicine} 21: 3153–3159.
{p_end}
