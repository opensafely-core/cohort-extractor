{smcl}
{* *! version 1.4.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 10.0 (compared with release 9)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 10.0:

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
    {c |} {bf:this file}        Stata 10.0 new release       2007            {c |}
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


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew10}.


{hline 3} {hi:Stata 10.0 release 25jun2007} {hline}

{title:Remarks}

{pstd}
We will list all the changes, item by item, but first, here are the
highlights:

{phang2}
1.  Stata 10 has an interactive, point-and-click editor for your graphs.
    You do not need to type anything; you just right-click within the Graph
    window and select {bf:Start Graph Editor}.
    You can do that any time, either when the graph is drawn or when you have
    {cmd:graph} {cmd:use}d it from disk.
    You can add text, lines, markers, titles, and annotations, outside the
    plot region or inside; you can move axes, titles, legends, etc.; you can
    change colors and sizes, number of tick marks, etc.; and you can even change
    scatters to lines or bars, or vice versa.
    See {manhelp graph_editor G-1:graph editor}.

{phang2}
2.  You can now save estimation results to disk.  After fitting a model, 
    whether with {cmd:regress}, {cmd:logistic}, ..., or even a 
    user-written command, you type {cmd:estimates} {cmd:save} {it:filename}
    to save it.  You type {cmd:estimates} {cmd:use} {it:filename} to reload 
    it later.  See {manhelp estimates R}.

{phang2}
3.  Stata now fits nested, hierarchical, and mixed models with binary and
    count responses; that is, you can fit logistic and Poisson models
    with complex, nested error components.  See {manhelp xtmelogit XT}
    and {manhelp xtmepoisson XT}.

{phang2}
4.  Stata now has exact logistic and exact Poisson regression.  
    In small samples, exact methods have better coverage than asymptotic
    methods, and exact methods are the only way to obtain point estimates,
    tests, and confidence intervals from covariates that perfectly predict the
    observed outcome.
    See {manhelp exlogistic R} and {manhelp expoisson R}.

{phang2}
5.  Stata now supports LIML and GMM estimation in addition to
    2SLS.  Tests of instrumental relevance and tests of
    overidentifying restrictions are available.  See {manhelp ivregress R} and
    {manhelp ivregress_postestimation R:ivregress postestimation}.

{phang2}
6.  Stata now has more estimators for dynamic panel-data models, including the
    Arellano-Bover/Blundell-Bond system estimator.  This
    estimator is an extension of the Arellano-Bond GMM
    estimator for dynamic panel models.  It is more efficient and has smaller
    bias when the AR process is too persistent.  These new estimators
    can also be used to fit models with serially correlated idiosyncratic
    errors and where the structure of the predetermined variables is
    complicated.  These new estimators can compute the Windmeijer
    biased-corrected two-step robust VCE in addition to the standard
    one-step i.i.d., one-step robust, and two-step i.i.d. VCEs.  See
    {manhelp xtabond XT}, {manhelp xtdpdsys XT}, and {manhelp xtdpd XT}.

{phang2}
7.  New estimation command {cmd:nlsur} fits a system of nonlinear equations by
    feasible generalized least squares, allowing for covariances among the
    equations.  See {manhelp nlsur R}.

{phang2}
8.  Stata has new estimation commands for fitting categorical and ranked
    outcomes, often used for choice models.  The new commands allow separate
    equations for each outcome and support the easy-to-use
    alternative-specific notation.  Joining Stata's alternative-specific
    multinomial probit are alternative-specific conditional logit (McFadden's
    choice model) and alternative-specific rank-ordered probit (for modeling
    ordered outcomes).  See {manhelp asclogit R} and {manhelp asroprobit R}.

{phang2}
9.  Stata's {cmd:svy:} prefix now works with 48 estimators, 27 more
    than previously.  Most importantly, {cmd:svy:} now works with
    Cox proportional-hazards regression models ({cmd:stcox}) 
    and parametric survival models ({cmd:streg}).  See 
    {manhelp svy_estimation SVY:svy estimation}.

{p 7 12 2}
10.  The new {cmd:stpower} command provides sample-size and power calculations
    for survival studies that use Cox proportional-hazards regressions,
    log-rank tests for two groups, or 
    differences in exponentially distributed hazards or log hazards.
    Available are (1) required sample size (given power), (2) power (given
    sample size), and (3) the minimal detectable effect (given power and sample
    size).  {cmd:stpower} allows automated production of customizable tables
    and has options to assist with creating graphs and power curves.
    See {manhelp stpower ST}.

{p 7 12 2}
11.  Stata 10 provides several discriminant analysis techniques, including 
    linear discriminant analysis (LDA), 
    quadratic discriminant analysis (QDA), 
    logistic discriminant analysis, 
    and {it:k}th-nearest-neighbor (KNN) discrimination.
    See {manhelp discrim MV}.

{p 7 12 2}
12.  Stata now provides multiple correspondence analysis (MCA)
    and joint correspondence analysis (JCA).
    See {manhelp mca MV}.

{p 7 12 2}
13.  Stata now provides 
    modern as well as classical multidimensional scaling (MDS), 
    including metric and nonmetric MDS.
    Available loss functions include stress, normalized stress, 
    squared stress, normalized squared stress, and Sammon.  Available 
    transformations include identity, power, and monotonic.
    See {manhelp mds MV}.

{p 7 12 2}
14.  Stata 10 has time/date variables in addition to date variables, so now
    you can work with data that say an event happened on 12may2007
    14:03:22.234 or events that happen every day at 14:03:22.234.  Note the
    millisecond resolution.  Time variables are available in two forms:
    adjusted for leap seconds and unadjusted.  See 
    {help datetime:[D] datetime}.

{p 7 12 2}
15.  New Mata function {cmd:optimize()} performs minimization and maximization.
    You can code just the function, the function and its first derivatives, 
    or the function and its first and second derivatives.  Optimization
    techniques include Newton-Raphson,
    Davidon-Fletcher-Powell,
    Broyden-Fletch-Goldfarb-Shanno,
    Berndt-Hall-Hall-Hausman, and the simplex
    method Nelder-Mead.  See {helpb mf_optimize:[M-5] optimize()}.

{p 7 12 2}
16.  Stata's online help now provides saved results and examples that you 
    can run.

{p 7 12 2}
17.  Stata for Windows now supports Automation, formerly known as 
    OLE Automation, which means that programmers can control Stata from
    other applications and retrieve results.  See {manhelp automation P}.

{p 7 12 2}
18.  Stata for Unix now supports unixODBC [{it:sic}], making it easier
    to connect to databases such as Oracle, MySQL, and
    PostgreSQL; see {manhelp odbc D}.

{pstd}
Another change is the introduction of Stata/MP, but that really
happened during Stata 9.  Stata/MP is the parallel version of Stata
for multiple-CPU and multicore computers; see
{help flavors}.
Stata/MP runs faster.  In Stata 10, many more
commands now exploit the multiple processors, which means that they run faster,
too.  This includes both survey and nonsurvey mean, total, ratio, and
proportion estimators and the survey linearized variance estimator, which is
available with many Stata estimation commands.

{pstd}
There is much more, and the important changes for you may not be 
what we list as highlights.  Below are the details.

{pstd}
What's new is presented under the following headings:

            {help whatsnew9to10##interface:What's new in the GUI and command interface}
	    {help whatsnew9to10##data:What's new in data management}
	    {help whatsnew9to10##general:What's new in statistics (general)}
	    {help whatsnew9to10##paneldata:What's new in statistics (longitudinal/panel data)}
	    {help whatsnew9to10##timeseries:What's new in statistics (time series)}
	    {help whatsnew9to10##survey:What's new in statistics (survey)}
	    {help whatsnew9to10##survival:What's new in statistics (survival analysis)}
	    {help whatsnew9to10##multivariate:What's new in statistics (multivariate)}
	    {help whatsnew9to10##graphics:What's new in graphics}
	    {help whatsnew9to10##programming:What's new in programming}
	    {help whatsnew9to10##mata:What's new in Mata}


{marker interface}{...}
{title:What's new in the GUI and command interface}

{phang2}
1.  The Review window has been redesigned.  It now
    shows the return code of each previous command and highlights errors.
    From the window, you can now select multiple commands -- not
    just single ones -- to save or execute.  

{phang2}
2.  The Variables window has been redesigned.
    It nows shows the storage type and display format for each variable 
    in addition to the variable's name and label.
    You can change any of these from the window, including the name; 
    just right-click.

{phang2}
3.  Stata's Viewer has been redesigned.
    In addition to an all-new look, it has a {bf:Forward} button and the search 
    capability is now built in rather than provided by a dialog box.

{phang2}
4.  The Graph window has been redesigned.  In addition to 
    providing an interactive editor, under Windows, it now allows tabs.  You
    can have either one window containing multiple graphs each on its 
    own tab, or you can have each graph in a separate window.

{phang2}
5.  You can copy and paste from Stata's Results and Viewer windows 
    in AS-IS mode, meaning that you can include Stata output in
    documents and slides looking exactly as it looked on your screen.

{phang2}
6.  Multiple Do-file Editors can now be opened simultaneously; just click on
    the files in the Open dialog.  (Unix users: You too can now open multiple
    Do-file Editors.)

{phang2}
7.  Concerning dialogs, 

{p 12 16 2}
a.  Stata now uses child dialogs, making dialogs for Stata commands easier
        to use.

{p 12 16 2}
b.  Programmers can program child dialogs, too; see
	{helpb dialog_programming:[P] dialog programming}.

{p 12 16 2}
c.  Graph dialogs have an all-new look that makes specifying the
	most important items and options easier, yet provides access to even
	more of {cmd:graph}'s capabilities.

{p 12 16 2}
d.  Dialogs that need matrices now allow the user to create the matrix via
        a matrix-input child dialog and to show that new matrix in the original
        dialog box after it has been created.

{p 12 16 2}
e.  Dialogs that need formats now allow the user to specify the 
        format via a format builder.

{p 12 16 2}
f.  Data from ODBC sources can now be accessed via a dialog.

{p 12 16 2}
g.  Dialogs now scale with Microsoft Windows' DPI settings.

{p 12 16 2}
h.  Dialogs now load faster.

{phang2}
8.  Stata for Unix has an all new, more modern GUI.

{phang2}
9.  Stata now executes {cmd:sysprofile.do}, if it exists, in addition to
    {cmd:profile.do} when Stata is launched.  This allows system
    administrators to provide global customization.  See
    {hi:[GS] Appendix A: More on starting and exiting Stata}.

{p 7 12 2}
10.  New command {cmd:adoupdate} automates the process of updating user-written
    ado-files; see {manhelp adoupdate R}.

{p 7 12 2}
11.  New command {cmd:hsearch} searches the help files for specified words and
    presents a ranked, clickable list in the Viewer; see {manhelp hsearch R}.

{p 7 12 2}
12.  Stata's help files are now named {cmd:*.sthlp} rather than {cmd:*.hlp},
    meaning that user-written help files can be sent via email more easily.
    Many email filters flag {cmd:.hlp} files as potential virus carriers
    because Stata was not the only one to use the {cmd:.hlp} suffix.
    You need not rename your old help
    files.  See {manhelp help R}.

{p 7 12 2}
13.  There are now console versions of Stata/SE and Stata/MP
    for Mac, just as there are for Unix.  They are included on the
    installation CD and installed automatically.

{p 7 12 2}
14.  Stata's {cmd:in} command modifier now accepts {cmd:F} and {cmd:L} as
    synonyms for {cmd:f} and {cmd:l}, meaning first and last observations.

{p 7 12 2}
15.  Multiple log files may be opened simultaneously; see {manhelp log R}.

{p 7 12 2}
16.  Intercooled Stata has been renamed to Stata/IC.


{marker data}{...}
{title:What's new in data management}

{phang2}
1.  Stata 10 has new date/time variables, so you can now record values like
    14jun2007 09:42:41.106 in one variable.  They are called {cmd:%tc}
    and {cmd:%tC} variables.  The first is unadjusted for leap seconds; the
    second is adjusted.

{pmore2}
    What used to be called "daily variables" are now called {cmd:%td}
    variables.  This is just a jargon change; daily ({cmd:%td}) variables
    continue to work as they did before -- 0 means 01jan1960, 1 means
    02jan1960, and so on.

{pmore2}
    {cmd:%tc} and {cmd:%tC} variables work similarly:  0 means 01jan1960
    00:00:00.  Here, however, 1 means 01jan1960 00:00:00.001,
    1000 means 01jan1960 00:00:01.000, and 02jan1960 08:00:00 is 115,200,000.
    The underlying values are big -- so it is important you store them as
    {cmd:double}s -- but the {cmd:%tc} and {cmd:%tC} formats make the values
    readable, just as the {cmd:%td} format makes daily ({cmd:%td}) values
    readable.

{pmore2}
    There are many new functions to go along with this new value type.  
    {cmd:clock()}, for instance, converts strings such as "02jan1960
    08:00:00" (or even "8:00 a.m., 1/2/1960") to their numeric equivalents.
    {cmd:dofc()} converts a {cmd:%tc} value (such as 115,200,000,
    meaning 02jan1960 08:00:00) to its {cmd:%td} equivalent (namely, 1, meaning
    02jan1960).  {cmd:cofd()} does the reverse (the result would
    be 86,400,000, meaning 02jan1960 00:00:00).

{pmore2}
    See {helpb datetime:[D] datetime}.

{phang2}
2.  The previously existing {cmd:date()} function, which converts strings to
    {cmd:%td} values, is now smarter.  In addition to being able to convert
    strings such as "21aug2005", "August 21, 2005", it can convert
    "082105", "08212005", "210805", and "21082005".  See
    {helpb datetime:[D] datetime}.

{phang2}
3.  New command {cmd:datasignature} allows you to sign datasets and later
    use that signature to determine whether the data have changed.  An early
    version of the command was made available during the Stata 9 release.
    That command is now called {cmd:_datasignature} and was used as the
    building block for the new, improved {cmd:datasignature}.   See
    {manhelp datasignature D} and {manhelp _datasignature D}.

{phang2}
4.  Existing command {cmd:clear} now clears data and value labels only.  Type
    {cmd:clear} {cmd:all} to clear everything.  This change will bite you
    the first few times you type {cmd:clear} expecting it to {cmd:clear}
    {cmd:all}.  The problem was that new users were surprised when
    {cmd:clear} by itself cleared everything, whereas {cmd:use}
    {it:filename}{cmd:,} {cmd:clear} loaded new data and value labels but
    left everything else in place.  The new users were right.

{pmore2}
    {cmd:clear} now has the following subcommands:

{p 12 16 2}
a.  {cmd:clear} {cmd:all} clears everything from memory.

{p 12 16 2}
b.  {cmd:clear} {cmd:ado} clears automatically loaded ado-file programs.

{p 12 16 2}
d.  {cmd:clear} {cmd:programs} clears all programs, 
       automatically loaded or not.

{p 12 16 2}
c.  {cmd:clear} {cmd:results} clears saved results.

{p 12 16 2}
d.  {cmd:clear} {cmd:mata} clears Mata functions and objects from memory.

{pmore2}
See {manhelp clear D}.

{phang2}
5.  Stata for Unix now supports unixODBC [{it:sic}], making it easier
    to connect to databases such as 
    Oracle, MySQL, and PostgreSQL; see {manhelp odbc D}.

{phang2}
6.  Existing command {cmd:describe} now allows option {cmd:varlist} that was 
    previously allowed only by {cmd:describe} {cmd:using}.  Existing command
    {cmd:describe} {cmd:using} {it:filename} now allows option {cmd:simple}
    that was previously allowed only by {cmd:describe}.  Option {cmd:varlist}
    saves the variable names in {cmd:r(varlist)}, and option {cmd:simple}
    displays the variable names in a compact format. 
    See {manhelp describe D}.


{phang2}
7.  Existing command {cmd:collapse} now supports four additional {it:stat}s:
    {cmd:first}, the first value; {cmd:last}, the last value; {cmd:firstnm},
    the first nonmissing value; and {cmd:lastnm}, the last nonmissing value.
    See {manhelp collapse D}.

{phang2}
8.  Existing command {cmd:cf} (compare files) now provides a detailed listing
    of observations that differ when the {cmd:verbose} option is
    specified.  
    Setting version to less than 10.0 restores
    the earlier behavior.  See {manhelp cf D}.

{phang2}
9.  Existing command {cmd:codebook} has new option {cmd:compact} that produces
    more compact output.  See {manhelp codebook D}.

{p 7 12 2}
10.  Existing command {cmd:insheet} has new option {cmd:case} that preserves
    the case of variable names when importing data; see
    {manhelp insheet D}.

{p 7 12 2}
11.  Existing command {cmd:outsheet} has new option {cmd:delimiter()} that
    specifies an alternative delimiter; see {manhelp outsheet D}.

{p 7 12 2}
12.  Existing commands {cmd:infile} and {cmd:infix} can now read up to 524,275
    characters per line; the previous limit was 32,765. See {manhelp infile D}
    and {helpb infile2:[D] infix (fixed format)}.

{p 7 12 2}
13.  Existing commands {cmd:icd9} and {cmd:icd9p} have now been updated to use
     the V24 codes; see {manhelp icd9 D}.

{p 7 12 2}
14.  New function {cmd:itrim()} returns the string with 
    consecutive, internal spaces collapsed to one space; see
    {helpb string functions:[FN] String functions}.

{p 7 12 2}
15.  New functions {cmd:lnnormal()} and {cmd:lnnormalden()} provide the natural
    logarithm of the cumulative standard normal distribution and of the
    standard normal density; see
    {helpb stat functions:[FN] Statistical functions}.

{p 7 12 2}
16.  New functions for calculating cumulative densities are now available:

{p2colset 13 38 40 2}{...}
{p2col: {opt binomial(n, k, p)}}lower tail of the Binomial distribution{p_end}
{p2col: {opt ibetatail(a, b, x)}}reverse (upper tail) of the cumulative
                                      Beta distribution{p_end}
{p2col: {opt gammaptail(a, x)}}reverse (upper tail) of the cumulative
                                     Gamma distribution{p_end}
{p2col:  {opt invgammaptail(a, p)}}inverse reverse of the cumulative
                                      Gamma distribution{p_end}
{p2col: {opt invibetatail(a, b, p)}}inverse reverse of the cumulative Beta
                                      distribution{p_end}
{p2col: {opt invbinomialtail(n, k, p)}}inverse of right cumulative
    binomial{p_end}

{pmore2}See
    {helpb stat functions:[FN] Statistical functions}.
    {p2colreset}{...}

{p 7 12 2}
17.  Existing function {opt Binomial(n, k, p)} has been renamed
    {opt binomialtail(n, k, p)}, thus making its name consistent with the
    naming convention for probability functions.  The accuracy of the function
    has also been improved for very large values of {it:n}.  At the other end of
    the number line, the function now returns the appropriate 0 or 1 value
    when {it:n} = 0, rather than returning missing.  {cmd:Binomial()}
    continues to work as a synonym for {cmd:binomialtail()}.

{p 7 12 2}
18.  The behavior and accuracy of the following probability functions have been
    improved:

{p 12 16 2}
a.  {opt F(n_1, n_2, f)} and {opt Ftail(n_1, n_2, f)} are
        more accurate for small values of {it:n_1} and large
        values of {it:n_2}.  Also, {cmd:F()} is more accurate 
        for large {it:f} where {it:n_1} and {it:n_2} are less than 1.

{p 12 16 2}
b.  {opt gammap(a, x)} is more accurate 
        when {it:a} is large and {it:x} is near {it:a}.

{p 12 16 2}
c.  {opt ibeta(a, b, x)} now is more accurate 
        when {it:x} is near {it:a}/({it:a}+{it:b}) and {it:a}
        or {it:b} is large.

{p 12 16 2}
d.  {opt invbinomial(n, k, p)}, {opt invchi2(n, p)},
	{opt invchi2tail(n, p)}, {opt invF(n_1, n_2, p)}, and 
	{opt invgammap(a, p)} are more accurate for small values of p or
        for returned values close to zero.

{p 12 16 2}
e.  {opt invFtail(n_1, n_2, p)} and {opt invibeta(a, b, p)}
	are more accurate for small values of {it:p} or for returned values
	close to zero.

{p 12 16 2}
f.  {opt invttail(n, p)} is more accurate for small
        values of {it:p} or for returned values close to zero.

{p 12 16 2}
g.  {opt ttail(n, t)} is more accurate for exceedingly
        large values of {it:n}.

{p 7 12 2}
19.  Existing function {opt invbinomial(n, k, p)} now returns the
    probability of a success on one trial such that the probability of
    observing {it:k} or fewer successes in {it:n} trials is {it:p}.  The
    previous behavior of {cmd:invbinomial()} is restored under version
    control.

{p 7 12 2}
20.  New function {cmd:fmtwidth()} returns the display width of a
    {cmd:%}{it:fmt} string; see
    {helpb prog functions:[FN] Programming functions}.

{p 7 12 2}
21.  The maximum length of a {cmd:%}{it:fmt} has increased from 12 to 48
    characters; see {manhelp format D}.  (This change was necessitated by the 
    new date/time variables.)

{p 7 12 2}
22.  Existing commands {cmd:corr2data} and {cmd:drawnorm} now allow singular
    correlation (or covariance) structures.  New option {cmd:forcepsd} 
    modifies a matrix to be positive semidefinite and thus to be a proper
    covariance matrix.  See {manhelp corr2data D} and {manhelp drawnorm D}.

{p 7 12 2}
23.  Existing command {cmd:hexdump,} {cmd:analyze} now saves the number of
    {cmd:\r\n} characters in {cmd:r(Windows)} rather than in {cmd:r(DOS)}.
    {cmd:r(DOS)} is still set when version is less than 10.  See
    {manhelp hexdump D}.


{marker general}{...}
{title:What's new in statistics (general)}

{phang2}
1.  As mentioned above, you can now save estimation results to disk.  You type
    {cmd:estimates} {cmd:save} {it:filename} to save results and
    {cmd:estimates} {cmd:use} {it:filename} to reload them.  In fact, the
    entire {cmd:estimates} command has been reworked.  The new command
    {cmd:estimates} {cmd:notes} allows you to add notes to estimation results
    just as you add them to datasets.  The new command {cmd:estimates}
    {cmd:esample} allows you to restore {cmd:e(sample)} after reloading
    estimates, should that be necessary (usually it is not).  The maximum
    number of estimation results that can be held in memory (as opposed to
    saved on disk) is increased to 300 from 20.  See {manhelp estimates R}.

{phang2}
2.  Stata now has exact logistic and exact Poisson regression.  
    Rather than having their inference based on asymptotic normality,
    exact estimators enumerate the conditional distribution of the sufficient
    statistics and then base inference upon that distribution.  In small
    samples, exact methods have better coverage than asymptotic methods, and
    exact methods are the only way to obtain point estimates, tests, and
    confidence intervals from covariates that perfectly predict the observed
    outcome.

{pmore2}
    Postestimation command {cmd:estat} {cmd:se} reports odds ratios and their
    asymptotic standard errors.  {cmd:estat} {cmd:predict}, available only
    after {cmd:exlogistic}, computes predicted probabilities, asymptotic
    standard errors, and exact confidence intervals for single cases.

{pmore2}
    See {manhelp exlogistic R} and {manhelp expoisson R}.

{phang2}
3.  New estimation command {cmd:asclogit} performs alternative-specific
    conditional logistic regression, which includes McFadden's choice model.
    Postestimation command {cmd:estat} {cmd:alternatives} reports
    alternative-specific summary statistics.  {cmd:estat} {cmd:mfx} reports
    marginal effects of regressors on probabilities of each alternative.  See
    {manhelp asclogit R} and
    {manhelp asclogit_postestimation R:asclogit postestimation}.

{phang2}
4.  New estimation command {cmd:asroprobit} performs alternative-specific
    rank-ordered probit regression.
    {cmd:asroprobit} is related to rank-ordered logistic regression 
    ({cmd:rologit}) but allows modeling alternative-specific effects and 
    modeling the covariance structure of the alternatives.
    Postestimation command {cmd:estat} {cmd:alternatives} provides summary
    statistics about the alternatives in the estimation sample.  {cmd:estat}
    {cmd:covariance} displays the variance-covariance matrix of the
    alternatives.  {cmd:estat} {cmd:correlation} displays the correlation
    matrix of the alternatives.  {cmd:estat} {cmd:mfx} computes the marginal
    effects of regressors on the probability of the alternatives.
    See {manhelp asroprobit R} and 
    {manhelp asroprobit_postestimation R:asroprobit postestimation}.

{phang2}
5.  New estimation command {cmd:ivregress} performs single-equation
    instrumental-variables regression by two-stage least squares,
    limited-information maximum likelihood, or generalized method of moments.
    Robust and HAC covariance matrices may be requested.
    Postestimation command {cmd:estat} {cmd:firststage} provides various
    descriptive statistics and tests of instrument relevance.  {cmd:estat}
    {cmd:overid} tests overidentifying restrictions.  
    {cmd:ivregress} replaces the previous {cmd:ivreg} command.  
    See {manhelp ivregress R} and
    {manhelp ivregress_postestimation R:ivregress postestimation}.

{phang2}
6.  New estimation command {cmd:nlsur} fits a system of nonlinear equations by
    feasible generalized least squares, allowing for covariances among the
    equations; see {manhelp nlsur R}.

{phang2}
7.  Existing estimation command {cmd:nlogit} was rewritten and has new, better
    syntax and runs faster when there are more than two levels.  Old syntax
    is available under version control.  {cmd:nlogit} now fits the
    random utilities maximization (RUM) model by default as well as the
    nonnormalized model that was available previously.  The new {cmd:nlogit}
    now allows unbalanced groups and allows groups to have different sets of
    alternatives.  
    {cmd:nlogit} now excludes entire choice sets (cases) if any alternative
    (observation) has a missing value; use new option {cmd:altwise} to exclude
    just the alternatives (observations) with missing values.
    Finally, {cmd:vce(robust)} is allowed regardless of the number of nesting
    levels.  See {manhelp nlogit R}.

{phang2}
8.  Existing estimation command {cmd:asmprobit} has the following
    enhancements:

{p 12 16 2}
a.  The new default parameterization estimates the covariance of the
        alternatives differenced from the base alternative, making the 
        estimates invariant to the choice of base.
        New option {cmd:structural} specifies that the previously structural 
        (nondifferenced) covariance parameterization be used.

{p 12 16 2}
b.  {cmd:asmprobit} now permits estimation of the constant-only model.

{p 12 16 2}
c.  {cmd:asmprobit} now excludes entire choice sets (cases) if any
	alternative (observation) has a missing value; use new option
	{cmd:altwise} to exclude just the alternatives (observations) with
	missing values.

{p 12 16 2}
d.  New postestimation command {cmd:estat mfx} computes marginal effects
        after {cmd:asmprobit}. 

{pmore2}
    See {manhelp asmprobit R} and
    {manhelp asmprobit_postestimation R:asmprobit postestimation}.

{phang2}
9.  Existing estimation command {cmd:clogit} now accepts {cmd:pweight}s and
    may be used with the {cmd:svy:} prefix.

{pmore2}
    Also, {cmd:clogit} used to be willing to produce
    cluster-robust VCEs when the groups were not nested within
    the clusters.  Sometimes, this VCE was consistent, and other times
    it was not.  You must now specify the new {cmd:nonest} option to obtain a
    cluster-robust VCE when the groups are not nested within
    panels.

{pmore2}
    {cmd:predict} after {cmd:clogit} now accepts options that calculate
    the Delta(beta) influence statistic, the Delta(chi^2) lack-of-fit
    statistic, the Hosmer and Lemeshow leverage, the Pearson residuals, and
    the standardized Pearson residuals.

{pmore2}
    See {manhelp clogit R} and
    {manhelp clogit_postestimation R:clogit postestimation}.

{p 7 12 2}
10.  Existing estimation command {cmd:cloglog} now accepts {cmd:pweight}s, may
    now be used with the {cmd:svy:} prefix, and has new option {cmd:eform}
    that requests that exponentiated coefficients be reported; see
    {manhelp cloglog R}.

{p 7 12 2}
11.  Existing estimation command {cmd:cnreg} now accepts {cmd:pweight}s, may be
    used with the {cmd:svy:} prefix, and is now noticeably faster (up to five
    times faster) when used within loops, such as by {cmd:statsby}.
    See {manhelp cnreg R}.

{p 7 12 2}
12.  Existing estimation commands {cmd:cnsreg} and {cmd:tobit} now accept
     {cmd:pweight}s, may be used with the {cmd:svy:} prefix, and are now
     noticeably faster (up to five times faster) when used within loops, such
     as by {cmd:statsby}.  Also, {cmd:cnsreg} now has new advanced option
     {cmd:mse1} that sets the mean squared error to 1.  See {manhelp cnsreg R}
     and {manhelp tobit R}.

{p 7 12 2}
13.  Existing estimation command {cmd:regress} is now noticeably faster (up to
    five times faster) when used with loops, such as by {cmd:statsby}.
    Also, 

{p 12 16 2}
a.  Postestimation command {cmd:estat} {cmd:hettest} has new option
	{cmd:iid} that specifies that an alternative version of the score test
	be performed that does not require the normality assumption.  New
	option {cmd:fstat} specifies that an alternative F test be performed
	that also does not require the normality assumption.

{p 12 16 2}
b.  Existing postestimation command {cmd:estat} {cmd:vif} has new option
        {cmd:uncentered} that specifies that uncentered variance inflation
        factors be computed.

{pmore2}
   See {manhelp regress_postestimation R:regress postestimation}.

{p 7 12 2}
14.  Existing estimation commands {cmd:logit}, {cmd:mlogit}, {cmd:ologit},
     {cmd:oprobit}, and {cmd:probit} are now noticeably faster (up to five
     times faster) when used within loops, such as by {cmd:statsby}.

{p 7 12 2}
15.  For existing estimation command {cmd:probit}, {cmd:predict} 
     now allows the {cmd:deviance} option; see
     {helpb probit postestimation:[R] probit postestimation}.

{p 7 12 2}
16.  Existing estimation command {cmd:nl} has the following enhancements:

{p 12 16 2}
a.  Option {opth vce(vcetype)} is now allowed, with supported
	{it:vcetype}s that include types derived from asymptotic theory, that
	are robust to some kinds of misspecification, that allow for
	intragroup correlation, and that use bootstrap or jackknife methods.
	Also, three heteroskedastic- and autocorrelation-consistent variance
	estimators are available.

{p 12 16 2}
b.  {cmd:nl} no longer reports an overall model F test because the test
        that all parameters other than the constant are jointly zero may not
        be appropriate in arbitrary nonlinear models. 

{p 12 16 2}
c.  The coefficient table now reports each parameter as its own equation,
        analogous to how {cmd:ml} reports single-parameter equations. 

{p 12 16 2}
d.  {cmd:predict} after {cmd:nl} has new options that allow you to
        obtain the probability that the dependent variable lies within a given
        interval, the expected value of the dependent variable conditional on
        its being censored, and the expected value of the dependent variable
        conditional on its being truncated.  These predictions assume that the
        error term is normally distributed.

{p 12 16 2}
e.  {cmd:mfx} can be used after {cmd:nl} to obtain marginal effects.

{p 12 16 2}
f.  {cmd:lrtest} can be used after {cmd:nl} to perform likelihood-ratio
	tests.

{pmore2}
See {manhelp nl R} and {manhelp nl_postestimation R:nl postestimation}.

{p 7 12 2}
17.  Existing estimation command {cmd:mprobit} now allows {cmd:pweight}s, may
    now be used with the {cmd:svy:} prefix, and has new option
    {cmd:probitparam} that specifies that the probit variance
    parameterization, which fixes the variance of the differenced latent
    errors between the scale and the base alternatives to one, be used.  See
    {manhelp mprobit R}.

{p 7 12 2}
18.  Existing estimation command {cmd:rologit} now allows {cmd:vce(bootstrap)}
    and {cmd:vce(jackknife)}.  See {manhelp rologit R}.

{p 7 12 2}
19.  Existing estimation command {cmd:truncreg} now allows {cmd:pweight}s and
    now works with the {cmd:svy:} prefix.  See
    {hi:[SVY] svy estimation}.

{p 7 12 2}
20.  After existing estimation command {cmd:ivprobit}, 
    postestimation commands {cmd:estat} {cmd:classification}, {cmd:lroc}, and
    {cmd:lsens} are now available. 
    Also, in
    {cmd:ivprobit}, the order of the ancillary parameters in the output has
    been changed to reflect the order in {cmd:e(b)}.
    See {manhelp ivprobit R} and
    {manhelp ivprobit_postestimation R:ivprobit postestimation}.

{p 7 12 2}
21.  All estimation commands that allowed options {cmd:robust} and
     {cmd:cluster()} now allow option {opth vce(vcetype)}.  {cmd:vce()}
     specifies how the variance-covariance matrix of the estimators
     (and hence standard errors) are to be calculated.  This syntax was
     introduced in Stata 9, with options such as {cmd:vce(bootstrap)},
     {cmd:vce(jackknife)}, and {cmd:vce(oim)}.

{pmore2}
    In Stata 10, option {cmd:vce()} is extended to encompass the robust (and
    optionally clustered) variance calculation.  Where you previously typed

{p 12 16 2}
. {it:estimation-command} ...{cmd:, robust}

{pmore2}
    you are now to type 

{p 12 16 2}
. {it:estimation-command} ...{cmd:, vce(robust)}

{pmore2}
    and where you previously typed 

{p 12 16 2}
. {it:estimation-command} ...{cmd:, robust cluster(}{it:clustervar}{cmd:)}

{pmore2}
    with or without the {cmd:robust}, you are now to type 

{p 12 16 2}
. {it:estimation-command} ...{cmd:, vce(cluster} {it:clustervar}{cmd:)}

{pmore2}
    You can still type the old syntax, but it is undocumented.  The new syntax
    emphasizes that the robust and cluster calculation affects 
    standard errors, not coefficients.
    See {manhelpi vce_option R}.

{pmore2}
    Going along with this change, estimation commands now have a term for 
    their default variance calculation.  Thus, you will see things like 
    {cmd:vce(ols)}, and {cmd:vce(gnr)}.  Here is what they all mean:

{p 12 16 2}
a.  {cmd:vce(ols)}.  The variance estimator for  ordinary least squares;
	an {it:s}^2(X'X)^{-1}-type calculation.

{p 12 16 2}
b.  {cmd:vce(oim)}.  The observed information matrix based on the 
	likelihood function; a (-{it:H})^{-1}-type calculation, where 
        {it:H} is the Hessian matrix.

{p 12 16 2}
c.  {cmd:vce(conventional)}.  A generic term to identify the conventional
        variance estimator associated with the model.  For instance, in the
        Heckman two-step estimator, {cmd:vce(conventional)} means the
        Heckman-derived variance matrix from an augmented regression.  In two
        different contexts, {cmd:vce(conventional)} does not necessarily mean
        the same calculation.

{p 12 16 2}
d.  {cmd:vce(analytic)}.  The variance estimator derived from first 
        principles of statistics for means, proportions, and totals.

{p 12 16 2}
e.  {cmd:vce(gnr)}.  The variance matrix based on an auxiliary regression,
	which is analogous to {it:s}^2({it:X}'{it:X})^{-1} generalized to
	nonlinear regression.  {cmd:gnr} stands for Gauss-Newton regression.

{p 12 16 2}
f.  {cmd:vce(linearized)}.  The variance matrix calculated by a
        first-order Taylor approximation of the statistic, otherwise known as
        the Taylor linearized variance estimator, the sandwich estimator, 
        and the White estimator.  This is identical to {cmd:vce(robust)} in
        other contexts.

{pmore2}
The above are used for defaults.  {cmd:vce()} may also be

{p 12 16 2}
g.  {cmd:vce(robust)}.  The variance matrix calculated by the 
	sandwich estimator of variance, VDV-type calculation, 
	where {it:V} is the conventional variance matrix and 
	{it:D} is the outer product of the gradients,
	sum_{it:i} {it:g_ig_i}'.

{p 12 16 2}
h.  {cmd:vce(cluster} {it:varname}{cmd:)}.  The cluster-based version 
        of {cmd:vce(robust)} where 
	sums are performed within the groups formed by {it:varname}, 
        which is equivalent to assuming that the independence is 
	between groups only, not between observations.

{p 12 16 2}
i.  {cmd:vce(hc2)} and {cmd:vce(hc3)}.  Calculated similarly as
	{cmd:vce(robust)} except that different scores are used in place of
	the gradient vectors {it:g_i}.

{p 12 16 2}
j.  {cmd:vce(opg)}.  The variance matrix calculated by the outer product 
	of the gradients; a (sum_{it:i} {it:g_ig_i}')^(-1)-type calculation.

{p 12 16 2}
k.  {cmd:vce(jackknife)}.  The variance matrix calculated by the 
 	jackknife, including delete one, delete {it:n}, and the cluster-based 
        jackknife.

{p 12 16 2}
l.  {cmd:vce(bootstrap)}.  The variance matrix calculated by 
        bootstrap resampling.

{pmore2}
    You do not need to memorize the above; the documentation for the 
    individual commands, and their corresponding dialog boxes, make 
    clear what is the default and what is available.

{p 7 12 2}
22.  Estimation commands specified with option {cmd:vce(bootstrap)}
    or {cmd:vce(jackknife)} now report a note when a variable is dropped 
    because of collinearity. 

{p 7 12 2}
23.  The new option {cmd:collinear}, which has been added to many estimation
    commands, specifies that the estimation command not remove collinear
    variables.  Typically, you do not want to specify this option.  It is for
    use when you specify constraints on the coefficients
    such that, even though the variables are collinear, the model is fully
    identified.  See {manhelp estimation_options R:estimation options}.

{p 7 12 2}
24.  Estimation commands having a model Wald test composed of more than just
     the first equation now save the number of equations in the model Wald
     test in {cmd:e(k_eq_model)}. 

{p 7 12 2}
25.  All estimation commands now save macro {cmd:e(cmdline)} containing the
     command line as originally typed.

{p 7 12 2}
26.  Concerning existing estimation command {cmd:ml};

{p 12 16 2}
a.  {cmd:ml} now saves the number of equations used to compute the model
        Wald test in {cmd:e(k_eq_model)}, even when option {cmd:lf0()} is
        specified.

{p 12 16 2}
b.  {cmd:ml} {cmd:score} has new option {cmd:missing} that specifies that
        observations containing variables with missing values not be
        eliminated from the estimation sample.

{p 12 16 2}
c.  {cmd:ml} {cmd:display} has new option {cmd:showeqns} that requests
        that equation names be displayed in the coefficient table.

{pmore2}
    See {manhelp ml R}.

{p 7 12 2}
27.  New command {cmd:lpoly} performs a kernel-weighted local polynomial
    regression and displays a graph of the smoothed values with optional
    confidence bands; see {manhelp lpoly R}.

{p 7 12 2}
28.  New prefix command {cmd:nestreg:} reports comparison tests of nested
    models; see {manhelp nestreg R}.

{p 7 12 2}
29.  Existing commands {cmd:fracpoly}, {cmd:fracgen}, and {cmd:mfp} have new
    features:

{p 12 16 2}
a.  {cmd:fracpoly} and {cmd:mfp} now support {cmd:cnreg}, {cmd:mlogit},
	{cmd:nbreg}, {cmd:ologit}, and {cmd:oprobit}.

{p 12 16 2}
b.  {cmd:fracpoly} and {cmd:mfp} have new option {cmd:all} that specifies
        that out-of-sample observations be included in the generated
        variables.

{p 12 16 2}
c.  {cmd:fracpoly, compare} now reports a closed-test comparison between
        fractional polynomial models by using deviance differences rather than
        reporting the gain; see {manhelp fracpoly R}.

{p 12 16 2}
d.  {cmd:fracgen} has new option {cmd:restrict()} that computes 
        adjustments and scaling on a specified subsample.

{pmore2}
    See {manhelp fracpoly R} and {manhelp mfp R}.

{p 7 12 2}
30.  For existing postestimation command {cmd:hausman}, options {cmd:sigmaless}
    and {cmd:sigmamore} may now be used after {cmd:xtreg}.  These options
    improve results when comparing fixed- and random-effects regressions
    based on small to moderate samples because they ensure that
    the differenced covariance matrix will be positive definite.  See
    {manhelp hausman R}.

{p 7 12 2}
31.  Existing postestimation command {cmd:testnl} now allows expressions that
    are bound in parentheses or brackets to have commas. For example,
    {cmd:testnl _b[x] = M[1,3]} is now allowed.  See {manhelp testnl R}.

{p 7 12 2}
32.  Existing postestimation command {cmd:nlcom} has a new option {cmd:noheader}
    that suppresses the output header; see {manhelp nlcom R}.

{p 7 12 2}
33.  Existing command {cmd:statsby} now works with more commands, including
    postestimation commands.  {cmd:statsby} also has new option
    {cmd:forcedrop} for use with commands that do not allow {cmd:if} or
    {cmd:in}.  {cmd:forcedrop} specifies that observations outside the
    {cmd:by()} group be temporarily dropped before the command is called.  See
    {manhelp statsby D}.

{p 7 12 2}
34.  Existing command {cmd:mkspline} will now create restricted cubic splines
    as well as linear splines.  New option {cmd:displayknots} will display the
    location of the knots.  See {manhelp mkspline R}.

{p 7 12 2}
35.  In existing command {cmd:kdensity}, {opt kernel(kernelname)}
    is now the preferred way to specify the kernel, but the previous method of
    simply specifying {it:kernelname} still works.  See 
    {manhelp kdensity R}.

{p 7 12 2}
36.  Existing command {cmd:ktau}'s computations are now faster; see
    {manhelp spearman R}.

{p 7 12 2}
37.  In existing command {cmd:ladder}, the names of the transformations in the
    output have been renamed to match those used by {cmd:gladder} and
    {cmd:qladder}.  Also, the returned results {cmd:r(raw)} and {cmd:r(P_raw)}
    have been renamed to {cmd:r(ident)} and {cmd:r(P_ident)}, respectively.
    See {manhelp ladder R}.

{p 7 12 2}
38.  Existing command {cmd:ranksum} now allows the {it:groupvar} in option
    {opt by(groupvar)} to be a string; see {manhelp ranksum R}. 

{p 7 12 2}
39.  Existing command {cmd:tabulate,} {cmd:exact} now allows exact computations
    on larger tables.  Also, new option {cmd:nolog} suppresses the
    enumeration log.  See {manhelp tabulate_twoway R:tabulate twoway}.

{p 7 12 2}
40.  Existing command {cmd:tetrachoric}'s default algorithm for computing
    tetrachoric correlations has been changed from the Edwards and Edwards
    estimator to a maximum likelihood estimator.  Also, standard
    errors and two-sided significance tests are produced.  The Edwards and
    Edwards estimator is still available by specifying the new {cmd:edwards}
    option.  A new {cmd:zeroadjust} option requests that frequencies be
    adjusted when one cell has a zero count.  See {manhelp tetrachoric R}.

{p 7 12 2}
41.  Existing command {cmd:areg} now works like {cmd:regress} with indicator
    variables when {cmd:cluster()} is specified.  See {manhelp areg R}.


{marker paneldata}{...}
{title:What's new in statistics (longitudinal/panel data)}

{phang2}
1.  New command {cmd:xtset} declares a dataset to be panel data and designates
    the variable that identifies the panels.  In previous versions of Stata,
    you specified options {opt i(groupvar)} and sometimes {opt t(timevar)} to
    identify the panels.  You specified the {cmd:i()} and {cmd:t()} options on
    the {cmd:xt} command you wanted to use.  Now you {cmd:xtset}
    {it:groupvar} or {cmd:xtset} {it:groupvar} {it:timevar} first.  The
    values you set will be remembered from one session to the next if you save
    your dataset.

{pmore2}
    {cmd:xtset} also provides a new feature.
    {cmd:xtset} allows option {cmd:delta()} to specify the frequency of 
    the time-series data, something you will need to do if you are 
    using Stata's new date/time variables.

{pmore2}
     Finally, you can still specify old options {cmd:i()} and {cmd:t()}, 
     but they are no longer documented.  Similarly, old commands {cmd:iis} and
     {cmd:tis} continue to work but are no longer documented.  See
     {manhelp xtset XT}.

{phang2}
2.  New estimation commands {cmd:xtmelogit} and {cmd:xtmepoisson} fit
    nested, hierarchical, and mixed models with binary and
    count responses; that is, you can fit logistic and Poisson models
    with complex, nested error components.
    Syntax is the same as for Stata's linear mixed-model estimator, 
    {cmd:xtmixed}.  
    To fit a model of graduation with a fixed coefficient on {cmd:x1} and
    random coefficient on {cmd:x2} at the school level, and with random
    intercepts at both the school and class-within-school level, you type

{p 12 16 2}
{cmd: xtmelogit graduate x1 x2 || school: x2 || class:}

{pmore2}
    {cmd:predict} after {cmd:xtmelogit} and {cmd:xtmepoisson} will calculate
    predicted random effects.  See
    {manhelp xtmelogit XT},
    {manhelp xtmelogit_postestimation XT:xtmelogit postestimation},
    {manhelp xtmepoisson XT}, and
    {manhelp xtmepoisson_postestimation XT:xtmepoisson postestimation}.

{phang2}
3.  New estimation commands are available for fitting dynamic panel-data 
    models:

{p 12 16 2}
a.  Existing estimation command {cmd:xtabond} fits dynamic panel-data
	models by using the Arellano-Bond estimator but now reports
	results in levels rather than differences.  Also, {cmd:xtabond}
	will now compute the Windmeijer biased-corrected two-step robust
	VCE.  See {manhelp xtabond XT}.

{p 12 16 2}
b.  New estimation command {cmd:xtdpdsys} fits dynamic panel-data models
	by using the Arellano-Bover/Blundell-Bond system
	estimator.  {cmd:xtdpdsys} is an extension of {cmd:xtabond} and
	produces estimates with smaller bias when the AR process is
	too persistent.  {cmd:xtpdsys} is also more efficient than
	{cmd:xtabond}.  Whereas {cmd:xtabond} uses moment conditions based on
	the differenced errors in producing results, {cmd:xtpdsys} uses moment
	conditions based on differences and levels.  See
	{manhelp xtdpdsys XT}.

{p 12 16 2}
c.  New estimation command {cmd:xtdpd} fits dynamic panel-data models
        extending the Arellano-Bond or the
	Arellano-Bover/Blundell-Bond system estimator and
	allows a richer syntax for specifying models and so will fit a broader
	class of models then either {cmd:xtabond} or {cmd:xtdpdsys}.
	{cmd:xtdpd} can be used to fit models with serially correlated
	idiosyncratic errors, whereas {cmd:xtdpdsys} and {cmd:xtabond} assume
	no serial correlation.  {cmd:xtdpd} can be used with models where the
	structure of the predetermined variables is more complicated than that
	assumed by {cmd:xtdpdsys} or {cmd:xtabond}.  See
	{manhelp xtdpd XT}.

{p 12 16 2}
d.  New postestimation command {cmd:estat} {cmd:abond} tests for serial
        correlation in the first-differenced errors.
	See {manhelp xtabond_postestimation XT:xtabond postestimation}, 
	{manhelp xtdpdsys_postestimation XT:xtdpdsys postestimation}, and 
	{manhelp xtdpd_postestimation XT:xtdpd postestimation}.

{p 12 16 2}
e.  New postestimation command {cmd:estat} {cmd:sargan} 
	performs the Sargan test of overidentifying restrictions.
	See {manhelp xtabond_postestimation XT:xtabond postestimation}, 
	{manhelp xtdpdsys_postestimation XT:xtdpdsys postestimation}, and 
	{manhelp xtdpd_postestimation XT:xtdpd postestimation}.

{phang2}
4.  Existing estimation command {cmd:xtreg,} {cmd:fe} now accepts
    {cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s.  Also, new option
    {cmd:dfadj} specifies that the cluster-robust VCE be adjusted for
    the within transform.  This was previously the default behavior.  See
    {manhelp xtreg XT}.

{phang2}
5.  Existing estimation commands {cmd:xtreg,} {cmd:fe} and {cmd:xtreg,}
    {cmd:re} used to be willing to produce cluster-robust VCEs when
    the panels were not nested within the clusters.  Sometimes this VCE is
    consistent and other times it is not.  You must now specify the new
    {cmd:nonest} option to obtain a cluster-robust VCE when the panels
    are not nested within the clusters.

{phang2}
6.  The numerical method used to evaluate distributions, known as quadrature,
    has been improved.  This method is used by the {cmd:xt} random-effects
    estimation commands {cmd:xtlogit}, {cmd:xtprobit}, {cmd:xtcloglog},
    {cmd:xtintreg}, {cmd:xttobit}, and {cmd:xtpoisson, re normal}.

{p 12 16 2}
a.  For the estimation commands, the default method is now
	{cmd:intmethod(mvaghermite)}.  The old default was
	{cmd:intmethod(aghermite)}.

{p 12 16 2}
b.  Option {opt intpoints(#)} for the commands now allows up to 195
        quadrature points.  The default is 12, and the old upper limit was 30.
        (Models with large random effects often require more quadrature
        points.)

{p 12 16 2}
c.  The estimation commands may now be used with constraints regardless 
	of the quadrature method chosen. 

{p 12 16 2}
d.  Command {cmd:quadchk}, for use after estimation to verify that the
        quadrature approximation was sufficiently accurate, now produces a
        more informative comparison table.  Before, four fewer and four more
        quadrature points were used, and that was reasonable if the number of
        quadrature points was, say, {it:n_q} = 12.  Now you may specify 
	significantly larger {it:n_q} and the {ul:+}4 is not useful.  Now
	{cmd:quadchk} uses {bind:{it:n_q} - {cmd:int}({it:n_q}/3)} and
	{bind:{it:n_q} + {cmd:int}({it:n_q}/3)}.

{p 12 16 2}
e.  {cmd:quadchk} has new option {cmd:nofrom} that forces refitted models
        to start from scratch rather than starting from the previous
        estimation results.  This is important if you use the old 
	{cmd:intmethod(aghermite)}, which is sensitive to starting values, 
	but not important if you are using the new default 
	{cmd:intmethod(mvaghermite)}.

{pmore2}
    See {manhelp quadchk XT}.

{phang2}
7.  All {cmd:xt} estimation commands now accept option {opt vce(vcetype)}.  As
    mentioned in the
    {it:{help whatsnew9to10##general:What's new in statistics (general)}},
    {cmd:vce(robust)} and {cmd:vce(cluster} {it:varname}{cmd:)} are the right
    ways to specify the old {cmd:robust} and {cmd:cluster()} options, and
    option {cmd:vce()} allows other VCE calculations as well.

{phang2}
8.  Existing estimation command {cmd:xtcloglog} has new option {cmd:eform}
    that requests exponentiated coefficients be reported; see
    {manhelp xtcloglog XT}.

{phang2}
9.  Existing estimation command {cmd:xthtaylor} now allows users to specify
    only endogenous time-invariant variables, only endogenous time-varying
    variables, or both.  Previously, both were required.  See
    {manhelp xthtaylor XT}.

{p 7 12 2}
10.  Most {cmd:xt} estimation commands have new option {cmd:collinear}, 
    which specifies that collinear variables are not to be removed.
    Typically, you do not want to specify this option.  It is for use 
    when you specify constraints on the coefficients such that,
    even though the variables are collinear, the model is fully identified.
    See {manhelp estimation_options XT:estimation options}.

{p 7 12 2}
11.  Existing command {cmd:xtdes} has been renamed to {cmd:xtdescribe}.
     {cmd:xtdes} continues to work as a synonym for {cmd:xtdescribe}.  See
     {manhelp xtdescribe XT}.

{p 7 12 2}
12.  The [XT] manual has an expanded glossary.


{marker timeseries}{...}
{title:What's new in statistics (time series)}

{phang2}
1.  All time-series analysis commands now support data with frequencies as
    high as 1 millisecond (ms), corresponding to Stata's new date/time
    variables.  Since your data are probably not recorded at the millisecond
    level, existing command {cmd:tsset} has new option {cmd:delta()} that
    allows you to specify the frequency of your data.  Previously, time was
    recorded as {it:t}_0, {it:t}_0 + 1, {it:t}_0 + 2, ..., and if time =
    {it:t} in some observation, then the corresponding lagged observation was
    the observation for which time = {it:t}-1.  That is still the default.
    When you specify {cmd:delta()}, time is assumed to be recorded as {it:t}_0,
    {it:t}_0 + delta, {it:t}_0 + 2delta, and if time = {it:t} in some
    observation, then the corresponding lagged observation is the observation
    for which time = {it:t} - delta.  Say that you are analyzing hourly data and
    time is recorded using Stata's new {cmd:%tc} values.  One hour corresponds
    to 3,600,000 ms, and you would want to specify {cmd:tsset} {cmd:t,}
    {cmd:delta(3600000)}.  Option {cmd:delta()} is smart; you can specify
    {cmd:tsset} {cmd:t,} {cmd:delta(1 hour)}.  See {manhelp tsset TS}.

{phang2}
2.  {cmd:tsset} now reports whether panels are balanced when an 
    optional panel variable is specified.

{phang2}
3.  Many {cmd:ts} estimation commands now accept option {opt vce(vcetype)}.
    As mentioned in
    {it:{help whatsnew9to10##general:What's new in statistics (general)}},
    {cmd:vce(robust)} and {cmd:vce(cluster} {it:varname}{cmd:)} are the right
    ways to specify the old {cmd:robust} and {cmd:cluster()} options, and
    option {cmd:vce()} allows other VCE calculations as well.

{phang2}
4.  Options {cmd:vce(hc2)} and {cmd:vce(hc3)} are now the preferred way to
    request alternative bias corrections for the robust variance calculation
    for existing estimation command {cmd:prais}.  
    See {manhelp prais TS}.

{phang2}
5.  Existing estimation commands {cmd:arch} and {cmd:arima} have new option
    {cmd:collinear} that specifies that the estimation command not remove
    collinear variables.  Typically, you do not want to specify this option.
    It is for use when you specify constraints on the
    coefficients such that, even though the variables are collinear, the model
    is fully identified.  See
    {manhelp estimation_options TS:estimation options}.

{phang2}
6.  Existing command {cmd:irf} now estimates and reports
    dynamic-multiplier functions and cumulative 
    dynamic-multiplier functions, as well as their standard errors. 
    See {manhelp irf TS}. 

{phang2}
7.  The [TS] manual has an expanded glossary.


{marker survey}{...}
{title:What's new in statistics (survey)}

{phang2}
1.  Stata's {cmd:svy:} prefix now works with 48 estimators, 28
    more than previously.  Most importantly, {cmd:svy:} now works with 
    Cox regression ({cmd:stcox}) and parametric survival
    models ({cmd:streg}).  Other commands with which {cmd:svy:} now works
    include

{p2colset 13 25 27 2}{...}
{p2col:{cmd:biprobit}}bivariate probit regression{p_end}
{p2col:{cmd:clogit}}conditional (fixed effects) logistic regression{p_end}
{p2col:{cmd:cloglog}}complementary log-log regression{p_end}
{p2col:{cmd:cnreg}}censored-normal regression{p_end}
{p2col:{cmd:cnsreg}}constrained linear regression{p_end}
{p2col:{cmd:glm}}generalized linear models{p_end}
{p2col:{cmd:hetprob}}heteroskedastic probit model{p_end}
{p2col:{cmd:ivregress}}instrumental-variables regression{p_end}
{p2col:{cmd:ivprobit}}probit model with endogenous regressors{p_end}
{p2col:{cmd:ivtobit}}tobit model with endogenous regressors{p_end}
{p2col:{cmd:mprobit}}multinomial probit regression{p_end}
{p2col:{cmd:nl}}nonlinear least-squares estimation{p_end}
{p2col:{cmd:scobit}}skewed logistic regression{p_end}
{p2col:{cmd:slogit}}stereotype logistic regression{p_end}
{p2col:{cmd:stcox}}Cox proportional hazards regression{p_end}
{p2col:{cmd:streg}}parametric survival models (5 estimators){p_end}
{p2col:{cmd:tobit}}tobit regression{p_end}
{p2col:{cmd:treatreg}}treatment-effects model{p_end}
{p2col:{cmd:truncreg}}truncated regression{p_end}
{p2col:{cmd:zinb}}zero-inflated negative binomial regression{p_end}
{p2col:{cmd:zip}}zero-inflated Poisson regression{p_end}
{p2col:{cmd:ztnb}}zero-truncated negative binomial regression{p_end}
{p2col:{cmd:ztp}}zero-truncated Poisson regression{p_end}

{pmore2}
See {manhelp svy_estimation SVY:svy estimation}.

{phang2}
2.  {cmd:svy:} prefix now calculates the linearized variance estimator
    2 to 100 times faster, the larger multiplier applying to large datasets
    with many sampling units; see {manhelp svy SVY}.

{phang2}
3.  {cmd:svy:} {cmd:mean}, {cmd:svy:} {cmd:proportion},
    {cmd:svy:} {cmd:ratio}, and {cmd:svy:} {cmd:total} are considerably faster
    when the {cmd:over()} option identifies many subpopulations.

{phang2}
4.  {cmd:svy:}, {cmd:svy:} {cmd:mean}, {cmd:svy:} {cmd:proportion},
    {cmd:svy:} {cmd:ratio}, and {cmd:svy:} {cmd:total} now take advantage of
    multiple processors in Stata/MP, making them even faster in that case.

{phang2}
5.  Concerning {cmd:svyset}, 

{p 12 16 2}
a.  New option {opt singleunit(method)} provides
    three methods for handling strata with one sampling unit.
    If not specified, the default in such cases is to report standard errors 
    as missing value. 

{p 12 16 2}
b.  New option {opt fay(#)} specifies that Fay's adjustment be made to the 
    BRR weights.

{pmore2}
    See {manhelp svyset SVY}. 

{phang2}
6.  {cmd:estat} has two new subcommands for use with {cmd:svy} estimation
    results:

{p 12 16 2}
a.  {cmd:estat} {cmd:sd}, used after {cmd:svy:} {cmd:mean}, reports
        subpopulation standard deviations.

{p 12 16 2}
b.  {cmd:estat} {cmd:strata} reports the number of singleton and certainty
        strata within each sampling stage.

{pmore2}
See {manhelp svy_estat SVY: estat}.

{phang2}
7.  {cmd:svy:} {cmd:tabulate} now allows string variables.  See 
    {manhelp svy_tabulate_oneway SVY:svy: tabulate oneway} and 
    {manhelp svy_tabulate_twoway SVY:svy: tabulate twoway}.

{phang2}
8.  Existing command {cmd:svydes} has been renamed {cmd:svydescribe};
    {cmd:svydes} continues to work. {cmd:svydescribe} now puts missing
    values in the {opt generate(newvar)} variable for observations
    outside the specified estimation sample.  Previously, the variable would
    contain a zero for observations outside the estimation sample.  See
    {manhelp svydescribe SVY}.

{phang2}
9.  The [SVY] manual has been reorganized.  Stata's survey estimation commands
    are now documented in {hi:[SVY] svy estimation}.  All model-specific
    information is now documented in the manual entry for the corresponding
    estimation command.


{marker survival}{...}
{title:What's new in statistics (survival analysis)}

{phang2}
1.  Existing estimation commands {cmd:stcox} and {cmd:streg} may now be used
    with the {cmd:svy:} prefix and so can fit models for complex survey
    data; see {manhelp stcox ST} and {manhelp streg ST}.

{phang2}
2.  New command {cmd:stpower} provides sample-size and power calculations for
    survival studies that use Cox proportional-hazards regressions, log-rank
    tests for two groups, or differences in exponentially distributed hazards
    or log hazards.

{p 12 16 2}
a.  {cmd:stpower} {cmd:cox} estimates required sample size (given power)
        or power (given sample size) or the minimal detectable coefficient
        (given power and sample size) for models with multiple covariates.
        The command provides options to account for possible correlation
        between the covariate of interest and other predictors and for 
        withdrawal of subjects from the study.  See 
	{manhelp stpower_cox ST:stpower cox}.

{p 12 16 2}
b.  {cmd:stpower} {cmd:logrank} estimates required sample size (given
        power) or power (given sample size) or the minimal detectable hazard
        ratio (given power and sample size) for studies comparing survivor
        functions of two groups by using the log-rank test.  Both the 
        {help whatsnew9to10##F1982:Freedman (1982)} and the
        {help whatsnew9to10##S1981:Schoenfeld (1981)} methods are provided.
        The command
        allows for unequal allocation of subjects between the groups and
        possible withdrawal of subjects.  Estimates can be adjusted for
        uniform accrual.  See {manhelp stpower_logrank ST:stpower logrank}.

{p 12 16 2}
c.  {cmd:stpower} {cmd:exponential} estimates sample size (given power)
	or power (given sample size) of tests of the difference between 
        hazards or log hazards of two groups under the assumption of
        exponential survivor functions (also known as the
        exponential test).  Both the 
        {help whatsnew9to10##LF1986:Lachin-Foulkes (1986)} and
	{help whatsnew9to10##RGS1981:Rubinstein-Gail-Santner (1981)} methods
        are provided.  Unequal
	group allocation, uniform or truncated exponential accrual, and
	different exponential losses due to follow-up in each group are
	allowed.  See {manhelp stpower_exponential ST:stpower exponential}.

{pmore2}
    The {cmd:stpower} commands allow automated production of
    customizable tables and have options to assist with creating graphs
    of power curves.  See {manhelp stpower ST}.

{phang2}
3.  Concerning existing command {cmd:sts} {cmd:graph},

{p 12 16 2}
a.  New option {cmd:risktable()} places a subjects-at-risk table
        underneath and aligned with the survivor or hazard plot.

{p 12 16 2}
b.  New option {cmd:ci} replaces old options {cmd:gwood}, {cmd:cna}, and
        {cmd:cihazard}. {cmd:sts} {cmd:graph} will choose the appropriate
        confidence interval on the basis of the function being graphed.

{p 12 16 2}
c.  Confidence intervals are now graphed using shaded areas and new
        options {cmd:plotopts()} and {cmd:ciopts()} allow you to
        control how plots and confidence intervals look.

{p 12 16 2}
d.  Overlaid confidence intervals are now allowed and are produced when
        new option {cmd:ci} is combined with existing option {opt by(varlist)}.

{p 12 16 2}
e.  New option {cmd:censopts()} controls the appearance of ticks and
        markers produced by existing option {cmd:censored()}.

{p 12 16 2}
f.  Boundary computations for smoothing hazards have been improved.  New
        option {cmd:noboundary} specifies that no boundary correction be done.

{p 12 16 2}
g.  The lower bound of the range to plot the hazard function now 
        extends to zero.
       
{p 12 16 2}
h.  Option {cmd:na} has been renamed {cmd:cumhaz}.  {cmd:na} may still be
        used.

{pmore2}
See {manhelp sts_graph ST:sts graph}.  Setting {cmd:version} to less than 10
restores previous behavior.

{phang2}
4.  For {cmd:sts} {cmd:list}, option {cmd:na} has been renamed
	{cmd:cumhaz}.  {cmd:na} may be used as a synonym for {cmd:cumhaz}.
         See {helpb sts list:[ST] sts list}.

{phang2}
5.
    Improvements to {cmd:stcurve} analogous to those of {cmd:sts} {cmd:graph}
    have been made.

{p 12 16 2}
a.  Boundary computations for smoothing hazards have been improved.  New
        option {cmd:noboundary} specifies that no boundary correction be done.

{p 12 16 2}
b.  The lower bound of the range to plot the hazard function now 
        extends to zero.

{pmore2}
    See {manhelp stcurve ST}.

{phang2}
6.  All {cmd:st} estimation commands accept option {opt vce(vcetype)}.  As
    mentioned in the
    {it:{help whatsnew9to10##general:What's new in statistics (general)}},
    {cmd:vce(robust)} and {cmd:vce(cluster} {it:varname}{cmd:)} are the right
    ways to specify the old {cmd:robust} and {cmd:cluster()} options, and
    option {cmd:vce()} now allows other VCE calculations as well.

{phang2}
7. Existing command {cmd:predict} after {cmd:stcox} has a new option, 
   {cmd:scores}, that allows generating variables with the partial efficient
   score residuals; see {manhelp stcox_postestimation ST:stcox postestimation}.

{phang2}
8.  Existing command {cmd:ltable} has new options {cmd:byopts()},
    {cmd:plotopts()}, {cmd:plot}{it:#}{cmd:opts()}, and
    {cmd:ci}{it:#}{cmd:opts()} that allow for more customization of the graph.
    New option {cmd:ci} adds confidence intervals to the graph.  See
    {manhelp ltable ST}.

{phang2}
9.  Existing command {cmd:stphplot} has a new option
    {cmd:plot}{it:#}{cmd:opts()} that allows for more customization of the
    graph.  See {manhelp stcox_diagnostics ST:stcox diagnostics}.

{p 7 12 2}
10.  Existing command {cmd:stcoxkm} has new options {cmd:byopts()},
    {cmd:obsopts()}, {cmd:obs}{it:#}{cmd:opts()}, {cmd:predopts()}, and
    {cmd:pred}{it:#}{cmd:opts()} that allow for more customization of the
    graph.  See {manhelp stcox_diagnostics ST:stcox diagnostics}.

{p 7 12 2}
11.  Existing command {cmd:cc} has new option {cmd:tarone} that produces
    Tarone's ({help whatsnew9to10##T1985:1985}) adjustment of the Breslow-Day
    test for homogeneity of odds ratios.  See {manhelp epitab R}.

{p 7 12 2}
12.  Existing command {cmd:stdes} has been renamed to {cmd:stdescribe}.
    {cmd:stdes} continues to work.  See {manhelp stdescribe ST}.

{p 7 12 2}
13.  The [ST] manual has an expanded glossary.


{marker multivariate}{...}
{title:What's new in statistics (multivariate)}

{phang2}
1.  New estimation commands {cmd:discrim} and {cmd:candisc}
    provide several discriminant analysis techniques, including 
    linear discriminant analysis (LDA), 
    quadratic discriminant analysis (QDA), 
    logistic discriminant analysis, 
    and {it:k}th nearest neighbor discrimination.
    See {manhelp discrim MV}, 
    {manhelp discrim_estat MV:discrim estat}, and
    {manhelp candisc MV}.

{phang2}
2.  Existing estimation commands {cmd:mds}, {cmd:mdslong}, and {cmd:mdsmat}
    now provide modern as well as classical multidimensional scaling (MDS),
    including metric and nonmetric MDS.  Available loss functions include
    stress, normalized stress, squared stress, normalized
    squared stress, and Sammon.  Available transformations include
    identity, power, and monotonic.  {cmd:mdslong} also now allows
    {cmd:aweight}s and {cmd:fweight}s, and {cmd:mdsmat} has a {cmd:weight()}
    option.  See {manhelp mds MV}, {manhelp mdslong MV}, and
    {manhelp mdsmat MV}.

{phang2}
3.  New estimation command {cmd:mca} provides multiple correspondence analysis
    (MCA) and joint correspondence analysis (JCA); see
    {manhelp mca MV} and {manhelp mca_postestimation MV:mca postestimation}.
    You can use existing command {cmd:screeplot} afterward to graph 
    principal inertias; see {manhelp screeplot MV}.

{phang2}
4.  Concerning existing estimation command {cmd:ca} (correspondence analysis),

{p 12 16 2}
a.  {cmd:ca} now allows crossed (stacked) variables.  This provides a way
        to automatically combine two or more categorical variables into one
        crossed variable and perform correspondence analysis with it.

{p 12 16 2}
b.  {cmd:ca}'s existing option {cmd:normalize()} now allows
	{cmd:normalize(standard)} to provide normalization of the coordinates
	by singular vectors divided by the square root of the mass.

{p 12 16 2}
c.  {cmd:ca}'s new option {cmd:length()} allows you to customize the
        length of labels with crossed variables in output.

{p 12 16 2}
d.  New postestimation command {cmd:estat loadings}, used after {cmd:ca}
        and {cmd:camat}, displays correlations of profiles and axes.

{p 12 16 2}
e.  Existing postestimation command {cmd:cabiplot} has new option
	{cmd:origin} that displays the origin within the plot.  {cmd:cabiplot}
	also now accepts {opt originlopts(line_options)} to
	customize the appearance of the origin on the graph.

{p 12 16 2}
f.  Existing postestimation commands {cmd:cabiplot} and {cmd:caprojection}
	now allow row and column marker labels to be specified using the
	{cmd:mlabel()} suboption of {cmd:rowopts()} and {cmd:colopts()}.

{pmore2}
    See {manhelp ca MV} and {manhelp ca_postestimation MV:ca postestimation}.

{phang2}
5.  Existing commands {cmd:cluster}, {cmd:matrix dissimilarity}, and {cmd:mds}
    now allow the Gower measure for a mix of binary and continuous data; see
    {manhelpi measure_option MV}.

{phang2}
6.  Existing command {cmd:biplot} has new options.  {cmd:dim()}
     specifies the dimensions to be displayed.  {cmd:negcol}
     specifies that negative column (variable) arrows be plotted.  
     {opt negcolopts(col_options)} provides graph options for the
     negative column arrows.  {cmd:norow} and {cmd:nocolumn}
     suppress the row points or column arrows.  See {manhelp biplot MV}.

{phang2}
7.  New postestimation command {cmd:estat rotate} after {cmd:canon} performs
    orthogonal varimax rotation of the raw coefficients, standard
    coefficients, or canonical loadings.  After {cmd:estat rotate}, new
    postestimation command {cmd:estat rotatecompare} displays the rotated and
    unrotated coefficients or loadings and the most recently rotated
    coefficients or loadings.  See
    {manhelp canon_postestimation MV:canon postestimation}.

{phang2}
8.  Existing commands {cmd:pcamat} and {cmd:factormat} now allow singular
    correlation or covariance structures.  New option {cmd:forcepsd}
    modifies a matrix to be positive semidefinite and thus to be a proper
    covariance matrix.  See {manhelp pca MV} and {manhelp factor MV}.

{phang2}
9.  Existing commands {cmd:rotate} and {cmd:rotatemat} now refer to 
    "Kaiser normalization" rather than "Horst normalization".  A search of
    the literature indicates that Kaiser normalization is the preferred
    terminology.  Previously option {cmd:horst} was a synonym for 
    {cmd:normalize}.  Now option {cmd:horst} is not documented.
    See {manhelp rotate MV} and {manhelp rotatemat MV}.

{p 7 12 2}
10.  Existing command 
    {cmd:procrustes} now saves the number of {it:y} variables in scalar
    {cmd:e(ny)}; see {manhelp procrustes MV}.


{marker graphics}{...}
{title:What's new in graphics}

{phang2}
1.  Stata 10 has an interactive, point-and-click editor for your graphs.
    You do not need to type anything; you just right-click within the Graph
    window and select {bf:Start Graph Editor}.
    You can do that any time, either when the graph is drawn or when you have
    {cmd:graph} {cmd:use}d it from disk.  
    You can add text, lines, markers, titles, and annotations, outside the
    plot region or inside; you can move axes, titles, legends, etc.; you can
    change colors and sizes, number of tick marks, etc.; and you can even change
    scatters to lines or bars, or vice versa.
    See {manhelp graph_editor G-1:graph editor}.

{phang2}
2.  New command {cmd:graph twoway lpoly} plots a local polynomial smooth; see
    {manhelp twoway_lpoly G-2:graph twoway lpoly}.
    New command {cmd:graph twoway lpolyci} plots a local polynomial smooth
    along with a confidence interval; see
    {manhelp twoway_lpolyci G-2:graph twoway lpolyci}.

{phang2}
3.  Concerning command {cmd:graph} {cmd:twoway},

{p 12 16 2}
a.  {cmd:graph} {cmd:twoway} now allows more than 100 variables to be
        plotted.

{p 12 16 2}
b.  New suboption {cmd:custom} of {it:axis_label_options}
        allows you to create custom axis ticks and labels that have a
        different color, size, tick length, etc., from the standard
        ticks and labels on the axis.  Such custom ticks can be used to
        emphasize points in the scale, such as important dates, physical
        constants, or other special values.  See the {cmd:custom} suboption in
        {manhelpi axis_label_options G-3}.

{p 12 16 2}
c.  New suboption {cmd:norescale} of {it:axis_label_options} specifies
	that added ticks and labels be placed directly on the graph
	without rescaling the axis or associated plot region for the new
	values; see {manhelpi axis_label_options G-3}.

{p 12 16 2}
d.  New advanced options {cmd:yoverhangs} and {cmd:xoverhangs} adjust the
        graph region margins to prevent long labels on the y or x axis
        from extending off the edges of the graphs; see
        {manhelpi advanced_options G-3}.

{phang2}
4.  {cmd:graph twoway pcarrow} and {cmd:graph twoway pcbarrow} may now be
    drawn on plot regions with log scales or reversed scales; see
    {manhelp twoway_pcarrow G-2:graph twoway pcarrow}.

{phang2}
5.  {cmd:graph bar} and {cmd:graph dot} no longer require user-provided names
    when a variable is repeated with more than one statistic; see 
    {manhelp graph_bar G-2:graph bar} and {manhelp graph_dot G-2:graph dot}. 

{phang2}
6. {cmd:graph twoway lfit} and {cmd:graph twoway qfit} now use value
    labels to annotate the x axis when using the existing suboption
    {cmd:valuelabel} of {cmd:xmlabel()}; see
    {manhelpi axis_label_options G-3}. 

{phang2}
7.  {cmd:graph export} has new options {opt width(#)} and {opt height(#)} that
    specify the width and height of the graph when exporting to PNG or TIFF,
    thus allowing the resolution to be greater than screen resolution; see
    {it:{help png_options}} and {it:{help tif_options}} in
    {manhelp graph_export G-2:graph export}.

{phang2}
8.  {cmd:graph} {cmd:twoway} {cmd:area} and {cmd:graph} {cmd:twoway}
    {cmd:rarea} now allow option {cmd:cmissing()} to control whether missing
    values produce breaks in the areas or are ignored; see
    {manhelp twoway_area G-2:graph twoway area} and
    {manhelp twoway_rarea G-2:graph twoway rarea}.

{phang2}
9.
   Typing {cmd:help graph} {it:option} now displays the help file for the
      specified option of the {cmd:graph} command. See {manhelp help R}.


{marker programming}{...}
{title:What's new in programming}

{phang2}
1.  First, a warning for time-series programmers:  Stata's new date/time
   values, which contain the number of milliseconds since
   01jan1960 00:00:00, result in large numbers.  21apr2007 12:14:07.123
   corresponds to 1,492,776,847,123.  Date/time values must be stored as
   {cmd:double}s.  Programmers should use scalars to store these values
   whenever possible.  If you must use a macro, exercise caution that the
   value is not rounded.  It would not do at all for 1,492,776,847,123 to be
   recorded as "{cmd:1.493e+12}" (which would be 24apr2007 02:13:20).  If you
   must use macros, our recommendations are

{p 12 16 2}
a.  If a date/time value is stored in one macro and you need it in
        another, code

{p 16 18 2}
	{cmd:local new `old'}

{p 12 16 2}
b.  If a date/time value is the result of an expression, and you must
        store it as a macro, code

{p 16 18 2}
	{cmd:local new = string(}{it:exp}{cmd:, "%21x")}

{p 12 16 2}
	or

{p 16 18 2}
	{cmd:local new : display %21x (}{it:exp}{cmd:)}

{pmore2}
Now we will continue with What's new.

{phang2}2.  Stata for Windows now supports Automation, formerly known as 
    OLE Automation, which means that programmers can control Stata from
    other applications and retrieve results.  See {manhelp automation P}.

{phang2}
3.  New command
    {cmd:confirm} {c -(}{cmd:numeric}|{cmd:string}|{cmd:date}{c )-} 
    {cmd:format} verifies that the format is of the specified type;
    see {manhelp confirm P}.

{phang2}
4.  New function {opt fmtwidth(s)} returns the display width of a
    {cmd:%}{it:fmt} string, including date formats; see
    {helpb prog functions:[FN] Programming functions}.

{phang2}
5.  Expression limits have been increased in Stata/MP, Stata/SE, and Stata/IC.
    The limit on the number of dyadic operators has increased from 500 to 800,
    and the limit on the number of numeric literals has increased from 150 to
    300.  See {help limits}.

{phang2}
6.  Intercooled Stata has been renamed to Stata/IC.  {cmd:c(flavor)}
    now contains "{cmd:IC}" rather than "{cmd:Intercooled}" if version > 10.
    Backward-compatibility old global macro {cmd:$S_FLAVOR} continues to
    contain "{cmd:Intercooled}".  See {manhelp creturn P} and 
    {manhelp macro P}.

{phang2}
7.  {cmd:c()} now contains values associated with Stata/MP:  {cmd:c(MP)} (1 or
    0 depending on whether you are running Stata/MP), {cmd:c(processors)} (the
    number of processors Stata will use), {cmd:c(processors_mach)} (the number
    of processors on the computer), {cmd:c(processors_lic)} (the maximum
    number of processors the license will allow you to use), and
    {cmd:c(processors_max)} (the maximum number of processors that could be
    used on this computer with this license).

{phang2}
8.  New command {cmd:include} is a variation on {cmd:do} and {cmd:run}.
    {cmd:include} executes the commands stored in a file just as if they were
    entered from the keyboard or the current do-file.  It is most often used
    in advanced Mata situations to create the equivalent of {cmd:#include}
    files.  See {manhelp include P}.

{phang2}
9.  New commands {cmd:signestimationsample} and {cmd:checkestimationsample}
    are useful in writing estimation/postestimation commands that need to 
    identify the estimation sample; see {manhelp signestimationsample P}.

{p 7 12 2}
10.  New command {cmd:_datasignature} is the building block 
    for Stata's {cmd:datasignature} command and the programming commands 
    {cmd:signestimationsample} and {cmd:checkestimationsample}.
    In advanced situations, you may wish to call it directly.
    See {manhelp _datasignature P}.

{p 7 12 2}
11.  New extended macro function {cmd::copy} copies one macro to another 
    and is faster when the macro being copied is long.  That is, coding 

{p 12 16 2}
	{cmd:local new : copy local old}

{pmore2}
    is faster than 

{p 12 16 2}
	{cmd:local new `old'}

{pmore2}
    See {manhelp macro P}.

{p 7 12 2}
12.  New command {cmd:timer} times sections of code;
    see {manhelp timer P}.

{p 7 12 2}
13.  Existing command {cmd:matrix accum} is now faster when some observations
    contain zeros; see {manhelp matrix_accum P:matrix accum}.

{p 7 12 2}
14.  Existing command {cmd:ml display} has new option {cmd:showeqns} that
    requests that equation names be displayed in the coefficient table; see
    {manhelp ml R}.

{p 7 12 2}
15.  Existing command {cmd:mkmat} has new options {cmd:rownames()},
     {cmd:roweq()}, {cmd:rowprefix()}, {cmd:obs}, and {cmd:nchar()} that
     specify the row names of the created matrix; see 
     {manhelp mkmat P:matrix mkmat}.

{p 7 12 2}
16.  Existing command {cmd:_rmdcoll}'s {cmd:nocollin} option has been renamed
    to {cmd:normcoll}.  {cmd:nocollin} will continue to work as a synonym for
    {cmd:normcoll}. See {manhelp _rmcoll P}.

{p 7 12 2}
17.  Existing command {cmd:describe}'s option {cmd:simple} no longer 
    saves the names of the variables in {cmd:r(varlist)}; you must 
    specify option {cmd:varlist} if you want that.  
    Also, existing command {cmd:describe} {cmd:using} {it:filename}
    now allows options {cmd:simple} and {cmd:varlist}. See 
    {manhelp describe D}.

{p 7 12 2}
18.  New extended macro function {cmd:adosubdir} returns the subdirectory in
    which Stata would search for a file along the ado-path.
    Determining the subdirectory in which Stata stores files is now a function
    of the file's extension.  {cmd:adosubdir} returns the
    subdirectory in which to look.  See {manhelp macro P}.

{p 7 12 2}
19.  Existing command
     {cmd:syntax} {c -(}[{it:optionname}({cmd:real} ...)]{c )-} now returns
     the number specified in {cmd:%18.0g} format if {cmd:version} is set to
     10.0 or higher.  For {cmd:version} less than 10, the number is returned
     in {cmd:%9.0g} format.  See {manhelp syntax P}.

{p 7 12 2}
20.  New functions {cmd:_byn1()} and {cmd:_byn2()}, available within a
     {cmd:byable(recall)} program, return the beginning and ending observation
     numbers of the by-group currently being executed; see
     {helpb byable:[P] byable}.

{p 7 12 2}
21.  Existing command {cmd:program drop} may now specify {cmd:program drop}
    {cmd:_allado} to drop programs that were automatically loaded from
    ado-files; see {manhelp program P}.

{p 7 12 2}
22.  Concerning SMCL, 

{p 12 16 2}
a.  Existing directive {cmd:{c -(}synoptset{c )-}} has new optional
	argument {cmd:notes} that specifies that some of the table entries
	will have footnotes and results in a larger indentation of the first
	column.

{p 12 16 2}
b.  Existing directive {cmd:{c -(}p{c )-}} now has an optional fourth
        argument specifying the paragraph's width.

{pmore2}
See {manhelp smcl P}.

{p 7 12 2}
23.  Concerning classes, you 
        can now define an {cmd:oncopy} member program to perform
        operations when a copy of an object is being created.  See
        {manhelp class P}.

{p 7 12 2}
24.  Concerning programmable menus, the maximum number of menu items that can
    be added to Stata has increased to 1,250 from 1,000; see
    {helpb window_programming:[P] window programming}.

{p 7 12 2}
25. Concerning programmable dialogs, 

{p 12 16 2}
a.  Child dialogs can now be created.

{p 12 16 2}
b.  New control {cmd:TEXTBOX} allows displaying multiline text.

{p 12 16 2}
c.  In the dialog programming language, (1) {cmd:if} now allows {cmd:else}
        and (2) new command {cmd:close} closes the dialog programmatically.

{p 12 16 2}
d.  Messages can be passed to dialogs when they are launched; see
	{helpb db:[R] db}.

{p 12 16 2}
e.  Dialogs can now be designated as modal, meaning that this dialog must 
        be dealt with by the user before new dialogs (other than children)
        can be launched.

{p 12 16 2}
f.  Several controls have new options and new member programs.
	For instance, {cmd:FILE} and {cmd:LISTBOX} now have option 
        {cmd:multiselect}, which lets the user pick more than one item.

{pmore2}
    See {helpb dialog programming:[P] dialog programming}.

{p 7 12 2}
26.  Stata's help files are now named {cmd:*.sthlp} rather than {cmd:*.hlp},
    meaning that user-written help files can be sent via email more easily.
    Many email filters flag {cmd:.hlp} files as potential virus carriers
    because Stata was not the only one to use the {cmd:.hlp} suffix.
    You need not rename your old help
    files.  See {manhelp help R}.

{p 7 12 2}
27.  Two new C functions have been exposed from Stata for 
    use by plugins:  {cmd:sstore()} and {cmd:sdata()}.  {cmd:sstore()} stores
    string data in the Stata dataset and {cmd:sdata()} reads them.  See
    {browse "http://www.stata.com/plugins/"}.


{marker mata}{...}
{title:What's new in Mata}

{phang2}
1.  New Stata command {cmd:include} is a variation on {cmd:do} and {cmd:run}
    and is useful for implementing {cmd:#include} for header files in 
    advanced programming situations.  
    See {manhelp include P} and type {cmd:viewsource} {cmd:optimize.mata} for
    an example of use.

{phang2}
2.  Mata now has structures, which will be of special interest to those
    writing large systems.  See 
    {helpb m2_struct:[M-2] struct} and 
    {helpb mf_liststruct:[M-5] liststruct()}.

{phang2}
3.  Mata now engages in more thorough type checking, and produces better code,
    for those who explicitly declare arguments and variables. 

{phang2}
4.  Mata inherits all of Stata's formats and functions for dealing 
    with the new date/time variables and values; see
    {helpb mf_date:[M-5] date()} and
    {helpb mf_fmtwidth:[M-5] fmtwidth()}.

{phang2}
5.  New functions {cmd:inbase()} and {cmd:frombase()} perform base
    conversions; see {helpb mf_inbase:[M-5] inbase()}.

{phang2}
6.  New function {cmd:floatround()} returns values rounded to float
    precision.  This is Mata's equivalent of Stata's {cmd:float()}
    function.  See {helpb mf_floatround:[M-5] floatround()}.

{phang2}
7.  New function {cmd:nameexternal()} returns the name of an external; see
    {helpb mf_findexternal:[M-5] findexternal()}.

{phang2}
8.  Concerning matrix manipulation, 

{p 12 16 2}
a.  Matrix multiplication is now faster when one of the matrices contains
        many zeros, as is function {cmd:cross()}.

{p 12 16 2}
b.  Appending rows or columns to a matrix using {cmd:,} and {cmd:\} 
        is now faster.

{p 12 16 2}
c.  New function {cmd:_diag()} replaces the principal diagonal of
        a matrix with a specified vector or scalar; see 
	{helpb mf__diag:[M-5] _diag()}.

{p 12 16 2}
d.  New functions {cmd:select()} and {cmd:st_select()} select
        rows or columns of a matrix on the basis of a criterion; see
        {helpb mf_select:[M-5] select()}.

{p 12 16 2}
e.  Existing functions 
	{cmd:rowsum()}, 
	{cmd:colsum()}, 
	{cmd:sum()},
	{cmd:quadrowsum()}, 
	{cmd:quadcolsum()}, and 
	{cmd:quadsum()} 
        now allow an optional second argument that determines how missing
        values are handled; see {helpb mf_sum:[M-5] sum()}.

{p 12 16 2}
f.  New functions 
	{cmd:runningsum()}, 
	{cmd:quadrunningsum()},
	{cmd:_runningsum()}, and 
	{cmd:_quadrunning-sum()} 
	return the running sum of a vector; see 
	{helpb mf_runningsum:[M-5] runningsum()}.

{p 12 16 2}
g.  New functions {cmd:minindex()} and {cmd:maxindex()} return the
        indices of minimums and maximums (including tied values) of a vector;
        see {helpb mf_minindex:[M-5] minindex()}.

{phang2}
9.  Concerning statistics, 

{p 12 16 2}
a.  New Mata function {cmd:optimize()} performs minimization and
        maximization.  You can code just the function, the function and its
        first derivatives, or the function and its first and second
        derivatives.  Optimization techniques include Newton-Raphson,
        Davidon-Fletcher-Powell,
	Broyden-Fletcher-Goldfarb-Shanno,
	Berndt-Hall-Hall-Hausman, and the simplex
	method Nelder-Mead.  See {helpb mf_optimize:[M-5] optimize()}.

{p 12 16 2}
b.  New function {cmd:cvpermute()} forms permutations; 
        see {helpb mf_cvpermute:[M-5] cvpermute()}. 

{p 12 16 2}
c.  New function {cmd:ghk()} provides the
        Geweke-Hajivassiliou-Keane multivariate normal
        simulator; see {helpb mf_ghk:[M-5] ghk()}. 
        New function {cmd:ghkfast()} is 
        faster but a little more difficult to use;
        see {helpb mf_ghkfast:[M-5] ghkfast()}.

{p 12 16 2}
d.  New functions {cmd:halton()}, {cmd:_halton()}, and {cmd:ghalton()}
	compute Halton and Hammersley sets; see
	{helpb mf_halton:[M-5] halton()}.

{p 12 16 2}
e.  The new density and probability functions available in Stata are also 
available in Mata, including 
	{cmd:binomial()},
	{cmd:binomialtail()},
        {cmd:gammaptail()},
	{cmd:invgammaptail()}, 
        {cmd:invbinomialtail()},
	{cmd:ibetatail()}, 
	{cmd:invibetatail()}, 
	{cmd:lnnormal()}, and 
	{cmd:lnnormalden()}; 
	see {helpb mf_normal:[M-5] normal()}.  
        Also, as in Stata, convergence and accuracy of many of the
        cumulatives, reverse cumulatives, and density functions have been
        improved.

{p 12 16 2}
f.  Existing Mata functions 
	{cmd:mean()},
	{cmd:variance()},
	{cmd:quadvariance()},
	{cmd:meanvariance()},
	{cmd:quadmeanvariance()},
	{cmd:correlation()}, and
	{cmd:quadcorrelation()}
        now make the weight argument optional.
        If not specified, unweighted estimates are returned.  See
        {helpb mf_mean:[M-5] mean()}.

{p 7 12 2}
10.  Concerning string processing, 

{p 12 16 2}
a.  New function {cmd:stritrim()} replaces multiple, consecutive
        internal spaces with one space; see
        {helpb mf_strtrim:[M-5] strtrim()}. 

{p 12 16 2}
b.  New functions {cmd:strtoreal()} and {cmd:_strtoreal()}
        convert strings to numeric values; see 
	{helpb mf_strtoreal:[M-5] strtoreal()}.

{p 12 16 2}
c.  New function {cmd:_substr()} substitutes a substring into an
        existing string; see
	{helpb mf__substr:[M-5] _substr()}.

{p 12 16 2}
d.  New function {cmd:invtokens()} is the inverse of the existing
        function {cmd:tokens()}; see 
	{helpb mf_invtokens:[M-5] invtokens()}.

{p 12 16 2}
e.  New function {cmd:tokenget()} performs advanced parsing; see
        {helpb mf_tokenget:[M-5] tokenget()}.

{p 7 12 2}
11.  Concerning I/O, 

{p 12 16 2}
a.  New function {cmd:adosubdir()} returns the subdirectory in
        which Stata would search for  a file; see
        {helpb mf_adosubdir:[M-5] adosubdir()}.
        New function {cmd:pathsearchlist({it:fn})} returns a row vector of
        full paths/filenames specifying all the locations, in order, where
        Stata would look for the specified {it:fn} along the official Stata
        ado-path; see {helpb mf_pathjoin:[M-5] pathjoin()}. 

{p 12 16 2}
b.  New function {cmd:byteorder()} returns 1 if the computer is
        HILO and returns 2 if the computer is LOHI; see
        {helpb mf_byteorder:[M-5] byteorder()}. 

{p 12 16 2}
c. New undocumented function {cmd:st_fopen()} makes opening files
	easier; see {helpb mf_st_fopen:[M-5] st_fopen()}.

{p 12 16 2}
d.  New functions {cmd:bufput()} and {cmd:bufget()} copy
        elements into and out of buffers; see 
	{helpb mf_bufio:[M-5] bufio()}. 

{p 12 16 2}
e.  Existing function {cmd:cat()} now allows optional second and third
        arguments that specify the beginning and ending lines of the file to
        read; see {helpb mf_cat:[M-5] cat()}.

{p 7 12 2}
12.  New functions {cmd:ferrortext()} and {cmd:freturncode()} obtain error
    messages and return codes following an I/O error; see
    {helpb mf_ferrortext:[M-5] ferrortext()}.

{p 7 12 2}
13.  Concerning the Stata interface, 

{p 12 16 2}
a.  New function {cmd:stataversion()} returns the version of Stata
        that you are running, and new function {cmd:statasetversion()}
        allows setting it.  See 
	{helpb mf_stataversion:[M-5] stataversion()}. 

{p 12 16 2}
b.  New function {cmd:setmore()} allows turning {cmd:more} on and off.
        New function {cmd:setmoreonexit()} allows restoring {cmd:more} to
        its original setting when execution ends.  See 
	{helpb mf_more:[M-5] more()}.

{p 12 16 2}
c.  New function {cmd:st_lchar()} allows storing exceedingly long
        strings (such as a varlist) in Stata dataset characteristics.  See
        {helpb mf_st_lchar:[M-5] st_lchar()}.


{title:What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated, and those updates are available for free
over the Internet.  All you have to do is type

            {cmd:. update query}

{pstd}
and follow the instructions.

{pstd}
To learn what has been added since this manual was printed, select 
{bf:Help > What's new?} or type

            {cmd:. help whatsnew}

{pstd}
We hope that you enjoy Stata 10.


{title:References}

{marker F1982}{...}
{phang} 
Freedman, L. S. 1982.
Tables of the number of patients required in clinical trials using the logrank
test.  {it:Statistics in Medicine} 1: 121-129.

{marker LF1986}{...}
{phang}
Lachin, J. M., and M. A. Foulkes. 1986.
Evaluation of sample size and power for analyses of survival with allowance
for nonuniform patient entry, losses to follow-up, noncompliance, and
stratification. {it:Biometrics} 42: 507-519.

{marker RGS1981}{...}
{phang}
Rubinstein, L. V., M. H. Gail, and T. J. Santner. 1981.
Planning the duration of a comparative clinical trial with loss to follow-up
and a period of continued observation. {it:Journal of Chronic Diseases} 34:
469-479.

{marker S1981}{...}
{phang} 
Schoenfeld, D. A. 1981. 
The asymptotic properties of nonparametric tests for comparing survival
distributions.  {it:Biometrika} 68: 316-319.

{marker T1985}{...}
{phang}
Tarone, R. E. 1985. On heterogeneity tests based on efficient scores.
{it:Biometrika} 72: 91-95.


{hline 3} {hi:previous updates} {hline}

{pstd}
See {help whatsnew9}.{p_end}

{hline}
