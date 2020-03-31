{smcl}
{* *! version 1.0.9  25apr2019}{...}
{viewerdialog "bayes: mestreg" "dialog bayes_mestreg"}{...}
{vieweralsosee "[BAYES] bayes: mestreg" "mansection BAYES bayesmestreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_mestreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_mestreg##menu"}{...}
{viewerjumpto "Description" "bayes_mestreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_mestreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_mestreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_mestreg##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: mestreg} {hline 2}}Bayesian multilevel
parametric survival models{p_end}
{p2col:}({mansection BAYES bayesmestreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt mestreg}
         {it:fe_equation} [{cmd:||} {it:re_equation}] 
	[{cmd:||} {it:re_equation} ...] 
	{cmd:,} {opth dist:ribution(mestreg##distname:distname)}
	[{it:{help bayes_mestreg##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin}
        [{it:{help bayes_mestreg##weight:weight}}]
	[{cmd:,} {it:{help bayes_mestreg##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:levelvar}{cmd::} [{varlist}]
		[{cmd:,} {it:{help bayes_mestreg##re_options:re_options}}]

{p 8 18 2}
	for a random effect among the values of a factor variable

{p 12 24 2}
	{it:levelvar}{cmd::} {cmd:R.}{varname}

{p 4 4 2}
    {it:levelvar} either is a variable identifying the group structure for the
    random effects at that level or is {cmd:_all}, representing one group
    comprising all observations.{p_end}

{synoptset 23 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the {help bayes_glossary##fixed_effects_parameters:fixed-effects} equation{p_end}
{synopt :{opth off:set(varname:varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(mestreg##vartype:vartype)}}variance-covariance 
structure of the {help bayes_glossary##random_effects_parameters:random effects}; only
structures {cmd:independent}, {cmd:identity}, and {cmd:unstructured}
supported{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects 
equation{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{p2coldent :* {opth dist:ribution(mestreg##distname:distname)}}specify survival
distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}

{syntab :Reporting}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
INCLUDE help bayesme_display

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt distribution(distname)} is required.{p_end}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:bayes: mestreg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:mestreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:mestreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help mestreg##options:{it:Options}} in {manhelp mestreg ME}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-ancillary parameters; default is {cmd:normalprior(100)}{p_end}
{p2coldent:* {opt igammapr:ior(# #)}}specify shape and scale of default inverse-gamma prior for variance components; default is {cmd:igammaprior(0.01 0.01)}{p_end}
{p2coldent:* {cmdab:iwishartpr:ior(}{help bayes##iwishartpriorspec:{it:#} [...]}{cmd:)}}specify degrees of freedom and, optionally, scale matrix of default inverse-Wishart prior for unstructured random-effects covariance{p_end}
{* INCLUDE help bayesecmd_opts*}
INCLUDE help bayesmh_prioropts

{marker options_simulation}{...}
{syntab:{help bayes##simulation_options:Simulation}}
INCLUDE help bayesmh_simopts
{synopt :{opt restubs(restub1 restub2 ...)}}specify stubs for random-effects parameters for all levels{p_end}

{marker options_blocking}{...}
{syntab:{help bayes##blocking_options:Blocking}}
{p2coldent:* {opt blocksize(#)}}maximum block size; default is {cmd:blocksize(50)}{p_end}
INCLUDE help bayesmh_blockopts
  {p2coldent:* {opt noblock:ing}}do not block parameters by default{p_end}

{marker options_initialization}{...}
{syntab:{help bayes##initialization_options:Initialization}}
INCLUDE help bayesmh_initopts
{p2coldent:* {opt noi:sily}}display output from the estimation command during initialization{p_end}

{marker options_adaptation}{...}
{syntab:{help bayes##adaptation_options:Adaptation}}
INCLUDE help bayesmh_adaptopts

{marker options_reporting}{...}
{syntab:{help bayes##reporting_options:Reporting}}
{* INCLUDE help bayesme_reportopts*}
INCLUDE help bayes_clevel_hpd_short
{p2coldent:* {opt nohr}}do not report hazard ratios{p_end}
{p2coldent:* {opt tr:atio}}report time ratios; requires option {cmd:time} with
{cmd:mestreg}{p_end}
INCLUDE help bayesmh_eform
{synopt :{opt remargl}}compute log marginal-likelihood{p_end}
{synopt :{opt batch(#)}}specify length of block for batch-means calculations;
default is {cmd:batch(0)}{p_end}
{synopt :{cmdab:sav:ing(}{help filename:{it:filename}}[{cmd:, replace}]{cmd:)}}save simulation results to {it:filename}{cmd:.dta}{p_end}
{synopt :{opt nomodelsumm:ary}}suppress model summary{p_end}
{synopt :{opt nomesumm:ary}}suppress multilevel-structure summary{p_end}
{synopt :[{cmd:no}]{opt dots}}suppress dots or display dots every 100
iterations and iteration numbers every 1,000 iterations; default is {cmd:dots}{p_end}
{synopt :{cmd:dots(}{it:#}[{cmd:,} {opt every(#)}]{cmd:)}}display dots as
simulation is performed {p_end}
{synopt :[{cmd:no}]{opth show:(bayesmh##paramref:paramref)}}specify model
parameters to be excluded from or included in the output{p_end}
{synopt :{opt showre:ffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]}specify that all or a subset of random-effects parameters be included in the output{p_end}
{synopt :{opt melabel}}display estimation table using the same row labels as
{cmd:mestreg}{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt notab:le}}suppress estimation table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt title(string)}}display {it:string} as title above the table of
parameter estimates{p_end}
{synopt :{help bayesmh##display_options:{it:display_options}}}control spacing,
line width, and base and empty cells{p_end}

{marker options_advanced}{...}
{syntab:{help bayes##advanced_options:Advanced}}
INCLUDE help bayesmh_advancedopts
{synoptline}
{p 4 6 2}* Starred options are specific to the {cmd:bayes} prefix; other
options are common between {cmd:bayes} and {helpb bayesmh}.{p_end}
{p 4 6 2}Options {cmd:prior()} and {cmd:block()} may be repeated.{p_end}
{p 4 6 2}{helpb bayesmh##priorspec:{it:priorspec}} and
{helpb bayesmh##paramref:{it:paramref}} are defined in {manhelp bayesmh BAYES}.
{p_end}
{p 4 6 2}{it:paramref} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}See {manhelp bayesian_postestimation BAYES:Bayesian postestimation} for
features available after estimation.{p_end}
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}},
ancillary parameters as described in
{mansection BAYES bayesmeglmRemarksandexamplesAdditionalmodelparameters:{it:Additional model parameters}},
random effects
{cmd:{c -(}}{it:rename}{cmd:{c )-}}, and either variance components
{cmd:{c -(}}{it:rename}{cmd::sigma2{c )-}} or, if option
{cmd:covariance(unstructured)} is specified, matrix parameter
{cmd:{c -(}}{it:restub}{cmd::Sigma,matrix{c )-}}; see
{mansection BAYES bayesRemarksandexamplesLikelihoodmodel:{it:Likelihood model}}
in {bf:[BAYES] bayes} for how {it:rename}s and {it:restub} are defined.
Use the {cmd:dryrun} option to see the definitions of model parameters
prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models > Bayesian regression > Parametric survival regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: mestreg} fits a Bayesian multilevel parametric survival model to
a survival-time outcome;
see {manhelp bayes BAYES} and {manhelp mestreg ME} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmestregQuickstart:Quick start}

        {mansection BAYES bayesmestregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmestregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples:  Setup}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse catheter}{p_end}
{phang2}{cmd:. stset}{p_end}


{title:Examples:  Exponential regression}

{pstd}
Fit Bayesian two-level exponential regression with random intercepts by 
{cmd:patient} using default priors and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, rseed(123): mestreg age female || patient:, distribution(exponential)}

{pstd}
Display coefficients instead of hazard ratios{p_end}
{phang2}{cmd:. bayes, nohr}

{pstd}
In addition to the main model parameters, display results for the first 5 
random effects{p_end}
{phang2}{cmd:. bayes, showreffects({U0[1/5]})}

{pstd}
Check MCMC convergence for the main model parameters{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}
Check MCMC convergence for patients 1, 10, and 20{p_end}
{phang2}{cmd:. bayesgraph diagnostics {U0[(1 10 20).patient]}}

{pstd}
Plot histograms of posterior distributions of the first 12 random effects 
on one graph{p_end}
{phang2}{cmd:. bayesgraph histogram {U0[1/12]}, byparm}

{pstd}
Display estimation results using {cmd:mestreg}'s parameter labels and 
compute log marginal-likelihood on replay{p_end}
{phang2}{cmd:. bayes, melabel remargl}

{pstd}
Save MCMC results on replay and store estimation results for later 
comparison{p_end}
{phang2}{cmd:. bayes, saving(mymcmc_exp)}{p_end}
{phang2}{cmd:. estimates store exp}{p_end}

{pstd}
Use the same uniform priors for all regression coefficients instead of the
default normal priors{p_end}
{phang2}{cmd:. bayes, prior({_t:age female _cons}, uniform(-10,10)): mestreg age female || patient:, distribution(exponential)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients{p_end}
{phang2}{cmd:. bayes, prior({_t:}, uniform(-10,10)): mestreg age female || patient:, distribution(exponential)}


{title:Examples:  Gamma regression}

{pstd}
Fit Bayesian two-level gamma regression with random intercepts by 
{cmd:patient} using default priors; specify random-number seed and compute 
log marginal-likelihood during estimation{p_end}
{phang2}{cmd:. bayes, rseed(123) remargl: mestreg age female || patient:, distribution(gamma)}

{pstd}
Check MCMC convergence for the main model parameters{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}
Save MCMC results on replay and store estimation results for later
comparison{p_end}
{phang2}{cmd:. bayes, saving(mymcmc_gamma)}{p_end}
{phang2}{cmd:. estimates store gamma}{p_end}


{title:Examples:  Weibull regression}

{pstd}
Fit Bayesian two-level Weibull regression with random intercepts by 
{cmd:patient} using default priors and specifying random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, rseed(123): mestreg age female || patient:, distribution(weibull)}

{pstd}
Check MCMC convergence for the main model parameters{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}
Increase the burn-in period to 5,000 from the default of 2,500 to improve
convergence and use the thinning interval of 4 to reduce autocorrelation{p_end}
{phang2}{cmd:. bayes, burnin(5000) thinning(4) rseed(123): mestreg age female || patient:, distribution(weibull)}

{pstd}
Check MCMC convergence for the main model parameters again{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}
Save MCMC results and compute log marginal-likelihood on replay; store 
estimation results for later comparison{p_end}
{phang2}{cmd:. bayes, saving(mymcmc_weibull) remargl}{p_end}
{phang2}{cmd:. estimates store weibull}{p_end}


{title:Examples:  Model comparison}

{pstd}
Compare models using exponential regression as the base model: based on Bayes
factors, exponential regression is a preferred model{p_end}
{phang2}{cmd:. bayesstats ic exp gamma weibull}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
