{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: streg" "dialog bayes_streg"}{...}
{vieweralsosee "[BAYES] bayes: streg" "mansection BAYES bayesstreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_streg##syntax"}{...}
{viewerjumpto "Menu" "bayes_streg##menu"}{...}
{viewerjumpto "Description" "bayes_streg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_streg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_streg##examples"}{...}
{viewerjumpto "Stored results" "bayes_streg##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[BAYES] bayes: streg} {hline 2}}Bayesian parametric survival models{p_end}
{p2col:}({mansection BAYES bayesstreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt streg}
[{varlist}]
{ifin}
[{cmd:,} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:e:xponential)}}exponential survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:gom:pertz)}}Gompertz survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:logl:ogistic)}}loglogistic survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ll:ogistic)}}synonym for {cmd:distribution(loglogistic)}{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:w:eibull)}}Weibull survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:logn:ormal)}}lognormal survival distribution{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ln:ormal)}}synonym for {cmd:distribution(lognormal)}{p_end}
{synopt :{cmdab:dist:ribution(}{cmdab:ggam:ma)}}generalized gamma survival distribution{p_end}
{synopt :{cmdab:fr:ailty(}{cmdab:g:amma)}}gamma frailty distribution{p_end}
{synopt :{cmdab:fr:ailty(}{cmdab:i:nvgaussian)}}inverse-Gaussian distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}

{syntab:Model 2}
{synopt :{opth st:rata(varname)}}strata ID variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opth sh:ared(varname)}}shared frailty ID variable{p_end}
{synopt :{opth anc:illary(varlist)}}use {it:varlist} to model the first ancillary parameter{p_end}
{synopt :{opth anc2(varlist)}}use {it:varlist} to model the second ancillary parameter{p_end}

{syntab:Reporting}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{opt nos:how}}do not show st setting information{p_end}
{synopt :{it:{help streg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:bayes: streg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:streg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:streg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help streg##options:{it:Options}} in {manhelp streg ST}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-ancillary parameters; default is
{cmd:normalprior(100)}{p_end}
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
{p2coldent:* {opt nohr}}do not report hazard ratios{p_end}
{p2coldent:* {opt tr:atio}}report time ratios; requires option {cmd:time} with
{cmd:streg}{p_end}
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
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} and
ancillary parameters as described in
{mansection BAYES bayesstregRemarksandexamplesAncillarymodelparameters:{it:Ancillary model parameters}} in {bf:[BAYES] bayes: streg}.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Regression models > Bayesian parametric survival models}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: streg} fits a Bayesian parametric survival model to a
survival-time outcome;
see {manhelp bayes BAYES} and {manhelp streg ST} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesstregQuickstart:Quick start}

        {mansection BAYES bayesstregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesstregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse hip3}{p_end}
{phang2}{cmd:. stset}{p_end}

{pstd}
Fit Bayesian Weibull survival model{p_end}
{phang2}{cmd:. bayes: streg protect age, distribution(weibull)}

{pstd}
Display coefficients instead of hazard ratios{p_end}
{phang2}{cmd:. bayes, nohr}

{pstd}
Display estimates of the shape parameter and its reciprocal{p_end}
{phang2}{cmd:. bayesstats summary (p: exp({ln_p})) (sigma: 1/exp({ln_p}))}

{pstd}
Fit Bayesian Weibull regression using uniform priors for all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({_t:protect age _cons}, uniform(-20,20)): streg protect age, distribution(weibull)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({_t:}, uniform(-20,20)): streg protect age, distribution(weibull)}

{pstd}
Use a different uniform prior for each regression coefficient{p_end}
{phang2}{cmd:. bayes, prior({_t:protect}, uniform(-5,5)) prior({_t:age}, uniform(0,1)) prior({_t:_cons}, uniform(-20,20)): streg protect age, distribution(weibull)}

{pstd}
Fit Bayesian Weibull survival model with ancillary variable {cmd:male}; 
use standard deviation of 10 of the default normal prior for 
regression coefficients and display dots as iterations are performed{p_end}
{phang2}{cmd:. bayes, normalprior(10) dots: streg protect age, distribution(weibull) ancillary(male)}

{pstd}
Same as above, but also increase the burn-in period to 3,000 from the default
of 2,500 and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) dots burnin(3000) rseed(12345): streg protect age, distribution(weibull) ancillary(male)}

{pstd}
Examine the diagnostic plot for {cmd:{ln_p:male}}{p_end}
{phang2}{cmd:. bayesgraph diagnostic {ln_p:male}}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
