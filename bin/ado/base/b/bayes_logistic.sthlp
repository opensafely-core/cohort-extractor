{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: logistic" "dialog bayes_logistic"}{...}
{vieweralsosee "[BAYES] bayes: logistic" "mansection BAYES bayeslogistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_logistic##syntax"}{...}
{viewerjumpto "Menu" "bayes_logistic##menu"}{...}
{viewerjumpto "Description" "bayes_logistic##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_logistic##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_logistic##examples"}{...}
{viewerjumpto "Stored results" "bayes_logistic##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[BAYES] bayes: logistic} {hline 2}}Bayesian logistic
regression, reporting odds ratios{p_end}
{p2col:}({mansection BAYES bayeslogistic:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt logistic}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_logistic##weight:weight}}]
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
{synopt :{opt coef}}report estimated coefficients{p_end}
{synopt :{it:{help logistic##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:logistic,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:logistic}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help logistic##options:{it:Options}} in {manhelp logistic R}.{p_end}

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
{p2coldent:* {cmd:coef}}report estimated coefficients{p_end}
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
{bf:Statistics > Binary outcomes > Bayesian regression > Logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: logistic} fits a Bayesian logistic regression to a
binary outcome;
see {manhelp bayes BAYES} and {manhelp logistic R:logistic} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeslogisticQuickstart:Quick start}

        {mansection BAYES bayeslogisticRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeslogisticMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples:  Logistic regression}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}
Fit Bayesian logistic regression using default priors{p_end}
{phang2}{cmd:. bayes: logistic low age lwt i.race}

{pstd}
Display coefficients instead of odds ratios{p_end}
{phang2}{cmd:. bayes, coef}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): logistic low age lwt i.race}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000):}
          {cmd:logistic low age lwt i.race}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:logistic low age lwt i.race}

{pstd}
Fit Bayesian logistic regression using uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:age lwt i.race _cons}, uniform(-10,10)): logistic low age lwt i.race}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({low:}, uniform(-10,10)): logistic low age lwt i.race}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{title:Examples:  Handling perfect prediction}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse heartswitz}

{pstd}
Fit a Bayesian logistic regression using default noninformative priors{p_end}
{phang2}{cmd:. bayes: logistic disease restecg isfbs age male}

{pstd}
Same as above, but specify option {cmd:noisily} to display the output of the {cmd:logistic} command{p_end}
{phang2}{cmd:. bayes, noisily: logistic disease restecg isfbs age male}

{pstd}
Specifying informative priors based on a similar study to resolve a problem of
perfect prediction; specify {cmd:logistic}'s {cmd:asis} option to prevent
{cmd:logistic} from dropping the perfect predictors from the model, and specify
{cmd:bayes}'s {cmd:nomleinitial} option to prevent {cmd:bayes} from trying to
obtain ML estimates as starting values{p_end}
{phang2}{cmd:. bayes, prior({disease:restecg age}, normal(0,10))}{p_end}
            {cmd:prior({disease:isfbs male}, normal(1,10))}
	    {cmd:prior({disease:_cons}, normal(-4,10)) nomleinitial:}
	    {cmd:logistic disease restecg isfbs age male, asis}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
