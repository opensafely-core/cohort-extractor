{smcl}
{* *! version 1.0.0  16mar2015}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{title:Adaptation continues during simulation}

{pstd}
At the bottom of the parameter-estimates table, you may see a note about
adaptation continuing during simulation.  Adaptation is part of
Metropolis-Hastings sampling and thus does not apply to the blocks of
parameters updated using Gibbs sampling.  You will typically see this
message when you increase the number of adaptive iterations by using option
{cmd:adaptation(maxiter())} without correspondingly increasing the length of
the burn-in period with option {cmd:burnin()}.

{pstd}
This note does not necessarily indicate a problem.  It simply notifies you
that the proposal distribution is still in the period of adaptation after the
burn-in period.  This is often the case with so-called continuous
adaptation such as diminishing adaptation, when parameters are allowed to
adapt continuously during the burn-in and simulation periods, but they adapt
less and less as the algorithm proceeds.  By default, {cmd:bayesmh} does not
perform diminishing adaptation and thus notifies you when adaptation continues
during simulation.  The default adaptation settings of {cmd:bayesmh} are
chosen such that the adaptation stops after the burn-in period, regardless of
whether the adaptation tolerance is met. (See 
{help j_bayesmh_adapttol:Adaptation tolerance is not met} for more
information.)  You can request diminishing adaptation by specifying a value
other than the default of 0 in option {cmd:adaptation(gamma())}.
{p_end}
