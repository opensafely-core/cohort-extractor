{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_eq_info##syntax"}{...}
{viewerjumpto "Description" "_ms_eq_info##description"}{...}
{viewerjumpto "Options" "_ms_eq_info##options"}{...}
{viewerjumpto "Stored results" "_ms_eq_info##results"}{...}
{title:Title}

{pstd}
{hi:[P] _ms_eq_info} {hline 2} Matrix stripe equation information


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_eq_info} [{cmd:,} {opt mat:rix(name)} {opt row}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_eq_info} returns information about the equations in the column stripe
on {cmd:e(b)}.


{marker options}{...}
{title:Options}

{phang}
{opt matrix(name)} specifies that {cmd:_ms_eq_info} report information from the
column stripe associated with the named matrix.  The default matrix is
{cmd:e(b)}.

{phang}
{opt row} specifies that the information come from the row stripe.  The
default is the column stripe.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_eq_info} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 20 24 2}{...}
{p2col: {cmd:r(k_eq)}}number of equations{p_end}
{p2col: {cmd:r(k}{it:#}{cmd:)}}number of elements in the {it:#}th equation
{p_end}

{pstd}Macros{p_end}
{p2col: {cmd:r(eq}{it:#}{cmd:)}}name of the {it:#}th equation{p_end}
