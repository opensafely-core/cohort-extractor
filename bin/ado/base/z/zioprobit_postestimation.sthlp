{smcl}
{* *! version 1.0.4  04jun2018}{...}
{viewerdialog predict "dialog zioprobit_p"}{...}
{vieweralsosee "[R] zioprobit postestimation" "mansection R zioprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] zioprobit" "help zioprobit"}{...}
{viewerjumpto "Postestimation commands" "zioprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "zioprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "zioprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "zioprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "zioprobit postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] zioprobit postestimation} {hline 2}}Postestimation tools
for zioprobit{p_end}
{p2col:}({mansection R zioprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt zioprobit}:

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
{synopt:{helpb zioprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb zioprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R zioprobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R zioprobitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,}
{it:statistic}
{opt o:utcome(outcome)}
{opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}}_reg {it:newvar}_infl {it:newvar}_0
... {it:newvar}_(H-1){c )-}
{ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pm:argin}}marginal probabilities of levels, Pr(y = h); the default{p_end}
{synopt :{opt pjoint1}}joint probabilities of levels and participation, Pr(y = h, s = 1){p_end}
{synopt :{opt pcond1}}probabilities of levels conditional on participation, Pr(y = h, s = 1){p_end}
{synopt :{opt ppar}}probability of participation, Pr(s = 1){p_end}
{synopt :{opt pnpar}}probability of nonparticipation, Pr(s = 0){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbinfl}}linear prediction for inflation equation{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt stdpinfl}}standard error of the linear prediction for inflation equation{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pmargin} (with one new variable
specified) assumes {cmd:outcome(#1)}.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pmargin}, {cmd:pjoint1}, and
{cmd:pcond1}, where {it:k} is the number of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:ppar}, {cmd:pnpar}, {cmd:xb},
{cmd:xbinfl}, {cmd:stdp}, and {cmd:stdpinfl}.{p_end}
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
{opt pmargin}, the default, calculates the predicted marginal probabilities,
Pr(y=h).

{phang}
{opt pjoint1} calculates the predicted joint probabilities of outcome levels
and participation, Pr(y=h, s=1).

{phang}
{opt pcond1} calculates the predicted probabilities of outcome levels
conditional on participation, Pr(y=h|s=1).

{pmore}
With {opt pmargin}, {opt pjoint1}, and {opt pcond1}, you can compute
predicted probabilities for one or for all outcome levels. When you specify one
new variable, {opt predict} computes probabilities for the first outcome level.
You can specify the {cmd:outcome(#}{it:k}{cmd:)} option to obtain
probabilities for the {it:k}th level. When you specify multiple new variables
or a stub, {opt predict} computes probabilities for all outcome levels. The
behavior of {opt predict} with one new variable is equivalent to specifying
{cmd:outcome(#1)}.
 
{phang} {opt ppar} calculates the predicted marginal probability of
participation, Pr(s=1).

{phang}
{opt pnpar} calculates the predicted marginal probability of nonparticipation,
Pr(s=0).

{phang}
{opt xb} calculates the linear prediction for the regression equation,
 which is xb if {opt offset()} was not specified with {cmd:zioprobit} and
is xb + offset^b if {cmd:offset()} was specified.

{phang}
{opt xbinfl} calculates the linear prediction for the inflation equation, which
is z(gamma) if {opt offset()} was not specified in {opt inflate()}
and is z(gamma) + offset^(gamma) if {opt offset()} was
specified in {opt inflate()}.

{phang}
{opt stdp} calculates the standard error of the linear prediction for the
regression equation.

{phang}
{opt stdpinfl} calculates the standard error of the linear prediction for the
inflation equation.

{phang}
{opt outcome(outcome)} specifies the outcome for which predicted
probabilities are to be calculated.  {opt outcome()} should contain either one
value of the dependent variable or one of {cmd:#1}, {cmd:#2}, ..., with
{cmd:#1} meaning the first category of the dependent variable, {cmd:#2} meaning
the second category, etc.  {cmd:outcome()} is allowed only with {cmd:pmargin},
{cmd:pjoint1}, and {cmd:pcond1}.
 
{marker nooffset}{...}
{phang}
{opt nooffset} is relevant only if you specified
{opth offset(varname)} with {opt zioprobit} or within the {opt inflate()}
option.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable; for example, the linear prediction for the
regression equation is treated as xb rather than as xb + offset^b.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable, {it:{help newvar}}_reg, will contain 
the derivative of the log likelihood with respect to the regression equation.

{pmore}
The second new variable, {it:{help newvar}}_infl, will contain
the derivative of the log likelihood with respect to the inflation equation.

{pmore}
When the dependent variable takes k different values, the third new variable
through new variable k+1 will contain the derivative of the log likelihood
with respect to the ordinal outcome equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pm:argin}}marginal probabilities of levels, Pr(y = h); the default{p_end}
{synopt :{opt pjoint1}}joint probabilities of levels and participation, Pr(y = h, s = 1){p_end}
{synopt :{opt pcond1}}probabilities of levels conditional on participation, Pr(y = h, s = 1){p_end}
{synopt :{opt ppar}}probability of participation, Pr(s = 1){p_end}
{synopt :{opt pnpar}}probability of nonparticipation, Pr(s = 0){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbinfl}}linear prediction for inflation equation{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdpinfl}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pmargin}, {opt pjoint1}, and {opt pcond1} default to the first outcome.
{p_end}

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
{phang2}{cmd:. webuse tobacco}{p_end}
{phang2}{cmd:. zioprobit tobacco education income i.female age, inflate(education income i.parent age i.female i.religion)}{p_end}

{pstd}Estimate the expected marginal effect of gender for individuals with a
college degree (17 years of education) and a smoking parent on the probability
of nonparticipation (being a genuine nonsmoker){p_end}
{phang2}{cmd:. margins, predict(pnpar) dydx(female) at(education = 17 parent = 1)}

{pstd}Estimate the expected marginal effect of income at six prespecified
values ranging from $10,000 to $60,000 on the probability of nonparticipation
{p_end}
{phang2}{cmd:. margins, predict(pnpar) at(income = (1/6))}{p_end}

{pstd}Calculate the probabilities for levels of consumption conditional on
participation{p_end}
{phang2}{cmd:. predict prcond*, pcond1}{p_end}
