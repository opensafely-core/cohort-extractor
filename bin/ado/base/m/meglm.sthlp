{smcl}
{* *! version 1.2.9  17feb2020}{...}
{viewerdialog meglm "dialog meglm"}{...}
{viewerdialog "svy: meglm" "dialog meglm, message(-svy-) name(svy_meglm)"}{...}
{vieweralsosee "[ME] meglm" "mansection ME meglm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: meglm" "help bayes meglm"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "meglm##syntax"}{...}
{viewerjumpto "Menu" "meglm##menu"}{...}
{viewerjumpto "Description" "meglm##description"}{...}
{viewerjumpto "Links to PDF documentation" "meglm##linkspdf"}{...}
{viewerjumpto "Options" "meglm##options"}{...}
{viewerjumpto "Remarks" "meglm##remarks"}{...}
{viewerjumpto "Examples" "meglm##examples"}{...}
{viewerjumpto "Video example" "meglm##video"}{...}
{viewerjumpto "Stored results" "meglm##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ME] meglm} {hline 2}}Multilevel mixed-effects generalized linear model{p_end}
{p2col:}({mansection ME meglm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:meglm} {depvar} {it:fe_equation} [{cmd:||} {it:re_equation}]
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help meglm##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} [{it:{help meglm##weight:weight}}]
	[{cmd:,} {it:{help meglm##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help meglm##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable in a
	crossed-effects model

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 25 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the fixed-effects
equation{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient
constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(meglm##vartype:vartype)}}variance-covariance structure of the random effects{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects equation{p_end}
{synopt :{opth fw:eight(varname)}}frequency weights at higher levels{p_end}
{synopt :{opth iw:eight(varname)}}importance weights at higher levels{p_end}
{synopt :{opth pw:eight(varname)}}sampling weights at higher levels{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt :{cmdab:f:amily(}{it:{help meglm##family:family}}{cmd:)}}distribution
	of {depvar}; default is {cmd:family(gaussian)}{p_end}
{synopt :{opth l:ink(meglm##link:link)}}link function; default varies per family
{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, {cmdab:r:obust},
or {cmdab:cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt le:vel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt eform}}report exponentiated fixed-effects coefficients{p_end}
{synopt :{opt irr}}report fixed-effects coefficients as incidence-rate ratios{p_end}
{synopt :{opt or}}report fixed-effects coefficients as odds ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{it:{help meglm##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(meglm##intmethod:intmethod)}}integration method{p_end}
{synopt :{opt intp:oints(#)}}set the number of integration
(quadrature) points for all levels; default is {cmd:intpoints(7)}{p_end}

{syntab :Maximization}
{synopt :{it:{help meglm##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

INCLUDE help startval_table
{synopt :{opt dnumerical}}use numerical derivative techniques{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

INCLUDE help me_vartype_table

{marker family}{...}
{synoptset 25}{...}
{synopthdr :family}
{synoptline}
{synopt :{opt gau:ssian}}Gaussian (normal); the default{p_end}
{synopt :{opt be:rnoulli}}Bernoulli{p_end}
{synopt :{opt bi:nomial} [{it:#}|{varname}]}binomial; default number of
binomial trials is 1{p_end}
{synopt :{opt gam:ma}}gamma{p_end}
{synopt :{opt nb:inomial} [{cmd:mean}|{cmdab:cons:tant}]}negative binomial; default dispersion is {cmd:mean}{p_end}
{synopt :{opt o:rdinal}}ordinal{p_end}
{synopt :{opt p:oisson}}Poisson{p_end}
{synoptline}

{marker link}{...}
{synoptset 25}{...}
{synopthdr :link}
{synoptline}
{synopt :{opt iden:tity}}identity{p_end}
{synopt :{opt log}}log{p_end}
{synopt :{opt logit}}logit{p_end}
{synopt :{opt prob:it}}probit{p_end}
{synopt :{opt clog:log}}complementary log-log{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help me_intmethod_table

INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:by}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_meglm BAYES:bayes: meglm}.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; 
see {help weight}.  Only one type of weight may be specified.
Weights are not supported under the Laplacian
approximation or for crossed models.{p_end}
{p 4 6 2}
{opt startvalues()}, {opt startgrid}, {opt noestimate}, {opt dnumerical},
{opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp meglm_postestimation ME:meglm postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models >}
      {bf:Generalized linear model (GLM)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:meglm} fits multilevel mixed-effects generalized linear models.
{cmd:meglm} allows a variety of distributions for the response conditional on
normally distributed random effects.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME meglmQuickstart:Quick start}

        {mansection ME meglmRemarksandexamples:Remarks and examples}

        {mansection ME meglmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed-effects equation and for any of or all the
random-effects equations.

{phang}
{opth exposure:(varname:varname_e)} specifies a variable that reflects the
amount of exposure over which the {depvar} events were observed for each
observation; ln({it:varname_e}) is included in the fixed-effects portion of the
model with coefficient constrained to be 1. 

{phang}
{opth offset:(varname:varname_o)} specifies that {it:varname_o} be included in
the fixed-effects portion of the model with the coefficient constrained to be
1.

{phang}
{opt asis} forces retention of perfect predictor variables and their
associated, perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.

INCLUDE help me_vartype_opt

INCLUDE help me_weight_opt

{phang}
{cmd:family(}{cmd:{it:{help meglm##family:family}}}{cmd:)}
specifies the distribution of {depvar}; {cmd:family(gaussian)} is the default.

{phang}
{opth link:(meglm##link:link)} specifies the link function; the
default is the canonical link for the {cmd:family()} specified
except for the gamma and negative binomial families.

{pmore}
If you specify both {cmd:family()} and {cmd:link()}, not all combinations
make sense.  You may choose from the following combinations:

                          identity  log  logit  probit  cloglog
        {hline 60}
        Gaussian              D      x
        Bernoulli                          D       x       x
        binomial                           D       x       x
        gamma                         D
        negative binomial             D
        ordinal                            D       x       x
        Poisson                       D
        {hline 60}
	D denotes the default.

{phang}
{opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), and
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}); see
{helpb vce_option:[R] {it:vce_option}}.  If {cmd:vce(robust)} is specified,
robust variances are clustered at the highest level in the multilevel model.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt eform} reports exponentiated fixed-effects coefficients and
corresponding standard errors and confidence intervals.  This option
may be specified either at estimation or upon replay.

{phang}
{opt irr} reports estimated fixed-effects coefficients transformed to
incidence-rate ratios, that is, exp(b) rather than b.  Standard errors and
confidence intervals are similarly transformed.  This option affects how
results are displayed, not how they are estimated or stored.  {cmd:irr} may be
specified either at estimation or upon replay.  This option is allowed for
count models only.

{phang}
{opt or} reports estimated fixed-effects coefficients transformed to odds
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated.  {opt or} may be specified at
estimation or upon replay.  This option is allowed for logistic models only.

{phang}
{opt nocnsreport}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt notable} suppresses the estimation table, either at estimation or upon
replay.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

INCLUDE help displayopts_list

{dlgtab:Integration}

INCLUDE help me_integration_opt

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
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
Those that require special mention for {cmd:meglm}
are listed below.

{pmore}
{opt from()} accepts a properly labeled vector of initial values or a list of
coefficient names with values.  A list of values is not allowed.

{pstd}
The following options are available with {opt meglm} but are not shown in
the dialog box:

{marker startval}{...}
{marker startvalues()}{...}
{phang}
{opt startvalues(svmethod)} specifies how starting values are
to be computed.  Starting values specified in {cmd:from()} override the 
computed starting values. 

{pmore}
	{cmd:startvalues(zero)} specifies that starting values be set to 0. 

{pmore}
	{cmd:startvalues(constantonly)} builds on {cmd:startvalues(zero)} 
	by fitting a constant-only model to obtain estimates of the intercept
	and auxiliary parameters, and it substitutes 1 for the variances of
	random effects. 

{pmore}
	{cmd:startvalues(fixedonly}[{cmd:,} {opt iter:ate(#)}]{cmd:)} builds
	on {cmd:startvalues(constantonly)} by fitting a full fixed-effects
	model to obtain estimates of coefficients along with intercept and
	auxiliary parameters, and it continues to use 1 for the variances of
	random effects.  This is the default behavior. 
	{opt iterate(#)} limits the number of iterations for fitting the
	fixed-effects model.

{pmore}
	{cmd:startvalues(iv}[{cmd:,} {opt iter:ate(#)}]{cmd:)} builds on
	{cmd:startvalues(fixedonly)} by using instrumental-variable methods
	with generalized residuals to obtain variances of random effects. 
	{opt iterate(#)} limits the number of iterations for fitting the
	instrumental-variable model.

{pmore}
	{cmd:startvalues(}{opt iter:ate(#)}{cmd:)} limits the number of
	iterations for fitting the default model (fixed effects).

{marker startgrid()}{...}
{phang}
{cmd:startgrid}[{cmd:(}{it:gridspec}{cmd:)}] performs a grid search on
variance components of random effects to improve starting values.  No grid
search is performed by default unless the starting values are found to be not
feasible, in which case {cmd:meglm} runs {cmd:startgrid()} to perform a
"minimal" search involving q^3 likelihood evaluations, where q is the
number of random effects.  Sometimes this resolves the problem.  Usually,
however, there is no problem and {cmd:startgrid()} is not run by default.
There can be benefits from running {cmd:startgrid()} to get better starting
values even when starting values are feasible.

{pmore}
	{cmd:startgrid()} is a brute-force approach that tries various values
	for variances and covariances and chooses the ones that work best.
	You may already be using a default form of {cmd:startgrid()} without
	knowing it.  If you see {cmd:meglm} displaying Grid node 1, Grid node
	2, ... following Grid node 0 in the iteration log, that is
	{cmd:meglm} doing a default search because the original starting
	values were not feasible.  The default form tries 0.1, 1, and 10 for
	all variances of all random effects. 

{pmore}
	{opth startgrid(numlist)} specifies values to try for
	variances of random effects.

{pmore}
	{opt startgrid(covspec)} specifies the particular variances and
	covariances in which grid searches are to be performed.
	{it:covspec} is {it:name}{cmd:[}{it:level}{cmd:]} for variances and
	{it:name1}{cmd:[}{it:level}{cmd:]*}{it:name2}{cmd:[}{it:level}{cmd:]}
	for covariances.
	For example, the variance of the random intercept at level {cmd:id} is
	specified as {cmd:_cons[id]}, and
	the variance of the random slope on variable {cmd:week} at the same
	level is specified as {cmd:week[id]}.
	The residual variance for the linear mixed-effects model is specified
	as {cmd:e.}{it:depvar}, where {it:depvar} is the name of the
	dependent variable.
	The covariance between the random slope and the random intercept above
	is specified as {cmd:_cons[id]*week[id]}.
	
{pmore}
	{opt startgrid(numlist covspec)} combines the
	two syntaxes.  You may also specify {cmd:startgrid()} multiple times 
	so that you can search the different ranges for different variances
	and covariances.

{phang} 
{cmd:noestimate} specifies that the model is not to be fit.  Instead, 
starting values are to be shown (as modified by the above options
if modifications were made), and they are to be shown using 
the {cmd:coeflegend} style of output.

{phang}
{opt dnumerical} specifies that during optimization, the gradient vector and
Hessian matrix be computed using numerical techniques instead of analytical
formulas.  By default, analytical formulas for computing the gradient and
Hessian are used for all integration methods except {cmd:intmethod(laplace)}.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help meglm##remarks1:Remarks on distributional families}{p_end}
{phang2}{help meglm##sampling:Remarks on using sampling weights}{p_end}


{marker remarks1}{...}
{title:Remarks on distributional families}

{pstd}
Some combinations of families and links are so common that we
implemented them as separate commands in terms of {cmd:meglm}.

        Command           {cmd:meglm} equivalent
        {hline 60}
        {cmd:melogit}      {cmd:family(bernoulli) link(logit)}
        {cmd:meprobit}     {cmd:family(bernoulli) link(probit)}
        {cmd:mecloglog}    {cmd:family(bernoulli) link(cloglog)}
        {cmd:meologit}     {cmd:family(ordinal) link(logit)}
        {cmd:meoprobit}    {cmd:family(ordinal) link(probit)}
        {cmd:mepoisson}    {cmd:family(poisson) link(log)}
        {cmd:menbreg}      {cmd:family(nbinomial) link(log)}
        {hline 60}

{pstd}
When no family-link combination is specified, {cmd:meglm} defaults to a
Gaussian family with an identity link.  Thus {cmd:meglm} can be used to fit
linear mixed-effects models; however, for those models we recommend using the
more specialized {cmd:mixed}, which, in addition to {cmd:meglm} capabilities,
allows for modeling of the structure of the residual errors;
see {helpb mixed:[ME] mixed} for details.


{marker sampling}{...}
INCLUDE help me_weight_remarks


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}

{pstd}Mixed-effects GLM with the default Gaussian family and identity link{p_end}
{phang2}{cmd:. meglm weight week || id:}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}

{pstd}Three-level model with bernoulli family and default logit link{p_end}
{phang2}{cmd:. meglm dtlm difficulty i.group || family: || subject:, family(bernoulli)}{p_end}

{pstd}Same as above but with a probit link{p_end}
{phang2}{cmd:. meglm dtlm difficulty i.group || family: || subject:, family(bernoulli) link(probit)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use https://www.stata-press.com/data/mlmus3/schiz}{p_end}
{phang2}{cmd:. generate impso = imps}{p_end}
{phang2}{cmd:. recode impso -9=. 1/2.4=1 2.5/4.4=2 4.5/5.4=3 5.5/7=4}{p_end}

{pstd}Two-level GLM with ordinal family and default logit link{p_end}
{phang2}{cmd:. meglm impso week treatment || id:, family(ordinal)}{p_end}

{pstd}Same as above but with a probit link{p_end}
{phang2}{cmd:. meglm impso week treatment || id:, family(ordinal) link(probit)}{p_end}

{pstd}Same as above but with a cloglog link{p_end}
{phang2}{cmd:. meglm impso week treatment || id:, family(ordinal) link(cloglog)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse melanoma, clear}{p_end}

{pstd}Three-level random-intercept Poisson model{p_end}
{phang2}{cmd:. meglm deaths uv, exposure(expected) || nation: || region:, family(poisson)}{p_end}

{pstd}Same as above but a negative binomial model{p_end}
{phang2}{cmd:. meglm deaths uv, exposure(expected) || nation: || region:, family(nbinomial)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use https://www.stata-press.com/data/mlmus3/drvisits}{p_end}
{phang2}{cmd:. keep if numvisit > 0}{p_end}

{pstd}Two-level random-intercept and random-coefficient gamma model{p_end}
{phang2}{cmd:. meglm numvisit reform age married loginc || id: reform, family(gamma)}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=SbwApki_BnI&feature=youtu.be":Tour of multilevel GLMs}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meglm} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_cat)}}number of categories (with ordinal outcomes){p_end}
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
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:meglm}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}{cmd:fweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(iweight}{it:k}{cmd:)}}{cmd:iweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}{cmd:pweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(model)}}name of marginal model{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(link)}}link{p_end}
{synopt:{cmd:e(family)}}family{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(binomial)}}binomial number of trials (with binomial models){p_end}
{synopt:{cmd:e(dispersion)}}{cmd:mean} or {cmd:constant} (with negative binomial models){p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(cat)}}category values (with ordinal outcomes){p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
