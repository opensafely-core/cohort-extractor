{smcl}
{* *! version 1.2.7  19oct2017}{...}
{viewerdialog predict "dialog xtfront_p"}{...}
{vieweralsosee "[XT] xtfrontier postestimation" "mansection XT xtfrontierpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtfrontier" "help xtfrontier"}{...}
{viewerjumpto "Postestimation commands" "xtfrontier postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtfrontier_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtfrontier postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtfrontier postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtfrontier postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[XT] xtfrontier postestimation} {hline 2}}Postestimation tools for xtfrontier{p_end}
{p2col:}({mansection XT xtfrontierpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtfrontier}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb xtfrontier_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtfrontier postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtfrontierpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtfrontierpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt u}}minus the natural log of the technical efficiency via E(u_it | e_it){p_end}
{synopt :{opt m}}minus the natural log of the technical efficiency via M(u_it | e_it){p_end}
{synopt :{opt te}}the technical efficiency via E{exp(-su_it | e_it}{p_end}
{synoptline}
{p2colreset}{...}

    where
           s =    1 for production functions
                 -1 for cost functions


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and technical efficiencies.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt u} produces estimates of minus the natural log of the technical
inefficiency via E(u_it | e_it).

{phang}
{opt m} produces estimates of minus the natural log of the technical
inefficiency via the mode, M(u_it | e_it).

{phang}
{opt te} produces estimates of the technical efficiency via 
E{c -(}exp(-su_it) | e_it{c )-}.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt u}}not allowed with {cmd:margins}{p_end}
{synopt :{opt m}}not allowed with {cmd:margins}{p_end}
{synopt :{opt te}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtfrontier1}{p_end}
{phang2}{cmd:. constraint 1 [eta]_cons = 0}{p_end}
{phang2}{cmd:. xtfrontier lnwidgets lnmachines lnworkers, tvd constraints(1)}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict xb}

{pstd}Technical efficiency{p_end}
{phang2}{cmd:. predict efficiency, te}

{pstd}Test for constant returns to scale{p_end}
{phang2}{cmd:. test lnmachines + lnworkers = 1}{p_end}
