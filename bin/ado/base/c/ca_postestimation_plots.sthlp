{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog cabiplot "dialog cabiplot"}{...}
{viewerdialog caprojection "dialog caprojection"}{...}
{vieweralsosee "[MV] ca postestimation plots" "mansection MV capostestimationplots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] ca postestimation" "help ca postestimation"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "ca postestimation plots##description"}{...}
{viewerjumpto "Links to PDF documentation" "ca_postestimation_plots##linkspdf"}{...}
{viewerjumpto "cabiplot" "ca postestimation plots##syntax_cabiplot"}{...}
{viewerjumpto "caprojection" "ca postestimation plots##syntax_caprojection"}{...}
{viewerjumpto "Examples" "ca postestimation plots##examples"}{...}
{p2colset 1 33 29 2}{...}
{p2col:{bf:[MV] ca postestimation plots} {hline 2}}Postestimation plots for
ca and camat{p_end}
{p2col:}({mansection MV capostestimationplots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:ca}
and {cmd:camat}:

{synoptset 21}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb ca postestimation plots##cabiplot:cabiplot}}biplot of row and column
	points{p_end}
{synopt:{helpb ca postestimation plots##caprojection:caprojection}}CA dimension
	projection plot{p_end}
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV capostestimationplotsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_cabiplot}{...}
{marker cabiplot}{...}
{title:Syntax for cabiplot}

{p 8 17 2}
{cmd:cabiplot} [{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt dim(# #)}}two dimensions to be displayed; 
	{bind:default is {cmd:dim(2 1)}}{p_end}
{synopt:{opt norow}}suppress row coordinates{p_end}
{synopt:{opt nocol:umn}}suppress column coordinates{p_end}
{synopt:{opt xneg:ate}}negate the data relative to the {it:x} axis{p_end}
{synopt:{opt yneg:ate}}negate the data relative to the {it:y} axis{p_end}
{synopt:{opt max:length(#)}}maximum number of characters for labels;
	default is {cmd:maxlength(12)}{p_end}
{synopt:{opt or:igin}}display the origin on the plot{p_end}
{synopt:{opth or:iginlopts(line_options)}}affect rendition of origin
	axes{p_end}

{syntab:Rows}
{synopt:{opt row:opts(row_opts)}}affect rendition of rows{p_end}

{syntab:Columns}
{synopt:{opt col:opts(col_opts)}}affect rendition of columns{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 26}{...}
{p2coldent:{it:row_opts} and {it:col_opts}}Descriptions{p_end}
{synoptline}
{synopt:{it:plot_options}}change look of markers
	(color, size, etc.) and look or position of marker labels{p_end}
{synopt:{opt sup:popts(plot_options)}}change look of supplementary markers
	and look or position of supplementary marker labels{p_end}
{synoptline}

{synopthdr:plot_options}
{synoptline}
{synopt:{it:{help marker_options}}}change look of markers
	(color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}add marker labels; change
	look or position{p_end}
{synoptline}


{marker menu_cabiplot}{...}
{title:Menu for cabiplot}

{phang}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
     {bf:Postestimation after CA > Biplot of row and column points}


{marker description_cabiplot}{...}
{title:Description for cabiplot}

{pstd}
{cmd:cabiplot}
produces a plot of the row points or column points, or a biplot of the row and
column points.  In this plot, the (Euclidean) distances between row (column)
points approximates the chi-squared distances between the associated row
(column) profiles if the CA is properly normalized.  Similarly, the
association between a row and column point is approximated by the inner
product of vectors from the origin to the respective points (see
{manhelp ca MV}).


{marker options_cabiplot}{...}
{title:Options for cabiplot}

{dlgtab:Main}

{phang}{opt dim(# #)}
identifies the dimensions to be displayed.  For instance, {bind:{cmd:dim(3 2)}} plots
the third dimension (vertically) versus the second dimension (horizontally).
The dimension number cannot exceed the number of extracted dimensions.  The
default is {cmd:dim(2 1)}.

{phang}{opt norow} suppresses plotting of row points.

{phang}{opt nocolumn} suppresses plotting of column points.

{phang}{opt xnegate}
specifies that the {it:x}-axis values are to be negated (multiplied by -1).

{phang}{opt ynegate}
specifies that the {it:y}-axis values are to be negated (multiplied by -1).

{phang}{opt maxlength(#)}
specifies the maximum number of characters for row and column labels; 
the default is {cmd:maxlength(12)}.

{phang}{opt origin}
specifies that the origin be displayed on the plot.  This
is equivalent to adding the options 
{cmd:xline(0, lcolor(black) lwidth(vthin))}
{cmd:yline(0, lcolor(black) lwidth(vthin))} to the {cmd:cabiplot} command.

{phang}{opt originlopts(line_options)}
affects the rendition of the origin axes; see 
    {manhelpi line_options G-3}.

{dlgtab:Rows}

{phang}{opt rowopts(row_opts)}
affects the rendition of the rows.  The following {it:row_opts} are allowed:

{phang2}
{it:plot_options} affect the rendition of row markers, including their shape,
size, color, and outline (see {manhelpi marker_options G-3}) and specify if and
how the row markers are to be labeled (see
{manhelpi marker_label_options G-3}).

{phang2}
{opt suppopts(plot_options)}
affects supplementary markers and supplementary marker labels; see above for
description of {it:plot_options}.

{dlgtab:Columns}

{phang}{opt colopts(col_opts)}
affects the rendition of the columns.  The following {it:col_opts} are allowed:

{phang2}
{it:plot_options} affect the rendition of column markers, including their shape,
size, color, and outline (see {manhelpi marker_options G-3}) and specify if and
how the column markers are to be labeled (see 
{manhelpi marker_label_options G-3}).

{phang2}
{opt suppopts(plot_options)}
affects supplementary markers and supplementary marker labels; see above for
description of {it:plot_options}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3} excluding
{cmd:by()}.  These include options for titling the graph (see
{manhelpi title_options G-3}) and saving the graph to disk (see
{manhelpi saving_option G-3}).

{pmore}
{cmd:cabiplot} automatically adjusts the aspect ratio on the basis of the
range of the data and ensures that the axes are balanced.  As an alternative,
the {it:twoway_option} {helpb aspect_option:aspectratio()} can be used to
override the default aspect ratio.  {cmd:cabiplot} accepts the
{cmd:aspectratio()} option as a suggestion only and will override it when
necessary to produce plots with balanced axes; that is, distance on the {it:x}
axis equals distance on the {it:y} axis.

{pmore}
{it:{help twoway_options}} such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()} should be used with
caution.  These {it:{help axis_options}} are accepted but may have unintended
side effects on the aspect ratio.


{marker syntax_caprojection}{...}
{marker caprojection}{...}
{title:Syntax for caprojection}

{p 8 19 2}
{cmd:caprojection} [{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opth dim(numlist)}}dimensions to be displayed; default is all{p_end}
{synopt:{opt norow}}suppress row coordinates{p_end}
{synopt:{opt nocol:umn}}suppress column coordinates{p_end}
{synopt:{opt alt:ernate}}alternate labels{p_end}
{synopt:{opt max:length(#)}}maximum number of characters displayed for labels;
	default is {cmd:maxlength(12)}{p_end}
{synopt:{it:{help graph_combine:combine_options}}}affect the rendition of
	the combined column and row graphs{p_end}	
{syntab:Rows}
{synopt:{opt row:opts(row_opts)}}affect rendition of rows{p_end}

{syntab:Columns}
{synopt:{opt col:opts(col_opts)}}affect rendition of columns{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 24}{...}
{p2coldent:{it:row_opts} and {it:col_opts}}Descriptions{p_end}
{synoptline}
{synopt:{it:plot_options}}change look of markers
	(color, size, etc.) and look or position of marker labels{p_end}
{synopt:{opt sup:popts(plot_options)}}change look of supplementary markers
	and look or position of supplementary marker labels{p_end}
{synoptline}

{synopthdr:plot_options}
{synoptline}
{synopt:{it:{help marker_options}}}change look of markers
	(color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}add marker labels; change
	look or position{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_caprojection}{...}
{title:Menu for caprojection}

{phang}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
       {bf:Postestimation after CA > Dimension projection plot}


{marker description_caprojection}{...}
{title:Description for caprojection}

{pstd}
{cmd:caprojection}
produces a line plot of the row and column coordinates.  The goal of this
graph is to show the ordering of row and column categories on each principal
dimension of the analysis.  Each principal dimension is represented by a
vertical line; markers are plotted on the lines where the row and column
categories project onto the dimensions.


{marker options_caprojection}{...}
{title:Options for caprojection}

{dlgtab:Main}

{phang}{opth dim(numlist)}
identifies the dimensions to be displayed.  By default, all dimensions are
displayed.

{phang}{opt norow} suppresses plotting of rows.

{phang}{opt nocolumn} suppresses plotting of columns.

{phang}{opt alternate}
causes adjacent labels to alternate sides.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for row and column labels; 
the default is {cmd:maxlength(12)}.

{phang}{it:combine_options}
affect the rendition of the combined plot; see
{manhelp graph_combine G-2: graph combine}.
{it:combine_options} may not be specified with either 
{cmd:norow} or {cmd:nocolumn}.

{dlgtab:Rows}

{phang}{opt rowopts(row_opts)}
affects the rendition of the rows.  The following {it:row_opts} are allowed:

{phang2}
{it:plot_options} affect the rendition of row markers, including their shape,
size, color, and outline (see {manhelp marker_options G-3}) and specify if and
how the row markers are to be labeled (see {manhelp marker_label_options G-3}).

{phang2}
{opt suppopts(plot_options)}
affects supplementary markers and supplementary marker labels; see above for
description of {it:plot_options}.

{dlgtab:Columns}

{phang}{opt colopts(col_opts)}
affects the rendition of the columns.  The following {it:col_opts} are allowed:

{phang2}
{it:plot_options} affect the rendition of column markers, including their shape,
size, color, and outline (see {manhelpi marker_options G-3}) and specify if and
how the column markers are to be labeled (see 
{manhelpi marker_label_options G-3}).

{phang2}
{opt suppopts(plot_options)}
affects supplementary markers and supplementary marker labels; see above for
description of {it:plot_options}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3} excluding
{cmd:by()}.   These include options for titling the graph (see
{manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    Setup
        {cmd:. webuse ca_smoking}

    Estimate CA
        {cmd:. ca rank smoking}

    Biplots
        {cmd:. cabiplot}
        {cmd:. cabiplot, nocolumn}

    Dimension projection plot
        {cmd:. caprojection, dim(1/2)}
