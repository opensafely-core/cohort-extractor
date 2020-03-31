{smcl}
{* *! version 1.1.6  05sep2018}{...}
{viewerdialog predict "dialog etpoisson_p"}{...}
{vieweralsosee "[TE] etpoisson postestimation" "mansection TE etpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etpoisson" "help etpoisson"}{...}
{viewerjumpto "Postestimation commands" "etpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "etpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "etpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "etpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "etpoisson postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[TE] etpoisson postestimation} {hline 2}}Postestimation tools for
etpoisson{p_end}
{p2col:}({mansection TE etpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{cmd:etpoisson}:

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
{synopt:{helpb etpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb etpoisson postestimation##predict:predict}}predictions,
  probabilities, and treatment effects{p_end}
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

        {mansection TE etpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection TE etpoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
{it:{help newvar:newvar_treat}}
{it:{help newvar:newvar_athrho}}
{it:{help newvar:newvar_lnsigma}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 15 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pom:ean}}potential-outcome mean (the predicted count); the default{p_end}
{synopt :{opt om:ean}}observed-outcome mean (the predicted count){p_end}
{synopt :{opt cte}}conditional treatment effect at treatment level{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbt:reat}}linear prediction for treatment equation{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
counts, conditional treatment effects, probabilities, and linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pomean}, the default, calculates the potential-outcome mean.

{phang}
{opt omean} calculates the observed-outcome mean.

{phang}
{opt cte} calculates the treatment effect, the difference of potential-outcome
means, conditioned on treatment level.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt xb} calculates the linear prediction for the dependent count variable,
which is xb if neither {cmd:offset()} nor {cmd:exposure()} was specified;
xb + offset if {cmd:offset()} was specified; or
xb + ln(exposure) if {cmd:exposure()} was specified.

{phang}
{opt xbtreat} calculates the linear prediction
for the endogenous treatment equation, which is wa
if {cmd:offset()} was not specified in {cmd:treat()} and
wa + offset if {cmd:offset()} was specified in {cmd:treat()}.

{marker nooffset}{...}
{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the
calculations made by {cmd:predict} so that they ignore the offset or exposure
variable.  {opt nooffset} removes the offset from calculations involving both
 the {cmd:treat()} equation and the dependent count variable.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the treatment equation.

{pmore}
The third new variable will contain the derivative of the log likelihood with
respect to the third equation ({hi:athrho}).

{pmore}
The fourth new variable will contain the derivative of the log likelihood with
respect to the fourth equation ({hi:lnsigma}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pom:ean}}potential-outcome mean (the predicted count); the default{p_end}
{synopt :{opt om:ean}}observed-outcome mean (the predicted count){p_end}
{synopt :{opt cte}}conditional treatment effect at treatment level{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbt:reat}}linear prediction for treatment equation{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for 
counts, conditional treatment effects, probabilities, and 
linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse trip1}{p_end}

{pstd}Fit a Poisson regression with endogenous treatment{p_end}
{phang2}{cmd:. etpoisson trips cbd ptn worker weekend,}
{cmd:  treat(owncar = cbd ptn worker realinc) vce(robust)}{p_end}

{phang}Estimate average treatment effect{p_end}
{phang2}{cmd:. margins r.owncar, vce(unconditional)}{p_end}

{phang}Estimate average treatment effect on the treated{p_end}
{phang2}{cmd:. margins, predict(cte) vce(unconditional) subpop(owncar)}{p_end}

{phang}Estimate number of events{p_end}
{phang2}{cmd:. predict num, omean}{p_end}
