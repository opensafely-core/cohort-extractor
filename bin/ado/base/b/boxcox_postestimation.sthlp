{smcl}
{* *! version 1.1.16  19oct2017}{...}
{viewerdialog predict "dialog boxcox_p"}{...}
{vieweralsosee "[R] boxcox postestimation" "mansection R boxcoxpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] boxcox" "help boxcox"}{...}
{viewerjumpto "Postestimation commands" "boxcox postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "boxcox_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "boxcox postestimation##syntax_predict"}{...}
{viewerjumpto "Remarks" "boxcox postestimation##remarks"}{...}
{viewerjumpto "Examples" "boxcox postestimation##examples"}{...}
{viewerjumpto "Reference" "boxcox postestimation##reference"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] boxcox postestimation} {hline 2}}Postestimation tools for boxcox{p_end}
{p2col:}({mansection R boxcoxpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:boxcox}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
{p2coldent:* {bf:{help lincom}}}point estimates, standard errors, testing, and
inference for linear combinations of coefficients{p_end}
{p2coldent:* {bf:{help nlcom}}}point estimates, standard errors, testing, and
inference for nonlinear combinations of coefficients{p_end}
{synopt :{helpb boxcox postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
{p2coldent:* {helpb test}}Wald tests of simple and composite linear
hypotheses{p_end}
{p2coldent:* {helpb testnl}}Wald tests of nonlinear hypotheses{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Inference is valid only for hypotheses concerning lambda and theta.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R boxcoxpostestimationRemarksandexamples:Remarks and examples}

        {mansection R boxcoxpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {it:options}]

{synoptset 17 tabbed}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt yhat}}predicted value of y; the default{p_end}
{synopt :{opt res:iduals}}residuals{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opt smear:ing}}compute statistic using smearing method; the default
{p_end}
{synopt :{opt bt:ransform}}compute statistic using back-transform method{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
predicted values and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt yhat}, the default, calculates the predicted value of the dependent
variable. 

{phang}
{opt residuals} calculates the residuals, that is, the observed value minus
the predicted value.

{dlgtab:Options}

{phang}
{cmd:smearing} calculates the statistics {cmd:yhat}
and {cmd:residuals} using the smearing method proposed by
{help boxcox postestimation##D1983:Duan (1983)} (see
{mansection R boxcoxpostestimationMethodsandformulas:{it:Methods and formulas}}
for a description of this method). {cmd:smearing} is the default.

{phang}
{cmd:btransform} calculates the statistics {cmd:yhat} and {cmd:residuals}
using the back-transform method (see
{mansection R boxcoxpostestimationMethodsandformulas:{it:Methods and formulas}}
for a description of this method).


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:boxcox} estimates variances only for the lambda and theta parameters
(see the {mansection R boxcoxRemarksandexamplestechnote:technical note} in
{hi:[R] boxcox}), so the extent to which
postestimation commands can be used following {cmd:boxcox} is limited.
Formulas used in {cmd:lincom}, {cmd:nlcom}, {cmd:test}, and {cmd:testnl}
are dependent on the estimated variances.  Therefore, the use of these
commands is limited and generally applicable only to inferences on the lambda
and theta coefficients.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2}{p_end}
{phang2}{cmd:. boxcox bpdiast bmi tcresult, notrans(age sex) model(theta)}
        {cmd:lrtest}{p_end}

{pstd}Calculate the predicted values using the default smearing method{p_end}
{phang2}{cmd:. predict yhat}

{pstd}Calculate the predicted values using the back-transform method{p_end}
{phang2}{cmd:. predict yhatb, btransform}{p_end}


{marker reference}{...}
{title:Reference}

{marker D1983}{...}
{phang}
Duan, N. 1983. Smearing estimate: A nonparametric retransformation method.
{it:Journal of the American Statistical Association} 78: 605-610.
{p_end}
