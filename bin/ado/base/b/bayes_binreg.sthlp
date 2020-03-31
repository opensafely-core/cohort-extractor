{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: binreg" "dialog bayes_binreg"}{...}
{vieweralsosee "[BAYES] bayes: binreg" "mansection BAYES bayesbinreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] binreg" "help binreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_binreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_binreg##menu"}{...}
{viewerjumpto "Description" "bayes_binreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_binreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_binreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_binreg##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: binreg} {hline 2}}Bayesian generalized linear
models: Extensions to the binomial family{p_end}
{p2col:}({mansection BAYES bayesbinreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt binreg}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_binreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt or}}use logit link and report odds ratios{p_end}
{synopt :{opt rr}}use log link and report risk ratios{p_end}
{synopt :{opt hr}}use log-complement link and report health ratios{p_end}
{synopt :{opt rd}}use identity link and report risk differences{p_end}
{synopt :{cmd:n(}{it:#}|{it:{help varname}}{cmd:)}}use {it:#} or {it:varname} for number of trials{p_end}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synopt :{opth mu(varname)}}use {it:varname} as the initial estimate for the
mean of {depvar}{p_end}
{synopt :{opth ini:t(varname)}}synonym for {opt mu(varname)}{p_end}

{syntab:Reporting}
{synopt :{cmdab:coef:ficients}}report nonexponentiated coefficients{p_end}
{synopt :{it:{help binreg##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:binreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:binreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help binreg##options:{it:Options}} in {manhelp binreg R}.
{cmd:binreg}'s option {cmd:ml} is implied with {cmd:bayes: binreg}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
{* INCLUDE help bayesecmd_opts*}
INCLUDE help bayesmh_prioropts

{marker options_simulation}{...}
  {syntab:{help bayes##simulation_options:Simulation}}
INCLUDE help bayesmh_simopts

{marker options_blocking}{...}
  {syntab:{help bayes##blocking_options:Blocking}}
{p2coldent:* {opt blocksize(#)}}maximum block size; default is {cmd:blocksize(50)}{p_end}
INCLUDE help bayesmh_blockopts
  {p2coldent:* {opt noblock:ing}}do not block parameters by default{p_end}

{marker options_initialization}{...}
  {syntab:{help bayes##initialization_options:Initialization}}
INCLUDE help bayesmh_initopts
  {p2coldent:* {opt noi:sily}}display output from the estimation command during initialization{p_end}

{marker options_adaptation}{...}
  {syntab:{help bayes##adaptation_options:Adaptation}}
INCLUDE help bayesmh_adaptopts

{marker options_reporting}{...}
  {syntab:{help bayes##reporting_options:Reporting}}
INCLUDE help bayes_clevel_hpd_short
{synopt:{cmdab:coef:ficients}}report nonexponentiated coefficients{p_end}
INCLUDE help bayesecmd_reportopts_special

{marker options_advanced}{...}
  {syntab:{help bayes##advanced_options:Advanced}}
INCLUDE help bayesmh_advancedopts
{synoptline}
{p 4 6 2}* Starred options are specific to the {cmd:bayes} prefix; other
options are common between {cmd:bayes} and {helpb bayesmh}.{p_end}
{p 4 6 2}Options {cmd:prior()} and {cmd:block()} may be repeated.{p_end}
{p 4 6 2}{helpb bayesmh##priorspec:{it:priorspec}} and
{helpb bayesmh##paramref:{it:paramref}} are defined in {manhelp bayesmh BAYES}.
{p_end}
{p 4 6 2}{it:paramref} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}See {manhelp bayesian_postestimation BAYES:Bayesian postestimation} for
features available after estimation.{p_end}
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
{bf:Statistics > Generalized linear models > Bayesian GLM for the binomial family}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: binreg} fits a Bayesian binomial regression to a binary 
outcome, assuming different link functions;
see {manhelp bayes BAYES} and {manhelp binreg R:binreg} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesbinregQuickstart:Quick start}

        {mansection BAYES bayesbinregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesbinregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse binreg}

{pstd}
Fit Bayesian binomial regression with the log complement link using default 
priors{p_end}
{phang2}{cmd:. bayes: binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Display coefficients instead of health ratios{p_end}
{phang2}{cmd:. bayes, coef}

{pstd}
Increase the burn-in period to 3,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(3000): binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(3000): binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(3000) rseed(12345): binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Use uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({n_lbw_babies:i.soc i.alc i.smo _cons}, uniform(-10,10)): binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients{p_end}
{phang2}{cmd:. bayes, prior({n_lbw_babies:}, uniform(-10,10)): binreg n_lbw_babies i.soc i.alc i.smo, n(n_women) hr}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
