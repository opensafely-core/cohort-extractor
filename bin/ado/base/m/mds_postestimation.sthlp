{smcl}
{* *! version 1.2.8  31may2018}{...}
{viewerdialog predict "dialog mds_p"}{...}
{viewerdialog estat "dialog mds_estat"}{...}
{viewerdialog mdsconfig "dialog mdsconfig"}{...}
{viewerdialog mdsshepard "dialog mdsshepard"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] mds postestimation" "mansection MV mdspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] mds postestimation plots" "help mds postestimation plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mdslong" "help mdslong"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "mds postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mds_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mds postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "mds postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "mds postestimation##examples"}{...}
{viewerjumpto "Stored results" "mds postestimation##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MV] mds postestimation} {hline 2}}Postestimation tools for mds, mdsmat, and mdslong
{p_end}
{p2col:}({mansection MV mdspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mds},
{cmd:mdsmat}, and {cmd:mdslong}:

{synoptset 22 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb mds postestimation##estat:estat config}}coordinates of the
	approximating configuration{p_end}
{synopt:{helpb mds postestimation##estat:estat correlations}}correlations
	between dissimilarities and approximating distances{p_end}
{synopt:{helpb mds postestimation##estat:estat pairwise}}pairwise
	dissimilarities, approximating distances, and raw residuals{p_end}
{synopt:{helpb mds postestimation##estat:estat quantiles}}quantiles of the
	residuals per object{p_end}
{synopt:{helpb mds postestimation##estat:estat stress}}Kruskal stress
        (loss) measure (only after classical MDS){p_end}
{p2coldent:+ {helpb mds postestimation##estat:estat summarize}}estimation
	sample summary{p_end}
{synopt:{helpb mds postestimation plots##mdsconfig:mdsconfig}}plot of approximating
	configuration{p_end}
{synopt:{helpb mds postestimation plots##mdsshepard:mdsshepard}}Shepard diagram{p_end}
{synopt:{helpb screeplot}}plot eigenvalues (only after classical MDS){p_end}
{synoptline}
{p 4 6 2}
+ {cmd:estat summarize} is not available after {cmd:mdsmat}.

{pstd}
The following standard postestimation commands are also available:

{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synopt:{helpb mds postestimation##predict:predict}}approximating
	configuration, disparities, dissimilarities, distances, and
	residuals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mdspostestimationRemarksandexamples:Remarks and examples}

        {mansection MV mdspostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help varlist:newvarlist}}} {ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt con:fig}}approximating configuration; specify {cmd:dimension()} or
        fewer variables{p_end}
{synopt:{opt pair:wise(pstats)}}selected pairwise statistics; specify same
        number of variables{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22}{...}
{p2coldent:{it:pstats}}Description{p_end}
{synoptline}
{synopt:{opt disp:arities}}disparities = transformed(dissimilarities){p_end}
{synopt:{opt diss:imilarities}}dissimilarities{p_end}
{synopt:{opt dist:ances}}Euclidean distances between configuration points{p_end}
{synopt:{opt rr:esiduals}}raw residual = dissimilarity - distance{p_end}
{synopt:{opt tr:esiduals}}transformed residual = disparity - distance{p_end}
{synopt:{opt we:ights}}weights{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save results to {it:filename}; use {cmd:replace} to overwrite existing {it:filename}{p_end}
{synopt:{opt full}}create predictions for all pairs of object; {opt pairwise()} only{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt saving()} is required after {cmd:mdsmat}, after {cmd:mds} if
{opt pairwise()} is selected, and after {cmd:mdslong} if {opt config} is
selected.
{p_end}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as
approximating configurations in Euclidean space and selected
pairwise statistics.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{cmd:config}
generates variables containing the approximating configuration in Euclidean
space.  Specify as many new variables as approximating dimensions (as
determined by the {cmd:dimension()} option of {cmd:mds}, {cmd:mdsmat}, or
{cmd:mdslong}), though you may specify fewer.
{cmd:estat config} displays the same information but does not store the
information in variables.  After {cmd:mdsmat} and {cmd:mdslong}, you must also
specify the {cmd:saving()} option.

{phang}{opt pairwise(pstats)}
generates new variables containing pairwise statistics.  The number of new
variables should be the same as the number of specified statistics.  The
following statistics are allowed

{phang3}{cmd:disparities}
generates the disparities, that is, the transformed dissimilarities.  If no
transformation is applied (modern MDS with
{cmd:transform(identity)}), disparities are the same as dissimilarities.

{phang3}{cmd:dissimilarities}
generates the dissimilarities used in MDS.  If {cmd:mds}, {cmd:mdslong}, or
{cmd:mdsmat} was invoked on similarity data, the associated dissimilarities
are returned.

{phang3}{cmd:distances}
generates the (unsquared) Euclidean distances between the fitted configuration
points.

{phang3}{cmd:rresiduals}
generates the raw residuals: dissimilarities - distances.

{phang3}{cmd:tresiduals}
generates the transformed residuals: disparities - distances.

{phang3}{cmd:weights}
generates the weights.  Missing proximities are represented by zero weights.

{pmore}
{cmd:estat pairwise} displays some of the same information
but does not store the information in variables.

{pmore}
After {cmd:mds} and {cmd:mdsmat}, you must also specify the {cmd:saving()}
option.  With n objects, the pairwise dataset has n(n-1)/2 observations.
In addition to the three requested variables, {cmd:predict} produces
variables {it:id}{cmd:1} and {it:id}{cmd:2}, which identify pairs of objects.
With {cmd:mds}, {it:id} is the name of the identification variable ({cmd:id()}
option), and with {cmd:mdsmat}, it is "{cmd:Category}".

{phang}{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)}
is required after {cmd:mdsmat}, after {cmd:mds} if {opt pairwise()} is selected,
and after {cmd:mdslong} if {opt config} is selected.  {opt saving()} indicates
that the generated variables are to be created in a new Stata dataset and
saved in the file named {it:filename}.  Unless {opt saving()} is specified,
the variables are generated in the current dataset.

{pmore}{opt replace}
indicates that {it:filename} specified in {cmd:saving()} may be overwritten.

{phang}{opt full}
creates predictions for all pairs of objects (j1,j2).  The default is to
generate predictions only for pairs (j1,j2) where j1>j2.  {opt full} may
be specified only with {opt pairwise()}.


{marker syntax_estat}{...}
{marker estat}{...}
{title:Syntax for estat}

{pstd}
List the coordinates of the approximating configuration

{p 8 14 2}
{cmd:estat} {cmdab:con:fig} [{cmd:,}
{opt max:length(#)} {opth for:mat(%fmt)}]


{pstd}
List the Pearson and Spearman correlations

{p 8 14 2}
{cmd:estat} {cmdab:cor:relations} [{cmd:,}
{opt max:length(#)} {opth for:mat(%fmt)} {opt notrans:form} {opt notot:al}]


{pstd}
List the pairwise statistics: disparities, distances, and residuals

{p 8 14 2}
{cmd:estat} {cmdab:pair:wise} [{cmd:,}
{opt max:length(#)} {opt notrans:form} {opt f:ull} {opt s:eparator}]


{pstd}
List the quantiles of the residuals

{p 8 14 2}
{cmd:estat} {cmdab:qua:ntiles} [{cmd:,}
{opt max:length(#)} {opth for:mat(%fmt)} {opt notot:al} {opt notrans:form}]


{pstd}
Display the Kruskal stress (loss) measure per point (only after classical MDS)

{p 8 14 2}
{cmd:estat} {cmdab:str:ess} [,
{opt max:length(#)} {opth for:mat(%fmt)} {opt notot:al} {opt notrans:form}]


{pstd}
Summarize the variables in MDS

{p 8 14 2}
{cmd:estat} {cmdab:su:mmarize} [{cmd:,} {opt lab:els}]


{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt:{opt max:length(#)}}maximum number of characters for displaying object
	names; default is {cmd:12}{p_end}
{synopt:{opth for:mat(%fmt)}}display format{p_end}
{synopt:{opt notot:al}}suppress display of overall summary statistics{p_end}
{synopt:{opt notrans:form}}use dissimilarities instead of disparities{p_end}
{synopt:{opt f:ull}}display all pairs (j1,j2); default is (j1>j2) only{p_end}
{synopt:{opt s:eparator}}draw separating lines{p_end}
{synopt:{opt lab:els}}display variable labels{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}{cmd:estat config}
lists the coordinates of the approximating configuration.

{pstd}{cmd:estat correlations}
lists the Pearson and Spearman correlations between the disparities or
dissimilarities and the Euclidean distances for each object.

{pstd}{cmd:estat pairwise}
lists the pairwise statistics: the disparities, the
distances, and the residuals.

{pstd}{cmd:estat quantiles}
lists the quantiles of the residuals per object.

{pstd}{cmd:estat stress}
displays the Kruskal stress (loss) measure between the (transformed)
dissimilarities and fitted distances per object (only after classical MDS).

{pstd}{cmd:estat summarize}
summarizes the variables in the MDS over the estimation sample.  After
{cmd:mds}, {cmd:estat summarize} also reports whether and how variables were
transformed before computing similarities or dissimilarities.


{marker options_estat}{...}
{title:Options for estat}

{phang}{opt maxlength(#)},
an option used with all but {cmd:estat summarize},
specifies the maximum number of characters of the object names to be
displayed; the default is {cmd:maxlength(12)}.

{phang}{opth format(%fmt)},
an option used with {cmd:estat config}, {cmd:estat correlations},
{cmd:estat quantiles}, and {cmd:estat stress}, specifies the display format;
the default differs between the subcommands.

{phang}{opt nototal},
an option used with {cmd:estat correlations}, {cmd:estat quantiles},
and {cmd:estat stress}, suppresses the overall summary statistics.

{phang}{opt notransform},
an option used with {cmd:estat correlations}, {cmd:estat pairwise},
{cmd:estat quantiles}, and {cmd:estat stress}, specifies that the
untransformed dissimilarities be used instead of the transformed
dissimilarities (disparities).

{phang}{opt full},
an option used with {cmd:estat pairwise},
displays a row for all pairs (j1,j2).  The default is to display rows only for
pairs where j1>j2.

{phang}{opt separator},
an option used with {cmd:estat pairwise},
draws separating lines between blocks of rows corresponding to changes in the
first of the pair of objects.

{phang}{opt labels},
an option used with {cmd:estat summarize},
displays variable labels.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Perform classical multidimensional scaling, standardizing variables
{p_end}
{phang2}{cmd:. mds price-gear, id(make) dim(2) std}

{pstd}List coordinates of the approximating configuration{p_end}
{phang2}{cmd:. estat config}

{pstd}List correlations between disparities and Euclidean distances{p_end}
{phang2}{cmd:. estat correlations}

{pstd}List quantiles of transformed residuals{p_end}
{phang2}{cmd:. estat quantiles}

{pstd}List pairwise disparities, distances, and residuals{p_end}
{phang2}{cmd:. estat pairwise}

{pstd}Display Kruskal stress measure for each object{p_end}
{phang2}{cmd:. estat stress}

{pstd}Display summary of variables{p_end}
{phang2}{cmd:. estat summarize}
 
{pstd}Generate variables containing the approximating configuration{p_end}
{phang2}{cmd:. predict d1 d2, config}

{pstd}Save to another dataset variables containing pairwise disparities,
dissimilarities, and distances{p_end}
{phang2}{cmd:. predict disp diss dist, pairwise(disp diss dist) saving(gd3)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat correlations} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(R)}}statistics per object; columns with # of obs., Pearson corr., and Spearman corr.{p_end}
{synopt:{cmd:r(T)}}overall statistics; # of obs., Pearson corr., and Spearman corr.{p_end}

{pstd}
{cmd:estat quantiles} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dtype)}}{cmd:adjusted} or {cmd:raw}; dissimilarity
transformation{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Q)}}statistics per object; columns with # of obs., min., p25,
p50, p75, and max.{p_end}
{synopt:{cmd:r(T)}}overall statistics; # of obs., min., p25, p50, p75, and
max.{p_end}

{pstd}
{cmd:estat stress} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dtype)}}{cmd:adjusted} or {cmd:raw}; dissimilarity
transformation{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(S)}}Kruskal's stress/loss measure per object{p_end}
{synopt:{cmd:r(T)}}1 x 1 matrix with the overall Kruskal stress/loss measure
{p_end}
{p2colreset}{...}
