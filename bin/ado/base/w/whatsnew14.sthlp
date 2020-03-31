{smcl}
{* *! version 1.1.6  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:Additions made to Stata during version 14}

{pstd}
This file records the additions and fixes made to Stata during the 14.0, 14.1,
and 14.2 releases:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {bf:this file}        Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
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
See {help whatsnew14to15}.


{hline 8} {hi:update 29jan2018} {hline}

{p 5 9 2}
1.  New command {helpb lmbuild} makes creating Mata function libraries easier 
    than does {helpb mata mlib}.

{p 5 9 2}
2.  {helpb estat mindices}, when specified after {helpb sem_command:sem} with
    a large number of observed endogenous variables, sometimes reported a
    missing value for all the modification indices representing an omitted
    path or covariance.  This has been fixed.

{p 9 9 2}
    Our technical services team previously recommended using the undocumented
    option {cmd:slow} when {cmd:estat} {cmd:mindices} reported missing values.
    This option is no longer necessary.

{p 5 9 2}
3.  {helpb ml}, when specified with option {cmd:technique(bhhh)}, sampling
    weights, and option {cmd:group()}, exited with an uninformative error
    message even when the weights were constant within group.  This has been
    fixed.


{hline 8} {hi:update 19dec2017} {hline}

{p 5 9 2}
1.  Community-contributed command {helpb dataex}, which generates properly
    formatted data examples for Statalist, is now being distributed with
    official Stata for the convenience of anyone who wishes to post data on
    Statalist.

{p 5 9 2}
2.  {helpb areg}, when fitting a model with the {opt absorb()} variable
    specified among the {it:indepvars} and with option
    {cmd:vce(cluster} {it:clustvar}{cmd:)} where {it:clustvar} is a variable
    other than the {opt absorb()} variable, incorrectly exited with error
    message "{err:not sorted}".  This has been fixed.

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
4.  {helpb esize:esize twosample}, when a string variable was specified in
    option {opt by()}, incorrectly exited with an uninformative error message.
    This has been fixed.

{p 5 9 2}
5.  {helpb gsem_command:gsem}, when fitting a model with both endogenous and
    exogenous latent variables and with an interaction term containing a
    latent variable, exited with an uninformative error message.  {cmd:gsem}
    now fits the model as specified.

{p 5 9 2}
6.  {helpb gsem_command:gsem}, when option {opt capslatent} was specified or
    implied, ignored variables in the model if their first letter was a
    capital letter.  Now {cmd:gsem} recognizes those variables as latent
    variables.

{p 5 9 2}
7.  {helpb margins} has the following improvement and fixes:

{p 9 13 2}
     a.  {cmd:margins} has improved numerical derivatives logic for computing
         the Jacobian matrix.

{p 9 13 2}
     b.  {cmd:margins} with option {opt asbalanced}, when working with
         estimation results from ordinal outcome models like {helpb ologit}
         and {helpb oprobit} and when a factor variable was not among the
         {it:marginsvars}, incorrectly exited with error message
         "{cmd:not conformable}".  This has been fixed.

{p 9 13 2}
     c.  {helpb margins_pwcompare:margins} with option {cmd:pwcompare}, when
         used to compute margins for two or more interaction terms that
         involved the same number of factor variables, incorrectly computed
         the values of the margins.  This has been fixed.

{p 5 9 2}
8.  {helpb marginsplot}, when plotting marginal effects of multiple factor
    variables in options {opt dydx()} and {opt eydx()}, has improved spacing
    of the x-axis scale.

{p 5 9 2}
9.  {helpb melogit} and {helpb mepoisson} with option
    {cmd:intmethod(laplace}}, when used to fit a two-level model, may not have
    converged when the model could have been identified.  This has been fixed.

{p 4 9 2}
10.  Prefix command {helpb mfp} used with {helpb intreg} incorrectly dropped
     all left- or right-censored observations from the estimation sample.
     {cmd:mfp} now keeps these observations.

{p 4 9 2}
11.  {helpb ml} with method {cmd:d1debug} or method {cmd:d2debug}, when the
     specified model contained factor variables, exited with error message
     "{err:could not calculate numerical derivatives}".  This has been fixed.

{p 4 9 2}
12.  {cmd:predict} after {helpb logit_postestimation##predict:logit} and
     {helpb probit_postestimation##predict:probit}, when the fitted model
     omitted the base level of a factor variable because it was a perfect
     predictor, did not properly assign missing values to the predictions
     according to the information in the matrix {cmd:e(rules)}.  This has been
     fixed.

{p 4 9 2}
13.  {helpb putexcel} {it:ul_cell}{cmd:=picture(}{it:filename}{cmd:)} gave an
     error if you used compound quotes around {it:filename}.  This has been
     fixed.

{p 4 9 2}
14.  {helpb pwcorr} has the following fixes:

{p 9 13 2}
     a.  {cmd:pwcorr} with no observations and only two variables specified,
         incorrectly stored {cmd:r(rho)} as 0.  It now exits with error
         message "{err:no observations}".

{p 9 13 2}
     b.  {cmd:pwcorr} with no observations for the first two variables and
         more than two variables specified, incorrectly stored {cmd:r(rho)} as
         0.  It now correctly stores {cmd:r(rho)} as missing.

{p 4 9 2}
15.  {helpb stcox}, when specified with option {opt shared()} and variable
     names in {it:indepvars} that exceeded the default 12-character width for
     the table, produced a coefficient table with misaligned elements in the
     row for the {cmd:theta} parameter estimate.  This has been fixed.

{p 4 9 2}
16.  {helpb stepwise} with options {cmd:lockterm1} and {cmd:lr} and forward
     selection or forward stepwise selection computed likelihood ratios at
     the first addition step by comparing each model with an additional term
     with an empty model rather than with the model that includes the forced
     first term.  Thus, terms could be added to the model that did not satisfy
     the specified significance level for inclusion.  This has been fixed.

{p 4 9 2}
17.  {helpb xtile:xtile, altdef} failed to use the alternative formula for
     calculating percentiles and instead calculated them using the default
     formula.  This has been fixed.

{p 4 9 2}
18.  Edit > Copy Table could omit the minus sign from negative numbers if they
     were in the first cell of a row being copied.  This has been fixed.

{p 4 9 2}
19.  (Mac) macOS 10.13 introduced a change that caused Stata's Data Editor to
     crash when used with an {help if:if expression}.  This has been fixed.


{hline 8} {hi:update 10oct2017} {hline}

{p 5 9 2}
1.  {helpb putexcel} now supports existing option {cmd:overwritefmt} when
    using the syntax for formatting cells.  This lets you write Excel cell
    formats more efficiently.

{p 5 9 2}
2.  {helpb asclogit}, {helpb asmprobit}, {helpb asroprobit}, and
    {helpb nlogit}, when option {cmd:case()} specified a variable with values
    exceeding {helpb creturn:c(maxlong)} = 2,147,483,620, grouped all the
    associated observations into a single case.  This has been fixed.

{p 5 9 2}
3.  {helpb graph} ignored legend option
    {helpb legend_options##location:ring()} if the scheme placed the legend
    within the plot region.  This has been fixed.

{p 5 9 2}
4.  {helpb graph export}, when exporting to PDF a
    {help graph_text##symbols:Greek letter} that had the italic font applied,
    did not display the Greek letter as italicized.  This has been fixed.

{p 5 9 2}
5.  {helpb import excel}, when the Excel file was specified as a path and
    filename without an extension, exited with error message
    "{err:file not found}" even when the file existed.  This has been fixed.

{p 5 9 2}
6.  {helpb margins} with weighted estimation results, with the first
    observation in the dataset containing a missing weight value, and with all
    the independent variables fixed to a constant value incorrectly estimated
    all margins as zero valued with the "(omitted)" note.  This has been
    fixed.

{p 5 9 2}
7.  {helpb marginsplot}, after {helpb margins} where a factor-variable name
    could also have served as an abbreviation for a continuous variable and
    both variables were specified in option {cmd:at()}, exited with error
    message "{err:_marg_save has a problem. Margins not uniquely identified.}"
    This has been fixed.

{p 5 9 2}
8.  {helpb tebalance box}, when used after {helpb teffects} with a treatment
    variable using value labels with spaces, incorrectly exited with error
    message "{err:invalid syntax}".  This has been fixed.

{p 5 9 2}
9.  {helpb zip} and {helpb zinb} no longer support option {cmd:vuong}, which
    specifies that the Vuong test for nonnested models be reported.  This test
    was used to compare zero-inflated and noninflated models.  However, recent
    work has shown that testing for zero inflation using the Vuong test is
    {help j_vuong:inappropriate}.  If you wish to proceed with the test
    anyway, use the zero-inflated commands with undocumented option
    {cmd:forcevuong}.

{p 4 9 2}
10.  (Windows) {helpb window fopen} always displayed all files instead of the
     filtered list of files.  This has been fixed.

{p 4 9 2}
11.  (Unix GUI) The "Save preferences" dialog box did not open to the correct
     directory.  This has been fixed.


{hline 8} {hi:update 26sep2017} {hline}

{p 5 9 2}
1.  (Mac) A bug in macOS High Sierra (10.13) could cause Stata to crash when
    dialogs that were opened from the Data, Statistics, and Graphics menus
    were closed.  This has been fixed.


{hline 8} {hi:update 13jul2017} {hline}

{p 5 9 2}
1.  {helpb mixed} with option {cmd:dfmethod()} is now faster when computing
    degrees of freedom using Satterthwaite and Kenward-Roger methods.  The
    increase in speed is substantial with clusters containing thousands of
    observations.

{p 5 9 2}
2.  {helpb gsem_postestimation:estat eform} is now supported after
    {helpb svy}{cmd::} {helpb gsem_command:gsem}.

{p 5 9 2}
3.  {helpb bayesmh}, when Gibbs sampling was used for a covariance matrix
    parameter with an inverse-Wishart prior and when the degrees of freedom
    was specified as a noninteger value, returned an uninformative error
    message.  {cmd:bayesmh} now exits with error message
    "{err:the degrees of freedom must be an integer number}".

{p 5 9 2}
4.  {helpb clogit} with option {cmd:vce(bootstrap)} did not allow
    factor-variables notation.  This has been fixed.

{p 5 9 2}
5.  {help exp:Expressions} that included a numeric literal longer
    than 129 characters could cause Stata to crash.  This has been fixed so
    that Stata can handle numeric literals of arbitrary length.

{p 5 9 2}
6.  {helpb fvrevar} now attaches the default numeric format to all indicator
    variables generated from a factor variable.  Previously, the numeric
    format of the original factor variable was copied to the new variables.
    The old behavior is not preserved under version control.

{p 5 9 2}
7.  {helpb graph export} has the following fixes:

{p 9 13 2}
     a.  {cmd:graph export}, when exporting to PDF file format a
         {help graph pie:pie graph} where the angle of a slice was close to 0
         degrees, incorrectly displayed the pie graph as a whole circle.  This
         has been fixed.

{p 9 13 2}
     b.  {cmd:graph export}, when exporting to EPS file format a graph where a
         truetype font was specified with option {opt fontface()}, did not
         render text as boldface or italic.  This has been fixed.

{p 5 9 2}
8.  {helpb gsem_command:gsem}, with multilevel latent variables, multiple
    outcome variables, and missing values in some of the observed variables,
    incorrectly exited with error message
    "{err:missing values not allowed in S}".  This has been fixed.

{p 5 9 2}
9.  {helpb gmm_postestimation##syntax_predict:predict} with option
    {opt scores}, when used after {helpb gmm} with option {opt onestep} and
    when {opt onestep} was abbreviated, exited with an uninformative error
    message.  {cmd:predict} now computes the scores as specified.

{p 4 9 2}
10.  {helpb import delimited}, when used with option {cmd:stringcols()} or
     option {cmd:numericcols()}, could incorrectly import the first row as
     variable names.  This has been fixed.

{p 4 9 2}
11.  Mata functions {helpb mf_normal:lnwishartden({it:df}, {it:V}, {it:X})}
     and {helpb mf_normal:lniwishartden({it:df}, {it:V}, {it:X})} caused Stata
     to use more memory than was required.  The practical consequence was that
     Stata ran slower when these functions were called repeatedly, such as by
     {helpb bayesmh} with models using Wishart and inverse-Wishart priors.
     This has been fixed.

{p 4 9 2}
12.  {helpb mfp} with the default closed-test algorithm for choosing a
     multivariable fractional polynomial (MFP) model reported p-values
     that were slightly smaller than they should have been.  In most cases,
     the difference occurred beyond the third decimal place.  This has been
     fixed.

{p 9 9 2}
     Note that the differences in p-values rarely affected the variables
     selected for the final MFP model and that the p-values reported in the
     regression table for the final model were correct.

{p 4 9 2}
13.  Prefix {helpb mi estimate}, when option {cmd:cmdok} was specified to
     allow estimation with unsupported command {helpb gsem_command:gsem},
     incorrectly exited with a Mata trace log and error message
     "{err:name conflict}" when random effects were included with {cmd:gsem}.
     {cmd:mi estimate} now fits the specified generalized SEM model.

{p 4 9 2}
14.  {helpb mi impute chained} with option {cmd:savetrace()} did not respect
     spaces or quotes in folder names or filenames.  This has been fixed.

{p 4 9 2}
15.  {helpb ml}, when option {opt technique()} specified a switch between
     {cmd:nr} and {cmd:bfgs} or between {cmd:nr} and {cmd:dfp} and when
     constraints were specified, incorrectly exited with an error message.
     This has been fixed.

{p 4 9 2}
16.  {helpb pctile} with option {opt genp(newvarp)} and more than 1,000
     quantiles specified in option {opt nquantiles()} did not store the
     percentages in the observations that held the corresponding percentiles.
     This has been fixed.

{p 4 9 2}
17.  {helpb gsem_predict:predict} with option {cmd:latent()}, when used after
     {helpb gsem_command:gsem} and when the fitted model had paths between
     endogenous latent variables, incorrectly exited with an error message.
     This has been fixed.

{p 4 9 2}
18.  {helpb saveold} with option {cmd:all}, when the dataset in memory
     contained the {cmd:e(sample)} variable, incorrectly exited with
     error message
    "{err:variable name ... does not meet the restrictions of old .dta format}".
     This has been fixed.

{p 4 9 2}
19.  {helpb sem_command:sem} with a symbolic constraint name defined using
     {cmd:@}, such as {cmd:@a}, when the constraint was also identified with
     an automatically determined anchor, exited with error message
     "{err:'a' not found}" if the symbolic constraint name was used in any
     other constraints.  {cmd:sem} now retains the symbolic constraint name.

{p 4 9 2}
20.  {helpb stcrreg} with prefix {helpb stepwise} and parentheses binding the
     first predictor incorrectly exited with error message
     "{err:option compete() required}" even when option {opt compete()} was
     specified.  This has been fixed.

{p 4 9 2}
21.  Function {helpb tden():tden({it:df},{it:t})}, in extreme cases in the
     tails of the distribution where the density is close to 0, returned a
     value that was larger than the correct value.  This has been fixed.

{p 4 9 2}
22.  {helpb tebalance box} and {helpb tebalance density} after
     {helpb teffects}, when the working directory contained many {bf:.gph}
     files, incorrectly exited with error message "{err:invalid syntax}".
     This has been fixed.

{p 4 9 2}
23.  {helpb unicode convertfile} with option {cmd:dstcallback()} applied the
     default method {cmd:stop} regardless of the method specified.  This has
     been fixed.

{p 4 9 2}
24.  Function {cmd:ustrregexs()} in {help f_ustrregexm:Stata} and
     {help mf_ustrregexm:Mata} without first performing a valid regular
     expression match using {cmd:ustrregexm()} caused Stata to crash.  This
     has been fixed.

{p 4 9 2}
25.  (Unix GUI) When using a MobaXterm Windows client, the Find dialog in the
     Do-file Editor froze if no matches were found for the text specified in
     the "Find what:" field.  This has been fixed.


{hline 8} {hi:update 04may2017} {hline}

{p 5 9 2}
1.  {helpb arfima}, when the time-series data were nonstationary and feasible
    initial values could not be obtained, exited with an uninformative error
    message.  The command now exits with error message
    "{err:initial values not feasible}".

{p 5 9 2}
2.  {helpb factor}, when any variable in the analysis is constant, exited with
    error message "{err:conformability error}".  Now, {cmd:factor} drops the
    constant variable and uses the remaining variables for the analysis.

{p 5 9 2}
3.  {helpb graph box} and {helpb graph hbox}, when the upper adjacent value
    equals the 75th percentile plus 1.5 times the interquartile range (IQR)
    or the lower adjacent value equals the 25th percentile minus 1.5 times the
    IQR, plotted the data whose value equals the adjacent values as an
    outlier. Because an outlier is defined as a value greater than the upper or
    less than the lower adjacent value, this value is not an outlier.  This
    has been fixed.

{p 5 9 2}
4.  {helpb icd10 lookup}, when the requested code range contained a formatted
    code (one that includes a "{bf:.}"), incorrectly reported
    "(no matches found)".  This has been fixed.

{p 5 9 2}
5.  {helpb irt rsm} now imposes constraints on the threshold structure of the
    items by using the underlying IRT parameterization to fit the model
    described by Andrich (1978a, {it:Applied Psychological Measurement} 2:
    581-594; 1978b, {it:Psychometrika} 43: 561-573).  Previously,
    {cmd:irt rsm} imposed constraints by using the slope-intercept
    parameterization.  The old behavior is not preserved under version
    control.

{p 5 9 2}
6.  {helpb predict} with option {cmd:cm} after {helpb tnbreg} and
    {helpb tpoisson}, when the lower truncation point specified in option
    {cmd:ll()} of the estimation command was not 0, did not account for
    truncation correctly when computing the conditional mean.  As a result,
    the conditional mean was overestimated.  This has been fixed.

{p 5 9 2}
7.  {helpb svy tabulate:svy: tabulate}, when tabulating numeric variables with
    value labels or string variables that contain periods ("{cmd:.}") or
    colons ("{cmd::}"), now preserves these characters in the row and column
    titles of the reported table.  Previously, "{cmd:.}" and "{cmd::}"
    were translated to "{cmd:,}" and "{cmd:;}".  The old behavior is not
    preserved under version control.


{hline 8} {hi:update 16mar2017} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 17(1).


{hline 8} {hi:update 07mar2017} {hline}

{p 5 9 2}
1.  {helpb sem_estat_eqgof:estat eqgof}, after fitting a model with
    {helpb sem_command:sem} that included latent endogenous variables and did
    not include any exogenous variables, incorrectly reported zero values for
    the R-squared statistics.  This has been fixed.

{p 5 9 2}
2.  {helpb import excel} has the following fixes:

{p 9 13 2}
     a.  {cmd:import excel} with option {opt sheet(sheetname)}, when the
         sheetname started with {bf:$}, incorrectly named the sheet
         {bf:Sheet1}.  This has been fixed.

{p 9 13 2}
     b.  {cmd:import excel} incorrectly used Stata format {cmd:%tchh:MM:SS}
         instead of {cmd:%tcHH:MM:SS} when importing Excel custom time format
         {cmd:h:mm:ss} data.  This has been fixed.

{p 5 9 2}
3.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with options {opt asbalanced} and
         {cmd:emptycells(reweight)} treated interaction terms without factor
         variables as zero.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} with option {cmd:predict()} and suboption {opt psel} or
         {opt xbsel} after {helpb heckman}, {helpb heckprobit}, or
         {helpb heckoprobit} incorrectly excluded nonselected observations
         with a missing value for a covariate not specified in {opt select()}
         at estimation.  This has been fixed.

{p 5 9 2}
4.  {helpb power oneproportion} with option {cmd:continuity} overestimated
    the power for the two-sided test.  This has been fixed.

{p 5 9 2}
5.  {helpb xtfrontier_postestimation##predict:predict} with option {opt te}
    after {helpb xtfrontier}, when estimation had been performed for a sample
    restricted to a certain range by using qualifiers {cmd:if} or {cmd:in},
    returned incorrect results.  This has been fixed.

{p 5 9 2}
6.  Do-files and ado-files that contain nested open comment delimiters with no
    spaces between them (for example, {cmd:/*/*}) could cause Stata to crash.
    This has been fixed.

{p 5 9 2}
7.  The Java Runtime Environment that is redistributed with Stata is now
    updated to version 8 update 121.

{p 5 9 2}
8.  (Mac) In the Data Editor, when the Option key+e combination was used to
    enter an accented character into a cell and when the inline edit field for
    the cell had not been initiated prior to entering text, the first typed
    character was not entered.  This has been fixed.

{p 5 9 2}
9.  (Mac) In the Data Editor, when an international keyboard (such as a
    Japanese keyboard) was used to initiate the inline edit field of a cell,
    the first typed character was not entered.  This has been fixed.

{p 4 9 2}
10.  (Mac) Stata could crash when a document that was printed from the Do-file
     Editor took a long time to print.  This has been fixed.

{p 4 9 2}
11.  (Mac) When opening a file in the Do-file Editor that is not encoded in
     UTF-8, Stata attempted to convert the file to UTF-8 using the default
     character encoding for your locale.  For some locales, this conversion
     could not be done using the default encoding, and nothing appeared in the
     Do-file Editor (for example, opening a do-file encoded in Windows Latin 1
     from a Japanese locale).  Stata now prompts you to specify the character
     encoding of the file before converting it to UTF-8.

{p 4 9 2}
12.  (Mac) Programmable dialogs with combo boxes that have editing disabled did
     not register a selection from the combo box's drop-down list.  This has
     been fixed.


{hline 8} {hi:update 09jan2017} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 16(4).

{p 5 9 2}
2.  {helpb bayestest model}, when all marginal likelihoods were evaluated to
    be zero because of numerical overflow, did not evaluate the posterior
    probabilities and reported missing values.  The calculation of the
    posterior probabilities is now more precise, so missing values are far
    less likely.

{p 5 9 2}
3.  {helpb suest}, when used to compute the sandwich estimator of the
    asymptotic variance for the fitted coefficients from non{helpb svy}
    estimation results, now uses {cmd:e(V_modelbased)} if it is present
    instead of {cmd:e(V)}.  The old behavior is not preserved under version
    control.


{hline 8} {hi:update 19dec2016} {hline}

{p 5 9 2}
1.  {helpb sem_estat_gof:estat gof}, after fitting a model with an
    overidentified mean structure using {helpb sem_command:sem},
    overestimated the value of SRMR.  {cmd:estat gof} no longer includes the
    modeled means when calculating SRMR.  The old behavior is not preserved
    under version control.

{p 5 9 2}
2.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} after {helpb stcrreg} and with option
         {cmd:vce(unconditional)} incorrectly exited with an error.  This has
         been fixed.

{p 9 13 2}
     b.  {cmd:margins} after {helpb svy} with multilevel weights exited with
	 error message "{err}{bf:svyset} characteristics disagree with
	 {bf:svy} estimation results{reset}" even when the {helpb svyset}
	 characteristics were not changed.  This has been fixed.

{p 5 9 2}
3.  Mata function {helpb mf__docx##remarks_file:_docx_new()}, when called
    after {helpb mf__docx##remarks_table:_docx_new_table()}, cleared
    previously returned table ID codes.  This prevented tables that were
    created before {cmd:_docx_new()} was called from being edited or added to
    the document.  This has been fixed.

{p 5 9 2}
4.  Mata function
    {helpb mf_pdf##des_table_matrix:fillStataMatrix({it:name, colnames, rownames})}
    incorrectly filled the first row of the table with the
    {helpb matrix_rownames:matrix rownames} of the matrix when the
    {it:colnames} argument was not 0.  This has been fixed.

{p 5 9 2}
5.  Mata function {helpb mf_normal:lnmvnormalden({it:M},{it:V},{it:X})} exited
    with error message "{err:conformability error}" when {it:M} and {it:X}
    were {help m2_void:void vectors} and {it:V} was a
    {help m2_void:0 {it:x} 0 matrix}.  {cmd:lnmvnormalden()} now returns a 0
    {it:x} 0 matrix in this case.

{p 5 9 2}
6.  Mata functions {helpb mf_normal:lnwishartden({it:df},{it:V},{it:X})} and
    {helpb mf_normal:lniwishartden({it:df},{it:V},{it:X})} exited with error
    message "{err:conformability error}" when {it:V} and {it:X} were
    {help m2_void:0 {it:x} 0 matrices}.  {cmd:lnwishartden()} and
    {cmd:lniwishartden()} now return a 0 {it:x} 0 matrix in this case.

{p 5 9 2}
7.  {helpb power twoproportions} has the following change in behavior and fix:

{p 9 13 2}
     a.  {cmd:power twoproportions} with option {cmd:test(fisher)}, when
         either the control-group or the experimental-group sample size is
         larger than 1,000, reported a missing value.  It now exits with error
         message "{err:failure to compute power}".

{p 9 13 2}
     b.  {cmd:power twoproportions} with option {cmd:test(fisher)}, when the
         total sample size is larger than 1,028 and both the control-group and
         experimental-group sample sizes are smaller than or equal to 1,000,
         underestimated the power.  It now exits with error message
         "{err:failure to compute power}".

{p 5 9 2}
8.  (Mac) When using Stata in full-screen mode on macOS Sierra, some graphs
    appeared in a low resolution or did not appear at all after their window
    finished transitioning into a full-screen window.  This has been fixed.

{p 5 9 2}
9.  (Mac) macOS Sierra 10.12.2 introduced a change that caused Stata's Do-file
    Editor to crash.  This has been fixed.

{p 4 9 2}
10.  (Mac and Unix GUI) When saving an SEM path diagram, Stata prompted the
     user for a filename even if the diagram had been saved before.  This has
     been fixed.


{hline 8} {hi:update 16nov2016} {hline}

{p 5 9 2}
1.  You can now comment or uncomment a selection of lines in the Do-file
    Editor by selecting the "Edit > Advanced > Toggle comment" menu item.

{p 5 9 2}
2.  Mata function {helpb mf__docx:_docx*()} has the following improvement
    and fix:

{p 9 13 2}
     a.  New Mata function
         {browse "http://www.stata.com/docx_styles.html":{bf:_docx_cell_set_border({it:dh, tid, i, j, name, val, color})}}
         allows you to format the borders of the cell on the {it:i}th row and
         {it:j}th column, in which {it:name}, {it:val}, and {it:color} specify
         the border name, border style, and border color.

{p 9 13 2}
     b.  {browse "http://www.stata.com/docx_styles.html":{bf:_docx_table_set_width({it:dh, tid, type, w})}},
         when argument {it:type} was {cmd:auto}, did not make the columns in a
	 table automatically fit the contents.  This has been fixed.

{p 5 9 2}
3.  {helpb _diparm} after {helpb meglm}, {helpb melogit}, {helpb meprobit},
    {helpb mecloglog}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb menbreg}, and {helpb mestreg}, when {it:eqname} referred to a
    variance component, incorrectly exited with error message
    "{err:equation ___ not found}".  {cmd:_diparm} now works as documented.

{p 5 9 2}
4.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {opt asbalanced} exited with an
         uninformative error message when {help fvvarlists:factor variables}
         were included in a model fit using {helpb gsem_command:gsem},
         {helpb meglm}, {helpb melogit}, {helpb meprobit}, {helpb mecloglog},
         {helpb mepoisson}, {helpb menbreg}, {helpb meologit},
         {helpb meoprobit}, {helpb mestreg}, {helpb xtologit}, or
         {helpb xtoprobit}.  {cmd:margins} now computes the requested marginal
         means, predictive margins, or marginal effects.

{p 9 13 2}
     b.  {cmd:margins}, when used after {helpb ologit} or {helpb oprobit} with
         no {it:indepvars} or a model Wald test with zero degrees of freedom,
         exited with error message "{err:0 invalid name}" instead of computing
         the requested margins.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins} after {helpb xtreg:xtreg, be} with option {cmd:wls}
         incorrectly exited with an uninformative error message.
         {cmd:margins} now works as documented.

{p 5 9 2}
5.  Mata function
    {cmd:setCellTopBorderWidth(}{it:i, j, sz}{cmd:)}
    incorrectly removed the right border instead of the top border of the cell
    on the {it:i}th row and {it:j}th column when the specified size {cmd:sz}
    was 0.  This has been fixed.

{p 5 9 2}
6.  {helpb ml plot} did not update starting values for use with {cmd:ml}.
    This has been fixed.

{p 5 9 2}
7.  {cmd:predict} with option {opt reffects} or {opt mu} after fitting a
    model with {helpb meglm_postestimation##predict:meglm},
    {helpb melogit_postestimation##predict:melogit},
    {helpb meprobit_postestimation##predict:meprobit},
    {helpb mecloglog_postestimation##predict:mecloglog},
    {helpb meologit_postestimation##predict:meologit},
    {helpb meoprobit_postestimation##predict:meoprobit},
    {helpb mepoisson_postestimation##predict:mepoisson},
    {helpb menbreg_postestimation##predict:menbreg}, or
    {helpb mestreg_postestimation##predict:mestreg} could return zero values
    instead of the empirical Bayes mean estimates for groups with a large
    number of observations.  This has been fixed.

{p 5 9 2}
8.  {cmd:predict} with option {opt latent} or {opt mu} after fitting a model
    with {helpb gsem_predict:gsem} could return zero values instead of the
    empirical Bayes mean estimates for groups with a large number of
    observations.  This has been fixed.

{p 5 9 2}
9.  {helpb qnorm}, when used with qualifier {cmd:if} or {cmd:in}, drew a
    y-axis scale that accounted for the observations not selected by the
    {cmd:if} or {cmd:in} condition.  This has been fixed.

{p 4 9 2}
10.  Stata function {helpb f_regexm:regexs()}, when used in an
     {help exp:expression}, could crash or produce wrong results in
     {help statamp:Stata/MP}.  The incorrect results were most often scrambled
     text.  This has been fixed.

{p 4 9 2}
11.  {helpb sem_command:sem} with option {cmd:technique(bhhh)}, when the model
     was not identified, sometimes exited with an uninformative error message
     before reaching the maximum number of iterations.  This has been fixed.

{p 4 9 2}
12.  {helpb stcrreg}, when the data were {helpb stset} using option
     {cmd:exit()}, reported incorrect numbers of competing risks and
     censored observations.  The estimated coefficients were not
     affected.  This has been fixed.

{p 4 9 2}
13.  {helpb labelbook:uselabel}, when used to create a dataset from labels
     that contained numeric values requiring
     {help data_types:double precision}, incorrectly stored the values in
     float precision.  This has been fixed.

{p 4 9 2}
14.  {helpb xtlogit}, {helpb xtprobit}, and {helpb xtcloglog} with option
     {cmd:vce(robust)} or option {cmd:vce(cluster} {it:panelvar}{cmd:)} and
     prefix {helpb by} incorrectly included the whole sample in the calculation
     of the standard errors instead of limiting the sample to each by-group.
     This has been fixed.

{p 4 9 2}
15.  {helpb translate} has the following improvement and fix:

{p 9 13 2}
     a.  (Mac) Translators {cmd:smcl2prn}, {cmd:txt2prn}, {cmd:smcl2pdf}, and
         {cmd:txt2pdf} of {cmd:translate} now support
         {helpb translate:translator set}tings {cmd:pagesize},
         {cmd:pagewidth}, and {cmd:pageheight}.  These settings let you, for
         example, specify landscape printing for a standard letter page
         (11 x 8.5 inches).  For more information, see
         {manlink R translate}.

{p 9 13 2}
     b.  (Mac) On some Macs, using {cmd:translate} to export the Results or
         Viewer window to a PDF file could print the contents of the window
         instead.  This has been fixed.


{hline 8} {hi:update 29sep2016} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 16(3).

{p 5 9 2}
2.  {helpb destring}, when used to convert a number stored as text that
    included leading or trailing Unicode whitespace characters, converted the
    number to missing instead of its numeric value.  This has been fixed.

{p 5 9 2}
3.  After the 30mar2016 update,
    {helpb stcox_postestimation##estatcon:estat concordance}, when the number
    of comparison pairs, the number of orderings as expected, or the number of
    tied predictions was greater than 10 million, incorrectly reported rounded
    values for the statistic that was greater than 10 million.  This has been
    fixed.

{p 5 9 2}
4.  {helpb gmm}, when used with option {opt xtinst()} and when the data
    contained panels that were completely dropped from the estimation sample,
    incorrectly exited with error message "{err:{bf:esample()} invalid}".
    This has been fixed.

{p 5 9 2}
5.  For graphics commands that support adding additional plots using option
    {helpb addplot_option:addplot()}, suboption {cmd:below} was respected on
    the initial drawing, and the added plot was drawn below the command's own
    plot or plots.  However, if the resulting graph was saved with
    {helpb graph save} or combined with {helpb graph combine}, then the added
    plot was brought back above the command's own plot or plots.  This has
    been fixed.


{hline 8} {hi:update 14sep2016} {hline}

{p 5 9 2}
1.  (Windows) After the 06sep2016 update, Stata displayed all matching
    variable names as a single menu item rather than separate menu items when
    the Tab key was used to autocomplete a partially typed variable name in
    the Command window.  This has been fixed.


{hline 8} {hi:update 06sep2016} (Stata version 14.2) {hline}

{p 5 9 2}
1.  The {helpb icd10} suite of commands has the following improvements and
    changes:

{p 9 13 2}
     a.  New command {cmd:icd10 search} allows you to search the text
         descriptions of ICD-10 codes for specified keywords.  With option
         {opt version(year)}, you can restrict the search to only codes valid
         in the specified {it:year}.

{p 9 13 2}
     b.  {cmd:icd10 check} has new option {opt summary}.  {opt summary} is a
	 reporting option that provides a frequency of each invalid or
	 undefined code.

{p 9 13 2}
     c.  {cmd:icd10 clean} now requires either option {opt generate()} or
         {opt replace}.  {opt generate()} creates a new variable that contains
         the cleaned ICD-10 codes.  {opt replace} replaces the existing ICD-10
         codes in the specified variable.

{p 9 13 2}
     d.  {cmd:icd10 generate} with option {opt description} can now be
         combined with new option {cmd:addcode(begin}|{cmd:end)}.
         {cmd:addcode(begin)} adds the ICD-10 code to the beginning of the
         description and replaces existing option {opt long}.
         {cmd:addcode(end)} adds the code to the end of the description.
         {opt long} continues to work but is undocumented.

{p 9 13 2}
     e.  {cmd:icd10 generate} with options {opt description} and
         {opt addcode()} can now be combined with new options {opt nodots} and
         {opt pad} to control the formatting of the code added to the
         description.

{p 9 13 2}
     f.  {cmd:icd10 lookup} now accepts a range of ICD-10 codes instead of a
         single code.

{p 9 13 2}
     g.  {cmd:icd10 clean} and {cmd:icd10 generate} have new option
	 {opt check} to check the formatting of the ICD-10 codes before either
	 cleaning or creating a new variable.  This is a convenience feature
	 to avoid running {cmd:icd10 check} first.

{p 9 13 2}
     h.  {cmd:icd10 check}, {cmd:icd10 clean}, {cmd:icd10 generate}, and
	 {cmd:icd10 lookup} have new option {opt version(year)}, which replaces
	 existing option {opt year()}. {opt year()} continues to work but is
	 undocumented.

{p 9 13 2}
     i.  {cmd:icd10 check} has new option {opt fmtonly}, which replaces
         existing option {opt any}.  {opt any} continues to work but is
	 undocumented.

{p 5 9 2}
2.  {helpb gmm} has the following improvements for postestimation after
    generalized method of moments (GMM) estimation:

{p 9 13 2}
     a.  {helpb gmm_postestimation##margins:margins} is now available after
         {cmd:gmm}.  This lets you estimate marginal and conditional effects
         such as means, predictive margins, and marginal effects after GMM
         estimation.

{p 9 13 2}
     b.  {helpb gmm_postestimation##syntax_predict:predict} after {cmd:gmm}
         now allows option {opt xb}.  This lets you obtain the linear
         prediction after GMM estimation.

{p 9 13 2}
     c.  {helpb gmm_postestimation##syntax_predict:predict} after {cmd:gmm}
         now takes option {opt scores}.  This lets you obtain the values of
         the moment conditions after GMM estimation.

{p 5 9 2}
3.  {cmd:predict} after {helpb irt_hybrid_postestimation##predict:irt},
    {helpb gsem_predict:gsem}, {helpb meglm_postestimation##predict:meglm},
    {helpb melogit_postestimation##predict:melogit},
    {helpb meprobit_postestimation##predict:meprobit},
    {helpb mecloglog_postestimation##predict:mecloglog},
    {helpb meologit_postestimation##predict:meologit},
    {helpb meoprobit_postestimation##predict:meoprobit},
    {helpb mepoisson_postestimation##predict:mepoisson},
    {helpb menbreg_postestimation##predict:menbreg}, and
    {helpb mestreg_postestimation##predict:mestreg} has the following
    improvements:

{p 9 13 2}
     a.  {cmd:predict} now supports out-of-sample predictions of empirical
         Bayes means, empirical Bayes modes, and other predictions that
         are conditional on them.

{p 9 13 2}
     b.  {cmd:predict} now computes predictions of empirical Bayes means and
         empirical Bayes modes even when the estimation sample has changed.

{p 9 9 2}
    The old behavior is preserved under version control.

{p 5 9 2}
4.  {helpb sem_command:sem} has improved starting values logic for models with
    latent and observed exogenous variables when option {cmd:method(mlmv)} is
    specified or option {cmd:noxconditional} is specified or implied by the
    model specification.  The result of this is faster convergence of the
    fitted target model.

{p 5 9 2}
5.  {helpb bayesmh}, when used with factor variables as predictors and
    when {helpb showbaselevels} was set, incorrectly included the base-level
    parameters in the calculation of the maximum and average sampling
    efficiencies, which led to increased estimates of these summaries.  The
    base-level parameters are omitted from the model and as such are not
    sampled.  This has been fixed.

{p 5 9 2}
6.  {helpb fp}, when a search was performed on a model that had been fit by
    {helpb clogit} and that model included only the fractional polynomial
    powers, exited with the error message
    "{err:redundant or inconsistent constraints}".  {cmd:fp} now fits the
    model as specified.

{p 5 9 2}
7.  Function {helpb lnigammaden():lnigammaden({it:a},{it:b},{it:x})}, when
    {it:x} was less than or equal to 0, returned a value of 0.
    {cmd:lnigammaden()} now returns a missing value if {it:x} is less than or
    equal to 0.

{p 5 9 2}
8.  {helpb gmm} has the following improvement and fixes:

{p 9 13 2}
     a.  {cmd:gmm} now reports the number of panels used to compute standard
         errors for models with panel-style instruments.

{p 9 13 2}
     b.  {cmd:gmm}, when option {opt onestep} was combined with option
         {cmd:winitial(identity)}, reported incorrect standard errors.  This
         has been fixed.

{p 9 13 2}
     c.  {cmd:gmm} with option {opt nocommonesample}, when specified with
         instruments that were not shared between moment equations, either did
         not converge or produced incorrect parameter estimates.  This has
         been fixed.

{p 9 13 2}
     d.  {cmd:gmm}, when used with a moment-evaluator program that included a
         {help tsvarlist:time-series operated} instrumental variable,
         incorrectly excluded observations in a panel from the estimation
         sample when the same time-series operator was applied to a variable
         used as an instrument and a variable defined in the moment-evaluator
	 program.  For example, specifying {cmd:L}{it:#}{cmd:.z} in the
	 {cmd:instruments()} option and {cmd:L}{it:#}{cmd:.u} in the evaluator
	 program would result in extra observations being dropped.  This has
	 been fixed.

{p 5 9 2}
9.  {helpb import delimited} with option {cmd:varnames(nonames)}, when the
    first line of the text file to be imported contained a missing value
    indicated by "{bf:.}", incorrectly imported the column as a string, even
    if all subsequent values in the columns were numeric or missing.  This
    has been fixed.

{p 4 9 2}
10.  After the 19may2016 update, {helpb irt} commands, when used to fit a
     model where some observations had missing values for all items or when
     specified with option {cmd:listwise}, incorrectly included the
     observations with missing values in {cmd:e(sample)}.  Estimation results
     were not affected, but subsequent commands such as {helpb predict} that
     rely on {cmd:e(sample)} incorrectly included these observations.  This
     has been fixed.

{p 4 9 2}
11.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins}, when used after {helpb xtlogit}, {helpb xtprobit}, and
	 {helpb xtcloglog} had been used to fit the default random-effects
	 model where {it:indepvars} included the same continuous variable
	 multiple times and when that variable was not specified in the
	 {cmd:margins} command, returned estimated margins that set the effect
	 of the variable to 0 in the calculations.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins}, when used after {helpb xtlogit}, {helpb xtprobit}, and
	 {helpb xtcloglog} had been used to fit the default random-effects
	 model where {it:indepvars} included the same continuous variable
	 multiple times and when that variable was specified in the
	 {cmd:margins} command, exited with an uninformative error message.
	 {cmd:margins} now computes the requested marginal effects.

{p 9 13 2}
     c.  {cmd:margins} with {helpb svy} estimation results and the default
	 variance estimation method ({cmd:vce(delta)}) ignored the design
	 degrees of freedom.  This means that confidence intervals were
	 narrower than they should have been and p-values were smaller than
	 they should have been.  This has been fixed.

{p 4 9 2}
12.  Mata function {helpb mf_fputmatrix:fputmatrix()}, when used to write a
     Mata struct that had been previously read by {cmd:fgetmatrix()} and when
     the Mata struct contained a member of type Mata struct, did not write the
     struct to the file.  This has been fixed.

{p 4 9 2}
13.  {helpb arch_postestimation##predict:predict} with option {cmd:het}, after
     fitting a model with {helpb arch}, ignored qualifiers {helpb if} and
     {helpb in}.  This has been fixed.

{p 4 9 2}
14.  {helpb teffects_postestimation##syntax_predict_match:predict} with option
     {cmd:distance}, after fitting a model with {helpb teffects nnmatch} that
     included {help fvvarlist:factor variables} in the outcome model, exited
     with an uninformative error message.  The nearest-neighbor distances are
     now calculated as requested.

{p 4 9 2}
15.  {helpb putexcel} has the following fixes:

{p 9 13 2}
     a.  {cmd:putexcel} with option {cmd:sheet()}, when the specified Excel
         worksheet name included leading or trailing whitespace characters,
         did not write the whitespace characters with the text.  This has been
         fixed.

{p 9 13 2}
     b.  {cmd:putexcel} with option {cmd:sheet()} did not allow commas in an
         Excel worksheet name.  This has been fixed.

{p 9 13 2}
     c.  {cmd:putexcel}, when writing Stata missing values, incorrectly
         overwrote a cell's formatting.  This has been fixed.

{p 4 9 2}
16.  {helpb svy}, when used as a prefix to {helpb etregress} and
     {helpb fracreg}, gave overly conservative standard errors. This has been
     fixed.

{p 4 9 2}
17.   {helpb svy} now defaults to using {cmd:e(V_modelbased)} instead of
      {cmd:e(V)} when {cmd:e(V_modelbased)} is available.  This change is
      being made because using {bf:e(V)} for commands that do not assume that
      the default variance-covariance matrix is independent and identically
      distributed results in overly conservative estimates of the standard
      errors.  The old behavior is not preserved under version control.

{p 4 9 2}
18.  {helpb tsreport} has improved output when the time gaps in the data occur
     in periods where the combined number of digits in the observation numbers
     that identify the gap exceed 11 characters.

{p 4 9 2}
19.  {helpb twoway fpfit} with missing values in {it:yvar} did not always
     produce the same graph when the same command was submitted multiple
     times.  This has been fixed.

{p 4 9 2}
20.  {helpb xtologit} and {helpb xtoprobit} with singleton groups and
     {cmd:pweight}s incorrectly exited with an uninformative error message.
     The commands now fit the model as specified.

{p 4 9 2}
21.  (Mac) Selecting "Replace all in selection" from the Find and Replace bar
     in the Do-file Editor replaced all matching text in the document instead
     of just the matching text in the current selection.  This has been fixed.

{p 4 9 2}
22.  (Unix) After the 20jul2016 update, opening the Data Editor twice in one
     session on a computer with the Ubuntu 16.04.1 LTS distribution caused
     Stata to crash.  This has been fixed.


{hline 8} {hi:update 20jul2016} {hline}

{p 5 9 2}
1.  Stata has been updated to account for the leap second that will be added
    by the International Earth Rotation and Reference Systems Service on
    December 31, 2016.  Stata's datetime/C UTC date format now recognizes
    31dec2016 23:59:60 as a valid time.

{p 5 9 2}
2.  {helpb sem_estat_teffects:estat teffects} did not correctly compute the
    standard errors for total and indirect effects between endogenous
    variables.  This has been fixed.

{p 5 9 2}
3.  {helpb menbreg} with option {cmd:dispersion()} incorrectly exited with
    error message "{err:option {bf:dispersion()} not allowed}".  This has been
    fixed.

{p 5 9 2}
4.  {helpb mixed} with robust standard errors and prefix {helpb by}
    incorrectly exited with an error message.  This has been fixed.

{p 5 9 2}
5.  {helpb nl_postestimation##predict:predict} with option {cmd:yhat}, option
    {cmd:residuals}, or option {cmd:scores} incorrectly exited with an error
    message when used after {helpb nl} with option {cmd:lnsql()}.  This has
    been fixed.

{p 5 9 2}
6.  {helpb statsby} with options {cmd:by()} and {cmd:total}, when specified as
    a prefix for {helpb mixed} with robust standard errors, returned correct
    values of the requested statistics for each by-group but returned
    only missing values when computed using all observations in the dataset.
    This has been fixed.

{p 5 9 2}
7.  {helpb xtreg} with a string variable specified in option
    {cmd:vce(cluster} {it:clustvar}{cmd:)}, when used to fit a fixed-effects
    or random-effects model, incorrectly exited with an error message.  This
    has been fixed.

{p 5 9 2}
8.  After the 06jul2016 update, all user-written commands accessed from the
    {bf:User} menu incorrectly exited with error message
    "{err:too many menus (limit of 1250)}".  This has been fixed.


{hline 8} {hi:update 06jul2016} {hline}

{p 5 9 2}
1.  {helpb odbc load} has new option {cmd:bigintasdouble}, which specifies
    storing database BIGINT columns as Stata type {helpb data types:double}
    when the data are loaded instead of using the default type ({cmd:string}).
    If any integer value is larger than  9,007,199,254,740,965 or less than
    -9,007,199,254,740,992, this conversion is not possible, and {cmd:odbc}
    {cmd:load} will issue an error message.

{p 5 9 2}
2.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 16(2).

{p 5 9 2}
3.  {helpb poisson_postestimation##estatgof:estat gof}, after fitting a
    saturated model with {helpb poisson}, could report a negative deviance
    statistic.  This has been fixed.

{p 5 9 2}
4.  {helpb irf create} after {helpb svar} displayed a dot instead of a red X
    when a bootstrap replication failed.  It now displays a red X for each
    failed replication and exits with an error message if there are
    insufficient observations to compute bootstrap standard errors.

{p 5 9 2}
5.  {helpb ivprobit} with options {opt first} and {opt twostep} did not
    display the linear regressions for the endogenous covariates.  This has
    been fixed.

{p 5 9 2}
6.  {helpb margins} with results from {cmd:svy: meologit} or
    {cmd:svy: meoprobit} incorrectly exited with error message
    "{err:conformability error}".  This has been fixed.

{p 5 9 2}
7.  Mata function {helpb mf_fgetmatrix:fgetmatrix()} did not read a Mata class
    or struct that contained a member of transmorphic type and nonreal
    contents.  This has been fixed.

{p 5 9 2}
8.  {helpb ml} with option {opt group()} and the default variance estimation
    method calculated the correct standard errors but incorrectly reported
    that the standard errors were adjusted for clustering.  This has been
    fixed.

{p 5 9 2}
9.  {helpb nlsur} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, when
    {it:clustvar} did not vary within the estimation sample, incorrectly
    exited with error message
    "{err:estimates repost: matrix has missing values}".  This has been fixed.

{p 4 9 2}
10.  {helpb predict}, after factor variables with operator {cmd:bn.} (no base)
     were specified in {helpb gsem_command:gsem}, {helpb meglm},
     {helpb melogit}, {helpb meprobit}, {helpb mecloglog}, {helpb meologit},
     {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg}, {helpb mestreg},
     {helpb xtologit}, or {helpb xtoprobit}, computed predictions as if the
     coefficients for the first levels of those factor variables were zero
     instead of the estimated values.  This has been fixed.

{p 4 9 2}
11.  {helpb regress} with a constant factor variable and {cmd:pweight}s or
     {cmd:aweight}s could fail to omit the constant factor variable.  This has
     been fixed.

{p 4 9 2}
12.  {helpb tabstat} with option {opt varwidth()} now displays longer variable
     names in the stub of the table when statistics are displayed in the table
     columns.  The maximum length is now the maximum name length in Stata,
     {ccl namelen}, instead of 16 characters.

{p 4 9 2}
13.  {helpb unicode translate} and {helpb unicode translate:unicode analyze},
     when the specified Stata dataset contained value-label contents that were
     blank, did not process the dataset.  This has been fixed.

{p 4 9 2}
14.  {helpb xtivreg} has the following fixes:

{p 9 13 2}
     a.  {cmd:xtivreg}, when used to fit the default random-effects model and
         with options {cmd:first} and {cmd:small}, reported normal (Z) and
         chi-squared statistics instead of small-sample t and F statistics for
         the first-stage regression.  This has been fixed.

{p 9 13 2}
     b.  {cmd:xtivreg}, when used to fit a fixed-effects model and with
         option {cmd:first} and either option {cmd:vce(robust)} or option
         {cmd:vce(cluster} {it:clustvar}{cmd:)}, reported standard errors from
         {cmd:areg} in the first stage.  {cmd:xtivreg, fe} now reports
         standard errors from {cmd:xtreg, fe} in the first stage.

{p 4 9 2}
15.  {helpb xtreg} with option {cmd:vce(cluster} {it:clustvar}{cmd:)} and
     either default option {opt re} or option {opt fe}, when a string variable
     was specified as {it:clustvar}, incorrectly exited with error message
     "{err:type mismatch}".  This has been fixed.

{p 4 9 2}
16.  After the 28 Jan 2016 update, when a custom font was embedded in a graph
     exported to a Postscript file, text was displayed incorrectly in
     Postscript renderers.  This has been fixed.

{p 4 9 2}
17.  (Unix GUI) For Ubuntu 14.04 users, the xstata {bf:Data} menu was disabled
     after opening the Data Editor.  This has been fixed.


{hline 8} {hi:update 19may2016} {hline}

{p 5 9 2}
1.  A new family of functions computes probabilities and other quantities of
the inverse Gaussian distribution.

{p 9 9 2}
    {help igaussian():{bf:igaussian(}{it:m}{bf:,}{it:a}{bf:,}{it:x}{bf:)}}
    computes the cumulative distribution function (CDF) of the inverse
    Gaussian distribution with mean {it:m} and shape {it:a}.

{p 9 9 2}
    {help igaussianden():{bf:igaussianden(}{it:m}{bf:,}{it:a}{bf:,}{it:x}{bf:)}}
    computes the density of the inverse Gaussian distribution with mean {it:m}
    and shape {it:a}.

{p 9 9 2}
    {help igaussiantail():{bf:igaussiantail(}{it:m}{bf:,}{it:a}{bf:,}{it:x}{bf:)}}
    computes the reverse CDF of the inverse Gaussian distribution with mean
    {it:m} and shape {it:a}.

{p 9 9 2}
    {help invigaussian():{bf:invigaussian(}{it:m}{bf:,}{it:a}{bf:,}{it:p}{bf:)}}
    computes the inverse CDF of the inverse Gaussian distribution: if
    {opt igaussian(m,a,x)} = {it:p}, then {opt invigaussian(m,a,p)} = {it:x}.

{p 9 9 2}
    {help invigaussiantail():{bf:invigaussiantail(}{it:m}{bf:,}{it:a}{bf:,}{it:p}{bf:)}}
    computes the inverse reverse CDF of the inverse Gaussian distribution:  if
    {opt igaussiantail(m,a,x)} = {it:p}, then {opt invigaussiantail(m,a,p)} =
    {it:x}.

{p 9 9 2}
    {help lnigaussianden():{bf:lnigaussianden(}{it:m}{bf:,}{it:a}{bf:,}{it:x}{bf:)}}
    computes the natural logarithm of the density of the inverse Gaussian
    distribution with mean {it:m} and shape {it:a}.

{p 9 9 2}
    {help rigaussian():{bf:rigaussian(}{it:m}{bf:,}{it:a}{bf:)}} computes
    inverse Gaussian variates with mean {it:m} and shape {it:a}.

{p 5 9 2}
2.  {helpb gmm} and {helpb ivregress} now allow an optional tuning parameter
    that affects the number of lags selected by Newey and West's (1994)
    optimal lag-selection algorithm.  To specify the tuning parameter, use
    option {cmd:wmatrix(hac} {it:kernel} {cmd:opt} [{it:#}]{cmd:)} or option
    {cmd:vce(hac} {it:kernel} {cmd:opt} [{it:#}]{cmd:)}.

{p 5 9 2}
3.  {helpb bayesmh} has new option {opt initrandom} to randomly initialize
    model parameters.  This option is useful for initializing multiple Markov
    chain Monte Carlo chains with different starting values.  When parameters
    cannot be randomly initialized, such as with user-defined prior
    distributions, {opt initrandom} can be combined with option
    {opt initial()}, which assigns fixed starting values to selected model
    parameters.

{p 5 9 2}
4.  {helpb irt} commands are now faster for models that have many observations
    and few items.

{p 5 9 2}
5.  {helpb roctab} is now faster.

{p 5 9 2}
6.  {helpb tab1} now allows {cmd:aweight}s and {cmd:iweight}s.

{p 5 9 2}
7.  New Mata class {helpb mf_associativearray:AssociativeArray()}
    provides an interface into {helpb mf_asarray:asarray()}.

{p 5 9 2}
8.  Mata structure scalars may now be used in an interactive Mata session.

{p 5 9 2}
9.  New Mata function {helpb mf_eltype:classname()} returns the class name of
    a Mata class scalar.

{p 4 9 2}
10.  New Mata function {helpb mf_eltype:structname()} returns the structure
     name of a Mata structure scalar.

{p 4 9 2}
11.  Mata functions {helpb mf_fopen:fputmatrix()} and
     {helpb mf_fopen:fgetmatrix()} now allow you to save and read Mata class
     matrices in addition to string, numeric, and pointer matrices.

{p 4 9 2}
12.  {helpb include} has new option {opt adopath}, which searches Stata's
     system directories for the specified file if the file is not found at the
     default location.

{p 4 9 2}
13.  {helpb areg}, when the model included an interaction between a single
     specified level of a factor variable and a continuous variable, omitted
     the main effect for the factor variable. This has been fixed.

{p 4 9 2}
14.  {helpb asclogit} with alternative-specific covariates used better
     starting values in Stata 13, meaning that the model converged quicker
     (required fewer iterations).  Stata 14 now uses the Stata 13 starting
     values.

{p 4 9 2}
15.  {helpb churdle} and {helpb fracreg}, when used to fit a model that
     included {help fvvarlist:factor variables}, reported the correct model
     chi-squared statistic but with incorrect degrees of freedom.  The
     degrees of freedom was too large because of the inclusion of the base
     levels of the factor variables, resulting in a conservative model test.
     This has been fixed.

{p 9 9 2}
     Note: It is unlikely that inference about the overall model significance
     test will change except in cases with small values of the model
     chi-squared statistic.

{p 4 9 2}
16.  {helpb ci:cii means} with option {opt poisson}, in the unusual case that
     the confidence level was set to 99.06 or higher, and with exactly one
     event, did not return results or exit until the {it:Break} key was
     pressed. This has been fixed.

{p 4 9 2}
17.  {helpb estimates table}, when used after {helpb bayesmh} to display
     stored results that were not obtained using {cmd:bayesmh}, incorrectly
     exited with error message
     "{err:estimates table not allowed after bayesmh}".  This has been fixed.

{p 4 9 2}
18.  {helpb glm} and {helpb poisson} with {cmd:iweight}s, when the weights
     contained negative values, incorrectly exited with error message
     "{err:negative weights encountered}".  This has been fixed.

{p 4 9 2}
19.  {helpb infile2:infile}, when used with a dictionary file that specified
     more variables than the current {helpb maxvar} setting allowed, caused
     Stata to crash.  This has been fixed.

{p 4 9 2}
20.  {helpb ivregress 2sls} with options {cmd:first} and
     {cmd:vce(cluster} {it:clustvar}{cmd:)} did not scale the first-stage
     standard errors properly.  This was a reporting error, and calculations
     for the full model and related inference were unaffected.  This has been
     fixed.

{p 4 9 2}
21.  {helpb margins}, when used with estimation results that have a single
     predictor variable {it:xvar} and with option
     {cmd:at(}{it:xvar}{cmd:=generate(}{it:exp}{cmd:))}, used only the first
     observation instead of the entire estimation sample.  This has been
     fixed.

{p 4 9 2}
22.  Mata function {helpb mf_asarray:asarray_remove()} could fail when the key
     dimension for the associative array was greater than 1.  This has been
     fixed.

{p 4 9 2}
23.  Mata function {helpb mf_st_subview:st_subview()}, when the first argument
     was the same as the second argument, could cause Stata to crash.  This
     has been fixed.

{p 4 9 2}
24.  {helpb mi impute} with a
     {help mi_impute_usermethod:user-defined imputation method} and
     option {opt replace}, when used with data declared in {cmd:flong} or
     {cmd:mlong} style, exited with an error.  In style {cmd:flong}, it exited
     with error message "{err:no observations}".  In style {cmd:mlong}, it
     exited with error message "{err:missing imputed values produced}".  This
     has been fixed.

{p 4 9 2}
25.  {helpb mi reshape} with option {cmd:string} did not properly register
     imputed, passive, and regular variables.  In style {cmd:mlong}, when the
     reshaped variables included imputed variables, and in style {cmd:wide},
     when the reshaped variables included imputed or passive variables,
     imputed data were lost for the reshaped variables.  This has been fixed.

{p 4 9 2}
26.  {helpb mixed}, when the model contained a lagged variable and when
     {cmd:vce(robust)}, {cmd:vce(cluster} {it:clustvar}{cmd:)}, or probability
     weights were specified, incorrectly exited with error message
     "{err:error obtaining scores for robust variance}".  This has been fixed.

{p 4 9 2}
27.  {helpb nlogit} ignored option {cmd:collinear} when checking collinearity
     among variables specified at different levels of the hierarchy.  This has
     been fixed.

{p 4 9 2}
28.  {helpb reg3} is documented to support
     {help tsvarlist:time-series operators} in options {cmd:exog()},
     {cmd:endog()}, and {cmd:inst()}.  However, the command exited with error
     message "{err:time-series operators not allowed}" when a time-series
     operator was used.  This has been fixed.

{p 4 9 2}
29.  {help f_strmatch:{bf:strmatch(}{it:s1}{bf:,}{it:s2}{bf:)}} treated
     "{cmd:*}" as a literal instead of as a wildcard character if it was in
     the same position in string {it:s1} and pattern {it:s2}.  For example,
     {cmd:strmatch("ab*c", "ab*")} returned 0 (not matched) instead of 1
     (matched).  This has been fixed.

{p 4 9 2}
30.  The {helpb stteffects} commands, when used with data that were previously
     {helpb stset} with options {opt enter()} and {opt exit()}, which are
     disallowed by {cmd:stteffects}, exited with an error message after
     {cmd:stset} was resubmitted with an allowed specification.  This has been
     fixed.

{p 4 9 2}
31.  {helpb svyset}, when the same sampling weight variable specified as a
     {cmd:pweight} or an {cmd:iweight} is included in the varlist specified
     with option {opt brrweight()}, {opt jkrweight()}, {opt bsrweight()}, or
     {opt sdrweight()}, now exits with an error message.

{p 4 9 2}
32.  {helpb test} and {helpb testparm}, used to test hypotheses for
     {helpb margins} estimation results computed following a
     {help svy estimation:survey estimation} command with bootstrap or
     successive difference replicate standard errors, reported a missing
     F statistic instead of an unadjusted chi-squared statistic.  This
     has been fixed.

{p 4 9 2}
33.  {helpb xtgee} with option {opt nmp}, when one or more {it:indepvars} were
     omitted because of collinearity, overestimated the standard errors,
     leading to conservative estimates of the reported z statistics and
     p-values.  This has been fixed.

{p 4 9 2}
34.  {helpb xtlogit} and {helpb xtprobit} with option {cmd:vce(robust)} or
     option {cmd:vce(cluster} {it:panelvar}{cmd:)}, when any of the
     variables in the model were specified with a
     {help tsvarlist:time-series operator}, incorrectly exited with error
     message "{err:calculation of robust standard errors failed}".  This has
     been fixed.

{p 4 9 2}
35.  {helpb zip} and {helpb zinb} with option {cmd:inflate(_cons)} and either
     {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} exited with error message
     "{red:variable _cons not found}".  This has been fixed.

{p 4 9 2}
36.  In the Results window, copying a table with spaces before the horizontal
     separators resulted in the table being copied as is instead of in a
     delimited format that could be pasted into another application.  This has
     been fixed.

{p 4 9 2}
37.  (Windows) In the Command window, selecting "Undo" from the contextual
     menu did not undo the last edit.  This has been fixed.


{hline 8} {hi:update 30mar2016} {hline}

{p 5 9 2}
1.  {helpb pcorr} now supports {help fvvarlist:factor variables}.

{p 5 9 2}
2.  {helpb roccomp} is now faster.

{p 5 9 2}
3.  {helpb stcox postestimation##estatcon:estat concordance} after
    {helpb stcox} is now faster.

{p 5 9 2}
4.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 16(1).

{p 5 9 2}
5.  {helpb betareg} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, when a
    string variable was specified as {it:clustvar}, incorrectly exited
    with error message "{err:no observations}".  This has been fixed.

{p 5 9 2}
6.  {helpb bayesmh} has the following fixes:

{p 9 13 2}
     a.  Suboption {cmd:noglmtransform} of {cmd:bayesmh}'s option
         {cmd:likelihood()}, which was used to fit the exponential, binomial,
         and Poisson distributions to the outcome variable, is now
         undocumented.  Instead, use
         {help bayesmh##distribution:probability distributions}
         {cmd:dexponential()}, {cmd:dbernoulli()}, {cmd:dbinomial()}, and
         {cmd:dpoisson()} within option {cmd:likelihood()} to fit the
         corresponding distribution to the data.

{p 9 13 2}
     b.  {cmd:bayesmh}, when used on replay, did not recalculate the deviation
	 information criterion (DIC) statistics and stored missing values in
	 {cmd:e(dic)}.  As a result, {helpb bayesstats ic} reported missing
	 DIC values.  This has been fixed.

{p 5 9 2}
7.  {helpb dstdize} with option {opt using()}, when the using dataset did not
    explicitly contain the {bf:.dta} extension and {cmd:using()} was specified
    as a relative path that contained a dot, exited with error message
    "{err:file ... not found}".  This has been fixed.

{p 5 9 2}
8.  {helpb duplicates:duplicates drop}, when specified with a varlist
    that included a variable that did not exist in the dataset, incorrectly
    exited with error message "{err:varlist not allowed}".
    {cmd:duplicates drop} now exits with error message
    "{err:variable ... not found}".

{p 5 9 2}
9.  {helpb eteffects} with {cmd:pweight}s incorrectly exited with error
    message "{err:{bf:pweights} not allowed}".  This has been fixed.

{p 4 9 2}
10.  {helpb fracreg} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, when
     {it:clustvar} was included in an {helpb if} or {helpb in} condition,
     reported the wrong number of clusters and incorrect standard errors.
     This has been fixed.

{p 4 9 2}
11.  {helpb heckprobit} with option {cmd:vce(opg)} used the
     default observed information matrix (OIM) standard errors instead
     of the requested outer product of the gradient vectors (OPG)
     standard errors.  This has been fixed.

{p 4 9 2}
12.  {helpb icd9:icd9 search} and {helpb icd9:icd9p search}, when
     {helpb set varabbrev} had been set to {cmd:off}, incorrectly exited with
     error message "{err:__desc not found}".  This has been fixed.

{p 4 9 2}
13.  {helpb irt grm}, {helpb irt nrm}, {helpb irt pcm}, {helpb irt gpcm}, and
     {helpb irt rsm} incorrectly accepted items with noninteger values.  The
     estimates from these {cmd:irt} commands were still correct.  However, the
     inclusion of noninteger values caused {helpb irtgraph} commands to exit
     with an error.  These {cmd:irt} commands now exit with error message
     "{err:item ... contains noninteger values}".

{p 4 9 2}
14.  {helpb table}, when option {cmd:contents()} contained a string variable,
     exited with an uninformative error message.  {cmd:table} now exits with
     error message "{err:'...' found where numeric variable expected}".

{p 4 9 2}
15.  {helpb tssmooth dexponential}, despite reporting the correct statistics,
     did not save the correct root mean squared error in {cmd:r(rmse)} or the
     correct sum of squared residuals in {cmd:r(rss)}.  This has been fixed.

{p 4 9 2}
16.  {helpb xtdpd} with option {cmd:vce(robust)}, in the unusual case in which
     the model included no lags of the dependent variable and the dependent
     variable had a missing value, incorrectly exited with error message
     "{err:estimates post: matrix has missing values}".  This has been fixed.

{p 4 9 2}
17.  {helpb xtlogit}, {helpb xtprobit}, {helpb xtcloglog}, and
     {helpb xtpoisson:xtpoisson, normal} with default option {cmd:re} have the
     following fixes:

{p 9 13 2}
     a.  {cmd:xtlogit}, {cmd:xtprobit}, {cmd:xtcloglog}, and {cmd:xtpoisson},
         when option {cmd:vce(oim)} was specified instead of being left as the
         unspecified default, incorrectly reported robust standard errors
         instead of the requested OIM standard errors.  This has been fixed.

{p 9 13 2}
     b.  {cmd:xtlogit}, {cmd:xtprobit}, {cmd:xtcloglog}, and {cmd:xtpoisson},
	 when constraints were specified with option {cmd:noconstant} and
	 either option {cmd:vce(robust)} or option
	 {cmd:vce(cluster} {it:clustvar}{cmd:)}, did not apply the constraints
	 when calculating robust standard errors.  This has been fixed.

{p 4 9 2}
18.  (Windows) {helpb estimates save} did not open files with UNC paths
     (network paths beginning with \\) and returned error message
     "{err:file {it:filename} could not be opened}".  This has been fixed.

{p 4 9 2}
19.  (Windows) {helpb estimates use} did not open files with UNC paths
     (network paths beginning with \\) and returned error message
     "{err:file {it:filename} not found}".  This has been fixed.


{hline 8} {hi:update 03mar2016} {hline}

{p 5 9 2}
1.  {helpb icd10 check}, {helpb icd10 lookup}, and {helpb icd10 generate} with
    option {cmd:description} have a new default year of 2016, which
    corresponds to the World Health Organization's Version 5. Results using
    previous ICD-10 codes may be obtained by specifying option
    {cmd:year(}{it:#}{cmd:)}.  Any year value from 2003 to 2016 is allowed.

{p 5 9 2}
2.  Stata/MP performance has improved, often dramatically, for the following
    commands: {helpb gsem_command:gsem}, {helpb irt}, {helpb meglm},
    {helpb melogit}, {helpb meprobit}, {helpb mecloglog}, {helpb meologit},
    {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg}, {helpb mestreg},
    {helpb xtologit}, {helpb xtoprobit}, and {helpb xtstreg}.

{p 5 9 2}
3.  {helpb cc}, {helpb cs}, and {helpb ir} now store the reported crude and
    pooled estimates from a stratified analysis, along with the upper and
    lower bounds from the confidence intervals.  The new stored results are
    {cmd:r(crude)}, {cmd:r(lb_crude)}, {cmd:r(ub_crude)}, {cmd:r(pooled)},
    {cmd:r(lb_pooled)}, and {cmd:r(ub_pooled)}.

{p 5 9 2}
4.  {helpb churdle} with a string variable specified in option
    {cmd:vce(cluster} {it:clustvar}{cmd:)} reported missing standard errors.
    This has been fixed.

{p 5 9 2}
5.  {helpb correlate}, when {it:{help varlist}} contained a string variable,
    incorrectly exited with error message "{err:no observations}".  This has
    been fixed.

{p 5 9 2}
6.  {helpb egen} with function {cmd:count(}{it:exp}{cmd:)} incorrectly exited
    with error message "{err:type mismatch}" when {it:exp} contained a string
    variable.  This has been fixed.

{p 5 9 2}
7.  {helpb fracreg} with a string variable specified in option
    {cmd:vce(cluster} {it:clustvar}{cmd:)} reported missing standard errors.
    This has been fixed.

{p 5 9 2}
8.  {helpb ivregress postestimation##syntax_estat:estat overid}, used after
    fitting a model with {helpb ivregress} that contained factor variables in
    the set of endogenous variables and with option {cmd:vce(robust)}
    specified, incorrectly exited with error message
    "{err:depvar may not be a factor variable}".  This has been fixed.

{p 5 9 2}
9.  {helpb graph export}, when exporting as a PDF file a
    {help graph pie:pie graph} that had the angle of the first slice set to a
    value other than the default 90 degrees, displayed the slice in wrong
    position in the PDF file.  This has been fixed.

{p 4 9 2}
10.  {helpb import delimited} incorrectly imported string values of the form
     #f or #F as numeric values.  For example, 12345F was imported as 12345
     instead of as a string containing 12345F.  This has been fixed.

{p 4 9 2}
11.  {helpb include} has new option {cmd:system}, which searches Stata's
     system directories for the specified file if the file is not found at the
     default location.

{p 4 9 2}
12.  {helpb loneway} with {cmd:aweight}s, when the response variable or group
     variable contained missing values or when qualifier {helpb if} or
     {helpb in} was specified, could report incorrect estimates of the
     intraclass correlation and the standard deviation of the group effect.
     If an entire group comprised observations to be omitted, the results
     were affected.  In other cases, whether incorrect results were reported
     depended on an internal sort.  This has been fixed.

{p 4 9 2}
13.  {helpb mgarch ccc}, {helpb mgarch dcc}, and {helpb mgarch vcc} have the
     following fixes:

{p 9 13 2}
     a.  {cmd:mgarch ccc}, {cmd:mgarch dcc}, and {cmd:mgarch vcc}, when lagged
         variables were specified as {it:indepvars} or in option
         {cmd:het(}{it:varlist}{cmd:)}, stored an incorrect minimum time in
         sample in {cmd:e(tmin)} and an incorrect formatted minimum time in
         {cmd:e(tmins)}.  This has been fixed.

{p 9 13 2}
     b.  {cmd:mgarch ccc}, {cmd:mgarch dcc}, and {cmd:mgarch vcc}, when used
         after {helpb tsappend}, stored an incorrect maximum time in sample in
         {cmd:e(tmax)} and an incorrect formatted maximum time in
         {cmd:e(tmaxs)}.  This has been fixed.

{p 4 9 2}
14.  {helpb plugin} function {cmd:SF_mat_store()}, when changing the value of
     element [i,j] of a symmetric matrix, also changed the value of element
     [j,i].  This has been fixed for plugins written using version 3.0 of the
     plugin interface.  Plugins written using version 2.0 of the plugin
     interface will continue to work as they did before.

{p 4 9 2}
15.  {helpb post} no longer requires the maximum number of bytes to hold an
     observation to be less than 32,767.

{p 4 9 2}
16.  {cmd:predict} with option {cmd:dynamic()}, when the data were
     {helpb tsset} using a
     {help datetime_business_calendars:business calendar} and used to make
     predictions after {helpb dfactor}, {helpb mgarch}, {helpb mswitch}, and
     {helpb sspace}, incorrectly exited with error message
     "{err:invalid syntax}".  This has been fixed.

{p 4 9 2}
17.  {helpb pca_postestimation##predict:predict} after {cmd:pca} is documented
     to accept {cmd:stub}{cmd:*} notation when no statistic is specified.
     Instead, {cmd:predict} exited with error message "{err:invalid name}".
     The command now works as documented.

{p 4 9 2}
18.  {helpb tsset} and {helpb xtset}, in the unusual case when there was only
     one observation in the dataset, incorrectly exited with error message
     "{err:observation numbers out of range}".  This has been fixed.

{p 4 9 2}
19.  {helpb unicode translate} could corrupt datasets that could not be opened
     in the current session.  For example, a dataset that could not be opened
     because it had more variables than the current {cmd:maxvar} setting may
     have become corrupted.  {cmd:unicode translate} now ignores files with
     the {cmd:.dta} extension that cannot be opened in the current session.

{p 4 9 2}
20.  {helpb xtreg}, {helpb xtivreg}, {helpb xthtaylor}, {helpb xtlogit},
     {helpb xtprobit}, {helpb xtcloglog}, {helpb xtologit}, {helpb xtoprobit},
     {helpb xtpoisson}, {helpb xtstreg}, and {helpb gmm}, when specified with
     qualifier {helpb if} or {helpb in} and with option
     {cmd:vce(cluster} {it:clustvar}{cmd:)} and when the panels were
     not nested in clusters in the full data but were nested in clusters after
     applying the qualifier, incorrectly exited with error message
     "{err:panels are not nested within clusters}".  This has been fixed.

{p 4 9 2}
21.  {helpb xttobit}, when specified without an independent variable,
     incorrectly exited with error message "{err:invalid syntax}".  This has
     been fixed.

{p 4 9 2}
22.  {helpb zinb}, with a {help fvvarlists:factor-variables operator} on the
     first variable in option {cmd:inflate()} and option {cmd:vce(bootstrap)}
     or {cmd:vce(jackknife)}, incorrectly exited with error message
     "{err:depvar may not be a factor variable}".  This has been fixed.

{p 4 9 2}
23.  The Data Editor did not allow variables that were formatted using a
     {help datetime_business_calendars:business calendar} format
     ({cmd:%tb}{it:calname}) to be edited with values that also had a business
     calendar format.  This has been fixed.

{p 4 9 2}
24.  (Windows only) {helpb graph export}, when used to export a graph to EPS
     or PS format, could cause Stata to crash if the {cmd:fontface} setting
     for EPS or PS was changed from the default value of Helvetica.  This has
     been fixed.

{p 4 9 2}
25.  (Mac and Unix) Windows-only setting {helpb set autotabgraphs} no longer
     returns error message "{err:unrecognized command}" when used on Mac and
     Unix platforms.  Instead, a note is displayed.  This prevents do-files
     written by users with Stata for Windows from exiting with an unnecessary
     error message when shared with users with Stata for Mac or Stata for
     Unix.


{hline 8} {hi:update 16feb2016} {hline}

{p 5 9 2}
1.  {helpb bayesmh} has new {cmd:likelihood()} specifications
    {cmd:dexponential()}, {cmd:dbernoulli()}, {cmd:dbinomial()}, and
    {cmd:dpoisson()} that allow you to more conveniently fit exponential,
    Bernoulli, binomial, and Poisson distributions to data.  Previously, these
    distributions could be fit using {cmd:likelihood()} specifications
    {cmd:exponential}, {cmd:binlogit}, and {cmd:poisson} with suboption
    {cmd:noglmtransform}.

{p 5 9 2}
2.  {helpb bayesmh} has new {cmd:likelihood()} specification {cmd:binomial()}
    that is a synonym for the existing {cmd:likelihood()} specification
    {cmd:binlogit()} for fitting a binomial regression with a logit link.

{p 5 9 2}
3.  {helpb bayestest interval}, when used with a probability label longer than
    31 characters, incorrectly displayed the label in the legend and exited
    with an uninformative error message.  This has been fixed.

{p 5 9 2}
4.  {helpb cii means} with option {cmd:poisson} did not allow noninteger
    exposure values.  This has been fixed.

{p 5 9 2}
5.  {helpb gsem_command:gsem}, {helpb meglm}, {helpb melogit},
    {helpb meprobit}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb menbreg}, and {helpb mestreg}, when used to fit a model with three
    or more levels and with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, did
    not exit with error message
    "{err}highest-level groups are not nested with {it:clustvar}{reset}" when
    the groups defined by the highest level of the model specification were
    not nested within the clusters defined by {it:clustvar}.  This has been
    fixed.

{p 5 9 2}
6.  {helpb gsem_command:gsem}, {helpb meglm}, {helpb melogit},
    {helpb meprobit}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb menbreg}, and {helpb mestreg}, when used to fit a model with three
    or more levels and with prefix {helpb svy}, did not exit with error
    message "{err}hierarchical groups are not nested within ...{reset}" when
    the groups defined by the multilevel model specification were not nested
    within the {helpb svyset} sampling units.  This has been fixed.

{p 5 9 2}
7.  {helpb mprobit}, when specified without independent variables, incorrectly
    exited with error message "{err:varlist required}".  This has been fixed.

{p 5 9 2}
8.  {helpb mestreg_postestimation##predict:predict, median}, after
    {helpb mestreg} was used to fit a model with family {cmd:weibull},
    {cmd:exponential}, {cmd:lognormal}, or {cmd:loglogistic}, ignored the
    random-effects portion of the model when generating the predictions.  This
    has been fixed.


{hline 8} {hi:update 01feb2016} {hline}

{p 5 9 2}
1.  (Mac) After the 28jan2016 update, the Data Editor's toolbar and menu were
    disabled.  This has been fixed.


{hline 8} {hi:update 28jan2016} {hline}

{p 5 9 2}
1.  {helpb bayesmh}, when initial values for scalar model parameters were
    specified in options {cmd:likelihood()} and {cmd:prior()} during parameter
    declaration, incorrectly exited with a syntax error.  This has been fixed.

{p 5 9 2}
2.  {helpb sem_estat_residuals:estat residuals} and
    {helpb sem_estat_teffects:estat teffects}, when used after
    {helpb sem_command:sem} with option {cmd:technique(bhhh)}, incorrectly
    exited with an uninformative error message.  This has been fixed.

{p 5 9 2}
3.  {helpb estat sbsingle}, for certain combinations of the number of
    observations in the dataset and the number of covariates in the model,
    incorrectly exited with error message
    "{err:insufficient observations at the specified trim level}" when there
    were enough observations to compute the test statistic.  This has been
    fixed.

{p 5 9 2}
4.  {helpb sem_estat_teffects:estat teffects} after {helpb sem_command:sem}
    did not show indirect effects when they were composed of more than six
    paths between the variables.  This has been fixed.

{p 5 9 2}
5.  Factor variables with an {helpb fvset:fvset base} of {cmd:first},
    {cmd:frequent}, or {cmd:last} incorrectly resulted in all single-level
    specifications being treated as a base level.  For example, for the
    0/1-valued variable {cmd:foreign}, typing

		{cmd:. sysuse auto}
		{cmd:. fvset base last foreign}
		{cmd:. regress mpg 1.foreign}

{p 9 9 2}
    resulted in {cmd:1.foreign} being treated as the base level and omitted
    from the model.  Similarly, single-level specifications with the
    base-level operators {cmd:b(first)}, {cmd:b(frequent)}, or {cmd:b(last)}
    were also treated as a base level.  The correct behavior is for
    single-level specifications to ignore the base-level setting or
    specification.  This has been fixed.

{p 5 9 2}
6.  Stata reported an uninformative error message when
    {help fvvarlist:factor-variable interaction notation} ({cmd:#} or
    {cmd:##}) was used with two different
    {help tsvarlist:time-series operators} applied to the same factor variable
    within the interaction term.  This has been fixed.

{p 5 9 2}
7.  {helpb graph export} has the following fixes:

{p 9 13 2}
     a.  {cmd:graph export}, when exporting a graph that contained text with a
	 font size of 0 to EPS format, produced an EPS file that was
	 unreadable by other applications.  When {cmd:graph export} encounters
	 text of size 0, it no longer exports that text when writing to an EPS
	 file.

{p 9 13 2}
     b.  {cmd:graph export}, when exporting an SEM or a GSEM path diagram that
         included a B{c e'}zier Curve to a PDF file, incorrectly exited with
         error message "{err:unable to save PDF file}".  This has been fixed.

{p 5 9 2}
8.  {helpb icc} now allows the target and rater variables to have a string
    {help data_types:storage type}.

{p 5 9 2}
9.  After the 29oct2015 update, {helpb ivprobit} with option
    {cmd:vce(cluster} {it:clustvar}{cmd:)} and {cmd:pweight}s incorrectly
    exited with error message
    "{err:option {bf:vce(cluster)} not allowed with probability weights}".
    This has been fixed.

{p 4 9 2}
10.  {helpb ivregress 2sls} with options {cmd:first} and {cmd:vce(cluster}
     {it:clustvar}{cmd:)}, when the data were not sorted by {it:clustvar},
     reported incorrect standard errors and an incorrect number of clusters
     for the first-stage model results only.  This was a reporting error, and
     calculations for the full model were unaffected.  This has been fixed.

{p 4 9 2}
11.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {cmd:predict(fixedonly ...)}, in the
         unusual case when predictions were made after one of the multilevel
         commands, {helpb gsem_command:gsem}, {helpb meglm}, {helpb melogit},
         {helpb meprobit}, {helpb meologit}, {helpb meoprobit},
         {helpb mepoisson}, {helpb menbreg}, or {helpb mestreg}, when the
         fitted model had a very small estimated value for a variance
         component (less than 1e-30), incorrectly exited with error message
         "{err:could not calculate numerical derivatives --}
         {err:discontinuous region with missing values encountered}" even
         when the prediction was not a function of the variance component.
         This has been fixed.

{p 9 13 2}
     b.  {cmd:margins}, when {helpb set varabbrev:set varabbrev off} was in
	 effect, incorrectly allowed variable abbreviations within option
	 {cmd:at()}.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins} after {helpb svy estimation:svy: logit},
         {helpb svy estimation:svy: logistic}, or
         {helpb svy estimation:svy: probit}, when a subpopulation had been
         specified in option {cmd:subpop()} and with perfect predictors and
         when using {cmd:bootstrap} or {cmd:jackknife} variance estimates,
         incorrectly reported some marginal predictions as not estimable.
         This has been fixed.

{p 4 9 2}
12.  {helpb margins} after {helpb xtprobit_post##margins:xtprobit},
     {helpb xtlogit_post##margins:xtlogit}, and
     {helpb xtcloglog_post##margins:xtcloglog} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with option {cmd:at(}{it:atspec}{cmd:)} incorrectly
         computed margins at mean values even when other values were requested
         for {it:atspec}.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} with option {cmd:atmeans} incorrectly exited with
         error message "{err:insufficient observations}".  This has been
         fixed.

{p 4 9 2}
13.  Mata functions {helpb mf__docx:_docx_add_data()},
     {helpb mf__docx:_docx_add_mata()}, and
     {helpb mf__docx:_docx_add_matrix()} inserted an empty line before the
     content in each cell when creating a table in a Microsoft {cmd:.docx}
     file.  This line is no longer inserted.  The old behavior is not
     preserved under version control.

{p 4 9 2}
14.  Mata function {helpb mf__docx:_docx_table_mod_cell_table()}, when
     argument {it:append} was specified as a value other than 0, incorrectly
     replaced the current contents of the cell instead of appending to the
     contents as requested.  This has been fixed.

{p 4 9 2}
15.  The multilevel mixed-effects estimators {helpb gsem_command:gsem},
     {helpb meglm}, {helpb melogit}, {helpb meprobit}, {helpb meologit},
     {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg}, and
     {helpb mestreg} have the following improvement and fix:

{p 9 13 2}
     a.  {cmd:gsem}, {cmd:meglm}, {cmd:melogit}, {cmd:meprobit},
         {cmd:meologit}, {cmd:meoprobit}, {cmd:mepoisson}, {cmd:menbreg}, and
         {cmd:mestreg} are now more likely to converge for models fit to data
         with large group sizes.

{p 9 13 2}
     b.  {cmd:gsem}, {cmd:meglm}, {cmd:melogit}, {cmd:meprobit},
         {cmd:meologit}, {cmd:meoprobit}, {cmd:mepoisson}, {cmd:menbreg}, and
         {cmd:mestreg}, when used with datasets that had many observations per
         group, could indicate that the model converged and report results
         that did not include the large groups in the computations.  To
         determine whether your model was affected, you can use {cmd:predict}
         to obtain empirical Bayes mean estimates for the random effects and
         check for zero values in large groups.  This has been fixed.

{p 4 9 2}
16.  {help Plugin} functions {cmd:SF_var_is_string()} and
     {cmd:SF_var_is_strl()} returned results for the ith variable of the
     dataset rather than the ith variable of the {varlist}.  This has
     been fixed.

{p 4 9 2}
17.  {helpb gsem_predict:predict}, when used to compute predictions that
     require empirical Bayes estimates after {helpb gsem_command:gsem}, could
     exit with an uninformative error message if an interaction term in the
     call to {cmd:gsem} was specified with a single level (or strict subset of
     the levels) of a factor variable.  This has been fixed.

{p 4 9 2}
18.  {helpb predict} after {helpb regress}, {helpb tobit}, {helpb intreg},
     {helpb ivregress}, {helpb ivtobit}, {helpb xttobit}, {helpb xtintreg},
     {helpb truncreg}, {helpb heckman}, and {helpb nl} has the following
     improvement and fix:

{p 9 13 2}
     a.  {cmd:predict,} {cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)},
         {cmd:predict,} {cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}, and
         {cmd:predict,} {cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} now allow
         {it:a} and {it:b} to be {help exp:expressions}.  This is useful when
         working with a transformed dependent variable because you can specify
         the same transform in the prediction.  For example, to predict the
         probability that a log-transformed dependent variable is less than
         90, you can now specify {cmd:pr(.,log(90))} rather than
         {cmd:pr(.,4.4998)}.

{p 9 13 2}
     b.  {cmd:predict,} {cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)},
         {cmd:predict,} {cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}, and
         {cmd:predict,} {cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} incorrectly
         allowed {it:b} to be less than {it:a}.  This has been fixed.

{p 4 9 2}
19.  {cmd:predict} with option {cmd:reffects} after
     {helpb mixed_post##predict:mixed},
     {helpb meqrlogit_post##predict:meqrlogit}, and
     {helpb meqrpoisson_post##predict:meqrpoisson} may now be specified with
     new option {cmd:reses()}.  This option allows you to request predictions
     of the standard errors of the random effects and predictions of the
     random effects themselves at the same time.  The old syntax
     ({cmd:predict, reses}) that required a separate command continues to work
     but is no longer documented.

{p 4 9 2}
20.  {helpb sem_command:sem} with option {cmd:ginvariant(all)} and
     user-specified zero-valued constraints on error variances incorrectly
     exited with error message "{err:inconsistent covariance setting for ...;}
     {err:one of these variable's underlying variance}
     {err:is constrained to zero}".  This has been fixed.

{p 4 9 2}
21.  {helpb sts list} with option {opt strata()} or option {opt by()} and
     with options {opt failure} and {opt at()} produced a value of 1 instead
     of 0 for the failure function when the time values specified in option
     {opt at()} preceded the earliest failure time in the data.  This has been
     fixed.

{p 4 9 2}
22.  {helpb var} with option {cmd:constraints()}, when
     {helpb set showbaselevels:set showbaselevels on} was specified,
     incorrectly exited with error message "{err:option baselevels not found}".
     This has been fixed.

{p 4 9 2}
23.  After the 29oct2015 update, {helpb xtlogit} and {helpb xtprobit} with
     option {cmd:vce(robust)} or option {cmd:vce(cluster} {it:panelvar}{cmd:)},
     when perfect predictors caused a reduction in the sample size, reported
     incorrect standard errors.  This has been fixed.

{p 4 9 2}
24.  {helpb xtreg} with option {cmd:vce(cluster} {it:clustvar}{cmd:)}, in the
     unusual case when {it:clustvar} was also specified as a continuous
     covariate, could report an incorrect number of clusters and could produce
     incorrect standard errors.  When the correct number of clusters was
     reported, the standard errors were correct even if {it:clustvar} was
     included as a continuous covariate.  This has been fixed.

{p 4 9 2}
25.  (Windows) {helpb export excel} did not save Excel files with the
     {cmd:.xls} extension when the filename contained a Unicode character
     beyond the {help u_glossary##plainascii:plain ASCII} range.  This has
     been fixed.

{p 4 9 2}
26.  (Windows) {help extended_fcn:Extended macro function} {cmd:dir files}
     with a {it:pattern} specified, when the pattern contained an uppercase
     letter and when option {cmd:respectcase} was not specified, did not store
     the names of matched filenames in the requested macro.  This has been
     fixed.

{p 4 9 2}
27.  (Mac) The {helpb import delimited} dialog box, when the name of the file
     to be imported contained a Unicode character, submitted an incorrect
     filename in the command it issued to Stata.  This has been fixed.

{p 4 9 2}
28.  (Mac) In the {helpb update} dialog box, clicking on the link for manual
     updates did not open the "Keeping Stata 14 up to date" webpage.  This has
     been fixed.


{hline 8} {hi:update 21dec2015} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 15(4).

{p 5 9 2}
2.  {helpb bayesmh}, when {help weight:{it:weight}}s were specified using an
    {help exp:expression}, incorrectly exited with error message
    "{err:variable not found}".  This has been fixed.

{p 5 9 2}
3.  {helpb estat icc} now allows robust or cluster-robust standard errors to
    be specified with the initial {helpb mixed} or {helpb melogit} command.

{p 5 9 2}
4.  {helpb fp:fp generate}, when qualifier {cmd:if} was specified with an
    {help exp:expression} containing quotation marks (""), incorrectly exited
    with error message "{err:invalid expression}".  This has been fixed.

{p 5 9 2}
5.  {helpb putexcel:putexcel set} has new option {opt modify}, which changes
    the contents of an existing workbook.

{p 9 9 2}
    After the 29oct2015 update, the default behavior of {cmd:putexcel set} was
    changed to modify an existing workbook or to create the workbook if it
    does not exist.  Option {opt modify} is intended to prevent accidental
    overwriting of existing workbooks.

{p 5 9 2}
6.  After the 29oct2015 update, {helpb putexcel}, when outputting string data
    enclosed with compound double quotes (`"` and '"'), incorrectly exited
    with error message "{err:` invalid name}".  This has been fixed.

{p 5 9 2}
7.  {helpb sem_command:sem}, when used to fit a model with more than 256
    observed variables, exited with an uninformative error.  If the number of
    model parameters (coefficients, means, variances, and covariances) is less
    than or equal to {ccl maxint}, then {cmd:sem} now fits the model as
    specified.  If the number of parameters exceeds {ccl maxint}, then
    {cmd:sem} exits with error message "{err:matsize too small}".

{p 5 9 2}
8.  {helpb streg} has the following fixes:

{p 9 13 2}
     a.  {cmd:streg}, in the rare case when the full model converged but the
         constant-only model did not, incorrectly reported a likelihood-ratio
         model test instead of a Wald model test.  This has been fixed.

{p 9 13 2}
     b.  {cmd:streg}, when used to fit a Weibull model with a constraint on
         the constant and when option {opt ancillary()}, {opt strata()},
         {opt offset()}, {opt frailty()}, or {opt shared()} was not specified,
         applied the specified constraint incorrectly.  This has been fixed.

{p 9 13 2}
     c.  {cmd:streg} has improved starting values for Weibull models with a
	 constraint on the shape parameter when option {opt ancillary()},
	 {opt strata()}, {opt offset()}, {opt frailty()}, or {opt shared()}
	 is not specified.

{p 9 13 2}
     d.  {cmd:streg}, when used to fit a Weibull model with only a constant
         term in the main and ancillary equations, when a constraint was
         applied to the constant in the ancillary equation, and when option
         {opt ancillary()}, {opt strata()}, {opt offset()}, {opt frailty()},
         or {opt shared()} was not specified, applied the specified constraint
         incorrectly.  This has been fixed.

{p 9 13 2}
     e.  {cmd:streg}, when used to fit a Weibull model in the accelerated
         failure-time (AFT) metric with constraints and when option
         {opt ancillary()}, {opt strata()}, {opt offset()}, {opt frailty()},
         or {opt shared()} was not specified, applied the constraints in the
         proportional-hazards metric instead of the AFT metric.  This has been
         fixed.

{p 9 13 2}
     f.  {cmd:streg}, when used to fit an exponential model in the accelerated
         failure-time (AFT) metric with constraints, applied the constraints
         in the proportional-hazards metric instead of the AFT metric.  This
         has been fixed.

{p 9 13 2}
     g.  {cmd:streg} with option {opt offset()}, when used to fit an
         exponential model in the accelerated failure-time (AFT) metric,
         constrained the parameter of the offset variable to one in the
         proportional-hazards metric instead of the AFT metric.  This has been
         fixed.

{p 9 13 2}
     h.  {cmd:streg} with option {opt frailty()}, option {opt shared()}, or
         both, when used to fit an exponential model in the accelerated
	 failure-time (AFT) metric, produced covariances between the main
	 equation parameters and the frailty parameter that had the wrong
	 sign.  This has been fixed.

{p 5 9 2}
9.  {helpb streg_postestimation##predict:predict}, with option {opt scores}
    after using {helpb streg} to fit an exponential model in the accelerated
    failure-time (AFT) metric, and when {cmd:streg} was specified with option
    {opt frailty()}, option {opt shared()}, or both, produced frailty
    parameter scores that had the wrong sign.  This has been fixed.


{hline 8} {hi:update 01dec2015} {hline}

{p 5 9 2}
1.  {helpb putexcel} has two new options to write Stata dates
    ({cmd:%td}-formatted values) or datetimes ({cmd:%tc}-formatted values) to
    Excel as unformatted numbers.

{p 9 13 2}
     a.  Option {opt asdatenum} converts the specified Stata date to an Excel
         date and writes the result as an unformatted number.  {opt asdatenum}
         is useful if you are adding data to cells that already have a date
         format and you do not want Stata to apply the default Excel date
         format, {it:m}/{it:d}/{it:yyyy}.

{p 9 13 2}
     b.  Option {opt asdatetimenum} converts the specified Stata datetime to
         an Excel datetime and writes the result as an unformatted number.
         {opt asdatetime} is useful if you are adding data to cells that
         already have a datetime format and you do not want Stata to apply the
         default Excel datetime format, {it:m}/{it:d}/{it:yyyy h}:{it:mm}.

{p 5 9 2}
2.  {helpb bayesmh} has the following fixes:

{p 9 13 2}
     a.  {cmd:bayesmh}, when option {opt noshow()} was specified for one or
         more model parameters, incorrectly treated the parameters as excluded
         in the calculation of the Laplace-Metropolis estimator of the log
         marginal likelihood instead of using the formula documented in the
         manual.  This has been fixed.

{p 9 13 2}
     b.  {cmd:bayesmh}, when option {opt exclude()} was specified for one or
         more model parameters, incorrectly attempted to calculate the
         Laplace-Metropolis estimator of the log marginal likelihood.  Because
         the Laplace-Metropolis estimator requires simulation results for all
         parameters in the model, {cmd:bayesmh} now reports a missing value
         for the log marginal likelihood if {opt exclude()} is specified.

{p 5 9 2}
3.  {helpb bayesstats ic} has new option {opt diconly} to report only the
    deviance information criterion (DIC).

{p 5 9 2}
4.  {helpb estat report}, {helpb irtgraph icc}, {helpb irtgraph tcc},
    {helpb irtgraph iif}, and {helpb irtgraph tif}, after an
    {help irt:IRT model} was fit with prefix {helpb svy}, incorrectly exited
    with error message "{err:invalid subcommand report}".  This has been fixed.

{p 5 9 2}
5.  {helpb forecast solve} with option
    {cmd:simulate(residuals,} {it:...}{cmd:)} now displays a progress log when
    computing the forecast residuals.  The log can be suppressed with
    option {cmd:log(off)}.

{p 5 9 2}
6.  {helpb gsem_command:gsem} and {helpb sem_command:sem}, when
    {helpb set varabbrev} had been set to {cmd:off} and when {cmd:_OEx},
    {cmd:_LEx}, {cmd:_Ex}, {cmd:e._OEn}, {cmd:e._LEn}, or {cmd:e._En} was
    specified in option {cmd:covariance()} or option {cmd:covstructure()},
    incorrectly exited with error message
    "{err:latent variable ... not found}".  This has been fixed.

{p 5 9 2}
7.  {helpb memory}, when used to check memory allocation in 64-bit
    {help statamp:Stata/MP}, always reported that 4 GB of memory was used for
    overhead, even when the actual amount was far less.  This has been fixed.

{p 5 9 2}
8.  {helpb nestreg}, with prefix {helpb svy} and missing values in any of
    the survey design variables, incorrectly exited with error message
    "{err:{it:#} obs. dropped because of estimability,}
    {err:this violates the nested model assumption}".  This has been fixed.

{p 5 9 2}
9.  {helpb gsem_predict:predict} with option {cmd:latent}, after using
    {helpb gsem_command:gsem} to fit a model with two or more latent
    variables that were each predicted by observed variables, incorrectly
    exited with error message "{error:variable _cons not found}".  This has
    been fixed.

{p 4 9 2}
10.  {cmd:predict}, when used to compute marginal predictions after fitting a
     weighted multilevel model with {helpb gsem_predict:gsem},
     {helpb meglm_postestimation##predict:meglm},
     {helpb melogit_postestimation##predict:melogit},
     {helpb meprobit_postestimation##predict:meprobit},
     {helpb meologit_postestimation##predict:meologit},
     {helpb meoprobit_postestimation##predict:meoprobit},
     {helpb mepoisson_postestimation##predict:mepoisson}, or
     {helpb menbreg_postestimation##predict:menbreg}, and in rare cases when
     group variables were changed to break the original nesting structure,
     incorrectly exited with error message
     "{err:weights not allowed with crossed models}".  This has been fixed.

{p 9 9 2}
     Estimation results {help estimates save:saved} to disk prior to this fix
     will continue to exhibit this unwanted behavior.

{p 4 9 2}
11.  {helpb putexcel}, after the 29oct2015 update and with option {opt asdate}
     or option {opt asdatetime}, wrote the specified number as a string
     instead of the correct Excel date value.  This has been fixed.

{p 4 9 2}
12.  {helpb putexcel:putexcel set}, after the 29oct2015 update and with option
     {cmd:sheet(}{it:sheetname}{cmd:, replace)}, did not clear the specified
     worksheet.  This has been fixed.

{p 4 9 2}
13.  {helpb sem_command:sem} has the following fixes:

{p 9 13 2}
     a.  {cmd:sem}, when specified with an empty weight expression,
         incorrectly exited with error message
	 "{err:'[]' found where '(' expected}".  This has been fixed.

{p 9 13 2}
     b.  {cmd:sem} has improved starting values for fitting models with
         unstructured error covariances when the data include few observations
         relative to the number of freely estimated parameters.

{p 4 9 2}
14.  {helpb svy tabulate:svy: tabulate}, when value labels for a tabulated
     variable contained quotation marks, exited with error message
     "{err:conformability error}".  This has been fixed.

{p 4 9 2}
15.  {helpb unzipfile} and {helpb zipfile}, when the name of the file
     contained the word "if", "in", or "using", exited with error message
     "{err:... not allowed}".  This has been fixed.

{p 4 9 2}
16.  (Windows) {help extended_fcn:Extended macro} function {cmd:dir} is
     documented to be case-insensitive by default.  The function was instead
     case-sensitive.  It now works as documented.

{p 4 9 2}
17.  (Windows) The Command window, when high-contrast colors are enabled in
     Windows, now uses the colors set by the operating system.

{p 4 9 2}
18.  (Windows) Toolbars, when high-contrast colors are enabled in Windows, now
     use an appropriate background color.

{p 4 9 2}
19.  (Windows) The Do-file Editor has the following improvements:

{p 9 13 2}
     a.  The Do-file Editor now allows you to set the cursor color.  To set
	 your cursor color preferences, choose {bf:Edit > Preferences...}
	 from the menu, and then select "Cursor color" on the {bf:Editor font}
	 tab.

{p 9 13 2}
     b.  Line numbers in the Do-file Editor now use the default text color
         from the operating system.

{p 4 9 2}
20.  (Unix) {helpb graph export}, when exporting to PDF and when the graph
     included an extended-ASCII mathematical character, could crash Stata.
     This has been fixed.


{hline 8} {hi:update 29oct2015} (Stata version 14.1) {hline}

{p 5 9 2}
1.  Bayesian analysis ({helpb bayesmh}) has many improvements for multilevel
    models, panel-data models, nonlinear models, and models with latent
    variables:

{p 9 13 2}
     a.  {cmd:bayesmh} has new option {opt reffects()} for fitting univariate
         two-level models.  Specifying {opt reffects()} implements a more
         computationally efficient Metropolis-Hastings algorithm for sampling
         random-effects parameters.

{p 9 13 2}
     b.  {cmd:bayesmh} with option {opt block()} has new suboption
         {opt reffects}.  Parameters grouped in a block with suboption
         {opt reffects} are treated as random-effects parameters and are
         simulated using the new optimized version of the Metropolis-Hastings
         algorithm.

{p 9 13 2}
     c.  {cmd:bayesmh} has new option {opt xbdefine()} for defining linear
         combinations.  This provides a more convenient and memory-efficient
         way of using linear combinations in substitutable expressions.  This
         option is used when fitting nonlinear models.

{p 9 13 2}
     d.  {cmd:bayesmh} has new option {opt redefine()} for defining linear
         forms associated with random-effects variables.  This option may be
         used to write expressions in likelihood specifications and speed up
         calculations, especially for nonlinear models that include random
         effects.

{p 9 13 2}
     e.  Option {opt prior()}'s suboptions {opt mvnormal()} and
         {opt mvnormal0()} provide a convenient way of modeling correlation
         between random-effects parameters.

{p 13 13 2}
         {opt mvnormal()} and {opt mvnormal0()} prior distributions of
         dimension {it:d} can now be used with lists of {it:m} x {it:d}
         parameters for any positive integer {it:m}.  In such cases, the list
         of parameters is reshaped into a matrix with {it:d} columns, and its
         rows are assumed to be independent samples from the specified
         multivariate normal distribution.  See
         {mansection BAYES bayesmhRemarksandexamplesex25:example 25}
	 in {bf:[BAYES] bayesmh} for application of this feature.

{p 5 9 2}
2.  {helpb ci} and {helpb cii} have the following improvements and changes:

{p 9 13 2}
     a.  With new commands {cmd:ci variances} and {cmd:cii variances}, you can
	 now compute confidence intervals for variances or standard
	 deviations.  Classical confidence intervals for normal data and
	 Bonett confidence intervals for nonnormal data are provided.

{p 9 13 2}
     b.  {cmd:ci means} and {cmd:cii means} are now used to compute confidence
         intervals for means of normally and Poisson distributed variates.
         The {help prdocumented:previous commands} were {cmd:ci} and
         {cmd:cii}.  The old syntax is preserved under version control.

{p 9 13 2}
     c.  {cmd:ci proportions} and {cmd:cii proportions} are now used to
         compute confidence intervals for proportions.  The
         {help prdocumented:previous commands} were {cmd:ci} with option
         {opt binomial} and {cmd:cii} with option {opt binomial}.  The old
         syntax is preserved under version control.

{p 5 9 2}
3.  New command {helpb diflogistic} performs the logistic regression test for
    uniform and nonuniform differential item functioning (DIF) in the context
    of item response theory (IRT) analysis.  Tests for DIF detect whether an
    item performs differently for individuals with the same ability who come
    from different groups.

{p 5 9 2}
4.  {helpb difmh} has the following improvements:

{p 9 13 2}
     a.  {cmd:difmh} has new option {cmd:maxp(}{it:#}{cmd:)} that causes
         {cmd:difmh} to display results only for items with
         {bind:p {ul:<} {it:#}}.

{p 9 13 2}
     b.  {cmd:difmh} has new option {cmd:sformat()} that changes the display
         format of chi-squared values.

{p 9 13 2}
     c.  {cmd:difmh} has new option {cmd:pformat()} that changes the display
         format of p-values.

{p 9 13 2}
     d.  {cmd:difmh} has new option {cmd:oformat()} that changes the display
         format of odds-ratio statistics.

{p 9 13 2}
     e.  {cmd:difmh} can now replay results, and on replay the user can
	 specify reporting options {cmd:maxp()}, {cmd:sformat()},
	 {cmd:pformat()}, {cmd:oformat()}, and {cmd:level()}.

{p 5 9 2}
5.  {helpb ivprobit} with two or more endogenous variables now converges more
    reliably and presents easier to interpret output for the ancillary
    parameters.  Their names in {cmd:e(b)} are now {bf:athrho} and
    {bf:lnsigma} with index suffixes.  The old behavior is preserved under
    version control.

{p 5 9 2}
6.  {helpb ivprobit} has two new postestimation commands:

{p 9 13 2}
     a.  {helpb ivprobit_postestimation##estat:estat covariance} displays the
         covariance matrix of the errors.

{p 9 13 2}
     b.  {helpb ivprobit_postestimation##estat:estat correlation} displays the
         correlation matrix of the errors.

{p 5 9 2}
7.  {helpb ivprobit postestimation##predict:predict} with option {cmd:pr}
    after {helpb ivprobit} has been improved to compute probability estimates
    that account for endogeneity.  The old behavior is preserved under
    version control.

{p 9 9 2}
     This means that the results of {helpb margins},
     {helpb estat classification}, {helpb lroc}, and {helpb lsens} after
     {helpb ivprobit} also have been improved to account for endogeneity.

{p 5 9 2}
8.  {helpb ivtobit postestimation##predict:predict} with options {cmd:pr()},
    {cmd:e()}, and {cmd:ystar()} after {helpb ivtobit} have been improved to
    compute probabilities, truncated expectations, and censored expectations
    that account for endogeneity.  The old behavior is preserved under
    version control.

{p 9 9 2}
     This means that the results of {helpb margins} also have been improved to
     account for endogeneity.

{p 5 9 2}
9.  You can now add your own imputation methods to {helpb mi impute} by
    writing an ado-file program that follows simple conventions.  You use the
    program to impute your variables once, and then use it with {cmd:mi impute}
    to obtain multiple imputations.  {cmd:mi impute} will properly create
    imputations according to the chosen {cmd:mi} style.  All of
    {cmd:mi impute}'s global options, except {cmd:by()} and {cmd:noupdate},
    are supported.  See
    {it:{help mi_impute_usermethod:User-defined imputation methods}} for
    details.

{p 4 9 2}
10.  {helpb mixed_postestimation##contrast:contrast} after
     {helpb mixed:mixed ..., dfmethod()} has new option {cmd:small} to perform
     small-sample inference for contrasts of fixed effects.  This
     allows you to request that degree-of-freedom adjustments, such as
     Kenward-Roger and Satterthwaite, be applied to tests for individual
     contrasts and tests of main effects, simple effects, and interactions.

{p 4 9 2}
11.  {helpb mixed_postestimation##pwcompare:pwcompare} after
     {helpb mixed:mixed ..., dfmethod()} has new option {opt small} to perform
     small-sample inference for pairwise comparisons of fixed effects.  This
     allows you to request that degree-of-freedom adjustments, such as
     Kenward-Roger and Satterthwaite, be applied to tests for pairwise
     comparisons.

{p 4 9 2}
12.  {helpb mlexp} has three new options:

{p 9 13 2}
     a.  Option {cmd:constraints()} allows linear constraints to be specified.

{p 9 13 2}
     b.  Option {cmd:collinear} allows {cmd:mlexp} to retain collinear
         variables.

{p 9 13 2}
     c.  Option {cmd:debug} may be specified with option {cmd:derivative()} to
         report the difference between the numerical derivatives and
         analytical derivatives.  This option is useful for determining if
         there are problems with user-provided derivatives.

{p 4 9 2}
13.  {helpb mlexp_postestimation##syntax_predict:predict} after {helpb mlexp}
     now takes option {opt xb}.  This lets you obtain the linear prediction
     after maximum likelihood estimation of user-specified expressions.

{p 4 9 2}
14.  {helpb mlexp_postestimation##margins:margins} is now available after
     {helpb mlexp}. This lets you estimate marginal and conditional effects
     such as means, predictive margins, and marginal effects after maximum
     likelihood estimation of user-specified expressions.

{p 4 9 2}
15.  {helpb teffects psmatch} is now much faster for large datasets.

{p 4 9 2}
16.  {helpb xtprobit:xtprobit, re}, {helpb xtlogit:xtlogit, re}, and
     {helpb xtcloglog:xtcloglog, re} now allow predictions of marginal
     probabilities.  The marginal probability is the probability of a positive
     outcome that is marginal with respect to the random effect.  This is now
     the default statistic for {helpb margins} after these commands.  The old
     default behavior is preserved under version control.

{p 4 9 2}
17.  {helpb xtpoisson:xtpoisson, re} with option {opt normal} now allows
     prediction of the number of events to be marginal with respect to the
     random effect.  This prediction is the new default statistic for
     {helpb margins} after {cmd:xtpoisson, re}.  The old default behavior is
     preserved under version control.

{p 4 9 2}
18.  {helpb xtologit} and {helpb xtoprobit} now allow predictions of marginal
     probabilities.  The marginal probability is the probability of the
     specified outcome that is marginal with respect to the random effect.
     The marginal probability for each outcome is the new default statistic
     for {helpb margins} after these commands.  The old default behavior is
     preserved under version control.

{p 4 9 2}
19.  {helpb xtstreg} now allows predictions of the marginal mean survival
     time, marginal hazard, and marginal survivor function.  The mean survival
     time, hazard, and survivor function are marginal with respect to the
     random effect.  The marginal mean survival time is the new default
     statistic for {helpb margins} after {cmd:xtstreg}.  The old default
     behavior is preserved under version control.

{p 4 9 2}
20.  {helpb stcurve} now defaults to marginal predictions after
     {helpb xtstreg}.  The old default behavior is preserved under version
     control.

{p 4 9 2}
21.  {helpb icd10} now works with ICD-10 codes from many more years.  Any year
     from 2003 to 2015 is allowed. This year range covers the full history of
     ICD-10 back to version 2. Type {cmd:icd10 query} for complete
     information.

{p 4 9 2}
22.  {helpb icd10:icd10 check}, {helpb icd10:icd10 lookup}, and
     {helpb icd10:icd10 generate} with option {opt description} default to
     using the most current ICD-10 codes in Stata if {opt year()} is not
     specified.  The current default is now {cmd:year(2015)}.

{p 4 9 2}
23.  {helpb putexcel} has a greatly simplified syntax and a more intuitive
     dialog.

{p 4 9 2}
24.  {help Plugins} now support {cmd:strL}s (long strings).  See the webpage
     {it:{browse "http://www.stata.com/plugins/":Creating and using Stata plugins}}.

{p 4 9 2}
25.  Stata has improved matrix stripe logic that now allows matrices to be
     combined with a mixture of factor-variable operators, including
     {helpb contrast} operators and the {cmd:@} operator.  Because matrix
     stripe behavior is affected, the old behavior is preserved under version
     control.

{p 4 9 2}
26.  {helpb eteffects}, {helpb teffects}, and {helpb stteffects} no longer
     allow the {cmd:r} operator in references to coefficients in the
     {cmd:POmean} equation.  The old behavior of requiring the {cmd:r}
     operator is preserved under version control.

{p 4 9 2}
27.  {helpb bayesmh}'s model summary of specified priors, when the prior
     included substitutable expressions that were not enclosed in parentheses,
     did not display the argument to the parameter distribution.  For example,
     {cmd:{mpg:_cons} ~ exponential(sqrt(_pi))} was displayed as
     {cmd:{mpg:_cons} ~ exponential}.  This has been fixed.

{p 4 9 2}
28.  {helpb collapse} has the following fixes:

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

{p 4 9 2}
29.  {helpb etregress} with {cmd:vce(cluster} {it:clustvar}{cmd:)} exited
     with an uninformative error message when {it:clustvar} had missing
     values.  This has been fixed.

{p 4 9 2}
30.  {cmd:gllamm} in {help statamp:Stata/MP} with {cmd:link(ologit)} or
     {cmd:link(oprobit)} exited with error message
     "{err:(error occurred in ML computation)}" even when the model was
     correctly specified.  This has been fixed.

{p 4 9 2}
31.  {helpb icd9} and {helpb icd9p} have the following fixes:

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
         these codes is now "{cmd:*}", which is the documented indicator that
         a code has been subdivided into billable codes.

{p 9 13 2}
     d.  {cmd:icd9 lookup} and {cmd:icd9p lookup}, when looking up a small
         number of category codes and subcategory codes without specifying a
         range, would incorrectly return "(no matches found)".  For example,
         typing {cmd:icd9 lookup 040.4} would trigger this note, but
         {cmd:icd9 lookup 040.4*} would not.  This has been fixed.

{p 4 9 2}
32.  {helpb import delimited} now uses a comma instead of a tab character
     ({cmd:\t}) as the default delimiter if it is unable to automatically
     determine the delimiter used in the file.  This behavior is more
     consistent with {cmd:import delimited}'s use of {cmd:.csv} as the default
     file extension.  The old behavior is preserved under version control.

{p 4 9 2}
33.  {helpb import delimited} with option {cmd:varnames()}, with files having
     more than 5,000 rows and where the data type for a variable switched
     between numeric and string after row 5,000, resulted in variable names
     being imported from the wrong line of the file.  This has been fixed.

{p 4 9 2}
34.  {helpb ologit_postestimation##predict:predict} with {it:stub}{cmd:*} and
     option {cmd:pr}, after using {helpb ologit} or {helpb oprobit} to fit a
     model without covariates, incorrectly exited with error message
     "{err:varname required}".  This has been fixed.

{p 4 9 2}
35.  {helpb xtintreg_postestimation##predict:predict} after {helpb xtintreg}
     and {helpb xttobit} and with option {opt pr0()}, option {opt e0()}, or
     option {opt ystar0()} calculated marginal predictions, typically more
     useful than predictions that assume a zero-valued random effect.
     However, the documentation stated that predictions assumed random effects
     were 0.  The documentation has been updated to reflect the behavior of
     the command and, for clarity, the options have been renamed {opt pr()},
     {opt e()}, and {opt ystar()}.  The old syntax is preserved under version
     control.

{p 4 9 2}
36.  {helpb rnormal()}, despite producing random-normal variates with all
     the desirable statistical properties of the documented algorithm, on rare
     occasions did not exactly implement the documented algorithm.  This has
     been fixed.

{p 9 9 2}
     The sequence of random-normal variates can differ in rare cases from
     those that were previously drawn when starting from the same {help seed}.
     Commands dependent on random-normal variates, such as {helpb bayesmh} and
     {helpb mi impute mvn} could produce different results.  The previous
     behavior is preserved under {help version##userversion:user-version control}.

{p 4 9 2}
37.  {helpb xtlogit} and {helpb xtprobit} with option {cmd:vce(robust)} or
     option {cmd:vce(cluster} {it:panelvar}{cmd:)}, when perfect predictors
     caused a reduction in the sample size, incorrectly exited with error
     message "{err:calculation of robust standard errors failed}".  This has
     been fixed.

{p 4 9 2}
38.  Contrary to the documentation, {helpb xtpoisson:xtpoisson, re} with
     option {opt normal} did not accept
     {help tsvarlist:time-series operators} in {it:depvar} or {it:indepvars}.
     This has been fixed.

{p 4 9 2}
39.  {helpb xtregar} has the following fixes:

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
40.  (Windows) Icons are now rendered more clearly when the DPI setting in
     Windows is above 100%.

{p 4 9 2}
41.  (Windows) Dialog boxes for {helpb import delimited} and {helpb power}
     now use proper scaling when the DPI setting in Windows is above 100%.

{p 4 9 2}
42.  (Windows) {helpb graph use} did not open files with UNC paths (network
     paths beginning with \\) and returned error message
     "{err:file {it:filename} not found}". This has been fixed.

{p 4 9 2}
43.  (Windows) The {help graph_editor##recorder:Graph Recorder}, when a
     recording was selected after choosing {bf:Recorder} and then {bf:Play}
     from the {bf:Tools} menu or after clicking on the {bf:Play recording}
     button in the Standard Toolbar, did not play the selected recording and
     put Stata in a state where no commands could be submitted.  This has been
     fixed.

{p 4 9 2}
44.  (Mac) {helpb view:view browse} did not open https URI schemes or URLs
     that were enclosed in quotes.  This has been fixed.

{p 4 9 2}
45.  (Mac) Selecting {bf:Paste special...} from the {bf:Edit} menu and then
     clicking on {bf:OK} in the resulting dialog caused Stata to crash.
     This has been fixed.

{p 4 9 2}
46.  (Mac GUI) The System Integrity Protection feature of OS X 10.11
     (El Capitan) prevents users from making modifications to the /usr/bin
     directory.  Because Stata can no longer write to the /usr/bin directory,
     Stata now creates a symbolic link to the console version of
     {help statamp:Stata/MP} or {help statase:Stata/SE} in the /usr/local/bin
     directory if the user selects "Install Terminal Utility..." from the
     Apple menu.  Stata will create the /usr/local/bin directory if it does
     not exist.

{hline 8} {hi:update 07oct2015} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 15(3).

{p 5 9 2}
2.  {helpb egen:egen cut({it:varname}), group({it:#})}, when {it:#} > 1000 and
    when the data were not previously sorted by {it:varname}, did not produce
    {it:#} groups.  This has been fixed.

{p 5 9 2}
3.  {helpb estat phtest} with option {cmd:detail}, when used after
    {helpb stcox} with option {cmd:vce(robust)} and with multiple-record data,
    used robust standard errors instead of the appropriate cluster-robust
    standard errors when computing rho statistics and p-values for tests of
    the proportional-hazards assumption for individual covariates.  This has
    been fixed.

{p 5 9 2}
4.  {helpb eteffects} has the following fixes and improvement:

{p 9 13 2}
     a.  {cmd:eteffects} after the 3 Aug 2015 update, when there were missing
         predicted values for the treatment probability, produced incorrect
         estimates.  This has been fixed.

{p 9 13 2}
     b.  {cmd:eteffects} attempted to fit a model when the treatment variable
         had a negative value and returned an uninformative error message.
         The command now returns error message
         "{err:treatment variable {it:tvar} must be positive}".

{p 9 13 2}
     c.  {cmd:eteffects} now allows the treatment variable to identify the
         treatment levels using any two nonnegative integers.  Previously, the
         treatment levels were required to be coded 0 and 1.  By default,
         {cmd:eteffects} assumes that the lower value of the treatment
         variable is the control.

{p 5 9 2}
5.  {helpb forecast solve} with option {cmd:simulate(residuals)} returned a
    Mata error message when used to define an
    {help forecast identity:identity} before
    {help forecast estimates:estimates} were defined or before a
    {help forecast coefvector:coefficient vector} was added.
    This has been fixed.

{p 5 9 2}
6.  {helpb ivtobit} with models having more than one endogenous variable
    specified is now more likely to converge.

{p 5 9 2}
7.  {helpb margins} with options {cmd:vce(unconditional)} and
    {cmd:expression()}, if the expression was a function of more than one
    prediction, exited with error message "{err:varlist required}".  This
    has been fixed.

{p 5 9 2}
8.  {helpb pctile:pctile {it:newvar} = {it:exp}, nquantiles({it:#})}, when
    {it:#} > 1000 and when the data were not previously sorted by {it:exp},
    correctly computed the quantile values but did not store the values in the
    first {it:#}-1 observations of the dataset.  This has been fixed.

{p 5 9 2}
9.  {helpb stcox_postestimation##predict:predict} with option {cmd:scaledsch},
    when used after {helpb stcox} with option {cmd:vce(robust)} and with
    multiple-record data, used robust standard errors instead of the
    appropriate cluster-robust standard errors when computing scaled
    Schoenfeld residuals.  This has been fixed.

{p 4 9 2}
10.  {helpb teffects nnmatch}, in the unusual case that {it:fweight}s were
     specified with option {cmd:vce(robust)}, produced standard errors that
     were too small.  This has been fixed.


{hline 8} {hi:update 22sep2015} {hline}

{p 5 9 2}
1.  Stata has improved execution for operations using the https:// protocol
    and when using a proxy server.  Stata now sends a CONNECT request to the
    proxy server, which is the standard Java implementation and is the
    preferred method for secure sockets layer (SSL) connections.

{p 5 9 2}
2.  {helpb eteffects} has improved starting values with outcome model
    {cmd:fractional} and with option {cmd:atet}, meaning that these models now
    converge faster.  The estimated average treatment effect on the treated
    (ATET) and associated standard error are unchanged.

{p 5 9 2}
3.  {helpb etregress} with option {opt cfunction} has an improved method for
    computing the moment conditions and gradient.  Most users will notice a
    change only in the values displayed in the iteration log.  However, in
    rare cases, some complex models that could not be fit before will now
    converge.

{p 5 9 2}
4.  {helpb contrast} with the observation-weighted orthogonal polynomial
    operators {cmd:pw(}{it:numlist}{cmd:).} and
    {cmd:qw(}{it:numlist}{cmd:).} did not correctly interpret the {it:numlist}
    as the degree of the polynomial.  When either {cmd:pw.} or {cmd:qw.} was
    specified, {it:numlist} was interpreted as the value of the factor
    variable.  This has been fixed.

{p 5 9 2}
5.  {helpb estat df} with option
    {cmd:method(repeated)} reported incorrect degrees of freedom when
    observations in the dataset were not grouped by the subject variable.
    This has been fixed.

{p 9 9 2}
    Note that results reported by {helpb mixed} with option
    {cmd:dfmethod(repeated)} were not affected.

{p 5 9 2}
6.  {helpb estimates table} with multiple {helpb prais} estimation results
    ignored all but the first coefficient.  This has been fixed.

{p 5 9 2}
7.  {helpb generate} and {helpb replace}, when the right-hand-side expression
    included references to elements of Stata matrices, did not benefit from
    parallelization.  These commands now exhibit nearly perfect
    parallelization when the matrix subscripts are specified as numeric
    scalars.

{p 5 9 2}
8.  {helpb graph export}, when used to export to EPS format a graph that had a
    font with glyphs of more than 2,000 points, could cause Stata to crash.
    This has been fixed.

{p 5 9 2}
9.  {helpb gsem_command:gsem} with prefix {helpb svy} and when the specified
    model included a multinomial outcome and did not include any latent
    variables incorrectly exited with an error message.  This has been fixed.

{p 4 9 2}
10.  Mata functions {helpb mf_lnmvnormalden:lnmvnormalden()},
     {helpb mf_lnwishartden:lnwishartden()}, and
     {helpb mf_lniwishartden:lniwishartden()} with an input argument that was
     created with {helpb mf_st_view:st_view()} returned incorrect results.
     This has been fixed.

{p 4 9 2}
11.  {helpb me} commands have the following fixes:

{p 9 13 2}
     a.  {cmd:me} commands used with a dependent variable that began with a
         capital letter and without a random-effects equation incorrectly
         exited with the error message "{err:model not identified}".  This has
         been fixed.

{p 9 13 2}
     b.  {cmd:me} commands, in the unusual case when multilevel commands were
         used to fit a one-level model and when the model included an
	 independent variable that began with a capital letter, fit the model
	 as if the capitalized variable were a level-2 random effect and
	 reported a note that {it:indepvar} was treated as a latent variable.
	 This has been fixed.

{p 4 9 2}
12.  {helpb prtest} and {helpb prtesti}, when used for a two-sample test of
     proportions, reported the two-sided p-value of the test with the label
     {cmd:Pr(|Z| < |z|)}.  The label should have been {cmd:Pr(|Z| > |z|)}.
     This has been fixed.

{p 4 9 2}
13.  {helpb pwcorr}, when pairwise correlations were requested for more than
     seven variables, did not store results as documented.  Matrix {cmd:r(C)}
     stored only a portion of the correlations, and scalars {cmd:r(rho)} and
     {cmd:r(N)} contained missing values.  This has been fixed.

{p 4 9 2}
14.  {helpb sem_command:sem} with constrained coefficients on paths from two
     or more latent variables to a single observed variable incorrectly exited
     with an error message when the model was identified.  This has been
     fixed.

{p 4 9 2}
15.  Postestimation command {helpb varlmar}, when the dataset contained
     variables beginning with {cmd:e}{it:#} and {it:#} was less than or equal
     to the number of equations in the previous model, dropped those variables
     from the dataset.  For instance, variables named {cmd:e1}, {cmd:e2}, and
     {cmd:e1a} were dropped.  If the variable was also included in the
     previous {helpb var} or {helpb svar} command, {cmd:varlmar} also exited
     with error message "{err:variable {it:varname} not found}".  This has
     been fixed.

{p 4 9 2}
16.  (Mac) When a table with multiple rows was copied from the Results
     window as HTML, the HTML output would appear as a table with just one
     row.  This has been fixed.

{p 4 9 2}
17.  (Mac) Graph dialogs on Mac OS X 10.10, when combined with this specific
     sequence of steps -- 1) select a variable from a variable control; 2)
     switch to a tab that contains no active text edit fields; and 3) click
     on the OK button without making any other changes -- displayed a warning
     message and, in rare cases, caused Stata to crash.  This has been fixed.

{p 4 9 2}
18.  (Mac and Unix GUI) The Do-file Editor now lets you replace all text
     within a selection. To use this feature, select a block of text in which
     you want to make changes and then

{p 9 13 2}
     a.  (Mac) open the Replace dialog within the Do-file Editor.  The
         "Replace all" button will display an arrow icon.  Click on the button
         to display a menu that prompts you to either replace all text within
         the document or replace only text within the selection.  Choose
         "Replace all in selection".

{p 9 13 2}
     b.  (Unix GUI) open the Replace dialog in the Do-file Editor, check the
         "Replace all in selection" checkbox, and click on the "Replace all"
         button.

{p 4 9 2}
19.  (Unix GUI) {helpb graph export}, when exporting to an {cmd:.eps} or a
     {cmd:.ps} file, no longer requires you to set font directories.  Truetype
     fonts are now automatically mapped to font settings specified by
     {helpb graph set:graph set {ps|eps} fontface} by searching system default
     font directories.  Alternative search paths to find corresponding
     truetype fonts may be specified by using
     {helpb graph set:graph set {ps|eps} fontdir}.


{hline 8} {hi:update 03aug2015} {hline}

{p 5 9 2}
1.  {helpb putexcel} has new option {cmd:locale()}, which lets you specify the
    locale to write extended ASCII characters to a workbook.

{p 5 9 2}
2.  {helpb ereturn post} and {helpb ereturn repost} have new options
    {opt buildfvinfo} and {opt findomitted}.  These are new utilities for
    programmers interested in adding factor-variables support to their
    estimation commands.

{p 5 9 2}
3.  {helpb ereturn repost} has new option {opt resize}.  This option
    allows programmers to repost estimation results of a different dimension
    than the original.

{p 5 9 2}
4.  {helpb areg} with option {cmd:vce(bootstrap)} or option
    {cmd:vce(jackknife)} resampled the absorption groups identified by the
    variable specified in option {cmd:absorb()} instead of resampling the
    observations.  Because the model for {cmd:areg} is a linear regression
    with a large dummy-variable set, observations are the appropriate
    resampling unit.  This has been fixed.

{p 9 9 2}
    The old behavior is not preserved under version control but can be
    reproduced by using {cmd:xtreg, fe} instead of {cmd:areg}.

{p 5 9 2}
5.  {helpb bayesmh} with {cmd:likelihood(probit)} now uses a more precise
    method of calculating the log likelihood for zero outcomes.  The previous
    method could produce numerically unstable results when an
    observation-level likelihood was close to zero.

{p 5 9 2}
6.  {helpb eteffects} produced incorrect standard errors.  This has been
    fixed.  Note that the point estimates of the treatment effects were
    correct.

{p 5 9 2}
7.  {helpb gmm} using {cmd:vce(hac} {it:kernel} {cmd:opt)}, where the optimal
    number of kernel lags is used, would report a missing value for the number
    of kernel lags used.  This has been fixed.  The missing value reported is
    not a numerical problem, only a reporting error.

{p 5 9 2}
8.  {helpb gsem_command:gsem}, {helpb meologit}, and {helpb meoprobit}, in the
    rare case when {it:depvar} contained noninteger values and the command was
    specified with prefix {helpb svy}, produced invalid linearized
    standard-error values.  This has been fixed.

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
11.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with weighted estimation results incorrectly reported
         some margins as "(not estimable)" in the results table if the margins
         were the result of fixing all the {it:indepvars} at a constant value
         and the first observation in the dataset had a zero-valued weight.
         This has been fixed.

{p 9 13 2}
     b.  {cmd:margins}, in the unusual case where {helpb xtlogit:xtlogit, re}
         or {helpb xtlogit:xtlogit, pa} was also specified with option
         {opt noconstant} and either option {cmd:vce(bootstrap)} or option
         {cmd:vce(jackknife)}, incorrectly reported the error message
         "{err:conformability error}".  This has been fixed.

{p 4 9 2}
12.  The documentation for {helpb meologit} and {helpb meoprobit} states that
     they support {help tsvarlist:time-series operators} for {it:depvar}.
     However, when a time-series-operated {it:depvar} was specified, these
     commands exited with an uninformative error message.  This has been
     fixed.

{p 4 9 2}
13.  {helpb putexcel}, when writing data or adding new formats, did not
     preserve existing column formats.  This has been fixed.

{p 4 9 2}
14.  Stata function {helpb f_regexm:regexm({it:s}, {it:re})} could crash Stata
     when one or both arguments were binary strL.  This has been fixed.

{p 4 9 2}
15.  Stata function {helpb f_strproper:strproper({it:s})} could crash Stata if
     the argument was binary strL.  This has been fixed.

{p 4 9 2}
16.  Stata function {helpb f_ustrlen:ustrlen({it:s})} caused Stata to use more
     memory than was required.  In general, this was not noticeable.  However,
     in rare cases, this could cause Stata to slow down.  This has been fixed.

{p 4 9 2}
17.  {helpb svy} when used to fit a {help svy estimation:regression model} to
     data from a multistage survey design that 1) did not have a sampling
     unit or stratum variable in the final stage and 2) had FPC variables in
     all stages could exit with the error message
     "{err:fpc for all observations within a stratum must be the same}",
     depending on the sort order of the data.  This has been fixed.

{p 4 9 2}
18.  In the Results or Viewer window, highlighting text that included
     Unicode characters, right-clicking to open a contextual menu, and then
     selecting "Copy table" or "Copy table as HTML" produced an incorrectly
     formatted table when the copied text was pasted to a new location.  This
     has been fixed.

{p 4 9 2}
19.  (Windows) {helpb graph export} when exporting to an {bf:.eps} or a
     {bf:.ps} file has the following fixes:

{p 9 13 2}
     a.  {cmd:graph export} with option {opt fontface(fontname)} ignored the
         specified {it:fontname} when rendering text in the PostScript file.
         This has been fixed.

{p 9 13 2}
     b.  {cmd:graph export} ignored the font settings for rendering text in
         the PostScript file that were specified through {helpb graph set}.
         This has been fixed.

{p 4 9 2}
20.  (Windows) The {help sem builder:SEM Builder} did not display the
     statistical category in the Details pane when showing associated results.
     This has been fixed.

{p 4 9 2}
21.  (Mac) After the 10 Jun 2015 update, the toolbar buttons and some menu
     items for the Data Editor were disabled.  This has been fixed.

{p 4 9 2}
22.  (Mac) In the Command window or Do-file Editor, dragging and dropping text
     could cause Stata to crash.  This has been fixed.

{p 4 9 2}
23.  (Mac) In the Find dialog, selecting "Match whole word only" while
     searching in the Do-file Editor caused Stata to correctly find the
     search term in the current search but incorrectly save the setting.  In
     subsequent searches, results only returned text that started with the
     requested search term rather than the whole word.  This has been fixed.

{p 4 9 2}
24.  (Mac) Stata graphs could incorrectly render to the screen the first point
     of polygons, such as arrowheads. The first point was shifted from where
     it should have been drawn by one pixel.  This has been fixed.

{p 4 9 2}
25.  (Unix GUI) On Ubuntu 12.04 LTS or later, Stata dialogs with multiple tabs
     would not display any dialog controls for Japanese.  This has been fixed.


{hline 8} {hi:update 23jun2015} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 15(2).

{p 5 9 2}
2.  {helpb estat abond} now stores p-values in {cmd:r(arm)}.

{p 5 9 2}
3.  In the 10jun2015 update, we reported that {helpb import delimited}, when
    importing a file with end-of-line characters from Mac OS 9 and earlier
    ({cmd:\r}), skipped portions of the data and that this was resolved.
    {cmd:import delimited} continued to have problems with {cmd:\r}.  This has
    been fixed.

{p 5 9 2}
4.  {helpb xtabond}, {helpb xtdpd}, and {helpb xtdpdsys} with option
    {opt twostep} reported standard errors that provided poor coverage when
    the second-step GMM weighting matrix was not full rank.  For example, this
    may have happened when the number of instruments was too large relative
    to the number of panels.  When the weighting matrix is not full rank,
    these commands now issue an error message, and the user is advised to use
    the default one-step estimates.


{hline 8} {hi:update 10jun2015} {hline}

{p 5 9 2}
1.  {helpb difmh} is a new command that performs the Mantel-Haenszel
    chi-squared test for uniform differential item functioning (DIF) in the
    context of IRT analysis.  Tests for DIF are used to detect whether an item
    performs differently for individuals with the same ability who come from
    different groups.  The Mantel-Haenszel test for DIF is used to determine
    whether the responses to an item are independent of the group to which an
    individual belongs.

{p 5 9 2}
2.  {helpb teffects} now allows fractional-outcome models with
    {helpb teffects ra}, {helpb teffects ipwra}, and {helpb teffects aipw}.
    This lets you estimate the average treatment effect, the average treatment
    effect on the treated, and the potential-outcome means for responses such
    as rates and proportions.

{p 5 9 2}
3.  {helpb pwcorr} now stores the pairwise correlations in matrix {cmd:r(C)}.

{p 5 9 2}
4.  {helpb arima} returned an uninformative error message when options
    {cmd:mar(}{it:numlist}{cmd:,} {it:#s}{cmd:)} or
    {cmd:mma(}{it:numlist}{cmd:,} {it:#s}{cmd:)} were incorrectly specified by
    omitting {it:numlist} or {it:#s}.  This has been fixed.

{p 5 9 2}
5.  {helpb bayesmh}, when used with a program evaluator that calls an
    estimation command and when option {cmd:saving()} was not specified,
    exited with error {bf:{search r(601):r(601)}}.  This has been fixed.

{p 5 9 2}
6.  {helpb bayesstats}, {helpb bayestest}, and {helpb bayesgraph}, when used
    after {helpb bayesmh} with option {cmd:noshow()} and when statistics,
    tests, or graphs were requested for the parameters specified in
    {cmd:noshow()}, exited with error message "parameter not found".  This
    has been fixed.

{p 5 9 2}
7.  {helpb betareg}, {helpb churdle}, and {helpb eteffects} failed to
    report a footnote when convergence was not achieved.  This has been
    fixed.

{p 5 9 2}
8.  After the 05may2015 update, {helpb export excel} with option
    {opt datestring()} generated strings containing incorrect dates
    when the specified {help datetime_display_formats:datetime format} was
    weekly, monthly, quarterly, half-yearly, or yearly.  This has been
    fixed.

{p 5 9 2}
9.  {helpb gsem_command:gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem} specified with more than one outcome variable, with
	 weights, and with latent variables exited with an uninformative error
	 message when perfect predictors caused a reduction in the sample size
	 for a subset of binary outcome variables.  This has been fixed.

{p 9 13 2}
     b.  {cmd:gsem} and some {help me} commands reported an unhelpful error
         message when there were variables defined in the current dataset but
         no observations.  In this case, these commands now report the error
         message "{error:no observations}".

{p 4 9 2}
10.  {helpb import delimited} has the following fixes:

{p 9 13 2}
     a.  {cmd:import delimited}, when string data were not present until row
         number 5,000 or higher for a variable in the imported text file,
         incorrectly chose a numeric {help data_type:data type} instead of a
         string data type for that variable.  This has been fixed.

{p 9 13 2}
     b.  {cmd:import delimited}, in rare cases, when importing a file with
         end-of-line characters from Mac OS version 9 and earlier ({cmd:\r}),
         skipped portions of the data.  This has been fixed.

{p 9 13 2}
     c.  {cmd:import delimited}, when importing a file with end-of-line
	 characters from Mac OS 9 and earlier ({cmd:\r}) and with extra blank
	 lines at the end, displayed error message
	 "{error:java.lang.ArrayIndexOutOfBoundsException}" and failed to
	 import the file.  This has been fixed.

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
         meta-information should be displayed only when suboption
         {cmd:verbose} is specified in {cmd:saving()}.  This has been fixed.

{p 4 9 2}
12.  {helpb irf graph} with option {opt ci#opts()} did not change the
     rendition of the confidence interval for the {it:#}th statistic.  This
     has been fixed.

{p 4 9 2}
13.  {helpb irt} with prefix {helpb svy}, contrary to the documentation,
     reported the fitted parameters using the slope-intercept parameterization
     instead of the standard IRT parameterization.  This has been fixed.

{p 4 9 2}
14.  {helpb ivprobit} for models with more than one endogenous variable
     specified is now more likely to converge.

{p 4 9 2}
15.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} with multiple {opt predict()} options and with option
         {opt atmeans}, option {opt at()}, option {opt over()}, or a factor
         variable in {it:marginslist} did not preserve the grouping of
         equations identified by the {it:indepvars} specified in the marginal
         effects options {opt dydx()}, {opt dyex()}, {opt eydx()}, and
         {opt eyex()}.  Predictions were correctly calculated, but the output
         did not display results in the most logical way.  This has been
         fixed.

{p 9 13 2}
     b.  {cmd:margins} after {help me} commands with one or more factor
         variables that have their base level {helpb fvset} incorrectly exited
         with an error.  This has been fixed.

{p 9 13 2}
     c.  {cmd:margins}, when using estimation results that contain an offset
         or exposure, and either when option {opt atmeans} was specified or
	 when all {it:indepvars} were fixed to constants, used one observation
	 instead of the entire estimation sample to compute margins and
	 marginal effects.  This has been fixed.

{p 4 9 2}
16.  {helpb mi impute intreg} exited with Mata error message
     "{error:st_store():  3203 colvector required}" when incomplete data
     contained only one censored observation.  This has been fixed.

{p 4 9 2}
17.  {helpb mlexp} ignored reporting options associated with factor variables.
     This has been fixed.

{p 4 9 2}
18.  {helpb nl} now allows {help weight:{bf:iweight}s} to be specified with
     option {cmd:vce(robust)}.

{p 4 9 2}
19.  {helpb teffects_postestimation##predict:predict} with option
     {cmd:lnsigma} after {helpb teffects ra}, when the specified prediction
     created one new variable instead of a group of variables, incorrectly
     exited with an error message.  This has been fixed.

{p 4 9 2}
20.  {helpb putexcel} has the following fixes:

{p 9 13 2}
     a.  {cmd:putexcel}, when writing a formula, created an invalid Excel
         formula if the formula to be written to the spreadsheet contained
         double quotes.  This has been fixed.

{p 9 13 2}
     b.  {cmd:putexcel} reset a cell's existing font format to the default
         format for the workbook and applied only the font format
         specified in {opt font()}, {opt bold()}, {opt italic()},
         {opt strikeout()}, or {opt underline()}. This has been fixed.

{p 9 13 2}
     c.  {cmd:putexcel}, when used with multiple cell formatting options
         ({opt font()}, {opt bold()}, {opt italic()}, {opt strikeout()}, or
         {opt underline()}), applied only the last specified formatting
         option.  This has been fixed.

{p 4 9 2}
21.  {helpb sem}, when option {opt covariance()} specified more than one
     covariance term and when starting values were specified for a subset of
     those covariance terms with the {opt init()} option, sometimes incorrectly
     exited with an error message.  Whether an error message was reported
     depended on the order of the terms within the {opt covariance()} option.
     For example, the option {cmd:covariance(x1*x2 (x1*x3, init(.2)))} would
     trigger this error.  This has been fixed.

{p 4 9 2}
22.  {helpb stcurve}, when plotting curves for a model that included an
     interaction between a factor variable and a continuous variable and when
     option {cmd:at()} set the continuous variable to a value that was not
     observed in the data, incorrectly reported error message
     "{error:# is not a valid level for factor variable {it:varname}}".  This
     has been fixed.

{p 4 9 2}
23.  {helpb svy} with multilevel models and survey weights specified using the
     {cmd:[pw=}{it:varname}{cmd:]} syntax ignored the weights.  An error
     message should have been issued because survey-weighted multilevel models
     require each stage-level weight variable to be {helpb svyset} using the
     stage's corresponding {cmd:weight()} option.  This has been fixed.

{p 4 9 2}
24.  {helpb vecrank}, when run in Small Stata, always exited with error
     message "{err:expression too long}".  This has been fixed.

{p 4 9 2}
25.  {helpb xtreg:xtreg, fe} with {cmd:vce(robust)} or
     {cmd:vce(cluster} {it:panelvar}{cmd:)} and exactly two observations per
     panel reported missing standard errors.  This has been fixed.

{p 4 9 2}
26.  {helpb xtreg:xtreg, mle} now has improved starting values for the
     constant-only model that is used to calculate the likelihood-ratio (LR)
     test for model fit.  In rare cases where option {opt mle} is specified
     with {cmd:xtreg} for models fit to datasets with few panels and very few
     observations per panel, the constant-only log likelihood and the LR
     statistic may change slightly.

{p 4 9 2}
27.  In the Data Editor, when a value label had been applied to a variable,
     the {help format:display format} was ignored when values of that variable
     were undefined in the value label.  This has been fixed.

{p 4 9 2}
28.  (Windows) In the {help graph editor:Graph Editor}, selecting Titles from
     the {bf:Graph} menu caused Stata to crash. This has been fixed.

{p 4 9 2}
29.  (Mac and Windows) Pressing the {hi:Tab} key to complete a filename in the
     Command window now displays a list of filenames when there is more than
     one possible match.

{p 4 9 2}
30.  (Mac and Windows) After the 05may2015 update, filename completion in the
     Command window was broken.  This has been fixed.

{p 4 9 2}
31.  (Mac) The {help SEM Builder} did not render a preview of an object as
     the object was dragged in the Builder window.  This has been fixed.

{p 4 9 2}
32.  (Mac) The Properties pane in the main Stata window showed the wrong
     variable notes for the selected variable if the variable names in the
     Variables pane were sorted by clicking the "Name" column and the selected
     variable was not in the same position when sorted by Name and by #.  This
     has been fixed.


{hline 8} {hi:update 05may2015} {hline}

{p 5 9 2}
1.  {helpb bayesmh} has the following new features:

{p 9 13 2}
     a.  {cmd:bayesmh} now supports the suboption {cmd:noglmtransform} for
         binomial regression via {cmd:likelihood(binlogit(), noglmtransform)}.
         This option allows you to fit a binomial distribution to the data.
         It requests that {cmd:bayesmh} not apply the inverse logit
         transformation to the linear predictor and is useful with
         constant-only models to directly model the probability of success.

{p 9 13 2}
     b.  {cmd:bayesmh} now supports {help fvvarlists:factor-variable}
         specifications of model parameters specified in options
         {cmd:prior()}, {cmd:block()}, {cmd:initial()}, {cmd:exclude()}, and
         {cmd:noshow()}.

{p 5 9 2}
2.  {helpb bayesgraph}, {helpb bayesstats summary}, and {helpb bayesstats ess}
    now support {help fvvarlists:factor-variable} specifications when
    referring to model parameters.

{p 5 9 2}
3.  {helpb bayesgraph} with option {opt wait} now pauses until the
    {hline 2}{cmd:more}{hline 2} condition is cleared even if
    {cmd:set more off} has been previously specified.

{p 5 9 2}
4.  {helpb codebook}, when a variable had more than 999 extended missing
    values, exited with error message "{err:options not allowed}".  This has
    been fixed.

{p 5 9 2}
5.  {helpb estat mfx}, after {helpb asclogit} or {helpb asmprobit} with a
    value label assigned to the {it:varname} specified in {bf:alternatives()},
    exited with an error if any of the strings in the value label were longer
    than 26 characters.  This has been fixed.

{p 5 9 2}
6.  Any estimation command that allowed {help fvvarlists:factor variables}
    would slow down when {helpb matsize} was set larger than 1,000 even for
    models with relatively few parameters.  This has been fixed.

{p 5 9 2}
7.  {helpb export excel}, when exporting variables with any calendar date
    format other than {cmd:%td}, incorrectly exported the variables as a daily
    date instead of respecting the weekly, monthly, quarterly, half-yearly, or
    yearly format.  This has been fixed.

{p 5 9 2}
8.  For variable names of the form {cmd:d#}, {cmd:D#}, {cmd:e#}, and {cmd:E#},
    Stata's expression parser misinterpreted some
    {help fvvarlists:factor-variable} specifications, such as {cmd:1.d1} and
    {cmd:1.e2}, as numeric literals instead of the intended indicator
    variables.  This has been fixed.

{p 5 9 2}
9.  {helpb fracreg} has the following fixes:

{p 9 13 2}
     a.  {cmd:fracreg} did not respect qualifiers {helpb if} and {helpb in}
         when verifying that the dependent variable was between the values
         zero and one.  This has been fixed.

{p 9 13 2}
     b.  {cmd:fracreg}, when levels of a {help fvvarlists:factor variable}
         were specified in parentheses, exited with error message
         "{err:variable i not found}".  This has been fixed.

{p 4 9 2}
10.  {helpb graph replay} with option {opt wait} now pauses until the
     {hline 2}{cmd:more}{hline 2} condition is cleared even if
     {cmd:set more off} has been previously specified.

{p 4 9 2}
11.  {helpb gsem_command:gsem} has the following fixes:

{p 9 13 2}
     a.  {cmd:gsem}, with a multilevel model specification and prefix
         {helpb bootstrap} or prefix {helpb jackknife}, exited with an error
         message stating the prefix is not allowed with group-level models.
         This has been fixed.

{p 9 13 2}
     b.  After the 22apr2015 update, the estimation options dialog for
         {cmd:gsem} would not submit a command.  This has been fixed.

{p 4 9 2}
12.  Stata matrix row and column names parsing logic, when presented with
     interactions where the order of factor variables was not the same in each
     term, did not properly keep track of the levels.  For example,

{p 13 17 2}
                {cmd:. matrix colnames b = 0.foreign#1.rep78 2.rep78#1.foreign}

{p 9 9 2}
     resulted in colnames

{p 13 17 2}
                {cmd:. matrix colnames b = 0.foreign#1.rep78 2.foreign#1.rep78}

{p 9 9 2}
     instead of the intended

{p 13 17 2}
                {cmd:. matrix colnames b = 0.foreign#1.rep78 1.foreign#2.rep78}

{p 9 9 2}
     This has been fixed.

{p 4 9 2}
13.  {helpb meglm}, {helpb melogit}, {helpb meprobit}, {helpb mecloglog},
     {helpb meologit}, {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg},
     and {helpb mestreg} with option {opt nolog} failed to suppress the
     iteration log as requested.  This has been fixed.

{p 4 9 2}
14.  {helpb meglm} with prefix {helpb svy} and one of options {opt eform},
     {opt irr}, or {opt or} failed to display transformed coefficients.  This
     has been fixed.

{p 4 9 2}
15.  {helpb melogit} and {helpb meologit} with prefix {helpb svy} and option
     {opt or} failed to report odds ratios instead of coefficients.  This has
     been fixed.

{p 4 9 2}
16.  {helpb mestreg} with prefix {helpb svy} has the following fixes:

{p 9 13 2}
     a.  {cmd:mestreg} with prefix {cmd:svy} exited with error message
         "{err:option distribution() required}".  This has been fixed.

{p 9 13 2}
     b.  {cmd:mestreg} with prefix {cmd:svy} and option {opt nohr} failed to
         report coefficients instead of hazard ratios.  This has been fixed.

{p 9 13 2}
     c.  {cmd:mestreg} with prefix {cmd:svy} and option {opt tratio} failed to
         report time ratios.  This has been fixed.

{p 4 9 2}
17.  {helpb ml} and Mata function {helpb mf_moptimize:moptimize()} with
     {cmd:lf1} specified as the evaluator type were passing the value {cmd:2}
     instead of {cmd:1} for {it:todo} while computing numerical second
     derivatives.  This has been fixed.

{p 4 9 2}
18.  {helpb odbc} has the following new features and fixes:

{p 9 13 2}
     a.  {helpb odbc:set odbcdriver} is a new command to specify the type of
         driver that {cmd:odbc} should use to connect to an ODBC data source.

{p 9 13 2}
     b.  In the {cmd:odbc load} dialog box, if the selected data source used
         Microsoft Access or Microsoft Excel ODBC drivers, the list of
         available tables was not displayed.  This has been fixed.

{p 4 9 2}
19.  {helpb saveold}, when the first character of a variable name was a
     multibyte Unicode character and when the first byte of that character
     would have been an invalid starting character for a variable name in an
     older version of Stata, issued an error message to that effect but still
     saved the {cmd:.dta} file rather than exiting with that error message.
     The saved {cmd:.dta} file could not be read by Stata.  {cmd:saveold} now
     exits with an error message and does not save the file.

{p 4 9 2}
20.  Seasonal difference {help tsvarlist:time-series operator} {cmd:S}{it:#}
     did not appropriately translate the zero-period difference ({cmd:S0}).
     Depending on the command with which it was specified, {cmd:S0} was
     translated to {cmd:S1} or resulted in a variable containing only zero
     values.  In all cases, typing {cmd:S0.var} is now equivalent to typing
     {cmd:var}; this translation is the same as that used for the other
     time-series operators.

{p 4 9 2}
21.  {helpb sem_command:sem}, when fitting a model with no observed exogenous
     variables, with more than one latent variable, and with at least two
     coefficients constrained to one on paths from a latent variable to its
     observed measurements, incorrectly exited with an error message.  This
     has been fixed.

{p 4 9 2}
22.  The {help sembuilder:SEM Builder}, when using a {cmd:.stsem} file created
     prior to Stata 14 and whose model was fit before saving, successfully
     opened the file but produced an error message when that model or any
     modified version of that model was refit from the Builder.  This has been
     fixed.

{p 4 9 2}
23.  {helpb xtivreg} with option {cmd:vce(bootstrap)} or option
     {cmd:vce(jackknife)} exited with an error message when an independent
     variable was included after the endogenous variable and instruments were
     specified in parentheses.  For example, the placement of variable
     {cmd:not_smsa} in

{p 13 17 2}
{cmd:. xtivreg ln_wage c.age##c.age (tenure = union south) not_smsa, vce(bootstrap)}

{p 9 9 2}
     would trigger this error.  Variables can now be specified after the
     expression in parentheses.

{p 4 9 2}
24.  Executing an operation using the https:// protocol when an internal
     content buffer was less than 100 bytes would cause Stata to exit with
     return code {search r(1)}.  This typically happened only when the results
     to be returned by the operation were very short.  This has been fixed.

{p 4 9 2}
25.  In the Data Editor, selecting one or more columns, right-clicking on the
     selection to open a context menu, and then choosing "Hide selected
     variables" or "Show only selected variables" from that menu could cause
     {help statamp:Stata/MP} and {help statase:Stata/SE} to crash.  This has
     been fixed.

{p 4 9 2}
26.  (Windows and Unix) {helpb translate} with translators {cmd:smcl2pdf},
     {cmd:log2pdf}, {cmd:txt2pdf}, {cmd:Viewer2pdf}, and {cmd:Results2pdf} now
     provides faster exporting to PDF.

{p 4 9 2}
27.  (Windows) {helpb graph use} and {helpb graph save} did not use or save,
     respectively, a graph when the current directory or the directory
     specified with the full path in the {help filename} included non-ASCII
     Unicode characters. This has been fixed.

{p 4 9 2}
28.  (Windows) In the Do-file Editor, when a subset of commands was selected,
     Stata failed to {helpb do} or {cmd:run} the selected commands when the
     full path for temporary files included non-ASCII Unicode characters. This
     has been fixed.

{p 4 9 2}
29.  (Windows) In the Review window, right-clicking and selecting "Save
     all..." or "Save selected..." would create or replace a do-file but would
     not include the commands.  This has been fixed.

{p 4 9 2}
30.  (32-bit Windows) {helpb update} failed to request that Windows elevate
     permissions to administrator status.  This could result in error
     {search r(608)} if the user did not have permission to write to the
     installation directory.  This has been fixed.

{p 4 9 2}
31.  (Windows and Mac) Pressing the {hi:Tab} key to complete a variable name
     in the Command window now displays a menu of variable names when there is
     more than one possible match.

{p 4 9 2}
32.  (Mac) The current graph disappeared when its window entered full-screen
     mode.  This has been fixed.

{p 4 9 2}
33.  (Mac) The small circle symbol in graphs was shown in the upper-left
     corner of the graph instead of in the correct location.  This has been
     fixed.

{p 4 9 2}
34.  (Mac) Files {cmd:.dta} and {cmd:.gph} did not display the correct 16x16
     icons for their file types.  This has been fixed.

{p 4 9 2}
35.  (Mac) The Do-file Editor has the following fixes:

{p 9 13 2}
     a.  Replacing text with Unicode characters resulted in the new text
         containing invalid Unicode characters instead of the Unicode
         characters that were typed.  This has been fixed.

{p 9 13 2}
     b.  Selecting a subset of commands and clicking on "Execute selection"
         from the Tools menu or clicking on the {bf:Do} button would execute
         more lines than those that were selected if the text preceding the
         selection or within the selection contained Unicode characters.  This
         has been fixed.

{p 9 13 2}
     c.  In the Do-file Editor, using the Find dialog and selecting
         "Replace all" might not replace all the text specified in "Find
         what:" if 1) the text to be replaced occurs more than once; 2) the
         length of the text specified in "Replace what:" is longer than the
         text that is being replaced; and 3) the text that is being replaced
         comes very close to the end of the document.

{p 4 9 2}
36.  (Mac) Using the Variables Manager to add or to edit a variable label
     would cause Stata to crash.  This has been fixed.

{p 4 9 2}
37.  (Unix and Mac) {helpb import excel} and {cmd:export excel} used the
     system locale as the default locale for option {cmd:locale()} when
     reading or writing extended ASCII characters.  Both commands now use
     UTF-8 as the default locale.

{p 4 9 2}
38.  (Unix GUI) On some Linux distributions, Stata either did not launch or
     did not display icons in the toolbar.  This has been fixed.

{p 4 9 2}
39.  (Unix GUI) The Do-file Editor could incorrectly determine that a text
     file contained invalid Unicode characters, depending on where the Unicode
     characters existed in the file.  This has been fixed.

{p 4 9 2}
40.  (Unix console) {helpb translate:translator set} did not allow the default
     font directory ({cmd:fontdir}) to be set for translators {cmd:smcl2pdf},
     {cmd:log2pdf}, {cmd:txt2pdf}, and {cmd:gph2pdf}.  This affected only logs
     and graph files that needed TrueType fonts when option {opt addfonts} had
     been specified with {cmd:translator set}.  This has been fixed.


{hline 8} {hi:update 22apr2015} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 15(1).

{p 5 9 2}
2.  {helpb eteffects_postestimation:estat endogenous} is a new command that
    tests the null hypothesis of no endogeneity for the treatment assignment
    after {helpb eteffects}. If no endogeneity exists, {helpb teffects} can be
    used to estimate the treatment effect.

{p 5 9 2}
3.  {helpb churdle} has improved starting values for the constant-only model,
    meaning that it can now report a likelihood-ratio test in rare cases where
    a missing value was previously reported.

{p 5 9 2}
4.  {helpb eteffects} has the following improvements and fixes:

{p 9 13 2}
     a.  {cmd:eteffects} has improved starting values for the exponential
         outcome model, meaning that many models now converge faster.

{p 9 13 2}
     b.  {cmd:eteffects} produced an error message when some treatment values
         were missing instead of excluding those observations and proceeding
         with estimation. This has been fixed.

{p 5 9 2}
5.  {helpb mixed} has the following improvements and fixes:

{p 9 13 2}
     a.  {cmd:mixed}'s option {helpb mixed##df_method:dfmethod()} now supports
	 two new suboptions, {cmd:eim} and {cmd:oim}, with the Kenward-Roger
	 and Satterthwaite DF methods.  These suboptions allow you to use
	 either the expected information matrix (the default) or the observed
	 information matrix to compute degrees of freedom.  The suboption
	 {cmd:oim} may be useful if you wish to match results from other
	 software packages that use the observed information matrix in their
	 computations.  {helpb estat df} after {cmd:mixed} now also supports
	 options {cmd:eim} and {cmd:oim} to provide the same functionality
	 when computing Kenward-Roger and Satterthwaite degrees of freedom
	 in postestimation.

{p 9 13 2}
     b.  {cmd:mixed} with option {cmd:dfmethod(repeated)} reported incorrect
	 denominator degrees of freedom or a Mata error message if two
	 conditions were true: 1) the model included one or more variables
	 that varied within subject; and 2) the first subject in the data had
	 no within-subject variation for one of those variables. This has been
	 fixed.

{p 5 9 2}
6.  {helpb bayesmh} has the following improvements and fixes:

{p 9 13 2}
     a.  {cmd:bayesmh}, contrary to the documentation, required expressions to
	 be enclosed in parentheses when specified in option
	 {cmd:likelihood(llf())}, {cmd:prior(density())}, or
	 {cmd:prior(logdensity())}.  Expressions may now be specified as
	 documented.

{p 9 13 2}
     b.  {cmd:bayesmh} displayed a nonmissing log marginal-likelihood as
	 missing when redisplaying results after estimation.  This has been
	 fixed.

{p 5 9 2}
7.  {helpb destring} with option {cmd:replace}, when specified with a variable
    that already had a characteristic named "destring", exited with the error
    message "{err:characteristic already exists}".  This has been fixed.

{p 5 9 2}
8.  {helpb margins_generate:margins} with option {opt generate()} after
    {helpb mlogit}, {helpb ologit}, and {helpb oprobit} incorrectly exited
    with the error message "{err:variable not found}".  This has been fixed.

{p 5 9 2}
9.  {helpb pause} would become stuck in an endless loop if you tried to start
    an interactive Mata session while Stata was already in a paused state.
    {cmd:pause} now returns an error message in this case.

{p 4 9 2}
10.  {helpb stcurve}, after {helpb mestreg} with one or more factor variables,
     failed to set factor variables to the levels specified in the
     {opt at()} options when plotting the curves.  This has been fixed.

{p 4 9 2}
11.  {helpb svy} with multilevel models and without stage-level weights
     specified in {helpb svyset} failed to exit with an error when multilevel
     groups were not nested within the sampling stages.  The affected commands
     are {helpb meglm}, {helpb melogit}, {helpb meprobit}, {helpb mecloglog},
     {helpb meologit}, {helpb meoprobit}, {helpb mepoisson}, {helpb menbreg},
     {helpb mestreg}, and {helpb gsem_command:gsem}.  This has been fixed.

{p 4 9 2}
12.  The {help sem_builder:SEM Builder}, when used to fit generalized SEM with
     the {it:Survey data estimation} option selected on the {bf:SE/Robust} tab
     of the GSEM estimation options dialog box, did not submit the command and
     prevented submission of all subsequent commands.  This has been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew13to14}.{p_end}

{hline}
