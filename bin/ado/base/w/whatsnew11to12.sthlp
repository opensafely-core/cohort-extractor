{smcl}
{* *! version 1.3.2  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 12.0 (compared with release 11)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 12.0:

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
    {c |} {bf:this file}        Stata 12.0 new release       2011            {c |}
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


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew12}.


{hline 3} {hi:Stata 12.0 release 25jul2011} {hline}

{title:Remarks}

{pstd}
We will list all the changes, item by item, but first, here are the highlights.

{marker highlights}{...}
    {title:What's new (highlights)}

{pstd}
Here are the highlights.  There is more, and do not assume that because
we mention a category, we have mentioned everything new in the category.
Detailed sections follow the highlights.

{phang2}
1.
    {bf:Automatic memory management}, which means that
    you no longer have to {cmd:set} {cmd:memory} and never again 
    will you be told that there is no room because you set too little!
    Stata automatically adjusts its memory usage up and down according 
    to current requirements.

{pmore2}
    The memory manager is tunable.  We recommend the default settings.
    See {helpb memory:[D] memory} if you are interested.

{pmore2}
    Old do-files can still {cmd:set} {cmd:memory}.  Stata merely responds, 
    "{cmd:set memory} ignored".

{phang2}
2.
    {bf:Structural equation modeling (SEM)}, via the new {cmd:sem} command, 
    is itself the subject of the new 
    {mansection SEM sem:{it:Stata Structural Equation Modeling Reference Manual}}. 
    SEM fits multivariate linear models that can include observed
    and latent variables.  These models include 
    confirmatory factor analysis, 
    linear models, 
    instrumental variables,
    2SLS, 3SLS, 
    multivariate regression,
    seemingly unrelated least squares, 
    recursive systems,
    simultaneous systems,
    path analysis, 
    latent variables,
    MIMIC, 
    modeling of direct and indirect effects,
    and more.
    All the above can be estimated by maximum likelihood with or without
    missing values, GLS, or ADF
    (asymptotic distribution free, also known as GMM).
    Missing values are handled using FIML.
    Raw and standardized coefficients and effects are reported.
    All models may be fit across groups and include tests for group invariance.
    Modification indices and score tests are provided.

{pmore2}
    Models may be specified and reported using commands or interactive path
    diagrams.  See {helpb sem:[SEM] sem}.

{phang2}
3.
    {bf:MI}, multiple imputation, 

{phang3}
a.
        {bf:Chained equations}, which is to say, fully conditional
        specifications 
        for imputing missing values given arbitrary patterns for continuous,
        binary, ordinal, cardinal, or count variables.
        See {helpb mi impute chained:[MI] mi impute chained}.

{phang3}
b.
        {bf:Four new imputation methods}.  You can impute

                1) truncated data,
                2) interval-censored data,
                3) count data, and 
                4) overdispersed count data.

{pmore2}
See 
               {helpb mi impute truncreg:[MI] mi impute truncreg},
               {helpb mi impute intreg:[MI] mi impute intreg},
               {helpb mi impute poisson:[MI] mi impute poisson}, and
               {helpb mi impute nbreg:[MI] mi impute nbreg}.

{phang3}
c. 
        {bf:Conditional imputation} is now supported by all univariate 
        imputation methods, which is to say, you can impute values for 
        variables with restrictions, such as the number of pregnancies being
        imputed only for females, even if female itself is imputed.
        See {mansection MI miimputeRemarksandexamplesConditionalimputation:{it:Conditional imputation}}
        in {bf:[MI] mi impute}
        and new option {cmd:conditional()} 
        in the univariate imputation entries such as 
        {helpb mi impute regress:[MI] mi impute regress}.

{phang3}
d.
        {bf:Imputation by groups}, which is to say, imputations can be 
        made separately for different groups of the data. 
        See new option {cmd:by()} in 
        {helpb mi impute:[MI] mi impute}.

{phang3}
e.
        {bf:Imputation by drawing posterior estimates from bootstrapped samples}.
        See new option {cmd:bootstrap} in the univariate imputation entries
        such as {helpb mi impute regress:[MI] mi impute regress}.

{phang3}
f.
        {bf:Panel-data and multilevel models} are now supported by 
        {cmd:mi estimate}.  
        Included are 
        {cmd:xtcloglog}, 
        {cmd:xtgee}, 
        {cmd:xtlogit}, 
        {cmd:xtmelogit}, 
        {cmd:xtmepoisson}, 
        {cmd:xtmixed}, 
        {cmd:xtnbreg}, 
        {cmd:xtpoisson}, 
        {cmd:xtprobit}, 
        {cmd:xtrc}, and
        {cmd:xtreg}.
        See {helpb mi estimation:[MI] estimation}.

{phang3}
g.
        {bf:Linear and nonlinear predictions after MI estimation}
        using new commands {cmd:mi predict} and {cmd:mi predictnl}.
        See {helpb mi predict:[MI] mi predict}.

{phang3}
h.
        {bf:Monte Carlo jackknife error estimates}
        obtained by omitting one imputation at a
        time and reapplying the combination rules. 
        See new option {cmd:mcerror} in {helpb mi estimate:[MI] mi estimate}.

{phang2}
4. {bf:Longitudinal/panel data},

{phang3}
a. {bf:Survey feature support for xtmixed} including 
    multilevel sampling weights and robust variance estimators.
    See {helpb xtmixed:[XT] xtmixed}.

{phang3}
b. {bf:Documentation for xtmixed, xtmelogit, and xtmepoisson}
	      {bf:has been modified to adopt the standard "level" terminology}
	      {bf:from the literature on hierarchical models.}
	      See the {it:Introduction} section of
	      {it:Remarks} in both {bf:[XT] xtmixed} and {bf:[XT] xtmelogit}.

{phang3}
c. {bf:xtmixed now uses maximum likelihood (ML) as the default}
	  {bf:method of estimation}. See {helpb xtmixed:[XT] xtmixed}.

{phang2}
5. 
    {bf:Contour plots}.  Filled and outlined plots are available.
    See {helpb twoway contour:[G-2] graph twoway contour} and
        {helpb twoway contourline:[G-2] graph twoway contourline}.

{phang2}
6.
    {bf:Contrasts}, which is to say, tests of linear hypotheses involving
    factor variables and their interactions from the most recently fit
    model, and that model can be virtually any model that Stata can fit.
    Tests include ANOVA-style tests of main effects, simple
    effects, interactions, and nested effects.  Effects can be decomposed into
    comparisons with reference categories, comparisons of adjacent levels,
    comparisons with the grand mean, and more.
    See {helpb contrast:[R] contrast} and
        {helpb margins contrast:[R] margins, contrast}.

{phang2}
7.
    {bf:Pairwise comparisons} of means, estimated cell means, estimated 
    marginal means, predictive margins of linear and nonlinear responses, 
    intercepts, and slopes.
    In addition to ANOVA-style comparisons, comparisons can be made of
    population averages.
    See {helpb pwmean:[R] pwmean}, {helpb pwcompare:[R] pwcompare}, and
        {helpb margins pwcompare:[R] margins, pwcompare}.

{phang2}
8.
    {bf:Graphs of margins, marginal effects, contrasts, and pairwise}
    {bf:comparisons}.  Margins and effects can be obtained from linear or
    nonlinear (for example, probability) responses.  See
    {helpb marginsplot:[R] marginsplot}.

{phang2}
9.
     {bf:Time series}, 

{phang3}
a.
        {bf:MGARCH}, which is to say, multivariate GARCH, which is to
        say, estimation of multivariate generalized autoregressive conditional
        heteroskedasticity models of volatility, and this includes constant,
        dynamic, and varying conditional correlations, also known as the
        CCC, DCC, and VCC models.
        Innovations in these models may follow multivariate normal or Student's
        t distributions.  See {helpb mgarch:[TS] mgarch}. 

{phang3}
b.
        {bf:UCM}, which is to say, unobserved-components models, also known as
        structural time-series models that decompose a series into trend,
        seasonal, and cyclical components, and which were popularized by
        {help whatsnew11to12##H1989:Harvey (1989)}.
        See {helpb ucm:[TS] ucm}.

{phang3}
c.
        {bf:ARFIMA}, which is to say, autoregressive fractionally integrated
        moving-average models, useful for long-memory processes.
        See {helpb arfima:[TS] arfima}.

{phang3}
d.
        {bf:Filters for extracting business and seasonal cycles}.  Four
        popular time-series filters are provided:
        the Baxter-King
	and the Christiano-Fitzgerald band-pass filters,
        and the Butterworth and the Hodrick-Prescott
        high-pass filters.  See {helpb tsfilter:[TS] tsfilter}.

{p 7 12 2}
10.
    {bf:Business dates} allow you to define your own calendars so that 
    they display correctly and lags and leads work as they should.
    You could create file {cmd:lse.stbcal} that recorded the days the 
    London Stock Exchange is open (or closed) and then Stata would understand 
    format {cmd:%tblse} just as it understands the usual date format
    {cmd:%td}.  Once you define a calendar, Stata deeply understands it.  You
    can, for instance, easily convert between {cmd:%tblse} and {cmd:%td}
    values.  See
    {helpb datetime business calendars:[D] datetime business calendars}.  

{p 7 12 2}
11.
    {bf:Improved documentation for date and time variables}.
    Anyone who has ever been puzzled by Stata's date and time variables, 
    which is to say, anyone who uses them, should see
    {helpb datetime:[D] datetime}, 
    {helpb datetime translation:[D] datetime translation}, 
    and {helpb datetime display formats:[D] datetime display formats}.

{p 7 12 2}
12.
     {bf:ROC adjusted for covariates}, which is to say, you can model the
     ROC curve and obtain coefficients, standard errors, and
     graphs.  Nonparametric and parametric estimation is supported.
     See {helpb rocreg:[R] rocreg} and {helpb rocregplot:[R] rocregplot}.

{p 7 12 2}
13.
    {bf:Survey SDR weights}, which is to say, successive difference replicate 
    weights, which are supplied with many datasets from the U.S. Census 
    Bureau.  See {helpb svy sdr:[SVY] svy sdr}. 

{p 7 12 2}
14.
    {bf:Bootstrap standard errors for survey data} using user-supplied 
    bootstrap replicate weights.  See {helpb svy bootstrap:[SVY] svy bootstrap}.
    
{p 7 12 2}
15.
    {bf:Importing and exporting}, 

{phang3}
a.
        {bf:Excel files}. 
        And the new import preview tool lets you see the data before you 
        import them.
        See {helpb import excel:[D] import excel}.  

{phang3}
b.
       {bf:EBCDIC files, importing}. 
        And you can convert between EBCDIC and ASCII formats;
        see {helpb infile2:[D] infile (fixed format)} and
            {helpb filefilter:[D] filefilter}.

{phang3}
c.
        {bf:ODBC connection strings}.
        See {helpb odbc:[D] odbc}.

{phang3}
d.
        {bf:PDF export for graphs and logs} lets you directly create 
        PDFs from your Stata results.
        See {helpb graph export:[G-2] graph export} and 
        {helpb translate:[R] translate}.

{p 7 12 2}
16. 
    {bf:Renaming groups of variables} is now easy using {cmd:rename}'s 
    new syntax that is 100% compatible with its old syntax.
    You can change names, swap names, renumber indices within variable names, 
    and more.  See {helpb rename group:[D] rename group}. 

{p 7 12 2}
17.
    {bf:Stata interface},

{phang3}
a.
        {bf:New layout} is wider and fits most screens better.

{phang3}
b.
        {bf:New Properties window}
        lets you manage the properties of your variables including 
        names, labels, value labels,
        notes, display formats, and storage types.  
        And you can manage the properties of your dataset.

{phang3}
c.
        {bf:Filtering of Review and Variables windows} lets you 
        type text and see only the matches.

{phang3}
d. 
        {bf:Searching in the Results window} lets you find results.

{phang3}
e.
        {bf:Expression Builder now accesses parameter estimates,}
        {bf:returned results, macros, and more},
        so you can build expressions for {cmd:nlcom} and {cmd:testnl}.  It is
        worth a test drive.

{phang3}
f.
        {bf:Unified interface for Mac} means no more lost windows; 
        all the Stata windows are tied together.

{phang3}
g.
        {bf:Gesture support for Mac} makes changing font sizes and moving 
        forward and backward easy.

{phang3}
h. 
        {bf:Tabbed graphs for Mac}.
      
{phang3}
i.
        {bf:File drag-and-drop for Windows} -- Stata for Mac already had
        it -- now Stata for Windows does, too.

{p 7 12 2}
18.
    {bf:Data Editor},

{phang3}
a. 
        {bf:New tool for managing variables} 
        lets you hide/show variables (and includes filtering!), 
        sort variables, and reorder variables via drag and drop.
        And it includes Stata's new Properties tool, so you can manage your data
        more easily from the Data Editor.  Try it.  Click on the Variables tool 
        in the toolbar.

{phang3}
b.
        {bf:New Clipboard Preview Tool} 
        lets you see the data before you paste them into Stata 
        and lets you control how the data will be pasted.

{phang3}
c. 
        {bf:Clipboard preserves variable properties} such as 
        display formats and types when you copy-and-paste data within Stata.

{p 7 12 2}
19.
    {bf:All-new Viewer}, 

{phang3}
a.
        {bf:Quick access to dialogs, sections, and "also see" references} via 
        three pulldown menus at the top of the Viewer for quick navigation 
        inside help files.

{phang3}
b.
        {bf:Tabbed Viewer} lets you open multiple help files and documents
        and switch between them. 
 
{p 7 12 2}
20.
    {bf:Do-file Editor}, 

{phang3}
a.
        {bf:Tabbed for Mac and Unix} -- Stata for Windows already had it --
        now Stata for Mac and Unix do, too.

{phang3}
b.
        {bf:Syntax highlighting and bookmarks for Mac} -- Stata for
        Windows already had it -- now Stata for Mac does, too.

{p 7 12 2}
21.
    {bf:Estimation output improved},

{phang3}
a.
        {bf:Baseline odds now shown}, which is to say, the exponentiated 
        intercept is displayed by {cmd:logistic} and by {cmd:logit} with
        option {cmd:or}.  In fact, all estimation commands show exponentiated
        intercepts when option {cmd:eform()} or its equivalent is
        specified.  For example, {cmd:poisson} shows the baseline incidence
        rate when option {cmd:irr} is specified.

{phang3}
b.
        {bf:Implied zero coefficients now shown}.  When a coefficient is 
        omitted, it is now shown as being zero and the reason it was
        omitted -- collinearity, base, empty -- is shown in the
        standard-error column.  (The word "omitted" is shown if 
        the coefficient was omitted because of collinearity.)

{phang3}
c.
        {bf:You can set displayed precision for all values in}
        {bf:coefficient tables} using {cmd:set} {cmd:cformat}, 
        {cmd:set} {cmd:pformat}, and {cmd:set} {cmd:sformat}.
        Or you may use options {cmd:cformat()}, {cmd:pformat()}, and 
        {cmd:sformat()} now allowed on all estimation commands.
        See {helpb set cformat:[R] set cformat} and
            {helpb estimation options:[R] estimation options}.

{phang3}
d.
         Estimation commands now respect the width of the Results window.
        This feature may be turned off by new display option {cmd:nolstretch}.
        See {helpb estimation options:[R] estimation options}.

{phang3}
e.
        {bf:You can now set whether base levels, empty cells, and omitted}
        {bf:are shown} using {cmd:set} {cmd:showbaselevels}, 
        {cmd:set} {cmd:showemptycells}, and 
        {cmd:set} {cmd:showomitted}.  
        See {helpb set showbaselevels:[R] set showbaselevels}.

{p 7 12 2}
22.
    {bf:More MP speed ups}, meaning faster execution for those running
     Stata/MP.

{phang3}
a.
        {bf:Improved MP support for factor variables used in estimation}.
        Execution is much faster when there are lots of levels.

{phang3}
b.
        {bf:Faster maximum likelihood execution with large numbers of covariates}.
        Processors being assigned on the basis of variables rather than
        observations when there are 300 or more covariates results in improved 
        performance.

{phang3}
c.
        {bf:Improved performance on 16 or more cores} due to better tuning.

{phang3}
d.
        {bf:Up to 64 cores now supported}, up from 32.

{p 7 12 2}
23.
    {bf:Installation Qualification} is now provided by a new tool 
    which you download for free.  
    The tool produces a report for submission to regulatory agencies 
    such as the FDA to establish that Stata is installed 
    correctly.
    Visit 
    {browse "http://www.stata.com/support/installation-qualification/":http://www.stata.com/support/installation-qualification/}.


    {title:What's new in the GUI and command interface}

{phang2}
1.
    {bf:Highlights,}{p_end}
{phang3}a. {bf:New layout.}
{p_end}
{phang3}b. {bf:New Properties window.}
{p_end}
{phang3}c. {bf:Filtering of Review and Variable windows.}
{p_end}
{phang3}d. {bf:Searching in the Results window.}
{p_end}
{phang3}e. {bf:Expression Builder can access parameter estimates, ....}
{p_end}
{phang3}f. {bf:Unified interface for Mac.}
{p_end}
{phang3}g. {bf:Gesture support for Mac.}
{p_end}
{phang3}h. {bf:Tabbed Graphs for Mac.}
{p_end}
{phang3}i. {bf:File drag-and-drop for Windows.}
{p_end}
{phang3}j. {bf:Data Editor, new tool for managing variables.}
{p_end}
{phang3}k. {bf:Data Editor, new Clipboard Preview Tool.}
{p_end}
{phang3}l. {bf:Data Editor, Clipboard preserves variable properties.}
{p_end}
{phang3}m. {bf:New Viewer, quick access to dialogs, sections, ....}
{p_end}
{phang3}n. {bf:New Viewer, tabbed.}
{p_end}
{phang3}o. {bf:Do-file Editor, tabbed for Mac and Unix.}
{p_end}
{phang3}p. {bf:Do-file Editor, syntax highlighting and bookmarks for Mac.}
{p_end}
{pmore2}See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
    {bf:Aero Snap functionality for Viewer in Windows 7.}

{phang2}
3.
    {bf:Stata for Unix dialog boxes now have full varlist controls.}


    {title:What's new in data management}

{phang2}
1. 
    {bf:Highlights},{p_end}
{phang3}a. {bf:Automatic memory management.}
              See {helpb memory:[D] memory}.

{phang3}b. {bf:Excel files, importing and exporting.}
              See {helpb import excel:[D] import excel}.

{phang3}c. {bf:EBCDIC files, importing.}
              See {helpb infile2:[D] infile (fixed format)} and
                  {helpb filefilter:[D] filefilter}.

{phang3}d. {bf:ODBC connection strings, importing and exporting.}
              See {helpb odbc:[D] odbc}.

{phang3}e. {bf:PDF files, exporting of graphs and logs.}
              See {helpb translate:[R] translate}.

{phang3}f. {bf:Business dates.}
              See
           {helpb datetime business calendars:[D] datetime business calendars}.

{phang3}g. {bf:Improved documentation for date and time variables.}
              See {helpb datetime:[D] datetime}, 
                  {helpb datetime translation:[D] datetime translation}, and
                  {helpb datetime display formats:[D] datetime display formats}.

{phang3}h. {bf:Renaming groups of variables.}
              See {helpb rename group:[D] rename group}. 

{pmore2}See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
    {bf:New functions},

{phang3}
a.
        {bf:Tukey's Studentized range}, cumulative and inverse,
        {cmd:tukeyprob()} and {cmd:invtukeyprob()}.

{phang3}
b.
        {bf:Dunnett's multiple range}, cumulative and inverse,
        {cmd:dunnettprob()} and {cmd:invdunnettprob()}.

{phang3}
c.
        {bf:New date conversion functions}
         {cmd:dofb()} and {cmd:bofd()} convert between business dates 
         and standard calendar dates.
         See
          {helpb datetime business calendars:[D] datetime business calendars}.

{pmore2}
    See {helpb functions:[FN] Functions by category}.

{phang2}
3.
    {bf:ODBC support for Oracle Solaris.}
    See {helpb odbc:[D] odbc}.

{phang2}
4.
   {bf:New Stata commands getmata and putmata} make it easy
   to transfer your data into Mata, manipulate them, and then transfer
   them back to Stata.  {cmd:getmata} and {cmd:putmata} are
   especially designed for interactive use.  See {helpb putmata:[D] putmata}.

{phang2}
5.
   {bf:New Stata commands import sasxport, export sasxport, and}
   {bf:import sasxport, describe} replace existing commands {cmd:fdause},
   {cmd:fdasave}, and {cmd:fdadescribe}. {cmd:fdause}, {cmd:fdasave},
   and {cmd:fdadescribe} are understood as synonyms.  See
   {helpb import sasxport:[D] import sasxport}.

{phang2}
6.
    {bf:xshell} support for Mac.
    See {helpb shell:[D] shell}.


    {title:What's new in statistics (general)}

{phang2}
1. 
    {bf:Highlights},{p_end}
{phang3}a. {bf:Contrasts}.
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}b. {bf:Pairwise comparisons}.
              See {helpb pwmean:[R] pwmean}, 
              {helpb pwcompare:[R] pwcompare}, and 
              {helpb margins pwcompare:[R] margins, pwcompare}.

{phang3}c. {bf:Graphs of margins, marginal effects, contrasts, ....}
              See {helpb marginsplot:[R] marginsplot}.

{phang3}d. {bf:ROC adjusted for covariates.}
              See {helpb rocreg:[R] rocreg} and 
              {helpb rocregplot:[R] rocregplot}.

{phang3}e. {bf:Estimation output improved}:{break}
              {bf:--Baseline odds now shown.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.} See
              {helpb set cformat:[R] set cformat}
                  and {helpb estimation options:[R] estimation options}.{break}
              {bf:--Estimation commands now respect the width of the}
                 {bf:Results window.}
                  See {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See
              {helpb set showbaselevels:[R] set showbaselevels} and
              {helpb estimation options:[R] estimation options}.

{pmore2}See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
    {bf:test with coefficient names not using _b[] notation is now allowed},
    even when the specified variables no longer exist in the current dataset.
    See {helpb test:[R] test}.

{phang2}
3. 
      {bf:areg now faster.}
      {cmd:areg} is orders of magnitude faster when there are hundreds 
      of absorption groups, even if you are not running Stata/MP.
      See {helpb areg:[R] areg}.

{phang2}
4. 
    {bf:misstable summarize will now create summary variable} recording 
    the missing-values pattern.  See new option {cmd:generate()} 
    for {cmd:summarize} in {helpb misstable:[R] misstable}.

{phang2}
5.
    {bf:margins command supports contrasts.}
    See {helpb margins contrast:[R] margins, contrast} and 
    {helpb contrast:[R] contrast}.

{phang2}
6.
    {bf:sfrancia uses better algorithm.}
    {cmd:sfrancia} now uses an algorithm based on the log transformation 
    for approximating the sampling distribution of the W' statistic for
    testing normality.  The old algorithm, using the Box-Cox
    transformation, is available under version control or via the new
    {cmd:boxcox} option.  Based on simulation, the new algorithm is more
    powerful for sample sizes greater than 1,000 and is comparable to the old
    algorithm for sample sizes less than 1,000.  Also, similarly to {cmd:swilk},
    {cmd:sfrancia} now allows you to suppress the treatment of ties when
    option {cmd:noties} is used.  See {helpb swilk:[R] swilk}.

{phang2}
7.
    {bf:logistic now allows option noconstant.}
    See {helpb logistic:[R] logistic}.

{phang2}
8.
    {bf:Probability predictions now available.}
    {cmd:predict} after count-data models, such as {cmd:poisson} and 
    {cmd:nbreg}, can now predict the probability of any count or count range.
    See {helpb nbreg postestimation:[R] nbreg postestimation},
    {helpb poisson postestimation:[R] poisson postestimation},
    {helpb tnbreg postestimation:[R] tnbreg postestimation},
    {helpb tpoisson postestimation:[R] tpoisson postestimation},
    {helpb zinb postestimation:[R] zinb postestimation}, and
    {helpb zip postestimation:[R] zip postestimation}.

{phang2}
9.
    {bf:Truncated count-data models now available.}
    New estimation commands {cmd:tpoisson} and {cmd:tnbreg} 
    fit models of count-data outcomes with any form of left truncation, 
    including truncation that varies observation by observation.  
    These new commands supersede {cmd:ztp} and {cmd:ztnb}. 
    See {helpb tpoisson:[R] tpoisson} and {helpb tnbreg:[R] tnbreg}.

{p 7 12 2}
10.
   {bf:cnsreg checks for collinear variables prior to estimation} and has new
   option {cmd:collinear}, which keeps the collinear variables
   instead of omitting them.  The old behavior of always keeping collinear
   variables is preserved under version control. 
   See {helpb cnsreg:[R] cnsreg}.

{p 7 12 2}
11.
    {bf:ml improved},

{phang3}a.
        {cmd:ml} now distinguishes the Hessian matrix produced by
	{cmd:technique(nr)} from the other techniques that compute a substitute
	for the Hessian matrix.  This means that {cmd:ml} will compute the real
	Hessian matrix of second derivatives to determine convergence when all
	other convergence tolerances are satisfied and {cmd:technique(bfgs)},
        {cmd:technique(bhhh)}, or {cmd:technique(dfp)} is in effect.

{pmore3}
         The old behavior was to use the {cmd:nrtolerance()} value with the
         H matrix associated with the {cmd:technique()} currently in
         effect to determine convergence; this behavior is preserved under
         version control.

{phang3}b.
        {cmd:ml} has new option {cmd:qtolerance()} that distinguishes
        itself from {cmd:nrtolerance()} when {cmd:technique(bfgs)},
        {cmd:technique(bhhh)}, or {cmd:technique(dfp)} is specified.  Option
        {cmd:qtolerance()} replaces {cmd:nrtolerance()} when
        {cmd:technique(bfgs)}, {cmd:technique(bhhh)}, or {cmd:technique(dfp)}
        is in effect.

{pmore2}
    See {helpb ml:[R] ml} and {helpb maximize:[R] maximize}.

{p 7 12 2}
12.
    {bf:margins has new option estimtolerance() for setting tolerance} 
    used to determine estimable functions.
    See {helpb margins:[R] margins}.

{p 7 12 2}
13.
     {bf:Option addplot() now places added graphs above or below.}
     Commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 


    {title:What's new in statistics (longitudinal/panel data)}

{phang2}
1. 
    {bf:Highlights}, 

{phang3}a. {bf:MI support for panel-data and multilevel models}
              including 
              {cmd:xtcloglog}, 
              {cmd:xtgee}, 
              {cmd:xtlogit}, 
              {cmd:xtmelogit}, 
              {cmd:xtmepoisson}, 
              {cmd:xtmixed}, 
              {cmd:xtnbreg}, 
              {cmd:xtpoisson}, 
              {cmd:xtprobit}, 
              {cmd:xtrc}, and
              {cmd:xtreg}. 
              See {helpb mi estimation:[MI] estimation}.

{phang3}b. {bf:Survey feature support for linear multilevel models},
              {cmd:xtmixed}, including multilevel sampling weights and robust
              variance estimators.
              See {helpb xtmixed:[XT] xtmixed}.

{phang3}c. {bf:Documentation for xtmixed, xtmelogit, and xtmepoisson}
      {bf:has been modified to adopt the standard "level" terminology}
      {bf:from the literature on hierarchical models.}  For example, what
      in previous Stata versions was considered a one-level model is
      now called a two-level model with the observations now being
      counted as "level one"; see the {it:Introduction} section of
      {it:Remarks} in both {bf:[XT] xtmixed} and {bf:[XT] xtmelogit} for
             more details.

{phang3}d. {bf:Contrasts} available after most xt commands. 
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}e. {bf:Pairwise comparisons}
              available after most xt estimation commands. 
              See {helpb pwcompare:[R] pwcompare} and 
              {helpb margins pwcompare:[R] margins, pwcompare}.

{phang3}f. {bf:Graphs of margins, marginal effects, contrasts, and}
	   {bf:pairwise comparisons} available after all xt estimation
           commands.  See {helpb marginsplot:[R] marginsplot}.

{phang3}g. {bf:xtmixed now uses maximum likelihood (ML) as the default}
	  {bf:method of estimation}, where previously it used restricted maximum
	  likelihood (REML).  REML is still available with the
	  {cmd:reml} option, and previous behavior is preserved under version
          control. 

{phang3}h. {bf:Estimation output improved.}{break}
              {bf:--Baseline odds now shown.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.}
              See {helpb set cformat:[R] set cformat} and
                  {helpb estimation options:[R] estimation options}.{break}
              {bf:--Estimation commands now respect the width of the}
                          {bf:Results window.}
                   See {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See
               {helpb set showbaselevels:[R] set showbaselevels} and
               {helpb estimation options:[R] estimation options}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2. {bf:Robust and cluster-robust SEs after fixed-effects xtpoisson.}
          See {helpb xtpoisson:[XT] xtpoisson}.

{phang2}
3. {bf:New residual covariance structures for multilevel models}
          include exponential, banded, and Toeplitz.  
          See {helpb xtmixed:[XT] xtmixed}.

{phang2}
4.
    {bf:Probability predictions now available.}
    {cmd:predict} after random-effects and population-averaged
    count-data models, such as {cmd:xtpoisson} and {cmd:xtgee},
    can now predict the probability of any count or count range.
    See {helpb xtpoisson postestimation:[XT] xtpoisson postestimation},
     {helpb xtgee postestimation:[XT] xtgee postestimation}, and
     {helpb xtnbreg postestimation:[XT] xtnbreg postestimation}.

{phang2}
5.
     {bf:Option addplot() now places added graphs above or below.}
     Commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 
     Affected is the command {cmd:xtline}; see {helpb xtline:[XT] xtline}.


    {title:What's new in statistics (time series)}

{phang2}
1. 
    {bf:Highlights,} 

{phang3}a. {bf:MGARCH.}
              See {helpb mgarch:[TS] mgarch}.

{phang3}b. {bf:UCM.}
              See {helpb ucm:[TS] ucm}.

{phang3}c. {bf:ARFIMA.}
              See {helpb arfima:[TS] arfima}.

{phang3}d. {bf:Filters for extracting business and seasonal cycles.}
              See {helpb tsfilter:[TS] tsfilter}.

{phang3}e. {bf:Business dates.}
              See
            {helpb datetime business calendars:[D] datetime business calendars}.

{phang3}f. {bf:Improved documentation for date and time variables.}
              See
              {helpb datetime:[D] datetime}, 
              {helpb datetime translation:[D] datetime translation}, 
              and {helpb datetime display formats:[D] datetime display formats}.

{phang3}g. {bf:Contrasts} available after many time-series estimation 
              commands. 
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}h. {bf:Pairwise comparisons}
              available after many time-series estimation commands.
              See {helpb pwcompare:[R] pwcompare} and 
              {helpb margins pwcompare:[R] margins, pwcompare}.

{phang3}i. {bf:Graphs of margins, marginal effects, contrasts, and}
	   {bf:pairwise comparisons} available after most time-series estimation
              commands.  See {helpb marginsplot:[R] marginsplot}.

{phang3}j. {bf:Estimation output improved.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.}
              See {helpb set cformat:[R] set cformat} and
               {helpb estimation options:[R] estimation options}.{break}
              {bf:--Estimation commands now respect the width of the}
                          {bf:Results window.}
                   See {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See
                {helpb set showbaselevels:[R] set showbaselevels} and
                {helpb estimation options:[R] estimation options}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
    {bf:Spectral densities from parametric models} via new postestimation
    command {cmd:psdensity} lets you estimate using {cmd:arfima}, {cmd:arima},
    and {cmd:ucm} and then obtain the implied spectral density.
    See {helpb psdensity:[TS] psdensity}.

{phang2}
3.
    {bf:dvech renamed mgarch dvech.}  The command for fitting the diagonal
    VECH model is now named {cmd:mgarch dvech}, and innovations may
    follow multivariate normal or Student's t distributions.
    See {helpb mgarch:[TS] mgarch}.

{phang2}
4.
    {bf:Loading data from Haver Analytics supported on all 64-bit Windows.}
    See {helpb haver:[TS] haver}.

{phang2}
5.
     {bf:Option addplot() now places added graphs above or below.}
     Graph commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 
     Affected by this are the commands 
     {cmd:corrgram},
     {cmd:cumsp},
     {cmd:pergram},
     {cmd:varstable},
     {cmd:vecstable},
     {cmd:wntestb}, and
     {cmd:xcorr}.


    {title:What's new in statistics (survey)}

{phang2}
1.
    {bf:Highlights}, 

{phang3}a. {bf:Contrasts} available after survey estimation.
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}b. {bf:Pairwise comparisons} available after survey estimation.
              See 
              {helpb pwcompare:[R] pwcompare} and 
              {helpb pwcompare postestimation:[R] pwcompare postestimation}.

{phang3}c. {bf:Graphs of margins, marginal effects, contrasts, and pairwise}
              {bf:comparisons} available after survey estimation.  
              See {helpb marginsplot:[R] marginsplot}.

{phang3}d. {bf:Survey SDR weights.}
              See {helpb svy sdr:[SVY] svy sdr}.

{phang3}e. {bf:Bootstrap standard errors for survey data.}
              See {helpb svy bootstrap:[SVY] svy bootstrap}.

{phang3}f. {bf:Estimation output improved.}{break}
              {bf:--Baseline odds now shown.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.}
              See {helpb set cformat:[R] set cformat} and
                {helpb estimation options:[R] estimation options}.{break}
              {bf:--Estimation commands now respect the width of the}
                          {bf:Results window.}
                   See {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See 
               {helpb set showbaselevels:[R] set showbaselevels} and
               {helpb estimation options:[R] estimation options}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.  
    {bf:Survey estimation may be combined with new SEM} for structural equation 
    modeling.  See {helpb svy estimation:[SVY] svy estimation} and
    {helpb sem:[SEM] sem}.

{phang2}
3.
    {bf:Survey goodness-of-fit} available after {cmd:logistic}, {cmd:logit},
    and {cmd:probit} with new command {cmd:estat gof}.
    See {helpb svy estat:[SVY] estat}.

{phang2}
4.
    {bf:Survey coefficient of variation (CV)} available with new command
    {cmd:estat cv}.  See {helpb svy estat:[SVY] estat}.


    {title:What's new in statistics (survival analysis)}

{phang2}
1. 
    {bf:Highlights}, 

{phang3}a. {bf:Contrasts} available after {cmd:stcox}, {cmd:stcrreg},
              and {cmd:streg}.
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}b. {bf:Pairwise comparisons} available after {cmd:stcox},
              {cmd:stcrreg}, and {cmd:streg}.
              See {helpb pwcompare:[R] pwcompare} and 
              {helpb margins pwcompare:[R] margins, pwcompare}.

{phang3}c. {bf:Graphs of margins, marginal effects, contrasts, and}
         {bf:pairwise comparisons} available after {cmd:stcox}, {cmd:stcrreg},
              and {cmd:streg}.  
              See {helpb marginsplot:[R] marginsplot}.

{phang3}d. {bf:Estimation output improved.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.}{break}
              {bf:--Estimation commands now respect the width of the}
                          {bf:Results window.}
              See {helpb set cformat:[R] set cformat} and
                 {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See
               {helpb set showbaselevels:[R] set showbaselevels} and
               {helpb estimation options:[R] estimation options}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
     {bf:G{c o:}nen and Heller's K concordance coefficient} available after Cox
     proportional hazards estimation.  K is robust to censoring.
     See new option {cmd:gheller} for {cmd:estat concordance} in
     {helpb stcox postestimation:[ST] stcox postestimation}.

{phang2}
3.
     {bf:Option addplot() now places added graphs above or below.}
     Graph commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 
     Affected by this are the commands 
     {cmd:ltable}, 
     {cmd:stci}, 
     {cmd:stcoxkm}, 
     {cmd:stcurve}, 
     {cmd:stphplot},
     {cmd:strate},
     {cmd:sts graph}, and
     {cmd:tabodds}. 


    {title:What's new in statistics (multivariate)}

{phang2}
1. 
    {bf:Highlights}, 

{phang3}a. {bf:Structural equation modeling (SEM).}
              See {helpb sem:[SEM] sem}.

{phang3}b. {bf:Contrasts.}
              See {helpb contrast:[R] contrast} and 
              {helpb margins contrast:[R] margins, contrast}.

{phang3}c. {bf:Pairwise comparisons.}
              See {helpb pwcompare:[R] pwcompare} and 
              {helpb margins pwcompare:[R] margins, pwcompare}.

{phang3}d. {bf:Graphs of margins, marginal effects, contrasts, and pairwise}
              {bf:comparisons.}  See {helpb marginsplot:[R] marginsplot}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
     {bf:Option addplot() now places added graphs above or below.}
     Graph commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 
     Affected by this are the commands
     {cmd:screeplot} and {cmd:cluster} {cmd:dendrogram}; see
     {helpb screeplot:[MV] screeplot} and
     {helpb cluster dendrogram:[MV] cluster dendrogram}. 


    {title:What's new in statistics (multiple imputation)}

{phang2}
1. 
    {bf:Highlights}, 

{phang3}a. {bf:Chained equations.}
              See {helpb mi impute chained:[MI] mi impute chained}.

{phang3}b. {bf:Four new imputation methods.}
              See {helpb mi impute truncreg:[MI] mi impute truncreg},
                  {helpb mi impute intreg:[MI] mi impute intreg},
                  {helpb mi impute poisson:[MI] mi impute poisson}, and
                  {helpb mi impute nbreg:[MI] mi impute nbreg}.

{phang3}c. {bf:Conditional imputation.}
              See 
   {mansection MI miimputeRemarksandexamplesConditionalimputation:{it:Conditional imputation}}
             in {bf:[MI] mi impute}
              and new option {cmd:conditional()} in the univariate imputation
              entries such as {helpb mi impute regress:[MI] mi impute regress}.

{phang3}d. {bf:Imputation by groups.}
              See new option {cmd:by()} in {helpb mi impute:[MI] mi impute}.

{phang3}e. {bf:Imputation by drawing posterior estimates from bootstrapped}
              {bf:samples.}
              See new option {cmd:bootstrap} in the univariate imputation
              entries such as {helpb mi impute regress:[MI] mi impute regress}.

{phang3}f. {bf:Panel-data and multilevel models are now supported.}
              Included are 
              {cmd:xtcloglog}, 
              {cmd:xtgee}, 
              {cmd:xtlogit}, 
              {cmd:xtmelogit}, 
              {cmd:xtmepoisson}, 
              {cmd:xtmixed}, 
              {cmd:xtnbreg}, 
              {cmd:xtpoisson}, 
              {cmd:xtprobit}, 
              {cmd:xtrc}, and
              {cmd:xtreg}.
              See {helpb mi estimation:[MI] mi estimation}.

{phang3}g. {bf:Linear and nonlinear predictions after MI estimation.}
        See {helpb mi estimate postestimation:[MI] mi estimate postestimation}.

{phang3}h. {bf:Monte Carlo jackknife error estimates.} 
              See new option {cmd:mcerror} in
              {helpb mi estimate:[MI] mi estimate}.

{phang3}i. {bf:Estimation output improved.}{break}
              {bf:--Baseline odds now shown.}{break}
              {bf:--Implied zero coefficients now shown.}{break}
              {bf:--You can set displayed precision.}
              See {helpb set cformat:[R] set cformat} and
                {helpb estimation options:[R] estimation options}.{break}
              {bf:--Estimation commands now respect the width of the}
                          {bf:Results window.}
                   See {helpb estimation options:[R] estimation options}.{break}
	      {bf:--You can now set whether base levels, empty cells, and}
	      {bf:omitted are shown.} See
              {helpb set showbaselevels:[R] set showbaselevels} and
              {helpb estimation options:[R] estimation options}.

{pmore2} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2.
        {bf:Handling of perfect prediction} during imputation of categorical 
        data using {cmd:logit}, {cmd:ologit}, and {cmd:mlogit}.  
        See {mansection MI miimputeRemarksandexamplesTheissueofperfectpredictionduringimputationofcategoricaldata:{it:The issue of perfect prediction during imputation of categorical data}} in 
        {helpb mi impute:[MI] mi impute}
        and see new option {cmd:augment} in 
        {helpb mi impute logit:[MI] mi impute logit}, 
        {helpb mi impute ologit:[MI] mi impute ologit}, and 
        {helpb mi impute mlogit:[MI] mi impute mlogit}.

{phang2}
3.
    {bf:Faster imputation.} 
    {cmd:mi impute} no longer secretly converts to {cmd:flongsep} and
     back again.

{phang2}
4.
    {bf:mi estimate now supports total.}  
    See {helpb mi estimation:[MI] estimation}.

{phang2}
5. 
    {bf:misstable summarize will now create summary variables} recording 
    the missing-values pattern.  See new option {cmd:generate()} 
    for {cmd:summarize} in {helpb misstable:[R] misstable}.
    Note that {cmd:mi} {cmd:misstable} does not have this new option.
    The new option is useful before data are imputed.

{phang2}
6. 
    {bf:mi estimate} and {bf:mi estimate using} now use a small-sample
    adjustment when computing fractions of missing information and,
    subsequently, when computing relative efficiencies when the specified
    estimation command provides complete-data degrees of freedom.  Before,
    these statistics were always computed assuming a large sample.  Fractions
    of missing information and relative efficiencies are reported when the
    {cmd:vartable} option is used.  The old behavior is available under
    version control.

{phang2}
7. 
    {bf:mi impute monotone} retains in the imputation model imputation
    variables that do not contain missing values in the imputation sample.
    Before, {bf:mi impute monotone} omitted such variables from the imputation
    model, assuming independence between the variables being imputed and
    the variables being omitted.  The old behavior is available under version
    control.


    {title:What's new in graphics}

{phang2}
1. 
    {bf:Highlights}, 

{phang3}a. {bf:Graphs of margins, marginal effects, contrasts, ....}
              See {helpb marginsplot:[R] marginsplot}.

{phang3}b. {bf:Contour plots.}
              See {helpb twoway contour:[G-2] graph twoway contour} and
                  {helpb twoway contourline:[G-2] graph twoway contourline}.

{phang3}c.
        {bf:PDF export for graphs and logs} lets you directly create
        PDFs from your Stata graphs.
        See {helpb graph export:[G-2] graph export} and
            {helpb translate:[R] translate}.

{pmore} See {it:{help whatsnew11to12##highlights:What's new (highlights)}}.

{phang2}
2. {bf:Time-series operators now supported} by 
          {cmd:twoway lfit}, 
          {cmd:twoway lfitci}, 
          {cmd:twoway qfit}, and
          {cmd:twoway qfitci}.
          See 
          {helpb twoway lfit:[G-2] graph twoway lfit},
          {helpb twoway lfitci:[G-2] graph twoway lfitci},
          {helpb twoway qfit:[G-2] graph twoway qfit}, and
          {helpb twoway qfitci:[G-2] graph twoway qfitci}.

{phang2}
3.
     {bf:Graphs of marginal and covariate-specific ROC curves.}
     New command {cmd:rocregplot} plots the fitted ROC curve after
     {cmd:rocreg}.  See {helpb rocregplot:[R] rocregplot}.

{phang2}
4.
     {bf:Option addplot() now places added graphs above or below.}
     Graph commands that allow option {cmd:addplot()} 
     can now place the added plots above or below the command's plots. 


    {title:What's new in programming}

{phang2}
1. 
      {bf:Stored results r() and e() can be marked hidden or historical},
      which means they do not show when the user types {cmd:return} {cmd:list} 
      or {cmd:ereturn} {cmd:list} unless the user also specifies option
      {cmd:all}.  See {helpb return:[P] return}.

{phang2}
2. 
     {bf:Estimation commands now store in r() as well as e().}
     {cmd:r()} values are stored at estimation time and after replaying.
     Stored are

{phang3}a.
        {cmd:r(level)}, a scalar containing the confidence level for the
        CIs.

{phang3}b.
        {cmd:r(label}{it:#}{cmd:)}, a macro containing the label displayed 
        with the {it:#}th coefficient, such as "(base)", "(omitted)", 
        or "(empty)".

{phang3}c.
        {cmd:r(table)}, a matrix containing all the data displayed in the 
        coefficient table.  The matrix is the coefficient table, transposed;
        each column contains coefficients and associated statistics.
        To understand the matrix, do the following:

                {cmd}. sysuse auto, clear
                . regress mpg weight displ
                . matrix list r(table){txt}

{pmore2}See {helpb ereturn:[P] ereturn}.

{phang2}
3.
   {bf:ereturn display offers new options for controlling the look of the}
     {bf:coefficient table.}

{phang3}a. Options {cmd:noomitted}, {cmd:vsquish}, {cmd:noemptycells},
{cmd:baselevels}, and {cmd:allbaselevels} control row spacing and
display of omitted variables and base and empty cells. 

{phang3}b. Formatting display options {cmd:cformat(%}{it:fmt}{cmd:)},
     {cmd:pformat(%}{it:fmt}{cmd:)}, and {cmd:sformat(%}{it:fmt}{cmd:)} control
     the formats of numbers in the coefficient table.

{phang3}c. {cmd:ereturn display} now respects the width of the Results
     window. This feature may be turned off by new display option
      {cmd:nolstretch}.

{pmore2}See {helpb estimation options:[R] estimation options}.

{phang2}
4.
    {bf:Matrices can be in tables with equation names only}
    using new options {cmd:coleqonly} and {cmd:roweqonly}.
    See {helpb matlist:[P] matlist}.

{phang2}
5.
    {bf:matrix accum allows option absorb()} to accumulate deviations 
    from the mean within groups.  See {helpb matrix accum:[P] matrix accum}.

{phang2}
6. 
    {bf:Version control for random-number generators} is now determined when
    the seed is set, not when the generator function is used; see
    {helpb version:[P] version}.  New {cmd:creturn} result {cmd:c(version_rng)}
    records the version number currently in effect for random-number
    generators; see {helpb creturn:[P] creturn}.

{phang2}
7. 
    {bf:fvrevar has new option stub()},
    which generates stub+index variables rather than temporary
    variables.  See {helpb fvrevar:[R] fvrevar}.

{phang2}
8. 
    {bf:mprobit now posts base outcome equation to e(b).}
    See {helpb mprobit:[R] mprobit}.

{phang2}
9.
    {bf:Default time for network timeouts was reduced.} 
    {cmd:timeout1} has been reduced from 120 seconds to 30, 
    and {cmd:timeout2} has been reduced from 300 seconds to 180.
    See {helpb netio:[R] netio}.


    {title:What's new in Mata}

{phang2}
1.
   {bf:New Stata commands getmata and putmata} make it easy
   to transfer your data into Mata, manipulate them, and then transfer
   them back to Stata.  {cmd:getmata} and {cmd:putmata} are
   especially designed for interactive use.  See {helpb putmata:[D] putmata}.

{phang2}
2.
    {bf:New functions} imported from Stata,

{phang3}
a.
        {bf:Tukey's Studentized range}, cumulative and inverse,
        {cmd:tukeyprob()} and {cmd:invtukeyprob()}.

{phang3}
b.
        {bf:Dunnett's multiple range}, cumulative and inverse,
        {cmd:dunnettprob()} and {cmd:invdunnettprob()}.

{phang3}
c.
        {bf:New date conversion functions}
         {cmd:dofb()} and {cmd:bofd()} convert between business dates 
         and standard calendar dates.
        See {helpb datetime business calendars:[D] datetime business calendars}.

{pmore2}
    See {helpb functions:[FN] Functions by category},
    {helpb mf_normal:[M-5] normal()}, and {helpb mf_date:[M-5] date()}.

{phang2}
3.
    {bf:Support for hidden and historical saved results.}
    Existing Mata functions {cmd:st_global()}, {cmd:st_numscalar()}, and
    {cmd:st_matrix()} now allow an optional third argument specifying 
    the hidden or historical status.
    Three new functions --  {cmd:st_global_hcat()}, 
    {cmd:st_numscalar_hcat()}, 
    {cmd:st_matrix_hcat()} -- allow you to determine the saved hidden or
    historical status.  See {helpb mf_st_global:[M-5] st_global()},
    {helpb mf_st_numscalar:[M-5] st_numscalar()}, and
    {helpb mf_st_matrix:[M-5] st_matrix()}. 

{phang2}
4.
    {bf:Support for new ml features.}
    Stata's {cmd:ml} now distinguishes the Hessian matrix produced by
    {cmd:technique(nr)} from the other techniques that compute a substitute for
    the Hessian matrix.  This means that {cmd:ml} will compute the real Hessian
    matrix of second derivatives to determine convergence when all other
    convergence tolerances are satisfied and {cmd:technique(bfgs)},
    {cmd:technique(bhhh)}, or {cmd:technique(dfp)} is in effect.

{pmore2}
    Mata's commands {cmd:optimize()} and {cmd:moptimize()} have  been
    similarly changed. 
    See {helpb mf_optimize:[M-5] optimize()} and
        {helpb mf_moptimize:[M-5] moptimize()}.


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
We hope that you enjoy Stata 12.


    {title:Reference}

{marker H1989}{...}
{phang}
Harvey, A. C. 1989.
{it:Forecasting, Structural Time Series Models and the Kalman Filter}.
Cambridge: Cambridge University Press.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew11}.{p_end}

{hline}
