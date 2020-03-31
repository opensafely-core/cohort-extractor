{smcl}
{* *! version 1.0.8  12doc2018}{...}
{viewerdialog "bayes: zioprobit" "dialog bayes_zioprobit"}{...}
{vieweralsosee "[BAYES] bayes: zioprobit" "mansection BAYES bayeszioprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] zioprobit" "help zioprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_zioprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_zioprobit##menu"}{...}
{viewerjumpto "Description" "bayes_zioprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_zioprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_zioprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_zioprobit##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[BAYES] bayes: zioprobit} {hline 2}}Bayesian zero-inflated
ordered probit regression{p_end}
{p2col:}({mansection BAYES bayeszioprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt zioprobit}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_zioprobit##weight:weight}}]{cmd:,}
{opt inf:late}{cmd:(}{varlist}[{cmd:,} {opt nocons:tant} {opth off:set(varname)}]|{cmd:_cons)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt inf:late()}}equation that determines excess zero values{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help zioprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt inf:late}{cmd:(}{it:varlist}[{cmd:,} {opt nocons:tant} {opt off:set(varname)}]|{cmd:_cons)}
is required.{p_end}
INCLUDE help fvvarlist2
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:zioprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:zioprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help zioprobit##options:{it:Options}} in {manhelp zioprobit R}.{p_end}

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
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}
for the main regression and
{cmd:{c -(}inflate:}{it:varlist}{cmd:{c )-}}
for the inflation equation and cutpoints
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
{bf:Statistics > Ordinal outcomes > Bayesian regression > Zero-inflated ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: zioprobit} fits a Bayesian zero-inflated ordered probit regression
to an ordinal outcome with a high fraction of zeros;
see {manhelp bayes BAYES} and {manhelp zioprobit R:zioprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeszioprobitQuickstart:Quick start}

        {mansection BAYES bayeszioprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeszioprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse tobacco}{p_end}
{phang2}{cmd:. set seed 12345}{p_end}
{phang2}{cmd:. sample 1}{p_end}

{pstd}
Fit Bayesian zero-inflated ordered probit regression using default priors{p_end}
{phang2}{cmd:. bayes: zioprobit tobacco educ, inflate(educ parent)}

{pstd}
Check efficiencies of all model parameters{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}
Increase the burn-in period to 5,000 from the default of 2,500 and use 
informative normal prior, with zero mean and variance of 10, for 
cutpoints{p_end}
{phang2}{cmd:. bayes, burnin(5000) prior({cut1 cut2 cut3}, normal(0,10)): zioprobit tobacco educ, inflate(educ parent)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, burnin(5000) prior({cut1 cut2 cut3}, normal(0,10)) rseed(123): zioprobit tobacco educ, inflate(educ parent)}

{pstd}
Fit Bayesian ordered probit regression using uniform priors for the regression 
coefficients in the inflation equation and normal priors for cutpoints{p_end}
{phang2}{cmd:. bayes, prior({inflate:educ parent  _cons}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3}, normal(0,10)):}
            {cmd:zioprobit tobacco educ, inflate(educ parent)}

{pstd}
Same as above, but use a shortcut notation to refer to the regression 
coefficients in the inflation equation{p_end}
{phang2}{cmd:. bayes, prior({inflate:}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3}, normal(0,10)):}
            {cmd:zioprobit tobacco educ, inflate(educ parent)}

{pstd}
As above, but also use the same uniform prior for the regression coefficient
in the main equation{p_end}
{phang2}{cmd:. bayes, prior({inflate:}, uniform(-5,5))}{p_end}
            {cmd:prior({tobacco:}, uniform(-5,5))}
            {cmd:prior({cut1 cut2 cut3}, normal(0,10)):}
            {cmd:zioprobit tobacco educ, inflate(educ parent)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
