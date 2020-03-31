{smcl}
{* *! version 1.0.0  19may2017}{...}
{title:Random initial state not feasible}

{pstd}
When you specify option {cmd:initrandom} with {helpb bayes} or 
{helpb bayesmh} and use diffuse priors, the command may not always
find a good initial state.  In that case, it will produce error message
"{err:could not find feasible random initial state}".  For example, if you are
using {cmd:bayes} with {help j_bayes_defaultpriors:default priors}, option
{cmd:initrandom} will generate initial values for regression coefficients from
the normal distribution with zero mean and a variance of 10,000 and will
likely produce large values for the coefficients.  For some likelihood
models, large coefficients may produce zero values of the likelihood and thus
missing values for the log likelihood.  In such cases, we recommend using
default initial values, specifying more informative priors, or providing
your own initial values.
{p_end}
