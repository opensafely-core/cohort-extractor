{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[P] pause" "mansection P pause"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] more" "help more"}{...}
{vieweralsosee "[P] trace" "help trace"}{...}
{viewerjumpto "Syntax" "pause##syntax"}{...}
{viewerjumpto "Description" "pause##description"}{...}
{viewerjumpto "Links to PDF documentation" "pause##linkspdf"}{...}
{viewerjumpto "Remarks" "pause##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] pause} {hline 2}}Program debugging command{p_end}
{p2col:}({mansection P pause:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:pause} {c -(} {cmd:on} | {cmd:off} | [{it:message}] {c )-}


{marker description}{...}
{title:Description}

{pstd}If pause is on, {cmd:pause} [{it:message}] command displays
{it:message} and temporarily suspends execution of the program, returning
control to the keyboard.  Execution of keyboard commands continues until you
type {cmd:end} or {cmd:q}, at which time execution of the program resumes.
Typing {cmd:BREAK} in pause mode (as opposed to pressing the {hi:Break} key)
also resumes program execution, but the break signal is sent to the
calling program.

{pstd}If pause is off, {cmd:pause} does nothing.

{pstd}Pause is off by default.  Type {cmd:pause on} to turn pause on.  Type
{cmd:pause off} to turn it back off.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P pauseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:pause} assists in debugging Stata programs.  The line {cmd:pause} or
{cmd:pause} {it:message} is placed in the program where problems are
suspected (more than one {cmd:pause} may be placed in a program).  For instance,
you have a program that is not working properly.  A piece of this program reads

        {cmd:gen `tmp'=exp(`1')/`2'}
        {cmd:summarize `tmp'}
        {cmd:local mean=r(mean)}

{pstd}
You think that the error may be in the creation of {cmd:`tmp'}.  You
change the program to read

        {cmd:gen `tmp'=exp(`1')/`2'}
        {cmd:pause Just created tmp}        /* this line is new */
        {cmd:summarize `tmp'}
        {cmd:local mean=r(mean)}
