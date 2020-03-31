{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta labbeplot" "mansection META metalabbeplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "[META] meta esize" "help meta esize"}{...}
{vieweralsosee "[META] meta regress" "help meta regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Syntax" "meta_labbeplot##syntax"}{...}
{viewerjumpto "Menu" "meta_labbeplot##menu"}{...}
{viewerjumpto "Description" "meta_labbeplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_labbeplot##linkspdf"}{...}
{viewerjumpto "Options" "meta_labbeplot##options"}{...}
{viewerjumpto "Examples" "meta_labbeplot##examples"}{...}
{viewerjumpto "Stored results" "meta_labbeplot##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[META] meta labbeplot} {hline 2}}L'Abb{c e'} plots{p_end}
{p2col:}({mansection META metalabbeplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:meta} {cmdab:labbe:plot}
{ifin} [{cmd:,} {it:options}]

{marker optstbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:random}[{cmd:(}{help meta_labbeplot##remethod:{it:remethod}}{cmd:)}]}random-effects meta-analysis{p_end}
{synopt :{cmd:common}[{cmd:(}{help meta_labbeplot##cefemethod:{it:cefemethod}}{cmd:)}]}common-effect meta-analysis{p_end}
{synopt :{cmd:fixed}[{cmd:(}{help meta_labbeplot##cefemethod:{it:cefemethod}}{cmd:)}]}fixed-effects meta-analysis{p_end}
{synopt :{opt reweight:ed}}make bubble size depend on random-effects weights{p_end}
{synopt :[{cmd:no}]{cmd:metashow}}display or suppress meta settings in the output{p_end}
{synopt :{help meta_labbeplot##graphopts:{it:graph_options}}}affect rendition of overall L'Abb{c e'} plot{p_end}
{synoptline}

{synoptset 22}{...}
INCLUDE help meta_remethod

INCLUDE help meta_cefemethod

{marker graphopts}{...}
{synoptset 22 tabbed}{...}
{synopthdr:graph_options}
{synoptline}
{syntab:RL options}
{synopt :{opth rlop:ts(line_options)}}affect rendition of the plotted reference line indicating no effect{p_end}

{syntab:ES options}
{synopt :{opth esop:ts(line_options)}}affect rendition of the plotted estimated effect-size line{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the contour plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in {manhelp twoway_options G-3:twoway_options}{p_end}
{synoptline}


INCLUDE help menu_meta


{marker description}{...}
{title:Description}

{pstd}
{cmd:meta labbeplot} produces L'Abb{c e'} plots for a meta-analysis that
compares the binary outcomes of two groups. These plots are useful for
assessing heterogeneity and comparing study-specific event rates in the two
groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metalabbeplotQuickstart:Quick start}

        {mansection META metalabbeplotRemarksandexamples:Remarks and examples}

        {mansection META metalabbeplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{pstd}
Options {cmd:random()}, {cmd:common()}, and {cmd:fixed()} specify a
meta-analysis model to use when estimating the overall effect size.  For
historical reasons, the default is {cmd:common(invvariance)}, regardless of
the global model declared by {helpb meta esize}.  Specify one of these options
with {cmd:meta labbeplot} to override this default.  Options {cmd:random()},
{cmd:common()}, and {cmd:fixed()} may not be combined.  Also see
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
is a synonym for {cmd:random(reml)}.  See
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
{cmd:common} implies {cmd:common(mhaenszel)}.

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
{cmd:fixed} implies {cmd:fixed(mhaenszel)}.

{marker fcefemethoddes}{...}
{phang2}
{it:cefemethod} is one of {cmd:mhaenszel} or {cmd:invvariance} (synonym
{cmd:ivariance}).  See {help meta_summarize##options:{it:Options}} in
{helpb meta_esize:[META] meta esize} for more information.

{phang}
{cmd:reweighted} is used with random-effects meta-analysis.  It specifies that
the sizes of the bubbles be proportional to the weights from the
random-effects meta-analysis, w^*_j = 1/(σ^2_j + τ^2 ).  By default, the sizes
are proportional to the precision of each study, w_j = 1/σ^2_j.

{phang}
{cmd:metashow} and {cmd:nometashow} display or suppress the meta setting
information.  By default, this information is displayed at the top of the
output.  You can also specify {cmd:nometashow} with {helpb meta update} to
suppress the meta setting output for the entire meta-analysis session.

{dlgtab:RL options}
 
{phang}
{opt rlopts(line_options)} affects the rendition of the plotted reference
(diagonal) line that indicates no effect of the intervention or treatment; see
{manhelpi line_options G-3}.

{dlgtab:ES options}
 
{phang}
{opt esopts(line_options)} affects the rendition of the dashed line that plots
the estimated overall effect size; see {manhelpi line_options G-3}.
 
{dlgtab:Add plots}
 
{phang} {opt addplot(plot)} allows adding more graph twoway plots to the
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}
 
{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the graph
to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgset}{p_end}

{pstd}Construct a L'Abb{c e'} plot{p_end}
{phang2}{cmd:. meta labbeplot}

{pstd}As above, but specify that study-marker sizes be proportional to weights
from a REML random-effects model instead of the default common-effect
model{p_end}
{phang2}{cmd:. meta labbeplot, random(reml) reweighted}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:meta labbeplot} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(theta)}}estimated overall effect size{p_end}
{synopt:{cmd:r(xmin)}}minimum value in the control group (x axis){p_end}
{synopt:{cmd:r(xmax)}}maximum value in the control group{p_end}
{synopt:{cmd:r(ymin)}}minimum value in the treatment group (y axis){p_end}
{synopt:{cmd:r(ymax)}}maximum value in the treatment group{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(model)}}meta-analysis model{p_end}
{synopt:{cmd:r(method)}}meta-analysis estimation method{p_end}
{p2colreset}{...}
