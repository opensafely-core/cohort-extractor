{smcl}
{* *! version 1.3.3  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 9.0 (compared with release 8)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 9.0:

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
    {c |} {bf:this file}        Stata  9.0 new release       2005            {c |}
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
See {help whatsnew9}.


{hline 3} {hi:Stata 9.0 release 22apr2005} {hline}

{title:Remarks}

{pstd}
Some of the important new additions include

{p 8 12 2}
1.  New matrix programming language Mata.

{p 8 12 2}
2.  New survey features, including 
    balanced repeated replications (BRR)
    and jackknife variance estimates, 
    complete support for multistage designs, 
    and poststratification.

{p 8 12 2}
3.  Estimation of linear mixed models, including standard errors and 
    confidence intervals for all variance components.

{p 8 12 2}
4.  Estimation of multinomial probit models, 
    including support for several correlation structures and for 
    user-defined structures.

{p 8 12 2}
5.  New multivariate analysis, including multidimensional scaling, 
    correspondence analysis, and Procrustean analysis, along with 
    the ability to analyze proximity matrices as well as raw data.

{p 8 12 2}
6.  Improved GUI, including multiple Do-file Editors, multiple Viewers,
     and multiple Graph windows; multiple windowing preferences; dockable
     windows; and much more.

{pstd}
There are other major features, and it will take us another 30 pages to
mention everything.

{pstd}
What's new is presented under the headings 

		{helpb whatsnew8to9##mata:New matrix language}

		{helpb whatsnew8to9##survey:Survey statistics}

		{helpb whatsnew8to9##panel:Longitudinal/panel data}
		
		{helpb whatsnew8to9##timeseries:Time-series statistics}

		{helpb whatsnew8to9##multivariate:Multivariate statistics}

		{helpb whatsnew8to9##survival:Survival analysis}

		{helpb whatsnew8to9##general:General-purpose statistics}

		{helpb whatsnew8to9##ml:New ML features}

		{helpb whatsnew8to9##functions:Functions and expressions}

		{helpb whatsnew8to9##data:Data management}

		{helpb whatsnew8to9##graphics:Graphics}

		{helpb whatsnew8to9##gui:User interface}

		{helpb whatsnew8to9##programming:Programming}

		{helpb whatsnew8to9##documentation:Documentation}


{marker mata}{...}
{title:What's new:  New matrix language}

{pstd}
Stata has an all-new matrix language called Mata, which is the subject
of its own manual, {bf:[M] The Mata Reference Manual}.
Mata can be used by those who want to think in matrix terms and perform 
matrix calculations interactively, and it can be used by
programmers who want to add features to Stata.

{pstd}
Mata has been used to implement many of the new features found in this
release.  Mata is compiled, optimized, and fast.

{pstd}
Stata's previously existing {cmd:matrix} command continues 
to be documented.  There is an admittedly uneasy relationship between
the two, but {cmd:matrix} continues to have its uses.  For
serious computation, however, you will definitely want to use the new
language.

{pstd}
See {helpb mata:[M-0] Intro} -- or {cmd:help} {cmd:mata} -- which provides an
introduction and organized reading list.  The first thing you will read is
{helpb m1_first:[M-1] first}.

 
{marker survey}{...}
{title:What's new:  Survey statistics}

{pstd}
Stata 9 substantially extends Stata's survey-analysis and
correlated-data-analysis facilities by adding the remaining two methods of
computing standard errors -- Balanced Repeated Replications (BRR) and survey
jackknife.

{pstd}
Stata 9
also adds complete support for multistage sampling and poststratification.  

{pstd}
A new, unified syntax is used for declaring the design of survey data and for
fitting models.  For an overview of all survey facilities, see
{help survey:{bf:[SVY] survey}}.

{pstd}
All the old syntax continues to work under version control, although the
survey estimation commands do not require that, but if you use old
syntax, the new features will not be available.

{p 5 9 2} 
1.  Existing command {cmd:svyset} for declaring the survey
    design has new syntax that supports a host of new features in Stata's
    survey-analysis facilities:  

{p 9 13 2}
    a.  BRR and jackknife variance estimators have been added to the
        previously available linearization variance estimator.
        Moreover, use of BRR or jackknife (or linearization) can now be 
        specified when you {cmd:svyset} or at estimation time.
    
{p 9 13 2}
    b.  Multistage designs can now be declared, and they may have primary, 
        secondary, and lower-stage sampling units.  The linearization variance
	estimator takes complete advantage of the information in multistage
	designs.

{p 9 13 2}
    c.  Stratification is now allowed in all stages, making variance estimates
        more efficient wherever stratification can be exploited.

{p 9 13 2}
    d.  Poststratification is now available and, like stratification,
        also makes variance estimates more efficient.  Poststratification
        adjusts weights, improves variance estimates, and accounts for biases
        when demographic or other groupings are known.

{p 9 13 2}
    e.  Finite-population corrections are now allowed in all stages.

{p 9 13 2}
    f.  Sampling weights are handled under all three variance estimators.

{p 9 9 2} 
    For details, see {manhelp svyset SVY}.
    The previous {cmd:svyset} syntax continues to work under version control.

{p 5 9 2}
2.  New prefix command {cmd:svy:} is
    how you tell estimators you have survey data.  You no longer type
    {cmd:svyregress}; you type {cmd:svy: regress}.  This is not just a matter
    of style; {cmd:svy} really is a prefix command, and in fact, you can even
    use it as a prefix on estimation commands you write.  In addition,
    {cmd:svy:} provides a standard, unified syntax for accessing Stata's 
    survey features.  {cmd:svy:} is easy to use because it automatically
    applies everything you have previously {cmd:svyset}, including the design.

{p 9 9 2} 
    The following estimators can be used with {cmd:svy:} prefix:

{p2colset 14 36 38 2}{...}
{p 9 9 2}
{bf:Descriptive statistics}

{p2col :{helpb "svy: mean"}}Population and subpopulation means{p_end}
{p2col :{helpb "svy: proportion"}}Population and subpopulation proportions{p_end}
{p2col :{helpb "svy: ratio"}}Population and subpopulation ratios{p_end}
{p2col :{helpb "svy: total"}}Population and subpopulation totals{p_end}

{p2col :{helpb "svy: tabulate oneway"}}One-way tables for survey data{p_end}
{p2col :{helpb "svy: tabulate twoway"}}Two-way tables for survey data{p_end}

{p 9 9 2}
{bf:Regression models}

{p2col :{helpb "svy: regress"}}Linear regression{p_end}
{p2col :{helpb "svy: ivreg"}}Instrumental variables regression{p_end}
{p2col :{helpb "svy: intreg"}}Interval and censored regression{p_end}

{p2col :{helpb "svy: logistic"}}Logistic regression, reporting odds ratios{p_end}
{p2col :{helpb "svy: logit"}}Logistic regression, reporting coefficients{p_end}
{p2col :{helpb "svy: probit"}}Probit regression{p_end}

{p2col :{helpb "svy: mlogit"}}Multinomial logistic regression{p_end}
{p2col :{helpb "svy: ologit"}}Ordered logistic regression{p_end}
{p2col :{helpb "svy: oprobit"}}Ordered probit models{p_end}

{p2col :{helpb "svy: poisson"}}Poisson regression{p_end}
{p2col :{helpb "svy: nbreg"}}Negative binomial regression{p_end}
{p2col :{helpb "svy: gnbreg"}}Generalized negative binomial regression{p_end}

{p2col :{helpb "svy: heckman"}}Heckman selection model{p_end}
{p2col :{helpb "svy: heckprob"}}Probit model with selection{p_end}

{p 9 9 2} 
    Previously existing survey-estimation commands, such as {cmd:svyregress},
    {cmd:svymean}, and {cmd:svypoisson}, continue to work as they did before,
    but only if your survey design is declared using {cmd:version 8: svyset}
    or if you are working with an old Stata 8 dataset.  For a mapping from old
    estimation commands to the new syntax, see {help svy8}.  (The new
    prefix {cmd:svy:} works with datasets that were {cmd:svyset} under an
    earlier release of Stata.)

{p 9 9 2} 
    In addition to the three variance estimators and support for multistage
    sampling, the new {cmd:svy:} prefix provides other enhancements, including

{p 9 13 2}
    a.  Option {cmd:subpop()} allows more
        flexible selection of subpopulations, meaning that more general
        {cmd:if} conditions are now allowed.

{p 9 13 2}
    b.  Strata with only one sampling unit (sometimes called singleton PSUs)
        are now handled better -- the coefficients are now reported, but with
        missing standard errors.  {cmd:svydes} can now be used to find and
        describe these strata;
        see {manhelp svydes SVY}.

{p 9 13 2}
    c.  With BRR variance estimation, a Hadamard matrix can be used in
        place of BRR weights, and Fay's adjustment may be specified;
        see {manhelpi brr_options SVY}.

{p 5 9 2}
3.  New command {cmd:svy:} {cmd:proportion} replaces {cmd:svyprop}.
    (By the way, new command {cmd:proportion} can be used without the 
    {cmd:svy:} prefix; see {manhelp proportion R}.)
    Unlike {cmd:svyprop}, {cmd:svy:} {cmd:proportion} is an estimation
    command and computes a full covariance matrix for all the estimated
    proportions, allowing postestimation features, such as tests of linear and
    nonlinear combinations of proportions ({helpb test} and {helpb testnl}) or
    creation of linear and nonlinear combinations with confidence intervals
    ({helpb lincom} and {helpb nlcom}).

{p 5 9 2}
4.  New commands {cmd:ratio}, {cmd:total}, and
    {cmd:mean}, used with the {cmd:svy:} prefix, 
    use casewise deletion and estimate full
    covariance matrices for the estimates.  

{p 5 9 2}
5.  New command {cmd:svy: tabulate oneway} addresses a missing feature.
    Previously, anyone wanting a one-way tabulation had to create a constant
    and perform two-way survey tabulation with that constant.

{p 5 9 2}
6.  New command {cmd:estat} computes and reports additional statistics and
    information after estimation with {cmd:svy:} prefix:

{p 9 13 2}
    a.  {cmd:estat} {cmd:svyset} reports complete information on the survey
        design.

{p 9 13 2}
    b.  {cmd:estat} {cmd:effects} computes and reports the design
        effects -- DEFF and DEFT -- and the misspecification effects -- MEFF
        and MEFT -- in any combination for each estimated parameter.

{p 9 13 2}
    c.  {cmd:estat} {cmd:effects} can also compute DEFF and DEFT for
        subpopulations using simple random-sample estimates from either the
        overall population or from the subpopulation.  {cmd:estat}
	{cmd:effects} replaces and extends the {cmd:deff}, {cmd:deft},
	{cmd:meff}, and {cmd:meft} options previously available on survey
	estimators.

{p 9 13 2}
    d.  {cmd:estat} {cmd:lceffects} computes and reports the survey design
	effects and misspecification effects for any linear combination of
	estimated parameters.

{p 9 13 2}
    e.  {cmd:estat} {cmd:size} reports the sample and population sizes for
        each subpopulation after {cmd:svy:} {cmd:mean}, 
	{cmd:svy:} {cmd:proportion}, {cmd:svy:} {cmd:ratio}, 
	and {cmd:svy:} {cmd:total}.

{p 9 9 2}
     For details on {cmd:estat} after survey estimation,
     see {help svy estat:{bf:[SVY] estat}}.

{p 5 9 2}
7.  Existing command {cmd:svydes} has several new features and options:

{p 9 13 2}
	a.  New option {cmd:stage()} lets you select the sampling stage
	    for which sample statistics are to be reported.

{p 9 13 2}
	b.  New option {cmd:generate()} identifies strata with a single
	    sampling unit.

{p 9 13 2}
	c.  New option {cmd:finalstage} replaces {cmd:bypsu} and reports
            observation sample statistics by sampling unit in the final stage.

{p 5 9 2}
8.  New options {cmd:stdize()} and {cmd:stdweight()} on commands
    {cmd:svy: mean}, {cmd:svy: ratio}, {cmd:svy: proportion},
    {cmd:svy: tabulate oneway}, and {cmd:svy: tabulate twoway} allow direct
    standardization of means, ratios, proportions, and tabulations using any
    of the three survey variance estimators.

{p 5 9 2}
9.  Programmers of estimation commands can get full support
    for estimation with survey and correlated data almost automatically.  This
    support includes correct treatment of multistage designs, weighting,
    stratification, poststratification, and finite-population corrections, as
    well as access to all three variance estimators.
    See {help program properties:{bf:[P] program properties}}.

{p 4 9 2}
10.  The [SVY] manual now has a glossary that defines commonly used terms in
     survey analysis and explains how these terms are used in the
     manual; see {bf:[SVY] Glossary}.


{marker panel}{...}
{title:What's new:  Longitudinal/panel data}

{p 5 9 2} 
1.  The big news is new command {cmd:xtmixed} -- Stata now fits linear
    mixed models, also known as hierarchical models or multilevel models.

{p 9 9 2} 
    Mixed models include what social scientists call random-effects
    models, including one-way, two-way, multi-way, and hierarchical models,
    and it includes random-coefficient models.

{p 9 9 2} 
    Estimates are obtained using maximum likelihood (ML), restricted maximum
    likelihood (REML), or expectation maximization (EM).  Covariances among
    random effects are estimated and may be independent (no covariance),
    exchangeable (common covariance), or unstructured (unique covariance for
    each pair of effects).  

{p 9 9 2} 
    {cmd:xtmixed} estimates standard errors and confidence intervals for
    the fixed parameters, and it estimates the standard deviations (variances)
    and correlations (covariances) of the random effects and the full VCE
    matrix among them.

{p 9 9 2} 
    For details, see {manhelp xtmixed XT}.

{p 9 9 2} 
    After estimation with {cmd:xtmixed}, 

{p 9 13 2}
    a.  {cmd:estat} {cmd:recovariance} reports the estimated
        variance-covariance matrix of the random effects for each level.

{p 9 13 2}
    b.  {cmd:estat} {cmd:group} summarizes the composition of the nested
        groups, providing minimum, average, and maximum group size for each
	level in the model.

{p 9 9 2} 
    {cmd:predict} after {cmd:xtmixed} can compute best linear unbiased
    predictions (BLUPs) for each random effect.  It can also compute the
    linear predictor, the standard error of the linear predictor, the fitted
    values (linear predictor plus contributions of random effects), the
    residuals, and the standardized residuals.

{p 5 9 2}
2.  New features have been added to the maximum-likelihood estimators
    that do not have closed-form solutions and require numeric evaluation of
    the likelihood.  These estimators include {helpb xtlogit}, 
    {helpb xtprobit}, {helpb xtpoisson}, {helpb xtcloglog}, 
    {helpb xtintreg}, and {helpb xttobit}.

{p 9 13 2}
    a.  The likelihood may now be approximated using adaptive Gauss-Hermite
        quadrature (the new default) or nonadaptive quadrature (the previous
        default).
        Adaptive quadrature
        substantially increases the accuracy of the approximation,
        particularly on difficult problems such as data with large panel sizes
        or data with a large variance for the random effects. 

{p 9 13 2}
    b.  Linear constraints may now be imposed using the new option 
        {cmd:constraints()}.  Constraints are specified the standard 
        way; see {manhelp constraint R}.

{p 9 13 2}
    c.  New option {cmd:intpoints()} replaces old option {cmd:quad()}, 
        although {cmd:quad()} continues to work.
        The new name is more meaningful, especially when used with estimators
        that integrate likelihoods using methods other than quadrature.

{p 5 9 2}
3.  Existing command {cmd:xtreg} now allows options {cmd:robust} and
    {cmd:cluster()} when estimating fixed-effects (FE) and random-effects (RE)
    models; see {manhelp xtreg XT}.

{p 5 9 2}
4.  Most {cmd:[XT]} commands that previously did not allow time-series
    operators now support them.  These commands include
    {helpb xtgls}, {helpb xtreg}, {helpb xtsum}, 
    {helpb xtcloglog}, {helpb xtintreg}, {helpb xtlogit}, {helpb xtpoisson},
    {helpb xtprobit}, {helpb xttobit}, and {helpb xtgee}.

{p 5 9 2}
5.  New command {cmd:xtrc} is old command {cmd:xtrchh}, renamed, and with 
    new features.
    New option {cmd:beta} reports the best linear predictors (BLUPs) for the
    group-specific coefficients, along with their standard errors and
    confidence intervals.  For details,
    see {manhelp xtrc XT}.

{p 5 9 2}
6.  {cmd:predict} after {cmd:xtrc} has the new option {cmd:group()} to compute
    the BLUPs of the dependent variable using the BLUPs of the coefficients.

{p 5 9 2}
7.  New command {cmd:xtline} plots panel data and
    allows either overlaid or separate graphs for each panel; 
    see {manhelp xtline XT}

{p 5 9 2}
8.  New section {bf:[XT]} {bf:Glossary} defines commonly used
    terms and how they are used by us.


{marker timeseries}{...}
{title:What's new:  Time-series statistics}

{p 5 9 2}
1.  Existing command {cmd:arima} can now estimate multiplicative seasonal
    ARIMA (SARIMA) models; see new options {cmd:sarima()}, {cmd:mar()}, and
    {cmd:mma()} in {helpb arima:[TS] arima}.

{p 5 9 2}
2.  New command {cmd:rolling} performs rolling-window or recursive estimations,
    including regressions, and collects statistics from the estimation on each
    window;
    see {manhelp rolling TS}.

{p 5 9 2}
3.  The {bf:[TS]} manual now has a glossary that defines commonly used terms
    in time-series analysis and explains how we use them in the manual; see
    {bf:[TS]} {bf:Glossary}.

{p 5 9 2}
4.  Many existing commands that previously did not allow time-series
    operators now do.  These
    commands include {cmd:areg}, {cmd:binreg}, {cmd:biprobit}, 
    {cmd:boxcox}, {cmd:cloglog}, {cmd:cnsreg}, {cmd:glm}, {cmd:heckman},
    {cmd:heckprob}, {cmd:hetprob}, {cmd:impute}, {cmd:intreg}, 
    {cmd:logistic}, {cmd:logit}, {cmd:lowess}, {cmd:mvreg}, {cmd:nbreg},
    {cmd:orthog}, {cmd:pcorr}, {cmd:poisson}, {cmd:probit}, {cmd:pwcorr},
    {cmd:rreg}, {cmd:testparm}, {cmd:treatreg}, {cmd:truncreg}, 
    {cmd:xtcloglog}, {cmd:xtgls}, {cmd:xtintreg}, {cmd:xtlogit}, 
    {cmd:xtpoisson}, {cmd:xtprobit}, {cmd:xtgee}, {cmd:xtreg}, 
    {cmd:xtsum}, and {cmd:xttobit}.  

{p 5 9 2}
5.  Many commands requiring time-series data will now work on a single panel
    from a panel dataset when that panel is selected using an {cmd:if}
    expression or an {cmd:in} qualifier.  Those commands include {cmd:ac},
    {cmd:corrgram}, {cmd:cumsp}, {cmd:dfgls}, {cmd:dfuller}, {cmd:pac},
    {cmd:pergram}, {cmd:pperron}, {cmd:wntestb}, {cmd:wntestq}, and
    {cmd:xcorr}.  New commands {cmd:estat} {cmd:archlm}, {cmd:estat}
    {cmd:bgodfrey}, {cmd:estat} {cmd:dwatson}, and {cmd:estat}
    {cmd:durbinalt}, which replace commands {cmd:archlm}, {cmd:bgodfrey},
    {cmd:dwstat}, and {cmd:durbina}, also work on a single panel from a panel
    dataset.

{p 5 9 2}
6.  The dialogs for analyzing IRF results are much improved.  The dialogs
    now populate lists of models and variables from the current IRF
    results that may be chosen for producing tables and graphs.  The 
    improved dialogs include {bf:{stata db irf cgraph}}, 
    {bf:{stata db irf ctable}},
    {bf:{stata db irf graph}}, 
    {bf:{stata db irf ograph}}, and 
    {bf:{stata db irf table}}.

{p 5 9 2}
7.  Existing command 
    {cmd:dfuller} has new option {cmd:drift} for testing the null hypothesis
    of a random walk with drift.  The algorithm for calculating MacKinnon's
    approximate p-values is also now more accurate in cases where the p-value
    is relatively large; see {helpb dfuller:[TS] dfuller}.

{p 5 9 2}
8.  Existing commands
    {cmd:corrgram} and {cmd:pac} have new option {cmd:yw} that
    computes partial autocorrelations using the Yule-Walker equations instead
    of the default regression-based method; see {manhelp corrgram TS}.

{p 5 9 2}
9.  Time-series operators are now better displayed in estimation
    and other result tables.

{p 4 9 2}
10.  New command {cmd:estat} -- used after {cmd:regress} -- brings together
     what was previously done by commands {cmd:dwstat}, {cmd:durbina},
     {cmd:bgodfrey}, and {cmd:archlm}.
     The new commands are 
     {cmd:estat dwatson}, 
     {cmd:estat durbina}, 
     {cmd:estat bgodfrey}, and
     {cmd:estat archlm}.
     See {helpb regress postestimationts:[R] regress postestimation time series}.

{p 4 9 2}
11.  The ability of {cmd:arima} and {cmd:arch} to estimate standard errors
     using either the observed information matrix (OIM) or the outer product
     of gradients (OPG) has been consolidated under the new {cmd:vce()}
     option.

{pstd}
(What follows was first released in Stata 8.2.)

{p 4 9 2}
12.  New command {cmd:vec} fits cointegrated vector error-correction
     models (VECMs) using Johansen's method; see {manhelp vec TS}.

{p 4 9 2}
13.  New command {cmd:vecrank} produces statistics used to determine the
    number of cointegrating vectors in a VECM, including Johansen's trace and
    maximum-eigenvalue tests for cointegration; see 
    {manhelp vecrank TS}.

{p 4 9 2}
14.  New command {cmd:fcast} -- which replaces old command
    {cmd:varfcast} -- produces and graphs dynamic forecasts of the dependent
    variables after fitting a VAR, SVAR, or VECM; see 
    {manhelp fcast TS}.

{p 4 9 2}
15.  New command {cmd:irf} -- which replaces the old command {cmd:varirf} --
    does everything the old command did and more.  {cmd:irf} estimates the
    impulse-response functions, cumulative impulse-response functions,
    orthogonalized impulse-response functions, structural impulse-response
    functions, and forecast error-variance decompositions after fitting a VAR,
    SVAR, or VECM.  {cmd:irf} can also make graphs and tables of the results.
    See {helpb irf:[TS] irf}.

{p 9 9 2}
    {cmd:varirf} continues to work but is no longer documented.  {cmd:irf}
    accepts {cmd:.vrf} result files created by {cmd:varirf}.

{p 4 9 2}
16.  Existing command {cmd:varsoc} can now be used to obtain lag-order
     selection statistics for VECMs, as well as VARs;
     see {helpb varsoc:[TS] varsoc}.

{p 4 9 2}
17.  New command {cmd:veclmar} computes Lagrange-multiplier statistics for
    autocorrelation after fitting a VECM; see 
     {helpb veclmar:[TS] veclmar}.

{p 4 9 2}
18.  New command {cmd:vecnorm} tests whether the disturbances in a VECM
    are normally distributed.  For each equation and for all equations
    jointly, three statistics are computed: a skewness statistic, a kurtosis
    statistic, and the Jarque-Bera statistic.  See 
    {helpb vecnorm:[TS] vecnorm}.

{p 4 9 2}
19.  New command {cmd:vecstable} checks the eigenvalue stability condition
    after fitting a VECM; see {helpb vecstable:[TS] vecstable}.

{p 4 9 2}
20.  New command {cmd:vecstable} and the existing command {cmd:varstable}
    have a new graph option for presenting
    the stability results.  See 
    {helpb vecstable:[TS] vecstable} and 
    {helpb varstable:[TS] varstable}.

{p 4 9 2}
21.  The output of the following commands has been standardized to improve
    formatting:  {cmd:var}, {cmd:svar}, {cmd:vargranger},
    {cmd:varlmar}, {cmd:varnorm}, {cmd:varsoc}, {cmd:varstable}, and
    {cmd:varwle}.

{p 4 9 2}
22.  New command {cmd:haver} makes it easy to load and analyze 
     economic and financial databases available from Haver Analytics;
     see {helpb haver:[TS] haver}.



{marker multivariate}{...}
{title:What's new:  Multivariate statistics}

{pstd}
Stata has four all-new methods for analyzing multivariate data and many
more extensions to existing methods.  In addition, most methods now support 
direct analysis of matrices as well as raw data.

{pstd}
Be sure you check the postestimation documentation for the multivariate
estimators you use; many important new features are documented there.  In
particular, all the multivariate commands make extensive use of new
command {cmd:estat} for providing additional statistics and results after
estimation.

{p 5 9 2}
1.  New commands {cmd:mds}, {cmd:mdslong}, and {cmd:mdsmat} perform classic 
    metric multidimensional scaling:  {cmd:mds} performs the scaling with
    respect to the distances (dissimilarities) between observations,
    {cmd:mdslong} performs the scaling on a long dataset where each
    observation represents the distance between two points or objects, and
    {cmd:mdsmat} performs the scaling on a matrix of distances.  
    See {help mds:{bf:[MV] mds}}, {help mdslong:{bf:[MV] mdslong}}, and 
    {help mdsmat:{bf:[MV] mdsmat}}.

{p 9 9 2}
    {cmd:mds} supports all 33 similarity/dissimilarity measures
    available in Stata; see 
    {help measure_option:{bf:[MV]} {it:measure_option}}.

{p 9 9 2}
    The following new {cmd:estat} commands work after {cmd:mds},
    {cmd:mdslong}, or {cmd:mdsmat} and provide additional statistics and
    results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:config} reports the coordinates of the
        approximating configuration.

{p 9 13 2}
    b.  {cmd:estat} {cmd:correlations} reports the Pearson and 
        Spearman correlations between the dissimilarities and the
        approximating distances for each object.

{p 9 13 2}
    c.  {cmd:estat} {cmd:pairwise} reports a set of statistics 
        for each pairwise comparison; it reports the dissimilarities, the
        approximating distances, and the raw residuals.

{p 9 13 2}
    d.  {cmd:estat} {cmd:quantiles} reports the quantiles of 
        the residuals for each observation (after {cmd:mds}) or object (after
        {cmd:mdslong} or {cmd:mdsmat}).

{p 9 13 2}
    e.  {cmd:estat} {cmd:stress} reports the Kruskal stress
        (loss) measure between the transformed dissimilarities and fitted
        distances per object.

{p 9 9 2}
    See {help mds postestimation:{bf:[MV] mds postestimation}}
    for more information.

{p 9 9 2}
    In addition, there are two new commands for graphing results from a
    multidimensional scaling:

{p 9 13 2}
    a.  {cmd:mdsconfig} plots the approximating Euclidean configuration of the
        first two dimensions; see 
	{help mds postestimation plots##mdsconfig:{bf:[MV] mds postestimation plots}}.

{p 9 13 2}
    b.  {cmd:mdsshepard} produces a Shepard diagram of the dissimilarities
        against the approximating Euclidean distances; see 
        {help mds postestimation plots##mdsshepard:{bf:[MV] mds postestimation plots}}.

{p 9 9 2}
    {cmd:predict} after any multidimensional-scaling command will
    produce 

{p 9 13 2}
    a.  variables containing the approximating configuration
	({cmd:predict} {it:newvarlist}{cmd:,} {cmd:config});

{p 9 13 2}
    b.  variables containing the dissimilarity, distance, and raw residuals
        ({cmd:predict} {it:newvarlist}{cmd:,} {cmd:pairwise})

{p 9 9 2}
    See {help mds postestimation##predict:{bf:[MV] mds postestimation}}
    for more information.

{p 5 9 2}
2.  New commands {cmd:ca} and {cmd:camat} perform two-way correspondence
    analysis using any of several available forms of normalization.
    {cmd:ca} performs the analysis on the cross-tabulation of two categorical
    variables; {cmd:camat} performs the analysis on a matrix of
    counts; see {help ca:{bf:[MV] ca}} for more information on both.

{p 9 9 2}
    The following new {cmd:estat} commands work after {cmd:ca} and {cmd:camat}
    and provide additional statistics and results

{p 9 13 2}
    a.  {cmd:estat} {cmd:coordinates} reports the coordinates in both the row
        space and the column space.

{p 9 13 2}
    b.  {cmd:estat} {cmd:distances} reports the chi-squared distances between
        the row profiles and between the column profiles, including the
	distances to the marginal distributions (commonly called centers).
	Both observed or fitted profiles are available.

{p 9 13 2}
    c.  {cmd:estat} {cmd:inertia} reports the inertia contributions of the
        individual cells.

{p 9 13 2}
    d.  {cmd:estat} {cmd:profiles} reports the row profiles and column 
        profiles -- the conditional distributions, given the other dimension.

{p 9 13 2}
    e.  {cmd:estat} {cmd:summarize} reports summary information of the row
        and column variables over the estimation sample.

{p 9 13 2}
    f.  {cmd:estat} {cmd:table} reports the fitted correspondence table, 
    	the observed "correspondence" table, or the expected table under
	the assumption of independence.

{p 9 9 2}
    See {help ca postestimation:{bf:[MV] ca postestimation}}
    for more information.

{p 9 9 2}
    In addition, there are two new commands for graphing results from a
    correspondence analysis:

{p 9 13 2}
    a.  {cmd:cabiplot} produces a biplot of each row category and 
        each column category;
        see {help ca postestimation plots##cabiplot:{bf:[MV] ca postestimation plots}}.

{p 9 13 2}
    b.  {cmd:caprojection} produces a graph that shows the ordering of row
        categories 
        and column categories on each principal dimension of the analysis.
        Each principal dimension is represented by a vertical line; markers
        are plotted on the lines where the row categories and column 
        categories project
        onto the dimensions; see 
	{help ca postestimation plots##caprojection:{bf:[MV] ca postestimation plots}}.

{p 9 9 2}
    {cmd:predict} after {cmd:ca} and {cmd:camat} computes fitted values and
    row or column scores for any dimension; see
    {help ca postestimation##predict:{bf:[MV] ca postestimation}}.

{p 5 9 2}
3.  The new command {cmd:procrustes} performs Procrustean analysis for
    comparing and measuring the similarity between two sets of variables:
    source and target.  Two datasets can also be compared if the datasets
    are first merged by record.

{p 9 9 2}
    The following new {cmd:estat} commands work after {cmd:procrustes} and
    provide additional statistics and results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:compare} reports fit statistics of the three
        transformations available in Procrustean analysis:  orthogonal,
	oblique, and unrestricted.

{p 9 13 2}
    b.  {cmd:estat} {cmd:mvreg} reports the multivariate regression that is
        related to the current Procrustean analysis.

{p 9 13 2}
    c.  {cmd:estat} {cmd:summarize} reports summary information of the two
        sets of variables over the estimation sample.

{p 9 9 2}
    See 
    {help procrustes postestimation:{bf:[MV] procrustes postestimation}}
    for more information.

{p 9 9 2}
    New command {cmd:procoverlay} after {cmd:procrustes} creates an
    overlay graph comparing the target variables to the fitted values derived
    from the source variables; see 
    {help procrustes postestimation##procoverlay:{bf:[MV] procrustes postestimation}}.

{p 9 9 2}
    {cmd:predict} after {cmd:procrustes} produces fitted values for all
    variables, residuals for all variables, or residual sums of squares for a
    specified target variable; see 
    {help procrustes postestimation##predict:{bf:[MV] procrustes postestimation}}.

{p 5 9 2}
4.  New command {cmd:biplot} performs a biplot analysis of a dataset and
    produces a two-dimensional biplot of the results.  A biplot simultaneously
    displays the observations (rows) and the relative positions of the
    variables (columns).  Observations are projected to two dimensions such
    that the distance between the observations is approximately preserved.
    The variables are plotted as arrows, with the cosine of the angle between
    arrows approximating the correlation between the variables.
    See {helpb biplot:[MV] biplot}.

{p 5 9 2}
5.  New command {cmd:tetrachoric} computes a tetrachoric correlation
    matrix for a set of binary variables.  {cmd:tetrachoric} is
    documented in {bf:[R]} but will often be used in multivariate analyses;
    see {help tetrachoric:{bf:[R] tetrachoric}}.

{p 9 9 2} 
    {cmd:tetrachoric} results can be used in subsequent factor
    analyses or principal component analyses using the new
    {cmd:factormat} and {cmd:pcamat} commands.  See 
    {helpb factor:[MV] factor} and {helpb pca:[MV] pca}.

{p 5 9 2} 
6.  Existing command {cmd:canon} now allows analysis and presentation of
    more than one linear combination and has new options for reporting the raw
    or standardized coefficients and for reporting significance tests of the
    canonical correlations; see {help canon:{bf:[MV] canon}}.

{p 9 9 2}
    The following new {cmd:estat} commands work after {cmd:canon} and
    provide additional statistics and results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:correlations} reports the correlations among all
        variables.

{p 9 13 2}
    b.  {cmd:estat} {cmd:loadings} reports the matrices of canonical loadings.

{p 9 9 2}
    See 
    {help canon postestimation:{bf:[MV] canon postestimation}}
    for more information.

{p 5 9 2}
7.  Existing command {cmd:cluster dendrogram} has many new features,
    including horizontal dendrograms and the ability to label branch counts.
    The look of the graph can now be changed (titles, axes, colors, etc.);
    see {help cluster dendrogram:{bf:[MV] cluster dendrogram}}.

{p 5 9 2}
8.  The existing hierarchical cluster commands have new option
    {cmd:measure()} that specifies the proximity measure to use in
    computing dissimilarities between observations.  Any of 33
     measures
    may be specified; see 
    {help measure_option:{bf:[MV]} {it:measure_option}}.  Previously
    most of the measures were available under other option names; those
    options continue to work but are undocumented.  See 
    {help cluster:{bf:[MV] cluster}}.

{p 5 9 2}
9.  Existing command {cmd:cluster stop} has new option {cmd:varlist()}
    that specifies alternative variables to use when computing the
    stopping rules; see {help cluster stop:{bf:[MV] cluster stop}}.


{title:What's new:  Analysis of proximity matrices}

{pstd}
All of Stata's multivariate analysis facilities that rely on pairwise
comparisons of distance, similarity, dissimilarity, covariance, correlation,
or other proximity measures can now work directly with
proximity matrices that you compute or obtain from other sources.

{pstd}
Previously, all of these facilities worked only with raw datasets.  The new
commands implement analyses on matrices.  They share the common ability to
accept either full matrices or vectors representing the lower or upper
triangle of a symmetric proximity matrix.

{p 4 9 2} 
10.  New command {cmd:clustermat} extends all of Stata's hierarchical
     clustering facilities to the analysis of matrices of a dissimilarity
     measure (sometimes called a distance or proximity measure).  This
     includes all seven linkage methods and the ability to create dendrograms
     of the results; see {help clustermat:{bf:[MV] clustermat}}.

{p 4 9 2} 
11.  New command {cmd:factormat} performs factor analysis on a matrix of
     correlations, extending all the new and previously available
     capabilities of the existing command {helpb factor:[MV] factor} 
     to precomputed
     matrices of correlations; see {help factor:{bf:[MV] factor}}.

{p 4 9 2} 
12.  New command {cmd:pcamat} performs principal component analysis on an
    existing correlation or covariance matrix; see 
    {help pca:{bf:[MV] pca}}.

{p 4 9 2}
13.  New {cmd:matrix} subcommand {cmd:dissimilarity} computes similarity,
    dissimilarity, or distance matrices using any of 19 
    proximity measures for continuous data 
    and 14 measures for binary data; see 
    {help measure_option:{bf:[MV]} {it:measure_option}}
     and see 
    {help matrix dissimilarity:{bf:[MV] matrix dissimilarity}}.


{title:What's new:  Factor and principal component analysis additions}

{p 5 5 2} 
In addition to allowing direct analysis of correlation and covariance matrices
using {helpb factormat} and {helpb pcamat}, Stata's factor analysis and
principal components analysis (PCA) methods have been expanded,
particularly through the addition of postestimation commands for reporting and
graphing results.

{p 4 9 2} 
14.  Command {cmd:factor} has new reporting option 
    {cmd:altdivisor}, that specifies
    the trace of the correlation matrix be used as the divisor for
    proportions, rather than the default (the sum of all eigenvalues).

{p 4 9 2}
15.  
    New {cmd:estat} commands for use after {cmd:factor} and
    {cmd:factormat} provide additional statistics and
    results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:common} reports the correlation matrix of the common
        factors and is more of interest after oblique rotations.

{p 9 13 2}
    b.  {cmd:estat} {cmd:factors} reports model-selection criteria (AIC and
        BIC) over all the factors retained in an analysis.

{p 9 13 2}
    c.  {cmd:estat} {cmd:rotatecompare} reports the unrotated factor loadings
        next to the most-recent rotated loadings.

{p 9 13 2}
    d.  {cmd:estat} {cmd:structure} reports the factor structure -- the
        correlations between the variables and the common factors.

{p 9 9 2}
    See {help factor postestimation:{bf:[MV] factor postestimation}}
    for more information.

{p 4 9 2} 
16.  Existing command {cmd:pca} allows several new options:

{p 9 13 2}
        a.  Option {cmd:vce(normal)} computes the VCE of the eigenvalues and 
            eigenvectors, assuming multivariate normality.  

{p 13 13 2}
            This gives you access to many of Stata's postestimation facilities
            for analyzing estimation results, including tests of eigenvalue and
            eigenvector significance, tests of linear and nonlinear
            combinations ({helpb test:[R] test} and {helpb testnl:[R] testnl}),
            linear and
            nonlinear combinations with confidence intervals 
            ({helpb lincom:[R] lincom}
            and {helpb nlcom:[R] nlcom}), 
            and nonlinear predictions with confidence
            intervals ({helpb predictnl:[R] predictnl}).

{p 13 13 2}
	    {cmd:vce(normal)} also produces the ingredients for 
            adding confidence intervals to screeplots; 
	    see {help screeplot:{bf:[MV] screeplot}}.

{p 9 13 2}
	b.  Options {cmd:level()}, {cmd:blanks()}, {cmd:novce}, and 
            {cmd:norotated} allow more flexible control of the displayed 
            results.

{p 9 13 2}
	c.  Option {opt components(#)} 
            specifies the number of components to retain
            and is a synonym for old option {cmd:factor()}.

{p 9 13 2}
	d.  Options {cmd:tol()} and {cmd:ignore} provide advanced control 
            for computationally difficult problems.

{p 9 9 2}
     See {help pca:{bf:[MV] pca}}
     for more information.

{p 4 9 2} 
17.  New {cmd:estat} commands for use after {cmd:pca} and {cmd:pcamat} provide
     additional statistics and results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:loadings} reports the component loading matrix in
        any of several available normalizations of the columns (eigenvectors).

{p 9 13 2}
    b.  {cmd:estat} {cmd:rotatecompare} reports the unrotated (principal)
        components next to the most recent rotated components.

{p 9 9 2}
     See {help pca postestimation:{bf:[MV] pca postestimation}}
     for more information.

{p 4 9 2} 
18.  New {cmd:estat} commands for use after any factor analysis or 
     any principal components analysis (that is, after 
     {cmd:factor} or {cmd:factormat} or after {cmd:pca} or {cmd:pcamat})
     provide
     additional statistics and results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:anti} reports the anti-image correlation and
        anti-image covariance matrices.

{p 9 13 2}
    b.  {cmd:estat} {cmd:kmo} reports the Kaiser-Meyer-Olkin measure of
        sampling adequacy.

{p 9 13 2}
    c.  {cmd:estat} {cmd:residuals} reports the difference between the
        observed correlation or covariance matrix and the fitted (reproduced)
        matrix using the retained factors.

{p 9 13 2}
    d.  {cmd:estat} {cmd:smc} reports the squared multiple correlations (SMC)
        between each variable and all other variables.  SMC is a theoretical
        lower bound for communality, so it is an upper bound for the
        unexplained variance.

{p 9 9 2}
     See 
     {help factor postestimation:{bf:[MV] factor postestimation}} and 
     {help pca postestimation:{bf:[MV] pca postestimation}}
     for more information.

{p 4 9 2} 
19.  Three new graphs are available after any factor analysis ({cmd:factor}
     and {cmd:factormat}) or after any principal components analysis
     ({cmd:pca} and {cmd:pcamat}):

{p 9 13 2}
    a.  {cmd:scoreplot} graphs scatterplots comparing each pair of factors or
        components; see {help scoreplot:{bf:[MV] scoreplot}}.

{p 9 13 2}
    b.  {cmd:loadingplot} graphs scatterplots comparing loadings for each pair
        of factors or components; see {help scoreplot:{bf:[MV] scoreplot}}.

{p 9 13 2}
    c.  {cmd:screeplot} plots the eigenvalues of a covariance or
        correlation matrix; see {help screeplot:{bf:[MV] screeplot}}.
	({cmd:screeplot} replaces {cmd:greigen} and has more features;
	{cmd:greigen} continues to work but is undocumented.)

{p 4 9 2} 
20.  New command {cmd:rotate} performs orthogonal and oblique rotations
     after {helpb factor}, {helpb factormat}, {helpb pca}, and {helpb pcamat}.
     Available rotations include varimax, quartimax, equamax, parsimax,
     minimum entropy, Comrey's tandem 1 and 2, promax power, biquartimax,
     biquartimin, covarimin, oblimin, factor parsimony, Crawford-Ferguson
     family, Bentler's invariant pattern, oblimax, quartimin, and target and
     partial-target matrices; see {help rotate:{bf:[MV] rotate}}.

{p 9 9 2} 
    New command {cmd:rotatemat} performs these same linear
    transformations (rotations) on any Stata matrix.


{marker survival}{...}
{title:What's new:  Survival analysis}

{p 5 9 2}
1.  The {cmd:[ST]} manual now has a glossary that defines commonly used terms
    in survival (or duration) analysis and often explains how these terms are
    used in the manual; see {bf:[ST]} {bf:Glossary}.

{p 5 9 2}
2.  New command {cmd:estat} can be used after {cmd:stcox} and {cmd:streg}.
    In addition to the standard {cmd:estat} statistics -- information
    criteria, estimation sample summary, and formatted variance-covariance
    matrix (VCE) -- statistics specific to the proportional hazards estimator
    are available after {cmd:stcox}.  These include

{p 9 13 2}
	a.  {cmd:estat concordance} computes 
            Harrell's C and Somer's D statistics measuring concordance -- 
	    agreement of predictions with observed failure order.

{p 9 13 2}
        b.  {cmd:estat phtest} replaces the existing
            {cmd:stphtest} for computing tests and graphs of the proportional
            hazards assumption.  {cmd:stphtest} continues to work.

{p 9 9 2}
        See
        {helpb stcox postestimation:[ST] stcox postestimation}
        and 
        {helpb streg postestimation:[ST] streg postestimation}.

{p 5 9 2}
3.  Existing command {cmd:sts graph} has new options {cmd:cihazard} 
    and {cmd:per(}{it:#}{cmd:)}.  {cmd:cihazard} draws pointwise confidence
    bands around the smoothed hazard function, and {cmd:per()} specifies the
    units used to report the survival or failure rate.  See 
    {helpb sts:[ST] sts}.

{p 5 9 2}
4.  Existing command {cmd:stcurve} now
    plots over an evenly spaced grid, producing smooth curves, even in
    small samples;
    see {helpb stcurve:[ST] stcurve}.

{p 5 9 2}
5.  Existing command {cmd:sts graph} has new options {cmd:atriskopts()} and
    {cmd:lostopts()} that let you control how the labels for at-risk and lost
    observations look (their color, font size, etc.); see 
    {helpb sts:[ST] sts}.

{p 5 9 2}
6.  Existing command {cmd:stci} has new options for controlling how the
    plotted survival line looks (color, thickness, etc.) and for adding
    titles, controlling legends, and all other characteristics of the graph;
    see {helpb stci:[ST] stci}.


{marker general}{...}
{title:What's new:  General-purpose statistics}

{p 5 9 2}
1.  New estimation command {cmd:asmprobit} fits multinomial probit (MNP)
    models to
    categorical data and is frequently used in choice-based modeling.
    {cmd:asmprobit}
    allows several correlation structures for the alternatives,
    including completely unstructured, where all possible
    correlations are estimated.  It also allows for either heteroskedastic or
    homoskedastic variances among the alternatives and allows arbitrary
    patterns within the alternative variances or correlations.
    {cmd:asmprobit}'s syntax makes specifying both case-specific
    and alternative-in-case-specific regressors easy.

{p 9 9 2}
    In addition to common postestimation commands, such as {cmd:mfx} 
    for
    computing marginal effects, new command {cmd:estat} 
    provides
    additional statistics and results:

{p 9 13 2}
    a.  {cmd:estat} {cmd:alternatives} reports summary statistics about each
	of the alternatives and provides a mapping between the
	index numbers labeling the alternatives and their associated values
	and labels in the dataset.

{p 9 13 2}
    b.  {cmd:estat} {cmd:covariance} computes and reports the estimated
        covariance matrix for the alternatives.

{p 9 13 2}
    c.  {cmd:estat} {cmd:correlation} reports the correlations among the
        alternatives in matrix form.

{p 9 9 2}
    Predicted statistics after {cmd:asmprobit} include the linear predictor,
    the probability an alternative is selected, and the standard error of the
    linear predictor.

{p 9 9 2}
    See 
    {help asmprobit:{bf:[R] asmprobit}},
    and 
    {help asmprobit postestimation:{bf:[R] asmprobit postestimation}}.

{p 5 9 2}
2.  New estimation command {cmd:mprobit} also fits multinomial probit models
    to categorical data but in the simplified situation of having only
    case-specific covariates (as with the multinomial logistic regression,
    {cmd:mlogit}).
    Maximizing the likelihood is much faster in such cases
    because the numeric approximation to the likelihood is simpler.
    See 
    {help mprobit:{bf:[R] mprobit}}.

{p 5 9 2}
3.  New estimation command {cmd:slogit} fits the stereotype logistic regression
    model for categorical dependent variables.  This model can be viewed as
    either a generalization of the multinomial logistic regression model
    ({cmd:mlogit}) or a generalization of the ordered logistic regression
    model ({cmd:ologit}) that relaxes the proportional-odds assumption. 
    See {help slogit:{bf:[R] slogit}}.

{p 9 9 2}
    Predicted statistics after {cmd:slogit} include the linear predictor,
    the probability of any or all outcomes, and the standard error of the
    linear predictor.
    See {help slogit postestimation:{bf:[R] slogit postestimation}}.

{p 5 9 2}
4.  New estimation command {cmd:ivprobit} fits probit regression models of
    binary outcomes with endogenous regressors.  Estimation can be performed
    by maximum likelihood estimation (MLE) or by Newey's minimum chi-squared
    two-step estimation, but some postestimation facilities,
    such as computing marginal effects with {cmd:mfx}, are available only
    after ML estimation -- the two-step estimator imposes a transformation
    that invalidates many postestimation results.  
    See {help ivprobit:{bf:[R] ivprobit}}.

{p 5 9 2}
5.  New estimation command {cmd:ivtobit} fits linear regression models with
    censored dependent variables by maximum likelihood estimation or by
    Newey's minimum chi-squared two-step estimation (but see the note about
    the two-step estimator in 4 above).  
    See {help ivtobit:{bf:[R] ivtobit}}.

{p 5 9 2}
6.  New estimation command {cmd:ztp} fits a zero-truncated Poisson
    model of event counts with truncation at zero.

{p 9 9 2}
    Predicted statistics after {cmd:ztp} include the linear predictor and its
    standard error, the predicted number of events, the incidence rate, the
    conditional mean, and the likelihood score
    See {help ztp:{bf:[R] ztp}}
    and 
    {help ztp postestimation:{bf:[R] ztp postestimation}}.

{p 5 9 2}
7.  New estimation command {cmd:ztnb} fits a zero-truncated negative
    binomial model of event counts with truncation at zero and over or under
    dispersion.

{p 9 9 2}
    Predicted statistics after {cmd:ztnb} include the linear predictor and its
    standard error, the predicted number of events, the incidence rate, the
    conditional mean, and the likelihood scores
    See {help ztnb:{bf:[R] ztnb}}
    and
    {help ztnb postestimation:{bf:[R] ztnb postestimation}}.

{p 5 9 2}
8.  New estimation commands {cmd:mean}, {cmd:ratio}, {cmd:proportion}, and
    {cmd:total} estimate means, ratios, proportions, and totals over the
    entire sample or over groups within the sample.  When estimating over
    groups, the entire covariance matrix (VCE) is estimated.  These are 
    full estimation commands that support a range of postestimation facilities,
    such as linear and nonlinear tests among the groups ({helpb test} and
    {helpb testnl}) and linear and nonlinear combinations of group-level
    statistics ({helpb lincom} and {helpb nlcom}).  All four commands support
    several SE and VCE estimates:  robust, cluster-robust, bootstrap,
    jackknife, and observed information matrix (the default).  

{p 9 9 2}
    {cmd:mean}, {cmd:ratio}, and {cmd:proportion} also support direct
    standardization across strata (groups) using the {cmd:stdize()} and
    {cmd:stdweight()} options.

{p 9 9 2}
    See {help mean:{bf:[R] mean}},
        {help ratio:{bf:[R] ratio}},
        {help proportion:{bf:[R] proportion}},
    and {help total:{bf:[R] total}}.

{p 5 9 2}
9.  To avoid conflict with the new {cmd:mean} command, existing command
    {cmd:means} has been renamed {cmd:ameans}, with synonyms
    {cmd:gmeans} and {cmd:hmeans}.

{p 4 9 2}
10.  Existing command {cmd:nl} has a new syntax that makes estimating
    nonlinear least-squares regressions easier.  For most models, estimation
    is now as easy as typing the nonlinear expression.  Full programmability
    has been retained for complex models, and the old syntax continues to work.

{p 9 9 2}
    {cmd:nl} also now supports robust (Huber/white/sandwich) and
    cluster-robust SE and VCE estimates, including two popular 
    adjustments that can dramatically improve the small-sample
    performance of robust SE and VCE estimates.  
    
{p 9 9 2}
    A number of new reporting and estimation options have also been added.
    See {help nl:{bf:[R] nl}}.


{p 4 9 2}
11.  New option {cmd:vce()} selects how standard errors (SEs) and covariance
     matrix of the estimated parameters are estimated by most estimation
     commands.
     Choices are {cmd:vce(oim)}, 
     {cmd:vce(opg)}, 
     {cmd:vce(robust)}, 
     {cmd:vce(jackknife)}, and 
     {cmd:vce(bootstrap)}, although the choices can vary estimator by 
     estimator.
     {cmd:vce(robust)} is a synonym for {cmd:robust}, and you can use either.
     What is new are {cmd:vce(jackknife)} and {cmd:vce(bootstrap)}.


{p 9 9 2}
     {cmd:vce(bootstrap)} specifies that the standard errors, significance
     tests, and confidence intervals be normal-based bootstrap estimates,
     rather than the default analytic estimates based on the observed
     information matrix.  You can also produce percentile-based or
     bias-corrected confidence intervals after estimation using 
     {cmd:estat bootstrap}; 
     see {helpb bootstrap postestimation:[R] bootstrap postestimation}.  

{p 9 9 2}
     {cmd:vce(jackknife)} specifies that the standard errors, significance
     tests, and confidence intervals be jackknife estimates.

{p 9 9 2}
     Both {cmd:vce(bootstrap)} and {cmd:vce(jackknife)} will automatically
     perform either observation or cluster sampling, whichever is appropriate
     for the estimator.

{p 9 9 2}
     Notably, both {cmd:vce(bootstrap)} and {cmd:vce(jackknife)} compute
     bootstrapped or jackknifed estimates of the complete VCE matrix.  This
     means that many of Stata's postestimation commands are available.  You
     can form linear and nonlinear combinations or functions of the parameters
     and obtain jackknife or normal-based bootstrap standard errors and
     confidence intervals for the combinations using {manhelp lincom R} and 
     {manhelp nlcom R}.  Similarly, you can perform linear and nonlinear tests
     using {manhelp test R} and {manhelp testnl R}.


{p 4 9 2}
12.  New command {cmd:estat}
     centralizes 
     the computing and reporting of additional statistics after 
     estimation, just as {cmd:predict} does with predictions.
     {cmd:estat} allows subcommands.  {cmd:estat} {cmd:summarize}, for
     instance, reports summary statistics for the estimation sample 
     and can be used after any estimator.
     {cmd:estat} also allows subcommands that are specific to the 
     estimation command.  To find out what is available after a command, 
     see the corresponding postestimation entry.  For example, after 
     {bf:[R] regress}, see 
     {help regress postestimation:{bf:[R] regress postestimation}};
     or after {bf:[XT] xtmixed}, see
     {help xtmixed postestimation:{bf:[XT] xtmixed postestimation}}.

{p 9 9 2}
    Existing postestimation commands have been brought into the
    {cmd:estat} framework:


	         Estimation       Old          New {cmd:estat}
	         command          command      command
	         {hline 50}
                 {cmd:regress}          {cmd:ovtest}       {cmd:estat} {cmd:ovtest}
                                  {cmd:hettest}      {cmd:estat} {cmd:hettest}
                                  {cmd:szroeter}     {cmd:estat} {cmd:szroeter}
                                  {cmd:vif}          {cmd:estat} {cmd:vif}
                                  {cmd:imtest}       {cmd:estat} {cmd:imtest}
        
                 {cmd:regress}          {cmd:dwstat}       {cmd:estat} {cmd:dwatson}
                 (time series)    {cmd:durbina}      {cmd:estat} {cmd:durbinalt}
                                  {cmd:bgodfrey}     {cmd:estat} {cmd:bgodfrey}
                                  {cmd:archlm}       {cmd:estat} {cmd:archlm}
        
                 {cmd:anova}            {cmd:ovtest}       {cmd:estat} {cmd:ovtest}
                                  {cmd:hettest}      {cmd:estat} {cmd:hettest}
        
                 {cmd:logit} and        {cmd:lstat}        {cmd:estat} {cmd:classification}(*)
                 {cmd:logistic}         {cmd:lfit}         {cmd:estat} {cmd:gof}(*)
        
                 {cmd:poisson}          {cmd:poisgof}      {cmd:estat} {cmd:gof} 
        
                 {cmd:stcox}            {cmd:stphtest}     {cmd:estat} {cmd:phtest}

                 {cmd:xtgee}            {cmd:xtcorr}       {cmd:estat} {cmd:wcorrelation}
	         {hline 50}
		 (*) The new command works after {cmd:probit}, as well
                     as {cmd:logit} and {cmd:logistic}; the old command worked
                     after {cmd:logit} and {cmd:logistic} only.

{p 9 9 2}
The original commands continue to work but are undocumented.

{p 9 9 2} 
    Three {cmd:estat} subcommands are available after almost all estimators:

{p 9 13 2}
    a.  {cmd:estat} {cmd:ic} reports Akaike's and Schwarz's Bayesian
        information criteria (AIC and BIC).

{p 9 13 2}
    b.  {cmd:estat} {cmd:summarize} reports summary statistics on the
        variables in the estimation model for the estimation sample.

{p 9 13 2}
    c.  {cmd:estat} {cmd:vce} reports the covariance (VCE) or correlation
        matrix estimates.  ({cmd:estat} {cmd:vce} replaces the old 
        {cmd:vce} command and has more features.)

{p 4 9 2}
13.  Stata has many new prefix commands (commands that behave like {cmd:by:}
     and {cmd:xi:}).  New prefix commands include {cmd:statsby:},
     {cmd:bootstrap:}, {cmd:jackknife:}, {cmd:permute:}, {cmd:simulate:},
     {cmd:stepwise:}, {cmd:svy:}, and {cmd:rolling:}.  For instance, to obtain
     the standard error and confidence interval of the mean, you might type

		{cmd:. jackknife: mean earnings}

{p 9 9 2}
     or to obtain survey-adjusted estimates, you might type 

		{cmd:. svy:  mean earnings}

{p 9 9 2}
     after {cmd:svyset}ting your data.

{p 9 9 2}
    See 
    {help bootstrap:{bf:[R] bootstrap}},
    {help jackknife:{bf:[R] jackknife}},
    {help permute:{bf:[R] permute}},
    {help rolling:{bf:[TS] rolling}},
    {help simulate:{bf:[R] simulate}},
    {help stepwise:{bf:[R] stepwise}},
    {help statsby:{bf:[D] statsby}}, 
    and
    {help svy:{bf:[SVY] svy}}.

{p 4 9 2}
14.  New prefix commands {cmd:bootstrap:} and {cmd:jackknife:} replace old
     commands {cmd:bs} and {cmd:jknife}, and in addition to having better
     syntax, they also provide new features:

{p 9 13 2}
    a.  They handle and report of expressions better.

{p 9 13 2}
    b.  They post their results as
        estimation results with a complete VCE.  Most postestimation
        facilities may now be used after them and will be based on 
        the bootstrap or jackknife VCE.  These include

{p2colset 17 28 30 0}{...}
{p2col:{helpb adjust}}adjusted predictions{p_end}
{p2col:{helpb estimates}}cataloging estimation results{p_end}
{p2col:{helpb lincom}}linear combinations with SEs, tests, and CIs{p_end}
{p2col:{helpb nlcom}}nonlinear combinations with SEs, tests, and CIs{p_end}
{p2col:{helpb mfx}}computing marginal effects and elasticities{p_end}
{p2col:{helpb predict}}predictions, residuals, probabilities, etc.{p_end}
{p2col:{helpb predictnl}}generalized nonlinear predictions with SEs and CIs{p_end}
{p2col:{helpb test}}Wald tests of simple and composite linear hypotheses{p_end}
{p2col:{helpb testnl}}Wald tests of nonlinear hypotheses{p_end}
{p2colreset}{...}

{p 9 13 2}
    c.  They produce a model test when
        applied to the coefficients of estimation commands.

{p 9 13 2}
    d.  They allow option {opt seed(#)} to set the random-number seed.

{p 9 13 2}
    e.  They allow option {opt reject(exp)} to reject replicates that
        explicitly match {it:exp}.

{p 9 13 2}
    f.  {cmd:bootstrap:} uses the normal distribution
        instead of the Student's t distribution to compute the
	normal-approximation confidence intervals.

{p 9 13 2}
    g.  {cmd:jackknife:} now allows {cmd:fweight}s to be specified.

{p 9 9 2}
See
    {help bootstrap:{bf:[R] bootstrap}} and
    {help jackknife:{bf:[R] jackknife}}.


{p 4 9 2}
15.  New prefix command {cmd:statsby:} replaces old command {cmd:statsby} (not
     a prefix) and provides enhanced handling and reporting of expressions,
     allows {cmd:weights}, and allows string variables in the option 
     {opt by()}.
     See {help statsby:{bf:[D] statsby}}.

{p 4 9 2}
 16.  New prefix command {cmd:stepwise:} replaces old command 
      {cmd:sw} and, in addition to working with all the previous estimators,
      also works with {helpb intreg:[R] intreg} and {helpb scobit:[R] scobit}.

{p 4 9 2}
17.  Existing prefix command {cmd:xi:} has new option {opt noomit} that
     prevents it from omitting a category when generating category indicators
     for group variables.
     See {helpb xi:[R] xi}.

{p 4 9 2}
18.  New command {cmd:tetrachoric} computes a tetrachoric correlation
    matrix for a set of binary variables.  See
    {helpb tetrachoric:[R] tetrachoric}.

{p 4 9 2}
19.  Existing command {cmd:suest}, which combines estimation results for
    subsequent testing, is easier to use and has new features:
	
{p 9 13 2}
        a.  Scores are now computed for the models you
            combine; you no longer need to save scores when
	    estimating.

{p 9 13 2}
        b.  {cmd:suest}, used after {cmd:svy:} estimation, now accounts 
           for your survey design.

{p 9 13 2}
        c.  {cmd:suest} now works more smoothly with certain estimation
            commands that previously required special treatment, including 
            {helpb regress}, {helpb ologit}, and {helpb oprobit}.

{p 9 13 2}
        d.  {cmd:suest} now works with all models estimated by {cmd:clogit},
	    rather than only those with a single positive outcome per group.

{p 9 9 2}
        See {help suest:{bf:[R] suest}}.

{p 4 9 2}
20.  Existing command {cmd:clogit} has new features:

{p 9 13 2}
	a.  Robust and cluster-robust SE and VCE estimates are now supported
	    through options {cmd:robust} and {cmd:cluster()}.

{p 9 13 2}
	b.  Linear constraints on the parameters are now implemented via
	    option {cmd:constraints()}.

{p 9 13 2}
	c.  New option {cmd:vce()} allows SE and VCE estimates to be
	    computed using OIM (the default), OPG, bootstrap, and jackknife.

{p 9 9 2}
    See {help clogit:{bf:[R] clogit}}.

{p 4 9 2} 
21.  Option {cmd:level()} now allows noninteger
     confidence levels to be specified.
     See {help estimation options:{bf:[R]} estimation options}.

{p 4 9 2}
22.  Existing command {cmd:predict} now generates equation-level scores
     after most maximum-likelihood estimation commands; see the documentation
     of {cmd:predict} in the postestimation entry for each estimation command.

{p 4 9 2}
23.  Existing command {help cumul} has a new option {cmd:equal} to create
     equal cumulative values for ties.  See {help cumul:{bf:[R] cumul}}.

{p 4 9 2}
24.  Existing command {cmd:estimates table} now allows you to specify more
     models, and the command wraps the table if necessary.  
     Also allowed are new options

{p 9 13 2}
        a.  {cmd:equations()}, which matches equations by number rather than
            by name.

{p 9 13 2}
        b.  {cmd:coded}, which displays the table in a compact, symbolic
            format.

{p 9 13 2}
        c.  {cmd:modelwidth()}, which sets the number of characters for
            displaying model names.

{p 9 9 2}
See {helpb estimates:[R] estimates}.

{p 4 9 2}
25.  {cmd:test} after {helpb anova} and {helpb manova} has two new options
        for performing Wald tests:

{p 9 13 2}
    a.  {cmd:mtest()}, which implements three methods to adjust for multiple
        tests: Bonferroni, Holm, and Sidak.

{p 9 13 2}
    b.  {cmd:test()}, which makes specifying contrasts easier by accepting a
         matrix containing the contrast.

{p 9 9 2}
See {helpb anova postestimation:[R] anova postestimation}.

{p 4 9 2}
26.  Commands {cmd:ci} and {cmd:cii} have new options {cmd:exact},
     {cmd:wilson}, {cmd:agresti}, {cmd:jeffreys}, and {cmd:wald} for computing
     different types of binomial confidence intervals.
     See {help ci:{bf:[R] ci}}.

{p 4 9 2}
27.  Command {cmd:hausman} has new option {cmd:df()} for controlling the
     degrees of freedom.  See {help hausman:{bf:[R] hausman}}.

{p 4 9 2}
28.  {cmd:predict} after {helpb ivreg} has the new {opt score} option for
     returning equation-level scores.
     See {bf:[R] ivreg postestimation}.

{p 4 9 2}
29.  Command {cmd:mfx} is now faster and has new option {cmd:varlist()} for
     computing effects of specific variables.  See {help mfx:{bf:[R] mfx}}.

{p 4 9 2}
30.  Commands {cmd:tabulate} and {cmd:tabi} with the {cmd:exact} option are
     now significantly faster.

{p 4 9 2} 
31.  In existing command {cmd:mlogit}, option {cmd:basecat} has been renamed
     {cmd:baseoutcome()} for better consistency with the terminology of choice
     models.
     See {helpb mlogit:[R] mlogit}.

{p 4 9 2} 
32.  Existing commands {cmd:spearman} and {cmd:ktau} now allow more than
    two variables to be specified and have more flexible output.
    See {helpb spearman:{bf:[R] spearman}}.

{p 4 9 2}
33.  Existing command {cmd:bsample} for sampling with replacement
    (bootstrap sampling) now supports weighted bootstrap resampling using the
    new {cmd:weight()} option.
    See {help bsample:{bf:[R] bsample}}.  

{p 4 9 2}
34.  Existing command {cmd:bstat} for reporting bootstrap results has a
     number of new reporting options.  In addition, {cmd:bstat} previously
     computed percentile and other confidence intervals.  This is now handled
     by {cmd:estat bootstrap}, which can be used after any bootstrap estimation,
     including {cmd:bstat}.  See {help bstat:{bf:[R] bstat}} and
    {help bootstrap postestimation:{bf:[R] bootstrap postestimation}}.  

{p 4 9 2}
35.  Most maximum likelihood estimators now test for convergence using
     the Hessian-scaled gradient, g*inv(H)*g'.  This criterion ensures that
     the gradient is close to zero when scaled by the Hessian (the curvature
     of the likelihood or pseudolikelihood surface at the optimum) and
     provides greater assurance of convergence for models whose likelihoods
     tend to be difficult to optimize, such as those for {cmd:arch},
     {cmd:asmprobit}, and {cmd:scobit}.  You can set the tolerance level for
     this test with new option {cmd:nrtolerance()}, show the Hessian-scaled
     gradient in the iteration log with option {cmd:shownrtol}, and turn the
     test off with option {cmd:nonrtolerance}.  
     See {help maximize:{bf:[R]} maximize}.

{p 4 9 2}
36.  Existing command {cmd:set} has new setting {cmd:maxiter} -- default 
    value 16000 -- that specifies the maximum number of iterations to be
    performed by all estimation commands.  You change this setting by typing
    {bind:{cmd:set} {cmd:maxiter} {it:#}}, and you may add option
    {cmd:permanently} to retain the setting in future Stata sessions.


{marker ml}{...}
{title:What's new:  New ML features}

{pstd}
Command {cmd:ml}, for implementing user-written maximum-likelihood
    estimators, has many new features:

{p 5 9 2}
    1.  New option {cmd:technique()} sets the optimization technique.  BHHH,
        DFP, and BFGS optimization techniques are now available; the default
        technique remains modified Newton-Raphson.

{p 5 9 2}
    2.  New option {cmd:vce()} sets the type of 
        covariance-matrix calculations that will be made.

{p 12 12 2}
	{cmd:vce(oim)} specifies the observed information matrix (OIM), also
		called the Hessian-based estimator; this is 
                (and always has been) the default.

{p 12 12 2}
	{cmd:vce(opg)} specifies the outer product of the gradients (OPG).
		This is new.

{p 12 12 2}
	{cmd:vce(robust)} specifies Taylor-series linearization, also known
                as the Huber or White estimator and, in Stata, as simply 
                robust.  

{p 5 9 2}
    3.  Most estimators written with {cmd:ml} now support estimation with
        survey data and correlated data with no additional programming.  This
        support includes correct treatment of multistage designs, weighting,
        stratification, poststratification, and finite-population corrections,
        as well as access to linearization, jackknife, and bootstrap 
	variance estimators.  For a discussion,
        see {help program properties:{bf:[P] program properties}}.

{p 5 9 2}
    4.  {cmd:ml} has always allowed linear constraints to be applied using the
        option {cmd:constraints()} with no additional programming.  It now
        handles irrelevant constraints more elegantly.  Irrelevant constraints
        are those that have no impact on the model.  Previously, irrelevant
        constraints caused an error message.  Now they are flagged and
        ignored.

{p 5 9 2}
    5.  When linear constraints are imposed,
        {cmd:ml} now applies a Wald test for the overall
        fit of the model, rather than attempting a likelihood-ratio (LR)
        test, which is often inappropriate.

{p 5 9 2}
    6.  {cmd:ml} has new subcommand {cmd:score} for generating 
	scores after fitting a model.

{p 5 9 2}
    7.  {cmd:ml} has new option {cmd:diparm_options()}
        that automatically performs transformations of ancillary parameters.

{p 5 9 2}
    8.  {cmd:ml} now saves the gradient vector in {cmd:e(gradient)}.

{p 5 9 2}
    9.  {cmd:ml} has new option {cmd:search(norescale)} that prevents
	rescaling when searching for starting values.

{p 4 9 2}
   10.  {cmd:ml} honors the new setting for maximum iterations, 
        {cmd:set maxiter} {it:#}, and will iterate a maximum of {it:#}
	iterations, even if convergence has not been achieved.
	
{p 4 9 2}
   11.  {cmd:ml} now displays a prominent message in the footer of the
        estimation results when convergence is not achieved.  This message
        continues to be shown on redisplay of estimation results.

{p 4 9 2}
   12.  {cmd:ml} has new option {cmd:nofootnote} to suppress printing
        the new message warning if convergence is not achieved.

{p 4 9 2}
   13.  {cmd:ml} tests for convergence using the Hessian-scaled gradient -- 
        g*inv(H)*g'.  This is a true convergence criterion that ensures that
	the gradient is close to zero when scaled by the Hessian (the
	curvature of the likelihood or pseudolikelihood surface at the
	optimum).  This new criterion is particularly important when
	maximizing difficult likelihoods to prevent stopping the
	maximization too soon.

{p 4 9 2}
   14.  New option {cmd:nrtolerance()} lets you change the tolerance for the
        Hessian-scaled gradient convergence criterion; the default is
        {cmd:nrtolerance(1e-5)}.

{p 4 9 2}
   15.  New option {opt shownrtolerance}
        displays the criterion value of the Hessian-scaled gradient at each
	iteration.

{p 4 9 2}
   16.  New undocumented command {cmd:mlmatbysum} helps you compute the
        Hessian of panel-data likelihoods and is of interest to those seeking
        the speed that comes with programming your own second-derivative
        calculations; see {helpb mlmatbysum}.

{p 4 9 2}
   17.  {cmd:ml} has two new undocumented subcommands -- {cmd:ml} {cmd:hold} 
        and {cmd:ml} {cmd:unhold} -- to assist in solving nested optimization
        problems, see {helpb ml_hold}.

{pstd}
     See {helpb ml:[R] ml} 
     for more information on these features. 
     Anyone programming estimators using {cmd:ml} should read 
     the book 
     {it:{browse "http://www.stata.com/bookstore/mle.html":Maximum Likelihood Estimation with Stata, 2nd Edition}} (Gould, Pitblado, and Sribney 2003).
     Many of the features mentioned above are discussed and applied to real
     problems in the book.


{marker functions}{...}
{title:What's new:  Functions and expressions}

{p 5 9 2} 
1.   The limit for the number of dyadic operators has been
     increased from 200 to 500; see {help limits}.

{p 5 9 2} 
2.  The default matrix size ({cmd:matsize}) for Intercooled Stata is now 200,
    rather than 40.  The default for Stata/SE remains 400, and for Small
    Stata it is 40.

{p 5 9 2} 
3.  The following new functions have been added in the context of 
    expressions, such as {cmd:generate} {it:newvar} {cmd:=} {it:exp} or 
    {cmd:if} {it:exp}:

		name            purpose
		{hline 46}
		{cmd:binormal()}      bivariate normal cumulative
		{cmd:atan2()}         two-argument arc tangent

		{cmd:regexm()}        regular expression matching
		{cmd:regexr()}        regular expression replacement
		{cmd:regexs()}        regular subexpressions

		{cmd:indexnot()}      first string {it:s1} not in {it:s2}
		{hline 46}

{p 9 9 2}
See {helpb functions:[FN] Functions by category} or type {cmd:help} followed
by the function name, such as {cmd:help binormal()}.

{p 9 9 2}
In addition, a host of new functions are available through Mata; 
see {helpb m4_intro:[M-4] Intro}.

{p 5 9 2} 
4.  The following existing functions have been renamed:

		old name                new name
		{hline 38}
		{cmd:index()                 strpos()}
		{cmd:binorm()                binormal()}
		{cmd:match()                 strmatch()}
		{cmd:norm()                  normal()}
		{cmd:invnorm()               invnormal()}
		{cmd:normd()	             normalden()}
		{cmd:lnfact()                lnfactorial()}
		{cmd:issym()                 issymmetric()}
		{cmd:syminv()                invsym()}
		{hline 38}

{p 9 9 2}
Old names continue to work.  Functions were renamed because the new name is
better and because Mata uses the new name, and you want to be able to use the
same names in both environments.

{p 5 9 2} 
5.  The following existing functions now have two names, and you can use 
    either:

		Name 1                  Name 2
		{hline 38}
		{cmd:lower()                 strlower()}
		{cmd:upper()                 strupper()}
		{cmd:proper()                strproper()}
		{cmd:ltrim()                 strltrim()}
		{cmd:rtrim()                 strrtrim()}
		{cmd:trim()                  strtrim()}
		{cmd:reverse()               strreverse()}
		{cmd:string()                strofreal()}
		{cmd:int()                   trunc()}
		{cmd:length()                strlen()}
		{hline 38}

{p 9 9 2}
In this case, throughout the Stata documentation, we use name 1, 
but you can use name 1 or name 2 in your Stata expressions.  Name 2 matches the
name of the Mata function that does the same thing, so you may want to 
standardize on name 2. 

{p 4 9 2}
6.  The following {cmd:egen} functions have been renamed:

		old name    new name
		{hline 24}
		{cmd:any()}	  {cmd:anyvalue()}
		{cmd:eqany()}	  {cmd:anymatch()}
		{cmd:neqany()}	  {cmd:anycount()}
		{cmd:rfirst()}	  {cmd:rowfirst()}
		{cmd:rlast()}	  {cmd:rowlast()}
		{cmd:rmean()}	  {cmd:rowmean()}
		{cmd:rmin()}	  {cmd:rowmin()}
		{cmd:rmiss()}	  {cmd:rowmiss()}
		{cmd:robs()}	  {cmd:rownonmiss()}
		{cmd:rsd()}	  {cmd:rowsd()}
		{cmd:rsum()}	  {cmd:rowtotal()}
		{cmd:sum()}	  {cmd:total()}
		{hline 24}

{p 9 9 2}
The new names are more consistent.
Old names continue to work but are not documented.


{marker data}{...}
{title:What new:  Data management}

{p 5 9 2}
1.  There is a new manual {bf:[D] Data management}, and the 
    data-management commands have been moved from {bf:[R]} to {bf:[D]}.
    See {bf:[D] Intro} for an expanded what's new for data-management
    capabilities.

{p 5 9 2}
2.  Existing command {cmd:set} {cmd:type} now has a {cmd:permanently}
    option.  You can now permanently set the default {help datatype} to either
    {cmd:float} (the factory default) or {cmd:double}.

{p 5 9 2}
3.  New commands {cmd:xmlsave} and {cmd:xmluse} save and restore datasets 
    in Extended Markup Language (XML) format.  Data may be saved or used in
    either Stata {cmd:dta} XML format or Microsoft Excel's SpreadsheetML
    format.  See {helpb xmlsave:[D] xmlsave}.

{p 5 9 2}
4.  New commands {cmd:fdasave}, {cmd:fdause}, and {cmd:fdadescribe} 
    save, use, and describe files in the format required by the U.S. Food and
    Drug Administration (FDA) for new drug and device applications (NDAs).
    These commands are designed to assist people making submissions to the
    FDA, but the commands are general enough for use in transferring data
    between SAS and Stata.  The FDA format is identical to the SAS XPORT
    Transport format.  See {helpb fdasave:[D] fdasave}.

{p 5 9 2}
5.  Value labels may now be up to 32,000 characters long.

{p 5 9 2}
6.  Existing command {cmd:label} has a new subcommand {cmd:language} that
    lets you create and use datasets containing different 
    variable, value, and data labels, which might be in different languages.
    See {helpb label_language:[D] label language}.

{p 5 9 2}
7.  Datasets from the examples in the Stata manuals can now be 
    browsed, described, and used.  Type help 
    {help dta contents}, or select {bf:File} {bf:> Example} {bf:datasets...}
    from the Stata menu.

{p 5 9 2}
8.  {cmd:statsby} is now a prefix command; see 
    {helpb prefix:[U] 11.1.10 Prefix commands}.
    For information on its new syntax, see {helpb statsby:[D] statsby}.
     Enhancements to {cmd:statsby} include

{p 9 13 2}
	a.  Rather than requiring a list of expressions for the 
            statistics to collect, {cmd:statsby} now collects a default set.

{p 9 13 2}
	b.  Expressions to be computed and saved can now 
            be grouped together as equations; see {help exp_list}.

{p 9 13 2}
	c.  String variables are now allowed.

{p 9 13 2}
	d.  Weights are now allowed.

{p 9 13 2}
	e.  New option {cmd:force} forces {cmd:statsby} to work with 
           {help svy:survey} estimators.  By default, this is prevented
           because the method {cmd:statsby} uses to select subsamples will
           generally not produce appropriate standard-error estimates with
           survey data (the {cmd:subpop} option must be used with survey
           data).

{p 9 13 2}
	f.  Dots showing the progress of computations are now shown by default.

{p 9 13 2}
	g.  New option {cmd:nolegend} suppresses the table reporting
	    on what {cmd:statsby} is running.

{p 5 9 2}
9.  New command {cmd:filefilter} copies an input file to an output file while
    converting a specified ASCII or binary pattern to another pattern; see
    {helpb filefilter:[D] filefilter}.

{p 4 9 2}
10.  New command {cmd:expandcl} replicates clusters of unique observations,
     much like an {cmd:expand}, but for clustered data; see
     {helpb expandcl:[D] expandcl}.

{p 4 9 2}
11.  New command {cmd:tostring} converts numeric variables to string;
     see {helpb tostring:[D] tostring}.

{p 4 9 2}
12.  Existing command {cmd:codebook} now allows {cmd:if} and {cmd:in}
     qualifiers; see {helpb codebook:[D] codebook}.

{p 4 9 2}
13.  New command {cmd:rmdir} removes an existing directory (folder);
     see {helpb rmdir:[D] rmdir}.

{p 4 9 2}
14.  New command {cmd:clonevar} makes an identical copy of an
     existing variable; see {helpb clonevar:[D] clonevar}.

{p 4 9 2}
15.  Existing commands
    {cmd:icd9} and {cmd:icd9p} have been updated to use the V21 codes;
    see {helpb icd9:[D] icd9} and {helpb icd9p:[D] icd9p}.

{p 4 9 2}
16.  Existing command
     {cmd:encode} has new option {cmd:noextend} that prevents adding 
     new value label mappings; see 
     {helpb encode:[D] encode}.

{p 4 9 2}
17.  Existing command {cmd:odbc} for accessing Open DataBase Connectivity
     (ODBC) data sources has the following enhancements:

{p 9 13 2}
	a.  ODBC is now supported under
            Mac OS X and Linux systems that use the iODBC Driver Manager.
            For more information on configuring ODBC for Mac and Linux,
            see the FAQ at 
	    {browse "http://www.stata.com/support/faqs/data/odbcmu.html"}.

{p 9 13 2}
	b.  {cmd:odbc} has new subcommands
            {cmd:odbc insert} and {cmd:odbc exec} for writing data to an ODBC
            data source.  Positioned updates can be performed using the
            {cmd:odbc exec} command.

{p 9 13 2}
        c.  {cmd:odbc} has a new subcommand {cmd:sqlfile} for batch
            processing SQL instructions.

{p 9 13 2}
        d.  {cmd:odbc load} has a new option {cmd:sqlshow} for debugging
            SQL communication with ODBC drivers.

{p 9 13 2}
        e.  {cmd:odbc load} has new options {cmd:allstring} and
            {cmd:datestring}, which import either all data or just dates as
            strings.

{p 9 13 2}
	See {helpb odbc:[D] odbc}.

{p 4 9 2}
18.  Existing command {cmd:merge} has the following new features:

{p 9 13 2}
        a.  It now accepts multiple {cmd:using} files. 
	
{p 9 13 2}
	b.  New option {cmd:nosummary} suppresses creating 
	    variables that summarize how the records were merged.

{p 9 13 2}
         c.  New option {cmd:sort} option sorts the master and 
             using datasets if they are not already sorted.

{p 9 13 2}
         d.  Existing options {cmd:unique}, {cmd:uniqmaster}, and
             {cmd:uniqusing} now require you to specify matching variables.

{p 9 13 2}
	 e.  Warning messages are now given when matching variables do
             not uniquely identify observations.

{p 9 13 2}
	See {helpb merge:[D] merge}.

{p 4 9 2}
19.  Existing commands 
     {cmd:merge} and {cmd:append} now incorporate all notes from the using
     dataset that do not already appear in the master dataset,
     unless new option {cmd:nonotes} is specified; 
     see {helpb merge:[D] merge} and {helpb append:[D] append}.

{p 4 9 2}
20.  Existing command {cmd:contract} has new options {cmd:cfreq()},
    {cmd:percent()}, {cmd:cpercent()}, {cmd:float}, and {cmd:format()} to
    create frequency and percentage variables; see
    {helpb contract:[D] contact}.

{p 4 9 2}
21.  Existing commands
     {cmd:corr2data} and {cmd:drawnorm} now support triangular specification
     of the correlation or covariance matrix; see
     {helpb corr2data:[D] corr2data} and {helpb drawnorm:[D] drawnorm}.

{p 4 9 2}
22.  Existing command
     {cmd:separate} has new option {cmd:shortlabel} 
     to specify that shorter variable labels be created; see
     {helpb separate:[D] separate}.

{p 4 9 2}
23.  Existing command
     {cmd:outfile} has new option {cmd:missing} that preserves both standard
     and extended missing values when the {cmd:comma} option is also
     specified; see {helpb outfile:[D] outfile}.

{p 4 9 2}
24.  Existing command {cmd:clear} now performs {cmd:mata:} {cmd:mata} 
     {cmd:clear} in addition to everything else; see 
     {helpb clear:[D] clear}.


{marker graphics}{...}
{title:What's new:  Graphics}

{p 5 9 2}
1.  Stata now allows multiple Graph windows.  The existing {cmd:name()} option
    now creates a named graph and displays it in its own window.  See
    {bf:What's new:  User interface} below.

{p 5 9 2}
2.  New command {cmd:sunflower} draws sunflower density-distribution
     plots; see {help sunflower:{bf:[R] sunflower}}.

{p 5 9 2}
3.  {cmd:graph twoway} has two new {it:plottypes} for plotting
    time-series data, {cmd:tsline} and {cmd:tsrline}; see 
    {helpb tsline:[TS] tsline} and 
    {helpb tsline:[G] graph twoway tsline}.

{p 5 9 2}
4.  Graphs have better axis labels when graphing dates.

{p 5 9 2}
5.  {cmd:graph twoway} has seven new options that are useful when plotting
    time-formatted variables:  {cmd:tscale()}, {cmd:tlabel()},
    {cmd:tmlabel()}, {cmd:ttick()}, {cmd:tmtick()}, {cmd:tline()}, and
    {cmd:ttext()}; see 
    {help axis_options:{bf:[G]} {it:axis_options}},
    {help added_line_options:{bf:[G]} {it:added_line_options}},
     and 
    {help added_text_options:{bf:[G]} {it:added_text_options}}.

{p 5 9 2}
6.  {cmd:graph twoway} has seven new {it:plottypes} for plotting
    paired-coordinate data -- data with 4 variables, where two variables
    form a starting x-y point and the other two variables form an ending x-y
    point.  The new {it:plottypes} are

{p2colset 10 23 29 2}{...}
{p2col:{it:plottype}}Description{p_end}
{p2line}
{p2col:{helpb twoway pcarrow:pcarrow}}plots a directional arrow for each 
	observation's paired coordinates{p_end}
{p2col:{helpb twoway pcbarrow:pcbarrow}}plots a two-headed arrow for 
	each observation's paired coordinates{p_end}
{p2col:{helpb twoway pcspike:pcspike}}plots a line or spike for each 
	observation{p_end}
{p2col:{helpb twoway pccapsym:pccapsym}}plots a line with symbols at each end
	for each observation{p_end}
{p2col:{helpb twoway pcscatter:pcscatter}}plots both pairs of x-y variables as a
	scatter, using a common style{p_end}
{p2col:{helpb twoway pci:pci}}immediate form of paired-coordinate plots; plots
	the specified coordinate pairs{p_end}
{p2col:{helpb twoway pcarrowi:pcarrowi}}immediate form of {cmd:pcarrow}{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
    See
    {helpb graph_twoway_pcarrow:[G] graph twoway pcarrow},
    {helpb graph_twoway_pcbarrow:[G] graph twoway pcbarrow},
    {helpb graph_twoway_pcspike:[G] graph twoway pcspike},
    {helpb graph_twoway_pccapsym:[G] graph twoway pccapsym},
    {helpb graph_twoway_pcscatter:[G] graph twoway pcscatter},
    {helpb graph_twoway_pci:[G] graph twoway pci},
    and
    {helpb graph_twoway_pcarrowi:[G] graph twoway pcarrowi}.

{p 5 9 2}
7.  {cmd:graph twoway}, {cmd:graph bar}, {cmd:graph box}, and 
    {cmd:graph dot} have new option {cmd:aspectratio()} that controls
    the aspect ratio of a plot region; see 
    {help aspect_option:{bf:[G]} {it:aspect option}}.

{p 5 9 2}
8.  {cmd:graph display} has new option {cmd:scale()} that allows all text,
    symbols, and line widths to be rescaled when a graph is redisplayed;
    see {helpb graph display:[G] graph display}.

{p 5 9 2}
9.  {cmd:graph export} supports new export formats
    TIFF, 
    PNG (portable network graphics),
    and 
    TIFF previews for EPS files.
    See {helpb graph export:[G] graph export}.

{p 4 9 2}
10.  New option {cmd:preview()} with {cmd:graph} {cmd:export}
    embeds a preview of the graph so that it
    can be viewed in publishing applications; 
    see {helpb graph export:[G] graph export} and
    {help eps_options:{bf:[G]} {it:eps options}}.

{p 4 9 2}
11.  {cmd:graph} now supports CMYK output to Postscript and
    Encapsulated Postscript (EPS) files.  CMYK stands for
    Cyan-Magenta-Yellow-blacK and is popular in the printing industry.  
    See {helpb graph export:[G] graph export} and 
    {help ps_options:{bf:[G]} {it:ps_options}}.

{p 9 9 2}
    {cmd:palette color} has the new option {cmd:cmyk}, specifying that
    color values be reported in CMYK; see 
    {helpb palette:[G] palette}.

{p 4 9 2}
12.  {cmd:graph box} can now label outside values using option
     {cmd:marker()}; see 
     {helpb graph box:[G] graph box} and 
     {help marker_label_options:{bf:[G]} {it:marker label options}}.

{p 4 9 2}
13.  {cmd:graph bar} has new options {cmd:over(, reverse)} and
    {cmd:yvaroptions(reverse)} to specify that the categorical scale be
    reversed, that it run from maximum to minimum;
    see {helpb graph bar:[G] graph bar}.

{p 4 9 2}
14.  {cmd:graph twoway} has new option {cmd:pcycle()} that specifies the
    maximum number of plots that may appear on a graph before the
    {help pstyle:pstyles} recycle to the first style; see
     {help advanced_options:{bf:[G]} {it:advanced_options}}.

{p 4 9 2}
15.  {cmd:graph combine} has new option {cmd:altshrink} that provides
     alternate sizing of the text, markers, line thickness, and line patterns
    on the individual combined graphs; see 
    {helpb graph combine:[G] graph combine}.

{p 4 9 2}
16.  {cmd:graph} has improved control over whether the largest and smallest
    possible grid lines are drawn.  This control is provided by improving the
    actions of the existing suboptions [{cmd:no}]{cmd:gmin} and
    [{cmd:no}]{cmd:gmax}; see 
     {help axis_label_options:{bf:[G]} {it:axis_label_options}}.

{p 4 9 2}
17.  {cmd:graph bar}, {cmd:graph dot}, {cmd:graph box}, and
     {cmd:graph pie} have new option {cmd:allcategories} specifying
     that the legend include all {cmd:over()} groups, not just groups in the
     sample specified by {cmd:if} and {cmd:in}.
     See, for example, {helpb graph bar:[G] graph bar}.

{p 4 9 2}
18.  {cmd:graph}, and all other commands that draw graphs, have new
     options for changing the color of objects and changing the
     appearance of lines:

{p 9 13 2}
        a.  Options {cmd:lstyle()}, {cmd:lcolor()}, {cmd:lwidth()}, and
            {cmd:lpattern()} are now accepted anywhere
            {cmd:cl}<{it:attribute}> and the {cmd:bl}<{it:attribute}>
            were allowed.  Specifically, the new options
	    replace the following original options:

{p2colset 20 35 37 21}{...}
{p2col:new options}original options{p_end}
{p2line}
{p2col:{cmd:lstyle()}}{cmd:clstyle()}, {cmd:blstyle()}{p_end}
{p2col:{cmd:lcolor()}}{cmd:clcolor()}, {cmd:blcolor()}{p_end}
{p2col:{cmd:lwidth()}}{cmd:clwidth()}, {cmd:blwidth()}{p_end}
{p2col:{cmd:lpattern()}}{cmd:clpattern()}, {cmd:blpattern()}{p_end}
{p2line}
{p2colreset}{...}

{p 13 13 2}
        The new options can be applied to all lines -- lines connecting
        points, lines outlining bars, lines around text boxes, etc.  The
        original option names continue to work but are undocumented.

{p 9 13 2}
        b.  New option {cmd:fcolor()} changes area fill colors and can be
        used anywhere {cmd:bfcolor()} or {cmd:afcolor()} were allowed.
        {cmd:bfcolor()} and {cmd:afcolor()} continue to work but are
        undocumented.

{p 9 13 2}
        c.  New option {opt color(arg)} sets all of a plot's colors;
            it is the equivalent of specifying {opt mcolor(arg)},
            {opt lcolor(arg)}, and {opt fcolor(arg)}. 

{p 4 9 2} 
19.  The syntax of the ROC curve commands is now consistent across all the
    ROC commands -- {helpb roctab}, {helpb roccomp}, {helpb rocgold}, and
    {helpb rocplot} -- with some new options added and some old options
    changing names.  The original options continue to work but are
    undocumented.
    See {helpb roctab:[R] roctab} 
    and 
    {helpb rocfit postestimation:[R] rocfit postestimation}.

{p 4 9 2} 
20.  Existing commands {helpb fracplot} and {helpb lowess} have new
    option {cmd:lineopts()} that replaces the confusingly named
    {cmd:rlopts()}.

{p 4 9 2} 
21.  Option {cmd:plot()}, available on many graph commands, has been
     renamed {cmd:addplot()}.  {cmd:addplot()} allows 
     {helpb twoway} plots, such as scatters, lines, or function plots to be
     added to most statistical graph commands.

{p 4 9 2}
22.  Command {cmd:kdensity} has new option {cmd:epan2} providing an alternate
    Epanechnikov kernel;
    see {help kdensity:{bf:[R] kdensity}}.
    Accordingly, {helpb sts:sts graph} and {helpb stcurve} now allow
    {cmd:kernel(epan2)} for specifying this new kernel.

{p 4 9 2}
23.  The base margin for {cmd:histogram} graphs is now zero.


{marker gui}{...}
{title:What's new:  User interface}

{pstd}
Stata 9 has a number of new features in the graphical user interface (GUI)
that are shared across all platforms, such as multiple Viewer and
Graph windows.  There are also some significant improvements that affect
only Windows, such as dockable windows.
Most GUI features are documented in the {bf:Getting} {bf:Started} manual.

{p 5 9 2} 
1.  New versions of Stata are available:

{p 9 13 2}
a.  Stata for Intel Itanium-based PCs running 64-bit Windows.

{p 9 13 2}
b.  Stata for x86-64 standard systems, including those based on 
	    AMD Opteron chips, Athlon-64 chips and Intel Xeon emt64 chips
	    running 64-bit Windows.

{p 9 13 2}
c.  Stata for Intel Itanium-based PCs running 64-bit Linux.

{p 9 13 2}
d.  Stata for x86-64 standard systems running 64-bit Linux.

{p 5 9 2} 
2.  Stata for Windows and Stata for Mac now have 
    automatic update checking (nothing is ever downloaded 
    without your confirmation).  The first time you start Stata and every 7th
    day afterward, you will be prompted whether to check for updates.

{p 9 9 2} 
    To control how often you are prompted, or to turn the feature off,
    select {bind:{cmd:Prefs} {cmd:>} {cmd:General} {cmd:Preferences}}, and
    select {bf:Internet}; or you can type {cmd:set} {cmd:update_interval} 
    {it:#} or {cmd:set} {cmd:update_query} {cmd:off} at the Stata prompt;
    see {helpb update:[R] update}.

{p 5 9 2} 
3.  Stata now allows multiple Viewer windows so that you can, for
    example, simultaneously view the help for several commands and the results
    from several logs or search queries.

{p 9 9 2} 
    There are several ways to open another Viewer window.

{p 9 13 2}
    a.  While viewing something in a Viewer, hold down the shift key, and
        click on any link.  A new Viewer will appear displaying 
        the contents of the link.

{p 9 13 2} 
    b.  Right-click on the link, and choose
        {bind:{bf:Open} {bf:Link} {bf:in} {bf:New} {bf:Viewer}}.
        That does the same thing.

{p 9 13 2} 
    c.  Click with the middle mouse button on the link.
        That also does the same thing.

{p 9 13 2} 
    d.  Right-click anywhere in an open Viewer, and choose 
        {bind:{bf:Open} {bf:New} {bf:Viewer}}.  This will open a new
        Viewer displaying {cmd:help contents}.

{p 9 9 2}
    See {bf:5. Using the Viewer}
    in the {it:Getting Started} manual.

{p 5 9 2} 
4.  The Viewer also has the following new features:

{p 9 13 2} 
    a.  It supports links within documents, including help
        files.  You will see this feature used extensively in Stata's online
        help.

{p 9 13 2} 
    b.  It has the ability to search for text
        within the window.  Click on the find icon that looks like a pair of
        binoculars at the top right of the Viewer.

{p 9 13 2} 
    c.  It now remembers its position in the
        document when you click {bf:Refresh}.

{p 9 9 2}
    In addition, both the Viewer and Results windows no longer
    underline links when they are displayed on a white background.  You can
    change this by selecting {bf:Prefs} > {bf:General} {bf:Preferences}.

{p 5 9 2} 
5.  Stata now allows multiple Graph windows.  The existing {cmd:name()} option
    of {helpb graph:[G] graph} now creates a named graph and displays it in
    its own window of the same name.

{p 9 9 2}
    Graph-management commands do what you would expect with the named windows;
    {helpb graph drop} drops the graph and closes its window;
    {helpb graph rename} renames both the graph and its window; and so
    on.  Note that closing a Graph window does not delete the underlying graph
    and the graph can be redisplayed with {helpb graph display}.

{p 5 9 2} 
6.  The {bf:Window} menu now supports multiple Viewer and Graph windows:

{p 9 13 2}
    a.  You can switch to specific Viewers or Graphs from this menu.

{p 9 13 2}
    b.  Menu item {bind:{cmd:Window > Viewer > Close All Viewers}} closes
        the Viewers.

{p 9 13 2}
    c.  Menu item {bind:{cmd:Window Graph > Close All Graphs}} closes 
        the graphs.

{p 5 9 2} 
7.  There are a number of enhancements to the toolbar:

{p 9 13 2}
    a.  The {bf:Open} button now has a menu that shows recently opened 
        datasets and allows you to reopen those datasets with a click.
        This even includes 
        datasets loaded over the web from 
	{bind:{bf:File} {bf:>} {bf:Example} {bf:Datasets...}}
	or with {helpb webuse}.

{p 9 13 2}
    b.  The {bf:Print} button has a new menu that lets you select the window
        to print.

{p 9 13 2}
    c.  The {bf:Viewer} button lets you switch to any Viewer or close all
        Viewers.

{p 9 13 2}
    d.  The {bf:Graph} button lets you switch to any Graph or close all
        Graphs.

{p 9 13 2}
    e.  The {bf:Do-file} {bf:Editor} button lets you switch to any Do-file
        Editor (Windows and Mac).

{p 5 9 2} 
8.  A number of new features and improvements are available under the
    {bf:File} menu:

{p 9 13 2}
    a.  Recently opened datasets can now be reopened by selecting 
        {bind:{bf:File} {bf:>} {bf:Open} {bf:Recent}}, and recently opened
        do-files or ado-files can likewise be reopened from within
        the {bf:Do-file} {bf:Editor} by selecting 
        {bind:{bf:File} {bf:>} {bf:Open} {bf:Recent}}.

{p 9 13 2}
    b.  {bf:File} {bf:>} {bf:Print} lets you select the window to print.

{p 9 13 2}
    c.  All the datasets shipped with Stata and all the datasets used in
        the examples in the manuals can be browsed and loaded by selecting 
	{bind:{bf:File} {bf:>} {bf:Example} {bf:Datasets...}}

{p 5 9 2} 
9.  Stata now allows multiple {bf:Do-file} editors under Windows and
    Mac.
    See 
    {bf:14.} {bf:Using} {bf:the} {bf:Do-file} {bf:Editor}
    in the {it:Getting Started} manual.

{p 4 9 2} 
10.  Contextual menus for common tasks, such as setting preferences, copying
     to the clipboard, and printing, are now available in all windows;
     right-click in the window to access them.

{p 4 9 2} 
11.  You can now define multiple windowing preferences and switch easily among
    those preferences.  For example, you might use small fonts and large
    Review and Variables windows for your normal work, but use
    large fonts with hidden Review and Variables windows for
    presentation.  Access this new feature by selecting 
    {bind:{bf:Prefs} {bf:>} {bf:Manage} {bf:Preferences}}.

{p 4 9 2} 
12.  The {bf: Data} {bf: Editor} has several enhancements:

{p 9 13 2}
    a.  The contents of string variables and variables with value labels are
        now shown in different colors so that they can be easily
        distinguished.

{p 9 13 2}
    b.  Variables with value labels can now be displayed as 
        either the value of the variable or the label.

{p 9 13 2}
    c.  For variables with value labels, you now may change the value of the
        variable by right-clicking on the cell and selecting
        {bind:{bf:Select Value from Value Label}}.  You may then select the
        value and label from a list.

{p 9 13 2}
    d.  You may now associate an existing value label with a variable by
        right-clicking on the variable's column and selecting a value label
        from {bind:{bf:Assign Value Label to Variable}}.

{p 9 13 2}
    e.  You may now define or modify value labels from within the
        Data Editor by right-clicking and selecting
        {bind:{bf:Define/Modify Value Labels...}}.  

{p 9 13 2} 
    f.  You can now access and modify the preferences for the Data
        Editor by right-clicking in the editor and selecting
        {bf:Preferences...}.

{p 4 9 2} 
13.  Dialogs have new features:

{p 9 13 2} 
    a.  Keyboard shortcuts for {bf:Copy}, {bf:Paste}, and {bf:Cut} now work.

{p 9 13 2} 
    b.  Anywhere that you need to select a variable or variables for a
        {varlist}, you may now select those variables from a drop-down list
	(Windows and Mac).

{p 9 13 2} 
    c.  The new copy button will copy the command built by
        the dialog to the clipboard.  The button appears just right of the
        refresh button at the bottom left of each dialog.  It works just like
        {bf:Submit}, but rather than executing the command, it pastes the
	command.

{p 9 13 2} 
    d.  Pressing the {bf:Return} key now works the same as clicking 
        {bf:OK}; pressing {bf:Shift}+{bf:Return} works the same as clicking
        {bf:Submit}.  Pressing the {bf:Escape} key works the same as clicking
        {bf:Cancel}.

{p 9 13 2} 
    e.  Pressing the space bar when the keyboard focus is on a radio button 
        works the same as clicking on the radio button.

{p 9 13 2} 
    f.  Keyboard arrow keys now work with dialog spinner controls.

{p 9 13 2} 
    g.  Estimation-command dialogs are laid out better, with the model
        specification always appearing on the {bf:Model} tab.  You can also
        now select standard error (SE) types with a single click in the
        {bf:SE/Robust} tab (which includes bootstrap and jackknife SEs as
        options for most estimators).

{p 9 13 2} 
    h.  The {helpb twoway} {cmd:graph} dialog boxes are laid out better,
        with easier selection of the plottype (scatter, line, range bar, etc.)
	and the addition of the new paired-coordinate 
	time-series plottypes.

{p 9 9 2}
In addition, the printed manual and online documentation do a better job 
of describing the options and controls available on a dialog.
The option entries in the manual and online are grouped into categories 
that match the tabs on the dialog box.

{p 4 9 2} 
14.  Stata for Windows has vastly improved flexibility for managing your
     work environment:

{p 9 13 2} 
    a.  Most windows -- the dockable ones -- can now be docked with the 
        main Stata window or with each other.  By dragging a dockable window
        over another dockable window, you may create either a single-paned
        window, containing both the original windows with a separator in
        between, or a single window with tabs for each of the original
	windows.  The Viewer, Command, Review, and Variables windows are
        all dockable.

{p 13 13 2} 
        In addition, any of these windows can either be attached (docked) to
        the main Stata window or detached and made free floating.  Each
        also has a {bf:pin} icon in the title bar that makes the window 
        always shown, or 
        makes it roll up into its title bar when undocked, or
        makes it shown only as a tab when docked.  For an overview of these
        features, see {bf:4.} {bf:The} {bf:Stata} {bf:user}
        {bf:interface} in the {it:Getting Started} manual.

{p 9 13 2} 
    b.  Most windows can be moved outside the main Stata window.
        These include the Graph, Viewer, Browse, and Edit
        windows, and include all dialogs.

{p 9 13 2}
     c.  The toolbar can be detached and repositioned.

{p 9 13 2} 
     d.  Double-clicking the Results window, when it is docked, merges
        it with the main Stata window as the primary document.  This saves
        some screen real estate, and we suggest that you try it.
        Double-click again to undo it.

{p 9 13 2} 
    e.  A number of new window preferences available from
        the {bf:Windowing} tab under
        {bind:{bf:Prefs >} {bf:General} {bf:Preferences...}} let you
        control how windows behave and how they dock.  You can lock paned
        windows so that they cannot be resized, turn on or off docking, turn
        on or off the docking guides, make all windows floating, make the
        contents of Viewers persistent so that they maintain their
        contents between Stata sessions, and even turn off all the
        advanced windowing features to lock your current settings.

{p 9 13 2} 
    f.  As with Stata on all other platforms, you can now save multiple
        windowing preferences and choose the one most appropriate for what you
        are doing, for example, working at home, giving a presentation, etc.

{p 9 9 2} 
    If you are fond of the way Stata for Windows worked prior to Stata 9, or
    you like to maximize your Stata window, we suggest that you select from the
    menu
    {bind:{bf:Prefs > Manage Preferences > Load Preferences > Maximized}}.
    Even so, we recommend that you try using the new layout without
    maximizing the Stata window.

{p 4 9 2} 
15.  You may now copy the {bf:Review} window to the Clipboard.
     Right-click in the window to access the contextual
     menu.

{p 4 9 2} 
16.  {helpb help} now displays in the Viewer window;
     new command {helpb chelp} displays in the
     Results window.  {cmd:help} also has two new options:

{p 9 13 2} 
    a.  {cmd:nonew} displays help in the topmost viewer rather than 
        in a new one.

{p 9 13 2} 
     b.  {opt name(viewername)} displays the help in the specified viewer.
         If that name does not exist, a new viewer will be created with
         that name.

{p 4 9 2} 
17.  You may now define and access {helpb note:notes} for a variable by
     right-clicking on the variable name in the {bf:Variables} window.
     Right-clicking on an empty space allows you to define and access 
     notes for the dataset.

{p 4 9 2} 
18.  The {bf:Do-file} {bf:Editor} has a new SMCL preview button on its
     toolbar that displays the current file in the Viewer as rendered
     SMCL.

{p 4 9 2} 
19.  (Windows and Mac) 
     You can now copy selected text as an HTML table
     using {bind:{bf:Edit} {bf:> Copy} {bf:Table} {bf:as} {bf:HTML}}.

{p 4 9 2} 
20.  (Unix) The minimize keyboard shortcut <Ctrl>-m has been added to all
     windows.

{p 4 9 2} 
21.  (Unix) You can now use the Window menu's keyboard shortcuts from any
     window.

{p 4 9 2}
22.  (Mac)
     You can now increase or decrease the font size in a window by 
     pressing Apple + and Apple -.

{p 4 9 2} 
23.  (Mac)
     The ability to undo or redo multiple actions has been added to the
     {help doedit:Do-file editor}.

{p 4 9 2}
24.  (Mac)
     You can now have Stata automatically bring all windows to the front 
     when it is active by selecting 
    {bf:Prefs > General Preferences...}.

{p 4 9 2}
25.  (Mac)
     You can now have Stata automatically snap windows to the edge of the main
     Stata window or to the edge of the screen when you move or resize them
     by selecting {bf:Prefs > General Preferences...}.

{p 4 9 2}
26.  (Mac)
     You can move all of Stata's currently open windows simultaneously by
     holding down the Control key while dragging one of the windows.  This
     will also bring all Stata's open windows to the foreground.

{p 4 9 2}
27.  (Mac)
     The toolbar may be a floating window or may be anchored to the menubar.
     The advantage of making the toolbar float is that it takes up
     less room on the screen and can be moved.  
     Access this feature using {bf:Window} {bf:>} {bf:Toolbar}.


{marker programming}{...}
{title:What's new:  Programming}

{p 5 9 2}
1.  Mata, Stata's new matrix-programming language can by used to code
    ado-file subroutines;  see {helpb m1_ado:[M-1] ado}.

{p 5 9 2}
2.  New command {cmd:viewsource} displays official and user-written 
    source code.  {cmd:viewsource} searches for the specified file along the
    adopath and displays the file in the Viewer.  This works not only for
    ado programs, but also for Mata functions that are programmed themselves
    in Mata.  See {helpb viewsource:[P] viewsource}.

{p 5 9 2}
3.  Programmers of estimation commands or commands that work with estimation
    results can tie postestimation analysis facilities into {help estat}, 
    making their postestimation facilities behave
    just like those shipped with Stata; see {help estat programming}.

{p 5 9 2}
4.  New command {cmd:matlist} provides extensive format control for 
    displaying a matrix; see {helpb matlist:[P] matlist}.

{p 5 9 2}
5.  Macro-extended functions that work on matrices will now work on the
    matrices stored in {cmd:r()} and {cmd:e()}, including {cmd:e(b)} and
    {cmd:e(V)}.  These extended functions include {cmd:rownames},
    {cmd:colnames}, {cmd:roweq}, {cmd:coleq}, {cmd:rowfullnames}, and
    {cmd:colfullnames}.  See {helpb matmacfunc:[P] matrix}.

{p 5 9 2}
6.  {help creturn:c()} (c-class returned values) has the following 
    new items:{p_end}
{p2colset 10 25 28 17}
{p2col:item} description{p_end}
{p2line}
{p2col:{cmd:c(Wdays)}}      "Sun Mon ... Sat"{p_end}
{p2col:{cmd:c(Weekdays)}}   "Sunday Monday Tuesday ... Saturday"{p_end}
{p2col:{cmd:c(alpha)}}      "a b c d e f h j ... x y z"{p_end}
{p2col:{cmd:c(ALPHA)}}      "A B C D E F H J ... X Y Z"{p_end}
{p2col:{cmd:c(Mons)}}       "Jan Feb ... Dec"{p_end}
{p2col:{cmd:c(Months)}}     "January February March ... December"{p_end}
{p2col:{cmd:c(tracehilite)}}pattern to be highlighted in trace log{p_end}
{p2col:{cmd:c(maxiter)}}maximum iterations for maximum likelihood estimators{p_end}
{p2col:{cmd:c(varabbrev)}}whether variable abbreviation is on{p_end}
{p2line}

{p 5 9 2}
7.  A program can now be assigned properties when the program is declared, 
    and those properties can be checked using 
    macro-extended functions.  Specifically, 

{p 9 13 2}a.  {cmd:program} has the new option {cmd:properties()}, which
               attaches properties to programs; see 
               {helpb program:[P] program}.

{p 9 13 2}b.  A new {cmd:properties} macro-extended function
               allows programmers to obtain the list of properties attached to
               a program; see {helpb macro:[P] macro}.

{p 9 9 2}
	To learn more, see {helpb program properties:[P] program properties}.

{p 5 9 2}
8.  Estimation results can now be assigned properties using new option
    {cmd:properties()} of {cmd:ereturn post} and {cmd:ereturn repost}.
    These property settings can be checked with the new function
    {cmd:has_eprop()}.  See {helpb ereturn:[P] ereturn} and 
    {helpb progfun:[FN] Programming functions}.

{p 5 9 2}
9.  {cmd:ereturn post} now allows posting results without a beta 
     vector, {cmd:e(b)}, or a covariance matrix, {cmd:e(V)}.

{p 4 9 2}
10. {cmd:version} has new option {cmd:born()} to prevent the program
    from running if the date of the Stata executable is earlier than the
    specified date.  {cmd:version} also issues more descriptive error
    messages.  See {helpb version:[P] version}.

{p 4 9 2}
11.  On Microsoft Windows and Unix platforms, the new command
    {cmd:window manage maintitle} allows you to reset the main
    title of the Stata window; see {cmd:manage maintitle} under 
    {helpb window:[P] window programming}.

{p 4 9 2}
12.  New command {cmd:levelsof} displays a sorted list of the
    distinct values of a variable.  This is especially useful for
    looping over the values of a variable with, say, {cmd:foreach}.
    See {helpb levelsof:[P] levelsof}.

{p 4 9 2}
13. Plugins (also known as DLLs or shared objects) written in C can now be
    incorporated into Stata to create new Stata commands; see 
    {helpb plugin:[P] plugin}.

{p 4 9 2}
14.  The maximum number of description lines in a stata.toc file has been
     increased from 10 to 50; see {helpb usersite:[R] net}

{p 4 9 2}
15.  New undocumented command {cmd:_coef_table} is a programmer's tool
     for displaying coefficient tables; see {helpb _coef_table}.

{p 4 9 2}
16.  {cmd:trace} has new setting {cmd:set tracehilite} to highlight a
     specified pattern in the trace output; see {helpb trace:[P] trace}.

{p 4 9 2}
17.  The functionality of {cmd:macval()} has been extended to macro
     dereferencing of values in a class.  For example, {cmd:`macval(.a.b.c)'}
     causes the class reference {cmd:.a.b.c} to be macro expanded only once,
     rather than being recursively re-expanded when the result itself
     contained a macro reference.

{p 4 9 2}
18.  Variable abbreviation can now be turned on and off using the new
    {cmd:set} {cmd:varabbrev}; 
    see {helpb set varabbrev:[R] set} or type 
    {cmd:help} {helpb set varabbrev}. 

{p 4 9 2}
19.  Command {cmd:syntax} has new specifier {cmd:syntax anything(everything)}
     that specifies that {cmd:anything} include {cmd:if}, {cmd:in}, 
     and {cmd:using}; see {helpb syntax##description_of_anything:[P] syntax}.
     
{p 4 9 2}
20. Command {cmd:syntax} has new option descriptor {cmd:cilevel} that
   restricts valid arguments to a standard confidence level and
   issues appropriate error messages for invalid entries; see help 
   {helpb syntax:[P] syntax}.

{p 4 9 2}
21.  A number of new directives and extensions to existing directives have been 
    added to SMCL.  They are summarized below within broad categories; see
    {help smcl} for complete documentation.

{p 9 9 2}
{ul:{bf:Jumping to marked locations in help or other files}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}marker pos1{c )-}}} marks the current position in a file
as {cmd:pos1}{p_end}
{p2col:{cmd:{c -(}help "regress##pos1"{c )-}}} opens the help file
regress.hlp at the marked position {cmd:pos1}{p_end}
{p2col:{cmd:{c -(}view "my.smcl##pos1"{c )-}}} opens the file
my.smcl at the marked position {cmd:pos1}{p_end}
{p2line}

{p 9 9 2}
{ul:{bf:Opening help or other files in new or multiple Viewers}}{p_end}
{p2colset 10 39 42 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}help "regress##|mywin"{c )-}}} opens the help file
regress.hlp in a new Viewer window named {cmd:mywin}{p_end}
{p2col:{cmd:{c -(}help "regress##pos1|mywin"{c )-}}} opens the help file
regress.hlp at the marked position {cmd:pos1} in a new Viewer window 
named {cmd:mywin}{p_end}
{p2col:{cmd:{c -(}help "regress##|_new"{c )-}}} opens the help file
regress.hlp in a new Viewer window{p_end}

{p2col:{cmd:{c -(}view "my.smcl##|mywin"{c )-}}} opens the file
my.smcl in a new Viewer window named {cmd:mywin}{p_end}
{p2col:{cmd:{c -(}view "my.smcl##pos1|mywin"{c )-}}} opens the file
my.smcl at the marked position {cmd:pos1} in a new Viewer window 
named {cmd:mywin}{p_end}
{p2col:{cmd:{c -(}view "my.smcl##|_new"{c )-}}} opens the file
my.smcl in a new Viewer window{p_end}
{p2line}
{marker man_refs}
{p 9 9 2}
{ul:{bf:Special formatting of links to help files}}{p_end}
{p2colset 10 39 42 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}helpb} {it:help_topic}{cmd:{c )-}}} creates link to
{it:help_topic}.hlp, just like {cmd:{c -(}help }{it:help_topic}{cmd:{c )-}},
but displays the link in bold.{p_end}
{p2col:{cmd:{c -(}helpb} {it:help_topic}{cmd::}{it:text}{cmd:{c )-}}} creates
link to {it:help_topic}.hlp, just like 
{cmd:{c -(}help }{it:help_topic}{cmd::}{it:text}{cmd:{c )-}}, but displays 
{it:text} in bold.{p_end}

{p2col:{cmd:{c -(}manhelp} {it:help_topic} {it:R}:{it:text}{c )-}} displays 
{help whatsnew8to9##man_refs:{bf:[R] text}} and links to {it:help_topic}.hlp{p_end}
{p2col:{cmd:{c -(}manhelpi} {it:help_topic} {it:R}:{it:text}{c )-}} displays 
{help whatsnew8to9##man_refs:{bf:[R]} {it:text}} and links to {it:help_topic}.hlp{p_end}
{p2line}

{p 9 9 2}
{ul:{bf:Two-column tables with indented wrapping of last column}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}p2colset} {it:#} {it:#} {it:#} {it:#}{cmd:{c )-}}}declares
column spacing for ensuing table lines that use 
the {cmd:{c -(}p2col:}...{cmd:{c )-}} directive{p_end}
{p2col:{cmd:{c -(}p2colreset{cmd:{c )-}}}}restores default column
spacing{p_end}
{p2col:{cmd:{c -(}p2col}{cmd::}{it:text 1}{cmd:{c )-}}}displays 
{it:text 1} in column 1 and enters paragraph mode in column2 for any
text that follows until a paragraph end is signaled; an 
extended syntax allows columns to be specified{p_end}
{p2col:{cmd:{c -(}p2coldent}{cmd::}{it:text 1}{cmd:{c )-}}}just like 
{cmd:{c -(}p2col}{c )-}, except {it:text_1} is output with a standard
indentation for syntax-diagram-option tables{p_end}
{p2col:{cmd:{c -(}p2line{c )-}}}draws a line the width of the table; extended
syntax allows margins around the line{p_end}
{p2line}

{p 9 9 2}
{ul:{bf:New documentation conventions for syntax-diagram-option tables}}{p_end}
{p2colset 10 37 40 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}synoptset} [{it:#}] [{cmd:tabbed}]{cmd:{c )-}}}declares
	default column spacing for syntax-diagram-option tables{p_end}
{p2col:{cmd:{c -(}synopt}[{cmd::}{it:option_text}]]{cmd:{c )-}}}displays 
	{it:option_text} in column 1 and enters paragraph mode in column 2
	for any text that follows until the paragraph terminates{p_end}
{p2col:{cmd:{c -(}syntab}{cmd::}{it:text}]{cmd:{c )-}}}outputs text 
	positioned as a subheading or "tab" in a syntax diagram 
	option table{p_end}
{p2col:{cmd:{c -(}synopthdr}[{cmd::}{it:column1_text}]{cmd:{c )-}}}displays a
	standard header for a syntax-diagram-option table.{p_end}
{p2col:{cmd:{c -(}synoptline}{c )-}}draws a horizontal line extending to the
	boundaries of the previous {cmd:{c -(}synoptset}{cmd:{c )-}}{p_end}
{p2line}

{p 9 9 2}
{ul:{bf:New documentation conventions for variables and varlists}}{p_end}
{p2colset 10 24 27 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}newvar{c )-}}} displays {newvar}
while providing a link to help {help newvar};  new convention for
documenting that a command accepts a new variable{p_end}
{p2col:{cmd:{c -(}varname{c )-}}} displays {varname}
while providing a link to help {help varname};  new convention for
documenting that a command accepts a variable{p_end}
{p2col:{cmd:{c -(}var{c )-}}} displays {var}
while providing a link to help {help varname};  abbreviated form 
of {cmd:{c -(}varname{c )-}}{p_end}
{p2col:{cmd:{c -(}varlist{c )-}}} displays {varlist}
while providing a link to help {help varlist};  new convention for
documenting that a command accepts a varlist{p_end}
{p2col:{cmd:{c -(}vars{c )-}}} displays {vars}
while providing a link to help {help varlist};  abbreviated form 
of {cmd:{c -(}varlist{c )-}}{p_end}
{p2col:{cmd:{c -(}depvar{c )-}}} displays {depvar}
while providing a link to help {help depvar};  new convention for 
documenting that a command accepts a dependent variable{p_end}
{p2col:{cmd:{c -(}depvarlist{c )-}}} displays {depvarlist}
while providing a link to help {help depvarlist}; new convention for 
documenting that a command accepts a list of dependent variables{p_end}
{p2col:{cmd:{c -(}depvars{c )-}}} displays {depvars}
while providing a link to help {help depvarlist};  abbreviated form of
{cmd:{c -(}depvarlist{c )-}}{p_end}
{p2col:{cmd:{c -(}indepvars{c )-}}} displays {indepvars}
while providing a link to help {help varlist}; new convention for 
documenting that a command accepts a list of independent variables{p_end}
{p2line}
{p 9 9 2}
Note that the only change in convention is the addition of links to help files
describing the syntax of variables and varlists.

{p 9 9 2}
Each of the above directives also accepts an optional argument that is
displayed immediately after the standard display but does not otherwise
change the link; for example, {cmd:{c -(}varlist:_1{c )-}} displays
{varlist:_1} but continues to link to help {help varlist}.

{p 9 9 2}
{ul:{bf:Other new documentation conventions}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}ifin{c )-}}} displays [{it:{help if}}] [{it:{help in}}]
while providing links to {help if} and {help in};  new convention for
documenting support for {cmd:if} and {cmd:in} in a syntax diagram{p_end}
{p2col:{cmd:{c -(}weight{c )-}}} displays [{it:{help weight}}]
while providing a link to help {help weight};  new convention for
documenting support for weights in a syntax diagram{p_end}
{p2col:{cmd:{c -(}dtype{c )-}}} displays [{it:{help datatypes:type}}]
while providing a link to help {help datatypes};  new convention for
documenting that a command accepts an optional datatype in its syntax{p_end}
{p2col:{cmd:{c -(}dlgtab:}{it:text}{cmd:{c )-}}} displays {it:text} while 
giving it the appearance of labeled a dialog tab (extended forms support 
additional formatting){p_end}
{p2line}

{p 9 9 2}
{ul:{bf:Directives that simplify documenting options}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}opt} {it:optname}{cmd:{c )-}}} document
options; equivalent to {cmd:{c -(}cmd:}{it:optname}{c )-}{p_end}

{p2col:{cmd:{c -(}opt} {it:opt}{cmd::}{it:name}{cmd:{c )-}}} document
options that can be abbreviated; {cmd:{c -(}opt my:opt{c )-}}
displays {opt my:opt}

{p2col:{cmd:{c -(}opt my:opt(}{it:arg}{cmd:){c )-}}} document options that take
arguments; in this example, the option is named {cmd:myopt} and can be
abbreviated {cmd:my} {c -} {opt my:opt(arg)}; directive will correctly display
arguments that are lists, such as {it:a,b,...} or {it:a|b|c|...}{p_end}

{p2col:{cmd:{c -(}opth my:opt(}{it:arg}{cmd:){c )-}}} like 
{cmd:{c -(}opt my:opt(}{it:arg}{cmd:){c )-}} documents options that take
arguments, but also provides a link to help for {it:arg}; for example, {break}
{cmd:{c -(}opth my:opt(varlist){c )-}} displays {break}
{opth my:opt(varlist)}; extended syntax allows the linked help to 
differ from the displayed argument{p_end}
{p2line}

{p 9 9 2}
{ul:{bf:Directives abbreviating standard paragraph forms}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}pstd{c )-}}} equivalent to {cmd:{c -(}p 4 4 2{c )-}}{p_end}
{p2col:{cmd:{c -(}psee{c )-}}} equivalent to {cmd:{c -(}p 4 13 2{c )-}}{p_end}
{p2col:{cmd:{c -(}phang{c )-}}} equivalent to {cmd:{c -(}p 4 8 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pmore{c )-}}} equivalent to {cmd:{c -(}p 8 8 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pin{c )-}}} equivalent to {cmd:{c -(}p 8 8 2{c )-}}{p_end}
{p2col:{cmd:{c -(}phang2{c )-}}} equivalent to {cmd:{c -(}p 8 12 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pmore2{c )-}}} equivalent to {cmd:{c -(}p 12 12 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pin2{c )-}}} equivalent to {cmd:{c -(}p 12 12 2{c )-}}{p_end}
{p2col:{cmd:{c -(}phang3{c )-}}} equivalent to {cmd:{c -(}p 12 16 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pmore3{c )-}}} equivalent to {cmd:{c -(}p 16 16 2{c )-}}{p_end}
{p2col:{cmd:{c -(}pin3{c )-}}} equivalent to {cmd:{c -(}p 16 16 2{c )-}}{p_end}
{p2line}


{p 9 9 2}
{ul:{bf:Other new directives and extensions to existing directives}}{p_end}
{p2colset 10 34 37 2} 
{p2col:directive} description{p_end}
{p2line}
{p2col:{cmd:{c -(}mata} {it:args}[{cmd::}{it:text}]{cmd:{c )-}}} like the
{cmd:{stata}} directive, but for {cmd:mata}; displays {it:text}, and when
{it:text} is clicked, executes the {cmd:mata} command {it:args}

{p2col:{cmd:{c -(}rcenter:}{it:text}{cmd:{c )-}}} places text one space to 
the right when there are unequal spaces left and right{p_end}

{p2col:{cmd:{c -(}hline} {it:#}{cmd:{c )-}}} draws a horizontal line stopping
{it:#} characters from the end of the line{p_end}
{p2line}

{p 4 9 2}
22. Existing command {cmd:window manage} has the following changes and
    additions:

{p 9 13 2}
        {cmd:window manage close graph} [{{it:graphname} | {cmd:_all}}]{break}
                closes the Graph window named {it:graphname}, if it
                exists.  Specifying {cmd:_all}, closes all Graph windows.

{p 9 13 2}
	{cmd:window manage forward graph} [{it:graphname}]{break}
                    now brings the Graph window named {it:graphname}
                    to the top of other windows and otherwise works as
		    before.

{p 9 13 2}
	{cmd:window manage close viewer} [{{it:viewername} | {cmd:_all}}]{break}
                    closes the Viewer window named {it:viewername}.
                    Specifying _all closes all Viewer windows.

{p 9 13 2}
	{cmd:window manage forward viewer} [{it:viewername}]{break}
                    now brings the Viewer window named {it:viewername}
                    to the top of other windows and continues to work as
                    before when no viewername is specified.

{p 9 13 2}
	{cmd:window manage minimize}{break}
		minimizes the main Stata window.

{p 9 13 2}
	{cmd:window manage restore}{break}
                restores the main Stata window, if it is minimized.

{p 4 9 2}
23.  Existing command {cmd:window menu} now has the new subcommand 
    {cmd:append_recentfiles} to add .dta or .gph files to the 
    {cmd:Open Recent} menu.

{p 4 9 2}
24. Existing command {cmd:confirm variable} has new option 
    {cmd: exact} that disallows variable abbreviations.

{p 4 9 2}
25.  New command {cmd:svymarkout} resets the value of a supplied 0/1
     variable to 0 when any of the survey-characteristic variables set by
     {helpb svyset} contain missing values; see 
     {helpb svymarkout:[SVY] svymarkout}.

{p 4 9 2}
26.  Help files now allow include files.  
     Syntax is {cmd:INCLUDE help} {it:helptopic} to include file 
     {it:helptopic}{cmd:.ihlp}.

{p 4 9 2} 
27.  String scalars are now supported, meaning that a scalar can contain
     either a numeric or string value.  The maximum length of a string scalar
     is the same as the maximum length of a string -- 244 characters.
     See {helpb scalar:[P] scalar}.  

{p 4 9 2}
28.  In addition to coding 
     "{cmd:local x} {cmd::} {cmd:all} {cmd:scalars}" 
     to obtain a list of all defined scalars, you can now code 
     "{cmd:local x} {cmd::} {cmd:all} {cmd:numeric} {cmd:scalars}" 
     and
     "{cmd:local x} {cmd::} {cmd:all} {cmd:string} {cmd:scalars}" 
     to obtain the list restricted to numeric or string scalars.
    See {help macro:{bf:[P] macro}}.

{p 4 9 2}
29.  In macro expansion, double backslash (\\) used to become single 
     backslash (\).  Now (but under version control) it becomes single
     backslash only if the second backslash precedes macro-expansion
     punctuation ({cmd:`} or {cmd:$}).


{marker documentation}{...}
{title:What's new:  Documentation}

{p 5 9 2} 
1.  There are new manuals:
    {bf:[D] Data management},
    {bf:[MV] Multivariate Statistics}, 
    and 
    {bf:[M] Mata}.

{p 5 9 2} 
2.  Documentation (printed and online) groups related options into 
    categories.  In addition, the categories match the tabs on 
    dialog boxes.


{p 5 9 2} 
3.  For all estimation commands, there is now an entry called 
    {bf:postestimation} following the estimation command.  For instance, 
    following {bf:[R] regress} is {bf:[R] regress postestimation}.
    The postestimation entry documents command-specific postestimation
    facilities to further analyze the results and also directs
    you to other relevant postestimation features.

{p 9 9 2} 
    In the online help system, go to help for the estimation command, and
    click on {cmd:postestimation} in the upper-right corner.

{p 5 9 2} 
4.  There are now glossaries in the {bf:[M]}, {bf:[SVY]},
    {bf:[TS]}, and {bf:[XT]} manuals.  The glossaries define commonly used
    terms and explain how these terms are used in the documentation.

{p 5 9 2} 5.  Stata's {cmd:help} command and online help facility have new
features:

{p 9 13 2} a.  Spaces and colons are now allowed in help topics, for example,
               {cmd:help} {cmd:graph} {cmd:intro}, {cmd:help} {cmd:regress}
               {cmd:postestimation}, or {cmd:help} {cmd:svy:} {cmd:logistic}
               (with or without the colon).

{p 9 13 2}
    b.  Typing {cmd:help sqrt()} now gives you help for Stata's {cmd:sqrt()} 
        function.  Typing {cmd:help mata sqrt()} gives you help for 
        Mata's {cmd:sqrt()} function.

{p 9 13 2}
    c.  Many command abbreviations are now recognized; for
        example, 
        {cmd:help} {cmd:reg} {cmd:post} is understood to mean {cmd:help}
        {cmd:regress} {cmd:postestimation}, and 
	{cmd:help} {cmd:tw con} is understood to mean {cmd:help} 
        {cmd:graph} {cmd:twoway} {cmd:connected}.


{hline 3} {hi:previous updates} {hline}

{pstd}
See {help whatsnew8}.{p_end}

{hline}
