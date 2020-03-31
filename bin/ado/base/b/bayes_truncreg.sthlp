{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: truncreg" "dialog bayes_truncreg"}{...}
{vieweralsosee "[BAYES] bayes: truncreg" "mansection BAYES bayestruncreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] truncreg" "help truncreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_truncreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_truncreg##menu"}{...}
{viewerjumpto "Description" "bayes_truncreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_truncreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_truncreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_truncreg##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[BAYES] bayes: truncreg} {hline 2}}Bayesian truncated regression{p_end}
{p2col:}({mansection BAYES bayestruncreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt truncreg}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_truncreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt:{cmd:ll(}{varname}|{it:#}{cmd:)}}left-truncation variable or limit
{p_end}
{synopt:{cmd:ul(}{varname}|{it:#}{cmd:)}}right-truncation variable or limit
{p_end}
{synopt:{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help truncreg##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:truncreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:truncreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help truncreg##options:{it:Options}} in {manhelp truncreg R}.{p_end}

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
{bf:Statistics > Linear models and related > Bayesian regression > Truncated regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: truncreg} fits a Bayesian truncated linear regression
to a continuous outcome;
see {manhelp bayes BAYES} and {manhelp truncreg R:truncreg} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayestruncregQuickstart:Quick start}

        {mansection BAYES bayestruncregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayestruncregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse laborsub}

{pstd}
Fit Bayesian truncated regression with truncation from below 0 using default 
priors{p_end}
{phang2}{cmd:. bayes: truncreg whrs kl6 k618 wa we, ll(0)}

{pstd}
Use standard deviation of 10,000 instead of 100 of the default normal prior 
for regression coefficients and increase the burn-in period to 5,000 from the 
default of 2,500{p_end}
{phang2}{cmd:. bayes, normalprior(10000) burnin(5000): truncreg whrs kl6 k618 wa we, ll(0)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345): truncreg whrs kl6 k618 wa we, ll(0)}

{pstd}
Display estimate of the error standard deviation as the square root of 
the error variance {cmd:{sigma2}}{p_end}
{phang2}{cmd:. bayesstats summary (sigma: sqrt({sigma2}))}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
