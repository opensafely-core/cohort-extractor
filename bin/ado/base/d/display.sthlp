{smcl}
{* *! version 1.1.13  22mar2018}{...}
{viewerdialog display "dialog display"}{...}
{vieweralsosee "[P] display" "mansection P display"}{...}
{vieweralsosee "[R] display" "mansection R display"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[D] list" "help list"}{...}
{vieweralsosee "[D] outfile" "help outfile"}{...}
{vieweralsosee "[P] quietly" "help quietly"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{viewerjumpto "Syntax" "display##syntax"}{...}
{viewerjumpto "Menu" "display##menu"}{...}
{viewerjumpto "Description" "display##description"}{...}
{viewerjumpto "Links to PDF documentation" "display##linkspdf"}{...}
{viewerjumpto "Remarks" "display##remarks"}{...}
{viewerjumpto "Examples" "display##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] display} {hline 2}}Display strings and values of scalar expressions{p_end}
{p2col:}({mansection P display:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmdab:di:splay} [{it:display_directive} [{it:display_directive} [{it:...}]]]

{pstd}where {it:display_directive} is

	{cmd:"}{it:double-quoted string}{cmd:"}
{p 8 16 2}{cmd:`"}{it:compound double-quoted string}{cmd:"'}{p_end}
	[{help format:{bf:%}{it:fmt}}] [{cmd:=}]{it:{help exp}}
{p 8 16 2}{cmd:as} {c -(} {cmd:text} | {cmd:txt} | {cmdab:res:ult}
			| {cmdab:err:or} | {cmdab:inp:ut} {c )-}{p_end}
	{cmd:in smcl}
	{cmd:_asis}
	{cmdab:_s:kip:(}{it:#}{cmd:)}
	{cmdab:_col:umn:(}{it:#}{cmd:)}
	{cmdab:_n:ewline}[{cmd:(}{it:#}{cmd:)}]
	{cmdab:_c:ontinue}
	{cmdab:_d:up:(}{it:#}{cmd:)}
	{cmdab:_r:equest:(}{it:macname}{cmd:)}
	{cmd:_char(}{it:#}{cmd:)}
	{cmd:,}
	{cmd:,,}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Other utilities > Hand calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:display} displays strings and values of scalar expressions.
{cmd:display} produces output from the programs that you write.

{pstd}
Interactively, {cmd:display} can be used as a substitute for a hand
calculator; see {manlink R display}.  You can type things such
as {cmd:display 2+2}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P displayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:display}'s {it:display_directive}s are used in do-files and programs
to produce formatted output.  The directives are

{synoptset 32}
{synopt:{cmd:"}{it:double-quoted string}{cmd:"}}displays the string without
              the quotes{p_end}

{synopt:{cmd:`"}{it:compound double-quoted string}{cmd:"'}}display the string
              without the outer quotes; allows embedded quotes{p_end}

{synopt:[{cmd:%}{it:fmt}] [{cmd:=}] {cmd:exp}}allows results to be formatted;
         see {bf:{mansection U 12.5FormatsControllinghowdataaredisplayed:[U] 12.5 Formats: Controlling how data are displayed}}{p_end}

{synopt:{cmd:as} {it:style}}sets the style ("color") for the directives that
         follow; there may be more than one {cmd:as} {it:style} per
         {cmd:display}{p_end}

{synopt:{cmd:in smcl}}switches from {cmd:_asis} model to {cmd:smcl} mode{p_end}

{synopt:{cmd:_asis}}switches from {cmd:smcl} model to {cmd:_asis} mode{p_end}

{synopt:{cmd:_skip(}{it:#}{cmd:)}}skips {it:#} columns{p_end}

{synopt:{cmd:_column(}{it:#}{cmd:)}}skips to the {it:#}th column{p_end}

{synopt:{cmd:_newline}}goes to a new line{p_end}

{synopt:{cmd:_newline(}{it:#}{cmd:)}}skips {it:#} lines{p_end}

{synopt:{cmd:_continue}}suppresses automatic newline at end of {cmd:display}
         command{p_end}

{synopt:{cmd:_dup(}{it:#}{cmd:)}}repeats the next directive {it:#} times{p_end}

{synopt:{cmd:_request(}{it:macname}{cmd:)}}accepts input from the console and
         places it into the macro {it:macname}{p_end}

{synopt:{cmd:_char(}{it:#}{cmd:)}}displays the character for ASCII and extended 
	ASCII code {it:#}, where {it:#} > 127 is 
	treated as a Latin1-encoded character and will be converted to the 
	corresponding UTF-8 character{p_end}

{synopt:{cmd:,}}displays one blank between two directives{p_end}

{synopt:{cmd:,,}}places no blanks between two directives{p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}As a hand calculator:

{phang2}{cmd:. display 2 + 2}

{pstd}As might be used in do-files and programs:

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}
{phang2}{cmd:. display as text "mean of mpg = " as result r(mean)}{p_end}
