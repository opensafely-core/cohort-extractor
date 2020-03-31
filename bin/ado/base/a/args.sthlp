{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] syntax" "mansection P syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[P] unab" "help unab"}{...}
{viewerjumpto "Syntax" "args##syntax"}{...}
{viewerjumpto "Description" "args##description"}{...}
{viewerjumpto "Links to PDF documentation" "args##linkspdf"}{...}
{viewerjumpto "Examples" "args##examples"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{cmd:args} (in {bf:[P] syntax}) {hline 2}}Parse Stata syntax positionally
{p_end}
{p2col:}({mansection P syntax:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:args} {it:macroname1} [{it:macroname2} [{it:macroname3 {it:...}}]]


{marker description}{...}
{title:Description}

{pstd}
{cmd:args} obtains command line arguments.  It works on positional
arguments -- the first, second, ... item entered on a command line.  The
{helpb syntax} command is a more comprehensive command that also obtains
command line arguments but does so according to Stata's language grammar.  For
an introduction to Stata's language, see {help language}.

{pstd}
{cmd:args} assigns the first command line argument to the local macro
{it:macroname1}, the second argument to {it:macroname2}, and so on.  In the
program, you subsequently refer to the contents of the macros by enclosing
their names in single quotes:  {cmd:`}{it:macroname1}{cmd:'},
{cmd:`}{it:macroname2}{cmd:'}, etc.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P syntaxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

	{cmd:program myprog}
		{cmd:version {ccl stata_version}}
		{cmd:args varname dof beta}
		{it:...}
{p 16 18 2}{txt:(program uses macros {hi:`varname'}, {hi:`dof'}, and {hi:`beta'})}{p_end}
		{it:...}
	{cmd:end}

	{cmd:. myprog mpg 32 8.2}

{pstd}
In this case {hi:`varname'} is set to {hi:mpg}, {hi:`dof'} is set to 32,
{hi:`beta'} is set to 8.2.
{p_end}
