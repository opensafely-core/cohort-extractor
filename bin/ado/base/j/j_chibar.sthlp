{smcl}
{* *! version 1.1.8  05mar2013}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "[ME] meglm" "mansection ME meglm"}{...}
{vieweralsosee "[ME] mixed" "mansection ME mixed"}{...}
{title:What is chibar2?}

{pstd}
The likelihood-ratio (LR) test that is displayed is testing on the boundary
of the parameter space.  You are probably testing whether an estimated
variance component (something that is always greater than zero) is
different from zero by using an LR test.

{pstd}
Suppose for now that the two models being compared differ only with respect
to the variance component in question, in which case the test statistic will
be displayed as "chibar(01)".  In such cases, the limiting distribution of the
maximum-likelihood estimate of the parameter in question is a normal
distribution that is halved, or chopped off at the boundary -- zero here. 
The distribution of the LR test statistic is therefore not the usual
chi-squared with 1 degree of freedom but is instead a 50:50 mixture of a
chi-squared with no degrees of freedom (that is, a point mass at zero) and a
chi-squared with 1 degree of freedom.

{pstd}
The p-value of the LR test takes this into account and will be set to 1
if it is determined that your estimate is close enough to zero to be, in
effect, zero for purposes of significance.  Otherwise, the p-value displayed
is set to one-half of the probability that a chi-squared with 1 degree of
freedom is greater than the calculated LR test statistic.

{pstd}
Sometimes you are testing whether a variance component is zero {it:in addition}
to testing whether {it:k} other parameters (not affected by boundary
conditions) are zero.  Such situations often arise when comparing
{help me:mixed-effects models}.  For such tests,
the distribution of the likelihood-ratio test statistic is a 50:50 mixture of
chi-squared distributions with {it:k} and {it:k}+1 degrees of freedom, shown
on the output as "chibar(4_5)", for example.  As for chibar(01), significance
levels are adjusted accordingly.

{pstd}
Finally, if you are testing more than one boundary-affected parameter, the
theory is much more complex and usually intractable.  When this
occurs, Stata will either display significance levels that are
{help j_mixedlr:conservative} and marked as such or will not display an 
LR test at all.
{p_end}
