{smcl}
{* *! version 1.0.5  04feb2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 15}

{pstd}
This file records the additions and fixes made to Stata during the 15.0 and
15.1 releases:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {bf:this file}        Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {help whatsnew14}       Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
    {c |} {help whatsnew13to14}   Stata 14.0 new release       2015            {c |}
    {c |} {help whatsnew13}       Stata 13.0 and 13.1          2013 to 2015    {c |}
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
See {help whatsnew15to16}.


{hline 8} {hi:update 03feb2020} {hline}

{p 5 9 2}
1.  {helpb icd10cm} and {helpb icd10pcs} have been updated for the 2020 fiscal
    year.  Type {cmd:icd10cm query} or {cmd:icd10pcs query} to see information
    about the changes.

{p 5 9 2}
2.  {helpb eivreg} with a large number of observations could incorrectly
    exit with Mata memory error message "{err:unable to allocate} ...",
    r(3900).  This has been fixed.

{p 5 9 2}
3.  {helpb graph export}, when exporting to a PDF file from a graph that
    contained {helpb graph twoway line:twoway line} connected lines, in rare
    cases incorrectly exited with error message
    "{err:unable to save PDF file}".  This bug was partially fixed in the
    26aug2019 update and is now fully fixed.

{p 5 9 2}
4.  {helpb import dbase}, in the rare case where rows contained binary null
    data, incorrectly imported those rows, shifting the remaining data.  This
    has been fixed.

{p 5 9 2}
5.  {helpb levelsof} did not properly handle {bf:r()} results within an
    {bf:if} expression (they were treated as missing values).  This has been
    fixed.

{p 5 9 2}
6.  {helpb gmm_postestimation##predict:predict}, when called under version
    14.1 or older and using {helpb gmm} estimation results, incorrectly
    defaulted to option {cmd:xb} instead of option {cmd:residuals}.  This has
    been fixed.

{p 5 9 2}
7.  {helpb teffects_psmatch##options_table:teffects psmatch} and
    {helpb teffects_nnmatch##options_table:teffects nnmatch} with option
    {cmd:generate(}{it:stub}{cmd:)} crashed Stata if the number of new
    variables created exceeded the maximum number of variables permitted in
    Stata; see {helpb memory:set maxvar}.  This has been fixed.

{p 5 9 2}
8.  (Stata/MP) Mata function
    {helpb mf_quadcrossdev:quadcrossdev({it:X}, {it:x}, {it:Z}, {it:z})},
    when cols({it:X}) > 250 and cols({it:Z}) < cols({it:X}), could crash
    Stata.  This has been fixed.

{p 5 9 2}
9.  (Mac) A password edit field in a programmable dialog always returned an
    empty string regardless of what had been entered.  This has been fixed.

{p 4 9 2}
10.  (Unix GUI) The "Wrap lines" menu can be set globally or as a tab-specific
     setting.  When switching between tabs, the "Wrap lines" setting was not
     always honored.  This has been fixed.


{hline 8} {hi:update 26aug2019} {hline}

{p 5 9 2}
1.  {helpb bootstrap} with a user-defined command that used time-series
    operators produced incorrect standard errors.  More lagged observations
    than necessary were excluded from the bootstrap-replication samples.
    Under standard assumptions, the reported standard-error estimates were
    conservative.  This has been fixed.

{p 5 9 2}
2.  {helpb graph export}, after the 05 Aug 2019 update and when exporting to a
    PDF file from a graph that contained {helpb graph twoway line:twoway line}
    connected lines, in rare cases incorrectly exited with error message
    "{err:unable to save PDF file}".  This has been fixed.

{p 5 9 2}
3.  Mata function {helpb mf_st_vlexists:st_vlload()} caused Stata to crash
    when the second and third arguments passed to it were the same matrix.  It
    now issues an error message in this case.

{p 5 9 2}
4.  {helpb reshape} with large {it:stub} numbers (those rounded because of
    floating-point precision) produced a faulty dataset and displayed the note
    "note: ({it:variable} not found)".  This has been fixed.

{p 5 9 2}
5.  {helpb threshold_postestimation##predict:predict} after {helpb threshold}
    has the following fixes:

{p 9 13 2}
     a.  {cmd:predict} after {cmd:threshold} with option {cmd:consinvariant}
         incorrectly exited with an uninformative error.  This has been fixed.

{p 9 13 2}
     b.  {cmd:predict, dynamic()} after {cmd:threshold}, when only the
	 region-specific constant varied by region, produced predicted values
	 that omitted the constant term.  This has been fixed.

{p 9 13 2}
     c.  {cmd:predict, dynamic()} after {cmd:threshold} with lagged variables
	 produced the predicted values in periods before the period specified
	 in option {cmd:dynamic()} that were created as either the
	 contemporaneous realized values of the dependent variable or the
	 one-step-ahead realized values.  {cmd:predict} now always reports the
	 one-step-ahead predictions in those periods, as documented.

{p 9 13 2}
     d.  {cmd:predict, stdp} after {cmd:threshold} reported the variance (the
         square of the standard error) rather than the standard error.  This
         has been fixed.

{p 9 13 2}
     e.  {cmd:predict} after {cmd:threshold}, in the rare and degenerate case
         where the threshold model specified no thresholds (a model that could
         be fit using {helpb regress}), incorrectly exited with an
         uninformative error message.  This has been fixed.

{p 5 9 2}
6.  {helpb threshold}, when fit with missing values in the dependent variable
    or if the sample was restricted using {it:if} or {it:in}, recorded too
    many region-specific observations in {cmd:e(nobs)}.  This has been fixed.
    The regression results were unaffected.


{hline 8} {hi:update 05aug2019} {hline}

{p 5 9 2}
1.  {helpb javacall} has the following fixes:

{p 9 13 2}
     a.  {cmd:javacall} incorrectly parsed tokens for option {cmd:args()}
	 using delimiters designed for expressions (commas, dashes, etc).  Now
	 {cmd:args()} are parsed solely based on spaces.

{p 9 13 2}
     b.  {cmd:javacall} exited without executing when option {cmd:jars()} had
         trailing spaces after the last jar file specified.  This has been
         fixed.

{p 5 9 2}
2.  {helpb marginsplot} has improved logic for detecting not-estimable
    margins.  Prior to this change, in the rare case when {cmd:margins}
    reported a nonmissing margin estimate with the note {cmd:(omitted)} or
    {cmd:(empty)}, {cmd:marginsplot} would not plot the reported estimate.

{p 5 9 2}
3.  {helpb meglm}, {helpb mecloglog}, {helpb meintreg}, {helpb melogit},
    {helpb menbreg}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb metobit}, and {helpb mestreg}, when specified with large
    {cmd:fweight}s, underreported the number of groups and group sizes.  The
    rest of the output was unaffected.  This has been fixed.

{p 5 9 2}
4.  {helpb merge}, when a key variable in the master dataset was a
    {helpb data_types:strL}, produced an uninformative error message.  It now
    indicates that {cmd:strL} types are not allowed as a key variable.

{p 5 9 2}
5.  {helpb odbc load} with option {opt allstring} imported Unicode columns
    as ISO Latin-1 columns.  This has been fixed.

{p 5 9 2}
6.  {helpb putexcel} with option {cmd:etable()}, when exporting two tables
    after {helpb margins}, inserted too many blank lines between the two
    tables.  This has been fixed.

{p 5 9 2}
7.  {helpb putmata}, when creating a named matrix with {it:varlist} specified
    as {cmd:*} or {cmd:_all}, added an extra column of 1s at the end of the
    matrix.  This has been fixed.

{p 5 9 2}
8.  {helpb pwcompare} with option {cmd:groups} and
    {helpb margins_pwcompare:margins, pwcompare(groups)}, when specified with
    terms having more than three levels and unequal standard errors, on rare
    occasions failed to identify all the groups.  This has been fixed.

{p 5 9 2}
9.  {helpb sem_command:sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem} with options {cmd:group()} and {cmd:constraints()} exited
         with an unhelpful error message, even when specified correctly.  This
         has been fixed.

{p 9 13 2}
     b.  {cmd:sem} specified with multiple latent variables, each with a
         single path to the same observed endogenous variable and with no
         other paths, exited with an unhelpful error message.  This has been
         fixed.  Note that such specifications require more than the default
         identifying constraints.

{p 4 9 2}
10.  When {helpb set emptycells:set emptycells drop} was in effect, Stata
     incorrectly dropped a single-factor noninteraction term if it did not
     contain a nonempty omitted level.  This has been fixed.

{p 4 9 2}
11.  Mata's {helpb mf_st_view:st_view()}, when specified with {it:varlist}
     with time-series operators applied to one or more variables bound by
     parentheses, failed to apply the time-series operators to the bound
     variables.  This has been fixed.

{p 4 9 2}
12.  {helpb suest} now exits with error message
     "{err:svy {it:method} not supported by suest}" when given estimation
     results where {it:method} is {helpb svy_bootstrap:bootstrap},
     {helpb svy_brr:brr}, {helpb svy_jackknife:jackknife}, or
     {helpb svy_sdr:sdr}.  Prior to this change, {cmd:suest} reported standard
     errors that were calculated using linearized variance estimates based on
     the {helpb svyset} design characteristics, ignoring option {cmd:vce()}.
     The old behavior is not preserved under version control.

{p 4 9 2}
13.  {helpb syntax} with specification {cmd:newvarlist}, when called multiple
     times, could leave behind multiple {cmd:typlist} local macros.  This has
     been fixed.

{p 4 9 2}
14.  {helpb graph twoway line:twoway line} connected lines are now rendered as
     a single path instead of a series of separate lines.  This improves the
     visual appearance of connected lines with transparencies.

{p 4 9 2}
15.  {helpb use:use {it:varlist} using {it:filename}} in rare cases crashed
     Stata or created an improperly sorted dataset.  This has been fixed.

{p 9 9 2}
     For this problem to happen, the dataset in {it:filename} needed to be
     sorted by one or more variables and {it:varlist} must have contained
     one or more of the first variables from the sorted variable list in
     {it:filename}.  For example, if the sorted list from {it:filename} is
     {cmd:x1}, {cmd:x2}, {cmd:x3}, and you typed one of

		{cmd:use x1 using} {it:filename}
                {cmd:use x1 x2 using} {it:filename}
                {cmd:use x1 x2 x3 using} {it:filename}

{p 9 9 2}
     an improper dataset could be created where the sorted list contained
     junk.  This could cause a crash.  In the rare case where "junk" looked
     like a variable name and you subsequently generated a variable of that
     name but it was not sorted, your dataset was now improperly sorted.

{p 9 9 2}
     Note that if you typed anything else, such as

		{cmd:use x2 using} {it:filename}
		{cmd:use x1 x2 z using} {it:filename}

{p 9 9 2}
     the problem would not arise.  That is, if {it:varlist} contained
     variables that were not included in the sort list or if {it:varlist}
     contained any of the last variables in the sort list without the first
     variables, the problem would not arise.  Additionally, if you had
     performed any operation that would naturally change the sort list, the
     data in memory no longer exhibited the problem.

{p 4 9 2}
16.  (Mac) When exporting a graph to a bitmap format with a user-specified
     width or height on a Mac with a Retina display, the exported image would
     be twice the size as what was requested.  This has been fixed.


{hline 8} {hi:update 02jul2019} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 19(2).

{p 5 9 2}
2.  {helpb bayes_mlogit:bayes: mlogit}, when labels of the outcome variable
    contained white space, did not recognize the base outcome level and
    exited with a Mata error message.  This has been fixed.

{p 5 9 2}
3.  {helpb bayesmh} and {helpb bayesstats summary}, both with option
    {cmd:batch()}, incorrectly reported batch standard deviation instead of
    the usual standard deviation.  This has been fixed.

{p 5 9 2}
4.  {helpb binreg} has the following fixes:

{p 9 13 2}
     a.  {cmd:binreg} with option {cmd:iter(0)} incorrectly exited with an
         uninformative error message instead of calculating the deviance
         without iterating.  This has been fixed.

{p 9 13 2}
     b.  {cmd:binreg}, when maximization options {cmd:search} and {cmd:from()}
	 were specified without option {cmd:ml}, did not exit with an error
	 message.  This has been fixed.

{p 5 9 2}
5.  {helpb eivreg} has the following fixes:

{p 9 13 2}
     a.  {cmd:eivreg} used the wrong formula to compute standard errors,
         resulting in standard errors that were too small.  This has been
         fixed.

{p 9 13 2}
     b.  {cmd:eivreg} postestimation commands {cmd:forecast}, {cmd:linktest},
         and {cmd:predictnl} are no longer available after {cmd:eivreg}.

{p 9 13 2}
     c.  {cmd:predict} after {cmd:eivreg} no longer allows options
         {cmd:residuals}, {cmd:stdp}, {cmd:stdf}, {cmd:pr()}, {cmd:e()}, or
         {cmd:ystar()}.

{p 9 13 2}
     d.  {cmd:margins} after {cmd:eivreg} no longer allows option
         {opt predict(statistic)} for the following {it:statistics}:
         {cmd:residuals}, {cmd:stdp}, {cmd:stdf}, {cmd:pr()}, {cmd:e()}, or
         {cmd:ystar()}.

{p 5 9 2}
6.  {helpb fmm} with {helpb set emptycells:set emptycells drop} in effect
    exited with an unhelpful error message, even when the model was specified
    correctly.  This has been fixed.

{p 5 9 2}
7.  {helpb glm} has the following fixes:

{p 9 13 2}
     a.  {cmd:glm} with options {cmd:irls} and {cmd:iter(0)} and any
         combination of options {cmd:family()} and {cmd:link()} except
         {cmd:family(gaussian)} with {cmd:link(identity)} incorrectly exited
         with an uninformative error message instead of calculating the
         deviance without iterating.  This has been fixed.

{p 9 13 2}
     b.  {cmd:glm}, when maximization options {cmd:search} and {cmd:from()}
	 were specified with option {cmd:irls}, did not exit with an error
	 message.  This has been fixed.

{p 5 9 2}
8.  {helpb import delimited}, when option {cmd:case()} was not specified or
    when {cmd:case(lower)} was specified, and when variable names in the file
    to be imported were Stata reserved words (for example, {cmd:if} or
    {cmd:in}) also containing capital letters (for example, {cmd:If} or
    {cmd:IN}), failed with an uninformative error message.  This has been
    fixed.

{p 5 9 2}
9.  {helpb import fred} exited with error message "{err:I/O error}" when the
    FRED server returned an HTTP error code 429 (too many requests).  This
    occurs when the number of requests to the FRED server exceeds limits
    imposed by FRED.  Now Stata reports the note
    {cmd:"Too many requests reported by FRED server; please wait."} and then
    proceeds to wait for a short time before automatically trying the request
    again.

{p 4 9 2}
10.  {helpb ir} and {helpb stir}, both with option {cmd:ird}, ignored options
     {cmd:estandard}, {cmd:istandard}, and {cmd:standard()}.  An error message
     is now produced.

{p 4 9 2}
11.  {helpb irt}, when an item variable contained all missing values, exited
     with a noninformative error message.  {cmd:irt} now exits with error
     message "{err:item ... contains only missing values}".

{p 4 9 2}
12.  {helpb lincom} unintentionally left behind matrix {cmd:rtable} in memory.
     This has been fixed.

{p 4 9 2}
13.  {helpb menl}, when fitting a linear mixed-effect model containing factor
     variables with more than two levels, ignored the base specification,
     thereby producing an overparameterized model.  This has been fixed.

{p 4 9 2}
14.  {helpb mi estimate} has the following fixes:

{p 9 13 2}
     a.  {cmd:mi estimate} with estimation command {helpb clogit} would not
         display notes about multiple positive outcomes within groups or how
         many groups were dropped during estimation.  Now the appropriate
         notes are displayed.

{p 9 13 2}
     b.  {cmd:mi estimate} with option {cmd:cmdok} and estimation command
         {helpb mestreg} incorrectly exited with error message
         "{err:command prefix mestreg <cmdline> not allowed}".  Now
         {cmd:mi estimate, cmdok: mestreg} executes without error.

{p 9 13 2}
     c.  {cmd:mi estimate}, when {it:estimation_command} contained an {it:if}
         expression with a single bar, "{cmd:|}", inside parentheses,
         ({it:ifexp1}{cmd:|}{it:ifexp2}), exited with a syntax error message.
         This has been fixed.

{p 4 9 2}
15.  {helpb mi impute chained} has the following fixes:

{p 9 13 2}
     a.  {cmd:mi impute chained} with functions of imputed variables did not
         generate these variables in double precision.  This could affect the
         precision of imputed values when, for example, the original imputed
         variable involved in a function was an integer and the regression
         imputation method was used to impute it.  This has been fixed.

{p 9 13 2}
     b.  {cmd:mi impute chained}, when the expression in option {cmd:include()}
         contained the same operation sign multiple times, such as
         {cmd:include(x1 + x2 + x3)}, produced an uninformative error message.
         This has been fixed.

{p 9 13 2}
     c.  {cmd:mi impute chained} with option {cmd:savetrace()}, when there
	 were multiple imputed variables with the same prefix names, produced
	 an uninformative error message.  This has been fixed.

{p 4 9 2}
16.  {helpb pkequiv} has the following improvement and fixes:

{p 9 13 2}
     a.  {cmd:pkequiv} with option {cmd:limit()} accepted equivalence
         limits only from 0.1 to 0.99, inclusive.  Now it accepts equivalence
         limits from 0.01 to 0.99, inclusive.

{p 9 13 2}
     b.  {cmd:pkequiv}, with unbalanced data (different numbers of subjects in
         each sequence) or missing values in any variable, produced incorrect
         results (it used the formulas for balanced data).  {cmd:pkequiv} now
         properly accounts for unbalanced data in the computation.

{p 9 13 2}
     c.  {cmd:pkequiv} did not respect {cmd:if} {it:exp} or {cmd:in}
         {it:range}.  This has been fixed.

{p 9 13 2}
     d.  {cmd:pkequiv}, when some {it:id}s did not receive both
         {it:treatment}s, miscalculated the degrees of freedom, resulting in
         confidence intervals that were slightly too narrow.  This has been
         fixed.

{p 9 13 2}
     e.  {cmd:pkequiv} with option {cmd:tost} miscalculated p-values for the
         two one-sided tests (TOST), reporting p-values that were twice as
         large as they should have been.  This has been fixed.

{p 9 13 2}
     f.  {cmd:pkequiv} with option {cmd:tost} or {cmd:anderson} and with
         option {cmd:limit()} ignored the specified limits when computing the
         TOST or Anderson and Hauck test.  It incorrectly used the default
         equivalence limit of 0.2.  This has been fixed.

{p 9 13 2}
     g.  {cmd:pkequiv} without options {cmd:noboot}, {cmd:symmetric}, or
         {cmd:fieller} used an unstratified bootstrap to calculate the
         probability that the confidence interval would lie within the
         equivalence limits if the experiment were repeated.  This has
         been corrected to stratify the bootstrap samples on the sequence in
         which treatments were received.

{p 9 13 2}
     h.  {cmd:pkequiv}, when the {it:treatment} variable took values other
         than 1 and 2, produced incorrect results.  This has been fixed.

{p 9 13 2}
     i.  {cmd:pkequiv} with option {cmd:compare()}, with any value of
         {cmd:compare()} except {opt compare(1 2)}, produced incorrect
         results.  This has been fixed.

{p 9 13 2}
     j.  {cmd:pkequiv} with option {cmd:fieller} miscalculated the confidence
         interval and mislabeled it as equivalence limits, which were not
         reported.  It now correctly reports the equivalence limits and
         confidence interval for the ratio.

{p 9 13 2}
     k.  {cmd:pkequiv} with option {cmd:symmetric} mislabeled the confidence
         interval for the test formulation as equivalence limits, which were
         not reported.  It now correctly reports the equivalence limits and
         confidence interval for the difference in means.

{p 9 13 2}
     l.  {cmd:pkequiv} without options {cmd:fieller} or {cmd:symmetric}
         displayed the confidence interval for the difference in means under
         the heading "test limits".  It now uses the heading "confidence
         interval".

{p 9 13 2}
     m.  {cmd:pkequiv} with options {cmd:fieller} or {cmd:symmetric}, when the
         sequence variable contained an odd number of observations with
         sequence equal to 1 or 2, incorrectly exited with error message
         "{err:option df() incorrectly specified}".  This has been fixed and
         no longer causes an error.

{p 4 9 2}
17.  {helpb pkshape} has the following improvements and fixes:

{p 9 13 2}
     a.  {cmd:pkshape} now creates variable labels for the new variables
         created.

{p 9 13 2}
     b.  {cmd:pkshape} now uses the information about treatments provided by
         users to label values of the sequence, treatment, and carryover
         variables.

{p 9 13 2}
     c.  {cmd:pkshape} now supports Unicode characters in variable names and
         treatment labels.

{p 9 13 2}
     d.  {cmd:pkshape}, when more than nine treatments were used, produced
	 incorrect results.  In those cases, {cmd:pkshape} would mislabel one
	 or more treatments, which would lead to incorrect results.  This has
	 been fixed.

{p 9 13 2}
     e.  {cmd:pkshape}, when numbers 1-9 were used as treatment codes, would
	 produce erroneous treatment and carryover values. This has been
	 fixed.

{p 9 13 2}
     f.  {cmd:pkshape} with option {cmd:order()} and a string input sequence
	 variable did not produce an error message as it should have and
	 ignored the treatment sequence provided by the input sequence
	 variable.  This could produce incorrect treatment assignments when
	 the specified ordering in {cmd:order()} was not alphabetical.
	 {cmd:pkshape} now produces an error message in this case.

{p 9 13 2}
     g.  {cmd:pkshape} exited with an error message without preserving the
	 original data when any of the following variables existed and the
	 corresponding option was not specified with a new variable name:
	 variable {it:outcome} and option {cmd:outcome()}, variable {it:treat}
	 and option {cmd:treatment()}, variable {it:carry} and option
	 {cmd:carryover()}, variable {it:sequence} and option
	 {cmd:sequence()}, and variable {it:period} and option {cmd:period()}.
	 Now data are preserved.

{p 9 13 2}
     h.  {cmd:pkshape} now saves outcome variables as type "double" if the
         input variables were saved as type "double".

{p 9 13 2}
     i.  {cmd:pkshape}, when period variables except the first two contained
	 nonnumeric values, exited with a misleading error message.  It now
	 produces an appropriate error message.

{p 9 13 2}
     j.  {cmd:pkshape}, when replicate combinations of {it:id} and
	 {it:sequence} were found, exited with a misleading error message.
	 It now produces an appropriate error message.

{p 4 9 2}
18.  {helpb menl_postestimation##predict:predict} after {helpb menl}, when
     specified with a linear combination containing an interaction between a
     continuous variable and factor variable, produced an uninformative error
     message.  This has been fixed.

{p 4 9 2}
19.  {helpb qreg} with prefix {helpb by} ran the model {it:k} x {it:k} times
     instead of {it:k} times, where {it:k} is the number of by-groups.  This
     has been fixed.

{p 4 9 2}
20.  {helpb stir} without option {cmd:strata()} produced error message
     "{err:missing by() option}" when any of the following options were
     specified: {cmd:ird}, {cmd:estandard}, {cmd:istandard}, {cmd:standard()},
     {cmd:pool}, {cmd:nocrude}, and {cmd:nohom}.  It now produces error
     message "{err:missing strata() option}".


{hline 8} {hi:update 21mar2019} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 19(1).

{p 5 9 2}
2.  {helpb asclogit} with option {cmd:vce(cluster} {it:clustvar}{cmd:)} using
    a string {it:clustvar} variable, when the case variable was not nested in
    clusters, incorrectly reported results instead of producing an error
    message.  This has been fixed.

{p 5 9 2}
3.  {helpb churdle} with frequency weights reported the wrong number of
    observations.  This has been fixed.  The reported coefficients, test
    statistics, and confidence intervals were correct.

{p 5 9 2}
4.  {helpb compare}, in cases with extreme double-precision values outside the
    range of float precision (such as {cmd:c(mindouble)} or
    {cmd:c(maxdouble)}), could show missing values in the output table.  This
    has been fixed.

{p 5 9 2}
5.  {helpb me estat sd:estat sd} after {helpb mixed} now allows option
    {opt coeflegend} when option {opt post} is also specified.
    {opt coeflegend} requests that {cmd:estat sd} display a legend that
    identifies how posted coefficients, standard deviations, and correlations
    should be specified in expressions.

{p 5 9 2}
6.  {helpb me estat sd:estat sd} after {helpb meglm},
    {helpb melogit}, {helpb meprobit}, {helpb meologit}, {helpb meoprobit},
    {helpb mepoisson}, {helpb menbreg}, {helpb meqrlogit}, and
    {helpb meqrpoisson} no longer allows option {opt coeflegend} unless option
    {opt post} is also specified.  The old behavior is not preserved under
    version control.

{p 5 9 2}
7.  After the 20feb2019 update, {helpb estimates table} specified with results
    containing two-part named free parameters, such as {cmd:/mills:lambda} of
    {helpb heckman:heckman, twostep}, exited with error message
    {err:/mills not found}.  This has been fixed.

{p 5 9 2}
8.  {helpb nlogit} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, when
    the case variable was not nested in clusters, incorrectly reported results
    instead of producing an error message. This has been fixed.


{hline 8} {hi:update 20feb2019} {hline}

{p 5 9 2}
1.  Functions {helpb tin()} and {helpb twithin()} now support dates in
    business calendar ({cmd:%tb}) format.

{p 5 9 2}
2.  {helpb describe} now stores the dataset label in {cmd:r(datalabel)}.

{p 5 9 2}
3.  {helpb areg} specified with a factor variable having a single chosen
    level, when that factor level was not observed in one or more of the
    absorption groups and the model contained subsequent interaction terms
    containing a continuous variable, produced incorrect coefficients and
    standard errors.  This has been fixed.

{p 5 9 2}
4.  {helpb ereturn post} and {helpb ereturn repost} with option
    {cmd:esample()} failed to update variable indices in the existing Mata
    views.  For Mata views that were created using variables with an index
    greater than that of the variable specified in option {cmd:esample()},
    those columns were referencing variables with a higher index than they
    should have.  This has been fixed.

{p 5 9 2}
5.  {helpb fracreg} with frequency weights reported the wrong number of
    observations.  This has been fixed.  The reported coefficients, standard
    errors, test statistics, and confidence intervals were correct.

{p 5 9 2}
6.  {helpb gsem_command:gsem} no longer requires option {cmd:nocapslatent}
    when option {cmd:lclass()} is specified and any of the observed variable
    names in the model begins with a capital letter.

{p 5 9 2}
7.  {helpb svy}{cmd::} {helpb gsem_command:gsem}, when {helpb svyset}
    weights contained zero values, sometimes exited with an unhelpful error
    message.  {cmd:svy} now properly marks the estimation sample for
    {cmd:gsem} in this case.

{p 5 9 2}
8.  {helpb gsem_command:gsem} now exits with an informative error message when
    factor-variable operators are specified on a latent variable not
    identified in option {opt lclass()}.  The old behavior, where {cmd:gsem}
    ignored factor-variable operators specified on latent variables not
    identified in option {opt lclass()}, is not preserved under version
    control.

{p 5 9 2}
9.  After the 15 Oct 2018 update, {helpb import excel}, when importing an
    {cmd:.xlsx} file that was already open in Excel, exited with an
    uninformative error message.  This has been fixed.

{p 4 9 2}
10.  {helpb makecns} now allows the number of constraints to be equal to the
     number of parameters.  This affects estimation commands such as
     {helpb cnsreg} and any estimation command that uses {helpb ml}.

{p 4 9 2}
11.  Mata functions {helpb mf_fopen:fputmatrix()} and
     {helpb mf_fopen:fgetmatrix()} were unable to save Mata structure matrices
     and vectors.  This has been fixed.

{p 4 9 2}
12.  Mata function {helpb mf_regexr:regexr()}, when a) the regular expression
     to match was a single byte, b) the match occurred at the end of the
     source string, and c) the replacement string was length 0 or 1, failed to
     replace the matching substring.

{p 9 9 2}
     For example,

		{cmd:mata: regexr("ABCDa","a","")}
		{cmd:mata: regexr("ABCDa","a","c")}

{p 9 9 2}
     both wrongly returned {cmd:"ABCDa"} instead of {cmd:"ABCD"} and
     {cmd:"ABCDc"}.  This has been fixed.

{p 4 9 2}
13.  {helpb ml}, when fitting a model with option {cmd:svy} and survey weights
     were not {helpb svyset}, posted the name of a temporary variable in
     macros {cmd:e(wvar)} and {cmd:e(wexp)}.  This has been fixed.

{p 4 9 2}
14.  {helpb predict}, when specified with a new variable name that matches a
     variable in the current estimation results, now exits with an error
     message even when that variable does not exist in the current dataset.
     The old behavior, which provided invalid predicted values, is not
     preserved under version control.

{p 4 9 2}
15.  {helpb asmixlogit_postestimation##predict:predict} after
     {helpb asmixlogit}, when specified with option {cmd:scores} and a
     specified variable type, retained the specified variable type for only
     the first score variable.  This has been fixed.

{p 4 9 2}
16.  {helpb asmixlogit_postestimation##predict:predict} after
     {helpb asmixlogit} and with option {cmd:scores}, when {cmd:asmixlogit}
     was specified with a full-factorial interaction among variables with
     fixed coefficients and was specified with option
     {cmd:random(}{it:varlist}{cmd:, correlated)} where {it:varlist} consisted
     of only a single variable, produced scores that were incorrectly set to
     0.  This has been fixed.

{p 4 9 2}
17.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem}, when
     specified with option {opt classposteriorpr} and when the fitted model
     contained two or more multinomial outcomes with missing-value patterns
     that would cause one or more observations to be dropped from the
     estimation sample, exited with an unhelpful error message.  This has been
     fixed.

{p 4 9 2}
18.  {cmd:predict} after {helpb ologit_postestimation##predict:ologit} and
     {helpb oprobit_postestimation##predict:oprobit} ignored option
     {cmd:nooffset}.  This has been fixed.

{p 4 9 2}
19.  {cmd:predict} after {helpb ologit_postestimation##predict:ologit} and
     {helpb oprobit_postestimation##predict:oprobit}, when specified with
     option {cmd:scores}, failed to exit with an error message when option
     {cmd:nooffset} was specified.  This has been fixed.

{p 4 9 2}
20.  {helpb sem_command:sem} now exits with an informative error message when
     factor-variable operators are specified on a latent variable.  The old
     behavior, where {cmd:sem} ignored factor-variable operators specified on
     latent variables, is not preserved under version control.

{p 4 9 2}
21.  {helpb sem_command:sem} with observed exogenous variables and two or
     more latent exogenous variables sometimes had difficulty fitting an
     otherwise-identified model depending on the order of the specified paths.
     This has been fixed.

{p 4 9 2}
22.  The {help sembuilder:SEM Builder} has the following fixes:

{p 9 13 2}
     a.  The SEM Builder, when the standard error was included in the
         customized appearance for a selected connection, would report the
         standardized estimate instead of the standard error estimate.  This
         has been fixed.

{p 9 13 2}
     b.  The SEM Builder, when attempting to change a path's arrow size,
         resulted in no change.  This has been fixed.

{p 9 13 2}
     c.  The SEM Builder, when changing a path's arrow barb size to 0,
         resulted in the arrow being replaced by a line that ran off the
         canvas.  This has been fixed.

{p 4 9 2}
23.  {helpb svy}{cmd::} {helpb total}, for data with a stratum having a single
     sampling unit and data that have been {helpb svyset} with option
     {cmd:singleunit(centered)}, now centers using the average of the stratum
     totals for a given stage instead of using the grand mean.  The old
     behavior produced standard errors that were too large and is not
     preserved under version control.

{p 4 9 2}
24.  {helpb teffects nnmatch} using both exact and distance matching ignored
     the specified caliper for the distance matching.  This has been fixed.

{p 4 9 2}
25.  Stata now creates random names for SVG path elements when exporting
     graphs to the SVG format.  When an HTML document contains multiple Stata
     SVG graphs that share common SVG path names, a browser can have trouble
     rendering the SVG graphs; randomizing the path names helps prevent
     that.  If you would like control over how the SVG path names are
     generated, specify option {cmd:pathprefix()} when exporting the
     graph.  Stata will use your path prefix and an index that is incremented
     for each path to create stable path names.  See
     {manhelpi svg_options G-3} for more information.


{hline 8} {hi:update 17dec2018} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 18(4).

{p 5 9 2}
2.  {helpb churdle} has the following fixes:

{p 9 13 2}
     a.  {cmd:churdle}, when specified with prefix {helpb svy} and weights
         with missing values, incorrectly exited with an error message. Now,
         point estimates are produced.

{p 9 13 2}
     b.  {cmd:churdle}, when specified with prefix {helpb svy}, produced
	 incorrect standard errors for the auxiliary parameter.  This affected
	 only models where heteroskedasticity was not modeled.  This has been
	 fixed.

{p 5 9 2}
3.  {helpb cpoisson}, when constraints were specified and initial values were
    not feasible, incorrectly exited with an uninformative error message.
    This has been fixed.

{p 5 9 2}
4.  {helpb ereturn display}, when specified with results from {helpb mean} and
    {helpb total}, ignored option {cmd:eform()} instead of reporting the
    estimated parameters in exponentiated form.  This has been fixed.

{p 5 9 2}
5.  {helpb estat sbknown}, when estimated on one panel of a multiple-panel
    dataset, exited with an uninformative error message.  This has been fixed.

{p 5 9 2}
6.  {helpb histogram}, when specified with an {cmd:if} expression or {cmd:in}
    range, incorrectly applied these sample restrictions to additional plots
    specified in option {cmd:addplot()}.  This has been fixed.

{p 9 9 2}
    However, when option {cmd:by()} is also specified, the {cmd:if}
    expression or {cmd:in} range sample restrictions will be applied to
    additional plots specified in option {cmd:addplot()}.  In other words,
    {cmd:histogram}'s behavior has not changed when option {cmd:by()} is
    specified.

{p 5 9 2}
7.  {helpb mestreg} did not check for the presence of delayed entries or gaps.
    {cmd:mestreg} now returns error message
    "{err:delayed entries or gaps not allowed}".

{p 5 9 2}
8.  {helpb gsem_predict:predict} with option {cmd:pr} after
    {helpb gsem_command:gsem}, {helpb meologit}, {helpb meoprobit},
    {helpb xtologit}, and {helpb xtoprobit} did not allow you to predict
    probabilities for negative ordinal outcomes.  This has been fixed.

{p 5 9 2}
9.  {helpb tpoisson_postestimation##predict:predict} with option {cmd:scores}
    after {helpb tpoisson}, which was not left-truncated at zero, produced
    incorrect scores.  This has been fixed.

{p 4 9 2}
10.  {helpb stteffects ipwra} with survival-time outcome model {cmd:weibull},
     {cmd:exponential}, or {cmd:lnormal} sometimes failed to converge.
     Convergence has been improved.


{hline 8} {hi:update 15oct2018} {hline}

{p 5 9 2}
1.  {helpb icd10cm} and {helpb icd10pcs} have been updated for the 2019 fiscal
    year.  Type {cmd:icd10cm query} or {cmd:icd10pcs query} to see information
    about the changes.

{p 5 9 2}
2.  {helpb areg}, when specified with factor variables and weights, sometimes
    failed to omit a factor level that was constant within the {cmd:absorb()}
    variable.  When this happened, the standard error for the coefficient on
    the associated factor level was typically astronomical compared with the
    other standard error estimates.  This has been fixed.

{p 5 9 2}
3.  {helpb estat lcmean} and {helpb estat lcprob}, when {helpb fmm} or
    {helpb gsem_command:gsem} fit a model with a {cmd:pointmass} outcome in
    the base level of the latent class, incorrectly exited with error message
    "{error}prediction is a function of possibly stochastic quantities other
    than e(b){reset}".  This has been fixed.

{p 5 9 2}
4.  {helpb estimates table}, when {helpb set emptycells:set emptycells drop}
    was in effect and an interaction term was specified in option {cmd:keep()}
    or option {cmd:drop()}, exited with error message "{err:invalid syntax}".
    This has been fixed.

{p 5 9 2}
5.  {helpb import fred:fredsearch} with option {cmd:tags()}, when the number
    of tags specified was greater than 5, returned an uninformative error
    message.  {cmd:fredsearch} now returns error message
    "{err:at most 5 tags can be specified in option tags()}".

{p 5 9 2}
6.  When {help graph_export:exporting a graph} to EPS or PDF format, Stata now
    hides lines with a line width of {cmd:none} or {cmd:0}.

{p 5 9 2}
7.  {helpb gsem_command:gsem}, when specified with a truncated Poisson
    outcome, sometimes caused Stata/MP to crash.  This has been fixed.

{p 5 9 2}
8.  The 02 April 2018 update caused {helpb import excel} with option
    {cmd:sheetreplace} to remove all workbook cell ranges.  This has been
    fixed.

{p 5 9 2}
9.  {helpb logit}, when fitting a model where a large number of the levels
    of a factor variable are perfect predictors and when
    {helpb set emptycells:set emptycells drop} is in effect, could cause Stata
    to crash.  This has been fixed.

{p 4 9 2}
10.  {helpb margins} after {helpb npregress} with option {cmd:noderivatives}
     always used default kernels {cmd:epanechnikov} and {cmd:racine} even
     if the user specified another kernel during estimation.  This has been
     fixed.

{p 4 9 2}
11.  {helpb margins} after {helpb npregress} with option {cmd:noderivatives},
     when {cmd:margins} was called more than once, removed the auxiliary
     variable used to store the mean function prediction.  This has been
     fixed.  Marginal effects and predictions were not affected by this
     issue.

{p 4 9 2}
12.  {helpb marginsplot} failed to plot margins values larger than
     {cmd:c(maxfloat)}.  This has been fixed.

{p 4 9 2}
13.  As of Stata 15, matrix subscripting did not recognize {cmd:/:} as a
     shortcut for retrieving all the free parameters from the specified
     matrix.  This problem was noticed when running community-contributed
     command {cmd:esttab} with option {cmd:unstack}.  This has been fixed.

{p 4 9 2}
14.  {helpb mixed}, {helpb meqrlogit}, and {helpb meqrpoisson} now store the
     number of iterations in {cmd:e(ic)}.

{p 4 9 2}
15.  {helpb ml display}, when working with estimation results containing
     free-parameter notation in the column stripe of {cmd:e(b)}, now
     interprets each of those free parameters as a separate equation when
     counting how many parameters to exponentiate when an {it:eform_option} is
     specified.  The old behavior, grouping the elements with free-parameter
     notation into a single equation, is not preserved.

{p 4 9 2}
16.  {helpb mleval}, {helpb mlvecsum}, {helpb mlmatsum}, and
     {helpb mlmatbysum} exited with error message
     "{err:equation 1000 out of range}" for estimation commands that specified
     more than 999 equations.  This restriction has been removed.  Now the
     number of equations allowed by these estimation commands is only limited
     by {helpb set matsize}.

{p 4 9 2}
17.  {helpb program} lines containing multiple adjacent spaces enclosed by
     {help quotes##double:compound double quotes}, {cmd:`""'}, would have
     those spaces compressed to a single space.  This has been fixed.

{p 4 9 2}
18.  {helpb stcoxkm}, which is not an estimation command, incorrectly modified
     existing stored estimation results or incorrectly created new estimation
     results when there were none.  This has been fixed.

{p 4 9 2}
19.  Stata would crash at the end of the following sequence of events:
{p_end}
{p 13 16 2}
        a. Create a Mata view from a varlist with time-series operators
           or factor variables.
{p_end}
{p 13 16 2}
        b. Call {helpb discard}.
{p_end}
{p 13 16 2}
        c. Run an estimation command that posts {cmd:e(sample)}.
{p_end}
{p 13 16 2}
        d. Create a new Mata view.
{p_end}
{p 9 9 2}
    This has been fixed.

{p 4 9 2}
20.  (Linux) {helpb creturn:c(username)} could return a truncated copy of the
     user ID from the operating system.  The truncation would occur after 8
     characters or after a nonalphanumeric character.  This has been fixed.


{hline 8} {hi:update 20sep2018} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 18(3).

{p 5 9 2}
2.  {helpb bootstrap}, when used with panel-data commands and variables having
    time-series operators, produced incorrect standard errors.  More lagged
    observations than necessary were excluded from the bootstrap replication
    samples.  Under standard assumptions, the reported standard-error
    estimates were conservative.  Stata's {help xt} estimation commands that
    allow both time-series operators and the {helpb vce_option:vce(bootstrap)}
    option were also affected.  This has been fixed.

{p 5 9 2}
3.  {helpb levelsof}, when used with {cmd:strL} variables and with only one
    observation in the dataset, produced an error message.  This has been
    fixed.

{p 5 9 2}
4.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins}, after fitting a model with an offset, when options
	 {cmd:expression()} and {cmd:at()} were both specified, in rare cases
	 computed margins from the expression using only the first observation
	 instead of the entire estimation sample.  Specifically, only the
	 first observation was used when the expression included more than a
	 single prediction, the prediction relied on the offset, and each
	 variable included in option {cmd:at()} was set to a constant value.
	 This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} with option {cmd:nose}, option {cmd:dydx()}, and
	 multiple {cmd:predict()} options reported marginal effects using
	 only the first {cmd:predict()} option instead of computing the
	 marginal effect for all specified predictions.  This has been
	 fixed.

{p 5 9 2}
5.  {helpb mixed} with option {cmd:dfmethod(kroger)} or option
    {cmd:dfmethod(satterthwaite)}, when group identifiers were string
    variables, exited with an uninformative error message.  This has been
    fixed.

{p 5 9 2}
6.  {helpb menl postestimation##predict:predict} after {helpb menl} now
    estimates predictions for observations with a missing dependent variable.

{p 5 9 2}
7.  Beginning with the 07 August 2018 update, {helpb reshape wide} with option
    {cmd:string} and option {opt j(varname)}, where {it:varname} was a string
    variable containing spaces, did not correctly identify unique values of
    {it:varname} if the characters before the first space were identical for
    two or more categories of {it:varname}.  {cmd:reshape wide} now exits with
    an error message indicating that string {cmd:j} variables are not allowed
    to contain spaces.

{p 9 9 2}
    To use a string variable that contains spaces with {cmd:reshape wide}, you
    can first create a corresponding numeric variable using {helpb encode} and
    then specify the resulting variable in {cmd:reshape}'s option {opt j()}.


{hline 8} {hi:update 07aug2018} {hline}

{p 5 9 2}
1.  The following new functions are added to Stata and Mata:

{p 9 13 2}
     a.  {helpb expm1():expm1({it:x})} returns e^{it:x} - 1 with higher
         precision than {helpb exp():exp({it:x})}-1 for small values of
         |{it:x}|.

{p 9 13 2}
     b.  {helpb ln1p():ln1p({it:x})} and {helpb log1p():log1p({it:x})} return
         the natural logarithm of 1+{it:x} with higher precision than
         {helpb ln():ln(1+{it:x})} for small values of |{it:x}|.

{p 9 13 2}
     c.  {helpb ln1m():ln1m({it:x})} and {helpb log1m():log1m({it:x})} return
         the natural logarithm of 1-{it:x} with higher precision than
         {helpb ln():ln(1-{it:x})} for small values of |{it:x}|.

{p 5 9 2}
2.  {helpb export excel} has new option {cmd:keepcellfmt} that preserves the
    cell style and format of an existing worksheet when writing data.

{p 5 9 2}
3.  {helpb me estat wcorrelation:estat wcorrelation} could generate an
    incorrect correlation or covariance matrix when used after {helpb menl}.
    This occurred only when option
    {cmd:rescovariance(unstructured, index(}{it:indexvar}{cmd:))} or option
    {cmd:rescorrelation(unstructured, index(}{it:indexvar}{cmd:))} was
    specified with {cmd:menl} and the user dropped observations from the
    dataset after fitting the model such that all observations from one or
    more levels of {it:indexvar} were omitted.  This has been fixed.

{p 5 9 2}
4.  {helpb irf create} with option {cmd:order()} did not produce the correct
    order when more than two variables changed position in the new order.
    This has been fixed.

{p 5 9 2}
5.  {helpb metobit} and {helpb meintreg} incorrectly omitted the variance
    component for the outcome variable, resulting in {cmd:e(k_rs)} being one
    less than it should have been.  This has been fixed.

{p 5 9 2}
6.  {helpb mlogit} and {helpb mprobit}, when the specified {it:depvar} had
    long value labels that started with a number, exited with error message
    "{err:invalid name}".  This has been fixed.

{p 5 9 2}
7.  {helpb menl_postestimation##predict:predict} could generate incorrect
    predictions after {helpb menl}.  This occurred only when option
    {cmd:rescovariance(unstructured, index(}{it:indexvar}{cmd:))} or option
    {cmd:rescorrelation(unstructured, index(}{it:indexvar}{cmd:))} was
    specified with {cmd:menl}, and the requested prediction was a function of
    the random effects, and the user dropped observations from the dataset
    after fitting the model such that all observations from one or more levels
    of {it:indexvar} were omitted.  This has been fixed.

{p 5 9 2}
8.  {helpb proportion}, when specified without the {helpb svy} prefix, without
    option {cmd:vce(cluster} {it:...}{cmd:)}, and without {it:pweight}s, now
    computes the standard error of the estimated proportion using the formula

{p 13 13 2}
        sqrt({it:phat}(1-{it:phat})/{it:n})

{p 9 9 2}
    as originally documented in
    {mansection R proportionMethodsandformulas:{it:Methods and formulas}}.
    The old behavior, using a similar formula that has {it:n}-1 in the
    denominator instead of {it:n}, is not preserved under version control.

{p 5 9 2}
9.  The 06 June 2018 update caused {helpb putexcel} to remove a cell
    fill-color format when any font format was written to the same cell.  This
    has been fixed.

{p 4 9 2}
10.  {helpb reshape wide} with option {cmd:string} and option {opt j(varname)},
     where {it:varname} is a string variable containing spaces, failed to
     generate the variables corresponding with the observations where the
     string variable contained spaces.  This has been fixed.

{p 4 9 2}
11.  {helpb svy_estimation:svy: mean} with option {cmd:over()} identifying
     more than 100 groups and stage-level sampling weights exited with error
     message "{err:{it:varname} not byte}".  This has been fixed.

{p 4 9 2}
12.  {helpb xtile}, when an {cmd:if} condition was specified after an
     expression that ended with a parenthesis, incorrectly produced an error
     message.  This has been fixed.

{p 4 9 2}
13.  {browse "https://www.stata.com/java/api/":Stata-Java API Specification},
     when called with {helpb version} less than 14, incorrectly encoded native
     strings from Stata to Java using either iso-8859-1 or MacRoman, depending
     on the platform.  This was incorrect because all strings in Stata are now
     represented with the UTF-8 encoding.  This is now fixed so that the UTF-8
     encoding is always used when converting Stata native strings to Java.

{p 4 9 2}
14.  When using the
     {browse "https://www.stata.com/java/api15/":Stata-Java API Specification},
     the method
     {browse "https://www.stata.com/java/api15/com/stata/sfi/ValueLabel.html#removeVarValueLabel-int-":ValueLabel.removeVarValueLabel(int index)}
     failed with return code {bf:{search r(198)}} when a valid variable index
     was specified.  This has been fixed.

{p 4 9 2}
15.  (Mac) When printing from the Viewer or Results window, changing the font
     size in the print dialog caused Stata to crash.  This has been fixed.

{p 4 9 2}
16.  (Mac) When printing from the Viewer or Results window, changing the
     scale in the print dialog could result in blank pages being printed.
     This has been fixed.


{hline 8} {hi:update 27jun2018} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 18(2).

{p 5 9 2}
2.  {helpb graph bar} with option {cmd:percentages}, when using a scheme that
    sets a nonzero number of minor ticks, used the wrong scale for the bar
    heights when the maximum value among the variables in {it:yvars} was
    greater than the maximum computed percentage.  This has been fixed.

{p 5 9 2}
3.  {helpb gsem_command:gsem} using the default integration method,
    {cmd:intmethod(mvaghermite)}, and with prefix {helpb svy}, in the rare
    situation where {cmd:predict} failed to compute the adaptive parameters
    within the default maximum number of adaptive iterations, reported
    standard errors that were too large, usually by a multiple of 3 or more.
    This situation will now cause {cmd:svy} to exit with an error message
    stating that the scores could not be computed and also suggesting that the
    model be refit using a different integration method.

{p 9 9 2}
    Other commands affected by this change are {helpb meglm},
    {helpb metobit}, {helpb meintreg}, {helpb melogit}, {helpb meprobit},
    {helpb meologit}, {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg},
    and {helpb mestreg}.

{p 5 9 2}
4.  {helpb meglm}, {helpb metobit}, {helpb meintreg}, {helpb melogit},
    {helpb meprobit}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb menbreg}, and {helpb mestreg}, when the fixed-effects equation
    contained factor variables, returned an incorrect number of parameters in
    {cmd:e(k_f)}.  This has been fixed.

{p 5 9 2}
5.  {helpb sem_command:sem} has improved starting values logic for models
    where some latent variables have only latent indicators, such as in
    hierarchical CFA models.


{hline 8} {hi:update 06jun2018} {hline}

{p 5 9 2}
1.  {helpb menl} has the following improvements:

{p 9 13 2}
     a.  {cmd:menl} now uses
         {help menl##menlmaxopts:standard maximization options} such as
         {cmd:iterate()} and {cmd:tolerance()} to control maximization of the
         NLS algorithm.  It was previously controlled by {cmd:pnlsopts()}'s
         suboptions.  {cmd:pnlsopts()} is no longer allowed with the NLS
         algorithm.

{p 9 13 2}
     b.  {cmd:menl} with nonlinear least-squares (NLS) models -- models
	 without random effects and with i.i.d. errors -- used a default of
	 only five maximum number of iterations.  Now it uses the current
	 value of {helpb set maxiter}, which is {cmd:iterate(16000)} by
	 default.  The increased default maximum number of iterations may
	 result in convergence of the NLS models that previously failed to
	 converge in five iterations.

{p 5 9 2}
2.  {cmd:putdocx} has the following improvement and fix:

{p 9 13 2}
     a.  {cmd:putdocx table} has new argument {it:bwidth} in option
         {cmd:border(}{it:bordername} [, {it:bpattern} [, {it:bcolor} [, {it:bwidth}]]]{cmd:)},
         which is used to set the width of the specified border.

{p 9 13 2}
     b.  {cmd:putdocx table} {it:tablename}{cmd:(}{it:i}{cmd:,}{it:j}{cmd:)} {cmd:=} {cmd:(}{it:{help exp}}{cmd:)},
         when {it:exp} contained unbalanced parenthesis {cmd:(} or {cmd:)},
         incorrectly exited with error message
         "{err:expression must be enclosed in ()}".  This has been fixed.

{p 5 9 2}
3.  {helpb graph export} has the following fixes:

{p 9 13 2}
     a.  {cmd:graph export}, when exporting to a PDF file a
	 {helpb twoway scatter} graph that contained multiple overlayed
	 scatterplots where the symbols in each plot specified transparency
	 settings on the same color, failed to display symbols with
	 transparency.  This has been fixed.

{p 9 13 2}
     b.  {cmd:graph export} could crash Stata when exporting to SVG format a
	 graph that contained many graph items.  This has been fixed.

{p 5 9 2}
4.  When Mata function {helpb mf_lapack:LA_DGEHRD()} was called within a
    {help timer:timing code section} using timer 1, the reported time was
    wrong.  This has been fixed.

{p 5 9 2}
5.  When using Mata, {help mf_st_view:views} and {help mf_st_subview:subviews}
    that were created using variable lists containing factor-variables
    notation or time-series operators used more memory than necessary.
    Although calculations were correct, Stata typically became noticeably
    slower.  This has been fixed.

{p 5 9 2}
6.  {helpb matrix list} and {helpb matlist}, when used to display matrices
    posted by {helpb contrast} and {helpb pwcompare}, failed to include the
    coding or contrast operators in the output.  This has been fixed.

{p 5 9 2}
7.  {cmd:putpdf table} with option {cmd:width()}, when the widths for each
    column in the table were specified as a group of numbers and the sum of
    those numbers equaled 100 as required, sometimes incorrectly exited with
    error message "{err:failed to set table width}".  This has been fixed.

{p 5 9 2}
8.  {helpb regress} with {cmd:aweight}s or {cmd:iweight}s and option
    {cmd:vce(hc2)} or option {cmd:vce(hc3)} did not use properly weighted
    leverage values when computing the variance estimates.  This typically
    resulted in standard-error values that differed in the third significant
    digit.  This has been fixed.

{p 5 9 2}
9.  (Windows) The 18 April 2018 update caused the exporting of Stata graphs to
    WMF format using {helpb translate} to fail.  This has been fixed.
    However, WMF is a legacy metafile format and does not support modern
    graphics features such as transparency and smooth lines.  Users are
    encouraged to switch to the EMF format, which is also supported by older
    versions of Stata.


{hline 8} {hi:update 08may2018} {hline}

{p 5 9 2}
1.  The {help erm_intro:extended regression model} commands now allow greater
    flexibility in modeling treatment effects.

{p 9 13 2}
     a.  New suboptions {cmd:povariance} and {cmd:pocorrelation} are now
         available within options {cmd:entreat()} and {cmd:extreat()} where
         the treatment model is specified.

{p 13 13 2}
         Different variance parameters can be estimated for each potential
         outcome (for each treatment level) by specifying the suboption
         {cmd:povariance}.  {cmd:povariance} may be specified only when
         fitting a model with {cmd:eregress} or {cmd:eintreg}.

{p 13 13 2}
         Different correlation parameters can be estimated for each potential
         outcome (for each treatment level) by specifying the suboption
         {cmd:pocorrelation}.

{p 9 13 2}
     b.  New suboptions {cmd:povariance} and {cmd:pocorrelation} are now
         available within option {cmd:endogenous()} when the suboption
         {cmd:probit} or {cmd:oprobit} has also been specified.

{p 13 13 2}
         Different variance parameters can be estimated for each level of the
         endogenous covariate by specifying the suboption {cmd:povariance}.
         {cmd:povariance} may be specified only when fitting a model with
         {cmd:eregress} or {cmd:eintreg}.

{p 13 13 2}
         Different correlation parameters can be estimated for each level of
         the endogenous covariate by specifying the suboption
         {cmd:pocorrelation}.

{p 5 9 2}
2.  {helpb meglm}, {helpb metobit}, {helpb meintreg}, {helpb melogit},
    {helpb meprobit}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb menbreg}, and {helpb mestreg}, when integration method
    {cmd:mvaghermite}, {cmd:mcaghermite}, or {cmd:ghermite} is specified,
    have improved performance for crossed models specified using the
    {cmd:R.} operator.

{p 5 9 2}
3.  {helpb areg}, when specified with factor variables and option
    {cmd:vce(cluster} {it:clustvar}{cmd:)}, exited with an error message if
    any of the independent variables contained {cmd:_cons} in their names.
    This has been fixed.

{p 5 9 2}
4.  {helpb bootstrap} with option {cmd:bca} and a variable named {cmd:_merge}
    in the dataset incorrectly exited with error message
    "{err:variable {bf:_merge} already defined}".  This has been fixed.

{p 5 9 2}
5.  {helpb jackknife} with option {cmd:keep} and a variable named {cmd:_merge}
    in the dataset incorrectly exited with error message
    "{err:variable {bf:_merge} already defined}".  This has been fixed.

{p 5 9 2}
6.  {helpb margins} after {helpb npregress} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {cmd:dydx()}, when value labels contained
         spaces, exited with an error message.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} with option
         {cmd:at(}{it:varname} {cmd:= generate(}{it:exp}{cmd:))}, when
         {it:exp} contained spaces, exited with an error message.  This has
         been fixed.

{p 5 9 2}
7.  {helpb arch_postestimation##predict:predict} after {helpb arch}, when
    {cmd:arch} was specified with both options {cmd:archmlags()} and
    {cmd:archmexp()}, produced an error message.  This has been fixed.

{p 5 9 2}
8.  {helpb predict} after {helpb meglm}, {helpb metobit}, {helpb meintreg},
    {helpb melogit}, {helpb meprobit}, {helpb meologit}, {helpb meoprobit},
    {helpb mepoisson}, {helpb menbreg}, and {helpb mestreg} now produces an
    error message if option {cmd:ebmeans} or {cmd:ebmodes} is specified
    without option {cmd:reffects}.  Previously, predictions of the mean
    response or another specified statistic that used the empirical Bayes
    means or empirical Bayes modes were produced.  That behavior was not
    documented and is not preserved under version control.

{p 5 9 2}
9.  {helpb pwcorr}, when specified with two variables and option {cmd:obs},
    reported the wrong number of observations for the individual variables
    when some of the observations contained missing values in one variable but
    not the other.  This has been fixed.


{hline 8} {hi:update 18apr2018} {hline}

{p 5 9 2}
1.  The Java Runtime Environment that is redistributed with Stata is now
    updated to version 8 update 162.

{p 5 9 2}
2.  {helpb graph twoway} with option {cmd:by()}, when using a scheme that sets
    a nonzero number of minor ticks, sometimes rescaled the axes differently
    between the individual graphs.  This usually happened to the y axes but
    could also happen to the x axes.  This has been fixed.

{p 5 9 2}
3.  {helpb import fred} with proxy settings enabled exited with error message
    "{err:connection timed out}".  This has been fixed.

{p 5 9 2}
4.  {helpb eteffects_postestimation##predict:predict} with option {cmd:score}
    after {helpb eteffects}, when one score was requested rather than one
    score for each equation, exited with an error message.  This has been
    fixed.

{p 5 9 2}
5.  (Mac) Stata could randomly crash when printing from the Results or
    Viewer window.  This has been fixed.


{hline 8} {hi:update 02apr2018} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 18(1).

{p 5 9 2}
2.  {helpb npregress} has the following new features and fix:

{p 9 13 2}
     a.  {cmd:npregress} with new option {cmd:citype()} allows you to specify
         normal-based and bias-corrected bootstrap confidence intervals in
         addition to the default percentile confidence interval.

{p 9 13 2}
     b.  {helpb margins} after {cmd:npregress} with new option {cmd:citype()}
	 allows you to specify normal-based and bias-corrected bootstrap
	 confidence intervals in addition to the default percentile confidence
	 interval.

{p 9 13 2}
     c.  {helpb margins} after {cmd:npregress} now allows
         {help contrast##operators:contrast operators}.

{p 9 13 2}
     d.  {cmd:npregress} produced an error message when a specific level of a
         factor variable was specified as a regressor.  This has been fixed.

{p 5 9 2}
3.  {helpb levelsof} has new option {opt hexadecimal} for numeric variables,
    which formats the levels in hexadecimal format.  This is useful when the
    variable's levels are noninteger or extremely large integers (absolute
    value >= 1e19).  This option guarantees that the values in the macro that
    {cmd:levelsof} creates are exactly numerically equal to their values in
    the variable.  This option is unnecessary for integers whose absolute
    values are less than 1e19.

{p 5 9 2}
4.  {helpb bayes} prefix for multilevel models (for example,
    {helpb bayes_melogit:bayes: melogit}) sometimes would not allow crossed
    effects, issuing an error message that the crossed latent variables were
    in conflict.  This has been fixed.

{p 5 9 2}
5.  {helpb bayes_mvreg:bayes: mvreg} with option {cmd:gibbs} performed
    incorrect full Gibbs sampling that affected the joint distribution of
    regression coefficients from different equations.  This has been fixed.
    Note that the marginal sampling distributions of regression coefficients
    were unaffected and correct.

{p 5 9 2}
6.  {helpb ci proportions} exited with an error message when
    {varlist} included a Stata wildcard character ({cmd:~}, {cmd:?}, {cmd:-},
    or {cmd:*}).  This has been fixed.

{p 5 9 2}
7.  {helpb glm_postestimation##predict:predict} after {helpb glm}, when
    {cmd:glm} was used with a user-written link function that required
    specification of a variable, exited with error message
    "{error:invalid syntax}".  This has been fixed.

{p 5 9 2}
8.  {helpb svy_tabulate:svy: tabulate}, when the specified variable(s) or the
    value label of the specified variable(s) contained a single left quote
    ({cmd:`}), exited with error message "{error:too few quotes}".  This has
    been fixed.

{p 5 9 2}
9.  (Windows) When the current working directory was a drive letter (for
    example, "c:"), {helpb dyndoc}, {helpb dyntext}, and {helpb markdown}
    constructed the output file path using a relative path notation
    "c:outputfile" instead of absolute path notation "c:/outputfile".  In this
    case, clicking on the link to the file failed to open it in the web
    browser.  This has been fixed.


{hline 8} {hi:update 08mar2018} {hline}

{p 5 9 2}
1.  {helpb erm estat teffects:estat teffects}, when specified after commands
    {helpb eregress}, {helpb eintreg}, {helpb eprobit}, or {helpb eoprobit}
    with prefix {helpb svy:svy:}, incorrectly exited with error message
    "{error:invalid subcommand teffects}".  This has been fixed.

{p 5 9 2}
2.  {helpb graph twoway} with option {cmd:by()}, when using a scheme that
    turned off y-axis grid lines, produced graphs with y-axis grid lines
    anyway.  This has been fixed.

{p 5 9 2}
3.  {helpb levelsof} did not correctly format large integers ({ul:>} 1e7).
    This has been fixed.

{p 5 9 2}
4.  {helpb margins} with option {cmd:vce(unconditional)}, when used after
    {helpb nl}, produced incorrect standard errors that were, on average, the
    square of what they should have been.  This means that if the previously
    reported standard error was larger than 1, then it was too large, and if
    the previously reported standard error was smaller than 1, then it was
    too small.  This has been fixed.

{p 5 9 2}
5.  {helpb mf_moptimize:moptimize()}, when {cmd:moptimize_init_indepvars()}
    was specified using a Mata subview that was created by selecting a subset
    of the columns of a Mata view containing time-series operators or factor
    variables, sometimes caused Stata to crash.  This has been fixed.

{p 5 9 2}
6.  {cmd:putdocx table} with options {cmd:title()} and
    {cmd:headerrow()}, when the table continued on more than one page, only
    created the table header on the first page and did not repeat the table
    header on subsequent pages.  This has been fixed.

{p 5 9 2}
7.  {helpb putexcel} {it:ul_cell}{cmd: = formula(}{it:formula}{cmd:)}, when
    double quotes were specified in {it:formula}, created an invalid workbook.
    When the workbook was opened in Excel, a stopbox was issued.  This has
    been fixed.

{p 5 9 2}
8.  {helpb svy}, when specified using the prefix syntax to replay survey
    estimation results from {helpb meglm}, {helpb metobit}, {helpb meintreg},
    {helpb melogit}, {helpb meprobit}, {helpb meologit}, {helpb meoprobit},
    {helpb mepoisson}, {helpb menbreg}, and {helpb mestreg}, such as

		{cmd:svy: meglm}

{p 9 9 2}
    exited with error message "{error:last estimates not found}".  This has
    been fixed.

{p 5 9 2}
9.  {helpb svy:svy: nl}, when the specified model contained a constant term,
    produced standard errors that were slightly too large by the factor
    f = (df_t - df_m) / (df_t - df_m - 1).  Here, df_t is the total degrees of
    freedom, and df_m is the model degrees of freedom.  This has been fixed.

{p 4 9 2}
10.  {helpb teffects nnmatch} with option {cmd:biasadj()} and frequency
     weights produced incorrect standard errors for the estimated
     average treatment effect (ATE) and the average treatment effect on the
     treated (ATET).  This has been fixed.

{p 4 9 2}
11.  Stata ignored the last line of some Stata text files, such as do-files
     and dictionaries, if the last line did not contain an end-of-line
     delimiter.  This has been fixed.

{p 4 9 2}
12.  (Windows) Stata displayed an empty confirmation dialog box if you opened
     a read-only file in the Do-file Editor and attempted to edit or execute
     the file.  Stata no longer displays the empty dialog box and now requires
     you to use a different filename if you try to save the file.

{p 4 9 2}
13.  (Windows) The "Recent files" menu truncated file paths at the end instead
     of the middle for extremely long file paths.  This has been fixed.

{p 4 9 2}
14.  (Mac) On macOS 10.13 (High Sierra), using the Data Editor to keep or drop
     observations issued an invalid command.  This has been fixed.

{p 4 9 2}
15.  (Unix) On some Unix operating systems, the Do-file Editor would not
     remember all syntax highlighting preferences between Stata sessions.
     This has been fixed.


{hline 8} {hi:update 13feb2018} {hline}

{p 5 9 2}
1.  {helpb bayesmh} and prefix {helpb bayes} now allow option
    {opt initsummary} to be specified with option {opt dryrun}.  This is
    useful for inspecting the initial parameter values before performing MCMC
    simulations.

{p 5 9 2}
2.  {helpb irtgraph icc} with option {cmd:blocation}, when the style of
    decimal point was set to comma, did not render the lines for the estimated
    item difficulties.  This has been fixed.

{p 5 9 2}
3.  {helpb margins}, when used with estimation results from {helpb ologit} or
    {helpb oprobit} where the last term in the main equation was an
    interaction involving a continuous variable and that continuous variable
    was also specified in option {cmd:dydx()}, did not compute the standard
    error of the marginal effect correctly.  The affected standard errors were
    typically inflated.  This has been fixed.

{p 5 9 2}
4.  After the 11jan2018 update, Mata function
    {helpb mf_st_addvar:st_addvar()}, when used to create new variables and
    when there were estimation results already present in {cmd:e()}, returned
    variable indices that were off by one position.  This typically only
    affected calls to {helpb mf_st_view:st_view()} that used these indices
    instead of variable names.  This has been fixed.

{p 5 9 2}
5.  {helpb stset} incorrectly cleared variable {cmd:_stack}, which was
    generated by a previous {helpb stack} command.  This has been fixed.

{p 5 9 2}
6.  The matching logic for estimated coefficients specified in expressions,
    such as those allowed by {helpb lincom}, {helpb test}, and
    {helpb generate}, was lacking version control for matrix stripe name
    elements of {cmd:e(b)} that look like functions.  For example, stripe name
    element {cmd:cov(y)} in an expression was transformed to {cmd:var(y)}
    before attempting to match against the stripe elements of {cmd:e(b)}.  The
    matching logic has been updated to search for the original specification
    when {helpb version} is less than 15.0 and to search for both variants
    when {cmd:version} is 15.0 or higher.


{hline 8} {hi:update 30jan2018} {hline}

{p 5 9 2}
1.  {helpb import excel}'s option {opt allstring} now has an optional argument,
    {cmd:allstring("}{it:{help format}}{cmd:")}, that allows you to control
    the display format of numeric spreadsheet columns being converted to Stata
    string data.

{p 5 9 2}
2.  New command {helpb lmbuild} makes creating Mata function libraries easier
    than does {helpb mata mlib}.

{p 5 9 2}
3.  {helpb clonevar}, when {it:newvar} started with the name or an abbreviated
    name of the cloned variable, incorrectly exited with error message
    "{err:ambiguous abbreviation}".  This has been fixed.

{p 5 9 2}
4.  {helpb collapse} {cmd:(min)} {it:varlist}, when a variable in {it:varlist}
    contained all {help missing:missing values} and when at least one of those
    was an extended missing value, could return any missing value for that
    variable instead of the smallest missing value.  This has been fixed.

{p 5 9 2}
5.  {cmd:estat lcprob}, after {helpb fmm estat lcprob:fmm} or
    {helpb sem estat lcprob:gsem}, when the name of the categorical latent
    variable was a valid abbreviation of a variable in the dataset, reported
    value labels attached to the variable (in the dataset) instead of the
    class levels.  This has been fixed.

{p 5 9 2}
6.  {helpb estat mindices}, when specified after {helpb sem_command:sem} with
    a large number of observed endogenous variables, sometimes reported a
    missing value for all the modification indices representing an omitted
    path or covariance.  This has been fixed.

{p 9 9 2}
    Our technical services team previously recommended using the undocumented
    option {cmd:slow} when {cmd:estat} {cmd:mindices} reported missing values.
    This option is no longer necessary.

{p 5 9 2}
7.  {helpb gsem_command:gsem}, when specified using the variable range syntax
    but with a space on either side of the dash character, such as

		{cmd:gsem} ... {cmd:fvar -lvar}
		{cmd:gsem} ... {cmd:fvar- lvar}
		{cmd:gsem} ... {cmd:fvar - lvar}

{p 9 9 2}
    exited with error message {err:nothing found where name expected}.
    {cmd:gsem} now tolerates spaces in this specification.

{p 5 9 2}
8.  {helpb histogram}, when specified with both options {opt horizontal} and
    {opt addlabel}, incorrectly placed the bar height labels as if option
    {opt horizontal} had not been specified.  The histogram was correctly
    presented horizontally, but the bar height labels were incorrectly placed
    as if the histogram were vertical.  This has been fixed.

{p 5 9 2}
9.  {helpb logistic}, {helpb logit}, {helpb mlogit}, {helpb ologit},
    {helpb oprobit}, and {helpb probit} now accumulate log-likelihood values
    using quad precision.  These commands now converge to a solution for some
    extreme datasets that previously caused these models not to converge.

{p 4 9 2}
10.  {helpb logistic}, {helpb logit}, and {helpb probit}, when specified with
     an interaction term that had a level that was a perfect predictor and
     when {helpb set emptycells:set emptycells drop} was in effect,
     incorrectly exited with error message
     "{err:initial vector: extra parameter ... found}".  This has been fixed.

{p 4 9 2}
11.  Matrix stripe parsing and matching logic was lacking version control for
     stripe name elements that look like functions.  For example, stripe name
     element {cmd:cov(y)} was transformed to {cmd:var(y)} without regard for
     version control.  Now the behavior is to transform only when
     {helpb version} is set to 15.0 or higher.

{p 4 9 2}
12.  {helpb ml}, when specified with option {cmd:technique(bhhh)}, sampling
     weights, and option {cmd:group()}, exited with an uninformative error
     message even when the weights were constant within group.  This has been
     fixed.

{p 4 9 2}
13.  When a graph was exported to SVG format, rotated marker symbols would not
     render properly.  This has been fixed.

{p 4 9 2}
14.  (Mac) The 11 Jan 2018 update improved scrolling performance of tables in
     the Results window but introduced a bug where horizontal lines would
     render only in black.  This has been fixed.


{hline 8} {hi:update 11jan2018} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 17(4).

{p 5 9 2}
2.  {helpb grmap} has new options that control the alignment of borders and
    outlines for polygons and text boxes.

{p 5 9 2}
3.  Function {helpb nt():nt({it:df},{it:np},{it:t})} incorrectly returned
    missing values in rare cases where the iterative method failed to reach
    convergence.  The iterative method now converges and correct values are
    returned.

{p 5 9 2}
4.  Function {helpb tden():tden({it:df},{it:t})}, in extreme cases where the
    degrees of freedom {it:df} was greater than about 1e+10, returned
    incorrect values.  This has been fixed.

{p 5 9 2}
5.  {helpb gsem_command:gsem}, when option {opt capslatent} was specified or
    implied, ignored variables in the model if their first letter was a
    capital letter.  {cmd:gsem} now recognizes those variables as latent
    variables.

{p 5 9 2}
6.  {helpb hausman}, when used with fitted models from {helpb sem_command:sem}
    or {helpb gsem_command:gsem} with fitted covariances, unintentionally
    exited with an error message such as "{err:option varname not allowed}".
    This has been fixed.

{p 5 9 2}
7.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {opt asbalanced}, when working with
         estimation results from ordinal outcome models like {helpb ologit}
         and {helpb oprobit} and when a factor variable was not among the
         {it:marginsvars}, incorrectly exited with error message
         "{cmd:not conformable}".  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} with option {opt expression()}, when the
         expression contained a time-series-operated variable
         and when that same variable specification was also
         specified in option {opt at()}, {opt dydx()}, {opt dyex()},
         {opt eydx()}, or {opt eyex()}, did not correctly compute the
         requested margin or marginal effect.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins} after {helpb gsem_command:gsem}, {helpb meglm},
         {helpb melogit}, {helpb meprobit}, {helpb metobit}, {helpb meintreg},
         {helpb meologit}, {helpb menbreg}, or {helpb mepoisson} with factor
         variables and random effects, when {it:marginsvars} were specified
         and when {helpb set emptycells:set emptycells drop} was in effect,
         exited with error message
         "{err:could not calculate numerical derivatives}".  {cmd:margins} now
         computes the margins as specified.

{p 9 13 2}
     d.  {cmd:margins} with option {opt expression()}, when the
	 expression contained a factor-variable indicator and in the
	 rare case when the level values of that factor variable were
	 set to fractional values using option {opt at()}, did not
	 correctly compute the requested margin or marginal effect.
	 This has been fixed.

{p 5 9 2}
8.  {helpb marginsplot}, when plotting marginal effects of multiple factor
    variables in options {opt dydx()} and {opt eydx()}, has improved spacing
    of the x-axis scale.

{p 5 9 2}
9.  {helpb gsem_predict:predict} after {helpb gsem_command:gsem}, when
    specified with a single new variable name and option {cmd:pr}, predicted
    the mean of the first outcome variable even when it was not a multinomial,
    ordinal, or Bernoulli outcome.  {cmd:predict} now predicts probabilities
    for the first outcome that is multinomial, ordinal, or Bernoulli.

{p 4 9 2}
10.  {cmd:putdocx image} with option
     {cmd:width(}{it:#}[{it:unit}]{cmd:)}, when {it:#} was set to a width
     larger than the body width of the document, caused the image to be
     clipped or not to be displayed in the document.  This has been fixed.
     Now if the image width specified is larger than the body width, the image
     width in the document is set to the body width.

{p 4 9 2}
11.  {cmd:putdocx table} with option {cmd:drop()}, when the row
     index {it:i} equaled the last row in the table, incorrectly exited with
     an error message.  This has been fixed.

{p 4 9 2}
12.  {helpb putexcel} {it:ul_cell}{cmd:=picture(}{it:filename}{cmd:)} gave an
     error message if you used compound quotes around {it:filename}.  This has
     been fixed.

{p 4 9 2}
13.  {cmd:putpdf table} with option
     {cmd:margin(}{it:type}{cmd:,} {it:#}[{it:unit}]{cmd:)}, when {it:#} was
     specified as a floating-point number, set the margin to the greatest
     integer less than or equal to {it:#}.  This has been fixed.

{p 4 9 2}
14.  The {help sembuilder:SEM Builder} has the following fixes:

{p 9 13 2}
     a.  The SEM Builder incorrectly drew double-thick lines when rendering
         the box for a generalized response variable.  This has been fixed.

{p 9 13 2}
     b.  In the SEM Builder, when the outline width for any variable was set
         to a sufficiently thick width, the paths connecting that variable to
         other variables would have a visible gap from the oval or rectangle
         outlining the variable.  This has been fixed.

{p 4 9 2}
15.  {helpb svy tabulate twoway:svy: tabulate} in a two-way specification,
     when there were empty cells and option {cmd:row} or {cmd:column} was
     specified with option {cmd:ci}, incorrectly exited with error message
     "{err:conformability error}".  This has been fixed.

{p 4 9 2}
16.  {helpb xtreg:xtreg, fe}, when used to fit a constant-only model,
     sometimes posted the total sum of squares in {cmd:e(rss)} instead of the
     residual sum of squares.  This affected the values posted in
     {cmd:e(rmse)}, {cmd:e(sigma_e)}, and {cmd:e(rho)}.  This has been fixed.

{p 4 9 2}
17.  The previous update (20dec2017) enabled simplified Chinese localization
     by default when the system language was set to Chinese (zh).  Now Chinese
     localization is only enabled by default if the system language is set to
     Chinese (zh) and the region is set to China (CN).  If you wish to
     manually enable simplified Chinese in the user interface, type
     {helpb set locale_ui:set locale_ui zh_CN}.

{p 4 9 2}
18.  Edit > Copy Table could omit the minus sign from negative numbers if they
     were in the first cell of a row being copied.  This has been fixed.

{p 4 9 2}
19.  (Windows) Exporting a graph to a file or the Clipboard in the EMF format
     could result in an image that contained a graph that was incorrectly
     sized within the image's boundaries.  This has been fixed.

{p 4 9 2}
20.  (Unix GUI) Stata sometimes crashed when using the Data Editor or Data
     Browser, especially when Stata had previously loaded Java.  This has been
     fixed.


{hline 8} {hi:update 20dec2017} {hline}

{p 5 9 2}
1.  Stata 可选择中文本土化用户界面 (Chinese language support has been added).

{p 9 9 2}
    Stata's menus, dialogs, and the like can now be displayed in Chinese, as
    well as Japanese, Spanish, and Swedish.  Manuals, help files, and output
    remain in English.

{p 9 9 2}
    If your computer language is set to Chinese ({cmd:zh}), Stata will
    automatically display the user interface in Chinese.  To change languages
    manually using Stata for Windows or Unix, select {bf:Edit > Preferences}
    {bf:> User-interface language...}; to change languages manually using
    Stata for Mac, select {bf:Stata 15 > Preferences}
    {bf:> User-interface language...}.  You can also change the language from
    the command line; see {helpb set locale_ui:[P] set locale_ui}.

{p 5 9 2}
2.  {helpb bayesstats summary}, {helpb bayesstats ess},
    {helpb bayestest interval}, and {helpb bayesgraph}, after fitting
    prefix command {helpb bayes} and subsequently calling
    {helpb estimates use} or {helpb estimates restore}, failed with error
    message "{err:file not found}" if the simulation results were not saved
    by {cmd:bayes} with option {opt saving()}.  This has been fixed.

{p 5 9 2}
3.  {helpb churdle_postestimation##predict:predict} with option {cmd:ystar},
    {cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)}, or
    {cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} after
    {helpb churdle:churdle exponential} produced incorrect results.  This has
    been fixed.

{p 9 9 2}
    The difference between the old and the new results is negligible when the
    values of the dependent variable are large, such as 100 or larger in our
    experiments.  Large values of the dependent variable are typical with
    exponential mean models.  However, in the rare case where the dependent
    variable is small, differences between old and new predictions may be
    larger; in our experiments, the change was at most 6%.

{p 5 9 2}
4.  {helpb eregress}, when the model included a variable that began with a
    capital letter, sometimes incorrectly exited with an error message
    regarding specification of initial values.  This has been fixed.

{p 5 9 2}
5.  {helpb esize:esize twosample}, when a string variable was specified in
    option {opt by()}, incorrectly exited with an uninformative error message.
    This has been fixed.

{p 5 9 2}
6.  {helpb mecloglog}, {helpb meglm}, {helpb meintreg}, {helpb melogit},
    {helpb menbreg}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb meprobit}, {helpb mestreg}, and {helpb metobit} ignored
    user-specified constraints imposed on {cmd:R.}{it:varname} terms in
    random-effects equations.  This has been fixed.

{p 5 9 2}
7.  {cmd:putdocx table} with option {cmd:title()}, when there was
    only one column in the table, exited with error message
    "{err:failed to add table title}".  This has been fixed.

{p 5 9 2}
8.  {helpb pwcorr} has the following fixes:

{p 9 13 2}
     a.  {cmd:pwcorr} with no observations and only two variables specified
         incorrectly stored {cmd:r(rho)} as 0.  It now exits with error
         message "{err:no observations}".

{p 9 13 2}
     b.  {cmd:pwcorr} with no observations for the first two variables and
         more than two variables specified incorrectly stored {cmd:r(rho)} as
         0.  It now correctly stores {cmd:r(rho)} as missing.

{p 5 9 2}
9.  {helpb stepwise} with options {cmd:lockterm1} and {cmd:lr} and forward
    selection or forward stepwise selection computed likelihood ratios at the
    first addition step by comparing each model with an additional term with
    an empty model rather than with the model that includes the forced first
    term.  Thus, terms could be added to the model that did not satisfy the
    specified significance level for inclusion.  This has been fixed.


{hline 8} {hi:update 21nov2017} {hline}

{p 5 9 2}
1.  {helpb areg}, when fitting a model with the {opt absorb()} variable
    specified among the {it:indepvars} and with option {cmd:vce(cluster}
    {it:clustvar}{cmd:)} where {it:clustvar} was a variable other than the
    {opt absorb()} variable, incorrectly exited with error message
    "{err:not sorted}".  This has been fixed.

{p 5 9 2}
2.  In Stata 15.1, {helpb drop} and {helpb keep} were modified under version
    control to store the number of observations dropped in {cmd:r(N_drop)} and
    the number of variables dropped in {cmd:r(k_drop)}.  However, they cleared
    previously set {cmd:r()} results too soon, meaning that an {cmd:r()}
    result passed to an {cmd:if} condition on {cmd:drop} or {cmd:keep} was
    treated as missing.  This has been fixed.

{p 5 9 2}
3.  {helpb graph} commands that specified option {opt msangle()} to change the
    angle of marker symbols in the current plot retained the adjusted marker
    angle for all plots even when {opt msangle()} was not specified with
    subsequent commands.  This has been fixed.

{p 5 9 2}
4.  {helpb graph matrix}, when using the default stroke alignment for bounding
    boxes of plots and diagonal text boxes, did not align correctly.  The
    result was that some borders appeared too thick.  This has been fixed.

{p 5 9 2}
5.  {helpb gsem_command:gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem}, when fitting a model with both endogenous and exogenous
         latent variables and with an interaction term containing a latent
         variable, exited with an uninformative error message.  {cmd:gsem} now
         fits the model as specified.

{p 9 13 2}
     b.  {cmd:gsem}, when specified with a multinomial logit outcome variable
         and crossed random effects, incorrectly exited with an uninformative
         error message.  {cmd:gsem} now fits the model as specified.

{p 5 9 2}
6.  Prefix command {helpb mfp} used with {helpb intreg} incorrectly dropped
    all left- or right-censored observations from the estimation sample.
    {cmd:mfp} now keeps these observations.

{p 5 9 2}
7.  {helpb ml} with method {cmd:d1debug} or method {cmd:d2debug}, when the
    specified model contained factor variables, exited with error message
    "{err:could not calculate numerical derivatives}".  This has been fixed.

{p 5 9 2}
8.  {cmd:predict} after {helpb logit_postestimation##predict:logit} and
    {helpb probit_postestimation##predict:probit}, when the fitted model
    omitted the base level of a factor variable because it was a perfect
    predictor, did not properly assign missing values to the predictions
    according to the information in the matrix {cmd:e(rules)}.  This has been
    fixed.

{p 5 9 2}
9.  {helpb stcox}, when specified with option {opt shared()} and variable
    names in {it:indepvars} that exceeded the default 12-character width for
    the table, produced a coefficient table with misaligned elements in the
    row for the {cmd:theta} parameter estimate.  This has been fixed.

{p 4 9 2}
10.  {helpb xtile} with option {opt altdef} failed to use the alternative
     formula for calculating percentiles and instead calculated them using the
     default formula.  This has been fixed.

{p 4 9 2}
11.  (Mac) When Stata was run on macOS High Sierra, the autocompletion list
     box from the Command window remained visible after the user attempted to
     cancel it. This has been fixed.


{hline 8} {hi:update 06nov2017} (Stata version 15.1) {hline}

{p 5 9 2}
1.  {helpb bayesmh} has new likelihood {opt t()} in option {cmd:likelihood()}
    for fitting Bayesian regression models with Student's t distributed
    errors, also known as Bayesian Student-t regression models.  This option is
    useful for performing robust linear regression inference in the presence
    of outliers or when the error terms are not normally distributed.  This
    option specified with the {it:t} prior permits {cmd:bayesmh} to fit robust
    multilevel models in which error terms and
    {help bayes_glossary##random_effects_parameters:random effects} follow
    Student's t distribution.

{p 5 9 2}
2.  {helpb margins}, for some nonlinear predictions after certain estimation
    commands, now runs faster and computes standard errors and marginal
    effects more accurately.  These improvements are a direct result of
    implementing analytical derivatives of the prediction with respect to each
    linear form and free parameter in the fitted model.

{p 9 9 2}
    Affected estimation commands include, but are not limited to:
    {helpb heckman}, {helpb logit}, {helpb nbreg}, {helpb poisson}, and
    {helpb probit}.  See {help margins derivatives} for the complete list.

{p 5 9 2}
3.  {helpb menl} has the following new features and fix:

{p 9 13 2}
     a.  {cmd:menl} now allows you to specify {cmd:unstructured} and
         {cmd:exchangeable} within options
         {opth rescovariance:(menl##rescovspec:rescovspec)} and
         {opth rescorrelation:(menl##rescorrspec:rescorrspec)} and
         to specify {cmd:distinct} within option
         {opth resvariance:(menl##resvarspec:resvarspec)}.  These new
         residual covariance structures let you either estimate each variance
         and covariance parameter separately or estimate equal variances and a
         common covariance for the residuals.

{p 9 13 2}
     b.  {cmd:menl} has new suboption {cmd:group()} within options
         {cmd:rescovariance()} and {cmd:rescorrelation()}.  This option lets
         you model residual covariance and correlation structures at the
         lowest level of your model hierarchy without having to include random
         effects at that level in your model.  This is useful, for instance,
         when fitting nonlinear marginal or population-averaged models that
         model dependence of residuals directly, without introducing random
         effects.

{p 9 13 2}
     c.  {cmd:menl} no longer requires you to include random effects in your
	 model specification.  The improved flexibility in model
	 specification, in combination with option {cmd:resvariance()},
	 {cmd:rescorrelation()}, or {cmd:rescovariance()}, permits fitting
	 nonlinear models without random effects but with heteroskedastic and
	 dependent error terms.

{p 9 13 2}
     d.  {cmd:menl} with option {cmd:rescovariance(independent)}, when the
         data contained a residual panel with more than two observations,
         displayed the standard errors for the residual variance (or standard
         deviation) incorrectly.  This has been fixed.

{p 9 13 2}
     e.  {cmd:menl} for models with uncorrelated heteroskedastic errors now
	 performs a more numerically efficient scaling computation for the
	 residuals, which may lead to slightly different parameter estimates
	 for small datasets or for ill-identified models.

{p 5 9 2}
4.  {helpb svyset} has the following improvements:

{p 9 13 2}
     a.  {cmd:svyset} has new option {opt rake()} that provides a
         specification for calibrating weights using the raking-ratio method.

{p 9 13 2}
     b.  {cmd:svyset} has new option {opt regress()} that provides
         specifications for calibrating weights using generalized regression
         (GREG) or truncated regression methods.

{p 9 13 2}
     c.  {cmd:svyset} with a list of variables specified in option
         {cmd:brrweight()}, {cmd:bsrweight()}, {cmd:jkrweight()}, or
         {cmd:sdrweight()} now reports the weighting variables in a more
         compact form.  Only the first and last variables in the list are
	 shown.  For example, typing the following command would produce
	 output of the form below:

                 . {cmd:svyset, jkrweight(jk1 jk2 jk3)}

		  ...
 		  jkrweight: {bf:jk1 .. jk3}

{p 5 9 2}
5.  {helpb regress_postestimation##syntax_estat_esize:estat esize} has the
    following improvements and change:

{p 9 13 2}
     a.  {cmd:estat esize} has new option {opt epsilon} that reports the table
         of effect sizes using epsilon-squared instead of eta-squared.
	 In comparison with eta-squared, epsilon-squared provides a less biased
	 estimate of the effect size.

{p 9 13 2}
     b.  {cmd:estat esize} with option {opt omega} now computes omega-squared
         using the modern method of
         {mansection R regresspostestimationReferences:Grissom and Kim (2012)}.
         Previously, {cmd:estat esize} used the method of
         {mansection R esizeReferences:Hays (1963)}.

{p 9 13 2}
     c.  {cmd:estat esize} reported confidence intervals for omega-squared.
         However, these confidence intervals were found to lack the proper
         coverage.  As such, they are no longer reported, and the lower and
         upper bounds are no longer stored in the matrix of effect sizes,
         {cmd:r(esize)}.  The old behavior is preserved under version control.

{p 5 9 2}
6.  {helpb esizei}, when specified using the syntax form for effect sizes for
    F tests after an ANOVA, has the following changes:

{p 9 13 2}
     a.  {cmd:esizei} has new effect-size estimate epsilon-squared that is
	 reported in the default output.  In comparison with eta-squared,
	 epsilon-squared provides a less biased estimate of the effect size.

{p 9 13 2}
     b.  {cmd:esizei} now computes omega-squared using the modern method of
         {mansection R esizeReferences:Grissom and Kim (2012)}.
         Previously, {cmd:esizei} used the method of
         {mansection R esizeReferences:Hays (1963)}.

{p 9 13 2}
     c.  {cmd:esizei} reported confidence intervals for omega-squared.
         However, these confidence intervals were found to lack the proper
         coverage.  As such, they are no longer reported, and the lower and
         upper bounds are no longer stored in {cmd:r(lb_omega2)} and
         {cmd:r(ub_omega2)}.  The old behavior is preserved under version
         control.

{p 5 9 2}
7.  {helpb estat icc} has the following improvements:

{p 9 13 2}
     a.  {cmd:estat icc} is now available after {helpb meglm} using a
         {cmd:gaussian} family with an {cmd:identity} link, a {cmd:bernoulli}
         family with a {cmd:logit} or {cmd:probit} link, and a {cmd:binomial}
         family with a {cmd:logit} or {cmd:probit} link.  This lets you
         calculate intraclass correlations after fitting a linear, logit, or
         probit mixed-effects model when using {cmd:meglm}.  Previously, you
         had to use separate commands for each family-link combination.

{p 9 13 2}
     b.  {cmd:estat icc} is now available after estimation with
         {help svy_estimation:svy estimation} results from {helpb melogit},
         {helpb meprobit}, {helpb meglm}, {helpb metobit}, and
         {helpb meintreg}.  This lets you calculate intraclass correlations
         for survey data.

{p 5 9 2}
8.  {helpb icd10cm} and {helpb icd10pcs} have been updated for the 2018 fiscal
    year.  Type {cmd:icd10cm query} or {cmd:icd10pcs query} to see information
    about the changes.

{p 5 9 2}
9.  {cmd:putdocx} has the following improvements:

{p 9 13 2}
     a.  New command {cmd:putdocx sectionbreak} lets you add a section break
	 to the current document.  You may apply document formatting options
	 {opt pagesize()} and {opt landscape} to the new section.  This
	 improvement makes it possible to set different properties for
	 different pages in the document.  For example, you can mix the
	 landscape and portrait layouts in a single document.

{p 9 13 2}
     b.  {cmd:putdocx table} now lets you customize the format of
         all cells in adjacent or noncontiguous ranges.  You may apply
         existing cell formatting options {opt halign()}, {opt valign()},
         {opt border()}, and {opt shading()} and existing cell text formatting
         options {opt font()}, {opt bold}, {opt italic}, {opt strikeout},
         {opt underline()}, {opt nformat()}, {opt smallcaps}, and
         {opt allcaps}.  This improvement makes it possible to format many
         cells at once.

{p 9 13 2}
     c.  {cmd:putdocx text} and {cmd:putdocx table} have new options
	 {opt smallcaps} and {opt allcaps} to format text in a paragraph or a
	 cell with a mix of larger and smaller capital letters or with all
	 capitalized letters, respectively.

{p 9 13 2}
     d.  {cmd:putdocx table} has new options {cmd:title()} and {cmd:note()} to
	 add a title or a note to a table.  Option {cmd:note()} may be
	 repeated to add multiple notes with the same format after a table.

{p 9 13 2}
     e.  {cmd:putdocx text}, {cmd:putdocx image}, and {cmd:putdocx table} with
         option {opt linebreak(#)} now let you add line breaks to a paragraph
         or a cell.  Previously, you needed to specify {opt linebreak}
         multiple times to add more than one line break.  You may still
         specify {opt linebreak} multiple times as you did before, but we
         recommend using the new, more concise syntax.

{p 4 9 2}
10.  {helpb putexcel} has the following improvements:

{p 9 13 2}
     a.  {cmd:putexcel set} has new option {cmd:open}.  Specifying {cmd:open}
         opens the specified filename in memory and leaves the file in memory
         for all future {cmd:putexcel} changes.

{p 9 13 2}
     b.  New command {cmd:putexcel close} closes the workbook and saves all
         changes to disk.  You must use {cmd:putexcel close} when you are done
         editing the workbook if you have opened the workbook with
         {cmd:putexcel set} and option {cmd:open}.

{p 9 13 2}
     c.  {cmd:putexcel} has new output type {cmd:etable}, which lets you more
	 easily add the reported coefficient table(s) from the most recent
	 estimation command to an Excel file.

{p 9 13 2}
     d.  {cmd:putexcel} now supports existing option {cmd:overwritefmt} when
         using the syntax for formatting cells.  This lets you write Excel
         cell formats more efficiently.

{p 4 9 2}
11.  {cmd:putpdf} has the following improvements and fixes:

{p 9 13 2}
     a.  New command {cmd:putpdf sectionbreak} lets you add a section
         break to the current document.  You may apply document formatting
         options {opt pagesize()}, {opt landscape}, {opt font()},
         {opt halign()}, {opt margin()}, and {opt bgcolor()} to the new
         section.  This improvement makes it possible to set different
         properties for different pages in the document.  For example, you can
         mix the landscape and portrait layouts in a single document.

{p 9 13 2}
     b.  {cmd:putpdf table} now lets you customize the format of all
         cells in adjacent or noncontiguous ranges.  You may apply existing
         cell formatting options {opt halign()}, {opt valign()},
         {opt border()}, {opt bgcolor()}, and {opt margin()} and existing cell
         text formatting options {opt font()}, {opt bold}, {opt italic},
         {opt strikeout}, {opt underline}, and {opt nformat()}.
         This improvement makes it possible to format many cells at once.

{p 9 13 2}
     c.  {cmd:putpdf text} and {cmd:putpdf table} have new option
	 {opt allcaps} to format text in a paragraph or a cell with all
	 capitalized letters.

{p 9 13 2}
     d.  {cmd:putpdf table} has new options {cmd:title()} and {cmd:note()} to
	 add a title or a note to a table.  Option {cmd:note()} may be
	 repeated to add multiple notes with the same format after a table.

{p 9 13 2}
     e.  {cmd:putpdf table} has new option {opt linebreak(#)} to add line
         breaks in a cell.

{p 9 13 2}
     f.  {cmd:putpdf text} and {cmd:putpdf image} with option
	 {opt linebreak(#)} now let you add line breaks to a paragraph.
	 Previously, you needed to specify {opt linebreak} multiple times to
	 add more than one line break.  You may still specify {opt linebreak}
	 multiple times as you did before, but we recommend using the new,
	 more concise syntax.

{p 9 13 2}
     g.  {cmd:putpdf table} now places the cell text 1 point higher within the
	 cell when the content of the cell is string.  The old behavior is
	 preserved under version control.

{p 9 13 2}
     h.  {cmd:putpdf table} with option {cmd:margin()}, when the margin was
	 set to less than 2 points, did not set the {cmd:top} or {cmd:bottom}
	 margins.  This has been fixed.

{p 4 9 2}
12.  {helpb levelsof} has the following improvements:

{p 9 13 2}
     a.  {cmd:levelsof} is now faster.  Speed is improved when there are many
         observations (>10,000) and many distinct values (>100) or when the
         data are integers.

{p 9 13 2}
     b.  {cmd:levelsof} has new option {opt matrow()} for saving the levels of
         the variable to a matrix.  Previously, you also had to run
         {helpb tabulate} to obtain the levels as a matrix.

{p 9 13 2}
     c.  {cmd:levelsof} has new option {opt matcell()} for saving the
         frequency of each level to a matrix.  Previously, you also had to run
         {helpb tabulate} to obtain the frequencies as a matrix.

{p 4 9 2}
13.  {helpb drop} and {helpb keep} now store the number of observations
     dropped in {cmd:r(N_drop)} and the number of variables dropped in
     {cmd:r(k_drop)}.  This change means that these commands now clear results
     previously stored in {cmd:r()} by other commands.  The old behavior is
     preserved under version control.

{p 4 9 2}
14.  Mata function {helpb mf_uniqrows:uniqrows()} is now faster, especially
     when the number of observations is large (>10,000) and the data are
     integers.

{p 4 9 2}
15.  Mata class {helpb mf_xl:xl()} has 28 new member functions for writing
     Excel cell formats and font formats more efficiently.

{p 4 9 2}
16.  {helpb zipfile} and {cmd:unzipfile} now produce and extract compressed
     files larger than 2 GBs.

{p 4 9 2}
17.  Community-contributed command {helpb dataex}, which generates
     properly formatted data examples for Statalist, is now being distributed
     with official Stata for the convenience of anyone who wishes to post data
     on Statalist.

{p 4 9 2}
18.  {helpb estat lcgof}, after {helpb gsem_command:gsem} with option
     {opt lclass()} was used to fit a model where the observed variables
     predicted latent class outcomes, reported the likelihood-ratio test
     of the fitted model versus the saturated model even though the methods
     currently implemented for computing the likelihood-ratio test do not
     support this situation.  {cmd:estat lcgof} no longer reports the
     likelihood-ratio test in this case.

{p 4 9 2}
19.  {helpb me estat sd:estat sd}, after fitting a model with {helpb mixed}
     where the residual structure was one of {cmd:ar}, {cmd:ma},
     {cmd:unstructured}, {cmd:banded}, {cmd:toeplitz}, or {cmd:exponential},
     labeled the residual structure coefficients in {cmd:r(b)} and {cmd:r(V)}
     in an incorrect order.  This has been fixed.

{p 4 9 2}
20.  {helpb etregress} has the following fixes:

{p 9 13 2}
     a.  {cmd:etregress} with option {cmd:lrmodel} incorrectly included the
         coefficients from the treatment equation in the likelihood-ratio
         model test.  This has been fixed.

{p 9 13 2}
     b.  {cmd:etregress} with options {cmd:lrmodel} and
         {cmd:hazard(}{it:newvar}{cmd:)} stored in {it:newvar} the hazards
         that corresponded to the treatment model with only the constant term
         (intercept).  This has been fixed.

{p 4 9 2}
21.  {helpb gsem_command:gsem} with option {cmd:lclass()} to specify models
     with categorical latent variables no longer implies option
     {cmd:listwise}.  The old behavior is preserved under version control.

{p 4 9 2}
22.  {helpb graph export}, when exporting a graph with a
     {help graph_text##symbols:Greek letter} in the italic style to a PDF
     file, did not display the Greek letter as italicized.  This has been
     fixed.

{p 4 9 2}
23.  {helpb import excel}, when the Excel file was specified as a path and
     filename without an extension, exited with error message
     "{err:file not found}", even when the file existed.  This has been fixed.

{p 4 9 2}
24.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {helpb stintreg_postestimation##margins:margins} after
         {helpb stintreg}, when option {cmd:expression()} contained anything
         other than a single {cmd:predict()} statement, exited with error
         message "{err:expression is a function of possibly stochastic}
         {err:quantities other than e(b)}".  This has been fixed.

{p 9 13 2}
     b.  {helpb margins_pwcompare:margins} with option {cmd:pwcompare}, when
         used to compute margins for two or more interaction terms that
         involved the same number of factor variables, incorrectly computed
         the values of the margins.  This has been fixed.

{p 4 9 2}
25.  {helpb melogit} and {helpb mepoisson} with option
     {cmd:intmethod(laplace)}, when used to fit a two-level model, may not have
     converged when the model could have been identified.  This has been
     fixed.

{p 4 9 2}
26.  {helpb merge} with options {cmd:keep()} and {cmd:assert()} did not
     always verify the required match results before keeping the requested
     observations.  This could result in {cmd:merge} not reporting an error
     when it should have.  This has been fixed.

{p 4 9 2}
27.  {helpb mi impute chained}, when option {cmd:include()} specified an
     expression longer than 80 characters, exited with error message
     "{err:too few ')' or ']'}" instead of producing imputations.  This has
     been fixed.

{p 4 9 2}
28.  {helpb spset}, when the data had been {cmd:xtset} with option
     {opt delta(timevar)}, reset the data with the periodicity information
     removed.  This has been fixed.

{p 4 9 2}
29.  {helpb svy jackknife}, when option {opt mse} was specified at estimation
     or set by {helpb svyset}, ignored the finite population correction if
     option {opt fpc()} was specified in the first sampling stage.  This has
     been fixed.

{p 4 9 2}
30.  (Windows) When exporting a Stata graph to the Clipboard or to an EMF
     file, Stata now includes image data in both the EMF+ and the EMF formats.
     Stata previously included image data only in the EMF format.  The EMF+
     format is an extension to the EMF format that supports features such as
     color transparency.  Exporting both formats together allows modern
     applications that support the EMF+ format to display color transparency
     in Stata's graphs while still supporting legacy applications that can
     only display the EMF format.

{p 4 9 2}
31.  (Windows) {helpb graph export}, when exporting to a bitmap format such as
     PNG, did not respect option {cmd:width()} or {cmd:height()} when
     {helpb set graphics} was set to {cmd:off}.  This has been fixed.

{p 4 9 2}
32.  (Windows) {helpb window fopen} always displayed all files instead of the
     filtered list of files.  This has been fixed.

{p 4 9 2}
33.  (Mac) macOS 10.13 introduced a change that caused Stata's Data Editor to
     crash when used with an {helpb if} expression.  This has been fixed.

{p 4 9 2}
34.  (Mac) macOS 10.13 introduced a bug that caused Stata's Do-file Editor to
     be unresponsive if Stata was installed on an SMB share.  This has been
     fixed.

{p 4 9 2}
35.  (Unix GUI) The Save preferences dialog did not open to the correct
     directory.  This has been fixed.


{hline 8} {hi:update 25sep2017} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 17(3).

{p 5 9 2}
2.  {helpb zip}, {helpb zinb}, and {helpb zioprobit} no longer support option
    {cmd:vuong}, which specifies that the Vuong test for nonnested models be
    reported.  This test was used to compare zero-inflated and noninflated
    models.  However, recent work has shown that testing for zero inflation
    using the Vuong test is {help j_vuong:inappropriate}.  If you wish to
    proceed with the test anyway, use the zero-inflated commands with
    undocumented option {cmd:forcevuong}.


{hline 8} {hi:update 05sep2017} {hline}

{p 5 9 2}
1.  {helpb teffects ra}, {helpb teffects aipw}, {helpb teffects ipw},
    {helpb teffects ipwra}, {helpb stteffects ra}, {helpb stteffects wra},
    {helpb stteffects ipw}, and {helpb stteffects ipwra} now allow you to
    specify option {cmd:vce(cluster} {it:clustvar}{cmd:)} to compute variance
    robust to intragroup correlation.

{p 5 9 2}
2.  {helpb asclogit}, {helpb asmprobit}, {helpb asroprobit}, and
    {helpb nlogit}, when option {cmd:case()} specified a variable with values
    exceeding {helpb creturn:c(maxlong)} = 2,147,483,620, grouped all the
    associated observations into a single case.  This has been fixed.

{p 5 9 2}
3.  {helpb bayesmh} and prefix {helpb bayes} with option {cmd:initrandom},
    when the Cauchy or Laplace distribution was used as the prior for some
    model parameters, incorrectly exited with error message
    "{err:not implemented}".  This has been fixed.

{p 5 9 2}
4.  {helpb bootstrap} and {helpb jackknife}, when used to prefix
    {helpb logistic} specified with an invalid {it:{help eform_option}}, now
    exits with an error message before entering the replication loop.

{p 5 9 2}
5.  {helpb estimates table} with option {cmd:varlabel}, when not all
    variables in the estimation results were present in the dataset, exited
    with error message "{error:variable {it:varname} not found}".
    {cmd:estimates} {cmd:table} now uses the variable name in the table
    instead.

{p 5 9 2}
6.  {help exp:Expressions} using system variables {cmd:_b} and {cmd:_se}, when
    used to access coefficients and standard errors after {helpb mlogit} with
    a value label attached to {it:depvar}, did not recognize equations
    specified using the level values of {it:depvar}.  This has been fixed.

{p 5 9 2}
7.  {helpb forecast solve}, when computing dynamic forecasts with
    {help forecast estimates:estimates} from a model fit using {helpb arima}
    with options {cmd:arima(0,1,1)} and {cmd:sarima(0,1,1,12)},
    incorrectly exited with
    error message "{red:missing values encountered}".  This has been fixed.

{p 5 9 2}
8.  {helpb graph} ignored legend option
    {helpb legend_options##location:ring()} if the scheme placed the legend
    within the plot region.  This has been fixed.

{p 5 9 2}
9.  {helpb gsem_command:gsem} with more than one outcome variable and with
    multilevel latent variables, when missing-value patterns in the observed
    variables caused the omission of one or more of the multilevel groups,
    incorrectly exited with an error.  This has been fixed.

{p 4 9 2}
10.  {helpb heckman} with options {cmd:twostep} and {cmd:vce(bootstrap)}
     incorrectly exited with error message "{error:name conflict}".  This has
     been fixed.

{p 4 9 2}
11.  {helpb margins} with weighted estimation results, with the first
     observation in the dataset containing a missing weight value, and with
     all the independent variables fixed to a constant value incorrectly
     estimated all margins as zero valued with the "(omitted)" note.  This has
     been fixed.

{p 4 9 2}
12.  {helpb menl_postestimation##predict:predict}, {helpb predictnl}, and
     {helpb me estat wcorrelation:estat wcorrelation} in the unusual case that
     out-of-sample predictions were obtained after {helpb menl} with option
     {cmd:rescovariance(independent, index(}{it:varname}{cmd:))} have the
     following fixes:

{p 9 13 2}
     a.  {cmd:predict} with statistic {cmd:rstandard} or with another
	 statistic but without option {cmd:fixedonly}, when the values of the
	 index {it:varname} in the new data did not exactly match the set of
	 values from the estimation sample, gave predictions based on an
	 incorrect residual covariance matrix.  {cmd:predict} now correctly
	 computes the predictions for values of {it:varname} that match
	 the estimation sample and returns missing values for those that do
	 not.

{p 9 13 2}
     b.  {cmd:predictnl} without option {cmd:fixedonly} to obtain nonlinear
         out-of-sample predictions after {cmd:menl} when the values of the
         index {it:varname} in the new data did not exactly match the set of
         values from the estimation sample, gave predictions based on an
         incorrect residual covariance matrix. {cmd:predict} now correctly
         computes the predictions for values of {it:varname} that match
         the estimation sample and returns missing values for those that do
         not.

{p 9 13 2}
     c.  {cmd:estat wcorrelation}, when used to obtain a correlation or
         covariance matrix for a cluster outside the estimation sample,
         returned matrices based on an incorrect residual covariance matrix.
         This has been fixed.

{p 4 9 2}
13.  {helpb menl_postestimation##predict:predict}, {helpb predictnl}, and
     {helpb me estat wcorrelation:estat wcorrelation} in the unusual case that
     out-of-sample predictions were obtained after {cmd:menl} with option
     {cmd:rescovariance()} or {cmd:rescorrelation()} and suboption
     {opt by(varname)} or with option {cmd:resvariance()} and suboption
     {opt strata(varname)} have the following fixes:

{p 9 13 2}
     a.  {cmd:predict} without option {cmd:fixedonly}, when the by or strata
         variable in the new dataset contained values that were different from
         their values in the estimation sample, computed predictions when it
         should have returned missing values.  This has been fixed.

{p 9 13 2}
     b.  {cmd:predictnl} without option {cmd:fixedonly}, when the by or strata
         variable in the new dataset contained values that were different from
         their values in the estimation sample, computed nonlinear predictions
         when it should have returned missing values.  This has been fixed.

{p 9 13 2}
     c.  {cmd:estat wcorrelation}, when the by or strata variable in the new
         dataset contained values that were different from their values in the
         estimation sample, could produce a correlation or covariance matrix
         when it should have exited with error message
         "{err:invalid level specification: {it:<levelspec>}}".  This has been
         fixed.

{p 4 9 2}
14.  {helpb _ms_extract_varlist}, when used after {helpb mlogit} with a value
     label attached to {it:depvar}, did not recognize equations specified
     using the level values of {it:depvar}.  This has been fixed.

{p 4 9 2}
15.  {cmd:putdocx} and {cmd:putpdf} have the following improvements and
     fix:

{p 9 13 2}
     a.  {cmd:putdocx table} and {cmd:putpdf table} with
         output type {cmd:etable()} now support
         the export of results after {helpb estimates table:estimates table}.
         This makes it easier to export formatted estimation results and
         export results from multiple models to a single table.

{p 9 13 2}
     b.  {cmd:putdocx table} and {cmd:putpdf table} with
         output type {cmd:etable()} now support
         the export of results after {helpb margins:margins}.  This makes it
         easier to create tables of marginal effects.

{p 9 13 2}
     c.  {cmd:putdocx describe} and {cmd:putpdf describe},
         when {it:tablename} is specified, now store the number of rows in
         {cmd:r(nrows)} and the number of columns in {cmd:r(ncols)} for the
         specified table.

{p 9 13 2}
     d.  {cmd:putdocx table}, when exporting data in memory to the
         document using output type {cmd:data()}
         and when there was no space between the equal sign {cmd:=} and
         {cmd:data()}, incorrectly exited with error message
         "{err:ddata:  invalid table specification}".  This has been fixed.

{p 4 9 2}
16.  The {help sem builder:SEM Builder}, when working with a path model with
     estimation results from Stata 14, incorrectly exited with an error
     message when the model was fit again using Stata 15.  This has been
     fixed.

{p 4 9 2}
17.  {helpb streg} and {helpb stintreg} with option
     {cmd:distribution(ggamma)}, {cmd:distribution(loglogistic)}, or
     {cmd:distribution(lognormal)}, when
     {helpb set varabbrev:set varabbrev off} was in effect, incorrectly exited
     with error message "{error:[/] not found}".  This has been fixed.

{p 4 9 2}
18.  {helpb tebalance box}, when used after {helpb teffects} with a treatment
     variable using value labels with spaces, incorrectly exited with error
     message "{err:invalid syntax}".  This has been fixed.

{p 4 9 2}
19.  (Windows) For system administrators, {helpb update} did not preserve
     batch mode during its restart sequence, which prevented the use of silent
     updates.  This has been fixed.

{p 4 9 2}
20.  (Mac) {helpb graph export}, when multiple graphs were exported and the
     Graph window preference "Keep list of graphs visible in window" was
     enabled, could export some images as blank.  This has been fixed.

{p 4 9 2}
21.  (Mac) When using an input source to enter characters into the Command
     window from a language other than that of the keyboard, pressing
     {bf:Enter} to choose from a list of characters from the input source
     instead submitted the current contents of the Command window.  This has
     been fixed.


{hline 8} {hi:update 20jul2017} {hline}

{p 5 9 2}
1.  Prefix {helpb bayes} and command {helpb bayesmh} support three new prior
    distributions in option {cmd:prior()}.

{p 9 13 2}
     a. {opt t(mu,sigma2,df)} specifies the location-scale {it:t} distribution
        with mean {it:mu}, squared scale {it:sigma2}, and degrees of freedom
        {it:df}.

{p 9 13 2}
     b. {opt laplace(mu,beta)} specifies the Laplace distribution with mean
        {it:mu} and scale {it:beta}.

{p 9 13 2}
     c. {opt cauchy(loc,beta)} specifies the Cauchy distribution with location
        {it:loc} and scale {it:beta}.

{p 5 9 2}
2.  New postestimation command
    {helpb stintreg_postestimation##gofplot:estat gofplot} after
    {helpb stintreg} allows you to visually assess the goodness of fit of the
    model by plotting the Cox-Snell residuals versus the estimated cumulative
    hazard function corresponding to these residuals.

{p 5 9 2}
3.  {helpb estat lcmean} after fitting a model with {helpb gsem_command:gsem}
    or prefix {helpb fmm:fmm:} can now handle up to 256 class-specific outcome
    means.  The previous limit was 70.

{p 5 9 2}
4.  {cmd:putdocx} has the following improvements and fixes:

{p 9 13 2}
     a.  New command {opt putdocx clear} lets you clear the current document
         in memory without saving.

{p 9 13 2}
     b.  {cmd:putdocx table} has new output type {cmd:etable}.  The
         {cmd:etable} output type lets you more easily add the reported
         coefficient table(s) from the most-recent estimation command to the
         active document.

{p 9 13 2}
     c.  {cmd:putdocx table} has new option {cmd:linebreak} to add a line
         break to a cell.

{p 9 13 2}
     d.  {cmd:putdocx table} now lets you customize the format of all cells in
         a row or column.  You may apply existing cell formatting options
         {opt halign()}, {opt valign()}, {opt border()}, and {opt shading()}
         and existing cell text formatting options {opt font()}, {opt bold},
         {opt italic}, {opt strikeout}, and {opt underline()}.  Previously,
         you could only edit formatting for a single cell.  This improvement
         makes it possible to format many cells at once.

{p 9 13 2}
     e.  {cmd:putdocx table} now lets you apply option {opt nformat()} to the
         numeric values of all cells in a row, the values of all cells in a
         column, or the value of a single cell when editing a table.
         Previously, you could only specify this option when exporting results
         from a Stata or Mata matrix.

{p 9 13 2}
     f.  {cmd:putdocx table} now lets you apply text formatting option
         {opt script()} to individual cells when editing a table.

{p 9 13 2}
     g.  {cmd:putdocx table}, when option {opt append} was specified for a
	 cell, appended the new text or image to the start of the next line
	 rather than the end of the current text or image.  This has been
	 fixed.

{p 9 13 2}
     h.  {cmd:putdocx table}, when exporting the data in memory as a table to
         the document, incorrectly removed the leading and trailing whitespace
         from string variables.  This has been fixed.

{p 5 9 2}
5.  {cmd:putpdf} has the following improvements:

{p 9 13 2}
     a.  New command {opt putpdf clear} lets you clear the current document in
         memory without saving.

{p 9 13 2}
     b.  {cmd:putpdf table} has new output type {cmd:etable}.  The {cmd:etable}
         output type lets you more easily add the reported coefficient table(s)
         from the most-recent estimation command to the active
         document.

{p 9 13 2}
     c.  {cmd:putpdf table} now lets you customize the format of all cells in
         a row or column.  You may apply existing cell formatting options
         {opt halign()}, {opt valign()}, {opt border()}, {opt bgcolor()}, and
         {opt margin()} and existing cell text formatting options
	 {opt font()}, {opt bold}, {opt italic}, {opt strikeout}, and
	 {opt underline()}.  Previously, you could only edit formatting for a
	 single cell.  This improvement makes it possible to format many cells
	 at once.

{p 9 13 2}
     d.  {cmd:putpdf table} now lets you apply option {opt nformat()} to the
         numeric values of all cells in a row, the values of all cells in a
         column, or the value of a single cell when editing a table.
         Previously, you could only specify this option when exporting results
         from a Stata or Mata matrix.

{p 9 13 2}
     e.  {cmd:putpdf table} now lets you apply text formatting option
         {opt script()} to individual cells when editing a table.

{p 5 9 2}
6.  {helpb syntax} can now parse up to 256 options.  The previous maximum was
    70.

{p 5 9 2}
7.  {helpb bootstrap_postestimation##estatbootstrap:estat bootstrap}, after a
    command that estimates multiple free (auxiliary) parameters and with
    option {helpb vce_option:vce(bootstrap)} or prefix {helpb bootstrap}
    specified at estimation, exited with error message
    "{error}estimation command error:  e(k_eq) does not equal the number of equations{reset}".
    Examples of affected commands include {helpb meglm},
    {helpb sem_command:sem}, and {helpb gsem_command:gsem}.  This has been
    fixed.

{p 5 9 2}
8.  {help exp:Expressions} using system variables {cmd:_b} and {cmd:_se}
    to access coefficients and standard errors, when
    {helpb set_varabbrev:set varabbrev} was {bf:on}, returned the value from
    the first element that had a possible match instead of the element with
    an exact match.  This has been fixed.

{p 5 9 2}
9.  {helpb graph export}, when exporting to PDF a map drawn by {helpb grmap}
    that contained a polygon with no fill color, incorrectly exited with
    error message "{err:unable to save PDF file}".  This has been fixed.

{p 4 9 2}
10.  {helpb graph twoway} has the following fixes:

{p 9 13 2}
     a.  {cmd:graph twoway}, when an option included a
         {help colorstyle:color style} that specified a color adjusted for
         both intensity using the {bf:*} operator and opacity using the {bf:%}
         operator (for example, {cmd:red*.8%20}), did not use the correct
         color or effect.  This has been fixed.

{p 9 13 2}
     b.  {cmd:graph twoway}, when an option included a
         {help linepatternstyle:linepattern} formula with consecutive {bf:l}s,
         showed a small gap between segments that should have been solid.
         This has been fixed.

{p 4 9 2}
11.  {helpb grmap}, when a single variable was specified in suboption
     {cmd:variables()} within option {cmd:diagram()}, did not render the
     mid-line in the diagrams.  This has been fixed.

{p 4 9 2}
12.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {cmd:dydx()} could cause Stata to crash if
         marginal effects were calculated only for a single level of a factor
         variable.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins}, when an interaction was specified in {it:marginslist}
         after {helpb dfactor}, {helpb gsem_command:gsem},
         {helpb mecloglog}, {helpb meglm}, {helpb meintreg}, {helpb melogit},
         {helpb menbreg}, {helpb menl}, {helpb meologit}, {helpb meoprobit},
         {helpb mepoisson}, {helpb meprobit}, {helpb mestreg},
         {helpb metobit}, {helpb mgarch}, {helpb nl}, {helpb nlsur},
         {helpb sem_command:sem}, {helpb spivregress}, {helpb spregress},
         {helpb spxtregress}, {helpb sspace}, or {helpb ucm}, produced margins
         for each factor variable separately instead of for the level
         combinations specified by the interactions.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins} after {helpb eintreg}, {helpb eoprobit},
         {helpb eprobit}, or {helpb eregress}, when an endogenous categorical
         variable was specified in {opt at()} but not specified in either
         option {opt fix()} or option {opt base()}, incorrectly used the
         observed values instead of the values specified in {opt at()}.  This
         affected only computations using the endogenous categorical variable
         in auxiliary equations.  This has been fixed.

{p 9 13 2}
     d.  {helpb margins_contrast:margins}, when syntax
         {it:op}{cmd:(}{it:numlist}{cmd:)} was used with one of the
         {help contrast##operators:contrast operators} {cmd:g}, {cmd:gw},
         {cmd:h}, {cmd:hw}, {cmd:j}, {cmd:jw}, {cmd:p}, {cmd:pw}, {cmd:q}, or
         {cmd:qw} to request only a subset of all possible contrasts, reported
         incorrect values of the contrasts.  This has been fixed.

{p 9 13 2}
     e.  {helpb clogit_postestimation##margins:margins} after {helpb clogit},
	 with default prediction {bf:pu0}, when the sum of the values of the
	 first variable in {it:indepvars} that contained no 0 values totaled
	 less than {bf:1e-9} in absolute value, reported missing standard
	 errors.  This has been fixed.

{p 9 13 2}
     f.  {cmd:margins} after
         {helpb npregress}, when {it:marginslist} or option {cmd:at()} was
         specified, incorrectly included in its computations of the reported
         point estimates observations that were missing in the estimation
         sample.  This has been fixed.

{p 9 13 2}
     g.  {cmd:margins} after
         {helpb npregress}, when option {cmd:over()} was specified and when
         more than one variable was specified in option {opt at()}, more than
         one variable was specified in option {opt dydx()}, or more than one
         variable was specified in the {it:marginslist}, labeled coefficients
         with the wrong variable names.  This has been fixed.

{p 4 9 2}
13.  {helpb marginsplot}, after {helpb margins} where a factor-variable name
     could also have served as an abbreviation for a continuous variable and
     both variables were specified in option {cmd:at()}, exited with error
     message
     "{err:_marg_save has a problem. Margins not uniquely identified.}"  This
     has been fixed.

{p 4 9 2}
14.  {helpb odbc insert}, when using a Unicode ODBC driver, truncated
     {cmd:strL} variables to 2,045 characters.  This has been fixed.

{p 4 9 2}
15.  {helpb pctile} with option {opt genp(newvarp)} and more than 1,000
     quantiles specified in option {opt nquantiles()} did not store the
     percentages in the observations that held the corresponding percentiles.
     This has been fixed.

{p 4 9 2}
16.  {helpb tebalance box} and {helpb tebalance density} after
     {helpb teffects}, when the working directory contained many {bf:.gph}
     files that contained spaces in their filenames, incorrectly exited with
     error message "{err:invalid syntax}".  This has been fixed.

{p 4 9 2}
17.  {helpb unicode convertfile} with option {cmd:dstcallback()} applied
     default method {cmd:stop} regardless of the method specified.  This has
     been fixed.

{p 4 9 2}
18.  (GUI) The "Save as" dialog, when used to save a dataset to a format used
     by an older version of Stata, specified the incorrect version number when
     it issued command {helpb saveold}.  This has been fixed.

{p 4 9 2}
19.  (Windows) {helpb graph export}, when used to export a graph to the legacy
     WMF format, did not display the plotted values.  This has been fixed.

{p 9 9 2}
     Stata for Windows users are encouraged to use the EMF format when
     exporting graphs because it supports modern features, such as
     transparency, that WMF does not.

{p 4 9 2}
20.  (Mac) {helpb graph export}, when the exported graph was saved to a
     Windows share and when the graph was exported to PDF or PNG format,
     correctly exported the graphs but the files were not visible from the
     Finder because of a bug in macOS.  This has been fixed.

{p 4 9 2}
21.  (Unix GUI) When using a MobaXterm Windows client, the Find dialog in the
     Do-file Editor froze if no matches were found for the text specified in
     the "Find what:" field.  This has been fixed.


{hline 8} {hi:update 29jun2017} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 17(2).

{p 5 9 2}
2.  {helpb bayes} with
    {help bayesian_estimation##multilevel:multilevel models} did not allow
    string variables to be specified as identifiers of random-effects levels.
    This has been fixed.

{p 5 9 2}
3.  {helpb gsem_predict:predict} with option {cmd:latent()} after
    {helpb gsem_command:gsem}, when the fitted model had paths between
    endogenous latent variables, incorrectly exited with an error.  This has
    been fixed.

{p 5 9 2}
4.  {cmd:putdocx}, when an RBG value was specified in option {cmd:border()},
    {cmd:font()}, or {cmd:shading()}, did not apply the appropriate color.
    This has been fixed.


{hline 8} {hi:update 19jun2017} {hline}

{p 5 9 2}
1.  {helpb proportion} and {helpb svy_proportion:svy proportion} now support
    new methods to compute limits for confidence intervals.  Option
    {opt citype()} lets you specify that the Wilson, exact (Clopper-Pearson),
    Jeffreys, or Agresti-Coull method be used in addition to the normal (Wald)
    and logit methods that were previously supported.

{p 5 9 2}
2.  {helpb sem_estat_lcgof:estat lcgof} has the following fixes:

{p 9 13 2}
     a.  {cmd:estat lcgof}, after fitting a model using
         {helpb gsem_command:gsem} with option {cmd:lclass()} and 10 or more
         outcome variables, exited with error message
         "{err:too many terms in interaction}".  This has been fixed.

{p 9 13 2}
     b.  {cmd:estat lcgof}, after fitting a model using
         {helpb gsem_command:gsem} with both options {cmd:lclass()} and
         {cmd:group()}, used the wrong number of degrees of freedom and wrong
	 saturated model for the likelihood-ratio test of the fitted model
	 versus the saturated model.  This has been fixed.

{p 5 9 2}
3.  {help exp:Expressions} that included a numeric literal that was longer
    than 129 characters could cause Stata to crash.  This has been fixed so
    that Stata can handle numeric literals of arbitrary length.

{p 5 9 2}
4.    {helpb gsem_command:gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem}, with multiple outcome variables, multilevel latent
         variables, and option {cmd:group()}, incorrectly exited with an
         uninformative error message.  {cmd:gsem} now works as documented.

{p 9 13 2}
     b.  {cmd:gsem}, with multilevel latent variables, multiple outcome
         variables, and missing values in some of the observed variables,
         incorrectly exited with error message
         "{err:missing values not allowed in S}".  This has been fixed.

{p 5 9 2}
5.  {helpb icd10}, {helpb icd10cm}, and {helpb icd10pcs} have the following
    fixes:

{p 9 13 2}
     a.  {cmd:icd10 generate}, {cmd:icd10cm generate}, and
         {cmd:icd10pcs generate} with option {opt range(codelist)}, when
         specified with an invalid {it:codelist} that included a range ending
         with a code using the wildcard character ({cmd:*}), incorrectly
         created a new variable.  For example, a range of B10/B29* is invalid,
         but {cmd:icd10 generate} still created a new variable.  These
         commands now return error message
         "{err:invalid range specification}".

{p 9 13 2}
     b.  {cmd:icd10 search}, {cmd:icd10cm search}, and {cmd:icd10pcs search},
         when the specified {it:codelist} included a range that ended with a
         code using the wildcard character ({cmd:*}), incorrectly returned all
	 ICD-10, ICD-10-CM, or ICD-10-PCS codes after the code at the start of
	 the range.  For example, a range of B10/B29* is invalid, but
	 {cmd:icd10 search} still returned a list of codes and their
	 descriptions for all ICD-10 codes from B10 and later.  These commands
	 now return error message "{err:invalid range specification}".

{p 9 13 2}
     c.  {cmd:icd10 check}, {cmd:icd10cm check}, and {cmd:icd10pcs check}, when
         option {cmd:version()} was not specified, did not check for codes
         that were valid for previous versions (error 77) or valid for later
         versions (error 88) of the ICD data.  This has been fixed.

{p 5 9 2}
6.  {helpb import delimited}, when used with option {cmd:stringcols()} or
    option {cmd:numericcols()}, could incorrectly import the first row as
    variable names.  This has been fixed.

{p 5 9 2}
7.  {helpb import excel} with option {cmd:firstrow}, when the specified
    workbook contained no data, exited with an uninformative error message.
    This has been fixed.  {cmd:import excel} now executes without an error
    message but does not create a Stata dataset.

{p 5 9 2}
8.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins}, when used after {helpb eoprobit} with option
         {cmd:entreat()} and when the treatment was interacted with the
	 cutpoints and when {cmd:margins}'s computations were restricted to a
	 single treatment group, incorrectly reported some marginal
	 predictions as not estimable.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins}, when used after {helpb gsem_command:gsem} with option
	 {cmd:group()} and when {cmd:margins}'s computations were restricted
	 to a single group, incorrectly reported some marginal predictions as
	 not estimable.  This has been fixed.

{p 5 9 2}
9.  {helpb ml}, when option {opt technique()} specified a switch between
    {cmd:nr} and {cmd:bfgs} or between {cmd:nr} and {cmd:dfp} and when
    constraints were specified, incorrectly exited with an error message.
    This has been fixed.

{p 4 9 2}
10.  {cmd:putpdf table}, in the rare case when the specified cell
     contents were another table and the cell comprised multiple cells that
     were merged vertically using option {cmd:rowspan()} or option
     {cmd:span()} and the merged cell crossed a page break, drew the bottom
     border of the cell incorrectly.  This has been fixed.

{p 4 9 2}
11.  {helpb stcrreg}, with prefix {helpb stepwise} and parentheses binding the
     first predictor, incorrectly exited with error message
     "{err:option compete() required}" even when option {opt compete()} was
     specified.  This has been fixed.

{p 4 9 2}
12.  Prefix {helpb svy}, when version control was set to 11 through 14.2 and
     when a command specified an interaction using
     {help fvvarlist:factor-variable notation}, exited with an error message
     such as "{err:c: operator invalid}" or "{err:1b: operator invalid}".
     This has been fixed.

{p 4 9 2}
13.  (Windows) {helpb tempfile}, in the rare case when the Stata temporary
     directory path contained certain rarely used Unicode characters and when
     Windows could not provide an ASCII-compatible version of that name,
     produced tempfile names that were invalid for some operations.  Affected
     commands exited with an error message reporting that the path was
     incorrect or the file could not be opened.  This has been fixed.

{p 4 9 2}
14.  (Windows) The {help doedit:Do-file Editor}, when content had not been
     saved before closing, reissued the prompt "Do you want to save the
     changes to ...?" when "Don't save" was selected the first time.  This has
     been fixed.

{p 4 9 2}
15.  (Mac) In the Command window or Do-file Editor, dragging a file
     onto the window did not insert the file path into the window.  This has
     been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew14to15}.{p_end}

{hline}
