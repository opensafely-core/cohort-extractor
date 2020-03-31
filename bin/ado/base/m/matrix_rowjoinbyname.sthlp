{smcl}
{* *! version 1.0.0  25mar2019}{...}
{vieweralsosee "[P] matrix rowjoinbyname" "mansection P matrixrowjoinbyname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix define" "help matrix define"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "matmacfunc" "help matmacfunc"}{...}
{viewerjumpto "Syntax" "matrix_rowjoinbyname##syntax"}{...}
{viewerjumpto "Description" "matrix_rowjoinbyname##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_rowjoinbyname##linkspdf"}{...}
{viewerjumpto "Options" "matrix_rowjoinbyname##options"}{...}
{viewerjumpto "Examples" "matrix_rowjoinbyname##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[P] matrix rowjoinbyname} {hline 2}}Join
rows while matching on column names{p_end}
{p2col:}({mansection P matrixrowjoinbyname:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Join matrix rows while matching on matrix column names

{p 8 15 2}
{cmdab:mat:rix} {cmdab:rowjoin:byname}
{it:A} {cmd:=} {it:matrix_list} [{cmd:,} {it:options}]
{p_end}


    Join matrix columns while matching on matrix row names

{p 8 15 2}
{cmdab:mat:rix} {cmdab:coljoin:byname}
{it:A} {cmd:=} {it:matrix_list} [{cmd:,} {it:options}]
{p_end}


{phang}
{it:matrix_list} is a list of Stata matrices, including matrices
from {cmd:e()} and {cmd:r()}.

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt mis:sing(#)}}missing-value code for unmatched elements; default is {cmd:missing(.)}{p_end}
{synopt :{opt noc:onsolidate}}do not consolidate equations and terms{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix rowjoinbyname} and {cmd:matrix coljoinbyname} join matrices along
one dimension while matching names in the other dimension.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixrowjoinbyname:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt missing(#)} specifies that elements not matched across all
matrices in {it:matrix_list} be set to {it:#}.
The default is {cmd:missing(.)}.

{phang}
{opt noconsolidate} prevents consolidating of equations and terms along the
matching dimension.
By default, the elements along the matching dimension are reordered so
that equations, factor-variable terms, and time-series-operated
variables appear together.


{marker examples}{...}
{title:Examples}

    {hi:Example 1}

                 b1  b2                  c1
              a1  1   2             a3   13
        z1 =  a2  3   4      z2 =   a1   11
              a3  5   6             a2   12

        {cmd:. matrix coljoinbyname z12 = z1 z2}

                 b1  b2  c1
              a1  1   2  11
        z12 = a2  3   4  12
              a3  5   6  13


    {hi:Example 2}

                   z11 z12                z11 z13
             A:a1    1   5          A:a1   11  12
        z1 = A:a2    2   6     z2 = A:a3   21  22
             B:b1    3   7          B:b1   31  32
               e1    4   8          C:c1   41  42

        {cmd:. matrix coljoinbyname z12 = z1 z2, miss(.u)}

                       z11  z12  z11  z13
                 A:a1    1    5   11   12
                 A:a2    2    6   .u   .u
        z12 =    A:a3   .u   .u   21   22
                 B:b1    3    7   31   32
                   e1    4    8   .u   .u
                 C:c1   .u   .u   41   42
