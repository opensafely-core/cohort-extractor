{* *! version 1.0.1  12mar2017}{...}
{phang}
{cmd:block(}{help bayesmh##paramref:{it:paramref}}[{cmd:,} {it:blockopts}]{cmd:)}
specifies a group of model parameters for the blocked MH algorithm.  By
default, all parameters except matrices are treated as one block, and each
matrix parameter is viewed as a separate block.  You can use the {opt block()}
option to separate scalar parameters in multiple blocks.  Technically, you can
also use {opt block()} to combine matrix parameters in one block, but this is
not recommended.  The {opt block()} option may be repeated to define multiple
blocks.  Different types of model parameters, such as scalars and matrices,
may not be specified in one {opt block()}.  Parameters within one block are
updated simultaneously, and each block of parameters is updated in the order
it is specified; the first specified block is updated first, the second is
updated second, and so on. See
{mansection BAYES bayesmhRemarksandexamplesImprovingefficiencyoftheMHalgorithm---blockingofparameters:{it:Improving efficiency of the MH algorithm---blocking of parameters}}
in {bf:[BAYES] bayesmh}.

{phang2}
{it:blockopts} include {cmd:gibbs}, {cmd:split}, {cmd:reffects},
{cmd:scale()}, {cmd:covariance()}, and {cmd:adaptation()}.

{phang2}
{opt gibbs} specifies to use Gibbs sampling to update parameters in the
block.  This option is allowed only for specific combinations of likelihood
models and prior distributions; see {mansection BAYES bayesmhMethodsandformulasGibbssamplingforsomelikelihood-priorandprior-hyperpriorconfigurations:{it:Gibbs sampling for some likelihood-prior and prior-hyperprior configurations}}
in {bf:[BAYES] bayesmh}. For more information, see
{mansection BAYES bayesmhRemarksandexamplesGibbsandhybridMHsampling:{it:Gibbs and hybrid MH sampling}}
in {bf:[BAYES] bayesmh}.  {cmd:gibbs} may not be combined with {cmd:reffects},
{cmd:scale()}, {cmd:covariance()}, or {cmd:adaptation()}.

{phang2}
{opt split} specifies that all parameters in a block are treated as separate
blocks.  This may be useful for levels of factor variables.

{phang2}
{opt reffects} specifies that the parameters associated with the levels of a
factor variable included in the likelihood specification be treated as
random-effects parameters.  Random-effects parameters must be included in one
prior statement and are assumed to be conditionally independent across levels
of a grouping variable given all other model parameters.  
{opt reffects} requires that parameters be specified as
{cmd:{c -(}}{it:depvar}{cmd::i.}{it:varname}{cmd:{c )-}}, 
where {cmd:i.}{it:varname} is the corresponding factor variable in the
likelihood specification, and may not be combined with {cmd:block()}'s
suboptions {cmd:gibbs} and {cmd:split}.  This option is useful for fitting
hierarchical or multilevel models.  See {mansection BAYES bayesmhRemarksandexamplesex25:example 25}
in {bf:[BAYES] bayesmh} for details.

{phang2}
{opt scale(#)} specifies an initial multiplier for the scale factor
corresponding to the specified block.  The initial scale factor is computed as
{it:#}/sqrt{n_p} for continuous parameters and as 
{it:#}/n_p for discrete parameters, where n_p is the number of
parameters in the block. The default is {cmd:scale(2.38)}.  If specified, this option overrides the
respective setting from the {cmd:scale()} option specified with the command.
{cmd:scale()} may not be combined with {cmd:gibbs}.

{phang2}
{opt covariance(matname)} specifies a scale matrix {it:matname} to be
used to compute an initial proposal covariance matrix corresponding to the
specified block.  The initial proposal covariance is computed as {it:rho} x
{it:Sigma}, where {it:rho} is a scale factor and {it:Sigma} = {it:matname}.
By default, {it:Sigma} is the identity matrix.  If specified, this option
overrides the respective setting from the {opt covariance()} option specified
with the command.  {opt covariance()} may not be combined with {opt gibbs}.

{phang2}
{cmd:adaptation(tarate())} and {cmd:adaptation(tolerance())} specify
block-specific TAR and acceptance tolerance. If specified,
they override the respective settings from the {opt adaptation()} option
specified with the command.
{opt adaptation()} may not be combined with {opt gibbs}.

{phang}
{opt blocksummary} displays the summary of the specified blocks.  This option
is useful when {opt block()} is specified. 
