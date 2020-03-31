{smcl}
{* *! version 1.0.5  04jun2018}{...}
{viewerdialog predict "dialog fracreg_p"}{...}
{vieweralsosee "[R] fracreg postestimation" "mansection R fracregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fracreg" "help fracreg"}{...}
{viewerjumpto "Postestimation commands" "fracreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "fracreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "fracreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "fracreg postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "fracreg postestimation##example"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] fracreg postestimation} {hline 2}}Postestimation tools for fracreg{p_end}
{p2col:}({mansection R fracregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt fracreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
{synopt:{helpb fracreg_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
        effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb fracreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} and {cmd:hausman} are not appropriate with {cmd:svy}
estimation results.  {cmd:forecast} is also not appropriate with {cmd:mi}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R fracregpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 19 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar}} {c |} {it:{help newvarlist}}{c )-}
{ifin}{cmd:,} {opt sc:ores}


{marker statistic}{...}
{synoptset 15 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt cm}}conditional mean; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt s:igma}}standard deviation of the error term (for {cmd:het()}){p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ores}}equation-level score variables{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
conditional means, linear predictions, standard errors, and
equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:cm}, the default, calculates the conditional mean of the outcome.

{phang}
{cmd:xb} calculates the linear prediction.

{phang}
{cmd:sigma} calculates the standard deviation of the error term. It is
available only when {cmd:het()} is specified.

{phang}
{cmd:stdp} calculates the standard error of the linear prediction.

{phang}
{cmd:scores} calculates the equation-level score, partial ln
L/partial(xb), in the case of {cmd:fracreg probit} and
{cmd:fracreg logit}, and can also calculate partial ln L/partial(z
gamma) if the option {cmd:het()} is specified.

{phang}
{cmd:nooffset} is relevant only if you specified {opth offset(varname)}.
It modifies the calculations made by {cmd:predict} so that they ignore
the offset variable; the linear prediction is treated as xb rather than as
xb + offset.


INCLUDE help syntax_margins

{synoptset 14}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt cm}}conditional mean; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt s:igma}}standard deviation of the error term (for {cmd:het()}){p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for conditional means and
linear predictions.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse 401k}

{pstd}
Use fractional probit regression to obtain consistent estimates of the
parameters of the conditional mean{p_end}
{phang2}{cmd:. fracreg probit prate mrate c.ltotemp##c.ltotemp c.age##c.age i.sole}

{pstd}
Obtain the predicted conditional means
{p_end}
{phang2}{cmd:. predict mpart}
{p_end}
