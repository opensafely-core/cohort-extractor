{smcl}
{* *! version 1.0.9  26apr2019}{...}
{viewerdialog "bayes: clogit" "dialog bayes_clogit"}{...}
{vieweralsosee "[BAYES] bayes: clogit" "mansection BAYES bayesclogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_clogit##syntax"}{...}
{viewerjumpto "Menu" "bayes_clogit##menu"}{...}
{viewerjumpto "Description" "bayes_clogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_clogit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_clogit##examples"}{...}
{viewerjumpto "Stored results" "bayes_clogit##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: clogit} {hline 2}}Bayesian conditional logistic regression{p_end}
{p2col:}({mansection BAYES bayesclogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt clog:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_clogit##weight:weight}}]{cmd:,}
{opth gr:oup(varname)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth gr:oup(varname)}}matched group variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}

{syntab:Reporting}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{it:{help clogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt group(varname)} is required.{p_end}
INCLUDE help fvvarlist
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}. {cmd:fweight}s are interpreted
to apply to groups as a whole, not to individual observations.
See {mansection R clogitRemarksandexamplesUseofweights:{it:Use of weights}}
in {bf:[R] clogit}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:clogit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:clogit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help clogit##options:{it:Options}} in {manhelp clogit R}.{p_end}

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
{p2coldent:* {cmd:or}}report odds ratios{p_end}
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
{bf:Statistics > Binary outcomes > Bayesian regression > Conditional logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: clogit} fits a Bayesian conditional logistic regression to
matched case-control data;
see {manhelp bayes BAYES} and {manhelp clogit R:clogit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesclogitQuickstart:Quick start}

        {mansection BAYES bayesclogitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesclogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse lowbirth2}

{pstd}
Fit Bayesian conditional logistic regression using default priors{p_end}
{phang2}{cmd:. bayes: clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Replay results and report odds ratios{p_end}
{phang2}{cmd:. bayes, or}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500 and display dots during simulation{p_end}
{phang2}{cmd:. bayes, burnin(5000) dots: clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) dots: clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345): clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Fit Bayesian logistic regression using uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:lwt smoke ptd ht ui _cons}, uniform(-10,10)): clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:}, uniform(-10,10)): clogit low lwt smoke ptd ht ui, group(pairid)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
