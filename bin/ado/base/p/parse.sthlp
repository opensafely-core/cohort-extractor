{smcl}
{* *! version 1.0.0  16apr2009}{...}
{cmd:help parse}{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:parse} continues to work but, as of Stata 5, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
For command-line parsing, see {manhelp syntax P} and {helpb args}.

{pstd}
For general macro parsing, see {manhelp tokenize P} and {manhelp gettoken P}.


{title:Title}


{p2colset 5 14 18 2}{...}
{p2col :{hi:parse} {hline 2}}Parse program arguments{p_end}


{title:Syntax}

{p 8 14 2}
{cmdab:par:se}
{cmd:"}[{it:string}]{cmd:"}
[{cmd:,}
{opt p:arse("pchars")}]


{title:Description}

{pstd}
{cmd:parse} provides both low-level parsing and full access to Stata's internal
parser.

	
{title:Options}

{phang}
{opt parse(pchars)} splits {it:string} into tokens based on the parsing
characters {it:pchars}.  If {opt parse()} is not specified, {it:string} is
parsed according to the standard Stata grammar.


{title:Syntax for local macros in high-level parsing}

{pstd}
{cmd:varlist} may contain nothing or

{p 8 14 2}
	[{opt opt:ional} | {opt req:uired} ] [{opt none}]
        [{opt ex:isting} | {opt new} ] [{opt min(#)}] [{opt max(#)}] 


{pstd}
{cmd:if}, {cmd:in}, {cmd:exp}, and {cmd:using} may contain nothing or

{p 8 14 2}
	[{opt opt:ional} | {opt req:uired}] [{opt nop:refix}]


{pstd}
{cmd:weight} may contain nothing or

{p 8 14 2}
	[{opt aw:eight}] [{opt fw:eight}] [{opt pw:eight}] [{opt iw:eight}]
        [{opt nop:refix}]

{pstd}
For instance, {cmd:local weight "fweight aweight"} allows either {cmd:fweight}
or {cmd:aweight} and makes {cmd:fweight} the default if the user is not
explicit.  In addition, if local macro {cmd:weight} is defined, local macro
{cmd:exp} must contain nothing.  

{pstd}
{cmd:options} may contain nothing or [element [element ...]], where element is

{p 8 14 2}
		[{cmdab:no:}]{it:{ul:OP}name}
		    {it:{ul:OP}name}{cmd:(}{cmdab:int:eger} {it:#}{cmd:)}
		    {it:{ul:OP}name}{cmd:(}{cmdab:rea:l} {it:#}{cmd:)}
		    {it:{ul:OP}name}{cmd:(}{cmdab:str:ing)}
		    {cmdab:*:}

{pstd}
and capitalization controls the minimum allowed abbreviation.


{title:Also see}

{psee}
 Manual:  {help prdocumented:previously documented}
{p_end}
