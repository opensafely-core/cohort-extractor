{smcl}
{* *! version 1.1.15  18feb2019}{...}
{viewerdialog dotplot "dialog dotplot"}{...}
{vieweralsosee "[R] dotplot" "mansection R dotplot"}{...}
{viewerjumpto "Syntax" "dotplot##syntax"}{...}
{viewerjumpto "Menu" "dotplot##menu"}{...}
{viewerjumpto "Description" "dotplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "dotplot##linkspdf"}{...}
{viewerjumpto "Options" "dotplot##options"}{...}
{viewerjumpto "Remarks" "dotplot##remarks"}{...}
{viewerjumpto "Examples" "dotplot##examples"}{...}
{viewerjumpto "Stored results" "dotplot##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] dotplot} {hline 2}}Comparative distribution dotplots{p_end}
{p2col:}({mansection R dotplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Dotplot of varname, with one column per value of groupvar

{p 8 16 2}
{cmd:dotplot} {varname} {ifin} [{cmd:,} {it:options}]


{phang}
Dotplot for each variable in varlist, with one column per variable

{p 8 16 2}
{cmd:dotplot} {varlist} {ifin} [{cmd:,} {it:options}]


{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth "over(varlist:groupvar)"}}display one columnar dotplot for each value of {it:groupvar}{p_end}
{synopt :{opt nx(#)}}horizontal dot density; default is {cmd:nx(0)}{p_end}
{synopt :{opt ny(#)}}vertical dot density; default is {cmd:ny(35)}{p_end}
{synopt :{opt i:ncr(#)}}label every {it:#} group; default is {cmd:incr(1)}{p_end}
{synopt :{opt mean}|{opt med:ian}}plot a horizontal line of pluses at the mean or median{p_end}
{synopt :{opt bo:unded}}use minimum and maximum as boundaries{p_end}
{synopt :{opt b:ar}}plot horizontal dashed lines at shoulders of each group{p_end}
{synopt :{opt nogr:oup}}use the actual values of {it:{help varname:yvar}}{p_end}
{synopt :{opt ce:nter}}center the dot for each column{p_end}

{syntab :Plot}
INCLUDE help gr_markopt2

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
     {manhelpi twoway_options G-3} {p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Distributional graphs > Distribution dotplot}


{marker description}{...}
{title:Description}

{pstd}
A dotplot is a scatterplot with values grouped together vertically ("binning",
as in a histogram) and with plotted points separated horizontally.  The aim is
to display all the data for several variables or groups in one compact graphic.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R dotplotQuickstart:Quick start}

        {mansection R dotplotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth "over(varlist:groupvar)"} identifies the variable for which {cmd:dotplot}
will display one columnar dotplot for each value of {it:groupvar}.
{opt over()} may not be specified in the second syntax.

{phang}
{opt nx(#)} sets the horizontal dot density.  A larger value of {it:#} will
increase the dot density, reducing the horizontal separation between dots.
This option will increase the separation between columns if two or more groups
or variables are used.

{phang}
{opt ny(#)} sets the vertical dot density (number of "bins" on the
y axis).  A larger value of {it:#} will result in more bins and a plot
that is less spread out horizontally.  {it:#} should be
determined in conjunction with {opt nx()} to give the most pleasing
appearance.

{phang}
{opt incr(#)} specifies how the x axis is to be labeled.  {cmd:incr(1)},
the default, labels all groups.  {cmd:incr(2)} labels every second group.

{phang}
[{opt mean}|{opt median}] plots a horizontal line of pluses at the mean or 
median of each group.

{phang}
{opt bounded} forces the minimum and maximum of the variable to be used as
boundaries of the smallest and largest bins.  It should be used with one
variable whose support is not the whole of the real line and whose
density does not tend to zero at the ends of its support, for example, a
uniform random variable or an exponential random variable.

{phang}
{opt bar} plots horizontal dashed lines at the "shoulders" of each group.  The
shoulders are taken to be the upper and lower quartiles unless {opt mean}
had been specified; here they will be the mean plus or minus the
standard deviation.

{phang}
{opt nogroup} uses the actual values of {it:{help varname:yvar}} rather than
grouping them (the default).  This option may be useful if {it:yvar} takes on
only a few values.

{phang}
{opt center} centers the dots for each column on a hidden vertical line.

{dlgtab:Plot}

{phang}
{it:marker_options}
    affect the rendition of markers drawn at the plotted points, including
    their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.
    {it:marker_label_options} are not allowed if {varlist} is specified.

{dlgtab :Y axis, X axis, Titles, Legend, Overall}

{phang} {it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include
options for titling the graph (see {manhelpi title_options G-3}) and for
saving the graph to disk (see {manhelpi saving_option G-3}).


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:dotplot} produces a figure that has elements of a boxplot, a histogram,
and a scatterplot.  Like a boxplot, it is most useful for comparing the
distributions of several variables or the distribution of 1 variable
in several groups.  Like a histogram, the figure provides a crude estimate of
the density, and, as with scatterplot, each symbol (dot) represents 1 
observation.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Draw dotplots of {cmd:mpg}, separately for foreign and domestic cars
{p_end}
{phang2}{cmd:. dotplot mpg, over(foreign)}{p_end}

{pstd}Same as above, but change dot densities, center the dots,
plot line of pluses at median, plot dashed lines at upper and lower quartiles
{p_end}
{phang2}{cmd:. dotplot mpg, over(foreign) nx(20) ny(10) center median bar}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse dotgr}{p_end}

{pstd}Draw dotplots, with one column per variable{p_end}
{phang2}{cmd:. dotplot g1r1-g1r10}{p_end}

{pstd}Same as above, but add title{p_end}
{phang2}{cmd:. dotplot g1r1-g1r10, title("Tumor volume, cu mm")}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dotplot} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(nx)}}horizontal dot density{p_end}
{synopt:{cmd:r(ny)}}vertical dot density{p_end}
{p2colreset}{...}
