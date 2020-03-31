{smcl}
{* *! version 1.2.6  31may2018}{...}
{viewerdialog predict "dialog treatr_p"}{...}
{vieweralsosee "[TE] etregress postestimation" "mansection TE etregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etregress" "help etregress"}{...}
{viewerjumpto "Postestimation commands" "etregress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "etregress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "etregress postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "etregress postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "etregress postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[TE] etregress postestimation} {hline 2}}Postestimation
tools for etregress{p_end}
{p2col:}({mansection TE etregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt etregress}:

{synoptset 17 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent:* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb etregress_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb etregress postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{p2coldent:* {helpb suest}}seemingly unrelated estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p 4 6 2}
* {cmd:estat ic}, {cmd:lrtest}, and {cmd:suest} are not appropriate after
      {cmd:etregress, twostep} or {cmd:etregress, cfunction}.
      {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
      estimation results.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE etregresspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{pstd}
After ML, twostep, or cfunction

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}]

{pstd}
After ML or cfunction for constrained model

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
    {it:{help newvar:newvar_treat}} {it:{help newvar:newvar_athrho}}
    {it:{help newvar:newvar_lnsigma}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{pstd}
After ML or cfunction for general potential-outcome model

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
    {it:{help newvar:newvar_treat}} {it:{help newvar:newvar_athrho0}}
    {it:{help newvar:newvar_lnsigma0}}
    {it:{help newvar:newvar_athrho1}}
    {it:{help newvar:newvar_lnsigma1}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}


{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt cte}}conditional treatment effect at treatment level{p_end}
{synopt:{opt stdp}}standard error of the prediction{p_end}
{synopt:{opt stdf}}standard error of the forecast{p_end}
{synopt:{opt yct:rt}}{it:E}(y | treatment = 1){p_end}
{synopt:{opt ycnt:rt}}{it:E}(y | treatment = 0){p_end}
{synopt:{opt pt:rt}}Pr(treatment = 1){p_end}
{synopt:{opt xbt:rt}}linear prediction for treatment equation{p_end}
{synopt:{opt stdpt:rt}}standard error of the linear prediction for treatment
equation{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.
{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions, conditional treatment effects, standard errors,
expected values, and probabilities. 


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear predictions, xb.

{phang}
{opt cte} calculates the treatment effect, the difference of potential-outcome
means, conditioned on treatment level.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
   thought of as the standard error of the predicted expected value or mean
   for the observation's covariate pattern.  The standard error of the
   prediction is also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
   standard error of the point prediction for one observation.  It is
   commonly referred to as the standard error of the future or forecast value.
   By construction, the standard errors produced by {opt stdf} are always
   larger than those produced by {opt stdp}; see
   {it:{mansection R regressMethodsandformulas:Methods and formulas}} in
   {hi:[R] regress}.

{phang}
{opt yctrt} calculates the expected value of the dependent variable
   conditional on the presence of the treatment: {it:E}(y | treatment=1).

{phang}
{opt ycntrt} calculates the expected value of the dependent variable
   conditional on the absence of the treatment: {it:E}(y | treatment=0).

{phang}
{opt ptrt} calculates the probability of the presence of the treatment:
   Pr(treatment=1) = Pr(w_j*g + u_j > 0).

{phang}
{opt xbtrt} calculates the linear prediction for the treatment equation.

{phang}
{opt stdptrt} calculates the standard error of the linear prediction for the
   treatment equation.

{phang}
{opt scores}, not available with {opt twostep}, calculates equation-level
score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the treatment equation.

{pmore}
Under the constrained model, the third new variable will contain
the derivative of the log likelihood with respect to the third equation
({hi:athrho}).

{pmore}
Under the constrained model, the fourth new variable will contain the
derivative of the log likelihood with respect to the fourth equation
({hi:lnsigma}).

{pmore}
Under the general potential-outcome model, the third new variable will contain
the derivative of the log likelihood with respect to the third equation
({hi:athrho0}).

{pmore}
Under the general potential-outcome model, the fourth new variable will contain
the derivative of the log likelihood with respect to the fourth equation
({hi:lnsigma0}).

{pmore}
Under the general potential-outcome model, the fifth new variable will contain
the derivative of the log likelihood with respect to the third equation
({hi:athrho1}).

{pmore}
Under the general potential-outcome model, the sixth new variable will contain
the derivative of the log likelihood with respect to the fourth equation
({hi:lnsigma1}).


INCLUDE help syntax_margins

{pstd}
Maximum likelihood and control-function estimation results

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt cte}}conditional treatment effect at treatment level{p_end}
{synopt:{opt yct:rt}}{it:E}(y | treatment = 1){p_end}
{synopt:{opt ycnt:rt}}{it:E}(y | treatment = 0){p_end}
{synopt:{opt pt:rt}}Pr(treatment = 1){p_end}
{synopt:{opt xbt:rt}}linear prediction for treatment equation{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdpt:rt}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
Two-step estimation results

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt pt:rt}}Pr(treatment = 1){p_end}
{synopt:{opt xbt:rt}}linear prediction for treatment equation{p_end}
{synopt :{opt cte}}not allowed with {cmd:margins}{p_end}
{synopt :{opt yct:rt}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ycnt:rt}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdpt:rt}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions,
conditional treatment effects, expected values, and probabilities. 


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse union3}{p_end}
{phang2}{cmd:. etregress wage age grade smsa i.union#c.(black tenure),}
           {cmd:treat(union = south black tenure) vce(robust) vsquish}
	   {cmd:nolstretch}

{pstd}Estimate average treatment effect{p_end}
{phang2}{cmd:. margins r.union, vce(unconditional) contrast(nowald)}

{pstd}Estimate average treatment effect on the treated{p_end}
{phang2}{cmd:. margins r.union, vce(unconditional) contrast(nowald)}
          {cmd:subpop(union)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse drugexp}{p_end}
{p 8 12 2}{cmd:. etregress lndrug chron age lninc, }
{cmd:treat(ins=age married lninc work) poutcomes cfunction}

{pstd}Estimate average treatment effect on the treated{p_end}
{phang2}{cmd:. margins, predict(cte) subpop(ins) vce(unconditional)}

    {hline}
