{smcl}
{* *! version 1.1.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _ms_eq_info" "help _ms_eq_info"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_eq_display##syntax"}{...}
{viewerjumpto "Description" "_ms_eq_display##description"}{...}
{viewerjumpto "Options" "_ms_eq_display##options"}{...}
{viewerjumpto "Stored results" "_ms_eq_display##results"}{...}
{title:Title}

{p2colset 4 26 28 2}{...}
{p2col:{hi:[P] _ms_eq_display} {hline 2}}Display
a matrix stripe equation for coefficient tables
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_eq_display} {cmd:,}
	{opt eq:uation(#)}
	[{opt mat:rix(name)}
		{opt row}
		{opt w:idth(#)}
		{opt indent(#)}
		{opt novbar}
		{opt v0bar}
		{opt nov1bar}
		{opt nextra(#)}
		{opt wextra(#)}
		{opt astext}
		{opt aux}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_eq_display} displays a column equation in the format used by
the coefficient tables of Stata's standard estimation commands.


{marker options}{...}
{title:Options}

{phang}
{opt equation(#)} is required and specifies which equation to display.

{phang}
{opt matrix(name)} specifies that {cmd:_ms_eq_display} display the equation
by using the column stripe associated with the named matrix.  The default
matrix is {cmd:e(b)}.

{phang}
{opt row} specifies that the information come from the row stripe.  The
default is the column stripe.

{phang}
{opt width(#)} affects how the returned strings are split or abbreviated.  The
default is {cmd:width(12)}.

{phang}
{opt indent(#)} specifies that the output be indented {it:#} characters. The
default is {cmd:indent(0)}.

{phang}
{opt novbar} suppresses the vertical bar that usually follows the title.

{phang}
{opt v0bar} adds a vertical bar preceding the title.

{phang}
{opt nov1bar} suppresses the vertical bar that usually follows the split pieces
of the title when it is spread over multiple lines.

{phang}
{opt nextra(#)} and {opt wextra(#)} specify extra column information for
filling in the vertical bars when the title is spread over multiple lines.

{phang2}
{opt nextra(#)} specifies that there be {it:#} extra columns following the
title.
The default is {cmd:nextra(0)}.

{phang2}
{opt wextra(#)} specifies that the extra columns following the title have
a common width of {it:#} characters.
The default is {cmd:wextra(0)}.

{phang}
{opt astext} reports the equation using the {cmd:{c -(}text{c )-}} SMCL tag
instead of the {cmd:{c -(}result{c )-}} SMCL tag.  See {help smcl}.

{phang}
{opt aux} changes the alignment (makes it right justified) and prefixes the
equation with {cmd:/}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_eq_display} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(output)}}indicates
	whether {cmd:_ms_eq_display} produced any output{p_end}
