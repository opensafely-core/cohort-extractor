{smcl}
{* *! version 1.2.25  21aug2018}{...}
{viewerdialog suest "dialog suest"}{...}
{vieweralsosee "[R] suest" "mansection R suest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[R] hausman" "help hausman"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[P] _robust" "help _robust"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{viewerjumpto "Syntax" "suest##syntax"}{...}
{viewerjumpto "Menu" "suest##menu"}{...}
{viewerjumpto "Description" "suest##description"}{...}
{viewerjumpto "Links to PDF documentation" "suest##linkspdf"}{...}
{viewerjumpto "Options" "suest##options"}{...}
{viewerjumpto "Remarks" "suest##remarks"}{...}
{viewerjumpto "Examples" "suest##examples"}{...}
{viewerjumpto "Stored results" "suest##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] suest} {hline 2}}Seemingly unrelated estimation{p_end}
{p2col:}({mansection R suest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:suest}
{it:namelist}
[{cmd:,}
{it:options}]

{phang}
where {it:namelist} is a list of one or more names under which
estimation results were stored via {helpb estimates store:estimates store}.
Wildcards may be used.  {opt *} and {opt _all} refer to all stored
results.  A period ({cmd:.}) may be used to refer to the last
estimation results, even if they have not (yet) been stored.
{p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:SE/Robust}
{synopt:{opt svy}}survey data estimation{p_end}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust} or
  {opt cl:uster} {it:clustvar}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}
{synopt:{opt d:ir}}display a table describing the models
{p_end}
{synopt:{opth ef:orm(strings:string)}}report exponentiated coefficients and label as {it:string}{p_end}
{synopt :{it:{help suest##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{opt suest} is a postestimation command; see {help estcom} and {help postest}.

{pstd}
{opt suest} combines the estimation results -- parameter estimates
and associated (co)variance matrices -- stored under {it:namelist} into
one parameter vector and simultaneous (co)variance matrix of the
sandwich/robust type.  This (co)variance matrix is appropriate even if
the estimates were obtained on the same or on overlapping data.

{pstd}
Typical applications of {opt suest} are tests for intramodel and cross-model
hypotheses using {cmd:test} or {cmd:testnl}, for example, a generalized
Hausman specification test.  {cmd:lincom} and {cmd:nlcom} may be used
after {opt suest} to estimate linear combinations and nonlinear functions of
coefficients.  {opt suest} may also be used to adjust a standard VCE for
clustering or survey design effects.

{pstd}
Different estimators are allowed, for example, a {cmd:regress} model
and a {cmd:probit} model; the only requirement is that {cmd:predict}
produce equation-level scores with the {opt score} option after an estimation
command.  The models may be estimated
on different samples, due either to explicit {opt if} or {opt in} selection or 
to missing values.  If weights are applied, the same weights (type and
values) should be applied to all models in {it:namelist}.  The estimators
should be estimated without {cmd:vce(robust)} or {cmd:vce(cluster}
{it:clustvar}{cmd:)} options.
{cmd:suest} returns the robust VCE, allows the {cmd:vce(cluster}
{it:clustvar}{cmd:)} option, and automatically works with results from the
{cmd:svy} prefix command (only for {cmd:vce(linearized)}).  See
{mansection SVY svypostestimationRemarksandexamplesex7:example 7} in
{manlink SVY svy postestimation} for an example using {cmd:suest} with
{cmd:svy: ologit}.

{pstd}
Because {opt suest} posts its results like a proper estimation command, its
results can be stored via {helpb estimates store}.  Moreover, like other
estimation commands, {cmd:suest} typed without arguments replays the results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R suestQuickstart:Quick start}

        {mansection R suestRemarksandexamples:Remarks and examples}

        {mansection R suestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:SE/Robust}

{phang}
{opt svy}
specifies that estimation results should be modified to reflect the survey
design effects according to the {cmd:svyset} specifications;
see {manhelp svyset SVY}.

{pmore}
The {opt svy} option is implied when {cmd:suest} encounters
survey estimation results from the {helpb svy} prefix. Poststratification is
allowed only with survey estimation results from the {cmd:svy} prefix.

INCLUDE help vce_rc

{pmore}
The {opt vce()} option may not be combined with the {opt svy} option or
estimation results from the {cmd:svy} prefix.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for 
confidence intervals of the coefficients; see {manhelp level R}.

{phang}
{opt dir} displays a table describing the models in {it:namelist}
just like {cmd:estimates dir} {it:namelist}.

{phang}
{opth eform:(strings:string)}
displays the coefficient table in
exponentiated form:  for each coefficient, exp(b) rather than b is displayed,
and standard errors and confidence intervals are transformed.
{it:string} is the table header that will be
displayed above the transformed coefficients and must be 11 characters or
fewer, for example, {cmd:eform("Odds ratio")}.

INCLUDE help displayopts_list

{pstd}
The following option is available with {opt suest} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help suest##remarks1:Using suest}
        {help suest##remarks2:Using suest with survey data}
        {help suest##remarks3:Remarks on specific commands}


{marker remarks1}{...}
{title:Using suest}

{pstd}
If you plan to use {opt suest}, you must take precautions
when fitting the original models.  These restrictions are relaxed when using
survey data; see {help suest##survey_data:{it:Using suest with survey data}}
below.

{phang2}1.  
	  {opt suest} works with estimation commands that allow {cmd:predict}
	  to generate equation-level score variables when supplied
	  with the {opt score} (or {opt scores}) option.  For example,
	  equation-level score variables are generated after running
	  {cmd:mlogit} by typing

{pin3}  {cmd:. predict sc*, scores}

{phang2}2.  
	Estimation should take place without the {cmd:vce(robust)} or
	{cmd:vce(cluster} {it:clustvar}{cmd:)} options.  {opt suest} always
	computes the robust estimator of the (co)variance, and {opt suest} has
        a {cmd:vce(cluster} {it:clustvar}{cmd:)} option.

{pmore2}The within-model covariance matrices computed by {opt suest} are
	identical to those obtained by specifying a {cmd:vce(robust)} or
	{cmd:vce(cluster} {it:clustvar}{cmd:)} option during estimation.
	{opt suest}, however, also estimates the between-model covariances
	of parameter estimates.

{phang2}3.  
	Finally, the estimation results to be combined should be stored by
	{cmd:estimates store}; see 
	{helpb estimates store:[R] estimates store}.

{pstd}
After estimating and storing a series of estimation results, you
are ready to combine the estimation results with suest,

{p 8 16 2}
{cmd:. suest} {it:name1} [{it:name2} ...] [{cmd:,} {cmd:vce(cluster}
{it:clustvar}{cmd:)}]

{pstd}
and you can subsequently use postestimation commands, such as {cmd:test},
to test hypotheses.  Here an important issue is how {opt suest} assigns names
to the equations.  If you specify one model {it:name}, the original equation
names are left unchanged; otherwise, {opt suest} constructs new equation
names.  The coefficients of a single-equation model (such as {cmd:logit} and
{cmd:poisson}) that was {cmd:estimate store}d under name {it:X} are
collected under equation {it:X}.  With a multiequation model stored under name
{it:X}, {opt suest} prefixes {it:X}{cmd:_} to an original equation name
{it:eq}, forming equation name {bind:{it:X}{cmd:_}{it:eq}}.

{pstd}
Technical note: in rare circumstances,
{opt suest} may have to truncate equation names to 32
characters. When equation names are not unique because of truncation, {opt suest}
numbers the equations within models, using equations named {it:X_#}.


{marker remarks2}{...}
{marker survey_data}{...}
{title:Using suest with survey data}

{pstd}
{opt suest} can be used to obtain the variance estimates for a series of
estimators that used the {helpb svy} prefix.  To use {opt suest} for this
purpose, perform the following steps:

{phang2}1.  Be sure to set the survey design characteristics correctly using
	{helpb svyset}.  Do not use the {opt vce()} option to change the
	default variance estimator from the linearized variance estimator.
	{cmd:vce(brr)} and {cmd:vce(jackknife)} are not supported by 
	{opt suest}.

{phang2}2.  Fit the model or models by using the {cmd:svy} prefix command,
	optionally including the subpopulation with the {opt subpop()} option.
	
{phang2}3.  Store the estimation results with {cmd:estimates store} {it:name}.

{phang2}4.  Use {cmd:suest} with {it:name}.


{marker remarks3}{...}
{title:Remarks on specific commands}

{p 4 4 2}Some estimation commands store or name their results in a slightly
nonstandard way, mostly for historical reasons.  {cmd:suest} provides
"fixes" in these cases.

{phang}{helpb regress} does not include its ancillary parameter, the residual
variance, in its coefficient vector and (co)variance matrix.  Moreover, while
the {opt score} option is allowed with {cmd:predict} after {cmd:regress},
a score variable is generated for the mean but not for the variance parameter.
{cmd:suest} contains special code that assigns the equation name {cmd:mean} to
the coefficients for the mean, adds the equation {cmd:lnvar} for the
log variance, and computes the appropriate score variables.


{marker examples}{...}
{title:Example 1: A Hausman test}

{phang}{cmd:. webuse sysdsn4}{p_end}
{phang}{cmd:. mlogit insure age male}{p_end}
{phang}{cmd:. estimates store m1, title(all three insurance forms)}{p_end}

{phang}{cmd:. quietly mlogit insure age male if insure != "Uninsure":insure}
{p_end}
{phang}{cmd:. estimates store m2, title(insure != "Uninsure":insure)}{p_end}

{phang}{cmd:. quietly mlogit insure age male if insure != "Prepaid":insure}
{p_end}
{phang}{cmd:. estimates store m3, title(insure != "Prepaid":insure)}{p_end}

{phang}{cmd:. hausman m2 m1, alleqs constant}{p_end}
{phang}{cmd:. hausman m3 m1, alleqs constant}{p_end}


{title:Example 2: Do coefficients vary between groups? ("Chow test")}

{phang}{cmd:. webuse income}{p_end}
{phang}{cmd:. regress inc edu exp if male}{p_end}
{phang}{cmd:. estimates store Male}{p_end}

{phang}{cmd:. regress inc edu exp if !male}{p_end}
{phang}{cmd:. estimates store Female}{p_end}

{phang}{cmd:. suest Male Female}{p_end}
{phang}{cmd:. test [Male_mean = Female_mean]}


{title:Example 3: A nonlinear Hausman-like test}

{phang}{cmd:. webuse income}{p_end}
{phang}{cmd:. probit promo edu exp}{p_end}
{phang}{cmd:. estimates store Promo}{p_end}

{phang}{cmd:. regress inc edu exp}{p_end}
{phang}{cmd:. estimates store Inc}{p_end}

{phang}{cmd:. suest Promo Inc}{p_end}
{phang}{cmd:. testnl [Promo_promo]edu/[Promo_promo]exp = [Inc_mean]edu/[Inc_mean]exp}


{title:Example 4: Using suest with survey data, the svy prefix}

{phang}{cmd:. webuse nhanes2f}{p_end}
{phang}{cmd:. svyset psuid [pw=finalwgt], strata(stratid)}{p_end}
{phang}{cmd:. svy: ologit health female black age age2}{p_end}
{phang}{cmd:. estimates store H5}{p_end}

{phang}{cmd:. gen health3 = clip(health,2,4)}{p_end}
{phang}{cmd:. svy: ologit health3 female black age age2}{p_end}
{phang}{cmd:. estimates store H3}{p_end}

{phang}{cmd:. suest H5 H3}{p_end}
{phang}{cmd:. test [H5_health=H3_health3]}{p_end}
{phang}
{cmd:. test ([/H5:cut2]=[/H3:cut1]) ([/H5:cut3]=[/H3:cut2])}
{p_end}


{title:Example 5: Using suest with survey data, the svy option}

{phang}{cmd:. webuse nhanes2f, clear}{p_end}
{phang}{cmd:. svyset psuid [pw=finalwgt], strata(stratid)}{p_end}
{phang}{cmd:. ologit health female black age age2 [iw=finalwgt]}{p_end}
{phang}{cmd:. estimates store H5}{p_end}

{phang}{cmd:. gen health3 = clip(health,2,4)}{p_end}
{phang}{cmd:. ologit health3 female black age age2 [iw=finalwgt]}{p_end}
{phang}{cmd:. estimates store H3}{p_end}

{phang}{cmd:. suest H5 H3, svy}{p_end}
{phang}{cmd:. test [H5_health=H3_health3]}{p_end}
{phang}{cmd:. test ([/H5:cut2]=[/H3:cut1]) ([/H5:cut3]=[/H3:cut2])}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:suest} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:suest}{p_end}
{synopt:{cmd:e(eqnames}{it:#}{cmd:)}}original names of equations of model {it:#}
{p_end}
{synopt:{cmd:e(names)}}list of model names{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}stacked coefficient vector of the models{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
