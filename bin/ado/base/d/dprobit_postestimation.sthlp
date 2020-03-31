{smcl}
{* *! version 1.1.5  29mar2013}{...}
{cmd:help dprobit postestimation}{...}
{right:dialogs:  {dialog dprobit_p:predict}  {dialog dprobit_estat:estat}{space 7}}
{right:also see:  {helpb dprobit}{space 14}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:dprobit} continues to work but, as of Stata 11, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 35 37 2}{...}
{p2col :{hi:[R] dprobit postestimation} {hline 2}}Postestimation tools for
dprobit{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The following postestimation commands are of special interest after
{cmd:dprobit}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb logistic postestimation##estatclas:estat clas}}{opt estat classification} reports various summary statistics, including the classification table{p_end}
{synopt :{helpb logistic postestimation##estatgof:estat gof}}Pearson or Hosmer-Lemeshow goodness-of-fit test{p_end}
{synopt :{helpb logistic postestimation##lroc:lroc}}graphs the ROC curve and calculates the area under the curve{p_end}
{synopt :{helpb logistic postestimation##lsens:lsens}}graphs sensitivity and specificity versus probability cutoff{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the {cmd:svy} prefix.
{p_end}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20 notes}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_adjust3par
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest2par
INCLUDE help post_mfx
INCLUDE help post_nlcom
{synopt :{helpb dprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}(1) {cmd:adjust} is not appropriate with time-series operators.{p_end}
INCLUDE help post_lrtest2par_msg


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt nooff:set} {opt rule:s} {opt asif}]

{synoptset 11 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt p:r}}probability of a positive outcome; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{p2coldent :* {opt de:viance}}deviance residual{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred


INCLUDE help menu_predict


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt deviance} calculates the deviance residual.  

{phang}
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt dprobit}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as xb
rather than xb + offset.

{phang}
{opt rules} requests that Stata use any rules that were used to
identify the model when making the prediction.  By default, Stata calculates
missing for excluded observations.

{phang}
{opt asif} requests that Stata ignore the rules and the exclusion criteria
and calculate predictions for all observations possible using the estimated
parameter from the model.


{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse repair}{p_end}
{phang2}{cmd:. gen rep_is_1 = repair == 1}{p_end}
{phang2}{cmd:. gen rep_is_2 = repair == 2}{p_end}
{phang2}{cmd:. dprobit foreign rep_is_1 rep_is_2}{p_end}

{pstd}Obtain predicted probabilities{p_end}
{phang2}{cmd:. predict p}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp dprobit R};
{manhelp logistic_postestimation R:logistic postestimation}
{p_end}
