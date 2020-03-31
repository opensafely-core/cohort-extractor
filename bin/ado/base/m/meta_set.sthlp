{smcl}
{* *! version 1.0.2  04nov2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta set" "mansection META metaset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta esize" "help meta esize"}{...}
{vieweralsosee "[META] meta update" "help meta update"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_set##syntax"}{...}
{viewerjumpto "Menu" "meta_set##menu"}{...}
{viewerjumpto "Description" "meta_set##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_set##linkspdf"}{...}
{viewerjumpto "Options" "meta_set##options"}{...}
{viewerjumpto "Examples" "meta_set##examples"}{...}
{viewerjumpto "Stored results" "meta_set##results"}{...}
{viewerjumpto "References" "meta_set##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[META] meta set} {hline 2}}Declare meta-analysis data using generic
effect sizes{p_end}
{p2col:}({mansection META metaset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Specify generic effect sizes and their standard errors

{p 8 16 2}
{cmd:meta set}
{help meta_set##esvar:{it:esvar sevar}}
{ifin}
[{cmd:,} {help meta_set##optstbl:{it:options}}]


{pstd}
Specify generic effect sizes and their confidence intervals

{p 8 16 2}
{cmd:meta set}
{help meta_set##esvar:{it:esvar cilvar ciuvar}}
{ifin}
[{cmd:,} {opt civarlev:el(#)}{cmd:,}
{opt civartol:erance(#)}
 {help meta_set##optstbl:{it:options}}]


{marker esvar}{...}
{pstd}
{it:esvar} specifies a variable containing the effect sizes, {it:sevar}
specifies a variable containing standard errors of the effect sizes, and
{it:cilvar} and {it:ciuvar} specify variables containing the respective lower
and upper bounds of (symmetric) confidence intervals for the effect sizes.
{it:esvar} and the other variables must correspond to effect sizes specified
in the metric closest to normality, such as log odds-ratios instead of
odds ratios.

{synoptset 22 tabbed}{...}
{marker optstbl}{...}
{synopthdr:options}
{synoptline}
{syntab:Model}
{synopt :{opt random}[{cmd:(}{help meta_set##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis; default is {cmd:random(reml)}{p_end}
{synopt :{cmd:common}}common-effect meta-analysis; implies inverse-variance method{p_end}
{synopt :{opt fixed}}fixed-effects meta-analysis; implies inverse-variance method{p_end}

{syntab:Options}
{synopt :{opth studylab:el(varname)}}variable to be used to label studies in all meta-analysis output{p_end}
{synopt :{opth studysize(varname)}}total sample size per study{p_end}
{synopt :{opth eslab:el(strings:string)}}effect-size label to be used in all meta-analysis output; default is {cmd:eslabel(Effect Size)}{p_end}
{synopt :{opt l:evel(#)}}confidence level for all subsequent meta-analysis commands{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings with other
{cmd:meta} commands{p_end}
{synoptline}

{synoptset 22}{...}
INCLUDE help meta_remethod


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta set} declares the data in memory to be {cmd:meta} data, informing
Stata of key variables and their roles in a meta-analysis.  It is used with
generic (precomputed) effect sizes specified in the metric closest to
normality; see {helpb meta esize:[META] meta esize}
if you need to compute and declare effect sizes.  You must use {cmd:meta set}
or {cmd:meta esize} to perform meta-analysis using the {cmd:meta} command; see
{manlink META meta data}.

{pstd}
If you need to update some of the meta settings after the data
declaration, see {helpb meta update:[META] meta update}.  To display current
meta settings, use {cmd:meta query}; see
{helpb meta update:[META] meta update}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metasetQuickstart:Quick start}

        {mansection META metasetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt civarlevel(#)} is relevant only when you specify CI variables
{help meta_set##esvar:{it:cilvar}} and
{help meta_set##esvar:{it:ciuvar}} with {cmd:meta set}.  It specifies the
confidence level corresponding to these variables.  The default is
{cmd:civarlevel(95)}.  This option affects the computation of the effect-size
standard errors stored in the
{mansection META metadataRemarksandexamplesSystemvariables:system variable}
{cmd:_meta se}.

{pmore}
Do not confuse {cmd:civarlevel()} with {cmd:level()}.  The former affects the
confidence level only for the specified CI variables.  The latter specifies the
confidence level for the meta-analysis.

{phang}
{opt civartolerance(#)} is relevant only when you specify CI variables
{help meta_set##esvar:{it:cilvar}}
and
{help meta_set##esvar:{it:ciuvar}}
with {opt meta set}.  {it:cilvar} and {it:ciuvar} must define a symmetric CI
based on the normal distribution.  {cmd:civartolerance()} specifies the
tolerance to check whether the CI is symmetric. The default is
{cmd:civartolerance(1e-6)}.  Symmetry is declared when
{helpb reldif():reldif}{cmd:(}{it:ciuvar} - {it:esvar}{cmd:,} {it:esvar} -
{it:cilvar}{cmd:)} < {it:#}.

{pmore}
{cmd:meta set} expects the effect sizes and CIs to be specified in the metric
closest to normality, which implies symmetric CIs. Effect sizes and their CIs
are often reported in the original metric and with limited precision that,
after the normalizing transformation, may lead to asymmetric CIs. In that
case, the default of 1e-6 may be too stringent. You may use
{cmd:civartolerance()} to loosen the default.

{dlgtab:Model}
 
{pstd}
Options {cmd:random()}, {cmd:common}, and {cmd:fixed} declare the meta-analysis
model globally throughout the entire meta-analysis; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  In other words, once you set your meta-analysis
model using {cmd:meta set}, all subsequent {cmd:meta} commands will assume that
same model.  You can update the declared model by using {helpb meta update} or
change it temporarily by specifying the corresponding option with the
{cmd:meta} commands.  Options {cmd:random()}, {cmd:common}, and {cmd:fixed}
may not be combined.  If these options are omitted, {cmd:random(reml)} is
assumed; see
{mansection META metadataRemarksandexamplesDefaultmeta-analysismodelandmethod:{it:Default meta-analysis model and method}}
in {bf:[META] meta data}.  Also see
{mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
in {bf:[META] Intro}.

{phang}
{cmd:random} and {opt random(remethod)} specify that a random-effects model be
assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesRandom-effectsmodel:{it:Random-effects model}}
in {bf:[META] Intro}.

{marker remethoddes}{...}
{phang2}
{it:remethod} specifies the type of estimator for the between-study variance
τ^2.  {it:remethod} is one of {cmd:reml}, {cmd:mle}, {cmd:ebayes},
{cmd:dlaird}, {cmd:sjonkman}, {cmd:hedges}, or {cmd:hschmidt}.  {cmd:random} is
a synonym for {cmd:random(reml)}.  Below, we provide a short description for
each method based on
{help meta_set##veronikietal2016:Veroniki et al. (2016)}.  Also see
{mansection META metadataRemarksandexamplesDeclaringameta-analysisestimationmethod:{it:Declaring a meta-analysis estimation method}}
in {bf:[META] meta data}.

{phang3}
{cmd:reml}, the default, specifies that the REML method
({help meta_set##raudenbush2009:Raudenbush 2009}) be used to estimate τ^2.
This method produces an unbiased, nonnegative estimate of the between-study
variance and is commonly used in practice.  Method {cmd:reml} requires
iteration.

{phang3}
{cmd:mle} specifies that the ML method
({help meta_set##hardythompson1996:Hardy and Thompson 1996}) be used to
estimate τ^2.  It produces a nonnegative estimate of the between-study
variance.  With a few studies or small studies, this method may produce biased
estimates.  With many studies, the ML method is more efficient than the REML
method.  Method {cmd:mle} requires iteration.

{phang3}
{cmd:ebayes} specifies that the empirical Bayes estimator
({help meta_set##berkeyetal1995:Berkey et al. 1995}), also known as the
Paule–Mandel estimator
({help meta_set##paulemandel1982:Paule and Mandel 1982}), be used to estimate
τ^2.  From simulations, this method, in general, tends to be less biased than
other random-effects methods, but it is also less efficient than {cmd:reml} or
{cmd:dlaird}.  Method {cmd:ebayes} produces a nonnegative estimate of τ^2 and
requires iteration.

{phang3}
{cmd:dlaird} specifies that the DerSimonian–Laird method
({help meta_set##dersimonianlaird1986:DerSimonian and Laird 1986}) be used to
estimate τ^2.  This method, historically, is one of the most popular estimation
methods because it does not make any assumptions about the distribution of
random effects and does not require iteration.  But it may underestimate the
true between-study variance, especially when the variability is large and the
number of studies is small.  This method may produce a negative value of τ^2
and is thus truncated at zero in that case.

{phang3}
{cmd:sjonkman} specifies that the Sidik–Jonkman method 
({help meta_set##sidikjonkman2005:Sidik and Jonkman 2005}) be used to
estimate τ^2.  This method always produces a nonnegative estimate of the
between-study variance and thus does not need truncating at 0, unlike the other
noniterative methods.  Method {cmd:sjonkman} does not require iteration.

{phang3}
{cmd:hedges} specifies that the Hedges method
({help meta_set##hedges1983:Hedges 1983}) be used to estimate τ^2.  When the
sampling variances of effect-size estimates can be estimated without bias, this
estimator is exactly unbiased (before truncation), but it is not widely used in
practice ({help meta_set##veronikietal2016:Veroniki et al. 2016}).  Method
{cmd:hedges} does not require iteration.

{phang3}
{cmd:hschmidt} specifies that the Hunter–Schmidt method
({help meta_set##schmidthunter2015:Schmidt and Hunter 2015}) be used to
estimate τ^2.  Although this estimator achieves a lower MSE than other methods,
except ML, it is known to be negatively biased.  Method {cmd:hschmidt} does not
require iteration.

{phang}
{cmd:common} specifies that a common-effect model be assumed for meta-analysis;
see {mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{phang}
{cmd:fixed} specifies that a fixed-effects model be assumed for meta-analysis;
see {mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  It uses the inverse-variance estimation method; see
{mansection META IntroRemarksandexamplesMeta-analysisestimationmethods:{it:Meta-analysis estimation methods}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{dlgtab:Options}
 
{phang}
{opth studylabel(varname)} specifies a string variable containing labels for
the individual studies to be used in all applicable meta-analysis output.  The
default study labels are {cmd:Study 1}, {cmd:Study 2}, ..., {cmd:Study} K,
where K is the total number of studies in the meta-analysis.

{phang}
{opth studysize(varname)} specifies the variable that contains the total sample
size for each study.  This option is useful for subsequent {cmd:meta} commands
that use this information in computations such as {helpb meta funnelplot} using
the sample-size metric.

{phang}
{opth eslabel:(strings:string)} specifies that {it:string} be used as the
effect-size label in all relevant meta-analysis output.  The default label is
{cmd:Effect Size}.

{marker level}{...}
{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  It will be used by all subsequent meta-analysis commands when
computing confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.  After the declaration, you can specify {cmd:level()} with
{cmd:meta update} to update the confidence level to be used throughout the rest
of the meta-analysis session.  You can also specify {cmd:level()} directly with
the {cmd:meta} commands to modify the confidence level, temporarily, during the
execution of the command.

{phang}
{cmd:metashow} and {cmd:nometashow} display or suppress the meta setting
information in the output of other {cmd:meta} commands.  By default, this
information is displayed at the top of their output.  You can also specify
{cmd:nometashow} with {helpb meta update} to suppress the meta setting output
for the entire meta-analysis session after the declaration.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metaset}{p_end}

{pstd}Declare precomputed effect sizes and their standard errors{p_end}
{phang2}{cmd:. meta set es se}

{pstd}As above, but specify a DerSimonian–Laird random-effects method and
study labels{p_end}
{phang2}{cmd:. meta set es se, random(dlaird) studylabel(studylab)}

{pstd}Declare precomputed effect sizes and their confidence intervals instead
of standard errors{p_end}
{phang2}{cmd:. meta set es cil ciu}

{pstd}As above, but specify a common-effect model and effect-size label{p_end}
{phang2}{cmd:. meta set es cil ciu, common eslabel("Mean diff.")}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgrratio, clear}

{pstd}Apply log transformation to risk ratios and their confidence intervals{p_end}
{phang2}{cmd:. generate double log_rr   = log(rr)}{p_end}
{phang2}{cmd:. generate double log_rrll = log(rr_ll)}{p_end}
{phang2}{cmd:. generate double log_rrul = log(rr_ul)}{p_end}

{pstd}Declare the normally distributed effect sizes and their confidence intervals{p_end}
{phang2}{cmd:. meta set log_rr log_rrll log_rrul}{p_end}

    {hline}
{pstd}Open dataset with risk ratios and confidence intervals that are stored
with only three decimals digits of precision{p_end}
{phang2}{cmd:. webuse bcgrratio2, clear}

{pstd}Create log-transformed versions of limited-precision risk ratios{p_end}
{phang2}{cmd:. generate double log_rr   = log(rr)}{p_end}
{phang2}{cmd:. generate double log_rrll = log(rr_ll)}{p_end}
{phang2}{cmd:. generate double log_rrul = log(rr_ul)}{p_end}

{pstd}Declare the effect sizes and their confidence intervals, and include the
{cmd:civartolerance()} option to loosen the tolerance for verifying that the
CIs are symmetric; the default CI tolerance of 1e-6 is too stringent because
of limited precision{p_end}
{phang2}{cmd:. meta set log_rr log_rrll log_rrul, civartolerance(1e-2)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta set} stores the following characteristics and system variables:

{synoptset 28 tabbed}{...}
{p2col 5 28 32 2: Characteristics}{p_end}
{synopt:{cmd:_dta[_meta_marker]}}"{cmd:_meta_ds_1"}{p_end}
{synopt:{cmd:_dta[_meta_K]}}number of studies in the meta-analysis{p_end}
{synopt:{cmd:_dta[_meta_studylabel]}}name of string variable containing study labels or {cmd:Generic}{p_end}
{synopt:{cmd:_dta[_meta_studysize]}}name of numeric variable containing study sizes, when {cmd:studysize()} specified{p_end}
{synopt:{cmd:_dta[_meta_estype]}}type of effect size; {cmd:Generic}{p_end}
{synopt:{cmd:_dta[_meta_eslabelopt]}}{opt eslabel(eslab)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_eslabel]}}effect-size label from {cmd:eslabel()}; default is {cmd:Effect Size}{p_end}
{synopt:{cmd:_dta[_meta eslabeldb]}}effect-size label for dialog box{p_end}
{synopt:{cmd:_dta[_meta_esvar]}}name of effect-size variable{p_end}
{synopt:{cmd:_dta[_meta_esvardb]}}abbreviated name of effect-size variable for dialog box{p_end}
{synopt:{cmd:_dta[_meta_sevar]}}name of standard-error variable, if specified, or {cmd:_meta_se}{p_end}
{synopt:{cmd:_dta[_meta_cilvar]}}name of variable containing lower CI bounds, if specified, or {cmd:_meta_cil}{p_end}
{synopt:{cmd:_dta[_meta_ciuvar]}}name of variable containing upper CI bounds, if specified, or {cmd:_meta_ciu}{p_end}
{synopt:{cmd:_dta[_meta_civarlevel]}}confidence level associated with CI variables, if specified{p_end}
{synopt:{cmd:_dta[_meta_level]}}default confidence level for meta-analysis{p_end}
{synopt:{cmd:_dta[_meta_modellabel]}}meta-analysis model label: {cmd:Random-effects}, {cmd:Common-effect}, or {cmd:Fixed-effects}{p_end}
{synopt:{cmd:_dta[_meta_model]}}meta-analysis model: {cmd:random}, {cmd:common}, or {cmd:fixed}{p_end}
{synopt:{cmd:_dta[_meta_methodlabel]}}meta-analysis method label; varies by meta-analysis model{p_end}
{synopt:{cmd:_dta[_meta_method]}}meta-analysis method; varies by meta-analysis model{p_end}
{synopt:{cmd:_dta[_meta_randomopt]}}{opt random(remethod)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_show]}}empty or {cmd:nometashow}{p_end}
{synopt:{cmd:_dta[_meta_datatype]}}data type; {cmd:Generic}{p_end}
{synopt:{cmd:_dta[_meta_datavars]}}variables specified with {cmd:meta set}{p_end}
{synopt:{cmd:_dta[_meta_setcmdline]}}{cmd:meta set} command line{p_end}
{synopt:{cmd:_dta[_meta_ifexp]}}{it:if} specification{p_end}
{synopt:{cmd:_dta[_meta_inexp]}}{it:in} specification{p_end}

{p2col 5 28 32 2: System variables}{p_end}
{synopt:{cmd:_meta_id}}study ID variable{p_end}
{synopt:{cmd:_meta_es}}variable containing effect sizes{p_end}
{synopt:{cmd:_meta_se}}variable containing effect-size standard errors{p_end}
{synopt:{cmd:_meta_cil}}variable containing lower bounds of CIs for effect sizes{p_end}
{synopt:{cmd:_meta_ciu}}variable containing upper bounds of CIs for effect sizes{p_end}
{synopt:{cmd:_meta_studylabel}}string variable containing study labels{p_end}
{synopt:{cmd:_meta_studysize}}variable containing total sample size per study{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker berkeyetal1995}{...}
{phang}
Berkey, C. S., D. C. Hoaglin, F. Mosteller, and G. A. Colditz. 1995.
A random-effects regression model for meta-analysis.
{it:Statistics in Medicine} 14: 395–411.

{marker dersimonianlaird1986}{...}
{phang}
DerSimonian, R., and N. Laird. 1986. Meta-analysis in clinical trials.
{it:Controlled Clinical Trials} 7: 177–188.

{marker hardythompson1996}{...}
{phang}
Hardy, R. J., and S. G. Thompson. 1996. A likelihood approach to meta-analysis
with random effects.
{it:Statistics in Medicine} 15: 619–629.

{marker hedges1983}{...}
{phang}
Hedges, L. V. 1983. A random effects model for effect sizes.
{it:Psychological Bulletin} 93: 388–395.

{marker paulemandel1982}{...}
{phang}
Paule, R. C., and J. Mandel. 1982. Consensus values and weighting factors.
{it:Journal of Research of the National Bureau of Standards} 87: 377–385.

{marker raudenbush2009}{...}
{phang}
Raudenbush, S. W. 2009. Analyzing effect sizes: Random-effects models. In
{it:The Handbook of Research Synthesis and Meta-Analysis},
ed. H. Cooper, L. V. Hedges, and J. C. Valentine, 2nd ed., 295–316.
New York: Russell Sage Foundation.

{marker schmidthunter2015}{...}
{phang}
Schmidt, F. L., and J. E. Hunter. 2015.
{it:Methods of Meta-Analysis: Correcting Error and Bias in Research Findings}.
3rd ed. Thousand Oaks, CA: SAGE.

{marker sidikjonkman2005}{...}
{phang}
Sidik, K., and J. N. Jonkman. 2005. A note on variance estimation in random
effects meta-regression.
{it:Journal of Biopharmaceutical Statistics} 15: 823–838.

{marker veronikietal2016}{...}
{phang}
Veroniki, A. A., D. Jackson, W. Viechtbauer, R. Bender, J. Bowden, G. Knapp,
O. Kuss, J. P. T. Higgins, D. Langan, and G. Salanti. 2016.
Methods to estimate the between-study variance and its uncertainty in
meta-analysis. {it:Research Synthesis Methods} 7: 55–79.
{p_end}
