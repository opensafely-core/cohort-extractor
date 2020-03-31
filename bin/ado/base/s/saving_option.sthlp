{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[G-3] saving_option" "mansection G-3 saving_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "[G-4] Concept: gph files" "help gph_files"}{...}
{viewerjumpto "Syntax" "saving_option##syntax"}{...}
{viewerjumpto "Description" "saving_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "saving_option##linkspdf"}{...}
{viewerjumpto "Option" "saving_option##option"}{...}
{viewerjumpto "Suboptions" "saving_option##suboptions"}{...}
{viewerjumpto "Remarks" "saving_option##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:saving_option} {hline 2}}Option for saving graph to disk{p_end}
{p2col:}({mansection G-3 saving_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:saving_option}}Description{p_end}
{p2line}
{p2col:{cmd:saving(}{it:{help filename}} [{cmd:,} {it:suboptions}]{cmd:)}}save
      graph to disk{p_end}
{p2line}
{p 4 6 2}{cmd:saving()} is {it:unique}; see {help repeated options}.


{p2col:{it:suboptions}}Description{p_end}
{p2line}
{p2col:{cmd:asis}}freeze graph and save as is{p_end}
{p2col:{cmd:replace}}okay to replace existing {it:filename}{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:saving()} saves the graph to disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 saving_optionQuickstart:Quick start}

        {mansection G-3 saving_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:saving(}{it:{help filename}} [{cmd:,} {it:suboptions}]{cmd:)}
    specifies the name of the diskfile to be created or replaced.
    If {it:filename} is specified without an extension, {cmd:.gph}
    will be assumed.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:asis} specifies that the graph be frozen and saved just as it is.
    The alternative -- and the default if {cmd:asis} is not
    specified -- is known as live format.  In live format, the graph can
    continue to be edited in future sessions, and the overall
    look of the graph continues to be controlled by the chosen scheme (see
    {manhelp schemes G-4:Schemes intro}).

{pmore}Say that you type

	    {cmd:. scatter yvar xvar,} ... {cmd:saving(mygraph)}

{pmore}
    That will create file {cmd:mygraph.gph}.  Now pretend you send that file
    to a colleague.  The way the graph appears on your colleague's computer
    might be different from how it appears on yours.  Perhaps you display titles
    on the top and your colleague has set his scheme to display titles on the
    bottom.  Or perhaps your colleague prefers the {it:y} axis on the right
    rather than the left.  It will still be the same graph,
    but it might have a different look.

{pmore}
    Or perhaps you just file away {cmd:mygraph.gph} for use later.  If you
    store it in the default live format, you can come back to it later and
    change the way it looks by specifying a different scheme or can edit it.

{pmore}
    If, on the other hand, you specify {cmd:asis}, the graph will look forever
    just as it looked the instant it was saved.  You cannot edit it; you
    cannot change the scheme.  If you send the as-is graph to colleagues,
    they will see it in exactly the form you see it.

{pmore}
    Whether a graph is saved as-is or live makes no difference for 
    printing.  As-is graphs usually require fewer bytes to store, and they
    generally display more quickly, but that is all.

{pstd}
{cmd:replace} specifies that the file may be replaced if it already exists.


{marker remarks}{...}
{title:Remarks}

{pstd}
To save a graph permanently, you add {cmd:saving()} to the end of the
{cmd:graph} command (or any place among the options):


	{cmd:. graph} ... {cmd:,} ... {cmd:saving(myfile)} ...
	(file myfile.gph saved)

{pstd}
You can also achieve the same result in two steps:

	{cmd:. graph} ... {cmd:,} ...

	{cmd:. graph save myfile}
	(file myfile.gph saved)

{pstd}
The advantage of the two-part construction is that you can edit the graph
between the time you first draw it and save it.
The advantage of the one-part construction is that you will not forget to
save it.
{p_end}
