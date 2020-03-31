{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 7}

{pstd}
This file records the additions and fixes made to Stata during the life
of Stata version 7:

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
    {c |} {bf:this file}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.
Note:  Starred (*) items mean the update was made to the executable.


{hline 5} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew7to8}.


{hline 5} {hi:update 05dec2002} {hline}

{p 2 6 2}
1.  On-line help and search index brought up-to-date for
    {help sj:Stata Journal 2(4)}.

{p 2 6 2}
2.  {help binreg} with the {cmd:by} {it:...}{cmd::} prefix did not restrict the
    observations based on the {cmd:by}.  This is fixed.


{hline 5} {hi:update 08nov2002} {hline}

{p 2 6 2}
1.  {help xpose} did not allow specification in the optional {cmd:_varname}
    variable of variable names of the form "v" followed by a number, such as
    "v1" or "v2"; this is fixed.


{hline 5} {hi:update 28oct2002} {hline}

{p 2 6 2}
1.  {help codebook} misspelled "trailing" in the output; this is fixed.

{p 2 6 2}
2.  {help savedresults:savedresults compare} was not comparing matrices; this
    is fixed.

{p 2 6 2}
3.  {help testnl} did not allow the {cmd:g()} or {cmd:r()} options when the
    expressions were enclosed in parentheses (the second syntax of
    {cmd:testnl}); this is fixed.


{hline 5} {hi:update 14oct2002} {hline}

{p 2 6 2}
1.  {help adjust} used after a model specified with an {cmd:offset()} or
    {cmd:exposure()} that varied within groups defined by {cmd:adjust}'s
    {cmd:by()} option, would arbitrarily choose one of the {cmd:offset()} or
    {cmd:exposure()} values found within each group in computing predictions.
    Now {cmd:adjust} requires that {cmd:offset()} or {cmd:exposure()} be
    constant within the groups defined by {cmd:adjust}'s {cmd:by()} option or
    that {cmd:adjust}'s {cmd:nooffset} option be specified.


{hline 5} {hi:update 02oct2002} {hline}

{p 2 6 2}
1.  {help mvreg} with collinear x variables correctly dropped the collinear
    variables from the estimation, but did not correspondingly drop them from
    the count contained in {cmd:e(k)} and {cmd:e(df_r)} which caused standard
    errors to be slightly larger than they should have been.  This is fixed.


{hline 5} {hi:update 25sep2002} {hline}

{p 2 6 2}
1.  {help swilk:swilk, lnnormal} would fail when there were 11 or fewer
    observations; this is fixed.

{p 2 6 2}
2.  {help xtabond} produced an incorrect {cmd:e(sample)} when the sample was
    more restricted by lags of the predetermined variables than by lags of the
    endogenous variables; this is fixed.


{hline 5} {hi:update 18sep2002} {hline}

{p 2 6 2}
1.  On-line help and search index brought up-to-date for
    {help sj:Stata Journal 2(3)}.

{p 2 6 2}
2.  {help kdensity:kdensity, parzen} when specified with {help weights} did
    not apply the weights; this is fixed.

{p 2 6 2}
3.  {help svytab:svytab, ci} now produces a better error message when more
    than one of the {cmd:cell}, {cmd:count}, {cmd:row}, or {cmd:column}
    options are specified.

{p 2 6 2}
4.  {help tabodds:tabodds, woolf or} incorrectly labeled the Woolf confidence
    interval as being Cornfield; this is fixed.


{hline 5} {hi:update 09aug2002} {hline}

{p 2 6 2}
1.  {help clkmeans:cluster kmeans} and {help clkmed:cluster kmedians} with a
    binary {help cldis:dissimilarity measure} option (for example,
    {cmd:matching}, {cmd:Jaccard}, ...) and presented with nonbinary data
    having no zeros, would cause Stata to crash.  It now displays an
    appropriate error message.

{p 2 6 2}
2.  {help egen:egen ... cut()} with the {cmd:at()} option was updated on
    08may2002 so that {it:k} instead of {it:k}-1 categories were created when
    {it:k} numbers were specified in {cmd:at()}.  The original behavior of
    creating {it:k}-1 categories is now reinstated.

{p 6 6 2}
    Some argue that {cmd:at()} should create {it:k} categories, others counter
    that {it:k}-1 is most natural.  Either way, the 08may2002 change should
    not have occurred because StataCorp policy is that updates during a
    release are to fix bugs and to add new functionality, not to change
    existing functionality.

{p 2 6 2}
3.  {help xtivreg:xtivreg, be} with [{cmd:if} {it:exp}] or
    [{cmd:in} {it:range}] did not save {cmd:e(sample)}; this is fixed.


{hline 5} {hi:update 02aug2002} {hline}

{p 2 6 2}
1.  {help collapse} would generate 0 for the standard deviation ({cmd:sd}) of
    a variable that equaled missing value (.) in all observations even though
    it would generate missing value for the mean.  {cmd:collapse} now
    generates missing value for the standard deviation, too.

{p 2 6 2}
2.  {help ksm:ksm, logit by()} did not handle the {cmd:by()} graph option
    correctly; this is fixed.

{p 2 6 2}
3.  {help roctab} could produce a "not enough memory" error due to temporary
    variables not being dropped at the end of each iteration of a loop.  This
    is fixed.

{p 2 6 2}
4.  {help ssc} has new subcommand {cmd:whatsnew} -- just type {cmd:ssc}
    {cmd:whatsnew} -- that summarizes the packages most recently made
    available or updated.  Output is presented in the Viewer, from where you
    may click to find out more or install.
    See help {help ssc}.


{hline 5} {hi:update 18jul2002} {hline}

{title:Stata executable(*)}

{p}
The 18jul2002 update is relevant only for 64-bit executables:  64-bit Sun
Solaris, 64-bit SGI IRIX, and Tru64/Digital Unix.  For all other platforms
(including Windows, Mac, and all other Unix), the 11jun2002
executable continues to be the most up to date.

For the 64-bit executables:

{p 2 6 2}
1.  Stata on 64-bit computers could crash when there was more than 2 gigabytes
    of data in memory and certain memory reorganizations were necessary.  This
    is fixed.


{hline 5} {hi:update 11jul2002} {hline}

{p 2 6 2}
1.  {help boxcox} treated {cmd:iweight}s as if they were {cmd:fweight}s and
    would not allow noninteger {cmd:iweight}s (see help {help weights}); this
    is fixed.

{p 2 6 2}
2.  {help egen} now allows longer {help numlist}s in the {cmd:values()} option
    for the {cmd:eqany()} and {cmd:neqany()} functions.

{p 2 6 2}
3.  {help nl} now produces more informative error messages.

{p 2 6 2}
4.  {help svytab:svytab, missing} would fail to run when missing values were
    present; this is fixed.

{p 2 6 2}
5.  {help svytab} would occasionally override the user specified
    {cmd:stubwidth()} and {cmd:cellwidth()} options (added in the 21jun2002
    update).  This is fixed.


{hline 5} {hi:update 21jun2002} {hline}

{p 2 6 2}
1.  On-line help and search index brought up-to-date for
    {help sj:Stata Journal 2(2)}.

{p 2 6 2}
2.  {help glm} previously calculated the Bayesian Information Criterion (BIC)
    using the model degrees of freedom as a component of the calculation,
    whereas the more common formula for BIC in the literature uses the
    residual degrees of freedom.  {cmd:glm} now calculates BIC using
    the residual degrees of freedom.

{p 2 6 2}
3.  {help newey} now preserves the sort order of the data.

{p 2 6 2}
4.  {help svytab} has new options: {cmd:cellwidth()}, {cmd:csepwidth()}, and
    {cmd:stubwidth()}.  See help {help svytab} for details.


{hline 5} {hi:update 11jun2002} {hline}

{p 2 6 2}
1.  {help blogit} and {help bprobit} with the {cmd:cluster()} or
    {cmd:offset()} options produced an error message; this is fixed.

{p 2 6 2}
2.  {help dstdize} ignored the {cmd:if} and {cmd:in} qualifiers when checking
    the data; this is fixed.

{p 2 6 2}
3.  {help egen:egen ... cut(), label} gave incorrect value labels as a result
    of the 08may2002 ado-file update; this is fixed.

{p 2 6 2}
4.  {help fracpoly} reported a missing value for the deviance when the model
    fit the data exactly; this is fixed.

{p 2 6 2}
5.  {help icd9:icd9 check} and {help icd9p:icd9p check} with the
    {cmd:generate()} option would fail if the operating system's temporary
    file directory name had a space in it; this is fixed.

{p 2 6 2}
6.  {help glm:predict, anscombe} produced incorrect results when used after
    {help glm} for negative binomial and non-Bernoulli binomial models.  This
    is fixed.

{p 2 6 2}
7.  {help xtabond}:  A number of improvements and bug fixes have been made.

{p 6 10 2}
    A.  {cmd:xtabond} did not use the first available moment condition for
	predetermined variables, causing the estimates to be consistent but
	less efficient than they could be.  This is fixed.

{p 6 10 2}
    B.  {cmd:xtabond}, when there was a gap common to all panels, did not
	properly calculate the degrees of freedom of the Sargan test.  This is
	fixed.

{p 6 10 2}
    C.  {cmd:xtabond, robust} and {cmd:xtabond, twostep}, with some datasets,
	could unnecessarily exit with the error "matrix not symmetric",
	r(505), due to an overly restrictive tolerance.  This is fixed.

{p 6 10 2}
    D.  {cmd:xtabond, noconstant} required that exogenous variables be
	specified, even if predetermined variables were specified.
	{cmd:noconstant} is now allowed when either exogenous or predetermined
	variables are specified.

{p 6 10 2}
    E.  {cmd:xtabond} now allows endogenous regressors; see help
	{help xtabond} for syntax.

{p 6 10 2}
    F.  {cmd:xtabond} is now 17% faster.

{p 2 6 2}
8.  {help xtgls} has an improved error message.

{p 2 6 2}
9.  {help xtivreg}:  One improvement and one fix has been made.

{p 6 10 2}
    A.  {cmd:xtivreg} now separately checks for collinearity in the varlists
	of exogenous variables and instruments.  This ensures that when an
	instrument is perfectly collinear with an exogenous variable, it is
	the instrument and not the exogenous variable which is dropped from
	the regression.

{p 6 10 2}
    B.  {cmd:xtivreg, fd} did not save {cmd:e(sample)}.  This is fixed.

{p 1 6 2}
10.  {help xtregar:xtregar, fe} displayed temporary variable names when there
     were time-series operated variables.  This is fixed.


{title:Stata executable(*)}

{p 1 6 2}
11.  (All platforms)
     The maximum number of significant {cmd:d}escription lines in a
     {help usersite:.pkg} file (see help {help net}) has been increased from
     20 to 100.  Previously, only the first 20 {cmd:d}escription lines would
     be listed.  Now, the first 100 will be listed.

{p 1 6 2}
12.  (All platforms)
     The {help functions:lngamma()} function now has 8 to 9 digits of accuracy
     whereas before it had 6 to 7.

{p 1 6 2}
13.  (All platforms)
     Internal service routines were modified to support the changes made to
     {help xtabond} documented in (7) above.

{p 1 6 2}
14.  ({help specialedition:Stata/SE}, all platforms)
     Using the {help edit:data editor}, if you added onto the end of a string
     variable to make it longer than {help str:str80}, the variable's contents
     would be truncated to 80 characters.  This is fixed (the maximum length
     of strings in Stata/SE is 244 characters).

{p 1 6 2}
15.  (Stata for Unix)
     Using the Print dialog when no PostScript printer had been defined would
     cause Stata to crash.  Stata now displays an error message describing the
     problem.


{hline 5} {hi:update 08may2002} {hline}

{p 2 6 2}
1.  {help alpha}, if invoked with several variables and one of the variables
    was dropped because it was constant, resulted in all the subsequent
    variables also being dropped.  This is fixed.

{p 2 6 2}
2.  {help destring} when called with multiple variables could fail due to
    changes made in the 04apr2002 update.  This is fixed.

{p 2 6 2}
3.  {help egen:egen ... cut()} with the {cmd:at()} option previously created
    {it:k}-1 categories when {it:k} numbers were specified in {cmd:at()}.
    Values larger than the {it:k}th value of {cmd:at()} were mapped to
    missing.  Now {it:k} categories are created, and values larger than the
    {it:k}th element of {cmd:at()} are mapped to the {it:k}th element of
    {cmd:at()}.

{p 2 6 2}
4.  {help mfx} produced incorrect standard errors when used on certain
    predictions after certain commands.  This is fixed.

{p 6 10 2}
    A.  {cmd:mfx} calculated standard errors for any statistic calculated by
	{cmd:predict} after any estimation command, even if that would be
	inappropriate, such as predictions of residuals.  The marginal
	effects calculated, however inappropriate they might be, adhered to
	the definition and so were "correct", but the standard errors were
	incorrect and, in fact, cannot be calculated by ordinary means.  In
	this case, marginal effects are now reported but standard errors are
	suppressed.

{p 6 10 2}
    B.  {cmd:mfx} calculated standard errors that were incorrect in the
	following cases:

{p 10 16 2}
	  B.1.  Predictions of {cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)},
		{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}, and
		{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} after {help regress},
		{help truncreg}, {help cnsreg}, {help heckman}, {help eivreg},
		{help intreg}, {help svyintreg}, and {help tobit}.

{p 10 16 2}
	  B.2.  Predictions of {cmd:nu0} and {cmd:iru0} after {help xtnbreg}.

{p 10 16 2}
	  B.3.  Predictions of {cmd:ycond} and {cmd:yexpected} after
		{help heckman}.

{p 10 16 2}
	  B.4.  Predictions obtained after {help streg:streg, dist() frailty()}
		that are unconditional on the frailty.

{p 10 10 2}
	 In all other cases, reported marginal effects and standard errors
	 were correct.  This includes use after {help probit}, {help logit},
	 {help mlogit}, etc.

{p 10 10 2}
	 In the cases listed, the reported marginal effect was correct but the
	 standard error was incorrect; this is fixed.  In the case of (B.1),
	 marginal effects for {cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)},
	 {cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}, and
	 {cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)}, are reported for all
	 commands, but standard errors will not be reported after
	 {help regress}, {help cnsreg}, and {help eivreg}.

{p 6 6 2}
    All the cases in (B) concerned the calculation of standard errors when
    the underlying model had ancillary parameters and they were either not
    recorded in the coefficient vector (for example, RMSE in the case of linear
    regression) or recorded in an e() scalar as well as the coefficient vector
    and the corresponding {cmd:predict} command was written using the e()
    scalar result.  {cmd:mfx} works by perturbing the coefficient vector and
    recalculating the predictions in order to obtain standard errors.  In all
    of the above cases, the effect of the uncertainty about an ancillary
    parameter was being ignored in the standard-error calculation of the
    marginal effect.

{p 6 6 2}
    Thus, the fixes for the problem were actually made to the corresponding
    {cmd:predict} commands.  In addition, {cmd:mfx} was modified so that it
    now verifies that results from {cmd:predict} are a function of the
    coefficient vector only and, if they are not, {cmd:mfx} suppresses the
    reporting of standard errors.

{p 6 6 2}
    The cases in (A) were similarly cases of the prediction not solely being a
    function of the coefficient vector, but in those cases, what was asked for
    was inappropriate because the standard error substantively depended on
    other things as well.  Since {cmd:mfx} now checks that results from
    {cmd:predict} are a function of the coefficient vector only, such
    inappropriate standard errors will no longer be reported.

{p 2 6 2}
5.  {help mfx} did not clear its estimation results, so if you typed
    "{cmd:mfx compute}" and then typed "{cmd:mfx compute, nose}", it would
    appear that the {cmd:nose} option was being ignored.  This is fixed.

{p 2 6 2}
6.  {help mfx:mfx compute, predict(residual)} after {cmd:regress} would claim
    to be ignoring your specification {cmd:predict(residual)} and then in fact
    not ignore it.  This is fixed.

{p 2 6 2}
7.  {help streg:predict} after {cmd:streg} now labels the new variable better
    and produces more informative error messages.

{p 2 6 2}
8.  {help streg:predict, mean time} is now available after
    {cmd:streg, dist(gamma)}.  ({cmd:predict} after {cmd:streg, dist(gamma)}
    previously could not make mean-time calculation).

{p 2 6 2}
9.  {help zip:predict, ir} when used after {cmd:zip} and {cmd:zinb} produced a
    syntax error.  This is fixed.

{p 1 6 2}
10.  {help zip:predict, n nooffset} when used after {cmd:zip} and {cmd:zinb}
     would apply the {cmd:nooffset} option to both the main equation and the
     "inflate" equation, when in fact it should only be applied to the main
     equation.  This is fixed.

{p 1 6 2}
11.  {help xtgls} and {help xtpcse} gave wrong standard errors when
     {help aweight}s were specified; this is fixed.


{title:Stata executable(*)}

{p 1 6 2}
12.  {help tabdisp} and {help table} would misalign the value labels above the
     supercolumns in 3-way tables, and display text such as
     "{c -(}hline -4{c )-}", when the value label was very long.  This is
     fixed.

{p 1 6 2}
13.  The cause of a crash reported with {help reshape} has been fixed.  The
     crash would in fact be invoked by the following sequence of events:  (1)
     a long, very narrow dataset which nearly filled memory was loaded; (2)
     the data were dropped by {help drop:drop _all}; (3) {help obs:set obs}
     was then used to create a 0-variable dataset; (4) {help generate} was
     finally used to create a variable that itself was wider than the sum of
     the widths of the previously loaded narrow dataset.  Stata would crash on
     the {cmd:generate} as it tried automatically to repartition memory
     containing 0 variables and _N>0 observations.

{p 1 6 2}
14.  (Windows) Filenames with paths longer than 128 characters may now be
     opened in the do-file editor.

{p 1 6 2}
15.  (Mac) With {cmd:set slash on}, macros containing a file path
     would be incorrectly expanded; this is fixed.

{p 1 6 2}
16.  (Mac) The Viewer window would sometimes not properly refresh its
     contents after the Back button had been pressed if
     the scrollbar was not at the top of the document.  This is fixed.

{p 1 6 2}
17.  (Mac) In OS X, if the Viewer window was in front of the Results
     window, it was not possible to make a selection in the area of the Viewer
     that obscured the Results window.  This is fixed.


{hline 5} {hi:update 04apr2002} {hline}

{p 2 6 2}
1.  {help cci} could enter an endless loop if one of the four numbers entered
    was zero; this is fixed.

{p 2 6 2}
2.  {help destring} now allows an abbreviated {it:newvarlist} in the
    {cmd:generate()} option.  For example,

{p 10 14 2}
	{cmd:. destring a b c x y z, generate(v1-v6)}

{p 6 6 2}
    generates six variables (v1, v2, ... v6).

{p 2 6 2}
3.  {help destring} failed when a large number of variables (300+) were
    specified; this is fixed.

{p 2 6 2}
4.  {help ir:ir, by() ird} did not give correct standard errors for the
    standardized rate difference (SRD) for stratified incidence-rate data;
    this is fixed.

{p 2 6 2}
5.  With the 09jan2002 update, {help streg:predict} after
    {cmd:streg, frailty()} ignored the optional user specified storage type
    and instead created the variable using the default type ({help float}).
    This is fixed.

{p 2 6 2}
6.  {help tabodds:tabodds, cornfield} calculated exact confidence intervals
    instead of the requested Cornfield confidence intervals; this is fixed.

{p 2 6 2}
7.  {help tabodds} could produce missing values for some of the odds ratios
    when the exposure variable had noninteger values; this is fixed.


{hline 5} {hi:update 22mar2002} {hline}

{title:Stata executable(*)}

{p 2 6 2}
1.  (All platforms)
    {help more:set more} has new {cmd:permanent} option that will cause
    Stata to remember the more setting between sessions.  For instance, you
    can type "{cmd:set more off, permanent}" so that (1) more is turned
    off and (2) Stata will subsequently come up with more turned off.

{p 2 6 2}
2.  (All platforms)
    Stata's reaction time to pressing the Break key, and the refreshing
    of windows during long calculations, is greatly improved.

{p 2 6 2}
3.  (Windows) Under Windows 98, Stata could not allocate more than 256
    megabytes to the data area; this is fixed.

{p 2 6 2}
4.  (Windows) Under Windows XP, users sometimes could not start Stata from the
    Start menu.  This is fixed.

{p 2 6 2}
5.  (Windows) Under Windows 2000 and Windows XP, clicking on a Stata window to
    make it active would sometimes not result in the window bar turning blue
    (that is, the window would not be activated, even though the window did get
    the keyboard focus and so allowed input).  The most noticeable side effect
    was the window would not allow the highlighting of text for copying into
    other windows, and this was most noticed in the Command window.  This is
    fixed.

{p 2 6 2}
6.  (Mac) {cmd:set slash} is now better documented
    and, if you "{cmd:set slash on}" slashes ({cmd:/}) in filenames
    will be understood everywhere as the directory separator.

{p 2 6 2}
7.  (Mac) Icons compatible with OS X are now included.

{p 2 6 2}
8.  (Mac) {help graph} would sometimes produce text that should have
    been vertically aligned but was not; this is fixed.

{p 2 6 2}
9.  (Mac) {help window:window menu clear} will no longer result in
    multiple instances of the same menu item appearing.


{hline 5} {hi:update 15mar2002} {hline}

{p 2 6 2}
1.  On-line help and search index brought up-to-date for
    {help sj:Stata Journal 2(1)}.

{p 2 6 2}
2.  {help arima} may now be used with the {help by} prefix command.

{p 2 6 2}
3.  {help arima} now allows estimation and prediction using samples that are
    wholly contained within one panel of a panel dataset (a dataset that has
    been {help tsset} with both panel and time identifiers).  This allows
    {cmd:arima} to be used in loops over panels.  Previously, unless the
    {cmd:condition} option was specified, {cmd:arima} refused to estimate any
    models on panel data.

{p 2 6 2}
4.  {help ci:ci, poisson} previously treated missing values in the
    {it:varlist} as representing zero events when the {cmd:exposure()} option
    was specified and the corresponding exposure variable was not also
    missing.  Now {cmd:ci} excludes those observations.

{p 2 6 2}
5.  {help ml} and all estimators using {cmd:ml} have a new tolerance option
    for determining convergence:  {cmd:nrtolerance()}.  Convergence is
    declared when g*inv(H)*g' < {cmd:nrtolerance()}, where g represents the
    gradient vector and H the Hessian matrix; see help {help maximize}.

{p 2 6 2}
6.  {help reg3} produced an extraneous horizontal line when the {cmd:noheader}
    option was specified; this has been fixed.

{p 2 6 2}
7.  {help sts:sts generate} would produce the error message "_merge already
    defined" when the user had previously used the {help merge} command
    and had not dropped the {cmd:_merge} variable.  That was because, in
    its machinations, {cmd:sts generate} used the {cmd:merge} command itself.
    {cmd:sts generate} still does this, but it no longer uses the variable
    name {cmd:_merge} to mark the outcome of its internal merge, meaning
    that if you have done a previous {cmd:merge}, {cmd:sts generate} will
    not complain that {cmd:_merge} is already defined, nor will this fix
    result in the value of an existing {cmd:_merge} variable having its values
    changed.

{p 6 6 2}
    {help stci} had the same behavior as {cmd:sts generate} because it used
    {cmd:sts generate} as a subroutine.  {cmd:stci} no longer cares whether
    the variable {cmd:_merge} exists in the dataset.

{p 2 6 2}
8.  {help xi} could fail when the command line contained quotes; this is fixed.


{hline 5} {hi:update 27feb2002} {hline}

{p 2 6 2}
1.  {help icd9} and {help icd9p} have been updated to use the V19 codes; V18
    codes (see the 11jun2001 update) and V16 codes were previously used.  V16,
    V18, and V19 codes have been merged so that {cmd:icd9} and {cmd:icd9p}
    work equally well with old and new datasets.  See help {help icd9} for a
    description of {cmd:icd9} and {cmd:icd9p}; type "{stata icd9 query}" and
    "{stata icd9p query}" for a complete description of the changes to the
    codes used.

{p 2 6 2}
2.  {help merge} no longer has a limit on the number of key (matching)
    variables; the previous limit was 10.  This change was implemented in
    the 01feb2002 executable update, but was not mentioned.

{p 2 6 2}
3.  {help mkmat} is now faster.

{p 2 6 2}
4.  {help rchart} and {help shewhart} now allow [{cmd:if} {it:exp}] and
    [{cmd:in} {it:range}] as claimed in {hi:[R] qc}.

{p 2 6 2}
5.  {help stcurve} has two new options, {cmd:unconditional} and {cmd:alpha1},
    for use after fitting frailty models with {help streg}.
    {cmd:unconditional} plots curves that are unconditional on the frailty.
    {cmd:alpha1} plots curves that are conditional on a frailty value of one.
    See help {help stcurve} for details.


{hline 5} {hi:update 01feb2002} {hline}

{p 2 6 2}
1.  {help statase:Stata/SE} was released, a new product that allows
    more variables, longer strings, and larger matrices.

{p 6 6 2}
    Stata/SE is not a new release of Stata and so you should not be worried
    that you will be out-of-date if you do not upgrade.  Stata/SE 7 is a
    bigger version of Stata 7.  If any of the limits of Intercooled Stata have
    gotten in your way, Stata/SE provides the solution.

{p 6 6 2}
    See help {help stata/se} for more information and point your browser
    to {browse "http://www.stata.com"} for purchase information.

{p 2 6 2}
2.  {help biprobit}, in the unusual case where robust variance estimates were
    requested and the parameter {cmd:/athrho} was constrained, would produce
    an extraneous message that the constraint was dropped.  The message was
    incorrect, and the constraint was included in the estimation.  This is
    fixed.

{p 2 6 2}
3.  {help bstat} could exit with an unhelpful error message in certain cases
    when calculating the endpoints for the bias-corrected CI; this is
    fixed.

{p 2 6 2}
4.  {help corr2data} and {help drawnorm} could produce the wrong correlation
    structure when the covariance matrix specified in the {cmd:cov()} option
    contained equation names; this is fixed.

{p 2 6 2}
5.  {help ssc} now produces the same informative error messages for those
    using a proxy server as those who do not.

{p 2 6 2}
6.  {help stset} now preserves the sort order of the data.

{p 2 6 2}
7.  {help xtpcse}, when specified with the options {cmd:correlation(psar1)} and
    {cmd:hetonly}, and when the matrix size was declared smaller than the
    number of panels, would issue an error message and refuse to estimate the
    model.  This is fixed.


{title:Stata executable(*)}

{p 2 6 2}
8.  Intercooled Stata has been updated to read the new
    {help statase:Stata/SE} .dta file format automatically if the
    dataset does not contain strings longer than {help str:str80} or more than
    2,047 variables.

{p 2 6 2}
9.  {help matsize:set matsize} and {cmd:set memory} have new option
    {cmd:permanent} to set the value and remember it between sessions.

{p 1 6 2}
10.  {help anova} could cause Stata to crash when estimating a model with
     more than 255 terms (a*b counts as one term no matter how many levels
     of a or b there are).  This is fixed.

{p 1 6 2}
11.  The text for the error messages associated with return codes 900 (no room
     to add more variables), 901 (no room to add more observations), 902 (no
     room to add more variables due to width), 903 (no room to promote
     variable), and 908 (matsize too small) has been improved.  If you are
     curious, you can see the improved text by typing {cmd:error 900}, ...,
     {cmd:error 903}, and {cmd:error 908} in the Command window.

{p 1 6 2}
12.  Stata for Mac will now properly display line breaks in help files
     created under Windows.


{hline 5} {hi:update 09jan2002} {hline}

{p 2 6 2}
1.  {help heckman:heckman, twostep} did not save e(sample).
    This affected no outputted results and is fixed.

{p 2 6 2}
2.  {help streg:predict} after {cmd:streg, frailty()} has two new options,
    {cmd:alpha1} and {cmd:unconditional}.  {cmd:alpha1} generates predictions
    conditional on a frailty equal to 1.  {cmd:unconditional} generates
    predictions that are unconditional on the frailty.

{p 6 6 2}
    Previously, when fitting a frailty model with {cmd:streg, frailty()}
    without the {cmd:shared()} option, {cmd:predict} would give unconditional
    predictions, and one may now override this default by using the new
    {cmd:alpha1} option.

{p 6 6 2}
    Previously, when fitting a shared frailty model with
    {cmd:streg, frailty() shared()}, predictions from {cmd:predict} were
    conditional on a frailty value of 1, and one may now override this
    default by using the new {cmd:unconditional} option.

{p 6 6 2}
    See help {help streg}.

{p 2 6 2}
3.  {help streg:predict} after {cmd:streg, dist(llogistic) ancillary()} or
    after {cmd:streg, dist(gamma) ancillary() anc2()} sometimes gave
    predictions based on erroneous estimates of the ancillary parameter(s).
    The estimated ancillary parameters should vary with the data, yet the
    parameters were sometimes held fixed at their values for {cmd:_n==1} when
    the predictions were calculated.  This is fixed.

{p 2 6 2}
4.  {help streg:predict} after {help streg} handles {cmd:if} and {cmd:in}
    conditions more efficiently (it runs faster).

{p 2 6 2}
5.  {help svydes}, {help svymean}, {help svyprop}, {help svyratio},
    {help svytab}, and {help svytotal} now preserve the sort order of the
    data.


{hline 5} {hi:update 20dec2001} {hline}

{p 2 6 2}
1.  {help ivreg} no longer lists perfectly collinear variables in
    {cmd:e(insts)}.

{p 2 6 2}
2.  {help pac} (and {help corrgram} since it calls {cmd:pac}) would overwrite
    any existing {cmd:e()} results with the results from the regression
    computed within {cmd:pac}.  Now the previous {cmd:e()} results
    are restored.

{p 2 6 2}
3.  {help treatreg} would report a "conformability error" and fail to run when
    there were perfect predictors in the treatment equation; this is fixed.

{p 2 6 2}
4.  {help xtreg} now issues a more appropriate error message when the panel
    variable is collinear with the independent variables.

{p 2 6 2}
5.  {help xtregar:xtregar, fe} did not save {cmd:e(rmse)}; this is fixed.


{hline 5} {hi:update 11dec2001} {hline}

{p 2 6 2}
1.  {help streg} has new option {cmd:shared(}{it:varname}{cmd:)} for fitting
    parametric shared frailty models, analogous to random effects models for
    panel data:  the frailty value is common among groups of observations and
    randomly distributed across groups.  {cmd:streg} could and still can
    estimate frailty models where the frailties are assumed to be randomly
    distributed at the observation level (specify option {cmd:frailty()}
    without the new option {cmd:shared()}).  See help {help streg}.

{p 2 6 2}
2.  On-line help and search index updated to include reference to more of the
    material available at {browse "http://www.ats.ucla.edu/stat/stata/"}.

{p 2 6 2}
3.  {help adjust} now allows the {cmd:pr} option when used after
    {help svylogit}, {help xtlogit}, {help svyprobit}, and {help xtprobit}.

{p 2 6 2}
4.  {help arima} with the unusual combination of a model with no covariates
    and with options {cmd:from(armab0)} and {cmd:noconstant} specified, would
    issue an error message and refuse to estimate the model; this is fixed.

{p 2 6 2}
5.  {help findit} without the {cmd:saving()} option now places the file
    _finditresults.smcl in the directory specified by the
    {help macro:global macro} {cmd:FINDIT_DIR} if defined or the current
    directory if not.

{p 2 6 2}
6.  {help linktest} now works after {help stcox} and {help streg}.

{p 2 6 2}
7.  {help nlogit} with the {help by} prefix command would present results for
    the complete sample after presenting the results for each by group.  Now
    it presents only the results for each by group.

{p 2 6 2}
8.  {help roccomp:roccomp, graph} now accepts the {cmd:l2title()}
    {help gr7axes:graph} option.  Additionally, {cmd:roccomp, graph binormal}
    now allows {help gr7color:graph}'s {cmd:pen()} option.

{p 6 6 2}
    {cmd:roccomp, graph} used to assign a key to the 45-degree line in the
    graph.  It no longer does, instead providing keys only for the actual
    curves.

{p 2 6 2}
9.  {help roctab} has a new option {cmd:specificity} to graph sensitivity
    versus specificity, instead of the default sensitivity versus
    (1-specificity); see help {help roctab}.

{p 1 6 2}
10.  {help treatreg:treatreg, twostep} did not save e(sample); this is fixed.

{p 1 6 2}
11.  {help prais} could, due to collinearity, drop the dependent variable;
    this is fixed.

{p 1 6 2}
12.  {help zip} and {help zinb} now accept the {cmd:from()} option.


{hline 5} {hi:update 07dec2001} {hline}

{title:Stata executable(*), Windows}

{p 2 6 2}
1.  The 06dec2001 fix for the on-going problem in which the mouse could not be
    used to select text in edit fields under Windows 2000 and XP created a
    problem for Windows 95 and 98; that is fixed.


{hline 5} {hi:update 06dec2001} {hline}

{p 2 6 2}
1.  {help ml} unnecessarily left behind matrices named ML_CT and ML_Ca
    after estimation with {cmd:constraints()}.

{p 6 6 2}
    {cmd:ml} now saves the constraint matrix in internal matrix Cns which
    can be obtained by typing "{cmd:matrix} {it:name} {cmd:=} {cmd:get(Cns)}".

{p 6 6 2}
    {cmd:ml display} now displays any constraints associated with the
    estimates.

{p 6 6 2}
    Note, there was nothing wrong with any results produced by {cmd:ml}; these
    changes merely affect how results are stored and displayed.


{title:Stata executable(*)}

{p 2 6 2}
2.  In downloading from the SSC Archive, Stata would occasionally
    (some would say often) produce the error message "I/O error" and you would
    have to try again.  This is fixed.  (Stata now watches for the problem and
    reestablishes the connection.)

{p 2 6 2}
3.  In {help exp:expressions}, FORTRAN syntax such as "1d+2" was not
    understood to mean 100 despite the documentation's claim otherwise.
    Now 1d+2 and even 1d2 are understood.

{p 2 6 2}
4.  {help foreach} and {help forvalues} now respond more promptly to the
    Break key.

{p 2 6 2}
5.  {help ivreg:ivreg, beta} produced random values for the betas
    (standardized coefficients); this is fixed.  Coefficients, standard errors,
    t-statistics, etc., were all correct.

{p 2 6 2}
6.  {help mlogit} previously printed any constraints before the iteration
    log; it now prints them after the log and before the coefficient table.
    Note, there was nothing wrong with any results produced by {cmd:mlogit};
    this change merely affects how results are displayed.

{p 2 6 2}
7.  {help syntax} allows new syntactical element {it:anything};
    see help {help syntax}.

{p 2 6 2}
8.  If you are programming in the dialog boxes created by
    {help window:window dialog}, you now can repopulate a combo box by
    changing the contents of the macro associated with it.

{p 2 6 2}
9.  (Windows)
    The permanent, more elegant fix promised in the 27oct2001 update for the
    on-going problem in which the mouse cannot be used to select text in edit
    fields under Windows 2000 or XP has been found and implemented.
    If you have {cmd:set cmdtitle off} in order to work around the bug and
    want the title back, set the {cmd:cmdtitle} back on.

{p 1 6 2}
10.  (Windows)
    Multiple instances of Stata running at the same time are now clearly
    marked in their title bar with an instance number.

{p 1 6 2}
11.  (Windows)
    Results and Viewer windows now have contextual menus; right-click when you
    are in the window to try it.

{p 1 6 2}
12.  (Windows and Mac)
     {help rmsg:set rmsg} could report the decimal portions of timings
     incorrectly; this is fixed.

{p 1 6 2}
13.  (Mac)
    You can now select all the contents of the Results or Viewer windows by
    selecting {hi:Select All} from the {hi:Edit} menu.

{p 1 6 2}
14.  (Mac)
    Any errors that occur when printing are now reported.  Previously, Stata
    relied on the Finder to report printing problems which, in some cases, it
    did not.

{p 1 6 2}
15.  (Mac)
    Clicking in the Variables window will now overwrite selected text in the
    Command window.

{p 1 6 2}
16.  (Unix GUI)
    Printing the Results or Viewer windows through the Print dialog box
    would sometimes fail; this is fixed.

{p 1 6 2}
17.  (Unix GUI)
     {help window:window menu} did not allow appending to the default Stata
     menus when the keyword {cmd:sysmenu} was enclosed in quotes; this is
     fixed.

{p 1 6 2}
18.  (Unix GUI)
    If a minimized window was selected from the {hi:Window} menu, Stata
    sometimes crashed; this is fixed.


{hline 5} {hi:update 14nov2001} {hline}

{p 2 6 2}
1.  On-line help and search index brought up-to-date for
    {help sj:Stata Journal 1(1)}.

{p 2 6 2}
2.  {help loneway} with the {cmd:exact} option produced correct results, but
    displayed spurious {help smcl} commands in a table header; this is fixed.

{p 2 6 2}
3.  {help ml:ml model, waldtest(0)}, rather than executing, produced an error
    message; this is fixed.

{p 2 6 2}
4.  {help nl} now saves the number of iterations in {hi:e(ic)}.

{p 2 6 2}
5.  {help nlogit} used with {help weights} did not correctly check for
    constant weights within groups; this is fixed.

{p 2 6 2}
6.  {help roctab:roctab, detail} could, under exceedingly rare conditions,
    produce incorrect results; this is fixed.  Additionally, a display format
    was changed to better display noninteger values.

{p 2 6 2}
7.  {help ssc} is a new command that lists and installs packages (and files)
    from the Statistical Software Components (SSC) archive, often called the
    Boston College Archive, and provided by
    {browse "http://repec.org":http://repec.org}.

{p 6 6 2}
    {cmd:ssc} is based on {cmd:archutil} by Nicholas J. Cox, University of
    Durham, and Christopher Baum, Boston College.  The reworking of the
    original was done with their blessing and their participation.

{p 2 6 2}
8.  {help stcurve:stcurve, hazard} is no longer allowed after {help stcox}
    since the graph produced was not a true hazard curve.

{p 2 6 2}
9.  {help tabodds}' display format was changed to better display noninteger
    values in the table.

{p 1 6 2}
10.  {help xtivreg} now saves the list of instrumented variables in
     {hi:e(instd)} and the list of instruments in {hi:e(insts)}.


{hline 5} {hi:update 26oct2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help matconst:matrix makeCns}, a programmer's command, now allows
    specifying constraints as a matrix or as a list of constraint numbers; see
    help {help matconst}.  This new matrix feature is also inherited by most
    commands that allow the {cmd:constraints()} option, such as {help cnsreg}.
    In those commands, the {cmd:constraints()} option may now be specified
    with a list of constraint numbers, as previously, or the name of a matrix.

{p 2 6 2}
2.  {help mat_put_rr} is a new programmer's command that directly specifies
    the {hi:Rr} matrix to be used in the next replay call of {help test}; see
    help {cmd:mat_put_rr}.

{p 2 6 2}
3.  {help post} has improved error messages to deal with too many or too few
    expression arguments.

{p 2 6 2}
4.  {help program:program drop} (and automatically generated
    {cmd:program drop}s) could cause subprograms to be mistakenly dropped when
    the subprogram had the same name as the main program in the dropped
    module.  This is fixed.

{p 2 6 2}
5.  {help search} now has new option {cmd:sj} which is a synonym to the
    existing option {cmd:stb} that limits the search to the
    {browse "http://www.stata-journal.com":Stata Journal} and Stata Technical
    Bulletin.


{title:Stata executable(*), Windows, dated 27oct2001}

{p 2 6 2}
1.  A workaround has been introduced for an on-going problem in which the
    mouse cannot be used to select text in the Command window under Windows
    2000 or XP.  The workaround is to type {cmd:set cmdtitle off}.  Doing this
    makes the mouse work but causes the window title to disappear, meaning
    moving the window or changing its font is impossible.  Typing
    {cmd:set cmdtitle on} will bring back the title bar along with the mouse
    problem.

{p 6 6 2}
    We are working on a permanent, more elegant fix.  For more information,
    see {browse "http://www.stata.com/support/faqs/win/clickcommand.html"}.


{hline 5} {hi:update 17oct2001} {hline}

{p 2 6 2}
1.  {help bitest}, {help prtest}, {help ttest}, and {help sdtest} now allow
    {cmd:==} to be used wherever {cmd:=} is allowed in their syntax.  The use
    of {cmd:==} in these commands is more consistent with Stata's general
    syntax that treats {cmd:==} as indicating comparison and {cmd:=} as
    meaning assignment.

{p 2 6 2}
2.  {help cc} and {help cci} would not show part of the results when the
    {cmd:exact} option was combined with the {cmd:cornfield}, {cmd:woolf}, or
    {cmd:tb} options.  This is fixed.

{p 2 6 2}
3.  {help testnl} could, on the rare occasion that the derivative with respect
    to a coefficient is nearly zero, try to post a missing value to {hi:e(b)}.
    This is fixed, and a warning message is displayed instead.

{p 2 6 2}
4.  {help xtgls} reported too large of an average number of observations per
    group in the header of its output; this is fixed.


{hline 5} {hi:update 12oct2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  In the 01oct2001 update, {help quietly} and {help while} could not be used
    on the same command line interactively.  Rather than typing

           . {cmd:quietly while {c -(}}

{p 6 6 2}
you had to type

            . {cmd:quietly {c -(}}
            .    {cmd:while} ...
            . {cmd:{c )-}}

{p 6 6 2}
This is fixed.


{title:Stata executable(*), Mac}

{p 2 6 2}
1.  Under OS X there is a new menu item, {hi:Bring All to Front} in the
    {hi:Window} menu.  This item brings all Stata windows to the front.

{p 2 6 2}
2.  The Enter key on the numeric keypad is now recognized as a carriage
    return.

{p 2 6 2}
3.  When clicking a variable in the Variables window, a space is now output
    before the variable name rather than after.  The 01oct2001 update claimed
    to have fixed this, but did not.

{p 2 6 2}
4.  In OS 10.1, selecting {hi:Minimize} from the {hi:Window} menu after all
    windows had already been minimized resulted in a crash.  This is fixed;
    selecting {hi:Minimize} now restores the Results window.

{p 2 6 2}
5.  Stata now properly uses Internet Config to map nonnative Stata file
    extensions to their appropriate applications.  For example, saving a file
    with the extension .html will set the file's type and creator to your
    default Internet browser.  File extension mappings can be set via the File
    Exchange control panel.

{p 2 6 2}
6.  The original Mac Menu Manager API did not allow "/" in menu titles
    and so Stata changed slashes to backslashes ("\").  The new Menu Manager
    does allow slashes, and so the substituting of backslashes in menu titles
    has been removed.


{title:Stata executable(*), Stata for 64-bit Sun Solaris}

{p 2 6 2}
1.  Stata for 64-bit Sun Solaris has been under beta test.
    Stata for 64-bit Sun Solaris is now in production and fully supported
    as of this update.


{hline 5} {hi:update 01oct2001} {hline}

{title:Ado-files, all platforms}

{p 2 6 2}
1.  {help arima:predict, dyn()} after {cmd:arima} would sometimes claim that
    some missing values of the prediction were produced when in fact the
    predictions were correctly produced.  This is fixed.

{p 2 6 2}
2.  {help xtgls:xtgls, panel(corr)} would fail when the path name for
    temporary files included spaces.  This is fixed.


{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help display}, under rare circumstances, could cause Small Stata to
    crash.  This is fixed.

{p 2 6 2}
2.  {help gr7oneway:graph, oneway box} could cause Stata to crash when the
    variable labels were very long.  This is fixed.

{p 2 6 2}
3.  {help matscore:matrix score}, when the matrix variables had time-series
    operators, could, in extremely rare instances use an incorrect time
    variable.  This could happen if the {help tsset} time variable was changed
    immediately before {cmd:matrix score} and the data were previously
    {cmd:tsset}.  In that case, the previously set time variable would be
    used.  This is fixed.

{p 6 6 2}
    {help mleval} had the same problem and is also fixed.

{p 2 6 2}
4.  The new {help net:net sj} command makes loading files from the new
    {it:{browse "http://www.stata-journal.com/":Stata Journal}}
    easier.  The {it:Journal} begins publication fourth quarter, 2001,
    so {cmd:net sj} does not do anything useful right now.  You can,
    however, experiment with the command using volume 0 issue 0, written
    as 0-0.  "{cmd:net sj 0-0}" shows the files available.
    "{cmd:net sj 0-0 xx0001}" shows a description for the files associated
    with reference number xx0001.  See help {help net}.

{p 6 6 2}
    The command {help net:net stb} is now documented; see help {help net}.
    {cmd:net stb} works similarly to {cmd:net sj}:  Typing "{cmd:net stb 61}"
    shows the contents of STB-61 and typing "{cmd:net stb 61 dm91}" would
    show the software associated with dm91.

{p 2 6 2}
5.  {cmd:translate}, when translating graph files to PostScript
    format, would incorrectly translate characters such as {c a'} and {c a'g}.
    This is fixed.

{p 2 6 2}
6.  The following should have been documented as of the previous, 17sep2001
    executable update:  In rare instances it was possible to shadow the
    definition of an autoloaded subprogram if a program with the same name as
    the subprogram was defined interactively or as an ado-file.  For example,
    if the ado-file {cmd:mymain} defined the subprogram {cmd:mysub} and
    {cmd:mysub} was also defined interactively, then the interactively defined
    version of {cmd:mysub} would be run in all cases, even when called from
    {cmd:mymain}.  This was fixed.


{title:Stata executable(*), Mac}

{p 2 6 2}
1.  When clicking a variable in the Variables window, a space was output
    after the variable name rather than before it.  This is fixed.

{p 2 6 2}
2.  Stata will now attempt to resize and move its windows if the display is
    changed to a smaller screen size.

{p 2 6 2}
3.  {help update:update executable}, after downloading and when presenting
    the final instructions for installing the new executable, would sometimes
    display extra (random) characters when referring to the name of the
    Stata executable.  This is fixed.


{title:Stata executable(*), Unix}

{p 2 6 2}
1.  When clicking a variable in the Variables window, a space was output
    after the variable name rather than before it.  This is fixed.

{p 2 6 2}
2.  {help print}, when printing graph files to a PostScript printer,
    would incorrectly print characters such as {c a'} and
    {c a'g}.  This is fixed.


{hline 5} {hi:update 17sep2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  Stata now runs ado-files 6 to 9 percent faster than previously.

{p 2 6 2}
2.  When copying-and-pasting into the {help edit:data editor}, Stata could
    become confused as to the character used to delimit cells and paste
    everything into a single cell.  This is fixed.

{p 2 6 2}
3.  {help anova} could cause Stata to crash when used with no right-hand-side
    variables.  This is fixed.

{p 2 6 2}
4.  {help syntax}, used in a program to parse user input, did not properly
    recognize abbreviation rules for options when the option name began with
    an underscore.  Rather than capitalization being taken to indicate minimum
    abbreviation length, it was taken literally and so required the user to
    specify the options in uppercase letters.  This is fixed.

{p 2 6 2}
5.  {help checksum:set checksum} is now set {cmd:off} rather than {cmd:on}
    by default.  This change affects how Stata copies files over the
    Internet, including {help update}, {help net}, and any other command used
    with a filename starting with "{cmd:http://}".

{p 6 6 2}
    Previously, Stata determined whether a checksum file existed at the
    site and, if it did, used the contents of that file to verify the
    error-free download of the original file.  To restore the old behavior,
    you can type "{cmd:set checksum on}".

{p 6 6 2}
    We have made the default {cmd:off} because (1) we are not aware of any
    user actually having errors and (2) some sites in Europe use caching to
    save on I/O to America.  The result is that, when we would post a
    new update at www.stata.com, some sites would update their cache for the
    files themselves but not the checksum files and so Stata would be fooled
    into thinking that downloads had an error.
    This made it impossible for some users to update their Stata.


{title:Stata executable(*), Mac}

{p 2 6 2}
6.  Stata for OS X could crash when clicking on the Delete button in the
    data editor.  This is fixed.

{p 2 6 2}
7.  There is now a console version of Stata for OS X.
    For details see {browse "http://www.stata.com/support/osx/#console"}.


{title:Stata executable(*), Unix}

{p 2 6 2}
8.  {help window:window menu append popout sysmenu}, rather than appending
    a new menu to the system menu, mistakenly cleared the system menu
    first.  This is fixed.


{hline 5} {hi:update 06sep2001} {hline}

{p 2 6 2}
1.  {help mfx} now respects the version of the calling program when it
    generates its predictions.

{p 2 6 2}
2.  The regression diagnostic commands {help acprplot},
    {help cprplot}, {help hettest}, {help lvr2plot}, {help ovtest},
    {help rvfplot}, and {help rvpplot} have been extended to work after
    {help anova}.

{p 2 6 2}
3.  {help savedresults:savedresults drop} would produce an error message and
    fail to operate; this is fixed.

{p 2 6 2}
4.  {help vif} would occasionally fail to provide output for all applicable
    variables when some of the variables had been dropped from the model due
    to collinearity; this is fixed.


{hline 5} {hi:update 24aug2001} {hline}

{p 2 6 2}
1.  On-line help and search index brought up to date for STB Reprints Vol. 10.
    Stata related FAQs found at {browse "http://www.ats.ucla.edu/stat/stata/"}
    have also been added to the search index.

{p 2 6 2}
2.  {help findit} now allows the word "for" to be included among the search
    words.

{p 2 6 2}
3.  {help ksm} now allows the {help gr7other:by()} option of {help graph}.

{p 2 6 2}
4.  {help xtregar} would not report results when the time-variable was
    included in the regression and the {cmd:lbi} option was specified.
    {cmd:xtregar} now explicitly prohibits the inclusion of the time-variable
    in the regression.


{hline 5} {hi:update 14aug2001} {hline}

{p 2 6 2}
1.  {help bs}, used with certain user-supplied commands, would sample from the
    entire data set even when some of the observations were not originally
    used.  Now {cmd:bs} checks if the user-supplied command is e-class and, in
    that case, resamples only the observations within the estimation
    subsample and, for other commands, {cmd:bs} displays a warning message.

{p 2 6 2}
2.  {help gompertz} and {help stphtest} underwent slight output format
    corrections.

{p 2 6 2}
3.  {help jknife}, when used on an e-class command, now excludes observations
    not in {cmd:e(sample)} from the leave-one-out estimators.

{p 2 6 2}
4.  {help nlogit} reported an "unbalanced data" error when the values of the
    {cmd:group()} variable exceeded float precision.  This has been fixed.

{p 2 6 2}
5.  {help xtnbreg:predict, nu0} and {help xtnbreg:predict, iru0} used after
    {help xtnbreg} has been corrected to account for the estimated dispersion
    parameters.


{hline 5} {hi:update 08aug2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help insheet} has new {cmd:delimiter("}{it:char}{cmd:")} option that
    allows you to specify an arbitrary character that separates values; see
    help {help insheet}.

{p 2 6 2}
2.  {help gr7hist:graph, histogram} has a new {cmd:percent} option for placing
    percentages on the vertical axis; see help {help gr7hist}.

{p 2 6 2}
3.  {help update} now saves in {cmd:r()} various information for use by
    programs; see help {help update}.

{p 2 6 2}
4.  When drawing graphs, it was possible for differing line thicknesses of
    different pens not to be noticed if the color did not also change; this is
    fixed.

{p 2 6 2}
5.  {help args:args x "a"} (note the incorrect double quotes), in addition
    to producing the appropriate error message, would cause a memory leak
    so that the user eventually also saw the error message "out of memory"
    and was thus forced to exit and restart Stata.

{p 2 6 2}
6.  (Windows)
    {help log:log using} with a UNC name (that is,
    \\{it:computername}\{it:path}) would prefix the UNC name with the current
    directory and then refuse to open the file.  This is fixed.

{p 2 6 2}
7.  (Unix) Whenever the print dialog was invoked, there was the possibility
    of a small memory leak, although the problem was never observed.
    It is fixed.

{p 2 6 2}
8.  (Mac) Stata now supports Mac OS X.


{hline 5} {hi:update 30jul2001} {hline}

{p 2 6 2}
1.  {help arch:predict} after estimation by {cmd:arch} with the option
    {cmd:archmexp()} issued an error message and would not produce
    predictions; this has been fixed.


{hline 5} {hi:update 23jul2001} {hline}

{p 2 6 2}
1.  {help glm} would give a syntax error when both the {cmd:trace} and
    {cmd:irls} options were specified.  Also, the {cmd:eform} option was
    ignored for some {cmd:family()} specifications.  These problems have been
    fixed.

{p 2 6 2}
2.  {help lookfor} now returns the list of matching variables in
    {hi:r(varlist)}.

{p 2 6 2}
3.  {help reg3} with the {cmd:constraints()} option did not set e(sample);
    this has been fixed.

{p 2 6 2}
4.  {help xtgee} and {help xtlogit} have a new {cmd:nodisplay} option that
    suppresses the header and table of coefficients.


{hline 5} {hi:update 17jul2001} {hline}

{p 2 6 2}
1.  {help binreg} now respects the {cmd:init()} option.

{p 2 6 2}
2.  {help findit} is a new command that finds and lists sources of
    information on Stata and Stata commands already installed on your computer
    or available on the web.  {cmd:findit} is Stata's most thorough, most
    complete search command.  The results include (1) official help-files
    installed on your computer, (2) FAQs available at the Stata website, (3)
    material published in the STB and the Stata Journal, and (4) user-written
    programs and help files available over the web.

{p 2 6 2}
3.  {help reshape:reshape long} could produce incorrect results when (1)
    variable names for the {cmd:j()} identifier were longer than 8 characters,
    (2) the {cmd:j()} identifiers were string variables ({cmd:string} option
    specified), and (3) you were converting the data from wide to long.  This
    is fixed.

{p 2 6 2} 4.  {help sampsi} now includes both tails when calculating power for
a two-sided test.

{p 2 6 2}
5.  {help svyintreg} followed by {cmd:predict} with the {cmd:pr()} or
    {cmd:e()} options now labels the generated variable in the same way as
    is done by {cmd:predict} after {help intreg}.


{hline 5} {hi:update 03jul2001} {hline}

{p 2 6 2}
1.  {help areg} with robust variance calculations could produce a nonpositive
    definite variance matrix.  This is not an error, but sometimes {cmd:areg}
    would stop and produce an error message instead of posting the estimates.
    This has been fixed.

{p 2 6 2}
2.  {help ivreg} with the {cmd:noconstant} and {cmd:first} options would
    display first-stage results which included _cons; this is fixed.  Note:
    there were NO errors in the final results presented by {cmd:ivreg}.

{p 2 6 2}
3.  {help xi} now uses natural numeric coding in more cases when creating
    variable names.  Previously, if the variable had values larger than 99,
    {cmd:xi} would create its own coding to shorten the created variable
    names.  Longer variable names make this no longer necessary.


{hline 5} {hi:update 26jun2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help gettoken} sometimes presented an odd error message; the text of the
    message is improved.

{p 2 6 2}
2.  {help graph:graph using}, when combining multiple graphs into one,
    could sometimes use the symbol from the first graph in subsequent
    graphs (it could do this when, in the subsequent graphs, the symbol was
    supposed to be invisible); this is fixed.

{p 2 6 2}
3.  {help mlogit}, if it ever had the error "no room to add more variables"
    or "system limit exceeded", would continue to repeat that error until
    another estimation command was run.

{p 2 6 2}
4.  {help regress} will no longer allow the {cmd:beta} and {cmd:cluster()}
    options to be combined.

{p 2 6 2}
5.  {cmd:translate} could sometimes fail to read Stata graph
    (.gph) files if they were very large; this is fixed.

{p 2 6 2}
6.  In the {help viewer}, one of the {help net} clickables would issue a
    syntax error if you clicked on it (because a comma was omitted); that
    is fixed.

{p 2 6 2}
7.  (Mac) Internal changes have been made to {help update} to accommodate
     the forthcoming Mac OS X version of Stata (which will be available
     as a free update).


{hline 5} {hi:update 21jun2001} {hline}

{p 2 6 2}
1.  On-line help and search index brought up to date for STB-61.


{hline 5} {hi:update 11jun2001} {hline}

{p 2 6 2}
1.  {help icd9} and {help icd9p} have been updated to use the V18 codes; V16
    codes were previously used.  V16 and V18 codes have been merged so that
    {cmd:icd9} and {cmd:icd9p} work equally well with old and new datasets.
    See help icd9 for a description of {cmd:icd9} and {cmd:icd9p}; type
    "{stata icd9 query}" and "{stata icd9p query}" for a complete description
    of the changes to the codes used.


{hline 5} {hi:update 04jun2001} {hline}

{p 2 6 2}
1.  {help boxcox} now accepts iweights.

{p 2 6 2}
2.  {help boxcox} with the {cmd:lrtest} option now correctly reports the sigma
    from the unconstrained model.  Previously, {cmd:boxcox} would report the
    sigma from the last constrained model estimated.

{p 2 6 2}
3.  {help egen}'s {cmd:cut()} function could, on rare occasions, produce
    inappropriate missing values due to the loss of precision from using
    local macros instead of scalars for the cut points; this is fixed.

{p 2 6 2}
4.  {help egen}'s {cmd:diff(}{it:varlist}{cmd:)} function failed when the
    {it:varlist} was over 75 characters long.  The failure resulted from
    attempting to apply a variable label that was too long.  Now, if
    {it:varlist} is over 75 characters, no variable label is applied.

{p 2 6 2}
5.  {help for} is now "version transparent".
    Previously, if you typed "{cmd:for} ...{cmd::} {it:cmd} ...", {it:cmd}
    would be executed as if you had first typed "{help version:version 6}".
    If {it:cmd} behaved differently under version 6 rather than version 7,
    {cmd:for} would execute the version-6 version of {it:cmd}.  This is fixed.
    Now {it:cmd} is executed according to whatever version you have set, just
    as you would expect.

{p 2 6 2}
6.  {help glm:glm, jknife cluster()} now works with weights.

{p 2 6 2}
7.  {help reg3} with option {cmd:ireg3} and {help sureg} with option
    {cmd:isure} now display the message "convergence not achieved" if the
    specified or maximum number of iterations is exceeded.  Also, to be
    consistent with {help ml}, the default number of iterations when
    {cmd:ireg3} or {cmd:isure} are specified has been increased to 16,000.

{p 2 6 2}
8.  {help statsby} called with an empty expression list now gives a more
    informative error message.

{p 2 6 2}
9.  {help table} would produce a syntax error for some valid {cmd:contents()}
    option specifications; this is fixed.


{hline 5} {hi:update 08may2001} {hline}

{title:Ado-files, all platforms}

{p 2 6 2}
1.  {help egen} functions called using {cmd:_all} as the {it:varlist} would
    include an unanticipated temporary variable among the variables; this is
    fixed.

{p 2 6 2}
2.  {help print} issued an error if {it:filename} had spaces in it; this is
    fixed.

{p 2 6 2}
3.  The {help xi} update of 13apr2001 would produce an error message when
    executed after the user had manually deleted some variables created using
    previous versions of {cmd:xi}; this is fixed.


{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help file} is a new command that allows programmers to read and write
    both ASCII text and binary files; see help {help file}.  In addition, two
    new regular functions and one new macro-extended function were added for
    use when reading and writing binary files.

{p 6 6 2}
New numeric function
    {help function:byteorder()} returns 1 or 2 depending on whether the
    computer writes the most or least significant byte first.

{p 6 6 2}
New string
    function {help function:char({it:#})} returns the ASCII character
    corresponding to numeric code {it:#}, 0<{it:#}<256.

{p 6 6 2}
New extended macro
    function {help macro:length} returns the length in characters of a local
    or global macro.

{p 6 6 2}
Use of all of these new functions is described in
    help {help file}, although the new {cmd:length} extended function is
    useful in other contexts, too.

{p 2 6 2}
2.  {help list} and {help correlate} now respect {help log:linesize}.
    {cmd:list} also has new option {cmd:noheader}.

{p 2 6 2}
3.  Under certain circumstances, concatenating strings using the plus
    operator (for example, {cmd:display stra+strb}, or
    {cmd:gen str80 newstr = stra+strb})
    when length(stra)+length(strb)>80, could produce unanticipated output and
    even cause Stata to crash.  This is fixed.


{hline 5} {hi:update 23apr2001} {hline}

{p 2 6 2}
1.  {help mfx} produced incorrect answers when used after {help ologit} or
    {help oprobit} and one or more of the independent variable names contained
    underscores.  The problem only arose when one or more of the variable
    names contained underscores.  The problem is fixed.

{p 2 6 2}
2.  {help mvdecode}'s {cmd:mv()} option now allows a {help numlist}.
    In addition, certain English grammar errors were fixed in the output
    of {cmd:mvdecode} and {cmd:mvencode}.

{p 2 6 2}
3.  {help svymlogit} would produce an error message when the dependent
    variable had a value label and one of the label values had a period in it;
    this is fixed.


{hline 5} {hi:update 13apr2001} {hline}

{p 2 6 2}
1.  {help mfx} will now use {help pweight:pweights} or {help iweight:iweights}
    when calculating the means or medians for the {it:atlist} following an
    estimation command that used pweights or iweights.  Previously, only
    fweights and aweights were supported.

{p 2 6 2}
2.  {help mhodds} would report missing values when large
    {help fweight:fweights} were used; this is fixed.

{p 2 6 2}
3.  {help ranksum} is now faster and has a new option, {cmd:porder}, that
    estimates P(x1>x2).

{p 2 6 2}
4.  {help svylc} would give a conformability error when the data had value
    labels that contained spaces; this is fixed.

{p 2 6 2}
5.  {help xi} now saves in characteristic _dta[__xi__Vars__Prefix__] the
    prefix names for the corresponding variables listed in the characteristic
    _dta[__xi__Vars__To__Drop__].  This may be helpful to programmers.

{p 2 6 2}
6.  {help xtivreg} now reports the first stage regression for {cmd:re} and
    {cmd:be} models when option {cmd:first} is specified and there are
    time-series operators in the {it:varlist}.

{p 2 6 2}
7.  {help xtregar:xtregar, fe} now allows {help aweight:aweights} and
    {help fweight:fweights}.


{hline 5} {hi:update 06apr2001} {hline}

{p 2 6 2}
1.  {help xtivreg} now estimates models that combine the {cmd:first} and
    {cmd:ec2sls} options.

{p 2 6 2}
2.  {cmd:predict} after {help xtivreg} now correctly predicts the individual
    level effects mu_i and the idiosyncratic errors e.

{p 2 6 2}
3.  {help xtlogit} now calculates rho using logistic variance of (_pi^2)/3
    instead of 1.


{hline 5} {hi:update 05apr2001 (29mar2001)} {hline}

{p}
({it}On 05apr2001, an update to the Stata executable dated 29mar2001 was
made available.{rm})

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  Stata now allows setting the size of the scrollback buffer for the Results
    window.  The number may be set between 10,000 and 500,000 bytes using the
    {cmd:set scrollbufsize} command; see help {help scrollbufsize}.
    Previously, the value was fixed at 10,000 bytes.

{p 2 6 2}
2.  Stata also has a new {cmd:set varlabelpos} command that controls the
    positioning of variable labels in the Variables window; see
    {cmd:varlabelpos}.

{p 2 6 2}
3.  The {help smcl} directive {cmd:{c -(}center:}{it:...}{cmd:{c )-}} now also
    allows the syntax {cmd:{c -(}center} {it:#}{cmd::}...{cmd:{c )-}} for
    centering text in a field of width {it:#}.

{p 2 6 2}
4.  {help outfile} has a new {cmd:runtogether} option for use by programmers.

{p 2 6 2}
5.  In all commands, options requiring a string as an argument previously
    required the string contain no more than 512 characters; that limit is
    now 67,784 characters (3,400 Small Stata).  In addition, for such options,
    specifying the option without arguments was previously considered an error
    (return code 198); it no longer is.

{p 2 6 2}
6.  The maximum number of {help window:dialog controls} is increased from 55
    to 85.

{p 2 6 2}
7.  {help gr7twoway:graph, twoway} sometimes failed to display a key at the top
    of a graph when it should have; this is fixed.  In addition, with the
    {cmd:connect(||)} or {cmd:connect(II)} options and symbols other than
    {cmd:symbol(ii)}, {cmd:graph, twoway} would show the first variable in
    the key as if it were connected by straight lines.  That is fixed, too.

{p 2 6 2}
8.  Stata could save an incorrect .gph file.  This only happened with large
    graph files having a particular pattern, and then only when saving the
    file by selecting {hi:File} then {hi:Save Graph}.  Directly using the
    {cmd:saving()} option of {help graph} did not have this problem.  The
    problem is fixed.

{p 2 6 2}
9.  {help translatetext:translate} and {help print} did not align the
    top-right-corner table-drawing character correctly when converting to
    PostScript; this is fixed.

{p 1 6 2}
10. {help _rmcoll} would run out of memory after being issued 40 times with no
    other intervening Stata commands; this is fixed.

{p 1 6 2}
11. {help checksum:Verification of checksums} is now temporarily turned off
    during {help net:net search}.


{title:Stata executable(*), Windows}

{p 2 6 2}
1.  Stata now looks for the environment variable STATATMP in addition to the
    environment variable TEMP for the location of the directory for storage of
    temporary files.  STATATMP takes precedence over TEMP.

{p 2 6 2}
2.  Pressing {hi:Alt-F4} will now close the Graph window if it is in front of
    the Results window rather than closing all of Stata.  If the Results
    window is in front; Stata will close as before.


{title:Stata executable(*), Mac}

{p 2 6 2}
1.  {help net} could cause a crash under rare conditions; this is fixed.

{p 2 6 2}
2.  Graph output settings have been modified to work better with MS Word.


{title:Stata executable(*), Unix}

{p 2 6 2}
1.  Stata now looks for the environment variable STATATMP in addition to the
    environment variable TMPDIR for the location of the directory for storage
    of temporary files.  STATATMP takes precedence over TMPDIR.

{p 2 6 2}
2.  Stata would not properly initialize the line width for the Result window
    until after it was manually resized; this is fixed.

{p 2 6 2}
3.  Stata would enter an endless loop if a checkbox in a programmable
    {help window:dialog box} was checked; this is fixed.


{hline 5} {hi:update 28mar2001} {hline}

{p 2 6 2}
1.  On-line help and search index brought up to date for STB-60.

{p 2 6 2}
2.  {help jknife} and {help statsby} displayed correct results (and
    generated the correct variables), but did so in a nonintuitive order
    when _b or _se with multiple entries were specified in the {it:exp_list}.
    This has been fixed.

{p 2 6 2}
3.  {help kdensity} now returns results in {hi:r()} even when the
    {cmd:nograph} option is specified and the {cmd:generate()} option is not.

{p 2 6 2}
4.  {help sample} now gives a more informative error message when the
    requested sample percent is outside the range of 0 to 100.

{p 2 6 2}
5.  {help xpose} has three new options:  {cmd:format} and
    {cmd:format(%}{it:fmt}{cmd:)} (which are mutually exclusive) and
    {cmd:promote}.  The {cmd:format} option finds the largest numeric display
    format in the pre-{cmd:xposed} data and applies it to the {cmd:xposed}
    data.  The {cmd:format(%}{it:fmt}{cmd:)} option sets the {cmd:xposed}
    data to the specified format.  The {cmd:promote} option causes the
    transposed data to have the most compact numeric
    {help datatypes:data type} that preserves the original data accuracy.

{p 2 6 2}
6.  {help xtintreg} would report an error when used without predictors;
    this is fixed.


{hline 5} {hi:update 09mar2001} {hline}

{p 2 6 2}
1.  {help aorder}, used with long variable names (longer than 8 characters),
    would sometimes refuse to order the variables and instead issue the error
    "system limit exceeded"; r(1000).  This is fixed.

{p 2 6 2}
2.  {help mfx:mfx, predict()}, with two or more arguments specified in the
    {cmd:predict()} option, would ignore the second and subsequent
    arguments; this is fixed.

{p 2 6 2}
3.  {help stci} sometimes reported percentiles as the next ordered survival
    time when the desired fraction exactly equaled the empirically observed
    fraction.  This would be similar to saying the median of (1,2,5,7,9) is 7
    rather than 5.  {cmd:stci} rarely made this mistake; this
    problem is fixed.

{p 2 6 2}
4.  {help xtgee:xtgee, family(binomial) link(logit)} refused to estimate models
    containing perfect predictors; it now attempts to estimate such models
    (producing very large or very small coefficients on the offending
    variables).

{p 2 6 2}
5.  {help xtregar} now estimates a rho-adjusted constant and {cmd:predict} after
    {cmd:xtregar} has been fixed to produce the correct u_i and residuals.

{p 2 6 2}
6.  {help xttobit} and {help xtintreg} have new {cmd:predict} options.  Option
    {cmd:pr0(}{it:a}{cmd:,}{it:b}{cmd:)} produces the probability of the
    dependent variable being uncensored {hline 2} Pr(a<y<b).  Option
    {cmd:e0(}{it:a}{cmd:,}{it:b}{cmd:)} produces the expected value of the
    dependent variable conditional on censoring {hline 2} E(y | a<y<b).  Option
    {cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} produces the expected value of the
    dependent variable truncated at the censoring point(s) {hline 2} E(y*),
    y* = max(a,min(y,b)).


{hline 5} {hi:update 01mar2001} {hline}

{p 2 6 2}
1.  {help ltable} ignored the {cmd:xlabel()} and {cmd:ylabel()} graphing
    options; this is fixed.

{p 2 6 2}
2.  {help mvreg:predict, residuals eq()} used after {help mvreg} calculated
    -X*b rather than y-X*b; this is fixed.


{hline 5} {hi:update 26feb2001} {hline}

{p 2 6 2}
1.  {help glm:glm, family(gaussian)} with the {cmd:offset()} option gave
    incorrect standard errors; this is fixed.

{p 2 6 2}
2.  {help rreg:predict, residuals} used after {help rreg} produced the message
    "invalid syntax", r(198), rather than predicting the residuals; this is
    fixed.

{p 2 6 2}
3.  {help rreg:predict} used after {help rreg} no longer produces predictions
    for options {cmd:stdf}, {cmd:stdr}, {cmd:cooksd}, {cmd:rstandard}, and
    {cmd:rstudent}.  These are options for linear models that are not strictly
    appropriate for the estimates produced by {cmd:rreg}.

{p 2 6 2}
4.  {help sample} has a new {cmd:count} option that allows samples of the
    specified number of observations (rather than percent) be drawn.  In
    addition, {cmd:sample} now allows the {cmd:by} {it:varlist}{cmd::} prefix
    as an alternative to the already existing {cmd:by(}{it:varlist}{cmd:)}
    option; both do the same thing.

{p 2 6 2}
5.  {help xtpcse} when specified without covariates -- a constant only model --
    reported "last test not found", r(302), and refused to estimate the model.
    {cmd:xtpcse} will now estimate the constant-only model.


{hline 5} {hi:update 19feb2001} {hline}

{p 2 6 2}
1.  {help cltree:cluster dendrogram} would not read the (dis)similarity range
    information in the rare case when an additional "other" field was set
    after the range; this is fixed.

{p 2 6 2}
2.  {help glogit} used {help datatypes:long} integers for the number of
    successes and failures.  This caused a loss of precision with extremely
    large populations.  Now {cmd:glogit} uses {help datatypes:double}s.

{p 2 6 2}
3.  {help reg3} would sometimes produce a spurious message concerning missing
    values being generated; this is fixed.

{p 2 6 2}
4.  {help sample}, used after {help generate:set seed}, did not always reproduce
    the same (pseudo) random sample (the sample, in all cases, was random);
    the problem is fixed.  For additional details, see the technical note at
    the end of help {help sample}.


{hline 5} {hi:update 06feb2001} {hline}

{p 2 6 2}
1.  On-line help and search index brought up to date for STB-59.

{p 2 6 2}
2.  {help poisgof} has a new option, {cmd:pearson}, to request the Pearson
    chi-square statistic.

{p 2 6 2}
3.  {help alpha} with the {cmd:item} option would display the negative estimate
    when a negative estimate was computed; it now displays missing value.
    As previously, {cmd:alpha} still returns in matrix {cmd:r(Alpha)} results
    when option {cmd:item} is specified.  Because Stata matrices cannot
    contain missing values, the value 1e+30 is returned in {cmd:r(Alpha)} to
    indicate missing.

{p 6 6 2}
    In addition, {cmd:alpha}'s {cmd:generate()} option would label the new
    variable as standardized even when it was not; this is fixed.

{p 6 6 2}
    Finally, the 17jan2001 update of {cmd:alpha} caused the {cmd:reverse()}
    option to display an uninformative message and then ignore that
    {cmd:reverse()} had been specified; this is fixed.

{p 2 6 2}
4.  {help strate} now drops temporary variables when a {hi:break} is pressed.


{hline 5} {hi:update 05feb2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help forvalues:forvalues x = 1(.2)2} ({cmd:forvalues} with noninteger
    increment) now works properly with {help format:set dp comma}.

{p 2 6 2}
2.  {help graph:graph, by()} had difficulty (could actually crash) when the
    {cmd:by()} variable had value labels and the value labels exceeded 32
    characters.  This is fixed.

{p 2 6 2}
3.  {help graph} no longer by default constructs keys for Hi-Lo charts
    ({cmd:connect(||)} and {cmd:connect(II)}).

{p 2 6 2}
4.  {help insheet} under version control ({help version} set to 6 or earlier)
    now reproduces the naming behavior of earlier versions of Stata.  When
    {cmd:version} is set to 6 or earlier, only the first 8 characters of the
    names are considered.

{p 2 6 2}
5.  Matrix expressions (for example,
    {help matrix:matrix {it:name} = {it:expression}})
    that include the function {cmd:nullmat()} could cause
    unnecessary memory to be consumed, which memory would not be freed until
    Stata was exited.  This is fixed.

{p 2 6 2}
6.  stata.toc files (the files read by {help net} from remote websites) now
    allow 150 links to be listed rather than 100.


{hline 5} {hi:update 29jan2001} {hline}

{p 2 6 2}
1.  {help glm} with a user specified link ignored the {cmd:eform} option.
    This is fixed.

{p 2 6 2}
2.  {help mfx} treated dummy variables containing missing values as continuous.
    In addition, under certain circumstances when one variable name was a
    proper subset of another, {cmd:mfx} would not report results for both
    variables.  These problems are fixed.

{p 2 6 2}
3.  {help stptime}, {help strate}, and {help statsby} failed if the computer's
    temporary directory name contained spaces (typical on many Mac
    computers).  This is fixed.

{p 2 6 2}
4.  {help stptime} ignored the {cmd:jackknife} option.  This is fixed.

{p 2 6 2}
5.  {help tabstat} with the {cmd:variance} option failed.  This is fixed.

{p 2 6 2}
6.  {help xi} would fail when specified with an interaction term containing a
    variable with a name of length one.  This is fixed.


{hline 5} {hi:update 23jan2001} {hline}

{title:Stata executable(*), all platforms}

{p 2 6 2}
1.  {help label:label values {it:varname lblname}}, under exceedingly rare
    conditions, would not adjust the width of {it:varname}'s %fmt display
    format.  This is fixed.

{p 2 6 2}
2.  {help more:set more off} in a do-file would leave {hline 2}more{hline 2}
    turned off even after the do-file completed.  This is fixed.

{p 2 6 2}
3.  {help log:set linesize {it:#}} will no longer allow setting the linesize to
    {it:#}>255.


{title:Stata executable(*), Windows}

{p 2 6 2}
1.  Stata now properly launches via double-clicking on filenames containing
spaces.

{p 2 6 2}
2.  Colored lines in graphs are now properly copied to the Clipboard under
    Windows 2000/NT (and all other versions of Windows).


{title:Stata executable(*), Mac}

{p 2 6 2}
1.  A number of small bugs in the interface have been fixed including in the
    scrolling-variables window, the do-file editor, etc.  SMCL files now
    appear in the Finder with the appropriate icon and are bound with
    double-quotes when opened from the Finder.


{hline 5} {hi:update 17jan2001} {hline}

{p 2 6 2}
1.  {help alpha} now allocates 12 rather than 8 characters for the display of
    variable names and its output is sensitive to {help log:linesize}.

{p 2 6 2}
2.  {help sts:sts graph} has new option {cmd:lstyle()} which allows specifying
    the style of the connected line.  For instance,
    "{cmd:sts graph, by(drug) lstyle([l] [-] [-.])}" would graph the
    Kaplan-Meier survivor function for each drug, using a solid line
    ({cmd:[l]}) to connect the curve for the first drug, a dashed line
    ({cmd:[-]}) for the second, and dash-dotted line
    ({cmd:[-.]}) for the third.

{p 2 6 2}
3.  {help stsplit}, the text of certain error messages has been improved.

{p 2 6 2}
4.  {help tabstat} has new option {cmd:varwidth(}{it:#}{cmd:)} specifying the
    number of characters used to display variable names.  In addition, the new
    options {cmd:statistics(variance)} and {cmd:statistics(semean)} displays
    the variance and the standard error of the mean.

{p 2 6 2}
5.  {help testnl} now allows typing "{cmd:testnl}
    {it:exp}{cmd:=}{it:exp}{cmd:=}...{cmd:=}{it:exp}" to test whether three
    or more expressions are equal.

{p 2 6 2}
6.  {help xtivreg} refused to estimate between models in which there were more
    parameters than groups; that is fixed.  In addition,
    {cmd:xtivreg} with the {cmd:first} option mislabeled the intercept in the
    display of the first-stage fixed-effects model.  The intercept is now
    correctly labeled {cmd:_cons}.

{p 2 6 2}
7.  {help xtregar:xtregar, fe} refused to estimate models when there was an
    effect that did not vary within group; this is fixed.


{hline 5} {hi:update 11jan2001} {hline}

{p 2 6 2}
1.  {help streg:streg, dist(exponential)} and {help ereg} did not honor
    standard maximization options such as {cmd:iterate(}{it:#}{cmd:)},
    {cmd:nolog}, etc.; see help {help maximize}.  This is fixed.

{p 2 6 2}
2.  {help streg:streg, dist(weibull) ancillary({it:varname})} did not show
    the coefficients of the ancillary equation even though the model was
    correctly estimated.  This is fixed.

{p 2 6 2}
3.  {help joinby} now accepts filenames with embedded spaces, assuming such
    filenames are enclosed in double quotes.


{hline 5} {hi:update 08jan2001} {hline}

{p 2 6 2}
1.  {help gphprint} (a Stata 6 command that did something similar to
    {help print}) would issue the error "logo() invalid" when translating to
    the Windows Metafile format or the Mac PICT format.  This is fixed.

{p 2 6 2}
2.  {help notes} now allows the individual notes to include {help smcl:SMCL}
    directives.


{hline 5} {hi:previous updates} {hline}

{pstd}
See help {help whatsnew6to7}.{p_end}

{hline}
