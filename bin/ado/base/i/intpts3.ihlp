{* *! version 1.0.7  05feb2013}{...}
{marker intmethod()}{...}
{dlgtab:Integration}

{phang}
{opt intmethod(intmethod)} specifies the integration method to be used
for the random-effects model.  It accepts one of four arguments:
{opt mvaghermite}, the default for all but a crossed random-effects model,
performs mean and variance adaptive Gauss-Hermite quadrature;
{opt mcaghermite} performs mode and curvature adaptive Gauss-Hermite
quadrature; {opt ghermite} performs nonadaptive Gauss-Hermite quadrature; and
{opt laplace}, the default for crossed random-effects models, performs
the Laplacian approximation. 

{phang} {opt intpoints(#)} specifies the number of integration points to use
for integration by quadrature.  The default is {cmd:intpoints(12)}; the
maximum is {cmd:intpoints(195)}.  Increasing this value improves accuracy but
also increases computation time.  Computation time is roughly proportional to
its value.
