{* *! version 1.0.0  19feb2015}{...}
{phang}
{opt conditional(ctype)} and {cmd:marginal} specify how latent
variables are handled in computing {it:statistic}.

{phang2}
{opt conditional()} specifies that {it:statistic} will be computed
conditional on specified or estimated latent variables.

{phang3}
{cmd:conditional(ebmeans)}, the default, specifies that empirical Bayes means
be used as the estimates of the latent variables.
These estimates are also known as posterior mean estimates of the latent
variables.

{phang3}
{cmd:conditional(ebmodes)} specifies that empirical Bayes modes be used as the
estimates of the latent variables.
These estimates are also known as posterior mode estimates of the latent
variables.

{phang3}
{cmd:conditional(fixedonly)} specifies that all latent variables be set to
zero, equivalent to using only the fixed portion of the model.

{phang2}
{opt marginal} specifies that the predicted {it:statistic} be computed
marginally with respect to the latent variables, which means that
{it:statistic} is calculated by integrating the prediction function with
respect to all the latent variables over their entire support.

{pmore2}
Although this is not the default, marginal predictions are often very
useful in applied analysis.
They produce what are commonly called population-averaged estimates.
{p_end}
