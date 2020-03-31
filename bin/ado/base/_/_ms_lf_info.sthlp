{smcl}
{* *! version 1.0.0  07apr2016}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_lf_info##syntax"}{...}
{viewerjumpto "Description" "_ms_lf_info##description"}{...}
{viewerjumpto "Options" "_ms_lf_info##options"}{...}
{viewerjumpto "Stored results" "_ms_lf_info##results"}{...}
{title:Title}

{pstd}
{hi:[P] _ms_lf_info} {hline 2} Matrix stripe linear form information


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_lf_info} [{cmd:,} {opt mat:rix(name)} {opt row}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_lf_info} returns information about the linear forms in the
column stripe on {cmd:e(b)}.


{marker options}{...}
{title:Options}

{phang}
{opt matrix(name)} specifies that {cmd:_ms_lf_info} report information from the
column stripe associated with the named matrix.  The default matrix is
{cmd:e(b)}.

{phang}
{opt row} specifies that the information come from the row stripe.  The
default is the column stripe.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_lf_info} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 22 26 2}{...}
{p2col: {cmd:r(k_lf)}}number of linear forms{p_end}
{p2col: {cmd:r(k}{it:#}{cmd:)}}number
	of elements in the {it:#}th linear form{p_end}
{p2col: {cmd:r(freeparm}{it:#}{cmd:)}}indicator
	of free parameter for the {it:#}th linear form{p_end}
{p2col: {cmd:r(cons}{it:#}{cmd:)}}indicates
	presence of {cmd:_cons} in the {it:#}th linear form{p_end}

{pstd}Macros{p_end}
{p2col: {cmd:r(lf}{it:#}{cmd:)}}identifier for the {it:#}th linear form{p_end}
{p2col: {cmd:r(varlist}{it:#}{cmd:)}}variables participating in the {it:#}th linear form{p_end}
{p2col: {cmd:r(varlist)}}all variables participating in linear forms{p_end}
