{smcl}
{* *! version 1.0.10  12dec2018}{...}
{viewerdialog "bayes: hetregress" "dialog bayes_hetregress"}{...}
{vieweralsosee "[BAYES] bayes: hetregress" "mansection BAYES bayeshetregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] hetregress" "help hetregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_hetregress##syntax"}{...}
{viewerjumpto "Menu" "bayes_hetregress##menu"}{...}
{viewerjumpto "Description" "bayes_hetregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_hetregress##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_hetregress##examples"}{...}
{viewerjumpto "Stored results" "bayes_hetregress##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[BAYES] bayes: hetregress} {hline 2}}Bayesian heteroskedastic
linear regression{p_end}
{p2col:}({mansection BAYES bayeshetregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt hetregress}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_hetregress##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmd:het(}{varlist}{cmd:)}}independent variables to model the variance{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab:Reporting}
{synopt :{it:{help hetregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist2
{p 4 6 2}
{it:depvar}, {it:indepvars}, and {it:varlist} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:hetregress,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:hetregress}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help hetregress##options_ml:{it:Options for maximum likelihood estimation}}
and 
{help hetregress##options_twostep:{it:Options for two-step GLS estimation}}
in {manhelp hetregress R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and log-variance coefficients; default is {cmd:normalprior(100)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} for the main
regression and {cmd:{c -(}lnsigma2:}{it:varlist}{cmd:{c )-}} for the
log-variance equation.  Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Heteroskedastic linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: hetregress} fits a Bayesian heteroskedastic linear regression
to a continuous outcome;
see {manhelp bayes BAYES} and {manhelp hetregress R} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeshetregressQuickstart:Quick start}

        {mansection BAYES bayeshetregressRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeshetregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}
Fit Bayesian multiplicative heteroskedastic regression model using default 
priors and use {cmd:length} to model the variance{p_end}
{phang2}{cmd:. bayes: hetregress mpg length i.foreign, het(length)}

{pstd}
Same as above, but increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): hetregress mpg length i.foreign, het(length)}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000): hetregress mpg length i.foreign, het(length)}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345): hetregress mpg length i.foreign, het(length)}

{pstd}
Specify uniform priors for all regression coefficients in the main equation
{p_end}
{phang2}{cmd:. bayes, prior({mpg:length i.foreign _cons}, uniform(-100,100)): hetregress mpg length i.foreign, het(length)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients in the main equation{p_end}
{phang2}{cmd:. bayes, prior({mpg:}, uniform(-100,100)): hetregress mpg length i.foreign, het(length)}

{pstd}
Same as above, but use another uniform prior for regression
coefficients in the variance equation{p_end}
{phang2}{cmd:. bayes, prior({mpg:}, uniform(-100,100)) prior({lnsigma2:}, uniform(-10,10)): hetregress mpg length i.foreign, het(length)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
