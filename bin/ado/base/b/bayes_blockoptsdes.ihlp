{* *! version 1.0.0  10jan2017}{...}
{phang}
{cmd:block(}{help bayesmh##paramref:{it:paramref}}[{cmd:,} {it:blockopts}]{cmd:)}
specifies a group of model parameters for the blocked MH algorithm.  By
default, model parameters are sampled as independent blocks of 50 parameters
or of the size specified in option {opt blocksize()}.  Regression coefficients
from different equations are placed in separate blocks.  Auxiliary parameters
such as variances and correlations are sampled as individual separate blocks,
whereas the cutpoint parameters of the ordinal-outcome regressions are sampled
as one separate block.  The {opt block()} option may be repeated to define
multiple blocks.  Different types of model parameters, such as scalars and
matrices, may not be specified in one {opt block()}.  Parameters within one
block are updated simultaneously, and each block of parameters is updated in
the order it is specified; the first specified block is updated first, the
second is updated second, and so on. See
{mansection BAYES bayesmhRemarksandexamplesImprovingefficiencyoftheMHalgorithm---blockingofparameters:{it:Improving efficiency of the MH algorithm---blocking of parameters}}
in {bf:[BAYES] bayesmh}.

{phang2}
{it:blockopts} include {cmd:gibbs}, {cmd:split}, 
{cmd:scale()}, {cmd:covariance()}, and {cmd:adaptation()}.

{phang2}
{opt gibbs} specifies to use Gibbs sampling to update parameters in the
block.  This option is allowed only for specific combinations of likelihood
models and prior distributions; see {mansection BAYES bayesmhMethodsandformulasGibbssamplingforsomelikelihood-priorandprior-hyperpriorconfigurations:{it:Gibbs sampling for some likelihood-prior and prior-hyperprior configurations}}
in {bf:[BAYES] bayesmh}. For more information, see
{mansection BAYES bayesmhRemarksandexamplesGibbsandhybridMHsampling:{it:Gibbs and hybrid MH sampling}}
in {bf:[BAYES] bayesmh}.  {cmd:gibbs} may not be combined with 
{cmd:scale()}, {cmd:covariance()}, or {cmd:adaptation()}.

{phang2}
{opt split} specifies that all parameters in a block are treated as separate
blocks.  This may be useful for levels of factor variables.

{phang2}
{opt scale(#)} specifies an initial multiplier for the scale factor
corresponding to the specified block.  The initial scale factor is computed as
{it:#}/sqrt{n_p} for continuous parameters and as 
{it:#}/n_p for discrete parameters, where n_p is the number of
parameters in the block. The default is {cmd:scale(2.38)}.  If specified, this option overrides the
respective setting from the {cmd:scale()} option specified with the command.
{cmd:scale()} may not be combined with {cmd:gibbs}.

{phang}
{opt covariance(matname)} specifies a scale matrix {it:matname} to be
used to compute an initial proposal covariance matrix corresponding to the
specified block.  The initial proposal covariance is computed as {it:rho} x
{it:Sigma}, where {it:rho} is a scale factor and {it:Sigma} = {it:matname}.
By default, {it:Sigma} is the identity matrix.  If specified, this option
overrides the respective setting from the {opt covariance()} option specified
with the command.  {opt covariance()} may not be combined with {opt gibbs}.

{phang}
{cmd:adaptation(tarate())} and {cmd:adaptation(tolerance())} specify
block-specific TAR and acceptance tolerance. If specified,
they override the respective settings from the {opt adaptation()} option
specified with the command.
{opt adaptation()} may not be combined with {opt gibbs}.

{phang}
{opt blocksummary} displays the summary of the specified blocks.  This option
is useful when {opt block()} is specified. 
