{smcl}
{* *! version 1.1.9  03feb2020}{...}
{viewerdialog menl "dialog menl"}{...}
{vieweralsosee "[ME] menl" "mansection ME menl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] menl postestimation" "help menl postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{viewerjumpto "Syntax" "menl##syntax"}{...}
{viewerjumpto "Menu" "menl##menu"}{...}
{viewerjumpto "Description" "menl##description"}{...}
{viewerjumpto "Links to PDF documentation" "menl##linkspdf"}{...}
{viewerjumpto "Options" "menl##options"}{...}
{viewerjumpto "Examples" "menl##examples"}{...}
{viewerjumpto "Stored results" "menl##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[ME] menl} {hline 2}}Nonlinear mixed-effects regression{p_end}
{p2col:}({mansection ME menl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{opt menl} {depvar} {cmd:=} <{it:menlexpr}>
{ifin}
[{cmd:,} {it:{help menl##optstable:options}}]

{marker menlexpr}{...}
{phang}
<{it:menlexpr}> defines a nonlinear regression function as a substitutable
expression that contains model parameters and random effects specified in
braces {cmd:{c -(}{c )-}}, as in
{cmd:exp({c -(}b{c )-}+{c -(}U[id]{c )-})}; see
{mansection ME menlRemarksandexamplesRandom-effectssubstitutableexpressions:{it:Random-effects substitutable expressions}}
in {bf:[ME] menl} for details.


{marker optstable}{...}
{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt ml:e}}fit model via maximum likelihood; the default{p_end}
{synopt :{opt reml}}fit model via restricted maximum likelihood{p_end}
{synopt :{cmdab:def:ine(}{help menl##paramdef:{it:name}{bf::}<{it:resubexpr}>}{cmd:)}}define a function of model
parameters; this option may be repeated{p_end}
{synopt :{opth cov:ariance(menl##covspec:covspec)}}variance-covariance
structure of the random effects; this option may be repeated{p_end}
{synopt :{opth init:ial(menl##initial_values:initial_values)}}initial values
for parameters{p_end}

{syntab:Residuals}
{synopt :{opth rescov:ariance(menl##rescovspec:rescovspec)}}covariance
structure for within-group errors{p_end}
{synopt :{opth resvar:iance(menl##resvarspec:resvarspec)}}heteroskedastic variance structure
for within-group errors{p_end}
{synopt :{opth rescorr:elation(menl##rescorrspec:rescorrspec)}}correlation
structure for within-group errors{p_end}

{syntab:Time series}
{synopt :{opth tsorder(varname)}}specify time variable to determine the
ordering for time-series operators{p_end}
{synopt :{cmd:tsinit(}{help menl##tsidef:{bf:{c -(}}{it:name}{bf::{c )-}=}<{it:resubexpr}>}{cmd:)}}specify initial conditions for lag operators used with named expressions; this option may be repeated{p_end}
{synopt :{opt tsmiss:ing}}keep observations with missing values in {it:depvar}
in computation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt var:iance}}show random-effects and within-group error parameter
estimates as variances and covariances; the default{p_end}
{synopt :{opt stddev:iations}}show random-effects and within-group
error parameter estimates as standard deviations and correlations{p_end}
{synopt :{opt noret:able}}suppress random-effects table{p_end}
{synopt :{opt nofet:able}}suppress fixed-effects table{p_end}
{synopt :{opt estm:etric}}show parameter estimates as stored in {cmd:e(b)}{p_end}
{synopt :{opt noleg:end}}suppress table expression legend{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt nostd:err}}do not estimate standard errors of random-effects
parameters{p_end}
{synopt :{opt lr:test}}perform a likelihood-ratio test to compare the nonlinear mixed-effects model with ordinary nonlinear regression{p_end}
{synopt :{opt notsshow}}do not show ts setting information{p_end}
{synopt :{it:{help menl##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:EM options}
{synopt :{opt emiter:ate(#)}}number of EM iterations; 
default is {cmd:emiterate(25)}{p_end}
{synopt :{opt emtol:erance(#)}}EM convergence tolerance; 
default is {cmd:emtolerance(1e-10)}{p_end}
{synopt :{opt emlog}}show EM iteration log{p_end}

{syntab:Maximization}
{synopt :{it:{help menl##menlmaxopts:menlmaxopts}}}control the maximization
process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp menl_postestimation ME:menl postestimation} for
features available after estimation.{p_end}
{p2colreset}{...}


{marker covspec}{...}
{phang}
The syntax of {it:covspec} is

{pmore2}
{mansection ME menlRemarksandexamplesrename:{it:rename1}} {it:rename2}
    [...]{cmd:,} {it:vartype}

{marker vartype}{...}
{synoptset 30}{...}
{synopthdr:vartype}
{synoptline}
{synopt :{opt ind:ependent}}one unique variance parameter per random effect;
all covariances are 0; the default{p_end}
{synopt :{opt exc:hangeable}}equal variances for random effects and one
common pairwise covariance{p_end}
{synopt :{opt id:entity}}equal variances for random effects; all covariances are
0{p_end}
{synopt :{opt un:structured}}all variances and covariances to be distinctly
estimated{p_end}
{synoptline}

{marker rescovspec}{...}
{phang}
The syntax of {it:rescovspec} is

{pmore2}
{it:rescov} [{cmd:,} {help menl##rescovopts:{it:rescovopts}}] 

{marker rescov}{...}
{synopthdr:rescov}
{synoptline}
{synopt :{opt id:entity}}uncorrelated within-group errors with one common
variance; the default{p_end}
{synopt :{opt ind:ependent}}uncorrelated within-group errors with distinct
variances{p_end}
{synopt :{opt exc:hangeable}}within-group errors with equal variances and one
common covariance{p_end}
{synopt :{cmd:ar} [{it:#}]}within-group errors with autoregressive (AR)
structure of order {it:#}, AR({it:#}); {cmd:ar 1} is implied by
{cmd:ar}{p_end}
{synopt :{cmd:ma} [{it:#}]}within-group errors with moving-average (MA)
structure of order {it:#}, MA({it:#}); {cmd:ma 1} is implied by
{cmd:ma}{p_end}
{synopt :{opt ctar1}}within-group errors with continuous-time AR(1)
structure{p_end}
{synopt :{opt to:eplitz} [{it:#}]}within-group errors have Toeplitz structure
of order {it:#}; {opt toeplitz} implies that all matrix off-diagonals be
estimated{p_end}
{synopt :{opt ba:nded} [{it:#}]}within-group errors with distinct variances
and covariances within first {it:#} off-diagonals; {cmd:banded} implies all
matrix bands (unstructured){p_end}
{synopt :{opt un:structured}}within-group errors with distinct variances and
covariances{p_end}
{synoptline}

{marker resvarspec}{...}
{phang}
The syntax of {it:resvarspec} is

{pmore2}
{it:resvarfunc} [{cmd:,} {help menl##resvaropts:{it:resvaropts}}] 

{marker resvarfunc}{...}
{synopthdr:resvarfunc}
{synoptline}
{synopt :{opt id:entity}}equal within-group error variances; the
default{p_end}
{synopt :{opt lin:ear} {varname}}within-group error variance varies linearly
with {it:varname}{p_end}
{synopt :{opt pow:er} {varname}|{cmd:_yhat}}variance function is a power of
{it:varname} or of predicted mean{p_end}
{synopt :{opt exp:onential} {varname}|{cmd:_yhat}}variance function is
exponential of {it:varname} or of predicted mean{p_end}
{synopt :{opt dis:tinct}}distinct within-group error variances{p_end}
{synoptline}

{marker rescorrspec}{...}
{phang}
The syntax of {it:rescorrspec} is

{pmore2}
{it:rescorr} [{cmd:,} {help menl##rescorropts:{it:rescorropts}}]

{marker rescorr}{...}
{synopthdr:rescorr}
{synoptline}
{synopt :{opt id:entity}}uncorrelated within-group errors; the default{p_end}
{synopt :{opt exc:hangeable}}within-group errors with one common correlation{p_end}
{synopt :{opt ar} [{it:#}]}within-group errors with AR({it:#}) structure;
{cmd:ar 1} is implied by {cmd:ar}{p_end}
{synopt :{opt ma} [{it:#}]}within-group errors with MA({it:#}) structure;
{cmd:ma 1} is implied by {cmd:ma}{p_end}
{synopt :{opt ctar1}}within-group errors with continuous-time AR(1)
structure{p_end}
{synopt :{opt to:eplitz} [{it:#}]}within-group errors have Toeplitz
correlation structure of order {it:#}; {cmd:toeplitz} implies that all
matrix off-diagonals be estimated{p_end}
{synopt :{opt ba:nded} [{it:#}]}within-group errors with distinct
correlations within first {it:#} off-diagonals; {cmd:banded} implies all
matrix bands (unstructured){p_end}
{synopt :{opt un:structured}}within-group errors with distinct correlations{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models > Nonlinear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:menl} fits nonlinear mixed-effects models in which some or all fixed and
random effects enter nonlinearly.  These models are also known as multilevel
nonlinear models or hierarchical nonlinear models.  The overall error
distribution of the nonlinear mixed-effects model is assumed to be Gaussian.
Different covariance structures are provided to model random effects and to
model heteroskedasticity and correlations within lowest-level groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME menlQuickstart:Quick start}

        {mansection ME menlRemarksandexamples:Remarks and examples}

        {mansection ME menlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:mle} and {cmd:reml} specify the statistical method for fitting the model.

{pmore}
{opt mle}, the default, specifies that the model be fit using 
maximum likelihood (ML).

{pmore}
{opt reml} specifies that the model be fit using restricted maximum likelihood
(REML), also known as residual maximum likelihood.

{marker paramdef}{...}
{phang}
{cmd:define(}{it:name}{cmd::}<{it:resubexpr}>{cmd:)} defines a function of
model parameters, <{it:resubexpr}>, and labels it as {it:name}.  This
option can be repeated to define multiple functions.  The {opt define()} option
is useful for expressions that appear multiple times in the main nonlinear
specification {help menl##menlexpr:{it:menlexpr}}: you define the
expression once and then simply refer to it by using
{cmd:{c -(}}{it:name}{cmd::{c )-}} in the nonlinear specification.  This
option can also be used for notational convenience.
See {mansection ME menlRemarksandexamplesRandom-effectssubstitutableexpressions:{it:Random-effects substitutable expressions}}
in {bf:[ME] menl} for how to specify <{it:resubexpr}>.
<{it:resubexpr}> within {cmd:define()} may not contain the lagged predicted
mean function.

{phang}
{cmd:covariance(}{mansection ME menlRemarksandexamplesrename:{it:rename1}}
{it:rename2} [...]{opt ,} {help menl##vartype:{it:vartype}}{cmd:)}
specifies the structure of the covariance matrix for the random effects.
{it:rename1}, {it:rename2}, and so on, are the names of the random effects to
be correlated (see {mansection ME menlRemarksandexamplesRandomeffects:{it:Random effects}}
in {bf:[ME] menl}), and {it:vartype} is one of the following: 
{opt independent}, {opt exchangeable}, {opt identity}, or {opt unstructured}.
Instead of {it:rename}s, you can specify {it:restub}{cmd:*} to refer to random
effects that share the same {it:restub} in their names.

{phang2}
{opt independent} allows for a distinct variance for each random
effect and assumes that all covariances are 0; the default.

{phang2}
{opt exchangeable} specifies one common variance for all random
effects and one common pairwise covariance.

{phang2}
{opt identity} is short for "multiple of the identity"; that is,
all variances are equal, and all covariances are 0.

{phang2}
{opt unstructured} allows for all variances and covariances to be
distinct.  If p random effects are specified, the
unstructured covariance matrix will have p(p+1)/2 unique parameters.

{marker initial_values}{...}
{phang}
{opt initial(initial_values)} specifies the initial values for model
parameters.  You can specify a 1 x k matrix, where k is the total
number of parameters in the model, or you can specify a parameter name, its
initial value, another parameter name, its initial value, and so on.  For
example, to initialize {cmd:{c -(}alpha{c )-}} to 1.23 and
{cmd:{c -(}delta{c )-}} to 4.57, you
would type

            . {cmd:menl} ...{cmd:, initial(alpha 1.23 delta 4.57)} ...

{pmore}
To initialize multiple parameters that have the same group name,
for example, {cmd:{c -(}y:x1{c )-}} and {cmd:{c -(}y:x2{c )-}}, with the same
initial value, you can simply type

            . {cmd:menl} ...{cmd:, initial({c -(}y:{c )-} 1)} ...

{pmore}
For the full specification, see
{mansection ME menlRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}} in {bf:[ME] menl}.

{dlgtab:Residuals}

{pstd}
{opt menl} provides two ways to model the within-group error covariance
structure, sometimes also referred to as residual covariance structure in the
literature.  You can model the covariance directly by using the
{cmd:rescovariance()} option or indirectly by using the {cmd:resvariance()}
and {cmd:rescorrelation()} options.

{phang}
{cmd:rescovariance(}{it:rescov}
[{cmd:,} {help menl##rescovopts:{it:rescovopts}}]{cmd:)} specifies the
{help me_glossary##withingrouperrors:within-group errors} covariance structure
or covariance structure of the residuals within the
{help me_glossary##lowestlevelgroup:lowest-level group}
of the nonlinear mixed-effects model.  For example, if you are modeling random
effects for classes nested within schools, then {cmd:rescovariance()} refers
to the residual variance-covariance structure of the observations
within classes, the lowest-level groups.

{marker rescov}{...}
{phang2}
{it:rescov} is one of the following:
{cmd:identity}, {cmd:independent}, {opt exchangeable},
{cmd:ar} [{it:#}], {cmd:ma} [{it:#}], {cmd:ctar1},
{cmd:toeplitz} [{it:#}], {cmd:banded} [{it:#}], or
{opt unstructured}.  Below, we describe each {it:rescov} with its specific
options {help menl##rescovopts:{it:rescovopts}}:

{phang3}
{cmd:identity} [{cmd:,} {opt by(byvar)}], the default, specifies that all
within-group errors be independent and identically distributed (i.i.d.) with
one common error variance sigma^2_epsilon.  When combined with
{opt by(byvar)}, independence is still assumed, but you estimate a distinct
variance for each category of {it:byvar}.

{phang3}
{cmd:independent,} {opt index(varname)} [{opt group(grpvar)}] specifies that
within-group errors are independent with distinct variances for each value
(index) of {it:varname}.  {opt index(varname)} is required.
{opt group(grpvar)} is required if there are no random effects in the model.

{phang3}
{cmd:exchangeable} [{cmd:,} {opt by(byvar)} {opt group(grpvar)}] assumes that
within-group errors have equal variances and a common covariance.

{phang3}
{cmd:ar} [{it:#}]{cmd:,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have an AR({it:#}) structure.  If
{it:#} is omitted, {cmd:ar 1} is assumed.  {opt t(timevar)} is required.  For
this structure,  {it:#} + 1 parameters are estimated: {it:#} AR coefficients
and one overall error variance, sigma^2_epsilon.

{phang3}
{cmd:ma} [{it:#}]{cmd:,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have an MA({it:#}) structure.  If {it:#} is
omitted, {cmd:ma 1} is assumed.  {opt t(timevar)} is required.  For this
structure, {it:#} + 1 parameters are estimated: {it:#} MA coefficients and one
overall error variance, sigma^2_epsilon.

{phang3}
{cmd:ctar1,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}] assumes
that within-group errors have a continuous-time AR(1) structure.  This is a
generalization of the AR covariance structure that allows for unequally spaced
and noninteger time values.  {opt t(timevar)} is required.  For this
structure, two parameters are estimated: the correlation parameter, rho, and
one overall error variance, sigma^2_epsilon.  The correlation between two
error terms is the parameter rho raised to a power equal to the absolute
value of the difference between the {cmd:t()} values for those errors.

{phang3}
{cmd:toeplitz} [{it:#}]{cmd:,} {opt t(timevar)}
[{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have a Toeplitz structure of order {it:#},
for which correlations are constant with respect to time lags less than or
equal to {it:#} and are 0 for lags greater than {it:#}.  {it:#} is an integer
between 1 and the maximum observed lag (the default).  {opt t(timevar)} is
required.  For this structure, {it:#} + 1 parameters are estimated:  {it:#}
correlations and one overall error variance, sigma^2_epsilon.

{phang3}
{cmd:banded} [{it:#}]{cmd:,} {opt index(varname)}
[{opt group(grpvar)}]
is a special case of {cmd:unstructured} that restricts estimation to the
covariances within the first {it:#} off-diagonals and sets the covariances
outside this band to 0.  {opt index(varname)} is required.  {it:#} is an
integer between 0 and L - 1, where L is the number of levels of {cmd:index()}.
By default, {it:#} is L - 1; that is, all elements of the covariance matrix
are estimated.  When {it:#} is 0, only the diagonal elements of the covariance
matrix are estimated.  {opt group(grpvar)} is required if there are no random
effects in the model.

{phang3}
{cmd:unstructured,} {opt index(varname)} [{opt group(grpvar)}] assumes that
within-group errors have distinct variances and covariances.  This is the most
general covariance structure in that no structure is imposed on the covariance
parameters.  {opt index(varname)} is required.  When you have L levels of
{opt index()}, then L(L + 1)/2 parameters are estimated.  {opt group(grpvar)}
is required if there are no random effects in the model.

{marker rescovopts}{...}
{phang2}
{it:rescovopts} are {opt index(varname)},
{opt t(timevar)}, {opt by(byvar)}, and {opt group(grpvar)}.

{phang3}
{opt index(varname)} is used within the {opt rescovariance()}
option with {it:rescov} {cmd:independent}, {cmd:banded}, or
{cmd:unstructured}.  {it:varname} is a nonnegative-integer-valued variable
that identifies the observations within the lowest-level groups (for example,
{cmd:obsid}).  The groups may be unbalanced in that different groups may have
different {cmd:index()} values, but you may not have repeated {cmd:index()}
values within any particular group.

{phang3}
{opt t(timevar)} is used within the {cmd:rescovariance()} option to
specify a time variable for the {cmd:ar}, {cmd:ma}, {cmd:ctar1}, and
{cmd:toeplitz} structures.

{pmore3}
With {it:rescov} {cmd:ar}, {cmd:ma}, and {cmd:toeplitz}, {it:timevar} is an
integer-valued time variable used to order the observations within the
lowest-level groups and to determine the lags between successive observations.
Any nonconsecutive time values will be treated as gaps.

{pmore3}
With {it:rescov} {cmd:ctar1}, {it:timevar} is a real-valued time variable.

{phang3}
{opt by(byvar)} is for use within the {opt rescovariance()} option and
specifies that a set of distinct within-group error covariance parameters be
estimated for each category of {it:byvar}.  In other words, you can use
{cmd:by()} to model heteroskedasticity.  {it:byvar} must be
nonnegative-integer valued and constant within the lowest-level groups.

{phang3}
{opt group(grpvar)} is used to identify the lowest-level groups (panels)
when modeling within-group error covariance structures.  {it:grpvar} is a
nonnegative-integer-valued group membership variable.  This option lets
you model within-group error covariance structures at the lowest level of your
model hierarchy without having to include random effects at that level in your
model.  This is useful, for instance, when fitting nonlinear marginal or
population-averaged models that model the dependence between error terms
directly, without introducing random effects; see
{mansection ME menlRemarksandexamplesmenlexdial:example 19}.  In
the presence of random effects at other levels of hierarchy in your model,
{it:grpvar} is assumed to be nested within those levels.

{phang}
{cmd:resvariance(}{it:resvarfunc}
[{cmd:,} {help menl##resvaropts:{it:resvaropts}}]{cmd:)} specifies a
heteroskedastic variance structure of the within-group errors.  It can be used
with the {opt rescorrelation()} option to specify flexible within-group
error covariance structures.  The heteroskedastic variance structure is
modeled as Var(epsilon_{ij})=sigma^2 g^2(delta,upsilon_{ij}), where sigma is
an unknown scale parameter, g() is a function that models heteroskedasticity
(also known as variance function in the literature), deltab is a vector of
unknown parameters of the variance function, and upsilon_{ij}'s are the values
of a fixed covariate or of the predicted mean hat{mu}_{ij}.

{marker resvarfunc}{...}
{phang2}
{it:resvarfunc}, omitting the arguments, is one of the following:
{cmd:identity}, {cmd:linear}, {cmd:power}, {cmd:exponential}, or
{cmd:distinct}, and {help menl##resvaropts:{it:resvaropts}} are options
specific to each variance function.

{phang3}
{opt identity}, the default, specifies a homoskedastic
variance structure for the within-group errors;
g(delta,upsilon_{ij})=1, so that Var(epsilon_{ij})=sigma^2=sigma^2_epsilon.

{phang3}
{opt linear} {varname} specifies that the within-group error variance
vary linearly with {it:varname}; that is,
g(delta,upsilon_{ij}) = sqrt{{it:varname}}_{ij}, so that
Var(epsilon_{ij})=sigma^2{it:varname}_{ij}.
{it:varname} must be positive.

{phang3}
{opt power} {varname}|{cmd:_yhat} [{cmd:,} {opt strata(stratavar)}
{opt nocons:tant}] specifies that the within-group error variance, or
more precisely the variance function, be expressed in terms of a power of
either {it:varname} or the predicted mean {cmd:_yhat}, plus a constant
term; g(delta,upsilon_{ij}) = |v_{ij}|^{delta_1}+delta_2.  If 
{opt noconstant} is specified, the constant term delta_2 is
suppressed.  In general, three parameters are estimated: a scale parameter
sigma, the power delta_1, and the constant term delta_2.  When
{opt strata(stratavar)} is specified, the power and constant
parameters (but not the scale) are distinctly estimated for each stratum.
A total number of 2L+1 parameters are estimated (L power parameters, L
constant parameters, and scale sigma), where L is the number of strata
defined by variable {it:stratavar}.

{phang3}
{opt exponential} {varname}|{cmd:_yhat} [{cmd:,} {opt strata(stratavar)}]
specifies that the within-group error variance vary exponentially with
{it:varname} or with the predicted mean {cmd:_yhat};
g(gamma,upsilon_{ij}) = exp(gamma v_{ij}).  Two parameters are
estimated: a scale parameter sigma and an exponential parameter gamma.
When {opt strata(stratavar)} is specified, the exponential parameter
gamma (but not scale sigma) is distinctly estimated for each stratum.
A total number of L+1 parameters are estimated (L exponential parameters
and scale sigma), where L is the number of strata defined by variable
{it:stratavar}.

{phang3}
{cmd:distinct,} {opt index(varname)} [{opt group(grpvar)}] specifies
that the within-group errors have distinct variances, sigma^2_l, for each
value (index), l, of {it:varname}, v_{ij}; g(delta,v_{ij}) = delta_{v_{ij}}
with delta_{v_{ij}}=sigma_{v_{ij}}/sigma_1 (delta_1=1 for identifiability
purposes) such that
Var(epsilon_{ij})=sigma^2_{v_{ij}}=sigma^2_1delta^2_{v_{ij}} for l=1,2,...,L
and v_{ij} in {c -(}1, 2, ..., L{c )-}.  {opt index(varname)} is required.
{opt group(grpvar)} is required if there are no random effects in the model.
{cmd:resvariance(distinct)} in combination with {cmd:rescorrelation(identity)}
is equivalent to {cmd:rescovariance(independent)}.

{marker resvaropts}{...}
{phang2}
{it:resvaropts} are {opt strata(stratavar)}, {opt nocons:tant},
{opt index()}, or {opt group(grpvar)}.

{phang3}
{opt strata(stratavar)} is used within the {cmd:resvariance()} option
with {it:resvarfunc} {cmd:power} and {cmd:exponential}.  {cmd:strata()}
specifies that the parameters of the variance function g() be
distinctly estimated for each stratum.  The scale parameter sigma remains
constant across strata.  In contrast, {opt rescovariance()}'s
{opt by(byvar)} suboption specifies that all covariance parameters, including
sigma (whenever applicable), be estimated distinctly for each category of
{it:byvar}.  {it:stratavar} must be nonnegative-integer valued and constant
within the lowest-level groups.

{phang3}
{opt noconstant} is used within the {opt resvariance()} option with
{it:resvarfunc} {cmd:power}.  {cmd:noconstant} specifies that the constant
parameter be suppressed in the expression of the variance function g().

{phang3}
{opt index(varname)} is used within the {cmd:resvariance()}
option with {it:resvarfunc} {cmd:distinct}.  {it:varname} is a
nonnegative-integer-valued variable that identifies the observations
within the lowest-level groups (for example, {cmd:obsid}).  The groups may be
unbalanced in that different groups may have different {cmd:index()} values,
but you may not have repeated {cmd:index()} values within any particular
group.

{phang3}
{opt group(grpvar)} is used within the {cmd:resvariance()} option with
{it:resvarfunc} {cmd:distinct}.  It identifies the lowest-level groups
(panels) when no random effects are included in the model specification such
as with nonlinear marginal models.  {it:grpvar} is a
nonnegative-integer-valued group membership variable.

{phang}
{cmd:rescorrelation(}{it:rescorr}
[{cmd:,} {help menl##rescorropts:{it:rescorropts}}]{cmd:)}
specifies a correlation structure of the within-group errors.
It can be used with the {cmd:resvariance()} option to specify flexible
within-group error covariance structures.

{marker rescorr}{...}
{phang2}
{it:rescorr} is one of the following:  {cmd:identity}, {cmd:exchangeable},
{cmd:ar} [{it:#}], {cmd:ma} [{it:#}], {cmd:ctar1},
{cmd:toeplitz} [{it:#}], {cmd:banded} [{it:#}], or {cmd:unstructured}.

{phang3}
{cmd:identity}, the default, specifies that all within-group error
correlations be zeros.

{phang3}
{cmd:exchangeable} [{cmd:,} {opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have a common correlation.

{phang3}
{cmd:ar} [{it:#}]{cmd:,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have an AR({it:#}) correlation
structure.  If {it:#} is omitted, {cmd:ar 1} is assumed.  The
{opt t(timevar)} option is required.  For this structure, {it:#} AR
coefficients are estimated.

{phang3}
{cmd:ma} [{it:#}]{cmd:,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have an MA({it:#}) correlation
structure.  If {it:#} is omitted, {cmd:ma 1} is assumed.  The
{opt t(timevar)} option is required.  For this structure, {it:#} MA
coefficients are estimated.

{phang3}
{opt ctar1,} {opt t(timevar)} [{opt by(byvar)} {opt group(grpvar)}] assumes
that within-group errors have a continuous-time AR(1) correlation structure.
The {opt t(timevar)} option is required.  The correlation between two errors
is the parameter rho raised to a power equal to the absolute value of the
difference between the {cmd:t()} values for those errors.

{phang3}
{opt toeplitz} [{it:#}]{cmd:,} {opt t(timevar)}
[{opt by(byvar)} {opt group(grpvar)}]
assumes that within-group errors have a Toeplitz correlation structure of
order {it:#}, for which correlations are constant with respect to time lags
less than or equal to {it:#} and are 0 for lags greater than {it:#}.  {it:#}
is an integer between 1 and the maximum observed lag (the default).
{opt t(timevar)} is required.  For this structure, {it:#} correlation
parameters are estimated.

{phang3}
{opt banded} [{it:#}]{cmd:,} {opt index(varname)}
[{opt group(grpvar)}]
is a special case of {cmd:unstructured} that restricts estimation to the
correlations within the first {it:#} off-diagonals and sets the correlations
outside this band to 0.  {opt index(varname)} is required.  {it:#} is an
integer between 0 and L - 1, where L is the number of levels of
{cmd:index()}.  By default, {it:#} is L - 1; that is, all elements of the
correlation matrix are estimated.  When {it:#} is 0, the correlation matrix is
assumed to be identity.  {opt group(grpvar)} is required if there are no
random effects in the model.

{phang3}
{cmd:unstructured,} {opt index(varname)} [{opt group(grpvar)}]
assumes that within-group errors have distinct correlations.  This
is the most general correlation structure in that no structure is
imposed on the correlation parameters.  {opt index(varname)} is required.
{opt group(grpvar)} is required if there are no random effects in the model.

{marker rescorropts}{...}
{phang2}
{it:rescorropts} are {opt index(varname)}, {opt t(timevar)}, {opt by(byvar)},
and {opt group(grpvar)}.

{phang3}
{opt index(varname)} is used within the {cmd:rescorrelation()}
option with {it:rescorr} {cmd:banded} or {cmd:unstructured}.  {it:varname} is
a nonnegative-integer-valued variable that identifies the observations within
the lowest-level groups (for example, {cmd:obsid}).  The groups may be
unbalanced in that different groups may have different {cmd:index()} values,
but you may not have repeated {cmd:index()} values within any particular
group.

{phang3}
{opt t(timevar)} is used within the {opt rescorrelation()} option
to specify a time variable for the {cmd:ar}, {cmd:ma}, {cmd:ctar1}, and
{cmd:toeplitz} structures.

{pmore3}
With {it:rescorr} {cmd:ar}, {cmd:ma}, and {cmd:toeplitz}, {it:timevar} is an
integer-valued time variable used to order the observations within the
lowest-level groups and to determine the lags between successive observations.
Any nonconsecutive time values will be treated as gaps.

{pmore3}
With {it:rescorr} {cmd:ctar1}, {it:timevar} is a real-valued time variable.

{phang3}
{opt by(byvar)} is used within the {opt rescorrelation()} option
and specifies that a set of distinct within-group error correlation parameters
be estimated for each category of {it:byvar}.  {it:byvar} must be
nonnegative-integer valued and constant within the lowest-level groups.

{phang3}
{opt group(grpvar)} is used to identify the lowest-level groups (panels)
when modeling within-group error correlation structures.  {it:grpvar} is a
nonnegative-integer-valued group membership variable.  This option lets
you model within-group error correlation structures at the lowest level of
your model hierarchy without having to include random effects at that level in
your model.  This is useful, for instance, when fitting nonlinear marginal or
population-averaged models that model the dependence between error terms
directly, without introducing random effects; see
{mansection ME menlRemarksandexamplesmenlexdial:example 19}.  In
the presence of random effects at other levels of hierarchy in your model,
{it:grpvar} is assumed to be nested within those levels.

{dlgtab:Time series}

{phang}
{opth tsorder(varname)} specifies the time variable that determines the time
order for time-series operators used in expressions; see
{mansection ME menlRemarksandexamplesTime-seriesoperators:{it:Time-series operators}}.
When you use time-series operators with {cmd:menl}, you must either
{helpb tsset} your data prior to executing {cmd:menl} or specify option
{cmd:tsorder()}.  When you specify {cmd:tsorder()}, {cmd:menl} uses the time
variable {it:varname} to create a new temporary variable that contains
consecutive integers, which determine the sort order of observations within
the lowest-level group.  {cmd:menl} also creates and uses the appropriate
panel variable based on the hierarchy of your model specification and the
estimation sample; see
{mansection ME menlRemarksandexamplesmenlphenobarb:example 17} and
{mansection ME menlRemarksandexamplesmenlquinidine:example 18}.

{marker tsidef}{...}
{phang}
{cmd:tsinit({c -(}}{it:name}{cmd::{c )-}=}<{it:resubexpr}>{cmd:)}
specifies an initial condition for the named expression {it:name} used with
the one-period lag operator, {cmd:L.{c -(}}{it:name}{cmd::{c )-}} or
{cmd:L1.{c -(}}{it:name}{cmd::{c )-}}, in the model specification.  {it:name}
can be the {it:depvar} or the name of a function of model parameters
previously defined in, for instance, option {cmd:define()}.  If you include the
lagged predicted mean function {cmd:L.{c )-}}{it:depvar}{cmd::{c )-}} or,
equivalently, {cmd:L._yhat} in your model, you must specify its initial
condition in {cmd:tsinit({c -(}}{it:depvar}{cmd::{c )-}=}...{cmd:)}.  The
initial condition can be expressed as a random-effects substitutable
expression,
{mansection ME menlRemarksandexamplesRandom-effectssubstitutableexpressions:<{it:resubexpr}>}.  Option {cmd:tsinit()} may be repeated.  Also see
{mansection ME menlRemarksandexamplesTime-seriesoperators:{it:Time-series operators}},
{mansection ME menlRemarksandexamplesmenlphenobarb:example 17},
and {mansection ME menlRemarksandexamplesmenlquinidine:example 18}.

{phang}
{opt tsmissing} specifies that observations containing system missing values
({cmd:.}) in {it:depvar} be retained in the computation when a lagged named
expression is used in the model specification.  Extended missing values in
{it:depvar} are excluded.  Both missing and nonmissing observations are used
to evaluate the predicted nonlinear mean function but only nonmissing
observations are used to evaluate the likelihood.  Observations containing
missing values in variables used in the model other than the dependent
variable are excluded.  This option is often used when subjects have
intermittent {it:depvar} measurements and the lagged predicted mean function,
{cmd:L.{c -(}}{it:depvar}{cmd::{c )-}} or {cmd:L._yhat}, is used in the model
specification.  Such models are common in pharmacokinetics; see
{mansection ME menlRemarksandexamplesmenlphenobarb:example 17} and
{mansection ME menlRemarksandexamplesmenlquinidine:example 18}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt variance}, the default, displays the random-effects and
within-group error parameter estimates as variances and covariances.

{phang}
{opt stddeviations} displays the random-effects and within-group error
parameter estimates as standard deviations and correlations.

{phang}
{opt noretable} suppresses the random-effects table from the output.

{phang}
{opt nofetable} suppresses the fixed-effects table from the output.

{phang}
{opt estmetric} displays all parameter estimates in one table using the metric
in which they are stored in {cmd:e(b)}.  Random-effects parameter estimates are
stored as log-standard deviations and hyperbolic arctangents of correlations.
Within-group error parameter estimates are stored as log-standard deviations
and, when applicable, as hyperbolic arctangents of correlations.  Note that
fixed-effects estimates are always stored and displayed in the same metric.

{phang}
{opt nolegend} suppresses the expression legend that appears before the
fixed-effects estimation table when functions of parameters or named
substitutable expressions are specified in the main equation or in the
{opt define()} options.

{phang}
{opt noheader} suppresses the output header, either at estimation or
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of
groups, average group size, minimum, and maximum) from the output header.

{phang}
{opt nostderr} prevents {opt menl} from calculating standard errors for the
estimated random-effects parameters, although standard errors are still
provided for the fixed-effects parameters.  Specifying this option will speed
up computation times.

{phang}
{opt lrtest} specifies to fit a reference nonlinear regression model
and to use this model in calculating a likelihood-ratio test, comparing the
nonlinear mixed-effects model with ordinary nonlinear regression.

{phang}
{opt notsshow} prevents {cmd:menl} from showing the key {cmd:ts} variables;
see {manhelp tsset TS}.

INCLUDE help displayopts_list

{dlgtab:EM options}

{pstd}
These options control the expectation-maximization (EM) iterations
that occur before estimation switches to the Lindstrom-Bates method.
EM is used to obtain starting values.

{phang}
{opt emiterate(#)} specifies the number of EM
iterations to perform.  The default is {cmd:emiterate(25)}.

{phang}
{opt emtolerance(#)} specifies the convergence tolerance for the
EM algorithm.  The default is {cmd:emtolerance(1e-10)}.  EM
iterations will be halted once the log (restricted) likelihood changes by a
relative amount less than {it:#}.  At that point, optimization switches to
the Lindstrom-Bates method.

{phang}
{opt emlog} specifies that the EM iteration log be shown.  The
EM iteration log is not displayed by default.

{dlgtab:Maximization}

{marker menlmaxopts}{...}
{phang}
{it:menlmaxopts}:
{opt iter:ate(#)},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance},
{opt pnlsopts()},
{opt lmeopts()},
[{cmd:no}]{opt log}.
The convergence is declared when either {cmd:tolerance()} or
{cmd:ltolerance()} is satisfied; see
{mansection ME menlMethodsandformulasstopping_rules:{it:Stopping rules}}
in {bf:[ME] menl} for details.

{pmore}
{it:menlmaxopts} control the maximization process of the Lindstrom-Bates, the
generalized nonlinear least-squares (GNLS), and the nonlinear least-squares
(NLS) algorithms.  The Lindstrom-Bates algorithm is the main optimization
algorithm used for nonlinear models containing random effects.  The GNLS
algorithm is used for the models without random effects but with non-i.i.d.
errors.  The NLS algorithm is used for the models without random effects and
with i.i.d. errors.  The Lindstrom-Bates and GNLS algorithms are alternating
algorithms -- they alternate between two optimization steps and thus support
options to control the overall optimization as well as the optimization of
each step.  The Lindstrom-Bates algorithm alternates between the penalized
least-squares (PNLS) and the linear mixed-effects (LME) optimization steps.
The GNLS algorithm alternates between the GNLS and ML or, if option {cmd:reml}
is used, REML steps.  Option {cmd:pnlsopts()} controls the PNLS and GNLS
steps, and option {cmd:lmeopts()} controls the LME and ML/REML steps.  The
other {it:menlmaxopts} control the overall optimization of the alternating
algorithms as well as the NLS optimization.

{phang2}
{opt iterate(#)} specifies the maximum number of iterations for the
alternating algorithms and the NLS algorithm.  One alternating iteration of
the Lindstrom-Bates algorithm involves {it:#}_pnls PNLS iterations as
specified in {opt pnlsopts()}'s {opt iterate()} suboption and {it:#}_lme LME
iterations as specified in {opt lmeopts()}'s {opt iterate()} suboption.
Similarly, one alternating iteration of the GNLS algorithm involves
{it:#}_gnls GNLS iterations and {it:#}_ml ML/REML iterations.  The default is
the number set using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.

{phang2}
{opt tolerance(#)} specifies the tolerance for the parameter vector in the
alternating algorithms and the NLS algorithm.  When the relative change in the
parameter vector from one (alternating) iteration to the next is less than or
equal to {opt tolerance()}, the parameter convergence is satisfied.  The
default is {cmd:tolerance(1e-6)}.

{phang2}
{opt ltolerance(#)} specifies the tolerance for the linearization log
likelihood of the Lindstrom-Bates algorithm and for the log likelihood of the
GNLS and NLS algorithms.  The linearization log likelihood is the log
likelihood from the LME optimization step in the last iteration.  When the
relative change in the log likelihood from one (alternating) iteration to the
next is less than or equal to {cmd:ltolerance()}, the log-likelihood
convergence is satisfied.  The default is {cmd:ltolerance(1e-7)}.

{phang2}
{opt nrtolerance(#)} and {opt nonrtolerance} control the tolerance for
the scaled gradient.

{phang3}
{opt nrtolerance(#)} specifies the tolerance for the scaled
gradient.  Convergence is declared when g(-H^{-1})g' is less than
{opt nrtolerance(#)}, where g is the gradient row vector and H is the
approximated Hessian matrix from the current iteration.  The default is
{cmd:nrtolerance(1e-5)}.

{phang3}
{opt nonrtolerance} specifies that the default
{opt nrtolerance()} criterion be turned off.

{phang3}
{opt nrtolerance(#)} and {opt nonrtolerance} are allowed only with the NLS
algorithm.

{phang2}
{opt pnlsopts(pnlsopts)} controls the PNLS optimization step of the
Lindstrom-Bates alternating algorithm and the GNLS optimization step of the
GNLS alternating algorithm.  {it:pnlsopts} include any of the following:
{opt iter:ate(#)}, {opt ltol:erance(#)}, {opt tol:erance(#)},
{opt nrtol:erance(#)}, and
{help menl##maximize_options_pnls:{it:maximize_options}}.
The convergence of this step within each alternating iteration is declared
when {opt nrtolerance()} and one of {opt tolerance()} or {opt ltolerance()}
are satisfied.  This option is not allowed with the NLS algorithm.

{phang3}
{opt iterate(#)} specifies the maximum number of iterations for the PNLS and
GNLS optimization steps of the alternating algorithms.  The default is
{cmd:iterate(5)}.

{phang3}
{opt ltolerance(#)} specifies the tolerance for the objective function in the
PNLS and GNLS optimization steps.  When the relative change in the objective
function from one PNLS or GNLS iteration to the next is less than or equal to
{opt ltolerance()}, the objective-function convergence is satisfied.  The
default is {cmd:ltolerance(1e-7)}.

{phang3}
{opt tolerance(#)} specifies the tolerance for the vector of fixed-effects
parameters.  When the relative change in the coefficient vector from one PNLS
or GNLS iteration to the next is less than or equal to {cmd:tolerance()}, the
parameter convergence criterion is satisfied.  The default is
{cmd:tolerance(1e-6)}.

{phang3}
{opt nrtolerance(#)} specifies the tolerance for the scaled gradient in the
PNLS and GNLS optimization steps.  Convergence is declared when g(-H^{-1})g'
is less than {opt nrtolerance(#)}, where g is the gradient row vector and H is
the approximated Hessian matrix from the current iteration.  The default is
{cmd:nrtolerance(1e-5)}.

{marker maximize_options_pnls}{...}
{phang3}
{it:maximize_options} are
[{cmd:no}]{opt log},
{opt tr:ace},
{opt showtol:erance}, 
{opt nonrtol:erance}; 
see {manhelp Maximize R}.

{phang2}
{opt lmeopts(lmeopts)} controls the LME optimization step of
the Lindstrom-Bates alternating algorithm and the ML/REML
optimization step of the GNLS alternating algorithm.
{it:lmeopts} include any of the following:
{opt iter:ate(#)}, {opt ltol:erance(#)}, {opt tol:erance(#)},
{opt nrtol:erance(#)}, and
{help menl##maximize_options_lme:{it:maximize_options}}.
The convergence of this step within each alternating iteration is declared
when {opt nrtolerance()} and one of {opt tolerance()} or {opt ltolerance()}
are satisfied.  This option is not allowed with the NLS algorithm.

{phang3}
{opt iterate(#)} specifies the maximum number of iterations for the LME and
ML/REML optimization steps of the alternating algorithms.  The default is
{cmd:iterate(5)}.

{phang3}
{opt ltolerance(#)} specifies the tolerance for the log likelihood in the LME
and ML/REML optimization steps.  When the relative change in the log
likelihood from one LME or ML/REML iteration to the next is less than or equal
to {cmd:ltolerance()}, the log-likelihood convergence is satisfied.  The
default is {cmd:ltolerance(1e-7)}.

{phang3}
{opt tolerance(#)} specifies the tolerance for the random-effects and
within-group error covariance parameters.  When the relative change in the
vector of parameters from one LME or ML/REML iteration to the next is less
than or equal to {opt tolerance()}, the convergence criterion for covariance
parameters is satisfied.  The default is {cmd:tolerance(1e-6)}.

{phang3}
{opt nrtolerance(#)} specifies the tolerance for the scaled gradient in the
LME and ML/REML optimization steps.  Convergence is declared when g(-H^{-1})g'
is less than {opt nrtolerance(#)}, where g is the gradient row vector and H is
the approximated Hessian matrix from the current iteration.  The default is
{cmd:nrtolerance(1e-5)}.

{marker maximize_options_lme}{...}
{phang3}
{it:maximize_options} are
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient}, 
{opt showstep}, 
{opt hess:ian},
{opt showtol:erance}, 
{opt nonrtol:erance}; 
see {manhelp Maximize R}.

{pmore}
[{cmd:no}]{opt log};
see {manhelp Maximize R}.

{pstd}
The following option is available with {opt menl} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse orange}{p_end}

{pstd}Fit a two-level model without covariates{p_end}
{phang2}{cmd:. menl circumf = ({b1}+{U1[tree]})/(1+exp(-(age-{b2})/{b3}))}

{pstd}Same as above, but use {cmd:define()} to simplify model specification and
highlight the 2-stage model formulation{p_end}
{phang2}{cmd:. menl circumf = {phi1:}/(1+exp(-(age-{b2})/{b3})),}
	{cmd:define(phi1:{b1}+{U1[tree]})}	

{pstd}Add a random intercept, {cmd: {U2[tree]}}, in the exponent and allow correlation between random intercepts {cmd:U1} and {cmd: U2}{p_end}
{phang2}{cmd:. menl circumf = {phi1:}/(1+exp(-(age-{phi2:})/{b3})),}
	   {cmd:define(phi1:{b1}+{U1[tree]})} {cmd:define(phi2:{b2}+{U2[tree]})}
	   {cmd:covariance(U1 U2, unstructured)}	

{pstd}Assume independent random intercepts {cmd:U1} and {cmd:U2}, and specify
a heteroskedastic within-subject error variance that varies as a power of
predicted mean values {cmd:_yhat}{p_end}
{phang2}{cmd:. menl circumf = {phi1:}/(1+exp(-(age-{phi2:})/{b3})),}
           {cmd:define(phi1:{b1}+{U1[tree]})} {cmd:define(phi2:{b2}+{U2[tree]})}
           {cmd:covariance(U1 U2, independent)}
	   {cmd:resvariance(power _yhat, noconstant)} 

{pstd}As above, but perform restricted maximum-likelihood estimation instead of
the default maximum-likelihood estimation{p_end}
{phang2}{cmd:. menl circumf = {phi1:}/(1+exp(-(age-{phi2:})/{b3})),}
{cmd:define(phi1:{b1}+{U1[tree]})} {cmd:define(phi2:{b2}+{U2[tree]})}
{cmd:covariance(U1 U2, independent) resvariance(power _yhat, noconstant) reml} 
   
{pstd}Display standard deviations and correlations instead of default variances
and covariances{p_end}
{phang2}{cmd:. menl, stddeviations}

{pstd}Fit a nonlinear marginal model with an exchangeable within-group error
covariance structure{p_end}
{phang2}{cmd:. menl circumf =}
        {cmd:{c -(}b1{c )-}/(1+exp(-(age-{c -(}b2{c )-})/{c -(}b3{c )-})),}
        {cmd:rescovariance(exchangeable, group(tree))}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse unicorn}{p_end}

{pstd}Fit a two-level model with covariates{p_end}
{phang2}{cmd:. menl weight = {phi1:}+({phi2}-{phi1:})*exp(-{phi3:}*time),}
          {cmd:define(phi1:{b10}+{b11}*1.female+{U0[id]})}
          {cmd:define(phi3:{b30}+{b31}*cupcake)}

{pstd}As above, but using efficient linear-combination specifications{p_end}
{phang2}{cmd:. menl weight = {phi1:}+({phi2}-{phi1:})*exp(-{phi3:}*time),}
          {cmd:define(phi1: i.female U0[id])}
	  {cmd:define(phi3: cupcake, xb)}

{pstd}Include a random slope on continuous variable {cmd: cupcake}, and specify and exchangeable covariance structure between random slope {cmd:U1} and random intercept {cmd:U0}{p_end}
{phang2}{cmd:. menl weight = {phi1:}+({phi2}-{phi1:})*exp(-{phi3:}*time),}
          {cmd:define(phi1: i.female U0[id])}
	  {cmd:define(phi3: cupcake c.cupcake#U1[id])}
 	  {cmd:covariance(U0 U1, exchangeable)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ovary}{p_end}

{pstd}Specify your own initial values for fixed effects{p_end}
{phang2}{cmd:. menl follicles = {phi1:}+{b1}*sin(2*_pi*stime*{b2})+{b3}*cos(2*_pi*stime*{b2}),}
{cmd:define(phi1: U1[mare], xb) initial(phi1:_cons 12.2 b1 -3.0 b2 1 b3 -.88, fixed)}

{pstd}As above, but specify an AR(1) covariance structure for the residuals instead of the default identity structure{p_end}
{phang2}{cmd:. menl follicles = {phi1:}+{b1}*sin(2*_pi*stime*{b2})+{b3}*cos(2*_pi*stime*{b2}),}
     {cmd:define(phi1: U1[mare], xb)}
     {cmd:initial(phi1:_cons 12.2 b1 -3.0 b2 1 b3 -.88, fixed)}
     {cmd:rescovariance(ar 1, t(time))}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse glucose}{p_end}

{pstd}Three-level model of {cmd:glucose} on {cmd:time} with random intercepts {cmd:U1} and {cmd:UU2} at the {cmd:subject} and {cmd:guar} levels, with {cmd:guar} nested within {cmd:subject}{p_end}
{phang2}{cmd:. menl glucose = {phi1:} + {phi2:}*c.time#c.time#c.time*exp(-{phi3:}*time),}
     {cmd:define(phi1: i.guar U1[subject])}
     {cmd:define(phi2: i.guar UU2[subject>guar])}
     {cmd:define(phi3: i.guar, xb)}

{pstd}As above, but specify a continuous-time AR(1) correlation structure for the residuals{p_end}
{phang2}{cmd:. menl glucose = {phi1:} + {phi2:}*c.time#c.time#c.time*exp(-{phi3:}*time),}
     {cmd:define(phi1: i.guar U1[subject])}
     {cmd:define(phi2: i.guar UU2[subject>guar])}
     {cmd:define(phi3: i.guar) rescorrelation(ctar1, t(time))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{opt menl} stores the following in {opt e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_nonmiss)}}number of nonmissing {it:depvar} observations, if
{cmd:tsmissing} is specified{p_end}
{synopt:{cmd:e(N_miss)}}number of missing {it:depvar} observations, if
{cmd:tsmissing} is specified{p_end}
{synopt:{cmd:e(N_ic)}}number of nonmissing {it:depvar} observations to be
used for BIC computation when {cmd:tsmissing} is specified{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_f)}}number of fixed-effects parameters{p_end}
{synopt:{cmd:e(k_r)}}number of random-effects parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(k_res)}}number of within-group error parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations{p_end}
{synopt:{cmd:e(k_feq)}}number of fixed-effects equations{p_end}
{synopt:{cmd:e(k_req)}}number of random-effects equations{p_end}
{synopt:{cmd:e(k_reseq)}}number of within-group error equations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom for comparison test{p_end}
{synopt:{cmd:e(ll)}}linearization log (restricted) likelihood{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:menl}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(varlist)}}variables used in the specified equation{p_end}
{synopt:{cmd:e(key_N_ic)}}{cmd:nonmissing obs}, if {cmd:tsmissing} is
specified{p_end}
{synopt:{cmd:e(tsmissing)}}{cmd:tsmissing}, if specified{p_end}
{synopt:{cmd:e(tsorder)}}{cmd:tsorder()} specification{p_end}
{synopt:{cmd:e(eq_}{it:depvar}{cmd:)}}user-specified equation{p_end}
{synopt:{cmd:e(tsinit_}{it:depvar}{cmd:)}}{cmd:tsinit()} specification for
{cmd:L.{c -(}}{it:depvar}{cmd::{c )-}}{p_end}
{synopt:{cmd:e(expressions)}}names of defined expressions, {it:expr_1},
{it:expr_2}, ..., {it:expr_k}{p_end}
{synopt:{cmd:e(expr_}{it:expr_i}{cmd:)}}defined expression {it:expr_i},
i=1, ..., k{p_end}
{synopt:{cmd:e(tsinit_}{it:expr}{cmd:)}}{cmd:tsinit()} specification for
{cmd:L.{c -(}}{it:expr}{cmd::{c )-}}{p_end}
{synopt:{cmd:e(hierarchy)}}random-effects hierarchy structure,
{cmd:(}{it:path}{cmd::}{it:covtype}{cmd::}{it:REs}{cmd:) (}...{cmd:)}{p_end}
{synopt:{cmd:e(revars)}}names of random effects{p_end}
{synopt:{cmd:e(rstructlab)}}within-group error covariance output label{p_end}
{synopt:{cmd:e(timevar)}}within-group error covariance {cmd:t()} variable, if
specified{p_end}
{synopt:{cmd:e(indexvar)}}within-group error covariance {cmd:index()}
variable, if specified{p_end}
{synopt:{cmd:e(covbyvar)}}within-group error covariance {cmd:by()} variable,
if specified{p_end}
{synopt:{cmd:e(stratavar)}}within-group error variance {cmd:strata()}
variable, if specified{p_end}
{synopt:{cmd:e(corrbyvar)}}within-group error correlation {cmd:by()} variable,
if specified{p_end}
{synopt:{cmd:e(rescovopt)}}within-group error covariance option, if
{cmd:rescovariance()} specified{p_end}
{synopt:{cmd:e(resvaropt)}}within-group error variance option, if
{cmd:resvariance()} specified{p_end}
{synopt:{cmd:e(rescorropt)}}within-group error correlation option, if
{cmd:rescorrelation()} specified{p_end}
{synopt:{cmd:e(groupvar)}}lowest-level {cmd:group()} variable, if
specified{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared
test{p_end}
{synopt:{cmd:e(vce)}}{cmd:conventional}{p_end}
{synopt:{cmd:e(method)}}{cmd:MLE} or {cmd:REML}{p_end}
{synopt:{cmd:e(opt)}}type of optimization, {cmd:lbates}{p_end}
{synopt:{cmd:e(crittype)}}optimization criterion{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {cmd:predict()} specification for
{cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}factor-variable constraint matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(b_sd)}}random-effects and within-group error estimates in the
standard deviation metric{p_end}
{synopt:{cmd:e(V_sd)}}VCE for parameters in the standard deviation
metric{p_end}
{synopt:{cmd:e(b_var)}}random-effects and within-group error estimates in the
variance metric{p_end}
{synopt:{cmd:e(V_var)}}VCE for parameters in the variance metric{p_end}
{synopt:{cmd:e(cov_}{it:#}{cmd:)}}random-effects covariance structure
at the hierarchical level k - {it:#} + 1 in a k-level model{p_end}
{synopt:{cmd:e(hierstats)}}group-size statistics for each hierarchy{p_end}

{p2col 5 23 25 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
