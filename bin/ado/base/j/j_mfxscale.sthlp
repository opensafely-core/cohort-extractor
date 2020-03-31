{smcl}
{* *! version 1.0.5  02feb2012}{...}
{vieweralsosee "[R] mfx" "help mfx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: Scaling and marginal effects" "browse http://www.stata.com/support/faqs/stat/mfx_scale.html"}{...}
{viewerjumpto "Rescaling warning message" "j_mfxscale##warning"}{...}
{viewerjumpto "Examples" "j_mfxscale##examples"}{...}
{marker warning}{...}
{title:Rescaling warning message}

{pstd}
A marginal effect is a derivative.  To find a derivative numerically, 
{cmd:mfx} uses the approximation  (f(x+h)-f(x))/h.

{pstd}
Thus {cmd:mfx} must find a suitable change h that is small enough for the
approximation to be accurate but not so small that the division of two small
numbers would be inaccurate.

{pstd}
Usually {cmd:mfx} has no trouble doing this in obtaining a marginal effect,
which is the derivative of the prediction function with respect to each
independent variable x.

{pstd}
To calculate the standard error of a marginal effect, {cmd:mfx} uses
the delta method and must calculate the derivative of the marginal effect with
respect to each coefficient in the model.  To do this, {cmd:mfx} looks for a
suitable small change in the coefficient b.  Problems arise when a small
change in b causes a large change in marginal effect, making it difficult for
mfx to find a suitable change in b.  The warning message is issued after
{cmd:mfx} has gone though 50 iterations of its search for a suitable change.

{pstd}
The message shows which variable had the problem.  Rescaling that variable
means dividing or multiplying the variable by a number and then running the
estimation command again before running {cmd:mfx} again.

{pstd}
When you divide a variable by, say, 100, both the marginal effect of that
variable and its standard error are divided by 100, meaning that we get the
same test statistic and p-value.  The marginal effects and standard errors of
other variables will be unchanged; however {cmd:mfx} may be more successful in
its search for a suitable change in b.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. replace mpg=mpg*100000000}{p_end}
{phang}{cmd:. gen mpg2=mpg*mpg}{p_end}
{phang}{cmd:. mlogit rep mpg mpg2 turn, nolog}{p_end}
{phang}{cmd:. mfx, predict(p outcome(1)) varlist(mpg)  tracelvl(3)}{p_end}
{phang}{cmd:. replace mpg=mpg/1000000}{p_end}
{phang}{cmd:. replace mpg2=mpg*mpg}{p_end}
{phang}{cmd:. mlogit rep mpg mpg2 turn, nolog}{p_end}
{phang}{cmd:. mfx, predict(p outcome(1)) varlist(mpg)  tracelvl(3)}{p_end}

{phang}{cmd:. webuse school}{p_end}
{phang}{cmd:. heckprobit private years logptax, select(vote= years loginc)}{p_end}
{phang}{cmd:. mfx, predict(xbsel) tracelvl(2)}{p_end}
{phang}{cmd:. mfx, predict(xbsel) tracelvl(3) varlist(years)}{p_end}
{phang}{cmd:. replace loginc=loginc/10}{p_end}
{phang}{cmd:. heckprobit private years logptax, select(vote= years loginc)}{p_end}
{phang}{cmd:. mfx, predict(xbsel) tracelvl(3) varlist(years)}{p_end}
