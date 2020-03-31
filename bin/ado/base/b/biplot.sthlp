{smcl}
{* *! version 1.3.16  19oct2017}{...}
{viewerdialog biplot "dialog biplot"}{...}
{vieweralsosee "[MV] biplot" "mansection MV biplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "biplot##syntax"}{...}
{viewerjumpto "Menu" "biplot##menu"}{...}
{viewerjumpto "Description" "biplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "biplot##linkspdf"}{...}
{viewerjumpto "Options" "biplot##options"}{...}
{viewerjumpto "Examples" "biplot##examples"}{...}
{viewerjumpto "Stored results" "biplot##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] biplot} {hline 2}}Biplots{p_end}
{p2col:}({mansection MV biplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:biplot}
{varlist} 
{ifin}
[{cmd:,} {it:options}]


{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth rowover(varlist)}}identify observations from different groups of
{it:varlist}; may not be combined with {cmd:separate} or {cmd:norow}{p_end}
{synopt:{opt dim(# #)}}two dimensions to be displayed; default is
{cmd:dim(2 1)}{p_end}
{synopt:{opt std}}use standardized instead of centered variables{p_end}
{synopt:{opt alp:ha(#)}}row weight={it:#}; column weight=1-{it:#}; default
	is 0.5{p_end}
{synopt:{opt st:retch(#)}}stretch the column (variable) arrows{p_end}
{synopt:{opt mah:alanobis}}approximate Mahalanobis distance; implies
	{cmd:alpha(0)}{p_end}
{synopt:{opt xneg:ate}}negate the data relative to the {it:x} axis{p_end}
{synopt:{opt yneg:ate}}negate the data relative to the {it:y} axis{p_end}
{synopt:{opt auto:aspect}}adjust aspect ratio on the basis of the data; default
	aspect ratio is 1{p_end}
{synopt:{opt sep:arate}}produce separate plots for rows and columns;
may not be combined with {opt rowover()}{p_end}
{synopt:{opt nog:raph}}suppress graph{p_end}
{synopt:{opt tab:le}}display table showing biplot coordinates{p_end}

{syntab:Rows}
{synopt:{opth row:opts(biplot##rowopts:row_options)}}affect rendition
of rows (observations){p_end}
{synopt:{cmdab:row:}{ul:{it:#}}{opth opts:(biplot##rowopts:row_options)}}affect
rendition of rows (observations) in the {it:#}th group of {varlist} defined
in {cmd:rowover()}; available only with {cmd:rowover()}{p_end}
{synopt:{opth rowlabel(varname)}}specify label variable for rows (observations)
{p_end}
{synopt:{opt norow}}suppress row points; may not be combined with {cmd:rowover()}{p_end}
{synopt :{cmdab:gen:erate(}{it:{help newvar:newvar_x}} {it:{help newvar:newvar_y}}{cmd:)}}store biplot coordinates for observations in variables {it:newvar_x}
and {it:newvar_y} {p_end}

{syntab:Columns}
{synopt:{opth col:opts(biplot##colopts:col_options)}}affect rendition of
columns (variables){p_end}
{synopt:{opt negc:ol}}include negative column (variable) arrows{p_end}
{synopt:{opth negcol:opts(biplot##colopts:col_options)}}affect rendition of
negative columns (variables){p_end}
{synopt:{opt nocol:umn}}suppress column arrows{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in 
{manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker rowopts}{...}
{synoptset 29}{...}
{synopthdr:row_options}
{synoptline}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change look or position of marker labels{p_end}
{synopt:{opt nolabel}}remove the default row (variable) label from the graph{p_end}
{synopt:{opt name(name)}}override the default name given to rows (observations){p_end}
{synoptline}

{marker colopts}{...}
{synopthdr:col_options}
{synoptline}
{synopt:{it:{help twoway_pcarrow:pcarrow_options}}}affect the rendition of paired-coordinate arrows{p_end}
{synopt:{opt nolabel}}remove the default column (variable) label from the graph{p_end}
{synopt:{opt name(name)}}override the default name given to columns (variables){p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Biplot}


{marker description}{...}
{title:Description}

{pstd}
{cmd:biplot} displays a two-dimensional biplot of a dataset.  A biplot
simultaneously displays the observations (rows) and the relative positions of
the variables (columns).  Marker symbols (points) are displayed for
observations, and arrows are displayed for variables.  Observations are
projected to two dimensions such that the distance between the observations is
approximately preserved.  The cosine of the angle between arrows approximates
the correlation between the variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV biplotQuickstart:Quick start}

        {mansection MV biplotRemarksandexamples:Remarks and examples}

        {mansection MV biplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opth rowover(varlist)}
distinguishes groups among observations (rows) by highlighting
observations on the plot for each group identified by equal values of the
variables in {it:varlist}.  By default, the graph contains a legend that
consists of group names.  {cmd:rowover()} may not be combined with
{cmd:separate} or {cmd:norow}.

{phang}{opt dim(# #)}
identifies the dimensions to be displayed.  For instance, {cmd:dim(3 2)}
plots the third dimension (vertically) versus the second dimension
(horizontally).  The dimension numbers cannot exceed the number of variables.
The default is {cmd:dim(2 1)}.

{phang}{opt std}
produces a biplot of the standardized variables instead of the centered
variables.

{phang}{opt alpha(#)}
specifies that the variables be scaled by lambda^{it:#} and the observations
by lambda^(1-{it:#}), where lambda are the singular values.  It is required
that 0 <= {it:#} <= 1.  The most common values are 0, 0.5, and 1.  The default
is {cmd:alpha(0.5)} and is known as the symmetrically scaled biplot or
symmetric factorization biplot.  The result with {cmd:alpha(1)} is the
principal-component biplot, also called the row-preserving metric (RPM) biplot.
The biplot with {cmd:alpha(0)} is referred to as the column-preserving metric
(CPM) biplot.

{phang}{opt stretch(#)}
causes the length of the arrows to be multiplied by {it:#}.  For example,
{cmd:stretch(1)} would leave the arrows the same length, {cmd:stretch(2)}
would double their length, and {cmd:stretch(0.5)} would halve their length.

{phang}{opt mahalanobis}
implies {cmd:alpha(0)} and scales the positioning of points
(observations) by sqrt(n-1) and positioning of arrows (variables) by
1/sqrt(n-1).  This additional scaling causes the distances between
observations to change from being approximately proportional to the
Mahalanobis distance to instead being approximately equal to the Mahalanobis
distance.  Also, the inner products between variables approximate their
covariance.

{phang}{opt xnegate}
specifies that dimension-1 ({it:x} axis) values be negated
(multiplied by -1).

{phang}{opt ynegate}
specifies that dimension-2 ({it:y} axis) values be negated
(multiplied by -1).

{marker autoaspect}{...}
{phang}{opt autoaspect}
specifies that the aspect ratio be automatically adjusted based on the
range of the data to be plotted.  This option can make some biplots more
readable.  By default, {cmd:biplot} uses an aspect ratio of one, producing a
square plot.  Some biplots will have little variation in the {it:y}-axis
direction, and using the {opt autoaspect} option will better fill the 
available graph space while preserving the equivalence of distance in the
{it:x}  and {it:y} axes.

{pmore}
As an alternative to {opt autoaspect}, the {it:twoway_option} 
{helpb aspect_option:aspectratio()} can be used to override the default
aspect ratio.  {cmd:biplot} accepts the {cmd:aspectratio()} option as a
suggestion only and will override it when necessary to produce plots with
balanced axes; that is, distance on the {it:x} axis equals distance on the
{it:y} axis.

{pmore}
{it:{help twoway_options}}, such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()}, should be used with
caution.  These {it:{help axis_options}} are accepted but may have unintended
side effects on the aspect ratio.

{phang}{opt separate}
produces separate plots for the row and column categories.  The default is to
overlay the plots.  {cmd:separate} may not be combined with {cmd:rowover()}.

{phang}{opt nograph}
suppresses displaying the graph.

{phang}{opt table}
displays a table with the biplot coordinates. 

{dlgtab:Rows}

{phang}{opt rowopts(row_options)}
affects the rendition of the points plotting the rows (observations).  This
option may not be combined with {cmd:rowover()}.  The following
{it:row_options} are allowed:

{phang2}
{it:marker_options}
affect the rendition of markers drawn at the plotted points, including 
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang2}
{it:marker_label_options}
specify the properties of marker labels; see
{manhelpi marker_label_options G-3}.
{opt mlabel()} in {opt rowopts()} may not be combined with the {opt rowlabel()}
option.

{phang2}
{opt nolabel}
removes the default row label from the graph.

{phang2}
{opt name(name)}
overrides the default name given to rows.

{phang}
{opt row}{it:#}{opt opts(row_options)} affects rendition of the points
plotting the rows (observations) in the {it:#}th group identified by equal
values of the variables in {varlist} defined in {cmd:rowover()}.  This
option requires specifying {cmd:rowover()}.  See {cmd:rowopts()} above for the
allowed {it:row_options}, except {cmd:mlabel()} is not allowed with
{opt row}{it:#}{opt opts()}.

{phang}
{opth rowlabel(varname)}
specifies label variable for rows (observations).

{phang}{opt norow}
suppresses plotting of row points.  This option may not be combined with
{cmd:rowover()}.

{phang}
{cmd:generate(}{it:{help newvar:newvar_x}} {it:newvar_y}{cmd:)}
stores biplot coordinates for rows in variables {it:newvar_x} and
{it:newvar_y}.

{dlgtab:Columns}

{phang}{opt colopts(col_options)}
affects the rendition of the arrows and points plotting the columns 
(variables).  The following {it:col_options}
are allowed:

{phang2}
{it:pcarrow_options}
affect the rendition of paired-coordinate arrows; see
{manhelp twoway_pcarrow G-2:graph twoway pcarrow}.

{phang2}
{opt nolabel}
removes the default column label from the graph.

{phang2}
{opt name(name)}
overrides the default name given to columns.

{phang}{opt negcol}
includes negative column (variable) arrows on the plot.

{phang}{opt negcolopts(col_options)}
affects the rendition of the arrows and points plotting the negative
columns (variables).  The {it:col_options} allowed are given
{help biplot##colopts:above}.

{phang}{opt nocolumn}
suppresses plotting of column arrows.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3} excluding
{cmd:by()}.  These include options for titling the graph (see 
{manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).  See {helpb biplot##autoaspect:autoaspect} above
for a warning against using options such as {cmd:xlabel()}, {cmd:xscale()},
{cmd:ylabel()}, and {cmd:yscale()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse renpainters}

{pstd}Biplot of 10 Renaissance painters on four attributes{p_end}
{phang2}{cmd:. biplot composition-expression, alpha(1) stretch(10) table}
	{cmd:rowlabel(painter) rowopts(name(Painters))}
	{cmd:colopts(name(Attributes))}
	{cmd:title(Renaissance painters) autoaspect}

{pstd}Same as above, but highlights observations with the same score on
attribute colour{p_end}
{phang2}{cmd:. biplot composition-expression, alpha(1) stretch(10) table}
        {cmd:rowover(colour) rowlabel(painter)}
        {cmd:colopts(name(Attributes))}
        {cmd:title(Renaissance painters) autoaspect}

{pstd}Same as above, but uses the defined names and suppresses the marker 
label{p_end}
{phang2}{cmd:. biplot composition-expression, alpha(1) stretch(10) table}
        {cmd:rowover(colour)}
        {cmd:row1opts(name("Color score: 4") nolabel)}
        {cmd:row2opts(name("Color score: 7") nolabel)}
        {cmd:row3opts(name("Color score: 8") nolabel)}
        {cmd:row4opts(name("Color score: 9") nolabel)}
        {cmd:row5opts(name("Color score: 10") nolabel)}
        {cmd:row6opts(name("Color score: 12") nolabel)}
        {cmd:row7opts(name("Color score: 16") nolabel)}
        {cmd:colopts(name(Attributes))}
        {cmd:title(Renaissance painters) autoaspect}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:biplot} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(rho1)}}explained variance by component 1{p_end}
{synopt:{cmd:r(rho2)}}explained variance by component 2{p_end}
{synopt:{cmd:r(rho)}}total explained variance{p_end}
{synopt:{cmd:r(alpha)}}value of {cmd:alpha()} option{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(U)}}biplot coordinates for the observations; stored only if the
	row dimension does not exceed Stata's maximum matrix size; as an
	alternative, use {cmd:generate()} to store biplot coordinates for the
	observations in variables{p_end}
{synopt:{cmd:r(V)}}biplot coordinates for the variables{p_end}
{synopt:{cmd:r(Vstretch)}}biplot coordinates for the variables times
{cmd:stretch()} factor{p_end}
{p2colreset}{...}
