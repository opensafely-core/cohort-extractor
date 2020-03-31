{smcl}
{* *! version 1.2.9  14may2018}{...}
{vieweralsosee "[SEM] gsem postestimation" "mansection SEM gsempostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem reporting options" "help gsem_reporting_options"}{...}
{viewerjumpto "Postestimation commands" "gsem_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_postestimation##linkspdf"}{...}
{viewerjumpto "margins" "gsem_postestimation##syntax_margins"}{...}
{viewerjumpto "Remarks" "gsem_postestimation##remarks"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[SEM] gsem postestimation} {hline 2}}Postestimation tools for
	gsem{p_end}
{p2col:}({mansection SEM gsempostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following are the postestimation commands that you can use after
estimation by {cmd:gsem}:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb sem_estat_eform:estat eform}}display exponentiated
coefficients{p_end}
INCLUDE help post_estatic
{synopt :{helpb sem_estat_lcgof:estat lcgof}}latent class goodness-of-fit statistic{p_end}
{synopt :{helpb sem_estat_lcmean:estat lcmean}}latent class marginal means{p_end}
{synopt :{helpb sem_estat_lcprob:estat lcprob}}latent class marginal probabilities{p_end}
{synopt :{helpb sem_estat_sd:estat sd}}display variance components as standard deviations and correlations{p_end}
INCLUDE help post_hausman_star

{p2coldent:* {helpb sem_lrtest:lrtest}}likelihood-ratio tests {p_end}
{synopt :{helpb sem_test:test}}Wald tests {p_end}
{synopt :{helpb sem_lincom:lincom}}linear combination of parameters {p_end}
{synopt :{helpb sem_nlcom:nlcom}}nonlinear combination of parameters {p_end}
{synopt :{helpb sem_testnl:testnl}}Wald tests of nonlinear hypotheses {p_end}

INCLUDE help post_estatsum
INCLUDE help post_estatvce

{synopt :{helpb gsem_predict:predict}}generalized linear predictions, etc. {p_end}
INCLUDE help post_predictnl

{synopt:{helpb gsem_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
{synopt :{helpb contrast}}contrasts and linear hypothesis tests{p_end}
{synopt :{helpb pwcompare}}pairwise comparisons{p_end}

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

        {mansection SEM gsempostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}calculate expected values for each {depvar}{p_end}
{synopt :{opt mu}}calculate expected value of {it:depvar}{p_end}
{synopt :{opt pr}}calculate probability (synonym for {cmd:mu} when mu is a
probability){p_end}
{synopt :{opt eta}}calculate expected value of linear prediction of {it:depvar}{p_end}
{synopt :{opt exp:ression}{cmd:(}{it:{help gsem_predict##exp:exp}{cmd:)}}}calculate prediction using {it:exp}{p_end}
{synopt :{opt classpr}}calculate latent class probabilities{p_end}
{synopt :{opt den:sity}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dist:ribution}}not allowed with {cmd:margins}{p_end}
{synopt :{opt surv:ival}}not allowed with {cmd:margins}{p_end}
{synopt :{opt latent}}not allowed with {cmd:margins}{p_end}
{synopt :{opt latent(varlist)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt classpost:eriorpr}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt mu} defaults to the first {it:depvar} if option {opt outcome()}
is not specified.
If {it:depvar} is
{cmd:family(multinomial)} or {cmd:family(ordinal)}
the default is the first level of the outcome.
{p_end}
{p 4 6 2}
{opt pr} defaults to the first {it:depvar} that allows predicted probabilities
if option {opt outcome()} is not specified.
If {it:depvar} is
{cmd:family(multinomial)} or {cmd:family(ordinal)}
the default is the first level of the outcome.
{p_end}
{p 4 6 2}
{opt eta} defaults to the first {it:depvar} if option {opt outcome()}
is not specified.
If {it:depvar} is
{cmd:family(multinomial)}
the default is the first level of the outcome.
{p_end}
{p 4 6 2}
{opt classpr} defaults to the first latent class if option {opt class()}
is not specified.{p_end}
{p 4 6 2}
{cmd:predict}'s option {opt marginal} is assumed if
{cmd:predict}'s options {cmd:conditional(fixedonly)} and {cmd:class()} are
not specified; see {manhelp gsem_predict SEM:predict after gsem}.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for expected values,
probabilities, and predictions.


{marker remarks}{...}
{title:Remarks}

{pstd}
This manual entry concerns {cmd:gsem}.
For information on postestimation features available after {cmd:sem},
see {helpb sem postestimation:[SEM] sem postestimation}.
{p_end}
