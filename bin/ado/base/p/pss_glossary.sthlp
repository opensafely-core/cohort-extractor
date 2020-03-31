{smcl}
{* *! version 1.0.13  20jun2019}{...}
{vieweralsosee "[PSS-5] Glossary" "mansection PSS-5 Glossary"}{...}
{viewerjumpto "Description" "pss_glossary##description"}{...}
{viewerjumpto "Glossary" "pss_glossary##glossary"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[PSS-5] Glossary}}{p_end}
{p2col:({mansection PSS-5 Glossary:View complete PDF manual entry})}{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
The terms commonly used in the {bf:PSS} manual entry are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:1:M matched case-control study}.
See {help pss_glossary##matchedstudy:{it:matched study}}.

{marker def_2x2table}{...}
{phang}
{bf:2 x 2 contingency table}.
A 2 x 2 contingency table is used to describe the association between a binary
independent variable and a binary response variable of interest.

{marker def_2x2Ktable}{...}
{phang}
{bf:2 x 2 x K contingency table}.
See {help pss_glossary##def_stratified2x2tables:{it:stratified 2 x 2 tables}}.

{phang}
{bf:acceptance region}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, an acceptance
region is a set of sample values for which the
{help pss_glossary##def_nullhyp:null hypothesis} cannot be rejected or can be
accepted.  It is the complement of the
{help pss_glossary##def_rejregion:rejection region}.

{phang}
{marker accrual_period}{...}
{bf:accrual period} or {bf:recruitment period} or {bf:accrual}.  The accrual
period (or recruitment period) is the period during which subjects are being
enrolled (recruited) into a study.  Also see
{it:{help pss_glossary##followup_period:follow-up period}}.

{phang}
{bf:actual alpha}, {bf:actual significance level}.
This is an attained or observed
{help pss_glossary##def_siglevel:significance level}.

{phang}
{bf:actual confidence-interval width}.
This is the {help pss glossary##def_ciwidth:CI width} that is computed using
the rounded-up sample size when the population standard deviation is known.

{phang}
{bf:actual probability of confidence-interval width}.
{cmd:ciwidth} will calculate the required sample size for a specified
probability of CI width, and if it is fractional, will round it up to report
an integer.  The actual probability of CI width is calculated using the rounded
sample-size estimates.

{phang}
{bf:actual sample size}.
For a two-sample study, when specifying one of the sample sizes and a
sample-size ratio that result in noninteger sample sizes, {cmd:power} and
{cmd:ciwidth} will round down the noninteger sample sizes to the nearest
integers and use these integers for computations.  The actual sample size is
the rounded-down sample size.

{phang}
{bf:actual sample-size ratio}.
When specifying a sample-size ratio that results in noninteger sample sizes,
{cmd:power} and {cmd:ciwidth} will round down the input sample sizes and round
up the computed sample sizes to the nearest integers.  The actual sample-size
ratio is computed using the rounded sample sizes.

{phang}
{marker administrative_censoring}{...}
{bf:administrative censoring}.
Administrative censoring is the right-censoring that occurs when the study
observation period ends.  All subjects complete the course of the study and
are known to have experienced one of two outcomes at the end of the study:
survival or failure.  This type of censoring should not be confused with 
{it:{help pss_glossary##withdrawal:withdrawal}} and 
{it:{help pss_glossary##loss_to_followup:loss to follow-up}}.  Also see
{it:{help st_glossary##censored:censored, left-censored, right-censored, and interval-censored}}.

{phang}
{bf:allocation ratio}.
This ratio n2/n1 represents the number of subjects in the comparison,
{help pss_glossary##def_expgroup:experimental group} relative
to the number of subjects in the reference, 
{help pss_glossary##def_controlgroup:control group}.  Also see
{manlink PSS-4 Unbalanced designs}.

{marker def_alpha}{...}
{phang}
{bf:alpha}.
Alpha denotes the
{help pss_glossary##def_siglevel:significance level}.

{marker def_althyp}{...}
{phang}
{bf:alternative hypothesis}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, the
alternative {help pss_glossary##def_hyp:hypothesis} represents the
counterpoint to which the
{help pss_glossary##def_nullhyp:null hypothesis} is compared.  When the
parameter being tested is a scalar, the alternative hypothesis can be either
{help pss_glossary##def_onesided:one sided} or
{help pss_glossary##def_twosided:two sided}.

{marker def_altval}{...}
{phang}
{bf:alternative value}, {bf:alternative parameter}.
This value of the parameter of interest under the
{help pss_glossary##def_althyp:alternative hypothesis} is fixed by the
investigator in a power and sample-size analysis.  For example, alternative
mean value and alternative mean refer to a value of the mean parameter under
the alternative hypothesis.

{marker def_anova}{...}
{phang}
{bf:analysis of variance}, {bf:ANOVA}.
This is a class of statistical models that studies differences between means
from multiple populations by partitioning the variance of the continuous
outcome into independent sources of variation due to effects of interest and 
random variation.  The test statistic is then formed as a ratio of the
expected variation due to the effects of interest to the expected random
variation.  Also see
{help pss_glossary##def_oneway:{it:one-way ANOVA}},
{help pss_glossary##def_twoway:{it:two-way ANOVA}},
{help pss_glossary##def_onewayrep:{it:one-way repeated-measures ANOVA}}, and
{help pss_glossary##def_twowayrep:{it:two-way repeated-measures ANOVA}}.

{marker def_balanced}{...}
{phang}
{bf:balanced design}.
A balanced design represents an experiment in which the numbers of treated and
untreated subjects are equal.  For many types of
{help pss_glossary##def_twosample:two-sample hypothesis tests}, the power of
the test is maximized with balanced designs.  For both PrSS and PSS analyses,
balanced designs tend to require fewer subjects than their corresponding
unbalanced designs.

{marker def_beta}{...}
{phang}
{bf:beta}.
Beta denotes the
{help pss_glossary##def_prtypeIIerr:probability} of committing a
{help pss_glossary##def_typeIIerr:type II error}, namely, failing to
reject the null hypothesis even though it is false.

{marker def_betweendesign}{...}
{phang}
{bf:between-subjects design}.
This is an experiment that has only
{help pss_glossary##def_betweenfactor:between-subjects factor}s.  See
{manlink PSS-2 power oneway} and {manlink PSS-2 power twoway}.

{marker def_betweenfactor}{...}
{phang}
{bf:between-subjects factor}.
This is a {help pss_glossary##def_factor:factor} for which each subject
receives only one of the levels.

{phang}
{bf:binomial test}.
A binomial test is a test for which the exact sampling distribution of the
test statistic is binomial; see {helpb bitest:[R] bitest}.  Also see
{helpb power oneproportion:[PSS-2] power oneproportion}.

{phang}
{bf:bisection method}.
This method finds a root x of a function f(x) such that f(x)=0 by
repeatedly subdividing an interval on which f(x) is defined until the change
in successive root estimates is within the requested tolerance and function
f() evaluated at the current estimate is sufficiently close to zero.

{marker def_casecontrolstudy}{...}
{phang}
{bf:case-control study.}
An {help pss_glossary##def_obsstudy:observational study} that
{help pss_glossary##def_retrospective:retrospectively} compares
characteristics of subjects with a certain problem (cases) with
characteristics of subjects without the problem (controls).  For example, to
study association between smoking and lung cancer, investigators will sample
subjects with and without lung cancer and record their smoking status.
Case-control studies are often used to study rare diseases.

{phang}
{bf:CCT}.
See {help pss_glossary##def_cct:{it:controlled clinical trial study}}.

{marker def_cellmean}{...}
{phang}
{bf:cell means}.
These are means of the outcome of interest within cells formed by the
cross-classification of the two 
{help pss_glossary##def_factor:factor}s.  See
{manlink PSS-2 power twoway} and {manlink PSS-2 power repeated}.

{marker def_cellmeanmodel}{...}
{phang}
{bf:cell-means model}.
A cell-means model is an
{help pss_glossary##def_anova:ANOVA} model formulated in
terms of {help pss_glossary##def_cellmean:cell means}.

{phang}
{bf:chi-squared test}.
This test for which either an asymptotic sampling distribution or a 
sampling distribution of a test statistic is
chi-squared.  See {helpb power onevariance:[PSS-2] power onevariance} and
{helpb power twoproportions:[PSS-2] power twoproportions}.

{phang}
{bf:CI}.
See {help pss glossary##def_ci:{it:confidence interval}}.

{phang}
{bf:CI precision}.
See {help pss glossary##def_ciprecision:{it:confidence-interval precision}}.

{phang}
{bf:CI precision graph}.
See
{help pss glossary##def_ciwcurve:{it:confidence-interval precision curve}}.

{phang}
{bf:CI width}.
See {help pss glossary##def_ciwidth:{it:confidence-interval width}}.

{marker def_clinicaltrial}{...}
{phang}
{bf:clinical trial}.  A clinical trials is
an experiment testing a medical treatment or procedure on human subjects.

{marker def_clinicaldiff}{...}
{phang}
{bf:clinically meaningful difference}, {bf:clinically meaningful effect},
{bf:clinically significant difference}.
Clinically meaningful difference represents the magnitude of an effect of
interest that is of clinical importance.  What is meant by "clinically
meaningful" may vary from study to study.  In
{help pss_glossary##def_clinicaltrial:clinical trial}s, for example, if
no prior knowledge is available about the performance of the considered
clinical procedure, a standardized
{help pss_glossary##def_esize:effect size} (adjusted for standard deviation)
between 0.25 and 0.5 may be considered of clinical importance.

{marker def_crd}{...}
{phang}
{bf:cluster randomized design}, {bf:CRD}, {bf:cluster randomized trial},
{bf:CRT}, {bf:group randomized trial}, {bf:GRT}.
Cluster randomized design is a type of randomized design in which groups of
subjects or clusters are sampled instead of individual subjects.  A cluster is
the randomization unit, and an individual within a cluster is the analysis
unit.  Observations within a cluster tend to be correlated.  The strength of the
correlation is measured by the
{help pss_glossary##def_intraclasscorr:intraclass correlation}.
Also see {help pss_glossary##def_indivleveldesign:{it:individual-level design}}.

{marker def_clustersize}{...}
{phang}
{bf:cluster size}.
The number of subjects in a group or cluster in a
{help pss_glossary##def_crd:cluster randomized design}.  If cluster sizes vary
between clusters, the {help pss_glossary##def_cv:coefficient of variation} for
cluster sizes is used for power and
{help pss_glossary##def_sampsideterm:sample-size determination}.

{marker def_CAtest}{...}
{phang}
{bf:Cochran-Armitage test}.
The Cochran-Armitage test is a test for a linear trend in a probability of
response in a {help pss glossary##def_Jx2table:J x 2 contingency table}.
The test statistic has an asymptotic chi-squared distribution under the 
null hypothesis.  See {helpb power trend:[P] power trend}.

{marker def_CMHtest}{...}
{phang}
{bf:Cochran-Mantel-Haenszel test}.
See {help pss glossary##def_MHtest:{it:Mantel-Haenszel test}}.

{marker def_cv}{...}
{phang}
{bf:coefficient of variation}, {bf:CV}.
Coefficient of variation measures the spread or the variability of the
observations relative to the mean.

{marker def_cohort}{...}
{phang}
{bf:cohort study}.
Typically an {help pss_glossary##def_obsstudy:observational study},
a cohort study may also be an
{help pss_glossary##def_expstudy:experimental} study in which a cohort,
a group of subjects who have similar characteristics, is followed over time
and evaluated at the end of the study.  For example, cohorts of vaccinated and
unvaccinated subjects are followed over time to study the effectiveness of
influenza vaccines.

{marker def_columns}{...}
{phang}
{bf:columns in graph}.
Think of {cmd:power, graph()} and {cmd:ciwidth, graph()} as graphing the
columns of {cmd:power, table}.  One of the columns will be placed on the x
axis, another will be placed on the y axis, and, if you have more columns with
varying values, separate plots will be created for each.  Similarly, we use
the terms "column symbol", "column name", and "column label" to refer to
symbols, names, and labels that appear in tables when tabular output is
requested.

{marker def_commonoddsratio}{...}
{phang} 
{bf:common odds ratio}.
A measure of association in 
{help pss glossary##def_stratified2x2tables:stratified 2 x 2 tables}.  It can
be viewed as a weighted aggregate of stratum-specific
{help pss glossary##def_oddsratio:odds ratios}.

{phang}
{bf:comparison value}.  See
{help pss_glossary##def_altval:{it:alternative value}}.

{phang}
{bf:compound symmetry}.
A covariance matrix has a compound-symmetry structure if all the variances
are equal and all the covariances are equal.  This is a special case of the
{help pss_glossary##def_sphericity:sphericity} assumption.

{marker def_concordpairs}{...}
{phang}
{bf:concordant pairs}.
In a {help pss_glossary##def_2x2table:2 x 2 contingency table}, a concordant
pair is a pair of observations that are both either successes or failures.
Also see {help pss_glossary##def_discpairs:{it:discordant pairs}} and
{mansection PSS-2 powerpairedproportionsRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power pairedproportions}.

{phang}
{bf:confidence bounds}.
See {help pss glossary##def_climits:{it:confidence limits}}.

{phang}
{bf:confidence coefficient}.
See {help pss glossary##def_clevel:{it:confidence level}}.

{marker def_ci}{...}
{phang}
{bf:confidence interval}.
A confidence interval provides an interval estimate for a parameter of
interest.  It is constructed such that, in a repeated independent sampling, the
proportion of confidence intervals containing the true parameter value will be
larger than or equal to the specified
{help pss glossary##def_clevel:confidence level}, 1-alpha.  A confidence
interval can also be viewed as a range of plausible values that cannot be
rejected by the corresponding hypothesis test at a given significance level
alpha.  See {mansection PSS-3 Intro(ciwidth)RemarksandexamplesConfidenceintervals:{it:Confidence intervals}}
in {bf:[PSS-3] Intro (ciwidth)}.  Also see
{help pss glossary##def_onesidedci:{it:one-sided confidence interval}} and
{help pss glossary##def_twosidedci:{it:two-sided confidence interval}}.

{marker def_clevel}{...}
{phang}
{bf:confidence level}.
The confidence level sets the degree of certainty with which the CIs,
constructed from repeated independent sampling, will be guaranteed to 
contain the true parameter value.  For example, when specifying a
confidence level of 95, the CI is guaranteed to contain the true 
parameter value 95% of the time.  The confidence level is equal to
1-alpha, where alpha is the 
{help pss glossary##def_siglevel:significance level}.

{marker def_climits}{...}
{phang}
{bf:confidence limits}.
The confidence limits are the upper and lower limits of the confidence
interval.  For two-sided CIs, both confidence limits are finite.  For one-sided
CIs, one confidence limit is finite and the other is infinite.  An upper
one-sided CI has a lower confidence limit equal to negative infinity, whereas
a lower one-sided CI has an upper confidence limit equal to infinity.  See 
{mansection PSS-3 Intro(ciwidth)RemarksandexamplesConfidenceintervals:{it:Confidence intervals}}
in {bf:[PSS-3] Intro (ciwidth)}.

{marker def_cihalfwidth}{...}
{phang}
{bf:confidence-interval half-width}.
The half-width of a confidence interval is equal to one half of the 
{help pss glossary##def_ciwidth:confidence-interval width},
w/2, and is also known as the margin of error.  The CI half-width is used
as a measure of precision for a symmetric CI.

{marker def_ciprecision}{...}
{phang}
{bf:confidence-interval precision}.
The precision of a {help pss glossary##def_ci:confidence interval} is
typically measured by its {help pss glossary##def_ciwidth:width}.  A larger
width means a lower degree of precision and leads to a wider CI.  A smaller
width means a higher degree of precision and leads to a narrower CI.

{marker def_ciwcurve}{...}
{phang}
{bf:confidence-interval precision curve}.
A confidence-interval precision curve is a graph of the estimated
{help pss glossary##def_ciwidth:CI width} as a function of some other study
parameter, such as sample size or probability of CI width.  The CI width is
plotted on the y axis, and the sample size or other parameter is plotted on
the x axis.

{phang}
{bf:confidence-interval precision determination}.
This pertains to the computation of
{help pss glossary##def_ciwidth:confidence-interval width} given
sample size, probability of CI width, and other study parameters.

{marker def_ciwidth}{...}
{phang}
{bf:confidence-interval width}.
For two-sided CIs, the width is defined as the difference between the upper
and lower limits.  For an upper one-sided CI, the width is the difference
between the upper confidence limit and the point estimate.  For a lower
one-sided CI, the width is the difference between the lower confidence limit
and the point estimate.

{marker def_contrasts}{...}
{phang}
{bf:contrasts}.
Contrasts refers to a linear combination of cell means such that the sum of
contrast coefficients is zero.

{phang}
{bf:control covariates}.
See {help pss_glossary##def_reducedmodel:{it:reduced model}}.

{marker def_controlgroup}{...}
{phang}
{bf:control group}.
A control group comprises subjects that are randomly assigned to a group where
they receive no treatment or receives a standard treatment.  In
{help pss_glossary##def_hyptesting:hypothesis testing}, this is usually
a reference group.  Also see
{help pss_glossary##def_expgroup:{it:experimental group}}.

{marker def_cct}{...}
{phang}
{bf:controlled clinical trial study}.
This is an {help pss_glossary##def_expstudy:experimental study} in which
treatments are assigned to two or more groups of subjects without the
randomization.

{phang}
{bf:CRD}.
See {help pss_glossary##def_crd:{it:cluster randomized design}}.

{phang}
{bf:critical region}.
See {help pss_glossary##def_rejregion:{it:rejection region}}.

{phang}
{bf:critical value}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, a critical
value is a boundary of the
{help pss_glossary##def_rejregion:rejection region}.

{phang}
{bf:cross-sectional study.}
This type of {help pss_glossary##def_obsstudy:observational study}
measures various population characteristics at one point in time or over a
short period of time.  For example, a study of the prevalence of breast cancer
in the population is a cross-sectional study.

{phang}
{bf:CRT}.
See {help pss_glossary##def_crd:{it:cluster randomized design}}.

{phang}
{bf:CV}.
See {help pss_glossary##def_cv:{it:coefficient of variation}}.

{phang}
{bf:delta}.
Delta in the context of power and sample-size calculations, denotes the
{help pss_glossary##def_esize:effect size}.

{phang}
{bf:directional test}.
See {help pss_glossary##def_onesided:{it:one-sided test}}.

{marker def_discpairs}{...}
{phang}
{bf:discordant pairs}.
In a {help pss_glossary##def_2x2table:2 x 2 contingency table}, discordant
pairs are the success-failure or failure-success pairs of observations.  Also
see {help pss_glossary##def_concordpairs:{it:concordant pairs}} and
{mansection PSS-2 powerpairedproportionsRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power pairedproportions}.

{phang}
{bf:discordant proportion}.
This is a proportion of
{help pss_glossary##def_discpairs:discordant pairs} or
{help pss_glossary##def_discsets:discordant sets}.  Also see
{mansection PSS-2 powerpairedproportionsRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power pairedproportions}
as well as
{mansection PSS-2 powermccRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power mcc}.

{marker def_discsets}{...}
{phang}
{bf:discordant sets}.  In a matched study with multiple controls matched to a
case, discordant sets are the sets in which there is any success-failure or
failure-success match between the case and any matched control.  Also see
{mansection PSS-2 powermccRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power mcc}.

{phang}
{bf:dropout}.
Dropout is the withdrawal of subjects before the end of a study and leads to
incomplete or missing data.

{marker def_esize}{...}
{phang}
{bf:effect size}.
The effect size is the size of the
{help pss_glossary##def_clinicaldiff:clinically significant difference}
between the treatments being compared, typically expressed as a quantity that
is independent of the unit of measure.  For example, in a
{help pss_glossary##def_onesampletest:one-sample mean test}, the effect
size is a standardized difference between the mean and its reference value.
In other cases, the effect size may be measured as an
{help pss_glossary##def_oddsratio:odds ratio} or a
{help pss_glossary##def_riskratio:risk ratio}.  See
{manlink PSS-2 Intro (power)} to
learn more about the relationship between effect size and the power of a test.

{phang}
{bf:effect-size curve}.
The effect-size curve is a graph of the estimated
{help pss_glossary##def_esize:effect size} or
{help pss_glossary##def_target:target parameter} as a function of some
other study parameter such as the
{help pss_glossary##def_samplesize:sample size}.  The effect size or
target parameter is plotted on the y axis, and the sample size or other
parameter is plotted on the x axis.

{phang}
{bf:effect-size determination}.
This pertains to the computation of an
{help pss_glossary##def_esize:effect size} or a
{help pss glossary##def_target:target parameter} given
{help pss_glossary##def_power:power},
{help pss_glossary##def_samplesize:sample size}, and other study
parameters.

{phang}
{bf:equal-allocation design}.
See {help pss_glossary##def_balanced:{it:balanced design}}.

{marker def_exacttest}{...}
{phang}
{bf:exact test}.
An exact test is one for which the probability of observing the data under the
null hypothesis is calculated directly, often by enumeration.  Exact tests do
not rely on any asymptotic approximations and are therefore widely used with
small datasets.  See {helpb power oneproportion:[PSS-2] power oneproportion}
and {helpb power twoproportions:[PSS-2] power twoproportions}.

{marker def_expgroup}{...}
{phang}
{bf:experimental group}.
An experimental group is a group of subjects that receives a treatment or
procedure of interest defined in a controlled experiment.  In
{help pss_glossary##def_hyptesting:hypothesis testing}, this is usually
a comparison group.  Also see
{help pss_glossary##def_controlgroup:{it:control group}}.

{marker def_expstudy}{...}
{phang}
{bf:experimental study.}
In an experimental study, as opposed to an
{help pss_glossary##def_obsstudy:observational study}, the assignment of
subjects to treatments is controlled by investigators.  For example, a study
that compares a new treatment with a standard treatment by assigning each
treatment to a group of subjects is an experimental study.

{phang}
{bf:exponential test}.
The exponential test is the parametric test comparing the hazard rates,
lambda_1 and lambda_2, (or log hazards) from two independent exponential
(constant only) regression models with the null hypothesis H_0:
lambda_2-lambda_1=0 (or H_0:
ln(lambda_2)-ln(lambda_1)=ln(lambda_2/lambda_1)=0).

{marker def_exposureoddsratio}{...}
{phang}
{bf:exposure odds ratio}.
An {help pss glossary##def_oddsratio:odds ratio} of exposure in cases relative
to controls in a
{help pss glossary##def_casecontrolstudy:case-control study}.

{phang}
{bf:F test}.
An F test is a test for which a sampling distribution of a test statistic is
an F distribution.  See {helpb power twovariances:[PSS-2] power twovariances}.

{marker def_factor}{...}
{phang}
{bf:factor}, {bf:factor variables}.
This is a categorical explanatory variable with any number of levels.

{phang}
{bf:finite population correction}.
When sampling is performed without replacement from a finite population, a
finite population correction is applied to the standard error of the estimator
to reduce sampling variance.

{phang}
{bf:Fisher-Irwin's exact test}.
See {help pss_glossary##def_fisher:{it:Fisher's exact test}}.

{marker def_fisher}{...}
{phang}
{bf:Fisher's exact test}.
Fisher's exact test is an
{help pss_glossary##def_exacttest:exact small-sample test} of independence
between rows and columns in a 2 x 2 contingency table.  Conditional on the
marginal totals, the test statistic has a hypergeometric distribution under
the null hypothesis.  See
{helpb power twoproportions:[PSS-2] power twoproportions} and
{helpb tabulate twoway:[R] tabulate twoway}.

{phang}
{bf:Fisher's z test}.
This is a {help pss_glossary##def_ztest:z test} comparing one or two
correlations.  See {helpb power onecorrelation:[PSS-2] power onecorrelation}
and
{helpb power twocorrelations:[PSS-2] power twocorrelations}.  Also see
{help pss_glossary##def_fisherz:{it:Fisher's z transformation}}.

{marker def_fisherz}{...}
{phang}
{bf:Fisher's z transformation}.
Fisher's z transformation applies an inverse hyperbolic tangent
transformation to the sample correlation coefficient.  This transformation is
useful for testing hypothesis concerning
{help pss_glossary##def_corrcoef:Pearson's correlation coefficient}.
The exact sampling distribution of the correlation coefficient is complicated,
while the transformed statistic is approximately standard normal.

{marker def_fixedeffects}{...}
{phang}
{bf:fixed effects}.
Fixed effects represent all levels of the factor that are of interest.

{phang}
{marker followup_period}{...}
{bf:follow-up period} or {bf:follow-up}.
The (minimum) follow-up period is the period after the last subject entered
the study until the end of the study.  The follow-up defines the phase of a
study during which subjects are under observation and no new subjects enter
the study.  If T is the total duration of a study, and R is the accrual period
of the study, then follow-up period f is equal to T-R.  Also see
{it:{help pss_glossary##accrual_period:accrual period}}.

{phang}
{bf:follow-up study.}
See {help pss_glossary##def_cohort:{it:cohort study}}.

{marker def_nfraction}{...}
{phang}
{bf:fractional sample size}.
Fractional (noninteger) sample sizes occur when specifying an odd number for
the total sample size in studies with an equal-allocation design.  They may
also occur when specifying noninteger sample-size ratios.

{marker def_fullmodel}{...}
{phang}
{bf:full model}.
In the regression context, a full model is a regression model that includes
all covariates of interest.  Also see
{help pss_glossary##def_reducedmodel:{it:reduced model}}.

{phang}
{bf:Greenhouse-Geisser correction}.
See {help pss_glossary##def_nonsphericityeps:{it:nonsphericity correction}}.

{phang}
{bf:group randomized trial}, {bf:GRT}.
See {help pss_glossary##def_crd:{it:cluster randomized design}}.

{marker def_hyp}{...}
{phang}
{bf:hypothesis}.
A hypothesis is a statement about a population parameter of interest.

{marker def_hyptesting}{...}
{phang}
{bf:hypothesis testing}, {bf:hypothesis test}.
This method of inference evaluates the validity of a
{help pss_glossary##def_hyp:hypothesis} based on a sample from the
population.  See
{mansection PSS-2 Intro(power)RemarksandexamplesHypothesistesting:{it:Hypothesis testing}}
under {it:Remarks and examples} in {bf:[PSS-2] Intro (power)}.

{phang}
{bf:hypothesized value}.
See {help pss_glossary##def_nullval:{it:null value}}.

{marker def_indivleveldesign}{...}
{phang}
{bf:individual-level design}.
Individual-level design is a classical randomized design in which individual
subjects or observations are sampled; thus they represent both units of
randomization and units of analysis.  In contrast, see 
{help pss_glossary##def_crd:{it:cluster randomized design}}.

{marker def_intereffects}{...}
{phang}
{bf:interaction effects}.
Interaction effects measure the dependence of the effects of one factor on the
levels of the other factor.  Mathematically, they can be defined as the
differences among treatment means that are left after
{help pss_glossary##def_maineffects:main effects} are removed
from these differences.

{marker def_intraclasscorr}{...}
{phang}
{bf:intraclass correlation}.
Intraclass correlation measures the dependence of observations in the same
group or cluster.

{marker def_Jx2table}{...}
{phang}
{bf:J x 2 contingency table}.
A J x 2 contingency table is used to describe the association between an
ordinal independent variable with J levels and a binary response variable of
interest.

{phang}
{bf:Lagrange multiplier test}.
See {help pss_glossary##def_scoretest:{it:score test}}.

{phang}
{bf:likelihood-ratio test}.
The likelihood-ratio (LR) test is one of the three classical testing
procedures used to compare the fit of two models, one of which, the
constrained model, is nested within the full (unconstrained) model.  Under the
null hypothesis, the constrained model fits the data as well as the full
model.  The LR test requires one to determine the maximal value of the
log-likelihood function for both the constrained and the full models.  See
{helpb power twoproportions:[PSS-2] power twoproportions} and
{helpb lrtest:[R] lrtest}.

{phang}
{marker loss_to_followup}
{bf:loss to follow-up}.
Subjects are lost to follow-up if they do not complete the course of the study
for reasons unrelated to the event of interest.  For example, loss to
follow-up occurs if subjects move to a different area or decide to no longer
participate in a study.  Loss to follow-up should not be confused with
administrative censoring.  If subjects are lost to follow-up, the information
about the outcome these subjects would have experienced at the end of the
study, had they completed the study, is unavailable.  Also see
{it:{help pss_glossary##withdrawal:withdrawal}},
{it:{help pss_glossary##administrative_censoring:administrative censoring}},
and {it:{help pss_glossary##followup_period:follow-up period or follow-up}}.

{marker def_lowerci}{...}
{phang}
{bf:lower one-sided confidence interval}.
A lower one-sided confidence interval contains a range of values that 
are greater than or equal to the lower confidence limit {it:ll}.
The confidence interval is defined by a
finite lower confidence limit and an upper confidence limit of infinity:
[{it:ll}, infinity).

{phang}
{bf:lower one-sided test}, {bf:lower one-tailed test}.
A lower one-sided test is a
{help pss_glossary##def_onesided:one-sided test} of a scalar parameter in
which the {help pss_glossary##def_althyp:alternative hypothesis} is
lower one sided, meaning that the alternative hypothesis states that the
parameter is less than the value conjectured under the
{help pss_glossary##def_nullhyp:null hypothesis}.  Also see
{mansection PSS-2 Intro(power)Remarksandexamplesonevstwo:{it:One-sided test versus two-sided test}}
under {it:Remarks and examples} in {bf:[PSS-2] Intro (power)}.

{marker def_maineffects}{...}
{phang}
{bf:main effects}.
These are average, additive effects that are associated with each level of
each factor.  For example, the main effect of level j of a factor is the
difference between the mean of all observations on the outcome of interest at
level j and the grand mean.

{marker def_MHtest}{...}
{phang}
{bf:Mantel-Haenszel test}.
The Mantel-Haenszel test evaluates whether the overall degree of association
in {help pss glossary##def_stratified2x2tables:stratified 2 x 2 tables} is
significant assuming that the exposure effect is the same across strata.  See
{manhelp power_cmh P:power cmh}.

{phang}
{bf:margin of error}.
See {help pss glossary##def_cihalfwidth:{it:confidence-interval half-width}}.

{marker def_marghomog}{...}
{phang}
{bf:marginal homogeneity}.
Marginal homogeneity refers to the equality of one or more row marginal
proportions with the corresponding column proportions.  Also see
{mansection PSS-2 powerpairedproportionsRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power pairedproportions}.

{phang}
{bf:marginal proportion}.
This represents a ratio of the number of observations in a row or column of a
{help pss_glossary##def_2x2table:contingency table} relative to the
total number of observations.  Also see
{mansection PSS-2 powerpairedproportionsRemarksandexamplesIntroduction:{it:Introduction}}
under {it:Remarks and examples} in {bf:[PSS-2] power pairedproportions}.

{marker matchedstudy}{...}
{phang}
{bf:matched study}.
In a matched study, an observation from one group is matched to one or more
observations from another group with respect to one or more characteristics of
interest.  When multiple matches occur, the study design is 1:M, where
M is the number of matches.  Also see
{help pss_glossary##def_paireddata:{it:paired data}}, also known as
1:1 matched data.

{phang}
{bf:McNemar's test}.
McNemar's test is a test used to compare two dependent binary populations.
The null hypothesis is formulated in the context of a 2 x 2
contingency table as a hypothesis of
{help pss_glossary##def_marghomog:marginal homogeneity}.  See
{helpb power pairedproportions:[PSS-2] power pairedproportions} and
{helpb mcc}.

{phang}
{bf:MDES}.
See {help pss_glossary##def_mdes:{it:minimum detectable effect size}}.

{phang}
{bf:mean contrasts}.
See {help pss_glossary##def_contrasts:{it:contrasts}}.

{marker def_mdes}{...}
{phang}
{bf:minimum detectable effect size}.
The minimum detectable {help pss_glossary##def_esize:effect size} is
the smallest effect size that can be detected by hypothesis testing for a
given power and sample size.

{phang}
{bf:minimum detectable value}.
The minimum detectable value represents the smallest amount or concentration
of a substance that can be reliably measured.

{marker def_mixeddesign}{...}
{phang}
{bf:mixed design}.
A mixed design is an experiment that has at least one
{help pss_glossary##def_betweenfactor:between-subjects factor} and one
{help pss_glossary##def_withinfactor:within-subject factor}.  See
{manlink PSS-2 power repeated}.

{marker def_mpcorr}{...}
{phang}
{bf:multiple partial correlation}.
In the regression context, multiple partial correlation is the measure of
association between the dependent variable and one or more independent
variables of interest, while controlling for the effect of other variables in
the model.

{marker def_negesize}{...}
{phang}
{bf:negative effect size}.
In power and sample-size analysis, we obtain a negative
{help pss_glossary##def_esize:effect size} when the postulated value of
the parameter under the alternative hypothesis is less than the hypothesized
value of the parameter under the null hypothesis.  Also see
{help pss_glossary##def_posesize:{it:positive effect size}}.

{phang}
{bf:nominal alpha}, {bf:nominal significance level}.
This is a desired or requested
{help pss_glossary##def_siglevel:significance level}.

{phang}
{bf:noncentrality parameter}.
In power and sample-size analysis, a noncentrality parameter is the expected
value of the test statistic under the alternative hypothesis.

{phang}
{bf:nondirectional test}.
See {help pss_glossary##def_twosided:{it:two-sided test}}.

{marker def_nonsphericityeps}{...}
{phang}
{bf:nonsphericity correction}.
This is a correction used for the degrees of freedom of a regular F test in
a repeated-measures ANOVA to compensate for the lack of
{help pss_glossary##def_sphericity:sphericity} of the
repeated-measures covariance matrix.

{marker def_nullhyp}{...}
{phang}
{bf:null hypothesis}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, the null
{help pss_glossary##def_hyp:hypothesis} typically represents the
conjecture that one is attempting to disprove.  Often the null hypothesis is
that a treatment has no effect or that a statistic is equal across
populations.

{marker def_nullval}{...}
{phang}
{bf:null value}, {bf:null parameter}.
This value of the parameter of interest under the
{help pss_glossary##def_nullhyp:null hypothesis} is fixed by the
investigator in a power and sample-size analysis.  For example, null mean
value and null mean refer to the value of the mean parameter under the null
hypothesis.

{marker def_nclust}{...}
{phang}
{bf:number of clusters}.
The number of independent sampling units, groups or clusters, in a
{help pss_glossary##def_crd:cluster randomized design}.

{marker def_obsstudy}{...}
{phang}
{bf:observational study.}
In an observational study, as opposed to an
{help pss_glossary##def_expstudy:experimental study}, the assignment of
subjects to treatments happens naturally and is thus beyond the control of
investigators.  Investigators can only observe subjects and measure their
characteristics.  For example, a study that evaluates the effect of exposure
of children to household pesticides is an observational study.

{phang}
{bf:observed level of significance}.
See {help pss_glossary##def_pvalue:{it:p-value}}.

{marker def_oddsratio}{...}
{phang}
{bf:odds and odds ratio}.
The odds in favor of an event are Odds = p/(1-p), where p is the
probability of the event.  Thus if p=0.2, the odds are 0.25, and if
p=0.8, the odds are 4.

{pmore}
The log of the odds is
ln(Odds) = logit(p) = ln{c -(}p/(1-p){c )-},
and logistic regression models, for instance, fit ln(Odds) as a
linear function of the covariates.

{pmore}
The odds ratio is a ratio of two odds:  Odds2/Odds1.
The individual odds that appear in the ratio are usually for an experimental
group and a control group or for two different demographic groups.

{marker def_onesampletest}{...}
{phang}
{bf:one-sample test}.
A one-sample test compares a parameter of interest from one sample with a
reference value.  For example, a one-sample mean test compares a mean of the
sample with a reference value.

{marker def_onesidedci}{...}
{phang}
{bf:one-sided confidence interval}.
See
{help pss glossary##def_upperci:{it:upper one-sided confidence interval}}
and
{help pss glossary##def_lowerci:{it:lower one-sided confidence interval}}.

{marker def_onesided}{...}
{phang}
{bf:one-sided test}, {bf:one-tailed test}.
A one-sided test is a
{help pss_glossary##def_hyptesting:hypothesis test} of a scalar parameter in
which the {help pss_glossary##def_althyp:alternative hypothesis} is one
sided, meaning that the alternative hypothesis states that the parameter is
either less than or greater than the value conjectured under the
{help pss_glossary##def_nullhyp:null hypothesis} but not both.  Also
see {mansection PSS-2 Intro(power)Remarksandexamplesonevstwo:{it:One-sided test versus two-sided test}}
under {it:Remarks and examples} in {bf:[PSS-2] Intro (power)}.

{marker def_oneway}{...}
{phang}
{bf:one-way ANOVA}, {bf:one-way analysis of variance}.
A one-way {help pss_glossary##def_anova:ANOVA} model has a single
{help pss_glossary##def_factor:factor}.  Also see
{manlink PSS-2 power oneway}.

{marker def_onewayrep}{...}
{phang}
{bf:one-way repeated-measures ANOVA}.
A one-way repeated-measures ANOVA model has a single
{help pss_glossary##def_withinfactor:within-subject factor}.
Also see {manlink PSS-2 power repeated}.

{marker def_paireddata}{...}
{phang}
{bf:paired data}.
Paired data consist of pairs of observations that share some characteristics
of interest.  For example, measurements on twins, pretest and posttest
measurements, before and after measurements, repeated measurements on the same
individual.  Paired data are correlated and thus must be analyzed by using a
{help pss_glossary##def_pairedtest:paired test}.
See
{manhelp ciwidth_pairedmeans PSS: ciwidth pairedmeans} for PrSS analysis for a
paired-means-difference CI.

{phang}
{bf:paired observations}.
See {help pss_glossary##def_paireddata:{it:paired data}}.

{marker def_pairedtest}{...}
{phang}
{bf:paired test}.
A paired test is used to test whether the parameters of interest of two
{help pss_glossary##def_paireddata:paired populations} are equal.  The
test takes into account the dependence between measurements.  For this reason,
paired tests are usually more powerful than their
{help pss_glossary##def_twosample:two-sample} counterparts.  For
example, a paired-means or paired-difference test is used to test whether the
means of two paired (correlated) populations are equal.

{marker def_pcorr}{...}
{phang}
{bf:partial correlation}.
Partial correlation is the measure of association between two continuous
variables, while controlling for the effect of other variables.

{marker def_corrcoef}{...}
{phang}
{bf:Pearson's correlation}.
Pearson's correlation rho, also known as the product-moment correlation,
measures the degree of association between two variables.  Pearson's
correlation equals the variables' covariance divided by their respective
standard deviations, and ranges between -1 and 1.  Zero indicates no
correlation between the two variables.

{phang}
{bf:population parameter}.
See {help pss_glossary##def_target:{it:target parameter}}.

{marker def_posesize}{...}
{phang}
{bf:positive effect size}.
In power and sample-size analysis, we obtain a positive
{help pss_glossary##def_esize:effect size} when the postulated value of
the parameter under the alternative hypothesis is greater than the
hypothesized value of the parameter under the null hypothesis.  Also see
{help pss_glossary##def_negesize:{it:negative effect size}}.

{phang}
{bf:postulated value}.
See {help pss_glossary##def_altval:{it:alternative value}}.

{marker def_power}{...}
{phang}
{bf:power}.
The power of a test is the probability of correctly rejecting the
{help pss_glossary##def_nullhyp:null hypothesis} when it is false.  It
is often denoted as 1-beta in the statistical literature, where beta
is the {help pss_glossary##def_prtypeIIerr:type II error probability}.
Commonly used values for power are 80% and 90%.  See
{manlink PSS-2 Intro (power)} for more details about power.

{marker def_pss}{...}
{phang}
{bf:power and sample-size analysis}.
Power and sample-size analysis investigates the optimal allocation of study
resources to increase the likelihood of the successful achievement of a study
objective.  The focus of power and sample-size analysis is on studies that use
hypothesis testing for inference.  Power and sample-size analysis provides an
estimate of the sample size required to achieve the desired
{help pss glossary##def_power:power} of a test in a future
study.  See {manlink PSS-2 Intro (power)}.  Also see
{help pss glossary##def_prss:{it:precision and sample-size analysis}}.

{marker def_powercurve}{...}
{phang}
{bf:power curve}.
A power curve is a graph of the estimated
{help pss_glossary##def_power:power} as a function of some other study
parameter such as the sample size.  The power is plotted on the y axis, and
the sample size or other parameter is plotted on the x axis.  See
{helpb power_optgraph:[PSS-2] power, graph}.

{phang}
{bf:power determination}.
This pertains to the computation of a
{help pss_glossary##def_power:power} given sample size, effect size,
and other study parameters.

{phang}
{bf:power function}.
The power functions is a function of the population parameter theta,
defined as the probability that the observed sample belongs to the
{help pss_glossary##def_rejregion:rejection region} of a test for given
theta.  See {mansection PSS-2 Intro(power)RemarksandexamplesHypothesistesting:{it:Hypothesis testing}}
under {it:Remarks and examples} in {bf:[PSS-2] Intro (power)}.

{phang}
{bf:power graph}.
See {help pss_glossary##def_powercurve:{it:power curve}}.

{marker def_prss}{...}
{phang}
{bf:precision and sample-size analysis}.
Just like {help pss glossary##def_pss:power and sample-size analysis},
precision and sample-size analysis investigates the optimal allocation of
study resources to increase the likelihood of the successful achievement of a
study objective.  The focus of precision and sample-size analysis is on
studies that use confidence intervals for inference.  Precision and sample-size
analysis provides an estimate of the sample size required to achieve the
desired
{help pss glossary##def_ciprecision:precision of a confidence interval} in a
future study.  See {manlink PSS-3 Intro (ciwidth)}.

{phang}
{bf:precision of a confidence interval}.
See {help pss glossary##def_ciprecision:{it:confidence-interval precision}}.

{marker def_prtypeIerr}{...}
{phang}
{bf:probability of a type I error}.
This is the probability of committing a
{help pss_glossary##def_typeIerr:type I error}
of incorrectly rejecting the
{help pss_glossary##def_nullhyp:null hypothesis}.  Also see
{help pss_glossary##def_siglevel:{it:significance level}}.

{marker def_prtypeIIerr}{...}
{phang}
{bf:probability of a type II error}.
This is the probability of committing a
{help pss_glossary##def_typeIIerr:type II error}
of incorrectly accepting the
{help pss_glossary##def_nullhyp:null hypothesis}.  Common values for
the probability of a type II error are 0.1 and 0.2 or, equivalently, 10% and
20%.  Also see {help pss_glossary##def_beta:{it:beta}} and
{help pss_glossary##def_power:{it:power}}.

{marker def_prwidth}{...}
{phang}
{bf:probability of confidence-interval width}.
The probability of CI width is the probability that the width of a CI
in a future study will be no greater than a prespecified value.

{marker def_prwidthdet}{...}
{phang}
{bf:probability of confidence-interval width determination}.
This pertains to the computation of the
{help pss glossary##def_prwidth:probability of CI width} given
CI width, sample size, and other study parameters.

{marker def_prospective}{...}
{phang}
{bf:prospective study}.
In a prospective study, the population or cohort is classified according to
specific {help pss_glossary##def_riskfactor:risk factors}, such that the
outcome of interest, typically various manifestations of a disease, can be
observed over time and tied in to the initial classification.  Also see
{help pss_glossary##def_retrospective:{it:retrospective study}}.

{phang}
{bf:PrSS analysis}.
See {help pss glossary##def_prss:{it:precision and sample-size analysis}}.

{phang}
{bf:PSS analysis}.
See {help pss_glossary##def_pss:{it:power and sample-size analysis}}.

{marker def_pcp}{...}
{phang}
{bf:PSS Control Panel}.
The PSS Control Panel is a point-and-click graphical user interface for
{help pss_glossary##def_pss:power and sample-size analysis}.  See
{manlink PSS-2 GUI (power)}.

{marker def_pvalue}{...}
{phang}
{bf:p-value}.
P-value is a probability of obtaining a test statistic as extreme or more
extreme as the one observed in a sample assuming the 
{help pss_glossary##def_nullhyp:null hypothesis} is true.

{marker def_r2}{...}
{phang}
{bf:R^2}.
See {help sem_glossary##coefdeter:{it:coefficient of determination}}.

{marker def_randomeffects}{...}
{phang}
{bf:random effects}.
Random effects represent a random sample of levels from all possible levels,
and the interest lies in all possible levels.

{marker def_rct}{...}
{phang}
{bf:randomized controlled trial}.
In this {help pss_glossary##def_expstudy:experimental study},
treatments are randomly assigned to two or more groups of subjects.

{phang}
{bf:RCT}.
See {help pss_glossary##def_rct:{it:randomized controlled trial}}.

{phang}
{bf:recruitment period}.
See {help pss_glossary##accrual_period:{it:accrual period}}.

{marker def_reducedmodel}{...}
{phang}
{bf:reduced model}.
In the regression context, a reduced model is a regression model that 
contains only a subset of covariates from the corresponding
{help pss_glossary##def_fullmodel:full model}.  These covariates are referred
to as "control covariates".  The covariates that are not in the reduced model
are referred to as "tested covariates".

{phang}
{bf:reference value}.
See {help pss_glossary##def_nullval:{it:null value}}.

{marker def_rejregion}{...}
{phang}
{bf:rejection region}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, a rejection
region is a set of sample values for which the
{help pss_glossary##def_nullhyp:null hypothesis} can be rejected.

{phang}
{bf:relative risk}.
See {help pss_glossary##def_riskratio:{it:risk ratio}}.

{marker def_retrospective}{...}
{phang}
{bf:retrospective study}.
In a retrospective study, a group with a disease of interest is compared with
a group without the disease, and information is gathered in a retrospective
way about the exposure in each group to various
{help pss_glossary##def_riskfactor:risk factors} that might be
associated with the disease.  Also see
{help pss_glossary##def_prospective:{it:prospective study}}.

{phang}
{bf:risk difference}.
A risk difference is defined as the probability of an event occurring when a
risk factor is increased by one unit minus the probability of the event
occurring without the increase in the risk factor.

{pmore}
When the risk factor is binary, the risk difference is the probability of the
outcome when the risk factor is present minus the probability when the risk
factor is not present.

{pmore}
When one compares two populations, a risk difference is defined as a
difference between the probabilities of an event in the two groups.  It is
typically a difference between the probability in the comparison group or
experimental group and the probability in the reference group or control
group.

{marker def_riskfactor}{...}
{phang}
{bf:risk factor}.
A risk factor is a variable that is associated with an increased or decreased
probability of an outcome.

{marker def_riskratio}{...}
{phang}
{bf:risk ratio}.
A risk ratio, also called a relative risk, measures the increase in the
likelihood of an event occurring when a risk factor is increased by one unit.
It is the ratio of the probability of the event when the risk factor is
increased by one unit over the probability without that increase.

{pmore}
When the risk factor is binary, the risk ratio is the ratio of the probability
of the event when the risk factor occurs over the probability when the risk
factor does not occur.

{pmore}
When one compares two populations, a risk ratio is defined as a ratio of the
probabilities of an event in the two groups.  It is typically a ratio of the
probability in the comparison group or experimental group to the probability
in the reference group or control group.

{marker def_samplesize}{...}
{phang}
{bf:sample size}.
This is the number of subjects in a sample.  See
{manlink PSS-2 Intro (power)} to learn more about the relationship between
sample size and the power of a test.

{phang}
{bf:sample-size curve}.
A sample-size curve is a graph of the estimated
{help pss_glossary##def_samplesize:sample size} as a function of some
other study parameter such as power.  The sample size is plotted on the y
axis, and the power or other parameter is plotted on the x axis.

{marker def_sampsideterm}{...}
{phang}
{bf:sample-size determination}.
This pertains to the computation of a
{help pss_glossary##def_samplesize:sample size} given power, effect
size, and other study parameters.  In a
{help pss_glossary##def_crd:cluster randomized design}, sample-size
determination consists of determining the number of clusters given the cluster
size or the cluster size given the number of clusters.

{marker def_sampsiratio}{...}
{phang}
{bf:sample-size ratio}.
The ratio of the experimental-group sample size relative to the control-group
sample size, n_2/n_1.

{marker def_sattw}{...}
{phang}
{bf:Satterthwaite's t test}.
Satterthwaite's t test is a modification of the
{help pss_glossary##def_ttest:two-sample t test} to account for
unequal variances in the two populations.  See
{mansection PSS-2 powertwomeansMethodsandformulas:{it:Methods and formulas}}
in {bf:[PSS-2] power twomeans} for details.

{marker def_scoretest}{...}
{phang}
{bf:score test}.
A score test, also known as a Lagrange multiplier test, is one of the three
classical testing procedures used to compare the fit of two models, one of
which, the constrained model, is nested within the full (unconstrained) model.
The null hypothesis is that the constrained model fits the data as well as the
full model.  The score test only requires one to fit the constrained model.
See {helpb power oneproportion:[PSS-2] power oneproportion} and
{helpb prtest:[R] prtest}.

{phang}
{bf:sensitivity analysis}.
Sensitivity analysis investigates the effect of varying study parameters on
power, sample size, and other components of a study.  The true values of study
parameters are usually unknown, and power and sample-size analysis uses best
guesses for these values.  It is therefore important to evaluate the
sensitivity of the computed power or sample size in response to changes in
study parameters.  See {helpb power_opttable:[PSS-2] power, table} and
{helpb power optgraph:[PSS-2] power, graph} for
details.

{phang}
{bf:sign test}.
A sign test is used to test the null hypothesis that the median of a
distribution is equal to some reference value.  A sign test is carried out as
a test of binomial proportion with a reference value of 0.5.  See
{helpb power oneproportion:[PSS-2] power oneproportion} and
{helpb bitest:[R] bitest}.

{marker def_siglevel}{...}
{phang}
{bf:significance level}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, the
significance level alpha is an upper bound for a
{help pss_glossary##def_prtypeIerr:probability of a type I error}.  See
{manlink PSS-2 Intro (power)} to learn more about the relationship between
significance level and the power of a test.

{phang}
{bf:size of test}.
See {help pss_glossary##def_siglevel:{it:significance level}}.

{marker def_sphericity}{...}
{phang}
{bf:sphericity assumption}.
All differences between levels of the within-subject factor
{help pss_glossary##def_withinfactor:within-subject} factor have
the same variances.

{marker def_stratified2x2tables}{...}
{phang}
{bf:stratified 2 x 2 tables}.
Stratified 2 x 2 tables describe the association between a binary independent
variable and a binary response variable of interest.  The analysis is
stratified by a nominal (categorical) variable with K levels.

{phang}
{bf:symmetry}.
In a {help pss_glossary##def_2x2table:2 x 2 contingency table},
symmetry refers to the equality of the off-diagonal elements.  For a 2 x 2
table, a test of
{help pss_glossary##def_marghomog:marginal homogeneity} reduces to a test of
symmetry.

{marker def_ttest}{...}
{phang}
{bf:t test}.
A t test is a test for which the sampling distribution of the test statistic
is a Student's t distribution.

{pmore}
A one-sample t test is used to test whether the mean of a population is equal
to a specified value when the variance must also be estimated.  The test
statistic follows Student's t distribution with N-1 degrees of freedom, where
N is the sample size.

{pmore}
A two-sample t test is used to test whether the means of two populations are
equal when the variances of the populations must also be estimated.  When the
two populations' variances are unequal, a modification to the standard
two-sample t test is used; see
{help pss_glossary##def_sattw:{it:Satterthwaite's t test}}.

{marker def_target}{...}
{phang}
{bf:target parameter}.
In power and sample-size analysis, the target parameter is the parameter of
interest or the parameter in the study about which hypothesis tests are
conducted.

{phang}
{bf:test statistic}.
In {help pss_glossary##def_hyptesting:hypothesis testing}, a test
statistic is a function of the sample that does not depend on any unknown
parameters.

{phang}
{bf:tested covariates}.
See {help pss_glossary##def_reducedmodel:{it:reduced model}}.

{phang}
{bf:two-independent-samples test}.
See {help pss_glossary##def_twosample:{it:two-sample test}}.

{phang}
{bf:two-sample paired test}.
See {help pss_glossary##def_pairedtest:{it:paired test}}.

{marker def_twosample}{...}
{phang}
{bf:two-sample test}.
A two-sample test is used to test whether the parameters of interest of the
two independent populations are equal.  For example, two-sample means test,
two-sample variances, two-sample proportions test, two-sample correlations
test.

{marker def_twosidedci}{...}
{phang}
{bf:two-sided confidence interval}.
A two-sided CI contains a plausible finite range of values for a parameter of
interest.  Two-sided CIs contain a finite upper limit for plausible values
greater than the point estimate and a finite lower limit for plausible values
less than the point estimate.  See
{mansection PSS-3 Intro(ciwidth)RemarksandexamplesConfidenceintervals:{it:Confidence intervals}}
in {bf:[PSS-3] Intro (ciwidth)}.

{marker def_twosided}{...}
{phang}
{bf:two-sided test}, {bf:two-tailed test}.
A two-sided test is a
{help pss_glossary##def_hyptesting:hypothesis test} of a parameter in which
the {help pss_glossary##def_althyp:alternative hypothesis} is the
complement of the {help pss_glossary##def_nullhyp:null hypothesis}.  In
the context of a test of a scalar parameter, the alternative hypothesis states
that the parameter is less than or greater than the value conjectured under
the null hypothesis.

{marker def_twoway}{...}
{phang}
{bf:two-way ANOVA}, {bf:two-way analysis of variance}.
A two-way {help pss_glossary##def_anova:ANOVA} model contains two
{help pss_glossary##def_factor:factor}s.
Also see {manlink PSS-2 power twoway}.

{marker def_twowayrep}{...}
{phang}
{bf:two-way repeated-measures ANOVA}, {bf:two-factor ANOVA}.
This is a repeated-measures {help pss_glossary##def_onewayrep:ANOVA}
model with one
{help pss_glossary##def_withinfactor:within-subject factor}
and one {help pss_glossary##def_betweenfactor:between-subjects factor}.  The
model can be additive (contain only main effects of the factors) or can
contain main effects and an interaction between the two factors.  Also see
{manlink PSS-2 power repeated}.

{marker def_typeIerr}{...}
{phang}
{bf:type I error}.
The type I error of a test is the error of rejecting the null hypothesis when
it is true; see {manlink PSS-2 Intro (power)} for more details.

{phang}
{bf:type I error probability}.
See {help pss_glossary##def_prtypeIerr:{it:probability of a type I error}}.

{phang}
{bf:type I study}.
A type I study is a study in which all subjects fail (or experience an event)
by the end of the study; that is, no censoring of subjects occurs.

{marker def_typeIIerr}{...}
{phang}
{bf:type II error}.
The type II error of a test is the error of not rejecting the null hypothesis
when it is false; see {manlink PSS-2 Intro (power)} for more details.

{phang}
{bf:type II error probability}.
See {help pss_glossary##def_prtypeIIerr:{it:probability of a type II error}}.

{phang}
{bf:type II study}.
A type II study is a study in which there are subjects who do not fail (or do
not experience an event) by the end of the study.  These subjects are known to
be censored.

{marker def_unbalanced}{...}
{phang}
{bf:unbalanced design}.
An unbalanced design indicates an experiment in which the numbers of treated
and untreated subjects differ.  Also see {manlink PSS-4 Unbalanced designs}.

{phang}
{bf:unequal-allocation design}.
See {help pss_glossary##def_unbalanced:{it:unbalanced design}}.

{marker def_upperci}{...}
{phang}
{bf:upper one-sided confidence interval}.
An upper one-sided confidence interval contains a range of values that are
less than or equal to the upper confidence limit {it:ul}.  The confidence
interval is defined by a finite upper confidence limit and a lower confidence
limit of negative infinity: (-infinity, {it:ul}].

{phang}
{bf:upper one-sided test}, {bf:upper one-tailed test}.
An upper one-sided test is a
{help pss_glossary##def_onesided:one-sided test} of a scalar
parameter in which the {help pss_glossary##def_althyp:alternative hypothesis}
is upper one sided, meaning that the alternative hypothesis states that the
parameter is greater than the value conjectured under the
{help pss_glossary##def_nullhyp:null hypothesis}.  Also see
{mansection PSS-2 Intro(power)Remarksandexamplesonevstwo:{it:One-sided test versus two-sided test}}
under {it:Remarks and examples} in {bf:[PSS-2] Intro (power)}.

{phang}
{bf:Wald test}.
A Wald test is one of the three classical testing procedures used to compare
the fit of two models, one of which, the constrained model, is nested within
the full (unconstrained) model.  Under the null hypothesis, the constrained
model fits the data as well as the full model.  The Wald test requires one to
fit the full model but does not require one to fit the constrained model.
Also see {helpb power oneproportion:[PSS-2] power oneproportion} and
{helpb test:[R] test}.

{phang}
{marker withdrawal}{...}
{bf:withdrawal}.
Withdrawal is the process under which subjects withdraw from a study for
reasons unrelated to the event of interest.  For example, withdrawal occurs if
subjects move to a different area or decide to no longer participate in a
study.  Withdrawal should not be confused with administrative censoring.  If
subjects withdraw from the study, the information about the outcome those
subjects would have experienced at the end of the study, had they completed
the study, is unavailable.  Also see
{it:{help pss_glossary##loss_to_followup:loss to follow-up}} and
{it:{help pss_glossary##administrative_censoring:administrative censoring}}.

{marker def_withindesign}{...}
{phang}
{bf:within-subject design}.
This is an experiment that has at least one
{help pss_glossary##def_withinfactor:within-subject factor}.
See {manlink PSS-2 power repeated}.

{marker def_withinfactor}{...}
{phang}
{bf:within-subject factor}.
This is a {help pss_glossary##def_factor:factor} for which each subject
receives several of or all the levels.

{marker def_ztest}{...}
{phang}
{bf:z test}.
A z test is a test for which a potentially asymptotic sampling distribution
of the test statistic is a normal distribution.  For example, a one-sample z
test of means is used to test whether the mean of a population is equal to a
specified value when the variance is assumed to be known.  The distribution of
its test statistic is normal.  See {helpb power onemean:[PSS-2] power onemean},
{helpb power twomeans:[PSS-2] power twomeans}, and
{helpb power pairedmeans:[PSS-2] power pairedmeans}.
{p_end}
