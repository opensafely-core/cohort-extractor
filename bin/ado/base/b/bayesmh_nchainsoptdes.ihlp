{* *! version 1.0.0  04dec2018}{...}
{phang}
{opt nchains(#)} specifies the number of Markov chains to simulate. You
must specify at least two chains. By default, only one chain is produced.
Simulating multiple chains is useful for convergence diagnostics and to
improve precision of parameter estimates. Four chains are often recommended in
the literature, but you can specify more or less depending on your objective.
The reported estimation results are based on all chains. You can use
{helpb bayesstats summary} with option
{cmd:sepchains} to see the results for each chain. The reported acceptance
rate, efficiencies, and log marginal-likelihood are averaged over all chains.
You can use option {cmd:chainsdetail} to see these simulation summaries for
each chain. Also see
{mansection BAYES bayesmhRemarksandexamplesConvergencediagnosticsusingmultiplechains:{it:Convergence diagnostics using multiple chains}}
in {bf:[BAYES] bayesmh} and
{mansection BAYES bayesstatsgrubinRemarksandexamplesGelman--Rubinconvergencediagnostic:{it:Gelman-Rubin convergence diagnostic}} in
{bf:[BAYES] bayesstats grubin}.
{p_end}
