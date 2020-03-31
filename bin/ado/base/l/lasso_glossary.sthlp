{smcl}
{* *! version 1.0.1  01jul2019}{...}
{vieweralsosee "[LASSO] Glossary" "mansection LASSO Glossary"}{...}
{viewerjumpto "Description" "lasso_glossary##description"}{...}
{viewerjumpto "Glossary" "lasso_glossary##glossary"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[LASSO] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection LASSO Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{marker adaptive_lasso}{...}
{phang} 
{bf:adaptive lasso}.  Adaptive lasso is one of three methods that Stata
provides for fitting lasso models.  The other two methods are
{help lasso_glossary##cross_validation:cross-validation} and
{help lasso_glossary##plugins:plugins}.  Adaptive lasso tends to include
fewer covariates than cross-validation and more covariates than plugins.
Adaptive lasso is not used for fitting square-root lasso and elastic-net
models.

{marker beta_min_condition}{...}
{phang} 
{bf:beta-min condition}.  Beta-min condition is a mathematical statement that
the smallest nonzero coefficient, in absolute value, be sufficiently large in
the true or best approximating model.  The condition is seldom met in lasso
models because lasso tends to omit covariates with small coefficients.  That
is not an issue for {help lasso_glossary##prediction:prediction}, but it is
for {help lasso_glossary##inference:inference}.  Stata's
{help lasso_glossary##double_selection:double selection, partialing out, and cross-fit partialing out} work around the issue.

{phang}
{bf:coefficients of interest}.
See {help lasso_glossary##covariates_interest:{it:covariates of interest and control covariates}}.

{phang}
{bf:control variables}.
See {help lasso_glossary##covariates_interest:{it:covariates of interest and control covariates}}.

{marker covariates}{...}
{phang} 
{bf:covariates}.  Covariates, also known as explanatory variables and RHS
variables, refer to the variables that appear or potentially appear on the
right-hand side of a model and that predict the values of the
{help lasso_glossary##outcome_variable:outcome variable}.  This manual often
refers to "potential covariates" and "selected covariates" to distinguish
the variables that lasso considers from those it selects for inclusion in the
model.

{marker covariates_interest}{...}
{phang} 
{bf:covariates of interest and control covariates}.  Covariates of interest
and control covariates compose the
{help lasso_glossary##covariates:covariates} that are specified when fitting
lasso models for {help lasso_glossary##inference:inference}.  In these cases,
the coefficients and standard errors for the covariates of interest are
estimated and reported.  The coefficients for the control covariates are not
reported nor are they recoverable, but they nonetheless appear in the model to
improve the measurement of the coefficients of interest.

{pmore}
Covariates of interest and control covariates are often called variables of
interest and control variables.

{pmore} 
The coefficients on the covariates of interest are called the coefficients of
interest.

{marker covariate_selection}{...}
{phang} 
{bf:covariate selection}.  Covariate selection refers to processes that
automatically select the covariates to be included in a model.  Lasso,
square-root lasso, and elastic net are three such processes.  What makes them
special is that they can handle so many potential covariates.

{pmore} 
Covariate selection is handled at the same time as estimation.  Covariates are
included and excluded based on coefficient estimates.  When estimates are 0,
covariates are excluded.

{marker cross_fitting}{...}
{phang} 
{bf:cross-fitting}.  Cross-fitting is another term for
{help lasso_glossary##DML:double machine learning}.

{marker cross_validation}{...}
{phang}
{bf:cross-validation (CV)}.  Cross-validation (CV) is a method for fitting
lasso models.  The other methods that Stata provides are
{help lasso_glossary##adaptive_lasso:adaptive lasso} and
{help lasso_glossary##plugins:plugins}.

{pmore}
The term in general refers to techniques that validate how well predictive
models perform.  Classic CV uses one dataset to fit the model and another to
evaluate its predictions.  When the term is used in connection with lasso,
however, CV refers to {help lasso_glossary##folds:K-fold CV}, a technique that
uses the same dataset to fit the model and to produce an estimate of how well
the model would do if used to make out-of-sample predictions.  See
{help lasso_glossary##folds:{it:folds}}.

{marker cross_crit}{...}
{phang}
{bf:cross-validation function}.  The cross-validation (CV) function is  
calculated by first dividing the data into K
{help lasso_glossary##folds:folds}.  The model for each λ (and α for elastic
net) is fit on data in all but one fold, and then the prediction on that
excluded fold is computed and a measure of fit calculated.  These K measures
of fit are averaged to give the value of the CV function.  For linear models,
the CV function is the
{help lasso_glossary##cv_meanpred:CV mean prediction error}.  For nonlinear
models, the CV function is the
{help lasso_glossary##cross_cvmd:CV mean deviance}.
{help lasso_glossary##cross_validation:CV} finds the minimum of the CV
function, and the value of λ (and α) that gives the minimum is the selected
λ^* (and α^*).

{marker cross_cvmd}{...}
{phang}
{bf:cross-validation mean deviance}.  Cross-validation mean deviance is
a {help lasso_glossary##cross_crit:cross-validation function}  that uses the
observation-level {help lasso_glossary##deviance:deviance} as a measure of
fit.

{marker cross_mdevr}{...}
{phang}
{bf:cross-validation mean deviance ratio}.  Cross-validation mean deviance
ratio is the {help lasso_glossary##cross_crit:cross-validation function}  
using the mean of the
{help lasso_glossary##deviance_ratio:deviance ratio} as the measure of fit.

{marker cv_meanpred}{...}
{phang}
{bf:cross-validation mean prediction error}.  Cross-validation mean prediction
error is the  {help lasso_glossary##cross_crit:cross-validation function}
using the mean of the square of the prediction error as the measure of fit.
For the linear model, the prediction error is the difference between the
individual-level outcome and the linear prediction {bf:x}_i'{bf:β}.

{marker DGP}{...}
{marker DGM}{...}
{phang}
{bf:data-generating process (DGP) and data-generating mechanism (DGM)}.
Data-generating process (DGP) and data-generating mechanism (DGM) are synonyms
for the underlying process that generated the data being analyzed.  The
scientific and statistical models that researchers fit are sometimes
approximations of the DGP.

{marker deviance}{...}
{phang}
{bf:deviance}.  The deviance is a measure-of-fit statistic for linear and
nonlinear likelihood-based models.  The deviance for an observation i, D_i, is
given by

            D_i = -2(l_i - l_{saturated})

{pmore}
where l_i is the observation-level likelihood and l_{saturated} is the
value of the saturated likelihood.

{marker deviance_null}{...}
{phang}
{bf:deviance null}.  The deviance null is the mean of the deviance evaluated
for the log likelihood of a model that only includes a constant.

{marker deviance_ratio}{...}
{phang}
{bf:deviance ratio}.  The deviance ratio is a measure-of-fit statistic for
linear and nonlinear likelihood-based models.  It is given by D

            D2 = 1 - Đ/(D_{null})

{pmore}
where Đ is the mean of the
{help lasso_glossary##deviance:deviance} and D_{null} is the 
{help lasso_glossary##deviance_null:deviance null}.

{marker DML}{...}
{phang}
{bf:double machine learning (DML)}.
Double machine learning (DML) is a method for estimating the
{help lasso_glossary##covariates_interest:coefficients of interest} and their
standard errors.  When lasso is used for
{help lasso_glossary##inference:inference}, you specify the covariates of
interest and the potential
{help lasso_glossary##covariates_interest:control covariates}.  DML is a
family of techniques that combine
{help lasso_glossary##sample_splitting:sample splitting} and robust moment
conditions.  See
{help lasso_glossary##double_selection:{it:double selection, partialing out, and cross-fit partialing out}}.

{marker double_selection}{...}
{phang}
{bf:double selection, partialing out, and cross-fit partialing out}.  Double
selection, partialing out, and cross-fit partialing out are three different
estimation techniques for performing
{help lasso_glossary##inference:inference} on a subset of the coefficients in
a lasso model.  Stata provides these techniques for linear, logit, Poisson,
and instrumental-variables models.  Cross-fit partialing out is also known as
{help lasso_glossary##DML:double machine learning} (DML).  Also see
{manlink LASSO Lasso inference intro}.

{marker ds}{...}
{phang} 
{bf:ds}.  A shorthand that we use in this manual to refer to all the
double-selection inference commands -- {helpb dsregress}, {helpb dslogit}, and
{helpb dspoisson}.

{marker elastic_net}{...}
{phang}
{bf:elastic net}.  Elastic net is a
{help lasso_glossary##penalized_estimators:penalized estimator} designed to be
less likely than lasso to exclude highly collinear covariates.  Stata's
{cmd:elasticnet} command fits elastic-net models using
{help lasso_glossary##cross_validation:cross-validation}.

{phang}
{bf:excluded covariates}.  See
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{marker folds}{...}
{phang} 
{bf:folds and K-fold cross-validation}.  Folds and K-fold cross-validation
refer to a technique for estimating how well a model would perform in
out-of-sample prediction without actually having a second dataset.  The same
data that were used to fit the model are then divided into K approximately
equal-sized, mutually exclusive subsamples called folds.  For each fold k, the
model is refit on the data in the other K - 1 folds, and that result is then
used to make predictions for the values in fold k.  When the process is
complete for all K folds, the predictions in the combined folds are compared
with actual values.  The number of folds, K, is usually set to 10.

{phang}
{bf:included covariates}.  See
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{marker inference}{...}
{phang} 
{bf:inference}.  Inference means statistical inference or scientific inference.
It involves using samples of data to infer the values of parameters in the
underlying population along with measures of their likely accuracy.  The
likely accuracy is stated in terms of probabilities, confidence intervals,
credence intervals, standard errors, and other statistical measures.

{pmore}
Inference can also refer to scientific inference.  Scientific inference is
statistical inference on a causal parameter.  These parameters characterize
cause-and-effect relationships.  Does more education cause higher incomes, or
is it simply a proxy that is associated with higher incomes because those who
have it are judged to be smarter or have more drive to succeed or simply spent
more time with the right people?  If the interest were in simply making
statistical {help lasso_glossary##prediction:predictions}, it would not
matter.

{marker insampler2}{...}
{phang}
{bf:in-sample R-squared}.  The in-sample R-squared is the
{help lasso_glossary##rsquared:R-squared} evaluated at the sample where the
model is fit.

{marker knots}{...}
{phang} 
{bf:knots}.  Knots are the values of the
{help lasso_glossary##penalty_parameter:penalty parameters} at which variables
in the model change.

{marker lambda}{...}
{marker alpha}{...}
{phang}
{bf:lambda and alpha}.  Lambda and alpha (λ and α) are lasso's and
elastic-net's {help lasso_glossary##penalty_parameter:penalty parameters}.

{pmore}
Lambda is lasso's and square-root lasso's penalty parameter.  Lambda is
greater than or equal to 0.  When it is 0, all possible covariates are
included in the model.  At its largest value (which is model dependent), no
covariates are included.  Thus, lambda orders the models.

{pmore}
Alpha is elastic-net's penalty parameter.  Alpha is bounded by 0 and 1,
inclusive.  When alpha is 0, the elastic net becomes ridge regression.  When
alpha is 1, the elastic net becomes lasso.

{marker lasso}{...}
{phang}
{bf:lasso}.  Lasso has different meanings in this glossary, depending on usage.

{pmore}
First, we use lasso to mean lasso, the word that started as LASSO because it
was an acronym for "least absolute shrinkage and selection operator".

{pmore}
Second, we use lasso to mean lasso and square-root lasso, which are two
different flavors of lasso.  See
{help lasso_glossary##square_root_lasso:{it:square-root lasso}}.

{pmore}
Third, we use lasso to mean lasso, square-root lasso, and elastic net.
Elastic net is yet another flavor of lasso that uses a different penalty
function.  See {help lasso_glossary##elastic_net:{it:elastic net}}.

{pmore}
Lasso in the broadest sense is widely used for
{help lasso_glossary##prediction:prediction}
and {help lasso_glossary##covariate_selection:covariate selection}.

{pmore}
Lasso in the narrowest sense is implemented by Stata's {cmd:lasso} command.
It fits linear, logit, probit, and Poisson models.  It fits them using any of
three methods:
{help lasso_glossary##cross_validation:cross-validation},
{help lasso_glossary##adaptive_lasso:adaptive lasso}, and
{help lasso_glossary##plugins:plugins}.

{pmore}
Square-root lasso is implemented by Stata's {cmd:sqrtlasso} command.  It fits
linear models using
{help lasso_glossary##cross_validation:cross-validation}
or {help lasso_glossary##plugins:plugins}.

{pmore}
Elastic net is implemented by Stata's {cmd:elasticnet} command.  It fits
linear, logit, probit, and Poisson models.  It uses
{help lasso_glossary##cross_validation:cross-validation}.

{pmore} 
Regardless of the particular lasso used, these methods estimate coefficients
on potential covariates.  Covariates are included and excluded based on the
estimate.  When estimates are 0, covariates are excluded.

{phang}
{bf:lasso selection}.  See
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{marker nonzero_coefficients}{...}
{phang}
{bf:nonzero coefficients}.  Nonzero coefficients are the coefficients
estimated for the
{help lasso_glossary##covariate_selection:selected covariates}.

{phang} 
{bf:not-selected covariates}.  Not-selected covariates is a synonym for
excluded covariates; see
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{marker outcome_variable}{...}
{phang} 
{bf:outcome variable}.  Outcome variable, also known as dependent variable and
LHS variable, refers to the variable whose values are predicted by the
independent variables, which are also known as
{help lasso_glossary##covariates:covariates} and RHS variables.

{marker outsampler2}{...}
{phang}
{bf:out-of-sample R-squared}.  The out-of-sample R-squared is the
{help lasso_glossary##rsquared:R-squared} evaluated for a sample distinct from
the one for which the model was fit.

{marker penalized_coeff}{...}
{phang}
{bf:penalized coefficients}.  Penalized coefficients are the coefficient
estimates produced by lasso when the covariates are not standardized to have a
mean of 0 and standard deviation of 1.

{marker penalized_estimators}{...}
{phang}
{bf:penalized estimators}.  Penalized estimators are statistical estimators
that minimize a measure of fit that includes a penalty term.  That term
penalizes models based on their complexity.  Lasso, square-root lasso, and
elastic net are penalized estimators.

{pmore}
What distinguishes lasso from elastic net, and is the only thing that
distinguishes them, is the particular form of the penalty term.  Lasso uses
the sum of the absolute values of the coefficients for the included
covariates.  Elastic net uses the same penalty term plus the sum of the
squared coefficients.  The additional term is designed to prevent exclusion of
highly collinear covariates.

{pmore}
Square-root lasso uses the same penalty term as lasso, but the form of the
objective function to which the penalty is added differs.

{marker penalty_loadings}{...}
{phang} 
{bf:penalty loadings}.  Penalty loadings refer to coefficient-specific penalty
weights in {help lasso_glossary##adaptive_lasso:adaptive lasso} and
{help lasso_glossary##plugins:plugins}.  Allowing coefficients to have
different penalty weights improves the model chosen by lasso, square-root
lasso, and elastic net.

{marker penalty_parameter}{...}
{phang} 
{bf:penalty parameter}.  Penalty parameter is the formal term for lambda (λ),
lasso's and square-root lasso's penalty parameter, and alpha (α),
elastic-net's penalty parameter.  See
{help lasso_glossary##lambda:{it:lambda and alpha}}.

{marker plugins}{...}
{phang}
{bf:plugins}.  Plugins are the method for fitting
{help lasso_glossary##lasso:lasso} and
{help lasso_glossary##square_root_lasso:square-root lasso} models, but not
{help lasso_glossary##elastic_net:elastic-net} models.  It is an alternative
to {help lasso_glossary##cross_validation:cross-validation}.  Cross-validation
tends to include more covariates than are justified, at least in comparison
with the best approximating model.  Plugins were developed to address this
problem.  Plugins have the added advantage of being quicker to execute, but
they will sometimes miss important covariates that cross-validation will find.

{marker po}{...}
{phang}
{bf:po}.  A shorthand that we use in this manual to refer to all the
partialing-out inference commands -- {helpb poregress}, {helpb pologit},
{helpb popoisson}, and {helpb poivregress}.

{marker postlasso_coefficients}{...}
{phang} 
{bf:post-lasso coefficients}.  Post-lasso coefficients, also known as
post-selection coefficients, are the estimated coefficients you would obtain
if you refit the model selected by lasso.  To be clear about it, you fit a
linear model by using lasso.  It selected covariates.  You then refit the
model on those covariates by using {cmd:regress}, {cmd:logit}, etc.  Those are
the post-selection coefficients, and they will differ from those produced by
lasso.  They will differ because lasso is a shrinkage estimator, and that
leads to the question: which are better for prediction?

{pmore}
There is no definitive answer to that question.  The best answer we can give
you is to use split samples and {cmd:lassogof} to evaluate both sets of
predictions and choose the better one.

{pmore} 
For your information, Stata's lasso commands -- {cmd:lasso}, {cmd:sqrtlasso},
and {cmd:elasticnet} -- provide both the lasso and the post-selection
coefficients.  The lasso coefficients are stored in {cmd:e(b)}.  The
post-selection coefficients are stored in {cmd:e(b_postselection)}.  You can
do in-sample and out-of-sample prediction with {cmd:predict}.  {cmd:predict}
by default uses the lasso coefficients.  Specify option {cmd:postselection},
and it uses the post-selection coefficients.

{phang}
{bf:potential covariates}.  See
{help lasso_glossary##covariates:{it:covariates}}.

{marker prediction}{...}
{phang}
{bf:prediction and predictive modeling}.  Prediction and predictive modeling
refer to predicting values of the
{help lasso_glossary##outcome_variable:outcome variable} based on
{help lasso_glossary##covariates:covariates}.  Prediction  is what lasso was
originally designed to do.  The variables on which the predictions are based
do not necessarily have a cause-and-effect relationship with the outcome.
They might be proxies for the cause and effects.  Also see
{help lasso_glossary##inference:{it:inference}}.

{marker regularized}{...}
{phang}
{bf:regularized estimator}.  Regularized estimators is another term used for 
penalized estimators.  See
{help lasso_glossary##penalized_estimators:{it:penalized estimators}}.

{marker rsquared}{...}
{phang}
{bf:R-squared}.  The R-squared (R^2) is a measure of goodness of fit.  It
tells you what fraction of the variance of the outcome is explained by your
model.

{marker sample_splitting}{...}
{phang}
{bf:sample splitting}.  Sample splitting is a way of creating two or more
smaller datasets from one dataset.  Observations are randomly assigned to
subsamples.  Stata's {cmd:splitsample} command does this.  Samples are
sometimes split to use the resulting subsamples in different ways.  One could
use the first subsample to fit the model and the second subsample to evaluate
its predictions.

{marker saturated}{...}
{phang}
{bf:saturated likelihood}.  The saturated likelihood is the likelihood for a
model that has as many estimated parameters as data points.

{pmore}
For linear models, logit models, and probit models; the log likelihood
function of the saturated model is 0.  In other words, l_{saturated} = 0.

{pmore}
For the Poisson model,

            l_{saturated} = 1/N sum_{i=1}^N {c -(}-y_i + ln(y_i)y_i{c )-}

{phang} 
{bf:selected covariates}.  Selected covariates is  synonym for included
covariates; see
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{marker sparsity_assumption}{...}
{phang}
{bf:sparsity assumption}.  Sparsity assumption refers to a requirement for
lasso to produce reliable results.  That requirement is that the true model
that lasso seeks has few variables, where "few" is measured relative to the
number of observations in the dataset used to fit the model.

{marker square_root_lasso}{...}
{phang}
{bf:square-root lasso}.  Square-root lasso is a variation on
{help lasso_glossary##lasso:lasso}.  Development of square-root lassos was
motivated by a desire to better fit linear models with homoskedastic but not
normal errors, but it can also be used with heteroskedastic errors.  Stata's
{cmd:sqrtlasso} command fits square-root lassos.

{marker standardized_coeff}{...}
{phang}
{bf:standardized coefficients}.  Standardized coefficients are the coefficient
estimates produced by lasso when the covariates are standardized to have a
mean of 0 and standard deviation of 1.

{phang} 
{bf:variable selection}.  See
{help lasso_glossary##covariate_selection:{it:covariate selection}}.

{phang}
{bf:variables of interest}.  See
{help lasso_glossary##covariates_interest:{it:covariates of interest and control covariates}}.

{marker xpo}{...}
{phang}
{bf:xpo}.  A shorthand that we use in this manual to refer to all the
cross-fit partialing-out inference commands -- {helpb xporegress},
{helpb xpologit}, {helpb xpopoisson}, and {helpb xpoivregress}.
{p_end}
