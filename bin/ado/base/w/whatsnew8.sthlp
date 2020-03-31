{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 8}

{pstd}
This file records the additions and fixes made to Stata during the 8.0, 8.1,
and 8.2 releases:

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
    {c |} {bf:this file}        Stata  8.0, 8.1, and 8.2     2003 to 2005    {c |}
    {c |} {help whatsnew7to8}     Stata  8.0 new release       2003            {c |}
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 8} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew8to9}.


{hline 8} {hi:update 24feb2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 5(1)}.

{p 5 9 2}
{* fix}
2.  After the update of 09dec2004 {help fcast graph}, {help irf graph}. 
    {help irf cgraph}, {help irf ograph}, and {help sts graph} when used with
    a monochrome scheme, such as {help scheme_s2:s2mono}, and when plotting
    more than one line, plotted all lines with the same solid style.  Each
    line is now plotted with a unique pattern.

{p 5 9 2}
{* fix}
3.  {help graph box} was not fully compliant with the new setting to turn off
    variable abbreviation {c -} {cmd:set varabbrev off}.  In the specific case
    where more than one yvar was specified in combination with the
    {cmd:over()} option, {cmd:graph box} terminated with an error message;
    this has been fixed.

{p 5 9 2}
{* fix}
4.  {help svytab} incorrectly computed the design effects when supplied with
    the {cmd:row} option with one or more of the {cmd:se}, {cmd:ci},
    {cmd:deff}, and {cmd:deft} options; this has been fixed.


{hline 8} {hi:update 10jan2005} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help streg} ignored the {cmd:level()} option at estimation; this has been
    fixed.

{p 5 9 2}
{* fix}
2.  {help streg} issued a meaningless error message when {cmd:noconstant} was
    specified and there were no regressors specified.  {cmd:streg} now issues
    an appropriate error message.

{p 5 9 2}
{* fix}
3.  {help rocfit} erroneously gave one-sided significance levels for
    individual parameter tests that were labeled as two-sided.  {cmd:rocfit}
    now gives the correct two-sided significance levels.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
4.  {help lowess} and {help twoway lowess} produced slightly different graphs
    when run multiple times using the same data and there were ties in the
    {cmd:x} variable; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help tabi} with the {cmd:exact} option after the 05oct2004 update
    sometimes reported an incorrect p-value for Fisher's exact test; this has
    been fixed.

{p 5 9 2}
{* fix}
6.  {help translate} with the {cmd:translator(smcl2log)} option caused Stata
    to exit; this has been fixed.

{p 5 9 2}
{* fix}
7.  If a matrix expression referred to a variable through observation
    subscripting, such as {cmd:matrix X[2,4] = mpg[3]}, the expression, in
    rare cases, returned missing, even though the variable contained a
    nonmissing value in the observation; this has been fixed.


{hline 8} {hi:update 20dec2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help estimates stats} displayed correct results, but the returned results
    matrix {cmd:r(S)} had the {cmd:ll0} and {cmd:ll} columns switched; this
    has been fixed.

{p 5 9 2}
{* fix}
2.  {help sdtest} and {help sdtesti} produced an incorrect p-value for the
    two-sided F test; this has been fixed.  The format of the output has also
    been improved.

{p 5 9 2}
{* fix}
3.  {help statsby} now allows string variables in the {cmd:by()} option.


{hline 8} {hi:update 17dec2004} {hline}

    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
1.  {help anova} with the {cmd:repeated()} option, specifying a pattern of
    repeated measure variables such that no subject had a complete set of
    observed levels, caused the {cmd:e(Srep)} matrix and the Huynh-Feldt and
    Greenhouse-Geisser epsilons to be incorrect.  The regular ANOVA results
    and the Box epsilon were not harmed.  This has been fixed.

{p 5 9 2}
{* enhancement}
2.  {help clogit} now uses better starting values and does not resort the data
    at log-likelihood evaluation.  Both changes result in faster execution
    times for most problems, notably for large datasets.

{p 5 9 2}
{* fix}
3.  {help filefilter} now accepts file paths without the need to double-quote
    the path.

{p 5 9 2}
{* enhancement}
4.  (GUI) The {dialog labeldefine_dlg:label define} dialog now allows you to
    continue adding/modifying labels until you cancel.  Stata previously
    required you to click on the Add or Modify button for each value label you
    wanted to add.

{p 5 9 2}
{* fix}
5.  (GUI) The {dialog labeldefine_dlg:label define} dialog displayed the
    numeric representations of missing values; this has been fixed.

{p 5 9 2}
{* enhancement}
6.  {help odbc load} (available for Windows, Mac OS X, and Linux) has
    two new options, {cmd:allstring} and {cmd:datestring}, which import either
    all data or just dates as strings; see help {help odbc}.

{p 5 9 2}
{* fix}
7.  {help postfile} with the {cmd:every()} option specified as {cmd:every(0)}
    caused Stata to crash; this has been fixed.

{p 5 9 2}
{* enhancement}
8.  {help rmdir} is a new command for removing an existing directory (folder);
    see help {help rmdir}.

{p 5 9 2}
{* fix}
9.  {help tabulate} with the {cmd:exact} option took an excessive amount of
    time if the number of rows of a contingency table was greater than the
    number of columns.  In such a case, Stata now works with the transpose of
    the table to dramatically decrease the computational time for Fisher's
    exact test.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
10.  You may now copy the contents of the Review window to the Clipboard.

{p 4 9 2}
{* fix}
11.  The {help doedit:Do-file Editor} is limited to 30K of text.  However, text
    could be pasted into the editor that would exceed this limit.  This has
    been fixed.

{p 4 9 2}
{* fix}
12.  {help dialog} {cmd:VARNAME} and {cmd:VARLIST} controls will now display
     the varlist even if there is a {cmd:--more--} condition.  Stata
     previously displayed an error message that it was busy.

{p 4 9 2}
{* fix}
13.  The {dialog labeldefine_dlg:label define} dialog showed only the first 10
     characters of a label when it was being modified; this has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
14.  There is now a console version of {help specialedition:Stata/SE} for the
     Mac.  See {browse "http://www.stata.com"} for more information.

{p 4 9 2}
{* fix}
15.  When running Stata remotely to execute a batch job, Stata now treats the
     {cmd:-b} option as an {cmd:-e} option to prevent the alert dialog from
     appearing.

{p 4 9 2}
{* fix}
16.  Graphs created while Stata is running in batch mode no longer appear on
     the screen.

{p 4 9 2}
{* fix}
17.  {help dialog} {cmd:VARNAME} and {cmd:VARLIST} controls will now display
     the varlist even if there is a {cmd:--more--} condition.  Stata
     previously displayed an error message that it was busy.

{p 4 9 2}
{* fix}
18.  In the {help doedit:Do-file Editor}, if you found some text and selected
     Replace..., it ignored the highlighted text and skipped down to the next
     occurrence and replaced that instead.  This has been fixed.

{p 4 9 2}
{* fix}
19.  The tiling of newly opened {help doedit:Do-file Editor} windows has been
     fixed.

{p 4 9 2}
{* fix}
20.  If the {help viewer:Viewer}'s scheme was changed and Default Windowing
     was selected from the Prefs menu, the Viewer's scheme would not be
     restored to the default setting.  This has been fixed.

{p 4 9 2}
{* fix}
21.  The Viewer button on the toolbar brought up a prompt for a file to view
     when it should have just displayed the {help viewer:Viewer}; this has
     been fixed.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* fix}
22.  The {help edit:Data Editor} now allows you to accept changes to the data
     when exiting, discard changes to the data when exiting, and cancel
     exiting.  It previously did not allow you to cancel exiting.

{p 4 9 2}
{* fix}
23.  When you refreshed a long file opened in the {help viewer:Viewer}, the
     Viewer would flicker as the file was being refreshed.  This has been
     fixed.


{hline 8} {hi:update 09dec2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 4(4)}.

{p 5 9 2}
{* enhancement}
2.  {help graph twoway}, {help graph bar}, {help graph box}, and 
    {help graph dot} have a new {cmd:aspectratio()} option to control the
    aspect ratio of a graph's plot region; see help {help aspect_option}.

{p 5 9 2}
{* enhancement}
3.  The default connecting line patterns for the {help scheme s2mono:s2mono}
    and {help scheme s2manual:s2manual} schemes have been improved to take
    advantage of the increased flexibility available to schemes.  The default
    connecting line patterns drawn by {help twoway line} continue to cycle
    through dashed and dotted patterns, while those drawn by
    {help twoway connected} and {help twoway scatter} {hline 2} with the
    {cmd:connect()} option {hline 2} are now all solid.

{p 5 9 2}
{* fix}
4.  Graph margin settings made by the {cmd:margin()} option of 
    {help graph display} would "stick" and apply the same margins to all
    subsequently drawn graphs until a {cmd:discard} command was issued; this
    has been fixed.


{hline 8} {hi:update 24nov2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Documentation for {help graph} scheme files is now available; see help
    {help scheme files}.

{p 5 9 2}
{* enhancement}
2.  The Data menu has been slightly reorganized.  The Labels & Notes submenu
    has been split into two separate entries.  Under Labels, value labels have
    been organized into their own submenu.

{p 5 9 2}
{* fix}
3.  {help cc} and {help cci} with small numbers in the case-control table and
    when {cmd:cornfield} was specified entered an endless loop; this has been
    fixed.

{p 5 9 2}
{* fix}
4.  {help cf} produced an incorrect message when the dataset contained a
    variable named {cmd:_merge}; it now produces the correct error message.

{p 5 9 2}
{* fix}
5.  {help cf} created local macros named after every variable in the dataset.
    This could cause a naming conflict with the local macros used in {cmd:cf}.
    This has been fixed.

{p 5 9 2}
{* fix}
6.  {help clonevar} has improved error messages.

{p 5 9 2}
{* enhancement}
7.  {help duplicates report} is now {help return:r-class} and returns
    {cmd:r(unique_value)} and {cmd:r(N)}.  {cmd:r(unique_value)} is the count
    of unique observations, while {cmd:r(N)} is the total number of
    observations.

{p 5 9 2}
{* enhancement}
8.  {help graph twoway} has a new {cmd:pcycle()} option that specifies the
    number of plots on a graph before the {help pstyle:pstyles} recycle back
    to the first style; see help {help advanced options}.

{p 5 9 2}
{* enhancement}
9.  {help loneway} now allows the group variable to be a string.

{p 4 9 2}
{* fix}
10.  The {dialog mfp} dialog incorrectly allowed oprobit and ologit; this has
     been fixed.

{p 4 9 2}
{* enhancement}
11.  {help roccomp} with the {cmd:graph} option now supports turning off the
     default grid lines using the {cmd:ylabel(,nogrid)} and
     {cmd:xlabel(,nogrid)} options.

{p 4 9 2}
{* enhancement}
12.  {help sampsi} now

{p 9 13 2}
    a.  has a new option {cmd:nocontinuity}.

{p 9 13 2}
    b.  displays a note when assumptions for large one- and two-sample tests on
        proportions are violated.

{p 9 13 2}
    c.  saves {cmd:r(warning)} in returned results.

{p 9 13 2}
    d.  displays an error message when both {cmd:r()} and {cmd:onesample}
        options are specified.

{p 4 9 2}
{* fix}
13.  {help separate} with the missing option failed if the variable contained
     extended missing values ({cmd:.a}, {cmd:.b}, ..., {cmd:.z}); this has
     been fixed.

{p 4 9 2}
{* fix}
14.  {help stcurve} added an extra space between the filename and the
     extension if the filename was quoted in the outfile() option; this has
     been fixed.

{p 4 9 2}
{* fix}
15.  {help svyprop} with the {opt subpop()} option could incorrectly exit with
    a "stratum with only one PSU detected" error; this has been fixed.

{p 4 9 2}
{* enhancement}
16.  {help tabodds} now interprets {cmd:base(}{it:#}{cmd:)} as the category
     number of {it: expvar} when options {cmd:or base()} are used with option
     {cmd:cornfield}, {cmd:tb}, or {cmd:woolf}.

{p 4 9 2}
{* fix}
17.  The {dialog tobit} dialog did not allow only one censoring limit to be
     specified; this has been fixed.

{p 4 9 2}
{* fix}
18.  {help xtgee} with the {cmd:score()} option failed to calculate the score
     if there existed a variable {cmd:_merge} in the dataset; this has been
     fixed.

{p 4 9 2}
{* fix}
19.  {help xtreg:xtreg , re} refused to estimate constant-only models when the
     data contained unbalanced panels; this has been fixed.


{hline 8} {hi:update 06oct2004} {hline}

    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
1.  (Windows GUI only) The 05oct2004 update introduced a problem in the
    {help Viewer} that caused Stata to crash; this has been fixed.

{p 5 9 2}
{* fix}
2.  (Windows GUI only) As of the 05oct2004 update, closing Stata while a
    dialog was open would cause a harmless exception error; this has been
    fixed.


{hline 8} {hi:update 05oct2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help areg}, after the 20aug2004 update, reported a missing value for the
    F statistic when the model was not full rank, even in cases when it should
    have reported an F statistic; this has been fixed.

{p 5 9 2}
{* fix}
2.  {help bsample} without the {cmd:strata()} and {cmd:cluster()} options
    ignored the {help if} qualifier; this has been fixed.

{p 5 9 2}
{* enhancement}
3.  {help clonevar} is a new command that makes an identical copy of an
    existing variable; see help {help clonevar}.  This command is based on
    work by Nicholas J. Cox, University of Durham.

{p 5 9 2}
{* fix}
4.  {help codebook} failed if one of the variables had a large number of
    {help labels:value labels}; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help graph pie} option {cmd:plabel( ... , gap())} would be applied to
    subsequent graphs even if the option were not specified on the subsequent
    {cmd:graph} command.  This has been fixed.

{p 5 9 2}
{* fix}
6.  {help graph twoway connected} ignored the {cmd:sort} option when a weight
    was specified; this has been fixed.

{p 5 9 2}
{* fix}
7.  {help irf} refused to estimate the IRFs after estimating a univariate VAR
    via {help var}; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help lroc} now preserves the sort order of the data.

{p 5 9 2}
{* enhancement}
9.  {help mfp} has a new option, {cmd:aic}, for selecting models by the Akaike
    information criterion (AIC); see help {help mfp}.

{p 4 9 2}
{* fix}
10.  Many commands were updated for better version-control handling of
     {help missing:extended missing values}.  See item #20 below.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
11.  {cmd:gllamm} now has more utility programs internalized in Stata's
     executable, further speeding up estimation for certain classes of models,
     including models with composite links and latent class models with class
     membership determined by covariates.  See
     {browse "http://www.gllamm.org"}.

{p 4 9 2}
{* fix}
12.  {cmd:format} date and time modifiers '{cmd:c}' and '{cmd:y}' did
     not omit leading zeros when they should have.  They behaved exactly like
     '{cmd:C}' and '{cmd:Y}'.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {help graph export} created invalid PostScript or Encapsulated PostScript
     files when graph labels were longer than 128 characters; this has been
     fixed.

{p 4 9 2}
{* enhancement}
14.  {help ibeta():ibeta(a,b,x)} has been improved to 10 digits of accuracy
     when {bind:0 < a, b < 100,000}.  Additionally, functions {help atan()},
     {help asin()}, and {help acos()} now have greater accuracy.

{p 4 9 2}
{* fix}
15.  {help matrix opaccum} and {help matrix glsaccum}, with a string group
     variable {cmd:group()}, caused Stata to crash; this has been fixed.

{p 4 9 2}
{* fix}
16.  {help predict:predict, r} is documented as the minimal abbreviation for
     obtaining residuals after many estimation commands, yet in some cases,
     such as {help regress} with robust standard errors, a minimal
     abbreviation of {cmd:re} was required.  {cmd:predict} now allows {cmd:r}
     as the minimum abbreviation.

{p 4 9 2}
{* enhancement}
17.  {help set varabbrev} is a new command that allows users to turn off
     variable abbreviation in Stata.  See help {help set varabbrev}.

{p 4 9 2}
{* enhancement}
18.  {help tabulate} and {help tabi} with the {cmd:exact} option are now
     significantly faster; see help {help tabulate}.

{p 4 9 2}
{* fix}
19.  {help tabulate} with both the {cmd:generate()} and {cmd:missing} options
     generated a dummy variable containing {cmd:.} rather than {cmd:1} for
     observations where varname was equal to missing; this has been fixed.

{p 4 9 2}
{* fix}
20.  {help version:version #, missing} ignored the {cmd:missing} option in the
     standalone case.  When used in a one-line manner, such as {cmd:version}
     {it:#}{cmd:, missing :} {it:cmd}, it caused an ado-file with {it:#} less
     than 8 to understand the extended {help missing:missing values}.  Now, in
     all cases, the {cmd:missing} option causes Stata to adopt the
     missing-value behavior of the calling program.  That is, an ado-file with
     {cmd:version} {it:#}{cmd:, missing}, when called by a program that
     understands extended missing values, will also understand extended
     missing values.  {cmd:version} {it:#}{cmd:, missing}, when called by a
     program that does not understand extended missing values, will also not
     understand extended missing values.

{p 4 9 2}
{* fix}
21.  {help window stopbox} with long text caused Stata to crash.  Stata now
     accepts text up to 500 characters in each argument, and if the limit is
     exceeded, a warning message is given.

{p 4 9 2}
{* fix}
22.  When you pasted into a single cell, the {help edit:Data Editor} could
     interpret a string containing a comma as two cells; this has been fixed.

{p 4 9 2}
{* fix}
23.  Specified heights for {help dialog} {cmd:VARLIST} and {cmd:VARNAME}
     controls are now ignored, and the default height is always used.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
24.  You can now paste to the Command window when the Results, Graph,
     Variables, or Review window is in the front by selecting Paste Text in
     Command Window from the Edit menu.

{p 4 9 2}
{* enhancement}
25.  Variable Properties, Sort, Hide, and Delete menu items have been added to
     the contextual menu of the {help edit:Data Editor}.

{p 4 9 2}
{* fix}
26.  {help dir} now handles file sizes greater than 2 GB.  The output of
     {cmd:dir} was changed slightly to better accommodate these large file
     sizes.

{p 4 9 2}
{* fix}
27.  The dropdown portion of {help dialog} {cmd:COMBOBOX} controls now resizes
     based on the longest text contained in their initial list.

{p 4 9 2}
{* fix}
28.  If you pressed Enter in a dialog without an OK button or pressed Esc in a
     dialog without a Cancel button, Stata crashed.  This has been fixed.

{p 4 9 2}
{* fix}
29.  A timing issue with the Windows Save As dialog caused an error when you
     tried to save a dataset to a floppy drive.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
30.  You can now paste to the Command window when the Results, Graph,
     Variables, or Review window is in the front by selecting Paste Text in
     Command Window from the Edit menu.

{p 4 9 2}
{* enhancement}
31.  Variable Properties, Sort, Hide, and Delete menu items have been
     reorganized on the contextual menu of the {help edit:Data Editor}.

{p 4 9 2}
{* enhancement}
32.  The floating Toolbar can now be resized.

{p 4 9 2}
{* fix}
33.  If the Toolbar was anchored, and you clicked the Zoom button of a window,
     the titlebar of the window would be obscured by the Toolbar.  This has
     been fixed.

{p 4 9 2}
{* fix}
34.  Results and {help viewer:Viewer} windows could not be resized to the full
     width of the screen; this has been fixed.

{p 4 9 2}
{* fix}
35.  When you printed from the {help viewer:Viewer}, the margins would be
     incorrect causing part of the header not to print and the output to be
     printed with no left margin.  This has been fixed.

{p 4 9 2}
{* fix}
36.  When printing long documents from the {help doedit:Do-file Editor}, Stata
     crashed or might not print the last page.  Both problems have been fixed.

{p 4 9 2}
{* fix}
37.  Right-justified text drawn in the Graph window sometimes was off by a
     pixel or two; this has been fixed.

{p 4 9 2}
{* fix}
38.  The dropdown variety of {help dialog} {cmd:COMBOBOX} controls did not
     scroll text correctly when long text was selected; this has been fixed.

{p 4 9 2}
{* fix}
39.  Specifying a height for some types of {help dialog} {cmd:COMBOBOX}
     controls changed the controls' position.  Now, the default height is
     always used, and the position is not affected.

{p 4 9 2}
{* fix}
40.  Small Stata crashed after drawing a number of graphs or invoking a
     sequence of dialogs; this has been fixed.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* enhancement}
41.  Variable Properties, Sort, Hide, and Delete menu items have been added to
     the contextual menu of the {help edit:Data Editor}.

{p 4 9 2}
{* fix}
42.  Specifying a height for some types of {help dialog} {cmd:COMBOBOX}
     controls changed the controls position.  Now, the default height is
     always used, and the position is not affected.


{hline 8} {hi:update 01sep2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 4(3)}.

{p 5 9 2}
{* fix}
2.  {help dstdize}, with the 20aug2004 update, saved an incorrect {cmd:r(se)}
    matrix; this has been fixed.


{hline 8} {hi:update 20aug2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help areg} now returns {cmd:e(ll)} and {cmd:e(ll_0)}, allowing the
    {help estimates table} command to compute AIC and BIC after {cmd:areg}.

{p 5 9 2}
{* fix}
2.  {help areg} did not use the number of clusters for the denominator degrees
    of freedom when the {cmd:cluster()} option was used.  The F statistic is
    now set to {help missing} if {help test} drops any variables when trying
    to compute the Wald statistic for the model.

{p 5 9 2}
{* enhancement}
3.  {help bootstrap}, {help jknife}, {help permute}, {help simulate}, and
    {help statsby} now {help more:set more off} before looping.

{p 5 9 2}
{* enhancement}
4.  {help dotplot} has the new {cmd:over()} option, which is a synonym for the
    {cmd:by()} option.

{p 5 9 2}
{* enhancement}
5.  {help dstdize} now returns the standard errors and confidence intervals in
    the matrices {cmd:r(se)}, {cmd:r(lb)}, and {cmd:r(ub)}.

{p 5 9 2}
{* enhancement}
6.  {help graph combine} has a new option, {cmd:altshrink}, that provides an
    alternate sizing of the text, markers, line thickness, and line patterns
    on the individual combined graphs; see help {help graph combine}.

{p 5 9 2}
{* fix}
7.  {help mfx} has been changed as follows.

{p 9 13 2}
    a.  {cmd:mfx} is no longer allowed after {help boxcox} or {help vec}.

{p 9 13 2}
    b.  {cmd:mfx} displays links to an explanation when it is unsuitable for
        computing the marginal effects or standard errors.

{p 9 13 2}
    c.  {cmd:mfx} displays {cmd:e(cmd2)} as the estimation command instead of
        {cmd:e(cmd)} when {cmd:e(cmd2)} is present.

{p 9 13 2}
    d.  {cmd:mfx} now displays an error message if the {cmd:eqlist()} option
        is used and equation names contain spaces.

{p 9 13 2}
    e.  {cmd:mfx} leaves {cmd:r()} empty at completion.  {cmd:mfx} continues
        to return results to {cmd:e()}.

{p 9 13 2}
    f.  {cmd:mfx} gave incorrect standard errors when using the linear method
        on models that contained a constant equation before an equation
        containing variables; this has been fixed.

{p 9 13 2}
    g.  {cmd:mfx} failed to complete if the model contained an equation with
        all coefficients at zero; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help frontier:predict, te} after fitting a model with {help frontier} in
    which both the {cmd:uhet()} and {cmd:vhet()} options were specified exited
    with an error; this has been fixed.

{p 5 9 2}
{* fix}
9.  {help tabi} produced an appropriate error message but left the returned
    error code {cmd:_rc} as 0 in some cases; this has been fixed.

{p 4 9 2}
{* fix}
10.  {help truncreg} refused to fit a constant-only model; this has been
     fixed.

{p 4 9 2}
{* fix}
11.  {help xtdes} declared that the observations were not unique for the id by
     time grid if the width of the participation pattern exceeded the value of
     the {cmd:width()} option.


{hline 8} {hi:update 27jul2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help _get_diparmopts}, a programmer's tool for estimation commands, now
    handles models with a large number of model parameters.  Correspondingly,
    {help svar} no longer exits with an obscure error message when fitting
    models with a large number of parameters.

{p 5 9 2}
{* enhancement}
2.  {help archlm} now allows a single panel from a panel dataset to be
    specified with an {help if} or {help in} qualifier.

{p 5 9 2}
{* fix}
3.  {help blogit} and {help bprobit} now issue a more informative error
    message when either {it:pos_var} or {it:pop_var} is not integer valued.

{p 5 9 2}
{* fix}
4.  {cmd:predict}, after {help xtlogit}, {help xtprobit}, and {help xtcloglog}
    for fitting random-effects models, ignored the {cmd:if} and {cmd:in}
    qualifiers; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help stcurve}, after {help streg} or {help stcox} with {help pweights},
    issued an error stating that {cmd:pweights} were not allowed, even
    though they were allowed when fitting the original model.  {cmd:stcurve}
    has been fixed to allow {cmd:pweights} and handle them properly.

{p 5 9 2}
{* fix}
6.  {help xttobit} ignored the {cmd:noskip} option; this has been fixed.


{hline 8} {hi:update 23jul2004} {hline}

{p 4 4 2}
The 23jul2004 update includes extensions to Stata's time-series capabilities,
including new commands for fitting and analyzing cointegrated vector
error-correction models (VECMs); see help {help vecintro}.  Several
postestimation commands for use after estimating vector autoregressions (VARs)
and structural VARs have been renamed to better reflect their function.  These
new time-series features are documented in a second edition of the Stata
Time-Series Reference Manual; see
{browse "http://www.stata.com/bookstore/ts.html"}.

{p 4 4 2}
A list of the other ado-file and executable updates for this update is
included after the description of the time-series updates.


    {title:Time-series update}

{p 5 9 2}
{* enhancement}
1.  The new command {help vec} fits cointegrated vector error-correction
    models (VECMs) using Johansen's method; see help {help vec}.

{p 5 9 2}
{* enhancement}
2.  The new command {help vecrank} produces statistics used to determine the
    number of cointegrating vectors in a VECM, including Johansen's trace and
    maximum-eigenvalue tests for cointegration; see help {help vecrank}.

{p 5 9 2}
{* enhancement}
3.  The new command {help fcast}, which replaces the old command
    {cmd:varfcast}, produces and graphs dynamic forecasts of the dependent
    variables after fitting a VAR, SVAR, or VECM; see help {help fcast}.

{p 5 9 2}
{* enhancement}
4.  The new command {help irf}, which replaces the old command {cmd:varirf},
    does everything the old command did and more.  {cmd:irf} estimates the
    impulse-response functions, cumulative impulse-response functions,
    orthogonalized impulse-response functions, structural impulse-response
    functions, and forecast error-variance decompositions after fitting a VAR,
    SVAR, or VECM.  {cmd:irf} can also make graphs and tables of the results.
    See help {help irf}.

{p 9 9 2}
    {cmd:varirf} continues to work but is no longer documented.  {cmd:irf}
    accepts {cmd:.vrf} result files created by {cmd:varirf}.

{p 5 9 2}
{* enhancement}
5.  The new command {help veclmar} computes Lagrange-multiplier statistics for
    autocorrelation after fitting a VECM; see help {help veclmar}.

{p 5 9 2}
{* enhancement}
6.  The new command {help vecnorm} tests whether the disturbances in a VECM
    are normally distributed.  For each equation, and for all equations
    jointly, three statistics are computed: a skewness statistic, a kurtosis
    statistic, and the Jarque-Bera statistic.  See help {help vecnorm}.

{p 5 9 2}
{* enhancement}
7.  The new command {help vecstable} checks the eigenvalue stability condition
    after fitting a VECM; see help {help vecstable}.

{p 5 9 2}
{* enhancement}
8.  The new command {help vecstable} and the existing command {help varstable}
    have a graph option that produces publication-quality graphs to facilitate
    interpreting and presenting the stability results.  See help
    {help vecstable} and help {help varstable}.

{p 5 9 2}
{* enhancement}
9.  The output of the following commands has been standardized for easier
    understanding:  {help var}, {help svar}, {help vargranger},
    {help varlmar}, {help varnorm}, {help varsoc}, {help varstable}, and
    {help varwle}.


    {title:Additional ado-files}

{p 4 9 2}
{* fix}
10.  {help ac}, {help bgodfrey}, {help corrgram}, {help cumsp}, {help dfgls},
     {help dfuller}, {help durbina}, {help dwstat}, {help pac},
     {help pergram}, {help pperron}, {help wntestb}, {help wntestq}, and
     {help xcorr} now allow a single panel from a panel dataset to be
     specified with an {help if} or {help in} qualifier.

{p 4 9 2}
{* fix}
11.  {help glm:glm, irls} quietly ignored {help ml}-specific {help maximize}
     options; this has been fixed.

{p 4 9 2}
{* fix}
12.  {help sw}, when used with {help clogit}, did not allow the {cmd:strata()}
     option as a synonym for {cmd:group()}; this has been fixed.

{p 4 9 2}
{* fix}
13.  {help xi}{cmd::} {it:command ...} run under version 6 or earlier,
     produced indicator variables appropriate for the calling version but
     ignored the calling version when executing {it:command}, instead running
     {it:command} under version 7.  {cmd:xi} now runs {it:command} under the
     calling version.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
14.  A menu item, 'Back', has been added to the {help viewer:Viewer's}
     contextual menu that appears when you right-click on the window.  It does
     the same thing as the 'Back' button on the Viewer.

{p 4 9 2}
{* enhancement}
15.  {cmd:VERSION} in {help dialogs:.dlg} files now takes an optional list of
     operating systems after the version number.  Any combination of
     {cmd:WINDOWS}, {cmd:MACINTOSH}, or {cmd:UNIX} may be specified.  The
     dialog will then be displayed only on the specified operating system(s).
     By default, a dialog may be displayed on any operating system.

{p 4 9 2}
{* enhancement}
16.  The maximum number of description lines in a {help usersite:stata.toc}
     file has been increased from 10 to 50.

{p 4 9 2}
{* fix}
17.  {help anova:anova, sequential}, with the "{cmd:/}" syntax for specifying
     error terms, produced incorrect F statistics; this has been fixed.

{p 4 9 2}
{* enhancement}
18.  {help clogit} has new options {cmd:robust} and {cmd:cluster()}; see help
     {help clogit}.  In addition, {cmd:clogit} has been converted from a
     built-in command to one that now uses {help ml}.  As a result,
     {cmd:clogit} now supports options that are available to
     {cmd:ml}-programmed estimators, such as {cmd:constraint()} for linear
     constraints.

{p 4 9 2}
{* fix}
19.  When {help delimit:#delimit ;} was on, {cmd://} comment lines without a
     leading space resulted in an error; this has been fixed.

{p 4 9 2}
{* fix}
20.  {help factor:factor, ml} with collinear variables entered an endless
     loop.  Now it presents an error message.

{p 4 9 2}
{* fix}
21.  {help infix}, when incorrectly specified without {cmd:using}, caused
     Stata to crash; this has been fixed.

{p 4 9 2}
{* fix}
22.  {help kdensity} and {help twoway kdensity} exited with an uninformative
     error message when supplied with a variable that did not vary; this has
     been fixed.

{p 4 9 2}
{* fix}
23.  {help label variable} and {help label data}, when given a label longer
     than the maximum allowed label length, truncated the label without
     warning.  A warning message is now displayed.

{p 4 9 2}
{* fix}
24.  {help rotate} caused Stata to crash if a negative number was supplied in
     the {cmd:factor()} option; this has been fixed.

{p 4 9 2}
{* fix}
25.  {help score}, in rare cases, did not set the generated variable to a
     missing value in an observation where one or more of the variables
     involved in the preceding {help pca} command had missing values; this has
     been fixed.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
26.  When the Command window has the keyboard focus, you can press the Up or
     Down cursor keys in combination with the Shift key to scroll through the
     Results window a line at a time.  You can also press the Page Up and Page
     Down keys in combination with the Shift key to scroll through the Results
     window a page at a time.

{p 4 9 2}
{* fix}
27.  {help shell} could not pass quoted arguments to a program installed in a
     path containing a space; this has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
28.  The maximum number of controls in Stata's old-style dialog programming
     language has been raised to 300 to be consistent with the Windows and
     Unix (GUI) versions of Stata.  Stata users are still encouraged to use
     the new {help dialogs:dialog programming language} when programming
     dialogs, as the old-style dialogs have been deprecated.

{p 4 9 2}
{* fix}
29.  In some cases, the Graph window automatically resized beyond the
     resolution of the screen, preventing the window from being resized
     manually; this has been fixed.

{p 4 9 2}
{* fix}
30.  The zoom control in the window titlebar has been reworked so that the
     ideal window state for a window that is to be zoomed is optimal for the
     current window.  For example, clicking on the zoom box in the Results
     window or {help viewer:Viewer} will resize the window so that it is 80
     characters wide and uses the full height of the screen (adjusted to the
     nearest line height).  Clicking on the zoom control in the
     {help edit:Data Editor} will result in the editor taking up the whole
     screen.  Clicking on the zoom control in the Graph window will result in
     the current graph taking up as much of the screen as possible while
     maintaining the correct aspect ratio.  Clicking on the zoom control again
     will restore the window to its previous state.

{p 4 9 2}
{* fix}
31.  Printing from Stata could potentially lead to a crash; this has been
     fixed.

{p 4 9 2}
{* fix}
32.  When printing multiple pages from the {help doedit:Do-file Editor}, page
     margins after the first page were smaller on all sides; this has been
     fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
33.  A command that saved a file with a path having tilde "{cmd:~}" as the
     first character without the {cmd:replace} option overwrote the file
     without generating an error or warning; this has been fixed.

{p 4 9 2}
{* fix}
34.  (GUI) If a do-file was executed by starting Stata with command-line
     arguments, the scrollbar of the Results window would not be in sync with
     the number of lines outputted in the Results window; this has been fixed.

{p 4 9 2}
{* fix}
35.  (Console) If the terminal window in which a console version of Stata for
     Unix was running was resized, Stata did not recognize the new size of the
     window.  Stata now resets the line width and page length if the terminal
     window in which it is running is resized.


{hline 8} {hi:update 01jul2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help adjust} now allows the {cmd:pr} option after {cmd:binreg}; see help
    {help adjust}.

{p 5 9 2}
{* enhancement}
2.  {help _coef_table} is a new programmer's tool for displaying coefficient
    tables; see help {help _coef_table}.

{p 5 9 2}
{* enhancement}
3.  {help contract} has new options {cmd:cfreq()}, {cmd:percent()},
    {cmd:cpercent()}, {cmd:float}, and {cmd:format()} based on the user
    command {cmd:pcontract} written by Roger Newson, King's College, London;
    see help {help contract}.

{p 5 9 2}
{* fix}
4.  (Mac only) {help graph set} without any other arguments produced
    partial output followed by an error message; this has been fixed.

{p 5 9 2}
{* enhancement}
5.  The {help _tab} class is a new programmer's tool for displaying tables; see
    help {help _tab}.

{p 5 9 2}
{* enhancement}
6.  {help xtdes} has new option {cmd:width(}{it:#}{cmd:)} specifying the
    maximum width of the participation pattern display.  The default is 100;
    see help {help xtdes}.  The width of the pattern determines how many
    temporary variables {cmd:xtdes} creates.  With a large number of time
    points, {cmd:xtdes} failed when it exceeded the maximum number of
    variables allowed in Stata.  {cmd:width()} limits {cmd:xtdes} to a
    reasonable width.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* enhancement}
7.  String scalars are now supported; see help {help scalar}.  They are
    limited to a maximum length of a string in a string expression; see help
    {help limits}.

{p 5 9 2}
{* enhancement}
8.  The extended {help macro} function {cmd:all scalars} now allows
    {cmd:numeric} or {cmd:string} as a prefix to {cmd:scalars}; see help
    {help macro}.

{p 5 9 2}
{* enhancement}
9.  A warning note is displayed at startup if a new executable has been
    downloaded without a subsequent {help update:update swap} to replace the
    old executable with the new one.

{p 4 9 2}
{* enhancement}
10.  The limit for the number of dyadic operators in an expression has been
     increased from 200 to 500 for Intercooled Stata and
     {help SpecialEdition:Stata/SE}; see help {help limits}.

{p 4 9 2}
{* enhancement}
11.  {help smcl:SMCL} has a new directive,
     {cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}}, that is the same as
     {cmd:{c -(}center:}{it:text}{cmd:{c )-}}, except when there is an unequal
     number of spaces to be placed around the centered text.
     {cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}} places the extra space to the
     left of the text, moving the text to the right.
     {cmd:{c -(}center:}{it:text}{cmd:{c )-}} places the extra space to the
     right of the text, moving the text to the left; see help {help smcl}.

{p 9 9 2}
    Previously, {cmd:{c -(}center:}{it:text}{cmd:{c )-}} acted inconsistently.
    With a width argument, it placed the extra space on the right.  Without a
    width argument, it placed the extra space on the left.  Now, with or
    without a width argument, {cmd:{c -(}center:}{it:text}{cmd:{c )-}} places
    the extra space to the right.

{p 4 9 2}
{* fix}
12.  Raw {help smcl:SMCL} directives were sometimes displayed when help
     include ({cmd:.ihlp}) files were used; this has been fixed.

{p 4 9 2}
{* fix}
13.  If there are multiple errors in a {help dialog} programming {cmd:if}
     command, the first error is now reported rather than the last.

{p 4 9 2}
{* fix}
14.  {help stcox:stcox, basechazard()} produced incorrect estimates of the
     baseline cumulative hazard when the {cmd:efron} option for ties was
     specified; this has been fixed.

{p 4 9 2}
{* fix}
15.  {help summarize} with the {cmd:format} option now respects
     {help datetime:date formats}.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
16.  Pressing the alt key in combination with a character did not
     automatically open the appropriate menu from the main Stata window's
     menubar in some cases.  This has been fixed.

{p 4 9 2}
{* fix}
17.  Pressing the escape key sets the focus to the Command window when working
     with the {help viewer:Viewer}.

{p 4 9 2}
{* fix}
18.  Keyboard shortcuts now work when the mouse pointer is positioned over the
     variables window.

{p 4 9 2}
{* fix}
19.  (Windows 95/98/NT) When the {help doedit:do-file editor} was invoked, it
     might fill the entire screen or be placed beyond the screen (that is, not
     be shown); this has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
20.  In the past, Stata used Internet Config to determine the proper type and
     creator for new files it created based on the file extension; that is,
     files with an {cmd:.html} extension would have the creator set to Internet
     Explorer.  If a file does not have a type and creator, Mac OS X determines
     which application should open the file based on its extension.  However,
     Internet Config and Mac OS X do not always agree on which application
     should be associated with a file.  Stata now allows you to turn on or off
     Internet Config file mapping with the {help icmap:set icmap} command or
     through the General Preferences dialog.  The default setting is for
     Internet Config file mapping to be off; see help {help icmap}.

{p 4 9 2}
{* fix}
21.  Canceling a print job from the {help viewer:Viewer} or Results window
     caused error dialogs to be displayed for every page that was to be
     printed.  Stata now presents only one dialog when printing has been
     canceled.


{hline 8} {hi:update 24jun2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 4(2)}.

{p 5 9 2}
{* fix}
2.  {help bootstrap}, {help permute}, {help simulate}, and {help statsby} use
    the first 80 characters of {it:command} to label the resulting dataset.
    An error resulted if {it:command} was extremely long; this has been fixed.

{p 5 9 2}
{* fix}
3.  {help codebook} correctly recorded noninteger variables with date formats
    in {cmd:r(realdate)} but did not display the information in the output;
    this has been fixed.

{p 5 9 2}
{* enhancement}
4.  {help codebook_problems} and {help labelbook_problems} are new help files
    providing guidance for resolving the various problems diagnosed by the
    {cmd:problems} option of the {help codebook} and {help labelbook}
    commands.

{p 5 9 2}
{* enhancement}
5.  {help dfuller} has new option {cmd:drift} for testing the null hypothesis
    of a random walk with drift, corresponding to Hamilton's (1994) case
    three.  The algorithm for calculating MacKinnon's approximate p-values is
    now more accurate in cases where the p-value is relatively large.  See
    help {help dfuller}.

{p 5 9 2}
{* fix}
6.  {help egen:egen ... group(), label} exited with an error when
    {cmd:group()} variables shared the same {help label:value label}; this has
    been fixed.

{p 5 9 2}
{* fix}
7.  The {help graph dot} {cmd:rwidth()} option did not allow {cmd:*}{it:#}
    {help relativesize:{it:relativesize}} specifications; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help jknife} sometimes did not perform all replications when used with
    non-{cmd:eclass} commands and datasets with missing values; this has been
    fixed.

{p 5 9 2}
{* fix}
9.  {help ml} sometimes produced a missing model F statistic when fitting a
    model with an offset using survey data; this has been fixed.

{p 4 9 2}
{* enhancement}
10.  {help pperron} now calculates MacKinnon's approximate p-values more
     accurately when the p-value is relatively large.

{p 4 9 2}
{* fix}
11.  {help recode:recode {it:variable ...}, generate()} exited with an error
     when {it:variable} was of type {help datatype:long} or
     {help datatype:double}; this has been fixed.

{p 4 9 2}
{* fix}
12.  {help twoway area} now accepts the option {cmd:cmissing(n)} and
     interprets it to mean that missing values in the plotted data mark the
     end of an area and that the next set of nonmissing data begins a new,
     possibly disjoint, area.

{p 4 9 2}
{* fix}
13.  {help var} with panel data did not allow the {help by} prefix command;
     this has been fixed.

{p 4 9 2}
{* enhancement}
14.  {help xi} now allows the alternative (undocumented) syntax:

{p 13 13 2}
{cmd:xi} {it:term(s)} [{cmd:,} {cmdab:pre:fix:(}{it:string}{cmd:)}]

{p 4 9 2}
{* fix}
15.  {help xtline} did not allow the {cmd:recast()} option; this has been
     fixed.

{p 4 9 2}
{* fix}
16.  Some commands failed if the system used a temporary directory where the
     path contained spaces; this has been fixed.


{hline 8} {hi:update 18may2004} {hline}

{p 4 4 2}
The 18may2004 executable and ado update includes 60 changes and improvements.
We recommend that you read the entire numbered list below.  Highlights:

{p 9 12 2}
    o{space 2}The Windows interface has been improved.  The improvements
      include the ability to have the Review and Variables windows inside or
      outside the main Stata window; see #26 below and help {cmd:revwindow}.
      Also see items #25-47 below.

{p 12 12 2}
      The 18may2004 executable will not change the current settings of
      existing users of Stata.  To take advantage of some of the new
      improvements, you must change your window settings from the new
      Windowing tab on the General Preferences dialog or select Default
      Windowing from the Preferences menu.

{p 9 12 2}
    o{space 2}Windows and Mac dialog variable fields have a drop-down
      list containing the current variables.  See #42a and #48 below.

{p 9 12 2}
    o{space 2}{cmd:help} now allows include files and accepts spaces and
      trailing parentheses so that requests such as {cmd:help log()},
      {cmd:help mat acc}, and {cmd:help two conn} send you to the help for the
      {cmd:log()} function, {cmd:matrix accum} command, and
      {cmd:twoway connected} command, respectively.  See #10 below.

{p 9 12 2}
    o{space 2}{cmd:anova} is now faster and returns more items in {cmd:e()}.
      See #2 and #3 below and help {help anova}.

{p 9 12 2}
    o{space 2}{cmd:merge} and {cmd:append} now deal with {help notes}.  See
      #18 below and help {help merge} and {help append}.


    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help codebook}, {help labelbook}, and {help numlabel} now deal better
    with labels containing left-quote ({cmd:`}) characters.  See #15 below.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* enhancement}
2.  {help anova} with the {cmd:repeated()} option and the replay of all runs
    of {cmd:anova} are now much faster.

{p 5 9 2}
{* enhancement}
3.  {help anova} now returns additional items in {cmd:e()} -- {cmd:e(sstype)},
    {cmd:e(term_}{it:#}{cmd:)}, {cmd:e(ss_}{it:#}{cmd:)},
    {cmd:e(df_}{it:#}{cmd:)}, and {cmd:e(F_}{it:#}{cmd:)} for those terms
    where an F statistic is calculated.  When the test of a term does not
    involve residual error, the following are also returned
    {cmd:e(errorterm_}{it:#}{cmd:)}, {cmd:e(ssdenom_}{it:#}{cmd:)}, and
    {cmd:e(dfdenom_}{it:#}{cmd:)}.

{p 5 9 2}
{* fix}
4.  {help char:char rename}, a low-level programmer's command, created
    characteristics with duplicate names.  "{cmd:char rename} {it:old} {it:new}"
    did this if a characteristic with the same name appeared in both {it:old}
    and {it:new}.  This has been fixed; {cmd:char rename} now issues an error
    message in such cases.  A new option, {cmd:replace}, indicates that, in
    such cases, {it:old}{cmd:[}{it:name}{cmd:]} should replace
    {it:new}{cmd:[}{it:name}{cmd:]}.

{p 5 9 2}
5.  The {help edit:Data Editor} now has the following fixes and enhancements:

{p 9 12 2}
{* fix}
    a. A single value may be pasted into the edit field.  Doing so in the past
       renamed the currently selected cell's column.

{p 9 12 2}
{* fix}
    b. When a single cell is selected, right-clicking on any other cell with
       data will change the selection to the new cell before presenting a
       contextual menu.

{p 9 12 2}
{* fix}
    c. When scrolling to the right, Stata now scrolls into view a newly
       selected cell that is partially visible.  Previously, if a cell's right
       edge was even with the editor window's right edge (not including the
       vertical scrollbar), the Data Editor could not scroll further right;
       this has been fixed.

{p 9 12 2}
{* enhancement}
    d. Pressing Control-Home moves the cursor to the first row and column.
       Pressing Control-End moves the cursor to the last row and column with
       data.

{p 9 9 2}
    Also see #29, #36, #40, #41, and #47 for Windows enhancements and fixes to
    the Data Editor.  See #57 and #58 for Unix enhancements and fixes to the
    Data Editor.

{p 5 9 2}
{* fix}
6.  {help dialog} {cmd:PROGRAM} execution subcommand {cmd:stata} does not
    execute if Stata is running another command.  This prevents a dialog from
    breaking the currently running Stata command.

{p 5 9 2}
{* fix}
7.  A {help format:%g format} in rare cases caused the number 99.9999... to
    incorrectly display as 10; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help generate}, after {help clear} or {help drop:drop _all} and when
    creating a {help datatype:string} variable with fewer observations in the
    same position as a string variable that existed in the old dataset, put
    some of the string values from the old dataset in the new dataset.  This
    has been fixed.

{p 5 9 2}
{* enhancement}
{* fix}
9.  {cmd:gllamm} utility programs received cosmetic changes to support the
    current version of the user-written {cmd:gllamm} command; see
    {browse "http://www.gllamm.org"}.
    Most importantly, with aggregated binomial data, the log-likelihood
    reported by {cmd:gllamm} is now scaled to reflect the actual probability
    density.

{p 4 9 2}
10.  {help help} has the following fixes and enhancements:

{p 9 12 2}
{* enhancement}
    a. {cmd:.hlp} files may now include {cmd:.ihlp} files.  The syntax is
       {cmd:INCLUDE help} {it:argument}.  This includes the contents of the
       {it:argument}{cmd:.ihlp} file into the {cmd:.hlp} file.  The
       {cmd:INCLUDE help} directive must begin in the first column.

{p 9 12 2}
{* enhancement}
    b. Trailing parentheses "()" in the requested help argument are treated as
       a request for help for a function.  The trailing parentheses are
       removed, and "f_" is prepended to the request.  Typing {cmd:help log()}
       is equivalent to typing {cmd:help f_log} and provides help for the
       {cmd:log()} function, while typing {cmd:help log} provides help for the
       {cmd:log} command.

{p 9 12 2}
{* enhancement}
    c. Spaces and colons in the requested help argument are translated to
       underscores.  For example, {cmd:help graph intro} is equivalent to
       {cmd:help graph_intro}.

{p 9 12 2}
{* enhancement}
    d. Additional aliases have been added to allow command abbreviation.  For
       example, {cmd:help mat acc} is the same as {cmd:help matrix_accum},
       {cmd:help gr matrix} is the same as {cmd:help graph_matrix}, and
       {cmd:help tw con} is the same as {cmd:help twoway_connected}.

{p 9 12 2}
{* fix}
    e. Entering some of the {help viewer:Viewer} commands without arguments
       produced strange results.  For example, under the Unix GUI,
       entering "{cmd:search}" in the Viewer with no item to search for caused
       the Viewer to flash until an exhaustive search was finished.  Stata now
       returns help for the {cmd:search} command.  For example, entering
       "{cmd:search}" by itself is the same as entering "{cmd:help search}".
       Similarly, at the Stata command line, {cmd:whelp search} is equivalent
       to {cmd:whelp help search}.

{p 4 9 2}
{* fix}
11.  {help infile2:infile} with a dictionary specifying a nonexistent raw file
     presented a message indicating that the file did not exist even when the
     {cmd:using()} override option was specified with a file that did exist.
     Now, if the {cmd:using()} override option is specified and the file it
     names exists, the message is suppressed.

{p 4 9 2}
{* enhancement}
12.  {help insheet}'s {cmd:double} option is now the default if the
     {help set type:default data type} has been set to {cmd:double}.  You can
     specify the {cmd:nodouble} option to prevent this.  See help
     {help insheet}.

{p 4 9 2}
{* fix}
13.  {help insheet} with a using file containing a row of variable names with
     no data reported that -1 observation had been read into Stata.  This led
     to problems with other commands, such as {help describe}.  The problem
     has been fixed.

{p 4 9 2}
{* fix}
14.  {help label language} limited {it:languagename} to 8 characters.  Now the
     limit is 24 characters.

{p 4 9 2}
{* fix}
15.  {help label save} now escapes with a backslash all left-quote ({cmd:`})
     characters in labels as they are saved to the do-file so that they will
     be properly re-created when the do-file is executed.

{p 4 9 2}
{* enhancement}
16.  {help macro:macro extended functions} {cmd:rownames}, {cmd:colnames},
     {cmd:roweq}, {cmd:coleq}, {cmd:rowfullnames}, and {cmd:colfullnames} now
     accept references to matrices stored in {cmd:r()} and {cmd:e()}; see help
     {help matmacfunc}.

{p 4 9 2}
{* fix}
17.  {help matrix svd} produced different, but still correct, answers on
     different platforms.  One solution had columns that were the negative of
     the other solution.  Now, for each column of {it:V}, if the sum of the
     elements of the column is negative, the column is replaced by its
     negative, and the corresponding column of {it:U} is replaced by its
     negative.

{p 4 9 2}
{* enhancement}
18.  {help merge} and {help append} now incorporate all notes from the using
     dataset that do not already appear in the master dataset.  A new option,
     {cmd:nonotes}, ignores the notes in the using dataset which was the
     previous behavior.  See help {help merge} and {help append}.

{p 4 9 2}
{* fix}
19.  {help monthly()} time-series function with {cmd:"ym"} as the second
     argument produced missing values when months in the first argument were
     abbreviated; this has been fixed.

{p 4 9 2}
{* fix}
20.  {help tabulate} entered an endless loop when the linesize was set too
     small; this has been fixed.

{p 4 9 2}
{* fix}
21.  In rare circumstances, a hostname cached by Stata's internet-aware
     features was forgotten by Stata, resulting in an error message when
     contacting that host.  This has been fixed.

{p 4 9 2}
{* fix}
22.  Rarely, the Variables window displayed its variable names off by one row;
     this has been fixed.

{p 4 9 2}
{* fix}
23.  Edit--Copy Table did not eliminate separator lines consisting of
     "{cmd:-}" and "{cmd:+}" characters if the beginning of the line started
     with spaces; this has been fixed.

{p 4 9 2}
{* enhancement}
24.  The Schemes drop-down list on the Graph Preferences dialog now shows all
     available schemes.  Previously it showed only the original schemes
     shipped with Stata.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
25.  Stata now presents a dialog that allows you to save your data before
     exiting when there is unsaved data.

{p 4 9 2}
{* enhancement}
26.  You now can choose to have the Review and Variables windows inside or
     outside the main Stata window.  You can make the choice through the
     Windowing preferences in the General Preferences dialog or from the
     command line; see help {cmd:revwindow}.  The default preference places
     them inside the main Stata window.

{p 4 9 2}
{* enhancement}
27.  If the position preference of a floating Variables window, floating
     Review window, or {help doedit:Do-File Editor} window would place the
     window off the screen, Stata now moves the window completely into view at
     the closest screen edge when the window is shown.

{p 4 9 2}
{* enhancement}
28.  Pressing Control-Tab cycles forward through windows inside the main Stata
     window.  Pressing Control-Shift-Tab cycles through the windows in reverse
     order.

{p 4 9 2}
{* enhancement}
29.  A contextual menu has been added to the edit fields of the
     {help viewer:Viewer} and {help edit:Data Editor} windows that allows Cut,
     Copy, Paste, Clear, and Select All in the edit field.  Clicking on the
     edit field brings its respective windows to the front.

{p 4 9 2}
{* enhancement}
30.  The default font is now Lucida Console.  Stata now calculates the proper
     window sizes for the Results window and {help viewer:Viewer} window based
     on the default font.  The Review, Variables, and Command windows are then
     sized and positioned according to the size and position of the Results
     window.

{p 4 9 2}
{* enhancement}
31.  You may now scroll the Results window when it is the frontmost window by
     using the Up, Down, Page Up, Page Down, Home, and End keys.  Any
     character input is redirected to the Command window.

{p 4 9 2}
{* enhancement}
32.  The Home and End keys now scroll to the top or bottom of the current
     document in the {help viewer:Viewer} window.

{p 4 9 2}
{* enhancement}
33.  You can change the Results window scroll buffer size in the Preferences
     dialog.

{p 4 9 2}
{* enhancement}
34.  The Go To Line dialog in the {help doedit:Do-file Editor} now shows the
     current line number, as well as the total number of lines in the editor.

{p 4 9 2}
{* enhancement}
35.  If the Data, Graphics, or Statistics submenus of the User menu are empty,
     the empty submenu is disabled.

{p 4 9 2}
{* fix}
36.  The {help edit:Data Editor} and {help viewer:Viewer} edit fields strip
     font styles when pasting text so that only plain text is pasted in.

{p 4 9 2}
{* enhancement}
37.  Control-R is now a synonym for Page Up and retrieves the previous command
     from the command history.

{p 4 9 2}
{* fix}
38.  When the font size was increased in the Variables window, the Target text
     label's font also changed the next time Stata was launched; this has
     been fixed.

{p 4 9 2}
{* fix}
39.  Clicking in a blank area of the Review window entered random values into
     the Command window; this has been fixed.

{p 4 9 2}
{* enhancement}
40.  The {help edit:Data Editor} now supports Scroll Lock.  When Scroll Lock
     is on, pressing the cursor keys scrolls the Data Editor rather than
     moving the cursor within the edit field when the keyboard focus is on the
     edit field.

{p 4 9 2}
{* fix}
41.  The {help edit:Data Editor} only allowed you to copy data if there was
     more than one cell selected.  The Data Editor and Browser now allow
     single cell copies.

{p 4 9 2}
42.  {help dialog}s have the following fixes and enhancements:

{p 9 12 2}
{* enhancement}
    a. {help dialog} {cmd:VARLIST} and {cmd:VARNAME} controls are now
       drop-down lists that display the current variables.

{p 9 12 2}
{* enhancement}
    b. Keyboard shortcuts for Copy, Paste, and Cut now work within dialogs.

{p 9 12 2}
{* enhancement}
    c. Pressing the Return key is the same as clicking the {hi:OK} button.
       Pressing Shift+Return is the same as clicking {hi:Submit}.  Pressing
       the Escape key is the same as clicking {hi:Cancel}.

{p 9 12 2}
{* enhancement}
    d. Pressing the space bar when the keyboard focus is on a radio button now
       simulates a mouse click on the radio button.

{p 9 12 2}
{* enhancement}
    e. Keyboard arrow keys now function with dialog spinner controls.

{p 9 12 2}
{* fix}
    f. In {help dialog} programming, a {cmd:.setlabel} member function
       resulted in improperly drawn labels when used with a {cmd:CHECKBOX}
       control that was specified with the {cmd:groupbox} option; this has
       been fixed.

{p 4 9 2}
{* fix}
43.  {help graph export}, when writing large {cmd:emf} files, produced an
     empty file or a file in which the text on the graph had an incorrect
     font; this has been fixed.

{p 4 9 2}
{* fix}
44.  {help tabi}, in rare cases depending on processor, produced incorrect
     output for Fisher's exact test; this has been fixed.

{p 4 9 2}
{* fix}
45.  {help window menu} actions had quotes stripped from them; This has been
     fixed.

{p 4 9 2}
{* enhancement}
46.  (Windows XP) You may now disable the Windows XP theme in Stata, allowing
     some dialogs to load faster.  See help {help xptheme}.

{p 4 9 2}
{* fix}
47.  (Windows XP) The wheel mouse did not work in the {help edit:Data Editor},
     Review window, and Variables window; this has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
48.  {help dialog} {cmd:VARLIST} and {cmd:VARNAME} controls are now drop-down
     lists that display the current variables.

{p 4 9 2}
{* enhancement}
49.  Pressing shift+Return in a dialog is the same as selecting the
     {hi:Submit} button.

{p 4 9 2}
{* fix}
50.  Stata did not properly enable and disable the font size menu based on the
     frontmost active window; this has been fixed.

{p 4 9 2}
{* fix}
51.  Opening a do-file when the current contents of the
     {help doedit:Do-File Editor} have not been saved replaced its contents;
     this has been fixed.

{p 4 9 2}
{* fix}
52.  Changes to the graph {help scheme} in the Graph Preferences dialog were
     not saved between Stata sessions; this has been fixed.


    {title:Stata executable, Unix (GUI)}

{p 4 9 2}
{* enhancement}
53.  Control-Break can now be used to interrupt a Stata command.

{p 4 9 2}
{* enhancement}
54.  A Print Selection checkbox has been added to the print dialog for the
     Results and {help viewer:Viewer} windows when there is a selection.  If
     the checkbox is checked, only the selected text is printed.

{p 4 9 2}
{* enhancement}
55.  The default font for a graph has been changed from Times to Helvetica to
     be consistent with Stata for Windows and Stata for Mac, which
     default to sans-serif fonts.  This will not affect current users unless
     Default Windowing is selected from the Prefs menu.

{p 4 9 2}
{* enhancement}
56.  If the Data, Graphics, or Statistics submenus of the User menu are empty,
     the empty submenu is disabled.

{p 4 9 2}
{* enhancement}
57.  In the {help edit:Data Editor}, pressing the Home key moves the cursor to
     the first column in the current row.  Pressing the End key moves the
     cursor to the last column in the current row.  (Also see #5d, which
     discusses the actions of pressing Control-Home and Control-End.)

{p 4 9 2}
{* fix}
58.  Resizing the {help edit:Data Editor} when there was less than a screen's
     worth of data caused Stata to stop responding; this has been fixed.

{p 4 9 2}
{* fix}
59.  The {help dialog} {cmd:LISTBOX} control failed to appear; this has been
     fixed.

{p 4 9 2}
{* fix}
60.  Pressing the Page Up key while there was a --more-- condition caused the
     previous command to be entered into the command buffer; this has been
     fixed.


{hline 8} {hi:update 14may2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help adjust}'s {cmd:by()} option is no longer required; see help
    {help adjust}.

{p 5 9 2}
{* fix}
2.  {help ci} with the {help by:by ...:} prefix and both the {cmd:exposure()}
    and {cmd:total} options failed with an uninformative error message.  It
    now correctly executes.

{p 5 9 2}
{* enhancement}
3.  {help glm}, when fitting a binomial model with either a log or identity
    link, now issues a warning message when the estimated parameters produce
    predicted probabilities outside their admissible range of [0,1].  The
    warning is warranted for these two links since the linear predictor may be
    mapped outside [0,1].

{p 5 9 2}
{* fix}
4.  {help glm} with {cmd:family(binomial} {it:arg}{cmd:)}, when {it:arg} was
    greater than one, produced an incorrect BIC value; this has been fixed.

{p 5 9 2}
5.  {help ltable}'s {cmd:saving()} option did not accept filenames or paths
    containing spaces; this has been fixed.  Additionally, the dialog for
    {dialog ltable} has been reorganized.

{p 5 9 2}
{* fix}
6.  {help mvreg} now produces better error messages when the residual degrees
    of freedom are zero or the residual covariance matrix is singular.

{p 5 9 2}
{* fix}
7.  {help nptrend} now displays three decimal places for the p-value instead
    of two decimal places.  Also {cmd:nptrend} now preserves the sort order of
    the data.

{p 5 9 2}
{* fix}
8.  {help print} generated an error if the filename contained more than one
    period; this has been fixed.

{p 5 9 2}
{* fix}
9.  {help recode} with {it:rule}s involving
    {help missing:extended missing values}, such as {cmd:(.a/.y=999)}, did not
    treat extended missing values as most people would expect.  It now recodes
    the extended missing values as directed.

{p 4 9 2}
{* fix}
10.  {help svynbreg} with the {cmd:dispersion(constant)} option displayed
     incorrect misspecification effects; this has been fixed.

{p 4 9 2}
{* fix}
11.  {help tsfill} did not fill in the dataset if the size of the gap was
     larger than the maximum value that can be held by an {help int}; this has
     been fixed.

{p 4 9 2}
{* fix}
12.  {help xtabond} included invalid instruments when lags of the
     predetermined variables were included in the model.  This problem only
     arose when 1 or more lags of the predetermined variables were included in
     the model.  Thus, for q > 0, {cmd:xtabond , pre(x , lagstruct(q , .))}
     defined x_{{space 0}it} as predetermined instead of x_{it-q}, causing
     {cmd:xtabond} to produce inconsistent estimates.  This has been fixed.

{p 4 9 2}
{* fix}
13.  {help xtabond} included some instruments for predetermined variables
     beyond the limit specified in the {cmd:lagstruct()} option.  Assuming a
     correctly specified model, these extra instruments increased the
     asymptotic efficiency at the cost of some finite sample bias.  This has
     been fixed.


{hline 8} {hi:update 14apr2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help cii} with two arguments now allows the option {cmd:binomial} to be
    specified.  Exact binomial confidence intervals have always been the
    default in this case, and now the option can be specified explicitly.

{p 5 9 2}
{* fix}
2.  {help graph_box:graph box} and {help graph_box:graph hbox} did not plot
    outside values on the side where the adjacent value could not be
    determined; this has been fixed.

{p 5 9 2}
{* fix}
3.  {help graph_query:graph query} listed some available schemes twice, once
    as {it:schemename} and once as {cmd:scheme-}{it:schemename}.  Each scheme
    is now listed only once as {it:schemename}.

{p 5 9 2}
{* fix}
4.  {help graph_twoway:graph twoway} did not work properly with date and
    left-justified time-series {help format:formats}; this has been fixed.

{p 5 9 2}
{* enhancement}
5.  {help icd9} and {help icd9p} have been updated to use the V21 codes; V19,
    V18, and V16 codes were previously used.  V16, V18, V19, and V21 codes
    have been merged so that {cmd:icd9} and {cmd:icd9p} work equally well
    with old and new datasets.  See help {help icd9} for a description of
    {cmd:icd9} and {cmd:icd9p}; type "{stata icd9 query}" and
    "{stata icd9p query}" for a complete description of the changes to the
    codes used.

{p 5 9 2}
{* fix}
6.  {help ivreg} option {cmd:score()}, added with the 11mar2004 ado-file
    update, is now named {cmd:pscore()} to distinguish it as a projected
    score; see help {help ivreg}.

{p 5 9 2}
{* enhancement}
7.  {help ltable} option {cmdab:nota:b} is now {cmdab:nota:ble}; see help
    {help ltable}.

{p 5 9 2}
{* fix}
8.  {help ml:ml display} with the {cmd:level()} option did not produce
    confidence intervals using the specified confidence level for auxiliary
    parameters; this has been fixed.

{p 5 9 2}
{* enhancement}
9.  {help palette:palette color} has a new {cmd:cmyk} option specifying that
    color values be reported in CMYK rather than RGB.  The position of the
    color box, line, and symbols has also been shifted left to allow for
    longer color names.

{p 4 9 2}
{* fix}
10.  {help statsby} posted missing values when used with a command that did
     not allow the [{cmd:in} {it:range}] qualifier; this has been fixed.

{p 4 9 2}
{* fix}
11.  {help tssmooth_ma:tssmooth ma, window()} restricted the span of the filter
     too tightly for some unbalanced panel datasets; this has been fixed.

{p 4 9 2}
{* fix}
12.  {help xtpcse} could return a nonsymmetric matrix error message when there
     were a large number of regressors; this has been fixed.


{hline 8} {hi:update 22mar2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 4(1)}.

{p 5 9 2}
2.  {help mfx} now has the following fixes and enhancements:

{p 9 12 2}
{* enhancement}
    a. {cmd:mfx} has new options {cmd:varlist()}, {cmd:tracelvl()},
       {cmd:diagnostics()} and {cmd:nodrop}; see help {help mfx}.

{p 9 12 2}
{* enhancement}
    b. {cmd:mfx} is now much faster.

{p 9 12 2}
{* enhancement}
    c. The subcommand {cmd:compute} is now optional.

{p 9 12 2}
{* enhancement}
    d. The {cmd:at()} option now allows {it:numlist} and {it:matname}
       following multiple-equation estimation.  Entering 1 for the constant
       term(s) in {it:numlist} and {it:matname} is now optional.

{p 9 12 2}
{* enhancement}
    e. {cmd:mfx} performs a new check for the suitability of marginal effects
       calculation, and has improved the way it determines suitability for the
       linear method.

{p 9 12 2}
{* fix}
    f. {cmd:mfx} did not take into account offsets from the preceding
       estimation command.  Now marginal effect will be evaluated at the mean
       of any offsets.

{p 9 12 2}
{* fix}
    g. Occasionally {cmd:mfx} produced an error with time-series operators in
       the independent variable list; this has been fixed.

{p 9 12 2}
{* fix}
    h. Some standard errors of discrete variables were not computed due to a
       version-control problem; this has been fixed.

{p 9 12 2}
{* fix}
    i. {cmd:mfx} displayed "(no effect)" when the marginal effect was zero.
       Now {cmd:mfx} displays the zero marginal effect and the standard error,
       if any.

{p 9 12 2}
{* fix}
    j. {cmd:mfx} is now more responsive to the break key.

{p 5 9 2}
{* fix}
3.  {help stcurve:stcurve, survival}, after
    {help streg:streg ..., distribution(weibull) ...}, erroneously
    gave plots of S(t | t>1) rather than S(t); this has been fixed.

{p 5 9 2}
{* enhancement}
4.  {help stcurve}, after {help streg}, used by default the observed time
    values in the data as the x-variable in the resulting plot, yet if option
    {cmd:range()} were specified, {cmd:stcurve} plotted on an evenly spaced
    grid.  {cmd:stcurve} now always plots over an evenly spaced grid,
    producing smooth-looking curves even in small samples.

{p 5 9 2}
5.  {help truncreg} now has the following fixes and enhancements:

{p 9 12 2}
{* enhancement}
    a. {cmd:truncreg, marginal}, when used with dummy variables, calculates
    marginal effects for these variables, even though it is often more
    desirable to obtain the discrete change in the prediction as the dummy
    variable changes from 0 to 1.  When dummy variables are present, a message
    is now displayed describing how the discrete change(s) may be obtained
    using {help mfx}.

{p 9 12 2}
{* enhancement}
    b. {cmd:truncreg, marginal} now suppresses the display of a marginal
       effect for the constant (intercept) term, producing output more
       consistent with {help mfx}.

{p 9 12 2}
{* fix}
    c. {cmd:truncreg, marginal} gave incorrect standard errors for the
       estimated marginal effects; this has been fixed.

{p 9 12 2}
{* fix}
    d. {cmd:truncreg, marginal}, with {cmd:offset()}, fitted the base model,
       including the offset, but ignored the offset when marginal effects were
       calculated; this has been fixed.

{p 9 12 2}
{* fix}
    e. {cmd:truncreg}, with {cmd:offset()}, displayed the offset variable in
       both displayed equations, even though the offset applies only to the
       first.  {cmd:truncreg} now displays the offset variable only in the
       first equation.


{hline 8} {hi:update 11mar2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help cltree:cluster dendrogram} with the {cmd:labels()} option and either
    the {cmd:cutvalue()} or the {cmd:cutnumber()} option mislabeled the bottom
    leaves of the dendrogram; this has been fixed.

{p 5 9 2}
{* fix}
2.  {help est_table:estimates table} with the {cmd:label} option and with the
    {cmd:varwidth(}{it:#}{cmd:)} option greater than 32 truncated the
    displayed variable labels to 32.  It now truncates the variable labels to
    {it:#} characters.

{p 5 9 2}
{* fix}
3.  Graphics dialogs did not allow some {it:{help title_options}} and
    {it:{help textbox_options}} to be specified unless text was explicitly
    supplied.  Some statistical graphs and graph commands that accept
    {it:{help by_option:by_options}} have default text which could not be
    changed using graphics dialogs.  Graphics dialogs now allow
    {it:title_options} and {it:textbox_options}, even if text is not
    explicitly entered.

{p 5 9 2}
{* fix}
4.  {help histogram}, with both the {cmd:by()} and {cmd:normal} options,
    produced the same normal density graph for each by-group; this has been
    fixed.

{p 5 9 2}
{* enhancement}
5.  {help ivreg} now has the {cmd:score()} option; see help {help ivreg}.

{p 5 9 2}
{* fix}
6.  {help mfx} after {help svyheckman} did not produce standard errors for
    some of the {cmd:predict()} options; this has been fixed.

{p 5 9 2}
{* enhancement}
7.  monochrome {help schemes} now provide better default shading for
    {help sunflower} plots.

{p 5 9 2}
{* fix}
8.  {help glm:predict} after {help glm} failed when using the {cmd:modified}
    option; this has been fixed.

{p 5 9 2}
{* fix}
9.  {help regress:predict} with the {cmd:dfbeta} option after {help regress}
    did not label the created variable; this has been fixed.

{p 4 9 2}
{* fix}
10.  {help xtivreg:predict} with the {cmd:u} or {cmd:e} options exited with an
     error after {help xtivreg} when the varlist contained time-series
     operators; this has been fixed.

{p 4 9 2}
{* fix}
11.  {help varlmar}, with some sample restrictions, included data from the
     excluded sample in the auxiliary regressions instead of replacing this
     data with zeros; this has been fixed.

{p 4 9 2}
{* fix}
12.  {help zinb} with the {cmd:zip} option and no inflation variables,
     {cmd:inflate(_cons)}, produced an error; this has been fixed.


{hline 8} {hi:update 19feb2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help bstat} ignored the elements of a matrix supplied to the {cmd:stat()}
    option if the column names of the matrix did not match the variable names
    in the bootstrap dataset; this has been fixed.

{p 5 9 2}
{* fix}
2.  {help codebook} produced an error message when it encountered a labeled
    variable containing all missing values; this has been fixed.

{p 5 9 2}
{* fix}
3.  {help est_table:estimates table}, when used with the {cmd:keep()}
    option, required full specification of the coefficients to be kept; that
    is, {it:eqname:varname}, sometimes caused a confusing error message when
    only {it:varname} was specified.  Now, if you specify {it:varname} within
    {cmd:keep()}, {cmd:estimates table} assumes you are talking about
    {it:varname} from the first equation.

{p 5 9 2}
{* fix}
4.  {help graph}, using the {help textsizestyle} {cmd:quarter_tiny}, produced
    a warning message and incorrectly sized text; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help hausman} has a new warning message when the rank of the differenced
    covariance matrix is less than the number of coefficients being tested.

{p 5 9 2}
{* fix}
6.  {help histogram} with the {cmd:normal} option produced a normal density
    curve that did not cover the full range of the bars in the histogram; this
    has been fixed.

{p 5 9 2}
{* fix}
7.  {help histogram} sometimes plotted an extra bin to the left of what
    should be the minimum class bin when the input variable was of the type
    {help float}; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help palette:palette color}, when issued after Stata started or after
    a {cmd:discard} command and before issuing any {cmd:graph} commands or
    other {cmd:palette} commands, showed the RGB values for the specified color
    to be "255 255 255", regardless of the specified color.  This has been
    fixed.

{p 5 9 2}
{* fix}
9.  {help glm:predict ..., hat}, when used after {help glm}, gave incorrect
    values of leverage (hat diagonals) when a noncanonical link was used; this
    has been fixed.

{p 4 9 2}
{* fix}
10.  {help streg:predict ..., mean time}, when used after
     {help streg:streg ..., dist(gamma)}, gave incorrect results when the
     estimated kappa was less than zero due to the integral diverging with
     kappa < 0.  Now, missing values are generated, and a note is
     presented indicating the problem.

{p 4 9 2}
{* fix}
11.  {help dp:set dp comma} caused several subsequent commands to fail;
     this has been fixed.  The problem was that statements such as
     {cmd:local vv : display _caller()} created {cmd:vv} equal to "8,2"
     (notice the comma instead of decimal point).  The way to overcome this is
     to instead use the statement {cmd:local vv : display string(_caller())}.

{p 4 9 2}
{* fix}
12.  {help svygnbreg}, {help svyheckman}, {help svyheckprob}, {help svyintreg},
     {help svynbreg}, and {help svypoisson} ignored {cmd:if} and {cmd:in}
     specified in the {cmd:subpop()} option; this has been fixed.


{hline 8} {hi:update 30jan2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help cf} failed when the {it:filename} contained spaces; this is fixed.

{p 5 9 2}
{* fix}
2.  {help lincom} did not allow the {cmd:or}, {cmd:irr}, and {cmd:rrr} options
    after some {help svy} commands when they should have been allowed; this
    has been fixed.

{p 5 9 2}
{* fix}
3.  {help ltable}, after the 20jan2004 update, ignored some of the
    {it:{help twoway_options}} when producing a graph; this has been fixed.

{p 5 9 2}
{* fix}
4.  {help sts:sts graph} with the {cmd:tmin()} option did not restrict the
    graph appropriately; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help twoway}, {help scatter}, {help line}, {help tsline}, and
    {help xtline} failed if the caller's {help version} were set to 7 or
    earlier; this has been fixed.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
6.  {help generate}, used with time-series operators referring to the variable
    being created (for example, {cmd:generate newvar = l.newvar}), produced all
    missing values rather than issuing an error message; this has been fixed.

{p 5 9 2}
{* enhancement}
7.  {help graph} now has support for CMYK output to PostScript and
    Encapsulated PostScript (EPS) files.  This support includes the ability
    to convert RGB color values to CMYK color values on
    {help graph_export:export} and to specify either RGB or CMYK values
    wherever {help colorstyle}s are accepted, including options to
    {cmd:graph} and in {help schemes:scheme} files.  The new
    {help graph_export:graph export} {cmd:cmyk(on)} option allows either
    PostScript or EPS files to be created with CMYK color specifications.
    CMYK can be made the default conversion using {cmd:graph set ps cmyk on}
    and {cmd:graph set eps cmyk on}; see help {help graph_set:graph set}.

{p 9 9 2}
    Printing presses require CMYK color separations, and CMYK support is
    expected to be of greatest use to those using Stata graphics in books or
    other publications intended for large-scale printing.

{p 5 9 2}
{* enhancement}
8.  {help kdensity} has new option {cmd:epan2} providing an alternate
    Epanechnikov kernel; see help {help kdensity}.  Accordingly,
    {help sts:sts graph} and {help stcurve} now allow {cmd:kernel(epan2)} for
    specifying this kernel.

{p 5 9 2}
{* fix}
9.  {help postfile} set the created dataset {help label:data label} to the
    same as that of the dataset in memory.  The dataset label is now set to
    {cmd:""}.

{p 4 9 2}
{* fix}
10.  {help program:sortpreserve}, specified as an option to a user-written
     {help program} that both dropped some observations and added others
     (something valid for a {cmd:program} to do), caused Stata to enter an
     endless loop when it tried to restore the sort order of the modified
     data; this has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* fix}
11.  The Log button on the Toolbar did not reflect the status of the current
     log file; this has been fixed.

{p 4 9 2}
{* fix}
12.  Mac OS X 10.3.2 introduced a bug in Apple Type Services for Unicode
     Imaging (ATSUI) that sometimes caused text to be rendered incorrectly in
     the graph window.  Stata now bypasses ATSUI and draws text directly using
     the Quartz drawing engine.

{p 4 9 2}
{* fix}
13.  Mac OS X 10.3 introduced a bug where rectangles drawn in the graph window
     also drew extra lines.  The 15dec2003 update of Stata avoided this
     problem by drawing a rectangle as a path of four connected lines.  Mac OS
     X 10.3.2 fixed the problem, so Stata now draws a rectangle as it did
     before the 15dec2003 update.

{p 4 9 2}
{* fix}
14.  In {help dialogs:dialog} programs, depending on the order in which they
     were created, checkbox groupboxes within other checkbox groupboxes did
     not respond to mouse clicks; this has been fixed.  Also, a potential
     problem where groupboxes and frames could be obscured by larger
     groupboxes and frames has been fixed.

{p 4 9 2}
{* fix}
15.  Translating a SMCL file to a PDF file presented an error dialog for every
     line in the SMCL file and did not create the PDF file; this has been
     fixed.  In addition, when there is a printing error, the error dialog is
     only presented once for each unique error.

{p 4 9 2}
{* fix}
16.  {help graph_save:As-is} graphs were saved with the wrong file permissions
     when saved from the File menu or the Graph Window's contextual menu; this
     has been fixed.

{p 4 9 2}
{* fix}
17.  Stata does not support Unicode characters.  However, Stata attempts to
     open a file even if the path or filename contains Unicode characters.
     Previously, a failure to convert Unicode to ASCII could cause Stata to
     crash; this has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
18.  You can now enable or disable replacing existing Stata datasets when Save
     is selected from the File menu or activated by a shortcut.  From the
     General Preferences dialog, check or uncheck the checkbox "Overwrite
     existing data when saving".

{p 4 9 2}
{* fix}
19.  Pressing the Back button in the Viewer changed the pointer to a hand
     rather than an arrow; this has been fixed.

{p 4 9 2}
{* fix}
20.  (Linux only) {help odbc} failed to load the iODBC library on some
     systems; this has been fixed.  You no longer need to set
     {cmd:LD_LIBRARY_PATH} to work around the problem.


{hline 8} {hi:update 20jan2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help adjust} after an estimation command that used the {cmd:exposure()}
    option failed with a message such as "offset (ln(exposure)) not constant
    within by()", even when the {cmd:exposure()} variable was constant; this
    has been fixed.

{p 5 9 2}
{* fix}
2.  {help corr2data} and {help drawnorm} option {cmd:cstorage()}, added on
    06jan2004, read matrix elements by column instead of by row (as indicated
    in the hlp files); this has been fixed.

{p 5 9 2}
{* enhancement}
3.  {help ltable} has two new options, {cmd:overlay} and {cmd:saving()}; see
    help {help ltable}.

{p 5 9 2}
{* fix}
4.  {help mfp} ran its component estimation commands under version 6,
    sometimes causing incompatibilities; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help rreg} cleared {cmd:e()} before parsing its syntax so that statements
    such as {cmd:rreg ... if e(sample)} failed; this has been fixed.


{hline 8} {hi:update 06jan2004} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal 3(4)}.

{p 5 9 2}
{* fix}
2.  {help bootstrap}, {help jknife}, {help permute}, and {help statsby} exited
    with an error when used with a multiple-equation estimation command having
    no independent variables; this has been fixed.

{p 5 9 2}
{* enhancement}
3.  {help codebook}, {help labelbook}, and {help uselabel} have been enhanced
    to handle multiple-language variable and value labels (added in the
    09sep2003 update; see help {help label_language}).

{p 5 9 2}
{* enhancement}
4.  {help codebook} has a new option, {cmd:languages()}, for selecting the
    languages to be reported in the codebook; see help {help codebook}.

{p 5 9 2}
{* enhancement}
5.  {help corr2data} and {help drawnorm} now support triangular specification
    of the correlation or covariance matrix.  See the discussion of the new
    {cmd:cstorage()} option in help {help corr2data} and {help drawnorm}.

{p 5 9 2}
{* enhancement}
6.  {help corr2data} has a new option, {cmd:seed()}; see help {help corr2data}.

{p 5 9 2}
{* fix}
7.  {help estimates:estimates store} {it:name} failed if variable
    {cmd:_est_}{it:name} already existed; this has been fixed.

{p 5 9 2}
{* fix}
8.  {help graph}'s [{cmd:x}|{cmd:y}]{cmd:label(alternate)} options were not
    respected after the 03dec2003 update; this has been fixed.

{p 5 9 2}
{* fix}
9.  {help graph_bar:graph bar} failed when three {cmd:over()} options were
    specified and each {cmd:over()} option included a {cmd:sort()} suboption.
    This also happened when {cmd:yvaroptions()} with a {cmd:sort()} suboption
    was combined with one or more {cmd:over(, sort())} options.  This has been
    fixed.

{p 4 9 2}
{* fix}
10.  {help graph_bar:graph bar}, {help graph_box:graph box}, and
     {help graph_dot:graph dot} produced an error message when used with a
     {cmd:by()} option that included a suboption containing a quoted string
     consisting of a single blank character (for example,
     {cmd:graph bar mpg, by(rep78, note(" "))}).  This has been fixed.

{p 4 9 2}
{* fix}
11.  {help graph_display:graph display}'s {cmd:scheme()} option failed after
     the 03dec2003 update; this has been fixed.

{p 4 9 2}
{* fix}
12.  {help graph_matrix:graph matrix} failed with any of the following
     options:  {cmd:ysize()}, {cmd:xsize()}, {cmd:name()}, {cmd:scheme()},
     {cmd:saving()}, {cmd:fxsize()}, or {cmd:fysize()} after the 15dec2003
     update; this has been fixed.

{p 4 9 2}
{* fix}
13.  {help graph_pie:graph pie}, in rare cases, did not allow the {cmd:over()}
     and {cmd:by()} options to be combined after the 03dec2003 update; this
     has been fixed.

{p 4 9 2}
{* fix}
14.  {help graph_twoway:graph twoway} options {cmd:tline()} and {cmd:ttext()}
     caused an error when the time variable contained a {cmd:%d} format; this
     has been fixed.

{p 4 9 2}
{* fix}
15.  {help lookfor} failed when left single quotes were part of a
     {help label:variable label}; this has been fixed.

{p 4 9 2}
{* fix}
16.  {help merge} with no arguments (an illegal syntax) froze the operation
     until break was pressed after the 15dec2003 update; this has been fixed.

{p 4 9 2}
{* enhancement}
17.  {help ml} has two new subcommands, {cmd:ml} {cmd:hold} and {cmd:ml}
     {cmd:unhold}, see help {help ml_hold}.  We acknowledge the helpful
     suggestions of Mead Over, The World Bank.

{p 4 9 2}
{* enhancement}
18.  {help recode} now produces more informative error messages if value labels
     are not expected.

{p 4 9 2}
{* fix}
19.  {help svmat} with the {cmd:names(col)} command now displays an
     informative error message when one of the matrix column names is
     {cmd:_cons}.

{p 4 9 2}
{* fix}
20.  {help uselabel} failed with long value labels; this has been fixed.


{hline 8} {hi:update 15dec2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help arch} and {help arima} help have been updated to document the
    {cmd:vce()} and {cmd:technique()} options, which are preferable to the
    older method of specifying {cmd:hessian}, {cmd:opg}, {cmd:bhhh},
    {cmd:bfgs}, {cmd:dfgs}, {cmd:dfp}, {cmd:nr}, {cmd:bhhhbfgs()}, or
    {cmd:bhhhdfp()}.  These older options continue to work but are now
    undocumented.

{p 5 9 2}
{* enhancement}
2.  Estimation command dialogs now have an improved layout.

{p 5 9 2}
{* fix}
3.  {help graph_box:graph box} and {help graph_box:graph hbox} did not allow
    you to label the outside values using the same variable being graphed;
    this has been fixed.

{p 5 9 2}
{* enhancement}
4.  {help maximize} help has been updated to document {cmd:vce(oim)}, which is
    an alias to the older {cmd:vce(hessian)} option, which continues to work.

{p 5 9 2}
{* fix}
5.  {help ml} exited with an error when no dependent variables were specified;
    this has been fixed.

{p 5 9 2}
{* enhancement}
6.  {help orthog} now accepts time-series operators; see help {help orthog}.

{p 5 9 2}
{* enhancement}
7.  {help svyset} now accepts the {cmd:srs} option, indicating that the data
    come from a simple random sample; see help {help svyset}.

{p 5 9 2}
{* enhancement}
8.  All {help svy} estimation commands allow an extended syntax for the
    {cmd:subpop()} option; the extended syntax is

{p 13 20 2}
        {cmd:subpop(}[{it:varname}] [if {it:exp}] [in {it:range}] [,
        {cmdab:srs:subpop}]{cmd:)}

{p 9 9 2}
    {cmdab:srs:subpop} can still be specified outside the {cmd:subpop()}
    option (this old syntax will no longer be documented).  This extension is
    also available in {help svymean}, {help svytotal}, {help svyratio},
    {help svyprop}, and {help ml}.


    {title:Stata executable, all platforms}

{p 5 9 2}
{* fix}
9.  {help by} with the illegal syntax
    {cmd:by (}{it:variables}{cmd:) :} {it:cmd}
    now stops and returns an error message and a 198 return code.  Previously,
    it produced incorrect results.

{p 4 9 2}
{* enhancement}
10.  {help creturn:c()} has the following new items:

	     {cmd:c(Wdays)}       "Sun Mon ... Sat"
	     {cmd:c(Weekdays)}    "Sunday Monday Tuesday ... Saturday"

{p 9 9 2}
     See help {help creturn:creturn}.

{p 4 9 2}
{* fix}
11.  {help filefilter}, when presented with identical filenames for
     {it:oldfile} and {it:newfile} and with the {cmd:replace} option, deleted
     the file and returned an error message.  Now, it returns an error message
     and does not affect the file.

{p 4 9 2}
{* fix}
12.  {help list:list *}, after running an estimation command, displayed an
     extra variable named "{cmd:(e)}"; this has been fixed.

{p 4 9 2}
{* enhancement}
13.  {help merge} now accepts multiple using files, and a {cmd:nosummary}
     option has also been added; see help {help merge}.

{p 4 9 2}
{* fix}
14.  {help nlist:numlist} now allows a longer input {it:{help numlist}}.

{p 4 9 2}
{* fix}
15.  {help odbc} can now connect to IBM Red Brick databases.  This fix
     involved removing any unnecessary spaces from the connection string, even
     though ODBC syntax allows spaces.

{p 4 9 2}
{* fix}
16.  {help odbc:odbc insert} now converts Stata {help missing:missing values}
     to NULL prior to insertion.

{p 4 9 2}
{* enhancement}
17.  {help rotate} now has a stricter convergence tolerance.  Previously, the
     undocumented {cmd:ltolerance()} option defaulted to
     {cmd:ltolerance(0.0001)}.  It now defaults to
     {cmd:ltolerance(0.00000001)}.  You can specify {cmd:ltolerance(0.0001)}
     to obtain the old setting.

{p 4 9 2}
{* fix}
18.  {help tabulate} reported frequencies without commas (for example, 12345
     rather than 12,345) even when there was still room in the table to include
     commas.  {cmd:tabulate} now reports numbers with commas if there is room
     in the table.

{p 4 9 2}
{* enhancement}
19.  {help trace} has a new setting, {cmd:set tracehilite}, that highlights a
     specified pattern in the trace output.  See help {help trace}.

{p 4 9 2}
{* fix}
20.  {cmd:test} after {cmd:anova} crashed Stata when presented with the
     illegal syntax {cmd:test} {it:term} {cmd:/} (that is, nothing following the
     "{cmd:/}").  Now, it displays a syntax error message and gives a 198
     return code.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
21.  When the overall magnification on the Printer tab of the Graph
     Preferences was changed from 100%, fonts did not print at the right size;
     this has been fixed.

{p 4 9 2}
{* fix}
22.  (Windows XP) dialog combo boxes that were supposed to allow multiple
     selections did not always allow more than one selection; this is fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
23.  {help odbc} now uses runtime linking to ensure the latest Apple runtime
     support for ODBC; see help {help odbc}.

{p 4 9 2}
{* fix}
24.  Mac OS X 10.3 introduced a bug that causes some of Stata's graphs to
     display extra lines when the Graph window is of a certain size or
     smaller.  Stata now avoids using the OS X drawing command that causes the
     extra lines to be drawn.

{p 4 9 2}
{* fix}
25.  If there is more than 32K of text in the Clipboard, Stata will no longer
     attempt to copy the data into its local scrap area when Stata is brought
     to the foreground.


    {title:Stata executable, Unix}

{p 4 9 2}
{* enhancement}
26.  Scrollwheel support has been added to the Unix GUI.

{p 4 9 2}
{* enhancement}
27.  The {help edit:Data Editor} now supports the Page Up and Page Down keys
     for scrolling.

{p 4 9 2}
{* fix}
28.  {help log} did not recognize {cmd:~/} to mean the user's home directory;
     this has been fixed.


{hline 8} {hi:update 03dec2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help cnsreg} now accepts time-series operators; see help {help cnsreg}.

{p 5 9 2}
{* enhancement}
2.  {help graph} has improved control over whether the largest and smallest
    possible grid lines are drawn.  This control is provided by improving the
    actions of the existing suboptions [{cmd:no}]{cmd:gmin} and
    [{cmd:no}]{cmd:gmax}.

{p 5 9 2}
{* enhancement}
3.  {help graph} areas such as {help title_options:boxed titles} and
    {help legend_options:legends} now recognize suboptions {cmd:lstyle(none)},
    {cmd:lwidth(none)}, {cmd:lcolor(none)}, and {cmd:lpattern(blank)} to mean
    that no line is to be drawn around the area.

{p 5 9 2}
{* fix}
4.  {help axis_label_options:graph axis labeling options} did not allow some
    legal forms of {it:numlist}; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help graph_pie:graph pie}, in the unusual case when options {cmd:by()}
    and {cmd:over()} and an {cmd:if} condition were specified, and when no
    variables were specified, included all {cmd:over()} categories in the
    legend, even if some were completely excluded by the {cmd:if} condition.
    Now, such categories are excluded from the legend.

{p 5 9 2}
{* fix}
6.  {help graph_twoway:graph twoway}, when two plots were plotted on a
    different x or y axis and when the option {cmd:plotregion(margin())} was
    also specified, did not apply the specified margin to the second plot.
    This has been fixed.

{p 5 9 2}
{* fix}
7.  {help graph_twoway:graph twoway} with {help axis_label_options:grids},
    {help added_line_options:xlines}, and {help added_line_options:ylines} on
    complicated graphs and with multiple x axes or y axes could, in rare
    cases, overlay the grids (or xlines or ylines) on top of the plots.
    Grids, xlines, and ylines now always appear behind the plots.

{p 5 9 2}
{* fix}
8.  {help hotelling} now mentions and drops collinear variables before
    computing Hotelling's T-squared.  Previously, the T-squared value was
    correct, but the degrees of freedom, and hence the resulting F test and
    p value, were incorrect when there were collinear variables.

{p 5 9 2}
{* enhancement}
9.  {help impute} has a new option {cmd:nomissings()}; see help {help impute}.

{p 4 9 2}
{* enhancement}
10.  {dialog iri}, {dialog csi}, {dialog cci}, and {dialog mcci} dialogs now
     allow you to input numbers up to 10,000,000.

{p 4 9 2}
{* fix}
11.  {help loneway} with {cmd:aweights} and more than 375 groups produced
     incorrect results; this has been fixed.

{p 4 9 2}
{* enhancement}
12.  {help lookfor} is now faster and has more detailed error messages.

{p 4 9 2}
{* fix}
13.  {help recode} mistakenly reported rule-overlap warnings in some cases;
     this is fixed.

{p 4 9 2}
{* fix}
14.  {help reshape} now provides a more detailed error message when the {it:j}
     variable takes on too many values.

{p 4 9 2}
{* enhancement}
15.  {help sts:sts graph} has two new options, {cmd:atriskopts()} and
     {cmd:lostopts()}, that affect how the labels for at-risk and lost
     observations are rendered; see help {help sts}.

{p 4 9 2}
{* fix}
16.  {help sunflower} produced graphs with colors even when supplied with a
     monochrome scheme;  this has been fixed.

{p 4 9 2}
{* fix}
17.  {help xpose} with the {cmd:varname} option when executed three times
     produced the error message "v1 already defined"; this has been fixed.


{hline 8} {hi:update 05nov2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help ml} and all estimators that use {cmd:ml} by default now check
    convergence using the {cmd:nrtolerance()} convergence criterion:
    g*inv(H)*g'; see help {help maximize}.  This is a true convergence
    criterion that ensures that the gradient is numerically 0 when scaled by
    the Hessian -- the shape of the likelihood or pseudolikelihood surface at
    the optimum.  This new default of {cmd:nrtolerance(1e-5)} was added
    because researchers are programming more likelihoods that have surfaces
    that are difficult to optimize.  It is also an improvement over the
    {cmd:gtolerance()} criterion that was added in Stata 7 to help ensure
    convergence of {help arch} and {help arima} models.

{p 9 9 2}
    In rare cases, this change may cause models that previously stopped
    iterating without converging to continue iterating and, in extremely rare
    cases, to continue iterating to the limit of 16,000 if convergence cannot
    be achieved.  {cmd:nrtolerance()} can be turned off with the new
    {cmd:nonrtolerance} option; see help {help maximize}.


{hline 8} {hi:update 31oct2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help graph_bar:graph bar}, {help graph_dot:graph dot},
    {help graph_box:graph box}, and {help graph_pie:graph pie} when used with
    both options {cmd:by()} and {cmd:over()} and when {cmd:if} conditions were
    specified included all {cmd:over} categories in the legend, even if some
    were completely excluded by the {cmd:if} condition.  Now, such categories
    are excluded from the legend.

{p 5 9 2}
{* fix}
2.  {help sampsi} with the {cmd:method(ancova)} option could return an
    incorrect result when {cmd:r1()} or {cmd:r01()} was specified with a
    negative number.  This has been fixed.


    {title:Stata executable, Windows}

{p 5 9 2}
{* fix}
3.  The change listed in item #49 in the 28oct2003 update had the unintended
    side-effect of setting the scroll position of the Do-file Editor to the
    top of the window.  In addition, an 'undo' was not possible after pasting
    text into the editor.  This has been fixed.


    {title:Stata executable, Mac}

{p 5 9 2}
{* fix}
4.  Due to the 28oct2003 update Stata 8 preferences were mistakenly saved as
    the file "Stata Preferences" rather than "Stata 8 Preferences"; this has
    been fixed.

{p 5 9 2}
{* fix}
5.  Stata failed to uncompress downloaded updates if the path to Stata had a
    space in it; this has been fixed.

{p 5 9 2}
{* fix}
6.  The Viewer window would draw text on top of the scrollbar while the window
    was being resized in Mac OS X 10.3; this has been fixed.


{hline 8} {hi:update 28oct2003} {hline}

    {title:What's new in release 8.2 (compared to release 8.1)}

{p 5 9 2}
{* enhancement}
1.  (Windows only) {help haver:haver use} and {help haver:haver describe} are
    new commands for loading data from Haver Analytics
    ({browse "http://www.haver.com/"}) database files.  See help {help haver}.

{p 5 9 2}
{* enhancement}
2.  {help odbc} has a new subcommand, {cmd:sqlfile}, for batch processing of
    SQL text files; see help {help odbc}.

{p 5 9 2}
{* enhancement}
3.  The default axis titles have changed for {help graph_twoway:graph twoway}.
    Previously, if more than one variable was plotted on an axis, the axis
    showed the labels or variable names of the variables.  Now, in such cases,
    no axis title is drawn, and the variables are identified in the legend by
    default.  The original behavior can still be obtained by setting the
    version to less than 8.2, for example, typing
    {cmd:version 8.1: graph twoway} {it:...}; see help {help version}.

{p 5 9 2}
{* enhancement}
4.  (Mac only) The Stata for Mac executable format has been
    changed from a single executable to Mac OS X's preferred executable
    format, an Application Package.  Although you can still launch Stata from
    the Finder by double-clicking the application from the Stata folder,
    launching Stata from a terminal or shell script will require a minor
    change.  If Stata is installed in /Applications/Stata, the path to the
    Stata executable as a single executable was /Applications/Stata/StataSE
    (for Stata/SE).  The path to the Stata executable as part of an
    Application Package is now
    /Applications/Stata/StataSE.app/Contents/MacOS/StataSE.

{p 5 9 2}
{* enhancement}
5.  (Mac only) A window- and screen-edge snap feature has been added
    that can be set using the general preferences dialog.  When you move or
    resize a Stata window, it will snap to the nearest edge of the frontmost
    and closest Stata window or to the edge of the screen.  Holding down the
    Option key while dragging the window disables this feature.  The gap
    between the windows they will snap to can be set.

{p 5 9 2}
{* enhancement}
6.  (Mac only) You can move all of Stata's currently open windows at the
    same time by holding down the Control key while dragging any of Stata's
    windows.  This will also bring all of Stata's currently open windows to the
    foreground.  The screen-edge snap feature can be disabled by also holding
    down the Option key.

{p 5 9 2}
{* enhancement}
7.  (Windows only) In the Do-file Editor, Ctrl+Shift+D has been added as a
     keyboard shortcut for the menu item "Tools--Do to bottom".

{p 5 9 2}
8.  Recommendation on setting version at the top of do-files and ado-files:
    Use {cmd:version 8.2}.  {cmd:version 8.2} adds new features and changes
    the default behavior of axis titles for {help graph_twoway:graph twoway}.
    (Setting {cmd:version 8.1} restores {cmd:graph twoway}'s old behavior.)
    See help {help version}.


    {title:Other additions and fixes}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
9.  {help fillin}, {help means}, {help recast}, {help tab1}, and {help tab2}
    are now a little faster.

{p 4 9 2}
{* enhancement}
10.  {help graph} axes with automatically generated or rule-specified tick
     labels (see help {help axis_options}) could on rare occasions display a
     tick at the value 0 as an exponential value very close to zero, for
     example, .11e-219.  This is now even more unlikely.

{p 4 9 2}
{* enhancement}
11.  {help graph} legends have more precise alignment between keys and their
     labels.  The legends also adjust to accommodate large symbols used as
     keys.

{p 4 9 2}
{* fix}
12.  {help legend_options:Legends for graphs} now accept any valid
     {help relativesize:relative size} in the suboptions {cmd:rowgap()},
     {cmd:colgap()}, {cmd:keygap()}, {cmd:symxsize()}, and {cmd:symysize()}.

{p 4 9 2}
{* enhancement}
13.  {help graph_bar:graph bar}, {help graph_dot:graph dot},
     {help graph_box:graph box}, and {help graph_pie:graph pie} have a new
     option {cmd:allcategories} specifying that the legend is to include all
     {cmd:over()} groups in all the dataset, not just groups in the sample
     specified by {cmd:if} and {cmd:in}.

{p 4 9 2}
{* fix}
14.  {help graph_bar:graph bar}, {help graph_dot:graph dot},
     {help graph_box:graph box}, and {help graph_pie:graph pie}, when used
     with both options {cmd:by()} and {cmd:over()} when
     different by groups contained different subsets of over groups,
     could produce legends that were not correct for all the by graphs.
     This has been fixed.

{p 4 9 2}
{* fix}
15.  {help graph_bar:graph bar} with options {cmd:stack} and
     {cmd:blabel(total)} did not show correct totals.  This has been fixed.
     Note that horizontal bar charts {help graph_bar:graph hbar} always showed
     correct totals.

{p 4 9 2}
{* fix}
16.  {help graph_combine:graph combine} options {cmd:xcommon} and
     {cmd:ycommon} "stuck" when specified; that is to say, subsequent graphs
     would be drawn as though the option were specified, even if it were not.
     This has been fixed.

{p 4 9 2}
{* fix}
17.  {help graph_combine:graph combine} did not respect the rescaling of the
     original graph axes when this rescaling was done with the {cmd:range()}
     suboption of the {cmd:xscale()}, {cmd:yscale()}, or {cmd:tscale()}
     options.  It now respects these rescalings.

{p 4 9 2}
{* fix}
18.  {help graph_dot:graph dot} options {cmd:linetype()},
     {cmd:lowextension()}, and {cmd:highextension()} "stuck" when specified;
     that is to say, subsequent graphs would be drawn as though the option
     were specified, even if it were not.  This has been fixed.

{p 4 9 2}
{* fix}
19.  {help graph_pie:graph pie} mislabeled the pie slices when the option
     {cmd:sort} was combined with {cmd:plabel(}{it:...} {cmd:name)}.  This has
     been fixed.  Note that this does not apply to options
     {cmd:plabel(}{it:...} {cmd:sum)}, {cmd:plabel(}{it:...}  {cmd:percent)},
     and {cmd:plabel(}{it:...} {cmd:"text")}, which have always produced
     correct labels.

{p 4 9 2}
{* fix}
20.  {help graph_pie:graph pie} when the {cmd:sort} and {cmd:by()} options are
     specified together now draws individual legends for each graph so that
     the pie slice colors are correctly identified for each graph.

{p 4 9 2}
{* fix}
21.  {help hetprob} stopped with an error message when used with the
     {cmd:technique()} option, for techniques other than Newton-Raphson; this
     has been fixed.

{p 4 9 2}
{* fix}
22.  {help ir} rounded the time at risk to the nearest integer, causing a
     potential loss of precision; this has been fixed.

{p 4 9 2}
{* fix}
23.  {help ksmirnov} was not preserving the sort order of the data; this has
     been fixed.

{p 4 9 2}
{* fix}
24.  {help lowess} stopped with an error when a {cmd:legend()} option was
     supplied within the {cmd:by()} option; this has been fixed.

{p 4 9 2}
{* fix}
25.  The dialogs for {dialog lowess} and {dialog spikeplot} incorrectly
     allowed the {cmd:missing} and {cmd:total} options to be used with
     {cmd:by}; this has been fixed.

{p 4 9 2}
{* fix}
26.  {cmd:predict} after {help ologit} and {help oprobit} would assign a value
     of zero to the linear predictor when there were no model degrees of
     freedom.  {cmd:predict} now sets the linear predictor to missing in this
     case to avoid misleading results.

{p 4 9 2}
{* fix}
27.  {help statsby} failed if the number of statistics to be collected were
     larger than approximately 65.  This limit has been increased so that the
     number of statistics allowed by {cmd:statsby} is virtually unlimited.

{p 4 9 2}
{* enhancement}
28.  {help stmc}'s {cmd:compare()} option now has a minimum allowed
     abbreviation of {cmd:c()}.  This matches {cmd:stmc}'s companion command
     {help stmh}.

{p 4 9 2}
{* fix}
29.  The 09sep2003 update of {help sts:sts graph} overrode the 03jun2003
     update that had the {cmd:yscale(log)} option only graphing nonzero
     values.  This fix has been restored.

{p 4 9 2}
{* enhancement}
30.  {help sunflower} has a new option {cmd:nosinglepetal}, see help
     {help sunflower}.

{p 4 9 2}
{* fix}
31.  {help twoway_rbar:twoway rbar} and {help twoway_rarea:twoway rarea} now
     fully respect line patterns set by the {cmd:blpattern()} option.

{p 4 9 2}
{* fix}
32.  {help xtabond} refused to estimate AR(1) models with only three data
     points; this has been fixed.

{p 4 9 2}
{* fix}
33.  {help xtabond} incorrectly labeled the output when predetermined
     variables were dropped because of collinearity; this has been fixed.

{p 4 9 2}
{* fix}
34.  {help xtdes} gave an error message when presented with data where the
     time variable included negative values; this has been fixed.

{p 4 9 2}
{* fix}
35.  {help xtreg:xtreg, re} produced erroneous results if the same independent
     variable were specified twice; this has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* enhancement}
36.  {help encode} has new {cmd:noextend} option that modifies the existing
     {cmd:label()} option; see help {help encode}.

{p 4 9 2}
{* fix}
37.  {help ereturn:ereturn matrix} no longer allows you to post matrices
     named {cmd:b} or {cmd:V}.  The correct method for posting these matrices
     is with the {cmd:ereturn post} or {cmd:ereturn repost} commands.

{p 4 9 2}
{* enhancement}
38.  {help graph_pie:graph pie} in the degenerate case of only one slice drew
     a line from the center to the top.  This has been fixed.

{p 4 9 2}
{* enhancement}
39.  A new {help macro:macro extended function}, {cmd:all}, allows programmers
     to obtain a list of currently defined global macros, scalars, or
     matrices; see help {help macro}.

{p 4 9 2}
{* enhancement}
40.  {cmd:`macval(.a.b.c)'}, when specified at the top level of macro
     expansion, causes the class reference {cmd:.a.b.c} to be macro expanded
     only once, so that after expansion the result is not macro expanded.
     This extends the functionality of the expansion operator {cmd:macval()}
     to class system references.

{p 4 9 2}
{* fix}
41.  {help merge}'s {cmd:uniqusing} option failed to issue an error message
     when the using data contained nonunique values in the match variable(s)
     if the master data also contained nonunique values in the match
     variable(s); this has been fixed.

{p 4 9 2}
{* fix}
42.  {help odbc:odbc describe} caused a "cursor error" with Microsoft ODBC
     drivers; this has been fixed.

{p 4 9 2}
{* fix}
43.  {help odbc} dialog connection options now allow previously saved
     usernames and passwords to be loaded by the MySQL driver.

{p 4 9 2}
{* fix}
44.  {help odbc:odbc insert} caused internal buffer overflow in the SQL
     statements used to feed data to the driver; this has been fixed.

{p 4 9 2}
{* fix}
45.  {help search} when executed in the Viewer on rare occasions incorrectly
     reported no results; this has been fixed.

{p 4 9 2}
{* fix}
46.  If an invalid syntax element such as {cmd:xyz(,abc)} were specified in
     the varlist portion of a command, Stata could crash.  More specifically,
     if what appeared to be an option that included a comma were specified
     where a varlist was expected and the invalid command was parsed with the
     {help syntax} command, Stata could crash.  This has been fixed.

{p 4 9 2}
{* fix}
47.  {help update} now clears all cached programs from memory.  This ensures
     that the updated programs will be loaded instead of Stata remembering the
     older version.

{p 4 9 2}
48.  Note to programmers:  For holding on to the caller version, use
     {cmd:local ver : display _caller()} instead of
     {cmd:local ver = _caller()}.  The first method places "8.2" in local
     macro {cmd:ver}, while the second places "8.199999999999999".  A
     subsequent call to {cmd:version `ver'} would fail with the second method.


    {title:Stata executable, Windows}

{p 4 9 2}
{* fix}
49.  Rich text copied into the Do-file Editor could change the font and color
     in the Do-file Editor; this has been fixed.

{p 4 9 2}
{* fix}
50.  When a user tried to paste text into the Command window, if the Viewer
     was open but not in front, sometimes the text could be pasted into the
     Viewer's edit field.  This has been fixed.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
51.  The Toolbar may be a floating window or may be anchored to the menubar.
     The advantage of making the Toolbar a floating window is that it takes
     up less room on the screen and can be moved around.  A Toolbar submenu
     containing the current hide and show options for the Toolbar as well
     as the option to make the Toolbar float or anchor has been added to the
     Window menu.

{p 4 9 2}
{* fix}
52.  Some keyboard shortcuts were remapped to be more consistent with similar
     menu items.  The keyboard shortcut for the Preferences dialog was
     remapped to "Apple-," to be consistent with other applications.

{p 4 9 2}
{* fix}
53.  Some of the window preferences were misnamed; this has been fixed.

{p 4 9 2}
{* fix}
54.  Executing commands from the Do-file Editor and immediately typing caused
     Stata to crash; this has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
55.  The Do-file Editor previously did not understand ~/ to mean the user's
     home directory (that is, doedit ~/myfile.do); this has been fixed.

{p 4 9 2}
{* fix}
56.  Stata's Do-file Editor no longer ignores a request to cancel closing its
     window when there is an unsaved document and the window is in the process
     of being closed by a request to exit Stata.


{hline 8} {hi:update 30sep2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help dotplot} now uses the variable format for the y axis if it is common
    among all the specified variables.

{p 5 9 2}
{* enhancement}
2.  {help lincom} after {help svy:svy estimation} now saves the degrees of
    freedom in {cmd:r(df)}.

{p 5 9 2}
{* fix}
3.  {help lnskew0}'s {dialog lnskew0:dialog} has been redesigned to better
    handle the {cmd:level()} option.  Previously, {cmd:level(95)} was ignored
    while other values of {cmd:level()} were accepted.

{p 5 9 2}
{* enhancement}
4.  {help sunflower} is a new command that produces sunflower
    density-distribution plots; see help {help sunflower}.  This command is
    based on earlier work by William D. Dupont and W. Dale Plummer, Vanderbilt
    University, who provided helpful suggestions for this version.

{p 5 9 2}
{* fix}
5.  Dates containing spaces, slashes, or commas must be bound in parentheses
    when specified in the time-axis {help graph} options {cmd:tscale()},
    {cmd:tlabel()}, {cmd:tmlabel()}, {cmd:ttick()}, {cmd:tmtick()}, and
    {cmd:ttext()}; see help {help datelist}.


{hline 8} {hi:update 26sep2003} {hline}

    {title:Stata executable, Mac only}

{p 5 9 2}
{* enhancement}
1.  Stata's update feature has been modified to handle the download and
    extraction of Mac OS X Application Packages.  Future updates to Stata will
    ship as a Mac OS X Application Package rather than as a single executable.
    The advantages of this format include faster startup, better performance,
    and the ability to download future Stata updates as a compressed file
    making updating faster.

{p 5 9 2}
{* fix}
2.  In some cases, Stata crashed if run in batch mode; this has been fixed.

{p 5 9 2}
{* fix}
3.  {help macro:Extended macro function} {cmd:dir} did not recognize {cmd:~/}
    to mean the user's home directory; this has been fixed.


{hline 8} {hi:update 15sep2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help graph_bar:graph hbar} and {cmd:graph bar, horizontal} after the
    12sep2003 update produced an error message when the {cmd:text()} option
    was specified; this has been fixed.

{p 5 9 2}
{* fix}
2.  {help xtline} now documents option {cmd:overlay} which replaces
    {cmd:overlayed}.


{hline 8} {hi:update 12sep2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help graph_twoway:graph twoway} has two new {it:plottypes} for plotting
    time-series data, {cmd:tsline} and {cmd:tsrline}; see help {help tsline}.
    Also, all {it:plottypes} automatically produce better label and tick
    values for variables having {help datetime:date formats} or
    {help datetime:time-series formats}.

{p 5 9 2}
{* enhancement}
2.  {help graph_twoway:graph twoway} has seven new options useful when plotting
    time-formatted variables:  {cmd:tscale()}, {cmd:tlabel()},
    {cmd:tmlabel()}, {cmd:ttick()}, {cmd:tmtick()}, {cmd:tline()}, and
    {cmd:ttext()}; see help {help axis_options}, {help added_line_options} and
    {help added_text_options}.  With these options you may directly specify
    date literals, such as {cmd:12sep2003} or {cmd:1990q2} to identify
    positions.

{p 5 9 2}
{* enhancement}
3.  {help xtline} is a new command for plotting panel data; see help
    {help xtline}.  {cmd:xtline} allows either overlaid or separate graphs to
    be produced, by panel.


{hline 8} {hi:update 09sep2003} {hline}

{p 4 4 2}
The 09sep2003 executable and ado update includes 45 changes and improvements.
We recommend you read the entire numbered list below.
Highlights include,

{p 9 12 2}
   o{space 2}Stata can now read and write files in the format required by the
    U.S. Food and Drug Administration (FDA) for new drug and device
    applications (NDAs).  {bind:See #13} below and see help {help fdasave}.

{p 9 12 2}
   o{space 2}Stata now allows multiple variable, value, and data labels, such
    as labels in different languages;
    {bind:see #22} below and see help {help label_language}.

{p 9 12 2}
   o{space 2}Stata now has multiple-comparison tests after {help anova} and
    {help manova}.  In addition, specifying contrasts is now easier.
    {bind:See #28} below and see help {help anova postestimation:testanova}
    and help {help manovatest}.

{p 9 12 2}
   o{space 2}A new file-editing/file-filtering command makes it possible to
    replace one set of characters with another; this may be done on
    files of unlimited size and on both binary and ASCII files.
    {bind:See #14} below and see help {help filefilter}.

{p 9 12 2}
   o{space 2}Stata now supports TIFF files; see #16 and #17 below and see help
    {help graph_export}.

{p 9 12 2}
   o{space 2}Under Stata for Windows, the Review and Variable windows may
    now be moved together with the main Stata window by holding Ctrl
    while dragging the main Stata window with the mouse; {bind:See #31}
    below.


    {title:Ado-files, all platforms}

{p 5 9 2}
{* enhancement}
1.  Online help and search index brought up to date for
    {help sj:Stata Journal 3(3)}.

{p 5 9 2}
{* enhancement}
2.  {help cf} is now faster.  The improvement results from code provided by
    David Kantor, Institute for Policy Studies, Johns Hopkins University.

{p 5 9 2}
{* fix}
3.  {help graph} color setting options, such as {cmd:mcolor(red*.3)},
    {cmd:color(blue*.5)}, and {cmd:lcolor(navy*.8)}, that used the
    {cmd:*}{it:#} syntax to change the intensity of a named color would cause
    that intensity change to stick.  For example, after option
    {cmd:mcolor(red*.3)} was specified, the color {cmd:red} would be shown as
    a light red in all subsequent graph commands until {help clear} or
    {help discard} was typed to reset the graph system.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {help graph_bar:graph bar} and {help graph_box:graph box} now respect the
    {cmd:blpattern()} suboption of the {cmd:bar()} option.

{p 5 9 2}
{* fix}
5.  {help graph_box:graph box} would not plot outside values when the
    interquartile range was zero; this has been fixed.

{p 5 9 2}
{* fix}
6.  {help graph_twoway:graph twoway} options {cmd:connect()} and
    {cmd:cmissing()} would "stick" when specified.  That is to say subsequent
    graphs would be drawn as though the option were specified, even if it were
    not.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {help sts:sts graph, hazard}, when used with {cmd:by()}, would graph
    estimated hazards over the range of observed failures for the entire data.
    As a result, the graphs produced were sometimes misleading, since the
    smoothed hazard estimate for a particular {cmd:by()} group is valid only
    over the failure range for that group.  {cmd:sts} now graphs the estimated
    hazard over the failure range for each group.

{p 5 9 2}
{* fix}
8.  {help tabstat} documented and computed {cmd:statistics(cv)} as
    variance/(mean^2).
    {cmd:tabstat} now documents and computes it as sd/mean to match the
    standard definition for the coefficient of variation.

{p 5 9 2}
{* fix}
9.  {help tabstat} misaligned the header if a value less than 8 was specified
    in {cmd:varwidth()}; this has been fixed.

{p 4 9 2}
{* fix}
10.  {help varsoc} failed when using pre-estimation syntax if {cmd:maxlags()}
     was not specified; this has been fixed.


    {title:Stata executable, all platforms}

{p 4 9 2}
{* fix}
11.  {help classexit:class exit} issued an error message if a number with a
     leading decimal point was specified as the return value, for example, .456.
     This led to error messages and failure to draw graphs if any text to be
     drawn were smaller than 1 unit, typically for very small fonts or text
     with a single narrow character such as "i".  This has been fixed.

{p 4 9 2}
{* fix}
12.  {help cldis:cluster dissimilarity} option {cmd:Hamann} has been added as
     the preferred alias for the previously documented {cmd:Hamman}.  The
     correct spelling is with two {it:n}s and one {it:m}.
     Both spellings are now allowed.

{p 4 9 2}
{* enhancement}
13.  {help fdasave}, {help fdause}, and {help fdadescribe} are new commands
     for saving and using files in the format required by the U.S. Food and
     Drug Administration (FDA) for new drug and device applications (NDAs).
     These commands are designed to assist people making submissions to the
     FDA, but the commands are general enough for use in transferring data
     between SAS and Stata.  The FDA format is identical to the SAS XPORT
     Transport format; see help {help fdasave}.

{p 4 9 2}
{* enhancement}
14.  {help filefilter} is a new command for copying an input file to an output
     file while converting a specified ASCII text or binary pattern to another
     pattern; see help {help filefilter}.

{p 4 9 2}
{* enhancement}
15.  {help graph} now produces better label and tick values for variables
     having a {help datetime:date formats} or
     {help datetime:time-series formats}.

{p 4 9 2}
{* enhancement}
16.  {help graph_export:graph export} now supports TIFF files.  The files are
     limited to the resolution of the display device and the size of the Graph
     window.  When a TIFF file is exported using an 8-bit display device, the
     TIFF file will be in 8-bit format.

{p 4 9 2}
{* enhancement}
17.  {help graph_export:graph export} now supports TIFF previews for EPS files
     through the {cmd:preview(on)} option; the graph window must be open so
     that it can be used to create the preview.

{p 4 9 2}
{* fix}
18.  EPS files produced by {help graph_export:graph export} did not print
     properly when placed in some Adobe applications such as PageMaker and
     InDesign, although they would print and could be viewed by other
     applications; this has been fixed.

{p 4 9 2}
{* enhancement}
19.  EPS files exported from Stata graphs now contain information describing
     the font that must be downloaded to the printer.  This assists desktop
     publishing applications when printing embedded Stata EPS files using a
     font that may not exist on a particular printer.

{p 4 9 2}
{* fix}
20.  EPS graph files that used the small square symbol could contain invalid
     PostScript code; this has been fixed.

{p 4 9 2}
{* fix}
21.  {help infix} and {help infile2:infile} with a dictionary had difficulty
     handling end-of-line characters from files created under different
     operating systems.  Stata for Windows and Stata for Unix did not read raw
     text files with Mac end-of-line characters.  Stata for Mac
     read a raw text file with DOS end-of-line characters as having two
     end-of-line characters.  Both problems have been fixed.

{p 4 9 2}
{* enhancement}
22.  {help label} has new subcommand {help label_language:language} that lets
     you create and use datasets that contain different sets of data,
     variable, and value labels.  A dataset might contain one set in English,
     another in German, and a third in Spanish.  Another dataset might contain
     one set of short labels and another of long labels.  Either way,
     you can switch between the label sets as desired.
     Up to 100 sets of labels are
     allowed.  See help {help label_language}.

{p 4 9 2}
{* fix}
23.  {help odbc:odbc describe} produces a more detailed error message when the
     table does not exist.

{p 4 9 2}
{* enhancement}
24.  {help odbc:odbc exec} now allows lengthy SQL statements; see help
     {help odbc}.

{p 4 9 2}
{* enhancement}
25.  {help odbc:odbc load} has a new {cmd:sqlshow} option for debugging SQL
     communication with the driver; see help {help odbc}.

{p 4 9 2}
{* enhancement}
26.  The maximum number of {help serset:sersets} has been increased from 100
     to 2,000; see help {help serset}.  This means that complex graphs and
     combined graphs can be drawn with many more plots (lines or scatters).

{p 4 9 2}
{* fix}
27.  {help tabulate} now accents the {c e'} when labeling Cram{c e'}r's V
     (obtained using the {cmd:V} option).  The value continues to be returned
     in {cmd:r(CramersV)} ({it:sans} accent).

{p 4 9 2}
{* enhancement}
28.  {cmd:test} after {help anova} and {help manova} has new options
     {cmd:mtest()}, {cmd:test()}, and {cmd:showorder}; see help
     {help anova postestimation:testanova} and {help manovatest}.
     {cmd:mtest()} provides adjustment for multiple tests.  {cmd:test()}
     allows easier specification of contrasts and other tests involving the
     coefficients of the underlying regression model.  {cmd:showorder} shows
     the order of the columns in the underlying regression model.

{p 4 9 2}
{* enhancement}
29.  {help _tsnatscale} is a new programmer command for obtaining nice label
     or tick values for time series; see help {help _tsnatscale}.


    {title:Stata executable, Windows}

{p 4 9 2}
{* enhancement}
30.  The Review and Variable windows may be jointly opened or closed by
     pressing Ctrl-9.

{p 4 9 2}
{* enhancement}
31.  The Review and Variable windows may be moved together with the main Stata
     window by holding down the Ctrl key while dragging the main Stata window
     with the mouse.

{p 4 9 2}
{* enhancement}
32.  The default actions associated with double-clicking on various Stata
     files no longer include {cmd:/m1} on the action command line.  Thus,
     the value of {cmd:set memory} ...{cmd:, permanently} will be respected.
     You may still edit the action command line for
     all Stata file types to override the default memory allocation.  If you
     wish Stata to use the new default associations, choose
     {cmd:Restore File Associations} from Stata's {cmd:Prefs} menu.

{p 4 9 2}
{* enhancement}
33.  The path passed to Stata when a Stata file was double-clicked was
     sometimes converted to old-style 8.3 notation before being displayed in
     Stata.  This did not affect functionality but was visually unappealing.
     Windows now passes Stata nicely formatted, full paths.  This takes effect
     if you reset Stata's default file associations by selecting
     {cmd:Restore File Associations} from Stata's {cmd:Prefs} menu.

{p 4 9 2}
{* fix}
34.  The Viewer edit field now allows text to be pasted into it.

{p 4 9 2}
{* fix}
35.  The Print item in the contextual menu in the Viewer did not print the
     Viewer's contents; this has been fixed.

{p 4 9 2}
{* enhancement}
36.  (Windows XP) The visual style of Stata for Windows now matches the
     currently selected Windows theme.

{p 4 9 2}
{* fix}
37.  (Windows XP) On some Dell platforms, Stata would fail to launch due to
     another process being frozen.  If frozen processes exist, Stata now
     works around this and still launches.


    {title:Stata executable, Mac}

{p 4 9 2}
{* enhancement}
38.  An "{cmd:Edit--Copy Table as HTML}" menu item has been added.

{p 4 9 2}
{* enhancement}
39.  Graphs saved or copied in the PICT format now provide true rotated text
    via PICCOMMENTS.  For applications that do not understand PICCOMMENTS and
    don't know to ignore them, there is an option to turn off this feature:
    {cmd:set piccomments off} or unchecking the
    "{cmd:Use PICCOMMENTS in PICT output to draw rotated text}" checkbox in
    the {cmd:Graph Preferences} dialog.

{p 4 9 2}
{* enhancement}
40.  Stata has been enhanced to support Panther, Apple's forthcoming OS X
     upgrade.

{p 4 9 2}
{* fix}
41.  Running Stata remotely in batch mode caused Stata to crash when drawing
     the progress bar on Stata's icon in the Dock.  Before attempting to draw
     the progress bar, Stata now determines whether it is being run remotely
     by checking that the environment variable {cmd:REMOTEHOST} is not empty.

{p 4 9 2}
{* fix}
42.  The Search menu was never enabled; this has been fixed.


    {title:Stata executable, Unix}

{p 4 9 2}
{* fix}
43.  (console mode) Underscores associated with the {help smcl} directive
     {cmd:{c -(}title:}...{cmd:{c )-}} did not match the indentation of the
     title; this has been fixed.

{p 4 9 2}
{* fix}
44.  (Linux) {help update:update swap} now uses {cmd:gunzip} rather than
     {cmd:uncompress}.

{p 4 9 2}
{* fix}
45.  (Solaris) license positions were sometimes tracked incorrectly; this has
     been fixed.


{hline 8} {hi:update 22aug2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help aorder} gave a system-limit error if some of the variable names had
    the letter "d" or "e" after an initial stub and number; this is fixed.

{p 5 9 2}
{* enhancement}
2.  {help bootstrap}, {help jknife}, {help permute}, {help simulate}, and
    {help statsby} have a new {cmd:trace} option that displays a trace of the
    execution of the command being operated on.

{p 5 9 2}
{* fix}
3.  Graphics options and suboptions that accept a {help compassdirstyle} now
    respect arguments that are clock directions -- numbers 0 through 12.

{p 5 9 2}
{* fix}
4.  The {help legend_options:legend()} option of {help graph} now honors the
    {cmd:height()} and {cmd:width()} suboptions.

{p 5 9 2}
{* enhancement}
5.  {help graph_box:graph box} can now label outside values; see the
    {it:{help marker_label_options:marker label options}} suboptions of
    {cmd:marker()} and help {help graph_box}.

{p 5 9 2}
{* fix}
6.  {help graph_box:graph box} issued an error message and did not draw the
    graph if any of the variables had value labels that labeled missing
    values only; this is fixed.

{p 5 9 2}
{* enhancement}
7.  {help scatter:graph twoway scatter} now has a {cmd:jitterseed()} option
    that sets the random-number seed for jittered points;
    see help {help scatter}.

{p 5 9 2}
{* fix}
8.  {help twoway:graph twoway} now honors the {cmd:xlabel(, valuelabels)}
    option even when more than one y axis is specified.  Previously, if more
    than one y axis were specified, the {cmd:valuelabels} suboption was
    ignored and numbers were shown in place of the associated value labels on
    the axis.

{p 5 9 2}
{* enhancement}
9.  {help ml} now has a {cmd:vce(oim)} option that is the preferred alias for
    the existing {cmd:vce(hessian)} option which continues to work; see help
    {help ml}.

{p 4 9 2}
{* enhancement}
10.  {help separate} now has a {cmd:shortlabel} option that specifies shorter
     variable labels are to be created; see help {help separate}.

{p 4 9 2}
{* enhancement}
11.  {help statsby} is now faster.  The improvement is based on code provided
     by Michael Blasnik, Blasnik & Associates.


{hline 8} {hi:update 13aug2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help bootstrap}, {help jknife}, {help permute}, {help simulate}, and
    {help statsby} would exit with an error when supplied with long
    expressions; this is fixed.

{p 5 9 2}
{* enhancement}
2.  {help ci} and {help cii} now produce more accurate Poisson exact
    confidence intervals.

{p 5 9 2}
{* fix}
3.  {help intreg} with the {cmd:het()} option would, on rare occasions, issue
    an error message saying there were no observations; this is fixed.

{p 5 9 2}
{* fix}
4.  {help separate} now preserves the sort order of the data.

{p 5 9 2}
{* fix}
5.  {help svar} displays a better error message when the specified model
    passes the order condition but fails the rank condition.

{p 5 9 2}
{* enhancement}
6.  {help tostring}, a command for converting numeric variables to string, is
    now an official Stata command; see help {help tostring}.

{p 5 9 2}
{* fix}
7.  {help varirf_create:varirf create} would fail to estimate the impulse
    response functions after some structural VAR models with long-run
    constraints.  This has been fixed.


{hline 8} {hi:update 15jul2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help ci} and {help cii} have new options {cmd:exact}, {cmd:wilson},
    {cmd:agresti}, and {cmd:jeffreys} for computing different types of
    binomial confidence intervals.  The default behavior of computing exact
    confidence intervals in the binomial case is unchanged.  See help
    {help ci} for details.

{p 5 9 2}
{* enhancement}
2.  {help codebook} now allows {cmd:if} {it:exp} and {cmd:in} {it:range}
    qualifiers; see help {help codebook}.

{p 5 9 2}
{* fix}
3.  {help findfile}, when used with the {cmd:all} option, saved results in the
    return list with unbalanced double quotes; this is fixed.

{p 5 9 2}
{* fix}
4.  {help graph} has improved axis titles when time-series operators are
    applied to a variable that does not have a label.  Previously the title
    did not include the variable name, only the time-series operator(s).  The
    title now includes {it:ts}{cmd:.}{it:varname} where {it:ts} are the
    time-series operator(s) and {it:varname} is the variable name.

{p 5 9 2}
{* enhancement}
5.  {help graph_bar:graph bar} has new options {cmd:over(, reverse)} and
    {cmd:yvaroptions(reverse)} that specifies the categorical scale be
    reversed to run from maximum to minimum rather than the default minimum
    to maximum.  See help {help graph_bar}.

{p 5 9 2}
{* fix}
6.  Several of the {help by_option:graph by()} suboptions could "stick",
    meaning that they would be applied to subsequent graphs drawn with the
    {cmd:by()} option even though the options were not specified
    subsequently.
    Suboptions that could "stick" were {cmd:xtitles}, {cmd:ytitles},
    {cmd:edgelabel}, {cmd:individual}, {cmd:ixaxes}, {cmd:iyaxes},
    {cmd:ixtitles}, {cmd:iytitles}, {cmd:ixticks}, {cmd:iyticks},
    {cmd:rescale}, {cmd:xrescale}, and {cmd:yrescale}.  This has been fixed.

{p 5 9 2}
{* fix}
7.  {help twoway_mband:graph twoway mband} for plots with only two
    observations now connects the two points in the data.  Previously no line
    was drawn.

{p 5 9 2}
{* enhancement}
8.  {help twoway_mband:graph twoway mband} and
    {help twoway_mspline:graph twoway mspline} now have better default number
    of bands.

{p 5 9 2}
{* fix}
9.  {help twoway_mspline:graph twoway mspline} for plots with only two unique
    values of the {it:x} variable now plots the two unique points and the
    medians for the {it:y} variables at those two points.  Previously a
    clearly incorrect line was drawn.

{p 4 9 2}
{* enhancement}
10.  {help hausman} has new option {cmd:df()} for controlling the degrees of
     freedom for the Hausman test; see help {help hausman}.

{p 4 9 2}
{* fix}
11.  {help hausman} could incorrectly state which model was consistent and
     which inconsistent-but-efficient in the message presented at the bottom
     of the output table; this is fixed.

{p 4 9 2}
{* fix}
12.  {help ml} when used with an {cmd:if} or {cmd:in} restriction, could
     produce the error "{it:tempvar} not found" in rare instances;
     this is fixed.

{p 4 9 2}
{* fix}
13.  When the {help maximize:nrtolerance()} option of maximum-likelihood
     estimators (such as {cmd:heckman}) or {help ml:ml maximize} was
     specified, the tolerance could be declared met even if the Hessian was
     not positive definite.  Now the Hessian must be positive definite as a
     precondition for the {cmd:nrtolerance()} convergence criterion.

{p 4 9 2}
{* fix}
14.  {help palette:palette linepalette} now honors the {cmd:scheme()} option.

{p 4 9 2}
{* fix}
15.  {help recode}, in the case of rule overlap, used the last matching rule,
     rather than the first matching rule as documented; this is fixed.
     In addition, {cmd:recode} is now faster.

{p 4 9 2}
{* enhancement}
16.  {help schemes:Scheme files} may now have {cmd:*!} comments.  This allows
     their version to be displayed by {help which}.

{p 4 9 2}
{* enhancement}
17.  {help svymarkout} is a new programmer's command for marking observations
     for exclusion based on survey characteristics set by {help svyset};
     see help {help svymarkout}.

{p 4 9 2}
{* fix}
18.  {help twoway__function_gen} could produce values of "x" greater than
     indicated in the {cmd:range()} option; this is fixed.


{hline 8} {hi:update 01jul2003} {hline}

    {title:What's new in release 8.1 (compared to release 8.0)}

{p 5 9 2}
{* enhancement}
1.  {help ml} has lots of new features; see help {help ml} and see the book
    {it:{browse "http://www.stata.com/bookstore/mle.html":Maximum Likelihood Estimation with Stata, 2d Edition}}
    (Gould, Pitblado, and
    Sribney 2003).

{p 9 13 2}
    a.  {cmd:ml} can now perform BHHH, DFP, and BFGS optimization techniques
	with user defined likelihood functions.  The default technique
	remains modified Newton-Raphson.

{p 9 13 2}
    b.  {cmd:ml} has a new variance estimator -- outer product of the
	gradients (OPG) -- to accompany the two previously available --
	the Hessian-based estimator and the robust estimator.  The new
	{cmd:vce()} option along with the existing {cmd:robust} option
	specify which is used:

{p 13 13 2}
	{cmd:vce(hessian)} specifies the Hessian-based variance estimator.

{p 13 13 2}
	{cmd:vce(opg)} specifies the outer-product-of-the-gradients variance
	estimator.

{p 13 13 2}
	{cmd:robust} specifies the Huber/White robust estimator.

{p 9 13 2}
    c.  {cmd:ml} handles irrelevant constraints, if specified, more elegantly.
        Previously, irrelevant constraints caused an error message.  Now they
        are flagged and ignored.

{p 13 13 2}
	{cmd:ml model} uses the new command {help makecns} when
	supplied with the {cmd:constraint()} option.  {cmd:makecns} uses
	{help matconst:matrix makeCns} to generate a constraint matrix, and
	displays a note for each constraint that causes a problem; see help
	{help makecns}.

{p 13 13 2}
	(Prior to version 8.1, {cmd:ml} would ignore the {cmd:constraint()}
	option if there were no predictors in the first equation.  This
	behavior is preserved under version control.  Under {cmd:version 8.1},
	{cmd:ml} applies constraints under all circumstances.)

{p 9 13 2}
    d.  Constraints now imply a Wald test for the model chi-squared test.  For
	those who wish to perform likelihood-ratio tests for models with
	constraints, see help {help lrtest}.

{p 9 13 2}
    e.  {help mlmatbysum} is a new programmer's command for use by method
	{cmd:d2} likelihood evaluators to help define the negative Hessian
	matrix in the case of panel-data likelihoods; see help
	{help mlmatbysum}.

{p 5 9 2}
{* enhancement}
2.  Plugins (also known as DLLs or shared objects) written in C can now be
    incorporated into and called from Stata.  Point your browser to
    {browse "http://www.stata.com/support/plugins/"}
    for more information and documentation.

{p 5 9 2}
{* enhancement}
3.  {help sts:sts graph} has new options {cmd:cihazard} and
    {cmd:per(}{it:#}{cmd:)}.  {cmd:cihazard} draws pointwise confidence bands
    around the smoothed hazard function.  {cmd:per()} specifies the units used
    to report the survival or failure rate.  See help {help sts} for details.

{p 5 9 2}
{* enhancement}
4.  (Windows, Mac, and Linux) {help odbc} has new commands
    {cmd:odbc insert} and {cmd:odbc exec} for writing data to an ODBC data
    source.  Positioned updates are also possible using the {cmd:odbc exec}
    command.  See help {help odbc} for more information.

{p 5 9 2}
{* enhancement}
5.  The constant and current-value class {cmd:c()} has the following new items.

		{cmd:c(alpha)}      (lowercase letters)
		{cmd:c(ALPHA)}      (uppercase letters)
		{cmd:c(Mons)}       "Jan Feb ... Dec"
		{cmd:c(Months)}     "January February March ... December"

{p 9 9 2}
    See help {help creturn}.

{p 5 9 2}
{* enhancement}
6.  {help outfile} has new option {cmd:missing} that preserves all missing
    values when the {cmd:comma} option is also specified.  Previously, if you
    specified {cmd:comma}, system missing values ({cmd:.}) were changed to
    null strings ({cmd:""}) and extended missing values ({cmd:.a}, {cmd:.b},
    ..., {cmd:.z}) were retained.  See help {help outfile}.

{p 5 9 2}
{* enhancement}
7.  {help _svy_mkdeff}, {help _svy_mkmeff}, {help _get_eformopts}, and
    {help _get_diparmopts} are new programmer utilities.

{p 5 9 2}
8.  Recommendation on setting version at the top of do-files and ado-files:
    Use {cmd:version 8.1}.  {cmd:version 8.1} adds new features and
    changes the behavior of {help ml} for the better.
    (Setting {cmd:version 8.0} restores {cmd:ml}'s old behavior.)
    See help {help version}.


    {title:Other additions and fixes}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
9.  {help nlogit} now uses the {help maximize:BFGS} optimization algorithm by
    default.

{p 4 9 2}
{* fix}
10.  {help nlogit} ignored the {cmd:robust} option when the specified model
     had more than 3 levels.  The {cmd:robust} option is no longer allowed
     when the specified model has more than 3 levels.

{p 4 9 2}
{* fix}
11.  {help zip} and {help zinb} with the {cmd:vuong} option now report an
     error if constraints are also specified.


    {title:Stata executable}

{p 4 9 2}
{* fix}
12.  {help insheet} did not honor the {cmd:double} option; this is fixed.

{p 4 9 2}
{* fix}
13.  (Windows) {help insheet} incorrectly identified very large integer values
     as fitting within type {help long} instead of {help double}; this is
     fixed.

{p 4 9 2}
{* enhancement}
14.  {help _pctile} will now compute up to 1000 percentiles (previously the
     limit was 20); see help {help _pctile}.  In addition, {help pctile}
     (no underscore) takes
     advantage of {cmd:_pctile}'s new higher limit, and is more precise in
     determining the boundaries between the requested percentiles.

{p 4 9 2}
{* enhancement}
15.  (Mac) The {hi:Browse...} dialog from the Viewer has been changed to
     allow selection of either files or folders.

{p 4 9 2}
{* fix}
16.  (Mac) {help update:update swap} has been altered to resolve a
     problem some users were having in updating to a new executable.

{p 4 9 2}
{* fix}
17.  (Mac) Clicking the toolbar switch button in the
     {help doedit:Do-file editor} to show the toolbar when it was previously
     hidden would not properly refresh the area between the text and the
     toolbar; this is fixed.


{hline 8} {hi:update 25jun2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and search index brought up to date for
    {help sj:Stata Journal 3(2)}.

{p 5 9 2}
{* fix}
2.  The {cmd:drop} and {cmd:keep} dialog did not enable the drop and keep
    checkboxes on Mac platforms; this is fixed.

{p 5 9 2}
{* fix}
3.  {help ltable} ignored the {cmd:ciopts()} option; this is fixed.

{p 5 9 2}
{* fix}
4.  {help tsappend} exited with an error when applied to panel data if the
    {cmd:panel()} option was not specified; this is fixed.

{p 5 9 2}
{* fix}
5.  {help xtregar:xtregar, fe} did not print warning messages for variables
    dropped due to collinearity; this is fixed.


{hline 8} {hi:update 17jun2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help cumul} has a new {cmd:equal} option; see help {help cumul}.

{p 5 9 2}
{* enhancement}
2.  {help ds} has new options that allow you to list variables that match
    certain criteria.  The resulting list is returned in {cmd:r(varlist)},
    which can then be used in a subsequent command.  The new options for
    {cmd:ds} are {cmd:not}, {cmd:has()}, {cmd:not()}, {cmd:insensitive},
    {cmd:detail}, and {cmd:indent()}.  See help {help ds} for details.

{p 5 9 2}
{* fix}
3.  {help graph} suboptions {cmd:label}, {cmd:nolabel}, {cmd:tick}, and
    {cmd:notick} of the {cmd:ylabel()}, {cmd:xlabel()}, {cmd:ytick()}, and
    {cmd:xtick()} options were not honored if {help by_option:by()} was also
    specified; see help {help axis_label_options}.  This has been fixed.

{p 5 9 2}
{* fix}
4.  {help graph_box:graph box} no longer draws a symbol for an outside value
    at the median when all observations for a variable (or the by group) for a
    box are constant.

{p 5 9 2}
{* fix}
5.  {help xpose} now uses the {help file} command instead of the
    {help outfile} and {help infile1:infile} commands and thus is better able
    to retain precision for variables of type {help double} when the
    {cmd:promote} option is specified.


{hline 8} {hi:update 03jun2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help bootstrap}, {help jknife}, {help permute}, {help simulate}, and
    {help statsby} exited with an error when the user-supplied command
    contained double quotes; this is fixed.

{p 5 9 2}
{* fix}
2.  {help ps_options:graph set ps fontface} and
    {help eps_options:graph set eps fontface} returned an error, and
    {help eps_options:graph set eps} displayed settings for {cmd:ps} rather
    than for {cmd:eps}; this is fixed

{p 5 9 2}
{* fix}
3.  {help twoway_histogram:graph twoway histogram} and {help histogram} could
    produce one less bin than it should have, resulting in the last bin
    falling short of the maximum value of the given variable; this is fixed.

{p 5 9 2}
{* enhancement}
4.  {help gsort} now has option {cmd:mfirst} for specifying that missing
    values are to be placed first in descending orderings rather than last.

{p 5 9 2}
{* fix}
5.  {help jknife} stopped with an error when it should have posted a missing
    value for a requested statistic; this is fixed.

{p 5 9 2}
{* fix}
6.  {help roctab} could produce ROC graphs with different connecting lines
    with repeated calls using the same data even though the plotted points
    were the same; this is fixed.

{p 5 9 2}
{* fix}
7.  {help sts:sts graph} with the {cmd:yscale(log)} option now graphs only the
    nonzero values.

{p 5 9 2}
{* fix}
8.  {help svytab} reported an error when the {cmd:stubwidth()} option was
    supplied with a value greater than 32 and a value label also exceeded 32
    characters.  The upper limit is now mentioned in the help file, and
    {cmd:svytab} uses 32 when supplied with a stubwidth greater than 32.


    {title:Stata executable}

{p 5 9 2}
{* enhancement}
9.  {help factor:factor, ipf} has new option {cmd:citerate()} that controls
    the number of iterations for reestimating the communalities; see help
    {help factor}.

{p 4 9 2}
{* fix}
10.  {help hexdump} incorrectly reported the count of the end-of-line
     character for Mac, reporting instead the count for Unix; this is
     fixed.

{p 4 9 2}
{* enhancement}
11.  {help lngamma:lngamma()} function is now computed with approximately 16
     digits of accuracy.

{p 4 9 2}
{* fix}
12.  {cmd:set memory {it:#}g}, with {it:#}>4 on 32-bit computers, now
     produces a more descriptive error message.

{p 4 9 2}
{* fix}
13.  {help manovatest:test after manova} could cause Stata to crash
     when presented with invalid syntax; this is fixed.

{p 4 9 2}
{* fix}
14.  {help update} is faster.  Stata no longer waits for the web server to
     respond if the requested file is 0 bytes.

{p 4 9 2}
{* fix}
15.  {help tempfile:temporary file names} remain unique longer.  The total
     number of unique names that are cycled through has been increased from
     1.3 million to 1.5 billion.

{p 4 9 2}
{* enhancement}
16.  {help version} has new option {cmd:born()} and issues more descriptive
     error messages.  In addition, the help file has been updated to
     be more understandable; see help {help version}.

{p 4 9 2}
{* enhancement}
17.  (Windows) An "Edit--Copy Table as HTML" menu item has been added.

{p 4 9 2}
{* fix}
18.  (Windows) {help graph_pie:Pie slices} with a 0-length arc drew a complete
     circle; this is fixed.

{p 4 9 2}
{* enhancement}
19.  (Mac) Shift-clicking in the {help doedit:Do-file Editor} now
     selects text from the insertion point to the text location where
     you click the mouse.

{p 4 9 2}
{* enhancement}
20.  (Mac)
     The ability to undo or redo multiple actions has been added to the
     {help doedit:Do-file editor}.

{p 4 9 2}
{* fix}
21.  (Mac) Styled text from the clipboard no longer is pasted into the
     {help doedit:Do-file editor} as styled text rather than mono-styled text.

{p 4 9 2}
{* enhancement}
22.  (Mac) The General Preferences dialog has a new option for
     bringing all open Stata windows to the front when Stata is activated.
     This prevents Stata's windows from overlapping with other application
     windows when Stata is brought to the front.

{p 4 9 2}
{* fix}
23.  (Mac) In later versions of the OS X operating system, a hidden
     progress bar incorrectly draws content that was previously over the
     control's boundaries.  Stata now works around this bug and displays the
     progress bar as indeterminate when establishing a connection (no progress
     bar was shown previously when establishing a connection).

{p 4 9 2}
{* fix}
24.  (Windows, Mac, and Linux) {help odbc} could load values incorrectly
     when the variables were explicitly specified in an order that did not
     match that of the underlying data; this is fixed.

{p 4 9 2}
{* fix}
25.  (64-bit Solaris GUI) Some keystrokes could be omitted or corrupted.
     Stata now links against a newer version of GDK in which this is fixed.

{p 4 9 2}
{* enhancement}
26.  (HP Unix GUI) Stata is now approximately 30% faster.


{hline 8} {hi:update 12may2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help estimates}, under rare conditions, would not restore {cmd:e(sample)};
    this is fixed.

{p 5 9 2}
{* enhancement}
2.  {help est_table:estimates table} now allows you to specify more models.
    It wraps the table if necessary.  {cmd:estimates table} also has new
    options

{p 13 17 2}
        {cmd:equations()} to match equations by number rather than by name.

{p 13 17 2}
        {cmd:coded} to display the table in a symbolic compact format in which
        numbers are represented by a single *.  This enables the display of a
        large number of models in a single table.

{p 13 17 2}
        {cmd:modelwidth()} to set the number of characters for displaying
        model names.

{p 9 9 2}
    See help {help est_table}.

{p 5 9 2}
{* fix}
3.  {help est_table:estimates table} produced an error message if the table
    included many coefficients or the {cmd:label} option was specified with
    models, such as {help ologit}, that contain special names in the
    coefficient vector name stripe (such as {cmd:_cut{it:#}} with {cmd:ologit});
    this is fixed.

{p 5 9 2}
{* fix}
4.  {help graph_display:graph display} labeled graph bars with zero height
    when redisplaying a graph that was drawn using
    {help graph_bar:graph bar, stack} or {help graph_bar:graph hbar, stack}
    even though {cmd:blabel()} was not specified; this has been fixed.

{p 5 9 2}
{* fix}
5.  {help twoway_function:graph twoway function} renamed a variable that
    started with x to "x" if there was only one such variable; this is fixed.

{p 5 9 2}
{* fix}
6.  {help twoway_histogram:graph twoway histogram} reported an error when
     more than 999 bins were involved; this is fixed.

{p 5 9 2}
{* enhancement}
7.  {help twoway_fpfit:graph twoway fpfit} and
    {help twoway_fpfitci:graph twoway fpfitci}
    now produce smaller .gph, .ps, .eps, and .wmf files.

{p 5 9 2}
{* fix}
8.  {help lrtest} and {help suest} now work correctly for models having zero
    parameters (for example, the null model for Cox regression).

{p 5 9 2}
{* fix}
9.  {help recode} with an {cmd:if} condition involving strings that contained
    spaces produced an error; this is fixed.

{p 4 9 2}
{* fix}
10.  {help svyheckman}, {help svyheckprob}, and {help svynbreg} computed
     confidence intervals using the wrong degrees of freedom for some
     parameters:  athrho, lnsigma, and lambda for {cmd:svyheckman}; athrho for
     {cmd:svyheckprob}; and lnalpha and lndelta for {cmd:svynbreg}.  This is
     fixed.

{p 4 9 2}
{* enhancement}
11.  {help svytab} has a new {cmd:notable} option that
     suppresses the header and table and presents only the test statistics, if
     any; see help {help svytab}.

{p 4 9 2}
{* fix}
12.  {help vwls} returned the error "{error:no observations}"
     when the computed variances were large; this is fixed.

{p 4 9 2}
{* fix}
13.  {help xtpcse} did not allow time-series operators when options
     {cmd:hetonly} or {cmd:independent} were specified; this is fixed.


{hline 8} {hi:update 29apr2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help graph_bar:graph bar} and {help graph_box:graph box} ignored
    weight specifications when users specified suboptions {cmd:relabel()},
    {cmd:sort}, or {cmd:total} within options {cmd:over()} or
    {cmd:yvaroptions()}; this is fixed.

{p 5 9 2}
{* enhancement}
2.  {help graph_display:graph display} has a new {cmd:scale()} option that
    allows all text, symbols, and line widths to be rescaled when a graph is
    displayed again.

{p 5 9 2}
{* fix}
3.  {help arima:predict} with the {cmd:mse} option, if used after {help arima}
    with the {cmd:condition} option, now produces mean-squared errors that are
    based on initializing the presample MSE vector of the state vector with
    the expected long-run MSE. This is the same initialization method used to
    produce conditional estimates. Previously, the presample MSE vector was
    initialized with expected values derived from the estimated parameters,
    which is the initialization method used to produce unconditional
    estimates.  The new method is more consistent with the conditional method
    of estimation.


{hline 8} {hi:update 24apr2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help egen:egen {it:newvar} = group()} with the {cmd:label} option would
    write over the value label named {it:newvar} if the value label already
    existed.  Now, it prompts you to use the {cmd:lname()} option to specify a
    name for the value label.

{p 5 9 2}
{* fix}
2.  {help tabodds} with {help weights} large enough to cause an overflow of
    the storage type {help int} would produce incorrect results.  Now, storage
    type {help long} is used, and the problem is fixed.


    {title:Stata executable}

{p 5 9 2}
{* enhancement}
3.  The {cmd:*} {help comments:comment indicator} can now be used in
    {help dialogs:.dlg} and .idlg files.

{p 5 9 2}
{* fix}
4.  The find string from the {help viewer:Viewer} window's Find dialog would
    sometimes be converted to lower case; this is fixed.

{p 5 9 2}
{* enhancement}
5.  Some operating systems allow read-only files to be overwritten if the
    directory is not read only.  Stata no longer allows read-only files to be
    overwritten, regardless of the directory protection.

{p 5 9 2}
{* fix}
6.  After {help dp:set dp comma}

{p 13 17 2}
    {help graph} now honors the setting and uses commas in place of decimals
    when labeling axes.

{p 13 17 2}
    {help graph} no longer draws extra-wide legends that overwrite other graph
    objects.

{p 13 17 2}
    {help serset} extended macro functions now return numbers with decimal
    points instead of commas to avoid problems in subsequent computations.

{p 13 17 2}
    {help macro:++} and {help macro:--} macro operators, when the value of the
    macro is not an integer, now return numbers with decimal points instead of
    commas to avoid problems in subsequent computations.

{p 5 9 2}
{* fix}
7.  (Windows) {help graph_export:graph export} of a {cmd:.wmf} file would fail
    if the path and filename were over 80 characters; this is fixed.

{p 5 9 2}
{* enhancement}
8.  (Windows and Unix) {help window:window manage maintitle} is a new command
    that allows users to set the main title of the Stata window; see help
    {help window}.

{p 5 9 2}
{* enhancement}
9.  (Mac) Keyboard shortcuts have been added for Edit->Copy Table,
    Tools->Search->Replace and Find Next, and Tools->Search->Match.

{p 4 9 2}
{* fix}
10.  (Mac) If the log menu became disabled, it would not be reenabled
     when Stata could again process log commands; this is fixed.

{p 4 9 2}
{* fix}
11.  (Mac) The Find button in the Viewer would not move when the window
     was resized; this is fixed.

{p 4 9 2}
{* fix}
12.  (Mac) You can now save a graph as a PNG (portable network graphics)
     file from the Save dialog.

{p 4 9 2}
{* fix}
13.  (Mac) Stata previously ran at a low scheduling priority when in
     batch mode.  The scheduling priority has been raised, increasing the
     execution speed.

{p 4 9 2}
{* enhancement}
14.  (Mac) The {cmd:-h} startup option has been added.  This option does
     not start Stata but shows the syntax diagram for invoking Stata.

{p 4 9 2}
{* fix}
15.  (Mac) The {cmd:-q} startup option now suppresses the Stata logo as
     well as the initialization messages.


{hline 8} {hi:update 16apr2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  The submenu for cross-sectional time-series under the statistics menu has
    been restructured to improve access to the dialog boxes.  (This will
    take effect once you exit and restart Stata.)

{p 5 9 2}
{* fix}
2.  {help egen:egen {it:newvar} = group()} with the {cmd:label} option did not
    check to see if a value label named {it:newvar} already existed before
    creation.  Now an error message is
    presented indicating that you should use the {cmd:lname()} option to
    provide a name for the new value label.

{p 5 9 2}
{* fix}
3.  {help findfile} produced an error message if the path specified in the
    {cmd:path()} option contained spaces; this is fixed.

{p 5 9 2}
{* enhancement}
4.  {help graph} when specified with the option {cmd:scale()} now causes
    linewidths to scale in proportion to the scaling of fonts and symbols.
    This also applies to the automatic scaling by {cmd:graph, by()} and
    {cmd:graph combine}.

{p 5 9 2}
{* fix}
5.  Some error messages in {help graph} have been improved.

{p 5 9 2}
{* fix}
6.  {help histogram} and {help twoway_histogram:twoway histogram} are now much
    faster for large datasets.

{p 5 9 2}
{* enhancement}
7.  {help levels} is a new command that displays a sorted list of the distinct
    values of a variable.  This command is especially useful for looping over
    distinct values of a variable with (say) {help foreach}; see help
    {help levels}.

{p 5 9 2}
{* fix}
8.  {help ml} did not correctly compute the tolerance for the
    {cmd:nrtolerance()} option when the {cmd:nr} or {cmd:bhhh} options were
    also specified.  This could cause {help arch} and {help arima} incorrectly
    to continue iterating beyond convergence.
    This is fixed.

{p 5 9 2}
{* enhancement}
9.  {help odbc}, as of the 10apr2003 executable update, is available for
    Mac OS X and Linux systems that use the iODBC Driver Manager.  ODBC, an
    acronym for Open DataBase Connectivity, allows data to be imported into
    Stata via an ODBC data source.  More information on configuring ODBC for
    Mac and Linux can be obtained from the FAQ located at
    {browse "http://www.stata.com/support/faqs/data/odbcmu.html"}.

{p 4 9 2}
{* enhancement}
10.  The {dialog stcox} dialog has been improved.

{p 4 9 2}
{* fix}
11.  {help tabstat} with the {cmd:by()} option ignored the
     {help datetime:date format} when displaying the {cmd:by()} variable; this
     is fixed.


{hline 8} {hi:update 10apr2003} {hline}

    {title:Stata executable}

{p 5 9 2}
{* enhancement}
1.  {help graph_intro:Graphics} are now approximately 100% faster -- they run
    in about half the time.  Some graphs demonstrate more than a 100% speedup,
    some less.
    Speedups are greatest on the second and subsequent {cmd:graph} commands
    (second
    after Stata has been started or refreshed by typing {cmd:clear} or
    {cmd:discard}).

{p 5 9 2}
{* enhancement}
2.  The {help viewer:Stata Viewer} now has the ability to search for text
    within the window.  Click on the find icon which looks like a pair of
    binoculars.  This icon is at the top right of the Viewer.

{p 5 9 2}
{* fix}
3.  {help delimit:#delimit ;} followed by a
    {help quotes:compound double quoted} string containing an odd number of
    regular double quotes would cause an error due to matching the
    beginning and ending compound double quotes incorrectly; this is fixed.

{p 5 9 2}
{* enhancement}
4.  {help graph_export:graph export} now supports PNG (portable network
    graphics) format, especially useful for posting graphs on the Internet.

{p 5 9 2}
{* fix}
5.  {help graph_save:graph save} could, on rare occasions, produce
    severely misdrawn graphs when preceded by "{cmd:graph7} ...
    {cmd:, saving()}".  This is fixed.

{p 5 9 2}
{* fix}
6.  {help saving_option:graph ... , saving(... , asis)} could, on rare
    occasions, cause Stata to crash.
    This occurred only when saving
    {cmd:asis}-format graphs; see help {help gph_files}.
    This is fixed.

{p 5 9 2}
{* fix}
7.  Help file aliases contained in the official {cmd:help_alias.maint} file
    are now resolved before attempting to locate the .hlp file along the ado
    path.  This ensures that the official Stata .hlp files are found before
    user-written .hlp files.

{p 5 9 2}
{* fix}
8.  {help regress:regress, beta} after {help anova} produced nonsense results
    for the normalized beta coefficients.  {cmd:regress, beta} is no longer
    allowed after {cmd:anova}.

{p 5 9 2}
{* fix}
9.  After {help dp:set dp comma},
    in-line = macro-expansion operators did not work in most contexts
    because the results it produced would have commas for decimal points and
    Stata would not understand that as input.
    In-line = operators now ignore the {cmd:dp} setting and all is fixed.

{p 4 9 2}
{* enhancement}
10.  Graphs exported to {help graph_export:PS or EPS} format now use round
     line caps on connected lines.

{p 4 9 2}
{* enhancement}
11.  (Unix) Connected lines drawn to the Graph window now use round line caps.
     The Windows and Mac versions already use round line caps.

{p 4 9 2}
{* enhancement}
12.  (Mac) Unconnected lines such as grid lines and axes now use butt
     line caps rather than round line caps.

{p 4 9 2}
{* enhancement}
13.  (Windows) Keyboard shortcuts to the menu items Do and Run in the
     {help edit:Do-file Editor} have been added.
     The shortcuts are ctrl-d and ctrl-r.

{p 4 9 2}
{* enhancement}
14.  (Mac) A keyboard shortcut to the menu item Run for the
     {help edit:Do-file Editor} has been added.

{p 4 9 2}
{* fix}
15.  (Mac) {help edit:Do-file editor} preferences were corrupted when
     the preference dialog was opened; this is fixed.

{p 4 9 2}
{* enhancement}
16.  (Mac) The preferences dialogs have been rewritten as one single
     dialog that can be accessed from Stata's menus or from the application
     menu.

{p 4 9 2}
{* fix}
17.  (Mac) When saving a new dataset, Stata now correctly defaults to a
     filename of Untitled.dta.

{p 4 9 2}
{* fix}
18.  (Mac) Stata now treats text that is dragged-and-dropped into the
     Command window the same as text that is pasted -- it truncates the text
     to the first line because the Command window only accepts one line of
     text.

{p 4 9 2}
{* enhancement}
19.  (Mac and Unix) The contents of the {help viewer:Review window}
     can now be copied to the Clipboard using the Review window's contextual
     menu.

{p 4 9 2}
{* fix}
20.  (Unix) The {help viewer:Review window's} contextual menu remained
     permanently disabled if the menu was ever opened while the Review window
     was empty; this is fixed.

{p 4 9 2}
{* enhancement}
21.  Stata for IRIX is now approximately 30% faster.

{p 4 9 2}
{* enhancement}
22.  Stata for 64-bit Solaris is now approximately 10% faster.


{hline 8} {hi:update 02apr2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help bstat} produced an error message when the {cmd:stat()} or
    {cmd:accel()} options were specified with a matrix; this is fixed.

{p 5 9 2}
{* fix}
2.  {help graph_bar:graph bar} when specified with both the {cmd:over()} and
    {cmd:asyvars} options and with an {cmd:if} or {cmd:in} qualifier, could
    produce bars that did not match those in the legend; this is fixed.

{p 5 9 2}
{* fix}
3.  {help graph_pie:graph pie} refused to draw the graph if the data for any
    pie slice was zero.  {cmd:graph pie} now allows a pie slice to be zero, as
    long as at least one slice in the pie is positive.

{p 5 9 2}
{* fix}
4.  {help graph_twoway:graph twoway} with option {cmd:yaxis(2)}, could cause a
    very slight skewing of points plotted on the second {it:y} axis toward the
    center of the {it:x} dimension of the graph; this is fixed.  The skewing
    was only noticeable when points should have been plotted at the same
    {it:x} value.

{p 5 9 2}
{* enhancement}
5.  {help ipolate} now creates the new variable containing interpolated values
    using storage type {help double} instead of {cmd:float}.

{p 5 9 2}
{* fix}
6.  {help ml:ml model} did not apply the {cmd:subpop()} option correctly in
    cases where there was no {help weight} variable; this is fixed.  This
    affected {help svypoisson}, {help svynbreg}, {help svygnbreg},
    {help svyheckman}, and {help svyheckprob}.

{p 5 9 2}
{* fix}
7.  {help sttocc} would not produce any case observations when all
    observations failed or were censored at the same time, that is, when the
    variance of _t was zero; this is fixed.


{hline 8} {hi:update 19mar2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help cf} is now an r-class command and returns {cmd:r(Nsum)}, the number
    of differences found.  This addition was made in the 14mar2003 update, but
    was not mentioned then.

{p 5 9 2}
{* fix}
2.  {help graph_bar:graph bar} and {help graph_bar:graph hbar} in the rare
    case where two or more string variables were specified in {cmd:over()}
    options and the {cmd:asyvars} option was specified, could produce bar
    colors that did not match the colors in the legend.  This is fixed.

{p 5 9 2}
{* fix}
3.  {help graph_pie:graph pie} when the option {cmd:over()} was specified, did
    not respect {cmd:if} conditions or {cmd:by} groups in determining the size
    of the pie slices; this is fixed.

{p 5 9 2}
{* fix}
4.  {help sttocc} could produce inappropriate matches when the number of
    observations exceeded 32,740; this is fixed.


{hline 8} {hi:update 14mar2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Online help and search index brought up-to-date for
    {help sj:Stata Journal 3(1)}.

{p 5 9 2}
{* fix}
2.  {help histogram} and {help twoway_histogram:twoway histogram} would not
    include the minimum value in the first bin if the minimum value could not
    be exactly represented in numerical precision; this is fixed

{p 5 9 2}
{* fix}
3.  {help rocgold:rocgold, graph} excluded missing observations casewise,
    while {cmd:rocgold, summary} excluded them on a pairwise basis.  This
    inconsistency has been removed.  {cmd:rocgold} now uses casewise deletion
    of missing observations for both {cmd:graph} and {cmd:summary}.


{hline 8} {hi:update 10mar2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help bootstrap} with the {cmd:bca} option now gives a more informative
    error message when it can not compute acceleration.

{p 5 9 2}
{* fix}
2.  {help bsample} with the {cmd:cluster()} option became noticeably slower as
    a result of options added in Stata 8.  This is no longer the case.

{p 5 9 2}
{* fix}
3.  Easy histogram dialog has been modified to remove the
    {cmd:xscale(log)} and {cmd:yscale(log)} options from the Axes tab since
    these options are rarely used with histograms.

{p 5 9 2}
{* enhancement}
4.  {help gladder} now has a {cmd:nonormal} option to suppress drawing the
    overlaid normal density.  The {dialog gladder} dialog has been modified to
    include this new option.

{p 5 9 2}
{* fix}
5.  (Windows) {cmd:graph set mf fontface} did not properly pass
    along double quotes around the specified font face; this is fixed.

{p 5 9 2}
{* enhancement}
6.  {dialog histogram}, easy histogram, and
    {dialog gladder} dialogs have been modified to include the {cmd:percent}
    option which was added in the 25feb2003 update.


    {title:Stata executable}

{p 5 9 2}
{* enhancement}
7.  {help clist} is a new command similar to {cmd:list, clean}; {cmd:clist} is
    in fact the {cmd:list} command that appeared in Stata prior to Stata 8,
    options and all.  Some users needed the old command for backward
    compatibility purposes; {help list} continues to be the preferred command.
    {cmd:clist} may be abbreviated {cmd:cl}; see help {help clist}.

{p 5 9 2}
{* enhancement}
8.  {help list} has new option {cmd:fast}, which is in fact a synonym for
    option {cmd:nocompress}.  {cmd:list} normally does a dry run to determine
    how best to format the display.  {cmd:nocompress} prevents that and, with
    very large datasets, this can save a little time before the output
    appears.  {cmd:fast} is a more suggestive name for the option in this
    case.  See help {help list}.

{p 5 9 2}
{* enhancement}
9.  {help flist} is a new command equivalent to {cmd:list, fast} or,
    equivalently, {cmd:list, nocompress}.  {cmd:flist} may be abbreviated
    {cmd:fl}; see help {help list}.

{p 4 9 2}
{* fix}
10.  {help use}, {help merge}, and {help append}, used with old-format
     datasets stored by Stata 7 or earlier, could change missing values stored
     in {help byte} or {help int} variables to nonmissing values.  Missings in
     {cmd:byte}s could be converted to 101 and missing in {cmd:int}s could be
     converted to 32,741.  This would happen only if the {cmd:byte} or
     {cmd:int} variable also contained nonmissing values greater than 100 or
     32,740 respectively and if the data were ordered in a certain way.  This
     is fixed.

{p 4 9 2}
{* fix}
11.  (Windows) {help graph_export:graph export} did not accept the
     {cmd:fontface()} option when exporting an Enhanced Metafile (emf); this
     is fixed.


{hline 8} {hi:update 25feb2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Five "easy" graph dialogs have been added to the previous eleven made
    available with the 10feb2003 update. These "easy" graph dialogs have been
    designed so that only the most essential options are exposed.  The
    full-featured graph dialogs are still available when more complex graphing
    is required.  The new easy graph dialogs are

	     Regression fit
	     Pie chart (by variables)
	     Pie chart (by category)
	     Histogram
	     Scatterplot matrix

{p 5 9 2}
{* enhancement}
2.  The datasets used in the Stata manuals are now easily obtained starting
    with help {help dta_contents}.  Links are provided for describing a
    dataset before loading it, using a dataset, and viewing the associated
    help file.

{p 5 9 2}
{* fix}
3.  {help archlm} gave a misleading error message that said the command only
    works after {cmd:regress} and {cmd:newey}.  In fact, it will not work
    after {cmd:newey} and only works after {cmd:regress}.  The error message
    has been corrected.

{p 5 9 2}
{* fix}
4.  {help graph} with the {cmd:twoway}, {cmd:bar}, {cmd:hbar}, {cmd:box},
    {cmd:hbox}, {cmd:pie}, or {cmd:matrix} subcommands may now be specified
    with variables that are labeled with a string that contains unbalanced
    parentheses.  Previously, when a variable had such a label, an error
    message, {error:unbalanced parentheses}, would be issued and the graph was
    not drawn.

{p 5 9 2}
{* fix}
5.  {help graph:graph ... , xtitle()}.  The {{cmd:x}|{cmd:y}}{cmd:title()}
    options would not allow the words "{cmd:if}" or "{cmd:in}" to appear in
    the text of the title unless the text was quoted.  These words may now
    appear in unquoted text.  Note that unbound parentheses must be protected
    by quoting the text.

{p 5 9 2}
{* fix}
6.  {help graph_matrix:graph matrix , diagonal()} now allows blank strings,
    for example, {cmd:""} or {cmd:`""'}, to be specified in the {cmd:diagonal()}
    option.  Previously this produced an error.

{p 5 9 2}
{* enhancement}
7.  {help histogram} and {help twoway_histogram:twoway histogram} have a new
    option {cmd:percent} that labels the vertical axis in percentages.

{p 5 9 2}
{* fix}
8.  {help intreg} would give an inappropriate error message when the
    {help matsize} was too small.  The error message has been improved.

{p 5 9 2}
{* fix}
9.  {help svyprop} would ignore {cmd:if} and {cmd:in}; this is fixed.

{p 4 9 2}
{* fix}
10.  {help svytest}, an out-of-date command superseded by {help test}, had a
     problem with extra quotation marks when version was set less than 8; this
     is fixed.

{p 4 9 2}
{* fix}
11.  {help twoway_histogram:twoway histogram} now allows {cmd:histogram} to be
     abbreviated down to {cmd:hist}, as documented in
     {hi:[G] graph twoway histogram}.

{p 4 9 2}
{* enhancement}
12.  {help twoway_lfitci:twoway lfitci}, {help twoway_qfitci:twoway qfitci},
     and {help twoway_fpfitci:twoway fpfitci} have a new option {cmd:nofit}
     that prevents the prediction from being plotted.

{p 4 9 2}
{* fix}
13.  {help twoway_rline:twoway rline} now allows {cmd:rline} to be abbreviated
     down to {cmd:rl}, as documented in {hi:[G] graph twoway rline}.


{hline 8} {hi:update 10feb2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  Eleven "easy" graph dialogs have been added. These "easy" graph dialogs
    have been designed so that only the most essential options are exposed.
    The full-featured graph dialogs are still available when more complex
    graphing is required.  The following easy graph dialogs are available:

{col 14}Scatter plot{...}
{col 44}Dot chart
{col 14}Connected scatter plot{...}
{col 44}Box plot
{col 14}Line graph{...}
{col 44}Horizontal box plot
{col 14}Area graph{...}
{col 44}Function graph
{col 14}Bar chart{...}
{col 44}Overlaid twoway graphs
{col 14}Horizontal bar chart

{p 5 9 2}
{* enhancement}
2.  The {cmd:Misc.} tab has been reorganized to be more intuitive for the
    following full-featured graph dialogs:

{col 14}{dialog bar:Bar chart}{...}
{col 44}{dialog box:Box plot}
{col 14}{dialog hbar:Horizontal bar chart}{...}
{col 44}{dialog hbox:Horizontal box plot}
{col 14}{dialog dot:Dot chart}

{p 5 9 2}
{* fix}
3.  {help bootstrap} now gives an improved error message when supplied with a
    statistic that results in a missing value when computed using the entire
    dataset.

{p 5 9 2}
{* fix}
4.  {help bootstrap} would ignore the {cmd:nopercentile} option; this is
    fixed.

{p 5 9 2}
{* fix}
5.  {help egen:egen ... ends(), tail} would return the whole string instead of
    the empty string when there was not a match; this is fixed.

{p 5 9 2}
{* fix}
6.  {help graph} with the option
    {c -(}{cmd:x}|{cmd:y}{c )-}{cmd:label(}...{cmd:, valuelabels)} did not
    show the labels for axis ticks when the numeric value of the tick was
    outside the range of the {it:x} ({it:y}) data.
    Instead, the numeric value was
    shown.  Labels, when available for the numeric tick value, are now always
    shown when option {cmd:valuelabels} is specified.

{p 5 9 2}
{* fix}
7.  {help graph} options {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title()} and
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:tick()} were implemented and documented
    with the same minimal abbreviation {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:ti()}.
    This sometimes lead to syntax errors when option
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title()} was specified with the minimal
    abbreviation.  The minimal abbreviation for
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:tick()} has been changed to
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:tic()}.

{p 5 9 2}
{* fix}
8.  {help graph_bar:graph bar} when specified with temporary variables as
    either the {it:y} variables or in the
    {cmd:over()} option would sometimes issue
    an error and refuse to draw the graph; this is fixed.

{p 5 9 2}
{* fix}
9.  {help graph_box:graph box} when specified with both the {cmd:capsize()}
    and {cmd:yscale(log)} options would distort the length of the whisker
    caps; this is fixed.

{p 4 9 2}
{* fix}
10.  {help graph_export:graph export} failed to recognize the {cmd:.wmf} and
     {cmd:.emf} suffixes due to a problem introduced in the 30jan2003 update;
     this is fixed.

{p 4 9 2}
{* fix}
11.  {help twoway_rcap:graph twoway rcap} would sometimes draw spurious caps on
     the connecting spikes when the graphed data included missing values; this
     is fixed.

{p 4 9 2}
{* fix}
12.  {help inbase}, asked to convert 0 to another base such as 2
     ({cmd:inbase 2 0}), would loop endlessly (until break was pressed); this
     is fixed.

{p 4 9 2}
{* fix}
13.  {help lrtest} when run under version control with version less than 8
     would not leave behind the {cmd:r()} results; this is fixed.

{p 4 9 2}
{* fix}
14.  {help mkassert:mkassert rclass, saving()} saved the {cmd:r()} results
     from the command that opened the file instead of the {cmd:r()} results of
     the previous command; this is fixed.

{p 4 9 2}
{* fix}
15.  {help rvfplot} incorrectly exchanged the labels for the {it:x} and {it:y}
     axes; this is fixed.

{p 4 9 2}
{* fix}
16.  {help scatter} with the {cmd:jitter()} option combined with the option
     {cmd:yscale(reverse)} or {cmd:xscale(reverse)} produced a graph with no
     plotted points.  Option {cmd:jitter()} may now be combined with option
     {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(reverse)}.

{p 4 9 2}
{* enhancement}
17.  {help xtabond} now labels the dependent variable in the estimation table
     {cmd:D.}{it:depvar} instead of just {it:depvar}.  Likewise,
     {cmd:e(depvar)} is {cmd:D.}{it:depvar} instead of {it:depvar}.  This
     change was made for consistency with the labeling of the right-hand-side
     variables.

{p 4 9 2}
{* enhancement}
18.  {help xtabond} now saves {cmd:e(bnames_ud)} and {cmd:e(depvar_ud)}.
     {cmd:e(bnames_ud)} is the names of the right-hand-side variables in
     undifferenced form.  {cmd:e(depvar_ud)} is the name of the dependent
     variable in undifferenced form.

{p 4 9 2}
{* fix}
19.  {help xtclog}, which was renamed to {help xtcloglog} in Stata 8, returned
     an {cmd:e(cmd)} or {cmd:e(cmd2)} of "{cmd:xtcloglog}" even when run under
     version control.  It now returns "{cmd:xtclog}" when {help version} is
     set to 7 or less, and "{cmd:xtcloglog}" otherwise.  In all cases, the
     {cmd:xtcloglog} command returns "{cmd:xtcloglog}" in {cmd:e(cmd)} or
     {cmd:e(cmd2)}.


{hline 8} {hi:update 30jan2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help graph_combine:graph combine} did not always respect {cmd:noticks}
    and {cmd:nolabels} settings on the x- and y-axes of the graphs being
    combined.  This is fixed.

{p 5 9 2}
{* fix}
2.  {help graph_combine:graph combine} sometimes refused to accept quoted
    filenames for the graphs to combine; now it does.

{p 5 9 2}
{* fix}
3.  (Mac) {help graph_export:graph export} now correctly recognizes the
    {cmd:.pct} suffix.

{p 5 9 2}
{* fix}
4.  {help graph_twoway:graph twoway} refused to accept the {cmd:text()} option
    when the graph had more than one x- or y-axis; this is fixed.

{p 5 9 2}
{* fix}
5.  {help gsort} failed when performed on a no-observation dataset and a
    descending sort was requested.  This is fixed.

{p 5 9 2}
{* fix}
6.  The {help scheme_sj:Stata Journal graphics scheme}
    had too large of a default graph size; this is fixed.  The new size has
    the same aspect ratio as the default graph size for the
    {help scheme_s2:s2color scheme}.

{p 5 9 2}
{* fix}
7.  {help svytest}, an out-of-date command superseded by {help test}, failed
    to allow variable name abbreviations; this is fixed.

{p 5 9 2}
{* fix}
8.  {dialog tab1}'s dialog would not accept multiple variables in the
    "Categorical variable(s)" field; it now does.


    {title:Stata executable}

{p 5 9 2}
{* fix}
9.  Expressions that contained a variable name that

{p 13 17 2}
	1.  Started with the letters {bf:a}-{bf:f}
{p_end}
{p 13 17 2}
	2.  continued, containing only the letters {bf:a}-{bf:f} or
            digits {bf:0}-{bf:9}
{p_end}
{p 13 17 2}
	3.  ended in {bf:x}

{p 9 9 2}
    would generate a syntax error when the variable was immediately followed
    by a {cmd:+} or {cmd:-} followed by a digit or the letters
    {cmd:a}-{cmd:f}.  For instance,
        "{cmd:. generate newvar = fx+2}"
    would produce a syntax error.  This is fixed.  The problem was that
    expressions such as "fx+2" were incorrectly confused with hexadecimal
    literals such as "1.0fx+2".

{p 4 9 2}
{* enhancement}
10.  (Windows) In the 17jan2003 update, the default clipboard format was
     changed from WMF (Windows Metafile) to EMF (Enhanced Metafile) format.
     Older Windows computers did not support EMF format, so a preference has
     been added to the Clipboard tab of the Graph Preferences dialog box to
     allow users to choose between EMF and WMF format.  The default clipboard
     format for modern versions of Windows (XP/2000/NT) is EMF.  The default
     format for older versions of Windows (ME/98) is WMF.

{p 4 9 2}
{* fix}
11.  (Windows) {help reventries:set reventries} did not accept the
     {cmd:permanently} option; now it does.

{p 4 9 2}
{* enhancement}
12.  (Mac) Stata now uses OS X's Quartz 2D drawing engine for drawing
     and printing graphs.  Copying graphs to the clipboard is still limited to
     the PICT format.

{p 4 9 2}
{* fix}
13.  (Mac) Reverse vertical and reverse horizontal text are now
     displayed properly when using the QuickDraw graphics engine for drawing
     graphs.  This only affects graphs copied to the clipboard or saved as
     PICT files.

{p 4 9 2}
{* fix}
14.  (Mac) {help graph_export:graph export {it:filename}.pict} would
     incorrectly report there was an error exporting a graph as a PICT file
     even though there was no error; this is fixed.

{p 4 9 2}
{* fix}
15.  (Mac) Graphs did not honor their aspect ratio until the user
     resized the window manually; this is fixed.

{p 4 9 2}
{* enhancement}
16.  (Mac) The precedence behavior for the Review and Variables windows
     can be set; see help {cmd:varwindow}.

{p 4 9 2}
{* enhancement}
17.  (Mac) The buttons on the Viewer window and Data Editor have been
     changed to use the Small System font.

{p 4 9 2}
{* fix}
18.  (Mac) {help display:display _request()} would prompt the user for
     input, ignore the input, prompt the user again, and then accept the
     input.  This is fixed.


{hline 8} {hi:update 23jan2003} {hline}

    {title:Stata executable (Windows only)}

{p 5 9 2}
{* fix}
1.  {help odbc} incorrectly stored strings in variables that were 127
    characters wider than necessary; this is fixed.

{p 5 9 2}
{* enhancement}
2.  The Review and Variables windows now maintain their position independently
    of the main Stata window.  If you install this as an update, the first
    time you run the new executable the Review and Variables windows may
    not appear or may appear in odd positions.  Select {bf:Default windowing}
    from the {bf:Prefs} menu and then reposition the windows as desired.

{p 5 9 2}
{* fix}
3.  {help update:update swap} would return an error if there was a
    blank in the name of the folder in which Stata is installed; this is fixed.

{p 5 9 2}
{* fix}
4.  {help smalldlg:set smalldlg}, introduced in the 17jan2003 update, did not
    accept the {cmd:permanently} option; now it does.


{hline 8} {hi:update 21jan2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help avplots}, {help gladder}, {help qladder}, {help shewhart}, and
    {help varfcast_graph:varfcast graph} did not drop temporary graphs that
    they created; this is fixed.

{p 5 9 2}
{* fix}
2.  {help twoway_function:graph twoway function} and
    {help twoway_kdensity:graph twoway kdensity}, when the data were sorted by
    a string variable and there were less than 300 observations,
    would change the data in memory.  This is fixed.


{hline 8} {hi:update 17jan2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* enhancement}
1.  {help scatter:graph twoway scatter} with very large datasets under
    {help SpecialEdition:Stata/SE} now produces graphs much faster.


    {title:Stata executable}

{p 5 9 2}
{* enhancement}
2.  {cmd:gllamm}, a user written program, runs faster due to some helper
    routines which are now included as part of Stata's executable.  Type
    {search gllamm, all:search gllamm, all} to locate the {cmd:gllamm}
    command.

{p 5 9 2}
{* enhancement}
3.  {help graph} now allows the {cmd:{c -(}c }...{cmd:{c )-}}
    {help smcl} directive to be used in
    graphical text.  For example,

{p 13 13}
{cmd:. scatter y x, title("Crecimiento demogr{c -(}c a'{c )-}fico")}

{p 9 9 2}
    results in the title {cmd:Crecimiento demogr{c a'}fico}.

{p 5 9 2}
{* fix}
4.  {help preserve} and {help save:save, emptyok}, given a
    multiple-observation dataset with no variables, would create an unreadable
    dataset; this is fixed.  This happened only in the rare case of having
    observations with no variables.

{p 5 9 2}
{* enhancement}
5.  (Windows) The default clipboard format has been changed from WMF (Windows
    Metafile) to EMF (Enhanced Metafile) format.  This was done to ensure that
    items such as filled polygons could be pasted into other applications.

{p 5 9 2}
{* fix}
6.  (Windows 98/ME) Some Windows 98/ME computers may suffer from a memory
    limitation that prevents them from opening some of the larger Stata
    dialog boxes, such as those for graphics commands.  Smaller dialog boxes
    have been implemented and may be selected as the default by typing
    {cmd:set smalldlg}.  See help {help smalldlg} for more information.

{p 9 9 2}
    In addition, if you ran into this limitation, Stata would refuse to
    open dialog boxes subsequently.  This is fixed.

{p 5 9 2}
{* fix}
7.  (Mac) The Viewer window could be slow in loading some help files;
    this is fixed.

{p 5 9 2}
{* fix}
8.  (Mac) The windowing positioning logic for floating windows was
    modified to avoid a bug present in all versions of the Mac OS X operating
    system up to and including 10.2.4.

{p 5 9 2}
{* fix}
9.  (Mac) Old-style programmable dialogs, such as those used by the
    StataQuest, could not be displayed due to a change in Mac OS X;
    this is fixed.  Nonetheless, users are strongly encouraged to program
    dialogs using the new dialog language; see help {help dialogs}.


{hline 8} {hi:update 14jan2003} {hline}

    {title:Ado-files}

{p 5 9 2}
{* fix}
1.  {help graph} and any commands using {cmd:graph} would issue an error
    message and fail if Stata was installed in a directory that contained a
    space anywhere in the full pathname of the directory.  This is fixed.

{p 5 9 2}
{* fix}
2.  {help hetprob} would not work when supplied with the {cmd:difficult}
    option; this is fixed.

{p 5 9 2}
{* fix}
3.  {help lowess} would put the default title, subtitle and note on each graph
    when used with the {cmd:by()} option; this is fixed.

{p 5 9 2}
{* fix}
4.  {help svygnbreg} and {help svynbreg} would not work when supplied with the
    {cmd:irr} option; this is fixed.

{p 5 9 2}
{* fix}
5.  {help twoway} graphs that included a right axis drew the labels on that
    axis using horizontal text (while the text on the left axis was drawn
    vertically).  Both axes are now drawn using vertical text by default.
    This affects graphs drawn with the {help scheme_s1:s1} and
    {help scheme_s2:s2} families of schemes.

{p 5 9 2}
{* fix}
6.  {help twoway_histogram:twoway histogram} would not allow the number of
    bins to exceed the number of observations; this is fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew7to8}.{p_end}

{hline}
