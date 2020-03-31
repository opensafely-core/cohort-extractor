{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog predict "dialog xtgee_p"}{...}
{viewerdialog estat "dialog xtgee_estat"}{...}
{vieweralsosee "[XT] xtgee postestimation" "mansection XT xtgeepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{viewerjumpto "Postestimation commands" "xtgee postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtgee_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtgee postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtgee postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "xtgee postestimation##syntax_estat_wcorr"}{...}
{viewerjumpto "Examples" "xtgee postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[XT] xtgee postestimation} {hline 2}}Postestimation tools for xtgee{p_end}
{p2col:}({mansection XT xtgeepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after {cmd:xtgee}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtgee postestimation##estatwcor:estat wcorrelation}}estimated matrix of the within-group correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb xtgee_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtgee postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtgeepostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:statistic} {opt nooff:set}]

{synoptset 18 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}predicted value of {depvar}; considers the {opt offset()} or {opt exposure()}; the default{p_end}
{synopt :{opt r:ate}}predicted value of {depvar}{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n) for {cmd:family(poisson)}
 {cmd:link(log)}{p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b) for
 {cmd:family(poisson)} {cmd:link(log)}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
predicted values, probabilities, linear predictions, standard errors,
and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt mu}, the default, and {opt rate} calculate the predicted value of
{depvar}.  {opt mu} takes into account the {opt offset()} or {opt exposure()}
together with the denominator if the family is binomial; {opt rate} ignores
those adjustments.  {opt mu} and {opt rate} are equivalent if you did not
specify the {opt offset()} or {opt exposure()} when you fit the {cmd:xtgee}
model and you did not specify {cmd:family(binomial} {it:#}{cmd:)} or
{cmd:family(binomial} {varname}{cmd:)}, meaning the binomial family and a
denominator not equal to one.

{pmore}
Thus {opt mu} and {opt rate} are the same for {cmd:family(gaussian)}
{cmd:link(identity)}.

{pmore}
{opt mu} and {opt rate} are not equivalent for {cmd:family(binomial pop)}
{cmd:link(logit)}.  Then {opt mu} would predict the number of positive outcomes
and {opt rate} would predict the probability of a positive outcome.

{pmore}
{opt mu} and {opt rate} are not equivalent for {cmd:family(poisson)}
{cmd:link(log)} {cmd:exposure(time)}.  Then {opt mu} would predict the number
of events given exposure time and {opt rate} would calculate the incidence rate
-- the number of events given an exposure time of 1.

{phang}
{opt pr(n)} calculates the probability Pr(y = n) for {cmd:family(poisson)}
{cmd:link(log)}, where n is a nonnegative integer that may be specified as a
number or a variable.

{phang}
{opt pr(a,b)} calculates the probability
Pr(a {ul:<} y {ul:<} b) for {cmd:family(poisson)} {cmd:link(log)},
where a and b are nonnegative integers that may be specified as numbers or
variables;

{pmore}
b missing {bind:(b {ul:>} .)} means plus infinity;{break}
{cmd:pr(20,.)}
calculates {bind:Pr(y {ul:>} 20)}; {break}
{cmd:pr(20,}{it:b}{cmd:)} calculates {bind:Pr(y {ul:>} 20)} in
observations for which {bind:b {ul:>} .}{break}
and calculates {bind:Pr(20 {ul:<} y {ul:<} b)} elsewhere.

{pmore}
{cmd:pr(.,}{it:b}{cmd:)} produces a syntax error.  A missing value in an
observation of the variable {it:a} causes a missing value in that
observation for {opt pr(a,b)}.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)},
{opt exposure(varname)}, {cmd:family(binomial} {it:#}{cmd:)}, or
{cmd:family(binomial} {it:varname}{cmd:)} when you fit the model.  It modifies
the calculations made by predict so that they ignore the offset or exposure
variable and the binomial denominator.  Thus {cmd:predict} {it:...}{cmd:,}
{cmd:mu nooffset} produces the same results as
{cmd:predict} {it:...}{cmd:, rate}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}predicted value of {depvar}; considers the {opt offset()} or {opt exposure()}; the default{p_end}
{synopt :{opt r:ate}}predicted value of {depvar}{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n) for {cmd:family(poisson)}
 {cmd:link(log)}{p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b) for
 {cmd:family(poisson)} {cmd:link(log)}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for predicted values,
probabilities, and linear predictions.


{marker syntax_estat_wcorr}{...}
{marker estatwcor}{...}
{title:Syntax for estat}

{p 8 16 2}{cmd:estat} {opt wcor:relation} [{cmd:,} {opt c:ompact}
             {opth f:ormat(%fmt)}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat wcorrelation} displays the estimated matrix of the within-group
correlations.


{marker options_estat_wcorr}{...}
{title:Options for estat}

{phang}
{opt compact} specifies that only the parameters (alpha) of the
estimated matrix of within-group correlations be displayed rather than the
entire matrix.

{phang}
{opt format(%fmt)} overrides the display format; see {manhelp format D}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse nlswork2}{p_end}

{pstd}Estimate random-effects linear regression{p_end}
{phang2}{cmd:. xtgee ln_w grade age c.age#c.age, corr(exchangeable)}{p_end}

{pstd}Examine the working correlation matrix after {cmd:xtgee}{p_end}
{phang2}{cmd:. estat wcorrelation}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse ships}

{pstd}Fit a Poisson model{p_end}
{phang2}{cmd:. xtgee accident op_75_79 co_65_69 co_70_74 co_75_79,}
    {cmd:family(poisson) link(log) corr(exchangeable) exposure(service)}{p_end}

{pstd}Predict the number of events give the exposure time of each
subject{p_end}
{phang2}{cmd:. predict nevents, mu}

{pstd}Predict the incidence rate, or number of events for an exposure time of
1{p_end}
{phang2}{cmd:. predict incrate, rate}{p_end}
    {hline}
