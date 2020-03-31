{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog predict "dialog meintreg_p"}{...}
{viewerdialog estat "dialog meintreg_estat"}{...}
{vieweralsosee "[ME] meintreg postestimation" "mansection ME meintregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meintreg" "help meintreg"}{...}
{viewerjumpto "Postestimation commands" "meintreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "meintreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "meintreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meintreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "meintreg postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[ME] meintreg postestimation} {hline 2}}Postestimation tools for
meintreg{p_end}
{p2col:}({mansection ME meintregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:meintreg}:

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
{synopt:{helpb meintreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb meintreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection ME meintregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME meintregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict


{marker statistic}{...}
{synoptset 25 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt eta}}fitted linear predictor; the default{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt pr(a,b)}}Pr(a < y < b){p_end}
{synopt :{opt e(a,b)}}E(y | a < y < b){p_end}
{synopt :{opt ys:tar(a,b)}}E(y*), y* = max{a,min(y,b)}{p_end}
{synoptline}
INCLUDE help esample

INCLUDE help whereab

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help meintreg_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help meintreg_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt eta}, the default, calculates the fitted linear prediction.

{phang}
{opt pr(a,b)} calculates estimates of 
{bind:Pr({it:a} < y < {it:b})}, which is the probability
that y would be observed in the interval (a,b).

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names;
{it:lb} and {it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < y < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates
{bind:Pr({it:lb} < y < {it:ub})}; and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates
{bind:Pr(20 < y < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} {cmd:.})} means minus infinity;{break}
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < y < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates {bind:Pr(-infinity < y < 30)}
in observations for which {bind:{it:lb} {ul:>} {cmd:.}}
(and calculates {bind:Pr({it:lb} < y < 30)} elsewhere).

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity;{break}
{cmd:pr(20,.)} calculates {bind:Pr(+infinity > y > 20)};{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(+infinity > y > 20)} in
observations for which {it:ub} {ul:>} {cmd:.} (and calculates
{bind:Pr(20 < y < {it:ub})} elsewhere).

{phang}
{opt e(a,b)} calculates estimates of {bind:E(y | {it:a} < y < {it:b})}, which
is the expected value of y conditional on y being in the interval
({it:a},{it:b}), meaning that y is truncated.  {it:a} and {it:b} are
specified as they are for {cmd:pr()}.

{phang}
{opt ystar(a,b)} calculates estimates of E(y*), where {bind:y* = a} if
{bind:y {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:y {ul:>} {it:b}}, and {bind:y* = y} otherwise,
meaning that y* is the censored version of y.
{it:a} and {it:b} are specified as they are for {cmd:pr()}.

{phang}
{opt xb}, {opt stdp}, {opt scores}, {opt conditional()}, {opt marginal},
and {opt nooffset};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.

{phang}
{cmd:reffects},
{cmd:ebmeans},
{cmd:ebmodes}, and
{cmd:reses()};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.

{dlgtab:Integration}

{phang}
{cmd:intpoints()},
{cmd:iterate()}, and
{cmd:tolerance()};
see {helpb meglm postestimation##options_predict:[ME] meglm postestimation}.


INCLUDE help syntax_margins

{marker statistic}{...}
{synoptset 25 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt eta}}fitted linear predictor; the default{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt pr(a,b)}}Pr(a < y < b){p_end}
{synopt :{opt e(a,b)}}E(y | a < y < b){p_end}
{synopt :{opt ys:tar(a,b)}}E(y*), y* = max{a,min(y,b)}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions, probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mastitis}{p_end}
{phang2}{cmd:. generate lnleft = ln(left)}{p_end}
{phang2}{cmd:. generate lnright = ln(right)}{p_end}
{phang2}{cmd:. meintreg lnleft lnright i.multiparous || farm: || cow:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predict probabilities conditional on random effects{p_end}
{phang2}{cmd:. predict pr_cond, pr(.,log(90))}{p_end}

{pstd}Compute the fitted linear prediction{p_end}
{phang2}{cmd:. predict eta_cond}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}
