{smcl}
{* *! version 1.1.6  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 15.0 (compared with release 14)}}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 15.0:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {bf:this file}        Stata 15.0 new release       2017            {c |}
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
See {help whatsnew15}.


{hline 3} {hi:Stata 15.0 release 06jun2017} {hline}

      {bf:Contents}
{p 11 12 2}1.3  What's new{p_end}
{p 9 12 2}{help whatsnew14to15##highlights:1.3.1  Highlights}{p_end}
{p 9 12 2}{help whatsnew14to15##NewStat:1.3.2  What's new in statistics (general)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewME:1.3.3  What's new in statistics (multilevel)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewBAYES:1.3.4  What's new in statistics (Bayesian)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewPSS:1.3.5  What's new in statistics (power and sample size)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewST:1.3.6  What's new in statistics (survival analysis)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewSVY:1.3.7  What's new in statistics (survey data)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewSEM:1.3.8  What's new in statistics (SEM)}{p_end}
{p 9 12 2}{help whatsnew14to15##NewXT:1.3.9  What's new in statistics (panel data)}{p_end}
{phang2}{help whatsnew14to15##NewTS:1.3.10  What's new in statistics (time series)}{p_end}
{phang2}{help whatsnew14to15##NewMV:1.3.11  What's new in statistics (multivariate)}{p_end}
{phang2}{help whatsnew14to15##NewFN:1.3.12  What's new in functions}{p_end}
{phang2}{help whatsnew14to15##NewG:1.3.13  What's new in graphics}{p_end}
{phang2}{help whatsnew14to15##NewD:1.3.14  What's new in data management}{p_end}
{phang2}{help whatsnew14to15##NewP:1.3.15  What's new in programming}{p_end}
{phang2}{help whatsnew14to15##NewM:1.3.16  What's new in Mata}{p_end}
{phang2}{help whatsnew14to15##NewGUI:1.3.17  What's new in the Stata interface}{p_end}
{phang2}{help whatsnew14to15##NewMore:1.3.18  What's more}{p_end}

{pstd}
This section is intended for users of the previous version of Stata.  If you
are new to Stata, you may as well skip to 
{it:{help whatsnew14to15##NewMore:What's more}}, below.

{pstd}
As always, Stata 15 is 100% compatible with the previous releases, but
we remind programmers that it is important to put
{cmd:version 15}, {cmd:version} {cmd:14.1}, or {cmd:version 12}, etc.,
at the top of old do- and ado-files so that they continue to work as you
expect.  You were supposed to do that when you wrote them, but if you did not,
go back and do it now.

{pstd}
We will list all the changes, item by item, but first, here are the
highlights.
 

{marker highlights}{...}
{title:1.3.1  Highlights}

{pstd}
The highlights of the release are the following:

{p 5 9 2}
1.  Latent class analysis (LCA)

{p 5 9 2}
2.  A {cmd:bayes} prefix command that can be used in front of many
            maximum likelihood estimation command

{p 5 9 2}
3.  Linearized dynamic stochastic general equilibrium (DSGE) models

{p 5 9 2}
4.  Extended regression models (ERMs) that fit continuous,
           binary, ordered responses with 1) endogeneity, 2) Heckman-style
	   selection, and 3) treatment effects

{p 5 9 2}
5.  Dynamic documents combining Markdown with Stata code to produce
            HTML files

{p 5 9 2}
6.  Nonlinear mixed-effects models

{p 5 9 2}
7.  Spatial autoregressive (SAR) models

{p 5 9 2}
8.  Interval-censored parametric survival-time models

{p 5 9 2}
9.  Finite mixture models (FMMs)

{p 5 9 2}
10.  Mixed logit models

{p 5 9 2}
11.  Nonparametric regression using kernel methods

{p 5 9 2}
12.  Power analysis for cluster randomized trials and regression models

{p 5 9 2}
13.  Produce PDF and Word documents

{p 5 9 2}
14.  Graph color transparency or opacity

{p 5 9 2}
15.  ICD-10-CM and ICD-10-PCS support

{p 5 9 2}
16.  Federal Reserve Economic Data support

{pstd}
And that is not all.  The following could have been highlights, too.

        o   multilevel tobit and interval regression
        o   heteroskedastic regression
        o   panel data cointegration tests
        o   threshold regression
        o   zero-inflated ordered probit
        o   Poisson with Heckman-style sample selection
        o   tests for multiple breaks in time series
        o   stream random numbers

{pstd}
    There is more to boot.  The above and other changes are covered here.
    Detailed sections follow the highlights.


{marker wnlatent}{...}
{pstd}
{bf:Highlight 1. Latent class analysis (LCA)}

{pmore}
Stata's {cmd:gsem} command now supports LCA, which, depending on the
jargon you use, includes latent profile analysis (LPA) and finite
mixture models (FMMs).

{pmore}
All of these models use categorical latent variables.  Categorical
means group.  Latent means unobserved.  Categorical latent
variables can be used to represent consumers with different buying
preferences, patients in different risk groups, or schools serving
students with different interests.  Unobserved are the buying
preferences, risk groups, and interests.  These unobserved
categories are the latent classes, and LCA is used to
identify them while accounting for the uncertainty of the recovered
groups and used to account for their effects.

{pmore}
LPA is a variation on LCA and is used when the
outcome variables are continuous.

{pmore}
FMM is a synonym for LCA to some people, a subset to
others, and a superset to even others.  In any case, {cmd:gsem} now
has the features.

{pmore}
We consider FMM to be a subset of LCA.  If you simply
want to fit finite mixtures of Poisson or linear regression models
and the like, you can use our new {cmd:gsem} features, but we have
another new feature for you:  the {cmd:fmm:} prefix command, which
is {help whatsnew14to15##wnfmm:{it:Highlight 9}} below.

{pmore}
LCA, LPA, and FMM are now part of Stata's
{cmd:gsem} command, and that means you can fit regression models
and multioutcome path models that allow parameters to vary across
latent classes.

{pmore}
For instance, you might have four binary variables that are
indicators of latent groups of consumers.  If you believed that
there are three such groups, you could type

            {cmd:. gsem (y1 y2 y3 y4 <- _cons), lclass(Consum 3) logit}

{pmore}
{cmd:y1}, {cmd:y2}, {cmd:y3}, and {cmd:y4} are observed outcome
variables.  {cmd:Consum} is the latent categorical variable that
we specified as taking on three values.  The result is to fit a
model in which {cmd:y1}, {cmd:y2}, {cmd:y3}, and {cmd:y4} are
determined by unobserved class.

{pmore}
The command fits four logistic regressions, one for each of the
{cmd:y} variables.  That would fit four intercepts.  Because of the
new {cmd:lclass(Consum 3)} option, however, each of the 4 
models would be fit with distinct intercepts for each value of {cmd:Consum},
meaning 12 intercepts would be fit for the logistic regressions, and that is
not all.  A multinomial logistic regression would be used to predict
{cmd:Consum}.

{pmore}
After fitting the model, you can 

{phang2}
o{space 3}use the new {cmd:estat lcprob} command to estimate the
     proportion of consumers belonging to each class; 

{phang2}
o{space 3}use the new {cmd:estat lcmean} command to estimate the marginal
     means of {cmd:y1}, {cmd:y2}, {cmd:y3}, and {cmd:y4} in
     each class (the means are probabilities in this case);

{phang2}
o{space 3}use the new {cmd:estat lcgof} command to evaluate the goodness
     of fit;

{phang2}
o{space 3}use the existing {cmd:predict} command to obtain predicted
     probabilities of class membership and predicted values of
     observed outcome variables.

{pmore}
See {manlink SEM Intro 2},
{manhelp gsem_lclass_options SEM:gsem lclass options},
{manhelp sem_estat_lcprob SEM:estat lcprob},
{manhelp sem_estat_lcmean SEM:estat lcmean},
{manhelp sem_estat_lcgof SEM:estat lcgof}, and
{manhelp predict_after_gsem SEM:predict after gsem}.


{marker wnbayes}{...}
{pstd}
{bf:Highlight 2. bayes prefix}

{pmore}
The new {cmd:bayes:} prefix command lets you fit Bayesian
regression models more easily and fit more models.  You always
could fit a Bayesian linear regression.  Now you can fit it by
typing

            {cmd:. bayes: regress y x1 x2}

{pmore}
That is convenient.  What you could not previously do was fit 
a Bayesian survival model.  Now you can.

           {cmd:. bayes: streg x1 x2, distribution(weibull)}

{pmore}
You can even fit Bayesian multilevel survival models.

           {cmd:. bayes: mestreg x1 x2 || id:, distribution(weibull)}

{pmore}
In this model, random intercepts were added for each value of 
variable {cmd:id}.

{pmore}
You can use the {cmd:bayes:} prefix with the following estimation 
commands:

{p2colset 7 35 37 2}{...}
{p2coldent:Command}Purpose{p_end}
{p2line}
{p2coldent :{helpb bayes betareg:bayes: betareg}}Beta regression{p_end}
{p2coldent :{helpb bayes binreg:bayes: binreg}}Binomial regression{p_end}
{p2coldent :{helpb bayes biprobit:bayes: biprobit}}Bivariate probit regression{p_end}
{p2coldent :{helpb bayes clogit:bayes: clogit}}Conditional logistic regression{p_end}
{p2coldent :{helpb bayes cloglog:bayes: cloglog}}Conditional log-log regression{p_end}
{p2coldent :{helpb bayes fracreg:bayes: fracreg}}Fractional response regression{p_end}
{p2coldent :{helpb bayes glm:bayes: glm}}Generalized linear model{p_end}
{p2coldent :{helpb bayes gnbreg:bayes: gnbreg}}Negative binomial regression{p_end}
{p2coldent :{helpb bayes heckman:bayes: heckman}}Heckman selection model{p_end}
{p2coldent :{helpb bayes heckoprobit:bayes: heckoprobit}}Ordered probit with sample selection{p_end}
{p2coldent :{helpb bayes heckprobit:bayes: heckprobit}}Probit with sample selection{p_end}
{p2coldent :{helpb bayes hetprobit:bayes: hetprobit}}Heteroskedastic probit{p_end}
{p2coldent :{helpb bayes hetregress:bayes: hetregress}}Heteroskedastic linear regression{p_end}
{p2coldent :{helpb bayes intreg:bayes: intreg}}Interval regression{p_end}
{p2coldent :{helpb bayes logistic:bayes: logistic}}Logistic regression (odds ratios){p_end}
{p2coldent :{helpb bayes logit:bayes: logit}}Logistic regression (coefficients){p_end}

{p2coldent :}Multilevel mixed-effects ...{p_end}
{p2coldent :{helpb bayes mecloglog:bayes: mecloglog}}{space 2}complementary
log-log regression{p_end}
{p2coldent :{helpb bayes meglm:bayes: meglm}}{space 2}generalized linear model{p_end}
{p2coldent :{helpb bayes meintreg:bayes: meintreg}}{space 2}interval regression{p_end}
{p2coldent :{helpb bayes melogit:bayes: melogit}}{space 2}logistic regression {p_end}
{p2coldent :{helpb bayes menbreg:bayes: menbreg}}{space 2}negative binomial regression{p_end}
{p2coldent :{helpb bayes meologit:bayes: meologit}}{space 2}ordered logistic regression{p_end}
{p2coldent :{helpb bayes meoprobit:bayes: meoprobit}}{space 2}ordered probit regression{p_end}
{p2coldent :{helpb bayes mepoisson:bayes: mepoisson}}{space 2}Poisson regression{p_end}
{p2coldent :{helpb bayes meprobit:bayes: meprobit}}{space 2}probit regression{p_end}
{p2coldent :{helpb bayes mestreg:bayes: mestreg}}{space 2}parametric survival regression{p_end}
{p2coldent :{helpb bayes metobit:bayes: metobit}}{space 2}tobit regression{p_end}
{p2coldent :{helpb bayes mixed:bayes: mixed}}{space 2}linear regression{p_end}

{p2coldent :{helpb bayes mlogit:bayes: mlogit}}Multinomial (polytomous) logistic regression{p_end}
{p2coldent :{helpb bayes mprobit:bayes: mprobit}}Multinomial probit regression{p_end}
{p2coldent :{helpb bayes mvreg:bayes: mvreg}}Multivariate linear regression{p_end}
{p2coldent :{helpb bayes nbreg:bayes: nbreg}}Negative binomial regression{p_end}
{p2coldent :{helpb bayes ologit:bayes: ologit}}Ordered logistic regression{p_end}
{p2coldent :{helpb bayes oprobit:bayes: oprobit}}Ordered probit regression{p_end}
{p2coldent :{helpb bayes poisson:bayes: poisson}}Poisson regression{p_end}
{p2coldent :{helpb bayes probit:bayes: probit}}Probit regression{p_end}
{p2coldent :{helpb bayes regress:bayes: regress}}Linear regression{p_end}
{p2coldent :{helpb bayes streg:bayes: streg}}Parametric survival regression{p_end}
{p2coldent :{helpb bayes tnbreg:bayes: tnbreg}}Truncated negative binomial regression{p_end}
{p2coldent :{helpb bayes tobit:bayes: tobit}}Tobit regression{p_end}
{p2coldent :{helpb bayes tpoisson:bayes: tpoisson}}Truncated Poisson regression{p_end}
{p2coldent :{helpb bayes truncreg:bayes: truncreg}}Truncated linear regression{p_end}
{p2coldent :{helpb bayes zinb:bayes: zinb}}Zero-inflated negative binomial regression{p_end}
{p2coldent :{helpb bayes zioprobit:bayes: zioprobit}}Zero-inflated ordered probit regression{p_end}
{p2coldent :{helpb bayes zip:bayes: zip}}Zero-inflated Poisson regression{p_end}
{p2line}
{p2colreset}{...}

{pmore}
All of Stata's Bayesian features are supported by the new {cmd:bayes:} prefix
command.  You can select from many prior distributions for model parameters or
use default priors. You can use the default adaptive Metropolis-Hastings
sampling, or Gibbs sampling, or a combination of the two sampling methods,
when available.  And you can use any other feature included in {cmd:bayesmh}.
For example, you can change the default prior distributions for the regression
coefficients: 

            {cmd:. bayes, prior({y: x1 x2}, normal(0,4)): regress y x1 x2}

{pmore}
After estimation, you can use Stata's standard Bayesian postestimation
tools such as {cmd:bayesgraph} to check convergence, {cmd:bayesstats}
{cmd:summary} to estimate functions of model parameters, {cmd:bayesstats}
{cmd:ic} and {cmd:bayestest} {cmd:model} to compute Bayes factors and compare
Bayesian models, and {cmd:bayestest} {cmd:interval} to perform interval
hypotheses testing.

{pmore}
See {manhelp bayes BAYES} and
{manhelp bayesian_estimation BAYES:bayesian estimation}.


{marker wndsge}{...}
{pstd}
{bf:Highlight 3. Linearized dynamic stochastic general equilibrium (DSGE) models}

{pmore}
Stata now fits linearized DSGE models, which are time-series models used in
economics.  These models are an alternative to traditional forecasting models.
Both attempt to explain aggregate economic phenomena, but DSGE
models do this on the basis of models derived from microeconomic
theory.

{pmore}
Being based on microeconomic theory means lots of equations.  The key feature
of these equations is that expectations of future variables affect variables
today.  This is one feature that distinguishes DSGEs from a vector
autoregression or a state-space model.  The other feature is that, being
derived from theory, the parameters can usually be interpreted in terms of that
theory.

{pmore}
You specify the equations with the {cmd:dsge} command.  Here is a
two-equation model:

{phang3}
{cmd:. dsge (p = {beta}*E(f.p) + {kappa}*y) (f.y = {rho}*y, state)}

{pmore}
{cmd:p} is a control variable, and {cmd:y} is a state variable in
state-space jargon.  {cmd:f.} is the forward operator.  These equation
say the following:

{p 12 16 2}
1.
The control variable {cmd:p} depends on {cmd:p} in the future 
  plus kappa times {cmd:y} today.

{p 12 16 2}
2.
The expected future value of {cmd:y} is rho times {cmd:y}
  today.  The {cmd:state} option specifies that {cmd:y} is a
  state variable.

{pmore}
There are three kinds of variables in DSGE models.  Control
variables and equations such as {cmd:p} have no shocks and are
determined by the system of equations.  State variables such as {cmd:y}
have implied shocks and are predetermined at the beginning of the time
period.  Shocks are the stochastic errors that drive the system.

{pmore}
In any case, the above {cmd:dsge} command would define a model and
fit it.

{pmore}
If we have a theory about the relationship between beta and
kappa, such as they are equal, we could now test it using {cmd:test}.

{pmore}
Postestimation commands {cmd:estat} {cmd:policy} and {cmd:estat}
{cmd:transition} report the policy and transition matrices.  If you type

            {cmd:. estat policy}

{pmore}
the control variables as a linear function of the state variables will be
displayed.  If you had five control variables and three state variables, each
of the controls would be reported as a linear function of the three states.
In the simple example above, the linear function predicting {cmd:p} will be
shown as a function of {cmd:y} today.

            {cmd:. estat transition}

{pmore}
reports the transition matrix.  Whereas the policy matrix reports {cmd:p} as a
function of {cmd:y}, the transition matrix reports how {cmd:y} evolves through
time exclusive of {cmd:p}.

{pmore}
You can produce forecasts using Stata's existing {cmd:forecast} command.
You can graph impulse-response functions using Stata's existing 
{cmd:irf} command.

{pmore}
See {manlink DSGE Intro}.


{marker wnerm}{...}
{pstd}
{bf:Highlight 4. Extended regression models (ERMs)}

{pmore}
ERMs is our name for 
regression models that can account for the following:

{p 12 16 2}
1.  Endogenous covariates 

{p 12 16 2}
2.  Nonrandom treatment assignment

{p 12 16 2}
3.  Heckman-style endogenous sample selection

{pmore}
The features may be used in any combination.  And it has yet
another feature:

{p 12 16 2}
4.  Forbidden regressions

{pmore}
You can fit models with interactions of endogenous covariates with
other covariates, exogenous or endogenous, continuous or dummy, and
this includes models containing interactions of an endogenous
variable with itself -- or said another way, with polynomials of
endogenous variables!

{pmore}
In the past, you might have used {cmd:heckman} to fit a linear model
with endogenous sample selection or {cmd:ivregress} to fit a linear
model with an endogenous covariate, and if you had both problems
in one dataset, you were out of luck.  You can now use the new 
{cmd:eregress} command to fit a model to account for both: 

            {cmd:. eregress y x, select(selvar = x z1 y2) endogenous(y2 = x z2)}

{pmore}
If you instead have endogenous treatment assignment and an
endogenous covariate, type

            {cmd:. eregress y x, entreat(trtvar = x z1 y2) endogenous(y2 = x z2)}

{pmore}
There are four ERM commands.

{p2colset 7 35 37 2}{...}
{p2coldent:New command}Fits{p_end}
{p2line}
{p2coldent :{helpb eregress}}linear regression{p_end}
{p2coldent :{helpb eintreg}}interval regression, including tobit{p_end}
{p2coldent :{helpb eprobit}}probit binary outcome{p_end}
{p2coldent :{helpb eoprobit}}ordered probit ordered categorical outcome{p_end}
{p2line}
{p2colreset}{...}

{pmore}
Notes:

{p 12 16 2}
1.
If you use the treatment-effect features, use {cmd:estat} {cmd:teffects}
after model fitting to obtain treatment effects and potential-outcome
means.

{p 12 16 2}
2.
All the standard postestimation commands are available.  {cmd:predict}
provides predicted values.  {cmd:margins} computes marginal effects and
marginal and conditional mean.

{pmore}
Regressors can be exogenous or endogenous.

{pmore}
Endogenous regressors can be continuous, binary, or ordinal.

{pmore}
Treatment can be endogenous or exogenous.  The treatment variable
can be binary or ordinal, which is to say, treatment can be 
multivalued.

{pmore}
Endogenous selection can be modeled using probit or tobit.

{pmore}
You can now fit models that were previously unavailable, even if you
need only one of the new features, such as

            o   interval regression with endogenous covariates
            o   probit regression with a binary endogenous covariate
            o   probit regression with endogenous ordinal treatment 
            o   ordered probit regression with endogenous treatment 
            o   linear regression with tobit endogenous sample selection

{pmore}
See {manlink ERM Intro 8} for an overview and see
{manhelp eregress ERM},
{manhelp eprobit ERM},
{manhelp eoprobit ERM}, and
{manhelp eintreg ERM}.


{marker wndynamicdocs}{...}
{pstd}
{bf:Highlight 5. Dynamic documents using Markdown}

{pmore}
Markdown is a standard markup language that provides text
formatting from plain text input.  It was designed to be easily
converted into HTML, the language of the web.  Stata now
supports it.

{pmore}
You can create HTML files from your Stata output, including graphs.  You will
start with a plain text file containing Markdown-formatted text and dynamic
tags specifying instruction to Stata, such as run this regression or produce
that graph.  You then use the new {cmd:dyndoc} command to convert the file to
HTML, 

{pmore}
Want to produce TeX documents?  With the new {cmd:dyntext} command, 
you can produce any text-based document!

{pmore}
See {manhelp dyndoc P}, {manhelp dyntext P}, {manhelp markdown P}, and
{manhelp dynamic_tags P:dynamic tags}.


{marker wnnonlinearme}{...}
{pstd}
{bf:Highlight 6. Nonlinear mixed-effects models}

{pmore}
Stata now fits nonlinear mixed-effects models, also known as
nonlinear multilevel models and nonlinear hierarchical models.
These models can be thought of two ways.  You can think of them as
nonlinear models containing random effects.  Or you can think of them
as linear mixed-effects models in which some or all fixed and
random effects enter nonlinearly.  However you think of them, the
overall error distribution is assumed to be Gaussian.

{pmore}
These models are popular because some problems are not, says their
science, linear in the parameters.  These models are popular in
population pharmacokinetics, bioassays, and studies of biological
and agricultural growth processes.  For example, nonlinear
mixed-effects models have been used to model drug absorption in the
body, intensity of earthquakes, and growth of plants.

{pmore}
The new estimation command is {cmd:menl}.  It implements the
popular-in-practice Lindstrom-Bates algorithm, which is based on
the linearization of the nonlinear mean function with respect to
fixed and random effects.  Both maximum likelihood and restricted
maximum-likelihood estimation methods are supported.

{pmore}
{cmd:menl} is easy to use.  Single equations can be entered directly, 
such as 

{phang3}
{cmd:. menl weight = ({b1}+{U[plant]})/(1+exp(-(age-{b2})/{b3}))}

{pmore}
which would fit 

	                 b_1 + U_plant
             weight =  ----------------------------- + epsilon
		       1 + exp{-({cmd:age}-b_2)/b_3}

{pmore}
To be estimated are b_1, b_2, and b_3.  U_plant is a random intercept for each
plant.

{pmore}
{cmd:menl} also allows multistage or hierarchical specifications
in which parameters of interest can be defined at each level of
hierarchy as functions of other model parameters and random
effects, such as 

{phang3}
{cmd:. menl weight = {phi1:}/(1+exp(-(age-{phi2:})/{phi3:})),}
{cmd:define(phi1:{b1}+{U1[plant]}) define(phi2:{b2}+{U2[plant]})}
{cmd:define(phi3:{b3}+{U3[plant]})}

{pmore}
This is the same model except that b_2 and b_3 are allowed 
to vary across plants.

{pmore}
Several variance-covariance structures are available to model the
dependence of random effects at the same level of hierarchy.  If we
wanted, we could have put dependence between {cmd:U1}, {cmd:U2},
and {cmd:U3} in the above example.

{pmore}
There is a within-group error in the model, epsilon.  Flexible
variance-covariance structures are available to model its
heteroskedasticity and its within-group dependence.  For
example, heteroskedasticity can be modeled as a power function of a
covariate or even of predicted mean values, and dependence can be
modeled using an autoregressive model of any order.

{pmore}
In addition to standard features, postestimation features also include
prediction of random effects and their standard errors, prediction of
parameters of interest defined in the model as functions of other model
parameters and random effects, estimation of the overall within-cluster
correlation matrix, and more.

{pmore}
See {manhelp menl ME} and {manhelp menl_postestimation ME:menl postestimation}.


{marker wnsp}{...}
{pstd}
{bf:Highlight 7. Spatial autoregressive (SAR) models}

{pmore}
Stata now fits SAR models, also known as simultaneous autoregressive models.
The new {cmd:spregress}, {cmd:spivregress}, and {cmd:spxtregress} commands
allow spatial lags of the dependent variable, spatial lags of the independent
variables, and spatial autoregressive errors.  Spatial lags are the spatial
analog of time-series lags.  Time-series lags are values of variables from
recent times.  Spatial lags are values from nearby areas.

{pmore}
The models are appropriate for area (also known as areal) data.
Observations are called spatial units and might be countries, states,
districts, counties, cities, postal codes, or city blocks.  Or they
might not be geographically based at all.  They could be nodes of a social
network.  Spatial models estimate direct effects -- the effects of areas
on themselves -- and estimate indirect or spillover effects -- effects
from nearby areas.

{pmore}
Stata provides a suite of commands for working with spatial
data and a new
{mansection SP spSpatialAutoregressiveModels:{bf:[SP]}}
manual to accompany them.
When spatial units are geographically based, you can download standard-format
shapefiles from the web that defines the map.  With a single command, you can
make spillover effects proportional to the inverse distance between areas or
restrict them to be just from neighboring areas.  And you can create your own
custom definitions of proximity.

{pmore}
Provided for fitting models are the following:

{p2colset 7 33 35 2}{...}
{p2coldent:Command}Description{space 19}Equivalent to{p_end}
{p2line}
{p2coldent :{helpb spregress:spregress, gs2sls}}GS2SLS{space 24}{helpb regress}{p_end}
{p2coldent :{helpb spregress:spregress, ml}}maximum likelihood{space 12}{helpb regress}{p_end}

{p2coldent :{helpb spivregress}}endogenous regressors{space 9}{helpb ivregress}{p_end}

{p2coldent :{helpb spxtregress:spxtregress, fe}}panel-data fixed effects{space 6}{helpb xtreg:xtreg, fe}{p_end}
{p2coldent :{helpb spxtregress:spxtregress, re}}panel-data random effects{space 5}{helpb xtreg:xtreg, re}{p_end}
{p2line}
{p2colreset}{...}

{pmore}
See {manlink SP Intro}.


{marker wnintcensparam}{...}
{pstd}
{bf:Highlight 8. Interval-censored parametric survival-time models}

{pmore}
Stata's new {cmd:stintreg} command joins {cmd:streg} for fitting 
parametric survival models.  {cmd:stintreg} fits models to
interval-censored data.  In interval-censored data, the time of
failure is not exactly known.  What is known, subject by subject,
is a time when the subject had not yet failed and a later time when
the subject already had failed.

{pmore}
{cmd:stintreg} can fit exponential, Weibull, Gompertz, lognormal,
loglogistic, and generalized gamma survival-time models.  Both
proportional-hazards and accelerated failure-time metrics are
supported.  Features include

{phang3}
o{space 3}stratified estimation

{phang3}
o{space 3}flexible modeling of ancillary parameters

{phang3}
o{space 3}robust, cluster-robust, bootstrap, and jackknife standard errors

{pmore}
Survey-data estimation is supported via the {cmd:svy} prefix.

{pmore}
In addition to the usual features, postestimation features also
include plots of survivor, hazard, and cumulative hazard functions,
prediction of mean and median times, Cox-Snell and martingale-like
residuals, and more.

{pmore}
See {manhelp stintreg ST} for details.


{marker wnfmm}{...}
{pstd}
{bf:Highlight 9. Finite mixture models (FMMs)}

{pmore}
The new {cmd:fmm:} prefix command can be used with 17 Stata estimation
commands to FMMs.  The commands are the following:

{p2colset 7 35 37 2}{...}
{p2coldent:Command}Fits{p_end}
{p2line}
{p2coldent :{helpb fmm betareg:fmm: betareg}}Beta regression{p_end}
{p2coldent :{helpb fmm cloglog:fmm: cloglog}}Complementary log-log regression{p_end}
{p2coldent :{helpb fmm glm:fmm: glm}}Generalized linear models{p_end}
{p2coldent :{helpb fmm intreg:fmm: intreg}}Interval-censored regression{p_end}
{p2coldent :{helpb fmm ivregress:fmm: ivregress}}Instrumental-variable regression{p_end}
{p2coldent :{helpb fmm logit:fmm: logit}}Logistic regression{p_end}
{p2coldent :{helpb fmm mlogit:fmm: mlogit}}Multinomial logistic regression{p_end}
{p2coldent :{helpb fmm nbreg:fmm: nbreg}}Negative binomial regression{p_end}
{p2coldent :{helpb fmm ologit:fmm: ologit}}Ordered logistic regression{p_end}
{p2coldent :{helpb fmm oprobit:fmm: oprobit}}Ordered probit regression{p_end}
{p2coldent :{helpb fmm poisson:fmm: poisson}}Poisson regression{p_end}
{p2coldent :{helpb fmm probit:fmm: probit}}Probit regression{p_end}
{p2coldent :{helpb fmm regress:fmm: regress}}Linear regression{p_end}
{p2coldent :{helpb fmm streg:fmm: streg}}Parametric survival-time regression{p_end}
{p2coldent :{helpb fmm tobit:fmm: tobit}}Tobit regression{p_end}
{p2coldent :{helpb fmm tpoisson:fmm: tpoisson}}Truncated Poisson regression{p_end}
{p2coldent :{helpb fmm truncreg:fmm: truncreg}}Truncated linear regression{p_end}
{p2line}
{p2colreset}{...}

{pmore}
{cmd:fmm} fits models when the data come from unobserved subpopulations. 
That is a broad statement and {cmd:fmm:} can support it.

{pmore}
The most typical use of {cmd:fmm:} is to fit one model and
allow the parameters (coefficients, location, variance, scale,
etc.) to vary across subpopulations.  We will call these unobserved
subpopulations classes.  Say we are interested in

            {cmd:. regress y x1 x2}

{pmore}
but we believe there are three classes across which the parameters
of the model might vary.  Even though we have no variable recording
the class membership, we can fit

            {cmd:. fmm 3:  regress y x1 x2}

{pmore}
Reported will be separate models for each class and a model for
predicting membership in them.

{pmore}
{cmd:fmm:} can be used with multiple estimation commands
simultaneously when the classes might follow different models, such as 

            {cmd:. fmm: (regress y x1 x2) (poisson y x1 x2 x3)}

{pmore}
In this two-class example, reported will be a linear regression
model for the first class, a Poisson regression for the second, and
a model that predicts class membership.

{pmore}
Postestimation commands are available to 1) estimate each class's proportion
in the overall population ({manhelp fmm_estat_lcprob FMM:estat lcprob});
2) report marginal means of the outcome variables within class
({manhelp fmm_estat_lcmean FMM:estat lcmean}); and 3) predict
probabilities of class membership and predicted outcomes
({manhelp fmm_postestimation FMM:fmm postestimation}).

{pmore}
See {manlink FMM fmm intro}.


{marker wnmixedlogit}{...}
{pstd}
{bf:Highlight 10. Mixed logit models}

{pmore}
Stata fits discrete choice models.  Stata 15 will fit them with
random coefficients.  Discrete choice is another way of saying
multinomial or conditional logistic regression.  The word "mixed" is
used by statisticians whenever some coefficients are random and
others are fixed.  Ergo, Stata 15 fits mixed logit models.

{pmore}
Random coefficients arise for many reasons, but there is a
special reason researchers analyzing discrete choices might be
interested in them.  Random coefficients are a way around the
IIA assumption.  If you have a choice among walking, public
transportation, or a car and you choose walking, the other two
alternatives are irrelevant.  Take one of them away, and you would
still choose walking.  Human beings sometimes violate this
assumption, at least judged by their behavior.

{pmore}
Mathematically speaking, IIA makes alternatives independent
after conditioning on covariates.  If IIA is violated, then
the alternatives would be correlated.  Random coefficients allow that.

{pmore}
A requirement for fitting random coefficients is that the variable
varies across the alternatives.  Thus the mixed logit model is
often said to incorporate alternative-specific variables.

{pmore}
The new Stata 15 command that fits this is named {cmd:asmixlogit}.

{pmore}
The new command also allows the random coefficients to be drawn
from different distributions.  One might be normal and another log
normal.  Also supported are multivariate normal, truncated normal,
uniform, and triangular distributions.

{pmore}
See {manhelp asmixlogit R}.


{marker wnnonparamreg}{...}
{pstd}
{bf:Highlight 11. Nonparametric regression, kernel methods}

{pmore}
Stata now fits nonparametric regressions.  In these models, you do
not specify a functional form.  You specify 

            y = g(x_1, x_2, ..., x_k) + epsilon

{pmore}
and g(.) is fit.  The method does not assume that
g(.) is linear; it could just as well be 

            y = beta_1 x_1 + beta_2 x_2^2 + beta_3 x_1 x_2 + ...

{pmore}
and it does not even assume it is linear in the parameters.  It could
just as well be 

           y = beta_1 x_1^{beta_2} + beta_3 cos(x_2+x_3) + ...

{pmore}
or anything else.  The result is not returned to you in algebraic
form, but predicted values and derivatives can be calculated.

{pmore}
The new {cmd:npregress} command fits the models using local-linear or
local-constant kernel regression.  Be aware that fitting accurate
nonparametric regressions needs lots of observations.  Stata does
not limit k, but practical issues do.

{pmore}
You might type

            {cmd:. npregress kernel y x1 x2 x3, vce(bootstrap)}

{pmore}
Reported will be the averages of the partial derivatives of {cmd:y} 
with respect to {cmd:x1}, {cmd:x2}, and {cmd:x3} and their standard
errors, which are obtained by bootstrapping.  The averages are
calculated over the data.  After fitting the model, you could
obtain predicted values using {cmd:predict}.

{pmore}
Average derivatives are something like coefficients, or at least
they would be if the model were linear, which it is not.  Realize
that average derivatives in nonlinear models are not derivatives at
the average.  You might want to know the derivative of {cmd:y}
w.r.t. {cmd:x1}, {cmd:x2}, and {cmd:x3} at the average values of
{cmd:x1}, {cmd:x2}, and {cmd:x3}.  You can use {cmd:margins} to
obtain that:

            {cmd:. margins, dydx(x1 x2 x3) atmeans}

{pmore}
Or perhaps you want the predicted values evaluated at specific
points of interest, 

            {cmd:. margins, at(x1=2 x2=3 x3=1) at(x1=2 x2=3 x3=2)}

{pmore}
If you wanted {cmd:x3} to be 1, 2, ..., 10, you could type 

            {cmd:. margins, at(x1=2 x2=3 x3=1(1)10)}

{pmore}
Then, you could type 

            {cmd:. marginsplot}

{pmore}
to graph this slice of the function.

{pmore}
By the way, {cmd:margins} not only makes calculations, it can also produce
bootstrap standard errors for them.

{pmore}
See {manhelp npregress R}.


{marker wnpowerclustrand}{...}
{pstd}
{bf:Highlight 12. Power analysis for linear regression, cluster randomized designs, and your own methods}

{pmore}
Stata's {cmd:power} command performs power and sample-size analysis
(PSS).  Its features now include PSS for linear
regression and for cluster randomized designs (CRDs).  In
addition, you can now add your own power and sample-size methods
to the {cmd:power} command.

{pmore}
The new PSS methods for linear regression include the following:

{phang2}
o{space 3}{cmd:power oneslope} performs PSS for a slope
    test in a simple linear regression.  It computes sample
    size or power or the target slope given other study
    parameters.  See {manhelp power_oneslope PSS:power oneslope}.

{phang2}
o{space 3}{cmd:power rsquared} performs PSS for an R^2
    test in a multiple linear regression.  An R^2 test is
    an F test for the coefficient of determination (R^2).
    The test can be used to test the significance of all the
    coefficients, or it can be used to test a subset of them.

{pmore2}
    In both cases, {cmd:power rsquared} computes sample size or
    power or the target R^2 given other study parameters.
    See {manhelp power_rsquared PSS:power rsquared}.

{phang2}
o{space 3}{cmd:power pcorr} performs PSS for a
    partial-correlation test in a multiple linear regression.  A
    partial-correlation test is an F test of the squared
    partial multiple correlation coefficient.
    The command computes sample size or power or the
    target squared partial correlation coefficient given other study
    parameters.  See {manhelp power_pcorr PSS:power pcorr}.

{pmore}
The new PSS methods for CRDs include the following:

{pmore2}
 The five existing {cmd:power} methods listed below, extended to
 support CRDs or clustered data when you specify new
 option {cmd:cluster}.

{p2colset 13 46 48 2}{...}
{p2coldent:Command}Title{p_end}
{p2line}
{p2coldent :{helpb power onemean, cluster}}One-sample mean test in a CRD{p_end}
{p2coldent :{helpb power oneproportion, cluster}}One-sample proportion test in a CRD{p_end}
{p2coldent :{helpb power twomeans, cluster}}Two-sample means test in a CRD{p_end}
{p2coldent :{helpb power twoproportions, cluster}}Two-sample proportions test in a CRD{p_end}
{p2coldent :{helpb power logrank, cluster}}Log-rank test in a CRD{p_end}
{p2line}
{p2colreset}{...}

{pmore2}
 In a CRD, groups of subjects (clusters) are randomized
 instead of individual subjects, so the sample size is
 determined by the number of clusters and the cluster size.
 The sample-size determination consists of the determination of
 the number of clusters given cluster size or the determination
 of cluster size given the number of clusters.  The commands
 compute one of the number of clusters, cluster size, power, or
 minimum detectable effect size given other parameters and
 provide options to adjust for unequal cluster sizes.

{pmore2}
 For two-sample methods, you can also adjust for unequal
 numbers of clusters in the two groups.

{pmore}
As with all other power methods, the new methods allow you to
specify multiple values of parameters and automatically produce
tabular and graphical results.

{pmore}
The final new feature is that you can add your own PSS
methods.  How you do that is now documented in
{manhelpi power_usermethod PSS:power usermethod}.  It is easy to do.  You write
a program that computes sample size or power or effect size.  The {cmd:power}
command will do the rest for you.  It will deal with the support of multiple
values in options and with the automatic generation of graphs and tables of
results.


{marker wnpdfword}{...}
{pstd}
{bf:Highlight 13. Produce PDF and Word documents}

{pmore}
It is now just as easy to produce PDF and Word documents in Stata as it is to
produce Excel worksheets.  Everybody loved {cmd:putexcel} in Stata 14.  If you
are among them, you will love {cmd:putpdf} and {cmd:putdocx}.

{pmore}
They work just like {cmd:putexcel}.  That means you can write
do-files to create entire PDF or Word reports containing
the latest results, tables, and graphs.  You can automate
reproducible reports.

{pmore}
The new {cmd:putpdf} command writes paragraphs, images, and tables
to a PDF file.  Images include Stata graphs and other images such 
as your organization's logo.  You can format the objects, too -- bold
face, italics, size, custom tables, etc.

{pmore}
The new {cmd:putdocx} command writes paragraphs, images, and tables
to a Word file or, to be precise about it, to Office Open XML
({cmd:.docx}) files.  Just as with {cmd:putpdf}, images include 
Stata graphs, and you can format the objects.

{pmore}
See {manhelp putpdf P} and {manhelp putdocx P}.


{marker wngraphcolor}{...}
{pstd}
{bf:Highlight 14. Graph color transparency or opacity}

{pmore}
Up until now, graph one thing on top of any other, and the object on
top covered up the object below.  In the jargon, Stata's colors are
fully opaque or, if you prefer, not at all transparent.  Stata 15
still works that way by default.  Stata 15, however, allows you to
control the opacity (transparency) of its colors.

{pmore}
Opacity is specified at a percent.  By default, Stata's colors are
100% opaque.

{pmore}
You can specify opacity whenever you specify a color, such as in the
{cmd:mcolor()} option, which controls the colors of markers.  Rather than
specifying {cmd:green}, you can now specify {cmd:green%50}.  Rather than
specifying {cmd:"0 255 0"} (equivalent to green), you can specify
{cmd:"0 255 0%50"}.  And you can simply specify {cmd:%50} to make the default
color 50% opaque.

{pmore}
You usually do not want to specify {cmd:%0}.  Yes, it is fully 
transparent, but it is also invisible.

{pmore}
Here is a graph where we use {cmd:%70}:

{phang3}
{cmd:. twoway rarea high open date in 1/15, color(red%70) ||}
{cmd:rarea low close date in 1/15, color(green%70)}


{marker wnicd10}{...}
{pstd}
{bf:Highlight 15. ICD-10-CM and ICD-10-PCS support}

{pmore}
Stata 15 now supports ICD-10-CM and ICD-10-PCS, the U.S.
ICD-10 codes provided by the National Center for Health Statistics
(NCHS) and the Centers for Medicare and Medicaid Services
(CMS).  These are the codes mandated for all medical billing in the
United States.

{pmore}
Stata has long supported ICD codes for reporting medical
diagnosis, procedures, and mortality.  ICD stands for
international statistical classification of diseases and related
health problems.  Stata began support of the code in 1998 starting
with ICD-9-CM version 16 and supported all
revisions after that.

{pmore}
Stata supports ICD-10 codes revisions since 2003.

{pmore}
See {manhelp icd D}, {manhelp icd10cm D}, and {manhelp icd10pcs D}.


{marker wnfred}{...}
{pstd}
{bf:Highlight 16. Federal Reserve Economic Data support}

{pmore}
The St. Louis Federal Reserve makes available over 470,000
U.S. and international economic and financial time series to registered users.
Registering is free and easy to do.  The service is called FRED.  FRED
includes data from 84 sources, including the Federal Reserve, the Penn World
Table, Eurostat, and the World Bank.

{pmore}
In Stata 15, you can use Stata's GUI to access and download
FRED data.  You search or browse by category or release or
source.  You click to select series of interest.  Select 1 or
select 100.  When you click on {bf:Import}, Stata will download
them and combine them into a single, custom dataset in memory.

{pmore}
These same features are also available from Stata's command line
interface.  The command is {cmd:import fred}.  The command is
convenient when you want to automate updating the 27 different series that you
are tracking for a monthly report.

{pmore}
Stata can access FRED and it can access ALFRED.
ALFRED is FRED's historical archive data.

{pmore}
See {manhelp import_fred D:import fred}.


{marker NewStat}{...}
{title:1.3.2  What's new in statistics (general)}

{pstd}
Finite mixture models is 
{help whatsnew14to15##wnfmm:{it:Highlight 9}}
of the release, mixed-logit
models is 
{help whatsnew14to15##wnmixedlogit:{it:Highlight 10}},
and nonparametric regression is
{help whatsnew14to15##wnnonparamreg:{it:Highlight 11}}.

{pstd}
Also new are the following:

{p 5 9 2}
1.  {bf:bayes: prefix works with general-purpose estimation commands}

{p 9 9 2}
The new {cmd:bayes:} prefix 
({help whatsnew14to15##wnbayes:{it:Highlight 2}} of the releases) works with
many of the general-purpose estimation commands:

{p2colset 13 35 37 2}{...}
{p2coldent:Command}Purpose{p_end}
{p2line}
{p2coldent :{helpb bayes betareg:betareg}}Beta regression{p_end}
{p2coldent :{helpb bayes binreg:binreg}}Binomial regression{p_end}
{p2coldent :{helpb bayes biprobit:biprobit}}Bivariate probit regression{p_end}
{p2coldent :{helpb bayes clogit:clogit}}Conditional logistic regression{p_end}
{p2coldent :{helpb bayes cloglog:cloglog}}Complementary log-log regression{p_end}
{p2coldent :{helpb bayes fracreg:fracreg}}Fractional-outcome regression{p_end}
{p2coldent :{helpb bayes glm:glm}}Generalized linear model{p_end}
{p2coldent :{helpb bayes gnbreg:gnbreg}}Generalized negative binomial regression{p_end}
{p2coldent :{helpb bayes heckman:heckman}}Heckman selection model{p_end}
{p2coldent :{helpb bayes heckoprobit:heckoprobit}}Heckman ordered probit with sample selection{p_end}
{p2coldent :{helpb bayes heckprobit:heckprobit}}Heckman probit with sample selection{p_end}
{p2coldent :{helpb bayes hetprobit:hetprobit}}Heteroskedastic probit regression{p_end}
{p2coldent :{helpb bayes hetregress:hetregress}}Heteroskedastic linear regression{p_end}
{p2coldent :{helpb bayes intreg:intreg}}Interval linear regression{p_end}
{p2coldent :{helpb bayes logistic:logistic}}Logistic regression (default odds ratio){p_end}
{p2coldent :{helpb bayes logit:logit}}Logistic regression (default coefficients){p_end}
{p2coldent :{helpb bayes mlogit:mlogit}}Multinomial logistic regression{p_end}
{p2coldent :{helpb bayes mprobit:mprobit}}Multinomial probit regression{p_end}
{p2coldent :{helpb bayes mvreg:mvreg}}Multivariate linear regression{p_end}
{p2coldent :{helpb bayes nbreg:nbreg}}Negative binomial regression{p_end}
{p2coldent :{helpb bayes ologit:ologit}}Ordered logistic regression{p_end}
{p2coldent :{helpb bayes oprobit:oprobit}}Ordered probit regression{p_end}
{p2coldent :{helpb bayes poisson:poisson}}Ordered Poisson regression{p_end}
{p2coldent :{helpb bayes probit:probit}}Probit regression{p_end}
{p2coldent :{helpb bayes regress:regress}}Linear regression{p_end}
{p2coldent :{helpb bayes tnbreg:tnbreg}}Truncated negative binomial regression{p_end}
{p2coldent :{helpb bayes tobit:tobit}}Tobit regression{p_end}
{p2coldent :{helpb bayes tpoisson:tpoisson}}Truncated Poisson regression{p_end}
{p2coldent :{helpb bayes truncreg:truncreg}}Truncated linear regression{p_end}
{p2coldent :{helpb bayes zinb:zinb}}Zero-inflated negative binomial regression{p_end}
{p2coldent :{helpb bayes zioprobit:zioprobit}}Zero-inflated ordered probit regression{p_end}
{p2coldent :{helpb bayes zip:zip}}Zero-inflated Poisson regression{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
        The list above is of general-purpose estimation commands.
        The {cmd:bayes:} prefix works with multilevel estimation
        commands, too.

{p 9 9 2}
        See {manhelp bayes BAYES} and
	{manhelp bayesian_estimation BAYES:bayesian estimation}.

{p 5 9 2}
2.  {bf:New command fits heteroskedastic regression}

{p 9 9 2}
New estimation command {cmd:hetregress} fits heteroskedastic
regression by modeling the variance as an exponential function
of the covariates you specify.  Two
estimation methods, maximum likelihood and Harvey's two-step
generalized least squares, are provided.  Robust,
cluster-robust, bootstrap, and jackknife standard errors are
supported.  Survey-data estimation is supported via the {cmd:svy}
prefix.

{p 9 9 2}
See {manhelp hetregress R}.

{p 5 9 2}
3.  {bf:New command fits Poisson regression with Heckman-style selection}

{p 9 9 2}
New estimation command {cmd:heckpoisson} fits a Poisson
regression model with endogenous sample selection.
All the standard postestimation features are provided.

{p 9 9 2}
See {manhelp heckpoisson R}.

{p 5 9 2}
4.  {bf:New command fits zero-inflated ordered probit regression}

{p 9 9 2}
New estimation command {cmd:zioprobit} fits zero-inflated
ordered probit models.  This model is used when data exhibit a
higher fraction of the zeros than is expected from a standard
ordered probit model.

{p 9 9 2}
We say 0, imagining that the dependent variable contains 0,
1, 2, ..., but we mean the lowest value of the outcome variable
because it could just as well contain 2, 5, 9, ....

{p 9 9 2}
The zero inflation is accounted for by assuming that the zeros
come from both a probit model and an ordered probit model.
Each model can have different covariates.

{p 9 9 2}
See {manhelp zioprobit R}.

{p 5 9 2}
5.  {bf:Tobit now accepts censoring limits and constraints}

{p 9 9 2}
Some people think of tobit as being censored at zero.  Stata's
{cmd:tobit} estimation command allows you to specify the lower
value of the censoring point, and it allows you to specify an
upper censoring point, too.  All that is unchanged.  You can
now specify censoring points -- upper, lower, or both -- that
vary observation by observation.  The censoring points can
be stored in variables.

{p 9 9 2}
{cmd:tobit} now allows constraints.

{p 9 9 2}
{cmd:tobit} now has the other standard features that it always
should have had, but that is just for completeness.  You can,
for instance, specify initial values.

{p 9 9 2}
See {manhelp tobit R}.

{p 5 9 2}
6.  {bf:tpoisson, ul()}

{p 9 9 2}
Existing estimation command {cmd:tpoisson} fits truncated
Poisson models.  It previously fit left-truncated models only.
It now fits left-, right-, and both-truncated models.  New
option {cmd:ul()} specifies the upper truncation limit.

{p 9 9 2}
See {manhelp tpoisson R}.

{p 5 9 2}
7.  {bf:Factor variables now work more like you would expect they would}

{p 9 9 2}
Consider fitting a model with the terms

            {cmd:.} {it:est_command} ... {cmd:i.a i(2 3).a#i.b} ...

{p 9 9 2}
What should happen?  What happens now should be more in line with your
expectations.  {cmd:i.a} adds main-effect coefficients for each level of
{cmd:a}, and the interaction {cmd:i(2 3).a#i.b} is restricted to {cmd:a}'s
levels 2 and 3.

{p 9 9 2}
What used to happen was rather more surprising.  The entire
RHS of the model was restricted to levels 2 and 3 of
{cmd:a}.

{p 5 9 2}
8.  {bf:One- and two-sample mean tests with clustered data}

{p 9 9 2}
Existing command {cmd:ztest} has new option {cmd:cluster()} and
other new options to account for clustering.

{p 9 9 2}
See {manhelp ztest R}.

{p 5 9 2}
9.  {bf:One- and two-sample proportion tests with clustered data}

{p 9 9 2}
Existing command {cmd:prtest} has new option {cmd:cluster()} and
other new options to account for clustering.

{p 9 9 2}
See {manhelp prtest R}.

{p 4 9 2}
10.  {bf:Note explaining interpretation of intercept when exponentiated coefficients reported}

{p 9 9 2}
Many estimation commands report exponentiated coefficients,
either by default or because you specified an option requesting
the odds ratio, incidence rate ratio, hazard ratio, and so on.
In those cases, Stata also reports the exponentiated intercept.
This confuses some people, especially students.  Stata now adds
a note at the end of the output explaining the interpretation
of the exponentiated intercept.

{p 9 9 2}
Notes also make clear which parameters are exponentiated.

{p 4 9 2}
11.  {bf:ivtobit has improved convergence}

{p 9 9 2}
Existing estimation command {cmd:ivtobit} fits instrumental-variable tobit
models.  It now converges more reliably when there are two or more endogenous
variables.

{p 4 9 2}
12.  {bf:New dots() option with replication methods}

{p 9 9 2}
Existing prefix commands {cmd:bootstrap}, {cmd:jackknife}, {cmd:permute}, and
{cmd:simulate} have new option {opt dots(#)}, which displays
dots every {it:#} replications.  This provides entertainment and
confirmation that the command is still working during long runs.

{p 9 9 2}
See {manhelp bootstrap R}, {manhelp jackknife R},
{manhelp permute R}, and {manhelp simulate R}.

{p 4 9 2}
13.  {bf:Option noskip renamed lrmodel}

{p 9 9 2}
Existing estimation commands 
{cmd:biprobit},
{cmd:heckman},
{cmd:heckprobit},
{cmd:hetprobit}, and
{cmd:truncreg}
had option {cmd:noskip}, which presented the
model test as a likelihood-ratio rather than the default Wald
test.  This option has been renamed {cmd:lrmodel}.  The old 
option name continues to work.  (There was a justification for
the old name.  Calculating the likelihood-ratio test requires
fitting the constant-only model.  {cmd:noskip} specified that
fitting of that model not be skipped!)

{p 4 9 2}
14.  {bf:hetprobit, waldhet (option rename)}

{p 9 9 2}
Existing estimation command {cmd:hetprobit} fits heteroskedastic
probit models.  Existing option {cmd:nolrtest} has been renamed
{cmd:waldhet}.  It tests whether the variance is
heteroskedastic.  Old option {cmd:nolrtest} continues to work
under version control.

{p 9 9 2}
See {manhelp hetprobit R}.

{p 4 9 2}
15.  {bf:Stata names free parameters in fitted models differently}

{p 9 9 2}
Free parameters are scalar parameters, variances, covariances,
and the like that are part of the model being fit.  A free
parameter might be ln(sigma).

{p 9 9 2}
We have made a deep change in the internals of Stata.  What
does this mean for you?  Not much.  If a model fits free
parameter {cmd:/lnsigma}, you can no longer refer to its value 
as {cmd:_b[lnsigma:_cons]}.  You must refer to it as
{cmd:_b[/lnsigma]}.  You probably always referred to it that way.
It involved less typing.

{p 9 9 2}
The renaming might matter in programs that you write; see the
next item.

{p 9 9 2}
Old syntax is preserved under version control.

{p 9 9 2}
See {manhelp ml R} and see the next item.

{p 4 9 2}
16.  {bf:Program your own models?  ml uses the new free-parameter syntax}

{p 9 9 2}
{cmd:ml} now allows and prefers that free parameters be specified
as {cmd:/}{it:name}.  You can no longer refer to them as if
they were constant-only equations, which is to say
{it:name}{cmd::}{cmd:_cons}, except under version control.

{p 9 9 2}
As explained in the previous item, {cmd:_b[/lnsigma]} is no
longer a shorthand for {cmd:_b[lnsigma:_cons]}.
{cmd:_b[/lnsigma]} is its own thing.  It is the free parameter
named {cmd:/lnsigma} and not the constant term from equation
{cmd:lnsigma}.

{p 9 9 2}
If you were using {cmd:ml} to fit your own maximum likelihood
model, you might create {cmd:/lnsigma} thinking you were
creating an equation named {cmd:lnsigma}.  You are not.  Now
you are creating a single free parameter.  If you want to
create a constant-only equation, you must use {cmd:(lnsigma:)},
which always meant to create an "equation" called {cmd:lnsigma}.

{p 9 9 2}
There are other implications for programmers writing advanced
code.  Matrix row and column names have changed and are now
easier to use.  This is mentioned in 
{help whatsnew14to15##NewP:{it:What's new in programming}}.

{p 9 9 2}
See {manhelp ml R}.

{p 4 9 2}
17.  {bf:More stored results}

{p 9 9 2}
Regular commands store their results in {cmd:r()}, and estimation commands
store them in {cmd:e()}.  There are now more of them.  If something
is reported, a result is stored even if what is reported could be 
calculated from the other stored results.


{marker NewME}{...}
{title:1.3.3  What's new in statistics (multilevel)}

{pstd}
Multilevel mixed-effects models are also known as
hierarchical models, nested data models, mixed models, random
coefficient models, random effects models, random parameter models,
and split-plot designs.

{pstd}
Nonlinear mixed models are 
{help whatsnew14to15##wnnonlinearme:{it:Highlight 6}} of the release.

{pstd}
Also new are the following:

{p 4 9 2}
18.  {bf:Multilevel mixed-effects tobit regression}

{p 9 9 2}
New estimation command {cmd:metobit} fits tobit models.  In tobit models,
outcomes below a limit or above a limit are censored.  Limits can be fixed
(say, 0 and 1,000) or vary observation by observation.

{p 9 9 2}
See {manhelp metobit ME}.

{p 4 9 2}
19.  {bf:Multilevel mixed-effects interval regression}

{p 9 9 2}
New estimation command {cmd:meintreg} fits interval regression
models.  In these models, the exact value of the dependent
variable is not observed in some or all observations.
Instead, y_i is known to be within [a_i,b_i].  Ranges can
be open ended, so the model handles censoring as well as
intervals.

{p 9 9 2}
See {manhelp meintreg ME}.

{p 4 9 2}
20.  {bf:bayes: prefix works with multilevel models}

{p 9 9 2}
Stata's new {cmd:bayes:} prefix command (see 
{help whatsnew14to15##wnbayes:{it:Highlight 2}}) may be used with the following:

{p2colset 13 38 40 2}{...}
{p2coldent:Estimation command}Fits multilevel mixed-effects ...{p_end}
{p2line}
{p2coldent :{helpb bayes mixed:bayes: mixed}}{space 2}linear regression{p_end}
{p2coldent :{helpb bayes metobit:bayes: metobit}}{space 2}tobit regression{p_end}
{p2coldent :{helpb bayes meintreg:bayes: meintreg}}{space 2}interval regression{p_end}
{p2coldent :{helpb bayes melogit:bayes: melogit}}{space 2}logistic regression{p_end}
{p2coldent :{helpb bayes meprobit:bayes: meprobit}}{space 2}probit regression{p_end}
{p2coldent :{helpb bayes mecloglog:bayes: mecloglog}}{space 2}complementary log-log regression{p_end}
{p2coldent :{helpb bayes mepoisson:bayes: mepoisson}}{space 2}Poisson regression{p_end}
{p2coldent :{helpb bayes menbreg:bayes: menbreg}}{space 2}negative binomial regression{p_end}
{p2coldent :{helpb bayes meglm:bayes: meglm}}{space 2}generalized linear model{p_end}
{p2coldent :{helpb bayes mestreg:bayes: mestreg}}{space 2}parametric survival models{p_end}
{p2line}
{p2colreset}{...}
     
{p 9 9 2}
See {manhelp bayes BAYES}.

{p 4 9 2}
21.  {bf:Standard deviations and correlations instead of variances and covariances}

{p 9 9 2}
New postestimation command {cmd:estat sd} displays random
effects and within-group error parameter estimates as standard
deviations and correlations instead of the variances and
covariances reported in the estimation output.

{p 9 9 2}
See {manhelp me_estat_sd ME:estat sd}.


{marker NewBAYES}{...}
{title:1.3.4  What's new in statistics (Bayesian)}

{pstd}
The new {cmd:bayes:} prefix command is 
{help whatsnew14to15##wnbayes:{it:Highlight 2}} of the release.

{pstd}
Also new are the following:

{p 4 9 2}
22.  {bf:bayesmh, eform()}

{p 9 9 2}
Existing estimation command {cmd:bayesmh} now allows the {cmd:eform} and
{opt eform(string)} options for reporting exponentiated coefficients
such as odds ratios, incidence rate ratios, and the like.

{p 9 9 2}
See {manhelp bayesmh BAYES}.

{p 4 9 2}
23.  {bf:bayesmh, show()}

{p 9 9 2}
Existing estimation command {cmd:bayesmh} now allows new 
option {opt show(paramlist)} to specify which 
model parameters should be presented in the output.
Option {cmd:show()} joins existing option {cmd:noshow()}.
Specify one, the other, or neither.

{p 9 9 2}
See {manhelp bayesmh BAYES}.

{p 4 9 2}
24.  {bf:bayesmh, showreffects}

{p 9 9 2}
Existing estimation command {cmd:bayesmh} now allows new 
option {cmd:showreffects} to specify that all random-effects 
estimates be presented in the output.  They are not displayed 
by default.

{p 9 9 2}
See {manhelp bayesmh BAYES}.

{p 4 9 2}
25.  {bf:Postestimation supports new bayes: prefix command} 

{p 9 9 2}
If you use the new {cmd:bayes:} prefix command with 
multilevel models such as {cmd:mixed} or {cmd:meglm}, 
{cmd:bayesgraph}, 
{cmd:bayesstats ess}, and 
{cmd:bayesstats summary} have new options.

{p 9 9 2}
New option {cmd:showreffects} displays the results for all 
random-effects parameters.

{p 9 9 2}
New option {cmd:showreffects()} displays 
specified random-effects parameters.

{p 9 9 2}
By default, results are displayed for all model parameters
except the random-effects parameters.

{p 9 9 2}
See {manhelp bayesian_postestimation BAYES:bayesian postestimation}.

{p 4 9 2}
26.  {cmd:bayesmh} with nonlinear models has the following
            updates to the linear-combination specifications within
            substitutable expressions:

{phang3}
1.  When you specify {cmd:{xb: x1 x2}}, the constant term is
                included automatically.  That is, {cmd:{xb: x1 x2}} is
                equivalent to

                    {cmd:{xb:x1}*x1 + {xb:x2}*x2 + {xb:_cons}}

{pmore3}
                You can suppress the constant term by specifying the new
                {cmd:noconstant} option such as {cmd:{xb: x1 x2, noconstant}}.

{phang3}
2.  The new {cmd:xb} option is required when you include only
                one variable in the linear-combination specification such as
                {cmd:{xb: z, xb}}.  The specification {cmd:{xb:z}} without the
                {cmd:xb} option corresponds to either a free parameter named
                {cmd:z} with the grouping label {cmd:xb} or a regression
                coefficient on variable {cmd:z} that was included in the
                previously defined linear combination {cmd:xb}.

{phang3}
3.  Regression coefficients of linear combinations are now
defined as {cmd:{c -(}}{it:xbname}{cmd::}{it:varname}{cmd:{c )-}} instead
of {cmd:{c -(}}{it:xbname}{cmd:_}{it:varname}{cmd:{c )-}}.  For example, if
you specify a linear combination {cmd:{c -(}xb: x1 x2{c )-}}, you refer to
regression coefficients of variables {cmd:x1} and {cmd:x2} as
{cmd:{c -(}xb:x1{c )-}}
and {cmd:{c -(}xb:x2{c )-}} instead of {cmd:{c -(}xb_x1{c )-}} and
{cmd:{c -(}xb_x2{c )-}}.

{p 9 9 2}
            The old behavior of linear-combination specifications is available
            under version control.

{p 4 9 2}
27.  {bf:Programmer alerts} 

{p 9 9 2}
If you consume matrix results from {cmd:e()} after {cmd:bayesmh}, 
be aware of two small labeling issues:

{phang3}
1.  Terms that were marked as omitted were not stored in
	 the matrix's row and column names.  They are now.
	 Old behavior is available under version control.

{phang3}
2.  {cmd:bayesmh} now includes equation labels in the
	 row and column names of {cmd:e(mean)} and {cmd:e(median)}.


{marker NewPSS}{...}
{title:1.3.5  What's new in statistics (power and sample size)}

{pstd}
New is the following:

{p 4 9 2}
28.  {bf:Power analysis for linear regression, cluster randomized designs, and your own methods}

{p 9 9 2}
Stata's {cmd:power} command now includes power and sample-size
analysis for linear regression and for cluster randomized
designs.  In addition, you can now add your own power and
sample-size methods to the {cmd:power} command.

{p 9 9 2}
This is 
{help whatsnew14to15##wnpowerclustrand:{it:Highlight 12}} of the release.


{marker NewST}{...}
{title:1.3.6  What's new in statistics (survival analysis)}

{pstd}
Stata's new ability to fit interval-censored parametric 
survival models is 
{help whatsnew14to15##wnintcensparam:{it:Highlight 8}} of the release.

{pstd}
Also new are the following:

{p 4 9 2}
29.  {bf:bayes: streg}

{p 9 9 2}
The new {cmd:bayes:} prefix command 
({help whatsnew14to15##wnbayes:{it:Highlight 2}})
can be used with existing estimation command {cmd:streg} to fit Bayesian
parametric survival models.

{p 9 9 2}
See {manhelp bayes_streg BAYES:bayes: streg}.

{p 4 9 2}
30.  {bf:fmm: streg}

{p 9 9 2}
The new {cmd:fmm:} prefix command 
({help whatsnew14to15##wnfmm:{it:Highlight 9}})
can be used with {cmd:streg} to fit finite mixtures of parametric
survival models.  See {manhelp fmm_streg FMM:fmm: streg}.

{p 4 9 2}
31.  {bf:streg, strata(i.varname)}

{p 9 9 2}
Existing estimation command {cmd:streg}'s option {cmd:strata()}
now allows a factor variable as an argument.  You can specify
{cmd:strata(i.agegroup)} for instance.  You can specify
{cmd:strata(i(2 4 6).agegroup} if you want the stratum to be 2, 4, 6,
and treat the other levels as baseline.

{p 9 9 2}
Previously, you specified {cmd:strata(agegroup)}, and the option
created new dummy variables in the dataset to include them in
the model.  If you specify {cmd:strata(agegroup}), it is now
interpreted as if you specified {cmd:strata(i.agegroup)}.  Old
behavior is preserved under version control.

{p 4 9 2}
32.  {bf:Better names for streg's free parameters}

{p 9 9 2}
 Free parameters in {cmd:streg} models now have more descriptive
 names.  The scale parameter ln sigma is now named
 {cmd:/lnsigma}, for instance, and not {cmd:/ln_sig}.  What was
 named {cmd:/ln_gam} is now named {cmd:/lngamma}.  What was
 named {cmd:/ln_the} is now named {cmd:/lntheta}.  You use the
 new names with {cmd:_b[]}.  You continue to use the old names
 under version control.


{marker NewSVY}{...}
{title:1.3.7  What's new in statistics (survey data)}

{pstd}
New features are the following:

{p 4 9 2}
33.  These new estimation commands may be used with 
the {cmd:svy:} prefix:

{p2colset 13 38 40 2}{...}
{p2coldent:Command}Purpose{p_end}
{p2line}
{p2coldent :{cmd:svy: asmixlogit}}Alternative-specific mixed logit regression{p_end}
{p2coldent :{cmd:svy: heckpoisson}}Poisson regression with sample selection{p_end}
{p2coldent :{cmd:svy: hetregress}}Heteroskedastic linear regression{p_end}
{p2coldent :{cmd:svy: stintreg}}Parametric interval-censored survival regression{p_end}
{p2coldent :{cmd:svy: zioprobit}}Zero-inflated ordered probit{p_end}

{p2coldent :}Multilevel mixed-effects ...{p_end}
{p2coldent :{cmd:svy: metobit}}{space 2}tobit regression{p_end}
{p2coldent :{cmd:svy: meintreg}}{space 2}interval regression{p_end}

{p2coldent :{cmd:svy: eregress}}Extended linear regression{p_end}
{p2coldent :{cmd:svy: eintreg}}Extended interval regression{p_end}
{p2coldent :{cmd:svy: eprobit}}Extended probit regression{p_end}
{p2coldent :{cmd:svy: eoprobit}}Extended ordered probit regression{p_end}

{p2coldent :{cmd:svy: gsem}}Generalized SEM, including latent class analysis{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
See {manhelp svy SVY}.

{p 4 9 2}
34.  The following existing estimation commands support 
combined use of {cmd:svy:} and {cmd:fmm:} to fit 
survey-adjusted finite mixture models:

{p2colset 13 38 40 2}{...}
{p2coldent:Command}Purpose{p_end}
{p2line}
{p2coldent :{cmd:svy: fmm: regress}}Linear regression{p_end}
{p2coldent :{cmd:svy: fmm: tobit}}Tobit regression{p_end}
{p2coldent :{cmd:svy: fmm: intreg}}Interval regression{p_end}
{p2coldent :{cmd:svy: fmm: truncreg}}Truncated regression{p_end}
{p2coldent :{cmd:svy: fmm: ivregress}}Instrumental-variable regression{p_end}
{p2coldent :{cmd:svy: fmm: logit}}Logistic regression{p_end}
{p2coldent :{cmd:svy: fmm: probit}}Probit regression{p_end}
{p2coldent :{cmd:svy: fmm: cloglog}}Conditional log-log regression {p_end}
{p2coldent :{cmd:svy: fmm: ologit}}Ordered logistic regression{p_end}
{p2coldent :{cmd:svy: fmm: oprobit}}Ordered probit regression{p_end}
{p2coldent :{cmd:svy: fmm: mlogit}}Multinomial logistic regression{p_end}
{p2coldent :{cmd:svy: fmm: poisson}}Poisson regression{p_end}
{p2coldent :{cmd:svy: fmm: nbreg}}Negative binomial regression{p_end}
{p2coldent :{cmd:svy: fmm: tpoisson}}Truncated Poisson regression{p_end}
{p2coldent :{cmd:svy: fmm: betareg}}Beta regression{p_end}
{p2coldent :{cmd:svy: fmm: glm}}Generalized linear model{p_end}
{p2coldent :{cmd:svy: fmm: streg}}Parametric survival regression{p_end}
{p2line}
{p2colreset}{...}

{p 9 9 2}
See {manhelp svy SVY} and {manhelp fmm FMM}.

{p 4 9 2}
35.  {bf:New dots() option}

{p 9 9 2}
Existing prefix commands {cmd:svy bootstrap:}, {cmd:svy jackknife:},
{cmd:svy brr:}, and {cmd:svy sdr:} allow new option {opt dots(#)}.  It
displays a dot every {it:#} replications.

{p 9 9 2}
See {manhelp svy_bootstrap SVY:svy bootstrap},
{manhelp svy_jackknife SVY:svy jackknife},
{manhelp svy_brr SVY:svy brr}, and
{manhelp svy_sdr SVY:svy sdr}.


{marker NewSEM}{...}
{title:1.3.8  What's new in statistics (SEM)}

{pstd}
Stata 15's new latent class analysis capabilities are 
{help whatsnew14to15##wnlatent:{it:Highlight 1}}
of the release.  Existing estimation command {cmd:gsem} performs
latent class analysis.

{pstd}
Also new are the following:

{p 4 9 2}
36.  {bf:Likelihood ratio, AIC, and BIC after classic latent class analysis}

{p 9 9 2}
New postestimation command {cmd:estat lcgof} reports the G^2
likelihood-ratio test after fitting classic latent class models
(logit outcome models).  The test compares the fitted model to the
saturated model.  The new command also reports AIC and
BIC.

{p 9 9 2}
See {manhelp sem_estat_lcgof SEM:estat lcgof}.

{p 4 9 2}
37.  {bf:Marginal means across latent classes}

{p 9 9 2}
New postestimation command {cmd:estat lcmean} computes marginal
means in latent class models for all response variables across
the latent classes.

{p 9 9 2}
See {manhelp sem_estat_lcmean SEM:estat lcmean}.

{p 4 9 2}
38.  {bf:Predicted marginal probability of class membership}

{p 9 9 2}
New postestimation command {cmd:estat lcprob} reports the
marginal probabilities of class membership in latent class
models.

{p 9 9 2}
See {manhelp sem_estat_lcprob SEM:estat lcprob}.

{p 4 9 2}
39.  {bf:New predictions after fitting latent class models}

{p 9 9 2}
Existing postestimation command {cmd:predict} has new 
options after fitting latent class models.  They are 

{phang2}
o{space 3}{cmd:predict, classpr} to predict latent class
   probabilities;

{phang2}
o{space 3}{cmd:predict, classposteriorpr} to predict posterior
       latent class probabilities;

{phang2}
o{space 3}{cmd:predict, mu marginal} to predict the overall expected
       value of each outcome by summing the latent class means
       weighted by the latent class probabilities;

{phang2}
o{space 3}{cmd:predict, mu pmarginal} to predict the overall
	expected value of each outcome by summing the latent
	class means weighted by the posterior latent class
	probabilities; and

{phang2}
o{space 3}{cmd:predict, mu class(}{it:#}{cmd:)} to predict 
	the expected value of each outcome for class {it:#}.

{p 9 9 2}
See {manhelp predict_after_gsem SEM:predict after gsem}.

{p 4 9 2}
40.  {bf:gsem now fits multiple-group models}

{p 9 9 2}
Existing estimation command {cmd:gsem}, whether used to fit the
new LCA models or the existing generalized SEM
models, now allows the {cmd:group()} option just as command
{cmd:sem} does.  You can type

            {cmd:. gsem} ...{cmd:, group(agegrp)}

{p 4 9 2}
41.  {bf:sem and gsem report multiple-group models in separate tables}

{p 9 9 2}
Both {cmd:sem} and {cmd:gsem} now report models in a more readable 
format.  Rather than a single table encompassing all multiple 
group parameters, separate tables are produced.

{p 9 9 2}
New option {cmd:byparm} produces the old output.

{p 9 9 2}
See {manhelp sem_reporting_options SEM:sem reporting options} and
{manhelp gsem_reporting_options SEM:gsem reporting options}.

{p 4 9 2}
42.  {bf:gsem now fits truncated Poisson models}

{p 9 9 2}
{cmd:gsem}, whether used to fit the
new LCA models or the existing generalized SEM
models, now fits truncated Poisson models if you specify option 
{cmd:family(poisson, ltruncated(}...{cmd:))}.

{p 9 9 2}
See {manhelp gsem_family_and_link_options SEM:gsem family-and-link options}.

{p 4 9 2}
43.  {bf:Variances and covariances as standard deviations and correlations}

{p 9 9 2}
New postestimation command {cmd:estat sd} after {cmd:gsem} 
reports the estimated variance components as standard deviations 
and correlations.

{p 9 9 2}
See {manhelp sem_estat_sd SEM:estat sd}.


{marker NewXT}{...}
{title:1.3.9  What's new in statistics (panel data)}

{pstd}
New features are the following:

{p 4 9 2}
44.  {bf:Cointegration test for nonstationary process in panel data}

{p 9 9 2}
The new {cmd:xtcointtest} command tests for cointegration in
nonstationary panel data.  It provides three methods, the ones
due to Kao, Pedroni, and Westerlund.  All assume the same null
hypothesis but differ on their specification of the alternative
hypotheses.

{p 9 9 2}
See {manhelp xtcointtest XT}.

{p 4 9 2}
45.  {bf:Option noskip renamed lrmodel}

{p 9 9 2}
Existing estimation commands
{cmd:xtcloglog}, 
{cmd:xtintreg}, 
{cmd:xtlogit}, 
{cmd:xtnbreg}, 
{cmd:xtologit},
{cmd:xtoprobit},
{cmd:xtpoisson}, 
{cmd:xtprobit}, 
{cmd:xtstreg}, and 
{cmd:xttobit}
had option {cmd:noskip}, which presented the model test as a
likelihood-ratio rather than the default Wald test.  This
option has been renamed {cmd:lrmodel}.  The old option name
continues to work.  (There was a justification for the old
name.  Calculating the likelihood-ratio test requires fitting
the constant-only model.  {cmd:noskip} specified that fitting
of that model not be skipped!)


{marker NewTS}{...}
{title:1.3.10 What's new in statistics (time series)}

{pstd}
Stata 15's new support for retrieving Federal Reserve Economic 
Data (FRED) is 
{help whatsnew14to15##wnfred:{it:Highlight 16}} of the release.

{pstd}
Also new are the following:

{p 4 9 2}
46.  {bf:Threshold regression}

{p 9 9 2}
 New estimation command {cmd:threshold} fits threshold
 regressions.  These are linear regressions in which the
 coefficients change by estimated cutpoints.
 This could be on the basis of time.  Then you have one 
 set of coefficients before the first threshold, another 
 set after the first and before the second, and so on.

{p 9 9 2}
 Or it could be on the basis of an exogenous variable.  In that
 case, you would have a set of coefficients when {cmd:x} < the first
 threshold, another set after the first and before the second, and so on.

{p 9 9 2}
 The lagged value of the dependent variable is an example of an
 exogenous variable.  In that case, you would have a set of coefficients
 when {cmd:l.y} < the first threshold, another set after the first and before
 the second, and so on.  This last case is known as the self-exciting
 threshold model.

{p 9 9 2}
 You can specify or estimate the number of threshold points.

{p 9 9 2}
 See {manhelp threshold TS}.

{p 4 9 2}
47.  {bf:Test for structural breaks after time-series regression}

{p 9 9 2}
 The new {cmd:estat} {cmd:sbcusum} command is for use 
 after {cmd:regress} on {cmd:tsset} data.

{p 9 9 2}
It tests for stability of coefficients based on the cumulative
sum (cusum) of either the recursive residuals or the ordinary
least-squares residuals.  This can be used to test for
structural breaks due to changes in regression coefficients
over time.

{p 9 9 2}
{cmd:estat sbcusum} also plots the cusum versus time along with 
confidence bands.  The graph provides additional information that
can help identify time periods in which the coefficients are 
unstable.

{p 9 9 2}
See {manhelp estat_sbcusum TS:estat sbcusum}.

{p 4 9 2}
48.  {bf:rolling, dots()}

{p 9 9 2}
Existing estimation command {cmd:rolling} fits rolling window 
and recursive linear regressions.  This can be time consuming.
It has new option {opt dots(#)}, which displays a dot
every {it:#} replications.  This is not only entertaining; it
provides information about the percent of the calculation
completed.

{p 9 9 2}
See {manhelp rolling TS}.


{marker NewMV}{...}
{title:1.3.11 What's new in statistics (multivariate)}

{pstd}
Latent class analysis is 
{help whatsnew14to15##wnlatent:{it:Highlight 1}} of the release.  It is an
alternative to cluster analysis.

{pstd}
Also new is the following:

{p 4 9 2}
49. {bf:New bayes: mvreg command}

{p 9 9 2}
Stata 15's new {cmd:bayes:} prefix command
({help whatsnew14to15##wnbayes:{it:Highlight 2}}
of the release) can be used with existing estimation command {cmd:mvreg}
to fit Bayesian multivariate regression models.

{p 9 9 2}
See {manhelp bayes BAYES},
{manhelp bayesian_estimation BAYES:bayesian estimation}, and
{manhelp mvreg MV}.


{marker NewFN}{...}
{title:1.3.12 What's new in functions}

{pstd}
Functions are used in expressions.  For instance, {cmd:log()} is a
function:

            {cmd:. generate lincome = log(income)}

{pstd}
The functions listed below are also available in both Stata and Mata.

{p 4 9 2}
50.  {bf:Cauchy distribution}

{p 9 9 2}
A new family of Cauchy distribution functions are provided:

{phang3}
{cmd:cauchyden(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)}
computes the density of the Cauchy distribution with location parameter {it:a}
and scale parameter {it:b}.

{phang3}
{cmd:cauchy(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the cumulative
distribution function of the Cauchy distribution with location parameter {it:a}
and scale parameter {it:b}.

{phang3}
{cmd:cauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the reverse
cumulative Cauchy distribution with location parameter {it:a} and scale
parameter {it:b}.

{phang3}
{cmd:invcauchy(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} computes the inverse
cumulative Cauchy distribution.  If
{cmd:cauchy(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invcauchy(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} = {it:x}.

{phang3}
{cmd:invcauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} computes the
inverse reverse cumulative Cauchy distribution.  If
{cmd:cauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invcauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} = {it:x}.

{phang3}
{cmd:lncauchyden(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the natural
logarithm of the density of the Cauchy distribution with location parameter
{it:a} and scale parameter {it:b}.

{phang3}
{cmd:rcauchy(}{it:a}{cmd:,}{it:b}{cmd:)} is a Cauchy random-number generator.
It computes Cauchy random variates with location parameter {it:a} and scale
parameter {it:b}.

{p 9 9 2}
See {manhelp density_functions FN:Statistical functions} and
{manhelp random_number_functions FN:Random-number functions}.

{p 4 9 2}
51.  {bf:Laplace distribution}

{p 9 9 2}
A new family of Laplace distribution functions are provided:

{phang3}
{cmd:laplaceden(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the density
of the Laplace distribution with mean {it:m} and scale parameter {it:b}.

{phang3}
{cmd:laplace(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the cumulative
distribution function of the Laplace distribution with mean {it:m} and scale
parameter {it:b}.

{phang3}
{cmd:laplacetail(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the reverse
cumulative Laplace distribution with mean {it:m} and scale parameter {it:b}.

{phang3}
{cmd:invlaplace(}{it:m}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} computes the inverse
cumulative Laplace distribution.  If
{cmd:laplace(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = {it:p},
then {cmd:invlaplace(}{it:m}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} = {it:x}.

{phang3}
{cmd:invlaplacetailb(}{it:m}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} computes the
inverse reverse cumulative Laplace distribution.  If
{cmd:laplacetail(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = {it:p},
then {cmd:invlaplacetail(}{it:m}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} = {it:x}.

{phang3}
{cmd:lnlaplaceden(}{it:m}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} computes the
natural logarithm of the density of the Laplace distribution with mean {it:m} and
scale parameter {it:b}.

{phang3}
{cmd:rlaplace(}{it:m}{cmd:,}{it:b}{cmd:)} is a Laplace random-number
generator.  It computes Laplace random variates with mean {it:m} and scale
parameter {it:b}.

{p 9 9 2}
See {manhelp density_functions FN:Statistical functions} and
{manhelp random_number_functions FN:Random-number functions}.

{p 4 9 2}
52.  {bf:Stream random numbers}

{p 9 9 2}
All of Stata's and Mata's existing random-number functions can
now produce stream random numbers.  Streams are necessary for
running simulations and bootstraps simultaneously.  Stata's
functions previously produced single streams.  In a single
stream, setting the seed determined the random numbers that
would be produced.  If two routines running simultaneously set
the same seed, they would obtain the same random numbers.
Multiple streams let them produce different random numbers.
Moreover, stream random-number generators (RNGs) are
designed so that you can simultaneously draw random numbers and
know that you are drawing from different sequences.

{p 9 9 2}
By default, Stata's and Mata's random-number functions are
based on an underlying RNG.  They are {cmd:kiss32} and
{cmd:mt64}.  {cmd:mt64} is the default, and {cmd:kiss32} was
provided for backward compatibility.  Now there is a third 
RNG:  {cmd:mt64s}, which is the stream version of the 
Mersenne Twister.

{p 9 9 2}
To use stream random numbers, you must first set the 
RNG to {cmd:mt64s}:

            {cmd:. set rng mt64s}

{p 9 9 2}
After that, you set the seed the usual way, 

            {cmd:. set seed} {it:#}

{p 9 9 2}
A new command allows you to set the stream, 

            {cmd:. set rngstream} {it:#}

{p 9 9 2}
where 1 {ul:<} {it:#} {ul:<} 32,767.  Each stream can produce 
2^{128} pseudorandom numbers before the sequence repeats.

{p 9 9 2}
Thus you can launch multiple Statas and run the same do-file
to produce simulations.  Each do-file can (and should) use the
same seed.  Before starting the do-file, set the {cmd:rngstream}, or have the
do-file accept a stream argument to set the stream.  Or launch the separate
Statas in batch mode and specify new start-up option {cmd:rngstream}{it:#}.

{p 9 9 2}
See {manhelp set_rngstream R:set rngstream}.


{marker NewG}{...}
{title:1.3.13 What's new in graphics}

{pstd}
Stata's new features allowing you to specify the transparency or opacity
of colors is 
{help whatsnew14to15##wngraphcolor:{it:Highlight 14}} of the release.

{pstd}
Also new are the following:

{p 4 9 2}
53.  {bf:Scalable vector graphics}

{p 9 9 2}
Stata now supports scalable vector graphics, also known as 
SVGs.  Vector graphic format is better than raster 
format because it is, well, scalable.  If you magnify the
graph, it does not become grainy or pixelated.

{p 9 9 2}
Scalable vector graphics are written in {cmd:.svg} files.
This format is especially popular for use on web pages.

{p 9 9 2}
Use {cmd:graph} {cmd:export,} {cmd:as(svg)}.

{p 9 9 2}
See {manhelp graph_export G-2:graph export}.

{p 4 9 2}
54.  {bf:New marker symbols}

{p 9 9 2}
Markers are used to show where the data lie.  Dots, hollow, or 
solid circles are popular.  Stata has lots of marker symbols.
Now it has more with short names {cmd:X}, {cmd:x}, {cmd:A}, 
{cmd:a}, {cmd:V}, {cmd:v}, and {cmd:|}.  Here are all of 
Stata 15's marker symbols: 

			Synonym
	{it:symbolstyle}     (if any)     Description
	{hline 55}
	{cmd:circle}             {cmd:O}         solid
	{cmd:diamond}            {cmd:D}         solid
	{cmd:triangle}           {cmd:T}         solid
	{cmd:square}             {cmd:S}         solid
	{cmd:plus}               {cmd:+}
	{cmd:X}                  {cmd:X}
	{cmd:arrowf}             {cmd:A}         filled arrow head
	{cmd:arrow}              {cmd:a}
	{cmd:pipe}               {cmd:|}
	{cmd:V}                  {cmd:V}

	{cmd:smcircle}           {cmd:o}         solid
	{cmd:smdiamond}          {cmd:d}         solid
	{cmd:smsquare}           {cmd:s}         solid
	{cmd:smtriangle}         {cmd:t}         solid
	{cmd:smplus}
        {cmd:smx}                {cmd:x}
	{cmd:smv}                {cmd:v}

	{cmd:circle_hollow}      {cmd:Oh}        hollow
	{cmd:diamond_hollow}     {cmd:Dh}        hollow
	{cmd:triangle_hollow}    {cmd:Th}        hollow
	{cmd:square_hollow}      {cmd:Sh}        hollow

	{cmd:smcircle_hollow}    {cmd:oh}        hollow
	{cmd:smdiamond_hollow}   {cmd:dh}        hollow
	{cmd:smtriangle_hollow}  {cmd:th}        hollow
	{cmd:smsquare_hollow}    {cmd:sh}        hollow

	{cmd:point}              {cmd:p}         a small dot
	{cmd:none}               {cmd:i}         a symbol that is invisible
	{hline 55}

{p 9 9 2}
You cannot rotate the arrows yet, but that is forthcoming.

{p 9 9 2}
See {manhelpi symbolstyle G-4}.

{p 4 9 2}
55.  {bf:New graph command for use after fitting nonparametric regression models}

{p 9 9 2}
New postestimation command {cmd:npgraph} is for use after fitting a
nonparametric regression model using the new {cmd:npregress} command.
{cmd:npregress} is {help whatsnew14to15##wnnonparamreg:{it:Highlight 11}} of
the release.  {cmd:npgraph} plots the nonparametric function fit by
{cmd:npregress} along with a scatterplot of the data.

{p 9 9 2}
See {manhelp npregress_postestimation R:npregress postestimation}.

{p 4 9 2}
56.  {bf:.gph file format updated}

{p 9 9 2}
Stata's {cmd:.gph} file format was updated because of the new
transparent colors and marker symbols.  Previous Statas will
not be able to read the new format, but Stata 15 can read old
formats without difficulty.

{marker NewD}{...}
{title:1.3.14 What's new in data management}

{pstd}
Stata's new ICD-10 features is 
{help whatsnew14to15##wnicd10:{it:Highlight 15}}
of the release, and Stata's new support of Federal Reserve Data Economic Data
is {help whatsnew14to15##wnfred:{it:Highlight 16}}.

{pstd}
Also new are the following:

{p 4 9 2}
57.  {bf:use ... in faster} 

{p 9 9 2}
Stata's {cmd:use} command is now significantly faster when you
specify {cmd:in} {it:range}.


{p 4 9 2}
58.  {bf:Import and export of dBase files} 

{p 9 9 2}
New command {cmd:import dbase} imports dBase version III and version
IV {cmd:.dbf} files.  dBase was one of the first micro database
management systems for microcomputers and is still used today.

{p 9 9 2}
New command {cmd:export dbase} exports to dBase IV
format.

{p 9 9 2}
See {manhelp import_dbase D:import dbase}.

{p 4 9 2}
59.  {bf:Stata/MP allows up to 120,000 variables}

{p 9 9 2}
Stata/MP's increase to 120,000 variables is up from 32,767 variables.  Stata/SE
continues to support up to 32,767 variables, and Stata/IC continues to support
up to 2,047 variables.

{p 4 9 2}
60.  {bf:statsby, dots()}

{p 9 9 2}
Existing command {cmd:statsby} has a new option {opt dots(#)} that displays
dots every {it:#} replications.  This provides entertainment and confirmation
that the command is still working during long runs.

{p 9 9 2}
See {manhelp statsby D}.

{marker NewP}{...}
{title:1.3.15 What's new in programming}

{pstd}
Dynamic documents using new command {cmd:markdown} is 
{help whatsnew14to15##wndynamicdocs:{it:Highlight 5}}
of the release.  Producing PDF and Word documents using new
commands {cmd:putpdf} and {cmd:putdocx} is 
{help whatsnew14to15##wnpdfword:{it:Highlight 13}}.

{pstd}
Also new are the following:

{p 4 9 2}
61.  {bf:New Java plugin features}

{p 9 9 2}
Stata's {help java:Java plugins} now have
features to store and access 

{phang3}
o{space 3}Stata's returned results

{phang3}
o{space 3}Stata's dataset characteristics

{phang3}
o{space 3}Stata's {cmd:strL} variables as a buffered array

{phang3}
o{space 3}Stata's string scalars

{phang3}
o{space 3}Stata's variable types

{phang3}
o{space 3}Stata's matrices  (they could already handle Mata's matrices)

{p 9 9 2}
In addition:

{phang3}
1.  It is now easier to access Stata's and Mata's matrix
	elements.

{phang3}
2.  Java plugins can now call Stata commands.

{phang3}
3.  Java plugins now use a custom class loader.

{p 16 18 2}
a.  Stata no longer needs to be restarted after
	       installation of a new Java plugin, and you 
	       can now detach plugins without restarting Stata.

{p 16 18 2}
b.  The loader allows for isolation of dependencies
	       between plugins.

{p 9 9 2}
See {manhelp java P} and {manhelp javacall P}.

{p 4 9 2}
62.  {bf:postfile bug fix}

{p 9 9 2}
 {cmd:postfile} previously allowed variable names sometimes 
 to be reserved words.  You could create a variable named 
 {cmd:int}, for instance.  This bug is fixed under version 
 control.

{p 4 9 2}
63.  {bf:New features to support new syntax for free parameters}

{p 9 9 2}
Stata has new syntax for free parameters in fitted models.
We mentioned this from the user's perspective in
{help whatsnew14to15##NewStat:{it:What's new in statistics (general)}}.
To rehash, {cmd:/}{it:name} is no longer a synonym for
{it:name}{cmd::}{cmd:_cons}; {cmd:/}{it:name} is its own thing for free
parameters.

{p 9 9 2}
Stata has new functions for dealing with matrix row and column
names that include {cmd:/}{it:name}:

{phang3}
{cmd:coleqnumb(}{it:M}{cmd:,}{it:s}{cmd:)} returns the equation number of
matrix {it:M} associated with column equation {it:s}.

{phang3}
{cmd:roweqnumb(}{it:M}{cmd:,}{it:s}{cmd:)} returns the equation number of
matrix {it:M} associated with row equation {it:s}.

{phang3}
{cmd:colnfreeparms(}{it:M}{cmd:)} returns the number of free
parameters in columns of matrix {it:M}.

{phang3}
{cmd:rownfreeparms(}{it:M}{cmd:)} returns the number of free
parameters in the rows of matrix {it:M}.

{p 9 9 2}
Stata also has new macro functions:

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:colnumb} {it:matrixname} {it:string}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rownumb} {it:matrixname} {it:string}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:coleqnumb} {it:matrixname} {it:string}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:roweqnumb} {it:matrixname} {it:string}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:colnfreeparms} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rownfreeparms} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:colnlfs} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rownlfs} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:colsof} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rowsof} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:colvarlist} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rowvarlist} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:collfnames} {it:matrixname}

{phang3}
{cmd:local} {it:lname} {cmd::} {cmd:rowlfnames} {it:matrixname}

{p 9 9 2}
See {manhelp matrix_functions FN:Matrix functions} and {manhelp macro P}.


{marker NewM}{...}
{title:1.3.16 What's new in Mata}

{pstd}
New are the following:

{p 4 9 2}
64.  {bf:Cauchy and Laplace distribution functions}

{p 9 9 2}
 The Cauchy and Laplace distribution functions added to
 Stata have been added to Mata, too.

{p 9 9 2}
 See 
{help whatsnew14to15##NewFN:{it:What's new in functions}}.

{p 4 9 2}
65.  {bf:Functions for calculating values and derivatives of the multivariate normal distribution}
 
{p 9 9 2}
 These functions allow fixed or varying limits, means, and
 variances/covariances/correlations.  Define

{phang3}
  {it:L} is the vector lower limits (default -infinity)

{phang3}
      {it:U} is the vector upper limits (default infinity)   

{phang3}
      {it:m} is the mean vector (default 0)

{phang3}
      {it:R} is the correlation matrix

{phang3}
      {it:V} is the variance matrix 

{p 9 9 2}
 The new functions return the value of the multivariate normal distribution
 between {it:L} and {it:U}:

{phang3}
       {cmd:mvnormal(}{it:U}{cmd:,}{it:R}{cmd:)}

{phang3}
      {cmd:mvnormal(}{it:L}{cmd:,}{it:U}{cmd:,}{it:R}{cmd:)}

{phang3}
      {cmd:mvnormalcv(}{it:L}{cmd:,}{it:U}{cmd:,}{it:M}{cmd:,}{it:V}{cmd:)} 

{phang3}
      {cmd:mvnormalderiv(}{it:U}{cmd:,}{it:R}{cmd:,}{it:dU}{cmd:,}{it:dR}{cmd:)} returns derivatives in
	   {it:dU}, {it:dR}

{phang3}
      {cmd:mvnormalderiv(}{it:L}{cmd:,}{it:U}{cmd:,}{it:R}{cmd:,}{it:dL}{cmd:,}{it:dU}{cmd:,}{it:dR}{cmd:)} returns derivatives in
	   {it:dL}, {it:dU}, {it:dR}

{phang3}
      {cmd:mvnormalcvderiv(}{it:L}{cmd:,}{it:U}{cmd:,}{it:M}{cmd:,}{it:V}{cmd:,}{it:dL}{cmd:,}{it:dU}{cmd:,}{it:dM}{cmd:,}{it:dV}{cmd:)} returns
	   derivatives in {it:dL}, {it:dU}, {it:dM}, {it:dV}

{p 9 9 2}
There are also versions of the above functions that allow specification of the
number of quadrature points.

{p 9 9 2}
See {manhelp mf_mvnormal M-5:mvnormal()}.

{p 4 9 2}
66.  {bf:Open Office XML files}

{p 9 9 2}
New functions were added to the suite for generating Open
Office XML ({cmd:.docx}) files:

{phang3}
      {cmd:_docx_append()} 

{phang3}
      {cmd:_docx_cell_set_span()} 

{p 9 9 2}
See {manhelp mf__docx M-5:_docx*()}.

{p 4 9 2}
67.  {bf:PDF files}

{p 9 9 2}
New functions were added to the suite for generating PDF
files:

{phang3}
     {cmd:PdfDocument.setLandscape()}

{phang3}
     {cmd:PdfParagraph.addLineBreak()} 

{phang3}
     {cmd:PdfParagraph.setVAlignment()} 

{phang3}
     {cmd:PdfTable.setCellBorderWidth()} 

{phang3}
     {cmd:PdfTable.setCellBorderColor()} 

{phang3}
     {cmd:PdfTable.setCellMargin()} 

{phang3}
     {cmd:PdfTable.setRowSplit()} 

{phang3}
     {cmd:PdfTable.addRow()} 

{phang3}
     {cmd:PdfTable.delRow()} 

{phang3}
     {cmd:PdfTable.addColumn()}

{phang3}
     {cmd:PdfTable.delColumn()} 

{p 9 9 2}
The following existing functions now have optional arguments and
added capabilities:

{phang3}
     {cmd:PdfTable.setBorderWidth()} 

{phang3}
     {cmd:PdfTable.setBorderColor()} 

{phang3}
     {cmd:PdfTable.fillStataMatrix()} 

{phang3}
     {cmd:PdfTable.fillMataMatrix()} 

{p 9 9 2}
See {manhelp mf_pdf M-5:Pdf*()}.

{p 4 9 2}
68.  {bf:Percent encoding for URLs}

{p 9 9 2}
New function {cmd:urlencode(}{it:s} [{cmd:,} {it:useplus}]{cmd:)}
returns {it:s} with any reserved characters changed to
percent-encoded ASCII.  Special characters are replaced 
by {cmd:%} followed by two hexadecimal digits.  For instance, each
space is replaced with {cmd:%20}.
If {cmd:useplus} is specified and nonzero, spaces are changed to 
{cmd:+}.

{p 9 9 2}
New function {cmd:urldecode(}{it:s}{cmd:)} returns {it:s} 
with percent encoding undone.

{p 9 9 2}
See {manhelp mf_urlencode M-5:urlencode()}.

{p 4 9 2}
69.  {bf:New option moptimize_init_eq_freeparm()}

{p 9 9 2}
New function {cmd:moptimize_init_eq_freeparm(}{it:M}{cmd:,}
{it:i}{cmd:,} {c -(}{cmd:"on"}{c |}{cmd:"off"}{c )-}{cmd:)} specifies whether
the equation for the {it:i}th parameter is to be treated as a
free parameter.  This setting is ignored if there are
independent variables or an offset attached to the parameter.
Free parameters have a shortcut notation that distinguishes
them from constant linear equations.  The free parameter
notation for an equation labeled name is {cmd:/}{it:name}.  The
corresponding notation for a constant linear equation is
{it:name}{cmd:_cons}.

{p 9 9 2}
See {manhelp mf_moptimize M-5:moptimize()}.


{marker NewGUI}{...}
{title:1.3.17 What's new in the interface}

{pstd}
New are the following:

{p 4 9 2}
70.  {bf:Do-file Editor is improved}

{p 9 9 2}
The Do-file Editor is improved.  In Stata for Windows, 

{phang3}
o{space 3}the current (active) line is now highlighted;

{phang3}
o{space 3}colors for line numbers, margins, bookmarks, etc. can be set;

{phang3}
o{space 3}bookmarks can be added or deleted by clicking in the
      bookmarks margin; and 

{phang3}
o{space 3}high-contrast mode is better supported.

{p 9 9 2}
Under all operating systems, including Windows,

{phang3}
o{space 3}column-mode selection and editing are now provided;

{phang3}
o{space 3}the new indentation guide aids in writing clean code by
      displaying vertical lines at every tab stop;

{phang3}
o{space 3}character encoding of legacy do-files can now be specified 
      so that any extended ASCII characters are converted 
      to the right Unicode character;

{phang3}
o{space 3}comments ({cmd:/* */} and {cmd://}) can be added or
      removed from a selection;

{phang3}
o{space 3}code folding for {cmd:program}, {cmd:mata}, and {cmd:input}
      is now provided;

{phang3}
o{space 3}wrapped lines can be marked visually;

{phang3}
o{space 3}program code can be automatically reindented to be 
      properly aligned, and spaces are converted to tabs.

{p 9 9 2}
Concerning column-mode editing: use {it:Alt}+mouse dragging or
{it:Alt}+{it:Shift}+arrow keys on Windows.  Substitute {it:Option} for
{it:Alt} on Mac and {it:Ctrl} for {it:Alt} on Linux.

{p 4 9 2}
71.  {bf:set more off now the default}

{p 9 9 2}
Stata displays {hline 2}{cmd:more}{hline 2} when output is about to scroll
off the screen.  You press the space bar or click on the {bf:More} button,
and another page of output appears.  This is called {cmd:set} {cmd:more}
{cmd:on}.

{p 9 9 2}
{cmd:set} {cmd:more} {cmd:off} is now the default.

{p 9 9 2}
If you prefer the old behavior, type {cmd:set} {cmd:more} {cmd:on,}
{cmd:permanently}.

{p 9 9 2}
See {manhelp more R}.

{p 4 9 2}
72.  {bf:If you do set more on ...}

{p 9 9 2}
The {bf:More} button has a useful new feature.
When output is paused, click on the triangle to the right 
of the {bf:More} button.  You will have two choices:

{phang3}
	     {bf:Show more results}

{phang3}
	     {bf:Run to completion}

{p 9 9 2}
Click on {bf:Run to completion}, and {cmd:more} will be
temporarily turned off until the currently running command (or
do-file!) completes.

{p 9 9 2}
See {manhelp more R}.

{p 4 9 2}
73.  {bf:Option to suppress header and footer in logs}

{p 9 9 2}
{cmd:log} has new option {cmd:nomsg}, which suppresses placing 
the header and footer in the log.  The header reports the filename
and date and time that the log was opened, and the footer reports the 
filename and date and time that the log was closed.

{p 9 9 2}
See {manhelp log R}.

{p 4 9 2}
74. {bf:Swedish language support}

{p 9 9 2}
Swedish now joins Spanish and Japanese as languages for which
Stata's menus, dialogs, and the like can be displayed.  Manuals
and help files remain in English.

{p 9 9 2}
If your computer locale is set to Sweden, Stata will automatically use its
Swedish setting.  To change languages manually, select {bf:Edit > Preferences}
{bf:> User-interface language...} using Windows or Unix, or on the Mac, select
{bf:Stata 15 > Preferences > User-interface language...}.  You can also
change the language from the command line; see
{helpb set locale_ui:[P] set locale_ui}.

{p 9 9 2}
StataCorp gratefully acknowledges the efforts of Metrika
Consulting AB, Stata's official distributor in Sweden, Finland,
Norway, and Denmark, for the translation to Swedish.


{marker NewMore}{...}
{title:1.3.18  What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated.  Those between-release updates are
available for free over the Internet.

{pstd}
Type {cmd:update query} and follow the instructions.

{pstd}
We hope that you enjoy Stata 15.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew14}.

{hline}
