{smcl}
{* *! version 1.0.4  04jun2018}{...}
{viewerdialog predict "dialog mswitch_p"}{...}
{viewerdialog estat "dialog mswitch_estat"}{...}
{vieweralsosee "[TS] mswitch postestimation" "mansection TS mswitchpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] mswitch" "help mswitch"}{...}
{viewerjumpto "Postestimation commands" "mswitch postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mswitch_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mswitch postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "mswitch postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "mswitch postestimation##examples"}{...}
{viewerjumpto "Stored results" "mswitch postestimation##results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[TS] mswitch postestimation} {hline 2}}Postestimation tools for
mswitch{p_end}
{p2col:}({mansection TS mswitchpostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:mswitch}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mswitch_postestimation##estat:estat transition}}display transition probabilities in a table{p_end}
{synopt :{helpb mswitch_postestimation##estat:estat duration}}display expected duration of states in a table{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
INCLUDE help post_nlcom
{p2col :{helpb mswitch postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mswitchpostestimationRemarksandexamples:Remarks and examples}

        {mansection TS mswitchpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}}
{ifin}
[{cmd:,} {help mswitch postestimation##statistic:{it:statistic}}
{help mswitch postestimation##options:{it:options}}]

{marker statistic}{...}
{synoptset 18 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt yhat}}predicted values; the default{p_end}
{synopt :{opt xb}}equation-specific predicted values; default is predicted values for the first equation{p_end}
{synopt :{opt pr}}compute probabilities of being in a given state; default is one-step-ahead probabilities{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{marker options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Options}
{synopt :{opth smeth:od(mswitch postestimation##method:method)}}method for predicting unobserved states; specify one of {cmd:onestep}, {cmd:filter}, or {cmd:smooth}; default is {cmd:smethod(onestep)}{p_end}
{synopt :{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)}}put estimated root mean squared errors of predicted statistics in new variables{p_end}
{synopt :{opth dyn:amic(mswitch postestimation##timeconstant:time_constant)}}begin dynamic forecast at specified time{p_end}
{synopt :{opt eq:uation(eqnames)}}names of equations for which predictions are to be made{p_end}
{synoptline}

{marker method}{...}
{synoptset 17}{...}
{synopthdr :method}
{synoptline}
{synopt :{opt one:step}}predict using past information{p_end}
{synopt :{opt fi:lter}}predict using past and contemporaneous information{p_end}
{synopt :{opt sm:ooth}}predict using all sample information{p_end}
{synoptline}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as predicted
values, probabilities, residuals, and standardized residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:yhat}, {cmd:xb}, {cmd:pr}, {cmd:residuals}, and {cmd:rstandard} specify
the statistic to be predicted.

{phang2}
{cmd:yhat}, the default, calculates the weighted and state-specific linear
predictions of the observed variables.

{phang2}
{cmd:xb} calculates the equation-specific linear predictions of the observed
variables.

{phang2}
{cmd:pr} calculates the probabilities of being in a given state.

{phang2}
{cmd:residuals} calculates the residuals in the equations for observable
variables.

{phang2}
{cmd:rstandard} calculates the standardized residuals, which are the residuals
normalized to have unit variances.

{dlgtab:Options}

{phang}
{opt smethod(method)} specifies the method for predicting the unobserved
states; {cmd:smethod(onestep)}, {cmd:smethod(filter)}, and
{cmd:smethod(smooth)} allow different amounts of information on the dependent
variables to be used in predicting the states at each time period.
{cmd:smethod()} may not be specified with {cmd:xb}.

{phang2}
{cmd:smethod(onestep)}, the default, causes {cmd:predict} to estimate the
states at each time period using previous information on the dependent
variables.  The nonlinear filter is performed on previous periods, but only
the one-step predictions are made for the current period.

{phang2}
{cmd:smethod(filter)} causes {cmd:predict} to estimate the states at each time
period using previous and contemporaneous data by using the nonlinear filter.
The filtering is performed on previous periods and the current period.

{phang2}
{cmd:smethod(smooth)} causes {cmd:predict} to estimate the states at each time
period using all sample data by using the smoothing algorithm.

{phang}
{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)} puts the root
mean squared errors of the predicted statistics into the specified new
variables.  The root mean squared errors measure the variances due to the
disturbances but do not account for estimation error.

{marker timeconstant}{...}
{phang}
{opt dynamic(time_constant)} specifies when {cmd:predict} starts producing
dynamic forecasts.  The specified {it:time_constant} must be in the scale of
the time variable specified in {cmd:tsset}, and the {it:time_constant} must be
inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2014q4))} causes dynamic predictions
to begin in the fourth quarter of 2014, assuming that the time variable is
quarterly; see {help datetime_functions:date and time functions}.  If the
model contains exogenous variables, they must be present for the whole
predicted sample.  {cmd:dynamic()} may not be specified with {cmd:xb},
{cmd:pr}, {cmd:residuals}, or {cmd:rstandard}.

{phang}
{opt equation(eqnames)} specifies the equations for which the predictions are
to be calculated.  If you do not specify {cmd:equation()} or {it:stub}{cmd:*},
the results are the same as if you had specified the name of the first
equation for the predicted statistic.  {cmd:equation()} may be specified with
{cmd:xb} only.

{pmore}
You specify a list of equation names, such as 
{cmd:equation(income consumption)} or {cmd:equation(factor1 factor2)}, to
identify the equations.

{pmore}
{cmd:equation()} may not be specified with {it:stub}{cmd:*}.


{marker syntax_estat}{...}
{marker estat}{...}
{title:Syntax for estat}

{pstd}
Display transition probabilities in a table

{p 8 24 2}{cmd:estat transition} [{cmd:,} {opt l:evel(#)}]

{pstd}
Display expected duration of states in a table

{p 8 24 2}{cmd:estat duration} [{cmd:,} {opt l:evel(#)}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat transition} displays all of the transition probabilities in tabular
form.

{pstd}
{cmd:estat duration} computes the expected duration that the process spends in
each state and displays the results in a table.


{marker options_estat_period}{...}
{title:Options for estat}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro}{p_end}

{pstd}
Estimate the parameters of a Markov-switching dynamic regression model for the
federal funds rate {cmd:fedfunds} as a function of its lag, the output gap
{cmd:ogap}, and {cmd:inflation} while suppressing the constant term{p_end}
{phang2}{cmd:. mswitch dr fedfunds, switch(L.fedfunds ogap inflation, noconstant)}

{pstd}
Obtain the one-step predictions for the dependent variable using the default
settings for {cmd:predict}{p_end}
{phang2}{cmd:. predict fedf}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse rgnp, clear}

{pstd}
Estimate the parameters of a Markov-switching autoregression for the United
States real gross national product as a function of its own lags{p_end}
{phang2}{cmd:. mswitch ar rgnp, ar(1/4)}

{pstd}
Calculate the average length of recession periods and expansion periods for
the U.S. economy{p_end}
{phang2}{cmd:. estat duration}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat transition} stores the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for transition probability{p_end}

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(prob)}}vector of transition probabilities{p_end}
{synopt:{cmd:r(se)}}vector of standard errors of transition probabilities{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence interval (lower and upper) for transition probability{p_end}

{pstd}
{cmd:estat duration} stores the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(d}{it:#}{cmd:)}}expected duration for state {it:#} {p_end}
{synopt:{cmd:r(se}{it:#}{cmd:)}}standard error of expected duration for state {it:#}{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for state {it:#} {p_end}

{synoptset 12 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence interval (lower and upper) for expected duration for state {it:#}{p_end}
{p2colreset}{...}
