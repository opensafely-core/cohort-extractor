{smcl}
{* *! version 1.0.7  19jun2019}{...}
{viewerdialog "predict after eintreg" "dialog eintreg_p"}{...}
{viewerdialog "predict after xteintreg" "dialog eintreg_p"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "mansection ERM eintregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg" "help eintreg"}{...}
{vieweralsosee "[ERM] eintreg predict" "help eintreg predict"}{...}
{vieweralsosee "[ERM] predict advanced" "help erm predict advanced"}{...}
{vieweralsosee "[ERM] predict treatment" "help erm predict treatment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eprobit postestimation" "help eprobit postestimation"}{...}
{viewerjumpto "Postestimation commands" "eintreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "eintreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "eintreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "eintreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "eintreg postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[ERM] eintreg postestimation} {hline 2}}Postestimation tools for
eintreg and xteintreg{p_end}
{p2col:}({mansection ERM eintregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{opt eintreg} and {opt xteintreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb erm estat teffects:estat teffects}}treatment effects and potential-outcome means{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are available after
{opt eintreg} and {opt xteintreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
{p2coldent:+ {help estat svy:{bf:estat} (svy)}}postestimation statistics for survey data{p_end}
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb eintreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb eintreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{p2coldent:+ {bf:{help suest}}}seemingly unrelated estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.{p_end}
{p 4 6 2}
+ {cmd:suest} and the survey data {cmd:estat} commands are not available after
{cmd:xteintreg}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eintregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ERM eintregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:predict}

{pstd}
Predictions after {cmd:eintreg} and {cmd:xteintreg} are described in

            {helpb eintreg predict:[ERM] eintreg predict}       predict after eintreg and xteintreg
            {helpb erm predict treatment:[ERM] predict treatment}     predict for treatment statistics
            {helpb erm predict advanced:[ERM] predict advanced}      predict’s advanced features

{pstd}
{helpb eintreg predict:[ERM] eintreg predict} describes the most commonly used
predictions.  If you fit a model with treatment effects, predictions
specifically related to these models are detailed in
{helpb erm predict treatment:[ERM] predict treatment}.
{helpb erm predict advanced:[ERM] predict advanced} describes less commonly
used predictions, such as predictions of outcomes in auxiliary equations.


INCLUDE help syntax_margins

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt m:ean}}mean; the default{p_end}
{synopt :{opt pr}}probability of binary or ordinal y{p_end}
{synopt :{opt pom:ean}}potential-outcome mean{p_end}
{synopt :{opt te}}treatment effect{p_end}
{synopt :{opt tet}}treatment effect on the treated{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt pr(a,b)}}Pr({it:a} < y < {it:b}) for continuous y{p_end}
{synopt :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}) for continuous y{p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-} for continuous y{p_end}
{synopt :{opt expm:ean}}calculate E{c -(}exp(y_i){c )-}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
means, probabilities, potential-outcome means, treatment effects,
and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse class10}{p_end}
{phang2}
{cmd:. eintreg gpal gpau income, endogenous(hsgpa = income i.hscomp)}{p_end}
{phang2}
{cmd:. generate str name = "Billy" in 537}

{pstd}
Expected values for college GPA if we fix Billy's {cmd:hsgpa} at 2.00
and at 3.00 and only consider his value of {cmd:income}{p_end}
{phang2}
{cmd:. margins if name=="Billy", at(hsgpa=(2 3)) predict(fix(hsgpa))}

{pstd}
Expected values for college GPA if we fix Billy's {cmd:hsgpa} at 2.00
and at 3.00 and if we also account for his values of {cmd:hsgpa},
{cmd:hscomp}, and unobservable factors that lead to correlation between
{cmd:hsgpa} and college GPA{p_end}
{phang2}
{cmd:. generate hsgpaT = hsgpa}{p_end}
{phang2}
{cmd:. margins if name=="Billy", at(hsgpa=(2 3)) predict(base(hsgpa=hsgpaT))}
{p_end}
