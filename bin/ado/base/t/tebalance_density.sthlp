{smcl}
{* *! version 1.0.14  20sep2018}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance density" "mansection TE tebalancedensity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[TE] tebalance" "help tebalance"}{...}
{vieweralsosee "[TE] teffects aipw" "help teffects aipw"}{...}
{vieweralsosee "[TE] teffects ipw" "help teffects ipw"}{...}
{vieweralsosee "[TE] teffects ipwra" "help teffects ipwra"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{viewerjumpto "Syntax" "tebalance density##syntax"}{...}
{viewerjumpto "Menu" "tebalance density##menu"}{...}
{viewerjumpto "Description" "tebalance density##description"}{...}
{viewerjumpto "Links to PDF documentation" "tebalance_density##linkspdf"}{...}
{viewerjumpto "Options" "tebalance density##options"}{...}
{viewerjumpto "Example" "tebalance density##example"}{...}
{viewerjumpto "Stored results" "tebalance density##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[TE] tebalance density} {hline 2}}Covariate balance density{p_end}
{p2col:}({mansection TE tebalancedensity:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Density plots for the propensity score

{p 8 12 2}
{cmd:tebalance} {cmd:density} [{cmd:,} {it:options}]


{pstd}
Density plots for a covariate

{p 8 12 2}
{cmd:tebalance} {cmd:density} {it:varname} [{cmd:,} {it:options}]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:kernel(}{it:{help tebalance_density##kernel:kernel}}{cmd:)}}specify the kernel function; default is {cmd:kernel(epanechnikov)}{p_end}
{synopt :{cmdab:bw:idth(*}{it:#}{cmd:)}}rescale default bandwidth{p_end}
{synopt :{cmd:line}{it:#}{cmd:opts}{cmd:(}{it:{help line_options}}{cmd:)}}{cmd:twoway line} options for density line number {it:#}{p_end}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in {manhelpi twoway_options G-3}{p_end}
{synopt :{cmdab:byop:ts(}{it:{help by_option:byopts}}{cmd:)}}how subgraphs are combined, labeled, etc.{p_end}
{synoptline}

{synoptset 17}{...}
{marker kernel}{...}
{synopthdr:kernel}
{synoptline}
{synopt :{cmdab:tri:angle}}triangle kernel function; the default{p_end}
{synopt :{cmdab:ep:anechnikov}}Epanechnikov kernel function{p_end}
{synopt :{cmd:epan2}}alternative Epanechnikov kernel function{p_end}
{synopt :{cmdab:bi:weight}}biweight kernel function{p_end}
{synopt :{cmdab:cos:ine}}cosine trace kernel function{p_end}
{synopt :{cmdab:gau:ssian}}Gaussian kernel function{p_end}
{synopt :{cmdab:par:zen}}Parzen kernel function{p_end}
{synopt :{cmdab:rec:tangle}}rectangle kernel function{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Balance > Graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tebalance density} produces kernel density plots that are used to
check for covariate balance after estimation by a {helpb teffects}
inverse-probability-weighted estimator, a {cmd:teffects} matching
estimator, or an {helpb stteffects} inverse-probability-weighted
estimator.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE tebalancedensityQuickstart:Quick start}

        {mansection TE tebalancedensityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:kernel(}{it:{help tebalance_density##kernel:kernel}}{cmd:)}
specifies the kernel function for use in calculating the kernel density
estimates.  The default kernel is the {cmd:kernel(epanechnikov)}.

{phang}
{cmd:bwidth(*}{it:#}{cmd:)} specifies the factor by which the default
bandwidths are to be rescaled.  A bandwidth is the half-width of the
kernel, the width of the density window around each point.  Each kernel
density plot has its own bandwidth, and by default, each kernel density
plot uses its own optimal bandwidth; see {manhelp kdensity R}.
{cmd:bwidth()} rescales each plot's optimal bandwidth by the specified
amount.

{phang}
{cmd:line}{it:#}{cmd:opts}{cmd:(}{it:{help line_options}}{cmd:)} specifies the
line pattern, width, color, and overall style of density line number
{it:#}.  The line numbers are in the same order as the treatment levels
specified in {cmd:e(tlevels)}.

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include
options for titling the graph (see {manhelpi title_options G-3}) and for
saving the graph to disk (see {manhelpi saving_option G-3}).
{cmd:tebalance density} uses {cmd:by()} to differentiate between raw and
weighted or matched samples, and some {it:twoway_options} will be
repeated for by {cmd:graph} and might be better specified as
{cmd:byopts()}.

{phang}
{cmd:byopts(}{it:by_option}{cmd:)} is as documented in 
{manhelpi by_options G-3}.  {cmd:byopts()} affects how the subgraphs are
combined, labeled, etc.  {cmd:byopts()} generally affects the entire
graph, and some {it:by_option} may be better specified as
{it:twoway_options}; see {manhelpi twoway_options G-3}.


{marker example}{...}
{title:Example}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the effect of a mother's smoking behavior ({cmd:mbsmoke}) on
the birthweight of her child ({cmd:bweight}), controlling for marital
status ({cmd:mmarried}), the mother's age ({cmd:mage}), whether the
mother had a prenatal doctor's visit in the baby's first trimester
({cmd:prenatal1}), and whether this baby is the mother's first child
({cmd:fbaby}){p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried mage prenatal1 fbaby), generate(matchv)}

{pstd}
Look at the default density plots
{p_end}
{phang2}{cmd:. tebalance density mage}


{marker results}{...}
{title:Stored results}

{pstd}
After {cmd:teffects} or {cmd:stteffects} fits a binary treatment,
{cmd:tebalance density} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 24 28 2:Scalars}{p_end}
{synopt :{cmd:r(bwc_adj)}}bandwidth for control in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(Nc_adj)}}observations on control in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(bwt_adj)}}bandwidth for treated in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(Nt_adj)}}observations on treated in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(bwc_raw)}}bandwidth for control in raw sample{p_end}
{synopt :{cmd:r(Nc_raw)}}observations on control in raw sample{p_end}
{synopt :{cmd:r(bwt_raw)}}bandwidth for treated in raw sample{p_end}
{synopt :{cmd:r(Nt_raw)}}observations on treated in raw sample{p_end}

{p2col 5 24 28 2:Macros}{p_end}
{synopt :{cmd:r(kernel)}}name of kernel{p_end}

{pstd}
After {cmd:teffects} or {cmd:stteffects} fits a multivalued treatment,
{cmd:tebalance density} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 24 28 2:Scalars}{p_end}
{synopt :{cmd:r(bw}{it:#}{cmd:_adj)}}bandwidth for treatment level {it:#} in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(N}{it:#}{cmd:_adj)}}observations on treatment level {it:#} in weighted or matched-adjusted sample{p_end}
{synopt :{cmd:r(bw}{it:#}{cmd:_raw)}}bandwidth for treatment level {it:#} in raw sample{p_end}
{synopt :{cmd:r(N}{it:#}{cmd:_raw)}}observations on treatment level {it:#} in raw sample{p_end}

{p2col 5 24 28 2:Macros}{p_end}
{synopt :{cmd:r(kernel)}}name of kernel{p_end}
