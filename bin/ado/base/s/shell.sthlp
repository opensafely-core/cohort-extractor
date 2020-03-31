{smcl}
{* *! version 1.2.10  15oct2018}{...}
{vieweralsosee "[D] shell" "mansection D shell"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "shell##syntax"}{...}
{viewerjumpto "Description" "shell##description"}{...}
{viewerjumpto "Links to PDF documentation" "shell##linkspdf"}{...}
{viewerjumpto "Remarks" "shell##remarks"}{...}
{viewerjumpto "Examples" "shell##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] shell} {hline 2}}Temporarily invoke operating system{p_end}
{p2col:}({mansection D shell:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}{c -(}{opt sh:ell}|{cmd:!}{c )-} [{it:operating_system_command}]

{p 8 12 2}{opt winexec} {it:program_name} [{it:program_args}]

{p 8 12 2}
{c -(}{opt xsh:ell}|{cmd:!}{cmd:!}{c )-} [{it:operating_system_command}]


{pstd}Command availability:

                 Stata for ...
        Command    Windows    Mac          Unix(GUI)    Unix(console)
        {hline 61}
        {cmd:shell}         X         X            X            X
        {cmd:winexec}       X         X            X            -
        {cmd:xshell}        -         X            X            - 
        {hline 61}


{marker description}{...}
{title:Description}

{pstd}
{opt shell} (synonym:  "{cmd:!}") allows you to send commands to your
operating system or to enter your operating system for interactive use. 
Stata will wait for the shell to close or the {it:operating_system_command}
to complete before continuing.

{pstd}
{opt winexec} allows you to start other programs (such as browsers) from
Stata's command line.  Stata will continue without waiting for the program to
complete.

{pstd}
{opt xshell} (Stata for Mac and Unix(GUI) only) brings up an {opt xterm} in
which the command is to be executed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D shellRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks for Mac users}

{pstd}
On macOS, {opt xterm} is available when {it:X11} is installed.  To
install {it:X11}, you must first download XQuartz from
{browse "https://xquartz.macosforge.org/"}.


{marker examples}{...}
{title:Examples}

{p2colset 5 39 41 2}{...}
{p2col :{cmd:. shell}}(enter operating system){p_end}

{p2col :{cmd:. shell erase *.log}}(Windows){p_end}
{p2col :{cmd:. shell rm *.log}}(Unix and Mac){p_end}

{p2col :{cmd:. shell edit myfile.ado}}(assuming editor called {opt edit}){p_end}

{p2col :{cmd:. !}}
{p2colreset}{...}

{phang}{cmd:. !edit myfile.ado}

{phang}{cmd:. winexec notepad}

{phang}{cmd:. winexec notepad c:\dta\myfile.do}

{phang}{cmd:. winexec c:\windows\notepad}

{phang}{cmd:. winexec c:\windows\notepad c:\dta\myfile.do}{p_end}
