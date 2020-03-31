{smcl}
{* *! version 1.1.6  04jun2018}{...}
{viewerdialog predict "dialog stcrreg_p"}{...}
{viewerdialog stcurve "dialog stcurve"}{...}
{vieweralsosee "[ST] stcrreg postestimation" "mansection ST stcrregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcrreg" "help stcrreg"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{viewerjumpto "Postestimation commands" "stcrreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "stcrreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "stcrreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "stcrreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "stcrreg postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[ST] stcrreg postestimation} {hline 2}}Postestimation tools for
stcrreg{p_end}
{p2col:}({mansection ST stcrregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:stcrreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb stcurve}}plot the cumulative subhazard and cumulative
incidence functions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb stcrreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb stcrreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stcrregpostestimationRemarksandexamples:Remarks and examples}

        {mansection ST stcrregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:sv_statistic} {opt nooff:set}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{c )-} {ifin}
{cmd:,} {it:mv_statistic} [{opt part:ial}]

{synoptset 17 tabbed}{...}
{synopthdr :sv_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt shr}}predicted subhazard ratio, also known as the relative subhazard; the default{p_end}
{synopt :{opt xb}}linear prediction xb{p_end}
{synopt :{opt stdp}}standard error of the linear prediction; SE(xb){p_end}
{p2coldent :* {opt basecif}}baseline cumulative incidence function (CIF){p_end}
{p2coldent :* {opt basecsh:azard}}baseline cumulative subhazard function{p_end}
{p2coldent :* {opt kmc:ensor}}Kaplan-Meier survivor curve for censoring distribution{p_end}
{synoptline}

{synoptset 17 tabbed}{...}
{synopthdr :mv_statistic}
{synoptline}
{syntab:Main}
{p2coldent :* {opt sco:res}}pseudolikelihood scores{p_end}
{p2coldent :* {opt esr}}efficient score residuals{p_end}
{p2coldent :* {opt dfb:eta}}DFBETA measures of influence{p_end}
{p2coldent :* {opt sch:oenfeld}}Schoenfeld residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred
{p 4 6 2}
{opt nooffset} is allowed only with unstarred statistics.
{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
subhazard ratios, linear predictions, standard errors, baseline cumulative
incidence and subhazard functions, Kaplan-Meier survivor curves,
pseudolikelihood scores, efficient score and Schoenfeld residuals, and DFBETA
measures of influence.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt shr}, the default, calculates the relative subhazard (subhazard ratio),
that is, the exponentiated linear prediction.

{phang}
{opt xb} calculates the linear prediction from the fitted model. That is,
you fit the model by estimating a set of parameters, b1, b2, ..., bk,
and the linear prediction is xb.

{pmore}
The x used in the calculation is obtained from the data
currently in memory and need not correspond to the data on the independent
variables used in estimating b.

{phang}
{opt stdp} calculates the standard error of the prediction, that is,
the standard error of xb.

{phang}
{opt basecif} calculates the baseline CIF.  This is the CIF of the
subdistribution for the cause-specific failure process.

{phang}
{opt basecshazard} calculates the baseline cumulative subhazard 
function.  This is the cumulative hazard function of the subdistribution 
for the cause-specific failure process.

{phang}
{opt kmcensor} calculates the Kaplan-Meier survivor function for the 
censoring distribution.  These estimates are used to weight within 
risk pools observations that have experienced a competing event.  As such, 
these values are not predictions or diagnostics in the strict sense, but 
are provided for those who wish to reproduce the pseudolikelihood calculations
performed by {helpb stcrreg}.

{phang}
{opt nooffset} is allowed only with {opt shr}, {opt xb}, and {opt stdp}, and is
relevant only if you specified {opth offset(varname)} for {cmd:stcrreg}.  It
modifies the calculations made by {cmd:predict} so that they ignore the offset
variable; the linear prediction is treated as xb rather than xb + offset.

{phang}
{cmd:scores} calculates the pseudolikelihood scores for each regressor in the
model.  These scores are components of the robust estimate of variance.  For
multiple-record data, by default only one score per subject is calculated and
it is placed on the last record for the subject.

{pmore} 
Adding the {opt partial} option will produce partial scores,
one for each record within subject; see
{helpb stcrreg_postestimation##partial:partial} below.
Partial pseudolikelihood scores are the additive contributions to a subject's
overall pseudolikelihood score.  In single-record data, the partial
pseudolikelihood scores are the pseudolikelihood scores.

{pmore}
One score variable is created for each regressor in the model; the first new
variable corresponds to the first regressor, the second to the second, and so
on.

{phang}
{cmd:esr} calculates the efficient score residuals for each regressor in the
model.  Efficient score residuals are diagnostic measures equivalent to 
pseudolikelihood scores, with the exception that efficient score residuals 
treat the censoring distribution (that used for weighting) as known rather 
than estimated.  For multiple-record data, by default only one efficient 
score per subject is calculated and it is placed on the last record for the
subject.

{pmore} 
Adding the {opt partial} option will produce partial efficient score residuals,
one for each record within subject; see
{helpb stcrreg_postestimation##partial:partial} below.
Partial efficient score residuals are the additive contributions to a subject's
overall efficient score residual.  In single-record data, the partial
efficient scores are the efficient scores.

{pmore}
One efficient score variable is created for each regressor in the model; the
first new variable corresponds to the first regressor, the second to the
second, and so on.

{phang}
{cmd:dfbeta} calculates the DFBETA measures of influence for each regressor
in the model.  The DFBETA value for a subject estimates the change
in the regressor's coefficient due to deletion of that subject.
For multiple-record data, by default only one value per subject is
calculated and it is placed on the last record for the subject.

{pmore} 
Adding the {opt partial} option will produce partial DFBETAs, one for each
record within subject; see
{helpb stcrreg_postestimation##partial:partial} below.  Partial DFBETAs are
interpreted as effects due to deletion of individual records rather than
deletion of individual subjects.  In single-record data, the partial DFBETAs
are the DFBETAs.

{pmore}
One DFBETA variable is created for each regressor in the model; the first new
variable corresponds to the first regressor, the second to the second, and so
on.

{phang}
{opt schoenfeld} calculates the Schoenfeld-like residuals.  Schoenfeld-like
residuals are diagnostic measures analogous to Schoenfeld residuals in 
Cox regression.  They compare a failed observation's covariate values to 
the (weighted) average covariate values for all those at risk at the time
of failure.  Schoenfeld-like residuals are calculated only for those
observations that end in failure; missing values are produced otherwise.

{pmore}
One Schoenfeld residual variable is created for each regressor in the model;
the first new variable corresponds to the first regressor, the second to the
second, and so on.

{phang}
Note: The easiest way to use the preceding four options is, for
example, 

{phang2}{cmd:. predict double} {it:stub}{cmd:*, scores} 

{pmore}
where {it:stub} is a short name of your
choosing.  Stata then creates variables {it:stub}{cmd:1}, {it:stub}{cmd:2},
etc.  You may also specify each variable name explicitly, in which case there
must be as many (and no more) variables specified as there are regressors
in the model.

{phang}
{marker partial}{...}
{opt partial} is relevant only for multiple-record data and is valid with
{opt scores}, {opt esr}, and {opt dfbeta}.  Specifying {opt partial} will
produce "partial" versions of these statistics, where one value is calculated
for each record instead of one for each subject.  The subjects are determined
by the {helpb stset##id():id()} option to {cmd:stset}.

{pmore}
Specify {opt partial} if you wish to perform diagnostics on individual
records rather than on individual subjects.  For example, a partial DFBETA 
would be interpreted as the effect on a coefficient due to deletion of one 
record, rather than the effect due to deletion of all records for a given 
subject.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt shr}}predicted subhazard ratio, also known as the relative subhazard; the default{p_end}
{synopt :{opt xb}}linear prediction xb{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt basecif}}not allowed with {cmd:margins}{p_end}
{synopt :{opt basecsh:azard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt kmc:ensor}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sco:res}}not allowed with {cmd:margins}{p_end}
{synopt :{opt esr}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dfb:eta}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sch:oenfeld}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
subhazard ratios and linear predictions.


{marker examples}{...}
{title:Examples of predictions after stcrreg}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hypoxia}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dftime, failure(failtype==1)}

{pstd}Fit competing-risks model{p_end}
{phang2}{cmd:. stcrreg ifp tumsize pelnode, compete(failtype==2)}

{pstd}Obtain the relative subhazards{p_end}
{phang2}{cmd:. predict double shr}

{pstd}Obtain the baseline cumulative subhazard function{p_end}
{phang2}{cmd:. predict double bcsh, basecsh}

{pstd}Obtain DFBETA measures of influence{p_end}
{phang2}{cmd:. predict double df*, dfbeta}

{pstd}Plot the first DFBETA versus analysis time{p_end}
{phang2}{cmd:. twoway scatter df1 _t}


{title:Example of using stcurve after stcrreg}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hypoxia, clear}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dftime, failure(failtype==1)}

{pstd}Fit competing-risks model{p_end}
{phang2}{cmd:. stcrreg ifp tumsize pelnode, compete(failtype==2)}

{pstd}Use {cmd:stcurve} to compare CIFs{p_end}
{phang2}{cmd:. stcurve, cif at1(pelnode=0) at2(pelnode=1)}{p_end}
