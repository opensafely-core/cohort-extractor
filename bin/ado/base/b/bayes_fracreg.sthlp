{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: fracreg" "dialog bayes_fracreg"}{...}
{vieweralsosee "[BAYES] bayes: fracreg" "mansection BAYES bayesfracreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] fracreg" "help fracreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_fracreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_fracreg##menu"}{...}
{viewerjumpto "Description" "bayes_fracreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_fracreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_fracreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_fracreg##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: fracreg} {hline 2}}Bayesian fractional response regression{p_end}
{p2col:}({mansection BAYES bayesfracreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax for fractional probit regression

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt fracreg} {opt pr:obit}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_fracreg##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Syntax for fractional logistic regression

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt fracreg} {opt log:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help fracreg##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Syntax for fractional heteroskedastic probit regression

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt fracreg} {opt pr:obit}
{depvar} [{indepvars}]
{ifin}
[{it:{help fracreg##weight:weight}}]{cmd:,}
{cmd:het(}{varlist}[{cmd:,}
{opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]


{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{p2coldent:* {cmd:het(}{varlist}[{cmd:,} {opth off:set(varname:varname_o)}]}independent variables to
model the variance and possible offset variable with {cmd:fracreg probit}{p_end}

{syntab:Reporting}
{synopt :{opt or}}report odds ratios; only valid with {cmd:fracreg logit}{p_end}
{synopt :{it:{help fracreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}* {cmd:het()} may be used only with {cmd:fracreg probit} to compute
fractional heteroskedastic probit regression.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:fracreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:fracreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help fracreg##options:{it:Options}} in {manhelp fracreg R}.{p_end}

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
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} and, if
option {opt het()} is specified, regression coefficients
{cmd:{c -(}lnsigma:}{it:varlist}{cmd:{c )-}} for the log-standard
deviation equation.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Fractional outcomes > Bayesian fractional regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: fracreg} fits a Bayesian fractional response regression to a
fractional outcome whose values are greater than or equal to 0 and less
than or equal to 1;
see {manhelp bayes BAYES} and {manhelp fracreg R:fracreg} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesfracregQuickstart:Quick start}

        {mansection BAYES bayesfracregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesfracregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse 401k}

{pstd}
Fit Bayesian fractional probit regression using default priors{p_end}
{phang2}{cmd:. bayes: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Same as above, but increase the burn-in period to 5,000 from the default of
2,500 and display dots during simulation{p_end}
{phang2}{cmd:. bayes, burnin(5000) dots: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345) dots: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Specify uniform priors for all regression coefficients; use option {cmd:dryrun} 
to check model specification{p_end}
{phang2}{cmd:. bayes, prior({prate:mrate ltotemp age i.sole _cons}, uniform(-5,5)) dryrun: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Fit the above model without displaying model summary{p_end}
{phang2}{cmd:. bayes, prior({prate:mrate ltotemp age i.sole _cons}, uniform(-5,5)) nomodelsummary: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients{p_end}
{phang2}{cmd:. bayes, prior({prate:}, uniform(-5,5)) nomodelsummary: fracreg probit prate mrate ltotemp age i.sole}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
