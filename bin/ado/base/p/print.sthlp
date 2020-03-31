{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[R] translate" "mansection R translate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] log" "help log"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{vieweralsosee "viewer" "help viewer"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{viewerjumpto "Syntax" "print##syntax"}{...}
{viewerjumpto "Description" "print##description"}{...}
{viewerjumpto "Links to PDF documentation" "print##linkspdf"}{...}
{viewerjumpto "Options" "print##options"}{...}
{viewerjumpto "Examples" "print##examples"}{...}
{viewerjumpto "Technical note for Unix users" "print##technote"}{...}
{viewerjumpto "Technical note for Unix(GUI) users" "print##GUI"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] translate} {hline 2}}Printing files
{p_end}
{p2col:}({mansection R translate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:print} {it:filename} [{cmd:,} {cmd:like(}{it:ext}{cmd:)}
 {cmd:name(}{it:windowname}{cmd:)} {it:override_options} ]

{pstd}
{it:filename}, in addition to being the filename to be printed, may be
specified as {cmd:@Result} to mean print the Results window, {cmd:@Viewer}
to mean print the topmost Viewer window, and {cmd:@Graph} to mean print the
topmost Graph window.  Unix(GUI) users should use the
{cmd:name} option when specifying {cmd:@Viewer} or {cmd:@Graph} to ensure
the correct window is printed when there is more than one viewer or graph
open
(see the {help print##GUI:Technical note for Unix(GUI) users}).


{marker description}{...}
{title:Description}

{pstd}
{cmd:print} prints log and SMCL files.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R translateQuickstart:Quick start}

        {mansection R translateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:like(}{it:ext}{cmd:)} specifies how the file should be translated to a
form suitable to print.  The default is to determine the translation method
based on the extension of {it:filename}.  Thus, {hi:mylog.smcl} is translated
according to the rule for translating {hi:smcl} files.  (The rule in this case
is {help translate}'s {cmd:smcl2prn} translator.)

{pmore}
Rules for the following extensions are predefined:

{p 12 22 2}{hi:.txt} {space 2} Assume input file contains plain text{p_end}
{p 12 22 2}{hi:.log} {space 2} Assume input file contains Stata log text

{p 12 22 2}{hi:.smcl} {space 1} Assume input file contains {help smcl:SMCL}

{pmore}
If you wish to print a file that has an extension different from those
listed above, you can define a new extension, but you do not have to do that.
If file {hi:read.me} contained text, you could type
{cmd:print read.me, like(txt)}.  On the other hand, you could type

{p 12 16 2}{cmd:. transmap define .me .txt}

{pmore}
to tell Stata that {hi:.me} files are always treated like {hi:.txt}
files.

{pmore}
Option {cmd:like()} overrides the recorded rules.

{phang}
{cmd:name(}{it:windowname}{cmd:)} specifies which window to print when
printing a viewer or graph.  Omitting the {cmd:name()} option prints the
topmost viewer or graph (Unix(GUI) users: see 
{help print##GUI:Technical note for Unix(GUI) users}).  The {cmd:name()}
option is ignored when printing the Results window.

{pmore}
The name for a window is inside parentheses in the window title.
For example, if the title for a Viewer window is
{hi:Viewer (}{hi:#1}{hi:)}{hi: [help print]}, the name for the 
window is {hi:#1}.  If the title for a Graph window is {hi:Graph (MyGraph)},
the name for the window is {hi:MyGraph}.  If a graph is an {cmd:asis} or
{cmd:graph7} graph where there is no name in the window title, then specify 
{hi:""} for {it:windowname}.

{phang}
{it:override_options} refers to {help translate}'s override options.
{cmd:print} uses {cmd:translate} to translate the file into a format suitable
for sending to the printer.  To find out what is overrideable for {it:X}
files, type "{cmd:translator query} {it:X}{cmd:2prn}".  For example, to find
out what is overrideable for printing {cmd:smcl} files, type
"{cmd:translator query smcl2prn}".  See {help translate}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. print mylog.smcl}

{phang}{cmd:. print mylog.log}

{phang}{cmd:. print @Results}

{phang}{cmd:. print @Viewer}

{phang}{cmd:. print @Graph, name(MyGraph)}


{marker technote}{...}
{title:Technical note for Unix users}

{pstd}
As shipped, Stata assumes you have a PostScript printer attached to your
Unix computer and that the Unix command lpr(1) can be used to send PostScript
files to it.  If you need to change that, see {help printer}.
For those who have read that, you will remember that one
of the examples was

{phang2}{cmd:. printer define prn ps "lpr -Plexmark @"}

{pstd}
You can also define multiple printers.  In that case, {cmd:print} has
syntax

{p 8 14 2}{cmd:print} {it:filename} [{cmd:,} {cmd:like(}{it:ext}{cmd:)}
{cmdab:pr:inter:(}{it:printername}{cmd:)} {it:override_options} ]


{marker GUI}{...}
{title:Technical note for Unix(GUI) users}

{pstd}
X-Windows does not have a concept of a window z-order which prevents Stata
from determining which window is the topmost window.  Instead, Stata
determines which window is topmost based on which window has the focus.
However, some window managers will set the focus to a window without bringing
the window to the top.  What is the topmost window to Stata may not appear
topmost visually.  For this reason, you should always use the {cmd:name()}
option to ensure the correct Viewer or Graph window is printed.
{p_end}
