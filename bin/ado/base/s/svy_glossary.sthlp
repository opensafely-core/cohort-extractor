{smcl}
{* *! version 1.1.14  14may2018}{...}
{vieweralsosee "[SVY] Glossary" "mansection SVY Glossary"}{...}
{viewerjumpto "Description" "svy_glossary##description"}{...}
{viewerjumpto "Glossary" "svy_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[SVY] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection SVY Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:100% sample}.  See {it:{help svy glossary##census:census}}.

{marker BRR}{...}
{phang}
{bf:balanced repeated replication}.  Balanced repeated replication (BRR)
is a method of variance estimation for designs with two PSUs in every stratum.
The BRR variance estimator tends to give more reasonable variance estimates
for this design than does the linearized variance estimator, which can result
in large values and undesirably wide confidence intervals.  The BRR variance
estimator is described in {manlink SVY Variance estimation}.

{phang}
{bf:bootstrap}.  The bootstrap is a method of variance estimation.
The bootstrap variance estimator for survey data is described in
{manlink SVY Variance estimation}.

{phang}
{bf:BRR}.
See {it:{help svy glossary##BRR:balanced repeated replication}}.

{marker calibration}{...}
{phang}
{bf:calibration}. Calibration is a method for adjusting sampling weights, most
often to account for underrepresented groups in the population.  This usually
results in decreased bias because it adjusts for nonresponse and
underrepresented groups in the population.  Calibration also tends to result
in smaller variance estimates.

{pmore}
The standard application of calibration uses population totals to adjust the
sampling weights.  Population totals are typically taken from a census or
other source separate from the survey.

{marker census}{...}
{phang}
{bf:census}.  When a census of the population is conducted, every individual
in the population participates in the survey.
Because of the time, cost, and other constraints, the data collected in a
census are typically limited to items that can be quickly and easily
determined, usually through a questionnaire.

{marker cluster}{...}
{phang}
{bf:cluster sampling}.  A cluster is a collection of individuals that are
sampled as a group.  Although the cost in time and money can be greatly
decreased, cluster sampling usually results in larger variance estimates when
compared with designs in which individuals are sampled independently.

{marker DEFF}{...}
{phang}
{bf:DEFF} and {bf:DEFT}. DEFF and DEFT are design
effects.  Design effects compare the sample-to-sample variability from a given
survey dataset with a hypothetical SRS design with the same number of
individuals sampled from the population.

{pmore}
DEFF is the ratio of two variance estimates.  The design-based
variance is in the numerator; the hypothetical SRS variance is in the
denominator.

{pmore}
DEFT is the ratio of two standard-error estimates.  The design-based
standard error is in the numerator; the hypothetical SRS
with-replacement standard error is in the denominator.  If the given survey
design is sampled with replacement, DEFT is the square root of DEFF.

{phang}
{bf:delta method}.  See 
{it:{help svy_glossary##linearization:linearization}}.

{phang}
{bf:design effects}.  See {help svy glossary##DEFF:{it:DEFF} and {it:DEFT}}.

{marker direct_std}{...}
{phang}
{bf:direct standardization}.
Direct standardization is an estimation method that allows comparing rates
that come from different frequency distributions.

{pmore}
Estimated rates (means, proportions, and ratios) are adjusted according to the
frequency distribution from a standard population.  The standard population is
partitioned into categories called standard strata.  The stratum frequencies
for the standard population are called standard weights.
The standardizing frequency distribution typically comes from census data, and
the standard strata are most commonly identified by demographic information
such as age, sex, and ethnicity.

{marker FPC}{...}
{phang}
{bf:finite population correction}.
Finite population correction (FPC) is an adjustment applied to the variance of
a point estimator because of sampling without replacement, resulting in
variance estimates that are smaller than the variance estimates from
comparable with-replacement sampling designs.

{phang}
{bf:FPC}.
See {it:{help svy glossary##FPC:finite population correction}}.

{phang}
{bf:Hadamard matrix}.
A Hadamard matrix is a square matrix with {it:r} rows and columns that has the
property

            {it:H}_{it:r}'{it:H}_{it:r} ={it:rI}_{it:r}

{pmore}
where {it:I}_{it:r} is the identity matrix of order {it:r}.  Generating a
Hadamard matrix with order {it:r}=2^{it:p} is easily accomplished.  Start with
a Hadamard matrix of order 2 ({it:H}_2), and build your {it:H}_{it:r} by
repeatedly applying Kronecker products with {it:H}_2.

{phang}
{bf:jackknife}.  The jackknife is a data-dependent way to estimate the
variance of a statistic, such as a mean, ratio, or regression coefficient.
Unlike BRR, the jackknife can be applied to practically any survey design.
The jackknife variance estimator is described in
{manlink SVY Variance estimation}.

{marker linearization}{...}
{phang}
{bf:linearization}.  Linearization is short for Taylor linearization. Also
known as the delta method or the
Huber/White/robust sandwich variance estimator, linearization is a method for
deriving an approximation to the variance of a point estimator, such as a
ratio or regression coefficient.
The linearized variance estimator is described in 
{manlink SVY Variance estimation}.

{marker MEFF}{...}
{phang}
{bf:MEFF} and {bf:MEFT}. MEFF and MEFT are
misspecification effects.  Misspecification effects compare the variance
estimate from a given survey dataset with the variance from a misspecified
model.
In Stata, the misspecified model is fit without weighting, clustering, or
stratification.

{pmore}
MEFF is the ratio of two variance estimates.  The design-based
variance is in the numerator; the misspecified variance is in the denominator.

{pmore}
MEFT is the ratio of two standard-error estimates.  The design-based
standard error is in the numerator; the misspecified standard error is in the
denominator.  MEFT is the square root of MEFF.

{phang}
{bf:misspecification effects}.  See
{help svy glossary##MEFF:{it:MEFF} and {it:MEFT}}.

{phang}
{bf:point estimate}.  A point estimate is another name for a statistic, such
as a mean or regression coefficient.

{phang}
{bf:poststratification}.  Poststratification is a method for adjusting
sampling weights, usually to account for underrepresented groups in the
population.
This usually results in decreased bias because of nonresponse and
underrepresented groups in the population.  Poststratification also tends to
result in smaller variance estimates.

{pmore}
The population is partitioned into categories, called poststrata.  The
sampling weights are adjusted so that the sum of the weights within each
poststratum is equal to the respective poststratum size.  The poststratum size
is the number of individuals in the population that are in the poststratum.
The frequency distribution of the poststrata typically comes from census data,
and the poststrata are most commonly identified by demographic information
such as age, sex, and ethnicity.

{phang}
{bf:predictive margins}.  Predictive margins provide a way of exploring the
response surface of a fitted model in any response metric of
interest -- means, linear predictions, probabilities, marginal effects,
risk differences, and so on.  Predictive margins are estimates of responses (or
outcomes) for the groups represented by the levels of a factor variable,
controlling for the differing covariate distributions across the groups.  They
are the survey-data and nonlinear response analogue to what are often called
estimated marginal means or least-squares means for linear models.

{pmore}
Because these margins are population-weighted averages over the estimation
sample or subsamples, and because they take account of the sampling
distribution of the covariates, they can be used to make inferences about
treatment effects for the population.

{marker PSU}{...}
{phang}
{bf:primary sampling unit}.
Primary sampling unit (PSU) is a cluster that was sampled in the first
sampling stage; see {it:{help svy glossary##cluster:cluster sampling}}.

{phang}
{bf:probability weight}. Probability weight is another term for sampling
weight.

{phang}
{bf:pseudolikelihood}. A pseudolikelihood is a weighted likelihood that is
used for point estimation.
Pseudolikelihoods are not true likelihoods because they do not represent the
distribution function for the sample data from a survey.  The sampling
distribution is instead determined by the survey design.

{phang}
{bf:PSU}.
See {it:{help svy glossary##PSU:primary sampling unit}}.

{phang}
{bf:replicate-weight variable}.  A replicate-weight variable contains
sampling weight values that were adjusted for resampling the data; see
{manlink SVY Variance estimation} for more details.

{phang}
{bf:resampling}.  Resampling refers to the process of sampling from the
dataset.
In the delete-one jackknife, the dataset is resampled by dropping one
PSU and producing a replicate of the point estimates.
In the BRR method, the dataset is resampled by dropping combinations
of one PSU from each stratum.
The resulting replicates of the point estimates are used to estimate their
variances and covariances.

{phang}
{bf:sample}.  A sample is the collection of individuals in the population
that were chosen as part of the survey.  Sample is also used to refer to
the data, typically in the form of answered questions, collected from the
sampled individuals.

{phang}
{bf:sampling stage}.  Complex survey data are typically collected using
multiple stages of clustered sampling.  In the first stage, the PSUs
are independently selected within each stratum.  In the second stage, smaller
sampling units are selected within the PSUs.  In later stages,
smaller and smaller sampling units are selected within the clusters from the
previous stage.

{phang}
{bf:sampling unit}.  A sampling unit is an individual or collection of
individuals from the population that can be selected in a specific stage of a
given survey design.  Examples of sampling units include city blocks,
high schools, hospitals, and houses.

{phang}
{bf:sampling weight}. Given a survey design, the sampling weight for an
individual is the reciprocal of the probability of being sampled.  The
probability for being sampled is derived from stratification and clustering in
the survey design.  A sampling weight is typically considered to be the number
of individuals in the population represented by the sampled individual.

{phang}
{bf:sampling with and without replacement}.
Sampling units may be chosen more than once in designs that use sampling
with replacement.
Sampling units may be chosen at most once in designs that use sampling
without replacement.
Variance estimates from with-replacement designs tend to be larger than
those from corresponding without-replacement designs.

{phang}
{bf:SDR}.
See {it:{help svy_glossary##SDR:successive difference replication}}.

{marker SSU}{...}
{phang}
{bf:secondary sampling unit}.
Secondary sampling unit (SSU) is a cluster that was sampled from within a PSU
in the second sampling stage.  SSU is also used as a generic term unit to
indicate any sampling unit that is not from the first sampling stage.

{marker SRS}{...}
{phang}
{bf:simple random sample}.
In a simple random sample (SRS), individuals are independently sampled -- each
with the same probability of being chosen.

{phang}
{bf:SRS}.
See {it:{help svy glossary##SRS:simple random sample}}.

{phang}
{bf:SSU}.
See {it:{help svy glossary##SSU:secondary sampling unit}}.

{phang}
{bf:standard strata}. See
{it:{help svy glossary##direct_std:direct standardization}}.

{phang}
{bf:standard weights}. See
{it:{help svy glossary##direct_std:direct standardization}}.

{phang}
{bf:stratification}.  The population is partitioned into well-defined groups
of individuals, called strata.
In the first sampling stage, PSUs are independently sampled from
within each stratum.
In later sampling stages, SSUs are independently sampled from
within each stratum for that stage.

{pmore}
Survey designs that use stratification typically result in smaller variance
estimates than do similar designs that do not use stratification.
Stratification is most effective in decreasing variability when sampling units
are more similar within the strata than between them.

{phang}
{bf:subpopulation estimation}. Subpopulation estimation focuses on computing
point and variance estimates for part of the population.  The variance
estimates measure the sample-to-sample variability, assuming that the same
survey design is used to select individuals for observation from the
population.  This approach results in a different variance than measuring the
sample-to-sample variability by restricting the samples to individuals within
the subpopulation; see {manlink SVY Subpopulation estimation}.

{marker SDR}{...}
{phang}
{bf:successive difference replication}.
Successive difference replication (SDR) is a method of variance typically
applied to systematic samples, where the observed sampling units are somehow
ordered.  The SDR variance estimator is described in
{manlink SVY Variance estimation}.

{phang}
{bf:survey data}.  Survey data consist of information about individuals that
were sampled from a population according to a survey design.  Survey data
distinguishes itself from other forms of data by the complex nature under
which individuals are selected from the population.

{pmore}
In survey data analysis, the sample is used to draw inferences about the
population.  Furthermore, the variance estimates measure the sample-to-sample
variability that results from the survey design applied to the fixed
population.
This approach differs from standard statistical analysis, in which the sample
is used to draw inferences about a physical process and the variance measures
the sample-to-sample variability that results from independently collecting
the same number of observations from the same process.

{phang}
{bf:survey design}.  A survey design describes how to sample individuals from
the population.  Survey designs typically include stratification and cluster
sampling at one or more stages.

{phang}
{bf:Taylor linearization}.  See 
{it:{help svy_glossary##linearization:linearization}}.

{phang}
{bf:variance estimation}.  Variance estimation refers to the collection of
methods used to measure the amount of sample-to-sample
variation of point estimates; see {manlink SVY Variance estimation}.
{p_end}
