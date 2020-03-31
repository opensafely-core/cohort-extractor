{smcl}
{* *! version 1.0.1  29mar2017}{...}
{vieweralsosee "[ERM] eprobit postestimation" "mansection ERM eprobitpostestimation"}{...}
{title:What is asf?}

{pstd}
In models with endogenous covariates, a contrast of the conditional means or
the conditional probabilities implied by two different covariate values,
with everything else held constant, defines a total effect that differs from
the structural effect usually of interest.

{pstd}
Endogeneity complicates parameter interpretation.  The average structural
function (ASF) resolves the issues by margining out the heterogeneity implied
by the endogeneity.  The ASF is analogous to the marginal function obtained by
margining out the random effects.  Applying the ASF to a conditional mean
produces the average structural mean (ASM).  Applying the ASF to a conditional
probability produces the average structural probability (ASP).

{pstd}
The structural effect is a contrast of the ASMs or ASPs implied by two
different covariate values, with everything else held constant.
{p_end}
