{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "[R] mfx" "help mfx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: Obtaining marginal effects without standard errors" "browse http://www.stata.com/support/faqs/stat/mfx_nose.html"}{...}
{viewerjumpto "Predict expression unsuitable for standard error calculation warning message" "j_mfxunsuitse##warning"}{...}
{viewerjumpto "Examples" "j_mfxunsuitse##examples"}{...}
{marker warning}{...}
{title:Predict expression unsuitable for standard error calculation warning message}

{pstd}
A marginal effect is a derivative of a function of the coefficients 
and independent variables of a model.
The {cmd:mfx} option {cmd:predict()} can be used to specify
the function to be differentiated. If this function depends
on random quantities other than the coefficients of the model
or on the coefficients in a way other than through the coefficient matrix
{cmd:e(b)}, {cmd:mfx} will most likely not be able to evaluate the
standard error of the marginal effect accurately. 

{pstd}
After computing the marginal effects, {cmd:mfx} checks this
by changing the values of particular stored results and recomputing
the marginal effects.  If the marginal effects have changed, it determines
that the predict expression is unsuitable for calculating standard errors.

{pstd}
The {cmd:mfx} option {cmd:diagnostics(vce)} displays the results of
this check.  The option {cmd:force} can be used to force calculation of the
standard errors, although this is usually inadvisable. 


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. regress mpg weight}{p_end}
{phang}{cmd:. mfx, predict(stdp) diagnostics(vce)}{p_end}
