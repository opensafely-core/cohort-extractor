{smcl}
{* *! version 1.0.0  20nov2018}{...}
{title:What is maximum Gelman-Rubin Rc?}

{pstd}
When you simulate multiple chains using {helpb bayesmh} or {helpb bayes}, the
commands report the maximum value of the Gelman-Rubin convergence statistic,
{it:Rc}, across all model parameters (except random-effects parameters for
multilevel models) in the header.  This statistic is used for assessing the
convergence of multiple Markov chains.  By looking at the maximum value, you
can quickly assess whether convergence rules are satisfied for all parameters.
When the maximum {it:Rc} is larger than 1.2, you should suspect nonconvergence
and investigate your model further; see 
{help j_bayes_grubin_conv:Convergence rules for the Gelman-Rubin statistic}
and {helpb bayesstats grubin} for details.
{p_end}
