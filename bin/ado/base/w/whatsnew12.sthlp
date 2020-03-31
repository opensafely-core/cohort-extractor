{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 12}

{pstd}
This file records the additions and fixes made to Stata during the 12.0 and
12.1 releases:

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
    {c |} {bf:this file}        Stata 12.0 and 12.1          2011 to 2013    {c |}
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
See {help whatsnew12to13}.


{hline 8} {hi:update 23jan2014} {hline}

{p 5 9 2}
1.  The 25nov2013 update introduced a bug where you could not add an object of
    default size to the SEM Builder by simply clicking where you wanted
    the object placed in the SEM Builder.  You had to click and drag to add
    and set the size of the object.  This has been fixed.


{hline 8} {hi:update 18dec2013} {hline}

{p 5 9 2}
1.  {helpb ivregress}, when specified with interactions involving factor
    variables with large numbers of categories, produced an error message.
    This has been fixed.

{p 5 9 2}
2.  {helpb nlcom} and {helpb lincom}, when estimating an expression involving
    a comma (like {cmd:_b[/cov(e.x,e.y)]}), produced an error message.  This
    has been fixed.


{hline 8} {hi:update 25nov2013} {hline}

{p 5 9 2}
1.  {helpb asmprobit} failed to display the coefficient table when there were
    no case variables and no constant terms in the model.  This has been
    fixed.

{p 5 9 2}
2.  {help Business calendars} use {cmd:dateformat} to specify how dates are
    typed in
    {help datetime_business_calendars_creation:business calendar files}.  The
    options for {cmd:dateformat} are {cmd:ymd}, {cmd:ydm}, {cmd:myd},
    {cmd:mdy}, {cmd:dym}, and {cmd:dmy}.  Not all of these options worked, for
    example, in function {helpb bofd()} or command {helpb bcal:bcal describe}.
    This has been fixed.

{p 5 9 2}
3.  {helpb cluster} with subcommands {cmd:averagelinkage},
    {cmd:completelinkage}, {cmd:waveragelinkage}, {cmd:medianlinkage},
    {cmd:centroidlinkage}, or {cmd:wardslinkage} and with a large number of
    observations (such as 400,000) could crash Stata instead of issuing an
    error message.  This has been fixed.

{p 5 9 2}
4.  Function {helpb dunnettprob()} would return a missing value if the {it:df}
    argument was not an integer value.  {cmd:dunnettprob()} now behaves like
    {helpb invdunnettprob()} and allows the {it:df} argument to be any real
    value in its documented domain.

{p 5 9 2}
5.  {helpb expoisson}, when using a {it:depvar} with a large number of counts
    (total exceeding 125) and an exposure variable, could give wrong results.
    This has been fixed.

{p 5 9 2}
6.  {helpb export excel} did not export a variable formatted as {cmd:%d} as a
    date.  This has been fixed.

{p 5 9 2}
7.  {helpb fcast compute} has the following fixes:

{p 9 13 2}
    a.  {cmd:fcast compute} after {helpb vec} failed to clear a global macro
        that it uses during execution and would therefore accumulate a long
        string in this macro when called repeatedly.  When the resulting
        string exceeded the maximum allowed length, the command would produce
        error "{err:macro substitution results in line that is too long}".
        This has been fixed.

{p 9 13 2}
    b.  {cmd:fcast compute} after {cmd:vec} dropped all variables created by
        previous calls to {cmd:fcast compute} if the current call resulted in
        an error.  This has been fixed.

{p 5 9 2}
8.  {helpb gmm}, when option {opt xtinstruments()} was specified and the user
    requested a cluster-robust weight matrix or VCE, ignored the cluster
    variable and instead clustered based on the panel variable.  This has been
    fixed.

{p 5 9 2}
9.  The {helpb icd9} databases have been updated to use the latest version
    (V31) of the ICD-9 codes.

{p 4 9 2}
10.  For {cmd:.xls} files, {helpb import excel} might omit rows or columns at
     the end of the sheet because of the recorded number of rows or columns in
     the {cmd:.xls} file not matching the number of actual rows or columns.
     This has been fixed.

{p 4 9 2}
11.  {helpb ivregress} has the following fixes:

{p 9 13 2}
     a.  {cmd:ivregress 2sls} is now more tolerant of highly collinear
         regressors.

{p 9 13 2}
     b.  {cmd:ivregress} with option {cmd:first} would report an error when
         factor variables were included in the exogenous variable list that
         were highly correlated with the instruments.  This has been fixed.

{p 9 13 2}
     c.  {cmd:ivregress} would report a syntax error when a very long {cmd:if}
         expression was used.  This has been fixed.

{p 9 13 2}
     d.  Option {cmd:noconstant} was not correctly passed through the
         collinearity check of the instruments.  This has been fixed.

{p 4 9 2}
12.  Mata function {helpb mf_st_addvar:st_addvar()} with more than one
     variable type specified and with the number of variable types fewer than
     the number of variable names could crash Stata.  This has been fixed.

{p 4 9 2}
13.  Mata function {helpb mf_asarray_keys:asarray_keys()} generated a 3201
     error when there were collisions of the hashes.  This has been fixed.

{p 4 9 2}
14.  Mata function {helpb mf_st_view:st_view()} is now much faster at creating
     views when the variable specification does not contain time-series or
     factor-variable operators.

{p 4 9 2}
15.  {helpb matrix accum} would incorrectly compute the cross-product sum
     between a continuous variable and a factor variable when interactions
     involving continuous variables were also specified.  This has been fixed.

{p 4 9 2}
16.  {helpb mi} has the following fixes:

{p 9 13 2}
     a.  {helpb mi estimate} produced an error if the length of the specified
         command line exceeded 244 characters.  This has been fixed.

{p 9 13 2}
     b.  {cmd:mi estimate}, when used with {cmd:mean}, {cmd:proportion},
         {cmd:ratio}, or {cmd:total}, could produce missing
         multiple-imputation standard errors when some of the
         imputation-specific standard errors were legitimate zeros.  For
         example, the {cmd:mean} command reports a standard error of zero for
         a constant variable.  {cmd:mi estimate} now reports the estimates
         instead of missing values.

{p 9 13 2}
     c.  {cmd:mi estimate} used with {cmd:mean}, {cmd:proportion},
         {cmd:ratio}, or {cmd:total} now produces missing multiple-imputation
         standard errors for any parameter that was estimated based on a
         sample of only one observation in any of the imputations, that is,
         for any parameter for which the corresponding element of the
         {cmd:e(_N)} matrix is one in any of the imputations.

{p 9 13 2}
     d.  {helpb mi impute chained} would mistakenly produce error
         "{err:missing imputed values are produced}" when option
         {cmd:noimputed} was specified and option {cmd:include()} contained a
         categorical or binary imputation variable with a factor specification
         other than {cmd:i.}.  This has been fixed.

{p 9 13 2}
     e.  During conditional imputation, {helpb mi impute chained} and
         {helpb mi impute monotone} failed to check the order in which the
         conditional and conditioning variables were imputed when the
         conditional variable contained the same number of missing
         observations as one of the conditioning variables.  The commands now
         produce an error if a conditional variable is listed before its
         conditioning variables in the specification of an imputation model.

{p 9 13 2}
     f.  {helpb mi impute mvn}, when the check for collinear independent
         variables failed, produced an error with a Mata traceback log.  It
         now produces an appropriate error message.

{p 4 9 2}
17.  {helpb ml} with option {opt subpop()} reported an incorrect sample size
     when some of the variables contained missing values outside the
     subpopulation sample.  It was also possible for an entire sampling unit
     to be dropped because of these missing values, yielding subpopulation
     variance estimates based on an incorrect sample size.  This has been
     fixed.

{p 4 9 2}
18.  {helpb nestreg} with prefix {helpb svy} and {cmd:svy} options exited
     with a syntax error when the prefixed estimation command contained
     parentheses-bound variables.  This has been fixed.

{p 4 9 2}
19.  {helpb nlogit} could drop too many alternative-specific variables if one
     alternative-specific variable was collinear with a variable specified in
     the last (leaf) alternative {help nlogit##byaltvarlist:varlist} after it
     was interacted with indicators of the alternatives.  This has been fixed.

{p 4 9 2}
20.  The dialog box for {helpb arfima postestimation:predict} after
     {helpb arfima} did not produce a command when you pressed the {hi:Submit}
     button.  This has been fixed.

{p 4 9 2}
21.  In rare situations, {helpb qreg} might cause Stata to crash.  This has
     been fixed.

{p 4 9 2}
22.  The parameter domains for {helpb rnbinomial()}, the negative binomial
     random-number generator, have changed to allow a greater range of
     parameter combinations.

{p 4 9 2}
23.  Performing a search in Stata's help system while Stata was busy executing
     a command could cause the command to fail with an error or even cause
     Stata to crash.  Stata no longer allows a search in Stata's help system
     while Stata is busy executing a command.

{p 4 9 2}
24.  {helpb set cformat}, {cmd:set pformat}, and {cmd:set sformat} have the
     following fixes:

{p 9 13 2}
     a.  They now report an error when the specified format width is too
         large.  The maximum format width for {cmd:cformat} is 9.  The maximum
         format width for {cmd:pformat} is 5.  The maximum format width for
         {cmd:sformat} is 8.

{p 9 13 2}
     b.  They reported error "{err:invalid numeric format}" on an empty format
         specification when option {opt permanently} was specified with a
         space before the comma.  This has been fixed.

{p 4 9 2}
25.  {helpb set obs}, when a variable was sorted and when the last value of
     that variable contained an {help missing:extended missing value}, did not
     mark that variable as no longer being sorted.  This has been fixed.

{p 4 9 2}
26.  When the jackknife method was used, {helpb stptime:stptime} and
     {helpb strate:strate} could report jackknife confidence intervals that
     did not include the estimated rate for survival datasets that contained
     no failures, only one failure, or only one cluster with failures.  They
     now report missing confidence intervals and a note with an explanation in
     these situations.

{p 4 9 2}
27.  {helpb ivregress} with prefix {helpb svy} has the following fixes:

{p 9 13 2}
     a.  Interactions in the exogenous variable list caused an error.  This
         has been fixed.

{p 9 13 2}
     b.  When {cmd:svy: ivregress} was used with option {cmd:first}, factor
         variables in the exogenous variable list caused an error.  This has
         been fixed.

{p 4 9 2}
28.  {helpb svy tabulate}, when used with a string variable, reported a
     temporary variable name in the output instead of the specified variable.
     This has been fixed.

{p 4 9 2}
29.  {helpb symmetry} with an empty {cmd:if} condition returned a tempvar not
     found error.  This has been fixed.

{p 4 9 2}
30.  Function {helpb tukeyprob()} would return a missing value if argument
     {it:df} was not an integer value.  {cmd:tukeyprob()} now behaves like
     {helpb invtukeyprob()} and allows {it:df} to be any real value in its
     documented domain.

{p 4 9 2}
31.  {helpb var} with option {cmd:small} and constraints would display missing
     values for the F statistic in the header.  This has been fixed.

{p 4 9 2}
32.  {helpb xtmixed} with collinear variables in a random-effects equation
     would exit with an error and a Mata trace log.  This has been fixed.

{p 4 9 2}
33.  Estimation commands that allow factor-variable notation would sometimes
     spuriously omit a continuous variable because of collinearity when
     interactions involving continuous variables were also specified.  This
     has been fixed.

{p 4 9 2}
34.  When executing an ado-file that was defined with more than 3,500 lines,
     Stata could crash.  Now Stata correctly issues the error message
     "{err:system limit exceeded}".

{p 4 9 2}
35.  Stata would appear to lock up while executing a do-file when there was an
     I/O error while reading the do-file (that is, the do-file was erased
     while Stata was executing it).  Stata now stops and displays an error
     message when there is an I/O error while executing a do-file.

{p 4 9 2}
36.  The Data Editor has the following fixes:

{p 9 13 2}
     a.  Long value labels could overflow the width of a column, causing them
         to display in adjacent columns.  This has been fixed.

{p 9 13 2}
     b.  Pasting data into the Data Editor did not update the internal list of
         sorted variables.  Now if you paste data into one of the variables on
         which the data were sorted, the list is updated.

{p 4 9 2}
37.  The {help sem_gui:SEM Builder} no longer allows you to add an object that
     is of 0 width or height.

{p 4 9 2}
38.  Syntax highlighting for the global macro in the Do-file Editor passed
     beyond the white-space character.  This has been fixed.

{p 4 9 2}
39.  (Stata/MP) {helpb matrix score}, when used with an {cmd:if} expression
     that could not be run in parallel (for example, {cmd:if runiform()>0.5}),
     might produce incorrect results.  This has been fixed.

{p 4 9 2}
40.  (Windows) {helpb file seek} always failed with files larger than
     2 gigabytes.  This has been fixed.

{p 4 9 2}
41.  (Windows) {helpb graph export} would fail with error {search r(603)} when
     used with a UNC path.  This has been fixed.

{p 4 9 2}
42.  (Windows) {helpb set httpproxyport} would accept ports between 1 and
     32,000, but a setting with ports above 9,999 would not be reloaded in
     subsequent Stata sessions.  This has been fixed.

{p 4 9 2}
43.  (Windows) The Do-file Editor Preferences dialog set the wrong default
     font size when button {bf:Restore Factory Defaults} was pressed from
     the {bf:Editor Font} tab.  This has been fixed.

{p 4 9 2}
44.  (Windows) {helpb update} failed to install from a local directory when
     Stata was run from a network share.  This has been fixed.

{p 4 9 2}
45.  (Mac) The Do-file Editor now uses a different method for saving temporary
     files to disk before running them.  The previous method prevented data
     loss in case of a crash if a file was being overwritten.  However, this
     method was unnecessary for temporary files and could make a temporary
     file unavailable when Stata was ready to run it.

{p 4 9 2}
46.  (Mac) {helpb import excel} and {cmd:export excel} did not convert strings
     from Unicode when importing and to Unicode when exporting.  This has been
     fixed.

{p 4 9 2}
47.  (Mac) {helpb odbc load} failed to load variables of type SQL_WCHAR,
     SQL_WVARCHAR, and SQL_WLONGVARCHAR on Macs.  This has been fixed.

{p 4 9 2}
48.  (Mac) Saved preference {cmd:max_memory} would not be read correctly if
     the setting was large.  This has been fixed.

{p 4 9 2}
49.  (Mac) Mac OS X 10.8.2 introduced a bug that could cause Adobe Reader to
     not receive messages from Stata to open the Stata PDF Documentation.
     This could happen if the user quit Adobe Reader and later clicked on the
     Stata PDF Documentation link from within Stata.  Stata now has a
     work-around for this bug.

{p 4 9 2}
50.  (Mac) Point marker symbols in graphs that are exported to PDF did not
     appear because the marker symbols were too small.  This has been fixed.
     The marker symbol is now rendered as a circle rather than a square.

{p 4 9 2}
51.  (Mac) Graphs could not be exported to EPS or PS while being edited in the
     Graph Editor.  This has been fixed.

{p 4 9 2}
52.  (Mac) Stata could crash if multiple graphs were drawn while the Do-file
     Editor was in full-screen mode.  This has been fixed.

{p 4 9 2}
53.  (Mac) The Retina version of the SEM Builder's tools icons was not being
     used by Mac OS X.  This has been fixed.

{p 4 9 2}
54.  (Mac) Stata displays a warning when the Data Editor is changed from
     browse mode to edit mode.  If data changed and you typed {helpb edit} in
     the Command window while in browse mode, Stata would display a warning
     dialog and immediately dismiss it.  This has been fixed, and the warning
     dialog is no longer immediately dismissed.

{p 4 9 2}
55.  (Mac) Selecting {bf:Edit > Undo} after editing text in the Data Editor
     and applying the change would cause Stata to crash.  This has been fixed.

{p 4 9 2}
56.  (Mac) Using {helpb translate} to convert a SMCL file to a PDF file would
     not produce a PDF file if the PDF filename contained spaces.  This has
     been fixed.

{p 4 9 2}
57.  (Mac) The notification sound Stata plays when Stata is finished executing
     a command in the background would not play in OS X 10.7 and 10.8.  This
     has been fixed.

{p 4 9 2}
58.  (Mac) OS X 10.9 (Mavericks) introduced a change that caused Stata to
     always start in the root directory "/" instead of the working directory
     from Stata's previous session.  This would only affect Stata if it was
     launched by double-clicking on it in the Finder, not by double-clicking
     on a do-file or dataset from the Finder.  This has been fixed.

{p 4 9 2}
59.  (Unix) Stata for Unix GUI crashed when you selected the menu item
     {bf:Edit > Preferences > Manage Preferences > Factor Settings} with a
     Viewer open.  This has been fixed.


{hline 8} {hi:update 09jul2013} {hline}

{p 5 9 2}
1.  {helpb histogram} incorrectly reported the syntax error
    "{err:parentheses do not balance}" when a suboption of {opt by()} was
    specified with quoted spaces.  This has been fixed.

{p 5 9 2}
2.  {helpb intreg} without option {opt het()} left behind an invalid
    {cmd:e(V_modelbased)} when {cmd:vce(robust)} or
    {cmd:vce(cluster} {it:...}{cmd:)} was specified.  This only affected
    {helpb margins} when option {cmd:vce(unconditional)} was specified.
    This has been fixed.

{p 5 9 2}
3.  {helpb margins} has the following fixes:

{p 9 13 2}
    a.  {helpb margins} with option {cmd:vce(unconditional)} used after
        {helpb xtmixed} would produce a cryptic error about not finding an
        equation.  This has been fixed.

{p 9 13 2}
    b.  {helpb margins} would report the warning "{err:cannot perform check}
	{err:for estimable functions}" with {helpb reg3} results that did not
	contain constraints for factor variables.  This has been fixed.

{p 9 13 2}
    c.  {helpb margins} was not properly handling quoted strings in option
        {opt predict()}, causing an error while reporting results.
        This has been fixed.

{p 5 9 2}
4.  {helpb marginsplot} produced an error message or a plot with missing points
    when {helpb margins} was specified with option {opt at()} that set a
    value out of the range for a given regressor.  This was most common when
    the {opt at()} variable was of type {help byte} and the {opt at()}
    value was greater than 100.  This has been fixed.

{p 5 9 2}
5.  Mata function
    {helpb mf_moptimize##result_display:moptimize_result_display()} with the
    Nelder-Mead technique and constraints would report
    "{error}estimates post: matrix has missing values{reset}" when it should
    have reported the estimates table with missing standard errors.  This has
    been fixed.

{p 5 9 2}
6.  {helpb ml plot} and {helpb ml graph}, when specified to produce as many or
    more plotted points than observations in the dataset, would exit with a
    Mata trace log when these commands should have produced a graph.  This
    has been fixed.

{p 5 9 2}
7.  {helpb pwmean} would interact only the first two variables specified in
    option {opt over()} when it should have been interacting all the
    {opt over()} variables.  This has been fixed.


{hline 8} {hi:update 20mar2013} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 13(1).

{p 5 9 2}
2.  {helpb areg_postestimation##predict:predict, residuals} after {helpb areg}
    for models using time-series operators would fail with the error
    "{err:not sorted}".  This has been fixed.

{p 5 9 2}
3.  In some cases, {helpb proportion} returned a cryptic error message when it
    should have returned "{err:no observations}".  This has been fixed.

{p 5 9 2}
4.  {helpb tsset} with a time variable in business calendar ({cmd:%tb}) format
    reported an incorrect time period (delta).  This has been fixed.


{hline 8} {hi:update 25feb2013} {hline}

{p 5 9 2}
1.  {helpb sem} with {cmd:method(mlmv)} will now attempt to fit the specified
    model even if the saturated model fails to converge.

{p 5 9 2}
2.  {helpb xtile} produced missing quantiles when an {cmd:if} condition was
    used and the resulting number of observations was less than the requested
    number of quantiles.  It now produces an error in this case.


{hline 8} {hi:update 30jan2013} {hline}

{p 5 9 2}
1.  {helpb expandcl:expandcl, cluster() generate()}, when there were many
    clusters before expanding the data, failed to generate unique identifiers
    for the duplicated clusters.  This has been fixed.

{p 5 9 2}
2.  {helpb graph} with option {cmd:yscale(range())} did not properly expand
    the range when the natural range of the data was negative and when the
    maximum value specified in {cmd:range()} was also negative.  This has been
    fixed.

{p 5 9 2}
3.  {helpb gmm} would sometimes exit with an error message stating
    that "{err:panels are not nested within clusters}" when panel-style
    instruments were specified with option {cmd:vce(cluster} {it:id}{cmd:)}
    or {cmd:wmatrix(cluster} {it:id}{cmd:)}, where {it:id} is the panel
    variable previously set via {helpb xtset}.  This has been fixed.

{p 5 9 2}
4.  {helpb ivtobit} would produce incorrect results if an endogenous
    regressor was adorned by time-series operators.  This has been fixed.

{p 5 9 2}
5.  In the {help sembuilder:SEM Builder}, moving text using the position
    control in the text properties dialog failed.  This has been fixed.

{p 5 9 2}
6.  {helpb stcox} and {helpb streg} with option {cmd:shared()} no longer
    allow the presence of delayed entries (left truncation) or gaps
    (interval truncation).  In general, the use of this option for truncated
    survival data will lead to inconsistent results unless the frailty
    distribution is independent of the covariates and the truncation point,
    which is a rather restrictive assumption in practice.  If desired, the
    estimation can be forced in the described case by specifying the
    undocumented option {cmd:forceshared}, although we strongly discourage
    users from doing so.


{hline 8} {hi:update 18dec2012} {hline}

{p 5 9 2}
1.  {helpb infile1:infile} (free format), in the rare case where the
    end-of-file designation was encountered in the middle of an observation,
    would mistakenly drop that entire observation and fill in the remaining
    variables in the previous observation with missing value {cmd:.} or
    {cmd:""}.  This has been fixed.

{p 5 9 2}
2.  {helpb ivprobit}'s maximum likelihood estimator reported the correct
    p-value for the exogeneity Wald test but stored the incorrect value in
    {cmd:e(p_exog)}.  This has been fixed.

{p 5 9 2}
3.  Two updates were made to {helpb margins}:

{p 9 13 2}
    a.  {cmd:margins} no longer allows interaction terms to contain
        continuous variables in the margins list.

{p 9 13 2}
    b.  {cmd:margins} gave the error "{err:not an array}" if there was a Stata
        graph in memory with one of the following names: asbal, base, mstat,
        phat, or p.  This has been fixed.

{p 5 9 2}
4.  {helpb matrix accum} with option {opt deviations} and factor-variable
    notation indicating a subset of the levels of a factor variable interacted
    with at least one continuous variable would produce incorrect values for
    off-diagonal elements of the cross product with other nonfactor terms.
    This has been fixed.

{p 5 9 2}
5.  {helpb ml} using evaluator type {cmd:gf0} with constraints and option
    {cmd:vce(robust)} or {cmd:vce(cluster} {it:...}{cmd:)} would
    report a Mata trace log after converging.  This has been fixed.

{p 5 9 2}
6.  {helpb ml check} would report a Mata trace log when multiple techniques
    were specified using option {opt technique()} of {helpb ml model}.
    {cmd:ml check} now reports an error if anything other than
    {cmd:technique(nr)} is in effect.

{p 5 9 2}
7.  {helpb net} would not show all the Stata packages available from a
    particular location if there were more than 150 entries in the
    table of contents file for that location.  This has been fixed.

{p 5 9 2}
8.  {helpb notes search} failed to find the text that was searched for if no
    dataset-wide (_dta) notes existed.  This has been fixed.

{p 5 9 2}
9.  Several updates were made to the {help sem_gui:SEM Builder}:

{p 9 13 2}
    a.  You can now easily change the confidence level used to compute
        confidence intervals through the new menu item
	{bf:View > Confidence Level}.  Changes made there are reflected in
        the {bf:Confidence level} field on the {bf:Reporting} tab of the SEM
        estimation dialog.  Likewise, changes on the dialog are reflected in
        {bf:View > Confidence Level}.

{p 9 13 2}
    b.  The typeface of results displayed on paths and covariances could not
        be changed and the italic and bold settings were ignored.  This has
        been fixed.

{p 9 13 2}
    c.  The confidence intervals for variances displayed in the Properties
        pane were computed in the variance metric, meaning that the lower bound
        could become negative.  While asymptotically equivalent, these CIs did
        not match those shown on the diagram and in the Results window.  These
        CIs are now computed in the log variance metric and transformed back
        into the variance metric.  They now match the CIs on the diagram and
        in the Results window.

{p 9 13 2}
    d.  Settings made in the {help sem_gui:SEM Builder} are now remembered for
	all future path diagrams, even those drawn in ensuing Stata sessions.
	Setting the label on a variable to "None" in a settings dialog
	correctly removed the label from the current diagram, but the setting
	was not remembered when new diagrams were created in new SEM Builder
	windows.  This has been fixed.

{p 4 9 2}
10.  Several updates were made to {helpb sem}:

{p 9 13 2}
     a.  {cmd:sem} with suboption {opt pattern()} or {opt fixed()} of option
         {opt covstructure()} was using the upper triangle elements of the
         matrix argument instead of the lower triangle elements.  {cmd:sem}
         now uses the lower triangle elements, as was originally intended and
         documented.

{p 9 13 2}
     b.  {cmd:sem} with option {opt standardized} now assumes option
         {opt showginvariant} for models fit with option {opt groups()}.

{p 9 13 2}
     c.  {cmd:sem} reported a cryptic error message when it encountered a
         model where an observed endogenous variable had a path to a latent
         variable but the model did not contain any observed exogenous
         variables.  This has been fixed.

{p 4 9 2}
11.  {helpb xtdpd} and {helpb xtabond}, when options {cmd:twostep} and
     {cmd:vce(robust)} were both specified and when the number of panels was
     small relative to the number of instruments, could result in unstable
     standard-error computations and could lead to standard errors with
     potentially poor coverage.  This was rare but was most likely to occur
     when the number of instruments exceeded the number of panels.  The
     stability of computations has been dramatically improved, and the new
     computations have nominal coverage.

{p 4 9 2}
12.  (Mac) When pasting text into the Data Editor, any text that could not be
     converted to ASCII would result in no text being pasted.  Stata will
     now display a prompt to convert the text using lossy conversion, which
     removes or alters some characters.  For example, accented characters that
     cannot be converted will lose the accent.

{p 4 9 2}
13.  (Unix) If many preferences were cleared, it was possible though highly
     unlikely that some of the cleared settings would still be used in future
     instances of Stata.  This has been fixed.

{p 4 9 2}
14.  Online help and the search index have been brought up to date for
     {help sj:Stata Journal} 12(4).


{hline 8} {hi:update 22oct2012} {hline}

{p 5 9 2}
1.  The path diagrams shown in the examples in
    [SEM] {it:Stata Structural Equation Modeling Reference Manual} can
    now be opened in the {help sem_gui:SEM Builder}.  In the Builder, click on
    the {bf:Help} menu and select {bf:Example Diagrams}.

{p 5 9 2}
2.  {helpb gmm} exited with an error message stating an equation had no
    parameters if a substitutable expression contained only linear
    combinations declared in previous expressions and no individual
    parameters.  This has been fixed.

{p 5 9 2}
3.  The {helpb icd9} databases have been updated to use the latest version
    (V30) of the ICD-9 codes, which became effective on 1 October 2012.

{p 5 9 2}
4.  (Windows) If multiple graphs were tabbed in the same Graph window, Stata
    could enter an endless loop when graph preferences were changed.  This has
    been fixed.

{p 5 9 2}
5.  (Windows) Toolbar items and menus that list open graphs did not show all
    graphs if they were tabbed. This has been fixed.

{p 5 9 2}
6.  (Mac) Importing an Excel file from the Import Excel dialog caused Stata to
    crash if the Excel file contained no worksheets.  This has been fixed.

{p 5 9 2}
7.  (Mac) You will no longer be prompted to check for updates after loading
    a saved preferences set and restarting Stata.

{p 5 9 2}
8.  (Mac) In the previous update, Stata updated its file and application icons
    to the format Apple recommends for support by Macs with a Retina Display.
    However, Macs running Mac OS X 10.5 do not support this new icon format.
    Stata now uses the older icon format.  Stata still uses other graphical
    assets that are compatible with both Macs with a Retina Display and
    Mac OS X 10.5.

{p 5 9 2}
9.  (Mac) If the interface layout was set to Combined and the Variables/Review
    views were hidden, selecting them from the Window menu still kept them
    hidden.  This has been fixed.


{hline 8} {hi:update 01oct2012} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 12(3).

{p 5 9 2}
2.  {helpb graph twoway} style options {cmd:lcolor()} and {cmd:lpattern()}
    could trigger a bug in {helpb _parse factor}, causing Stata to crash.  This
    has been fixed.

{p 5 9 2}
3.  {helpb import excel} gave a "{err:file too big}" error for {bf:.xls} files
    over 40 MB.  The restriction was intended for {bf:.xlsx} files only.  This
    has been fixed.

{p 5 9 2}
4.  {helpb lpoly} would on rare occasions exit with an error message when
    {cmd:fweight}s or {cmd:aweight}s were specified.  This has been fixed.

{p 5 9 2}
5.  {helpb margins} commands with an {opt at()} option that contained repeated
    values for a given variable repeated the margins results.  This was not
    the intended behavior, so now {cmd:margins} keeps only unique values for a
    given variable.

{p 5 9 2}
6.  {helpb marginsplot} failed if the preceding {helpb margins} command had
    an {opt at()} option with repeated values for a given variable.  This has
    been fixed.

{p 5 9 2}
7.  {helpb marginsplot} failed if any of the variables involved in the plot
    had a value label assigned and that value label contained no labels.  This
    has been fixed.

{p 5 9 2}
8.  Mata {helpb mf_moptimize:moptimize()} subroutines
    {cmd:moptimize_util_vecsum()} and {cmd:moptimize_util_matsum()} now skip
    over observations where the score variable is equal to zero.  This change
    was made to facilitate likelihood-evaluator functions that have a method
    for dealing with missing values in {it:indepvars}.

{p 5 9 2}
9.  {helpb matlist} when used with factor-variable notation in the column
    titles would unintentionally show some {help smcl:SMCL} tags in the
    output.  This has been fixed.

{p 4 9 2}
10.  {helpb matrix accum} with the {opt deviations} option and factor-variable
     notation indicating a subset of the levels of a factor variable
     interacted with at least one continuous variable would produce incorrect
     values for off-diagonal elements of the cross product with other terms
     containing factor variables.  This has been fixed.

{p 4 9 2}
11.  {helpb mi impute intreg} and {helpb mi impute truncreg} could sometimes
     produce imputed values outside the implied range when the set of complete
     predictors exhibited some collinearity.  This has been fixed.

{p 4 9 2}
12.  {helpb odbc insert} when inserting data into a dBASE file sometimes
     produced an error message and failed to produce the file.  This has
     been fixed.

{p 4 9 2}
13.  {helpb arch_postestimation##predict:predict} after {helpb arch} and
     {helpb arima} did not calculate dynamic forecasts correctly when the
     option {cmd:dynamic(.)} was specified.  This has been fixed.

{p 4 9 2}
14.  {helpb reg3} and {helpb sureg} with a complex system containing many
     identifying constraints and a relatively small number of observations
     would sometimes report that the estimated covariance matrix was not
     symmetric, yielding missing values for unconstrained model coefficients.
     This has been fixed.

{p 4 9 2}
15.  {helpb _return hold} results named by using {helpb tempname} were not
     being dropped automatically at the program's conclusion.  This has been
     fixed.

{p 4 9 2}
16.  {helpb _return restore} with the {opt hold} option did not copy matrix
     stripes correctly, eventually causing Stata to crash.  This has been
     fixed.

{p 4 9 2}
17.  In the {help sem_gui:SEM Builder}, holding the {bf:Shift} key while
     adding a path or covariance will now constrain them horizontally or
     vertically.

{p 4 9 2}
18.  The {help sem_gui:SEM Builder} now displays standardized estimates when
     "Display standardized coefficients and values" is checked on the
     {bf:Reporting} tab of the Builder's SEM estimation options dialog box.

{p 4 9 2}
19.  {helpb spearman} no longer creates unnecessary temporary variables.

{p 4 9 2}
20.  {helpb tssmooth ma} exited with an error message if the {opt weights()}
     option was specified and the dataset had more than 3,201 observations.
     This has been fixed.

{p 4 9 2}
21.  Stata's variable list parse logic was not distributing time-series
     operators on interaction terms correctly when the time-series operators
     were specified on a parentheses-bound list containing interaction terms.
     This has been fixed.

{p 4 9 2}
22.  (Mac) In the {help sem_gui:SEM Builder}, on the {bf:Group} tab of the
     SEM estimation options dialog box, selecting a parameter from the
     "Parameters that are equal across groups" combobox would insert the
     textual description of the parameter instead of its option name into the
     combobox.  This would result in an error when submitting the command.
     This has been fixed.

{p 4 9 2}
23.  (Mac) On a Mac with a Retina Display, the selected tab of a window that
     did not have the keyboard focus would render the wrong color.  This has
     been fixed.

{p 4 9 2}
24.  (Mac) When using the Import Excel dialog, selecting a filename with
     Unicode characters could cause Stata to crash.  This has been fixed.


{hline 8} {hi:update 08aug2012} {hline}

{p 5 9 2}
1.  {helpb glm} would exit with an error message if one or more levels of a
    factor-variable term was omitted because of collinearity.  This has been
    fixed.

{p 5 9 2}
2.  The dialog box for {helpb import excel} failed to output the correct sheet
    name if the first sheet was empty.  This has been fixed.

{p 5 9 2}
3.  {helpb sem} with summary statistics data ({helpb ssd}) failed to properly
    compute the log likelihood for the saturated model when one of the
    observed variable names was a substring in another observed variable name
    (for example, when some of the variable names were composed of one
    letter).  As a result, {cmd:sem} failed to properly fit the specified
    model and to report the likelihood-ratio test comparing the fitted model
    with the saturated model.  In addition, {helpb sem_estat_gof:estat gof}
    reported a Mata trace log.  This has been fixed.

{p 5 9 2}
4.  (Mac) A change in Mac OS X 10.8 (Mountain Lion) caused Stata to crash when
    automatically relaunched after a Stata update.  Although all ado-files
    and the Stata executable would be successfully updated, the user had to
    manually restart Stata after an update.  This has been fixed.


{hline 8} {hi:update 18jul2012} {hline}

{p 5 9 2}
1.  {helpb alpha} now reports a more informative error message when it cannot
    determine the sense of each item empirically.

{p 5 9 2}
2.  {helpb blogit}, {helpb bprobit}, {helpb glogit}, and {helpb gprobit}, with
    options {cmd:vce(bootstrap)} and {cmd:vce(jackknife)}, treated the
    population total variable, {it:pop_var}, as an independent variable when
    checking for collinearity.  This has been fixed.

{p 5 9 2}
3.  {helpb graph twoway function} passed the wrong version to the function
    {it:f}{cmd:()}.  This rarely mattered but could affect
    {helpb f_invbinomial:invbinomial()}.  This has been fixed.

{p 5 9 2}
4.  If {cmd:position()} was specified in the
    {it:{help title_options}} of
    {cmd:legend()} in {helpb graph twoway}, the same position was wrongly
    applied to the main title of the plot as well.  This has been fixed.

{p 5 9 2}
5.  {helpb import excel} can now open Excel files directly from a URL.

{p 5 9 2}
6.  The {cmd:import excel} dialog box disabled the checkbox "Import first
    row as variable names" if the first row of data contained numeric values.
    This has been fixed.

{p 5 9 2}
7.  {helpb keep:keep _all} would mistakenly {cmd:drop} all variables.  This
    has been fixed.

{p 5 9 2}
8.  (Windows) When you copy an SEM diagram to the Clipboard, the entire
    workspace background is now included.

{p 5 9 2}
9.  (Mac) Line wrapping can now be disabled when printing from the Do-file
    Editor by using the "Wrap lines" checkbox from the {bf:General Preferences}
    dialog and the {bf:Do-file Editor > Advanced} tab.

{p 4 9 2}
10.  (Mac) A bad symbolic link (for example, a symbolic link that points to a
     file that does not exist) can cause Stata's {bf:Open} dialog to hang
     requiring a Force Quit of Stata.  This has been fixed.

{p 4 9 2}
11.  (Mac) Stata for Mac is now code signed as required by Mac OS X 10.8
     (Mountain Lion).

{p 4 9 2}
12.  (Ubuntu Linux) Recent releases of Ubuntu Linux (for example, 12.04) use
     the Linux glibc library version 2.15, which contains a bug in the math
     function logb(x).  This bug affects the commands {helpb exlogistic} and
     {helpb expoisson}.  Stata now uses its own implementation of logb()
     internally and so is no longer affected by the bug in glibc.

{p 4 9 2}
13.  (Unix) The Data Editor deleted multiple characters after the first
     character was deleted if you tabbed into a cell.  This has been fixed.


{hline 8} {hi:update 03jul2012} {hline}

{p 5 9 2}
1.  Stata has been updated to account for the leap second that was added by
    the International Earth Rotation and Reference Systems Service on
    June 30, 2012.  Stata's {help datetime:datetime/C} UTC date format now
    recognizes 30jun2012 23:59:60 as a valid time.


{hline 8} {hi:update 27jun2012} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 12(2).

{p 5 9 2}
2.  {helpb contrast} with weighted contrast operators computed improperly
    weighted effects.  This happened because {helpb svy} failed to post the
    proper weighted frequencies of factor variables.  This has been fixed.

{p 5 9 2}
3.  {helpb margins} failed to compute properly weighted effects when weighted
    contrast operators were specified and the estimation results used weights.
    This has been fixed.

{p 5 9 2}
4.  {helpb sem} commands built by using the {help sem_gui:SEM Builder} with
    option {cmd:method(mlmv)} and data with missing values in the estimation
    sample caused an unintentional error in the following postestimation
    commands:

		{helpb estat ginvariant}
		{helpb estat mindices}
		{helpb sem_estat_residuals:estat residuals}
		{helpb estat scoretests}
		{helpb estat teffects}

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
5.  If the {help sem_gui:SEM Builder} automatically added many covariance
    paths during estimation, it sometimes failed to put the estimation results
    in the path diagram.  This has been fixed.


{hline 8} {hi:update 20jun2012} {hline}

{p 5 9 2}
1.  {helpb datasignature:datasignature set}, {helpb datasignature:confirm},
    and {helpb datasignature:report} reported a file-not-found error (or
    saved a signature file without extension {cmd:.dtasig}) when the
    specified path and filename began with a "{cmd:.}" or "{cmd:..}".  This
    has been fixed.

{p 5 9 2}
2.  {helpb egen}, when the argument to {it:fcn}{cmd:()} was an expression of
    a variable subtracted or multiplied by another variable, mistakenly
    unabbreviated the argument as if it were a variable list.  This has been
    fixed.

{p 5 9 2}
3.  {helpb estat teffects} after {helpb sem} would incorrectly label the
    values for direct, indirect, and total effects and their standard errors
    for some fitted models that contained one or more exogenous variables and
    at least two endogenous variables.  This has been fixed.

{p 5 9 2}
4.  {helpb marginsplot} failed with an error message when Stata's temporary
    directory contained spaces.  This has been fixed.

{p 5 9 2}
5.  Mata function {helpb mf_st_fopen:st_fopen()} reported a file-not-found
    error when the specified path and filename began with a "{cmd:.}" or
    "{cmd:..}".  This has been fixed.

{p 5 9 2}
6.  {helpb arima_postestimation##predict:predict} after {helpb arima} ignored
    option {opt stdp} and produced linear predictions, the default.
    This has been fixed.

{p 5 9 2}
7.  {helpb sem} reported the syntax error "{err:option ... not found}" when a
    display option such as {opt standardized} or {opt level()} was used with a
    single path specification that was not bound in parentheses.  This has
    been fixed.

{p 5 9 2}
8.  {helpb tsappend:tsappend, last() tsfmt()} was slow when there were many
    panels.  This has been fixed.


{hline 8} {hi:update 23may2012} {hline}

{p 5 9 2}
1.  New command {helpb icc} computes intraclass correlation coefficients
    for one-way random-effects models, two-way random-effects models, and
    two-way mixed-effects models for both individual and average measurements.
    Intraclass correlations measuring consistency of agreement or absolute
    agreement of the measurements may be estimated.

{p 5 9 2}
2.  New postestimation command {helpb estat icc} computes intraclass
    correlations at each nested level for nested random-effects models fit by
    {helpb xtmixed} and {helpb xtmelogit}.

{p 5 9 2}
3.  {helpb svy_estat:estat gof} has been disallowed after
    {helpb svy:svy, subpop():} because this test does not specifically address
    subpopulation estimation.

{p 5 9 2}
4.  {helpb import excel} mistakenly imported some Excel formats that
    included brackets as datetime formats.  This has been fixed.

{p 5 9 2}
5.  Adding a Mata function to a Mata library failed with an error if the
    function had an optional argument that was a Mata class matrix, a Mata
    class rowvector, or a Mata class colvector.  This has been fixed.

{p 5 9 2}
6.  {helpb odbc insert} has new option {opt block} used for block inserts.
    {cmd:odbc insert} now allows you to specify qualifiers {cmd:if} and
    {cmd:in}.

{p 5 9 2}
7.  (Mac) Stata for Mac was not using the ISO Latin1 string encoding to output
    text when {cmd:set charset} was set to {cmd:latin1}.  This has been fixed.
    This setting affects all of Stata's text output, including graphs, the
    Data Editor, and the Do-file Editor, not just SMCL output in the Results
    and Viewer windows.

{p 5 9 2}
8.  (Mac) When using the Find Panel to search and replace all text in the
    Do-file Editor, Stata could crash if the file being edited contained
    multiline comments.  This has been fixed.

{p 5 9 2}
9.  (Mac) The Mac OS X 10.7.4 update could cause Stata's help system to crash.
    This has been fixed.

{p 4 9 2}
10.  (Mac) Entering accented characters in the Data Editor could cause Stata
     to crash.  This has been fixed.

{p 4 9 2}
11.  (Windows) In the Variables window, the scrollbar might not show up if the
     scrollbar was moved from the top position and a new dataset was loaded.
     This has been fixed.

{p 4 9 2}
12.  (Unix) Copying data from Excel and pasting the data into the Stata for
     Unix Data Editor would sometimes cause Stata to crash.  This only
     affected users who accessed Stata on a remote machine with an X server
     or who used virtualization software to run both Unix and Windows
     operating systems simultaneously.  This has been fixed.


{hline 8} {hi:update 11may2012} {hline}

{p 5 9 2}
1.  {helpb egen}, when the argument to {it:fcn()} was {cmd:*} (all variables),
    included a temporary variable intended for {cmd:egen}'s own use.  This has
    been fixed.

{p 5 9 2}
2.  {helpb estimates store}, when the specified name was an abbreviation of a
    previously specified name, dropped variable {cmd:e(sample)} of the
    previously stored estimation.  This has been fixed.

{p 5 9 2}
3.  {helpb import excel} did not read Microsoft Excel files if the file
    extension was capitalized.  This has been fixed.

{p 5 9 2}
4.  {helpb logistic estat gof:estat gof} after
    {helpb logistic}, {helpb logit}, and {helpb probit} issued a
    "{err:not enough degrees of freedom to perform the test}" error when it
    was possible to perform the test but there was only one degree of
    freedom.  This has been fixed.

{p 5 9 2}
5.  {helpb fcast compute}, when used after command {helpb vec} with option
    {opt sindicators()}, produced incorrect forecasts.  This has been fixed.

{p 5 9 2}
6.  {helpb margins} reported a conformability error when used with
    {helpb mlogit} or {helpb mprobit} estimation results that used a
    replication method for variance estimation, such as with options
    {cmd:vce(bootstrap)} and {cmd:vce(jackknife)} or with prefix commands
    {helpb bootstrap}, {helpb jackknife}, {helpb svy bootstrap},
    {helpb svy brr}, {helpb svy jackknife}, and {helpb svy sdr}.  This has
    been fixed.

{p 5 9 2}
7.  In rare cases, the {help sem_gui:SEM Builder} created {cmd:.stsem} files
    that it could not open.  A sequence of four actions prior to saving was
    required to elicit the behavior.  1) The SEM model had to be fit
    within the Builder and the diagram had to be incomplete in that some paths
    or covariances required to identify the model were missing.  2) When
    presented with a dialog box asking whether to add the missing paths or
    covariances, the user had to select "Yes".  3) The user then had to modify
    the placement or appearance of one of the added paths or covariances.
    4) The model had to be refit.  This has been fixed.

{p 9 9 2}
    If you have a {cmd:.stsem} file that exhibits this problem, StataCorp can
    recover the file.  Send the file to Technical Services at
    {browse "mailto:tech-support@stata.com":tech-support@stata.com}.  If you
    can also send the associated dataset, the recovery will be easier and
    quicker, but the dataset is not required.

{p 5 9 2}
8.  In the {help sem_gui:SEM Builder}, some cosmetic edits to the path diagram
    (for example, color and size) could not be undone.  This has been fixed.

{p 5 9 2}
9.  {helpb sts graph} produced an error when the path of the temporary
    directory contained a space.  This has been fixed.

{p 4 9 2}
10.  {helpb tetrachoric} with option {cmd:pw} and two variables with no
     nonmissing observations in common produced a spurious correlation value
     instead of a missing value for those two variables.  This has been fixed.


{hline 8} {hi:update 24apr2012} {hline}

{p 5 9 2}
1.  {helpb export excel} exported blanks instead of the numeric value for data
    that used a value label, but the data were unlabeled.  This has been fixed.

{p 5 9 2}
2.  {helpb margins} now works with constant-only models.

{p 5 9 2}
3.  {helpb pwcompare} and {helpb pwmean} did not account for unequal
    within-term variances of the margins when determining group codes; thus
    some significantly different margins were incorrectly labeled with the
    same group code.  This has been fixed.

{p 5 9 2}
4.  (Stata/MP) {helpb regress} with {cmd:aweight}s that did not sum to the
    sample size, option {opt noconstant}, and 300 or more independent
    variables computed an incorrect root mean squared error and
    variance-covariance matrix of the coefficient estimates.  This has been
    fixed.

{p 5 9 2}
5.  (Mac) The {bf:Window > Do-file Editor > New Do-file} menu item has been
    renamed to {bf:Top Do-file} and assigned a keyboard shortcut.  This menu
    item will select the topmost Do-file Editor window and bring it to the
    front.  If there are no Do-file Editor windows open, it will create a new
    Do-file Editor window.


{hline 8} {hi:update 04apr2012} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 12(1).

{p 5 9 2}
2.  {helpb alpha} with options {cmd:item} and {cmd:label} and with the
    Results window sized greater than 99 characters wide reported incorrect
    observation totals.  This has been fixed.

{p 5 9 2}
3.  {helpb areg} with factor-variable notation would, on rare occasions, fail
    to omit a collinear variable, resulting in a
    "{err:matrix not positive definite}" error.  This has been fixed.

{p 5 9 2}
4.  {helpb asclogit} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}
    sometimes did not converge when it should have.  This has been fixed.

{p 5 9 2}
5.  In {help Stata/MP}, functions {helpb bofd()} and {helpb dofb()} could
    produce erroneous results or crash Stata.  Passing the same arguments to
    one of these functions would yield correct results some of the time, yield
    incorrect results at other times, or cause Stata to crash, with
    essentially no ability to predict which of the three outcomes would occur
    at any particular function invocation.  Stata/MP users who have used
    these functions should verify datasets and results that depend on proper
    conversion between business and daily calendar dates.  These functions
    have been fixed.

{p 5 9 2}
6.  {helpb import excel} has the following fixes:

{p 9 13 2}
    a.  {cmd:import excel} imported an Excel column with only numeric cells
        and empty string cells as a string variable. This has been changed to
        import the column as a numeric variable.

{p 9 13 2}
    b.  {cmd:import excel} ignored Excel elapsed time formats.  This has been
        fixed.  Excel elapsed time formats are now imported as Stata
        {help datetime_display_formats:datetime format} {cmd:%tc}.

{p 5 9 2}
7.  {helpb marginsplot} working with more than one factor variable in
    {helpb margins} results failed to identify an x-axis variable if it was a
    factor variable and the base was {helpb fvset}.  This has been fixed.

{p 5 9 2}
8.  {helpb nbreg} ignored option {cmd:vce(opg)} and reported the variance
    based on the observed information matrix instead of the outer product of
    the gradients.  This has been fixed.

{p 5 9 2}
9.  {helpb glm_postestimation##predict:predict, score} after
    {helpb glm:glm, family(binomial) link(logit)} caused an error if the
    dependent variable was missing in the observations that {cmd:predict} was
    used on.  This has been fixed.

{p 4 9 2}
10.  {helpb sem} with option {opt noivstart} now allows the specified model to
     have more latent variables than observed endogenous variables.  When
     option {opt noivstart} is not specified, {cmd:sem} will continue to
     report an error if there are more latent variables than observed
     endogenous variables.

{p 4 9 2}
11.  {helpb tsappend:tsappend, last() tsfmt()} when the data had been
     {helpb tsset} to have a panel variable carried over the last observed
     value to the appended observations rather than assigning missing values
     to them.  This has been fixed.

{p 4 9 2}
12.  {helpb ttest:ttest, by()} with a string by-variable containing values
     with leading blanks issued a "{err:more than 2 groups found}" error.
     This has been fixed.

{p 4 9 2}
13.  {helpb twoway area} with option {cmd:horizontal} drew the plot
     incorrectly after the 30jan2012 update.  This has been fixed.

{p 4 9 2}
14.  {helpb use} with {it:varlist} could cause Stata to crash if the command
     returned with an error.  This has been fixed.

{p 4 9 2}
15.  {helpb xtmixed}, {helpb xtmelogit}, and {helpb xtmepoisson} failed to
     post the standard {cmd:r()} results associated with the coefficient table
     ({helpb ereturn display}) when the fixed-effects table was reported.
     This has been fixed.

{p 4 9 2}
16.  (Windows) In rare cases, {helpb browse} or {helpb edit} specified with
     {helpb if} could cause Stata to crash when there were no data in memory.
     This has been fixed.

{p 4 9 2}
17.  (Windows) Exporting an SEM graph to a bitmap format such as PNG resulted
     in a thin black line along the right and bottom edges of the graph.  This
     has been fixed.

{p 4 9 2}
18.  (Windows) In rare cases, {helpb update all} could exit with error
     {search r(2101):r(2101)} even when the executable was named correctly.
     This has been fixed.

{p 4 9 2}
19.  (Mac) When loading saved preferences while a Do-file Editor window was
     already open, the Do-file Editor window would get centered on the screen
     instead of using the saved position from the saved preferences.  This has
     been fixed.

{p 4 9 2}
20.  (Windows and Mac) Calling Stata in batch mode before entering a license
     and authorization key would cause Stata to hang in an infinite loop.
     This has been fixed.


{hline 8} {hi:update 15mar2012} {hline}

{p 5 9 2}
1.  The following commands now label standard errors as "Robust" instead of
    "Semirobust" when the {cmd:vce(robust)} option is used:

{p 13 13 2}
	{helpb binreg:binreg, irls or}{break}
	{helpb glm:glm, irls} {space 6} with canonical links{break}
	{helpb xtgee:xtgee} {space 10} with canonical links{break}
	{helpb xtlogit:xtlogit, pa}{break}
	{helpb xtpoisson:xtpoisson, pa}{break}
	{helpb xtreg:xtreg, pa}{p_end}

{p 9 9 2}
    Under the canonical link, "Semirobust" and "Robust" standard errors are
    equivalent.

{p 5 9 2}
2.  {helpb biprobit} has the following fixes:

{p 9 13 2}
    a.  {cmd:biprobit} with constraints reported the likelihood-ratio test of
        rho=0 rather than a Wald test.  This has been fixed.

{p 9 13 2}
    b.  {cmd:biprobit} in the seemingly unrelated form produced an error when
        option {cmd:iterate()} was specified.  This has been fixed.

{p 5 9 2}
3.  {helpb bootstrap} and {helpb bstat} have new option {opt ties}.

{p 5 9 2}
4.  {helpb collapse} could produce incorrect summary statistics when {it:stat}
    was {cmd:last()}, {cmd:first()}, {cmd:lastnm()}, or {cmd:firstnm()} and
    the dataset had been sorted by more than one variable.  This has been
    fixed.

{p 5 9 2}
5.  {helpb contrast} and {helpb pwcompare}, after commands that have an
    implied intercept in the main regression equation, such as {helpb ologit}
    and {helpb oprobit}, incorrectly flagged some contrasts, pairwise
    comparisons, and margins as "(not estimable)".  This has been fixed.

{p 5 9 2}
6.  {helpb gmm} has the following fixes:

{p 9 13 2}
    a.  {cmd:gmm} exited with an error message if option
        {cmd:vce(cluster} {it:clustvar}{cmd:)} was specified and the user had
        previously {helpb xtset} the data with a panel variable but not a time
        variable.  This has been fixed.

{p 9 13 2}
    b.  {cmd:gmm} exited with an error message if option {opt xtinstruments()}
        was used and 1) one or more panels was eliminated from the estimation
        sample because of missing data or 2) a panel had nonmissing data for
        only the observation corresponding to the last time period in the
        estimation sample.  These issues have been fixed.

{p 5 9 2}
7.  {helpb logistic} with option {opt log} caused a syntax error,
    "{err:option nolog not allowed}".  This has been fixed.

{p 5 9 2}
8.  {helpb nlsur} was documented as allowing the user to pass optional
    arguments to the function evaluator program.  However, {cmd:nlsur} ignored
    these options and did not pass them to the function evaluator program.
    This has been fixed.

{p 5 9 2}
9.  {helpb sem} with option {cmd:method(mlmv)} sometimes produced a Mata trace
    log error instead of reporting that the starting values were not feasible.
    This has been fixed.


{hline 8} {hi:update 06feb2012} {hline}

{p 5 9 2}
1.  The 30jan2012 update to {helpb gmm} introduced the following bugs, which
    have now been fixed.

{p 9 13 2}
    a.  {cmd:gmm, twostep} accepted {it:iweight}s but did not handle them
        correctly under two-step estimation.  This has been fixed.

{p 9 13 2}
    b.  {cmd:gmm} {it:moment_prog} exited with an error when multiple moment
        equations were used with analytic derivatives.  This has been fixed.

{p 5 9 2}
2.  {helpb lrtest} issued a "{err:samples differ}" error when observations
    were added to the dataset between fitting the models that were being
    compared.  The estimation samples do not actually differ when the
    additional observations are not used in fitting the second model.  The
    error is no longer produced in this case.

{p 5 9 2}
3.  The 30jan2012 update introduced a bug where user-written ado-files saved
    with legacy Mac end-of-line delimiters resulted in an unexpected
    end-of-file error when loaded.  This has been fixed.

{p 5 9 2}
4.  (Mac) Exporting a graph as a PDF using command form
    {cmd:graph export ~/filename.pdf} resulted in an error because the {cmd:~}
    was not converted to the user's home directory.  Only the PDF format was
    affected.  This has been fixed.

{p 5 9 2}
5.  (Mac) Exporting a graph as a PDF with option {cmd:name()} always exported
    the topmost graph instead of the named graph.  Only the PDF format was
    affected.  This has been fixed.

{p 5 9 2}
6.  (Linux) A library change in some of the latest releases of Linux
    distributions could cause Stata's memory to become corrupt.  This behavior
    has been observed in CentOS 6.2 and Ubuntu 11.10 but not in any prior
    versions.  The data corruption was isolated to variables that were loaded
    when a {varlist} was specified with command {helpb use}, and even then was
    unlikely to occur.  {cmd:use} without a {it:varlist} was not affected.
    This has been fixed.


{hline 8} {hi:update 30jan2012} (Stata version 12.1) {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 11(4).

{p 5 9 2}
2.  {helpb qreg} has improved standard-error estimates.  There are three
    new estimators available for estimating the standard errors: the
    fitted-value-based estimator, the residual-based estimator, and the
    kernel estimator.  In addition, three new bandwidth choices are available.

{p 9 9 2}
    The new default standard errors will provide better coverage than the
    old standard errors.  Use {cmd:version 12: qreg ...} to reproduce the
    old standard-error estimates.

{p 5 9 2}
3.  Normal random variates generated by {helpb f_rnormal:rnormal()} may be
    different between version 11.2 and 12.0.  This has been fixed.  The normal
    variates generated in version 12.1 will match those of 11.2.  Use
    {cmd:version 12: }{helpb set seed}{it: #} to reproduce normal random
    variates generated under version 12.0.

{p 5 9 2}
4.  {helpb xtunitroot} now accepts time-series operators.

{p 5 9 2}
5.  {helpb assert} has new option {opt fast}, which forces the command to exit
    when it encounters the first contradiction.

{p 5 9 2}
6.  {helpb asmprobit} and {helpb asroprobit} with options
    {cmd:intburn(}{it:#}{cmd:)} and {cmd:favor(speed)} (the default) ignored
    the starting index specified in {cmd:intburn()}.  This has been fixed.

{p 5 9 2}
7.  {help datetime_business_calendars:business calendars} have the following
    fixes:

{p 9 13 2}
    a.  An incorrect business calendar file -- a {cmd:.stbcal} file containing
        an error -- could cause Stata to loop endlessly when asked to display
        values formatted with that business format.  This has been fixed.
        When a value is formatted with a format containing an error, the
        underlying numerical value is shown.

{p 9 13 2}
    b.  Some correct business calendars were mistakenly considered by Stata to
        be in error and thus produced error messages.  This has been fixed.

{p 5 9 2}
8.  {helpb clogit} and {helpb xtlogit} with option {cmd:fe} did not omit
    factor variables that have no within-group variance.  This has been fixed.

{p 5 9 2}
9.  {helpb collapse} with statistic {cmd:lastnm} if {cmd:by()} was not
    specified sometimes selected a missing value instead of the last
    nonmissing value.  This has been fixed.

{p 4 9 2}
10.  {helpb estimates table} has the following fixes:

{p 9 13 2}
     a.  {cmd:estimates table} when used with an interaction element specified
         in option {opt drop()} or {opt keep()} resulted in an invalid
         operator error even when the interaction term was specified
         correctly.  This has been fixed.

{p 9 13 2}
     b.  {cmd:estimates table} when used with time-series operators in option
         {opt drop()} or {opt keep()} incorrectly reported that the
         coefficient did not occur in any of the specified models.  This has
         been fixed.

{p 9 13 2}
     c.  {cmd:estimates table} with option {opt equations()} and results from
         {helpb sem} would report an invalid operator error.  This has been
         fixed.

{p 4 9 2}
11.  {helpb glm} incorrectly reported a syntax error if option
     {cmd:vce(unbiased)} was specified in addition to {cmd:vce(robust)} or
     {cmd:vce(cluster} {it:clustvar}{cmd:)}.  This has been fixed.

{p 4 9 2}
12.  {helpb gmm} now accepts {cmd:iweight}s.  {cmd:iweight}s are treated
     like {cmd:fweight}s except that {cmd:iweight}s may be noninteger.  When
     {cmd:iweight}s are used, the reported sample size is the sum of the
     weights rounded down to the nearest integer.

{p 9 9 2}
     Also, an error message is now issued if {cmd:gmm} encounters missing
     values when calculating the user-supplied analytic derivatives.

{p 4 9 2}
13.  {helpb import excel} and {helpb export excel} have the following fixes
     and new features:

{p 9 13 2}
     a.  {cmd:import excel} and {cmd:export excel} now have new option
         {opt locale()}, which allows you to specify the locale of the Excel
         workbook.

{p 9 13 2}
     b.  {cmd:import excel} now has option {opt case()}.  This option works
         with option {cmd:firstrow} and takes {cmd:lower}, {cmd:upper}, or
         {cmd:preserve} depending on what case you want your variable names to
         be.

{p 9 13 2}
     c.  {cmd:import excel} and {cmd:export excel} did not allow the
         documented command abbreviations.  This has been fixed.

{p 9 13 2}
     d.  {cmd:import excel} did not always reset file handle tracking if an
         error occurred when reading the file.  This has been fixed.

{p 9 13 2}
     e.  (Mac and Unix) {cmd:import excel} and {cmd:export excel} did not
         respect {cmd:~} in paths.  This has been fixed.

{p 4 9 2}
14.  {helpb margins} after {helpb xtpoisson} with option {opt fe} incorrectly
     reported margins and marginal effects of factor variables as "not
     estimable".  This has been fixed.

{p 4 9 2}
15.  {helpb marginsplot} has the following fixes:

{p 9 13 2}
     a.  {cmd:marginsplot}s of {helpb margins} results using factor variables
         in option {opt dydx()} had unwanted base-level plots since the
         13oct2011 update.  This has been fixed.

{p 9 13 2}
     b.  {cmd:marginsplot} failed to identify the x-axis variable if it was a
         factor variable and the base was {helpb fvset}.  This has been fixed.

{p 4 9 2}
16.  {helpb mata} has the following fixes and new features:

{p 9 13 2}
     a.  The maximum number of numeric literals in a single Mata function has
         been increased from 100 to 2000.

{p 9 13 2}
     b.  Long sequences from Mata function {helpb mf_ghalton:ghalton()} could
         deviate from the true Halton sequence.  This has been fixed.

{p 9 13 2}
     c.  When there was an error, Mata function
         {helpb mf_st_addvar:_st_addvar()} returned with the Stata return code
         itself instead of the negative of the appropriate Stata return code
         as indicated by the documentation.  This has been fixed.

{p 9 13 2}
     d.  (Windows) Mata function {helpb mf_dir:dir()} returned file and
         directory names in lowercase.  This has been changed to respect the
         original case.

{p 4 9 2}
17.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total}
     neglected to post the coefficient table results to {cmd:r()} when run
     {helpb quietly} even when {helpb set coeftabresults} was {cmd:on}.  This
     has been fixed.

{p 4 9 2}
18.  {helpb mi_estimate:mi_estimate, post:} issued a
     "{err:last estimates not found}" error when used with multilevel
     commands, such as {cmd:xtmixed} with more than two levels.  This has been
     fixed.

{p 4 9 2}
19.  {helpb ml} has the following fixes:

{p 9 13 2}
     a.  {cmd:ml} with constraints used with option {cmd:technique(dfp)} or
         {cmd:technique(bfgs)} caused a conformability error in Mata.  This
         has been fixed.

{p 9 13 2}
     b.  {cmd:ml} used with time-series operators but without option
         {opt nopreserve} resulted in the
         "{err:initial values not feasible}" error.  This has been fixed.

{p 4 9 2}
20.  After the 13oct2011 update, {helpb odbc load} did not remember file
     information correctly for "MS Access Database" data source names.  This
     has been fixed.

{p 4 9 2}
21.  {cmd:predict} after {helpb xtmixed}, {helpb xtmelogit}, and
     {helpb xtmepoisson} now reports a more informative error message when the
     predicted statistic requires random-effects estimation and the data used
     in estimation are not in memory.

{p 4 9 2}
22.  {helpb _rmdcoll} when supplied with a {it:depvar} that was constant and
     zero gave an unhelpful error message.  This has been fixed.

{p 4 9 2}
23.  {helpb rocreg:rocreg, probit ml} with {cmd:pweight}s and multiple
     classification variables produced an error message.  This has been fixed.

{p 4 9 2}
24.  The F statistic reported by {helpb sdtest} was not formatted properly
     when the decimal point was set to a comma instead of a period.  This has
     been fixed.

{p 4 9 2}
25.  {helpb sem} has the following fixes and new features:

{p 9 13 2}
     a.  {cmd:sem} is now more convergent because of improvements in the
         computation of analytic derivatives.

{p 9 13 2}
     b.  {cmd:sem} now uses new algorithms that dramatically reduce the amount
         of memory required for models with many observed variables.

{p 9 13 2}
     c.  {cmd:sem} with a string variable specified in option
         {cmd:vce(cluster} ...{cmd:)} caused a Mata run-time error complaining
         that a real vector was required.  This has been fixed.

{p 9 13 2}
     d.  {cmd:sem} specified with hierarchical latent structural paths and
         observed exogenous variables caused a Mata trace-log error.  This has
         been fixed.

{p 9 13 2}
     e.  {cmd:sem} neglected to switch to {opt noxconditional} when
         constraints were applied to the mean of an observed exogenous
         variable.  This has been fixed.

{p 9 13 2}
     f.  {cmd:sem} computed incorrect standard errors for the reported means
         and covariances of observed exogenous variables when {cmd:sem}
         remained {opt xconditional}.  {cmd:sem} now switches to
         {opt noxconditional} when an observed exogenous variable is specified
         in option {opt mean()}, {opt variance()}, {opt covariance()}, or
         {opt covstructure()}.

{p 9 13 2}
     g.  The {help sem_gui:SEM Builder} could not fully edit variables whose
         labels contained quotes.  Some edits worked, others did not, and
         selecting such variables produced error messages.  This has been
         fixed.

{p 4 9 2}
26.  If {helpb set segmentsize} was used after {helpb set max_memory}, Stata
     could fail to load any dataset with size larger than the new segmentsize.
     This has been fixed.

{p 4 9 2}
27.  {helpb stsplit} when used with {cmd:after()} and {cmd:every()}
     incorrectly split observations that occurred before the time specified in
     {cmd:after()}.  This has been fixed.

{p 4 9 2}
28.  {helpb twoway area} now uses an internal drawing routine that is
     significantly faster over large datasets.

{p 4 9 2}
29.  {helpb twoway contour} drew an extra line at the bottom of the legend if
     the smallest cut was less than the minimum of the z value.  This has been
     fixed.

{p 4 9 2}
30.  {helpb use} and {helpb merge} will now exit with an error if the dataset
     on disk contains an invalid {help data type}.

{p 4 9 2}
31.  {helpb xtmelogit} and {helpb xtmepoisson} do not support weighted
     estimation.  When {cmd:fweight}s or {cmd:pweight}s were specified, the
     weights were ignored and the unweighted results were reported.  An
     appropriate error message is now issued.

{p 4 9 2}
32.  A do-file containing ASCII character 255 would cause that do-file to
     terminate upon processing of that character.  This has been fixed.

{p 4 9 2}
33.  The varlist controls for dialogs sometimes were not displayed correctly
     when listing a large varlist.  This has been fixed.

{p 4 9 2}
34.  The Data Editor has the following fixes:

{p 9 13 2}
     a.  The 13Oct2011 update modified the behavior of pasting so that numbers
         with leading zeros preserved the leading zeros by importing the value
         as a string.  However, the logic was flawed, causing a value of zero
         to also import as a string.  This has been fixed.

{p 9 13 2}
     b.  Paste Special did not handle carriage returns embedded inside double
         quotes.  Now carriage returns are processed as part of the string if
         the option "Double quotes bind tokens" is checked.

{p 4 9 2}
35.  (Windows) A setting has been added to the Do-file Editor's Preference
     dialog that allows the behavior for {cmd:.do} file extensions to be
     changed so that the default is execute.  Previously, the default behavior
     in Stata 12 was changed to always edit do-files.

{p 4 9 2}
36.  (Windows) Typing characters in the Variables window now places the
     keyboard focus in the Command window, leaving the cursor at its previous
     location.  Previously, the cursor was always moved to the end of any
     existing text.  Note that the behavior for pressing the space bar has not
     changed; it still sends the selected variables to the Command window.

{p 4 9 2}
37.  (Mac) Printing from the Results or Viewer windows now prevents partial
     lines from being printed regardless of paper size.

{p 4 9 2}
38.  (Mac) Mac OS X 10.7 (Lion) introduced a feature called automatic text
     substitution in text controls that allows a user to type text such as tm
     and have it replaced by the trademark symbol.  By default, it is turned
     on by the OS but it can interfere with Stata's ado-language.  Automatic
     text substitution is now turned off in the Do-file Editor and the Command
     window.

{p 4 9 2}
39.  (Mac) Mac OS X 10.7.2 (Lion) introduced a bug that causes the Zoom
     combobox in the SEM Builder's toolbar to crash Stata.  This bug does not
     affect Stata running on earlier versions of Mac OS X.  The appearance of
     the combobox has been changed to avoid this bug in Lion.

{p 4 9 2}
40.  (Mac) The Break menu item and keyboard shortcut (Command+.) would always
     be disabled if the main Stata window's toolbar was hidden when Stata
     started up.  This has been fixed.

{p 4 9 2}
41.  (Mac) When saving an SEM path diagram, the default filename would have a
     file extension of {cmd:.gph} instead of {cmd:.stsem} if the Finder was
     set to always show file extensions or the Save dialog's Hide File
     Extensions checkbox was unchecked.  This has been fixed.

{p 4 9 2}
42.  (Mac) In very rare cases, Stata for Mac could crash if a {helpb browse}
     or {helpb edit} command was issued and resulted in an error (such as
     incorrectly typing a variable name).  This has been fixed.

{p 4 9 2}
43.  (Mac) The Variables Name field of the Data Editor's Properties pane was
     not editable unless a variable in the Data Editor's Variables pane was
     selected even though there was a single variable selected in the Data
     Editor's grid pane.  This has been fixed.


{hline 8} {hi:update 10nov2011} {hline}

{p 5 9 2}
1.  {helpb gmm} would on rare occasions exit with an error message when option
    {opt xtinstruments()} was specified and the minimum requested lag
    was greater than one.  This has been fixed.

{p 9 9 2}
    Also, we have tweaked the scaling bounds used by {cmd:gmm}'s numerical
    derivative taker to better handle some difficult problems.  Most users
    will notice no differences, but a few problems that failed to work
    previously should now work.  Moreover, an error message is now issued if
    {cmd:gmm} encounters missing values when computing numerical derivatives.

{p 5 9 2}
2.  {helpb ivregress} incorrectly treated endogenous regressors that used
    time-series operators as exogenous when collinear variables and factor
    variables were specified as exogenous regressors ({it:varlist1}).  This
    has been fixed.

{p 5 9 2}
3.  {helpb marginsplot} after the 13oct2011 update put option {opt level()}'s
    specification in the graph title instead of the specified
    confidence-level value.  This has been fixed.

{p 5 9 2}
4.  In styles mlong and flong, {helpb mi update} (or any other {cmd:mi}
    command that runs {cmd:mi update} automatically) would unregister all
    passive variables whenever any passive variable was dropped using
    command {cmd:drop}.  This could result in a loss of imputed data for some
    of the unregistered passive variables in style mlong.  This
    problem did not occur if {cmd:mi xeq: drop} was used to drop a passive
    variable instead of {cmd:drop}.  This has been fixed.

{p 5 9 2}
5.  {helpb mi varying} issued a "{red:type mismatch}" error in styles flong
    and flongsep when a string variable varied between imputations.  This has
    been fixed.

{p 5 9 2}
6.  {helpb mi xeq} has the following fixes:

{p 9 13 2}
    a.  {cmd:mi xeq} now issues an error if {helpb collapse} is attempted to
        be used with it.

{p 9 13 2}
    b.  {cmd:mi xeq} did not allow {help svy:survey commands} to be executed
        on individual imputations.  This has been fixed.

{p 5 9 2}
7.  {helpb rocreg} failed when {cmd:ctrlcov()} was specified with bootstrap
    standard errors.  This has been fixed.

{p 5 9 2}
8.  {helpb sem} with variances constrained to zero sometimes reported the
    "{err:initial values not feasible}" error, even when the model was
    properly specified.  This has been fixed.


{hline 8} {hi:update 13oct2011} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 11(3).

{p 5 9 2}
2.  {helpb help} no longer displays a message box before doing a
    {helpb search} if the help term was not a Stata command.

{p 5 9 2}
3.  {helpb estat ginvariant} after {helpb sem} reported noninformative rows of
    dots for testing group invariance of latent variable means when the
    default constraints were used.  This has been fixed to no longer show
    these rows.

{p 5 9 2}
4.  The {helpb icd9} databases have been updated to use the latest version
    (V29) of the ICD-9 codes, which became effective on 1 October 2011.

{p 5 9 2}
5.  {helpb import excel} has the following fixes:

{p 9 13 2}
    a.  {cmd:import excel} imported cells with formatted text as empty
        strings.  This has been fixed.

{p 9 13 2}
    b.  {cmd:import excel} imported text cells containing Unicode characters
        not supported by the current code page as empty strings.  This has
        been fixed so that the Unicode characters are replaced as question
        marks.

{p 9 13 2}
    c.  {cmd:import excel} imported inline string and numeric cells in
        {cmd:.xlsx} files as empty string and missing values.  This has been
        fixed.

{p 5 9 2}
6.  {helpb margins} after {helpb manova} with option {opt asbalanced} with the
    default prediction was producing incorrect margin values when there was a
    factor variable in the model but not in the margins list.  This was also
    the case if option {cmd:at()} was used to set the relative frequencies
    of a factor variable in the model.  This has been fixed.

{p 5 9 2}
7.  {helpb marginsplot} has the following fixes and new features:

{p 9 13 2}
    a.  {cmd:marginsplot} ignored the {opt level()} and {opt mcompare()}
        information stored in {cmd:r()} after {helpb margins}, yielding
        unadjusted confidence intervals using the default level setting.  This
        has been fixed.

{p 9 13 2}
    b.  {cmd:marginsplot} now accepts options {opt level()} and
        {opt mcompare()}.  These options affect the plotted confidence
        intervals.

{p 5 9 2}
8.  {helpb odbc load} now remembers your file information when using the
    "Excel Files" or "MS Access Database" data source names.

{p 5 9 2}
9.  {helpb stcurve} after {helpb streg} with omitted variables produced
    missing values and blank graphs.  This has been fixed.

{p 4 9 2}
10.  The Data Editor has the following fixes:

{p 9 13 2}
    a.  Paste now respects {helpb set type}.

{p 9 13 2}
    b.  Paste no longer treats numbers with leading zeros as numeric.

{p 9 13 2}
    c.  Paste did not create variable labels when the variable names were
        modified to form legal names in Stata.  This has been fixed.

{p 9 13 2}
    d.  With the Data Editor open, any program or do-file that both renamed a
        variable and decreased the total number of variables could cause Stata
        to crash.  This has been fixed.

{p 9 13 2}
    e.  (Mac and Unix) From the Data Editor's Paste Special dialog, the
        checkbox labeled 'treating sequential delimiters as one' could cause
        Clipboard data to be misinterpreted.  This has been fixed.

{p 4 9 2}
11.  (Windows) The dialog box for {helpb sktest} caused Stata to crash when
     the Expression Builder was launched from the if/in tab.  This has been
     fixed.

{p 4 9 2}
12.  (Mac) Opening a do-file using the Open button in an existing Do-file
     Editor window would cause Stata to crash only when run on Mac OS X 10.5
     (Leopard).  This crash does not happen on Mac OS X 10.6 and Mac OS X 10.7
     and does not happen if you use File > Open to open a do-file even on Mac
     OS X 10.5.  We have changed the Do-file Editor to work around this issue
     with Mac OS X 10.5.

{p 4 9 2}
13.  (Unix) When you click on a menu item in the Stata Help menu, a new Viewer
     is created.  Before, it overwrote the current active Viewer.


{hline 8} {hi:update 15sep2011} {hline}

{p 5 9 2}
1.  {helpb ereturn display} and some estimation commands would report omitted
    coefficients even when the {helpb set_showomitted:showomitted} setting was
    {cmd:off} or the {opt noomitted} option was specified.  This has been
    fixed.

{p 5 9 2}
2.  {helpb estimates table} has improved parsing logic for options
    {opt keep()} and {opt drop()}.

{p 5 9 2}
3.  Estimation commands with empty cells in interaction terms of the model
    specification crashed Stata if the empty cells were dropped with
    {helpb set emptycells}.  This has been fixed.

{p 5 9 2}
4.  {helpb graph export} failed to set the font face when the output format
    was PDF.  This has been fixed.

{p 5 9 2}
5.  {helpb import excel} and {helpb export excel} could crash Stata if the
    Excel file contained a chart-only sheet.  This has been fixed.

{p 5 9 2}
6.  {helpb import excel} with option {cmd:allstring} could import numeric
    values with less precision into string.  This has been fixed.

{p 5 9 2}
7.  {helpb import excel} treated columns with numeric cells and empty cells as
    string columns instead of numeric columns.  This has been fixed.

{p 5 9 2}
8.  The maximum length of the Mata library path was increased from 256 to 4096
    characters.

{p 5 9 2}
9.  Prefix commands were ignoring misspecified {opt if} conditions when they
    should have been reporting an error.  This has been fixed.

{p 4 9 2}
10.  {helpb rename} now updates {helpb tsset} and {helpb xtset} information in
     the data when the time or panel variable is renamed.

{p 4 9 2}
11.  Zooming in and out from the {help sem_gui:SEM Builder} now keeps the
     currently visible content centered in the window.

{p 4 9 2}
12.  {helpb sem} exited with a Mata conformability error when used with
     {cmd:method(mlmv)} and an estimation sample that had a missing-value
     pattern where all observed variables but one endogenous variable are
     missing.  This has been fixed.

{p 4 9 2}
13.  Single-equation estimation commands that allow options
     {cmd:vce(jackknife)} and {cmd:vce(bootstrap)} reported a syntax error
     when factor-variable or time-series operators that contained
     parentheses were used.  For example,

{p 13 17 2}
         . {cmd:sysuse auto}
{p_end}
{p 13 17 2}
         . {cmd:regress mpg b(last).rep78}
{p_end}

{p 9 9 2}
     reported "variable b not found".  This has been fixed.

{p 4 9 2}
14.  {helpb ssd build} exited with an error when the original data contained a
     value-label name that matched the name of the variable {opt group()}.
     This has been fixed.

{p 4 9 2}
15.  {helpb stcox} with option {cmd:efron} took a long time to compute when
     there were many tied failures.  This has been fixed.

{p 4 9 2}
16.  {cmd:test}, {cmd:test} after {cmd:anova}, and {cmd:test} after
     {cmd:manova} have new dialogs providing access to the equation names and
     coefficients of the last estimation.

{p 4 9 2}
17.  {helpb translator query} failed to display translator Graph2pdf's
     parameter settings.  This has been fixed.

{p 4 9 2}
18.  {helpb update all} when called from batch mode would prompt the user
     before closing Stata.  The behavior has been changed so that interactive
     prompts are now suppressed.

{p 4 9 2}
19.  Adding variables to the Command window by clicking on a variable in the
     Variables window now prefixes a space character only when necessary.

{p 4 9 2}
20.  In the Data Editor, in very rare circumstances, Paste Special could crash
     Stata.  This has been fixed.

{p 4 9 2}
21.  (Windows) {cmd:window manage close viewer _all} did not close any Viewer
     windows when it should have closed all of them.  This has been fixed.

{p 4 9 2}
22.  (Mac) Stata for Mac has the following new features and fixes:

{p 9 13 2}
     a.  Stata's file dialogs now support opening symbolic links to files or
         directories.

{p 9 13 2}
     b.  The Variables and Review windows now only pass a {hi:Return} key
         press to the Command window when they have the keyboard focus.

{p 9 13 2}
     c.  The Do-file Editor will now open a do-file in the current tab or
         window if it is empty and unsaved rather than always create a new
         tab or window.

{p 9 13 2}
     d.  The gesture preferences are no longer displayed in the Preferences
         dialog when running under Lion because they are unsupported.

{p 9 13 2}
     e.  Launching the GUI version of Stata from a command line to execute a
         do-file caused the {hi:Break} key to be disabled until the do-file
         had completed.  This has been fixed.

{p 9 13 2}
     f.  In tabbed windows, the {bf:Close} button for a tab is hidden until
         the mouse cursor is over a tab.  Stata now always displays the
         {bf:Close} button for the active tab unless it is the only tab in a
         window.

{p 9 13 2}
     g.  After updating ado-files or documentation only, Stata would not
         relaunch.  This has been fixed.

{p 4 9 2}
23.  (Unix) Dragging and dropping a long command from the Review window to the
     Command window crashed Stata for Unix.  This has been fixed.

{p 4 9 2}
24.  (Unix) The Do-file Editor did not support extended ASCII characters in
     do-files.  This has been fixed.


{hline 8} {hi:update 01sep2011} {hline}

{p 5 9 2}
1.  The {help whatsnew11##up01sep2011:01sep2011 Stata 11.2 update} item 1 has
    now been applied to Stata 12.  Other applicable items from that update
    were applied previously.

{p 5 9 2}
2.  {help prefix:Prefix} commands that produce replication-based variance
    estimates (such as {helpb bootstrap}) when used with posted results from
    {helpb margins} with option {cmd:at()} reported a "{err:no observations}"
    error after completing all the replications.  This has been fixed.

{p 5 9 2}
3.  Some {helpb sem_postestimation:estat} commands after {helpb sem} with
    method {cmd:mlmv} and {cmd:xconditional} results would error-out with a
    Mata trace log.  This has been fixed.

{p 5 9 2}
4.  In the {help sem_gui:SEM Builder}, observed variables whose names begin
    with a capital letter were treated as latent when estimation was
    performed.  This has been fixed.

{p 5 9 2}
5.  In the {help sem_gui:SEM Builder}, the property dialog boxes for variables
    and paths would not allow initial values to be removed.  This has been
    fixed.

{p 5 9 2}
6.  {helpb sem} specified with models with three or more endogenous variables
    and some of them used to predict other endogenous variables would yield
    different standard errors or even fail to converge depending on the
    order in which the paths were specified.  A typical difference in the
    standard errors was in the third decimal place and beyond, depending on
    the relative scales of the observed variables.  This has been fixed.


{hline 8} {hi:update 24aug2011} {hline}

{p 5 9 2}
1.  {helpb blogit} did not allow option
    {cmd:vce(cluster} {it:clustvar}{cmd:)}.  This has been fixed.

{p 5 9 2}
2.  {help datetime business calendars creation:Business calendars} with month
    or weekday names containing capital letters would fail to load.  This has
    been fixed.

{p 5 9 2}
3.  {helpb marginsplot} now recognizes {helpb margins} results in {cmd:e()}
    when {cmd:r()} no longer contains results from {cmd:margins}.
    {cmd:margins} will post its results to {cmd:e()} when option {opt post}
    is used.

{p 5 9 2}
4.  Mata's {helpb mf_optimize:optimize()} with the Nelder-Mead technique and
    constraints would error-out with a Mata trace log.  This has been fixed.

{p 5 9 2}
5.  {helpb query} now displays the setting {helpb coeftabresults} as an output
    setting.  This setting controls whether coefficient table results are
    stored in {cmd:r()}.

{p 5 9 2}
6.  {helpb roctab} with option {opt detail} produced unaligned tables when the
    classification variable had long value labels.  These labels are now
    abbreviated if needed, and a new option, {opt nolabel}, has been added to
    suppress displaying the value labels.

{p 5 9 2}
7.  {helpb sspace}, when time-series operators were combined with the
    {cmd:e.} error operator on the dependent variable in an {it:obs_efeq}
    equation, produced an error message.  This has been fixed.

{p 5 9 2}
8.  {helpb svy}{cmd:} {helpb ivregress} reported an invalid operator error
    when factor-variables notation was used in the list of instrumental
    variables ({it:varlist_iv}) but not in the list of exogenous variables
    ({it:varlist1}).  This has been fixed.

{p 5 9 2}
9.  When pasting data into the Data Editor, sequential delimiters were treated
    as one delimiter, causing missing cells to be omitted.  This has been
    fixed.

{p 4 9 2}
10.  (Windows) Updating Stata over a network share failed with error r(695),
     leaving the Stata installation unchanged.  This has been fixed.

{p 4 9 2}
11.  (Mac) When resizing the main Stata window, the Results view will now
     always be the main view that gets resized regardless of its location in
     the main Stata window.

{p 4 9 2}
12.  (Mac) The keyboard shortcut for "Do to Bottom" for the Do-file Editor has
     been changed to Ctrl-Cmd-D because the previous keyboard shortcut
     conflicted with the system keyboard shortcut for hiding/showing the Dock.

{p 4 9 2}
13.  (Mac) If tabbed windowing for the Do-file Editor is turned off and there
     are multiple Do-file Editor windows, Stata could be confused as to which
     Do-file Editor is active and perform menu and toolbar operations on the
     wrong window.  This has been fixed.

{p 4 9 2}
14.  (Mac) Translating SMCL to PDF has been reenabled.

{p 4 9 2}
15.  (Mac) Translating SMCL to PS could cause Stata to crash.  This has been
     fixed.

{p 4 9 2}
16.  (Unix) Shift-clicking objects in the {help sembuilder:SEM Builder} would
     not properly enable/disable items in the Object > Align menu.  This has
     been fixed.


{hline 8} {hi:update 08aug2011} {hline}

{p 5 9 2}
1.  {helpb compress} and commands that internally used {cmd:compress} could
    fail, causing future commands to issue a "{err:variable not found}" error.
    This has been fixed.


{hline 8} {hi:update 05aug2011} {hline}

{p 5 9 2}
1.  A serious memory management bug has been fixed.  The bug was unlikely to
    occur.  If it occurred, it usually caused a crash.  It could, however,
    cause data to be corrupted.  We had only four reports, all involving
    crashes.  If a dataset was below 32 MB on 64-bit computers or 16 MB on
    32-bit computers, the bug could not occur.

{p 5 9 2}
2.  {helpb stcox} using options {cmd:efron} and {cmd:vce(robust)} could take a
    long time to compute for large datasets with many tied failure times.
    This has been fixed.

{p 5 9 2}
3.  (Mac) Changing the results color for the Results window had no effect.
    This has been fixed.

{p 5 9 2}
4.  (Mac) The keyboard shortcuts for Shift Left and Shift Right in the Do-file
    Editor's contextual menu did not match the main menu's keyboard shortcuts
    (which take precedence).  This has been fixed.

{p 5 9 2}
5.  (Mac) Graphs drawn using polygons would render with thick lines when
    exported to PDF or a bitmap format.  This has been fixed.

{p 5 9 2}
6.  (Windows) Some tooltips for copying to the Clipboard could incorrectly
    show up as "Copy Diagram".  This has been fixed.

{p 5 9 2}
7.  (Windows) On some international keyboards, characters that required
    the right-side Alt key to be pressed, such as { and } on German
    keyboards, could not be typed in the Command window or the Do-file Editor.
    This has been fixed.

{p 5 9 2}
8.  (64-bit Windows) {helpb query memory} displayed an extra letter "{cmd:c}"
    when reporting memory sizes.  This has been fixed.


{hline 8} {hi:update 26jul2011} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 11(2).

{p 5 9 2}
2.  The {help whatsnew11##up19jul2011:19jul2011 Stata 11.2 update} items 2, 3,
    4, 6, 7, 11, 12, 13, 14, 15, 17, and 21 have now been applied to Stata 12.
    The other items from that update were applied to Stata 12 prior to its
    initial release.

{p 5 9 2}
3.  {helpb margins} with options {cmd:vce(unconditional)} and
    {opt noestimcheck} reported a "{err:varlist required}" error if a factor
    variable was also specified in one of the marginal effects options
    ({opt dydx()}, {opt dyex()}, {opt eydx()}, or {opt eyex()}).  This has
    been fixed.

{p 5 9 2}
4.  ({help statamp:Stata/MP}) {helpb mlmatbysum} produced wrong results if the
    global macro {cmd:$ML_w} was empty.  This has been fixed.

{p 5 9 2}
5.  {cmd:notes search} issued an r(111) error if the search string in question
    was not found in a note.  This has been fixed.

{p 5 9 2}
6.  The new {help sembuilder:SEM Builder} has enhancements and bug fixes, such
    as the following: settings affecting appearance are now remembered between
    Stata sessions (enhancement), and paths connecting error variables now join
    better with the containing circle (bug fix).

{p 9 9 2}
    The thirty-two enhancements/fixes are not enumerated here because they
    were made on the date of release.

{p 5 9 2}
7.  {helpb sem} has the following fixes:

{p 9 13 2}
    a.  {cmd:sem} would sometimes report structural equations out of the order
        in which they were specified.  This has been fixed.

{p 9 13 2}
    b.  {cmd:sem} with a {helpb svy} prefix or with options
        {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} failed to report the
        standardized model parameters when option {opt standardized} was
        specified.  This has been fixed.

{p 5 9 2}
8.  (Mac) In a tabbed Viewer window, dragging the last tab out of the window
    now destroys the empty window.  Previously, the empty window wasn't
    destroyed, which could cause problems when a new Viewer was created.

{p 5 9 2}
9.  (Mac) The Do-file Editor automatically saves backups of unsaved do-files.
    If Stata crashes, then the next time Stata is launched, the backup is
    automatically opened in the Do-file Editor.  Previously, if the backup was
    closed without saving changes, the backup would be opened every time Stata
    was launched.  This has been fixed; Stata now removes the backup file.

{p 4 9 2}
10.  (Unix) The Stata GUI issued GTK warnings if your dataset contained
     extended ASCII characters.  This has been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew11to12}.{p_end}

{hline}
