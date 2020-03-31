{smcl}
{* *! version 1.1.0  27feb2019}{...}
{viewerdialog predict "dialog npregress_kernel_p"}{...}
{viewerdialog npgraph "dialog npgraph"}{...}
{vieweralsosee "[R] npregress kernel postestimation" "mansection R npregresskernelpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress kernel" "help npregress kernel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap postestimation" "help bootstrap postestimation"}{...}
{viewerjumpto "Postestimation commands" "npregress_kernel_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "npregress_kernel_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "npregress_kernel_postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "npregress_kernel_postestimation##syntax_margins"}{...}
{viewerjumpto "npgraph" "npregress_kernel_postestimation##syntax_npgraph"}{...}
{viewerjumpto "Examples" "npregress_kernel_postestimation##examples"}{...}
{viewerjumpto "Reference" "npregress_kernel_postestimation##reference"}{...}
{p2colset 1 40 42 2}{...}
{p2col:{bf:[R] npregress kernel postestimation} {hline 2}}Postestimation tools
for npregress kernel{p_end}
{p2col:}({mansection R npregresskernelpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:npregress kernel}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb npregress_kernel_postestimation##npgraph:npgraph}}plot of conditional
means{p_end}
{synoptline}


{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb npregress_kernel_postestimation##margins:margins}}marginal means, predictive margins, marginal effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb npregress_kernel_postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R npregresskernelpostestimationRemarksandexamples:Remarks and examples}

        {mansection R npregresskernelpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict}
{dtype}
{newvar} {ifin}
[{cmd:,}
{it:statistic}]

{p 8 19 2}
{cmd:predict}
{dtype}
{{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}}
{ifin}{cmd:,}
{cmdab:deriv:atives}

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{cmd:mean}}conditional mean of the outcome; the default{p_end}
{synopt :{cmdab:r:esiduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
conditional mean of the outcome, residuals, or derivatives of the mean
function.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:mean}, the default, calculates the conditional mean of the
outcome variable.

{phang}
{cmd:residuals} calculates the residuals.

{phang}
{cmd:derivatives} calculates the derivatives of the conditional mean.


{marker syntax_margins}{...}
{marker margins}{...}
{title:Syntax for margins}

{p 8 16 2}
{cmd:margins} [{it:{help margins##syntax:marginlist}}]
[{cmd:,} {it:options}]

{p 8 16 2}
{cmd:margins} [{it:{help margins##syntax:marginlist}}]
{cmd:,}
{opt pr:edict(statistic ...)}
[{it:options}]

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{cmd:mean}}conditional mean of the outcome; the default{p_end}
{synopt :{cmdab:r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{cmdab:deriv:atives}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 19 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:SE}
{synopt :{opt nose}}do not estimate standard errors; the default{p_end}
{synopt :{cmd:vce(bootstrap)}}estimate bootstrap standard errors{p_end}
{synopt :{opt r:eps(#)}}equivalent to {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}{p_end}
{synopt :{opt seed(#)}}set random-number seed to {it:#}; must also specify
{opt reps(#)}{p_end}

{syntab:Reporting}
{synopt :{opth citype:(npregress_kernel postestimation##citype:citype)}}method to compute bootstrap confidence intervals; default is
{cmd:citype(}{cmdab:p:ercentile}{cmd:)}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 19}{...}
{marker citype}{...}
{synopthdr:citype}
{synoptline}
{synopt :{opt p:ercentile}}percentile confidence intervals; the default{p_end}
{synopt :{opt bc}}bias-corrected confidence intervals{p_end}
{synopt :{opt nor:mal}}normal-based confidence intervals{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of the conditional mean.


{marker options_margins}{...}
{title:Options for margins}

{dlgtab:SE}

{phang}
{opt nose}
     suppresses calculation of the VCE and standard errors.
     This is the default.

{phang}
{cmd:vce(bootstrap)} specifies the type of standard error reported; see
{manhelpi vce_option R}.

{pmore}
We recommend that you select the number
of replications using {opt reps(#)} instead of specifying
{cmd:vce(bootstrap)}, which defaults to 50 replications. Be aware
that the number of replications needed to produce good estimates of
the standard errors varies depending on the problem.

{phang}
{opt reps(#)} specifies the
number of bootstrap replications to be performed.
Specifying this option is equivalent to
specifying {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}.

{phang}
{opt seed(#)} sets the random-number seed.
You must specify {opt reps(#)} with {opt seed(#)}.

{dlgtab:Reporting}

{phang}
{opt citype(citype)} specifies the type of confidence interval to be computed.
By default, bootstrap percentile confidence intervals are reported as
recommended by
{help npregress_kernel_postestimation##CJ2018:Cattaneo and Jansson (2018)}.
{it:citype} may be one of {cmd:percentile}, {cmd:bc}, or {cmd:normal}.


{marker syntax_npgraph}{...}
{marker npgraph}{...}
{title:Syntax for npgraph}

{p 8 15 2}
{cmd:npgraph}
{ifin}
[{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Plot}
{p2col:{it:{help marker_options}}}change look of markers (color, size,
etc.){p_end}
{p2col:{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt :{opt nosc:atter}}suppress scatterplot{p_end}

{syntab:Smoothed line}
{synopt :{opth lineop:ts(cline_options)}}affect rendition of the smoothed line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Description for npgraph}

{pstd}
{cmd:npgraph} plots the conditional mean estimated by {cmd:npregress kernel}
overlayed on a scatterplot of the data.  {cmd:npgraph} is available only
after fitting models with one covariate.


{title:Options for npgraph}

{dlgtab:Plot}

{phang}
{it:marker_options} affect the rendition of markers drawn at the plotted
points, including their shape, size, color, and outline; see
{manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are to be labeled;
see {manhelpi marker_label_options G-3}

{phang}
{opt noscatter} suppresses superimposing a scatterplot of the observed data
over the smooth.  This option is useful when the number of resulting points
would be so large as to clutter the graph.

{dlgtab:Smoothed line}

{phang}
{opt lineopts(cline_options)} affects the rendition of the
smoothed line; see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dui}

{pstd}Nonparametric kernel regression of {cmd:citations} as a function of
{cmd:fines}{p_end}
{phang2}{cmd:. npregress kernel citations fines}

{pstd}Plot the estimated conditional mean function{p_end}
{phang2}{cmd:. npgraph}

{pstd}Add {cmd: taxes} as a discrete covariate{p_end}
{phang2}{cmd:. npregress kernel citations fines i.taxes}

{pstd}Estimate the mean number of citations when fines are increased by 15%{p_end}
{phang2}{cmd:. margins, at(fines=generate(fines*1.15))}


{marker reference}{...}
{title:Reference}

{marker CJ2018}{...}
{phang}
Cattaneo, M. D., and M. Jansson. 2018. Kernel-based semiparametric estimators:
Small bandwidth asymptotics and bootstrap consistency.
{it:Econometrica} 86: 955-995.
{p_end}
