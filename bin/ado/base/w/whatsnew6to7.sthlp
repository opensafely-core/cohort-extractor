{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 7 (compared with release 6)}

{pstd}
This help file lists the changes corresponding to the creation of Stata
release 7:

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
    {c |} {bf:this file}        Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew7}.


{hline 3} {hi:Stata 7 release 15dec2000} {hline}

{p 4 4}The features added to Stata 7 are listed under the following headings.

{p 8 12}Changes you cannot help but notice{p_end}
{p 16 20}Long (32-character) names{p_end}
{p 16 20}New varlist abbreviation rules{p_end}
{p 16 20}Windowed Stata now across all platforms{p_end}
{p 16 20}Improved output, more clickability{p_end}
{p 16 20}Improvements to by{p_end}
{p 16 20}Sort stability{p_end}
{p 16 20}European decimal format{p_end}
{p 16 20}Faster{p_end}

{p 8 12}Statistics{p_end}
{p 16 20}Estimation commands (exclusive of st and xt){p_end}
{p 16 20}Cross-sectional time-series analysis (xt){p_end}
{p 16 20}Survival analysis (st){p_end}
{p 16 20}Commands for epidemiologists{p_end}
{p 16 20}Marginal effects{p_end}
{p 16 20}Cluster analysis{p_end}
{p 16 20}Pharmacokinetics{p_end}
{p 16 20}Other statistical commands{p_end}
{p 16 20}Distribution functions{p_end}

{p 8 12}Nonstatistical improvements{p_end}
{p 16 20}Graphics{p_end}
{p 16 20}New commands{p_end}
{p 16 20}New string functions{p_end}
{p 16 20}Other new functions{p_end}


{hline}

{title:Changes you cannot help but notice}

    {title:Long (32-character) names}

{p 4 4}
Stata now allows names to be up to 32 characters long.  That includes variable
names, label names, macro names, and any other name you can think of.  This
includes program names, and we have renamed a few existing Stata programs:

{center:Prior name    New name  }
{center:{hline 24}}
{center:{cmd:llogist}       {help llogistic} }
{center:{cmd:xthaus}        {help xthausman} }
{center:{cmd:spikeplt}      {help spikeplot} }
{center:{cmd:stcurv}        {help stcurve}   }
{center:{cmd:svyintrg}      {help svyintreg} }
{center:{cmd:svyprobt}      {help svyprobit} }
{center:{cmd:svymlog}       {help svymlogit} }
{center:{cmd:svyolog}       {help svyologit} }
{center:{cmd:svyoprob}      {help svyoprobit}}

{p 4 4}
The old names continue to work.

{p 4 4}
In any case, now you do not have to name your variable {hi:f_inc1999}, you can
name it {hi:farm_inc_1999} or {hi:farm_income_1999} or even
{hi:farm_income_in_fiscal_year_1999}.  Where possible, we have adjusted Stata
output to allow 12 spaces for displaying names.  When names are longer than
that, you will discover that Stata abbreviates and shows, for instance,
{hi:farm_in~1999}.  {hi:~} is the new Stata abbreviation character, which
Stata not only uses in output but which you can use in input (which is to say,
in varlists; see help {help varlist}).  If you type {hi:farm_in~1999},
{hi:f~1999}, or {hi:f~in~1999}, Stata will understand that you mean
{hi:farm_income_in_fiscal_year_1999}.  Thus, if in output Stata presents
{hi:dose~d1~42}, that name is unique and you can type it and Stata will
understand it.

{p 4 4}
{help describe} now has two new options, {cmd:fullname} and {cmd:numbers}.
{cmd:fullname} shows the full, 32-character names, instead of shorter
{hi:~}-abbreviations, and {cmd:numbers} shows the variable number.


    {title:New varlist abbreviation rules}

{p 4 4}
Varlists now understand {cmd:*} when used as other than a suffix.  You can
still type {hi:pop*}, but you can also type {hi:pop*99} or {hi:pop*30_40*1999}
or even {hi:*1999}.  {cmd:*} means "zero or more characters go here".  Also
understood is the new {cmd:~} abbreviation character mentioned above.  {cmd:*}
and {cmd:~} really mean the same thing and work the same way, except {cmd:~}
adds the claim "and only one variable matches this pattern", whereas {cmd:*}
means "give me all the variables that match this pattern".

{p 4 4}
The other new abbreviation character is {cmd:?}, which means "one character
goes here", so {hi:result?10} might match {hi:resultb10} and {hi:resultc10},
but would not match {hi:resultb110}.


    {title:Windowed Stata now across all platforms}

{p 4 4}
Stata for Unix users now have the same windowed interface that Stata for
Windows and Stata for Mac users have:  type {cmd:xstata} rather than
{cmd:stata} to start Stata.  Typing {cmd:stata} brings up the old line-by-line
console version of Stata.  Typing {cmd:xstata} brings up the new windowed
version.  The old console version is still useful in batch situations, but
Stata(console), as it is now called, can no longer render graphs.


    {title:Improved output, more clickability}

{p 4 4}
Stata's output looks better thanks to the new output language called SMCL,
which stands for Stata Markup and Control Language.  Moreover, all Stata
output, whether it be help files in the help window (now called the Viewer),
help files in the Results window, or statistical output, is SMCL, meaning all
features are available in all contexts.  One implication is that if something
is clickable, it is clickable regardless of the window in which it is
displayed, so you can start by typing {cmd:help} {cmd:anova} and click on
links just as you could had you pulled down {hi:Help} and gone about
displaying the help in the help window (Viewer).

{p 4 4}
Clickability is not limited to help files.  You can write programs that
display in their output clickable links.  The corresponding action can even be
the execution of another Stata command or program!

{p 4 4}
The help window is now called the Viewer because it serves more purposes than
solely displaying help files.  The Viewer, for instance, is where you look at
logs you have previously created or are creating.  That's because, by default,
Stata logs are now SMCL files and the default file extension for log files is
{hi:.smcl} to remind you of that.  When you type `{cmd:log using myfile}',
{hi:myfile.smcl} is created.  The file is ASCII, so you can look at it (and
even edit it) in your editor or word processor, but it is not a pretty sight.

{p 4 4}
Formatted, however, it is pretty.  The Viewer can print the SMCL logs Stata
now creates, and the new {cmd:translate} command can translate the SMCL file
to PostScript format, or even standard ASCII text format, so you can get back
to just where you were in Stata 6; see help {help translate}.  Moreover, you
can directly create old-style ASCII text logs if that is your preference; just
type `{cmd:log using myfile.log}' or `{cmd:log using myfile, text}'; see help
{help log}.

{p 4 4}
The Viewer can be accessed by pulling down {hi:File}, or you can use the new
{cmd:view} command, which provides some additional features; see help
{help view}.

{p 4 4}
Programmers will want to see help {help smcl} for a complete description of
SMCL.  You can use SMCL in your ado-files.

{p 4 4}
There is one other log change:  you can now create command logs (ASCII text
logs containing only what you type, which used to be called {cmd:noproc} logs)
using the new {cmd:cmdlog} command.  Even better, you can create command logs
and full session logs simultaneously; see help {help log}.

{p 4 4}
Stata(console) for Unix users:  All the above applies to you, too, except
that you cannot click.  Stata(console) does not have a {cmd:view} command, but
{cmd:type} can display {hi:.smcl} files, and {cmd:translate} can translate
them.  See help {help conren} for instructions on how to make SMCL output look
as good as possible on your line-by-line console.


    {title:Improvements to by}

{p 4 4}
{cmd:by} {it:varlist}{cmd::} now has a {cmd:sort} option.  You can type, for
instance, `{cmd:by foreign, sort: summarize mpg}' or, equivalently,
`{cmd:bysort foreign: summarize mpg}', rather than first sorting
the data and then typing the {cmd:by} command; see help {help by}.

{p 4 4}
{cmd:by} has a new parenthesis notation:
`{cmd:by} {it:id} {cmd:(}{it:time}{cmd:):} {it:...}' means to perform {it:...}
by {it:id}, but first verify that the data are sorted by {it:id} and
{it:time}.  `{cmd:by} {it:id} {cmd:(}{it:time}{cmd:), sort:} {it:...}' says to
sort the data by {it:id} and {it:time} and then perform {it:...} by {it:id}.

{p 4 4}
There is also a new {cmd:rc0} option, which says to keep on going even if one
of the by-groups results in an error.

{p 4 4}
More importantly, {cmd:by} {it:varlist}{cmd::} is now allowed with virtually
every Stata command, including commands implemented as ado-files, including
{cmd:egen}.  We have been claiming for some time that whether a command is
built-in or implemented as an ado-file is irrelevant, it has the same
features.  Now the claim is true.  Programmers:  see help {help byprog} for
instructions on how to make your programs and ado-files allow the {cmd:by}
prefix; it is easy.

{p 4 4}
The commands {cmd:generate}, {cmd:replace}, {cmd:drop}, {cmd:keep}, and
{cmd:assert} no longer present the detailed, group-by-group report when
prefixed with {cmd:by}, meaning you no longer need to prefix them with
{cmd:quietly}:

{p 8 12}{cmd:. by id:  replace bp = bp[_n-1] if bp==.}{p_end}
{p 8 12}{txt:(120 changes made)}


    {title:Sort stability}

{p 4 4}
Commands that report results of calculations (commands not intended to change
the data) no longer change the sort order of the data.  If you type
`{cmd:sort} {it:id} {it:time}', you can be assured that your dataset will stay
sorted by {it:id} and {it:time}. This is true even if the command is
implemented as an ado-file.

{p 4 4}
Programmers:  see {hi:[P] sortpreserve} for instructions on making your old
programs and ado-files sort stable.  It is easy, and the performance penalty
is barely measurable.


    {title:European decimal format}

{p 4 4}
Stata now understands output formats such as {cmd:%9,2f} as well as
{cmd:%9.2f}.  In {cmd:%9,2f}, the number 500.5 is displayed as 500,50.  In
{cmd:%9,2fc} format, the number 1,000.5 is displayed as 1.000,50.

{p 4 4}
Even better, you can now {cmd:set dp comma} to modify all of Stata's output to
use the European format, including all statistical output.  See help
{help format}.


    {title:Faster}

{p 4 4}
Stata 7 has more features, but continuing our long tradition, it is also
faster; ado-files execute between 8.8 and 11.8 percent faster.  Some programs,
we have observed, execute 13 percent faster.


{hline}

{title:Statistics}

    {title:Estimation commands (exclusive of st and xt)}

{p 4 4}
First, all maximum-likelihood estimation commands of Stata now allow linear
constraints; each has a new {cmd:constraint()} option.  See the particular
estimator.

{p 4 4}
{cmd:boxcox} has been rewritten.  It now produces maximum likelihood estimates
of the coefficients and the Box--Cox transform parameter(s).  Box--Cox models
may be estimated in various forms, with the transform on the left, on the
right, or on both sides.  See help {help boxcox}.

{p 4 4}
{cmd:glm} has also been rewritten.  It continues to estimate the generalized
linear model, but now offers an expanded choice of link functions and also
allows user-specified link and variance functions.  {cmd:glm} will now report
maximum-likelihood based estimates of standard errors, IRLS based estimates,
and many others.  See help {help glm}

{p 4 4}
{cmd:nlogit} estimates nested logit models.  In a nested logit model, multiple
outcomes are grouped into a nested tree structure, and nested logit has the
advantage over multinomial and conditional logistic models of allowing you to
parameterize away the assumption of independence of the irrelevant
alternatives (IIA).  See help {help nlogit}.

{p 4 4}
{cmd:treatreg} estimates the treatment effects model using either a two-step
estimator or a full maximum-likelihood estimator.  The treatment effects model
considers the effect of an endogenously chosen binary treatment on another
endogenous continuous variable, conditional on two sets of independent
variables.  See help {help treatreg}.

{p 4 4}
{cmd:truncreg} estimates truncated regression models.  Truncated regression
refers to regressions estimated on samples drawn based on the dependent
variable, and therefore for which (sometimes) neither the dependent nor
independent variables are observed (as opposed to {cmd:tobit}, which estimates
regression models when the independent variables are observed in all cases).
See help {help truncreg}.


    {title:Cross-sectional time-series analysis (xt)}

{p 4 4}
{cmd:xtabond} produces the Arellano--Bond one-step, one-step
    robust, and two-step estimators for dynamic panel-data models, models in
    which there are lagged dependent variables.  {cmd:xtabond} can be used
    with exogenously unbalanced panels and, uniquely, handles embedded gaps in
    the time series as well as opening and closing gaps.  {cmd:xtabond} allows
    for predetermined covariates.  {cmd:xtabond} allows you to use either the
    full instrument matrix or a pared down version.  {cmd:xtabond} reports
    both the Sargan and autocorrelation tests derived by Arellano and Bond.
    See help {help xtabond}.

{p 4 4}
{cmd:xtregar} estimates cross-sectional time-series models in which epsilon_it
is assumed to follow an AR(1) process.  {cmd:xtregar} reports the within
estimator and a GLS random-effects estimator.  {cmd:xtregar} can handle
unequally spaced observations and exogenously unbalanced panels.
{cmd:xtregar} uniquely reports the modified Bhargava et al. Durbin--Watson
statistic and the Baltagi--Wu locally best invariant test statistic for
autocorrelation.  See help {help xtregar}.

{p 4 4}
{cmd:xtivreg} estimates cross-sectional time-series regressions with
(generalized) instrumental variables, or, said differently, estimates
two-stage least squares time-series cross-sectional models.  {cmd:xtivreg} can
estimate such models using the between-2SLS estimator, the within-2SLS
estimator, the first-differenced 2SLS estimator, the
Balestra--Varadharajan--Krishnakumar G2SLS estimator, or the Baltagi EC2SLS
estimator.  All the estimators allow use of balanced or (exogenously)
unbalanced panels.  See help {help xtivreg}.

{p 4 4}
{cmd:xtpcse} produces panel-corrected standard errors (PCSE) for linear
cross-sectional time-series models where the parameters are estimated by OLS
or Prais--Winsten regression.  When computing the standard errors and the
variance--covariance estimates, the disturbances are, by default, assumed to
be heteroskedastic and contemporaneously correlated across panels.  See help
{help xtpcse}.


    {title:Survival analysis (st)}

{p 4 4}
{cmd:stcox} will now estimate proportional hazard models with continuously
time-varying covariates, and you do not need to modify your data to obtain the
estimates.  See the {cmd:tvc()} and {cmd:texp()} options in help {help stcox}.

{p 4 4}
{cmd:streg} can now estimate parametric survival models with individual-level
frailty (unobserved heterogeneity).  Two forms of the frailty distribution are
allowed:  gamma and inverse gaussian.  Frailty is allowed with all the
parametric distributions currently available.  See help {help streg}.  (New
commands {cmd:weibullhet}, {cmd:ereghet}, etc., allow users to estimate these
models outside of the st system; see help {help weibull}.)

{p 4 4}
{cmd:streg} has also been modified to allow estimation of stratified models,
meaning that the distributional parameters (the ancillary parameters and
intercept) are allowed to differ across strata.  See the {cmd:strata()} option
in help {help streg}.

{p 4 4}
{cmd:streg} has also been modified to allow you to specify any
linear-in-the-parameters equation for any of the distributional parameters,
which allows you to create various forms of stratification, as well as
allowing distributional parameters to be linear functions of other covariates.
See the {cmd:ancillary()} option in help {help streg}.

{p 4 4}
{cmd:stptime} calculates person-time (person-years) and incidence rates and
implements computation of the standardized mortality/morbidity ratios (SMR).
See help {help stptime}.

{p 4 4}
{cmd:sts test} has been modified to include additional tests for comparing
survivor distributions, including the Tarone--Ware test, the
Fleming--Harrington test, and the Peto--Peto--Prentice test.  Also new is a
test for trend.  See help {help sts}.

{p 4 4}
{cmd:stci} calculates and reports the level and confidence intervals of the
survivor function, as well as computing and reporting the mean survival time
and confidence interval.  See help {help stci}.

{p 4 4}
{cmd:stsplit} is now much faster and now allows for splitting on failure
times, as well as providing some additional convenience options.  See help
{help stsplit}, but remember that {cmd:stcox} can now estimate with continuous
time-varying covariates without you having to {cmd:stsplit} the data
beforehand.

{p 4 4}
{cmd:stcurve} has a new {cmd:outfile} option.  See help {help streg}.


    {title:Commands for epidemiologists}

{p 4 4}
Five new commands are provided for the analysis of Receiver Operating
Characteristic (ROC) curves.

{p 4 4}
{cmd:roctab} is used to perform nonparametric ROC analyses.  By default,
{cmd:roctab} calculates the area under the curve.  Optionally, {cmd:roctab}
can plot the ROC curve, display the data in tabular form, and produce
Lorenz-like plots.  See help {help roctab}.

{p 4 4}
{cmd:rocfit} estimates maximum-likelihood ROC models assuming a binormal
distribution of the latent variable.  {cmd:rocplot} may be used after
{cmd:rocfit} to plot the fitted ROC curve and simultaneous confidence bands.
See help {help rocfit}.

{p 4 4}
{cmd:roccomp} tests the equality of two or more ROC areas obtained from
applying two or more test modalities to the same sample or to independent
samples.  See help {help roccomp}.

{p 4 4}
{cmd:rocgold} independently tests the equality of the ROC area of each of
several test modalities against a "gold" standard ROC curve.  For each
comparison, {cmd:rocgold} reports the raw and the Bonferroni adjusted
significance probability.  Optionally, Sidak's adjustment for multiple
comparisons can be obtained.  See help {help rocgold}

{p 4 4}
{cmd:binreg} estimates generalized linear models for the binomial family and
various links.  It may be used with either individual-level or grouped data.
Each of the link functions offers a distinct, epidemiological interpretation
of the estimated parameters.  See help {help binreg}.

{p 4 4}
{cmd:cc} and {cmd:cci} now, by default, compute exact confidence intervals
    for the odds ratio.  See help {help cc}.

{p 4 4}
{cmd:icd9} and {cmd:icd9p} assist when you are working with ICD-9-CM
diagnostic and procedure codes.  These commands allow the cleaning up,
verification, labeling, and selection of ICD-9 values.  See help {help icd9}.


    {title:Marginal effects}

{p 4 4}
{cmd:mfx} reports marginal effects after estimation of any model.  Marginal
effects refers to df()/dx_i evaluated at x, where f() is any function of the
data and the model's estimated parameters, x are the model's covariates, and
x_i is one of the covariates.  For instance, the model might be probit and f()
the cumulative normal distribution, in which case df()/dx_i = the change in
the probability of a positive outcome with respect to a change in one of the
covariates.  x might be specified as the mean, so that the change would be
evaluated at the mean.

{p 4 4}
{cmd:dprobit} would already do that for the probit model, and there have been
other commands published in the STB that would do this for other particular
models, such as {cmd:dtobit} for performing tobit estimation.

{p 4 4}
{cmd:mfx} works after estimation of any model in Stata and is capable of
producing marginal effects for anything {cmd:predict} can produce.  For
instance, after {cmd:tobit}, you could get the marginal effect of the
probability of an outcome being uncensored, or the expected value of the
uncensored outcome, or the expected value of the censored outcome.

{p 4 4}
{cmd:mfx} can compute results as derivatives or elasticities.  See help
{help mfx}


    {title:Cluster analysis}

{p 4 4}
{cmd:cluster} performs partitioning and hierarchical cluster analysis using a
variety of methods.  Two partitioning cluster methods are provided -- kmeans
and kmedians -- and three hierarchical-cluster methods are provided -- single
linkage, average linkage, and complete linkage.  Included are 14 binary
similarity measures and 7 different continuous measures (counting things such
as the Minkowski distance {it:#} as one).

{p 4 4}
The result is to add various characteristics to the dataset, including
variables reflecting cluster membership.  {cmd:cluster} can then can display
results in various ways.

{p 4 4}
More than one result can be saved simultaneously, so that the results of
different analyses may be compared.  {cmd:cluster} allows adding notes to
analyses and, of course, the dropping of analyses.  {cmd:cluster} also
provides post-clustering commands that can, for instance, display the
dendrogram (clustering tree) from a hierarchical analysis or produce new
grouping variables based on the analysis.

{p 4 4}
{cmd:cluster} has been designed to be extended.  Users may program extensions
for new cluster methods, new cluster management routines, and new
post-analysis summary methods.

{p 4 4}
See help {help cluster} and, if you are interested in programming extensions,
see help {help clprog}.


    {title:Pharmacokinetics}

{p 4 4}
There are four new estimation commands and two new utilities intended for the
analysis of pharmacokinetic data; see help {help pk}.

{p 4 4}
{cmd:pkexamine} calculates pharmacokinetic measures from
time-and-concentration subject-level data. {cmd:pkexamine} computes and
displays the maximum measured concentration, the time at the maximum measured
concentration, the time of the last measurement, the elimination rate, the
half-life, and the area under the concentration-time curve (AUC).  See help
{help pkexamine}.

{p 4 4}
{cmd:pksumm} obtains the first four moments from the empirical distribution of
each pharmacokinetic measurement and tests the null hypothesis that the
measurement is normally distributed.  See help {help pksumm}.

{p 4 4}
{cmd:pkcross} analyzes data from a crossover design experiment.  When
analyzing pharmaceutical trial data, if the treatment, carryover, and sequence
variables are known, the omnibus test for separability of the treatment and
carryover effects is calculated.  See help {help pkcross}.

{p 4 4}
{cmd:pkequiv} performs bioequivalence testing for two treatments.  By default,
{cmd:pkequiv} calculates a standard confidence interval symmetric about the
difference between the two treatment means.  Optionally, {cmd:pkequiv}
calculates confidence intervals symmetric about zero and intervals based on
Fieller's theorem.  Additionally, {cmd:pkequiv} can perform interval
hypothesis tests for bioequivalence.  See help {help pkequiv}.

{p 4 4}
{cmd:pkshape} and {cmd:pkcollapse} help in reshaping the data into the form
that the above commands need; see help {help pkshape} and {help pkcollapse}.


    {title:Other statistical commands}

{p 4 4}
{cmd:jknife} performs jackknife estimation, which is (1) an alternative,
first-order unbiased estimator for a statistic; (2) a data-dependent way to
calculate the standard error of the statistic and to obtain significance
levels and confidence intervals; and (3) a way of producing measures
reflecting the observation's influence on the overall statistic.  See help
{help jknife}.

{p 4 4}
{cmd:lfit}, {cmd:lroc}, {cmd:lsens}, and {cmd:lstat} now work after
{cmd:probit} just as they do after {cmd:logit} or {cmd:logistic}.

{p 4 4}
{cmd:drawnorm} draws random samples from a multivariate normal distribution
with specified means and covariance matrix.  See help {help drawnorm}.

{p 4 4}
{cmd:corr2data} creates fictional datasets with the specified means and
covariance matrix (correlation structure).  Thus, you can take published
results and duplicate and modify them if the estimator is solely a function of
the first two moments of the data, such as {cmd:regress}, {cmd:ivreg},
{cmd:anova}, or {cmd:factor}.  See help {help corr2data}.

{p 4 4}
{cmd:median} performs a nonparametric test that K samples were drawn from
populations with the same median.  See help {help median}.

{p 4 4}
{cmd:tabstat} displays tables of summary statistics, possibly broken down
(conditioned) on another variable.  See help {help tabstat}.

{p 4 4}
The command {cmd:avplot} now works after estimation using the {cmd:robust} or
{cmd:cluster()} options.  See help {help avplot}.

{p 4 4}
{cmd:ml} can now perform estimation with linear constraints.  All that is
required is that you specify the {cmd:constraint()} option on the {cmd:ml}
{cmd:maximize} command.  See help {help ml}.


    {title:Distribution functions}

{p 4 4}
Stata's density and distribution functions have been renamed.  First, all the
old names continue to work, even when not documented in the manual, at least
under version control.  The new standard, however, is, if {it:X} is the name
of a distribution, then

{p 8 26}{it:X}{cmd:den()}{space 8}is its density{p_end}
{p 8 26}{it:X}{cmd:()}{space 11}is its cumulative distribution{p_end}
{p 8 26}{cmd:inv}{it:X}{cmd:()}{space 8}is its inverse cumulative{p_end}
{p 8 26}{it:X}{cmd:tail()}{space 7}is its reverse cumulative{p_end}
{p 8 26}{cmd:inv}{it:X}{cmd:tail()}{space 4}is its inverse reverse
	cumulative{p_end}

{p 4 4}
Not all functions necessarily exist and, if they do not, that is not solely
due to laziness on our part.  In particular, concerning the choice between
{it:X}{cmd:()} and {it:X}{cmd:tail()}, the functions exist that we have
accurately implemented.  In theory, you only need one because
{bind:{it:X}{cmd:tail()} = 1 - {it:X}{cmd:()}}, but in practice, the one-minus
subtraction wipes out lots of accuracy.  If one really wants an accurate
right-tail or left-tail probability, one needs a separately written
{it:X}{cmd:tail()} or {it:X}{cmd:()} routine, written from the ground up.

{p 4 4}
Anyway, forget everything you ever knew about Stata's distribution functions.
Here is the new set:

{p 8 31}{cmd:normden()}{space 8}same as old {cmd:normd()}{p_end}
{p 8 31}{cmd:norm()}{space 11}same as old {cmd:normprob()}{p_end}
{p 8 31}{cmd:invnorm()}{space 8}same as old {cmd:invnorm()}{p_end}

{p 8 31}{cmd:chi2()}{space 11}related to old {cmd:chiprob()}; see below{p_end}
{p 8 31}{cmd:invchi2()}{space 8}related to old {cmd:invchi()}; see below{p_end}
{p 8 31}{cmd:chi2tail()}{space 7}related to old {cmd:chiprob()}{p_end}
{p 8 31}{cmd:invchi2tail()}{space 4}related to old {cmd:invchi()}{p_end}

{p 8 31}{cmd:F()}{space 14}related to old {cmd:fprob()}{p_end}
{p 8 31}{cmd:invF()}{space 11}related to old {cmd:invfprob()}{p_end}
{p 8 31}{cmd:Ftail()}{space 10}same as old {cmd:fprob()}{p_end}
{p 8 31}{cmd:invFtail()}{space 7}equal to old {cmd:invfprob()}{p_end}

{p 8 31}{cmd:ttail()}{space 10}related to old {cmd:tprob()}; see below{p_end}
{p 8 31}{cmd:invttail()}{space 7}related to old {cmd:invt()}; see below{p_end}

{p 8 31}{cmd:nchi2()}{space 10}equal to old {cmd:nchi()}{p_end}
{p 8 31}{cmd:invnchi2()}{space 7}equal to old {cmd:invnchi()}{p_end}
{p 8 31}{cmd:npnchi2()}{space 8}equal to old {cmd:npnchi()}{p_end}

{p 4 4}
We want to emphasize that if a function exists, it is calculated accurately.
To wit, {cmd:F()} accurately calculates left tails, and {cmd:Ftail()}
accurately calculates right tails; {cmd:Ftail()} is far more accurate than
{bind:1 - {cmd:F()}}.

{p 4 4}
There is no {cmd:normtail()} function.  The accurate way to calculate
left-tail probabilities (z<0) is {cmd:norm(z)}.  The accurate way to calculate
right-tail probabilities (z>0) is {cmd:norm(-z)}.

{p 4 4}
All the old functions still exist, but in two cases, they work only under
version control:  The old {cmd:invt()}, under the new naming logic, ought to
be the inverse of the cumulative, but is not, so {cmd:invt()} goes into forced
retirement for a release or two.  It works if {cmd:version} is set to 6 or
before; otherwise, you get the error "unknown function invt()".  Similarly,
the old {cmd:invchi()} goes into forced retirement because it is too close to
the new name {cmd:invchi2()}.


{hline}

{title:Nonstatistical improvements}

    {title:Graphics}

{p 4 4}
Stata's {cmd:graph} command now allows line styles.  Whereas before you might
have specified {cmd:c(lls)} on the {cmd:graph} command to indicate the first
variable was to be connected by lines, the second variable was to be
connected by lines, and the third variable was to be connected by a cubic
spline, you can now specify things like {cmd:c(l l[-] s[-.])} to indicate
the same thing and to also specify the style of the lines used to show the
result.  The first is to be shown by a solid line, the second by a dashed
line, and the third by a line in a dash-dot-dash-dot pattern.

{p 4 4}
You can still specify the old style, or mix old and new style.  In the square
brackets you can type a pattern which is made up of the following pieces:

{p 16 21}{cmd:l}{space 4}(el) solid line (default){p_end}
{p 16 21}{cmd:_}{space 4}(underscore) a long dash{p_end}
{p 16 21}{cmd:-}{space 4}(hyphen) a medium dash{p_end}
{p 16 21}{cmd:.}{space 4}(period) a short dash (almost a dot){p_end}
{p 16 21}{cmd:#}{space 4}(pound sign) a space

{p 4 4}
The pattern you specify repeats.

{p 4 4}
The keys at the top of graphics have been improved -- they now show the line
style as well as the point, and you can now exercise control over the keys
with the new {cmd:key1()}, {cmd:key2()}, {cmd:key3()}, and {cmd:key4()}
options.  The {cmd:key}{it:#}{cmd:()} options allow you to specify the text,
the symbol, the line style, and the color, in any combination.
{cmd:key1(c(l[.-]) s(x) p(2) "Explanatory text")} creates a key displaying
a dot-dash-dot-dash line pattern, symbol small x ({cmd:symbol(x)} is new), in
the color of pen 2, with the text "Explanatory text".

{p 4 4}
You can now specify {cmd:xsize(}{it:#}{cmd:)} and {cmd:ysize(}{it:#}{cmd:)}
options on {cmd:graph} (and with the programming command {cmd:gph open}).
These specify the size of the graph, in inches, and take effect when you print
the graph.  The default is {cmd:xsize(6)} and {cmd:ysize(4)}.

{p 4 4}
Printing is now a little different.  Because Stata 7 now includes a windowed
interface for all operating systems, Unix included, you can pull down
{hi:File} and choose {hi:Print Graph}.  You can also use the new {cmd:print}
command; see help {help print}.  The {cmd:translate} command can translate
from .gph format to other file formats.

{p 4 4}
Compared to previous versions, this means the Unix stand-alone executables
gphdot and gphpen are now gone; you do not need them.  {cmd:print} is better.
This also means the old {cmd:gphprint} command of Stata, available under
Windows and Mac only, is also supplanted for printing by {cmd:print}
and for file translation by {cmd:translate}.

{p 4 4}
The .gph file format has changed, meaning Stata 6 cannot display or print
Stata 7 .gph files (but Stata 7 can display and print Stata 6 files).  The
old Stage editor cannot edit Stata 7 graphs.

{p 4 4}
The line-by-line console version of Stata for Unix can no longer display
graphs, although the {cmd:graph} command works in the sense that you can
graph into a file and print the results.  To see graphs on the screen, you
must use the windowed version of Stata.

{p 4 4}
The programmer's command {cmd:gph} continues unmodified, but programmers are
alerted that Stata 7 has a new programmable bottom-layer graphics engine.
You may wish to code your graphics programs using this new feature and, if
so, point your browser at

{center:{browse "http://developer.stata.com/graphics"}}

{p 4 4}
Documentation for the new developmental system resides there.

{p 4 4}
Note: Your copy of Stata may have new graphic features not listed here.  New
features might be added when you type {cmd:update} to obtain and install the
latest updates from www.stata.com.  To find out about any new graphics
features see help {help whatsnew}.  Help {help whatsnew}
gives a complete list of all new features, graphics and otherwise, provided
by your current update.  Help {help graphics} will document new end-user
graphics features that are added through the life of Version 7.


    {title:New commands}

{p 4 4}
{cmd:foreach} is a new programming command, but it can be used directly and is
a useful alternative to {cmd:for} and {cmd:while}.  With {cmd:foreach}, you
can type things such as


	{cmd:. foreach file in this.dta that.dta theother.dta {c -(}}
	  {cmd:2. use `file', clear}
	  {cmd:3. replace bp=. if bp==999}
	  {cmd:4. save `file', replace}
	  {cmd:5. {c )-}}

{p 4 4}
See help {help foreach}.

{p 4 4}
Likewise, the new {cmd:forvalues} programming command is a useful alternative
to {cmd:for} and {cmd:while} that steps through numeric values.  Instead of
coding

	{cmd:. local i = 1}
	{cmd:. while `i' <= `n' {c -(}}
	  {cmd:2.} {it:...} {cmd:`i'} {it:...}
	  {cmd:3. local i = `i' + 1}
	  {cmd:4. {c )-}}

{p 4 4}
you code

	{cmd:. forvalues i = 1(1)`n' {c -(}}
	  {cmd:2.} {it:...} {cmd:`i'} {it:...}
	  {cmd:3. {c )-}}

{p 4 4}
See help {help forvalues}.

{p 4 4}
{cmd:continue} (and {cmd:continue, break}) allow you to continue out of, or
break out of, {cmd:while}, {cmd:forvalues}, and {cmd:foreach} loops; see
help {help continue}.

{p 4 4}
{cmd:net} {cmd:search} searches the web for user-written additions to Stata,
including, but not limited to, user-written additions published in the STB.
The user-written materials found are available for immediate download and
automatic installation by clicking on the link.  {cmd:net} {cmd:search} is the
latest incarnation of {cmd:webseek}, a command not included in Stata 6 but
which was made available during the release, and which continues to work but
is now undocumented.  See help {help net}.

{p 4 4}
{cmd:destring} makes converting variables from string to numeric easier.  See
help {help destring}.

{p 4 4}
The following new {cmd:egen} functions have been added:  {cmd:any()},
{cmd:concat()}, {cmd:cut()}, {cmd:eqany()}, {cmd:ends()}, {cmd:kurt()},
{cmd:mad()}, {cmd:mdev()}, {cmd:mode()}, {cmd:neqany()}, {cmd:pc()},
{cmd:seq()}, {cmd:skew()}, and {cmd:tag()}.  In addition, {cmd:group()} and
{cmd:rank()} have new options.  See help {help egen}.

{p 4 4}
{cmd:statsby} creates a dataset of the results of a command executed
{cmd:by} {it:varlist}{cmd::}.  The results can be any of the saved results of
the specified command and, if it is an estimation command, the coefficients
and the standard errors.  Typing
`{cmd:statsby "regress mpg weight" _b _se e(r2), by(foreign)}', for instance,
would create a two-observation dataset in which the first recorded the
coefficients, standard error, and R^2 for foreign = 0, and the second recorded
them for foreign = 1.  See help {help statsby}.

{p 4 4}
{cmd:xi} has been modified to exploit Stata's longer variable names to create
more readable names for the interaction terms.  See help {help xi}.

{p 4 4}
{cmd:hexdump} will give you a hexadecimal dump of a file.  Even more useful is
its {cmd:analyze} option, which will analyze the dump for you and report just
the summary.  This can be useful for diagnosing problems with raw datasets.
See help {help hexdump}.

{p 4 4}
{cmd:type} has a new {cmd:asis} option.  The default behavior of {cmd:type}
has been changed when the filename ends in {hi:.smcl} to interpret the SMCL
codes.  This way, if you previously created a session log by typing
`{cmd:log using mylog}', you can type `{cmd:type mylog.smcl}' to display it as
you probably want to see it.  If you wanted to see the raw SMCL codes,
you would type `{cmd:type mylog.smcl, asis}'.  See help {help type}.

{p 4 4}
{cmd:net} {hi:stata.toc} and {hi:*.pkg} files now allow the {cmd:v} directive.
You are supposed to code `{cmd:v 2}' at the top of the files and, if you do
that, you may use SMCL directives in the files; see help {help net} and
{help smcl}.

{p 4 4}
{cmd:format} now allows you to type the {cmd:%}{it:fmt} first or last, so you
can equally well type `{cmd:format mpg weight %9.2f}' or
`{cmd:format %9.2f mpg weight}'.  See help {help format}.

{p 4 4}
{cmd:version} may now be used as a prefix command; you can type
`{cmd:version 6: }{it:...}' to mean that {it:...} is to be run under version 6.
See help {help version}.

{p 4 4}
There are now three {cmd:shell}-like commands, depending on your operating
system:  {cmd:shell}, {cmd:xshell}, and {cmd:winexec}.  Stata for Window's
users: nothing has changed.  Stata for Mac users:  nothing has changed.
Stata(console) for Unix users:  nothing has changed.  Stata(GUI) for Unix,
however, is more complicated, and it all has to do with whether you want a new
{hi:xterm} window created for the application.  See help {help shell}.

{p 4 4}
Numlists may now be specified as {it:a}{cmd:[}{it:b}{cmd:]}{cmd:c} as well as
{it:a}{cmd:(}{it:b}{cmd:)}{it:c}.  See help {help numlist}.

{p 4 4}
{cmd:list} now has a {cmd:doublespace} option.  See help {help list}.

{p 4 4}
{cmd:confirm} {cmd:names} verifies that what follows, follows Stata's naming
syntax -- which is to say, starts with a letter or underscore and thereafter
contains letters, underscores, or digits -- and is not too long.

{p 4 4}
{cmd:estimates} {cmd:hold} has two new options and one new behavior that will
be of interest to programmers.  The new behavior is that if estimates are
held under a temporary name, they are now automatically discarded when the
program terminates.  The new {cmd:restore} option schedules the held estimates
for automatic restoration on program termination.  The new {cmd:not} option
to {cmd:estimates} {cmd:unhold} cancels the previously scheduled restoration.
The new {cmd:copy} option to {cmd:estimates} {cmd:hold} copies the current
estimates rather than moving them.  See help {help estimates}.

{p 4 4}
{cmd:_rmcoll} and {cmd:_rmdcoll} assist in removing collinear variables from
varlists; see help {help _rmcoll} and {help _rmdcoll}.


    {title:New string functions}

{p 4 4}
There are four new string functions: {cmd:match()}, {cmd:subinstr()},
{cmd:subinword()}, and {cmd:reverse()}.

{p 4 4}
{cmd:match(}{it:s_1}{cmd:,}{it:s_2}{cmd:)} returns 1 if string {it:s_1}
"matches" {it:s_2}.  In the match, {cmd:*} in {it:s_2} is understood to mean
zero or more characters go here, and {cmd:?} is understood to mean one
character goes here.  {cmd:match("this","*hi*")} is true.  In {it:s_2},
{cmd:\\}, {cmd:\?}, and {cmd:\*} can be used if you really want a {cmd:\},
{cmd:?}, or {cmd:*} character.

{p 4 4}
{cmd:subinstr(}{it:s_1}{cmd:,}{it:s_2}{cmd:,}{it:s_3}{cmd:,}{it:n}{cmd:)} and
{cmd:subinword(}{it:s_1}{cmd:,}{it:s_2}{cmd:,}{it:s_3}{cmd:,}{it:n}{cmd:)}
substitute the first {it:n} occurrences of {it:s_2} in {it:s_1} with {it:s_3}.
{cmd:subinword()} restricts "occurrences" to be occurrences of words.  In
either, {it:n} may be coded as missing value, meaning to substitute all
occurrences.  For instance, {cmd:subinword("measure me","me","you",.)} returns
"measure you", and {cmd:subinstr("measure me","me","you",.)} returns "youasure
you".

{p 4 4}
{cmd:reverse(}{it:s}{cmd:)} returns {it:s} turned around.
{cmd:reverse("string")} returns "gnirts".

{p 4 4}
A fifth new string function is really intended for programmers:
{cmd:abbrev(}{it:s}{cmd:,}{it:n}{cmd:)} returns the {it:n}-character
{cmd:~}-abbreviation of the variable name {it:s}.
{cmd:abbrev(}{it:s}{cmd:,12)} is the function used throughout Stata to make
32-character names fit into 12 spaces.

{p 4 4}
See help {help functions}.


    {title:Other new functions}

{p 4 4}
The new functions {cmd:inrange()} and {cmd:inlist()} make choosing the right
observations easier.

{p 4 4}
{cmd:inrange()} handles missing values elegantly when selecting subsamples
such as {bind:{it:a} <= {it:x} <= {it:b}}.
{cmd:inrange(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:)} answers the question,
"Is {it:x} known to be in the range {it:a} to {it:b}?" Obviously,
{cmd:inrange(.,1000,2000)} is false.  {it:a} or {it:b} may be missing.
{cmd:inrange(}{it:x}{cmd:,}{it:a}{cmd:,.)} answers whether it is known that
{bind:{it:x} >= {it:a}}, and {cmd:inrange(}{it:x}{cmd:,.,}{it:b}{cmd:)} answers
whether it is known that {bind:{it:x} <= {it:b}}.  {cmd:inrange(.,.,.)}
returns 0 which, if you think about it, is inconsistent but is probably what
you want.

{p 4 4}
{cmd:inlist(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:,}{it:...}{cmd:)} selects
observations if {bind:{it:x} = {it:a}} or {bind:{it:x} = {it:b}} or {it: ...}.

{p 4 4}
See help {help functions} for more information on the above functions.  Other
functions have been added.  {cmd:_by()}, {cmd:_bylastcall()}, and
{cmd:_byindex()} deal with making programs and ado-files allow the
{cmd:by} {it:varlist}{cmd::} prefix; see help {help byprog}.

{p 4 4}
The new macro extended function:
{c -(}{cmd:r}|{cmd:e}|{cmd:s}{c )-}{cmd:(}{c -(}{cmd:scalars}|{cmd:macros}|{cmd:matrices}|{cmd:functions}{c )-}{cmd:)}
returns the names of all the saved results of the indicated type.  For
instance, {cmd:local x : e(scalars)} returns the names of all the scalars
currently stored in {cmd:e()}.  See help {help macro}.


{hline 3} {hi:previous updates} {hline}

{pstd}
See {help whatsnew6}.{p_end}

{hline}
