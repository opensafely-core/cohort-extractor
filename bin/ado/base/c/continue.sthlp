{smcl}
{* *! version 1.1.9  19oct2017}{...}
{vieweralsosee "[P] continue" "mansection P continue"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] forvalues" "help forvalues"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] exit" "help exit_program"}{...}
{vieweralsosee "[P] if" "help ifcmd"}{...}
{viewerjumpto "Syntax" "continue##syntax"}{...}
{viewerjumpto "Description" "continue##description"}{...}
{viewerjumpto "Links to PDF documentation" "continue##linkspdf"}{...}
{viewerjumpto "Option" "continue##option"}{...}
{viewerjumpto "Examples" "continue##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] continue} {hline 2}}Break out of loops{p_end}
{p2col:}({mansection P continue:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:continue} [{cmd:,} {cmdab:br:eak}]


{marker description}{...}
{title:Description}

{pstd}
The {cmd:continue} command within a {cmd:foreach}, {cmd:forvalues}, or
{cmd:while} loop breaks execution of the current loop iteration and skips
the remaining commands within the loop.  Execution resumes at the top of the
loop unless the {cmd:break} option is specified, in which case
execution resumes with the command following the looping command.  See
{manhelp foreach P}, {manhelp forvalues P}, and {manhelp while P} for a
discussion of the looping commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P continueRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:break} indicates that the loop is to be exited.  The default
is to skip the remaining steps of the current iteration and to resume loop
execution again at the top of the loop.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
List the odd and even numbers from one to four

	{cmd:. forvalues x = 1/4} {cmd:{c -(}}
	{cmd:  2.    if mod(`x',2)} {cmd:{c -(}}
	{cmd:  3.        display "`x' is odd"}
	{cmd:  4.    {c )-}}
	{cmd:  5.    else} {cmd:{c -(}}
	{cmd:  6.        display "`x' is even"}
	{cmd:  7.    {c )-}}
	{cmd:  8. {c )-}}
	{cmd:1 is odd}
 	{cmd:2 is even}
	{cmd:3 is odd}
	{cmd:4 is even}

{pstd}
The above program could be coded using {cmd:continue} instead of {cmd:else}

	{cmd:. forvalues x = 1(1)4} {cmd:{c -(}}
	{cmd:  2.    if mod(`x',2)} {cmd:{c -(}}
	{cmd:  3.        display "`x' is odd"}
	{cmd:  4.        continue}
	{cmd:  5.    {c )-}}
	{cmd:  6.    display "`x' is even"}
	{cmd:  7. {c )-}}
	{cmd:1 is odd}
 	{cmd:2 is even}
	{cmd:3 is odd}
	{cmd:4 is even}

{pstd}
When {cmd:continue} is executed, any remaining statements that exist in the
loop are ignored.  Execution continues at the top of the loop where, here,
{cmd:forvalues} sets the next value of {cmd:`x'}, compares that with 4, and
then perhaps begins the loop again.

    {hline}
{pstd}Use the {cmd:break} option to prematurely exit the loop

	{cmd:. forvalues x = 6/1000} {cmd:{c -(}}
	{cmd:  2.    if mod(`x',2)==0 & mod(`x',3)==0 & mod(`x',5)==0} {cmd:{c -(}}
	{cmd:  3.        display "The least common multiple of 2, 3, and 5 is `x'"}
	{cmd:  4.        continue, break}
	{cmd:  5.    {c )-}}
	{cmd:  6. {c )-}}
	{cmd:The least common multiple of 2, 3, and 5 is 30}

{pstd}Although the {cmd:forvalues} loop was scheduled to go over the values
6-1,000, the {cmd:continue,} {cmd:break} statement forced it to stop after 30.
{p_end}

    {hline}
