{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: heckman" "dialog bayes_heckman"}{...}
{vieweralsosee "[BAYES] bayes: heckman" "mansection BAYES bayesheckman"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_heckman##syntax"}{...}
{viewerjumpto "Menu" "bayes_heckman##menu"}{...}
{viewerjumpto "Description" "bayes_heckman##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_heckman##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_heckman##examples"}{...}
{viewerjumpto "Stored results" "bayes_heckman##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: heckman} {hline 2}}Bayesian Heckman selection
model{p_end}
{p2col:}({mansection BAYES bayesheckman:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt heckman}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_heckman##weight:weight}}]{cmd:,}
    {opt sel:ect}{cmd:(}[{it:{help depvar:depvar_s}} {cmd:=}]
    {it:{help varlist:varlist_s}} [{cmd:,} 
    {opt nocons:tant} {opth off:set(varname:varname_o)}]{cmd:)} 
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt sel:ect()}}specify selection equation: dependent and independent variables; whether to have constant term and offset variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help heckman##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt select()} is required. The full specification is{break}
{opt sel:ect}{cmd:(}[{it:depvar_s} {cmd:=}] {it:varlist_s}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_o)}]{cmd:)}.
{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:indepvars}, {it:varlist_s}, and {it:depvar_s} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:heckman,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:heckman}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help heckman##options_ml:{it:Options for Heckman selection model (ML)}} and
{help heckman##options_twostep:{it:Options for Heckman selection model (two-step)}} in {manhelp heckman R}.{p_end}

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
{cmd:{c -(}select:}{it:varlist_2}{cmd:{c )-}}
for the selection equation, atanh-transformed correlation
{cmd:{c -(}athrho{c )-}}, and log-standard deviation
{cmd:{c -(}lnsigma{c )-}}.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Heckman selection model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: heckman} fits a Bayesian sample-selection linear regression
to a partially observed continuous outcome;
see {manhelp bayes BAYES} and {manhelp heckman R:heckman} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesheckmanQuickstart:Quick start}

        {mansection BAYES bayesheckmanRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesheckmanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse womenwk}

{pstd}
Fit Bayesian Heckman selection model, specifying dots be displayed during 
simulation{p_end}
{phang2}{cmd:. bayes, dots: heckman wage educ age, select(married children educ age)}

{pstd}
Calculate posterior summaries for rho, sigma, and lambda, inverse-transforming
the model parameters {cmd:{athrho}} and {cmd:{lnsigma}}{p_end}
{phang2}{cmd:. bayesstats summary (rho:1-2/(exp(2*{athrho})+1)) (sigma:exp({lnsigma})) (lambda:exp({lnsigma})*(1-2/(exp(2*{athrho})+1)))}

{pstd}
Use standard deviation of 10 of the default normal prior for regression 
coefficients and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) rseed(12345) dots:}
          {cmd:heckman wage educ age, select(married children educ age)}

{pstd}
Fit Bayesian Heckman selection model using uniform priors for all regression 
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({wage:educ age _cons}, uniform(-5,5)) dots:}
          {cmd:heckman wage educ age, select(married children educ age)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({wage:}, uniform(-5,5)) dots:}
          {cmd:heckman wage educ age, select(married children educ age)}

{pstd}
As above, but use another uniform prior for all regression coefficients in 
the selection equation{p_end}
{phang2}{cmd:. bayes, prior({wage:}, uniform(-5,5))} 
          {cmd:prior({select:}, uniform(-10,10)) dots:}
          {cmd:heckman wage educ age, select(married children educ age)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
