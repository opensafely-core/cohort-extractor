{smcl}
{* *! version 1.1.2  19oct2017}{...}
{vieweralsosee "[G-2] graph print" "mansection G-2 graphprint"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] pr_options" "help pr_options"}{...}
{vieweralsosee "[G-2] set printcolor" "help set_printcolor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph display" "help graph_display"}{...}
{vieweralsosee "[G-2] graph use" "help graph_use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{viewerjumpto "Syntax" "graph_print##syntax"}{...}
{viewerjumpto "Description" "graph_print##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_print##linkspdf"}{...}
{viewerjumpto "Options" "graph_print##options"}{...}
{viewerjumpto "Remarks" "graph_print##remarks"}{...}
{viewerjumpto "Technical notes" "graph_print##technote"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-2] graph print} {hline 2}}Print a graph{p_end}
{p2col:}({mansection G-2 graphprint:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:gr:aph}
{cmd:print}
[{cmd:, name(}{it:windowname}{cmd:)}
{it:{help pr_options}}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:print} prints the graph displayed in a Graph
window.

{pstd}
Stata for Unix users must do some setup before using {cmd:graph} {cmd:print}
for the first time; see
{it:{help graph print##remarks4:Appendix:  Setting up Stata for Unix to print graphs}} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphprintQuickstart:Quick start}

        {mansection G-2 graphprintRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:name(}{it:windowname}{cmd:)} specifies which window to print when
printing a graph.  The default is for Stata to print the topmost graph
(Unix(GUI) users: see
{it:{help graph print##GUI:Technical note for Stata for Unix(GUI) users}}).

{p 8 8 2}
The window name is located inside parentheses in the window title.
For example, if the title for a Graph window is {hi:Graph (MyGraph)}, the name
for the window is {hi:MyGraph}.  If a graph is an {cmd:asis} or {cmd:graph7}
graph, where there is no name in the window title, then specify {cmd:""} for
{it:windowname}.

{phang}
{it:pr_options}
    modify how the graph is printed.  See {manhelpi pr_options G-3}.

{phang}
Default values for the options may be set using
{manhelp graph_set G-2:graph set}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Graphs are printed by displaying them on the screen and then typing

	{cmd:. graph print}

{pstd}
Remarks are presented under the following headings:

	{help graph print##remarks1:Printing the graph displayed in a Graph window}
	{help graph print##remarks2:Printing a graph stored on disk}
	{help graph print##remarks3:Printing a graph stored in memory}
	{help graph print##remarks4:Appendix:  Setting up Stata for Unix to print graphs}

{pstd}
Also see {manhelp set_printcolor G-2:set printcolor}.  By default, if the graph
being printed has a black background, it is printed in monochrome.

{pstd}
In addition to printing graphs, Stata can export graphs in
PostScript,
Encapsulated PostScript (EPS),
Portable Network Graphics (PNG),
TIFF,
Windows Metafile (WMF), and
Windows Enhanced Metafile (EMF);
see {manhelp graph_export G-2:graph export}.


{marker remarks1}{...}
{title:Printing the graph  displayed in a Graph window}

{pstd}
There are three ways to print the graph displayed in a Graph window:

{phang2}
    1.  Right-click in the Graph window, and select {bf:Print...}.

{phang2}
    2.  Select {bf:File > Print Graph...}.

{phang2}
    3.  Type "{cmd:graph} {cmd:print}" in the Command window.
        Stata for Unix(GUI) users should use the {cmd:name()} option if there
        is more than one graph displayed to ensure that the correct graph is
        printed (see 
        {it:{help graph print##GUI:Technical note for Stata for Unix(GUI) users})}.

{pstd}
All are equivalent.  The advantage of {cmd:graph} {cmd:print} is that you may
include it in do-files:

	{cmd:. graph} ...{col 40}(draw a graph)

	{cmd:. graph print}{col 40}(and print it)


{marker remarks2}{...}
{title:Printing a graph stored on disk}

{pstd}
To print a graph stored on disk, type

	{cmd:. graph use} {it:filename}

	{cmd:. graph print}

{pstd}
Do not specify {cmd:graph} {cmd:use}'s {cmd:nodraw} option; see 
{manhelp graph_use G-2:graph use}.

{pstd}
Stata for Unix(console) users:  follow the instructions just given,
even though you have no Graph window and cannot see what has just been
"displayed".  Use the graph, and then print it.


{marker remarks3}{...}
{title:Printing a graph stored in memory}

{pstd}
To print a graph stored in memory but not currently displayed, type

	{cmd:. graph display} {it:name}

	{cmd:. graph print}

{pstd}
Do not specify {cmd:graph} {cmd:display}'s {cmd:nodraw} option; see
{manhelp graph_display G-2:graph display}.

{pstd}
Stata for Unix(console) users:  follow the instructions just given,
even though you have no Graph window and cannot see what has just been
"displayed".  Display the graph, and then print it.


{marker remarks4}{...}
{title:Appendix:  Setting up Stata for Unix to print graphs}

{pstd}
Before you can print graphs, you must tell Stata the command you ordinarily
use to print PostScript files.  By default, Stata assumes that the command
is

	{cmd:$ lpr < }{it:filename}

{pstd}
That command may be correct for you.  If, on the other hand, you usually
type something like

	{cmd:$ lpr -Plexmark} {it:filename}

{pstd}
you need to tell Stata that by typing

	{cmd:. printer define prn ps "lpr -Plexmark @"}

{pstd}
Type an {cmd:@} where you ordinarily would type the filename.  If you
want the command to be "{cmd:lpr -Plexmark < @}", type

	{cmd:. printer define prn ps "lpr -Plexmark < @"}

{pstd}
Stata assumes that the printer you specify understands PostScript format.


{marker technote}{...}
{title:Technical note for Stata for Unix users}

{pstd}
Stata for Unix uses PostScript to print graphs.  If the graph you wish to
print contains Unicode characters, those characters may not appear correctly
in PostScript files because the PostScript fonts do not support Unicode.
Stata will map as many characters as possible to characters supported by
Unicode but will print a question mark (?) for any unsupported character.  We
recommend that you export the graph to a PDF file, which has fonts with
better support for Unicode characters.
See {manhelp graph_export G-2:graph export}.


{marker GUI}{...}
{title:Technical note for Stata for Unix(GUI) users}

{pstd}
X-Windows does not have the concept of a window z-order, which prevents Stata
from determining which window is the topmost window.  Instead, Stata
determines which window is topmost based on which window has the focus.
However, some window managers will set the focus to a window without bringing
the window to the top.  What Stata considers the topmost window may not appear
topmost visually.  For this reason, you should always use the {cmd:name()}
option to ensure that the correct Graph window is printed.
{p_end}
