{smcl}
{* *! version 1.4.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 10}

{pstd}
This file records the additions and fixes made to Stata during the 10.0
and 10.1 releases:

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
    {c |} {bf:this file}        Stata 10.0 and 10.1          2007 to 2009    {c |}
    {c |} {help whatsnew9to10}    Stata 10.0 new release       2007            {c |}
    {c |} {help whatsnew9}        Stata  9.0, 9.1, and 9.2     2005 to 2007    {c |}
    {c |} {help whatsnew8to9}     Stata  9.0 new release       2005            {c |}
    {c |} {help whatsnew8}        Stata  8.0, 8.1, and 8.2     2003 to 2005    {c |}
    {c |} {help whatsnew7to8}     Stata  8.0 new release       2003            {c |}
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 8} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew10to11}.


{hline 8} {hi:update 10jun2010} {hline}

    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
1.  In rare circumstances, accessing the Internet from within Stata could
    cause Stata to crash.  This has been fixed.


    {title:Stata executable, Mac (64-bit)}

{p 5 9 2}
{* fix}
2.  Graphs exported from the 64-bit version of Stata for Mac to a bitmap
    format, such as TIFF, would not be exported to a user-specified size when
    Stata was run in Snow Leopard (Mac OS X 10.6).  This has been fixed.


    {title:Stata executable, Ubuntu Linux}

{p 5 9 2}
{* fix}
3.  In release 10.04 of the Ubuntu distribution of Linux, the data in Stata's
    memory could become corrupt.  This was caused by a change in the behavior
    of a low-level call in an operating system library in the Ubuntu
    distribution of Linux and so was restricted only to the Ubuntu 10.04
    distribution of Linux.  This has been fixed.


{hline 8} {hi:update 20jan2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb svy:svy: regress}, when fitting a model with duplicate {indepvars},
    reported the coefficient and standard error of the first element occurring
    in {cmd:e(b)} for all of its duplicates in the coefficient table.  This
    misrepresented the actual fitted coefficients in {cmd:e(b)} because
    typically all but one of the coefficients should have been reported as
    "(dropped)".  This has been fixed.


{hline 8} {hi:update 01oct2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb stci}, when used with prefix {cmd:by}, option {opt by()},
    {cmd:if}, or {cmd:in}, produced correct confidence intervals but reported
    standard errors that were based on a survivor-function estimate that did
    not restrict the sample.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb sunflower} with option {opt addplot()} would only render the
    plots in option {opt addplot()}.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
3.  Function {helpb colnumb()} failed to match an equation specification on
    columns containing time-series operators.  This has been fixed.

{p 5 9 2}
{* fix}
4.  Stata's old programmable dialog system was mistakenly disabled in the
    18aug2009 update.  This functionality has been restored.


    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
5.  Applying the "Factory Settings" with some very specific
    windowing arrangements could crash Stata.  This has been fixed.


    {title:Stata executable, 64-bit Mac}

{p 5 9 2}
{* fix}
6.  The 18aug2009 update introduced a bug in the Graph Editor where changing a
    selection in a pulldown menu of the graph toolbar would have no effect on
    the graph being edited.  This has been fixed.


{hline 8} {hi:update 04sep2009} {hline}

    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
1.  Changes in Mac OS X 10.6 (Snow Leopard) caused shell commands executed
    from Stata to crash.  Stata now accommodates these changes in Snow Leopard
    when executing shell commands while maintaining compatibility with earlier
    versions of Mac OS X.


    {title:Stata executable, 64-bit Mac}

{p 5 9 2}
{* fix}
2.  {helpb sts graph} displayed a black background in the legend if the region
    color was set to white.  This has been fixed.


{hline 8} {hi:update 18aug2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 9(2).

{p 5 9 2}
{* fix}
2.  Previously, {helpb arch}, when used with option {opt het()}, did not
    display the slope coefficients of the heteroskedasticity equation if the
    model did not include any ARCH terms, though the coefficients were stored
    in the coefficient vector {cmd:e(b)}.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb areg}, in rare cases, would report a nonzero coefficient and a very
    large standard error for a variable that had no within-group variance
    instead of dropping the variable.  This has been fixed.

{marker n4_18aug2009}{...}
{p 5 9 2}
{* fix}
4.  {helpb areg}, when used with models with very few observations per level
    of the absorbed category, would occasionally exit with an error message
    claiming insufficient observations even though the model was estimable.
    This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb areg} reported an incorrect F test of the joint significance of the
    absorbed indicators when a regressor was perfectly correlated with them.
    This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb biprobit} with option {cmd:vce(robust)} or
    {helpb vce_option:vce(cluster {it:clustvar})} reported a likelihood-ratio
    test for rho instead of a Wald test for rho.  Also, log likelihoods
    were reported in the iteration log instead of log pseudolikelihoods.  This
    has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb blogit} and {helpb bprobit}, when the number of positive responses
    was larger than the total population, returned an error message.
    Observations that have a number of positive responses that is larger than
    the total population are now dropped from the analysis.

{p 5 9 2}
{* fix}
8.  {helpb egen} function {cmd:mode()} with option {cmd:missing} and a
    variable containing all missing values incorrectly reported a warning
    message that multiple modes were present.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb estat classification}, when used after an estimation command with
    {cmd:iweight}s, would treat the {cmd:iweight}s as {cmd:fweight}s if they
    were integer valued or would report an error message if they were not
    integers.  {cmd:estat classification} now provides an appropriate error
    message any time {cmd:iweight}s are used in the estimation.

{p 4 9 2}
{* fix}
10.  {helpb ivregress_postestimation##estatoverid:estat overid}, when used
     after {helpb ivregress gmm}, would exit with an error if the model
     included regressors with time-series operators.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb estat summarize} after {helpb arch} and {helpb arima} would appear
     to freeze Stata and eventually exit with an error if the previous model
     did not contain any ARCH or ARIMA terms.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb glm} option {cmd:vce(unbiased)} could not be combined with
     {cmd:vce(cluster} {it:clustvar}{cmd:)} or with {cmd:vce(robust)}.  They
     may now be combined (for example, {cmd:vce(unbiased) vce(robust)}).

{p 4 9 2}
{* fix}
13.  When option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} was specified with
     {helpb heckprob} or the maximum-likelihood version of {helpb heckman},
     the test for rho = 0 at the bottom of the output was labeled as a Wald
     test but was actually a likelihood-ratio test.  This has been fixed so
     that a Wald test is really performed.  When option {cmd:vce(robust)} or
     {cmd:vce(cluster} {it:clustvar}{cmd:)} was specified with these
     commands, a log likelihood was reported in the iteration log.  This has
     been changed to a log pseudolikelihood.

{p 4 9 2}
{* fix}
14.  {helpb hetprob} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} reported a likelihood-ratio
     test for lnsigma2 = 0.  Likelihood-ratio statistics are not valid with
     robust VCEs.  Therefore, this test is no longer reported.

{marker n15_18aug2009}{...}
{p 4 9 2}
{* fix}
15.  {helpb ivregress}, when used with regressors that differed by many orders
     of magnitude, could report erroneous results or drop regressors.  Now
     {cmd:ivregress} is more tolerant of poorly scaled data.

{p 4 9 2}
{* fix}
16.  {helpb lrtest}, when used after {helpb xtmixed}, {helpb xtmelogit}, or
     {helpb xtmepoisson}, detects differences in the number of estimated
     random-effects variances between nested mixed models.  Previously, if a
     difference was detected, {cmd:lrtest} assumed that this was a result of
     testing the null hypothesis that the variances in question were equal to
     zero, that is, that the null hypothesis was on the boundary of the
     parameter space.  When this occurred, if the difference in model degrees
     of freedom was equal to one, then the p-value was divided by two and
     reported as {help j_chibar:chibar2(01)}.  If the difference in model
     degrees of freedom exceeded one, then a note was placed in the output
     stating that the p-value was a conservative estimate.  Such behavior was
     correct most of the time, but not always.

{p 9 9 2}
     Sometimes nested mixed models differ in the number of variances estimated
     even when not testing on a boundary, for example, when testing whether
     two variances are equal.  In such situations, {cmd:lrtest} either
     reported a {help j_chibar:chibar2(01)} p-value that was anticonservative
     or erroneously declared the p-value as a conservative estimate when, in
     fact, the p-value was precise.

{p 9 9 2}
     Rather than assume all tests are on the boundary or try to infer the null
     hypothesis from the estimation results, {cmd:lrtest} now prints a note
     stating when the possibility of a boundary test exists and leaves it up
     to the user to determine whether this is the case.  The new behavior is
     guaranteed to be either conservative or precise, but never
     anticonservative.

{p 4 9 2}
{* fix}
17.  {helpb nbreg} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} reported a likelihood-ratio
     test for alpha = 0.  Likelihood-ratio statistics are not valid with
     robust VCEs.  Therefore, this test is no longer reported.

{p 4 9 2}
{* fix}
18.  The {helpb nlogit} coefficient table did not display coefficients for
     continuous variables associated with the base alternatives.  This has
     been fixed.

{marker n19_18aug2009}{...}
{p 4 9 2}
{* fix}
19.  {helpb arch_postestimation##predict:predict, variance} after {helpb arch}
     would sometimes exit with an error message if the model was fit with
     constraints.  This has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb areg_postestimation##predict:predict, xbd} and
     {helpb areg_postestimation##predict:predict, d} after {helpb areg}
     changed the sort order of the data.  This has been fixed.

{p 4 9 2}
{* fix}
21.  {helpb arima_postestimation##predict:predict} with option {opt stdp}
     would exit with an obscure error message after {helpb arima} if the model
     did not contain any regressors or a constant term.  Now a more
     descriptive error message is issued.

{p 4 9 2}
{* fix}
22.  The predicted inclusive values,
     {helpb nlogit_postestimation##predict:predict, iv}, after fitting the RUM
     consistent nested logit model, that is, {helpb nlogit} without option
     {cmd:nonnormalized}, were incorrect.  This has been fixed.

{p 4 9 2}
{* fix}
23.  {helpb streg_postestimation##predict:predict} after {helpb streg} with
     option {cmd:frailty()} sometimes ignored options {cmd:alpha1} and
     {cmd:unconditional} when used to predict quantities accumulated over
     multiple-record data, such as cumulative martingale residuals (option
     {cmd:cmgale}) and cumulative survival probabilities (option {cmd:csurv}).
     This has been fixed.

{p 4 9 2}
{* fix}
24.  {helpb scobit} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} reported a likelihood-ratio
     test for alpha = 1.  Likelihood-ratio statistics are not valid with
     robust VCEs.  Therefore, this test is no longer reported.

{marker n25_18aug2009}{...}
{p 4 9 2}
{* fix}
25.  {helpb sts graph} would not honor suboption {cmd:cols()} of
     {cmd:legend()} when specified with options {cmd:ci} and {cmd:by()}.  This
     has been fixed.

{marker n26_18aug2009}{...}
{p 4 9 2}
{* fix}
26.  {helpb suest} with {helpb mlogit} results that contained a period in an
     equation name would report the "operator invalid" error.  This has been
     fixed.  Now {cmd:suest} converts periods to commas.

{p 4 9 2}
{* fix}
27.  {helpb suest} with data that were {helpb svyset} would report an error
     message if any of the {cmd:svyset} variables was not found, even when
     option {opt svy} was not specified and none of the estimation results
     was from prefix {helpb svy}.  This has been fixed.

{p 4 9 2}
{* fix}
28.  Undocumented command {helpb svygen:svygen jackknife} produced an
     error message if options {cmd:poststrata()} and {cmd:postweight()}
     were specified.  This has been fixed.

{p 4 9 2}
{* fix}
29.  {helpb treatreg}, when used with option {opt constraints()}, did not
     properly apply the constraints when computing the likelihood-ratio test
     of independent equations, resulting in an invalid test statistic.  Now
     {cmd:treatreg} reports a Wald test of independence when constraints are
     applied.

{marker n30_18aug2009}{...}
{p 4 9 2}
{* fix}
30.  {helpb xthtaylor}, in rare cases, would declare a variable to be
     time-invariant even though it was time varying.  This has been fixed.

{p 4 9 2}
{* fix}
31.  {helpb xtreg:xtreg, fe} now reports a missing F statistic for the overall
     model test when the VCE is less than full rank.  The reported degrees of
     freedom corresponds to the maximum number of coefficients that could be
     simultaneously tested.

{p 4 9 2}
{* fix}
32.  {helpb xtreg:xtreg, pa} with option {opt corr()} and {helpb xtgee} with
     option {opt corr()}, when there were more time periods than could be
     handled by {cmd:tabulate}, returned an error message.  This has been
     fixed.

{p 4 9 2}
{* fix}
33.  {helpb xtreg:xtreg, re} and {helpb xtgee} now report a missing Wald
     chi-squared statistic for the overall model test when the VCE is less
     than full rank.  The reported degrees of freedom corresponds to the
     maximum number of coefficients that could be simultaneously tested.

{p 4 9 2}
{* fix}
34.  {helpb xtreg:xtreg, re} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})}, when the dataset had
     balanced panels, reported an incorrect F statistic.  This has been fixed.

{p 4 9 2}
{* fix}
35.  {helpb zinb} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} would report a Vuong test
     or likelihood-ratio test of alpha = 0 if option {cmd:vuong} or {cmd:zip}
     was also specified.  Likelihood-ratio statistics and Vuong tests are not
     valid with robust VCEs.  Therefore, these tests are no longer reported.

{p 4 9 2}
{* fix}
36.  {helpb zip} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} would report a Vuong test
     if option {cmd:vuong} was also specified.  The Vuong test is not valid
     with robust VCEs.  Therefore, this test is no longer reported.

{p 4 9 2}
{* fix}
37.  {helpb ztnb} with option {cmd:vce(robust)} or
     {helpb vce_option:vce(cluster {it:clustvar})} reported a likelihood-ratio
     test for alpha = 0.  Likelihood-ratio statistics are not valid with
     robust VCEs.  Therefore, this test is no longer reported.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
38.  Printing a selection that included the very last line of the Results or
     Viewer windows caused Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
39.  The Review window would show the incorrect return code for
     {help comments} that were typed interactively following an error
     message.  This has been fixed.

{p 4 9 2}
{* fix}
40.  Mata nonuniform {help mf_rnormal:random-number generators}, when
     {help mf_st_view:views} were used for the parameter matrices, would crash
     Stata.  This has been fixed.

{p 4 9 2}
{* fix}
41.  Mata probability functions {helpb mf_binomialp:binomialp()},
     {bf:hypergeometricp()}, {bf:nbinomialp()}, and {bf:poissonp()}, when
     {help mf_st_view:views} were used for the parameter matrices, would crash
     Stata.  This has been fixed.

{p 4 9 2}
{* fix}
42.  Mata functions {helpb mf_findexternal:findexternal()},
     {helpb mf_valofexternal:valofexternal()},
     {helpb mf_crexternal:crexternal()}, and
     {helpb mf_rmexternal:rmexternal()} would allow names containing blanks if
     the name was otherwise valid.  This has been fixed.

{marker n43_18aug2009}{...}
{p 4 9 2}
{* fix}
43.  Mata function {helpb mf_dir:dir()} could crash Stata when the results
     were more than 10,000 items.  This has been fixed.

{p 4 9 2}
{* fix}
44.  Mata probability distribution functions
     {helpb mf_hypergeometric:hypergeometric()}, {bf:nbinomial()}, and
     {bf:poisson()}, when {help mf_st_view:views} were used for the parameter
     matrices, would crash Stata.  This has been fixed.

{p 4 9 2}
{* fix}
45.  Mata function {helpb mf_st_addvar:st_addvar()} would add a variable to
     the Stata dataset even when the variable name contained blanks but was
     otherwise valid.  This has been fixed.

{p 4 9 2}
{* fix}
46.  Mata function {helpb mf_st_isname:st_isname()}, when the name being
     checked contained blanks but was otherwise valid, returned valid (1).
     This has been fixed.

{p 4 9 2}
{* fix}
47.  Mata function {helpb mf_st_varrename:st_varrename()} would rename a
     variable to a name containing blanks if the name was otherwise valid.
     This has been fixed.

{p 4 9 2}
{* fix}
48.  {helpb svy}{cmd::} {helpb mean}, {helpb svy}{cmd::} {helpb proportion},
     {helpb svy}{cmd::} {helpb ratio}, and {helpb svy}{cmd::} {helpb total}
     would mark out observations with missing values in the summary variables
     even when the sampling weight was zero, which is a surrogate for
     identifying out-of-subpopulation observations.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
49.  {helpb edit} or {helpb browse} with an {cmd:if} expression that included
     all observations in the dataset sometimes caused the vertical scrollbar
     to not display or to scroll incorrectly.  This has been fixed.

{p 4 9 2}
{* fix}
50.  In the Data Editor, if the operating system failed to complete a
     Clipboard copy, a memory leak could occur.  This has been fixed.

{p 4 9 2}
{* fix}
51.  {helpb set linesize}, when the scrollbar automatically appeared in the
     Results window, could be overwritten.  This has been fixed.

{p 4 9 2}
{* fix}
52.  {helpb window manage associate} would fail to restore file associations
     under Windows Vista if Stata was not started with administrator access.
     This has been fixed.

{p 4 9 2}
{* fix}
53.  In some circumstances, the Results window did not initialize the linesize
     correctly when maximized inside Stata's main window.  This has been
     fixed.

{p 4 9 2}
{* fix}
54.  The Review and Variables windows did not save and restore their font
     settings with saved preferences.  This has been fixed.

{p 4 9 2}
{* fix}
55.  The Review window could show error codes next to the wrong command if the
     Review window was initially closed when Stata was first opened.  This has
     been fixed.

{p 4 9 2}
{* fix}
56.  "Compact Window Settings" did not autohide the Review and Variables
     windows and did not correctly size Stata's main window.  This has been
     fixed.

{p 4 9 2}
{* fix}
57.  In the Graph Editor, copying a graph to the Clipboard could cause
     selecting a graph object to work incorrectly.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
58.  In the Graph Editor, copying a graph to the Clipboard could cause
     selecting a graph object to work incorrectly.  This has been fixed.

{marker n59_18aug2009}{...}
{p 4 9 2}
{* fix}
59.  After changing the aspect ratio of a graph from the Graph Editor, the
     graph window would not automatically resize to the new aspect ratio.
     This has been fixed.


    {title:Stata executable, 64-bit Mac}

{p 4 9 2}
{* fix}
60.  Depending on the number of lines displayed in the Results window,
     {cmd:--more--} could still appear in the Results window even after the
     more condition had been cleared.  This has been fixed.

{p 4 9 2}
{* fix}
61.  The {helpb window fopen} and {helpb window fsave} commands are now
     supported.

{p 4 9 2}
{* fix}
62.  {bf:File > Insert File...} will now insert files in the Do-file Editor.

{p 4 9 2}
{* fix}
63.  Stata is now brought to the front when launched from the command line.

{p 4 9 2}
{* fix}
64.  If the Data Editor was started with an {cmd:if} condition and the Delete
     dialog was opened more than once, Stata could crash.  This has been
     fixed.

{marker n65_18aug2009}{...}
{p 4 9 2}
{* fix}
65.  How Stata redraws the graph window after the window has been resized has
     been modified to accommodate changes to Mac OS X 10.6 (Snow Leopard).
     This modification is also compatible with Mac OS X 10.5 (Leopard).

{marker n66_18aug2009}{...}
{p 4 9 2}
{* fix}
66.  From the Graph Editor, adding a marker and then changing the property of
     the newly added marker could cause Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
67.  The Graph Editor caused Stata to crash if the image lock16.png was not
     found in Stata's ado-path or was corrupt.  Although the missing/corrupted
     image suggests that Stata's ado directory has been corrupted and requires
     Stata to be reinstalled, Stata will now ignore the missing icon to avoid
     crashing.

{p 4 9 2}
{* fix}
68.  The current graph scheme was not being saved in Stata's preferences.
     This has been fixed.

{marker n69_18aug2009}{...}
{p 4 9 2}
{* fix}
69.  The Do-file Editor now automatically adds an end-of-line delimiter at the
     end of a do-file if one does not already exist.  Stata requires that an
     end-of-line delimiter exist on all lines in a do-file that are to be
     executed.

{p 4 9 2}
{* fix}
70.  Stata did not convert filenames with Unicode characters from an Open or
     Save dialog to a filename with the correct file system representation.
     In some cases, this would result in "file not found" errors.  This has
     been fixed.


    {title:Stata executable, Unix GUI}

{p 4 9 2}
{* fix}
71.  {helpb edit} or {helpb browse} with an {cmd:if} expression that included
     all observations in the dataset sometimes caused the vertical scrollbar
     to not display or to scroll incorrectly.  This has been fixed.

{p 4 9 2}
{* fix}
72.  The Command window had a vertical scrollbar that was only
     displayed when needed.  Resizing the Command window so that it was
     shorter than the height needed to display the entire vertical scrollbar
     caused the Command window to grow in height to the minimum height
     necessary to display the vertical scrollbar the next time Stata was
     launched.  This in turn also caused Stata's main window to grow.  Because
     of the resizing problem and the limited usefulness of the vertical
     scrollbar, the Command window will now no longer display a vertical
     scrollbar.

{p 4 9 2}
{* fix}
73.  Selecting {bf:File > Open} from a Do-file Editor window that
     had an open do-file displayed the Open dialog with no current folder.
     This has been fixed so that the Open dialog defaults to the directory of
     the currently opened do-file.


{hline 8} {hi:update 16apr2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb stcox_postestimation##estatcon:estat concordance}, when used after
    {cmd:stcox} with the {opt strata()} option, did not take into account the
    stratification structure of the data. Thus, support for this feature
    has been temporarily disabled until a statistically appropriate solution
    can be implemented.

{p 5 9 2}
{* fix}
2.  {helpb stcox_postestimation##estatcon:estat concordance} changed the sort
    order of the current dataset.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb fracpoly} and {helpb mfp}, when used with {helpb mlogit}, assigned
    incorrect model degrees of freedom.  The model degrees of freedom were too
    small, resulting in smaller p-values.  This has been fixed.


    {title:Stata executable, Mac (32- and 64-bit)}

{p 5 9 2}
{* fix}
4.  {helpb edit} or {helpb browse} with an {cmd:if} expression that included
    all observations in the dataset sometimes caused the vertical scrollbar to
    not display or scroll correctly.  This has been fixed.


    {title:Stata executable, Mac (32-bit)}

{p 5 9 2}
{* fix}
5.  Graphs saved as a PDF sometimes had extra white space above the top of the
    actual graph image in the PDF file.  This has been fixed.


    {title:Stata executable, Mac (64-bit)}

{p 5 9 2}
{* enhancement}
6.  You can now sort the columns in the Review window.  You can now drag and
    drop selected commands from the Review window to a destination that
    accepts text.  You can also drag and drop selected variables from the
    Variables window to a destination that accepts text.

{p 5 9 2}
{* enhancement}
7.  Entering {cmd:doedit filename.do} from the command line when
    {cmd:filename.do} does not exist creates a new Do-file Editor document and
    sets the filename for the document.  Although the document does not exist
    on disk yet, selecting {bf:File > Save...} for the first time for the new
    document will save the document to disk without prompting for a filename.

{p 5 9 2}
{* enhancement}
8.  Programmable menu support (see {helpb window menu}) is now available.

{p 5 9 2}
{* fix}
9.  The graph {bf:Save As} dialog now uses the current graph filename as the
    default filename.

{p 4 9 2}
{* fix}
10.  The plot type listbox would not show all plot types in some situations.
     This has been fixed.

{p 4 9 2}
{* fix}
11.  If Stata's main toolbar window was moved to an external display and the
     external display was not available the next time Stata was started, then
     the window did not appear on the primary display.  This has been fixed.
     Stata now allows the main toolbar window to be dragged above the menu bar
     if an external display is arranged above the primary display.

{p 4 9 2}
{* fix}
12.  Opening the Data Editor with an {cmd:if} condition that returned no
     observations (for example, {cmd:edit if foreign==.} when {cmd:foreign} had
     no missing values) caused Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
13.  The font preference for the Viewer window would not be permanently saved
     until Stata had exited.  This caused new Viewer windows during the same
     session to not use the new font preference.  This has been fixed.

{p 4 9 2}
{* fix}
14.  Stata did not adjust for the font leading when drawing text in graphs.
     This would cause text to appear slightly lower than what was intended.
     This has been fixed.

{p 4 9 2}
{* fix}
15.  Stata would not save a TIFF graph.  This has been fixed.


{hline 8} {hi:update 17mar2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 9(1).

{p 5 9 2}
{* enhancement}
2.  {helpb fracpoly} and {helpb mfp} have been updated to support {cmd:stpm2}
    (Royston and Lambert, forthcoming, {it:Stata} {it:Journal}), an improved
    version of user-written command {cmd:stpm}.

{p 5 9 2}
{* fix}
3.  {helpb graph} with option {cmd:by(}{it:varlist}{cmd:)} failed if
    {it:varlist} was just one {it:varname} and any of the levels of
    {it:varname} were either a blank string or an empty label.  This has been
    fixed.

{p 5 9 2}
{* fix}
4.  {helpb stsplit} would, on rare occasions, order survival times incorrectly
    as the result of a precision bug.  This occurred when your default type
    was not {cmd:double} and you used {cmd:stsplit} to split records over
    failure times that differed by less than float precision.  This has been
    fixed.

{p 5 9 2}
{* fix}
5.  {helpb sureg} with option {opt isure} could not replay its own estimation
    results.  This has been fixed.


{hline 8} {hi:update 06mar2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb suest} did not allow default options {cmd:robust} or
    {cmd:vce(robust)} to be specified.  This has been fixed.


    {title:Stata executable, Mac (64-bit)}

{p 5 9 2}
{* fix}
2.  The {cmd:Window} > {cmd:Do-file Editor} menu did not display a list of the
    currently open Do-file Editor windows.  This has been fixed.

{p 5 9 2}
{* fix}
3.  The vertical scrollbar in the Do-file Editor would always move to the top
    of the document after a new line was entered.  This has been fixed.

{p 5 9 2}
{* fix}
4.  Using command {helpb translate} to convert a SMCL file from disk to PDF
    format would print the file instead.  This has been fixed.

{p 5 9 2}
{* fix}
5.  The Open button on the main toolbar would display only the most recently
    opened files.  It now displays the Open dialog when clicked.  Clicking and
    holding the left mouse button on the Open button is required to display
    the Open Recents menu.  The Save button on the main toolbar now displays
    the Save As dialog when there are data in memory.

{p 5 9 2}
{* fix}
6.  When running or doing an unsaved do-file from the Do-file Editor and
    autosave is enabled, you may be presented with the warning "This
    document's file has been changed by another application since you opened
    or saved it" when the do-file is saved or run.  This has been fixed and
    you should no longer see the warning.

{p 5 9 2}
{* fix}
7.  Some lines in graphs would not be drawn with the correct thickness.  This
    has been fixed.


{hline 8} {hi:update 26feb2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb alpha}, an r-class command, cleared all results stored in
    {cmd:e()}.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb alpha} returned a "no observations" error when the sense could not
    be determined empirically.  An error is now given suggesting that option
    {cmd:asis} be specified.

{p 5 9 2}
{* fix}
3.  {helpb anova_postestimation##test:test} after {helpb anova} did not allow
    options {cmd:test()} and {cmd:matvlc()} to be specified together.  This
    has been fixed.


    {title:Stata executable, Mac (32-bit)}

{p 5 9 2}
{* fix}
4.  In the previous update, Stata changed its behavior from copying graphs to
    the Clipboard in either the PDF or PICT format to copying graphs in
    multiple graphic formats, including PDF, TIFF, and PICT.  This allows both
    modern and legacy applications to paste graphs from Stata in a format the
    applications prefer.  However, Microsoft Office 2004 does not support
    multiple graphic formats in the Clipboard.  Stata has reintroduced the
    "Copy images to the Clipboard only as PICT" option in the General
    Preferences dialog to copy graphs to the Clipboard only in the PICT
    format.

{p 5 9 2}
{* fix}
5.  The Variables window scrollbar no longer moves to the beginning of the
    variables list when variables are added.


    {title:Stata executable, Mac (64-bit)}

{p 5 9 2}
{* fix}
6.  You can now drag and drop Stata graphs to the Desktop and to applications
    that support the PDF or TIFF format.

{p 5 9 2}
{* fix}
7.  Clicking on a variable name or an observation number in the Data Editor
    did not select a variable's column or observation's row, respectively.
    This has been fixed.

{p 5 9 2}
{* fix}
8.  Double-clicking on a Stata file did not automatically change the current
    working directory within Stata.  This has been fixed.

{p 5 9 2}
{* fix}
9.  Stata required a restart after its Internet proxy settings were changed
    before they would take effect.  Stata's Internet proxy settings now take
    effect immediately after they have been changed.

{p 4 9 2}
{* fix}
10.  The Viewer would not use the color scheme preference from a previous
     session.  This has been fixed.


{hline 8} {hi:update 02feb2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  The dialog box for creating display formats contained a sample for weekly
    formats that was invalid.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb mkspline}, when used to produce linear splines with equally spaced
    knots, could create spline variables containing all 0s if the knots could
    not be uniquely identified when formatted as {cmd:%9.0g}.  This has been
    fixed.

{p 5 9 2}
{* fix}
3.  {helpb sktest} previously used casewise deletion.  It now uses
    variablewise deletion.

{p 5 9 2}
{* fix}
4.  The dialog box for {helpb xtdpdsys} did not allow options {cmd:twostep}
    and {cmd:vce(robust)} to be specified together.  This has been
    fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
5.  {helpb describe}'s {cmd:varlist} option, when the data were not sorted,
    reported the entire varlist, or the given varlist if specified, in
    {cmd:r(sortlist)}.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb estimates use} misread {helpb logistic}, {helpb logit}, and
    {helpb probit} estimation results that identified multiple perfect
    predictors, variables dropped because of collinearity, or both, possibly
    resulting in Stata crashing.  This has been fixed.

{p 5 9 2}
{* fix}
7.  The estimation algorithm for {helpb exlogistic} has been improved to use
    relative frequencies.  This means that it can successfully fit models with
    larger datasets and higher frequencies of enumerated sufficient statistics.
    The error message has also been improved when the datasets or sufficient
    statistics are too large.

{p 5 9 2}
{* fix}
8.  {helpb exlogistic} with one or more independent variables collinear with
    the dependent variable terminated with an error message.  A check for
    collinearity is unnecessary and has been removed.

{p 5 9 2}
{* fix}
9.  Mata's {helpb mata rename} did not check whether the new matrix name was
    valid.  This has been fixed.

{p 4 9 2}
{* fix}
10.  Mata's {helpb mf_st_local:st_local()} function, after reading a string
     from a binary file, would sometimes return a string with garbage values
     appended to the end of the original string.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb matrix accum} without option {opt noconstant} and with one less
     variable than the current value of {cmd:c(matsize)} caused Stata to
     crash.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb odbc insert} with option {opt create} would issue an error
     message when inserting data stored as a double into Excel.  This has been
     fixed.

{p 4 9 2}
{* enhancement}
13.  {helpb odbc query} now has two new options, {opt verbose} and
     {opt schema}.  {opt verbose} lists any data source alias, nickname,
     typed table, typed view, and view along with tables so that you can load
     data from these table types.  {opt schema} lists schema names with
     the table names if the data source returns schema information.

{p 4 9 2}
{* fix}
14.  {helpb predict} with {helpb matsize} set smaller than required for the
     current estimation results caused Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb syntax} incorrectly parsed wildcard ({cmd:*}) options when
     arguments contained unbalanced parentheses enclosed in double quotes;
     {cmd:syntax} parsed them correctly when enclosed in compound double
     quotes.  It now works correctly in both cases.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
16.  The {help doedit:Do-file Editor}, while the {help edit:Data Editor}
     was open, did not redraw correctly.  This has been fixed.

{p 4 9 2}
{* fix}
17.  Printing a do-file by selecting {hi:File} > {hi:Print} from the main Stata
     window crashed Stata.  This has been fixed.

{p 4 9 2}
{* fix}
18.  The drop-down list in the Graph window's "Save as" dialog box did not
     correctly change the file extension, for example, from {cmd:*.gph}
     to {cmd:*.emf}.  This has been fixed.

{p 4 9 2}
{* fix}
19.  On the Graph window, the toolbar did not remember customizations between
     sessions.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
20.  Stata now includes both PDF data and PICT data when copying Stata graphs
     or Stata output to the Clipboard.  This will allow applications that do
     not support PDF data to still paste data from the Clipboard
     in the PICT format.  As a consequence of this change, the "Copy
     images to the Clipboard as PICT" setting is no longer necessary and has
     been removed.

{p 4 9 2}
{* fix}
21.  Stata now uses the default end-of-line delimiter preference when copying
     text to the Clipboard from the Results, Viewer, and Data Editor windows.
     This is necessary for applications such as OpenOffice that only support
     the Unix end-of-line delimiter in text pasted from the Clipboard.

{p 4 9 2}
{* fix}
22.  Stata previously used the incorrect uniform type identifier (UTI)
     description of "ASP Code file" for the different text files it supports
     such as {cmd:.do} and {cmd:.ado}.  The mislabeled description did not
     affect the functionality of the text files.  Stata now uses a unique UTI
     for each text file it supports, for example, "Stata Do-file" for
     do-files and "Stata Ado-file" for ado-files.  This is useful for
     distinguishing between Stata's different text files in applications such
     as a Spotlight search.  The additional UTIs may require rebuilding the
     LaunchServices database on your Mac before the changes become visible, but
     it is not urgent.  Please contact technical support if you require further
     assistance in rebuilding the database.

{p 4 9 2}
{* fix}
23.  The Variable window's scrollbar would not reset its position when data
     were cleared or when new data were used.  This has been fixed.

{p 4 9 2}
{* fix}
24.  Stata would not open a file in a web browser when using the
     {help smcl:SMCL} directive {cmd:browse}.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
25.  For some Unix platforms, such as the Solaris Sparc, printing the Results
     window by using the "Print" dialog box caused Stata to crash.  This has
     been fixed.


{hline 8} {hi:update 06jan2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 8(4).

{p 5 9 2}
{* enhancement}
2.  Stata's {cmd:%tC} {help datetime_display_formats:date-and-time format}
    now includes a {help datetime_translation##leapsecs:leap second} following
    31dec2008 23:59:59, namely, 31dec2008 23:59:60, as recently specified by
    the International Earth Rotation and Reference Systems Service (IERS).
    The update will not take effect until Stata is restarted after the update
    is installed.

{p 5 9 2}
{* fix}
3.  {helpb collapse} with small {cmd:aweight}s occasionally produced incorrect
    percentile values.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb egen} function {cmd:group()} with the {cmd:label()} option failed
    if a value label contained double quotes.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb estat bootstrap}, when used with certain estimation commands
    and when the expression list was something other than {cmd:_b},
    sometimes incorrectly reported "estimation results not found".  This has
    been fixed.

{p 5 9 2}
{* fix}
6.  {helpb logistic estat gof:estat gof}, when used after a
    {helpb probit}, {helpb logit}, or {helpb logistic} command that included
    either the {cmd:vce(robust)} or the {cmd:vce(jackknife)} option, reported
    an incorrect test result.  The test result was incorrect because it used
    the linear predictor in place of the predicted probability of success.
    This has been fixed.

{p 5 9 2}
{* enhancement}
7.  In all {help graph:graphs}, value labels and string variables are handled
    more elegantly.  Specifically, labels and string variables that contain
    multiple quoted strings, such as

{p 13 17 2}
	. {cmd:label define mylbl 1 `""this" "and that""'}

{p 9 9 2}
    now follow the standard graphics convention and produce multiline
    subtitles on {help by_option:by graphs} and produce multiline
    {help axis_label_options:axis tick labels} when the {cmd:valuelabel}
    option is specified.

{p 9 9 2}
    This change also allows labels or strings to include unbalanced
    parentheses and leading equal signs, which previously could cause the
    {cmd:graph} command to fail.

{p 5 9 2}
{* fix}
8.  {helpb hausman}, following estimation with {cmd:vce(robust)}, sometimes
    reported a test statistic and significance level, even though it was not
    statistically appropriate to do so.  {cmd:hausman} now issues an error
    message instead.

{p 5 9 2}
{* fix}
9.  {helpb ivtobit} with the two-step estimator and multiple endogenous
    regressors reported incorrect chi-squared statistics for the test of
    exogeneity.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb ksmirnov} with the {cmd:exact} option reported negative p-values
     on rare occasions because of a precision problem.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb linktest}, after estimation with the {helpb svy} prefix, produced
     standard errors that did not take into account the survey design.
    {cmd:linktest} is no longer available after the {cmd:svy} prefix.

{p 4 9 2}
{* fix}
12.  {helpb streg_postestimation##predict:predict}, after {helpb streg} with
     the {helpb svy} prefix, no longer allows the {cmd:csnell}, {cmd:mgale},
     {cmd:deviance}, {cmd:ccsnell}, and {cmd:cmgale} options.  These
     diagnostic predictions are statistically inappropriate for survey data.

{p 4 9 2}
{* enhancement}
13.  {helpb rolling} no longer limits the number of panels allowed based on
     the number of characters allowed in a macro.

{p 4 9 2}
{* fix}
14.  {helpb rolling}, when receiving an error from a command for a certain
     subset of data, would post missing values in two observations instead of
     in one.  This has been fixed.

{p 4 9 2}
{* enhancement}
15.  {helpb ssc type} now allows new option {cmd:asis} to display files
     without interpretation of {help SMCL} directives.

{p 4 9 2}
{* fix}
16.  {helpb stcox}, when used with the {helpb svy} prefix, no longer allows
     the diagnostic options {cmd:mgale()}, {cmd:schoenfeld()}, and
     {cmd:scaledsch()}.  These diagnostics are statistically inappropriate for
     survey data.

{p 4 9 2}
{* fix}
17.  {helpb sts list} with the {cmd:saving()} option did not allow spaces in
     filenames.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb table}, when {helpb aweight}s were specified and when missing
     values were present, incorrectly computed the {cmd:semean} statistic.
     This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb xtdescribe} treated missing values in the panel ID variable as a
     valid group rather than marking the observations out of the sample.  This
     has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb xtile} with ties occasionally produced incorrect quantile
     categories.  This has been fixed.


{hline 8} {hi:update 15oct2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb asmprobit postestimation##estatcor:estat correlation}, after
    {helpb asmprobit} and {helpb asroprobit}, now uses a default output format
    of {cmd:%9.4f} instead of the previous {cmd:%6.3f}.

{p 5 9 2}
{* enhancement}
2.  In {helpb estimates table} the {cmd:stfmt(%}{it:fmt}{cmd:)} option no
    longer affects the display format of the estimation sample size, N.

{p 5 9 2}
{* enhancement}
3.  {helpb icd9}'s database has been updated to use codes through the V26
    update of 1 October, 2008.

{p 5 9 2}
{* fix}
4.  {helpb ssc:ssc hot} now provides more informative error messages if
    certain files stored at the SSC are not as expected, although you will
    never see these messages.  These improvements were requested by Kit Baum,
    who maintains the SSC site.

{p 5 9 2}
{* enhancement}
5.  {helpb tab2} has a new option, {cmd:firstonly}, that restricts the output
    to only those tables that include the first specified variable.  Use this
    option to obtain tables of one variable interacted with a set of other
    variables.

{p 5 9 2}
{* enhancement}
6.  {helpb tsappend} with panel data is now faster.

{p 5 9 2}
{* fix}
7.  {helpb xtmelogit} and {helpb xtmepoisson} did not save {cmd:e(converged)}
    as documented.  This has been fixed.


{hline 8} {hi:update 22sep2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 8(3).

{p 5 9 2}
{* fix}
2.  {helpb codebook} with {cmd:if} or {cmd:in} qualifiers and option
    {cmd:compact} presented the wrong number of observations for string
    variables.  This has been fixed.

{p 5 9 2}
{* fix}
3.  The {helpb egen} function {cmd:total()} with the {cmd:missing} option gave
    results that depended on the sort order.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb heckman} with option {cmd:twostep}, when regressors appeared in
    both the outcome and selection equations, reported a Wald chi-squared test
    for the coefficients in both equations.  This has been fixed so that now a
    joint test is performed for only those coefficients in the outcome
    equation.

{p 5 9 2}
{* fix}
5.  {helpb heckman} with option {cmd:first}, when no dependent variable was
    specified in the selection equation, displayed a temporary variable name
    in the output.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ksmirnov} now issues the appropriate error message when used with a
    string variable.

{p 5 9 2}
{* fix}
7.  {helpb prtesti} with option {cmd:count} did not allow specifying equal
    counts (equivalent to specifying a proportion of 1), contrary to the
    documentation.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb spearman} with option {cmd:pw} produced incorrect values of
    correlation coefficients and significance levels for pairs of variables
    containing missing values when more than two variables were specified.
    This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb stphplot} with option {cmd:adjust()} produced an error message when
    {cmd:pweight}s were specified with {helpb stset}.  This has been fixed.

{p 4 9 2}
{* enhancement}
10.  {helpb sts list} option {cmd:saving()} can now be combined with options
     {cmd:failure} and {cmd:at()}.

{p 4 9 2}
{* fix}
11.  {helpb sts list} with option {cmd:saving()} produced an error message
     when the {cmd:compare} option was specified to compare more than six
     groups.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb svy} with an {cmd:if} expression in the {cmd:subpop()} option
     could result in the error "no observations in subpop() subpopulation" as
     a result of the update on 11aug2008.  This has been fixed.

{p 4 9 2}
{* enhancement}
13.  {helpb xtreg} now allows the {cmd:in} syntax for specifying a range of
     observations.

{p 4 9 2}
{* fix}
14.  {helpb xtreg} did not accept the {cmd: inrange()} function as part of an
     {cmd:if} expression.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb xtreg}, when the panel variable was included in the model as an
     independent variable, sometimes returned a confusing message.  This has
     been fixed.

{p 4 9 2}
{* fix}
16.  {helpb xtreg} did not check for collinearity between the independent
     variables and the panel variable.  This has been fixed.


{hline 8} {hi:update 26aug2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb reshape}, when reshaping from long to wide format with xij variable
    names longer than 20 characters, produced an error message and stopped.
    This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb svy}'s descriptive statistics commands ({cmd:svy: mean},
    {cmd:svy: proportion}, {cmd:svy: ratio}, and {cmd:svy: total}) with the
    {opt over()} option would exit with the error message "conformability
    error" when one or more over groups were dropped because of missing value
    patterns in the varlist.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb svy}'s descriptive statistics commands ({cmd:svy: mean},
    {cmd:svy: proportion}, {cmd:svy: ratio}, and {cmd:svy: total}) were
    marking out observations that had missing values in the {cmd:over()}
    variables for observations outside the subpopulation.  This affected the
    estimated variance values when the missing value patterns resulted in
    dropped primary sampling units, decreasing the design degrees of freedom.
    Both of these effects were very slight and inversely related to the number
    of PSUs.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb svy_tabulate:svy: tabulate} was marking out observations that had
    missing values in the variable list for observations outside the
    subpopulation.  This affected the estimated variance values when the
    missing value patterns resulted in dropped primary sampling units,
    decreasing the design degrees of freedom.  Both of these effects were very
    slight and inversely related to the number of PSUs.  This has been fixed.


{hline 8} {hi:update 11aug2008} {hline}

    {title:What's new in release 10.1 (compared with release 10.0)}

{pstd}
Highlights for release 10.1 include the following:

{p 8 11 2}
{cmd:o}{space 2}Distribution and probability mass functions for the
        hypergeometric, negative binomial, and Poisson distributions have been
        added to Stata.  The probability mass function for the binomial
        distribution has also been added.  See {help density functions}.
        Additionally, Mata now has these functions; see {helpb mata normal()}.

{p 8 11 2}
{cmd:o}{space 2}Random-variate functions for the beta, binomial, chi-squared,
        gamma, hypergeometric, negative binomial, normal, Poisson, and
        Student's t distributions have been added to Stata; see
        {help random-number functions}.  Additionally, Mata now has these
        random-variate functions; see {helpb mata runiform()}.

{p 11 11 2}
        {cmd:uniform()} has been renamed
        {helpb random_number_functions:runiform()} to be consistent
        with the naming convention of the nonuniform random-variate functions.
        {cmd:uniform()} continues to work but is now undocumented.  Mata
        functions {cmd:uniform()} and {cmd:uniformseed()} have been renamed
        {helpb mf_runiform:runiform()} and {helpb mf_runiform:rseed()}.

{p 8 11 2}
{cmd:o}{space 2}{helpb asmprobit} and {helpb asroprobit} have several new
        features, including option {cmd:factor(}{it:#}{cmd:)} specifying the
        use of a factor covariance structure, which models the covariance as
        I + C'C.  Postestimation command {helpb estat facweights} displays the
        covariance factor weights in matrix form.

{p 8 11 2}
{cmd:o}{space 2}{helpb reshape} now preserves the J variable value and
        variable labels and all xij variable labels when reshaping from wide
        to long and back to wide.

{p 8 11 2}
{cmd:o}{space 2}{helpb pwcorr} has new option {cmd:listwise}, which specifies
        that missing values are to be handled by listwise deletion, allowing
        users of {cmd:pwcorr} to mimic {cmd:correlate}'s treatment of missing
        values while maintaining access to all of {cmd:pwcorr}'s features.

{p 8 11 2}
{cmd:o}{space 2}Initialization Mata functions {helpb mf_ghk:ghk_init()} and
     {helpb mf_ghkfast:ghkfast_init()}, as well as several other helper
     functions, have been added to construct, modify, and query structures
     defining simulation parameters and creating simulation points for
     subsequent calls to {helpb mf_ghk:ghk()} and
     {helpb mf_ghkfast:ghkfast()}.

{pstd}
We recommend that you set the version to {cmd:version 10.1} at the top of new
do-files and ado-files.  See {helpb version}.


    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb asmprobit} and {helpb asroprobit} have a new covariance structure.
    Option {cmd:factor(}{it:#}{cmd:)} specifies the use of factor covariance
    structure. For a model with J alternatives, the {it:#} x J factor matrix
    C, {it:#} smaller than J, models the covariance as I + C'C, where I is a
    J x J identity matrix.

{p 5 9 2}
{* enhancement}
2.  {helpb asmprobit} and {helpb asroprobit} have new option
    {cmd:favor(speed}|{cmd:space)}, which directs the programs to favor either
    speed or space (memory) when executing.  {cmd:favor(speed)} is the
    default.

{p 5 9 2}
{* enhancement}
3.  {helpb asmprobit} and {helpb asroprobit} have new option {cmd:nopivot},
    which will direct the programs not to pivot integration intervals so that
    wider intervals are on the inside of the multivariate integration.  This
    option may be useful when fitting a model with few simulation points.

{p 5 9 2}
{* fix}
4.  {helpb biplot}, when computing means (and standard deviations with option
    {cmd:std}) used in the computations, did not honor {helpb if} or {helpb in}
    qualifiers.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb bootstrap} and {helpb jackknife} removed option {opt vce()}
    when it was specified on the command being bootstrapped or jackknifed,
    resulting in calculations based on the conventional standard errors and
    covariances instead of the requested alternative.  This has been fixed.

{p 5 9 2}
{* enhancement}
6.  {helpb canon}'s default output has changed.  {helpb canon} now displays
    matrices of raw coefficients by default.  {helpb canon} no longer
    documents option {cmd:coefmatrix}, which specified the display of matrices
    of raw coefficients.  Setting the version to less than 10.1 will display the
    raw coefficients, conditionally estimated standard errors, and confidence
    intervals in the standard estimation table, by default; this output can
    also be obtained by using new option {cmd:stderr}.

{p 5 9 2}
{* fix}
7.  {helpb dstdize} reported large population totals rounded to floating point
    precision.  This has been fixed.

{p 5 9 2}
{* enhancement}
8.  {helpb egen} function {cmd:mode()} with option {cmd:missing} now treats
    missing values as a category when finding the mode.  The {cmd:minmode},
    {cmd:maxmode}, and {cmd:nummode()} option scan now be specified
    with and without the {cmd:missing} option for the desired mode.  When
    {helpb version} is set to less than 10.1 with option {cmd:missing},
    missing values are not treated as a category.

{p 5 9 2}
{* enhancement}
9.  {helpb egen} functions {cmd:total()} and {cmd:rowtotal()} have new option
    {cmd:missing}.  With this option, if all values of {it:exp} or
    {it:varlist} for an observation are missing, then that observation in
    {it:newvar} will be set to missing.

{p 4 9 2}
{* enhancement}
10.  New postestimation command {helpb estat facweights} after
     {helpb asmprobit}{cmd:, factor(}{it:#}{cmd:)} and
     {helpb asroprobit}{cmd:, factor(}{it:#}{cmd:)} displays the covariance
     factor weights in matrix form.

{p 4 9 2}
{* fix}
11.  The dialog box for {helpb fdasave} did not place quotation marks around
     the path and filename, causing an error when the path or filename
     contained spaces.  This has been fixed.

{p 4 9 2}
{* fix}
12.  In the {help Graph Editor}, when editing a {help graph bar:bar graph}
     created with the {help by option:{it:by option}}, the Sort
     button of both the Contextual Toolbar for the bar region and the
     properties dialog for the bar region failed to sort the graph's bars.
     This has been fixed.

{p 4 9 2}
{* enhancement}
13.  The dialog box for {helpb graph twoway} now allows plots to be reordered
     when multiple plots have been defined.

{p 4 9 2}
{* fix}
14.  {helpb ivregress}, when a heteroskedasticity-and-autocorrelation
     consistent VCE or weight matrix was requested with the Bartlett kernel
     and Newey and West's optimal bandwidth-selection algorithm, could report
     incorrect standard errors.  When the GMM estimator was used, the point
     estimates could also be incorrect.  This has been fixed.  Whether you
     observe changes in output as a result of this bug fix is data dependent.

{p 4 9 2}
{* enhancement}
15.  Mata functions {helpb mf_ghk:ghk()} and {helpb mf_ghkfast:ghkfast()} have
     a new syntax.  Initialization functions {helpb mf_ghk:ghk_init()} and
     {helpb mf_ghkfast:ghkfast_init()}, as well as several helper functions,
     have been added to construct, modify, and query structures defining
     simulation parameters and creating simulation points for subsequent calls
     to {cmd:ghk()} and {cmd:ghkfast()}.

{p 4 9 2}
{* enhancement}
16.  {helpb pwcorr} has new option {cmd:listwise}, which specifies that
     missing values are to be handled by listwise deletion; that is,
     observations containing missing values for any of the given variables are
     removed from the estimation sample before any calculations take place.
     By default, {cmd:pwcorr} uses pairwise deletion, under which the
     correlation calculation for each variable pair uses all available data
     without regard to missing values outside that variable pair.

{p 9 9 2}
     Specifying {cmd:listwise} allows users of {cmd:pwcorr} to mimic
     {cmd:correlate}'s treatment of missing values while maintaining access to
     all of {cmd:pwcorr}'s features.

{p 4 9 2}
{* enhancement}
17.  {helpb reshape} now preserves the J variable value and variable labels
     and all xij variable labels when reshaping from wide to long and back to
     wide.  Previous behavior is obtained by setting {helpb version} to less
     than 10.1.

{p 4 9 2}
{* fix}
18.  {helpb roctab} and {helpb roccomp}, although r-class commands, left
     information in the {cmd:ereturn list} from calls they made to the
     {cmd:logistic} command.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb stpower} did not allow spaces in filenames specified in option
     {cmd:saving()}.  This has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb svy}'s descriptive statistics commands ({cmd:svy: mean},
     {cmd:svy: proportion}, {cmd:svy: ratio}, and {cmd:svy: total}) were
     marking out observations that had missing values in the variable list for
     observations outside the subpopulation.  This affects the estimated
     variance values when the primary sampling units were the individual
     observations and could decrease the design degrees of freedom.  Both of
     these effects are very slight and inversely related to the sample size.
     This has been fixed.

{p 4 9 2}
{* fix}
21.  {helpb svy}, in the {cmd:if} expression within the {opt subpop()} option,
     did not allow the {cmd:missing()} function to be specified.  This has been
     fixed.

{p 4 9 2}
{* fix}
22.  {helpb xthtaylor}, when used with a sufficient number of perfectly
     collinear covariates, would drop different variables when the same
     command was repeatedly run.  This has been fixed.

{p 4 9 2}
{* fix}
23.  {helpb xtgee}, when used with {cmd:corr(fixed} {it:matname}{cmd:)},
     deleted matrix {it:matname}.  This has been fixed.

{p 4 9 2}
{* enhancement}
24.  {helpb xtmelogit} and {helpb xtmepoisson} now support maximize option
     {cmd:from()}; see {help maximize}.  This allows users to specify starting
     values, which can significantly speed up estimation.  For these two
     commands, {cmd:from()} is particularly useful when combined with
     {cmd:refineopts(iterate(0))}, which bypasses the initial optimization
     stage.

{p 4 9 2}
{* enhancement}
25.  As of Stata 10.1, {helpb xtmixed}, {helpb xtmelogit}, and
     {helpb xtmepoisson} now require that random-effects specifications
     contain an explicit level variable (or {cmd:_all}) followed by a colon.
     Previously, if these were omitted, a level specification of {cmd:_all:}
     was assumed, leading to confusion when only the colon was omitted.  To
     avoid this confusion, omitting the colon now produces an error, with
     previous behavior preserved under {helpb version} control.

{p 4 9 2}
{* fix}
26.  {helpb xtreg} with option {opt be}, when used with regressors that
     included time-series operators, would exit with an error message saying
     "time-series operators not allowed".  Now time-series operators are
     allowed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
27.  Distribution and probability mass functions for the hypergeometric,
     negative binomial, and Poisson distributions have been added to Stata.
     The probability mass function for the binomial distribution has also been
     added.  See {help density functions}.  Additionally, Mata now has these
     functions; see {helpb mata normal()}.

{p 4 9 2}
{* enhancement}
28.  Random-variate functions for the beta, binomial, chi-squared, gamma,
     hypergeometric, negative binomial, normal, Poisson, and Student's t
     distributions have been added to Stata; see
     {help random-number functions}.  Additionally, Mata now has these
     random-variate functions; see {helpb mata runiform()}.

{p 4 9 2}
{* enhancement}
29.  Function {cmd:uniform()} has been renamed
     {helpb random_number_functions:runiform()} to be consistent with
     the naming convention of the nonuniform random-variate functions.
     {cmd:uniform()} continues to work but is now undocumented.  Mata
     functions {cmd:uniform()} and {cmd:uniformseed()} have been renamed
     {helpb mf_runiform:runiform()} and {helpb mf_runiform:rseed()}.

{p 4 9 2}
{* enhancement}
30.  Old function {cmd:Binomial()} is no longer allowed (as of Stata 10.1);
     {helpb binomialtail()} should be used instead.  {cmd:Binomial()} is
     allowed when {helpb version} is set to less than 10.1.

{p 4 9 2}
{* enhancement}
31.  {helpb drawnorm} now uses new function {helpb rnormal()} to generate
     normal random variates.  When {helpb version} is set to less than 10.1,
     {cmd:drawnorm} reverts to using {cmd:invnormal(uniform())}.

{p 4 9 2}
{* fix}
32.  Mata's {help m2_op_colon:addition colon operator}, {cmd::+}, crashed
     Stata if one of the arguments was a void string matrix.  This has been
     fixed.

{p 4 9 2}
{* fix}
33.  Mata function {helpb mf_hash1:hash1(x, n)} incorrectly returned n+1 for
     certain x and n.  This has been fixed.

{p 4 9 2}
{* fix}
34.  Mata function {helpb mf_strofreal:strofreal()} returned different results
     depending on the {help set dp:style of decimal point setting}.  This has
     been fixed.

{p 4 9 2}
{* fix}
35.  {helpb mlmatbysum} now checks for string variables in {opt by()}.
     String variables are not allowed in this option.

{p 4 9 2}
{* fix}
36.  {helpb odbc insert} with option {cmd:create} now writes Stata doubles as
     SQL data type FLOAT(53) instead of REAL.  Most of the time in SQL, the
     REAL data type maps to a 4-byte float, so on SQL Server, for example,
     there was a loss of precision for all doubles.

{p 4 9 2}
{* fix}
37.  {helpb oneway}, with a constant {it:response_var} and option
     {opt bonferroni}, {opt scheffe}, or {opt sidak}, produced invalid p-values
     in the comparison table.  For larger datasets, Stata stopped responding
     while {cmd:oneway} was in the middle of producing the comparison table.
     This has been fixed.

{p 4 9 2}
{* enhancement}
38.  {helpb stcox} now allows a maximum of 100 variables to be specified in
     option {cmd:tvc()}.  The previous limit was 10.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
39.  {helpb postfile} with option {cmd:every()} did not cause {helpb post} to
     write results to disk as often as was specified in {cmd:every()}.  This
     has been fixed.

{p 4 9 2}
{* fix}
40.  The Do-file Editor did not allow printing a selection. This has been
     fixed.

{p 4 9 2}
{* fix}
41.  While {help graph editor##grid_editing:grid editing} in the
     {help graph_editor:Graph Editor}, dragging an object into another cell
     did not highlight the target cell properly.  Now the target cell is shown
     in a darker translucent red, which is consistent with Stata for Mac OS
     and Unix.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
42.  You can now disable keyboard navigation in the Variables and Review
     windows from the General Preferences dialog.  See {help revkeyboard} or
     {help varkeyboard} for more information.

{p 4 9 2}
{* enhancement}
43.  Pressing Cmd+Left arrow and Cmd+right arrow in the Command window will
     now move the cursor to the beginning of a line and to the end of a line,
     respectively.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
44.  {helpb printer define} now allows up to 100 defined printers.  The
     previous limit was 10.

{p 4 9 2}
{* fix}
45.  Previously, when opening an existing do-file using File > Open from an
     existing Do-file Editor window, the do-file to be opened would replace
     the contents of the existing Do-file Editor window, regardless of whether
     the existing window had been saved.  Stata now always opens an
     existing do-file in a new window.  The Open Recent menu would display
     some characters as underlined if a filename contained an underscore.
     This has been fixed.  The Open Recent menu in a new Do-file Editor window
     would not show the most recent file added to the menu.  This has been
     fixed.


{hline 8} {hi:update 25jun2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 8(2).

{p 5 9 2}
{* enhancement}
2.  {helpb collapse} and {helpb table} now allow the statistics {cmd:semean},
    {cmd:sebinomial}, and {cmd:sepoisson} to calculate the standard error of
    the mean, the binomial standard error of the mean, and the Poisson
    standard error of the mean, respectively.

{p 5 9 2}
{* fix}
3.  {helpb collapse} with the {it:target_var}{cmd:=}{it:varname} syntax and
    with an empty weight (that is, {cmd:[]}) produced an error message.  This
    has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb collapse} with {cmd: aweight}s and when ties were present on rare
    occasions produced inconsistent percentile results. This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb median} did not allow a string variable in option {cmd:by()}.  This
    has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ml}'s documentation mistakenly contained {cmd:bootstrap} and
    {cmd:jackknife} among the {it:vcetype}s allowed in the {opt vce()} option.
    This has been fixed in the online help.

{p 5 9 2}
{* fix}
7.  {helpb nestreg} would fail to recognize the correct estimation sample for
    {helpb stcox} and {helpb streg} when {helpb stset} marked out
    observations, such as for missing values in {it:timevar} or when the
    {it:{help if}} qualifier was specified.  In such cases, {cmd:streg} would
    report the error "# obs. dropped because of estimability, this violates
    the nested model assumption" and quit.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb svy brr} and {helpb svy jackknife}, when used to prefix r-class
    commands, would exit with the error "statistic ... evaluated to missing in
    full sample".  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy jackknife}, when a string variable was specified in the
    {opt strata()} option of {helpb svyset} (without the {opt jkrweight()}
    option), reported a "type mismatch" error.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb table} with option {cmd:contents(freq)} did not allow more than
     seven digits in the {cmd:format()} option.  This has been fixed.


{hline 8} {hi:update 30may2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb dfuller} with option {opt regress} overwrote the estimation results
    with those from the Dickey-Fuller regression.  {cmd:dfuller} now leaves
    existing estimation results unchanged.

{p 5 9 2}
{* enhancement}
2.  {helpb ivregress_postestimation##estatendog:estat endogenous} and
    {helpb ivregress_postestimation##estatoverid:estat overid} now save in
    {cmd:r()} the p-values from chi-squared and F tests.

{p 5 9 2}
{* fix}
3.  {helpb ivregress_postestimation##estatfirst:estat firststage} after
    {helpb ivregress} exited with an error when the model contained
    time-series operators.  This has been fixed.

{p 5 9 2}
{* enhancement}
4.  {helpb ivregress 2sls} and {helpb ivregress gmm} have new option
    {opt perfect}, which skips checking whether the endogenous regressors are
    collinear with the excluded instruments.

{p 5 9 2}
{* fix}
5.  {helpb tsset} and {helpb xtset} ignored period options such as
    {opt daily} or {opt weekly} if the time variable had previously been
    formatted with a different period.  These commands now honor the specified
    period option and issue a warning if it requires resetting the period.

{p 5 9 2}
{* fix}
6.  {helpb xtlogit} with option {cmd:fe} ignored option {cmd:from()}.  This
    has been fixed.


{hline 8} {hi:update 27may2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  The {helpb bootstrap}{cmd::} and {helpb jackknife}{cmd::} prefixes
    now allow you to specify the {opt vce()} option on the command being
    bootstrapped or jackknifed.  This allows you to bootstrap or jackknife
    alternate estimates of standard errors and covariances.

{p 5 9 2}
{* fix}
2.  The dialog box for {helpb describe} could sometimes initialize with
    checkboxes in the incorrect state.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb discrim lda postestimation##syntax_estat:estat anova} after
    {helpb discrim lda} did not abbreviate long variable names causing
    misaligned output.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb exlogistic} and {helpb expoisson} now issue an error message
    when the requested memory (option {cmd:memory()}) exceeds the limit of two
    gigabytes.

{p 5 9 2}
{* fix}
5.  {helpb exlogistic} and {helpb expoisson} in rare cases declared
    nonconvergence on calculations for confidence bounds when in fact finite
    bounds were computable.  This has been fixed.

{p 5 9 2}
{* fix}
6.  Mata's {helpb mf_optimize:optimize()} with {it:singularHmethod}
    {cmd:"hybrid"} did not always optimally recover from bad steps.  This
    has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb mfp}, when used to fit an {helpb xtgee} model with a single
    covariate, reported a missing deviance.  This has been fixed.

{p 5 9 2}
{* enhancement}
8.  {helpb ml display} has new option {opt nocnsreport}, which suppresses the
    display of constraints above the coefficient table.

{p 5 9 2}
{* fix}
9.  {helpb nlcom} and {helpb testnl} no longer require that {cmd:e(cmd)}
    exists.  This allows both to work with a wider range of user-written
    estimation commands.

{p 4 9 2}
{* fix}
10.  {helpb statsby} with option {opt subsets} and a string {opt by()}
     variable produced a type mismatch error.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb sts graph} with options {opt tmin()} or {opt tmax()} and option
     {opt risktable} could produce incorrect at-risk counts within the table.
     This has been fixed.

{p 4 9 2}
{* enhancement}
12.  {helpb sts list} has new option {cmd:saving()}, which will create a
     dataset containing the results.

{p 4 9 2}
{* fix}
13.  {helpb sts list} does not support standard errors and confidence
     intervals when the data are {helpb stset} with {helpb pweight}s.
     However, when option {opt at()} was also specified, standard errors
     and confidence intervals were reported, but these were inappropriate
     for sampling-weighted data.  As such, they are no longer reported.

{p 4 9 2}
{* fix}
14.  {helpb xtcloglog}, {helpb xtfrontier}, {helpb xtintreg}, {helpb xtlogit},
     {helpb xtnbreg}, {helpb xtpoisson}, and {helpb xtprobit} now issue more
     informative error messages when invalid {cmd:vce()} types are specified.

{p 4 9 2}
{* fix}
15.  {helpb xtmelogit} and {helpb xtmepoisson}, when used to fit a
     crossed-effects model that includes both factor notation
     ({cmd:R.}{it:varname}) and random coefficients, exited with a matrix
     conformability error.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb xtpoisson} with option {cmd:fe}, when used with covariates that are
     collinear with the panel identifier, incorrectly labeled coefficients
     on variables that followed the dropped collinear variables.  This has
     been fixed.

{p 4 9 2}
{* enhancement}
17.  {helpb xttab} now returns the matrix of results in {cmd:r(results)} and
     the number of panels in the sample in {cmd:r(n)}.

{p 4 9 2}
{* fix}
18.  {helpb xttab}, when used on data with unbalanced panels, produced
     within-panel tabulations that incorrectly treated the panels as
     balanced.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
19.  {cmd:c(smallestdouble)} has been added to {helpb creturn list}.

{p 4 9 2}
{* enhancement}
20.  {help m1_first:Mata} has the following new functions.

{p 9 13 2}
    A.  {helpb mf_asarray:asarray()} provides associative arrays, also known
        as containers, maps, dictionaries, indices, and hash tables; see
        {helpb mf_asarray:[M-5] asarray()}.

{p 9 13 2}
    B.  {helpb mf_dmatrix:[M-5] Dmatrix()} creates duplication matrices; see
        {helpb mf_dmatrix:[M-5] Dmatrix()}.

{p 9 13 2}
    C.  {helpb mf_hash1:hash1()} implements Jenkins' one-at-a-time hash
        function; see {helpb mf_hash1:[M-5] hash1()}.

{p 9 13 2}
    D.  {helpb mf_kmatrix:[M-5] Kmatrix()} creates commutation matrices; see
        {helpb mf_kmatrix:[M-5] Kmatrix()}.

{p 9 13 2}
    E.  {helpb mf_lmatrix:[M-5] Lmatrix()} creates elimination matrices; see
        {helpb mf_lmatrix:[M-5] Lmatrix()}.

{p 4 9 2}
{* enhancement}
21.  {help m1_first:Mata} functions {helpb mf_vec:[M-5] vec()} and
     {helpb mf_vech:[M-5] vech()} have been sped up for real and complex
     matrices.

{p 4 9 2}
{* fix}
22.  Mata's {helpb mf_mindouble:smallestdouble()} value was twice as large as
     the smallest full-precision double.  This has been fixed.

{p 4 9 2}
{* fix}
23.  Stata failed to recognize matrix subscripts when they were strings with
     leading spaces.  This has been fixed.

{p 4 9 2}
{* fix}
24.  {helpb odbc load}, when converting dates, failed to fully honor version
     control.  When the version was set to 9 or less, it converted dates to the
     newer {cmd:%tc} format rather than the older {cmd:%td} format.  This
     has been fixed.

{p 4 9 2}
{* fix}
25.  Function {helpb regexr()}, when called with an empty string as its first
     argument, would sometimes incorrectly return the result of its previous
     call.  This has been fixed.

{p 4 9 2}
{* enhancement}
26.  {helpb smallestdouble()} has been added to Stata's programming functions.
     It returns the smallest full-precision double.

{p 4 9 2}
{* fix}
27.  {helpb xtabond}, {helpb xtdpd}, and {helpb xtdpdsys}, when used with
     data that contained gaps in panels such that the gaps varied from panel to
     panel, produced estimates that were based on an incorrect instrument
     matrix.  This has been fixed.

{p 4 9 2}
{* fix}
28.  The Data Editor, when used with many variables containing long strings,
     would occasionally draw incorrectly and occasionally have
     difficulty scrolling horizontally.  These problems have been fixed.

{p 4 9 2}
{* enhancement}
29.  The Data Editor now respects display formats on string variables.
     That is to say, what you see in a cell is the formatted string.

{p 4 9 2}
{* fix}
30.  When Stata closed, it did not call the {help class} destructors for class
     instances that existed at exit.  This affected a few sophisticated
     programmers who needed to know when every instance was destroyed so that
     they could perform explicit clean-up operations for their instances.
     This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
31.  Executables for Stata and StataAdministrativeTools are now signed,
     allowing Windows Vista to identify StataCorp LP as the software
     publisher.  Previously, starting Stata with Administrator access and with
     User Access Control (UAC) enabled would cause a warning to be displayed
     that identified Stata as an "Unidentified Publisher".

{p 4 9 2}
{* enhancement}
32.  The extended {helpb macro} function {helpb extended_fcn:dir} has the new
     option {opt respectcase}, which specifies that {cmd:dir} respect the case
     of filenames when performing matches.  Windows has case-insensitive
     filenames.  As such, by default under Windows {cmd:dir} converts all
     filenames to lowercase before matching them.  {opt respectcase} prevents
     this lowercase conversion.

{p 4 9 2}
{* fix}
33.  {helpb odbc} in 64-bit Stata for Windows would crash when loading the
     Windows 64-bit ODBC driver.  This has been fixed.

{p 4 9 2}
{* fix}
34.  The Do-file Editor, when opening a file, would place the cursor at the
     end of the file instead of at the beginning.  This has been fixed.

{p 4 9 2}
{* fix}
35.  The Do-file Editor did not open the file menu when Alt+F was pressed.
     This has been fixed.

{p 4 9 2}
{* fix}
36.  The Graph Editor did not always populate the Object Browser when the
     Browser was opened manually.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
37.  {cmd:--more--} conditions in the Results window unnecessarily caused
     high CPU usage until cleared.  This has been fixed.

{p 4 9 2}
{* fix}
38.  Selecting a file using {helpb window fopen} could cause Stata
     to crash if the file's path was greater than 32 characters.  This
     has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
39.  {helpb log} with option {opt append}, when used to create a new
     file rather than appending to an existing file, would apply incorrect
     permissions to the newly-created file.  This has been fixed.


{hline 8} {hi:update 02apr2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 8(1).

{p 5 9 2}
{* fix}
2.  {helpb nestreg} reported the error "arguments to title do not match the
    number of columns" while displaying its summary of results when used with
    {helpb regress} with the {cmd:vce(bootstrap)} option.  This has been
    fixed.

{p 5 9 2}
{* fix}
3.  {helpb suest} complained about missing score values with results from
    {helpb heckman} or {helpb heckprob} when the independent variables in the
    main equation (but not in the selection equation) contained missing values
    outside the selection observations.  This has been fixed.

{p 5 9 2}
{* enhancement}
4.  {manhelp svy SVY} now mentions {cmd:e(b)} and {cmd:e(V)} in the
    {cmd:Stored results} section.

{p 5 9 2}
{* fix}
5.  {help svy}'s linearized variance estimator was marking out observations
    that had missing values in the independent variables for observations
    outside the subpopulation.  This affects the estimated variance values
    when the primary sampling units were the individual observations and could
    decrease the design degrees of freedom.  Both of these effects are very
    slight and inversely related to the sample size.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb svy jackknife} would report too many PSUs when something other than
    the default {it:exp_list} statistic ({cmd:_b}) was specified, the PSUs
    were data observations, and some of the observations were dropped by the
    prefixed command (typically because of missing values), resulting in
    slightly inflated degrees of freedom depending on the number of dropped
    observations.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb svy_tabulate:svy: tabulate} with the {opt se} or {opt ci} options
    did not display standard errors or confidence intervals when there was a
    stratum with a single sampling unit, even when the dataset was
    {helpb svyset} using option {cmd:singleunit(certainty)},
    {cmd:singleunit(scaled)}, or {cmd:singleunit(centered)}.  This has been
    fixed.


{hline 8} {hi:update 17mar2008} {hline}

    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
1.  The permissions for Stata's resource files have been corrected to allow
    all users to launch Stata.

{p 5 9 2}
{* fix}
2.  Some of Stata's dialogs, such as the General Preferences and Find dialogs,
    had a close window button mistakenly added to the dialogs in the 25feb2008
    update.  This has been fixed.


{hline 8} {hi:update 06mar2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  Following the 25feb2008 update, {helpb xtmelogit} treated a missing value
    in the dependent variable as a positive response instead of removing the
    observation from the estimation sample.  This has been fixed.


{hline 8} {hi:update 03mar2008} {hline}

    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
1.  Performance of the Review window has been enhanced so that there is less
    overhead between executing multiple commands that are all pasted into the
    Command window at once.

{p 5 9 2}
{* fix}
2.  With the 25feb2008 update, the Do-file Editor overwrote the do-file in the
    editor with the selected lines when running those selected lines using the
    {bf:Run} button.  This has been fixed.


{hline 8} {hi:update 29feb2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  With the 25feb2008 update, the abbreviation {cmd:la} for {helpb label} did
    not work.  This has been fixed.

{p 5 9 2}
{* fix}
2.  The {cmd:predict} dialog reported a "file not found" error when used with
    results from the following survey estimation commands:  {cmd:svy: gnbreg},
    {cmd:svy: heckman}, {cmd:svy: heckprob}, {cmd:svy: intreg},
    {cmd:svy: logistic}, {cmd:svy: logit}, {cmd:svy: mlogit},
    {cmd:svy: nbreg}, {cmd:svy: ologit}, {cmd:svy: oprobit},
    {cmd:svy: poisson}, {cmd:svy: probit}, and {cmd:svy: regress}.  This has
    been fixed.

{p 5 9 2}
{* fix}
3.  The {helpb heckman_postestimation##predict:predict} dialog for
    {helpb "svy: heckman"} disabled the radio button for "Standard error of
    the prediction" when it should have disabled the radio button for
    "Standard error of the forecast".  This has been fixed.


{hline 8} {hi:update 25feb2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb bootstrap} has the new {opt jackknifeopts()} option for passing
    options to {helpb jackknife} when the {opt bca} option is specified.

{p 5 9 2}
{* fix}
2.  The documentation for {helpb glm} and {helpb binreg} did not mention that
    the {opt const:raints()} option was allowed when fitting models using
    {helpb ml} optimization.  The help files and dialogs have been updated.

{p 5 9 2}
{* fix}
3.  {helpb glm}, when used with the {cmd:binomial} family and either the
    {cmd:log} or {cmd:identity} link, sometimes issued a spurious warning
    message regarding inadmissible predictions.  This has been fixed.

{p 5 9 2}
{* fix}
4.  When using a saved {help graph matrix:scatterplot matrix} that was
    created using the {helpb by_option:by()} option and that had previously
    been edited with the {help Graph Editor},
    {help graph_editor##contextual_menus:Observation Property} edits might be
    ignored for some observations.  This has been fixed.

{p 5 9 2}
{* fix}
5.  The {cmd:Y axis} tab has been removed from the dialog box for
    {helpb graph pie}.

{p 5 9 2}
{* fix}
6.  {helpb kdensity} displayed a bandwidth of zero on the graph even though
    the bandwidth was not exactly zero.  {cmd:kdensity} now displays more
    significant digits for the bandwidth in the resulting graph.

{p 5 9 2}
{* fix}
7.  {helpb notes} did not attach notes to a variable name with exactly 32
    characters.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb mlogit_postestimation##predict:predict} with the {cmd:scores}
    option after {helpb mlogit} was displaying an error when specifying the
    correct number of variables.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb ologit_postestimation##predict:predict} with the {opt scores}
    option after {helpb ologit} and {helpb oprobit} produced incorrect
    equation-level score values when the estimation results were computed
    under version control less than 9.  This affected the standard errors
    produced by {helpb svy estimation:svy: ologit} and
    {helpb svy estimation:svy: oprobit} when they were called under version
    control less than 9.  This has been fixed.

{p 4 9 2}
{* enhancement}
10.  {helpb ssc:ssc whatsnew} and {helpb ssc:ssc whatshot} have been renamed
     {cmd:ssc new} and {cmd:ssc hot}.  The old subcommand names continue to
     work but are undocumented.

{p 4 9 2}
{* fix}
11.  The following changes are made to {helpb sts graph} and {helpb stcurve}
     for kernel-based hazard estimation (when option {cmd:hazard} is used).

{p 9 13 2}
    A.  The use of the boundary-adjusted kernel functions {cmd:epan2},
        {cmd:biweight}, or {cmd:rectangular} can sometimes lead to negative
        estimates of the hazard function.  In such cases, the negative hazard
        estimates are replaced with 0.

{p 9 13 2}
    B.  When a hazard estimation grid included a time point equal to the value
        of a bandwidth, the hazard estimates obtained using an {cmd:epan2},
        {cmd:biweight}, or {cmd:rectangular} kernel were incorrectly shifted
        by one time point in the right boundary region.  This could result in
        a slightly different curve being displayed in the right boundary
        region with these kernels.  This has been fixed.

{p 9 13 2}
    C.  The left boundary region is changed to be the region [L,L+h) instead
        of the old region [0,h).  Here L is the minimum analysis time at which
        failure occurred, and h is the bandwidth.  As such, the default
        plotting range is restricted to [L,R] (R is the observed maximum
        failure time) for the {cmd:epan2}, {cmd:biweight}, and
        {cmd:rectangular} kernels.  For other available kernels, the default
        plotting range is [L+h,R-h].

{p 4 9 2}
{* enhancement}
12.  {helpb svy} results will now report the population and subpopulation
     sizes out to a larger number of significant digits, reserving scientific
     notation for sizes greater than 99 trillion.

{p 4 9 2}
{* fix}
13.  {helpb svy_tabulate_twoway:svy: tabulate twoway}, when used with data
     that contained a stratum with a single sampling unit, would report
     zero-valued test statistics (with p-values of 1) when it should have
     reported missing values.  This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb svy_tabulate_twoway:svy: tabulate twoway} now recognizes value
     labels assigned to extended missing values.

{p 4 9 2}
{* fix}
15.  {helpb svyset} would not check for invalid syntax beyond the stage that
     contained an {opt fpc()} option.  This has been fixed.

{p 4 9 2}
{* fix}
16.  The dialog box for {helpb xtabond} did not allow {cmd:vce(robust)} to be
     specified with the {cmd:twostep} option.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb xtgee} terminated with error 198, {error}Unable to identify
     sample{text}, if {cmd:pweight}s were used with the {cmd:noconstant}
     option.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb xtgee} did not properly mark the estimation sample (contained in
     {cmd:e(sample)}) when using the autoregressive, stationary, and
     nonstationary correlation structures, and observations were dropped
     because they did not have equally spaced time intervals.  This has been
     fixed.

{p 4 9 2}
{* enhancement}
19.  {helpb xtmixed}, {helpb xtmelogit}, and {helpb xtmepoisson} now support
     time-series operators.

{p 4 9 2}
{* enhancement}
20.  {helpb xtreg:xtreg, fe} now uses {cmd:vce(cluster id)} when
     {cmd:vce(robust)} is specified, in light of the new results in Stock
     and Watson, "Heteroskedasticity-robust standard errors
     for fixed-effects panel-data regression,"
     {it:Econometrica} 76 (2008): 155-174.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
21.  The {help graph editor:Graph Editor} can now record a series of
     edits, name the recording, and apply the edits from the recording to
     other graphs.  You can apply the recorded edits from the {bf:Graph}
     {bf:Editor} or
     from the command line.  The edits can be applied from the command line
     when a graph is created, when it is used from disk, or whenever it is the
     active graph.

{p 9 9 2}
     See {help graph_editor##recorder:Graph Recorder} in
     {manhelp graph_editor G-1:graph editor} for creating and playing recordings
     in the {bf:Graph} {bf:Editor}.  For applying edits from the command
     line, see {manhelp graph_play G-2:graph play} and the option
     {cmd:play(}{it:recordingname}{cmd:)} in {manhelpi std_options G-3} and
     {manhelp graph_use G-2:graph use}.

{p 4 9 2}
{* enhancement}
22.  Official ado updates may now be distributed as a compressed archive.
     This can make updates significantly faster for those with a slow internet
     connection.

{p 4 9 2}
{* enhancement}
23.  Algorithms for the function for the normal distribution (function
     {helpb normal()}) and the log of the normal distribution (function
     {helpb lnnormal()}) have been improved to operate in 60% of the time and
     75% of the time respectively, while giving equivalent double-precision
     results.

{p 4 9 2}
{* enhancement}
24.  {helpb correlate} now returns a matrix {cmd:r(C)} containing the
     correlation or covariance matrix.

{p 4 9 2}
{* enhancement}
25.  {helpb describe} now respects the Results window line width when
     displaying variable labels.  Long variable labels will wrap to fit the
     line width of the Results window.

{p 4 9 2}
{* enhancement}
26.  New command {helpb label:label copy} has been added, which allows a value
     label to be copied to a new name.

{p 4 9 2}
{* enhancement}
27.  {helpb label values} now takes a {it:{help varlist}}.  To assign the
     value label, you specify the label name after the {it:varlist}.  To remove
     a value label from a {it:varlist}, you specify a {cmd:.} after the
     {it:varlist}.  The old syntax to remove a value label from one variable
     continues to work.

{p 4 9 2}
{* enhancement}
28.  {help Mata} on 64-bit computers now supports matrices larger than 2
     gigabytes when the computer has sufficient memory.

{p 4 9 2}
{* enhancement}
29.  Mata's {helpb mf_j:J()} function, {opt J(r, c, val)}, now allows {it:val}
     to be specified as a matrix and creates an
     {it:r}{cmd:*rows(}{it:val}{cmd:)} {it:x} {it:c}{cmd:*cols(}{it:val}{cmd:)}
     result.  The third argument, {it:val}, was previously required to be 1
     {it:x} 1.  Behavior in the 1 {it:x} 1 case is unchanged.

{p 4 9 2}
{* fix}
30.  {helpb merge} would fail to report that the match variables did not
     uniquely identify observations in some cases.  This has been fixed.

{p 4 9 2}
{* fix}
31.  {helpb odbc insert} could fail with error {search r(682)} if no previous
     {cmd:odbc} commands had been executed in the current session.  This has
     been fixed.

{p 4 9 2}
{* fix}
32.  {helpb odbc insert} with 64 bit FreeDTS ODBC driver caused an unexpected
     error.  This has been fixed.

{p 4 9 2}
{* fix}
33.  Stata will now return an error when it cannot restore data due to
     insufficient memory.  Stata previously immediately exited.  A
     {helpb restore} can fail if commands are executed since the last
     {helpb preserve} that do not leave sufficient memory to restore the data.
     You can free up memory for data by performing a {helpb discard} before a
     {cmd:restore}.

{p 4 9 2}
{* fix}
34.  The Data Editor could fail to draw data after a graph preference dialog
     has been opened.  This only affected displaying the data in the Data
     Editor; it did not change the data.  This has been fixed.

{p 4 9 2}
{* fix}
35.  {cmd:c(changed)} and {cmd:r(changed)} are supposed to return a numeric
     scalar equal to 0 if the dataset in memory has not changed since it was
     last saved and 1 otherwise.  However, they incorrectly returned how many
     times the dataset in memory has changed since it was last saved.  This
     has been fixed.

{p 4 9 2}
{* fix}
36.  Stata would report an "unexpectedly out of memory" error when the
     {cmd:_b} and {cmd:_se} system variables were used within {it:=exp}
     expressions that were parsed by {helpb syntax}.  This has been fixed.

{p 4 9 2}
{* fix}
37.  Some ill-formed xml documents could crash Stata when {helpb xmluse} tried
     to read them.  This has been fixed.

{p 4 9 2}
{* fix}
38.  {help Stata/MP} with 16 or more processors and 300 or more variables
     could stop with an error message because of mistakenly calculating the
     number of processors to use for a certain size of problem.  This has been
     fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
39.  Stata updates now have a component for downloading and installing
     official utilities.  See {helpb update:update utilities}.

{p 4 9 2}
{* enhancement}
40.  Stata now has a mechanism for handling license initialization and updates
     under Windows Vista if
     User Account Control (UAC) is enabled.  This feature requires the above
     mentioned utilities to be installed.

{p 4 9 2}
{* enhancement}
41.  Programmable dialog boxes now have improved keyboard navigation.

{p 4 9 2}
{* fix}
42.  Batch jobs were interrupted if Stata's main window was maximized.  This
     has been fixed.

{p 4 9 2}
{* enhancement}
43.  {cmd:Ctrl+Shift+S} shortcut for {hi:Save As...} menu item in the Do-file
     Editor {hi:File} menu has been added.

{p 4 9 2}
{* fix}
44.  The Do-file Editor did not handle {cmd:\r\r\n} end of line sequences
     correctly.  This has been fixed.

{p 4 9 2}
{* fix}
45.  If necessary, the Results window will now maximize before processing
     commands from {helpb profilew:profile.do}.

{p 4 9 2}
{* fix}
46.  Pressing {cmd:Ctrl+9} crashed Stata.  This has been fixed.

{p 4 9 2}
{* fix}
47.  The background color of the Graph window is now controlled by the
     application background color, which is specified in the operating
     system's appearance settings.  This is typically gray by default.

{p 4 9 2}
{* fix}
48.  The {help graph editor:Graph Editor} did not display the extent of
     certain objects while dragging.  This has been fixed.

{p 4 9 2}
{* fix}
49.  Using {helpb graph export} to create a TIF image with a width greater
     than 5300 could cause Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
50.  Using {helpb graph export} to create a TIF or PNG image immediately after
     exporting to EMF or WMF could produce an image with a black area to the
     right of or beneath the graph.  This has been fixed.

{p 4 9 2}
{* fix}
51.  Specifying very small sizes for text in {helpb graph twoway} could cause
     the actual size of text rendered on the screen to be larger than
     expected.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
52.  You may now prevent Stata from notifying you that it has finished
     executing a command by bouncing the Stata icon in the Dock.  See
     {helpb notifyuser} for more information.

{p 9 9 2}
     Stata will no longer ignore Apple event messages directed at Stata while
     it is trying to notify you that Stata has finished executing a command.

{p 4 9 2}
{* enhancement}
53.  Stata now includes Mac OS 10.5 Quick Look support for do-files and
     ado-files.

{p 4 9 2}
{* enhancement}
54.  Stata can now use Growl ({browse "http://growl.info/about.php"}) to
     display notifications that Stata has finished executing a command when it
     is in the background.  If Growl is installed, Stata displays a short
     description of the command and the time that the command has been
     completed.

{p 4 9 2}
{* fix}
55.  The main Stata toolbar now recalls its size from the last time Stata was
     used.

{p 4 9 2}
{* fix}
56.  When running Stata in Mac OS X 10.5 (Leopard), clicking the Review or
     Variables window while a Viewer is visible can cause the Viewer to
     display the wrong font when the Viewer is later scrolled.  This has been
     fixed.

{p 4 9 2}
{* fix}
57.  Specifying very small sizes for text in {helpb graph twoway} could cause
     the actual size of text rendered on the screen to be larger than
     expected.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
58.  The Do-file Editor now encloses filenames with quotes when {helpb do}ing
     or {helpb run}ning a file.

{p 4 9 2}
{* fix}
59.  Pressing the {hi:Control}, {hi:Shift}, or {hi:Alt} keys would dismiss a
     {cmd:--more--} condition.  This has been fixed.

{p 4 9 2}
{* fix}
60.  Stata could not interpret non-ASCII characters entered into the Viewer,
     Data Editor, or Graph Editor.  This has been fixed.

{p 4 9 2}
{* fix}
61.  If the Review window has been sorted by commands, clicking on a command in
     the Review window would output the wrong command.  This has been fixed.

{p 4 9 2}
{* fix}
62.  Using {helpb graph export} to create a TIF image with a width greater
     than 5300 could cause Stata to crash.  This has been fixed.


{hline 8} {hi:update 22jan2008} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 7(4).

{p 5 9 2}
{* fix}
2.  Robust standard errors would not be computed for {helpb asmprobit},
    {helpb asroprobit}, {helpb asclogit}, and {helpb nlogit} if the model
    specification would result in a covariance matrix that had a dimension of
    200 or larger.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb cchart} and {helpb pchart} displayed the wrong number of units out
    of control when missing values were present in the first variable.  This
    has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb codebook} reported the longest value of a string variable as
    {cmd:str.} if it was larger than {cmd:str100}.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb destring}'s {cmd:dpcomma} option did not correctly convert European
    formatted numbers when you specified {cmd:ignore(".")}.  This has been
    fixed.

{p 5 9 2}
{* fix}
6.  {helpb dfuller} after an estimation command overwrote existing e-class
    macros.  Now previous estimation results are restored unless the
    {opt regress} option is used to display the regression table.

{p 5 9 2}
{* enhancement}
7.  New command {helpb ivregress postestimation##estatendog:estat endogenous},
    available after {helpb ivregress:ivregress 2sls} and {cmd:ivregress gmm},
    performs tests to determine whether endogenous regressors in the
    previously fitted model can in fact be treated as exogenous.  After GMM
    estimation, the C (difference-in-Sargan) statistic is reported.  After
    2SLS estimation, the Durbin and Wu-Hausman statistics or robust variants
    of them are reported.

{p 9 9 2}
    Also, if a cluster-robust weighting matrix was requested with
    {cmd:ivregress gmm}, {cmd:pweight}s were used, and the {opt vce()} option
    was not specified, a heteroskedasticity-robust VCE was incorrectly
    reported.  Now, a cluster-robust VCE is reported.

{p 5 9 2}
{* fix}
8.  The {cmd:beta()} option was mistakenly added to the documentation and
    dialog boxes for {helpb estat gof} and
    {helpb estat classification} after
    {helpb logistic}, {helpb logit}, and {helpb probit}.  The {cmd:beta()}
    option is not allowed, so the help files and dialog boxes have been fixed
    to reflect this.

{p 5 9 2}
{* fix}
9.  {helpb ivregress:ivregress gmm}, when a HAC VCE was used with two or more
    lags, {cmd:aweight}s were specified, and the dataset had gaps, would
    report incorrect results; this has been fixed.  Typically, the differences
    between the old and new results are under one percent.

{p 4 9 2}
{* fix}
10.  Dialog boxes for {helpb lnskew0} and {helpb bcskew0} did not allow the
     default confidence level to be calculated. This has been fixed.

{p 4 9 2}
{* fix}
11.  For large datasets, {helpb lpoly} would sometimes issue
     {helpb m2_errors:error 3900}, the "out of memory" error, when computing
     standard errors.  To alleviate this problem, the code was modified to
     avoid creating a large temporary matrix that arises in the intermediate
     computations.

{p 4 9 2}
{* fix}
12.  {helpb merge} with the {cmd:sort} option previously implied the
     {cmd:unique} option.  {cmd:unique} is now implied only if
     {cmd:uniqmaster} or {cmd:uniqusing} is not specified.

{p 4 9 2}
{* fix}
13.  {helpb mfx} no longer requires you to use the {opt force} option to
     obtain the standard errors of the marginal effects when used after
     {helpb ivprobit} and {helpb ivtobit}.  Also, the marginal effects with
     respect to the additional instruments, which are identically zero, are no
     longer displayed.

{p 4 9 2}
{* fix}
14.  {helpb prais} and {helpb newey} did not work with the {opt by} prefix.
     This has been fixed.  Also, {cmd:newey} would exit with an error message
     when used with a dataset that was {helpb tsset} in an earlier version of
     Stata and no {cmd:tsset} command was issued prior to calling {cmd:newey}.
     This has also been fixed.

{p 4 9 2}
{* fix}
15.  {helpb nlsur_postestimation##predict:predict}, when used after
     {helpb nlsur}, would exit with an error message if the {opt residual}
     option was specified and the {opt equation()} option was not specified.
     This has been fixed.

{p 4 9 2}
{* enhancement}
16.  {help prefix:Prefix} commands that use the
     {helpb _prefix:_prefix_command} parsing tool now accept the {cmd:using}
     clause in the prefixed command.  This affects the following Stata
     commands: {helpb bootstrap}, {helpb jackknife}, {helpb nestreg},
     {helpb permute}, {helpb rolling}, {helpb simulate}, {helpb statsby},
     {helpb stepwise}, and {helpb svy}.

{p 4 9 2}
{* enhancement}
17.  {help qc} commands ({cmd:cchart}, {cmd:pchart}, {cmd:rchart},
     {cmd:xchart}, {cmd:shewhart}) now have a {cmd:nograph} option to suppress
     the display of the graph.  These commands also now return in {cmd:r()}
     the relevant values displayed in the charts.  In addition, {helpb rchart}
     has the option {cmd:generate()} to save the variables plotted in the
     chart.

{p 4 9 2}
{* fix}
18.  Under Windows, {helpb saveold} would return an error when trying to save
     to a UNC path (that is, \\computername\path...).  This has been fixed.

{p 4 9 2}
{* enhancement}
19.  {helpb sktest} now returns a matrix of the test results, {cmd:r(Utest)}.

{p 4 9 2}
{* fix}
20.  {helpb ssc:ssc whatshot} did not work when
     {helpb varabbrev:set varabbrev} had been turned off.  This has been
     fixed.

{p 4 9 2}
{* fix}
21.  {helpb svy} regression model commands were marking out observations that
     had missing values in the independent variables even for observations
     outside the subpop.  These observations should be considered part of the
     estimation sample for subpopulation variance estimation.  This has been
     fixed.

{p 4 9 2}
{* fix}
22.  {helpb xtgls} would not report the log-likelihood or save {cmd:e(ll)}
     when homoskedasticity and no correlation were assumed, even though the
     resulting model is maximum likelihood.  This has been fixed.


{hline 8} {hi:update 13nov2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  New command {helpb ssc:ssc whatshot} lists the most popular user-written
    packages available for download at the SSC.  By default, the top ten
    packages are listed.  Typing {cmd:ssc whatshot, n(15)} would list the top
    fifteen.  (SSC is the premier Stata download site for user-written
    software on the web.  Additions to Stata available there range from
    spectacular to idiosyncratic.  If you have not looked at what is available
    on the SSC, you should.)

{p 5 9 2}
{* fix}
2.  For commands {helpb nl} and {helpb nlsur}, when a substitutable expression
    included the syntax for a linear combination of variables and a minus sign
    preceded that linear combination, the minus sign would be applied to only
    the first variable's coefficient.  This caused the remaining variables'
    coefficients to be displayed with the wrong sign but did not affect any
    other results.  This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
3.  Text that has been copied and pasted in the Do-file Editor could appear
    incorrectly formatted.  A do-file created in Windows and opened in the
    Do-file Editor would have a blank line appended after every line in the
    do-file.  These problems have been fixed.

{p 5 9 2}
{* fix}
4.  On Mac OS X 10.5, selecting a menu item from the Graph Editor's contextual
    menu could lead to unexpected results.  This has been fixed.


{hline 8} {hi:update 29oct2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb codebook} failed when variable labels started with a right single
    quote or had a left single quote within the variable label.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
2.  {helpb fracpoly} and {helpb mfp} have been updated to now work with
    {helpb intreg}.

{p 5 9 2}
{* fix}
3.  {helpb stphplot} did not allow version 9 syntax even when called under
    version control.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb xtpoisson} with time-series operators produced poorly labeled
    output.  This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
5.  The Do-file Editor might crash while executing selected text.  This has
    been fixed.  The horizontal scrollbar might fail to completely scroll in
    text from the left edge of the window when using a scroll wheel that
    supports horizontal scrolling.  This has been fixed.


{hline 8} {hi:update 15oct2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Dialog boxes that accept {helpb constraint:constraints} now provide a tool
    for managing them.

{p 5 9 2}
{* enhancement}
2.  {helpb destring} now has a {opt dpcomma} option for handling variables
    with commas as decimal points.

{p 5 9 2}
{* fix}
3.  {helpb egen} now displays a better error message if the {cmd:egen}
    function you specify does not exist.

{p 5 9 2}
{* fix}
4.  Marginal effects computed by {helpb estat mfx} after {helpb asmprobit} and
    {helpb asroprobit} were incorrect if {cmd:estat mfx} computed the means or
    medians of nonbinary case variables and the data were unbalanced (not all
    cases having the same alternatives).  The severity of the error increased
    with the degree of alternative imbalance.  This has been fixed.

{p 5 9 2}
{* fix}
5.  Marginal effects computed by {helpb estat mfx} after {helpb asmprobit} and
    {helpb asroprobit} failed if {cmd:intmethod(random)} was used during
    estimation.  This has been fixed.

{p 5 9 2}
{* fix}
6.  Using the {helpb graph editor} to edit a bar label of a
    {help graph bar:bar graph} after using the editor to change graph
    orientation, add bar labels, reverse the scale, stack bars, include
    missing categories, switch to dot plot, graph percentages, include 0 in y
    axis, change bar spacing, or sort bars produced a graph that could not be
    used after being saved to disk as a .gph file.  This has been fixed.

{p 5 9 2}
{* fix}
7.  When adding text to a graph using the
    {help graph editor##text_tool:Graph Editor's Text Tool}, the properties
    of the tool could not be changed once the tool had been used to add text.
    This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb graph matrix} did not allow apostrophes in
    {help graph title:titles}, subtitles, notes, or captions.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb icd9}'s database has been updated to use codes through the V25
    update of Oct. 1, 2007.

{p 4 9 2}
{* fix}
10.  The fix to scores after {helpb ivprobit} and {helpb ivtobit} that was
     made on 30Aug2007 had an unreported implication.  Prior to that change,
     when {cmd:ivprobit} or {cmd:ivtobit} were run on {help svy:survey data},
     the reported standard errors were incorrect.  This was fixed as of the
     30Aug2007 update.

{p 4 9 2}
{* fix}
11.  {helpb ivregress} could choose the wrong number of lags when a HAC VCE
     with automatic bandwidth selection was requested.  This has been fixed.

{p 4 9 2}
{* fix}
12.  The maximum likelihood version of {helpb ivtobit} reported incorrect
     results when the censoring point was nonzero or when both left- and
     right-censoring points were specified.  This has been fixed.

{p 4 9 2}
{* fix}
13.  Mata's {helpb mf_optimize:optimize()} function with a type {cmd:v0}
     evaluator and the {cmd:bhhh} technique would report a conformability
     error and terminate execution.  This has been fixed.

{p 4 9 2}
{* fix}
14.  Mata's {helpb mata optimize():optimize()} function with type
     {opt v1debug} evaluators reported that the evaluator did not compute a
     Hessian matrix when it should have just ended the derivative-comparison
     report.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb ml model} with the {opt svy} option neglected to mark out
     observations where only the survey design variables contained missing
     values.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb nlogit} would drop cases that had more than 100 alternatives.
     This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb nbreg postestimation##predict:predict} with the {cmd:stdplna}
     option after {helpb gnbreg} created a variable containing the predicted
     number of events instead of the standard error of the predicted
     ln(alpha).  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb stcox_postestimation##predict:predict} with the {opt scores}
     option after {helpb stcox} reported the error "option none not allowed"
     when there were no tied failure times.  This had been fixed.

{p 4 9 2}
{* fix}
19.  {helpb stcox_postestimation##predict:predict} with the {opt scores}
     option is no longer allowed with {helpb stcox} results that used the
     {opt tvc()} option.  The {opt scores} option now requires that the data
     be {helpb stsplit} so that the extra observations may be used to fully
     generate the requested partial efficient score residuals.

{p 4 9 2}
{* fix}
20.  {helpb rreg} reported a "no observations" error when the weights in the
     biweight iterations were all set to zero.  Now {cmd:rreg} reports that
     all the weights were set to zero in the error message.

{p 4 9 2}
{* fix}
21.  {helpb stcox} will no longer allow option {opt tvc()} to be combined with
     any of the following variable-generating functions:  {opt basechazard()},
     {opt basehc()}, {opt basesurv()}, {opt effects()}, {opt esr()},
     {opt mgale()}, {opt scaledsch()}, and {opt schoenfeld()}.  These options
     require that the data be {helpb stsplit} in order to generate the
     requested information.  The {opt tvc()} and {opt texp()} options are not
     allowed with the {helpb svy} prefix.

{p 4 9 2}
{* fix}
22.  {helpb stcox:svy: stcox} and {helpb streg:svy: streg} reported a "no
     observations" error when a string variable was used in the {opt id()}
     option of {helpb stset}.  This has been fixed.

{p 4 9 2}
{* fix}
23.  {helpb sts graph} options that affect the colors of confidence bands now
     apply the exact color specified rather than attenuating the specified
     color to a lighter shade.

{p 4 9 2}
{* fix}
24.  {helpb sts graph} did not respect {opt ciopts(recast(rarea))}.  This has
     been fixed.

{p 4 9 2}
{* fix}
25.  {helpb svy jackknife} reported incorrect values in {cmd:e(b_jk)} when
     the {opt mse} option was not used.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
26.  New {helpb creturn:c()} return value {cmd:c(tmpdir)} has been added; it
     returns a string containing the temporary directory being used by Stata.

{p 4 9 2}
{* enhancement}
27.  Options {cmd:nrtolerance(}{it:#}{cmd:)} and {cmd:nonrtolerance} have been
     added to estimation commands {helpb bprobit}, {helpb blogit},
     {helpb cnreg}, {helpb dprobit}, {helpb factor}, {helpb logit},
     {helpb mlogit}, {helpb ologit}, {helpb oprobit}, {helpb probit},
     {helpb rologit}, {helpb stcox}, and {helpb tobit}.  The default is
     {cmd:nrtolerance(1e-5)}.  Moreover, the iteration log will display
     "(backed up)" whenever more than 5 step halves have been taken to
     complete a step.

{p 4 9 2}
{* enhancement}
28.  Mata's {helpb mf_sort:order()} function allowed up to 500 columns of a
     matrix to be used for generating a permutation vector.  This limit has
     been removed; thus, more than 500 columns of a matrix can be used for
     generating a permutation vector.

{p 4 9 2}
{* enhancement}
29.  Mata's {helpb mf_sort:sort()} and {cmd:_sort()} functions sorted the rows
     of a matrix based on up to 500 of its columns.  This limit has been
     removed; thus, a matrix can be sorted based on more than 500 of its
     columns.

{p 4 9 2}
{* enhancement}
30.  The default amount of memory allocated to ado files was increased from
     500 kilobytes to 1 megabyte.

{p 4 9 2}
{* fix}
31.  Discrete choice programs {helpb asclogit}, {helpb asmprobit},
     {helpb asroprobit}, and {helpb nlogit} did not drop the temporary
     variables that encode the case-specific (cs) variables crossed with
     alternative indicators that were collinear, nor did it drop
     alternative-specific variables that were collinear with these cs
     temporary variables.  This has been fixed.

{p 4 9 2}
{* fix}
32.  {helpb expoisson} now scales the exposure or offset variable to help
     prevent numerical overflow or underflow from occurring when computing the
     relative weights associated with the sufficient statistics.

{p 4 9 2}
{* fix}
33.  {helpb logistic} displayed untransformed confidence limits in the table
     of estimated coefficients when the exponentiated coefficients (odds
     ratios) resulted in missing values.  {cmd:logistic} now reports missing
     confidence limits in this case.

{p 4 9 2}
{* fix}
34.  {helpb mlogit} could crash Stata/MP if the number of variables times the
     number of outcomes exceeded {help matsize}. This has been fixed.

{p 4 9 2}
{* fix}
35.  {helpb odbc} read in BIGINT storage types as LONGs.  It now reads in
     BIGINTs as strings.

{p 4 9 2}
{* fix}
36.  {helpb odbc} truncated strings longer than 243 characters to 243
     characters.  This has been fixed.

{p 4 9 2}
{* fix}
37.  Date/time variables were not formatted correctly if you specified a
     varlist with {helpb odbc load}.  This has been fixed.

{p 4 9 2}
{* fix}
38.  {helpb regress} with {opt iweight}s that sum to a value less than one
     would crash Stata.  This has been fixed.

{p 4 9 2}
{* fix}
39.  The {cmd:stata hidden} command in
     {help dialog_programming:programmable dialog} boxes now respects version
     number so that if version is less than 10 the command behaves as it did
     in Stata 9, which is a potentially dangerous mix of the current
     {cmd:stata} {cmd:hidden} {cmd:immediate} and {cmd:stata} {cmd:hidden}
     {cmd:queue} that immediately executes the command while continuing to
     poll.  See {help dialog_programming:programmable dialog} for details on
     {cmd:stata} {cmd:hidden}.

{p 4 9 2}
{* fix}
40.  The maximum table dimension for Fisher's exact test,
     {cmd:tabulate, exact}, is 20 for Stata/IC and 80 for Stata/SE and
     Stata/MP.  These are the column limits for {helpb tabulate twoway} (see
     {help limits}).

{p 4 9 2}
{* fix}
41.  An undetected integer overflow in the algorithm implementing Fisher's
     exact test was possible in rare cases involving large tables (see
     {helpb tabulate twoway}).  In this situation, the algorithm failed,
     reporting 0 enumerations at all stages of the enumeration log, and
     reporting a p-value of 0.  This has been fixed.

{p 4 9 2}
{* fix}
42.  {helpb translate:translator set pagesize} did not set the correct page
     height or width for the page type (legal, a4, etc.).  This has been
     fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
43.  {hi:Change Working Directory} has been added to the {hi:File} menu making
     it consistent with the Unix and Mac versions.

{p 4 9 2}
{* fix}
44.  {helpb autotabgraphs:set autotabgraphs on} did not have an effect with
     {help floatwindows:floating windows} enabled.  This has been fixed.

{p 4 9 2}
{* fix}
45.  In certain circumstances with {help floatwindows:floating windows}
     enabled, dockable windows could become unresponsive.  This has been
     fixed.

{p 4 9 2}
{* fix}
46.  The Graph Editor did not allow switching between tabbed graphs while in
     edit mode.  This has been fixed.

{p 4 9 2}
{* fix}
47.  Using the Graph Editor with the main Stata window minimized would produce
     debug output in the Results window.  This has been fixed.

{p 4 9 2}
{* fix}
48.  Saving the contents of the Review window to a do-file would create a file
     with mixed end-of-line characters (\r\r\n).  In Stata 10, the Do-file
     Editor will not handle this sequence.  The Review window now does not
     write do-files with mixed end-of-line characters.

{p 4 9 2}
{* fix}
49.  The tooltip for the "Run" button did not change to "Run Selected Lines"
     when lines were selected in the Do-file Editor.  This has been fixed.

{p 4 9 2}
{* fix}
50.  The tab navigation key, the "Enter" key, and the "Esc" key were not
     working in the Find/Replace dialog of the Do-file Editor.  This has been
     fixed.

{p 4 9 2}
{* fix}
51.  "Replace All" was not reporting the number of changes being made in the
     Find/Replace dialog of the Do-file Editor.  This has been fixed.

{p 4 9 2}
{* fix}
52.  The naming convention for a new do-file is "Untitled%d".  The number was
     not unique among different do-file editors.  This has been fixed.

{p 4 9 2}
{* fix}
53.  The list of recent files in the Do-file Editor was not saved in the
     Windows registry.  This has been fixed.

{p 4 9 2}
{* fix}
54.  The main window was displayed a few pixels outside of the screen after it
     was maximized in the previous Stata session.  This has been fixed.

{p 4 9 2}
{* fix}
55.  (Windows Vista) Under certain circumstances, File dialogs launched by
     Stata did not render correctly.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
56.  The Do-file Editor's Find/Replace dialog will now stay visible until the
     dialog is canceled.  A button named "Replace and Find" has been added
     that replaces the search text then finds the next occurrence of the search
     text.

{p 4 9 2}
{* enhancement}
57.  {cmd:window manage prefs} {{cmd:load} | {cmd:save}} has been added.  See
     {helpb window manage} for more information.

{p 4 9 2}
{* enhancement}
58.  The variables dropdown list control from Stata's programmable dialogs now
     supports smooth scrolling devices such as Apple's Mighty Mouse and
     MacBook trackpads for scrolling.  The control will also display variable
     names with font smoothing.

{p 4 9 2}
{* enhancement}
59.  Ctrl-D has been added as a keyboard shortcut for {bf:File} > {bf:Do}...

{p 4 9 2}
{* fix}
60.  The Variables window can no longer be sorted by clicking the Format
     column header.

{p 4 9 2}
{* fix}
61.  Saving graphs in the PICT format using {helpb graph export} or the Save
     dialog would cause Stata to crash.  The {cmd:fontface()}
     option had no effect on graphs exported in the PICT format using
     {cmd:graph export}.  Both problems have been fixed.

{p 4 9 2}
{* fix}
62.  Dragging and dropping a graph will now export a graph in the PICT format
     if the Copy as PICT general preference is enabled.

{p 4 9 2}
{* fix}
63.  The Do-file Editor will no longer display the Save dialog to save a file
     that was opened by using the {helpb doedit} command.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
64.  The Do-file Editor's Find/Replace dialog will now stay visible until the
     dialog is canceled.  A button named "Replace and Find" has been added
     that replaces the search text then finds the next occurrence of the search
     text.

{p 4 9 2}
{* enhancement}
65.  {cmd:window manage prefs} {{cmd:load} | {cmd:save}} has been added.  See
     {helpb window manage} for more information.

{p 4 9 2}
{* enhancement}
66.  Programmable dialog boxes now attempt to scale based on the window
     manager's selected font.

{p 4 9 2}
{* fix}
67.  The Do-file Editor was saving do-files with UTF-8 rather than with a
     Latin-1 text encoding.  This could cause mistakes in alignment of output
     when attempting to run or do the do-file from Stata if the do-file
     contained non-ASCII characters.  This could also cause incorrect results
     in determining string lengths if the string contained non-ASCII
     characters.  This did not affect data or numerical results and has been
     fixed.

{p 4 9 2}
{* fix}
68.  The Do-file Editor will no longer display the Save dialog to save a file
     that was opened by using the {helpb doedit} command.

{p 4 9 2}
{* fix}
69.  Stata will now bring a dialog back to the front of the main Stata window
     after you click on the Variables window to enter a variable name into the
     dialog.

{p 4 9 2}
{* fix}
70.  The Command window was passing commands entered into Stata with UTF-8
     rather than Latin-1 text encoding.  This has been fixed.

{p 4 9 2}
{* fix}
71.  Stata would cause GDK warning messages to appear if a command was entered
     into the Command window that contained non-ASCII characters.  This has
     been fixed.


{hline 8} {hi:update 19sep2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 7(3).


{hline 8} {hi:update 30aug2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb bootstrap} failed to check for {helpb stset} weights when the
    prefixed command had the "st" program property.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb codebook} with the {cmd:compact} option could alter the sort order
    of the data.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb corr2data} now requires the number of rows and columns in the
    matrix specified in the {cmd:corr()} and {cmd:cov()} options be equal to
    the number of new variables given.

{p 5 9 2}
{* fix}
4.  Dialog boxes for {cmd:estat} after {helpb arch} and {helpb arima} did not
    exist.  This has been fixed.

{p 5 9 2}
{* enhancement}
5.  {helpb exlogistic} and {helpb expoisson} no longer restrict the
    {cmd:memory(}{it:#}{cmd:)} option to a maximum of 512 megabytes.

{p 5 9 2}
{* fix}
6.  Changes made on the {bf:Organization} tab of the {bf:Legend}
    {bf:properties} dialog in the {help Graph Editor} no longer reset the
    label text for each key to its original value.  Now whether you change a
    label's text before a reorganization or after a reorganization the
    resulting legend is the same.

{p 5 9 2}
{* fix}
7.  When using the {help Graph Editor} to edit bar graphs, edits to the text
    of bar labels or changes to a bar label's {bf:Object-specific}
    {bf:properties} were ignored if the graph were saved and then restored.
    This has been fixed.

{p 5 9 2}
{* fix}
8.  When editing time-series graphs, reference lines could not be added
    directly to the plotregion by specifying a date.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb ivregress} exited with an error if the model did not contain any
    exogenous regressors or a constant term and the GMM or LIML estimator was
    used.  This has been fixed.  Also, when the {opt igmm} option was used, an
    error message would be printed before the iteration log; this too has been
    fixed.

{p 4 9 2}
{* fix}
10.  The dialog box for {helpb kdensity} did not output the {opt kernel()}
     option correctly.  This has been fixed.

{p 4 9 2}
{* fix}
11.  Mata's {helpb mf_optimize:optimize()} function
     {cmd:optimize_init_singularHmethod(}{it:S}{cmd:,"m-marquardt")} would
     sometimes exit with the error "Hessian is not negative semidefinite" (or
     "Hessian is not positive semidefinite" for minimization) when a Hessian
     matrix was not concave (convex).  This has been fixed.

{p 4 9 2}
{* fix}
12.  Mata's {helpb mf_optimize:optimize_result_V_robust()} function could
     result in a nonsymmetric matrix.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb ml} with the {helpb vce_option:vce(cluster {it:clustvar})} option
     reported an incorrect value in {cmd:e(rank)} when there were fewer
     clusters than model coefficients.  This affected the results in
     {helpb estat ic} and {helpb estimates stats}, resulting in larger AIC and
     BIC values than should have been reported.  This has been fixed.

{p 4 9 2}
{* fix}
14.  Dialog boxes for {helpb nestreg} and {helpb stepwise} could issue
     unnecessary error messages.  This has been fixed.

{p 4 9 2}
{* fix}
15.  The {helpb personal} command would fail on Mac platforms when the
     {opt dir} option was specified.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb predict} with the {cmd:scores} option produced incorrect scores
     following {helpb ivprobit} and {helpb ivtobit}.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb sample} with an {helpb if} qualifier and the {opt by()} option
     (or {helpb by} prefix) failed to keep the correct number of observations
     in all {cmd:by} groups.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb stepwise} with {helpb streg} and parentheses binding the first
     predictor variable caused the "must specify distribution()" error even
     when the {opt distribution()} option was specified.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb xtlogit}, {helpb xtprobit}, {helpb xtcloglog}, {helpb xtintreg},
     {helpb xttobit}, and {helpb xtpoisson:xtpoisson, re normal} now use
     stable sorts for internal computations.  This makes their results
     perfectly reproducible from run to run so long as the user does not
     resort the data.  Previously, with some particularly difficult datasets,
     it was possible for the results to differ slightly from run to run.

{p 4 9 2}
{* fix}
20.  The dialog box for {helpb xtreg} failed to generate a command.  This has
     been fixed.


{hline 8} {hi:update 30jul2007} {hline}

    {title:Stata executable, Unix (GUI)}

{p 5 9 2}
{* fix}
1.  Some child dialog boxes did not respond to user input following
    the 25 Jul 2007 update.  This occurred only on Unix platforms and primarily
    affected some of the dialog boxes in the Graph Editor.  This has been
    fixed.


{hline 8} {hi:update 25jul2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb mfx} with a long {cmd:at()} list sometimes produced an erroneous
    warning message that at-list variables were not found in the estimation.
    This has been fixed.

{p 5 9 2}
{* enhancement}
2.  {cmd:renpfix} now returns a list of the variables it changed in
    {cmd:r(varlist)}.

{p 5 9 2}
{* fix}
3.  {helpb sqreg} did not allow quantiles specified beyond two digits of
    precision.  This has been fixed.

{p 5 9 2}
{* fix}
4.  In certain circumstances, {helpb sts graph} did not respect the
    {opt aspectratio()} option.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb xtlogit} with either option {cmd:fe} or {cmd:pa}, and
    {helpb xtprobit} with option {cmd:pa}, always exited with an error when
    used under version control with version less than 10.  This has been
    fixed.

{p 5 9 2}
{* fix}
6.  {helpb xtreg:xtreg, fe cluster()} used incorrect model F test numerator
    degrees of freedom when the robust coefficient covariance matrix was not
    positive definite.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
7.  {helpb matrix dissimilarity} option {cmd:dissim()} now has synonym
    {cmd:s2d()} for consistency with other commands that have similarity
    measures as options.

{p 5 9 2}
{* fix}
8.  Some graph objects in the Graph Editor could not be deleted by pressing
    the Delete key. They could be deleted only by selecting Object > Delete or
    right-clicking on the object and selecting Delete.  This has been fixed.

{p 5 9 2}
{* fix}
9.  Child dialogs did not work correctly if an alternate name was specified
    when the parent dialog box was launched.  This has been fixed.

{p 4 9 2}
{* fix}
10.  Dialog boxes with filenames longer than 28 characters could crash Stata.
     Filenames longer than 28 characters are therefore no longer allowed.

{p 4 9 2}
{* fix}
11.  The Value Label dialog did not allow value labels to contain spaces.
     This has been fixed.

{p 4 9 2}
{* fix}
12.  Stata previously did not update the Variables window when variable names
     with the underscore character as the first character were dropped.  This
     has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
13.  {helpb graph export} using PNG and TIFF did not work if the {opt width()}
     or {opt height()} option was specified.  This has been fixed.

{p 4 9 2}
{* fix}
14.  When the user clicked in the Variables window, variables were always
     pasted at the end of the text in the Command window.  This has been fixed
     so that variables will be pasted at the position of the cursor.

{p 4 9 2}
{* fix}
15.  Under certain circumstances, the right-click context menu for the Command
     window did not have Cut, Copy, and Delete enabled when they should have
     been.  This has been fixed.

{p 4 9 2}
{* fix}
16.  The area to the right and beneath a Stata graph did not always render
     correctly when the graph was initially drawn.  This has been fixed.

{p 4 9 2}
{* fix}
17.  When used on systems with a secondary display device, Stata could attempt
     to position itself on that device even if the device was not connected
     the next time Stata was started. This issue affected primarily laptops
     that are sometimes connected to a docking station. This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
18.  Stata 10 now uses Mac OS X's Pasteboard for copying images from Stata to
     the Clipboard.  This allows Stata to copy images in the PDF format.
     However, some older applications do not yet support the Pasteboard.
     Stata can now revert to the old method of copying images to the Clipboard
     in the PICT format by using {cmd:set copyaspict} for such
     applications.

{p 4 9 2}
{* fix}
19.  The File > Import menu was mistakenly enabled when Stata was modal and
     disabled when Stata was not modal.  This has been fixed.

{p 4 9 2}
{* fix}
20.  Printing a preview of a graph drew the graph in the Graph window rather
     than the Preview window.  This has been fixed.

{p 4 9 2}
{* fix}
21.  Selecting lines in the Do-file Editor and selecting Do or Run executed
     the whole do-file rather than just the lines selected if the do-file had
     been saved.  This has been fixed.

{p 4 9 2}
{* fix}
22.  Stata 10 for Mac now looks in the
     "Library/Application Support/Stata" subdirectory of your home directory
     to search for your personal ado-directory.  The console version of Stata
     10 for Mac was still using the old location, your home directory,
     to search for your personal ado-directory.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
23.  Stata for Unix(GUI) can now copy graphs as a bitmap to the Clipboard.  A
     Copy Graph menu item in the Edit menu and contextual menu, as well as a
     toolbar button, has been added to the Graph window to allow copying of
     graphs.

{p 4 9 2}
{* fix}
24.  Stata for Unix(GUI) could have problems executing properly on setups with
     non-U.S. English locales.  Stata now sets the locale to the traditional
     Unix system behavior within its own process without affecting the rest of
     the system.

{p 4 9 2}
{* fix}
25.  Sixty-four-bit HP Itanium systems had problems running the GUI version of
     Stata 10 because of a missing shared library.  This has been fixed.

{p 4 9 2}
{* fix}
26.  Some Sun Solaris systems had problems running the GUI version of Stata 10
     for Solaris.  Stata 10 has been rebuilt with libraries that offer better
     compatibility with various Solaris systems.

{p 4 9 2}
{* fix}
27.  On Solaris machines with more than 255 fonts, Stata reported that it
     could not open the default font configuration file, even though the file
     existed and the user had the correct permissions.  This has been fixed.


{hline 8} {hi:update 12jul2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb arch} now allows you to fit models assuming that the disturbances
    follow Student's t distribution or the generalized error distribution, as
    well as the Gaussian (normal) distribution.  Specify which distribution to
    use with the {opt distribution()} option.  You can specify the shape or
    degree-of-freedom parameter, or you can let {cmd:arch} estimate it along
    with the other parameters of the model.

{p 5 9 2}
{* fix}
2.  {helpb arch} stored an incorrect p-value in {cmd:e(p)}, though this did
    not affect the displayed results.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb asmprobit} and {helpb asroprobit} did not include the case variable
    when setting the estimation-data signature.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb exlogistic} no longer reports p-values for joint tests (as
    specified in option {cmd:terms()}) using the default method of sufficient
    statistics.  They were inappropriate because in multiple dimensions there
    is no natural ordering of the sufficient statistics.  Add option
    {cmd:test(score)} or option {cmd:test(probability)} to obtain p-values
    using alternate methods.  This can be done either at estimation or on
    replay.


{hline 8} {hi:update 03jul2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 7(2).

{p 5 9 2}
{* enhancement}
2.  Edits made in the {help graph editor} may now be undone or redone any
    time in the current Stata session, even if the editor is stopped and then
    restarted.

{p 5 9 2}
{* fix}
3.  The indicator that a graph has been edited in the {help graph editor} now
    turns off when all edits have been undone.

{p 5 9 2}
{* fix}
4.  {helpb estat firststage} after {helpb ivregress} exited with an error when
    the model contained time-series operators.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb nlogitgen} did not allow the alternatives variable to be of type
    string.  Now it does.  The new alternatives variable generated by
    {cmd:nlogitgen} is now generated as an {cmd:int} instead of a {cmd:float}.

{p 5 9 2}
{* fix}
6.  The variable {bf:trunc} automatically created by {helpb uselabel} could
    contain missing ({cmd:.}) when it should contain {cmd:0} if {cmd:uselabel}
    encountered more than 100 label mappings.  This has been fixed.


{hline 8} {hi:update 26jun2007} {hline}

    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
1.  {helpb exlogistic}, in the unusual case where the problem was large
    and the {cmd:memory()} option was set to its maximum of {cmd:512m},
    could crash Stata.  This has been fixed.

{p 5 9 2}
{* fix}
2.  Multiple new-line characters in a string could cause Mata's
    {helpb mf_printf:printf()} function to enter an endless loop.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  On very-high-resolution displays, the Data Editor could not display
    more than 20 columns at a time.  This has been fixed.


    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
4.  Exporting graphs as PNG or TIF files could produce an image with a
    black area to the right of or beneath the graph.  This has been fixed.

{p 5 9 2}
{* fix}
5.  The file dialog for saving commands from the Review Window could
    fail to append the file extension.  This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
6.  The Variables window would show temporary variables that no longer
    exist after some commands.  This has been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew9to10}.{p_end}

{hline}
