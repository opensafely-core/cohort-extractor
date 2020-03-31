{smcl}
{* *! version 1.0.5  07jan2019}{...}
{viewerdialog predict "dialog irt_p"}{...}
{vieweralsosee "[IRT] irt 2pl postestimation" "mansection IRT irt2plpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] estat greport" "help estat greport"}{...}
{vieweralsosee "[IRT] estat report" "help estat report"}{...}
{vieweralsosee "[IRT] irtgraph icc" "help irtgraph icc"}{...}
{vieweralsosee "[IRT] irtgraph iif" "help irtgraph iif"}{...}
{vieweralsosee "[IRT] irtgraph tcc" "help irtgraph tcc"}{...}
{vieweralsosee "[IRT] irtgraph tif" "help irtgraph tif"}{...}
{viewerjumpto "Postestimation commands" "irt 2pl postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "irt_2pl_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "irt 2pl postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "irt 2pl postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[IRT] irt 2pl postestimation} {hline 2}}Postestimation tools for 
irt 2pl {p_end}
{p2col:}({mansection IRT irt2plpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:irt 2pl}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_irt_special
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_irt_common1
{synopt :{helpb irt 2pl postestimation##predict:predict}}predictions{p_end}
INCLUDE help post_irt_common2
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:lrtest} is not appropriate with {cmd:svy} estimation results.

 
{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irt2plpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{pstd}
Syntax for obtaining predictions of item probabilities and other statistics

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin} 
[{cmd:,} {it:{help irt_2pl_postestimation##statistic:statistic}}
{it:{help irt_2pl_postestimation##ioptions:item_options}}]


{p 4 4 2}
Syntax for obtaining estimated latent variables and their standard errors

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin}{cmd:,} {opt latent}
[{it:{help irt_2pl_postestimation##loptions:latent_options}}]


{pstd}
Syntax for obtaining parameter-level scores

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin}{cmd:,} {opt sc:ores}


{pstd}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.


INCLUDE help syntax_irt_predict_stats

{marker ioptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr:item_options}
{synoptline}
{syntab:Main}
{synopt :{opt outcome(item)}}specify item variable; default is all
     variables{p_end}
{synopt :{opth cond:itional(irt_2pl_postestimation##ctype:ctype)}}compute
     {it:statistic} conditional on estimated latent variables; default is
     {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the
     latent variables{p_end}

{syntab:Integration}
{synopt :{help irt_2pl_postestimation##int_options:{it:int_options}}}integration
      options{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help syntax_irt_predict_ctype

{marker loptions}{...}
{synoptset 20 tabbed}{...}
{synopthdr:latent_options}
{synoptline}
{syntab:Main}
{synopt :{opt ebmean:s}}use empirical Bayes means of latent trait; the
     default{p_end}
{synopt :{opt ebmode:s}}use empirical Bayes modes of latent trait{p_end}
{synopt :{opth se(newvar)}}calculate standard errors{p_end}

{syntab:Integration}
{synopt :{help irt_2pl_postestimation##int_options:{it:int_options}}}integration
    options{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help syntax_irt_predict_int


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and parameter-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

INCLUDE help des_irt_predict_pr

INCLUDE help des_irt_predict_xb

INCLUDE help des_irt_predict_outcome

INCLUDE help des_irt_predict_item

INCLUDE help des_irt_predict_latent

INCLUDE help des_irt_predict_se

INCLUDE help des_irt_predict_scores

INCLUDE help des_irt_predict_int


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}

{pstd}Fit a 2PL model to binary items {cmd:q1-q9}{p_end}
{phang2}{cmd:. irt 2pl q1-q9}

{pstd}Replay the table of estimated IRT parameters, sorting the output by
parameter instead of by item and in ascending order of discrimination{p_end}
{phang2}{cmd:. estat report, byparm sort(a)}

{pstd}Use the 2PL parameters to plot the item characteristic curves of the
highest and lowest items{p_end}
{phang2}{cmd:. irtgraph icc q7 q1, blocation}

{pstd}Use the 2PL parameters to plot the test characteristic curves{p_end}
{phang2}{cmd:. irtgraph tcc, thetalines(-1.96 0 1.96)}{p_end}
