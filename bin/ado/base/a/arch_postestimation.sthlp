{smcl}
{* *! version 1.2.5  15may2018}{...}
{viewerdialog predict "dialog arch_p"}{...}
{vieweralsosee "[TS] arch postestimation" "mansection TS archpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch" "help arch"}{...}
{viewerjumpto "Postestimation commands" "arch_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "arch_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "arch_postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "arch_postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "arch_postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[TS] arch postestimation} {hline 2}}Postestimation tools for arch{p_end}
{p2col:}({mansection TS archpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:arch}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb arch_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb arch postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS archpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}predicted values for mean equation -- the differenced
		series; the default{p_end}
{synopt:{opt y}}predicted values for the mean equation in y -- the undifferenced series{p_end}
{synopt:{opt v:ariance}}predicted values for the conditional
		variance{p_end}
{synopt:{opt h:et}}predicted values of the variance, considering
		only the multiplicative heteroskedasticity{p_end}
{synopt:{opt r:esiduals}}residuals or predicted innovations{p_end}
{synopt:{opt yr:esiduals}}residuals or predicted innovations in
		y -- the undifferenced series{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

{marker options}{...}
{synoptset 35 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt:{opt d:ynamic(time_constant)}}how to handle the lags of y_t{p_end}
{synopt:{cmd:at(}{it:{help varname:varname_e}}|{it:#e} {it:varname_s2}|{it:#s2}{cmd:)}}make static predictions{p_end}
{synopt:{opt t0(time_constant)}}set starting point for the recursions to {it:time_constant}{p_end}
{synopt:{opt str:uctural}}calculate considering the structural component only{p_end}
{synoptline}
{p2colreset}{...}
{p 4 4 2}
{it:time_constant} is a {it:#} or a time literal, such as
{cmd:td(1jan1995)} or {cmd:tq(1995q1)}, etc.; see 
{it:{help datetime##s9:Conveniently typing SIF values}}
in 
{bf:[D] Datetime}.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as 
expected values and residuals.  All predictions are available as static
one-step-ahead predictions or as dynamic multistep predictions, and you can
control when dynamic predictions begin.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the predictions from the mean
   equation.  If {opt D.}{depvar} is the dependent variable, these predictions
   are of {opt D.}{it:depvar} and not of {it:depvar} itself.

{phang}
{opt y} specifies that predictions of {depvar} are to be made even
if the model was specified for, say, {opt D.}{it:depvar}.

{phang}
{opt variance} calculates predictions of the conditional variance.

{phang}
{opt het} calculates predictions of the multiplicative heteroskedasticity
   component of variance.

{phang}
{opt residuals} calculates the residuals.  If no other options are
   specified, these are the predicted innovations; that is, they include any
   ARMA component.  If the {opt structural} option is specified, these are the
   residuals from the mean equation, ignoring any ARMA terms; see
   {helpb arch postestimation##structural:structural} below.  The residuals are
    always from the estimated equation, which may have a differenced dependent
    variable; if {depvar} is differenced, they are not the residuals of the
    undifferenced {it:depvar}.

{phang}
{opt yresiduals} calculates the residuals for {depvar}, even
   if the model was specified for, say, {opt D.}{it:depvar}.  As with
   {opt residuals}, the {opt yresiduals} are computed from the model,
   including any ARMA component.  If the {opt structural} option is specified,
   any ARMA component is ignored and {opt yresiduals} are the residuals from
   the structural equation; see
   {helpb arch postestimation##structural:structural} below.

{dlgtab:Options}

{phang}
{opt dynamic(time_constant)} specifies how lags of y_t in the model are to be
   handled.  If {opt dynamic()} is not specified, actual values are used
   everywhere lagged values of y_t appear in the model to produce one-step-ahead
   forecasts.

{pmore}
   {opt dynamic(time_constant)} produces dynamic (also known as recursive)
   forecasts.  {it:time_constant} specifies when the forecast is to switch
   from one step ahead to dynamic.  In dynamic forecasts, references to y_t
   evaluate to the prediction of y_t for all periods at or after
   {it:time_constant}; they evaluate to the actual value of y_t for all prior
   periods.

{pmore}
   {cmd:dynamic(10)}, for example, would calculate predictions where any
   reference to y_t with t < 10 evaluates to the actual value of y_t and any
   reference to y_t with t {ul:>} 10 evaluates to the prediction of y_t.  This
   means that one-step-ahead predictions would be calculated for t < 10 and
   dynamic predictions would be calculated thereafter.  Depending on the lag
   structure of the model, the dynamic predictions might still refer to some
   actual values of y_t.

{pmore}
   You may also specify {cmd:dynamic(.)} to have {opt predict}
   automatically switch from one-step-ahead to dynamic predictions at p + q,
   where p is the maximum AR lag and q is the maximum MA lag.

{phang}
{cmd:at(}{it:{help varname:varname_e}}|{it:#e varname_s2}|{it:#s2}{cmd:)}
   makes static predictions.  {opt at()} and {opt dynamic()} may not be
   specified together.

{pmore}
   Specifying {opt at()} allows static evaluation of results for a given set of
   disturbances.  This is useful, for instance, in generating the news response
   function.  {opt at()} specifies two sets of values to be used for e_t and
   s_t^2, the dynamic components in the model.  These specifies values are
   treated as given.  Also, any lagged values of {depvar} in the model
   are obtained from the real values of the dependent variable.  All
   computations are based on actual data and the given values.

{pmore}
   {opt at()} requires that you specify two arguments,  which can either be a
   variable name or a number.  The first argument supplies the values to be
   used for e_t; the second supplies the values to be used for s_t^2.  If
   s_t^2 plays no role in your model, the second argument may be specified as
   '{opt .}' to indicate missing.

{phang}
{opt t0(time_constant)} specifies the starting point for the
   recursions to compute the predicted statistics; disturbances are assumed to
   be 0 for t < {opt t0()}.  The default is to set {opt t0()} to the
   minimum t observed in the estimation sample, meaning that observations
   before that are assumed to have disturbances of 0.

{pmore}
{opt t0()} is irrelevant if {opt structural} is specified because then
all observations are assumed to have disturbances of 0.

{pmore}
{cmd:t0(5)}, for example, would begin recursions at t = 5.  If your data were
   quarterly, you might instead type {cmd:t0(tq(1961q2))} to obtain the same
   result.

{pmore}
   Any ARMA component in the mean equation or GARCH term in the
   conditional-variance equation makes {opt arch} recursive and dependent on
   the starting point of the predictions.  This includes one-step-ahead
   predictions.

{marker structural}{...}
{phang}
{opt structural} makes the calculation considering the structural component
   only, ignoring any ARMA terms, and producing the steady-state equilibrium
   predictions.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr:statistic}
{synoptline}
{synopt:{opt xb}}predicted values for mean equation -- the differenced
		series; the default{p_end}
{synopt:{opt y}}predicted values for the mean equation in y -- the undifferenced series{p_end}
{synopt:{opt v:ariance}}predicted values for the conditional
		variance{p_end}
{synopt:{opt h:et}}predicted values of the variance, considering
		only the multiplicative heteroskedasticity{p_end}
{synopt:{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt:{opt yr:esiduals}}not allowed with {cmd:margins}{p_end}
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

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse wpi1}{p_end}

{pstd}Fit EGARCH model{p_end}
{phang2}{cmd:. arch D.ln_wpi, ar(1) ma(1,4) earch(1) egarch(1)}{p_end}

{pstd}Create variable that ranges from about -4 to 4{p_end}
{phang2}{cmd:. generate et = (_n-64)/15}{p_end}

{pstd}Static prediction of the conditional variance assuming lagged variance
is one for values of e_t ranging from -4 to 4{p_end}
{phang2}{cmd:. predict sigma2, variance at(et 1)}{p_end}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wpi1, clear}

{pstd}Impose declining lag structure{p_end}
{phang2}{cmd:. constraint 1 (3/4)*[ARCH]l1.arch = [ARCH]l2.arch}{p_end}
{phang2}{cmd:. constraint 2 (2/4)*[ARCH]l1.arch = [ARCH]l3.arch}{p_end}
{phang2}{cmd:. constraint 3 (1/4)*[ARCH]l1.arch = [ARCH]l4.arch}

{pstd}Fit ARCH model with constraints{p_end}
{phang2}{cmd:. arch D.ln_wpi, ar(1) ma(1 4) arch(1/4) constraints(1 2 3)}

{pstd}Estimate alpha parameter of the model for the conditional variance{p_end}
{phang2}{cmd:. lincom [ARCH]l1.arch/.4}{p_end}

    {hline}
