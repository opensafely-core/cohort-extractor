{* *! version 1.2.0  02oct2014}{...}
{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {opt xb} {opt e} {opt stdp} {opt di:fference}] 


INCLUDE help menu_predict


{marker description_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction. 

{phang}
{opt e} calculates the residual error. 

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction
is also referred to as the standard error of the fitted value.  {opt stdp} may
not be combined with {opt difference}.

{phang}
{opt difference} specifies that the statistic be calculated for the first
differences instead of the levels, the default.
