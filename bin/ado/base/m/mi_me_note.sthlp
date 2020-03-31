{smcl}
{* *! version 1.0.6  23may2018}{...}
{p 0 0 2}
{bf:Why are confidence intervals not reported for some random-effects parameters after} 
{bf:mi estimate with mixed?}

{pstd}
{cmd:mi estimate} does not report confidence intervals for some random-effects
parameters in these situations:

{phang}
1.  You use {cmd:covariance(exchangeable)} or {cmd:covariance(unstructured)}
    in some of your random-effects specifications and use 
    {cmd:mi estimate}'s {cmd:variance} option to display results as variances
    and covariances rather than the default standard deviations and
    correlations.

{phang}
2.  You use {cmd:residuals(exchangeable)} or {cmd:residuals(toeplitz)} with
    {cmd:mixed} and use {bind:{cmd:mi estimate}'s} {cmd:variance} option to
    display results as variances and covariances rather than the default
    standard deviations and correlations.

{phang}
3.  You request group-specific residual structures via {cmd:residuals()}'s
    suboption {cmd:by()} with {cmd:mixed}.

{phang}
4.  You use {cmd:residuals(unstructured)} or {cmd:residuals(banded)} with
    {cmd:mixed}.

{pstd}
In the above situations, some of the displayed random-effects estimates are
obtained via transformations involving multiple parameter estimates.  For
example, in situations 1 and 2, covariances are estimated as functions of the
estimated standard deviations and correlations; in situation 3, group-specific
residual variances are obtained as functions of the residual variance that
corresponds to the baseline category of the grouping variable.  When a
transformation involves multiple MI (multiple imputation) parameter estimates,
the confidence intervals are formed around the transformed point estimate, for
which there is no joint estimate of the MI degrees of freedom.  As such, the
respective confidence intervals are not reported.

{pstd}
You can obtain the confidence intervals in the log-standard-deviation
(estimation) metric by specifying the {cmd:estmetric} option.  If the
{cmd:variance} option is specified, such as in situations 1 and 2, you can
omit it to obtain the confidence intervals in the default standard-deviation
metric.
