{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: ologit" "dialog bayes_ologit"}{...}
{vieweralsosee "[BAYES] bayes: ologit" "mansection BAYES bayesologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_ologit##syntax"}{...}
{viewerjumpto "Menu" "bayes_ologit##menu"}{...}
{viewerjumpto "Description" "bayes_ologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_ologit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_ologit##examples"}{...}
{viewerjumpto "Stored results" "bayes_ologit##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: ologit} {hline 2}}Bayesian ordered logistic regression{p_end}
{p2col:}({mansection BAYES bayesologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt olog:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_ologit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{it:{help ologit##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:ologit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:ologit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help ologit##options:{it:Options}} in {manhelp ologit R}.{p_end}

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
{bf:Statistics > Ordinal outcomes > Bayesian regression > Ordered logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: ologit} fits a Bayesian ordered logistic regression to
an ordinal outcome;
see {manhelp bayes BAYES} and {manhelp ologit R:ologit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesologitQuickstart:Quick start}

        {mansection BAYES bayesologitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesologitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse fullauto}

{pstd}
Fit Bayesian ordered logistic regression using default priors{p_end}
{phang2}{cmd:. bayes: ologit rep77 mpg foreign}

{pstd}
Display odds ratios instead of coefficients{p_end}
{phang2}{cmd:. bayes, or}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): ologit rep77 mpg foreign}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:ologit rep77 mpg foreign}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:ologit rep77 mpg foreign}

{pstd}
Fit Bayesian ordered logistic regression using uniform priors for all regression coefficients and normal priors for cutpoints{p_end}
{phang2}{cmd:. bayes, prior({rep77:mpg foreign}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3 cut4}, normal(0,10)):}
            {cmd:ologit rep77 mpg foreign}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({rep77:}, uniform(-5,5))}{p_end}
            {cmd:prior({cut1 cut2 cut3 cut4}, normal(0,10)):}
            {cmd:ologit rep77 mpg foreign}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
