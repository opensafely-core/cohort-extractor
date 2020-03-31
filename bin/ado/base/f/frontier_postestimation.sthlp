{smcl}
{* *! version 1.2.8  12feb2019}{...}
{viewerdialog predict "dialog fron_p"}{...}
{vieweralsosee "[R] frontier postestimation" "mansection R frontierpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] frontier" "help frontier"}{...}
{viewerjumpto "Postestimation commands" "frontier postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "frontier_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "frontier postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "frontier postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "frontier postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] frontier postestimation} {hline 2}}Postestimation tools for
frontier{p_end}
{p2col:}({mansection R frontierpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt frontier}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest
{synopt:{helpb frontier_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb frontier postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R frontierpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_xb}}
                           {it:{help newvar:newvar_v}}
                           {it:{help newvar:newvar_u}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the prediction{p_end}
{synopt :{opt u}}estimates of minus the natural log of the technical
efficiency via {it:E}(u|e){p_end}
{synopt :{opt m}}estimates of minus the natural log of the technical
efficiency via M(u|e){p_end}
{synopt :{opt te}}estimates of the technical efficiency via {bind:E{exp(-su)|e}}
{break}
s ={space 2}1, for production functions{break}
s ={space 1}-1, for cost functions
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These statistics are available both in and out of sample; type
{cmd:predict...if e(sample)...} if wanted only for the estimation sample.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and estimates of technical efficiency.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt u} produces estimates of minus the natural log of the technical
efficiency via {it:E}(u|e).

{phang}
{opt m} produces estimates of minus the natural log of the technical
efficiency via M(u|e).

{phang}
{opt te} produces estimates of the technical efficiency
via {bind:E{exp(-su)|e}}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the second equation ({hi:lnsig2v}).

{pmore}
The third new variable will contain the derivative of the log likelihood with
respect to the third equation ({hi:lnsig2u}).

{pmore}
{cmd:scores} may not be specified after estimation with
option {cmd:distribution(tnormal)}.


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
{cmd:margins} estimates margins of response for
linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse greene9}

{pstd}Fit stochastic frontier model and use {cmd:capital} to model the
idiosyncratic error variance{p_end}
{phang2}{cmd:. frontier lnv lnk lnl, vhet(capital)}

{pstd}Estimate technical efficiency{p_end}
{phang2}{cmd:. predict efficiency, te}

{pstd}Use mean of conditional error distribution to estimate minus log
efficiency{p_end}
{phang2}{cmd:. predict mlogeffmean, u}

{pstd}Use mode of conditional error distribution to estimate minus log
efficiency{p_end}
{phang2}{cmd:. predict mlogeffmode, m}{p_end}
