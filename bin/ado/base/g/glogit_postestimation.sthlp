{smcl}
{* *! version 1.3.0  25sep2014}{...}
{viewerdialog predict "dialog glogit_p"}{...}
{vieweralsosee "[R] glogit" "help glogit"}{...}
{viewerjumpto "Description" "glogit postestimation##description"}{...}
{viewerjumpto "Syntax for predict" "glogit postestimation##syntax_predict"}{...}
{viewerjumpto "Menu for predict" "glogit postestimation##menu_predict"}{...}
{viewerjumpto "Options for predict" "glogit postestimation##options_predict"}{...}
{viewerjumpto "Syntax for margins" "glogit postestimation##syntax_margins"}{...}
{viewerjumpto "Menu for margins" "glogit postestimation##menu_margins"}{...}
{viewerjumpto "Examples" "glogit postestimation##examples"}{...}
{pstd}
{cmd:blogit}, {cmd:bprobit}, {cmd:glogit}, and {cmd:gprobit} continue to work
but, as of Stata 14, are no longer an official part of Stata.  This is the
original help file, which we will no longer update, so some links may no
longer work.

{pstd}
See {helpb glm postestimation} for a recommended alternative.

{hline}

{title:Title}

{p2colset 5 34 36 2}{...}
{p2col :{hi:[R] glogit postestimation} {hline 2}}Postestimation tools for
glogit, gprobit, blogit, and bprobit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are available after {cmd:glogit},
{cmd:gprobit}, {cmd:blogit}, and {cmd:bprobit}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent :* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{p2coldent :* {helpb lrtest}}likelihood-ratio test{p_end}
{synopt:{helpb glogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb glogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt estat ic} and {opt lrtest} are not appropriate after {opt glogit} and
{opt gprobit}.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt n}}predicted count; the default{p_end}
{synopt :{opt p:r}}probability of a positive outcome{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the expected count, that is, the
estimated probability times {it:pop_var}, which is the total population.

{phang}
{opt pr} calculates the predicted probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}predicted count; the default{p_end}
{synopt :{opt p:r}}probability of a positive outcome{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse xmpl2}{p_end}
{phang2}{cmd:. bprobit deaths pop agecat exposed}{p_end}

{pstd}Expected number of deaths{p_end}
{phang2}{cmd:. predict number}{p_end}

{pstd}Probability of death{p_end}
{phang2}{cmd:. predict p if e(sample), pr}{p_end}
