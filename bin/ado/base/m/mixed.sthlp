{smcl}
{* *! version 1.2.13  17feb2020}{...}
{viewerdialog mixed "dialog mixed"}{...}
{vieweralsosee "[ME] mixed" "mansection ME mixed"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mixed postestimation" "help mixed postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: mixed" "help bayes mixed"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[XT] xtrc" "help xtrc"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Syntax" "mixed##syntax"}{...}
{viewerjumpto "Menu" "mixed##menu"}{...}
{viewerjumpto "Description" "mixed##description"}{...}
{viewerjumpto "Links to PDF documentation" "mixed##linkspdf"}{...}
{viewerjumpto "Options" "mixed##options"}{...}
{viewerjumpto "Remarks" "mixed##remarks"}{...}
{viewerjumpto "Examples" "mixed##examples"}{...}
{viewerjumpto "Stored results" "mixed##results"}{...}
{viewerjumpto "References" "mixed##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ME] mixed} {hline 2}}Multilevel mixed-effects linear regression
{p_end}
{p2col:}({mansection ME mixed:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{opt mixed} {depvar} {it:fe_equation} [{cmd:||} {it:re_equation}] 
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help mixed##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin}
        [{it:{help mixed##weight:weight}}]
	[{cmd:,} {it:{help mixed##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help mixed##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable in a
	crossed-effects model

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}
		[{cmd:,} {it:{help mixed##re_options:re_options}}]

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 23 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the fixed-effects equation{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(mixed##vartype:vartype)}}variance-covariance 
structure of the random effects{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects 
equation{p_end}
{synopt :{opth fw:eight(exp)}}frequency weights at higher levels{p_end}
{synopt :{opth pw:eight(exp)}}sampling weights at higher levels{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt:{opt ml:e}}fit model via maximum likelihood (ML); the default{p_end}
{synopt:{opt reml}}fit model via restricted maximum likelihood (REML){p_end}
{synopt:{cmdab:dfm:ethod(}{it:{help mixed##df_method:df_method}}{cmd:)}}specify method for computing degrees of freedom (DF) of a t distribution{p_end}
{synopt:{cmd: pwscale(}{it:{help mixed##scale_method:scale_method}}{cmd:)}}control scaling of sampling weights in two-level models{p_end}
{synopt:{cmdab:res:iduals(}{it:{help mixed##rspec:rspec}}{cmd:)}}structure of residual errors{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, {cmdab:r:obust},
or {cmdab:cl:uster} {it:clustvar}; types other than {cmd:oim} may not be 
combined with {cmd:dfmethod()}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt var:iance}}show random-effects and residual-error parameter
estimates as variances and covariances; the default{p_end}
{synopt :{opt stddev:iations}}show random-effects and residual-error parameter
estimates as standard deviations and correlations{p_end}
{synopt :{cmdab:dftab:le(}{it:{help mixed##dftable:dftable}}{cmd:)}}specify
contents of fixed-effects table; requires {cmd:dfmethod()} at estimation{p_end}
{synopt :{opt noret:able}}suppress random-effects table{p_end}
{synopt :{opt nofet:able}}suppress fixed-effects table{p_end}
{synopt :{opt estm:etric}}show parameter estimates as stored in {cmd:e(b)}{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt nostd:err}}do not estimate standard errors of 
random-effects parameters{p_end}
{synopt :{it:{help mixed##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :EM options}
{synopt :{opt emiter:ate(#)}}number of EM iterations; default is
{cmd:emiterate(20)}{p_end}
{synopt :{opt emtol:erance(#)}}EM convergence tolerance; default is
{cmd:emtolerance(1e-10)}{p_end}
{synopt :{opt emonly}}fit model exclusively using EM{p_end}
{synopt :{opt emlog}}show EM iteration log{p_end}
{synopt :{opt emdot:s}}show EM iterations as dots{p_end}

{syntab :Maximization}
{synopt :{it:{help mixed##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
{synopt :{opt matsqrt}}parameterize variance components using matrix square
roots; the default{p_end}
{synopt :{opt matlog}}parameterize variance components using matrix logarithms
{p_end}

{synopt :{opt small}}replay small-sample inference results{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker vartype}{...}
{synopthdr :vartype}
{synoptline}
{synopt :{opt ind:ependent}}one unique variance parameter per random effect, 
all covariances 0; the default unless the {bf:R.} notation is used{p_end}
{synopt :{opt exc:hangeable}}equal variances for random effects, 
and one common pairwise covariance{p_end}
{synopt :{opt id:entity}}equal variances for random effects, all 
covariances 0; the default if the {bf:R.} notation is used{p_end}
{synopt :{opt un:structured}}all variances and covariances to be distinctly 
estimated{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker df_method}{...}
{synopthdr :df_method}
{synoptline}
{synopt :{opt res:idual}}residual degrees of freedom, n - rank(X){p_end}
{synopt :{opt rep:eated}}repeated-measures ANOVA{p_end}
{synopt :{opt anova}}ANOVA{p_end}
{synopt :{opt sat:terthwaite}[{cmd:,} {it:{help mixed##dfopts:dfopts}}]}generalized Satterthwaite approximation; REML estimation only{p_end}
{synopt :{opt kr:oger}[{cmd:,} {it:{help mixed##dfopts:dfopts}}]}Kenward-Roger; REML estimation only{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker dftable}{...}
{synopthdr :dftable}
{synoptline}
{synopt :{opt def:ault}}test statistics, p-values, and confidence intervals; the default{p_end}
{synopt :{opt ci}}DFs and confidence intervals{p_end}
{synopt :{opt pv:alue}}DFs, test statistics, and p-values{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain 
         time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:jackknife},
{cmd:mi estimate}, {cmd:rolling}, and {cmd:statsby} are allowed; see
{help prefix}.  For more details, see
{manhelp bayes_mixed BAYES:bayes: mixed}.{p_end}
{p 4 6 2}{cmd:mi estimate} is not allowed if {cmd:dfmethod()} is specified.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s and {opt fweight}s are allowed; see {help weight}.
However, no weights are allowed if either option {cmd:reml} or option
{cmd:dfmethod()} is specified.{p_end}
{p 4 6 2}
{opt small}, {opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp mixed_postestimation ME:mixed postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models > Linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mixed} fits linear mixed-effects models.  These models are also known as
multilevel models or hierarchical linear models.  The overall error
distribution of the linear mixed-effects model is assumed to be Gaussian, and
heteroskedasticity and correlations within lowest-level groups also may be
modeled.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME mixedQuickstart:Quick start}

        {mansection ME mixedRemarksandexamples:Remarks and examples}

        {mansection ME mixedMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed-effects equation and for any of or all the
random-effects equations.

{phang}{opt covariance(vartype)} specifies the structure of the covariance
matrix for the random effects and may be specified for each random-effects
equation.  {it:vartype} is one of the following:  {cmd:independent},
{cmd:exchangeable}, {cmd:identity}, or {cmd:unstructured}.

{phang2}
{cmd:independent} allows for a distinct variance for each random effect within
a random-effects equation and assumes that all covariances are 0.

{phang2}
{cmd:exchangeable} specifies one common variance for all random effects and
one common pairwise covariance.

{phang2}
{cmd:identity} is short for "multiple of the identity"; that is, all variances
are equal and all covariances are 0.

{phang2}
{cmd:unstructured} allows for all variances and covariances to be distinct.
If an equation consists of p random-effects terms, the unstructured covariance
matrix will have p(p+1)/2 unique parameters.

{pmore}
{cmd:covariance(independent)} is the default, except when the {bf:R.} notation
is used, in which case {cmd:covariance(identity)} is the default and only
{cmd:covariance(identity)} and {cmd:covariance(exchangeable)} are allowed.

{phang}
{opth fweight(exp)} specifies frequency weights at
higher levels in a multilevel model, whereas frequency weights at the
first level (the observation level) are specified in the usual manner,
for example, {cmd:[fw=}{it:fwtvar1}{cmd:]}.  {it:exp} can be any valid
Stata variable, and you can specify {cmd:fweight()} at levels two and higher
of a multilevel model.  For example, in the two-level model

{p 12 16 4}{cmd:. mixed} {it:fixed_portion} {cmd:[fw = wt1]}
{cmd:|| school:} ... {cmd:, fweight(wt2)} ...{p_end}

{pmore}
the variable {cmd:wt1} would hold the first-level (the observation-level)
frequency weights, and {cmd:wt2} would hold the second-level (the
school-level) frequency weights.

{phang}
{opth pweight(exp)} specifies sampling weights at
higher levels in a multilevel model, whereas sampling weights at the
first level (the observation level) are specified in the usual manner, for
example, {cmd:[pw=}{it:pwtvar1}{cmd:]}.  {it:exp} can be any valid Stata
variable, and you can specify {cmd:pweight()} at each levels two and higher of
a multilevel model.  For example, in the two-level model

{p 12 16 4}{cmd:. mixed} {it:fixed_portion} {cmd:[pw = wt1]}
{cmd:|| school:} ... {cmd:, pweight(wt2)} ...{p_end}

{pmore}
variable {cmd:wt1} would hold the first-level (the observation-level) sampling
weights, and {cmd:wt2} would hold the second-level (the school-level) sampling 
weights. 

{pmore}
See {help mixed##sampling:{it:Remarks on using sampling weights}} below
for more information regarding the use of sampling weights in multilevel
models.

{phang}
{opt mle} and {opt reml} specify the statistical method for fitting the model.

{phang2}
{opt mle}, the default, specifies that the model be fit using ML.
Options {cmd:dfmethod(satterthwaite)} and {cmd:dfmethod(kroger)} are not
supported under ML estimation.

{phang2}
{opt reml} specifies that the model be fit using REML, also known as
residual maximum likelihood.

{marker options_df_method}{...}
{phang}
{opt dfmethod(df_method)} requests that reported hypothesis tests for the 
fixed effects (coefficients) use a small-sample adjustment.  By default,
inference is based on a large-sample approximation of the sampling
distributions of the test statistics by normal and chi-squared distributions.
Caution should be exercised when choosing a DF method; see
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for details.

{pmore}
When {opt dfmethod(df_method)} is specified, the sampling distributions of
the test statistics are approximated by a t distribution,
according to the requested method for computing the DF.  {it:df_method} is
one of the following: {opt residual}, {opt repeated}, {opt anova},
{opt satterthwaite}, or {opt kroger}.

{phang2}
{opt residual} uses the residual degrees of freedom, n - rank(X), as the DF
for all tests of fixed effects.  For a linear model without random effects
with independent and identically distributed errors, the distributions of the
test statistics for fixed effects are t distributions with the
residual DF.  For other mixed-effects models, this method typically leads to
poor approximations of the actual sampling distributions of the test
statistics.  

{phang2}
{opt repeated} uses the repeated-measures ANOVA method for computing the DF.
It is used with balanced repeated-measures designs with spherical correlation
error structures.  It partitions the residual degrees of freedom into the
between-subject degrees of freedom and the within-subject degrees of freedom.
{cmd:repeated} is supported only with two-level models.  For more complex
mixed-effects models or with unbalanced data, this method typically leads to
poor approximations of the actual sampling distributions of the test
statistics.

{phang2}
{opt anova} uses the traditional ANOVA method for computing the DF.
According to this method, the DF for a test of a fixed effect of a given
variable depends on whether that variable is also included in any of the
random-effects equations.  For traditional ANOVA models with balanced designs,
this method provides exact sampling distributions of the test statistics.  For
more complex mixed-effects models or with unbalanced data, this method
typically leads to poor approximations of the actual sampling distributions of
the test statistics.

{phang2}
{cmd:satterthwaite}[{cmd:,} {it:dfopts}] implements a generalization of the
{help mixed##S1946:Satterthwaite (1946)}
approximation of the unknown sampling distributions of test statistics for
complex linear mixed-effect models.  This method is supported only with REML
estimation.

{phang2}
{cmd:kroger}[{cmd:,} {it:dfopts}] implements the
{help mixed##KR1997:Kenward and Roger (1997)} method, which is designed to
approximate unknown sampling distributions of test statistics for complex
linear mixed-effects models.  This method is supported only with REML
estimation.

{marker dfopts}{...}
{pmore}
{it:dfopts} is either {opt eim} or {opt oim}.

{phang3}
{opt eim} specifies that the expected information matrix be used to compute
Satterthwaite or Kenward-Roger degrees of freedom.  This is the default.

{phang3}
{opt oim} specifies that the observed information matrix be used to compute
Satterthwaite or Kenward-Roger degrees of freedom.

{pmore} 
Residual, repeated, and ANOVA methods are suitable only when the sampling
distributions of test statistics are known to be t or F.  This is usually only
known for certain classes of linear mixed-effects models with simple
covariance structures and when data are balanced.  These methods are available
with both ML and REML estimation.

{pmore}
For unbalanced data or balanced data with complicated covariance structures,
the sampling distributions of the test statistics are unknown and can only 
be approximated.  The Satterthwaite and Kenward-Roger methods provide
approximations to the distributions in these cases.  According to 
{help mixed##SMF2002:Schaalje, McBride, and Fellingham (2002)}, 
the Kenward-Roger method should, in general, be preferred to the Satterthwaite
method.  However, there are situations in which the two methods are expected
to perform similarly, such as with compound symmetry covariance structures.
The Kenward-Roger method is more computationally demanding than the
Satterthwaite method.  Both methods are available only with REML estimation.
See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
under {it:Remarks and examples} in {bf:[ME] mixed} for examples and
more detailed descriptions of the DF methods.

{pmore}
{cmd:dfmethod()} may not be combined with weighted estimation, the
{cmd:mi estimate} prefix, or {cmd:vce()} unless it is the default
{cmd:vce(oim)}.

{marker scale_method}{...}
{phang}
{cmd:pwscale(}{it:scale_method}{cmd:)} controls how sampling weights (if
specified) are scaled in two-level models.  {it:scale_method} is one of the
following: {cmd:size}, {cmdab:eff:ective}, or {cmd:gk}.

{phang2}
{cmd:size} specifies that first-level
(observation-level) weights be scaled so that they sum to the 
sample size of their corresponding second-level cluster.  Second-level
sampling weights are left unchanged.

{phang2}
{cmd:effective} specifies that first-level weights be
scaled so that they sum to the effective sample size of their
corresponding second-level cluster.  Second-level sampling weights are
left unchanged.

{phang2}
{cmd:gk} specifies the
{help mixed##GK1996:Graubard and Korn (1996)} method.
Under this method, second-level weights are set to the cluster averages of the
products of the weights at both levels, and first-level weights are then set
equal to 1.

{pmore}
{cmd:pwscale()} is supported only with two-level models.
See {mansection ME mixedRemarksandexamplesSurveydata:{it:Survey data}} under
{it:Remarks and examples} in {bf:[ME] mixed} for more details on using
{cmd:pwscale()}.  {cmd:pwscale()} may not be combined with the {cmd:dfmethod()}
option.

{marker rspec}{...}
{phang}{opt residuals(rspec)} specifies the structure of the residual errors
within the lowest-level groups (the second level of a multilevel model with
the observations comprising the first level) of the linear mixed model.  For
example, if you are modeling random effects for classes nested within schools,
then {cmd:residuals()} refers to the residual variance-covariance structure of
the observations within classes, the lowest-level groups. {it:rspec}
has the following syntax:

{phang3}
{it:restype} [{cmd:,} {help mixed##residual_options:{it:residual_options}}]

{pmore}
{it:restype} is one of the following:
{cmdab:ind:ependent}, {cmdab:exc:hangeable}, {cmd:ar} {it:#}, {cmd:ma} {it:#},
{cmdab:un:structured}, {cmdab:ba:nded} {it:#}, {cmdab:to:eplitz} {it:#},
or {cmdab:exp:onential}.
      
{phang2}
{cmd:independent}, the default, specifies that all residuals be independent
and identically distributed Gaussian with one common variance.  When combined
with {opth by(varname)}, independence is still assumed, but you estimate a
distinct variance for each level of {it:varname}.  Unlike with the structures
described below, {it:varname} does not need to be constant within groups.

{phang2}
{cmd:exchangeable} estimates two parameters, one common 
within-group variance and one common pairwise covariance.  When combined
with {opth by(varname)}, these two parameters are distinctly 
estimated for each level of {it:varname}.  Because you are modeling a 
within-group covariance, {it:varname} must be constant within lowest-level
groups.

{phang2}
{cmd:ar} {it:#} assumes that within-group errors have 
an autoregressive (AR) structure of order {it:#}; {cmd: ar 1} is the default.
The {opth t(varname)} option is required, where {it:varname} is an
integer-valued time variable used to order the observations within groups and
to determine the lags between successive observations.  Any nonconsecutive time
values will be treated as gaps.  For this structure, {it:#} + 1 parameters are
estimated ({it:#} AR coefficients and one overall error variance).
{it:restype} {cmd:ar} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang2}
{cmd:ma} {it:#} assumes that within-group errors have 
a moving average (MA) structure of order {it:#}; {cmd: ma 1} is the default.
The {opth t(varname)} option is required, where {it:varname} is an
integer-valued time variable used to order the observations within groups and
to determine the lags between successive observations.  Any nonconsecutive time
values will be treated as gaps.  For this structure, {it:#} + 1 parameters are
estimated ({it:#} MA coefficients and one overall error variance).
{it:restype} {cmd:ma} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang2}
{cmd:unstructured} is the most general structure; it estimates
distinct variances for each within-group error and distinct covariances for
each within-group error pair.  The {opth t(varname)} option is required, where
{it:varname} is a nonnegative-integer-valued variable that identifies the
observations within each group.  The groups may be unbalanced in that not all
levels of {opt t()} need to be observed within every group, but you may not
have repeated {opt t()} values within any particular group.  When you have p
levels of {opt t()}, then p(p+1)/2 parameters are estimated.  {it:restype}
{cmd:unstructured} may be combined with {opt by(varname)}, but {it:varname}
must be constant within groups.

{phang2}
{cmd:banded} {it:#} is a special case of {cmd:unstructured} that
restricts estimation to the covariances within the first {it:#}
off-diagonals and sets the covariances outside this band to 0.  The
{opth t(varname)} option is required, where {it:varname} is a
nonnegative-integer-valued variable that identifies the observations within
each group.  {it:#} is an integer between 0 and p-1, where p is the number
of levels of {opt t()}.  By default, {it:#} is p-1; that is, all elements of
the covariance matrix are estimated.  When {it:#} is 0, only the diagonal 
elements of the covariance matrix are estimated.  {it:restype}
{cmd:banded} may be combined with {opt by(varname)}, but {it:varname} must
be constant within groups.

{phang2}
{cmd:toeplitz} {it:#} assumes that within-group errors have
Toeplitz structure of order {it:#}, for which correlations are constant with
respect to time lags less than or equal to {it:#} and are 0 for lags greater
than {it:#}.  The {opth t(varname)} option is required, where {it:varname} is
an integer-valued time variable used to order the observations within groups
and to determine the lags between successive observations.  {it:#} is an
integer between 1 and the maximum observed lag (the default).  Any
nonconsecutive time values will be treated as gaps.  For this structure,
{it:#} + 1 parameters are estimated ({it:#} correlations and one overall error
variance).  {it:restype} {cmd:toeplitz} may be combined with
{opt by(varname)}, but {it:varname} must be constant within groups.

{phang2}
{cmd:exponential} is a generalization of the AR
covariance model that allows for unequally spaced and noninteger time values.
The {opth t(varname)} option is required, where {it:varname} is real-valued.
For the exponential covariance model, the correlation between two errors is
the parameter rho, raised to a power equal to the absolute value of the
difference between the {cmd:t()} values for those errors.  For this structure,
two parameters are estimated (the correlation parameter rho and one overall
error variance).  {it:restype} {cmd:exponential} may be combined with
{opt by(varname)}, but {it:varname} must be constant within groups.

{marker residual_options}{...}
{pmore}
{it:residual_options} are {opth by(varname)} and {opt t(varname)}.

{phang2}
{opt by(varname)} is for use within the {opt residuals()} option and specifies
that a set of distinct residual-error parameters be estimated for each level of
{it:varname}.  In other words, you use {opt by()} to model heteroskedasticity.

{phang2}
{opt t(varname)} is for use within the {opt residuals()} option to specify a
time variable for the {cmd:ar}, {cmd:ma}, {cmd:toeplitz}, and
{cmd:exponential} structures, or to identify the observations when
{it:restype} is {cmd:unstructured} or {cmd:banded}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}),
and that allow for intragroup correlation ({cmd:cluster} {it:clustvar}); see
{helpb vce_option:[R] {it:vce_option}}.  If {cmd:vce(robust)} is specified,
robust variances are clustered at the highest level in the multilevel model.

{phang2}
{cmd:vce(robust)} and {cmd:vce(cluster} {it:clustvar}{cmd:)} are not
supported with REML estimation.  Only {cmd:vce(oim)} is allowed in combination 
with {cmd:dfmethod()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt variance}, the default, displays the random-effects and residual-error
parameter estimates as variances and covariances.

{phang}
{opt stddeviations} displays the random-effects and residual-error
parameter estimates as standard deviations and correlations.

{phang}
{opt dftable(dftable)} specifies the contents of the fixed-effects table for
small-sample inference when {cmd:dfmethod()} is used during estimation.  
{it:dftable} is one of the following:
{cmd:default}, {cmd:ci}, or {cmd:pvalue}.

{phang2}
{cmd:default} displays the default standard fixed-effects table that
contains test statistics, p-values, and confidence intervals.

{phang2}
{cmd:ci} displays the fixed-effects table in which the columns
containing statistics and p-values are replaced with a column containing
coefficient-specific DFs.  Confidence intervals are also displayed.

{phang2}
{cmd:pvalue} displays the fixed-effects table that includes a column
containing DFs with the standard columns containing test statistics and
p-values.  Confidence intervals are not displayed.

{phang}
{opt noretable} suppresses the random-effects table from the output.

{phang}
{opt nofetable} suppresses the fixed-effects table from the output.

{phang}
{opt estmetric} displays all parameter estimates in one table using the metric
in which they are stored in {cmd:e(b)}.  The results are stored in the same
metric regardless of the parameterization of the variance components,
{cmd:matsqrt} or {cmd:matlog}, used at estimation time.  Random-effects
parameter estimates are stored as log-standard deviations and hyperbolic
arctangents of correlations, with equation names that organize them by model
level.  Residual-variance parameter estimates are stored as log-standard
deviations and, when applicable, as hyperbolic arctangents of correlations.
Note that fixed-effects estimates are always stored and displayed in the same
metric.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

{phang}
{opt nostderr} prevents {cmd:mixed} from calculating standard errors for
the estimated random-effects parameters, although standard errors are still
provided for the fixed-effects parameters.  Specifying this option will speed
up computation times.  {opt nostderr} is available only when residuals are
modeled as independent with constant variance.

INCLUDE help displayopts_list

{dlgtab:EM options}

{pstd}
These options control the expectation-maximization (EM)
iterations that take place before estimation switches to a gradient-based
method.  When residuals are modeled as independent with constant variance,
EM will either converge to the solution or bring parameter estimates
close to the solution.  For other residual structures or for 
weighted estimation, EM is used to obtain starting values.

{phang2}
{opt emiterate(#)} specifies the number of EM iterations to perform.  The
default is {cmd:emiterate(20)}.

{phang2}
{opt emtolerance(#)} specifies the convergence tolerance for the EM 
algorithm.  The default is {cmd:emtolerance(1e-10)}.  EM iterations will be
halted once the log (restricted) likelihood changes by a relative amount less
than {it:#}.  At that point, optimization switches to a gradient-based method,
unless {opt emonly} is specified, in which case maximization stops.

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
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance}; 
see {helpb maximize:[R] Maximize}.
Those that require special mention for {cmd: mixed}
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
The following options are available with {opt mixed} but are not shown in the
dialog box:

{phang}
{opt small} replays previously obtained small-sample results.  This option is 
available only upon replay and requires that the {cmd:dfmethod()} option be 
used during estimation. {cmd:small} is equivalent to {cmd:dftable(default)} 
upon replay.

{phang}
{opt collinear} specifies that {cmd:mixed} not omit collinear
variables from the random-effects equation.  Usually, there is no reason to
leave collinear variables in place; in fact, doing so usually causes the
estimation to fail because of the matrix singularity caused by the collinearity.
However, with certain models (for example, a random-effects model with a full
set of contrasts), the variables may be collinear, yet the
model is fully identified because of restrictions on the random-effects
covariance structure.  In such cases, using the {cmd:collinear} option allows
the estimation to take place with the random-effects equation intact.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help mixed##remarks1:Remarks on specifying random-effects equations}
{p_end}
{phang2}{help mixed##sampling:Remarks on using sampling weights}{p_end}
{phang2}{help mixed##denDF:Remarks on small-sample inference for fixed effects}{p_end}


{marker remarks1}{...}
{title:Remarks on specifying random-effects equations}

{pstd}
Mixed models consist of fixed effects and random effects.  The fixed effects
are specified as regression parameters in a manner similar to most other Stata
estimation commands, that is, as a dependent variable followed by a set of
regressors.  The random-effects portion of the model is specified by first
considering the grouping structure of the data.  For example, if random
effects are to vary according to variable {cmd:school}, then the call to
{cmd:mixed} would be of the form

{p 8 12 4}{cmd:. mixed} {it:fixed_portion} 
{cmd:|| school:} ... {cmd:,}
{it:options}{p_end}

{pstd}
The variable lists that make up each equation describe how the random effects
enter into the model, either as random intercepts (constant term) or as random
coefficients on regressors in the data.  One may also specify the
variance-covariance structure of the within-equation random effects, according
to the four available structures described above.  For example,

{p 8 12 4}{cmd:. mixed} {it:f_p}
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

{p 8 12 4}{cmd:. mixed} {it:f_p} 
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

{p 8 12 4}{cmd:. mixed} {it:f_p} 
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
end, {cmd:mixed} allows the special group designation {cmd:_all}.  
{cmd:mixed} also allows the {cmd:R.}{it:varname} notation, 
which is shorthand for describing the levels of {it:varname} as a 
series of indicator variables.  See 
{mansection ME mixedRemarksandexamplesCrossed-effectsmodels:{it:Crossed-effects models}}
in {bf:[ME] mixed} for more details.


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
two-level model, {cmd:mixed} will assume sampling with equal
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
To deal with this, {cmd:mixed} has the {cmd:pwscale()} option for
rescaling weights in two-level models; see {help mixed##scale_method:above} 
for more information on {cmd:pwscale()}.
Three scaling methods are offered, with each method known to perform
well under certain data situations and posited models.

{pstd}
In general, exercise caution when using sampling weights with 
{cmd:mixed}; see {mansection ME mixedRemarksandexamplesSurveydata:{it:Survey data}} in {bf:[ME] mixed} for more information.


{marker denDF}{...}
{title:Remarks on small-sample inference for fixed effects}

{pstd}
By default, {cmd:mixed} performs large-sample inference for fixed effects
using asymptotic normal and chi-squared distributions.  These large-sample
approximations may not be appropriate in small samples, and t and F
distributions may provide better approximations.  You can specify the
{cmd:dfmethod()} option to request small-sample inference for fixed effects.
{cmd:mixed, dfmethod()} uses a t distribution for one-hypothesis tests
and an F distribution for multiple-hypotheses tests for inference about
fixed effects.  It also provides five different methods for calculating the
DF: {cmd:residual}, {cmd:repeated}, {cmd:anova}, {cmd:satterthwaite}, and
{cmd:kroger}.  See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for more information.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}

{pstd}Random-intercept model, analogous to {cmd:xtreg}{p_end}
{phang2}{cmd:. mixed ln_w grade age c.age#c.age ttl_exp}
          {cmd:tenure c.tenure#c.tenure || id:}{p_end}

{pstd}Random-intercept and random-slope (coefficient) model{p_end}
{phang2}{cmd:. mixed ln_w grade age c.age#c.age ttl_exp}
           {cmd:tenure c.tenure#c.tenure || id: tenure}{p_end}

{pstd}Random-intercept and random-slope (coefficient) model, correlated random
effects{p_end}
{phang2}{cmd:. mixed ln_w grade age c.age#c.age ttl_exp}
            {cmd:tenure c.tenure#c.tenure || id: tenure,}
            {cmd:cov(unstruct)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Two-level model{p_end}
{phang2}{cmd:. mixed weight week || id:}{p_end}

{pstd}Two-level model with robust standard errors{p_end}
{phang2}{cmd:. mixed weight week || id:, vce(robust)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity}{p_end}

{pstd}Three-level nested model, observations nested within 
{cmd:state} nested within {cmd:region}, fit
by maximum likelihood{p_end}
{phang2}{cmd:. mixed gsp private emp hwy water other unemp || region: ||}
           {cmd:state:, mle}{p_end}

{pstd}Three-level nested random interactions model with ANOVA DF{p_end}
{phang2}{cmd:. mixed gsp private emp hwy water other unemp || region:water }
	{cmd: || state:other, dfmethod(anova)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Two-way crossed random effects{p_end}
{phang2}{cmd:. mixed weight week || _all: R.id || _all: R.week}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ovary}{p_end}

{pstd}Linear mixed model with MA 2 errors{p_end}
{phang2}{cmd:. mixed follicles sin1 cos1 || mare: sin1, residuals(ma 2, t(time))}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse childweight}{p_end}

{pstd}Linear mixed model with heteroskedastic error variances{p_end}
{phang2}{cmd:. mixed weight age || id:age, residuals(independent, by(girl))}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Random-intercept and random-slope model with Kenward-Roger DF{p_end}
{phang2}{cmd:. mixed weight week || id:week, reml dfmethod(kroger)}{p_end}

{pstd}Display degrees-of-freedom table containing p-values{p_end}
{phang2}{cmd:. mixed, dftable(pvalue)}{p_end}

{pstd}Display degrees-of-freedom table containing confidence intervals{p_end}
{phang2}{cmd:. mixed, dftable(ci)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse t43}{p_end}

{pstd} Repeated-measures model with the repeated DF{p_end}
{phang2}{cmd:. mixed score i.drug || person:, reml dfmethod(repeated)}{p_end}

{pstd} Replay large-sample results{p_end}
{phang2}{cmd:. mixed}{p_end}

{pstd} Replay small-sample results using the repeated DF{p_end}
{phang2}{cmd:. mixed, small}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mixed} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_f)}}number of fixed-effects parameters{p_end}
{synopt:{cmd:e(k_r)}}number of random-effects parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(k_res)}}number of residual-error parameters{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(nrgroups)}}number of residual-error {cmd:by()} groups{p_end}
{synopt:{cmd:e(ar_p)}}AR order of residual errors, if specified{p_end}
{synopt:{cmd:e(ma_q)}}MA order of residual errors, if specified{p_end}
{synopt:{cmd:e(res_order)}}order of residual-error structure, if appropriate{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(small)}}{cmd:1} if {cmd:dfmethod()} option specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(F)}}overall F test statistic when {cmd:dfmethod()} is 
specified{p_end}
{synopt:{cmd:e(ddf_m)}}model DDF{p_end}
{synopt:{cmd:e(df_max)}}maximum DF{p_end}
{synopt:{cmd:e(df_avg)}}average DF{p_end}
{synopt:{cmd:e(df_min)}}minimum DF{p_end}
{synopt:{cmd:e(ll)}}log (restricted) likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mixed}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type (first-level weights){p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}{cmd:fweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}{cmd:pweight} variable for {it:k}th highest level, if specified{p_end}
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
{synopt:{cmd:e(dfmethod)}}DF method specified in {cmd:dfmethod()}{p_end}
{synopt:{cmd:e(dftitle)}}title for DF method{p_end}
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
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(tmap)}}ID mapping for unstructured residual errors{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(df)}}parameter-specific DF for fixed effects{p_end}
{synopt:{cmd:e(V_df)}}variance-covariance matrix of the estimators when {cmd:dfmethod(kroger)} is specified{p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker GK1996}{...}
{phang}
Graubard, B. I., and E. L. Korn. 1996.  Modelling the sampling design in the 
analysis of health surveys. 
{it:Statistical Methods in Medical Research} 5: 263-281.

{marker KR1997}{...}
{phang}
Kenward, M. G., and J. H. Roger. 1997.  Small sample inference for fixed
effects from restricted maximum likelihood.  {it:Biometrics} 53: 983-997.

{marker S1946}{...}
{phang}
Satterthwaite, F. E. 1946. An approximate distribution of estimates of
variance components. {it:Biometrics Bulletin} 2: 110-114.

{marker SMF2002}{...}
{phang}
Schaalje, G. B., J. B. McBride, and G. W. Fellingham. 2002. Adequacy of 
approximations to distributions of test statistics in complex mixed linear
models. {it:Journal of Agricultural, Biological, and Environmental Statistics} 
7: 512-524.
{p_end}
