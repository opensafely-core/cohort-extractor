{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: poisson" "dialog bayes_poisson"}{...}
{vieweralsosee "[BAYES] bayes: poisson" "mansection BAYES bayespoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_poisson##syntax"}{...}
{viewerjumpto "Menu" "bayes_poisson##menu"}{...}
{viewerjumpto "Description" "bayes_poisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_poisson##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_poisson##examples"}{...}
{viewerjumpto "Stored results" "bayes_poisson##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: poisson} {hline 2}}Bayesian Poisson regression{p_end}
{p2col:}({mansection BAYES bayespoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt poisson}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_poisson##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{it:{help poisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar}, {it:indepvars}, {it:varname_e}, and {it:varname_o} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:poisson,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:poisson}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help poisson##options:{it:Options}} in {manhelp poisson R}.{p_end}

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
{p2coldent:* {opt ir:r}}report incidence-rate ratios{p_end}
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
{bf:Statistics > Count outcomes > Bayesian regression > Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: poisson} fits a Bayesian Poisson regression to a
nonnegative count outcome;
see {manhelp bayes BAYES} and {manhelp poisson R:poisson} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayespoissonQuickstart:Quick start}

        {mansection BAYES bayespoissonRemarksandexamples:Remarks and examples}

        {mansection BAYES bayespoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse dollhill3}

{pstd}
Fit Bayesian Poisson regression using default priors{p_end}
{phang2}{cmd:. bayes: poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Replay results and report incidence-rate ratios{p_end}
{phang2}{cmd:. bayes, irr}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Fit Bayesian Poisson regression using uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({deaths:smokes i.agecat _cons}, uniform(-10,10)): poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({deaths:}, uniform(-10,10)): poisson deaths smokes i.agecat, exposure(pyears)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
