{smcl}
{* *! version 1.3.5  19oct2017}{...}
{viewerdialog predict "dialog clogit_p"}{...}
{vieweralsosee "[R] clogit postestimation" "mansection R clogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{viewerjumpto "Postestimation commands" "clogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "clogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "clogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "clogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "clogit postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] clogit postestimation} {hline 2}}Postestimation tools for 
clogit{p_end}
{p2col:}({mansection R clogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after {cmd:clogit}:

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
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb clogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb clogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R clogitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R clogitpostestimationMethodsandformulas:Methods and formulas}

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

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pc1}}probability of a positive outcome; the default
{p_end}
{synopt :{opt pu0}}probability of a positive outcome, assuming
fixed effect is zero{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{p2coldent :* {opt db:eta}}Delta-b influence statistic{p_end}
{p2coldent :* {opt dx:2}}Delta chi-squared lack-of-fit statistic{p_end}
{p2coldent :* {opt gdb:eta}}Delta-b influence statistic for each group{p_end}
{p2coldent :* {opt gdx:2}}Delta chi-squared lack-of-fit statistic for each group{p_end}
{p2coldent :* {opt h:at}}Hosmer and Lemeshow leverage{p_end}
{p2coldent :* {opt r:esiduals}}Pearson residuals{p_end}
{p2coldent :* {opt rsta:ndard}}standardized Pearson residuals{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred

{p 4 6 2}Starred statistics are available for multiple controls per
case-matching design only. They are not available if {cmd:vce(robust)},
{cmd:vce(cluster} {it:clustvar}{cmd:)}, or {cmd:pweight}s were specified with
{cmd:clogit}.

{p 4 6 2}{opt dbeta}, {opt dx2}, {opt gdbeta}, {opt gdx2}, {opt hat}, and 
{opt rstandard} are not available if {opt constraints()} was specified with
{cmd:clogit}.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, standard errors,
influence statistics, lack-of-fit statistics, Hosmer and Lemeshow leverages,
Pearson residuals, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pc1}, the default, calculates the probability of a
positive outcome conditional on one positive outcome within group.

{phang}
{opt pu0} calculates the probability of a positive outcome, assuming that
the fixed effect is zero.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt dbeta} calculates the Delta-b influence statistic, a standardized measure
of the difference in the coefficient vector that is due to deletion of the
observation.

{phang}
{opt dx2} calculates the Delta chi-squared influence statistic, reflecting the
decrease in the Pearson chi-squared that is due to deletion of the observation.

{phang}
{opt gdbeta} calculates the approximation to the Pregibon stratum-specific
Delta-b influence statistic, a standardized measure of the difference in the
coefficient vector that is due to deletion of the entire stratum.

{phang}
{opt gdx2} calculates the approximation to the Pregibon stratum-specific Delta
chi-squared influence statistic, reflecting the decrease in the Pearson
chi-squared that is due to deletion of the entire stratum.

{phang}
{opt hat} calculates the Hosmer and Lemeshow leverage or the diagonal element
of the hat matrix.

{phang}
{opt residuals} calculates the Pearson residuals.

{phang}
{opt rstandard} calculates the standardized Pearson residuals.

{phang}
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {cmd:offset({varname})} for
{cmd:clogit}. It modifies the calculations made by {cmd:predict} so that they
ignore the offset variable; the linear prediction is treated as xb rather than
as xb + offset.  This option cannot be specified with {opt dbeta},
{opt dx2}, {opt gdbeta}, {opt gdx2}, {opt hat}, and {opt rstandard}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pu0}}probability of a positive outcome, assuming
fixed effect is zero; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt pc1}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt db:eta}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dx:2}}not allowed with {cmd:margins}{p_end}
{synopt :{opt gdb:eta}}not allowed with {cmd:margins}{p_end}
{synopt :{opt gdx:2}}not allowed with {cmd:margins}{p_end}
{synopt :{opt h:at}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rsta:ndard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
probabilities and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lowbirth2}{p_end}

{pstd}Fit conditional logistic regression{p_end}
{phang2}{cmd:. clogit low lwt smoke ptd ht ui i.race, group(pairid)}

{pstd}Test that the coefficient on {cmd:2.race} equals the coefficient on
{cmd:3.race}{p_end}
{phang2}{cmd:. test 2.race = 3.race}{p_end}

{pstd}Predict the probability of a positive outcome conditional on one
positive outcome within group{p_end}
{phang2}{cmd:. predict pc}{p_end}

{pstd}Predict Hosmer and Lemeshow leverage{p_end}
{phang2}{cmd:. predict hat, hat}{p_end}
