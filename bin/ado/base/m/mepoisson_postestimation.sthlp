{smcl}
{* *! version 1.3.3  19oct2017}{...}
{viewerdialog predict "dialog mepoisson_p"}{...}
{viewerdialog estat "dialog mepoisson_estat"}{...}
{vieweralsosee "[ME] mepoisson postestimation" "mansection ME mepoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mepoisson" "help mepoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{viewerjumpto "Postestimation commands" "mepoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mepoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mepoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mepoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mepoisson postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[ME] mepoisson postestimation} {hline 2}}Postestimation tools for
mepoisson{p_end}
{p2col:}({mansection ME mepoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:mepoisson}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize
the composition of the nested groups{p_end}
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
{synopt:{helpb mepoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mepoisson postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection ME mepoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME mepoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict

INCLUDE help syntax_me_predict_stats

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help mepoisson_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help mepoisson_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
{cmd:pearson},
{cmd:deviance},
{cmd:anscombe}
may not be combined with {cmd:marginal}.
{p_end}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; density and distribution functions;
standard errors; and Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:mu}, the default, calculates the predicted mean, that is, the
predicted number of events.

INCLUDE help syntax_me_predict_desc


INCLUDE help syntax_margins

INCLUDE help syntax_me_margins_stats

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
mean responses and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse melanoma}{p_end}
{phang2}{cmd:. mepoisson deaths c.uv##c.uv, exposure(expected) || nation: || region:}{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predicted counts, incorporating random effects{p_end}
{phang2}{cmd:. predict n}{p_end}

{pstd}Predicted counts, setting all random effects to zero{p_end}
{phang2}{cmd:. predict n_fixed, conditional(fixedonly)}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re*, reffects}{p_end}
