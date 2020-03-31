{smcl}
{* *! version 1.2.6  29may2018}{...}
{viewerdialog predict "dialog rologit_p"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rologit" "help rologit"}{...}
{viewerjumpto "Postestimation commands" "rologit postestimation##description"}{...}
{viewerjumpto "predict" "rologit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "rologit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "rologit postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] rologit postestimation} {hline 2}}Postestimation tools for
rologit{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rrologitpostestimation.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:rologit} has been renamed to {helpb cmrologit}.  {cmd:rologit}
continues to work but, as of Stata 16, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:rologit}:

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
{synopt:{helpb rologit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb rologit postestimation##predict:predict}}predictions, 
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 18 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt nooff:set}]

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt p:r}}probability that alternatives are ranked first; the
default{p_end}
{synopt :{opt xb}}linear predictor{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
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
{opt pr}, the default, calculates the probability that alternatives are ranked
first.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:rologit}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than as xb + offset.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear predictor; the default{p_end}
{synopt :{opt p:r}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
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

    {hline}
    Setup
{phang2}{cmd:. webuse rologitxmpl}{p_end}
{phang2}{cmd:. rologit pref edufit grades workexp}
            {cmd:c.firmsize#c.(edufit grades workexp boardexp) if job==1,}
            {cmd:group(caseid)}{p_end}

{pstd}Test that coefficients on interacted {cmd:firmsize} variables
are all 0{p_end}
{phang2}{cmd:. testparm c.firmsize#c.(edufit grades workexp boardexp)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse evignet}{p_end}
{phang2}{cmd:. rologit pref age female edufit grades workexp boardexp if}
                 {cmd:job==1, group(caseid)}{p_end}

{pstd}Store estimates for later use{p_end}
{phang2}{cmd:. estimates store Ranking}{p_end}

{pstd}{cmd:best} contains 1 for best alternatives, 0 otherwise{p_end}
{phang2}{cmd:. by caseid (pref), sort: gen best = pref == pref[_N] if job==1}
{p_end}

{pstd}Confirm there are no ties{p_end}
{phang2}{cmd:. by caseid (pref), sort: assert pref[_N-1] != pref[_N] if job==1}
{p_end}

{phang2}{cmd:. rologit best age edufit grades workexp boardexp if job==1,}
                 {cmd:group(caseid)}{p_end}

{pstd}Test for misspecification{p_end}
{phang2}{cmd:. hausman Ranking .}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse evignet, clear}{p_end}
{phang2}{cmd:. rologit pref grades edufit workexp boardexp if job==1 &}
                 {cmd:pref!=0, group(caseid)}{p_end}

{pstd}Store estimates for later use{p_end}
{phang2}{cmd:. estimates store Original}{p_end}

{pstd}Reverse the preference order{p_end}
{phang2}{cmd:. rologit pref grades edufit workexp boardexp if job==1 &}
                  {cmd:pref!=0, group(caseid) reverse}{p_end}

{pstd}Store estimates for later use{p_end}
{phang2}{cmd:. estimates store Reversed}{p_end}

{pstd}Display table of estimation results for both models{p_end}
{phang2}{cmd:. estimates table Original Reversed, stats(aic bic)}{p_end}
    {hline}
