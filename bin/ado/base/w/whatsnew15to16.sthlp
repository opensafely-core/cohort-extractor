{smcl}
{* *! version 1.0.6  05feb2020}{...}
{findalias asfrupdate}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{title:What's new in release 16.0 (compared with release 15)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 16.0:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {bf:this file}        Stata 16.0 new release       2019            {c |}
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
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}

{pstd}
Most recent changes are listed first.


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew16}.


{hline 3} {hi:Stata 16.0 release 26jun2019} {hline}

{* ------------------------------------------------------------}{...}
      {bf:Contents}
{p 11 12 2}1.3  What's new{p_end}
{* ...}{...}

{p 9 12 2}{help whatsnew15to16##highlights:1.3.1  Highlights}{p_end}
{* ...}{...}

{p 9 12 2}{help whatsnew15to16##NewStat:1.3.2  What's new in statistics (general)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewME:1.3.3  What's new in statistics (multilevel)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewBAYES:1.3.4  What's new in statistics (Bayesian)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewPSS:1.3.5  What's new in statistics (power and sample size)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewXT:1.3.6  What's new in statistics (panel data)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewSVY:1.3.7  What's new in statistics (survey data)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewSEM:1.3.8  What's new in statistics (SEM)}{p_end}
{* ...}{...}
{p 9 12 2}{help whatsnew15to16##NewTS:1.3.9  What's new in statistics (time series)}{p_end}
{* ...}{...}
{phang2}{help whatsnew15to16##NewIRT:1.3.10  What's new in statistics (item response theory)}{p_end}
{* ...}{...}
{phang2}{help whatsnew15to16##NewDSGE:1.3.11  What's new in statistics (DSGE)}{p_end}

{* ...}{...}
{phang2}{help whatsnew15to16##NewFN:1.3.12  What's new in functions}{p_end}

{* ...}{...}
{phang2}{help whatsnew15to16##NewG:1.3.13  What's new in graphics}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewD:1.3.14  What's new in data management}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewP:1.3.15  What's new in programming}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewM:1.3.16  What's new in Mata}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewREPORT:1.3.17  What's new in reporting}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewGUI:1.3.18  What's new in the Stata interface}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewMisc:1.3.19  What's new (miscellaneous)}{p_end}
{* ...}{...}

{phang2}{help whatsnew15to16##NewMore:1.3.20  What's more}{p_end}

{pstd}
    This section is intended for users of the previous version of
    Stata.  If you are new to Stata, you may as well skip to 
    {it:{help whatsnew15to16##NewMore:What's more}}, below.

{pstd}
    As always, Stata 16 is 100% compatible with the previous releases,
    but we remind programmers that it is important to put 
    {cmd:version 15.1}, {cmd:version} {cmd:15}, or {cmd:version 14},
    etc., at the top of old do- and ado-files so that they continue to
    work as you expect.  You were supposed to do that when you wrote
    them, but if you did not, go back and do it now.

{pstd}
    We will list all the changes, item by item, but first, here are the
    highlights.


{* ------------------------------------------------------------}{...}
{marker highlights}{...}
{title:1.3.1  Highlights}

{pstd}
The following are the highlights of the Stata 16 release:

{p 5 9 2}
    1.  {help whatsnew15to16##lasso:Lasso}
 
{p 5 9 2}
     2.  {help whatsnew15to16##autoreport:Automated reporting}

{p 5 9 2}
     3.  {help whatsnew15to16##meta:Meta-analysis}

{p 5 9 2}
     4.  {help whatsnew15to16##choice:Choice models}

{p 5 9 2}
     5.  {help whatsnew15to16##python:Python integration}

{p 5 9 2}
     6.  {help whatsnew15to16##bayes:Bayes: Multiple chains, predictions, and more}

{p 5 9 2}
     7.  {help whatsnew15to16##erms:ERMs for panel data}

{p 5 9 2}
    8.  {help whatsnew15to16##import:Import data from SAS and SPSS}

{p 5 9 2}
    9.  {help whatsnew15to16##npse:Nonparametric series regression}

{p 4 9 2}
   10.  {help whatsnew15to16##frames:Frames: Multiple datasets in memory}

{p 4 9 2}
   11.  {help whatsnew15to16##ss:Sample-size analysis for confidence intervals}

{p 4 9 2}
   12.  {help whatsnew15to16##nonlinearDSGE:Nonlinear DSGE models}

{p 4 9 2}
   13.  {help whatsnew15to16##irt:Multiple-group IRT}

{p 4 9 2}
   14.  {help whatsnew15to16##pdsel:xtheckman: Panel data selection models}

{p 4 9 2}
   15.  {help whatsnew15to16##pharmo:Nonlinear multilevel models with lags, and more: Multiple-dose PK models}

{p 4 9 2}
   16.  {help whatsnew15to16##hetoprobit:Heteroskedastic ordered-probit models}

{p 4 9 2}
   17.  {help whatsnew15to16##sizes:Graph sizes in printer points, inches, or centimeters}

{p 4 9 2}
    18.  {help whatsnew15to16##numinteg:Numerical integration}

{p 4 9 2}
    19.  {help whatsnew15to16##lp:Linear programming}

{p 4 9 2}
    20.  {help whatsnew15to16##korean:Stata in Korean} (Stata 한국어로)

{p 4 9 2}
    21.  {help whatsnew15to16##dofileed:Do-file Editor updates}

{p 4 9 2}
    22.  {help whatsnew15to16##mac:Mac interface updates}

{p 4 9 2}
    23.  {help whatsnew15to16##matsize:Set matsize obviated}


{* ------------------------------------------------------------}{...}
{marker lasso}{...}
{title:Highlight 1. Lasso}

    {bf:Highlight 1, take 1: Model selection and prediction}

{pstd}
    Both lasso and elastic net select models and estimate their coefficients,
    simultaneously.  These estimated coefficients are constructed to
    improve prediction.  For instance, if we type

             {cmd:. lasso linear y x1-x4000}

     or 

             {cmd:. elasticnet linear y x1-x4000}

{pstd}
   then {cmd:lasso} or {cmd: elasticnet} will select a
   subset of the specified covariates -- say, x2, x10, x11, x21, ... -- from
   the 4,000 potential covariates we specified.  The number of potential
   covariates can be large, even larger than the number of observations
   in the data.

{pstd}
   These examples use linear models to select optimal predictors for a
   continuous outcome y.  {cmd:lasso} and {cmd:elasticnet} can also
   select covariates for binary-outcome logit and probit models
   and count-outcome Poisson models.

{pstd}
   After model selection, use Stata's standard {cmd:predict}
   command to obtain predictions regardless of outcome type.


    {bf:Highlight 1, take 2: Inference}

{pstd}
    Stata 16 also provides commands for fitting lassos for use in
    inference.  These commands estimate and test a subset of the
    coefficients while using lasso to select the other control
    variables that need to appear in the model.

{pstd}
The commands are arranged in three groups.

{p 8 11 2}
1. The {cmd:ds} commands perform double-selection lasso.
   Provided are {helpb dsregress}, {helpb dslogit}, and {helpb dspoisson}.

{p 8 11 2}
2. The {cmd:po} commands perform partialing-out lasso.
   Provided are {helpb poregress}, {helpb pologit}, and {helpb popoisson}.
   Also provided is {helpb poivregress} for fitting linear models that
   contain endogenous variables.

{p 8 11 2}
3. The {cmd:xpo} commands perform 
   cross-fit partialing-out lasso, also known as 
   double machine learning 1 and 2
   (DML1 and DML2).  Provided are 
   {helpb xporegress}, {helpb xpologit}, and {helpb xpopoisson}.
   Also provided is {helpb xpoivregress} for fitting linear models that
   contain endogenous variables.

{pstd}
   Remarkably, 
   the estimates and standard errors produced by these commands 
   are robust to any model-selection mistakes that the lasso makes.


{marker bayesvarsel}{...}
    {bf:Highlight 1, take 3: Bayesian modeling}

{pstd}
    Did you know that you can fit Bayesian lasso linear models by using 
    {helpb bayes_regress:bayes: regress}?  And that inference can be
    performed in the usual Bayesian way, just as it would be for any
    other model?

{pstd}
    Lasso uses L1-constrained least squares to estimate its coefficients.
    This involves selecting a value for the penalty parameter,
    which is often done using cross-validation.

{marker laplprior}{...}
{pstd}
    The Bayesian approach is different.  Constraints are imposed
    through prior distributions.  The Laplace prior provides
    constraints that have the same analytic form as the L1 penalty
    used in lasso.  The Laplace prior introduces the penalty
    parameter as one more model parameter that needs to be estimated
    from the data.

{pstd}
    To fit a lasso-style model, use the {helpb bayes:bayes:} prefix or
    the {helpb bayesmh} command with Laplace priors.  No variable selection
    is performed automatically, but Bayesian analysis offers various
    ways to select variables.  One is to use {helpb bayesstats summary} to
    display a table of the posterior probabilities that each
    coefficient is different from 0 and select variables based on 
    them.


    {bf:Highlight 1, take 4: Documentation}

{pstd}
    See the
{mansection LASSO lassoLasso:{bf:[LASSO]} {it:Stata Lasso Reference Manual}}.


    {it:One more thing ...}

{pstd}
    New command {manhelp vl D} is especially helpful for assembling 
    the varlists you specify when fitting lasso models.  These
    varlists contain the potential 
    RHS variables from which lasso chooses a subset.  These 
    varlists can be long.  {cmd:vl} makes constructing them
    easier.


{* ------------------------------------------------------------}{...}
{marker autoreport}{...}
{title:Highlight 2. Automated reporting}

{pstd}
    Automated reporting is a hallmark of Stata.  Users have long employed
    Stata's reporting features in do-files to create 

{p 8 11 2}
        1. reproducible reports and

{p 8 11 2}
        2. reports that update themselves by rerunning the analysis on 
           the latest data.

{pstd}
    Stata's reporting features can produce reports in Word ({cmd:.docx}),
    Excel ({cmd:.xls}, {cmd:.xlsx}), PDF, and HTML formats.  Reports can
    combine content that you write with Stata results and graphs.

{pstd}
    That said, you were left on your own to figure out how to do this.

{pstd} 
    Stata 16 has new and improved features, of course, but just as 
    importantly, all of Stata's reporting features are now documented 
    in the new 
{mansection RPT rptReporting:{bf:[RPT]} {it:Stata Reporting Reference Manual}}.
    The new manual includes examples and workflows.

{pstd}
    In addition, 

{p 8 8 2}
    Existing commands {helpb dyndoc} and {helpb markdown} can now create
    Word documents from Markdown source, not just HTML documents.

{p 8 8 2}
    Existing command {helpb putdocx} now lets you create headers,
    footers, page numbers, and text blocks in Word documents.

{p 8 8 2}
    New command {helpb docx2pdf} converts Word documents to PDF.

{p 8 8 2}
    New command {helpb html2docx} converts HTML documents to Word
    and preserves the style of the HTML documents.

    
{* ------------------------------------------------------------}{...}
{marker meta}{...}
{title:Highlight 3. Meta-analysis}

{pstd} 
    Stata 16 has a new suite of commands for performing
    meta-analysis.  The suite includes {cmd:meta} {cmd:set},
    {cmd:meta} {cmd:esize}, {cmd:meta}
    {cmd:forestplot}, and more.  The suite lets you explore
    and combine the results from different studies.
 
{pstd}
    The new suite is broad, but what sets it apart is its simplicity.
    Let's start with simplicity.  See
    {help whatsnew15to16##metaex:Workflow} below.  Then see 
    {help whatsnew15to16##metafeat:Summary of features in four tables}.
    Also see {manhelp meta META} in the new
{mansection META metaMeta-Analysis:{bf:[META]} {it:Stata Meta-Analysis Reference Manual}}
    for all the details.


{marker metaex}{...}
    {bf:Workflow}

{pstd}
    Here is one possible workflow:

{phang2}
1. {help whatsnew15to16##metaset:Prepare the data for meta-analysis}
{p_end}
{phang2}
2. {help whatsnew15to16##metasum:Obtain summaries of effect sizes}
{p_end}
{phang2}
3. {help whatsnew15to16##metahet:Explore heterogeneity by using subgroup analysis and meta-regression}
{p_end}
{phang2}
4. {help whatsnew15to16##metabias:Investigate publication bias by using funnel plots, ...}
{p_end}
{phang2}
5. {help whatsnew15to16##metacumul:Perform cumulative meta-analysis by using forest plots, ...}
{p_end}


{marker metaset}{...}
{pstd}
  {ul:{it:Workflow step 1: Prepare the data for meta-analysis}}

{pstd}
    Tell {cmd:meta} that your data have effect sizes and their
    standard errors already stored in variables such as {cmd:es} and
    {cmd:se}, 
{p_end}

{phang2}{cmd:. meta set es se}

{pstd}
    or that you have binary summary data and 
    want to compute, for instance, log odds-ratios, 
{p_end}

{phang2}{cmd:. meta esize n11 n12 n21 n22, esize(lnoratio)}

{pstd}
    or that you have continuous summary data and
    want to compute, for instance, Hedges's g standardized mean
    differences, 
{p_end}

{phang2}{cmd:. meta esize n1 mean1 sd1 n2 mean2 sd2, esize(hedgesg)}


{marker metasum}{...}
{pstd}
{ul:{it:Workflow step 2: Obtain summaries of effect sizes}}

{pstd}
    Estimate overall effect size and its confidence interval (CI), obtain heterogeneity
    statistics, and more:
{p_end}

{phang2}{cmd:. meta summarize}

{pstd}
    Or produce a forest plot:
{p_end}

{phang2}{cmd:. meta forestplot}


{marker metahet}{...}
{pstd}
{ul:{it:Workflow step 3: Explore heterogeneity by using subgroup analysis and meta-regression}}

{pstd}
    If the studies in your data are divided into groups,
    explore heterogeneity across them by using a subgroup forest plot:

{phang2}{cmd:. meta forestplot, subgroup(group)}

{pstd}
Explore heterogeneity induced by a continuous moderator {cmd:x} by using
meta-regression:
{p_end}

{phang2}{cmd:. meta regress x}


{marker metabias}{...}
{pstd}
{ul:{it:Workflow step 4: Investigate publication bias by using funnel plots, ...}}

{pstd}
Check visually for funnel-plot asymmetry:
{p_end}
   
{phang2}{cmd:. meta funnelplot}

{pstd}
Check whether funnel-plot
asymmetry is because of publication bias
by using a contour-enhanced funnel plot:
{p_end}

{phang2}{cmd:. meta funnelplot, contours(1 5 10)}

{pstd}
    Test formally for funnel-plot asymmetry:
{p_end}

{phang2}{cmd:. meta bias, egger}

{pstd}
    Assess publication bias by using the trim-and-fill method:
{p_end}

{phang2}{cmd:. meta trimfill}


{marker metacumul}{...}
{pstd}
{ul:{it:Workflow step 5: Perform cumulative meta-analysis by using forest plots, ...}}

{pstd}
Explore temporal trends in overall effect sizes and display results 
in a table,{p_end}

{phang2}{cmd:. meta summarize, cumulative(year)}

{pstd}
or display results in a forest plot:{p_end}

{phang2}{cmd:. meta forestplot, cumulative(year)}


{marker metafeat}{...}
    {bf:Summary of features}

{p2colset 9 40 42 2}{...}
{center:Table 1.  Three analysis models}
{p2line}
{p2col:Model}Estimates{p_end}
{p2line}
{p2col:Common-effect}single overall effect{p_end}
{p2col:Fixed-effects}weighted average of study effects{p_end}
{p2col:Random-effects}mean of the distribution of effects{p_end}
{p2line}


{center:Table 2.  Estimation methods}
{p2line}
{p2col:Model}Methods{p_end}
{p2line}
{p2col:Common-effect}inverse-variance
                              Mantel-Haenszel (binary data){p_end}
{p2col:Fixed-effects}inverse-variance
                              Mantel-Haenszel (binary data){p_end}
{p2col:Random-effects}REML, ML, empirical Bayes,
                              DerSimonian-Laird, Sidik-Jonkman, 
                              Hedges, Hunter-Schmidt{p_end}
{p2line}


{center:Table 3.  {cmd:meta} works with three types of data: Observations}
{center:record studies and variables record ...}
{p2line}
{p2col:Dataset format}Contains individual variables for{p_end}
{p2line}
{p2col:Binary-outcome summary data}{it:#} of successes (treated){p_end}
{p2col:}{it:#} of failures  (treated){p_end}
{p2col:}{it:#} of successes (controls){p_end}
{p2col:}{it:#} of failures  (controls){p_end}
{p2line}
{p2col:Continuous-outcome summary}sample size    (treated){p_end}
{p2col:{space 2}data}mean           (treated){p_end}
{p2col:}std. dev.      (treated){p_end}
{p2col:}sample size    (controls){p_end}
{p2col:}mean           (controls){p_end}
{p2col:}std. dev.      (controls){p_end}
{p2line}
{p2col:Precomputed effect-sizes data}effect size (correlation, HR, OR,
                           mean difference, etc.){p_end}
{p2col:}std. err. or CI of effect size{p_end}
{p2line}


{center:Table 4:  The {cmd:meta} commands}
{p2line}
{p2col:Command}Purpose{p_end}
{p2line}
{p2col:{helpb meta set}}declare data using precalculated effect sizes{p_end}
{p2col:{helpb meta esize}}declare data (calculate effect sizes){p_end}
{p2col:{helpb meta update}}modify declaration of meta data{p_end}
{p2col:{helpb meta query}}report how meta data are set{p_end}

{p2col:{helpb meta summarize}}summarize meta-analysis results{p_end}
{p2col:{helpb meta forestplot}}graph forest plot{p_end}

{p2col:{helpb meta regress}}perform meta-regression{p_end}
{p2col:{helpb predict}}predict random effects, etc.{p_end}
{p2col:{helpb estat bubbleplot}}graph bubble plot{p_end}
{p2col:{helpb meta labbeplot}}graph L'Abbé plot{p_end}

{p2col:{helpb meta funnelplot}}graph funnel plots{p_end}
{p2col:{helpb meta bias}}test for small-study effects {p_end}
{p2col:{helpb meta trimfill}}trim-and-fill analysis{p_end}
{p2line}
        {it:Notes:}
           1. {cmd:meta summarize, subgroup()} performs subgroup analysis.
           2. {cmd:meta summarize, cumulative()} performs cumulative
              meta-analysis.
           3. {cmd:meta forestplot} with the {cmd:subgroup()} or
	      {cmd:cumulative()} option does the same, but graphically.
           4. {cmd:meta funnelplot, contours()} produces contour-enhanced
              funnel plots.


{* ------------------------------------------------------------}{...}
{marker choice}{...}
{title:Highlight 4. Choice models}

{pstd} 
     Stata's choice models have been reorganized and updated, and that
     is putting it mildly.  There are new commands, and the previous
     commands have been improved and replaced by commands with new names.
     The result is a set of {cmd:cm*} commands that are related, 
     all work in the same way, and are documented together in the new
{mansection CM cmChoiceModels:{bf:[CM]} {it:Stata Choice Models Reference Manual}}.

{pstd} 
     The new commands are easier to use, but that is not the best part.
     The best part is that {helpb margins} now works after fitting
     choice models.  You can fit a model and produce results that
     you can interpret and explain to others.  You
     can answer questions such as, how would a $10,000 increase in
     income affect the probability that people take public transportation
     to work?  To learn more about interpretation, see 
     {manlink CM Intro 1}.

{pstd} 
     Do not panic.  Old commands continue to work under version control.
     You will want to use the new commands, however.

{pstd}
     You now {helpb cmset} your data before fitting a choice model.
     You type, for instance,

               {cmd:. cmset personid transportmethod}

{pstd}
     The same datasets that previously worked for fitting choice models
     still work.  They have multiple observations per person or case, and 
     each observation represents a possible choice.  You just have to 
     {cmd:cmset} the data before fitting the model.

{pstd}
     Here are the commands for fitting choice models:

{p2line}
{p2col:Purpose}Old command{space 7}New command{p_end}
{p2line}
{p2col:conditional logit}{cmd:asclogit}{space 10}{helpb cmclogit}{p_end}
{p2col:mixed logit}{cmd:asmixlogit}{space 8}{helpb cmmixlogit}{p_end}
{p2col:multinomial probit}{cmd:asmprobit}{space 9}{helpb cmmprobit}{p_end}
{p2col:rank-ordered probit}{cmd:asroprobit}{space 8}{helpb cmroprobit}{p_end}
{p2col:rank-ordered logit}{cmd:rologit}{space 11}{helpb cmrologit}{p_end}
{p2col:panel-data mixed logit}---{space 15}{helpb cmxtmixlogit}{p_end}
{p2line}
         {it:Notes:}
            1.  {cmd:cmxtmixlogit} is new to Stata 16.
            2.  Old commands continue to work under version control.

{pstd}
        And here are the new commands you can use after setting your 
        data:
 
{p2line}
{p2col:Purpose}{space 18}New command{p_end}
{p2line}
{p2col 9 58 60 2:set the choice modeling data}{helpb cmset}{p_end}
{p2col 9 58 60 2:summaries by chosen alternatives}{helpb cmsummarize}{p_end}
{p2col 9 58 60 2:tabulate choice sets}{helpb cmchoiceset}{p_end}
{p2col 9 58 60 2:tabulate chosen alternatives}{helpb cmtab}{p_end}
{p2col 9 58 60 2:report on potential problems in data}{helpb cmsample}{p_end}
{p2line}
         {it:Notes:}
             1.  You can now use {helpb cm_margins:margins} after fitting a choice model.


{* ------------------------------------------------------------}{...}
{marker python}{...}
{title:Highlight 5. Python integration}

{pstd}
    You can now use the 
{browse "https://en.wikipedia.org/wiki/Python_(programming_language)":Python programming language} 
    from Stata.  You can use it from the command line, in do-files, and 
    in ado-files.  Visit {browse "https://www.python.org/"} to
    download Python if it is not already on your computer.

{pstd}
    Stata's relationship with Python is much like its relationship with
    Mata.  You can 

{p 8 11 2}
    1. Enter Python, use it interactively, and exit.

{p 8 11 2}
    2. Intermix single lines of Python code with Stata code.

{p 8 11 2}
    3. Embed Python code in ado-files in the same way that you embed 
       Mata code.

{pstd}
    To use Python interactively, type {cmd:python} and press Return.
    Use Python, and then type {cmd:end} to exit back to Stata:

             {cmd:. python}
             {cmd:>>> 2+2}
             {cmd:4}
             {cmd:>>> print("Hello world!)}
             {cmd:Hello World!}
             {cmd:>>> end}

             {cmd:. _}

{pstd}
     To intermix Python code with Stata code, use the 
     {cmd:python:} prefix command interactively, in do-files, or
     in ado-files:

             {cmd:. python: mypythonfunction(...)}

{pstd}
     You can also call Python scripts by using the {cmd:python}
     {cmd:script} command:

             {cmd:. python script myfile.py}

{pstd}
     Embed Python programs at the end of ado-files in the same way 
     you would embed Mata code: 

             {hline 40}{cmd:myprogram.ado}{hline 3}
             {cmd:*! version 1.0.0}
         
             {cmd:program myprogram}
             {cmd:        version 16}
             {cmd:        ...}
             {cmd:        ...}
             {cmd:        python: function1(...)}
             {cmd:        ...}
             {cmd:        python: function2(...)}
             {cmd:        ...}
             {cmd:end}

             {cmd:version 16}
             {cmd:python:}
             {cmd:def function1(...)}
             {cmd:    }{it:<code>}
             {cmd:    }{it:<code>}
             {cmd:    }{it:<code>}

             {cmd:def function2(...)}
             {cmd:    }{it:<code>}
             {cmd:    }{it:<code>}
             {cmd:    }{it:<code>}

             {cmd:end}
             {hline 40}{cmd:myprogram.ado}{hline 3}

{pstd}
     Python code can access and post results back into Stata and Mata.
     We provide the Stata Function Interface (SFI), a Python module for
     doing that.

{pstd} 
     Do we have to sell you on Python?  Lots of libraries are available
     for it, and you can use any of them with Stata.  You can draw
     3D graphs using Python.  You can import and use numerical libraries
     such as 
     {browse "https://en.wikipedia.org/wiki/NumPy":NumPy}
     and
     {browse "https://en.wikipedia.org/wiki/TensorFlow":TensorFlow}.

{pstd}
      See {manhelp python P} and see 
      {browse "https://www.stata.com/python/api16/":Stata's Python API documentation}.


{* ------------------------------------------------------------}{...}
{marker bayes}{...} 
{title:Highlight 6. Bayes: Multiple chains, predictions, and more}

{pstd}
    Here is a summary of the new features.

    {hline 73}
      {bf:Option or command      Purpose}
    {hline 73}
    1. {cmd:nchains({it:#})} option     fit models using {help whatsnew15to16##bbchains:multiple chains} and report
                             maximum of Gelman-Rubin convergence diagnostic

    {hline 73}
    2. {helpb bayesstats grubin}     report {help whatsnew15to16##bbgr:Gelman-Rubin convergence diagnostic}
                             for each model parameter after estimation

    {hline 73}
    3. {helpb bayespredict}          calculate {help whatsnew15to16##bbpred:Bayesian predictions} for outcomes 
                             and functions of them, and save them in a new 
                             Stata dataset

                             dataset contains {it:N}*{it:m} obs.
                                 {it:N} = {it:#} of obs. in estimation data 
                                 {it:m} = {it:#} of simulated draws

    {hline 73}
    {it:After running (3), you may obtain the following for predictions:}

    4. {helpb bayesgraph}            {help whatsnew15to16##bbpost:graphical summaries}
       {helpb bayesstats ess}        {help whatsnew15to16##bbpost:effective sample sizes} & related
       {helpb bayesstats summary}    {help whatsnew15to16##bbpost:posterior summary statistics}
       {helpb bayestest interval}    {help whatsnew15to16##bbpost:interval hypothesis testing}

    {hline 73}
    5. {helpb bayespredict} again    {help whatsnew15to16##bbpostsum:posterior summaries of simulated values}, such
                             as mean, median, or credible intervals, which
                             are added as new variables to estimation data

    {hline 73}
    6. {helpb bayesreps}             {help whatsnew15to16##bbmcmc:MCMC replicates} of Bayesian predictions (random
                             sample from all simulated draws) added as new 
                             variables in estimation data 
                         
    {hline 73}
    7. {helpb bayesstats ppvalues}   goodness-of-fit {help whatsnew15to16##bbppp:posterior predictive p-values}

    {hline 73}


{marker bbchains}{...}
    {bf:1. Multiple chains}

{pstd}
    Has the Markov Chain Monte Carlo (MCMC)
    converged?  Has it fully explored the target posterior
    distribution?  Or do you need more simulations?  New option
    {cmd:nchains(}{it:#}{cmd:)} will help answer those questions.  Type 

        {cmd:. bayes, nchains(4): regress y x1 x2}

{pstd}
    and four chains will be produced, in this case for Bayesian regression of
    {cmd:y} on {cmd:x1} and {cmd:x2}.  The chains will be compared and the
    Gelman-Rubin convergence diagnostic reported.  And the chains will be
    combined to produce a more accurate final result.  The intent is that you
    check the reported diagnostic before interpreting the results.

{pstd}
    {cmd:nchains()} may be used with the {helpb bayes:bayes:} prefix
    and the {helpb bayesmh} command.


{marker bbgr}{...}
    {bf:2. Gelman-Rubin convergence diagnostic}

{pstd}
   The diagnostic we just told you about is in fact the maximum of the
   Gelman-Rubin convergence diagnostics, which are calculated for each
   model parameter.  When the maximum diagnostic suggests
   nonconvergence, you can look at the individual diagnostics to
   discover which parameters have convergence problems.  Type

        {cmd:. bayesstats grubin}

{pstd}
    Sometimes nonconvergence arises because you did not run enough
    simulations.  Other times, it is because of inherent problems with
    the model's specification.  If you run more simulations without 
    convergence and the same parameters keep being identified as 
    problematic, you need to think about respecifying your model.

{pstd}
    Use the new {helpb bayesstats grubin} command after fitting the
    model with {helpb bayes:bayes, nchains():} or 
    {helpb bayesmh:bayesmh ..., nchains()}.


{marker bbpred}{...}
    {bf:3. Bayesian predictions}

{pstd}
    Bayesian predictions are simulated values (or, more generally, functions
    of the simulated values) from the posterior predictive distribution.  New
    command {helpb bayespredict} computes these simulated values and saves
    them in a new Stata dataset.  First, you must fit a model.  Here is a
    Bayesian linear regression fit using {helpb bayesmh}:

{phang2}
        {cmd:. bayesmh y x1 x2, likelihood(normal({c -(}var{c )-}))}
        {cmd:                   prior({c -(}y:{c )-},  normal(0,100))}
        {cmd:                   prior({c -(}var{c )-}, igamma(1,2))}

{pstd}
    To compute simulated values for outcome 
    {cmd:y} and save them in {cmd:ysimdata.dta}, type 

        {cmd:. bayespredict {c -(}_ysim{c )-}, saving(ysimdata)}

{pstd}
    These simulated values can be used to perform model diagnostic
    checks.  Or, if you change the values recorded in {cmd:x1} and
    {cmd:x2} or add new values for them, to make forecasts.

{pstd}
    {cmd:bayespredict} can also produce functions of simulated values.
    To simulate minimums and maximums of simulated {cmd:y}, type

{phang2}
       {cmd:. bayespredict (ymin:@min({c -(}_ysim{c )-})) (ymax:@max({c -(}_ysim{c )-})),}
       {cmd:                                                   saving(yminmax)}

{pstd}
     These statistics can be used to compare the distributions of 
     the observed and simulated data.

{pstd}
     We used Mata's {cmd:max()} and {cmd:min()} functions.  We could
     have used other functions, or we could even write our own in Stata or Mata.

{pstd}
     New command {cmd:bayespredict} can be used after {cmd:bayesmh} 
     but not after prefix {cmd:bayes:}.


{marker bbpost}{...}
    {bf:4. Bayesian predictions with other postestimation commands}

{pstd}
   You may use Bayesian predictions produced by {cmd:bayespredict} with any of
   the following commands:

{p2line}
{p2col:Postestimation command}Purpose{p_end}
{p2line}
{p2col:{helpb bayesgraph}}graphical summaries{p_end}
{p2col:{helpb bayesstats ess}}effective sample sizes and related statistics{p_end}
{p2col:{helpb bayesstats summary}}posterior summary statistics{p_end}
{p2col:{helpb bayestest interval}}interval hypothesis testing{p_end}
{p2line}

{pstd}
    You can type, for example,

{phang2}
       {cmd:. bayespredict (ymin:@min({c -(}_ysim{c )-})) (ymax:@max({c -(}_ysim{c )-})),}
       {cmd:                                                   saving(yminmax)}

       {cmd:. bayesgraph histogram {c -(}ymin{c )-} {c -(}ymax{c )-} using yminmax}

{pstd}
     This produces histograms of the minimum and maximum values of
     simulated {cmd:y}.


{marker bbpostsum}{...}
    {bf:5. Posterior summaries of simulated outcomes}

{pstd}
    Sometimes, you do not need the full set of simulated values.  If you  want
    to predict the posterior mean of the outcome variable for each
    observation, the means of the simulated values will do.  That is relevant
    because you may have 10,000 or more simulated values for each observation
    in your estimation data.

{pstd}
    {cmd:bayespredict} can also produce posterior summaries of the simulated
    values.  That is of special interest because those values can be stored in
    your original data.  For instance, type 

        {cmd:. bayespredict pmean, mean}

{pstd}
     and new variable {cmd:pmean} will contain the posterior mean for
     each observation.  Type

        {cmd:. bayespredict pmedian, median}

{pstd}
     and new variable {cmd:pmedian} will contain the posterior median
     for each observation.  Type 

        {cmd:. bayespredict cri_l cri_u, cri}

{pstd}
     and new variables {cmd:cri_l} and {cmd:cri_u} will contain the 
     lower and upper 95% credible intervals for each observation.


{marker bbmcmc}{...}
    {bf:6. MCMC replicates}

{pstd}
    The new command {cmd:bayesreps} generates MCMC replicates
    and stores them in the current dataset.  These are a random 
    sample of the simulated values created when we previously typed 

        {cmd:. bayespredict {c -(}_ysim{c )-}, saving(ysimdata)}

{pstd}
   You may only need 100 replicates out of the entire sample
   {cmd:bayespredict} created, which might have 10,000 or more
   replicates per observation.  If so, you can type 

        {cmd:. bayesreps yrep*, nreps(100)}

{pstd} 
    This will create 100 new variables in your data, {cmd:yrep1} to
    {cmd:yrep100}.  You can use these variables to compare {cmd:y} with values
    predicted by the model, observation by observation.


{marker bbppp}{...}
    {bf:7. Posterior predictive p-values}

{pstd}
    Posterior predictive p-values are known as PPPs or Bayesian
    predictive p-values.  They are used to evaluate model goodness of
    fit.  PPPs are bounded by 0 and 1 and measure the agreement between
    the observed and the replicated data.

{pstd} New command {helpb bayesstats ppvalues} computes PPPs for the
predictions produced by {helpb bayespredict}.  For instance, we
previously simulated minimums and maximums for the outcome variable, 

{phang2}
       {cmd:. bayespredict (ymin:@min({c -(}_ysim{c )-})) (ymax:@max({c -(}_ysim{c )-})),}
       {cmd:                                                   saving(yminmax)}

{pstd}
    To obtain the corresponding PPPs, we type 

        {cmd: . bayesstats ppvalues {c -(}ymin{c )-} {c -(}ymax{c )-} using yminmax}

{pstd}
    In addition to other predictive summaries, the command reports the
    PPPs, which in this case are the proportions of simulated minimums
    and maximums that are larger than the observed ones.  The closer
    the proportions are to 0.5, the better the model fits the data.


{* ------------------------------------------------------------}{...}
{marker erms}{...}
{title:Highlight 7. ERMs for panel data}

{pstd}
    ERMs were a big new feature last release.  And now, we add a big new
    feature to ERMs this release.  You may remember that ERMs stands for
    "extended regression models".  ERMs is famous for two reasons: what it can
    do and
    {browse "https://blog.stata.com/2018/03/27/ermistatas-and-statas-new-erms-commands/":Ermistatas}, 
    the monster that appeared on the ERMs t-shirt.  One way to
    describe the new feature this release is that Ermistatas now has a
    fourth antenna.  More seriously, there are now {cmd:xt} versions of
    the ERM commands.

{pstd}
    {cmd:xt} is the Stata-command prefix for commands that
    handle estimation with panel data, also known as longitudinal data.
    What they handle is the correlation within panels.  Some handle it
    with random effects, others with fixed effects, and even others
    give you a choice.

{pstd}
    New commands 
    {helpb xteregress}, 
    {helpb xteprobit}, 
    {helpb xteoprobit}, and
    {helpb xteintreg}
    fit linear regression, probit, ordered probit,
    and interval regression models with panel data.
    They fit random-effects
    linear regression, probit, ordered probit,
    and interval regression models, and they allow the random effects to
    be correlated across equations!  And some of the equations can have no
    random effects at all if you wish.

{pstd}
    What can it do?  One hundred colleges have joined together to study the
    effects of high-school GPA on college GPA.  You lead the investigation.
    You expect that unobserved ability affects both GPAs, so you think that
    they are endogenous.  You also suspect that other unobserved
    characteristics of the colleges affect college GPA, but obviously not the
    high-school GPA.  So you want to put a random effect in the college-GPA
    equation but not the high-school GPA equation.

{pstd}
    That's your substantive problem, but you have a data problem too.
    You have a sample of 2,000 students who attended high school and
    one of the 100 colleges, but some of the college GPAs are
    missing.  They are missing because some students dropped out, or
    were kicked out, and either way, some of what caused that is
    endogenous.

{pstd}
    So you use Stata's new command {cmd:xteregress}.  You type 

{phang2}{cmd:. xteregress gpa income,}
        {cmd:endogenous(hsgpa = income i.hsprivate, nore)}
        {cmd:select(graduate = hsgpa income i.roommate i.program)}


{* ------------------------------------------------------------}{...}
{marker import}{...}
{title:Highlight 8. Import data from SAS and SPSS}

{pstd}
    Stata 16 has two new import commands for importing SAS and SPSS 
    datasets.

{pstd}
    {helpb import sas} imports files from SAS version 7 or higher.  It
    imports {cmd:.sas7bdat} data files, and it imports {cmd:.sas7bcat}
    value-label files.

{pstd}
    {helpb import spss} imports files SPSS version 16 or higher.
    It imports IBM SPSS Statistics files, meaning {cmd:.sav} and 
    {cmd:.zsav} files.

{pstd}
     Try using these new commands from their dialog boxes.  You
     can preview data and select the variables and observations you
     want to import.


{* ------------------------------------------------------------}{...}
{marker npse}{...}
{title:Highlight 9. Nonparametric series regression}

{pstd}  
   Stata 16's new {helpb npregress series} command fits nonparametric
   series regressions that approximate the mean of the dependent
   variable by using polynomials, B-splines, or splines of the covariates.
   Type

        {cmd:. npregress series  wineoutput  rainfall temperature i.irrigation}

{pstd}
    and {cmd:npregress series} fits the model 

         E(wineoutput) = g(rainfall, temperature, i.irrigation) 

{pstd}
    Instead of reporting coefficients, {cmd:npregress} {cmd:series}
    reports effects, meaning average marginal effects for continuous
    variables and contrasts for categorical variables.  The
    results might be that the average marginal effect of rainfall is 1
    and the contrast for irrigation is 2, which can be interpreted 
    as the average treatment effect of irrigation.

{pstd}
    Being a nonparametric regression, the unknown mean is 
    approximated by a series function of the covariates.  And yet
    we can still obtain the inferences that we could from a
    parametric model.  We just use {cmd:margins}.  We could type

        {cmd:. margins irrigation, at(temperature=(40(10)90))}

{pstd}
    and obtain a table of the average effects of the level of irrigation 
    at 40, 50, ..., 90 degrees.  We could graph the result using 
    {cmd:marginsplot}.

{pstd}
    {cmd:npregress} can also fit partially parametric (semiparametric)
    models.  {cmd:npregress} can fit models such as

                  E(y) = g1(x1,x2) + g2(x3) + g(x4)
    and 
                  E(y) = g(x1,x2) + β₁x3 + β₂x3*x4

{pstd}
    See {manlink R npregress intro} to learn more about nonparametric series
    regression.


{* ------------------------------------------------------------}{...}
{marker frames}{...}
{title:Highlight 10. Frames: Multiple datasets in memory}

{pstd}
    In one way, nothing has changed.  If you type 

             {cmd:. use people}

{pstd} 
    {cmd:people.dta} is loaded into memory just as it would have been by
    previous releases of Stata.  You can use Stata 16 just as you always have used Stata,
    one dataset at a time.  In Stata 16, however, that dataset you just used
    was loaded into a frame, and you can have lots of frames.  Frames have
    names.  {cmd:people.dta} was loaded into the frame named {cmd:default}.
    Next try this: 

             {cmd:. frame create counties}
             {cmd:. frame counties: use counties}

{pstd}
    Now you have two datasets in memory!  File {cmd:people.dta} is in the
    frame named {cmd:default} and file {cmd:counties.dta} is in the frame
    named {cmd:counties}.  Your current frame is still {cmd:default},
    and most Stata commands use the data in the current frame.
    If you typed

             {cmd:. list}

{pstd}
    then {cmd:people.dta} would be listed.  If you typed

             {cmd:. frame counties: list}

{pstd}
    then {cmd:counties.dta} would be listed.  Or you could make
    {cmd:counties} the current frame by typing 

            {cmd:. frame change counties}
 
{pstd} 
    and now if you typed

             {cmd:. list}

{pstd} 
    then {cmd:county.dta} would be listed, and any other Stata command you
    typed would run on the data in frame {cmd:counties}.  When you wish, you
    can switch back to {cmd:default}:

            {cmd:. frame change default}

{pstd} 
    Imagine that {cmd:people.dta} -- the data in frame {cmd:default} --
    contains a variable called {cmd:countycode}, and imagine that
    {cmd:counties.dta} -- the data in frame {cmd:counties} -- also has a
    county-code variable, but it is named {cmd:cntycode}.  If the
    variables use the same encoding, be it string or numeric, we can
    link the observations in the two frames.  If we do, we will be able
    to access the variables stored in frame {cmd:counties} from the data
    in frame {cmd:default}.  To link the two frames, we type 

            {cmd:. frlink m:1 countycode, frame(counties cntycode)}

{pstd}
   But ignore that.  {cmd:frlink}'s syntax is simpler when the linkage
   variables have the same names, so try this on for size:

            {cmd:. frame county: rename cntycode countycode}
            {cmd:. frlink m:1 countycode, frame(counties)}

{pstd}
    Either way, each person in {cmd:default} is linked to the
    appropriate observation in {cmd:counties}; those
    who live in the same county will be linked to the same observation
    in {cmd:counties}.  Wait a minute!
    Frame {cmd:counties} contains counties, but
    frame {cmd:default} contains people?  Stata does not care, but that
    is just irritating if only because the inconsistency makes sentences
    ungainly.  We can fix that.

           {cmd:. frame rename default people}

{pstd}
    That is better.  {cmd:counties.dta} is in frame {cmd:counties},
    {cmd:people.dta} is in frame {cmd:people}, and frame {cmd:people} is
    linked to frame {cmd:counties}.  The linkage will be
    valid even if some people reside in the same county, even if there are
    counties in which no one in {cmd:people} live, and even if some people
    live in counties that are not defined in {cmd:counties}!

{pstd}
    That is what frames can do for you.  And a lot more.
    See {helpb frames intro:[D] frames intro}.


    {it:One more thing ...}

{pstd}
    Because of frames, ado-files that use {cmd:preserve} run faster
    with Stata/MP.  And you do not have to modify them!
    We rewrote {cmd:preserve} to secretly use frames, which means that when
    memory is available, datasets can be preserved in less than a blink
    of an eye.  And restored just as quickly.

{pstd}
    If you have lots of memory on your computer, you may want to change
    Stata's new {cmd:set} {cmd:max_preservemem} to a number larger than
    the default {cmd:1g}.  By default, once 1 gigabyte of memory is
    consumed preserving datasets, {cmd:preserve} reverts to its old
    behavior of saving datasets on disk.  See {manhelp preserve D}.
    

{* ------------------------------------------------------------}{...}
{marker ss}{...}
{title:Highlight 11. Sample-size analysis for confidence intervals}

{pstd}
    New command {helpb ciwidth} performs precision and sample-size
    (PrSS) analysis, which is sample-size analysis for confidence
    intervals (CIs).  The issue is to optimally allocate study
    resources when CIs are to be used for inference or, said
    differently, to estimate the sample size required to achieve the
    desired precision of a CI in a planned study.

{pstd}
    {cmd:ciwidth} produces sample sizes, precision, and more, that are 
    required for 

                CI for one mean
                CI for one variance

                CI for two independent means 
                CI for two paired means 

{pstd}
   An integrated GUI lets you select the analysis type and input
   assumptions to obtain desired results.

{pstd} 
    {cmd:ciwidth} allows results to be displayed in customizable tables
    and graphs.

{pstd}
    The {cmd:ciwidth} command also provides facilities for you to add
    your own methods.

{pstd}
    Power, precision, and sample size is the subject of its own manual.
    See {manlink PSS-3 Precision and sample-size analysis}.


{* ------------------------------------------------------------}{...}
{marker nonlinearDSGE}{...}
{title:Highlight 12. Nonlinear DSGE models}

{pstd}
    Stata's new {helpb dsgenl} command estimates the parameters of
    nonlinear dynamic stochastic general equilibrium (DSGE) models,
    in which models in our implementation can incorporate nonlinearities
    in both the parameters and the equations.  The model's
    solution is approximated with a first-order perturbation.
    Parameter estimation is then performed on the approximate model.

{pstd}
    You no longer have to linearize models by hand so that you can fit
    them with Stata's {cmd:dsge} command.  When you enter equations
    into {cmd:dsgenl}, it linearizes them for you.  A model could
    include the equation

        {cmd:. dsgenl (1 = {beta}*(f.c/c)*(1+r-{delta}) ...}

{pstd}
    The above is a Euler equation.  The variables are

                  {cmd:c}    consumption 
	          {cmd:r}    interest rate 

{pstd}
    and {cmd:{c -(}beta{c )-}} and {cmd:{c -(}delta{c )-}} are
    the parameters to be estimated.
    This equation might appear in the following model: 

{phang2}
        {cmd:. dsgenl (  1 = {beta}*(f.c/c)*(1+r-{delta})}
                 {cmd:(f.r = {rho}*r + (1-{rho}), observed(c) exostate(r)}

{pstd}
    Postestimation commands {cmd:estat} {cmd:policy} and {cmd:estat}
    {cmd:transition} report policy and transition matrices just as they
    do after estimating models with the linear {cmd:dsge} command.

{pstd}
    {helpb estat policy} reports the model's control variables as linear
    functions of the state variables.

{pstd}
    {helpb dsge estat transition:estat transition} reports how the state
    variables evolve over time.

{pstd}
    New is {helpb estat steady}.  It displays the model's steady-state,
    which is where the model's variables eventually come to rest after
    a shock.

{pstd}
    Also new is {helpb dsge estat covariance:estat covariance}.  It displays
    variances, covariances, and autocovariances of variables implied by the
    system of equations.

{pstd}
    And of course, you can use the existing {cmd:irf} commands to
    create and display impulse-response functions.

{pstd}
     See {manlink DSGE Intro 1} and {manhelp dsgenl DSGE}.


{* ------------------------------------------------------------}{...}
{marker irt}{...}
{title:Highlight 13. Multiple-group IRT}

{pstd}
    Stata's {cmd:irt} command now handles multiple-group analysis.
    Take any of the existing {cmd:irt} commands, add a
    {cmd:group(}{varname}{cmd:)} option, and it fits the
    corresponding multiple-group model.

{pstd}
    {cmd:irt} fits 1-, 2-, and 3-parameter logistic models.  It fits
    graded response, nominal response, partial credit, and rating scale
    models, and any combination of them.  And it can graph
    item characteristic curves, test characteristic curves, item
    information functions, and test information functions.

{pstd}
    Item difficulty and discrimination is estimated in IRT analysis,
    and a latent variable represents the unobserved trait the items are
    intended to measure.  Only the variance of the unobserved trait
    can be estimated when there is one group.

{pstd}
    Group-specific means and variances will be estimated.
    Group-specific difficulty and discrimination of the items can also 
    be estimated with multiple-group data, or they can be constrained 
    to be equal across groups.  Or they can be constrained however you
    please.  {cmd:irt}'s new {cmd:constraints} option allows you to
    specify which parameters are to be constrained to be equal across
    groups and which are not.

{pstd}
    Likelihood-ratio tests are also available and provide an 
    IRT model-based approach for testing differential item function.

{pstd}
    See {manhelp irt_group IRT:irt, group()},
        {manhelp irt_constraints IRT:irt constraints}, and
	{manhelp estat_greport IRT:estat greport}.


{* ------------------------------------------------------------}{...}
{marker pdsel}{...}
{title:Highlight 14. xtheckman: Panel data selection models}

{pstd}
    Stata 16 now fits panel-data Heckman selection models.
    Heckman selection handles situations where some outcomes are missing
    and this missingness is not at random.  You want to fit the model

         {it:y}ᵢₜ = {bf:x}ᵢₜ{bf:β} + αᵢ + {it:e}ᵢₜ

{pstd}
    where yᵢₜ is sometimes missing.  The equation that determines
    which yᵢₜ are observed (which are not missing) is

         {it:y}ᵢₜ observed = ({bf:z}ᵢₜ{bf:γ} + {it:v}ᵢ + {it:u}ᵢₜ > 0)

{pstd}
    In these equations, αᵢ, {it:e}ᵢₜ, {it:v}ᵢ, and {it:u}ᵢₜ
    are unobserved and will not be estimated.  Their correlations,
    however, will be estimated along with {bf:β} and {bf:γ}.

{pstd}
    Classical Heckman selection was developed for cross-sectional data
    and concerned correlation in the residuals.  In the panel-data
    extension, those residuals still exist, but we model them as random
    effects αᵢ and {it:v}ᵢ.

{pstd}
    Consider a model where yᵢₜ is wage and the
    selection effect is whether individuals are employed.  In panel
    data, outcomes can change over time, and so can missingness.
    Person 22 might be employed at times 1 and 2, unemployed at time 3,
    and employed again at time 4.

{pstd}
    In this example, we can plausibly argue that αᵢ is unobserved
    wage-related ability.  We can also argue that {it:v}ᵢ is
    job-related ability.  If they are correlated, we have endogenous
    sample selection.  We can test for that.  If it is significant and
    the correlation is positive, then those who do not work would earn
    less than those who do.  If it is negative, they would earn more.

{pstd}
    See {manhelp xtheckman XT}.


{* ------------------------------------------------------------}{...}
{marker pharmo}{...}
{p 0 0 2}{bf:{ul:Highlight 15. Nonlinear multilevel models with lags, and more: Multiple-dose PK models}}

{pstd}
    Existing command {helpb menl} has new features for fitting nonlinear
    multilevel models that may include the lag, lead (forward), and difference
    operators.  One important class of such models are pharmacokinetic (PK)
    models.  PK models concern drug absorption, distribution,
    metabolism, and excretion.  Single-dose and multiple-dose models are
    of special interest.  Each comes in two flavors distinguished by
    how long it takes the drug to enter the body: orally or intravenously.
    {cmd:menl} can fit all those models.

{pstd}
    Here is how you would use {cmd:menl} to fit a one-compartment open model
    (1-COM) with intravenous administration of multiple doses
    and first-order elimination.  1-COM models treat bodies as singular
    homogeneous volumes.  Inject the drug and mixing is instantaneous.
    First-order elimination assumes that after each injection, the
    concentration of the drug declines exponentially.  To fit the
    model, type

{phang2}
         {cmd:. menl conc = dose/{V:} + L.{conc:}*exp( -{Cl:}/{V:}*D.time ),}
                {cmd:define(Cl: {cl:weight} * weight * exp({U1[subject]}))}
                {cmd:define( V: {v:weight} * weight *}
                           {cmd:( 1+{c -(}v:apgar{c )-}*1.fapgar ) * exp( {c -(}U2[subject]{c )-}) )}
                {cmd:tsinit({conc:} = dose/{V:})}
                {cmd:tsmissing}
                {cmd:tsorder(time)}

{pstd}
    {cmd:menl}'s new features can also be used to fit other models, such
    as certain growth and time-series nonlinear multilevel models.  See
{mansection ME menlRemarksandexamplesTime-seriesoperators:{it:Time-series operators}}
    and 
{mansection ME menlRemarksandexamplesMultiple-dosepharmacokineticmodeling:{it:Multiple-dose pharmacokinetic modeling}}
    in {bf:[ME] menl}.


{* ------------------------------------------------------------}{...}
{marker hetoprobit}{...}
{title:Highlight 16. Heteroskedastic ordered-probit models}

{pstd}
    Heteroskedastic ordered probit now joins the ordered-probit models
    that Stata previously fit.  Ordered-probit models are a
    generalization of probit models from binary to multiple-ordered
    outcomes.  Think of a three-valued outcome.  Outcomes are "poor" if
    {bind:{it:z} ≤ -1.1}, "good" if {bind:-1.1 < {it:z} ≤ 1}, and
    "excellent" if {bind:{it:z} > 1}, where

               {it:z} = {bf:X}{bf:β} + {it:u}

{pstd}
    and {it:u} is N(0,1).

{pstd}
    Stata's new {cmd:hetoprobit} command lets you model the variance of {it:u} to be 
    a function of the same or other covariates.  With probit,
    heteroskedasticity cannot be ignored.  Results will be wrong if it is.

{pstd}
    Heteroskedastic ordered probit is used when different subjects have 
    different variances.  See {manhelp hetoprobit R}.


{* ------------------------------------------------------------}{...}
{marker sizes}{...}
{title:Highlight 17. Graph sizes in printer points, inches, or centimeters}

{pstd}
    Graphics commands now allow specifying sizes in printer points,
    inches, or centimeters.  Specify {cmd:12pt}, {cmd:1in}, or
    {cmd:1.4cm}.  You can use the units for text sizes, marker sizes,
    margins, line thicknesses, line spacing, gaps, etc.  You can use
    them for all sizes except those that are explicitly relative
    to another object in the graph.

{pstd}
    See {manhelpi size G-4}.


{* ------------------------------------------------------------}{...}
{marker numinteg}{...}
{title:Highlight 18. Numerical integration}

{pstd}
     Mata's new {cmd:Quadrature} class numerically integrates {it:y}
     = f({it:x}), {it:y} and {it:x} scalars, over the interval {it:a}
     to {it:b}, where {it:a} may be minus infinity or finite and {it:b}
     may be positive infinity or finite.  The integral is approximated
     using adaptive quadrature.

{pstd}
     See {helpb mf_quadrature:[M-5] Quadrature()}.
  

{* ------------------------------------------------------------}{...}
{marker lp}{...}
{title:Highlight 19. Linear programming}

{pstd}
    Mata's new {cmd:LinearProgram} class solves linear programs 
    using an interior-point method.  It minimizes or maximizes 
    a linear objective function subject to linear constraints
    (equality, inequality) and boundary conditions.

{pstd}
    See {helpb mf_linearprogram:[M-5] LinearProgram()}.


{* ------------------------------------------------------------}{...}
{marker korean}{...}
{title:Highlight 20. Stata in Korean}

{pstd}
이제 Stata는 한국어를 제공합니다.

{pstd}
더 이상 무슨말이 필요하겠습니까?

{pstd}
StataCorp는 Stata 한국 공식 유통 업체인 JasonTG의 노력에 감사드립니다.


{* ------------------------------------------------------------}{...}
{marker dofileed}{...}
{title:Highlight 21. Do-file Editor updates}

{pstd}
    Stata's Do-file Editor lets you edit do-files, ado-files, and Mata
    code.  In Stata 16, it also lets you edit Python code, and it lets 
you edit Markdown files to automate reports.

{pstd}
    Stata's Do-file Editor still provides syntax highlighting for Stata.
    In Stata 16, it also provides syntax highlighting
    for the Python and Markdown languages.

{pstd}
    And Stata 16's Do-file Editor has autocompletion.  The
    Editor autocompletes words that already exist in the document,
    autocompletes Stata commands, and autocompletes quotes, parentheses,
    braces, and brackets.

{pstd}
    Last, but not least, you can now use spaces for indentation as well as
    tabs.


{* ------------------------------------------------------------}{...}
{marker mac}{...}
{title:Highlight 22. Mac interface updates}

{pstd}
    Stata for Mac now supports Dark Mode, that is, bright text on dark backgrounds.
    
{pstd}
    Stata for Mac also now supports native tabbed windows, which allows
    combining most of Stata's windows into one window and is
    ideal for the smaller displays of laptops.


{* ------------------------------------------------------------}{...}
{marker matsize}{...}
{title:Highlight 23. Set matsize obviated}

{pstd}
    Forget {cmd:set} {cmd:matsize}.  You no longer have to set it to 
    create large Stata matrices or to fit models with lots of covariates.

{pstd}
    The maximum size of Stata matrices allowed is now

          Stata/IC           800 x 800         (unchanged)
          Stata/SE        11,000 x 11,000      (unchanged)
          Stata/MP        65,534 x 65,534      (new)

{pstd}
    Meanwhile, the maximum size of Mata matrices remains unchanged.
    Matrices may be 

          Stata/IC         {it:r} x {it:c};  {it:r}, {it:c} < 2 billion 
          Stata/SE         {it:r} x {it:c};  {it:r}, {it:c} < 2 billion 
          Stata/MP         {it:r} x {it:c};  {it:r}, {it:c} < 1 trillion  

{pstd}
    The maximum-sized matrices you can create, Stata or Mata,
    depends on memory being available on your computer.
{p_end}


{marker NewStat}{...}
{title:1.3.2  What's new in statistics (general)}

{p 5 8 2}
    1. {it:{help whatsnew15to16##hetoprobit:Highlight of the release}}.

{p 8 8 2}
       {helpb hetoprobit}, the new estimation command for fitting 
       heteroskedastic ordered-probit models,
       lets you model the variance of {it:u} to be 
       a function of the same or other covariates.
{p_end}

{p 5 8 2}
    2. Existing command {helpb ranksum} has new option {cmd:exact}
       to specify that exact p-values be computed for the Wilcoxon
       rank-sum test.


{p 5 8 2}
    3. Existing command {helpb signrank} has new option {cmd:exact}
       to specify that exact p-values be computed for the Wilcoxon
       signed-rank test.

{p 5 8 2}
    4. Estimation commands {helpb mean}, {helpb proportion}, 
       {helpb ratio}, and {helpb total} now allow factor-variable
       notation.  Old behavior is preserved under version control.
       We mention that despite factor variables being a superset of
       varlists because variables in {cmd:over()} are now interacted,
       which they always were, but the use of factor variables changes
       (improves) the names under which results are stored.  Old 
       result names are preserved under version control.

{p 8 8 2}
       In addition,

{p 11 14 2}
           a. Empty cells identified with unobserved level combinations
              of variables in the {cmd:over()} option are kept or
              dropped according to {helpb set emptycells}.

{p 11 14 2}
           b. {cmd:mean}, {cmd:proportion}, {cmd:ratio}, and {cmd:total} 
              can now be used with the postestimation commands
              {helpb contrast}, {helpb pwcompare}, and {helpb marginsplot}.

{p 5 8 2}
    5. The new setting {helpb set iterlog} controls whether estimation 
       commands display iteration logs.  The setting defaults to {cmd:on}.
       Type {cmd:set} {cmd:iterlog} {cmd:off} to turn it off.  Type
       {cmd:set} {cmd:iterlog} {cmd:off,} {cmd:permanently} to turn it
       off in future sessions as well.

{p 8 8 2}
       The setting also affects user-written estimation commands that
       use Mata's optimization functions 
       {helpb mf moptimize:moptimize()}, 
       {helpb mf optimize:optimize()}, and
       {helpb mf solvenl:solvenl()}.

{p 8 8 2}
        New {help creturn:c-return} result {cmd:c(iterlog)} returns 
        the current setting.

{p 5 8 2}
     6. The new setting {helpb set dots} controls whether dots are 
        reported each time statistics are computed from a sample or 
        resample of a dataset by the commands 
	{helpb bootstrap}, {helpb jackknife}, 
	{helpb permute}, {helpb rolling}, {helpb simulate}, 
        {helpb statsby}, {helpb svy bootstrap}, {helpb svy brr}, 
	{helpb svy jackknife}, {helpb svy sdr}, and {helpb threshold}.

{p 8 8 2}
        The setting defaults to {cmd:on}.  Type {cmd:set} {cmd:dots}
        {cmd:off}[{cmd:,} {cmd:permanently}] to turn it off.

{p 8 8 2}
        New {help creturn:c-return} result {cmd:c(dots)} returns the
        current setting.

{p 5 8 2}
     7. New postestimation command {helpb estimates selected}
        displays a table about the coefficients from one or more
        estimation commands.  The table shows which coefficients were
        estimated in each model and, optionally, the values of the
        coefficients.  Results may be sorted based on the values of
        the estimated coefficients or variable names.

{p 5 8 2}
     8. Factor-variable varlists now allow interactions of up to 
        64 continuous variables per term.  See {manhelp limits R}.

{p 5 8 2}
     9. Existing command {helpb summarize} no longer 
        assigns a default base level for factor variables when one is
        not specified.  Previous behavior is preserved under version
        control.

{p 4 8 2}
    10. {helpb cpoisson}, the existing estimation command for fitting
        censored Poisson models, required
        that lower and upper censoring limits be specified in options
        {cmd:ll(}{it:#}{cmd:)} and {cmd:ul(}{it:#}{cmd:)}.  New options
        {cmd:ll} and {cmd:ul} are now allowed that do not require the 
        censoring limit to be specified.  {cmd:ll} specifies that the 
        censoring limit is the minimum of the dependent variable;
        {cmd:ul} specifies that it is the maximum.
  
{p 4 8 2}
    11. Existing postestimation command {helpb estimates stats}
        has new option {cmd:bicdetail} that produces a table showing 
        the type of N used in the BIC calculation.  Most estimation
        commands use the number of observations in the estimation
        sample for the BIC for N, although other values, such as 
        the number of cases in choice models,
        are sometimes used.  When the default table of
        {cmd:estimates} {cmd:stats} contains more than one type of N,
        specifying {cmd:bicdetail} allows you to differentiate the 
        type of N used for the calculation of the BIC.

{p 4 8 2}
    12. The following estimation commands now post scalar
        {cmd:e(N_ic)}, used by {cmd:estimates stats} and 
        {cmd:estat ic} for calculating information criterion
        statistics AIC and BIC:

              {helpb cmclogit}
              {helpb cmmixlogit}
              {helpb cmmprobit}
              {helpb cmrologit}
              {helpb cmroprobit}
              {helpb cmxtmixlogit}
              {helpb menl}
              {helpb nlogit}

{p 8 8 2}
        Estimation command {helpb xtgls} posts scalars {cmd:e(N_ic)}
        and {cmd:e(df_ic)}, which are used by {cmd:estimates stats} and
        {cmd:estat ic} for calculating the AIC and BIC.

{p 4 8 2}
    13. The free parameters in {helpb ivprobit} and {helpb ivtobit} --
        Stata's existing estimation commands to fit instrumental-variables
        probit and tobit models -- now have better names:

            {hline 60}
            Old name        New name     Meaning
            {hline 60}
            {cmd:lnsigma}{it:#}{cmd::_cons}  {cmd:/:lnsigma}{it:#}   log std. dev. 
            {cmd:athrho}{it:#}{cmd:_}{it:#}{cmd::cons}  {cmd:/:athrho}{it:#}{cmd:_}{it:#}  inv. hyper. tangent correlation
            {hline 60}

{p 4 8 2}
    14. {helpb margins} now assumes option {cmd:nose} (no standard
        errors) when used with
        estimation results that do not contain matrix variance estimates.
        If option {cmd:vce()} is specified, {cmd:margins} now exits
        with error message 
        "{error:option {bf:vce(...)} not allowed}".

{p 4 8 2}
    15. {helpb tnbreg}, the existing estimation command for fitting 
        truncated negative binomial models, now runs faster and computes
        standard errors more accurately.  These improvements are the
        result of implementing more-accurate numerical derivatives in
        the calculation of the gradient and Hessian.

{p 4 8 2}
     16. {helpb hetprobit}, the existing estimation command to fit 
         heterogeneous probit models, 
         incorrectly labeled the log standard deviation as
         {bf:lnsigma2}.  It now uses the correct label {bf:lnsigma}.  The
         old label is available under version control.


{marker NewME}{...}
{title:1.3.3  What's new in statistics (multilevel)}

{p 5 8 2}
    1. {it:{help whatsnew15to16##pharmo:Highlight of the release}}.

{p 8 8 2}
       {helpb menl} is Stata's existing estimation command for fitting
       nonlinear mixed-effects models.
       It has been extended for fitting the models that include lag, lead
       (forward), and difference operators, such as multiple-dose
       pharmacokinetic models. Specifically,
{p_end}

{p 8 11 2}
        a. {cmd:menl} supports time-series operators in variable lists
           and expressions; see {mansection ME menlRemarksandexamplesTime-seriesoperators:{it:Time-series operators}} in {bf:[ME] menl}.

{p 8 11 2}
        b. {cmd:menl} provides new specification
           {cmd:L.{c -(}}{it:depvar}{cmd::{c )-}} or, equivalently,
           {cmd:L._yhat} to include the lagged predicted mean function in
           your expression. More generally, you can use the one-period lag
           with any named expression {it:name},
           {bf:L.{c -(}}{it:name}{bf::{c )-}}.  These features are useful
           for fitting pharmacokinetic models that involve multiple-dose
           applications for each subject; see
           {mansection ME menlRemarksandexamplesMultiple-dosepharmacokineticmodeling:{it:Multiple-dose pharmacokinetic modeling}} in {bf:[ME] menl}.

{p 8 11 2}
        c. {cmd:menl} has new options:

{p 11 11 2}
	  {opt tsorder(timevar)} specifies the time variable that determines
	  the time order for time-series operators used in expressions.  This
	  may be a convenient alternative to {helpb tsset}ing your time-series
          data.

{p 11 11 2}
	  {cmd:tsinit({c -(}}{it:name}{cmd::{c )-}=}<{it:resubexpr}>{cmd:)}
	  specifies initial conditions for any lagged named expression
	  {bf:L.{c -(}}{it:name}{bf::{c )-}} and for the lagged mean prediction
          function {bf:L.{c -(}}{it:depvar}{bf::{c )-}}.

{p 11 11 2}
	  {cmd:tsmissing} specifies that observations containing system missing
	  values ({cmd:.}) in the dependent variable be retained in the
	  computation when a lagged named expression
	  {bf:L.{c -(}}{it:name}{bf::{c )-}} is used in the model
	  specification.  This option is often used when subjects have
	  intermittent {it:depvar} measurements and the lagged predicted mean
	  function {bf:L.{c -(}}{it:depvar}{bf::{c )-}} is included in the
	  model specification.  This is common for some multiple-dose
          pharmacokinetic models; see
          {mansection ME menlRemarksandexamplesMultiple-dosepharmacokineticmodeling:{it:Multiple-dose pharmacokinetic modeling}} in {bf:[ME] menl}.

{p 11 11 2}
	  {cmd:notsshow} suppresses the ts setting information from the output.

{p 5 8 2}
    2. {helpb menl} supports two new within-group error structures,
               Toeplitz and banded:

{p 8 11 2}
            a. Options {cmd:rescovariance()} and {cmd:rescorrelation()}
               now support structure {bind:{cmd:toeplitz} {it:#}} for fitting
               models in which within-group errors have Toeplitz structure of
               order {it:#}.

{p 8 11 2}
            b. Options {cmd:rescovariance()} and {cmd:rescorrelation()} now
               support structure {bind:{cmd:banded} {it:#}} for fitting
               models in which within-group errors have a banded structure of
               order {it:#}.  This is a special case of an unstructured
               covariance (or correlation) matrix in which only the
               covariances (or correlations) within the first {it:#}
               off-diagonals are estimated and the covariances (or
               correlations) outside this band are set to 0.

{p 5 8 2}
    3. {helpb menl} has new option {cmd:lrtest} that reports a
       likelihood-ratio test comparing the nonlinear mixed-effects
       model with the model fit by ordinary nonlinear regression.

{p 5 8 2}
    4. Postestimation commands 
       {helpb predict} and {helpb estat wcorrelation}
       after {cmd:menl} now allow options 
       {opt nrtolerance(#)} and {cmd:nonrtolerance}.
        See "{mansection ME menlMethodsandformulasstopping_rules:Stopping rules}"
       in {bf:[ME] menl}.


{marker NewBAYES}{...}
{title:1.3.4  What's new in statistics (Bayesian)}

{p 5 8 2}
  1. {it:{help whatsnew15to16##bayes:Highlight of the release}}.

{p 8 8 2}
     Stata 16 includes 
     extensive additions to Stata's Bayesian 
     suite of commands, which include 

{col 12}{it:{help whatsnew15to16##bbchains:Multiple chains}}
{col 12}{it:{help whatsnew15to16##bbgr:Gelman-Rubin convergence diagnostics}} 
{col 12}{it:{help whatsnew15to16##bbpred:Bayesian predictions}} 
{col 12}{it:{help whatsnew15to16##bbpostsum:Posterior summaries of simulated values}}
{col 12}{it:{help whatsnew15to16##bbmcmc:MCMC replicates}}
{col 12}{it:{help whatsnew15to16##bbppp:Posterior predictive p-values}}

{pmore}
and more.  See below for details.
{p_end}

{p 5 8 2}
2. {bf:Multiple chains}.  Multiple Markov chains are commonly used to check
   convergence of Markov chain Monte Carlo (MCMC) and to improve precision of
   parameter estimates.  Stata's Bayesian suite now supports multiple chains.
   Specifically,
{p_end}

{p 8 11 2}
            a. {helpb bayesmh} and {helpb bayes} have new option
               {opt nchains()} for simulating multiple Markov chains; see
               {mansection BAYES bayesmhRemarksandexamplesConvergencediagnosticsusingmultiplechains:{it:Convergence diagnostics using multiple chains}}
                 in {bf:[BAYES] bayesmh}.

{p 8 11 2}
            b. {helpb bayesstats_grubin:bayesstats grubin} is a new 
               {help bayesian_postestimation:Bayesian postestimation}
               command for checking MCMC convergence using multiple Markov
               chains.  It computes Gelman-Rubin convergence statistics and
               their upper confidence limits for each model parameter.  MCMC
               convergence is declared whenever all convergence statistics
               are within a certain threshold.  See
               {mansection BAYES bayesstatsgrubinRemarksandexamplesGelman--Rubinconvergencediagnostic:{it:Gelman-Rubin convergence diagnostic}}
                 in {bf:[BAYES] bayesstats grubin}.

{p 8 11 2}
            c. {helpb bayesmh} and {helpb bayes} have new option
               {cmd:init}{it:#}{cmd:()} for specifying initial values for
               model parameters for the {it:#}th chain.  These commands also
               have new option {cmd:initall()} for specifying initial
               values for model parameters for all chains.

{p 8 11 2}
            d. {helpb bayesmh} and {helpb bayes} have new option
               {cmd:chainsdetail} for displaying the simulation summary
               separately for each Markov chain.

{p 8 11 2}
            e. {helpb bayesstats_summary:bayesstats summary}, 
               {helpb bayesstats_ess:bayesstats ess}, 
               {helpb bayesstats_ic:bayesstats ic}, 
               {helpb bayestest_interval:bayestest interval}, and 
               {helpb bayestest_model:bayestest model} have new options
               {cmd:chains()} and {cmd:sepchains}.  {cmd:chains()} specifies
               which chains to use for calculating the results.
               {cmd:sepchains} specifies that the results be calculated
               separately for each chain.  By default, all chains are used to
               calculate the results.

{p 8 11 2}
            f. {helpb bayesgraph:bayesgraph} supports the following new
               options to plot results from multiple simulated chains:
               {cmd:chains()}, {cmd:sepchains}, {cmd:bychain()},
               {cmd:chainopts()}, {cmd:chain}{it:#}{cmd:opts()}, and
               {cmd:chainslegend}.  By default, the first 10 chains are
               plotted on one graph.  You can use option {cmd:chains()} to
               plot all chains or to select which chains to plot.  You can
               use option {cmd:sepchains} to plot each chain on a separate
               graph or option {cmd:bychain()} to plot chains as separate
               subgraphs on one graph.  You can use options
               {cmd:chainopts()} and {cmd:chain}{it:#}{cmd:opts()} to modify
               the look of all chains and of the {it:#}th chain.  Finally,
               you can use option {cmd:chainslegend} to show legend keys
               corresponding to chain numbers, which are not displayed by
               default.  See
               {mansection BAYES bayesgraphRemarksandexamplesUsingbayesgraph:{it:Using bayesgraph}}
	       in {bf:[BAYES] bayesgraph}.

{p 5 8 2}
3. {bf:Bayesian predictions}.  In Bayesian analysis, simulating samples from
   the posterior predictive distribution of outcome variables has important
   applications for model checking and for forecasting at new data points.
   Stata now provides Bayesian predictions for models fit using the 
   {helpb bayesmh} command.  Specifically,
{p_end}

{p 8 11 2}
            a. {helpb bayespredict:bayespredict} is a new
               {help bayesian_postestimation:Bayesian postestimation}
               command for generating Bayesian predictions.
               It can be used to simulate outcomes from their
               posterior predictive distributions.
               You can also use it to obtain functions and posterior
               summaries of simulated outcomes.  All Bayesian predictions
               generated by {helpb bayespredict} can be used as input
	       parameters in many other
	       {help bayesian_postestimation:Bayesian postestimation}
	       commands, such as {helpb bayesstats_summary:bayesstats summary}
               and {helpb bayesstats_ess:bayesstats ess}.  See
{mansection BAYES bayespredictRemarksandexamplesOverviewofBayesianpredictions:{it:Overview of Bayesian predictions}}
               in {bf:[BAYES] bayespredict}.

{p 8 11 2}
            b. {helpb bayespredict:bayesreps} is a new
               {help bayesian_postestimation:Bayesian postestimation}
               command that obtains a smaller random MCMC subsample of
               simulated outcomes from the entire MCMC sample and saves them
               in the current data.  This command is useful when you want to
               compare the distribution of simulated outcomes with the
               observed one using various numerical and graphical summaries.

{p 8 11 2}
            c. {helpb bayesstats_ppvalues:bayesstats ppvalues} is a new
               {help bayesian_postestimation:Bayesian postestimation}
               command for calculating posterior predictive p-values
               for test statistics of replicated outcomes simulated by 
               {helpb bayespredict}.  These posterior p-values can be
               used to assess model goodness of fit.  Lack of fit is declared
               whenever these values are close to 0.  See 
               {manhelp bayesstats_ppvalues BAYES:bayesstats ppvalues}.

{p 8 11 2}
            d. {helpb bayesgraph:bayesgraph},
               {helpb bayesstats_summary:bayesstats summary},
               {helpb bayesstats_ess:bayesstats ess}, and
               {helpb bayestest_interval:bayestest interval} allow you to
               produce graphical summaries, compute posterior summaries and
               effective sample sizes, test hypotheses, and more for
               simulated outcomes and other Bayesian predictions obtained
               from {helpb bayespredict}.  This is facilitated by the new
               {bind:{cmd:using} {it:predfile}} specification with these
               commands.

{p 5 8 2}
   4. Prefix command {helpb bayes:bayes:} now supports
      the new {helpb hetoprobit} command so that you can fit Bayesian
      heteroskedastic ordered-probit models.

{p 5 8 2}
   5. Prefix command {helpb bayes:bayes:} with multilevel models 
      now runs faster.

{marker laplprior}{...}
{p 5 8 2}
   6. {helpb bayesmh} and {helpb bayes:bayes:} have new 
        prior-specification options
        {cmd:pareto()},
	{cmd:dirichlet()}, and {cmd:geometric()} 
        for specifying Pareto, multivariate 
	beta (Dirichlet), and geometric prior distributions.

{p 8 8 2}
	Pareto is a power-law-based distribution.  Dirichlet can be used for 
	specifying priors for probability vector parameters.  Geometric 
	priors are suitable for modeling count parameters.

{p 5 8 2}
   7. {helpb bayesmh} and {helpb bayes:bayes:} now label all variables in
       the MCMC dataset.

{p 5 8 2}
   8. {helpb bayesgraph:bayesgraph, kdensity()} 
      now defaults to showing the overall density or, said differently, 
      defaults to {cmd:show(none)} instead of {cmd:show(both)}.
      The old default showed the first-half and second-half densities 
      overlaid with the overall density.  Old behavior is preserved under
      version control.


{marker NewPSS}{...}
{title:1.3.5  What's new in statistics (power and sample size)}

{p 5 8 2}
    1. {it:{help whatsnew15to16##ss:Highlight of the release}}.

{p 8 8 2}
       Power and sample size (PSS) has new features for sample-size analysis 
       for confidence intervals.
{p_end}


{marker NewXT}{...}
{title:1.3.6  What's new in statistics (panel data)}

{p 5 8 2}
     1. {it:{help whatsnew15to16##erms:Highlight of the release}}.

{p 8 8 2}
        New ERM estimation commands 
        {helpb xteregress}, 
        {helpb xteprobit}, 
        {helpb xteoprobit}, and
        {helpb xteintreg}
        fit linear regression, probit, ordered probit,
        and interval regression models with panel data
        and allow random effects to be correlated across equations.
{p_end}

{p 5 8 2}
     2. {it:{help whatsnew15to16##pdsel:Highlight of the release}}.

{p 8 8 2}
        New estimation command {helpb xtheckman} fits panel-data models 
        with endogenous sample selection using a random-effects estimator.
        All the standard postestimation features are provided.
{p_end}

{p 5 8 2}
     3. Existing estimation command {helpb xttobit} 
        previously required that lower and upper censoring limits be
        specified in options {cmd:ll(}{it:#}{cmd:)}
        and {cmd:ul(}{it:#}{cmd:)}.  New options 
        {cmd:ll} and {cmd:ul} make it easier to set the censoring 
        limits when the lower limit needs to be the minimum of the outcome 
        variable and the upper limit needs to be the maximum of the outcome variable.


{marker NewSVY}{...}
{title:1.3.7  What's new in statistics (survey data)}

{p 5 8 2}
    1. Prefix {helpb svy:svy:} works with more estimation commands, 
       namely, new commands 
       {helpb hetoprobit}, 
       {helpb cmmixlogit}, and {helpb cmxtmixlogit}.


{marker NewSEM}{...}
{title:1.3.8  What's new in statistics (SEM)}

{* rmsea in following paragraph is correct}{...}
{p 5 8 2}
     1. {helpb sem estat gof:estat gof} after {helpb sem} estimation now
     computes {bf:rmsea} using {it:N} in the denominator instead of {it:N}-1.
     This is a bug fix.


{marker NewTS}{...}
{title:1.3.9  What's new in statistics (time series)}

{p 5 8 2}
    1. You now refer to the free parameters differently 
        when fitting models using 
        {helpb arfima}, {helpb dfactor}, {helpb mgarch}, 
        {helpb sspace}, {helpb svar}, and {helpb ucm}.

{col 9}{hline}
{col 9}{cmd:arfima}:  
{col 12}{it:residual variance}
{col 15}old name:  {cmd:sigma2_cons}
{col 15}new name:  {cmd:/sigma2}

{col 9}{hline}
{col 9}{cmd:dfactor}:  
{col 12}{it:variance components of observable dependent variables}
{col 15}old names: {cmd:var(}{it:varspec}{cmd:):_cons}
{col 15}           {cmd:cov(}{it:varspec}{cmd:,}{it:varspec}{cmd:):_cons}

{col 15}new names: {cmd:/observable:var(}{it:varspec}{cmd:)}
{col 15}           {cmd:/observable:cov(}{it:varspec}{cmd:,}{it:varspec}{cmd:)}

{col 12}{it:variance components of unobserved factors}
{col 15}old names: {cmd:var(}{it:factorspec}{cmd:):_cons}
{col 15}           {cmd:cov(}{it:factorspec}{cmd:,}{it:factorspec}{cmd:):_cons}

{col 15}new names: {cmd:/factor:var(}{it:factorspec}{cmd:)}
{col 15}           {cmd:/factor:cov(}{it:factorspec}{cmd:,}{it:factorspec}{cmd:)}

{col 9}{hline}
{col 9}{cmd:mgarch ccc}, {cmd:mgarch vcc}, {cmd:mgarch dcc}:
{p 11 11 2}
{it:dependent variable correlations, ARCH, GARCH,}
{it:and t-distribution degrees of freedom}
{p_end}
{col 15}old names: {cmd:corr(}{it:varspec}{cmd:,}{it:varspec}{cmd:):_cons}
{col 15}           {cmd:Adjustment:lambda}{it:i}
{col 15}           {cmd:df:_cons}

{col 15}new names: {cmd:/:corr(}{it:varspec}{cmd:,}{it:varspec}{cmd:)}
{col 15}           {cmd:/Adjustment:lambda}{it:i}
{col 15}           {cmd:/t-dist:_cons}

{p 14 14 2}
where {it:varspec} is a dependent variable.
{p_end}

{col 9}{hline}
{col 9}{cmd:mgarch dvech}:
{p 11 11 2}
{it:S matrix, ARCH, GARCH,}
{it:and t-distribution degrees of freedom}
{p_end}
{col 15}old names: {cmd:Sigma0:}{it:i}{cmd:_}{it:j}
{col 15}           {cmd:df:_cons}

{col 15}new names: {cmd:/Sigma0:}{it:i}{cmd:_}{it:j}
{col 15}           {cmd:/t-dist:_cons}

{col 9}{hline}
{col 9}{cmd:sspace}:
{p 11 11 2}
{it:variance components of the observed dependent variables}
{p_end}
{col 15}old names: {cmd:var(}{it:varspec}{cmd:):_cons}
{col 15}           {cmd:cov(}{it:varspec}{cmd:,}{it:varspec}{cmd:):_cons}

{col 15}new names: {cmd:/observable:var(}{it:varspec}{cmd:)}
{col 15}           {cmd:/observable:cov(}{it:varspec}{cmd:,}{it:varspec}{cmd:)}

{p 11 11 2}
{it:variance components of the unobserved states}
{p_end}
{col 15}old names: {cmd:var(}{it:statespec}{cmd:):_cons}
{col 15}           {cmd:cov(}{it:statespec}{cmd:,}{it:statespec}{cmd:):_cons}

{col 15}new names: {cmd:/state:var(}{it:statespec}{cmd:)}
{col 15}           {cmd:/state:cov(}{it:statespec}{cmd:,}{it:statespec}{cmd:)}

{p 15 15 2}
where {it:varspec} is a dependent-variable specification, possibly with
TS operators, and {it:statespec} is an unobserved state specified in
the model.

{col 9}{hline}
{col 9}{cmd:svar}:
{col 12}{it:A, B, and C matrix elements}
{col 15}old names: {cmd:a_}{it:i}{cmd:_}{it:j}{cmd::_cons}
{col 15}           {cmd:b_}{it:i}{cmd:_}{it:j}{cmd::_cons}
{col 15}           {cmd:c_}{it:i}{cmd:_}{it:j}{cmd::_cons}

{col 15}new names: {cmd:/A:}{it:i}{cmd:_}{it:j}
{col 15}           {cmd:/B:}{it:i}{cmd:_}{it:j}
{col 15}           {cmd:/C:}{it:i}{cmd:_}{it:j}

{col 9}{hline}
{col 9}{cmd:ucm}:
{p 11 11 2}
variance components of the observed dependent variable
{p_end}
{col 15}old name:  {cmd:var(}{it:depvar}{cmd:):_cons}
{col 15}new name:  {cmd:/var(}{it:depvar}{cmd:)}

{p 11 11 2}
variance components of the unobserved components
{p_end}
{col 15}old name:  {cmd:var(}{it:compspec}{cmd:):_cons}
{col 15}new name:  {cmd:/var(}{it:compspec}{cmd:)}

{p 15 15 2}
where {it:depvar} is a dependent-variable specification and 
{it:compspec} is an unobserved component specified in the model.
{p_end}

{col 9}{hline}


{marker NewIRT}{...}
{title:1.3.10 What's new in statistics (item response theory)}

{p 5 8 2}
    1. {it:{help whatsnew15to16##irt:Highlight of the release}}.

{p 8 8 2}
    Stata's {cmd:irt} command now handles multiple-group analysis.
    It fits 1-, 2-, and 3-parameter logistic models.  It fits
    graded response, nominal response, partial credit, and rating scale
    models, and any combination of them.  And it can graph
    item characteristic curves, test characteristic curves, item
    information functions, and test information functions.
{p_end}

{p 5 8 2}
    2. The existing {cmd:irt} commands now allow you to specify
       fixed-value and equality constraints on item parameters.  These
       constraints are particularly useful when combined with
       the new multiple-group models because they allow you to perform
       model-based tests of differential item functioning (DIF).
       See {helpb irt constraints:[IRT] irt constraints}.

{p 5 8 2}
     3. {helpb estat greport} is a new command that displays
        results of group IRT models in a compact form.
        You can sort items by parameter value or
        group results by parameter just as you can with 
        {helpb estat report}.


{marker NewDSGE}{...}
{title:1.3.11  What's new in statistics (DSGE)}

{p 5 8 2}
    1. {it:{help whatsnew15to16##NewDSGE:Highlight of the release}}.

{p 8 8 2}
    Stata's new {helpb dsgenl} command estimates the parameters of
    nonlinear dynamic stochastic general equilibrium (DSGE) models,
    in which models in our implementation can incorporate nonlinearities
    in both the parameters and the equations.  The model's
    solution is approximated with a first-order perturbation.
    Parameter estimation is then performed on the approximate model.
{p_end}

{p 5 8 2}
    2. New command {helpb estat steady}  is for use after {cmd:dsgenl}.
       It displays the model's steady-state, which is where the model's
       variables eventually come to rest after a shock.

{p 5 8 2}
    3. New command {helpb dsge estat covariance:estat covariance} is for use
    after {cmd:dsge} and {cmd:dsgenl}.  It reports model-implied variances,
    covariances, and autocovariances.


{marker NewFN}{...}
{title:1.3.12 What's new in functions}

{p 5 8 2}
    1. New functions {helpb frval()} and {helpb _frval()} are 
       part of 
       {help whatsnew15to16##frames:Stata's new frames features}, which
       allows you to have multiple datasets in memory and is a highlight
       of the release.  They access the values of variables in other
       frames.

{p 5 8 2}
     2. New function {help expm1():{bf:expm1(}{it:x}{bf:)}}
        calculates {cmd:exp(}{it:x}{cmd:)}-1 at high accuracy for small values 
        of |{it:x}|.

{p 5 8 2}
     3. New function {help ln1m():{bf:ln1m(}{it:x}{bf:)}} calculates
     {cmd:ln(}1-{it:x}{cmd:)} at high accuracy for small values of |{it:x}|.

{p 5 8 2}
     4. New function {help ln1p():{bf:ln1p(}{it:x}{bf:)}} calculates 
        {cmd:ln(}1+{it:x}{cmd:)} at high accuracy for small values of |{it:x}|.
         

{marker NewG}{...}
{title:1.3.13 What's new in graphics}

{p 5 8 2}
    1. {it:{help whatsnew15to16##sizes:Highlight of the release}}.

{p 8 8 2}
       All graphics commands now support specifying sizes in 
       printer points, inches, or centimeters.
       The units can be used to specify text sizes, marker sizes,
       margins, line thicknesses, line spacing, gaps, and more.
{p_end}

{p 5 8 2}
    2. {helpb graph export} is 
        Stata's existing command for translating Stata's graphs to 
        PostScript, EPS, SVG, Windows Metafile, Windows Enhanced 
        Metafile, PDF, PNG, TIFF, TIF, and JPEG.

{p 8 8 2}
        New option {cmd:pathprefix()} specifies the prefix to use when
        naming SVG paths.  This allows you to create stable path names.
        A path is a collection of lines and curves that define a shape.
        See {manhelpi svg_options G-3}.

{p 5 8 2}
     3. {helpb graph export} used on the Mac can now export to 
        GIF and JPEG formats.

{p 5 8 2}
     4. {helpb marginsplot} is Stata's existing command for graphing 
        results from {helpb margins}.
        {cmd:marginsplot} now allows abbreviations of variables
        specified in dimension lists in the following options:

                {cmd:marginsplot, xdimension()}
                {cmd:marginsplot, plotdimension()}
                {cmd:marginsplot, bydimension()}

{p 5 8 2}
     5. Stata's {cmd:.gph} file format was updated because of the new support
        of units when specifying sizes for text, markers, margins, line
	thickness, line spacing, gaps, etc.  Previous versions of Stata will
	not be able to read the new format, but Stata 16 can read old formats
	without difficulty.


{marker NewD}{...}
{title:1.3.14 What's new in data management}

{p 5 8 2}
    1. {it:{help whatsnew15to16##frames:Highlight of the release}}.

{p 8 8 2}
    Stata now allows you to have multiple datasets in memory 
    simultaneously.  See the highlight, and see {helpb frames}
    and {helpb frlink}.
{p_end}

{p 5 8 2}
    2. {cmd:clear all} clears more now that Stata allows multiple 
       datasets in memory.  It now also calls {cmd:frames reset}
       to reset frames.

{p 8 8 2}
       New command {helpb frames reset} clears and deletes all the
       frames, and it changes the name of the current frame to
       {cmd:default}.

{p 8 8 2}
        Relatedly, new command {cmd:clear frames} is a synonym for 
        {cmd:frames reset}.

{p 5 8 2}
    3. {it:{help whatsnew15to16##import:Highlight of the release}}.

{p 8 8 2}
    Stata's {helpb import} command can now import SAS and SPSS 
    datasets.
{p_end}

{p 5 8 2}
    4. New command {helpb export sasxport8} exports datasets to 
       SAS XPORT Version 8 Transport format.

{p 8 8 2}
        Relatedly, {helpb export sasxport5} is the new name of 
        previously existing command {cmd:export sasxport}.

{p 5 8 2}
    5. {helpb vl} is a new command that helps you assemble varlists
       containing lots of variables, including factor variables and 
       interactions.  We created the command for
       use with {cmd:lasso}, a highlight of the release, but it turns
       out to be useful with all of Stata's estimation commands when
       you need to specify lots of covariates.

{p 5 8 2}
    6. {helpb splitsample} splits data into random samples.  It can
       create simple random samples or clustered ones.  It can also
       create balanced random samples.  Balance splitting can be used
       for matched-treatment assignment.

{p 5 8 2}
    7. {helpb assertnested} is a new Stata {helpb assert} command.
       These commands verify something is true and issue an error
       message (and thereby abort do-files) if not.  {cmd:assertnested}
       {it:varname1} {it:varname2} asserts that the observations
       identified by {it:varname2} are nested within those identified
       by {it:varname1}.  You can specify multiple variables to assert
       a chain of nestings.

{p 5 8 2}
    8.  {helpb _pctile} is the existing command for creating 
        variables containing percentiles.  It will now compute
        up to 4,096 percentiles, up from 1,000.

{p 5 8 2}
     9. {helpb list} no longer 
        assigns a default base level for factor variables when
        one is not specified.  The old behavior is preserved under
        version control.

{p 4 8 2}
    10. {helpb import delimited} is the existing command to 
        import data from delimited text files.  It has been enhanced.

{p 11 14 2}
          a. It is faster.  It is 10% faster in general, and 
             2 to 4 times faster in some cases.

{p 11 14 2}
          b. It detects delimiters better.
             In addition to commas and tabs, it now detects 
             pipes, colons, and semicolons.

{p 11 14 2}
         c. New options allow numeric parsing based on locale.
            The options are {cmd:parselocale()},
            {cmd:groupseparator()}, and {cmd:decimalseparator()}.

{p 11 14 2}
          d. Mismatched quotes in the imported file are reported so that you 
             can fix them.

{p 11 14 2}
          e. The GUI has three new features:{break}
              o It detects and sets the text encoding.{break}
              o It now displays data types, which you can modify.{break}
              o Data from web addresses can be previewed and imported.

{p 4 8 2}
   11. Stata now allows abbreviations of matrix-stripe names 
       when {helpb set varabbrev:varabbrev} is set to {cmd:on}.
       Stripe abbreviations will be allowed by the following: 

            Stata functions {helpb colnumb()} and {helpb rownumb()}
            Stata extended macro functions {helpb macro##macro_fcn::colnumb} and {helpb macro##macro_fcn::rownumb}
            Mata functions {helpb mf_st_ms_utils:st_matrixcolnumb()} and {helpb mf_st_ms_utils:st_matrixrownumb()}

{p 8 8 2}
    Old behavior is preserved under version control.


{marker NewP}{...}
{title:1.3.15 What's new in programming}

{p 5 8 2}
    1. {it:{help whatsnew15to16##python:Highlight of the release}}.

{p 8 8 2}
    You can now write programs in Python that are integrated with Stata.  You
    can use Python from Stata's command line, in do-files, and in ado-files.
    Stata's relationship with Python is much like its relationship with Mata.
    {p_end}

{p 5 8 2}
    2. {helpb preserve} now runs faster with Stata/MP because
       we wrote it to exploit Stata's new 
       {help whatsnew15to16##frames:frames} features.
       Datasets are secretly preserved to hidden frames.

{p 8 8 2}
    If you have lots of memory on your computer, you may want
    to change Stata's new {cmd:set} {cmd:max_preservemem} to a number
    larger than the default {cmd:1g}.  By default, once 1 gigabyte of
    memory is consumed preserving datasets, {cmd:preserve} reverts to
    its old behavior of saving datasets on disk.
    See {manhelp preserve D}.

{p 5 8 2}
   3. {helpb creturn:c(changed)} is Stata's c-return value 
      that returns 1 when data have changed since last saved and returns 
      0 otherwise.  Stata now sets {cmd:c(changed)} to 1 more liberally.
      In addition to all the old reasons, {cmd:c(changed)} is now 1 if 
      you 

              modify dataset or variable characteristics
              modify dataset or variable notes 
              modify dataset or variable labels 

              modify variable formats 

              run {helpb compress} that changes variable storage types

{p 5 8 2}
    4. New commands {helpb matrix rowjoinbyname} and 
       {helpb matrix coljoinbyname} join matrix rows (columns) matched 
       on column (row) names.

{p 5 8 2}
    5. There are new Stata utility commands for controlling the Java 
       Runtime Environment (JRE).

{p 11 14 2}
       a. New command {helpb java query} shows settings and system 
          for the JRE.

{p 11 14 2}
       b. New command {helpb java set:java set home} sets the 
          path to the JRE.
          {cmd:set java home} is a synonym for {cmd:java set home}.

{p 11 14 2}
       c. New command {helpb java set:java set heapmax} 
          sets the maximum heap memory allocated for the Java Virtual 
          Machine (JVM).
          {cmd:set java heapmax} is a synonym for {cmd:java set heapmax}.

{p 11 14 2}
       d. New command {helpb java initialize} manually initializes 
           the JVM.
      
{p 5 8 2}
    6. New extended macro function {cmd::results} returns whether the command 
        is {cmd:nclass}, {cmd:rclass}, {cmd:eclass}, or {cmd:sclass}.
        The syntax is

                {cmd:local} {it:class} {cmd::results} {it:commandname}
 
{p 8 8 2}
	See {manhelp macro P}.

{p 5 8 2}
    7. {helpb confirm} is Stata's programming command for confirming 
       that a file exists, a variable exists, a variable is numeric, 
       and so on.

{p 8 8 2}
       New command {cmd:confirm frame} {it:framename} verifies that
       {it:framename} is an existing frame.

{p 8 8 2}
       New command {cmd:confirm new frame} {it:framename} verifies that 
       {it:framename} does not currently exist and that {it:frame} 
       would be a valid name for a new frame.

{p 5 8 2}
    8. Matrix subscripting and extraction are now allowed with 
       {cmd:r()} and {cmd:e()} matrices, including 
       {cmd:e(b)}, {cmd:e(V)}, and {cmd:e(Cns)}.  For example, 

              {cmd:. sysuse auto}
              {cmd:. regress mpg turn trunk}
              {cmd:. display e(v)["turn","trunk"]}

{p 5 8 2}
     9. Matrix functions returning scalars now work with {cmd:r()}
         and {cmd:e()} matrices.  For example, 

              {cmd:. sysuse auto}
              {cmd:. regress mpg turn trunk}
              {cmd:. display colsof(e(b))}


{marker NewM}{...}
{title:1.3.16 What's new in Mata}

{p 5 8 2}
    1. {it:{help whatsnew15to16##numinteg:Highlight of the release}}.

{p 8 8 2}
     Mata's new {cmd:Quadrature} class numerically integrates {it:y}
     = f({it:x}), {it:y} and {it:x} scalars, over the interval {it:a}
     to {it:b}, where {it:a} may be minus infinity or finite and {it:b}
     may be positive infinity or finite.  The integral is approximated
     using adaptive quadrature.
{p_end}

{p 5 8 2}
    2. {it:{help whatsnew15to16##lp:Highlight of the release}}.

{p 8 8 2}
    Mata's new {cmd:LinearProgram} class solves linear programs 
    using an interior-point method.
{p_end}

{p 5 8 2}
    3. New Mata functions {bf:{help mata st_frame():st_frame*()}}
       manipulate frames, including creating them, changing them, 
       and deleting them.
    
{p 5 8 2}
    4. New Mata function {bf:{help mata ustrsplit():ustrsplit()}}
       splits Unicode strings into parts according to a regular 
       expression, which is also in Unicode.

{p 5 8 2}
    5. New Mata function {bf:{help mata isascii():isascii()}}
       returns whether a string contains only ASCII codes.

{p 5 8 2}
    6. New Mata function {bf:{help mata issamefile():issamefile()}}
       returns whether file paths point to the same file.

{p 5 8 2}
    7. New Mata function {bf:{help mata pathresolve():pathresolve()}}
       resolves relative paths.  For example, 

               {cmd:pathresolve("c:/test", "../test1")}

{p 8 8 2}
       returns {cmd:c:/test1"}.

{p 5 8 2}
    8. New Mata function {bf:{help mata pathgetparent():pathgetparent()}}
       returns the parent of a path.  For example, 

               {cmd:pathgetparent("c:/test/test.do")}

{p 8 8 2}
       returns {cmd:"c:/test"}.  Neither the original path nor 
       the parent path need exist.

{p 5 8 2}
     9. New Mata function {help mata expm1():{bf:expm1(}{it:X}{bf:)}}
        calculates {cmd:exp(}{it:x}{cmd:)}-1 for every element x of
	matrix X at high accuracy for small values of |{it:x}|.

{p 4 8 2}
    10. New Mata function {help mata ln1m():{bf:ln1m(}{it:X}{bf:)}} calculates
    {cmd:ln(}1-{it:x}{cmd:)} for every element x of real matrix X
	at high accuracy for small values of |{it:x}|.

{p 4 8 2}
    11. New Mata function {help ln1p():{bf:ln1p(}{it:X}{bf:)}} calculates 
	{cmd:ln(}1+{it:x}{cmd:)} for every element x of real matrix X
	at high accuracy for small values of |{it:x}|.


{marker NewREPORT}{...}
{title:1.3.17 What's new in reporting}

{p 4 8 2}
    1. {it:{help whatsnew15to16##autoreport:Highlight of the release}}.

{p 8 8 2}
    Stata's automated reporting is a highlight of the release.
    See the highlight for details.  We provide details and list 
    other changes below.
{p_end}

{p 4 8 2}
    2. {helpb putdocx} has new features for adding headers, footers, 
       and page numbers to a Word document.

{p 11 14 2}
      a. {cmd:putdocx begin}'s  new options {cmd:header()} and {cmd:footer()} 
	 specify headers and footers be added to the document.
   
{p 11 14 2}
      b. {cmd:putdocx sectionbreak}'s new options {cmd:header()} and 
         {cmd:footer()} specify headers and footers be added to the
         section.

{p 11 14 2}
      c. {cmd:putdocx paragraph}'s new options {cmd:toheader()} and
         {cmd:tofooter()} add content to headers and footers.

{p 11 14 2}
      d. {cmd:putdocx table}'s new options {cmd:toheader()} 
         and {cmd:tofooter()} add tables to headers and footers.

{p 11 14 2}
      e. New command {cmd:putdocx pagenumber} adds page numbers to a 
         paragraph that is to be added to the header or footer.

{p 11 14 2}
      f. {cmd:putdocx table}'s new options {cmd:pagenumber} and 
         {cmd:totalpages} add the current page and total number of
         pages to a table that appears in a header or footer.

{p 11 14 2}
      g. {cmd:putdocx save}'s  new option {cmd:append()} controls how
	 page breaks, page numbers, headers, and footers appear 
	 in the appended document.
	
{p 14 14 2}
         New suboption {cmd:pagebreak} specifies that each appended
         file begin on a new page.

{p 14 14 2}
         New suboption {cmd:pgnumrestart} specifies that page numbering
         be restarted at the beginning of each appended file.

{p 14 14 2}
         New suboption {cmd:headsrc()} specifies whether the appended
         document's header and footer comes from the first file or the
         last file or whether each appended file should keep its own header and
         footer.

{p 11 14 2}
      h. {cmd:putdocx append} has three new options that control how
          page breaks, page numbers, headers, and footers appear
         in the appended document.

{p 14 14 2}
          New option {cmd:pagebreak} specifies that each appended file
          begin on a new page.

{p 14 14 2}
	  New option {cmd:pgnumrestart} specifies that page numbering
          be restarted at the beginning of each appended file.

{p 14 14 2}
          New option {cmd:headsrc()} specifies whether the appended
          document's header and footer comes from the first file or the
          last file or whether each appended file keep its own header and
          footer.

{p 11 14 2}
      i. {cmd:putdocx} has four new commands to simplify writing
      paragraphs to a document.

{p 14 14 2}
        {cmd:putdocx textblock begin},{break}
        {cmd:putdocx textblock append}, and{break}
        {cmd:putdocx textblock end}{break}
        let you write large blocks of text to be included in the
        Word document.  Unlike {cmd:putdocx text}, these commands do
        not require that you specify text as expressions.  They make it
	easier to write entire paragraphs.  You can add the content of Stata
	macros and format the text within a text block by using the new
	dynamic tag {cmd:dd_docx_display}.

{p 14 14 2}
        {cmd:putdocx textfile} allows you to add a textfile as a block
        of preformatted text.

{p 4 8 2}
    3. {cmd:putexcel}'s output type {cmd:picture()} is renamed {cmd:image()}.

{p 4 8 2}
    4. {cmd:putexcel close} is renamed {cmd:putexcel save}.

{p 4 8 2}
    5. New command {helpb html2docx} converts HTML web pages (both contents 
        and style) to Word ({cmd:.docx}) documents.

{p 4 8 2}
    6. New command {helpb docx2pdf} to converts Word ({cmd:.docx}) document
    (both contents and style) to PDF documents.

{p 4 8 2}
    7. {helpb dyndoc}'s new option {cmd:docx} 
       produces Word ({cmd:.docx}) documents 
       that include Stata output and graphs from a Markdown 
       document.

{p 4 8 2}
    8. {helpb dyndoc}'s new option {cmd:embedimage} specifies that images
       in the new HTML file be included as a data resource instead of a
       link.

{p 4 8 2}
    9. {helpb markdown}'s new option {cmd:docx} produces Word (.docx) documents
       from a Markdown document.

{p 3 8 2}
   10. {helpb markdown}'s new option {cmd:embedimage} specifies that images
       in the new HTML file be included as a data resource instead of a
       link.

{p 3 8 2}
   11. {helpb markdown}'s new option {cmd:basedir()} specifies the base
       directory for the links that contain the relative path.

{p 3 8 2}
   12. Dynamic tag {cmd:<<dd docx display>>} is now available 
       for use with {helpb putdocx} to include output of a Stata
       expression in a Word file as shown by Stata's {cmd:display} command
       and to format text within a text block.

{p 3 8 2}
   13. Dynamic tags {cmd:<<dd_if>>}, {cmd:<<dd_else>>}, and 
       {cmd:<<dd_endif>>} are now available for processing contents based 
       on a condition.

{p 3 8 2}
   14. Dynamic tag {cmd:<<dd_version>>}'s version changed from 1 
       (Stata 15) to 2 (Stata 16).

{p 3 8 2}
   15. Dynamic tag {cmd:<<dd_include>>} now allows macros in
        the filename.


{marker NewGUI}{...}
{title:1.3.18 What's new in the interface}

{p 5 8 2}
    1. {it:{help whatsnew15to16##dofileed:Highlight of the release}}.
   
{p 8 8 2}
    Stata's Do-file Editor now lets you edit Python and Markdown files, 
    and even provides syntax highlighting for the two languages.
    The Editor now autocompletes Stata commands, words that exist in the
    document, and quotes, parentheses, braces, and brackets.
{p_end}

{p 5 8 2}
    2. The Do-file Editor also supports the use of spaces instead
       of tabs for indentation.  It can even convert between the two
       methods of indentation.

{p 5 8 2}
    3. {it:{help whatsnew15to16##mac:Highlight of the release}}.

{p 8 8 2}
    Stata for Mac now supports Dark Mode and native tabbed windows.
{p_end}

{p 5 8 2}
    4. The Review window is now called the History window on
       all operating systems.

{p 5 8 2}
    5. Stata for Mac also has a new default layout.
       The layout is named {it:Sidebar}.  It moves three of the 
       window panes -- Variables, History, and Project Manager -- to a tabbed
       sidebar.  This layout is ideal for laptops.

{p 8 8 2}
       Meanwhile, the {it:Widescreen} layout is still available for 
       those who want both the Variables and History panes to be 
       simultaneously visible.

{p 5 8 2}
    6. Stata for Mac's application and installer are now notarized by Apple.
       This provides assurance that the software we distribute has been 
       checked by Apple for malicious components.  As of macOS 10.15
       (to be released in the fall of 2019), notarization is required
       for all software.

{p 5 8 2}
    7. Stata for Windows now supports a dark theme, that is, bright text on a 
       dark background, and several more.

{p 5 8 2}
    8. Stata's Data Editor (all operating systems) now allows 
       columns to be resized by dragging.

{p 5 8 2}
    9. Stata for Linux now opens PDF manuals using {bf:evince} if it is 
       installed on your computer.  {cmd:evince} is a third-party
       PDF viewer.

{p 8 8 2}
       If you wish to use Acrobat Reader {cmd:acroread} or some
       other PDF viewer, put its name in the Unix shell environment
       variable {bf:PDFVIEWER} and Stata will use it.  For more
       information, see the comments in the file {bf:stata_pdf} in the
       directory where Stata is installed.


{marker NewMisc}{...}
{title:1.3.19  What's new (miscellaneous)}

{p 5 8 2}
    1. {cmd:_se} is now a reserved word, which means that 
       you may no longer create a variable, matrix, or scalar named 
       {cmd:_se}.  The old behavior is preserved under version control.

{p 5 8 2}
    2. {helpb ado update} is the new name of the {cmd:adoupdate} command.
    
{p 5 8 2}
    3. {it:Windows only}.

{p 8 8 2}
       The {helpb sysdir:PLUS} directory is now 
       defined as {cmd:%USERPROFILE%/ado/plus} 
       if {cmd:C/ado/plus} does not already exist.

{p 8 8 2}
       The {helpb sysdir:PERSONAL} directory is now 
       defined as 
       {cmd:%USERPROFILE%/ado/personal}
       if {cmd:C:/ado/personal} does not already exist.


{marker NewMore}{...}
{title:1.3.20  What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated.  Those between-release updates are
available for free over the Internet.

{pstd}
Type {bf:{stata update query:update query}} and follow the instructions.

{pstd}
We hope that you enjoy Stata 16.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew15}.

{hline}
