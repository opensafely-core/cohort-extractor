{smcl}
{* *! version 1.0.1  20nov2013}{...}
{p 0 0 2}
{bf:Why are jackknife confidence intervals missing?}

{pstd}
{cmd:strate, jackknife} does not report jackknife confidence intervals in the
following situations:

{phang}
1.  The dataset contains one failure or none.

{phang}
2.  The {cmd:cluster()} option is specified, and the dataset contains only one
    cluster with failures.

{phang}
3.  The {cmd:pweight}s or {cmd:iweight}s were specified when the
    dataset was {cmd:stset}, and the original dataset contains only one
    failure or none.

{pstd}
To ensure that jackknife confidence intervals are bounded between 0 and 1,
a user applies the jackknife method to the logarithm of the survival rate.
The obtained jackknife confidence intervals are then back-transformed
(exponentiated) to the original scale.  In the situations described above, the
jackknife computation fails for the replication containing no failures because
the point estimate (the logarithm of the estimated zero survival rate) is
missing in that replication.  Therefore, the jackknife confidence intervals
are reported as missing in situations 1, 2, and 3.
{p_end}
