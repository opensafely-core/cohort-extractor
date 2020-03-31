{smcl}
{* *! version 1.0.11  14may2019}{...}
{vieweralsosee "[BAYES] Glossary" "mansection BAYES Glossary"}{...}
{viewerjumpto "Description" "bayes_glossary##description"}{...}
{viewerjumpto "Reference" "bayes_glossary##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[BAYES] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection BAYES Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{marker a_posteriori}{...}
{phang}
{bf:a posteriori}.
In the context of Bayesian analysis, we use a posteriori to mean "after the
sample is observed".  For example, a posteriori information is any information
obtained after the data sample is observed.  See
{it:{help bayes_glossary##posterior_distribution:posterior distribution, posterior}}.

{marker a_priori}{...}
{phang}
{bf:a priori}.
In the context of Bayesian analysis, we use a priori to mean "before the
sample is observed".  For example, a priori information is any information
obtained before the data sample is observed.  In a Bayesian model, a priori
information about {help bayes_glossary##model_parameter:model parameters} is
specified by {help bayes_glossary##prior_distribution:prior distributions}.

{marker acceptance_rate}{...}
{phang}
{bf:acceptance rate}.
In the context of the MH algorithm, acceptance rate is the fraction of the
proposed samples that is accepted.  The optimal acceptance rate depends on the
properties of the
{help bayes_glossary##stationary_distribution:target distribution} and is not
known in general.  If the target distribution is normal, however, the optimal
acceptance rate is known to be 0.44 for univariate distributions and 0.234 for
multivariate distributions.

{marker adaptation}{...}
{phang}
{bf:adaptation}.
In the context of the MH algorithm, adaptation refers to the process of tuning
or adapting the proposal distribution to optimize the MCMC sampling.
Typically, adaptation is performed periodically during the MCMC sampling.  The
{cmd:bayesmh} command performs adaptation every {it:#} of iterations as
specified in option {cmd:adaptation(every(}{it:#}{cmd:))} for a maximum of
{cmd:adaptation(maxiter())} iterations.  In a continuous-adaptation regimes,
the adaptation lasts during the entire process of the MCMC sampling.  See
{manhelp bayesmh BAYES}.

{marker adaptation_period}{...}
{phang}
{bf:adaptation period}.
Adaptation period includes all MH
{help bayes_glossary##adaptive_iteration:adaptive iterations}.  It equals the
length of the adaptation interval, as specified by {cmd:adaptation(every())},
times the maximum number of adaptations, {cmd:adaptation(maxiter())}.

{marker adaptive_iteration}{...}
{phang}
{bf:adaptive iteration}.
In the adaptive MH algorithm, adaptive iterations are iterations during which
{help bayes_glossary##adaptation:adaptation} is performed.

{marker AIC}{...}
{phang}
{bf:Akaike information criterion, AIC.}
Akaike information criterion (AIC) is an information-based model-selection
criterion.  It is given by the formula -2 x log likelihood + 2k, where k is
the number of parameters.  AIC favors simpler models by penalizing for the
number of model parameters.  It does not, however, account for the sample
size.  As a result, the AIC penalization diminishes as the sample size
increases, as does its ability to guard against overparameterization.

{marker batch_means}{...}
{phang}
{bf:batch means}.
Batch means are means obtained from batches of sample values of equal size.
Batch means provide an alternative method for estimating MCMC standard errors
({help bayes_glossary##MCSE:MCSE}).  The batch size is usually chosen to
minimize the correlation between different batches of means.

{marker Bayes_factor}{...}
{phang}
{bf:Bayes factor}.
Bayes factor is given by the ratio of the
{help bayes_glossary##marginal_likelihood:marginal likelihoods} of two models,
M_1 and M_2.  It is a widely used criterion for Bayesian model comparison.
Bayes factor is used in calculating the posterior odds ratio of model M_1
versus M_2,

            P(M_1|y)/P(M_2|y) = P(y|M_1)/P(y|M_2) P(M_1)/P(M_2)

{pmore}
where P(M_i|y) is a posterior probability of model M_i, and P(M_i) is a prior
probability of model M_i.  When the two models are equally likely, that is,
when P(M_1) = P(M_2), the Bayes factor equals the posterior odds ratio of the
two models.

{marker Bayes_theorem}{...}
{phang}
{bf:Bayes's theorem}.
The Bayes's theorem is a formal method for relating conditional probability
statements.  For two (random) events X and Y, the Bayes's theorem states that

            P(X|Y) propto P(Y|X) P(X)

{pmore}
that is, the probability of X conditional on Y is proportional to the
probability of X and the probability of Y conditional on X.  In Bayesian
analysis, the Bayes's theorem is used for combining prior information about
model parameters and evidence from the observed data to form the
{help bayes_glossary##posterior_distribution:posterior distribution}.

{marker Bayesian_analysis}{...}
{phang}
{bf:Bayesian analysis}.
Bayesian analysis is a statistical methodology that considers model parameters
to be random quantities and estimates their
{help bayes_glossary##posterior_distribution:posterior distribution} by
combining prior knowledge about parameters with the evidence from the observed
data sample.  Prior knowledge about parameters is described by
{help bayes_glossary##prior_distribution:prior distributions} and evidence
from the observed data is incorporated through a likelihood model.  Using the
{help bayes_glossary##Bayes_theorem:Bayes's theorem}, the prior distribution
and the likelihood model are combined to form the posterior distribution of
model parameters.  The posterior distribution is then used for parameter
inference, hypothesis testing, and prediction.

{marker Bayesian_estimation}{...}
{phang}
{bf:Bayesian estimation}.
Bayesian estimation consists of fitting Bayesian models and estimating their
parameters based on the resulting posterior distribution. Bayesian estimation
in Stata can be done using the convenient {helpb bayes} prefix or the more
general {helpb bayesmh} command. See
{manhelp bayesian_estimation BAYES:Bayesian estimation} for details.

{marker Bayesian_estimation_results}{...}
{phang}
{bf:Bayesian estimation results}.
Estimation results obtained after the {helpb bayes} prefix or the
{helpb bayesmh} command.

{marker Bayesian_hypothesis_testing}{...}
{phang}
{bf:Bayesian hypothesis testing}.
Bayesian hypothesis testing computes probabilities of hypotheses conditional
on the observed data.  In contrast to the frequentist hypothesis testing, the
Bayesian hypothesis testing computes the actual probability of a hypothesis H
by using the Bayes's theorem,

            P(H|y) propto P(y|H) P(H)

{pmore}
where y is the observed data, P(y|H) is the marginal likelihood of y given H,
and P(H) is the prior probability of H.  Two different hypotheses, H_1 and
H_2, can be compared by simply comparing P(H_1|y) to P(H_2|y).

{marker BIC}{...}
{phang}
{bf:Bayesian information criterion, BIC}.
The Bayesian information criterion (BIC), also known as Schwarz criterion, is
an information based criterion used for model selection in classical
statistics.  It is given by the formula -0.5 x log likelihood + k x ln n,
where k is the number of parameters and n is the sample size.  BIC favors
simpler, in terms of complexity, models and it is more conservative than 
{help bayes_glossary##AIC:AIC}.

{marker model_checking}{...}
{phang}
{bf:Bayesian model checking}.
In Bayesian statistics, model checking refers to testing likelihood and 
prior model adequacy in the context of a research problem and observed data.
A simple sanity check may include verifying that posterior inference 
produces results that are reasonable in the context of the problem.
More substantive checks may include analysis of the sensitivity of Bayesian 
inference to changes in likelihood and prior distribution specifications.
See {help bayes_glossary##posterior_predictive_checking:{it:posterior predictive checking}}.

{marker Bayesian_predictions}{...}
{phang}
{bf:Bayesian predictions}.
Bayesian predictions are samples from the 
{help bayes_glossary##posterior_predictive_distribution:posterior predictive distribution} 
of outcome variables and functions of these samples and, optionally, model 
parameters.  Examples of Bayesian predictions include 
{help bayes_glossary##replicated_data:replicated data}, out-of-sample 
predictions, and test statistics of 
{help bayes_glossary##simulated_outcome:simulated outcomes}.

{marker blocking}{...}
{phang}
{bf:blocking}.
In the context of the MH algorithm, blocking refers to the process of
separating model parameters into different subsets or blocks to be sampled
independently of each other.  MH algorithm generates proposals and applies the
acceptance-rejection rule sequentially for each block.  It is recommended that
correlated parameters are kept in one block.  Separating less-correlated or
independent model parameters in different blocks may improve the 
{help bayes_glossary##mixing:mixing} of the MH algorithm.

{marker burnin_period}{...}
{phang}
{bf:burn-in period}.
The burn-in period is the number of iterations it takes for an
{help bayes_glossary##MCMC:MCMC} sequence to reach stationarity.

{phang}
{bf:central posterior interval}.  See
{it:{help bayes_glossary##equal_tailed_cri:equal-tailed credible interval}}.

{phang}
{bf:conditional conjugacy}.  See
{it:{help bayes_glossary##semiconjugate_prior:semiconjugate prior}}.

{marker conjugate_prior}{...}
{phang}
{bf:conjugate prior}.
A prior distribution is conjugate for a family of likelihood distributions if
the prior and posterior distributions belong to the same family of
distributions.  For example, the gamma distribution is a conjugate prior for
the Poisson likelihood.  Conjugacy may provide an efficient way of sampling
from posterior distributions and is used in
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}.

{marker continuous_parameters}{...}
{phang}
{bf:continuous parameters}.
Continuous parameters are parameters with continuous prior distributions.

{marker credible_interval}{...}
{phang}
{bf:credible interval}.
In Bayesian analysis, the credible interval of a scalar model parameter is an
interval from the domain of the marginal posterior distribution of that
parameter.  Two types of credible intervals are typically used in practice:
{help bayes_glossary##equal_tailed_cri:equal-tailed credible intervals} and
{help bayes_glossary##HPD_cri:HPD credible intervals}.

{marker credible_level}{...}
{phang}
{bf:credible level}.
The credible level is a probability level between 0% and 100% used for
calculating {help bayes_glossary##credible_interval:credible intervals} in
Bayesian analysis.  For example, a 95% credible interval for a scalar
parameter is an interval the parameter belongs to with the probability of 95%.

{marker cusum_plot}{...}
{phang}
{bf:cusum plot, CUSUM plot}.
The cusum (CUSUM) plot of an MCMC sample is a plot of cumulative sums of the
differences between sample values and their overall mean against the iteration
number.  Cusum plots are useful graphical summaries for detecting early drifts
in MCMC samples.

{marker DIC}{...}
{phang}
{bf:deviance information criterion, DIC}.
The deviance information criterion (DIC) is an information based criterion
used for Bayesian model selection.  It is an analog of AIC and is given by the
formula D(overline theta) + 2 x p_D, where D(overline theta) is the deviance
at the sample mean and p_D is the effective complexity, a quantity equivalent
to the number of parameters in the model.  Models with smaller DIC are
preferred.

{marker diminishing_adaptation}{...}
{phang}
{bf:diminishing adaptation}.
Diminishing adaptation of the adaptive algorithm is the type of adaptation in
which the amount of adaptation decreases with the size of the MCMC chain.

{marker discrete_parameters}{...}
{phang}
{bf:discrete parameters}.
Discrete parameters are parameters with discrete prior distributions.

{marker ESS}{...}
{phang}
{bf:effective sample size, ESS}.
Effective sample size (ESS) is the MCMC sample size T adjusted for the
autocorrelation in the sample.  It represents the number of independent
observations in an MCMC sample.  ESS is used instead of T in calculating MCSE.
Small ESS relative to T indicates high autocorrelation and consequently poor
{help bayes_glossary##mixing:mixing} of the chain.

{marker efficiency}{...}
{phang}
{bf:efficiency}.
In the context of MCMC, efficiency is a term used for assessing the mixing
quality of an MCMC procedure.  Efficient MCMC algorithms are able to explore
posterior domains in less time (using fewer iterations).  Efficiency is
typically quantified by the sample autocorrelation and effective sample size.
An MCMC procedure that generates samples with low autocorrelation and
consequently high ESS is more efficient.

{marker equal_tailed_cri}{...}
{phang}
{bf:equal-tailed credible interval}.
An equal-tailed credible interval is a credible interval defined in such a way
that both tails of the marginal posterior distribution have the same
probability.  A 100 x (1-alpha)% equal-tailed credible interval is defined by
the alpha/2th and (1-alpha)/2th quantiles of the marginal posterior
distribution.

{marker feasible_initial_value}{...}
{phang}
{bf:feasible initial value}.
An initial-value vector is feasible if it corresponds to a state with a
positive posterior probability.

{marker fixed_effects}{...}
{phang}
{bf:fixed effects}.  See
{help bayes_glossary##fixed_effects_parameters:{it:fixed-effects parameters}}.

{marker fixed_effects_parameters}{...}
{phang}
{bf:fixed-effects parameters}.
In the Bayesian context, the term "fixed effects" or "fixed-effects
parameters" is a misnomer, because all model parameters are inherently
random.  We use this term in the context of Bayesian multilevel models to
refer to regression model parameters and to distinguish them from the
{help bayes_glossary##random_effects_parameters:random-effects parameters}.
You can think of fixed-effects parameters as parameters modeling population
averaged or marginal relationship of the response and the variables of
interest.

{marker frequentist_analysis}{...}
{phang}
{bf:frequentist analysis}.
Frequentist analysis is a form of statistical analysis where model parameters
are considered to be unknown but fixed constants and the observed data are
viewed as a repeatable random sample.  Inference is based on the sampling
distribution of the data.

{marker full_conditionals}{...}
{phang}
{bf:full conditionals}.
A full conditional is the probability distribution of a random variate
conditioned on all other random variates in a joint probability model.  Full
conditional distributions are used in
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}.

{phang}
{bf:full Gibbs sampling}.
See {it:{help bayes_glossary##Gibbs_sampling:Gibbs sampling, Gibbs sampler}}.

{marker Gelman_Rubin_convergence_diagnostic}{...}
{phang}
{bf:Gelman-Rubin convergence diagnostic, Gelman-Rubin convergence statistic}.
Gelman-Rubin convergence diagnostic assesses MCMC convergence by analyzing
differences between multiple Markov chains.  The convergence is assessed by
comparing the estimated between-chains and within-chain variances for each
model parameter.  Large differences between these variances indicate
nonconvergence.  See {manhelp bayesstats_grubin BAYES:bayesstats grubin}.

{marker Gibbs_sampling}{...}
{phang}
{bf:Gibbs sampling, Gibbs sampler}.
Gibbs sampling is an MCMC method, according to which each random variable from
a joint probability model is sampled according to its
{help bayes_glossary##full_conditionals:full conditional distribution}.

{marker HPD_cri}{...}
{phang}
{bf:highest posterior density credible interval, HPD credible interval}.  The
highest posterior density (HPD) credible interval is a type of a credible
interval with the highest marginal posterior density.  An HPD interval has the
shortest width among all other credible intervals.  For some multimodal
marginal distributions, HPD may not exists.  See
{it:{help bayes_glossary##HPD_region:highest posterior density region, HPD region}}.

{marker HPD_region}{...}
{phang}
{bf:highest posterior density region, HPD region}.
The highest posterior density (HPD) region for model parameters has the
highest marginal posterior probability among all domain regions.  Unlike an
{help bayes_glossary##HPD_cri:HPD credible interval}, an HPD region always
exist.

{marker hybrid_MH_sampling}{...}
{phang}
{bf:hybrid MH sampling, hybrid MH sampler}.
A hybrid MH sampler is an MCMC method in which some blocks of parameters are
updated using the MH algorithms and other blocks are updated using Gibbs
sampling.

{marker hyperparameter}{...}
{phang}
{bf:hyperparameter}.
In Bayesian analysis, hyperparameter is a parameter of a prior distribution,
in contrast to a {help bayes_glossary##model_parameter:model parameter}.

{marker hyperprior}{...}
{phang}
{bf:hyperprior}.
In Bayesian analysis, hyperprior is a prior distribution of hyperparameters.
See {it:{help bayes_glossary##hyperparameter:hyperparameter}}.

{marker improper_prior}{...}
{phang}
{bf:improper prior}.
A prior is said to be improper if it does not integrate to a finite number.
Uniform distributions over unbounded intervals are improper.  Improper priors
may still yield proper posterior distributions.  When using improper priors,
however, one has to make sure that the resulting posterior distribution is
proper for Bayesian inference to be invalid.

{marker independent_aposteriori}{...}
{phang}
{bf:independent a posteriori}.
Parameters are considered independent a posteriori if their marginal posterior
distributions are independent; that is, their joint posterior distribution is
the product of their individual marginal posterior distributions.

{marker independent_apriori}{...}
{phang}
{bf:independent a priori}.
Parameters are considered independent a priori if their prior distributions
are independent; that is, their joint prior distribution is the product of
their individual marginal prior distributions.

{marker informative_prior}{...}
{phang}
{bf:informative prior}.
An informative prior is a prior distribution that has substantial influence on
the posterior distribution.

{phang}
{bf:in-sample predictions}.
See {help bayes_glossary##replicated_outcome:{it:replicated outcome}}.

{marker interval_hypothesis_testing}{...}
{phang}
{bf:interval hypothesis testing}.
Interval hypothesis testing performs
{help bayes_glossary##interval_test:interval hypothesis tests} for model
parameters and functions of model parameters.

{marker interval_test}{...}
{phang}
{bf:interval test}.
In Bayesian analysis, an interval test applied to a scalar model parameter
calculates the marginal posterior probability for the parameter to belong to
the specified interval.

{marker Jeffreys_prior}{...}
{phang}
{bf:Jeffreys prior}.
The Jeffreys prior of a vector of model parameters theta is proportional to
the square root of the determinant of its Fisher information matrix I(theta).
Jeffreys priors are locally uniform and, by definition, agree with the
likelihood function.  Jeffreys priors are considered noninformative priors
that have minimal impact on the posterior distribution.

{marker marginal_distribution}{...}
{phang}
{bf:marginal distribution}.
In Bayesian context, a distribution of the data after integrating out
parameters from the joint distribution of the parameters and the data.

{marker marginal_likelihood}{...}
{phang}
{bf:marginal likelihood}.
In the context of Bayesian model comparison, a marginalized over model
parameters theta likelihood of data y for a given model M, P(y|M)=m(y)=int
P(y|theta,M)P(theta|M)d theta.  Also see
{it:{help bayes_glossary##Bayes_factor:Bayes factor}}.

{marker marginal_posterior_distribution}{...}
{phang}
{bf:marginal posterior distribution}.
In Bayesian context, a marginal posterior distribution is a distribution
resulting from integrating out all but one parameter from the joint posterior
distribution.

{marker Markov_chain}{...}
{phang}
{bf:Markov chain}.
Markov chain is a random process that generates sequences of random vectors
(or states) and satisfies the Markov property: the next state depends only on
the current state and not on any of the previous states.
{help bayes_glossary##MCMC:MCMC} is the most common methodology for simulating
Markov chains.

{marker matrix_model_parameter}{...}
{phang}
{bf:matrix model parameter}.
A matrix model parameter is any
{help bayes_glossary##model_parameter:model parameter} that
is a matrix.  Matrix elements, however, are viewed as
{help bayes_glossary##scalar_model_parameter:scalar model parameters}.

{pmore}
Matrix model parameters are defined and referred to within the {cmd:bayesmh}
command as {cmd:{c -(}}{it:param}{cmd:,}{cmdab:m:atrix}{cmd:{c )-}} or
{cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:,}{cmdab:m:atrix}{cmd:{c )-}}
with the equation name {it:eqname}.  For example, {cmd:{Sigma, matrix}} and
{cmd:{Scale:Omega, matrix}} are matrix model parameters.  Individual matrix
elements cannot be referred to within the {cmd:bayesmh} command, but they can
be referred within postestimation commands accepting parameters.  For example,
to refer to the individual elements of the defined above, say, 2 x 2 matrices,
use {cmd:{Sigma_1_1}}, {cmd:{Sigma_2_1}}, {cmd:{Sigma_1_2}}, {cmd:{Sigma_2_2}}
and {cmd:{Scale:Omega_1_1}}, {cmd:{Scale:Omega_2_1}}, {cmd:{Scale:Omega_1_2}},
{cmd:{Scale:Omega_2_2}}, respectively.  See {manhelp bayesmh BAYES}.

{phang}
{bf:matrix parameter}.  See
{it:{help bayes_glossary##matrix_model_parameter:matrix model parameter}}.

{marker MCMC}{...}
{phang}
{bf:MCMC, Markov chain Monte Carlo}.
MCMC is a class of simulation-based methods for generating samples from
probability distributions.  Any MCMC algorithm simulates a
{help bayes_glossary##Markov_chain:Markov chain} with a target distribution as
its stationary or equilibrium distribution.  The precision of MCMC algorithms
increases with the number of iterations.  The lack of a stopping rule and
convergence rule, however, makes it difficult to determine for how long to run
MCMC.  The time needed to converge to the target distribution within a
prespecified error is referred to as mixing time.  Better MCMC algorithms have
faster mixing times.  Some of the popular MCMC algorithms are random-walk
Metropolis, {help bayes_glossary##MH_sampling:Metropolis-Hastings}, and
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}.

{marker MCMC_replicates}{...}
{phang}
{bf:MCMC replicates}.
An {help bayes_glossary##MCMC_sample:MCMC sample} of
{help bayes_glossary##simulated_outcome:simulated outcomes}.

{marker MCMC_sample}{...}
{phang}
{bf:MCMC sample}.
An MCMC sample is obtained from
{help bayes_glossary##MCMC_sampling:MCMC sampling}.  An MCMC sample
approximates a target distribution and is used for summarizing this
distribution.

{marker MCMC_sample_size}{...}
{phang}
{bf:MCMC sample size}.
MCMC sample size is the size of the
{help bayes_glossary##MCMC_sample:MCMC sample}.  It is specified in
{cmd:bayesmh}'s option {cmd:mcmcsize()}; see {manhelp bayesmh BAYES}.

{marker MCMC_sampling}{...}
{phang}
{bf:MCMC sampling, MCMC sampler}.
MCMC sampling is an MCMC algorithm that generates samples from a target
probability distribution.

{marker MCSE}{...}
{phang}
{bf:MCMC standard error, MCSE}
MCSE is the standard error of the posterior mean estimate.  It is defined as
the standard deviation divided by the square root of
{help bayes_glossary##ESS:ESS}.  MCSEs are analogs of standard errors in
frequentist statistics and measure the accuracy of the simulated MCMC sample.

{marker MH_sampling}{...}
{phang}
{bf:Metropolis-Hastings (MH) sampling, MH sampler}.
A Metropolis-Hastings (MH) sampler is an MCMC method for
simulating probability distributions.  According to this method, at each step
of the Markov chain, a new proposal state is generated from the current state
according to a prespecified proposal distribution.  Based on the current and
new state, an acceptance probability is calculated and then used to accept or
reject the proposed state.  Important characteristics of MH sampling is the
{help bayes_glossary##acceptance_rate:acceptance rate} and
{help bayes_glossary##mixing:mixing} time.  The MH algorithm is very
general and can be applied to an arbitrary target distribution.  However, its
efficiency is limited, in terms of mixing time, and decreases as the dimension
of the target distribution increases.
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}, when available,
can provide much more efficient sampling than MH sampling.

{marker mixing}{...}
{phang}
{bf:mixing of Markov chain}.
Mixing refers to the rate at which a Markov chain traverses the parameter
space.  It is a property of the Markov chain that is different from
convergence.  Poor mixing indicates a slow rate at which the chain explores
the stationary distribution and will require more iterations to provide
inference at a given precision.  Poor (slow) mixing is typically a result of
high correlation between model parameters or of weakly-defined model
specifications.

{marker model_hypothesis_testing}{...}
{phang}
{bf:model hypothesis testing}.
Model hypothesis testing tests hypotheses about models by computing
{help bayes_glossary##model_posterior_probability:model posterior probabilities}.

{marker model_parameter}{...}
{phang}
{bf:model parameter}.
A model parameter refers to any (random) parameter in a Bayesian model.  Model
parameters can be
{help bayes_glossary##scalar_model_parameter:scalars} or
{help bayes_glossary##matrix_model_parameter:matrices}.  Examples of
model parameters as defined in {cmd:bayesmh} are {cmd:{mu}}, {cmd:{scale:s}},
{cmd:{Sigma,matrix}}, and {cmd:{Scale:Omega,matrix}}.
See {helpb bayesmh} and, specifically,
{it:{mansection BAYES bayesmhRemarksandexamplesDeclaringmodelparameters:Declaring model parameters}} and
{it:{mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:Referring to model parameters}} in that entry.  Also see
{it:{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingmodelparameters:Different ways of specifying model parameters}} in {bf:[BAYES] Bayesian postestimation}.

{phang}
{marker model_posterior_probability}{...}
{bf:model posterior probability}.
Model posterior probability is probability of a model M computed conditional on the observed data y,

            P(M|y)=P(M)P(y|M)=P(M)m(y)

{pmore}
where P(M) is the prior probability of a model M and m(y) is the
{help bayes_glossary##marginal_likelihood:marginal likelihood}
under model M.

{marker noninformative_prior}{...}
{phang}
{bf:noninformative prior}.
A noninformative prior is a prior with negligible influence on the posterior
distribution.  See, for example,
{it:{help bayes_glossary##Jeffreys_prior:Jeffreys prior}}.

{phang}
{bf:objective prior}.  See
{it:{help bayes_glossary##noninformative_prior:noninformative prior}}.

{marker onetime_sampling}{...}
{phang}
{bf:one-at-a-time MCMC sampling}.
A one-at-a-time MCMC sample is an MCMC sampling procedure in which
random variables are sampled individually, one at a time.  For example, in
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}, individual
variates are sampled one at a time, conditionally on the most recent values of
the rest of the variates.

{phang}
{bf:out-of-sample predictions}.
Predictions of future observations; see
{help bayes_glossary##simulated_outcome:{it:simulated outcome}}.

{marker overdispersed_initial_value}{...}
{phang}
{bf:overdispersed initial value}.
An overdispersed initial value is obtained from a distribution that is
overdispersed or has larger variability relative to the true marginal
posterior distribution.  Overdispersed initial values are used with
multiple Markov chains for diagnosing MCMC convergence.  Also see
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh}.

{marker posterior_distribution}{...}
{phang}
{bf:posterior distribution, posterior}.
A posterior distribution is a probability distribution of model parameters
conditional on observed data.  The posterior distribution is determined by the
likelihood of the parameters and their prior distribution.  For a parameter
vector theta and data y, the posterior distribution is given by
		
            P(theta|y) = {P(theta) P(y|theta)}/{P(y)}

{pmore}
where P(theta) is the prior distribution, P(y|theta) is the model
likelihood, and P(y) is the marginal distribution for y.  Bayesian
inference is based on a posterior distribution.

{phang}
{bf:posterior independence}.  See
{it:{help bayes_glossary##independent_aposteriori:independent a posteriori}}.

{phang}
{bf:posterior interval}.  See
{it:{help bayes_glossary##credible_interval:credible interval}}.

{marker posterior_odds}{...}
{phang}
{bf:posterior odds}.
Posterior odds for theta_1 compared with theta_2 is the ratio of
posterior density evaluated at theta_1 and theta_2 under a given
model,

{phang3}
            p(theta_1|y)/p(theta_2|y)= p(theta_1)/p(theta_2) p(y|theta_1)/p(y|theta_2)

{pmore}
In other words, posterior odds are prior odds times the likelihood ratio.

{marker posterior_predictive_checking}{...}
{phang}
{bf:posterior predictive checking}.
Posterior predictive checking is a methodology for assessing goodness of fit
of a Bayesian model using
{help bayes_glossary##replicated_data:replicated data} simulated from the
{help bayes_glossary##posterior_predictive_distribution:posterior predictive distribution}
of the model.  For example, graphical diagnostics of the replicated residuals
may be used to check the distributional assumptions of the model error terms.
A more formal and systematic approach uses
{help bayes_glossary##test_quantity:test quantities} and test statistics
to measure discrepancies between replicated data and observed data.  Test
statistics such as a mean, minimum, and maximum can be used to compare
different aspects of the observed data distribution with those of the
replicated-data distribution.
{help bayes_glossary##posterior_predictive_pvalue:Posterior predictive p-values},
also called Bayesian p-values, computed for test quantities and test statistics
are used to quantify the discrepancy between the observed and replicated data.
Also see {help bayes_glossary##model_checking:{it:Bayesian model checking}}.

{marker posterior_predictive_distribution}{...}
{phang}
{bf:posterior predictive distribution}.
Posterior predictive distribution is a distribution of unobserved (future)
data conditional on observed data.  Posterior predictive distribution is
derived by marginalizing the likelihood function with respect to the
{help bayes_glossary##posterior_distribution:posterior distribution} of model
parameters.

{marker posterior_predictive_pvalue}{...}
{phang}
{bf:posterior predictive p-value}.
Posterior predictive p-value, also called a Bayesian p-value, is the
probability that a test quantity (or statistic) computed for the
{help bayes_glossary##replicated_data:replicated data} is greater or
equal to the test quantity computed for the observed data.  Posterior
predictive p-values are used in
{help bayes_glossary##posterior_predictive_checking:posterior predictive checking}.
p-values less than 0.05 or greater than 0.95 typically indicate model misfit
({help bayes_glossary##gelmanetal2014:Gelman et al. 2014}).

{marker predictive_distribution}{...}
{phang}
{bf:predictive distribution}.  See
{help bayes_glossary##prior_predictive_distribution:{it:prior predictive distribution}} and
{help bayes_glossary##posterior_predictive_distribution:{it:posterior predictive distribution}}.

{marker predictive_inference}{...}
{phang}
{bf:predictive inference}.
In Bayesian statistics, predictive inference is inference about unobserved
(future) data conditionally on past data and prior knowledge of model
parameters.  Predictive inference is based on
{help bayes_glossary##prior_predictive_distribution:prior predictive} or
{help bayes_glossary##posterior_predictive_distribution:posterior predictive}
 distribution of model parameters.

{marker predictive_outcome}{...}
{phang}
{bf:predictive outcome}.
Predictive outcome ỹ is a value or a set of values simulated from a
{help bayes_glossary##posterior_predictive_distribution:posterior predictive distribution}
p(ỹ|y) of a Bayesian model
({help bayes_glossary##gelmanetal2014:Gelman et al. 2014}).
In contrast with {help bayes_glossary##replicated_outcome:replicated outcome}, 
predictive outcomes may use the values of independent variables that are
different from those used to fit the model.  Also see
{help bayes_glossary##simulated_outcome:{it:simulated outcome}}.

{marker prior_distribution}{...}
{phang}
{bf:prior distribution, prior}.
In Bayesian statistics, prior distributions are probability distributions of
model parameters formed based on some a priori knowledge about parameters.
Prior distributions are independent of the observed data.

{phang}
{bf:prior independence}.  See
{it:{help bayes_glossary##independent_apriori:independent a priori}}.

{marker prior_odds}{...}
{phang}
{bf:prior odds}.
Prior odds for theta_1 compared with theta_2 is the ratio of prior
density evaluated at theta_1 and theta_2 under a given model,
p(theta_1)/p(theta_2).  Also see
{it:{help bayes_glossary##posterior_odds:posterior odds}}.

{marker prior_predictive_distribution}{...}
{phang}
{bf:prior predictive distribution}.
Prior predictive distribution is a distribution of unobserved (future) data 
derived by marginalizing the likelihood function with respect to the 
{help bayes_glossary##prior_distribution:prior distribution} of model 
parameters.  Also see
{help bayes_glossary##marginal_distribution:{it:marginal distribution}}.

{marker proposal_distribution}{...}
{phang}
{bf:proposal distribution}.
In the context of the MH algorithm, a proposal distribution is used for
defining the transition steps of the Markov chain.  In the standard
random-walk Metropolis algorithm the proposal distribution is a multivariate
normal distribution with zero mean and adaptable covariance matrix.

{marker pseudoconvergence}{...}
{phang}
{bf:pseudoconvergence}.
A Markov chain may appear to converge when in fact it did not.  We refer to
this phenomenon as pseudoconvergence.  Pseudoconvergence is typically caused
by multimodality of the stationary distribution, in which case the chain may
fail to traverse the weakly connected regions of the distribution space.  A
common way to detect pseudoconvergence is to run multiple chains using
different starting values and to verify that all of the chain converge to the
same target distribution.

{marker random_effects}{...}
{phang}
{bf:random effects}.  See
{help bayes_glossary##random_effects_parameters:{it:random-effects parameters}}.

{marker random_effects_linear_form}{...}
{phang}
{bf:random-effects linear form}.
A linear form representing a random-effects variable that can be used in
substitutable expressions.

{marker random_effects_parameters}{...}
{phang}
{bf:random-effects parameters}.
In the context of Bayesian multilevel models, random-effects parameters are
parameters associated with a
{help bayes_glossary##random_effects_variable:random-effects variable}.
Random-effects parameters are assumed to be conditionally independent across
levels of the random-effects variable given all other model parameters.
Often, random-effects parameters are assumed to be normally distributed with a
zero mean and an unknown variance-covariance matrix.

{marker random_effects_variable}{...}
{phang}
{bf:random-effects variable}.
A variable identifying the group structure for the random effects at a
specific level of hierarchy.

{phang}
{bf:reference prior}.  See
{it:{help bayes_glossary##noninformative_prior:noninformative prior}}.

{marker replicated_data}{...}
{phang}
{bf:replicated data}.
Replicated data, {bf:y}^{rep}, are data that would be observed if the
experiment that produced the observed data, {bf:y}^{obs}, were replicated using
the same model and the same values of independent variables that generated
{bf:y}^{obs}.  See
{help bayes_glossary##gelmanetal2014:Gelman et al. (2014, 145)},
{helpb bayespredict:[BAYES] bayespredict}, and
{helpb bayesstats ppvalues:[BAYES] bayesstats ppvalues}.

{marker replicated_outcome}{...}
{phang}
{bf:replicated outcome}.
Replicated outcome is a special case of a 
{help bayes_glossary##simulated_outcome:simulated outcome} that is generated
using the same values of independent variables as those used to fit the model.
Also see
{help bayes_glossary##replicated_data:{it:replicated data}}.

{marker scalar_model_parameter}{...}
{phang}
{bf:scalar model parameter}.
A scalar model parameter is any 
{help bayes_glossary##model_parameter:model parameter} that is a scalar.  For
example, {cmd:{mean}} and {cmd:{hape:alpha}} are scalar parameters, as
declared by the {cmd:bayesmh} command.  Elements of 
{help bayes_glossary##matrix_model_parameter:matrix model parameters} are
viewed as scalar model parameters.  For example, for a 2 x 2 matrix parameter
{cmd:{Sigma,matrix}}, individual elements {cmd:{Sigma_1_1}},
{cmd:{Sigma_2_1}}, {cmd:{Sigma_1_2}}, and {cmd:{Sigma_2_2}} are scalar
parameters.  If a matrix parameter contains a label, the label should be
included in the specification of individual elements as well. See 
{manhelp bayesmh BAYES}.

{phang}
{bf:scalar parameter}.  See
{it:{help bayes_glossary##scalar_model_parameter:scalar model parameter}}.

{marker semiconjugate_prior}{...}
{phang}
{bf:semiconjugate prior}.
A prior distribution is semiconjugate for a family of likelihood distributions
if the prior and (full) conditional posterior distributions belong to the same
family of distributions.  For semiconjugacy to hold, parameters must typically
be independent a priori; that is, their joint prior distribution must be the
product of the individual marginal prior distributions.  For example, the
normal prior distribution for a mean parameter of a normal data distribution
with an unknown variance (which is assumed to be independent of the mean a
priori) is a semiconjugate prior.  Semiconjugacy may provide an efficient way
of sampling from posterior distributions and is used in
{help bayes_glossary##Gibbs_sampling:Gibbs sampling}.

{marker simulated_outcome}{...}
{phang}
{bf:simulated outcome}.
In Bayesian predictive inference, simulated outcomes are samples from the 
{help bayes_glossary##posterior_predictive_distribution:posterior predictive distribution}.
In the context of {helpb bayespredict}, we define a simulated outcome as a
T x n matrix of new outcome values simulated from the posterior predictive
distribution, p({bf:ỹ}|{bf:y}), for a particular outcome variable {bf:y},
where T is the MCMC sample size and n is the number of observations.

{marker stationary_distribution}{...}
{phang}
{bf:stationary distribution}.
Stationary distribution of a stochastic process is a joint distribution that
does not change over time.  In the context of MCMC, stationary distribution is
the target probability distribution to which the Markov chain converges.  When
MCMC is used for simulating a Bayesian model, the stationary distribution is
the target joint posterior distribution of model parameters.

{phang}
{bf:subjective prior}.  See
{it:{help bayes_glossary##informative_prior:informative prior}}.

{phang}
{bf:subsampling the chain}.  See
{it:{help bayes_glossary##thinning:thinning}}.

{marker sufficient_statistic}{...}
{phang}
{bf:sufficient statistic}.
Sufficient statistic for a parameter of a parametric likelihood model is any
function of the sample that contains all the information about the model
parameter.

{marker test_quantity}{...}
{phang}
{bf:test quantity}.
In Bayesian predictive inference, test quantity is any function of a
{help bayes_glossary##simulated_outcome:simulated outcome}, {bf:y}^{sim}, 
and model parameters theta.  It is estimated by sampling from the joint
posterior distribution p({bf:y}^{sim},theta).  A test quantity that depends
only on {bf:y}^{sim} is called a test statistic.  Test quantities are used in 
{help bayes_glossary##posterior_predictive_checking:posterior predictive checking}
to assess model fit.

{marker test_statistic}{...}
{phang}
{bf:test statistic}.
A special case of a {help bayes_glossary##test_quantity:test quantity}
that depends only on the data.

{marker thinning}{...}
{phang}
{bf:thinning}.
Thinning is a way of reducing autocorrelation in the MCMC sample by
subsampling the MCMC chain every prespecified number of iterations determined
by the thinning interval.  For example, the thinning interval of 1 corresponds
to using the entire MCMC sample; the thinning interval of 2 corresponds to
using every other sample value; and the thinning interval of 3 corresponds to
using values from iterations 1, 4, 7, 10, and so on.  Thinning should be
applied with caution when used to reduce autocorrelation because it may not
always be the most appropriate way of improving the precision of estimates.

{phang}
{bf:vague prior}.  See
{it:{help bayes_glossary##noninformative_prior:noninformative prior}}.

{phang}
{bf:valid initial state}.  See
{it:{help bayes_glossary##feasible_initial_value:feasible initial value}}.

{phang}
{bf:vanishing adaptation}.  See
{it:{help bayes_glossary##diminishing_adaptation:diminishing adaptation}}.

{marker zellnersg}{...}
{phang}
{bf:Zellner's g-prior}.
Zellner's g-prior is a form of a weakly informative prior for the regression
coefficients in a linear model.  It accounts for the correlation between the
predictor variables and controls the impact of the prior of the regression
coefficients on the posterior with parameter g.  For example, g=1 means that
prior weight is 50% and g rightarrow infty means diffuse prior.
{p_end}


{marker reference}{...}
{title:Reference}

{marker gelmanetal2014}{...}
{phang}
Gelman, A., J. B. Carlin, H. S. Stern, D. B. Dunson, A. Vehtari, and
D. B. Rubin. 2014. {it:Bayesian Data Analysis}. 3rd ed.
Boca Raton, FL: Chapman & Hall/CRC.
{p_end}
