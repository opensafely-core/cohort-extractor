{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta trimfill" "mansection META metatrimfill"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta bias" "help meta bias"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta funnelplot" "help meta funnelplot"}{...}
{vieweralsosee "[META] meta summarize" "help meta summarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_trimfill##syntax"}{...}
{viewerjumpto "Menu" "meta_trimfill##menu"}{...}
{viewerjumpto "Description" "meta_trimfill##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_trimfill##linkspdf"}{...}
{viewerjumpto "Options" "meta_trimfill##options"}{...}
{viewerjumpto "Examples" "meta_trimfill##examples"}{...}
{viewerjumpto "Stored results" "meta_trimfill##results"}{...}
{viewerjumpto "Reference" "meta_trimfill##reference"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[META] meta trimfill} {hline 2}}Nonparametric trim-and-fill
analysis of publication bias{p_end}
{p2col:}({mansection META metatrimfill:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:meta} {cmdab:trim:fill}
{ifin}
[{cmd:,} {it:options}]

{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opth est:imator(meta_trimfill##estimator:estimator)}}estimator for the number of missing studies; default is {cmd:linear}{p_end}
{synopt :{opt left}}impute studies on the left side of the funnel plot{p_end}
{synopt :{opt right}}impute studies on the right side of the funnel plot{p_end}
{synopt :{opt funnel}[{cmd:(}{help meta_trimfill##funnelopts:{it:funnelopts}}{cmd:)}]}draw funnel plot{p_end}

{syntab:Options}
{synopt :{opt l:evel(#)}}set confidence level; default is as declared for meta-analysis{p_end}
{synopt :{help meta_trimfill##eform_option:{it:eform_option}}}report exponentiated results{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}
{synopt :{help meta_trimfill##dispopts:{it:display_options}}}control column formats{p_end}

{syntab:Iteration}
{synopt :{opt random}[{cmd:(}{help meta_trimfill##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis to use for iteration and pooling steps{p_end}
{synopt :{opt common}}common-effect meta-analysis to use for iteration and pooling steps; implies inverse-variance method{p_end}
{synopt :{opt fixed}}fixed-effects meta-analysis to use for iteration and pooling steps; implies inverse-variance method{p_end}
{synopt :{opth itermeth:od(meta_trimfill##itermethod:method)}}meta-analysis to use for iteration step{p_end}
{synopt :{opth poolmeth:od(meta_trimfill##poolmethod:method)}}meta-analysis to use for pooling step{p_end}
{synopt :{opt iter:ate(#)}}maximum number of iterations for the trim-and-fill algorithm; default is {cmd:iterate(100)}{p_end}
{synopt :[{cmd:no}]{cmd:log}}display an iteration log from the trim-and-fill algorithm{p_end}
{synoptline}

{marker estimator}{...}
{synoptset 22}{...}
{synopthdr:estimator}
{synoptline}
{synopt :{opt lin:ear}}linear estimator, L_0; the default{p_end}
{synopt :{opt run}}run estimator, R_0{p_end}
{synopt :{opt quad:ratic}}quadratic estimator, Q_0 (rarely used){p_end}
{synoptline}

INCLUDE help meta_remethod


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta trimfill} performs the nonparametric "trim-and-fill" method to
account for publication bias in meta-analysis.  The command estimates the
number of studies potentially missing from a meta-analysis because of
publication bias, imputes these studies, and computes the overall effect-size
estimate using the observed and imputed studies.  It can also provide a
funnel plot, in which omitted studies are imputed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metatrimfillQuickstart:Quick start}

        {mansection META metatrimfillRemarksandexamples:Remarks and examples}

        {mansection META metatrimfillMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt estimator(estimator)} specifies the type of estimator for the number of
missing studies.  {it:estimator} is one of {cmd:linear}, {cmd:run}, or
{cmd:quadratic}.  The default is {cmd:estimator(linear)}.

{phang2}
{cmd:linear} specifies that the "linear" estimator, L_0, be used to estimate
the number of missing studies.  This is the default estimator.

{phang2}
{cmd:run} specifies that the rightmost-run estimator, R_0, be used to estimate
the number of missing studies.

{phang2}
{cmd:quadratic} specifies that the "quadratic" estimator, Q_0, be used to
estimate the number of missing studies.  This estimator is not recommended in
the literature and provided for completeness.

{pmore}
{help meta_trimfill##duvaltweedie2000:Duval and Tweedie (2000)} found that
the L_0 and R_0 estimators perform better in terms of mean squared error than
the Q_0 estimator, with L0 having the smallest mean squared error in certain
cases.  They also found that R_0 tends to be conservative in some cases.
Therefore, L_0 is chosen to be the default, but the authors recommend that all
estimators be considered in practice.  Also see
{mansection META metatrimfillMethodsandformulasEstimatingthenumberofmissingstudies:{it:Estimating the number of missing studies}}
in {bf:[META] meta trimfill} for details about the estimators.

{phang}
{cmd:left} and {cmd:right} specify the side of the funnel plot, where the
missing studies are to be imputed.  By default, the side is chosen based on
the results of the traditional Egger test -- if the estimated slope is
positive, {cmd:left} is assumed; otherwise, {cmd:right} is assumed. Only one
of {cmd:left} or {cmd:right} is allowed.

{phang2}
{cmd:left} assumes that the leftmost (smallest) effect sizes have been
suppressed and specifies to impute them.

{phang2}
{cmd:right} assumes that the rightmost (largest) effect sizes have been
suppressed and specifies to impute them.

{marker funnelopts}{...}
{phang}
{cmd:funnel} and {opt funnel(funnelopts)} specify to draw a funnel plot that
includes the imputed studies.

{phang2}
{it:funnelopts} are any options as documented in
{helpb meta_funnelplot:[META] meta funnelplot}, except
{cmd:random}[{cmd:()}], {cmd:common}[{cmd:()}], {cmd:fixed}[{cmd:()}],
{cmd:by()}, [{cmd:no}]{cmd:metashow}, and {cmd:addplot()}.

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
respective confidence intervals, whenever applicable. By default, the results
are displayed in the metric declared with {cmd:meta set} or {cmd:meta esize}
such as log odds-ratios and log risk-ratios.  {it:eform_option} affects how
results are displayed, not how they are estimated and stored.

{phang2}
{opt eform(string)} labels the exponentiated effect sizes as {it:string}; the
other options use default labels.  The default label is specific to the chosen
effect size. For example, option {cmd:eform} uses {cmd:Odds Ratio} when used
with log odds-ratios declared with {cmd:meta esize} or {cmd:Risk Ratio} when
used with the declared log risk-ratios. Option {cmd:or} is a synonym for
{cmd:eform} when log odds-ratio is declared, and option {cmd:rr} is a synonym
for {cmd:eform} when log risk-ratio is declared. If option
{opt eslabel(eslab)} is specified during declaration, then {cmd:eform} will
use the {opt exp(eslab)} label or, if {it:eslab} is too long, the
{cmd:exp(ES)} label.

{phang}
{cmd:metashow} and {cmd:nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {cmd:nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

{marker dispopts}{...}
{phang}
{it:display_options}: {opth cformat(%fmt)}; see
{helpb estimation_options:[R] Estimation options}.

{dlgtab:Iteration}
 
{pstd}
Options {cmd:random()}, {cmd:common}, and {cmd:fixed}, when specified with
{cmd:meta trimfill}, temporarily override the global model declared by
{helpb meta set} or {helpb meta esize} during the computation.  These options
specify that the same method be used during both iteration and pooling steps.
To specify different methods, use options {cmd:itermethod()} and
{cmd:poolmethod()}.  Options {cmd:random()}, {cmd:common}, and {cmd:fixed} may
not be combined.  If these options are omitted, the declared meta-analysis
model is assumed; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  Also see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
in {bf:[META] Intro}.

{phang}
{opt random} and {opt random(remethod)} specify that a random-effects model be
assumed for meta-analysis during iteration and pooling steps of the
trim-and-fill algorithm; see
{mansection META IntroRemarksandexamplesRandom-effectsmodel:{it:Random-effects model}}

{marker remethoddes}{...}
{phang2}
{it:remethod} specifies the type of estimator for the between-study variance
τ^2.  {it:remethod} is one of {cmd:reml}, {cmd:mle}, {cmd:ebayes},
{cmd:dlaird}, {cmd:sjonkman}, {cmd:hedges}, or {cmd:hschmidt}.  {cmd:random}
is a synonym for {cmd:random(reml)}. See
{help meta_esize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{cmd:common} specifies that a common-effect model be assumed for meta-analysis
during iteration and pooling steps of the trim-and-fill algorithm; see
{mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.
{cmd:common} is not allowed in the presence of {it:moderators}.

{phang}
{cmd:fixed} specifies that a fixed-effects model be assumed for meta-analysis
during iteration and pooling steps of the trim-and-fill algorithm; see
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{marker itermethod}{...}
{phang}
{opt itermethod(method)} specifies the meta-analysis method to use during the
iteration step of the trim-and-fill algorithm. The default is the method
declared for meta-analysis; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  Also see
{mansection META metatrimfillMethodsandformulasTrim-and-fillalgorithm:{it:Trim-and-fill algorithm}}
in {it:Methods and formulas} of {bf:[META] meta trimfill}.  This option may
not be combined with {cmd:random()}, {cmd:common}, or {cmd:fixed}.

{phang2}
{it:method} is one of the random-effects meta-analysis methods,
{help meta_trimfill##remethod:{it:remethod}}; or a common-effect
inverse-variance method, {cmd:common}; or a fixed-effects inverse-variance
method, {cmd:fixed}; see
{help meta_set##options:{it:Options}} in
{helpb meta_set:[META] meta esize} for details.

{marker poolmethod}{...}
{phang}
{opt poolmethod(method)} specifies the meta-analysis method to use during the
pooling step of the trim-and-fill algorithm. The default is to use the method
declared for meta-analysis; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  Also see
{mansection META metatrimfillMethodsandformulasTrim-and-fillalgorithm:{it:Trim-and-fill algorithm}}
in {it:Methods and formulas} of {bf:[META] meta trimfill}.  This option may
not be combined with {cmd:random()}, {cmd:common}, or {cmd:fixed}.

{phang2}
{it:method} is one of the random-effects meta-analysis methods,
{help meta_trimfill##remethod:{it:remethod}}; or a common-effect
inverse-variance method, {cmd:common}; or a fixed-effects inverse-variance
method, {cmd:fixed}; see
{help meta_set##options:{it:Options}} in
{helpb meta_set:[META] meta esize} for details.

{phang}
{opt iterate(#)} specifies the maximum number of iterations for the
trim-and-fill algorithm.  The default is {cmd:iterate(100)}.  When the number
of iterations equals {cmd:iterate()}, the algorithm stops and presents the
current results. If convergence is not reached, a warning message is also
displayed.  If convergence is declared before this threshold is reached, the
algorithm will stop when convergence is declared.

{phang}
{opt nolog} and {opt log} specify whether an iteration log showing the
progress of the trim-and-fill algorithm is to be displayed. By default, the
log is suppressed but you can specify {cmd:log} to display it.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse metatrim}{p_end}
{phang2}{cmd:. meta set stdmdiff se}

{pstd}Perform the trim-and-fill analysis of publication bias{p_end}
{phang2}{cmd:. meta trimfill}

{pstd} As above, but request the rightmost-run estimator to estimate the number
of missing studies{p_end}
{phang2}{cmd:. meta trimfill, estimator(run)}

{pstd}As above, but request a funnel plot of the observed and imputed
studies{p_end}
{phang2}{cmd:. meta trimfill, estimator(run) funnel}

{pstd}As above, but request a contour-enhanced funnel plot{p_end}
{phang2}{cmd:. meta trimfill, estimator(run) funnel(contour(1 5 10))}

{pstd}Specify that overall effect-size estimation be based on the fixed-effect
inverse-variance method during iteration step and random-effects
DerSimonian–Laird method during pooling step of the trim-and-fill algorithm
{p_end}
{phang2}{cmd:. meta trimfill, itermethod(fixed) poolmethod(dlaird)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta trimfill} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(K_total)}}total number of studies (observed plus imputed){p_end}
{synopt:{cmd:r(K_observed)}}number of observed studies{p_end}
{synopt:{cmd:r(K_imputed)}}number of imputed studies{p_end}
{synopt:{cmd:r(converged)}}{cmd:1} if trim-and-fill algorithm converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(estimator)}}type of estimator for the number of missing studies{p_end}
{synopt:{cmd:r(side)}}side of the funnel plot with missing studies; {cmd:left} or {cmd:right}{p_end}
{synopt:{cmd:r(itermethod)}}meta-analysis estimation method used during iteration step{p_end}
{synopt:{cmd:r(poolmethod)}}meta-analysis estimation method used during final pooling step{p_end}
{synopt:{cmd:r(level)}}confidence level for CIs{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}trim-and-fill table of results{p_end}
{synopt:{cmd:r(imputed)}}matrix of effect sizes and their standard errors for imputed studies{p_end}


{marker reference}{...}
{title:Reference}

{marker duvaltweedie2000}{...}
{phang}
Duval, S., and R. L. Tweedie. 2000. Trim and fill: A simple funnel-plot–based
method of testing and adjusting for publication bias in meta-analysis.
{it:Biometrics} 56: 455–463.
{p_end}
