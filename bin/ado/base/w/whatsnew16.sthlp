{smcl}
{* *! version 1.1.8  05mar2020}{...}
{findalias asfrwhatsnew}{...}
{findalias asfrres}{...}
{findalias asfrwww}{...}
{findalias asfrstatapress}{...}
{findalias asfrstatalist}{...}
{findalias asfrstb}{...}
{findalias asfrweb}{...}
{findalias asfroffinstall}{...}
{findalias asfrupdate}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{title:Title}

{phang}
{hi:Additions to Stata since release 16.0}


{title:Description}

    Update history:

            {hi:Stata 16.0 base    26jun2019}
            {hi:Stata 16.1 base    18feb2020}
            {hi:updated to         05mar2020}

{pstd}
This file records the additions and fixes made to Stata since the release of
version 16.0.  The end of this file provides links for earlier additions and
fixes.

{pstd}
Updates are available for free over the Internet.
{update "from http://www.stata.com":Click here} to obtain the latest update,
or see {help updates} for detailed instructions.

{pstd}
The most recent changes are listed first.


{* place new entries here}{...}
{hline 8} {hi:update 05mar2020} {hline}

{p 5 9 2}
1.  Prefix {helpb bayes} ignored the adaptation option {cmd:covariance()}
    unless it was specified inside option {cmd:block()}.  This has been fixed.

{p 5 9 2}
2.  The {helpb Graph Editor}, after the 18 Feb 2020 update, failed to allow
    the selection of {helpb twoway} plots.  This has been fixed.

{p 5 9 2}
3.  {helpb margins} with option {opt dydx(varname)} after {helpb menl},
    if there was no estimated coefficient associated with {it:varname},
    produced error message "{red:variable {it:varname} not found in list}
    {red:of covariates}".  This has been fixed.

{p 5 9 2}
4.  {helpb nlogit} with option {cmd:noconstant} and with no
    alternative-specific variables produced error message
    "{red:no equations have been specified to identify the alternatives}
    {red:defined in variable {it:depvar}; see nlogit for the proper syntax}".
    This has been fixed.

{p 5 9 2}
5.  {helpb spset} generated missing values for centroid variables {cmd:_CX}
    and {cmd:_CY} when working with point shape data.  {cmd:spset} now uses
    the point data as the value for centroid variables {cmd:_CX} and
    {cmd:_CY}.


{hline 8} {hi:update 18feb2020} (Stata version 16.1) {hline}

{p 5 9 2}
1.  (GUI) The Do-file Editor has the following enhancements:

{p 9 13 2}
     a.  Existing preferences have the following new features:

{p 13 17 2}
         1.  auto-indentation when adding a new line between curly braces

{p 13 17 2}
         2.  brace snapping to the correct indent when adding a closing brace

{p 13 17 2}
         3.  deleting matched special characters (quotes, macro expansion,
             parentheses, curly braces, square brackets) when the cursor is
             between them

{p 13 17 2}
         4.  better behavior of auto-inserting closing characters

{p 9 13 2}
     b.  The Do-file Editor now supports the shortcut Alt + Up/Down arrow to
         shift selected lines up or down.

{p 9 13 2}
     c.  The Do-file Editor now supports wrapping selected text in quotes,
         parentheses, and macro expansion.  This preference is disabled by
         default.

{p 5 9 2}
2.  {helpb frame put} now allows a {varlist} to be specified at the same time
    as {helpb if} and {helpb in}.  Previously, you could only {cmd:frame}
    {cmd:put} a subset of variables or a subset of observations into a new
    frame (that is, you could not do these simultaneously).

{p 5 9 2}
3.  {helpb putdocx begin} and {helpb putdocx sectionbreak} have new option
    {cmd:margin(}{it:type}{cmd:,} {it:#}[{it:unit}]{cmd:)}, which sets the
    page margins for the document.

{p 5 9 2}
4.  {helpb meta forestplot} and {helpb meta summarize} have new option
    {cmd:transform()} that reports transformed effect sizes and CIs.  The
    following transformations are currently supported: {cmd:corr},
    {cmd:efficacy}, {cmd:exp}, {cmd:invlogit}, and {cmd:tanh}.  This option is
    useful when you wish to report your results in a metric that makes them
    easier to interpret.  For example, use {cmd:transform(corr)} to report
    correlations instead of Fisher's z values.

{p 5 9 2}
5.  {helpb mixed}, {helpb meglm}, {helpb mecloglog}, {helpb meintreg},
    {helpb melogit}, {helpb menbreg}, {helpb meologit}, {helpb meoprobit},
    {helpb mepoisson}, {helpb meprobit}, {helpb metobit}, and {helpb mestreg}
    now support factor-variables notation for random slopes in the
    random-effects equations.

{p 5 9 2}
6.  {helpb cmmixlogit} and {helpb cmxtmixlogit} have new option {cmd:or} for
    displaying exponentiated coefficients that are interpreted as odds ratios
    for alternative-specific variables and relative-risk ratios for
    case-specific variables.

{p 5 9 2}
7.  {helpb xtreg:xtreg, mle} now supports options {cmd:vce(robust)} and
    {cmd:vce(cluster} ...{cmd:)}.

{p 5 9 2}
8.  {helpb pwmean} now supports {helpb if} and {helpb in}.

{p 5 9 2}
9.  {helpb dydx} and {helpb dydx:integ} have new option {opt double} that
    specifies type {opt double} for the newly generated variable storing the
    results.  If not specified, the new variable type is determined by the
    default storage type according to {helpb set type}.

{p 4 9 2}
10.  {helpb mlmatbysum} now supports {it:varname_c} when specified for a
     single equation.

{p 4 9 2}
11.  The Java Runtime Environment that is redistributed with Stata is now
     updated to version 11.0.6+10-LTS acquired from Azul Systems.

{p 4 9 2}
12.  Prefix {helpb bayes}, when used with options {cmd:nchains()} and
     {cmd:initrandom}, failed to draw initial values from the prior
     distribution of the parameters in the chains after the first one.  Option
     {cmd:initrandom} thus had an effect only on the first chain.  This has
     been fixed.

{p 4 9 2}
13.  {helpb dsregress}, {helpb dslogit}, {helpb dspoisson}, {helpb poregress},
     {helpb poivregress}, {helpb pologit}, {helpb popoisson},
     {helpb xporegress}, {helpb xpoivregress}, {helpb xpologit}, and
     {helpb xpopoisson} now require option {cmd:controls()}.  Previously,
     when specified without option {cmd:controls()}, these commands fit the
     model without model selection.

{marker integ_newvals}{...}
{p 4 9 2}
14.  {helpb dydx} and {helpb dydx:integ} performed the final summation (the
     final step in the computation) using float precision.  They now use
     double precision.  This affects the results stored in newly generated
     variables in option {cmd:generate()} and, for {cmd:integ}, the returned
     scalar {cmd:r(integral)}.  The new results are more accurate, but the
     relative difference between the new and previously obtained results, in
     general, should not exceed 1e-7.

{p 4 9 2}
15.  {helpb estat sd}, when reporting correlations for results from
     {helpb gsem_command:gsem}, {helpb mixed}, {helpb meglm},
     {helpb mecloglog}, {helpb meintreg}, {helpb melogit}, {helpb menbreg},
     {helpb meologit}, {helpb meoprobit}, {helpb mepoisson}, {helpb meprobit},
     {helpb metobit}, or {helpb mestreg}, sometimes reported confidence limits
     outside the range of support for correlations.  This has been fixed.

{p 4 9 2}
16.  {helpb estimates store} after {helpb menl} postestimation command
     {helpb me_estat_sd:estat sd, post} produced error message
     "{err:last estimation results not found, nothing to store}".  This has
     been fixed.

{p 4 9 2}
17.  {helpb graph} objects with their line color set to {cmd:none} sometimes
     rendered black lines instead of using transparency.  This has been fixed.

{p 4 9 2}
18.  {helpb irt_group:irt}, when specified with option {cmd:group()} and an
     item variable was missing for all observations within a group,
     incorrectly exited with an unhelpful error message.  This has been fixed.

{p 4 9 2}
19.  {helpb lasso}, {helpb sqrtlasso}, and {helpb elasticnet}, when weights
     were specified using syntax {cmd:[weight =} ...{cmd:]}, defaulted to
     using {helpb weight:fweight}s.  Now the weight type must be explicitly
     specified, such as {cmd:[fweight =} ...{cmd:]}.  This is because
     {cmd:fweight}s are not allowed with cross-validation (the default method
     for selecting lambda).

{p 4 9 2}
20.  {helpb margins} has the following enhancement and fixes:

{p 9 13 2}
     a.  {cmd:margins} with {helpb svy} estimation results now includes
         standard survey information in the header.  The most common survey
         header information is the number of sample strata, the number of
         primary sampling units, and the estimated population size.

{p 9 13 2}
     b.  After the 11 Dec 2019 update, {cmd:margins} after {helpb cmclogit}
         using weights produced error message "{err:invalid syntax}".  This
         has been fixed.

{p 9 13 2}
     c.  After the 11 Dec 2019 update, {cmd:margins} with option
         {cmd:dydx()} after {helpb cmclogit}, {helpb cmmprobit}, or
         {helpb cmroprobit} using a string alternatives variable (see
         {helpb cmset}) reported a zero derivative for case-specific
         variables.  This has been fixed.

{p 9 13 2}
     d.  After the 11 Dec 2019 update, {cmd:margins} with option {cmd:at()}
         after {helpb cmclogit} used the observed instead of the requested
         values of the {cmd:at()} variables.  This has been fixed.

{p 9 13 2}
     e.  After the 11 Dec 2019 update, {cmd:margins} after {helpb cmclogit}
         could crash Stata.  This has been fixed.

{p 9 13 2}
     f.  {cmd:margins} with option {opt at()} after {helpb npregress series}
         with option {opt asis()} produced an error message saying that
         variables specified in {opt at()} were not in the list of covariates.
         This has been fixed.

{p 4 9 2}
21.  {helpb meta forestplot} and {helpb meta summarize} with option
     {cmd:cumulative()} and one of options {cmd:eform()}, {cmd:eform},
     {cmd:or}, or {cmd:rr} incorrectly exited with a Mata error message when
     the model was based on the Mantel-Haenszel method.  This has been fixed.

{p 4 9 2}
22.  {helpb meta trimfill} with option {cmd:funnel} and one of options
     {cmd:eform()}, {cmd:eform}, {cmd:or}, or {cmd:rr} produced a funnel plot
     where the estimated effect-size (ES) line incorrectly corresponded to the
     exponentiated value of the overall ES.  This line should be based on the
     natural unexponentiated value of the overall ES.  Options {cmd:eform()},
     {cmd:eform}, {cmd:or}, and {cmd:rr} should only affect the numerical
     results in the output table.  This has been fixed.

{p 4 9 2}
23.  {helpb mi estimate} with option {cmd:cmdok} and any of the mixed-effects
     {cmd:me} commands, such as {helpb melogit} or {helpb meglm}, produced the
     notes below the output table about varying numbers of groups and
     observations per group even when these numbers did not vary across
     imputations.  This has been fixed.

{p 4 9 2}
24.  {helpb mi impute mvn} with option {cmd:initmcmc()} did not respect the
     order of the specified imputation variables when assigning the supplied
     initial values to the respective parameters of the MCMC procedure.  The
     command always supplied the initial values in the order of imputation
     variables listed from the most observed to the least observed.  If
     imputation variables were not specified with the command in that order,
     the incorrect initial values could potentially lead to slower convergence
     of MCMC and thus require more iterations than needed to achieve
     convergence.  The command now supplies the initial values in the correct
     order.

{p 4 9 2}
25.  {helpb pkexamine}, {helpb pksumm}, and {helpb pkcollapse} now use
     {help whatsnew16##integ_newvals:more precise values} from {helpb integ},
     which may lead to slight differences (relative differences no larger than
     1e-6) compared with the previously obtained results.  The affected
     results are the area under the curve and statistics related to it.

{p 4 9 2}
26.  {helpb poivregress} and {helpb xpoivregress} did not produce an error
     message when the model was not identified.  It now does.

{p 4 9 2}
27.  {helpb power logrank} with option {cmd:st1()} now uses
     {help whatsnew16##integ_newvals:more precise values} from {helpb integ},
     which may lead to slight differences (relative differences no larger than
     1e-6) compared with the previously obtained results.  The affected result
     is the probability of an event computed numerically using {cmd:integ}
     when option {cmd:st1()} is specified.

{p 4 9 2}
28.  {helpb predict} after {helpb cmmixlogit} and {helpb cmxtmixlogit}, when
     the fitted model had only two alternatives and either had no
     case-specific variables with an alternative-specific constant or had one
     case-specific variable with no alternative-specific constant, exited with
     an uninformative error message.  This has been fixed.

{p 4 9 2}
29.  The {help python:Python environment} within Stata has the following
     fixes:

{p 9 13 2}
     a.  When using method
         {browse "https://www.stata.com/python/api16/Macro.html#sfi.Macro.getGlobal":{bf:Macro.getGlobal(}{it:name}{bf:)}} defined in
         {browse "https://www.stata.com/python/api16/":Stata's Python API documentation}
         to retrieve the values of the global macros {cmd:S_FN} and
         {cmd:S_FNDATE} with a dataset in memory, Python returned an empty
         string for both of them.  This has been fixed.

{p 9 13 2}
     b.  When using method
         {browse "https://www.stata.com/python/api16/SFIToolkit.html#sfi.SFIToolkit.display":{bf:SFIToolkit.display(}{it:s}{bf:,} {it:asis=False}{bf:)}}
         defined in
         {browse "https://www.stata.com/python/api16/":Stata's Python API documentation}
         within a compound statement, such as {cmd:for}, {cmd:while},
         functions, etc., Python displayed the content {it:s} with a line
         terminator at the end.  This has been fixed.  It now displays the
         content without adding a line terminator at the end.

{p 9 13 2}
     c.  In a do-file when running Python code defined within
         {cmd:python}[{cmd::}] and {cmd:end} and when there was a compound
         statement, such as {cmd:for}, {cmd:while}, etc., before
         {cmd:stata:}, {it:cmd} failed to execute the specified Stata command
         within Python.  This has been fixed.

{p 4 9 2}
30.  {helpb suest} specified with {helpb tobit} estimation results on
     {it:depvar} having more than 12 characters incorrectly exited with
     an unhelpful error message.  This has been fixed.

{p 4 9 2}
31.  (Mac) A password edit field in a programmable dialog always returned an
     empty string regardless of what had been entered.  This has been fixed.

{p 4 9 2}
32.  (Unix) The Data Editor's filter dialog sometimes incorrectly reported
     that an {helpb if} expression was invalid.  This has been fixed.


{hline 8} {hi:update 08jan2020} {hline}

{p 5 9 2}
1.  {helpb icd10cm} and {helpb icd10pcs} have been updated for the 2020 fiscal
    year.  Type {cmd:icd10cm query} or {cmd:icd10pcs query} to see information
    about the changes.

{p 5 9 2}
2.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 19(4).

{p 5 9 2}
3.  {helpb eintreg}, {helpb eoprobit}, {helpb eprobit}, {helpb eregress},
    {helpb xteintreg}, {helpb xteoprobit}, {helpb xteprobit}, and
    {helpb xteregress} occasionally issued error messages related to initial
    values when they should not have.  These error messages included
    "{err:initial vector: matrix must be dimension #}",
    "{err:could not calculate initial values; try specifying {bf:from()}}",
    and "{err:initial vector: extra parameter <matrix_stripe> found}".  This
    has been fixed.

{p 5 9 2}
4.  {helpb meta forestplot}, in the case of missing effect sizes in variable
    {cmd:_meta_es} due to an {cmd:if} or {cmd:in} specification with
    {helpb meta set} or {helpb meta esize}, failed to exclude the
    corresponding studies from the forest plot.  This has been fixed.

{p 5 9 2}
5.  {helpb meta summarize}, when specified with option {cmd:nostudies} and one
    of options {cmd:eform}[{cmd:()}], {cmd:or}, or {cmd:rr}, produced
    incorrect standard errors of the exponentiated overall effect size.  This
    has been fixed.

{p 5 9 2}
6.  {helpb zioprobit_postestimation##predict:predict} with options {cmd:stdp}
    or {cmd:stdpinf} after {helpb zioprobit}, in the rare case of no
    independent variables in the main equation, produced incorrect
    predictions.  Option {cmd:stdp} produced standard errors of the linear
    prediction for the inflation equation, whereas {cmd:stdpinf} produced
    standard errors for the first cutpoint.  This has been fixed.

{p 5 9 2}
7.  {helpb zioprobit_postestimation##predict:predict, scores} after
    {helpb zioprobit} did not respect {cmd:if} and {cmd:in} conditions and in
    most cases exited with a Mata error.  This has been fixed.


{hline 8} {hi:update 11dec2019} {hline}

{p 5 9 2}
1.  {helpb margins} after {helpb cmclogit}, {helpb cmmprobit},
    {helpb cmroprobit}, {helpb cmmixlogit}, and {helpb cmxtmixlogit} is now
    much faster.

{p 5 9 2}
2.  {helpb power} and {helpb ciwidth} with user-defined methods have the
    following enhancement and fixes:

{p 9 13 2}
     a.  With multiple computations, performed when multiple values are
	 specified in options or arguments, the commands no longer exit with
	 an error message if it occurs in one of the computations.  As with
	 official methods, the commands proceed with all computations but
	 display a warning at the bottom of the output table about failed
	 computations.

{p 9 13 2}
     b.  With two-sample methods and multiple computations, the commands
	 failed to perform certain checks of common options, such as checking
	 that the group-specific sample sizes specified in options {cmd:n1()}
	 or {cmd:n2()} do not exceed the total sample size specified in option
	 {cmd:n()}.  The commands now produce a warning about the failed
	 computations in which such checks were not satisfied.

{p 9 13 2}
     c.  With two-sample methods, the commands failed to store scalars
         {cmd:N1}, {cmd:N2}, and {cmd:nratio}.  This has been fixed.

{p 5 9 2}
3.  Stata function {helpb autocode:autocode({it:x},{it:n},{it:x0},{it:x1})}
    returned a missing value for {it:n} >= 1,000.  The domain of {it:n} is
    updated to integers from 1 to 10,000.

{p 5 9 2}
4.  {helpb margins} after {helpb cmclogit}, {helpb cmmprobit},
    {helpb cmroprobit}, {helpb cmmixlogit}, or {helpb cmxtmixlogit} when
    specified with option {cmd:vce(unconditional)} and one of options
    {cmd:dydx(x)}, {cmd:dyex(x)}, {cmd:eydx(x)}, or {cmd:eyex(x)}, where x is
    an alternative-specific covariate, reported the delta method standard
    errors instead of the unconditional standard errors.  This has been fixed.

{p 5 9 2}
5.  Prefix {helpb bayes_prefix:bayes} with option {cmd:dryrun} and all 
    {help me:multilevel mixed-effects commands} except {cmd:mixed} took a long
    time to produce the results.  This has been fixed.

{p 5 9 2}
6.  {helpb predict} after {helpb cmmixlogit} and {helpb cmxtmixlogit} always
    used casewise deletion to omit observations because of missing values in
    covariates (unless undocumented option {cmd:altwise} was specified).
    {cmd:predict} now deletes observations as documented, using casewise
    deletion after estimation with casewise deletion and using alternativewise
    deletion after estimation with alternativewise deletion.

{p 5 9 2}
7.  {helpb stcurve} after {helpb stintreg}, when all left endpoints were
    missing for left-censored observations, produced a graph where the
    analysis time did not include time 0.  (The left endpoint being missing is
    the same as setting the left endpoint to 0.)  This has been fixed.

{p 5 9 2}
8.  (Stata/MP) Stata functions {helpb lnmvnormalden()},
    {helpb lnwishartden()}, and {helpb lniwishartden()} were mistakenly
    allowed to execute in parallel in Stata/MP, causing Stata to crash.  This
    has been fixed.

{p 5 9 2}
9.  (Mac) Because of a bug in macOS 10.15 (Catalina), opening the Save dialog
    caused Stata to crash in rare cases.  Stata now uses a different method
    for opening the Save dialog to avoid the problem.


{hline 8} {hi:update 14nov2019} {hline}

{p 5 9 2}
1.  {helpb margins} has the following fixes:

{p 9 13 2}
     a.  {cmd:margins} after {helpb cmclogit}, {helpb cmmixlogit},
	 {helpb cmmprobit}, {helpb cmroprobit}, or {helpb cmxtmixlogit} and
	 when specified with option {opt dyex(x)} or {opt eyex(x)}, where
	 {it:x} is an alternative-specific covariate, reported incorrect
	 elasticity values for {opt outcome(o)} and {opt alternative(a)} when
	 {it:o}!={it:a}.  This has been fixed.

{p 9 13 2}
     b.  {cmd:margins} after {helpb ologit} or {helpb oprobit} where the
	 dependent variable contained noninteger values sometimes exited with
	 error message

		 {err:outcome ... not found}
		 {err:option {bf:outcome()} must be either a value of y}
		 {err:or #1, #2, ...}

{p 13 13 2}
         for the default predictions.  This has been fixed.

{p 5 9 2}
2.  {helpb stepwise} since the 16oct2019 update stopped working with
    {helpb mlogit} because all {it:indepvars} were omitted even when they were
    not part of a collinearity.  This has been fixed.

{p 5 9 2}
3.  (Mac) The 05nov2019 update introduced a bug in some of Stata's dialog
    boxes that could potentially cause a crash.  This has been fixed.


{hline 8} {hi:update 05nov2019} {hline}

{p 5 9 2}
1.  {helpb meta forestplot} has the following new features and fixes:

{p 9 13 2}
     a.  {cmd:meta forestplot} now allows you to specify variables from your
         dataset as columns in a forest plot. For instance, you may now add
         variables {cmd:x1} and {cmd:x2} to the forest plot by typing

{p 17 17 2}
             {cmd:. meta forestplot _id x1 _plot _esci x2}

{p 9 13 2}
     b.  {cmd:meta forestplot} has new options {cmd:predinterval} and
         {opt predinterval(predspec)} to compute and display a prediction
         interval for the overall effect size on a forest plot.  When either
         option is specified, the whiskers are added to the overall effect
         diamond and span the width of the prediction interval.  You may
         customize the look of whiskers with {opt predinterval(predspec)}.

{p 9 13 2}
     c.  {cmd:meta forestplot} has new options {cmd:esrefline} and
         {opt esrefline(line_options)} that draw a vertical line at the
         overall effect-size value.  You may customize the look of the line
         with {opt esrefline(line_options)}.

{p 9 13 2}
     d.  {cmd:meta forestplot} has new options {cmd:nullrefline} and
         {opt nullrefline(nullopts)} that draw a vertical line at the null
         value that corresponds to no overall effect.  You may customize the
         look of the line with {opt nullrefline(nullopts)}.  {it:nullopts}
         also include suboptions {cmd:favorsleft()} and {cmd:favorsright()}
         that can be used to annotate the sides of the forest graph favoring
         treatment or control.

{p 9 13 2}
     e.  {cmd:meta forestplot} has new option {cmd:customoverall()} that draws
         a custom-defined diamond representing an overall effect size.  This
         option can be repeated to include multiple custom diamonds.  It is
         useful to display the results of multiple meta-analyses, such as
         those from different meta-analysis models (for example, common versus
         random).

{p 9 13 2}
     f.  {cmd:meta forestplot} has new options {cmd:insidemarker} and
         {opt insidemarker(marker_options)} that add a marker (an orange
         circle, by default) at the center of study markers.  You may
         customize the look of the added markers with
         {opt insidemarker(marker_options)}.  These options are used to more
         easily identify the study-specific effect-size values.  This is
         particularly helpful with less precise studies that have large
         squares.

{p 9 13 2}
     g.  {cmd:meta forestplot} has new option {opt sort(varlist)} that sorts
         the studies in ascending or descending order based on the values of
         variables in {it:varlist}.  {it:varlist} may contain string and
         numeric variables.  You can sort studies with respect to effect-size
         magnitudes, study precision, and more.

{p 9 13 2}
     h.  {cmd:meta forestplot} without option {cmd:subgroup()} or option
         {cmd:cumulative()} failed to respect the sort order set by
         {helpb meta esize} or {helpb meta set}.  This has been fixed.

{p 9 13 2}
     i.  {cmd:meta forestplot} with column {cmd:_esci} put too much space
         between the opening square bracket and the lower confidence bound.
         This has been fixed.

{p 5 9 2}
2.  {helpb meta set} with the CI specification has new option
    {cmd:civartolerance()} that specifies the tolerance to check whether the
    specified CIs are symmetric.  The default tolerance is 1e-6.

{p 9 9 2}
    {cmd:meta set} expects that the effect sizes and measures of their
    precision (such as CIs) are specified in the metric closest to normality,
    which implies symmetric CIs.  Effect sizes and their CIs are often
    reported in the original metric and with limited precision that, after the
    normalizing transformation, may lead to asymmetric CIs.  In that case, the
    default of 1e-6 may be too stringent.  You may use {cmd:civartolerance()}
    to loosen the default.

{p 5 9 2}
3.  {helpb meta summarize} has the following new feature and a fix:

{p 9 13 2}
     a.  {cmd:meta summarize} has new option {opt sort(varlist)} that sorts
         the studies in ascending or descending order based on the values of
         variables in {it:varlist}.  {it:varlist} may contain string and
         numeric variables.  You can sort studies with respect to effect-size
         magnitudes, study precision, and more.

{p 9 13 2}
     b.  {cmd:meta summarize} with option {cmd:predinterval} or
         {cmd:predinterval()} failed to exponentiate the prediction interval
         when one of options {cmd:eform}, {cmd:eform()}, {cmd:or}, or {cmd:rr}
         was specified.  This has been fixed.

{p 5 9 2}
4.  {helpb estat icc} is now supported after {helpb mecloglog} and
    {helpb meglm} with the complementary log-log link.

{p 5 9 2}
5.  The Java Runtime Environment that is redistributed with Stata is now
    updated to version 11.0.5+10-LTS acquired from Azul Systems.

{p 5 9 2}
6.  {helpb isid} with string variables in {it:varlist} now issues a note if
    uniqueness is due to leading or trailing blank spaces.

{p 5 9 2}
7.  {helpb graph} has the following new features and fixes:

{p 9 13 2}
     a.  With {help marker_options}, when using option {cmd:msangle()} to
         specify a rotation angle for the marker symbol, Stata now rotates the
         marker symbol in a counter-clockwise direction instead of a clockwise
         direction.

{p 9 13 2}
     b.  {cmd:graph} axes were counting characters instead of computing the
         length of axis labels, sometimes resulting in cropped or otherwise
         incorrectly measured axis labels.  This has been fixed.

{p 9 13 2}
     c.  {cmd:graph}, when a single-line tick label was specified after a
         multi-line tick label, produced the wrong vertical alignment of the
         single-line tick label.  This has been fixed.

{p 9 13 2}
     d.  {helpb scatter} with numeric marker labels, when also specified with
         options {cmd:msymbol(none)} and {cmd:mlabposition(0)}, ignored option
         {opt mlabformat(%fmt)}, even when it was correctly specified.  This
         has been fixed.

{p 5 9 2}
8.  {helpb ciwidth} and {helpb power} with user-defined methods, when the
    length of {it:usermethod} was too long, exited with an incorrect error
    message. The commands now check that the length of {it:usermethod} does
    not exceed 14 characters with {cmd:ciwidth} and 16 characters with
    {cmd:power}, and they issue the appropriate error message if it does.

{p 5 9 2}
9.  {helpb levelsof} did not properly handle {bf:r()} results within an
    {cmd:if} expression (they were treated as missing values).  This has been
    fixed.

{p 4 9 2}
10.  {helpb manova_postestimation##manovatest:manovatest} since the release of
     Stata 16 (26jun2019), when testing results with fewer than six factor
     levels, reported contrast elements and other seemingly random values in
     the table instead of the test statistics, degrees of freedom, and
     p-values.  In most cases, the reported values would be obviously wrong.
     The posted {cmd:r()} results were correct.  This has been fixed.

{p 4 9 2}
11.  {helpb cm_margins:margins}, working with weighted estimation results from
     supported {bf:[CM]} estimation commands, produced incorrect continuous
     marginal effects and standard errors for alternative-specific predictors.
     The reported values were off by a factor of {it:C}/{it:sum_w}, where
     {it:C} is the number of cases in the estimation sample and {it:sum_w} is
     the sum of the weights, one from each case.  This has been fixed.

{p 4 9 2}
12.  {helpb marginsplot} with option {opt derivlabels} failed to use
     variable labels for continuous marginal effects when the current
     {helpb margins} results were constructed without factor variables in
     {it:marginlist}.  This has been fixed.

{p 4 9 2}
13.  {helpb mean}, {helpb proportion}, and {helpb total}, when
     factor-variables notation was applied to a variable with negative values,
     exited with error message
     "{error:factor variables may not contain negative values}", even when
     observations with negative values were not part of the estimation sample.
     This has been fixed.

{p 4 9 2}
14.  (Unix GUI) The "Wrap lines" menu can be set globally or as a tab-specific
     setting.  When switching between tabs, the "Wrap lines" setting was not
     always honored.  This has been fixed.


{hline 8} {hi:update 16oct2019} {hline}

{p 5 9 2}
1.  In the File menu, new menu item "Open data subset..." allows you to select
    a subset of data from your {cmd:.dta} file on disk.

{p 5 9 2}
2.  {helpb graph} has the following new features:

{p 9 13 2}
     a.  {cmd:graph} options {cmd:xsize()} and {cmd:ysize()} now allow
         specifying sizes in printer points, inches, and centimeters.  For
         example, you could specify {cmd:288pt}, {cmd:4in}, or {cmd:10.16cm}.
         When the units are not specified, inches are assumed.

{p 9 13 2}
     b.  New graph marker label option {opth mlabf:ormat(%fmt)} specifies the
         format for marker labels.  See {manhelpi marker_label_options G-3}.

{p 9 13 2}
     c.  The maximum graph size is now 100 inches.

{p 5 9 2}
3.  {helpb estat icc} is now supported after {helpb meoprobit},
    {helpb meologit}, and {helpb meglm} with the ordinal family and probit or
    logit links.

{p 5 9 2}
4.  {helpb nestreg} now supports factor-variables notation.  The old behavior
    (that is, not allowing factor-variables notation) is preserved under
    version control.

{p 5 9 2}
5.  {helpb stepwise} now supports factor-variables notation.  The old behavior
    (that is, not allowing factor-variables notation) is preserved under
    version control.

{p 5 9 2}
6.  {helpb npregress series} has the following improvements:

{p 9 13 2}
     a.  New option {opt distinct()} enables the minimum number of distinct
         values allowed in continuous covariates to be modified from its
         default of 10.

{p 9 13 2}
     b.  If a continuous variable specified in option {opt asis()} had less
         than 10 distinct values, Stata produced an error message.  Now
         variables in {opt asis()} are allowed to enter the model as specified
         regardless of the number of distinct values.

{p 5 9 2}
7.  New setting {helpb set docx:set docx_hardbreak} controls whether a space
    is added after each hard line break in a text block created by
    {helpb putdocx textblock}.  The setting defaults to {cmd:off}, indicating
    that spaces are inserted exactly as typed in the text block.  Type
    {cmd:set docx_hardbreak on} to insert a space at the beginning of all
    nonempty lines, excluding the first line in the block of text and the
    first line of each paragraph.

{p 5 9 2}
8.  New setting {helpb set docx:set docx_paramode} controls whether
    text following an empty line within the text block created by
    {helpb putdocx textblock} should be treated as the start of a new
    paragraph.  The setting defaults to {cmd:off}, indicating that the entire
    text block is to be treated as a single paragraph.  Type
    {cmd:set docx_paramode on} to start a new paragraph with text that follows
    an empty line.

{p 5 9 2}
9.  {cmd:putdocx} has the following improvements:

{p 9 13 2}
     a.  {helpb putdocx textblock:putdocx textblock begin} now sets the
         paragraph it adds as the current paragraph.  Thus, subsequent text
         that is added using {helpb putdocx text} is now added to the
         paragraph created by {cmd:putdocx textblock begin}.

{p 9 13 2}
     b.  {helpb putdocx textblock} has new option {opt paramode}, which
         signals that text following an empty line within the text block
         should be treated as the start of a new paragraph.

{p 9 13 2}
     c.  {helpb putdocx textblock} has new option {opt hardbreak}, which adds
         a space after each hard line break in the text block.  When
         {opt hardbreak} is specified, a space is inserted at the beginning of
         all nonempty lines, excluding the first line in the block of text and
         the first line of each paragraph.

{p 9 13 2}
     d.  {helpb putdocx textblock:putdocx textblock begin} now allows
         {help putdocx_paragraph##paraopts:paragraph options} for specifying
         the style, font, alignment, indentation, and other attributes of the
         paragraph.

{p 9 13 2}
     e.  Within a block of text created by {helpb putdocx textblock}, the
         {helpb dynamic_tags:dd_docx_display} dynamic tag now supports text
         option {opt hyperlink()}, which adds the text as a hyperlink.

{p 9 13 2}
     f.  Within a block of text created by {helpb putdocx textblock}, the
         {helpb dynamic_tags:dd_docx_display} dynamic tag now supports text
         option {opt trim}, which removes the leading and trailing spaces in
         the text to be added.

{p 9 13 2}
     g.  {helpb putdocx text} and {helpb putdocx table} have new option
         {opt hyperlink()}, which adds the text as a hyperlink.

{p 9 13 2}
     h.  {helpb putdocx text} and {helpb putdocx table} have new option
         {opt trim}, which removes the leading and trailing spaces in the text
         to be added.

{p 9 13 2}
     i.  {helpb putdocx_begin:putdocx save} and
         {helpb putdocx_begin:putdocx append} now provide a message with a
         clickable link that allows you to open the saved {cmd:.docx} file.
         New option {cmd:nomsg} allows you to suppress this message.

{p 4 9 2}
10.  {helpb putpdf_begin:putpdf save} now provides a message with a clickable
     link that allows you to open the saved {cmd:.pdf} file.  New option
     {cmd:nomsg} allows you to suppress this message.

{p 4 9 2}
11.  {helpb frame post} was changed in the 30sep2019 update to not overwrite
     {helpb stored_results:r()} {help stored_results:results} previously in
     memory.  With that change, {cmd:frame post} could no longer directly
     access those {cmd:r()} results.  This has been fixed.

{p 4 9 2}
12.  {helpb gsem_command:gsem} and {helpb irt}, when option {cmd:group()}
     specified a variable that contained negative or noninteger values, failed
     to exit with an appropriate error message.  This has been fixed.

{p 4 9 2}
13.  {helpb irt}, when item variables contained negative values, failed to
     exit with an appropriate error message.  This has been fixed.

{p 4 9 2}
14.  {helpb loadingplot}, when three or more factors were specified to be
     plotted and the number of variables in the current estimation result
     exceeded the number of observations, exited with error message
     "{error:already preserved}" instead of producing the requested loadings
     plot.  This has been fixed.

{p 4 9 2}
15.  {helpb mean}, {helpb ratio}, and {helpb total}, when specified with
     option {opt over()} that identified a single observation in one of the
     groups, exited with error message
     "{error:estimates post: matrix has missing values}" instead of posting a
     zero-valued variance that is reported as missing.  This has been fixed.

{p 4 9 2}
16.  {helpb stcrreg}, when used with weights, did not properly store the
     weights expression with a leading equal sign in {cmd:e(wexp)}, which
     might cause subsequent commands, such as {helpb margins}, to fail.  This
     has been fixed.

{p 4 9 2}
17.  (Stata/MP) Mata function {helpb mf_cross:cross({it:X},{it:w},{it:Z})},
     when specified with a view for {it:w} and when matrices {it:X} and {it:Z}
     were not the same matrix, returned a matrix filled with missing values
     even when it should not have.  This has been fixed.

{p 4 9 2}
18.  (Stata/MP) Mata function
     {helpb mf_quadcrossdev:quadcrossdev({it:X}, {it:x}, {it:Z}, {it:z})},
     when cols({it:X}) > 250 and cols({it:Z}) < cols({it:X}), could crash
     Stata.  This has been fixed.

{p 4 9 2}
19.  (Stata/MP) {helpb regress}, when specified with more than 16,379
     variables, exited with error message
     "{error:op. sys. refuses to provide memory}" even when enough memory was
     available.  This has been fixed.


{hline 8} {hi:update 30sep2019} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 19(3).

{p 5 9 2}
2.  The asterisk in {helpb describe}'s output that indicates a variable has
    {help notes} may now be clicked to list the notes for that variable.

{p 5 9 2}
3.  {helpb frame} has the following fixes:

{p 9 13 2}
     a.  When more than one frame with a {help tempname:temporary name} was
	 created at the same time, some of the temporary frames would persist
	 in memory until a few subsequent commands had executed.  They are now
	 removed as soon as they should be.

{p 9 13 2}
     b.  When working with frames, if your current frame had {it:k} variables
	 and you then created a {help tempvar:temporary variable} in that
	 frame, and if you then switched to a different frame that had more
	 than {it:k} variables, and your do- or ado-file exited while the
	 second frame was current, only the first {it:k} variables of the
	 second frame would be retained.  This has been fixed.

{p 9 13 2}
     c.  If a frame that had been {helpb preserve:preserve}d was subsequently
	 destroyed and re-created, it would not be restored by explicitly
	 typing command {cmd:restore}.  For example,

                 {cmd:frame change b}
                 {cmd:preserve}
                 ...
                 {cmd:frame copy a b, replace}
                 ...
                 {cmd:restore}

{p 13 13 2}
         This has been fixed.

{p 9 13 2}
     d.  {helpb frame copy}, when the destination frame was the current frame,
         issued an error that the destination frame already existed even if
         option {cmd:replace} was specified.  This has been fixed.

{p 9 13 2}
     e.  {helpb frame post} overwrote {helpb stored_results:r()}
	 {help stored_results:results} previously in memory.  It now leaves
	 previous {cmd:r()} results, if any, as they were.

{p 5 9 2}
4.  {helpb graph export}, when exporting to a PDF file from a graph that
    contained {helpb graph twoway line:twoway line} connected lines, in rare
    cases incorrectly exited with error message
    "{err:unable to save PDF file}".  This bug was partially fixed in the
    23aug2019 update and is now fully fixed.

{p 5 9 2}
5.  {help graph hbar:Horizontal bar graphs}, when the label size on the y axis
    was specified using points, inches, or centimeters and when labels were
    requested for the bars, mispositioned the bar labels if the graph was
    restored from a saved file or if the graph was combined using
    {helpb graph combine}.  This has been fixed.

{p 5 9 2}
6.  {helpb import dbase}, in the rare case where rows contained binary null
    data, incorrectly imported those rows, shifting the remaining data.  This
    has been fixed.

{p 5 9 2}
7.  From the release of Stata 16,
    {helpb import excel:import excel {it:filename}} unintentionally returned
    two undocumented results, {cmd:r(N)} and {cmd:r(k)}.  Thus, all {cmd:r()}
    results returned by {cmd:import} {cmd:excel} {it:filename}{cmd:,}
    {cmd:describe} were removed.  Now {cmd:import excel} {it:filename}
    returns nothing, preserving the {cmd:r()} results from
    {cmd:import} {cmd:excel} {it:filename}{cmd:, describe}.

{p 5 9 2}
8.  {helpb gmm_postestimation##predict:predict}, when called under version
    14.1 or older and using {helpb gmm} estimation results, incorrectly
    defaulted to option {cmd:xb} instead of option {cmd:residuals}.  This has
    been fixed.

{p 5 9 2}
9.  {helpb symmetry}, specified with data where a matched-pair sample size was
    larger than 32,740, exited with error message
    "{error:matrix not symmetric}".  This has been fixed.

{p 4 9 2}
10.  {helpb teffects_psmatch##options_table:teffects psmatch} and
     {helpb teffects_nnmatch##options_table:teffects nnmatch} with option
     {cmd:generate(}{it:stub}{cmd:)} crashed Stata if the number of new
     variables created exceeded the maximum number of variables permitted in
     Stata; see {helpb memory:set maxvar}.  This has been fixed.

{p 4 9 2}
11.  {helpb unzipfile} with a filename specified as an absolute path exited
     with error message "{error:file not found}".  This has been fixed.

{p 4 9 2}
12.  (Windows) The Do-file Editor Replace dialog ignored when the
     "Match whole word only" checkbox was checked.  This has been fixed.

{p 4 9 2}
13.  (Mac) Closing a Do-file Editor window on macOS 10.12 or earlier could
     cause Stata to crash.  This has been fixed.

{p 4 9 2}
14.  (Unix) When saving a file from the Do-file Editor, Stata now appends
     an end-of-line delimiter to the last line of the file if one does not
     already exist.


{hline 8} {hi:update 23aug2019} {hline}

{p 5 9 2}
1.  {helpb import sas} and {helpb import spss} have new option {cmd:encode()}
    for specifying a file's encoding.

{p 5 9 2}
2.  {helpb bayesmh} containing {cmd:prior()} specifications with a matrix
    definition produced an error message indicating there was an unexpected
    token.  This has been fixed.

{p 5 9 2}
3.  {helpb bootstrap} with a user-defined command that used time-series
    operators exited with an uninformative error message.  This has been
    fixed.

{p 5 9 2}
4.  {helpb export sasxport8} with option {cmd:vallabfile} and with extension
    {cmd:.v8xpt} specified with the filename overwrote the export filename
    with the SAS code file.  This has been fixed.

{p 5 9 2}
5.  {helpb graph export}, when exporting to a PDF file from a graph that
    contained {helpb graph twoway line:twoway line} connected lines, in rare
    cases incorrectly exited with error message
    "{err:unable to save PDF file}".  This has been fixed.

{p 5 9 2}
6.  {helpb import sas} with option {cmd:bcat()} incorrectly read in
    value-label definitions that did not have a name associated with them.
    This has been fixed.

{p 5 9 2}
7.  Mata function {helpb mf_st_vlexists:st_vlload()} caused Stata to crash
    when the second and third arguments passed to it were the same matrix.  It
    now issues an error message in this case.

{p 5 9 2}
8.  {helpb putdocx paragraph} and {helpb putdocx table}, when inserting an
    image into the header or footer of a document by using option
    {cmd:toheader()} or {cmd:tofooter()}, failed to display the image.  This
    has been fixed.

{p 5 9 2}
9.  {helpb reshape} with large {it:stub} numbers (those rounded because of
    floating-point precision) produced a faulty dataset and displayed the note
    "(note: {it:variable} not found)".  This has been fixed.

{p 4 9 2}
10.  {helpb ttest} with option {cmd:by()} now allows the order of the mean
     difference to be reversed using new option {cmd:reverse}.  With
     {cmd:reverse}, the mean of the group with the smallest category is
     subtracted from the mean of the group with the largest category.  The
     opposite is true by default.

{p 4 9 2}
11.  Stata incorrectly employed user version control for allowing
     abbreviations of matrix-stripe names in the following:  Stata functions
     {helpb colnumb()} and {helpb rownumb()}; Stata macro functions
     {helpb macro##macro_fcn::colnumb} and {helpb macro##macro_fcn::rownumb};
     and Mata functions {helpb mf_st_ms_utils:st_matrixcolnumb()} and
     {helpb mf_st_ms_utils:st_matrixrownumb()}.  The corrected behavior
     employs regular version control in these cases.

{p 4 9 2}
12.  The Java Runtime Environment that is redistributed with Stata is now
     updated to version 11.0.4+11-LTS acquired from Azul Systems.


{hline 8} {hi:update 21aug2019} {hline}

{p 5 9 2}
1.  {helpb dyndoc} and {helpb markdown} with option {cmd:docx} and a source
    file containing non-ASCII Unicode characters, and when the charset was not
    specified using the HTML <meta charset> tag, might have caused the
    generated {bf:.docx} file to contain garbled text depending on the length
    of the source file and the position of the non-ASCII Unicode characters.
    This has been fixed.

{p 5 9 2}
2.  {helpb meta set} {it:esvar} {it:cilvar} {it:ciuvar} now checks that the
    confidence intervals defined by variables {it:cilvar} and {it:ciuvar} are
    symmetric to ensure that standard errors stored in {cmd:_meta_se} are
    correct.  An error message is produced otherwise.

{p 5 9 2}
3.  {helpb threshold_postestimation##predict:predict} after {helpb threshold}
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
	 one-step-ahead predictions in those periods, just as documented.

{p 9 13 2}
     d.  {cmd:predict, stdp} after {cmd:threshold} reported the variance (the
         square of the standard error) rather than the standard error.  This
         has been fixed.

{p 9 13 2}
     e.  {cmd:predict} after {cmd:threshold} in the rare and degenerate case
         where the threshold model specified no thresholds (a model that could
         be fit using {helpb regress}) incorrectly exited with uninformative
         error.  This has been fixed.

{p 5 9 2}
4.  {helpb putdocx textfile} did not properly handle non-ASCII Unicode
    characters in the source text file.  They appeared garbled in the produced
    {bf:.docx} file.  This has been fixed.

{p 5 9 2}
5.  {helpb threshold}, when fit with missing values in the dependent variable
    or if the sample was restricted using {it:if} or {it:in}, recorded too
    many region-specific observations in {cmd:e(nobs)}.  This has been fixed.
    The regression results were unaffected.


{hline 8} {hi:update 01aug2019} {hline}

{p 5 9 2}
1.  {helpb bayesmh} and {helpb menl} containing expressions that include the
    logical and, {bf:&}, or logical or, {bf:|}, produced an error message
    indicating there was an unexpected token.  This has been fixed.

{p 5 9 2}
2.  In the Do-file Editor, the auto completion for
    {help quotes##single:single quotes} ({cmd:`} and {cmd:'}) now works the
    same as it does for parentheses, brackets, and curly braces.

{p 5 9 2}
3.  {helpb marginsplot} has the following improvements:

{p 9 13 2}
     a.  {cmd:marginsplot} has new option {cmd:derivlabels}.
         {cmd:derivlabels} specifies that {cmd:marginsplot} use variable
         labels attached to marginal-effects variables in titles and legends.

{p 9 13 2}
     b.  {cmd:marginsplot} has improved logic for detecting not-estimable
         margins.  Prior to this change, in the rare case when {cmd:margins}
         reported a nonmissing margin estimate with the note {cmd:(omitted)}
         or {cmd:(empty)}, {cmd:marginsplot} would not plot the reported
         estimate.

{p 5 9 2}
4.  {helpb pwcompare} with option {cmd:groups} and
    {helpb margins_pwcompare:margins, pwcompare(groups)}, when specified with
    terms having more than three levels and unequal standard errors, on rare
    occasions failed to identify all the groups.  This has been fixed.

{p 5 9 2}
5.  When {helpb set emptycells:set emptycells drop} was in effect, Stata
    incorrectly dropped a single-factor noninteraction term if it did not
    contain a nonempty omitted level.  This has been fixed.

{p 5 9 2}
6.  {helpb test} {cmd:[}{it:eqno}{cmd:]}, when used with estimation results
    having a large number of equations, incorrectly exited with error message
    "{err:insufficient memory}".  For Stata/IC, large is greater than 20
    equations.  For Stata/SE, large is greater than 104 equations.  For
    Stata/MP, large is greater than 255 equations.  This has been fixed.

{p 5 9 2}
7.  {helpb use:use {it:varlist} using {it:filename}} in rare cases crashed
    Stata or created an improperly sorted dataset.  This has been fixed.

{p 9 9 2}
    For this problem to happen, the dataset in {it:filename} needed to be
    sorted by one or more variables and the {it:varlist} must have contained
    one or more of the first variables from the sorted variable list in
    {it:filename}.  For example, if the sorted list from {it:filename} is
    {cmd:x1}, {cmd:x2}, {cmd:x3}, and you typed one of the following

		{cmd:use x1 using} {it:filename}
                {cmd:use x1 x2 using} {it:filename}
                {cmd:use x1 x2 x3 using} {it:filename}

{p 9 9 2}
    an improper dataset could be created where the sorted list contained junk.
    This could cause a crash.  In the rare case where "junk" looked like a
    variable name and you subsequently generated a variable of that name but
    it was not sorted, your dataset was now improperly sorted.

{p 9 9 2}
    Note that if you typed anything else, such as

		{cmd:use x2 using} {it:filename}
		{cmd:use x1 x2 z using} {it:filename}

{p 9 9 2}
    the problem would not arise.  That is, if the {it:varlist} contained
    variables that were not included in the sort list or if the {it:varlist}
    contained any of the last variables in the sort list without the first
    variables, the problem would not arise.  Additionally, if you had
    performed any operation that would naturally change the sort list, the
    data in memory no longer exhibited the problem.

{p 5 9 2}
8.  (Mac) There is now a setting for opening the Project Manager in the main
    Stata window in the {bf:General preferences...} dialog.  If the setting is
    off, the Project Manager will open in a Do-file Editor window instead of
    the main Stata window.


{hline 8} {hi:update 24jul2019} {hline}

{p 5 9 2}
1.  (Win) {helpb import sas} and {helpb import spss} failed to import files
    larger than 2 GB.  When using the Command window, error code {cmd:r(692)}
    with message "{err:error reading file}" was presented, and when using the
    dialog box, a pop-up message of "{err:Unable to parse file on disk}" was
    presented.  This has been fixed.

{p 5 9 2}
2.  {helpb label save} with no value labels specified (meaning that the
    command should save all value labels) created an empty file.  This has
    been fixed.


{hline 8} {hi:update 18jul2019} {hline}

{p 5 9 2}
1.  {helpb cpoisson} has the following fixes:

{p 9 13 2}
     a.  {cmd:cpoisson} with factor variables returned incorrect values for
         {cmd:e(k)} and {cmd:e(k_dv)}.  The values for {bf:e(k)} were too
         small, and the values for {cmd:e(k_dv)} were too large.  This has
         been fixed.

{p 9 13 2}
     b.  {cmd:cpoisson} with factor variables and with option {cmd:from()}
         incorrectly exited with error message
	 "{err:invalid number of initial values in option {bf:from()}}".
	 This has been fixed.

{p 5 9 2}
2.  {helpb meglm}, {helpb mecloglog}, {helpb meintreg}, {helpb melogit},
    {helpb menbreg}, {helpb meologit}, {helpb meoprobit}, {helpb mepoisson},
    {helpb metobit}, and {helpb mestreg}, when specified with large
    {cmd:fweight}s, underreported the number of groups and group sizes.  The
    rest of the output was unaffected.  This has been fixed.

{p 5 9 2}
3.  {helpb merge}, when a key variable in the master dataset was a
    {helpb data_types:strL}, produced an uninformative error message.  It now
    indicates that {cmd:strL} types are not allowed as a key variable.

{p 5 9 2}
4.  {helpb putmata}, when creating a named matrix with {it:varlist}
    specified as {cmd:*} or {cmd:_all}, added an extra column of 1s at the
    end of the matrix.  This has been fixed.

{p 5 9 2}
5.  In a {help python:Python environment}, when using method
    {browse "https://www.stata.com/python/api16/Data.html#sfi.Data.get":{bf:Data.get}{bf:(}{it:var}{bf:,} {it:obs}{bf:,} {it:selectvar}{bf:,} {it:valuelabel}{bf:,} {it:missingval}{bf:)}}
    defined in
    {browse "https://www.stata.com/python/api16/":Stata's Python API documentation},
    {cmd:Data.get()} failed to replace missing values of
    {helpb datatypes:float} or {cmd:double} Stata variables with the specified
    {it:missingval} in the resulting Python list.  This has been fixed.  This
    problem did not exist for {cmd:byte}, {cmd:int}, and {cmd:long} Stata
    variables.

{p 5 9 2}
6.  {helpb sem_command:sem} with options {cmd:group()} and {cmd:constraints()}
    exited with an unhelpful error message, even when specified correctly.
    This has been fixed.

{p 5 9 2}
7.  {helpb suest} now exits with error message
    "{err:svy {it:method} not supported by suest}" when the given estimation
    results are from {it:method} {helpb svy_bootstrap:bootstrap},
    {helpb svy_brr:brr}, {helpb svy_jackknife:jackknife}, or
    {helpb svy_sdr:sdr}.  Prior to this change, {cmd:suest} reported standard
    errors that were calculated using linearized variance estimates based on
    the {helpb svyset} design characteristics, ignoring option {cmd:vce()}.
    The old behavior is not preserved under version control.

{p 5 9 2}
8.  {helpb test} {it:coeflist}, when used with estimation results having a
    large number of equations, incorrectly exited with error message
    "{err:unable to allocate matrix}".  For Stata/IC, large is greater than 20
    equations.  For Stata/SE, large is greater than 104 equations.  For
    Stata/MP, large is greater than 255 equations.  This has been fixed.

{p 5 9 2}
9.  (Mac) Setting the Results window's scrollback buffer size in the
    {bf:General preferences...} dialog had no effect.  This has been fixed.

{p 4 9 2}
10.  (Mac) Dragging and dropping more than one variable in the Data Editor's
     variables pane caused Stata to crash.  This has been fixed.

{p 4 9 2}
11.  (Mac) The maximum value for the Do-file Editor's page guide column
     setting was 99.  This limitation has been removed, and there is no longer
     a maximum value for the page guide column setting.


{hline 8} {hi:update 02jul2019} {hline}

{p 5 9 2}
1.  Online help and the search index have been brought up to date for
    {help sj:Stata Journal} 19(2).

{p 5 9 2}
2.  {helpb odbc load} has the following fixes:

{p 9 13 2}
     a.  {cmd:odbc load} produced SQLSTATE error 42000 and Stata error
         {cmd:r(682)} when the {cmd:odbcdriver} was set to {cmd:unicode}.
         This has been fixed.

{p 9 13 2}
     b.  {cmd:odbc load} with option {opt allstring} imported Unicode columns
         as ISO Latin-1 columns.  This has been fixed.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew15to16}.

    {c TLC}{hline 63}{c TRC}
    {c |} Help file        Contents                     Years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {bf:this file}        Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
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
{hline}
