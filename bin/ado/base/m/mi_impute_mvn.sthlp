{smcl}
{* *! version 1.0.23  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute mvn" "mansection MI miimputemvn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute chained" "help mi_impute_chained"}{...}
{vieweralsosee "[MI] mi impute monotone" "help mi_impute_monotone"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_mvn##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_mvn##menu"}{...}
{viewerjumpto "Description" "mi_impute_mvn##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_mvn##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_mvn##options"}{...}
{viewerjumpto "Examples" "mi_impute_mvn##examples"}{...}
{viewerjumpto "Stored results" "mi_impute_mvn##results"}{...}
{viewerjumpto "Reference" "mi_impute_mvn##reference"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MI] mi impute mvn} {hline 2}}Impute using multivariate normal regression{p_end}
{p2col:}({mansection MI miimputemvn:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:mi} {cmdab:imp:ute} {cmd:mvn} {it:ivars}
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:options}]


{synoptset 30 tabbed}{...}
{marker options_table}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}

{syntab:MCMC options}
{synopt: {opt burn:in(#)}}specify number of iterations for the burn-in period; default is {cmd:burnin(100)}{p_end}
{synopt: {opt burnb:etween(#)}}specify number of iterations between imputations; default is {cmd:burnbetween(100)}{p_end}
{synopt: {opth pri:or(mi_impute_mvn##prior:prior_spec)}}specify a prior distribution; default is {cmd:prior(uniform)}{p_end}
{synopt: {opt mcmconly}}perform MCMC for the length of the burn-in period without imputing missing values{p_end}
{synopt: {opth initm:cmc(mi_impute_mvn##initda:init_mcmc)}}specify initial values for the MCMC procedure; default is {cmd:initmcmc(em)} using EM estimates for initial values{p_end}
{synopt: {opt wlfwgt(matname)}}specify weights for the worst linear function{p_end}
{synopt:{cmdab:savew:lf(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save WLF from each iteration in {it:filename}{cmd:.dta}{p_end}
{synopt:{cmdab:savep:trace(}{it:fname}[{cmd:, replace}]{cmd:)}}save MCMC
parameter estimates from each iteration in {it:fname}{cmd:.stptrace}; see 
{manhelp mi_ptrace MI: mi ptrace}{p_end}

{syntab:Reporting}
{synopt: {opt emlog}}display iteration log from EM{p_end}
{synopt: {opt emout:put}}display intermediate output from EM estimation{p_end}
{synopt: {opt mcmcdots}}display dots as MCMC iterations are performed{p_end}
{synopt: {opt alldots}}display dots as intermediate iterations are performed
{p_end}
{synopt: {opt nolog}}do not display information about the EM or MCMC 
   procedures{p_end}

{syntab:Advanced}
{synopt: {cmd:emonly}[{cmd:(}{it:{help mi_impute_mvn##em_opts:em_options}}{cmd:)}]}perform EM estimation only{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute}
{cmd:mvn}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} {it:ivars} as imputed before using {cmd:mi} 
{cmd:impute} {cmd:mvn}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}


{synoptset 30}{...}
{marker prior}{...}
{synopthdr:prior_spec}
{synoptline}
{synopt: {opt u:niform}}use the uniform prior distribution; the default{p_end}
{synopt: {opt j:effreys}}use the Jeffreys noninformative prior distribution{p_end}
{synopt: {opt r:idge, df(#)}}use a ridge prior distribution with degrees of freedom {it:#}{p_end}
{synoptline}


{synoptset 30}{...}
{marker initda}{...}
{synopthdr:init_mcmc}
{synoptline}
{synopt: {opt em} [{cmd:,} {it:{help mi_impute_mvn##em_opts:em_options}}]}use EM to obtain starting values for MCMC; the default{p_end}
{synopt: {it:{help mi_impute_mvn##initmatlist:initmatlist}}}supply matrices containing initial values for MCMC{p_end}
{synoptline}


{synoptset 30}{...}
{marker em_opts}{...}
{synopthdr:em_options}
{synoptline}
{synopt: {opt iter:ate(#)}}specify the maximum number of iterations; default is {cmd:iterate(100)}{p_end}
{synopt: {opt tol:erance(#)}}specify tolerance for the changes in parameter estimates; default is {cmd:tolerance(1e-5)}{p_end}
{synopt: {opth init:(mi_impute_mvn##initem:init_em)}}specify initial values for the EM algorithm; default is {cmd:init(ac)}{p_end}
{synopt: {opt nolog}}do not show EM iteration log{p_end}
{synopt:{cmdab:savep:trace(}{it:fname}[{cmd:, replace}]{cmd:)}}save
EM parameter estimates from each iteration in {it:fname}{cmd:.stptrace};
           {manhelp mi_ptrace MI: mi ptrace}{p_end}
{synoptline}


{synoptset 30}{...}
{marker initem}{...}
{synopthdr:init_em}
{synoptline}
{synopt: {opt ac}}use all available cases to obtain initial values for EM; the default{p_end}
{synopt: {opt cc}}use only complete cases to obtain initial values for EM{p_end}
{synopt: {it:{help mi_impute_mvn##initmatlist:initmatlist}}}supply matrices containing initial values for EM{p_end}
{synoptline}


{phang}
{marker initmatlist}{...}
{it:initmatlist} is of the form {it:{help mi_impute_mvn##initmat:initmat}} [{it:initmat} [...]]


{synoptset 30}{...}
{marker initmat}{...}
{synopthdr:initmat}
{synoptline}
{synopt: {opt b:etas(#|matname)}}specify coefficient vector; default is {cmd:betas(0)}{p_end}
{synopt: {opt sd:s(#|matname)}}specify standard deviation vector; default is {cmd:sds(1)}{p_end}
{synopt: {opt var:s(#|matname)}}specify variance vector; default is {cmd:vars(1)}{p_end}
{synopt: {opt corr(#|matname)}}specify correlation matrix; default is {cmd:corr(0)}{p_end}
{synopt: {opt cov(matname)}}specify covariance matrix{p_end}
{synoptline}
{pstd}
In the above, {it:#} is understood to mean a vector containing all elements
equal to {it:#}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} {cmd:mvn} fills in missing values of one or more
continuous variables using multivariate normal regression.  It accommodates
arbitrary missing-value patterns. You can perform separate imputations on
different subsets of the data by specifying the {cmd:by()} option.  {cmd:mi}
{cmd:impute} {cmd:mvn} uses an iterative Markov chain Monte Carlo (MCMC) method
to impute missing values.  See 
{mansection MI miimputemvnRemarksandexamples:{it:Remarks and examples}} in
{bf:[MI] mi impute mvn} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputemvnRemarksandexamples:Remarks and examples}

        {mansection MI miimputemvnMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:noconstant}; see {manhelp estimation_options R:Estimation options}.

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see 
{manhelp mi_impute MI:mi impute}.

{dlgtab:MCMC options}

{phang}
{opt burnin(#)} specifies the number of iterations for the initial
burn-in period.  The default is {cmd:burnin(100)}.  This option specifies the
number of iterations necessary for the MCMC to reach approximate
stationarity or, equivalently, to converge to a stationary distribution.  The
required length of the burn-in period will depend on the starting values used
and the missing-data patterns observed in the data.  It is important to
examine the chain for convergence to determine an adequate length of the
burn-in period prior to obtaining imputations; see 
{mansection MI miimputemvnRemarksandexamplesConvergenceoftheMCMCmethod:{it:Convergence of the MCMC method}}
and examples
{mansection MI miimputemvnRemarksandexamplesex2:2}
and 
{mansection MI miimputemvnRemarksandexamplesex4:4} in {bf:[MI] mi impute mvn}.
The provided default may be sufficient in many cases, but you are responsible
for determining that sufficient iterations are performed.

{phang}
{opt burnbetween(#)} specifies a number of iterations of the MCMC
to perform between imputations, the purpose being to reduce correlation between
sets of imputed values.  The default is {cmd:burnbetween(100)}.  As with
{cmd:burnin()}, you are responsible for determining that sufficient iterations
are performed. See 
{mansection MI miimputemvnRemarksandexamplesConvergenceoftheMCMCmethod:{it:Convergence of the MCMC method}} and examples
{mansection MI miimputemvnRemarksandexamplesex2:2}
and 
{mansection MI miimputemvnRemarksandexamplesex4:4} in {bf:[MI] mi impute mvn}.

{phang}
{opt prior(prior_spec)} specifies a prior distribution to be used by
the MCMC procedure.  The default is {cmd:prior(uniform)}.  The alternative
prior distributions are useful when the default estimation of the parameters
using maximum likelihood becomes unstable (for example, estimates on the
boundary of the parameter space) and introducing some prior information about
parameters stabilizes the estimation.

{pmore}
{it:prior_spec} is

            {opt u:niform} {c |} {opt j:effreys} {c |} {opt r:idge,} {opt df(#)}

{phang3}
{cmd:uniform} specifies the uniform (flat) prior distribution.  Under this
prior distribution, the posterior distribution is proportional to the
likelihood function and thus the estimate of the posterior mode is the same as
the maximum likelihood (ML) estimate.

{phang3}
{cmd:jeffreys} specifies the Jeffreys, noninformative prior distribution.
This prior distribution can be used when there is no strong prior knowledge
about the model parameters.

{phang3}
{cmd:ridge,} {opt df(#)} specifies a ridge, informative prior
distribution with the degrees of freedom {it:#}.  This prior introduces some
information about the covariance matrix by smoothing the off-diagonal elements
(correlations) toward zero.  The degrees of freedom, {cmd:df()}, which may be
noninteger, regulates the amount of smoothness -- the larger this number,
the closer the correlations are to zero.  A ridge prior is useful to stabilize
inferences about the mean parameters when the covariance matrix is poorly
estimated, for example, when there are insufficient observations to estimate
correlations between some variables reliably because of missing data, causing
the estimated covariance matrix to become non-positive definite (see
{help mi impute mvn##S1997:Schafer [1997, 155-157]} for details).

{phang}
{cmd:mcmconly} specifies that {cmd:mi} {cmd:impute} {cmd:mvn} run the MCMC for
the length of the burn-in period and then stop.  This option is useful in
combination with {cmd:savewlf()} or {cmd:saveptrace()} to examine the
convergence of the MCMC prior to imputation.  No imputation is performed
when {cmd:mcmconly} is specified, so {cmd:add()} or {cmd:replace} is not
required with {cmd:mi} {cmd:impute} {cmd:mvn,} {cmd:mcmconly}, and they are
ignored if specified.  The {cmd:mcmconly} option is not allowed with
{cmd:emonly}.

{phang}
{cmd:initmcmc()} may be specified as
{cmd:initmcmc(em} [{cmd:,} {it:em_options}]{cmd:)} or
{cmd:initmcmc(}{it:initmatlist}{cmd:)}.

{pmore}
{cmd:initmcmc()} specifies initial values for the regression coefficients and
covariance matrix of the multivariate normal distribution to be used by the
MCMC procedure.  By default, initial values are obtained from the EM
algorithm, {cmd:initmcmc(em)}.

{phang}
{cmd:initmcmc(em} [{cmd:,} {it:em_options}{cmd:)} specifies that the initial
values for the MCMC procedure be obtained from EM.  You can control the
EM estimation by specifying {it:em_options}.  If the uniform prior is
used, the initial estimates correspond to the ML estimates computed using
EM.  Otherwise, the initial values are the estimates of the posterior mode
computed using EM.

{marker em_options}{...}
{pmore}
{it:em_options} are 

{phang3}
{opt iterate(#)} specifies the maximum number of EM
iterations to perform.  The default is {cmd:iterate(100)}.

{phang3}
{opt tolerance(#)} specifies the convergence tolerance for the EM
algorithm.  The default is {cmd:tolerance(1e-5)}.  Convergence is declared
once the maximum of the relative changes between two successive estimates of
all model parameters is less than {it:#}.

{phang3}
{cmd:init()} may be specified as {cmd:init(ac)}, {cmd:init(cc)}, or
{opt init(matlist)}

{pmore3}
{cmd:init()} specifies initial values for the regression coefficients and
covariance matrix of the multivariate normal distribution to be used by the
EM algorithm.  {cmd:init(ac)} is the default.

{p 16 20 2}
{cmd:init(ac)} specifies that initial estimates be obtained using all
available cases.  The initial values for regression coefficients are obtained
from separate univariate regressions of each imputation variable on the
independent variables.  The corresponding estimates of the residual
mean-squared error are used as the initial values for the diagonal entries of
the covariance matrix (variances).  The off-diagonal entries (correlations)
are set to zero.

{p 16 20 2}
{cmd:init(cc)} specifies that initial estimates be obtained using only
complete cases.  The initial values for regression coefficients and the
covariance matrix are obtained from a multivariate regression fit to the
complete cases only.

{p 16 20 2}
{opt init(initmatlist)} specifies to use manually supplied initial
values for the EM procedure and syntactically is identical to
{opt mcmcinit(initmatlist)}, described below, except that you specify
{opt init(initmatlist)}.

{phang3}
{cmd:nolog} suppresses the EM iteration log when {cmd:emonly} or
{cmd:emoutput} is used.

{phang3}
{cmd:saveptrace(}{it:fname} [{cmd:, replace}]{cmd:)} specifies to save the
parameter trace log from the EM algorithm to a file called
{it:fname}{cmd:.stptrace}.  If the file already exists, the {cmd:replace}
suboption specifies to overwrite the existing file.  See
{manhelp mi_ptrace MI:mi ptrace} for
details about the saved file and how to read it into Stata.

{phang}
{opt initmcmc(initmatlist)}, where {it:initmatlist} is

        {it:initmat} [{it:initmat} [...]]

{pmore}
specifies manually supplied initial values for the MCMC procedure.

{pmore}
{it:initmat} is

{phang2}
{opt betas(# | matname)} specifies initial values for
the regression coefficients.  The default is {cmd:betas(0)}, implying a value
of zero for all regression coefficients.  If you specify
{opt betas(#)}, then {it:#} will be used as the initial value for all
regression coefficients.  Alternatively, you can specify the name of a Stata
matrix, {it:matname}, containing values for each regression coefficient.
{it:matname} must be conformable with the dimensionality of the specified
model.  That is, it can be one of the following dimensions: p {it:x} q,
q {it:x} p, 1 {it:x} pq, or pq {it:x} 1, where p is the number of
imputation variables and q is the number of independent variables.

{phang2}
{opt sds(# | matname)} specifies initial values for the
standard deviations (square roots of the diagonal elements of the covariance
matrix).  The default is {cmd:sds(1)}, which sets all standard deviations and
thus variances to one.  If you specify {opt sds(#)}, then the squared
{it:#} will be used as the initial value for all variances.  Alternatively,
you can specify the name of a Stata matrix, {it:matname}, containing
individual values.  {it:matname} must be conformable with the dimensionality
of the specified model.  That is, it can be one of the following dimensions:
1 {it:x} p or p {it:x} 1, where p is the number of imputation
variables.  This option cannot be combined with {cmd:cov()} or {cmd:vars()}.
The {cmd:sds()} option can be used in combination with {cmd:corr()} to provide
initial values for the covariance matrix.

{phang2}
{opt vars(# | matname)} specifies initial values for
variances (diagonal elements of the covariance matrix).  The default is
{cmd:vars(1)}, which sets all variances to one.  If you specify
{opt vars(#)}, then {it:#} will be used as the initial value for all
variances.  Alternatively, you can specify the name of a Stata matrix,
{it:matname}, containing individual values.  {it:matname} must be
conformable with the dimensionality of the specified model.  That is, it can be
one of the following dimensions:  1 {it:x} p or p {it:x} 1, where p
is the number of imputation variables.  This option cannot be combined with
{cmd:cov()} or {cmd:sds()}.  The {cmd:vars()} option can be used in combination
with {cmd:corr()} to provide initial values for the covariance matrix.

{phang2}
{opt corr(# | matname)} specifies initial values for
the correlations (off-diagonal elements of the correlation matrix).  The
default is {cmd:corr(0)}, which sets all correlations and, thus, covariances to
zero.  If you specify {opt corr(#)}, then all correlation coefficients
will be set to {it:#}.  Alternatively, you can specify the name of a Stata
matrix, {it:matname}, containing individual values.  {it:matname} can be a
square p {it:x} p matrix with diagonal elements equal to one or it can
contain the corresponding lower (upper) triangular matrix in a vector of
dimension p(p+1)/2, where p is the number of imputation variables.
This option cannot be combined with {cmd:cov()}.  The {cmd:corr()} option can be
used in combination with {cmd:sds()} or {cmd:vars()} to provide initial values
for the covariance matrix.

{phang2}
{opt cov(matname)} specifies initial values for the covariance matrix.
{it:matname} must contain the name of a Stata matrix.  {it:matname} can be
a square p {it:x} p matrix or it can contain the corresponding lower (upper)
triangular matrix in a vector of dimension p(p+1)/2, where p is the
number of imputation variables.  This option cannot be combined with
{cmd:corr()}, {cmd:sds()}, or {cmd:vars()}.

{phang}
{opt wlfwgt(matname)} specifies the weights (coefficients) to use when
computing the worst linear function (WLF).  The coefficients must be saved in
a Stata matrix, {it:matname}, of dimension 1 {it:x} d, where
d=pq+p(p+1)/2, p is the number of imputation variables, and q is
the number of predictors.  This option is useful when initial values from the
EM estimation are supplied to data augmentation (DA) as matrices.  This
option can also be used to obtain the estimates of linear functions other than
the default WLF.  This option cannot be combined with {cmd:by()}.

{phang}
{cmd:savewlf(}{it:{help filename}} [{cmd:,} {cmd:replace}]{cmd:)} specifies to
save the estimates of the WLF from each iteration of MCMC to a Stata dataset
called {it:filename}{cmd:.dta}.  If the file already exists, the {cmd:replace}
suboption specifies to overwrite the existing file.  This option is useful for
monitoring convergence of the MCMC.  {cmd:savewlf()} is allowed with
{cmd:initmcmc(em)}, when the initial values are obtained using the EM
estimation, or with {cmd:wlfwgt()}.  This option cannot be combined with
{cmd:by()}.

{phang}
{cmd:saveptrace(}{it:fname} [{cmd:, replace}]{cmd:)} specifies to save the
parameter trace log from the MCMC to a file called {it:fname}{cmd:.stptrace}.
If the file already exists, the {cmd:replace} suboption specifies to overwrite
the existing file.  See {manhelp mi_ptrace MI:mi ptrace} for details about the
saved file and how to read it into Stata.  This option is useful for monitoring
convergence of the MCMC.  This option cannot be combined with {cmd:by()}.

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend};
see {manhelp mi_impute MI:mi impute}. Also, {cmd:noisily} is a synonym for
{cmd:emoutput}.  {cmd:nolegend} suppresses group legends that may appear when
the {cmd:by()} option is used.  It is a synonym for {cmd:by(, nolegend)}.

{phang}
{cmd:emlog} specifies that the EM iteration log be shown.  The EM
iteration log is not displayed unless {cmd:emonly} or {cmd:emoutput} is
specified.

{phang}
{cmd:emoutput} specifies that the EM output be shown.  This option is
implied with {cmd:emonly}.

{phang}
{cmd:mcmcdots} specifies to display all MCMC iterations as dots.

{phang}
{cmd:alldots} specifies to display all intermediate iterations as dots in
addition to the imputation dots.  These iterations include the EM iterations
and the MCMC burn-in iterations.  This option implies {cmd:mcmcdots}. 

{phang}
{cmd:nolog} suppresses all output from EM or MCMC that is usually
displayed by default.

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_impute MI:mi impute}.

{phang}
{cmd:emonly} [{cmd:(}{it:{help mi_impute_mvn##em_options:em_options}}{cmd:)}]
specifies that {cmd:mi impute mvn} perform EM estimation and then stop.  You
can control the EM process by specifying {it:em_options}.  This option is
useful at the preliminary stage to obtain insight about the length of the
burn-in period as well as to choose a prior specification.  No imputation is
performed, so {cmd:add()} or {cmd:replace} is not required with {cmd:mi}
{cmd:impute} {cmd:mvn,} {cmd:emonly}, and they are ignored if specified.  The
{cmd:emonly} option is not allowed with {cmd:mcmconly}.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker examples}{...}
{title:Examples:  Multivariate normal imputation}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart8s0}
{p_end}

{pstd}Describe {cmd:mi} data{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
Impute {cmd:age} and {cmd:bmi} using multivariate normal regression
{p_end}
{phang2}
{cmd:. mi impute mvn age bmi = attack smokes hsgrad female, add(10)}
{p_end}


{title:Examples:  Imputing transformed variables}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mhouses1993, clear}{p_end}

{phang2}
Create variables containing log of {cmd:age} and {cmd:tax}
{p_end}
{phang2}
{cmd:. gen lnage = ln(age)}
{p_end}
{phang2}
{cmd:. gen lntax = ln(tax)}
{p_end}

{p 6 6 2}Declare data and register variables {cmd:lnbmi} and {cmd:lntax} as imputed{p_end}
{phang2}
{cmd:. mi set mlong }
{p_end}
{phang2}
{cmd:. mi register imputed lnage lntax}
{p_end}

{pstd}Describe {cmd:mi} data{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
Impute ln({cmd:age}) and ln({cmd:tax})
{p_end}
{phang2}
{cmd:. mi impute mvn lnage lntax = price sqft nfeatures ne custom corner, add(20)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute mvn} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables{p_end}
{synopt:{cmd:r(burnin)}}number of burn-in iterations{p_end}
{synopt:{cmd:r(burnbetween)}}number of burn-between iterations{p_end}
{synopt:{cmd:r(df_prior)}}prior degrees of freedom (stored only with {cmd:prior(ridge)}){p_end}
{synopt:{cmd:r(N_em)}}number of observations used by EM (including omitted missing observations){p_end}
{synopt:{cmd:r(N_e_em)}}number of observations used by EM in estimation (excluding omitted missing observations){p_end}
{synopt:{cmd:r(N_mis_em)}}number of incomplete observations within the EM estimation sample{p_end}
{synopt:{cmd:r(N_S_em)}}number of unique missing-value patterns{p_end}
{synopt:{cmd:r(niter_em)}}number of iterations EM takes to converge{p_end}
{synopt:{cmd:r(llobs_em)}}observed log likelihood (stored with {cmd:prior(uniform)}){p_end}
{synopt:{cmd:r(lpobs_em)}}observed log posterior (stored with priors other than {cmd:uniform}){p_end}
{synopt:{cmd:r(converged_em)}}convergence flag for EM{p_end}
{synopt:{cmd:r(emonly)}}{cmd:1} if performed EM estimation only, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(mcmconly)}}{cmd:1} if performed MCMC only without imputing data, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:mvn}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(prior)}}prior distribution{p_end}
{synopt:{cmd:r(init_mcmc)}}type of initial values ({cmd:em} or {cmd:user}){p_end}
{synopt:{cmd:r(ivarsorder)}}names of imputation variables in the order used in the computation{p_end}
{synopt:{cmd:r(init_em)}}type of initial values used by EM ({cmd:ac}, {cmd:cc}, or {cmd:user}){p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(Beta0)}}initial values for regression coefficients used by DA{p_end}
{synopt:{cmd:r(Sigma0)}}initial variance-covariance matrix used by DA{p_end}
{synopt:{cmd:r(wlf_wgt)}}coefficients for the WLF (stored with {cmd:initmcmc(em)} or if {cmd:wlfwgt()} is used){p_end}
{synopt:{cmd:r(Beta_em)}}estimated regression coefficients from EM{p_end}
{synopt:{cmd:r(Sigma_em)}}estimated variance-covariance matrix from EM{p_end}
{synopt:{cmd:r(Beta0_em)}}initial values for regression coefficients used by EM{p_end}
{synopt:{cmd:r(Sigma0_em)}}initial variance-covariance matrix used by EM{p_end}
{synopt:{cmd:r(N_pat)}}minimum, average, and maximum numbers of observations per missing-value pattern{p_end}
{p2colreset}{...}

{pstd}
{cmd:r(N_pat)} and results with the {cmd:_em} suffix are stored only when the
EM algorithm is used (with {cmd:emonly} or {cmd:initmcmc(em)}).


{marker reference}{...}
{title:Reference}

{marker S1997}{...}
{phang}
Schafer, J. L. 1997. {it:Analysis of Incomplete Multivariate Data}.
Boca Raton, FL: Chapman & Hall/CRC.
{p_end}
