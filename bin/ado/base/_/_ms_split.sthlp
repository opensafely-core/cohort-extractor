{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_ms_utils()" "help mf_st_ms_utils"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_split##syntax"}{...}
{viewerjumpto "Description" "_ms_split##description"}{...}
{viewerjumpto "Options" "_ms_split##options"}{...}
{viewerjumpto "Stored results" "_ms_split##results"}{...}
{title:Title}

{pstd}
{hi:[P] _ms_split} {hline 2} Matrix stripe splitting tools


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_split} {it:matrix_name} [{cmd:,}
		{opt row}
		{opt abbrev}
		{opt width(#)}
		{opt nocol:on}
	]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_split} returns in {cmd:r()} a macro representation of the string
matrix returned by Mata functions
{helpb mf_st_ms_utils:st_matrixrowstripe_split()}
and 
{helpb mf_st_ms_utils:st_matrixcolstripe_split()}.


{marker options}{...}
{title:Options}

{phang}
{opt row} specifies that {cmd:_ms_split} work with {it:matrix_name}'s row
stripe.

{phang}
{opt abbrev} specifies that slightly different rules be applied for splitting.
The maximum string width will be the sum of 20 plus {it:#} from {opt width(#)}.

{phang}
{opt width(#)} specifies the maximum number of characters allowed in each
macro.  The default is {cmd:width(12)}.

{phang}
{opt nocolon} indicates that a colon not be appended onto equation names.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_split} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(k_rows)}}number
	of rows in the macro-represented string matrix{p_end}
{p2col: {cmd:r(k_cols)}}number
	of columns in the macro-represented string matrix{p_end}

{pstd}Macros{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(str}{it:i}_{it:j}{cmd:)}}string
	matrix element from row {it:i}, column {it:j}{p_end}
