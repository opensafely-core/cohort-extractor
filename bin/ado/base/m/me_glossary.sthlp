{smcl}
{* *! version 1.0.9  19oct2017}{...}
{vieweralsosee "[ME] Glossary" "mansection ME Glossary"}{...}
{viewerjumpto "Description" "me_glossary##description"}{...}
{viewerjumpto "References" "me_glossary##references"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ME] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection ME Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{marker anovaDDF}{...}
{phang}
{bf:ANOVA denominator degrees of freedom (DDF) method}.
This method uses the traditional ANOVA for computing DDF.
According to this method, the DDF for a test of a fixed effect of a
given variable depends on whether that variable is also included in any of the
random-effects equations.  For traditional ANOVA models with balanced
designs, this method provides exact sampling distributions of the test
statistics.  For more complex mixed-effects models or with unbalanced data,
this method typically leads to poor approximations of the actual sampling
distributions of the test statistics.

{marker approximationDDF}{...}
{phang}
{bf:approximation denominator degrees of freedom (DDF) methods}.
The Kenward-Roger and Satterthwaite DDF methods are referred
to as approximation methods because they approximate the sampling
distributions of test statistics using t and F distributions with the
DDF specific to the method for complicated mixed-effects models and
for simple mixed models with unbalanced data.
Also see
{help me_glossary##exactDDF:{it:exact denominator degrees of freedom (DDF) methods}}.

{phang}
{bf:between-within denominator degrees of freedom (DDF) method}. See
{help me_glossary##repeatedDDF:{it:repeated denominator degrees of freedom (DDF) method}}.

{phang}
{bf:BLUPs}. 
BLUPs are best linear unbiased predictions of either random effects
or linear combinations of random effects.  In linear models containing random 
effects, these effects are not estimated directly but instead are integrated
out of the estimation.  Once the fixed effects and variance components have
been estimated, you can use these estimates to predict group-specific random
effects.  These predictions are called BLUPs because they are 
unbiased and have minimal mean squared errors among all linear functions 
of the response.

{phang}
{bf:canonical link}. Corresponding to each family of distributions in a
generalized linear model (GLM) is a canonical link function for which
there is a sufficient statistic with the same dimension as the number of
parameters in the linear predictor.  The use of canonical link functions
provides the GLM with desirable statistical properties, especially
when the sample size is small.

{phang}
{bf:conditional hazard function}.
In the context of mixed-effects survival models, the conditional hazard function
is the hazard function computed conditionally on the random effects.
Even within the same covariate pattern, the conditional hazard function varies
among individuals who belong to different random-effects clusters.

{phang}
{bf:conditional hazard ratio}.
In the context of mixed-effects survival models, the conditional hazard ratio
is the ratio of two conditional hazard functions evaluated at different values
of the covariates.  Unless stated differently, the denominator corresponds to
the conditional hazard function at baseline, that is, with all the covariates
set to zero.

{phang}
{bf:conditional overdispersion}.
In a negative binomial mixed-effects model, conditional overdispersion is
overdispersion conditional on random effects.  Also see
{it:{help me_glossary##overdispersion:overdispersion}}.

{phang}
{bf:containment denominator degrees of freedom (DDF) method}.  See
{help me_glossary##anovaDDF:{it:ANOVA denominator degrees of freedom (DDF) method}}.

{marker car1}{...}
{phang}
{bf:continuous-time autoregressive structure}. A generalization of the
autoregressive structure that allows for unequally spaced and noninteger time
values.

{phang}
{bf:covariance structure}. In a mixed-effects model, covariance structure
refers to the variance-covariance structure of the random effects.

{marker crossed_effects_model}{...}
{phang}
{bf:crossed-effects model}. A crossed-effects model is a mixed-effects model
in which the levels of random effects are not nested.  A simple
crossed-effects model for cross-sectional time-series data would contain a
random effect to control for panel-specific variation and a second random
effect to control for time-specific random variation.  Rather than being
nested within panel, in this model a random effect due to a given time is the
same for all panels.

{phang}
{bf:crossed-random effects}. See
{it:{help me_glossary##crossed_effects_model:crossed-effects model}}.

{phang}
{bf:EB}. See
{it:{help me_glossary##empirical_Bayes:empirical Bayes}}.

{marker empirical_Bayes}{...}
{phang}
{bf:empirical Bayes}. In generalized linear mixed-effects models, empirical
Bayes refers to the method of prediction of the random effects after the model
parameters have been estimated.  The empirical Bayes method uses Bayesian
principles to obtain the posterior distribution of the random effects, but
instead of assuming a prior distribution for the model parameters, the
parameters are treated as given.

{phang}
{bf:empirical Bayes mean}.
See
{it:{help me glossary##posterior_mean:posterior mean}}.

{phang}
{bf:empirical Bayes mode}.
See
{it:{help me glossary##posterior_mode:posterior mode}}.

{marker error_covariance}{...}
{phang}
{bf:error covariance}, {bf:error covariance structure}. Variance-covariance
structure of the errors within the
{help me_glossary##lowestlevelgroup:lowest-level group}. For example, if you
are modeling random effects for classes nested within schools, then error
covariance refers to the variance-covariance structure of the observations
within classes, the lowest-level groups. With a slight abuse of the
terminology, error covariance is sometimes also referred to as residual
covariance or residual error covariance in the literature.

{marker exactDDF}{...}
{phang}
{bf:exact denominator degrees of freedom (DDF) methods}.
Residual, repeated, and ANOVA DDF methods are referred to as
exact methods because they provide exact t and F sampling
distributions of test statistics for special classes of mixed-effects
models -- linear regression, repeated-measures designs, and traditional
ANOVA models -- with balanced data. Also see
{help me_glossary##approximationDDF:{it:approximation denominator degrees of freedom (DDF) methods}}.

{phang}
{bf:fixed effects}. In the context of multilevel mixed-effects models, fixed
effects represent effects that are constant for all groups at any level of
nesting.  In the ANOVA literature, fixed effects represent the levels
of a factor for which the inference is restricted to only the specific
levels observed in the study.  See also
{it:{help xt_glossary##fixedeffects_model:fixed-effects model}} in
{bf:[XT] Glossary}.

{marker free_parameter}{...}
{phang}
{bf:free parameter}. Free parameters are parameters that are not defined by a
{help me_glossary##linear_form:linear form}.  Free parameters
are displayed with a forward slash in front of their names or their equation
names.

{marker GHquadrature}{...}
{phang}
{bf:Gauss-Hermite quadrature}.  In the context of generalized linear
mixed models, Gauss-Hermite quadrature is a method of approximating the
integral used in the calculation of the log likelihood.  The quadrature
locations and weights for individual clusters are fixed during the
optimization process.

{marker GLMEmodel}{...}
{phang}
{bf:generalized linear mixed-effects model}. A generalized linear
mixed-effects model is an extension of a generalized linear model
allowing for the inclusion of random deviations (effects).

{marker GLM}{...}
{phang}
{bf:generalized linear model}. The generalized linear model is an
estimation framework in which the user specifies a distributional family
for the dependent variable and a link function that relates the
dependent variable to a linear combination of the regressors.  The
distribution must be a member of the exponential family of distributions.
The generalized linear model encompasses many common models, including linear,
probit, and Poisson regression.

{phang}
{bf:GHQ}. See
{it:{help me_glossary##GHquadrature:Gauss-Hermite quadrature}}.

{phang}
{bf:GLM}. See
{it:{help me_glossary##GLM:generalized linear model}}.

{phang}
{bf:GLME model}. See
{it:{help me_glossary##GLMEmodel:generalized linear mixed-effects model}}.

{phang}
{bf:GLMM}. Generalized linear mixed model. See
{it:{help me_glossary##GLMEmodel:generalized linear mixed-effects model}}.

{phang}
{bf:hierarchical model}. A hierarchical model is one in which successively
more narrowly defined groups are nested within larger groups.  For example, in
a hierarchical model, patients may be nested within doctors who are in turn
nested within the hospital at which they practice.

{phang}
{bf:intraclass correlation}. In the context of mixed-effects models,
intraclass correlation refers to the correlation for pairs of responses at
each nested level of the model.

{phang}
{bf:Kenward-Roger denominator degrees of freedom (DDF) method}.
This method implements the {help me_glossary##KW1997:Kenward and Roger (1997)}
method, which is designed to approximate unknown sampling distributions of
test statistics for complex linear mixed-effects models.  This method is
supported only with restricted maximum-likelihood estimation.

{phang}
{bf:Laplacian approximation}. Laplacian approximation is a technique used to
approximate definite integrals without resorting to quadrature methods.  In
the context of mixed-effects models, Laplacian approximation is as a rule
faster than quadrature methods at the cost of producing biased parameter
estimates of variance components.

{marker lb_algorithm}{...}
{phang}
{bf:Lindstrom-Bates algorithm}. An algorithm used by the
{help me_glossary##linearization_method:linearization method}.

{marker linear_form}{...}
{phang}
{bf:linear form}. A linear combination is what we call a "linear form" as long
as you do not refer to its coefficients or any subset of the linear
combination anywhere in the expression. Linear forms are beneficial for some
nonlinear commands such as {helpb nl} because they make derivative computation
faster and more accurate. In contrast to
{help me_glossary##free_parameter:free parameters}, parameters of a linear
form are displayed without forward slashes in the output. Rather, they are
displayed as parameters within an equation whose name is the linear
combination name. Also see
{mansection ME menlRemarksandexamplesLinearformsversuslinearcombinations:{it:Linear forms versus linear combinations}}
in {bf:[ME] menl}.

{phang}
{bf:linear mixed model}. See
{it:{help me_glossary##LMEmodel:linear mixed-effects model}}.

{marker LMEmodel}{...}
{phang}
{bf:linear mixed-effects model}. A linear mixed-effects model
is an extension of a linear model allowing for the inclusion of random
deviations (effects).

{marker linearization_log_likelihood}{...}
{phang}
{bf:linearization log likelihood}. Objective function used by the
{help me_glossary##linearization_method:linearization method} for
optimization. This is the log likelihood of the linear mixed-effects model
used to approximate the specified nonlinear mixed-effects model.

{marker linearization_method}{...}
{phang}
{bf:linearization method}, {bf:Lindstrom-Bates method}. Method
developed by {help me_glossary##LB1990:Lindstrom and Bates (1990)} to
approximate for fitting
{help me_glossary##NLMEmodel:nonlinear mixed-effects models}. The linearization method uses a
first-order Taylor-series expansion of the specified nonlinear mean function
to approximate it with a linear function of fixed and random effects.  Thus a
nonlinear mixed-effects model is approximated by a
{help me_glossary##LMEmodel:linear mixed-effects model}, in
which the fixed-effects and random-effects design matrices involve derivatives
of the nonlinear mean function with respect to fixed effects (coefficients)
and random effects, respectively. Also see
{mansection ME menlRemarksandexampleslinearization_method:{it:Introduction}}
in {bf:[ME] menl}.

{phang}
{bf:link function}. In a generalized linear model or a generalized linear
mixed-effects model, the link function relates a linear combination of
predictors to the expected value of the dependent variable.  In a linear
regression model, the link function is simply the identity function.

{phang}
{bf:LME model}. See
{it:{help me_glossary##LMEmodel:linear mixed-effects model}}.

{marker lowestlevelgroup}{...}
{phang}
{bf:lowest-level group}. The second level of a multilevel model with the
observations composing the first level.  For example, if you are modeling
random effects for classes nested within schools, then classes are the
lowest-level groups.

{phang}
{bf:MCAGH}. See
{it:{help me_glossary##MCAGHquadrature:mode-curvature adaptive Gauss-Hermite quadrature}}.

{marker MVAGHquadrature}{...}
{phang}
{bf:mean-variance adaptive Gauss-Hermite quadrature}. In the context of
generalized linear mixed models, mean-variance adaptive Gauss-Hermite
quadrature is a method of approximating the integral used in the calculation
of the log likelihood.  The quadrature locations and weights for individual
clusters are updated during the optimization process by using the posterior
mean and the posterior standard deviation.

{phang}
{bf:mixed model}. See
{it:{help me_glossary##MEmodel:mixed-effects model}}.

{marker MEmodel}{...}
{phang}
{bf:mixed-effects model}. A mixed-effects model contains both fixed and
random effects. The fixed effects are estimated directly, whereas the random
effects are summarized according to their (co)variances.  Mixed-effects models
are used primarily to perform estimation and inference on the regression
coefficients in the presence of complicated within-subject correlation
structures induced by multiple levels of grouping.

{marker MCAGHquadrature}{...}
{phang}
{bf:mode-curvature adaptive Gauss-Hermite quadrature}. In the context of
generalized linear mixed models, mode-curvature adaptive Gauss-Hermite
quadrature is a method of approximating the integral used in the calculation
of the log likelihood.  The quadrature locations and weights for individual
clusters are updated during the optimization process by using the posterior
mode and the standard deviation of the normal density that approximates the
log posterior at the mode.

{phang}
{bf:MVAGH}. See
{it:{help me_glossary##MVAGHquadrature:mean-variance adaptive Gauss-Hermite quadrature}}.

{marker named_subexpr}{...}
{phang}
{bf:named substitutable expression}.
A named substitutable expression is a
{mansection ME menlRemarksandexamplesnamed_subexpr:substitutable expression}
defined within
{helpb menl}'s {cmd:define()} option; see
{mansection ME menlRemarksandexamplesSubstitutableexpressions:{it:Substitutable expressions}}
in {bf:[ME] menl}.

{phang}
{bf:nested random effects}. In the context of mixed-effects models,
nested random effects refer to the nested grouping factors for the random
effects.  For example, we may have data on students who are nested in classes
that are nested in schools.

{phang}
{bf:NLME model}. See
{help me_glossary##NLMEmodel:{it:nonlinear mixed-effects model}}.

{marker NLMEmodel}{...}
{phang}
{bf:nonlinear mixed-effects model}. A model in which the conditional
mean function given random effects is a nonlinear function of fixed and
random effects. A linear mixed-effects model is a special case of a nonlinear
mixed-effects model.

{phang}
{bf:one-level model}. A one-level model has no multilevel structure and no
random effects.  Linear regression is a one-level model.

{marker overdispersion}{...}
{phang}
{bf:overdispersion}.  In count-data models, overdispersion occurs when
there is more variation in the data than would be expected if the process
were Poisson.

{marker posterior_mean}{...}
{phang}
{bf:posterior mean}.
In generalized linear mixed-effects models, posterior mean refers to the
predictions of random effects based on the mean of the posterior distribution.

{marker posterior_mode}{...}
{phang}
{bf:posterior mode}.
In generalized linear mixed-effects models, posterior mode refers to the
predictions of random effects based on the mode of the posterior distribution.

{phang}
{bf:QR decomposition}. QR decomposition is an orthogonal-triangular
decomposition of an augmented data matrix that speeds up the calculation of
the log likelihood; see
{it:{mansection ME mixedMethodsandformulas:Methods and formulas}}
in {bf:[ME] mixed} for more details.

{phang}
{bf:quadrature}. Quadrature is a set of numerical methods to
evaluate a definite integral.

{phang}
{bf:random coefficient}. In the context of mixed-effects models,
a random coefficient is a counterpart to a slope in the
fixed-effects equation.  You can think of a random coefficient as a
randomly varying slope at a specific level of nesting.

{marker random_effects}{...}
{phang}
{bf:random effects}. In the context of mixed-effects models, random
effects represent effects that may vary from group to group at any level of
nesting.  In the ANOVA literature, random effects represent the levels
of a factor for which the inference can be generalized to the underlying
population represented by the levels observed in the study.  See also
{it:{help xt_glossary##randomeffects_model:random-effects model}} in
{bf:[XT] Glossary}.

{phang}
{bf:random intercept}. In the context of mixed-effects models,
a random intercept is a counterpart to the intercept in the
fixed-effects equation.  You can think of a random intercept as a
randomly varying intercept at a specific level of nesting.

{phang}
{bf:random-effects substitutable expression}.
A random-effects substitutable expression is a
{help me_glossary##subexpr:substitutable expression} containing
random-effects terms; see
{mansection ME menlRemarksandexamplesRandom-effectssubstitutableexpressions:{it:Random-effects substitutable expressions}}
in {bf:[ME] menl}.

{phang}
{bf:REML}.  See
{it:{help me_glossary##REML:restricted maximum likelihood}}.

{marker repeatedDDF}{...}
{phang}
{bf:repeated denominator degrees of freedom (DDF) method}.
This method uses the repeated-measures ANOVA for computing
DDF.  It is used with balanced repeated-measures designs with
spherical correlation error structures.  It partitions the residual degrees of
freedom into the between-subject degrees of freedom and the within-subject
degrees of freedom.  The repeated method is supported only with two-level
models.  For more complex mixed-effects models or with unbalanced data, this
method typically leads to poor approximations of the actual sampling
distributions of the test statistics.

{phang}
{bf:residual covariance}, {bf:residual error covariance}. See
{help me_glossary##error_covariance:{it:error covariance}}.

{phang}
{bf:residual denominator degrees of freedom (DDF) method}.
This method uses the residual degrees of freedom, n - rank(X), as the
DDF for all tests of fixed effects.  For a linear model without random
effects with independent and identically distributed errors, the distributions
of the test statistics for fixed effects are t or F distributions with the
residual DDF.  For other mixed-effects models, this method typically
leads to poor approximations of the actual sampling distributions of the test
statistics.

{marker REML}{...}
{phang}
{bf:restricted maximum likelihood}.  Restricted maximum likelihood is a method
of fitting linear mixed-effects models that involves transforming out the fixed
effects to focus solely on variance-component estimation.

{phang}
{bf:Satterthwaite denominator degrees of freedom (DDF) method}.
This method implements a generalization of the
{help me_glossary##S1946:Satterthwaite (1946)} approximation of the unknown
sampling distributions of test statistics for complex linear mixed-effects
models.  This method is supported only with restricted maximum-likelihood
estimation.

{marker subexpr}{...}
{phang}
{bf:substitutable expression}. Substitutable expressions are like any
other mathematical expressions involving scalars and variables, such as those
you would use with Stata's {cmd:generate} command, except that the parameters
to be estimated are bound in braces. See
{mansection ME menlRemarksandexamplesSubstitutableexpressions:{it:Substitutable expressions}} in
{bf:[ME] menl}.

{phang}
{bf:three-level model}. A three-level mixed-effects model has one level of
observations and two levels of grouping.  Suppose that you have a dataset
consisting of patients overseen by doctors at hospitals, and each doctor
practices at one hospital.  Then a three-level model would contain a set of
random effects to control for hospital-specific variation, a second set of
random effects to control for doctor-specific random variation within a
hospital, and a random-error term to control for patients' random variation.

{phang}
{bf:two-level model}. A two-level mixed-effects model has one level of
observations and one level of grouping.  Suppose that you have a panel dataset
consisting of patients at hospitals; a two-level model would contain a set of
random effects at the hospital level (the second level) to control for
hospital-specific random variation and a random-error term at the observation
level (the first level) to control for within-hospital variation.

{phang}
{bf:variance components}. In a mixed-effects model, the variance components
refer to the variances and covariances of the various random effects.

{marker withingrouperrors}{...}
{phang}
{bf:within-group errors}. In a two-level model with observations nested
within groups, within-group errors refer to error terms at the observation
level. In a higher-level model, they refer to errors within the
{help me_glossary##lowestlevelgroup:lowest-level groups}.


{marker references}{...}
{title:References}

{marker KW1997}{...}
{phang}
Kenward, M. G., and J. H. Roger. 1997. Small sample inference for fixed
effects from restricted maximum likelihood.
{it:Biometrics} 53: 983-997.

{marker LB1990}{...}
{phang}
Lindstrom, M. J., and D. M. Bates. 1990. Nonlinear mixed effects models
for repeated measures data.
{it:Biometrics} 46: 673-687.

{marker S1946}{...}
{phang}
Satterthwaite, F. E. 1946. An approximate distribution of estimates of
variance components. {it:Biometrics Bulletin} 2: 110-114.
{p_end}
