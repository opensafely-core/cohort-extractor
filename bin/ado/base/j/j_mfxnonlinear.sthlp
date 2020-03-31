{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "[R] mfx" "help mfx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: Methods for obtaining marginal effects" "browse http://www.stata.com/support/faqs/stat/mfx_dydx.html"}{...}
{title:Try nonlinear warning message}

{pstd}
A marginal effect is a derivative.  To find a derivative numerically, 
{cmd:mfx} uses the approximation  (f(x+h)-f(x))/h.

{pstd}
Thus, {cmd:mfx} must find a suitable change h that is small enough for the
approximation to be accurate but not so small that the division of two small
numbers would be inaccurate.  {cmd:mfx} finds this change h by selecting an
initial h and then looping, making h smaller or larger each time through the
loop until it finds a suitable h.

{pstd}
This process can be very time consuming for models with many variables, so you
may want to avoid this by using another method, which we call the "linear
method".  This method uses a different set of formulas so that only a few
derivatives have to be found.  All the remaining derivatives can be obtained
without iteration.

{pstd}
If {cmd:mfx} has trouble obtaining the h for the few derivatives it must
calculate using iteration, you can always use the usual "nonlinear" method.
This will be slower, but because it is a different calculation, it may not have
the same problem.
{p_end}
