{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 11}

{pstd}
This file records the additions and fixes made to Stata during the 11.0, 11.1,
and 11.2 releases:

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
    {c |} {bf:this file}        Stata 11.0, 11.1, and 11.2   2009 to 2011    {c |}
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
See {help whatsnew11to12}.


{marker up01sep2011}{...}
{hline 8} {hi:update 01sep2011} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb discrim knn} when the values of {it:groupvar} (specified in option
    {cmd:group()}) were not contiguous for a group (that is, for example, when
    all observations for group 1 were not together, all observations for group
    2 were not together, etc.) could give incorrect results.  This has been
    fixed.

{p 5 9 2}
{* fix}
2.  {helpb margins} was reporting all margins, even the estimable ones, as
    "(not estimable)" when factor variables were specified in models fit using
    {helpb slogit} or {helpb stcrreg}.  This has been fixed.

{p 5 9 2}
{* fix}
3.  Mata's {helpb mf_optimize:optimize()} with the Nelder-Mead technique and
    constraints would error-out with a Mata trace log.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb sspace} when time-series operators were combined with the
    {cmd:e.} error operator on the dependent variable in an {it:obs_efeq}
    equation produced an error message.  This has been fixed.

{p 5 9 2}
{* enhancement}
5.  {helpb svy} now calls option validator programs for user-written
    estimation commands; see {help svy_parsing}.

{p 5 9 2}
{* fix}
6.  {helpb svy brr} with an expression would sometimes report an error about a
    working variable not found.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb svy}{cmd:} {helpb ivregress} reported an invalid-operator error
    when factor-variables notation was used in the list of instrumental
    variables {it:varlist_iv} but not in the list of exogenous variables
    {it:varlist1}.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb var} with 10 or more lags of exogenous variables failed to sort the
    lags in the right order.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
9.  {helpb anova} and {helpb manova} specified with a {it:termlist} longer
    than 503 characters would typically report a {err:variable not found}
    error.  This has been fixed.

{p 4 9 2}
{* fix}
10.  Mata functions {helpb mf_fget:fget()} and {helpb mf_fgetnl:fgetnl()}, in
     the case of files with Windows-style end-of-line characters (\r\n) when a
     line had a length of a multiple of 512 characters, minus 1, could return
     an extra blank line upon a repeated call to one of these functions.  This
     has been fixed.

{p 4 9 2}
{* enhancement}
11.  The maximum length for the Mata library path was 256 characters.  It has
     been increased to 4096 characters.

{p 4 9 2}
{* enhancement}
12.  {helpb set memory} with memory allocations between 105 GB and 208 GB
     could cause Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb stcox} using options {cmd:efron} and {cmd:vce(robust)} could take
     a long time to compute for large datasets with many tied failure times.
     This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb xmlsave} might crash Stata if the variables to be saved were
     sorted.  This has been fixed.

{p 4 9 2}
{* enhancement}
15.  The text limit of VARLIST controls in dialog boxes has been increased to
     2048 characters.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
16.  {helpb graph} text with a {help alignmentstyle:vertical alignment} of
     {cmd:middle} or {cmd:top} had superscripts and subscripts shifted
     slightly vertically.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
17.  How Stata displays its main windows after it has been launched has
     changed because of changes in behavior in Mac OS X 10.7 (Lion) from
     earlier versions of Mac OS X.

{p 4 9 2}
{* enhancement}
18.  Stata's file dialogs now support opening symbolic links to files or
     directories.

{p 4 9 2}
{* fix}
19.  Changes to Mac OS X 10.6.7 could cause printing from the Do-file Editor
     to crash.  This has been fixed.

{p 4 9 2}
{* fix}
20.  A change in Mac OS X 10.7 (Lion) caused the cursor to disappear when the
     cursor was on a line that only contained a carriage return in the Do-file
     Editor.  This has been fixed.

{p 4 9 2}
{* fix}
21.  {cmd:c(mode)} {helpb creturn} value has been added to the console version
     of Stata.

{p 4 9 2}
{* fix}
22.  When printing from the Results window or the Viewer window, the last line
     would not be printed.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
23.  {helpb graph} text with a {help alignmentstyle:vertical alignment} of
     {cmd:middle} or {cmd:top} had superscripts and subscripts shifted
     slightly vertically.  This has been fixed.

{p 4 9 2}
{* fix}
24.  {cmd:c(mode)} {helpb creturn} value has been added to the console version
     of Stata.


{marker up19jul2011}{...}
{hline 8} {hi:update 19jul2011} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 11(2).

{p 5 9 2}
{* fix}
2.  {helpb stcox_postestimation##estatcon:estat concordance} was not allowed
    after {helpb stcox} with bootstrap or jackknife adjusted standard errors.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb ivregress postestimation##estatendog:estat endogenous} after
    {helpb ivregress} sometimes reported an error when factor variables were
    specified.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb gmm} with a string cluster variable produced incorrect standard
    errors.  This has been fixed.

{p 5 9 2}
{* enhancement}
5.  {helpb svy jackknife} now reports a note when subpopulation observations
    were dropped because of missing values in the model's variables.  This note
    explains why {cmd:svy} {cmd:jackknife} may report that there are
    insufficient observations to compute standard errors, and gives some
    advice on how this might be fixed.

{p 5 9 2}
{* fix}
6.  {helpb margins} was incorrectly allowing option {cmd:vce(unconditional)}
    with {helpb svy bootstrap} and {helpb svy sdr}.  The standard
    errors in this case were not computed using either bootstrap or SDR
    methods but were linearized based on the currently {helpb svyset} design.
    {cmd:margins} with option {cmd:vce(unconditional)} will now report an
    error with {cmd:svyset} data if the default {opt vce()} is different from
    {cmd:linearized} or if the currently estimated standard errors are not
    {cmd:linearized}.

{p 5 9 2}
{* fix}
7.  {helpb mca} did not allow a {it:{help varlist}} with notation {cmd:*} or
    {cmd:_all} to represent all variables in the current dataset.  This has
    been fixed.

{p 5 9 2}
{* fix}
8.  {helpb mi estimate} now checks for structural variables (variables
    declared by {cmd:stset}, {cmd:svyset}, {cmd:tsset}, or {cmd:xtset}) that
    are registered as passive or imputed and issues an error message if there
    are any.

{p 5 9 2}
{* fix}
9.  {helpb mi import flongsep} did not respect spaces in folder names
    specified within option {cmd:using()}.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb mi impute} has the following fixes:

{p 9 13 2}
     a.  {helpb mi impute ologit} failed to detect cases when the simulated
         posterior estimates of the cutpoints did not satisfy the monotonicity
         constraint.  This could result in the middle categories of the
         imputation variable being underrepresented.  Such situations could
         arise in the presence of factor variables among the independent
         variables.  This has been fixed.

{p 9 13 2}
     b.  {helpb mi impute regress} and {helpb mi impute pmm} with analytic
         weights produced imputed values with dispersion smaller that it
         should have been.  This has been fixed.

{p 9 13 2}
     c.  {helpb mi impute} now treats missing frequency weights as ones rather
         than zeros when displaying the numbers of complete, incomplete,
         imputed, and total observations.  This does not affect the imputation
         procedure, only the displayed numbers of observations in the
         imputation table.

{p 4 9 2}
{* fix}
11.  {helpb mprobit_postestimation##predict:predict} after {helpb mprobit} did
     not allow option {opt equation()} as a synonym for {opt outcome()}.  This
     has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb proportion} with the {helpb svy brr} or {helpb svy jackknife}
     prefix and option {opt subpop()} that excluded one or more of the
     categories of a variable in the {it:varlist} reported an
     "{err:insufficient observations to compute jackknife standard errors}"
     error.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb proportion}, {helpb ratio}, {helpb mean}, and {helpb total} return
     a better error message when there are no observations.

{p 4 9 2}
{* fix}
14.  {helpb robvar} did not allow string variables in option {opt group()}.
     This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb smooth} gave an uninformative error message when no
     smoother was specified.  The message has been improved.

{p 4 9 2}
{* fix}
16.  {helpb svy_tabulate:svy: tabulate} with option {opt ci} and bootstrap
     or SDR standard errors was reporting confidence intervals that were too
     narrow for the specified {opt level()}.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb svy_tabulate:svy: tabulate} with option {opt stdize()} and one of
     the replication methods for variance estimation would incorrectly report
     a syntax error that option {opt stdize()} was not allowed.  This has
     been fixed.

{p 4 9 2}
{* fix}
18.  {helpb truncreg} did not respect frequency weights when computing the
     number of observations before truncation, {cmd:e(N_bf)}.  This has been
     fixed.

{p 4 9 2}
{* fix}
19.  {helpb xtpoisson} with options {opt re} and {opt normal} did not estimate
     the constant-only model when option {opt noskip} was specified.  This has
     been fixed.

{p 4 9 2}
{* fix}
20.  {helpb xtreg:xtreg, re} incorrectly reported that the GLS estimates
     assumed a Gaussian distribution for the random effects.  This has been
     fixed.

{p 4 9 2}
{* fix}
21.  {helpb xttest0} reported test statistics to be from a
     one-degree-of-freedom chi-squared distribution when they were actually
     from a one-degree-of-freedom 50:50 mixture of a chi-squared distribution
     with zero.  This has been fixed.


{hline 8} {hi:update 30mar2011} (Stata version 11.2) {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb bstat} ignored {opt if} and {opt in} restrictions.  This has been
    fixed.

{p 5 9 2}
{* fix}
2.  In some cases, when text was added to {helpb graph bar}, {helpb graph box},
    or {helpb graph dot} graphs using option {cmd:text()} and that text was
    subsequently edited in the {help Graph Editor}, {helpb graph use} after
    {helpb graph save} would fail with an error message.  This has been fixed.

{p 5 9 2}
{* fix}
3.  In the {help Graph Editor} when using the {bf:Grid} {bf:Edit} tool,
    expanding or contracting cells using "Above 1 cell" could fail to perform
    the expand or contract operation.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb merge}, if the master dataset contained a temporary
    variable, could rarely report that no observations were merged even though
    they were.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb merge} with option {cmd:keep()}, in rare situations, could
    report that it needed more memory to complete the merge than was actually
    necessary.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb mi impute} has the following fixes:

{p 9 13 2}
    a.  {helpb mi impute pmm} would sometimes fail to issue an error when
        missing imputed values were produced and would automatically proceed
        with imputation as if option {cmd:force} had been issued.  This
        has been fixed.

{p 9 13 2}
    b.  Contrary to the documentation, {helpb mi impute regress} and
        {helpb mi impute pmm} assumed frequency weights by default rather than
        analytic weights.  The implementation now matches the documentation;
        analytic weights are the default.

{p 9 13 2}
    c.  {helpb mi impute monotone}, with the default specification, treated
        right-hand-side factor variables as continuous in the prediction
        equations.  This has been fixed.

{p 9 13 2}
    d.  {helpb mi impute mvn} failed with an error message when used with
        factor variables and an {cmd:if} condition.  The error arose when
        factor variables contained fewer levels in the restricted sample than
        in the unrestricted sample.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb quadchk} after {helpb xtpoisson} with option {opt exposure()}
    resulted in a syntax error.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb roctab}, when graphing with option {cmd:specificity}, did
    not sort the data correctly.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy} with {helpb stset} data now recognizes when it is performing
    subpopulation estimation with the {helpb stcox} and {helpb streg} models
    even when the subpopulation information was specified in {helpb svyset}
    but not option {opt subpop()}.

{p 4 9 2}
{* fix}
10.  {helpb svy estimation:svy: stcox} and {helpb svy estimation:svy: streg}
     specified with an {cmd:if} or {cmd:in} condition changed the record
     selection information stored by {helpb stset} when it should have left
     the original {cmd:stset} information unchanged.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb xtmixed} ignored factor-variable specifications of the form
     "{cmd:ibn.}" (no base level).  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
12.  {helpb drawnorm} produces different results from previously because of
     the changes in function {cmd:rnormal()} documented below.  Prior results
     are reproduced under version control.

{p 4 9 2}
{* enhancement}
13.  {helpb mi impute} produces different results from previously because of
     the changes in function {cmd:rnormal()} documented below.  Prior results
     are reproduced under version control.  The statistical properties of the
     new results are no better or worse than the prior results.

{p 4 9 2}
{* fix}
14.  {helpb rnormal()}, the Gaussian random-number generation function in both
     Stata and Mata, now produces different, better values.  Prior results are
     reproduced under version control.

{p 9 9 2}
     {cmd:rnormal()} produced sequences that were insufficiently random for
     certain applications.  After setting the seed, the sign of the first
     random number drawn was correlated with the sign of the first random
     number that would be drawn after setting a different seed; the sign of
     the second random number drawn was correlated with the sign of the second
     random number that would be drawn; and so on.  Thus the sequence produced
     by {cmd:rnormal()} after {helpb set seed} was not statistically
     independent from the sequence produced after another {cmd:set seed}
     command.

{p 9 9 2}
     This lack of independence made no difference in the statistical quality
     of results when the seed was set only once, because the lack of
     independence did not arise.  Setting the seed once is typical in many
     cases, including the running of simulations.

{p 9 9 2}
     The correlation is of statistical concern when the seed is set more than
     once in the same problem.

{p 9 9 2}
     Only the {cmd:rnormal()} function had this problem.  None of Stata's
     other random-number functions, such as {cmd:runiform()}, {cmd:rbeta()},
     etc., had this problem.

{p 9 9 2}
     The problem is fixed, with the result that random-number sequences
     produced by {cmd:rnormal()} are now different.  If you need to re-create
     previously produced results, use version control and specify a version
     prior to 11.2 when setting the random number seed with {helpb set seed}.

{p 4 9 2}
{* enhancement}
15.  Help for {helpb set seed} now includes useful advice on how to set the
     seed and explains the difference between a random-number generator seed
     and its state as recorded in {cmd:c(seed)}.

{p 4 9 2}
{* enhancement}
16.  The way version control is handled for random-number generators has
     changed.  Version control is now specified at the time command
     {cmd:set seed} is issued; the version in effect at the time the
     random-number generator (for example, {cmd:rnormal()}) is used is now
     irrelevant.  The situation was previously the other way around.

{p 9 9 2}
     Under the new scheme, typing

{p 13 13 2}
                {cmd:. set seed 123456789}{break}
		{cmd:.} {it:any_command}

{p 9 9 2}
     causes {it:any_command} to use the new, version 11.2 {cmd:rnormal()}
     function even if {it:any_command} is an ado-file itself containing
     explicit versioning for an earlier release.  Thus existing ado-files
     need not be updated to benefit from the updated {cmd:rnormal()}
     function.

{p 9 9 2}
     Similarly, if you wish to run {it:any_command} using the prior version of
     {cmd:rnormal()}, you may type

{p 13 13 2}
		{cmd:. version 11.1: set seed 123456789}{break}
		{cmd:.} {it:any_command}

{p 9 9 2}
     Even years from now, {it:any_command} will still use the 11.1 version of
     {cmd:rnormal()}, and it will do that even if {it:any_command} was written
     for a later release of Stata.

{p 4 9 2}
{* enhancement}
17.  Programmers do not need to update their previously written ado-files
     because of the change in function {cmd:rnormal()}, with one exception.
     If the ado-file itself contains a {cmd:set seed} command, the ado-file
     should be updated to use the version in effect at the time the ado-file
     was called.  To do this, early in the code, obtain the version of the
     caller.  Later, use the caller's version when issuing command
     {cmd:set seed}:

{p 13 13 2}
                {cmd:program xxx}
{p_end}
{p 17 17 2}
                    {cmd:version} ...

{p 17 17 2}
                    {cmd:syntax} ...{break}
                    ...{break}
                    {cmd:local callersversion = _caller()}{break}
                    ...{break}
                    {cmd:version `callersversion': set seed} ...{break}
                    ...
{p_end}
{p 13 13 2}
                {cmd:end}

{p 9 9 2}
     If {cmd:set seed} appears in a private subroutine of {cmd:xxx}, you
     must pass {cmd:callersversion} to the subroutine.

{p 9 9 2}
     If {cmd:set seed} appears in another program that you did not
     write, execute that program under the caller's version:

{p 13 13 2}
                {cmd:program xxx}
{p_end}
{p 17 17 2}
                    {cmd:version} ...

{p 17 17 2}
                    {cmd:syntax} ...{break}
                    ...{break}
                    {cmd:local callersversion = _caller()}{break}
                    ...{break}
                    {cmd:version `callersversion': mi impute} ...{cmd:, seed(}...{cmd:)}{break}
                    ...
{p_end}
{p 13 13 2}
                {cmd:end}

{p 4 9 2}
{* enhancement}
18.  New {helpb creturn} result {cmd:c(version_rng)} records the version
     number currently in effect for random-number generators.

{p 4 9 2}
{* fix}
19.  {helpb fvrevar} with option {opt tsonly} failed to preserve the
     {cmd:b(none).} (abbreviated {cmd:bn.}) operator attached to factor
     variables.  This has been fixed.

{p 4 9 2}
{* fix}
20.  {helpb intreg} with a constant-only specification reported a
     "{err:too few variables specified}" error.  This has been fixed.

{p 4 9 2}
{* fix}
21.  {helpb margins} and other estimation commands that allow factor-variables
     notation crashed Stata when multiple duplicate variables were specified
     in a single interaction term.  This has been fixed.

{p 4 9 2}
{* fix}
22.  Mata did not allow Mata class scalar or matrix to be declared as
     external; a "{err:sysfail 52}" error was reported.  This has been fixed.

{p 4 9 2}
{* fix}
23.  Mata function {helpb mata st_addvar():st_addvar()} added "str245"
     variables to Stata even though the maximum length string variable is
     str244.  The variables were not really str245, but numeric.
     {cmd:st_addvar()} did this when called with a real scalar first argument
     equal to 245.  The function now aborts with error in this case.

{p 4 9 2}
{* fix}
24.  Mata function {helpb mf_st_view:st_view()} with factor variables in the
     {it:j} argument ignored the {it:selectvar} argument when filling in the
     levels of the factor variables, this led to the full set of levels being
     included instead of the levels present in the selected sample.  This has
     been fixed.

{p 4 9 2}
{* fix}
25.  {helpb ml} and Mata's {helpb moptimize:moptimize()} with type {cmd:e1},
     {cmd:e2}, {cmd:lf1}, and {cmd:lf2} evaluators and {helpb matafavor} set
     to {cmd:speed} sometimes resulted in a nonconvergent iteration log full
     of {cmd:(backed up)} messages.  This specifically occurred when some of
     the equation-level score values were equal to zero, causing a bad
     gradient vector calculation.  This has been fixed.

{p 4 9 2}
{* fix}
26.  The graph produced by {helpb palette:palette symbolpalette}, when
     exported to PostScript, had the names of the square symbols shifted down
     slightly.  This has been fixed.

{p 4 9 2}
{* fix}
27.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} now
     report a missing value for the standard error when the effective sample
     size for the point estimate is based on a single value.  Prior to this
     change, these commands would report a zero-valued standard error; this
     previous behavior will not be preserved under version control.

{p 4 9 2}
{* fix}
28.  {helpb prais} with any of the robust {cmd:vce()} options erroneously
     included the intercept in the model F statistic.  This has been fixed.

{p 4 9 2}
{* fix}
29.  {helpb regress} with option {opt hascons} and option {cmd:vce(robust)} or
     {cmd:vce(cluster} ...{cmd:)} erroneously reported an omitted intercept.
     This has been fixed.

{p 4 9 2}
{* fix}
30.  With {help statamp:Stata/MP}, {helpb mlmatbysum} produced wrong results
     if the global macro {cmd:$ML_w} was empty.  This has been fixed.

{p 4 9 2}
{* fix}
31.  The Data Editor has the following modifications and fixes:

{p 9 13 2}
     a.  Variables are no longer abbreviated in the location bar.

{p 9 13 2}
     b.  Single cell paste is now handled as a manual edit and thus issues a
         Stata command.

{p 9 13 2}
     c.  Copying and pasting string data from within the Data Editor could
         result in extra characters getting pasted if the source string was
         copied from a shorter-string type.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
32.  Loading a saved window preference did not set the font in the Command
     window until Stata was restarted.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
33.  Graphs exported as PDF files are now exported with increased resolution.

{p 4 9 2}
{* enhancement}
34.  The point symbol was previously drawn as a 1/72" x 1/72" rectangle which
     is the minimum size of a screen pixel.  Stata now draws the point symbol
     as a 1/216" x 1/216" rectangle when printing for better looking results.

{p 4 9 2}
35.  The Do-file Editor has the following new features and fixes:

{p 9 13 2}
{* enhancement}
     a.  The Do-file Editor can now optionally display line numbers when
         printing text.  Text is now line-wrapped to fit the printed page.

{p 9 13 2}
{* fix}
     b.  Syntax highlighting highlighted as a comment entire lines that started
         with the comment delimiter {cmd:*/}.  Only text up to and including
         the comment delimiter {cmd:*/} should be highlighted as a comment.

{p 4 9 2}
{* fix}
36.  Dragging a variable or command from the Variables and Review windows,
     respectively, would insert the currently highlighted variable or command
     instead of the item that was dragged.  This has been fixed.  Dragging and
     dropping a command from the Review window to the Command window now
     inserts the command instead of replacing the contents of the Command
     window.

{p 4 9 2}
{* fix}
37.  The Data Editor allowed text to be pasted while in browse mode.  This has
     been fixed.

{p 4 9 2}
{* fix}
38.  Stata now prompts you to save unsaved data when opening new data from the
     Open Recents menu.

{p 4 9 2}
{* fix}
39.  Selecting File > Save on a modified graph that has been already saved no
     longer prompts the user for a filename.  Stata now uses the saved
     filename.

{p 4 9 2}
{* fix}
40.  Mac OS X 10.7 (Lion) might not include the font Monaco.  When a Stata
     window's font setting includes a font that does not exist on the system,
     Stata will use the default Mac OS X fixed-width system font instead.  You
     will not have to change the font settings yourself but this is why Stata
     might be using a different font the first time you run Stata on a Mac
     upgraded to Lion.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
41.  Saving a windowing preference using command
     {cmd:window manage prefs save} did not work unless you already had a
     windowing preference saved.  This has been fixed.


{hline 8} {hi:update 21mar2011} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 11(1).


{hline 8} {hi:update 24feb2011} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb estat summarize} ignored the {cmd:c.} operator in interactions,
    treating all variables in an interaction as factor variables.  This has
    been fixed.

{p 5 9 2}
{* fix}
2.  {helpb margins} with option {cmd:vce(unconditional)} with robust
    results from {helpb mlogit} reported a conformability error.  This has
    been fixed.

{p 5 9 2}
{* fix}
3.  Mata's {helpb mf_moptimize:moptimize()} with a {cmd:gf0} evaluator,
    grouped data identified with the {cmd:moptimize_init_by()} setting, and
    weights reported a conformability error while taking numerical
    derivatives.  This has been fixed.

{p 5 9 2}
{* fix}
4.  When the eigenvector computation for Mata functions
    {helpb mf_symeigensystemselecti:symeigensystemselecti()} and
    {helpb mf_symeigensystemselectr:symeigensystemselectr()} did not converge,
    the functions incorrectly generated a "{err:conformability error}".
    This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} with
    two or more variables and more than 400 subpopulations implied by option
    {opt over()} incorrectly labeled the estimated summary statistics
    in the estimation table.  The first 400 subpopulation estimates were
    correctly associated with the first variable; all remaining subpopulation
    estimates for the first variable were associated with the second variable.
    A similar mislabeling of subpopulation estimates happened to the second
    and third variables, if specified.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ml} with a {cmd:gf0} evaluator, option {opt group()}, and
    weights reported a conformability error while taking numerical
    derivatives.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb glm_postestimation##predict:predict} with option {cmd:working}
    after {helpb glm} produced working residuals that were incorrectly
    multiplied by the reciprocal of the derivative of the link function
    instead of just the derivative itself.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb svy:svy:} {helpb clogit} using a replication method reported an
    incorrect population-size estimate.  It reported the sum of the sampling
    weights from each observation instead of the sum of one weight value from
    each group.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy jackknife} with a poststratification adjustment and
    subpopulation estimation reported a subpopulation size computed from the
    sum of unadjusted sampling weights instead of the poststratification
    adjusted sampling weights.  This has been fixed.


{hline 8} {hi:update 04jan2011} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 10(4).

{p 5 9 2}
{* fix}
2.  {helpb arch}, when used with {helpb capture}, sometimes failed to
    return the error code of the model.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb regress_postestimation##estatimtest:estat imtest} with option
    {opt preserve} reported an invalid syntax error when the model contained
    factor-variable notation.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb regress_postestimation##estatimtest:estat imtest} with models
    containing interactions of factor variables with many base levels exited
    with an error, usually because it attempted to create too many temporary
    variables or exceeded the maximum matrix size.  While this can still
    happen, {cmd:estat} {cmd:imtest} will now ignore all base-level factors
    and omitted variables in its internal calculations.

{p 5 9 2}
{* fix}
5.  {helpb gsort} sorted missing values ({cmd:.a}, ..., {cmd:.z}, and {cmd:.})
    in ascending order when a descending sort was specified.  This has been
    fixed.

{p 5 9 2}
{* fix}
6.  Mata's {helpb mf_moptimize##result_V_robust:moptimize_result_V_robust()},
    when used with evaluator type {cmd:gf} and a matrix set with
    {helpb mf_moptimize##init_by:moptimize_init_by()}, reported the error
    "{err:scores returned by evaluator not conformable with the dataset}" even
    when the scores matrix was conformable with the number of groups.  This
    has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ml check} with one of the {cmd:gf} evaluator types incorrectly
    failed in the first test, checking the value of the log-likelihood scalar.
    This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb nl} and {helpb nlsur} in the unusual case where the same linear
    combination was specified more than once within a single equation
    estimated unique parameters for each specification of the combination.
    They now estimate a single set of parameters that are used everywhere the
    combination is specified.

{p 5 9 2}
{* fix}
9.  {helpb nlogit} issued an error when commas were used in the constraints
    numlist.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb pwcorr} and {helpb spearman} incorrectly reported a p-value when
     rho was missing.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb sspace} issued an error for models with more than 100 parameters.
     This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb svy tabulate twoway:svy: tabulate} with option {opt row} (or
     {opt column}) and direct standardization where one of the standard strata
     does not intersect with a row (or column), instead of reporting the
     estimated row (or column) proportions, reported values that were scaled
     by the row (or column) total.  Usually, the row (or column) proportions
     sum to 1, but in this case they cannot.  Now {cmd:svy:} {cmd:tabulate}
     reports the row (or column) proportions as they were estimated, revealing
     where the sum of the row (or column) proportions do not add up to 1.

{p 4 9 2}
{* fix}
13.  {helpb xttest0} reported p-values that did not account for the null
     hypothesis being on the boundary of the variance parameter space.
     This has been fixed.


{hline 8} {hi:update 10nov2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb areg} with option {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}
    stored a temporary variable name in {cmd:e(datasignaturevars)} instead of
    the variable specified in option {opt absorb()}.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb biprobit} exited with an invalid syntax error when option
    {opt iterate()} was specified.  This has been fixed.

{p 5 9 2}
{* enhancement}
3.  Mata's {helpb mf_optimize:optimize()} now allows negative values to be set
    in {helpb mf_optimize##i_nmdeltas:optimize_init_nmsimplexdeltas()}.

{p 5 9 2}
{* fix}
4.  {helpb tobit} with robust variance estimates with a reduced rank did not
    update the {cmd:e(rank)} result.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb unzipfile} exited with an error when the {it:zipfilename} contained
    a space.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb xtpoisson} with option {opt fe} reported an
    {err:"o." operator not allowed} error when a time-series-operated variable
    was dropped because of collinearity.  This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
7.  Line numbers in the Do-file Editor did not draw at the correct location.
    This has been fixed.


{hline 8} {hi:update 04nov2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  There is now a dialog for command {helpb clonevar}.

{p 5 9 2}
{* fix}
2.  {helpb asclogit_postestimation##estatmfx:estat mfx} after {helpb asclogit}
    would exit with an error when the alternative variable was numeric without
    value labels.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb graph by:graph, by()} would exit with an error when any of the
    variables specified in option {cmd:by()} had value labels or string
    values that contained commas.  This has been fixed.

{p 5 9 2}
{* enhancement}
4.  {helpb lincom} and {helpb nlcom} now accept options {opt cformat()},
    {opt pformat()}, and {opt sformat()}; see
    {help estimation options##cformat:estimation options}.

{p 5 9 2}
{* fix}
5.  Mata's {helpb mf_deriv:deriv()} function with the verbose setting off
    still displayed notes when it encountered missing values, or flat or
    discontinuous regions.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ml maximize} ignored option {opt negh}.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb prais} with option {cmd:vce(robust)},
    {cmd:vce(cluster} {it:clustvar}{cmd:)},
    {cmd:vce(hc2)}, or {cmd:vce(hc3)} included the constant in the overall
    model F test.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb svy_tabulate:svy: tabulate} with option {opt level()} reported
    the error "{err:option level() not allowed}" when the supplied value did
    not match the value in {cmd:c(level)}.  This has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb twoway lfit}, {helpb twoway lfitci}, {helpb twoway qfit}, and
    {helpb twoway qfitci} now support {help tsvarlist:time-series operators}
    on both {it:yvar} and {it:xvar}.

{p 4 9 2}
{* fix}
10.  {helpb xtreg} with factor variables and option {opt sa} reported a
     "{err:variable not found}" error when the panels were not balanced.  This
     has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
11.  {helpb heckprob} with missing values in the {it:indepvars} where
     {it:depvar} was missing or {it:depvar_s} was equal to zero would
     sometimes report the error "{err:Hessian is not negative semidefinite}".
     The missing values were incorrectly being used in calculating the Hessian
     matrix.  This has been fixed.

{p 4 9 2}
{* fix}
12.  Mata's {helpb mf_moptimize:moptimize()} with the Nelder-Mead technique
     and evaluator types {cmd:lf}, {cmd:lf0}, {cmd:lf1}, and {cmd:lf2} exited
     with an error reporting an incorrect number of arguments.  This has been
     fixed.

{p 4 9 2}
{* fix}
13.  Mata's {helpb mf_moptimize##result_post:moptimize_result_post()} with the
     Nelder-Mead technique reported the error
     "{err:matrix has missing values}".  Because the Nelder-Mead technique
     does not provide a variance matrix, {cmd:e(V)} will not be posted, with
     one exception: when constraints are specified, a zero matrix will be
     posted to {cmd:e(V)}.

{p 4 9 2}
{* fix}
14.  Mata's {helpb mf_moptimize##util_vecsum:moptimize_util_vecsum()} used
     with a constant only equation and weights could crash Stata.  This has
     been fixed.

{p 4 9 2}
{* fix}
15.  In rare cases, {helpb merge} with option {cmd:update} could cause a
     crash.  This has been fixed.

{p 4 9 2}
{* enhancement}
16.  {helpb odbc} has new option {cmd:connectionstring()}, which allows you to
     specify a connection string instead of a DSN to connect to a database.
     See {helpb odbc} for more information on this option.

{p 4 9 2}
{* fix}
17.  Using a subexpression in a {help regex:regular expression} could cause a
     crash.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb xtabond}, {helpb xtdpd}, and {helpb xtdpdsys}, in the rare case
     where GMM-style instruments are created from a single lag of a variable,
     produced estimates that were based on an incorrect instrument matrix.
     This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
19.  When using the Do-file Editor to run a selection, and if 
     running the selection caused a {opt {hline 2}more{hline 2}}
     condition, the subsequent running of a selection from the Do-file Editor
     could cause Stata to generate the error message
     "{err:Encountered a sharing violation while accessing xxxx}",
     where xxxx was the name of a temporary file.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
20.  The diamond or plus symbols would be incorrectly rendered in graphs drawn
     to the screen, exported, or printed.  This has been fixed.

{p 4 9 2}
{* fix}
21.  Truetype font support in {help graph_export:graphs exported} as EPS files
     has been enabled in both GUI and console versions.  The console version
     now searches the standard Mac locations for fonts.

{p 4 9 2}
{* fix}
22.  Resizing a checkbox groupbox control in a programmable dialog could
     result in the control being clipped.  This has been fixed.


{hline 8} {hi:update 30sep2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 10(3).

{p 5 9 2}
{* enhancement}
2.  The {helpb icd9} databases have been updated to use the latest version
    (V28) of the ICD-9 codes, which will officially become effective on
    1 October 2010.

{p 5 9 2}
{* fix}
3.  {helpb ivregress} exited with an error when option {cmd:vce(cluster)}
    contained a string variable.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb margins} with unconditional variance estimates and survey
    subpopulation estimation results with some of the independent variables
    containing missing values in observations where the sampling weights were
    zero would report the error "{err:unconditional standard errors derived}
    {err:assuming full estimation sample; indepvars dropped observations}
    {err: from the estimation sample}".  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb mean}, {helpb proportion}, {helpb ratio}, {helpb total}, and
    {helpb svy_tabulate:svy: tabulate} would report an
    "{err:option not allowed}" error when one or more of the following
    settings were in effect:

{p 13 13 2}
        {cmd:set showemptycells off}{break}
        {cmd:set showbaselevels all}{break}
        {cmd:set showbaselevels off}{break}
        {cmd:set showomitted off}

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ml} has the following fixes:

{p 9 13 2}
    a.  Subcommand {opt footnote} was not recognized.  This has been fixed.

{p 9 13 2}
    b.  Subcommand {opt report} reported a Mata trace log when used with an
        evaluator that did not compute the Hessian matrix.  This has been
        fixed.

{p 9 13 2}
    c.  Option {opt group()} (and Mata's {helpb moptimize:moptimize()} with a
        group variable set using {cmd:moptimize_init_by()}) and a type
        {cmd:gf} evaluator exited with an error, usually resulting from a
        conformability error.  This has been fixed.

{p 9 13 2}
    d.  With option {opt noclear}, the estimation sample identifier was not
        generated as a {opt byte} variable.  This would result in a
        "{err:type mismatch}" error when {helpb mleval} was called.  This has
        been fixed.

{p 5 9 2}
{* fix}
7.  {helpb nestreg}, when used with {helpb intreg}, exited with an error
    instead of performing as expected.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb robvar} was treating observations with missing values in option
    {opt by(groupvar)} as another group when it should have excluded those
    observations from the analysis.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy_tabulate_twoway:svy: tabulate} with option {opt deff} or
    {opt deft} and either option {opt row} or option {opt column} would
    compute the marginal SRS variances incorrectly, resulting in incorrect
    DEFF and DEFT values in the row or column margins.  This has been fixed.

{p 4 9 2}
{* enhancement}
10.  The {help use:use with options} dialog box now allows you to select
     variables from the dataset on disk that you want to load into Stata.

{p 4 9 2}
{* fix}
11.  {helpb _vce_parse} marked out all observations if
     {cmd:vce(cluster} {it:clustvar}{cmd:)} was specified with {it:clustvar}
     being a string variable.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb xtmixed}, {helpb xtmelogit}, and {helpb xtmepoisson}, when used
     with prefix commands such as {helpb statsby} and {helpb bootstrap},
     issued a syntax error if options were specified within more than one
     model equation.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb xtsum} would terminate with an error when string variables were
     included in the variable list.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
14.  {helpb anova} and {helpb manova} with unbalanced data and interaction
     terms with empty cells could fail to properly fit the specified model,
     yielding incorrectly low values for sums of squares and their
     corresponding degrees of freedom.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb cluster measures} now accepts option {cmd:Gower}.

{p 4 9 2}
{* fix}
16.  In the {helpb format} dialog box, one of the sample quarterly formats was
     incorrect.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
17.  Scrolling in the Viewer window did not work correctly when viewing very
     large log files.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
18.  The currently selected variable in the Variables Manager is now scrolled
     into view if necessary when using the arrow button to navigate through
     the list of variables.

{p 4 9 2}
{* fix}
19.  Programmable dialogs on the Mac did not support resizing of controls.
     This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
20.  Using a dialog box varlist control on some 32-bit Ubuntu machines caused
     Stata to crash.  This has been fixed.


{hline 8} {hi:update 01sep2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb estat phtest} with option {cmd:detail}, after {helpb stcox} with
    robust/clustered standard errors, produced rho test statistics and
    p-values that did not take into account that robust standard errors were
    used in the original model.  Predictions of scaled Schoenfeld residuals,
    after {helpb stcox} with robust/clustered standard errors, were similarly
    affected.  Both issues have been fixed.

{p 5 9 2}
{* fix}
2.  {helpb graph twoway}, in the extremely rare case where a variable being
    graphed took on only a single value and when that same value was
    specified as the single label in option {cmd:xlabel()} or {cmd:ylabel()},
    exited with an error and did not draw the graph.  This has been
    fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb margins} now reports a warning when option {opt expression()}
    does not contain a reference to {opt predict()} or {opt xb()}.

{p 5 9 2}
{* fix}
4.  {helpb margins} with a factor variable in option {opt dydx()} failed
    to properly assign the omit operator to the column elements in {cmd:r(b)}
    that corresponded to the base level.  This has been fixed.

{p 5 9 2}
{* fix}
5.  The {bf:Populate} button on the {bf:Options} tab for the {cmd:merge}
    dialog box did not work if the path to the using dataset had a space in
    it.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ml} commands with a large number of independent variables in an
    equation occasionally reported an error about extra parameters when option
    {opt init()} or command {cmd:ml} {cmd:init} was used.  This has
    been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ml} reported an extraneous Mata trace log when it could not compute
    numerical derivatives for a model fit with constraints.  This has been
    fixed.

{p 5 9 2}
{* fix}
8.  {helpb nlogit} with option {cmd:collinear} will now allow the same
    variable to be specified in multiple level equations.

{p 5 9 2}
{* fix}
9.  Nonstationary {helpb sspace} models using {cmd:method(dejong)}, the
    default method, could terminate with an "{err:invalid subscript}" error.
    This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb stcurve} with options {cmd:at1()}, {cmd:at2()}, ..., {cmd:at10()}
     produced an error message if the dataset contained a {cmd:_merge}
     variable.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb sts graph} with options {cmd:by} and {cmd:censored()} could
     produce an incorrect survival curve if one individual was censored just
     before another individual failed.  This has been fixed.

{p 4 9 2}
{* fix}
12.  {helpb testparm} would incorrectly report the error
     "{err:no such variables}" when used with {helpb mlogit} results where the
     first equation was the base outcome.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {helpb tsset} with option {opt noquery} was not posting
     {cmd:r(tdelta)}.  This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb xtmixed}, when used to model a residual-error structure with
     exactly two parameters -- for example, distinct residual variances for
     males and for females -- in models with no random effects, would report a
     p-value for the likelihood-ratio (LR) comparison test that was half of
     what it should have been.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
15.  Expressions with factor-variable notation like

{p 13 13 2}
        {cmd:1.d - 2.d}

{p 9 9 2}
     where the variable name was the letter {cmd:d} or the letter {cmd:e}
     (lowercase or uppercase) would cause an "{err:invalid operator}" syntax
     error.  This has been fixed.

{p 4 9 2}
{* fix}
16.  {helpb merge:merge 1:m} with option {opt update}, in the rare case when
     1) there was a mismatch in the value of a variable with the same name in
     both master and using datasets, 2) when that value was missing in
     the master dataset, and 3) when that value varied in multiple observations
     of the using dataset, could use the first updated value from the using
     dataset in the subsequent matched observations.  This has been fixed.

{p 4 9 2}
{* fix}
17.  Mata functions {helpb mf_st_ms_utils:st_matrixcolstripe_fvinfo()} and
     {cmd:st_matrixrowstripe_fvinfo()}, when used with matrices containing an
     interaction with only continuous variables, would crash Stata.  This has
     been fixed.

{p 4 9 2}
{* fix}
18.  Mata functions {helpb mf_tokenget:tokenget()} and
     {helpb mf_tokenget:tokengetall()}, in the case where multiple characters
     were being treated as white-space characters, could fail to properly
     return tokens.  This has been fixed.

{p 4 9 2}
{* fix}
19.  Mata functions {helpb mf_tokenget:tokenget()} and
     {helpb mf_tokenget:tokengetall()}, in the case where multiple characters
     were being used as parsing characters, could fail to properly return
     tokens.  This has been fixed.

{p 4 9 2}
{* fix}
20.  Stata/MP was overoptimistic in parallelizing the Mata colon operator.
     Stata/MP would sometimes run much slower than Stata/SE with some Mata
     colon operations on small matrices.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
21.  {helpb haver} is now supported in 64-bit Stata for Windows.

{p 4 9 2}
{* fix}
22.  With {help autotabgraphs:tabbed graphs} enabled when using the Graph
     Editor, it was possible to switch away from the graph currently being
     edited to another graph.  This behavior was unsafe and in rare cases
     could lead to unsaved edits.  The Graph Editor now requires that you
     complete your edits to a single graph before editing a graph in another
     tab.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
23.  As a Viewer window was being resized, Stata for Mac automatically
     refreshed the content.  However, quickly clicking the Viewer window's
     size control could cause the Viewer to get in a state where further clicks
     in the Viewer caused the window to resize.  The Viewer now only refreshes
     a Viewer window after the mouse has been released off the size control.

{p 4 9 2}
{* fix}
24.  Syntax highlighting in the Do-file Editor could crash Stata if it
     encountered the // comment delimiter near the end of a do-file.  This has
     been fixed.

{p 4 9 2}
{* fix}
25.  When using the up or down cursor keys to navigate the Data Editor, the
     previously selected cell still displayed a selection box when the Data
     Editor was scrolled vertically.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
26.  Using the keyboard shortcut {bf:Ctrl}+{bf:w} in the Command window caused
     Stata to hang.  Stata for Unix (GUI) now ignores this shortcut for the
     Command window and allows the default key binding to take effect.


{hline 8} {hi:update 21jul2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb graph box} and {helpb graph hbox}, when the variable being graphed
    contained only two unique values, could in rare cases identify both values
    as outliers when only one value was an outlier.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb logistic}, when called under version control less than 11, would
    report an "{err:option} ... {err:not allowed}" error whenever any of the
    following settings were in effect:

	     {helpb set_showbaselevels:set showbaselevels all}
	     {helpb set_showbaselevels:set showbaselevels on}
	     {helpb set_showemptycells:set showemptycells off}
	     {helpb set_showomitted:set showomitted off}

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} with
    two or more variables in option {opt over()} and one of
    {cmd:vce(bootstrap)}, {cmd:vce(jackknife)}, {helpb svy bootstrap},
    {helpb svy brr}, {helpb svy jackknife}, or {helpb svy sdr} failed to
    properly identify the replicated point estimates.  With
    {cmd:vce(bootstrap)}, this resulted in the error message
    "{err:insufficient observations to compute bootstrap standard errors}".
    In the other cases, the subpopulation point estimates were labeled with
    generic integer indices without prefix {cmd:_subpop_}.  This has been
    fixed.

{p 5 9 2}
{* fix}
4.  {helpb mi impute} uses listwise deletion when predictors (or weights)
    contain missing values, which leads to a reduced number of observations
    being used during the estimation task.  {bind:{cmd:mi} {cmd:impute}} now
    reports a note to notify users when this happens.

{p 5 9 2}
5.  {helpb mi impute mvn} has the following new features and fixes:

{p 9 13 2}
{* enhancement}
     a.  {cmd:mi impute mvn} with a large number of variables is now
         significantly faster.

{p 9 13 2}
{* fix}
     b.  With more than 53 imputation variables, {cmd:mi impute mvn} could
         mistakenly treat adjacent missing-value patterns as a single pattern.
         In such cases, this would often result in an {search r(498)} error,
         "{err:imputed data contain missing values}", unless option
         {cmd:emonly} or {cmd:force} was specified.  If option {cmd:emonly}
         was specified or option {cmd:force} was used to proceed with
         imputation anyway, {cmd:mi} {cmd:impute} {cmd:mvn} produced EM
         parameter estimates and imputed values that were based on
         overinflated tallies of missing-value patterns.  This has been fixed.

{p 9 13 2}
{* fix}
     c.  In cases where predictors (right-hand-side variables) contained
         missing values, {cmd:mi impute mvn} did not account for the reduced
         numbers of observations during computation and thus produced
         incorrect imputed values.  This has been fixed.

{p 5 9 2}
{* fix}
6.  Mata's {helpb mf_moptimize:moptimize()} function
    {cmd:moptimize_result_coefs()} was documented but did not exist.  This
    has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ml plot} exited with a Mata run-time error the first time it was
    run after {cmd:ml} {cmd:model}.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb ml score} exited with an error message when used after an
    {cmd:lf}-family or {cmd:gf}-family evaluator.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb prais} exited with an error message if option {cmd:vce()} was
    specified.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb svy} mistakenly used observations where the poststrata variable
     contained a missing value.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb svy} with multistage data mistakenly used observations that
     contained missing values in a stratum variable in any but the last stage.
     This has been fixed.


{hline 8} {hi:update 01jul2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 10(2).

{p 5 9 2}
{* fix}
2.  Mata's {helpb mf_moptimize:moptimize()} and {helpb mf_optimize:optimize()}
    with the Nelder-Mead technique reported the unhelpful error message
    "Hessian is not negative semidefinite" when it should have reported
    "missing values returned by evaluator".  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb xtpoisson} with options {cmd:fe} and {cmd:vce(robust)} failed when
    factor variables were used.  This has been fixed.


{hline 8} {hi:update 16jun2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb estat bootstrap}, when reporting the default bias-corrected or the
    optional bias-corrected and accelerated confidence intervals (CIs) and in
    the rare case where the standard errors (SEs) were so large relative to
    the coefficient that the dataset was not truly identifying the parameter
    estimates, produced CIs that were overly conservative.  Specifically, the
    problem occurred only when the ratio of the SEs and the parameter
    estimates was on the order of 10 million (1e7) or greater.  This has been
    fixed.

{p 5 9 2}
{* fix}
2.  {helpb ml trace} reported a syntax error even when supplied with the
    correct syntax.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb svy} would incorrectly report that option {opt baselevels} was not
    allowed when {helpb set showbaselevels} was set to {cmd:on}.  This has
    been fixed.

{p 5 9 2}
{* fix}
4.  {helpb svy} would incorrectly report that option {opt allbaselevels} was
    not allowed when {helpb set showbaselevels} was set to {cmd:all}.  This
    has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb mean:svy: mean}, {helpb proportion:svy: proportion},
    {helpb ratio:svy: ratio}, and {helpb total:svy: total} with
    {opt vce(bootstrap)} and both option {opt subpop()} and option {opt over()}
    would report an invalid syntax error if there were two or more overgroups.
    This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb svy_tabulate:svy: tabulate} with options {opt cv} and {opt percent}
    would report coefficients of variations that were too large by a factor of
    100.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
7.  {helpb outsheet} could crash Stata if a {help format:date format} and
    {help label:value label} were assigned to a variable.  This has been
    fixed.

{p 5 9 2}
{* fix}
8.  {helpb _pctile} with option {opt percentile()} containing a value
    within 1e-15 in relative difference to 100 would cause Stata to crash.
    This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb svy} estimation commands with independent variables in multiple
    equations (such as {cmd:svy: mlogit}) and {helpb svyset}
    poststratification variables would report incorrect standard errors in all
    but the first equation or would report the error
    {err:estimates post: matrix has missing values}.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
10.  Stata would crash if the Variable Properties window was used to navigate
     to an empty column in the Data Editor.  This has been fixed.

{p 4 9 2}
{* fix}
11.  The Data Editor could display drawing artifacts when there were few
     variables and the scrollbar was quickly set to its maximum value.  This
     has been fixed.


{hline 8} {hi:update 03jun2010} (Stata version 11.1) {hline}

    {title:What's new in release 11.1 (compared with release 11.0)}

{pstd}
Highlights for release 11.1 include the following:

{p 8 11 2}
{cmd:o}{space 2}{bf:Multiple imputation}.  The {helpb mi} command now
        officially supports fitting panel-data and multilevel models.  See
        {help mi estimation}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Truncated count-data models}.  New commands
        {helpb tpoisson} and {helpb tnbreg} fit models of count-data outcomes
        with any form of left truncation, including truncation that varies by
        observations.

{p 8 11 2}
{cmd:o}{space 2}{bf:Mixed models}.  Linear mixed (multilevel) models have new
        covariance structures for the residuals: exponential, banded, and
        Toeplitz.  See {helpb xtmixed}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Probability predictions}.  {cmd:predict} after
        count-data models, such as {helpb poisson} and {helpb nbreg}, can now
        predict the probability of any count or any count range.

{p 8 11 2}
{cmd:o}{space 2}{bf:Survey bootstrap}.  Estimation commands can now estimate
        survey bootstrap standard errors (SEs) using user-supplied bootstrap
        replicate weights.  See {helpb svy bootstrap}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Survey SDR weights}.  Successive difference replicate
        (SDR) weights are now supported when estimating with survey data.
        These weights are supplied with many datasets from the U.S. Census
        Bureau.  See {helpb svy sdr}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Concordance}.
        {helpb stcox_postestimation##estatcon:estat concordance} adds a new
        measure of concordance, G{c o:}nen and Heller's K, that is robust in
        the presence of censoring.

{p 8 11 2}
{cmd:o}{space 2}{bf:Survey GOF}.  Goodness-of-fit (GOF) tests are now
        available after {helpb probit} and {helpb logistic} estimates on
        survey data.  See {help svy estat}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Robust SEs}.  Cluster-robust SEs have been added to
	{helpb xtpoisson:xtpoisson, fe}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Survey CV}.  The coefficient of variation (CV) is now
        available after estimation with survey data.  See {help svy estat}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Estimation formatting}.  Numerical formats can now be
        customized on regression results.  You can set the number of decimal
        places for coefficients, SEs, p-values, and confidence intervals using
        either command-line arguments or the {cmd:set} command.  See
        {help estimation options} and {helpb set cformat}.

{p 11 11 2}
        Settings have also been added to control the display of factor
        variables in estimation tables.  These display settings include
        display of empty cells, display of base levels, and omitting variables
	excluded because of collinearity.  See {helpb set showbaselevels} and
        {bf:{stata query output:query output}}.

{p 8 11 2}
{cmd:o}{space 2}{bf:Stata/MP performance}. Stata/MP, the parallel version of
        Stata, has several performance improvements:  many panel-data
        estimators are even more parallelized, improved parallelization of
        estimations with more than 200 covariates, improved tuning of MP on
        large numbers of processors/cores.

{p 8 11 2}
{cmd:o}{space 2}{bf:Clipboard improvements}.  Clipboard support in the Data
        Editor has been enhanced.  Copies to the Clipboard now retain
        variable formats and other characteristics of the data when pasting
        within Stata.

{p 8 11 2}
{cmd:o}{space 2}{bf:Windows XP}.  The amount of memory available to Stata has
        been increased on 32-bit Windows XP.

{p 8 11 2}
{cmd:o}{space 2}{bf:Do-file Editor}.  Syntax highlighting, bookmarks, and
        other Do-file Editor features have been added to Stata for Mac.

{p 8 11 2}
{cmd:o}{space 2}{bf:ODBC}.  {help odbc:ODBC} support has been added for Oracle
        Solaris (Sun Solaris).

{p 8 11 2}
{cmd:o}{space 2}{bf:Dialog boxes}.  Dialog boxes on Unix now have varlist
        controls that allow you to select variables from a list of variables
        in your dataset.


    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb datasignature}, when used under version control with a version less
    than 10, was not saving the resulting data signature in
    {cmd:r(datasignature)}.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb _diparm} reported that it could not find the {cmd:_cons}
    coefficient for the specified equation when it was marked as omitted with
    the {cmd:o.} operator.  This has been fixed.

{p 5 9 2}
{* enhancement}
3.  {helpb stcox_postestimation##estatcon:estat concordance} provides a new
    concordance measure, G{c o:}nen and Heller's K concordance coefficient,
    which is robust to censoring unlike the conventional Harrell's C index.
    The new measure is available by using option {cmd:gheller}.

{p 5 9 2}
{* enhancement}
4.  {helpb svy_estat:estat cv} is a new postestimation command available with
    {helpb svy} estimation results.  {cmd:estat} {cmd:cv} reports a table of
    coefficients of variation for each coefficient in the current estimation
    results.

{p 5 9 2}
{* enhancement}
5.  {helpb svy_estat:estat gof} is now available after
    {cmd:svy:} {cmd:logistic}, {cmd:svy:} {cmd:logit}, and
    {cmd:svy:} {cmd:probit}.  {cmd:estat gof} reports a goodness-of-fit test
    for logistic and probit regression models that were fit using complex
    survey data.

{p 5 9 2}
{* fix}
6.  {helpb estat summarize} has the following fixes:

{p 9 13 2}
    a.  It reported zero values for levels of factor variables that were less
        than the base level as set by {helpb fvset}.  This has been fixed.

{p 9 13 2}
    b.  It reported incorrect values for interactions involving factor
        variables when the level of the factor variable was less than the base
        level as set by {helpb fvset}.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb regress_postestimation##estatvif:estat vif} produced incorrect
    results when used with a subset of the data.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb estimates replay} would issue the error
    {err:last estimates not found} when used after
    {cmd:mi estimate, post: regress}.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb expandcl} with an {helpb if} restriction would also add
    observations even where the {cmd:if} restriction was false.  This has been
    fixed.

{p 4 9 2}
{* fix}
10.  In rare cases, {helpb gmm} would exit with an error message if option
     {opt xtinstruments()} was used and the data contained many gaps.
     This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb heckman} has the following fixes:

{p 9 13 2}
     a.  When the two-step estimator was used and weights were specified,
         {cmd:heckman} ignored the weights and produced unweighted two-step
         estimates.  Now an error message is produced indicating that weights
         are not allowed with the two-step estimator.

{p 9 13 2}
     b.  When the maximum likelihood estimator was used and the BHHH
         maximization technique was requested, {cmd:heckman} exited with an
         error message even though the BHHH technique is allowed.  This has
         been fixed.

{p 4 9 2}
{* fix}
12.  {helpb margins}, when used after {helpb glm} with either a {cmd:power} or
     an {cmd:opower} (odds power) link, would erroneously report that the
     default prediction is a function of possibly stochastic quantities other
     than {cmd:e(b)}.  {cmd:margins} now proceeds with the prediction.

{p 4 9 2}
{* enhancement}
13.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} with
     option {opt over()} are now faster, especially when used
     with replication-method option {cmd:vce(bootstrap)} or
     {cmd:vce(jackknife)} or with prefix command {helpb svy brr} or
     {helpb svy jackknife}.

{p 4 9 2}
14.  {helpb mi estimate} has the following new features and fixes:

{p 9 13 2}
{* enhancement}
     a.  {cmd:mi estimate} now officially supports estimation of
         many panel-data and multilevel models with multiply imputed data; see
         {help mi estimation} for a list of supported commands.

{p 9 13 2}
{* fix}
     b.  When the number of tested coefficients in the model test exceeded
         model degrees of freedom, {cmd:mi estimate} reported a
         minimum-degrees-of-freedom test based on a reduced set of
         coefficients.  It now reports a missing value and provides a link to
         the description of why the joint model test of all coefficients could
         not be performed.

{p 9 13 2}
{* fix}
     c.  {cmd:mi estimate} reported nonmissing multiple-imputation standard
         errors when some of the within-imputation standard errors were
         reported to be missing.  This has been fixed.

{p 9 13 2}
{* fix}
     d.  {cmd:mi estimate, post} would incorrectly set macro {cmd:e(cmd)}
         to the contents of macro {cmd:e(cmd2)} if that macro was set by
         the estimation command used with {cmd:mi estimate}.  This has been
         fixed.

{p 4 9 2}
{* fix}
15.  {helpb mi test} used the rank of the VCE matrix instead of its inverse to
     determine model degrees of freedom.  In rare cases where,
     computationally, these ranks did not coincide, {cmd:mi test} reported
     incorrect model degrees of freedom.  This has been fixed.

{p 4 9 2}
{* fix}
16.  In rare cases, {helpb ml} and Mata's {helpb mf_moptimize:moptimize()},
     when rescaling the parameters during a search for starting values,
     reported a Mata run-time error.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb ml} reported a conformability error with a Mata trace log when
     having difficulty computing numerical derivatives for methods {cmd:lf},
     {cmd:lf0}, and {cmd:gf0}.  This has been fixed.

{p 4 9 2}
{* enhancement}
18.  {cmd:predict} after {helpb gnbreg}, {helpb nbreg},
     {helpb poisson}, {helpb xtgee}, {helpb xtnbreg}, {helpb xtpoisson},
     {helpb zinb}, and {helpb zip} has two new options:
     {opt pr(n)} and {opt pr(a,b)}.  Postestimation command
     {cmd:predict varname, pr(}{it:n}{cmd:)} stores the probability
     Pr(y = n) for the specified model in {cmd:varname}, where n
     can be a number or a variable.  Postestimation command
     {cmd:predict varname, }{opt pr(a,b)} stores the probability
     Pr(a {ul:<} y {ul:<} b) for the specified model in {cmd:varname}, where
     a and b can be a number or a variable.

{p 4 9 2}
{* enhancement}
19.  {cmd:predict} after {helpb sspace} and {helpb dfactor} now allow dynamic
     forecasting when the estimation's dependent variables included
     time-series operators.

{p 4 9 2}
{* fix}
20.  Dynamic forecasts from
     {helpb sspace_postestimation##predict:predict, dynamic()} after
     {helpb sspace} could be incorrect if the dependent variables in the
     observation equations were not in the same order as listed in the dataset
     and were included on the right-hand side of an observation equation.

{p 4 9 2}
{* fix}
21.  {helpb xtmixed_postestimation##predict:predict} after {helpb xtmixed}
     with a model containing an empty random-effects structure would produce
     an error message if predicted fitted values (option {cmd:fitted}),
     residuals (option {cmd:residuals}), or standardized residuals (option
     {cmd:rstandard}) were out of sample.  This has been fixed.

{p 4 9 2}
{* fix}
22.  {helpb xtnbreg_postestimation##predict:predict} with option {cmd:iru0},
     when used after {helpb xtnbreg:xtnbreg, re}, created a new variable when
     the estimated value of r was less than one and the expected value was
     undefined.  An appropriate error message is now produced.

{p 4 9 2}
{* fix}
23.  {helpb rocfit} with option {cmd:continuous} could produce fewer groups
     than specified.  This has been fixed.

{p 4 9 2}
{* fix}
24.  The dialog box for {helpb rolling} concatenated options {opt clear} and
     {opt keep} when specified together.  This has been fixed.

{p 4 9 2}
{* fix}
25.  {helpb sqreg} coefficient labels for quantiles less than 0.1 were missing
     the leading zeros.  This has been fixed.  For example,
     {cmd:quantile(0.025)} is now labeled as {cmd:q025} instead of {cmd:q25}.

{p 4 9 2}
{* fix}
26.  {helpb sspace} did not allow the wildcard character {cmd:*} in a
     {it:varlist} specification.  This has been fixed.

{p 4 9 2}
{* enhancement}
27.  {helpb svy} has new option {opt dof()} for specifying the design
     degrees of freedom.  This option overrides the default calculation,
     {it:df} = {it:N_psu} - {it:N_strata}.

{p 4 9 2}
{* enhancement}
28.  {helpb svy bootstrap} is a new prefix command for performing bootstrap
     variance estimation for survey data.  {cmd:svy} {cmd:bootstrap} requires
     that the bootstrap replicate weights be {helpb svyset}.

{p 4 9 2}
{* fix}
29.  {helpb svy_jackknife:svy jackknife} with {helpb svyset} {cmd:iweight}s
     and suboption {opt multiplier()} of {opt jkrweight()} incorrectly
     computed the design degrees of freedom.  This has been fixed.

{p 4 9 2}
{* enhancement}
30.  {helpb svy sdr} is a new prefix command for performing successive
     difference variance estimation for survey data.  {cmd:svy} {cmd:sdr}
     requires that the replicate weights be {helpb svyset}.

{p 4 9 2}
{* enhancement}
31.  {helpb svy_tabulate:svy: tabulate} has new option {opt cv}, which
     specifies that {cmd:svy} {cmd:tabulate} display the coefficient of
     variation for each cell in the table.

{p 4 9 2}
{* fix}
32.  {helpb svy_tabulate:svy: tabulate} now reports the error
     {err:matsize too small} much earlier when option {opt stdize()}
     identifies more groups than {help matsize} would allow.

{p 4 9 2}
33.  {helpb svyset} has the following new features:

{p 9 13 2}
{* enhancement}
     a.  New option {opt bsrweight()} sets bootstrap replicate weights, and
         new option {opt bsn()} sets the variance multiplier for mean
         bootstrap replicate weights.  New option {cmd:vce(bootstrap)} sets
         the default method for variance estimation to be the bootstrap.

{p 9 13 2}
{* enhancement}
     b.  New option {opt sdrweight()} sets successive difference replicate
         weights.  New option {cmd:vce(sdr)} sets the default method for
         variance estimation to be the successive difference replication
         method.

{p 9 13 2}
{* enhancement}
     c.  New option {opt dof()} specifies the design degrees of freedom.  This
         option overrides the default calculation,
         {it:df} = {it:N_psu} - {it:N_strata}.

{p 4 9 2}
{* enhancement}
34.  {helpb tnbreg} is a new command that implements truncated negative
     binomial regression for any nonnegative truncation point.  Truncation
     can be specified as a number or a variable, which allows for varying
     truncation values.  Additionally, options have been added to return
     conditional and unconditional probabilities for the truncated negative
     binomial regression model.

{p 4 9 2}
{* enhancement}
35.  {helpb tpoisson} is a new command that implements truncated Poisson
     regression.  Truncation can be specified as a number or a variable, which
     allows for varying truncation values.  Additionally, options have been
     added to return conditional and unconditional probabilities for the
     truncated Poisson regression model.

{p 4 9 2}
{* enhancement}
36.  {helpb xtmixed} now supports three new residual variance-covariance
     structures:  {cmd:banded}, {cmd:toeplitz}, and {cmd:exponential}; see
     {helpb xtmixed} for details.

{p 4 9 2}
{* fix}
37.  With {helpb version} set to less than 11.1, {helpb xtnbreg:xtnbreg, re}
     returns {cmd:xtn_re} in {cmd:e(cmd2)} and {helpb xtnbreg:xtnbreg, fe}
     returns {cmd:xtn_fe} in {cmd:e(cmd2)}.  As of version 11.1,
     {cmd:xtnbreg} instead returns {cmd:e(model)}, containing {cmd:re},
     {cmd:fe}, or {cmd:pa} to indicate which model was specified.

{p 4 9 2}
{* enhancement}
38.  {helpb xtpoisson} now returns {cmd:e(model)}, containing {cmd:re},
     {cmd:fe}, or {cmd:pa} to indicate which model was specified.

{p 4 9 2}
{* fix}
39.  {helpb xtrc} has the following fixes:

{p 9 13 2}
     a.  {cmd:xtrc}, when used with factor-variable notation, produced
         erroneous results if any variables were dropped because of
         collinearity while performing OLS regression on each of the panels.
         In other cases, {cmd:xtrc} exited with an error message if any
         variables were dropped because of collinearity while performing those
         regressions.  Both issues have been fixed.

{p 9 13 2}
     b.  {cmd:xtrc} drops panels with fewer observations than the number of
         {it:indepvars} but failed to report the proper error message when the
         entire estimation sample was dropped.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
40.  {helpb ereturn display} is now allowed after {helpb regress}.

{p 4 9 2}
41.  {help estimation commands} have the following new features:

{p 9 13 2}
{* enhancement}
     a.  Three new {help estimation options:display options} control
         formatting within the coefficient table.  {opt cformat()} controls
         the formatting of coefficients, standard errors, and confidence
         limits.  {opt sformat()} controls the formatting of test statistics.
         {opt pformat()} controls the formatting of p-values.  These options
         override the default output format for individual estimation
         commands.

{p 9 13 2}
{* enhancement}
     b.  Three new settings control formatting within the coefficient table.
         {helpb set cformat} controls the formatting of coefficients, standard
         errors, and confidence limits.  {helpb set sformat} controls the
         formatting of test statistics.  {helpb set pformat} controls the
         formatting of p-values.  These settings override the default output
         format for all estimation commands.

{p 9 13 2}
{* enhancement}
     c.  Three new settings control what is shown in the coefficient table.
         {helpb set showbaselevels} controls the output of base levels for
         factors and interactions.  {helpb set showemptycells} controls the
         output of empty cells for factors and interactions.
         {helpb set showomitted} controls the output of omitted coefficients.

{p 4 9 2}
{* fix}
42.  Factor-variable interactions were not parsed properly.  The specific
     conditions that triggered this were as follows:

{p 9 13 2}
     a.  You specified a simple interaction (a single {cmd:#} sign) between
         two or more factor variables.

{p 9 13 2}
     b.  The first variable in the interaction had the value zero as one of
         its categories.

{p 9 13 2}
     c.  The first specification in the interaction had a base level that is
         not the default of zero (the lowest level for the first variable).

{p 9 13 2}
     d.  At least one of the remaining variables in the interaction had a base
         equal to the lowest-valued category for that variable, whether
         explicitly specified or taken as the default.

{p 9 9 2}
     When the above conditions occurred, Stata attempted to omit an extra cell
     in the interaction.  Sometimes, the cell would be omitted altogether;
     other times, Stata produced a coefficient for that cell, but it produced
     missing standard errors and confidence intervals.  Either way, the model
     fit was thrown off because the cell's coefficient was not properly
     estimated.  Almost all estimation commands were affected by this bug,
     with {cmd:regress} being one notable exception.  This has been fixed.

{p 4 9 2}
{* fix}
43.  {helpb margins} with abbreviated names in options {opt at()},
     {opt dydx()}, {opt dyex()}, {opt eydx()}, and {opt eyex()} picked
     non-factor variables that matched the abbreviation, even when a factor
     variable was intended.  These options now check for perfect matches and
     report an error for ambiguous abbreviations.

{p 4 9 2}
{* fix}
44.  {helpb matrix dissimilarity} with options {cmd:gower} and {cmd:variables}
     and with the number of observations exceeding {help matsize} crashed
     Stata.  This has been fixed.

{p 4 9 2}
{* fix}
45.  {helpb mlogit} failed to flag the {it:indepvars} in the base equations as
     omitted.  This has been fixed.

{p 4 9 2}
{* fix}
46.  {helpb summarize} with option {cmd:format} formatted the Std. Dev. as
     a date if the variable you specified had a date format, even after the
     11feb2010 update.  This has been fixed.

{p 4 9 2}
{* fix}
47.  {helpb svy_total:svy: total} would randomly but rarely produce
     {cmd:e(V_srssub)} and {cmd:e(V_srssubwr)} matrices filled with zeros
     instead of with the correct variance estimates.  This has been fixed.

{p 4 9 2}
{* enhancement}
48.  {helpb tobit} now accepts time-series operators.

{p 4 9 2}
{* enhancement}
49.  {helpb xtpoisson} with option {cmd:fe} now supports {cmd:vce(robust)}.

{p 4 9 2}
{* fix}
50.  {helpb xtprobit} with option {cmd:intmethod(aghermite)} would not allow
     factor variables in Stata/MP.  This has been fixed.

{p 4 9 2}
{* fix}
51.  In rare circumstances, accessing the Internet from within Stata could
     cause Stata to crash.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
52.  {cmd:set memory} on a 32-bit Windows XP computer with Service Pack 3
     installed may now be able to allocate more memory, depending on your
     computer's particular configuration.

{p 4 9 2}
{* enhancement}
53.  For executable updates, {helpb update swap} will now get called
     automatically when the update completes.  This behavior has been the
     default for Windows Vista and Windows 7 with User Account Control (UAC)
     enabled and will now be extended to include all versions of Windows.  The
     new behavior will take effect on subsequent executable updates.

{p 4 9 2}
{* fix}
54.  The Do-file Editor has the following fixes:

{p 9 13 2}
     a.  When a long do-file was opened, the first line was scrolled off the
         screen, so the first visible line was the second line.  This has been
         fixed.

{p 9 13 2}
     b.  When doing a "Replace All", if the "Regular Expression" checkbox was
         checked, Stata might get into an infinite loop depending on the
         regular expression being replaced.  This has been fixed.

{p 4 9 2}
{* fix}
55.  Opening PDF documentation from Stata could cause any open log files to
     become locked until Adobe Reader was closed.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
56.  The Do-file Editor has the following new features:

{p 9 13 2}
{* enhancement}
     a.  Syntax highlighting.  See the Do-file Editor preferences in the
         General Preferences dialog for syntax highlighting options.

{p 9 13 2}
{* enhancement}
     b.  Line numbers.

{p 9 13 2}
{* enhancement}
     c.  Bookmarks for lines.  Bookmarks allow you to navigate between lines
         that have been bookmarked.  To add a bookmark for a line, click on
         the line number for the line.  To remove a bookmark from a line,
         click on the line's marker.  Click on the Next Bookmark toolbar
         button to move the cursor from its current position to the next
         bookmarked line.  Click on the Previous Bookmark toolbar button to
         move the cursor from its current position to the previous bookmarked
         line.

{p 4 9 2}
{* fix}
57.  The Do-file Editor no longer opens files already open in the Do-file
     Editor in multiple Do-file Editor windows.  If you attempt to open a file
     that is already open, the file's Do-file Editor window is brought to the
     front.

{p 4 9 2}
{* fix}
58.  The 09mar2010 update introduced a bug where clicking on the Open button
     of the Graph window's toolbar caused Stata to crash.  This has been
     fixed.

{p 4 9 2}
{* fix}
59.  When loading a previously saved set of preferences, the Results window
     would not be resized and moved to the saved window size and location if
     the saved Results window font was different from the current font.  This
     has been fixed.

{p 4 9 2}
{* fix}
60.  Mac OS X would set the current directory for the Open and Save dialogs to
     Stata's preferences directory after saving preferences.  Stata now sets
     the current directory for the Open and Save dialogs back to the previous
     directory after saving preferences.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
61.  In release 10.04 of the Ubuntu distribution of Linux, the data in Stata's
     memory could become corrupt.  This was caused by a change in the
     behavior of a low-level call in an operating system library in the
     Ubuntu distribution of Linux.  This was restricted to only the Ubuntu
     10.04 distribution of Linux.  This has been fixed.

{p 4 9 2}
{* fix}
62.  A filter search in the Variables Manager did nothing.  This has been
     fixed.


{hline 8} {hi:update 20apr2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  As of the 09mar2010 update, the speed of Stata/MP for many panel-data
    estimators was improved by reducing the unparallelized regions of the
    commands.  Faster commands include {helpb xtgee}, {helpb xtgls},
    {helpb xthtaylor}, {helpb xtintreg}, {helpb xtlogit}, {helpb xtnbreg},
    {helpb xtpcse}, {helpb xtpoisson}, {helpb xtprobit}, {helpb xtreg},
    {helpb xtregar}, and {helpb xttobit}.

{p 5 9 2}
{* fix}
2.  {helpb xtunitroot ips} would exit with an error message if the panels
    contained too few time periods to compute p-values for the Z_t-tilde-bar
    test statistic.  This has been fixed.

{p 5 9 2}
{* fix}
3.  The dialog box for {helpb infix} did not specify a default file extension
    for a dictionary.  This has been fixed.

{p 5 9 2}
{* fix}
4.  The dialog box for controlling paired-coordinate arrowhead properties
    failed to work.  This has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
5.  {helpb anova} and other commands specified with multiple interactions
    split between two or more {cmd:i.(}{it:...}{cmd:)} groups that shared two
    or more variables, and one or more of them containing parentheses-bound
    terms in their specification, would occasionally omit some of the
    interaction terms or even crash Stata.  This was a rare occurrence except
    with the slash operator, {cmd:/}, in {helpb anova} and {helpb manova}.
    This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
6.  Programmable dialogs that used an empty file filter to open files
    caused Stata to crash.  This has been fixed.


{hline 8} {hi:update 25mar2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 10(1).

{p 5 9 2}
{* fix}
2.  {helpb estimates use} would not recognize valid estimation results that
    were {helpb estimates store}d with {helpb set dp:set dp comma} in effect.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb margins} with continuous variables in option {opt dydx()} and
    with {helpb set dp:set dp comma} in effect would report a cryptic invalid
    name error.  This has been fixed.

{p 5 9 2}
{* fix}
4.  The {cmd:odbc load} dialog did not bring up the file chooser dialog for
    Excel files and MS Access Database data source names, even after the
    {cmd:11feb2010} update.  This has been fixed.


{hline 8} {hi:update 09mar2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  The display of results for most estimation commands is now faster because
    {helpb _coef_table} and {helpb ereturn display} are faster.  This speedup
    will be most noticeable when running many estimation commands on small
    samples.

{p 5 9 2}
{* enhancement}
2.  {helpb describe}, in addition to its other capabilities, can now produce a
    dataset containing the description.  {cmd:describe} does this when new
    option {cmd:replace} is specified.

{p 5 9 2}
{* enhancement}
3.  {helpb ds}, temporarily moved to "previously documented", is now restored
    to being an official, documented command of Stata.  To be clear, {cmd:ds}
    is as fully up to date and fully supported as any other official command
    of Stata.

{p 5 9 2}
{* fix}
4.  {helpb graph hbar}, {helpb graph hbox}, and {helpb graph dot} did not
    honor option {cmd:yline()}.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb graph pie} could fail with an error when options {cmd:by()} and
    {cmd:over()} were combined and when the number of categories in the
    over-groups differed across by-groups.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb histogram} with a reference to an {cmd:r()} result in the {cmd:if}
    condition, such as

{p 13 13 2}
        {cmd:. summarize mpg, detail}{break}
        {cmd:. histogram mpg if mpg < r(p50)}

{p 9 9 2}
    would result in an incorrect graph, even after the {cmd:11feb2010} update.
    This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb mi estimate}, when used with {helpb mlogit} or {helpb mprobit}
    where the base outcome was the first level of the {it:depvar}, reported
    the note "(base outcome)" instead of the specified transformations.  This
    has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb ml check}, when used with {cmd:lf0}, {cmd:lf1}, or {cmd:lf2}
    evaluator types, would incorrectly report a failure caused by the evaluator
    not setting the log-likelihood scalar in the first test.  This has been
    fixed.

{p 5 9 2}
{* fix}
9.  {helpb ologit} and {helpb oprobit} failed to report the offset variable in
    the coefficient table when there were no {it:indepvars}.  This has been
    fixed.

{p 4 9 2}
{* fix}
10.  {helpb svy_tabulate_oneway:svy: tabulate oneway} and
     {helpb svy_tabulate_twoway:svy: tabulate twoway}, when used with missing
     values in one or both of the direct standardization variables, specified
     in options {opt stdize()} and {opt stdweight()}, would report inflated
     values for the cell observations.  This has been fixed.

{p 9 9 2}
     All other cell statistics were properly computed in this case.

{p 4 9 2}
{* enhancement}
11.  {helpb tsset} and {helpb xtset} have new option {opt noquery}.

{p 4 9 2}
{* fix}
12.  {helpb xtrc} incorrectly marked some elements of column names of
     {cmd:e(b)} as omitted based on the sample identified by the last panel.
     This only affected the coefficient table if option {opt noomitted} was
     specified.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
13.  Expressions involving {help quotes:compound double quoted strings} that
     contained a single right quote could in rare cases cause the string to be
     misinterpreted.  This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb fmtwidth()} did not recognize centered string formats.  This has
     been fixed.

{p 4 9 2}
{* fix}
15.  {helpb margins} was incorrectly reporting "(not estimable)" with
     estimation results from commands like {helpb heckman} and
     {helpb heckprob} that allow certain missing-value patterns in the
     independent variables.  This has been fixed.

{p 4 9 2}
16.  Mata has the following fixes:

{p 9 13 2}
{* fix}
    a.  {helpb mf__editmissing:_editmissing()} called thousands of times could
        cause Mata to produce a stack overflow error message.  This has been
        fixed.

{p 9 13 2}
{* fix}
    b.  {helpb mf_fmtwidth:fmtwidth()} did not recognize centered string
        formats.  This has been fixed.

{p 9 13 2}
{* fix}
    c.  {helpb mf_printf:printf()} was not correctly handling date-time
        formats containing "\n", "\t", and "\r".  This has been fixed.

{p 9 13 2}
{* fix}
    d.  {helpb mata mlib add} reported an invalid opcode error when attempting
        to add a class definition to an {cmd:mlib} file.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb test} with the syntax

{p 13 13 2}
         {cmd:test} {cmd:[}{it:eq}{cmd:]}{it:element}

{p 9 9 2}
     or

{p 13 13 2}
         {cmd:test} {cmd:[}{it:eq}{cmd:]:}{it:element}

{p 9 9 2}
     would report the error

{p 13 13 2}
         {error}[{it:eq}]o.{it:element} not found{reset}

{p 9 9 2}
     when {it:element} was omitted in the first equation but not in equation
     {it:eq}.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb test} failed to recognize the Break key when working with
     estimation results with a large number of elements in {cmd:e(b)}.  This
     has been fixed.

{p 4 9 2}
{* enhancement}
19.  Previously, pasting into the Data Editor was not allowed with a filter
     applied for observations.  This restriction has been loosened so that the
     user can override this behavior.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
20.  On Windows XP, {bf:File > Open...} on the main Stata window and the
     Do-file Editor displayed the old-style Windows "File Open" dialog.  This
     has been fixed.

{p 4 9 2}
{* fix}
21.  Switching from another window to Stata should automatically focus Stata's
     Command window; however, this feature was unintentionally disabled in the
     11feb2010 executable update.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
22.  You can now select all text in the Review window by selecting the
     {bf:Edit > Select All} menu item when the Review window has the keyboard
     focus.

{p 4 9 2}
{* enhancement}
23.  The default behavior for the Open dialog is to allow only files that
     Stata recognizes to be opened.  A file format pop-up button has been added
     to the Open dialog that allows you to limit the opening of files to all or
     just a subset of the file types that Stata recognizes.  You can also set
     the Open dialog to open any file and any file type that Stata does not
     recognize in the Do-file Editor.  The file format pop-up button does not
     show all file types that Stata recognizes but just the ones that are most
     commonly opened by Stata users.

{p 4 9 2}
{* enhancement}
24.  The Do-file Editor's Save dialog now includes a file format pop-up button
     that allows you to specify the file extension to use in the filename.

{p 4 9 2}
{* fix}
25.  The 11feb2010 update added the ability to open a do-file from the Finder
     in the Do-file Editor instead of executing it.  However, the current
     working directory was changed to the location of the do-file.  This has
     been fixed.

{p 4 9 2}
{* fix}
26.  Navigating the Data Editor with the cursor keys would not work after
     entering or changing a value in the main edit field.  This has been
     fixed.

{p 4 9 2}
{* fix}
27.  When using the Make Text Bigger or Make Text Smaller menu items to change
     the font size of the Results or Viewer windows, the windows are
     automatically resized to maintain the same number of rows and columns
     currently visible.  However, the windows would move slightly from their
     original positions while they were being resized.  This has been fixed.

{p 4 9 2}
{* fix}
28.  When exporting graphs to PostScript or Encapsulated PostScript (EPS)
     files, extended ASCII characters would not be outputted correctly and
     could appear blank in the resulting files when viewed.  This has been
     fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
29.  {helpb odbc} is now supported on Solaris.

{p 4 9 2}
{* enhancement}
30.  The Data Editor now has a preference for disabling visual gradients.
     Enabling this preference can increase the speed at which the Data Editor
     refreshes its display when running Stata over a network.


{hline 8} {hi:update 11feb2010} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {helpb arima}, on very rare occasions, would exit with a "matrix not
    symmetric" error.  This has been fixed.

{p 5 9 2}
{* fix}
2.  {helpb bsample}, when used with option {opt cluster()}, would exit
    with an incorrect error message if the requested sample size was greater
    than the number of clusters.  Now a better error message is produced.

{p 5 9 2}
{* fix}
3.  {helpb fracplot} and {helpb fracpred:fracpred, dresid} now produce an
    appropriate error message when used after {cmd:mfp: stcrreg} or
    {cmd:fracpoly: stcrreg}.

{p 5 9 2}
{* fix}
4.  {helpb gmm}, if the minimum lag
    requested in option {opt xtinstruments()} was at least two more than
    the greatest lag of the dependent variable in the regression equation and
    if a constant term or other exogenous regressors were included in the
    model, would exit with an error message or report incorrect results for
    dynamic panel-data models.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb graph} has the following fixes:

{p 9 13 2}
    a.  {cmd:graph} with option {cmd:by(}{it:byvar}{cmd:)}, when {it:byvar}
        was a string that contained an unquoted comma, would fail with an
        error.  This has been fixed.

{p 9 13 2}
    b.  {cmd:graph} trimmed trailing spaces from variable labels when those
        labels appeared in a graph.  These spaces are no longer trimmed.

{p 9 13 2}
    c.  {cmd:graph} could be extremely slow at handling variables whose value
	labels had extremely large gaps in the values being labeled, for
        example, 1 and 1,000,000.  This has been fixed.

{p 9 13 2}
    d.  {cmd:graph} did not correctly draw axis lines when option
        {cmd:yscale(noextend)} or option {cmd:xscale(noextend)} was
        specified.  Although the axis line itself was not drawn correctly or
        sometimes was not drawn at all, the tick marks and their labels were
        all correct and correctly positioned.  This has been fixed.

{p 9 13 2}
    e.  {helpb graph hbar}, {helpb graph hbox}, and {helpb graph dot} did not
        honor suboption {cmd:angle()} of option {cmd:ylabel()}.  This
        has been fixed.

{p 9 13 2}
    f.  {helpb graph matrix}, when graphs were drawn with a monochromatic
        scheme (such as {cmd:s1mono} or {cmd:s2mono}), outlined the markers
        with navy lines.  The markers are now outlined in the same gray with
        which the markers are filled.

{p 5 9 2}
{* fix}
6.  {helpb histogram} with a reference to an {cmd:r()} result in the {opt if}
    condition, such as

{p 13 13 2}
         {cmd:. summarize mpg, detail}{break}
         {cmd:. histogram mpg if mpg < r(p50)}

{p 9 9 2}
     would result in an incorrect graph.  The contents of {cmd:r()} were being
     changed before the {opt if} condition was used to determine the sample.
     This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ivregress} and {helpb gmm}, if the quadratic-spectral kernel was
    used and the time series contained gaps, would calculate
    heteroskedasticity and autocorrelation-consistent (HAC) weight and
    variance-covariance matrices incorrectly.  This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb makecns}, when called under version control between 8 and 10.1, would
    truncate the constraint list to 244 characters.  This only affected models
    that employed a large number of constraints.  This has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb margins} now reports a note when option {opt continuous} is turned
    on because a single-level factor is specified in option {opt dydx()} or
    {opt eydx()}.

{p 4 9 2}
10.  Mata has the following new features and fixes:

{p 9 13 2}
{* enhancement}
    a.  {helpb mf_moptimize:moptimize()} now has a long and a short name
        associated with the evaluator types it supports.  Some of the short
        names for the evaluator types have been renamed.  The old names will
        continue to work but are going undocumented.  Click
        {help moptimize_11:here} to see how {cmd:moptimize()} was previously
        documented.

{col 18}Short name{col 32}Long name{col 57}Old name
{col 18}{hline 48}
{col 18}{cmd:d0}{col 32}{cmd:derivative0}
{col 18}{cmd:d1}{col 32}{cmd:derivative1}
{col 18}{cmd:d2}{col 32}{cmd:derivative2}
{col 18}{cmd:d1debug}{col 32}{cmd:derivative1debug}
{col 18}{cmd:d2debug}{col 32}{cmd:derivative2debug}
{col 18}{cmd:gf0}{col 32}{cmd:generalform0}{col 57}{cmd:v0}
{col 18}{cmd:gf1}{col 32}{cmd:generalform1}{col 57}{cmd:v1}
{col 18}{cmd:gf2}{col 32}{cmd:generalform2}{col 57}{cmd:v2}
{col 18}{cmd:gf1debug}{col 32}{cmd:generalform1debug}{col 57}{cmd:v1debug}
{col 18}{cmd:gf2debug}{col 32}{cmd:generalform2debug}{col 57}{cmd:v2debug}
{col 18}{cmd:q0}{col 32}{cmd:quadraticform0}
{col 18}{cmd:q1}{col 32}{cmd:quadraticform1}
{col 18}{cmd:q1debug}{col 32}{cmd:quadraticform1debug}
{col 18}{hline 48}

{p 9 13 2}
{* enhancement}
    b.  {helpb mf_moptimize:moptimize()} has three new evaluator types to
        replace {cmd:e1} and {cmd:e2}.  The {cmd:e}-type evaluators will
        continue to work but are going undocumented.  Click
        {help moptimize_11:here} to see how {cmd:moptimize()} was previously
        documented.

{col 18}Short name{col 32}Long name
{col 18}{hline 30}
{col 18}{cmd:lf0}{col 32}{cmd:linearform0}
{col 18}{cmd:lf1}{col 32}{cmd:linearform1}
{col 18}{cmd:lf1debug}{col 32}{cmd:linearform1debug}
{col 18}{cmd:lf2}{col 32}{cmd:linearform2}
{col 18}{cmd:lf2debug}{col 32}{cmd:linearform2debug}
{col 18}{hline 30}

{p 9 13 2}
{* enhancement}
    c.  {helpb mf_optimize:optimize()} now has a long and a short name
        associated with the evaluator types it supports.  Some of the short
        names for the evaluator types have been renamed.  The old names
        continue to work but are going undocumented.  Click
        {help optimize_11:here} to see how {cmd:optimize()} was previously
        documented.

{col 18}Short name{col 32}Long name{col 57}Old name
{col 18}{hline 48}
{col 18}{cmd:d0}{col 32}{cmd:derivative0}
{col 18}{cmd:d1}{col 32}{cmd:derivative1}
{col 18}{cmd:d2}{col 32}{cmd:derivative2}
{col 18}{cmd:d1debug}{col 32}{cmd:derivative1debug}
{col 18}{cmd:d2debug}{col 32}{cmd:derivative2debug}
{col 18}{cmd:gf0}{col 32}{cmd:generalform0}{col 57}{cmd:v0}
{col 18}{cmd:gf1}{col 32}{cmd:generalform1}{col 57}{cmd:v1}
{col 18}{cmd:gf2}{col 32}{cmd:generalform2}{col 57}{cmd:v2}
{col 18}{cmd:gf1debug}{col 32}{cmd:generalform1debug}{col 57}{cmd:v1debug}
{col 18}{cmd:gf2debug}{col 32}{cmd:generalform2debug}{col 57}{cmd:v2debug}
{col 18}{cmd:q0}{col 32}{cmd:quadraticform0}
{col 18}{cmd:q1}{col 32}{cmd:quadraticform1}
{col 18}{cmd:q1debug}{col 32}{cmd:quadraticform1debug}
{col 18}{hline 48}

{p 9 13 2}
{* fix}
    d.  {helpb mf_optimize:optimize()} with the default
        {cmd:optimize_init_colstripe()} setting and
        {cmd:optimize_init_tracelevel()} set to "{cmd:params}",
        "{cmd:gradient}", or "{cmd:hessian}" reported a conformability error
        after the first iteration.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb mfp} and {helpb fracpoly} now respect the {hi:Break} key.

{p 4 9 2}
{* fix}
12.  {helpb mi impute monotone} has the following fixes:

{p 9 13 2}
{* fix}
    a.  {cmd:mi impute monotone} produced the syntax error "duplicates found"
        when the length of the list of names of the specified imputation
        variables exceeded 244 characters.  This has been fixed.

{p 9 13 2}
{* fix}
    b.  {cmd:mi impute monotone}, when the {cmd:logit} method was used, would
        display an extra empty line.  This has been fixed.

{p 4 9 2}
13.  {helpb ml} has the following new features and fixes:

{p 9 13 2}
{* enhancement}
    a.  {cmd:ml} now has a long and a short name associated with the evaluator
        types it supports.  Some of the short names for the evaluator types
        have been renamed.  The old {cmd:v0}, {cmd:v1}, and {cmd:v2} evaluator
        types will continue to work but are going undocumented.  Click
        {help ml_11:here} to see how {cmd:ml} was previously documented.

{col 18}Short name{col 32}Long name{col 57}Old name
{col 18}{hline 48}
{col 18}{cmd:d0}{col 32}{cmd:derivative0}
{col 18}{cmd:d1}{col 32}{cmd:derivative1}
{col 18}{cmd:d1debug}{col 32}{cmd:derivative1debug}
{col 18}{cmd:d2}{col 32}{cmd:derivative2}
{col 18}{cmd:d2debug}{col 32}{cmd:derivative2debug}
{col 18}{cmd:gf0}{col 32}{cmd:generalform0}{col 57}{cmd:v0}
{col 18}{hline 48}

{p 9 13 2}
{* fix}
    b.  {cmd:ml} with a model specification that contained multiple equations
        with the same name would report a cryptic error message after
        attempting to fit the model.  {cmd:ml} {cmd:model} now catches the
        error early and reports a better error message.

{p 9 13 2}
{* fix}
    c.  {cmd:ml}, when supplied with an {it:indepvarlist} containing more than
        one duplicate, such as

{p 17 17 2}
                {cmd:. sysuse auto}{break}
                {cmd:. logit foreign turn turn turn}

{p 13 13 2}
        would complain about duplicate entries.  This has been fixed.

{p 9 13 2}
{* fix}
    d.  {cmd:ml}, when called under version control between 8 and 10.1, would
        truncate the constraints in {opt constraint(numlist)} to 244
        characters.  This only affected models that employed a large number of
        constraints.  This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb nlcom}, for expressions involving the
     {cmd:_b[}{it:eq}{cmd::}{it:name}{cmd:]} notation, reported an "invalid
     name" error.  This has been fixed.

{p 4 9 2}
{* fix}
15.  The {cmd:odbc load} dialog did not bring up the file chooser dialog for
     Excel files and MS Access Database data source names.  This has been
     fixed.

{p 4 9 2}
{* enhancement}
16.  {help previously documented} has been updated.  It now contains links to
     help files for {cmd:ml} for Stata 10 and early Stata 11 (prior to the
     new evaluator names).  It also contains links to help files for
     {cmd:optimize()} and {cmd:moptimize()} for early Stata 11 (prior to the
     new evaluator names).

{p 4 9 2}
{* enhancement}
17.  {helpb putmata} and {helpb getmata} are new Stata commands that make it
     easy to move data from Stata to Mata and vice versa.

{p 4 9 2}
{* fix}
18.  {helpb _rmdcoll}, when option {opt expand} was specified, would
     incorrectly report that option {opt expand} was not allowed.  This has
     been fixed.

{p 4 9 2}
{* fix}
19.  {helpb sts test}, if the variable used had a value label that had been
     dropped but the value-label name was still attached to the variable,
     issued an error.  This has been fixed.

{p 4 9 2}
{* enhancement}
20.  {helpb xtmelogit} and {helpb xtmepoisson} now use a more sophisticated
     method of shuffling starting values when estimating the random effects as
     a component of the model log likelihood.  As a result, many models that
     previously failed with an "initial values not feasible" error may now be
     fit error free.  Also, random-effects predictions are now less prone
     to convergence failures.

{p 4 9 2}
{* enhancement}
21.  {helpb xtmixed}, when used to fit
     crossed-effects models, is now more computationally efficient.  When
     constructing crossed-effects design matrices, {cmd:xtmixed}'s
     likelihood evaluator now looks up variables by position, where previously
     it looked up variables by name.  The resulting speed gain is more
     significant the larger the clusters.

{p 4 9 2}
{* fix}
22.  {cmd:xtpois} and {cmd:xtclog} were replaced by {helpb xtpoisson} and
     {helpb xtcloglog}, respectively.  However, {cmd:xtpois} and {cmd:xtclog}
     continued to work and behaved as if {cmd:xtpoisson} or {cmd:xtcloglog}
     was called under version control for Stata 8.  {cmd:xtpois} and
     {cmd:xtclog} are now synonyms for the current version of
     {cmd:xtpoisson} and {cmd:xtcloglog}.

{p 4 9 2}
{* fix}
23.  {helpb zipfile}, if there was not a space between the comma in option
     {cmd:saving()} and suboption {cmd:replace}, issued an error.
     This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
24.  Base-level information on interactions sometimes got lost after some
     postestimation commands, such as {helpb nlcom} and {helpb testnl}.  This
     only affected the look of the coefficient table.  This has been fixed.

{p 4 9 2}
{* fix}
25.  Under very unusual conditions, valid ado-programming
     {help classassign:class assignments} could fail with the message
     "= assignment of a reference is not allowed".  This has been fixed.

{p 4 9 2}
{* fix}
26.  Stata {help functions} have the following fixes:

{p 9 13 2}
    a.  {helpb binormal:binormal()}, in rare instances, returned missing
        values with reasonable input arguments.  This has been fixed.

{p 9 13 2}
    b.  {helpb rbinomial()}, when 15 < {it:n}*(1-{it:p}) <= 125, {it:p} > 0.5,
        and when calling {cmd:rbinomial(}{it:n}{cmd:,} {it:p}{cmd:)} followed by
        {cmd:rbinomial(}{it:n}{cmd:,} {cmd:1-}{it:p}{cmd:)}, would generate
        incorrect variates.  The second call would generate variates from a
        binomial({it:n},{it:p}) distribution.  This has been fixed.

{p 9 13 2}
    c.  {helpb rnormal()}, if the standard deviation parameter was zero,
        returned missing values.  Now it returns zeros.

{p 4 9 2}
{* fix}
27.  {helpb graph export}, when exporting a graph to PostScript or EPS, would
     not display bold or italic text if the text was being rendered in a
     default PostScript font.  This has been fixed.

{p 4 9 2}
{* fix}
28.  {helpb lincom} and {helpb test}, when repeatedly used with the new
     factor-variable notation, would eventually cause Stata to slow down.
     This has been fixed.

{p 4 9 2}
{* fix}
29.  {helpb logit} and {helpb probit} failed to detect perfect predictors that
     were base-level virtual variables for factor variables or interactions.
     This has been fixed.

{p 4 9 2}
{* fix}
30.  Mata's {helpb mf_st_sdata:st_sdata()} and {helpb mf_st_sview:st_sview()}
     did not allow varlists in the string elements of the j argument, a
     feature that was added to {helpb mf_st_data:st_data()} and
     {helpb mf_st_view:st_view()} in Stata 11.  This has been fixed.

{p 4 9 2}
{* fix}
31.  {helpb matrix rownames} and {cmd:matrix colnames}, when presented with a
     string that looked like a variable with time-series operators, such as
     {cmd:sd(e)}, would sometimes report the "invalid name" error.  This has
     been fixed.

{p 4 9 2}
{* fix}
32.  {helpb ologit} (and most other {helpb ml}-based estimation commands),
     when used with an interaction involving a factor variable with a
     continuous variable squared, would report the error "multiple 'o'
     operators attached to a single variable are not allowed within an
     interaction" when the base level was omitted because of lower-ordered
     terms.  This has been fixed.

{p 4 9 2}
{* fix}
33.  {helpb regress} has the following fixes:

{p 9 13 2}
    a.  {cmd:regress} with noninteger-valued {helpb iweight}s was using the
        integer-truncated degrees of freedom in calculating the mean squared
        error and variance-covariance values.  This has been fixed.

{p 9 13 2}
    b.  {cmd:regress}, when used with a varlist entirely bound in parentheses
        (including the {it:depvar}), such as

{p 17 17 2}
            . {cmd:regress} {cmd:(mpg} {cmd:turn)}

{p 13 13 2}
        would report a "system limit exceeded" error.  This has been fixed.

{p 4 9 2}
{* fix}
34.  {helpb reg3}, {helpb regress}, {helpb xtivreg}, {helpb xtpcse}, and
     {helpb xtreg} marked omitted variables with the '{cmd:o.}' operator, even
     when called under version control less than 11 (and no factor-variables
     notation was used).  This has been fixed.

{p 4 9 2}
{* fix}
35.  {helpb sspace} has the following fixes:

{p 9 13 2}
    a.  The {cmd:sspace} coefficient standard errors for nonstationary models
        using option {bf:method(dejong)} were incorrect.  Although the De Jong
        likelihood is used for nonstationary models by default, this bug
        occurred only if option {bf:method(dejong)} was specified explicitly.
        This has been fixed.

{p 9 13 2}
    b.  {cmd:sspace} may have had difficulty converging for nonstationary
        models using option {bf:covstate(unstructured)} with option
        {bf:method(hybrid)}, the default, or option {bf:method(dejong)}.  This
        has been fixed.

{p 4 9 2}
{* fix}
36.  {helpb strtoname()} now respects extended ASCII characters.  Now all
     strings that are accepted as names by {helpb confirm names} and
     {helpb syntax} will remain unchanged when passed to {cmd:strtoname()}.

{p 4 9 2}
{* fix}
37.  {helpb summarize} has the following fixes:

{p 9 13 2}
    a.  {cmd:summarize} with the {helpb by} prefix and {helpb aweight}s or
        {helpb iweight}s would ignore the weight specification after the
        results from the first {cmd:by} group were displayed.  This has been
        fixed.

{p 9 13 2}
    b.  {cmd:summarize} with options {cmd:detail} and {cmd:format}, if the
        specified variable had a date format, formatted the Std. Dev.,
        Variance, Skewness, and Kurtosis as dates.  This has been fixed.

{p 4 9 2}
{* fix}
38.  {helpb svy}, when used with certainty PSUs, was not including the
     observations corresponding to the certainty PSUs in the {cmd:e(V_srs)}
     and {cmd:e(V_srswr)} calculations, affecting the output from
     {helpb estat effects}.  This has been fixed.

{p 4 9 2}
{* enhancement}
39.  {helpb tabsum:tabulate, summarize()} now uses a two-pass formula (instead
     of a one-pass formula) to compute standard deviations with quad
     precision.  This produces more-accurate standard deviations.

{p 4 9 2}
{* fix}
40.  {helpb testparm} with interactions of continuous variables with factor
     variables with {helpb fvset} base levels failed to capture all the
     requested regression coefficients in the Wald test.  This has been fixed.

{p 4 9 2}
{* fix}
41.  Stata's varlist parsing logic would sometimes incorrectly identify a
     single-letter variable name as a time-series or factor-variable operator.
     For example, {cmd:i.(i(1/5).b)} caused a syntax error.  This has been
     fixed.

{p 4 9 2}
{* fix}
42.  The Data Editor has the following fixes:

{p 9 13 2}
    a.  Pasting into the Data Editor from an Excel spreadsheet that contained
        empty columns caused Stata to always treat the first row as data, even
        if the first row otherwise contained valid variable names.  This has
        been fixed.

{p 9 13 2}
    b.  In the Data Editor, double-clicking on a column heading for an
        existing variable should open the Variable Properties dialog; however,
        if the variables were filtered, the dialog box for generating a new
        variable might have opened instead.  This has been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
43.  {helpb sleep} could exhibit excessive CPU load during sleep intervals of
     less than 501 milliseconds.  This has been fixed.

{p 4 9 2}
{* fix}
44.  Stata did not respect the preference for persistent viewers.  This has
     been fixed.

{p 4 9 2}
{* fix}
45.  Under very specific circumstances, Stata could repeatedly prompt the user
     to elevate privileges when trying to apply updates on Windows Vista or
     Windows 7.  This problem could only occur if User Access Control (UAC)
     has been disabled and if the user attempting to apply the update is not
     part of the Administrators group.

{p 4 9 2}
{* fix}
46.  The Do-file Editor has the following fixes:

{p 9 13 2}
    a.  Selecting {bf:Edit > Find > Balance Braces} excluded the open and
        close braces from the selection, which caused the subsequent
        {bf:Do the selection} operation to produce a "matching close brace not
        found" error.  This has been fixed.

{p 9 13 2}
    b.  In the Do-file Editor Preferences dialog,
        {bf:Restore Factory Defaults} sometimes failed to correctly restore
        default settings for code folding.  This has been fixed.

{p 4 9 2}
{* fix}
47.  Some circle and square marker symbols could appear as ovals or rectangles
     in {help graph:graphs}.  This has been fixed.

{p 4 9 2}
{* fix}
48.  The Graph window has the following fixes:

{p 9 13 2}
    a.  Resizing or maximizing the Graph window could cause Stata to appear
        slow or unresponsive when many graphs were tabbed into the same Graph
        window.  This has been fixed.

{p 9 13 2}
    b.  The keyboard shortcut for Copy (Ctrl+C) did not work.  This has been
        fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
49.  You can now select multiple files in the Open dialog.  Stata will open
     the files in the order that it receives them from the Mac, not
     necessarily in the order that you have selected the files.  When
     selecting multiple do-files, Stata will open all the do-files in the
     Do-file Editor.  When selecting multiple datasets, Stata will {helpb use}
     each one in the order it receives them from the Mac; however, because
     Stata can only have one dataset in memory at a time, it does not make
     sense to select multiple datasets in the Open dialog.

{p 4 9 2}
{* enhancement}
50.  You can now navigate combobox and varlist controls in Stata's
     programmable dialogs with the keyboard.  When the keyboard focus is set
     to a combobox or varlist control, you can press the down arrow key to
     display the drop-down list, use the up and down arrow keys to navigate
     the drop-down list, press the {hi:Return} key to select an item from the
     drop-down list, or press the {hi:Escape} key to dismiss the drop-down
     list.

{p 4 9 2}
51.  Rendering graphs has been improved:

{p 9 13 2}
{* enhancement}
    a.  Text rendering for graphs drawn to a window has been improved so that
        text with multiple fonts, superscripts and subscripts, and Greek
        letters will render with a consistent baseline.

{p 9 13 2}
{* enhancement}
    b.  When exporting a graph as a PDF, rendering connected lines has been
        greatly improved.  Rendering graphs to the screen has also been
        improved.

{p 9 13 2}
{* fix}
    c.  Some circle and square marker symbols could appear as ovals or
        rectangles in {help graph:graphs}.  This has been corrected.

{p 9 13 2}
{* fix}
    d.  Because of changes in Mac OS X 10.6, options {cmd:width()} and
        {cmd:height()} had no effect on graphs exported to a bitmap format
        using {helpb graph export}.  This has been fixed while still
        maintaining compatibility with Mac OS X 10.5.

{p 4 9 2}
52.  The Do-file Editor has the following new features and fixes:

{p 9 13 2}
{* enhancement}
    a.  Do-files opened from the Finder can now be opened in the Do-file
        Editor instead of executing them.  To enable this setting, check the
        "Edit do-files opened from the Finder instead of executing them"
        checkbox on the Do-file Editor tab in the Preferences dialog.  Any
        do-file named {bf:Stata.do} will still execute in Stata and
        automatically set the current working directory to the directory that
        the {bf:Stata.do} file is contained in regardless of whether this
        setting is enabled.

{p 9 13 2}
{* fix}
    b.  The contextual menu for the Do-file Editor displayed an incorrect
        keyboard shortcut for executing a do-file.  This has been fixed.

{p 4 9 2}
{* fix}
53.  Pressing any function key in the Data Editor would clear the contents of
     the current cell and enable editing.  The correct behavior is for the F2
     key to enable editing in the current cell and to move the text cursor to
     the end of the current cell's contents; all other function key presses
     are to be ignored.  This has been fixed.

{p 4 9 2}
{* fix}
54.  The Variables window columns would sometimes resize so that all columns
     would appear, even if the user intentionally resized the columns to hide
     some columns such as the Type and Format columns.  This has been fixed.

{p 4 9 2}
{* fix}
55.  In the Variables Manager, if the Reset or Apply button had been clicked
     on first, the variable properties would not immediately update after
     clicking on an arrow to navigate between variables.  This has been fixed.

{p 4 9 2}
{* fix}
56.  A command that took some time to execute would not appear
     in the Results window until it had completed.  Stata for Mac
     now immediately displays the command in the Results window.

{p 4 9 2}
{* fix}
57.  Listbox controls in Stata's programmable dialogs always defaulted to the
     first item in the listbox instead of the last selected item when a dialog
     was reopened.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
58.  The Command window now allows the use of the arrow keys in combination
     with the Control key to navigate the cursor by word or to move the cursor
     to the beginning or the end of a line.

{p 4 9 2}
{* fix}
59.  The Data Editor has the following fixes:

{p 9 13 2}
    a.  Pressing any function key in the Data Editor would clear the contents
        of the current cell and enable editing.  The correct behavior is for
        the F2 key to enable editing in the current cell and to move the text
        cursor to the end of the current cell's contents; all other function
        key presses are to be ignored.  This has been fixed.

{p 9 13 2}
    b.  The Data Editor would only use its own private Clipboard data, even
        when text was copied in another application.  This has been fixed.

{p 9 13 2}
    c.  The Data Editor could crash when right-clicking within the Data Editor
        window.  This has been fixed.


{hline 8} {hi:update 08dec2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 9(4).

{p 5 9 2}
{* fix}
2.  {helpb svy_estat:estat effects} and {helpb svy_estat:estat lceffects}
    incorrectly reported zeros for {opt meff} and {opt meft} statistics when
    one or more of the model coefficients contained the new factor-variable
    operators.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb ivregress_postestimation##estatoverid:estat overid}, when used
    after {helpb ivregress 2sls}, incorrectly reported a
    heteroskedasticity-robust score statistic if cluster-robust standard
    errors were reported at estimation time.  Now a message indicating that
    the robust test is not available is displayed in that case.

{p 9 9 2}
    Also, {cmd:estat overid}, when used after {cmd:ivregress liml}, reported
    an incorrect Basmann statistic and denominator degrees of freedom.  This
    has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb gmm} reported incorrect point estimates and standard errors when an
    HAC weight matrix was used and the time series contained one or more gaps
    in the first {it:j} observations, where {it:j} is the number of lags used
    to compute the HAC matrix.  If a non-HAC weight matrix was used in
    conjunction with an HAC covariance matrix, the standard errors would be
    incorrect in this situation.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb heckman} for some datasets would take a much longer time computing
    starting values compared with when it was called under version control
    less than 11.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb ivregress} reported incorrect standard errors when an HAC
    covariance matrix was used and the time series contained one or more gaps
    in the first {it:j} observations, where {it:j} is the number of lags used
    to compute the HAC matrix.  In addition, if the GMM estimator was used
    with an HAC weight matrix, the point estimates would also be incorrect in
    this situation.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb lrtest}, when used to compare models fit with {helpb xtmixed},
    {helpb xtmelogit}, or {helpb xtmepoisson}, calculated an incorrect test
    degrees of freedom if the fixed-effects specifications of these models
    contained factor variables and if the number of omitted coefficients
    differed between models.  This has been fixed.

{p 5 9 2}
{* enhancement}
8.  {helpb margins} with options {opt dydx()} and {opt asbalanced} and using
    the chain rule to compute derivatives with respect to the model
    coefficients produced slightly incorrect standard errors.  Some numerical
    derivatives were yielding a zero when they should have resulted in nonzero
    values.  This has been fixed.

{p 5 9 2}
{* enhancement}
9.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total} now run
    faster when run {helpb quietly} because they now skip the code used to
    formulate the table of estimation results.  Previously, only the actual
    display of the estimation table was suppressed.  You will notice the speed
    increase the most when using prefix commands such as {helpb bootstrap} and
    {helpb svy jackknife}, because they execute estimation commands repeatedly
    and {cmd:quietly}.

{p 4 9 2}
{* fix}
10.  {helpb merge} used with unsorted data would sometimes fail to sort the
     data and thus issue the error message that the master or using data were
     unsorted.  This has been fixed.

{p 4 9 2}
{* enhancement}
11.  {helpb mfp} and {helpb fracpoly} now support {helpb stcrreg}.

{p 4 9 2}
{* fix}
12.  {helpb mfp} and {helpb fracpoly} used incorrect degrees of freedom for
     the fractional polynomial models when used with {helpb mlogit} (as of
     Stata 11) or with {helpb glm}, which led to incorrect p-values reported
     for the deviance tests.  As a result, in the presence of binary
     predictors, {cmd:mfp: glm} reported a missing p-value for the deviance
     test for binary predictors and could mistakenly exclude the binary
     predictors from the final model.  The above issues have been fixed.

{p 4 9 2}
{* fix}
13.  {helpb ml display}, when the {opt neq()} option was specified, was
     incorrectly applying {opt eform} to all equations.  It should have
     applied it only to the first {cmd:e(k_eform)} equations ({cmd:e(k_eform)}
     is 1 by default).  This has been fixed.

{p 4 9 2}
{* fix}
14.  {helpb nlsur} exited with an error if a cluster-robust VCE was requested
     and the cluster variable was a string variable.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {helpb probit} and {helpb logit} did not respect the minimum
     abbreviation, {cmd:nocon}, for the {cmd:noconstant} option.  This has
     been fixed.

{p 4 9 2}
{* fix}
16.  {helpb _rmcoll2list} was incorrectly truncating the varlist result
     {cmd:r(blist)}.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb _rmdcoll} did not accept the {opt expand} option as documented.
     This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb roctab:roctab, binomial} reported incorrect binomial confidence
     intervals when the estimate of the area under the receiver characteristic
     curve was 1.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb tabodds:tabodds, or} now reports missing values for the confidence
     interval for the base category when one of {cmd:woolf}, {cmd:tb}, or
     {cmd:cornfield} is specified.

{p 4 9 2}
{* fix}
20.  {helpb xtivreg} produced erroneous results if the same variable was
     specified both as the dependent variable and in the list of additional
     instruments.  Now an error message is produced.

{p 4 9 2}
{* enhancement}
21.  {helpb xtmixed} now allows the time-indexing variable to contain values
     equal to zero when modeling the residual-error structure as an
     unstructured matrix.  Previously, the time-indexing variable was
     restricted to be a positive integer.

{p 4 9 2}
{* fix}
22.  {helpb xtreg:xtreg, fe} exited with an error if a cluster-robust VCE was
     requested and the cluster variable was a string variable.  This has been
     fixed.


{hline 8} {hi:update 21oct2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {helpb icd9} had its databases updated to use codes through the V27 update
    released on 1 Oct 2009.

{p 5 9 2}
{* fix}
2.  {helpb ivregress}, in certain cases involving time-series operators with
    variables bound in parentheses, reported a "parentheses unbalanced" error.
    This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb margins} with option {opt eydx()} or {opt eyex()} (regardless of
    whether option {opt atmeans} or {opt at()} is also specified) would report
    the error "default prediction is a function of possibly stochastic
    quantities other than e(b)" for some models producing negative predicted
    values using the current data.  This has been fixed.

{p 5 9 2}
{* fix}
4.  The {bf:At} tab on the {helpb margins} dialog box now lists the overall
    statistics in the statistics combo box.

{p 5 9 2}
{* fix}
5.  Mata function {helpb mf_optimize:optimize()} failed to replace the old
    parameter values with new ones specified in {cmd:optimize_init_params()}.
    This has been fixed.

{p 5 9 2}
{* fix}
6.  Mata function {helpb mf_optimize:optimize_evaluate()} reported the
    "attempt to dereference NULL pointer" run-time error when used without
    first calling {cmd:optimize()}.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb regress} did not allow all display options to be abbreviated when
    replaying results.  This has been fixed.

{p 5 9 2}
{* fix}
8.  The dialog box for {helpb stcurve} failed to output options specified on
    the {bf:Legend} tab.  This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb xtline} dropped observations that contained missing values in the
    variables being plotted.  This was not intended and has been fixed.

{p 4 9 2}
{* enhancement}
10.  {helpb xtmixed_postestimation##predict:predict} after {helpb xtmixed} now
     allows out-of-sample predictions that are based on estimated random
     effects, provided that the out-of-sample observations correspond to
     groups that are represented in the estimation sample.  The one exception
     is standardized residuals (option {cmd:rstandard}), which are
     statistically appropriate only within the estimation sample.

{p 4 9 2}
{* fix}
11.  {helpb xtpcse} with {cmd:aweight}s and factor variables included in the
     model reported an error message.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
12.  {helpb graph export} could crash when exporting PostScript graphs using
     a nondefault font that could not be found on the computer.  This has been
     fixed.

{p 4 9 2}
{* fix}
13.  {helpb label language} ...{cmd:, delete}, when the language name being
     deleted was the current dataset language name, would leave some labels in
     the dataset from the deleted language name.  This has been fixed.

{p 4 9 2}
{* fix}
14.  Mata class matrices were not allowed in optional argument lists of Mata
     functions.  This has been fixed.

{p 4 9 2}
{* fix}
15.  Mata function {helpb mf_eltype:eltype()} now returns "class" for Mata
     class matrices and "classdef" for Mata class functions.

{p 4 9 2}
{* fix}
16.  {helpb _ms_extract_varlist} with option {opt noomit} ignored generic
     factor terms whose base level was {helpb fvset}.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb regress} ran slower than usual for small datasets with a small
     number of independent variables.  This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb _return} failed to clear matrix row and column names from dropped
     {cmd:r()} results.  This would cause {cmd:set memory} to complain that
     "Stata matrices have not been cleared" and prevent
     {helpb clear:clear matrix} from fully removing all of Stata's matrices.
     This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb testparm} dropped factor terms whose base level was {helpb fvset}.
     This has been fixed.

{p 4 9 2}
20.  The Data Editor has the following new features and fixes:

{p 9 13 2}
{* enhancement}
    A.  Double-clicking on the column heading for an existing variable now
        opens the dialog for variable properties.

{p 9 13 2}
{* enhancement}
    B.  Live filtering can now be disabled.

{p 9 13 2}
{* fix}
    C.  It was not possible to paste variable names longer than 80 characters.
        Now Stata will accept text longer than 80 characters, attempt to form
        a valid Stata variable name, and apply the first 80 characters to the
        variable's label.

{p 4 9 2}
{* fix}
21.  Stata's old programmable dialog system was mistakenly disabled on Windows
     and Unix(GUI) platforms in the 26aug2009 update.  This functionality has
     been restored.


    {title:Stata executable, Windows}

{p 4 9 2}
22.  The Do-file Editor has the following new features and fixes:

{p 9 13 2}
{* enhancement}
    A.  New option "Replace all in selection" restricts the replacement of all
        occurrences to the currently selected text.

{p 9 13 2}
{* fix}
    B.  When a "Replace all" was requested of a string, s, with a string s1
        that contained s, an infinite loop happened.  This has been fixed.

{p 9 13 2}
{* fix}
    C.  "Balance Braces" under the "Find" submenu in the "Edit" menu did
        not work if the close brace was the last character of the file.  This
        has been fixed.

{p 9 13 2}
{* fix}
    D.  "Match Brace" under the "Find" submenu in the "Edit" menu selected
        the section of code between the focused brace and its matching brace.
        It now selects only the matching brace.

{p 9 13 2}
{* fix}
    E.  Syntax highlighting settings could not be restored to factory
        defaults.  This has been fixed.

{p 9 13 2}
{* fix}
    F.  When a line was selected by clicking on the line number, the selected
        line and the following line were both executed.  This has been fixed.

{p 9 13 2}
{* fix}
    G.  Under certain conditions and when auto-indentation was enabled, the
        Do-file Editor computed the wrong indentation length for the current
        line based on the indentation length of the previous line.  This has
        been fixed.

{p 4 9 2}
{* fix}
23.  Applying the "Factory Settings" with some very specific windowing
     arrangements could crash Stata.  This has been fixed.

{p 4 9 2}
{* fix}
24.  If the Review window was not initially shown because of a tabbed
     configuration, commands were not added to the Review window.  This has
     been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
25.  In Mac OS X, PDF is the preferred format for images copied to
     the Clipboard.  However, many legacy applications, such as Microsoft
     Office 2004, do not support PDF images from the Clipboard.  Stata copies
     an image in both PDF and bitmap to the Clipboard for
     compatibility with both modern and legacy applications.  Some modern
     applications, such as PowerPoint 2008, will still mistakenly paste in a
     bitmap image even if the preferred PDF image is available from the
     Clipboard.  To avoid this behavior, you can now disable the inclusion of
     a bitmap image when copying an image to the Clipboard by opening the
     Preferences dialog and unchecking the "Include a bitmap image in addition
     to a PDF image" checkbox or by setting {helpb include_bitmap} to
     {cmd:off}.

{p 4 9 2}
{* fix}
26.  {helpb graph export} could crash when exporting PostScript graphs in the
     rare case of a nondefault, TrueType font that could not be converted to
     PostScript.  This has been fixed.

{p 4 9 2}
{* fix}
27.  The 26aug2009 update introduced a bug in the Graph Editor where changing
     a selection in a pulldown menu of the graph toolbar would have no effect
     on the graph being edited.  This has been fixed.

{p 4 9 2}
{* fix}
28.  Opening the Data Editor with an {cmd:if} condition could crash Stata.
     This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
29.  Right-clicking within the Data Editor window could cause it to crash.
     This has been fixed.

{p 4 9 2}
{* fix}
30.  Stata does not support Unicode and must convert Unicode characters
     inputted into Stata to ASCII.  Stata now displays a warning when it
     cannot convert Unicode to ASCII and accepts the text it could convert.

{p 4 9 2}
{* enhancement}
31.  Copy Table has been added to the contextual menu for the Results window.


{hline 8} {hi:update 30sep2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 9(3).

{p 5 9 2}
{* fix}
2.  {helpb areg} with interactions in the {it:indepvars} would report an
    invalid operator error if one of the virtual interaction variables was
    omitted because of collinearity.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb clogit} for some models would take a much longer time computing
    starting values compared with when it was called under version control
    less than 11.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb dotplot} with option {cmd:bar} produced an error message and
    did not draw the graph.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb estimates use} would report a Mata run-time error when attempting
    to restore estimation results containing a matrix with zero rows or
    columns.  This has been fixed.

{p 5 9 2}
{* enhancement}
6.  {helpb margins} is now faster when marginal effects of factor variables
    are computed.

{p 5 9 2}
{* fix}
7.  {helpb margins} with options {opt eydx()} and {opt eyex()} would report
    that "prediction <=0, eydx() not available" when it should not have.  This
    has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb margins} with {helpb nl} results and a marginal effects or
    elasticity option (for example, {opt dydx()}, {opt eyex()}, {opt eydx()}, or
    {opt dyex()}) would report an error about not finding a variable in the
    list of covariates, even when option {opt variables()} was specified.
    This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb mi_impute_logit:mi impute logit} used a single uniform random
    number to obtain all imputed values within an imputation rather than using
    observation-specific uniform random numbers.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb ml} and Mata's {helpb mata moptimize():moptimize()} with multiple
     techniques would report the Mata run-time error "subscript invalid" when
     searching for improved initial values.  This has been fixed.

{p 4 9 2}
{* fix}
11.  {helpb ml init} and {helpb ml} with option {opt init()} allowed only
     factor-variable notation in column names of matrices.  Now the
     {it:name}{cmd:=}{it:#} syntax supports factor-variable specifications.

{p 4 9 2}
{* fix}
12.  {helpb ml plot} did not allow factor-variable notation.  This has been
     fixed.

{p 4 9 2}
{* enhancement}
13.  {helpb _ms_unab} is a new {help undocumented} programmers' tool that
     unabbreviates matrix stripe elements by using the variable names in the
     current dataset.

{p 4 9 2}
{* fix}
14.  Mata function {helpb mf_optimize:optimize()} used with evaluator {cmd:d0}
     or {cmd:v0} when the numerical derivatives could not be computed would
     sometimes crash Stata.  This has been fixed.

{p 4 9 2}
{* enhancement}
15.  {helpb postrtoe} is a new {help undocumented} command for moving results
     stored in {cmd:r()} into {cmd:e()}.

{p 4 9 2}
{* fix}
16.  {helpb stci}, when used with prefix {cmd:by}, option {opt by()},
     {cmd:if}, or {cmd:in}, produced correct confidence intervals but reported
     standard errors that were based on a survivor-function estimate that did
     not restrict the sample.  This has been fixed.

{p 4 9 2}
{* fix}
17.  {helpb sts graph:sts graph, hazard} ignored value labels of the variable
     specified within option {cmd:by()} when displaying the graph legend.  It
     also did not respect the variable label of the by-variable in the note
     displayed when option {cmd:separate} was used.  These issues have been
     fixed.

{p 4 9 2}
{* fix}
18.  {helpb sunflower} with option {opt addplot()} would only render the plots
     in option {opt addplot()}.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {helpb svy} regression models would incorrectly report missing standard
     errors for multistage designs that had a strata variable {helpb svyset}
     in stage k+1 but not in stage k.  {cmd:svy} was incorrectly determining
     that every stratum in stage k contained only one sampling unit.  This has
     been fixed.

{p 4 9 2}
{* fix}
20.  {helpb "svy: tabulate"} allowed option {opt over()} when it should not
     have.  This has been fixed.

{p 4 9 2}
{* fix}
21.  {helpb xtgee} for some models would take a much longer time computing
     starting values compared with when it was called under version control
     less than 11.  This has been fixed.


{hline 8} {hi:update 14sep2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Almost all Stata estimation commands now run faster when run
    {helpb quietly} because they now skip the code used to formulate the table
    of estimation results.  Previously, only the actual displaying of the
    estimation table was suppressed.  You will notice the speed increase the
    most when using prefix commands such as {helpb bootstrap} and
    {helpb fracpoly}, because they execute estimation commands repeatedly and
    quietly.

{p 5 9 2}
{* fix}
2.  {helpb gmm} exited with an error message if you used the moment-evaluator
    program version, specified derivatives, and used the {opt xtinstruments()}
    option.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb mi impute mvn} and {helpb mi impute monotone} dialogs did not allow
    multiple imputed variables.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {helpb reshape} issued an {err:r(181)} error if your j variable had a
    value label and you reshaped from long to wide and back to long, but you
    added the {cmd:string} option when reshaping back to long.  This has been
    fixed.

{p 5 9 2}
{* fix}
5.  {helpb stcox}, when used with options {cmd:tvc()} and {cmd:texp()}, now
    issues an error message when the expression specified in {cmd:texp()} is
    not a proper function of analysis time, {cmd:_t}.

{p 5 9 2}
{* fix}
6.  {helpb xthtaylor} with option {cmd:vce(bootstrap)} returned an error
    message when the model contained collinear terms.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb xtlogit} with option {cmd:fe} returned a conformability error when
    a model containing collinear variables was run under version 10.1 or
    earlier.  This has been fixed.

{p 5 9 2}
{* enhancement}
8.  {helpb xtmixed}, when used to model standard linear regression (no random
    effects) with heteroskedastic residuals, has been modified to avoid
    calculations involving very large matrices.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
9.  Some graphs would render to the screen with a stroke
    or fill color of black for some graph objects.  This has been fixed.

{p 4 9 2}
{* fix}
10.  Clicking a link in the Viewer that is supposed to go to a named
     destination within a help file would sometimes not go to the correct
     destination within the help file.  This has been fixed.


{hline 8} {hi:update 26aug2009} {hline}

{p 5 9 2}
{* fix}
1.  The 18aug2009 Stata 10.1 update items {help whatsnew10##n4_18aug2009:4},
    {help whatsnew10##n15_18aug2009:15}, {help whatsnew10##n19_18aug2009:19},
    {help whatsnew10##n25_18aug2009:25}, {help whatsnew10##n26_18aug2009:26},
    {help whatsnew10##n30_18aug2009:30}, {help whatsnew10##n43_18aug2009:43},
    {help whatsnew10##n59_18aug2009:59}, {help whatsnew10##n65_18aug2009:65},
    {help whatsnew10##n66_18aug2009:66}, and
    {help whatsnew10##n69_18aug2009:69} have now been applied to Stata 11.
    The other items from that update were applied to Stata 11 prior to its
    initial release.


    {title:Ado-files}

{p 5 9 2}
{* fix}
2.  {helpb ereturn display} exits with an error if scalar {cmd:e(k_eq)}
    contains a value that is not equal to the number of equations in
    {cmd:e(b)}.  Prior to Stata 11, {cmd:ereturn} {cmd:display} was oblivious
    to the scalars in {cmd:e()}.  The old behavior is now preserved under
    version control.

{p 5 9 2}
{* fix}
3.  {helpb margins}, when used with {helpb svy} results that employed option
    {cmd:subpop()} and when some of the independent variables contained
    missing values in observations outside the subpopulation sample,
    incorrectly refused to estimate margins under two additional conditions.

{p 9 13 2}
    a.  When option {cmd:subpop()} was also specified on command
        {cmd:margins} and when option {cmd:vce(unconditional)} was
        specified on command {cmd:margins}, {cmd:margins} incorrectly
        reported an error that observations were dropped from the estimation
        sample.  This has been fixed.

{p 9 13 2}
    b.  When option {cmd:subpop()} was not specified on command {cmd:margins},
        {cmd:margins} would incorrectly report all margins as "(not
        estimable)", even for margins that were estimable.  This has been
        fixed.

{p 5 9 2}
{* fix}
4.  Mata function {helpb moptimize:moptimize_init_eq_colnames()} would only
    work with equations with a single predictor.  This has been fixed.

{p 5 9 2}
{* fix}
5.  Mata function {helpb optimize:optimize()} with constraints and
    {cmd:optimize_init_tracelevel()} set to "{cmd:params}", "{cmd:step}",
    "{cmd:gradient}", or "{cmd:hessian}" would report a conformability error
    in Mata.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb mi import ice} with option {cmd:automatic} and when the dataset
    being imported contained string variables exited with a "type mismatch"
    error.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb ml model} dropped constant-only equations that were not supplied
    with an equation name.  Thus the specification

{p 13 13 2}
        {cmd:. ml model lf {it:myeval} (y = x) ()}

{p 9 9 2}
    was treated as

{p 13 13 2}
        {cmd:. ml model lf {it:myeval} (y = x)}.

{p 9 9 2}
    This has been fixed.

{p 5 9 2}
{* fix}
8.  {helpb sspace_postestimation##predict:predict} with both option
    {cmd:smooth} and option {cmd:rmse()} after {helpb sspace} with
    {cmd:method(hybrid)} or {cmd:method(dejong)} and with a nonstationary
    state-space model produced root mean squared error values that were too
    small.  This effect was less pronounced for later values in the series.
    This has been fixed.

{p 5 9 2}
{* fix}
9.  {helpb regress} with prefix {helpb by} reported an error message in
    addition to the usual warning when the last displayed group contained no
    observations.  This has been fixed.

{p 4 9 2}
{* fix}
10.  {helpb xtmixed}, when used to estimate the residual variance structure in
     a model with no random effects, would issue a Mata run-time error if
     either factor variables were specified or variables were omitted because
     of collinearity in the fixed-effects portion of the model.  This has been
     fixed.

{p 4 9 2}
{* fix}
11.  {helpb xtunitroot} would exit with various obscure error messages or
     report "no observations" if the variable being tested contained missing
     values for the first time period for all panels, even if the test could
     be conducted using subsequent time periods' data.  This has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
12.  {helpb anova} with option {cmd:repeated()}, when option
     {cmd:dropemptycells} was not specified and when there were empty
     cells in the between-subjects error term, reported values too large for
     the between-subjects error term, {cmd:e(N_bse)}, and the Huynh-Feldt
     corrections, {cmd:e(hf}{it:#}{cmd:)}, and the p-values based on these
     correction factors were consequently incorrect.  This has been fixed.
     The Greenhouse-Geisser and Box corrections and the p-values based upon
     them were correct.

{p 4 9 2}
{* fix}
13.  {helpb anova} with ill-conditioned data suffered loss of precision.  This
     has been fixed.

{p 4 9 2}
{* fix}
14.  Calling {helpb browse} or {helpb edit} commands from a do-file where the
     command specified a {help varlist} or restricted the observations using
     {helpb if} or {helpb in} showed the entire dataset inside the Data
     Editor.  This has been fixed.

{p 4 9 2}
{* fix}
15.  {cmd:clist} failed to recognize the data in memory.  This has been fixed.

{p 4 9 2}
{* fix}
16.  Function {helpb colnumb()} failed to match an equation specification on
     columns containing time-series operators or factor variables.  This has
     been fixed.

{p 4 9 2}
{* fix}
17.  {helpb margins} with a nonlinear prediction after {helpb ologit},
     {helpb oprobit}, or any other model without an intercept in one of its
     equations would attempt to use the chain rule for covariate patterns that
     it should not have, resulting in a subscript invalid error from Mata.
     This has been fixed.

{p 4 9 2}
{* fix}
18.  {helpb matrix colnames} failed to unset equation names when used with an
     unadorned colon character, as in {cmd:matrix coleq b = :}.  This has been
     fixed.

{p 4 9 2}
{* fix}
19.  The {cmd:quoted} option of {helpb odbc insert} did not work.  This has
     been fixed.

{p 4 9 2}
{* fix}
20.  {helpb suest} with the same factor variable but different levels across
     multiple estimation results would report the factor-variable name in an
     incorrect position in the regression table.  This has been fixed.

{p 4 9 2}
{* fix}
21.  In the Data Editor, pasting external Clipboard data did not support
     variable names that were longer than 32 characters.  In this situation,
     Stata will now attempt to form a valid variable name and store the
     original long name as the variable's label.

{p 4 9 2}
{* fix}
22.  In the Data Editor, editing the contents of a string variable, which
     resulted in the variable's string width increasing, caused the
     Data Editor to display the new width improperly.  This has been fixed.

{p 4 9 2}
{* enhancement}
23.  The Window menu now has an entry for the Variables Manager.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
24.  Windows Metafiles (WMF) created by {helpb graph export} or copied to the
     Clipboard had incorrectly positioned text.  This has been fixed.

{p 4 9 2}
{* fix}
25.  {helpb graph export} to PNG and TIFF formats using option {cmd:width()}
     crashed Stata.  This has been fixed.

{p 4 9 2}
{* fix}
26.  {helpb window menu refresh} and {helpb window menu clear} sometimes
     caused the restore icon for the Results window to disappear.  This has
     been fixed.

{p 4 9 2}
{* fix}
27.  In the Data Editor, deleting a variable that was used to filter
     observations sometimes caused Stata to crash.  This has been fixed.

{p 4 9 2}
{* fix}
28.  In the Variables Manager, unpinning the Variable Properties window caused
     the buttons for managing value labels and notes to not work.  This has
     been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
29.  If the Data Editor was already open when data was loaded, Stata sometimes
     crashed.  This has been fixed.

{p 4 9 2}
{* fix}
30.  Stata will no longer resave an unmodified do-file when the do-file is
     executed from the Do-file Editor.

{p 4 9 2}
{* fix}
31.  64-bit Mac:  The Do-file Editor now automatically adds an end-of-line
     delimiter at the end of a do-file if one does not already exist.  Stata
     requires that an end-of-line delimiter exist on all lines in a do-file
     that are to be executed.

{p 4 9 2}
{* fix}
32.  After changing the aspect ratio of a graph from the Graph Editor, the
     graph window would not automatically resize to the new aspect ratio.
     This has been fixed.

{p 4 9 2}
{* fix}
33.  The Make Text Bigger/Smaller menu items were disabled if the content area
     of a Viewer was clicked.  This has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
34.  You can now double-click on a snapshot in the Data Editor snapshot dialog
     to restore the snapshot.

{p 4 9 2}
{* fix}
35.  The Variables Manager reset button issued a warning before resetting the
     variables properties.  This has been fixed.


{hline 8} {hi:update 14aug2009} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 9(2).

{p 5 9 2}
{* fix}
2.  {helpb stcox_diagnostics:estat phtest} after {helpb stcox}
    reported an error message when factor variables were included in the
    model.  This has been fixed.

{p 5 9 2}
{* fix}
3.  {helpb estat summarize} after {helpb nlsur} exited with an error if option
    {opt variables()} was not specified with {cmd:nlsur}.  This has
    been fixed.

{p 5 9 2}
{* fix}
4.  {helpb estimates table} reported the error "nothing found where name
    expected" when splitting a wide table.  This has been fixed.

{p 5 9 2}
{* fix}
5.  {helpb ml display} failed to recognize Stata 10 estimation results that
    were restored using {helpb estimates use}.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {helpb _robust} ignored the weight specification.
    This affected only user-written commands that used {cmd:_robust} directly.
    It did not affect any official Stata estimators, nor did it affect any
    user-written estimators that used {helpb ml} or Mata functions
    {helpb mata optimize():optimize()} or {helpb mata moptimize():moptimize()}.
    This has been fixed.

{p 5 9 2}
{* fix}
7.  {helpb xtmixed}, when used to fit models with no random effects and with
    heteroskedastic residual variances, would perform an LR test (comparing
    the mixed model with standard linear regression) that failed to acknowledge
    that the mixed model had no random effects.

{p 9 9 2}
    If the heteroskedasticity occurred over exactly two groups, {cmd:xtmixed}
    reported a {help j_chibar:chibar(01)} test statistic when instead it should
    have reported a standard chi-squared with one degree of freedom.
    If there were more than two groups, {cmd:xtmixed} labeled the chi-squared
    test as conservative when, in fact, the test was precise.  This has been
    fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew10to11}.{p_end}

{hline}
