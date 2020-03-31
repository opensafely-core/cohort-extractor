{smcl}
{* *! version 1.0.2  19oct2017}{...}
{vieweralsosee "[IRT] Glossary" "mansection IRT Glossary"}{...}
{viewerjumpto "Description" "irt_glossary##description"}{...}
{viewerjumpto "Glossary" "irt_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[IRT] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection IRT Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:1PL}.
	See {help irt_glossary##1PL:{it:one-parameter logistic model}}.

{phang}
{bf:2PL}.
	See {help irt_glossary##2PL:{it:two-parameter logistic model}}.

{phang}
{bf:3PL}.
	See {help irt_glossary##3PL:{it:three-parameter logistic model}}.

{marker ability}{...}
{phang}
{bf:ability}.
	See {help irt_glossary##latent_trait:{it:latent trait}}.

{phang}
{bf:BCC}.
	See {help irt_glossary##BCC:{it:boundary characteristic curve}}.

{marker binary}{...}
{phang}
{bf:binary item}.
	A binary item is an item that is scored as either 0 or 1.

{marker BCC}{...}
{phang}
{bf:boundary characteristic curve}.
	A boundary characteristic curve (BCC) expresses the
	probability of transitioning across a given boundary threshold that
	separates the ordered item categories into two groups
	as a function of the latent trait.

{marker calibration}{...}
{phang}
{bf:calibration}.
	The procedure of estimating parameters of an IRT model.

{marker categorical}{...}
{phang}
{bf:categorical item}.
	A categorical item is an item that is either ordinal or nominal.

{phang}
{bf:category boundary curve}.
	See {help irt_glossary##BCC:{it:boundary characteristic curve}}.

{phang}
{bf:category boundary location}.
	See {help irt_glossary##difficulty:{it:difficulty}}.

{marker CCC}{...}
{phang}
{bf:category characteristic curve}.
	A category characteristic curve (CCC) expresses the
	probability of a response in a given item category as a
	function of the latent trait.

{phang}
{bf:category response function}.
	See {help irt_glossary##CCC:{it:category characteristic curve}}.

{phang}
{bf:CCC}.
	See {help irt_glossary##CCC:{it:category characteristic curve}}.

{marker conditional_independence}{...}
{phang}
{bf:conditional independence}.
	The assumption that responses are not correlated after
	controlling for the latent trait.

{marker dichotomous}{...}
{phang}
{bf:dichotomous item}.
	See {help irt_glossary##binary:{it:binary item}}.

{marker difficulty}{...}
{phang}
{bf:difficulty}.
	A level of the latent trait needed to pass an item or an item
	category.

{marker discrimination}{...}
{phang}
{bf:discrimination}.
	A measure of how well an item can distinguish between contiguous
	latent trait levels near the inflection point of an item characteristic
	curve.

{marker empirical_Bayes}{...}
{phang}
{bf:empirical Bayes}.
	In IRT models, empirical Bayes refers to the method of prediction
	of the latent trait after the model parameters have been estimated.
	The empirical Bayes method uses Bayesian principles to obtain the
	posterior distribution of the latent trait.  However, instead of
	assuming a prior distribution for the model parameters, one treats the
	parameters as given.

{marker GHQ}{...}
{phang}
{bf:Gauss-Hermite quadrature}.
	In the context of IRT models, Gauss-Hermite quadrature
	(GHQ) is a method of approximating the integral used in the
	calculation of the log likelihood.  The quadrature locations and
	weights for individuals are fixed during the optimization process.

{marker GPCM}{...}
{phang}
{bf:generalized partial credit model}.
	The generalized partial credit model (GPCM) is an IRT model for
	ordinal responses.  The categories within each item vary in their
	difficulty and share the same discrimination parameter.

{phang}
{bf:GHQ}.
	See {help irt_glossary##GHQ:{it:Gauss-Hermite quadrature}}.

{phang}
{bf:GPCM}.
	See {help irt_glossary##GPCM:{it:generalized partial credit model}}.

{marker GRM}{...}
{phang}
{bf:graded response model}.
	The graded response model (GRM) is an extension of the
	two-parameter logistic model to ordinal responses.
	The categories within each item vary in their difficulty and share the
	same discrimination parameter.

{phang}
{bf:GRM}.
	See {help irt_glossary##GRM:{it:graded response model}}.
	
{marker guessing}{...}
{phang}
{bf:guessing}.
	The guessing parameter incorporates the impact of chance on an
	observed response.  The parameter lifts the lower asymptote of
	the item characteristic curve above zero.

{marker hybrid_model}{...}
{phang}
{bf:hybrid model}.
	A hybrid IRT model is a model that performs a single calibration
	of an instrument consisting of different response formats.

{phang}
{bf:ICC}.
	See {help irt_glossary##ICC:{it:item characteristic curve}}.

{phang}
{bf:IIF}.
	See {help irt_glossary##IIF:{it:item information function}}.
	
{marker information}{...}
{phang}
{bf:information}.
	Precision with which an item or an instrument measures the
	latent trait; also see
	{help irt_glossary##IIF:{it:item information function}}
	and
	{help irt_glossary##TIF:{it:test information function}}.

{marker instrument}{...}
{phang}
{bf:instrument}.
	A collection of items, usually called a test, a survey, or
	a questionnaire.

{marker invariance}{...}
{phang}
{bf:invariance}.
	When an IRT model fits the data exactly in the population,
	then the estimated item parameters should be the same,
	within sampling error, regardless of what sample the data were
	derived from, and the estimated person latent traits should be the
	same regardless of what items they are based on.

{phang}
{bf:IRT}.
	See {help irt_glossary##IRT:{it:item response theory}}.

{marker item}{...}
{phang}
{bf:item}.
	An item is a single question or task on a test or an instrument.

{marker ICC}{...}
{phang}
{bf:item characteristic curve}.
	An item characteristic curve (ICC) expresses the probability
	for a given response to a binary item as a function of the latent
	trait.

{marker IIF}{...}
{phang}
{bf:item information function}.
	An item information function (IIF) indicates the precision of
	an item along the latent trait continuum.

{phang}
{bf:item location}.
	Location of an item on the difficulty scale.
	
{phang}
{bf:item response function}.
	See {help irt_glossary##ICC:{it:item characteristic curve}}.

{marker IRT}{...}
{phang}
{bf:item response theory}.
	Item response theory (IRT) is a theoretical framework
	organized around the concept of the latent trait.
	IRT encompasses a set of models and associated statistical
	procedures that relate observed responses on an instrument to a
	person's level of the latent trait.

{marker latent_space}{...}
{phang}
{bf:latent space}.
	Number of latent traits that are measured by an instrument.
	All IRT models described in this manual assume
	a unidimensional latent space or, in other words, that a single latent
	trait explains the response pattern.

{marker latent_trait}{...}
{phang}
{bf:latent trait}.
	A variable or construct that cannot be directly observed.

{phang}
{bf:local independence}.
	See {help irt_glossary##conditional_independence:{it:conditional independence}}.

{phang}
{bf:lower asymptote}.
	See {help irt_glossary##guessing:{it:guessing}}.

{phang}
{bf:MCAGHQ}.
	See {help irt_glossary##MCAGHQ:{it:mode-curvature adaptive Gauss-Hermite quadrature}}.

{marker MVAGHQ}{...}
{phang}
{bf:mean-variance adaptive Gauss-Hermite quadrature}.
	In the context of IRT models, mean-variance adaptive
	Gauss-Hermite quadrature (MVAGHQ)  is a method of
	approximating the integral used in the calculation of the log
	likelihood.  The quadrature locations and weights for individuals are
	updated during the optimization process by using the posterior mean
	and the posterior standard deviation.

{marker MCAGHQ}{...}
{phang}
{bf:mode-curvature adaptive Gauss-Hermite quadrature}.
	In the context of IRT models, mode-curvature adaptive Gauss-Hermite
	quadrature (MCAGHQ) is a method of approximating the integral
	used in the calculation of the log likelihood.  The quadrature
	locations and weights for individuals are updated during the
	optimization process by using the posterior mode and the standard
	deviation of the normal density that approximates the log posterior at
	the mode.

{phang}
{bf:MVAGHQ}.
	See {help irt_glossary##MVAGHQ:{it:mean-variance adaptive Gauss-Hermite quadrature}}.

{marker nominal}{...}
{phang}
{bf:nominal item}.
	A nominal {help irt_glossary##item:item} is an item scored in
	categories that have no natural ordering.

{marker NRM}{...}
{phang}
{bf:nominal response model}.
	The nominal response model (NRM) is an IRT model for
	nominal responses.  The categories within each item vary in their
	difficulty and discrimination.

{phang}
{bf:NRM}.
	See {help irt_glossary##NRM:{it:nominal response model}}.

{marker 1PL}{...}
{phang}
{bf:one-parameter logistic model}.
	The one-parameter logistic (1PL) model is an IRT model for
	binary responses where items vary in their difficulty but share
	the same discrimination parameter.

{phang}
{bf:operating characteristic curve}.
	See {help irt_glossary##CCC:{it:category characteristic curve}}.

{marker ordinal}{...}
{phang}
{bf:ordinal item}.
	An ordinal item is an item scored on a scale where a higher score
	indicates a "higher" outcome.

{marker PCM}{...}
{phang}
{bf:partial credit model}.
	The partial credit model (PCM) is an IRT model for
	ordinal responses. The categories across all items vary in their
	difficulty and share the same discrimination parameter.

{phang}
{bf:PCM}.
	See {help irt_glossary##PCM:{it:partial credit model}}.

{phang}
{bf:person location}.
	Location of a person on the latent trait scale.

{marker polytomous}{...}
{phang}
{bf:polytomous item}.
	See {help irt_glossary##categorical:{it:categorical item}}.

{marker posterior_mean}{...}
{phang}
{bf:posterior mean}.
	In IRT models, posterior mean refers to the predictions of the
	latent trait based on the mean of the posterior distribution.

{marker posterior_mode}{...}
{phang}
{bf:posterior mode}.
	In IRT models, posterior mode refers to the predictions of the
	latent trait based on the mode of the posterior distribution.

{phang}
{bf:quadrature}.
	Quadrature is a set of numerical methods to evaluate a
	definite integral.

{marker RSM}{...}
{phang}
{bf:rating scale model}.
	The rating scale model (RSM) is an IRT model for
	ordinal responses.  The categories within each item vary in their
	difficulty; however, the distances between adjacent difficulty
	parameters are constrained to be the same across the items.  The
	categories across all items share the same discrimination parameter.

{phang}
{bf:RSM}.
	See {help irt_glossary##RSM:{it:rating scale model}}.

{phang}
{bf:slope}.
	See {help irt_glossary##discrimination:{it:discrimination}}.

{phang}
{bf:TCC}.
	See {help irt_glossary##TCC:{it:test characteristic curve}}.

{marker TCC}{...}
{phang}
{bf:test characteristic curve}.
	A test characteristic curve (TCC) is the sum of
	item characteristic curves and represents the expected score
	on the instrument.

{marker TIF}{...}
{phang}
{bf:test information function}
	A test information function (TIF) is the sum of item
	information functions and indicates the precision of
	the entire instrument along the latent trait continuum.

{marker 3PL}{...}
{phang}
{bf:three-parameter logistic model}.
	The three-parameter logistic (3PL) model is an IRT model for
	binary responses where items vary in their difficulty and
	discrimination and can share or have their own guessing parameter.

{phang}
{bf:TIF}.
	See {help irt_glossary##TIF:{it:test information function}}.

{phang}
{bf:total characteristic curve}.
	See {help irt_glossary##TCC:{it:test characteristic curve}}.

{phang}
{bf:total information function}.
	See {help irt_glossary##TIF:{it:test information function}}.

{marker 2PL}{...}
{phang}
{bf:two-parameter logistic model}.
	The two-parameter logistic (2PL) model is an IRT model for
	binary responses where items vary in their difficulty and
	discrimination.

{phang}
{bf:unidimensionality}.
	See {help irt_glossary##latent_space:{it:latent space}}.
{p_end}
