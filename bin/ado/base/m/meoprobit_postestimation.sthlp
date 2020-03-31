{smcl}
{* *! version 1.3.5  17sep2019}{...}
{viewerdialog predict "dialog meoprobit_p"}{...}
{viewerdialog estat "dialog meoprobit_estat"}{...}
{vieweralsosee "[ME] meoprobit postestimation" "mansection ME meoprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meoprobit" "help meoprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{viewerjumpto "Postestimation commands" "meoprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "meoprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "meoprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meoprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "meoprobit postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[ME] meoprobit postestimation} {hline 2}}Postestimation tools for meoprobit{p_end}
{p2col:}({mansection ME meoprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:meoprobit}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb estat icc}}estimate
intraclass correlations{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as standard deviations and correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18 tabbed}{...}
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
{synopt:{helpb meoprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb meoprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME meoprobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME meoprobitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict

{marker statistic}{...}
{synoptset 25 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}predicted probabilities; the default{p_end}
{synopt :{opt eta}}fitted linear predictor{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt den:sity}}predicted density function{p_end}
{synopt :{opt dist:ribution}}predicted distribution function{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help meoprobit_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}
{synopt :{opt out:come(outcome)}}outcome category for predicted probabilities{p_end}

{syntab :Integration}
{synopt :{it:{help meoprobit_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
You specify one or {it:k} new variables in {it:{help newvarlist}}
with {cmd:pr}, where {it:k} is the number of outcomes.
If you do not specify {cmd:outcome()}, these options assume {cmd:outcome(#1)}.{p_end}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, density and distribution functions,
and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:pr}, the default, calculates the predicted probabilities.

{pmore}
You specify one or {it:k} new variables, where {it:k} is the number of
categories of the dependent variable.  If you specify the {cmd:outcome()}
option, the probabilities will be predicted for the requested outcome only, in
which case you specify only one new variable.  If you specify only one new
variable and do not specify {cmd:outcome()}, {cmd:outcome(#1)} is assumed.

{phang}
{cmd:eta},
{cmd:xb},
{cmd:stdp},
{cmd:density},
{cmd:distribution},
{cmd:scores},
{cmd:conditional()},
{cmd:marginal}, and
{cmd:nooffset};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.

{phang}
{opt outcome(outcome)} specifies the outcome for which the predicted
probabilities are to be calculated.  {cmd:outcome()} should contain either one
value of the dependent variable or one of {bf:#1}, {bf:#2}, ..., with {bf:#1}
meaning the first category of the dependent variable, {bf:#2} meaning the
second category, etc.

{phang}
{cmd:reffects},
{cmd:ebmeans},
{cmd:ebmodes},
and
{cmd:reses()};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.

{dlgtab:Integration}

{phang}
{cmd:intpoints()},
{cmd:iterate()},
{cmd:tolerance()};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt pr}}probability for a specified outcome{p_end}
{synopt :{opt eta}}fitted linear predictor{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt den:sity}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dist:ribution}}not allowed with {cmd:margins}{p_end}
{synopt :{opt reffects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt scores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:pr} defaults to the first outcome.
{p_end}
{p 4 6 2}
Options {cmd:conditional(ebmeans)} and {cmd:conditional(ebmodes)} are not
allowed with {cmd:margins}.
{p_end}
{p 4 6 2}
Option {opt marginal} is assumed where applicable if
{cmd:conditional(fixedonly)} is not specified.
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
{phang2}{cmd:. webuse tvsfpors}{p_end}
{phang2}{cmd:. meoprobit thk prethk cc##tv || school: || class:}{p_end}

{pstd}Obtain predicted probabilities for each outcome based on the contribution of both fixed effects and random effects{p_end}
{phang2}{cmd:. predict pr*}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re*, reffects}{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}
