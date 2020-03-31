{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: biprobit" "dialog bayes_biprobit_notsu"}{...}
{viewerdialog "bayes: biprobit (seemingly unrelated)" "dialog bayes_biprobit_su"}{...}
{vieweralsosee "[BAYES] bayes: biprobit" "mansection BAYES bayesbiprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] biprobit" "help biprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_biprobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_biprobit##menu"}{...}
{viewerjumpto "Description" "bayes_biprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_biprobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_biprobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_biprobit##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[BAYES] bayes: biprobit} {hline 2}}Bayesian bivariate probit regression{p_end}
{p2col:}({mansection BAYES bayesbiprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Bayesian bivariate probit regression

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt biprobit}
{it:{help depvar:depvar1}} {it:{help depvar:depvar2}}
[{indepvars}]
{ifin}
[{it:{help bayes_biprobit##weight:weight}}]
[{cmd:,} {it:options}]


{phang}Bayesian seemingly unrelated bivariate probit regression

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt biprobit}
{it:equation1} {it:equation2}
{ifin}
[{it:{help biprobit##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}where {it:equation1} and {it:equation2} are specified as

{p 8 12 2}{cmd:(} [{it:eqname}{cmd:: }] {depvar} [{cmd:=}] [{indepvars}]
		[{cmd:,} {opt nocons:tant}
                {opth off:set(varname)} ] {cmd:)}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth offset1(varname)}}offset variable for first equation{p_end}
{synopt :{opth offset2(varname)}}offset variable for second equation{p_end}

{syntab:Reporting}
{synopt :{it:{help biprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar1}, {it:depvar2}, {it:depvar}, and {it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:biprobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:biprobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help biprobit##options:{it:Options}} in {manhelp biprobit R}.  Options
{cmd:noconstant}, {cmd:offset1()}, and {cmd:offset2()} are not allowed
with seemingly unrelated bivariate probit regression.{p_end}

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
{cmd:{c -(}}{it:depvar1}{cmd::}{it:indepvars}{cmd:{c )-}} and
{cmd:{c -(}}{it:depvar2}{cmd::}{it:indepvars}{cmd:{c )-}} and
atanh-transformed correlation {cmd:{c -(}athrho{c )-}}.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Bayesian regression > Bivariate probit regression}

{phang}
{bf:Statistics > Binary outcomes > Bayesian regression > Seemingly unrelated bivariate probit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: biprobit} fits a Bayesian bivariate probit regression to
two binary outcomes;
see {manhelp bayes BAYES} and {manhelp biprobit R:biprobit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesbiprobitQuickstart:Quick start}

        {mansection BAYES bayesbiprobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesbiprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples:  Bivariate probit regression}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse school}

{pstd}
Fit Bayesian bivariate probit regression using default priors{p_end}
{phang2}{cmd:. bayes: biprobit private vote logptax loginc years}

{pstd}
Calculate posterior summaries for rho by inverse-transforming the model 
parameter {cmd:{athrho}}{p_end}
{phang2}{cmd:. bayesstats summary (rho:1-2/(exp(2*{athrho})+1))}

{pstd}
Increase the burn-in period to 5,000 from the default of 2,500 and decrease 
the MCMC samples size to 5,000 from the default 10,000; display dots during 
simulation{p_end}
{phang2}{cmd:. bayes, burnin(5000) mcmcsize(5000) dots: biprobit private vote logptax loginc years}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, burnin(5000) mcmcsize(5000) normalprior(10) rseed(12345) dots: biprobit private vote logptax loginc years}

{pstd}
Fit Bayesian bivariate probit regression using uniform priors for all 
regression coefficients in the {cmd:private} equation{p_end}
{phang2}{cmd:. bayes, prior({private:logptax loginc years _cons}, uniform(-10,10)) dots: biprobit private vote logptax loginc years}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({private:}, uniform(-10,10)) dots: biprobit private vote logptax loginc years}

{pstd}
Use the same uniform priors for regression coefficients in both equations{p_end}
{phang2}{cmd:. bayes, prior({private:} {vote:}, uniform(-10,10)) dots: biprobit private vote logptax loginc years}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{title:Examples:  Seemingly unrelated bivariate probit regression}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse school}

{pstd}
Fit Bayesian seemingly unrelated bivariate probit regression using default 
priors{p_end}
{phang2}{cmd:. bayes: biprobit (private = logptax loginc years) (vote = logptax years)}

{pstd}
Same as above, but use {cmd:uniform(-100,100)} priors for regression 
coefficients in equation {cmd:private} and {cmd:uniform(-10,10)} priors 
for coefficients in equation {cmd:vote}{p_end}
{phang2}{cmd:. bayes, prior({private:}, uniform(-100,100)) prior({vote:}, uniform(-10,10)): biprobit (private = logptax loginc years) (vote = logptax years)}

{pstd}
Report a 90% highest posterior density (HPD) credible interval during replay
{p_end}
{phang2}{cmd:. bayes, clevel(90) hpd}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
