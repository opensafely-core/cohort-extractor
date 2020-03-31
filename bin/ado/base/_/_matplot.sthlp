{smcl}
{* *! version 1.0.7  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "[P] matlist" "help matlist"}{...}
{vieweralsosee "[P] matrix mkmat" "help svmat"}{...}
{viewerjumpto "Syntax" "_matplot##syntax"}{...}
{viewerjumpto "Description" "_matplot##description"}{...}
{viewerjumpto "Options" "_matplot##options"}{...}
{viewerjumpto "Examples" "_matplot##examples"}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col :{hi:[G-2] _matplot} {hline 2}}Scatterplot of matrix{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_matplot} {it:matname} [{cmd:,} {it:options} ]

{synoptset 22}{...}
{synopthdr}
{synoptline}
{synopt:{opt col:umns(#1 #2)}}columns used as y and x; default 1 2{p_end}
{synopt:{opt matrix}}graph as a scatterplot matrix{p_end}
{synopt:{opt nonam:es}}suppress display of rownames with points{p_end}
{synopt:{it:scatter_options}}see {manhelp scatter G-2:graph twoway scatter}
{p_end}
{synopt:{it:graph_matrix_options}}see {manhelp graph_matrix G-2:graph matrix}
{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_matplot} produces a plot of two columns of a matrix,
with the data points marked by the rownames.  All columns may be plotted
by specifying the {opt matrix} option.


{marker options}{...}
{title:Options}

{phang}{cmd:columns(}{it:#1 #2}{cmd:)}
specifies the columns of the matrices used as the y- and x-coordinate
of the plot.  The y-coordinate is displayed vertically.  The default
is {bind:{cmd:columns(1 2)}}. This option may not be used with 
{opt matrix}.

{phang}{opt matrix} specifies that all columns are to be plotted 
using {cmd:graph matrix}. This option may not be used with 
{cmd:columns()}.

{phang}{cmd:nonames}
suppresses labeling of data with rownames.

{phang}{it:scatter_options}
are any options allowed with {helpb scatter}.  You may be especially
interested in options for the display of the row labels, see
{manhelpi marker_label_options G-3}.

{phang}{it:graph_matrix_options}
affect the rendition of the matrix plot; see
{manhelp graph_matrix G-2:graph matrix}. 
These options are allowed only when the {opt matrix} option is specified.


{marker examples}{...}
{title:Examples}

    {cmd:. _matplot m}
    {cmd:. _matplot m, columns(2 1) }
    {cmd:. _matplot m, matrix nonames }
