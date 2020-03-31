{smcl}
{* *! version 1.2.0  19feb2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _ms_element_info" "help _ms_element_info"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_display##syntax"}{...}
{viewerjumpto "Description" "_ms_display##description"}{...}
{viewerjumpto "Options" "_ms_display##options"}{...}
{viewerjumpto "Stored results" "_ms_display##results"}{...}
{title:Title}

{p2colset 4 20 23 2}{...}
{p2col:{hi:[P] _ms_display}}{hline 2} Display
a matrix stripe element for coefficient tables
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_display}{cmd:,}
	{opt el:ement(#)}
	[{opt mat:rix(name)}
		{opt row}
		{opt eq:uation(eqid)}
		{opt w:idth(#)}
		{opt noabbrev}
		{opt indent(#)}
		{opt fir:st}
		{opt nocons:tant}
		{opt noname}
		{opt novbar}
		{opt v0bar}
		{opt nov1bar}
		{opt nolev:el}
		{opt nextra(#)}
		{opt wextra(#)}
		{it:{help _ms_display##display_options:display_options}}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_display} displays column stripe information in the format used by the
coefficient tables of Stata's standard estimation commands.  It also returns
information about the specified element in the column stripe on {cmd:e(b)}.


{marker options}{...}
{title:Options}

{phang}
{opt element(#)} specifies that the information come from the {it:#}th element
in the first equation. {opt element()} is required.

{phang}
{opt matrix(name)} specifies that the information come from the
column stripe associated with the named matrix.  The default matrix is
{cmd:e(b)}.

{phang}
{opt row} specifies that the information come from the row stripe.  The
default is the column stripe.

{phang}
{opt equation(eqid)} specifies that {opt element(#)} refer to the {it:#}th
element within the identified equation.  The default is the first equation.

{phang}
{opt width(#)} affects how the returned strings are split or abbreviated.  The
default is {cmd:width(12)}.

{phang}
{opt noabbrev} prevents long name elements from being abbreviated when
they do not fit within the specified {opt width(#)}.
Instead of abbreviating long names, {cmd:_ms_display} will split the
long names onto multiple lines.

{phang}
{opt indent(#)} specifies that the output be indented {it:#} characters. The
default is {cmd:indent(0)}.

{phang}
{opt first} indicates that this element should be considered the first of its
group.
The variable name is displayed for standard variables with time-series
operators or simple factor variables.  The interaction variables are displayed
for interactions.  This heading information is displayed in addition to the
usual time-series operators and factor levels.  This option has no effect for
standard variables (without time-series operators).

{phang}
{opt noconstant} indicates that {cmd:_cons} elements not be displayed.

{phang}
{opt noname} suppresses the term name from being displayed.

{phang}
{opt novbar} suppresses the vertical bar that usually follows the title.

{phang}
{opt v0bar} adds a vertical bar preceding the title.

{phang}
{opt nov1bar} suppresses the vertical bar that usually follows the split pieces
of the title when it is spread over multiple lines.

{phang}
{opt nolevel} suppresses outputting the level information for factor variables
and interactions containing factor variables.

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

{marker display_options}{...}
{phang}
{it:display_options}: 
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_display} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(output)}}indicates
	whether {cmd:_ms_display} produced any output{p_end}
{p2col: {cmd:r(k)}}number of level values in {cmd:r(level)}{p_end}
{p2col: {cmd:r(k_term)}}number
	of macros that split or abbreviate {cmd:r(term)}{p_end}
{p2col: {cmd:r(k_operator)}}number
	of macros that split {cmd:r(operator)}{p_end}
{p2col: {cmd:r(k_level)}}number
	of macros that split {cmd:r(level)}{p_end}

{pstd}Macros{p_end}
{p2col: {cmd:r(type)}}element type:  {cmd:variable}, {cmd:factor}, or
            {cmd:interaction}{p_end}
{p2col: {cmd:r(term)}}term associated with the element{p_end}
{p2col: {cmd:r(term}{it:#}{cmd:)}}{it:#}th split or abbreviated piece of
          {cmd:r(term)}{p_end}
{p2col: {cmd:r(operator)}}time-series operator if specified element is
        a time-series-operated standard variable{p_end}
{p2col: {cmd:r(operator}{it:#}{cmd:)}}{it:#}th split piece of {cmd:r(operator)}
{p_end}
{p2col: {cmd:r(level)}}factor levels that identify the element within the term
{p_end}
{p2col: {cmd:r(level}{it:#}{cmd:)}}{it:#}th split piece of {cmd:r(level)}{p_end}
{p2col: {cmd:r(note)}}"", {cmd:(base)}, {cmd:(empty)}, or {cmd:(omitted)}{p_end}
