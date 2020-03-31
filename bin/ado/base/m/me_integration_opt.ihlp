{* *! version 1.0.4  29jan2015}{...}
{phang}
{opt intmethod(intmethod)} specifies the integration method to be used for the
random-effects model.
{cmd:mvaghermite} performs mean-variance adaptive Gauss-Hermite quadrature;
{cmd:mcaghermite} performs mode-curvature adaptive Gauss-Hermite quadrature;
{cmd:ghermite} performs nonadaptive Gauss-Hermite quadrature; and
{cmd:laplace} performs the Laplacian approximation, equivalent to
mode-curvature adaptive Gaussian quadrature with one integration point.

{pmore}
The default integration method is {cmd:mvaghermite} unless a crossed
random-effects model is fit, in which case the default integration method is
{cmd:laplace}.  The Laplacian approximation has been known to produce biased
parameter estimates; however, the bias tends to be more prominent in the
estimates of the variance components rather than in the estimates of the fixed
effects.

{pmore}
For crossed random-effects models, estimation with more than one quadrature
point may be prohibitively intensive even for a small number of levels.  For
this reason, the integration method defaults to the Laplacian approximation.
You may override this behavior by specifying a different integration method.

{phang}
{opt intpoints(#)} sets the number of integration points for quadrature.
The default is {cmd:intpoints(7)}, which means that seven quadrature points
are used for each level of random effects.
This option is not allowed with {bf:intmethod(laplace)}.

{pmore}
The more integration points, the more accurate the approximation to the log
likelihood.  However, computation time increases as a function of the number
of quadrature points raised to a power equaling the dimension of the
random-effects specification.  In crossed random-effects models and in models
with many levels or many random coefficients, this increase can be
substantial.
{p_end}
