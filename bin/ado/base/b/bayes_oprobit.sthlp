{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: oprobit" "dialog bayes_oprobit"}{...}
{vieweralsosee "[BAYES] bayes: oprobit" "mansection BAYES bayesoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_oprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_oprobit##menu"}{...}
{viewerjumpto "Description" "bayes_oprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_oprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_oprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_oprobit##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: oprobit} {hline 2}}Bayesian ordered probit regression{p_end}
{p2col:}({mansection BAYES bayesoprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt oprob:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_oprobit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help oprobit##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:oprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:oprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help oprobit##options:{it:Options}} in {manhelp oprobit R}.{p_end}

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
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} and cutpoints
{cmd:{c -(}cut1{c )-}},
{cmd:{c -(}cut2{c )-}}, and so on.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}Flat priors, {cmd:flat}, are used by default for cutpoints.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Bayesian regression > Ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: oprobit} fits a Bayesian ordered probit regression to
an ordinal outcome;
see {manhelp bayes BAYES} and {manhelp oprobit R:oprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesoprobitQuickstart:Quick start}

        {mansection BAYES bayesoprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesoprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse fullauto}

{pstd}
Fit Bayesian ordered probit regression using default priors{p_end}
{phang2}{cmd:. bayes: oprobit rep77 mpg foreign}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): oprobit rep77 mpg foreign}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:oprobit rep77 mpg foreign}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:oprobit rep77 mpg foreign}

{pstd}
Fit Bayesian ordered probit regression using uniform priors for all regression coefficients and normal priors for cutpoints{p_end}
{phang2}{cmd:. bayes, prior({rep77:mpg foreign}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3 cut4}, normal(0,10)):}
            {cmd:oprobit rep77 mpg foreign}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({rep77:}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3 cut4}, normal(0,10)):}
            {cmd:oprobit rep77 mpg foreign}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
