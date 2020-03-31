{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_op_info##syntax"}{...}
{viewerjumpto "Description" "_ms_op_info##description"}{...}
{viewerjumpto "Stored results" "_ms_op_info##results"}{...}
{title:Title}

{pstd}
{hi:[P] _ms_op_info} {hline 2} Matrix stripe operator information


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_op_info} {it:matrix_name}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_op_info} returns an indication of whether {it:matrix_name} has
factor variables or time-series operators in any of its column stripe
elements.  Factor variables include the omit operator, 'o', and interactions.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_op_info} stores the following in {cmd:r()}:

{pstd}Scalars{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(fvops)}}indicator for factor variables{p_end}
{p2col: {cmd:r(tsops)}}indicator for time-series operators{p_end}
