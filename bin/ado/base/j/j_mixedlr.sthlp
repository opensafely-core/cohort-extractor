{smcl}
{* *! version 1.0.6  11mar2013}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "[ME] meglm" "mansection ME meglm"}{...}
{vieweralsosee "[ME] mixed" "mansection ME mixed"}{...}
{viewerjumpto "Why is my mixed-effects model LR test conservative" "j_mixedlr##remarks1"}{...}
{viewerjumpto "Distribution theory for mixed-model comparison tests" "j_mixedlr##remarks2"}{...}
{viewerjumpto "How do I interpret the results of this conservative test?" "j_mixedlr##remarks3"}{...}
{viewerjumpto "References" "j_mixedlr##references"}{...}
{marker remarks1}{...}
{title:Why is my mixed-effects model LR test conservative?}

{pstd}
You have performed a likelihood-ratio (LR) test comparing two nested
mixed-effects models, whether it be 1) the test versus a marginal regression
presented at the bottom of the output produced by a {help me:mixed-effects command},
or 2) the comparison of two mixed-effects models via {cmd:lrtest}.  What follows
below discusses the first scenario but applies equally to the second.


{marker remarks2}{...}
{title:Distribution theory for mixed-model comparison tests}

{pstd}
The LR test presented at the bottom of a {help me:mixed-effects command} output
is a comparison of the fitted mixed model to standard regression with no group-level
random effects.  For example, for {helpb melogit} you are comparing with
standard logistic regression.  This LR test assesses whether all random-effects
parameters of the mixed model are simultaneously zero.

{pstd}
When there is only one random-effects parameter to be tested,
this parameter, a variance component, is restricted to be greater than zero.
Because the null hypothesis is that this parameter is indeed zero, which is on
the boundary of the parameter space, the distribution of the LR test statistic
is a 50:50 mixture of a chi2(0) (point mass at zero) and a chi2(1) (point mass
at one) distribution.  Therefore, significance levels in the one-parameter
case can be adjusted accordingly, and no warning that the test is conservative
is displayed.  See 
{help j_mixedlr##SL1987:Self and Liang (1987)}
for the appropriate theory, or see
{help j_mixedlr##GCD2001:Gutierrez, Carter, and Drukker (2001)}
for a Stata-specific discussion.

{pstd}
When there is more than one random-effects parameter to be tested, however, 
the situation becomes more complicated.  Consider a model where
we have two random coefficients with the unstructured covariance matrix

{pmore}
{space 16}{c TLC}{space 13}{c TRC}{break} 
{space 16}{c | } {it:v}_11{space 3}{it:v}_12{space 1}{c |}{break}
{space 16}{c | } {it:v}_12{space 3}{it:v}_22{space 1}{c |}{break}
{space 16}{c BLC}{space 13}{c BRC}{break}

{pstd}
Because the "random" component of the mixed model comprises three
parameters ({it:v}_11,{it:v}_12,{it:v}_22), it would appear that
the LR comparison test would be distributed as chi2(3).  However, there are
two complications that need to be considered.  First, the variances {it:v}_11
and {it:v}_22 are restricted to be positive, and testing them against zero
presents the same boundary condition described above.  Second, constraints
such as {it:v}_11 = 0 implicitly restrict the covariance {it:v}_12 to be zero
as well, and from a technical standpoint, it is unclear how many parameters
need to be restricted to reduce the model to one with no group-level
random effects.

{pstd}
Because of these complications, appropriate and sufficiently 
general computation methods for the more-than-one-parameter case have yet to be
developed.  Theory (for example, 
{help j_mixedlr##SL1994:Stram and Lee [1994]})
and empirical studies (for example, 
{help j_mixedlr##MB1988:McLachlan and Basford [1988]}) have demonstrated
that, whatever the distribution of the LR test statistic, its tail
probabilities are bound above by those of the chi-squared distribution with
degrees of freedom equal to the full number of restricted parameters (three in
the above example).

{pstd}
{help me:Mixed-effects commands} use this
reference distribution, the chi-squared test with full degrees of freedom, to
produce a conservative test.


{marker remarks3}{...}
{title:How do I interpret the results of this conservative test?}

{pstd}
The reported significance level for the LR test is an upper bound on the
actual significance level.  Rejection of the null hypothesis on the basis of
the reported level would therefore imply rejection based on the actual level.


{marker references}{...}
{title:References}

{marker GCD2001}{...}
{phang}
Gutierrez, R. G., S. Carter, and D. M. Drukker. 2001.
sg160: On boundary-value likelihood-ratio tests.  
{browse "http://www.stata.com/products/stb/journals/stb60.pdf":{it:Stata Technical Bulletin} 60}: 15-18.
Reprinted in {it:Stata Technical Bulletin Reprints}, vol. 10, pp. 269-273.
College Station, TX: Stata Press.{p_end}

{marker MB1988}{...}
{phang}McLachlan, G. J., and K. E. Basford. 1988.  {it:Mixture Models}.
New York: Dekker.{p_end}

{marker SL1987}{...}
{phang}Self, S. G., and K.-Y. Liang. 1987. Asymptotic properties of 
maximum likelihood estimators and likelihood ratio tests under nonstandard
conditions.  {it:Journal of the American Statistical Association} 
82: 605-610.{p_end}

{marker SL1994}{...}
{phang}Stram, D. O., and J. W. Lee. 1994. Variance components testing
in the longitudinal mixed effects model. {it:Biometrics} 50: 1171-1177.{p_end}
