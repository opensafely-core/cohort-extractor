{* *! version 1.0.3  04dec2018}{...}
{phang}
{opt initial(initspec)} specifies initial values for the model
parameters to be used in the simulation.  With multiple chains, this option
is equivalent to specifying option {cmd:init1()}.  You can specify a parameter
name, its initial value, another parameter name, its initial value, and so on.
For example, to initialize a scalar parameter {cmd:alpha} to 0.5 and a 2x2
matrix {cmd:Sigma} to the identity matrix {cmd:I(2)}, you can type

{phang3}
  {cmd:bayesmh} ...{cmd:,} {cmd:initial({c -(}alpha{c )-}} {cmd:0.5} {cmd:{c -(}Sigma,m{c )-}} {cmd:I(2))} ... 
 
{pmore}
You can also specify a list of parameters using any of the specifications
described in {mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:{it:Referring to model parameters}}
in {bf:[BAYES] bayesmh}.  For example, to initialize all regression
coefficients from equations {cmd:y1} and {cmd:y2} to zero, you can type

{phang3}
  {cmd:bayesmh} ...{cmd:,} {cmd:initial({c -(}y1:{c )-} {c -(}y2:{c )-} 0)} ... 

{pmore}
The general specification of {it:initspec} is

{pmore2}
{help bayesmh##paramref:{it:paramref}} {it:initval} [{it:paramref} {it:initval} [{...}]]

{pmore}
where {it:initval} is either a number, a Stata expression that evaluates to
a number, or a Stata matrix for initialization of matrix parameters.

{pmore}
Curly braces may be omitted for scalar parameters but must be specified for
matrix parameters.  Initial values declared using this option override the
default initial values or any initial values declared during parameter
specification in the {cmd:likelihood()} option.  See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{cmd:init}{it:#}{cmd:(}{it:{help bayes##initspec:initspec}}{cmd:)} specifies
initial values for the model parameters for the {it:#}th chain.  This option
requires option {cmd:nchains()}.  {cmd:init1()} overrides the default initial
values for the first chain, {cmd:init2()} for the second chain, and so on.
You specify initial values in {cmd:init}{it:#}{cmd:()} just like you do in
option {cmd:initial()}.  See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{opth initall:(bayes##initspec:initspec)} specifies initial values for the
model parameters for all chains.  This option requires option {cmd:nchains()}.
You specify initial values in {cmd:initall()} just like you do in option
{cmd:initial()}.  You should avoid specifying fixed initial values in
{cmd:initall()} because then all chains will use the same initial values.
{cmd:initall()} is useful to specify random initial values when you define
your own priors within {cmd:prior()}'s {cmd:density()} and {cmd:logdensity()}
suboptions.  See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{opt nomleinitial} suppresses using maximum likelihood estimates (MLEs) as
starting values for model parameters.  With multiple chains, this option
and discussion below apply only to the first chain.  By default, when no
initial values are specified, MLE values (when available) are used as initial
values.  If {opt nomleinitial} is specified and no initial values are
provided, the command uses ones for positive scalar parameters, zeros for
other scalar parameters, and identity matrices for matrix parameters.
{cmd:nomleinitial} may be useful for providing an alternative starting state
when checking convergence of MCMC.  This option cannot be combined with
{cmd:initrandom}.

{phang}
{opt initrandom} requests that the model parameters be initialized randomly.
Random initial values are generated from the prior distributions of the model
parameters.  If you want to use fixed initial values for some of the
parameters, you can specify them in the {opt initial()} option or during
parameter declarations in the {opt likelihood()} option.  Random initial
values are not available for parameters with {opt flat}, {opt jeffreys},
{opt density()}, {opt logdensity()}, and {opt jeffreys()} priors; you must
provide your own initial values for such parameters.  This option cannot be
combined with {opt nomleinitial}.  See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{opt initsummary} specifies that the initial values used for simulation be
displayed.
{p_end}
