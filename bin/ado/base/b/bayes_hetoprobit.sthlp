{smcl}
{* *! version 1.0.0  13dec2018}{...}
{viewerdialog "bayes: hetoprobit" "dialog bayes_hetoprobit"}{...}
{vieweralsosee "[BAYES] bayes: hetoprobit" "mansection BAYES bayeshetoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] hetoprobit" "help hetoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_hetoprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_hetoprobit##menu"}{...}
{viewerjumpto "Description" "bayes_hetoprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_hetoprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_hetoprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_hetoprobit##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[BAYES] bayes: hetoprobit} {hline 2}}Bayesian heteroskedastic
ordered probit regression{p_end}
{p2col:}({mansection BAYES bayeshetoprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt hetoprobit}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_hetoprobit##weight:weight}}]{cmd:,}
{cmd:het(}{varlist} [{cmd:,} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {cmd:het(}{varlist}[...]{cmd:)}}independent variables to model the variance and possible offset variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help hetoprobit##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:hetoprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:hetoprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help hetoprobit##options:{it:Options}} in {manhelp hetoprobit R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-standard-deviation coefficients; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}
for the main regression and
{cmd:{c -(}lnsigma:}{it:varlist}{cmd:{c )-}}
for the log-standard-deviation equation and cutpoints
{cmd:{c -(}cut1{c )-}}, {cmd:{c -(}cut2{c )-}}, and so on.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}Flat priors, {cmd:flat}, are used by default for cutpoints.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Bayesian regression > Heteroskedastic ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: hetoprobit} fits a Bayesian heteroskedastic ordered probit
regression to an ordinal outcome;
see {manhelp bayes BAYES} and {manhelp hetoprobit R:hetoprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeshetoprobitQuickstart:Quick start}

        {mansection BAYES bayeshetoprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeshetoprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse fullauto}

{pstd}
Fit Bayesian heteroskedastic ordered probit model using default priors, using
{cmd:foreign} to model the variance, and setting a random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, rseed(12345): hetoprobit rep77 mpg foreign, het(foreign)}

{pstd}
Same as above, but increase the burn-in period to 4,000 from the default of
2,500 and display dots during simulation{p_end}
{phang2}{cmd:. bayes, burnin(4000) dots rseed(12345): hetoprobit rep77 mpg foreign, het(foreign)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(4000) dots rseed(12345): hetoprobit rep77 mpg foreign, het(foreign)}

{pstd}
Specify uniform priors for all regression coefficients in the main equation
{p_end}
{phang2}{cmd:. bayes, prior({rep77:mpg foreign}, uniform(-10,10)) burnin(4000) rseed(12345): hetoprobit rep77 mpg foreign, het(foreign)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({rep77:}, uniform(-10,10)) burnin(4000) rseed(12345): hetoprobit rep77 mpg foreign, het(foreign)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
