{smcl}
{* *! version 1.0.0  28apr2019}{...}
{viewerdialog predict "dialog cmclogit_p"}{...}
{vieweralsosee "[CM] cmclogit postestimation" "mansection CM cmclogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmclogit" "help cmclogit"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{viewerjumpto "Postestimation commands" "cmclogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmclogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cmclogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cmclogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cmclogit postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[CM] cmclogit postestimation} {hline 2}}Postestimation tools for
cmclogit{p_end}
{p2col:}({mansection CM cmclogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:cmclogit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt :{helpb cmclogit postestimation##margins:margins}}adjusted predictions, predictive margins, and marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cmclogit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmclogitpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}{cmd:,}
{opt sc:ores}

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability alternative is chosen; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
INCLUDE help esample
{p 4 6 2}
{cmd:predict} omits missing values casewise if {cmd:cmclogit} 
used casewise deletion (the default); if {cmd:cmclogit} used
alternativewise deletion (option {cmd:altwise}),
{cmd:predict} uses alternativewise deletion.


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
{opt pr}, the default, calculates the probability of choosing each alternative.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} 
for {cmd:cmclogit}.  It modifies the calculations made by predict so that they
ignore the offset variable; the linear prediction is treated as 
xb rather than as xb + offset.

{phang}
{cmd:scores} calculates the scores for each coefficient in {cmd:e(b)}.  This
option requires a new variable list of length equal to the number of columns
in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*} syntax to have
{cmd:predict} generate enumerated variables with prefix {it:stub}.


INCLUDE help syntax_cmmargins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}probability alternative is chosen; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ores}}not allowed with {cmd:margins}{p_end}
{synoptline}

INCLUDE help notes_cmmargins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
probabilities and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Fit conditional logit choice model{p_end}
{phang2}{cmd:. cmclogit purchase dealers, casevars(i.gender income)}{p_end}

{pstd}Test whether the coefficients for {cmd:gender=1} are the same for
the {cmd:Japanese} and {cmd:Korean} alternatives relative to the
{cmd:American} base alternative{p_end}
{phang2}{cmd:. test [Japanese]:1.gender = [Korean]:1.gender}{p_end}

{pstd}Calculate predicted probabilities{p_end}
{phang2}{cmd:. predict p}{p_end}
