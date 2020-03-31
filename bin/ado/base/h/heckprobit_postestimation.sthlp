{smcl}
{* *! version 1.1.5  31may2018}{...}
{viewerdialog predict "dialog heckpr_p"}{...}
{vieweralsosee "[R] heckprobit postestimation" "mansection R heckprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckprobit" "help heckprobit"}{...}
{viewerjumpto "Postestimation commands" "heckprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "heckprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "heckprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "heckprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "heckprobit postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] heckprobit postestimation} {hline 2}}Postestimation tools
for heckprobit{p_end}
{p2col:}({mansection R heckprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:heckprobit}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb heckprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb heckprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy} estimation
results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R heckprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt nooff:set} ]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
{it:{help newvar:newvar_sel}}
{it:{help newvar:newvar_athrho}}{c )-}
{ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pm:argin}}Pr({it:depvar}=1); the default{p_end}
{synopt :{opt p11}}Pr({it:depvar}=1, {it:depvar_s}=1){p_end}
{synopt :{opt p10}}Pr({it:depvar}=1, {it:depvar_s}=0){p_end}
{synopt :{opt p01}}Pr({it:depvar}=0, {it:depvar_s}=1){p_end}
{synopt :{opt p00}}Pr({it:depvar}=0, {it:depvar_s}=0){p_end}
{synopt :{opt ps:el}}Pr({it:depvar_s}=1){p_end}
{synopt :{opt pc:ond}}Pr({it:depvar}=1 | {it:depvar_s}=1){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt stdps:el}}standard error of the linear prediction for selection equation{p_end}
{synoptline}
{p2colreset}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pmargin}, the default, calculates the univariate (marginal) predicted
probability of success Pr({it:depvar}=1).

{phang}
{opt p11} calculates the bivariate predicted probability
Pr({it:depvar}=1, {it:depvar_s}=1).

{phang}
{opt p10} calculates the bivariate predicted probability
Pr({it:depvar}=1, {it:depvar_s}=0).

{phang}
{opt p01} calculates the bivariate predicted probability
Pr({it:depvar}=0, {it:depvar_s}=1).

{phang}
{opt p00} calculates the bivariate predicted probability
Pr({it:depvar}=0, {it:depvar_s}=0).

{phang}
{opt psel} calculates the univariate (marginal) predicted probability
of selection Pr({it:depvar_s}=1).

{phang}
{opt pcond} calculates the conditional (on selection) predicted
probability of success Pr({it:depvar}=1 | {it:depvar_s}=1) =
Pr({it:depvar}=1, {it:depvar_s}=1)/Pr({it:depvar_s}=1).

{phang}
{opt xb} calculates the probit linear prediction.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt xbsel} calculates the linear prediction for the selection equation.

{phang}
{opt stdpsel} calculates the standard error of the linear prediction
for the selection equation.

{phang}
{opt nooffset} is relevant only if you specified
{opth offset(varname)} for {cmd:heckprobit}.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset variable; the linear
prediction is treated as xb rather than xb + offset.

{phang}
{opt scores} calculates equation-level score variables.{p_end}

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the selection equation.

{pmore}
The third new variable will contain the derivative of the log likelihood with
respect to the third equation ({hi:athrho}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pm:argin}}Pr({it:depvar}=1); the default{p_end}
{synopt :{opt p11}}Pr({it:depvar}=1, {it:depvar_s}=1){p_end}
{synopt :{opt p10}}Pr({it:depvar}=1, {it:depvar_s}=0){p_end}
{synopt :{opt p01}}Pr({it:depvar}=0, {it:depvar_s}=1){p_end}
{synopt :{opt p00}}Pr({it:depvar}=0, {it:depvar_s}=0){p_end}
{synopt :{opt ps:el}}Pr({it:depvar_s}=1){p_end}
{synopt :{opt pc:ond}}Pr({it:depvar}=1 | {it:depvar_s}=1){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdps:el}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and linear
predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse school}

{pstd}Fit probit model with sample selection{p_end}
{phang2}{cmd:. heckprobit private years logptax, sel(vote=years loginc logptax)}

{pstd}Estimate marginal probability that {cmd:private} equals one{p_end}
{phang2}{cmd:. predict pmarg}

{pstd}Compare to probit model with an {cmd:if} qualifier{p_end}
{phang2}{cmd:. probit private years if vote==1}

{pstd}Calculated predicted probabilities{p_end}
{phang2}{cmd:. predict phat}{p_end}
