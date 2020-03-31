{smcl}
{* *! version 1.0.0  28apr2019}{...}
{viewerdialog predict "dialog cmmixlogit_p"}{...}
{vieweralsosee "[CM] cmmixlogit postestimation" "mansection CM cmmixlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmmixlogit" "help cmmixlogit"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{viewerjumpto "Postestimation commands" "cmmixlogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmmixlogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cmmixlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cmmixlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cmmixlogit postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[CM] cmmixlogit postestimation} {hline 2}}Postestimation tools for
cmmixlogit{p_end}
{p2col:}({mansection CM cmmixlogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:cmmixlogit}:

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
{synopt :{helpb cmmixlogit postestimation##margins:margins}}adjusted predictions, predictive margins, and marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cmmixlogit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
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

        {mansection CM cmmixlogitpostestimationMethodsandformulas:Methods and formulas}

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
{cmd:predict} omits missing values casewise if {cmd:cmmixlogit} 
used casewise deletion (the default); if {cmd:cmmixlogit} used
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
{opt pr}, the default, calculates the probability of choosing each alternative.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
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
{p2colreset}{...}

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
{phang2}{cmd:. webuse inschoice}{p_end}
{phang2}{cmd:. cmset id insurance}{p_end}
{phang2}{cmd:. cmmixlogit choice premium, random(deductible) intpoints(1000)}{p_end}

{pstd}Estimate the proportion of people who will select each insurance plan{p_end}
{phang2}{cmd:. margins}{p_end}

{pstd}Same as above, but account for an increase in premiums of 10% on
{cmd:HCorp}{p_end}
{phang2}{cmd:. margins, at(premium=generate(premium*1.10)) alternative(HCorp)}{p_end}
