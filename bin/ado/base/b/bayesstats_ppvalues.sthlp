{smcl}
{* *! version 1.0.0  04apr2019}{...}
{viewerdialog "bayesstats ppvalues" "dialog bayesstats_ppvalues"}{...}
{vieweralsosee "[BAYES] bayesstats ppvalues" "mansection BAYES bayesstatsppvalues"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayespredict" "help bayespredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{viewerjumpto "Syntax" "bayesstats_ppvalues##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_ppvalues##menu"}{...}
{viewerjumpto "Description" "bayesstats_ppvalues##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesstats_ppvalues##linkspdf"}{...}
{viewerjumpto "Options" "bayesstats_ppvalues##options"}{...}
{viewerjumpto "Examples" "bayesstats_ppvalues##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_ppvalues##results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[BAYES] bayesstats ppvalues} {hline 2}}Bayesian predictive p-values
and other predictive summaries{p_end}
{p2col:}({mansection BAYES bayesstatsppvalues:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{marker bayespred}{...}
{marker statpred}{...}
{pstd}
Posterior predictive summaries for replicated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmdab:ppval:ues}
{it:{help bayesstats_ppvalues##yspec:yspec}} [{it:yspec} ...] 
{cmd:using} {it:{help bayesstats_ppvalues##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ppvalues##options_table:options}}]


{pstd}
Posterior predictive summaries for expressions of replicated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmdab:ppval:ues}
{cmd:(}{it:{help bayesstats_ppvalues##yexprspec:yexprspec}}{cmd:)}
     [{cmd:(}{it:yexprspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_ppvalues##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ppvalues##options_table:options}}]


{pstd}
Posterior predictive summaries for Mata functions of replicated outcomes, residuals, and more

{p 8 11 2}
{cmd:bayesstats} {cmdab:ppval:ues}
{cmd:(}{it:{help bayesstats_ppvalues##funcspec:funcspec}}{cmd:)}
     [{cmd:(}{it:funcspec}{cmd:)} ...] 
{cmd:using} {it:{help bayesstats_ppvalues##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ppvalues##options_table:options}}]


{pstd}
Full syntax

{p 8 11 2}
{cmd:bayesstats} {cmdab:ppval:ues}
{it:{help bayesstats_ppvalues##predspec:predspec}} [{it:predspec} ...] 
{cmd:using} {it:{help bayesstats_ppvalues##predfile:predfile}}
[{cmd:,} {it:{help bayesstats_ppvalues##options_table:options}}]


INCLUDE help bayesstats_predfile

{marker yspec}{...}
{p 4 6 2}
{it:yspec} is {c -(}{it:{help bayesstats_ppvalues##ysimspec:ysimspec}} {c |}
                    {it:{help bayesstats_ppvalues##residspec:residspec}} {c |}
		    {it:{help bayesstats ppvalues##label:label}}{c )-}.{p_end}

{marker ysimspec}{...}
{p 4 6 2}
{it:ysimspec} is {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} refers to all observations of the
{it:#}th replicated outcome and
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}} refers to the selected
observations, {it:numlist}, of the {it:#}th replicated outcome.
{cmd:{c -(}_ysim{c )-}} is a synonym for {cmd:{c -(}_ysim1{c )-}}.{p_end}

{marker residspec}{...}
{p 4 6 2}
{it:residspec} is {cmd:{c -(}_resid}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_resid}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_resid}{it:#}{cmd:{c )-}} refers to all residuals of the {it:#}th
replicated outcome and {cmd:{c -(}_resid}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}}
refers to the selected residuals, {it:numlist}, of the {it:#}th replicated
outcome.  {cmd:{c -(}_resid{c )-}} is a synonym for {cmd:{c -(}_resid1{c )-}}.
{p_end}

INCLUDE help bayesstats_label.ihlp

{* INCLUDE help bayesstats_largedta.ihlp *}{...}
{pstd}
With large datasets, specifications
{cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} and
{cmd:{c -(}_resid}{it:#}{cmd:{c )-}}
may use a lot of time and memory and should be avoided.  See
{mansection BAYES bayespredictRemarksandexamplesGeneratingandsavingsimulatedoutcomes:{it:Generating and saving simulated outcomes}} in
{bf:[BAYES] bayespredict}.{p_end}

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
{it:predspec} is one of {it:{help bayesstats_ppvalues##yspec:yspec}},
{cmd:(}{it:{help bayesstats_ppvalues##yexprspec:yexprspec}}{cmd:)}, or
{cmd:(}{it:{help bayesstats_ppvalues##funcspec:funcspec}}{cmd:)}.  See
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingpredictionsandtheirfunctions:{it:Different ways of specifying predictions and their functions}}
in {bf:[BAYES] Bayesian postestimation}.


{synoptset 24 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
INCLUDE help bayespost_chainopts
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synoptline}
{p 4 6 2}
* Options {cmd:chains()} and {cmd:sepchains}
are relevant only when option {opt nchains()} is used with {helpb bayesmh}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Posterior predictive p-values}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats ppvalues} performs posterior predictive checking of the 
goodness of fit of a Bayesian model.  It computes
{help bayes_glossary##posterior_predictive_pvalue:posterior predictive p-values}
(PPPs) for functions of
{help bayes_glossary##replicated_outcome:replicated outcomes} produced by
{helpb bayespredict} after fitting a model using {helpb bayesmh}. PPPs measure
the agreement between replicated and observed data. PPPs close to 0 or 1
indicate lack of model fit. The command also reports other summary statistics
related to
{help bayes_glossary##posterior_predictive_checking:posterior predictive checking}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesstatsppvaluesQuickstart:Quick start}

        {mansection BAYES bayesstatsppvaluesRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesstatsppvaluesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{* INCLUDE help bayespost_chainoptsdes *}{...}
{marker chainsspec}{...}
{phang}
{cmd:chains(_all} | {it:{help numlist}}{cmd:)} specifies which chains from the
MCMC sample to use for computation.  The default is {cmd:chains(_all)} or
to use all simulated chains. Using multiple chains, provided the chains have
converged, generally improves MCMC summary statistics. Option {cmd:chains()}
is relevant only when option {cmd:nchains()} is specified with
{helpb bayesmh}.

{phang}
{opt sepchains} specifies that the results be computed separately for each
chain. The default is to compute results using all chains as determined by
option {opt chains()}. Option {opt sepchains} is relevant only when option
{opt nchains()} is specified with {helpb bayesmh}.

{phang}
{opt nolegend} suppresses the display of the table legend, which 
identifies the rows of the table with the expressions they represent.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}{p_end}
{phang2}{cmd:. bayesmh mpg weight length, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({mpg:}, normal(0, 1e4)) block({mpg:}, gibbs)}
        {cmd:prior({c -(}var{c )-}, igamma(.01,.01)) block({c -(}var{c )-}, gibbs)}
        {cmd:mcmcsize(1000) saving(simdata) rseed(14)}

{pstd}Generate simulated outcomes for {cmd:mpg} and save them in {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayespredict {_ysim}, saving(prdata)}

{pstd}Compute posterior predictive p-values for the first simulated observation
using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats ppvalues {_ysim[1]} using prdata}

{pstd} Compute posterior predictive p-values for the minimum and maximum 
of the simulated residuals using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats ppvalues (@min({_resid})) (@max({_resid})) using prdata}

{pstd}Clear prediction data{p_end}
{phang2}{cmd:. rm prdata.dta}{p_end}
{phang2}{cmd:. rm prdata.ster}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats ppvalues} stores the following in {cmd:r()}:

{synoptset 19 tabbed}{...}
{p2col 5 19 21 2: Scalars}{p_end}
{synopt :{cmd:r(mcmcsize)}}MCMC sample size used in the computation{p_end}
INCLUDE help bayespost_scalar_nchains

{p2col 5 19 21 2: Macros}{p_end}
{synopt :{cmd:r(names)}}names of model parameters and expressions{p_end}
{synopt :{cmd:r(expr_}{it:#}{cmd:)}}{it:#}th expression{p_end}
{synopt :{cmd:r(exprnames)}}expression labels{p_end}
INCLUDE help bayespost_macro_chains

{p2col 5 19 21 2: Matrices}{p_end}
{synopt :{cmd:r(summary)}}matrix with predictive statistics for parameters in
{cmd:r(names)}{p_end}
{synopt :{cmd:r(summary_chain}{it:#}{cmd:)}}matrix {cmd:summary} for chain
{it:#}, if {cmd:sepchains} is specified{p_end}
{p2colreset}{...}
