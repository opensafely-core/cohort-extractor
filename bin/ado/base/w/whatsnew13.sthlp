{smcl}
{* *! version 1.2.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 13}

{pstd}
This file records the additions and fixes made to Stata during the 13.0 and
13.1 releases:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {help whatsnew14}       Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
    {c |} {help whatsnew13to14}   Stata 14.0 new release       2015            {c |}
    {c |} {bf:this file}        Stata 13.0 and 13.1          2013 to 2015    {c |}
    {c |} {help whatsnew12to13}   Stata 13.0 new release       2013            {c |}
    {c |} {help whatsnew12}       Stata 12.o and 12.1          2011 to 2013    {c |}
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
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 8} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew13to14}.


{hline 8} {hi:update 16dec2016} {hline}

{p 5 9 2}
1.  (Mac) macOS Sierra 10.12.2 introduced a change that caused Stata's Do-file
    Editor to crash.  This has been fixed.


{hline 8} {hi:update 25jul2016} {hline}

{p 5 9 2}
1.  Stata has been updated to account for the leap second that was added by
    the International Earth Rotation and Reference Systems Service (IERS) on
    June 30, 2015, and for the leap second that will be added by IERS on
    December 31, 2016.  Stata's datetime/C UTC date format now recognizes
    30jun2015 23:59:60 and 31dec2016 23:59:60 as valid times.

{p 5 9 2}
2.  {helpb sem_estat_teffects:estat teffects} did not correctly compute the
    standard errors for total and indirect effects between endogenous
    variables.  This has been fixed.


{hline 8} {hi:update 10mar2016} {hline}

{p 5 9 2}
1.  The multilevel mixed-effects estimators {helpb gsem_command:gsem},
    {helpb meglm}, {helpb melogit}, {helpb meprobit}, {helpb meologit},
    {helpb meoprobit}, {helpb mepoisson}, and {helpb menbreg} have the
    following improvement and fix:

{p 9 13 2}
     a.  {cmd:gsem}, {cmd:meglm}, {cmd:melogit}, {cmd:meprobit},
         {cmd:meologit}, {cmd:meoprobit}, {cmd:mepoisson}, and {cmd:menbreg}
         are now more likely to converge for models fit to data with large
         group sizes.

{p 9 13 2}
     b.  {cmd:gsem}, {cmd:meglm}, {cmd:melogit}, {cmd:meprobit},
         {cmd:meologit}, {cmd:meoprobit}, {cmd:mepoisson}, and {cmd:menbreg},
         when used with datasets that had many observations per group, could
         indicate that the model converged and report results that did not
         include the large groups in the computations.  To determine whether
         your model was affected, you can use {cmd:predict} to obtain
         empirical Bayes mean estimates for the random effects and check for
         zero values in large groups.  This has been fixed.

{p 5 9 2}
2.  After the 12nov2015 update, {helpb xtlogit} and {helpb xtprobit} with
    option {cmd:vce(robust)} or option {cmd:vce(cluster} {it:panelvar}{cmd:)},
    when perfect predictors caused a reduction in the sample size, reported
    incorrect standard errors.  This has been fixed.


{hline 8} {hi:update 09dec2015} {hline}

{p 5 9 2}
1.  {helpb fp:fp generate}, when qualifier {cmd:if} was specified with an
    {help exp:expression} containing quotation marks (""), incorrectly exited
    with error message "{err:invalid expression}".  This has been fixed.

{p 5 9 2}
2.  {cmd:predict} after {helpb gsem_command:gsem}, {helpb meologit}, or
    {helpb meoprobit}, when {it:depvar}'s outcomes were not contiguous values
    starting at {cmd:1} and when the requested prediction required empirical
    Bayes estimates, incorrectly exited with error message
    "{err:could not compute empirical Bayes' means;}
    {err:missing values were returned by the evaluator}".  This has been
    fixed.

{p 5 9 2}
3.  (Mac) The Do-file Editor, when executing a selection of lines and when the
    selected lines were preceded by lines that contained Unicode characters,
    executed the wrong lines.  This has been fixed.

{p 5 9 2}
4.  (Mac) In the Update dialog, clicking on the link for manual updates did
    not open the "Keeping Stata 13 up to date" webpage.  This has been fixed.


{hline 8} {hi:update 12nov2015} {hline}

{p 5 9 2}
1.  {helpb collapse} has the following fixes:

{p 9 13 2}
     a.  {cmd:collapse} with option {opt percent} and missing values in a
         {opt by()} variable used the wrong denominator to calculate the
         percentages.  This has been fixed.

{p 9 13 2}
     b.  {cmd:collapse} with option {opt percent} and {cmd:iweight}s used the
         unweighted total instead of the weighted total to calculate the
         percentages.  This has been fixed.

{p 9 13 2}
     c.  {cmd:collapse} with option {opt percent} and {cmd:aweight}s ignored
         the specified weights.  This has been fixed.

{p 5 9 2}
2.  {helpb contrast} with the observation-weighted orthogonal polynomial
    operators {cmd:pw(}{it:numlist}{cmd:).} and
    {cmd:qw(}{it:numlist}{cmd:).} did not correctly interpret the {it:numlist}
    as the degree of the polynomial.  When either {cmd:pw.} or {cmd:qw.} was
    specified, {it:numlist} was interpreted as the value of the factor
    variable.  This has been fixed.

{p 5 9 2}
3.  {helpb egen:egen cut({it:varname}), group({it:#})}, when {it:#} > 1000 and
    when the data were not previously sorted by {it:varname}, did not produce
    {it:#} groups.  This has been fixed.

{p 5 9 2}
4.  {helpb etregress} with {it:aweight}s incorrectly exited with an error.
    This has been fixed.

{p 5 9 2}
5.  {helpb forecast solve} with option {cmd:simulate(residuals)} returned a
    Mata error message when used to define an
    {help forecast identity:identity} before
    {help forecast estimates:estimates} were defined or before a
    {help forecast coefvector:coefficient vector} was added.
    This has been fixed.

{p 5 9 2}
6.  Stata function {helpb f_regexm:regexm({it:s}, {it:re})} could crash Stata
    when one or both arguments were binary strL.  This has been fixed.

{p 5 9 2}
7.  Stata function {helpb f_strproper:strproper({it:s})} could crash Stata if
    the argument was binary strL.  This has been fixed.

{p 5 9 2}
8.  {helpb graph export}, when used to export to EPS format a graph that had a
    font with glyphs of more than 2,000 points, could cause Stata to crash.
    This has been fixed.

{p 5 9 2}
9.  {helpb gsem_command:gsem} with intercepts or fixed predictors on some but
    not all latent variables would fail to converge, even for models that were
    otherwise statistically identified.  Instead, the command reported the
    message "(not concave)" or "(backed up)" with unchanging log-likelihood
    values in the iteration log.  This has been fixed.

{p 4 9 2}
10.  The documentation for {helpb gsem_command:gsem} states that
     {help tsvarlist:time-series operators} are allowed.  However, when a
     time-series-operated {it:depvar} and multilevel latent variables were
     specified, {cmd:gsem} exited with an uninformative error message.  This
     has been fixed.

{p 4 9 2}
11.  {helpb icd9} and {helpb icd9p} have the following fixes:

{p 9 13 2}
     a.  {cmd:icd9 check} and {cmd:icd9p check}, for a small number of
         category and subcategory codes, incorrectly indicated that the codes
         were not defined.  This has been fixed.  Note that no billable
         ICD-9-CM codes were affected.

{p 9 13 2}
     b.  {cmd:icd9 generate} and {cmd:icd9p generate} with option
	 {cmd:description} returned a blank description for a small number of
	 codes instead of indicating that these codes were further subdivided.
	 This has been fixed.

{p 9 13 2}
     c.  {cmd:icd9 generate} with option {cmd:description} for the codes 176,
	 764, 765, V29, and V69 returned unofficial descriptions created by
	 StataCorp that included the text "(Stata)".  The description for
	 these codes is now "{cmd:*}", which is the documented indicator that a
	 code has been subdivided into billable codes.

{p 9 13 2}
     d.  {cmd:icd9 lookup} and {cmd:icd9p lookup}, when looking up a small
         number of category codes and subcategory codes without
         specifying a range, incorrectly returned note
         "(no matches found)".  For example, typing {cmd:icd9 lookup 040.4}
         would trigger this note, but {cmd:icd9 lookup 040.4*} would not.
         This has been fixed.

{p 4 9 2}
12.  {helpb ivtobit} with models having more than one endogenous variable
     specified is now more likely to converge.

{p 4 9 2}
13.  {helpb margins}, in the unusual case where {helpb xtlogit:xtlogit, re}
     or {helpb xtlogit:xtlogit, pa} was also specified with option
     {opt noconstant} and either option {cmd:vce(bootstrap)} or option
     {cmd:vce(jackknife)}, incorrectly reported the error message
     {err:"conformability error"}.  This has been fixed.

{p 4 9 2}
14.  The documentation for {helpb meologit} and {helpb meoprobit} states that
     they support {help tsvarlist:time-series operators} for {it:depvar}.
     However, when a time-series-operated {it:depvar} was specified, these
     commands exited with an uninformative error message.  This has been
     fixed.

{p 4 9 2}
15.  {helpb pctile:pctile {it:newvar} = {it:exp}, nquantiles({it:#})}, when
     {it:#} > 1000 and when the data were not previously sorted by {it:exp},
     correctly computed the quantile values but did not store the values in
     the first {it:#}-1 observations of the dataset.  This has been fixed.

{p 4 9 2}
16.  {helpb gsem_predict:predict} with option {cmd:latent} after
     {helpb gsem_command:gsem}, when used to fit a model with two or more
     latent variables that were each predicted by observed variables,
     incorrectly exited with error message "{error:variable _cons not found}".
     This has been fixed.

{p 4 9 2}
17.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} with
     multinomial outcomes incorrectly exited with an error message if the
     specified prediction involved the prediction of a latent variable.  This
     has been fixed.

{p 4 9 2}
18.  {helpb ologit_postestimation##predict:predict} with {it:stub}{cmd:*} and
     option {cmd:pr}, after using {helpb ologit} or {helpb oprobit} to fit a
     model without covariates, incorrectly exited with error message
     "{err:varname required}".  This has been fixed.

{p 4 9 2}
19.  {helpb prtest} and {helpb prtesti}, when used for a two-sample test of
     proportions, reported the two-sided p-value of the test with the label
     {cmd:Pr(|Z| < |z|)}.  The label should have been {cmd:Pr(|Z| > |z|)}.
     This has been fixed.

{p 4 9 2}
20.  {helpb svy} when used to fit a {help svy estimation:regression model} to
     data from a multistage survey design that 1) did not have a sampling
     unit or stratum variable in the final stage and 2) had FPC variables in
     all stages could exit with error message
     "{err:fpc for all observations within a stratum must be the same}",
     depending on the sort order of the data.  This has been fixed.

{p 4 9 2}
21.  {helpb svy tabulate:svy: tabulate}, when value labels for a tabulated
     variable contained quotation marks, exited with error message
     "{err:conformability error}".  This has been fixed.

{p 4 9 2}
22.  {helpb teffects nnmatch}, in the unusual case that {it:fweight}s were
     specified with option {cmd:vce(robust)}, produced standard errors that
     were too small.  This has been fixed.

{p 4 9 2}
23.  {helpb xtlogit} and {helpb xtprobit} with option {cmd:vce(robust)} or
     option {cmd:vce(cluster} {it:panelvar}{cmd:)}, when perfect predictors
     caused a reduction in the sample size, incorrectly exited with error
     message "{err:calculation of robust standard errors failed}".  This has
     been fixed.

{p 4 9 2}
24.  Contrary to the documentation, {helpb xtpoisson:xtpoisson, re} with
     option {opt normal} did not accept
     {help tsvarlist:time-series operators} in {it:depvar} or {it:indepvars}.
     This has been fixed.

{p 4 9 2}
25.  {helpb xtregar} has the following fixes:

{p 9 13 2}
     a.  {cmd:xtregar} with option {cmd:re}, in the rare case of a negative
         autocorrelation coefficient, produced standard errors that were too
         large.  This has been fixed.

{p 9 13 2}
     b.  {cmd:xtregar} with option {cmd:fe}, in the rare case of a negative
         autocorrelation coefficient, produced standard errors that were too
         large and a point estimate for the constant term that was biased
         toward 0.  This has been fixed.

{p 4 9 2}
26.  (Mac) In the Find dialog, selecting "Match whole word only" while
     searching in the Do-file Editor caused Stata to correctly find the
     search term in the current search but incorrectly save the setting.  In
     subsequent searches, results only returned text that started with the
     requested search term rather than the whole word.  This has been fixed.

{p 4 9 2}
27.  (Mac) When a table with multiple rows was copied from the Results
     window as HTML, the HTML output would appear as a table with just one
     row.  This has been fixed.

{p 4 9 2}
28.  (Mac) Stata graphs could incorrectly render to the screen the first point
     of polygons, such as arrowheads.  The first point was shifted from where
     it should have been drawn by one pixel.  This has been fixed.

{p 4 9 2}
29.  (Mac) Graph dialogs on Mac OS X 10.10, when combined with this specific
     sequence of steps -- 1) select a variable from a variable control; 2)
     switch to a tab that contains no active text edit fields; and 3) click
     on the OK button without making any other changes -- displayed a warning
     message and, in rare cases, caused Stata to crash.  This has been fixed.

{p 4 9 2}
30.  (Mac) {helpb view:view browse} did not open https URI schemes or URLs
     that were enclosed in quotes.  This has been fixed.

{p 4 9 2}
31.  (Mac GUI) The System Integrity Protection feature of OS X 10.11
     (El Capitan) prevents users from making modifications to the /usr/bin
     directory.  Because Stata can no longer write to the /usr/bin directory,
     Stata now creates a symbolic link to the console version of
     {help statamp:Stata/MP} or {help statase:Stata/SE} in the /usr/local/bin
     directory if the user selects "Install Terminal Utility..." from the
     Apple menu.  Stata will create the /usr/local/bin directory if it does
     not exist.


{hline 8} {hi:update 03jun2015} {hline}

{p 5 9 2}
1.  {helpb ereturn display}, {helpb ml display}, and {helpb _coef_table}, when
    reporting estimation results from a multiple-equation model that included
    an interaction term in more than one equation, would sometimes fail to
    recognize some base levels of interaction terms.  In this case, base
    levels were labeled "(omitted)" instead of "(base)".  The estimated
    coefficients and related statistics were correct; the error affected
    only the labels.

{p 9 9 2}
    For example, suppose we have factors A and B, each with levels 1 and 2.
    Then the coefficient table from

		{cmd:. sureg (y1 = A##B) (y2 = A#B), allbase}

{p 9 9 2}
    would mislabel elements {cmd:_b[y1:1.A#2.B]} and {cmd:_b[y1:2.A#1.B]} as
    "(omitted)" instead of as "(base)".  This has been fixed.

{p 5 9 2}
2.  {helpb estat mfx}, after {helpb asclogit} or {helpb asmprobit} with a
    value label assigned to {it:varname} specified in {bf:alternatives()},
    exited with an error if any strings in the value label were longer
    than 26 characters.  This has been fixed.

{p 5 9 2}
3.  Any estimation command that allowed {help fvvarlists:factor variables}
    would slow down when {helpb matsize} was set larger than 1,000 even for
    models with relatively few parameters.  This has been fixed.

{p 5 9 2}
4.  {helpb export excel}, when exporting variables with any calendar date
    format other than {cmd:%td}, incorrectly exported the variables as a daily
    date instead of respecting the weekly, monthly, quarterly, half-yearly, or
    yearly format.  This has been fixed.

{p 5 9 2}
5.  For variable names of the form {cmd:d#}, {cmd:D#}, {cmd:e#}, and {cmd:E#},
    Stata's expression parser misinterpreted some
    {help fvvarlists:factor-variable} specifications such as {cmd:1.d1} and
    {cmd:1.e2} as numeric literals instead of the intended indicator
    variables.  This has been fixed.

{p 5 9 2}
6.  Functions {help normalden():{bf:normalden(}{it:x},{it:m},{it:s}{bf:)}} and
    {help lnnormalden():{bf:lnnormalden(}{it:x},{it:m},{it:s}{bf:)}}, when
    {it:s} was specified as a string value rather than as a numeric
    value representing the standard deviation, returned the specified string
    instead of exiting with an error message.  This has been fixed.

{p 5 9 2}
7.  {helpb gnbreg}, {helpb nbreg}, and {helpb tnbreg} now report the
    pseudo-R-squared when option {cmd:vce(robust)}, option
    {cmd:vce(cluster} {it:clustvar}{cmd:)}, or {help weight:{bf:pweight}s}
    are specified.

{p 5 9 2}
8.  {helpb graph}, when using a {cmd:.gph} file that was created by a newer
    version of Stata that required a newer format {cmd:.gph} file and when the
    graph file name was quoted on the command line, simply declared the file
    to be not found.  {cmd:graph} now issues the message that the format of
    the file is too new for the running version of Stata.

{p 5 9 2}
9.  {helpb graph bar}, when no variable or statistic was specified and when
    options {cmd:over()} and {cmd:by()} were combined (for example,
    {cmd:graph bar, over(rep78) by(foreign)}), incorrectly exited with an
    error.  This has been fixed.

{p 4 9 2}
10.  {helpb graph pie}, when the number of slices exceeded the defined number
     of {help pstyle:{it:pstyle}s} in a {help scheme}, made all excess slices
     white and issued uninformative notes.  {cmd:graph pie} now behaves like
     {cmd:graph bar}, {cmd:graph twoway}, and other graph commands by
     recycling the defined {it:pstyle}s when the number of slices exceeds the
     number of defined {it:pstyle}s.  {cmd:graph pie} now also supports the
     {cmd:pcycle()} option to reduce the number of {it:pstyle}s used before
     recycling.

{p 4 9 2}
11.  {helpb import haver} has the following fixes:

{p 9 13 2}
     a.  {cmd:import haver}, when aggregating a daily series to weekly,
         defined weeks as beginning on Mondays.  Friday is now treated as
	 the first day of the week.

{p 9 13 2}
     b.  {cmd:import haver}, when a series contained no data, loaded the
         series as a variable containing all missing values instead of
         dropping the series from the query.  This has been fixed.

{p 9 13 2}
     c.  {cmd:import haver, describe} with option {cmd:saving()} always
         displayed the series meta-information in the Results window.  The
         meta-information should only be displayed when suboption
         {cmd:verbose} is specified in {cmd:saving()}.  This has been fixed.

{p 4 9 2}
12.  {helpb irf graph} with option {cmd:ci}{it:#}{cmd:opts()} did not change
     the rendition of the confidence interval for the {it:#}th statistic.
     This has been fixed.

{p 4 9 2}
13.  {helpb ivprobit} for models with more than one endogenous variable
     specified is now more likely to converge.

{p 4 9 2}
14.  {helpb margins} after {help me} commands with one or more factor
     variables that have their base level {helpb fvset} incorrectly exited
     with an error.  This has been fixed.

{p 4 9 2}
15.  {helpb mi impute intreg} exited with a Mata error
     "{error:st_store():  3203 colvector required}" when incomplete data
     contained only one censored observation.  This has been fixed.

{p 4 9 2}
16.  {helpb mi impute pmm}, {helpb mi impute monotone}, and
     {helpb mi impute chained} now display a note whenever predictive mean
     matching imputation uses the default one nearest neighbor.  This default
     is arbitrary.  The optimal number of nearest neighbors varies from one
     application to another.  Recent simulation studies demonstrated that
     using one nearest neighbor performed poorly in many of the considered
     scenarios.  We suggest that you choose the number of neighbors
     appropriate for your data and specify it in option {cmd:knn()} when
     imputing variables using predictive mean matching.

{p 4 9 2}
17.  {helpb minbound}, when the minimum value of the function occurred at the
     specified left boundary, returned the function value evaluated close
     to, but not exactly at, the boundary.  This has been fixed.

{p 4 9 2}
18.  {helpb ml} and Mata function {helpb mf_moptimize:moptimize()}, with
     {cmd:lf1} specified as the evaluator type, were passing the value {cmd:2}
     instead of {cmd:1} for {it:todo} while computing numerical second
     derivatives.  This has been fixed.

{p 4 9 2}
19.  {helpb mlexp} ignored reporting options associated with factor variables.
     This has been fixed.

{p 4 9 2}
20.  {helpb mvreg}, when replaying results from a model fit using
     {helpb manova}, did not display value labels for factor variables.
     This has been fixed.

{p 4 9 2}
21.  {helpb pause} would become stuck in an endless loop if you tried to start
     an interactive Mata session while Stata was already in a paused state.
     {cmd:pause} now returns an error message in this case.

{p 4 9 2}
22.  {helpb etpoisson_postestimation##predict:predict} with option {opt pr()}
     after {helpb etpoisson} did not correctly compute the predicted
     probabilities.  {cmd:predict} failed to integrate over the unobserved
     component to obtain the final results.  This has been fixed.

{p 4 9 2}
23.  {helpb teffects_postestimation##syntax_predict_ra:predict} with option
     {cmd:lnsigma} after {helpb teffects ra}, when the specified prediction
     created one new variable instead of a group of variables, incorrectly
     exited with an error.  This has been fixed.

{p 4 9 2}
24.  {helpb set coeftabresults:set coeftabresults off} is a setting used to
     make {helpb regress} faster when run in tight loops, in simulations, and
     when bootstrapping.  It is now faster still.

{p 9 9 2}
     Other estimation commands are also affected, but you would rarely
     notice a difference.

{p 4 9 2}
25.  {helpb regress}, when a {help tsvarlist:time-series-operated}
     variable was omitted because of collinearity, reported that a
     variable named {cmd:_delete} was omitted instead of reporting the name
     of the omitted variable.  This has been fixed.

{p 4 9 2}
26.  {helpb sem_command:sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem}, when fitting a model with no observed exogenous variables,
         with more than one latent variable, and with at least two
         coefficients constrained to 1 on paths from a latent variable to
         its observed measurements, incorrectly exited with an error message.
         This has been fixed.

{p 9 13 2}
     b.  {cmd:sem}, when option {opt covariance()} specified more than one
         covariance term and when starting values were specified for a subset
         of those covariance terms via the {opt init()} option, sometimes
         incorrectly exited with an error message.  Whether an error was
         reported depended on the order of the terms within the
         {opt covariance()} option.  For example, the option
         {cmd:covariance(x1*x2 (x1*x3, init(.2)))} would trigger this error.
         This has been fixed.

{p 9 13 2}
     c.  In the {help sem_builder:SEM Builder}, canvas length and canvas width
	 were not properly restricted to be between 1 inch and 20 inches.
	 This has been fixed.

{p 4 9 2}
27.  Stata matrix row and column names parsing logic, when presented with
     interactions where the order of factor variables was not the same in each
     term, did not properly keep track of the levels.  For example,

{p 13 17 2}
		{cmd:. matrix colna b = 0.foreign#1.rep78 2.rep78#1.foreign}

{p 9 9 2}
     would result in colnames

{p 13 17 2}
		{cmd:. matrix colna b = 0.foreign#1.rep78 2.foreign#1.rep78}

{p 9 9 2}
     instead of the intended

{p 13 17 2}
		{cmd:. matrix colna b = 0.foreign#1.rep78 1.foreign#2.rep78}

{p 9 9 2}
     This has been fixed.

{p 4 9 2}
28.  {helpb stcurve}, when plotting curves for a model that included an
     interaction between a factor variable and a continuous variable and when
     option {cmd:at()} set the continuous variable to a value that was not
     observed in the data, incorrectly reported error message
     "{error:# is not a valid level for factor variable {it:varname}}".  This
     has been fixed.

{p 4 9 2}
29.  {help tsvarlist:Time-series operators} have the following fixes:

{p 9 13 2}
     a.  Seasonal difference time-series operator {cmd:S}{it:#} did not
         appropriately translate the zero-period difference ({cmd:S0}).
         Depending on the command with which it was specified, {cmd:S0} was
         translated to {cmd:S1} or resulted in a variable containing only 0
         values.  In all cases, typing {cmd:S0.var} is now equivalent to
         typing {cmd:var}; this translation is the same as that used for the
         other time-series operators.

{p 9 13 2}
     b.  Time-series operators, when used with a dataset with more than 1
         billion observations and when the time series contained gaps, could
         cause Stata to crash or to return incorrect results.  Whether this
         occurred or not depended on certain relationships between the
         location of the gap, the number of observations, and the operator
         used.  This has been fixed.

{p 4 9 2}
30.  {helpb twoway scatter}, {helpb twoway line}, {helpb twoway connected},
     {helpb twoway area}, {helpb twoway bar}, {helpb twoway spike},
     {helpb twoway dropline}, {helpb twoway dot}, {helpb twoway rarea},
     {helpb twoway rbar}, {helpb twoway rspike}, {helpb twoway rcap},
     {helpb twoway rcapsym}, {helpb twoway rscatter}, {helpb twoway rline},
     and {helpb twoway rconnected} now support directly graphing the columns
     of a Mata matrix.  For the sake of speed and space, the matrix data are
     passed directly to the graph, not brought into the Stata dataset.

{p 9 9 2}
     The basic syntax is

	     {cmd:twoway scatter matamatrix(}{it:matname}{cmd:)} [{it:namelist}]

{p 9 9 2}
     This feature is not officially documented, but the syntax is documented in
     {helpb twoway mata:help twoway mata}.

{p 4 9 2}
31.  {helpb xtgls} issued a note when the number of panels was greater than
     the number of periods.  The note incorrectly stated the opposite, that
     the number of periods was greater than the number of panels.  This has
     been fixed.

{p 4 9 2}
32.  {helpb xtivreg} with option {cmd:vce(bootstrap)} or option
     {cmd:vce(jackknife)} exited with an error when an independent variable
     was included after the endogenous variable and instruments were specified
     in parentheses.  For example, the placement of variable {cmd:not_smsa} in

{p 13 17 2}
{cmd:. xtivreg ln_wage c.age##c.age (tenure = union south) not_smsa, vce(bootstrap)}

{p 9 9 2}
     would trigger this error.  Variables can now be specified after the
     expression in parentheses.

{p 4 9 2}
33.  Executing an operation using the https:// protocol when an internal
     content buffer was less than 100 bytes would cause Stata to exit with
     return code {bf:{search r(1)}}.  This typically happened only when the
     results to be returned by the operation were very short.  This has been
     fixed.

{p 4 9 2}
34.  (64-bit platforms) Mata functions {helpb mf_fopen:fseek()} and
     {cmd:ftell()}, when used to search for a position larger than 2GB in a
     file that was also larger than 2GB, returned a negative error code.  This
     has been fixed.

{p 4 9 2}
35.  (Mac) {helpb import excel}, when importing long variable names,
     incorrectly truncated the variable names to 33 characters when it should
     have truncated them to 32 characters.  This has been fixed.

{p 4 9 2}
36.  (Mac) {helpb translate} with translator {cmd:smcl2pdf} and when the
     destination file was specified either without an absolute path or without
     a path beginning {cmd:~/} resulted in an empty destination file.  This
     has been fixed.

{p 4 9 2}
37.  (Mac) {helpb xshell} did not launch {cmd:xterm} when used on Mac OS X
     10.8 or newer because XQuartz installs the {cmd:xterm} executable in a
     location other than where Stata is expecting.  This has been fixed.

{p 4 9 2}
38.  (Mac) The Do-file Editor has the following fixes:

{p 9 13 2}
     a.  Line numbers were not correctly resized when the Do-file Editor was
         zoomed in or zoomed out.  This has been fixed.

{p 9 13 2}
     b.  Using the Find dialog and selecting "Replace all" might not replace
         all the text specified in "Find what:" if 1) the text to be replaced
         occurs more than once; 2) the length of the text specified in
         "Replace what:" is longer than the text that is being replaced; and
         3) the text that is being replaced comes very close to the end of the
         document.

{p 4 9 2}
39.  (Mac) Stata graphics no longer attempts to render a 0 line width path but
     will instead ignore the drawing command.  In addition, Stata no longer
     sets the minimum line width to 1 pixel when rendering paths on the
     screen.  Users with Mac OS X may notice that there is no longer any
     variation in how 0 width lines are rendered across output devices such as
     monitors and printers.

{p 4 9 2}
40.  (Unix GUI) If a user changed themes on the computer, the Preferences
     dialog box continued to use a black font even if the theme requested
     another color.  This has been fixed.

{p 4 9 2}
41.  (Unix GUI) The SEM Builder's Estimation menu, when used to request
     exponentiated coefficients after fitting a generalized SEM, opened an
     incorrect dialog box.  This has been fixed.

{p 4 9 2}
42.  (Linux/Unix) In the Stata {help class} system, if Stata was launched in
     batch mode, destructors were not invoked when Stata exited.  This
     affected only users who had created classes that used destructors to
     manage computing resources not internal to Stata.  This has been fixed.


{hline 8} {hi:update 17apr2015} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 15(1).

{p 5 9 2}
2.  {helpb estat esize}, when a noncentrality parameter could not be
    calculated, incorrectly reported a lower limit of 0 and upper limit of 1
    for the confidence intervals of eta-squared and omega-squared.  A missing
    lower limit and missing upper limit are now reported.

{p 5 9 2}
3.  {helpb sem_estat_stdize:estat stdize} after {helpb sem_command:sem} could,
    with nearly unidentified models, sometimes report the warning
    "{error:variance matrix is nonsymmetric or highly singular}" and report
    missing standard errors and test statistics.  This has been fixed.

{p 5 9 2}
4.  {helpb etpoisson}, {helpb heckoprobit}, {helpb heckprobit}, {helpb nbreg},
    {helpb poisson}, {helpb tnbreg}, and {helpb tpoisson}, when a
    time-series-operated variable was specified in option {cmd:offset()} or
    option {cmd:exposure()}, ignored the option and fit the model without an
    offset or an exposure.  This has been fixed.

{p 5 9 2}
5.  {helpb glm} with {cmd:family(binomial} {it:varname}{cmd:)} did not exclude
    observations for which {it:varname} was missing. This typically resulted
    in a model that would not converge.  This has been fixed.

{p 5 9 2}
6.  {helpb graph}, when using a {cmd:.gph} file that was created by a newer
    version of Stata that required a newer-format {cmd:.gph} file, simply
    declared the file specification to be invalid.  {cmd:graph} now issues the
    message that the format of the file is too new for the running version of
    Stata.

{p 5 9 2}
7.  {helpb gsem_command:gsem} and {helpb meglm} with {cmd:family(binomial}
    {it:varname}{cmd:)} did not exclude observations where {it:varname} was
    missing.  This typically resulted in log-likelihood values labeled as
    "(not concave)", leading to the error
    "{error:Hessian is not negative semidefinite}".  This has been fixed.

{p 5 9 2}
8.  {helpb gsem_command:gsem}, {helpb mecloglog}, {helpb meglm},
    {helpb melogit}, {helpb menbreg}, {helpb meologit}, {helpb meoprobit},
    {helpb mepoisson}, {helpb meprobit}, {helpb xtologit}, and
    {helpb xtoprobit} specified with constraints or factor variables would
    sometimes exit with a Mata trace log when the starting values were not
    feasible.  Stata now produces an informative error message.

{p 5 9 2}
9.  {helpb lv} failed to ignore string-valued variables in the {it:varlist}
    when determining the estimation sample.  This has been fixed.

{p 4 9 2}
10.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  Specifying any factor variable as {cmd:asbalanced} when that factor
	 variable is interacted with other factor variables in models fit
	 using {helpb gsem_command:gsem}, {helpb mecloglog}, {helpb meglm},
	 {helpb melogit}, {helpb menbreg}, {helpb meologit},
	 {helpb meoprobit}, {helpb mepoisson}, {helpb meprobit},
	 {helpb xtologit}, and {helpb xtoprobit} produced asobserved rather
	 than asbalanced marginal predictions. This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} after {helpb sem_command:sem} incorrectly exited with
	 an error message when endogenous covariates were specified in option
	 {opt at()}.  {cmd:margins} now fully supports endogenous covariates
	 in option {opt at()}.

{p 9 13 2}
     c.  {cmd:margins} with option {opt subpop()} and weighted contrast
	 operator {cmd:gw.}, {cmd:hw.}, {cmd:jw.}, {cmd:pw.}, or
	 {cmd:qw.} applied the overall-sample frequencies instead of the
	 subpopulation-sample frequencies to the weighted contrasts.  This has
	 been fixed.

{p 4 9 2}
11.  {helpb marginsplot} now allows an optional {cmd:using} {it:filename}.
     The data in {it:filename} are assumed to come from the data saved by
     {cmd:margins}'s {cmd:saving()} option.  This feature is not documented
     with {cmd:marginsplot}; instead see {helpb margins saving}.

{p 4 9 2}
12.  {helpb melogit} and {helpb meprobit} with option
     {opt binomial(varname)} failed to exclude observations where {it:varname}
     was missing.  This typically resulted in log-likelihood values labeled as
     "(not concave)", leading to the error
     "{error:Hessian is not negative semidefinite}".  This has been fixed.

{p 4 9 2}
13.  {helpb power_twoproportions:power twoproportions} with option
     {cmd:test(fisher)} reported an incorrect value of actual alpha when the
     specified proportion in the control group was greater than the proportion
     in the experimental group.  This has been fixed.

{p 4 9 2}
14.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} did not
     allow {it:depvar} to be abbreviated in option {cmd:outcome()}.  This has
     been fixed.

{p 4 9 2}
15.  {helpb rolling} with option {opt keep(varname)} did not keep the correct
     values of {it:varname} unless the time variable specified in
     {helpb tsset} was exactly equal to the observation number. This has been
     fixed.

{p 4 9 2}
16.  {helpb streg} with {opt distribution(exponential)} did not allow option
     {opt from()}.  This has been fixed.

{p 4 9 2}
17.  {helpb sts_test:sts test} with option {cmd:fh()} reported incorrect sum
     of ranks and test statistics except when {cmd:fh(0 0)} was specified.
     This has been fixed.

{p 4 9 2}
18.  {helpb sts_test:sts test} with option {cmd:strata()} combined with either
     option {cmd:peto} or option {cmd:fh()} reported incorrect sum of ranks
     and test statistics. This has been fixed.

{p 4 9 2}
19.  {helpb suest} with option {cmd:vce(cluster} {it:clustvar}{cmd:)} failed
     to identify missing values in {it:clustvar} within the estimation sample.
     {cmd:suest} now exits with the error message
     "{error:cluster variable clustvar is not allowed to be missing within the estimation sample}".

{p 4 9 2}
20.  {helpb testnl} with option {cmd:mtest} and only a single testable
     constraint would produce an error instead of dropping untestable
     constraints and testing the remaining constraint. This has been fixed.

{p 4 9 2}
21.  {helpb xtcloglog}, {helpb xtlogit}, {helpb xtpoisson}, and
     {helpb xtprobit} with options {cmd:vce(robust)} and {cmd:noconstant}
     specified in the default random-effects model produced a conformability
     error.  This has been fixed.


{hline 8} {hi:update 19dec2014} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 14(4).

{p 5 9 2}
2.  {helpb forecast solve} using estimates from {helpb arima} with no
    covariates exited with an error message.  This has been fixed.

{p 5 9 2}
3.  {helpb gsort}, when arranging observations to be in descending order of a
    numeric variable, replaced the results in {cmd:r()} even though
    {cmd:gsort} is not an r-class command.  {cmd:gsort} now preserves existing
    results in {cmd:r()}.

{p 5 9 2}
4.  {helpb mfp} would not allow abbreviated variable names to be entered in
    the options {bf:zero()} and {bf:catzero()}.  This has been fixed.

{p 5 9 2}
5.  {helpb total} with option {opt over()} and without prefix {helpb svy}
    sometimes failed to estimate the variance matrix and reported the warning
    "{err:variance matrix is nonsymmetric or highly singular}".  This most
    commonly occurred when {cmd:over()} was combined with {cmd:vce(cluster}
    {it:clustvar}{cmd:)}.  This has been fixed.

{p 5 9 2}
6.  {helpb tsreport}, when used with data that included repeated time values
    and had not been either {helpb xtset} or {helpb tsset} with a panel
    variable, returned an uninformative error message.  This has been fixed.


{hline 8} {hi:update 07nov2014} {hline}

{p 5 9 2}
1.  {helpb collapse} with option {cmd:percent} now reports percentages
    rather than proportions.

{p 5 9 2}
2.  {helpb estat summarize} after {helpb gsem} ignored all arguments and
    options.  This has been fixed.

{p 5 9 2}
3.  {helpb graph bar} and {helpb graph dot} with option {cmd:percent} now
    report percentages rather than proportions.

{p 5 9 2}
4.  {helpb ksmirnov:ksmirnov, exact} could report an incorrect p-value
    because of numerical precision for the two-sample exact test when the
    number of observations in at least one group was not equal to a power of
    2.  In such cases, the reported p-value was too small.  This has been
    fixed.

{p 5 9 2}
5.  {helpb levelsof}, when used with a variable containing all missing values,
    returned an uninformative error message when it should
    have returned "{err:no observations}".  This has been fixed.

{p 5 9 2}
6.  {helpb testnl} has the following fixes:

{p 9 13 2}
     a.  {cmd:testnl}, when used with survey data, incorrectly reported an F
	 statistic by default instead of a chi-squared statistic.  This
	 has been fixed.

{p 9 13 2}
     b.  {cmd:testnl}, when used with survey data, ignored the specified
	 option {cmd:df()}.  This has been fixed.


{hline 8} {hi:update 09oct2014} {hline}

{p 5 9 2}
1.  {helpb collapse} now supports the {cmd:(percent)} statistic
    specifying that the percentage of observations within each {cmd:by()}
    group be placed in the collapsed dataset.

{p 5 9 2}
2.  {helpb graph bar} and {helpb graph dot} now handle categorical data
    better.  Graphs of frequencies and percentages of observations within
    {cmd:over()} groups can be obtained using statistics {cmd:(count)} and
    {cmd:(percent)}.  For example,

{p 13 13 2}
	{cmd:graph bar (percent), over(grpvar)}

{p 9 9 2}
    creates bars measuring the percentage of observations in each level of
    {cmd:grpvar}.

{p 13 13 2}
	{cmd:graph bar, over(grpvar)}

{p 9 9 2}
    is an abbreviated syntax that does the same.

{p 5 9 2}
3. {helpb istdize} has the following improvements:

{p 9 13 2}
     a.  {cmd:istdize} now stores results in {cmd:r()}.

{p 9 13 2}
     b.  {cmd:istdize} now returns an error message

{p 13 15 2}
	 o if option {opt by()} is not specified and if the numbers of cases
	   stored in variable casevar_s are not the same (excluding missing
           values) for all observations;

{p 13 15 2}
	 o if option {opt by()} is specified and if the numbers of cases
	   stored in variable {it:casevar_s} are not the same (excluding
           missing values) for all observations in a group defined by the
           {opt by()} variables; or

{p 13 15 2}
	 o if option {opt by()} is specified and when the numbers of cases
	   stored in variable {it:casevar_s} are missing for all observations
           in one or more groups defined by the {opt by()} variables.

{p 5 9 2}
4.  {helpb glm_postestimation##predict:predict} after
    {helpb svy}{cmd::} {helpb glm} now allows statistic {opt response},
    the difference between the observed and fitted outcomes.

{p 5 9 2}
5.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 14(3).

{p 5 9 2}
6.  {helpb clogit} with an unusually large number of positive values of the
    outcome per group could produce a numeric overflow and cause
    {help statamp:Stata/MP} to crash.  This has been fixed.

{p 5 9 2}
7.  {helpb contrast} now works with estimation results that do not contain
    {cmd:e(V)}.  This means that {helpb margins_contrast:margins} with
    contrasts and option {opt nose} will no longer issue an error message
    for such estimation results.

{p 5 9 2}
8.  {helpb creturn list} and {cmd:c(k)} incorrectly reported a value that was
    one larger than the number of variables in the dataset whenever
    {cmd:e(sample)} was present in the current estimation results.  This has
    been fixed.

{p 5 9 2}
9.  The Data Editor has the following fixes:

{p 9 13 2}
     a.  In the Data Editor, editing a cell containing a {cmd:$} would result
	 in the text following the {cmd:$} being dropped because the {cmd:$}
	 and following text were incorrectly treated as a global macro.  This
	 has been fixed.

{p 9 13 2}
     b.  The 06may2014 update modified the way the data view was scrolled when
         filters were added or removed in the Data Editor.  This behavior
         change could make it difficult to locate the current cursor position
         after a filter was removed.  The behavior has now been restored to
         the behavior that existed before the 06may2014 update.

{p 4 9 2}
10.  {helpb estimates describe}, when {cmd:e(cmdline)} contained quotes,
     exited with an error message.  This has been fixed.

{p 4 9 2}
11.  {helpb expoisson} and {helpb exlogistic}, in rare cases where the model
     conditioned on a variable with many distinct values, would produce so
     many enumerations that Stata could crash.  This has been fixed.

{p 4 9 2}
12.  After the 06may2014 update, expressions using ambiguous abbreviations of
     variable names resulted in error message "{err:... not found}" instead of
     "{err:... ambiguous abbreviation}".  This has been fixed.

{p 4 9 2}
13.  {helpb heckoprobit} incorrectly posted options {opt stdp} and
     {opt stdpsel} to {cmd:e(marginsok)} instead of {cmd:e(marginsnotok)}.
     This has been fixed.  {cmd:margins} now issues an error message if these
     predictions are specified in option {cmd:predict()}.

{p 4 9 2}
14.  {helpb ivpoisson} incorrectly posted option {opt residuals} to
     {cmd:e(marginsok)}.  This has been fixed.  {cmd:margins} now issues an
     error message if this prediction is specified in option {cmd:predict()}.

{p 4 9 2}
15.  In the
     {browse "http://www.stata.com/java/api/":Java-Stata API Specification},
     {cmd:com.stata.sfi.Data.getFormattedValue()} did not display commas for
     Stata formats for which it should have displayed commas, such as
     {cmd:%8.0gc}.  This has been fixed.

{p 4 9 2}
16.  {helpb log:log close {it:logname}}, where {it:logname} was a name that
     was greater than 32 characters in length, could crash Stata.  This has
     been fixed.

{p 4 9 2}
17.  {helpb lrtest} unnecessarily required the dependent variables be
     specified in the same order for all fitted models.  This has been fixed.

{p 4 9 2}
18.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {opt over()} or {opt within()} ignored
	 {opt generate()} expressions within option {opt at()}.  This has been
	 fixed.

{p 9 13 2}
     b.  {cmd:margins} with multiple {opt at()} settings and with
         {helpb set emptycells:set emptycells drop} would incorrectly exit
	 with the error message "{error:conformability error}".  This has been
	 fixed.

{p 9 13 2}
     c.  {cmd:margins} with option {cmd:vce(unconditional)} failed to restrict
         computation of scores to within the estimation sample.  On rare
	 occasions, out-of-sample scores could not be computed, resulting
         in error message

		  {error:cannot compute vce(unconditional);}
		  {error:predict after ... could not compute scores}

{p 13 13 2}
	 This has been fixed.

{p 9 13 2}
     d.  {cmd:margins} with default {cmd:vce(delta)} and {helpb svy}
	 estimation results reported a different sample size when
	 {cmd:if e(sample)} was specified if the survey weights variable
	 contained zero values within the estimation sample, because
	 zero-weighted observations were not counted.  This has been fixed.

{p 4 9 2}
19.  Mata function {helpb mf_selectindex:{bf:selectindex(}{it:v}{bf:)}},
     when {it:v} was a vector with no elements, could cause Stata to crash.
     This has been fixed.

{p 4 9 2}
20.  Mata function {helpb mf_selectindex:{bf:selectindex(}{it:v}{bf:)}}, when
     {it:v} was created using {helpb mf_st_view:st_view()}, incorrectly
     returned the index values of zero-valued vector elements.  This has been
     fixed.

{p 4 9 2}
21.  {helpb ml} with option {cmd:svy} reported an unadjusted model F test
     instead of an adjusted model F test.  This has been fixed.

{p 4 9 2}
22.  {helpb ml display}, {helpb ereturn display}, and {helpb _coef_table},
     when a scalar was posted to {cmd:e(b)}, reported the error message
     "{err:point estimates required}", even when the point estimates were also
     present in matrix {cmd:e(b)}.  This has been fixed.

{p 4 9 2}
23.  {helpb power} did not allow the specification of two-sample
     options such as {cmd:n1()}, {cmd:n2()}, and {cmd:nratio()} for
     user-defined power methods.  This is now allowed if you also specify
     new option {cmd:twosample} with {cmd:power}.  See
     {cmd:power userwritten} for more details.

{p 4 9 2}
24.  {helpb teffects_postestimation##predict:predict} after
     {helpb teffects nnmatch}{cmd:, atet biasadj()} would incorrectly exit
     with error message "{err:conformability error}".  This has been fixed.

{p 4 9 2}
25.  {helpb pwcompare} now works with estimation results that do not contain
     {cmd:e(V)}.  This means that {helpb margins_pwcompare:margins} with
     options {opt pwcompare} and {opt nose} will no longer issue an error
     message for such estimation results.

{p 4 9 2}
26.  {helpb _rmcollright} with a weight expression would incorrectly exit with
     error message "{err:weights not allowed}".  This has been fixed.

{p 4 9 2}
27.  {helpb sem_command:sem} did not allow option {cmd:init()} to be used
     within options {opt means()}, {opt variance()}, or {opt covariance()}
     when the constraint operator {cmd:@} was also specified.  This has been
     fixed.

{p 4 9 2}
28.  {helpb serset sort} and {helpb serset summarize}, when there was a
     {cmd:strL} variable in the dataset, could cause Stata to crash.  This has
     been fixed.

{p 4 9 2}
29.  {helpb smooth} now labels the {opt generate()} variable.

{p 4 9 2}
30.  {helpb suest}, when it encounters results from {helpb gmm} or
     {helpb gsem_command:gsem}, now reports a more informative error message.

{p 4 9 2}
31.  {helpb svy}{cmd::} {helpb sem_command:sem} with options {opt group()}
     and {cmd:method(ml)} (the default) did not produce correct linearized
     standard errors unless the data were already sorted by the {opt group()}
     variable.  The score values used in the linearized variance estimator
     were not put in the proper observations, resulting in different
     standard-error estimates depending on the sort order of the dataset.
     This has been fixed.

{p 4 9 2}
32.  {helpb test} with an expression using a factor variable with a level
     value greater than 32,767 would incorrectly exit with the error message
     "{error:regressor ... not found}".  This has been fixed.

{p 4 9 2}
33.  {helpb xtnbreg} with an {opt offset()} variable containing extremely
     large values could exit with the unhelpful error message
     "{error:matrix not found}".  This error message was caused by a numerical
     overflow caused by the {opt offset()} variable.  Now {cmd:xtnbreg}
     will report the following error message:
     "{error:could not find feasible starting values}".

{p 4 9 2}
34.  {helpb xtreg:xtreg, fe} would mistakenly identify independent variables
     with a constant lag difference as constant within panel.  This affected
     only the value of the test statistic reported below the results table
     as "F test that all u_i=0".  This has been fixed.

{p 4 9 2}
35.  (Windows) Exporting a graph to a PDF file that contained text with a
     size of 0 would cause Stata to crash.  This has been fixed.

{p 4 9 2}
36.  (Windows) Creating thousands of {help graph:graphs} could eventually
     cause Stata to fail to render graphs on the screen.  This has been fixed.

{p 4 9 2}
37.  (Windows and Mac) Calling Stata in batch mode and passing a do-file
     without specifying command {helpb do} would result in Stata assuming
     {helpb doedit} as the command by default.  Stata will now always assume
     {cmd:do} as the command in batch mode.

{p 4 9 2}
38.  (Mac) Stata's code signature has been updated for compatibility with OS X
     10.9.5 and newer.

{p 4 9 2}
39.  (Mac) In the {helpb power} dialog box, clicking on the button for the
     score test comparing a proportion with a reference value opened the wrong
     dialog box.  This has been fixed.

{p 4 9 2}
40.  (Mac and Unix console) Calling Stata in batch mode and passing a do-file
     without specifying command {helpb do} would result in the log filename
     getting prepended with a quote.  This has been fixed.

{p 4 9 2}
41.  (Unix GUI) On some Linux distributions, the output from a command could
     appear twice in the Results window.  This has been fixed.


{hline 8} {hi:update 06aug2014} {hline}

{p 5 9 2}
1.  The {help sem builder:SEM Builder} now allows you to provide a matrix or
    list of initial values on the {bf:Maximization} tab of the SEM estimation
    options dialog.

{p 5 9 2}
2.  {helpb contrast} with option {opt level()} would incorrectly exit with
    the error message "{error:option level() not allowed}".  This also
    affected {helpb margins} with option {opt level()} and contrast
    operators.  This has been fixed.

{p 5 9 2}
3.  {helpb graph matrix} with a varlist specification containing {cmd:_all} or
    {cmd:*} would include graphs of each variable against the binary temporary
    variable that identifies the sample.  This has been fixed.

{p 5 9 2}
4.  {helpb marginsplot} with a single variable specified in option
    {opt xdimension()} ignored suboptions {opt labels()} and {opt elabels()}.
    This has been fixed.

{p 5 9 2}
5.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} and
    {helpb me} would incorrectly return zero-valued empirical Bayes' mean
    estimates when {cmd:intmethod(mvaghermite)} was not a viable integration
    method.  In this case, {cmd:gsem} and {cmd:me} will now report a note
    below the coefficient table acknowledging that the results were produced
    using nonadaptive quadrature, and {cmd:predict} will issue the error
    message "{error:could not compute the empirical Bayes' means}".

{p 5 9 2}
6.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} has been
    improved to better handle missing-value patterns in the
    {cmd:family(gaussian)} outcomes.  Before this fix, structural paths
    between {cmd:family(gaussian)} outcomes would cause {cmd:predict} to
    incorrectly return missing values in observations where any one of the
    {cmd:family(gaussian)} outcomes were missing even if that outcome was not
    a predictor for the outcome of interest.

{p 5 9 2}
7.  {helpb sem_command:sem} has the following fixes:

{p 9 13 2}
    a.  {cmd:sem} did not allow option {opt init()} to be used with terms
        containing the constraint operator {cmd:@}.  For example, the
	following command would return an error message stating that {cmd:@}
	is an invalid name:

		 {cmd:. sem mpg <- (turn@a, init(.5)) (trunk@a, init(.5))}

{p 13 13 2}
        This has been fixed.

{p 9 13 2}
    b.  {cmd:sem} with option {cmd:method(mlmv)} and collinear variables would
	exit with a Mata trace log.  This Mata bug has been fixed.  {cmd:sem}
	will now report that the starting values are not feasible when it is
	unable to fit the saturated model in this situation.

{p 5 9 2}
8.  {helpb statsby}, in the rare case where one or more {cmd:by()} groups
    contained a huge number of observations (greater than 16,777,216), could
    result in a dataset with missing values for the last group, and it could
    possibly result in extra observations filled in with missing values.
    Furthermore, statistics for these large groups and those following may not
    be based on the intended observations from the original dataset.  This has
    been fixed.

{p 5 9 2}
9.  {helpb teffects psmatch} with option {cmd:caliper()} would produce an
    error message for some covariate patterns when attempting to compute
    robust standard errors for the ATET estimator. This has been fixed.


{hline 8} {hi:update 03jul2014} {hline}

{p 5 9 2}
1.  {helpb margins} always produced zero-valued marginal effects for
    time-series-operated variables when working with {helpb sem_command:sem}
    or {helpb gsem_command:gsem} results.  This has been fixed.

{p 5 9 2}
2.  {helpb sem_command:sem} with {cmd:vce(robust)} or
    {cmd:vce(cluster} {it:...}{cmd:)} and time-series operators on one or more
    variables iterated to convergence but exited with the error
    "{error:time-series operators not allowed}" instead of reporting the
    estimation results.  This has been fixed.

{p 5 9 2}
3.  (Mac) The 26jun2014 update introduced a bug where closing a Do-file Editor
    with unsaved changes would not prompt the user to save the changes and
    would put Stata into a state where it could not be exited.  This has been
    fixed.


{hline 8} {hi:update 26jun2014} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 14(2).

{p 5 9 2}
2.  The standard reporting options for estimation commands now include options
    {cmd:noci} and {cmd:nopvalues}.  {cmd:noci} suppresses confidence
    intervals from being reported in the coefficient table.  {cmd:nopvalues}
    suppresses p-values and their test statistics from being reported in the
    coefficient table.

{p 5 9 2}
3.  {helpb bootstrap} with option {opt bca} and when using an estimation
    command that included factor variables issued a warning about missing
    acceleration estimates and did not compute bias-corrected and accelerated
    (BCa) confidence intervals because of zero-valued constraints on base
    levels and omitted predictors.  This has been fixed so that BCa confidence
    intervals are produced for the other estimates.

{p 5 9 2}
4.  {helpb bootstrap} and {helpb bsample} with option {opt idcluster()} and a
    sample with more than 16,777,216 total observations failed to include
    all observations from some of the sampled clusters.  This has been fixed.

{p 5 9 2}
5.  {helpb forecast solve} when obtaining forecast standard deviations or
    variances with option {cmd:simulate()} and when a specific prediction had
    not been specified using option {cmd:predict()} of {cmd:forecast estimate}
    did not produce correct standard deviations or variances for the
    estimators {cmd:xtreg, fe}, {cmd:xtreg, re}, {cmd:xtpcse}, or
    {cmd:xtivreg}.  This has been fixed.  Note that the forecasts themselves
    were correct.

{p 5 9 2}
6.  {helpb gsem} has improved parsing to handle elements within an interaction
    term that were specified with different variable ordering.  For example,

	     . {cmd:sysuse auto}
	     . {cmd:gsem mpg <- 0.foreign#c.turn#c.trunk 1.foreign#c.trunk#c.turn}

{p 9 9 2}
    was ignoring the {cmd:1.foreign#c.trunk#c.turn} element of the interaction
    term when it should have produced the same result as

	     . {cmd:gsem mpg <- foreign#c.turn#c.trunk}

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
7.  {helpb import delimited} will now completely ignore any binary zeros in
    the text-delimited file on disk.  Binary zeros are not valid in text data.
    Upon completion, {cmd:import delimited} will now report the number of
    binary zero bytes that have been ignored, if any.

{p 5 9 2}
8.  {helpb import excel} with option {opt firstrow} imported the last
    character in a variable name incorrectly when the variable name was longer
    than 32 characters.  This has been fixed.

{p 5 9 2}
9.  {helpb jackknife}, when option {opt n()} was supplied with an expression
    dependent upon {cmd:r()} results other than {cmd:r(N)}, would exit with
    the error message "{err:number of obs. ... evaluated to missing in full}
    {err:sample}". This has been fixed.

{p 4 9 2}
10.  {helpb logistic} with option {opt coeflegend} reported the odds ratios.
     This behavior was misleading because the legend elements correspond
     to coefficients when used in expressions.  {cmd:logistic} with option
     {opt coeflegend} now reports the estimated coefficient values.

{p 4 9 2}
11.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} did not allow certain {it:{help varlist}}
         specifications within options {cmd:dydx()}, {cmd:dyex()},
         {cmd:eydx()}, and {cmd:eyex()}.  For example, with the following
         regression

		. {cmd:sysuse auto}
		. {cmd:regress mpg turn trunk i.foreign}

{p 13 13 2}
         {cmd:margins} would exit with the following error messages:

		 . {cmd:margins, dydx(t*)}
		 {err:'t*' not found in list of covariates}

		 . {cmd:margins, dydx(f*)}
		 {err:'f*' not found in list of covariates}

		 . {cmd:margins, dydx(i.foreign)}
		 {err:i:  operator invalid}

{p 13 13 2}
         These {it:varlist} specifications are now supported in {cmd:margins}.

{p 9 13 2}
     b.  {cmd:margins} ignored factor-level restrictions in the
         {it:marginlist} for factor variables that had a base preference
	 specified in the {cmd:margins} command or the {helpb fvset} command.
	 This has been fixed.

{p 4 9 2}
12.  {helpb marginsplot} has the following improvements and fixes:

{p 9 13 2}
     a.  Axis labels have been improved when contrasts are present in the
         {helpb margins} results.

{p 9 13 2}
     b.  Axis labels now show factor-variable values rather than value
         labels after {helpb margins} with option {opt nofvlabel}.

{p 9 13 2}
     c.  {cmd:marginsplot} now checks for {opt at()} variables that are
         present as both a factor variable and a regular variable in the
         estimation results.  For example,

		 . {cmd:sysuse auto}
		 . {cmd:regress mpg foreign rep78#foreign}
		 . {cmd:margins, at(rep78=(3/5))}

{p 13 13 2}
         treats {cmd:foreign} as a regular variable in the main effect but as
         a factor variable in the interaction with {cmd:rep78}.
         {cmd:marginsplot} does not support this and will exit with an error
         identifying {cmd:foreign} as the offending variable.

{p 13 13 2}
         The solution to this situation is to refit and specify the offending
	 variable exclusively as a factor variable or exclusively as a regular
	 variable.  For the above example, this means specifying the linear
	 regression as

		 . {cmd:regress mpg i.foreign rep78#foreign}

{p 4 9 2}
13.  Mata function
     {helpb mf_normal:{bf:lnnormalden(}{it:x}{bf:,}{it:sd}{bf:)}} did not
     return a missing value in some cases where it was expected to, for
     instance, when {it:x} was missing or extremely large.  This has been
     fixed.

{p 4 9 2}
14.  {helpb odbc query} and {helpb odbc describe} issued the error message
     "{err:Memory allocation error}" when connecting to a MonetDB database.
     This has been fixed.

{p 4 9 2}
15.  {helpb proportion} with option {opt over()} reported missing proportion
     values for categories with no observations within the groups defined by
     {cmd:over()}.  {cmd:proportion} will now report a zero value.  The old
     behavior is not preserved under version control.

{p 4 9 2}
16.  {helpb prtest} {it:varname} with option {opt by()} failed to check that
     {it:varname} was binary for the two-sample test of proportions.  If the
     specified variable contained values other than 0 or 1 and the mean
     of {it:varname} in each group was in the range of 0 to 1, {cmd:prtest}
     would produce incorrect proportions and tests of differences, but it
     did not produce an error message.  This has been fixed.

{p 4 9 2}
17.  {helpb pwcompare} with option {cmd:mcompare(tukey)} no longer reports a
     warning about unbalanced factors.  The method implemented for
     {cmd:mcompare(tukey)} is commonly known as the Tukey-Kramer method, which
     is an extension to Tukey's honest significant difference method that
     accounts for unbalanced factors.

{p 4 9 2}
18.  {helpb pwcorr} produced a table containing missing values when numerical
     overflow occurred.  The command now produces a numerical overflow error
     message.

{p 4 9 2}
19.  {helpb qreg} has the following fixes:

{p 9 13 2}
     a.  {cmd:qreg} reported twice the sum of the absolute weighted
	 deviations.  This rescaling of the objective function did not affect
	 the other results.  The sum of the absolute deviations is now
	 reported.

{p 9 13 2}
     b.  In rare cases in which some of the specified weights were very large
	 and others were relatively small, numeric imprecision could
	 accumulate and cause the algorithm to select a point near the optimum
	 instead of the optimal point.  Numeric stability of the {cmd:qreg}
	 computations has been improved.

{p 4 9 2}
20.  The {helpb sembuilder:SEM Builder} has the following improvements:

{p 9 13 2}
     a.  The Contextual Toolbar no longer flashes when opening a path diagram
         file or when using the {hi:Undo} or {hi:Redo} buttons.

{p 9 13 2}
     b.  Opening a path diagram and using the {hi:Undo} and {hi:Redo} buttons
	 are now much faster.  The speed improvement is particularly
	 noticeable on large or complex path diagrams.

{p 9 13 2}
     c.  The Builder window now becomes inoperative during {hi:Undo} and
	 {hi:Redo} operations.  Previously, it was possible to connect a path
	 to or from a variable that would be removed by the operation, leading
	 to warning messages.

{p 4 9 2}
21.  {helpb sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem} with a fitted model that was not full rank in {cmd:e(V)}
	 reported a model-versus-saturated chi-squared test that had an
	 inflated p-value because the degrees of freedom for the test was
	 inflated.  {cmd:sem} now reports a note indicating this has occurred
	 instead of reporting the test.

{p 9 13 2}
     b.  {cmd:sem} with {cmd:method(mlmv)} in the very rare situation where
         the saturated model converged, but was not full rank, yielded a
         log likelihood greater than the fitted log likelihood.  In this case,
	 {cmd:sem} reported a zero-valued chi-squared statistic instead of the
	 negative difference in the chi-squared values.  {cmd:sem} now reports
	 a note indicating that the saturated model is not full rank instead
	 of reporting the chi-squared test.

{p 4 9 2}
22.  {helpb stcox}, {helpb stcrreg}, and {helpb streg} with option
     {opt coeflegend} reported the hazard ratios.  This behavior was
     misleading because the legend elements correspond to coefficients when
     used in expressions.  These commands with the option {opt coeflegend} now
     report the estimated coefficient values.

{p 4 9 2}
23.  {helpb sts graph} with option {cmd:risktable()} and suboptions
     {cmd:rowtitle()} and {cmd:group()} did not respect those suboptions when
     option {cmd:by()} was also specified with multiple variables.  This has
     been fixed.

{p 4 9 2}
24.  {helpb sunflower} with option {opt name()} and without option
     {opt binar()} unintentionally changed the contents of the default graph
     named {cmd:Graph}.  This has been fixed.

{p 4 9 2}
25.  {helpb svy} estimation with {helpb svyset} poststratification did not
     account for observations excluded from the estimation sample when running
     the estimation command.  This could result in positively or negatively
     biased results depending on which poststratum observations were excluded
     and the value of the corresponding poststratum weights.  In either case,
     standard errors were inflated.  {cmd:svy} now reports a note when this
     occurs and reruns the estimation command with the poststratification
     adjustment accounting for the new estimation sample.

{p 9 9 2}
     The following commands did not have this problem:  {helpb mean},
     {helpb proportion}, {helpb ratio}, {helpb total},
     {helpb svy_tabulate_oneway:svy: tabulate oneway}, and
     {helpb svy_tabulate_twoway:svy: tabulate twoway}.

{p 4 9 2}
26.  {helpb svy bootstrap}, {helpb svy brr}, {helpb svy jackknife}, and
     {helpb svy sdr} incorrectly ignored option {helpb eform_option:eform}.
     This has been fixed.

{p 4 9 2}
27.  {helpb testparm} produces a more informative error message when
     {it:varlist} does not identify any testable coefficients.

{p 4 9 2}
28.  Stata could crash if more than two gigabytes of data were copied to the
     clipboard from the Data Editor and then subsequently pasted back to the
     Data Editor.  Now the Data Editor limits the amount of data that can be
     copied to the clipboard to two gigabytes.

{p 4 9 2}
29.  In Stata/MP with more than 50 processors or cores and in rare cases that
     depended on the number of observations being sorted, {helpb sort} could
     stop with error message "{err:failed to select pivot values}".  This has
     been fixed.

{p 4 9 2}
30.  (Mac) The Do-file Editor's Find bar would sometimes not appear when
     activated, and an empty line would appear in its place.  This has been
     fixed.

{p 4 9 2}
31.  (Mac) When using a do-file to create graphs, closing nontabbed Graph
     windows that were in fullscreen mode left empty spaces in Mission
     Control.  This has been fixed.

{p 4 9 2}
32.  (Mac) Stata would open in the root directory, "/", when launched directly
     from the Finder on Mac OS X 10.10 (Yosemite).  This has been fixed.

{p 4 9 2}
33.  (Mac) Stata for Mac (GUI) would set the graphics setting to off when
     launched from the command line with the -q flag.  Setting graphics off
     prevents graphs from rendering to the screen.  The -q flag no longer sets
     the graphics setting to off.

{p 4 9 2}
34.  (Mac) The console version of Stata would search only in
     /Applications/Stata for the Stata directory.  It now searches for the
     Stata directory in /Applications/Stata13.1, /Applications/Stata13.0,
     /Applications/Stata13, and /Applications/Stata, in that order.

{p 4 9 2}
35.  (Unix GUI) The {cmd:import excel} dialog box, when {cmd:lower} was
     selected from the "Variable case" combo box, did not issue the command
     with option {cmd:case(lower)}.  This has been fixed.


{hline 8} {hi:update 06may2014} {hline}

{p 5 9 2}
1.  {helpb estimates for} with {helpb estat ic} incorrectly failed with an
    error message.  {cmd:estimates for} now works with {cmd:estat ic}.

{p 5 9 2}
2.  {helpb etregress} with option {cmd:vce(robust)} reported a
    likelihood-ratio test for the test of independent equations (null is no
    endogeneity).  This test did not use the robust VCE and thus would
    over reject the alternative of endogenous treatment in the usual case
    where the robust SEs are larger than the standard SEs.  So the test was
    conservative with regard to endogeneity.  {cmd:etregress} now reports a
    robust Wald test of independent equations.

{p 5 9 2}
3.  Function {help rnormal:{bf:rnormal(}{it:m}{bf:,}{it:s}{bf:)}} returned
    0 in the unusual case where {it:s} was 0, even when {it:m} was specified
    to be nonzero.  {cmd:rnormal()} now returns {it:m} in such cases.

{p 5 9 2}
4.  {helpb gsem_command:gsem}, when the observed endogenous variable was part
    of a predictor term using factor-variables notation, failed to catch
    unsupported nonrecursive systems.  This has been fixed.

{p 9 9 2}
    For example, the following model specifications will now cause a syntax
    error because {cmd:y1} and {cmd:y2} form a nonrecursive system that is not
    supported by {cmd:gsem}.

{p 13 13 2}
	{cmd:gsem (y1 <- y2 x1, logit) (y2 <- i.y1 x2)}

{p 13 13 2}
	{cmd:gsem (y1 <- y2 x1, ologit) (y2 <- i.y1 x2)}

{p 13 13 2}
	{cmd:gsem (y1 <- y2 x1) (y2 <- c.y1##c.x2)}

{p 5 9 2}
5.  {helpb import excel} refused to open some Excel files created by Apple
    Numbers for Mac.  This has been fixed.

{p 5 9 2}
6.  Functions {helpb colnumb()}, {helpb el()}, and {helpb rownumb()}, when
    used in a scalar expression, reported an error message if the supplied
    matrix name was an unambiguous abbreviation of 2 or more variables, even
    when a matrix of that exact name existed.  This has been fixed.

{p 5 9 2}
7.  {helpb merge} with option {opt keepusing()}, where variables in the
    using dataset shared names with variables in the master dataset and some
    were omitted from the {opt keepusing()} varlist, sometimes returned
    nonmissing values for unmatched observations when it should have returned
    missing values.  This has been fixed.

{p 5 9 2}
8.  {helpb odbc sqlfile} stopped execution of the SQL file if an SQL command
    in the file did not return results.  This has been fixed.

{p 5 9 2}
9.  {helpb qreg} with probability weights ({helpb pweight}s) or importance
    weights ({helpb iweight}s) did not produce correct standard errors.  This
    has been fixed.

{p 4 9 2}
10.  {helpb reshape}, when the j variable value label contained only labels
     for extended missing values, produced error code
     {bf:{search r(198):r(198)}}.  This has been fixed.

{p 4 9 2}
11.  {helpb sts graph} did not respect option {opt censopts()} when option
     {opt risktable} was also specified.  This has been fixed.

{p 4 9 2}
12.  {helpb teffects psmatch} and {helpb teffects nnmatch} with option
     {opt nneighbors(#)} did not enforce that {it:#} matches were found for
     each observation.  Estimation continued so long as one match could be
     found.  {cmd:teffects} now strictly enforces that {it:#} matches are
     found for each observation and provides diagnostics to help you identify
     observations with too few matches.

{p 4 9 2}
13.  (Mac) The Open dialog for the Viewer now allows {bf:.log} files to be
     selected.

{p 4 9 2}
14.  (Mac) The 31mar2014 update introduced a bug where printing the Results or
     Viewer window would print only the first page.  This has been fixed.

{p 4 9 2}
15.  (Mac) Class files were not enabled in the Open dialog for the Do-file
     Editor.  In rare cases, a Do-file Editor would not be correctly sized in
     its window when there were multiple tabs in the window.  These problems
     have been fixed.

{p 4 9 2}
16.  (Mac) The Variables window was not updating after a Stata command was
     executed from AppleScript.  This has been fixed.

{p 4 9 2}
17.  (Mac) Opening log and SMCL files from the Finder now opens the files in
     their own tab in the Viewer.


{hline 8} {hi:update 24apr2014} {hline}

{p 5 9 2}
1.  {helpb sem_estat_eqtest:estat eqtest} after {helpb sem_command:sem} with
    prefix command {helpb svy} now uses survey-adjusted F tests for the
    equation-level coefficients when design degrees of freedom is present.
    Option {opt nosvyadjust} was added to {cmd:estat eqtest} to provide
    unadjusted F tests.

{p 5 9 2}
2.  {helpb expoisson} using {cmd:fweight}s with more than one covariate gave
    the wrong coefficient estimate for all covariates beyond the first.  This
    has been fixed.

{p 5 9 2}
3.  {helpb ivregress} has the following fixes:

{p 9 13 2}
     a.  {cmd:ivregress}, when used with a certain configuration of factor
	 variables, could produce an error message.  This happened when the
	 terms of a factorial interaction were split between the exogenous
	 regressors and the instrumental-variables list.  This has been fixed.

{p 9 13 2}
     b.  {cmd:ivregress}, in the unusual cases where each exogenous regressor
	 was perfectly collinear with the endogenous regressor or
	 constant-valued, produced an error message.  {cmd:ivregress} now
	 drops these variables and performs the estimation.

{p 5 9 2}
4.  {helpb marginsplot}, when used correctly with the results from
    {helpb margins} after a constant-only model, reported error message
    "{err:variable _cons not found}".  This has been fixed.

{p 5 9 2}
5.  {cmd:predict} after {helpb gsem_predict:gsem} and
    {helpb meglm_postestimation##predict:meglm} now produces a more
    informative error message when empirical Bayes estimates are to be
    computed but the data have changed since estimation.

{p 5 9 2}
6.  {helpb sem_command:sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem} with option {opt group()} specified with prefix command
	 {helpb bootstrap}, {helpb jackknife}, or {helpb svy} incorrectly
	 exited with error message "{err:label already defined}" when the
	 group variable had value labels attached.  This has been fixed.

{p 9 13 2}
     b.  {cmd:sem} exited with a Mata conformability trace error message when
	 specified with exactly one endogenous latent variable with no
	 predictors.  This has been fixed.

{p 5 9 2}
7.  {helpb svy sdr} with option {opt subpop()} specified with command
    {helpb mean}, {helpb proportion}, {helpb ratio}, or {helpb total} and
    option {opt over()} incorrectly reported an invalid syntax error
    message after the replications were complete.  This has been fixed.

{p 5 9 2}
8.  {helpb _coef_table} with option {opt dfmatrix()} required a nonmissing
    value stored in {cmd:e(df_r)}; otherwise, it failed to use t in the column
    labels for the test statistic and p-values.  This has been fixed.


{hline 8} {hi:update 31mar2014} {hline}

{p 5 9 2}
1.  {helpb dtaversion} and {helpb dtaverify} are new, {help undocumented}
    commands in Stata.  "Undocumented" means the commands are not documented
    in the manuals but are documented online.

{p 9 9 2}
    {cmd:dtaversion} reports an internal {cmd:.dta} file-format version
    number and the corresponding Stata version number.  The command is
    probably of little interest outside StataCorp.

{p 9 9 2}
    {cmd:dtaverify} confirms the consistency of a {cmd:.dta} file; that is, it
    checks whether the {cmd:.dta} file is corrupt.  For most of us, this
    command is useful when we want to determine the file is not damaged from
    an accident, say, coffee spilling on the computer.  Programmers writing
    programs to write Stata {cmd:.dta} files will find {cmd:dtaverify} even
    more useful because they can use it to debug their programs.
    {cmd:dtaverify} provides a lot of useful information when the {cmd:.dta}
    file has errors.

{p 5 9 2}
2.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 14(1).

{p 5 9 2}
3.  Calling {cmd:exit, clear STATA} from a do-file more than one execution
    level deep would cause Stata to hang.  This has been fixed.

{p 5 9 2}
4.  {helpb forecast} exited with an error message when an {helpb arima} model
    had covariates.  This has been fixed.

{p 5 9 2}
5.  {helpb fp} could produce an error message when used with an estimation
    command that created new variables.  This has been fixed.

{p 5 9 2}
6.  Function
    {helpb invnFtail:{bf:invnFtail(}{it:df1}{bf:,}{it:df2}{bf:,}{it:np}{bf:,}{it:p}{bf:)}}
    could return incorrect results when {it:p} was very small.  This has been
    fixed.

{p 5 9 2}
7.  Function {helpb regexr()} was much slower in Stata 13 compared with
    Stata 12.  The speed of the function in Stata 13 is now improved to be
    comparable with the speed in Stata 12 on fixed-length strings.  The speed
    is also improved on the new long strings.

{p 5 9 2}
8.  {helpb glm} with {cmd:family(binomial)} and nonzero fractional responses
    would incorrectly exit with the error message "{error:no observations}",
    {search r(2000)}, and a note that the outcome does not vary.  This has
    been fixed.

{p 5 9 2}
9.  {helpb graph twoway} with multiple labels specified in option
    {opt tlabel()} produced bolding effects on the labels.  This has been
    fixed.

{p 4 9 2}
10.  {helpb gsem_command:gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem} failed to report a syntax error when weights were
	 specified.  This has been fixed.

{p 9 13 2}
     b.  {cmd:gsem} with certain constraints could try to fit a Gaussian
	 outcome variable with a starting value of zero for an error
	 variance, causing {cmd:gsem} to exit with the error message
	 "{error:initial values are not feasible}".  This has been fixed.

{p 4 9 2}
11.  {helpb import excel} failed to open some Excel files created by Apple
     Numbers for Mac.  This has been fixed.

{p 4 9 2}
12.  {helpb meglm} ignored covariance constraints specified with the
     {opt constraints()} option.  This has been fixed.

{p 4 9 2}
13.  {helpb merge} could issue the error message "{err:.dta file corrupt}",
     {search r(688):r(688)}, when merging datasets that both contained strL
     variables of the same name, and in a different, but special, order.  The
     error message was unlikely and incorrect; none of the {cmd:.dta} files
     were corrupt.  The invalid error message produced by {cmd:merge} has been
     fixed.

{p 4 9 2}
14.  {helpb mi_impute_logit:mi impute logit},
     {helpb mi_impute_ologit:mi impute ologit}, and
     {helpb mi_impute_mlogit:mi impute mlogit} now issue a more informative
     error message when any of the unsupported
     {it:maximize_options} are used in
     combination with the {cmd:augment} option.  The documentation now
     explicitly lists all such options.

{p 4 9 2}
15.  {helpb mi_impute_intreg:mi impute intreg, bootstrap} ignored all censored
     observations when obtaining a bootstrap sample during the estimation step
     of the imputation procedure.  The problem would also arise when the
     {cmd:intreg} method was used within
     {helpb mi_impute_chained:mi impute chained} and the {cmd:bootstrap}
     option was specified either as a global option --
     {cmd:mi impute chained (intreg), bootstrap} -- or as a method-specific
     option of the {cmd:intreg} method --
     {cmd:mi impute chained (intreg, bootstrap)}.  This has been fixed.

{p 4 9 2}
16.  {helpb mlogit} now reports the number of completely determined
     observations in a footnote after the coefficient table.

{p 4 9 2}
17.  {helpb oprobit} with {cmd:fweight}s neglected to count the number of
     observations with completely determined outcomes.  This has been fixed.

{p 4 9 2}
18.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} with
     {cmd:poisson} or {cmd:binomial} outcomes and with missing values within
     the estimation sample exited with the error message
     "{error:numerical overflow occurred}".  This has been fixed.

{p 4 9 2}
19.  {helpb sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem} with more than 40 model variables and more than just a few
	 groups would sometimes incorrectly report the error message
	 "{error:insufficient memory}" even when the model parameters would
	 fit within a coefficient vector with {cmd:c(matsize)} elements.  This
	 has been fixed.

{p 9 13 2}
     b.  {cmd:sem} with {cmd:method(mlmv)} and {helpb pweight}s was producing
	 invalid and highly inflated standard errors.  The inflation factor
	 was on the order of the average of the sampling weights.  This has
	 been fixed.

{p 4 9 2}
20.  The {help sembuilder:SEM Builder} has the following fixes:

{p 9 13 2}
     a.  When performing group analysis, you could save a path diagram that
	 could not be restored or that led to Builder errors when restored and
	 edited.  This problem occurred only if the final estimation before
	 saving the path diagram was run while the {bf:Group} control in the
	 {bf:Toolbar} was not set to the first group, and even then, only
	 rarely.  This has been fixed.

{p 9 13 2}
     b.  If a Builder file was saved after estimation with method {cmd:mlmv}
	 and you requested that required covariances among observed variables
	 not be added to the diagram, those covariances would be shown on the
	 path diagram when the file was later used.  This has been fixed.

{p 9 13 2}
     c.  Opening path diagrams when the diagram's filename contained special
	 characters could put the Builder in a bad state.  One common symptom
	 was loss of the Contextual toolbar.  This has been fixed.

{p 9 13 2}
     d.  The SEM Builder no longer allows you to create objects that are of 0
	 width or 0 height.

{p 4 9 2}
21.  {helpb svy} reported negative F statistics instead of reporting a missing
     value for fitted models where the design degrees of freedom was smaller
     than the number of model coefficients.  This has been fixed.

{p 4 9 2}
22.  {helpb svy brr} with {helpb sem} would produce an unintended
     error message "{err:operator invalid}" after looping through the
     replicates.  This has been fixed.

{p 4 9 2}
23.  {helpb teffects} has the following fixes:

{p 9 13 2}
     a.  The nearest-neighbor algorithm used by {helpb teffects nnmatch} and
	 {helpb teffects psmatch} failed to check for a user-initiated
	 execution break.  This has been fixed.

{p 9 13 2}
     b.  {helpb teffects overlap} overwrote the estimation result
	 {cmd:e(cmdline)}.  This has been fixed.

{p 9 13 2}
     c.  {cmd:teffects} produced an error message when {cmd:control()} was
	 specified with a value label that had spaces.  This has been fixed.

{p 4 9 2}
24.  (Windows) Function {helpb acosh:{bf:acosh(}{it:x}{bf:)}} could return
     incorrect results when {it:x} was very large.  This has been fixed.

{p 4 9 2}
25.  (Windows) Function {helpb asinh:{bf:asinh(}{it:x}{bf:)}} could return
     incorrect results when |{it:x}| was very large.  This has been fixed.

{p 4 9 2}
26.  (Mac) You may now specify the ODBC driver manager by using
     {cmd:set odbcmgr} {c -(}{opt iodbc}{c |}{opt unixodbc}{c )-}.

{p 4 9 2}
27.  (Mac) The Do-file Editor has the following fixes:

{p 9 13 2}
     a.  (Mac) Multiple uses of {bf:Find} could cause a crash when using the
	 keyboard to navigate or dismiss the {bf:Find} control.  This has been
	 fixed.

{p 9 13 2}
     b.  (Mac) Stata help files could not be opened in the Do-file Editor.
	 This has been fixed.

{p 9 13 2}
     c.  (Mac) The print dialog for the Do-file Editor would not show an
	 up-to-date preview of what would be printed based on the print line
	 number preference.  This has been fixed.

{p 4 9 2}
28.  (Mac) The search-has-wrapped status window no longer appears when the
     cursor has been moved past the last found item.


{hline 8} {hi:update 15jan2014} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 13(4).

{p 5 9 2}
2.  {helpb forecast} now solves models more quickly.  Forecast models that
    include estimation results from {helpb arima} will show significantly
    faster solve times, and nearly all forecast models will show at least
    slight speed improvements.

{p 5 9 2}
3.  Commands that utilize substitutable expressions ({helpb gmm}, {helpb nl},
    {helpb nlsur}, and {helpb mlexp}) now benefit from the multiple-core
    features of Stata/MP and exhibit nearly perfect parallelization.

{p 5 9 2}
4.  {helpb generate} and {helpb replace}, when the right-hand-side expression
    included references to elements of Stata matrices, did not benefit from
    parallelization.  These commands now exhibit nearly perfect
    parallelization when the matrix subscripts are specified as numeric
    scalars.

{p 5 9 2}
5.  {helpb asmprobit} failed to display the coefficient table when there were
    no case-specific variables and no constant terms in the model.  This has
    been fixed.

{p 5 9 2}
6.  {helpb estat recovariance} after
    {helpb mixed} failed to report the covariance of the factor variable
    {it:varname} for a random-effects equation specified with
    {cmd:R.}{it:varname} and option {cmd:covariance(exchangeable)}.  This has
    been fixed.

{p 5 9 2}
7.  {helpb me estat wcorrelation:estat wcorrelation} after
    {helpb mixed}, when models included 1) multiple random-effects
    specifications with the same level variable or 2) a random-effects
    equation specified with {cmd:R.}{it:varname} and option
    {cmd:covariance(exchangeable)}, produced incorrect results.  The affected
    results were the within-cluster correlation and covariance matrices, the
    variance-covariance matrix of random effects {cmd:r(G)}, and the
    model-based design matrix for random effects {cmd:r(Z)}.  This has been
    fixed.

{p 5 9 2}
8.  {helpb estimates table} after {helpb sem} with option {cmd:group()}
    reported "(empty)" for all intercepts, means, and variance components.
    This has been fixed.

{p 5 9 2}
9.  {helpb export delimited} failed to respect double quotes
    embedded in string data.  {cmd:export delimited} now correctly respects
    double quotes embedded in string data by exporting two double quotes for
    each real double quote.

{p 4 9 2}
10.  {helpb export excel} would not execute {helpb quietly} if you specified
     option {cmd:replace} and a path to a file that contained a space.  This
     has been fixed.

{p 4 9 2}
11.  {helpb fcast compute} after {helpb vec} has the following fixes:

{p 9 13 2}
     a.  {cmd:fcast compute} after {cmd:vec} failed to clear the global macro
         {cmd:S_vecfcast_cr} after execution and thus would accumulate a long
         string in this macro when called repeatedly.  When the resulting
         string exceeded the maximum allowed length, the command would produce
         error message
         "{err:macro substitution results in line that is too long}".  This
         has been fixed.

{p 9 13 2}
     b.  On error, {cmd:fcast compute} after {cmd:vec} dropped all variables
         created by previous calls to {cmd:fcast compute}.  This has been
         fixed.

{p 4 9 2}
12.  {helpb forecast solve} exited with an error message when the forecast
     model included an estimation result in which equation names were
     specified (such as from {helpb reg3}).  This has been fixed.

{p 4 9 2}
13.  {helpb gmm} exited with an error message if the user supplied analytic
     derivatives and specified option {opt nocommonesample} but did not
     specify option {opt xtinstruments()}, even if the model could be fit.
     This has been fixed.

{p 4 9 2}
14.  {helpb gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem} failed to report a variance component in the coefficient
         table if the preceding row was the base outcome from a multinomial
         response variable.  This has been fixed.

{p 9 13 2}
     b.  {cmd:gsem} with multiple observed endogenous variables each having a
         path from an interaction containing a latent variable was not
         applying the automatic anchoring logic correctly, causing
         coefficients on those paths to be constrained to 1.  This has been
         fixed.

{p 9 13 2}
     c.  {cmd:gsem} was not using the variables specified in the censoring
         suboptions allowed in {cmd:family(gaussian)} when computing the
         {help signestimationsample:signed estimation} results.  This has been
         fixed.

{p 4 9 2}
15.  {helpb import delimited} has the following new features and fixes:

{p 9 13 2}
     a.  A new option has been added to {cmd:import delimited}.
         {cmd:charset("}{it:charset}{cmd:")} sets the character set used for
         importing ASCII text data.  By default, {cmd:latin1} (ISO-8859-1
         encoding) will be used; however, {cmd:mac} (Mac OS Roman encoding)
         may be specified where appropriate.

{p 9 13 2}
     b.  {cmd:import delimited} ignored option {opt rowrange()} when
         specified with a row range greater than 10,000,000.  This has been
         fixed.

{p 9 13 2}
     c.  The dialog box for {cmd:import delimited} failed to use
         compound double quotes with custom delimiters that contained actual
         quotes, resulting in an error in the generated command.  This has
         been fixed.

{p 4 9 2}
16.  {helpb ivregress} with options {cmd:first} and {cmd:vce(robust)} could
     produce an error message when the endogenous variable list contained a
     factor variable that included an omitted category.  This has been fixed.

{p 4 9 2}
17.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} no longer allows option {opt coeflegend} if the
         {opt post} option is not also specified.

{p 9 13 2}
     b.  {cmd:margins} after {helpb gsem} with multinomial outcomes reported
         all margins as "(not estimable)".  This has been fixed.

{p 4 9 2}
18.  {help matrix_operators:Matrix} Kronecker products with time-series
     operators or factor-variable notation in the row or column names were
     not yielding the expected equation names in the resulting matrix.  This
     has been fixed.

{p 4 9 2}
19.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} with
     options {cmd:vce(bootstrap, bca)} and {cmd:over()} would incorrectly
     report error message "{err:option sovar() not allowed}".  This has
     been fixed.

{p 4 9 2}
20.  {helpb mi estimate} has the following fixes:

{p 9 13 2}
     a.  {cmd:mi estimate}, when used with {cmd:mean}, {cmd:proportion},
         {cmd:ratio}, or {cmd:total}, could produce missing
         multiple-imputation standard errors when some of the
         imputation-specific standard errors were legitimate zeros.  For
         example, the {cmd:mean} command reports a standard error of zero for
         a constant variable.  {cmd:mi estimate} now reports the estimates
         instead of missing values.

{p 9 13 2}
     b.  {cmd:mi estimate}, when used with {cmd:mean}, {cmd:proportion},
         {cmd:ratio}, or {cmd:total}, now produces missing multiple-imputation
         standard errors for any parameter that was estimated using a
         sample of only one observation in any of the imputations, that is,
         for any parameter for which the corresponding element of the
         {cmd:e(_N)} matrix is {cmd:1} in any of the imputations.

{p 4 9 2}
21.  {helpb mi impute chained} has the following fixes:

{p 9 13 2}
     a.  {cmd:mi impute chained} could produce error message
         "{err:missing imputed values are produced}" during the initial
         conditional imputation when option {cmd:include()} contained
         expressions of imputation variables and the names of those variables
         happened to be abbreviations of other variables in the dataset.  This
         has been fixed.

{p 9 13 2}
     b.  {cmd:mi impute chained} mistakenly produced error message
         "{err:missing imputed values are produced}" when option
         {cmd:noimputed} was specified and option {cmd:include()}
         contained a categorical or binary imputation variable with a factor
         specification other than {cmd:i.}{it:varname}.  This has been fixed.

{p 4 9 2}
22.  During conditional imputation, {helpb mi impute chained} and
     {helpb mi impute monotone} failed to check the order in which the
     conditional and conditioning variables were imputed when the conditional
     variable contained the same number of missing observations as one of the
     conditioning variables.  The commands now produce an error message if a
     conditional variable is listed before its conditioning variables in the
     specification of an imputation model.

{p 4 9 2}
23.  {helpb mi reshape} has the following fixes:

{p 9 13 2}
     a.  {cmd:mi reshape} allowed {cmd:@} in the specification of {it:stubs}
         when it should not have.  If {cmd:@} is specified, the proper error
         message is now produced.

{p 9 13 2}
     b.  All variables corresponding to the same {it:stub} must be registered
         of the same {cmd:mi} type:  {cmd:imputed}, {cmd:passive}, or
         {cmd:regular}.  {cmd:mi reshape} did not return the proper error
         message if these variables were of mixed {cmd:mi} types.  This has
         been fixed.

{p 4 9 2}
24.  {helpb nlcom} and {helpb lincom}, when estimating an expression involving
     a comma (like {cmd:_b[/cov(e.x,e.y)]}), produced an error message.  This
     has been fixed.

{p 4 9 2}
25.  {helpb nlogit} could drop too many alternative-specific variables if one
     alternative-specific variable was collinear with a variable specified in
     the last {help nlogit##byaltvarlist:alternative varlist} after it was
     interacted with indicators of the alternatives.  This has been fixed.

{p 4 9 2}
26.  {helpb power twomeans} incorrectly defined the effect size ({cmd:delta})
     as the ratio of the difference between the experimental-group mean and
     the control-group mean to the standard error of the difference between
     two sample means.  This led to the definition of an effect size that
     involves sample sizes.  The effect size is now defined to be the
     difference between the experimental-group mean and the control-group
     mean.  This change does not affect any previously obtained estimates of
     sample size or power, only the reported and computed effect sizes.

{p 4 9 2}
27.  {helpb sem} has improved starting values logic for models that use
     latent variables to model error covariances between observed endogenous
     variables.

{p 4 9 2}
28.  {helpb sqreg} computations could fail in {cmd:qreg} when computing robust
     standard errors unnecessarily.  {cmd:sqreg} bootstraps the standard
     errors.  This has been fixed.

{p 4 9 2}
29.  {helpb stptime} and {helpb strate}, when the jackknife method was used,
     could report jackknife confidence intervals that did not include the
     estimated rate for survival datasets that contained no failures, only one
     failure, or only one cluster with failures.  They now report missing
     confidence intervals and a note with explanation in these situations.

{p 4 9 2}
30.  {helpb svy jackknife} with {helpb svyset} data that did not have a
     specified {helpb pweight} variable always reported error message
     "{err}insufficient observations to compute jackknife standard errors no
     results will be saved{reset}".  This has been fixed.

{p 4 9 2}
31.  {helpb svy tabulate}, when used with a string variable, reported a
     temporary variable name in the output instead of the specified variable.
     This has been fixed.

{p 4 9 2}
32.  {helpb teffects psmatch} with options {cmd:atet}, {cmd:vce(iid)}, and
     {cmd:caliper()} unnecessarily required valid matches for control subjects
     and would exit with an error if this requirement was not met.
     With these three options, {cmd:teffects} {cmd:psmatch} would
     unnecessarily exit with an error when it could not find a treated
     observation that was within {cmd:caliper()} distance of a control
     observation.  This has been fixed.

{p 4 9 2}
33.  (Windows) As of the 30oct2013 update, unconnected lines such as grid
     lines and axes now use butt line caps rather than round line caps.  With
     this change, the behavior for Windows is the same as Mac and Unix
     platforms.  The new behavior matches the results produced by
     {helpb graph export} when producing EPS, PS, and PDF files.

{p 4 9 2}
34.  (Windows) Pasting multiple commands into Stata's Command window and then
     minimizing Stata before the commands completed could result in one
     character being removed from a subsequent command, resulting in an error
     message.  This has been fixed.

{p 4 9 2}
35.  (Mac) Graphs could not be exported to EPS or PS while being edited in the
     Graph Editor.  This has been fixed.

{p 4 9 2}
36.  (Mac) Stata could crash if multiple graphs were drawn while the Do-file
     Editor was in full-screen mode.  This has been fixed.

{p 4 9 2}
37.  (Mac) Generating a complex graph and immediately exporting the graph to a
     PDF file could include visual artifacts in the PDF file.  This has been
     fixed.

{p 4 9 2}
38.  (Mac) When users tried saving a recording in the Graph Editor, Stata
     would crash if the "Save graph recording as:" edit field was empty and
     button {bf:Browse...} was clicked on.  This has been fixed.

{p 4 9 2}
39.  (Mac) Saved preference {cmd:max_memory} would not be read correctly if
     the setting was large.  This has been fixed.

{p 4 9 2}
40.  (Mac) Selecting {bf:Edit > Undo} after editing text in the Data Editor
     and applying the change would cause Stata to crash.  This has been fixed.


{hline 8} {hi:update 30oct2013} (Stata version 13.1) {hline}

{p 5 9 2}
1.  {helpb power} has three new methods for power and sample-size analysis of
    ANOVA models.

{p 9 9 2}
    {helpb power oneway} performs power and sample-size analysis for one-way
    ANOVA models.  It computes sample size, power, or effect size given other
    study parameters.  It provides computations for unbalanced designs and for
    mean contrasts.  It also supports multiple specifications of input
    parameters.  For example, to compute power or sample size, you can either
    specify group means directly or specify their between-group variability.

{p 9 9 2}
    {helpb power twoway} performs power and sample-size analysis for two-way
    ANOVA models.  It computes sample size, power, or effect size given other
    study parameters and supports unbalanced designs.  It also supports
    multiple specifications of input parameters.  For example, to compute
    power or sample size, you can either specify cell means directly or
    specify the variance of the tested effect.

{p 9 9 2}
    {helpb power repeated} performs power and sample-size analysis for one-way
    and two-way repeated-measures ANOVA models.  It computes sample size,
    power, or effect size given other study parameters and supports
    unbalanced designs.  It also supports multiple specifications of input
    parameters.  For example, to compute power or sample size, you can either
    specify cell means directly or specify the variance of the tested effect.

{p 9 9 2}
    As in all other {cmd:power} methods, {cmd:oneway}, {cmd:twoway}, and
    {cmd:repeated} allow you to specify multiple values of parameters and
    automatically produce results in a table or on a graph.

{p 5 9 2}
2.  {helpb power oneproportion} and {helpb power twoproportions} have new
    option {cmd:continuity}, which applies a continuity correction to the
    normal approximation of the discrete distribution.

{p 5 9 2}
3.  {helpb power} now provides facilities for users to add their own methods
    to {cmd:power}.  See {cmd:power userwritten} for details.

{p 5 9 2}
4.  Six noncentral chi-squared functions are added or improved. The following
    three functions are added:

{p2colset 14 37 41 2}{...}
{p2col:New functions}Description{p_end}
{p2line}
{p2col:{cmd:nchi2den(}{it:df}{cmd:,}{it:np}{cmd:,}{it:x}{cmd:)}}probability
        density of noncentral chi-squared distribution{p_end}
{p2col:{cmd:nchi2tail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:x}{cmd:)}}right-tailed
	noncentral chi-squared distribution{p_end}
{p2col:{cmd:invnchi2tail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}}inverse
	of right-tailed noncentral chi-squared distribution{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
    The following three functions are improved (they now support broader
    domains for degrees of freedom and noncentrality parameter):

{p2colset 14 37 41 2}{...}
{p2col:Improved functions}Description{p_end}
{p2line}
{p2col:{cmd:nchi2(}{it:df}{cmd:,}{it:np}{cmd:,}{it:x}{cmd:)}}cumulative
	noncentral chi-squared distribution{p_end}
{p2col:{cmd:invnchi2(}{it:df}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}}inverse
	cumulative noncentral chi-squared distribution{p_end}
{p2col:{cmd:npnchi2(}{it:df}{cmd:,}{it:x}{cmd:,}{it:p}{cmd:)}}noncentrality
	parameter of noncentral chi-squared distribution{p_end}
{p2line}
{p2colreset}{...}

{p 5 9 2}
5.  {helpb gsem}'s {cmd:family(gaussian)} option now has suboptions for
    censoring when {cmd:link(identity)} is used.  See
    {helpb gsem_family_and_link_options:[SEM] gsem family-and-link options}.

{p 5 9 2}
6.  {helpb irf} now works after {helpb arima} and {helpb arfima}.

{p 5 9 2}
7.  New command {helpb estat aroots} checks the eigenvalue stability
    condition after estimating the parameters of a model with time-dependent
    disturbances using {helpb arima}.

{p 5 9 2}
8.  New command {helpb estat acplot} estimates autocorrelation and
    autocovariance functions after estimating the parameters of a model with
    time-dependent disturbances using {helpb arima} or {helpb arfima}.

{p 5 9 2}
9.  {helpb psdensity} now works after {helpb arima} with multiplicative
    autoregressive moving-average (ARMA) terms.

{p 4 9 2}
10.  {helpb putexcel} has new option {opt keepcellformat}, which preserves a
     cell's style and format when {cmd:putexcel} writes a value to a cell.

{p 4 9 2}
11.  {helpb mecloglog}, {helpb melogit}, and {helpb meprobit} have new option
     {opt asis} for retaining perfect predictors.  The new default behavior is
     to detect and omit perfect predictors.  The old default behavior of
     retaining perfect predictors is preserved under version control.

{p 4 9 2}
12.  {helpb bsample} and {helpb bootstrap} with option {opt idcluster()} will
     now produce a unique identifier for each resampled cluster even when
     option {opt strata()} is specified.  The old behavior of indexing
     resampled clusters starting with 1 from within each stratum is preserved
     under version control.

{p 4 9 2}
13.  {helpb export excel} did not export a variable formatted as {cmd:%d} as a
     date.  This has been fixed.

{p 4 9 2}
14.  {helpb forecast solve} exited with an error message if you attempted to
     forecast a panel-data model and specified suboption {opt saving()} of
     option {opt simulate}.  This has been fixed.

{p 4 9 2}
15.  {helpb merge} and {helpb append}, if an error occurs, are supposed to
     leave the original data in memory.  If an error occurred, however, they
     could leave the original data with extra observations at the end.  This
     has been fixed.

{p 4 9 2}
16.  {helpb mgarch_vcc_postestimation##predict:predict} with option
     {cmd:variance} or option {cmd:correlation} produced incorrect results
     after {helpb mgarch vcc}.  This has been fixed.

{p 4 9 2}
17.  Function {helpb subinword()} could match the ending of a word rather than
     matching an entire word.  This has been fixed.

{p 4 9 2}
18.  Pasting data into the Data Editor did not update the internal
     list of sorted variables.  Now if you paste data into one of the variables
     on which the data was sorted, the list is updated.

{p 4 9 2}
19.  Strings passed from Stata to the Java Runtime Environment containing
     characters encoded with ASCII values between 128 and 255 might not get
     passed through correctly.  This problem was originally discovered when
     writing data to an {help mf__docx:Office Open XML (.docx) file}.  This
     has been fixed.

{p 4 9 2}
20.  (Windows) {helpb update} failed to install from a local directory when
     Stata was run from a shared network.  This has been fixed.

{p 4 9 2}
21.  (Windows) Pressing the {hi:Break} button when executing code with
     {helpb nobreak} would cause Stata to issue a message box stating
     "Break disallowed at this time".  Though informative, this behavior
     prevented programmers from coding specialized break logic.  Stata for
     Windows will now have the same behavior as Stata on other platforms and
     simply ignore {helpb break} when code is executed with {helpb nobreak}.

{p 4 9 2}
22.  (Mac) The Project Manager now opens SMCL and help files in the Viewer
     window instead of the Do-file Editor.

{p 4 9 2}
23.  (Mac) The default width for the Viewer window was less than 80 columns.
     This has been fixed.

{p 4 9 2}
24.  (Mac) Dragging and dropping text to the Do-file Editor or Command window
     did not result in any text inserted.  This has been fixed.

{p 4 9 2}
25.  (Mac) OS X 10.9 (Mavericks) or Java on Mavericks has a bug that could
     lead to a crash in Stata when Stata accessed Java in the
     {helpb project manager:Project Manager},
     the GUI for the {helpb power} command, the {helpb import delimited}
     command, https or ftp URLs, or the Mata {helpb mf__docx:_docx*()}
     functions.  This update works around the bug to avoid the possibility of
     such a crash.

{p 4 9 2}
26.  (Mac) OS X 10.9 (Mavericks) introduced a change that caused Stata to
     always start in the root directory "/" instead of the working directory
     from Stata's previous session.  This would only affect Stata if it was
     launched by double-clicking on it in the Finder, not by double-clicking
     on a do-file or dataset from the Finder.  This has been fixed.

{p 4 9 2}
27.  (Unix) Double-clicking on a .smcl file from a project in the Project
     Manager now opens the file in a Viewer.


{hline 8} {hi:update 07oct2013} {hline}

{p 5 9 2}
1.  The logic for detecting perfect predictors built into {helpb logit} and
    {helpb probit} has been added to the following estimation commands.
    Option {cmd:asis} has also been added.

		{helpb glm} with family {cmd:binomial}
		{helpb xtgee} with family {cmd:binomial}
		{helpb xtcloglog}{cmd:, pa}
		{helpb xtcloglog}{cmd:, re}
		{helpb xtlogit}{cmd:, pa}
		{helpb xtlogit}{cmd:, re}
		{helpb xtprobit}{cmd:, pa}
		{helpb xtprobit}{cmd:, re}

{p 5 9 2}
2.  {helpb contrast} with survey estimation results posted the unadjusted
    F statistics and p-values in {cmd:r(F)} and {cmd:r(p)},
    respectively, even when option {opt nosvyadjust} was not specified.
    This has been fixed.

{p 9 9 2}
    {cmd:contrast} with option {cmd:post} will continue to post the
    unadjusted values to {cmd:e(F)} and {cmd:e(p)}; they are used to recompute
    the reported survey-adjusted values on replay.

{p 5 9 2}
3.  {helpb correlate} with time-series operators and option {opt means}
    failed to report all the variable names correctly in the means table.
    This has been fixed.

{p 5 9 2}
4.  {helpb gsem} with time-series operators on variables interacted with
    multilevel latent variables (random covariates) would cause error
    "{err:not sorted}".  This has been fixed.

{p 5 9 2}
5.  {helpb gsem} and all {helpb me} commands have the following fixes:

{p 9 13 2}
    a.  {cmd:gsem} and {helpb meglm} with options {opt dnumerical} and
        {cmd:vce(robust)} or {cmd:vce(cluster ...)} reported a Mata
        conformability trace error when any kind of constraint was specified
        or implied.  This has been fixed.

{p 9 13 2}
    b.  {cmd:gsem} and {cmd:meglm} will now attempt to fit the specified model
        even if the fixed-only model fails to converge.

{p 9 13 2}
    c.  {helpb gsem} and all {helpb me} commands with option
        {cmd:intmethod(mvaghermite)} fitting multilevel models with one or
        more groups that yield a large negative log likelihood ignored missing
        values when computing and using the adaptive parameters, yielding an
        incorrectly fit model.  This has been fixed.

{p 5 9 2}
6.  {helpb hausman} has the following fixes:

{p 9 13 2}
    a.  {cmd:hausman} has improved factor-variables support in its table.

{p 9 13 2}
    b.  {cmd:hausman} with option {opt equations()} and interactions
        present in the specified equations exited with error
        "{err:operator invalid}".  This has been fixed.

{p 5 9 2}
7.  {helpb import delimited} would exit with an error if the file to be
    imported contained two variables with the same name.  Now
    {cmd:import delimited} will import the data, renaming any duplicate
    variables to {cmd:v}{it:#}, where {it:#} represents the column's position.

{p 5 9 2}
8.  {helpb import excel} used an excessively large amount of temporary memory
    to import string variables.  This has been fixed.

{p 5 9 2}
9.  {helpb margins}, {helpb contrast}, and {helpb pwcompare}, after
    {helpb gsem} with some but not all ordinal depvars, incorrectly flagged
    some margins, contrasts, and pairwise comparisons as "(not estimable)".
    This has been fixed.

{p 4 9 2}
10.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} now has better error messages when a name specified in
         {it:marginslist} does not appear among the list of covariates in the
         current estimation results.

{p 9 13 2}
     b.  {cmd:margins} with {helpb gsem} results was mistakenly treating
         multilevel latent variables as intercepts, which caused it to always
         fail the estimable functions test.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins} with option {opt over()} and expression {opt generate()}
         in option {opt at()} would cause a syntax error.  This has
         been fixed.

{p 9 13 2}
     d.  {cmd:margins} was not recognizing a named equation as part of option
         {cmd:equation()} within a {cmd:predict()} or
         {cmd:expression()} specification.  When this caused a problem, it
         reported "(not estimable)" for margins that actually were estimable.
         User-written estimation commands that set {cmd:e(marginsprop)} to
         contain {cmd:addcons} and allow an equation name to be specified in
         option {cmd:equation()} of {helpb predict} were the only commands
         affected by this.

{p 4 9 2}
11.  {helpb matrix list} and {helpb matlist} misaligned row and column
     headings that ended in {cmd:#}, {cmd:*}, {cmd:@}, or {cmd:|} but were not
     part of a multiple-line factor-variables interaction specification.  This
     has been fixed.

{p 4 9 2}
12.  {helpb mi impute mvn}, when the check for collinear independent variables
     failed, produced an error with a Mata traceback log.  It now produces an
     appropriate error message.

{p 4 9 2}
13.  {helpb ml} has the following fixes:

{p 9 13 2}
     a.  {cmd:ml} with option {opt subpop()} reported an incorrect sample size
         when some of the variables contained missing values outside the
         subpopulation sample.  It was also possible for an entire sampling
         unit to be dropped because of these missing values, yielding
         subpopulation variance estimates based on an incorrect sample size.
         This has been fixed.

{p 9 13 2}
     b.  Estimation commands using {cmd:ml} to fit models with empty cells in
         interaction terms when {helpb set emptycells} {cmd:drop} was in effect
         exited with a Mata conformability error.  This has been fixed.

{p 9 13 2}
     c.  {cmd:ml} subroutines {helpb mlvecsum}, {helpb mlmatsum}, and
         {helpb mlmatbysum} were not working properly when
         {helpb set emptycells} {cmd:drop} was in effect; they failed to
         ignore empty cells in interaction terms.  This has been fixed.

{p 4 9 2}
14.  {helpb nestreg} with prefix {helpb svy} and {cmd:svy} options exited
     with a syntax error when the prefixed estimation command contained
     parenthesis-bound variables.  This has been fixed.

{p 4 9 2}
15.  {helpb odbc load} crashed when using the Postgres Unicode ODBC driver to
     load strings longer than 280.  This has been fixed.

{p 4 9 2}
16.  {helpb gsem_predict:predict} after {helpb gsem} with structural paths
     between Gaussian depvars used an inverse projection of the structural
     coefficients instead of a direct linear combination to compute the linear
     predictions.

{p 9 9 2}
     For the example model

		Y = B * Y + G * X + e

{p 9 9 2}
     where Y is the matrix of depvars, X is the matrix of
     (exogenous) indepvars, e is the matrix of endogenous errors, B
     is the matrix of structural coefficients, and G is the matrix of
     exogenous coefficients, {cmd:predict} computed linear predictions as

		Yhat = (I - Bhat)^-1 * Ghat * X

{p 9 9 2}
     when it should have been using

		Yhat = Bhat * Y + Ghat * X

{p 9 9 2}
     This has been fixed.

{p 4 9 2}
17.  {helpb qreg}, in rare situations, could cause Stata to crash.  This has
     been fixed.

{p 4 9 2}
18.  {helpb sem} and {helpb gsem} now respect an unconstrained constant path
     in all cases when option {opt noconstant} is specified.  For example,

		{cmd:sem} {cmd:(mpg <- _cons)} {cmd:(mpg <- turn)} {cmd:,} {cmd:noconstant}

{p 9 9 2}
     would fit with a zero-constrained constant, while

		{cmd:sem} {cmd:(mpg <- turn)} {cmd:(mpg <- _cons)} {cmd:,} {cmd:noconstant}

{p 9 9 2}
     would fit with an unconstrained constant.  Now both specifications will
     fit with an unconstrained constant.

{p 4 9 2}
19.  The {help sem_builder:SEM Builder} now adds an object at the default size
     if the user mistakenly adds an object of 0 width or height.

{p 4 9 2}
20.  {helpb set cformat}, {cmd:set pformat}, and {cmd:set sformat} commands
     have the following fixes:

{p 9 13 2}
     a.  They now report an error when the specified format width is too
         large.  The maximum format width for {cmd:cformat} is 9.  The maximum
         format width for {cmd:pformat} is 5.  The maximum format width for
         {cmd:sformat} is 8.

{p 9 13 2}
     b.  They reported error "{err:invalid numeric format}" on an empty
         format specification when option {opt permanently} was specified
         with a space before the comma.  This has been fixed.

{p 4 9 2}
21.  {helpb set obs}, when a variable was sorted and when the last value of
     that variable contained an {help missing:extended missing value}, did not
     mark that variable as no longer being sorted.  This has been fixed.

{p 4 9 2}
22.  {helpb simulate} with a user-written command that has an option minimally
     abbreviated as {opt l(arg)} parsed this option as if it were option
     {opt level(#)}, causing a syntax error when {it:arg} was not a
     value in the limited range allowed by {opt level(#)}.
     {cmd:simulate} no longer parses {opt level(#)}.

{p 4 9 2}
23.  {helpb svy} was not always preserving the {cmd:r()} results normally
     posted by {helpb ereturn display}.  This has been fixed.

{p 4 9 2}
24.  {helpb svy_tabulate_twoway:svy: tabulate twoway} with option {opt wald}
     and using bootstrap variance estimation reported an unhelpful error.
     This has been fixed so that {cmd:svy:} {cmd:tabulate} {cmd:twoway}
     reports the unadjusted Wald test using a chi-squared statistic instead of
     the usual F statistic.

{p 4 9 2}
25.  {helpb testparm} ignored the level restrictions on factor variables in
     interactions when at least one factor variable was specified without a
     level restriction.  The result was a test that included more level
     combinations of the interaction than was specified.  This has been fixed.

{p 4 9 2}
26.  (Mac) The Do-file Editor has the following fixes:

{p 9 13 2}
     a.  Scrolling when using a scroll wheel from a third-party mouse would be
         very slow.  This has been fixed.

{p 9 13 2}
     b.  Using Find on a long document when running on Mac OS X 10.6 could
         cause severe performance problems.  This has been fixed.

{p 9 13 2}
     c.  Menu {bf:File > Do...} would open the selected do-file in
	 the Do-file Editor instead of executing it.  It now executes the
	 selected do-file.

{p 4 9 2}
27.  (Mac) The Project Manager did not restore a project's expanded or
     collapsed state after the project was opened.  This has been fixed.

{p 4 9 2}
28.  (Mac) Commands are now added to the Review window before they finish
     executing.

{p 4 9 2}
29.  (Windows) Double-clicking on a *.smcl file in the Project Manager now
     opens the file in the Viewer.

{p 4 9 2}
30.  (Unix Console and Mac Console) Pressing Ctrl+C could cause Stata to
     terminate.  The problem would occur only after the Java Runtime
     Environment was loaded by Stata.  This has been fixed.


{hline 8} {hi:update 19sep2013} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 13(3).

{p 5 9 2}
2.  New postestimation command {helpb estat wcorrelation} after {helpb mixed}
    computes and displays the within-cluster correlation matrix for a given
    cluster calculated on the basis of the design of the random effects and
    their assumed covariance and the correlation structure of the residuals.
    This allows for a comparison of different multilevel models in terms of
    the ultimate within-cluster correlation matrix that each model implies.

{p 5 9 2}
3.  The {helpb icd9} databases have been updated to use the latest version
    (V31) of the ICD-9 codes.

{p 5 9 2}
4.  {helpb mgarch_ccc_postestimation##predict:predict} after
    {helpb mgarch ccc}, {helpb mgarch dcc}, and {helpb mgarch vcc} has new
    option {cmd:correlation} for producing conditional correlations.


{hline 8} {hi:update 12aug2013} {hline}

{p 5 9 2}
1.  Filename completion is now available in the Command window by pressing the
    Tab key.  The filename must be preceded by a double-quote ({cmd:"})
    character.  Otherwise, Stata will assume you wish to do variable name
    completion.

{p 5 9 2}
2.  {helpb forecast identity} has new option {cmd:generate} to generate the
    left-hand-side variable on the fly, which is useful when fitting equations
    that include transformations of endogenous variables as covariates.

{p 5 9 2}
3.  {helpb gsem_command:gsem} has new option {opt dnumerical} to compute the
    gradient and Hessian using numerical techniques instead of analytical
    formulas.  This option may be helpful when using multilevel latent
    variables with large groups and when {cmd:gsem} reports "starting values
    not feasible" for a variety of user-specified starting values.

{p 5 9 2}
4.  {helpb stem} has new option {opt truncate(#)}, which truncates data to
    the specified value.

{p 5 9 2}
5.  Prefix {helpb by}, when used with {helpb summarize} with an {helpb if}
    expression containing a string variable, could cause Stata to crash.  This
    has been fixed.

{p 5 9 2}
6.  {helpb estat esize} mislabeled interaction terms in the reported effects
    sizes table by attaching the operator {opt c.} to all variables in the
    interaction term.  This has been fixed.

{p 5 9 2}
7.  {helpb export delimited} issued an error when trying to save a filename
    with embedded spaces.  This has been fixed.

{p 5 9 2}
8.  {helpb gmm}, when option {opt xtinstruments()} was specified and the user
    requested a cluster-robust weight matrix or VCE, ignored the cluster
    variable and instead clustered based on the panel variable.  This has been
    fixed.

{p 5 9 2}
9.  {helpb heckman}, with user-specified constraints, produced a
    likelihood-ratio test for independent equations that was incorrect.  Now a
    Wald test is reported when a user specifies constraints.

{p 4 9 2}
10.  {helpb import delimited} could fail to import a row correctly if the file
     to be imported had both a line ending with a delimiter and the next
     line starting with a delimiter and if option
     {helpb import_delimited##import_options:delimiters()} was specified with
     suboption {helpb import_delimited##import_options:collapse}.  This
     has been fixed.

{p 4 9 2}
11.  {helpb margins} after {helpb gsem_command:gsem} or {helpb meglm} with
     {cmd:family(gamma)} would report the error
     "{err:prediction is a function of possibly stochastic quantities}
     {err:other than e(b)}" even when there were no latent variables in the
     model specification.  This has been fixed.

{p 4 9 2}
12.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem} was not
     computing out-of-sample mean predictions (for option {opt mu} or
     {opt pr}) when it should.  This has been fixed.

{p 4 9 2}
13.  {helpb meglm_postestimation##predict:predict} after {helpb meglm} was not
     computing out-of-sample mean predictions (for option {opt mu} or
     {opt pr}) when it should.  This has been fixed.

{p 4 9 2}
14.  {helpb symmetry} with an empty {helpb if} condition returned the
     error "{err:tempvar not found}".  This has been fixed.

{p 4 9 2}
15.  {helpb tabulate_summarize:tabulate}, when used with a
     {helpb strings:strL} variable and options {cmd:summarize()} and
     {cmd:missing}, could crash Stata.  This has been fixed.

{p 4 9 2}
16.  {helpb var} with options {cmd:small} and {cmd:constraints()} would
     display missing values for the F statistic in the header.  This has been
     fixed.

{p 4 9 2}
17.  (Mac) Executing commands in Stata from an AppleScript script that creates
     multiple graphs could cause Stata to crash.  This has been fixed.

{p 4 9 2}
18.  (Windows) The {help set linesize:linesize} setting was not set when the
     font was changed in the Results window.  This has been fixed.

{p 4 9 2}
19.  (Unix) On systems using European number formats, Stata commands could
     fail when reading values with decimals.  The problem would occur only
     after the Java Runtime Environment was loaded by Stata.  This has been
     fixed.


{hline 8} {hi:update 23jul2013} {hline}

{p 5 9 2}
1.  {helpb ivregress} produced an error when you specified interactions of
    factors with a large number of categories.  This has been fixed.

{p 5 9 2}
2.  {helpb gmm} now allows equation names within option {opt parameters()}
    and labels the parameter vector passed to moment-evaluator programs
    appropriately.  That allows you to use {helpb matrix score} in evaluator
    programs to compute linear combinations of variables quickly.  New option
    {opt haslfderivatives} allows you to code derivatives with respect to
    those linear combinations, simplifying the use of {cmd:gmm} when
    implementing other commands.

{p 9 9 2}
    In addition, {cmd:gmm} has a new option, {opt quickderivatives}, that
    provides an alternative method of computing the numerical derivatives
    required in the VCE computations when analytic derivatives are not
    provided.  This method is slightly less accurate than the default method
    but is substantially faster with problems that contain many instruments or
    residual equations.

{p 5 9 2}
3.  {helpb import excel} gave a "{err:file too big}" error for {cmd:.xls}
    files over 40 MB.  The restriction was intended for {cmd:.xlsx} files
    only.  This limit has been removed for {cmd:.xls} files.

{p 5 9 2}
4.  {helpb import excel} was slower in Stata 13 compared with Stata 12.  The
    performance in Stata 13 has been improved to be comparable with Stata 12.

{p 5 9 2}
5.  {helpb reshape}, when the variable specified in option {opt j(varname)}
    contained missing values, might give the wrong error message.  This has
    been fixed.

{p 5 9 2}
6.  The parameter domains for {helpb rnbinomial()}, the negative binomial
    random-number generator, have changed to allow a greater range of
    parameter combinations.

{p 5 9 2}
7.  {helpb sem} with a dataset that has one or more variables with capitalized
    names was reporting the error
    "{err:latent variable '...' not referenced in the model}" even when
    option {opt latent()} was not used.  This has been fixed.

{p 5 9 2}
8.  (Mac) The notification sound Stata plays when Stata is finished executing
    a command in the background would not play in Mac OS X 10.7 and 10.8.
    This has been fixed.

{p 5 9 2}
9.  (Mac) The main Stata window now has a minimum content height of 320 pixels
    so that it can be resized to a much shorter height than before.


{hline 8} {hi:update 02jul2013} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 13(2).

{p 5 9 2}
2.  {help dta:{bf:.dta} files} did not fill in the file position in the "map"
    for variable labels; this has been fixed.  This did not affect Stata's
    ability to read and write {cmd:.dta} files.

{p 5 9 2}
3.  {helpb merge} in Stata/SE and Stata/MP would produce an error if the using
    dataset contained more than 5,000 variables.  This has been fixed.

{p 5 9 2}
4.  Function {helpb subinword()}, when the string to be substituted with
    was a single letter and matched both a word at the end of the string to be
    substituted for and the first letter of the string to be substituted for,
    returned an empty string rather than performing the proper substitution.
    This has been fixed.

{p 5 9 2}
5.  {helpb tabulate_oneway:tabulate, sort} with a string variable did not
    always list the categories in descending order of frequency.  This was
    fixed 21jun2013 for Mac and Windows and has been fixed in this update for
    all others.

{p 5 9 2}
6.  (Mac) After updating Stata, attempting to open the Do-file Editor would
    hang Stata for Mac.  This has been fixed.

{p 5 9 2}
7.  (Mac) Executing a selection from a do-file in the Do-file Editor could
    cause Stata to write out incomplete lines to be executed or even crash
    Stata if the do-file contained extended ASCII characters.  This has been
    fixed.

{p 5 9 2}
8.  (Mac) In the Do-file Editor, {hi:Replace & Find} would replace the search
    expression from the beginning of the do-file instead of from the current
    selection.  This has been fixed.

{p 5 9 2}
9.  (Mac) Displaying the current working directory in the status bar is now
    much faster.


{hline 8} {hi:update 21jun2013} {hline}

{p 5 9 2}
1.  (Mac) When using the Graph Editor on Mac OS X 10.7 or newer,
    right-clicking on an object would bring up two different contextual menus.
    This has been fixed.

{p 5 9 2}
2.  (Windows) If a {help project_manager:new project} was created through the
    Do-file Editor or a new file was added to an open project, open Viewer
    windows became unresponsive.  This has been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew12to13}.{p_end}

{hline}
