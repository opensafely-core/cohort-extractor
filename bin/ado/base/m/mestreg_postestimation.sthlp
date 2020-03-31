{smcl}
{* *! version 1.1.4  05sep2018}{...}
{viewerdialog predict "dialog mestreg_p"}{...}
{vieweralsosee "[ME] mestreg postestimation" "mansection ME mestregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{vieweralsosee "[ME] mixed postestimation" "help mixed postestimation"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{viewerjumpto "Postestimation commands" "mestreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mestreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mestreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mestreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mestreg postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[ME] mestreg postestimation} {hline 2}}Postestimation tools for mestreg{p_end}
{p2col:}({mansection ME mestregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:mestreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb stcurve}}plot the survivor, hazard, and cumulative hazard functions{p_end}
{synopt :{helpb estat group}}summarize the composition of the nested groups{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as
standard deviations and correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

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
{synopt:{helpb mestreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb mestreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy} estimation
results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME mestregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME mestregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict

{synoptset 15 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mean}}mean survival time; the default{p_end}
{synopt :{opt med:ian}}median survival time{p_end}
{synopt :{opt ha:zard}}hazard{p_end}
{synopt :{opt eta}}fitted linear predictor{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt s:urv}}predicted survivor function{p_end}
{synopt :{opt den:sity}}predicted density function{p_end}
{synopt :{opt dist:ribution}}predicted distribution function{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} 
{p_end}
{p2colreset}{...}
INCLUDE help esample

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help mestreg_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help mestreg_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
{cmd:median}
may not be combined with {cmd:marginal}.

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
median and mean survival times, hazards, survivor functions,
linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt mean}, the default, calculates the mean survival time.

{phang}
{opt median} calculates the median survival time.

{phang}
{opt hazard} calculates the hazard. When {opt marginal} is specified, marginal
hazard is calculated as a ratio of the marginal density to the marginal
survivor function.

{phang}
{opt surv} calculates the predicted survivor function.

{phang}
{opt eta}, {opt xb}, {opt stdp}, {opt density}, {opt distribution},
{opt scores}, {opt conditional()}, {opt marginal}, and {opt nooffset};
see {helpb meglm postestimation:[ME] meglm postestimation}.
{cmd:marginal} may not be specified with {cmd:median}.

{phang}
{opt reffects},
{opt ebmeans},
{opt ebmodes}, and
{opt reses()};
see {helpb meglm postestimation:[ME] meglm postestimation}.

{dlgtab:Integration}

{phang}
{opt intpoints()}, {opt iterate()}, and {opt tolerance()};
see {helpb meglm postestimation:[ME] meglm postestimation}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mean}}mean survival time; the default{p_end}
{synopt :{opt med:ian}}median survival time{p_end}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt ha:zard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt eta}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt s:urv}}not allowed with {cmd:margins}{p_end}
{synopt :{opt den:sity}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dist:ribution}}not allowed with {cmd:margins}{p_end}
{synopt :{opt reffects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt scores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
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
mean and median survival times and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter}

{pstd}Two-level random-intercept Weibull survival model{p_end}
{phang2}{cmd:. mestreg age female || patient:, distribution(weibull)}

{pstd}Predict the marginal mean survival time{p_end}
{phang2}{cmd:. predict m_marg, mean marginal}

{pstd}Predict the conditional mean survival time using empirical Bayes means estimates for the random effects{p_end}
{phang2}{cmd:. predict m_cond1, mean conditional}

{pstd}Predict the conditional mean survival time using empirical Bayes modes estimates for the random effects{p_end}
{phang2}{cmd:. predict m_cond2, mean conditional(ebmodes)}

{pstd}Use {cmd:margins} to calculate the marginal predicted means for females at different ages{p_end}
{phang2}{cmd:. margins, predict(mean marginal) at(female=0 age=(20(5)70))}

{pstd}Plot the results{p_end}
{phang2}{cmd:. marginsplot}{p_end}
