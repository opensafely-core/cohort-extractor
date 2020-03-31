{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] while" "mansection P while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] forvalues" "help forvalues"}{...}
{vieweralsosee "[P] if" "help ifcmd"}{...}
{viewerjumpto "Syntax" "while##syntax"}{...}
{viewerjumpto "Description" "while##description"}{...}
{viewerjumpto "Links to PDF documentation" "while##linkspdf"}{...}
{viewerjumpto "Examples" "while##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] while} {hline 2}}Looping{p_end}
{p2col:}({mansection P while:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:while} {it:exp} {cmd:{c -(}}
		{it:stata_commands}
	{cmd:{c )-}}

{pstd}
Braces must be specified with {cmd:while}, and

{phang2}
1.  the open brace must appear on the same line as {cmd:while};

{phang2}
2.  nothing may follow the open brace, except, of course, comments;
    the first command to be executed must appear on a new line;

{phang2}
3.  the close brace must appear on a line by itself.


{marker description}{...}
{title:Description}

{pstd}
{cmd:while} evaluates {it:exp} and, if it is true (nonzero), executes the
{it:stata_commands} enclosed in the braces. It then repeats the process until
{it:exp} evaluates to false (zero).  {cmd:while}s may be nested within
{cmd:while}s.  If the {it:exp} refers to any variables, their values in the
first observation are used unless explicit subscripts are specified; see
{findalias frsubscripts}.

{pstd}
Also see {manhelp foreach P} and {manhelp forvalues P} for alternatives to 
{cmd:while}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P whileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Example 1}

	{cmd:program} {it:...}
		{it:...}
		{cmd:gettoken tok 0 : 0}
		{cmd:while "`tok'" != "" {c -(}}
			{it:...}
			{cmd:gettoken tok 0 : 0}
		{cmd:{c )-}}
		{it:...}
	{cmd:end}


{title:Example 2}

{pstd}
{cmd:while} may be used interactively.  Here we use it to generate
several uniform random variables.

	{cmd:. set obs 10}
	{cmd:. local i = 1}
	{cmd:. while `i' < 40 {c -(}}
	  {cmd:2. gen u`i' = runiform()}
	  {cmd:3. local i = `i' + 1}
	  {cmd:4. {c )-}}
	{cmd:. list u1 - u7}
