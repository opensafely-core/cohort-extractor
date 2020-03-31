{* *! version 1.0.0  04dec2018}{...}
{marker chainsspec}{...}
{phang}
{cmd:chains(_all} | {it:{help numlist}}{cmd:)} specifies which chains from the
MCMC sample to use for computation.  The default is {cmd:chains(_all)} or
to use all simulated chains. Using multiple chains, provided the chains have
converged, generally improves MCMC summary statistics. Option {cmd:chains()}
is relevant only when option {cmd:nchains()} is specified with
{helpb bayesmh} or the {helpb bayes} prefix.

{phang}
{opt sepchains} specifies that the results be computed separately for each
chain. The default is to compute results using all chains as determined by
option {opt chains()}. Option {opt sepchains} is relevant only when option
{opt nchains()} is specified with {helpb bayesmh} or the {helpb bayes} prefix.
{p_end}
