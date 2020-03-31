{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 9}

{pstd}
This file records the additions and fixes made to Stata during the 9.0, 9.1,
and 9.2 releases:

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
    {c |} {bf:this file}        Stata  9.0, 9.1, and 9.2     2005 to 2007    {c |}
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
See {help whatsnew9to10}.


{hline 8} {hi:update 20jul2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb adoupdate} did not set the saved result {cmd:r(pkglist)} correctly
    in all cases.  {cmd:adoupdate} should save in {cmd:r(pkglist)} a space
    separated list of package names that need updating (option {cmd:update}
    not specified) or that were updated (option {cmd:update} specified).  In
    fact, {cmd:adoupdate} did this except when a package list was specified,
    and then it returned the package list specified.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb _diparm} reported a conformability error when one of the equations
    in a multiple equation specification contained predictors.  This has been
    fixed.

{p 5 9 2}
{* fix}
3.  {helpb fcast} produced a syntax error when applied to a VAR with only one
    lag.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb irf cgraph} reported an unbalanced-quotes error when there was a
    space at the end of a quoted subtitle.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb irf cgraph} produced a syntax error when {cmd:level()} was
    specified for one of the graphs to be combined.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb nestreg}, when used with {helpb stcox} or {helpb streg},
    incorrectly bound standalone variables into blocks with multiple variables
    when the first block was bound in parentheses.  For example,

{p 13 13 2}
	{cmd:. nestreg: stcox (x1 x2) x3 x4 x5}

{p 9 9 2}
    was incorrectly interpreted as

{p 13 13 2}
	{cmd:. nestreg: stcox (x1 x2) (x3 x4 x5)}

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb nlcom} and {helpb testnl} returned an error when used after
    {helpb svy jackknife} with replicate weights.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb nlogit} failed to omit observations with missing values in the
    dependent variable or the level alternative variables.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb nlogittree} now allows {cmd:if} and {cmd:in} qualifiers.

{p 4 9 2}
{* fix}
10.  {helpb heckprobit_postestimation##predict:predict} was unable to generate
     scores after {helpb heckprobit} when the fitted model did not have a
     dependent variable specified in the selection equation.  This has been
     fixed.

{p 4 9 2}
{* fix}
11.  {helpb stepwise}, when used with {helpb stcox} or {helpb streg},
     incorrectly bound standalone variables into terms with multiple variables
     when the first term was bound in parentheses.  For example,

{p 13 13 2}
	{cmd:. stepwise, pr(.4): stcox (x1 x2) x3 x4 x5}

{p 9 9 2}
    was incorrectly interpreted as

{p 13 13 2}
	{cmd:. stepwise, pr(.4): stcox (x1 x2) (x3 x4 x5)}

{p 9 9 2}
    This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb sts graph} with the {opt hazard} option would return the error
     message "variable __ub not found" when
     {help set varabbrev:variable abbreviations} were turned off.  This has
     been fixed.

{p 4 9 2}
{* fix}
13.  {helpb suest} complained about missing score values when used after
     {helpb heckman} and the dependent variable contained missing values.
     This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb sunflower} failed to draw the final segment of a hexagon's
     outline.  This was only noticeable on Mac computers and has been
     fixed.

{p 4 9 2}
{* fix}
15.  {helpb "svy: tabulate"} with the {opt subpop()} option miscounted omitted
     strata when the row or column variable contained missing values for all
     of the subpopulation observations.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb testnl} reported incorrect standard errors when the estimated
     parameter values were close to the boundary of the support for the
     functions specified in the user defined constraints.  For example,

{pin2}
     {cmd:. testnl sqrt(_b[x1]^2 - _b[x2])}

{p 9 9 2}
     resulted in incorrect standard errors if the squared value of
     {cmd:_b[x1]} was very close to the value of {cmd:_b[x2]}, leading to the
     square root of a negative number.  This has been fixed.

{p 4 9 2}
{* fix}
17.  The {helpb vce_options:vce(bootstrap)} and
     {helpb vce_options:vce(jackknife)} options were not aware of the
     {opt noconstant} option when presented with indicator variables that were
     collinear with the constant.  This resulted in an incorrectly dropped
     indicator variable.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb xi} with the {opt noomit} option failed to keep track of one of
     its generated indicator variables.  On subsequent {cmd:xi} calls with the
     {opt noomit} option, {cmd:xi} failed to remove one of the previously
     generated indicator variables.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb xi} with the {opt noomit} option generated variables without the
     default {cmd:_I} prefix when the {opt prefix()} option was not specified.
     This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
20.  The Data Editor could not display more than 20 variables at a time.  This
     limitation affected users with very high-resolution displays.  This has
     been fixed.

{p 4 9 2}
{* fix}
21.  {helpb fcast} after {cmd:var} produced an error when the VAR contained
     only one endogenous variable.  This has been fixed.

{p 4 9 2}
{* fix}
22.  Using a Stata matrix function that returns a scalar within an {cmd:if}
     clause of a {helpb regress} command caused {cmd:e(b)} and {cmd:e(V)} to
     be saved incorrectly, thereby causing postestimation commands not to work
     after {cmd:regress}.  This has been fixed.

{p 4 9 2}
{* fix}
23.  Inverse probability functions {helpb invbinomial()}, {helpb invFtail()},
     {helpb invibeta()}, {helpb invnFtail()}, and {helpb invnibeta()} could
     enter an endless loop when the unique solution could not be found due to
     the limit of machine precision.  Now, as with other inverse functions,
     they return missing in such cases.  Also {helpb nibeta()} now returns 1
     if {bind:{it:x} > 1} and noncentrality parameter {bind:{it:L} {ul:<} 1}.

{p 4 9 2}
{* enhancement}
24.  {helpb infile2:infile} (fixed format) now accepts a
     {cmd:%}[{opt #}]{opt S} {it:infmt}.  {cmd:%}[{opt #}]{opt S} is similar
     to {cmd:%}[{opt #}]{opt s}, but {cmd:%}[{opt #}]{opt S} preserves leading
     and trailing spaces; {cmd:%}[{opt #}]{opt s} does not.

{p 4 9 2}
{* fix}
25.  {helpb infile2:infile} (fixed format) treated the ASCII character 255
     (hexidecimal 0xFF) as an end of file marker and would stop reading the
     file if it encountered it.  This character is now treated just as any
     other ASCII character.

{p 4 9 2}
{* fix}
26.  Mata miscompiled the expression {cmd:y[p] = y}.  The notable feature of
     this expression is that {cmd:y[p]} appears on the left-hand side of the
     expression and {cmd:y}, the same variable, appears on the right.  This
     has been fixed.

{p 4 9 2}
{* fix}
27.  Mata's {helpb mf_bufput:bufput()} function ignored the {it:offset}
     argument when it copied elements into the buffer.  This has been fixed.

{p 4 9 2}
{* fix}
28.  {helpb odbc load} incorrectly imported real data as missing values for
     values that were within 27 of the upper boundary of integer data types.
     This has been fixed.

{p 4 9 2}
{* fix}
29.  Returned values from r-class programs could mistakenly include {cmd:r()}
     values from the last command the ado-file ran under certain rare
     circumstances.  This has been fixed.

{p 4 9 2}
{* fix}
30.  {helpb sreturn:sreturn list} mistakenly listed matrices returned in
     {cmd:r()}.  This has been fixed.

{p 4 9 2}
{* fix}
31.  {helpb svy}, when used with regression commands such as {cmd:regress},
     incorrectly reported missing standard errors when the {opt subpop()}
     option excluded one or more strata with a single sampling unit.  Here,
     {cmd:svy} incorrectly counted the out-of-subpopulation singleton strata
     even though they were dropped from the estimation sample.  This has been
     fixed.

{p 4 9 2}
{* fix}
32.  {helpb unabcmd} now recognizes the abbreviations for the following
     formerly built-in commands:  {opt cnr:eg}, {opt logi:t}, {opt mlog:it},
     {opt olog:it}, {opt oprob:it}, {opt prob:it}, {opt reg:ress}, and
     {opt tob:it}.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
33.  In certain circumstances double buffering could prevent some Stata
     windows from rendering correctly when used with multiple monitors.  This
     has been fixed.

{p 4 9 2}
{* fix}
34.  In the Do-file Editor, the Search -- Find Next menu item and its
     corresponding F3 keyboard shortcut were not working.  This has been
     fixed.

{p 4 9 2}
{* fix}
35.  The Stata Data Editor displayed an empty system menu under Windows Vista.
     This has been fixed.

{p 4 9 2}
{* fix}
36.  Two scroll bars sometimes appeared on the Variables window under Windows
     Vista.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
37.  The Output Settings dialog is no longer displayed when translating a SMCL
     file to another format.

{p 4 9 2}
{* fix}
38.  The scroll bar thumb would not scroll past the 32,767th line.  This has
     been fixed.

{p 4 9 2}
{* fix}
39.  Clicking multiple times on the Apply button in the Variable Properties
     window of the Data Editor could crash Stata on early versions of Mac OS
     X.  This has been fixed.

{p 4 9 2}
{* fix}
40.  Graphs copied to the Clipboard could possibly contain two filled
     rectangles as the background instead of just one.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
41.  Remotely launching Stata (for example, {cmd:ssh mymachine xstata-se}) would
     cause Stata to believe it was running in batch mode.  This has been
     fixed.


{hline 8} {hi:update 22may2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb binreg} reported the error "option rrr not allowed" when the
    {opt rr} option was used with {cmd:vce(bootstrap)} or
    {cmd:vce(jackknife)}.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb ivprobit} did not apply {cmd:if} or {cmd:in} restrictions specified
    by the user when checking for perfect predictors.  Also {cmd:ivprobit}
    would exit with an error if the two-step estimator was used and the
    reduced-form model had perfect predictors.  These issues have been fixed.

{p 5 9 2}
{* fix}
3.  {helpb jackknife} reported an error when weights were specified with
    commands that have multiple equation specifications using the
    parenthetical notation.  This has been fixed.

{p 5 9 2}
{* fix}
4.  A note has been added to the {helpb ksmirnov} output to warn users when
    ties are found in the variable whose distribution is being tested.

{p 5 9 2}
{* fix}
5.  {helpb nlogit} with {cmd:vce(robust)} neglected to cluster on the
    {cmd:group()} variable when computing standard errors.  This has been
    fixed.

{p 9 9 2}
    {cmd:nlogit} with {opt robust} did not have this problem.

{p 5 9 2}
{* fix}
6.  {helpb roccomp} could produce different chi-squared tests when monotonic
    transformations were applied to the ratings.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb rreg} reported the error "option noheader not allowed" when used
    with the {helpb bootstrap} prefix.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb svyintreg} reported the error "initial values not feasible" for
    constant-only models.  This has been fixed.  {helpb "svy: intreg"} did not
    have this problem.

{p 5 9 2}
{* fix}
9.  {helpb "svy: tabulate"} did not always post the correct {cmd:e(sample)}
    when one or more strata were omitted because they contained no
    subpopulation members; some observations from the omitted strata may have
    been left in the estimation sample identified by {cmd:e(sample)} when they
    should not have been.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb "svy: tabulate"} failed to report on omitted strata when options
     {opt ci} or {opt se} were not specified.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb xtgee} reported the error "option level() incorrectly specified"
     when used with {cmd:vce(jackknife)}.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb xtlogit}, when reporting the number and size of groups, ignored
     groups with more than 32,740 observations.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb xtreg} exited with an error message that the "independent
     variables are collinear with the panel variable" if the scale of the
     panel variable was too large.  This has been fixed.


{hline 8} {hi:update 07mar2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb ctset} with the option {cmd:clear} did not clear the ct setting.
    This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb estimates table} reported a conformability error when used after
    {helpb mlogit} when one or more equations contained a space.  This has
    been fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb icd9} and {helpb icd9p} were updated to use codes through the V24
    update released on October 1, 2006.  The descriptions were also updated so
    that the description of invalid codes that were valid in the past end in
    a hash mark (#).

{p 5 9 2}
{* fix}
4.  The {bf:{dialog matrix_input:matrix input}} dialog did not create a
    symmetric matrix correctly when negative values were specified.  This has
    been fixed.


{hline 8} {hi:update 16feb2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 7(1).

{p 5 9 2}
{* fix}
2.  {helpb cttost} exited with an error message if the total number of
    failures and censored observations in a certain period was equal to the
    total number of individuals in the study, and if the number of failures
    was not smaller than the number of individuals in the study two periods
    before.  Now, in this setting, {cmd:cttost} produces the correct output.

{p 5 9 2}
{* fix}
3.  {helpb svy jackknife} reported an incorrect subpopulation size and
    number of subpopulation observations when the prefixed estimation command
    dropped observations due to missing values.  This has been fixed.


{hline 8} {hi:update 06feb2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb lookfor} can now search for phrases enclosed in double quotes.

{p 5 9 2}
{* fix}
2.  {cmd:predict, scores} after {helpb ologit_postestimation##predict:ologit}
    and {helpb oprobit_postestimation##predict:oprobit} incorrectly returned
    missing values for models having one cutpoint.  The score variable for the
    cutpoint contained missing values in observations where the dependent
    variable equals the second ordered value.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb "svy: ologit"} and {helpb "svy: oprobit"} produced incorrect
    standard errors when used to fit models where the dependent variable had
    only two values.  This was caused by a problem with predicted
    equation-scores for these models, which has been fixed.


    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
4.  (Windows Vista only) Pressing Ctrl-C to copy text from the Command window
    caused Stata to crash.  This has been fixed.

{p 5 9 2}
{* fix}
5.  Printing the Do-file Editor from the File-Print menu or the main Stata
    toolbar would print spurious pages.  This has been fixed.


{hline 8} {hi:update 24jan2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb hausman} failed to correctly recognize equation names in
    {helpb mlogit}'s estimation results when one or more equation names
    contained a space.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb hausman} now exits with an error message if either model was fitted
    with {opt cluster()} or with {helpb pweight}s.  The performance of the
    test can be forced by using {opt force}.

{p 5 9 2}
{* fix}
3.  {helpb lrtest} exited with an error message if the dependent variable of
    one of the models being compared contained time-series operators and the
    restricted model was specified before the unrestricted model in the call
    to {cmd:lrtest}.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb statsby} did not respect the {cmd: level()} option.  This has been
    fixed.

{p 5 9 2}
{* fix}
5.  {helpb "svy: tabulate"} failed to report standard errors or confidence
    intervals if they were requested when the BRR variance estimation method
    was used.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb xtpoisson:xtpoisson, re normal} applied the {cmd:noskip} option by
    default; this has been fixed.


{hline 8} {hi:update 12jan2007} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb adjust} has been modified to perform intermediate computations by
    using double precision.  The resulting gain in precision is usually
    evident in the fourth or fifth decimal place.

{p 5 9 2}
{* fix}
2.  {helpb glm}'s Newey-West standard-error calculation, when used with the
    Anderson kernel function, failed to account for this kernel's being
    nonstandard.  The Anderson kernel is nonstandard because (1) it permits
    a noninteger lag, that is, a bandwidth and (2) the kernel weights are
    nonzero outside the bandwidth/lag range.  {helpb glm} now accounts for both
    of these nonstandard behaviors.

{p 5 9 2}
{* fix}
3.  {helpb gprobit} computed incorrect weights for the GLS stage of the
    computations.  As a result, the coefficient estimates were inefficient.
    This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb graph} now better supports variable labels that are by default used
    to label axes and legend keys.  Labels with unbalanced parentheses and
    brackets are now supported, as well as labels with separately
    double-quoted strings.  As with text appearing in graph options, each
    double-quoted section of text now appears on its own line in the title or
    label.  Results for options {cmd:xtitle()}, {cmd:ytitle()},
    {cmd:legend(label())}, and {cmd:legend(order())} are similarly improved.

{p 5 9 2}
{* fix}
5.  {helpb pac} exited with an error when used with the option {cmd:yw} if
    {cmd:varabbrev} was set to {cmd:off}.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb stcox} and {helpb streg} now exit with an error when option
    {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified when weights
    were {helpb stset}.  Prior to this update, weights corresponding to the
    resampled observations were used as is for computing the replicates.

{p 9 9 2}
    {helpb bootstrap} does not allow weights.

{p 9 9 2}
    {helpb jackknife} allows weights but currently cannot handle them
    correctly for {cmd:stcox} and {cmd:streg}.

{p 5 9 2}
{* fix}
7.  {helpb suest} allowed survey estimation results that used
    poststratification to be mixed with estimation results that did not.  This
    has been fixed.

{p 9 9 2}
    {cmd:suest} can be used only with survey estimation results that are
    consistent with the poststratification information in the current
    {helpb svyset}tings.

{p 9 9 2}
    {cmd:suest} will now verify that the poststratification information is
    consistent between {cmd:svyset} and the specified estimation results.

{p 9 9 2}
    {cmd:suest} will exit with an error message when non-{cmd:svy} estimation
    results are specified and poststratification variables have been
    {cmd:svyset}.

{p 5 9 2}
{* fix}
8.  {helpb svy}, in the 21nov2006 update, was changed to use {helpb encode} on
    string-valued stratum and sampling unit variables.  This change restricted
    the number of sampling units to no more than 65,536 if the variable that
    identifies sampling units was a string variable.  This upper-limit
    restriction has been removed.

{p 9 9 2}
    To decrease the amount of overhead, consider replacing string variables
    that identify the strata and sampling units with encoded numeric
    variables.

{p 5 9 2}
{* fix}
9.  {helpb "svy: tabulate"} failed to drop categories of the row and column
    variables that were exclusively defined in omitted strata.  This has been
    fixed.

{p 4 9 2}
{* fix}
10.  {helpb xtrc} exited with an error when used with more than 1,000 panels.
     This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
11.  {helpb in} now accepts {cmd:F} as a synonym for {cmd:f} as
            shorthand for the beginning of the {cmd:in} range.  {cmd:L} has
            been added as a synonym for {cmd:l} as shorthand for the end of
            the {cmd:in} range.

{p 4 9 2}
12.  Mata has the following new features and fixes:

{p 9 13 2}
{* enhancement}
     A.  New function {helpb mf__diag:_diag()} replaces the principal diagonal
         of a matrix with a specified vector or scalar.

{p 9 13 2}
{* enhancement}
     B.  New ({help undocumented}) functions {helpb mf_trace_avbv:trace_AVBV()}
         and {helpb mf_trace_abbav:trace_ABBAV()} compute the trace of special
         matrices used for spatial statistical calculations.

{p 9 13 2}
{* enhancement}
     C.  Appending rows to a matrix ({helpb m2_op_join:[M-2] op_join}) in Mata
         is now faster.

{p 9 13 2}
{* enhancement}
     D.  Matrix {help m2_op_arith:multiplication}, {it:A}*{it:B}, is now
         faster when {it:A} contains zeros.

{p 9 13 2}
{* enhancement}
     E.  {helpb mf_cross:cross}{cmd:({it:X}, {it:Z})} is now faster when
         {it:X} contains zeros.

{p 9 13 2}
{* fix}
     F.  {helpb mf_select:select}{cmd:({it:X}, {it:v})} exited with a
         conformability error when {it:X} was a row vector and {it:v} was a
         scalar; this has been fixed.

{p 9 13 2}
{* fix}
     G.  {helpb mf_sizeof:sizeof()} could not be used; including
         {cmd:sizeof()} in code resulted in the error "'sizeof' found where
         almost anything else expected" during compilation.  This has been
         fixed.

{p 4 9 2}
{* enhancement}
13.  Two new functions have been added for use with Stata {helpb plugins}:
     {cmd:sstore()} and {cmd:sdata()}.  {cmd:sstore()} stores string data in
     Stata and {cmd:sdata()} reads string data from Stata; see
     {browse "http://www.stata.com/plugins/"}.

{p 4 9 2}
{* fix}
14.  The random-effects panel-data estimators
     {helpb xtlogit:xtlogit, re}; {helpb xtprobit:xtprobit, re};
     {helpb xtcloglog:xtcloglog, re}; {helpb xtpoisson:xtpoisson, re normal};
     {helpb xtintreg}; and {helpb xttobit} could ignore large panels when
     fitting the model.  This was caused by an internal numerical underflow,
     although no warning message was presented, and this is now fixed.  What
     follows is a description of the bug and how to determine whether the bug
     affected any models you have fitted.

{p 9 9 2}
     The above commands use adaptive Gaussian quadrature to estimate
     panel-level likelihoods, where each is the integral of some function
     (call it G) times the normal density.  The function G is the panel-level
     likelihood conditional on the random effects and thus is itself a product
     of observation-level densities of the observations within that panel.
     Typically, but not necessarily, densities are between 0 and 1, and in
     fact they are between 0 and 1 for binary-data models.  In any case, the
     product of these densities over a large panel (a panel with many
     observations) can be small.  If the values got too small, they were
     treated as if they were exactly zero.  The net effect was that such
     panels were ignored in the estimation of the parameters.

{p 9 9 2}
     This problem arose in datasets with large panels, that is, datasets with
     many observations per panel.  How large a panel needed to be in order to
     be affected depended on the average observation-level density for the
     panel.  If this density (probability in a binary model) averaged 10%,
     underflow would occur in panels containing 300 or more observations.  If
     this density averaged 50%, underflow would occur in panels containing
     1,000 or more observations.  At 90%, the underflow would occur with
     panels containing 6,500 or more observations.  Since most users use these
     models to estimate for large N, small T data, this large-T problem did
     not affect many users.

{p 9 9 2}
     Also, regardless of panel size, calculations for determining the
     optimal Gaussian quadrature points were also subject to a similar
     underflow problem.  This has also been fixed.  The net result of this
     fix, however, is merely that quadrature points are now more precisely
     estimated, resulting in better-approximated log-likelihoods.  The gain in
     precision is slight, usually being in the fourth or fifth decimal place
     of the estimated regression parameters.

{p 4 9 2}
{* fix}
15.  {help Stata/MP} with more than two processors had a bug in {helpb tobit}
     and {helpb cnreg}.  Let N_PROCS be the number of processors with
     N_PROCS>2, and let N_OBS be the number of observations for the model.
     When N_OBS/100>1 and N_OBS/100<N_PROCS, Stata/MP made a mistake in
     determining the actual number of processors to use.  The mistake could
     crash Stata or produce wrong results.  This is fixed.

{p 4 9 2}
{* fix}
16.  When exporting a graph with the Stata logo as a PostScript file, Stata
     would specify the wrong font name for the Stata logo.  This caused
     applications such as Adobe Illustrator or Distiller to complain that a
     font wasn't found.  This bug is not serious since those applications
     would substitute a font for the incorrectly named font.  This has
     been fixed.

{p 9 9 2}
    Stata also now outputs characters outside the range of 7-bit ASCII
    characters in PostScript's preferred octal format.  Users should see no
    difference when their PostScript or EPS files are rendered or printed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
17.  A process spawned by {helpb winexec} would inherit and hold open any file
     handles previously opened by Stata (such as an open log file) even if
     Stata later closed those file handles.  Stata now does not allow a
     process spawned by {cmd:winexec} to inherit Stata's file handles.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
18.  You may now change the font in the Results, Viewer, Command, Data Editor,
     Do-file Editor, Review, and Variables windows.  You may select a
     fixed-width font only in the Results, Viewer, Data Editor, Do-file
     Editor, and Variables windows.

{p 9 9 2}
    Stata continues to allow you to change the font in the Graph window.

{p 4 9 2}
{* fix}
19.  Stata previously output text from graphs and SMCL exported to PostScript
     by using the incorrect font encoding.  This caused characters outside the
     7-bit ASCII range to not translate properly when using an external
     application's PostScript interpreter.  This has been fixed.


{hline 8} {hi:update 30nov2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 6(4).


    {title:Stata/MP executable, 64-bit Itanium Windows}

{p 5 9 2}
{* fix}
2.  The 64-bit Itanium Windows Stata/MP executable could have problems
    completing an {helpb update executable} command; this has been fixed.


{hline 8} {hi:update 21nov2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb bstat} exited with an error indicating a name conflict when the
    {opt stat()} option contained a matrix with equation names.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
2.  {helpb cnreg}, {helpb logit}, {helpb mlogit}, {helpb ologit},
    {helpb oprobit}, {helpb probit}, {helpb regress}, and {helpb tobit} are
    now noticeably faster (up to five times faster) when used within large
    loops, such as {helpb statsby} with datasets that have many small
    {it:by}-groups.

{p 5 9 2}
{* fix}
3.  {helpb histogram} with an {it:if} condition that excluded one of the
    categories in the {opt by()} option resulted in an extra empty plot when
    option {opt addlabels} or {opt kdensity} was specified or resulted in an
    error when option {opt normal} was specified.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb nestreg} reported confidence intervals for the default confidence
    level even when a different confidence level was specified in the
    {opt level()} option of the prefixed command.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb quadchk} exited with an error when used to check models using the
    {cmd:offset()} option.  This has been fixed.  {helpb quadchk} also ignored
    weights and the {cmd:collinear} and {cmd:constraints()} options.  This has
    been fixed.

{p 5 9 2}
{* fix}
6.  {helpb svy} now identifies the rare case when a sampling unit bridges
    adjacent strata in multistage designs.  {cmd:svy} treats all sampling
    units as nested within strata and units from prior stages.

{p 5 9 2}
{* fix}
7.  {helpb "svy: heckman"} excluded from the estimation sample observations
    with a missing value in the dependent variable when it should not have.
    This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb svy jackknife} reported incorrect values for the sample size,
    population size, and number of strata when some of the strata were
    omitted.  This has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb svy} linearization is now two to five times faster.
    {cmd:svy: mean}, {cmd:svy: proportion}, {cmd:svy: ratio}, and
    {cmd:svy: total} are considerably faster when the {opt over()} option
    identifies many subpopulations.

{p 4 9 2}
{* fix}
10.  {helpb "svy: mean"}, {helpb "svy: proportion"}, {helpb "svy: ratio"}, and
     {helpb "svy: total"} reported missing standard errors due to strata with
     one sampling unit even when a {opt subpop()} option excluded the
     offending strata.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb "svy: mean"}, {helpb "svy: proportion"}, {helpb "svy: ratio"}, and
     {helpb "svy: total"} failed to omit strata that contain no subpopulation
     members.  This has been fixed.

{p 4 9 2}
{* enhancement}
12.  {helpb "svy: tabulate twoway"}, when option {cmd:row} or {cmd:column} is
     specified, uses the ratio estimator to compute cell proportions relative
     to the row or column margins.  For direct standardization, option
     {cmd:stdize()}, a better estimator is available:  the standardized ratio
     estimator.  This standardized ratio estimator is now used in place of the
     simple ratio estimator when {cmd:stdize()} is specified.

{p 4 9 2}
{* fix}
13.  {helpb "svy: tabulate"} incorrectly reported zero standard errors when
     used with survey data that had strata with one sampling unit.
     Standard errors and confidence intervals are now suppressed with a note
     explaining why when the {opt se} or {opt ci} option is specified in
     such cases.

{p 4 9 2}
{* fix}
14.  {helpb xtcloglog} and {helpb xtpoisson} with the {cmd:re} and
     {cmd:normal} options would ignore constraints on {cmd:lnsig2u}.  This has
     been fixed.

{p 4 9 2}
{* fix}
15.  {helpb xtintreg}, {helpb xtlogit}, {helpb xtprobit}, {helpb xtpoisson}
     with the {cmd:re} and {cmd:normal} options, and {helpb xttobit} all
     accepted the {cmd:collinear} option but exited with an error when used
     with a constraint to define a collinear model.  This is now fixed.

{p 4 9 2}
{* fix}
16.  {helpb xtintreg} and {helpb xttobit} ignored constraints on {cmd:sigma_u}
     and {cmd:sigma_e}.  This has been fixed.

{p 4 9 2}
{* enhancement}
17.  {helpb xtline} has new {opt i()} and {opt t()} options.  The {opt i()}
     option allows the panels (groups) to be identified using a string
     variable.  The {opt t()} option allows a variable with noninteger values
     and repeated values within group.

{p 9 9 2}
     The important effect of this is that {cmd:xtline} can now be used to
     easily create two-way graphs with separate plots for each level of a
     categorical variable.  For example,

{p 13 17 2}
	{cmd:. xtline mpg, t(displacement) i(rep78) overlay}

{p 9 9 2}
     creates five line plots of {cmd:mpg} versus {cmd:displacement}, one for
     each of the five levels of {cmd:rep78}.

{p 9 9 2}
     These plots can be rendered as other {cmd:twoway} plottypes by adding a
     {cmd:recast()} option.  For example, adding {cmd:recast(scatter)} to the
     command above will produce five scatterplots rather than five line
     plots.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
18.  In Mata's {helpb mf_ghk:ghk()} function, when the covariance matrix is
     not positive definite, the {cmd:ghk()} Cholesky routine will pivot out
     the offending row and column of the covariance matrix.  The {cmd:ghk()}
     function failed to permute the corresponding upper bound of integration.
     This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
19.  Stata for Windows now supports Microsoft Windows Vista.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
20.  For efficiency, when resizing a graph window, Stata draws a preview of
     the graph rather than completely redrawing the graph.  However, the
     preview could be drawn at the wrong size if the window is quickly resized
     by jerking the mouse.  This has been fixed.

{p 4 9 2}
{* fix}
21.  When there is a {cmd:{hline 2}more{hline 2}} condition in the Results
     window, Stata will continuously poll for a key press to clear the
     {cmd:{hline 2}more{hline 2}} condition, which causes the processor usage
     to be very high.  Stata now does not poll as often when there is a
     {cmd:{hline 2}more{hline 2}} condition, causing the processor usage to be
     very low.

{p 4 9 2}
{* fix}
22.  Some graph markers and objects would not be drawn with an outline in the
     Graph window when using the Quartz 2D graphics engine.  This has been
     fixed.  This bug did not affect EPS and PS files.

{p 4 9 2}
{* fix}
23.  The console version of Stata/MP for Intel-based Macs could not correctly
     determine whether an executable update was available.  This has been
     fixed.

{p 4 9 2}
{* fix}
24.  The Do-file Editor will now treat a tab character as multiple spaces when
     printing a do-file.  The Do-file Editor previously treated a tab
     character as one space when printing.

{p 4 9 2}
{* fix}
25.  Stata now creates the Stata license file as stata.lic instead of
     Stata.Lic after license initialization.  This distinction allows Mac OS X
     systems using the UFS file system to read the license file because the
     UFS file system is case sensitive.  The default file system for Mac OS X
     is HFS+ and is not case sensitive, and it will accept both stata.lic and
     Stata.Lic.  Current Stata users who are using the UFS file system can
     simply rename the file Stata.Lic to stata.lic.  Current Stata users who
     are using the HFS+ file system do not need to rename Stata.Lic to
     stata.lic.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* fix}
26.  Clicking a link in the Results window to open a help file in the Viewer
     could cause Stata to crash.  This has been fixed.


{hline 8} {hi:update 27oct2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  For {helpb bootstrap} and {helpb jackknife}, if a user specified a
    {opt cluster()} option before the colon and a conflicting {opt cluster()}
    option after the colon, the second {opt cluster()} option was being
    ignored.  An error message is now issued.

{p 5 9 2}
{* fix}
2.  If a user-written e-class command did not set {cmd:e(cmd)},
    {helpb bootstrap}, {helpb jackknife}, {helpb svy brr}, and
    {helpb svy jackknife} exited with an error message.  This has been fixed.

{p 5 9 2}
{* fix}
3.  If a URL longer than 44 characters was used to open a dataset,
    {helpb codebook}'s {cmd:problems} option reported an error.  It no longer
    does so.

{p 5 9 2}
{* fix}
4.  If a value label had unbalanced quotes, {helpb codebook} stopped with an
    error message.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb ivprobit} did not set {cmd:e(depvar)} when the {cmd:twostep} option
    was used.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb screeplot}'s {cmd:addplot()} option failed with multiple plots.
    This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb "svy: regress"} when typed in the abbreviated forms
    {cmd:svy: regr}, {cmd:svy: regre}, and {cmd:svy: regres} (with one s),
    failed to adjust standard errors for mean squared error of the regression.
    This has been fixed.

{p 9 9 2}
    There was no problem when you typed {cmd:svy: regress} or its most common
    abbreviation, {cmd:svy: reg}.

{p 5 9 2}
{* fix}
8.  Previously, {helpb xtgee} could produce model results in which the
    estimated working correlation matrix was not positive definite, as a
    proper correlation matrix must be.  Now, when {cmd:xtgee} reaches a
    solution for which the working correlation matrix is not positive
    definite, the command issues an error message stating that convergence has
    not been achieved.

{p 9 9 2}
    Also, for exchangeable correlation matrix structures, the estimation
    algorithm resets the correlation parameter to its minimum bound implied by
    the maximum panel size when the correlation parameter is infeasible.  This
    reset will help models that can converge to do so, although if the data
    are incompatible with an exchangeable correlation structure, then
    convergence cannot be achieved.


{hline 8} {hi:update 06oct2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb areg} with option {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}
    resampled observations instead of the groups identified by the
    {opt absorb()} variable.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb asmprobit_postestimation##estatmfx:estat mfx} after
    {helpb asmprobit}, in extremely rare cases, gave incorrect standard errors
    for the marginal effects of discrete case-specific covariates.  These
    standard errors were incorrect only when different individuals faced
    different alternatives and when the subsample used to compute marginal
    effects was missing the first alternative.  This has been fixed.

{p 9 9 2}
    Standard errors of marginal effects for both discrete and continuous
    alternative-specific covariates, as well as those for all continuous
    covariates, were always correct.

{p 5 9 2}
{* fix}
3.  Bayesian information criterion (BIC) calculations within {helpb glm}, with
    {cmd:family(binomial)} and an explicit binomial denominator, were based on
    an incorrect total number of observations.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb quadchk} used with version control for versions before 9 exited
    with an error.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb rolling} returned an error message when used with panel data and an
    {cmd:if} qualifier that disqualified an entire panel.  This has been
    fixed.

{p 5 9 2}
{* fix}
6.  {helpb svyset} with the {opt noclear} option resulted in one sampling
    stage even when the original settings had more than one stage.  This
    has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb xtgee}, when used with {cmd:family(binomial)}, issued an "estimates
    diverging" error when used with fractional dependent variables containing
    values equal to one.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb xtset}, when both panel and time variables were specified,
    misreported unbalanced panels as either strongly balanced or weakly
    balanced.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
9.  {helpb pctile} and {helpb xtile}, when dividing the data into more than
    1,001 quantiles, would occasionally put data into the wrong quantile
    because of small rounding errors.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb svy} reported missing standard errors when there were strata with
     one certainty unit.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
11.  Pressing Page Up/Down in the Command window no longer sounds a system
     beep.

{p 4 9 2}
{* fix}
12.  The Value labels list box from the {cmd:label define} dialog could
     obscure part of the Define label names list box on systems where the
     window appearance setting was changed.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
13.  Stata prevented windows from being dragged above the menu bar on Macs
     with multiple monitors.  This has been fixed.


{hline 8} {hi:update 28aug2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 6(3).

{p 5 9 2}
{* fix}
2.  {helpb clogit} standard errors were not correct if {helpb pweight}s were
    used without option {cmd:cluster()}.  This problem has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb cloglog} and {helpb xtcloglog} reported error messages when the
    {opt collinear} option was specified even when constraints were specified
    that properly identified the model.  This problem has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb graph bar}, in rare cases, produced bars based on incorrect values
    when a variable was repeated for a statistic and followed by another
    statistic and variable.  This problem has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb histogram}, {helpb kdensity}, {helpb twoway histogram},
    {helpb twoway kdensity}, {helpb twoway lfit}, and {helpb twoway qfit}
    produced unusable graphs when the {opt by()} option identified one or more
    groups that resulted in an empty graph.  This problem has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb linktest}, when run after {helpb glm}, used a Stata 6 version of
    {cmd:glm} rather than the modern one.  This problem has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ml} commands using {helpb fweight}s with options
    {cmd:technique(bhhh)} or {cmd:vce(opg)} produced incorrect standard error
    estimates.  This problem has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb ml} exited with an unhelpful error message when checking for
    convergence and the likelihood evaluator resulted in an unstable or
    asymmetric Hessian matrix.  This problem has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb nestreg} returned an error message when {helpb svy} omitted strata
    due to zero weights or subpopulation estimation.  This problem has been
    fixed.

{p 4 9 2}
{* fix}
10.  The function evaluator version of {helpb nl} exited with an error if the
     user tried to pass any options to the function evaluator program.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb nlogit}'s robust standard-error calculation failed to take into
     account the within-choice-set correlation inherent to {cmd:nlogit}
     models.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
12.  {helpb pcamat}, {helpb factormat}, {helpb corr2data}, and {helpb drawnorm}
     now allow singular correlation (or covariance) structures.  {cmd:pcamat},
     {cmd:factormat}, {cmd:corr2data}, and {cmd:drawnorm} have new option
     {opt forcepsd} that maps a matrix intended to be correlations
     (covariances) into a positive-semidefinite singular correlation
     (covariance) matrix.

{p 4 9 2}
{* enhancement}
13.  {helpb ranksum} now allows {cmd:by()} to contain a string variable.

{p 4 9 2}
{* enhancement}
14.  {helpb _rmdcoll}'s {opt nocollin} option has been renamed to
     {opt normcoll}.  The {opt nocollin} option will continue to work as a
     synonym for {opt normcoll} but will become undocumented.

{p 4 9 2}
{* fix}
15.  {helpb stepwise} dropped variables collinear with the constant even when
     the {opt noconstant} option was specified in the prefixed command.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb svy jackknife} sometimes reported the number of subpopulation
     observations and subpopulation size even when the {cmd:subpop()} option
     was not specified.  This problem has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb table}'s {cmd:format()} option was not applied to the frequency
     column when the frequency was greater than nine digits.  This
     problem has been fixed.

{p 4 9 2}
{* enhancement}
18.  {helpb testnl} with an expression that included a comma produced an error
     message.  Expressions that are bound in parentheses now allow commas.
     For example, {cmd:testnl _b[x]=M[1,3]} is still not allowed, whereas
     {cmd:testnl (_b[x]=M[1,3])} is now allowed.

{p 4 9 2}
{* enhancement}
19.  {helpb tsset} and {helpb xtset} now indicate whether the panels are
     balanced.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
20.  {helpb asmprobit} sometimes incorrectly marked the estimation sample when
     invalid observations were dropped.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
21.  {helpb graph twoway} plot types {cmd:pcarrow}, {cmd:pcbarrow}, and
     {cmd:pcarrowi} may now be drawn on plot regions with log scales or
     reversed scales.

{p 4 9 2}
{* fix}
22.  Once {helpb logit}, {helpb logistic}, or {helpb probit} reported an error
     902 (no room to add more variables due to width), the error would
     continue being reported on subsequent attempts even after the memory had
     been set to a value large enough to perform the estimation.  This problem
     has been fixed.

{p 4 9 2}
{* enhancement}
23.  Mata function {helpb mf_findexternal:findexternal()} is updated to allow
     returning pointers to functions as well as matrices, vectors, and
     scalars.

{p 4 9 2}
{* fix}
24.  {helpb svy brr}, {helpb svy jackknife}, {helpb "svy: mean"},
     {helpb "svy: proportion"}, {helpb "svy: ratio"}, and {helpb "svy: total"}
     did not omit strata for which every observation contained a zero sampling
     weight.  This problem has been fixed.


    {title:Stata executable, Windows and Mac}

{p 4 9 2}
{* fix}
25.  When Stata checked if an update was available from Stata's website but no
     updating was performed, it displayed a note that an update was available
     after Stata was launched.  In rare cases, Stata's update status was not
     synchronized with Stata's website.  This problem has been fixed.


{hline 8} {hi:update 31jul2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Estimation commands called with options {cmd:vce(bootstrap)} or
    {cmd:vce(jackknife)} now report a note when a variable is dropped due to
    collinearity.

{p 5 9 2}
{* fix}
2.  {helpb asmprobit} when used with {cmd:vce(bootstrap)} or
    {cmd:vce(jackknife)} now requires that {opt basealternative()} and
    {opt scalealternative()} options be specified.

{p 5 9 2}
{* fix}
3.  {helpb heckman}{cmd:,} {opt twostep}'s dialog incorrectly displayed a
    button for launching the {helpb svyset} dialog.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
4.  {helpb mlogit}, {helpb mprobit}, and {helpb slogit} when used with
    {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} now require that the
    {opt baseoutcome()} option be specified.

{p 5 9 2}
{* fix}
5.  {helpb nlogit} issued a "too many values" error if the number of groups
    exceeded {helpb tabulate}'s row limit; see {help limits}.
    This problem has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb nlogit} reported incorrect degrees of freedom for the LR test of
    homoskedasticity if constraints were applied to the regression parameters.
    This problem has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ologit} sometimes reported a missing model F statistic when it
    should have reported a missing model LR statistic.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
8.  {helpb rolling} failed to compute results with commands that generate new
    variables.  This problem has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy} now omits strata that have zero-valued sampling weights in
    every observation.

{p 4 9 2}
{* fix}
10.  {helpb tabstat} with the {cmd:by()} option truncated the word Total when
     the {cmd:by()} variable's name and value label were fewer than 5
     characters.  This problem has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
11.  The following commands now have the {opt collinear} option:
     {helpb arch}, {helpb arima}, {helpb asmprobit}, {helpb biprobit},
     {helpb clogit}, {helpb cloglog}, {helpb frontier}, {helpb gnbreg},
     {helpb heckman}, {helpb heckprob}, {helpb hetprob}, {helpb intreg},
     {helpb ivprobit}, {helpb ivtobit}, {helpb mlogit}, {helpb mprobit},
     {helpb nbreg}, {helpb nlogit}, {helpb poisson}, {helpb _rmcoll},
     {helpb _rmdcoll}, {helpb slogit}, {helpb streg}, {helpb treatreg},
     {helpb truncreg}, {helpb xtcloglog}, {helpb xtfrontier},
     {helpb xtintreg}, {helpb xtlogit}, {helpb xtnbreg}, {helpb xtpoisson},
     {helpb xtprobit}, {helpb xttobit}, {helpb zinb}, {helpb zip},
     {helpb ztnb}, and {helpb ztp}.

{p 4 9 2}
{* enhancement}
12.  {helpb _parse expand} and {helpb _parse canonicalize} now have the
     {opt gweight} option for parsing global weights.

{p 4 9 2}
{* fix}
13.  {helpb datasignature} did not always calculate the correct checksum when
     using the {cmd:fast} option on Power PC-based Mac, AIX, Solaris,
     HP/9000, HP/Itanium, and Irix computers.  This problem has been fixed.

{p 4 9 2}
{* fix}
14.  Mata's {helpb mf_all:allof()} and {helpb mf_all:anyof()} functions did
     not allow {help m2_pointers:pointer} or {help m2_struct:structure}
     arguments and, in fact, could crash when such arguments were specified.
     This problem has been fixed, and the functions may be used with pointer
     or structure arguments.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
15.  The ability to submit multiple commands to the Command window has been
     reinstated.

{p 4 9 2}
{* fix}
16.  Review window selections are now retained.

{p 4 9 2}
{* fix}
17.  Under rare conditions, programmable dialogs could show up with a black
     background.  This problem has been fixed.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* fix}
18.  The previous update of Stata introduced a problem where printing a Viewer
     window would cause the Command edit field to not accept any keyboard
     input.  This problem has been fixed.

{p 4 9 2}
{* fix}
19.  When building a list of fonts for display in the Graph Preferences
     dialog, Stata queries the font server for a list of fonts and expects the
     fonts to be specified in the X Logical Font Description (XLFD) format.
     If a font was not in the XLFD format, Stata crashed.  Stata now ignores
     fonts that are not returned in the correct format.


{hline 8} {hi:update 13jul2006} {hline}

    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
1.  Certain windowing layouts could cause Stata to incorrectly
    display windows upon starting up.  For example, a pinned Variable
    pane could cause a portion of Stata's background to not be drawn
    properly.  This problem has been fixed.


{hline 8} {hi:update 11jul2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb clogit} now accepts {helpb pweight}s.

{p 5 9 2}
{* enhancement}
2.  {helpb tetrachoric}'s default algorithm for computing tetrachoric
    correlations has been changed from the Edwards and Edwards estimator to a
    maximum likelihood estimator.  The Edwards and Edwards estimator performed
    poorly with skewed data.  {cmd:tetrachoric}'s features are now similar to
    those of {helpb spearman} and {helpb ktau}.  Standard errors and two-sided
    significance tests are now included.  A frequency adjustment when one cell
    has a zero count is now available with the {cmd:zeroadjust} option.  This
    change has been made without version control; to get the old behavior, the
    {cmd:edwards} option can be used.

{p 5 9 2}
{* enhancement}
3.  {helpb xtmixed} has new option {cmd:collinear}, which tells {cmd:xtmixed}
    to retain collinear variables within random-effects equations.


{hline 8} {hi:update 06jul2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb clear} has been updated to clear the new timers described below for
    profiling ado and Mata code.

{p 5 9 2}
{* fix}
2.  {helpb heckman}'s dialog incorrectly displayed a button for launching the
    {helpb svyset} dialog.  This problem has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb lowess} ignored certain suboptions of the {opt by()} option.  This
    problem has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb streg_postestimation##predict:predict, scores} after
    {helpb streg:streg, distribution(exponential)} computed scores incorrectly
    when {it:t0} was not 0.  This problem has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb survey} estimation commands that allow the {opt technique()} option
    reported incorrect standard errors when {cmd:technique(bhhh)} was
    specified.  This problem has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb "svy: tabulate oneway"} reported an error message when specified
    with a constant variable.  This problem has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb tsline} misread or would not accept certain {it:{help datelist}}
    specifications in the {opt tlabel()} and {opt tline()} options.  This
    problem has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb twoway fpfitci} did not draw the confidence interval when the
    option {cmd:estcmd()} was used to specify some estimation commands.  This
    problem has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* enhancement}
9.  {help statamp:Stata/MP}, the parallel-processing flavor of Stata, is now
    available for 64-bit Solaris on x86-64 hardware.  The supported platforms
    for Stata/MP are Windows (32-bit, 64-bit Itanium, and 64-bit x86-64),
    Linux (32-bit, 64-bit Itanium, and 64-bit x86-64), and Solaris (64-bit
    SPARC and 64-bit x86-64).

{p 4 9 2}
{* enhancement}
10.  The internal utilities for {cmd:gllamm} now support inverse-probability
     weighting schemes.

{p 4 9 2}
{* enhancement}
11.  Mata has the following new functions:

{p 9 13 2}
    A.  Mata functions {helpb mf_minindex:minindex()} and
        {helpb mf_minindex:maxindex()} return the indices of minimums and
        maximums (including tied values) of a vector, {it:v}.

{p 9 13 2}
    B.  Mata function {helpb mf_timer:timer()} is a new {help undocumented}
        function for profiling the execution time of Mata code.

{p 4 9 2}
{* fix}
12.  Mata had the following fixes:

{p 9 13 2}
    A.  Mata functions {helpb mf_crossdev:crossdev()} and
        {helpb mf_quadcross:quadcrossdev()} aborted with error if the
        centering variables contained missing values.  Now the functions
        return an all-zero result.

{p 9 13 2}
    B.  Mata functions {helpb mf_rowshape:rowshape()} and
        {helpb mf_rowshape:colshape()} would not let you change certain types
        of null matrices to other types.  For instance, you could not change
        a 1 {it:x} 0 matrix into a 0 {it:x} 0.  This problem is fixed.  A side
        effect of the fix is that you must recompile any programs that use
        {cmd:colshape()}.  You do not need to recompile programs that use
        {cmd:rowshape()}, however.

{p 9 13 2}
    C.  Mata function {helpb mf_st_numscalar:st_strscalar()} did not return
        results from Stata's {helpb c()}, such as
        {bf:st_strscalar("c(byteorder)")}.  This problem has been fixed.
        Users are reminded that another way to obtain c-class values is via
        Mata's {helpb mf_c_lc:c()} function:  {bf:c("byteorder")}.

{p 4 9 2}
{* fix}
13.  Inserting data via {helpb odbc insert} to an existing database could,
     depending on the underlying SQL code generated, cause SQL syntax errors.
     This problem has been fixed.

{p 4 9 2}
{* fix}
14.  The regular expression functions {helpb regexm()}, {helpb regexs()}, and
     {helpb regexr()} could cause {help Stata/MP} to crash; this problem has
     been fixed.

{p 4 9 2}
{* enhancement}
15.  To prevent output from wrapping, {helpb return list},
     {helpb ereturn list}, and {helpb sreturn list} now display only the first
     line of long string results.  The result looks better and is more easily
     read.  If a report is truncated, two dots are added to the end of the
     part shown.

{p 4 9 2}
{* fix}
16.  In {helpb tabulate twoway}, cells with zero counts contributed missing
     ({cmd:.}) instead of zero to the value of the likelihood-ratio
     chi-squared test.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
17.  {helpb timer} is a new {help undocumented} command for profiling the
     execution time of ado-code.

{p 4 9 2}
{* fix}
18.  Small Stata (Windows and Mac) could crash when the
     {help extended_fcn:extended macro function} {cmd:properties} was used in
     a program.  This problem has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
19.  The Command window now has keyboard shortcuts reinstated from Stata 8.
     Using Ctrl-Backspace to delete a whole word is an example.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
20.  The contextual menu item Copy Review Contents to Do-file Editor for the
     Review window was enabled even when the Review window was empty.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
21.  The Font Size submenu from the Prefs menu was not enabled when the
     Variables window was selected.  This problem has been fixed.

{p 4 9 2}
{* fix}
22.  Using the Quartz drawing engine for drawing graphs could render some
     non-ASCII characters as outlined boxes.  To avoid this limitation of the
     Quartz text renderer, you may use ATSUI (Apple Type Services for Unicode
     Imaging) to render text in graphs by using
     {cmd:set use_atsui_graph on}.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* fix}
23.  Closing a Viewer window while a modal dialog was up would cause Stata to
     crash.  Stata now prevents you from closing the Viewer until the warning
     dialog is closed.

{p 4 9 2}
{* fix}
24.  A GTK warning message could appear from the console Stata was started
     from if a dialog had a dropdown list combo box.  This problem has been
     fixed.

{p 4 9 2}
{* fix}
25.  After the 17may2006 executable update, the {cmd:setposition} member
     program did not work correctly for certain types of programmable dialog
     controls.  This problem has been fixed.


{hline 8} {hi:update 20jun2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 6(2).

{p 5 9 2}
{* fix}
2.  {helpb areg} exited with an error when {opt if} or {opt in} was properly
    supplied after the {opt absorb()} option.  This problem has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb egen}'s {cmd:median()} function failed when presented with
    expressions containing double quotes.  This problem has been fixed.

{p 5 9 2}
{* enhancement}
4.  {helpb regress postestimation##estathett:estat hettest} has new options
    {opt iid} and {opt fstat}.  By default, {cmd:estat hettest} performs a
    score test for heteroskedasticity that assumes that the regression
    disturbances are normally distributed.  {opt iid} causes
    {cmd:estat hettest} to perform a score test for heteroskedasticity that
    drops the normality assumption.  {opt fstat} causes {cmd:estat hettest} to
    perform an F test for heteroskedasticity that drops the normality
    assumption.

{p 5 9 2}
{* fix}
5.  {helpb stcox_postestimation:estat} failed to work after
    {helpb stcox:stcox, shared()}.  This problem has been fixed.

{p 5 9 2}
{* enhancement}
6.  Mata functions {helpb mf_mean:mean()}, {helpb mf_mean:variance()},
    {helpb mf_mean:quadvariance()}, {helpb mf_mean:meanvariance()},
    {helpb mf_mean:quadmeanvariance()}, {helpb mf_mean:correlation()}, and
    {helpb mf_mean:quadcorrelation()} previously required two arguments, the
    second being {it:w}, the weight.  The second argument is now optional and,
    if omitted, unweighted estimates (equivalent {it:w}=1) are returned.

{p 5 9 2}
{* fix}
7.  Mata functions {helpb mf_mean:variance(X,w)},
    {helpb mf_mean:quadvariance(X,w)}, {helpb mf_mean:meanvariance(X,w)}, and
    {helpb mf_mean:quadmeanvariance(X,w)} aborted with an error if {it:X} or
    {it:w} contained all missing values.  Now the functions return an
    all-missing result.

{p 5 9 2}
{* fix}
8.  {helpb nl} exited with an error if a parameter's name was a substring of
    another parameter's name and the parameter whose name was longer was
    declared first.  This problem has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb nlogit} did not use weights when computing the initial estimates
    and null likelihoods used to test the regression coefficients and
    homoskedasticity.  This problem has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb roctab}, with the {cmd:detail} option, reported incorrect values
     of sensitivity when the classification probabilities corresponding to
     different levels of the classification variable were equal.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb "svy: mlogit"} exited with an invalid-syntax error when the
     dependent variable had value labels with spaces in them.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb treatreg} now accepts the {opt from()} option.

{p 4 9 2}
{* fix}
13.  {helpb tsline} reported an invalid-number error when the time variable
     had a {cmd:%d} format and a time axis option was specified using a date
     string.  This problem has been fixed.


{hline 8} {hi:update 17may2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb regress_postestimation##estatvif:estat vif} after {cmd:regress} has
    a new option, {cmd:uncentered}, that computes uncentered variance
    inflation factors.

{p 5 9 2}
{* fix}
2.  {helpb regress_postestimation##estatvif:estat vif} after {cmd:regress}
    reported invalid results with options {cmd:vce(bootstrap)} or
    {cmd:vce(jackknife)} or with the {helpb svy} prefix.  {cmd:estat vif} now
    reports an error message.

{p 5 9 2}
{* fix}
3.  {helpb estimates table} did not label estimates properly when equation
    names contained spaces.  This problem has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb glm} would exit with an error message if an HAC covariance matrix
    was requested and the list of regressors included time-series operators.
    This problem has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb glm} reported incorrect deviances and deviance diagnostics when
    fitted to proportion data with {cmd:family(binomial 1)}.  This problem has
    been fixed.

{p 5 9 2}
{* enhancement}
6.  {helpb graph twoway} now allows more than 100 variables to be plotted even
    when those variables are from the same observations.  Previously the only
    way to plot more than 100 variables was to ensure that some of the
    variables were plotted over a different range of observations.  One plot
    is still limited to 100 or fewer variables.

{p 5 9 2}
{* fix}
7.  The dialog box for {helpb graph twoway} did not generate the correct
    options for affecting the rendition of lines when used with
    {helpb twoway lfitci}, {helpb twoway qfitci}, or {helpb twoway fpfitci}.
    This problem has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb ivprobit} and {helpb ivtobit} exited with an error message when
    regressors were dropped because of collinearity, when the list of
    regressors exceeded about 500 characters, or when time-series operators
    were used.  These problems have been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb nlogit} now allows the {cmd:robust} option for models that nest
    deeper than three levels.

{p 4 9 2}
{* fix}
10.  {helpb qreg}, and similar quantile regression commands, sometimes dropped
     the dependent variable when it equaled a linear function of the
     covariates.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
11.  {helpb svyset} now has the {opt fay(#)} option.

{p 4 9 2}
{* fix}
12.  {helpb "svy: tabulate twoway"} reported a one in the marginals when the
     {opt column} and {opt row} options were specified, even when given data
     that resulted in a zero in the marginals.  This problem has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb table} now issues an improved error message when the {cmd:sd}
     statistic is used with {help pweights}.

{p 4 9 2}
{* fix}
14.  {helpb xi} omitted a group when called with the {opt noomit} option and
     syntax {cmd:i.}{it:varname1}{cmd:*}{it:varname2} or
     {cmd:i.}{it:varname1}{cmd:|}{it:varname2}.  This problem has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb xtreg:xtreg, fe cluster()} did not report the proper degrees of
     freedom or p-value for the model F test.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
16.  {helpb xtset} is a new command for declaring panel data.  This command is
     meant to eventually replace {cmd:iis} and {cmd:tis}.  For panel data with
     a time variable, {cmd:xtset} and {helpb tsset} are equivalent.  View the
     {cmd:xtset} command as a new convenience command, something you do not
     really need but might like to use anyway.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
17.  {helpb datasignature} is a new command that many users will find useful.
     {cmd:datasignature} reports a short string (a signature) that you can use
     to detect whether your data have changed.  See
     "{it:Examples of interactive use}" under {it:Remarks} in the help file.

{p 4 9 2}
{* fix}
18.  {helpb insheet}, when given a file with more than the maximum allowed
     number of variables, could cause Stata to crash.  This problem has been
     fixed.

{p 4 9 2}
{* enhancement}
19.  {helpb irf create} now estimates dynamic-multiplier (DM) functions and
     cumulative DM functions, as well as their standard errors.  The
     {helpb irf} reporting commands were modified to display the new DM
     estimates.

{p 4 9 2}
{* enhancement}
20.  Mata functions {helpb mf_select:select()} and
     {helpb mf_select:st_select()} are new.  They select rows or columns of a
     matrix on the basis of a criterion.

{p 4 9 2}
{* fix}
21.  Mata incorrectly executed statements of the form
     "{it:v}{cmd:[}{it:i}{cmd:]} {cmd:=} {it:name}" and
     "{it:v}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} {cmd:=} {it:name}" when {it:v}
     and {it:name} were {help m2_struct:structures}.  Rather than assigning a
     copy of structure {it:name} to {it:v}, Mata assigned {it:name} itself, so
     that subsequent changes in {it:name} changed {it:v}{cmd:[}{it:i}{cmd:]}
     and {it:v}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}.  This problem has been
     fixed.  You do not need to recompile Mata code.

{p 4 9 2}
{* fix}
22.  Mata inconsistently classified {cmd:""} as being greater than nonempty
     strings (such as {cmd:"a"}), whereas Stata classifies them as being less
     than nonempty strings.  Mata has been modified so that it agrees with
     Stata:  {cmd:""} < {cmd:"a"}.

{p 4 9 2}
{* fix}
23.  Mata's {helpb m2_op_logical:>=} operator returned an incorrect result
     when used with strings and the string to the left of the operator was
     greater than the string to the right of the operator.  This problem has
     been fixed.

{p 4 9 2}
{* enhancement}
24.  {helpb signestimationsample} and {helpb checkestimationsample} are new
     programmer commands for coordinating estimation and postestimation
     ado-files.

{p 4 9 2}
{* enhancement}
25.  Classes can now define an {cmd:.oncopy} member program to perform
     operations when a copy of an object is created.  This is an advanced
     concept; see {help classman} section
     {hi:{help classman##specifying_initialization3:4.8 Advanced initialization, .oncopy}}.

{p 4 9 2}
{* enhancement}
26.  For Stata/MP, Stata/SE, and Intercooled Stata, the limit on the number of
     dyadic operators in an expression has been increased from 500 to 800, and
     the limit on the number of numeric literals in an expression has been
     increased from 150 to 300.  See {help limits}.

{p 4 9 2}
{* enhancement}
27.  New functions {cmd:_byn1()} and {cmd:_byn2()} are available within a
     {cmd:byable(recall)} program.  They return the beginning and ending
     observation numbers of the by-group currently being executed.  See
     {help byable} for more information.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
28.  The Data editor on Windows ME could freeze Stata.  This problem has been
     fixed.

{p 4 9 2}
{* fix}
29.  The dropdown print menu from the toolbar print button could get
     corrupted when displaying multiple graphs.  This problem has been fixed.

{p 4 9 2}
{* fix}
30.  Stata could crash if scheduled to run at a preset time when there was no
     user logged in to Windows.  This problem has been fixed.

{p 4 9 2}
{* fix}
31.  When invoking a dataset via the recent files menu in Stata that happened
     to also be on a shared network drive, an extra slash was prepended to the
     path.  This problem has been fixed.

{p 4 9 2}
{* fix}
32.  {help Stata/MP} on Windows XP loaded a wrong version of the common
     controls DLL.  Various abnormal GUI behaviors, such as the dialog
     backgrounds becoming black, could occur if XP Themes were used.  This
     problem has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
33.  {helpb xmlsave} now uses only double quotes as tag attributes when saving
     to the Excel doctype.  This change circumvents a bug in Excel for
     Mac when reading XML data files generated from Stata.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* enhancement}
34.  When a programmable dialog has the keyboard focus, pressing Enter
     simulates clicking the OK button if one exists, pressing Escape simulates
     clicking the Cancel button if one exists, and pressing Shift and Return
     simulates clicking the Submit button if one exists.

{p 4 9 2}
{* enhancement}
35.  The Command window is no longer resized if the main Stata window is
     resized vertically.  The Review and Variables windows are no longer
     resized if the main Stata window is resized horizontally.  You may still
     drag the splitter controls to resize the windows.

{p 4 9 2}
{* fix}
36.  Sometimes, the Command window lost the keyboard focus, preventing users
     from inputting any commands unless they clicked on the body of the main
     Stata window.  This problem has been fixed.

{p 4 9 2}
{* fix}
37.  Exporting a graph as TIFF would result in a graph with the width and
     height swapped.  This problem has been fixed.

{p 4 9 2}
{* fix}
38.  Resizing a Graph window could cause its graph to not draw at the final
     window size if the graph could not finish drawing while it was being
     resized.  This problem has been fixed.

{p 4 9 2}
{* fix}
39.  Resizing the Data Editor also caused the Data Editor's toolbar and edit
     field to resize vertically.  This problem has been fixed.

{p 4 9 2}
{* fix}
40.  Right-clicking in a Viewer window and selecting Find in Viewer... would
     not display the Find bar.  After selecting File > Log > View... to
     display the Choose File to View dialog, clicking the Browse... button and
     selecting a filename would not be entered into the File or URL: edit
     field.  Both problems have been fixed.

{p 4 9 2}
{* fix}
41.  Selecting Prefs > Manage Preferences > Load Preferences > Open... could
     crash Stata.  This problem has been fixed.

{p 4 9 2}
{* fix}
42.  If any modal dialog caused Stata's Results window to scroll before the
     dialog could close completely, the first line to be obscured by the top
     of the dialog would not be updated after it scrolled.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
43.  {helpb shell} under Linux could fail if more than half of the memory
     available on the system was allocated to Stata.  This problem has been
     fixed.


{hline 8} {hi:update 14apr2006} {hline}

    {title:What's new in release 9.2 (compared with release 9.1)}

{pstd}
Highlights for release 9.2 include the following:

{p 8 11 2}
{cmd:o}{space 2}Stata/MP
        is a new parallel-processing version of Stata that can perform
        calculations in parallel on computers with 2, 4, 8, 16, and even 32
        processors or cores.  Stata/MP has all the capabilities of
        {help SpecialEdition:Stata/SE} but can perform many analyses much
        faster by taking advantage of special code to perform symmetric
        multiprocessing (SMP).  See {help Stata/MP} and
        {browse "http://www.stata.com/statamp/"} for more information.

{p 8 11 2}
{cmd:o}{space 2}Mata
        now has structures, which will be of special interest to those writing
        large, complicated systems.  See {help whatsnew9##matastruct:item 14 A}
        below.

{p 8 11 2}
{cmd:o}{space 2}Mata
        now engages in more thorough type checking, and produces better code,
        for those who explicitly declare arguments and variables.  See
        {help whatsnew9##matatypecheck:item 14 B} below.

{p 8 11 2}
{cmd:o}{space 2}{cmd:hsearch}
        is a new command that searches help files.  It is an alternative to
        the {cmd:search} command.  You will want to try {helpb hsearch}.

{pstd}
We recommend that you set version to {cmd:version 9.2} at the top of new
do-files and ado-files.  See help {helpb version}.


    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb bootstrap} and {helpb jackknife} exited with an error when an
    appropriate {it:{help eform_option}} was specified.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
2.  {helpb bsample} returned incorrect frequency weight values (in the
    {opt weight()} option) when called with a resample size less than the
    selected sample size.  This problem has been fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb cloglog} and {helpb xtcloglog} have new option {opt eform}.

{p 5 9 2}
{* fix}
4.  {helpb corr2data} was inadvertently setting the random-number generator
    seed to the current value of {helpb sortseed}.  This problem has been
    fixed.

{p 5 9 2}
{* enhancement}
5.  {helpb glm} and {helpb xtgee} labeled generic exponentiated coefficients
    as "ExpB" and "e^coef".  For consistency, both labels have been changed to
    "exp(b)".  This change applies only to models where exponentiated
    coefficients do not already have meaningful names, such as hazard ratios.

{p 5 9 2}
{* enhancement}
6.  {helpb hsearch} is a new command for searching the Stata help files on
    your computer.

{p 5 9 2}
{* fix}
7.  {helpb ml} complained that the variable {cmd:ML_subv} already exists when
    called twice interactively with the {opt subpop()} option.  This problem
    has been fixed.

{p 5 9 2}
{* enhancement}
8.  {helpb ml display} has new option {opt showeqns}.

{p 5 9 2}
{* fix}
9.  {helpb sts graph} did not respect value labels when the {opt by()} and
    {opt separate} options were combined with {opt hazard}.  This problem has
    been fixed.

{p 4 9 2}
{* fix}
10.  {helpb svy jackknife} with the {opt mse} option after {cmd:svyset}ing
     {cmd:iweight}s with {opt strata()} resulted in incorrect standard errors.
     This problem has been fixed.

{p 4 9 2}
{* enhancement}
11.  {helpb xthtaylor} no longer requires the user to specify both endogenous
     time-invariant variables and endogenous time-varying variables; users may
     now specify endogenous time-invariant variables and/or endogenous
     time-varying variables.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
12.  {helpb asmprobit} with unbalanced data and the BHHH optimization
     technique, {cmd:tech(bhhh)}, did not work properly and typically did not
     converge.  This problem has been fixed.

{p 4 9 2}
{* fix}
13.  Date values in Stata should be integers.  Given noninteger values,
     however, date functions and date formats rounded toward 1jan1960.  Now
     they always round down (toward the past).

{p 4 9 2}
{* enhancement}
14.  Mata has the following new features:

{marker matastruct}{...}
{p 9 13 2}
    A.  Mata now has structures (see {helpb m2_struct:[M-2] struct}), which
        will be of special interest to those writing large, complicated
        systems.  Because of the change, the format of {cmd:.mlib} libraries
        is different.  There is no backward-compatibility issue -- you do not
        need to recompile old code -- you *NEVER* need to recompile old code.
        However, because of the format change, you will not be able to add new
        members to old libraries.  Libraries cannot contain a mix of old and
        new code.  To add new members, you must first rebuild the old library.

{marker matatypecheck}{...}
{p 9 13 2}
    B.  Mata now engages in much more thorough type checking, and produces
        better code, for those who explicitly declare arguments and variables.
        As before, declaration is optional.  However, if you make explicit
        declarations, old code may not compile because Mata detects problems
        it previously could not.  As an example, assigning a string result to
        a variable explicitly declared as {cmd:real} is no longer allowed.  If
        you have old code with such problems, either change the variable's
        declaration to {cmd:transmorphic} or introduce a new variable to fix
        the problem properly.

{p 9 13 2}
    C.  Mata now includes all 29 Stata date functions; see
        {helpb mf_date:[M-5] date()}.

{p 4 9 2}
{* fix}
15.  Mata had the following fixes:

{p 9 13 2}
    A.  The first time Mata was invoked after launching Stata, if the first
        thing typed into Mata was a double quote character and there was no
        matching close quote, Stata crashed.  This problem has been fixed.

{p 9 13 2}
    B.  Mata function {helpb mf_ascii:ascii()} returned negative values for
        the extended ASCII characters rather than returning values in the
        range 128 to 255.  This problem has been fixed.

{p 9 13 2}
    C.  Mata functions {helpb mf_fopen:fread()} and {helpb mf_fopen:_fread()}
        caused Mata to issue a stack-overflow error.  This problem has been
        fixed.

{p 9 13 2}
    D.  Mata function {cmd:regexr()} did not allow replacement with
        an empty string (for deletions) and did not allow substitutions on
        strings shorter than 10 characters.  Both problems have been fixed.

{p 9 13 2}
    E.  Mata {help m2_op_logical:comparison operator} {cmd:>=} was treated the
        same as {cmd:>} for string comparisons.  This problem has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb merge}, specified with match variables, caused Stata to crash when
     the master dataset had no observations.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
17.  {helpb net:net install} and {helpb net:net get} now accept a {cmd:force}
     option, which specifies that the downloaded files replace existing files
     if any of the files already exist, even if Stata thinks all the files are
     the same.

{p 4 9 2}
{* fix}
18.  PNG (Portable Network Graphics) files produced by {helpb graph export} on
     64-bit systems could contain valid image data but an invalid checksum on
     that data.  This could cause some third-party applications to have
     problems displaying the PNG files.  This problem has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb use} did not clear the previous sort list when a {it:varlist} was
     specified.  This problem has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb xtcloglog}, {helpb xtintreg}, {helpb xtlogit}, {helpb xtpoisson},
     {helpb xtprobit}, and {helpb xttobit} used single precision instead of
     double precision storage for the log likelihood.  This problem has been
     fixed.

{p 4 9 2}
{* fix}
21.  {helpb xtintreg} and {helpb xttobit} results were not as precise as they
     could have been because of inaccuracy in the calculation of the
     derivatives of the log likelihood.  This problem has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
22.  {helpb odbc load} now imports the ODBC bit data type as Stata byte.
     Previously bits were imported as Stata integers.  This change reduces the
     memory needed to import data.

{p 4 9 2}
{* enhancement}
23.  Alt-Tab functionality and focusing of the Command window has been
     improved for nondefault layouts.

{p 4 9 2}
{* fix}
24.  New layouts are now saved properly when issuing the {helpb exit:exit}
     command.

{p 4 9 2}
{* fix}
25.  Under Windows 98, closing the Data Editor caused Stata to crash. This
     problem has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
26.  You may now paste multiple lines of text into the Command window.  Stata
     executes each line of text that is terminated by a carriage return.  If a
     line of text does not end in a carriage return, it is simply pasted into
     the Command window.  Any errors in the lines of text that are executed do
     not prevent subsequent lines from executing, which can cause unintended
     results.  As such, this setting is off by default, which means that only
     the first line of text is pasted into the Command window and is not
     executed.

{p 4 9 2}
{* fix}
27.  Stata now uses very little of the processor while Mata is idling in
     interactive mode.

{p 4 9 2}
{* fix}
28.  Stata now prevents multiple lines of text from being pasted into an edit
     control from a programmable dialog.  Only the first line of text is
     pasted.  Pressing the Home or End key in an edit control of a
     programmable dialog now moves the selection to the beginning or end,
     respectively, of the edit control.

{p 4 9 2}
{* fix}
29.  Stata's Do-file Editor tiles new Do-file Editor windows 20 pixels to the
     right and 20 pixels below the last moved or created Do-file Editor
     window.  However, a new Do-file Editor window could potentially be tiled
     off the screen if the last window is too close to the right edge or
     bottom of the screen.  Stata now starts over from the top-left corner of
     the screen if a new Do-file Editor window is too close to the right edge
     or bottom of the screen.  Also, Do-file Editor, Viewer, and Graph windows
     will now tile properly on multiple displays.  Stata previously always
     tiled new windows on the primary display rather than the display in which
     the last window was located.

{p 4 9 2}
{* fix}
30.  Pressing Return in the Data Editor's Edit dialog inserted a carriage
     return into the currently active edit control.  This problem has been
     fixed.

{p 4 9 2}
{* fix}
31.  The 20jan2006 executable update, when run on a PowerPC-based Mac, would
     require a G4 processor or better (this limitation did not affect Stata
     when run on an Intel-based Mac).  Stata will now run on any PowerPC
     computer that supports Mac OS X just like it did prior to the 20jan2006
     update.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* fix}
32.  If the main Stata window was resized to smaller than the default, it
     still opened at the default window size the next time Stata was launched.
     This problem has been fixed.

{p 4 9 2}
{* fix}
33.  Stata now prevents multiple lines of text from being pasted into an edit
     control from a programmable dialog.  Only the first line of text is
     pasted.

{p 4 9 2}
{* fix}
34.  The Do-file Editor could crash if there was no carriage return on the
     last line of the do-file.  This problem has been fixed.


{hline 8} {hi:update 27feb2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 6(1).

{p 5 9 2}
{* fix}
2.  {helpb bstat} always reported 95% confidence intervals even when the
    {opt level()} option was specified.  This problem has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb cs} exited with an error when {opt by()} contained more than one
    by-variable, and option {opt rd} was specified.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
4.  {helpb regress_postestimationts##dwatson:estat dwatson} could produce
    erroneous results when used after a command that performed a regression
    that included temporary variables.  Now an error message is produced.

{p 5 9 2}
{* fix}
5.  {helpb gladder} and {helpb qladder} did not apply user-specified
    {help schemes} to individual plots.  This problem has been fixed.

{p 5 9 2}
{* enhancement}
6.  Mata function {helpb mf_cat:cat()} now executes faster on large
    files.

{p 5 9 2}
{* fix}
7.  {helpb merge} was documented as allowing {cmd:uniqu} as a valid
    abbreviation for both {cmd:unique} and {cmd:uniqusing}.  The help file now
    documents that {cmd:uniqu} is an abbreviation only for {cmd:unique}.

{p 5 9 2}
{* fix}
8.  {helpb mfx:mfx, eyex} and {cmd:mfx, dyex} would report negative standard
    errors for marginal effects if the value of the x variable was negative.
    This problem has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb ml} now saves {cmd:e(k_eq_model)}, the number of equations to
    include in a model Wald test, even when {opt lf0()} is specified.

{p 4 9 2}
{* fix}
10.  {helpb permute} with the {opt left} option did not count all cases where
     replicate values were less than or equal to the observed value of the
     test statistic.  This problem has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb pksumm} sometimes incorrectly reported the error 'follow-up times
     are different for each patient'.  This problem has been fixed.

{p 4 9 2}
{* fix}
12.  {cmd:predict} after {helpb logit_postestimation##predict:logit} and
     {helpb probit_postestimation##predict:probit} reported an error when an
     independent variable was dropped because of collinearity.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb xtcloglog_postestimation##predict:predict}, after
     {helpb xtcloglog}, exited with a file-not-found error.  This problem has
     been fixed.

{p 4 9 2}
{* fix}
14.  {helpb xtreg_postestimation##predict:predict, xbu} after
     {helpb xtreg:xtreg, fe} failed if any of the regressors contained
     time-series operators.  This problem has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb predictnl} after {helpb ologit} exited with an error when the
     special {cmd:predictnl} function {opt predict()} was specified.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb recode}'s {cmd:min} element replaced a variable's value with
     missing when the {helpb if} qualifier was specified and no observations
     met the {cmd:if} criterion.  This problem has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb stptime} exited with a syntax error when an {helpb if} qualifier
     containing strings was specified.  This problem has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb "svy: tabulate twoway"} would report tests of independence when
     the table had a zero margin in a column beyond the number of rows.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb xtlogit} and {helpb xtprobit} did not accept constraints on
     {cmd:[lnsig2u]_cons}.  This problem has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb pwcorr} with perfectly correlated data now returns correct
     significance values.


{hline 8} {hi:update 20jan2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb nestreg} exited with an error when a block of variables was
    preliminarily dropped from the model specification.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
2.  {helpb stepwise} exited with an error when a term consisting of a single
    variable was preliminarily dropped from the model.  This problem has been
    fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* enhancement}
3.  The maximum number of programmable menu items that can be added to Stata
    has been increased from 1,000 to 1,250.

{p 5 9 2}
{* fix}
4.  {helpb asmprobit}'s GHK simulator generated too many uniform numbers in
    the simulation.  This problem has been fixed.

{p 5 9 2}
{* fix}
5.  {help class:Class member programs} were not using the version number
    specified at the top of a class-definition file.  This problem has been
    fixed.

{p 5 9 2}
{* enhancement}
6.  {helpb confirm:confirm format} is a new command that allows formats to be
    verified.  Optionally, you can confirm that the given format is of a
    particular type: {cmd:numeric}, {cmd:string}, {cmd:date}, or {cmd:ts}.

{p 5 9 2}
{* fix}
7.  An expression evaluated by a command issued in a loop with an
    {cmd:`=}{it:exp}{cmd:'} on the initial loop command line could return
    missing value ({cmd:.}) even when it should not.  This problem has been
    fixed.

{p 5 9 2}
{* fix}
8.  {helpb filefilter} used on files containing embedded NULL characters in
    certain positions sometimes caused the filters to be ignored for a portion
    of the file following the NULL before eventually resuming correct
    filtering.  This problem has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb graph box}, when specified with only a single variable that did not
    have a value label, left the y-axis untitled.  In such cases, the y-axis
    will now be titled with the variable name.

{p 4 9 2}
{* enhancement}
10.  {helpb graph twoway} now allows you to create custom axis ticks and
     labels that have a different appearance (color, size, tick length, etc.)
     from the other ticks and labels on the axis.  Such custom ticks can be
     used to emphasize points in the scale, such as important dates, physical
     constants, or other special values.  See the new {cmd:custom} suboption
     of {{cmd:y|x|t}}{cmd:label()} in {it:{help axis_label_options}}.

{p 4 9 2}
{* enhancement}
11.  {helpb graph twoway} has new options, {cmd:yoverhangs} and
     {cmd:xoverhangs}, that attempt to adjust the graph region margins to
     prevent long labels on the y- or x-axes from extending off the edges of
     the graph; see {it:{help advanced_options}}.

{p 4 9 2}
{* enhancement}
12.  {helpb graph twoway} has a new suboption, {cmd:norescale}, to the options
     {{cmd:y|x|t}}{cmd:label()}.  This suboption specifies that the ticks and
     labels specified in the {{cmd:y|x|t}}{cmd:label()} option be placed
     directly on the graph without rescaling the axis or associated plot
     region for the new values; see {it:{help axis_label_options}}.

{p 4 9 2}
{* fix}
13.  {helpb help}, under rare conditions when accessing help files across a
     network, could be slow; this problem has been fixed.

{p 4 9 2}
{* enhancement}
14.  {helpb inspect} output has been slightly modified.  All output on the
     right-hand side has been shifted to the left three spaces so that the
     "Nonintegers" heading is placed on one line.

{p 4 9 2}
{* fix}
15.  {helpb label define}, followed by something that was not a valid label
     name, caused a memory leak that could result in Stata's incorrectly
     reporting an 'unexpectedly out of memory' error with a return code of
     9710.  This problem has been fixed.

{p 4 9 2}
{* enhancement}
16.  {helpb lnnormal()} and {helpb lnnormalden()} are new functions that
     provide the natural logarithm of the cumulative normal distribution
     function and the normal density function, respectively.

{p 4 9 2}
{* enhancement}
17.  The new extended macro function {bf:{help extended_fcn:adosubdir}}
     returns the subdirectory in which Stata would search for a file on the
     {help adopath:ado-path}.

{p 4 9 2}
{* enhancement}
18.  Mata has the following new functions:

{p 9 13 2}
    A.  {bf:{help mf_adosubdir:adosubdir()}} returns the subdirectory in which
        Stata would search for a file on the {help adopath:ado-path}.

{p 9 13 2}
    B.  {helpb mf_ghk:ghk()} provides a Geweke-Hajivassiliou-Keane multivariate
        normal simulator.

{p 9 13 2}
    C.  {helpb mf_halton:halton()}, {helpb mf_halton:_halton()}, and
        {helpb mf_halton:ghalton()} compute Halton and Hammersley sets.

{p 9 13 2}
    D.  {helpb mf_normal:lnnormal()} and {helpb mf_normal:lnnormalden()} find
        the logarithm of the cumulative normal and of the density function,
        respectively.

{p 9 13 2}
    E.  {helpb mf_pathsearchlist:pathsearchlist()} returns a row vector of
        full paths/filenames specifying all the locations Stata will search
        for a named file along the official Stata {help adopath:ado-path}.

{p 4 9 2}
{* fix}
19.  Mata also has the following changes:

{p 9 13 2}
    A.  Mata's logical negation (not) operator
        {bf:{help m2_op_logical:!}} treated missing values incorrectly.  A
        missing value is supposed to be treated as meaning true just like any
        other nonzero value.  Thus if {cmd:x==.}, {cmd:!x} is {cmd:0}.
        Instead, {cmd:!x} returned missing ({cmd:.}).  This problem has been
        fixed.

{p 9 13 2}
    B.  Mata's {helpb mf_printf:printf()} and {cmd:sprintf()} functions
        left-justified strings printed with {cmd:%#s} formats and
        right-justified strings with {cmd:%-#s} formats.  This effect was the
        reverse of what was correct and has been fixed.

{p 9 13 2}
    C.  Mata/Stata interface functions {helpb mf_st_local:st_local()},
        {helpb mf_st_global:st_global()},
        {helpb mf_st_numscalar:st_numscalar()}, and
        {helpb mf_st_strscalar:st_strscalar()}, when used to store something
        more than 65,532 times in a tight loop, could cause a Mata stack
        overflow error.  This problem has been fixed.

{p 9 13 2}
    D.  On 64-bit computers, Mata restricted matrix size such that
        r*c*8 < 2^31 for regular matrices and r*c*16 < 2^31 for complex
        matrices even when more than 2 GB of memory was available.  This
        problem has been fixed, and matrices larger than 2 GB may now be used
        in Mata on 64-bit computers.

{p 4 9 2}
{* fix}
20.  {helpb odbc} commands with extended variable lists did not respect quotes
     or compound quotes to allow nonalphanumeric variable names to be
     imported.  This problem has been fixed.

{p 4 9 2}
{* fix}
21.  Exporting a graph with the {cmd:width()} or {cmd:height()} options caused
     Stata to crash if the graph window was closed.  Stata now prevents you
     from exporting a graph when the graph window is closed.

{p 4 9 2}
{* fix}
22.  {helpb _qreg}, a programmer's routine, skipped observations when
     {it:{help if}} or {it:{help in}} qualifiers were specified.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
23.  The {helpb regexr()} function and the Mata {cmd:regexr()}
     function did not allow a string to be replaced with an empty string.  For
     example:

{p 13 17 2}
	{cmd:. display regexr("mystring", "mystring", "")}

{p 9 9 2}
     displayed "mystring" instead of "".  This problem has been fixed.

{p 4 9 2}
{* enhancement}
24.  {helpb tabulate_twoway:tabulate, exact}, for computing Fisher's exact
     test, now allows larger tables, and an enumeration log is displayed.  New
     option {opt nolog} suppresses the log.

{p 4 9 2}
{* enhancement}
25.  {helpb twoway lfit} and {helpb twoway qfit} can now pick up value labels
     to annotate the x-axis by using the existing option
     {cmd:mlabel(, valuelabel)}; see {it:{help axis_label_options}}.

{p 4 9 2}
{* enhancement}
26.  A contextual menu item has been added to the Viewer that closes all
     viewers except the current one.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
27.  Multiple do-file editors may now be opened from a single open dialog.
     The first file goes to the currently open do-file editor, whereas
     subsequent files open in new editor windows.

{p 4 9 2}
{* fix}
28.  The most recently used file information was not saved properly when
     exiting Stata with the {helpb exit} command.  This problem has been
     fixed.

{p 4 9 2}
{* fix}
29.  The Variables Property dialog has been modified to set the focus to the
     variables edit field and to set its text selection to all text.

{p 4 9 2}
{* fix}
30.  Specifying a {cmd:width()} of less than 115 pixels when exporting a graph
     would not result in a bitmap image with the specified width.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
31.  When Alt-Tabbing between windows and the main Stata window, focus will
     automatically be sent to the Command window.  Previously, focus was sent
     only after alphanumeric keystrokes were detected.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
32.  You can select multiple files from the Open dialog and Do dialog.
     Selecting multiple do-files from the Open dialog will open all files in
     separate Do-file Editor windows.  Selecting multiple do-files from the Do
     dialog will {helpb do} do-files in the order that they were selected.
     Selecting multiple datasets and graphs will open only the first file
     selected.

{p 4 9 2}
{* enhancement}
33.  Horizontal scroll wheel support has been added to the Data Editor and
     Do-file Editor.  You may now use an Apple Mighty Mouse scroll wheel to
     scroll in any direction.

{p 4 9 2}
{* enhancement}
34.  The menu item Tools > Back and its keyboard shortcut Cmd-[ have been
     added to the Viewer to match the keyboard shortcut for Back in Safari.
     However, Cmd-[ had been previously reserved for Edit > Shift Left (to
     shift text one tab stop to the left in the Do-file Editor).  To avoid any
     conflicts, the keyboard shortcuts for Shift Left and Shift Right have now
     been changed to include the shift key (press Cmd-Shift-[ to shift text
     left and Cmd-Shift-] to shift text right).

{p 4 9 2}
{* enhancement}
35.  Stata now displays the current number of columns and rows of the Results,
     Viewer, and Do-file Editor windows as they are being resized.

{p 4 9 2}
{* fix}
36.  Stata no longer displays window transition effects when it is in the
     background.

{p 4 9 2}
{* fix}
37.  Pressing the keyboard shortcut Cmd-W did not close the Review window.
     This problem has been fixed.

{p 4 9 2}
{* fix}
38.  In some cases, clicking the Back button in the Viewer would result in the
     Viewer toolbar's being overwritten with the Viewer's output.  This
     problem has been fixed.

{p 4 9 2}
{* fix}
39.  In some cases, a single line in the Results window would appear chopped
     after output had scrolled.  This problem has been fixed.

{p 4 9 2}
{* fix}
40.  Typing {cmd:exit} from the Command window exited Stata without prompting
     to save any unsaved changes in the Do-file Editor.  This problem has been
     fixed.  Type {cmd:exit, clear} to exit Stata without prompting.

{p 4 9 2}
{* fix}
41.  Stata(console) for Mac failed to perform an {cmd:update swap} after
     an executable had been downloaded.  This problem has been fixed.
     However, current Stata(console) for Mac users will have to manually
     download the updated executable with the fix from
     {browse "http://www.stata.com/support/mac/"}.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* enhancement}
42.  Stata now displays the current number of columns and rows of Viewer
     windows as they are being resized.

{p 4 9 2}
{* enhancement}
43.  Pressing Ctrl-W now closes the Viewer.


{hline 8} {hi:update 12jan2006} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb cnsreg} has the new {opt mse1} option and accepts {opt iweight}s.

{p 5 9 2}
{* enhancement}
2.  Estimation commands with model Wald tests composed of more than just the
    first equation now save the number of equations in the model Wald test in
    {cmd:e(k_eq_model)}.

{p 5 9 2}
{* fix}
3.  {helpb kwallis} now exits with an error when there are no observations to
    perform the calculations or when fewer than two populations are specified.

{p 5 9 2}
{* enhancement}
4.  {helpb ml} now saves the number of equations used to compute the model
    Wald test (from the {opt waldtest(#)} option) in {cmd:e(k_eq_model)}.

{p 5 9 2}
{* fix}
5.  {helpb ml display} after {helpb ml}-based user-written Stata 9 estimation
    commands that were prefixed with {helpb svy} did not display the
    coefficient table header properly.  This problem has been fixed.

{p 5 9 2}
{* enhancement}
6.  {helpb ml score} has the new {opt missing} option.

{p 5 9 2}
{* fix}
7.  {helpb pkexamine} has the following changes:

{p 9 13 2}
    A.  {cmd:pkexamine} with an {it:{help if}} condition that excluded the
        observation with zero time and concentration did not use the proper
        zero time and concentration in the computations.  This problem has
        been fixed.

{p 9 13 2}
    B.  {cmd:pkexamine} no longer adds an observation with zero time and zero
        concentration when the dataset has an observation with nonzero
        concentration at time zero.

{p 9 13 2}
    C.  {cmd:pkexamine} exited with an error message when {opt fit()}
        contained the total number of observations.  This problem has been
        fixed.

{p 5 9 2}
{* fix}
8.  {cmd:predict} after {helpb ologit_postestimation##predict:ologit} and
    {helpb oprobit_postestimation##predict:oprobit} reported an error when the
    correct number of new variable names was specified for computing multiple
    equation-level score variables from a constant-only model.  This problem
    has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb qreg} did not set {cmd:e(wtype)} and {cmd:e(wexp)} when weights
    were used.  This problem has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb suest} after {helpb intreg} reported an error when there were
     missing values in one or both of the dependent variables.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb suest} produced incorrect variance estimates when used with
     {helpb cnsreg}.  This problem has been fixed.


{hline 8} {hi:update 13dec2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  Errors in a couple of help files have been corrected.


{hline 8} {hi:update 12dec2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 5(4).

{p 5 9 2}
{* enhancement}
2.  {helpb adoupdate} is a new command for keeping the user-written ado-files
    you have installed from {it:The Stata Journal}, the SSC, and other sources
    up to date.

{p 5 9 2}
{* fix}
3.  {helpb bootstrap} did not pass the {opt nodrop} option to
    {helpb jackknife} when both the {opt nodrop} and {opt bca} options were
    specified.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb estat} exited with an error message after {helpb arima} if the
    {opt condition} option was specified.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb glm} ignored the {cmd:exposure()} option.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb histogram} occasionally reported one fewer bin than the number
    produced in the graph.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb jackknife} reported a "last estimates not found" error when called
    as a prefix to a command without arguments.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb jackknife} reported an "options not allowed" error when called as a
    prefix to a command that does not allow options even when no options were
    specified.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb lrtest} output inappropriately wrapped to a new line if the names
    of the tested models were long.  This has been fixed.

{p 4 9 2}
{* enhancement}
10.  {helpb nl} now uses the format {it:/param} in listing the parameters in
     the coefficient table.

{p 4 9 2}
{* fix}
11.  {helpb nl}, when used with weights, reported an incorrect sum of weights
     and residual deviance.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb recode}'s {cmd:max} element treated missing values as the maximum
     value of a variable if the variable contained all missing values.  This
     has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb stphplot} did not display the legend properly in certain
     circumstances.  This has been fixed.

{p 4 9 2}
{* enhancement}
14.  {helpb suest} now has option {opt svy} for applying the current
     {helpb svyset} characteristics to the variance calculation.

{p 4 9 2}
{* fix}
15.  The 15sep2005 update changed some low-level graphics calls.  In rare
     cases, the previous low-level graphics calls were not properly
     interpreted by some HP printer drivers, causing the entire graph to be
     printed black.  We have confirmed with users who had experienced the
     problem that the 15sep2005 update allows these drivers to render the
     graphs correctly.

{p 9 9 2}
     This problem also occurred when copying and pasting into Microsoft Office
     on the Mac platform.  The 15sep2005 update fixed this problem.


{hline 8} {hi:update 11nov2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb nestreg} exited with an error when used with a {helpb survey}
    estimation command other than {helpb "svy: regress"}.  This has been fixed.


{hline 8} {hi:update 10nov2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb adjust} after {helpb ivprobit} can now calculate adjusted
    probabilities when the maximum likelihood estimator is used.

{p 5 9 2}
{* fix}
2.  {helpb bootstrap} with the {cmd:bca} option exited with error when the
    user specified names for bootstrap statistics.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb bootstrap_postestimation:estat bootstrap} reported an invalid
    subcommand error when used after {helpb mean}, {helpb proportion},
    {helpb ratio}, and {helpb total} even when {cmd:vce(bootstrap)} was
    specified.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb ds} sometimes failed when certain values were specified together in
    the {cmd:indent()} and {cmd:skip()} options and the linesize was smaller
    than needed.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb glm} saved an invalid {cmd:e(power)} when user-defined links used
    the {cmd:SGLM_p} macro for non-standard purposes (such as holding a
    variable name instead of a number).  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ivreg} ignored the {cmd:beta} option.  This has been fixed.

{p 5 9 2}
{* enhancement}
7.  {helpb nestreg} is a new {help prefix} command for reporting nested model
    comparison tests (also known as block or hierarchical regression
    analysis).

{p 5 9 2}
{* enhancement}
8.  The dialog for {helpb stepwise} has been modified so that only the weights
    that are accepted for a specific command are presented.

{p 5 9 2}
{* fix}
9.  {helpb xtgee_postestimation##predict:predict} exited with an error after
    {helpb xtgee} with the {cmd:link(nbinomial)} option. This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb xtdes} exited abruptly if the time variable had fewer than two
     distinct nonmissing values.  Now a more informative error message is
     issued.


{hline 8} {hi:update 20oct2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb merge}, when specified with no {cmd:using} files, gave an incorrect
    error message.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb merge} failed if any of the {cmd:using} files were located on a
    network drive.  This has been fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb nl} has received the following enhancements.  The previous behavior
    of {cmd:nl} is preserved by setting {helpb version} to one earlier than
    9.1.

{p 9 13 2}
    A.  {helpb mfx} can be used after {cmd:nl} to obtain marginal effects.

{p 9 13 2}
    B.  {cmd:nl} now supports the {opt vce(vcetype)} option.  Allowed
        {it:vcetype}s include {cmd:bootstrap}, {cmd:jackknife}, {cmd:robust},
        and three heteroskedasticity- and autocorrelation-consistent (HAC)
        variance estimators.

{p 9 13 2}
    C.  {helpb nl postestimation##predict:predict} after {cmd:nl} now allows
        you to obtain the probability that the dependent variable lies within
        a given interval, the expected value of the dependent variable
        conditional on it being censored, and the expected value of the
        dependent variable conditional on it being truncated.  These
        predictions assume that the error term is normally distributed.

{p 9 13 2}
    D.  The iteration log now reports the new sum of squares after each
        iteration is complete instead of the old value.

{p 9 13 2}
    E.  The coefficient table now reports each parameter as its own equation,
       analogous to how {helpb ml} reports single-parameter equations.

{p 9 13 2}
    F.  {cmd:nl} no longer reports an overall model F test because the test
        that all parameters other than the constant are jointly zero may not
        be appropriate in arbitrary nonlinear models.

{p 9 13 2}
    G.  The value of the log-likelihood function assuming i.i.d. normal errors
        is saved in {cmd:e(ll)}, and likelihood-ratio tests can be performed
        after estimation using {helpb lrtest}.

{p 5 9 2}
{* fix}
4.  {helpb qreg}'s {opt wlsiter(#)} option with {it:#} > 1 did not change the
    coefficients compared with when {it:#} was 1.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb stepwise} incorrectly exited with an error when adding back a term
    that was previously removed for backward stepwise regression (when using
    options {opt pr()} and {opt pe()}).  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb stepwise} incorrectly exited with an error when performing forward
    hierarchical selection (when using options {opt pe()} and
    {opt hierarchical}).  This has been fixed.


{hline 8} {hi:update 05oct2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb asmprobit} with the {cmd:cluster()} option set {cmd:e(wtype)} to
    {cmd:pweight} causing an error in
    {helpb asmprobit_postestimation##estatmfx:estat mfx} after
    {cmd:asmprobit}.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb egen}'s {cmd:rowtotal()} function, when passed a variable list
    containing a wildcard followed by numbers, such as "{cmd:*00}", sometimes
    calculated an incorrect sum due to the inclusion of a temporary variable.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb svy brr} with the {opt fay()} option produced incorrect variance
    estimates.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb tabodds} with the {cmd:or} and {cmd:cornfield} options failed when
    the {it:var_case} (case variable) contained missing values.  This has been
    fixed.


{hline 8} {hi:update 19sep2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
{* fix}
1.  {helpb codebook:codebook} has new option {cmd:dots} for use with the
    {cmd:compact} option.  {cmd:dots} displays a dot for each variable
    processed before displaying the compact codebook table.  This will
    interest those working interactively with large datasets.  Additionally,
    the {cmd:compact} option, introduced in the 15sep2005 update, displayed
    counts for string variables before displaying the correct compact codebook
    table.  The spurious output is now suppressed.

{p 5 9 2}
{* fix}
2.  {helpb graph export}, when specified with an extremely small pixel size
    for the {cmd:width()} or {cmd:height()} options sometimes caused Stata to
    crash.  Stata now limits the pixel size range to be between 8 and 16,000.

{p 5 9 2}
{* fix}
3.  {helpb xtpoisson} sometimes labeled the variables in the output
    incorrectly when variables were dropped from the estimation.  This has
    been fixed.


{hline 8} {hi:update 15sep2005} {hline}

    {title:What's new in release 9.1 (compared with release 9)}

{pstd}
Highlights for release 9.1 include the following:

{p 8 11 2}
{cmd:o}{space 2}Multiple {helpb log} files may be opened simultaneously.
See {help whatsnew9##multiplelogs:item 39} below.

{p 8 11 2}
{cmd:o}{space 2}Survey linearization is now 2 to 100 times faster, the larger
multiplier applying to large datasets with many sampling units.
See {help whatsnew9##svylinearization:item 46} below.

{p 8 11 2}
{cmd:o}{space 2}The string length {help limits:limit} has been increased to
244 for Intercooled and Small Stata to match {help SpecialEdition:Stata/SE}.
See {help whatsnew9##strlen244:item 32} below.

{p 8 11 2}
{cmd:o}{space 2}Up to 300 estimation results may be stored.
See {help whatsnew9##eststore300:item 34} below.

{p 8 11 2}
{cmd:o}{space 2}{help Mata} has a new permutation function making it easier to
program exact permutation tests.
See {help whatsnew9##matapermute:item 41 D} below and the examples in
{helpb mata cvpermute():help mata cvpermute()}.

{p 8 11 2}
{cmd:o}{space 2}{help Mata} has several other new features, including new
string, regular expression, and binary I/O functions.
See {help whatsnew9##matanewfuncs:item 41} below.

{p 8 11 2}
{cmd:o}{space 2}Graphs exported to PNG or TIFF bitmap format may now have
their sizes specified, allowing the resolution to be greater than screen
resolution.
See {help whatsnew9##pngtiffsize:item 36} below.

{p 8 11 2}
{cmd:o}{space 2}There is a new command for computing marginal effects after an
alternative-specific multinomial probit model.
See {help whatsnew9##asmprobitmfx:item 3 B} below.

{p 8 11 2}
{cmd:o}{space 2}There is now a console version of
{help SpecialEdition:Stata/SE} for the Mac.
See {help whatsnew9##consolemac:item 63} below.

{p 8 11 2}
{cmd:o}{space 2}Collecting statistics across a by list using the
{helpb statsby} command is now allowed in more situations, including with
postestimation commands.
See {help whatsnew9##statsbyenhanced:item 21} below.

{p 8 11 2}
{cmd:o}{space 2}Fay's adjustment is now allowed with balanced repeated
replications (BRR) for complex survey data.
See {help whatsnew9##svybrrfay:item 25 A} below.

{pstd}
We recommend that you set version to {cmd:version 9.1} at the top of do-files
and ado-files.  {cmd:version 9.1} improves the default behavior for
{helpb permute} and {helpb xtreg}.  See help {helpb version}.


    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 5(3).

{p 5 9 2}
{* fix}
2.  Some maximum likelihood estimation commands (such as {helpb arima},
    {helpb nbreg}, {helpb streg}, and {helpb xtnbreg}) ignored constraints
    when there were no predictors in the model.  This has been fixed.

{p 5 9 2}
{* enhancement}
{* fix}
3.  {helpb asmprobit} has the following changes.

{p 9 13 2}
    A.  {cmd:asmprobit} has a new default covariance parameterization and a
        new option, {cmd:structural}.  The new default parameterization
        estimates the covariance of the alternatives differenced with the base
        alternative.  For a J-alternative model, the differenced covariance is
        a J-1 x J-1 matrix with J(J-1)/2 - 1 estimable parameters, where the
        variance of the latent errors for the scale alternative minus the base
        alternative is fixed to 2.

{p 13 13 2}
        {cmd:structural} specifies that the structural J x J covariance
        parameterization be used, which sets J-1 of the correlations to zero
        and fixes the base and scale variances to 1.

{marker asmprobitmfx}{...}
{p 9 13 2}
    B.  {helpb asmprobit postestimation##estatmfx:estat mfx} is a new
        postestimation command for computing marginal effects after
        {cmd:asmprobit}.  The {cmd:Postestimation} /
        {cmd:Marginal effects or elasticities} menu displays the
        {cmd:estat mfx} dialog after an {cmd:asmprobit} has been fitted.

{p 9 13 2}
    C.  When called with {helpb pweight}s, {cmd:asmprobit} incorrectly stored
        {cmd:iweight}s instead of {cmd:pweight}s in {cmd:e(wtype)}.  This has
        been fixed.

{p 9 13 2}
    D.  {cmd:asmprobit} did not allow the constant-only model.  Now it does.

{p 9 13 2}
    E.  Computing the likelihood for cases with only two alternatives had the
        alternative probabilities reversed.  If all cases had two
        alternatives, the signs of the estimated coefficients were reversed.
        If only some cases had two alternatives, estimates were inaccurate.
        This has been fixed.

{p 9 13 2}
    F.  {cmd:predict} after {cmd:asmprobit} mislabeled the predictions when
        one or more alternatives were excluded throughout the prediction
        dataset.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb biplot} with the option {cmd:separate} by default always places
    both subgraphs on common x- and y-scales.  Previously, the scales
    sometimes differed.

{p 5 9 2}
{* fix}
5.  {helpb bootstrap} exited with an error, complaining about time-series
    operators in the expression when an expression contained a numeric literal
    with a decimal.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb bootstrap} and {helpb jackknife} exited with an obscure error
    message when used with {helpb xtmixed}.  This has been fixed.

{p 5 9 2}
{* enhancement}
7.  {helpb codebook} has new option {cmd:compact} that produces a compact
    codebook with each line showing a variable name, number of observations,
    number of unique observations, mean, minimum, maximum, and variable label.

{p 5 9 2}
{* fix}
8.  The {dialog collapse:collapse dialog} has been improved.

{p 5 9 2}
{* fix}
9.  {helpb estimates table} with a long {it:namelist} labeled only the first
    few columns of estimation results.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb fracpoly} and {helpb mfp}, when used with {helpb glm}, ran an
     older version of {cmd:glm}.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb graph} when the range of values in the y- or x-dimension was very
     close to machine precision, but not exactly 0, sometimes entered an
     infinite loop, requiring that processing be manually broken.  This has
     been fixed.

{p 4 9 2}
{* fix}
12.  {helpb graph combine} with options {cmd:ycommon} and {cmd:xcommon} in
     rare cases did not produce combined graphs with the intended common axes.
     This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb graph set} did not recognize the PICT format for setting graphics
     exporting options.  This has been fixed.

{p 4 9 2}
{* enhancement}
14.  {helpb hausman} now supports the existing {cmd:sigmaless} and new
     {cmd:sigmamore} options after {cmd:xtreg}.  These options are
     particularly useful when comparing fixed- and random-effects regressions
     because they improve results in small to moderate samples by ensuring
     that the difference covariance matrix will be positive definite.

{p 4 9 2}
{* fix}
15.  {helpb svy jackknife} did not correctly count the number of observations
     in the estimation sample when the sampling weight variable contained
     zeros.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb logit}, {helpb probit}, and {helpb dprobit} allowed
     {helpb aweight}s, even though they were not documented and the resulting
     calculation had no meaningful interpretation.  When {helpb version} is
     set higher than 9.0, these commands now issue an error message when used
     with aweights.

{p 4 9 2}
{* enhancement}
17.  The {dialog matrix_input:matrix input dialog} now allows users to enter
     symmetric matrices by filling in the lower triangle.

{p 4 9 2}
{* fix}
18.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} exited
     with a syntax error when supplied with the {opt over()} option with more
     than 400 subpopulations.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb mprobit} has new option {cmd:probitparam} that scales the
     coefficients in the same way as {helpb probit}.  Also, {cmd:mprobit}
     coefficients had reversed signs when there were two alternatives (a
     probit model).  This has been fixed.

{p 4 9 2}
{* enhancement}
20.  {helpb permute} now uses two random uniform variables to generate Monte
     Carlo permutations of the values of the permute variable.  {cmd:permute}
     must be called under {helpb version} control in order to reproduce old
     results.

{marker statsbyenhanced}{...}
{p 4 9 2}
{* enhancement}
21.  {helpb statsby} has several enhancements.

{p 9 13 2}
    A.  {cmd:statsby} now works with postestimation commands.

{p 9 13 2}
    B.  {cmd:statsby} now works with commands that support neither
        {it:{help if}} nor {it:{help in}} (although it will be slower with
        such commands).

{p 9 13 2}
    C.  {cmd:statsby} has a new option {cmd:forcedrop} that forces all data to
        be dropped except the group samples.  This allows {cmd:statsby} to
        work with user-written commands that completely ignore {it:{help if}}
        and {it:{help in}} qualifiers.

{p 9 13 2}
    D.  {cmd:statsby} no longer clears estimation results when the command
        being run is not an estimation command.

{p 9 13 2}
    E.  {cmd:statsby} is now faster when used with most time-series datasets.

{p 4 9 2}
{* fix}
22.  {helpb stci} exited with an error message when one or more
     {it:{help twoway_options}} were supplied, even though the {opt emean} and
     {opt graph} options were specified.  This has been fixed.

{p 4 9 2}
{* fix}
23.  {helpb stcurve} exited with an error message when options {opt at()},
     {opt at1()}, and {opt at10()} were used together.  This has been fixed.

{p 4 9 2}
{* fix}
24.  {helpb stepwise} produced a "variable not found" error message when a
     variable name was an abbreviation of another variable name found earlier
     in the variable list.  This has been fixed.  Also, {helpb sw} with the
     Stata 8 syntax sometimes incorrectly exited with an error message if the
     estimation command dropped a variable due to nonestimability.  This has
     been fixed.

{p 4 9 2}
{* enhancement}
{* fix}
25.  {helpb svy} has several improvements.

{marker svybrrfay}{...}
{p 9 13 2}
    A.  {helpb svy brr} now allows the {opt fay()} option when using
        replication weight variables.  {cmd:svy brr} also saves the value of
        the Fay's adjustment in {cmd:e(fay)}.

{p 9 13 2}
    B.  {helpb "svy: tabulate"} now accepts string variables.

{p 9 13 2}
    C.  {helpb svy} did not correctly set {cmd:e(sample)} when there were
        missing values in the independent variables.  This has been fixed.

{p 9 13 2}
    D.  {helpb "svy: mlogit"}, when supplied with a dependent variable with
        value labels containing dots ({cmd:.}) or colons ({cmd::}),
        incorrectly exited with an error message.  This has been fixed.

{p 9 13 2}
    E.  {helpb "svy: proportion"}, when used with variables having value
        labels with the right quote character ("{cmd:'}"), incorrectly exited
        with an error message.  This has been fixed.

{p 9 13 2}
    F.  {helpb "svy: tabulate"} exited with an unhelpful error message when
        {helpb mata} did not have enough memory to perform the necessary
        calculations.  A better error message is now displayed.

{p 9 13 2}
    G.  {helpb "svy: tabulate oneway"}, when used with the {opt missing}
        option, dropped the correct "Total" margin and labeled the row for the
        missing value as the "Total".  This has been fixed.

{p 9 13 2}
    H.  Version 8 survey estimation commands ({cmd:svyregress},
        {cmd:svylogit}, ...) now provide a better error message when used with
        data that are {helpb svyset} under version 9.

{p 9 13 2}
    I.  {helpb svyset} did not return the name of the sampling weight variable
        in {cmd:r(wvar)} as documented in {hi:[SVY] svyset}.  This has been
        fixed.

{p 4 9 2}
{* fix}
26.  {helpb tsline} sometimes incorrectly exited with an error when the
     {opt tlabel()} option was supplied with integers but no date strings.
     This has been fixed.

{p 4 9 2}
{* fix}
27.  {helpb varwle} displayed missing values for some tests when the lags were
     not consecutive.  This has been fixed.

{p 4 9 2}
{* fix}
28.  {helpb xi} ignored the {opt noomit} option when it was called with
     {it:terms} after the comma.  This has been fixed.

{p 4 9 2}
{* fix}
29.  {helpb xtmixed}, when used with the maximize option {cmd:iterate()},
     did not issue the appropriate warning at the bottom of the output if
     the model failed to converge.  This has been fixed.

{p 4 9 2}
{* fix}
{* enhancement}
30.  {helpb xtreg} has the following improvements:

{p 9 13 2}
    A.  {cmd:xtreg, fe} adjusted the VCE for the within transform when
        {cmd:cluster()} was specified.  The cluster-robust VCE no longer
        adjusts for the within transform unless the new {cmd:dfadj} option is
        specified.

{p 9 13 2}
    B.  {cmd:xtreg, fe} and {cmd:xtreg, re} produced cluster-robust VCEs when
        the panels were not nested within the clusters.  In some cases this
        VCE is consistent, and in others it is not.  You must now specify the
        new {cmd:nonest} option to get a cluster-robust VCE when the panels
        are not nested within the clusters.

{p 9 13 2}
    C.  {cmd:xtreg, re} reported different between R-squared values from one
        run to another on identical datasets.  This has been fixed.

{p 4 9 2}
{* fix}
31.  {helpb xtregar:xtregar, fe} mislabeled variables when variables from the
     middle of the list of {it:indepvars} were dropped due to collinearity.
     This has been fixed.


    {title:Stata executable, all platforms}

{marker strlen244}{...}
{p 4 9 2}
{* enhancement}
32.  Intercooled and Small Stata now have the same maximum string length (244)
     as {help SpecialEdition:Stata/SE}.  See {help limits}.

{p 4 9 2}
{* fix}
33.  {helpb encode} encoded in reverse order for some platforms.  This has
     been fixed.

{marker eststore300}{...}
{p 4 9 2}
{* enhancement}
34.  {helpb estimates store} and {helpb _estimates hold} now allow up to 300
     estimation results to be stored.  The previous limit was 20.

{p 4 9 2}
{* fix}
35.  {helpb gettoken}'s {cmd:bind} option did not work properly if the first
     character of the string to be parsed was "{cmd:(}" or "{cmd:[}".  This
     has been fixed.

{marker pngtiffsize}{...}
{p 4 9 2}
{* enhancement}
36.  {helpb graph export} has new options {cmd:width()} and {cmd:height()} for
     specifying the width and height of a graph in pixels when exporting to
     PNG and TIFF bitmap formats.  If only the width or height is specified,
     Stata exports the graph with the requested dimension while maintaining
     the correct aspect ratio.

{p 4 9 2}
{* enhancement}
37.  {helpb include} is a new command similar to {helpb do} and {helpb run}
     for executing do-files, but it differs in that any local macros, changed
     settings, etc., created by executing the file are not dropped or reset
     when execution concludes.  Rather, results are just as if the commands
     appeared in the session or file that included the file.

{p 4 9 2}
{* enhancement}
38.  {helpb itrim()} is a new string function that replaces multiple,
     consecutive, internal spaces with a single space in strings.

{marker multiplelogs}{...}
{p 4 9 2}
{* enhancement}
39.  {helpb log} can now start multiple log files simultaneously.  See
     {helpb log} for full details.

{p 4 9 2}
{* fix}
40.  {helpb logistic}, {helpb logit}, and {helpb probit}, when used with the
     {helpb svy} prefix or with options {cmd:vce(bootstrap)} or
     {cmd:vce(jackknife)}, had the following fixes:

{p 9 13 2}
    A.  They did not display a note indicating when there were completely
        determined successes or failures.  This has been fixed.

{p 9 13 2}
    B.  They did not display a note indicating the presence of perfect
        predictors.  This has been fixed.

{p 9 13 2}
    C.  They did not correctly report on variables that were dropped due to
        collinearity.  This has been fixed.

{marker matanewfuncs}{...}
{p 4 9 2}
{* enhancement}
41.  {help mata:Mata} has several new functions:

{p 9 13 2}
    A.  {bf:{help mf_bufio:bufput()}} and {bf:{help mf_bufio:bufget()}} assist
        in performing binary-formatted I/O.

{p 9 13 2}
    B.  {bf:{help mf_byteorder:byteorder()}} is equivalent to Stata's
        {cmd:byteorder()} function.

{p 9 13 2}
    C.  Existing function {bf:{help mf_cat:cat()}} now takes optional second
        and third arguments specifying the beginning and ending lines of the
        file to read.

{marker matapermute}{...}
{p 9 13 2}
    D.  {bf:{help mf_cvpermute:cvpermute()}} returns all permutations of the
        values of a column vector {it:V}, one at a time.  If {it:V}=(1\2\3),
        there are six permutations:  (1\2\3), (1\3\2), (2\1\3), (2\3\1),
        (3\1\2), and (3\2\1).  If {it:V}=(1\2\1), there are three
        permutations:  (1\1\2), (1\2\1), and (2\1\1).

{p 9 13 2}
    E.  {cmd:regexm()}, {cmd:regexr()}, and
        {cmd:regexs()} are regular expression functions
        corresponding to the Stata functions with the same name.

{p 9 13 2}
    F.  {bf:{help mf_stataversion:stataversion()}} returns the version of
        Stata that you are running.
        {bf:{help mf_stataversion:statasetversion()}} allows setting the
        version.

{p 9 13 2}
    G.  {bf:{help mf_strtrim:stritrim()}} replaces multiple, consecutive,
        internal spaces with a single space in strings.

{p 9 13 2}
    H.  {bf:{help mf_strtoreal:strtoreal()}} converts strings to numeric
        values.

{p 4 9 2}
{* fix}
42.  {help mata:Mata} function {helpb mf_cat:cat()} produced an extra empty
     line in the rare case when the input stream had "{cmd:\r\n}" and the
     "{cmd:\r}" landed at the end of the internal buffer.  This has been
     fixed.

{p 4 9 2}
{* fix}
43.  {helpb ologit} and {helpb oprobit}, when used with the {helpb svy} prefix
     or with options {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, did not
     display a note indicating when there were completely determined
     observations.  This has been fixed.

{p 4 9 2}
{* fix}
44.  {helpb print:print @Graph} with no Graph window open sometimes caused
     Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
45.  {helpb print:print} {it:filename}{cmd:.gph}, where
     {it:filename}{cmd:.gph} was not a Stata format graph file or was a
     live-format Stata graph file, sometimes caused Stata to crash.  This has
     been fixed.

{marker svylinearization}{...}
{p 4 9 2}
{* enhancement}
46.  {helpb svy} linearization is now faster, especially for large datasets
     with many sampling units.

{p 4 9 2}
{* fix}
47.  {helpb xmluse} with the {cmd:firstrow} option, when reading Excel
     datasets where the second row did not have sufficient type information,
     resulted in an error message saying that a variable couldn't be created
     because it already existed.  This has been fixed.

{p 4 9 2}
{* fix}
48.  {helpb xtabond} produced consistent but inefficient estimates when there
     were gaps in the time series.  This has been fixed.

{p 4 9 2}
{* enhancement}
49.  The {dialog twoway_overlay:overlaid twoway graph dialog} has a new tab
     {cmd:Y-Axis (2)} for affecting the rendition of a second y-axis.

{p 4 9 2}
{* fix}
50.  Axis tabs on all graph dialogs produced incorrect option arguments
     for grid-line patterns.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
51.  {helpb set doublebuffer} is a new command that enables or disables
     double-buffering in the Results, Viewer, and Data Editor windows.
     Disabling double-buffering may be necessary if output from the Results
     window appears very slowly.

{p 4 9 2}
{* fix}
52.  (64-bit versions of Windows with a 64-bit version of Stata) {helpb odbc}
     loaded only a subset of the requested data.  This has been fixed.

{p 4 9 2}
{* fix}
53.  {helpb permute}, when called with the {opt using} option with an absolute
     path in Windows (as in C:\mystuff\outperm.dta), issued an error message
     instead of replaying the results stored in the supplied dataset.  This
     has been fixed.

{p 4 9 2}
{* fix}
54.  If {cmd:profile.do} was located on a UNC path (that is,
     \\computername\path...), Stata prepended an extra backslash (that is,
     \\\computername\path...) and caused an error.  This has been fixed.

{p 4 9 2}
{* fix}
55.  On certain Windows versions, most notably Windows 98, opening the Viewer
     could crash Stata. This has been fixed.

{p 4 9 2}
{* enhancement}
56.  Tooltips have been added to some items in the Preferences dialog to aid
     in readability.

{p 4 9 2}
{* fix}
57.  The Variables Properties dialog from the Data Editor sometimes did not
     select the correct value label for the current variable.  This has been
     fixed.

{p 4 9 2}
{* fix}
58.  The Do-file Editor was incorrectly staggered from the correct position
     when it was the initial editor opened.  This has been fixed.

{p 4 9 2}
{* fix}
59.  A runtime exception sometimes occurred when the Search dialog was opened.
     The exception was never critical and always allowed for execution to
     continue.  The cause of the exception has been fixed.

{p 4 9 2}
{* fix}
60.  The initial dimensions of the Results window were sometimes too small
     when using the initial, default settings.  The Results window was not
     fully utilizing the available space.  This has been fixed.

{p 4 9 2}
{* fix}
61.  Runtime assertion errors could occur when creating Viewers, Graphs, or
     Do-File editors.  These have been resolved.

{p 4 9 2}
{* fix}
62.  When a variable control in a dialog has the focus, subsequent clicks
     inside the Variables window will send variables to the dialog control, as
     was the case in version 8.


    {title:Stata executable, Mac}

{marker consolemac}{...}
{p 4 9 2}
{* enhancement}
63.  There is now a console version of {help SpecialEdition:Stata/SE} for the
     Mac.  See {browse "http://www.stata.com/support/mac/"} for more
     information.

{p 4 9 2}
{* fix}
64.  Stata now attempts to resolve aliases to the Stata directory and the
     Stata executable upon startup.

{p 4 9 2}
{* fix}
65.  The mouse pointer did not change to a hand when the pointer was over a
     link.  This has been fixed.

{p 4 9 2}
{* fix}
66.  If you were running Stata from Mac OS 10.4 (Tiger), some lines would
     appear bold when you made a selection from the Results window or Viewer.
     This has been fixed.

{p 4 9 2}
{* fix}
67.  A keyboard shortcut for {bf: File > Save As...} has been added.


{hline 8} {hi:update 05jul2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb aorder}, when used on a variable list containing variable names
    with certain combinations of the letters '{cmd:c}', '{cmd:d}', '{cmd:e}',
    or '{cmd:f}', could exit with a 'system limit exceeded' error.  This has
    been fixed.

{p 5 9 2}
{* enhancement}
2.  {helpb icd9} and {helpb icd9p} have been updated to use the V22 codes;
    V21, V19, V18, and V16 codes were previously used.  V16, V18, V19, V21,
    and V22 codes have been merged so that {cmd:icd9} and {cmd:icd9p} work
    equally well with old and new datasets.  See help {helpb icd9} for a
    description of {cmd:icd9} and {cmd:icd9p}; type "{bf:{stata icd9 query}}"
    and "{bf:{stata icd9p query}}" for a complete description of the changes
    to the codes used.

{p 5 9 2}
{* fix}
3.  {helpb ml:ml display} now behaves as it did in Stata 8 when called under
    version control.

{p 5 9 3}
{* fix}
4.  {helpb suest} allowed estimation results from {cmd:ivreg} when it should
    have produced an error message.  This has been fixed.

{p 5 9 3}
{* fix}
5.  {helpb split}, when passed {cmd:parse("")} as an option, failed with an
    error.  {cmd:split} now understands that {cmd:parse("")} is equivalent to
    {cmd:parse()}.

{p 5 9 2}
{* fix}
6.  {helpb svy} sometimes identified a larger estimation sample in
    {cmd:e(sample)} than was actually used.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb xtgee:xtgee, family(binomial)} is now equivalent to
    {cmd:xtgee, family(binomial 1)} for nonbinary dependent variables as
    documented in the manual.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* enhancement}
8.  Find in the {help viewer:Viewer} has been improved.  Find is no longer
    performed through a modal dialog but instead is performed from a Find bar
    that is located above the Viewer's status bar.  In addition to finding a
    search term and selecting it, the Find bar can also highlight all
    instances of the search term.  Every Viewer window has its own Find bar.
    To show or hide a Viewer's Find bar, click its Find button, press Ctrl-F
    (Mac users press Cmd-F), or press F3.

{p 9 9 2}
    Stata always starts a find operation from the current selection.  If there
    is no selection, Stata starts at the beginning of the document.  To
    perform a find at the beginning of a document when there is text selected,
    click on the Viewer content area to clear the selection before performing
    a find, or press Ctrl-F3.  If the Find bar's edit field has the keyboard
    focus, you may also press Ctrl-Enter to do the same.

{p 9 9 2}
    The following keyboard shortcuts are available when the Find bar is
    visible.

{p2colset 10 50 52 2}{...}
{p2col:{bf:Shortcut}{space 11}{bf:Keyboard Focus}}{bf:Action}{p_end}
{p2line}
{p2col:Ctrl-F{space 13}Any part of Viewer}Show/hide Find bar{p_end}
{p2col:Return{space 13}Find bar edit field}Find next{p_end}
{p2col:Shift-Return{space 7}Find bar edit field}Find previous{p_end}
{p2col:Ctrl-Return{space 8}Find bar edit field}Find from beginning of document{p_end}
{p2col:Ctrl-Shift-Return{space 2}Any part of Viewer}Find from end of document{p_end}
{p2col:F3{space 17}Any part of Viewer}Find next{p_end}
{p2col:Shift-F3{space 11}Any part of Viewer}Find previous{p_end}
{p2col:Ctrl-F3{space 12}Any part of Viewer}Find from beginning of document{p_end}
{p2col:Ctrl-Shift-F3{space 6}Any part of Viewer}Find from end of document{p_end}
{p2col:Ctrl-G{space 13}Any part of Viewer}Find next{p_end}
{p2col:Ctrl-Shift-G{space 7}Any part of Viewer}Find previous{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
Note: Mac users should press the Cmd key instead of the Ctrl key.

{p 5 9 2}
{* fix}
9.  The {help dialog programming} documentation has been updated for Stata 9.
    In addition, several bugs that were present in the dialog system have been
    fixed.

{p 9 13 2}
A.  The {cmd:stata} command did not echo the command in the Results window as
    documented.  This has been fixed.

{p 9 13 2}
B.  Spaces that preceded text in a {cmd:put} command were not always handled
    properly.  This has been fixed.

{p 9 13 2}
C.  {cmd:target(stata hidden)} was not accepted with u-action buttons as
    documented.  This has been fixed.

{p 9 13 2}
D.  The {cmd:require} command did not work with heavyweight i-actions.  This
    has been fixed.

{p 9 13 2}
E.  The {cmd:VERSION} statement did not work correctly when multiple operating
    systems were specified.  This has been fixed.

{p 9 13 2}
F.  {opt onchange(i-action)} did not work with {cmd:BROWSE} controls.  This
    has been fixed.

{p 4 9 2}
{* fix}
10.  Do-files that generate a {helpb graph} and later produce an error, only
     showed the error message but did not produce the error code.  This has
     been fixed.

{p 4 9 2}
{* fix}
11.  Time-series {helpb graph}s were limited to 100 tick marks.  This has been
     fixed.

{p 4 9 2}
{* enhancement}
12.  {helpb ktau} computations are now faster.

{p 4 9 2}
{* fix}
13.  {helpb mata:Mata}'s object files ({cmd:.mo} and {cmd:.mlib} files; see
     {bf:{help m1_how:[M-1] how}}) are now stored a little differently.  This
     means that if you have any personal {cmd:.mo} or {cmd:.mlib} files, you
     must rebuild them from your source code; see
     {bf:{help mata_mosave:[M-3] mata mosave}} and
     {bf:{help mata_mlib:[M-3] mata mlib}}.
     Because this change is being made so close to the original release date,
     it is not being made under version control.

{p 4 9 2}
{* fix}
14.  {helpb mata:Mata} could mistakenly issue a subscript-out-of-range error
     for the statement {cmd:d[i]=x} when {cmd:i} was a vector.  Mata did this
     when any element of {cmd:i} exceeded {cmd:length(x)} instead of when any
     element exceeded {cmd:length(d)}.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb mata:Mata} produced a stack-overflow error, r(3998), in a rare
     case.  This has been fixed.

{p 4 9 2}
{* enhancement}
16.  {helpb quadchk} has new option {cmd:nofrom}.  By default {cmd:quadchk}
     starts from the previous estimation results.  Adaptive quadrature is
     sensitive to starting data, so specifying {cmd:nofrom} will often get
     slightly closer results.

{p 4 9 2}
{* fix}
17.  After {helpb set_varabbrev:set varabbrev off} an expression using
     {cmd:_b[}{it:some_abbreviated_varname}{cmd:]} worked when it should not
     have.  This has been fixed.

{p 4 9 2}
{* enhancement}
18.  {helpb xtlogit:xtlogit, re}, {helpb xtprobit:xtprobit, re},
     {helpb xtcloglog:xtcloglog, re}, {helpb xtpoisson:xtpoisson, re normal},
     {helpb xtintreg}, and {helpb xttobit} now allow up to 195 integration
     points in the {cmd:intpoints()} option.

{p 4 9 2}
{* enhancement}
19.  {helpb xtlogit}, {helpb xtprobit}, {helpb xtcloglog}, {helpb xtpoisson},
     {helpb xtintreg}, and {helpb xttobit} when specified with the
     {cmd:intmethod(ghermite)} option now allow the {cmd:constraints()} option
     for specifying constraints.

{p 4 9 2}
{* fix}
20.  The {cmd:set level} extended macro function (documented in Stata 7 and
     earlier versions) failed to work in Stata 9.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
21.  {helpb cd} to a UNC path (that is, {cmd:cd \\computername\path}{it:...})
     returned {cmd:c(pwd)} as an empty string rather than the correct path.
     This has been fixed.

{p 4 9 2}
{* fix}
22.  In Stata's various file dialogs, such as {bf:File--Open}, if a user
     attempted to open or save a file across a UNC path (that is,
     {cmd:\\computername\path}{it:...}), Stata would prepend an extra
     backslash (that is, {cmd:\\\computername\path}{it:...}) and cause an error.
     This has been fixed.

{p 4 9 2}
{* fix}
23.  {helpb haver} failed to load datasets that contained more than 2048
     variables.  This has been fixed.  Now, the maximum is determined by the
     {help maxvar} setting.

{p 4 9 2}
{* fix}
24.  Stata for Windows incorrectly enumerated multiple instances of Stata.
     This has been fixed.

{p 4 9 2}
{* fix}
25.  The main Stata window remained hidden when launched until the commands in
     {cmd:profile.do} completed.  This has been fixed.

{p 4 9 2}
{* fix}
26.  When a Viewer was launched upon startup of Stata (whether through
     shortcuts, double-clicking smcl files, etc.) the Viewer never appeared.
     This has been fixed.

{p 4 9 2}
{* fix}
27.  Graph window positions were not properly loaded from a named preference
     set.  This has been fixed.

{p 4 9 2}
{* fix}
28.  Copy (Ctrl-C) and Print (Ctrl-P) shortcuts failed to work in the Graph
     window.  This has been fixed.

{p 4 9 2}
{* fix}
29.  Resizing a floating Results window could result in the output not
     matching the dimensions of the window.  This has been fixed.

{p 4 9 2}
{* fix}
30.  The Results window, {help viewer:Viewer}, and {help edit:Data Editor} now
     double-buffer their contents to prevent them from flickering when resized
     or redrawn.

{p 4 9 2}
{* fix}
31.  When the Variables or Review windows were clicked and text was sent to
     the Command window, the right-click menu did not properly allow for
     Cut/Undo/Copy operations.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
32.  There is a new option to draw smooth fonts with QuickDraw and the Quartz
     graphics engine rather than drawing smooth fonts using Quartz directly.
     This allows for slightly faster, yet potentially less accurate, rendering
     of text output.  To enable or disable the option, check or uncheck the
     {bf:Draw text using QuickDraw} checkbox from the General Preferences
     dialog or {cmd:set use_qd_text} {{cmd:on} | {cmd:off}}; see
     {cmd:set use_qd_text}.  When this option is enabled, the minimum font
     size for smoothing is read from the System Preferences, not Stata's
     preferences.  This enhancement requires Mac OS X 10.2 or higher.

{p 4 9 2}
{* note}
33.  Some of Stata's menus that contain hierarchical menus do not display an
     arrow to indicate that a menu item contains a hierarchical menu while
     running Stata in Mac OS X 10.4 (Tiger).  This is an issue in Tiger, not
     in Stata.  Apple is aware of this and has indicated that it will be fixed
     in a future software update to Tiger.

{p 4 9 2}
{* fix}
34.  Due to a change in how the default PATH environment variable is defined
     in Tiger from previous versions of Mac OS X, Stata now searches the
     user's home directory regardless of whether it is defined in the PATH
     variable or not.  This allows Stata to determine if a profile.do file
     exists in the user's home directory when running Stata on Tiger.

{p 4 9 2}
{* fix}
35.  In Mac OS X 10.4.x (Tiger), Stata files could not be dropped on Stata's
     Dock icon so that they will open in Stata.  This has been fixed.

{p 4 9 2}
{* fix}
36.  Setting the y resolution of graphs copied to the Clipboard using the
     Graph Preferences dialog had no effect.  This has been fixed.


{hline 8} {hi:update 21jun2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 5(2).

{p 5 9 2}
{* fix}
2.  {helpb adjust} failed when an {cmd:if} condition involved literal strings.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb ml} now documents that {cmd:ml} {cmd:display} uses {cmd:e(k_eform)}
    to determine how many equations to exponentiate when supplied with an
    {it:{help ml##eform_option:eform_option}}.

{p 5 9 2}
{* fix}
4.  {cmd:predict} with the {opt pr} option, when used after {helpb probit}
    with the {helpb svy} prefix or the {cmd:vce(bootstrap)} or
    {cmd:vce(jackknife)} options, did not produce the predicted probability
    values.  This has been fixed.


{hline 8} {hi:update 17jun2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb areg} failed when attempting to fit a constant-only model.  This
    has been fixed.

{p 5 9 2}
{* enhancement}
2.  {helpb asmprobit} uses either {helpb clogit} or {helpb mlogit} for initial
    estimates.  These estimates are now scaled by the standard deviation of
    the extreme value distribution, {cmd:c(pi)/sqrt(6)}.

{p 5 9 2}
{* enhancement}
3.  {helpb asmprobit} does not attempt to refine the standard
    deviation/correlation estimates if the first call to {cmd:ml} (using the
    Cholesky factored variance/covariance parameterization) does not converge.
    In this case, a second call to {cmd:ml} is made to reparameterize the
    estimates, but {cmd:iterate(0)} is used to prevent another nonconvergent
    search.

{p 5 9 2}
{* fix}
4.  {helpb asmprobit}, {helpb mprobit}, and {helpb slogit} used inappropriate
    error codes.  This has been fixed.

{p 5 9 2}
{* enhancement}
5.  {helpb biplot} now allows plotting of any two dimensions, not just the
    first two, with the new {cmd:dim()} option.  {cmd:biplot} also now allows
    you to plot negative column (variable) arrows with the new {cmd:negcol}
    option.  Graph options for the negative column arrows are specified with
    the new {cmd:negcolopts()} option.  New options {cmd:norow} and
    {cmd:nocolumn} suppress the row points or column arrows.

{p 5 9 2}
{* enhancement}
6.  {helpb nlogit} now allows groups to have different sets of alternatives,
    so unbalanced groups are now allowed.  {cmd:nlogit} now saves
    {cmd:e(alt_min)}, {cmd:e(alt_max)}, and {cmd:e(alt_avg)} providing the
    minimum, maximum, and average number of alternatives per group.

{p 5 9 2}
{* fix}
7.  {helpb cluster measures} complained if a {it:measure} was not provided.
    It now defaults to using the {cmd:L2} {it:measure}, as documented.

{p 5 9 2}
{* fix}
8.  {helpb dotplot}, when supplied with an {opt if} or {opt in} restriction,
    produced graphs with an incorrect range for the frequency axis.  This has
    been fixed.

{p 5 9 2}
{* fix}
9.  {helpb _get_gropts}, a programmer's command, now recognizes the
    {opt altshrink} option as a {cmd:graph} {cmd:combine} option when the
    {opt getcombine} option is specified.

{p 4 9 2}
{* fix}
10.  {helpb newey} failed if a model contained variables with time-series
     operators and one of those variables was dropped due to
     multicollinearity.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb newey}, like {helpb regress}, showed "(dropped)" in the table of
     coefficients for a dropped variable.  Now, like most other commands, it
     displays "note: {it:variable} dropped due to collinearity" at the top of
     the output.

{p 4 9 2}
{* fix}
12.  {cmd:predict} with the {opt pr} option, when used after {helpb logistic},
     {helpb logit}, or {helpb probit} with the {helpb svy} prefix or the
     {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} options, produced values of
     the linear prediction instead of the predicted probability.  This has
     been fixed.

{p 4 9 2}
{* fix}
13.  {helpb xtmixed_postestimation##predict:predict}
     {it:varlist}{cmd:, reffects} after {helpb xtmixed} now produces an
     appropriate error message and exits with an error code if any of the
     variables in {it:varlist} already exist.

{p 4 9 2}
{* fix}
14.  {helpb svy} estimation commands, when string variables were used to
     identify strata or sampling units, incorrectly counted the corresponding
     number of strata or sampling units resulting in incorrect variance
     estimates.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb svyopts} did not work as advertised in the Stata Press book,
     {it:{browse "http://www.stata.com/bookstore/mle.html":Maximum Likelihood Estimation with Stata, 2nd edition}}
     (Gould, Pitblado, and Sribney 2003).  This has been fixed.

{p 9 9 2}
    Programmers interested in getting their estimation commands to work with
    the new {helpb svy} prefix command should see the {hi:Remarks} section of
    {help program properties}.

{p 4 9 2}
{* fix}
16.  {helpb "svy: regress"} and {cmd:svy: ivreg} exited with an
     inappropriate error message when the sampling weights summed to a number
     less than 1.  Although this has been fixed, we note that the sum of the
     sampling weights should sum to the population size (or at least estimate
     the population size) for the DEFF design effect to be valid when using an
     FPC in the first stage.  DEFT is invariant to the scale of sampling
     weights.


{hline 8} {hi:update 25may2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb asmprobit} help now documents that the options
    {cmd:basealternative()} and {cmd:scalealternative()} may contain a number,
    a label value, or a string.

{p 5 9 2}
{* fix}
2.  {helpb biplot} did not label row markers properly when the {cmd:mlabel()}
    option was specified and a subsample of the data was used.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb ca_postestimation plots##cabiplot:cabiplot} and
    {helpb ca_postestimation plots##caprojection:caprojection} now allow row and
    column marker labels to be specified.  This is accomplished with the
    {cmd:mlabel()} suboption of {cmd:rowopts()} and {cmd:colopts()}.

{p 5 9 2}
{* fix}
4.  {helpb estimates:estimates replay} failed when called under version 8.2
    version control.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb glm}, {helpb mdslong}, {helpb merge},
    {helpb mds_postestimation##predict:predict} after {helpb mds}, and
    {helpb rolling} failed when the temporary file directory path contained
    spaces.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb graph bar} and {helpb graph dot}, after the 04may2005 update,
    displayed an extra set of bars when the {cmd:sort} suboption was specified
    with the {cmd:over()} option.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb graph twoway} error messages have been improved when too many or
    too few variables are specified for a plot.

{p 5 9 2}
{* fix}
8.  {helpb icd9:icd9[p] check} with the {cmd:generate()} option did not
    generate a variable if all codes were valid.  This has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb mprobit} and {helpb slogit} help now document that the option
    {cmd:baseoutcome()} may contain a number or a label value.

{p 4 9 2}
{* fix}
10.  {helpb nl} when used with the pre-version-9 syntax accepted but ignored
     the {cmd:robust}, {cmd:cluster()}, {cmd:hc2}, and {cmd:hc3} options.
     Now specifying one of those options with the old syntax will result in
     an error message.

{p 4 9 2}
{* fix}
11.  {helpb asmprobit_postestimation##predict:predict} failed after
     {helpb asmprobit} with a string {cmd:alternatives()} variable.  This has
     been fixed.

{p 4 9 2}
{* fix}
12.  {helpb xtreg_postestimation##predict:predict} after
     {helpb xtreg:xtreg, fe} produced the linear prediction when options such
     as {cmd:residuals} or {cmd:cooksd} were specified.  An error message is
     now issued instead.

{p 4 9 2}
{* fix}
13.  {helpb stepwise} incorrectly exited with an error for backward stepwise
     regression (when using options {opt pr()} and {opt pe()}).  This has been
     fixed.

{p 4 9 2}
{* fix}
14.  {helpb xtmixed} sometimes failed when given an {cmd:if} condition that
     used value labels, for example, {cmd:if foreign == "Domestic":origin}.
     This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb xttobit} erroneously treated observations for which the dependent
     variable was missing as being right-censored instead of ignoring them.
     This has been fixed.


{hline 8} {hi:update 04may2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb asmprobit} models with unstructured covariances produced an error
    message during the reparameterization phase of the {helpb ml} optimization
    if the model definition for the variance/correlation parameters exceeded
    80 characters.  This has been fixed.

{p 5 9 2}
{* enhancement}
2.  {cmd:bootstrap} has a {opt group()} option, which was not documented in the
    manual.  See {helpb bootstrap} for the updated online documentation.

{p 5 9 2}
{* fix}
3.  {helpb clogit} performed an extra, but unnecessary, calculation, which
    caused it to run slowly on large datasets.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb clogit} uses {helpb logit} to generate starting values when none
    are specified.  For some models, these starting values resulted in
    nonsensical {cmd:clogit} log-likelihoods.  {cmd:clogit} now checks that
    starting values make sense before using them.

{p 5 9 2}
{* enhancement}
5.  {helpb graph bar} and {helpb graph dot} no longer require user-provided
    names when a variable is repeated with more than one statistic.  The
    dialogs for these commands have been redesigned to take advantage of the
    new, simplified syntax.

{p 5 9 2}
6.  When managing multiple graphs or renaming graphs when used from disk,
    Stata sometimes displayed the wrong graph in a Graph window.  This has
    been fixed.

{p 5 9 2}
{* fix}
7.  {helpb pause} executed subsequent commands under version 6 control.  It
    now executes them under the control of the caller's version.

{p 5 9 2}
{* fix}
8.  {helpb roctab} produced a different standard error for the area under the
    curve when a monotonic transformation was applied to the rating.  This has
    been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb screeplot} has been enhanced to produce scree plots automatically
    after {helpb manova}, {helpb canon}, {helpb ca}, and {helpb camat}.

{p 4 9 2}
{* fix}
10.  {helpb stsum} sometimes reported percentiles as the next ordered survival
     time when the desired fraction exactly equaled the empirically observed
     fraction.  This would be similar to saying that the median of (1,2,5,7,9)
     is 7 rather than 5.  {cmd:stsum} rarely made this mistake.  This problem
     has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb svy} dropped observations from the estimation sample that had zero
     as the value of the sampling weight.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb xtreg:xtreg, be} and {cmd:xtreg, fe} reported a missing value for
     the model F statistic when the {cmd:vce(bootstrap)} option was specified.
     They now report the correct model Wald chi-squared statistic.

{p 4 9 2}
{* fix}
13.  {helpb xtreg:xtreg, re} reported a missing value for the model
     chi-squared statistic when the {cmd:vce(jackknife)} option was specified.
     {cmd:xtreg, re} now reports the correct model F statistic.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew8to9}.{p_end}

{hline}
