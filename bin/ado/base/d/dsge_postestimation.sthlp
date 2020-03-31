{smcl}
{* *! version 1.0.5  25feb2019}{...}
{viewerdialog predict "dialog dsge_p"}{...}
{vieweralsosee "[DSGE] dsge postestimation" "mansection DSGE dsgepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge" "help dsge"}{...}
{vieweralsosee "[DSGE] estat policy" "help estat policy"}{...}
{vieweralsosee "[DSGE] estat stable" "help dsge estat stable"}{...}
{vieweralsosee "[DSGE] estat transition" "help dsge estat transition"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{viewerjumpto "Postestimation commands" "dsge postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsge_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "dsge postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "dsge postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[DSGE] dsge postestimation} {hline 2}}Postestimation tools for 
dsge{p_end}
{p2col:}({mansection DSGE dsgepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:dsge}:

{synoptset 26}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat policy}}display policy matrix
	of estimated model{p_end}
{synopt :{helpb dsge estat stable:estat stable}}assess stability 
	of the system{p_end}
{synopt :{helpb dsge estat transition:estat transition}}display
	 transition matrix of estimated model{p_end}
{synopt :{helpb irf}}create and analyze IRFs and FEVDs{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 26}{...}
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
{synopt :{helpb dsge_postestimation##predict:predict}}one-step-ahead
predictions, prediction errors, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE dsgepostestimationRemarksandexamples:Remarks and examples}

        {mansection DSGE dsgepostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{marker statistic}{...}
{synoptset 26 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{cmd:xb}}linear prediction for observed variables{p_end}
{synopt :{opt st:ates}}linear prediction for latent state variables{p_end}
{synoptline}

{marker options}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)}}put estimated root mean squared errors of predicted statistics in new variables{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified
time{p_end}

{syntab:Advanced}
{synopt :{opt smeth:od(method)}}method for predicting unobserved states{p_end}
{synoptline}

{synoptset 26}{...}
{synopthdr:method}
{synoptline}
{synopt :{opt onestep}}predict using past information{p_end}
{synopt :{opt filter}}predict using past and contemporaneous
information{p_end}
{synoptline}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{opt predict} creates new variables containing predictions such
as expected values. Predictions are available as static one-step-ahead
predictions or as dynamic multistep predictions, and you can control 
when dynamic predictions begin.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear predictions of the
observed variables.

{phang}
{opt states} calculates the linear predictions of the latent
state variables.

{dlgtab:Options}

{phang}
{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)} puts the root
mean squared errors of the predicted statistics into the specified new
variables.  The root mean squared errors measure the variances due to the
disturbances but do not account for estimation error.

{phang}
{opt dynamic(time_constant)} specifies when {cmd:predict} starts
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {cmd:tsset}, and the
{it:time_constant} must be inside a sample for which observations on the
dependent variables are available.  For example, {cmd:dynamic(tq(2008q4))}
causes dynamic predictions to begin in the fourth quarter of 2008, assuming
that your time variable is quarterly; see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.

{dlgtab:Advanced}

{phang}
{opt smethod(method)} specifies the method for predicting the
unobserved states, {cmd:smethod(onestep)} and {cmd:smethod(filter)}, and  
causes different amounts of information on the dependent
variables to be used in predicting the states at each time period.

{phang2}
{cmd:smethod(onestep)}, the default, causes {cmd:predict} to estimate the
states at each time period using previous information on the dependent
variables.  The Kalman filter is performed on previous periods, but
only the one-step predictions are made for the current period.

{phang2}
{cmd:smethod(filter)} causes {cmd:predict} to estimate the states at each
time period using previous and contemporaneous data by the Kalman filter.
The Kalman filter is performed on previous periods and the current
period. {cmd:smethod(filter)} may be specified only with {cmd:states}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rates2}{p_end}
{phang2}{cmd:. generate p = 400*(ln(gdpdef) - ln(L.gdpdef))}{p_end}
{phang2}{cmd:. label variable p "Inflation rate"}{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*E(F.p) + {c -(}kappa{c )-}*x)}
         {cmd:(x = E(F.x) -(r - E(F.p) - g), unobserved)}
         {cmd:(r = (1/{c -(}beta{c )-})*p + u)}
         {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
         {cmd:(F.g = {c -(}rhoz{c )-}*g, state)}

{pstd}Obtain an estimate of 1/beta{p_end}
{phang2}{cmd:. nlcom 1/_b[beta]}

{pstd}Obtain the policy matrix{p_end}
{phang2}{cmd:. estat policy}

{pstd}Obtain the transition matrix{p_end}
{phang2}{cmd:. estat transition}

{pstd}Graph an IRF{p_end}
{phang2}{cmd:. irf set nkirf.irf}{p_end}
{phang2}{cmd:. irf create model1}{p_end}
{phang2}{cmd:. irf graph irf, impulse(u) response(x p r u) byopts(yrescale)}

{pstd}Store the previous {cmd:dsge} estimation results{p_end}
{phang2}{cmd:. estimates store dsge_est}

{pstd}Extend the dataset by 3 years or 12 quarters{p_end}
{phang2}{cmd:. tsappend, add(12)}

{pstd}Setup a forecast{p_end}
{phang2}{cmd:. forecast create dsgemodel}{p_end}
{phang2}{cmd:. forecast estimates dsge_est}{p_end}
{phang2}{cmd:. forecast solve, prefix(d1_) begin(tq(2017q1))}

{pstd}Graph the forecast for inflation {cmd:d1_p}{p_end}
{phang2}{cmd:. tsline d1_p if tin(2010q1, 2021q1), tline(2017q1)}{p_end}
