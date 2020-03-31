{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: heckprobit" "dialog bayes_heckprobit"}{...}
{vieweralsosee "[BAYES] bayes: heckprobit" "mansection BAYES bayesheckprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] heckprobit" "help heckprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_heckprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_heckprobit##menu"}{...}
{viewerjumpto "Description" "bayes_heckprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_heckprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_heckprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_heckprobit##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[BAYES] bayes: heckprobit} {hline 2}}Bayesian probit model with
sample selection{p_end}
{p2col:}({mansection BAYES bayesheckprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt heckprobit}
{depvar} {indepvars}
{ifin}
[{it:{help bayes_heckprobit##weight:weight}}]{cmd:,}
{opt sel:ect}{cmd:(}[{it:{help depvar:depvar_s}} {cmd:=}]
                     {it:{help varlist:varlist_s}}
[{cmd:,} {opt nocons:tant} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt sel:ect()}}specify selection equation: dependent and independent variables; whether to have constant term and offset variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help heckprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt select()} is required. The full specification is{break}
{opt sel:ect}{cmd:(}[{it:depvar_s} {cmd:=}] {it:varlist_s}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_o)}]{cmd:)}.
{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:varlist_s}, and {it:depvar_s} may
contain time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:heckprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:heckprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help heckprobit##options:{it:Options}} in {manhelp heckprobit R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and atanh-transformed correlation; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}
for the main regression and
{cmd:{c -(}select:}{it:varlist_s}{cmd:{c )-}}
for the selection equation, and atanh-transformed correlation
{cmd:{c -(}athrho{c )-}}.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Bayesian regression > Probit model with sample selection}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: heckprobit} fits a Bayesian sample-selection probit regression
to a partially observed binary outcome;
see {manhelp bayes BAYES} and {manhelp heckprobit R:heckprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesheckprobitQuickstart:Quick start}

        {mansection BAYES bayesheckprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesheckprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse school}

{pstd}
Fit Bayesian probit model with sample selection using default priors{p_end}
{phang2}{cmd:. bayes: heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
Check MCMC convergence for {cmd:{athrho}}{p_end}
{phang2}{cmd:. bayesgraph diagnostics {athrho}}

{pstd}
Increase the burn-in period to 5,000 from the default of 2,500 and specify 
a more informative normal prior with zero mean and variance of 10 
for {cmd:athrho}{p_end}
{phang2}{cmd:. bayes, burnin(5000) prior({athrho}, normal(0,10)): heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
MCMC diagnostics for {cmd:{athrho}} look better{p_end}
{phang2}{cmd:. bayesgraph diagnostics {athrho}}

{pstd}
Calculate posterior summaries for rho by inverse-transforming the model 
parameter {cmd:{athrho}}{p_end}
{phang2}{cmd:. bayesstats summary (rho:1-2/(exp(2*{athrho})+1))}

{pstd}
Use standard deviation of 10 of the default normal prior for all model 
parameters, specify random-number seed for reproducibility, and display 
dots during simulation{p_end}
{phang2}{cmd:. bayes, normalprior(10) rseed(12345) dots: heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
Fit Bayesian probit selection model using uniform priors for all regression 
coefficients in the main equation and for {cmd:{athrho}}{p_end}
{phang2}{cmd:. bayes, prior({private:years logptax _cons} {athrho}, uniform(-5,5)): heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({private:} {athrho}, uniform(-5,5)): heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
As above, but use another uniform prior for all regression coefficients in 
the selection equation{p_end}
{phang2}{cmd:. bayes, prior({private:} {athrho}, uniform(-5,5))}{p_end}
            {cmd:prior({vote:}, uniform(-10,10)):}
            {cmd:heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
