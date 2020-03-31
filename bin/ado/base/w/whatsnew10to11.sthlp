{smcl}
{* *! version 1.4.6  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 11.0 (compared with release 10)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 11.0:

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
    {c |} {bf:this file}        Stata 11.0 new release       2009            {c |}
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


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew11}.


{hline 3} {hi:Stata 11.0 release 13jul2009} {hline}

{title:Remarks}

{pstd}
We will list all the changes, item by item, but first, here are the
highlights:

{phang2}
1.  Stata now allows factor variables!  In estimation, you can now fit 
    models by typing, for example,

            {cmd:. regress y i.sex i.group i.sex#i.group age}{right:(1)}
            {cmd:. regress y i.sex##i.group age         }   {right:(same as 1)}
	    {cmd:. regress y i.sex i.group i.region i.sex#i.group}
            {cmd:      i.sex#i.region i.group#i.region }    {right:(2)}
            {cmd:      i.sex#i.group#i.region}
            {cmd:      age }
	    {cmd:. regress y i.sex##i.group##i.region age}   {right:(same as 2)}

{pmore2}
    and Stata will form for itself the indicator variables for sex, group,
    and region, and their interactions.  You do not use the old {cmd:xi} 
    command, and no new variables will be created in your data.  
    You can form interactions of factor variables with continuous variables, 
    and continuous variables with continuous variables by using the {cmd:c.}
    prefix:

            {cmd:. regress y i.sex##i.group##i.region }
            {cmd:      age c.age#c.age               }      {right:(3)}
	    {cmd:. regress y i.sex##i.group##i.region}
            {cmd:      age i.sex##i.group##i.region#c.age }  {right:(4)}
            {cmd:      c.age#c.age i.sex##i.group##i.region#c.age#c.age}
	    {cmd:. regress y i.sex##i.group##i.region##c.age}  {right:(same as 4)}
            {cmd:      i.sex##i.group##i.region##c.age#c.age}

{pmore2}
    This new factor-variable notation is understood by nearly every 
    Stata estimation command, so you can type, for example,

	     {cmd:. logistic outcome i.treatment##i.sex age bp c.age#c.bp }

{pmore2}
    Factor variables work with {cmd:summarize} and {cmd:list}, too:

	    {cmd:. list outcome i.treatment##i.sex}

{pmore2}
    Factor variables have lots of additional features; see 
     {findalias frfvvarlists}.

{phang2}
2.  Stata 11's new postestimation command {cmd:margins}
    estimates margins and marginal effects.  Included are estimated marginal
    means, least-squares means, average and conditional marginal and partial
    effects, average and conditional adjusted predictions, predictive margins,
    and more.  There are few users who will not find {cmd:margins} useful.  It
    will be well worth your time to read {manhelp margins R}.

{phang2}
3.
    Stata's new {cmd:mi} suite of commands performs multiple imputation.
    There is so much to say that {cmd:mi} gets its own manual.

{pmore2}
    {cmd:mi} provides methods for the analysis of incomplete data, data for
    which some values are missing, and provides both the imputation
    and estimation steps.  {cmd:mi}'s estimation step combines the
    estimation and pooling steps.  Multivariate normal imputation is provided,
    along with five univariate methods that can be used alone or as building
    blocks for multivariate imputation.

{pmore2}
    {cmd:mi} can import already imputed data, including data from
    NHANES and {cmd:ice}.  {cmd:mi} solves the problem of keeping
    multiple datasets in sync.  You can create or drop variables or observations
    just as if you were working with one dataset.  You can merge, append, and
    reshape data, all of which is to say that you can perform data management
    either before or even after forming the imputations.

{pmore2}
    Included is an interactive control panel that provides access to almost
    all of {cmd:mi}'s capabilities and guides you through the steps of
    analysis.

{pmore2}
    See {manhelp mi_intro MI:intro}.

{phang2}
4.  The new Variables Manager is the one-stop place to go to manage your 
    variables.  Click on the Variables Manager button or type {cmd:varmanage}.  
    You can change names, labels, display formats, and storage types.
    You can define and edit notes, and define and edit value labels.  The
    Variables Manager is useful even for those who have thousands of variables
    in their data; just type part of the name in the filter at the top
    left.
    See {manhelp varmanage D} and
       [GS] 7 Using the Variables Manager
       ({mansection GSM 7UsingtheVariablesManager:GSM},
        {mansection GSU 7UsingtheVariablesManager:GSU}, or
        {mansection GSW 7UsingtheVariablesManager:GSW}).

{phang2}
5.  The Data Editor is all new.  It is now a live view onto your data, which 
    means that you can run a Stata command and see the changes reflected
    immediately.  You can apply filters to view subsets of your data, take
    snapshots so that you can undo changes, and enter dates and times the
    natural way.  See {manhelp edit D} and [GS] 6 Using the Data Editor
    ({mansection GSM 6UsingtheDataEditor:GSM},
     {mansection GSU 6UsingtheDataEditor:GSU}, or
     {mansection GSW 6UsingtheDataEditor:GSW}).

{phang2}
6.  The Do-file Editor under Windows is all new, too.  Syntax highlighting and
    code folding are provided.  There is no limit to file size.
    See {manhelp doedit D}.

{phang2}
7.  You can now put bold and italic text, Greek letters, symbols,
    superscripts, and subscripts on graphs!  See {manhelpi text G-4}.

{phang2}
8.  If you are not reading this on your computer, you could be.
    Stata now has PDF manuals -- [GS], [U], [D],
    [G], [MI], [MV], [R], [ST], [SVY], [TS], [XT], [P], [M], and
    [I] -- and they are shipped with every copy
    of Stata.  Select {bf:Help > PDF Documentation}.  Even better, the
    manuals are integrated into the help system.  From a help file, you can
    jump directly to the relevant page just by clicking on the reference.
    There is nothing more to know.

{pstd}
There are other exciting new features in this release depending on who
you are and what interests you.  These include

{phang2}
 o competing-risks regression models; see {manhelp stcrreg ST}

{phang2}
 o GMM estimation; see {manhelp gmm R}

{phang2}
 o state-space (Kalman filtering) modeling; see {manhelp sspace TS}

{phang2}
 o multivariate GARCH; see {manhelp dvech TS}

{phang2}
 o dynamic-factor models; see {manhelp dfactor TS}

{phang2}
 o unit-root tests for panel data; see {manhelp xtunitroot XT}

{phang2}
 o error structures for linear mixed models; see {manhelp xtmixed XT}

{phang2}
 o standard errors for BLUPs in linear mixed models;
                    see {manhelp xtmixed XT}

{phang2}
 o object-oriented programming in Mata; see {helpb m2_class:[M-2] class}

{phang2}
 o full model-based optimization in Mata; see
                    {helpb mf_moptimize:[M-5] moptimize()}

{phang2}
 o numerical derivative function in Mata; see
                    {helpb mf_deriv:[M-5 deriv()}

{pstd}
Each of these, and more, is covered in the sections that follow.


    {title:What's new in the GUI and command interface}

{phang2}
1.  As mentioned in the highlights, the new Variables Manager is the 
    one-stop place to go to manage your variables.  
    See {manhelp varmanage D} and
       [GS] 7 Using the Variables Manager
       ({mansection GSM 7UsingtheVariablesManager:GSM},
        {mansection GSU 7UsingtheVariablesManager:GSU}, or
        {mansection GSW 7UsingtheVariablesManager:GSW}).

{phang2}
2.  Also a highlight is the new Data Editor, a live view onto your data. 
    See {manhelp edit D} and
       [GS] 6 Using the Data Editor
       ({mansection GSM 6UsingtheDataEditor:GSM},
        {mansection GSU 6UsingtheDataEditor:GSU}, or
        {mansection GSW 6UsingtheDataEditor:GSW}).

{phang2}
3.  The Do-file Editor is all new under Windows and provides 
    syntax highlighting and code folding.  See {manhelp doedit D}.

{phang2}
4.  You doubtlessly have already noticed that Stata's Results window now has a
    white background.  Stata has several new color schemes, and the one you are 
    seeing is called {bf:Standard}.  What was the default scheme in Stata 10
    is called {bf:Classic}, so if you want it back, select
    {bf:Edit > Preferences > General Preferences...} and change the
    scheme for the Results window to it.  You can try the other schemes or
     make your own and save it in {bf:Custom 1}, {bf:Custom 2}, or 
     {bf:Custom 3}.

{phang2}
5.  In Stata for Windows, you can now choose from among five different default 
    layouts for the overall size and position of Stata's windows or,
    just as previously, you can make your own.  Select 
    {bf:Edit > Preferences > Load Preference Set} and pick a layout.
    In addition to {bf:Factory Settings}, available are
    {bf:Compact Window Layout} and three {bf:Presentation}
    layouts optimized for different projector resolutions.

{phang2}
6.  Output scrolling in the Results window is now significantly faster.
    Also, the upper limit of {cmd:set} {cmd:scrollbufsize} has been 
    increased to 2,000,000.  See {manhelp set R}.

{phang2}
7.  In Stata for Windows, Graph windows no longer float.

{phang2}
8.  In Stata for Windows, existing command {cmd:windows} {cmd:manage} 
    has new subcommand {cmd:prefs} for loading and saving 
    named preference sets; type {cmd:help} {cmd:window} {cmd:manage} 
    for details.

{phang2}
9.  Stata for Unix(GUI) now supports copying graphs to the Clipboard
    in bitmap format.

{p 7 12 2}
10.  Stata for Mac now supports copying graphs to the Clipboard in PDF
    format.

{p 7 12 2}
11.  Stata for Mac's graphical user interface (GUI) has been completely
    rewritten in Apple's Cocoa programming interface.

{p 7 12 2}
12.  Stata for Mac is now available as a universal binary that runs natively
     on 32-bit Intel- or PowerPC-based Macs and 64-bit Intel-based Macs to
     deliver optimal performance for all three architectures in a single
     package.


    {title:What's new in data management}

{phang2}
1.  Existing command {cmd:merge} has all new syntax.  It is easier to use,
    easier to read, and makes it less likely that you will make a mistake.
    Merges are classified as {cmd:1:1}, {cmd:1:m}, {cmd:m:1}, and {cmd:m:m}.
    When you type {cmd:merge} {cmd:1:1}, you are saying that you expect the
    observations to match one-to-one.  {cmd:merge} {cmd:1:m} specifies a
    1-to-many merge; {cmd:m:1}, a many-to-1 merge; and {cmd:m:m}, a
    many-to-many merge.  New options {cmd:assert()} and {cmd:keep()} allow you
    to specify what you expect the outcome to be and what you want to keep
    from it.  For instance,

            {cmd:. merge 1:1 subjid using} {it:filename}{cmd:, assert(match)}

{pmore2}
    means that you expect all the observations in both datasets to match each
    other, whereas

	    {cmd:. merge 1:1 subjid using} {it:filename}{cmd:, assert(match using) keep(match)}

{pmore2}
    specifies that you expect each observation to either match or be solely 
    from the using data and, assuming that is true, you want to keep only 
    the matches.

{pmore2}
    Sorting of both the master and the using datasets is now automatic.

{pmore2}
    The new {cmd:merge} does not support merging multiple files in one step.
    Merge the first two datasets, then merge that result with the next dataset, 
    and so on.

{pmore2}
    {cmd:merge} now aborts with error if variables are string in one 
    dataset and numeric in the other unless new option {cmd:force} 
    is specified.

{pmore2}
    See {manhelp merge D}.  The old {cmd:merge} syntax continues to work.

{phang2}
2.  Existing command {cmd:append} has several new features:  1) it will work
    even if there are no data in memory; 2) multiple files can be appended in
    one step; and 3) new option {opt generate(newvar)} creates a
    variable indicating the source of the observations, numbered 0, 1, ....
    {cmd:append} now aborts with error if variables are string in one dataset
    and numeric in the other unless new option {cmd:force} is specified.  See
    {manhelp append D}.  Old behavior is preserved under version control.

{phang2}
3.  Stata's default memory allocations have changed:

{phang3}
a.  Stata/SE and Stata/MP now default to allocating
        50 M of memory rather than 10 M.  Stata/IC
        now defaults to 10 M rather than 1 M.  Stata's required
        footprint has not grown; we reset these defaults because users were
        resetting to larger numbers anyway.

{phang3}
b.  Stata/IC now defaults {cmd:matsize} to 400 rather than 200;
        the default for Stata/SE and Stata/MP remains 400.  The
        default for Small Stata is now 100 rather than 40.

{phang2}
4.  Existing command {cmd:order} now does what {cmd:order}, {cmd:move}, and
    {cmd:aorder} did; see {manhelp order D}.  Old commands {cmd:aorder} and
    {cmd:move} continue to work but are no longer documented.

{phang2}
5.  New commands {cmd:zipfile} and {cmd:unzipfile} compress and uncompress
    files and directories in zip archive format.  See {manhelp zipfile D}.

{phang2}
6.  New command {cmd:changeeol} converts text from one operating system's
    end-of-line format to another's.  Stata does not care about end-of-line
    format, but some editors and other programs do.  See {manhelp changeeol D}.

{phang2}
7.  New command {cmd:snapshot} saves to disk and restores from disk copies of
    the data in memory.  {cmd:snapshot} is used by the new Data Editor.
    An important feature of the Data Editor is that it can log all the changes
    you make interactively.  {cmd:snapshot} will show up in those logs. 
    {cmd:snapshot} really is a command of Stata, so you can replay logs 
    to duplicate past efforts.  For your own use, however, it is better 
    if you continue using {cmd:preserve} and {cmd:restore}.
    See {manhelp snapshot D}.

{phang2}
8.  You can now copy-and-paste commands from logs and execute them 
    without editing out the period (the dot prompt) in front!  Stata 11 ignores
    leading periods.

{phang2}
9.  Existing command {cmd:notes} has new options {cmd:search}, {cmd:replace},
    and {cmd:renumber}.  See {manhelp notes D}.

{p 7 12 2}
10.
    Concerning value labels:

{phang3}
a.  Existing command {cmd:label} {cmd:define} has new option {cmd:replace}
        so that you do not have to drop the value label before redefining it.

{phang3}
b.  New command {cmd:label} {cmd:copy} copies value labels.

{phang3}
c.  Existing command {cmd:label} {cmd:values} now allows a varlist, so you
        can label (or unlabel) a group of variables at the same time.

{pmore2}
    See {manhelp label D}.

{p 7 12 2}
11.  Existing command {cmd:expand} has new option 
    {opt generate(newvar)} that makes it easier to distinguish
    original from duplicated observations.  See {manhelp expand D}.

{p 7 12 2}
12.  Concerning {cmd:egen}:

{phang3}
a.  New function {opt rowmedian(varlist)} returns, observation
        by observation, the median of the values in {it:varlist}.

{phang3}
b.  New function {opt rowpctile(varlist)}{cmd:,} 
        {opt p(#)} returns, observation by observation, the
        {it:#}th row percentile of the values within {it:varlist}.

{phang3}
c.  Existing function {opt mode(varname)} with option 
        {cmd:missing} treats missing values as a category.  When {cmd:version}
	is set to {cmd:10} or less, {cmd:missing} does not treat missing as a
        category.

{phang3}
d.  Existing functions {opt total(exp)} and 
        {opt rowtotal(varlist)} have new option {cmd:missing}.  If
        all values of {it:exp} or {it:varlist} for an observation are
        missing, then that observation in {it:newvar} will be set to
        missing.

{pmore2} See {manhelp egen D}.

{p 7 12 2}
13.  Existing command {cmd:copy} now allows copying a file to a directory
    without having to type the filename twice; see {manhelp copy D}.

{p 7 12 2}
14.  Existing command {cmd:clear} now allows {cmd:clear} {cmd:matrix} to clear
    all Stata matrices (as distinguished from Mata matrices) from memory; see
    {manhelp clear D}.

{p 7 12 2}
15.  Existing command {cmd:outfile} now exports date variables as strings
    rather than their underlying numeric value.  Under version control, old
    behavior is restored.  See {manhelp outfile D}.

{p 7 12 2}
16.
    Existing command {cmd:reshape} now preserves variable and value labels
    when converting from long to wide and restores variable and value labels
    when converting from wide to long.  Thus the value and variable labels for
    the {cmd:i} variable, which exists in long form but not in wide form, are
    restored when converting back from wide to long.  The value labels of the
    {cmd:xij} variables are similarly restored.  Prior behavior is preserved
    when {cmd:version} is {cmd:10} or earlier.  See {manhelp reshape D}.

{p 7 12 2}
17.
    Existing command {cmd:collapse} now allows new statistics {cmd:semean},
    {cmd:sebinomial}, and {cmd:sepoisson} for obtaining the standard error of
    the mean.  See {manhelp collapse D}.

{p 7 12 2}
18.
    Existing command {cmd:destring} allows new option {cmd:dpcomma} to convert
    to numeric form string representation of numbers using commas as the
    decimal point.  See {manhelp destring D}.

{p 7 12 2}
19.  Concerning existing command {cmd:odbc}:

{phang3}
a.  {cmd:odbc} {cmd:insert} now uses parameterized inserts, which
                are faster.

{phang3}
b.  The dialogs for {cmd:odbc} {cmd:load} and {cmd:odbc}
                {cmd:insert} can now store a data-source user ID and
                password for a Stata session.

{phang3}
c.  {cmd:odbc} {cmd:query} has new options {cmd:verbose} and
                {cmd:schema}.  {cmd:verbose} lists any data source alias,
                nickname, typed table, typed view, and view along with tables
                so that data from these table types can be loaded. 
                {cmd:schema} lists schema names with the table names if the data
                source returns schema information.

{phang3}
d.  {cmd:odbc} {cmd:insert} has a new dialog.

{phang3}
e.  Existing option {cmd:dsn()} now allows the data source to be
                up to 499 characters.

{phang3}
f.  {cmd:odbc} now reports driver errors directly.  Previously,
                {cmd:odbc} would issue the error "ODBC error; type
                -set debug on- and rerun command to see extended error
                information" when an ODBC driver issued an error.

{phang3}
g.  {cmd:odbc}, with {cmd:set} {cmd:debug} {cmd:on},
                for security reasons no longer displays the data source name,
                user ID, and password used for connecting to your data
                source.

{pmore2}
See {manhelp odbc D}.

{p 7 12 2}
20.  New function {cmd:strtoname()} converts a general string to a
        string meeting Stata's naming conventions.
        Also, existing functions
        {cmd:lower()},
        {cmd:ltrim()},
        {cmd:proper()},
        {cmd:reverse()},
        {cmd:rtrim()}, and
        {cmd:upper()}
        now have synonyms
        {cmd:strlower()},
        {cmd:strltrim()},
        ..., and
        {cmd:strupper()}.
        Both sets of names work equally well.
        See {helpb string functions:[FN] String functions}.

{p 7 12 2}
21.  New function {cmd:soundex()} returns the soundex code for a name,
        consisting of a letter followed by three numbers.  New function
        {cmd:soundex_nara()} returns the U.S. Census soundex for a name,
        also consisting of a letter followed by three numbers, but produced
        by a different algorithm.
        See {helpb string functions:[FN] String functions}.

{p 7 12 2}
22.  New functions {cmd:sinh()}, {cmd:cosh()}, {cmd:asinh()}, and
        {cmd:acosh()} join existing functions {cmd:tanh()} and {cmd:atanh()}
        to provide the hyperbolic functions.
        See {helpb trig functions:[FN] Trigonometric functions}.

{p 7 12 2}
23.  New functions
        {cmd:binomialp()};
        {cmd:hypergeometric()} and {cmd:hypergeometricp()};
        {cmd:nbinomial()}, {cmd:nbinomialp()}, and {cmd:nbinomialtail()};
        and
        {cmd:poisson()}, {cmd:poissonp()}, and {cmd:poissontail()}
        provide distribution and probability mass for the
        binomial, hypergeometric, negative binomial, and Poisson
        distributions.
        See {helpb stat functions:[FN] Statistical functions}.

{p 7 12 2}
24.  New functions
        {cmd:invnbinomial()} and {cmd:invnbinomialtail()}, and
        {cmd:invpoisson()} and {cmd:invpoissontail()}
        provide inverses for the negative binomial and Poisson distributions.
        See {helpb stat functions:[FN] Statistical functions}.

{p 7 12 2}
25.  Algorithms for the existing functions {cmd:normal()} and
        {cmd:lnnormal()}  have been improved to operate in 60%
        and 75% of the time, respectively, while giving equivalent
        double-precision results.

{p 7 12 2}
26.  New functions
        {cmd:rbeta()},
        {cmd:rbinomial()},
        {cmd:rchi2()},
        {cmd:rgamma()},
        {cmd:rhypergeometric()},
        {cmd:rnbinomial()},
        {cmd:rnormal()},
        {cmd:rpoisson()}, and
        {cmd:rt()}
        produce random variates for the
        beta, binomial, chi-squared, gamma, hypergeometric,
        negative binomial, normal, Poisson, and Student's t distributions,
        respectively.

{pmore2}
Old function {cmd:uniform()} has been renamed to {cmd:runiform()},
        but {cmd:uniform()} continues to work.

{pmore2}
Thus all random-variate functions start with {cmd:r}.

{pmore2}
        See {helpb random number functions:[FN] Random-number functions}.

{p 7 12 2}
27.  Existing command {cmd:drawnorm} now uses new function
        {cmd:rnormal()} to generate random variates.  When {cmd:version} is
        set to {cmd:10} or earlier, {cmd:drawnorm} reverts to using
        {cmd:invnormal(uniform())}.
        See {helpb random number functions:[FN] Random-number functions}.

{p 7 12 2}
28.  Existing command {cmd:describe} now respects the width of the
        Results window when formatting output; see {manhelp describe D}.

{p 7 12 2}
29.  Existing command {cmd:renpfix} now returns the list of variables
        changed in {cmd:r(varlist)};
        see {cmd:[D] rename}.

{p 7 12 2}
30.  Previously existing command {cmd:impute} still works but is now
        undocumented.  It is replaced by the new multiple-imputation
        command {cmd:mi}.  See the
        {mansection MI Intro:{it:Multiple-Imputation Reference Manual}}.


    {title:What's new in statistics (general)}

{phang2}
1.
    The highlight of this release is statistics related, namely, factor
    variables.  We have already said a lot about them.  You will not be able
    to avoid them.  You will not want to avoid them.  See 
    {findalias frfvvarlists}.

{phang2}
2.
    The new postestimation command {cmd:margins} is also a highlight of this
    release.  {cmd:margins} estimates margins and marginal effects.  Included
    are estimated marginal means, least-squares means, average and conditional
    marginal and partial effects, average and conditional adjusted
    predictions, predictive margins, and more.  We urge you to read
    {manhelp margins R}.

{pmore2}
    {cmd:margins} replaces old commands {cmd:mfx} and {cmd:adjust}.  {cmd:mfx}
    and {cmd:adjust} are no longer documented but continue to work under
    version control.

{phang2}
3.
    New command {cmd:mi} performs multiple imputation; see 
    {manhelp mi_intro MI:intro}.

{phang2}
4.
    New command {cmd:misstable} makes tables that help you understand
    the pattern of missing values in your data; see {manhelp misstable R}.

{phang2}
5. 
    New command {cmd:gmm} implements the generalized method of moments
    estimator.
    {cmd:gmm} allows linear and nonlinear models; allows one-step, two-step, and
    iterative estimators; works with cross-sectional, time-series, and panel
    data; and allows panel-style instruments.  To fit a model, you need
    only write the expressions of the moments.  See {manhelp gmm R}.

{phang2}
6.
    Concerning factor variables:

{phang3}
a.
        Factor variables may be specified with almost all estimation
        commands (see item 6g below).  

{phang3}
b.
        If an estimation command works with factor variables, so do its
        postestimation commands.  If the postestimation command accepts
        or requires a varlist, factor variables may be specified.

{phang3}
c.
         Factor variables may be specified with existing commands {cmd:list}
         and {cmd:summarize}.

{phang3}
d.
        Commands that allow factor variables also allow 
        new options affecting how output appears: 
		{cmd:vsquish}, 
		{cmd:baselevels},
        	{cmd:allbaselevels}, 
		{cmd:noemptycells}, and
		{cmd:noomitted}.
        Many commands that work with factor variables, such as
        {cmd:estat} {cmd:summarize}, {cmd:estat} {cmd:vce}, and the like, also
        allow the above options.  Estimation commands also allow new option
        {cmd:coeflegend}.  See
        {manhelp estimation_options R:estimation options}.

{pmore3}
        {cmd:coeflegend} is useful when you wish to access the coefficients or
        standard errors individually using {cmd:_b[]} or {cmd:_se[]},
        such as when you are using {cmd:lincom}, {cmd:nlcom}, or {cmd:test}.
        {cmd:coeflegend} provides what you need to type.

{pmore3}
	{cmd:vsquish} reduces the amount of white space used 
        vertically to display results.

{pmore3}
        Stata used to drop covariates because of collinearity before performing
        estimation.  This is now handled differently.  Stata dropped variables
        for three reasons: because they were 1) base levels of factors,
        2) levels corresponding to interactions where there were no data, and
        3) truly collinear.  These are now identified separately.

{pmore3}
	New option {cmd:baselevels} says to report reason 1 in main effects.

{pmore3}
	New option {cmd:allbaselevels} says to report reason 1 in all terms.

{pmore3}
	New option {cmd:noemptycells} says not to report reason 2.

{pmore3}
	New option {cmd:noomitted} says not to report reason 3.

{phang3}
e.
        New command {cmd:fvset} allows you to specify default base levels and
        design settings for variables that can be recorded in the dataset and
        so remembered from one session to the next; see {manhelp fvset R}.

{phang3}
f.
        New command {cmd:set} {cmd:emptycells} {cmd:drop} specifies that all
        estimation commands drop covariates associated with empty cells from
        estimation.  The default is {cmd:set} {cmd:emptycells} {cmd:keep}.  If
        you have sufficient memory, it is better to keep the covariates
        because then new postestimation command {cmd:margins} can better
        identify nonestimability.

{phang3}
g. 
    	Factor variables are allowed with the following estimation commands:
	{cmd:anova},
	{cmd:areg},
	{cmd:binreg},
	{cmd:biprobit},
	{cmd:blogit},
	{cmd:bootstrap},
	{cmd:bprobit},
	{cmd:clogit},
	{cmd:cloglog},
	{cmd:dfactor},
	{cmd:dvech},
	{cmd:eivreg},
	{cmd:frontier},
	{cmd:glm},
	{cmd:glogit},
	{cmd:gnbreg},
	{cmd:gprobit},
	{cmd:heckman},
	{cmd:heckprob},
	{cmd:hetprob},
	{cmd:intreg},
	{cmd:ivprobit},
	{cmd:ivregress},
	{cmd:ivtobit},
	{cmd:jackknife},
	{cmd:logistic},
	{cmd:logit},
	{cmd:manova},
	{cmd:mlogit},
	{cmd:mprobit},
	{cmd:mvreg},
	{cmd:nbreg},
	{cmd:newey},
	{cmd:ologit},
	{cmd:oprobit},
	{cmd:poisson},
	{cmd:prais},
	{cmd:probit},
	{cmd:reg3},
	{cmd:regress},
	{cmd:rologit},
	{cmd:rreg},
	{cmd:scobit},
	{cmd:slogit},
	{cmd:sspace},
	{cmd:stcox},
	{cmd:streg},
	{cmd:sureg},
	{cmd:svy},
	{cmd:tobit},
	{cmd:treatreg},
	{cmd:truncreg},
	{cmd:xtcloglog},
	{cmd:xtfrontier},
	{cmd:xtgee},
	{cmd:xtgls},
	{cmd:xtintreg},
	{cmd:xtivreg},
	{cmd:xtlogit},
	{cmd:xtmelogit},
	{cmd:xtmepoisson},
	{cmd:xtmixed},
	{cmd:xtnbreg},
	{cmd:xtpcse},
	{cmd:xtpoisson},
	{cmd:xtprobit},
	{cmd:xtrc},
	{cmd:xtreg},
	{cmd:xtregar},
	{cmd:xttobit},
	{cmd:zinb},
	{cmd:zip},
	{cmd:ztnb}, and
	{cmd:ztp}.

{phang2}
7.
    {cmd:anova} and {cmd:manova} now use Stata's new factor-variable 
    syntax, which means new estimation and postestimation features 
    and a few changes to what you type.

{phang3}
a.
        In other estimation commands, covariates are assumed to be continuous
	unless {cmd:i.} is specified in front of variable names. In {cmd:anova}
	and {cmd:manova}, covariates are assumed to be factors unless {cmd:c.}
        is specified.

{phang3}
b.
	To form an interaction, you now use {it:varname}{cmd:#}{it:varname}
        rather than {it:varname}{cmd:*}{it:varname}.  A {cmd:*} now means 
        variable-name expansion.  A {cmd:|} continues to be used to indicate 
        nesting.

{phang3}
c.
	{it:varname1}{cmd:##}{it:varname2} can now be specified to 
        indicate full factorial layout, i.e, {it:varname1} {it:varname2} 
	{it:varname1}{cmd:#}{it:varname2}.
        You can use 
	{it:varname1}{cmd:##}{it:varname2}{cmd:##}{it:varname3}
        to form 3-way factorial layouts, and so on.

{phang3}
d.
        No longer allowed are negative and noninteger levels for categorical
	variables.  Options {cmd:category()}, {cmd:class()}, and
	{cmd:continuous()} are no longer allowed; instead, factor-variable
        notations {cmd:i.} and {cmd:.} are used where there might be ambiguity.

{phang3}
e.
        Reporting option {cmd:regress} is no longer allowed.  To redisplay 
        results, use the {cmd:regress} command after {cmd:anova}, or the
        {cmd:mvreg} command after {cmd:manova}.

{phang3}
f. 
        Option {cmd:detail} is no longer allowed nor necessary.  Output
        produced by {cmd:anova} and {cmd:manova} is self explanatory, and you
        can use {cmd:regress} or {cmd:mvreg} if you want factor-level
        information.

{phang3}
g.
        Option {cmd:noanova} is no longer allowed.  To suppress output, type
        {cmd:quietly} in front of the command just as you would with any other
        estimation command. 

{phang3}
h.
        New option {cmd:dropemptycells} makes {cmd:anova} and {cmd:manova} more
        space efficient by dropping from {cmd:e(b)} and {cmd:e(V)} any
        interactions for which there are no observations.  The disadvantage 
        is that new postestimation command {cmd:margins} then cannot 
        identify nonestimability and issue the appropriate warnings; see
        {manhelp margins R}.

{phang3}
i.
        The following postestimation commands now work after {cmd:anova} just
        as they do after {cmd:regress}:  
	{cmd:dfbeta}, 
	{cmd:estat} {cmd:imtest}, 
	{cmd:estat} {cmd:szroeter},
        {cmd:estat} {cmd:vif},
	{cmd:hausman}, 
	{cmd:lrtest}, 
	{cmd:margins}, 
	{cmd:predictnl}, 
	{cmd:nlcom}, 
	{cmd:suest}, 
	{cmd:testnl}, and 
	{cmd:testparm}.
        Full {cmd:estat} {cmd:hettest} syntax is now allowed, too.

{phang3}
j.
        The following postestimation commands now work after {cmd:manova} just
        as they do after {cmd:mvreg}:  
	{cmd:margins}, 
	{cmd:nlcom}, 
	{cmd:predictnl}, and
	{cmd:testnl}.

{phang3}
k.
        Existing command {cmd:test} used after {cmd:anova}
        now allows all the syntaxes allowed after {cmd:regress} while
        continuing to allow the special syntaxes for {cmd:anova}.

{phang3}
l.
        Existing command {cmd:test} used after {cmd:manova} now allows all the
        syntaxes allowed after {cmd:mvreg} while continuing to allow the
        special syntaxes for {cmd:manova}.

{pmore2}
        Old {cmd:anova} and {cmd:manova} syntaxes continue to work under
        version control.  See {manhelp anova R} and {manhelp manova MV}. 

{phang2}
8.
    Concerning the {cmd:bootstrap} and {cmd:jackknife} prefix commands:

{phang3}
a.
	They may now be used with {cmd:anova} and {cmd:manova}.

{phang3}
b.
        {cmd:bootstrap}'s new option {cmd:jackknifeopts()} allows options to
        be passed to {cmd:jackknife} for computing acceleration values for
        BCa confidence intervals.

{phang3}
c.
        {cmd:bootstrap} no longer overwrites the macro {cmd:e(version)}, which
        the command being prefixed saved.

{phang2}
9.
    Concerning fractional polynomial regression:

{phang3}
a.  Existing commands {cmd:fracpoly} and {cmd:mfp} have a new syntax. They
        are now prefix commands, so you type 
        {cmd:fracpoly,} ... {cmd:} {it:estimation_command} 
	and 
	{cmd:mfp,} ... {cmd::} {it:estimation_command}.
	Old syntax continues to be understood.

{phang3}
b.  Option {cmd:adjust()} used by {cmd:fracpoly}, {cmd:mfp}, and
	{cmd:fracgen} is renamed {cmd:center()}.  The old option continues to
        be understood.

{phang3}
c.  {cmd:fracpoly} now works with {cmd:intreg}; see {manhelp intreg R}.

{phang3}
d.  {cmd:mfp} now works with {cmd:intreg}; see {manhelp intreg R}.

{pmore2}
    See {manhelp fracpoly R} and {manhelp mfp R}.

{p 7 12 2}
10.
    Concerning the existing {cmd:estimates} command: 

{phang3}
a.
        {cmd:estimates} {cmd:save} has new option {cmd:append}, which allows
        results to be appended to an existing file. See
        {manhelp estimates_save R:estimates save}.

{phang3}
b.
        {cmd:estimates} {cmd:use} and {cmd:estimates} {cmd:describe}
	{cmd:using} have new option {opt number(#)}, which specifies the
	results to be used or described.  See 
        {manhelp estimates_save R:estimates save} and
        {manhelp estimates_describe R:estimates describe}.

{phang3}
c.
        {cmd:estimates} {cmd:table} now supports factor variables and
        time-series-operated variables and so supports the new options 
	{cmd:vsquish}, 
	{cmd:noomitted}, 
	{cmd:baselevels}, 
	{cmd:allbaselevels}, and {cmd:noemptycells}; 
	see {manhelp estimates_table R:estimates table}.

{p 7 12 2}
11.
    Concerning existing estimation command {cmd:ivregress}: 

{phang3}
a.  New postestimation command {cmd:estat} {cmd:endogenous} for use with
        {cmd:ivregress} {cmd:2sls} and {cmd:ivregress} {cmd:gmm} performs
        tests of whether endogenous regressors can be treated as exogenous;
        see {manhelp ivregress_postestimation R:ivregress postestimation}.

{phang3}
b.  New option {cmd:perfect} for use with {cmd:ivregress} {cmd:2sls} and
        {cmd:ivregress} {cmd:gmm} allows perfect instruments; it skips
        checking whether endogenous regressors are collinear with excluded
        instruments (see {manhelp ivregress R}).

{p 7 12 2}
12.
    Concerning {cmd:regress}: 

{phang3}
a.
    Existing postestimation command {cmd:dfbeta} now names the variables it
    creates differently.  Variables are now named {cmd:_dfbeta_}{it:#}
    rather than {cmd:DF}{it:name}.  The old naming convention is restored 
    under version control.

{phang3}
b.
    New option {cmd:notable} suppresses display of the coefficient table.

{pmore2}
    See {manhelp regress R}.

{p 7 12 2}
13.
     Constraints are now allowed by existing estimation commands {cmd:blogit},
     {cmd:bprobit}, {cmd:logistic}, {cmd:logit}, {cmd:ologit}, {cmd:oprobit},
     and {cmd:probit}.  New option {cmd:collinear} specifies not to omit
     collinear variables from the model.

{p 7 12 2}
14.
     New option {cmd:nocnsreport} for use on estimation commands suppresses
     display of constraints.  See
      {manhelp estimation_options R:estimation options}.

{p 7 12 2}
15.
    Existing command {cmd:pcorr} can now calculate semipartial correlation
    coefficients; see {manhelp pcorr R}.

{p 7 12 2}
16.
    Existing command {cmd:pwcorr} has new option {cmd:listwise}
    to omit observations in which any of the variables contain missing 
    and thus mimic {cmd:correlate}'s treatment of missing values, 
    while maintaining access to all of {cmd:pwcorr}'s other features;
    see {manhelp correlate R}.

{p 7 12 2}
17.
    Existing estimation command {cmd:glm} now allows option
    {cmd:ml} in {cmd:family(nbinomial} {cmd:ml)} to allow estimation via
    maximum likelihood; see {manhelp glm R}.

{p 7 12 2}
18.
    Existing estimation commands {cmd:asmprobit} and {cmd:asroprobit} have
    several new features:

{phang3}
a. 
        New option {opt factor(#)} specifies that a factor
        covariance structure with dimension {it:#} be used.

{phang3}
b. 
        New option {cmd:favor(speed} {c |} {cmd:space)} allows you to set
        the speed/memory tradeoff.  {cmd:favor(speed)} is the default.

{phang3}
c. 
        New option {cmd:nopivot} specifies that interval pivoting not be used
        in integration.  By default, the programs pivot the wider of the
        integration intervals into the interior of the multivariate
        integration.  Although this improves the accuracy of the quadrature
        estimate, discontinuities may result in the computation of numerical
        second-order derivatives.

{phang3}
d. 
        New postestimation command {cmd:estat} {cmd:facweights} specifies that
        the covariance factor weights be displayed in matrix form.

{phang3}
e. 
        Existing postestimation command {cmd:estat} {cmd:correlation} now uses a
        default output format of {cmd:%9.4f} instead of the previous
        {cmd:%6.3f}.

{pmore2}
    See {manhelp asmprobit R}, {manhelp asroprobit R}, 
     {manhelp asmprobit_postestimation R:asmprobit postestimation},
     and {manhelp asroprobit_postestimation R:asroprobit postestimation}.

{p 7 12 2}
19.
     {cmd:biprobit} with option {cmd:constraints()} specified now applies
     these constraints when fitting the comparison models.  As such, we
     can now report a likelihood-ratio (LR) test of the comparison
     model test instead of a Wald test.  To obtain a Wald comparison test,
     type {cmd:test} {cmd:[athrho]_cons} after fitting the model.

{p 7 12 2}
20.
    Existing quality-control commands {cmd:cchart}, {cmd:pchart}, {cmd:rchart},
    {cmd:xchart}, and {cmd:shewhart} have new option {cmd:nograph}, which
    suppresses the display of the graph.  These commands also now return in
    {cmd:r()} the relevant values displayed in the charts.  Also, {cmd:pchart}
    has new option {cmd:generate()}, which saves the variables plotted in the
    chart.  See {manhelp qc R}.

{p 7 12 2}
21.
    {cmd:predict} used after {cmd:mlogit}, {cmd:mprobit}, {cmd:ologit}, 
    {cmd:oprobit}, and {cmd:slogit} now defaults to
    predicting the probability of observing the first outcome.  Previously,
    the {cmd:outcome()} option was required.

{p 7 12 2}
22.
    Existing estimation command {cmd:reg3} now reports large-sample statistics
    by default when constraints are specified, regardless of the estimator used.

{p 7 12 2}
23.
    Several estimation commands now accept existing convergence-criterion
    options {opt nrtolerance(#)} and {cmd:nonrtolerance}.
    Commands include {cmd:blogit}, {cmd:factor},
    {cmd:logit}, {cmd:mlogit}, {cmd:ologit}, {cmd:oprobit}, {cmd:probit},
    {cmd:rologit}, {cmd:stcox}, and {cmd:tobit}.  The default is
    {cmd:nrtolerance(1e-5)}.

{p 7 12 2}
24.
    Existing estimation commands {cmd:exlogistic} and {cmd:expoisson} allow
    option {cmd:memory()} to be more than 512 MB; see {manhelp exlogistic R}
    and {manhelp expoisson R}.

{p 7 12 2}
25.
    Existing command {cmd:ssc}, which obtains user-written software 
    from the Statistical Software Components archive, 
    has new syntax {cmd:ssc} {cmd:hot} to list the most-downloaded 
    submissions; see {manhelp ssc R}.


    {title:What's new in statistics (longitudinal data/panel data)}

{phang2}
1.  
    New command {cmd:xtunitroot} performs the Levin-Lin-Chu,
    Harris-Tzavalis, Breitung's, Im-Pesaran-Shin,
    Fisher-type, and Hadri Lagrange multiplier tests for unit roots on panel
    data.  See {manhelp xtunitroot XT}.

{phang2}
2.
    Concerning existing estimation command {cmd:xtmixed}:

{phang3}
a.  
        {cmd:xtmixed} now allows modeling of the residual-error structure of
        the linear mixed models.  Five structures are available:  independent,
	exchangeable, autoregressive (AR), moving average (MA), and
	unstructured.  Use new option {cmd:residuals()}.  Within
	{cmd:residuals()}, you may also specify suboption
	{opt by(varname)} to obtain heteroskedastic versions of the above
        structures.  For example, specifying {cmd:residuals(independent,}
	{cmd:by(sex))} will estimate distinct residual variances for both males
        and females.

{phang3}
b.  
        {cmd:xtmixed} has new options {cmd:matlog} and {cmd:matsqrt}, which
        specify the matrix square root and matrix logarithm variance-component
        parameterizations, respectively.  Previously, {cmd:xtmixed} supported
        the matrix logarithm parameterization only.  Now {cmd:xtmixed}
	supports both parameterizations and the default has changed to
	{cmd:matsqrt}.  Previous default behavior is preserved under version
        control.

{phang3}
c.
	{cmd:xtmixed} now supports time-series operators.

{pmore2}
    See {manhelp xtmixed XT}.

{phang2}
3.
    {cmd:predict} after {cmd:xtmixed} now allows new option {cmd:reses} for
    obtaining standard errors of predicted random effects
    (best linear unbiased predictions).
    See {manhelp xtmixed_postestimation XT:xtmixed postestimation}.

{phang2}
4.  Concerning existing estimation command {cmd:xtreg}:

{phang3}
a.  Specifying {cmd:xtreg,} {cmd:re} {cmd:vce(robust)} now means
               the same as {cmd:xtreg,} {cmd:re} {cmd:vce(cluster}
               {it:panelvar}{cmd:}.  The new interpretation is robust to a
	       broader class of deviations.  The old interpretation is
               available under version control.  

{phang3}
b.  Similarly, specifying 
               {cmd:xtreg,} {cmd:fe} {cmd:vce(robust)} now means
               the same as {cmd:xtreg,} {cmd:fe} {cmd:vce(cluster}
               {it:panelvar}{cmd:)} in light of the new results 
               by Stock and Watson (2008).

{phang3}
c.  {cmd:xtreg} now allows the {cmd:in} {it:range} qualifier.  

{pmore2}
See {manhelp xtreg XT}.

{phang2}
5.  All xt estimation commands now allow Stata's new factor-variable 
        varlist notation, with the exception of commands 
        {cmd:xtabond},
        {cmd:xtdpd},
        {cmd:xtdpdsys}, and
        {cmd:xthtaylor}.
        See {findalias frfvvarlists}.  
        Also, estimation commands allow the standard set of
        factor-variable-related reporting options; see
        {manhelp estimation_options R:estimation options}.

{phang2}
6.  New postestimation command {cmd:margins} is available after 
        all xt estimation commands; see {manhelp margins R}.

{phang2}
7.  Concerning existing estimation commands {cmd:xtmelogit} and
         {cmd:xtmepoisson}:

{phang3}
a.  They have new option {cmd:matsqrt}, which allows you to
              explicitly specify the default matrix square-root
              parameterization.

{phang3}
b.  They now support time-series operators.

{pmore2}
See {manhelp xtmelogit XT} and {manhelp xtmepoisson XT}.

{phang2}
8.  As of Stata 10.1, existing estimation commands 
        {cmd:xtmixed}, {cmd:xtmelogit}, and {cmd:xtmepoisson} 
        require that random-effects specifications contain an explicit level
        variable (or {cmd:_all}) followed by a colon.  Previously, if these
        were omitted, a level specification of {cmd:_all:} was assumed,
        leading to confusion when only the colon was omitted.  To avoid this
        confusion, omitting the colon now produces an error, with previous
        behavior preserved under control.

{phang2}
9.  Existing command {cmd:xttab} now returns the matrix of results 
        in {cmd:r(results)} and the number of panels in {cmd:r(n)}.
        See {manhelp xttab XT}.


    {title:What's new in statistics (time series)}

{phang2}
1.
    New estimation command {cmd:sspace} fits linear state-space models by
    maximum likelihood.  In state-space models, the dependent variables are
    linear functions of unobserved states and observed exogenous variables.
    This includes VARMA, structural time-series, some linear dynamic,
    and some stochastic general-equilibrium models.  {cmd:sspace} can estimate
    stationary and nonstationary models.  See {manhelp sspace TS}.

{phang2}
2.
    New estimation command {cmd:dvech} estimates diagonal vech multivariate
    GARCH models.  These models allow the conditional variance matrix
    of the dependent variables to follow a flexible dynamic structure in which
    each element of the current conditional variance matrix depends on its own
    past and on past shocks.  See {manhelp dvech TS}.

{phang2}
3.  
    New estimation command {cmd:dfactor} estimates dynamic-factor models.  
    These models allow the dependent variables and the unobserved factor
    variables to have vector autoregressive (VAR) structures and to be
    linear functions of exogenous variables.  See {manhelp dfactor TS}.

{phang2}
4.  Estimation commands 
        {cmd:newey},
        {cmd:prais},
        {cmd:sspace},
        {cmd:dvech}, and 
        {cmd:dfactor}
        allow Stata's new factor-variable varlist notation; 
        see {findalias frfvvarlists}.
        Also, these estimation commands allow the 
        standard set of factor-variable-related reporting options; 
        see {manhelp estimation_options R:estimation options}.

{phang2}
5.  New postestimation command {cmd:margins}, which calculates 
        marginal means, predictive margins, marginal effects, and average 
        marginal effects, is available after 
        {cmd:arch},
        {cmd:arima},
        {cmd:newey},
        {cmd:prais},
        {cmd:sspace},
        {cmd:dvech}, and 
        {cmd:dfactor}.
        See {manhelp margins R}.

{phang2}
6.  New display option {cmd:vsquish} for estimation commands, which
	allows you to control the spacing in output containing time-series
	operators or factor variables, is available after all time-series
        estimation commands.  See
         {manhelp estimation_options R:estimation options}.

{phang2}
7.  New display option {cmd:coeflegend} for estimation commands, which
	  displays the coefficients' legend showing how to specify them in an
	  expression, is available after all time-series estimation commands.
          See {manhelp estimation_options R:estimation options}.

{phang2}
8.  {cmd:predict} after {cmd:regress} now allows time-series operators in
        option {cmd:dfbeta()}; see
        {manhelp regress_postestimation R:regress postestimation}.  Also
        allowing time-series operators are {cmd:regress} postestimation commands
        {cmd:estat} {cmd:szroeter}, {cmd:estat} {cmd:hettest}, {cmd:avplot},
        and {cmd:avplots}.  See 
        {manhelp regress_postestimation R:regress postestimation}.

{phang2}
9.  Existing estimation commands {cmd:mlogit}, {cmd:ologit}, and
       {cmd:oprobit} now allow time-series operators; see 
       {manhelp mlogit R}, {manhelp ologit R}, and {manhelp oprobit R}.

{p 7 12 2}
10.  Existing estimation commands {cmd:arch} and {cmd:arima} now accept
        maximization option {cmd:showtolerance}; see {manhelp maximize R}.

{p 7 12 2}
11.  Existing estimation command {cmd:arch} now allows you to fit models
        assuming that the disturbances follow Student's t distribution or the
        generalized error distribution, as well as the Gaussian (normal)
	distribution.  Specify which distribution to use with option
	{cmd:distribution()}.  You can specify the shape or degree-of-freedom
	parameter, or you can let {cmd:arch} estimate it along with the other
        parameters of the model.  See {manhelp arch TS}.

{p 7 12 2}
12.  Existing command {cmd:tsappend} is now faster. 
        See {manhelp tsappend TS}.


    {title:What's new in statistics (survival analysis)}

{phang2}
1.
    Stata's new {cmd:stcrreg} command fits competing-risks regression models.
    In a competing-risks model, subjects are at risk of failure because of two
    or more separate and possibly correlated causes.  See {manhelp stcrreg ST}.
    Existing command {cmd:stcurve} will now graph cumulative incidence
    functions after {cmd:stcrreg}; see {manhelp stcurve ST}.

{phang2}
2.
    Stata's new multiple-imputation features may be used with {cmd:stcox},
    {cmd:streg}, and {cmd:stcrreg}; see {manhelp mi_intro MI:intro}.

{phang2}
3.  Factor variables may now be used with {cmd:stcox}, {cmd:streg}, and
    {cmd:stcrreg}.  
    See {findalias frfvvarlists}.

{phang2}
4.  New postestimation command {cmd:margins}, which calculates 
        marginal means, predictive margins, marginal effects, and average 
        marginal effects, is available after 
        {cmd:stcox},
        {cmd:streg}, and
        {cmd:stcrreg}.
        See {manhelp margins R}.

{phang2}
5.  New reporting options {cmd:baselevels} and {cmd:allbaselevels}
    control how base levels of factor variables are displayed in output tables.
    New reporting option {cmd:noemptycells} controls whether missing cells in
    interactions are displayed.  

{pmore2}
These new options are supported by estimation commands {cmd:stcox},
    {cmd:streg}, and {cmd:stcrreg}, and by existing postestimation commands
    {cmd:estat} {cmd:summarize} and {cmd:estat} {cmd:vce}.  See
    {manhelp estimation_options R:estimation options}.

{phang2}
6.  New reporting option {cmd:noomitted} controls whether covariates
    that are dropped because of collinearity are reported in output tables.  By
    default, Stata now includes a line in estimation and related output tables
    for collinear covariates and marks those covariates as "(omitted)".
    {cmd:noomitted} suppresses those lines.  

{pmore2}
{cmd:noomitted} is supported by estimation commands {cmd:stcox},
    {cmd:streg}, and {cmd:stcrreg}, and by existing postestimation commands
    {cmd:estat summarize} and {cmd:estat vce}.  See 
    {manhelp estimation_options R:estimation options}.

{phang2}
7.  New option {cmd:vsquish} eliminates blank lines in estimation and
    related tables.  Many output tables now set off factor variables and
    time-series-operated variables with a blank line.  {cmd:vsquish}
    removes these lines.  

{pmore2}
{cmd:vsquish} is supported by estimation commands {cmd:stcox},
    {cmd:streg}, and {cmd:stcrreg}, and by existing postestimation command
    {cmd:estat summarize}.  See
     {manhelp estimation_options R:estimation options}.

{phang2}
8.  Estimation commands {cmd:stcox}, {cmd:streg}, and {cmd:stcrreg}
    support new option {cmd:coeflegend} to display the coefficients' legend
    rather than the coefficient table.  The legend shows how you would type a
    coefficient in an expression, in a test command, or in a constraint
    definition.  See {manhelp estimation_options R:estimation options}.

{phang2}
9.  Estimation commands {cmd:streg} and {cmd:stcrreg}
    support new option {cmd:nocnsreport} to suppress reporting constraints;
    see {manhelp estimation_options R:estimation options}.

{p 7 12 2}
10.  Concerning {cmd:predict}:

{phang3}
a.  {cmd:predict} after {cmd:stcox} offers three new diagnostic
              measures of influence:  DFBETAs, likelihood displacement
              values, and LMAX statistics.  See 
         {manhelp stcox_postestimation ST:stcox postestimation}.

{phang3}
b.  {cmd:predict} after {cmd:stcox} can now calculate diagnostic 
              statistics 
              {cmd:basesurv()},
              {cmd:basechazard()}, {cmd:basehc()}, {cmd:mgale()},
              {cmd:effects()}, {cmd:esr()}, {cmd:schoenfeld()}, and
              {cmd:scaledsch()}.
              Previously, you had to request these statistics when you
              fit the model by specifying the option with the {cmd:stcox}
              command.  Now you obtain them by using {cmd:predict} after
              estimation.  The options continue to work with {cmd:stcox}
              directly but are no longer documented.  See
              {manhelp stcox_postestimation ST:stcox postestimation}.

{phang3}
c.  {cmd:predict} after {cmd:stcox} and {cmd:streg} now produces
              subject-level residuals by default.  Previously, record-level or
              partial results were produced, although there was an
              inconsistency.  This affects multiple-record data only because
              there is no difference between subject-level and partial
	      residuals in single-record data.  This change affects
	      {cmd:predict}'s options {cmd:mgale}, {cmd:csnell},
	      {cmd:deviance}, and {cmd:scores} after {cmd:stcox} (and new
	      options {cmd:ldisplace}, {cmd:lmax}, and {cmd:dfbeta}, of
	      course); and it affects {cmd:mgale} and {cmd:deviance} after
	      {cmd:streg}.  {cmd:predict,} {cmd:deviance} was the
              inconsistency; it always produced subject-level results.

{pmore3}
For instance, in previous Stata versions you typed

                {cmd:. predict cs, csnell}

{pmore3}
to obtain partial Cox-Snell residuals.  One statistic per
              record was produced.  To obtain subject-level residuals, for which
              there is one per subject and which {cmd:predict} stored on each
              subject's last record, you typed

                {cmd:. predict ccs, ccsnell}

{pmore3}
In Stata 11, when you type 

                {cmd:. predict cs, csnell}

{pmore3}
you obtain the subject-level residual.  To obtain the partial,
              you use the new {cmd:partial} option:

                {cmd:. predict cs, csnell partial}

{pmore3}
The same applies to all the other residuals.  Concerning the
              inconsistency, partial deviances are now available.

{pmore3}
Not affected is {cmd:predict,} {cmd:scores} after {cmd:streg}.
              Log-likelihood scores in parametric models are mathematically
              defined at the record level and are meaningful only if evaluated
              at that level.

{pmore3}
Prior behavior is restored under version control.
              See {manhelp stcox_postestimation ST:stcox postestimation}, 
              {manhelp streg_postestimation ST:streg postestimation}, and 
              {manhelp stcrreg_postestimation ST:stcrreg postestimation}.

{p 7 12 2}
11.  {cmd:stcox} now allows up to 100 time-varying covariates as specified 
         in option {cmd:tvc()}.  The previous limit was 10.
         See {manhelp stcox ST}.

{p 7 12 2}
12.  Existing commands {cmd:stcurve} and {cmd:estat} {cmd:phtest} no
	 longer require that you specify the appropriate options to {cmd:stcox}
	 before using them.  The commands automatically generate the statistics
         they require.  See {manhelp stcurve ST} and
         {helpb stcox_diagnostics:[ST] stcox PH-assumption tests}.

{p 7 12 2}
13.  Existing epitab commands {cmd:ir}, {cmd:cs}, {cmd:cc},
         and {cmd:mhodds} now treat missing categories of variables in
         {cmd:by()} consistently.  By default, missing categories are now
         excluded from the computation.  This may be overridden by specifying
         {cmd:by()}'s new option {cmd:missing}.  See {manhelp epitab R}.

{p 7 12 2}
14.  Existing command {cmd:sts} {cmd:list} has new option {cmd:saving()},
          which creates a dataset containing the results.
         See {manhelp sts_list ST:sts list}.


    {title:What's new in statistics (multivariate)}

{phang2}
1. New command {cmd:mvtest} performs multivariate tests on means, 
      covariances, and correlations (both one-sample and multiple-sample),
      and it performs tests of univariate, bivariate, and multivariate
      normality.  Included are 
      Box's M test for covariances, 
      and for tests of normality, 
      the Doornik-Hansen omnibus test, 
      Henze-Zirkler test, 
      Mardia's multivariate kurtosis test, 
      and 
      Mardia's multivariate skewness test.
      See {manhelp mvtest MV}.

{phang2}
2.  The new factor-variable syntax allowed throughout Stata affects
      {cmd:manova} even though {cmd:manova} always allowed factor variables. 
      See {manhelp manova MV}.

{phang3}
a.  {cmd:manova} has an all-new syntax.  The old syntax continues 
             to work under version control.

{phang3}
b.  {cmd:manova}, just like {cmd:anova}, adopts the new 
             factor-variable syntax, but with a twist.  In other 
             Stata commands, continuous is assumed and you use 
             {cmd:i.}{it:varname} to indicate a categorical variable.
             In {cmd:manova} and {cmd:anova}, categorical is assumed 
             and you use {cmd:c.}{it:varname} to indicate continuous.
             Thus the options {cmd:category()}, {cmd:class()}, and 
             {cmd:continuous()} are no longer used.

{phang3}
c.  To form an interaction, you use {it:varname1}{cmd:#}{it:varname2}. 
      Previously, you used {it:varname1}{cmd:*}{it:varname2}.  A {cmd:*}
      now means variable-name expansion, just 
             as it does on other commands, so you could type 
             {cmd:manova} {cmd:y*} {cmd:=} {cmd:a} {cmd:b*} {cmd:a#b*}.
             The {cmd:|} symbol continues to be used for nesting.

{phang3}
d.  You can now use {it:varname1}{cmd:##}{it:varname2} as 
             a shorthand for full factorial, meaning {it:varname1}
             {it:varname2} {it:varname1}{cmd:#}{it:varname2}.
	     You can use {it:varname1}{cmd:##}{it:varname2}{cmd:##}{it:varname3}
             for 3-way factorial, and so on.

{phang2}
3.  Existing command {cmd:mvreg} may now be used after {cmd:manova} 
             to show results in regression-style format, just as 
             {cmd:regress} can be used after {cmd:anova}.  See 
            {manhelp manova MV}.

{phang2}
4.  Existing command {cmd:test} after {cmd:manova}, 
             in addition to allowing the special syntax previously provided,
             now allows all the standard {cmd:test} syntax, too.
             See {manhelp manova_postestimation MV:manova postestimation}.

{phang2}
5.  Existing commands 
             {cmd:predictnl},
             {cmd:nlcom},
             {cmd:testnl}, and 
             {cmd:testparm}
             may now be used after {cmd:manova}; 
             see {manhelp predictnl R}, {manhelp nlcom R}, {manhelp testnl R},
              and {manhelp test R}.

{phang2}
6.  New postestimation command {cmd:margins} may be used after
          {cmd:manova}. See {manhelp margins R}.

{phang2}
7.  {cmd:manova} now requires that categorical variables take on
        nonnegative integer values.  Previously, a categorical variable could
        take on values -1, 2.5, 3.14159, etc., although few did.  
        Arbitrary values are still allowed under version control.
        See {manhelp manova MV}.

{phang2}
8.  {cmd:manova}'s new option {cmd:dropemptycells} removes 
        unobserved levels from the model rather than setting their 
        coefficients to zero.  Statistically, the approaches are equivalent.
	Computationally, a larger {cmd:matsize} is required when empty cells
	are retained.  In models with many interactions, you may need to
        specify this option.  See {manhelp manova MV} and see 
       {manhelp set_emptycells R:set emptycells}.

{phang2}
9.  Programmers:  The row and column names on {cmd:e(b)}, 
             {cmd:e(V)}, etc., after {cmd:manova}
             are now meaningful and follow standard factor-variable notation.
             See {it:What's new} in {manlink P Intro}.

{p 7 12 2}
10.  Existing command {cmd:biplot} has several improvements:

{phang3}
a.  {cmd:biplot} can now be used with larger datasets.  Previously,
                the row dimension was limited by Stata's maximum {cmd:matsize}.

{phang3}
b.  {cmd:biplot} has new option {cmd:generate()}, which saves the
                coordinates of observations in variables.

{phang3}
c.  {cmd:biplot} has new options {cmd:rowover()} and
		{cmd:row}{it:#}{cmd:opts()}, which
                allow highlighting groups of
                observations on the graph and customizing the look of the
                graph.

{phang3}
d.  New option {cmd:rowlabel()} makes customizing rows easier.

{phang3}
e.  {cmd:biplot} now drops constant variables from the computation.

{phang3}
f.  {cmd:biplot} now uses an improved version
                of the singular value
                decomposition, which may result in sign
                differences and slight differences in values.

{phang3}
g.  {cmd:rowopts()}, {cmd:colopts()}, and {cmd:negcolopts()} now
                allow names to contain simple and compound quotes.

{phang3}
h.  {cmd:biplot} did not honor option {cmd:scheme(economist)} for
                separate graphs (option {cmd:separate}).  This has been fixed.

{p 7 12 2}
11.  Existing command {cmd:canon}'s default output has changed.  
        It previously displayed something that looked like estimation output
        but was not because standard errors were conditional.  The output 
        now looks like you would expect.  The conditional output can be 
        obtained by specifying new option {cmd:stderr} or under version 
        control (set {cmd:version} to {cmd:10} or earlier). 

{p 7 12 2}
12.  The manual now includes a glossary; see {manhelp mv_glossary MV:Glossary}.
 

    {title:What's new in statistics (survey)}

{phang2}
1.  New command {cmd:margins}, a highlight of the release, 
        may be used after estimation, whether 
        survey or not, but will be of special interest to those doing survey
	estimation.  One aspect of {cmd:margins} -- predictive
	margins -- was developed by survey statisticians for reporting
        survey results.

{pmore2}
{cmd:margins} lets you explore the response surface of a
        fitted model in any metric of interest -- means, linear
        predictions, probabilities, marginal effects, risk differences, 
        and so on.
        {cmd:margins} can evaluate responses for fixed values
        of the covariates or for observations in a sample or subsample.
        Average responses can be obtained, not just responses that are
        conditional on fixed values of the covariates.  Survey-adjusted
        standard errors and confidence intervals are reported based on
        a linearized variance estimator of the response that accounts for the
        sampling distribution of the covariates.  Thus inferences can be made
        about the population.  See {manhelp margins R}.

{phang2}
2.  Survey estimators may be used with Stata's new multiple-imputation 
        features.  Either {cmd:svyset} your data before you 
        {cmd:mi} {cmd:set} your data or use {cmd:mi} {cmd:svyset} afterward.
        See {manhelp mi_intro MI:intro}.

{phang2}
3.  Survey commands now report population and subpopulation sizes 
        with a larger number of digits, reserving scientific notation 
        only for sizes greater than 99 trillion.
        
{phang2}
4.  Survey estimation commands may now be used with factor variables; 
        see {findalias frfvvarlists}.

{phang2}
5.  New reporting options {cmd:baselevels} and {cmd:allbaselevels}
	control how base levels of factor variables are displayed in output
	tables.  New reporting option {cmd:noemptycells} controls whether
	missing cells in interactions are displayed.  These new options are
	supported by existing prefix command {cmd:svy} and existing
	postestimation commands {cmd:estat effects} and {cmd:estat vce}.  See
        {manhelp estimation_options R:estimation options}.

{phang2}
6.  New reporting option {cmd:noomitted} controls whether covariates that
	are dropped because of collinearity are reported in output tables.  By
	default, Stata now includes a line in estimation and related output
	tables for collinear covariates and marks those covariates as
        "(omitted)".  {cmd:noomitted} suppresses those lines.

{pmore2}
 {cmd:noomitted} is supported by prefix command {cmd:svy} and
	postestimation commands {cmd:estat effects} and
        {cmd:estat vce}.  See {manhelp estimation_options R:estimation options}.

{phang2}
7.  New option {cmd:vsquish} eliminates blank lines in estimation and
	related tables.  Many output tables now set off factor variables and
	time-series-operated variables with a blank line.
	{cmd:vsquish} removes these lines.

{pmore2}
{cmd:vsquish} is supported by prefix command {cmd:svy} and
        postestimation command {cmd:estat effects}.

{phang2}
8.  Prefix command {cmd:svy} now supports new option {cmd:coeflegend} to
	display the coefficients' legend rather than the coefficient table.
	The legend shows how you would type a coefficient in an expression, in
	a test command, or in a constraint definition.  See
        {manhelp estimation_options R:estimation options}.

{phang2}
9.  Prefix command {cmd:svy} now supports new option {cmd:nocnsreport} to
        suppress reporting constraints; see
        {manhelp estimation_options R:estimation options}.


    {title:What's new in statistics (multiple imputation)}

{phang2}
1.
    All of it.  Multiple imputation is about the analysis of data for which
    some values are missing.  See {manhelp mi_intro MI:intro}.

{phang2}
2.
    New command {cmd:misstable} makes tables that help you understand the
    pattern of missing values in your data; see {manhelp misstable R} and
    {manhelp mi_misstable MI:mi misstable}.

{phang2}
3.
    Estimation commands that may be used with {cmd:mi} {cmd:estimate} include
    the following:

{p2colset 13 30 32 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :Linear regression models}{p_end}
{p2col 15 30 32 2: {helpb regress}}Linear regression{p_end}
{p2col 15 30 32 2: {helpb cnsreg}}Constrained linear regression{p_end}
{p2col 15 30 32 2: {helpb mvreg}}Multivariate regression{p_end}

{p2col:Binary-response regression models}{p_end}
{p2col 15 30 32 2: {helpb logistic}}Logistic regression, reporting odds ratios{p_end}
{p2col 15 30 32 2: {helpb logit}}Logistic regression, reporting coefficients{p_end}
{p2col 15 30 32 2: {helpb probit}}Probit regression{p_end}
{p2col 15 30 32 2: {helpb cloglog}}Complementary log-log regression{p_end}
{p2col 15 30 32 2: {helpb binreg}}GLM for the binomial family{p_end}

{p2col:Count-response regression models}{p_end}
{p2col 15 30 32 2: {helpb poisson}}Poisson regression{p_end}
{p2col 15 30 32 2: {helpb nbreg}}Negative binomial regression{p_end}
{p2col 15 30 32 2: {helpb nbreg:gnbreg}}Generalized negative binomial regression{p_end}

{p2col:Ordinal-response regression models}{p_end}
{p2col 15 30 32 2: {helpb ologit}}Ordered logistic regression{p_end}
{p2col 15 30 32 2: {helpb oprobit}}Ordered probit regression{p_end}

{p2col:Categorical-response regression models}{p_end}
{p2col 15 30 32 2: {helpb mlogit}}Multinomial (polytomous) logistic regression{p_end}
{p2col 15 30 32 2: {helpb mprobit}}Multinomial probit regression{p_end}
{p2col 15 30 32 2: {helpb clogit}}Conditional (fixed-effects) logistic regression{p_end}

{p2col:Quantile regression models}{p_end}
{p2col 15 30 32 2: {helpb qreg}}Quantile regression{p_end}
{p2col 15 30 32 2: {helpb qreg:iqreg}}Interquantile range regression{p_end}
{p2col 15 30 32 2: {helpb qreg:sqreg}}Simultaneous-quantile regression{p_end}
{p2col 15 30 32 2: {helpb qreg:bsqreg}}Quantile regression with bootstrap standard errors{p_end}

{p2col:Survival regression models}{p_end}
{p2col 15 30 32 2: {helpb stcox}}Cox proportional hazards model{p_end}
{p2col 15 30 32 2: {helpb streg}}Parametric survival models{p_end}
{p2col 15 30 32 2: {helpb stcrreg}}Competing-risks regression{p_end}

{p2col:Other regression models}{p_end}
{p2col 15 30 32 2: {helpb glm}}Generalized linear models{p_end}
{p2col 15 30 32 2: {helpb areg}}Linear regression with a large dummy-variable set{p_end}
{p2col 15 30 32 2: {helpb rreg}}Robust regression{p_end}
{p2col 15 30 32 2: {helpb truncreg}}Truncated regression{p_end}

{p2col:Descriptive statistics}{p_end}
{p2col 15 30 32 2: {helpb mean}}Estimate means{p_end}
{p2col 15 30 32 2: {helpb proportion}}Estimate proportions{p_end}
{p2col 15 30 32 2: {helpb ratio}}Estimate ratios{p_end}

{p2col:Survey regression models}{p_end}
{p2col 15 30 32 2: {helpb svy:svy:}}Estimation commands for survey data (excluding commands that are not listed above){p_end}
{p2line}
{p2colreset}{...}


    {title:What's new in graphics}

{phang2}
1.
    A release highlight, text in graphs now supports multiple fonts.  You can
    display symbols, Greek letter, subscripts, superscripts, as well as text
    in multiple font faces including bold and italic.  See 
    {manhelpi text G-4}.
    Everything is automatic, but you can set up the fonts to be used; see
    {manhelp graph_set G-2:graph set}, {manhelpi ps_options G-3}, and 
    {manhelpi eps_options G-3}.

{phang2}
2.  Stata's Graph Editor can now record a series of edits and
       apply them to other graphs; see
       {help graph editor##recorder:Graph Recorder}
       in {manhelp graph_editor G-1:graph editor}.
       You can also apply recorded edits from the command line.
       See {manhelp graph_play G-2:graph play} and see option 
       {opt play(recordingname)} in {manhelpi std_options G-3} and
       {manhelp graph_use G-2:graph use}.

{phang2}
3.  The dialog box for {cmd:graph} {cmd:twoway}
       now allows plots to be reordered when multiple plots have been defined.


    {title:What's new in programming}

{phang2}
1.  
    The big news in programming concerns 
    parsing varlists containing factor variables, 
    dealing with factor variables, 
    and processing matrices whose row or column names contain factor variables.

{phang3}
a. {cmd:syntax} will allow varlists to contain factor variables 
           if new specifier {cmd:fv} is among the specifiers in the 
           description of the varlist, for instance, 

{p 16 20 2}
{cmd:syntax varlist(fv)} {cmd:[if]} {cmd:[in]} {cmd:[,}
    {cmd:Detail]}

{pmore3}
Similarly, {cmd:syntax} will allow a {cmd:varlist} option to
           include factor variables if {cmd:fv} is included among
           its specifiers:

{p 16 20 2}
{cmd:syntax varlist(fv)} {cmd:[if]} {cmd:[in]} {cmd:[,}
          {cmd:Detail]} {cmd:EQ(varlist} {cmd:fv)}

{pmore3}
See {manhelp syntax P}.

{phang3}
b. You can use resulting macro {cmd:`varlist'} as the varlist 
           for any Stata command that allows factor varlists.

{phang3}
c. Factor varlists come in two flavors, general and specific. 
           An example of a general factor varlist is {cmd:mpg}
           {cmd:i.foreign}.  The corresponding specific factor 
           varlist might be

{p 16 20 2}
 {cmd:mpg} {cmd:i(0} {cmd:1)b0.foreign}

{pmore3}
A specific factor varlist is specific with respect to a 
           given problem, which is to say, a given dataset and subsample.  The
           specific varlist identifies the values taken on by factor
           variables and the base.

{pmore3}
Users usually specify general factor varlists, although they 
           can specify specific ones.  In the process of your program, a
           factor varlist, if it is general, will become specific.  This is
           usually automatic.

{pmore3}
Existing commands {cmd:_rmcoll} and {cmd:_rmdcoll} now accept a
           general or specific factor varlist and return a specific varlist
           in {cmd:r(varlist)}.  See {manhelp _rmcoll P}.

{pmore3}
Existing command {cmd:ml} accepts a general or specific factor
           varlist and returns a specific varlist, in this case in the row and
           column names of the vectors and matrices it produces; see 
          {manhelp ml R}. 
           The same applies to Mata's new {cmd:moptimize()} function, which is
           equivalent to {cmd:ml}; see {manhelp mf_moptimize M-5:moptimize()}.

{pmore3}
Similarly, all Stata estimation commands that allow factor 
           varlists return the specific varlist in the row and column names of 
           {cmd:e(b)} and {cmd:e(V)}.

{pmore3}
Factor varlist {cmd:mpg} {cmd:i(0} {cmd:1)b0.foreign} is 
           specific.  The same varlist could be written 
           {cmd:mpg} {cmd:i0b.foreign} {cmd:i1.foreign}, so that 
           is specific, too.  The first is specific and unexpanded.  
           The second is specific and expanded.
           New command {cmd:fvexpand} takes a general or specific (expanded
           or unexpanded) factor varlist, {cmd:if} or {cmd:in}, 
           and returns a fully expanded, specific varlist.  See 
           {manhelp fvexpand P}.

{pmore3}
New command {cmd:fvunab} takes a general or specific factor 
           varlist and returns it in the same form, but with variable
           names unabbreviated.  See {manhelp unab P}.

{phang3}
d.  Matrix row and column names are now generalized to include factor
           variables.  The row or column names contain the elements from a fully
           expanded, specific factor varlist.  Because a fully expanded,
  	   specific factor varlist is a factor varlist, the contents of the row
           or column names can be used with other Stata commands as a varlist.
           Unrelatedly, the equation portion of the row or column name now has
           a maximum length of 127 rather than the previous 32.

{phang3}
e.  The treatment of variables that are omitted because of
           collinearity has changed.  Previously, such variables were 
           dropped from {cmd:e(b)} and {cmd:e(V)} except by {cmd:regress}, 
           which included the variables but set the corresponding element 
           of {cmd:e(b)} to zero and similarly set the corresponding row and
           column of {cmd:e(V)} to zero.  Now all Stata estimators that 
           allow factor variables work like {cmd:regress}.

{pmore3}
Also, if you want to know why the variable was dropped, you can 
           look at the corresponding element of the row or column name. 
           The syntax of an expanded, specific varlist allows operators 
           {cmd:o} and {cmd:b}.  Operator {cmd:o} indicates omitted
           either because the user specified omitted or because of 
           collinearity;
           {cmd:b} indicates omitted because of being a base category.
           For instance, {cmd:o.mpg} would indicate that {cmd:mpg} was omitted, 
           whereas {cmd:i0b.foreign} would indicate that {cmd:foreign}=0
           was omitted because it was the base category.  Either way, 
           the corresponding element of {cmd:e(b)} will be zero, as will 
           the corresponding rows and columns of {cmd:e(V)}.

{pmore3}
This new treatment of omitted variables -- previously called 
	   dropped variables -- can cause old user-written programs to
	   break.  This is especially true of old postestimation commands not
	   designed to work with {cmd:regress}.  If you set {cmd:version} to
	   {cmd:10} or earlier before estimation, however, then estimation
	   results will be stored in the old way and the old postestimation
           commands will work.  The solution is

                {cmd:. version 10}
	        {cmd:.} {it:estimation_command} ...
                {cmd:.} {it:old_postestimation_command} ...
                {cmd:. version 11}

{pmore3}
When running under {cmd:version 10} or earlier, you may not use 
           factor variables with the estimation command.

{phang3}
f.  Because omitted variables are now part of estimation results,
            constraints play a larger role in the implementation of
            estimators.  Omitted variables have coefficients constrained 
            to be zero. {cmd:ml} now handles such constraints automatically
            and posts in {cmd:e(k_autoCns)} the number of such constraints, 
            which can be due to the variable being used as the base, being
            empty, or being omitted.  {cmd:makecns} similarly saves in 
            {cmd:r(k_autoCns)} the number of such constraints, and in 
            {cmd:r(clist)}, the constraints used.  The matrix of constraints
            is now posted with {cmd:ereturn} {cmd:post} and saved, as usual,
            in {cmd:e(Cns)}.  {cmd:ereturn} {cmd:matrix} no longer posts
            constraints.  Old behavior is preserved under version control.
            See {manhelp ml R},  {manhelp makecns P}, and {manhelp ereturn P}.

{phang3}
g.  There are additional commands to assist in using and 
           manipulating factor varlists that are documented only online;
           type {cmd:help} {cmd:undocumented} in Stata.

{phang2}
2.  Factor variables also allow interactions. 
        Up to eight-way interactions are allowed.

{phang3}
a.  Consider the interaction {cmd:a#b}. If each took on two levels, 
           the unexpanded, specific varlist would be 
           {cmd:i(1 2)b1.a#i(1 2)b1.b}.
           The expanded, specific varlist would be 
           {cmd:1b.a#1b.b 1b.a#2.b 2.a#1b.b 2.a#2.b}.

{phang3}
b.  Consider the interaction {cmd:c.x#c.x}, where {cmd:x} 
           is continuous.  
           The unexpanded and expanded, specific varlists are 
           the same as the general varlist:  {cmd:c.x#c.x}.

{phang3}
c.  Consider the interaction {cmd:a#c.x}.
           The unexpanded, specific varlist is 
           {cmd:i(1 2).a#c.x},
           and the expanded, specific varlist is
	   {cmd:1.a#c.x 2.a#c.x}.

{phang3}
d.  All of these varlists are handled in the same way that factor 
           variables are handled, as outlined in item 1 above.

{phang2}
3.  
        New command {cmd:fvrevar} creates equivalent, temporary variables for
        any factor variables, interactions, or times-series-operated
        variables so that older commands can be easily converted to working 
	with factor variables.  We hasten to add that, in general, Stata 
	does not follow the {cmd:fvrevar} approach.
	Think of this {cmd:fvrevar} as a generalization 
	of {cmd:tsrevar}.  See {manhelp fvrevar R}.

{phang2}
4.
    Factor variables lead to a number of additions to what is saved in
    {cmd:e()} and sometimes {cmd:r()}:

{phang3}
a.
        Estimation commands that post {cmd:e(V)} now post the corresponding
        rank of the matrix in scalar {cmd:e(rank)}.

{phang3}
b.
        Estimation commands that allow constraints now post the constraints
        matrix in matrix {cmd:e(Cns)}.

{phang3}
c.
        In many estimation commands allowing constraints, and in the
        programming command {cmd:makecns}, scalar {cmd:e(k_autoCns)} is now
        posted containing the sum of the number of base, empty, and omitted
        constraints.

{phang3}
d.
	Programming command {cmd:makecns} now save the constraints used 
	in macro {cmd:r(clist)}.

{phang3}
e.
        Estimation commands that allow factor variables now post in macro
        {cmd:e(asbalanced)} the name of each factor variable participating in
        {cmd:e(b)} that was {cmd:fvset} {cmd:design} {cmd:asbalanced} and post
        in macro {cmd:e(asobserved)} the name of each factor variable
	participating in {cmd:e(b)} that was {cmd:fvset} {cmd:design}
        {cmd:asobserved}.

{phang3}
f.
        Estimation commands now post in macros how new command {cmd:margins}
        is to treat their prediction statistics when the statistics require
        special treatment.  These macros are 
	{cmd:e(marginsok)},
	{cmd:e(marginsnotok)}, and
        {cmd:e(marginsprop)}.

{pmore3}
        {cmd:e(marginsok)} specifies the name of predictors that are to be
        allowed and that appear to violate {cmd:margins}' usual rules, such as
        dependent variables being involved in the calculation.

{pmore3}
	{cmd:e(marginsnotok)} are statistics that {cmd:margins} fails to 
	identify as violating assumptions but that do and should not be allowed.

{pmore3}
        {cmd:e(marginsprop)} provides special signals as to how statistics
        for the estimator must be handled.  Currently allowed are
	combinations of {cmd:addcons}, {cmd:noeb}, and {cmd:nochainrule}.
	{cmd:addcons} means that the estimated equations have no constant even
	if the user did not specify {cmd:noconstant} at estimation time.
	{cmd:noeb} means that the estimator does not store the covariate names
	in the column names of {cmd:e(b)}.  {cmd:nochainrule} means that the
        chain rule may not be used to calculate derivatives.

{phang3}
g.
        Matrix {cmd:e(V_modelbased)}, the model-based VCE, is now
        posted by most estimation commands that allow robust variance
        estimation by {cmd:bootstrap} and {cmd:jackknife}.

{phang3}
h.
        Existing command {cmd:sktest} now returns in matrix {cmd:r(N)} the 
        matrix of observation counts and in matrix {cmd:r(Utest)} the matrix
        of test results.

{phang2}
5.
    Existing command {cmd:estimates} {cmd:describe} {cmd:using} now saves in
    scalar {cmd:r(nestresults)} the number of sets of estimation results saved
    in the {cmd:.ster} file.

{phang2}
6.
    Existing command {cmd:correlate} saves in matrix {cmd:r(C)} the
    correlation or covariance matrix.

{phang2}
7.  Existing command {cmd:ml} has been rewritten.  It is now implemented
        in terms of new Mata function and optimization engine {cmd:moptimize()}.
        The new {cmd:ml} handles automatic or implied constraints, posts 
        some additional information to {cmd:e()}, and allows evaluators 
	written in Mata as well as ado.  See {manhelp maximize R} for an
        overview and see {manhelp ml R} and 
        {manhelp mf_moptimize M-5:moptimize()}.

{phang2}
8.  Existing command {cmd:estimates} {cmd:save} now has option 
        {cmd:append}, which allows storing more than one set of estimation 
        results in the same file; see 
        {manhelp estimates_save R:estimates save}.

{phang2}
9.  Existing commands {cmd:ereturn} {cmd:post} and {cmd:ereturn} 
        {cmd:repost} now work with more commands, including 
        {cmd:logit}, {cmd:mlogit}, {cmd:ologit}, {cmd:oprobit}, {cmd:probit},
        {cmd:qreg}, {cmd:_qreg}, {cmd:regress}, {cmd:stcox}, and {cmd:tobit}.
        Also, {cmd:ereturn} {cmd:post} and {cmd:ereturn} {cmd:repost}
        now allow weights to be specified and save them in {cmd:e(wtype)} and
        {cmd:e(wexp)}.  See {manhelp ereturn P}.

{p 7 12 2}
10.  Existing command {cmd:markout} has new option {cmd:sysmissok},
        which excludes observations with variables equal to system missing
	({cmd:.}) but not to extended missing ({cmd:.a}, {cmd:.b}, ...,
	{cmd:.z}); see {manhelp mark P}.  This has to do with new emphasis on
        imputation of missing values; see {manhelp mi_intro MI:intro}.

{p 7 12 2}
11.  New commands {cmd:varabbrev} and {cmd:unabbrev} make it easy 
        to temporarily reset whether Stata allows variable-name 
        abbreviations; see {manhelp varabbrev P}.

{p 7 12 2}
12.  New programming function {cmd:smallestdouble()} returns the
        smallest double-precision number greater than zero; see
        {helpb prog functions:[FN] Programming functions}.

{p 7 12 2}
13.  {cmd:creturn} has new returned values:

{phang3}
a.  {cmd:c(noisily)} returns {cmd:0} when output is being suppressed
             and {cmd:1} otherwise.  Thus programmers can avoid executing code
             whose only purpose is to display output.

{phang3}
b.  {cmd:c(smallestdouble)} returns the smallest double-precision
            value that is greater than 0.

{phang3}
c.  {cmd:c(tmpdir)} returns the temporary directory being used 
            by Stata.

{phang3}
d. {cmd:c(eqlen)} returns the maximum length that Stata allows
            for equation names.

{p 7 12 2}
14.  Existing extended macro function {cmd::dir} 
        has new option {cmd:respectcase}, which causes {cmd::dir} to 
        respect uppercase and lowercase when performing filename matches.
        This option is relevant only for Windows.

{p 7 12 2}
15.  Stata has new string functions {cmd:strtoname()}, {cmd:soundex()},
        and {cmd:soundex_nara()}; see
        {helpb string functions:[FN] String functions}.

{p 7 12 2}
16.  Stata has 17 new numerical functions:
        {cmd:sinh()}, {cmd:cosh()}, {cmd:asinh()}, and {cmd:acosh()}; 
        {cmd:hypergeometric()} and {cmd:hypergeometricp()};
        {cmd:nbinomial()}, {cmd:nbinomialp()}, and {cmd:nbinomialtail()};
        {cmd:invnbinomial()} and {cmd:invnbinomialtail()};
        {cmd:poisson()}, {cmd:poissonp()}, and {cmd:poissontail()};
        {cmd:invpoisson()} and {cmd:invpoissontail()};
        and 
        {cmd:binomialp()}; 
        see {helpb trig functions:[FN] Trigonometric functions} and
            {helpb stat functions:[FN] Statistical functions}.

{p 7 12 2}
17.  Stata has nine new random-variate functions for
        beta, binomial, chi-squared, gamma,
        hypergeometric, negative binomial, normal, Poisson, and Student's t:
        {cmd:rbeta()}, 
        {cmd:rbinomial()}, 
        {cmd:rchi2()}, 
        {cmd:rgamma()}, 
        {cmd:rhypergeometric()}, 
        {cmd:rnbinomial()}, 
        {cmd:rnormal()}, 
        {cmd:rpoisson()}, and
        {cmd:rt()}, respectively.
        Also, old function {cmd:uniform()} is renamed
        {cmd:runiform()}.
        All random-variate functions start with {cmd:r}.
        See {helpb random number functions:[FN] Random-number functions}.

{p 7 12 2}
18.  Existing command {cmd:clear} has new syntax 
        {cmd:clear} {cmd:matrix}, which clears (drops) all Stata 
        matrices, as distinguished from {cmd:clear} {cmd:mata}, which 
        drops all Mata matrices and functions.  See {manhelp clear D}.

{p 7 12 2}
19.  These days, commands intended for use by end-users are often being 
        used as subroutines by other end-user commands.  Some of these 
        commands preserve the data simply so that, should something go 
        wrong or the user press {bf:Break}, the original data can be restored.
        Sometimes, when such commands are used as subroutines, the caller 
        has already preserved the data.  Therefore, all programmers are 
        requested to include option {cmd:nopreserve} on commands that 
        preserve the data for no other reason than error recovery, and 
        thus speed execution when commands are used as subroutines.
        See {manhelp nopreserve_option P:nopreserve option}.


    {title:What's new in Mata}

{phang2}
1.
    Mata now allows full object-oriented programming!  A class is a set of
    variables, related functions, or both tied together under one name.  One
    class can be derived from another via inheritance.  Variables can be
    public, private, protected, or static.  Functions can be public, private,
    protected, static, or virtual.  Members, whether variables or functions,
    can be final.  Classes, member functions, and access to member variables
    and calls to member functions are fully compiled -- not
    interpreted -- meaning there is no speed penalty for casting your
    program in terms of a class.  See {manhelp m2_class M-2:class}.

{phang2}
2.
    The new {cmd:moptimize()} suite of functions comprises Stata's new
    optimization engine used by {cmd:ml} and thereby, either directly or
    indirectly, by nearly all official Stata estimation commands. 
    {cmd:moptimize()} provides full support for Stata's new factor variables.
    See {manhelp mf_moptimize M-5:moptimize()}, {manhelp ml R}, and 
    {manhelp maximize R}.

{pmore2}
{cmd:moptimize} is important.
    The full story is that Stata's {cmd:ml} is implemented in terms of Mata's
    {cmd:moptimize()}, which in turn is implemented in terms of Mata's 
    {cmd:optimize()}.  {cmd:optimize()} finds parameters 
    {bf:p} = (p_1, p_2, ..., p_n) that maximize or minimize f(p).  
    {cmd:moptimize()} finds coefficients 
    {bf:b} = ({bf:b}_1, {bf:b}_2, ..., {bf:b}_n), where 
    p_1 = {bf:X}_1{bf:b}_1, p_2 = {bf:X}_2{bf:b}_2, ...,
    p_n = {bf:X}_n{bf:b}_n.

{phang2}
3.
    New function suite {cmd:deriv()} produces numerically calculated first and
    second derivatives of vector functions; see
     {manhelp mf_deriv M-5:deriv()}.

{phang2}
4.
    Improvements have been made to {cmd:optimize()}:

{phang3}
a.  {cmd:optimize()} with constraints is now faster for evaluator
            types {cmd:d0} and {cmd:v0} and for all gradient-based techniques.
	    Also, it is faster for evaluator types {cmd:d1} and {cmd:v1} when
	    used with constraints and with the {cmd:nr}
            (Newton-Raphson) technique.

{phang3}
b.  Gauss-Newton optimization, also known as quadratic
            optimization, is now available as technique {cmd:gn}.  Evaluator
            functions must be of type 'q'.

{phang3}
c.  {cmd:optimize()} can now switch between techniques
            {cmd:bhhh},
            {cmd:nr},
            {cmd:bfgs}, and
            {cmd:dfp} (between Berndt-Hall-Hall-Hausman,
            Newton-Raphson, 
            Broyden-Fletcher-Goldfarb-Shanno, and
            Davidon-Fletcher-Powell).
        
{phang3}
d.  {cmd:optimize()}, when output of the convergence values
            is requested in the trace log, now displays the identity and
            value of the convergence criterion that is closest to being met.

{phang3}
e.  {cmd:optimize()} has 15 new initialization functions:

                {cmd:optimize_init_cluster()}
                {cmd:optimize_init_trace_dots()}
                {cmd:optimize_init_colstripe()}
                {cmd:optimize_init_trace_gradient()}
                {cmd:optimize_init_conv_ignorenrtol()}
                {cmd:optimize_init_trace_Hessian()}
                {cmd:optimize_init_conv_warning()}
                {cmd:optimize_init_trace_params()}
                {cmd:optimize_init_evaluations()}
                {cmd:optimize_init_trace_step()}
                {cmd:optimize_init_gnweightmatrix()}
                {cmd:optimize_init_trace_tol()}
                {cmd:optimize_init_iterid()}
                {cmd:optimize_init_trace_value()}
                {cmd:optimize_init_negH()}

{pmore3}
Also, new function {cmd:optimize_result_evaluations()}
           reports the number of times the evaluator is called.

{phang2}
5.  Existing functions {cmd:st_data()} and {cmd:st_view()} now allow
         the variables to be specified as a string scalar with space-separated
         names, as well as a string row vector with elements being names.  In
         addition, when a string scalar is used, you now specify either or
	 both time-series-operated variables (for example, {cmd:l.gnp}) and
         factor variables (for example, {cmd:i.rep78}).

{phang2}
6.  Thirty-four LAPACK (Linear Algebra PACKage) functions are
         now available in as-is form and more are coming.  LAPACK is
         the premier software for solving systems of
         simultaneous equations, eigenvalue problems, and singular value
         decompositions.  Many
         of Mata's matrix functions are and have been implemented using
         LAPACK.  We are now in the process of making all the
         double-precision LAPACK real and complex functions available
         in raw form for those who want to program their own advanced numerical
         techniques.  See {manhelp mf_lapack M-5:lapack()} and
       {manhelp copyright_lapack R:Copyright lapack}.

{phang2}
7.  New function suite {cmd:eigensystemselect()} computes the
         eigenvectors for selected eigenvalues; see
         {manhelp mf_eigensystemselect M-5:eigensystemselect()}.

{phang2}
8.  New function suite {cmd:geigensystem()} computes generalized
        eigenvectors and eigenvalues; see 
       {manhelp mf_geigensystem M-5:geigensystem()}.

{phang2}
9.  New function suites {cmd:hessenbergd()} and {cmd:ghessenbergd()}
        compute the (generalized) Hessenberg decompositions;
        see {manhelp mf_hessenbergd M-5:hessenbergd()} and
            {manhelp mf_ghessenbergd M-5:ghessenbergd()}.

{p 7 12 2}
10.  New function suites {cmd:schurd()} and {cmd:gschurd()} compute the
        (generalized) Schur decompositions; see 
        {manhelp mf_schurd M-5:schurd()} and
        {manhelp mf_gschurd M-5:gschurd()}.

{p 7 12 2}
11.  New function {cmd:_negate()} quickly negates a matrix
        in place; see {manhelp mf__negate M-5:_negate()}.

{p 7 12 2}
12.  New functions {cmd:Dmatrix()}, {cmd:Kmatrix()}, and
        {cmd:Lmatrix()} compute the duplication matrix, commutation matrix,
        and elimination matrix used in computing derivatives of
        functions of symmetric matrices; see
        {manhelp mf_Dmatrix M-5:Dmatrix()},
        {manhelp mf_Kmatrix M-5:Kmatrix()}, and
        {manhelp mf_Lmatrix M-5:Lmatrix()}.

{p 7 12 2}
13.  New function {cmd:sublowertriangle()} extracts the lower
        triangle of a matrix, where lower triangle means below
        a specified diagonal; see 
        {manhelp mf_sublowertriangle M-5:sublowertriangle()}.

{p 7 12 2}
14.  New function {cmd:hasmissing()} returns whether a matrix
        contains any missing values; see 
        {manhelp mf_missing M-5:missing()}.

{p 7 12 2}
15.  New function {cmd:strtoname()} performs the same actions
        as Stata's {cmd:strtoname()} function:  it converts a general string
        to a string meeting the Stata naming conventions.  See
        {manhelp mf_strtoname M-5:strtoname()}. 

{p 7 12 2}
16.  New function {cmd:abbrev()} performs the same actions as 
        Stata's {cmd:abbrev()} function:  it returns abbreviated variable
        names.  See {manhelp mf_abbrev M-5:abbrev()}.

{p 7 12 2}
17.  New function {cmd:_st_tsrevar()} is a handle-the-error-yourself
        variation of existing function {cmd:st_tsrevar()};
        see {manhelp mf_st_tsrevar M-5:st_tsrevar()}.

{p 7 12 2}
18.  Existing functions {cmd:ghk()} and {cmd:ghkfast()}, which evaluate
        multivariate normal integrals, have improved syntax;
        see {manhelp mf_ghk M-5:ghk()} and 
            {manhelp mf_ghkfast M-5:ghkfast()}.

{p 7 12 2}
19.  Existing functions {cmd:vec()} and {cmd:vech()} are
        now faster for both real and complex matrices; see 
        {manhelp mf_vec M-5:vec()}.

{p 7 12 2}
20.  Mata has 13 new distribution-related functions:
        {cmd:hypergeometric()} and
        {cmd:hypergeometricp()};
        {cmd:nbinomial()},
        {cmd:nbinomialp()}, and
        {cmd:nbinomialtail()};
        {cmd:invnbinomial()} and
        {cmd:invnbinomialtail()};
        {cmd:poisson()},
        {cmd:poissonp()}, and  
        {cmd:poissontail()};
        {cmd:invpoisson()} and 
        {cmd:invpoissontail()};
        and 
        {cmd:binomialp()}; see {manhelp mf_normal M-5:normal()}.

{p 7 12 2}
21.  Mata has nine new random-variate functions for 
        beta, binomial, chi-squared, gamma,
        hypergeometric, negative binomial, normal, Poisson, and Student's t:
        {cmd:rbeta()},
        {cmd:rbinomial()},
        {cmd:rchi2()}, 
        {cmd:rgamma()},
        {cmd:rhypergeometric()},
        {cmd:rnbinomial()},
        {cmd:rnormal()},
        {cmd:rpoisson()}, and
        {cmd:rt()}, respectively.

{pmore2}
Also, {cmd:rdiscrete()} is provided for drawing from a
        general discrete distribution.

{pmore2}
Old functions {cmd:uniform()} and {cmd:uniformseed()} are
        replaced with {cmd:runiform()} and {cmd:rseed()}.
        All random-variate functions start with {cmd:r}.
        See {manhelp mf_runiform M-5:runiform()}.

{p 7 12 2}
22.  Existing functions {cmd:sinh()}, {cmd:cosh()}, {cmd:asinh()}, and
        {cmd:acosh()} now have improved accuracy; see 
        {manhelp mf_sin M-5:sin()}.

{p 7 12 2}
23.  New function {cmd:soundex()} returns the soundex code for a name
        and consists of a letter followed by three numbers.  New function
        {cmd:soundex_nara()} returns the U.S. Census soundex for a
        name and also consists of a letter followed by three numbers,
        but is produced by a different algorithm.  See 
        {manhelp mf_soundex M-5:soundex()}.

{p 7 12 2}
24.  Existing function
        {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}
        now allows {it:val}
        to be specified as a matrix and creates an
        r{cmd:*rows(}{it:val}{cmd:)} {it:x}
        c{cmd:*cols(}{it:val}{cmd:)} result.
        The third argument, {it:val}, was previously required to be
        1 {it:x} 1.
        Behavior in the 1 {it:x} 1 case is unchanged.
        See {manhelp mf_J M-5:J()}.

{p 7 12 2}
25.  Existing functions {cmd:sort()}, {cmd:_sort()}, and {cmd:order()}
        sorted the rows of a matrix based on up to 500 of its columns.  This
        limit has been removed. See
         {manhelp mf_sort M-5:sort()}.

{p 7 12 2}
26.  New function {cmd:asarray()} provides associative arrays; 
        see {manhelp mf_asarray M-5:asarray()}.

{p 7 12 2}
27.  New function {cmd:hash1()} provides Jenkins' one-at-a-time hash
          function; see {manhelp mf_hash1 M-5:hash1()}.

{p 7 12 2}
28.  Mata object-code libraries ({cmd:.mlib}'s) may now contain up to 
        2,048 functions and may contain up to 1,024 by default.
        Use {cmd:mlib} {cmd:create}'s new {cmd:size()} option to change 
        the default.  The previous fixed maximum was 500.
        See {manhelp mata_mlib M-3:mata mlib}.

{p 7 12 2}
29. Mata on 64-bit computers now supports matrices larger than
         2 gigabytes when the computer has sufficient memory.

{p 7 12 2}
30.  One hundred and nine existing functions now take advantage of 
        multiple cores when using Stata/MP.  They are

            {cmd:acos()}           {cmd:factorial()}        {cmd:minutes()}
            {cmd:arg()}            {cmd:Fden()}             {cmd:mm()}
            {cmd:asin()}           {cmd:floatround()}       {cmd:mmC()}
            {cmd:atan2()}          {cmd:floor()}            {cmd:mod()}
            {cmd:atan()}           {cmd:Ftail()}            {cmd:mofd()}
            {cmd:betaden()}        {cmd:gammaden()}         {cmd:month()}
            {cmd:binomial()}       {cmd:gammap()}           {cmd:msofhours()}
            {cmd:binomialtail()}   {cmd:gammaptail()}       {cmd:msofminutes()}
            {cmd:binormal()}       {cmd:halfyear()}         {cmd:msofseconds()}
            {cmd:ceil()}           {cmd:hh()}               {cmd:nbetaden()}
            {cmd:chi2()}           {cmd:hhC()}              {cmd:nchi2()}
            {cmd:chi2tail()}       {cmd:hofd()}             {cmd:nFden()}
            {cmd:Cofc()}           {cmd:hours()}            {cmd:nFtail()}
            {cmd:cofC()}           {cmd:ibeta()}            {cmd:nibeta()}
            {cmd:Cofd()}           {cmd:ibetatail()}        {cmd:normal()}
            {cmd:cofd()}           {cmd:invbinomial()}      {cmd:normalden()}
            {cmd:comb()}           {cmd:invbinomialtail()}  {cmd:npnchi2()}
            {cmd:cos()}            {cmd:invchi2()}          {cmd:qofd()}
            {cmd:day()}            {cmd:invchi2tail()}      {cmd:quarter()}
            {cmd:dgammapda()}      {cmd:invF()}             {cmd:round()}
            {cmd:dgammapdada()}    {cmd:invFtail()}         {cmd:seconds()}
            {cmd:dgammapdadx()}    {cmd:invgammap()}        {cmd:sin()}
            {cmd:dgammapdx()}      {cmd:invgammaptail()}    {cmd:sqrt()}
            {cmd:dgammapdxdx()}    {cmd:invibeta()}         {cmd:ss()}
            {cmd:digamma()}        {cmd:invibetatail()}     {cmd:tan()}
            {cmd:dofC()}           {cmd:invnchi2()}         {cmd:tden()}
            {cmd:dofc()}           {cmd:invnFtail()}        {cmd:trigamma()}
            {cmd:dofh()}           {cmd:invnibeta()}        {cmd:trunc()}
            {cmd:dofm()}           {cmd:invnormal()}        {cmd:ttail()}
            {cmd:dofq()}           {cmd:invttail()}         {cmd:week()}
            {cmd:dofw()}           {cmd:ln()}               {cmd:wofd()}
            {cmd:dofy()}           {cmd:lnfactorial()}      {cmd:year()}
            {cmd:dow()}            {cmd:lngamma()}          {cmd:yh()}
            {cmd:doy()}            {cmd:lnnormal()}         {cmd:ym()}
            {cmd:exp()}            {cmd:lnnormalden()}      {cmd:yq()}
            {cmd:F()}              {cmd:mdy()}              {cmd:yw()}


    {title:What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated, and those updates are available for free
over the Internet.  All you have to do is type

{phang2}
{cmd:. update query}

{pstd}
and follow the instructions.

{pstd}
To learn what has been added since this manual was printed, select 
{bf:Help > What's New?} or type

{phang2}
{cmd:. help whatsnew}

{pstd}
We hope that you enjoy Stata 11.


{hline 3} {hi:previous updates} {hline}

{pstd}
See {help whatsnew10}.{p_end}

{hline}
