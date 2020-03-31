{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta esize" "mansection META metaesize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta set" "help meta set"}{...}
{vieweralsosee "[META] meta update" "help meta update"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] esize" "help esize"}{...}
{viewerjumpto "Syntax" "meta_esize##syntax"}{...}
{viewerjumpto "Menu" "meta_esize##menu"}{...}
{viewerjumpto "Description" "meta_esize##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_esize##linkspdf"}{...}
{viewerjumpto "Options" "meta_esize##options"}{...}
{viewerjumpto "Examples" "meta_esize##examples"}{...}
{viewerjumpto "Stored results" "meta_esize##results"}{...}
{viewerjumpto "References" "meta_esize##references"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[META] meta esize} {hline 2}}Compute effect sizes and declare
meta-analysis data{p_end}
{p2col:}({mansection META metaesize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute and declare effect sizes for two-group comparison of continuous
outcomes

{p 8 16 2}
{cmd:meta} {cmdab:es:ize}
{help meta_esize##nms:{it:n1}}
{help meta_esize##nms:{it:mean1}}
{help meta_esize##nms:{it:sd1}}
{help meta_esize##nms:{it:n2}}
{help meta_esize##nms:{it:mean2}}
{help meta_esize##nms:sd2}
{ifin} [{cmd:,}
{help meta_esize##cont_options:{it:options_continuous}}
{help meta_esize##optstbl:{it:options}}]


{phang}
Compute and declare effect sizes for two-group comparison of binary outcomes

{p 8 16 2}
{cmd:meta} {cmd:esize} 
{help meta_esize##n11:{it:n11}}
{help meta_esize##n11:{it:n12}}
{help meta_esize##n11:{it:n21}}
{help meta_esize##n11:{it:n22}}
{ifin} [{cmd:,} 
{help meta_esize##bin_options:{it:options_binary}}
{help meta_esize##optstbl:{it:options}}]


{marker nms}{...}
{phang}
Variables {it:n1}, {it:mean1}, and {it:sd1} contain sample sizes, means, and
standard deviations from individual studies for group 1 (treatment), and
variables {it:n2}, {it:mean2}, and {it:sd2} contain the respective summaries
for group 2 (control).

{marker n11}{...}
{phang}
Variables {it:n11} and {it:n12} contain numbers of successes and numbers of
failures from individual studies for group 1 (treatment), and variables
{it:n21} and {it:n22} contain the respective numbers for group 2 (control).
A single observation defined by variables {it:n11}, {it:n12}, {it:n21}, and
{it:n22} represents a 2 × 2 table from an individual study.  Therefore,
variables {it:n11}, {it:n12}, {it:n21}, and {it:n22} represent a sample of
2 × 2 tables from all studies.  We will thus refer to observations on these
variables as 2 × 2 tables and to values of these variables as cells.

{marker cont_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:options_continuous}
{synoptline}
{syntab:Main}
{synopt :{opth es:ize(meta_esize##esspeccnt:esspeccnt)}}specify effect size for
continuous outcome to be used in the meta-analysis{p_end}

{syntab:Model}
{synopt :{opt random}[{cmd:(}{help meta_esize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis; default is {cmd:random(reml)}{p_end}
{synopt :{opt common}}common-effect meta-analysis; implies inverse-variance method{p_end}
{synopt :{opt fixed}}fixed-effects meta-analysis; implies inverse-variance method{p_end}
{synoptline}

{marker bin_options}{...}
{synopthdr:options_binary}
{synoptline}
{syntab:Main}
{synopt :{opth es:ize(meta_esize##estypebin:estypebin)}}specify effect size for
binary outcome to be used in the meta-analysis

{syntab:Model}
{synopt :{opt random}[{cmd:(}{help meta_esize##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis; default is {cmd:random(reml)}{p_end}
{synopt :{opt common}[{cmd:(}{help meta_esize##cefemethod:{it:cefemethod}}{cmd:)}]}common-effect meta-analysis{p_end}
{synopt :{opt fixed}[{cmd:(}{help meta_esize##cefemethod:{it:cefemethod}}{cmd:)}]}fixed-effects meta-analysis{p_end}

{syntab:Options}
{synopt :{opth zerocells:(meta_esize##zcspec:zcspec)}}adjust for zero cells
during computation; default is to add 0.5 to all cells of those 2 x 2 tables
that contain zero cells{p_end}
{synoptline}

{marker optstbl}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt :{opth studylab:el(varname)}}variable to be used to label studies in all meta-analysis output{p_end}
{synopt :{opth eslab:el(strings:string)}}effect-size label to be used in all meta-analysis output; default is {cmd:eslabel(Effect Size)}{p_end}
{synopt :{opt l:evel(#)}}confidence level for all subsequent meta-analysis commands{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings with other
{cmd:meta} commands{p_end}
{synoptline}

{marker esspeccnt}{...}
{pstd}
The syntax of {it:esspeccnt} is

{pmore2}
{help meta_esize##estypecnt:{it:estypecnt}}{cmd:,}
{help meta_esize##esopts:{it:esopts}}

{synoptset 22}{...}
INCLUDE help meta_estypecnt

INCLUDE help meta_estypebin

INCLUDE help meta_remethod

INCLUDE help meta_cefemethod


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta esize} computes effect sizes from study summary data and uses the
results to declare the data in memory to be {cmd:meta} data, informing Stata
of key variables and their roles in a meta-analysis.  It computes various
effect sizes and their respective standard errors for two-group comparisons of
continuous and binary outcomes.  It then uses the computed effect sizes and
standard errors to declare the data in memory to be {cmd:meta} data.  If you do
not have the summary data from individual studies and, instead, you have
precalculated effect sizes, you can use {helpb meta set} to declare your
meta-analysis data.  You must use {cmd:meta esize} or {cmd:meta set} to
perform meta-analysis using the {cmd:meta} command; see
{manlink META meta data}.

{pstd}
If you need to update some of the meta settings after the data
declaration, see {manhelp meta_update META:meta update}.  To display current
meta settings, use {cmd:meta query}; see
{manhelp meta_update META:meta update}.
 

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaesizeQuickstart:Quick start}

        {mansection META metaesizeRemarksandexamples:Remarks and examples}

        {mansection META metaesizeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker esopts}{...}
{phang}
{opt esize(esspec)} specifies the effect size to be used in the meta-analysis.
For continuous outcomes, {it:esspec} is
{help meta_esize##estypecntdes:{it:estypecnt}}[{cmd:,}
{help meta_esize##esopts:{it:esopts}}].  For binary outcomes, {it:esspec}
is {help meta_esize##estypebindes:{it:estypebin}}.

{marker estypecntdes}{...}
{pmore}
For continuous outcomes, {it:estypecnt} is one of the following: {cmd:hedgesg},
{cmd:cohend}, {cmd:glassdelta2}, {cmd:glassdelta1}, or {cmd:mdiff}.  Below, we
describe each type with its specific options, {it:esopts}.

{phang3}
{cmd:hedgesg}[{cmd:,} {cmd:exact holkinse}] computes the effect size as the
Hedges's g ({help meta_esize##hedges1981:1981}) standardized mean difference.
This is the default for continuous outcomes.  For consistency with meta-analysis
literature, {cmd:hedgesg} uses an approximation to compute g rather than the
exact computation (see
{mansection META metaesizeMethodsandformulas:{it:Methods and formulas}}
in {bf:[META] meta esize}), as provided by {cmd:esize}'s option {cmd:hedgesg}.
You can use the {cmd:exact} suboption to match the results from {cmd:esize}
(see {manhelp esize R}).

{phang3}
{cmd:cohend}[{cmd:,} {cmd:holkinse}]  computes the effect size as the Cohen's d
({help meta_esize##cohen1969:1969}, {help meta_esize##cohen1988:1988})
standardized mean difference.

{phang3}
{cmd:glassdelta2} computes the effect size as the Glass's ∆ standardized mean
difference, where the standardization uses the standard deviation of the group
2 (control group).  {cmd:glassdelta2} is more common in practice than
{cmd:glassdelta1}.

{phang3}
{cmd:glassdelta1} computes the effect size as the Glass's ∆ standardized mean
difference, where the standardization uses the standard deviation of the group
1 (treatment group).  {cmd:glassdelta2} is more common in practice than
{cmd:glassdelta1}.

{phang3}
{cmd:mdiff}[{cmd:,} {cmd:unequal}] computes the effect size as the
unstandardized or raw mean difference.

{pmore}
{it:esopts} are {cmd:exact}, {cmd:holkinse}, and {cmd:unequal}.

{phang3}
{cmd:exact} specifies that the exact computation be used for the
bias-correction factor in Hedges's g instead of an approximation used by
default.

{phang3}
{cmd:holkinse} specifies that the standard error of Hedges's g and Cohen's d be
computed as described in
{help meta_esize##hedgesolkin1985:Hedges and Olkin (1985)}.  This is another
approximation to the standard error of these effect sizes sometimes used in
practice.

{phang3}
{cmd:unequal} specifies that the computation of the standard error of the mean
difference ({cmd:esize(mdiff)}) assume unequal group variances.

{marker estypebindes}{...}
{pmore}
For binary outcomes, {it:estypebin} is one of the following:
{cmd:lnoratio}, {cmd:lnrratio}, {cmd:rdiff}, or {cmd:lnorpeto}.

{phang3}
{cmd:lnoratio} specifies that the effect size be the log odds-ratio.  This is
the default for binary outcomes.

{phang3}
{cmd:lnrratio} specifies that the effect size be the log risk-ratio, also known
as a log relative-risk and a log risk-rate.

{phang3}
{cmd:rdiff} specifies that the effect size be the risk difference.

{phang3}
{cmd:lnorpeto} specifies that the effect size be the log odds-ratio as defined
by {help meta_esize##petoetal1977:Peto et al. (1977)}.  This effect size is
preferable with rare events.

{pmore}
For effect sizes in the log metric such as log odds-ratios, the results by
default are displayed in the log metric.  You can use
{help meta_summarize##eform_option:{it:eform_option}} to obtain
exponentiated results such as odds ratios.

{dlgtab:Model}
 
{pstd}
Options {cmd:random()}, {cmd:common()}, and {cmd:fixed()} declare the
meta-analysis model globally throughout the entire meta-analysis; see
{mansection META metadataRemarksandexamplesDeclaringameta-analysismodel:{it:Declaring a meta-analysis model}}
in {bf:[META] meta data}.  In other words, once you set your meta-analysis model
using {cmd:meta esize}, all subsequent {cmd:meta} commands will assume that
same model.  You can update the declared model by using
{helpb meta update} or change it temporarily by specifying the corresponding
option with the {cmd:meta} commands.  Options {cmd:random()}, {cmd:common()},
and {cmd:fixed()} may not be combined.  If these options are omitted,
{cmd:random(reml)} is assumed; see
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
{cmd:dlaird}, {cmd:sjonkman}, {cmd:hedges}, or {cmd:hschmidt}.  {cmd:random}
is a synonym for {cmd:random(reml)}.  Below, we provide a short description
for each method based on
{help meta_esize##veronikietal2016:Veroniki et al. (2016)}.  Also see
{mansection META metadataRemarksandexamplesDeclaringameta-analysisestimationmethod:{it:Declaring a meta-analysis estimation method}}
in {bf:[META] meta data}.

{phang3}
{cmd:reml}, the default, specifies that the REML method
({help meta_esize##raudenbush2009:Raudenbush 2009}) be used to estimate τ^2.
This method produces an unbiased, nonnegative estimate of the between-study
variance and is commonly used in practice.  Method {cmd:reml} requires
iteration.

{phang3}
{cmd:mle} specifies that the ML method
({help meta_esize##hardythompson1996:Hardy and Thompson 1996}) be used to
estimate τ^2.  It produces a nonnegative estimate of the between-study
variance.  With a few studies or small studies, this method may produce biased
estimates.  With many studies, the ML method is more efficient than the REML
method.  Method {cmd:mle} requires iteration.

{phang3}
{cmd:ebayes} specifies that the empirical Bayes estimator
({help meta_esize##berkeyetal1995:Berkey et al. 1995}), also known as the
Paule–Mandel estimator
({help meta_esize##paulemandel1982:Paule and Mandel 1982}), be used to estimate
τ^2.  From simulations, this method, in general, tends to be less biased than
other random-effects methods, but it is also less efficient than {cmd:reml} or
{cmd:dlaird}.  Method {cmd:ebayes} produces a nonnegative estimate of τ^2 and
requires iteration.

{phang3}
{cmd:dlaird} specifies that the DerSimonian–Laird method
({help meta_esize##dersimonianlaird1986:DerSimonian and Laird 1986}) be used to
estimate τ^2.  This method, historically, is one of the most popular estimation
methods because it does not make any assumptions about the distribution of
random effects and does not require iteration.  But it may underestimate the
true between-study variance, especially when the variability is large and the
number of studies is small.  This method may produce a negative value of τ^2
and is thus truncated at zero in that case.

{phang3}
{cmd:sjonkman} specifies that the Sidik–Jonkman method
({help meta_esize##sidikjonkman2005:Sidik and Jonkman 2005}) be used to
estimate τ^2.  This method always produces a nonnegative estimate of the
between-study variance and thus does not need truncating at 0, unlike the other
noniterative methods.  Method {cmd:sjonkman} does not require iteration.

{phang3}
{cmd:hedges} specifies that the Hedges method
({help meta_esize##hedges1983:Hedges 1983}) be used to estimate τ^2.  When the
sampling variances of effect-size estimates can be estimated without bias, this
estimator is exactly unbiased (before truncation), but it is not widely used in
practice ({help meta_esize##veronikietal2016:Veroniki et al. 2016}).  Method
{cmd:hedges} does not require iteration.

{phang3}
{cmd:hschmidt} specifies that the Hunter–Schmidt method
({help meta_esize##schmidthunter2015:Schmidt and Hunter 2015}) be used to
estimate τ^2.  Although this estimator achieves a lower MSE than other methods,
except ML, it is known to be negatively biased.  Method {cmd:hschmidt} does not
require iteration.

{phang}
{cmd:common} and {opth common:(meta_esize##ccefemethoddes:cefemethod)} specify
that a common-effect model be assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesCommon-effect(fixed-effect)model:{it:Common-effect ("fixed-effect") model}}
in {bf:[META] Intro}.  Also see the 
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{pmore}
{cmd:common} implies {cmd:common(mhaenszel)} for effect sizes {cmd:lnoratio},
{cmd:lnrratio}, and {cmd:rdiff} and {cmd:common(invvariance)} for all other
effect sizes.

{marker ccefemethoddes}{...}
{phang2}
{it:cefemethod} is one of {cmd:mhaenszel} or {cmd:invvariance} (synonym
{cmd:ivariance}).  Below, we provide a short description for each method.
Also see
{mansection META metadataRemarksandexamplesDeclaringameta-analysisestimationmethod:{it:Declaring a meta-analysis estimation method}}
in {bf:[META] meta data}.

{phang3}
{cmd:mhaenszel} is available only for binary outcomes.  It specifies a
meta-analysis using the Mantel–Haenszel method to estimate the overall effect
size for binary outcomes.  This method is the default for effect sizes
{cmd:lnoratio}, {cmd:lnrratio}, and {cmd:rdiff} but is not available for effect
size {cmd:lnorpeto}.

{phang3}
{cmd:invvariance} specifies a meta-analysis using the inverse-variance method
to estimate the overall effect size.  This method is available for all types
of outcomes and effect sizes and is the default for continuous outcomes and
for binary outcomes using effect size {cmd:lnorpeto}.

{phang3}
{cmd:ivariance} is a synonym for {cmd:invvariance}.

{phang}
{cmd:fixed} and {opth fixed:(meta_esize##fcefemethoddes:cefemethod)} specify that a fixed-effects model be
assumed for meta-analysis; see
{mansection META IntroRemarksandexamplesFixed-effectsmodel:{it:Fixed-effects model}}
in {bf:[META] Intro}.  Also see the
{mansection META metadataRemarksandexamplesfixedvscommon:discussion}
in {bf:[META] meta data} about common-effect versus fixed-effects models.

{pmore}
{cmd:fixed} implies {cmd:fixed(mhaenszel)} for effect sizes {cmd:lnoratio},
{cmd:lnrratio}, and {cmd:rdiff} and {cmd:fixed(invvariance)} for all other
effect sizes.

{marker fcefemethoddes}{...}
{phang2}
{it:cefemethod} is one of {cmd:mhaenszel} or {cmd:invvariance} (synonym
{cmd:ivariance}); see descriptions {help meta_esize##ccefemethoddes:above}.

{dlgtab:Options}

{marker zcspec}{...}
{phang}
{opt zerocells(zcspec)} is for use with binary outcomes when the effect size is
either {cmd:lnoratio} or {cmd:lnrratio}.  It specifies the adjustment to be
used for the cells, the values of variables
{help meta_esize##n11:{it:n11}}, {help meta_esize##n11:{it:n12}},
{help meta_esize##n11:{it:n21}}, and {help meta_esize##n11:{it:n22}},
when there are zero cells.  The adjustment is applied during computation -- the
original data are not modified.  The default is {cmd:zerocells(0.5, only0)}; it
adds 0.5 to all cells of 2 x 2 tables that contain at least one zero cell.  To
request no adjustment, specify {cmd:zerocells(none)}.  More generally, the
syntax of {it:zcspec} is

            {it:#}[{cmd:,} {it:zcadj}]

{pmore}
where {it:#} is the adjustment value, also known as the continuity-correction
value in the meta-analysis literature, and {it:zcadj} is {cmd:only0} or
{cmd:allif0}.

{phang2}
{cmd:only0} specifies that {it:#} be added to all cells of only those 2 x 2
tables that contain at least one zero cell.  That is, during computation,
{it:#} is added to each observation defined by variables
{help meta_esize##n11:{it:n11}}, {help meta_esize##n11:{it:n12}},
{help meta_esize##n11:{it:n21}}, and {help meta_esize##n11:{it:n22}}
if that observation contains a value of zero in any of those variables.

{phang2}
{cmd:allif0} specifies that {it:#} be added to all cells of all 2 x 2 tables
but only if there is at least one 2 × 2 table with a zero cell.  That is,
during computation, {it:#} is added to all values of variables
{help meta_esize##n11:{it:n11}}, {help meta_esize##n11:{it:n12}},
{help meta_esize##n11:{it:n21}}, and {help meta_esize##n11:{it:n22}}
but only if there is a zero value in one of the four variables.

{pmore}
For the effect size {cmd:lnoratio}, {it:zcspec} may also be {cmd:tacc}, which
implements the treatment-arm continuity correction of
{help meta_esize##sweetingsuttonlambert2004:Sweeting, Sutton, and Lambert (2004)}.
This method estimates the group-specific adjustment values from the data to
minimize the bias of the overall odds-ratio estimator in the presence of zero
cells.  This method is recommended when the groups are unbalanced.

{phang}
{opth studylabel(varname)} specifies a string variable containing labels for the
individual studies to be used in all applicable meta-analysis output.  The
default study labels are {cmd:Study 1}, {cmd:Study 2}, ..., {cmd:Study} K,
where K is the total number of studies in the meta-analysis.

{phang}
{opth eslabel:(strings:string)} specifies that {it:string} be used as the
effect-size label in all relevant meta-analysis output.  The default label is
{cmd:Effect Size}.

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
{phang2}{cmd:. webuse metaesbin}{p_end}

{pstd}Compute log odds-ratios, their standard errors, and CIs based on 2 x 2
summary tables{p_end}
{phang2}{cmd:. meta esize tdead tsurv cdead csurv}

{pstd}As above, but request a Mantel–Haenszel common-effect method{p_end}
{phang2}{cmd:. meta esize tdead tsurv cdead csurv, common(mhaenszel)}

{pstd}Compute log risk-ratios and specify study labels{p_end}
{phang2}{cmd:. meta esize tdead tsurv cdead csurv, esize(lnrratio)}
           {cmd:studylabel(study)}

{pstd}Request the treatment-arm continuity correction (TACC) to adjust for
zero cells{p_end}
{phang2}{cmd:. meta esize tdead tsurv cdead csurv, zerocells(tacc)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metaescnt, clear}

{pstd}Compute Hedges's g mean standardized differences, their standard errors,
and CIs based on sample sizes, means and standard deviations{p_end}
{phang2}{cmd:. meta esize n1 m1 sd1 n2 m2 sd2}

{pstd}As above, but compute Cohen's d mean standardized differences{p_end}
{phang2}{cmd:. meta esize n1 m1 sd1 n2 m2 sd2, esize(cohend)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta esize} stores the following characteristics and system variables:

{synoptset 28 tabbed}{...}
{p2col 5 28 32 2: Characteristics}{p_end}
{synopt:{cmd:_dta[_meta_marker]}}"{cmd:_meta_ds_1}"{p_end}
{synopt:{cmd:_dta[_meta_K]}}number of studies in the meta-analysis{p_end}
{synopt:{cmd:_dta[_meta_studylabel]}}name of string variable containing study labels or {cmd:Generic}{p_end}
{synopt:{cmd:_dta[_meta_estype]}}type of effect size; varies{p_end}
{synopt:{cmd:_dta[_meta_eslabelopt]}}{opt eslabel(eslab)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_eslabel]}}effect-size label from {opt eslabel()}; default varies{p_end}
{synopt:{cmd:_dta[_meta_eslabeldb]}}effect-size label for dialog box{p_end}
{synopt:{cmd:_dta[_meta_esvardb]}}{cmd:_meta_es}{p_end}
{synopt:{cmd:_dta[_meta_level]}} default confidence level for meta-analysis{p_end}
{synopt:{cmd:_dta[_meta_esizeopt]}}{opt esize(estype)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_esopt_exact]}}{cmd:exact}, if {cmd:esize(, exact)} is specified{p_end}
{synopt:{cmd:_dta[_meta_esopt_holkinse]}}{cmd:holkinse}, if {cmd:esize(, holkinse)} is specified{p_end}
{synopt:{cmd:_dta[_meta_esopt_unequal]}}{cmd:unequal}, if {cmd:esize(, unequal)} is specified{p_end}
{synopt:{cmd:_dta[_meta_modellabel]}}meta-analysis model label: {cmd:Random-effects}, {cmd:Common-effect}, or {cmd:Fixed-effects}{p_end}
{synopt:{cmd:_dta[_meta_model]}}meta-analysis model: {cmd:random}, {cmd:common}, or {cmd:fixed}{p_end}
{synopt:{cmd:_dta[_meta_methodlabel]}}meta-analysis method label; varies by meta-analysis model{p_end}
{synopt:{cmd:_dta[_meta_method]}}meta-analysis method; varies by meta-analysis model{p_end}
{synopt:{cmd:_dta[_meta_randomopt]}}{opt random(remethod)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_zcopt]}}{opt zerocells(zcspec)}, if specified{p_end}
{synopt:{cmd:_dta[_meta_zcadj]}}type of adjustment for zero cells, if {cmd:zerocells()} specified{p_end}
{synopt:{cmd:_dta[_meta_zcvalue]}}value added to cells to adjust for zero cells, if specified{p_end}
{synopt:{cmd:_dta[_meta_show]}}empty or {cmd:nometashow}{p_end}
{synopt:{cmd:_dta[_meta_n1var]}}name of group 1 sample-size variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_mean1var]}}name of group 1 mean variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_sd1var]}}name of group 1 std. dev. variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_n2var]}}name of group 2 sample-size variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_mean2var]}}name of group 2 mean variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_sd2var]}}name of group 2 std. dev. variable; for continuous data{p_end}
{synopt:{cmd:_dta[_meta_n11var]}}name of {help meta_esize##n11:{it:n11}} variable; for binary data{p_end}
{synopt:{cmd:_dta[_meta_n12var]}}name of {help meta_esize##n11:{it:n12}} variable; for binary data{p_end}
{synopt:{cmd:_dta[_meta_n21var]}}name of {help meta_esize##n11:{it:n21}} variable; for binary data{p_end}
{synopt:{cmd:_dta[_meta_n22var]}}name of {help meta_esize##n11:{it:n22}} variable; for binary data{p_end}
{synopt:{cmd:_dta[_meta_datatype]}}data type; {cmd:continuous} or {cmd:binary}{p_end}
{synopt:{cmd:_dta[_meta_datavars]}}variables specified with {cmd:meta esize}{p_end}
{synopt:{cmd:_dta[_meta_setcmdline]}}{cmd:meta esize} command line{p_end}
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

{marker cohen1969}{...}
{phang}
Cohen, J. 1969. {it:Statistical Power Analysis for the Behavioral Sciences}.
New York: Academic Press.

{marker cohen1988}{...}
{phang}
--------. 1988. {it:Statistical Power Analysis for the Behavioral Sciences}.
2nd ed. Hillsdale, NJ: Erlbaum.

{marker dersimonianlaird1986}{...}
{phang}
DerSimonian, R., and N. Laird. 1986. Meta-analysis in clinical trials.
{it:Controlled Clinical Trials} 7: 177–188.

{marker hardythompson1996}{...}
{phang}
Hardy, R. J., and S. G. Thompson. 1996. A likelihood approach to meta-analysis
with random effects.
{it:Statistics in Medicine} 15: 619–629.

{marker hedges1981}{...}
{phang}
Hedges, L. V. 1981. Distribution theory for Glass's estimator of effect size
and related estimators. {it:Journal of Educational Statistics} 6: 107–128.

{marker hedges1983}{...}
{phang}
------. 1983. A random effects model for effect sizes.
{it:Psychological Bulletin} 93: 388–395.

{marker hedgesolkin1985}{...}
{phang}
Hedges, L. V., and I. Olkin. 1985. {it:Statistical Methods for Meta-Analysis}.
Orlando, FL: Academic Press.

{marker paulemandel1982}{...}
{phang}
Paule, R. C., and J. Mandel. 1982. Consensus values and weighting factors.
{it:Journal of Research of the National Bureau of Standards} 87: 377–385.

{marker petoetal1977}{...}
{phang}
Peto, R., M. C. Pike, P. Armitage, N. E. Breslow, D. R. Cox, S. V. Howard, N.
Mantel, K. McPherson, J. Peto, and P. G. Smith. 1977. Design and analysis of
randomized clinical trials requiring prolonged observation of each patient. II.
Analysis and examples. {it:British Journal of Cancer} 35: 1–39.

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

{marker sweetingsuttonlambert2004}{...}
{phang}
Sweeting, M. J., A. J. Sutton, and P. C. Lambert. 2004. What to add to nothing?
Use and avoidance of continuity corrections in meta-analysis of sparse data.
{it:Statistics in Medicine} 23: 1351–1375.

{marker veronikietal2016}{...}
{phang}
Veroniki, A. A., D. Jackson, W. Viechtbauer, R. Bender, J. Bowden, G. Knapp,
O. Kuss, J. P. T. Higgins, D. Langan, and G. Salanti. 2016.
Methods to estimate the between-study variance and its uncertainty in
meta-analysis. {it:Research Synthesis Methods} 7: 55–79.
{p_end}
