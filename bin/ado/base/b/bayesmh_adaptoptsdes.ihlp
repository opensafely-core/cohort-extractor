{* *! version 1.0.0  10jan2017}{...}
{phang}
{opt adaptation(adaptopts)} controls adaptation of the MCMC procedure.
Adaptation takes place every prespecified number of MCMC iterations and
consists of tuning the proposal scale factor and proposal covariance for each
block of model parameters.  Adaptation is used to improve sampling efficiency.
Provided defaults are based on theoretical results and may not be sufficient
for all applications.  See {mansection BAYES bayesmh RemarksandexamplesAdaptationoftheMHalgorithm:{it:Adaptation of the MH algorithm}}
in {bf:[BAYES] bayesmh} for details about adaptation and its parameters.

{pmore}
{it:adaptopts} are any of the following options:  

{phang2}
{opt every(#)} specifies that adaptation be attempted every {it:#}th
iteration.  The default is {cmd:every(100)}.  To determine the adaptation
interval, you need to consider the maximum block size specified in your model.
The update of a block with k model parameters requires the estimation of
a k x k covariance matrix.  If the adaptation interval is not sufficient
for estimating the k(k+1)/2 elements of this matrix, the adaptation
may be insufficient.

{phang2}
{opt maxiter(#)} specifies the maximum number of adaptive
iterations.  Adaptation includes tuning of the proposal covariance and of the
scale factor for each block of model parameters.  Once the TAR is achieved
within the specified tolerance, the adaptation stops.  However, no more than
{it:#} adaptation steps will be performed.  The default is variable and is
computed as max{25,{cmd:floor(burnin()/adaptation(every()))}}.

{pmore2}
{cmd:maxiter()} is usually chosen to be no greater than
({cmd:mcmcsize()}+{cmd:burnin()})/{cmd:adaptation(every())}.

{phang2}
{opt miniter(#)} specifies the minimum number of adaptive iterations to be
performed regardless of whether the TAR has been achieved.  The default is
{cmd:miniter(5)}.  If the specified {opt miniter()} is greater than
{opt maxiter()}, then {opt miniter()} is reset to {opt maxiter()}.  Thus, if
you specify {cmd:maxiter(0)}, then no adaptation will be performed.

{phang2}
{opt alpha(#)} specifies a parameter controlling the adaptation of the
AR.  {opt alpha()} should be in [0,1].  The default is {cmd:alpha(0.75)}.

{phang2}
{opt beta(#)} specifies a parameter controlling the adaptation of the
proposal covariance matrix.  {opt beta()} must be in [0,1].  The closer
{opt beta()} is to zero, the less adaptive the proposal covariance.  When
{opt beta()} is zero, the same proposal covariance will be used in all MCMC
iterations.  The default is {cmd:beta(0.8)}.

{phang2}
{opt gamma(#)} specifies a parameter controlling the adaptation rate
of the proposal covariance matrix.  {opt gamma()} must be in [0,1].  The
larger the value of {opt gamma()}, the less adaptive the proposal covariance.
The default is {cmd:gamma(0)}.

{phang2}
{opt tarate(#)} specifies the TAR for all blocks of model parameters; this is
rarely used.  {opt tarate()} must be in (0,1).  The default AR is 0.234 for
blocks containing continuous multiple parameters, 0.44 for blocks with one
continuous parameter, and 1/{it:n_maxlev} for blocks with discrete
parameters, where {it:n_maxlev} is the maximum number of levels for a
discrete parameter in the block.

{phang2}
{opt tolerance(#)} specifies the tolerance criterion for adaptation
based on the TAR.  {opt tolerance()} should be in (0,1).
Adaptation stops whenever the absolute difference between the current AR and
TAR is less than {opt tolerance()}.  The default is {cmd:tolerance(0.01)}.

{phang}
{opt scale(#)} specifies an initial multiplier for the scale factor for
all blocks.  The initial scale factor is computed as {it:#}/sqrt{n_p}
for continuous parameters and {it:#}/n_p for discrete parameters,
where n_p is the number of parameters in the block.  The default is
{cmd:scale(2.38)}.

{phang}
{opt covariance(cov)} specifies a scale matrix {it:cov} to be used to
compute an initial proposal covariance matrix.  The initial proposal
covariance is computed as rho x Sigma, where rho is a scale factor
and Sigma = {it:matname}.  By default, Sigma is the identity matrix.
Partial specification of Sigma is also allowed.  The rows and columns of
{it:cov} should be named after some or all model parameters.  According to
some theoretical results, the optimal proposal covariance is the posterior
covariance matrix of model parameters, which is usually unknown.
