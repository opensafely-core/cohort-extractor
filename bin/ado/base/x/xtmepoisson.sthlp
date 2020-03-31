{smcl}
{* *! version 1.2.4  16jun2014}{...}
{viewerdialog xtmepoisson "dialog xtmepoisson"}{...}
{vieweralsosee "[XT] xtmepoisson postestimation" "help xtmepoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] estimation" "help mi estimation"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{vieweralsosee "[XT] xtmelogit" "help xtmelogit"}{...}
{vieweralsosee "[XT] xtmixed" "help xtmixed"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[XT] xtrc" "help xtrc"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Syntax" "xtmepoisson##syntax"}{...}
{viewerjumpto "Description" "xtmepoisson##description"}{...}
{viewerjumpto "Options" "xtmepoisson##options"}{...}
{viewerjumpto "Remarks on specifying random-effects equations" "xtmepoisson##remarks"}{...}
{viewerjumpto "Examples" "xtmepoisson##examples"}{...}
{viewerjumpto "Saved results" "xtmepoisson##saved_results"}{...}
{pstd}
{cmd:xtmepoisson} has been renamed to {helpb meqrpoisson}.  {cmd:xtmepoisson}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 25 27 2}{...}
{synopt :{hi:[XT] xtmepoisson} {hline 2}}Multilevel mixed-effects Poisson regression{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:xtmepoisson} {depvar} [{it:fe_equation}] {cmd:||} {it:re_equation}
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help xtmepoisson##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} [{cmd:,} {it:{help xtmepoisson##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help xtmepoisson##re_options:re_options}}]

{p 8 18 2}
	for a random effect among the values of a factor variable

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}
		[{cmd:,} {it:{help xtmepoisson##re_options:re_options}}]

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 30 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt noc:onstant}}suppress constant term from the fixed-effects equation{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with 
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with 
coefficient constrained to 1{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(xtmepoisson##vartype:vartype)}}variance-covariance 
structure of the random effects{p_end}
{synopt :{opt noc:onstant}}suppress the constant from the random-effects 
equation{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Integration}
{synopt :{opt lap:lace}}use Laplacian approximation; equivalent to 
{cmd:intpoints(1)}{p_end}
{synopt :{opt intp:oints}{cmd:(}{it:#} [{it:#} ...]{cmd:)}}set the number of 
integration (quadrature) points; default is 7{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report fixed-effects coefficients as incidence-rate ratios{p_end}
{synopt :{opt var:iance}}show random-effects parameter estimates as 
variances and covariances{p_end}
{synopt :{opt noret:able}}suppress random-effects table{p_end}
{synopt :{opt nofet:able}}suppress fixed-effects table{p_end}
{synopt :{opt estm:etric}}show parameter estimates in the estimation 
metric{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt nolr:test}}do not perform LR test comparing to Poisson
regression{p_end}
{synopt :{it:{help xtmepoisson##display_options:display_options}}}control
column formats, row spacing, and display of omitted variables and base
   and empty cells{p_end}

{syntab :Maximization}
{synopt :{it:{help xtmepoisson##maximize_options:maximize_options}}}control 
the maximization process during gradient-based optimization; seldom 
used{p_end}
{synopt :{opt retol:erance(#)}}tolerance for random-effects estimates; default 
is {cmd:retolerance(1e-8)}; seldom used{p_end}
{synopt :{opt reiter:ate(#)}}maximum number of iterations for random-effects
estimation; default is {cmd:reiterate(50)}; seldom used{p_end}
{synopt :{opt matsqrt}}parameterize variance components using matrix square
roots; the default{p_end}
{synopt :{opt matlog}}parameterize variance components using matrix logarithms
{p_end}
{synopt :{opt refine:opts}{cmd:(}{it:{help xtmepoisson##maximize_options:maximize_options}}{cmd:)}}control
the maximization process during refinement of starting values
{p_end}

INCLUDE help shortdes-coeflegend
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
covariances zero; the default if factor variables are specified{p_end}
{synopt :{opt un:structured}}all variances-covariances distinctly 
estimated{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help fvvarlist
{p 4 6 2}{it:indepvars} and {it:varlist} may contain time-series operators; 
         see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:mi estimate},
{cmd:rolling}, and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp xtmepoisson_postestimation XT:xtmepoisson postestimation}
for features available after estimation.{p_end}


{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Multilevel mixed-effects models >}
     {bf:Mixed-effects Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtmepoisson} fits mixed-effects models for count responses.
Mixed models contain both fixed effects and
random effects.  The fixed effects are analogous to standard regression
coefficients and are estimated directly.  The random effects are not directly
estimated (although they may be obtained postestimation)
but are summarized according to their estimated variances and
covariances.  Random effects may take the form of either random intercepts or
random coefficients, and the grouping structure of the data may consist of
multiple levels of nested groups.  The distribution of the random effects is
assumed to be Gaussian.  The conditional distribution of the response given
the random effects is assumed to be Poisson.  Because the log likelihood for
this model has no closed form, it is approximated by adaptive Gaussian
quadrature.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed effects equation and for any or all the
random-effects equations.

{phang}
{cmd:exposure(}{help varname:{it:varname_e}}{cmd:)} specifies a variable that
reflects the amount of exposure over which the {help depvar:{it:depvar}} events
were observed for each observation;  ln({it:varname_e}) is included
in the fixed-effects portion of the model with coefficient constrained 
to be 1. 

{phang}{cmd:offset(}{help varname:{it:varname_o}}{cmd:)} specifies that
{it:varname_o} be included in the fixed-effects portion of the model with the
coefficient constrained to be 1.

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

{phang}{opt collinear} specifies that {cmd:xtmepoisson} not omit collinear
variables from the random-effects equation.  Usually there is no reason to
leave collinear variables in place, and in fact doing so usually causes the
estimation to fail because of the matrix singularity caused by the collinearity.
However, with certain models (for example, a random-effects model with a full
set of contrasts), the variables may be collinear, yet the
model is fully identified because of restrictions on the random-effects
covariance structure.  In such cases, using the {cmd:collinear} option allows
the estimation to take place with the random-effects equation intact.

{dlgtab:Integration}

{marker laplace}{...}
{phang}{opt laplace} specifies that log likelihoods be calculated using 
the Laplacian approximation, equivalent to adaptive Gaussian quadrature with
one integration point for each level in the model;  {cmd:laplace} is 
equivalent to {cmd:intpoints(1)}.  Computation time increases as a
function of the number of quadrature points raised to a power equaling the
dimension of the random-effects specification.  The computational time
saved by using {cmd:laplace} can thus be substantial, especially when you have
many levels and/or random coefficients.

{pmore}
The Laplacian approximation has been known to produce biased parameter
estimates, but the bias tends to be more prominent in the estimates of the
variance components rather than in estimates of the fixed effects.  If your
interest lies primarily with the fixed-effects estimates, the Laplace
approximation may be a viable faster alternative to adaptive quadrature with
multiple integration points.

{pmore}
Specifying a factor variable, {cmd:R.}{varname}, increases the 
dimension of the random effects by the number of distinct values of
{it:varname}, that is, the number of factor levels.  Even when this number 
is small to moderate, it increases the total random-effects dimension to the
point where estimation with more than one quadrature point is prohibitively
intensive.

{pmore}
For this reason, when you have factor variables in your random-effects
equations, the {cmd:laplace} option is assumed.  You can override this 
behavior by using the {cmd:intpoints()} option, but doing so is not recommended.

{phang}
{opt intpoints(# [# ...])} sets the number of integration points for adaptive
Gaussian quadrature.  The more
points, the more accurate the approximation to the
log likelihood.  However, computation time increases with the number of
quadrature points, and in models with many levels and/or many random
coefficients, this increase can be substantial.

{pmore}
You may specify one number of integration points applying to all levels
of random effects in the model, or you may specify distinct numbers of points
for each level.  {cmd:intpoints(7)} is the default; that is, by default 
seven quadrature points are used for each level.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang} 
{opt irr} reports the fixed-effects coefficients transformed to incidence-rate
ratios, that is, exp(b) rather than b.  Standard errors and confidence intervals
are similarly transformed.  This option affects how results are displayed, not
how they are estimated.  {cmd:irr} may be specified at estimation or when
replaying previously estimated results.

{phang}
{opt variance} displays the random-effects parameter estimates as 
variances and covariances.  The default is to display them as standard
deviations and correlations.

{phang}
{opt noretable} suppresses the random-effects table from the output.

{phang}
{opt nofetable} suppresses the fixed-effects table from the output.

{phang}
{opt estmetric} displays all parameter estimates in the estimation metric.
Fixed-effects estimates are unchanged from those normally displayed, but 
random-effects parameter estimates are displayed as log-standard deviations
and hyperbolic arctangents of correlations, with equation names that 
organize them by level.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

{phang}
{opt nolrtest} prevents {cmd:xtmepoisson} from performing a likelihood-ratio
test that compares the mixed-effects Poisson model with standard (marginal)
Poisson regression.  This option may also be specified upon replay to
suppress this test from the output.

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

{dlgtab:Maximization}

{marker maximize_options}{...}
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
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] maximize}.
Those that require special mention for {cmd:xtmepoisson}
are listed below.

{pmore}
For the {opt technique()} option, the default is {cmd:technique(nr)}.
The {opt bhhh} algorithm may not be specified.

{pmore}{opt from(init_specs)} is particularly useful when
combined with {cmd:refineopts(iterate(0))}, which bypasses the initial
optimization stage; see 
{help xtmepoisson##refineopts:below}.

{marker retolerance()}{...}
{phang}
{opt retolerance(#)} specifies the convergence tolerance for the estimated
random effects used by adaptive Gaussian quadrature.  Gaussian quadrature
points are adapted to be centered at the estimated random effects given a
current set of model parameters.  Estimating these random effects is an
iterative procedure, with convergence declared when the maximum relative
change in the random effects is less than {cmd:retolerance()}.  The default
{cmd:retolerance()} is 1e-8.  You should seldom have to use this option.

{phang}
{opt reiterate(#)} specifies the maximum number of iterations used when 
estimating the random effects to be used in adapting the Gaussian 
quadrature points; see the {helpb xtmepoisson##retolerance():retolerance()}
option.  The default is {cmd:reiterate(50)}.  You should seldom have to use
this option.

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

{phang}
{opt refineopts}{cmd:(}{it:{help xtmepoisson##maximize_options:maximize_options}}{cmd:)} controls 
the maximization process during the refinement of starting values.  Estimation
in {cmd:xtmepoisson} takes place in two stages.  In the first stage, starting
values are refined by holding the quadrature points fixed between iterations.
During the second stage, quadrature points are adapted with each evaluation
of the log likelihood.  Maximization options specified within 
{cmd:refineopts()} control the first stage of optimization; that is, they 
control the refining of starting values.

{pmore}
{it:maximize_options} specified outside
{cmd:refineopts()} control the second stage.

{pmore}
The one exception to the above rule is the {cmd:nolog} option, which when
specified outside {cmd:refineopts()} applies globally.

{pmore}
{opt from(init_specs)} is not allowed within {cmd:refineopts()} and
instead must be specified globally.

{marker refineopts}{...}
{pmore}
Refining starting values helps make the iterations of the 
second stage (those that lead toward the solution) more numerically stable.
In this regard, of particular interest is 
{cmd:refineopts(iterate(}{it:#}{cmd:))}, with two iterations being the 
default.  Should the maximization fail because of instability in the Hessian
calculations, one possible solution may be to increase the number of
iterations here.

{pstd}
The following option is available with {opt xtmepoisson} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker remarks}{...}
{title:Remarks on specifying random-effects equations}

{pstd}
Mixed models consist of fixed effects and random effects.  The fixed effects
are specified as regression parameters in a manner similar to that of most
other Stata estimation commands, that is, as a dependent variable followed by
a set of regressors.  The random-effects portion of the model is specified by
first considering the grouping structure of the data.  For example, if random
effects are to vary according to variable {cmd:school}, then the call to
{cmd:xtmepoisson} would be of the form

{p 8 12 4}{cmd:. xtmepoisson} {it:fixed_portion} 
{cmd:|| school:} ... {cmd:,}
{it:options}{p_end}

{pstd}
The variable lists that make up each equation describe how the random effects
enter into the model, either as random intercepts (constant term) or as random
coefficients on regressors in the data.  One may also specify the
variance-covariance structure of the within-equation random effects, according
to the four available structures described above.  For example,

{p 8 12 4}{cmd:. xtmepoisson} {it:f_p}
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

{p 8 12 4}{cmd:. xtmepoisson} {it:f_p} 
{cmd:|| school: z1, cov(un) || class: z2 z3, nocons cov(ex)} {it:options}

{pstd}
where variables {cmd:school} and {cmd:class} identify the schools and 
classes within schools, respectively.   This model contains a random 
intercept and random coefficient on {cmd:z1} at the school level and has random
coefficients on variables {cmd:z2} and {cmd:z3} at the 
class level.  The covariance structure for the random effects at the class
level is exchangeable, meaning that the random effects share a common 
variance, and they are allowed to be correlated.  A simplification allowing
for no correlation (while still allowing a common variance) would be 
{cmd:cov(identity)}.

{pstd} Group variables may be repeated, allowing for more general covariance
structures to be constructed as block-diagonal matrices based on the four
original structures.  Consider

{p 8 12 4}{cmd:. xtmepoisson} {it:f_p} 
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
For mixed models with no nested grouping structure, thinking of the entire
estimation data as one group is convenient.  Toward this end, {cmd:xtmepoisson}
allows the special group designation {cmd:_all}.  {cmd:xtmepoisson} also allows
the factor variable notation {cmd:R.}{it:varname}, which is shorthand for
describing the levels of {it:varname} as a series of indicator variables.  See
example 5 in {bf:[XT] xtmelogit} for more details.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse epilepsy}{p_end}

{pstd}Two-level random-intercept model, analogous to {cmd:xtpoisson}{p_end}
{phang2}{cmd:. xtmepoisson seizures treat lbas lbas_trt lage v4 || subject:}{p_end}

{pstd}Two-level random-intercept and random-coefficient model{p_end}
{phang2}{cmd:. xtmepoisson seizures treat lbas lbas_trt lage visit || subject: visit}{p_end}

{pstd}Two-level random-intercept and random-coefficient model, correlated random
effects{p_end}
{phang2}{cmd:. xtmepoisson seizures treat lbas lbas_trt lage visit || subject: visit, cov(unstructured) intpoints(9)}{p_end}

{pstd}Replay results with incidence-rate ratios and variances/covariances{p_end}
{phang2}{cmd:. xtmepoisson, irr variance}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse melanoma}{p_end}

{pstd}Three-level nested model, observations nested {cmd:region} nested within {cmd:nation}{p_end}
{phang2}{cmd:. xtmepoisson deaths uv c.uv#c.uv, exposure(expected) || nation: || region:}{p_end}

{pstd}Four-level nested model, fit using {helpb xtmepoisson##laplace:laplace}{p_end}
{phang2}{cmd:. xtmepoisson deaths uv c.uv#c.uv, exposure(expected) || nation: || region: || county:, laplace}{p_end}

    {hline}


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:xtmepoisson} saves the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_f)}}number of FE parameters{p_end}
{synopt:{cmd:e(k_r)}}number of RE parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of standard deviations{p_end}
{synopt:{cmd:e(k_rc)}}number of correlations{p_end}
{synopt:{cmd:e(df_m)}}fixed-effects model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for chi-squared{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison model{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison model{p_end}
{synopt:{cmd:e(p_c)}}p-value, comparison model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(reparm_rc)}}return code, final reparameterization{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtmepoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(exposurevar)}}exposure variable{p_end}
{synopt:{cmd:e(model)}}{cmd:Poisson}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(redim)}}random-effects dimensions{p_end}
{synopt:{cmd:e(vartypes)}}variance-structure types{p_end}
{synopt:{cmd:e(revars)}}random-effects covariates{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(laplace)}}{cmd:laplace}, if Laplace approximation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{cmd:bootstrap} or {cmd:jackknife} if defined{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(method)}}{cmd:ML}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
