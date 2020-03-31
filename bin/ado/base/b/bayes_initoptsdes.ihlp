{* *! version 1.0.1  28mar2017}{...}
{phang}
{opt initial(initspec)} specifies initial values for the model
parameters to be used in the simulation.  You can specify a parameter name,
its initial value, another parameter name, its initial value, and so on.  For
example, to initialize a scalar parameter {cmd:alpha} to 0.5 and a 2x2 matrix
{cmd:Sigma} to the identity matrix {cmd:I(2)}, you can type

{phang3}
  {cmd:bayes}{cmd:,} {cmd:initial({c -(}alpha{c )-}} {cmd:0.5} {cmd:{c -(}Sigma,m{c )-}} {cmd:I(2))}{cmd::} ...
 
{pmore}
You can also specify a list of parameters using any of the specifications
described in {mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:{it:Referring to model parameters}}
in {bf:[BAYES] bayesmh}.  For example, to initialize all regression
coefficients from equations {cmd:y1} and {cmd:y2} to zero, you can type

{phang3}
  {cmd:bayes,} {cmd:initial({c -(}y1:{c )-} {c -(}y2:{c )-} 0)}{cmd::} ...
 
{pmore}
The general specification of {it:initspec} is

{pmore2}
{help bayesmh##paramref:{it:paramref}} {it:#} [{it:paramref} {it:#} [{...}]]

{pmore}
Curly braces may be omitted for scalar parameters but must be specified for
matrix parameters.  Initial values declared using this option override the
default initial values or any initial values declared during parameter
specification in the {cmd:likelihood()} option. See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{opt nomleinitial} suppresses using maximum likelihood estimates (MLEs)
starting values for model parameters.  By default, when no initial values are
specified, MLE values from {it:estimation_command} are used as initial values.
If {opt nomleinitial} is specified and no initial values are provided, the
command uses ones for positive scalar parameters, zeros for other scalar
parameters, and identity matrices for matrix parameters.  {opt nomleinitial}
may be useful for providing an alternative starting state when checking
convergence of MCMC.  This option cannot be combined with {opt initrandom}.  

{phang}
{opt initrandom} requests that the model parameters be initialized randomly.
Random initial values are generated from the prior distributions of the model
parameters.  If you want to use fixed initial values for some of the
parameters, you can specify them in the {opt initial()} option or during
parameter declarations in the {opt likelihood()} option.  Random initial
values are not available for parameters with {opt flat}, {opt density()},
{opt logdensity()}, and {opt jeffreys()} priors; you must provide fixed
initial values for such parameters.   This option cannot be combined with 
{opt nomleinitial}.{p_end}
