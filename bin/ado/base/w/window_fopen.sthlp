{smcl}
{* *! version 1.2.3  10may2018}{...}
{vieweralsosee "[P] window fopen" "mansection P windowfopen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window stopbox" "help window stopbox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window programming" "help window_programming"}{...}
{viewerjumpto "Syntax" "window_fopen##syntax"}{...}
{viewerjumpto "Description" "window_fopen##description"}{...}
{viewerjumpto "Links to PDF documentation" "window_fopen##linkspdf"}{...}
{viewerjumpto "Remarks" "window_fopen##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[P] window fopen} {hline 2}}Display open/save dialog box{p_end}
{p2col:}({mansection P windowfopen:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{opt win:dow} {{opt fo:pen}|{opt fs:ave}} {it:macroname}
 {cmd:"}{it:title}{cmd:"} {cmd:"}{it:filter}{cmd:"} [{it:extension}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:window} {cmd:fopen} and {cmd:window} {cmd:fsave} allow Stata programmers
to use standard {hi:File} > {hi:Open...} and {hi:File} > {hi:Save} dialog
boxes in their programs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P windowfopenRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:window} {cmd:fopen} and {cmd:window} {cmd:fsave} call forth the operating
system's standard {hi:File} > {hi:Open...} and {hi:File} > {hi:Save} dialog
boxes.  The commands do not themselves open or save any files; they merely
obtain from the user the name of the file to be opened or saved and return it
to you.  The filename returned is guaranteed to be valid and includes the full
path.

{pstd} 
The filename is returned in the global macro {it:macroname}.
In addition, if {it:macroname} is defined at the outset, its
contents will be used to fill in the default filename selection.

       {it:title} is displayed as the title of the dialog.

{pstd} 
{it:filter} must be specified.  One possible specification is {cmd:""},
meaning no filter.  Alternatively, {it:filter} consists of pairs of
descriptions and wildcard file selection strings separated by '{cmd:|}', such
as

       {cmd:"Stata Graphs|*.gph|All Files|*.*"}

{pstd} 
Stata uses the filter to restrict the files the user sees.  The above example
allows the user either to see Stata graph files or to see all files.  The
dialog will display a drop-down list from which the user can select a file
type (extension).  The first item of each pair ({cmd:Stata} {cmd:Graphs} and
{cmd:All} {cmd:Files}) will be listed as the choices in the drop-down list.
The second item of each pair restricts the files displayed in the dialog box
to those that match the wildcard description.  For instance, if the user
selects {cmd:Stata Graphs} from the list box, only files with extension
{cmd:.gph} will be displayed in the file dialog box.

{pstd} 
Finally, {it:extension} is optional.  It may contain a string of characters
to be added to the end of filenames by default.  For example, if the 
{it:extension} were specified as {cmd:xyz}, and the user typed a filename of
{cmd:abc} in the file dialog box, {cmd:abc.xyz} would be returned in 
{it:macroname}.

{pstd} 
In Windows, the default {it:extension} is ignored if a {it:filter} other
than {cmd:*.*} is in effect.  For example, if the user's current filter is
{cmd:*.gph}, the default extension will be {cmd:.gph}, regardless of the 
{it:extension} specified.

{pstd} 
Because Windows allows long filenames, {it:extension} can lead to unexpected
results.  For example, if {it:extension} were specified as {cmd:xyz} and the
user typed a filename of {cmd:abc.def}, Windows would append {cmd:.xyz} before
returning the filename to Stata, so the resulting filename is
{cmd:abc.def.xyz}.  Windows users should be aware that if they want to specify
an extension different from the default, they must enter a filename in the
file dialog box enclosed in double quotes:  {cmd:"abc.def"}.  This applies to
all programs, not just Stata.

{pstd} 
If the user presses the {hi:Cancel} button on the file dialog, 
{cmd:window fopen} and {cmd:window fsave} set {it:macroname} to be empty and
exit with a return code of 601.  Programmers should use the {cmd:capture}
command to prevent the 601 return code from appearing to the user.

       {hline 47} begin dtaview.ado {hline 4}
       {cmd}program dtaview
                version {ccl stata_version}
                capture window fopen D_dta "Select a dataset to use:" /*
                        */ "Stata Data (*.dta)|*.dta|All Files (*.*)|*.*" dta 
                if _rc==0 {c -(} 
                        display "User chose $D_dta as the filename."
                        use "$D_dta"
                {c )-}
       end{txt}
       {hline 47} end dtaview.ado {hline 6}
