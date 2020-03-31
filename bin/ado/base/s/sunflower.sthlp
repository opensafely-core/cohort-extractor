{smcl}
{* *! version 1.1.13  19oct2017}{...}
{viewerdialog sunflower "dialog sunflower"}{...}
{vieweralsosee "[R] sunflower" "mansection R sunflower"}{...}
{viewerjumpto "Syntax" "sunflower##syntax"}{...}
{viewerjumpto "Menu" "sunflower##menu"}{...}
{viewerjumpto "Description" "sunflower##description"}{...}
{viewerjumpto "Links to PDF documentation" "sunflower##linkspdf"}{...}
{viewerjumpto "Options" "sunflower##options"}{...}
{viewerjumpto "Remarks" "sunflower##remarks"}{...}
{viewerjumpto "Examples" "sunflower##examples"}{...}
{viewerjumpto "Reference" "sunflower##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] sunflower} {hline 2}}Density-distribution sunflower plots{p_end}
{p2col:}({mansection R sunflower:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:sunflower} {it:yvar} {it:xvar}
{ifin}
[{it:{help sunflower##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 32 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt nograph}}do not show graph{p_end}
{synopt:{opt notab:le}}do not show summary table; implied when {opt by()} is specified{p_end}
{synopt:{it:{help marker_options:marker_options}}}affect rendition of markers
	drawn at the plotted points{p_end}

{syntab:Bins/Petals}
{synopt:{opt binw:idth(#)}}width of the hexagonal bins{p_end}
{synopt:{opt binar(#)}}aspect ratio of the hexagonal bins{p_end}
{synopt:{it:{help sunflower##bin_options:bin_options}}}affect rendition of hexagonal bins{p_end}
{synopt:{opt li:ght(#)}}minimum observations for a light sunflower; default is {cmd:light(3)}{p_end}
{synopt:{opt da:rk(#)}}minimum observations for a dark sunflower; default is {cmd:dark(13)}{p_end}
{synopt:{opt xcen:ter(#)}}{it:x}-coordinate of the reference bin{p_end}
{synopt:{opt ycen:ter(#)}}{it:y}-coordinate of the reference bin{p_end}
{synopt:{opt petalw:eight(#)}}observations in a dark sunflower petal{p_end}
{synopt:{opt petall:ength(#)}}length of sunflower petal as a percentage{p_end}
{synopt:{it:{help sunflower##petal_options:petal_options}}}affect rendition of sunflower petals{p_end}
{synopt:{opt flower:sonly}}show petals only; do not render bins{p_end}
{synopt:{opt nosingle:petal}}suppress single petals{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall, By}
{synopt:{it:twoway_options}}any options documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}

{synoptset 32}{...}
{marker bin_options}{...}
{synopthdr:bin_options}
{synoptline}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth bsty:le(areastyle)}}overall look of hexagonal bins
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth bc:olor(colorstyle)}}outline and fill color
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth bfc:olor(colorstyle)}}fill color
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth blst:yle(linestyle)}}overall look of outline
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth blc:olor(colorstyle)}}outline color
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth blw:idth(linewidthstyle)}}thickness of outline
{p_end}
{synoptline}

{marker petal_options}{...}
{synopthdr:petal_options}
{synoptline}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth fls:tyle(linestyle)}}overall style of sunflower petals
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth flc:olor(colorstyle)}}color of sunflower petals
{p_end}
{synopt:[{cmdab:l:}{c |}{cmdab:d:}]{opth flw:idth(linewidthstyle)}}thickness of sunflower petals
{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
All options are {it:rightmost}; see {it:{help repeated_options}}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Smoothing and densities > Density-distribution sunflower plot}


{marker description}{...}
{title:Description}

{pstd}
{opt sunflower} draws density-distribution sunflower plots
({help sunflower##PD2003:Plummer and Dupont 2003}).  Dark sunflowers, light
sunflowers, and marker symbols represent high-, medium-, and low-density
regions of the data, respectively.  These plots are useful for displaying
bivariate data whose density is too great for conventional scatterplots to be
effective.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R sunflowerQuickstart:Quick start}

        {mansection R sunflowerRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt nograph} prevents the graph from being generated.

{phang}
{opt notable} prevents the summary table from being displayed.  This option is
implied when the {opt by()} option is specified.

{phang}
{it:marker_options}
    affect the rendition of markers drawn at the plotted points, including
    their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{dlgtab:Bins/Petals}

{phang}
{opt binwidth(#)} specifies the horizontal width of the hexagonal
bins in the same units as {it:xvar}.  By default,

{pin2}
{it:binwidth} = {cmd:max(}rbw,nbw{cmd:)}

{pmore}
where

{pin2}
rbw = range of {it:xvar}/40

{pin2}
nbw = range of {it:xvar}/{cmd:max(1,}nb{cmd:)}

{pmore}
and

{pin2}
nb = {cmd:int(min(sqrt(}{it:n}{cmd:),10*}{cmd:log10(}{it:n}{cmd:)}{cmd:)}{cmd:)}

{pmore}
where 

{pin2}
{it:n} = the number of observations in the dataset

{phang}
{opt binar(#)} specifies the aspect ratio for the hexagonal bins.
The height of the bins is given by

{pin2}
{it:binheight} = {it:binwidth} * {it:#} * 2/sqrt(3)

{pmore}
where {it:binheight} and {it:binwidth} are specified in the units of
{it:yvar} and {it:xvar}, respectively.
The default is {opt binar(r)}, where {it:r} results in the rendering of
regular hexagons.

{phang}
{it:bin_options} affect how the hexagonal bins are rendered.

{phang2}
{opt lbstyle(areastyle)} and {opt dbstyle(areastyle)}
    specify the look of the light and dark hexagonal bins, respectively.  The
    options listed below allow you to change each attribute, but
    {opt lbstyle()} and {opt dbstyle()} provide the starting points.  See
    {manhelpi areastyle G-4} for a list of available area styles.

{phang2}
{opt lbcolor(colorstyle)} and {opt dbcolor(colorstyle)}
    specify one color to be used both to outline the shape
    and to fill the interior of the light and dark hexagonal bins,
    respectively.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang2}
{opt lbfcolor(colorstyle)} and {opt dbfcolor(colorstyle)}
    specify the color to be used to fill the interior of the light and dark
    hexagonal bins, respectively.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang2}
{opt lblstyle(linestyle)} and {opt dblstyle(linestyle)}
    specify the overall style of the line used to outline the area, which
    includes its pattern (solid, dashed, etc.), thickness, and color.
    The other options listed below allow you to change the line's attributes,
    but {opt lblstyle()} and {opt dblstyle()} are the starting points.
    See {manhelpi linestyle G-4} for a list of choices.

{phang2}
{opt lblcolor(colorstyle)} and {opt dblcolor(colorstyle)}
    specify the color to be used to outline the light and dark hexagonal bins,
    respectively.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang2}
{opt lblwidth(linewidthstyle)} and {opt dblwidth(linewidthstyle)}
    specify the thickness of the line to be used to outline the light and dark
    hexagonal bins, respectively.
    See {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{opt light(#)} specifies the minimum number of observations needed
for a bin to be represented by a light sunflower.  The default is
{cmd:light(3)}.

{phang}
{opt dark(#)} specifies the minimum number of observations needed
for a bin to be represented by a dark sunflower.  The default is
{cmd:dark(13)}.

{phang}
{opt xcenter(#)} and {opt ycenter(#)} specify the center
of the reference bin.  The default values are the median values of
{it:xvar} and {it:yvar}, respectively.  The centers of the other bins are
implicitly defined by the location of the reference bin together with the
common bin width and height.

{phang}
{marker petalweight}{...}
{opt petalweight(#)} specifies the number of observations
represented by each petal of a dark sunflower.  The default value is chosen so
that the maximum number of petals on a dark sunflower is 14.

{phang}
{opt petallength(#)} specifies the length of petals in the
sunflowers.  The value specified is interpreted as a percentage of half the
bin width.  The default is 100%.

{phang}
{it:petal_options} affect how the sunflower petals are rendered.

{phang2}
{opt lflstyle(linestyle)} and {opt dflstyle(linestyle)}
	specify the overall style of the light and dark sunflower petals,
	respectively.

{phang2}
{opt lflcolor(colorstyle)} and {opt dflcolor(colorstyle)}
	specify the color of the light and dark sunflower petals,
	respectively.

{phang2}
{opt lflwidth(linewidthstyle)} and {opt dflwidth(linewidthstyle)}
	specify the width of the light and dark sunflower petals,
	respectively.

{phang}
{opt flowersonly} suppresses rendering of the bins.  This option is
equivalent to specifying {cmd:lbcolor(none)} and {cmd:dbcolor(none)}.

{phang}
{opt nosinglepetal} suppresses flowers from being drawn in light bins that
contain only 1 observation and dark bins that contain as many observations
as the petal weight (see the {helpb sunflower##petalweight:petalweight()}
option).

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}.  These include options for titling the graph
(see {manhelpi title_options G-3}), options for saving the graph to disk
(see {manhelpi saving_option G-3}), and the {opt by()} option (see
{manhelpi by_option G-3}).


{marker remarks}{...}
{title:Remarks}

{pstd}
A sunflower is several line segments of equal length, called petals, that
radiate from a central point.  There are two varieties of sunflowers: light
and dark.  Each petal of a light sunflower represents 1 observation.  Each
petal of a dark sunflower represents several observations.
Dark and light sunflowers represent high- and medium-density regions of the
data, and marker symbols represent individual observations in low-density
regions.

{pstd}
{cmd:sunflower} divides the plane defined by the variables {it:yvar} and
{it:xvar} into contiguous hexagonal bins.  The number of observations
contained within a bin determines how the bin will be represented.

{phang}
o  When there are fewer than {opt light(#)} observations in a bin,
    each point is plotted using the usual marker symbols in a scatterplot.

{phang}
o  Bins with at least {opt light(#)} but fewer than
    {opt dark(#)} observations are represented by a light sunflower.
    Each petal of a light sunflower represents one observation in the bin.

{phang}
o  Bins with at least {opt dark(#)} observations are represented by
    a dark sunflower.  Each petal of a dark sunflower represents multiple
    observations.


{marker examples}{...}
{title:Examples}

    {cmd:. sysuse auto}

    {cmd:. sunflower mpg displ}
      {it:({stata "gr_example auto: sunflower mpg displ":click to run})}

{p 4 6 2}
{cmd:. sunflower mpg displ, xcenter(100) ycenter(100) binwidth(20)}{break}
{it:({stata "gr_example auto: sunflower mpg displ, xcenter(100) ycenter(100) binwidth(20)":click to run})}

{p 4 6 2}
{cmd:. sunflower mpg weight, binwidth(500) petalweight(2) dark(8)}{break}
{it:({stata "gr_example auto: sunflower mpg weight, binwidth(500) petalweight(2) dark(8)":click to run})}


{marker reference}{...}
{title:Reference}

{marker PD2003}{...}
{phang}
Plummer, W. D., Jr., and W. D. Dupont. 2003. Density distribution sunflower
plots. {it:Journal of Statistical Software} 8: 1-11.
{p_end}
