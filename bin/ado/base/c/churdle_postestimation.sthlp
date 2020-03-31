{smcl}
{* *! version 1.0.6  21may2018}{...}
{viewerdialog predict "dialog churdle_p"}{...}
{vieweralsosee "[R] churdle postestimation" "mansection R churdlepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] churdle" "help churdle"}{...}
{viewerjumpto "Postestimation commands" "churdle postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "churdle_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "churdle postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "churdle postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "churdle postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] churdle postestimation} {hline 2}}Postestimation tools for churdle{p_end}
{p2col:}({mansection R churdlepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{cmd:churdle}:

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
INCLUDE help post_lrtest_star
{synopt:{helpb churdle_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
        effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb churdle postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R churdlepostestimationRemarksandexamples:Remarks and examples}

        {mansection R churdlepostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {opt e:quation(eqno)}]

{p 8 19 2}
{cmd:predict}
{dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist:newvarlist}}}
{ifin}{cmd:,} {cmdab:sc:ores}

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{cmdab:ys:tar}}conditional expectation of {it:depvar}; the default{p_end}
{synopt :{cmdab:r:esiduals}}residuals {p_end}
{synopt :{cmdab:ys:tar(}{it:a}{cmd:,}{it:b}{cmd:)}}E(y*), y*=max{{it:a},
min(y,{it:b})}{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt :{cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)}}Pr({it:a} < y < {it:b}){p_end}
{synopt :{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}}E(y | {it:a} < y < {it:b}){p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

INCLUDE help whereab
{p 6 6 2}For {cmd:churdle exponential}, {it:b} is {cmd:.} (missing).


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
conditional expectation of {depvar}, residuals, linear predictions, 
standard errors, and probabilities.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:ystar}, the default, calculates the conditional expectation of the
dependent variable.

{phang}
{cmd:residuals} calculates the residuals.

{phang}
{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} calculates E(y*).  {it:a} and
{it:b} are specified as they are for {cmd:pr()}.  If {it:a} and {it:b}
are equal to the lower and upper bounds specified in {cmd:churdle}, then
E(y*) is equivalent to the predicted value of the dependent variable
{cmd:ystar}.

{phang}
{cmd:xb} calculates the linear prediction.

{phang}
{cmd:stdp} calculates the standard error of the linear prediction. 

{phang}
{opt pr(a,b)} calculates {bind:Pr({it:a} < y < {it:b})}, the probability
that y|x would be observed in the interval ({it:a},{it:b}).

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names;
{it:lb} and {it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < y<30)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates 
{bind:Pr({it:lb} < y < {it:ub})}; and{break}
{cmd:pr(20,} {it:ub}{cmd:)} calculates {bind:Pr(20 < y < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} {cmd:.})} means {cmd:ll}; {cmd:pr(.,30)}
calculates {bind:Pr({it:ll} < y < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates {bind:Pr({it:ll} < y < 30)} in
observations for which {bind:{it:lb} {ul:>} {cmd:.}}{break} and calculates
{bind:Pr({it:lb} < y < 30)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} {cmd:.})} means plus infinity;
{cmd:pr(20,.)} calculates {bind:Pr(infinity > y > 20)};{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(infinity > y > 20)} in
observations for which {bind:{it:ub} {ul:>} {cmd:.}}{break}
and calculates {bind:Pr({it:ub} > y > 20)} elsewhere.{break}
For {cmd:churdle linear}, {it:ul} is infinity.

{phang}
{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:E(y | {it:a} < y < {it:b})},
the expected value of y|x conditional on y|x being
in the interval ({it:a},{it:b}), meaning that y|x is bounded.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{opt equation(eqno)} specifies the equation for which predictions
are to be made for the {cmd:xb} and {cmd:stdp} options. {cmd:equation()}
should contain either one equation name or one of {cmd:#1}, {cmd:#2},
... with {cmd:#1} meaning the first equation, {cmd:#2} meaning the
second equation, etc.

{pmore}
If you do not specify {cmd:equation()}, the results are the same as if
you specified {cmd:equation(# 1)}.

{phang}
{cmd:scores} calculates the equation-level score variables. If you
specify one new variable, the scores for the latent-variable equation are
computed. If you specify a variable list, the scores for each equation
are calculated. The following scores may be obtained:

{pmore}
the first new variable will contain 
partial ln L/partial(x beta),

{pmore}
the second new variable will contain 
partial ln L/partial(z gamma_{ll}),

{pmore}
the third new variable will contain 
partial ln L/partial(z gamma_{ul}),

{pmore}
the fourth new variable will contain 
partial ln L/partial(sigma),

{pmore}
the fifth new variable will contain 
partial ln L/partial(sigma_{ll}), and 

{pmore}
the sixth new variable will contain 
partial ln L/partial(sigma_{ul}).


INCLUDE help syntax_margins

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt ys:tar}}conditional expectation of {it:depvar}; the default{p_end}
{synopt :{cmdab:ys:tar(}{it:a}{cmd:,}{it:b}{cmd:)}}E(y*), y*=max{{it:a}, min(y,{it:b})}; for {cmd:churdle exponential} {it:b} is .{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)}}Pr({it:a} < y < {it:b}); for {cmd:churdle exponential} {it:b} is .{p_end}
{synopt :{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)}}E(y | {it:a} < y < {it:b}); for {cmd:churdle exponential} {it:b} is .{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
conditional expectations, linear predictions, and probabilities.


{marker examples}{...}
{title:Examples}

    Setup
{phang2}{cmd:. webuse fitness}{p_end}
{phang2}{cmd:. churdle linear hours age i.smoke distance i.single, select(commute whours) ll(0) het(age single) nolog}

{pstd}Fit conditional expectation the dependent variable {cmd:hours}{p_end}
{phang2}{cmd:. predict hourshat}

{pstd}Fit conditional expectation for values of the dependent variable
greater than zero{p_end}
{phang2}{cmd:. predict exercises, e(0,.)}{p_end}
{phang2}{cmd:. summarize hours hourshat exercises}{p_end}

{pstd}Average marginal effect of {cmd:single}{p_end}
{phang2}{cmd:. margins, dydx(1.single)}{p_end}
