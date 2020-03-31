{smcl}
{* *! version 1.2.4  15may2018}{...}
{viewerdialog predict "dialog dfactor_p"}{...}
{vieweralsosee "[TS] dfactor postestimation" "mansection TS dfactorpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] sspace postestimation" "help sspace_postestimation"}{...}
{viewerjumpto "Postestimation commands" "dfactor postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "dfactor_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "dfactor postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "dfactor postestimation##examples"}{...}
{p2colset 1 32 36 2}{...}
{p2col:{bf:[TS] dfactor postestimation} {hline 2}}Postestimation tools for dfactor{p_end}
{p2col:}({mansection TS dfactorpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after {cmd:dfactor}:

{synoptset 17}{...}
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
{synopt :{helpb dfactor postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
	

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS dfactorpostestimationRemarksandexamples:Remarks and examples}

        {mansection TS dfactorpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-} 
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 17 tabbed}{...}
{synopthdr: statistic}
{synoptline}
{syntab :Main}
{synopt :{opt y}}dependent variable, which is {opt xbf} + {opt residuals}{p_end}
{synopt :{opt xb}}linear predictions using the observable independent variables
{p_end}
{synopt :{opt xbf}}linear predictions using the observable
       independent variables plus the factor contributions{p_end}
{synopt :{opt fac:tors}}unobserved factor variables{p_end}
{synopt :{opt r:esiduals}}autocorrelated disturbances{p_end}
{synopt :{opt in:novations}}innovations, the observed dependent
        variable minus the predicted {opt y}{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{synoptset 26 tabbed}{...}
{synopthdr: options}
{synoptline}
{syntab :Options}
{synopt :{opt eq:uation(eqnames)}}specify name(s) of equation(s) 
     for which predictions are to be made{p_end}
{synopt :{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)}}put estimated
     root mean squared errors of predicted objects in new variables{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified time
     {p_end}

{syntab :Advanced}
{synopt :{opt smeth:od(method)}}method for predicting unobserved states{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 17}{...}
{synopthdr :method}
{synoptline}
{synopt :{opt on:estep}}predict using past information{p_end}
{synopt :{opt sm:ooth}}predict using all sample information{p_end}
{synopt :{opt fi:lter}}predict using past and contemporaneous information{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
expected values, unobserved factors, autocorrelated disturbances, and
innovations.  The root mean squared error is available for all predictions.
All predictions are also available as static one-step-ahead predictions or as
dynamic multistep predictions, and you can control when dynamic predictions
begin.


{marker options_predict}{...}
{title:Options for predict}

{pstd}
The mathematical notation used in this section is defined in 
{it:{mansection TS dfactorDescription:Description}} of 
{bf:[TS] dfactor}.

{dlgtab:Main}

{phang}
{cmd:y}, {cmd:xb}, {cmd:xbf}, {cmd:factors}, {cmd:residuals}, and
{cmd:innovations} specify the statistic to be predicted.

{phang2}
{cmd:y}, the default, predicts the dependent variables. The predictions
include the contributions of the unobserved factors, the linear predictions
by using the observable independent variables, and any autocorrelation.

{phang2}
{cmd:xb} calculates the linear prediction by using the observable independent
variables.

{phang2}
{cmd:xbf} calculates the contributions of the unobserved factors plus the
linear prediction by using the observable independent variables.

{phang2}
{cmd:factors} estimates the unobserved factors.

{phang2}
{cmd:residuals} calculates the autocorrelated residuals.

{phang2}
{cmd:innovations} calculates the innovations.

{dlgtab:Options}

{phang}
{opt equation(eqnames)} specifies the equation(s) for which the
predictions are to be calculated.

{pmore}
You specify equation names, such as {cmd:equation(income consumption)}
or {cmd:equation(factor1 factor2)}, to identify the equations.  
For the {cmd:factors} statistic, you must specify names of equations for
factors; for all other statistics, you must specify names of equations for
observable variables. 

{pmore}
If you do not specify {opt equation()} and do not specify {it:stub}{cmd:*},
the results are the same as if you had specified the name of the first equation
for the predicted statistic.

{pmore}
{opt equation()} may not be specified with {it:stub}{cmd:*}.

{phang} 
{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)} puts the root mean
squared errors of the predicted objects into the specified new variables.  The
root mean squared errors measure the variances due to the disturbances but do
not account for estimation error.

{phang}
{opt dynamic(time_constant)} specifies when {opt predict} starts
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {cmd:tsset}, and the {it:time_constant}
must be inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2008q4))} causes dynamic predictions
to begin in the fourth quarter of 2008, assuming that your time variable is
quarterly, see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {opt dynamic()} may not be specified with {opt xb}, {opt xbf},
{opt innovations}, {cmd:smethod(filter)}, or {cmd:smethod(smooth)}.

{dlgtab:Advanced}

{phang}
{opt smethod(method)} specifies the method used to predict the
unobserved states in the model. 
{opt smethod()} may not be specified with {opt xb}.

{phang2}
{cmd:smethod(onestep)}, the default, causes {opt predict} to use previous
information on the dependent variables.  The Kalman filter is performed
on previous periods, but only the one-step predictions are made for the
current period.  

{phang2}
{cmd:smethod(smooth)} causes {opt predict} to estimate the states at each
time period using all the sample data by the Kalman smoother.

{phang2}
{cmd:smethod(filter)} causes {opt predict} to estimate the states at each
time period using previous and contemporaneous data by the Kalman filter.
The Kalman filter is performed on previous periods and the current
period.  {cmd:smethod(filter)} may be specified only with {cmd:factors}
and {cmd:residuals}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dfex}{p_end}
{phang2}{cmd:. dfactor (D.(ipman income hours unemp) = , noconstant ar(1))}
        {cmd:(f = , ar(1/2))}{p_end}

{pstd}Forecast changes in {cmd:ipman} 6 months into the future, using
dynamic predictions starting in December 2008, and then graph the series{p_end}
{phang2}{cmd:. tsappend, add(6)}{p_end}
{phang2}{cmd:. predict Dipman_f, dynamic(tm(2008m12)) equation(D.ipman)}{p_end}
{phang2}{cmd:. tsline D.ipman Dipman_f if month>=tm(2008m1),}
            {cmd:xtitle("") legend(rows(2))}{p_end}

{pstd}Predict and graph the unobserved factor along with changes in {cmd:ipman}
{p_end}
{phang2}{cmd:. predict fac if e(sample), factor}{p_end}
{phang2}{cmd:. tsline D.ipman fac, lcolor(gs10) xtitle("") legend(rows(2))}
{p_end}
