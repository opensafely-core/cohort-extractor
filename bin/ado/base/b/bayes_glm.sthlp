{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: glm" "dialog bayes_glm"}{...}
{vieweralsosee "[BAYES] bayes: glm" "mansection BAYES bayesglm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_glm##syntax"}{...}
{viewerjumpto "Menu" "bayes_glm##menu"}{...}
{viewerjumpto "Description" "bayes_glm##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_glm##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_glm##examples"}{...}
{viewerjumpto "Stored results" "bayes_glm##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[BAYES] bayes: glm} {hline 2}}Bayesian generalized linear
models{p_end}
{p2col:}({mansection BAYES bayesglm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt glm}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_glm##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth f:amily(glm##familyname:familyname)}}distribution of {depvar};
    default is {cmd:family(gaussian)}{p_end}
{synopt :{opth l:ink(glm##linkname:linkname)}}link function; default is
    canonical link for {opt family()} specified{p_end}

{syntab :Model 2}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opth mu(varname)}}use {it:varname} as the initial estimate for the
mean of {depvar}{p_end}
{synopt :{opth ini:t(varname)}}synonym for {opt mu(varname)}{p_end}

{syntab:Reporting}
{synopt :{opt ef:orm}}report exponentiated coefficients{p_end}
{synopt :{it:{help glm##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:glm,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:glm}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help glm##options:{it:Options}} in {manhelp glm R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Generalized linear models > Bayesian generalized linear models (GLM)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: glm} fits a Bayesian generalized linear model to
outcomes of different types such as continuous, binary, count, and so on;
see {manhelp bayes BAYES} and {manhelp glm R:glm} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesglmQuickstart:Quick start}

        {mansection BAYES bayesglmRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesglmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse beetle}

{pstd}
Fit Bayesian generalized linear model with a binomial family and a
complementary log-log link using default priors{p_end}
{phang2}{cmd:. bayes: glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Replay results and report exponentiated coefficients{p_end}
{phang2}{cmd:. bayes, eform}

{pstd}
Obtain highest posterior density intervals on replay{p_end}
{phang2}{cmd:. bayes, hpd}

{pstd}
Obtain highest posterior density intervals at estimation time{p_end}
{phang2}{cmd:. bayes, hpd: glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500 and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, burnin(5000) rseed(12345): glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Use uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({r:i.beetle _cons}, uniform(-10,10)): glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({r:}, uniform(-10,10)): glm r i.beetle, family(binomial n) link(cloglog)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
