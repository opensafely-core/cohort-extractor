{smcl}
{* *! version 1.0.2  17feb2020}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta summarize" "mansection META metasummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta forestplot" "help meta forestplot"}{...}
{vieweralsosee "[META] meta regress" "help meta regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_summarize##syntax"}{...}
{viewerjumpto "Menu" "meta_summarize##menu"}{...}
{viewerjumpto "Description" "meta_summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_summarize##linkspdf"}{...}
{viewerjumpto "Options" "meta_summarize##options"}{...}
{viewerjumpto "Examples" "meta_summarize##examples"}{...}
{viewerjumpto "Stored results" "meta_summarize##results"}{...}
{viewerjumpto "References" "meta_summarize##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[META] meta summarize} {hline 2}}Summarize meta-analysis data{p_end}
{p2col:}({mansection META metasummarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Meta-analysis as declared with meta set or meta esize

{p 8 16 2}
{cmd:meta} {cmdab:sum:marize}
{ifin} [{cmd:,} {help meta_summarize##optstbl:{it:options}}
                {help meta_summarize##reopts:{it:reopts}}]


{pstd}
Random-effects meta-analysis

{p 8 16 2}
{cmd:meta} {cmdab:sum:marize}
{ifin}{cmd:,}
{cmd:random}[{cmd:(}{help meta_summarize##remethod:{it:remethod}}{cmd:)}]
           [{help meta_summarize##optstbl:{it:options}}
                {help meta_summarize##reopts:{it:reopts}}]


{pstd}
Common-effect meta-analysis

{p 8 16 2}
{cmd:meta} {cmdab:sum:marize}
{ifin}{cmd:,}
{cmd:common}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}]
           [{help meta_summarize##optstbl:{it:options}}]


{pstd}
Fixed-effects meta-analysis

{p 8 16 2}
{cmd:meta} {cmdab:sum:marize}
{ifin}{cmd:,}
{cmd:fixed}[{cmd:(}{help meta_summarize##cefemethod:{it:cefemethod}}{cmd:)}]
           [{help meta_summarize##optstbl:{it:options}}]


{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opth subgr:oup(varlist)}}subgroup meta-analysis for each variable in {it:varlist}{p_end}
{synopt :{opth cumul:ative(meta_summarize##cumulspec:cumulspec)}}cumulative meta-analysis{p_end}
{synopt :{cmd:sort(}{help meta_summarize##sortspec:{it:varlist}[{bf:,} ...]}{cmd:)}}sort studies according to
{it:varlist}{p_end}

{syntab:Options}
{synopt :{opt l:evel(#)}}set confidence level; default is as declared for meta-analysis{p_end}
{synopt :{help meta_summarize##eform_option:{it:eform_option}}}report exponentiated results{p_end}
INCLUDE help meta_transfopt
{synopt :{opt tdist:ribution}}report t test instead of z test for the overall effect size{p_end}
{synopt :{opt nostud:ies}}suppress output for individual studies{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}
{synopt :{help meta_summarize##dispopts:{it:display_options}}}control column formats{p_end}

{syntab:Maximization}
{synopt :{help meta_summarize##maxopts:{it:maximize_options}}}control the maximization process; seldom used{p_end}
{synoptline}

{synoptset 22}{...}
INCLUDE help meta_remethod

INCLUDE help meta_cefemethod

{marker reopts}{...}
{synopthdr:reopts}
{synoptline}
{synopt :{opt tau2(#)}}sensitivity meta-analysis using a fixed value of between-study variance τ^2{p_end}
{synopt :{opt i2(#)}}sensitivity meta-analysis using a fixed value of heterogeneity statistic I^2{p_end}
{synopt :{opt predint:erval}[{cmd:(}{it:#}{cmd:)}]}report prediction interval for the overall effect size{p_end}
{synopt :{opth se:(meta_summarize##seadj:seadj)}}adjust standard error of the overall effect size{p_end}
{synoptline}


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta summarize} summarizes
{help meta_glossary##meta_data:{bf:meta} data}.  It reports individual effect
sizes and the overall effect size (ES), their confidence intervals (CIs),
heterogeneity statistics, and more.  {cmd:meta summarize} can perform
random-effects (RE), common-effect (CE), and fixed-effects (FE) meta-analyses.
It can also perform subgroup, cumulative, and sensitivity meta-analyses.  For
graphical display of meta-analysis summaries, see
{helpb meta_forestplot:[META] meta forestplot}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metasummarizeQuickstart:Quick start}

        {mansection META metasummarizeRemarksandexamples:Remarks and examples}

        {mansection META metasummarizeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{pstd}
Options {cmd:random()}, {cmd:common()}, and {cmd:fixed()}, when specified with
{cmd:meta summarize}, temporarily override the global model declared by
{helpb meta set} or {helpb meta esize} during the computation.  Options
{cmd:random()}, {cmd:common()}, and {cmd:fixed()} may not be combined.  If
these options are omitted, the declared meta-analysis model is assumed; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  Also see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
in {bf:[META] Intro}.

{phang}
{opt random} and {opt random(remethod)} specify that a random-effects model be
assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesRandom-effectsmodel:{it:Random-effects model}}
in {bf:[META] Intro}.

{marker remethoddes}{...}
{phang2}
{it:remethod} specifies the type of estimator for the between-study variance
τ^2.  {it:remethod} is one of {cmd:reml}, {cmd:mle}, {cmd:ebayes},
{cmd:dlaird}, {cmd:sjonkman}, {cmd:hedges}, or {cmd:hschmidt}.  {cmd:random} is
a synonym for {cmd:random(reml)}.  See
{help meta_esize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{cmd:common} and {opth common:(meta_summarize##ccefemethoddes:cefemethod)}
specify that a common-effect model be assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{pmore}
{cmd:common} implies {cmd:common(mhaenszel)} for effect sizes {cmd:lnoratio},
{cmd:lnrratio}, and {cmd:rdiff} and {cmd:common(invvariance)} for all other
effect sizes.  {cmd:common(mhaenszel)} is supported only with effect sizes
{cmd:lnoratio}, {cmd:lnrratio}, and {cmd:rdiff}.

{marker ccefemethoddes}{...}
{phang2}
{it:cefemethod} is one of {cmd:mhaenszel} or {cmd:invvariance} (synonym
{cmd:ivariance}).  See {help meta_summarize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{cmd:fixed} and {opth fixed:(meta_summarize##fcefemethoddes:cefemethod)}
specify that a fixed-effects model be assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  Also see the
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{pmore}
{cmd:fixed} implies {cmd:fixed(mhaenszel)} for effect sizes {cmd:lnoratio},
{cmd:lnrratio}, and {cmd:rdiff} and {cmd:fixed(invvariance)} for all other
effect sizes.  {cmd:fixed(mhaenszel)} is supported only with effect sizes
{cmd:lnoratio}, {cmd:lnrratio}, and {cmd:rdiff}.

{marker fcefemethoddes}{...}
{phang2}
{it:cefemethod} is one of {cmd:mhaenszel} or {cmd:invvariance} (synonym
{cmd:ivariance}).  See {help meta_summarize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{opth subgroup(varlist)} specifies that a subgroup meta-analysis (subgroup
analysis) be performed for each variable in {it:varlist}.  Subgroup analysis
performs meta-analysis separately for each variable in {it:varlist} and for each
group as defined by that variable.  The specified meta-analysis model is
assumed for each subgroup.  This analysis is useful when the results of all
studies are too heterogeneous to be combined into one estimate but the results
are similar within certain groups of studies.  The specified variables can be
numeric or string variables.  When multiple variables are specified, only the
subgroup results are displayed; that is, the results from individual studies
are suppressed for brevity.  Only one of {cmd:subgroup()} or
{cmd:cumulative()} may be specified.

{marker cumulspec}{...}
{phang}
{cmd:cumulative(}{it:ordervar}[{cmd:,} {cmdab:asc:ending}{c |}{cmdab:desc:ending} {opt by(byvar)}]{cmd:)}
performs a cumulative meta-analysis (CMA).  CMA performs multiple
meta-analyses and accumulates the results by adding one study at a time to
each subsequent analysis.  It is useful for monitoring the results of the
studies as new studies become available.  The studies enter the CMA based on
the ordered values of variable {it:ordervar}.  {it:ordervar} must be a numeric
variable.  By default, ascending order is assumed unless the suboption
{cmd:descending} is specified; only one of {cmd:ascending} or {cmd:descending}
is allowed.  The {opt by(byvar)} option specifies that the CMA be stratified
by variable {it:byvar}.

{marker sortspec}{...}
{phang}
{cmd:sort(}{varlist}[{cmd:,} {opt asc:ending} | {opt desc:ending}]{cmd:)}
sorts the studies in ascending or descending order based on values of the
variables in {it:varlist}.  This option is useful if you want to sort the
studies in the output by effect sizes, {cmd:sort(_meta_es)}, or by
precision, {cmd:sort(_meta_se)}.  By default, ascending order is assumed
unless the suboption {cmd:descending} is specified; only one of
{cmd:ascending} or {cmd:descending} is allowed.  {it:varlist} may contain
string and numeric variables.  This option is not allowed with
{cmd:cumulative()}.  When {cmd:sort()} is not specified, the order of the
studies in the output is based on the ascending values of variable
{cmd:_meta_id}, which is equivalent to {cmd:sort(_meta_id)}.

{marker reoptsdes}{...}
{phang}
{it:reopts} are {opt tau2(#)}, {opt i2(#)},
{opt predinterval}[{cmd:(}{it:#}{cmd:)}], and
{cmd:se(}{cmd:khartung}[{cmd:, truncated}]{cmd:)}.
These options are used with random-effects meta-analysis.

{phang2}
{opt tau2(#)} specifies the value of the between-study variance parameter, τ^2,
to use for the random-effects meta-analysis.  This option is useful for
exploring the sensitivity of the results to different levels of between-study
heterogeneity.  Only one of {cmd:tau2()} or {cmd:i2()} may be specified.  This
option is not allowed in combination with {cmd:subgroup()} or
{cmd:cumulative()}.

{phang2}
{opt i2(#)} specifies the value of the heterogeneity statistic I^2 (as
a percentage) to use for the random-effects meta-analysis.  This option is
useful for exploring the sensitivity of the results to different levels of
between-study heterogeneity.  Only one of {cmd:i2()} or {cmd:tau2()} may be
specified.  This option is not allowed in combination with {cmd:subgroup()} or
{cmd:cumulative()}.

{phang2}
{cmd:predinterval} and {opt predinterval(#)} specify that the 95% or {it:#}%
{help meta_glossary##prediction_interval:prediction interval} be reported for
the overall effect size in addition to the confidence interval.  {it:#}
specifies the confidence level of the prediction interval.  The prediction
interval provides plausible ranges for the effect size in a future, new study.

{marker seadj}{...}
{phang2}
{opt se(seadj)} specifies that the adjustment {it:seadj} be applied to the
standard error of the overall effect size.  Additionally, the test of
significance of the overall effect size is based on a Student's t distribution
instead of the normal distribution.

{phang3}
{it:seadj} is {opt kh:artung}[{cmd:,} {opt trunc:ated}].  Adjustment
{cmd:khartung} specifies that the Knapp–Hartung adjustment
({help meta_summarize##hartungknapp2001a:Hartung and Knapp 2001a},
{help meta_summarize##hartungknapp2001b:2001b};
{help meta_summarize##knapphartung2003:Knapp and Hartung 2003}),
also known as the Sidik–Jonkman adjustment
({help meta_summarize##sidikjonkman2002:Sidik and Jonkman 2002}),
be applied to the standard error of the overall effect size.  {cmd:hknapp} and
{cmd:sjonkman} are synonyms for {cmd:khartung}.  {cmd:truncated} specifies that
the truncated Knapp–Hartung adjustment
{help meta_summarize##knapphartung2003:Knapp and Hartung 2003}),
also known as the modified Knapp–Hartung adjustment, be used.

{dlgtab:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is as declared for the meta-analysis session; see
{mansection META metadataRemarksandexamplesDeclaringaconfidencelevelformeta-analysis:{it:Declaring a confidence level for meta-analysis}}
in {bf:[META] meta data}.  Also see option
{helpb meta_set##level:level()} in {helpb meta_set:[META] meta set}.

{marker eform_option}{...}
{phang}
{it:eform_option} is one of {cmd:eform}, {opt eform(string)}, {cmd:or}, or
{cmd:rr}.  It reports exponentiated effect sizes and transforms their
respective confidence intervals, whenever applicable.  By default, the results
are displayed in the metric declared with {cmd:meta set} or {cmd:meta esize}
such as log odds-ratios and log risk-ratios.  {it:eform_option} affects how
results are displayed, not how they are estimated and stored.

{phang2}
{opt eform(string)} labels the exponentiated effect sizes as {it:string}; the
other options use default labels.  The default label is specific to the chosen
effect size.  For example, option {cmd:eform} uses {cmd:Odds Ratio} when used
with log odds-ratios declared with {cmd:meta esize} or {cmd:Risk Ratio} when
used with the declared log risk-ratios.  Option {cmd:or} is a synonym for
{cmd:eform} when log odds-ratio is declared, and option {cmd:rr} is a synonym
for {cmd:eform} when log risk-ratio is declared.  If option
{opt eslabel(eslab)} is specified during declaration, then {cmd:eform} will
use the {opt exp(eslab)} label or, if {it:eslab} is too long, the
{cmd:exp(ES)} label.

{marker transfspec}{...}
{phang}
{cmd:transform(}[{it:label}{cmd::}] {it:transf_name}{cmd:)} reports
transformed effect sizes and CIs.  {it:transf_name} is one of {cmd:corr},
{cmd:efficacy}, {cmd:exp}, {cmd:invlogit}, or {cmd:tanh}.  When {it:label} is
specified, the transformed effect sizes are labeled as {it:label} instead of
using the default label.  This option may not be combined with
{it:eform_option}.

{phang2}
{cmd:corr} transforms effect sizes (and CIs) specified as Fisher's z values
into correlations and, by default, labels them as {cmd:Correlation}; that is,
{cmd:transform(corr)} is a synonym for {cmd:transform(Correlation: tanh)}.

{phang2}
{cmd:efficacy} transforms the effect sizes and CIs using the 1 - {cmd:exp()}
function (or more precisely, the -{helpb expm1()} function) and labels them as
{cmd:Efficacy}.  This transformation is used, for example, when the effect
sizes are log risk-ratios so that the transformed effect sizes can be
interpreted as treatment efficacies, 1 - risk ratios.

{phang2}
{cmd:exp} exponentiates effect sizes and CIs and, by default, labels them as
{helpb exp():exp(ES)}.  This transformation is used, for example, when the
effect sizes are log risk-ratios, log odds-ratios, and log hazard-ratios so
that the transformed effect sizes can be interpreted as risk ratios, odds
ratios, and hazard ratios.  If the declared effect sizes are log odds-ratios
or log risk-ratios, the default label is {cmd:Odds ratio} or {cmd:Risk ratio},
respectively.

{phang2}
{cmd:invlogit} transforms the effect sizes and CIs using the inverse-logit
function, {helpb invlogit()}, and, by default, labels them as
{cmd:invlogit(ES)}.  This transformation is used, for example, when the effect
sizes are logit of proportions so that the transformed effect sizes can be
interpreted as proportions.

{phang2}
{cmd:tanh} applies the hyperbolic tangent transformation, {helpb tanh()}, to
the effect sizes and CIs and, by default, labels them as {cmd:tanh(ES)}.  This
transformation is used, for example, when the effect sizes are Fisher's z
values so that the transformed effect sizes can be interpreted as
correlations.

{phang}
{opt tdistribution} reports a t test instead of a z test for the overall effect
size.  This option may not be combined with option {cmd:subgroup()},
{cmd:cumulative()}, or {cmd:se()}.

{phang}
{opt nostudies} (synonym {cmd:nostudy}) suppresses the display of information
such as effect sizes and their CIs for individual studies from the output
table.

{phang}
{opt noheader} suppresses the output header.

{phang}
{opt metashow} and {opt nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {cmd:nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

{marker dispopts}{...}
{phang}
{it:display_options}: {opth cformat(%fmt)}, {opt pformat(%fmt)}, and
{opt sformat(%fmt)}; see {helpb estimation_options:[R] Estimation options}.
The defaults are {cmd:cformat(%9.3f)}, {cmd:pformat(%5.3f)}, and
{cmd:sformat(%8.2f)}.

{phang2}
{opth wgtformat(%fmt)} specifies how to format the weight column in the output
table.  The default is {cmd:wgtformat(%5.2f)}.  The maximum format width is 5.

{phang2}
{opth ordformat(%fmt)} specifies the format for the values of the order
variable, specified in {opt cumulative(ordervar)}.  The default is
{cmd:ordformat(%9.0g)}.  The maximum format width is 9.

{dlgtab:Maximization}
    
{marker maxopts}{...}
{phang}
{it:maximize_options}: {opt iter:ate(#)}, {opt tol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}
(see {helpb maximize:[R] Maximize}), {opt from(#)}, and {opt showtrace}.
These options control the iterative estimation of the between-study variance
parameter, τ^2, with random-effects methods {cmd:reml}, {cmd:mle}, and
{cmd:ebayes}.  These options are seldom used.

{phang2}
{opt from(#)} specifies the initial value for τ^2 during estimation.  By
default, the initial value for τ^2 is the noniterative Hedges estimator.

{phang2}
{opt showtrace} displays the iteration log that contains the estimated
parameter τ^2, its relative difference with the value from the previous
iteration, and the scaled gradient.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse pupiliqset}{p_end}

{pstd}Obtain a standard meta-analysis summary{p_end}
{phang2}{cmd:. meta summarize}

{pstd}Obtain results based on the DerSimonian–Laird random-effects and apply
the Knapp–Hartung adjustment to the overall effect-size standard error{p_end}
{phang2}{cmd:. meta summarize, random(dlaird) se(khartung)}

{pstd}Obtain results based on a fixed value of τ^2 at 0.25 and suppress the
output from individual studies{p_end}
{phang2}{cmd:. meta summarize, tau2(0.25) nostudies}

{pstd}Perform a subgroup analysis based on variable {cmd:week1}{p_end}
{phang2}{cmd:. meta summarize, subgroup(week1)}

{pstd}Perform two independent subgroup analyses based on variables {cmd:week1}
and {cmd:tester}{p_end}
{phang2}{cmd:. meta summarize, subgroup(week1 tester)}

{pstd}Perform a cumulative MA based on the order of variable {cmd:year}{p_end}
{phang2}{cmd:. meta summarize, cumulative(year)}

{pstd}As above, but perform a stratified CMA by variable {cmd:week1}{p_end}
{phang2}{cmd:. meta summarize, cumulative(year, by(week1))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta summarize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(theta)}}overall effect size{p_end}
{synopt:{cmd:r(se)}}standard error of overall effect size{p_end}
{synopt:{cmd:r(ci_lb)}}lower CI bound for overall effect size{p_end}
{synopt:{cmd:r(ci_ub)}}upper CI bound for overall effect size{p_end}
{synopt:{cmd:r(tau2)}}between-study variance{p_end}
{synopt:{cmd:r(I2)}}I^2 heterogeneity statistic (not for CE model){p_end}
{synopt:{cmd:r(H2)}}H^2 heterogeneity statistic (not for CE model){p_end}
{synopt:{cmd:r(z)}}z statistic for test of significance of overall effect size (when {cmd:se()} not specified){p_end}
{synopt:{cmd:r(t)}}t statistic for test of significance of overall effect size (when {cmd:se()} specified){p_end}
{synopt:{cmd:r(df)}}degrees of freedom for t distribution{p_end}
{synopt:{cmd:r(p)}}p-value for test of significance of overall effect size{p_end}
{synopt:{cmd:r(Q)}}Cochran's Q heterogeneity test statistic (not for CE model){p_end}
{synopt:{cmd:r(df_Q)}}degrees of freedom for heterogeneity test{p_end}
{synopt:{cmd:r(p_Q)}}p-value for heterogeneity test{p_end}
{synopt:{cmd:r(Q_b)}}Cochran's Q statistic for test of group differences (for {cmd:subgroup()} with one variable){p_end}
{synopt:{cmd:r(df_Q_b)}}degrees of freedom for test of group differences{p_end}
{synopt:{cmd:r(p_Q_b)}}p-value for test of group differences{p_end}
{synopt:{cmd:r(seadj)}}standard-error adjustment{p_end}
{synopt:{cmd:r(level)}}confidence level for CIs{p_end}
{synopt:{cmd:r(pi_lb)}}lower bound of prediction interval{p_end}
{synopt:{cmd:r(pi_ub)}}upper bound of prediction interval{p_end}
{synopt:{cmd:r(pilevel)}}confidence level for prediction interval{p_end}
{synopt:{cmd:r(converged)}}{cmd:1} if converged, {cmd:0} otherwise (with iterative random-effects methods){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(model)}}meta-analysis model{p_end}
{synopt:{cmd:r(method)}}meta-analysis estimation method{p_end}
{synopt:{cmd:r(subgroupvars)}}names of subgroup-analysis variables{p_end}
{synopt:{cmd:r(ordervar)}}name of order variable used in option {cmd:cumulative()}{p_end}
{synopt:{cmd:r(byvar)}}name of variable used in suboption {cmd:by()} within option {cmd:cumulative()}{p_end}
{synopt:{cmd:r(direction)}}{cmd:ascending} or {cmd:descending}{p_end}
{synopt:{cmd:r(seadjtype)}}type of standard-error adjustment{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(esgroup)}}ESs and CIs from subgroup analysis{p_end}
{synopt:{cmd:r(hetgroup)}}heterogeneity summary from subgroup analysis{p_end}
{synopt:{cmd:r(diffgroup)}}results for tests of group differences from subgroup analysis{p_end}
{synopt:{cmd:r(cumul)}}results from cumulative meta-analysis{p_end}
{p2colreset}{...}

{pstd}
{cmd:meta summarize} also creates a system variable, {cmd:_meta_weight}, which
contains study weights.  When the {cmd:transform()} option is specified,
{cmd:meta summarize} creates system variables {cmd:_meta_es_transf},
{cmd:_meta_cil_transf}, and {cmd:_meta_ciu_transf}, which contain the
transformed effect sizes and lower and upper bounds of the corresponding
transformed CIs.

{pstd}
Also see
{help meta_set##results:{it:Stored results}} in
{helpb meta_set:[META] meta set} and
{help meta_esize##results:{it:Stored results}} in
{helpb meta_esize:[META] meta esize} for other system variables.
{p_end}


{marker references}{...}
{title:References}

{marker hartungknapp2001a}{...}
{phang}
Hartung, J., and G. Knapp. 2001a. On tests of the overall treatment effect in
meta-analysis with normally distributed responses.
{it:Statistics in Medicine} 20: 1771–1782.

{marker hartungknapp2001b}{...}
{phang}
------. 2001b. A refined method for the meta-analysis of controlled clinical
trials with binary outcome.  {it:Statistics in Medicine} 20: 3875–3889.

{marker knapphartung2003}{...}
{phang}
Knapp, G., and J. Hartung. 2003. Improved tests for a random effects
meta-regression with a single covariate.
{it:Statistics in Medicine} 22: 2693–2710.

{marker sidikjonkman2002}{...}
{phang}
Sidik, K., and J. N. Jonkman. 2002. A simple confidence interval for
meta-analysis. {it:Statistics in Medicine} 21: 3153–3159.
{p_end}
