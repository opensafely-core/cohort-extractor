{smcl}
{* *! version 1.0.4  05sep2018}{...}
{viewerdialog "predict" "dialog fmm_p"}{...}
{vieweralsosee "[FMM] fmm postestimation" "mansection FMM fmmpostestimation"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm estimation" "help fmm estimation"}{...}
{viewerjumpto "Postestimation commands" "fmm postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "fmm postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "fmm postestimation##syntax_margins"}{...}
{viewerjumpto "Remarks and examples" "fmm postestimation##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[FMM] fmm postestimation} {hline 2}}Postestimation tools for
fmm{p_end}
{p2col:}({mansection FMM fmmpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
estimation with {cmd:fmm}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb fmm estat eform:estat eform}}display exponentiated parameters{p_end}
{synopt :{helpb fmm estat lcmean:estat lcmean}}latent class marginal means{p_end}
{synopt :{helpb fmm estat lcprob:estat lcprob}}latent class marginal probabilities{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb contrast}}contrasts and linear hypothesis tests{p_end}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
{synopt :{helpb lincom}}linear combination of parameters{p_end}
INCLUDE help post_lrtest_star
{synopt:{helpb fmm_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb fmm_postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p2colreset}{...}
{p 4 6 2}
* {opt hausman} and {opt lrtest} are not appropriate with {opt svy} estimation
results.{p_end}

{pstd}
Postestimation commands such {opt lincom} and {opt nlcom} require
referencing estimated parameter values, which are accessible via
{cmd:_b[}{it:name}{cmd:]}. To find out what the names are, type
{cmd:fmm,} {cmd:coeflegend}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM fmmpostestimationRemarksandexamples:Remarks and examples}

        {mansection FMM fmmpostestimationMethodsandformulas:Methods and formulas}

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
{synoptset 20 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}expected value of {depvar}; the default{p_end}
{synopt :{opt eta}}linear prediction of {depvar}{p_end}
{synopt :{opt den:sity}}density function at {depvar}{p_end}
{synopt :{opt dist:ribution}}distribution function at {depvar}{p_end}
{synopt :{opt surv:ival}}survivor function at {depvar}{p_end}
{synopt :{opt classpr}}latent class probability{p_end}
{synopt :{opt classpost:eriorpr}}posterior latent class probability{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to
the parameters{p_end}
{synoptline}

{marker options}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt marg:inal}}compute {it:statistic} marginally with respect to the
latent classes{p_end}
{synopt :{opt pmarg:inal}}compute {cmd:mu} marginally with respect to the
posterior latent class probabilities{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or
exposure{p_end}
{p2coldent :* {cmdab:o:utcome(}{depvar} [{it:#}]{cmd:)}}specify observed response
variable (default all){p_end}
{synopt :{opt class(#)}}specify latent class (default all){p_end}
{synoptline}
{p 4 6 2}
*{opt outcome(depvar #)} is allowed only if {it:depvar} is
from {cmd:mlogit}, {cmd:ologit}, or {cmd:oprobit}.{break}
{opt outcome(depvar #)} may also be specified as
{cmd:outcome(}{it:#}{cmd:.}{it:depvar}{cmd:)} or
{cmd:outcome(}{it:depvar} {cmd:#}{it:#}{cmd:)}.{break}
{cmd:outcome(}{it:depvar} {cmd:#3)} means the third outcome value.
{cmd:outcome(}{it:depvar} {cmd:#3)} would mean the same as
{cmd:outcome(}{it:depvar}{cmd:4)} if outcomes were 1, 3, and 4.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} after {cmd:fmm} creates new variables containing predictions
such as means, probabilities, linear predictions, densities, or latent class
probabilities.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt mu}, the default, calculates the expected value of the outcomes.

{phang} 
{opt eta} calculates the fitted linear prediction.

{phang}
{opt density} calculates the density function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.

{phang}
{opt distribution} calculates the distribution function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.
This option is not allowed for {opt mlogit} outcomes.

{phang}
{opt survival} calculates the survivor function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.
This option is allowed only for {opt streg} outcomes.

{phang}
{opt classpr} calculates predicted probabilities for each latent class.

{phang}
{opt classposteriorpr} calculates predicted posterior probabilities for
each latent class.
The posterior probabilities are a function of the latent-class predictors
and the fitted outcome densities.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.  This
option requires a new variable list of length equal to the number of columns in
{cmd:e(b)}.  Otherwise, use {it:stub}{cmd:*} to have {cmd:predict} generate
enumerated variables with prefix {it:stub}.

{phang}
{opt marginal} specifies that the prediction be computed marginally with
respect to the latent classes.
The marginal prediction is computed by combining the class specific
predictions using the latent-class probabilities.

{pmore}
This option is allowed only with {opt mu} and {opt density}.

{phang}
{opt pmarginal} specifies that the prediction is computed by combining
the class specific expected values using the posterior latent-class
probabilities.

{pmore}
This option is allowed only with {opt mu}.

{phang}
{opt nooffset} is relevant only if option
{opt offset()} or {opt exposure()} was specified at estimation time.
{opt nooffset} specifies that {opt offset()} or {opt exposure()} be
ignored, which produces predictions as if all subjects had equal
exposure. 

{phang}
{cmd:outcome(}{depvar} [{it:#}]{cmd:)} specifies the
{it:depvar} for which predictions should be calculated.
Predictions for all observed response variables are computed by default.
Most models have only one {it:depvar}.
If {it:depvar} is an {opt mlogit}, {opt ologit}, or {opt oprobit}
outcome, then {it:#} optionally specifies which outcome level to
predict. The default is the first level.

{phang}
{opt class(#)} specifies that predictions for
latent class {it:#} be calculated.
Predictions for all latent classes are computed by default.


INCLUDE help syntax_margins

{synoptset 20}{...}
{synopthdr:statistic}
{synoptline}
{synopt :default}calculate expected values for each {depvar}{p_end}
{synopt :{opt mu}}calculate expected value of {depvar}{p_end}
{synopt :{opt eta}}calculate expected value of linear prediction of
{depvar}{p_end}
{synopt :{opt classpr}}calculate latent class prior probabilities{p_end}
{synopt :{opt den:sity}}not allowed with {opt margins}{p_end}
{synopt :{opt dist:ribution}}not allowed with {opt margins}{p_end}
{synopt :{opt surv:ival}}not allowed with {opt margins}{p_end}
{synopt :{opt classpost:eriorpr}}not allowed with {opt margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {opt margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt mu} defaults to the first {depvar}
if option {opt outcome()} is not specified.
If {it:depvar} is {opt mlogit}, {opt ologit}, or {opt oprobit}, the default
is the first level of the outcome.
The default is the first latent class if
{opt class()} is not specified.{p_end}
{p 4 6 2}
{opt eta} defaults to the first {depvar}
if option {opt outcome()} is not specified.
If {it:depvar} is {opt mlogit}, the default
is the first level of the outcome.{p_end}
{p 4 6 2}
{opt classpr} defaults to the first latent class
if option {opt class()} is not specified.{p_end}
{p 4 6 2}
{opt predict}'s option {opt marginal} is assumed if
{opt predict}'s option {opt class()} is not
specified.

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{opt margins} estimates margins of response for outcome means,
outcome probabilities, and latent-class probabilities.


{marker remarks}{...}
{title:Remarks and examples}

{pstd}
For examples using {cmd:estimates stats} to compare models based on
Akaike information criterion and Bayesian information
criterion, see {findalias fmmexrega}, {findalias fmmexregb}, and
{findalias fmmexregd}.

{pstd}
For examples using {cmd:estat lcprob} to obtain marginal latent class
probabilities and {cmd:estat lcmean} to obtain marginal predicted means, see
{findalias fmmexpoisson} and {findalias fmmexzip}.

{pstd}
For examples using {cmd:test} and {cmd:contrast} to test
equality of coefficients across classes, see {findalias fmmexregc}.

{pstd}
For examples using {cmd:predict}, see {findalias fmmexpoisson},
{findalias fmmexzip}, and {findalias fmmexsurv}.
{p_end}
