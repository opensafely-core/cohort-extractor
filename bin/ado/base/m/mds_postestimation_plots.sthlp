{smcl}
{* *! version 1.1.4  23oct2017}{...}
{viewerdialog mdsconfig "dialog mdsconfig"}{...}
{viewerdialog mdsshepard "dialog mdsshepard"}{...}
{vieweralsosee "[MV] mds postestimation plots" "mansection MV mdspostestimationplots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] mds postestimation" "help mds postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mdslong" "help mdslong"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "mds postestimation plots##description"}{...}
{viewerjumpto "Links to PDF documentation" "mds_postestimation_plots##linkspdf"}{...}
{viewerjumpto "mdsconfig" "mds postestimation plots##syntax_mdsconfig"}{...}
{viewerjumpto "mdsshepard" "mds postestimation plots##syntax_mdsshepard"}{...}
{viewerjumpto "Examples" "mds postestimation plots##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[MV] mds postestimation plots} {hline 2}}Postestimation plots for mds, mdsmat, and mdslong
{p_end}
{p2col:}({mansection MV mdspostestimationplots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mds},
{cmd:mdsmat}, and {cmd:mdslong}:

{synoptset 22}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb mds postestimation plots##mdsconfig:mdsconfig}}plot of approximating
	configuration{p_end}
{synopt:{helpb mds postestimation plots##mdsshepard:mdsshepard}}Shepard diagram{p_end}
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mdspostestimationplotsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_mdsconfig}{...}
{marker mdsconfig}{...}
{title:Syntax for mdsconfig}

{p 8 18 2}
{cmd:mdsconfig} [{cmd:,} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt dim:ensions(# #)}}two dimensions to be displayed; 
	{bind:default is {cmd:dimensions(2 1)}}{p_end}
{synopt:{opt xneg:ate}}negate data relative to the {it:x} axis{p_end}
{synopt:{opt yneg:ate}}negate data relative to the {it:y} axis{p_end}
{synopt:{opt auto:aspect}}adjust aspect ratio on the basis of the data;
	default aspect ratio is 1{p_end}
{synopt:{opt max:length(#)}}maximum number of characters used in marker
	labels{p_end}
{synopt:{it:{help cline_options}}}affect rendition of the lines
	connecting points{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, 
	size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change look or position 
	of marker labels{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
        documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_mdsconfig}{...}
{title:Menu for mdsconfig}

{phang}
{bf:Statistics > Multivariate analysis > Multidimensional scaling (MDS) >}
       {bf:Postestimation > Approximating configuration plot}


{marker desc_mdsconfig}{...}
{title:Description for mdsconfig}

{pstd}{cmd:mdsconfig}
produces a plot of the approximating Euclidean configuration.  By default,
dimensions 1 and 2 are plotted.


{marker options_mdsconfig}{...}
{title:Options for mdsconfig}

{dlgtab:Main}

{phang}{opt dimensions(# #)}
identifies the dimensions to be displayed.  For instance,
{bind:{cmd:dimensions(3 2)}} plots
the third dimension (vertically) versus the second dimension (horizontally).
The dimension number cannot exceed the number of extracted dimensions.  The
default is {cmd:dimensions(2 1)}.

{phang}{opt xnegate}
specifies that the data be negated relative to the {it:x} axis.

{phang}{opt ynegate}
specifies that the data be negated relative to the {it:y} axis.

{marker autoaspect}{...}
{phang}{opt autoaspect}
specifies that the aspect ratio be automatically adjusted based on the
range of the data to be plotted.  This option can make some plots more
readable.  By default, {cmd:mdsconfig} uses an aspect ratio of one, producing
a square plot.  Some plots will have little variation in the {it:y}-axis
direction, and use of the {opt autoaspect} option will better fill the
available graph space while preserving the equivalence of distance in the
{it:x} and {it:y} axes.

{pmore}
As an alternative to {opt autoaspect}, the {it:twoway_option}
{helpb aspect_option:aspectratio()} can be used to override the default
aspect ratio. {cmd:mdsconfig} accepts the {cmd:aspectratio()} option as
a suggestion only and will override it when necessary to produce plots
with balanced axes; that is, distance on the {it:x} axis equals distance
on the {it:y} axis.

{pmore}
{it:{help twoway_options:twoway_options}}, such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()}, should be used with
caution.  These {it:{help axis_options}} are accepted but may have unintended
side effects on the aspect ratio.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for object names used to mark the
points; the default is {cmd:maxlength(12)}.

{phang}
{it:cline_options}
affect the rendition of the lines connecting the plotted points; see
{manhelpi cline_options G-3}.  If you are drawing connected lines, 
the appearance of the plot depends on the sort order of the data.

{phang}
{it:marker_options}
affect the rendition of the markers drawn at the plotted points, including
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
specify if and how the markers are to be labeled; see
{manhelpi marker_label_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3}, excluding
{cmd:by()}.  These include options for titling the graph (see
{manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).
See {helpb mds postestimation plots##autoaspect:autoaspect} above for a warning
against using options such as {cmd:xlabel()}, {cmd:xscale()},
{cmd:ylabel()}, and {cmd:yscale()}.


{marker syntax_mdsshepard}{...}
{marker mdsshepard}{...}
{title:Syntax for mdsshepard}

{p 8 19 2}
{cmd:mdsshepard} [{cmd:,} {it:options}]

{synoptset 21 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt notrans:form}}use dissimilarities instead of disparities{p_end}
{synopt:{opt auto:aspect}}adjust aspect ratio on the basis of the data;
	default aspect ratio is 1{p_end}
{synopt:{opt sep:arate}}draw separate Shepard diagrams for each object{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, 
	size, etc.){p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
        documented in {manhelpi twoway_options G-3}{p_end}
{synopt:{opth byo:pts(by_option)}}affect the
        rendition of combined graphs; {opt separate} only{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_mdsshepard}{...}
{title:Menu for mdsshepard}

{phang}
{bf:Statistics > Multivariate analysis > Multidimensional scaling (MDS) >}
    {bf:Postestimation > Shepard diagram}


{marker desc_mdsshepard}{...}
{title:Description for mdsshepard}

{pstd}{cmd:mdsshepard}
produces a Shepard diagram of the disparities against
the Euclidean distances.  Ideally, the points in the plot should be close
to the y=x line.  Optionally, separate plots are generated for each "row"
(value of {cmd:id()}).


{marker options_mdsshepard}{...}
{title:Options for mdsshepard}

{dlgtab:Main}

{phang}{opt notransform}
uses dissimilarities instead of disparities, that is, suppresses the
transformation of the dissimilarities.

{phang}{opt autoaspect}
specifies that the aspect ratio is to be automatically adjusted based on the
range of the data to be plotted.  By default, {cmd:mdsshepard} uses an aspect
ratio of one, producing a square plot.

{pmore}
See the description of the 
{helpb mds postestimation plots##autoaspect:autoaspect} option of
{cmd:mdsconfig} for more details.

{phang}{opt separate}
displays separate plots of each value of the id variable.  This may
be time consuming if the number of distinct id values is not small.

{phang}
{it:marker_options}
affect the rendition of the markers drawn at the plotted points, including
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3}, excluding
{cmd:by()}. These include options for titling the graph (see
{manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).
See the {helpb mds postestimation plots##autoaspect:autoaspect} option of
{cmd:mdsconfig} for a warning against using options such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()}.

{phang}
{opt byopts(by_option)}
is documented in {manhelpi by_option G-3}.  This option affects the appearance
of the combined graph and is allowed only with the {opt separate} option.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Perform classical multidimensional scaling, standardizing variables
{p_end}
{phang2}{cmd:. mds price-gear, id(make) dim(2) std}

{pstd}Plot the approximating configuration{p_end}
{phang2}{cmd:. mdsconfig}

{pstd}Plot Shepard diagram{p_end}
{phang2}{cmd:. mdsshepard}{p_end}
