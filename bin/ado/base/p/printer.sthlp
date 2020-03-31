{smcl}
{* *! version 1.1.4  19oct2017}{...}
{viewerdialog printer "dialog printer"}{...}
{vieweralsosee "[R] translate" "mansection R translate"}{...}
{viewerjumpto "Syntax" "printer##syntax"}{...}
{viewerjumpto "Description" "printer##description"}{...}
{viewerjumpto "Links to PDF documentation" "printer##linkspdf"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] translate} {hline 2}}Printing files (Unix only)
{p_end}
{p2col:}({mansection R translate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:printer} {cmdab:def:ine} {it:printername} [{{cmd:ps}|{cmd:txt}}
{cmd:"}{it:Unix command with} {cmd:@"} ]

{p 8 16 2}{cmd:printer} {cmdab:q:uery} [{it:printername}]


{marker description}{...}
{title:Description}

{pstd}
The {helpb print} command assumes you have a
PostScript printer attached to your Unix computer and that the Unix
command lpr(1) can be used to send PostScript files to it, but you can
change this.  It is possible that, on your Unix system, typing

{phang2}mycomputer$ {cmd:lpr <} {it:filename}

{pstd}
is not sufficient to print PostScript files.  For instance, perhaps on
your system, you would need to type

{phang2}mycomputer$ {cmd:lpr -Plexmark <} {it:filename}

{pstd}or perhaps you need

{phang2}mycomputer$ {cmd:lpr -Plexmark} {it:filename}

{pstd}or perhaps you need something else.  To set the print command to be
{cmd:lpr -Plexmark} {it:filename} and state that the printer expects to
receive PostScript files, type

{phang2}{cmd:. printer define prn ps "lpr -Plexmark @"}

{pstd}
That is, just type the command necessary to send files to your printer
and include an {cmd:@} sign where the filename should be substituted.  The
default setting, as shipped from the factory is

{phang2}{cmd:. printer define prn ps "lpr < @"}

{pstd}You may define multiple printers.  By default {cmd:print} uses the
printer named {hi:prn}, but {helpb print} has the option
{cmd:printer(}{it:printername}{cmd:)} and so, if you define multiple printers,
you may route your output to them.

{pstd}
Any printers that you set will be remembered even across sessions.  You
can delete printers with the {cmd:printer define} {it:printername} command
followed by nothing.  You will not want to delete the definition of the
{hi:prn} printer.

{pstd}
You can list all the defined printers by typing {cmd:printer query}, and
you can list the definition of a particular printer, say {hi:prn}, by typing
{cmd:printer query prn}.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R translateQuickstart:Quick start}

        {mansection R translateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


