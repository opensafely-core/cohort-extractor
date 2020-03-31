{smcl}
{* *! version 1.1.2  29mar2013}{...}
{cmd:help dvech postestimation}{...}
{right:dialog:  {dialog dvech_p:predict}}
{right:also see:  {help dvech}  }
{hline}
{pstd}
{cmd:dvech} has been superseded by {helpb mgarch dvech}.  {cmd:mgarch dvech}
is part of {helpb mgarch}, which estimates the parameters of 4 different
multivariate GARCH models -- diagonal-vech models, constant
conditional-correlation models, dynamic conditional-correlation models, and
time-varying conditional-correlation models; thus {cmd:mgarch dvech} does what
{cmd:dvech} can do and more.  {cmd:dvech} continues to work but, as of
Stata 12, is no longer an official part of Stata.  This is the original help
file, which we will no longer update, so some links may no longer work.


{title:Title}

{p2colset 5 34 38 2}{...}
{p2col :{bf:[TS] dvech postestimation} {hline 2}}Postestimation tools for
dvech{p_end}


{title:Description}

{pstd}
The following standard postestimation commands are available after {cmd:dvech}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_lrtest
INCLUDE help post_margins
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb dvech postestimation##predict:predict}}predictions and residuals
{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:stub}{cmd:*}{c |}{it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}dependent variables{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt v:ariance}}conditional variances and covariances{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt :{opt e:quation(eqnames)}}names of equations for which
             predictions are made{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified time
{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the predictions of the dependent
variables.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt variance} predicts the conditional variances and conditional covariances.

{dlgtab:Options}

{phang}
{opt equation(eqnames)} specifies the equation for which the
predictions are calculated.  Use this option to predict a statistic for a
particular equation.  Equation names, such as {cmd:equation(income)}, are used
to identify equations.

{pmore}
One equation name may be specified when predicting the dependent variable, 
the residuals, or the conditional variance.  For example, specifying
{cmd:equation(income)} causes {cmd:predict} to predict {cmd:income}, and
specifying {cmd:variance equation(income)} causes predict to predict the
conditional variance of income.

{pmore}
Two equations may be specified when predicting a conditional variance or
covariance. For example, specifying
{cmd:equation(income, consumption)} {cmd:variance} causes {cmd:predict} to
predict the conditional covariance of {cmd:income} and {cmd:consumption}.

{phang}
{opt dynamic(time_constant)} specifies when {cmd:predict} starts
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {cmd:tsset}, and the {it:time_constant}
must be inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2008q4))} causes dynamic predictions
to begin in the fourth quarter of 2008, assuming that your time variable is
quarterly; see {manhelp datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {cmd:dynamic()} may not be specified with {cmd:residuals}.


{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse acme}{p_end}
{phang2}{cmd:. constraint 1 [L.ARCH]1_1  = [L.ARCH]2_2}{p_end}
{phang2}{cmd:. constraint 2 [L.GARCH]1_1 = [L.GARCH]2_2}{p_end}
{phang2}{cmd:. dvech (acme = L.acme) (anvil = L.anvil), arch(1) garch(1) constraints(1 2)}{p_end}

{pstd}Forecast conditional variances 12 weeks into the future, using dynamic
predictions beginning in the twenty-sixth week of 1998, and then graph the
forecasts{p_end}
{phang2}{cmd:. tsappend, add(12)}{p_end}
{phang2}{cmd:. predict H*, variance dynamic(tw(1998w26))}{p_end}
{phang2}{cmd:. tsline H_acme_acme H_anvil_anvil if t>=tw(1995w25), legend(rows(2))}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse aacmer, clear}{p_end}
{phang2}{cmd:. dvech (acme anvil = , noconstant), arch(1/2) garch(1) }{p_end}

{pstd}Forecast conditional variance of {cmd:acme} equation and graph the
results{p_end}
{phang2}{cmd:. predict h_acme, variance eq(acme, acme)}{p_end}
{phang2}{cmd:. tsline h_acme}{p_end}

    {hline}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp dvech TS}
{p_end}
