{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee "[R] mfx" "help mfx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: predict() option unsuitable for marginal effects" "browse http://www.stata.com/support/faqs/stat/mfx_unsuit.html"}{...}
{viewerjumpto "Predict expression unsuitable error message" "j_mfxunsuit##error"}{...}
{viewerjumpto "Examples" "j_mfxunsuit##examples"}{...}
{marker error}{...}
{title:Predict expression unsuitable error message}

{pstd}
A marginal effect is a derivative of a function of the coefficients 
and independent variables of a model.
The {cmd:mfx} option {cmd:predict()} can be used to specify
the function to be differentiated. If this function depends
on quantities other than the coefficients and independent variables of the
model, {cmd:mfx} will most likely not be able to evaluate the derivative
accurately.

{pstd}
{cmd:mfx} checks for dependence on other quantities by predicting 
into different observations in the dataset and 
checking that it obtains the same value. 
If not, it determines that the expression is unsuitable.

{pstd}
The {cmd:mfx} option {cmd:diagnostics(beta)} displays the results of
these checks.  The option {cmd:force} can be used to force the calculation of
the marginal effect, although this is usually inadvisable.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. regress mpg weight}{p_end}
{phang}{cmd:. mfx, predict(res) diagnostics(beta)}{p_end}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. clogit for turn, group(head)}{p_end}
{phang}{cmd:. mfx, predict(pc1) diagnostics(beta)}{p_end}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. xtlogit for mpg, i(rep) fe}{p_end}
{phang}{cmd:. mfx, predict(p) diagnostics(beta)}{p_end}
