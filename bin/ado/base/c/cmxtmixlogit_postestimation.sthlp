{smcl}
{* *! version 1.0.0 28apr2019}{...}
{viewerdialog predict "dialog cmxtmixlogit_p"}{...}
{vieweralsosee "[CM] cmxtmixlogit postestimation" "mansection CM cmxtmixlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmxtmixlogit" "help cmxtmixlogit"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{viewerjumpto "Postestimation commands" "cmxtmixlogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmxtmixlogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cmxtmixlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cmxtmixlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cmxtmixlogit postestimation##examples"}{...}
{p2colset 1 37 39 2}{...}
{p2col:{bf:[CM] cmxtmixlogit postestimation} {hline 2}}Postestimation tools for
cmxtmixlogit{p_end}
{p2col:}({mansection CM cmxtmixlogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after {cmd:cmxtmixogit}:

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt :{helpb cmxtmixlogit postestimation##margins:margins}}adjusted predictions, predictive margins, and marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cmxtmixlogit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmxtmixlogitpostestimationMethodsandformulas:Methods and formulas}

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
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}{cmd:,}
{opt sc:ores}

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability alternative is chosen; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synoptline}
INCLUDE help esample
{p 4 6 2}
{cmd:predict} omits missing values casewise if {cmd:cmxtmixlogit} 
used casewise deletion (the default); if {cmd:cmxtmixlogit} used
alternativewise deletion (option {cmd:altwise}),
{cmd:predict} uses alternativewise deletion.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities or linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:pr}, the default, calculates the probability of choosing each alternative.

{phang}
{cmd:xb} calculates the linear prediction.

{phang}
{cmd:scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.


INCLUDE help syntax_cmmargins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}probability alternative is chosen; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
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
{phang2}{cmd:. webuse transport}{p_end}
{phang2}{cmd:. cmset id t alt}{p_end}

{pstd}Fit panel-data mixed logit choice model{p_end}
{phang2}{cmd:. cmxtmixlogit choice trcost, casevars(age income) random(trtime)}{p_end}

{pstd}Estimate expected choice probabilities for specified income levels{p_end}
{phang2}{cmd:. margins, at(income=(3 8))}{p_end}

{pstd}Same as above, but evaluate the predictions at a certain time
point{p_end}
{phang2}{cmd:. margins, at(income(3 8)) subpop(if t==1)}{p_end}
