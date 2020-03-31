{smcl}
{* *! version 1.0.0  19jun2019}{...}
{vieweralsosee "[META] Glossary" "mansection META Glossary"}{...}
{viewerjumpto "Description" "meta_glossary##description"}{...}
{viewerjumpto "Glossary" "meta_glossary##glossary"}{...}
{viewerjumpto "References" "meta_glossary##references"}{...}
{p2colset 1 20 21 2}{...}
{p2col:{bf:[META] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection META Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:Begg test, Begg and Mazumdar test}.  A nonparametric rank correlation test
for funnel-plot asymmetry of
{help meta_glossary##beggmazumdar1994:Begg and Mazumdar (1994)}. It tests
whether Kendall's rank correlation between the effect sizes and their
variances equals zero. The regression-based tests such as the
{help meta_glossary##Egger_test:Egger test} tend to perform better in terms
of type I error than the rank correlation test. This test is no longer
recommended in the literature and provided mainly for completeness.  See
{helpb meta_bias:[META] meta bias}.

{phang}
{bf:between-study sample size}.  The number of studies in a meta-analysis.

{phang}
{bf:between-study variability}.  Also known as between-study heterogeneity;
see {help meta_glossary##heterog:{it:heterogeneity}}.

{phang}
{bf:bubble plot}.  A scatterplot of effect size against a continuous covariate
(moderator) in the meta-regression.  The size of points representing the
studies is proportional to study weights from a fixed-effects or, optionally,
random-effects meta-analysis.

{phang}
{bf:clinical heterogeneity}.  According to
{help meta_glossary##deekshigginsaltman2017:Deeks, Higgins, and Altman (2017)},
it is "variability in the participants, interventions and outcomes studied".
Clinical variation will lead to
{help meta_glossary##heterog:heterogeneity} if the effect size is affected by
any of these varying factors.

{phang}
{bf:Cochrane's Q statistic}.  See
{help meta_glossary##qstat:{it:Q statistic}}.

{marker cohend}{...}
{phang}
{bf:Cohen's d}.  An effect-size measure introduced by
{help meta_glossary##cohen1988:Cohen (1988)} for continuous outcomes.  It is a
standardized mean difference where the difference between the two group means
is usually divided by the standard deviation pooled across both groups.  See
{mansection META metaesizeMethodsandformulasStandardizedmeandifference:{it:Standardized mean difference}}
in {bf:[META] meta esize}.

{phang}
{bf:combined effect size}.  See
{it:{help meta_glossary##oes:overall effect size}}.

{phang}
{bf:common-effect meta-analysis model}.  A meta-analysis model that assumes
that a single (common) true effect size underlies all the
{help meta_glossary##primary:primary study} results.
See {mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}} in
{bf:[META] Intro}.

{phang}
{bf:cumulative meta-analysis}.  Cumulative meta-analysis performs multiple
meta-analyses by accumulating studies one at a time.  The studies are first
ordered with respect to the variable of interest, the ordering variable.
Meta-analysis summaries are then computed for the first study, for the first
two studies, for the first three studies, and so on.  The last meta-analysis
will correspond to the standard meta-analysis using all studies.
See {manhelp meta_summarize META:meta summarize}.

{phang}
{bf:cumulative overall effect sizes}.  In the context of cumulative
meta-analysis, cumulative (overall) effect sizes refer to the overall effect
sizes computed by accumulating one study at a time.  That is, the first overall
effect size is simply the individual effect size of the first study.  The
second overall effect size is the overall effect size computed based on the
first two studies.  The third overall effect size is the overall effect size
computed based on the first three studies.  And so on.  The last effect size
in a cumulative meta-analysis corresponds to the overall effect size computed
using all studies in a standard meta-analysis.

{phang}
{bf:DerSimonian-Laird's method}.  A noniterative, random-effects estimator of
the between-study variance parameter that does not make any assumptions about
the distribution of random effects.  This method was introduced in
{help meta_glossary##dersimonianlaird1986:DerSimonian and Laird (1986)}.
Historically, random-effects meta-analysis has been based solely on this
method.  See
{mansection META metasummarizeMethodsandformulasNoniterativemethods:{it:Noniterative methods}}
in {bf:[META] meta summarize}.

{marker esize}{...}
{phang}
{bf:effect size}.  A numerical summary of the group differences or of
association between factors. For example, effect sizes for two-group
comparisons include standardized and unstandardized mean differences, odds
ratio, risk ratio, hazard ratio, and correlation coefficient.
See {helpb meta esize:[META] meta esize}.

{marker Egger_test}{...}
{phang}
{bf:Egger test}.  A regression-based test for funnel-plot asymmetry of
({help meta_glossary##eggeretal1997:Egger et al. 1997}). This is the test of a
slope coefficient in a weighted regression of the effect sizes on their
standard errors.  See {helpb meta bias:[META] meta bias}.

{marker femamodel}{...}
{phang}
{bf:fixed-effects meta-analysis model}.  A meta-analysis model that assumes
effect sizes are different across the studies and estimates a weighted average
of their true values.  This model is not valid for making inferences about
studies beyond those included in the meta-analysis.  See
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}} in {bf:[META] Intro}.

{phang}
{bf:fixed-effects meta-regression}.
{help meta_glossary##meta_regression:Meta-regression} that assumes 
a fixed-effects meta-analysis model.  This regression model does not account
for residual heterogeneity.  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
in {bf:[META] meta regress}.

{phang}
{bf:forest plot}.  A forest plot is a graphical representation of the results
of a meta-analysis.  In addition to meta-analytic summary such as overall
effect size and its confidence interval and heterogeneity statistics and
tests, it includes study-specific effect sizes and confidence intervals.  See
{manhelp meta_forestplot META:meta forestplot}.

{phang}
{bf:funnel plot}.  The funnel plot is a scatterplot of the study-specific
effect sizes against measures of study precision.  This plot is commonly used
to explore small-study effects or publication bias.  In the absence of
small-study effects, the shape of the scatterplot should resemble a symmetric
inverted funnel.  See {manhelp meta_funnelplot META:meta funnelplot}.

{marker glassdelta}{...}
{phang}
{bf:Glass's Delta}.  An effect-size measure introduced by
{help meta_glossary##smithglass1977:Smith and Glass (1977)} for continuous
outcomes.  It is a standardized mean difference where the difference between
the two group means is divided by the sample standard deviation of the control
group.  Another variation of this statistic uses the sample standard deviation
of the treatment group for the standardization.  See
{mansection META metaesizeMethodsandformulasStandardizedmeandifference:{it:Standardized mean difference}}
in {bf:[META] meta esize}.

{phang}
{bf:grey literature}.  In the context of meta-analysis, grey literature refers
to the literature that is difficult to obtain; it is thus rarely included in a
meta-analysis.

{phang}
{bf:H^2 statistic}.  A statistic for assessing heterogeneity.  A value of
H^2 = 1 indicates perfect homogeneity among the studies.  See
{mansection META metasummarizeMethodsandformulasHeterogeneitymeasures:{it:Heterogeneity measures}}
in {bf:[META] meta summarize}.

{marker hedgesg}{...}
{phang}
{bf:Hedges's g}.  An effect-size measure introduced by
{help meta_glossary##hedges1981:Hedges (1981)} for
continuous outcomes.  It is a
{help meta_glossary##cohend:Cohen's d} statistic adjusted for bias.
See {mansection META metaesizeMethodsandformulasStandardizedmeandifference:{it:Standardized mean difference}} in {bf:[META] meta esize}.

{marker heterog}{...}
{phang}
{bf:heterogeneity}.  In a meta-analysis, statistical heterogeneity, or
simply heterogeneity, refers to the variability between the study-specific
effect sizes that cannot be explained by a random variation.
See {mansection META IntroRemarksandexamplesHeterogeneity:{it:Heterogeneity}}
in {bf:[META] Intro}.

{marker heteroparam}{...}
{phang}
{bf:heterogeneity parameter}.  In a random-effects meta-analysis, the variance
of the random effects, tau^2, is used to account for the between-study
heterogeneity.  It is often referred to as the "heterogeneity parameter".

{phang}
{bf:homogeneity}.  The opposite of
{help meta_glossary##heterog:heterogeneity}.

{marker homogeneity_test}{...}
{phang}
{bf:homogeneity test}.  A test based on Cochrane's 
{help meta_glossary##qstat:Q statistic} for assessing whether effect sizes
from studies in a meta-analysis are homogeneous.  See
{mansection META metasummarizeMethodsandformulasHomogeneitytest:{it:Homogeneity test}}
in {bf:[META] meta summarize}.

{phang}
{bf:I^2 statistic}.  A statistic for assessing heterogeneity. It estimates
the proportion of variation between the effect sizes due to heterogeneity
relative to the pure sampling variation. I^2 > 50 indicates substantial
heterogeneity.  See
{mansection META metasummarizeMethodsandformulasHeterogeneitymeasures:{it:Heterogeneity measures}} in {bf:[META] meta summarize}.

{phang}
{bf:intervention effects}.  See
{help meta_glossary##esize:{it:effect size}}.

{phang}
{bf:inverse-variance method}.  A method of estimating the overall effect size
as a weighted average of the study-specific effect sizes by using the weights
that are inversely related to the variance
({help meta_glossary##whiteheadwhitehead1991:Whitehead and Whitehead 1991}).
This method is applicable to all meta-analysis models and all types of effect
sizes.

{phang}
{bf:L'Abb{c e'} plot}.  A scatterplot of the summary outcome measure such as
log odds in the control group on the x axis and of that in the treatment group
on the y axis.  It is used with binary outcomes to inspect the range of
group-level summary outcome measures among the studies to identify excessive
heterogeneity.  See {manhelp meta_labbeplot META:meta labbeplot}.

{phang}
{bf:large-strata limiting model}.  A model assumption for binary data in which
the number of studies remains fixed but similar cell sizes in the
2 x 2 tables increase.  See
{help meta_glossary##robinsbreslowgreenland1986:Robins, Breslow, and Greenland (1986)}.

{phang}
{bf:Mantel-Haenszel method}.  In the context of meta-analysis, the
Mantel--Haenszel method combines odds ratios, risk ratios, and risk
differences. This method performs well in the presence of sparse data.
For nonsparse data, its results are similar to those of the inverse-variance
method.  It was introduced by 
{help meta_glossary##mantelhaenszel1959:Mantel and Haenszel (1959)} for
odds ratios and extended to risk ratios and risk differences by
{help meta_glossary##greenlandrobins1985:Greenland and Robins (1985)}.  See 
See {mansection META metasummarizeMethodsandformulasMantel--Haenszelmethodforbinaryoutcomes:{it:Mantel-Haenszel method for binary outcomes}}
in {bf:[META] meta summarize}.

{marker meta_data}{...}
{phang}
{bf:meta data}.  {cmd:meta} data are the data that were {cmd:meta} set (or
declared) by either {helpb meta set} or {helpb meta esize}.  {cmd:meta}
data store key variables and characteristics about your meta-analysis
specifications, which will be used by all {helpb meta} commands during your
meta-analysis session.  Thus, declaration of your data as {cmd:meta} data
is the first step of your meta-analysis in Stata.  This step helps minimize
mistakes and saves you time -- you need to specify the necessary
information only once.  Also see {manlink META meta data}.

{marker meta_settings}{...}
{phang}
{bf:meta settings}.  Meta settings refers to the meta-analysis information
specified during the declaration of the {cmd:meta} data via {helpb meta set}
or {helpb meta esize}.  This includes the declared effect size, meta-analysis
model, estimation method, confidence level, and more.  See
{mansection META metadataRemarksandexamplesDeclaringmeta-analysisinformation:{it:Declaring meta-analysis information}} in
{bf:[META] meta data} for details.

{marker meta_analysis}{...}
{phang}
{bf:meta-analysis}.  The statistical analysis that combines quantitative
results from multiple individual studies into a single result.  It is often
performed as part of a systematic review.
See {mansection META IntroRemarksandexamplesBriefoverviewofmeta-analysis:{it:Brief overview of meta-analysis}}
in {bf:[META] Intro}.

{marker meta_regression}{...}
{phang}
{bf:meta-regression}.  A weighted regression of study effect sizes on 
study-level covariates or moderators.  You can think of it as an extension of
standard meta-analysis to incorporate the moderators to account for 
between-study heterogeneity.  See {manhelp meta_regress META:meta regress}.

{phang} 
{bf:methodological heterogeneity}.  Variability in study design and conduct
({help meta_glossary##deekshigginsaltman2017:Deeks, Higgins, and Altman 2017}).
See {mansection META IntroRemarksandexamplesHeterogeneity:{it:Heterogeneity}}
in {bf:[META] Intro}.

{marker moderator}{...}
{phang}
{bf:moderator}.  A moderator is a study-level covariate that may help explain
between-study heterogeneity.  If the moderator is categorical, its effect may
be investigated by a subgroup analysis (see {manhelp meta_summarize META:meta summarize}); if the
moderator is continuous, its effect may be investigated by a meta-regression.
See {manhelp meta_regress META:meta regress}.

{phang}
{bf:multiple subgroup analyses}.  Subgroup analysis performed separately for
each of multiple categorical variables.  See
{manhelp meta_summarize META:meta summarize}.

{marker mdparam}{...}
{phang}
{bf:multiplicative dispersion parameter}.  In a fixed-effects meta-regression,
the multiplicative dispersion parameter is a multiplicative factor applied to
the variance of each effect size to account for
{help meta_glossary##residhet:residual heterogeneity}.  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
of {bf:[META] meta regress}.

{phang}
{bf:multiplicative meta-regression}.  A fixed-effects meta-regression that
accounts for {help meta_glossary##residhet:residual heterogeneity}
through a dispersion parameter phi
applied (multiplicatively) to each effect-size variance.  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
of {bf:[META] meta regress}.

{phang}
{bf:narrative review}.  In a narrative review, the conclusion about the
findings from multiple studies is given by a person, an expert in a particular
field, based on his or her research of the studies.  This approach is
typically subjective and does not allow to account for certain aspects of the
studies such as study heterogeneity and publication bias.

{phang}
{bf:odds ratio}.  A ratio of the odds of a success in one group (treatment
group) to those of another group (control group). It is often used as an
effect size for comparing binary outcomes of two groups.
See {helpb meta esize:[META] meta esize}.

{marker oes}{...}
{phang}
{bf:overall effect size}.  The main target of interest in meta-analysis.  Its
interpretation depends on the assumed meta-analysis model.  In a common-effect
model, it is the common effect size of the studies.  In a fixed-effects model,
it is a weighted average of the true study-specific effect sizes.  In a
random-effects model, it is the mean of the distribution of the effect sizes.
The overall effect size is usually denoted by {cmd:theta} in the output.  Also
see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}} in
{bf:[META] Intro}.

{phang}
{bf:Peto's method}.  A method for combining odds ratios that is often used
with sparse 2 x 2 tables.  This method does not require a
{help meta_glossary##zerocelladj:zero-cell adjustment}.
See {mansection META metasummarizeMethodsandformulasPetosmethodforoddsratios:{it:Peto's method for odds ratios}} in
{manhelp meta_summarize META:meta summarize}.

{phang}
{bf:pooled effect size}.  See
{it:{help meta_glossary##oes:overall effect size}}.

{marker prediction_interval}{...}
{phang}
{bf:prediction interval}.  In a random-effects meta-analysis, a 100(1-alpha)%
prediction interval indicates that the true effect sizes in
100(n1-alpha)% of new studies will lie within the interval.  See
{mansection META metasummarizeMethodsandformulasPredictionintervals:{it:Prediction intervals}} in {bf:[META] meta summarize}.

{marker primary}{...}
{phang}
{bf:primary study}.  The original study in which data are collected.  An
observation in a meta-analysis represents a primary study.

{phang}
{bf:pseudo confidence interval}.  Pseudo confidence intervals refer to the
confidence intervals as constructed by the standard funnel plot.  See
{manhelp meta_funnelplot META:meta funnelplot}.

{marker pubbias}{...}
{phang}
{bf:publication bias}.  Publication bias is known in the meta-analysis
literature as an association between the likelihood of a publication and the
statistical significance of a study result.  See
{mansection META IntroRemarksandexamplesPublicationbias:{it:Publication bias}}
in {bf:Intro}.

{marker qstat}{...}
{phang}
{bf:Q statistic}.  The test statistic of the
{help meta_glossary##homogeneity_test:homogeneity test}.  See
{mansection META metasummarizeMethodsandformulasHomogeneitytest:{it:Homogeneity test}}
in {manhelp meta_summarize META:meta summarize}.

{marker remamodel}{...}
{phang}
{bf:random-effects meta-analysis model}.  A meta-analysis model that
assumes that the study effects are random; that is, the studies used in the
meta-analysis represent a random sample from a larger population of similar
studies.  See
{mansection META IntroRemarksandexamplesRandom-effectsmodel:{it:Random-effects model}}
in {bf:[META] Intro}.

{phang}
{bf:random-effects meta-regression}.
{help meta_glossary##meta_regression:Meta-regression} that assumes 
a random-effects meta-analysis model.  This regression model accounts for
residual heterogeneity via an additive error term.  See
{mansection META metaregressRemarksandexamplesIntroduction:{it:Introduction}}
in {manhelp meta_regress META:meta regress}.

{phang}
{bf:randomized controlled trial}.  A randomized controlled trial is an
experiment in which participants are randomly assigned to two or more
different treatment groups.  Randomized controlled trials are commonly used in
clinical research to determine the effectiveness of new treatments.  By
design, they avoid bias in the treatment estimates.

{phang}
{bf:rate ratio}.  See {help meta_glossary##rratio:{it:risk ratio}}.

{phang}
{bf:relative risk}.  See {help meta_glossary##rratio:{it:risk ratio}}.

{phang}
{bf:reporting bias}.  Systematic difference between the studies selected
in a meta-analysis and all the studies relevant to the research question of
interest.  Also see {help meta_glossary##pubbias:{it:publication bias}}.

{marker residhet}{...}
{phang}
{bf:residual heterogeneity}.  In the meta-regression context, this is the
remaining variability between the studies not accounted for by the moderators.
It is usually captured by the 
{help meta_glossary##heteroparam:heterogeneity parameter} in a random-effects
meta-regression or by a
{help meta_glossary##mdparam:multiplicative dispersion parameter} in a
fixed-effects meta-regression.

{marker rratio}{...}
{phang}
{bf:risk ratio}.  A ratio of the success probability in one group (treatment)
to that of another group (control). It is often used as an effect size for
comparing binary outcomes of two groups.  See
{helpb meta esize:[META] meta esize}.

{phang}
{bf:sensitivity analysis}.  In the context of meta-analysis, sensitivity
analyses are used to assess how robust the meta-analysis results are to 
assumptions made about the data and meta-analysis models.
See {manhelp meta_summarize META:meta summarize}.

{phang}
{bf:significance contours}.  In the context of a funnel plot
({manhelp meta_funnelplot META:meta funnelplot}), significance contours (or
contour lines of statistical significance) are the contour lines corresponding
to the tests of significance of individual effect sizes for a given
significance level alpha = c/100.  In other words, if a study falls in the
shaded area of a c-level contour, it is considered not statistically
significant at the alpha level based on a test of significance of the study
effect size.

{phang}
{bf:single subgroup analysis}.  Subgroup analysis performed for one
categorical variable.  See {manhelp meta_summarize META:meta summarize}.

{marker small_study_effects}{...}
{phang}
{bf:small-study effects}.  Small-study effects arise when the results of
smaller studies differ systematically from the results of larger studies.  See
{mansection META metafunnelplotRemarksandexamplesIntroduction:{it:Introduction}}
of {bf:[META] meta funnelplot}.

{marker sparsedata}{...}
{phang}
{bf:sparse data}.  For binary data, a 2 x 2 table is considered sparse
if any of the cell counts are small.

{phang}
{bf:sparse data limiting model}.  A model assumption for binary data in which
the number of 2 x 2 tables (studies) increases but the cell sizes remain
fixed.  See
{help meta_glossary##robinsbreslowgreenland1986:Robins, Breslow, and Greenland (1986)}.

{phang}
{bf:statistical heterogeneity}.  See
{help meta_glossary##heterog:{it:heterogeneity}}.

{phang}
{bf:study precision}.  Study precision is a function of a study sample size or
study variability.  Typically, study precision is measured by the inverse of
the effect-sizes standard errors, 1/σ_j, but other measures are also used.
For instance, in a funnel pot, multiple precision metrics such as variances
and sample sizes are considered. More precise studies (with larger sample
sizes and smaller variances) are assigned larger weights in a meta-analysis.

{phang}
{bf:subgroup analysis}.  A subgroup analysis divides the
studies into groups and then estimates the overall effect size for each of
the groups.  The goal of subgroup analysis is to compare the overall effect
sizes and explore heterogeneity between the subgroups.  see
{helpb meta summarize:[META] meta summarize} and
{helpb meta forestplot:[META] meta forestplot}.

{marker subgroup_het}{...}
{phang}
{bf:subgroup heterogeneity}.  In the context of meta-analysis, subgroup
heterogeneity is between-study heterogeneity induced by the differences
between effect sizes of groups defined by one or more categorical variables.
See {manhelp meta META} and {manhelp meta_summarize META:meta summarize}.

{marker summary_data}{...}
{phang}
{bf:summary data}.  In the context of
{help meta_glossary##meta_analysis:meta-analysis}, we use the term
summary data to mean summary statistics that are used to compute the effect
sizes and their standard errors for each study in the meta-analysis.  For
example, for a two-group comparison of continuous outcomes, the summary data
contain the number of observations, means, and standard deviations in each
group for each study.  For a two-group comparison of binary outcomes, the
summary data contain the 2 x 2 tables for each study.  See
{manhelp meta_esize META:meta esize}.

{phang}
{bf:summary effect}.  See
{help meta_glossary##oes:{it:overall effect size}}.

{phang}
{bf:systematic review}.  A procedure that uses systematic and well-defined
methods to find, select, and evaluate relevant research studies to answer a
specific research question.  It typically involves collecting and analyzing
summary data of the selected studies.  Meta-analysis is the statistical
analysis used as part of a systematic review.

{phang}
{bf:trim-and-fill method}.  A method of testing and adjusting for
publication bias in meta-analysis; see
{manhelp meta_trimfill META:meta trimfill}.

{marker zerocelladj}{...}
{phang}
{bf:zero-cell adjustment}.  Adjustment made to cells of 2 x 2 tables containing
zero cells.  In the meta-analysis of binary data, zero-cell counts pose
difficulties when computing odds ratios and risk ratios.  Therefore, it is
common to make zero-cell adjustments, such as adding a small number to all
cells containing zeros.  See
{mansection META metaesizeMethodsandformulasZero-cellsadjustments:{it:Zero-cells adjustments}}
in {manhelp meta_esize META:meta esize}.


{marker references}{...}
{title:References}

{marker beggmazumdar1994}{...}
{phang}
Begg, C. B., and M. Mazumdar. 1994. Operating characteristics of a rank
correlation test for publication bias.
{it:Biometrics} 50: 1088–1101.

{marker cohen1988}{...}
{phang}
Cohen, J. 1988. {it:Statistical Power Analysis for the Behavioral Sciences}.
2nd ed. Hillsdale, NJ: Erlbaum.

{marker deekshigginsaltman2017}{...}
{phang}
Deeks, J. J., J. P. T. Higgins, and D. G. Altman. 2017. Analysing data and
undertaking meta-analyses. In
{it:Cochrane Handbook for Systematic Reviews of Interventions Version 5.2.0},
ed. J. P. T. Higgins and S. Green, chap. 9.
London: The Cochrane Collaboration.
{browse "https://training.cochrane.org/handbook"}.

{marker dersimonianlaird1986}{...}
{phang}
DerSimonian, R., and N. Laird. 1986. Meta-analysis in clinical trials.
{it:Controlled Clinical Trials} 7: 177-188.

{marker eggeretal1997}{...}
{phang}
Egger, M., G. Davey Smith, M. Schneider, and C. Minder. 1997. Bias in
meta-analysis detected by a simple, graphical test.
{it:British Medical Journal} 315: 629–634.

{marker greenlandrobins1985}{...}
{phang}
Greenland, S., and J. M. Robins. 1985. Estimation of a common effect parameter
from sparse follow-up data.
{it:Biometrics} 41: 55–68.

{marker hedges1981}{...}
{phang}
Hedges, L. V. 1981. Distribution theory for Glass's estimator of effect size
and related estimators. {it:Journal of Educational Statistics} 6: 107-128.

{marker mantelhaenszel1959}{...}
{phang}
Mantel, N., and W. Haenszel. 1959. Statistical aspects of the analysis of data
from retrospective studies of disease.
{it:Journal of the National Cancer Institute} 22: 719-748.
Reprinted in {it:Evolution of Epidemiologic Ideas: Annotated}
{it:Readings on Concepts and Methods}, ed. S. Greenland, pp. 112-141.
Newton Lower Falls, MA: Epidemiology Resources.

{marker robinsbreslowgreenland1986}{...}
{phang}
Robins, J. M., N. E. Breslow, and S. Greenland. 1986. Estimators of the
Mantel-Haenszel variance consistent in both
sparse data and large-strata limiting models. {it:Biometrics} 42: 311-323.

{marker smithglass1977}{...}
{phang}
Smith, M. L., and G. V. Glass. 1977. Meta-analysis of psychotherapy outcome
studies. {it:American Psychologist} 32: 752-760.

{marker whiteheadwhitehead1991}{...}
{phang}
Whitehead, A., and J. Whitehead. 1991. A general parametric approach to the
meta-analysis of randomized clinical trials.
{it:Statistics in Medicine} 10: 1665-1677.
{p_end}
