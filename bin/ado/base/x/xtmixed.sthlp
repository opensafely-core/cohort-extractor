{smcl}
{* *! version 2.4.3  19dec2012}{...}
{viewerdialog xtmixed "dialog xtmixed"}{...}
{vieweralsosee "[XT] xtmixed postestimation" "help xtmixed postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] estimation" "help mi estimation"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "[XT] xtmelogit" "help xtmelogit"}{...}
{vieweralsosee "[XT] xtmepoisson" "help xtmepoisson"}{...}
{vieweralsosee "[XT] xtrc" "help xtrc"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Syntax" "xtmixed##syntax"}{...}
{viewerjumpto "Description" "xtmixed##description"}{...}
{viewerjumpto "Options" "xtmixed##options"}{...}
{viewerjumpto "Remarks" "xtmixed##remarks"}{...}
{viewerjumpto "Examples" "xtmixed##examples"}{...}
{viewerjumpto "Saved results" "xtmixed##saved_results"}{...}
{viewerjumpto "Reference" "xtmixed##reference"}{...}
{pstd}
{cmd:xtmixed} has been renamed to {helpb mixed}.  {cmd:xtmixed}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 21 23 2}{...}
{synopt :{hi:[XT] xtmixed} {hline 2}}Multilevel mixed-effects linear regression
{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:xtmixed} {depvar} [{it:fe_equation}] [{cmd:||} {it:re_equation}] 
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help xtmixed##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} {weight} [{cmd:,} {it:{help xtmixed##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help xtmixed##re_options:re_options}}]

{p 8 18 2}
	for a random effect among the values of a factor variable

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}
		[{cmd:,} {it:{help xtmixed##re_options:re_options}}]

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 23 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt noc:onstant}}suppress constant term from the fixed-effects equation{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(xtmixed##vartype:vartype)}}variance-covariance 
structure of the random effects{p_end}
{synopt :{opt noc:onstant}}suppress constant term from the random-effects 
equation{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
{synopt :{opth fw:eight(exp)}}frequency weights at higher levels{p_end}
{synopt :{opth pw:eight(exp)}}sampling weights at higher levels{p_end}
{synoptline}

{synoptset 23}{...}
{marker vartype}{...}
{synopthdr :vartype}
{synoptline}
{synopt :{opt ind:ependent}}one variance parameter per random effect, 
all covariances zero; the default unless a factor variable is specified{p_end}
{synopt :{opt ex:changeable}}equal variances for random effects, 
and one common pairwise covariance{p_end}
{synopt :{opt id:entity}}equal variances for random effects, all 
covariances zero; the default for factor variables{p_end}
{synopt :{opt un:structured}}all variances and covariances distinctly 
estimated{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt:{opt ml:e}}fit model via maximum likelihood, the default{p_end}
{synopt:{opt reml}}fit model via restricted maximum likelihood{p_end}
{synopt:{cmd: pwscale(}{it:{help xtmixed##scale_method:scale_method}}{cmd:)}}control scaling of sampling weights in two-level models{p_end}
{synopt:{cmdab:res:iduals(}{it:{help xtmixed##rspec:rspec}}{cmd:)}}structure of residual errors{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, {cmdab:r:obust},
or {cmdab:cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt var:iance}}show random-effects parameter estimates as 
variances and covariances{p_end}
{synopt :{opt noret:able}}suppress random-effects table{p_end}
{synopt :{opt nofet:able}}suppress fixed-effects table{p_end}
{synopt :{opt estm:etric}}show parameter estimates in the estimation 
metric{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt nostd:err}}do not estimate standard errors of 
random-effects parameters{p_end}
{synopt :{opt nolr:test}}do not perform LR test comparing to linear 
regression{p_end}
{synopt :{it:{help xtmixed##display_options:display_options}}}control
column formats, row spacing, and display of omitted variables and base
   and empty cells{p_end}

{syntab :EM options}
{synopt :{opt emiter:ate(#)}}number of EM iterations, default is 20{p_end}
{synopt :{opt emtol:erance(#)}}EM convergence tolerance, default is 1e-10{p_end}
{synopt :{opt emonly}}fit model exclusively using EM{p_end}
{synopt :{opt emlog}}show EM iteration log{p_end}
{synopt :{opt emdot:s}}show EM iterations as dots{p_end}

{syntab :Maximization}
{synopt :{it:{help xtmixed##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
{synopt :{opt matsqrt}}parameterize variance components using matrix square
roots; the default{p_end}
{synopt :{opt matlog}}parameterize variance components using matrix logarithms
{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain 
         time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:mi estimate}, {cmd:rolling},
         and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}{opt pweight}s and {opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp xtmixed_postestimation XT:xtmixed postestimation} for
features available after estimation.{p_end}


{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Multilevel mixed-effects models >}
     {bf:Mixed-effects linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtmixed} fits linear mixed models.  Mixed models are characterized as
containing both fixed effects and random effects.  The fixed effects
are analogous to standard regression coefficients and are estimated directly.
The random effects are not directly estimated but are summarized according to
their estimated variances and covariances.  Although random effects are not
directly estimated, you can form best linear unbiased predictions (BLUPs) of
them (and standard errors) by using {cmd:predict} after {cmd:xtmixed}; see
{manhelp xtmixed_postestimation XT:xtmixed postestimation}.  Random effects may
take the form of either random intercepts or random coefficients, and the
grouping structure of the data may consist of multiple levels of nested groups.
As such, mixed models are also known in the literature 
as {it:multilevel models} and {it:hierarchical linear models}.  The
overall error distribution of the linear mixed model is assumed to be
Gaussian, and heteroskedasticity and correlations within lowest-level
groups also may be modeled.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed effects equation and for any or all the
random-effects equations.

{phang}{opt covariance(vartype)}, where {it:vartype} is

{phang3}
{cmd:independent}{c |}{cmd:exchangeable}{c |}{cmd:identity}{c |}{cmd:unstructured}

{pmore}
specifies the structure of the covariance
matrix for the random effects and may be specified for each random-effects
equation.  An {cmd:independent} covariance structure allows a distinct
variance for each random effect within a random-effects equation and 
assumes that all covariances are zero.  {cmd:exchangeable} covariances
have common variances and one common pairwise covariance.  {cmd:identity}
is short for "multiple of the identity"; that is, all variances are equal
and all covariances are zero.  {cmd:unstructured} allows for
all variances and covariances to be distinct.  If an equation consists of
{it:p} random-effects terms, the {cmd:unstructured} covariance matrix will have
{it:p}({it:p}+1)/2 unique parameters.

{pmore}
{cmd:covariance(independent)} is the default, except when the
random-effects equation consists of the factor-variable specification
{cmd:R.}{varname}, in which case {cmd:covariance(identity)} is the default,
and only {cmd:covariance(identity)} and {cmd:covariance(exchangeable)} 
are allowed.

{phang}{opt collinear} specifies that {cmd:xtmixed} not omit collinear
variables from the random-effects equation.  Usually there is no reason to
leave collinear variables in place, and in fact doing so usually causes the
estimation to fail because of the matrix singularity caused by the collinearity.
However, with certain models (for example, a random-effects model with a full
set of contrasts), the variables may be collinear, yet the
model is fully identified because of restrictions on the random-effects
covariance structure.  In such cases, using the {cmd:collinear} option allows
the estimation to take place with the random-effects equation intact.

{phang}{cmd:fweight(}{it:exp}{cmd:)} specifies frequency weights at
higher levels in a multilevel model, whereas frequency weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[fw=}{it:fwtvar1}{cmd:]}.  {it:exp} can be any valid Stata
expression, and you can specify {cmd:fweight()} at levels two and higher
of a multilevel model.  For example, in the two-level model

{p 12 12 4}{cmd:. xtmixed} {it:fixed_portion} {cmd:[fw = wt1]}
{cmd:|| school:} ... {cmd:, fweight(wt2)} ...{p_end}

{pmore}
variable {cmd:wt1} would hold the first-level (the observation-level)
frequency weights, and {cmd:wt2} would hold the second-level (the
school-level) frequency weights.

{phang}{cmd:pweight(}{it:exp}{cmd:)} specifies sampling weights at
higher levels in a multilevel model, whereas sampling weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[pw=}{it:pwtvar1}{cmd:]}.  {it:exp} can be any valid Stata
expression, and you can specify {cmd:pweight()} at each levels two and higher
of a multilevel model.  For example, in the two-level model

{p 12 12 4}{cmd:. xtmixed} {it:fixed_portion} {cmd:[pw = wt1]}
{cmd:|| school:} ... {cmd:, pweight(wt2)} ...{p_end}

{pmore}
variable {cmd:wt1} would hold the first-level (the observation-level) sampling
weights, and {cmd:wt2} would hold the second-level (the school-level) sampling 
weights. 

{pmore}
See {help xtmixed##sampling:{it:Remarks on using sampling weights}} below
for more information regarding the use of sampling weights in multilevel
models.

{pmore}
Weighted estimation, whether frequency or sampling, is not supported under
restricted maximum-likelihood estimation (REML).

{phang}
{opt mle} and {opt reml} specify the statistical method for fitting the model.

{phang2}
{opt mle}, the default, specifies that the model be fit using maximum
likelihood.

{phang2}
{opt reml}, specifies that the model be fit using restricted
maximum likelihood (REML), also referred to as residual maximum likelihood.

{marker scale_method}{...}
{phang}
{cmd:pwscale(}{it:scale_method}{cmd:)}, where {it:scale_method} is

{p 16 20 2}
{cmd:size}{c |}{cmdab:eff:ective}{c |}{cmd:gk}

{phang2}
controls how sampling weights (if specified) are scaled in two-level models.
See {it:Survey data} under
{it:Remarks} in {bf:[XT] xtmixed} for more details on using {cmd:pwscale()}.

{phang3}
{it:scale_method} {cmd:size} specifies that first-level
(observation-level) weights be scaled so that they sum to the 
sample size of their corresponding second-level cluster.  Second-level
sampling weights are left unchanged.

{phang3}
{it:scale_method} {cmd:effective} specifies that first-level weights be
scaled so that they sum to the effective sample size of their
corresponding second-level cluster.  Second-level sampling weights are
left unchanged.

{phang3}
{it:scale_method} {cmd:gk} specifies the
{help xtmixed##GK1996:Graubard and Korn (1996)} method.
Under this method, second-level weights 
are set to the cluster averages
of the products of the weights at both levels,
and first-level weights
are then set equal to one.

{phang2}
{cmd:pwcale()} is supported only with two-level models.

{marker rspec}{...}
{phang}{opt residuals(rspec)}, where {it:rspec} is

{phang3}
{it:restype} [{cmd:,} {it:residual_options}]

{pmore}
specifies the structure of the residual 
errors within the lowest-level (the second level of a multilevel model 
with the observations comprising the first level) groups of the linear
mixed model.  For example, if you are modeling random effects for
classes nested within schools, then {cmd:residuals()} refers to the
residual variance-covariance structure of the observations within
classes, the lowest-level groups.

{pmore}
{it:restype} is

{p 16 20 2}
{cmdab:ind:ependent}{c |}{cmdab:ex:changeable}{c |}{cmd:ar} {it:#}{c |}{cmd:ma} {it:#}{c |}{cmdab:un:structured}|{cmdab:ba:nded} {it:#}|{cmdab:to:eplitz} {it:#}|{cmdab:exp:onential}
      
{pmore2}
By default, {it:restype} is {cmd:independent}, which means that all residuals
are i.i.d. Gaussian with one common variance.  When combined with
{opth by(varname)}, independence is still assumed, but you estimate a distinct
variance for each level of {it:varname}.  Unlike with the structures described
below, {it:varname} does not need to be constant within groups.

{phang3}
{it:restype} {cmd:exchangeable} estimates two parameters, one common 
within-group variance and one common pairwise covariance.  When combined
with {opth by(varname)}, these two parameters are distinctly 
estimated for each level of {it:varname}.  Because you are modeling a 
within-group covariance, {it:varname} must be constant within lowest-level
groups.

{phang3}
{it:restype} {cmd:ar} {it:#} assumes that within-group errors have 
an autoregressive (AR) structure of order {it:#}; {cmd: ar 1} is the default.
The {opth t(varname)} option is required, where {it:varname} is an
integer-valued time variable used to order the observations within groups and
to determine the lags between successive observations.  Any nonconsecutive time
values will be treated as gaps.  For this structure, {it:#} + 1 parameters are
estimated ({it:#} AR coefficients and one overall error variance).
{it:restype} {cmd:ar} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang3}
{it:restype} {cmd:ma} {it:#} assumes that within-group errors have 
a moving average (MA) structure of order {it:#}; {cmd: ma 1} is the default.
The {opth t(varname)} option is required, where {it:varname} is an
integer-valued time variable used to order the observations within groups and
to determine the lags between successive observations.  Any nonconsecutive time
values will be treated as gaps.  For this structure, {it:#} + 1 parameters are
estimated ({it:#} MA coefficients and one overall error variance).
{it:restype} {cmd:ma} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang3}
{it:restype} {cmd:unstructured} is the most general structure; it estimates
distinct variances for each within-group error and distinct covariances for
each within-group error pair.  The {opth t(varname)} option is required, where
{it:varname} is a nonnegative-integer-valued variable that identifies the
observations within each group.  The groups may be unbalanced in that not all
levels of {opt t()} need to be observed within every group, but you may not
have repeated {opt t()} values within any particular group.  When you have p
levels of {opt t()}, then p*(p+1)/2 parameters are estimated.  {it:restype}
{cmd:unstructured} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang3}
{it:restype} {cmd:banded} {it:#} is a special case of {cmd:unstructured} that
restricts estimation to the covariances within the first {it:#}
off-diagonals and sets the covariances outside this band to zero.  The
{opth t(varname)} option is required, where {it:varname} is a
nonnegative-integer-valued variable that identifies the observations within
each group.  {it:#} is an integer between zero and p-1, where p is the number
of levels of {opt t()}.  By default, {it:#} is p-1; that is, all elements of
the covariance matrix are estimated.  When {it:#} is zero, only the diagonal 
elements of the covariance matrix are estimated.  {it:restype}
{cmd:banded} may be combined with {opt by(varname)}, but {it:varname} must
be constant within groups.

{phang3}
{it:restype} {cmd:toeplitz} {it:#} assumes that within-group errors have
Toeplitz structure of order {it:#}, for which correlations are constant with
respect to time lags less than or equal to {it:#} and are zero for lags greater
than {it:#}.  The {opth t(varname)} option is required, where {it:varname} is
an integer-valued time variable used to order the observations within groups
and to determine the lags between successive observations.  {it:#} is an
integer between one and the maximum observed lag (the default).  Any
nonconsecutive time values will be treated as gaps.  For this structure,
{it:#} + 1 parameters are estimated ({it:#} correlations and one overall error
variance).  {it:restype} {cmd:toeplitz} may be combined with
{opt by(varname)}, but {it:varname} must be constant within groups.

{phang3}
{it:restype} {cmd:exponential} is a generalization of the autoregressive (AR)
covariance model that allows for unequally spaced and noninteger time values.
The {opth t(varname)} option is required, where {it:varname} is real-valued.
For the exponential covariance model, the correlation between two errors is
the parameter rho, raised to a power equal to the absolute value of the
difference between the {cmd:t()} values for those errors.  For this structure,
two parameters are estimated (the correlation parameter rho and one overall
error variance).  {it:restype} {cmd:exponential} may be combined with
{opt by(varname)}, but {it:varname} must be constant within groups.

{pmore}
{it:residual_options} are {opth by(varname)} and {opt t(varname)}.

{phang3}
{opt by(varname)} is for use within the {opt residuals()} option and specifies
that a set of distinct residual-error parameters be estimated for each level of
{it:varname}.  In other words, you use {opt by()} to model heteroskedasticity.

{phang3}
{opt t(varname)} is for use within the {opt residuals()} option to specify a
time variable for the {cmd:ar}, {cmd:ma}, {cmd:toeplitz}, and
{cmd:exponential} structures, or to ID the observations when {it:restype} is
{cmd:unstructured} or {cmd:banded}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are robust to some kinds of misspecification and that allow
for intragroup correlation; see
{helpb vce_option:[R] {it:vce_option}}.  {cmd:vce(oim)} is the default.  
If {cmd:vce(robust)} is specified, robust variances are clustered at the
highest level in the multilevel model.

{phang2}
{cmd:vce(robust)} and {cmd:vce(cluster} {it:clustvar}{cmd:)} are not
supported with REML estimation.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] estimation options}.

{phang}
{opt variance} displays the random-effects and residual-error parameter
estimates as variances and covariances.  The default is to display them as
standard deviations and correlations.

{phang}
{opt noretable} suppresses the random-effects table from the output.

{phang}
{opt nofetable} suppresses the fixed-effects table from the output.

{phang}
{opt estmetric} displays all parameter estimates in the estimation metric.
Fixed-effects estimates are unchanged from those normally displayed, but 
random-effects parameter estimates are displayed as log-standard deviations
and hyperbolic arctangents of correlations, with equation names that 
organize them by model level.  Residual-variance parameter estimates are
also displayed in their original estimation metric.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

{phang}
{opt nostderr} prevents {cmd:xtmixed} from calculating standard errors for
the estimated random-effects parameters, although standard errors are still
given for the fixed-effects parameters.  Specifying this option will
speed up computation times.  {opt nostderr} is available only when residuals
are modeled as independent with constant variance.

{phang}
{opt nolrtest} prevents {cmd:xtmixed} from fitting a reference linear 
regression model and using this model to calculate a likelihood-ratio 
test comparing the mixed model to ordinary regression.  This option may
also be specified upon replay to suppress this test from the output.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] estimation options}.

{dlgtab:EM options}

{pstd}
These options control the EM (expectation-maximization)
iterations that take place before estimation switches to a gradient-based
method.  When residuals are modeled as independent with constant variance,
EM will either converge to the solution or bring parameter estimates
close to the solution.  For other residual structures or for 
weighted estimation, EM is used to obtain starting values.

{phang2}
{opt emiterate(#)} specifies the number of EM (expectation-maximization)
iterations to perform.  The default is {cmd:emiterate(20)}.

{phang2}
{opt emtolerance(#)} specifies the convergence tolerance for the EM 
algorithm.  The default is {cmd:emtolerance(1e-10)}.  EM iterations will be
halted once the log (restricted) likelihood changes by a relative amount less
than {it:#}.  At that point, optimization switches to a gradient-based method,
unless {opt emonly} is specified.

{phang2}
{opt emonly} specifies that the likelihood be maximized exclusively using
EM.  The advantage of specifying {opt emonly} is that EM iterations are 
typically much faster than those for gradient-based methods.  The disadvantages
are that EM iterations can be slow to converge (if at all) and that EM provides
no facility for estimating standard errors for the random-effects parameters.
{opt emonly} is available only with unweighted estimation and when
residuals are modeled as independent with constant variance.

{phang2}
{opt emlog} specifies that the EM iteration log be shown.  The EM iteration 
log is, by default, not displayed unless the {opt emonly} option is specified.

{phang2}
{opt emdots} specifies that the EM iterations be shown as dots.  This option
can be convenient because the EM algorithm may require many iterations to
converge.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmdab:no:}]{opt lo:g},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance}; 
see {helpb maximize:[R] maximize}.
Those that require special mention for {cmd: xtmixed}
are listed below.

{pmore}
For the {opt technique()} option, the default is {cmd:technique(nr)}.
The {opt bhhh} algorithm may not be specified.

{phang}
{opt matsqrt} (the default), during optimization, parameterizes variance
components by using the matrix square roots of the variance-covariance
matrices formed by these components at each model level.

{phang}
{opt matlog}, during optimization, parameterizes variance components by using
the matrix logarithms of the variance-covariance matrices formed by these
components at each model level.

{pmore}
The {opt matsqrt} parameterization ensures that variance-covariance 
matrices are positive semidefinite, while {opt matlog} ensures matrices that
are positive definite.  For most problems, the matrix square root is
more stable near the boundary of the parameter space.  However, if
convergence is problematic, one option may be to try the alternate
{cmd:matlog} parameterization.  When convergence is not an issue, both
parameterizations yield equivalent results.

{pstd}
The following option is available with {opt xtmixed} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help xtmixed##remarks1:Remarks on specifying random-effects equations}
{p_end}
{phang2}{help xtmixed##sampling:Remarks on using sampling weights}{p_end}


{marker remarks1}{...}
{title:Remarks on specifying random-effects equations}

{pstd}
Mixed models consist of fixed effects and random effects.  The fixed effects
are specified as regression parameters in a manner similar to most other Stata
estimation commands, that is, as a dependent variable followed by a set of
regressors.  The random-effects portion of the model is specified by first
considering the grouping structure of the data.  For example, if random
effects are to vary according to variable {cmd:school}, then the call to
{cmd:xtmixed} would be of the form

{p 8 12 4}{cmd:. xtmixed} {it:fixed_portion} 
{cmd:|| school:} ... {cmd:,}
{it:options}{p_end}

{pstd}
The variable lists that make up each equation describe how the random effects
enter into the model, either as random intercepts (constant term) or as random
coefficients on regressors in the data.  One may also specify the
variance-covariance structure of the within-equation random effects, according
to the four available structures described above.  For example,

{p 8 12 4}{cmd:. xtmixed} {it:f_p}
{cmd:|| school: z1, covariance(unstructured)}
{it:options}{p_end}

{pstd}
will fit a model with a random intercept and random slope for variable 
{cmd:z1} and treat the variance-covariance structure of these two 
random effects as unstructured.

{pstd}
If the data are organized by
a series of nested groups, for example, classes within schools, then the
random-effects structure is specified by a series of equations, each separated
by {cmd:||}.  The order of nesting proceeds from left to right.  For our
example, this would mean that an equation for schools would be specified
first, followed by an equation for classes.  As an example, consider

{p 8 12 4}{cmd:. xtmixed} {it:f_p} 
{cmd:|| school: z1, cov(un) || class: z1 z2 z3, nocons cov(ex)} {it:options}

{pstd}
where variables {cmd:school} and {cmd:class} identify the schools and 
classes within schools, respectively.   This model contains a random 
intercept and random coefficient on {cmd:z1} at the school level and has random
coefficients on variables {cmd:z1}, {cmd:z2}, and {cmd:z3} at the 
class level.  The covariance structure for the random effects at the class
level is exchangeable, meaning that the random effects share a common 
variance and common pairwise covariance.

{pstd}
Group variables may be repeated, allowing for more general covariance
structures to be constructed as block-diagonal matrices based on the four
original structures.  Consider

{p 8 12 4}{cmd:. xtmixed} {it:f_p} 
{cmd:|| school: z1 z2, nocons cov(id) || school: z3 z4, nocons cov(un)}
{it:options}

{pstd}
which specifies four random coefficients at the school level.  The 
variance-covariance matrix of the random effects is the 4 x 4 matrix
where the upper 2 x 2 diagonal block is a multiple of the identity matrix and 
the lower 2 x 2 diagonal block is unstructured.  In effect, the coefficients on
{cmd:z1} and {cmd:z2} are constrained to be independent and share a common
variance.  The coefficients on {cmd:z3} and {cmd:z4} each have a distinct
variance and a variance distinct from that of the coefficients on {cmd:z1} and
{cmd:z2}.  They are also allowed to be correlated, yet they are independent
from the coefficients on {cmd:z1} and {cmd:z2}.

{pstd}
For mixed models with no nested grouping structure,
thinking of the entire estimation data as one group is convenient.  Toward this
end, {cmd:xtmixed} allows the special group designation {cmd:_all}.  
{cmd:xtmixed} also allows the factor variable notation {cmd:R.}{it:varname}, 
which is shorthand for describing the levels of {it:varname} as a 
series of indicator variables.  See 
{it:Random-effects factor notation and crossed-effects models}
in {bf:[XT] xtmixed} for more details.


{marker sampling}{...}
{title:Remarks on using sampling weights}

{pstd}
Sampling weights are treated differently in multilevel models than they
are in standard models such as OLS regression.  In a multilevel model,
observation-level weights are not indicative of overall
inclusion.  Instead, they indicate inclusion conditional on the 
corresponding cluster being included at the next highest-level of sampling.

{pstd}
For example, if you include only observation-level weights in a
two-level model, {cmd:xtmixed} will assume sampling with equal
probabilities at level two, and this may or may not be what you intended.
If the sampling at level two is weighted, then including only level-one 
weights can lead to biased results even if weighting at level two has
been incorporated into the level-one weight variable.  For example, it is 
a common practice to multiply conditional weights from multiple levels into
one overall weight.  By contrast, weighted multilevel analysis
requires the component weights from each level of sampling.

{pstd}
Even if you specify sampling weights at all model levels, the scale of
sampling weights at lower levels can affect your estimated parameters 
in a multilevel model.  That is, not only do the relative sizes of the
weights at lower levels matter, the scale of these weights matters also.
To deal with this, {cmd:xtmixed} has the {cmd:pwscale()} option for
rescaling weights in two-level models; see {help xtmixed##scale_method:above} 
for more information on {cmd:pwscale()}.
Three scaling methods are offered, with each method known to perform
well under certain data situations and posited models.

{pstd}
In general, exercise caution when using sampling weights with 
{cmd:xtmixed}; see {it:Survey data} in {bf:[XT] xtmixed} for more information.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}

{pstd}Random-intercept model, analogous to {cmd:xtreg}{p_end}
{phang2}{cmd:. xtmixed ln_w grade age c.age#c.age ttl_exp}
          {cmd:tenure c.tenure#c.tenure || id:}{p_end}

{pstd}Random-intercept and random-slope (coefficient) model{p_end}
{phang2}{cmd:. xtmixed ln_w grade age c.age#c.age ttl_exp}
           {cmd:tenure c.tenure#c.tenure || id: tenure}{p_end}

{pstd}Random-intercept and random-slope (coefficient) model, correlated random
effects{p_end}
{phang2}{cmd:. xtmixed ln_w grade age c.age#c.age ttl_exp}
            {cmd:tenure c.tenure#c.tenure || id: tenure,}
            {cmd:cov(unstruct)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Two-level model{p_end}
{phang2}{cmd:. xtmixed weight week || id:}{p_end}

{pstd}Two-level model with robust standard errors{p_end}
{phang2}{cmd:. xtmixed weight week || id:, vce(robust)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity}{p_end}

{pstd}Three-level nested model, observations nested within 
{cmd:state} nested within {cmd:region}, fit
by maximum likelihood{p_end}
{phang2}{cmd:. xtmixed gsp private emp hwy water other unemp || region: ||}
           {cmd:state:, mle}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Two-way crossed random effects{p_end}
{phang2}{cmd:. xtmixed weight week || _all: R.id || _all: R.week}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ovary}{p_end}

{pstd}Linear mixed model with MA 2 errors{p_end}
{phang2}{cmd:. xtmixed follicles sin1 cos1 || mare: sin1, residuals(ma 2, t(time))}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse childweight}{p_end}

{pstd}Linear mixed model with heteroskedastic error variances{p_end}
{phang2}{cmd:. xtmixed weight age || id:age, residuals(independent, by(girl))}{p_end}

    {hline}


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:xtmixed} saves the following in {cmd:e()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_f)}}number of FE parameters{p_end}
{synopt:{cmd:e(k_r)}}number of RE parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of standard deviations{p_end}
{synopt:{cmd:e(k_rc)}}number of correlations{p_end}
{synopt:{cmd:e(k_res)}}number of residual-error parameters{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(nrgroups)}}number of residual-error {cmd:by()} groups{p_end}
{synopt:{cmd:e(ar_p)}}AR order of residual errors, if specified{p_end}
{synopt:{cmd:e(ma_q)}}MA order of residual errors, if specified{p_end}
{synopt:{cmd:e(res_order)}}order of residual-error structure, if appropriate{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log (restricted) likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for chi-squared{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison model{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison model{p_end}
{synopt:{cmd:e(p_c)}}p-value, comparison model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtmixed}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type (first-level weights){p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}fweight expression for {it:k}th-highest level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}pweight expression for {it:k}th-highest level, if specified{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(redim)}}random-effects dimensions{p_end}
{synopt:{cmd:e(vartypes)}}variance-structure types{p_end}
{synopt:{cmd:e(revars)}}random-effects covariates{p_end}
{synopt:{cmd:e(resopt)}}{cmd:residuals()} specification, as typed{p_end}
{synopt:{cmd:e(rstructure)}}residual-error structure{p_end}
{synopt:{cmd:e(rstructlab)}}residual-error structure output label{p_end}
{synopt:{cmd:e(rbyvar)}}residual-error {cmd:by()} variable, if specified{p_end}
{synopt:{cmd:e(rglabels)}}residual-error {cmd:by()} group labels{p_end}
{synopt:{cmd:e(pwscale)}}sampling-weight scaling method{p_end}
{synopt:{cmd:e(timevar)}}residual-error {cmd:t()} variable, if specified{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(method)}}{cmd:ML} or {cmd:REML}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(optmetric)}}{cmd:matsqrt} or {cmd:matlog}; random-effects
                 matrix parameterization{p_end}
{synopt:{cmd:e(emonly)}}{cmd:emonly}, if specified{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(tmap)}}ID mapping for unstructured residual errors{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker GK1996}{...}
{phang}
Graubard, B. I., and E. L. Korn. 1996.  Modelling the sampling design in the 
analysis of health surveys. 
{it:Statistical Methods in Medical Research} 5: 263-281.
{p_end}
