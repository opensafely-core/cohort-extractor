{smcl}
{* *! version 1.0.5  17oct2015}{...}
{title:Why is small-sample inference not available or denominator degrees of freedom missing?}

{pstd}
When you fit a {cmd:mixed} model and specify option {cmd:dfmethod()},
perform linear hypotheses tests using {bind:{cmd:test, small}} or
{bind:{cmd:testparm, small}} after {bind:{cmd:mixed, dfmethod()}}, or 
perform tests of contrasts using {bind:{cmd:contrast, small}} after
{bind:{cmd:mixed, dfmethod()}},
you may see a missing value for the denominator degrees of freedom (DDF) of
the reported F test.  You may also see a note that small-sample inference is
not available when you use {bind:{cmd:lincom, small}},
{bind:{cmd:contrast, small}}, or {bind:{cmd:pwcompare, small}} after
{bind:{cmd:mixed, dfmethod()}}.  This may occur when you use
{cmd:dfmethod(anova)} or {cmd:dfmethod(repeated)}.

{pstd}
{cmd:dfmethod(anova)} and {cmd:dfmethod(repeated)} cannot
compute DDF for a multiple-hypotheses F test when the degrees of freedom of
the corresponding single-hypothesis t tests are not the same.  Also,
{cmd:dfmethod(anova)} and {cmd:dfmethod(repeated)} cannot compute DDF for a
linear combination of fixed effects that have different DDFs.  In these cases,
small-sample inference is not available.
{p_end}
