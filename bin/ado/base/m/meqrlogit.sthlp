{smcl}
{* *! version 1.3.1  10oct2018}{...}
{viewerdialog meqrlogit "dialog meqrlogit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meqrlogit postestimation" "help meqrlogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] estimation" "help mi estimation"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{vieweralsosee "[XT] xtlogit" "help xtlogit"}{...}
{viewerjumpto "Syntax" "meqrlogit##syntax"}{...}
{viewerjumpto "Menu" "meqrlogit##menu"}{...}
{viewerjumpto "Description" "meqrlogit##description"}{...}
{viewerjumpto "Options" "meqrlogit##options"}{...}
{viewerjumpto "Remarks" "meqrlogit##remarks"}{...}
{viewerjumpto "Examples" "meqrlogit##examples"}{...}
{viewerjumpto "Stored results" "meqrlogit##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[ME] meqrlogit} {hline 2}}Multilevel mixed-effects logistic
regression (QR decomposition){p_end}
{p2col:}({browse "http://www.stata.com/manuals15/memeqrlogit.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:meqrlogit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb melogit} for a recommended alternative to {cmd:meqrlogit}.


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:meqrlogit} {depvar} {it:fe_equation} {cmd:||} {it:re_equation}
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help meqrlogit##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} [{cmd:,} {it:{help meqrlogit##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help meqrlogit##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}
		[{cmd:,} {it:{help meqrlogit##re_options:re_options}}]

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 30 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the fixed-effects
equation{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(meqrlogit##vartype:vartype)}}variance-covariance structure of the random effects{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects equation{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt :{opt bin:omial}{cmd:(}{it:{help varname:varname}}|{it:#}{cmd:)}}set binomial trials if data are in binomial form{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report fixed-effects coefficients as odds ratios{p_end}
{synopt :{opt var:iance}}show random-effects parameter
estimates as variances and covariances; the default{p_end}
{synopt :{opt stddev:iations}}show random-effects parameter estimates as 
standard deviations and correlations{p_end}
{synopt :{opt noret:able}}suppress random-effects table{p_end}
{synopt :{opt nofet:able}}suppress fixed-effects table{p_end}
{synopt :{opt estm:etric}}show parameter estimates as stored in {cmd:e(b)}{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{it:{help meqrlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opt intp:oints(# [# ...])}}set the number of 
integration (quadrature) points; default is {cmd:intpoints(7)}{p_end}
{synopt :{opt lap:lace}}use Laplacian approximation; equivalent to 
{cmd:intpoints(1)}{p_end}

{syntab :Maximization}
{synopt :{it:{help meqrlogit##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}
{synopt :{opt retol:erance(#)}}tolerance for random-effects estimates; default 
is {cmd:retolerance(1e-8)}; seldom used{p_end}
{synopt :{opt reiter:ate(#)}}maximum number of iterations for random-effects
estimation; default is {cmd:reiterate(50)}; seldom used{p_end}
{synopt :{opt matsqrt}}parameterize variance components using matrix square
roots; the default{p_end}
{synopt :{opt matlog}}parameterize variance components using matrix logarithms
{p_end}
{synopt :{opth refine:opts(meqrlogit##maximize_options:maximize_options)}}control
the maximization process during refinement of starting values
{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}

{synoptset 23}{...}
{marker vartype}{...}
{synopthdr :vartype}
{synoptline}
{synopt :{opt ind:ependent}}one variance parameter per random effect, 
all covariances 0; the default unless the {bf:R.} notation is used{p_end}
{synopt :{opt exc:hangeable}}equal variances for random effects, 
and one common pairwise covariance{p_end}
{synopt :{opt id:entity}}equal variances for random effects, all 
covariances 0; the default if the {bf:R.} notation is used{p_end}
{synopt :{opt un:structured}}all variances and covariances to be distinctly 
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
{p 4 6 2}See {manhelp meqrlogit_postestimation ME:meqrlogit postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models >}
     {bf:Estimation by QR decomposition > Logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:meqrlogit} is a legacy command for fitting mixed-effects models to binary
or binomial responses.  {cmd:melogit} is the modern command, and it offers
more functionality; see {manhelp melogit ME}. The two commands use different
but equivalent estimation methods. {cmd:melogit} performs optimization using
variance components in their original metric, whereas {cmd:meqrlogit} uses the
QR decomposition of the variance-components matrix.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed-effects equation and for any of or all the
random-effects equations.

{phang}
{opth offset(varname)} specifies that {it:varname} be included in the
fixed-effects portion of the model with the coefficient constrained to be 1.

{phang}
{opt covariance(vartype)} specifies the structure of the covariance
matrix for the random effects and may be specified for each random-effects
equation.  {it:vartype} is one of the following:
{cmd:independent}, {cmd:exchangeable}, {cmd:identity}, or {cmd:unstructured}.

{pmore}
{cmd:covariance(independent)} covariance structure allows for a distinct
variance for each random effect within a random-effects equation and
assumes that all covariances are 0.
The default is {cmd:covariance(independent)}, except when the {cmd:R.}
notation is used, in which case the default is {cmd:covariance(identity)} and
only {cmd:covariance(identity)} and {cmd:covariance(exchangeable)} are
allowed.

{pmore}
{cmd:covariance(exchangeable)} structure specifies one common variance for all
random effects and one common pairwise covariance.

{pmore}
{cmd:covariance(identity)} is short for "multiple of the identity"; that is,
all variances are equal and all covariances are 0.

{pmore}
{cmd:covariance(unstructured)} allows for all variances and covariances to be
distinct.  If an equation consists of p random-effects terms, the
unstructured covariance matrix will have p(p+1)/2 unique parameters.

{phang}{opt collinear} specifies that {cmd:meqrlogit} not omit collinear
variables from the random-effects equation.  Usually, there is no reason to
leave collinear variables in place; in fact, doing so usually causes the
estimation to fail because of the matrix singularity caused by the collinearity.
However, with certain models (for example, a random-effects model with a full
set of contrasts), the variables may be collinear, yet the
model is fully identified because of restrictions on the random-effects
covariance structure.  In such cases, using the {cmd:collinear} option allows
the estimation to take place with the random-effects equation intact.

{phang}{cmd:binomial(}{it:{help varname}}|{it:#}{cmd:)} specifies that
the data are in binomial form; that is, {depvar} records the number of
successes from a series of binomial trials.  
This number of trials is given either as {it:varname},
which allows this number to vary over the observations, or as the constant
{it:#}.  If {opt binomial()} is not specified (the default), {it:depvar} is
treated as Bernoulli, with any nonzero, nonmissing values indicating positive
responses.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] estimation options}.

{phang} 
{opt or} reports estimated fixed-effects coefficients transformed to odds
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated.  {cmd:or} may be specified either at
estimation or upon replay.

{phang}
{opt variance}, the default, displays the random-effects
parameter estimates as variances and covariances.

{phang}
{opt stddeviations} displays the random-effects parameter estimates as
standard deviations and correlations.

{phang}
{opt noretable} suppresses the random-effects table.

{phang}
{opt nofetable} suppresses the fixed-effects table.

{phang}
{opt estmetric}  displays all parameter estimates in one table using the
metric in which they are stored in {cmd:e(b)}.  The results are stored in the
same metric regardless of the parameterization of the variance components,
{cmd:matsqrt} or {cmd:matlog}, used at estimation time.  Random-effects
parameter estimates are stored as log-standard deviations and hyperbolic
arctangents of correlations, with equation names that organize them by model
level.  Note that fixed-effects estimates are always stored and displayed in
the same metric.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{opt intpoints(# [# ...])} sets the number of integration points for adaptive
Gaussian quadrature.  The more integration points, the more accurate the
approximation to the log likelihood.  However, computation time increases with
the number of quadrature points, and in models with many levels or many random
coefficients, this increase can be substantial.

{pmore}
You may specify one number of integration points applying to all levels of
random effects in the model, or you may specify distinct numbers of points for
each level.  {cmd:intpoints(7)} is the default; that is, by default seven
quadrature points are used for each level.

{marker laplace}{...}
{phang}{opt laplace} specifies that log likelihoods be calculated using 
the Laplacian approximation, equivalent to adaptive Gaussian quadrature with
one integration point for each level in the model; {cmd:laplace} is 
equivalent to {cmd:intpoints(1)}.  Computation time increases as a
function of the number of quadrature points raised to a power equaling the
dimension of the random-effects specification.  The computational time
saved by using {cmd:laplace} can thus be substantial, especially when you have
many levels or random coefficients.

{pmore}
The Laplacian approximation has been known to produce biased parameter
estimates, but the bias tends to be more prominent in the estimates of the
variance components rather than in the estimates of the fixed effects.  If your
interest lies primarily with the fixed-effects estimates, the Laplace
approximation may be a viable faster alternative to adaptive quadrature with
multiple integration points.

{pmore}
When the {cmd:R.}{it:varname} notation is used, the dimension of the random
effects increases by the number of distinct values of {it:varname}.  Even when
this number is small to moderate, it increases the total random-effects
dimension to the point where estimation with more than one quadrature point is
prohibitively intensive.

{pmore}
For this reason, when you when you use the {cmd:R.} notation in your
random-effects equations, the {cmd:laplace} option is assumed.  You can
override this behavior by using the {cmd:intpoints()} option, but doing so is
not recommended.

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
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] maximize}.
Those that require special mention for {cmd:meqrlogit}
are listed below.

{pmore}
For the {opt technique()} option, the default is {cmd:technique(nr)}.
The {opt bhhh} algorithm may not be specified.

{pmore}{opt from(init_specs)} is particularly useful when
combined with {cmd:refineopts(iterate(0))}
(see the description {help meqrlogit##refineopts:below}),
which bypasses the initial optimization stage.

{marker retolerance()}{...}
{phang}
{opt retolerance(#)} specifies the convergence tolerance for the estimated
random effects used by adaptive Gaussian quadrature.  Although not estimated
as model parameters, random-effects estimators are used to adapt the
quadrature points.  Estimating these random effects is an iterative procedure,
with convergence declared when the maximum relative change in the random
effects is less than {cmd:retolerance()}.  The default is
{cmd:retolerance(1e-8)}.  You should seldom have to use this option.

{phang}
{opt reiterate(#)} specifies the maximum number of iterations used when 
estimating the random effects to be used in adapting the Gaussian 
quadrature points; see the {helpb meqrlogit##retolerance():retolerance()}
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
{opt refineopts}{cmd:(}{it:{help meqrlogit##maximize_options:maximize_options}}{cmd:)} controls
the maximization process during the refinement of starting values.  Estimation
in {cmd:meqrlogit} takes place in two stages.  In the first stage, starting
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
The following option is available with {opt meqrlogit} but is not shown in
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
{cmd:meqrlogit} would be of the form

{p 8 12 4}{cmd:. meqrlogit} {it:fixed_portion} 
{cmd:|| school:} ... {cmd:,}
{it:options}{p_end}

{pstd}
The variable lists that make up each equation describe how the random effects
enter into the model, either as random intercepts (constant term) or as random
coefficients on regressors in the data.  One may also specify the
variance-covariance structure of the within-equation random effects, according
to the four available structures described above.  For example,

{p 8 12 4}{cmd:. meqrlogit} {it:f_p}
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

{p 8 12 4}{cmd:. meqrlogit} {it:f_p} 
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

{p 8 12 4}{cmd:. meqrlogit} {it:f_p} 
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
estimation data as one group is convenient.  Toward this end, {cmd:meqrlogit}
allows the special group designation {cmd:_all}.  {cmd:meqrlogit} also allows
the {cmd:R.}{it:varname} notation, which is shorthand for
describing the levels of {it:varname} as a series of indicator variables.  See
{mansection ME meRemarksandexamplesex8:example 8} in
{bf:[ME] me} for more details.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bangladesh}{p_end}

{pstd}Two-level random-intercept model, analogous to {cmd:xtlogit}{p_end}
{phang2}{cmd:. meqrlogit c_use urban age child* || district:}{p_end}

{pstd}Two-level random-intercept and random-coefficient model{p_end}
{phang2}{cmd:. meqrlogit c_use urban age child* || district: urban}{p_end}

{pstd}Two-level random-intercept and random-coefficient model, correlated random
effects{p_end}
{phang2}{cmd:. meqrlogit c_use urban age child* || district: urban,}
       {cmd:cov(unstruct)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}

{pstd}Three-level nested model, {cmd:subject} nested within {cmd:family}{p_end}
{phang2}{cmd:. meqrlogit dtlm difficulty i.group || family: || subject:}{p_end}

{pstd}Three-level nested model, altering the number of integration points{p_end}
{phang2}{cmd:. meqrlogit dtlm difficulty i.group || family: || subject:, intpoints(4 5)}{p_end}

{pstd}Replaying fixed effects as odds ratios{p_end}
{phang2}{cmd:. meqrlogit, or}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fifeschool}{p_end}
{phang2}{cmd:. gen byte attain_gt_6 = attain > 6}{p_end}

{pstd}Two-way crossed random effects{p_end}
{phang2}{cmd:. meqrlogit attain_gt_6 sex || _all:R.sid || pid:}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meqrlogit} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_f)}}number of fixed-effects parameters{p_end}
{synopt:{cmd:e(k_r)}}number of random-effects parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(reparm_rc)}}return code, final reparameterization{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:meqrlogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(model)}}{cmd:logistic}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(binomial)}}binomial number of trials{p_end}
{synopt:{cmd:e(redim)}}random-effects dimensions{p_end}
{synopt:{cmd:e(vartypes)}}variance-structure types{p_end}
{synopt:{cmd:e(revars)}}random-effects covariates{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(laplace)}}{cmd:laplace}, if Laplace approximation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared{p_end}
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
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
