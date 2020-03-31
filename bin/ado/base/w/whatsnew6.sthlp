{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 6}

{pstd}
This file records the additions and fixes made to Stata during the life
of Stata version 6:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {help whatsnew14}       Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
    {c |} {help whatsnew13to14}   Stata 14.0 new release       2015            {c |}
    {c |} {help whatsnew13}       Stata 13.0 and 13.1          2013 to 2015    {c |}
    {c |} {help whatsnew12to13}   Stata 13.0 new release       2013            {c |}
    {c |} {help whatsnew12}       Stata 12.0 and 12.1          2011 to 2013    {c |}
    {c |} {help whatsnew11to12}   Stata 12.0 new release       2011            {c |}
    {c |} {help whatsnew11}       Stata 11.0, 11.1, and 11.2   2009 to 2011    {c |}
    {c |} {help whatsnew10to11}   Stata 11.0 new release       2009            {c |}
    {c |} {help whatsnew10}       Stata 10.0 and 10.1          2007 to 2009    {c |}
    {c |} {help whatsnew9to10}    Stata 10.0 new release       2007            {c |}
    {c |} {help whatsnew9}        Stata  9.0, 9.1, and 9.2     2005 to 2007    {c |}
    {c |} {help whatsnew8to9}     Stata  9.0 new release       2005            {c |}
    {c |} {help whatsnew8}        Stata  8.0, 8.1, and 8.2     2003 to 2005    {c |}
    {c |} {help whatsnew7to8}     Stata  8.0 new release       2003            {c |}
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {bf:this file}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.
Note:  Starred (*) items mean the update was made to the executable.


{hline 5} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew6to7}.


{hline 5} {hi:update 20nov2000} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-58


{hline 5} {hi:update 03nov2000} {hline}

{p 0 4}
{help biprobit} had difficulty parsing the second equation when it was longer
than 80 characters; in that case, if the first and second equations were
identical for the first 80 characters, {cmd:biprobit} would use the first
equation as the second equation, and so estimate a model which was not the one
requested.  This has been fixed.

{p 0 4}
{help glm} with {cmd:family(binomial)} would report an error if the dependent
variable did not vary even when the binomial denominator did.  This has been
fixed.

{p 0 4}
{help xtpcse} with the options {cmd:correlation(ar1)} or
{cmd:correlation(psar1)} was reporting an uncentered R-squared -- an R-squared
with a base of 0 rather than the mean of the dependent variable -- and
associated model sum of squares {hi:e(mss)} and model degrees of freedom
{hi:e(df_m)}.  It now computes a centered R-squared unless option
{cmd:noconstant} is specified.

{hline 5} {hi:update 25oct2000} {hline}

{p 0 4}
{help stsplit}, as updated 19sep2000, when used with datasets containing more
than 32,766 observations, would fail to split the data correctly. This has
been fixed.

{hline 5} {hi:update 12oct2000} {hline}

{p 0 4}
{help stcurv}, with multiple failure data and used after {cmd:streg,}
{cmd:dist(lognormal)}, produced a graph with a jagged line; this has been
fixed.  In addition, {cmd:stcurv} used after {cmd:streg,}
{cmd:dist(exponential)} had a spelling error on the default labeling of the
axis.

{p 0 4}
{help vif} on rare occasions would fail to compute variance inflation factors
for all the rhs variables in the model.

{hline 5} {hi:update 19sep2000} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-57

{p 0 4}
{help bstat} has a new option {cmd:title()} allowing the title on the output
to be changed.

{p 0 4}
{help stcox} did not save in {hi:e()} the names of the variables created when
the {cmd:basehazard()}, {cmd:basechazard()}, or {cmd:basesurv()} options were
specified and fully spelled out rather than entered as abbreviations, such as
{cmd:baseh()}, {cmd:basec()}, and {cmd:bases()}.  This caused no problems
whatsoever, but could cause problems if you wanted to use the saved results.

{p 0 4}
{help stcurv}'s new {cmd:outfile(}{it:filename}{cmd:)} option will save the
data generated to produce the graphed curves in a Stata .dta dataset for later
use.

{p 0 4}
{help stsplit} has been improved.  It runs faster, it has additional options,
and it has a new syntax that facilitates splitting at failure times.  See help
{help stsplit}.  In addition, the new help file stsplit2 is very much
like a FAQ in that it explains the usefulness of splitting at failure times
and the relationship between {help stcox}'s {cmd:exactp} option and
conditional logistic regression estimates produced by {help clogit}; see help
stsplit2.  There were no bugs in the previous {cmd:stsplit}.

{hline 5} {hi:update 11sep2000} {hline}

{p 0 4}
{help alpha} with option {cmd:generate()} would fail with an "invalid syntax"
error message if the option was completely spelled out; this is fixed.

{p 0 4}
{help avplot} after {help regress} with the {cmd:cluster()} option would title
the resulting plot using the non-robust standard error.

{p 0 4}
{help xtgee} on rare occasions would fail with error message r(505) "matrix
not symmetric". This has been fixed.

{hline 5} {hi:update 18aug2000} {hline}

{p 0 4}
{help tabstat} has a new {cmd:statistics(sdmean)} option to produce standard
deviation of the mean, the {cmd:statistics()} option is now case insensitive,
and the default output format has been changed if only one variable is
specified.

{hline 5} {hi:update 15aug2000} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
{help rotate} with the {cmd:varimax} option, used after {help factor} with two
factors retained, produced incorrect answers; results are now correct.

{hline 5} {hi:update 14aug2000} {hline}

{p 0 4}
{help dprobit} would give an error message if any of the independent variables
contained the string "_cons" in the variable name.

{p 0 4}
{help xtpcse} with the option {cmd:correlation(ar1)} or
{cmd:correlation(psar1)} now constrains estimates of panel-level
autocorrelation to be in the range [-1,1].  This bounding imposes the
theoretical limits on the correlations and allows the Prais-Winsten
computation to always be performed.  The change only affects estimation
results for unusual datasets where any estimated panel-level autocorrelation
fell outside the range [-1,1].  Even in these cases, the new results are
asymptotically equivalent to the prior results.

{hline 5} {hi:update 02aug2000} {hline}

{p 0 4}
{help avplot} after {help regress} with the {cmd:robust} option would title
the resulting plot using the non-robust standard error.

{p 0 4}
{help dfuller} reported an incorrect 1% critical value when the number of
observations was between 101 and 500 and options {cmd:trend} and
{cmd:noconstant} were not specified.

{p 0 4}
{help pperron} reported incorrect Z(t) and Z(rho) statistics.  In addition, as
with {cmd:dfuller}, {cmd:pperron} reported incorrect 1% critical values when
the number of observations was between 101 and 500 and options {cmd:trend} and
{cmd:noconstant} were not specified.

{hline 5} {hi:update 17jul2000} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-56

{hline 5} {hi:update 07jul2000} {hline}

{p 0 4}
{help xtpcse} when specified with the {cmd:pairwise} option would exit with a
"matrix not positive definite" message in the unusual case when the estimated
covariance matrix of the disturbances was not positive definite.  The error
message has been improved to state that the pairwise option may not be used.
As noted in help {help xtpcse}, this can only occur when the {cmd:pairwise}
option is specified.

{p 0 4}
{help strate} with option {cmd:smr} and option {cmd:output()} would fail with
an error message.  It now works.

{p 0 4}
{help stsum} with option {cmd:by()}, and when two variables were specified in
the {cmd:by()}, would sometimes display the stub of the table with quote
characters in odd positions.  This is fixed.

{hline 5} {hi:update 03jul2000} {hline}

{p 0 4}
{help stset}, due to a recent update, when
{cmd:exit(}{it:eventvar}{cmd:==}{it:numlist} {cmd:time} {it:varname}{cmd:)}
was specified, could ignore the events in favor of the time, treating the
option as if {cmd:exit(time} {it:varname}{cmd:)} had been specified.  The same
could happen with the {cmd:enter()} and {cmd:origin()} options.  The problem
could only occur when both an event list and a time were specified; there was
no problem with statements such as
{cmd:exit(}{it:eventvar}{cmd:==}{it:numlist}{cmd:)} or
{cmd:exit(time} {it:varname}{cmd:)}.

{hline 5} {hi:update 29jun2000} {hline}

{p 0 4}
{help ml} has improved convergence properties for pathological likelihoods
where one or more parameters are being driven to positive or negative
infinity.

{p 0 4}
{help reshape}, in a certain case, gave an unhelpful error message.  The error
message has been improved.

{p 0 4}
{help sts} {cmd:generate}, in rare circumstances, would give an error message
rather than producing the requested result.  That is fixed.

{p 0 4}
{help tabstat} is a new command to display a table of summary statistics; see
help {help tabstat}.

{p 0 4}
{help xi} would give an error message if one or more of the variables in the
model contained a constant; {cmd:xi} should have not complained and simply
allowed the model to be estimated.  This arose as a side effect of the
12jun2000 update and is now fixed.

{hline 5} {hi:update 26jun2000} {hline}

{p 0 4}
{help wntestb} had an unnecessary global macro that was never explicitly used
but could on occasion be outputted on the graph's title. This has been fixed.

{p 0 4}
{help xthaus} when used with no covariates which vary within panel would
produce a syntax error. It now gives a more informative error message.

{p 0 4}
{help xtpcse} specified with options {cmd:correlation(ar1)} and
{cmd:pairwise}, and when there were no observations on which to compute the
autocorrelation parameter, would exit with the error message "matrix has
missing values".  It now exits with the appropriate error message
"insufficient observations".

{hline 5} {hi:update 12jun2000} {hline}

{p 0 4}
{help collapse} would not allow a mix of its two syntaxes, one of which
specified the name of the new variable and the other of which did not, such as
"{cmd:collapse newvar1=oldvar1 oldvar2 newvar3=oldvar3}".
"{cmd:collapse newvar1=oldvar1 newvar3=oldvar3}" was allowed as was
"{cmd:collapse oldvar2}", but you could not mix the two together into one
statement.  Now you can.

{p 0 4}
{help xi} would give a syntax error if what followed it contained a reference
to a Stata function.  This was fixed on 31may2000, but not completely.

{hline 5} {hi:update 31may2000} {hline}

{p 0 4}
{help dstdize} now saves numbers of observations, unadjusted, and adjusted
rates for use by other programs; see help {help dstdize} for details.

{p 0 4}
{help xi} would give a syntax error if what followed it contained a reference
to a Stata function.  This has been fixed.

{hline 5} {hi:update 25may2000} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
{help xtclog} produced estimates of the parameters and standard errors that
were only accurate to a few digits or, in a few cases, failed to converge.
This was traced to an error in the calculation of the matrix of 2nd
derivatives and is fixed.

{hline 5} {hi:update 24may2000} {hline}

{p 0 4}
{help ci} with the options {cmd:poisson} and {cmd:by()} along with an {cmd:if}
restriction would fail to produce results when one of the by groups had no
observations meeting the if condition.

{p 0 4}
{help hausman} output makes it clearer that the more efficient model in the
test must be fully efficient.

{hline 5} {hi:update 08may2000} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-55

{hline 5} {hi:update 19apr2000} {hline}

{p 0 4}
{help codebook} would produce an error when sent certain variable names such
as {hi:_d}.  This has been fixed.

{p 0 4}
{help fracpred} with the {cmd:dresid} option and {help fracplot} gave
uninformative error messages after "{cmd:fracpoly clogit} ..." or
"{cmd:fracpoly probit} ..."  They now produce more informative errors.  (The
manual does not list {cmd:fracpoly} as working with {help clogit} and
{help probit}, but it does.  Neither {cmd:clogit} nor {cmd:probit}, however,
can produce deviance residuals and so {cmd:fracplot} and
{cmd:fracpred, dresid} are not allowed after {cmd:fracpoly} with either of
these commands.)

{p 0 4}
{help gladder} now works with variables with nonpositive values.

{p 0 4}
{help nl} now includes an {cmd:if} exp on an "{cmd:nl ?}" call.  See "Advanced programming of
    nlfcns" in help {help nl}.  On a query call, the syntax is now

{p 8 16}{cmd:nlfcn} {cmd:?} [{it:varlist}] {cmd:if} {it:exp} [{cmd:,} {it:options}]

{p 4 4}This allows the nlfcn to perform initialization computations restricted
to the relevant subsample within the portion of the code that sets the initial
parameters into global macros.  In addition, {cmd:nl} will no longer remove
existing variables with the same name (or similar name based on abbreviation
rules) as the parameter names.  The {cmd:leave} option is still supported, but
a check is first made that no existing variables by those names exist before
creating the variables.

{p 0 4}
{help predict} after {help stcox} and {cmd:cox} reported hazard ratios of 1
rather than exp(x*b) whenever x*b>18.  This has been fixed.

{p 0 4}
{help qladder} is a new command that displays the quantiles of transforms of
varname according to the ladder of powers against the quantiles of a normal
distribution.

{p 0 4}
{help snapspan} with the {cmd:generate(}{it:newt0var}{cmd:)} option now
formats {it:newt0var} to have the same format as the {it:timevar}.

{p 0 4}
{help svyolog}, {help svyoprob}, and {help svymlog} produced uninformative
error messages when there were more than 50 outcomes (a Stata limit).  It now
produces the appropriate error message and return code r(149).

{p 0 4}
{help xtpcse} now allows the time variable to be used as a regressor with any
set of options.  Previously, {cmd:xtpcse} refused to estimate models with the
time variable as a regressor when options {cmd:correlation(ar1)} or
{cmd:correlation(psar1)} were specified.

{hline 5} {hi:update 17apr2000} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
{help display}'s {cmd:_request()} option now allows more than 80 characters of
input.

{p 0 4}
{help format} {cmd:_all} caused a crash if there were no data in memory; that
is fixed.

{p 0 4}
{help matrix} {cmd:accum} now produces an error when _N==1.

{p 0 4}
{help matrix} {cmd:glsaccum} now produces correct results when used with
time-series operators, and when the {cmd:rows()} option is used to repeat rows
of the weighting matrix.  In addition, {cmd:matrix} {cmd:glsaccum} now
produces an error message when the data are not sorted by group and when the
weighting matrix in nonsymmetric.

{p 0 4}
{help matrix} {cmd:vecaccum} with time-series operators now correctly labels
the rows.

{p 0 4}
Power calculations a^b are now calculated by repeated multiplication for
integer values of b<=32; previously b<=4 was used.  This makes results more
accurate.

{p 0 4}
In matrix expressions, the {cmd:nullmat()} function worked only on the left
hand side of the comma and backslash operators; it now works on both the left
and right hand sides.


{p 0 4}
{hi:Stata executable}(*), Unix.

{p 0 4}
Under Solaris, the message "operating system refuses to spawn new process"
should no longer appear when you attempt an {help ls} or {help shell} command.

{p 0 4}
Under Red Hat 6.2, some people reported that Stata crashed when invoked,
before the initial prompt.  That is now fixed.

{hline 5} {hi:update 05apr2000} {hline}

{p 0 4}
{help xtgls} with options {cmd:corr(ar1)} or {cmd:corr(psar1)} did not fully
honor the {cmd:force} option and this could lead to the error r(504) "matrix
has missing values".  {cmd:xtgls} now always honors the {cmd:force} option.

{p 0 4}
{help xtpcse} now allows estimation when the panel-level autocorrelation
parameter, rho_i, cannot be computed for one or more panels and the option
{cmd:correlation(psar1)} has been specified.  Previously, {cmd:xtpcse} would
return the error message r(504) "matrix has missing values" and refuse to
estimate the model; it now assumes that these correlations are 0 and proceeds
with the estimation.

{hline 5} {hi:update 27mar2000} {hline}

{p 0 4}
{help sts} {cmd:list} with the {cmd:by()} option used an incorrect display
format when the by-variable was numeric.  Although the output was correct, the
most appropriate display format was not always used.

{p 0 4}
{help svytab} produced an "operator invalid"; r(198) error message when there
were value labels containing a period.  This has been fixed.

{hline 5} {hi:update 24mar2000} {hline}

{p 0 4}
{help intreg} now handles {help aweight}s differently; see comment concerning
20mar2000 update to {cmd:tobit} and {cmd:cnreg} below.

{p 0 4}
{help kwallis} was updated 09mar2000 to report an adjusted-for-ties
chi-squared statistic.  This new statistic was calculated incorrectly when
there were missing values.

{p 0 4}
{help xtclog}, {help xtlogit}, {help xtnbreg}, {help xtpois}, {help xtprobit},
and {help xtreg}, all with the {cmd:pa} option, no longer allow {help aweight}s.
With {cmd:pa}, however, they all now allow {help fweight}s.  All now work with
the {cmd:noconstant} option.

{p 0 4}
{help xtgee} has had numerous changes made to it.  These include

{p 4 8}1.  The default divisor for computing correlations and standard errors
has been changed from 1/(N-p) to 1/N.  New option {cmd:nmp} will produce the
previous results.  (Which divisor is used is of little importance since both
are asymptotically correct.  1/N has the slight advantage in that it scales;
see help {help xtgee}.

{p 4 8}2.  In the particular case of {cmd:family(gaussian)}, the default
normalization for calculating the robust VCE is now n/(n-1) instead of
[n/(n-1)]*[(N-1)/(N-p)], where n = # of panels and N = # of observations, and
this change was made for the same reasons as (1).  New option {cmd:rgf} will
reproduce the previous results.

{p 4 8}3.  The calculation of the working correlation matrix, and thus the
resulting estimates, in the case of unbalanced panels with
{cmd:corr(nonstationary)} or {cmd:corr(unstructured)}, has been changed.

{p 4 8}4.  {cmd:xtgee} no longer allows {help aweight}s.

{p 4 8}5.  {cmd:xtgee} now allows {help fweight}s.

{p 4 8}6.  The way {cmd:xtgee} calculates weighted results has changed.

{p 4 4}See {browse "http://www.stata.com/support/faqs/stat/xtgeetech.html"}
for a technical FAQ on this.

{p 4 4}For these changes to take effect, you must also install the 20mar2000
executable update.

{hline 5} {hi:update 20mar2000} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
{help clogit} with no right-hand-side variables reported an obviously
incorrect log-likelihood value when there was more than one failure per group.
In addition, {cmd:clogit} with the {cmd:offset()} option reported an incorrect
model chi-squared statistic.

{p 0 4}
Matrix function {cmd:det()} was reported to return a 0 for the determinant
when the matrix had zeros on the diagonal; that is fixed.

{p 0 4}
{help mlogit}'s convergence has been improved; it now converges for some
models where previously it did not.  (This resulted from improving the way
stepping is handled in the internal optimizer and should improve convergence
of all models).

{p 0 4}
{help tobit} and {help cnreg} now handle {help aweight}s differently.
Previously, they were just scaled and applied to the likelihood function in
the "ordinary" way, but that solves no real-world problem.  Now they are
applied in the correct way to deal with cell-mean data with these two
likelihood functions.

{p 4 4}
({cmd:aweight}s have been going through a change for many releases now.  They
started as being defined as rescaled {cmd:fweight}s, perhaps useful, and
perhaps not, and most estimators allowed them.  Later, {cmd:aweight}s, still
defined in this mechanical way, were deleted from estimators in which they
solved no real-world problem.  By that logic, {cmd:aweight}s should have been
deleted from {cmd:tobit} and {cmd:cnreg}.  {cmd:aweight}s are now in the
process of being given a different definition:  that of producing estimates
when the estimator is applied to cell-mean data, even if this requires
changing the mechanical definition.  The mechanical definition arose because
it was the solution to handling cell-mean data in linear regression.)

{p 0 4}
{help tobit} and {help cnreg} now produce better starting values and so should
converge more quickly.  There was previously one report of a model in which
{cmd:tobit} refused to converge; the new starting values fix that.

{p 0 4}
Internal changes were made to support the 24mar2000 update to {help xtgee},
listed above.


{p 0 4}
{hi:Stata executable}(*), Unix.

{p 0 4}
Stata would refuse to execute from a Gnome terminal under Red Hat Linux 6.1.
That is fixed.

{hline 5} {hi:update 13mar2000} {hline}

{p 0 4}
{help egen}'s {cmd:robs()} function with the {cmd:strok} option (introduced
16Aug1999) counted the number of missing instead of the number of non-missing
observations.  This has been fixed.

{p 0 4}
On-line help and search index brought up to date for STB-54

{hline 5} {hi:update 09mar2000} {hline}

{p 0 4}
{help biprobit} has been improved in three ways.  (1) {cmd:biprobit} did not
respect the {cmd:ml} options; this has been fixed.  (2) {help predict} after
{cmd:biprobit} defaulted to {cmd:pmarg1} when, per the documentation, it
should have defaulted to {cmd:p11}.  (3) {cmd:biprobit} with {cmd:partial}
option would report incorrect values for the comparison test of rho=0.

{p 0 4}
{help cttost} would fail if an enter variable was specified to indicate
delayed entry.

{p 0 4}
{help heckman} has four new options for use when option {cmd:twostep} is
specified:  {cmd:rhosigma}, {cmd:rhotrunc}, {cmd:rholimited}, and
{cmd:rhoforce}.  These options affect the handling of estimates of rho outside
the bounds [-1,1] and are relevant only with the two-step method because
obtaining values outside those bounds is not possible using maximum
likelihood.  In addition to help {help heckman}, see
{browse "http://www.stata.com/support/faqs/stat/twosteprho.html"} for
technical details.

{p 0 4}
{help kwallis} now reports both the unadjusted and the adjusted-for-ties
chi-squared statistics and associated p-values.

{p 0 4}
{help strate} when used with the {cmd:output()} option would save the
person-time values in a string rather than numeric variable.  This has been
fixed.

{p 0 4}
{help stset} with the {cmd:time0(}{it:varname}{cmd:)} option correctly did not
use observations with missing values of {it:varname}, but incorrectly did not
use such observations even when processing the
{cmd:entry(}{it:eventvar}{cmd:==}{it:numlist}{cmd:)} option.  A missing value
of {cmd:time0()} for the first observation on a subject is reasonable and even
so, that record should be able to trigger entry-into-the analysis because it
is the data on the subsequent record (for which {cmd:time0()} is not missing)
that is relevant.

{hline 5} {hi:update 21feb2000} {hline}

{p 0 4}
{help heckman} with the {cmd:twostep} option, and only with the {cmd:twostep}
option, produced incorrect standard errors (they were overly conservative) and
incorrect estimate of rho (it was attenuated toward zero) when all (emphasis
on all) the independent variables in the regression equation were nonmissing
in any observation flagged as not observed.

{p 0 4}
{help table} with the {cmd:replace} option would give an error message if a
variable named {cmd:table1} was already defined in the dataset.

{p 0 4}
{help webseek} under Windows and Mac did not honor the {cmd:results}
option.

{hline 5} {hi:update 09feb2000} {hline}

{p 0 4}
{help gamma}, {help gompertz}, {help llogist} and {help lnormal} parametric
survival regression models, when used outside the {cmd:st} system, would fail
if the failure-event variable was not coded 0/1. This has been fixed.  These
programs assume that the failure-event variable is 0 if the observation is
censored and a value other than 0 -- typically 1 -- if the observation
represents a failure.

{p 0 4}
{help kap} now reports and saves in {hi:r(se)} the standard error for the
estimated kappa statistic. Also, the output table now uses a better display
format for the outcome value when {cmd:kap} is used with more than two raters
and a non-integer scale.

{p 0 4}
{help stset} without arguments and {help streset} failed to reset the data
properly if {cmd:failure(}{it:varname}{cmd:==}{it:numlist}{cmd:)} was
originally specified, for example {cmd:failure(event==12 13 14)}.  In
addition, the text of an observation-exclusion message was changed from "obs
begin on or after enter" to "obs begin on or after exit" or "obs begin on or
after first failure", as appropriate.  Only the text of the message was
changed.

{p 0 4}
{help xtgls} now returns the more appropriate error code 459 rather than 498
when the data do not meet the requirements of the estimator.

{p 0 4}
{help xthaus} now refuses to perform the Hausman test and suggests use of the
command {help hausman} when the estimate of sigma_u (the estimate of the
variance of the random effect) is 0.  The random-effects estimator in this
case has degenerated to pooled OLS and the difference of the
variance-covariance matrices computed by {cmd:xthaus} may no longer be
positive definite.  The test statistics reported by the more general
{cmd:hausman} command are preferred when the difference matrix is not positive
definite.

{hline 5} {hi:update 28jan2000} {hline}

{p 0 4}
{help webseek} is a new command to perform a keyword search of user-written
additions to Stata.  {cmd:webseek} searches not only the STB but the entire
web, including user sites.

{hline 5} {hi:update 27jan2000} {hline}

{p 0 4}
{help arch}, {help heckman} and {help intreg} now check for collinearity
between the dependent and independent variables. If collinearity exists, an
error message explaining which variables are collinear is displayed.

{p 0 4}
{help stcurv} now accepts multiple
{cmd:at(}{it:varname}{cmd:=}{it:#} ...{cmd:)} options, called {cmd:at1()},
{cmd:at2()}, ..., {cmd:at10()}.  This allows multiple curves to be plotted on
the same graph.

{hline 5} {hi:update 21jan2000} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
Stata can now allocate up to 16,384 gigabytes of memory if the hardware
supports it.  (With the exception of the 64-bit DEC Alpha, most hardware can
support only 4 gigabytes.)

{p 4 4}
There is a new {cmd:-m} (Unix) {cmd:/m} (Windows) start up option that works
like {cmd:-k} ({cmd:/k}) except that memory is specified in megabytes, not
kilobytes.

{p 0 4}
Stata misparsed expressions with a very unusual set of characteristics, for
example "{cmd:(substr(`"a"bc"',1,1)=="f")|(1)}" and similar expressions that
had (1) open and close parentheses at the beginning and end, (2) the
parenthesis did not match, (3) a function was used inside the parentheses, and
(4) the expression contained both simple and compound double quotes.  This has
been fixed.

{p 0 4}
{help graph}{cmd:,} {cmd:c(L)} mistakenly connected points when values of
x[_n-1]>x[_n] but the values were exceedingly close.  This has been fixed.

{p 0 4}
{help matrix} and {help scalar} will no longer create matrices and scalars
with the reserved names {hi:_pred}, {hi:_b}, {hi:_n}, {hi:_N}, {hi:float},
{hi:double}, {hi:int}, {hi:long}, {hi:_uniform}, {hi:_coef}, {hi:_rc},
{hi:_pi}, and {hi:byte}.

{p 0 4}
{help matrix} {it:name} {cmd:=} {it:exp} could sometimes report an "expression
too long" error when the expression was not too long, depending on the
expressions previously executed (technically, {cmd:matrix} did not clear the
literal stack).  This has been fixed.

{p 0 4}
{help predict}{cmd:, residual} after {cmd:regress, robust} now produces
correct results when the dependent variable contains time-series operators.

{p 0 4}
{hi:Stata executable}(*), Windows 3.1:{p_end}
{p 4 4}{help dir} had a y2k bug and reported two-digit years for the file date
and reported "100" for files dated 2000.  This has been fixed.

{p 0 4}
{hi:Stata executable}(*), Windows 2000/98/95/NT:{p_end}
{p 4 4}On the print log, the radio button for printing a selection is now
disabled as it always should have been.

{p 0 4}
{hi:Stata executable}(*), Windows 2000/98/95/NT and Unix:{p_end}
{p 4 4}Do-files with Mac end-of-line characters (carriage return only)
can now be executed without translation.

{hline 5} {hi:update 19jan2000} {hline}

{p 0 4}
{help areg} and {help xtreg} with the {cmd:fe}, {cmd:be}, and {cmd:re} options
({cmd:xtreg} without {cmd:mle}) now produce more accurate results.  For most
datasets, this improvement changes coefficient estimates in the 9th or 10th
decimal place.

{p 4 4}
Internally, all of these estimators work by transforming the data into
differences from group means, pseudo differences from group means, or the
group means themselves.  Previously, the transformed data was calculated in
double precision but stored in float precision unless the original variable
was double.  Now transformed results are stored in double precision in all
cases.

{p 0 4}
{help xtdata} has new option {cmd:nodouble}.  {cmd:xtdata}'s default behavior
has been changed so that the transformed variables are recast to double,
making results slightly more precise.  Option {cmd:nodouble} restores the
previous behavior.

{hline 5} {hi:update 14jan2000} {hline}

{p 0 4}
{help arch} now computes, in all cases, the model chi-square test using all
coefficients entering the specification of the conditional mean.  Previously,
in the specific case where option {cmd:archm} was specified with options
{cmd:ar()} or {cmd:ma()} and no independent variable list was specified, the
{cmd:ar()} and/or {cmd:ma()} terms were excluded from the test.

{p 0 4}
{help areg} now saves the adjusted R-square in {hi:e(ar2)}.

{p 0 4}
{help prtesti} has new option {cmd:count}.  {cmd:count} specifies that counts
rather than proportions are specified.  For example, "{cmd:prtesti 20 .2 30 .3}"
tests whether an observed proportion of .2 in 20 observations could be from
the same population and an observed proportion of .3 in 30 observations.
"{cmd:prtesti 20 4 30 9, count}" performs the same test but the observed
frequencies are specified as counts.

{p 0 4}
{help xtgls} previously implemented a generalization of PCSEs that allowed
users too easily to request covariance structures that are NOT what most
people currently mean by PCSE.  This would occur if
{cmd:panels(heteroskedastic)}, {cmd:panels(independent)}, or no {cmd:panels()}
option was specified.

{p 4 4}
Now {cmd:xtgls}, when specified with options {cmd:pcse} or {cmd:ols}, invokes
the new command {help xtpcse} to perform OLS and Prais-Winsten regressions
with panel corrected standard errors (PCSE).

{p 4 4}
If options {cmd:ols} or {cmd:pcse} are specified and the requested covariance
structure is not {cmd:panels(correlated)}, {cmd:xtgls} will now display an
error message.  {cmd:xtgls}'s previous behavior can be obtained by specifying
the option {cmd:forcepcse}.

{p 4 4}
{cmd:xtgls} has also been modified to return the estimated disturbance
{hi:e(Sigma)} that was used in computing the coefficient and variance
estimates and to use this estimate in computing the log likelihood.
Previously, if the option {cmd:twostep} was specified, {cmd:xtgls} returned an
estimate of Sigma based on the FGLS coefficient estimates.  The two estimates
of Sigma are asymptotically equivalent.  The numerical accuracy of xtgls has
also been improved when {cmd:corr(ar1)} or {cmd:corr(psar1)} are specified.

{p 0 4}
{help xtpcse} is a new command to more accurately reflect the use of the term
PCSE in the literature.  In addition to providing the functionality of
{cmd:xtgls, ols} and {cmd:xtgls, pcse}, {cmd:xtpcse} allows for unbalanced
panels, estimation of autocorrelation parameters when there are gaps in the
time series, and the use of time-series operators.

{hline 5} {hi:update 13jan2000} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-53.

{hline 5} {hi:update 03jan2000} {hline}

{p 0 4}
{help ivreg} now produces a better error message when the equal sign is not
specified to separate the instrumented variables from the instrument list.

{p 0 4}
{help xtgls}'s help now clearly documents how parameter estimates are computed
when options {cmd:pcse} or {cmd:ols} are combined with a specification for
autocorrelation -- option {cmd:corr(ar1)} or {cmd:corr(psar1)}.

{p 0 4}
{help predict} after {help reg3} when the {cmd:residual} option is specified
and more than one equation has the same dependent variable, now computes
residuals properly.  Previously, in this unusual event, the negative of the Xb
prediction was returned instead of the residual.

{hline 5} {hi:update 22dec1999} {hline}

{p 0 4}
{help biprobit} now identifies collinearity among variables and its error
messages have been improved.

{p 0 4}
{help collapse}'s {cmd:sum} and {cmd:rawsum} statistics now compute all sums
in double precision.  Previously sums were calculated in double precision only
if the original variable was of type {help long} or {help double}.

{p 4 4}
{cmd:collapse} now also allows spaces between the parentheses and the
statistic name.  For example, before you had to type "{cmd:collapse (mean) x}",
now you can type "{cmd:collapse ( mean ) x}".

{p 0 4}
{help for} incorrectly limited the number of concurrent lists to 8 instead of
9.  This has been fixed.

{p 0 4}
{help hausman} could not perform the test when one estimator used equation
names and the other did not.  New option {cmd:equations()} solves this
problem; see help {help hausman}.

{p 0 4}
{help tsfill} with the {cmd:full} option could on occasion produce entries
within a panel with incorrect time values resulting in two entries with the
same time value and another time value absent.  This has been corrected.

{hline 5} {hi:update 17dec1999} {hline}

{p 0 4}
{help prtesti} reset the default confidence level for confidence intervals if
you specified its {cmd:level()} option, meaning all subsequent commands showed
confidence intervals of that level until you "{cmd:set level 95}" again.
{cmd:prtesti} no longer does that.

{p 0 4}
{help stset}'s {cmd:origin(}{it:varname}{cmd:=}{it:#s}{cmd:)},
{cmd:enter(}{it:varname}{cmd:=}{it:#s}{cmd:)}, and
{cmd:exit(}{it:varname}{cmd:=}{it:#s}{cmd:)} options, did not work unless
varname was the same as the failure variable.  E.g.,
"{cmd:failure(outcome==5) exit(outcome==3)}" did work but
"{cmd:failure(outcome==5) exit(diag2==32)}" did not.  This is fixed.

{hline 5} {hi:update 06dec1999} {hline}

{p 0 4}
{help heckman} and {help heckprob}, if the dependent variable was abbreviated,
used the abbreviated name on the output (as well as to label the saved results
{hi:e(b)} and {hi:e(V)}).

{p 0 4}
{help kdensity}, when {cmd:aweight}s were specified, would mistakenly report
"... real changes made".

{p 0 4}
{help strate} would distort the table alignment when reporting large values.

{p 0 4}
{help tabodds} produced an ambiguous error message when {it:case_var} was not
numeric. The error message has been changed.

{p 0 4}
{help ttest} and {help sdtest}, when used with {cmd:by()}, and in particular
when the by-variable had a variable label containing parentheses, quotation
marks, etc., would fail with an uninformative error message.

{hline 5} {hi:update 30nov1999} {hline}

{p 0 4}
{help ivreg} now saves in {hi:e(insts)} the full list of exogenous variables
rather than an abbreviated list containing the first few exogenous variables
followed by an ellipse (...).

{p 0 4}
{help prtesti} with {cmd:level(}{it:#}{cmd:)} option would incorrectly produce
an error message; this has been fixed.

{hline 5} {hi:update 22nov1999} {hline}

{p 0 4}
{help arch}'s {cmd:predict} will now produce predictions for ARCH models with
ARCH-family terms and with multiplicative heteroskedasticity.  Previously,
{cmd:predict} refused to produce predictions for these models.  {cmd:predict}
will also now handle lags and other operated forms of the dependent variable
in the multiplicative heteroskedastic component, that is, when the original
model was estimated with {cmd:arch}'s {cmd:het()} option.

{p 0 4}
{help dprobit} now names the columns of the saved matrices {hi:e(dfdx)} and
{hi:e(se_dfdx)} with the variable names from the estimated model.

{p 0 4}
{help heckprob} with {cmd:nolog} option would incorrectly produce an
"unrecognized command:  nolog" error message; this has been fixed.

{p 0 4}
{help logistic} has new option {cmd:coef} which causes {cmd:logistic} to
report the estimated coefficients rather than the odds ratios (exponentiated
coefficients).

{p 0 4}
{help sts} {cmd:graph} with option {cmd:enter} and not {cmd:lost}, would not
report the number who enter and the number censored on the graph; you had to
specify both the {cmd:enter} and {cmd:lost} options.  Now {cmd:enter} implies
{cmd:lost}.

{p 0 4}
{help xtgls} now uses a default maximum iterations of 16,000 when option
{cmd:igls} is specified.

{hline 5} {hi:update 17nov1999} {hline}

{p 0 4}
{help cs}'s {cmd:by()} option has been enhanced to take more than one
stratification variable.

{p 0 4}
{help stdes} with the {cmd:weight} option would incorrectly produce an
"invalid syntax" error message; this has been fixed.

{p 0 4}
{help svytab} with only one row or column would produce an error "name
conflict"; r(507).  This has been fixed.

{p 0 4}
{help svytotal}, {help svymean}, and {help svyratio} produced an "operator
invalid"; r(198) error message when the {cmd:by()} option variable had value
labels that contained a period.  This has been fixed.

{p 0 4}
{help xtgee} will now estimate models with options {cmd:binomial} and
{cmd:link(logit)} or {cmd:link(cloglog)} when the model contains a perfect
predictor for some of the observations.  Previously, {cmd:xtgee} would refuse
to estimate such models and report "Unable to identify sample".

{p 0 4}
{help xtgls} now estimates models if option {cmd:corr(ar1)} is specified and
the autocorrelation is indeterminate for one or more panels.  Prior to this
update {cmd:xtgls} refused to estimate such models.

{hline 5} {hi:update 12nov1999} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-52.

{hline 5} {hi:update 05nov1999} {hline}

{p 0 4}
{hi:whatsnew} (this file) improperly described the 4nov1999 update made to
{help table}.  The wording below is fixed.

{hline 5} {hi:update 04nov1999} {hline}

{p 0 4}
{help bsample} with the {cmd:cluster()} option did not produce a bootstrapped
sample if the data were not sorted by the cluster variable.  This is now
corrected.  The problem did not affect {help bs} or {help bstrap} because they
called {cmd:bsample} after sorting on the cluster variable.

{p 0 4}
{help egen}'s {cmd:count()} function now allows string as well as numeric
expressions.  In the case of {cmd:count(}{it:exp}{cmd:)} where {it:exp} is a
string, observations in which {it:exp} evaluates to "" are considered to be
missing.

{p 0 4}
{help ksm} with the {cmd:weight} option would incorrectly produce an "invalid
syntax" error message; this has been fixed.

{p 0 4}
{help separate} objected to the use of quotes in its {cmd:by()} option, such
as "{cmd:separate make, by(make=="Subaru")}".  This is fixed.

{p 0 4}
{help stset}:  the text of an informatory message was changed.

{p 0 4}
{help table} displayed strange (temporary) variable names in the heading if
five statistics were requested and the variables had long names.  Variable
names are now shortened (truncated) in the heading.

{p 0 4}
{help xtcorr} has new option {cmd:compact} that displays only the estimated
parameters (alpha) of the matrix of within-group correlations rather than the
entire matrix.

{hline 5} {hi:update 15oct1999} {hline}

{p 0 4}
{help kdensity} now correctly reports the number of observations used when the
number specified in {cmd:n()} is larger than the total sample size.  Also,
when specifying {cmd:at()} with tied values, {cmd:kdensity} now retains the
original order of the dataset.  Additionally, {cmd:kdensity} now runs faster.

{p 0 4}
{help qnorm} no longer produces an error when the {cmd:connect()} or
{cmd:symbol()} graph options are specified.

{p 0 4}
{help _rmdcoll} is a new programmer's command that identifies and removes
collinearity from variable lists.  See help {help _rmdcoll}.

{p 0 4}
{help svytab} with the {cmd:subpop()} and {cmd:obs} options now displays
subpopulation counts in each cell rather than the full population counts
previously displayed.

{hline 5} {hi:update 12oct1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 0 4}
Stata has had a long history (since Stata 1.0) of confusing expressions such
as e+3 with numbers such as 1e+3, leading to syntax errors and users avoiding
the name e for variables or scalars.  That has been fixed.

{p 0 4}
{help anova} with {help aweight}s now works.  The precision improvements made
to {cmd:anova} on 2aug1999 resulted in aweighted models being reported with
all zero coefficients and missing test statistics.  That has been fixed.

{p 0 4}
{help arima}, or rather, "{cmd:predict, dynamic()}" used after
"{cmd:arima, ar(1)}" now produces dynamic predictions.  Previously
"{cmd:predict, dynamic()}" after "{cmd:arima, ar(1)}" produced structural
predictions.  The problem existed only with pure AR(1) models --
"{cmd:predict, dynamic()}" used after "{cmd:arima, ar(1) ma(1)}", for
instance, always produced dynamic predictions.  Now all produce dynamic
predictions.

{p 0 4}
{help cnreg} now saves {hi:e(censored)} containing the censoring variable name
along with the other saved results.

{p 0 4}
{help estimates} {cmd:matrix} and {help return} {cmd:matrix} will no longer
create multiple matrices with the same name.  Instead, the previous matrix is
erased and the new matrix replaces it.  This problem only caused a waste of
memory.

{p 0 4}
{help infile} and {help infix} no longer issue an error message when the
{cmd:using()} option is specified and the (irrelevant) data file mentioned in
the dictionary (if any) does not exist.

{p 0 4}
{help insheet} will no longer allow creation of str81 variables.

{p 0 4}
{help ivreg} now produces more digits of precision when used with
ill-conditioned data.

{p 0 4}
{help macro} {cmd:drop} now allows multiple wildcard references such as
"{cmd:macro drop A* B*}".

{p 0 4}
{help table} now honors specified formats wider than 9 characters.

{p 0 4}
{help tobit} now saves {cmd:e(llopt)} and {cmd:e(ulopt)} -- the lower and
upper bounds -- along with the other saved results.


{p 0 4}
{hi:Stata executable}(*), Unix.

{p 0 4}
Stata for Unix is now 8-bit cleaner.  Stata now defaults to specifying -e
("stata -e") when loading the pipeline driver ({help pd}) automatically.  This
allows 8-bit streams to be sent to the terminal.

{hline 5} {hi:update 28sep1999} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-51.

{p 0 4}
{help joinby} has been made faster and some new options were added.  There
were no problems with the previous {cmd:joinby}.

{p 0 4}
{help qreg}, {help iqreg}, {help sqreg}, and {help bsqreg} sometimes reported
that a collinear variable was being dropped whereas in actuality another of
the collinear variables was dropped.  The reported variable dropped now always
agrees with the actual variable dropped.  In rare instances, this could lead
to a "conformability error" when using {cmd:bsqreg}; this no longer occurs.

{p 0 4}
{help pwcorr} stopped with an error message if a pair of variables had no
observations in common; now {cmd:pwcorr} reports missing value for the
correlation.

{p 0 4}
{help _rmcoll} is now documented on-line.  This is an advanced programming
command for use in writing estimation commands that are to run efficiently.

{p 0 4}
{help xttab} produced an inappropriate error message when run on zero
observations.

{hline 5} {hi:update 10sep1999} {hline}

{p 0 4}
{help cloglog} with {cmd:fweight}s reported incorrect number of zeros and
ones. The estimation results were correct. This has been fixed.

{p 0 4}
{help dotplot} now accepts a string variable in the {cmd:by()} option.

{p 0 4}
{help quadchk} now works correctly after {help xttobit}.  {cmd:xttobit} now
saves returned results {hi:e(ulopt)} and {hi:e(llopt)} for use by
{cmd:quadchk} but which other programs may now use.  {hi:e(ulopt)} and
{hi:e(llopt)} are the {cmd:ul()} and {cmd:ll()} options specified by the user.

{p 0 4}
{help recast} has a new {cmd:force} option that forces the change to be made
even if that change would cause a loss of precision, introduction of missing
values, etc.

{p 0 4}
{help reshape} now allows variable-name abbreviation for varlist and {cmd:j()}
option when changing data from long to wide form.

{p 0 4}
{help reg3} and {help sureg} with weights specified now save the weighting
expression in {cmd:e(wexp)} and the weight type in {cmd:e(wtype)}.

{p 0 4}
{help zinb} option {cmd:nbreg} has been replaced by option {cmd:vuong}.
{cmd:vuong} requests that a Vuong test of ZINB vs. negative binomial be done.

{p 0 4}
{help zip} option {cmd:poisson} has been replaced by option {cmd:vuong}.
{cmd:vuong} requests that a Vuong test of ZIP vs. Poisson be done.

{hline 5} {hi:update 30aug1999} {hline}

{p 0 4}
{help xi}, when producing interactions of variables taking on hundreds of
different values, could fail with the error message "syserr: length |5| not
right"; r(198).  This has been fixed.

{hline 5} {hi:update 27aug1999} {hline}

{p 0 4}
{help cchart} and {help pchart} now correctly plot and report the number of
units out of control if the lower control limit is zero or lower.

{p 0 4}
{help predict} after {help streg}, {cmd:dist(exponential)} and {cmd:streg},
{cmd:dist(weibull)} now calculates predicted time without including Euler's
constant.

{p 0 4}
{help predict} after {help streg}, {cmd:dist(gamma)} now produces correct
predicted time values when kappa is negative.  Also the way it calculates
hazard values has been made more numerically stable.

{p 0 4}
{help recode}, when used on a variable of storage type {help long} or
{help double}, and the variable contained lots of significant digits, could
incorrectly include in recode ranges values that should have been excluded.
This has been fixed.

{p 0 4}
{help sts} {cmd:generate} {it:newvar} {cmd:= s} now produces survival
probabilities equal to 1 rather than missing when there are no failures in the
data.

{p 0 4}
{help tsset} now returns values for the time unit (that is, periodicity) and
the time-series format.  {hi:r(unit)} contains {hi:daily}, {hi:weekly},
{hi:quarterly}, etc.  {hi:r(unit1)} contains {hi:d}, {hi:w}, {hi:q}, etc.
{hi:r(tsfmt)} contains the time-series format.

{hline 5} {hi:update 17aug1999} {hline}

{p 0 4}
{help codebook} now handles date variables more elegantly.  In addition, the
new option {cmd:notes} displays {help notes} associated with variables and the
new option {cmd:header} reports the dataset's name, etc., above the report on
the individual variables.  New option {cmd:all} is equivalent to specifying
both {cmd:header} and {cmd:notes}.

{p 0 4}
{help xi} now works properly with commands that use bound (parenthesized)
equation or variable lists (such as {help ivreg}) and with commands that take
equations or variable lists in options (such as {help heckman}).

{hline 5} {hi:update 16aug1999} {hline}

{p 0 4}
{help arima} with the {cmd:arima()} option specified as
{cmd:arima(}{it:k}{cmd:,0,0)} now estimates ARIMA
models with {it:k} AR terms and no MA terms; previously
{cmd:arima(}{it:k}{cmd:,0,0)} was incorrectly taken to mean {it:k} AR and
{it:k} MA terms.

{p 0 4}
{help egen}'s {cmd:robs()} function has a new {cmd:strok} option.  {cmd:strok}
allows string variables to be specified and they are counted as containing
missing when the string variables contain "".

{p 0 4}
{help streg}{cmd:, dist(exponential)} and {help ereg}, when the {cmd:robust}
option is specified, now label the chi-squared model test "Wald chi2".  They
previously incorrectly labeled the test "LR chi2".

{p 0 4}
{help svytab} can now tabulate variables whose variable labels contain quotes.

{hline 5} {hi:update 05aug1999} {hline}

{p 0 4}
{help lrecomp} is a new command for making tables of number of correctly
estimated digits (LREs) when comparing calculated results to
known-to-be-correct results.

{hline 5} {hi:update 02aug1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.

{p 4 4}
{help anova} now provides more digits of precision when used with
ill-conditioned data.

{p 4 4}
{help mlogit}, {help ologit}, and {help oprobit} now produce correct standard
errors when {cmd:pweight}s are specified with option {cmd:cluster()}.
Previously, absurdly large standard errors were reported.

{p 4 4}
{help net} now works with paths including "{cmd:..}" for all HTTP servers,
including Mac servers.  Previously, {cmd:net} relied on the server to
handle relative paths.

{p 4 4}
{help regress} now provides more digits of precision in R-squared near 1
regressions.

{p 4 4}
Typing "{cmd:save, replace}" now works when the remembered filename exceeds 64
characters.

{p 4 4}
The {cmd:subinstr} extended macro function with the option {cmd:word} now
correctly handles words at the beginning of a string when the first character
is doubled.

{p 4 4}
{help table} now handles spaces at the beginning and end of string variables
more elegantly.

{p 4 4}
{help tab2} now allows option {cmd:exact} to be abbreviated {cmd:e} as per the
documentation.


{p 0 4}
{hi:Stata for Windows executable}(*).

{p 4 4}
The do-file editor now includes {hi:.dct} files in the list of editable files.

{p 4 4}
The log window now remembers the printer font as well as the screen font
between sessions.

{p 4 4}
Copying and pasting into the data editor no longer creates a row of missing
values below the pasted data.

{p 4 4}
Stata now reports attempts to open log files in read-only directories.


{p 0 4}
{hi:Stata for Mac executable}(*).

{p 4 4}
Copying and pasting into the data editor no longer creates a row of missing
values below the pasted data.

{hline 5} {hi:update 29jul1999} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-50.

{p 0 4}
{help sts} {cmd:graph} now includes option {cmd:censored()} which allows
placing tick marks on the graph to indicate censorings.

{hline 5} {hi:update 23jul1999} {hline}

{p 0 4}
{help dprobit} added two matrices to saved results -- {hi:e(dfdx)} records the
vector marginal effects and {hi:e(se_dfdx)} records their standard errors.

{p 0 4}
{help cc} now suppresses the test for homogeneity when any of the estimated
odds ratios are zero or missing.

{p 0 4}
{help reshape}.  A message {cmd:reshape} sometimes displays has been reworded
to correct a typographical error.

{hline 5} {hi:update 13jul1999} {hline}

{p 0 4}
{help aorder} now handles multiple number fields within variable names.

{p 0 4}
{help centile} now correctly handles the case of no observations (it
previously went into an endless loop) and it correctly handles {cmd:if}
{it:exp} and {cmd:in} {it:range} when there are multiple variables.

{p 0 4}
{help cf} could become confused when different variables appeared in both
datasets and the name of one of the variables could be interpreted as an
abbreviation of the other.

{p 0 4}
{help dotplot} now recognizes labels for the y variable.

{p 0 4}
{help egen}'s {cmd:rmean()} and {cmd:rsum()} functions now allow one or more
variables rather than requiring at least two.

{p 0 4}
{help nl} has a new {cmd:delta(}{it:#}{cmd:)} option and a default value for
same that should improve the accuracy of coefficients and standard-error
estimates.

{p 0 4}
{help predict} after {help streg}{cmd:, dist(gamma)} produced incorrect hazard
values.  This also caused {help stcurv} to make incorrect plots.

{p 0 4}
{help heckman} with the {cmd:twostep} option sometimes reported the message
"matrix not symmetric".

{p 0 4}
{help ksmirnov}, after reporting an uncorrected P-value of zero, reported the
corrected P-value as zero rather than missing.

{p 0 4}
{help mhodds} now displays better headers when option {cmd:by()} is specified
with string variables.

{p 0 4}
{help streset} would fail if the {cmd:before} option was specified.

{p 0 4}
{help xtnbreg} now honors the {cmd:nolog} option.

{hline 5} {hi:update 28jun1999} {hline}

{p 0 4}
{help arima} sometimes produced unclear and misleading messages during
optimization.  Messages have been reworded.

{p 0 4}
{help cf}'s option {cmd:verbose} did nothing; it is fixed.

{p 0 4}
{help collapse} no longer retains the name of the original dataset and so
typing "{cmd:save, replace}" after {cmd:collapse} will not replace the
original, uncollapsed data.

{p 0 4}
{help compare} run on some files that contained string variables presented a
syntax error and stopped; that is fixed.

{p 0 4}
{help corrgram}, {help ac}, and {help pac} have been given minor improvements:
{cmd:corrgram} now stores results in {hi:r()}, {cmd:ac} is faster, and
{cmd:pac} handles errors better.

{p 0 4}
{help fracpoly}.  Setting the random-number seed did not re-create an analysis
when the {cmd:add} option was specified.

{p 0 4}
{help lsens}'s {cmd:replace} option did not work; it now does.

{p 0 4}
{help stsplit} and {help stjoin}.  {cmd:stsplit}'s way of recording time could
cause {cmd:stjoin}, in some cases, not to be able to rejoin all the records
possible.

{p 0 4}
{help svytab} with the {cmd:subpop()} option mistakenly printed the word
"dash" in its header; it no longer does.

{hline 5} {hi:update 22jun1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.{p_end}
{p 4 4}
HTTP proxy authorization has been added.

{p 4 4}
In processing numlists, Stata issued an error when numlists of the form
"{it:#}{cmd:(}{it:#}{cmd:)}{it:#}" or "{it:# #} {cmd:to} {it:#}" did not start
with an integer element.

{p 4 4}
The {help numlist} parsing command issued an out-of-range error when option
{cmd:range(<}{it:#}{cmd:)} was specified even when the list did not contain
out-of-range elements.

{p 4 4}
{help summarize} now saves {hi:r(sd)} = sqrt({hi:r(Var)}).

{p 4 4}
{help tabulate} truncated a character in the labels of one-way tabulations
when the labels were longer than 8 or 9 characters.


{p 0 4}
{hi:Stata for Windows executable}(*).{p_end}
{p 4 4}
{hi:--more--} conditions now work as expected with dialog boxes.

{p 4 4}
The do-file editor now clears the edited filename when a new instance is
started.  Thus, restarting the do-file editor and clicking the save button now
results in the do-file editor asking for the name under which the file is to
be saved.

{hline 5} {hi:update 31may1999} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-49.

{p 0 4}
{help cloglog} with the {cmd:noconstant} option sometimes dropped variables
when it should not have.  That has been fixed and this updated version also
converges more reliably.

{p 0 4}
{help lrtest} now handles models with no RHS variables.

{p 0 4}
{help ml} {cmd:graph} did not work when there were more than 10 iterations; it
now does.

{p 0 4}
{help xtgls} would, for some models, reset the {cmd:iis} and {cmd:tis}
variables so that they were interchanged.  This is fixed.

{hline 5} {hi:update 13may1999} {hline}

{p 0 4}
{help collapse} previously produced a {help float} result when working with
{help long} variables and now produces a {help double} result, thus
maintaining all possible precision.

{p 0 4}
{help heckprob} now works correctly for selection dependent variables that are
zero/not zero.  Previously, it required that the selection dependent variable
be 0/1.

{p 0 4}
{help reshape} mislabeled the heading of its report when reshaping from long
to wide.  It said "wide -> long" when it should have said "long -> wide".

{p 0 4}
{help stset}'s {cmd:exit(}{it:var}{cmd:=}{it:numlist}{cmd:)} option would not
work if {help numlist} contained more than one variable.

{hline 5} {hi:update 05may1999} {hline}

{p 0 4}
{help prais} issued an error message when used with more than 10 or 20
variables.  Now it is fixed.

{hline 5} {hi:update 27apr1999} {hline}

{p 0 4}
{help arima} and {help arch}.  To make the interpretation of dynamic
predictions more consistent for a wider range of models, the meaning of the
{cmd:dynamic()} option has changed.  Now, all references to the dependent
variable, say y, prior to the time period specified in {cmd:dynamic()}
evaluate to the observed (not predicted) value of y; all values of y on or
after {cmd:dynamic()} evaluate to the predicted value of y.

{p 0 4}
{help xi} would not work with time-series operators if the dataset was
{help tsset} as panel data.

{hline 5} {hi:update 26apr1999} {hline}

{p 0 4}
{help tabi} now works correctly with larger than 9 x k or k x 9 tables.

{hline 5} {hi:update 23apr1999} {hline}

{p 0 4}
{help grmeanby} did not work when weights were specified.

{p 0 4}
{help ivreg} would fail if the number of instruments exceeded about 450.

{p 0 4}
{help ltable} did not present the log-rank test if weights were specified.

{p 0 4}
{help pause} now runs in version-6 mode, meaning commands you type in debug
mode are interpreted according to the modern rules.

{p 0 4}
{help sttocc} did not necessarily reselect the same "random" sample when rerun
with the same random-number seed; it now does.  In addition, {cmd:sttocc}'s
{cmd:match()} option now allows a varlist rather than just a varname.

{p 0 4}
{help stmh} did not, under certain conditions, report results when option
{cmd:by()} was specified.

{p 0 4}
{help sts} now uses the value labels to label graphs when you have attached
value labels to the analytic time variable {hi:_t} (as unlikely as that may
be).

{hline 5} {hi:update 21apr1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.{p_end}
{p 4 4}
{cmd:cox} and {help stcox} now have a new {cmd:noadjust} option for use with
the {cmd:robust} option.  This option prevents the estimated variance matrix
from being multiplied by N/(N-1) or g/(g-1) (g the number of clusters).  Most
users will probably not wish to use this new option.

{p 4 4}
{help gettoken} and {help tokenize} now support long macros.

{p 4 4}
*.pkg files may now contain "{hi:f ../}etc." references to mean parent
directory.

{p 0 4}
{hi:Stata executable}(*), Unix.{p_end}
{p 4 4}
Some users saw $<#> in help files when text was supposed to be highlighted.
The text is now shown in highlighted form just as intended.

{hline 5} {hi:update 12apr1999} {hline}

{p 0 4}
On-line help and search index brought up to date for STB-48.

{hline 5} {hi:update 02apr1999} {hline}

{p 0 4}
{help adjust}.  The reported standard errors were incorrect when some
variables were left unspecified.  Results were correct when every variable in
the model was specified either in the varlist or in the {cmd:by()} option.

{p 0 4}
{help arima} and {help arch} could not estimate models if there were
insufficient contiguous observations for the starting value algorithm.  In
such cases, they now default to starting values of 0 for the ARMA and/or ARCH
parameters.

{p 0 4}
{help hausman} has new options {cmd:prior()} and {cmd:current()} to allow the
labels for the coefficient columns to be changed.

{p 0 4}
{help heckman}.  The counts of censored and uncensored observations were
reversed in the output.

{p 0 4}
{help heckprob}.  (1) The {cmd:noconstant} option was not honored in the
selection equation; it now is.  (2) When there were missing values among the
RHS variables of the primary equation for observations that were not selected,
these observations were incorrectly omitted from the estimation sample.  (3)
Better starting values are now used so models should converge more quickly.

{p 0 4}
{help integ} incorrectly required the user to specify the {cmd:generate()}
option.

{p 0 4}
{help istdize} would sometimes mistakenly issue the error message that the
number of cases exceeded the population size and so refused to run, even when
that was not true.

{p 0 4}
{help kdensity}'s {cmd:title()} option now understands {cmd:title(" ")} to
mean no title is to be displayed and the {cmd:title()} option will accept
compound double quotes.

{p 0 4}
{help quadchk} now works with {help xtintreg}.

{p 0 4}
{help scobit}'s model test is deleted because the ancillary parameter alpha
and the constant are not both identifiable in the constant-only model.
{cmd:scobit} now also converges more reliably.

{p 0 4}
{help xtgls}.  (1) {cmd:xtgls} now reports the correct log-likelihood.  (2)
Previously, if option {cmd:igls} was specified, {cmd:xtgls} reported
consistent, iterated results, but these were not the MLE; now MLE results are
produced.  (3) Previously, when {cmd:panel(correlated)} was specified without
option {cmd:igls}, the GLS matrix was based on a panel-heteroskedastic model.
It is now computed from OLS.  Both yield consistent results but the new
approach is more in line with what most people would expect.

{p 0 4}
{help xtnbreg}{cmd:, fe} now explicitly omits all observations that do not
contribute to the likelihood (for example, groups of size one).  {cmd:xtnbreg},
both {cmd:fe} and {cmd:re}, also now converges more reliably for difficult
problems.

{p 0 4}
{help xtpois}{cmd:, fe} now explicitly omits all observations that do not
contribute to the likelihood (for example, groups of size one).
{cmd:xtpois, re normal} now converges more reliably for the constant-only
model.

{hline 5} {hi:update 19mar1999} {hline}

{p 0 4}
{help snapspan} refused to transform the data and instead issued a syntax
error when there was more than one event variable in the dataset.

{p 0 4}
{help tabodds}.  When weights were used, the score test for trend reported by
{cmd:tabodds} was incorrect.  (All other statistics were fine.)  The problem
has been fixed.

{hline 5} {hi:update 15mar1999} {hline}

{p 0 4}
{help nbreg} has been enhanced to optionally estimate an alternative
parameterization of the negative binomial model.  Choosing the option
{cmd:dispersion(constant)} yields a model in which the overdispersion is
constant from observation to observation.  See help {help nbreg} for details.

{p 0 4}
{help stphplot} would sometimes connect the points in the resulting graph in
an odd order.

{p 0 4}
{help xtnbreg}{cmd:, fe} should have included a constant term, but it did not.
When weights were specified in the {cmd:re} and {cmd:fe} models, it would not
converge to the right answer; it now converges reliably.  The comparison model
for the {cmd:re} case is the new {cmd:nbreg, dispersion(constant)} alternative
parameterization.  The command is now much faster as well.

{p 0 4}
{help xtpois}{cmd:, re} (without weights) could sometimes have a problem
converging.  When weights were specified in the {cmd:re} and {cmd:fe} models,
it would not converge to the right answer.  It now converges reliably with and
without weights, and it is much faster as well.

{hline 5} {hi:update 04mar1999} {hline}

{p 0 4}
{help fracpoly}.  The way the {cmd:adjust()} option works has changed.

{p 0 4}
{help sw} now works with {help ologit} and {help oprobit}.

{p 0 4}
{hi:Stata executable}(*), all platforms.{p_end}
{p 4 4}
When version is set to 5, {help label} {cmd:save} now produces files
compatible with Stata 5.0.

{p 4 4}
{cmd:cox} and {help stcox} no longer allow specifying option {cmd:robust}
with {cmd:mexact} or {cmd:pexact} options.

{p 4 4}
{help ologit} and {help oprobit} now report the Wald model chi2 statistic if
option {cmd:offset()} is specified.

{p 4 4}
{help inspect} caused {help fracpoly} to crash under certain circumstances;
that is fixed.

{p 0 4}
{hi:Stata for Mac executable}(*).{p_end}
{p 4 4}
profile.do can now be located in a folder that contains spaces in its name.

{p 4 4}
The Log button is now synchronized with the command line.

{p 0 4}
{hi:Stata for Windows executable}(*).{p_end}
{p 4 4}
The Review window now maintains its size even when used with TrueType fonts.

{p 4 4}
profile.do can now be located in a folder that contains spaces in its name.

{p 4 4}
With some printers, the do-file editor would only print on a quarter of a
page.  It now prints on the whole page.

{hline 5} {hi:update 22feb1999} {hline}

{p 0 4}
{help cnsreg} was not saving the log-likelihood.

{p 0 4}
{help dstdize}'s {cmd:saving()} option now works and its {cmd:base()} option
now works with value labels.

{p 0 4}
{help heckman}'s {cmd:mills()} option did not work if an optional dependent
variable was specified simultaneously with the {cmd:select()} option.  In
addition, option {cmd:nshazard()} has been added as a synonym for
{cmd:mills()} because it more accurately describes what is calculated
(nshazard stands for nonselection hazard).

{p 0 4}
{help linktest} would not run if you set version prior to 6.

{p 0 4}
{help lrtest}.  The reported degrees-of-freedom for the test would be
incorrect if the estimator's option {cmd:constraints()} was used in the
estimation of either model and it was the constraint being tested.  (This
could only affect {help reg3} and {help mlogit}).

{p 0 4}
{help strate}'s {cmd:jackknife} option now works with {help pweight}s and
{help iweight}s.

{p 0 4}
{help svylc}{cmd:, show} did not work; it now does.

{hline 5} {hi:update 10feb1999} {hline}

{p 0 4}
{help areg}.  {cmd:predict} after {cmd:areg} did not take into account weights
if they were specified.

{p 0 4}
{help bs} has been improved so as to post a missing value when a statistic
cannot be calculated, or when the bootstrap sample causes the estimation
command to produce an error.

{p 0 4}
{help bs}, {help bstrap}, {help bsample} gave an error message when the
{cmd:cluster()} or {cmd:size()} options were specified.  These options now
work.

{p 0 4}
{help bstat} now handles missing values on a variable-by-variable basis.

{p 0 4}
{help fracpred}.  Typing {cmd:fracpred} {it:newvar}{cmd:, for(}{it:xvar}{cmd:)}
where {it:xvar} was not a predictor produced an incorrectly worded error
message.

{p 0 4}
{help streg}{cmd:, dist(gamma)} could produce the message "initial values
invalid", and then refuse to estimate the model, if {hi:_t} in the first
observation was missing.

{p 0 4}
{help svymean}, {help svytotal}, and {help svyratio} gave an error message
when they encountered value labels longer than 8 characters.

{p 0 4}
{help svymlog} gave an error message when it encountered value labels with
embedded quotes.

{p 0 4}
{help xi} could not be used with the version-5 (backward compatibility mode)
{help st} commands or other version-5 commands.

{hline 5} {hi:update 28jan1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.{p_end}
{p 4 4}
The {help outfile} command did not respect date formats.{p_end}
{p 4 4}
The {help sysdir} {cmd:set} command incorrectly handled trailing slashes.

{p 0 4}
{hi:Stata for Windows executable}(*).{p_end}
{p 4 4}
If an application such as
{net from "http://www.stata.com/quest":StataQuest}
changed the {hi:Help} menu, later the original menu bar could not be restored.

{hline 5} {hi:update 27jan1999} {hline}

{p 0 4}
{hi:Stata for Mac executable}(*).{p_end}
{p 4 4}
In some cases, Stata had difficulty finding its library that allows it to
communicate over the Internet.

{hline 5} {hi:update 19jan1999} {hline}

{p 0 4}
{hi:Stata executable}(*), all platforms.{p_end}
{p 4 4}
Expressions containing nested, compound double quotes (e.g, `"`"this"'"') in
which the quoted string itself contained +, -, *, /, would result in a syntax
error.

{p 0 4}
{hi:Stata for Windows executable}(*).{p_end}
{p 4 4}
File--Close did nothing under the do-file editor, although the Close button
did work.  In addition, double clicking on very long lines in the Review
window would cause the line to be truncated when executed.

{p 0 4}
{hi:Stata for Mac executable}(*).{p_end}
{p 4 4}
Long string variables (longer than 20 characters) could cause problems in the
data editor.

{hline 5} {hi:update 13jan1999} {hline}

{p 0 4}
{help gnbreg}.  The degrees of freedom for the likelihood ratio test of
alpha=0 (comparison with Poisson model) were set to one in all cases.  The
degrees of freedom should be the number of parameters in the {cmd:lnalpha}
equation.  This is fixed.

{p 0 4}
{help heckprob} did not honor {cmd:if} {it:exp} or {cmd:in} {it:range}.{p_end}

{hline}
