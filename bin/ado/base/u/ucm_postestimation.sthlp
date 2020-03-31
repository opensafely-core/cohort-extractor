{smcl}
{* *! version 1.1.4  15may2018}{...}
{viewerdialog predict "dialog ucm_p"}{...}
{viewerdialog estat "dialog ucm_estat"}{...}
{viewerdialog psdensity "dialog psdensity"}{...}
{vieweralsosee "[TS] ucm postestimation" "mansection TS ucmpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] ucm" "help ucm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] psdensity" "help psdensity"}{...}
{vieweralsosee "[TS] sspace postestimation" "help sspace postestimation"}{...}
{viewerjumpto "Postestimation commands" "ucm postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ucm_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ucm postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "ucm postestimation##syntax_estat_period"}{...}
{viewerjumpto "Examples" "ucm postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[TS] ucm postestimation} {hline 2}}Postestimation tools for
ucm{p_end}
{p2col:}({mansection TS ucmpostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:ucm}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb ucm_postestimation##estatperiod:estat period}}display cycle 
	periods in time units{p_end}
{synopt :{helpb psdensity}}estimate the spectral density{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
INCLUDE help post_nlcom
{p2col :{helpb ucm postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS ucmpostestimationRemarksandexamples:Remarks and examples}

        {mansection TS ucmpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}} 
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction using exogenous variables{p_end}
{synopt :{opt tr:end}}trend component{p_end}
{synopt :{opt sea:sonal}}seasonal component{p_end}
{synopt :{opt cyc:le}}cyclical component{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Options}
{synopt :{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{cmd:)}}put
 estimated root mean squared errors of predicted statistics in new variables
{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified time
{p_end}

{syntab :Advanced}
{synopt :{opt smeth:od(method)}}method for predicting unobserved components
	{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 18}{...}
{synopthdr :method}
{synoptline}
{synopt :{opt one:step}}predict using past information{p_end}
{synopt :{opt sm:ooth}}predict using all sample information{p_end}
{synopt :{opt fi:lter}}predict using past and contemporaneous information{p_end}
{synoptline}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, trend components, seasonal components, cyclical
components, and standardized and unstandardized residuals.  The root mean
squared error is available for all predictions.  All predictions are also
available as static one-step-ahead predictions or as dynamic multistep
predictions, and you can control when dynamic predictions begin.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, {opt trend}, {opt seasonal}, {opt cycle}, {opt residuals}, and 
{opt rstandard} specify the statistic to be predicted.

{phang2}
{opt xb}, the default, calculates the linear predictions using the exogenous
variables. {bf:xb} may not be used with the {cmd:smethod(filter)} option.

{phang2}
{opt trend} estimates the unobserved trend component.

{phang2}
{opt seasonal} estimates the unobserved seasonal component.

{phang2}
{opt cycle} estimates the unobserved cyclical component.

{phang2}
{opt residuals} calculates the residuals in the equation for the dependent 
variable.  {opt residuals} may not be specified with {opt dynamic()}.

{phang2}
{opt rstandard} calculates the standardized residuals, which are the
residuals normalized to have unit variances.  {opt rstandard} may not be
specified with the {cmd:smethod(filter)}, {cmd:smethod(smooth)}, or
{cmd:dynamic()} option.

{dlgtab:Options}

{phang}
{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{cmd:)} puts the root mean
squared errors of the predicted statistic into the specified new variable.
Multiple variables are only required for predicting cycles of a model that has
more than one cycle.  The root mean squared errors measure the variances due to
the disturbances but do not account for estimation error.  The {it:stub}{cmd:*}
syntax is for models with multiple cycles, where you provide the prefix and
{opt predict} will add a numeric suffix for each predicted cycle.

{phang}
{opt dynamic(time_constant)} specifies when {opt predict} should start
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {helpb tsset}, and the
{it:time_constant} must be inside a sample for which observations on the
dependent variable are available.  For example, {cmd:dynamic(tq(2008q4))}
causes dynamic predictions to begin in the fourth quarter of 2008, assuming
that your time variable is quarterly; see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {opt dynamic()} may not be specified with the {opt rstandard},
{opt residuals}, or {cmd:smethod(smooth)} option.

{dlgtab:Advanced}

{phang}
{opt smethod(method)} specifies the method for predicting the unobserved
components.  {opt smethod()} causes different amounts of information on the
dependent variable to be used in predicting the components at each time
period.

{phang2}
{cmd:smethod(onestep)}, the default, causes {opt predict} to estimate the
components at each time period using previous information on the dependent
variable.  The Kalman filter is performed on previous periods, but
only the one-step predictions are made for the current period.  

{phang2}
{cmd:smethod(smooth)} causes {cmd:predict} to estimate the components at each
time period using all the sample data by the Kalman smoother.
{cmd:smethod(smooth)} may not be specified with the {opt rstandard} option.

{phang2}
{cmd:smethod(filter)} causes {cmd:predict} to estimate the components at each
time period using previous and contemporaneous data by the Kalman filter.
The Kalman filter is performed on previous periods and the current
period. {cmd:smethod(filter)} may not be specified with the {opt xb} option.


{marker syntax_estat_period}{...}
{marker estatperiod}{...}
{title:Syntax for estat}

{p 8 18 2}
{cmd:estat}
{opt per:iod} [{cmd:,} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Main}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth cformat(%fmt)}}numeric format{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat period} transforms an estimated central frequency to an estimated
period after {cmd:ucm}.


{marker options_estat_period}{...}
{title:Options for estat}

{dlgtab:Options}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{phang}
{opth cformat(%fmt)} sets the display format for the table numeric values.
	The default is {cmd:cformat(%9.0g)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse uduration2}{p_end}

{pstd}Model monthly data on the median duration of employment spells in the
United States; include a stochastic-seasonal component because the data are
not seasonally adjusted{p_end}
{phang2}{cmd:. ucm duration, seasonal(12) cycle(1) difficult}{p_end}

{pstd}Predict the trend and seasonal components{p_end}
{phang2}{cmd:. predict strend, trend smethod(smooth)}{p_end}
{phang2}{cmd:. predict season, seasonal smethod(smooth)}{p_end}

{pstd}Graph the trend and seasonal components{p_end}
{phang2}{cmd:. tsline duration strend, name(trend) nodraw legend(rows(1))}
{p_end}
{phang2}{cmd:. tsline season, name(season) nodraw legend(rows(1))}{p_end}
{phang2}{cmd:. graph combine trend season, rows(2)}{p_end}

{pstd}Use the model to forecast the median unemployment duration; use the
root mean squared error of the prediction to compute the confidence interval
of our dynamic predictions{p_end}
{phang2}{cmd:. tsappend, add(12)}{p_end}
{phang2}{cmd:. predict duration_f, dynamic(tm(2009m1)) rmse(rmse)}{p_end}
{phang2}{cmd:. scalar z = invnormal(0.95)}{p_end}
{phang2}{cmd:. generate lbound = duration_f - z*rmse if tm>=tm(2008m12)}{p_end}
{phang2}{cmd:. generate ubound = duration_f + z*rmse if tm>=tm(2008m12)}{p_end}
{phang2}{cmd:. label variable lbound "90% forecast interval"}{p_end}
{phang2}{cmd:. twoway (tsline duration duration_f if tm>=tm(2006m1))}
              {cmd:(tsline lbound ubound if tm>=tm(2008m12)),}
              {cmd:ysize(2) xtitle("") legend(cols(1))}{p_end}
