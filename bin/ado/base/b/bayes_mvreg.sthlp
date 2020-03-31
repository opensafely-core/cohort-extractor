{smcl}
{* *! version 1.0.7  31oct2018}{...}
{viewerdialog "bayes: mvreg" "dialog bayes_mvreg"}{...}
{vieweralsosee "[BAYES] bayes: mvreg" "mansection BAYES bayesmvreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_mvreg##syntax"}{...}
{viewerjumpto "Menu" "bayes_mvreg##menu"}{...}
{viewerjumpto "Description" "bayes_mvreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_mvreg##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_mvreg##examples"}{...}
{viewerjumpto "Stored results" "bayes_mvreg##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[BAYES] bayes: mvreg} {hline 2}}Bayesian multivariate regression{p_end}
{p2col:}({mansection BAYES bayesmvreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt mvreg}
{it:{help varlist:depvars}} {cmd:=} {indepvars}
{ifin}
[{it:{help bayes_mvreg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab:Reporting}
{synopt :{it:{help mvreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:mvreg,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:mvreg}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help mvreg##options:{it:Options}} in {manhelp mvreg MV}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt gibbs}}specify Gibbs sampling; available only with normal
priors for regression coefficients and multivariate Jeffreys prior for covariance{p_end}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar1}{cmd::}{it:indepvars}{cmd:{c )-}},
{cmd:{c -(}}{it:depvar2}{cmd::}{it:indepvars}{cmd:{c )-}}, and so on,
and covariance matrix {cmd:{c -(}Sigma,matrix{c )-}}.  Use the {cmd:dryrun}
option to see the definitions of model parameters prior to estimation.{p_end}
{p 4 6 2}Multivariate Jeffreys prior, {opt jeffreys(d)}, is used by default
for the covariance matrix of dimension {it:d}.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Multivariate regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: mvreg} fits a Bayesian multivariate regression to
multiple continuous outcomes;
see {manhelp bayes BAYES} and {manhelp mvreg MV} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmvregQuickstart:Quick start}

        {mansection BAYES bayesmvregRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmvregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}
Fit Bayesian multivariate regression of {cmd:headroom} and {cmd:turn} on 
{cmd:price} and {cmd:mpg}{p_end}
{phang2}{cmd:. bayes: mvreg headroom turn = price mpg}

{pstd}
Use Gibbs sampling instead of the default adaptive Metropolis-Hastings 
sampling and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, gibbs rseed(12345): mvreg headroom turn = price mpg}

{pstd}
Same as above, but specify 90% highest posterior density (HPD) interval{p_end}
{phang2}{cmd:. bayes, gibbs rseed(12345) clevel(90) hpd: mvreg headroom turn = price mpg}

{pstd}
Specify inverse-Wishart prior of dimension 2 with 30 degrees of freedom and
scale matrix {cmd:S} for the covariance matrix instead of the default Jeffreys
prior; increase the burn-in period to 5,000 from the default of 2,500{p_end}
{phang2}{cmd:. matrix S = (0.8,0.5\0.5,10)}{p_end}
{phang2}{cmd:. bayes, prior({Sigma,matrix}, iwishart(2,30,S)) burnin(5000): mvreg headroom turn = price mpg}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
