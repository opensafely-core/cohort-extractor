{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[G-2] graph save" "mansection G-2 graphsave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "[G-4] Concept: gph files" "help gph_files"}{...}
{viewerjumpto "Syntax" "graph save##syntax"}{...}
{viewerjumpto "Description" "graph save##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_save##linkspdf"}{...}
{viewerjumpto "Options" "graph save##options"}{...}
{viewerjumpto "Remarks" "graph save##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-2] graph save} {hline 2}}Save graph to disk{p_end}
{p2col:}({mansection G-2 graphsave:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:gr:aph}
{cmd:save}
[{it:graphname}]
{it:{help filename}}
[{cmd:,}
{cmd:asis}
{cmd:replace}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:save} saves the specified graph to disk.  If {it:graphname}
is not specified, the graph currently displayed is saved to disk in Stata's
{cmd:.gph} format.

{pstd}
If {it:{help filename}} is specified without an extension, {cmd:.gph} is
assumed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphsaveQuickstart:Quick start}

        {mansection G-2 graphsaveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:asis} specifies that the graph be frozen and saved as is.
    The alternative -- and the default if {cmd:asis} is not
    specified -- is live format.  In live format, the graph can be edited
    in future sessions, and the overall look of the graph
    continues to be controlled by the chosen scheme (see
    {manhelp schemes G-4:Schemes intro}).

{pmore} Say that you type

	    {cmd:. scatter yvar xvar,} ...
	    {cmd:. graph save mygraph}

{pmore}
    which will create file {cmd:mygraph.gph}.  Suppose that you send the
    file to a colleague.  The way the graph will appear on your colleague's
    computer might be different from how it appeared on yours.  Perhaps you
    display titles on the top, and your colleague has set his scheme to display
    titles on the bottom.  Or perhaps your colleague prefers {it:y} axes on
    the right rather than on the left.  It will still be the
    same graph, but it might look different.

{pmore}
    Or perhaps you just file away {cmd:mygraph.gph} for use later.  If the
    file is stored in the default live format, you can come back to it and
    change the way it looks by specifying a different scheme, and you can edit
    it.

{pmore}
    If, on the other hand, you specify {cmd:asis}, the graph will forever look
    just as it looked the instant it was saved.  You cannot edit it, and you
    cannot change the scheme.  If you send the as-is graph to colleagues, they
    will see it exactly in the form that you see it.

{pmore}
    Whether a graph is saved as-is or live makes no difference for
    printing.  As-is graphs usually require fewer bytes to store, and they
    generally display more quickly, but that is all.

{pstd}
{cmd:replace} specifies that the file may be replaced if it already exists.


{marker remarks}{...}
{title:Remarks}

{pstd}
You may instead specify that the graph be saved at the instant you draw
it by specifying the
{cmd:saving(}{it:filename}[{cmd:,}
{cmd:asis}
{cmd:replace}]{cmd:)}
option; see {manhelpi saving_option G-3}.
{p_end}
