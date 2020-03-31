{smcl}
{* *! version 1.0.1  05feb2020}{...}
{viewerdialog "predict" "dialog xtheckman_p"}{...}
{vieweralsosee "[XT] xtheckman postestimation" "mansection XT xtheckmanpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtheckman" "help xtheckman"}{...}
{viewerjumpto "Postestimation commands" "xtheckman postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtheckman_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtheckman postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtheckman postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtheckman postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[XT] xtheckman postestimation} {hline 2}}Postestimation tools for
xtheckman{p_end}
{p2col:}({mansection XT xtheckmanpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}

{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtheckman}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb xtheckman_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtheckman postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtheckmanpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt nooff:set}]


{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist:newvarlist}}{c )-}
{ifin}{cmd:,} {opt sc:ores}


{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt pr(a,b)}}Pr(y {c |} {it:a} < y < {it:b}){p_end}
{synopt :{opt e(a,b)}}E(y {c |} {it:a} < y < {it:b}){p_end}
{synopt :{opt ys:tar(a,b)}}E(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-}{p_end}
{synopt :{opt yc:ond}}E(y | y observed){p_end}
{synopt :{opt ps:el}}Pr(y observed){p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

{phang}
where {it:a} and {it:b} may be numbers or variables; {it:a} missing
({it:a} {ul:>} {cmd:.}) means -infinity, and {it:b} missing
({it:b} {ul:>} {cmd:.}) means +infinity; see {help missing}.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{opt predict} creates a new variable containing predictions such as
linear predictions, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt xbsel} calculates the linear prediction for the selection equation.

{phang}
{opt pr(a,b)} calculates
Pr({it:a} < xb + u + epsilon < {it:b}),
the probability that
y|x would be observed in the interval ({it:a},{it:b}).

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names;
{it:lb} and {it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < xb + u + epsilon < 30)};{break}
{opt pr(lb,ub)} calculates {bind:Pr({it:lb} < xb + u + epsilon < {it:ub})};
and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(20 < xb + u + epsilon < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} {cmd:.})} means -infinity;
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < xb + u + epsilon < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates
{bind:Pr(-infinity < xb + u + epsilon < 30)} in
observations for which {bind:{it:lb} {ul:>} {cmd:.}}{break}
and calculates {bind:Pr({it:lb} < xb + u + epsilon < 30)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} {cmd:.})} means +infinity;
{cmd:pr(20,.)} calculates {bind:Pr(+infinity > xb + u + epsilon > 20)};{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates
{bind:Pr(+infinity > xb + u + epsilon > 20)} in
observations for which {bind:{it:ub} {ul:>} {cmd:.}}{break}
and calculates {bind:Pr(20 < xb + u + epsilon < {it:ub})} elsewhere.

{phang}
{opt e(a,b)} calculates
{bind:E(xb + u + epsilon | {it:a} < xb + u + epsilon < {it:b})},
the expected value of y {c |} x conditional on y {c |} x being
in the interval ({it:a},{it:b}), meaning that y {c |} x is truncated.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{opt ystar(a,b)} calculates {bind:E(y*)}, where {bind:y* = {it:a}} if
{bind:xb + u + epsilon {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb + u + epsilon {ul:>} {it:b}}, and {bind:y* = xb + u + epsilon}
otherwise, meaning that y* is not selected.  {it:a} and {it:b} are specified
as they are for {opt pr()}.

{phang}
{opt ycond} calculates the expected value of the dependent variable conditional
    on the dependent variable being observed, that is, selected;
    {bind:E(y | y observed)}.

{phang}
{opt psel} calculates the probability of selection (or being observed).

{phang}
{opt nooffset} is relevant when you specify {opth offset(varname)}
for {opt xtheckman}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as
xb rather than as xb + offset.

{phang}
{opt scores} calculates parameter-level score variables.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt pr(a,b)}}Pr(y {c |} {it:a} < y < {it:b}){p_end}
{synopt :{opt e(a,b)}}E(y {c |} {it:a} < y < {it:b}){p_end}
{synopt :{opt ys:tar(a,b)}}E(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-}{p_end}
{synopt :{opt yc:ond}}E(y {c |} y observed){p_end}
{synopt :{opt ps:el}}Pr(y observed){p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions,
probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wagework}{p_end}
{phang2}{cmd:. xtset personid year}{p_end}
{phang2}{cmd:. xtheckman wage c.age##c.age tenure, select(working = c.age##c.age market)}{p_end}

{pstd}Estimate the expected wages for individuals between ages 30 and 70 and
with 0 and 5 years of job tenure{p_end}
{phang2}{cmd:. margins, at(age=(30(5)70) tenure=(0 5))}{p_end}

{pstd}Graph the results{p_end}
{phang2}{cmd:. marginsplot}{p_end}
