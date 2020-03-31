{smcl}
{* *! version 1.1.8  31may2018}{...}
{cmd:help cnreg postestimation}{...}
{right:dialog:  {dialog cnreg_p:predict}{space 14}}
{right:also see:  {help cnreg} {space 15}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:cnreg} continues to work but, as of Stata 11, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 33 35 2}{...}
{p2col :{hi:[R] cnreg postestimation} {hline 2}}Postestimation tools for cnreg{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The following postestimation commands are available after {cmd:cnreg}:

{synoptset 20 notes}{...}
{synopthdr :command}
{synoptline}
INCLUDE help post_adjust1
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
INCLUDE help post_mfx
INCLUDE help post_nlcom
{synopt :{helpb cnreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
INCLUDE help post_lrtest_star_msg


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*}{c |}{it:newvar_reg} {it:newvar_sigma}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{synoptset 14 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
INCLUDE help regstats
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.

INCLUDE help whereab


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see {cmd:regress} {it:Methods and formulas}. 

INCLUDE help pr_opt

{phang}
{opt e(a,b)} calculates
{bind:{it:E}(xb + u | {it:a} < xb + u < {it:b})},
the expected value of y|x conditional
on y|x being in the interval ({it:a},{it:b}),
meaning that y|x is censored.
{it:a} and {it:b} are specified as they are for {opt pr()}.

{phang}
{opt ystar(a,b)}
calculates {it:E}(y*), where {bind:y* = {it:a}}
if {bind:xb + u {ul:<} {it:a}}, {bind:y* = {it:b}}
if {bind:xb + u {ul:>} {it:b}},
and {bind:y* = xb + u} otherwise, meaning that
y* is truncated.  {it:a} and {it:b} are specified as they are for
{opt pr()}.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)}.
It modifies the calculations made
by {cmd:predict} so that they ignore the offset variable; the linear
prediction is treated as xb rather than as xb + offset.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the scale equation ({hi:sigma}).


{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse news2}{p_end}
{phang2}{cmd:. cnreg date lncltn famown, censored(cnsrd)}{p_end}

{pstd}Obtain predictions, assuming they are truncated to fall between 8036 and
11323 (inclusive){p_end}
{phang2}{cmd:. predict ystar, ystar(8036,11323)}{p_end}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp cnreg R}
{p_end}
