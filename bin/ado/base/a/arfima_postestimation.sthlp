{smcl}
{* *! version 1.1.6  15may2018}{...}
{viewerdialog predict "dialog arfima_p"}{...}
{viewerdialog "estat acplot" "dialog arfima_estat"}{...}
{viewerdialog psdensity "dialog psdensity"}{...}
{vieweralsosee "[TS] arfima postestimation" "mansection TS arfimapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arfima" "help arfima"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] estat acplot" "help estat acplot"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] psdensity" "help psdensity"}{...}
{viewerjumpto "Postestimation commands" "arfima postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "arfima_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "arfima postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "arfima postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "arfima postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[TS] arfima postestimation} {hline 2}}Postestimation tools for
arfima{p_end}
{p2col:}({mansection TS arfimapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:arfima}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat acplot}}estimate autocorrelations and autocovariances{p_end}
{synopt :{helpb irf}}create and analyze IRFs{p_end}
{synopt :{helpb psdensity}}estimate the spectral density{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17 tabbed}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent:* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
{p2coldent:* {helpb arfima_postestimation##margins:margins}}marginal means, predictive margins, marginal
                effects, and average marginal effects{p_end}
{p2coldent:* {bf:{help marginsplot}}}graph the results from margins (profile
               plots, interaction plots, etc.){p_end}
{p2coldent:* {bf:{help nlcom}}}point estimates, standard errors, testing, and
               inference for nonlinear combinations of coefficients{p_end}
{p2col :{helpb arfima postestimation##syntax_predict:predict}}predictions, residuals,
               influence statistics, and other diagnostic measures{p_end}
{p2coldent:* {bf:{help predictnl}}}point estimates, standard errors, testing,
               and inference for generalized predictions{p_end}
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p 4 6 2}
* {bf:estat ic}, {bf:margins}, {bf:marginsplot}, {bf:nlcom}, and {bf:predictnl}
are not appropriate after {bf:arfima, mpl}.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS arfimapostestimationRemarksandexamples:Remarks and examples}

        {mansection TS arfimapostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,}
{it:{help arima postestimation##statistic:statistic}}
{it:{help arima postestimation##options:options}}]

{marker statistic}{...}
{synoptset 22 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}predicted values; the default{p_end}
{synopt:{opt r:esiduals}}predicted innovations{p_end}
{synopt:{opt rsta:ndard}}standardized innovations{p_end}
{synopt:{opt fdif:ference}}fractionally differenced series{p_end}
{synoptline}
INCLUDE help esample

{marker options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt :{cmd:rmse(}{dtype} {it:{help newvar:newvar}}{cmd:)}}put the estimated
        root mean squared error of the predicted statistic
	in a new variable; only permitted with options {opt xb} and 
	{opt residuals}{p_end}
{synopt:{cmdab:dyn:amic(}{it:{help datetime##s9:datetime}}{cmd:)}}forecast
        the time series starting at {it:datetime}; only permitted with
	option {opt xb}{p_end}
{synoptline}
{p 4 6 2}
{it:datetime} is a {it:#} or a time literal, such as {cmd:td(1jan1995)} or
{cmd:tq(1995q1)}; see {helpb datetime:[D] Datetime}.
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
expected values, fractionally differenced series, and innovations.  All
predictions are available as static one-step-ahead predictions, and the
dependent variable is also available as a dynamic multistep prediction.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the predictions for the level of {depvar}.

{phang}
{opt residuals} calculates the predicted innovations.

{phang}
{opt rstandard} calculates the standardized innovations.

{phang}
{opt fdifference} calculates the fractionally differenced predictions of
{depvar}.

{dlgtab:Options}

{phang}
{cmd:rmse(}{dtype} {it:{help newvar}}{cmd:)} puts the root mean
squared errors of the predicted statistics into the specified new variables.
The root mean squared errors measure the variances due to the disturbances but
do not account for estimation error.  {cmd:rmse()} is only permitted
with the {opt xb} and {opt residuals} options.

{phang}
{cmd:dynamic(}{it:datetime}{cmd:)} specifies when {opt predict} starts
producing dynamic forecasts.  The specified {it:datetime} must be in the
scale of the time variable specified in {opt tsset}, and the {it:datetime}
must be inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2008q4))} causes dynamic predictions
to begin in the fourth quarter of 2008, assuming that your time variable is
quarterly; see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {opt dynamic()} may only be specified with {opt xb}.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt xb}}predicted values; the default{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rsta:ndard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt fdif:ference}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tb1yr}{p_end}

{pstd}Fit ARFIMA(2,d,1) model on 1-year treasury bill data{p_end}
{phang2}{cmd:. arfima tb1yr, ar(1/2) ma(1)}{p_end}

{pstd}One-step predictions of {cmd:tb1yr}{p_end}
{phang2}{cmd:. predict ptb}{p_end}

{pstd}Filter wpi, applying fractional differences{p_end}
{phang2}{cmd:. predict fdtb, fdifference}

{pstd}Plot the time-series, predictions, and filtered estimates{p_end}
{phang2}{cmd:. twoway tsline tb1yr ptb fdtb}{p_end}

{pstd}Extend the data 1 year{p_end}
{phang2}{cmd:. tsappend, add(12)}

{pstd}Compute forecasts of {cmd:dwpi} for the year of 1991 and their RMSE{p_end}
{phang2}{cmd:. predict ftb, xb dynamic(tm(2001m9)) rmse(rtb)} 

{pstd}Compute approximate 90% forecast intervals{p_end}
{phang2}{cmd:. scalar z = invnormal(0.95)}{p_end}
{phang2}{cmd:. generate lb = ftb - z*rtb if month>=tm(2001m9)}{p_end}
{phang2}{cmd:. generate ub = ftb + z*rtb if month>=tm(2001m9)}{p_end}

{pstd}Graph a time-series line plot{p_end}
{phang2}{cmd:. twoway tsline tb1yr ftb if month>tm(1998m12)||}{break}
        {cmd:tsrline lb ub if month>=tm(2001m9),}{break}
        {cmd:legend(cols(1) label(3 "80% prediction interval"))}{p_end}
