{smcl}
{* *! version 1.0.3  19oct2017}{...}
{vieweralsosee "[FMM] Glossary" "mansection FMM Glossary"}{...}
{viewerjumpto "Description" "fmm_glossary##description"}{...}
{viewerjumpto "Glossary" "fmm_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[FMM] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection FMM Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{marker categorical_latent_variable}{...}
{phang}
{bf:categorical latent variable}.
	A categorical latent variable has levels that represent unobserved
	groups in the population.  Latent classes are identified with the
	levels of the categorical latent variables and may represent healthy
	and unhealthy individuals, consumers with different buying
	preferences, or different motivations for delinquent behavior.

{marker class_model}{...}
{phang}
{bf:class model}.
	A class model is a regression model that is applied to one component
	in a mixture model.  In the absence of covariates, the regression
	model reduces to a distribution function.

{pmore}
Class model is also referred to in the literature as a
"component model",
"component density", or
"component distribution".

{marker class_probability}{...}
{phang}
{bf:class probability}.
	In the context of FMM, the probability of belonging to a given class.
	{cmd:fmm} uses multinomial logistic regression to model class
	probabilities.

{pmore}
Class probability is also referred to in the literature as a
"latent class probability",
"component probability",
"mixture component probability",
"mixing probability",
"mixing proportion",
"mixing weight", or
"mixture probability".

{phang}
{bf:EM algorithm}.
	See {help fmm_glossary##expectation_maximization:{it:expectation-maximization algorithm}}.

{marker expectation_maximization}{...}
{phang}
{bf:expectation-maximization algorithm}.
	In the context of FMM, an iterative procedure for refining starting
	values before maximizing the likelihood.  The EM algorithm uses the
	complete-data likelihood as if we have observed values for the latent
	class indicator variable.

{marker finite_mixture_model}{...}
{phang}
{bf:finite mixture model}.
	A finite mixture model (FMM) is a statistical model
	that assumes the presence of unobserved groups, called
	{help fmm_glossary##latent_class:latent classes},
	within an overall population.  Each latent class can be fit with its
	own regression model, which may have a linear or
	{help fmm_glossary##generalized_linear_response_functions:generalized linear response function}.
	We can compare models with differing numbers of latent classes and
	different sets of constraints on parameters to determine the best
	fitting model.  For a given model, we can compare parameter estimates
	across classes.  We can estimate the proportion of the population in
	each latent class, and we can predict the probabilities that the
	observations in our sample belong to each latent class.

{phang}
{bf:FMM}.
	See {help fmm_glossary##finite_mixture_model:{it:finite mixture model}}.

{marker generalized_linear_response_functions}{...}
{phang}
{bf:generalized linear response functions}.
	Generalized linear response functions include linear functions and
	include functions such as probit, logit, multinomial logit, ordered
	probit, ordered logit, Poisson, and more.

{pmore} 
	These generalized linear functions are described by a link function
	g() and statistical distribution F.  The link function g() specifies
	how the response variable y_i is related to a linear equation of the
	explanatory variables, {bf:x}_i{beta}, and the family F specifies the
	distribution of y_i:

            g{E(y_i)} = {bf:x}_i{beta}     y_i sim F

{pmore}
	If we specify that g() is the identity function and F is the Gaussian
	(normal) distribution, then we have linear regression.  If we specify
	that g() is the logit function and F the Bernoulli distribution, then
	we have logit (logistic) regression.

{pmore} 
	In this generalized linear structure, the family may be Gaussian,
	gamma,  Bernoulli, binomial, Poisson, negative binomial, ordinal, or
	multinomial.  The link function may be the identity, log, logit,
	probit, or complementary log-log.

{marker latent_class}{...}
{phang}
{bf:latent class}.
	A latent class is an unobserved group identified by a level of a
	{help fmm_glossary##categorical_latent_variable:categorical latent variable}.

{pmore}
Latent class is also referred to in the literature as a
"class",
"group",
"type", or
"mixture component".

{phang}
{bf:latent variable}.
	See {help fmm_glossary##categorical_latent_variable:{it:categorical latent variable}}.

{phang}
{bf:pointmass density}.
	In the context of FMM, a degenerate distribution that takes on a
	single integer value with probability one.  A pointmass density is
	used in combination with other FMM distributions to model, most
	commonly, zero-inflated outcomes.
{p_end}
