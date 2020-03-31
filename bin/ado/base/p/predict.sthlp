{smcl}
{* *! version 1.1.11  31may2018}{...}
{viewerdialog predict "dialog predict"}{...}
{vieweralsosee "[R] predict" "mansection R predict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _predict" "help _predict"}{...}
{vieweralsosee "[R] predictnl" "help predictnl"}{...}
{vieweralsosee "[P] _pred_se" "help _pred_se"}{...}
{viewerjumpto "Syntax" "predict##syntax"}{...}
{viewerjumpto "Menu" "predict##menu_predict"}{...}
{viewerjumpto "Description" "predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "predict##linkspdf"}{...}
{viewerjumpto "Options" "predict##options"}{...}
{viewerjumpto "Examples" "predict##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] predict} {hline 2}}Obtain predictions, residuals, etc., after
estimation{p_end}
{p2col:}({mansection R predict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
After single-equation (SE) models

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help predict##single_options:single_options}}]


{phang}
After multiple-equation (ME) models

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
 {it:{help predict##multiple_options:multiple_options}}] 

{p 8 16 2}
{cmd:predict} {dtype}
 {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar1}} ... {it:{help newvar:newvarq}}{c )-}
{ifin} {cmd:,} {opt sc:ores}


{synoptset 23 tabbed}{...}
{marker single_options}
{synopthdr :single_options}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}calculate linear prediction{p_end}
{synopt :{opt stdp}}calculate standard error of the prediction{p_end}
{synopt :{opt sc:ore}}calculate first derivative of the log likelihood with
respect to xb{p_end}

{syntab :Options}
{synopt :{opt nooff:set}}ignore any {opt offset()} or {opt exposure()}
variable{p_end}
{synopt :{it:other_options}}command-specific options{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{marker multiple_options}{...}
{synopthdr :multiple_options}
{synoptline}
{syntab :Main}
{synopt :{opt eq:uation}{cmd:(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)}}specify equations{p_end}
{synopt :{opt xb}}calculate linear prediction{p_end}
{synopt :{opt stdp}}calculate standard error of the prediction{p_end}
{synopt :{opt stddp}}calculate the difference in linear predictions{p_end}

{syntab :Options}
{synopt :{opt nooff:set}}ignore any {opt offset()} or {opt exposure()} variable{p_end}
{synopt :{it:other_options}}command-specific options{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker description}{...}
{title:Description}

{pstd}
{cmd:predict} calculates predictions, residuals, influence statistics, and the
like after estimation.  Exactly what {cmd:predict} can do is determined by the
previous estimation command; command-specific options are documented with each
estimation command.  Regardless of command-specific options, the actions of
{cmd:predict} share certain similarities across estimation commands:

{phang2}1.{space 2}{cmd:predict} {newvar} creates {it:newvar} containing
"predicted values" -- numbers related to the {it:E}(y|x).  For instance,
after linear regression, {cmd:predict} {it:newvar} creates xb and, after
probit, creates the probability F(xb).

{phang2}2.{space 2}{cmd:predict} {newvar}{cmd:,} {opt xb} creates {it:newvar}
containing xb.  This may be the same result as option 1 (for example, linear
regression) or different (for example, probit), but regardless, option {opt xb}
is allowed.

{phang2}3.{space 2}{cmd:predict} {newvar}{cmd:,} {opt stdp} creates
{it:newvar} containing the standard error of the linear prediction xb.

{phang2}4.{space 2}{cmd:predict} {newvar}{cmd:,} {it:other_options} may
create {it:newvar} containing other useful quantities; see {cmd:help} or the
reference  manual entry for the particular estimation command to find out
about other available options.

{phang2}5.{space 2}{cmd:nooffset} added to any of the above commands
requests that the calculation ignore any offset or exposure variable
specified by including the {opth offset:(varname:varname_o)} or
{opt exposure(varname_e)} option when you fit the model.  

{pstd}
{cmd:predict} can be used to make in-sample or out-of-sample predictions:

{phang2}6.{space 2}{cmd:predict} calculates the requested
statistic for all possible observations, whether they were used in fitting
the model or not.  {cmd:predict} does this for the standard options 1
through 3 and generally does this for estimator-specific options 4.

{phang2}7.{space 2}{cmd:predict} {newvar} {cmd:if e(sample),} {it:...}
restricts the prediction to the estimation subsample.

{phang2}8.{space 2}Some statistics make sense only with respect to the
estimation subsample.  In such cases, the calculation is automatically
restricted to the estimation subsample, and the documentation for the specific
option states this.  Even so, you can still specify {cmd:if e(sample)} if you
are uncertain.

{phang2}9.{space 2}{cmd:predict} can make out-of-sample predictions even
using other datasets.  In particular, you can

{pmore2}{cmd:. use ds1}{p_end}
             {it:(fit a model)}
{pmore2}{cmd:. use two} {space 12} /* another dataset         */{p_end}
{pmore2}{cmd:. predict yhat,} {it:...} {space 2} /* fill in the predictions */


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R predictQuickstart:Quick start}

        {mansection R predictRemarksandexamples:Remarks and examples}

        {mansection R predictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:xb} calculates the linear prediction from the fitted model.  That is,
all models can be thought of as estimating a set of parameters b1, b2, ..., bk,
and the linear prediction is y = xb.  For linear regression, the
values y are called the predicted values or, for out-of-sample predictions, 
the forecast.  For logit and probit, for example, y is called the 
logit or probit index.

{pmore}
x1, x2, ..., xk are obtained from the data currently in memory and do not
necessarily correspond to the data on the independent variables used to fit
the model (obtaining the b1, b2, ..., bk).

{phang}
{cmd:stdp} calculates the standard error of the linear prediction.  Here the
prediction means the same thing as the "index", namely, xb.  The statistic
produced by {cmd:stdp} can be thought of as the standard error of the predicted
expected value, or mean index, for the observation's covariate pattern.  The
standard error of the prediction is also commonly referred to as the standard
error of the fitted value. The calculation can be made in or out of sample.

{phang}
{opt stddp} is allowed only after you have previously fit a
multiple-equation model.  The standard error of the difference in linear
predictions between two equations is calculated.  This option requires that
{opt equation(eqno1,eqno2)} be specified.

{phang}
{opt score} calculates the equation-level score; this is usually the
derivative of the log likelihood with respect to the linear prediction.

{phang}
{opt scores} is the ME model equivalent of the {opt score} option, resulting
in multiple equation-level score variables.  An equation-level score variable
is created for each equation in the model; ancillary parameters -- such as
ln(sigma) and atanh(rho) -- make up separate equations.

{phang}
{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} -- synonym
{opt outcome()} -- is relevant only when you have previously fit a
multiple-equation model.  It specifies the equation to which you are
referring.

{pmore}
{opt equation()} is typically filled in with one {it:eqno} -- it would
be filled in that way with options {opt xb} and {opt stdp}, for instance.
{cmd:equation(#1)} would mean the calculation is to be made for the first
equation, {cmd:equation(#2)} would mean the second, and so on.  You could
also refer to the equations by their names.  {cmd:equation(income)} would
refer to the equation named income and {cmd:equation(hours)} to the equation
named hours.

{pmore}
If you do not specify {opt equation()}, results are the same as if you
specified {cmd:equation(#1)}.

{pmore}
Other statistics, such as {opt stddp}, refer to between-equation concepts.
In those cases, you might specify {cmd:equation(#1,#2)} or 
{cmd:equation(income,hours)}.  When two equations must be specified, 
{opt equation()} is required.

{dlgtab:Options}

{phang}
{opt nooffset} may be combined with most statistics and specifies that
the calculation should be made, ignoring any offset or exposure variable
specified when the model was fit.  

{pmore}
This option is available, even if not documented for {opt predict} after a
specific command.  If neither the {opth offset:(varname:varname_o)} option nor
the {opt exposure(varname_e)} option was specified when the model was fit,
specifying {opt nooffset} does nothing.

{phang}
{it:other_options} refers to command-specific options that are documented with
each command.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight if foreign}

{pstd}Obtain predictions for just the sample on which we fit the model
{p_end}
{phang2}{cmd:. predict pmpg if e(sample)}{p_end}

{pstd}Obtain out-of-sample prediction using all 74 observations of same dataset
{p_end}
{phang2}{cmd:. predict pmpg2}

{pstd}{cmd:cooksd} is a regression-specific option; see
        {manhelp regress_postestimation R:regress postestimation}{p_end}
{phang2}{cmd:. predict c, cooksd}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. generate weight2 = weight^2}{p_end}
{phang2}{cmd:. regress mpg weight weight2 foreign}{p_end}
{phang2}{cmd:. webuse newautos, clear}{p_end}
{phang2}{cmd:. generate weight2 = weight^2}{p_end}

{pstd}Obtain out-of-sample prediction using another dataset{p_end}
{phang2}{cmd:. predict mpg}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. generate weight2 = weight^2}{p_end}
{phang2}{cmd:. regress mpg weight weight2 foreign}{p_end}

{pstd}Obtain residuals{p_end}
{phang2}{cmd:. predict double resid, residuals}{p_end}
{phang2}{cmd:. summarize resid}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. logistic foreign mpg weight}{p_end}

{pstd}Obtain probability of a positive outcome; see
         {manhelp logistic_postestimation R:logistic postestimation}{p_end}
{phang2}{cmd:. predict phat}{p_end}

{pstd}Obtain linear prediction{p_end}
{phang2}{cmd:. predict idxhat, xb}{p_end}
{phang2}{cmd:. summarize foreign phat idxhat}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse airline, clear}{p_end}
{phang2}{cmd:. poisson injuries XYZowned}{p_end}

{pstd}Obtain predicted count; see
        {manhelp poisson_postestimation R:poisson postestimation}{p_end}
{phang2}{cmd:. predict injhat}{p_end}

{pstd}Obtain linear prediction{p_end}
{phang2}{cmd:. predict idx, xb}{p_end}
{phang2}{cmd:. generate exp_idx = exp(idx)}{p_end}
{phang2}{cmd:. summarize injuries injhat exp_idx idx}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. logistic foreign mpg weight}{p_end}

{pstd}Obtain single-equation model scores{p_end}
{phang2}{cmd:. predict double sc, score}{p_end}
{phang2}{cmd:. summarize sc}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. sureg (price foreign displ) (weight foreign length)}{p_end}

{pstd}Obtain linear prediction for {cmd:price} equation{p_end}
{phang2}{cmd:. predict pred_p, equation(price)}{p_end}

{pstd}Obtain linear prediction for {cmd:weight} equation{p_end}
{phang2}{cmd:. predict pred_w, equation(weight)}{p_end}
{phang2}{cmd:. summarize price pred_p weight pred_w}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. ologit rep78 mpg weight}{p_end}

{pstd}Obtain multiple-equation model scores{p_end}
{phang2}{cmd:. predict double sc*, scores}{p_end}
{phang2}{cmd:. summarize sc*}{p_end}
    {hline}
