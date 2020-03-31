{smcl}
{* *! version 1.0.9  14may2019}{...}
{viewerdialog "bayesstats ess" "dialog bayesstats_ess"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "mansection BAYES bayesstatsess"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{viewerjumpto "Syntax" "bayesstats_ess##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_ess##menu"}{...}
{viewerjumpto "Description" "bayesstats_ess##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesstats_ess##linkspdf"}{...}
{viewerjumpto "Options" "bayesstats_ess##options"}{...}
{viewerjumpto "Examples" "bayesstats_ess##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_ess##results"}{...}
{p2colset 1 27 27 2}{...}
{p2col:{bf:[BAYES] bayesstats ess} {hline 2}}Effective sample sizes and related statistics{p_end}
{p2col:}({mansection BAYES bayesstatsess:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax is presented under the following headings:

        {help bayesstats_ess##statparams:Statistics for model parameters}
        {help bayesstats_ess##statpred:Statistics for predictions}


{marker statparams}{...}
{title:Statistics for model parameters}

{phang}
Statistics for all model parameters 

{p 8 11 2}
{opt bayesstats ess} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]

{p 8 11 2}
{opt bayesstats ess} {cmd:_all} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]


{phang}
Statistics for selected model parameters

{p 8 11 2}
{opt bayesstats ess} {it:{help bayesstats_ess##paramspec:paramspec}} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{phang}
Statistics for expressions of model parameters

{p 8 11 2}
{opt bayesstats ess} {it:{help bayesstats_ess##exprspec:exprspec}} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{phang}
Full syntax 

{p 8 11 2}
{opt bayesstats ess} {it:{help bayesstats_ess##spec:spec}}
[{it:spec} ...] [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{marker paramspec}{...}
INCLUDE help bayes_paramspec

{marker exprspec}{...}
INCLUDE help bayes_exprspec

{marker spec}{...}
{phang}
{it:spec} is one of {it:{help bayesstats_ess##paramspec:paramspec}}  
or {it:{help bayesstats_ess##exprspec:exprspec}}.


{marker statpred}{...}
{title:Statistics for predictions}

{pstd}
Statistics for simulated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmd:ess}
{it:{help bayesstats_ess##yspec:yspec}} [{it:yspec} ...] 
{cmd:using} {it:{help bayesstats_ess##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{pstd}
Statistics for expressions of simulated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmd:ess}
{cmd:(}{it:{help bayesstats_ess##yexprspec:yexprspec}}{cmd:)}
     [{cmd:(}{it:yexprspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_ess##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{pstd}
Statistics for Mata functions of simulated outcomes, residuals, and
more

{p 8 11 2}
{cmd:bayesstats} {cmd:ess}
{cmd:(}{it:{help bayesstats_ess##funcspec:funcspec}}{cmd:)}
     [{cmd:(}{it:funcspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_ess##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{pstd}
Full syntax

{p 8 11 2}
{cmd:bayesstats} {cmd:ess}
{it:{help bayesstats_ess##predspec:predspec}} [{it:predspec} ...] 
{cmd:using} {it:{help bayesstats_ess##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


INCLUDE help bayesstats_predfile

{marker yspec}{...}
{p 4 6 2}
{it:yspec} is {c -(}{it:{help bayesstats_ess##ysimspec:ysimspec}} {c |}
                    {it:{help bayesstats_ess##residspec:residspec}} {c |}
		    {it:{help bayesstats_ess##muspec:muspec}} {c |}
		    {it:{help bayesstats ess##label:label}}{c )-}.{p_end}

{marker ysimspec}{...}
{p 4 6 2}
{it:ysimspec} is {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} refers to all observations of the
{it:#}th simulated outcome and
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}} refers to the selected
observations, {it:numlist}, of the {it:#}th simulated outcome.
{cmd:{c -(}_ysim{c )-}} is a synonym for {cmd:{c -(}_ysim1{c )-}}.{p_end}

{marker residspec}{...}
{p 4 6 2}
{it:residspec} is {cmd:{c -(}_resid}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_resid}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_resid}{it:#}{cmd:{c )-}} refers to all residuals of the {it:#}th
simulated outcome and {cmd:{c -(}_resid}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}}
refers to the selected residuals, {it:numlist}, of the {it:#}th simulated
outcome.  {cmd:{c -(}_resid{c )-}} is a synonym for {cmd:{c -(}_resid1{c )-}}.
{p_end}

INCLUDE help bayesstats_muspec.ihlp

INCLUDE help bayesstats_label.ihlp

INCLUDE help bayesstats_largedta.ihlp

{marker yexprspec}{...}
{p 4 6 2}
{it:yexprspec} is [{it:exprlabel}{cmd::}]{it:yexpr},
where {it:exprlabel} is a valid Stata name and {it:yexpr} is a scalar
expression that may contain
individual observations of simulated outcomes,
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; individual
expected outcome values, {cmd:{c -(}_mu}{it:#}{cmd:[}{it:#}{cmd:]{c )-}};
individual simulated residuals,
{cmd:{c -(}_resid}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; and other scalar
predictions, {cmd:{c -(}}{it:label}{cmd:{c )-}}.{p_end}

INCLUDE help bayesstats_funcspec.ihlp

{marker predspec}{...}
{p 4 6 2}
{it:predspec} is one of {it:{help bayesstats_ess##yspec:yspec}},
{cmd:(}{it:{help bayesstats_ess##yexprspec:yexprspec}}{cmd:)}, or
{cmd:(}{it:{help bayesstats_ess##funcspec:funcspec}}{cmd:)}.  See
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingpredictionsandtheirfunctions:{it:Different ways of specifying predictions and their functions}}
in {bf:[BAYES] Bayesian postestimation}.


{synoptset 24 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
INCLUDE help bayespost_chainopts
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{it:{help bayesstats ess##display_options:display_options}}}control
spacing, line width, and base and empty cells{p_end}

{syntab:Advanced}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default
varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is
{cmd:corrtol(0.01)}{p_end}
{synoptline}
INCLUDE help bayespost_syntablegend


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Effective sample sizes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats ess} calculates effective sample sizes (ESS), correlation
times, and efficiencies for model parameters and functions of model parameters
using current Bayesian estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesstatsessQuickstart:Quick start}

        {mansection BAYES bayesstatsessRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesstatsessMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

INCLUDE help bayespost_chainoptsdes

INCLUDE help bayespost_showreoptdes

INCLUDE help bayespost_skipoptsdes

{phang}
{cmd:nolegend} suppresses the display of the table legend, which
identifies the rows of the table with the expressions they represent.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels}, 
{opt nofvlab:el},
{opt fvwrap(#)}, 
{opt fvwrapon(style)}, and 
{opt nolstretch};
   see {helpb estimation options##display_options:[R] Estimation options}.

{dlgtab:Advanced}

{phang}
{opt corrlag(#)} specifies the maximum autocorrelation lag used for
calculating effective sample sizes.  The default is
min{500,{cmd:mcmcsize()}/2}.  The total autocorrelation is computed as the sum
of all lag-k autocorrelation values for k from 0 to either {cmd:corrlag()} or
the index at which the autocorrelation becomes less than {cmd:corrtol()} if
the latter is less than {cmd:corrlag()}.

{phang}
{opt corrtol(#)} specifies the autocorrelation tolerance used for calculating
effective sample sizes.  The default is {cmd:corrtol(0.01)}.  For a given
model parameter, if the absolute value of the lag-k autocorrelation is less
than {cmd:corrtol()}, then all autocorrelation lags beyond the kth lag are
discarded.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Effective sample sizes for all model parameters{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}Effective sample size for parameter {cmd:{change:age}}{p_end}
{phang2}{cmd:. bayesstats ess {change:age}}

{pstd}Effective sample sizes for a function of model parameter
{cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesstats ess (sqrt({c -(}var{c )-}))}

{pstd}Effective sample sizes for multiple functions of model parameters with
labels for each expression{p_end}
{phang2}{cmd:. bayesstats ess (exp_age: exp({change:age})) (sd: sqrt({c -(}var{c )-}))}
 
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen, clear}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)} 
        {cmd:nchains(3) rseed(16)}

{pstd}Effective sample sizes for all three chains combined{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}Effective sample sizes for the second and third chains combined{p_end}
{phang2}{cmd:. bayesstats ess, chains(2 3)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats ess} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(mcmcsize)}}MCMC sample size used in the computation{p_end}
{synopt:{cmd:r(skip)}}number of MCMC observations to skip in the
computation; every {cmd:r(skip)} observations are skipped{p_end}
{synopt:{cmd:r(corrlag)}}maximum autocorrelation lag{p_end}
{synopt:{cmd:r(corrtol)}}autocorrelation tolerance{p_end}
INCLUDE help bayespost_scalar_nchains

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of model parameters and expressions{p_end}
{synopt:{cmd:r(expr_}{it:#}{cmd:)}}{it:#}th expression{p_end}
{synopt:{cmd:r(exprnames)}}expression labels{p_end}
INCLUDE help bayespost_macro_chains

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:r(ess)}}matrix with effective sample sizes, correlation times, and efficiencies for parameters in {cmd:r(names)}{p_end}
{synopt:{cmd:r(ess_chain}{it:#}{cmd:)}}matrix {cmd:ess} for chain {it:#}, if
{cmd:sepchains} is specified{p_end}
{p2colreset}{...}
