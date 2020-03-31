{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 8.0 (compared with release 7)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 8.0:

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
    {c |} {bf:this file}        Stata  8.0 new release       2003            {c |}
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew8}.


{hline 3} {hi:Stata 8.0 release 02jan2003} {hline}

{p 4 4 2}
As always, Stata 8.0 is 100% compatible with the previous release of Stata,
but as always we remind programmers that it is vitally important that you put
{cmd:version 7.0} at the top of your old do-files and ado-files if they are
to work; see help {help version}. You were supposed to do that when you wrote
them but, if you did not, go back and do it now. We have made a lot of changes
(improvements) to Stata.

{p 4 4 2}
In addition, Stata's dataset format has changed because of the new longer data
storage types and the fact that Stata now has multiple representations for
missing values. You will not care because Stata automatically reads old-format
datasets, but if you need to send a dataset to someone still using Stata 7,
remember to use the {cmd:saveold} command; see help {help saveold}.

{p 4 4 2}
The features added to Stata 8.0 are listed under the following headings.

	    {bf:What's big}
		{bf:Graphics}
		{bf:GUI}
	    {bf:What's useful}
	    {bf:What's convenient}
	    {bf:What was needed}
	    {bf:What's faster}
	    {bf:What's new in time-series analysis}
	    {bf:What's new in cross-sectional time-series analysis}
	    {bf:What's new in survival analysis}
	    {bf:What's new in survey analysis}
	    {bf:What's new in cluster analysis}
	    {bf:What's new in statistics useful in all fields}
	    {bf:What's new in data management}
	    {bf:What's new in expressions and functions}
	    {bf:What's new in display formats}
	    {bf:What's new in programming}
	    {bf:What's new in the user interface}
	    {bf:What's more}


{title:What's big}

{p 4 4 2}
The big news is the new GUI and the new Graphics.  There is no putting them in
an order.


    {title:Graphics}

{p 4 4 2}
You can create graphs that look like this

{p 12 12 2}
({stata gr_example2 line3:click to run})

{p 4 4 2}
or this

{p 12 12 2}
({stata "gr_example auto: twoway (qfitci mpg weight, stdf) (scatter mpg weight), by(foreign)":click to run})

{p 4 4 2}
See {hi:A quick tour} in help {help graph_intro}.  Everything you need to know
is online.

{p 4 4 2}
So what's new in Stata graphics?  Everything.  There is not one little bit
that is not new, even if it seems familiar.

{p 4 4 2}
Before you panic, let us tell you that all the old graphics are still
in Stata.  If you type

	{cmd:. graph7} ...

{p 4 4 2}
or

	{cmd:. gr7} ...

{p 4 4 2}
you will be back to using the old {cmd:graph} command; see help {help graph7}.
Moreover, the old {cmd:graph} command is still invoked under version control;
see help {help version}.  If you set your version to 7.0 or earlier,
{cmd:graph} does not mean what is defined in help {help graph}; it means what
it used to mean, which means that old do-files and ado-files continue to work.

{p 4 4 2}
One new feature requires some adjustment.  What used to be called symbols are
now called markers, and marker symbols are the shapes of the markers.  Thus,
you no longer specify the {cmd:symbol()} or {cmd:s()} option, you specify the
{cmd:msymbol()} or {cmd:ms()} option.  In addition, the old {cmd:s(.)} for
specifying the dot symbol is now {cmd:ms(p)} ({cmd:p} stands for point).
{cmd:ms(.)} means to use the default.

{p 4 4 2}
All existing statistical commands that produce graphs have been updated
to take advance of the new graphics.


    {title:GUI}

{p 4 4 2}
GUI stands for Graphical User Interface, and to try it, you do not need to
read a thing.  Pull down {hi:Data}, {hi:Graphics}, or {hi:Statistics}, find
what you are looking for, and click.

{p 4 4 2}
Fill in the dialog box and click to submit.  Do not ignore tabs at the top --
there are very useful things hidden under them.

{p 4 4 2}
If you know the command you want, you can skip the menus and type {cmd:db}
followed by the command name.  For instance you can jump directly to the
{cmd:stcox} dialog box by typing {cmd:db stcox} (or
{dialog stcox:click here}).  See help {help db}.


{title:What's useful}

{p 4 4 2}
Stata 8 has so many features that finding what you are looking for can be a
challenge.  We have addressed that:

{p 6 10 2}
1.  Pull down {hi:Help} and select {hi:Contents}.  You will be presented with
    the categories Basics, Data management, Statistics, Graphics, and
    Programming.  Click on one of them -- say, Statistics -- and you will be
    presented with another set of categories:  Summary statistics and tests,
    Tables, Estimation, Multivariate analysis, Resampling and simulation,
    Statistical hand calculations, and Special topics.  Click on one of those
    and, well, you get the idea.  With the new {cmd:help contents}, it never
    takes long to find what you need.

{p 6 10 2}
2.  Help files now have hyperlinks in the header for launching the dialog
    associated with the command.  So, there are three ways to launch a dialog
    box:  (1) use the menus (pull down {hi:Data}, {hi:Graphics}, or
    {hi:Statistics}); (2) use the new {cmd:db} command (see help {help db});
    or (3) pick the command from the online help.

{p 6 10 2}
3.  When you do need to search, {cmd:findit} is the key.  {cmd:findit}
    searches everywhere:  Stata itself, the Stata website, the FAQs, the
    {it:Stata Journal}, and even user-written programs available on the web.
    An earlier version of {cmd:findit} was made available as an update to
    Stata 7, but the new version is better.  You can also access {cmd:findit}
    by pulling down {hi:Help} and selecting {hi:Search}.  If you do that, be
    sure to click {hi:Search all} in the dialog box.  See help {help search}.

{p 6 10 2}
4.  The new {cmd:ssc} command lists and installs user-written packages from
    the Statistical Software Components (SSC) archive, also known as the
    Boston College Archive, located at {browse "http://www.repec.org"}.  See
    help {help ssc}.

{p 6 10 2}
5.  The new {cmd:net sj} command makes loading files from the new
    {it:Stata Journal} easier; see help {help net}.


{title:What's convenient}

{p 4 4 2}
The existing {cmd:set} command has a new {cmd:permanently} option that allows
you to make the setting permanent.  This does away with the necessity of
having a {cmd:profile.do} file for most users.


{title:What was needed}

{p 4 4 2}
Stata now has multiple missing values!  In addition to the previously existing
{cmd:.}, there is now {cmd:.a}, {cmd:.b}, ..., {cmd:.z}, and you can attach
value labels to the new missing codes!

{p 4 4 2}
One thing to watch out for:  Do not type

{p 8 12 2}
	{cmd:.} {it:stata_command} ... {cmd:if} {it:x} {cmd:!= .}

{p 4 4 2}
Instead, type

{p 8 12 2}
	{cmd:.} {it:stata_command} ... {cmd:if} {it:x} {cmd:< .}

{p 4 4 2}
You need remember this only if you use the new missing values, but better to
have good habits.  The way things now work,

{p 8 12 2}
	{it:all numbers} < {cmd:.} < {cmd:.a} < {cmd:.b} < ... < {cmd:.z}

{p 4 4 2}
So, if you wanted to list all observations for which {it:x} is missing, you
would type

{p 8 12 2}
	{cmd:. list if} {it:x} {cmd:>= .}

{p 4 4 2}
See help {help missing}.


{title:What's faster}

{p 4 4 2}
Stata 8 executes programming commands in half the time of Stata 7, on average.
This results in commands implemented as ado-files running about 17 to 43%
faster.

{p 6 10 2}
1.  This speed-up is due to a new, faster memory manager that reduces the
    time needed to find, access, and store results.  Thus, the improvement
    does not change much the time to run built-in, heavily computational
    commands.  {help regress}, for instance, runs only 1.43% faster.
    Nevertheless, the effect can be marked on other commands.  {help poisson}
    runs up to 31% faster, and {help heckman} runs up to 43% faster.  The
    larger the dataset, the less will be the improvement:  {cmd:heckman} runs
    17% faster on 4,000 observations.

{p 6 10 2}
2.  That statistical commands run faster is a happy side effect.  The big
    advantage of the speed-up is that it allows some problems to be approached
    using ado-files that previously would have required internal code, such as
    Stata's new graphics, which is an ado-file implementation!  Some
    programming commands run up to 400% faster.  Implementing features as
    ado-files is part of the effort to keep Stata open and extendable by
    users.


{title:What's new in time-series analysis}

{p 6 10 2}
1.  Stata now can fit vector autoregression (VAR) and structural vector
    autoregression (SVAR) models.  New commands {cmd:var}, {cmd:varbasic}, and
    {cmd:svar} perform the estimation; see help {help varintro}.

{p 10 14 2}
    a.  A suite of {cmd:varirf} commands estimate, tabulate, and graph
	impulse-response functions, cumulative impulse-response functions,
	orthogonalized impulse-response functions, structural impulse-response
	functions, and their confidence intervals, along with forecast-error
	variance decompositions and structural forecast-error variance
	decompositions; see help {help varirf}.  This suite allows graphical
	comparisons of IRFs and variance decompositions across models and
	orderings.

{p 10 14 2}
    b.  {cmd:varfcast} produces dynamic forecasts from a previously fitted
	{cmd:var} or {cmd:svar} model; see help {help varfcast}.

{p 10 14 2}
    c.  There is also a full suite of diagnostic and testing tools including

{p 16 20 2}
	i.  {cmd:vargranger}, that performs Granger causality tests; see help
	    {help vargranger}.

{p 15 20 2}
	ii.  {cmd:varlmar}, that performs a Lagrangian multiplier (LM)
	     test for residual autocorrelation; see help {help varlmar}.

{p 14 20 2}
	iii.  {cmd:varnorm}, that performs a series of tests for normality of
	      the disturbances; see help {help varnorm}.

{p 15 20 2}
	iv.  {cmd:varsoc}, that reports a series of lag order selection
	     statistics; see help {help varsoc}.

{p 16 20 2}
	v.  {cmd:varstable}, that checks the eigenvalue stability condition;
	    see help {help varstable}.

{p 15 20 2}
	vi.  {cmd:varwle}, that performs a Wald test that all the endogenous
	     variables of a given lag are zero, both for each equation
	     separately and for all equations jointly; see help {help varwle}.

{p 6 10 2}
2.  The new {cmd:tssmooth} command smooths and predicts univariate time series
    using weighted or unweighted moving average, single exponential smoothing,
    double exponential smoothing, Holt-Winters nonseasonal smoothing,
    Holt-Winters seasonal smoothing, or nonlinear smoothing.  See help
    {help tssmooth}.

{p 6 10 2}
3.  The new {cmd:tsappend} command appends observations to a time-series
    dataset, automatically filling in the time variable and the panel
    variable, if set, by using the information contained in {cmd:tsset}.  See
    help {help tsappend}.

{p 6 10 2}
4.  The new {cmd:archlm} command computes a Lagrange multiplier test for
    autoregressive conditional heteroskedasticity (ARCH) effects in the
    residuals after {help regress}; see help {help archlm}.

{p 6 10 2}
5.  The new {cmd:bgodfrey} command computes the Breusch-Godfrey Lagrange
    multiplier (LM) test for serial correlation in the disturbances after
    {help regress}; see help {help bgodfrey}.

{p 6 10 2}
6.  The new {cmd:durbina} command computes the Durbin (1970) alternative
    statistic to test for serial correlation in the disturbances after
    {help regress} when some of the regressors are not strictly exogenous; see
    help {help durbina}.

{p 6 10 2}
7.  The new {cmd:dfgls} command performs the modified Dickey-Fuller t test for
    a unit root (proposed by Elliott, Rothenberg, and Stock (1996)) using
    models with 1 to {it:maxlags} lags of the first differenced variable in an
    augmented Dickey-Fuller regression; see help {help dfgls}.

{p 6 10 2}
8.  The existing {cmd:arima} command may now be used with the {cmd:by} prefix
    command, and it now allows prediction in loops over panels; see help
    {help arima}.

{p 6 10 2}
9.  The existing {cmd:newey} command now allows (and requires) that you
    {help tsset} your data; see help {help newey}.


{title:What's new in cross-sectional time-series analysis}

{p 6 10 2}
1.  The new {cmd:xthtaylor} command fits panel-data random-effects models
    using the Hausman-Taylor and the Amemiya-MaCurdy
    instrumental-variables estimators; see help {help xthtaylor}.

{p 6 10 2}
2.  The new {cmd:xtfrontier} command fits stochastic production or cost
    frontier models for panel data allowing two different parameterizations
    for the inefficiency term: a time-invariant model and the Battese-Coelli
    (1992) parameterization of time effects; see help {help xtfrontier}.

{p 6 10 2}
3.  The existing {cmd:xtabond} command now allows endogenous regressors; see
    help {help xtabond}.

{p 6 10 2}
4.  The existing {cmd:xtivreg} command will now optionally report first stage
    results of Baltagi's EC2SLS random-effects estimator; see help
    {help xtivreg}.

{p 6 10 2}
5.  The existing {cmd:xttobit} and {cmd:xtintreg} commands have new
    {cmd:predict} options:

{p 10 14 2}
    a.  {cmd:pr0(}{it:#_a}{cmd:,}{it:#_b}{cmd:)} produces the probability of
	the dependent variable being uncensored P({it:#_a}< y < {it:#_b}).

{p 10 14 2}
    b.  {cmd:e0(}{it:#_a}{cmd:,}{it:#_b}{cmd:)} produces the corresponding
	expected value E(y | {it:#_a} < y < {it:#_b}).

{p 10 14 2}
    c.  {cmd:ystar(}{it:#_a}{cmd:,}{it:#_b}{cmd:)} produces the expected
	value of the dependent variable truncated at the censoring point(s),
	E(y^*), where y^* = max({it:#_a}, min(y,{it:#_b})).

{p 10 10 2}
  See help {help xttobit} and {help xtintreg}.

{p 6 10 2}
6.  Existing commands {cmd:xtgee} and {cmd:xtlogit} have a new {cmd:nodisplay}
    option that suppresses the header and table of coefficients; {cmd:xtregar,
    fe} now allows {cmd:aweight}s and {cmd:fweight}s; and {cmd:xtpcse} now has
    no restrictions on how {cmd:aweight}s are applied.  See help {help xtgee},
    {help xtlogit}, and {help xtpcse}.

{p 6 10 2}
7.  Two commands have been renamed:  {cmd:xtpois} is now called
    {cmd:xtpoisson} and {cmd:xtclog} is now {cmd:xtcloglog}.  The old names
    continue to work.  See help {help xtpoisson} and {help xtcloglog}.


{title:What's new in survival analysis}

{p 6 10 2}
1.  Existing command {cmd:stcox} has an important new feature and some minor
    improvements:

{p 10 14 2}
    a.  {cmd:stcox} will now fit models with gamma-distributed frailty.  In
	this model, frailty is assumed to be shared across groups of
	observations.  Previously, if one wanted to analyze multivariate
	survival data using the Cox model, one would fit a standard model and
	account for the correlation within groups by adjusting the standard
	errors for clustering.  Now, one may directly model the correlation by
	assuming a latent gamma-distributed random effect or frailty;
	observations within group are correlated because they share the same
	frailty.  Estimation is via penalized likelihood.  An estimate of the
	frailty variance is available and group-level frailty estimates can be
	retrieved.

{p 10 14 2}
    b.  {help fracpoly}, {help sw}, and {help linktest} now work after
	{cmd:stcox}.

{p 10 10 2}
    See help {help stcox}.

{p 6 10 2}
2.  Existing command {cmd:streg} has an important new feature and some minor
    improvements:

{p 10 14 2}
    a.  {cmd:streg} has new option {cmd:shared(}{it:varname}{cmd:)} for
	fitting parametric shared frailty models, analogous to random effects
	models for panel data.  {cmd:streg} could, and still can, fit frailty
	models where the frailties are assumed to be randomly distributed at
	the observation level.

{p 10 14 2}
    b.  {help fracpoly}, {help sw}, and {help linktest} now work after
	{cmd:streg}.

{p 10 14 2}
    c.  {cmd:streg} has four other new options: {cmd:noconstant},
	{cmd:offset()}, {cmd:noheader}, and {cmd:nolrtest}.

{p 10 10 2}
    See help {help streg}.

{p 6 10 2}
3.  {cmd:predict} after {cmd:streg, frailty()} has two new options:

{p 10 14 2}
    a.  {cmd:alpha1} generates predictions conditional on a frailty equal to
	1.

{p 10 14 2}
    b.  {cmd:unconditional} generates predictions that are "averaged" over
	the frailty distribution.

{p 10 10 2}
    These new options may also be used with {cmd:stcurve}.  See help
    {help streg}.

{p 6 10 2}
4.  {cmd:sts graph} and {cmd:stcurve} (after {cmd:stcox}) can now plot
    estimated hazard functions, which are calculated as weighted kernel
    smooths of the estimated hazard contributions; see help {help sts}.

{p 6 10 2}
5.  {cmd:streg, dist(gamma)} is now faster and more accurate.  In addition,
    you can now predict mean time after gamma; see help {help streg}.

{p 6 10 2}
6.  Old commands {cmd:ereg}, {cmd:ereghet}, {cmd:llogistic},
    {cmd:llogistichet}, {cmd:gamma}, {cmd:gammahet}, {cmd:weibull},
    {cmd:weibullhet}, {cmd:lnormal}, {cmd:lnormalhet}, {cmd:gompertz},
    {cmd:gompertzhet} are deprecated (they continue to work) in favor of
    {cmd:streg}.  Old command {cmd:cox} is now deprecated (it continues to
    work) in favor of {cmd:stcox}.  See help {help streg} and {help stcox}.


{title:What's new in survey analysis}

{p 6 10 2}
1.  Stata's {cmd:ml} user-programmable likelihood-estimation routine has new
    options that automatically handle the production of survey estimators,
    including stratification and estimation on a subpopulation; see help
    {help ml}.

{p 6 10 2}
2.  Four new survey estimation commands are available:

{p 10 14 2}
    a.  {cmd:svynbreg} for negative-binomial regression; see help
	{help svynbreg}.

{p 10 14 2}
    b.  {cmd:svygnbreg} for generalized negative-binomial regression; see help
	{help svygnbreg}.

{p 10 14 2}
    c.  {cmd:svyheckman} for the Heckman selection model; see help
	{help svyheckman}.

{p 10 14 2}
    d.  {cmd:svyheckprob} for probit regression with selection; see help
	{help svyheckprob}.

{p 6 10 2}
3.  Use of the survey commands has been made more consistent.

{p 10 14 2}
    a.  {cmd:svyset} has new syntax.  Before it was

{p 18 22 2}
	    {cmd:svyset} {it:thing_to_set} [{cmd:, clear} ]

{p 14 14 2}
	and now it is

{p 18 22 2}
	    {cmd:svyset} [{it:weight}] [{cmd:, strata(}{it:varname}{cmd:)}
		{cmd:psu(}{it:varname}{cmd:)} {cmd:fpc(}{it:varname}{cmd:)} ]

{p 14 14 2}
	See help {help svyset} for details.  In addition, you must now
	{cmd:svyset} your data prior to using the survey commands; no longer
	can you set the data via options to the other survey commands.

{p 10 14 2}
    b.  Two survey estimation commands have been renamed:  {cmd:svyreg} to
	{cmd:svyregress} and {cmd:svypois} to {cmd:svypoisson}; see help
	{help svyregress} and {help svypois}.

{p 10 14 2}
    c.  {cmd:svyintreg} now applies constraints in the same manner as all
	other estimation commands; see help {help svyintreg}.

{p 10 14 2}
    d.  {cmd:lincom} now works after all {cmd:svy} estimators; see help
	{help lincom}.  ({cmd:svylc} is now deprecated.)

{p 10 14 2}
    e.  {cmd:testnl} now works after all {cmd:svy} estimators; see help
	{help testnl}.

{p 10 14 2}
    f.  {cmd:testparm} now works after all {cmd:svy} estimators; see help
	{help test}.

{p 10 14 2}
    g.  The new {cmd:nlcom} and {cmd:predictnl} commands, which form nonlinear
	combinations of estimators and generalized predictions, work after all
	{cmd:svy} estimators; see help {help nlcom} and {help predictnl}.

{p 6 10 2}
4.  Existing command {cmd:svytab} has three new options: {cmd:cellwidth()},
    {cmd:csepwidth()}, and {cmd:stubwidth()}; they specify the widths of table
    elements in the output.  See help {help svytab}.


{title:What's new in cluster analysis}

{p 6 10 2}
1.  The new {cmd:cluster wardslinkage} command provides Ward's linkage
    hierarchical clustering and can produce Ward's method, also known as
    minimum-variance clustering.  See help {help clward}.

{p 6 10 2}
2.  The new {cmd:cluster waveragelinkage} command provides weighted-average
    linkage hierarchical clustering to accompany the previously available
    average linkage clustering.  See help {help clwav}.

{p 6 10 2}
3.  The new {cmd:cluster centroidlinkage} command provides centroid linkage
    hierarchical clustering.  This differs from the previously available
    {cmd:cluster averagelinkage} in that it combines groups based on the
    average of the distances between observations of the two groups to be
    combined.  See help {help clcent}.

{p 6 10 2}
4.  The new {cmd:cluster medianlinkage} command provides median linkage
    hierarchical clustering, also known as Gower's method.  See help
    {help clmedian}.

{p 6 10 2}
5.  The new {cmd:cluster stop} command provides stopping rules.  Two popular
    stopping rules are provided, the Calinski & Harabasz pseudo-F index
    (Calinski and Harabasz (1974)) and the Duda & Hart Je(2)/Je(1) index with
    associated pseudo T-squared (Duda and Hart (1973)).  See help
    {help clstop}.

{p 10 10 2}
    Additional stopping rules can be added; see help {help clprog}.

{p 6 10 2}
6.  Two new dissimilarity measures have been added:  {cmd:L2squared} and
    {cmd:Lpower(}{it:#}{cmd:)}.  {cmd:L2squared} provides squared Euclidean
    distance.  {cmd:Lpower(}{it:#}{cmd:)} provides the Minkowski distance
    metric with argument {it:#} raised to the {it:#} power.  See help
    {help cldis}.

{p 6 10 2}
7.  A list of the variables used in the cluster analysis is now saved with the
    cluster analysis structure, which is useful for programmers; see help
    {help clprog}.


{title:What's new in statistics useful in all fields}

{p 6 10 2}
1.  The following new estimators are available:

{p 10 14 2}
    a.  {cmd:manova} fits multivariate analysis-of-variance (MANOVA) and
	multivariate analysis-of-covariance (MANCOVA) models for balanced and
	unbalanced designs, including designs with missing cells; and for
	factorial, nested, or mixed designs.  See help {help manova}.
	({cmd:manovatest} provides multivariate tests involving terms from the
	most recently fitted {cmd: manova}; see help {help manovatest}.)

{p 10 14 2}
    b.  {cmd:rologit} fits the rank-order logit model, also known as the
	exploded logit model.  This model is a generalized McFadden's choice
	model as fitted by {cmd:clogit}.  In the choice model, only the
	alternative that maximizes utility is observed.  {cmd:rologit} fits
	the corresponding model in which the preference ranking of the
	alternatives is observed, not just the alternative that is ranked
	first.  {cmd:rologit} supports incomplete rankings and ties
	("indifference").  See help {help rologit}.

{p 10 14 2}
    c.  {cmd:frontier} fits stochastic frontier models with technical or cost
	inefficiency effects.  {cmd:frontier} can fit models in which the
	inefficiency error component is assumed to be from one of the three
	distributions: half-normal, exponential, or truncated-normal.  In
	addition, when the inefficiency term is assumed to be either
	half-normal or exponential, {cmd:frontier} can fit models in which the
	error components are heteroskedastic, conditional on a set of
	covariates.  {cmd:frontier} can also fit models in which the mean of
	the inefficiency term is modeled as a linear function of a set of
	covariates.  See help {help frontier}.

{p 10 10 2}
These new estimators are in addition to the new estimators listed in previous
sections.

{p 6 10 2}
2.  New command {cmd:mfp} selects the fractional polynomial model that best
    predicts the dependent variable from the independent variables; see help
    {help mfp}.

{p 6 10 2}
3.  The new {cmd:nlcom} command computes point estimates, standard errors, t
    and Z statistics, p-values, and confidence intervals for nonlinear
    combinations of coefficients after any estimation command.  Results are
    displayed in the table format that is commonly used for displaying
    estimation results.  The standard errors are based on the delta method, an
    approximation appropriate in large samples.  See help {help nlcom}.

{p 6 10 2}
4.  The new {cmd:predictnl} command produces nonlinear predictions after any
    Stata estimation command, and optionally, can calculate the variance,
    standard errors, Wald test-statistics, significance levels, and point-wise
    confidence intervals for these predictions.  Unlike {cmd:testnl} and
    {cmd:nlcom}, the quantities generated by {cmd:predictnl} are allowed to
    vary over the observations in the data.  The standard errors and other
    inference-related quantities are based on the "delta method", an
    approximation appropriate in large samples.  See help {help predictnl}.

{p 6 10 2}
5.  The new {cmd:bootstrap} command replaces the old {cmd:bstrap} and {cmd:bs}
    commands.  {cmd:bootstrap} has an improved syntax and allows for
    stratified sampling.  See help {help bootstrap}.

{p 10 10 2}
    Existing command {cmd:bsample} also now accepts the {cmd:strata()} option,
    and it has a new {cmd:weight()} option that allows the user to save the
    sample frequency instead of changing the data in memory.  See help
    {help bootstrap}.

{p 6 10 2}
6.  The existing {cmd:bstat} command can now construct bias-corrected and
    accelerated (BCa) confidence intervals.  In addition, {cmd:bstat} is now
    an e-class command, meaning all the post-estimation commands can be used
    on bootstrap results.  See help {help bootstrap}.

{p 6 10 2}
7.  Existing command {cmd:jknife} now accepts the {cmd:cluster()} option; see
    help {help jknife}.

{p 6 10 2}
8.  New command {cmd:permute} estimates p-values for permutation tests based
    on Monte Carlo simulations.  These estimates can be one sided or two
    sided.  See help {help permute}.

{p 6 10 2}
9.  Existing command {cmd:sample} has new option {cmd:count} that allows
    samples of the specified number of observations (rather than a percentage)
    to be drawn.  In addition, {cmd:sample} now allows the
    {bind:{cmd:by} {it:varlist}{cmd::}} prefix as an alternative to the
    already existing {cmd:by(}{it:varlist}{cmd:)} option; both do the same
    thing.  See help {help sample}.

{p 5 10 2}
10.  New command {cmd:simulate} replaces {cmd:simul} and provides improved
     syntax for specifying simulations; see help {help simulate}.

{p 5 10 2}
11.  Existing command {cmd:statsby} has a new syntax, new options, and now
     allows time-series operators; see help {help statsby}.

{p 5 10 2}
12.  The new {cmd:estimates} command provides a new, consistent way to store
     and refer to estimation results.  Post-estimation commands that make
     comparisons across models, such as {cmd:lrtest} and {cmd:hausman},
     previously had their own idiosyncratic ways to store and refer to
     estimation results.  These commands now support a unified way of
     retrieving estimation results utilizing the new {cmd:estimates} suite.

{p 10 10 2}
     Under the new scheme, after fitting a model, you can type

{p 14 18 2}
	{cmd:. estimates store} {it:name}

{p 10 10 2}
     to save the results.  At some point later in the session, you can type

{p 14 18 2}
	{cmd:. estimates restore} {it:name}

{p 10 10 2}
     to get back the estimates.  You can redisplay estimates (without
     restoring them) by typing

{p 14 18 2}
	{cmd:. estimates replay} {it:name}

{p 10 10 2}
     Other estimation manipulation commands are provided; see help
     {help estimates}.

{p 10 14 2}
     a.  Existing command {help lrtest} has been modified to have syntax

{p 18 22 2}
	{cmd:lrtest} {it:name} {it:name}

{p 10 14 2}
     b.  Existing command {help hausman} has been modified to have syntax

{p 18 22 2}
	{cmd:hausman} {it:name} {it:name}

{p 10 14 2}
     c.  The new {cmd:estimates for} command can be used in front of any
	 post-estimation command, such as {help test} or {help predict}, to
	 perform the action on the specified set of estimation results,
	 without disturbing the current estimation results.  With
	 {cmd:estimates for}, you can type such things as

{p 18 22 2}
	{cmd:. estimates for} {it:earlierresults}{cmd:: predict expected}

{p 14 14 2}
     See help {help estimates}.

{p 10 14 2}
     d.  The new {cmd:estimates stats} command displays the Akaike Information
	 Criterion (AIC) and Schwarz Information Criterion (BIC) model
	 selection indexes.  See help {help estimates}.

{p 5 10 2}
13.  Existing command {cmd:lrtest} now supports composite models specified by
     a parenthesized list of model names.  In a composite model, it is assumed
     that the log likelihood and dimension of the full model are obtained as
     the sum of the log likelihoods and the sum of the dimensions of the
     constituent models.

{p 10 10 2}
     {cmd:lrtest} has a new {cmd:stats} option to display statistical
     information about the unrestricted and restricted models, including the
     AIC and BIC model selection statistics.  See help {help lrtest}.

{p 5 10 2}
14.  {cmd:test} has improved syntax:

{p 10 14 2}
     a.  You may now type

{p 18 22 2}
	    {cmd:. test} {it:a} {cmd:=} {it:b}

{p 14 14 2}
	 for expressions {it:a} and {it:b}, or you may type

{p 18 22 2}
	    {cmd:. test} {it:a} {cmd:==} {it:b}

{p 14 14 2}
	 The use of {cmd:==} is more consistent with Stata's syntax that
	 treats {cmd:==} as indicating comparison and {cmd:=} as meaning
	 assignment.

{p 10 14 2}
     b.  You may now specify multiple tests on one line:

{p 18 22 2}
	 {cmd:. test} {cmd:(}{it:a} {cmd:==} {it:b} {cmd:==} {it:c}{cmd:)}

{p 18 22 2}
	 {cmd:. test} {cmd:(}{it:a} {cmd:==} {it:b}{cmd:)}
			{cmd:(}{it:c} {cmd:==} {it:d}{cmd:)}

{p 10 14 2}
     c.  {cmd:test} has new option {cmd:coef}, which specifies that the
	 constrained coefficients are to be displayed.

{p 10 14 2}
     d.  {cmd:test} has two new options for use with the
	 {cmd:test} {cmd:[}{it:eq1}{cmd:==}{it:eq2}{cmd:]} syntax:
	 {cmd:constant} and {cmd:common}.  {cmd:constant} specifies that
	 {cmd:_cons} should be included in the list of coefficients to be
	 tested.  {cmd:common} specifies that {cmd:test} restrict itself to
	 the coefficient in common between {it:eq1} and {it:eq2}.

{p 10 14 2}
     e.  {cmd:test} may now be used after survey estimation.

{p 10 14 2}
     f.  {cmd:test} has a new programmer's option
	 {cmd:matvlc(}{it:matname}{cmd:)}, which saves the variance-covariance
	 matrix of the linear combination(s).

{p 10 10 2}
     See help {help test}.

{p 5 10 2}
15.  {cmd:testnl} now allows typing
     {cmd:testnl} {it:exp}{cmd:==} {it:exp} {cmd:==} ... {cmd:==} {it:exp}
     to test whether two or more expressions are equal.  Single equal signs
     may be used:
     {cmd:testnl} {it:exp}{cmd:=} {it:exp} {cmd:=} ... {cmd:=} {it:exp}.

{p 10 10 2}
     In addition, {cmd:testnl} has new option {cmd:iterate(}{it:#}{cmd:)} for
     specifying the maximum number of iterations used to find the optimal step
     size in the calculation of the numerical derivatives of the expressions
     to be tested.  See help {help testnl}.

{p 5 10 2}
16.  {cmd:testparm} has new option {cmd:equation()} for use after fitting
     multiple-equation models such as {help mvreg}, {help mlogit},
     {help heckman}, etc.  It specifies the equation for which the all-zero or
     all-equal hypothesis is to be tested.  See help {help test}.

{p 5 10 2}
17.  {cmd:lincom} now works after {help anova} and after all survey
     estimators; see help {help lincom}.

{p 5 10 2}
18.  {cmd:bitest}, {cmd:prtest}, {cmd:ttest}, and {cmd:sdtest} now allow
     {cmd:==} to be used wherever {cmd:=} is allowed in their syntax; See help
     {help bitest}, {help prtest}, {help ttest}, and {help sdtest}.

{p 5 10 2}
19.  New command {cmd:suest} is a post-estimation command that combines
     multiple estimation results (parameter vectors and their
     variance-covariance matrices) into simultaneous results with a single
     stacked parameter vector and a robust (sandwich) variance-covariance
     matrix. The estimation results to be combined may be based on different,
     overlapping, or even the same data.  After creating the simultaneous
     estimation results, one can use {help test} or {help testnl} to obtain
     Hausman-type tests for cross-model hypotheses.  {cmd:suest} supports
     survey data.  See help {help suest}.

{p 5 10 2}
20.  New command {cmd:imtest} performs the information matrix test for an a
     regression model.  In addition, it provides the Cameron-Trevedi
     decomposition of the IM-test in tests for heteroskedasticity, skewness,
     and kurtosis, and White's original heteroskedasticity test.  See help
     {help imtest}.

{p 5 10 2}
21.  New command {cmd:szroeter} performs Szroeter's test for
     heteroskedasticity in a regression model; see help {help szroeter}.

{p 5 10 2}
22.  Existing command {cmd:hettest} now provides option {cmd:rhs} to test for
     heteroskedasticity in the independent variables.  It now also supports
     multiple comparison testing.  See help {help hettest}.

{p 5 10 2}
23.  Existing command {cmd:tabulate} has output changes, new features, and
     expanded limits.

{p 10 14 2}
     a.  Three new statistics are available for twoway tabulations:
	 {cmd:expected}, {cmd:cchi2}, and {cmd:clrchi2}.  {cmd:expected}
	 reports the expected number in each cell.  {cmd:cchi2} reports the
	 contribution to Pearson's chi-squared.  {cmd:clrchi2} reports the
	 contribution to the likelihood-ratio chi-squared.

{p 10 14 2}
     b.  New options {cmd:key} and {cmd:nokey} force or suppress a key
	 explaining the entries in the table.

{p 10 14 2}
     c.  Twoway tabulations now respect {cmd:set linesize}, meaning you can
	 produce wide tables.

{p 10 14 2}
     d.  Both oneway and twoway tabulations now put commas in the reported
	 frequency counts.

{p 10 14 2}
     e.  {cmd:tabulate} for oneway tabulations has new option {cmd:sort},
	 which puts the table in descending order of frequency.

{p 10 14 2}
     f.  {cmd:tabulate} has expanded limits:

		  {c TLC}{hline 19}{c TT}{hline 8}{c TT}{hline 13}{c TRC}
		  {c |} Flavor            {c |}  1-way {c |}    2-way    {c |}
		  {c LT}{hline 19}{c +}{hline 8}{c +}{hline 13}{c RT}
		  {c |} {help SpecialEdition:Stata/SE}          {c |} 12,000 {c |} 12,000 x 80 {c |}
		  {c |} Intercooled Stata {c |}  3,000 {c |}    300 x 20 {c |}
		  {c |} Small Stata       {c |}    500 {c |}    160 x 20 {c |}
		  {c BLC}{hline 19}{c BT}{hline 8}{c BT}{hline 13}{c BRC}

{p 10 10 2}
     See help {help tabulate}.

{p 5 10 2}
24.  Existing command {cmd:tabstat} has new options {cmd:statistics(variance)}
     and {cmd:statistics(semean)} which display the variance and the standard
     error of the mean.  (Also provided is new option
     {cmd:varwidth(}{it:#}{cmd:)}, specifying the number of characters used to
     display variable names.)  See help {help tabstat}.

{p 5 10 2}
25.  Existing command {cmd:roctab} has new option {cmd:specificity} to graph
     sensitivity versus specificity, instead of the default sensitivity versus
     (1-specificity); see help {help roctab}.

{p 5 10 2}
26.  Existing command {cmd:ologit} now has option {cmd:or} to display results
     as odds ratios (display exponentiated coefficients); see help
     {help ologit}.

{p 5 10 2}
27.  New command {cmd:lowess} replaces old command {cmd:ksm}.  {cmd:lowess}
     allows {cmd:graph} {cmd:twoway}'s {cmd:by()} option and is much faster
     than {cmd:ksm}; see help {help lowess}.

{p 5 10 2}
28.  Existing command {cmd:kdensity} has been rewritten so that it executes
     faster; see help {help kdensity}.

{p 5 10 2}
29.  Existing command {cmd:intreg} now applies constraints in the same manner
     as all other estimation commands, and existing command {cmd:mlogit} now
     allows constraints with constants; see help {help intreg} and
     {help mlogit}.

{p 5 10 2}
30.  New command {cmd:pca} performs principal components analysis, replacing
    {cmd:factor,} {cmd:pc}; see help {help pca}.

{p 5 10 2}
31.  Existing command {cmd:ml} {cmd:maximize} and all estimators using {cmd:ml}
     have a new tolerance option {cmd:nrtolerance(}{it:#}{cmd:)} for
     determining convergence.  Convergence is declared when
     {bf:g}*inv({bf:H})*{bf:g}' < {cmd:nrtolerance(}{it:#}{cmd:)}, where {bf:g}
     represents the gradient vector and {bf:H} the Hessian matrix; see help
     {help maximize}.

{p 5 10 2}
32.  Existing command {cmd:mfx} will now use {cmd:pweight}s or {cmd:iweight}s
     when calculating the means or medians for the {it:atlist} following an
     estimation command that used {cmd:pweight}s or {cmd:iweight}s.
     Previously, only {cmd:fweight}s and {cmd:aweight}s were supported.  See
     help {help mfx}.

{p 5 10 2}
33.  Existing command {cmd:adjust} now allows the {cmd:pr} option to display
     predicted probabilities when used after {help svylogit},
     {help svyprobit}, {help xtlogit}, and {help xtprobit}.  See help
     {help adjust}.

{p 5 10 2}
34.  The existing regression diagnostics commands {help acprplot},
     {help cprplot}, {help hettest}, {help lvr2plot}, {help ovtest},
     {help rvfplot}, and {help rvpplot} have been extended to work after
     {help anova}.  In addition, {help cprplot} and {help acprplot} have new
     options {cmd:lowess} and {cmd:mspline} that allow putting a lowess curve
     or median spline through the data.  See help {help regdiag}.

{p 5 10 2}
35.  Existing command {cmd:ranksum} has new option {cmd:porder} that estimates
     P(x_1>x_2); see help {help signrank}.

{p 5 10 2}
36.  Existing command {cmd:poisgof} has new option {cmd:pearson} to request
     the Pearson chi-squared goodness-of-fit statistic; see help {help poisson}.

{p 5 10 2}
37.  Existing command {cmd:binreg} now respects the {cmd:init()} option; see
     help {help binreg}.

{p 5 10 2}
38.  Existing command {cmd:boxcox} now accepts {cmd:iweight}s; see help
     {help boxcox}.

{p 5 10 2}
39.  Existing commands {cmd:zip} and {cmd:zinb} now accept the
     {it:maximize_option} {cmd:from()} to provide starting values; see help
     {help zip}.

{p 5 10 2}
40.  Existing command {cmd:cnsreg} now accepts the {cmd:noconstant} option;
     see help {help cnsreg}.

{p 5 10 2}
41.  Existing command {cmd:hotel} has been renamed {cmd:hotelling}; {cmd:hotel}
    is now an abbreviation for {cmd:hotelling}; see help {help hotelling}.

{p 5 10 2}
42.  The {cmd:score()} option is now unified across all estimation commands.
     You must specify the correct number of score variables, and, in
     multiple-equation estimators, you may specify {it:stub}{cmd:*} to mean
     create new variables named {it:stub}{cmd:1}, {it:stub}{cmd:2}, ...

{p 10 10 2}
     Estimation commands now save in {cmd:e(scorevars)} the names of the score
     variables if {cmd:score()} was specified.

{p 5 10 2}
43.  Existing command {cmd:summarize} without the {cmd:detail} option now
     allows {cmd:iweight}s; see help {help summarize}.

{p 5 10 2}
44.  Existing commands {cmd:ci} and {cmd:summarize} have new option
     {cmd:separator(}{it:#}{cmd:)} that specifies how frequently separation
     lines should be inserted into the output; see help {help ci} and
     {help summarize}.

{p 5 10 2}
45.  Existing command {cmd:impute} has three new options, {cmd:regsample},
     {cmd:all}, and {cmd:copyrest} that control the sample used for forming
     the imputation and how out-of-sample values are treated; see help
     {help impute}.

{p 5 10 2}
46.  Existing command {cmd:collapse} now takes time-series operators; see help
     {help collapse}.


{title:What's new in data management}

{p 6 10 2}
1.  New command {cmd:odbc} allows Stata for Windows to act as an ODBC client,
    meaning you can fetch data directly from ODBC sources; see help
    {help odbc}.

{p 6 10 2}
2.  Existing command {cmd:generate} has new, more convenient syntax.
    Now you can type

{p 14 18 2}
	{cmd:. generate a = 2 + 3}

{p 10 10 2}
    or

{p 14 18 2}
	{cmd:. generate b = "this" + "that"}

{p 10 10 2}
    without specifying whether new variable {cmd:b} is numeric or string of a
    particular length.  If you wish, you can also type

{p 14 18 2}
	{cmd:. generate str b = "this" + "that"}

{p 10 10 2}
    which asserts that {cmd:b} is a string but leaves it to {cmd:generate} to
    determine the length of the string.  This is useful in programming
    situations because it helps to prevent bugs.  Of course, you can continue
    to type

{p 14 18 2}
	{cmd:. generate double a = _pi/2}

{p 10 10 2}
    and

{p 14 18 2}
	{cmd:. generate str8 b = "this" + "that"}

{p 10 10 2}
    See help {help generate}.

{p 6 10 2}
3.  Existing command {cmd:list} has been completely redone.  Not only is
    output far more readable -- and even pretty -- but programmers will want
    to use {cmd:list} to format tables.  See help {help list}.

{p 6 10 2}
4.  Existing command {cmd:merge} has been improved:

{p 10 14 2}
    a.  New options {cmd:unique}, {cmd:uniqmaster}, and {cmd:uniqusing} ensure
	that the merge goes as you intend.  These options amount to assertions
	that, if false, cause {cmd:merge} to stop.  {cmd:unique} specifies
	that there should not be repeated observations within match variables,
	and that if you say "{cmd:merge} {it:id} {cmd:using} {it:myfile}",
	there should be one observation per {it:id} value in the master data
	(the data in memory) and one observation per {it:id} in the using
	data.  If observations are not unique, {cmd:merge} will complain.

{p 14 14 2}
	Options {cmd:uniqmaster} and {cmd:uniqusing} make the same claim for
	one or the other half of the merge; {cmd:uniq} is equivalent to
	specifying {cmd:uniqmaster} and {cmd:uniqusing}.

{p 10 14 2}
    b.  {cmd:merge} no longer has a limit on the number of match (key)
	variables.

{p 10 14 2}
    c.  {cmd:merge} has new option {cmd:keep(}{it:varlist}{cmd:)} that
	specifies the variables to be kept from the using data.

{p 10 10 2}
    See help {help merge}.

{p 6 10 2}
5.  Existing command {cmd:append} has new option {cmd:keep(}{it:varlist}{cmd:)}
    that specifies the variables to be kept from the using data; see help
    {help append}.

{p 6 10 2}
6.  New command {cmd:tsappend} appends observations in a time-series context.
    {cmd:tsappend} uses the information set by {help tsset}, automatically
    fills in the time variable, and fills in the panel variable if the panel
    variable was set.  See help {help tsappend}.

{p 6 10 2}
7.  Existing command {cmd:describe using} will now allow you to specify a
    {it:varlist}, so you can check whether a variable exists in a dataset
    before merging or appending.  Programmers will be interested in the new
    {cmd:varlist} option, which will leave in {cmd:r()} the names of the
    variables in the dataset.  See help {help describe}.

{p 6 10 2}
8.  New command {cmd:isid} verifies that a variable or set of variables
    uniquely identify the observations and so are suitable for use with
    {cmd:merge}; see help {help isid}.

{p 6 10 2}
9.  Existing command {cmd:codebook} has new option {cmd:problems} to report
    potential problems in the data; see help {help codebook}.

{p 5 10 2}
10.  New command {cmd:labelbook} is like {cmd:codebook}, but for value labels.
     In addition to providing documentation, the output includes a list of
     potential problems.

{p 10 10 2}
     New command {cmd:numlabel} prefixes numerical values onto value labels
     and removes them.  For example, the mapping 2 --> "Catholic"
     becomes "2. Catholic" and vice versa.

{p 10 10 2}
     See help {help labelbook} and {help numlabel}.

{p 5 10 2}
11.  New command {cmd:duplicates} reports on, gives examples of, lists,
     browses, tags, and/or drops duplicate observations; see help
     {help duplicates}.

{p 5 10 2}
12.  Existing command {cmd:recode} has three new features:

{p 10 14 2}
     a.  {cmd:recode} now allows a {it:varlist} rather than a {it:varname},
	 so several variables can be recoded at once.

{p 10 14 2}
     b.  {cmd:recode} has new option {cmd:generate()} to specify that the
	 transformed variables be stored under different names than the
	 originals.

{p 10 14 2}
     c.  {cmd:recode} has new option {cmd:prefix()}, an alternative to
	 {cmd:generate}, to specify that the transformed variables are to be
	 given their original names, but with a prefix.

{p 10 10 2}
     See help {help recode}.

{p 5 10 2}
13.  Existing command {cmd:sort} has new option {cmd:stable} that says, within
     equal values of the sort keys, the observations are to appear in the same
     order as they did originally.  See help {help sort}.

{p 5 10 2}
14.  New command {cmd:webuse} loads the specified dataset, obtaining it over
     the web.  By default, datasets are obtained from
     {browse "http://www.stata-press.com/data/r8/"}, but you can reset that.
     See help {help webuse}.

{p 10 10 2}
     New command {cmd:sysuse} loads the specified dataset that was shipped
     with Stata, plus any other datasets stored along the ado-path; see help
     {help sysuse}.

{p 5 10 2}
15.  Existing command {cmd:insheet} has a new {cmd:delimiter(}{it:char}{cmd:)}
     option that allows you to specify an arbitrary character as the value
     separator; see help {help insheet}.

{p 5 10 2}
16.  Existing commands {cmd:infile} and {cmd:infix} no longer treat {cmd:^Z}
     as the end of a file; see help {help infile1}, {help infile2} and
     {help infix}.

{p 5 10 2}
17.  Existing command {cmd:save} has features:

{p 10 14 2}
     a.  New option {cmd:orphans} specifies that all value labels, including
	 those not attached to any variables, are to be saved in the file.

{p 10 14 2}
     b.  New option {cmd:emptyok} specifies that the dataset is to be saved
	 even if it contains no variables and no observations.

{p 10 14 2}
     c.  Existing option {cmd:old} is removed.  To save datasets in Stata 7
	 format, use the new {cmd:saveold} command; see help {help saveold}.

{p 10 10 2}
     See help {help save}.  By the way, Stata 8 now has a single {cmd:.dta}
     dataset format used by both {help SpecialEdition:Stata/SE} and
     Intercooled Stata, meaning that sharing data with colleagues is easy.

{p 5 10 2}
18.  Existing command {cmd:outfile} has new features:

{p 10 14 2}
     a.  New options {cmd:rjs} and {cmd:fjs} specify how strings are to be
	 aligned in the output file.  The default is left alignment.  Option
	 {cmd:rjs} specifies right alignment.  Option {cmd:fjs} specifies
	 alignment as specified by the variables' formats.

{p 10 14 2}
     b.  New option {cmd:runtogether} is for use by programmers; it specifies
	 that all string variables be run together without extra spaces in
	 between or quotes.

{p 10 10 2}
    See help {help outfile}.

{p 5 10 2}
19.  You may attach value labels to the new extended missing values ({cmd:.a},
     {cmd:.b}, ..., {cmd:.z}); see help {help label}.

{p 5 10 2}
20.  As a consequence of the 26 new missing value codes, the maximum value
     that can be stored in a {cmd:byte}, {cmd:int}, and {cmd:long} is reduced
     to 100, 32,740, and 2,147,483,620; see help {help datatypes}.

{p 5 10 2}
21.  New command {cmd:split} splits the contents of a string variable into one
     or more parts and is useful for separating words into multiple variables;
     see help {help split}.

{p 5 10 2}
22.  In the way of minor improvements are

{p 10 14 2}
     a.  Existing command {cmd:egen} now allows longer {it:numlists} in the
	 {cmd:values()} option for the {cmd:eqany()} and {cmd:neqany()}
	 functions; see help {help egen}.

{p 10 14 2}
     b.  Existing command {cmd:destring} now allows an abbreviated
	 {it:newvarlist} in the {cmd:generate()} option; see help
	 {help destring}.

{p 10 14 2}
     c.  Existing commands {cmd:icd9} and {cmd:icd9p} have been updated to use
	 the V18 and V19 codes; V16, V18, and V19 codes have been merged so
	 that {cmd:icd9} and {cmd:icd9p} work equally well with old and new
	 datasets; see help {help icd9}.

{p 10 14 2}
     d.  Existing command {cmd:egen} {cmd:mtr()} has been updated to include
	 the marginal tax rates for the years 2000 and 2001; see help
	 {help egen}.

{p 10 14 2}
     e.  Existing command {cmd:mvdecode}'s {cmd:mv()} option now allows a
	 {it:numlist}; see help {help mvencode}.

{p 10 14 2}
     f.  Existing command {cmd:mvencode} has a new, more versatile syntax to
	 accommodate extended missing values; see help {help mvencode}.

{p 10 14 2}
     g.  Existing command {cmd:xpose} has three new options: {cmd:format},
	 {cmd:format(%}{it:fmt}{cmd:)}, and {cmd:promote}.  The {cmd:format}
	 option finds the largest numeric display format in the pretransposed
	 data and applies it to the transposed data.  The
	 {cmd:format(%}{it:fmt}{cmd:)} option sets the transposed data to the
	 specified format.  The {cmd:promote} option causes the transposed
	 data to have the most compact numeric data type that preserves the
	 original data accuracy.  See help {help xpose}.

{p 10 14 2}
     h.  Existing command {cmd:notes} now allows the individual notes to
	 include SMCL directives; see help {help notes}.

{p 10 14 2}
     i.  Existing command {cmd:mkmat} has new {cmd:nomissing} option that
	 causes observations with missing values to be excluded (because
	 matrices can now contain missing values).  {cmd:mkmat} has also been
	 made faster.  See help {help mkmat}.

{p 10 14 2}
     j.  Existing command {cmd:ds} has three new options: {cmd:alpha},
	 {cmd:varwidth(}{it:#}{cmd:)}, and {cmd:skip(}{it:#}{cmd:)}.
	 {cmd:alpha} sorts the variables in alphabetic order.
	 {cmd:varwidth(}{it:#}{cmd:)} specifies the display width of the
	 variable names.  {cmd:skip(}{it:#}{cmd:)} specifies the number of
	 spaces between variables.  See help {help describe}.

{p 10 14 2}
     k. Existing commands {cmd:label dir} now returns the names of the defined
	value labels in {cmd:r(names)} and {cmd:label list} now returns the
	minimum and maximum of the mapped values in {cmd:r(min)} and
	{cmd:r(max)}; see help {help label}.


{title:What's new in expressions and functions}

{p 6 10 2}
1.  First, a warning:  Do not type

{p 14 18 2}
	{cmd:. generate} {it:newvar} {cmd:=} ... {cmd:if} {it:oldvar} {cmd:!= .}

{p 14 18 2}
	{cmd:. replace} {it:oldvar} {cmd:=} ... {cmd:if} {it:oldvar} {cmd:!= .}

{p 14 18 2}
	{cmd:. list} ... {cmd:if} {it:var} {cmd:!= .}

{p 10 10 2}
    Type

{p 14 18 2}
	{cmd:. generate} {it:newvar} {cmd:=} ... {cmd:if} {it:oldvar} {cmd:< .}

{p 14 18 2}
	{cmd:. replace} {it:oldvar} {cmd:=} ... {cmd:if} {it:oldvar} {cmd:< .}

{p 14 18 2}
	{cmd:. list} ... {cmd:if} {it:var} {cmd:< .}

{p 10 10 2}
    or type

{p 14 18 2}
	{cmd:. generate} {it:newvar} {cmd:=} ... {cmd:if !mi(}{it:oldvar}{cmd:)}

{p 14 18 2}
	{cmd:. replace} {it:oldvar} {cmd:=} ... {cmd:if !mi(}{it:oldvar}{cmd:)}

{p 14 18 2}
	{cmd:. list} ... {cmd:if !mi(}{it:var}{cmd:)}

{p 10 10 2}
    Stata has new missing values and the ordering is {it:all numbers} <
    {cmd:.} < {cmd:.a} < {cmd:.b} < ... < {cmd:.z}.  If you do not use the new
    missing values, then your old habits will work, but better to be safe.

{p 10 10 2}
    It is a hot topic of debate at StataCorp whether {it:varname}{cmd:<.} or
    {cmd:!mi(}{it:varname}{cmd:)} is the preferred way of excluding missing
    values, and therefore both constructs are deemed to be equally stylish;
    use whichever appeals to you.

{p 10 10 2}
    New function {cmd:mi()} is a synonym for existing function
    {cmd:missing()}; it returns 1 (true) if missing and false otherwise.
    See help {help progfun}.

{p 6 10 2}
2.  By the same token, do not type

{p 14 18 2}
	{cmd:. list} ... {cmd:if} {it:var} {cmd:== .}

{p 10 10 2}
    To list observations with missing values of {\it var}, type

{p 14 18 2}
	{cmd:. list} ... {cmd:if} {it:var} {cmd:>= .}

{p 10 10 2}
    or type

{p 14 18 2}
	{cmd:. list} ... {cmd:if mi(}{it:var}{cmd:)}

{p 6 10 2}
3.  Matrices can now contain missing values, both the standard one ({cmd:.})
    and the extended ones ({cmd:.a}, {cmd:.b}, ..., {cmd:.z}).

{p 6 10 2}
4.  The following new density functions are provided:

{p 10 14 2}
    a.  {cmd:tden(}{it:n}{cmd:,}{it:t}{cmd:)}, the density of Student's t
	distribution.

{p 10 14 2}
    b.  {cmd:Fden(}{it:n_1}{cmd:,}{it:n_2}{cmd:,}{it:F}{cmd:)}, the density of
	the F distribution.

{p 10 14 2}
    c.  {cmd:nFden(}{it:n_1}{cmd:,}{it:n_2}{cmd:,}{it:lambda}{cmd:,}{it:F}{cmd:)},
	the noncentral F density.

{p 10 14 2}
    d.  {cmd:betaden(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)}, the 2-parameter
	Beta density.

{p 10 14 2}
    e.  {cmd:nbetaden(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:x}{cmd:)},
	the noncentral Beta density.

{p 10 14 2}
    f.  {cmd:gammaden(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:x}{cmd:)},
	the 3-parameter Gamma density.

{p 10 10 2}
    See help {help probfun}.

{p 6 10 2}
5.  The following new cumulative density functions are provided:

{p 10 14 2}
    a.  {cmd:nFtail(}{it:n_1}{cmd:,}{it:n_2}{cmd:,}{it:lambda}{cmd:,}{it:f}{cmd:)},
	the upper-tail of the noncentral F.

{p 10 14 2}
    b.  {cmd:nibeta(}{it:a}{cmd:,}{it:b}{cmd:,}{it:lambda}{cmd:,}{it:x}{cmd:)},
	the cumulative noncentral ibeta probability.

{p 10 10 2}
    See help {help probfun}.

{p 6 10 2}
6.  The following new inverse cumulative density functions are provided:

{p 10 14 2}
    a.  {cmd:invnFtail(}{it:n_1}{cmd:,}{it:n_2}{cmd:,}{it:lambda}{cmd:,}{it:p}{cmd:)},
	the noncentral F corresponding to upper-tail {it:p}.

{p 10 14 2}
    b.  {cmd:invibeta(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)}, the incomplete
	beta value corresponding to {it:p}.

{p 10 14 2}
    c.  {cmd:invnibeta(}{it:a}{cmd:,}{it:b}{cmd:,}{it:lambda}{cmd:,}{it:p}{cmd:)},
	the noncentral beta value corresponding to {it:p}.

{p 10 10 2}
    In addition, existing function
    {cmd:invbinomial(}{it:n}{cmd:,}{it:k}{cmd:,}{it:p}{cmd:)} has improved
    accuracy.  See help {help probfun}.

{p 6 10 2}
7.  A suite of new functions provides partial derivatives of the cumulative
    gamma distribution.  The following new functions are provided:

{p 10 14 2}
    a.  {cmd:dgammapda(}{it:a}{cmd:,}{it:x}{cmd:)}, partial derivative of
	{cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} with respect to {it:a}.

{p 10 14 2}
    b.  {cmd:dgammapdx(}{it:a}{cmd:,}{it:x}{cmd:)}, partial derivative of
	{cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} with respect to {it:x}.

{p 10 14 2}
    c.  {cmd:dgammapdada(}{it:a}{cmd:,}{it:x}{cmd:)}, 2nd partial derivative
	of {cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} with respect to {it:a}.

{p 10 14 2}
    d.  {cmd:dgammapdxdx(}{it:a}{cmd:,}{it:x}{cmd:)}, 2nd partial derivative
	of {cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} with respect to {it:x}.

{p 10 14 2}
    e.  {cmd:dgammapdadx(}{it:a}{cmd:,}{it:x}{cmd:)}, 2nd partial derivative
	of {cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} with respect to {it:a} and
	{it:x}.

{p 10 10 2}
    See help {help probfun}.

{p 6 10 2}
8.  All density and distribution functions have been extended to return
    nonmissing values over the entire real line; see help {help probfun}.

{p 6 10 2}
9.  The following new string functions are provided:

{p 10 14 2}
    a.  {cmd:word(}{it:s}{cmd:,}{it:n}{cmd:)} returns the {it:n}th word in
	{it:s}.

{p 10 14 2}
    b.  {cmd:wordcount(}{it:s}{cmd:)} returns the number of words in {it:s}.

{p 10 14 2}
    c.  {cmd:char(}{it:n}{cmd:)} returns the character corresponding to ASCII
	code {it:n}.

{p 10 14 2}
    d.  {cmd:plural(}{it:n}{cmd:,}{it:s_1}{cmd:)} returns the plural of
	{it:s_1} if {it:n} does not equal 1 or -1, and otherwise returns
	{it:s_1}.

{p 10 14 2}
    e.  {cmd:plural(}{it:n}{cmd:,}{it:s_1}{cmd:,}{it:s_2}{cmd:)} returns the
	plural of {it:s_1} if {it:n} does not equal 1 or -1, forming the
	plural by adding or removing suffix {cmd:s_2}.

{p 10 14 2}
    f.  {cmd:proper(}{it:s}{cmd:)} capitalizes the first letter of a string
	and any other letters immediately following characters that are not
	letters; remaining letters are converted to lowercase.

{p 10 10 2}
See help {help strfun}.

{p 5 10 2}
10.  The following new mathematical functions are provided:

{p 10 14 2}
     a.  {cmd:logit(}{it:x}{cmd:)}, the log of the odds ratio.

{p 10 14 2}
     b.  {cmd:invlogit(}{it:x}{cmd:)}, the inverse logit.

{p 10 14 2}
     c.  {cmd:cloglog(}{it:x}{cmd:)}, the complementary log-log.

{p 10 14 2}
     d.  {cmd:invcloglog(}{it:x}{cmd:)}, the inverse of the complementary
	 log-log.

{p 10 14 2}
     e.  {cmd:tanh(}{it:x}{cmd:)}, the hyperbolic tangent.

{p 10 14 2}
     f.  {cmd:atanh(}{it:x}{cmd:)}, the inverse-hyperbolic tangent of {it:x}.

{p 10 14 2}
     g.  {cmd:floor(}{it:x}{cmd:)}, the integer {it:n} such that
	 {it:n} <= {it:x} < {it:n}+1.

{p 10 14 2}
     h.  {cmd:ceil(}{it:x}{cmd:)}, the integer {it:n} such that
	 {it:n} < {it:x} <= {it:n}+1.

{p 10 10 2}
    In addition, the following existing mathematical functions have been
    modified:

{p 10 14 2}
     i.  {cmd:round(}{it:x}{cmd:,}{it:y}{cmd:)} now allows the second argument
	 be optional and defaults it to 1, so {cmd:round(}{it:x}{cmd:)}
	 returns {it:x} rounded to the closest integer.

{p 10 14 2}
     j.  {cmd:lngamma(}{it:x}{cmd:)} and
	 {cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)} now have improved accuracy.

{p 10 10 2}
See help {help mathfun}.

{p 5 10 2}
11.  Existing function {cmd:uniform()} will now allow you to capture and reset
     its seed.  The seed value, in encrypted form, is now shown by
     {cmd:query}.  You can store its value by typing

{p 14 18 2}
	{cmd:local seed = c(seed)}

{p 10 10 2}
     Later, you can reset it by typing

{p 14 18 2}
	{cmd:. set seed `seed'}

{p 10 10 2}
    See help {help seed} and help {help random}.

{p 5 10 2}
12.  The following new matrix functions are provided:

{p 10 14 2}
     a.  {cmd:issym(}{it:M}{cmd:)} returns 1 if matrix {it:M} is symmetric and
	 returns 0 otherwise; {cmd:issym()} may be used in any context.

{p 10 14 2}
     b.  {cmd:matmissing(}{it:M}{cmd:)} returns 1 if any elements of {it:M}
	 are missing and returns 0 otherwise; {cmd:matmissing()} may be used
	 in any context.

{p 10 14 2}
     c.  {cmd:vec(}{it:M}{cmd:)} returns the column vector formed by listing
	 the elements of {it:M}, starting with the first column and proceeding
	 column by column.

{p 10 14 2}
     d.  {cmd:hadamard(}{it:M}{cmd:,}{it:N}{cmd:)} returns a matrix whose
	 {it:i}, {it:j} element is
	 {it:M}[{it:i},{it:j}] * {it:N}[{it:i},{it:j}].

{p 10 14 2}
     e.  {cmd:matuniform(}{it:r}{cmd:,}{it:c}{cmd:)} returns the {it:r} by
	 {it:c} matrix containing uniformly distributed pseudo-random numbers
	 on the interval [0,1).

{p 10 10 2}
     See help {help matfcns}.

{p 10 10 2}
     In addition, the new command {cmd:matrix} {cmd:eigenvalues} returns the
     complex eigenvalues of an {it:n} by {it:n} nonsymmetric matrix; see help
     {help mateig}.

{p 5 10 2}
13.  The following new programming functions have been added:

{p 10 14 2}
     a.  {cmd:clip(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:)} returns {it:x} if
	 {it:a} <= {it:x} <= {it:b}, {it:a} if {it:x} <= {it:a}, {it:b} if
	 {it:x} >= {it:b}, and {it:missing} if $x$ is missing.

{p 10 14 2}
     b.  {cmd:chop(}{it:x}{cmd:,}{it:epsilon}{cmd:)} returns
	 {cmd:round(}{it:x}{cmd:)} if
	 |{it:x} - {cmd:round(}{it:x}{cmd:)}| < {it:epsilon}, otherwise
	 returns {it:x}.

{p 10 14 2}
     c.  {cmd:irecode(}{it:z}{cmd:,}{it:x_1}{cmd:,}{it:x_2}{cmd:,} ... {cmd:,}{it:x_n}{cmd:)}
	 returns the index of the range in which {it:z} falls.

{p 10 14 2}
     d.  {cmd:maxbyte()}, {cmd:maxint()}, {cmd:maxlong()},
	 {cmd:maxfloat()}, and {cmd:maxdouble()} return the maximum value
	 allowed by the storage type.

{p 10 14 2}
     e.  {cmd:minbyte()}, {cmd:minint()}, {cmd:minlong()},
	 {cmd:minfloat()}, and {cmd:mindouble()} return the minimum value
	 allowed by the storage type.

{p 10 14 2}
     f.  {cmd:epsfloat()} and {cmd:epsdouble()} return the precision
	 associated with the storage type.

{p 10 14 2}
     g.  {cmd:byteorder()} returns 1 if the computer stores numbers in
	 most-significant-byte-first format and 0 if in
	 least-significant-byte-first format.

{p 10 10 2}
     The following programming functions have been modified or extended:

{p 10 14 2}
     h.  {cmd:missing(}{it:x}{cmd:)} now optionally allows multiple arguments
	 so that it becomes
	 {cmd:missing(}{it:x_1}{cmd:,}{it:x_2}{cmd:,} ... {cmd:,}{it:x_n}{cmd:)}.
	 The extended function returns 1 (true) if any of the {it:x_i} are
	 missing and returns 0 (false) otherwise.

{p 10 14 2}
     i.  {cmd:cond(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:)} now optionally
	 allows a fourth argument so that it becomes
	 {cmd:cond(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:,}{it:c}{cmd:)}.
	 {it:c} is returned if {it:x} evaluates to missing.

{p 10 10 2}
See help {help progfun}.


{title:What's new in display formats}

{p 6 10 2}
1.  The {cmd:%g} format has been modified:  {cmd:%}{it:#}{cmd:.0g} still means
    the same as previously, but {cmd:%}{it:#}{cmd:.}{it:#}{cmd:g} has a new
    meaning.  For instance, {cmd:%9.5g} means to show approximately 5
    significant digits.  We say approximately because, given the number
    123,456, {cmd:%9.5g} will show {cmd:123456} rather than {cmd:1.2346e+05},
    as would strictly be required if only five digits are to be shown.  Other
    than that, it does what you would expect, and we think, in all cases, does
    what you want.

{p 6 10 2}
2.  {cmd:%}[{cmd:-}]{cmd:0}{it:#}{cmd:.}{it:#}{cmd:f} formats, note the
    leading {cmd:0}, now specify that leading zeros are to be included in the
    result.  1.2 in {cmd:%09.2f} format is {cmd:000001.20}.

{p 6 10 2}
3.  Stata has a new {cmd:%21x} hexadecimal format that will mainly be of
    interest to numerical analysts.  In {cmd:%21x}, 123,456 looks like
    {cmd:+1.e240000000000X+010}, which you read as the hexadecimal number
    1.e24 multiplied by 2^10.  The period in 1.e24 is the base-16 point.
    The beauty of this format is that it reveals numbers exactly as the
    binary computer thinks of it.  For instance, the new format shows how
    difficult numbers like 0.1 are for binary computers:
    {cmd:+1.999999999999aX-004}.

{p 10 10 2}
    You can use this hexadecimal way of writing numbers in expressions; Stata
    will understand, for instance,

{p 14 18 2}
	{cmd:. generate xover4 = x / 1.0x+2}

{p 10 10 2}
    but it is unlikely you would want to do that.  The notation will even by
    understood by {help input}, {help infix}, and {help infile}.  There is no
    {cmd:%21x} input format, but wherever a number appears, Stata will
    understand {it:#}{cmd:.}{it:##}...{it:#}{cmd:x}[{cmd:+}|{cmd:-}]{it:###}.

{p 4 4 2}
See help {help format}.


{title:What's new in programming}

{p 4 4 2}
Lots of programming improvements have been made; see {hi:What's new} in
{hi:[P] intro}.  Here we will just touch on a few highlights.

{p 6 10 2}
1.  The two big features are the ability to program dialog boxes and the
    addition of class programming; see help {help dialogs} and {help class}.
    Stata's new GUI and new graphics have been programmed using these new
    features.

{p 6 10 2}
2.  The new c-class collects where settings are found.  Type
    {cmd:creturn list} and all will become clear.  Recorded in
    {cmd:c(}{it:settingname}{cmd:)} are all the system settings, so no longer
    do you have to wonder whether the setting is in {cmd:$S_}{it:something},
    obtained as a result of an extended macro function, or found somewhere
    else.  See help {help creturn}.

{p 6 10 2}
3.  Program debugging is now easier thanks to the new {cmd:trace} facilities.

{p 10 14 2}
    a.  Trace output now shows the line with macros expanded as well as
	unexpanded.  This makes spotting errors easier.

{p 10 14 2}
    b.  Separators are drawn and output indented when one program calls
	another, making it easier to see where you are.

{p 10 14 2}
    c.  {cmd:set trace} is now pushed-and-popped, so the original value will
	be restored when a program ends.

{p 10 14 2}
    d.  The new command {cmd:set tracedepth} allows you to specify how deeply
	calls to subroutines should be traced, so you can eliminate unwanted
	output.

{p 10 10 2}
See help {help trace}.

{p 6 10 2}
4.  One change will bite you:  With {cmd:if} {it:exp}, {cmd:while} {it:exp},
    {cmd:forvalues}, and all the other commands that take a brace,
    no longer can the open brace and close brace be on the same line as
    the command.  You may not code

{p 14 18 2}
	{cmd:if (}{it:exp}{cmd:) {c -(}} ... {cmd:{c )-}}

{p 10 10 2}
    You must instead code

	      {cmd:if (}{it:exp}{cmd:) {c -(}}
		      ...
	      {cmd:{c )-}}

{p 10 10 2}
    In the case of {cmd:if}, you may omit the braces altogether:

{p 14 18 2}
	{cmd:if (}{it:exp}{cmd:)} ...

{p 10 10 2}
     Under version control, Stata continues to tolerate the old, all on one
     line syntax, but the new syntax makes Stata considerably faster.
     See help {help ifcmd}.

{p 6 10 2}
5.  Existing commands {cmd:postfile}, {cmd:post}, and {cmd:postclose} will now
    save string variables; see help {help postfile}.

{p 6 10 2}
6.  Do-files and ado-files now allow {cmd://} comments and {cmd:///}
    continuation lines.  {cmd://} on a line says that from here to the end of
    the line is a comment.  {cmd:///} does the same, but also says that the
    next line is to be joined with the current line (and not treated as a
    comment).  See help {help comments}.

{p 6 10 2}
7.  Existing command {cmd:which} will now not only locate {cmd:.ado} files,
    but other system files as well.  You can type, for instance,
    {cmd:which anova.hlp} to discover the location of the help file
    for {cmd:anova}.  See help {help which}.

{p 10 10 2}
    New command {cmd:findfile} will look for any file along the adopath;
    see help {help findfile}.

{p 6 10 2}
8.  The {cmd:sysdir} directory {cmd:STBPLUS} is now called {cmd:PLUS};
    see help {help sysdir}.

{p 6 10 2}
9.  {cmd:net .pkg} files have new features:

{p 10 14 2}
    a.  {cmd:F} {it:filename} is a variation on {cmd:f} {it:filename} that
	specifies the file is to be installed into the system directories,
	even if it ordinarily would not.  This is useful for installing
	{cmd:.dta} datasets that accompany ado-files.

{p 10 14 2}
    b.  {cmd:g} {it:platformname filename} is another variation on {cmd:f}
	{it:filename}.  It specifies that the file is to be installed only if
	the user's computer is of type {it:platformname}.

{p 10 14 2}
    c.  {cmd:G} {it:platformname filename} is variation on {cmd:F}
	{it:filename}.  The file is installed only if the user's computer is
	of type {it:platformname}, and, if it is installed, it is installed in
	the system directories.

{p 10 14 2}
    d.  {cmd:h} {it:filename} asserts that {it:filename} must be loaded or
	else this package cannot be installed.

{p 10 14 2}
    e.  The maximum number of description lines in a {cmd:.pkg} file has been
	increased from 20 to 100.

{p 10 10 2}
See help {help net} and {help usersite}.

{p 4 4 2}
There are lots of new programming features, and the ones we have chosen to
mention may not be of the most interest to you.  Do see {hi:What's new} in
{hi:[P] intro}.


{title:What's new in the user interface}

{p 6 10 2}
1.  The GUI, of course, but we have already mentioned that; see
    {hi:Stata's interface} in Chapter 3 of the
    {hi:{it:Getting Started with Stata}} manual.

{p 6 10 2}
2.  Stata now has tab-name completion.  When typing a command, type
    the first few letters of a variable name and press tab.

{p 6 10 2}
3.  Existing commands {cmd:set} and {cmd:query} have been redone.  {cmd:set}
    now has a {cmd:permanently} option that makes the setting permanent across
    sessions, alleviating the need for creating {cmd:profile.do} files.
    {cmd:query} has a new output format.
    See help {help set} and {help query}.

{p 6 10 2}
4.  There are lots of new {cmd:set} parameters.  Do not even try to dig them
    out of the manual.  Instead, type {cmd:query}.  The new {cmd:query} output
    shows you where you can find out about each and what values you can set.

{p 6 10 2}
5.  Almost all windows now have contextual menus; right-click when you are in
    the window to try them.

{p 6 10 2}
6.  Under Windows and Mac, the following improvements have been made:

{p 10 14 2}
    a.  If an http proxy is needed, Stata will attempt to get the proper
	settings from the operating system; see help {help netio}.

{p 10 14 2}
    b.  You are no longer limited to a maximum of 10 nested do-files.  The
	limit is now 64, the same as Stata for Unix.

{p 6 10 2}
7.  Under Windows, the following improvements have been made:

{p 10 14 2}
    a.  Shortcuts for {cmd:.smcl} files have been added.  By default,
	double-clicking on the shortcut will open the file in the Viewer, and
	right-clicking on the shortcut and choosing {bf:Edit} will open the
	file in the Do-file Editor.

{p 10 14 2}
    b.  Multiple instances of Stata for Windows running at the same time are
	now clearly marked in their title bar with an instance number.

{p 10 14 2}
    c.  You can now set the maximum number of lines recorded in the Review
	window using {cmd:set reventries}; see help {help reventries}.

{p 6 10 2}
8.  Under Mac, the following improvements have been made:

{p 10 14 2}
    a.  Stata is now a native Mach-O application.  It may be launched from a
	terminal with command line options in addition to the usual
	double-clicking on Stata from the Finder.

{p 10 14 2}
    b.  Stata can now change the amount of memory allocated on the fly just as
	Stata can on other operating systems; see help {help memory}.

{p 10 14 2}
    c.  Stata can now pass commands to the operating system for execution; see
	help {help shell}.

{p 10 14 2}
    d.  The filename separator is now forward slash ({cmd:/}) rather than
	colon ({cmd::}) in keeping with changes made by Apple.  For backward
	compatibility, Stata still recognizes a colon ({cmd::}) as a filename
	separator.

{p 10 14 2}
    e.  You can now open more than one file simultaneously in the Do-file
	Editor.

{p 10 14 2}
    f.  Stata honors and sets file permissions when creating files.

{p 10 14 2}
    g.  Stata now uses {cmd:/tmp} for its temporary files.

{p 10 14 2}
    h.  You can now select all the contents of the Results or Viewer
	windows by selecting {bf:Select All} from the {bf:Edit} menu.

{p 10 14 2}
    i.  There is a new menu item, {bf:Bring All to Front}, in the Window menu
	that brings all Stata windows to the front.

{p 6 10 2}
9.  Stata for Unix now looks for the environment variable {cmd:STATATMP} in
    addition to the environment variable {cmd:TMPDIR} for the location of the
    directory where temporary files are stored.  {cmd:STATATMP} takes
    precedence over {cmd:TMPDIR}.


{title:What's more}

{p 4 4 2}
We have not listed all the changes, but we have listed the important ones.
The remaining changes -- a list of about equal length as the one above -- are
all implications of what has been listed.

{p 4 4 2}
What is important to know is that Stata is continually being updated and those
updates are available for free over the Internet.  All you have to do is type

{p 8 12 2}
	{cmd:. update query}

{p 4 4 2}
and follow the instructions.
(Or just {update "from http://www.stata.com":click here} to update).

{p 4 4 2}
We hope you enjoy Stata 8.


{hline 3} {hi:previous updates} {hline}

{pstd}
See {help whatsnew7}.{p_end}

{hline}
