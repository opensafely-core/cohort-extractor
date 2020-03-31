{smcl}
{* *! version 1.2.6  21may2018}{...}
{viewerdialog predict "dialog nl_p"}{...}
{vieweralsosee "[R] nl postestimation" "mansection R nlpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{viewerjumpto "Postestimation commands" "nl postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "nl_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "nl postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "nl postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "nl postestimation##examples"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[R] nl postestimation} {hline 2}}Postestimation tools for nl{p_end}
{p2col:}({mansection R nlpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:nl}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{p2coldent:+ {helpb nl_postestimation##margins:margins}}marginal means,
		predictive margins, marginal
                effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb nl postestimation##predict:predict}}predictions and residuals{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are  not appropriate with
{cmd:svy} estimation results.{p_end}
{p 4 6 2}
+ You must specify the {cmd:variables()} option with {cmd:nl}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nlpostestimationRemarksandexamples:Remarks and examples}

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
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_1}} ... {it:{help newvar:newvar_k}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{phang}
where k is the number of parameters in the model.

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt y:hat}}fitted values; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt pr(a,b)}}Pr(y | {it:a} < y < {it:b}){p_end}
{synopt :{opt e(a,b)}}{it:E}(y | {it:a} < y < {it:b}){p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{cmd:(}{it:a},min(y,{it:b}{cmd:))}{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
fitted values, residuals, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt yhat}, the default, calculates the fitted value.

{phang}
{opt residuals} calculates the residuals.


INCLUDE help pr_opt

{phang}
{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:{it:E}(y | {it:a} < y < {it:b})}, the expected value of y|x 
conditional
on y|x being in the interval ({it:a},{it:b}), meaning that y|x is 
truncated.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} calculates {it:E}(y*),
where {bind:y* = {it:a}} if {bind:y {ul:<} {it:a}}, 
{bind:y* = {it:b}} if
{bind:y {ul:>} {it:b}}, and {bind:y* = y} otherwise, meaning that y* is
censored.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{opt scores} calculates the scores.  The {it:j}th new variable created 
will contain the score for the {it:j}th parameter in e(b).


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt y:hat}}fitted values; the default{p_end}
{synopt :{opt pr(a,b)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt e(a,b)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ys:tar(a,b)}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
fitted values.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. nl (mpg = {b0} + {b1} / turn)}{p_end}

{pstd}Calculate predicted value of {cmd:mpg}{p_end}
{phang2}{cmd:. predict mpghat}{p_end}

{pstd}Calculate residuals{p_end}
{phang2}{cmd:. predict mpgerr, residuals}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. nl (mpg = {c -(}b0{c )-} +}
       {cmd:{c -(}b1{c )-}*weight^{c -(}gamma=-0.5{c )-}), variables(weight)}
{p_end}

{pstd}Obtain elasticity of {cmd:weight} with respect to {cmd:mpg}{p_end}
{phang2}{cmd:. margins, eyex(weight)}{p_end}

    {hline}
