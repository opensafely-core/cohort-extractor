{smcl}
{* *! version 1.1.11  01mar2017}{...}
{cmd:help ztp postestimation}{right:dialog:  {dialog ztp_p:predict}{space 14}}
{right:also see:  {help ztp}{space 18}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:ztp} has been superseded by {helpb tpoisson}.  {cmd:tpoisson} allows the
specification of any nonnegative integer as the left truncation point; thus
it does what {cmd:ztp} can do and more. 
{cmd:ztp} continues to work but, as of Stata 12, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 31 33 2}{...}
{p2col :{bf:[R] ztp postestimation} {hline 2}}Postestimation tools for ztp
{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The following postestimation commands are available after {cmd:ztp}:

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
{p2col :{helpb ztp postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
   {it:statistic} {opt nooff:set}]

{synoptset 11 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, {it:E}(y_j|y_j > 0){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
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
specified; or {bind:exp(xb) x exposure} if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted
number of events when exposure is 1.  This is equivalent to specifying both
{opt n} and {opt nooffset} options.

{phang}
{opt cm} calculates the conditional mean of n, given n>0, that is,
{it:E}(n|n>0,x), which is exp(xb)/P(n > 0|x) if neither {opt offset()} nor
{opt exposure()} was specified when the zero-truncated negative binomial model
was fit, or {bind:exp(xb + offset)/P(n > 0|x)} if {opt offset()} was
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
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset or exposure variable; the
linear prediction is treated as xb rather than as {bind:xb + offset}
or {bind:xb + ln(exposure)}.  Specifying {cmd:predict} ...{cmd:, nooffset} is
equivalent to specifying {cmd:predict} ...{cmd:, ir}.


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse runshoes}{p_end}

{pstd}Fit zero-truncated Poisson regression{p_end}
{phang2}{cmd:. ztp shoes distance male age}{p_end}

{pstd}Predict the number of shoes purchased{p_end}
{phang2}{cmd:. predict shoehat, n}{p_end}

{pstd}Predict the number of shoes purchased, conditional on each person having
bought shoes{p_end}
{phang2}{cmd:. predict shoecondhat, cm}{p_end}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp ztp R}
{p_end}
