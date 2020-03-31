{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: tobit" "dialog bayes_tobit"}{...}
{vieweralsosee "[BAYES] bayes: tobit" "mansection BAYES bayestobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_tobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_tobit##menu"}{...}
{viewerjumpto "Description" "bayes_tobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_tobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_tobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_tobit##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[BAYES] bayes: tobit} {hline 2}}Bayesian tobit regression{p_end}
{p2col:}({mansection BAYES bayestobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt tob:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_tobit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt ll}[{cmd:(}{varname}|{it:#}{cmd:)}]}left-censoring limit{p_end}
{synopt :{opt ul}[{cmd:(}{varname}|{it:#}{cmd:)}]}right-censoring limit{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help tobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:tobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:tobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help tobit##options:{it:Options}} in {manhelp tobit R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
{p2coldent:* {opt igammapr:ior(# #)}}specify shape and scale of default inverse-gamma prior for variance; default is {cmd:igammaprior(0.01 0.01)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} and variance
{cmd:{c -(}sigma2{c )-}}.  Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Tobit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: tobit} fits a Bayesian tobit regression to a censored
continuous outcome;
see {manhelp bayes BAYES} and {manhelp tobit R:tobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayestobitQuickstart:Quick start}

        {mansection BAYES bayestobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayestobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate wgt = weight/1000}

{pstd}
Fit Bayesian tobit regression, specifying a right-censoring limit of 24{p_end}
{phang2}{cmd:. bayes: tobit mpg wgt, ul(24)}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500 and the MCMC sample size to 15,000 from the default 10,000{p_end}
{phang2}{cmd:. bayes, burnin(5000) mcmcsize(15000): tobit mpg wgt, ul(24)}

{pstd}
Use standard deviation of 10 instead of 100 of the default normal prior for 
regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10): tobit mpg wgt, ul(24)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) rseed(12345): tobit mpg wgt, ul(24)}

{pstd}
Fit Bayesian tobit regression using uniform priors for all regression 
coefficients{p_end}
{phang2}{cmd:. bayes, prior({mpg:wgt _cons}, uniform(-100,100)): tobit mpg wgt, ul(24)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients{p_end}
{phang2}{cmd:. bayes, prior({mpg:}, uniform(-100,100)): tobit mpg wgt, ul(24)}

{pstd}
Use different uniform priors for the intercept and the slope{p_end}
{phang2}{cmd:. bayes, prior({mpg:wgt}, uniform(-10,10)) prior({mpg:_cons}, uniform(-100,100)): tobit mpg wgt, ul(24)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
