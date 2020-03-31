{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: probit" "dialog bayes_probit"}{...}
{vieweralsosee "[BAYES] bayes: probit" "mansection BAYES bayesprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_probit##syntax"}{...}
{viewerjumpto "Menu" "bayes_probit##menu"}{...}
{viewerjumpto "Description" "bayes_probit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_probit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_probit##examples"}{...}
{viewerjumpto "Stored results" "bayes_probit##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: probit} {hline 2}}Bayesian probit regression{p_end}
{p2col:}({mansection BAYES bayesprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt prob:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_probit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}

{syntab:Reporting}
{synopt :{it:{help probit##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:probit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:probit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help probit##options:{it:Options}} in {manhelp probit R}.{p_end}

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
{bf:Statistics > Binary outcomes > Bayesian regression > Probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: probit} fits a Bayesian probit regression to a binary 
outcome;
see {manhelp bayes BAYES} and {manhelp probit R:probit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesprobitQuickstart:Quick start}

        {mansection BAYES bayesprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples:  Probit regression}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}
Fit Bayesian probit regression using default priors{p_end}
{phang2}{cmd:. bayes: probit low age lwt i.race}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): probit low age lwt i.race}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:probit low age lwt i.race}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:probit low age lwt i.race}

{pstd}
Fit Bayesian probit regression using uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:age lwt i.race _cons}, uniform(-10,10)): probit low age lwt i.race}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:}, uniform(-10,10)): probit low age lwt i.race}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{title:Examples:  Handling perfect prediction}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse heartswitz}

{pstd}
Fit Bayesian probit regression using default noninformative priors{p_end}
{phang2}{cmd:. bayes: probit disease restecg isfbs age male}

{pstd}
Same as above, but specify option {cmd:noisily} to display the output of the {cmd:probit} command{p_end}
{phang2}{cmd:. bayes, noisily: probit disease restecg isfbs age male}

{pstd}
Specifying informative priors based on a similar study to resolve a problem of
perfect prediction; specify {cmd:probit}'s {cmd:asis} option to prevent
{cmd:probit} from dropping the perfect predictors from the model, and specify
{cmd:bayes}'s {cmd:nomleinitial} option to prevent {cmd:bayes} from trying to
obtain ML estimates as starting values; specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, prior({disease:restecg age}, normal(0,10))}{p_end}
            {cmd:prior({disease:isfbs male}, normal(1,10))}
	    {cmd:prior({disease:_cons}, normal(-4,10)) nomleinitial rseed(123):}
	    {cmd:probit disease restecg isfbs age male, asis}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
