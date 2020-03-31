{smcl}
{* *! version 1.2.3  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 14.0 (compared with release 13)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 14.0:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {help whatsnew14}       Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
    {c |} {bf:this file}        Stata 14.0 new release       2015            {c |}
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
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew14}.


{hline 3} {hi:Stata 14.0 release 02apr2015} {hline}

      {bf:Contents}
{p 9 12 2}1.3  What's new{p_end}
{p 9 12 2}{help whatsnew13to14##highlights:1.3.1  Highlights}{p_end}
{p 9 12 2}{help whatsnew13to14##NewStat:1.3.2  What's new in statistics (general)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewSEM:1.3.3  What's new in statistics (SEM)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewME:1.3.4  What's new in statistics (multilevel modeling)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewTE:1.3.5  What's new in statistics (treatment effects)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewXT:1.3.6  What's new in statistics (longitudinal/panel data)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewTS:1.3.7  What's new in statistics (time series)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewST:1.3.8  What's new in statistics (survival analysis)}{p_end}
{p 9 12 2}{help whatsnew13to14##NewSVY:1.3.9  What's new in statistics (survey data)}{p_end}
{phang2}{help whatsnew13to14##NewPSS:1.3.10  What's new in statistics (power and sample size)}{p_end}
{phang2}{help whatsnew13to14##NewMI:1.3.11  What's new in statistics (multiple imputation)}{p_end}
{phang2}{help whatsnew13to14##NewMV:1.3.12  What's new in statistics (multivariate)}{p_end}
{phang2}{help whatsnew13to14##NewD:1.3.13  What's new in data management}{p_end}
{phang2}{help whatsnew13to14##NewFN:1.3.14  What's new in functions}{p_end}
{phang2}{help whatsnew13to14##NewG:1.3.15  What's new in graphics}{p_end}
{phang2}{help whatsnew13to14##NewM:1.3.16  What's new in Mata}{p_end}
{phang2}{help whatsnew13to14##NewP:1.3.17  What's new in programming}{p_end}
{phang2}{help whatsnew13to14##NewGUI:1.3.18  What's new in the Stata interface}{p_end}
{phang2}{help whatsnew13to14##NewMore:1.3.19  What's more}{p_end}

{pstd}
This section is intended for users of the previous version of Stata.  If you
are new to Stata, you may as well skip to 
{it:{help whatsnew13to14##NewMore:What's more}}, below.

{pstd}
As always, we remind programmers it is important that you put
{cmd:version 14}, {cmd:version} {cmd:13.1}, or {cmd:version 12}, etc.,
at the top of your old do- and ado-files so that they continue to work as you
expect.  You were supposed to do that when you wrote them, but if you did not,
go back and do it now.

{pstd}
We will list all the changes, item by item, but first, here are the
highlights.
 


{marker highlights}{...}
{title:1.3.1  Highlights}

{marker WnUnicode}{...}
{p 5 9 2}
1.  {bf:Unicode support}

{p 9 9 2}
    Здравствуйте.  こんにちは.  Hello.  

{p 9 9 2}
    Stata 14 supports Unicode (UTF-8).  All of Stata is Unicode aware.
    You may use Unicode for variable names, labels, data, and whatever
    else you wish.  Not only do you have more characters from which to
    choose, but when you share data, others will see what you see.


{marker WnUnicodeWarn}{...}
{p 15 15 2}
    {bf:Warning ... Files may need translating}

{p 15 15 2} 
    If you previously used Extended ASCII to overcome the limitations 
    of plain ASCII in your .dta files, do-files, and ado-files, they 
    need to be translated from Extended ASCII to Unicode.  We have made
    that easy: see {manhelp unicode_translate D:unicode translate}.  If you do
    not translate your files, they will not display properly.  If you used
    Extended ASCII for variable names, you may not even be able to type the
    mangled names!


{marker WnUnicodeStr}{...}
{p 15 15 2}
    {bf:New string functions}

{p 15 15 2} 
    Stata 14 has three times the number of string functions as Stata
    13.  To understand why, let's start with what you may find a
    surprising side effect of using Unicode.  Say you had an {cmd:str3}
    variable and you replaced a value in one observation with
    "f{c u:}r".  The variable would be {cmd:str4} after the change!  It
    would be {cmd:str4} because it takes four memory positions (bytes)
    to store "f{c u:}r": one each for "f" and "r" and two for
    "{c u:}".

{p 15 15 2}
    The standard ASCII characters consume one memory position just as
    they did previously, but the other Unicode characters need two,
    three, or even four memory positions.  {cmd:strlen()} works in
    terms of memory positions, so {cmd:strlen("f{c u:}r")} reports 4
    positions, not 3 characters.  New function
    {cmd:ustrlen("f{c u:}r")} works in terms of character positions, so
    it reports 3 characters.  {cmd:strlen("こんにちは")} is 15 if
    you can believe it, but {cmd:ustrlen("こんにちは")} is a
    reassuring 5.  By the way, こんにちは is pronounced "Kon'nichiwa"
    and means "hello".

{p 15 15 2}
    Anyway, for each string function, {it:fcn}{cmd:()}, that needs it,
    there is a new, corresponding function, {cmd:u}{it:fcn}{cmd:()}.
    {cmd:u}{it:fcn}{cmd:()} uses the character-position metric instead of
    the memory-position metric.  As another example,
    {cmd:usubstr(}{it:s}{cmd:,} {cmd:2}, {cmd:3)} returns up to three
    characters starting at the second.
    {cmd:substr(}{it:s}{cmd:,} {cmd:2}, {cmd:3)} returns up to three
    memory positions (bytes) starting at the second.  Memory positions are the
    same as characters only if {it:s} is ASCII.

{p 15 15 2}
    If you are writing for an international audience, you need to
    distinguish between the two flavors of each string function.

{p 15 15 2}
    The third new group of string functions are the {cmd:ud}{it:fcn}{cmd:()}s. 
    They work in the display-position metric.  
    {cmd:udstrlen("f{c u:}r")} is 3, meaning it takes 
    3 columns to display "f{c u:}r".  
    {cmd:udstrlen("こんにちは")} is 10, meaning it takes 
    10 columns to display "こんにちは".  
    You use the new {cmd:ud}{it:fcn}{cmd:()}s 
    when you are aligning output in a table. 
    {cmd:udsubstr(}{it:s}{cmd:,} {cmd:2}, {cmd:3)} returns however 
    many characters it takes to fill up to three columns, starting after 
    the second character. 


{marker WnUnicodeGraphs}{...}
{p 15 15 2}
    {bf:Graphs, SEM Builder, Unicode, and Extended ASCII} 

{p 15 15 2}
    Export graphs or output containing Unicode using PDF instead of
    PostScript (PS) or Encapsulated PostScript (EPS).  PS and EPS do
    not support Unicode.  In some cases, you can use PS and EPS because
    Stata converts accented Latin characters to the Extended ASCII
    characters that PS and EPS expect.

{p 15 15 2}
    If you have Stata 13 or earlier .gph graph files or .stsem SEM
    Builder files, and those files contain Extended ASCII, Stata 14
    will not display the Extended ASCII characters correctly, and they
    cannot be translated.  You can edit them.

{p 9 9 2}
    See {findalias frunicode} 
    and see {manhelp unicode D}
    for more information on Stata 14's new Unicode capabilities.


{marker WnTrilObs}{...}
{p 5 9 2}
2.  {bf:More than 2 billion observations now allowed}{break}

{p 9 9 2}
    Stata/MP, the multiprocessor version of Stata 14, now allows more
    than 2 billion observations, or more correctly, more than
    2,147,483,620 observations.  The maximum now depends solely
    on the amount of memory on your computer.  Stata will not limit
    you; it can now count up to 281 trillion observations.  

{p 9 9 2}
    How many observations you can process depends on the size of your
    computer and the width of your data.  Here are some sample
    calculations and a formula:

                                       Billions of observations
                   Computer's  Memory          scenario 
                     memory     used       (1)    (2)    (3) 
		   {hline 43}
                      128GB    112GB      1.8    1.4    1.0
                      256GB    240GB      3.8    2.9    2.1
                      512GB    496GB      7.9    6.1    4.4
                     1024GB   1008GB     16.2   12.3    9.8
                     1536GB   1520GB     24.4   18.5   13.6
		   {hline 43}

{p 12 12 2}
Notes:
{p_end}
{p 12 12 12}
{it:Memory used} is the total used for storing data.  We left 16GB free for
Stata and other processes, meaning that we assumed that Stata consumes
nearly all the computer's resources (single user).

{p 12 12 2}
{it:Observations} leaves extra room for adding three doubles, because 
Stata commands often add working variables.  The width used by 
the three scenarios is for your data exclusive of working variables. 

{p 12 12 2}
         Scenario 1:  width = 43 bytes (same as {cmd:auto.dta}) {break}
         Scenario 2:  width = 64 bytes{break}
         Scenario 3:  width = 96 bytes

{p 12 12 2}
	 Calculation:
{p_end}
{*             {it:obs} = (({it:memory_used}/{it:width}+24)*(1024²/1000²)}
		          {it:memory_used}    1024³
                 {it:obs}  =  {hline 12} × {hline 6}
                          {it:width} + 24     1000³

{p 12 12 2}
where {it:memory_used} is in gigabytes and {it:obs} is in billions.

{p 9 9 2}
There is nothing more to know except that we have advice on how to
improve Stata's performance when processing datasets with more than 2
billion observations; see {help obs_advice:help obs advice}.


{marker WnBayes}{...}
{p 5 9 2}
3.  {bf:Bayesian statistical analysis}{break}

{p 9 9 2}
    Stata 14 provides Bayesian statistical analyses
    with the new {helpb bayesmh} command and corresponding suite of
    features.  The {it:mh} on the end of {cmd:bayesmh} stands for
    Metropolis-Hastings.  You can fit models by using an adaptive
    Metropolis-Hastings algorithm, or a full Gibbs sampling for 
    some models, or a combination of the two algorithms. 
    After estimation, you can diagnose convergence and analyze results. 

{p 9 9 2}
    Fitting a model can be as easy as typing

{p 12 12 2}
. {cmd:bayesmh y x, likelihood(logit) prior({y:}, normal(0,100))}

{p 9 9 2}
    You can use our suite of preprogrammed likelihood models, or you can
    write your own.  Postestimation features are the same either way.
    And even if you write your own models, you can still use 
    the built-in priors. 

{p 9 9 2}
    We provide 12 built-in likelihood models and 22 built-in prior
    distributions.  Built in are continuous, binary, ordinal, and count
    likelihood models.  Built in are continuous univariate, continuous
    multivariate, discrete, and more prior distributions.  Supported are
    univariate, multivariate, and multiple-equation models, including
    linear and nonlinear models and including generalized nonlinear 
    models. 

{p 9 9 2}
   Results are reported with credible intervals (CrIs).  You can check
   convergence visually by typing {cmd:bayesgraph} {cmd:diagnostics}
   {cmd:_all}.  You can check Markov chain Monte Carlo (MCMC) efficiency by
   using the new {cmd:bayesstats} {cmd:ess} command.

{p 9 9 2}
   You can obtain estimates of the posterior means and their MCMC
   standard errors not only for model parameters but also for functions
   of model parameters.

{p 9 9 2}
   You can compare models using Bayesian information criteria such as
   the deviance information criterion or Bayes factors.

{p 9 9 2}
   You can perform interval hypothesis testing by computing
   probabilities that a parameter or set of parameters or even
   functions of parameters belong to a specified range.

{p 9 9 2}
    You can perform model hypothesis testing by computing probabilities
    of models given the observed data, which is to say, using model
    posterior probabilities.

{p 9 9 2}
    And you can store your MCMC and estimation results for later
    analysis.  

{p 9 9 2}
    We provide an entire, new manual on all of this; see the 
    {mansection BAYES bayes:{it:Stata Bayesian Analysis Reference Manual}}.


{marker WnIRT}{...}
{p 5 9 2}
4.   {bf:IRT models}{break}

{p 9 9 2}
     IRT stands for item response theory.  IRT models explore the
     relationship between a latent (unobserved) trait and items that
     measure aspects of the trait.  This often arises in standardized
     testing.  A set of items (questions) is designed, the responses to
     which measure, say, the unobservable trait mathematical ability.
     Or questions are designed to measure unobservable cognitive
     abilities, personality traits, attitudes, health outcomes, quality
     of life, morale, and so on.  The observable items do not have to be
     responses to questions, but they usually are.  The items can be
     any observable variables that we believe measure the trait.

{p 9 9 2}
    Stata can fit models for binary items, ordinal items, or
    categorical items.  These include, for binary items, one-parameter
    logistic (1PL), two-parameter logistic (2PL), and three-parameter
    logistic (3PL); for ordinal items, graded response models, rating scale
    models, and partial credit models; and for categorical items,
    nominal response models.  Stata can also fit hybrid models where
    different items use different models.

{p 9 9 2}
    Once a model is fit, Stata can graph item characteristic curves
    (ICCs), test characteristic curves (TCCs), item information
    functions (IIFs), and test information functions (TIFs).

{p 9 9 2}
    Stata includes a control panel to guide you through the fitting 
    and analysis of models. 

{p 9 9 2}
    There is a lot more to say; see the all-new 
    {mansection IRT irt:{it:Stata Item Response Theory Reference Manual}}.


{marker WnXTstreg}{...}
{p 5 9 2}
5.  {bf:Panel-data survival models}

{p 9 9 2}
    New estimation command {helpb xtstreg} fits parametric panel-data
    survival models with random effects.  Five distributions are
    provided:  exponential, loglogistic, Weibull, lognormal, and gamma.
    Estimation is in the accelerated failure-time metric, but
    exponential and Weibull also allow the proportional-hazards metric.

{p 9 9 2}
    {cmd:xtstreg} is both an xt and an st command; you
    {helpb xtset} the panel characteristics of the data and {cmd:stset}
    the survival characteristics.  Hence, single- and multiple-record
    st data as well as all the other survival-data features are
    supported, and survivor, hazard, and cumulative hazard functions can be
    graphed using {helpb stcurve}.

{p 9 9 2}
    Frequency, importance, and probability sampling weights are allowed.

{p 9 9 2}
    See {manhelp xtstreg XT}.

{p 9 9 2}
    New estimation command {helpb mestreg} fits 
    panel-data models with random coefficients and random intercepts.
    See {manhelp mestreg ME}.


{marker WnTE}{...}
{p 5 9 2}
6.  {bf:New in treatment effects}{break} 

{p 9 9 2}
    Stata 14 provides many new features for fitting and evaluating 
    treatment effects.  Treatment effects seek to extract
    experimental-style causal effects from observational data.


{marker WnTEst}{...}
{p 12 12 2}
    {bf:Treatment effects for survival models}

{p 12 12 2}
      New estimator {cmd:stteffects ra} estimates 
      average treatment effects (ATEs),
      average treatment effects among the treated (ATETs), and
      potential-outcome means (POMs) via regression adjustment. 
      See {manhelp stteffects_ra TE:stteffects ra}.

{p 12 12 2}
      New estimator {cmd:stteffects ipw} estimates ATEs, ATETs, and 
      POMs via inverse-probability weighting. 
      See {manhelp stteffects_ipw TE:stteffects ipw}.

{p 12 12 2}
      New estimator {cmd:stteffects ipwra} estimates ATEs, ATETs, and 
      POMs via inverse-probability-weighted regression adjustment. 
      See {manhelp stteffects_ipwra TE:stteffects ipwra}.

{p 12 12 2}
      New estimator {cmd:stteffects wra} estimates ATEs, ATETs, and 
      POMs via weighted regression adjustment. 
      See {manhelp stteffects_wra TE:stteffects wra}.

{p 12 12 2} 
   All the new estimators allow probability sampling weights.  


{marker WnTEendog}{...}
{p 12 12 2}
    {bf:Endogenous treatments}

{p 12 12 2}
    Stata 14 has a new estimator for endogenous treatments.
    Endogenous treatments arise when both the treatment model and the
    outcome model share unobserved covariates.

{p 12 12 2} 
       {cmd:etteffects} estimates ATEs, ATETs, and POMs for
       continuous, binary, count, fractional, and nonnegative outcomes when
       treatment assignment is correlated with outcome.
       See {manhelp eteffects TE}.


{marker WnTEpw}{...}
{p 12 12 2} 
    {bf:Probability weights}{break}

{p 12 12 2} 
    All the new estimators listed above support probability sampling weights.
    Support is also provided for 
        {manhelp teffects_ipwra TE:teffects ipwra}, 
        {manhelp teffects_ipw TE:teffects ipw}, and 
        {manhelp teffects_ra TE:teffects ra}.


{marker WnTEbal}{...}
{p 12 12 2}
    {bf:Balance analysis}

{p 12 12 2}
    Stata 14 performs balance analysis for treatment effects.  A key
    requirement is that our treatment-effects model explicitly or
    implicitly reweights the data such that the treated and
    the untreated groups have comparable covariate values.
    Four new commands are provided to assess and to test
    balance.

{p 12 12 2}
     {cmd:tebalance summarize} reports model-adjusted means and
     variances of covariates for the treated and untreated.
     See {manhelp tebalance_summarize TE:tebalance summarize}.

{p 12 12 2}
     {cmd:tebalance density} graphs kernel density plots for 
     the model-adjusted data for the treated and untreated. 
     See {manhelp tebalance_density TE:tebalance density}.

{p 12 12 2}
     {cmd:tebalance box} graphs box plots for
     the model-adjusted data for the treated and untreated. 
     See {manhelp tebalance_box TE:tebalance box}.

{p 12 12 2}
     {cmd:tebalance overid} tests for covariate balance.
     See {manhelp tebalance_overid TE:tebalance overid}.


{marker WnMEst}{...}
{p 5 9 2} 
7.  {bf:Multilevel mixed-effects parametric survival models}{break}

{p 9 9 2}
    New command {helpb mestreg}
    fits multilevel mixed-effects parametric survival models.

{p 12 12 2} 
              Five distributions are supported: exponential, loglogistic,
              Weibull, lognormal, and gamma.

{p 12 12 2} 
              Both proportional-hazards and accelerated failure-time
              parameterizations are supported.

{p 12 12 2} 
              Random effects, including random intercepts and random
              coefficients, at different levels of hierarchy are supported.

{p 12 12 2} 
              Single- or multiple-record st data as well as other
              survival-data features are supported via the 
	      {cmd:stset} command.
	      See {manhelp stset ST}.

{p 12 12 2} 
              Survey data are supported via the {cmd:svy} prefix.  
	      See {manhelp svy SVY}.

{p 12 12 2} 
              Relationships between multiple random effects
              can be independent or freely correlated, or you can specify 
              the covariance structure. 

{p 12 12 2} 
              Postestimation statistics include 
              predictions of mean and median survival times, and hazard and
              survivor functions.  Predictions can be obtained conditionally
              or unconditionally on random effects.

{p 12 12 2} 
              Survivor, hazard, and cumulative hazard functions can be graphed 
              using the {cmd:stcurve} command.  See {manhelp stcurve ST}.

{p 9 9 2} 
           See {manhelp mestreg ME}.


{marker WnDDF}{...}
{p 5 9 2} 
8.  {bf:Small-sample inference for fixed effects in linear multilevel mixed models}

{p 9 9 2} 
    Existing command {cmd:mixed} fits linear multilevel mixed models.
    {cmd:mixed} reports asymptotic test statistics for fixed effects by
    default.  Those statistics have large-sample normal and chi-squared
    distributions.  See {manhelp mixed ME}.

{p 9 9 2}
    When groups are balanced and sample size is small, these test
    statistics have exact t and F distributions for certain classes of
    models.  In other situations, such as when groups are unbalanced,
    the sampling distributions of the statistics may be approximated by
    t and F distributions.  Approximations differ in how (denominator)
    degrees of freedom are computed.  The small-sample tests may yield
    better coverages.

{p 9 9 2}
    New option {cmd:dfmethod(}{it:method}{cmd:)} provides various
    degree-of-freedom adjustments.  Five methods are provided, including 
    Kenward-Roger and Satterthwaite methods. 

{p 9 9 2} 
    New postestimation command {helpb estat df} reports the
    degrees of freedom for each coefficient. 

{p 9 9 2} 
    {helpb test}, {helpb testparm}, and {helpb lincom} have new option
    {cmd:small} to perform small-sample inference for fixed effects.

{p 9 9 2} 
See {mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}} in {bf:[ME] mixed}.


{marker WnSEM}{...}
{p 5 9 2} 
9.  {bf:New SEM (structural equation modeling) features}{break}

{p 9 9 2}
    Existing commands {helpb sem} and {helpb gsem} provide the
    following new features:


{marker WnSEMst}{...}
{p 12 12 2}
{bf:Survival models}

{p 12 12 2}
    {helpb gsem} now fits parametric survival models.  With the new
    multilevel survival models previously mentioned, you might wonder
    why you would care.  You care because SEM can fit multivariate
    models including survival models with unobserved components (latent
    variables), and combine survival models with other models involving
    continuous, binary, count, and other kinds of outcomes.

{p 12 12 2} 
     Five families are added to {cmd:gsem}: exponential, loglogistic,
     lognormal, Weibull, and gamma.  Options are added for specifying
     right-censoring and left-truncation, as is common (and
     necessary) for analyzing survival times.  See
     {manhelp sem_option_method SEM:sem option method()}.

{p 12 12 2} 
    {helpb gsem_predict:predict} after {cmd:gsem} has new option
    {cmd:survival} for computing survival-time predictions.  The
    predicted survival function is computed using the current outcome
    values and the estimated parameters.

{p 12 12 2} 
    All the new families support the accelerated failure-time
    metric.  Exponential and Weibull also support the proportional-hazards
    metric.

{p 12 12 2}
    If you use the SEM Builder, simply select one of the survival
    families from the contextual toolbar.


{marker WnSEMsatorra}{...}
{p 12 12 2} 
        {bf:Satorra-Bentler scaled chi-squared test}

{p 12 12 2}
        {helpb sem} now provides the 
        Satorra-Bentler scaled chi-squared model-versus-saturated test;
        specify new option {cmd:vce(sbentler)}.  In addition,
        corresponding robust standard errors (SEs) are produced and reported.  This test
        and the SEs are robust to nonnormal distributions.
        These are an alternative to the previously provided robust
        SEs.
        Goodness-of-fit statistics based on the model chi-squared are
        also adjusted. 


{marker WnSEMsvy}{...}
{p 12 12 2}
    {bf:Support for survey data}

{p 12 12 2}
    {helpb gsem} now supports the {cmd:svy} prefix for analyzing survey
    data, which includes multilevel weights.  See {manhelp svy SVY}.

{p 12 12 2}
    All the postestimation features available after survey
    estimation are also available.  See 
    {manhelp svy_postestimation SVY:svy postestimation} and 
    {manhelp svy_estat SVY:estat}.


{p 12 12 2}
{bf:Support for observational and multilevel weights}

{p 12 12 2}
    {helpb gsem} now supports observation-level weights and multilevel
    weights, even outside of a survey-data context.


{marker WnSEMbeta}{...}
{p 12 12 2}
{bf:Beta distribution}

{p 12 12 2}
    {helpb gsem} adds the beta distribution to the choice of families and
    may be used with logit, probit, and cloglog links.  The beta
    distribution is particularly appropriate for fractional or
    proportion data.

{p 9 9 2}
    See {manhelp sem SEM:sem and gsem}.

{marker WnSEMother}{...}
{p 9 9 2}
{cmd:gsem} provides the following new postestimation features:

{p 12 12 2}
        {helpb gsem_predict:predict} has new options
        {cmd:density} and {cmd:distribution} for computing the density
        and distribution function for each outcome using their current
        values and the estimated parameters.

{p 12 12 2} 
        {cmd:predict}
        has new option {opt marginal} for computing observed
        endogenous predictions that are marginal with respect to the
        latent variables, meaning that prediction is produced by
        integrating over the distribution of the latent variable(s).

{p 12 12 2}
        {cmd:predict} 
        has new option {opt expression()} that calculates linear and
        nonlinear functions of the mean and linear predictions.

{p 9 9 2}
    See {manhelp gsem_predict SEM:predict after gsem}.


{marker WnPSS}{...}
{p 4 9 2}
10.  {bf:Power analysis for survival and epidemiological methods}{break}

{p 9 9 2}
    Existing command {helpb power} now provides 
    all-new power analysis for epidemiological methods.

{p 9 9 2}
    In addition, existing command {cmd:stpower} for performing power
    analysis on survival models is now undocumented, and its
    capabilities are now folded into existing command {cmd:power}.  The
    advantage is that extensive graphing and tabulation of results are
    now available.

{p 9 9 2}
    Here are the details.  We will start with the survival models:


{p 12 12 2}
{bf:New methods for analysis of survival models}

{p 12 12 2}
    {helpb power cox} estimates required sample size, power, and effect
    size using Cox proportional hazards models allowing for multiple
    covariates.  It allows for correlation between the covariate of
    interest and other covariates, and it allows for withdrawal of subjects
    from the study.  See {manhelp power_cox PSS:power cox}.

{p 12 12 2}
    {helpb power exponential} estimates required sample size and power
    comparing two exponential survivor functions.  It accommodates
    unequal allocation between the two groups, flexible accrual of
    subjects into the study (uniform and truncated exponential), and
    group-specific losses to follow-up.  
    See {manhelp power_exponential PSS:power exponential}.

{p 12 12 2}
    {helpb power logrank} estimates required sample size, power, and
    effect size for comparing survivor functions in two groups using
    the log-rank test.  It provides options to account for unequal
    allocation of subjects between the groups, possible withdrawal of
    subjects from the study (loss to follow-up), and uniform accrual of
    subjects into the study.
    See {manhelp power_logrank PSS:power logrank}.

{p 12 12 2}
     As with all other {cmd:power} methods, {cmd:cox},
     {cmd:exponential}, and {cmd:logrank} allow you to specify multiple
     values of parameters and automatically produce tabular and
     graphical results.


{p 12 12 2}
{bf:New methods for analysis of contingency tables}

{p 12 12 2}
     This will be of special interest to epidemiological researchers. 

{p 12 12 2}
    {helpb power cmh} performs power and sample-size analysis for a
    Cochran-Mantel-Haenszel test of association in stratified 2 x 2
    tables.  It computes sample size, power, or effect size (common
    odds ratio) given other study parameters.  It provides computations
    for designs with unbalanced stratum sizes as well as unbalanced
    group sizes within each stratum.
    See {manhelp power_cmh PSS:power cmh}.

{p 12 12 2}
    {helpb power mcc} performs power and sample-size analysis for a
    test of association between a risk factor and a disease in 1:M
    matched case-control studies.  It computes sample size, power, or
    effect size (odds ratio) given other study parameters.
    See {manhelp power_cmh PSS:power cmh}.

{p 12 12 2}
    {helpb power trend} performs power and sample-size analysis for a
    Cochran-Armitage test of a linear trend in a probability of
    response in J x 2 tables.  The rows of the table correspond to
    ordinal exposure levels.  The command computes sample size or power
    given other study parameters.  It provides computations for
    unbalanced designs and for unequally spaced exposure levels
    (doses).  With equally spaced exposure levels, a continuity
    correction is available.
    See {manhelp power_trend PSS:power trend}.

{p 12 12 2}
    As with all other {cmd:power} methods, {cmd:cmh}, {cmd:mcc}, and
    {cmd:trend} allow you to specify multiple values of parameters and
    automatically produce tabular and graphical results.

{p 9 9 2}
    See {manhelp power PSS}. 


{marker WnMarkov}{...}
{p 4 9 2}
11.  {bf:Markov-switching regression models}{break}

{p 9 9 2}
    New estimation command {helpb mswitch} fits Markov-switching
    models.  These are times-series models in which some of or all the
    parameters of a regression probabilistically transition among a
    finite set of unobserved states with unknown transition points.

{p 9 9 2}   
    Let's consider some examples.  In economics, switching regression
    has been used to model growth rate of GDP to model asymmetric
    behavior observed over expansions and recessions.

{p 9 9 2}   
    In finance, switching has been used to model monthly stock returns.

{p 9 9 2}   
    In political science, switching has been used to model transitions
    between Democratic and Republican partisanship.

{p 9 9 2}   
    In psychology, switching has been used to model transitions between
    manic and depressive states.

{p 9 9 2}   
    In epidemiology, switching has been used to model the incidence
    rate of infectious disease in epidemic and nonepidemic states.

{p 9 9 2}
    {cmd:mswitch} provides two ways of modeling the switching process:
    autoregressive (AR) and dynamic regression (DR).  AR is
    typically used for processes that change slowly, and DR is typically used for processes
    that transition rapidly.  See {manhelp mswitch TS}.

{p 9 9 2} 
    New postestimation commands {helpb estat transition} and
    {helpb estat duration} report the transition probabilities and
    expected state durations.
    See {manhelp estat_transition TS:mswitch postestimation}.

{p 9 9 2}
    After estimation, you can {cmd:predict} the dependent variable, and
    you can also predict the probability of being in each of the
    unobserved states.  These predictions are available as one-step
    ahead (static) or multi-step ahead (dynamic).


{marker WnSB}{...}
{p 4 9 2}
12.  {bf:Tests for structural breaks in time-series data}{break}

{p 9 9 2}
     Two new postestimation commands test for structural breaks
     after estimation by {helpb regress} or {helpb ivregress}.

{p 9 9 2}
     {helpb estat sbknown} tests for structural breaks at known dates. 

{p 9 9 2}
     {helpb estat sbsingle} tests for a structural break at an unknown date. 

{p 9 9 2}
     See {manhelp estat_sbknown TS:estat sbknown}
     and {manhelp estat_sbsingle TS:estat sbsingle}.


{marker WnFrac}{...}
{p 4 9 2}
13.  {bf:Regression models for fractional data}{break}

{p 9 9 2}
    Two new estimation commands are provided for fitting models when
    the dependent variable is a fraction, a proportion, or a rate.

{p 9 9 2}
    New estimation command {helpb fracreg} allows the dependent
    variable to be in the range 0 to 1 inclusive.  It fits probit,
    logit, and heteroskedastic probit models.  See {manhelp fracreg R}.

{p 9 9 2}
    New estimation command {helpb betareg} requires the dependent 
    variable to be in the range 0 to 1 exclusive. 
    It fits beta regression.  See {manhelp betareg R}.

{p 9 9 2}
    Both new estimators support the {helpb svy} prefix for analyzing 
    survey data. 


{marker WnMEsvy}{...}
{p 4 9 2}
14.  {bf:Survey support and multilevel weights for multilevel models}

{p 9 9 2}
        We use the term "survey support" to include both Stata's
        {helpb svy} prefix and multilevel probability weights outside of
        the survey context.

{p 9 9 2}
       The following estimation commands now support the {cmd:svy} prefix
       using the linearized estimate of the variance-covariance estimate: 
            {helpb mecloglog},
            {helpb meglm},
            {helpb melogit},
            {helpb menbreg},
            {helpb meologit},
            {helpb meoprobit},
            {helpb mepoisson}, and
            {helpb meprobit}.

{p 9 9 2}
        The same estimation commands now support multilevel sampling and
        frequency weights, too.


{marker WnRNG}{...}
{p 4 9 2}
15.  {bf:New random-number generators (RNGs)}

{p 9 9 2}
    Existing function {helpb runiform()} now uses the 64-bit Mersenne
    Twister.  {cmd:runiform()} produces uniformly distributed random
    numbers, and the functions providing random numbers for other
    distributions use {cmd:runiform()} in producing their results.
    Thus, all of Stata's RNGs are now based on the Mersenne
    Twister, too.  Stata previously used KISS32 and still does under
    version control.

{p 9 9 2}
    KISS32 is an excellent RNG, but the Mersenne Twister has 
    better properties and a longer period, namely 2^19937-1.  The
    Mersenne Twister is 623-dimensionally equidistributed and has
    53-bit resolution.


{marker WnRNGuniform}{...}
{p 12 12 2}
   {bf:Uniformly distributed RNGs in specified intervals}

{p 12 12 2}
      Existing function {helpb runiform()} now allows you 
      to specify the range over which random variates will be 
      supplied.  {cmd:runiform(}{it:a}{cmd:,} {it:b}{cmd:)} 
      returns values in the open interval ({it:a}, {it:b}). 

{p 12 12 2} 
      New function
      {help runiformint():{bf:runiformint(}{it:a}{bf:,} {it:b}{bf:)}}
      returns integer values in the closed interval [{it:a}, {it:b}].

{p 12 12 2}
      It is a minor technical detail, but existing function
      {cmd:runiform()} without arguments now produces random numbers in
      the open interval (0,1) instead of [0,1) as previously.  It
      produces [0,1) values under version control when KISS32 is used.


{marker WnRNGdistribs}{...}
{p 12 12 2}
    {bf:New RNGs for distributions} 

{p 12 12 2} 
    Newly provided are 

{p 16 18 2}
	    {helpb rexponential():{bf:rexponential(}{it:b}{bf:)}}{break}
	    exponential random variates with scale {it:b}

{p 16 18 2}
	    {helpb rlogistic()}{break}
	    logistic variates with mean 0 and standard deviation π/sqrt(3)

{p 16 18 2}
	    {help rlogistic():{bf:rlogistic(}{it:s}{bf:)}}{break}
	    logistic variates with mean 0, scale {it:s}, and standard deviation
	    {it:s}π/sqrt(3)

{p 16 18 2}
	    {help rlogistic():{bf:rlogistic(}{it:m}{bf:,}{it:s}{bf:)}}{break}
	    logistic variates with mean {it:m}, scale {it:s}, and standard
	    deviation {it:s}π/sqrt(3)

{p 16 18 2}
	    {help rweibull():{bf:rweibull(}{it:a}{bf:,}{it:b}{bf:)}}{break}
	    Weibull variates with shape {it:a} and scale {it:b}

{p 16 18 2}
	    {help rweibull():{bf:rweibull(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:)}}{break}
	    Weibull variates with shape {it:a}, scale {it:b}, and location
            {it:g}

{p 16 18 2}
	    {help rweibull():{bf:rweibullph(}{it:a}{bf:,}{it:b}{bf:)}}{break}
	    Weibull (proportional hazards) variates with shape {it:a} and
            scale {it:b}

{p 16 18 2}
	    {help rweibullph():{bf:rweibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:)}}{break}
	    Weibull (proportional hazards) variates with shape {it:a}, scale
            {it:b}, and location {it:g}

{p 12 12 2}
	    See {manhelp random_number_functions FN:Random-number functions}.


{marker WnRNGchoosing}{...}
{p 12 12 2}
    {bf:Choosing which RNG to use} 
     
{p 12 12 2}
    You are running Stata with version 14 set.  You want values from 
    {helpb rlogistic()} but based on KISS32 rather than the version-14
    default of Mersenne Twister.  You could type

{p 16 16 2}
	. {cmd:version 13:}  ... {cmd:rlogistic()} ...

{p 12 12 2} 
    or you can just use new function {cmd:rlogistic_kiss32()} without
    resetting the version:

{p 16 16 2}
	. ... {cmd:rlogistic_kiss32()} ...

{p 12 12 2} 
    That is, every RNG {it:fcn}{cmd:()} comes in
    three flavors:
    {it:fcn}{cmd:()}, 
    {it:fcn}{cmd:_mt64()}, and 
    {it:fcn}{cmd:_kiss32()}.

{p 12 12 2} 
    Functions 
    {it:fcn}{cmd:_mt64()} and 
    {it:fcn}{cmd:_kiss32()} are now considered the true names of the 
    RNGs, but still, you will usually type {it:fcn}{cmd:()}.

{p 12 12 2}
    That is because of another new feature: 

{p 16 16 2}
	. {cmd:set rng kiss32}

{p 12 12 2}
    {cmd:set rng kiss32} says that when you type {it:fcn}{cmd:()}, you
    mean {it:fcn}{cmd:_kiss32()}.  You can {helpb set rng} to
    {cmd:kiss32}, {cmd:mt64}, or {cmd:default}.  That is how the meaning
    of {it:fcn}{cmd:()} is set.  {cmd:default} means the default for the
    version.  In version 14, the default is {cmd:mt64}.  In version 13 and
    before, it is {cmd:kiss32}.

{p 12 12 2}
    Programmers:  Ado-file code written under previous versions of
    Stata now use modern RNGs!  You do not have to modify your
    ado-files.  That is because how {cmd:version} is set for the
    RNGs has been modified.  Users typing {cmd:version} at the command
    line or in a do-file set RNG's version, too.  Ado-files setting
    version, however, do not change RNG's version!  In ado-files, the
    RNG's version can be set by setting the user version if you wanted to
    set it, but you do not.  See {manhelp version P}.


{marker WnRNGseeds}{...}
{p 12 12 2}
    {bf:Setting seeds and states} 

{p 12 12 2} 
    You previously could set the seed or reset the state of the RNGs
    by using {cmd:set seed}.  Now, {cmd:set seed} is used solely for
    setting the seed.  New command {cmd:set rngstate} is used for
    resetting the state.  See {manhelp set_seed R:set seed}.

{p 12 12 2} 
    You previously obtained the state of the RNGs by using {cmd:c(seed)}. 
    Stata continues to understand that, but officially, you are 
    supposed to use {cmd:c(rngstate)}.  

{p 9 9 2}
See
{manhelp random_number_functions FN:Random-number functions}
and {manhelp set_seed R:set seed}.


{marker WnPostest}{...}
{p 4 9 2}
16.  {bf:Postestimation made easy} 

{p 9 9 2}
    You have to try this.  Clear your Stata's estimation results, if
    any; type {cmd:discard}.  Now type {cmd:postest}.  A little, empty
    window will pop up.  Move it to where it does not overlap Stata but
    you can see it.  Now run an estimation command -- any estimation
    command.  You could type {cmd:use auto} and then type 
    {cmd:regress mpg weight foreign}.

{p 9 9 2}
    Isn't that neat?  Well, if you are not following along, let us tell
    you what just appeared in that little, empty window.  This
    appeared:

{col 13}> Marginal analysis
{col 13}> Tests, contrasts, and comparisons of parameter estimates
{col 13}> Specification, diagnostic, and goodness-of-fit analysis
{col 13}> Diagnostic and analytic plots
{col 13}> Predictions
{col 13}> Other reports
{col 13}> Manage estimation results

{p 9 9 2}
   Those are the postestimation things you can do after {cmd:regress}.
   Use a different estimation command and you will see a different
   list.  Click on a topic and it expands.  That list is tailored, too.
   Highlight a detailed element, click on Launch, and you are in the
   dialog box for the postestimation feature and it is filled in as much
   as it can be.

{p 9 9 2}
    Enjoy.


{marker WnMargins}{...}
{p 4 9 2}
17.  {bf:New and improved features in margins}

{p 9 9 2}
    Existing command {helpb margins} is used after estimation.
    {cmd:margins} uses the fitted results, the data in memory, and a
    little bit that you type to produce estimates of marginal effects,
    marginal means, predictive margins, population-averaged effects,
    and least-squares means, and presents the estimates in tables or
    graphs.  

{p 9 9 2}
    With {cmd:margins}, you can do what-if analyses.  What
    would have been observed if everyone in the data were males?
    Females?  What would have happened if the men in the data had
    their same characteristics but were relabeled women, and the women
    had their same characteristics but were relabeled men?  If you can
    think of a counterfactual, potential outcome, comparison, or contrast,
    {cmd:margins} can do it.

{p 9 9 2}
   We have improved {cmd:margins} in Stata 14. 


{marker WnMarginsOutcomes}{...}
{p 15 15 2} 
{bf:Works with multiple outcomes simultaneously}

{p 15 15 2} 
   {helpb margins} previously restricted you to working with one
   outcome at a time.  No longer does it do this, and by default,
   {cmd:margins} automatically produces its results for all
   equations, outcomes, or ordered levels of the fitted model.  If you
   fit a multivariate regression on two variables, you get {cmd:margins}
   results for both variables.
   If you fit an ordinal model, you get results for each of the 
   ordered levels.

{p 15 15 2} 
   Use the {cmd:predict()} option to restrict results to selected
   equations, outcomes, or levels if you wish.  You may now specify 
   multiple {cmd:predict()} options on the same {cmd:margins} command. 


{marker WnMarginsMarginal}{...}
{p 15 15 2}
    {bf:Integrates over unobserved components after multilevel and SEM models} 

{p 15 15 2}
    Making predictions (even if counterfactual) is difficult with
    models that contain random or latent variables which are, after
    all, unobserved.  {helpb margins} now integrates over them and gets
    the average.  Integrating over unobserved components is the logical
    counterpart of producing population-averaged results by averaging
    over your data.

{p 15 15 2}
    There is even logic for it when making predictions about
    individuals; you are making average predictions for individuals
    with the same characteristics.  What is the expected probability of
    high blood pressure for males, age 50, weight 190, based on a
    random-effects logistic regression?  To compute that probability,
    you cannot simply take the random effect at its known mean of 0.
    You must integrate over the distribution of the random effect.
    {cmd:margins} does this.


{marker WnMarginsPredict}{...}
{p 15 15 2}
{bf:predict has these features, too}

{p 15 15 2}
    {helpb margins} has the new features just described, but in fact, it
    inherited them from new features of {cmd:predict}.  You can now use
    {cmd:predict} to obtain predictions integrated over the
    distributions of unobserved components, random effects, and latent
    variables.

{p 15 15 2} 
    These marginal predictions are produced if you specify new option
    {cmd:marginal} with {cmd:predict} and are available after
                   {helpb gsem},
                   {helpb mecloglog},
                   {helpb meglm},
                   {helpb melogit},
                   {helpb menbreg},
                   {helpb meologit},
                   {helpb meoprobit},
                   {helpb mepoisson}, and
                   {helpb meprobit}.


{marker WnMarginsDefault}{...}
{p 15 15 2}
{bf:Better default statistics after some estimators} 

{p 15 15 2}
    {helpb margins} now uses its own default prediction statistic rather
    than the default prediction for the estimator.  Sometimes, the
    default for the estimator is not statistically appropriate for use
    with {cmd:margins}, or there is an optional prediction statistic
    that is more interesting for marginal analysis.  In such cases,
    {cmd:margins} now uses the most interesting or appropriate
    prediction statistic by default.  You can still choose any
    available statistic by using the {cmd:predict()} option.  The previous
    default is preserved under version control.  See 
    {help whatsnew13to14##NewMarginsDefault:item 36} 
    below for the complete list of new defaults.


{marker WnMarginsFaster}{...}
{p 15 15 2}
    {bf:margins is faster} 

{p 15 15 2}
   {helpb margins} is now much faster when computing predictive margins and
   marginal effects on predicted probabilities after {helpb ologit}, 
   {helpb oprobit}, and {helpb mlogit}.

{p 15 15 2}
    It is also much faster when all of a model's {it:indepvars} are
    fixed to constants, such as when the {cmd:atmeans} option is
    specified.


{marker WnMarginsGen}{...}
{p 15 15 2}
    {bf:margins can now add its results to your data}

{p 15 15 2}
    {helpb margins} has a new {cmd:generate()} option.  You supply the
    stub of a name, and {cmd:margins} fills in the rest.  Specify the
    option, and {cmd:margins} creates new variables containing
    observation-by-observation values used to produce each of its
    reported results.

{p 15 15 2} 
    This is an often-requested feature and is useful when you use
    margins to produce a single or a small set of results.  Otherwise,
    you will be inundated with new variables that are difficult to
    interpret.

{p 15 15 2} 
    This new, useful feature is currently "undocumented" in Stata
    speak, meaning that the documentation for it is available solely in
    {help margins generate:help margins generate}.


{marker WnMarginsDoc}{...}
{p 15 15 2} 
    {bf:And it is now easier to determine which features are available} 

{p 15 15 2} 
    Each estimation command now documents which of the available
    predicted statistics is the default statistic for {helpb margins} and
    which of the other statistics are appropriate for use with
    {cmd:margins}.

{p 9 9 2}
See {manhelp margins R}. 


{marker WnHurdle}{...}
{p 4 9 2} 
18.  {bf:Hurdle model estimation}

{p 9 9 2} 
    New estimation command {helpb churdle} fits linear or exponential
    hurdle models.  Hurdle models allow us to model censored and
    uncensored outcomes separately.  Uncensored outcomes are assumed to
    be observed when a hurdle is cleared.  Censored outcomes are a
    result of not clearing the hurdle.

{p 9 9 2} 
    Hurdle models come in two- and three-equation forms.  The
    two-equation form handles a right- or left-censoring.  The
    three-equation form handles combined censoring.

{p 9 9 2}
    Consider modeling how much people spend at the movies.  We have
    data on a cross-section of people and the amount they spent last
    month.  In our data, many people spent nothing because they did not even
    go to the movies; and how much the rest spent varies.  In the
    hurdle model, we assume that once the decision is made to go to the
    movies, the amount spent can be treated independently of the
    decision to go.  Those are the two equations:  one for the 
    decision to go and another for the amount spent.

{p 9 9 2}
    See {manhelp churdle R}. 


{marker WnCpoisson}{...}
{p 4 9 2} 
19.  {bf:Censored Poisson estimation} 

{p 9 9 2}
    New command {helpb cpoisson} fits censored Poisson regressions to
    count outcomes.  These are Poisson models with values that are not
    observed if they are below a threshold, or they are above a
    threshold, or both.  The thresholds can be fixed values, such as 5
    and 10, or can be recorded in variables, meaning that thresholds vary
    observation by observation.

{p 9 9 2}
    Postestimation, you can obtain predictions of the number of
    uncensored events, the uncensored incidence rate, the uncensored
    probability of a particular value or range of values, and the expected
    conditional probabilities of a value or range conditional on being
    within the censoring limits.

{p 9 9 2}
    See {manhelp cpoisson R}. 


{marker WnICD10}{...}
{p 4 9 2}
20.  {bf:Support for ICD-10 medical diagnosis codes}

{p 9 9 2}
    New command {cmd:icd10} joins existing commands {cmd:icd9} and
    {cmd:icd9p}.

{p 9 9 2}
    New command {helpb icd10} provides automatic mapping of the World
    Health Organization's ICD-10 diagnosis codes for mortality and
    morbidity, and it adds some features not previously provided with
    {cmd:icd9} and {cmd:icd9p}.  It allows a version control that sets
    descriptions to those that were current at the time your data were
    recorded, it works with a subset or with all records of your data, and
    it can be used with category or subcategory codes.

{p 9 9 2}
    {cmd:icd10} allows you to do the same things you could do with
    {cmd:icd9} and {cmd:icd9p}; namely, you can standardize the format
    of codes in your data, confirm that codes are defined, verify that
    codes are formatted correctly, and easily create indicators for the
    presence of different conditions.

{p 9 9 2}
    Meanwhile, existing commands {helpb icd9} and {helpb icd9p} (for
    ICD-9, of course) provide the same new features, where applicable,
    provided by {cmd:icd10}.  These new features include {cmd:if}
    {it:exp} and {cmd:in} {it:range} being allowed, and more. 

{p 9 9 2}
    See {manhelp icd10 D} and {manhelp icd9 D}.

{p 9 9 2}
    We would like to thank the World Health Organization for making 
    these codes available to Stata users.  
    See {help copyright_icd10:copyright icd10}
    for allowed usage.


{marker WnPutexcel}{...}
{p 4 9 2}
21.  {bf:Excel reports get better} 

{p 9 9 2}
     One of the more popular features of Stata 13 was the
     {cmd:putexcel} command for exporting results to Excel.  All it
     did, however, was allow you to poke numbers and strings into Excel
     worksheets.  Even so, a Stata blog entry about it was our most
     popular of the release!

{p 9 9 2}
     So we have added to {cmd:putexcel}.  In addition to previous
     features, you can now

{p 12 15 2}
o{bind:  }insert Stata graphs
{p_end}

{p 12 15 2}
o{bind:  }insert text and format it with alignment, boldface, italics,
color, and more

{p 12 15 2}
o{bind:  }specify Excel formats, including date formats, currency formats, 
and more

{p 12 15 2}
o{bind:  }make better tables with cell spanning, border formatting, and more

{p 12 15 2}
o{bind:  }insert Excel formulas

{p 9 9 2}
     All the things you can do from {cmd:putexcel} you can also do
     from Mata's {cmd:xl()} Excel file I/O class.

{p 9 9 2}
     See {manhelp putexcel P} and {manhelp mf_xl M-5:xl()}.


{marker WnQstart}{...}
{p 4 9 2} 
22.  {bf:Manual entries now have Quick starts} 

{p 9 9 2}
   Have you ever looked at a Stata command for the first time and
   wanted to see some examples without explanation that do something
   interesting?  Or have you ever needed a quick refresher on a
   command's most common syntaxes?

{p 9 9 2} 
   If so, what you want is now at the top of the command's manual
   entry.  We call them Quick starts.  We show a few examples for
   simple commands and sometimes more than a few when the command's
   syntax is more complex.  If a command involves several steps, those
   steps are shown, too.

{p 9 9 2}
   The Quick starts are located right below the Description, 
   and the Description now appears below the Title, where it 
   always should have been. 

{p 9 9 2}
    Quick starts do not appear in the help files, but they are just a
    click away.  Click on the blue command name in the Title.  In the
    help files, we keep Syntax near the top so that experts who
    just need the facts can see a quick refresher.


{marker WnLoc}{...}
{p 4 9 2}
23.  {bf:Stata in Spanish and Japanese}

{p 9 9 2}
    It is called localization when a software's menus, dialogs, and the
    like are translated into other languages.  We have completed
    localization of Stata for Spanish and Japanese.  Manuals and help
    files remain in English.

{p 9 9 2}
    If your computer is set to a specific language, and that language
    is Spanish or Japanese, Stata will recognize this and automatically
    use that language.  To manually change the language, select 
    {bf:Edit > Preferences > User-interface language...}  (Windows and Unix), 
    or select 
    {bf:Stata 14 > Preferences > User-interface language...} (Mac).
    Alternatively, you can change the language from the command line: 
    see {manhelp set_locale_ui P:set locale_ui}. 

{p 9 9 2}
    StataCorp translated to Spanish, and StataCorp gratefully 
    acknowledges the efforts of LightStone Corporation, Stata's
    official distributor in Japan, for translating to Japanese. 



{marker NewStat}{...}
    {title:1.3.2  What's new in statistics (general)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnBayes:Bayesian statistical analysis}
        {help whatsnew13to14##WnFrac:Regression models for fractional data}
        {help whatsnew13to14##WnHurdle:Hurdle model estimation}
        {help whatsnew13to14##WnCpoisson:Censored Poisson estimation}
        {help whatsnew13to14##WnRNG:New random-number generators (RNGs)}
        {help whatsnew13to14##WnMargins:New and improved features in margins}

{pstd}
The following are also new:

{p 7 12 2}
       24.  New commands {cmd:ztest} and {cmd:ztesti} 
            compare means in one or two samples using a {it:z} test and assuming
            known variances.  With two samples, {cmd:ztest} supports both
            paired and unpaired data.  {cmd:ztesti} is the immediate form of
            {cmd:ztest} that allows you to perform a test by typing summary
            statistics rather than using a dataset.
	    See {manhelp ztest R}.

{p 7 12 2}
       25.  Almost every estimator now supports {help factor variables}.  New
            to this list in Stata 14 are {helpb asmprobit},
	    {helpb asroprobit}, {helpb asclogit}, {helpb nlogit}, {helpb gmm},
	    and {helpb mlexp}.

{p 7 12 2}
       26.  Existing estimation command 
            {helpb nlogittree} now reports when any observations violate
	    the specified nesting structure of the model and will result in
	    {helpb nlogit} dropping observations or terminating with an error.
	    See {manhelp nlogit R}.

{p 7 12 2}
       27.  Existing commands 
            {helpb test} and {helpb testparm} provide new option
            {opt df(#)} to specify that the F distribution,
	    rather than the default chi-squared distribution,
	    be used when performing the Wald test.

{p 7 12 2}
       28.  When used with survey data, existing command 
            {helpb testparm} provides new option
	    {cmd:nosvyadjust}, which specifies that the Wald test is to be
	    performed without the default adjustment for the design degrees of
	    freedom.

{p 7 12 2}
       29.  Existing command 
            {helpb cumul} now labels the generated variable.  The label is
	    "ECDF of {it:varname}".

{p 7 12 2}
       30.  Existing command 
            {helpb ksmirnov} no longer reports the corrected p-value.
	    The "exact" p-values for the one-sample and two-sample
	    tests are based on the asymptotic limiting distribution of the
	    test statistic and involve infinite series.  By default, Stata
	    reports an approximate p-value computed using the first five
	    terms of the series.  The corrected p-value was obtained by
	    applying an ad hoc correction to the approximate p-value to
	    make it closer to the exact p-value.  In recent simulation
	    studies, we found that this correction does not perform
	    satisfactorily in all situations and is thus no longer supported.
	    The old results can be obtained under version control.  For a
	    two-sample test, you can use the {cmd:exact} option to obtain the
	    exact p-value.  
	    See {manhelp ksmirnov R}.

{p 7 12 2}
       31.  Existing command {cmd:tabulate} now has new 
            options {cmd:rowsort} and {cmd:colsort},
            which specify that the rows (columns) of a two-way tabulation be 
	    presented 
	    in order of observed frequency.
	    See {manhelp tabulate_twoway R:tabulate twoway}.

{p 7 12 2}
       32.  Existing estimation commands
            {helpb mprobit} and {helpb mlogit} with constraints
            defined using equation indices rather than the equation names
            would apply the constraints without accounting for the base
            outcome equation.  For example,

                . {cmd:sysuse auto}
                . {cmd:constraint 1 [#2]turn = [#2]trunk}
                . {cmd:mprobit rep78 turn trunk, baseoutcome(1) constraint(1)}

{pmore2}
            would result in [3]turn = [3]trunk instead of [2]turn = [2]trunk.
            Now {cmd:mprobit} accounts for the base outcome equation when
            applying such constraints.  The old behavior is preserved under
            version control.  Either behavior is truly reasonable, but the new
	    behavior is more consistent with how these commands report their
	    results.

{p 7 12 2}
       33.  Existing estimation commands 
            {helpb mprobit} and {helpb mlogit} did not respect 
	    constraints that had been defined using value labels 
	    associated with the levels of the outcome variable.
            For example,

                . {cmd:label define replab 1 "A" 2 "B" 3 "C" 4 "D" 5 "E"}
                . {cmd:label values rep78 replab}
                . {cmd:constraint 1 [2]turn = [2]trunk}
                . {cmd:mprobit rep78 turn trunk, baseoutcome(1) constraint(1)}

{pmore2}
            would drop constraint 1.
            Now {cmd:mprobit} and {cmd:mlogit} work with constraints 
	    specified in this way.

{pmore2}
            You can also now refer to the estimated coefficients using
            the equation name or the outcome value label in expressions.  
	    Using the above example, the following is now allowed:

{pmore3}
                . {cmd:test [3]turn = [3]trunk}

{pmore2}
            The old behavior disallowing these two behaviors is preserved
            under version control.

{p 7 12 2}
       34.  Existing command 
            {helpb nptrend} now displays value labels in its output.
            New option {opt nolabel} specifies that
            numerical codes be displayed rather than value
            labels.
	    See {manhelp nptrend R}.

{p 7 12 2}
       35.  Existing postestimation commands {helpb margins} 
	    and {helpb marginsplot} have many new features.   Some were
	    mentioned in the highlights:

{p 15 18 2}{help whatsnew13to14##WnMarginsOutcomes:Works with multiple outcomes simultaneously}{p_end}
{p 15 18 2}{help whatsnew13to14##WnMarginsMarginal:Integrates over unobserved components after multilevel and SEM models}{p_end}
{p 15 18 2}{help whatsnew13to14##WnMarginsDefault:Better default statistics after some estimators}{p_end}
{p 15 18 2}{help whatsnew13to14##WnMarginsFaster:margins is faster}{p_end}
{p 15 18 2}{help whatsnew13to14##WnMarginsGen:margins can now add its results to your data}{p_end}
{p 15 18 2}{help whatsnew13to14##WnMarginsDoc:And it is now easier to determine which features are available}{p_end}

{marker NewMarginsDefault}{...}
{p 7 12 2}
36.  {helpb margins} now defaults to prediction 
	    statistics different from
            the default for {helpb predict} when {cmd:predict}'s default
            is not the most interesting statistic for marginal analysis or when
	    that default is not statistically appropriate for marginal
	    analysis.  

{pmore2}
{cmd:margins} also defaults to producing statistics for
	    all equations, outcomes, or levels when possible.  The original 
	    behavior is preserved under version
	    control.  See the highlight
{help whatsnew13to14##WnMarginsDefault:{it:Better default statistics after some estimators}}.

{pmore2}
	The following estimators have new defaults:

{p2colset 18 34 38 2}{...}
{p2col:Command} New default statistic{p_end}
{p2line}
{p2col:{helpb clogit_postestimation##margins:clogit}}
	probability assuming fixed effect is zero{p_end}
{p2col:{helpb gsem_postestimation##margins:gsem}}
	expected values for each outcome{p_end}
{p2col:{helpb heckoprobit_postestimation##margins:heckoprobit}}
	marginal probabilities for each outcome{p_end}
{p2col:{helpb manova_postestimation##margins:manova}}
	linear predictions for each equation{p_end}
{p2col:{helpb meologit_postestimation##margins:meologit}}
	probabilities for each outcome{p_end}
{p2col:{helpb meoprobit_postestimation##margins:meoprobit}}
	probabilities for each outcome{p_end}
{p2col:{helpb meqrlogit_postestimation##margins:meqrlogit}}
	linear prediction{p_end}
{p2col:{helpb meqrpoisson_postestimation##margins:meqrpoisson}}
	linear prediction{p_end}
{p2col:{helpb mgarch_ccc_postestimation##margins:mgarch ccc}}
	linear predictions for each equation{p_end}
{p2col:{helpb mgarch_dcc_postestimation##margins:mgarch dcc}}
	linear predictions for each equation{p_end}
{p2col:{helpb mgarch_dvech_postestimation##margins:mgarch dvech}}
	linear predictions for each equation{p_end}
{p2col:{helpb mgarch_vcc_postestimation##margins:mgarch vcc}}
	linear predictions for each equation{p_end}
{p2col:{helpb mlogit_postestimation##margins:mlogit}}
	probabilities for each outcome{p_end}
{p2col:{helpb mprobit_postestimation##margins:mprobit}}
	probabilities for each outcome{p_end}
{p2col:{helpb mvreg_postestimation##margins:mvreg}}
	linear predictions for each equation{p_end}
{p2col:{helpb ologit_postestimation##margins:ologit}}
	probabilities for each outcome{p_end}
{p2col:{helpb oprobit_postestimation##margins:oprobit}}
	probabilities for each outcome{p_end}
{p2col:{helpb reg3_postestimation##margins:reg3}}
	linear predictions for each equation{p_end}
{p2col:{helpb rologit_postestimation##margins:rologit}}
	linear prediction{p_end}
{p2col:{helpb sem_postestimation##margins:sem}}
	linear predictions for each observed endogenous variable{p_end}
{p2col:{helpb slogit_postestimation##margins:slogit}}
	probabilities for each outcome{p_end}
{p2col:{helpb sureg_postestimation##margins:sureg}}
	linear predictions for each equation{p_end}
{p2col:{helpb varbasic_postestimation##margins:varbasic}}
	linear predictions for each equation{p_end}
{p2col:{helpb var_postestimation##margins:var}}
	linear predictions for each equation{p_end}
{p2col:{helpb vec_postestimation##margins:vec}}
	linear predictions for each equation{p_end}
{p2col:{helpb xtlogit_postestimation##margins:xtlogit, fe}}
	probability assuming fixed effect is zero{p_end}
{p2line}

{pmore2}
	For multilevel model estimators and {cmd:gsem}, the default
	prediction statistics are not statistically appropriate
	with {cmd:margins}.  These estimators now support 
	{help whatsnew13to14##WnMarginsDefault:marginal}
        predictions, which are highly interpretable when used with
        {cmd:margins}.  These marginal means and probabilities are now the
        default statistics produced by {cmd:margins} after
                   {helpb gsem},
                   {helpb mecloglog},
                   {helpb meglm},
                   {helpb melogit},
                   {helpb menbreg},
                   {helpb meologit},
                   {helpb meoprobit},
                   {helpb mepoisson}, and
                   {helpb meprobit}.

{p 7 12 2}
      37.  {helpb margins_contrast:margins, contrast()} has new suboptions
	    to support multiple {opt predict()} options.  Also see the
	    highlight
{help whatsnew13to14##WnMarginsOutcomes:{it:Works with multiple outcomes simultaneously}}.

{p 7 12 2}
      38.  {helpb margins} after {helpb mixed}, when the model specification
	    includes multilevel weights, now
            uses the product of the multilevel weights when computing the
            means and margins.  The previous behavior of using only the 
	    observation-level
            weights is preserved under version control.

{p 7 12 2}
       39.  Support for multilevel weights has been added in Stata 14 to 
	    several estimation commands:
                {helpb gsem},
                {helpb mecloglog},
                {helpb meglm},
                {helpb melogit},
                {helpb menbreg},
                {helpb meologit},
                {helpb meoprobit},
                {helpb mepoisson}, and
                {helpb meprobit}.
	    {helpb margins} also supports multilevel weights
	    for all of these commands.

{pmore2}
	    {cmd:margins} 
	    uses the 
	    product of the multilevel weights when computing means and
	    margins.

{p 7 12 2}
       40.  {helpb marginsplot} now supports the new multiple {cmd:predict()}
            options allowed on {helpb margins}.  It also automatically handles
            the new default of multiple results that {cmd:margins} produces
            with multivariate, multinomial, and ordinal estimators.  You can
            customize how these plot, equation, and outcome dimensions are
            graphed using the new directives {cmd:_predict}, {cmd:_equation},
            and {cmd:_outcome} in the existing options {cmd:xdimension()},
            {cmd:plotdimension()}, {cmd:bydimension()}, and
            {cmd:graphdimension()}.
	    See {manhelp marginsplot R}.



{marker NewSEM}{...}
    {title:1.3.3  What's new in statistics (SEM)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnSEMst:Survival models}
        {help whatsnew13to14##WnSEMsatorra:Satorra-Bentler scaled chi-squared test}
        {help whatsnew13to14##WnSEMsvy:Support for survey data}
        {help whatsnew13to14##WnSEMbeta:Beta distribution}
        {help whatsnew13to14##WnSEMother:Multilevel weights}
        {help whatsnew13to14##WnSEMother:Prediction improvements}

{pstd}
The following are also new:

{p 7 12 2}
       41.  Existing postestimation command 
            {helpb sem_predict:predict} after {helpb sem} now has the
            {opt scores} option for predicting parameter-level scores.
	    See {manhelp sem_predict SEM:predict after sem}.

{p 7 12 2}
       42.  Existing estimation command {cmd:sem} now reports information
            about each dependent variable in the header of the
            estimation table.

{p 7 12 2}
       43.  Existing estimation command 
            {helpb sem}'s starting-values logic for 
            {cmd:startvalues(fixedonly)} and for those built on it now
            considers all constraints on the fixed-effects
            parameters.  This improves convergence for some models.



{marker NewME}{...}
    {title:1.3.4  What's new in statistics (multilevel modeling)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnMEst:Multilevel mixed-effects parametric survival models}
        {help whatsnew13to14##WnDDF:Small-sample inference for linear multilevel mixed models}
        {help whatsnew13to14##WnMEsvy:Survey support and multilevel weights for multilevel models}

{pstd}
The following are also new:

{p 7 12 2}
       44.  Existing postestimation command {helpb predict} 
            supports new options after the following me
            estimators, nearly all multilevel:
            {helpb meglm_postestimation##predict:meglm},
            {helpb melogit_postestimation##predict:melogit},
            {helpb meprobit_postestimation##predict:meprobit},
            {helpb mecloglog_postestimation##predict:mecloglog},
            {helpb meologit_postestimation##predict:meologit},
            {helpb meoprobit_postestimation##predict:meoprobit},
            {helpb mepoisson_postestimation##predict:mepoisson},
            and
            {helpb menbreg_postestimation##predict:menbreg}.

{p 12 12 2}
                {cmd:predict} supports new
                options {cmd:density} and {cmd:distribution} for computing the
                density and distribution function of the fitted model using
                the current values and the estimated parameters.  

{p 12 12 2}
                {cmd:predict} supports new option
            	{opt scores} for predicting parameter-level scores.

{p 7 12 2}
       45.  Existing {help me} estimation commands 
            now support {cmd:iweight}s in the fixed-effects
	    and random-effects equations.



{marker NewTE}{...}
    {title:1.3.5  What's new in statistics (treatment effects)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnTEst:Treatment effects for survival models}
        {help whatsnew13to14##WnTEendog:Endogenous treatments}
        {help whatsnew13to14##WnTEpw:Probability weights}
        {help whatsnew13to14##WnTEbal:Balance analysis}

{pstd}
The following are also new:

{p 7 12 2}
	46.  Existing estimation command 
            {cmd:etregress} has new features, an improvement, and a change.

{p 12 12 2}
	    New option {cmd:cfunction} specifies that the model be estimated
	    using control function rather than the previously available
	    GMM and maximum likelihood estimators.
	    See {manhelp etregress TE}.

{p 12 12 2}
	    New option {cmd:poutcomes} specifies that a
	    potential-outcome model be fit with separate standard deviation
	    and correlation parameters in the treatment and control regimes.

{p 12 12 2}
	    {cmd:etregress} is now faster.

{p 12 12 2}
	    The labeling of the coefficients has changed such that
	    that the
            treatment is represented in factor variable notation.  The 
            old labeling is maintained under version
            control.

{pmore2}
	    See {manhelp etregress TE}.



{marker NewXT}{...}
    {title:1.3.6  What's new in statistics (longitudinal/panel data)}

{pstd}
Already mentioned as a highlight of the release was the following:

        {help whatsnew13to14##WnXTstreg:Panel-data survival models}

{pstd}
The following are also new:

{p 7 12 2}
       47.  Three estimators add the {cmd:vce(robust)} and 
	    {cmd:vce(cluster ...)} options to compute standard errors that are
	    robust to distributional assumptions and correlated data.
	    This new support is provided for 
		{cmd:xthtaylor}, 
		{cmd:xtivreg}, and
		the random-effects estimator of {cmd:xtpoisson}. 
		({cmd:xtpoisson} previously
		supported the options for Gaussian-distributed random effects
		but not for the default gamma distribution.)

{p 12 12 2}
See {manhelp xthtaylor XT}, {manhelp xtivreg XT}, and {manhelp xtpoisson XT}.


{p 7 12 2}
       48.  Existing estimation commands 
	    {helpb xtologit} and {helpb xtoprobit} now support weights -- 
	    frequency weights ({cmd:fweight}s), sampling weights
	    ({cmd:pweight}s), and importance weights ({cmd:iweight}s).
	    See {manhelp xtologit XT} and {manhelp xtoprobit XT}.

{p 7 12 2}
       49.  Existing estimation command {cmd:xtreg, fe}
            is now orders of magnitude faster when there are
            many panels, and there always are.



{marker NewTS}{...}
    {title:1.3.7  What's new in statistics (time series)}

{pstd}
Everything new was mentioned in the following highlights:

        {help whatsnew13to14##WnMarkov:Markov-switching regression models}
        {help whatsnew13to14##WnSB:Tests for structural breaks in time-series data}



{marker NewST}{...}
    {title:1.3.8  What's new in statistics (survival analysis)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnMEst:Multilevel mixed-effects parametric survival models}
        {help whatsnew13to14##WnDDF:Small-sample inference for linear multilevel mixed models}
        {help whatsnew13to14##WnMEsvy:Survey support and multilevel weights for multilevel models}

{pstd}
The following are also new:

{p 7 12 2}
       50.  Existing command 
            {cmd:stcurve} has new option {cmd:marginal}, which is a synonym for
            option {cmd:unconditional}; see
	    {manhelp streg_postestimation ST:streg postestimation}.

{p 7 12 2}
      51.  Existing estimation command 
            {helpb stcox} now allows factor variables in option {opt tvc()};
	    see {manhelp stcox ST}.

{p 7 12 2}
      52.  System variables created by command {helpb stset} -- {cmd:_st}, 
	    {cmd:_d}, {cmd:_t0}, {cmd:_t}, and
            {cmd:_origin} -- are now labeled.

{p 7 12 2}
       53.  Variables generated by existing command {helpb sttocc} are
            now labeled.

{p 7 12 2} 
       54.  Existing estimation command {cmd:streg}'s option
            {cmd:distribution(gamma)} was renamed to
            {cmd:distribution(ggamma)}.  {cmd:gamma} continues to be
            supported under version control.

{pmore2}
	This distribution should always have been designated {cmd:ggamma}
	because it is one of the generalized gamma distributions.  It is
	renamed now to avoid confusion with the {cmd:gamma} argument allowed
	with the new option {cmd:distribution(gamma)} allowed 
	on the {helpb mestreg} command and on the {helpb xtstreg} command
	and with the new option {cmd:family(gamma)} allowed on the
	{helpb gsem} command.



{marker NewSVY}{...}
    {title:1.3.9  What's new in statistics (survey data)}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnMEsvy:Survey support and multilevel weights for multilevel models}
        {help whatsnew13to14##WnSEMsvy:Support for survey data} (SEM)

{pstd}
    The following are also new:

{p 7 12 2}
       55.  Existing command 
            {helpb svyset} has a new syntax for specifying stage-level
            sampling weight variables.  New syntax supports
            commands such as {helpb gsem} and {helpb meglm} that can
            fit hierarchical multilevel models with group-level weights.
            See {manhelp svyset SVY}, and for examples of fitting a
            multilevel model with stage-level sampling weights, see
	    examples {mansection ME meglmRemarksandexamplesex5:5} and
	    {mansection ME meglmRemarksandexamplesex6:6}
            in {bf:[ME] meglm}.

{p 7 12 2}
      56.  The existing prefix command 
            {helpb svy_jackknife:svy jackknife:} with {helpb svyset} 
            replicate weight
            variables now uses the specified multiplier values as
            {helpb svyset} in the {opt jkrweight()} option, even for
	    unit-valued multipliers.
            The old behavior where {cmd:svy} {cmd:jackknife} used the default
            delete-1 multiplier instead of unit-valued multipliers is
            preserved under version control.



{marker NewPSS}{...}
    {title:1.3.10  What's new in statistics (power and sample size)}

{pstd}
Already mentioned as a highlight of the release was the following:

        {help whatsnew13to14##WnPSS:Power analysis for survival and epidemiological methods}

{pstd}
The following are also new:

{p 7 12 2}
       57.  Existing command {helpb power}
            now displays an estimated target variance in addition 
	    to the effect size when computing effect size for the 
	    analysis of variance and covariance methods. See 
	    {manhelp power_oneway PSS:power oneway},
	    {manhelp power_twoway PSS:power twoway}, and
	    {manhelp power_repeated PSS:power repeated}.
    


{marker NewMI}{...}
    {title:1.3.11  What's new in statistics (multiple imputation)}

{p 7 12 2}
        58.  Existing command 
            {helpb mi impute pmm} now requires the specification of the number
            of nearest neighbors in the {cmd:knn()} option.  Before,
            {cmd:mi impute pmm} used the default of one nearest neighbor,
            {cmd:knn(1)}.  

{p 12 12 2}
            Recent simulation studies demonstrated that using
            one nearest neighbor performed poorly in many of the considered
            scenarios.  In general, the optimal number of nearest neighbors
            varies from one application to another.  Thus
            {cmd:mi impute pmm} now requires that the {cmd:knn()} option be
            specified.  See {manhelp mi_impute_pmm MI:mi impute pmm} 
            for details.

{p 12 12 2}
            This change will also affect 
            {helpb mi impute monotone} and
            {helpb mi impute chained} when the {cmd:pmm} method is used in the
            conditional specifications.  The old behavior of the commands is
            available under version control.

{p 7 12 2}
      59.  {helpb mi} now requires that the names of imputation and passive
            variables not exceed 29 characters.  In the wide style, the
            names of these variables may be restricted to fewer than 29
            characters depending on the number of imputations.  In the
            flongsep style, the names of regular variables in addition to the
            names of imputation and passive variables also may not exceed 29
            characters.  These requirements are imposed by the internal
            structure of the {cmd:mi} command.  The affected commands are

                {cmd:mi convert}
                {cmd:mi import}
                {cmd:mi passive}
                {cmd:mi register}
                {cmd:mi rename}
                {cmd:mi set M}

{p 7 12 2}
       60.  {cmd:mi} supports new estimation command {helpb fracreg}.
            See {manhelp fracreg R}.



{marker NewMV}{...}
    {title:1.3.12  What's new in statistics (multivariate)}

{p 7 12 2}
       61.  {cmd:margins} used after existing estimation commands 
            {helpb manova} and {helpb mvreg} now defaults to 
            reporting linear predictions for all equations. 
            Previous behavior was to default to reporting 
            linear predictions for only the first equation. 



{marker NewD}{...}
    {title:1.3.13  What's new in data management}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnUnicode:Unicode support}
        {help whatsnew13to14##WnTrilObs:More than 2 billion observations now allowed}
        {help whatsnew13to14##WnICD10:Support for ICD-10 medical procedure codes}
	{help whatsnew13to14##WnPutexcel:Excel reports get better}

{pstd}
The following are also new:

{p 7 12 2} 
      62.  Stata's .dta dataset file format has changed. 
            The change was unavoidable because of Stata 14's new 
            Unicode features and the increase in the allowed maximum
            number of observations.  {cmd:use} continues to read 
            old-format files, of course.  {cmd:save} writes new-format
            files.  Use {cmd:saveold} when sharing datasets with 
            users of previous versions of Stata. 

{p 12 12 2}
            Few will be interested, but those who are should 
            see {helpb dta} for the technical specification of 
            the new dataset format. 

{p 7 12 2} 
      63.  Existing command 
           {helpb saveold} has a new {cmd:version()} option
           and the corresponding 
           ability to save files not only in the 
           format of the previous Stata release, but in the formats 
           of older releases, too. 
           {cmd:saveold} can save data in the formats of
           Stata 11, 12, and 13. 
           See {cmd:saveold} in {manhelp save D}. 

{p 7 12 2} 
       64.  Existing commands {helpb icd9} and {helpb icd9p} have 
            new features.  This was mentioned in passing 
            in the {help whatsnew13to14##WnICD10:highlights} 
            of the new {cmd:icd10} command.
            See {manhelp icd9 D}. 

{p 7 12 2}
       65.  Existing command {helpb destring} now handles Unicode. 
	    {cmd:destring}'s option {cmd:ignore()} has new suboptions
	    {cmd:asbytes} and {cmd:illegal} in support of Unicode, but you are
	    unlikely ever to want to specify either of these suboptions. 

{p 12 12 2} 
            New suboption {cmd:asbytes} specifies that multibyte sequences
            be treated as nothing more than a series of bytes, meaning
            strings may contain untranslated Extended ASCII characters.
            New suboption {cmd:illegal} specifies that multibyte characters
            that do not make sense to Unicode are to be ignored.

{p 12 12 2} 
	    See {manhelp destring D}.

{p 7 12 2}
       66.  Existing command {helpb import delimited} has 
            new option {cmd:encoding("}{it:encoding}{cmd:")}.
            This option allows {cmd:import delimited}
            to import into Stata files that contain Extended ASCII 
            strings.  The Extended ASCII characters are translated into 
            Unicode.  In addition, {cmd:import delimited}'s performance 
            has been improved.  
            See {manhelp import_delimited D:import delimited}.

{p 7 12 2}
       67.  Existing command {helpb generate} has new options 
            {cmd:before()} and {cmd:after()} so that the newly 
            created variable be placed {cmd:before(}{it:existing_var}{cmd:)}
            or {cmd:after(}{it:existing_var}{cmd:)}.
	    See {manhelp generate D}. 

{p 7 12 2}
      68.  New command {cmd:insobs} inserts new, empty observations
           into the dataset.  Empty means that the variables in 
           the new observations contain missing.  See {manhelp insobs D}. 



{marker NewFN}{...}
    {title:1.3.14  What's new in functions}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnRNGuniform:Uniformly distributed RNGs in specified intervals}
        {help whatsnew13to14##WnRNGdistribs:New RNGs for distributions}

{pstd} 
     It is also worth mentioning that Stata has a new 
    {mansection FN fnFunctions:{it:Functions Reference Manual}}
     dedicated solely to the documentation of functions.

{pstd}
     The following new functions are added to Stata and Mata:

{p 7 12 2}
   69.  New function {cmd:strrpos(}{it:s1}{cmd:,}{it:s2}{cmd:)} returns 
        the position of the last occurrence of {it:s2} in {it:s1}.
        That is to say, {cmd:strrpos()} searches backward from the 
        right.  
        See {manhelp string_functions FN:String functions}.

{p 7 12 2}
   70.  New string functions {cmd:u}{it:fcn}{cmd:()} 
        and {cmd:ud}{it:fcn}{cmd:()} corresponding
        to each string function {it:fcn}{cmd:()} are added. 
        These functions work in the Unicode metric as described in 
        {help whatsnew13to14##WnUnicodeStr:highlights}.  

{p 12 12 2}
     The following {cmd:u}{it:fcn}{cmd:()}s are added:

                New function             Corresponding to
                {hline 42}
		{helpb ustrlen()}                   {helpb strlen()}
		{helpb usubstr()}                   {helpb substr()}
		{helpb usubinstr()}                 {helpb subinstr()}
		{helpb ustrpos()}                   {helpb strpos()}
		{helpb ustrrpos()}                  {helpb strrpos()}

		{helpb ustrlower()}                 {helpb strlower()}
		{helpb ustrupper()}                 {helpb strupper()}
		{helpb ustrtitle()} 		    {helpb strproper()}

		{helpb ustrltrim()}                 {helpb strltrim()}
		{helpb ustrrtrim()}                 {helpb strrtrim()}
		{helpb ustrtrim()}                  {helpb strtrim()}

                {helpb ustrregexm()}                {helpb regexm()}
                {helpb ustrregexra()}               {helpb regexr()}
                {helpb ustrregexrf()}               {helpb regexr()}  [{it:sic}]
	        {helpb ustrregexs()}                {helpb regexs()}

		{helpb ustrreverse()}               {helpb strreverse()}
		{helpb uchar()}                     {helpb char()}
		{helpb ustrtoname()}                {helpb strtoname()}
		{helpb ustrword()}                  {helpb word()}
		{helpb ustrwordcount()}             {helpb wordcount()}
                {hline 42}


{p 12 12 2}
     The following {cmd:ud}{it:fcn}{cmd:()}s are added:

                New function             Corresponding to
                {hline 42}
                {helpb udstrlen()}                  {helpb strlen()}
                {helpb udsubstr()}                  {helpb substr()}
                {hline 42}

{p 12 12 2}
        See {manhelp string_functions FN:String functions}.

{p 7 12 2}
    71.  New Unicode string functions 
    {helpb ustrcompare()}, 
    {helpb ustrcompareex()}, 
    {helpb ustrsortkey()}, and 
    {helpb ustrsortkeyex()}
    compare and sort Unicode strings 
    in a locale-aware manner, for instance, by generating a key 
    for use with the {cmd:sort} command. 
    See {findalias frunicodesort}.

{p 7 12 2} 
72.  New Unicode string functions 
    {helpb ustrfrom()} and {helpb ustrto()} convert strings between UTF-8 and
    Extended ASCII encodings.  When converting from Extended ASCII to
    UTF-8, that is, when using {cmd:ustrfrom()}, you may want to first
    use new function {helpb ustrinvalidcnt()}, which counts the number of
    character sequences not already UTF-8.  {cmd:ustrinvalidcnt()}
    indicates that a string needs conversion.

{p 7 12 2}
73.  New Unicode string functions 
{helpb ustrunescape()} and 
{helpb ustrtohex()}
translate escape sequences to and from Unicode. 
Escape sequences look like {cmd:\u00e8}, which is the escape sequence 
for "è".  Some websites write this as U+00E8.  If you wanted 
"è" and did not know how to type it, you could type 
{cmd:ustrunescape("\u00e8")}.  The function would return {cmd:"è"}.

{p 12 12 2}
If you wanted to know the escape sequence for "è", 
you could use function {cmd:ustrtohex("è")} and get back 
the string {cmd:"\u00e8"}.

{p 7 12 2}
74.  New Unicode string function
    {helpb tobytes()} returns the byte values of a Unicode string.  For
    instance, {cmd:ustrtohex("è")} returns {cmd:"\d195\d168"} because
    the UTF-8 encoded form of "è" is two bytes long.  The byte
    value is 195 followed by 168, written in decimal form.

{p 7 12 2}
75.  New Unicode string functions
{helpb ustrleft()} and {helpb ustrright()} are most easily understood 
in terms of {cmd:usubstr()}. 
{cmd:ustrleft(}{it:s}{cmd:,} {it:#}{cmd:)} is equal to 
{cmd:substr(}{it:s}{cmd:, 1,} {it:#}{cmd:)}. 
and 
{cmd:ustrright(}{it:s}{cmd:,} {it:#}{cmd:)} is equal to 
{cmd:substr(}{it:s}{cmd:, -}{it:#}{cmd:, .)}.

{p 7 12 2} 
76.  The following new Unicode string functions
    are rarely used and highly technical:

		{helpb uisdigit()}
		{helpb uisletter()}
		{helpb ustrfix()}
		{helpb ustrnormalize()}
		{helpb wordbreaklocale()}
		{helpb collatorlocale()}
		{helpb collatorversion()}

{p 12 12 2} 
    See {manhelp string_functions FN:String functions}.

{p 7 12 2}
77.  There are many new random-number functions.
The new functions are

		{helpb runiform()}
		{helpb runiformint()}
		{helpb rexponential()}
		{helpb rlogistic()}
		{helpb rweibull()}
		{helpb rweibullph()}

{p 12 12 2} 
See {manhelp random_number_functions FN:Random-number functions}. 

{p 7 12 2}
       78.  A new family of functions computes probabilities and other
            quantities of the logistic distribution.

{p 12 12 2}
            {help logistic():{bf:logistic(}{it:x}{bf:)}} computes the
            cumulative distribution function of the logistic
            distribution with mean 0 and standard deviation
	    π/sqrt(3).

{p 12 12 2}
            {help logistic():{bf:logistic(}{it:s}{bf:,}{it:x}{bf:)}} computes
	    the cumulative distribution function of a logistic
            distribution with mean 0, scale {it:s}, and standard
	    deviation 
	    {it:s}π/sqrt(3).

{p 12 12 2}
            {help logistic():{bf:logistic(}{it:m}{bf:,}{it:s}{bf:,}{it:x}{bf:)}}
	    computes the cumulative distribution function of a logistic
            distribution with mean {it:m}, scale {it:s}, and standard
            deviation {it:s}π/sqrt(3).

{p 12 12 2}
            {help logisticden():{bf:logisticden(}{it:x}{bf:)}} computes the
            density of the logistic distribution with mean 0 and
	    standard deviation π/sqrt(3).

{p 12 12 2}
            {help logisticden():{bf:logisticden(}{it:s}{bf:,}{it:x}{bf:)}}
	    computes the density of the logistic distribution with mean 0,
	    scale {it:s}, and standard deviation {it:s}π/sqrt(3).

{p 12 12 2}
            {help logisticden():{bf:logisticden(}{it:m}{bf:,}{it:s}{bf:,}{it:x}{bf:)}}
	    computes the density of the logistic distribution with mean
	    {it:m}, scale {it:s}, and standard deviation {it:s}π/sqrt(3).

{p 12 12 2}
            {help logistictail():{bf:logistictail(}{it:x}{bf:)}}
	    computes the reverse cumulative logistic distribution with mean 0
	    and standard deviation π/sqrt(3).

{p 12 12 2}
            {help logistictail():{bf:logistictail(}{it:s}{bf:,}{it:x}{bf:)}}
	    computes the reverse cumulative logistic distribution with mean 0,
	    scale {it:s}, and standard deviation {it:s}π/sqrt(3).

{p 12 12 2}
            {help logistictail():{bf:logistictail(}{it:m}{bf:,}{it:s}{bf:,}{it:x}{bf:)}} computes
            the reverse cumulative logistic distribution with mean {it:m},
            scale {it:s}, and standard deviation π/sqrt(3).

{p 12 12 2}
            {helpb invlogistic():{bf:invlogistic(}{it:p}{bf:)}} computes the
            inverse cumulative logistic distribution: if
	    {opt logistic(x)} = {it:p}, then {opt invlogistic(p)} = {it:x}.

{p 12 12 2}
            {helpb invlogistic():{bf:invlogistic(}{it:s}{bf:,}{it:p}{bf:)}}
	    computes the inverse cumulative logistic distribution: if
	    {opt logistic(s,x)} = {it:p}, then {opt invlogistic(s,p)} = {it:x}.

{p 12 12 2}
            {helpb invlogistic():{bf:invlogistic(}{it:m}{bf:,}{it:s}{bf:,}{it:p}{bf:)}} computes the
            inverse cumulative logistic distribution: if
	    {opt logistic(m,s,x)} = {it:p}, then
	    {opt invlogistic(m,s,p)} = {it:x}.

{p 12 12 2}
            {helpb invlogistictail():{bf:invlogistictail(}{it:p}{bf:)}}
            computes the inverse reverse cumulative logistic distribution: if
            {opt logistictail(x)} = {it:p}, then
	    {opt invlogistictail(p)} = {it:x}.

{p 12 12 2}
            {helpb invlogistictail():{bf:invlogistictail(}{it:s}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative logistic distribution: if
            {opt logistictail(s,x)} = {it:p}, then
	    {opt invlogistictail(s,p)} = {it:x}.

{p 12 12 2}
            {helpb invlogistictail():{bf:invlogistictail(}{it:m}{bf:,}{it:s}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative logistic distribution: if
            {opt logistictail(m,s,x)} = {it:p}, then
            {opt invlogistictail(m,s,p)} = {it:x}.

{p 12 12 2}
            {helpb rlogistic():rlogistic()} computes logistic
            variates with mean 0 and standard deviation
            π/sqrt(3).

{p 12 12 2}
            {help rlogistic():{bf:rlogistic(}{it:s}{bf:)}} computes logistic
            variates with mean 0, scale {it:s}, and standard deviation
            {it:s}π/sqrt(3).

{p 12 12 2}
            {help rlogistic():{bf:rlogistic(}{it:m}{bf:,}{it:s}{bf:)}} computes
	    logistic variates with mean {it:m}, scale {it:s}, and standard
	    deviation {it:s}π/sqrt(3).

{p 12 12 2}
	    See {helpb statistical_functions:[FN] Statistical functions}
	    and {helpb random_number_functions:[FN] Random-number functions}.

{p 7 12 2}
       79.  A new family of functions computes probabilities and other
            quantities of the Weibull distribution.

{p 12 12 2}
            {help weibull():{bf:weibull(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}}
	    computes the cumulative distribution function of a Weibull
	    distribution with shape {it:a} and scale {it:b}.
	    {opt weibull(a,b,x)} = {opt weibull(a,b,0,x)}.

{p 12 12 2}
            {help weibull():{bf:weibull(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}} computes the
	    cumulative distribution function of a Weibull distribution with
	    shape {it:a}, scale {it:b}, and location {it:g}.

{p 12 12 2}
            {help weibullden():{bf:weibullden(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}}
	    computes the density of the Weibull distribution with shape
	    {it:a} and scale {it:b}.
	    {opt weibullden(a,b,x)} = {opt weibullden(a,b,0,x)}.

{p 12 12 2}
            {help weibullden():{bf:weibullden(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}} computes the
            density of the Weibull distribution with shape {it:a}, scale
            {it:b}, and location {it:g}.

{p 12 12 2}
            {help weibulltail():{bf:weibulltail(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}} computes the
            reverse cumulative Weibull distribution with shape {it:a} and
	    scale {it:b}. {opt weibulltail(a,b,x)} =
	    {opt weibulltail(a,b,0,x)}.

{p 12 12 2}
            {help weibulltail():{bf:weibulltail(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}} computes
            the reverse cumulative Weibull distribution with shape {it:a},
            scale {it:b}, and location {it:g}.

{p 12 12 2}
            {help invweibull():{bf:invweibull(}{it:a}{bf:,}{it:b}{bf:,}{it:p}{bf:)}} computes the
            inverse cumulative Weibull distribution: if
	    {opt weibull(a,b,x)} = {it:p}, then
	    {opt invweibull(a,b,p)} = {it:x}.

{p 12 12 2}
            {help invweibull():{bf:invweibull(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:p}{bf:)}} computes the
            inverse cumulative Weibull distribution: if
	    {opt weibull(a,b,g,x)} = {it:p}, then
	    {opt invweibull(a,b,g,p)} = {it:x}.

{p 12 12 2}
            {help invweibulltail():{bf:invweibulltail(}{it:a}{bf:,}{it:b}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative Weibull distribution: if
            {opt weibulltail(a,b,x)} = {it:p}, then
	    {opt invweibulltail(a,b,p)} = {it:x}.

{p 12 12 2}
            {help invweibulltail():{bf:invweibulltail(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative Weibull distribution: if
            {opt weibulltail(a,b,g,x)} = {it:p}, then
	    {opt invweibulltail(a,b,g,p)} = {it:x}.

{p 12 12 2}
            {help rweibull():{bf:rweibull(}{it:a}{bf:,}{it:b}{bf:)}}
	    computes Weibull variates with shape {it:a} and scale {it:b}.

{p 12 12 2}
            {help rweibull():{bf:rweibull(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:)}} computes Weibull
            variates with shape {it:a}, scale {it:b}, and location {it:g}.

{p 12 12 2}
	    See {helpb statistical_functions:[FN] Statistical functions}
	    and {helpb random_number_functions:[FN] Random-number functions}.

{p 7 12 2}
       80.  A new family of functions computes probabilities and other
            quantities of the Weibull distribution (proportional hazards).

{p 12 12 2}
            {help weibullph():{bf:weibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}} computes the
            cumulative distribution function of a Weibull distribution
	    (proportional hazards) with shape {it:a} and scale {it:b}.
	    {opt weibullph(a,b,x)} = {opt weibullph(a,b,0,x)}.

{p 12 12 2}
            {help weibullph():{bf:weibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}} computes the
            cumulative distribution function of a Weibull distribution
            (proportional hazards) with shape {it:a}, scale {it:b},
	    and location {it:g}.

{p 12 12 2}
            {help weibullphden():{bf:weibullphden(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}} computes
            the density of the Weibull distribution (proportional hazards)
            with shape {it:a} and scale {it:b}.
            {opt weibullphden(a,b,x)} = {opt weibullphden(a,b,0,x)}.

{p 12 12 2}
            {help weibullphden():{bf:weibullphden(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}} computes
	    the density of the Weibull distribution (proportional hazards)
	    with shape {it:a}, scale {it:b}, and location {it:g}.

{p 12 12 2}
            {help weibullphtail():{bf:weibullphtail(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}} computes
	    the reverse cumulative Weibull distribution (proportional hazards)
            with shape {it:a} and scale {it:b}.
	    {opt weibullphtail(a,b,x)} = {opt weibullphtail(a,b,0,x)}.

{p 12 12 2}
            {help weibullphtail():{bf:weibullphtail(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:x}{bf:)}}
            computes the reverse cumulative Weibull distribution (proportional
            hazards) with shape {it:a}, scale {it:b}, and location {it:g}.

{p 12 12 2}
            {helpb invweibullph():{bf:invweibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:p}{bf:)}} computes
            the inverse cumulative Weibull distribution (proportional
            hazards): if {opt weibullph(a,b,x)} = {it:p}, then
            {opt invweibullph(a,b,p)} = {it:x}.

{p 12 12 2}
            {help invweibullph():{bf:invweibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:p}{bf:)}} computes
            the inverse cumulative Weibull distribution (proportional
            hazards):  if {opt weibullph(a,b,g,x)} = {it:p}, then
            {opt invweibullph(a,b,g,p)} = {it:x}.

{p 12 12 2}
            {help invweibullphtail():{bf:invweibullphtail(}{it:a}{bf:,}{it:b}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative Weibull distribution
            (proportional hazards): if {opt weibullphtail(a,b,x)} = {it:p},
	    then {opt invweibullphtail(a,b,p)} = {it:x}.

{p 12 12 2}
            {help invweibullphtail():{bf:invweibullphtail(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative Weibull distribution
	    (proportional hazards): if {opt weibullphtail(a,b,g,x)} = {it:p},
	    then {opt invweibullphtail(a,b,g,p)} = {it:x}.

{p 12 12 2}
            {help rweibullph():{bf:rweibullph(}{it:a}{bf:,}{it:b}{bf:)}}
	    computes Weibull (proportional hazards) variates with shape
	    {it:a} and scale {it:b}.

{p 12 12 2}
            {help rweibullph():{bf:rweibullph(}{it:a}{bf:,}{it:b}{bf:,}{it:g}{bf:)}} computes
            Weibull (proportional hazards) variates with shape {it:a}, scale
            {it:b}, and location {it:g}.

{p 12 12 2}
	    See {helpb statistical_functions:[FN] Statistical functions}
	    and {helpb random_number_functions:[FN] Random-number functions}.

{p 7 12 2}
       81.  A new family of functions computes probabilities and other
            quantities of the exponential distribution.

{p 12 12 2}
            {help exponential():{bf:exponential(}{it:b}{bf:,}{it:x}{bf:)}}
	    computes the cumulative distribution function of an exponential
	    distribution with scale {it:b}.

{p 12 12 2}
            {help exponentialden():{bf:exponentialden(}{it:b}{bf:,}{it:x}{bf:)}}
	    computes the density of the exponential distribution with scale
	    {it:b}.

{p 12 12 2}
            {help exponentialtail():{bf:exponentialtail(}{it:b}{bf:,}{it:x}{bf:)}}
            computes the reverse cumulative exponential distribution with
            scale {it:b}.

{p 12 12 2}
            {help invexponential():{bf:invexponential(}{it:b}{bf:,}{it:p}{bf:)}} computes
            the inverse cumulative exponential distribution: if
            {opt exponential(b,x)} = {it:p}, then
	    {opt invexponential(b,p)} = {it:x}.

{p 12 12 2}
            {help invexponentialtail():{bf:invexponentialtail(}{it:b}{bf:,}{it:p}{bf:)}}
            computes the inverse reverse cumulative exponential distribution:
	    if {opt exponentialtail(b,x)} = {it:p},
	    then {opt invexponentialtail(b,p)} = {it:x}.

{p 12 12 2}
            {help rexponential():{bf:rexponential(}{it:b}{bf:)}} computes
	    exponential variates with scale {it:b}.

{p 12 12 2}
	    See {helpb statistical_functions:[FN] Statistical functions}
	    and {helpb random_number_functions:[FN] Random-number functions}.

{p 7 12 2}
       82.  The following statistical functions are added:

{p 12 12 2}
	    {help invnt():{bf:invnt(}{it:df}{bf:,}{it:np}{bf:,}{it:p}{bf:)}}
	    computes inverse cumulative noncentral Student's t distribution.

{p 12 12 2}
	    {help invnF():{bf:invnF(}{it:df1}{bf:,}{it:df2}{bf:,}{it:np}{bf:,}{it:p}{bf:)}}
	    computes inverse cumulative noncentral F distribution.

{p 12 12 2}
	    {help lnwishartden():{bf:lnwishartden(}{it:df}{bf:,}{it:V}{bf:,}{it:X}{bf:)}}
	    computes natural logarithm of the density of the Wishart
	    distribution.

{p 12 12 2}
	    {help lniwishartden():{bf:lniwishartden(}{it:df}{bf:,}{it:V}{bf:,}{it:X}{bf:)}}
	    computes natural logarithm of the density of the inverse Wishart
	    distribution.

{p 12 12 2}
	    {help lnmvnormalden():{bf:lnmvnormalden(}{it:M}{bf:,}{it:V}{bf:,}{it:X}{bf:)}}
	    computes natural logarithm of the multivariate normal density.

{p 12 12 2}
	    {help lnigammaden():{bf:lnigammaden(}{it:a}{bf:,}{it:b}{bf:,}{it:x}{bf:)}}
	    computes natural logarithm of the inverse gamma density.

{p 12 12 2}
	    See {helpb density_functions:[FN] Statistical functions}.

{p 7 12 2}
      83.  The string functions, random-number functions, and statistical
           functions added to Stata were also added to Mata.

{p 12 12 2}
	    See {helpb m4_string:[M-4] string},
	        {helpb mf_runiform:[M-5] runiform()},
	    and {helpb mf_normal:[M-5] normal()}.



{marker NewG}{...}
    {title:1.3.15  What's new in graphics}

{p 7 12 2}
       84.  New commands {helpb graph replay} and {helpb graph close}  
            join improved existing command {helpb graph drop} to 
            form a useful suite.   All accept a graph name, 
            a list of graph names, {cmd:_all}, and graph names 
            with wildcards.

{p 12 12 2}
	    {cmd:graph replay} redisplays graphs. 

{p 12 12 2}
	    {cmd:graph close} closes graph windows. 

{p 12 12 2} 
	    {cmd:graph drop} drops graphs (and closes their window 
            if they have one open). 

{p 12 12 2} 
	    See 
	    {manhelp graph_replay G-2:graph replay}, 
	    {manhelp graph_replay G-2:graph close}, and
	    {manhelp graph_replay G-2:graph drop}.
	
{p 7 12 2} 
       85.  Existing command 
            {helpb histogram} now allows bin size to be recalculated
            in each category when {cmd:by} is specified; specify the
            new option {cmd:binrescale}.
	    See {manhelp histogram R}. 

{p 7 12 2} 
       86.  Existing command 
            {helpb twoway kdensity} can now estimate the density one
            bandwidth beyond the maximum and minimum values of the
            dependent variable; specify new option {cmd:boundary}.

{p 7 12 2}
        87.  New graph commands for the new IRT models are provided:

{p 12 12 2}
	     {helpb irtgraph icc} graphs item characteristic curves. 
	
{p 12 12 2}
	     {helpb irtgraph tcc} graphs test characteristic curves. 

{p 12 12 2}
	     {helpb irtgraph iif} graphs the item information function.

{p 12 12 2}
	     {helpb irtgraph tif} graphs the test information function.

{p 12 12 2}
	     See 
	     {manhelp irtgraph_icc IRT:irtgraph icc}, 
	     {manhelp irtgraph_tcc IRT:irtgraph tcc}, 
	     {manhelp irtgraph_iif IRT:irtgraph iif}, and
	     {manhelp irtgraph_tif IRT:irtgraph tif}.

{p 7 12 2}
        88.  {helpb bayesgraph} graphs summaries and 
             convergence diagnostics for simulated posterior
             distributions (MCMC samples) of model parameters and
             functions of model parameters obtained from new command
             {helpb bayesmh}.  Graphical summaries include trace plots,
             autocorrelation plots, and various distributional plots.
	     See {manhelp bayesgraph BAYES}. 



{marker NewM}{...}
    {title:1.3.16  What's new in Mata}

{p 7 12 2}
       89.  All the new functions added to Stata have also been added to
            Mata.
	    See {help whatsnew13to14##NewFN:{it:1.3.14 What's new in functions}}
	    above.

{p 7 12 2}
      90.  Mata's file commands can now read, write, 
            and seek with files that are longer than 2GB 
            on 64-bit systems.  See {manhelp mf_fopen M-5:fopen()}.

{p 7 12 2}
       91.  The default size of the Mata cache has been increased 
            from 400 to 2,000 kilobytes.
	    See {manhelp mata_set M-3:mata set}. 

{p 7 12 2}
      92.  Existing {cmd:xl()} Excel file I/O class has been 
           extended beyond inserting text to include formatting of text, 
           alignment, boldface, color, italics, and the like;
           inserting Stata graphs; 
           specifying Excel formats including date formats, currency
           formats, etc.; cell spanning and table border
           formatting; and inserting Excel formulas.  See the highlight
           {help whatsnew13to14##WnPutexcel:{it:Excel reports get better}} and
           see {manhelp mf_xl M-5:xl()}.

{p 7 12 2}
      93.  New {cmd:PdfDocument()} class has creates PDF files 
           from scratch in a programmatic way.  
           See {manhelp mf_pdf M-5:Pdf*()}.



{marker NewP}{...}
    {title:1.3.17  What's new in programming}

{p 7 12 2}
       94.  Command {cmd:version} has new option {cmd:user}.  This option
	    causes {cmd:version} to backdate the random-number generators 
            (RNGs). 
            The new RNGs are a {help whatsnew13to14##WnRNG:highlight} of 
            Stata 14.
            As {help whatsnew13to14##WnRNGchoosing:we explained}, 
            the {cmd:version} command has become more sophisticated. 
            Seemingly like magic, Stata chooses an RNG according 
            to what the user has specified and ignores
            the version numbers specified in intermediary ado-files.  If the
            user is running under version 14, it does not matter if the
            ado-file was written for Stata 12.  Any {cmd:runiform()} function
            in it is given the same interpretation as in Stata 14.

{p 12 12 2} 
            This is because Stata is tracking a second version number
            along with the first.  The second is known as the user version 
            and is set only when the {cmd:version} command is given 
            interactively or in do-files.  {cmd:version} given here 
            sets both version numbers.  In your ado-file, {cmd:version}
	    sets only the first version number.  If you want to 
            set the second version number in your ado-file, you add a 
            second {cmd:version} line with option {cmd:user}. 

{p 12 12 2} 
            Official guidelines are that you should not do this, or 
            at least, not do this without warning the user that 
            your command does not honor the implicit RNG setting
            via the user setting the version number. 

{p 7 12 2} 
       95.  {cmd:creturn()} reports two new system settings, 
            {cmd:c(rng)} and {cmd:(rng_current)}.  

{p 12 12 2}
            {cmd:c(rng)} corresponds to the setting of 
            {cmd:set rng}, which will usually be the string 
            {cmd:default} but could be {cmd:mt64} or {cmd:kiss32}. 
            If it is {cmd:default}, the RNGs in effect on based 
            on {cmd:version}, as described above.  

{p 12 12 2}
	    {cmd:c(rng_current)} reports the RNGs in effect -- the 
            RNGs that would be used by {cmd:runiform()} if it were 
            given now -- regardless of how that was set or determined. 
            Its values are {cmd:mt64} or {cmd:kiss32}. 

{p 7 12 2} 
       96.  Stata's dialog programming language now provides 
	    a {cmd:TREEVIEW} input control.  
	    See 
	    {help dialogs##remarks3.6.17:{it:3.6.17 TREEVIEW tree input control}}
	    in {manhelp dialogs P:dialog programming}.

{p 7 12 2}
      97.  New command {cmd:set locale_functions} {it:localename} 
            resets the default locale used by new Unicode string functions,
	    which take an optional locale argument.  {cmd:set} 
            {cmd:locale_functions} is automatically set to {cmd:default},
            which means the operating system's recorded locale.
            See {manhelp set_locale_functions P:set locale_functions}. 

{p 7 12 2} 
98.  Two new extended macro functions are provided. 

{p 12 12 2}
{cmd::ustrlen} 
is the macro equivalent of the new {cmd:ustrlen()} function. 

{p 12 12 2}
{cmd::udstrlen}  
is the macro equivalent of the new {cmd:udstrlen()} function. 

{p 12 12 2}
See {manhelp macro P}. 



{marker NewGUI}{...}
    {title:1.3.18  What's new in the Stata interface}

{pstd}
Already mentioned as highlights of the release were the following:

        {help whatsnew13to14##WnPostest:Postestimation made easy}
        {help whatsnew13to14##WnQstart:Manual entries now have Quick starts}
        {help whatsnew13to14##WnLoc:Stata in Spanish and Japanese}

{pstd}
The following are also new:

{p 7 12 2}
       99.  The Data Editor has three new features. 

{p 12 12 2}
	You can now use Find in the Data Editor to search.

{p 12 12 2}
	You can now insert variables or observations in the 
           middle of your data.

{p 12 12 2} 
        You can print the entire dataset or a selection. 

{p 6 12 2}
100.  The Variable Manager now supports printing.  You can 
print the entire list of variables or a selection. 

{p 6 12 2}
101.  You can now export graphs and results to PDF files in Stata 
for Unix.  You could always do this with Windows or Mac. 

{p 6 12 2}
102.  The PDF export engine in Stata for Windows is all new
    and provides support for the new Unicode features in Stata. 
      


{marker NewMore}{...}
    {title:1.3.19  What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated. All between-release updates are
available for free over the Internet. 

{pstd}
Type {cmd:update query} and follow the instructions.

{pstd}
We hope that you enjoy Stata 14.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew13}.

{hline}
