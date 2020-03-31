{smcl}
{* *! version 1.0.0  16mar2015}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{title:Adaptation tolerance is not met}

{pstd}
At the bottom of the parameter-estimates table, you may see a note about the
adaptation tolerance not being met in at least one of the blocks of
parameters.  Adaptation is part of Metropolis-Hastings sampling and thus
does not apply to the blocks of parameters updated using Gibbs sampling.

{pstd}
This note does not necessarily indicate a problem. It simply notifies you that
the default target acceptance rate as specified in option
{cmd:adaptation(tarate())} has not been reached within the tolerance specified
in option {cmd:adaptation(tolerance())}.  The default used for the target
acceptance rate corresponds to the theoretical asymptotically optimal
acceptance rate of 0.44 for a block with one parameter and 0.234 for a block
with multiple parameters.  The rate is derived for a specific class of models
and does not necessarily represent the optimal rate for all models.  If your
MCMC converged, you can safely ignore this note.  Otherwise, you need to
investigate your model further.  One remedy is to increase the burn-in period,
which automatically increases the adaptation period, or more specifically, the
number of adaptive iterations as controlled by option
{cmd:adaptation(maxiter())}.
{p_end}
