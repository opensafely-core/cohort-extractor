{smcl}
{* *! version 1.0.11  24apr2019}{...}
{viewerdialog "bayes: regress" "dialog bayes_regress"}{...}
{vieweralsosee "[BAYES] bayes: regress" "mansection BAYES bayesregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_regress##syntax"}{...}
{viewerjumpto "Menu" "bayes_regress##menu"}{...}
{viewerjumpto "Description" "bayes_regress##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_regress##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_regress##examples"}{...}
{viewerjumpto "Video examples" "bayes_regress##video"}{...}
{viewerjumpto "Stored results" "bayes_regress##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: regress} {hline 2}}Bayesian linear regression{p_end}
{p2col:}({mansection BAYES bayesregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt reg:ress}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_regress##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab:Reporting}
{synopt :{opth ef:orm(strings:string)}}report exponentiated coefficients and
    label as {it:string}{p_end}
{synopt :{it:{help regress##display_options:display_options}}}control
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
{cmd:bayes:} {cmd:regress,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:regress}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help regress##options:{it:Options}} in {manhelp regress R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt gibbs}}specify Gibbs sampling; available only with normal
priors for regression coefficients and an inverse-gamma prior for variance{p_end}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
{p2coldent:* {opt igammapr:ior(# #)}}specify shape and scale of default inverse-gamma prior for variance; default is {cmd:igammaprior(0.01 0.01)}{p_end}
INCLUDE help bayesecmd_opts
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}} and variance
{cmd:{c -(}sigma2{c )-}}.  Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Bayesian regression > Linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: regress} fits a Bayesian linear regression
to a continuous outcome;
see {manhelp bayes BAYES} and {manhelp regress R} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesregressQuickstart:Quick start}

        {mansection BAYES bayesregressRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}
Fit Bayesian regression using default priors{p_end}
{phang2}{cmd:. bayes: regress price length i.foreign}

{pstd}
Same as above, but increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): regress price length i.foreign}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000): regress}
          {cmd:price length i.foreign}

{pstd}
Same as above, but also specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345): regress}
          {cmd:price length i.foreign}

{pstd}
Specify Zellner's g-prior with 50 degrees of freedom  
and with {cmd:{sigma2}} as variance parameter of the error
term for the 3 regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({price:length i.foreign _cons}, zellnersg0(3, 50, {sigma2}))}
           {cmd:burnin(5000): regress price length i.foreign}

{pstd}
Same as above, but use a shortcut notation to refer to all regression
coefficients{p_end}
{phang2}{cmd:. bayes, prior({price:}, zellnersg0(3, 50, {sigma2}))}
           {cmd:burnin(5000): regress price length i.foreign}

{pstd}
Use Gibbs sampling instead of the default adaptive Metropolis-Hastings 
sampling{p_end}
{phang2}{cmd:. bayes, gibbs: regress price length i.foreign}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Fit Bayesian regression using three chains{p_end}
{phang2}{cmd:. bayes, nchains(3) rseed(16) gibbs:}
         {cmd:regress price length i.foreign}

    {hline}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=L7GfMLl7EqM":Bayesian linear regression using the bayes prefix}

{phang}
{browse "https://www.youtube.com/watch?v=76K1Cznzz0Q":Bayesian linear regression using the bayes prefix: How to specify custom priors}

{phang}
{browse "https://www.youtube.com/watch?v=W9EUr1rtH-k":Bayesian linear regression using the bayes prefix: Checking convergence of the MCMC chain}

{phang}
{browse "https://www.youtube.com/watch?v=KStrHq2Nw6w":Bayesian linear regression using the bayes prefix: How to customize the MCMC chain}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
