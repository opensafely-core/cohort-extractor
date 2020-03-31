{smcl}
{* *! version 1.1.7  10aug2018}{...}
{viewerdialog predict "dialog heckopr_p"}{...}
{vieweralsosee "[R] heckoprobit postestimation" "mansection R heckoprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckoprobit" "help heckoprobit"}{...}
{viewerjumpto "Postestimation commands" "heckoprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "heckoprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "heckoprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "heckoprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "heckoprobit postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[R] heckoprobit postestimation} {hline 2}}Postestimation tools
for heckoprobit{p_end}
{p2col:}({mansection R heckoprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:heckoprobit}:

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
{synopt:{helpb heckoprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb heckoprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R heckoprobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R heckoprobitpostestimationMethodsandformulas:Methods and formulas}

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
[{cmd:,} {it:statistic}
{opt o:utcome(outcome)}
{opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:newvar_reg newvar_sel newvar_1 ... newvar_h newvar_athrho}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 11 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pm:argin}}marginal probabilities; the default{p_end}
{synopt :{opt p1}}bivariate probabilities of levels with selection{p_end}
{synopt :{opt p0}}bivariate probabilities of levels with no selection{p_end}
{synopt :{opt pcond1}}probabilities of levels conditional on selection{p_end}
{synopt :{opt pcond0}}probabilities of levels conditional on no selection{p_end}
{synopt :{opt ps:el}}selection probability{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt stdps:el}}standard error of the linear prediction for selection equation{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pmargin} (with one new variable
specified) assumes {cmd:outcome(#1)}.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pmargin}, where k is the number
of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:psel}, {cmd:xb}, {cmd:stdp},
{cmd:xbsel}, and {cmd:stdpsel}.{p_end}
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
{opt pmargin}, the default, calculates the predicted marginal probabilities.

{pmore}
You specify one or k new variables, where k is the number of categories of the
dependent variable.  If you specify the {opt outcome()} option, you must
specify one new variable.  If you specify one new variable and do not specify
{opt outcome()}, {cmd:outcome(#1)} is assumed.

{pmore}
When {opt outcome()} is specified, the marginal probability that the dependent
variable is equal to the level {opt outcome()} is calculated.  When 
{opt outcome()} is not specified, the marginal probabilities for each outcome
level are calculated.

{phang}
{opt p1} calculates the predicted bivariate probabilities of outcome levels
with selection.

{pmore}
You specify one or k new variables, where k is the number of categories of the
dependent variable.  If you specify the {opt outcome()} option, you must
specify one new variable.  If you specify one new variable and do not specify
{opt outcome()}, {cmd:outcome(#1)} is assumed.

{pmore}
When {opt outcome()} is specified, the bivariate probability that the
dependent variable is equal to the level {opt outcome()} and that the
dependent variable is observed is calculated.  When {opt outcome()} is not
specified, the bivariate probabilities for each outcome level and selection
are calculated.

{phang}
{opt p0} calculates the predicted bivariate probabilities of outcome levels
with no selection.

{pmore}
You specify one or k new variables, where k is the number of categories of the
dependent variable.  If you specify the {opt outcome()} option, you must
specify one new variable.  If you specify one new variable and do not specify
{opt outcome()}, {cmd:outcome(#1)} is assumed.

{pmore} 
When {opt outcome()} is specified, the bivariate probability that the
dependent variable is equal to the level {opt outcome()} and that the
dependent variable is not observed is calculated. When {opt outcome()} is not
specified, the bivariate probabilities for each outcome level and no selection
are calculated.

{phang}
{opt pcond1} calculates the predicted probabilities of outcome levels
conditional on selection.

{pmore}
You specify one or k new variables, where k is the number of categories of the
dependent variable.  If you specify the {opt outcome()} option, you must
specify one new variable.  If you specify one new variable and do not specify
{opt outcome()}, {cmd:outcome(#1)} is assumed.

{pmore}
When {opt outcome()} is specified, the probability that the dependent variable
is equal to the level {opt outcome()} given that the dependent variable is
observed is calculated.  When {opt outcome()} is not specified, the
probabilities for each outcome level conditional on selection are calculated.

{phang}
{opt pcond0} calculates the predicted probabilities of outcome levels
conditional on no selection.

{pmore}
You specify one or k new variables, where k is the number of categories of the
dependent variable.  If you specify the {opt outcome()} option, you must
specify one new variable.  If you specify one new variable and do not specify
{opt outcome()}, {cmd:outcome(#1)} is assumed.

{pmore}
When {opt outcome()} is specified, the probability that the dependent variable
is equal to the level {opt outcome()} given that the dependent variable is
not observed is calculated.  When {opt outcome()} is not specified, the
probabilities for each outcome level conditional on no selection are calculated.

{phang} {opt psel} calculates the predicted univariate (marginal) probability
of selection.

{phang}
{opt xb} calculates the linear prediction for the outcome variable,
which is xb if {cmd:offset()} was not specified and
xb + offset if {cmd:offset()} was specified.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt xbsel} calculates the linear prediction for the selection equation, which
is zg if {cmd:offset()} was not specified in {cmd:select()} and
zg + offset if {cmd:offset()} was specified in {cmd:select()}.

{phang}
{opt stdpsel} calculates the standard error of the linear prediction
for the selection equation.

{phang}
{opt outcome(outcome)} specifies the outcome for which predicted probabilities
are to be calculated.  {opt outcome()} should contain either one value of the
dependent variable or one of {opt #1}, {opt #2}, ...., with {opt #1} meaning
the first category of the dependent variable, {opt #2} meaning the second
category, etc.

{marker nooffset}{...}
{phang}
{opt nooffset} is relevant only if you specified
{opth offset(varname)} for {cmd:heckoprobit}.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset variable; the linear
prediction is treated as xb rather than xb + offset.

{phang}
{opt scores} calculates equation-level score variables.{p_end}

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the selection equation.

{pmore}
When the dependent variable takes k different values, new variables three
through k+1 will contain the derivatives of the log likelihood with respect to
the cutpoints.

{pmore}
The last new variable will contain the derivative of the log likelihood with
respect to the last equation ({hi:athrho}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}marginal probabilities for each outcome{p_end}
{synopt :{opt pm:argin}}marginal probabilities{p_end}
{synopt :{opt p1}}bivariate probabilities of levels with selection{p_end}
{synopt :{opt p0}}bivariate probabilities of levels with no selection{p_end}
{synopt :{opt pcond1}}probabilities of levels conditional on selection{p_end}
{synopt :{opt pcond0}}probabilities of levels conditional on no selection{p_end}
{synopt :{opt ps:el}}selection probability{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdps:el}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pmargin}, {opt p1}, {opt p0}, {opt pcond1}, and {opt pcond0} default to
the first outcome.
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
{phang2}{cmd:. webuse womensat}{p_end}

{pstd}Fit an ordered probit model with sample selection based on employment{p_end}
{phang2}{cmd:. heckoprobit satisfaction educ age, select(work=educ age i.married##c.children)}
{p_end}

{pstd}Estimate the selection probability{p_end}
{phang2}{cmd:. predict sel, psel}{p_end}

{pstd}Estimate probability of being in the second group and selected{p_end}
{phang2}{cmd:. predict in2sel, outcome(#2) p1}{p_end}
