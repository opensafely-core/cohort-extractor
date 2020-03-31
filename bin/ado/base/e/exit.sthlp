{smcl}
{* *! version 1.2.5  25sep2018}{...}
{vieweralsosee "[R] exit" "mansection R exit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] exit" "help exit_program"}{...}
{viewerjumpto "Syntax" "exit##syntax"}{...}
{viewerjumpto "Description" "exit##description"}{...}
{viewerjumpto "Links to PDF documentation" "exit##linkspdf"}{...}
{viewerjumpto "Option" "exit##option"}{...}
{viewerjumpto "Examples" "exit##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] exit} {hline 2}}Exit Stata{p_end}
{p2col:}({mansection R exit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmdab:e:xit} [{cmd:,} {cmd:clear}]


{marker description}{...}
{title:Description}

{pstd}
Typing {cmd:exit} causes Stata to stop processing and return control to the
operating system.  If the dataset in memory has changed since the last
{cmd:save} command, you must specify the {opt clear} option before Stata will
let you exit.

{pstd}
If you wish to use {cmd:exit} in do-files or programs to set return codes
or terminate programs, see {helpb exit_program:[P] exit}.

{pstd}
Stata for Windows users may also exit Stata by clicking on the {bf:Close}
button or by pressing {bf:Alt}+{bf:F4}.

{pstd}
Stata for Mac users may also exit Stata by pressing {bf:Command}+{bf:Q}.

{pstd}Stata for Unix(GUI) users may also exit Stata by clicking on the
{bf:Close} button.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R exitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}{opt clear} permits you to exit, even if the current dataset has not
been saved.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price mpg rep78 foreign}{p_end}

    Exit Stata
{phang2}{cmd:. exit}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. drop if rep78==.}{p_end}

{pstd}Exit Stata even though dataset has changed and has not been saved{p_end}
{phang2}{cmd:. exit, clear}{p_end}
    {hline}
