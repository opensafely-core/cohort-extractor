{smcl}
{* *! version 1.0.2  04nov2014}{...}
{vieweralsosee "undocumented" "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Syntax" "twoway_mata##syntax"}{...}
{viewerjumpto "Description" "twoway_mata##description"}{...}
{viewerjumpto "Remarks" "twoway_mata##remarks"}{...}
{viewerjumpto "Examples" "twoway_mata##examples"}{...}
{title:Title}

{p2colset 5 26 28 2}{...}
{p2col :{bf:[G-2] twoway mata} {hline 2}}Twoway graphs of mata matrices{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
[{cmdab:gr:aph}]
{cmdab:tw:oway}
{it:plot} [{it:plot} ...]
{ifin}
[{cmd:,}
{it:{help twoway_options}}]

{pstd}
where the syntax of {it:plot} is

{pin}
[{cmd:(}]
{it:plottype} {it:mata_matrix_name} [{it:column_names}]...{cmd:,} {it:options}
[{cmd:)}] [{cmd:||}]

{synoptset 20}{...}
{p2col :{it:plottype}}Description{p_end}
{p2line}
{p2col :{helpb scatter}}scatterplot{p_end}
{p2col :{helpb line}}line plot{p_end}
{p2col :{helpb twoway_connected:connected}}connected-line plot{p_end}

{marker barplots}{...}
{p2col :{helpb twoway_area:area}}line plot with shading{p_end}
{p2col :{helpb twoway_bar:bar}}bar plot{p_end}
{p2col :{helpb twoway_spike:spike}}spike plot{p_end}
{p2col :{helpb twoway_dropline:dropline}}dropline plot{p_end}
{p2col :{helpb twoway_dot:dot}}dot plot{p_end}

{marker rangeplots}{...}
{p2col :{helpb twoway_rarea:rarea}}range plot with area shading{p_end}
{p2col :{helpb twoway_rbar:rbar}}range plot with bars{p_end}
{p2col :{helpb twoway_rspike:rspike}}range plot with spikes{p_end}
{p2col :{helpb twoway_rcap:rcap}}range plot with capped spikes{p_end}
{p2col :{helpb twoway_rcapsym:rcapsym}}range plot with spikes capped with symbols{p_end}
{p2col :{helpb twoway_rscatter:rscatter}}range plot with markers{p_end}
{p2col :{helpb twoway_rline:rline}}range plot with lines{p_end}
{p2col :{helpb twoway_rconnected:rconnected}}range plot with lines and markers{p_end}
{p2line}
{p2colreset}{...}

{pstd}
{it:plot} may also be any syntax for plotting data from the current dataset as
documented in {helpb graph twoway}.  Multiple Mata matrix plots and data plots
may be overlayed in a single {cmd:graph twoway} command.

{pstd}
The leading {cmd:graph} is optional.
If the first (or only) {it:plot} is {cmd:scatter}, you may omit
{cmd:twoway} as well, and then the syntax is

{p 8 20 2}
{cmdab:sc:atter} ... [{cmd:,} {it:scatter_options}]
[ {cmd:||}
{it:plot} [{it:plot} [...]]]

{pstd}
and the same applies to {cmd:line}.  The other
{it:plottypes} must be preceded by {cmd:twoway}.

{pstd}
Regardless of how the command is specified,
{it:twoway_options}
may be specified among the
{it:scatter_options}, {it:line_options}, etc., and they will be treated just
as if they were specified among the {it:twoway_options} of the
{cmd:graph} {cmd:twoway} command.


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} is a family of plots, all of which use numeric {it:y} and
{it:x} scales.  The data for these plots typically come from the current
dataset as documented in {helpb graph twoway}.  Here we document graphing the
columns of Mata matrices as though they were dataset variables by using the
same {cmd:twoway} command.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks assume familiarity with {helpb graph twoway} and with the concepts of
twoway plots as described there.  Here we simply extend the standard
{cmd:twoway} syntax to support plotting columns of Mata matrices as though
they were variables in the dataset.  

{pstd}
The advantage of this extended syntax over putting your Mata matrix into the
dataset using {helpb getmata:putmata} or {helpb mf_st_store:st_store()}
involves both speed and space.  The syntax documented here causes the data
from the Mata matrices to be placed directly into the graphics system without
first creating variables in your Stata dataset.  This advantage will typically
only matter when you have datasets with huge numbers of observations.

{pstd}
Aside from using Mata matrices as data, the syntax of {cmd:twoway} remains
unchanged.  Let's create two mata matrices to demonstrate.

{phang2}{cmd:. mata:  amat = 1,2  \  3,4 \ 4,5 \ 5,6}{p_end}
{phang2}{cmd:. mata:  bmat = .9,1.1,2  \  2.8,3.4,4 \ 3.7,4.5,5 \ 4.6,6,6}

{pstd}
We graph a scatterplot of the first column of {cmd:amat} against its second
column by typing

{phang2}{cmd:. twoway scatter matamatrix(amat)}

{pstd}
The first column of {cmd:amat} will be the y variable and will by default be
labeled "amat1".  The second column will be the x variable and will by default
be labeled "x".  We can change both of these names by specifying a list of
names after {cmd:matamatrix()}:

{phang2}{cmd:. twoway scatter matamatrix(amat) yvarname xvarname}

{pstd}
When the matrix has more than two columns, say, k columns, the columns 1
through k-1 are treated as y variables to be plotted, and column k is the
x variable for each to be plotted against.  This is identical to how
{cmd:twoway} handles varlist specifications:

{phang2}{cmd:. twoway scatter y1 y2 x}

{pstd}
Using our {cmd:bmat}, we type
    
{phang2}{cmd:. twoway scatter matamatrix(bmat)}

{pstd}
to obtain two scatterplots, one for the first column of {cmd:bmat} and one for
the second column.

{pstd}
We can rename those two plots by typing

{phang2}{cmd:. twoway scatter matamatrix(bmat) y1 y2}

{pstd}
We can also rename the x variable by typing

{phang2}{cmd:. twoway scatter matamatrix(bmat) y1 y2 ourx}

{pstd}
As with other twoway plots, we can overlay plots of Mata matrices:

{phang2}{cmd:. twoway scatter matamatrix(amat) || scatter matamatrix(bmat)}

{pstd}
We can treat the first two columns of our {cmd:bmat} as a range plot:

{phang2}{cmd:. twoway scatter matamatrix(amat) || rcap matamatrix(bmat)}

{pstd}
And we can intermix plots of Mata matrices with plots of Stata variables:

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. twoway scatter matamatrix(amat) || scatter gear_ratio rep78}

{pstd}
This is a silly graph, but it shows the syntax.

{pstd}
What {cmd:twoway} does when your matrix has many columns depends on the plot
type.  {cmd:scatter}, {cmd:line}, and {cmd:connected} create plots for k-1
columns, where k is the number of columns in your matrix.  All other plot
types enforce that the matrix has the exact number of required columns --
two columns for {cmd:area}, {cmd:bar}, {cmd:spike}, {cmd:dropline}, and
{cmd:dot} types; and three columns for {cmd:rarea}, {cmd:rbar}, {cmd:rspike},
{cmd:rcap}, {cmd:rcapsym}, {cmd:rline}, and {cmd:rconnected} plot types.  If
your Mata matrix has extra columns you do not want to graph, use standard mata
column referencing to create a matrix with fewer columns:

{phang2}{cmd:mata:  b = a[., 1..3]}

{pstd}
creates b with the first 3 columns of a;

{phang2}{cmd:mata:  b = a[., 5..6]}

{pstd}
creates b with the 5th and 6th columns of a; and

{phang2}{cmd:mata:  b = a[., (2,7,3)]}

{pstd}
creates b with the 2nd and 7th and 3rd columns of a, with the 2nd column of a
becoming the first column of b, the 7th column of a becoming the 2nd column of
b, and the 3rd column of a becoming the 3rd column of b.


{marker examples}{...}
{title:Examples}

{p 4 4 2}
    Create a mata matrix named {cmd:mymat} having three columns

{p 8 8 2}
    {cmd:mata:  mymat = 1,1.1,2  \  3,3.4,4 \ 4,4.5,5 \ 5,6,6}

{p 4 4 2}
    Create a scatterplot of the data in {cmd:mymat}, treating the first column
    as the y values for the first plot, the second column as the y values for
    the second plot, and the third column as the x values for both plots

{p 8 8 2}
	{cmd:twoway scatter matamatrix(mymat)}

{p 4 4 2}
    As above, naming the first two columns (plots) {cmd:plot1} and {cmd:plot2}

{p 8 8 2}
	{cmd:twoway scatter matamatrix(mymat) plot1 plot2}

{p 4 4 2}
    Create a range spike plot of the data in {cmd:mymat}, treating the first
    column as the lower y values of the spikes, the second column as the upper
    y values of the spikes, and the third column as the x values for the
    spikes

{p 8 8 2}
	{cmd:twoway rspike matamatrix(mymat)}

{p 4 4 2}
     As above, adding a scatterplot of variables {cmd:yvar} and {cmd:xvar}
     from the current dataset

{p 8 8 2}
	{cmd:twoway rspike matamatrix(mymat) || scatter yvar xvar}
{p_end}
