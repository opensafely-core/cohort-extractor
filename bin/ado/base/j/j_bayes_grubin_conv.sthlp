{smcl}
{* *! version 1.0.0  19jun2019}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{title:Convergence rules for the Gelman-Rubin statistic}

{pstd}
The Gelman-Rubin (1992) statistic convergence statistic, {it:Rc}, is a
diagnostic used for assessing the convergence of MCMC based on multiple
chains.  {it:Rc} measures the between-chains variability relative to the
within-chain variability.  If all chains have converged, {it:Rc} should be
close to 1.

{pstd}
Brooks and Gelman (1998) suggest that the MCMC convergence can be declared
when {it:Rc} is less than 1.2 for all model parameters.  A more stringent
convergence rule, {it:Rc} < 1.1, is often used in practice.  See
{mansection BAYES bayesstatsgrubinRemarksandexamplesGelman--Rubinconvergencediagnostic:{it:Gelman-Rubin convergence diagnostic}}
in {bf:[BAYES] bayesstats grubin} for details.

{pstd}
When you simulate multiple chains using {helpb bayesmh} or {helpb bayes} or
subsequently use {helpb bayesstats grubin} to check MCMC convergence, the
commands report the maximum value of {it:Rc} across all model parameters
(except random-effects parameters for multilevel models) in the header.  In
this way, you can quickly assess whether some of the above convergence rules
are satisfied for all parameters.

{pstd}
With {helpb bayesstats grubin}, you can use option {cmd:sort} to list model
parameters in descending order of their convergence statistics {it:Rc}.  The
parameters with the largest values of {it:Rc} will be listed first, making it
easier to verify their convergence.

{pstd}
For multilevel models, convergence statistics are not reported for the
random-effects parameters by default.  If these parameters are of primary
interest in your study, you should use option {cmd:showreffects} or
{opt showreffects(reref)} to obtain convergence statistics for all
random-effects parameters or for their subset {it:reref}.

{pstd}
Also see {mansection BAYES bayesmhRemarksandexamplesConvergencediagnosticsusingmultiplechains:{it:Convergence diagnostics using multiple chains}} 
in {bf:[BAYES] bayesmh},
{mansection BAYES bayesstatsgrubinRemarksandexamplesGelman--Rubinconvergencediagnostic:{it:Gelman-Rubin convergence diagnostic}}
in {bf:[BAYES] bayesstats grubin}, and
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}}
in {bf:[BAYES] bayesmh}.


{title:References}

{marker brooks1998}{...}
{phang}
Brooks, S. P., and A. Gelman. 1998.
General methods for monitoring convergence of iterative simulations.
{it:Journal of Computational and Graphical Statistics} 7: 434-455.

{marker gelmanrubin1992}{...}
{phang}
Gelman, A., and D. B. Rubin. 1992.
Inference from iterative simulation using multiple sequences.
{it:Statistical Science} 7: 457-472.
{p_end}
