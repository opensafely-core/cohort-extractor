{smcl}
{* *! version 1.0.10  15jan2019}{...}
{viewerdialog "bayes: hetprobit" "dialog bayes_hetprobit"}{...}
{vieweralsosee "[BAYES] bayes: hetprobit" "mansection BAYES bayeshetprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] hetprobit" "help hetprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_hetprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_hetprobit##menu"}{...}
{viewerjumpto "Description" "bayes_hetprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_hetprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_hetprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_hetprobit##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[BAYES] bayes: hetprobit} {hline 2}}Bayesian heteroskedastic
probit regression{p_end}
{p2col:}({mansection BAYES bayeshetprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt hetprobit}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_hetprobit##weight:weight}}]{cmd:,}
{cmd:het(}{varlist} [{cmd:,} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {cmd:het(}{varlist}[...]{cmd:)}}independent variables to model the variance and possible offset variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}

{syntab:Reporting}
{synopt :{it:{help hetprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt het()} is required. The full specification is{break}
     {cmd:het(}{it:varlist} [{cmd:,} {opt off:set(varname_o)}]{cmd:)}.
{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{it:depvar}, {it:indepvars}, and {it:varlist} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:hetprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:hetprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help hetprobit##options:{it:Options}} in {manhelp hetprobit R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-variance coefficients; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}
for the main regression and
{cmd:{c -(}lnsigma:}{it:varlist}{cmd:{c )-}}
for the log-variance equation.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Bayesian regression > Heteroskedastic probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: hetprobit} fits a Bayesian heteroskedastic probit regression
to a binary outcome;
see {manhelp bayes BAYES} and {manhelp hetprobit R:hetprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeshetprobitQuickstart:Quick start}

        {mansection BAYES bayeshetprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeshetprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse hetprobxmpl}

{pstd}
Fit Bayesian heteroskedastic probit model using default priors and use
{cmd:xhet} to model the variance{p_end}
{phang2}{cmd:. bayes: hetprobit y x, het(xhet)}

{pstd}
Same as above, but increase the burn-in period to 5,000 from the default of
2,500 and display dots during simulation{p_end}
{phang2}{cmd:. bayes, burnin(5000) dots: hetprobit y x, het(xhet)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345) dots: hetprobit y x, het(xhet)}

{pstd}
Specify uniform priors for all regression coefficients in the main equation
{p_end}
{phang2}{cmd:. bayes, prior({y:x _cons}, uniform(-10,10)): hetprobit y x, het(xhet)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({y:}, uniform(-10,10)): hetprobit y x, het(xhet)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
