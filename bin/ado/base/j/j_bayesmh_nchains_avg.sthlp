{smcl}
{* *! version 1.0.0  25apr2019}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{title:What are average log marginal-likelihood, acceptance rate, and efficiencies?}

{pstd}
You specified option {cmd:nchains()} with {helpb bayesmh} or the {helpb bayes}
prefix, and the header now reports Avg log marginal-likelihood, Avg acceptance
rate, and Avg efficiencies.

{pstd}
With multiple chains, the commands report an average value computed
across chains for the log marginal-likelihood, acceptance rate, and
efficiency.  For models with multiple parameters, average values of
minimum, maximum, and average efficiencies are reported.  You can use
option {cmd:chainsdetail} to see these values separately for each chain.
{p_end}
