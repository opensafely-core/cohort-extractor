{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta regress" "mansection META metaregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta regress postestimation" "help meta regress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta summarize" "help meta summarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_regress##syntax"}{...}
{viewerjumpto "Menu" "meta_regress##menu"}{...}
{viewerjumpto "Description" "meta_regress##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_regress##linkspdf"}{...}
{viewerjumpto "Options" "meta_regress##options"}{...}
{viewerjumpto "Examples" "meta_regress##examples"}{...}
{viewerjumpto "Stored results" "meta_regress##results"}{...}
{viewerjumpto "References" "meta_regress##references"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[META] meta regress} {hline 2}}Meta-analysis regression{p_end}
{p2col:}({mansection META metaregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Meta-regression using meta-analysis model as declared with meta set or meta
esize

{p 8 16 2}
{cmd:meta} {cmdab:reg:ress}
{help varlist:{it:moderators}}
{ifin}
[{cmd:,} {help meta_regress##reopts:{it:reopts}}
{help meta_regress##optstbl:{it:options}}]


{pstd}
Random-effects meta-regression

{p 8 16 2}
{cmd:meta} {cmdab:reg:ress}
{help varlist:{it:moderators}}
{ifin}{cmd:,} 
{cmd:random}[{cmd:(}{help meta_regress##remethod:{it:remethod}}{cmd:)}]
[{help meta_regress##reopts:{it:reopts}}
{help meta_regress##optstbl:{it:options}}]


{pstd}
Fixed-effects meta-regression

{p 8 16 2}
{cmd:meta} {cmdab:reg:ress}
{help varlist:{it:moderators}}
{ifin}{cmd:,} {cmd:fixed}
[{opt mult:iplicative}
{help meta_regress##optstbl:{it:options}}]


{pstd}
Constant-only meta-regression

{p 8 16 2}
{cmd:meta} {cmdab:reg:ress}
{cmd:_cons}
{ifin}
[{cmd:,}
{help meta_regress##modelopts:{it:modelopts}}]


{marker reopts}{...}
{synoptset 22}{...}
{synopthdr:reopts}
{synoptline}
{synopt :{opt tau2(#)}}sensitivity meta-analysis using a fixed value of between-study variance τ^2{p_end}
{synopt :{opt i2(#)}}sensitivity meta-analysis using a fixed value of heterogeneity statistic I^2_{c -(}res{c )-}{p_end}
{synopt :{opth se:(meta_regress##seadj:seadj)}}adjust standard errors of the coefficients{p_end}
{synoptline}

{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt tdist:ribution}}report t tests instead of z tests for the coefficients{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is as declared for meta-analysis{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}
{synopt :{it:{help meta_regress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{help meta_regress##maxopts:{it:maximize_options}}}control the maximization process; seldom used{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
{it:moderators} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp meta_regress_postestimation R:meta regress postestimation} for
features available after estimation.

{synoptset 22}{...}
INCLUDE help meta_remethod

{marker modelopts}{...}
{pstd}
{it:modelopts} is any option except {opt noconstant}.


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta regress} performs meta-analysis regression, or meta-regression,
which is a linear regression of the study effect sizes on study-level
covariates (moderators).  Meta-regression investigates whether between-study   
heterogeneity can be explained by one or
more moderators.  You can think of meta-regression as a standard meta-analysis
that incorporates moderators into the model.  {cmd:meta regress} performs both
random-effects and fixed-effects meta-regression.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaregressQuickstart:Quick start}

        {mansection META metaregressRemarksandexamples:Remarks and examples}

        {mansection META metaregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:noconstant}; see {helpb estimation_options:[R] Estimation options}.  This
option is not allowed with constant-only meta-regression.

{pstd}
Options {cmd:random()} and {cmd:fixed}, when specified with {cmd:meta regress},
temporarily override the global model declared by {helpb meta set} or
{helpb meta esize} during the computation.  Options {cmd:random()} and
{cmd:fixed} may not be combined.  If these options are omitted, the declared
meta-analysis model is assumed; see Declaring a meta-analysis model in [META]
{mansection META metadataRemarksandexamplesDeclaringaconfidencelevelformeta-analysis:{it:Declaring a confidence level for meta-analysis}}
in {bf:[META] meta data}.  Also see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
in {bf:[META] Intro}.

{phang}
{opt random} and {opt random(remethod)} specify that a random-effects model be
assumed for meta-regression; see
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
{cmd:fixed} specifies that a fixed-effects model be assumed for
meta-regression; see
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.

{phang}
{it:reopts} are {opt tau2(#)}, {opt i2(#)}, and
{cmd:se(khartung}[{cmd:, truncated}]{cmd:)}. These options are used with
random-effects meta-regression.

{phang2}
{opt tau2(#)} specifies the value of the between-study variance parameter,
τ^2, to use for the random-effects meta-regression.  This option is useful
for exploring the sensitivity of the results to different levels of
between-study heterogeneity.  Only one of {cmd:tau2()} or {cmd:i2()} may be
specified.

{phang2}
{opt i2(#)} specifies the value of the residual heterogeneity statistic
I^2_{c -(}res{c )-} (as a percentage) to use for the random-effects
meta-regression.  This option is useful for exploring the sensitivity of the
results to different levels of between-study heterogeneity.  Only one of
{cmd:i2()} or {cmd:tau2()} may be specified.

{marker seadj}{...}
{phang2}
{opt se(seadj)} specifies that the adjustment {it:seadj} be applied to the
standard errors of the coefficients.  Additionally, the tests of significance
of the coefficients are based on a Student's t distribution instead of the
normal distribution.

{phang3}
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
{opt multiplicative} performs a fixed-effects meta-regression that accounts
for residual heterogeneity by including a multiplicative variance parameter φ.
φ is referred to as an "(over)dispersion parameter".  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
in {bf:[META] meta regress} for details.

{phang}
{opt tdistribution} reports t tests instead of z tests for the coefficients.
This option is useful, for instance, when {cmd:meta regress} is used to
conduct a regression-based test for funnel-plot asymmetry.  Traditionally, the
test statistic from this test is compared with critical values from a
Student's t distribution instead of the default normal distribution.  This
option may not be combined with option {cmd:se()}.

{dlgtab:Reporting}
 
{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is as declared for the meta-analysis session; see
{mansection META metadataRemarksandexamplesDeclaringaconfidencelevelformeta-analysis:{it:Declaring a confidence level for meta-analysis}}
in {bf:[META] meta data}.  Also see option
{helpb meta_set##level:level()} in {helpb meta_set:[META] meta set}.

{phang}
{opt noheader} suppresses the output header, either at estimation or upon
replay.

{phang}
{opt metashow} and {opt nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {opt nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

INCLUDE help displayopts_list

{dlgtab:Maximization}
 
{marker maxopts}{...}
{phang}
{it:maximize_options}: {opt iter:ate(#)}, {opt tol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance} (see
{helpb maximize:[R] Maximize}), {opt from(#)}, and {opt showtrace}.  These
options control the iterative estimation of the between-study variance
parameter, τ^2, with random-effects methods {cmd:reml}, {cmd:mle}, and
{cmd:ebayes}.  These options are seldom used.

{phang2}
{opt from(#)} specifies the initial value for τ^2 during estimation.  By
default, the initial value for τ^2 is the noniterative Hedges estimator.

{phang2}
{opt showtrace} displays the iteration log that contains the estimated
parameter τ^2, its relative difference with the value from the previous
iteration, and the scaled gradient.

{pstd}
The following option is available with {cmd:meta regress} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see {helpb estimation_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgset}{p_end}

{pstd}Perform meta-regression of the effect size, {cmd:_meta_es}, on covariate
(moderator) {cmd:latitude_c}{p_end}
{phang2}{cmd:. meta regress latitude_c}

{pstd}As above, but assume a DerSimonian–Laird random-effects method and
request a Knapp–Hartung adjustment to the standard errors of
coefficients{p_end}
{phang2}{cmd:. meta regress latitude_c, random(dlaird) se(khartung)}

{pstd}Perform a meta-regression by assuming a fixed value of 0.2 for the
between-study variance{p_end}
{phang2}{cmd:. meta regress latitude_c i.alloc, tau2(.1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta regress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations (studies){p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}model chi-squared Wald test statistic{p_end}
{synopt:{cmd:e(F)}}model F statistic{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(phi)}}dispersion parameter{p_end}
{synopt:{cmd:e(tau2)}}between-study variance{p_end}
{synopt:{cmd:e(I2_res)}}I^2_{c -(}res{c )-} heterogeneity statistic{p_end}
{synopt:{cmd:e(H2_res)}}H^2_{c -(}res{c )-} heterogeneity statistic{p_end}
{synopt:{cmd:e(R2)}}R^2 heterogeneity measure{p_end}
{synopt:{cmd:e(Q_res)}}Cochran's Q residual homogeneity test statistic{p_end}
{synopt:{cmd:e(df_Q_res)}}degrees of freedom for residual homogeneity test{p_end}
{synopt:{cmd:e(p_Q_res)}}p-value for residual homogeneity test{p_end}
{synopt:{cmd:e(seadj)}}standard-error adjustment{p_end}
{synopt:{cmd:e(level)}}confidence level for CIs{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise (with iterative random-effects methods){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:meta regress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable, {cmd:_meta_es}{p_end}
{synopt:{cmd:e(indepvars)}}names of independent variables (moderators){p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(model)}}meta-analysis model{p_end}
{synopt:{cmd:e(method)}}meta-analysis estimation method{p_end}
{synopt:{cmd:e(seadjtype)}}type of standard-error adjustment{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {cmd:predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance–covariance matrix of the estimators{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}

{pstd}
{cmd:meta regress} also creates a system variable, {cmd:_meta_regweight}, that
contains meta-regression weights.
{p_end}


{marker references}{...}
{title:References}

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

{marker sidikjonkman2002}{...}
{phang}
Sidik, K., and J. N. Jonkman. 2002. A simple confidence interval for
meta-analysis. {it:Statistics in Medicine} 21: 3153–3159.
{p_end}
