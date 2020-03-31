{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: intreg" "dialog bayes_intreg"}{...}
{vieweralsosee "[BAYES] bayes: intreg" "mansection BAYES bayesintreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_intreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_intreg##menu"}{...}
{viewerjumpto "Description" "bayes_intreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_intreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_intreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_intreg##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: intreg} {hline 2}}Bayesian interval regression{p_end}
{p2col:}({mansection BAYES bayesintreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt intreg}
{it:{help depvar:depvar1}}
{it:{help depvar:depvar2}}
[{indepvars}]
{ifin}
[{it:{help bayes_intreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:h:et(}{varlist} [{cmd:,} {opt nocons:tant}]{cmd:)}}independent
variables to model the variance; use {opt noconstant} to suppress constant
term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help intreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist2
{p 4 6 2}
{it:depvar1}, {it:depvar2}, {it:indepvars}, and {it:varlist} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:intreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:intreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help intreg##options:{it:Options}} in {manhelp intreg R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-variance; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar1}{cmd::}{it:indepvars}{cmd:{c )-}} and
log-standard deviation {cmd:{c -(}lnsigma{c )-}} or, if option
{opth het(varlist)} is specified, coefficients
{cmd:{c -(}lnsigma:}{it:varlist}{cmd:{c )-}} of the log-standard-deviation
equation.  Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Interval regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: intreg} fits a Bayesian interval regression to a continuous,
interval-measured outcome;
see {manhelp bayes BAYES} and {manhelp intreg R:intreg} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesintregQuickstart:Quick start}

        {mansection BAYES bayesintregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesintregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
We have a dataset containing wages, truncated and in categories.  Some of
the observations on wages are

        {cmd:wage1}    {cmd:wage2}
{p 8 27 2}20{space 7}25{space 6} meaning  20,000 <= wages <= 25,000{p_end}
{p 8 27 2}50{space 8}.{space 6} meaning 50,000 <= wages

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse intregxmpl}{p_end}

{pstd}
Fit Bayesian interval regression, specifying dots during simulation{p_end}
{phang2}{cmd:. bayes, dots: intreg wage1 wage2 age rural school tenure}

{pstd}
As above, but increase the burn-in period to 5,000 from the default of
2,500 and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, burnin(5000) rseed(12345) dots: intreg wage1 wage2 age rural school tenure}

{pstd}
Use standard deviation of 10 instead of 100 of the default normal prior for 
regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10): intreg wage1 wage2 age rural school tenure}

{pstd}
Fit Bayesian interval regression using uniform priors for all regression 
coefficients{p_end}
{phang2}{cmd:. bayes, prior({wage1:age rural school tenure _cons}, uniform(-100,100)): intreg wage1 wage2 age rural school tenure}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients{p_end}
{phang2}{cmd:. bayes, prior({wage1:}, uniform(-100,100)): intreg wage1 wage2 age rural school tenure}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
