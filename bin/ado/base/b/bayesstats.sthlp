{smcl}
{* *! version 1.0.7  03apr2019}{...}
{vieweralsosee "[BAYES] bayesstats" "mansection BAYES bayesstats"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[BAYES] bayesstats} {hline 2}}Bayesian statistics after
bayesmh{p_end}
{p2col:}({mansection BAYES bayesstats:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following subcommands are available with {cmd:bayesstats} after
{cmd:bayesmh} and the {cmd:bayes} prefix:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb bayesstats ess}}effective sample sizes and related statistics{p_end}
{synopt :{helpb bayesstats summary}}Bayesian summary statistics for model parameters and their functions{p_end}
{synopt :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}
{synopt :{helpb bayesstats grubin}}Gelman-Rubin convergence diagnostics{p_end}
{synopt :{helpb bayesstats ppvalues}}Bayesian predictive p-values (available only after {cmd:bayesmh}){p_end}
{synoptline}
{p2colreset}{...}
