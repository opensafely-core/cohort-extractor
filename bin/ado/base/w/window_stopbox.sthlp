{smcl}
{* *! version 1.0.7  19oct2017}{...}
{vieweralsosee "[P] window stopbox" "mansection P windowstopbox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[P] window programming" "help window_programming"}{...}
{viewerjumpto "Syntax" "window_stopbox##syntax"}{...}
{viewerjumpto "Description" "window_stopbox##description"}{...}
{viewerjumpto "Links to PDF documentation" "window_stopbox##linkspdf"}{...}
{viewerjumpto "Remarks" "window_stopbox##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[P] window stopbox} {hline 2}}Display message box{p_end}
{p2col:}({mansection P windowstopbox:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmd:window} {opt stop:box}
{{opt stop}|{opt note}|{opt rusure}}
[{cmd:"}{it:line 1}{cmd:"}
[{cmd:"}{it:line 2}{cmd:"}
[{cmd:"}{it:line 3}{cmd:"}
[{cmd:"}{it:line 4}{cmd:"}]]]]


{marker description}{...}
{title:Description} 

{pstd}
{cmd:window} {cmd:stopbox} allows Stata programs to display message boxes.  Up
to four lines of text may be displayed on a message box.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P windowstopboxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
There are three types of message boxes available to Stata programmers.
The first is the {cmd:stop} message box.  {cmd:window stopbox stop}
displays a message box intended for error messages.  This type of
message box always exits with a return code of 1.

{p 8 17 2}{cmd:. window stopbox stop "You must type a variable name."  "Please try again."}

       ({cmd:stop} message box is displayed)

       {cmd}--Break--
       r(1);{txt}

{pstd}
The second message box is the {cmd:note} box.  {cmd:window} {cmd:stopbox}
{cmd:note} displays a message box intended for information messages or notes.
This type of message box always exits with a return code of 0.

{p 8 17 2}{cmd:. window stopbox note "You answered 3 of 4 questions correctly."  "Press OK to continue."}

       ({cmd:note} message box is displayed)

{pstd}
The only way to close the first two types of message boxes is to click the
{hi:OK} button displayed at the bottom of the box.

{pstd}
The third message box is the {cmd:rusure} (say, "Are you sure?") box.
This message box lets a Stata program ask the user a question.
The user can close the box by clicking either {hi:Yes} or {hi:No}.
The message box exits with a return code of 0 if the user clicks {hi:Yes},
or exits with a return code of 1 if the user clicks {hi:No}.

{pstd}
A Stata program should use the {cmd:capture} command to determine whether
the user clicked {hi:Yes} or {hi:No}.
       
{p 8 25 2}{cmd:. capture window stopbox rusure "Do you want to clear the current dataset from memory?"}{p_end}

       ({cmd:rusure} message box is displayed)

       {cmd:. if _rc == 0 clear}
