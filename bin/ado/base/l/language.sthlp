{smcl}
{* *! version 1.1.4  11feb2011}{...}
{findalias asfrsyntax}{...}
{viewerjumpto "Syntax" "language##syntax"}{...}
{viewerjumpto "Description" "language##description"}{...}
{viewerjumpto "Remarks" "language##remarks"}{...}
{viewerjumpto "Examples" "language##examples"}{...}
{title:Title}

{p 4 13 2}
{findalias frsyntax}


{marker syntax}{...}
{title:Syntax}

{pstd}
With few exceptions, the basic language syntax is

{p 8 27 2}
[{it:prefix} {cmd::}]
{it:command} [{it:varlist}]
[{cmd:=}{it:exp}]
{ifin}
{weight}
{bind:[{cmd:using} {it:filename}]}
{bind:[{cmd:,} {it:options}]}


{p2colset 5 24 48 2}{...}
{p2col:see}language element {space 4} description{p_end}
{p2line}
{p2col:help {it:{help prefix}}}{it:prefix} {cmd::} {space 12} prefix
		command{p_end}
{p2col:help {it:command}}{it:command} {space 13} Stata command{p_end}
{p2col:help {it:{help varlist}}}{it:varlist} {space 13} variable list{p_end}
{p2col:help {it:{help exp}}}{cmd:=}{it:exp} {space 16} expression{p_end}
{p2col:help {it:{help if}}}{it:if} {space 18} {cmd:if} {it:exp}
		qualifier{p_end}
{p2col:help {it:{help in}}}{it:in} {space 18} {cmd:in} {it:range}
		qualifier{p_end}
{p2col:help {it:{help weight}}}{it:weight} {space 14} weight{p_end}
{p2col:help {it:{help using}}}{cmd:using} {it:filename} {space 6} {cmd:using}
		{it:filename} modifier{p_end}
{p2col:help {it:{help options}}}{it:options} {space 13} options{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Stata commands follow a common syntax.  A command's syntax diagram shows how
to type the command, indicates possible options, and gives the minimum allowed
abbreviations for items in the command.


{marker remarks}{...}
{title:Remarks}

{pstd}
In a syntax diagram, square brackets distinguish optional from required options.
Items presented like {cmd:this} should be typed exactly as they appear in the
diagram.  Underlining is used to indicate the shortest abbreviations where
abbreviations are allowed, so that an item presented like {cmdab:th:is}
indicates that {cmd:this} may be abbreviated to {cmd:th}.  Items presented
like {it:this} represent arguments for which you are to substitute variable
names, observation numbers, and the like.

{pstd}
Options, denoted as {it:options} in the generic syntax diagram above, are
specified at the end of the command.  A comma must precede the first
{it:option}.

{pstd}
Some options take numeric lists as arguments.  See help {help numlist} for
details on various ways of specifying these numeric lists.

{pstd}
Some commands also have an immediate form (allow you to enter numbers
directly instead of entering variable names).  See help {help immed} for
details.

{pstd}
Programmers interested in incorporating Stata's language features into
their Stata programs should see help {help syntax} for the {cmd:syntax}
command.


{marker examples}{...}
{title:Examples}

    {title:{cmd:count} command}

{pin}
The {help count} command has the following syntax diagram:

{phang3}
{cmdab:cou:nt} {ifin}

{pin}
{cmd:count} is the {it:command} and it may be abbreviated to {cmd:cou}.
The {cmd:if} and {cmd:in} qualifiers are optional; see help {it:{help if}}
and help {it:{help in}}.

{pin}
Examples:

{phang3}{cmd:. sysuse auto}{p_end}
{phang3}{cmd:. count if rep78 > 4}{p_end}
{phang3}{cmd:. count if weight < 3000}{p_end}
{phang3}{cmd:. cou if rep78 > 4 & weight < 3000}{p_end}


    {title:{cmd:replace} command}

{pin}
The {help replace} command has the following syntax diagram:

{phang3}
{cmd:replace} {it:oldvar} {cmd:=}{it:exp} {ifin}
	[{cmd:,} {opt nop:romote} ]

{pin}
{cmd:replace} is the {it:command}.  {it:oldvar} corresponds to {it:varlist} in
the generic syntax diagram.  Here {it:oldvar} is required because there
are no square brackets around it.  The equal sign followed by an expression is
also required.  The {cmd:if} and {cmd:in} qualifiers are optional.  There is
one option, {cmd:nopromote}, which may be abbreviated to {cmd:nop}.  If this
option is specified, it must follow a comma after the earlier parts of the
command have been typed.

{pin}
Examples:

{phang3}{cmd:. sysuse nlsw88}{p_end}
{phang3}{cmd:. replace married = 2 if never_married == 0 & married == 0}{p_end}
{phang3}{cmd:. replace wage = wage * 2080}{p_end}
{phang3}{cmd:. replace age = age^2, nopromote}{p_end}
