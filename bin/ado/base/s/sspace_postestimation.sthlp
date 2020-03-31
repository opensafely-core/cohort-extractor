{smcl}
{* *! version 1.1.3  15may2018}{...}
{viewerdialog predict "dialog sspace_p"}{...}
{vieweralsosee "[TS] sspace postestimation" "mansection TS sspacepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{vieweralsosee "[TS] dfactor postestimation" "help dfactor_postestimation"}{...}
{viewerjumpto "Postestimation commands" "sspace postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "sspace_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "sspace postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "sspace postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[TS] sspace postestimation} {hline 2}}Postestimation tools for
sspace{p_end}
{p2col:}({mansection TS sspacepostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after {cmd:sspace}:

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
{synopt :{helpb sspace postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS sspacepostestimationRemarksandexamples:Remarks and examples}

        {mansection TS sspacepostestimationMethodsandformulas:Methods and formulas}

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
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}observable variables{p_end}
{synopt :{opt st:ates}}latent state variables{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab :Options}
{synopt :{opt eq:uation(eqnames)}}name(s) of equation(s) for which
          predictions are to be made{p_end}
{synopt :{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)}}put
       estimated root mean squared errors of predicted statistics in new
       variables
{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified time
{p_end}

{syntab :Advanced}
{synopt :{opt smeth:od(method)}}method for predicting unobserved states{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 17 tabbed}{...}
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
{cmd:predict} creates a new variable containing predictions such as expected
values.  The root mean squared error is available for all predictions.  All
predictions are also available as static one-step-ahead predictions or as
dynamic multistep predictions, and you can control when dynamic predictions
begin.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, {opt states}, {opt residuals}, and {opt rstandard} specify the
statistic to be predicted.

{phang2}
{cmd:xb}, the default, calculates the linear predictions of the observed
variables. 

{phang2}
{cmd:states} calculates the linear predictions of the latent state
variables.

{phang2}
{cmd:residuals} calculates the residuals in the equations for observable
variables.  {cmd:residuals} may not be specified with {cmd:dynamic()}.

{phang2}
{cmd:rstandard} calculates the standardized residuals, which are the
residuals normalized to be uncorrelated and to have unit variances.
{cmd:rstandard} may not be specified with {cmd:smethod(filter)},
{cmd:smethod(smooth)}, or {cmd:dynamic()}.

{dlgtab:Options}

{phang}
{opt equation(eqnames)} specifies the equation(s) for which the
predictions are to be calculated.  If you do not specify {opt equation()} or
{it:stub}{cmd:*}, the results are the same as if you had specified the name of
the first equation for the predicted statistic.

{pmore}
You specify a list of equation names, such as
{cmd:equation(income consumption)} or {cmd:equation(factor1 factor2)}, to
identify the equations.  Specify names of state equations when predicting
{cmd:states} and names of observable equations in all other cases.

{pmore}
{cmd:equation()} may not be specified with {it:stub}{cmd:*}.

{phang}
{cmd:rmse(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{cmd:)} puts the root mean
squared errors of the predicted statistics into the specified new variables.
The root mean squared errors measure the variances due to the disturbances but
do not account for estimation error.

{phang}
{opt dynamic(time_constant)} specifies when {opt predict} starts
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {opt tsset}, and the {it:time_constant}
must be inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2008q4))} causes dynamic predictions
to begin in the fourth quarter of 2008, assuming that your time variable is
quarterly; see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {opt dynamic()} may not be specified with {opt rstandard}, 
{opt residuals}, or {cmd:smethod(smooth)}.

{dlgtab:Advanced}

{phang}
{opt smethod(method)} specifies the method for predicting the
unobserved states; {cmd:smethod(onestep)}, {cmd:smethod(filter)}, and
{cmd:smethod(smooth)} cause different amounts of information on the dependent
variables to be used in predicting the states at each time period.

{phang2}
{cmd:smethod(onestep)}, the default, causes {opt predict} to estimate the
states at each time period using previous information on the dependent
variables.  The Kalman filter is performed on previous periods, but
only the one-step predictions are made for the current period.  

{phang2}
{cmd:smethod(smooth)} causes {cmd:predict} to estimate the states at each
time period using all the sample data by the Kalman smoother.
{cmd:smethod(smooth)} may not be specified with {cmd:rstandard}.

{phang2}
{cmd:smethod(filter)} causes {cmd:predict} to estimate the states at each
time period using previous and contemporaneous data by the Kalman filter.
The Kalman filter is performed on previous periods and the current
period. {cmd:smethod(filter)} may be specified only with {cmd:states}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dfex}{p_end}
{phang2}{cmd:. constraint 1 [lf]L.f = 1}{p_end}
        {cmd:. sspace (f L.f L.lf, state noconstant)     ///}
                 {cmd:(lf L.f, state noconstant noerror) ///}
                 {cmd:(D.ipman f, noconstant)            ///}
                 {cmd:(D.income f, noconstant)           ///}
                 {cmd:(D.hours f, noconstant)            ///}
                 {cmd:(D.unemp f, noconstant),           ///}
                 {cmd:covstate(identity) constraints(1)}

{pstd}Produce in-sample forecasts for the four observed series and
graph {cmd:D.ipman} and its forecast{p_end}
{phang2}{cmd:. predict dep*}{p_end}
{phang2}{cmd:. tsline D.ipman dep1}

{pstd}Forecast changes in {cmd:ipman} 6 months into the future, using
dynamic predictions starting in December 2008, and then graph the series{p_end}
{phang2}{cmd:. tsappend, add(6)}{p_end}
{phang2}{cmd:. predict Dipman_f, dynamic(tm(2008m12)) equation(D.ipman)}{p_end}
{phang2}{cmd:. tsline D.ipman Dipman_f if month>=tm(2008m1), xtitle("")}
                  {cmd:legend(rows(2))}{p_end}

{pstd}Predict the unobserved factor using the Kalman smoother and graph it
along with {cmd:D.ipman}{p_end}
{phang2}{cmd:. predict fac if e(sample), states smethod(smooth) equation(f)}
{p_end}
{phang2}{cmd:. tsline D.ipman fac, xtitle("") legend(rows(2))}{p_end}
