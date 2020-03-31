{* *! version 1.0.2  21mar2018}{...}
{phang}
{opt covariance(vartype)} specifies the structure of the covariance
matrix for the random effects and may be specified for each random-effects
equation.  {it:vartype} is one of the following:
{cmd:independent}, {cmd:exchangeable}, {cmd:identity}, {cmd:unstructured},
{opt fixed(matname)}, or {opt pattern(matname)}.

{phang2}
{cmd:covariance(independent)} covariance structure allows for a distinct
variance for each random effect within a random-effects equation and
assumes that all covariances are 0.
The default is {cmd:covariance(independent)} unless a crossed random-effects
model is fit, in which case the default is {cmd:covariance(identity)}.

{phang2}
{cmd:covariance(exchangeable)} structure specifies one common variance for all
random effects and one common pairwise covariance.

{phang2}
{cmd:covariance(identity)} is short for "multiple of the identity"; that is,
all variances are equal and all covariances are 0.

{phang2}
{cmd:covariance(unstructured)} allows for all variances and covariances to be
distinct.  If an equation consists of p random-effects terms, the
unstructured covariance matrix will have p(p+1)/2 unique parameters.

{phang2}
{cmd:covariance(}{opt fixed(matname)}{cmd:)} and
{cmd:covariance(}{opt pattern(matname)}{cmd:)} covariance structures provide a
convenient way to impose constraints on variances and covariances of random
effects.  Each specification requires a {it:matname} that defines the
restrictions placed on variances and covariances.  Only elements in the lower
triangle of {it:matname} are used, and row and column names of {it:matname}
are ignored.  A missing value in {it:matname} means that a given element is
unrestricted.  In a {opt fixed(matname)} covariance structure,
(co)variance (i,j) is constrained to equal the value specified in
the i,jth entry of {it:matname}.   In a {opt pattern(matname)} covariance
structure, (co)variances (i,j) and (k,l) are constrained to be equal if
{it:matname}[i,j] = {it:matname}[k,l].
{p_end}
