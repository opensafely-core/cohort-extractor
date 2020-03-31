{smcl}
{* *! version 1.0.13  25apr2019}{...}
{viewerdialog "bayesstats summary" "dialog bayesstats_summary"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "mansection BAYES bayesstatssummary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesgraph" "help bayesgraph"}{...}
{vieweralsosee "[BAYES] bayespredict" "help bayespredict"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "help bayesstats ess"}{...}
{vieweralsosee "[BAYES] bayesstats ppvalues" "help bayesstats ppvalues"}{...}
{vieweralsosee "[BAYES] bayestest interval" "help bayestest interval"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "bayesstats_summary##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_summary##menu"}{...}
{viewerjumpto "Description" "bayesstats_summary##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesstats_summary##linkspdf"}{...}
{viewerjumpto "Options" "bayesstats_summary##options"}{...}
{viewerjumpto "Examples" "bayesstats_summary##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_summary##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[BAYES] bayesstats summary} {hline 2}}Bayesian summary statistics{p_end}
{p2col:}({mansection BAYES bayesstatssummary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax is presented under the following headings:

        {help bayesstats_summary##statparams:Summary statistics for model parameters}
        {help bayesstats_summary##statpred:Summary statistics for predictions}


{marker statparams}{...}
{title:Summary statistics for model parameters}

{phang}
Summary statistics for all model parameters 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {cmd:_all} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]


{phang}
Summary statistics for selected model parameters

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##paramspec:paramspec}} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Summary statistics for expressions of model parameters

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##exprspec:exprspec}} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Summary statistics of log-likelihood or log-posterior functions 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {cmd:_loglikelihood} | {cmd:_logposterior} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Full syntax 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##spec:spec}}
[{it:spec} ...] 
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{marker paramspec}{...}
INCLUDE help bayes_paramspec

{marker exprspec}{...}
INCLUDE help bayes_exprspec

{phang}
{cmd:_loglikelihood} and {cmd:_logposterior} also have respective synonyms
{cmd:_ll} and {cmd:_lp}.

{marker spec}{...}
{phang}
{it:spec} is one of {it:{help bayesstats_summary##paramspec:paramspec}}, 
{it:{help bayesstats_summary##exprspec:exprspec}}, 
{cmd:_loglikelihood} (or {cmd:_ll}), or {cmd:_logposterior} (or {cmd:_lp}).


{marker statpred}{...}
{title:Summary statistics for predictions}

{pstd}
Summary statistics for simulated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmdab:summ:ary}
{it:{help bayesstats_summary##yspec:yspec}} [{it:yspec} ...] 
{cmd:using} {it:{help bayesstats_summary##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{pstd}
Summary statistics for expressions of simulated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmdab:summ:ary}
{cmd:(}{it:{help bayesstats_summary##yexprspec:yexprspec}}{cmd:)}
     [{cmd:(}{it:yexprspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_summary##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{pstd}
Summary statistics for Mata functions of simulated outcomes, residuals, and
more

{p 8 11 2}
{cmd:bayesstats} {cmdab:summ:ary}
{cmd:(}{it:{help bayesstats_summary##funcspec:funcspec}}{cmd:)}
     [{cmd:(}{it:funcspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_summary##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{pstd}
Full syntax

{p 8 11 2}
{cmd:bayesstats} {cmdab:summ:ary}
{it:{help bayesstats_summary##predspec:predspec}} [{it:predspec} ...] 
{cmd:using} {it:{help bayesstats_summary##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


INCLUDE help bayesstats_predfile

{marker yspec}{...}
{p 4 6 2}
{it:yspec} is {c -(}{it:{help bayesstats_summary##ysimspec:ysimspec}} {c |}
                    {it:{help bayesstats_summary##residspec:residspec}} {c |}
		    {it:{help bayesstats_summary##muspec:muspec}} {c |}
		    {it:{help bayesstats summary##label:label}}{c )-}.{p_end}

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
{it:predspec} is one of {it:{help bayesstats_summary##yspec:yspec}},
{cmd:(}{it:{help bayesstats_summary##yexprspec:yexprspec}}{cmd:)}, or
{cmd:(}{it:{help bayesstats_summary##funcspec:funcspec}}{cmd:)}.  See
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingpredictionsandtheirfunctions:{it:Different ways of specifying predictions and their functions}}
in {bf:[BAYES] Bayesian postestimation}.


{synoptset 24 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt clev:el(#)}}set credible interval level; default is {cmd:clevel(95)}{p_end}
{synopt :{opt hpd}}display HPD credible intervals instead of the default equal-tailed credible intervals{p_end}
{synopt :{opt batch(#)}}specify length of block for batch-means calculations; default is {cmd:batch(0)}{p_end}
INCLUDE help bayespost_chainopts
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{it:{help bayesstats_summary##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{syntab:Advanced}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is {cmd:corrtol(0.01)}{p_end}
{synoptline}
INCLUDE help bayespost_syntablegend


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats summary} calculates and reports posterior summary statistics
for model parameters and functions of model parameters using current
Bayesian estimation results.  Posterior summary
statistics include posterior means, posterior standard deviations, MCMC
standard errors (MCSE), posterior medians, and equal-tailed credible intervals
or highest posterior density (HPD) credible intervals.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesstatssummaryQuickstart:Quick start}

        {mansection BAYES bayesstatssummaryRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesstatssummaryMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

INCLUDE help bayes_clevel_hpd

INCLUDE help bayesmh_batchoptdes

INCLUDE help bayespost_chainoptsdes

INCLUDE help bayespost_showreoptdes

INCLUDE help bayespost_skipoptsdes

{phang}
{opt nolegend} suppresses the display of table legend, which
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

INCLUDE help bayes_corr


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Summaries for all model parameters{p_end}
{phang2}{cmd:. bayesstats summary}

{pstd}Summaries for model parameters {cmd:{change:age}} and {cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesstats summary {change:age} {c -(}var{c )-}}

{pstd}Summaries for model parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesstats summary {change:age _cons}}
	
{pstd}Summaries for model parameters in the equation for {bf:change}{p_end}
{phang2}{cmd:. bayesstats summary {change:}}

{pstd}Summaries for a function of model parameters labeled {cmd:sd}{p_end}
{phang2}{cmd:. bayesstats summary (sd: sqrt({c -(}var{c )-}))}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen, clear}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)} 
        {cmd:nchains(3) rseed(16)}

{pstd}Summaries for all three chains combined{p_end}
{phang2}{cmd:. bayesstats summary}

{pstd}Summaries computed separately for each chain{p_end}
{phang2}{cmd:. bayesstats summary, sepchains}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats summary} stores the following in {cmd:r()}:

{synoptset 19 tabbed}{...}
{p2col 5 19 21 2: Scalars}{p_end}
{synopt:{cmd:r(mcmcsize)}}MCMC sample size used in the computation{p_end}
{synopt:{cmd:r(clevel)}}credible interval level{p_end}
{synopt:{cmd:r(hpd)}}{cmd:1} if {cmd:hpd} is specified, {cmd:0} otherwise {p_end}
{synopt:{cmd:r(batch)}}batch length for batch-means calculations{p_end}
{synopt:{cmd:r(skip)}}number of MCMC observations to skip in the
computation; every {cmd:r(skip)} observations are skipped{p_end}
{synopt:{cmd:r(corrlag)}}maximum autocorrelation lag{p_end}
{synopt:{cmd:r(corrtol)}}autocorrelation tolerance{p_end}
INCLUDE help bayespost_scalar_nchains

{p2col 5 19 21 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of model parameters and expressions{p_end}
{synopt:{cmd:r(expr_}{it:#}{cmd:)}}{it:#}th expression{p_end}
{synopt:{cmd:r(exprnames)}}expression labels{p_end}
INCLUDE help bayespost_macro_chains

{p2col 5 19 21 2: Matrices}{p_end}
{synopt:{cmd:r(summary)}}matrix with posterior summaries statistics for parameters in {cmd:r(names)}{p_end}
{synopt:{cmd:r(summary_chain}{it:#}{cmd:)}}matrix {cmd:summary} for chain {it:#}, if {cmd:sepchains} is specified{p_end}
{p2colreset}{...}
