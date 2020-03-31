{smcl}
{* *! version 1.1.7  31jul2019}{...}
{vieweralsosee "[G-2] set graphics" "mansection G-2 setgraphics"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] nodraw_option" "help nodraw_option"}{...}
{viewerjumpto "Syntax" "set_graphics##syntax"}{...}
{viewerjumpto "Description" "set_graphics##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_graphics##linkspdf"}{...}
{viewerjumpto "Remarks" "set_graphics##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-2] set graphics} {hline 2}}Set whether graphs are displayed{p_end}
{p2col:}({mansection G-2 setgraphics:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:q:uery}
{cmdab:graph:ics}

{p 8 16 2}
{cmd:set}
{cmdab:g:raphics}
{c -(}{cmd:on} | {cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:query} {cmd:graphics} shows the graphics settings.

{pstd}
{cmd:set} {cmd:graphics} allows you to change whether graphs are
displayed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 setgraphicsQuickstart:Quick start}

        {mansection G-2 setgraphicsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you type

	{cmd:. set graphics off}

{pstd}
when you type a {cmd:graph} command, such as

	{cmd:. scatter yvar xvar, saving(mygraph)}

{pstd}
the graph will be "drawn" and saved in file {cmd:mygraph.gph}, but it will not
be displayed.  If you type

	{cmd:. set graphics on}

{pstd}
graphs will be displayed once again.

{pstd}
Drawing graphs without displaying them is sometimes useful in programming
contexts, although in such contexts, it is better to specify the {cmd:nodraw}
option; see {manhelpi nodraw_option G-3}.  Typing

	{cmd:. scatter yvar xvar, saving(mygraph) nodraw}

{pstd}
has the same effect as typing

	{cmd:. set graphics off}
	{cmd:. scatter yvar xvar, saving(mygraph)}
	{cmd:. set graphics on}

{pstd}
The former has two advantages: it requires less typing, and if the user
presses {hi:Break}, {cmd:set} {cmd:graphics} will not be left {cmd:off}.
{p_end}
