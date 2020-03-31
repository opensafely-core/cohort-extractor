{smcl}
{* *! version 1.0.7  04jun2018}{...}
{viewerdialog predict "dialog stintreg_p"}{...}
{viewerdialog stcurve "dialog stcurve"}{...}
{viewerdialog estat "dialog stintreg_estat"}{...}
{vieweralsosee "[ST] stintreg postestimation" "mansection ST stintregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stintreg" "help stintreg"}{...}
{viewerjumpto "Postestimation commands" "stintreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "stintreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "stintreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "stintreg postestimation##syntax_margins"}{...}
{viewerjumpto "estat gofplot" "stintreg postestimation##syntax_gofplot"}{...}
{viewerjumpto "Examples" "stintreg postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[ST] stintreg postestimation} {hline 2}}Postestimation tools for stintreg{p_end}
{p2col:}({mansection ST stintregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:stintreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb stintreg_postestimation##gofplot:estat gofplot}}produce goodness-of-fit plot{p_end}
{synopt :{helpb stcurve}}plot the survivor, hazard, and cumulative hazard functions{p_end}
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
{synopt:{helpb stintreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb stintreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection ST stintregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ST stintregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}
   {help stintreg_postestimation##synopts:{it:options}}]

{p 8 16 2}
{cmd:predict} {dtype} {help newvar:newvar_l} {help newvar:newvar_u}
{ifin} {cmd:,} {it:{help stintreg_postestimation##statistic2:statistic2}}
   [{help stintreg_postestimation##synopts:{it:options}}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{c )-}
{ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt med:ian} {opt time}}median survival time; the default{p_end}
{synopt :{opt med:ian} {opt lnt:ime}}median ln(survival time){p_end}
{synopt :{opt mean time}}mean survival time{p_end}
{synopt :{opt mean} {opt lnt:ime}}mean ln(survival time){p_end}
{synopt :{opt hr}}hazard ratio, also known as the relative hazard{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction; SE(xb){p_end}
{p2coldent :* {opt mg:ale}}martingale-like residuals{p_end}
{synoptline}
{p2colreset}{...}

{marker statistic2}{...}
{synoptset 17 tabbed}{...}
{synopthdr :statistic2}
{synoptline}
{syntab:Main}
{synopt :{opt ha:zard}}hazard for interval endpoints {it:ltime} and {it:rtime}{p_end}
{synopt :{opt s:urv}}survivor probability for interval endpoints {it:ltime} and {it:rtime}{p_end}
{p2coldent :* {opt csn:ell}}Cox-Snell residuals for interval endpoints {it:ltime} and {it:rtime}{p_end}
{synoptline}
{p2colreset}{...}

{marker synopts}{...}
{synoptset 17}{...}
{synopthdr :options}
{synoptline}
{syntab:Main}
{synopt :{opt nooff:set}}ignore the {cmd:offset()} variable specified in
    {cmd:stintreg}{p_end}
{synopt :{opt oos}}make {it:statistic} and {it:statistic2} available in and out of sample{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2} 
Unstarred statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.  Starred statistics are calculated for the estimation sample
by default, but the {opt oos} option makes them available both in and out of
sample.{p_end}
{p 4 6 2} 
The predicted hazard ratio, option {opt hr}, is available only
for the exponential, Weibull, and Gompertz models. The {opt mean} {opt time}
and {opt mean lntime} options are not available for the Gompertz model.{p_end}
{p 4 6 2}
{opt csnell} and {opt mgale} are not allowed with {cmd:svy} estimation
results.{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
median and mean survival times, hazards, hazard ratios, linear predictions,
standard errors, probabilities, Cox-Snell and martingale-like residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt median time} calculates the predicted median survival time in
analysis-time units.  When no options are specified with {cmd:predict}, the
predicted median survival time is calculated for all models.

{phang}
{opt median lntime} calculates the natural logarithm of what {opt median time}
produces.

{phang}
{opt mean time} calculates the predicted mean survival time in analysis-time
units.  This option is not available for Gompertz regression.

{phang}
{opt mean lntime} predicts the mean of the natural logarithm of {opt time}.
This option is not available for Gompertz regression.

{phang}
{opt hazard} calculates the predicted hazard for both the lower endpoint
{it:ltime} and the upper endpoint {it:rtime} of the time interval.

{phang}
{opt hr} calculates the hazard ratio.  This option is valid only for models
having a proportional-hazards parameterization.

{phang}
{opt xb} calculates the linear prediction from the fitted model. That is,
you fit the model by estimating a set of parameters b0, b1, b2, ..., bk,
and the linear prediction is y = xb.

{pmore}
The x used in the calculation is obtained from the data currently in memory
and need not correspond to the data on the independent variables used in
estimating b.

{phang}
{opt stdp} calculates the standard error of the prediction, that is,
the standard error of y.

{phang}
{opt surv} calculates each observation's predicted survivor probabilities for
both the lower endpoint {it:ltime} and the upper endpoint {it:rtime} of the
time interval. 

{phang}
{opt csnell} calculates the Cox-Snell residuals for both the lower endpoint
{it:ltime} and the upper endpoint {it:rtime} of the time interval.

{phang}
{opt mgale} calculates interval-censored martingale-like residuals, which are
an interval-censored version of martingale-like residuals for right-censored
data.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} with
{opt stintreg}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as xb
rather than xb + offset.

{phang}
{opt oos} makes {opt csnell} and {opt mgale}
available both in and out of sample.  {opt oos} also dictates that summations
and other accumulations take place over the sample as defined by {cmd:if} and
{cmd:in}.  By default, the summations are taken over the estimation sample, with
{cmd:if} and {cmd:in} merely determining which values of {newvar},
{it:newvar_l}, and {it:newvar_u} are to be filled in once the calculation is
finished.

{phang}
{opt scores} calculates equation-level score variables.  The number of score
variables created depends upon the chosen distribution.

{pmore}
The first new variable will always contain the partial derivative of the log
likelihood with respect to the linear prediction (regression equation)
from the fitted model.

{pmore}
The subsequent new variables will contain the partial derivative of the log
likelihood with respect to the ancillary parameters. 


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt med:ian} {opt time}}median survival time; the default{p_end}
{synopt :{opt med:ian} {opt lnt:ime}}median ln(survival time){p_end}
{synopt :{opt mean time}}mean survival time{p_end}
{synopt :{opt mean} {opt lnt:ime}}mean ln(survival time){p_end}
{synopt :{opt hr}}hazard ratio, also known as the relative hazard{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ha:zard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt s:urv}}not allowed with {cmd:margins}{p_end}
{synopt :{opt csn:ell}}not allowed with {cmd:margins}{p_end}
{synopt :{opt mg:ale}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
Hazard estimation is not allowed because it produces interval estimates.

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for median and mean survival
times, hazard ratios, and linear predictions.


{marker syntax_gofplot}{...}
{marker gofplot}{...}
{title:Syntax for estat gofplot}

{p 8 16 2}
{cmd:estat gofplot} [{cmd:,} {it:options}]

{synoptset 34 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{cmdab:out:file:(}{it:{help filename}}[{cmd:,} {opt replace}]{cmd:)}}save values used to plot the goodness-of-fit graph{p_end}

{syntab:Plot}
{synopt :{it:{help connect_options:connect_options}}}affect rendition of
plotted cumulative hazard function{p_end}

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
         {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker des_gofplot}{...}
{title:Description for estat gofplot}

{pstd}
{cmd:estat gofplot} plots the Cox-Snell residuals versus the estimated
cumulative hazard function corresponding to these residuals to assess 
the goodness of fit of the model visually.


{marker options_gofplot}{...}
{title:Options for estat gofplot}

{phang}
{cmd:outfile(}{it:{help filename}}[{cmd:,} {opt replace}]{cmd:)} saves in
{it:filename}{cmd:.dta} the values used to plot the goodness-of-fit graph.

{dlgtab:Plot}

{phang}
{it:connect_options} affect the rendition of the plotted 
cumulative hazard function; see {manhelpi connect_options G-3}.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line;
see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cosmesis}

{pstd}Fit Weibull survival model{p_end}
{phang2}{cmd:. stintreg i.treat, distribution(weibull) interval(ltime rtime)}

{pstd}Predict median survival time{p_end}
{phang2}{cmd:. predict time, time}

{pstd}Predict log-median survival time{p_end}
{phang2}{cmd:. predict lntime, lntime}

{pstd}Predict adjusted Cox-Snell residuals{p_end}
{phang2}{cmd:. predict double cs, csnell adjusted}

{pstd}Predict martingale-like residuals{p_end}
{phang2}{cmd:. predict double mg, mgale}{p_end}

{pstd}Graphically test goodness of fit of the model{p_end}
{phang2}{cmd:. estat gofplot}{p_end}
