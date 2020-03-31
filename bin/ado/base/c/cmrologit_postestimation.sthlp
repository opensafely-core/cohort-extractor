{smcl}
{* *! version 1.0.1  10feb2020}{...}
{viewerdialog predict "dialog cmrologit_p"}{...}
{vieweralsosee "[CM] cmrologit postestimation" "mansection CM cmrologitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmrologit" "help cmrologit"}{...}
{viewerjumpto "Postestimation commands" "cmrologit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmrologit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cmrologit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cmrologit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cmrologit postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[CM] cmrologit postestimation} {hline 2}}Postestimation tools for
cmrologit{p_end}
{p2col:}({mansection CM cmrologitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:cmrologit}:

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
INCLUDE help post_linktest
INCLUDE help post_lrtest
{synopt :{helpb cmrologit postestimation##margins:margins}}adjusted predictions, predictive margins, and marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cmrologit postestimation##predict:predict}}predicted probabilities, estimated linear predictor and its standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmrologitpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {it:statistic}
{opt nooff:set}]

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability that alternatives are ranked first; the
default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
INCLUDE help esample
{p 4 6 2}
{cmd:predict} omits missing values casewise if {cmd:cmrologit} 
used casewise deletion (the default); if {cmd:cmrologit} used
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
{opt pr}, the default, calculates the probability that alternatives
are ranked first.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt cmrologit}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than as xb + offset.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}

{pstd}
Statistics not allowed with {cmd:margins} are functions of stochastic 
quantities other than {cmd:e(b)}.

{pstd}
Because {cmd:cmrologit} does not explicitly identify alternatives (that is,
there is no alternatives variable), the alternative-specific features of
{manhelp margins CM} do not apply to {cmd:cmrologit}.  See {manhelp margins R}
for the full syntax of {cmd:margins} available after {cmd:cmrologit}.


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{opt margins} estimates margins of response for linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse evignet}{p_end}
{phang2}{cmd:. cmset caseid, noalternatives}{p_end}

{pstd}Fit rank-ordered logit choice model{p_end}
{phang2}{cmd:. cmrologit pref i.female age i.grades i.edufit i.workexp i.boardexp if job==1}

{pstd}Calculate the probabilities for alternatives to be ranked first{p_end}
{phang2}{cmd:. predict p if e(sample)}

{pstd}Refit the model but for clustered choice data{p_end}
{phang2}{cmd:. cmrologit pref job##(i.female i.grades i.edufit i.workexp), vce(cluster employer)}

{pstd}Perform a Wald test for the equality hypothesis of no difference{p_end}
{phang2}{cmd:. testparm job#(i.female i.grades i.edufit i.workexp)}{p_end}
