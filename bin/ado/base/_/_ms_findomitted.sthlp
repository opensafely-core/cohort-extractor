{smcl}
{* *! version 1.0.1  28feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_findomitted##syntax"}{...}
{viewerjumpto "Description" "_ms_findomitted##description"}{...}
{viewerjumpto "Option" "_ms_findomitted##option"}{...}
{title:Title}

{p2colset 4 24 27 2}{...}
{p2col:{hi:[P] _ms_findomitted}}{hline 2} Find and flag omitted matrix
elements{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_findomitted} {it:bmat} {it:vmat} [{cmd:,} {opt nocheck}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_findomitted} searches for zero-valued elements of row vector
{it:bmat} that correspond to zero-valued diagonal elements of {it:vmat}.  It
then flags those zero-valued elements of {it:bmat} as "(omitted)" using the
{cmd:o.} operator on the corresponding column stripe element of {it:bmat}.
The row and column stripes of {it:vmat} are also updated if the {opt nocheck}
option is not specified.


{marker option}{...}
{title:Option}

{phang}
{opt nocheck} prevents {cmd:_ms_findomitted} from doing anything with the
column and row stripes of {it:vmat}.
By default, the matrix stripe information in the columns of {it:bmat} must
agree with the matrix stripe information in the rows and columns of {it:vmat}.
{p_end}
