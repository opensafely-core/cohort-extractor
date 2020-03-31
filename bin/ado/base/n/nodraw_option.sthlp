{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-3] nodraw_option" "mansection G-3 nodraw_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "nodraw_option##syntax"}{...}
{viewerjumpto "Description" "nodraw_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "nodraw_option##linkspdf"}{...}
{viewerjumpto "Option" "nodraw_option##option"}{...}
{viewerjumpto "Remarks" "nodraw_option##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:nodraw_option} {hline 2}}Option for suppressing display of graph{p_end}
{p2col:}({mansection G-3 nodraw_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:nodraw_option}}Description{p_end}
{p2line}
{p2col:{cmd:nodraw}}suppress display of graph{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}{cmd:nodraw} is {it:unique}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:nodraw} prevents the graph from being displayed. Graphs drawn
with {cmd:nodraw} may not be printed or exported, though they may be saved.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 nodraw_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:nodraw}
    specifies that the graph not be displayed.


{marker remarks}{...}
{title:Remarks}

{pstd}
When you type, for instance,

	{cmd:. scatter yvar xvar, saving(mygraph)}

{pstd}
a graph is displayed and is stored in file
{cmd:mygraph.gph}.  If you type

	{cmd:. scatter yvar xvar, saving(mygraph) nodraw}

{pstd}
the graph will still be saved in file {cmd:mygraph.gph}, but it will not be
displayed.  The result is the same as if you typed

	{cmd:. set graphics off}
	{cmd:. scatter yvar xvar, saving(mygraph)}
	{cmd:. set graphics on}

{pstd}
Here, however, the graph may also be printed or exported.

{pstd}
You need not specify {cmd:saving()} (see {manhelpi saving_option G-3}) to use
{cmd:nodraw}.  You could type

	{cmd:. scatter yvar xvar, nodraw}

{pstd}
and later type (or code in an ado-file)

	{cmd:. graph display Graph}

{pstd}
See {manhelp graph_display G-2:graph display}.
{p_end}
