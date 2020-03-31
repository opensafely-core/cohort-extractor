{smcl}
{* *! version 1.0.3  05dec2012}{...}
{title:Estimating variance components with mi estimate: xtreg}

{pstd}
Unlike other panel-data commands (for example, {cmd:xtlogit} and
{cmd:xtprobit}),
the {cmd:xtreg} command saves the estimates of variance components or, more
precisely, the standard deviations, in the standard-deviation metric instead of
in the metric used during estimation, the log-standard-deviation metric.  Thus,
multiple-imputation (MI) estimates of these components as obtained from
{cmd:{bind:mi estimate: xtreg}} are based on applying Rubin's combination
rules to the parameters in the standard-deviation metric.  For other
panel-data and mixed-effects models (for example, {cmd:xtlogit} and
{cmd:mixed}), MI estimates are obtained by combining the
variance components in the log-standard-deviation metric and displaying the
results in the standard-deviation metric by applying the appropriate
transformation (the exponentiation for standard deviations and the hyperbolic
tangent for correlations).

{pstd}
In small samples, the sampling distribution of the estimators of variance
components in the log-standard-deviation metric tends to be closer to
normality.  In large samples, the choice of the metric is less important.  As
such, to obtain MI estimates of variance components based on the
log-standard-deviation metric, use {cmd:mi estimate} with {helpb mixed}.
