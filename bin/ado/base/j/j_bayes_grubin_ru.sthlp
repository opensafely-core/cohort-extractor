{smcl}
{* *! version 1.0.0  20nov2018}{...}
{title:Gelman-Rubin Ru}

{pstd}
The Gelman-Rubin {it:Ru} statistic is an upper confidence limit for the
{it:Rc} diagnostic statistic used for assessing the convergence of Markov
chains.  {it:Ru} is calculated with respect to a prespecified coverage
probability, 0.95 by default, and assumes that the posterior distribution is
normal.  In a perfect case of convergence, {it:Rc} estimates are less than the
corresponding {it:Ru} estimates for all model parameters.  Often, this is a
too strict condition, and we consider the convergence test to have passed when
the maximum {it:Rc} is less than 1.1.  For the detailed Gelman-Rubin
convergence diagnostic, use the {helpb bayesstats grubin} command.
{p_end}
