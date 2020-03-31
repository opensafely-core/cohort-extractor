{smcl}
{* *! version 1.0.2  24apr2019}{...}
{viewerdialog "bayesstats grubin" "dialog bayesstats_grubin"}{...}
{vieweralsosee "[BAYES] bayesstats grubin" "mansection BAYES bayesstatsgrubin"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{viewerjumpto "Syntax" "bayesstats_grubin##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_grubin##menu"}{...}
{viewerjumpto "Description" "bayesstats_grubin##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesstats_grubin##linkspdf"}{...}
{viewerjumpto "Options" "bayesstats_grubin##options"}{...}
{viewerjumpto "Examples" "bayesstats_grubin##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_grubin##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[BAYES] bayesstats grubin} {hline 2}}Gelman-Rubin convergence
diagnostics{p_end}
{p2col:}({mansection BAYES bayesstatsgrubin:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Convergence statistics for all model parameters

{p 8 11 2}
{opt bayesstats} {opt gr:ubin}
[{cmd:,} {it:{help bayesstats_grubin##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]

{p 8 11 2}
{opt bayesstats} {opt gr:ubin}
{cmd:_all} [{cmd:,} {it:{help bayesstats_grubin##options_table:options}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]


{phang}
Convergence statistics for selected model parameters

{p 8 11 2}
{opt bayesstats} {opt gr:ubin}
{it:{help bayesstats_grubin##paramspec:paramspec}}
[{cmd:,} {it:{help bayesstats_grubin##options_table:options}}]


{phang}
Convergence statistics for functions of model parameters

{p 8 11 2}
{opt bayesstats} {opt gr:ubin} {it:{help bayesstats_grubin##exprspec:exprspec}}
[{cmd:,} {it:{help bayesstats_grubin##options_table:options}}]


{phang}
Full syntax

{p 8 11 2}
{opt bayesstats} {opt gr:ubin} {it:{help bayesstats_grubin##spec:spec}}
[{it:spec} ...] [{cmd:,} {it:{help bayesstats_grubin##options_table:options}}]


{marker paramspec}{...}
INCLUDE help bayes_paramspec

{marker exprspec}{...}
INCLUDE help bayes_exprspec

{marker spec}{...}
{phang}
{it:spec} is one of {it:{help bayesstats_grubin##paramspec:paramspec}}
or {it:{help bayesstats_grubin##exprspec:exprspec}}.

{synoptset 24}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{synopt :{opt sort}}list parameters in descending order of their convergence
statistics{p_end}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{it:{help bayesstats grubin##display_options:display_options}}}control
spacing, line width, and base and empty cells{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Gelman-Rubin convergence diagnostics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats grubin} calculates Gelman-Rubin convergence diagnostics
for model parameters and functions of model parameters using current Bayesian
estimation results containing at least two Markov chains.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesstatsgrubinQuickstart:Quick start}

        {mansection BAYES bayesstatsgrubinRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesstatsgrubinMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:sort} specifies that model parameters be listed in descending order of
their Gelman-Rubin convergence statistics. This option is useful for
models with many parameters, such as multilevel models, to more easily identify
the set of parameters with large values of convergence statistics.

INCLUDE help bayespost_showreoptdes
{p 8 8 2}
If random-effects parameters are of interest in your study, you should use
option {cmd:showreffects} to check their convergence diagnostics.

INCLUDE help bayespost_skipoptsdes

{phang}
{opt nolegend} suppresses the display of the table legend, which
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


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}

{pstd}Bayesian normal linear regression using three chains{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))} 
        {cmd:prior({change:}, normal(0, 100))}
        {cmd:prior({c -(}var{c )-}, igamma(1, 100))} 
        {cmd:block({change:}, gibbs) nchains(3) rseed(16)}

{pstd}Gelman-Rubin convergence diagnostics{p_end}
{phang2}{cmd:. bayesstats grubin}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}{p_end}

{pstd}Bayesian logistic regression using two chains{p_end}
{phang2}{cmd:. bayes, nchains(2) rseed(16): logit low age lwt i.race}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats grubin} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(mcmcsize)}}MCMC sample size of each chain{p_end}
{synopt:{cmd:r(nchains)}}number of MCMC chains{p_end}
{synopt:{cmd:r(Rc_max)}}maximum convergence diagnostic{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:r(Rc)}}convergence diagnostics {cmd:Rc}{p_end}
{synopt:{cmd:r(t_df)}}degrees of freedom of a t distribution{p_end}
{synopt:{cmd:r(B)}}between-chains variances{p_end}
{synopt:{cmd:r(W)}}within-chain variances{p_end}
{synopt:{cmd:r(V)}}total variances{p_end}
{p2colreset}{...}
