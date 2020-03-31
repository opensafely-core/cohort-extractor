{smcl}
{* *! version 1.0.2  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_put_omit##syntax"}{...}
{viewerjumpto "Description" "_ms_put_omit##description"}{...}
{viewerjumpto "Stored results" "_ms_put_omit##results"}{...}
{title:Title}

{p2colset 4 21 24 2}{...}
{p2col:{hi:[P] _ms_put_omit}}{hline 2}
Add o. operators to a matrix stripe element
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_put_omit} {it:spec}

{pstd}
where {it:spec} is a valid matrix stripe element, excluding the
equation part.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_put_omit} places the {cmd:o.} operator on the variable names in
{it:spec} so that {it:spec} is recognized as omitted.  The result is returned
in {cmd:s()}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_put_omit} stores the following in {cmd:s()}:

{p2colset 9 24 28 2}{...}
{pstd}Macros{p_end}
{p2col: {cmd:s(ospec)}}matrix
	stripe including {cmd:o.} operators{p_end}
