{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: heckoprobit" "dialog bayes_heckoprobit"}{...}
{vieweralsosee "[BAYES] bayes: heckoprobit" "mansection BAYES bayesheckoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] heckoprobit" "help heckoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_heckoprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_heckoprobit##menu"}{...}
{viewerjumpto "Description" "bayes_heckoprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_heckoprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_heckoprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_heckoprobit##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[BAYES] bayes: heckoprobit} {hline 2}}Bayesian ordered probit
model with sample selection{p_end}
{p2col:}({mansection BAYES bayesheckoprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt heckoprobit}
{depvar} {indepvars}
{ifin}
[{it:{help bayes_heckoprobit##weight:weight}}]{cmd:,}
{opt sel:ect}{cmd:(}[{it:{help depvar:depvar_s}} {cmd:=}]
                     {it:{help varlist:varlist_s}}
[{cmd:,} {opt nocons:tant} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt sel:ect()}}specify selection equation:  dependent and independent variables; whether to have constant term and offset variable{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}

{syntab:Reporting}
{synopt :{it:{help heckoprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt select()} is required.  The full specification is{p_end}
{p 10 10 2}
{opt sel:ect}{cmd:(}[{it:depvar_s} {cmd:=}] {it:varlist_s}
[{cmd:,} {opt nocons:tant} {opt off:set(varname_o)}]{cmd:)}
{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:varlist_s}, and {it:depvar_s} may
contain time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:heckoprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:heckoprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help heckoprobit##options:{it:Options}} in {manhelp heckoprobit R}.{p_end}

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
{cmd:{c -(}select:}{it:varlist_s}{cmd:{c )-}}
for the selection equation, atanh-transformed correlation
{cmd:{c -(}athrho{c )-}}, and cutpoints
{cmd:{c -(}cut1{c )-}}, {cmd:{c -(}cut2{c )-}}, and so on.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}Flat priors, {cmd:flat}, are used by default for cutpoints.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Bayesian regression > Ordered probit regression with sample selection}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: heckoprobit} fits a Bayesian sample-selection ordered probit
regression to a partially observed ordinal outcome;
see {manhelp bayes BAYES} and {manhelp heckoprobit R:heckoprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesheckoprobitQuickstart:Quick start}

        {mansection BAYES bayesheckoprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesheckoprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse womensat}{p_end}
{phang2}{cmd:. set seed 5678}{p_end}
{phang2}{cmd:. sample 5, by(work)}{p_end}

{pstd}
Fit Bayesian ordered probit model with sample selection using default priors; 
display dots during simulation{p_end}
{phang2}{cmd:. bayes, dots: heckoprobit satisfaction educ age, select(work=educ age i.married children)}

{pstd}
Check efficiency for model parameters{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}
Increase the burn-in period to 5,000 from the default of 2,500; specify 
a more informative normal prior with zero mean and variance of 5 for 
cutpoints; and use a random-number see for reproducibility{p_end}
{phang2}{cmd:. bayes, burnin(5000) prior({cut1 cut2 cut3}, normal(0,5)) rseed(123) dots: heckoprobit satisfaction educ age, select(work=educ age i.married children)}

{pstd}
Calculate posterior summaries for rho by inverse-transforming the model 
parameter {cmd:{athrho}}{p_end}
{phang2}{cmd:. bayesstats summary (rho:1-2/(exp(2*{athrho})+1))}

{pstd}
Fit Bayesian ordered probit selection model using uniform priors for all
regression coefficients in the main equation and {cmd:normal(0,5)} prior for 
cutpoints; use a smaller MCMC sample size of 5,000 instead of the default of 
10,000{p_end}
{phang2}{cmd:. bayes, prior({satisfaction:educ age _cons}, uniform(-1,1)) prior({cut1 cut2 cut3}, normal(0,5)) mcmcsize(5000) dots: heckoprobit satisfaction educ age, select(work=educ age i.married children)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({satisfaction:}, uniform(-1,1)) prior({cut1 cut2 cut3}, normal(0,5)) mcmcsize(5000) dots: heckoprobit satisfaction educ age, select(work=educ age i.married children)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
