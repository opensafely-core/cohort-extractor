{smcl}
{* *! version 1.1.16  17may2019}{...}
{viewerdialog bayesmh "dialog bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesmh evaluators" "help bayesmh evaluators"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayesmh##syntax"}{...}
{viewerjumpto "Menu" "bayesmh##menu"}{...}
{viewerjumpto "Description" "bayesmh##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesmh##linkspdf"}{...}
{viewerjumpto "Options" "bayesmh##options"}{...}
{viewerjumpto "Remarks" "bayesmh##remarks"}{...}
{viewerjumpto "Examples" "bayesmh##examples"}{...}
{viewerjumpto "Video examples" "bayesmh##video"}{...}
{viewerjumpto "Stored results" "bayesmh##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[BAYES] bayesmh} {hline 2}}Bayesian regression using Metropolis-Hastings algorithm{p_end}
{p2col:}({mansection BAYES bayesmh:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
{bf:Univariate linear models}
    
{p 8 16 2}
{opt bayesmh} {it:{help depvar:depvar}} [{indepvars}] 
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##modelspec:modelspec}}{cmd:)}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{opth re:ffects(varname)} {it:{help bayesmh##options_table:options}}]


{phang}
{bf:Multivariate linear models}

{p 6 11 2}
Multivariate normal linear regression with common regressors
    
{p 8 16 2}
{opt bayesmh} 
   {it:{help depvar:depvars}} {cmd:=} [{indepvars}]
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
   {opt likel:ihood}{cmd:(mvnormal(}...{cmd:))}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{it:{help bayesmh##options_table:options}}]

{p 6 11 2}
Multivariate normal regression with outcome-specific regressors 
    
{p 8 11 2}
{opt bayesmh} 
   {cmd:(}[{it:eqname1}{cmd::}]{it:{help depvar:depvar1}} [{it:{help indepvars:indepvars1}}]{cmd:)} 
{p_end}
{p 16 16 0}
   {cmd:(}[{it:eqname2}{cmd::}]{it:{help depvar:depvar2}} [{it:{help indepvars:indepvars2}}]{cmd:)}
   [...]
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
{p_end}
{p 16 16 0}
   {opt likel:ihood}{cmd:(mvnormal(}...{cmd:))}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{it:{help bayesmh##options_table:options}}]


{phang}
{bf:Multiple-equation linear models}

{p 8 11 2}
{opt bayesmh} 
   {cmd:(}{it:{help bayesmh##eqspec:eqspec}}{cmd:)}
   [{cmd:(}{it:{help bayesmh##eqspec:eqspec}}{cmd:)}] 
   [...]
   {ifin} 
   [{it:{help bayesmh##weight:weight}}]{cmd:,}
{p_end}
{p 16 16 0}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{it:{help bayesmh##options_table:options}}]


{phang}
{bf:Nonlinear models}

{p 6 11 2}
Univariate nonlinear regression

{p 8 11 2}
{opt bayesmh} 
{it:{help depvar:depvar}} {cmd:=} {cmd:(}{it:{help bayesmh##subexpr:subexpr}}{cmd:)}
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
{p_end}
{p 16 11 0}
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##modelspec:modelspec}}{cmd:)}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)} 
   [{it:{help bayesmh##options_table:options}}]
{p_end}

{p 6 11 2}
Multivariate normal nonlinear regression

{p 8 11 2}
{opt bayesmh} 
   {cmd:(}{it:{help depvar:depvar1}} {cmd:=} {cmd:(}{it:{help bayesmh##subexpr:subexpr1}}{cmd:))}
{p_end}
{p 16 11 0}
   {cmd:(}{it:{help depvar:depvar2}} {cmd:=} {cmd:(}{it:{help bayesmh##subexpr:subexpr2}}{cmd:))}
   [...]
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
{p_end}
{p 16 11 0}
   {opt likel:ihood}{cmd:(mvnormal(}...{cmd:))}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)} 
   [{it:{help bayesmh##options_table:options}}]
{p_end}


{phang}
{bf:Probability distributions}

{p 6 11 2}
Univariate distributions
    
{p 8 16 2}
{opt bayesmh} {it:{help depvar:depvar}} 
   {ifin}
   [{it:{help bayesmh##weight:weight}}]{cmd:,} 
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##distribution:distribution}}{cmd:)}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{it:{help bayesmh##options_table:options}}]

{p 6 11 2}
Multiple-equation distribution specifications

{p 8 11 2}
{opt bayesmh} 
   {cmd:(}{it:{help bayesmh##deqspec:deqspec}}{cmd:)}
   [{cmd:(}{it:{help bayesmh##deqspec:deqspec}}{cmd:)}] 
   [...]
   {ifin} 
   [{it:{help bayesmh##weight:weight}}]{cmd:,}
{p_end}
{p 16 16 0}
   {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}
   [{it:{help bayesmh##options_table:options}}]


{marker eqspec}{...}
{pstd}
The syntax of {it:eqspec} is 

{phang2}
   {it:{help bayesmh##varspec:varspec}}   
   {ifin} [{it:{help bayesmh##weight:weight}}]{cmd:,}
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##modelspec:modelspec}}{cmd:)}
   [{opt nocons:tant}] 
{p_end}

{marker varspec}{...}
{phang2}
The syntax of {it:varspec} is one of the following:

            for single outcome

{p 16 18 2}
[{it:eqname}{cmd::}]{it:{help depvar:depvar}} [{indepvars}]
{p_end}

            for multiple outcomes with common regressors

{p 16 18 2}
{it:{help depvar:depvars}} {cmd:=} [{indepvars}]
{p_end}

            for multiple outcomes with outcome-specific regressors

{p 16 18 2}
{cmd:(}[{it:eqname1}{cmd::}]{it:{help depvar:depvar1}} [{it:{help indepvars:indepvars1}}]{cmd:)} 
{cmd:(}[{it:eqname2}{cmd::}]{it:{help depvar:depvar2}} [{it:{help indepvars:indepvars2}}]{cmd:)} [...] 
{p_end}

{marker deqspec}{...}
{pstd}
The syntax of {it:deqspec} is 

{phang2}
   [{it:eqname}{cmd::}] {it:{help depvar:depvar}}   
   {ifin} [{it:{help bayesmh##weight:weight}}]{cmd:,}
   {opt likel:ihood}{cmd:(}{it:{help bayesmh##distribution:distribution}}{cmd:)}
{p_end}

{marker subexpr}{...}
{pstd}
{it:subexpr}, {it:subexpr1}, {it:subexpr2}, and so on are substitutable
expressions; see
{help bayesmh##subexp:{it:Substitutable expressions}} for details.

{marker modelspec}{...}
{phang}
The syntax of {it:modelspec} is

{p 16 18 2}
{it:{help bayesmh##model:model}}
[{cmd:,} {it:{help bayesmh##modelopts:modelopts}}]


{synoptset 22 tabbed}{...}
{marker model}{...}
{synopthdr:model}
{synoptline}
{syntab:Model}
{synopt :{opt norm:al(var)}}normal regression with variance {it:var}{p_end}
{synopt :{opt t(sigma2, df)}}t regression with squared scale {it:sigma2} and degrees of freedom {it:df}{p_end}
{synopt :{opt lognorm:al(var)}}lognormal regression with variance {it:var}{p_end}
{synopt :{opt lnorm:al(var)}}synonym for {cmd:lognormal()}{p_end}
{synopt :{opt exp:onential}}exponential regression{p_end}
{synopt :{opt mvn:ormal(Sigma)}}multivariate normal regression with covariance matrix {it:Sigma}{p_end}

{synopt :{opt probit}}probit regression{p_end}
{synopt :{opt logit}}logistic regression{p_end}
{synopt :{opt logis:tic}}logistic regression; synonym for {cmd:logit}{p_end}
{synopt :{opt binom:ial(n)}}binomial regression with logit link and number of trials {it:n}{p_end}
{synopt :{opt binlogit(n)}}synonym for {cmd:binomial()}{p_end}
{synopt :{opt oprobit}}ordered probit regression{p_end}
{synopt :{opt ologit}}ordered logistic regression{p_end}
{synopt :{opt pois:son}}Poisson regression{p_end}

{synopt :{opt llf(subexpr)}}substitutable expression for observation-level
log-likelihood function{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A distribution argument is a number for scalar arguments such as {it:var};
a variable name, {varname} (except for matrix arguments); a matrix for matrix
arguments such as {it:Sigma}; a model parameter,
{it:{help bayesmh##paramspec:paramspec}}; an expression, {it:{help exp:expr}};
or a substitutable expression, {it:{help bayesmh##subexpr:subexpr}}.
See {mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}.{p_end}

{synoptset 22 tabbed}{...}
{marker modelopts}{...}
{synopthdr:modelopts}
{synoptline}
{syntab:Model}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model
with coefficient constrained to 1; not allowed with {cmd:normal()} and
{cmd:mvnormal()}{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1; allowed only with {cmd:poisson}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22 tabbed}{...}
{marker distribution}{...}
{synopthdr:distribution}
{synoptline}
{syntab:Model}
{synopt :{opt dexp:onential(beta)}}exponential distribution with scale parameter {it:beta}{p_end}
{synopt :{opt dbern:oulli(p)}}Bernoulli distribution with success probability {it:p}{p_end}
{synopt :{opt dbinom:ial(p,n)}}binomial distribution with success probability {it:p} and number of trials {it:n}{p_end}
{synopt :{opt dpois:son(mu)}}Poisson distribution with mean {it:mu}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A distribution argument is a model parameter,
{it:{help bayesmh##paramspec:paramspec}}, or a substitutable expression,
{it:{help bayesmh##subexpr:subexpr}}, containing model parameters.  An
{it:n} argument may be a number; an expression, {it:{help exp:expr}}; or a
variable name, {varname}.
See {mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}.{p_end}

{marker priorspec}{...}
{phang}
The syntax of {it:priorspec} is 

{p 8 11 2}
{it:{help bayesmh##paramref:paramref}}{cmd:,}
{it:{help bayesmh##priordist:priordist}}

{marker paramref}{...}
{phang}
where the simplest specification of {it:paramref} is 

{p 8 11 2}
{it:{help bayesmh##paramspec:paramspec}} [{it:paramspec}] [...]]

{phang}
Also see {help bayesmh##refer:{it:Referring to model parameters}}
for other specifications.

{marker paramspec}{...}
{phang}
The syntax of {it:paramspec} is 

{p 8 11 2}
{cmd:{c -(}}[{it:eqname}{cmd::}]{it:param}[, {opt m:atrix}]{cmd:{c )-}}

{phang}
where the parameter label {it:eqname} and parameter name {it:param} are valid Stata names.  
Model parameters are either scalars such as {cmd:{c -(}}{cmd:var}{cmd:{c )-}}, {cmd:{c -(}}{cmd:mean}{cmd:{c )-}}, {cmd:{c -(}}{cmd:scale:beta}{cmd:{c )-}}, 
or matrices such as {cmd:{c -(}}{cmd:Sigma, matrix}{cmd:{c )-}} and 
{cmd:{c -(}}{cmd:Scale:V, matrix}{cmd:{c )-}}.  For scalar parameters, you can
use {cmd:{c -(}}{it:param}{cmd:=}{it:#}{cmd:{c )-}} to specify an initial
value.  For example, you can specify, {cmd:{c -(}}{cmd:var=1}{cmd:{c )-}},
{cmd:{c -(}mean=1.267{c )-}}, or {cmd: {c -(}shape:alpha=3{c )-}}.

{synoptset 28 tabbed}{...}
{marker priordist}{...}
{synopthdr:priordist}
{synoptline}
{syntab:Model}
{synopt :{opt norm:al(mu,var)}}normal with mean {it:mu} and variance {it:var}{p_end}
{synopt :{opt t(mu,sigma2,df)}}location-scale {it:t} with mean {it:mu}, squared scale {it:sigma2}, and degrees of freedom {it:df}{p_end}
{synopt :{opt lognorm:al(mu,var)}}lognormal with mean {it:mu} and variance {it:var}{p_end}
{synopt :{opt lnorm:al(mu,var)}}synonym for {cmd:lognormal()}{p_end}
{synopt :{opt unif:orm(a,b)}}uniform on (a,b){p_end}
{synopt :{opt gamma(alpha,beta)}}gamma with shape {it:alpha} and scale
{it:beta}{p_end}
{synopt :{opt igamma(alpha,beta)}}inverse gamma with shape {it:alpha} and
scale {it:beta}{p_end}
{synopt :{opt exp:onential(beta)}}exponential with scale {it:beta}{p_end}
{synopt :{opt beta(a,b)}}beta with shape parameters {it:a} and {it:b}{p_end}
{synopt :{opt laplace(mu,beta)}}Laplace with mean {it:mu} and scale {it:beta}{p_end}
{synopt :{opt cauchy(loc,beta)}}Cauchy with location {it:loc} and scale {it:beta}{p_end}
{synopt :{opt chi2(df)}}central chi-squared with degrees of freedom {it:df}{p_end}
{synopt :{opt pareto(alpha,beta)}}Pareto with shape {it:alpha} and scale
{it:beta}{p_end}
{synopt :{opt jeff:reys}}Jeffreys prior for variance of a normal distribution{p_end}

{synopt :{opt mvn:ormal(d,mean,Sigma)}}multivariate normal of dimension {it:d}
with mean vector {it:mean} and covariance matrix {it:Sigma}; {it:mean} can be
a matrix name or a list of {it:d} means separated by comma: {it:mu1}{cmd:,}
{it:mu2}{cmd:,} ...{cmd:,} {it:mud}{p_end}
{synopt :{opt mvnormal0(d,Sigma)}}multivariate normal of dimension {it:d} with
zero mean vector and covariance matrix {it:Sigma}{p_end}
{synopt :{opt mvn0(d,Sigma)}}synonym for {cmd:mvnormal0()}{p_end}
{synopt :{cmd:zellnersg(}{it:d}{cmd:,}{it:g}{cmd:,}{it:mean}{cmd:,{c -(}}{it:var}{cmd:{c )-})}}Zellner's g-prior of
dimension {it:d} with {it:g} degrees of freedom, mean vector {it:mean}, and
variance parameter {cmd:{c -(}}{it:var}{cmd:{c )-}}; {it:mean} can be a matrix
name or a list of {it:d} means separated by comma: {it:mu1}{cmd:,}
{it:mu2}{cmd:,} ...{cmd:,} {it:mud}{p_end}
{synopt :{cmd:zellnersg0(}{it:d}{cmd:,}{it:g}{cmd:,{c -(}}{it:var}{cmd:{c )-})}}Zellner's g-prior of dimension
{it:d} with {it:g} degrees of freedom, zero mean vector, and variance
parameter {cmd:{c -(}}{it:var}{cmd:{c )-}}{p_end}
{synopt :{opt dirichlet(a_1,a_2,...,a_d)}}Dirichlet
(multivariate beta) of dimension {it:d} with shape parameters
{it:a_1}, {it:a_2}, ..., {it:a_d}{p_end}
{synopt :{opt wish:art(d,df,V)}}Wishart of dimension {it:d} with degrees of freedom {it:df} and scale matrix {it:V}{p_end}
{synopt :{opt iwish:art(d,df,V)}}inverse Wishart of dimension {it:d} with degrees of freedom {it:df} and scale matrix {it:V}{p_end}
{synopt :{opt jeff:reys(d)}}Jeffreys prior for covariance of a multivariate normal distribution of dimension {it:d}{p_end}

{synopt :{opt bern:oulli(p)}}Bernoulli with success probability {it:p}{p_end}
{synopt :{opt geometric(p)}}geometric for the number of failures before
the first success with success probability on one trial {it:p}{p_end}
{synopt :{opt index(p1,...,pk)}}discrete indices 1, 2, ..., {it:k} with
probabilities {it:p1}, {it:p2}, ..., {it:pk}{p_end}
{synopt :{opt pois:son(mu)}}Poisson with mean {it:mu}{p_end}

{marker modelspec_table}{...}
{synopt :{opt flat}}flat prior; equivalent to {cmd:density(1)} or
{cmd:logdensity(0)}{p_end}
{synopt :{opt dens:ity}{cmd:(}{it:{help bayesmh##generic_f:f}}{cmd:)}}generic density {it:f}{p_end}
{synopt :{opt logdens:ity}{cmd:(}{it:{help bayesmh##generic_logf:logf}}{cmd:)}}generic logdensity {it:logf}{p_end}
{synoptset 27 tabbed}{...}
{synoptline}
{phang}
Dimension {it:d} is a positive {it:#}.{p_end}
{phang}
A distribution argument is a number for scalar arguments such as {it:var},
{it:alpha}, {it:beta}; a Stata matrix for matrix arguments such as {it:Sigma}
and {it:V}; a model parameter, {it:{help bayesmh##paramspec:paramspec}}; an
expression, {it:{help exp:expr}}; or a substitutable expression
{it:{help bayesmh##subexpr:subexpr}}.
See {mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}.{p_end}
{phang}
{marker generic_f}
{it:f} is a nonnegative number, {it:#}; an expression
{it:{help exp:expr}}; or a substitutable expression,
{it:{help bayesmh##subexpr:subexpr}}.{p_end}
{phang}
{marker generic_logf}
{it:logf} is a number, {it:#}; an expression, {it:{help exp:expr}}; or a
substitutable expression, {it:{help bayesmh##subexpr:subexpr}}.{p_end}
{phang}
When {cmd:mvnormal()} or {cmd:mvnormal0()} of dimension {it:d} is applied to 
{it:{help bayesmh##paramref:paramref}} with {it:n} parameters ({it:n}!={it:d}), 
{it:paramref} is reshaped into a matrix with {it:d} columns, and its 
rows are treated as independent samples from the specified {cmd:mvnormal()} 
distribution. If such reshaping is not possible, an error is issued.
See {mansection BAYES bayesmhRemarksandexamplesex25:example 25} for
application of this feature.{p_end}

{synoptset 30 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term; not allowed with ordered models, nonlinear models, and probability distributions{p_end}
{p2coldent:* {opt likel:ihood}{cmd:(}{it:{help bayesmh##lspec:lspec}}{cmd:)}}distribution for the likelihood model{p_end}
{p2coldent:* {opt prior}{cmd:(}{it:{help bayesmh##priorspec:priorspec}}{cmd:)}}prior for model parameters; this option may be repeated{p_end}
{synopt :{opt dryrun}}show model summary without estimation{p_end}

{syntab :Model 2}
{synopt :{opt redef:ine}{cmd:(}{it:label}{cmd::i.}{it:{help varname:varname}}{cmd:)}}specify a random-effects linear form; this option may be repeated{p_end}
{synopt :{opt xbdef:ine}{cmd:(}{it:label}{cmd::}{it:{help varlist:varlist}}{cmd:)}}specify a linear form{p_end}

{marker options_simulation}{...}
{syntab:Simulation}
INCLUDE help bayesmh_simopts

{marker options_blocking}{...}
{syntab:Blocking}
INCLUDE help bayesmh_blockopts

{marker options_initialization}{...}
{syntab:Initialization}
INCLUDE help bayesmh_initopts

{marker options_adaptation}{...}
{syntab:Adaptation}
INCLUDE help bayesmh_adaptopts

{marker options_reporting}{...}
{syntab:Reporting}
INCLUDE help bayesmh_reportopts

{marker options_advanced}{...}
{syntab:Advanced}
INCLUDE help bayesmh_advancedopts
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Options {cmd:likelihood()} and {cmd:prior()} are required.
{cmd:prior()} must be specified for all model parameters.{p_end}
{p 4 6 2}Options {cmd:prior()}, {cmd:redefine()}, and {cmd:block()} may be repeated.{p_end}
{p 4 6 2}{it:indepvars} and {it:{help bayesmh##paramref:paramref}} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}With multiple-equations specifications, a local {it:{help if}}
specified within an equation is applied together with the global {it:if}
specified with the command.{p_end}
{marker weight}{...}
{p 4 6 2}Only {cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}With multiple-equations specifications, local weights or (weights
specified within an equation) override global weights (weights specified with
the command).{p_end}
{p 4 6 2}See {manhelp bayesian_postestimation BAYES:Bayesian postestimation} for
features available after estimation.
{p_end}

{synoptset 30}{...}
{marker blockopts}{...}
{synopthdr: blockopts}
{synoptline}
{synopt :{opt gibbs}}requests Gibbs sampling; available for selected models
only and not allowed with {cmd:scale()}, {cmd:covariance()}, or {cmd:adaptation()}{p_end}
{synopt :{opt split}}requests that all parameters in a block be treated as separate blocks{p_end}
{synopt :{opt re:ffects}}requests that all parameters in a block be treated as random-effects parameters{p_end}
{synopt :{opt sc:ale(#)}}initial multiplier for scale factor for current
block; default is {cmd:scale(2.38)}; not allowed with {cmd:gibbs}{p_end}
{synopt :{opt cov:ariance(cov)}}initial proposal covariance for the current
block; default is the identity matrix; not allowed with {cmd:gibbs}{p_end}
{synopt :{opth adapt:ation(bayesmh##adaptopts:adaptopts)}}control the adaptive
MCMC procedure of the current block; not allowed with {cmd:gibbs}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Only {cmd:tarate()} and {cmd:tolerance()} may be specified in the
{cmd:adaptation()} option.{p_end}

{synoptset 30 tabbed}{...}
{marker adaptopts}{...}
{synopthdr: adaptopts}
{synoptline}
{synopt :{opt every(#)}}adaptation interval; default is {cmd:every(100)}{p_end}
{synopt :{opt maxiter(#)}}maximum number of adaptation loops; default is
{cmd:maxiter(25)} or max{c -(}25,{cmd:floor(burnin()/every())}{c )-} whenever
default values of these options are modified{p_end}
{synopt :{opt miniter(#)}}minimum number of adaptation loops; default is {cmd:miniter(5)}{p_end}
{synopt :{opt alpha(#)}}parameter controlling acceptance rate (AR); default is {cmd:alpha(0.75)}{p_end}
{synopt :{opt beta(#)}}parameter controlling proposal covariance; default is {cmd:beta(0.8)}{p_end}
{synopt :{opt gamma(#)}}parameter controlling adaptation rate; default is {cmd:gamma(0)}{p_end}
{p2coldent :* {opt tarate(#)}}target acceptance rate (TAR); default is parameter specific{p_end}
{p2coldent :* {opt tol:erance(#)}}tolerance for AR; default is {cmd:tolerance(0.01)}{p_end}
{synoptset 27 tabbed}{...}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Only starred options may be specified in the {cmd:adaptation()} option
specified within {cmd:block()}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > General estimation and regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesmh} fits a variety of Bayesian models using an adaptive
Metropolis-Hastings (MH) algorithm.  It provides various likelihood models and
prior distributions for you to choose from.  Likelihood models include
univariate normal linear and nonlinear regressions, multivariate normal linear
and nonlinear regressions, generalized linear models such as logit and Poisson
regressions, and multiple-equations linear models.  Prior distributions
include continuous distributions such as uniform, Jeffreys, normal, gamma,
multivariate normal, and Wishart and discrete distributions such as Bernoulli
and Poisson.  You can also program your own Bayesian models; see
{manhelp bayesmh_evaluators BAYES:bayesmh evaluators}.

{pstd}
Also see {manhelp bayesian_estimation BAYES:Bayesian estimation} for a list of
Bayesian regression models that can be fit more conveniently with the
{opt bayes} prefix ({manhelp bayes BAYES}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmhQuickstart:Quick start}

        {mansection BAYES bayesmhRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmhMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant term (intercept) from the regression
model. By default, {cmd:bayesmh} automatically includes a model parameter
{cmd:{c -(}}{it:depname}{cmd::_cons{c )-}} in all regression models except
ordered and nonlinear models. Excluding the constant term may be desirable
when there is a factor variable, the base level of which absorbs the constant
term in the linear combination.

{phang}
{marker dist_spec}
{marker lspec}
{opt likelihood(lspec)} specifies the distribution of the data.  This option
specifies the likelihood portion of the Bayesian model. This option is
required.  {it:lspec} is one of {it:{help bayesmh##modelspec:modelspec}} or 
{it:{help bayesmh##distribution:distribution}}.

{pmore}
{it:{help bayesmh##modelspec:modelspec}} specifies one of the supported
likelihood distributions for regression models.  A location parameter of these
distributions is automatically parameterized as a linear combination of the
specified independent variables and needs not be specified.  Other parameters
may be specified as arguments to the distribution separated by commas. Each
argument may be a real number ({it:#}), a variable name (except for matrix
parameters), a predefined matrix, a model parameter specified in
{cmd:{c -(} {c )-}}, a Stata expression, or a substitutable expression
containing model parameters; see
{mansection BAYES bayesmhRemarksandexamplesDeclaringmodelparameters:{it:Declaring model parameters}} and
{mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}
in {bf:[BAYES] bayesmh}.

{pmore}
{it:{help bayesmh##distribution:distribution}} specifies one of the supported 
distributions for modeling the dependent variable.  A distribution argument 
must be a model parameter specified in {cmd:{c -(} {c )-}} or a substitutable 
expression containing model parameters; see
{mansection BAYES bayesmhRemarksandexamplesDeclaringmodelparameters:{it:Declaring model parameters}} and
{mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}
in {bf:[BAYES] bayesmh}.
A number of trials, {it:n}, of the binomial distribution may be a real
number ({it:#}), a Stata expression, or a variable name.  For an example of
modeling outcome distributions directly, see
{mansection BAYES bayesmhRemarksandexamplesBeta-binomialmodel:{it:Beta-binomial model}}
in {bf:[BAYES] bayesmh}.

{pmore}
For some regression {help bayesmh##model:models}, option {cmd:likelihood()}
provides suboptions {it:subopts} in {opt likelihood(..., subopts)}.
{it:subopts} is {cmd:offset()} and {cmd:exposure()}.

{marker offset}{...}
{phang2}
{opth offset:(varname:varname_o)} specifies that {it:varname_o} be included
in the regression model with the coefficient constrained to be 1.  This option
is available with {cmd:probit}, {cmd:logit}, {cmd:binomial()},
{cmd:binlogit()}, {cmd:oprobit}, {cmd:ologit}, and {cmd:poisson}.

{marker exposure}{...}
{phang2}
{opth exposure:(varname:varname_e)} specifies a variable that reflects the
amount of exposure over which the {depvar} events were observed for each
observation; ln({it:varname_e}) with coefficient constrained to be 1 is
entered into the log-link function. This option is available with
{cmd:poisson}.

{* similar to bayesmh_prioroptsdes.ihlp}{...}
{phang}
{opt prior(priorspec)} specifies a prior distribution for model parameters.
This option is required and may be repeated.  A prior must be specified for
each model parameter.  Model parameters may be scalars or matrices, but both
types may not be combined in one prior statement.  If multiple scalar
parameters are assigned a single univariate prior, they are considered
independent, and the specified prior is used for each parameter.  You may
assign a multivariate prior of dimension {it:d} to {it:d} scalar parameters.
Also see
{help bayesmh##refer:{it:Referring to model parameters}} below
and
{mansection BAYES bayesmhRemarksandexamplesSpecifyingargumentsoflikelihoodmodelsandpriordistributions:{it:Specifying arguments of likelihood models and prior distributions}}
in {bf:[BAYES] bayesmh}.

{pstd}
All {cmd:likelihood()} and {cmd:prior()} combinations are allowed, but they
are not guaranteed to correspond to proper posterior distributions.  You need
to think carefully about the model you are building and evaluate its
convergence thoroughly; see
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}} in {bf:[BAYES] bayesmh}.

{phang}
{opt dryrun} specifies to show the summary of the model that would be fit
without actually fitting the model.  This option is recommended for checking
specifications of the model before fitting the model.  The model summary
reports the information about the likelihood model and about priors for all
model parameters.

{dlgtab:Model 2}

{phang}
{opth reffects(varname)} specifies a random-effects variable, a variable
identifying the group structure for the random effects, with univariate linear
models.  This option is useful for fitting two-level random-intercept models.
A random-effects variable is treated as a factor variable with no base level.
As such, you can refer to random-effects parameters or, simply, random effects
associated with {it:varname} using a conventional factor-variable notation.
For example, you can use
{cmd:{c -(}}{it:depvar}{cmd::i.}{it:varname}{cmd:{c )-}} to refer to all
random-effects parameters of {it:varname}.  These parameters must be included
in a single prior statement, usually a normal distribution with variance
specified by an additional parameter.  The random-effects parameters are
assumed to be conditionally independent across levels of {it:varname} given
all other model parameters.  The random-effects parameters are automatically
grouped in one block and are thus not allowed in the {cmd:block()} option.  
See {mansection BAYES bayesmhRemarksandexamplesex23:example 23}.

{phang}
{cmd:redefine(}{it:label}{cmd::i.}{it:{help varname:varname}}{cmd:)}
specifies a random-effects linear form that can be used in substitutable
expressions.  You can use {cmd:{c -(}}{it:label}{cmd::{c )-}} to refer to the
linear form in substitutable expressions.  You can specify
{cmd:{c -(}}{it:label}{cmd::i.}{it:varname}{cmd:{c )-}} to refer to all
random-effects parameters associated with {it:varname}.  The random-effects
parameters are automatically grouped in one block and are thus not allowed in
the {cmd:block()} option.  This option is useful for fitting multilevel
models and may be repeated.  See {mansection BAYES bayesmhRemarksandexamplesex29:example 29}.

{phang}
{cmd:xbdefine(}{it:label}{cmd::}{it:{help varlist:varlist}}{cmd:)}
specifies a linear form of the variables in {it:varlist} that can be used in
substitutable expressions.  You can use the specification
{cmd:{c -(}}{it:label}{cmd::{c )-}} to refer to the linear form in
substitutable expressions.  For any {it:varname} in {it:varlist}, you can use
{cmd:{c -(}}{it:label}{cmd::}{it:varname}{cmd:{c )-}} to refer to the
corresponding parameter. This option is useful with nonlinear specifications
when the linear form contains many variables and provides more efficient
computation in such cases.  

{dlgtab:Simulation}

INCLUDE help bayesmh_nchainsoptdes

{phang}
{opt mcmcsize(#)} specifies the target MCMC sample size.  The
default MCMC sample size is {cmd:mcmcsize(10000)}.  The total number of
iterations for the MH algorithm equals the sum of the burn-in iterations
and the MCMC sample size in the absence of thinning.  If thinning is
present, the total number of MCMC iterations is computed as
{cmd:burnin()} + ({cmd:mcmcsize()} - 1) x {cmd:thinning()} + 1.
Computation time of the MH algorithm is proportional to the total number of
iterations.  The MCMC sample size determines the precision of posterior
summaries, which may be different for different model parameters and will
depend on the efficiency of the Markov chain.  With multiple chains,
{cmd:mcmcsize()} applies to each chain.  Also see
{mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
in {bf:[BAYES] bayesmh}.

{phang}
{opt burnin(#)} specifies the number of iterations for the burn-in
period of MCMC.  The values of parameters simulated during burn-in are used
for adaptation purposes only and are not used for estimation.  The default is
{cmd:burnin(2500)}.  Typically, burn-in is chosen to be as long as or longer
than the adaptation period.
With multiple chains, {cmd:burnin()} applies to each chain.
Also see {mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
and
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}}
in {bf:[BAYES] bayesmh}.

{phang}
{opt thinning(#)} specifies the thinning interval.  Only simulated
values from every (1+k x {it:#})th iteration for
k = 0, 1, 2, ... are saved in the final MCMC sample; all other
simulated values are discarded.  The default is {cmd:thinning(1)}; that is,
all simulation values are saved.  Thinning greater than one is typically used
for decreasing the autocorrelation of the simulated MCMC sample.  With
multiple chains, {cmd:thinning()} applies to each chain.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results.  With one chain, {opt rseed(#)} is equivalent to typing
{cmd:set} {cmd:seed} {it:#} prior to calling {cmd:bayesmh}; see
{manhelp set_seed R:set seed}.  With multiple chains, you should use
{cmd:rseed()} for reproducibility; see
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}} in
{bf:[BAYES] bayesmh}.

{phang}
{opth exclude:(bayesmh##paramref:paramref)} specifies which model parameters
should be excluded from the final MCMC sample.  These model parameters will
not appear in the estimation table, and postestimation features for these
parameters and log marginal-likelihood will not be available.  This option is
useful for suppressing nuisance model parameters.  For example, if you have a
factor predictor variable with many levels but you are only interested in the
variability of the coefficients associated with its levels, not their actual
values, then you may wish to exclude this factor variable from the simulation
results.  If you simply want to omit some model parameters from the output,
see the {helpb bayesmh##noshow():noshow()} option.
{it:paramref} can include individual random-effects parameters.

{dlgtab:Blocking}

INCLUDE help bayesmh_blockoptsdes

{dlgtab:Initialization}

{marker initspec}{...}
INCLUDE help bayesmh_initoptsdes

{dlgtab:Adaptation}

{phang}
{opt adaptation(adaptopts)} controls adaptation of the MCMC procedure.
Adaptation takes place every prespecified number of MCMC iterations and
consists of tuning the proposal scale factor and proposal covariance for each
block of model parameters.  Adaptation is used to improve sampling efficiency.
Provided defaults are based on theoretical results and may not be sufficient
for all applications.  See {mansection BAYES bayesmhRemarksandexamplesAdaptationoftheMHalgorithm:{it:Adaptation of the MH algorithm}}
in {bf:[BAYES] bayesmh} for details about adaptation and its parameters.

{pmore}
{it:adaptopts} are any of the following options:  

{phang2}
{opt every(#)} specifies that adaptation be attempted every {it:#}th
iteration.  The default is {cmd:every(100)}.  To determine the adaptation
interval, you need to consider the maximum block size specified in your model.
The update of a block with k model parameters requires the estimation of
a k x k covariance matrix.  If the adaptation interval is not sufficient
for estimating the k(k+1)/2 elements of this matrix, the adaptation
may be insufficient.

{phang2}
{opt maxiter(#)} specifies the maximum number of adaptive
iterations.  Adaptation includes tuning of the proposal covariance and of the
scale factor for each block of model parameters.  Once the TAR is achieved
within the specified tolerance, the adaptation stops.  However, no more than
{it:#} adaptation steps will be performed.  The default is variable and is
computed as max{25,{cmd:floor(burnin()/adaptation(every()))}}.

{pmore2}
{cmd:maxiter()} is usually chosen to be no greater than
({cmd:mcmcsize()}+{cmd:burnin()})/{cmd:adaptation(every())}.

{phang2}
{opt miniter(#)} specifies the minimum number of adaptive iterations to be
performed regardless of whether the TAR has been achieved.  The default is
{cmd:miniter(5)}.  If the specified {opt miniter()} is greater than
{opt maxiter()}, then {opt miniter()} is reset to {opt maxiter()}.  Thus, if
you specify {cmd:maxiter(0)}, then no adaptation will be performed.

{phang2}
{opt alpha(#)} specifies a parameter controlling the adaptation of the
AR.  {opt alpha()} should be in [0,1].  The default is {cmd:alpha(0.75)}.

{phang2}
{opt beta(#)} specifies a parameter controlling the adaptation of the
proposal covariance matrix.  {opt beta()} must be in [0,1].  The closer
{opt beta()} is to zero, the less adaptive the proposal covariance.  When
{opt beta()} is zero, the same proposal covariance will be used in all MCMC
iterations.  The default is {cmd:beta(0.8)}.

{phang2}
{opt gamma(#)} specifies a parameter controlling the adaptation rate
of the proposal covariance matrix.  {opt gamma()} must be in [0,1].  The
larger the value of {opt gamma()}, the less adaptive the proposal covariance.
The default is {cmd:gamma(0)}.

{phang2}
{opt tarate(#)} specifies the TAR for all blocks of model parameters; this is
rarely used.  {opt tarate()} must be in (0,1).  The default AR is 0.234 for
blocks containing continuous multiple parameters, 0.44 for blocks with one
continuous parameter, and 1/{it:n_maxlev} for blocks with discrete
parameters, where {it:n_maxlev} is the maximum number of levels for a
discrete parameter in the block.

{phang2}
{opt tolerance(#)} specifies the tolerance criterion for adaptation
based on the TAR.  {opt tolerance()} should be in (0,1).
Adaptation stops whenever the absolute difference between the current AR and
TAR is less than {opt tolerance()}.  The default is {cmd:tolerance(0.01)}.

{phang}
{opt scale(#)} specifies an initial multiplier for the scale factor for
all blocks.  The initial scale factor is computed as {it:#}/sqrt{n_p}
for continuous parameters and {it:#}/n_p for discrete parameters,
where n_p is the number of parameters in the block.  The default is
{cmd:scale(2.38)}.

{phang}
{opt covariance(cov)} specifies a scale matrix {it:cov} to be used to
compute an initial proposal covariance matrix.  The initial proposal
covariance is computed as rho x Sigma, where rho is a scale factor
and Sigma = {it:matname}.  By default, Sigma is the identity matrix.
Partial specification of Sigma is also allowed.  The rows and columns of
{it:cov} should be named after some or all model parameters.  According to
some theoretical results, the optimal proposal covariance is the posterior
covariance matrix of model parameters, which is usually unknown.  This option
does not apply to the blocks containing random-effects parameters.

{dlgtab:Reporting}

INCLUDE help bayesmh_credintoptsdes

{phang}
  {cmd:eform} and {opt eform(string)} specify that the coefficient table
  be displayed in exponentiated form and that {cmd:exp(b)} and {it:string},
  respectively, be used to label the exponentiated coefficients in the table.

INCLUDE help bayesmh_batchoptdes

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} saves simulation
results in {it:filename}{cmd:.dta}.  The {cmd:replace} option specifies to
overwrite {it:filename}{cmd:.dta} if it exists. If the {opt saving()} option
is not specified, {cmd:bayesmh} saves simulation results in a temporary file
for later access by postestimation commands.  This temporary file will be
overridden every time {cmd:bayesmh} is run and will also be erased if the
current estimation results are cleared. {cmd:saving()} may be specified during
estimation or on replay.

{pmore}
The saved dataset has the following structure.  Variable {cmd:_chain}
records chain identifiers.  Variable {cmd:_index} records
iteration numbers.  {cmd:bayesmh} saves only states (sets of parameter values)
that are different from one iteration to another and the frequency of each
state in variable {cmd:_frequency}. (Some states may be repeated for discrete parameters.) As such, {cmd:_index} may not
necessarily contain consecutive integers. Remember to use {cmd:_frequency} as
a frequency weight if you need to obtain any summaries of this dataset.
Values for each parameter are saved in a separate variable in the dataset.
Variables containing values of parameters without equation names are named as
{cmd:eq0_p}{it:#}, following the order in which parameters are declared in
{cmd:bayesmh}.  Variables containing values of parameters with equation names
are named as {cmd:eq}{it:#}{cmd:_p}{it:#}, again following the order in which
parameters are defined.  Parameters with the same equation names will have the
same variable prefix {cmd:eq}{it:#}.  For example,

{phang3}
  {cmd:. bayesmh y x1, likelihood(normal({c -(}var{c )-})) saving(mcmc)} ...

{pmore}
will create a dataset, {cmd:mcmc.dta}, with variable names {cmd:eq1_p1} for
{cmd:{c -(}y:x1{c )-}}, {cmd:eq1_p2} for {cmd:{c -(}y:_cons{c )-}}, and
{cmd:eq0_p1} for {cmd:{c -(}var{c )-}}.
Also see macros {cmd:e(parnames)} and {cmd:e(varnames)} for the correspondence
between parameter names and variable names.

{pmore}
In addition, {cmd:bayesmh} saves variable {cmd:_loglikelihood} to contain
values of the log likelihood from each iteration and variable
{cmd:_logposterior} to contain values of the log posterior from each
iteration.

{phang}
{opt nomodelsummary} suppresses the detailed summary of the specified model.
The model summary is reported by default.

{phang}
{opt noexpression} suppresses the output of expressions from the model
summary.  Expressions (when specified) are reported by default.

INCLUDE help bayesmh_chainsdetailoptsdes

{phang}
{opt nodots}, {opt dots}, and {opt dots(#)} specify to suppress or display
dots during simulation.  With multiple chains, these options affect all
chains.  {opt dots(#)} displays a dot every {it:#} iterations.  During the
adaptation period, a symbol {cmd:a} is displayed instead of a dot.  If
{cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot or
{cmd:a}.  {cmd:dots(, every(}{it:#}{cmd:))} is equivalent to
{cmd:dots(1, every(}{it:#}{cmd:))}.  {cmd:dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100, every(1000))}.  By default, no dots are displayed
({cmd:nodots} or {cmd:dots(0)}).

{marker noshow()}{...}
{phang}
{opth show:(bayesmh##paramref:paramref)} or
{opth noshow:(bayesmh##paramref:paramref)}
specifies a list of model parameters to be included in the output or excluded
from the output, respectively.  By default, all model parameters (except
random-effects parameters when {cmd:reffects()} is specified) are displayed.
Do not confuse {cmd:noshow()} with {cmd:exclude()}, which excludes the
specified parameters from the MCMC sample.  When the {cmd:noshow()} option is
specified, for computational efficiency, MCMC summaries of the specified
parameters are not computed or stored in {cmd:e()}.  {it:paramref} can include
individual random-effects parameters.

{phang}
{opt showreffects} and
{opth showreffects:(bayesian_postestimation##bayesian_post_reref:reref)}
are used with option {cmd:reffects()} and specify that all or a list {it:reref}
of random-effects parameters be included in the output in addition to other
model parameters.  By default, all random-effects parameters introduced by
{cmd:reffects()} are excluded from the output as if you have specified the
{opt noshow()} option.  This option computes, displays, and stores in
{opt e()} MCMC summaries for the random-effects parameters.

{phang}
{opt notable} suppresses the estimation table from the output.  By default, a
summary table is displayed containing all model parameters except those listed
in the {opt exclude()} and {opt noshow()} options.  Regression model
parameters are grouped by equation names.  The table includes six columns and
reports the following statistics using the MCMC simulation results:
posterior mean, posterior standard deviation, MCMC standard error or
MCSE, posterior median, and credible intervals.

{phang}
{opt noheader} suppresses the output header either at estimation or upon
replay.

{phang}
{opt title(string)} specifies an optional title for the command that is
displayed above the table of the parameter estimates.  The default title is
specific to the specified likelihood model.

INCLUDE help bayesmh_displayoptsdes

{dlgtab:Advanced}

INCLUDE help bayesmh_advancedoptsdes


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help bayesmh##usingbayesmh:Using bayesmh}
        {help bayesmh##declare:Declaring model parameters}
        {help bayesmh##refer:Referring to model parameters}
        {help bayesmh##subexp:Substitutable expressions}


{marker usingbayesmh}{...}
{title:Using bayesmh}

{pstd}
The {cmd:bayesmh} command for Bayesian analysis includes three functional
components: setting up a posterior model, performing MCMC simulation, and
summarizing and reporting results.  The first component, the model-building
step, requires some experience in the practice of Bayesian statistics and, as
any modeling task, is probably the most demanding.  You should specify a
posterior model that is statistically correct and that represents the observed
data.  Another important aspect is the computational feasibility of the model
in the context of the MH MCMC procedure implemented in {cmd:bayesmh}.
The provided MH algorithm is adaptive and, to a degree, can accommodate
various statistical models and data structures.  However, careful model
parametrization and well-specified initial values and MCMC sampling scheme
are crucial for achieving a fast-converging Markov chain and consequently good
results.  Simulation of MCMC must be followed by a thorough investigation
of the convergence of the MCMC algorithm.  Once you are satisfied with the
convergence of the simulated chains, you may proceed with posterior summaries
of the results and their interpretation.  Below we discuss the three major
steps of using {cmd:bayesmh} and provide recommendations.


{marker declare}{...}
{title:Declaring model parameters}

{pstd}
Model parameters are typically declared, meaning first introduced, in the
arguments of distributions specified in options {cmd:likelihood()} and
{cmd:prior()}.  We will refer to model parameters that are declared in the
prior distributions (and not the likelihood distributions) as hyperparameters.
Model parameters may also be declared within the parameter specification of
the {cmd:prior()} option, but this is more rare.

{pstd}
{cmd:bayesmh} distinguishes between two types of model parameters: scalar and
matrix.  All parameters must be specified in curly braces,
{cmd:{c -(} {c )-}}.  There are two ways for declaring a scalar parameter:
{cmd:{it:param}} and {cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:{c )-}},
where {it:param} and {it:eqname} are valid Stata names. 

{pstd}
The specification of a matrix parameter is similar, but you must use the
{cmd:matrix} suboptions:  {cmd:{c -(}}{it:param}{cmd:,}
{opt m:atrix}{cmd:{c )-}} and {cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:,}
{opt m:atrix}{cmd:{c )-}}.  The most common application of matrix model
parameters is for specifying the variance-covariance matrix of a
multivariate normal distribution.

{pstd}
All matrices are assumed to be symmetric and only the elements in the lower
diagonal are reported in the output.  Only a few multivariate prior
distributions are available for matrix parameters: {cmd:wishart()},
{cmd:iwishart()}, and {cmd:jeffreys()}.  In addition to being symmetric, these
distributions require that the matrices be positive definite.

{pstd}
It is your responsibility to declare all parameters of your model, except
regression coefficients in linear models.  For a linear model, {cmd:bayesmh}
automatically creates a regression coefficient with the name
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvar}{cmd:{c )-}} for each independent
variable {it:indepvar} in the model and, if {cmd:noconstant} is not
specified, an intercept parameter {cmd:{c -(}}{it:depvar}{cmd:{c )-}}. In the
presence of factor variables, {cmd:bayesmh} will create a parameter
{cmd:{c -(}}{it:depvar}{cmd::}{it:level}{cmd:{c )-}} for each level indicator
{it:level} and a parameter
{cmd:{c -(}}{it:depvar}{cmd::}{it:inter}{cmd:{c )-}} for each interaction
indicator {it:inter}; see {help fvvarlists}. (It is still your responsibility,
however, to specify prior distributions for the regression parameters.)

{pstd}
For example, 

{phang3}{cmd:. bayesmh y x,} ...

{pstd}
will automatically have two regression parameters: {cmd:{y:x}} and {cmd:{y}},
whereas

{phang3}{cmd:. bayesmh y x, noconstant} ...

{pstd}
will have only one: {cmd:{y:x}}.

{pstd}
For a univariate normal linear regression, we may want to additionally declare
the scalar variance parameter by

{phang3}{cmd:. bayesmh y x, likelihood(normal({sig2}))} ...

{pstd}
We can label the variance parameter, as follows:

{phang3}{cmd:. bayesmh y x, likelihood(normal({c -(}var:sig2{c )-}))} ...

{pstd}
We can declare a hyperparameter for {cmd:{sig2}} using

{phang3}
{cmd:. bayesmh y x, likelihood(normal({sig2})) prior({sig2}, igamma({df},2))}
...

{pstd}
where the hyperparameter {cmd:{df}} is declared in the inverse-gamma prior
distribution for {cmd:{sig2}}.

{pstd}
For a multivariate normal linear regression, in addition to four regression
parameters declared automatically by {cmd:bayesmh}: {cmd:{y1:x}},
{cmd:{y1}}, {cmd:{y2:x}}, and {cmd:{y2}}, we may also declare a parameter for
the variance-covariance matrix:

{phang3}
{cmd:. bayesmh y1 y2 = x, likelihood(mvnormal({Sigma, matrix}))} ...

{pstd}
or abbreviate {cmd:matrix} to {cmd:m} for short:

{phang3}
{cmd:. bayesmh y1 y2 = x, likelihood(mvnormal({Sigma, m}))} ...


{marker refer}{...}
{title:Referring to model parameters}

{pstd}
After a model parameter is declared, we may need to refer to it in our further
model specification.  We will definitely need to refer to it when we specify
its prior distribution.  We may also need to use it as an argument in the
prior distributions of other parameters or need to specify it in the
{cmd:block()} option for blocking of model parameters; see
{mansection BAYES bayesmhRemarksandexamplesImprovingefficiencyoftheMHalgorithm---blockingofparameters:{it:Improving efficiency of the MH algorithm---blocking of parameters}}
in {bf:[BAYES] bayesmh}.

{pstd}
To refer to one parameter, we simply use its definition:
{cmd:{c -(}}{it:param}{cmd:{c )-}},
{cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:{c )-}},
{cmd:{c -(}}{it:param}{cmd:,} {opt m:atrix}{cmd:{c )-}}, or
{cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:,} {opt m:atrix}{cmd:{c )-}}.
There are several ways in which you can refer to multiple parameters.  You can
refer to multiple model parameters in the parameter specification
{it:paramref} of the {opt prior(paramref, ...)} option, of the
{opt block(paramref, ...)} option, or of the
{opt initial(paramref #)} option.

{pstd}
The most straightforward way to refer to multiple scalar model parameters is
to simply list them individually, as follows:

{phang3}{cmd:{param1} {param2}} ...

{pstd}
but there are shortcuts.

{pstd}
For example, the alternative to the above is

{phang3}{cmd:{param1 param2}} ...

{pstd}
where we simply list the names of all parameters inside one set of curly
braces.

{pstd}
If parameters have the same equation name, you can refer to all of the
parameters with that equation name as follows.  Suppose that we have three
parameters with the same equation name {cmd:eqname}, then the specification

{phang3}{cmd:{eqname:param1} {eqname:param2} {eqname:param3}}

{pstd}
is the same as the specification

{phang3}{cmd:{eqname:}}

{pstd}
or the specification

{phang3}{cmd:{eqname:param1 param2 param3}}

{pstd}
The above specification is useful if we want to refer to a subset of
parameters with the same equation name. For example, in the above, if we
wanted to refer to only {cmd:param1} and {cmd:param2}, we could type

{phang3}{cmd:{eqname:param1 param2}}

{pstd}
If a factor variable is used in the specification of the regression
function, you can use the same factor-variable specification within
{it:paramref} to refer to the coefficients associated with the levels of that
factor variable; see {help fvvarlists}.

{pstd}
For example, factor variables are useful for constructing multilevel Bayesian
models.  Suppose that variable {cmd:id} defines the second level of
hierarchy in a two-level random-effects model.  We can fit a Bayesian
random-intercept model as follows.

{phang3}
{cmd:. bayesmh y x i.id, likelihood(normal({c -(}var{c )-}))}
       {cmd:prior({y:i.id}, normal(0,{tau}))} ...

{pstd}
Here we used {cmd:{y:i.id}} in the prior specification to refer to all levels
of {cmd:id}.

{pstd}
Similarly, we can add a random coefficient for a continuous covariate {cmd:x}
by typing

{phang3}
{cmd:. bayesmh y c.x##i.id, likelihood(normal({c -(}var{c )-}))}
          {cmd:prior({y:i.id}, normal(0,{tau1}))}
	  {cmd:prior({y:c.x#i.id}, normal(0,{tau2}))} ...

{pstd}
You can mix and match all of the specifications above in one parameter
specification, {it:paramref}.

{pstd}
To refer to multiple matrix model parameters, you can use
{cmd:{c -(}}{it:paramlist}{cmd:,} {opt m:atrix}{cmd:{c )-}} to refer to matrix
parameters with names {it:paramlist} and
{cmd:{c -(}}{it:eqname}{cmd::}{it:paramlist}{cmd:,} {opt m:atrix}{cmd:{c )-}}
to refer to matrix parameters with names in {it:paramlist} and with equation
name {it:eqname}.

{pstd}
For example, the specification

{phang3}
{cmd:{eqname:Sigma1,m}} {cmd:{eqname:Sigma2,m}} {cmd:{Sigma3,m}}
     {cmd:{Sigma4,m}}

{pstd}
is the same as the specification

{phang3}
{cmd:{eqname:Sigma1 Sigma2,m}} {cmd:{Sigma3 Sigma4,m}}

{pstd}
You cannot refer to both scalar and matrix parameters in one {it:paramref}
specification.

{pstd}
For referring to model parameters in postestimation commands, see
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingmodelparameters:{it:Different ways of specifying model parameters}}
in {bf:[BAYES] Bayesian postestimation}.


{marker subexp}{...}
{title:Substitutable expressions}

{pstd}
You may use substitutable expressions in {cmd:bayesmh} to define nonlinear
expressions {it:subexpr}, arguments of outcome distributions in option
{cmd:likelihood()}, observation-level log likelihood in option {cmd:llf()},
arguments of prior distributions in option {cmd:prior()}, and generic prior
distributions in {cmd:prior()}'s suboptions {cmd:density()} and
{cmd:logdensity()}.  Substitutable expressions are just like any other
mathematical expression in Stata, except that they may include model
parameters.

{pstd}
To specify a substitutable expression in your {cmd:bayesmh} model, you must
comply with the following rules:

{p 4 7 2}
1. Model parameters are bound in braces: {cmd:{mu}},
         {cmd:{c -(}var:sigma2{c )-}}, {cmd:{Sigma, matrix}}, and
         {cmd:{Cov:Sigma, matrix}}.

{p 4 7 2}
2. Linear combinations can be specified using the notation

{phang3}{cmd:{c -(}}{it:eqname}{cmd::}{it:varlist}[{cmd:,} {cmd:xb} {cmdab:nocons:tant}]{cmd:{c )-}}
	 
{p 7 7 2}For example, {cmd:{c -(}}{cmd:lc:mpg price weight{c )-}} is
equivalent to 

{phang3}{cmd:{c -(}lc:mpg{c )-}*mpg} {cmd:+} {cmd:{c -(}lc:price{c )-}*price}
             {cmd:+} {cmd:{c -(}lc:weight{c )-}*weight} {cmd:+}
	     {cmd:{c -(}mpg:_cons{c )-}}

{p 7 7 2}
The {opt xb} option is used to distinguish between the linear combination that
contains one variable and a free parameter that has the same name as the
variable and the same group name as the linear combination. For example,
{cmd:{c -(}lc:weight, xb{c )-}} is equivalent to {cmd:{c -(}lc:_cons{c )-}}
{cmd:+} {cmd:{c -(}lc:weight{c )-}}{cmd:*weight}, whereas
{cmd:{c -(}lc:weight{c )-}} refers to either a free parameter {cmd:weight}
with a group name {cmd:lc} or the coefficient of the {cmd:weight} variable, if
{cmd:{c -(}lc:{c )-}} has been previously defined in the expression as a
linear combination that involves variable {cmd:weight}.  Thus the {cmd:xb}
option indicates that the specification is a linear combination rather than a
single parameter to be estimated.

{p 7 7 2}
When you define a linear combination, a constant term is included by default.
The {cmd:noconstant} option suppresses the constant.

{p 7 7 2}
See {mansection ME menlRemarksandexamplesLinearcombinations:{it:Linear combinations}}
in {bf:[ME] menl} for details about specifying linear combinations.

{p 4 7 2}
3. Initial values are given by including an equal sign and the initial
         value inside the braces, for example, {cmd:{b1=1.267}},
	 {cmd:{gamma=3}}, etc.  If you do not specify an initial value, that
	 parameter is initialized to one for positive scalar parameters and to
	 zero for other scalar parameters, or it is initialized to its MLE,
	 if available.  The {cmd:initial()} option overrides initial values
	 provided in substitutable expressions.  Initial values for matrices
	 must be specified in the {cmd:initial()} option. By default, matrix
	 parameters are initialized with identity matrices.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
	
{pstd}Bayesian normal linear regression with noninformative priors{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}{p_end}

{pstd}Bayesian normal linear regression with normal and inverse-gamma
priors{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, normal(0, {c -(}var{c )-}))}
        {cmd:prior({c -(}var{c )-}, igamma(2.5, 2.5))}{p_end}
		
{pstd}Bayesian normal linear regression with multivariate Zellner’s
g-prior{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, zellnersg0(3,12,{c -(}var{c )-}))}
        {cmd:prior({c -(}var{c )-}, igamma(0.5, 4))}{p_end}
		
{pstd}Update parameter {cmd:{c -(}var{c )-}} separately from other model
coefficients{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, zellnersg0(3,12,{c -(}var{c )-}))}
        {cmd:prior({c -(}var{c )-}, igamma(0.5, 4))}
        {cmd:block({c -(}var{c )-})}{p_end}

{pstd}Use Gibbs sampling for parameter {cmd:{c -(}var{c )-}} and display the summary
about blocks{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, normal(0, 100))}
        {cmd:prior({c -(}var{c )-}, igamma(0.5, 4))}
        {cmd:block({c -(}var{c )-}, gibbs) blocksummary}{p_end}

{pstd}Bayesian logistic regression model with a noninformative prior{p_end}
{phang2}{cmd:. webuse hearthungary	}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh disease restecg isfbs age male, likelihood(logit)}
	{cmd:prior({disease:}, normal(0,1000))}

{pstd}Bayesian ordered probit model including hyperparameter
{cmd:{lambda}}{p_end}
{phang2}{cmd:. webuse fullauto}{p_end}
{phang2}{cmd:. replace length = length/10}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh rep77 foreign length mpg, likelihood(oprobit)}
	{cmd:prior({rep77: foreign length mpg}, normal(0,1))}
	{cmd:prior({rep77:_cut1 _cut2 _cut3 _cut4}, exponential({lambda=30}))}
	{cmd:prior({lambda}, uniform(10,40))}
	{cmd:block(lambda)}{p_end}
		
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. replace weight = weight/1000}{p_end}
{phang2}{cmd:. replace length = length/100}{p_end}
{phang2}{cmd:. replace mpg = mpg/10}{p_end}

{pstd}Bayesian multivariate normal model including matrix parameter {cmd:{Sigma}} 
for the covariance matrix{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh (mpg) (weight) (length), likelihood(mvnormal({Sigma,m}))}
	{cmd:	prior({mpg:_cons} {weight:_cons} {length:_cons}, normal(0,100))}
	{cmd:	prior({Sigma,m}, iwishart(3,100,I(3)))}
	{cmd:	block({mpg:_cons} {weight:_cons} {length:_cons})}
	{cmd:	block({Sigma,m}) dots}{p_end}

{pstd}Request additional burn-in and more frequent adaptation{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh (mpg) (weight) (length), likelihood(mvnormal({Sigma,m}))}
	{cmd:prior({mpg:_cons} {weight:_cons} {length:_cons}, normal(0,100))}
	{cmd:prior({Sigma,m}, iwishart(3,100,I(3)))}
	{cmd:block({mpg:_cons} {weight:_cons} {length:_cons})}
	{cmd:block({Sigma,m}) dots}
	{cmd:burnin(5000) adaptation(every(50))}{p_end}

{pstd}Request Gibbs sampling for covariance matrix {cmd:{Sigma}}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh (mpg) (weight) (length), likelihood(mvnormal({Sigma,m}))}
	{cmd:prior({mpg:_cons} {weight:_cons} {length:_cons}, normal(0,100))}
	{cmd:prior({Sigma,m}, iwishart(3,100,I(3)))}
	{cmd:block({mpg:_cons} {weight:_cons} {length:_cons})}
	{cmd:block({Sigma,m}, gibbs) dots}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig, clear}{p_end}

{pstd}Bayesian linear random-intercept model{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. fvset base none id}{p_end}
{phang2}{cmd:. bayesmh weight week i.id, likelihood(normal({c -(}var_0{c )-})) noconstant}
	{cmd:prior({weight:i.id}, normal({weight:_cons},{c -(}var_id{c )-}))}
	{cmd:prior({weight:_cons}, normal(0, 100))}
	{cmd:prior({weight:week}, normal(0, 100))}
	{cmd:prior({c -(}var_0{c )-}, igamma(0.001, 0.001))}
	{cmd:prior({c -(}var_id{c )-}, igamma(0.001, 0.001))}
	{cmd:mcmcsize(5000) dots}{p_end}

{pstd}Bayesian linear random-intercept model using the {cmd:reffects()} option{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh weight week, reffects(id) likelihood(normal({c -(}var_0{c )-})) noconstant}
	{cmd:prior({weight:i.id}, normal({weight:_cons},{c -(}var_id{c )-}))}
	{cmd:prior({weight:_cons}, normal(0, 100))}
	{cmd:prior({weight:week}, normal(0, 100))}
	{cmd:prior({c -(}var_0{c )-}, igamma(0.001, 0.001))}
	{cmd:prior({c -(}var_id{c )-}, igamma(0.001, 0.001))}
	{cmd:mcmcsize(5000) dots}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse coal}{p_end}

{pstd}Analysis of a change point problem with target MCMC sample size of
20,000{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh count,}
	{cmd:likelihood(dpoisson({mu1}*sign(year<{cp})+{mu2}*sign(year>={cp})))}
	{cmd:prior({mu1} {mu2}, flat)}
	{cmd:prior({cp}, uniform(1851,1962))}
	{cmd:initial({mu1} 1 {mu2} 1 {cp} 1906)}
	{cmd:mcmcsize(20000)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}

{pstd}Bayesian normal linear regression using three chains{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, normal(0, 100))} 
        {cmd:prior({c -(}var{c )-}, igamma(1, 100)) nchains(3) rseed(16)}{p_end}

    {hline}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://youtu.be/0F0QoMCSKJ4":Introduction to Bayesian statistics, part 1: The basic concepts}

{phang}
{browse "https://youtu.be/OTO1DygELpY":Introduction to Bayesian statistics, part 2: MCMC and the Metropolis-Hastings algorithm}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesmh} stores the following in {cmd:e()}:

{synoptset 21 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_sc)}}number of scalar parameters{p_end}
{synopt:{cmd:e(k_mat)}}number of matrix parameters{p_end}
{synopt:{cmd:e(n_eq)}}number of equations{p_end}
{synopt:{cmd:e(nchains)}}number of MCMC chains{p_end}
{synopt:{cmd:e(mcmcsize)}}MCMC sample size{p_end}
{synopt:{cmd:e(burnin)}}number of burn-in iterations{p_end}
{synopt:{cmd:e(mcmciter)}}total number of MCMC iterations{p_end}
{synopt:{cmd:e(thinning)}}thinning interval{p_end}
{synopt:{cmd:e(arate)}}overall AR{p_end}
{synopt:{cmd:e(eff_min)}}minimum efficiency{p_end}
{synopt:{cmd:e(eff_avg)}}average efficiency{p_end}
{synopt:{cmd:e(eff_max)}}maximum efficiency{p_end}
{synopt:{cmd:e(Rc_max)}}maximum Gelman-Rubin convergence statistic (only with
{cmd:nchains()}){p_end}
{synopt:{cmd:e(clevel)}}credible interval level{p_end}
{synopt:{cmd:e(hpd)}}{cmd:1} if {cmd:hpd} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(batch)}}batch length for batch-means calculations{p_end}
{synopt:{cmd:e(corrlag)}}maximum autocorrelation lag{p_end}
{synopt:{cmd:e(corrtol)}}autocorrelation tolerance{p_end}
{synopt:{cmd:e(dic)}}deviance information criterion{p_end}
{synopt:{cmd:e(lml_lm)}}log marginal-likelihood using Laplace-Metropolis method{p_end}
{synopt:{cmd:e(scale)}}initial multiplier for scale factor; {cmd:scale()}{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_gibbs)}}{cmd:1} if Gibbs sampling is used in {it:#}th block, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_reffects)}}{cmd:1} if the parameters in {it:#}th block are random effects, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_scale)}}{it:#}th block initial multiplier for scale factor{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_tarate)}}{it:#}th block target adaptation rate{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_tolerance)}}{it:#}th block adaptation tolerance{p_end}
{synopt:{cmd:e(adapt_every)}}adaptation iterations {cmd:adaptation(every())}{p_end}
{synopt:{cmd:e(adapt_maxiter)}}maximum number of adaptive iterations {cmd:adaptation(maxiter())}{p_end}
{synopt:{cmd:e(adapt_miniter)}}minimum number of adaptive iterations {cmd:adaptation(miniter())}{p_end}
{synopt:{cmd:e(adapt_alpha)}}adaptation parameter {cmd:adaptation(alpha())}{p_end}
{synopt:{cmd:e(adapt_beta)}}adaptation parameter {cmd:adaptation(beta())}{p_end}
{synopt:{cmd:e(adapt_gamma)}}adaptation parameter {cmd:adaptation(gamma())}{p_end}
{synopt:{cmd:e(adapt_tolerance)}}adaptation tolerance {cmd:adaptation(tolerance())}{p_end}
{synopt:{cmd:e(repeat)}}number of attempts used to find feasible initial values{p_end}

{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:bayesmh}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}sampling method{p_end}
{synopt:{cmd:e(depvars)}}names of dependent variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(likelihood)}}likelihood distribution (one equation){p_end}
{synopt:{cmd:e(likelihood}{it:#}{cmd:)}}likelihood distribution for #th equation{p_end}
{synopt:{cmd:e(prior)}}prior distribution{p_end}
{synopt:{cmd:e(prior}{it:#}{cmd:)}}prior distribution, if more than one {cmd:prior()} is specified{p_end}
{synopt:{cmd:e(priorparams)}}parameter specification in {cmd:prior()}{p_end}
{synopt:{cmd:e(priorparams}{it:#}{cmd:)}}parameter specification from #th {cmd:prior()}, if more than one {cmd:prior()} is specified{p_end}
{synopt:{cmd:e(parnames)}}names of model parameters except {cmd:exclude()}{p_end}
{synopt:{cmd:e(postvars)}}variable names corresponding to model parameters in {cmd:e(parnames)} {p_end}
{synopt:{cmd:e(subexpr)}}substitutable expression{p_end}
{synopt:{cmd:e(subexpr}{it:#}{cmd:)}}substitutable expression, if more than one{p_end}
{synopt:{cmd:e(wtype)}}weight type (one equation){p_end}
{synopt:{cmd:e(wtype}{it:#}{cmd:)}}weight type for #th equation{p_end}
{synopt:{cmd:e(wexp)}}weight expression (one equation){p_end}
{synopt:{cmd:e(wexp}{it:#}{cmd:)}}weight expression for #th equation{p_end}
{synopt:{cmd:e(block}{it:#}{cmd:_names)}}parameter names from #th block{p_end}
{synopt:{cmd:e(exclude)}}names of excluded parameters{p_end}
{synopt:{cmd:e(filename)}}name of the file with simulation results{p_end}
{synopt:{cmd:e(scparams)}}scalar model parameters{p_end}
{synopt:{cmd:e(matparams)}}matrix model parameters{p_end}
{synopt:{cmd:e(pareqmap)}}model parameters in display order{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(rngstate)}}random-number state at the time of simulation (only
with single chain){p_end}
{synopt:{cmd:e(rngstate}{it:#}{cmd:)}}random-number state for {it:#}th chain (only
with {cmd:nchains()}){p_end}
{synopt:{cmd:e(search)}}{cmd:on}, {cmd:repeat()}, or {cmd:off}{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:e(mean)}}posterior means{p_end}
{synopt:{cmd:e(sd)}}posterior standard deviations{p_end}
{synopt:{cmd:e(mcse)}}MCSE{p_end}
{synopt:{cmd:e(median)}}posterior medians{p_end}
{synopt:{cmd:e(cri)}}credible intervals{p_end}
{synopt:{cmd:e(Cov)}}variance-covariance matrix of parameters{p_end}
{synopt:{cmd:e(ess)}}effective sample sizes{p_end}
{synopt:{cmd:e(init)}}initial values vector{p_end}
{synopt:{cmd:e(dic_chains)}}deviance information criterion for each chain
(only with {cmd:nchains()}){p_end}
{synopt:{cmd:e(arate_chains)}}acceptance rate for each chain (only with
{cmd:nchains()}){p_end}
{synopt:{cmd:e(eff_min_chains)}}minimum efficiency for each chain (only with
{cmd:nchains()}){p_end}
{synopt:{cmd:e(eff_avg_chains)}}average efficiency for each chain (only with
{cmd:nchains()}){p_end}
{synopt:{cmd:e(eff_max_chains)}}maximum efficiency for each chain (only with
{cmd:nchains()}){p_end}
{synopt:{cmd:e(lml_lm_chains)}}log marginal-likelihood for each chain (only
with {cmd:nchains()}){p_end}

{p2col 5 15 17 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}mark estimation sample{p_end}
{p2colreset}{...}
