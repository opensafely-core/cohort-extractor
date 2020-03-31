{smcl}
{* *! version 1.1.3  11feb2011}{...}
{* This hlp file is called by clickable output in -factor-}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{title:Heywood case}

{pstd}
Factor analysis output mentioning Heywood cases indicates that a boundary
solution, called a Heywood solution, was produced.  The approximations used in
computing the chi-squared value and degrees of freedom for the
likelihood-ratio test are mathematically justified on the assumption that an
interior solution to the factor maximum likelihood was found.

{pstd}
Heywood solutions often produce uniquenesses of 0, and then, at least
at a formal level, the test cannot be justified.  Nevertheless, we believe
that the reported tests are useful, even in such circumstances, provided that
they are interpreted cautiously.  The maximum likelihood method seems to be
particularly prone to producing Heywood solutions.

{pstd}
A message concerning Heywood cases is also printed when, in principle, there
are enough free parameters to completely fit the correlation matrix, another
kind of boundary solution.  We say "in principle" because the correlation
matrix frequently cannot be fit perfectly, so you will see a positive
chi-squared with zero degrees of freedom.  This warning note is printed
because the geometric assumptions underlying the likelihood-ratio test are
violated.
{p_end}
