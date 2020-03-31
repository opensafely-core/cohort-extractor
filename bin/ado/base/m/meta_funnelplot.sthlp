{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta funnelplot" "mansection META metafunnelplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta bias" "help meta bias"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta trimfill" "help meta trimfill"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_funnelplot##syntax"}{...}
{viewerjumpto "Menu" "meta_funnelplot##menu"}{...}
{viewerjumpto "Description" "meta_funnelplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_funnelplot##linkspdf"}{...}
{viewerjumpto "Options" "meta_funnelplot##options"}{...}
{viewerjumpto "Examples" "meta_funnelplot##examples"}{...}
{viewerjumpto "Stored results" "meta_funnelplot##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[META] meta funnelplot} {hline 2}}Funnel plots{p_end}
{p2col:}({mansection META metafunnelplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Construct a funnel plot

{p 8 16 2}
{cmd:meta} {cmdab:funnel:plot}
{ifin}
[{cmd:,} {opt level(#)}
{help meta_funnelplot##optstbl:{it:options}}]


{pstd}
Construct a contour-enhanced funnel plot

{p 8 16 2}
{cmd:meta} {cmdab:funnel:plot}
{ifin}{cmd:,}
{opth contours:(meta_funnelplot##contourspec:contourspec)}
[{help meta_funnelplot##optstbl:{it:options}}]


{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmd:random}[{cmd:(}{help meta_funnelplot##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{cmd:common}[{cmd:(}{help meta_funnelplot##cefemethod:{it:cefemethod}}{cmd:)}]}common-effect meta-analysis{p_end}
{synopt :{cmd:fixed}[{cmd:(}{help meta_funnelplot##cefemethod:{it:cefemethod}}{cmd:)}]}fixed-effects meta-analysis{p_end}

{syntab:Options}
{synopt :{helpb by_option:by({it:varlist}, ...)}}construct a separate plot for each group formed by {it:varlist}{p_end}
{synopt :{opth metric:(meta_funnelplot##metric:metric)}}specify y-axis metric; default is {cmd:metric(se)}{p_end}
{synopt :{opt n(#)}}evaluate CI lines or significance contours at {it:#} points; default is {cmd:n(300)}{p_end}
{synopt :[{cmd:no}]{opt metashow}}display or suppress meta settings in the output{p_end}
{synopt :{help meta_funnelplot##graphopts:{it:graph_options}}}affect rendition of overall funnel plot{p_end}
{synoptline}

{synoptset 22}{...}
INCLUDE help meta_remethod

INCLUDE help meta_cefemethod

{marker graphopts}{...}
{synoptset 22 tabbed}{...}
{synopthdr:graph_options}
{synoptline}
{syntab:ES line}
{synopt :{opth esop:ts(line_options)}}affect rendition of estimated effect-size line{p_end}

{syntab:CI plot}
{p2coldent:∗ {opth ciop:ts(meta_funnelplot##ciopts:ciopts)}}affect rendition of the confidence intervals{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the funnel plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options documented in {manhelp twoway_options G-3:twoway_options}{p_end}
{synoptline}
{p 4 6 2}
∗ {opt ciopts(ciopts)} is not available for a contour-enhanced funnel plot.


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta funnelplot} produces funnel plots, which are used to
explore the presence of
{help meta_glossary##small_study_effects:small-study effects}
often associated with publication bias.  A funnel plot is a scatterplot of
study-specific effect sizes on the x axis against the measures of study
precision such as standard errors and inverse standard errors on the y axis.
In the absence of small-study effects, the plot should look symmetrical.
{cmd:meta funnelplot} can also draw contour-enhanced funnel plots, which are
useful for investigating whether the plot asymmetry can be attributed to
publication bias.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metafunnelplotQuickstart:Quick start}

        {mansection META metafunnelplotRemarksandexamples:Remarks and examples}

        {mansection META metafunnelplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker contourspec}{...}
{phang}
{opt contours(contourspec)} specifies that a contour-enhanced funnel plot be
plotted instead of the default standard funnel plot; see
{mansection META metafunnelplotRemarksandexamplesContour-enhancedfunnelplots:{it:Contour-enhanced funnel plots}}
in {bf:[META] meta funnelplot}.  This option may not be combined with options
{cmd:ciopts()} and {cmd:level()}.

{pmore}
{it:contourspec} is {it:{help numlist}}[{cmd:,} {cmd:lower} {cmd:upper} {cmd:lines} {help meta_funnelplot##cgraphopts:{it:graph_options}}].
{it:numlist} specifies the levels of significance (as percentages) and
may contain no more than 8 integer values between 1 and 50.

{phang3}
{cmd:lower} and {cmd:upper} specify that the significance contours be based on
one-sided lower- or upper-tailed z tests of individual effect sizes.  In other
words, the studies in the shaded area of a specific contour c are considered
not statistically significant based on one-sided lower- or upper-tailed z tests
with α = c/100.  By default, the contours correspond to the two-sided z tests.

{phang3}
{cmd:lines} specifies that only the contours lines be plotted.  That is, no
shaded regions will be displayed.

{marker cgraphopts}{...}
{phang3}
{it:graph_options} are any of the options documented in
{manhelpi area_options G-3} except {cmd:recast()} or, if option {cmd:lines} is
specified, any of the options documented in {manhelpi line_options G-3}.

{dlgtab:Model}
 
{pstd}
Options {cmd:random()}, {cmd:common()}, and {cmd:fixed()} specify a
meta-analysis model to use when estimating the overall effect size.  For
historical reasons, the default is {cmd:common(invvariance)}, regardless of the
global model declared by {helpb meta set} or {helpb meta esize}.  Specify one
of these options with {cmd:meta funnelplot} to override this default.  Options
{cmd:random()}, {cmd:common()}, and {cmd:fixed()} may not be combined.  Also
see {mansection META IntroRemarksandexamplesMeta-analysismodels:{it:Meta-analysis models}}
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

{dlgtab:Options}
 
{phang}
{cmd:by(}{varlist}[{cmd:,} {it:byopts}]{cmd:)} specifies that a separate plot
for each group defined by {it:varlist} be produced.  {it:byopts} are any of the
options documented in {manhelpi by_option G-3}.  {cmd:by()} is useful to
explore publication bias in the presence of between-study heterogeneity induced
by a set of categorical variables.  These variables must then be specified in
the {cmd:by()} option.

{marker metric}{...}
{phang}
{opt metric(metric)} specifies the precision metric on the y axis.  {it:metric}
is one of {cmd:se}, {cmd:invse}, {cmd:var}, {cmd:invvar}, {cmd:n}, or
{cmd:invn}.  When metric is one of {cmd:n} or {cmd:invn}, no CIs or
significance contours are plotted.  The default is {cmd:metric(se)}.

{phang2}
{cmd:se} specifies that the standard error, σ_j, be used as the precision
metric.

{phang2}
{cmd:invse} specifies that the inverse of the standard error, 1/σ_j, be used as
the precision metric.

{phang2}
{cmd:var} specifies that the variance, σ^2_j, be used as the precision metric.

{phang2}
{cmd:invvar} specifies that the inverse of the variance, 1/σ^2_j, be used as
the precision metric.

{phang2}
{cmd:n} specifies that the sample size, n_j, be used as the precision metric.

{phang2}
{cmd:invn} specifies that the inverse of the sample size, 1/n_j, be used as the
precision metric.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is as declared for the meta-analysis session; see
{mansection META metadataRemarksandexamplesDeclaringaconfidencelevelformeta-analysis:{it:Declaring a confidence level for meta-analysis}}
in {bf:[META] meta data}.  Also see option
{helpb meta_set##level:level()} in {helpb meta_set:[META] meta set}.
This option may not be combined with option {cmd:contours()}.

{phang}
{opt n(#)} specifies the number of points at which to evaluate the CIs or, if
option {cmd:contours()} is specified, significance contours.  The default is
{cmd:n(300)}.

{phang}
{opt metashow} and {opt nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {cmd:nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

{dlgtab:ES line}
 
{phang}
{opt esopts(line_options)} affects the rendition of the line that plots the
estimated overall effect size; see {manhelpi line_options G-3}.

{dlgtab:CI plot}

{marker ciopts}{...}
{phang}
{opt ciopts(ciopts)} affects the rendition of the (pseudo) CI lines in a funnel
plot.  {it:ciopts} are any of the options documented in
{manhelpi line_options G-3}and option {cmd:recast(rarea)} as described in
{manhelpi advanced_options G-3}.  This option may not be combined with option
{cmd:contours()}.

{dlgtab:Add plots}
 
{phang}
{opt addplot(plot)} allows adding more {cmd:graph twoway} plots to the graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}
 
{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}.  These include options for titling the graph
(see {manhelpi title_options G-3}) and for saving the graph to disk
(see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nsaidsset}{p_end}

{pstd}Construct a funnel plot{p_end}
{phang2}{cmd:. meta funnelplot}

{pstd}As above, but specify the inverse standard error as the precision metric
on the y axis{p_end}
{phang2}{cmd:. meta funnelplot, metric(invse)}

{pstd}Specify 1%, 5%, and 10% significance contours to produce a
contour-enhanced funnel plot{p_end}
{phang2}{cmd:. meta funnelplot, contours(1 5 10)}

{pstd}As above, but base the significance contours on a one-sided lower-tailed
z test{p_end}
{phang2}{cmd:. meta funnelplot, contours(1 5 10, lower)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pupiliqset, clear}

{pstd}Construct separate funnel plots for each group of variable {cmd:week1}
{p_end}
{phang2}{cmd:. meta funnelplot, by(week1)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta funnelplot} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(theta)}}estimated overall effect size{p_end}
{synopt:{cmd:r(xmin)}}minimum abscissa of scatter points{p_end}
{synopt:{cmd:r(xmax)}}maximum abscissa of scatter points{p_end}
{synopt:{cmd:r(ymin)}}minimum ordinate of scatter points{p_end}
{synopt:{cmd:r(ymax)}}maximum ordinate of scatter points{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(model)}}meta-analysis model{p_end}
{synopt:{cmd:r(method)}}meta-analysis estimation method{p_end}
{synopt:{cmd:r(metric)}}metric for the y axis{p_end}
{synopt:{cmd:r(contours)}}significance levels of contours{p_end}
{p2colreset}{...}
