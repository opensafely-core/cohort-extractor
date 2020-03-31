{smcl}
{* *! version 1.0.4  14may2018}{...}
{vieweralsosee "[P] exit" "mansection P exit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[P] class exit" "help class_exit"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] error" "help error"}{...}
{vieweralsosee "[R] Error messages" "help error messages"}{...}
{vieweralsosee "[R] exit" "help exit"}{...}
{viewerjumpto "Syntax" "exit_program##syntax"}{...}
{viewerjumpto "Description" "exit_program##description"}{...}
{viewerjumpto "Links to PDF documentation" "exit_program##linkspdf"}{...}
{viewerjumpto "Options" "exit_program##options"}{...}
{viewerjumpto "Remarks" "exit_program##remarks"}{...}
{viewerjumpto "Examples" "exit_program##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] exit} {hline 2}}Exit from a program or do-file{p_end}
{p2col:}({mansection P exit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmdab:e:xit} [[{cmd:=}]{it:{help exp}}] [{cmd:,} {it:options}]

{synoptset 9}{...}
{synopthdr}
{synoptline}
{synopt :{opt clear}}exit Stata, even if the current dataset has not been saved{p_end}
{synopt :{opt STATA}}exit Stata and return control to operating system{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:exit}, when typed from the keyboard, causes Stata to terminate
processing and returns control to the operating system.  If the dataset in
memory has changed since the last {cmd:save} command, you must specify the
{cmd:clear} option before Stata will let you leave.  Use of the command in this
way is discussed in {helpb exit:[R] exit}.

{pstd}
More generally, {cmd:exit} causes Stata to terminate the current process and
returns control to the calling process.  The return code is set to the value of
the expression or to zero if no expression is specified.  Thus {cmd:exit} can
be used to exit a program or do-file and return control to Stata.  With an
option, {cmd:exit} can even be used to exit Stata from a program or do-file.
Such use of {cmd:exit} is the subject of this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P exitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt clear} permits you to exit, even if the current dataset has not
been saved.

{phang}{opt STATA} exits Stata and returns control to the operating system,
even when given from a do-file or program.  The {opt STATA} option is implied
when {cmd:exit} is issued from the keyboard.


{marker remarks}{...}
{title:Remarks}

{pstd}
Caution should be used if {cmd:exit} is included to break execution within a
loop. A more suitable command is {helpb continue} or
{helpb continue:continue, break}. 
{cmd:continue} is used to explicitly break execution of the current loop
iteration with execution resuming at the top of the loop unless the
{cmd:break} option is specified, in which case execution resumes with the
command following the looping command.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Here is a useless program that will tell you whether a variable exists:

        {cmd}. program check
          1. capture confirm variable `1'
          2. if _rc!=0 {
          3.    display "`1' not found"
          4.    exit
          5. }
          6. display "The variable `1' exists."
          7. end{txt}

        {cmd:. check median_age}
        The variable median_age exists.

        {cmd:. check age}
        age not found

{pstd}
{cmd:exit} did not close Stata and cause a return to the operating system; it
instead terminated the program.

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. drop if rep78==.}{p_end}

{pstd}Exit Stata even though dataset has changed and has not been saved{p_end}
{phang2}{cmd:. exit, clear}{p_end}
    {hline}
