{smcl}
{* *! version 1.0.7  31oct2018}{...}
{viewerdialog "bayes: betareg" "dialog bayes_betareg"}{...}
{vieweralsosee "[BAYES] bayes: betareg" "mansection BAYES bayesbetareg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] betareg" "help betareg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_betareg##syntax"}{...}
{viewerjumpto "Menu" "bayes_betareg##menu"}{...}
{viewerjumpto "Description" "bayes_betareg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_betareg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_betareg##examples"}{...}
{viewerjumpto "Stored results" "bayes_betareg##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: betareg} {hline 2}}Bayesian beta regression{p_end}
{p2col:}({mansection BAYES bayesbetareg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt betareg}
{depvar} {indepvars}
{ifin}
[{it:{help bayes_betareg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:sca:le(}{varlist} [{cmd:,} {cmdab:nocons:tant}{cmd:)}}specify
independent variables for scale{p_end}
{synopt :{opth li:nk(betareg##linkname:linkname)}}specify link function for the conditional mean;
default is {cmd:link(logit)}{p_end}
{synopt :{opth sli:nk(betareg##slinkname:slinkname)}}specify link function for the conditional
scale; default is {cmd:slink(log)} {p_end}

{syntab:Reporting}
{synopt :{it:{help betareg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist2
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:betareg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:betareg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help betareg##options:{it:Options}} in {manhelp betareg R}.{p_end}

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
{cmd:{c -(}scale:}{it:varlist}{cmd:{c )-}} for the scale equation.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Fractional outcomes > Bayesian beta regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: betareg} fits a Bayesian beta regression to a fractional 
outcome whose values are greater than 0 and less than 1;
see {manhelp bayes BAYES} and {manhelp betareg R:betareg} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesbetaregQuickstart:Quick start}

        {mansection BAYES bayesbetaregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesbetaregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse sprogram}

{pstd}
Fit Bayesian beta regression with default logit link for the conditional mean
and log link for the conditional scale; use default priors{p_end}
{phang2}{cmd:. bayes: betareg prate i.summer freemeals pdonations}

{pstd}
Same as above, but increase the burn-in period to 5,000 from the default of
2,500 and display dots during simulation{p_end}
{phang2}{cmd:. bayes, burnin(5000) dots: betareg prate i.summer freemeals pdonations}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345) dots: betareg prate i.summer freemeals pdonations}

{pstd}
Specify uniform priors for all regression coefficients modeling conditional 
mean{p_end}
{phang2}{cmd:. bayes, prior({prate:i.summer freemeals pdonations _cons}, uniform(-10,10)): betareg prate i.summer freemeals pdonations}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients from equation {cmd:prate}{p_end}
{phang2}{cmd:. bayes, prior({prate:}, uniform(-10,10)): betareg prate i.summer freemeals pdonations}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
