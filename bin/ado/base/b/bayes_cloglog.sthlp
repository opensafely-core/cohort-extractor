{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: cloglog" "dialog bayes_cloglog"}{...}
{vieweralsosee "[BAYES] bayes: cloglog" "mansection BAYES bayescloglog"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] cloglog" "help cloglog"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_cloglog##syntax"}{...}
{viewerjumpto "Menu" "bayes_cloglog##menu"}{...}
{viewerjumpto "Description" "bayes_cloglog##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_cloglog##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_cloglog##examples"}{...}
{viewerjumpto "Stored results" "bayes_cloglog##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: cloglog} {hline 2}}Bayesian complementary
log-log regression{p_end}
{p2col:}({mansection BAYES bayescloglog:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt cloglog}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_cloglog##weight:weight}}]
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
{synopt :{opt ef:orm}}report exponentiated coefficients{p_end}
{synopt :{it:{help cloglog##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:cloglog,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:cloglog}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help cloglog##options:{it:Options}} in {manhelp cloglog R}.{p_end}

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
{bf:Statistics > Binary outcomes > Bayesian regression > Complementary log-log regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: cloglog} fits a Bayesian complementary log-log regression
to a binary outcome;
see {manhelp bayes BAYES} and {manhelp cloglog R:cloglog} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayescloglogQuickstart:Quick start}

        {mansection BAYES bayescloglogRemarksandexamples:Remarks and examples}

        {mansection BAYES bayescloglogMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples:  Complementary log-log regression}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}
Fit Bayesian complementary log-log regression using default priors{p_end}
{phang2}{cmd:. bayes: cloglog low age lwt i.race}

{pstd}
Display exponentiated coefficients{p_end}
{phang2}{cmd:. bayes, eform}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): cloglog low age lwt i.race}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:cloglog low age lwt i.race}

{pstd}
Fit Bayesian complementary log-log regression using uniform priors for all regression coefficients and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, prior({low:age lwt i.race _cons}, uniform(-5,5)) rseed(12345): cloglog low age lwt i.race}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:}, uniform(-5,5)) rseed(12345): cloglog low age lwt i.race}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{title:Examples:  Handling perfect prediction}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse heartswitz}

{pstd}
Fit a Bayesian complementary log-log regression using default noninformative priors{p_end}
{phang2}{cmd:. bayes: cloglog disease restecg isfbs age male}

{pstd}
Same as above, but specify option {cmd:noisily} to display the output of the {cmd:cloglog} command{p_end}
{phang2}{cmd:. bayes, noisily: cloglog disease restecg isfbs age male}

{pstd}
Specifying informative priors based on a similar study to resolve a problem of
perfect prediction; specify {cmd:cloglog}'s {cmd:asis} option to prevent
{cmd:cloglog} from dropping the perfect predictors from the model, and specify
{cmd:bayes}'s {cmd:nomleinitial} option to prevent {cmd:bayes} from trying to
obtain ML estimates as starting values{p_end}
{phang2}{cmd:. bayes, prior({disease:restecg age}, normal(0,10))}{p_end}
            {cmd:prior({disease:isfbs male}, normal(1,10))}
	    {cmd:prior({disease:_cons}, normal(-4,10)) nomleinitial:}
	    {cmd:cloglog disease restecg isfbs age male, asis}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
