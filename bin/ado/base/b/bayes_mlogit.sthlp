{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog "bayes: mlogit" "dialog bayes_mlogit"}{...}
{vieweralsosee "[BAYES] bayes: mlogit" "mansection BAYES bayesmlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_mlogit##syntax"}{...}
{viewerjumpto "Menu" "bayes_mlogit##menu"}{...}
{viewerjumpto "Description" "bayes_mlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_mlogit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_mlogit##examples"}{...}
{viewerjumpto "Stored results" "bayes_mlogit##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[BAYES] bayes: mlogit} {hline 2}}Bayesian multinomial logistic regression{p_end}
{p2col:}({mansection BAYES bayesmlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt mlog:it}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_mlogit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt b:aseoutcome(#)}}value of {depvar} that will be the base outcome{p_end}

{syntab:Reporting}
{synopt :{opt rr:r}}report relative-risk ratios{p_end}
{synopt :{it:{help mlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:mlogit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:mlogit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help mlogit##options:{it:Options}} in {manhelp mlogit R}.{p_end}

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
{p2coldent:* {opt rr:r}}report relative-risk ratios{p_end}
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
{cmd:{c -(}}{it:outcome1}{cmd::}{it:indepvars}{cmd:{c )-}}, 
{cmd:{c -(}}{it:outcome2}{cmd::}{it:indepvars}{cmd:{c )-}}, and so on,
where {it:outcome#}'s are the values of the dependent variable or the value
labels of the dependent variable if they exist.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Bayesian multinomial logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: mlogit} fits a Bayesian multinomial logistic regression
to a categorical outcome;
see {manhelp bayes BAYES} and {manhelp mlogit R:mlogit} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmlogitQuickstart:Quick start}

        {mansection BAYES bayesmlogitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmlogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}

{pstd}
Fit Bayesian multinomial logistic regression using default priors{p_end}
{phang2}{cmd:. bayes: mlogit insure age male nonwhite}

{pstd}
Obtain posterior summaries for relative-risk ratios on replay{p_end}
{phang2}{cmd:. bayes, rrr}

{pstd}
Obtain posterior summaries for relative-risk ratios at estimation time{p_end}
{phang2}{cmd:. bayes, rrr: mlogit insure age male nonwhite}

{pstd}
As above, but specify option {cmd:rrr} with {cmd:mlogit}{p_end}
{phang2}{cmd:. bayes: mlogit insure age male nonwhite, rrr}

{pstd}
Increase the burn-in period to 5,000 from the default of
2,500{p_end}
{phang2}{cmd:. bayes, burnin(5000): mlogit insure age male nonwhite}

{pstd}
Same as above, but use standard deviation of 10 of the default normal prior 
for regression coefficients and specify random-number seed for 
reproducibility{p_end}
{phang2}{cmd:. bayes, normalprior(10) burnin(5000) rseed(12345):}
          {cmd:mlogit insure age male nonwhite}

{pstd}
Fit Bayesian multinomial logistic regression using uniform priors for all 
regression coefficients from the {cmd:Prepaid} equation{p_end}
{phang2}{cmd:. bayes, prior({Prepaid:age male nonwhite _cons}, uniform(-10,10)): mlogit insure age male nonwhite}

{pstd}
Same as above, but use a shortcut notation to refer to all regression coefficients from the {cmd:Prepaid} equation{p_end}
{phang2}{cmd:. bayes, prior({Prepaid:}, uniform(-10,10)): mlogit insure age male nonwhite}

{pstd}
Fit Bayesian multinomial logistic regression using uniform priors for all 
regression coefficients{p_end}
{phang2}{cmd:. bayes, prior({Prepaid:} {Uninsure:}, uniform(-10,10)): mlogit insure age male nonwhite}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
