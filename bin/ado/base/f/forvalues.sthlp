{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] forvalues" "mansection P forvalues"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] if" "help ifcmd"}{...}
{viewerjumpto "Syntax" "forvalues##syntax"}{...}
{viewerjumpto "Description" "forvalues##description"}{...}
{viewerjumpto "Links to PDF documentation" "forvalues##linkspdf"}{...}
{viewerjumpto "Examples" "forvalues##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[P] forvalues} {hline 2}}Loop over consecutive values{p_end}
{p2col:}({mansection P forvalues:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmdab:forv:alues} {it:lname} {cmd:=} {it:range} {cmd:{c -(}}
		{it:Stata commands referring to} {cmd:`}{it:lname}{cmd:'}
	{cmd:{c )-}}

    where {it:range} is

{center:{it:#1}{cmd:(}{it:#d}{cmd:)}{it:#2} {space 4} meaning {it:#1} to {it:#2} in steps of {it:#d}     }
{center:{it:#1}{cmd:/}{it:#2} {space 7} meaning {it:#1} to {it:#2} in steps of 1      }
{center:{it:#1} {it:#t} {cmd:to} {it:#2} {space 1} meaning {it:#1} to {it:#2} in steps of {it:#t} - {it:#1}}
{center:{it:#1} {it:#t} {cmd::}{space 2}{it:#2} {space 1} meaning {it:#1} to {it:#2} in steps of {it:#t} - {it:#1}}

{pstd}
The loop is executed as long as calculated values of {cmd:`}{it:lname}{cmd:'}
are {ul:<} {it:#2}, assuming that {it:#d} > 0.

{pstd}
Braces must be specified with {cmd:forvalues}, and

{phang2}
1.  the open brace must appear on the same line as {cmd:forvalues};

{phang2}
2.  nothing may follow the open brace except, of course, comments;
    the first command to be executed must appear on a new line;

{phang2}
3.  the close brace must appear on a line by itself.


{marker description}{...}
{title:Description}

{pstd}
{cmd:forvalues} repeatedly sets local macro {it:lname} to each element of
{it:range} and executes the commands enclosed in braces.  The loop is executed
zero or more times.

{pstd}
{cmd:forvalues} is the fastest way to execute a block of code for different
numeric values of {it:lname}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P forvaluesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Generate 100 uniform random variables named x1, x2, ..., x100.

	{cmd:. forvalues i = 1(1)100 {c -(}}
	  {cmd:2.       generate x`i' = runiform()}
	  {cmd:3. {c )-}}

{pstd}
For variables var5, var6, ..., var13 output the number of observations greater
than 10.

	{cmd:. forval num = 5/13 {c -(}}
	  {cmd:2.       count if var`num' > 10}
	  {cmd:3. {c )-}}

{pstd}
Produce individual summarize commands for variables x5, x10, ..., x300.

	{cmd:. forvalues k = 5 10 to 300 {c -(}}
	  {cmd:2.       summarize x`k'}
	  {cmd:3. {c )-}}

{pstd}
A loop over noninteger values that includes more than one command.

	{cmd:. forval x = 31.3 31.6 : 38 {c -(}}
	  {cmd:2.       count if var1 < `x' & var2 < `x'}
	  {cmd:3.       summarize myvar if var1 < `x'}
	  {cmd:4. {c )-}}
