{smcl}
{* *! version 1.2.4  29jan2019}{...}
{vieweralsosee "[P] window push" "mansection P windowpush"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] #review" "help review"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window programming" "help window_programming"}{...}
{viewerjumpto "Syntax" "window_push##syntax"}{...}
{viewerjumpto "Description" "window_push##description"}{...}
{viewerjumpto "Links to PDF documentation" "window_push##linkspdf"}{...}
{viewerjumpto "Remarks" "window_push##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[P] window push} {hline 2}}Copy command into History window{p_end}
{p2col:}({mansection P windowpush:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{opt win:dow} {opt push} {it:command-line}


{marker description}{...}
{title:Description}

{pstd}
{cmd:window} {cmd:push} copies the specified {it:command-line} onto the
end of the command history.  {it:command-line} will appear as the most
recent command in the {cmd:#review} list and will appear as the last command
in the History window.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P windowpushRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:window} {cmd:push} is useful when one Stata command creates another Stata
command and executes it.  Normally, commands inside ado-files are not added to
the command history, but an ado-file such as a dialog interface to a Stata
command might exist solely to create and execute another Stata command.

{pstd}
{cmd:window} {cmd:push} allows the interface to add the created command to the
command history (and therefore to the History window) after executing the
command.

     {hline 50} begin example.do {hline 4}
     {cmd}program example
         version {ccl stata_version}
         display "This display command is not added to the command history"
         display "This display command is added to the command history"
         window push display "This display command is added to the command /*
             */ history"
     end{txt}
     {hline 50} end example.do {hline 6}

     {cmd}. example
     This display command is not added to the command history
     This display command is added to the command history

     . #review
     3
     2 example
     1 display "This display command is added to the command history"

     .{txt}
