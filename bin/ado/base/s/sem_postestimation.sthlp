{smcl}
{* *! version 1.1.8  14may2018}{...}
{vieweralsosee "[SEM] sem postestimation" "mansection SEM sempostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem reporting options" "help sem_reporting_options"}{...}
{viewerjumpto "Postestimation commands" "sem_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_postestimation##linkspdf"}{...}
{viewerjumpto "margins" "sem_postestimation##syntax_margins"}{...}
{viewerjumpto "Remarks" "sem_postestimation##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[SEM] sem postestimation} {hline 2}}Postestimation tools for
	sem{p_end}
{p2col:}({mansection SEM sempostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following are the postestimation commands that you can use after
estimation by {cmd:sem}:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb sem_estat_framework:estat framework}}display results in
modeling framework (matrix form){p_end}

{synopt :{helpb sem_estat_gof:estat gof}}overall goodness of fit{p_end}
{synopt :{helpb sem_estat_ggof:estat ggof}}group-level goodness of fit{p_end}
{synopt :{helpb sem_estat_eqgof:estat eqgof}}equation-level goodness of fit{p_end}
{synopt :{helpb sem_estat_residuals:estat residuals}}matrices of residuals{p_end}
INCLUDE help post_estatic
INCLUDE help post_hausman_star

{synopt :{helpb sem_estat_mindices:estat mindices}}modification indices (score tests){p_end}
{synopt :{helpb sem_estat_scoretests:estat scoretests}}score tests{p_end}
{synopt :{helpb sem_estat_ginvariant:estat ginvariant}}test of invariance of
parameters across groups{p_end}

{synopt :{helpb sem_estat_eqtest:estat eqtest}}equation-level Wald tests{p_end}
{p2coldent:* {helpb sem_lrtest:lrtest}}likelihood-ratio tests {p_end}
{synopt :{helpb sem_test:test}}Wald tests {p_end}
{synopt :{helpb sem_lincom:lincom}}linear combination of parameters {p_end}
{synopt :{helpb sem_nlcom:nlcom}}nonlinear combination of parameters {p_end}
{synopt :{helpb sem_testnl:testnl}}Wald tests of nonlinear hypotheses {p_end}
{synopt :{helpb sem_estat_stdize:estat stdize:}}test standardized parameters{p_end}

{synopt :{helpb sem_estat_teffects:estat teffects}}decomposition of effects{p_end}
{synopt :{helpb sem_estat_stable:estat stable}}assess stability of nonrecursive systems{p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce

{synopt :{helpb sem_predict:predict}}factor scores, predicted values, etc. {p_end}

{synopt:{helpb sem_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot

{synopt :{helpb estimates:estimates}}cataloging estimation results{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.

{pstd}
For a summary of postestimation features, see {manlink SEM Intro 7}.

{pstd}
Postestimation commands such {cmd:lincom} and {cmd:nlcom} require
referencing estimated parameter values, which are accessible via
{cmd:_b[}{it:name}{cmd:]}. To find out what the names are, type
{cmd:sem,} {cmd:coeflegend}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM sempostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}linear prediction for all OEn variables{p_end}
{synopt :{opth xb(varname)}}linear prediction for the specified OEn variable{p_end}
{synopt :{opt xb}}not syntactically compatible with {cmd:margins}{p_end}
{synopt :{opt xblat:ent}}not allowed with {cmd:margins}{p_end}
{synopt :{opt xblat:ent(varlist)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt lat:ent}}not allowed with {cmd:margins}{p_end}
{synopt :{opt lat:ent(varlist)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Key: OEn = observed endogenous
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker remarks}{...}
{title:Remarks}

{pstd}
This manual entry concerns {cmd:sem}.
For information on postestimation features available after {cmd:gsem},
see {helpb gsem postestimation:[SEM] gsem postestimation}.
{p_end}
