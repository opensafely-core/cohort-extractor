{* *! version 1.0.0  11feb2015}{...}
{phang}
{opt intmethod(intmethod)} specifies the integration method to be
used for computing the log likelihood.
{opt mvaghermite} performs mean and variance adaptive
Gauss-Hermite quadrature;
{opt mcaghermite} performs mode and curvature adaptive
Gauss-Hermite quadrature;
and {opt ghermite} performs nonadaptive Gauss-Hermite
quadrature.

{pmore}
The default integration method is {opt mvaghermite}.

{phang}
{opt intpoints(#)} sets the number of integration points for quadrature.
The default is {cmd:intpoints(7)}, which means that seven quadrature points
are used to compute the log likelihood.

{pmore}
The more integration points, the more accurate the approximation to the log
likelihood.  However, computation time increases with the number of
integration points.
{p_end}
