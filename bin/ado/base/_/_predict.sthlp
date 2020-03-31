{smcl}
{* *! version 1.1.9  19oct2017}{...}
{vieweralsosee "[P] _predict" "mansection P _predict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] predict" "help predict"}{...}
{vieweralsosee "[P] _pred_se" "help _pred_se"}{...}
{viewerjumpto "Syntax" "_predict##syntax"}{...}
{viewerjumpto "Description" "_predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "_predict##linkspdf"}{...}
{viewerjumpto "Options" "_predict##options"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] _predict} {hline 2}}Obtain predictions, residuals, etc., after estimation programming command{p_end}
{p2col:}({mansection P _predict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}After regress

{p 8 17 2}{cmd:_predict} {dtype} {newvar}
        {ifin} [{cmd:,} {opt xb} {opt stdp} {opt stdf} {opt stdr}
        {opt h:at} {opt c:ooksd} {opt re:siduals} {opt rsta:ndard}
        {opt rstu:dent} {opt nolab:el}]


{phang}After single-equation (SE) estimators

{p 8 17 2}{cmd:_predict} {dtype} {newvar}
        {ifin} [{cmd:,} {opt xb} {opt stdp} {opt nooff:set} {opt nolab:el}]


{phang}After multiple-equation (ME) estimators

{p 8 17 2}{cmd:_predict} {dtype} {newvar}
        {ifin} [{cmd:,} {opt xb} {opt stdp} {opt stddp}
        {opt nooff:set} {opt nolab:el} 
        {cmdab:e:quation(}{it:eqno}[{cmd:,} {it:eqno}]{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_predict} is for use by programmers as a subroutine for implementing
the {cmd:predict} command for use after estimation; see
{manhelp predict R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P _predictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:xb} calculates the linear prediction from the fitted model.  That is,
all models can be thought of as estimating a set of parameters b1, b2, ..., bk,
and the linear prediction is y = xb.  For linear regression, the
values y are called the predicted values or, for out-of-sample predictions, 
the forecast.  For logit and probit, for example, y is called the 
logit or probit index.

{pmore}
It is important to understand that the x1, x2, ..., xk used in the calculation
are obtained from the data currently in memory and do not have to correspond
to the data on the independent variables used in fitting the model (obtaining
the b1, b2, ..., bk).

{phang}
{cmd:stdp} calculates the standard error of the prediction after any
estimation command.  Here the prediction is understood to mean the same thing
as the "index", namely, xb.  The statistic produced by {cmd:stdp} can be
thought of as the standard error of the predicted expected value, or mean
index, for the observation's covariate pattern.  This is commonly referred to
as the standard error of the fitted value.

{phang}
{cmd:stdf} calculates the standard error of the forecast, which is the standard error of the point prediction for 1 observation.  It is commonly 
referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {cmd:stdf} are always larger
than those produced by {cmd:stdp}; see
{mansection R predictMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] predict}.

{phang} {cmd:stdr} calculates the standard error of the residuals.

{phang}
{cmd:hat} (or {cmd:leverage}) calculates the diagonal elements of the
projection hat matrix.

{phang}
{cmd:cooksd} calculates the Cook's D influence statistic.

{phang}
{cmd:residuals} calculates the residuals.

{phang}
{cmd:rstandard} calculates the standardized residuals.

{phang}
{cmd:rstudent} calculates the Studentized (jackknifed) residuals.

{phang}
{cmd:nooffset} may be combined with most statistics and specifies that the
calculation be made, ignoring any offset or exposure variable specified when
the model was fit.

{pmore}
This option is available, even if not documented, for {cmd:predict} after a
specific command.  If neither the {opth offset(varname)} option nor the 
{opt exposure(varname)} option was specified when the model was fit,
specifying {opt nooffset} does nothing.

{phang}
{cmd:nolabel} prevents {cmd:_predict} from labeling the newly created
variable.

{phang}
{cmd:stddp} is allowed only after you have previously fit a
multiple-equation model.  The standard error of the difference in linear
predictions between equations 1 and 2 is calculated.
Use the {cmd:equation()} option to get the standard error of the difference
between other equations.

{phang}
{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} is relevant only when you
have previously fit a multiple-equation model.  It specifies the
equation to which you are referring.

{pmore}
{cmd:equation()} is typically filled in with one {it:eqno} -- it would be
filled in that way with options {cmd:xb} and {cmd:stdp}, for instance.  
{cmd:equation(#1)} would mean that the calculation is to be made for the first
equation, {cmd:equation(#2)} would mean the second, and so on. 
You could also refer to the equations by their names: {cmd:equation(income)}
would refer to the equation name {cmd:income} and {cmd:equation(hours)} to the
equation named {cmd:hours}.

{pmore}
If you do not specify {cmd:equation()}, the results are the same as if you
specified {cmd:equation(#1)}.

{pmore}
Other statistics refer to between-equation concepts; {cmd:stddp} is an
example.  In those cases, you might specify {cmd:equation(#1,#2)} or
{cmd:equation(income,hours)}.  When two equations must be specified,
{cmd:equation()} is required.
{p_end}
