{smcl}
{* *! version 1.4.10  14apr2019}{...}
{viewerdialog predict "dialog streg_p"}{...}
{viewerdialog stcurve "dialog stcurve"}{...}
{vieweralsosee "[ST] streg postestimation" "mansection ST stregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{viewerjumpto "Postestimation commands" "streg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "streg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "streg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "streg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "streg postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[ST] streg postestimation} {hline 2}}Postestimation tools for streg{p_end}
{p2col:}({mansection ST stregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after {cmd:streg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb stcurve}}plot the survivor, hazard, and cumulative hazard functions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb streg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb streg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy} estimation
results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ST stregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {it:options}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{c )-}
{ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt med:ian} {opt time}}median survival time; the default{p_end}
{synopt :{opt med:ian} {opt lnt:ime}}median ln(survival time){p_end}
{synopt :{opt mean time}}mean survival time{p_end}
{synopt :{opt mean} {opt lnt:ime}}mean ln(survival time){p_end}
{synopt :{opt ha:zard}}hazard{p_end}
{synopt :{opt hr}}hazard ratio, also known as the relative hazard{p_end}
{synopt :{opt xb}}linear prediction xb{p_end}
{synopt :{opt stdp}}standard error of the linear prediction; SE(xb){p_end}
{synopt :{opt s:urv}}S(t|t_0){p_end}
{p2coldent :* {opt csu:rv}}S(t|earliest t_0 for subject){p_end}
{p2coldent :* {opt csn:ell}}Cox-Snell residuals{p_end}
{p2coldent :* {opt mg:ale}}martingale-like residuals{p_end}
{p2coldent :* {opt dev:iance}}deviance residuals{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 17}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt oos}}make {it:statistic} available in and out of sample{p_end}
{synopt :{opt nooff:set}}ignore the {cmd:offset()} variable specified in
    {cmd:streg}{p_end}
{synopt :{opt alpha:1}}predict {it:statistic} conditional on frailty value
    equal to one{p_end}
{synopt :{opt uncond:itional}}predict {it:statistic} unconditionally on the
    frailty{p_end}
{synopt :{opt marg:inal}}synonym for {cmd:unconditional}{p_end}
{synopt :{opt part:ial}}produce observation-level results{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2} 
Unstarred statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample. Starred statistics are calculated for the estimation sample
by default, but the {opt oos} option makes them available both in and out of
sample.{p_end}
{p 4 6 2} 
When no option is specified, the predicted median survival time is calculated
for all models.  The predicted hazard ratio, option {opt hr}, is available only
for the exponential, Weibull, and Gompertz models.  The {opt mean time} and
{opt mean lntime} options are not available for the Gompertz model.
Unconditional estimates of {opt mean time} and {opt mean lntime} are not
available if {opt frailty()} was specified with {helpb streg}.{p_end}
{p 4 6 2}
{opt csnell}, {opt mgale}, and {opt deviance} are not allowed with {cmd:svy}
estimation results.{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
median and mean survival times; hazards; hazard ratios; linear predictions;
standard errors; probabilities; Cox-Snell, martingale-like, and deviance
residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt median time} calculates the predicted median survival time in
analysis-time units.  This is the prediction from time 0 conditional
on constant covariates.  When no options are specified with {cmd:predict}, the
predicted median survival time is calculated for all models.

{phang}
{opt median lntime} calculates the natural logarithm of what {opt median time}
produces.

{phang}
{opt mean time} calculates the predicted mean survival time in analysis-time
units.  This is the prediction from time 0 conditional on constant covariates.
This option is not available for Gompertz regressions and is available for
frailty models only if {opt alpha1} is specified, in which case what you obtain
is an estimate of the mean survival time conditional on a frailty effect of
one.

{phang}
{opt mean lntime} predicts the mean of the natural logarithm of {opt time}.
This option is not available for Gompertz regression and is available for
frailty models only if {opt alpha1} is specified, in which case what you obtain
is an estimate of the mean log survival-time conditional on a frailty effect of
one.

{phang}
{opt hazard} calculates the predicted hazard.

{phang}
{opt hr} calculates the hazard ratio.  This option is valid only for models
having a proportional-hazards parameterization.

{phang}
{opt xb} calculates the linear prediction from the fitted model. That is,
you fit the model by estimating a set of parameters b0, b1, b2, ..., bk,
and the linear prediction is y = xb.

{pmore}
The x used in the calculation is obtained from the data
currently in memory and need not correspond to the data on the independent
variables used in estimating b.

{phang}
{opt stdp} calculates the standard error of the prediction, that is,
the standard error of y.

{phang}
{opt surv} calculates each observation's predicted survivor probability,
S(t|t0), where t_0 is {cmd:_t0}, the analysis time at which each record became
at risk.  For multiple-record data, see the {opt csurv} option below.

{phang}
{opt csurv} calculates the predicted S(t|earliest t0) for each subject in
multiple-record data by calculating the conditional survivor values, S(t|t0)
(see the {opt surv} option above), and then multiplying them.

{pmore}
What you obtain from {cmd:surv} will differ from what you obtain from
{cmd:csurv} only if you have multiple records for that subject.

{pmore}
In the presence of gaps or delayed entry, the estimates obtained from
{cmd:csurv} can be different for subjects with gaps from those without gaps,
having the same covariate values, because the probability of survival over gaps
is assumed to be 1.  Thus the predicted cumulative conditional survivor
function is not a smooth function of time {cmd:_t} for constant values of the
covariates.  Use {cmd:stcurve, survival} to obtain a smooth estimate
of the cumulative survivor function S(t|x).

{phang}
{opt csnell} calculates the Cox-Snell generalized residuals.  For
multiple-record-per-subject data, by default only one value per subject is
calculated and it is placed on the last record for the subject.

{pmore}
Adding the {opt partial} option will produce partial Cox-Snell residuals, one
for each record within subject; see
{helpb streg_postestimation##partial:partial} below.
Partial Cox-Snell residuals are the additive contributions to a subject's
overall Cox-Snell residual.  In single-record-per-subject data, the partial
Cox-Snell residuals are the Cox-Snell residuals.

{phang}
{opt mgale} calculates the martingale-like residuals.  For multiple-record
data, by default only one value per subject is calculated and it is placed on
the last record for the subject.

{pmore} Adding the {opt partial} option will produce partial martingale
residuals, one for each record within subject; see
{helpb streg_postestimation##partial:partial} below.
Partial martingale residuals are the additive contributions to a subject's
overall martingale residual.  In single-record data, the partial martingale
residuals are the martingale residuals.

{phang}
{opt deviance} calculates the deviance residuals.  Deviance residuals are
martingale residuals that have been transformed to be more symmetric about
zero.  For multiple-record data, by default only one value per subject is
calculated and it is placed on the last record for the subject.

{pmore}
Adding the {opt partial} option will produce partial deviance residuals, one for
each record within subject; see
{helpb streg_postestimation##partial:partial} below.
Partial deviance residuals are transformed partial martingale residuals.  In
single-record data, the partial deviance residuals are the deviance residuals.

{phang}
{opt oos} makes {opt csurv}, {opt csnell}, {opt mgale}, and {opt deviance}
available both in and out of sample.  {opt oos} also dictates that summations
and other accumulations take place over the sample as defined by {cmd:if} and
{cmd:in}.  By default, the summations are taken over the estimation sample, with
{cmd:if} and {cmd:in} merely determining which values of {newvar} are to be
filled in once the calculation is finished.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} with
{opt streg}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as xb
rather than xb + offset.

{phang}
{opt alpha1}, when used after fitting a frailty model, specifies that
{it:statistic} be predicted conditional on a frailty value equal to one.
This is the default for shared-frailty models.

{phang}
{opt unconditional} and {opt marginal},
when used after fitting a frailty model,
specify that {it:statistic} be predicted unconditional on the frailty.
That is, the prediction is averaged over the frailty distribution.
This is the default for unshared-frailty models.

{phang}
{marker partial}{...}
{opt partial} is relevant only for multiple-record data and is valid with 
{opt csnell}, {opt mgale}, and {opt deviance}.  Specifying {opt partial} will
produce "partial" versions of these statistics, where one value is calculated
for each record instead of one for each subject.  The subjects are determined
by the {helpb stset##id():id()} option of {cmd:stset}.

{pmore}
Specify {opt partial} if you wish to perform diagnostics on individual
records rather than on individual subjects.  For example, a partial deviance
can be used to diagnose the fitted characteristics of an individual record 
rather than those of the set of records for a given subject.

{phang}
{opt scores} calculates equation-level score variables.  The number of score
variables created depends upon the chosen distribution.

{pmore}
The first new variable will always contain the partial derivative of the log
likelihood with respect to the linear prediction (regression equation)
from the fitted model.

{pmore}
The subsequent new variables will contain the partial derivative of the log
likelihood with respect to the ancillary parameters.  For example, in the
generalized gamma model, the second new variable will contain
the partial derivative of the log likelihood with respect to the linear
prediction (sigma equation), and the third new variable will contain
the partial derivative of the log likelihood with respect to the linear
prediction (kappa equation).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt med:ian} {opt time}}median survival time; the default{p_end}
{synopt :{opt med:ian} {opt lnt:ime}}median ln(survival time){p_end}
{synopt :{opt mean time}}mean survival time{p_end}
{synopt :{opt mean} {opt lnt:ime}}mean ln(survival time){p_end}
{synopt :{opt hr}}hazard ratio, also known as the relative hazard{p_end}
{synopt :{opt xb}}linear prediction xb{p_end}
{synopt :{opt ha:zard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt s:urv}}not allowed with {cmd:margins}{p_end}
{synopt :{opt csu:rv}}not allowed with {cmd:margins}{p_end}
{synopt :{opt csn:ell}}not allowed with {cmd:margins}{p_end}
{synopt :{opt mg:ale}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dev:iance}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for median and mean survival
times, hazard ratios, and linear predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse kva}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset failtime}

{pstd}Fit Weibull survival model{p_end}
{phang2}{cmd:. streg load bearings, d(weibull)}

{pstd}Predict median survival time{p_end}
{phang2}{cmd:. predict time, time}

{pstd}Predict log-median survival time{p_end}
{phang2}{cmd:. predict lntime, lntime}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cancer, clear}

{pstd}Map value for {cmd:drug} into 0 for placebo and 1 for nonplacebo{p_end}
{phang2}{cmd:. replace drug = drug == 2 | drug == 3}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset studytime, failure(died)}

{pstd}Fit exponential survival model{p_end}
{phang2}{cmd:. streg age drug, d(exp)}

{pstd}Predict Cox-Snell residuals{p_end}
{phang2}{cmd:. predict double cs, csnell}

{pstd}{cmd:stset} the data again with {cmd:cs} as failure-time variable{p_end}
{phang2}{cmd:. stset cs, failure(died)}

{pstd}Create {cmd:km} containing Kaplan-Meier survival estimates{p_end}
{phang2}{cmd:. sts generate km = s}

{pstd}Create {cmd:H}, the cumulative hazard{p_end}
{phang2}{cmd:. generate double H = -ln(km)}

{pstd}Plot {cmd:H} against {cmd:cs}, specifying {cmd:cs} twice to obtain
reference line{p_end}
{phang2}{cmd:. line H cs cs, sort}

{pstd}Fit lognormal survival model{p_end}
{phang2}{cmd:. streg age drug, d(lnormal)}

{pstd}Predict deviance residuals{p_end}
{phang2}{cmd:. predict dev, deviance}

{pstd}Plot deviance residuals{p_end}
{phang2}{cmd:. scatter dev studytime, yline(0) m(o)}{p_end}
    {hline}
