{smcl}
{* *! version 1.1.11  31may2018}{...}
{cmd:help ztnb postestimation}{right:dialog:  {dialog ztnb_p:predict}{space 14}}
{right:also see:  {help ztnb}{space 17}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:ztnb} has been superseded by {helpb tnbreg}. {cmd:tnbreg} allows the 
specification of any nonnegative integer as the left truncation point; thus
it does what {cmd:ztnb} can do and more.
{cmd:ztnb} continues to work but, as of Stata 12, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 32 34 2}{...}
{p2col :{bf:[R] ztnb postestimation} {hline 2}}Postestimation tools for ztnb
{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The following postestimation commands are available after {cmd:ztnb}:

{synoptset 20 notes}{...}
{p2col :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
INCLUDE help post_margins
INCLUDE help post_nlcom
{p2col :{helpb ztnb postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
INCLUDE help post_lrtest_star_msg


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} 
{opt nooff:set}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:stub}{cmd:*}{c |}{it:newvar_reg}
 {it:newvar_disp}{c )-}
 {ifin} {cmd:,} {opt sc:ores}

{synoptset 11 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt n}}number of events; the default{p_end}
{synopt:{opt ir}}incidence rate{p_end}
{synopt:{opt cm}}conditional mean, {it:E}(y_j|y_j > 0){p_end}
{synopt:{opt xb}}linear prediction{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events, which
is exp(xb) if neither {opt offset()} nor {opt exposure()} was specified
when the model was fit; {bind:exp(xb + offset)} if {opt offset()} was
specified; or {bind:exp(xb)*exposure} if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted
number of events when exposure is 1.  This is equivalent to specifying both
{opt n} and {opt nooffset} options.

{phang}
{opt cm} calculates the conditional mean of n, given n>0, that
is, {it:E}(n|n > 0), which is exp(xb)/P(n > 0|x) if neither {opt offset()} nor
{opt exposure()} was specified when the zero-truncated negative binomial model
was fit, or {bind:exp(xb + offset)/P( n > 0|x)} if {opt offset()} was
specified, or {bind:exp(xb)/P(n > 0|x)*exposure} if {opt exposure()} was
specified.

{phang}
{opt xb} calculates the linear prediction, which is xb if neither 
{opt offset()} nor {opt exposure()} was specified; 
{bind:xb + offset} if {opt offset()} was specified; or 
{bind:xb + ln(exposure)} if {opt exposure()} was specified; see 
{opt nooffset} below.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset or exposure variable; the
linear prediction is treated as xb rather than as {bind:xb + offset}
or {bind:xb + ln(exposure)}.  Specifying {cmd:predict} ...{cmd:, nooffset} is
equivalent to specifying {cmd:predict} ...{cmd:, ir}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the dispersion equation.


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rod93}{p_end}

{pstd}Fit zero-truncated negative binomial regression model{p_end}
{phang2}{cmd:. ztnb deaths i.cohort, exposure(exposure)}{p_end}

{pstd}Predict incidence rate of death{p_end}
{phang2}{cmd:. predict incidence, ir}{p_end}

{pstd}Predict the number of events{p_end}
{phang2}{cmd:. predict nevents, n}{p_end}

{pstd}Predict the number of events, conditional on the number being positive
{p_end}
{phang2}{cmd:. predict condmean, cm}{p_end}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp ztnb R}
{p_end}
