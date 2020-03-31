{smcl}
{* *! version 1.1.8  18feb2020}{...}
{viewerdialog predict "dialog ivpoisson_p"}{...}
{viewerdialog estat "dialog ivpoisson_estat"}{...}
{vieweralsosee "[R] ivpoisson postestimation" "mansection R ivpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivpoisson" "help ivpoisson"}{...}
{viewerjumpto "Postestimation commands" "ivpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ivpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "ivpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "ivpoisson postestimation##syntax_estat_overid"}{...}
{viewerjumpto "Examples" "ivpoisson postestimation##examples"}{...}
{viewerjumpto "Stored results" "ivpoisson postestimation##results"}{...}
{p2colset 1 33 26 2}{...}
{p2col:{bf:[R] ivpoisson postestimation} {hline 2}}Postestimation tools for ivpoisson{p_end}
{p2col:}({mansection R ivpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after 
{cmd:ivpoisson}:

{synoptset 14}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb ivpoisson postestimation##estatoverid:estat overid}}perform test of overidentifying restrictions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 14}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb ivpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb ivpoisson postestimation##predict:predict}}predictions and residuals{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection R ivpoissonpostestimationMethodsandformulas:Methods and formulas}

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
[{cmd:,} {it:statistic} {opt nooff:set}]

{synoptset 11 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt : {opt xbt:otal}}linear prediction, using
residual estimates for {opt ivpoisson cfunction}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
numbers of events, linear predictions, and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events via the
exponential-form estimate.  This is exp(x'b1+y2'b2) if neither {cmd:offset()}
nor {opt exposure()} was specified, exp(x'b1+y2'b2 + offset) if {cmd:offset()}
was specified, or exp(x'b1 + y2'b2)*exposure if {cmd:exposure()} was
 specified.  

{pmore}
After generalized method of moments estimation, the exponential-form estimate
is not a consistent estimate of the conditional mean of y, because it is not
corrected for E(e|y2).  More details are found in
{mansection R ivpoissonpostestimationMethodsandformulas:{it:Methods and formulas}}.

{pmore}
After control-function estimation, we correct the exponential-form
estimate for E(e|y2) by using the estimated residuals of
y2 and the {cmd:c_*} auxiliary parameters.  This supplements the
direct effect of y2 and x through b1 and
b2 with the indirect effects of y2, x, and the
instruments z through the endogenous error e.  Thus, the
exponential-form estimate consistently estimates the conditional mean of y.

{phang}
{opt xbtotal} calculates the linear prediction, which is x'b1+y2'b2 if neither
{cmd:offset()} nor {cmd:exposure()} was specified,
x'b1 + y2'b2 + offset if {cmd:offset()} was specified, or
x'b1+y2'b2 + ln(exposure) if {cmd:exposure()} was specified.

{pmore}
After control-function estimation, the estimate of the linear form x'b1
includes the estimated residuals of the endogenous regressors with
coefficients from the {cmd:c_*} auxiliary parameters.

{phang}
{opt xb} calculates the linear prediction, which is x'b1+y2'b2 if neither
{cmd:offset()} nor {cmd:exposure()} was specified,
x'b1+y2'b2 + offset if {cmd:offset()} was specified, or
x'b1+y2'b2 + ln(exposure) if {cmd:exposure()} was specified.
See {helpb ivpoisson_postestimation##nooffset:nooffset} below.

{phang}
{opt residuals} calculates the residuals.
Under additive errors, these are calculated as y-exp(x'b1+y2'b2).
Under multiplicative errors, they are calculated as y/exp(x'b1+y2'b2) - 1.  

{pmore}
When {cmd:offset()} or {cmd:exposure()} is specified, x'b1 is not used
directly in the residuals.  x'b1 + offset is used if {cmd:offset()} was
specified.  x'b1 + ln(exposure) is used if {cmd:exposure()} was specified.
See {helpb ivpoisson_postestimation##nooffset:nooffset} below.

{pmore}
After control-function estimation, the estimate of the linear form x'b1
includes the estimated residuals of the endogenous regressors with
coefficients from the {cmd:c_*} auxiliary parameters.

{marker nooffset}{...}
{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the
calculations made by {cmd:predict} so that they ignore the offset or exposure
variable. {cmd:nooffset} removes the offset from calculations involving both
the {cmd:treat()} equation and the dependent count variable.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}number of events; the default{p_end}
{synopt : {opt xbt:otal}}linear prediction, using
residual estimates for {opt ivpoisson cfunction}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
numbers of events and linear predictions.


{marker syntax_estat_overid}{...}
{marker estatoverid}{...}
{title:Syntax for estat}

{p 8 16 2}
{cmd:estat} {cmdab:over:id} 


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat} {cmd:overid} reports Hansen's J statistic, which is used to
determine the validity of the overidentifying restrictions in a GMM model.
{cmd:ivpoisson} {cmd:gmm} uses GMM estimation to obtain parameter estimates.
Under additive and multiplicative errors, Hansen's J statistic can be
accurately reported when more instruments than endogenous regressors are
specified.  It is not  appropriate to report the J statistic after
{cmd:ivpoisson} {cmd:cfunction}, because a just-identified model is fit.

{pstd}
If the model is correctly specified in the sense that
E{z u(y,x,y2,b)} =
0, then the sample analog to that condition should hold at the estimated
value of b1 and b2.  The z variables are the exogenous
regressors x and instrumental variables z used in
{cmd:ivpoisson} {cmd:gmm}.  The y2 are the endogenous regressors.
The u function is the error function, which will have a different form for
multiplicative and additive errors in the regression.

{pstd}
Hansen's J statistic is valid only if the weight matrix is optimal, meaning
that it equals the inverse of the covariance matrix of the moment conditions.
Therefore, {cmd:estat} {cmd:overid} only reports Hansen's J statistic after
two-step or iterated estimation or if you specified {opt winitial(matname)}
when calling {cmd:ivpoisson} {cmd:gmm}.  In the latter case, it is your
responsibility to determine the validity of the J statistic.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse website}{p_end}

{pstd}Generalized method of moments; additive errors{p_end}
{phang2}{cmd:. ivpoisson gmm visits ad female} 
	{cmd:(time = phone frfam)}{p_end}

{pstd}Test overidentifying restrictions{p_end}
{phang2}{cmd:. estat overid }{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse trip}{p_end}

{pstd}Control-function method{p_end}
{phang2}{cmd:. ivpoisson cfunction trips cbd ptn worker weekend}
	{cmd: (tcost=pt)}{p_end}

{pstd}Predict number of trips{p_end}
{phang2}{cmd:. predict double m} {p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat overid} stores the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Scalars}{p_end}
{synopt:{cmd:r(J)}}Hansen's J statistic{p_end}
{synopt:{cmd:r(J_df)}}J statistic degrees of freedom{p_end}
{synopt:{cmd:r(J_p)}}J statistic p-value{p_end}
