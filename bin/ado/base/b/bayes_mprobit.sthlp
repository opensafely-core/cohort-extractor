{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: mprobit" "dialog bayes_mprobit"}{...}
{vieweralsosee "[BAYES] bayes: mprobit" "mansection BAYES bayesmprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_mprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_mprobit##menu"}{...}
{viewerjumpto "Description" "bayes_mprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_mprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_mprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_mprobit##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: mprobit} {hline 2}}Bayesian multinomial probit regression{p_end}
{p2col:}({mansection BAYES bayesmprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt mprobit}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_mprobit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt base:outcome(#)}}value of {depvar} that will be the base outcome{p_end}
{synopt :{opt probit:param}}use the probit variance parameterization{p_end}

{syntab:Reporting}
{synopt :{it:{help mprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:mprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:mprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help mprobit##options:{it:Options}} in {manhelp mprobit R}.{p_end}

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
{cmd:{c -(}}{it:outcome1}{cmd::}{it:indepvars}{cmd:{c )-}},
{cmd:{c -(}}{it:outcome2}{cmd::}{it:indepvars}{cmd:{c )-}}, and so on,
where {it:outcome#}'s are the values of the dependent variable or the value
labels of the dependent variable if they exist.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Bayesian multinomial probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: mprobit} fits a Bayesian multinomial probit regression
to a categorical outcome;
see {manhelp bayes BAYES} and {manhelp mprobit R:mprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmprobitQuickstart:Quick start}

        {mansection BAYES bayesmprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}

{pstd}
Fit Bayesian multinomial probit regression using default priors and MCMC 
sample size of 2,500 instead of the default 10,000; display dots during 
simulation{p_end}
{phang2}{cmd:. bayes, dots mcmcsize(2500): mprobit insure age male nonwhite}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) mcmcsize(2500) rseed(12345) dots:}
          {cmd:mprobit insure age male nonwhite}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
