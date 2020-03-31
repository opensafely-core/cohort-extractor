{smcl}
{* *! version 1.1.11  15may2018}{...}
{viewerdialog "matrix svd" "dialog matrix_svd"}{...}
{vieweralsosee "[P] matrix svd" "mansection P matrixsvd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix define" "help matrix define"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-5] svd()" "help mf_svd"}{...}
{viewerjumpto "Syntax" "matrix_svd##syntax"}{...}
{viewerjumpto "Menu" "matrix_svd##menu"}{...}
{viewerjumpto "Description" "matrix_svd##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_svd##linkspdf"}{...}
{viewerjumpto "Remarks" "matrix_svd##remarks"}{...}
{viewerjumpto "Examples" "matrix_svd##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] matrix svd} {hline 2}}Singular value decomposition{p_end}
{p2col:}({mansection P matrixsvd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmdab:mat:rix} {cmd:svd} {it:U} {it:W} {it:V} {cmd:=} {it:A}

{pstd}
where {it:U}, {it:W}, and {it:V} are matrix names (the matrices may exist
or not) and {it:A} is the name of an existing m x n matrix, m {ul:>} n.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Matrices, ado language > Singular value decomposition}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix svd} produces the singular value decomposition (SVD) of {it:A}.

{pstd}
Also see {bf:{help mf_svd:[M-5] svd()}} for alternative routines for obtaining
the singular value decomposition.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixsvdRemarksandexamples:Remarks and examples}

        {mansection P matrixsvdMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The singular value decomposition of m x n matrix {it:A}, m {ul:>} n, is defined
as

	{it:A} = {it:U} diag({it:W}) {it:V}'

{pstd}
where {it:U} is column orthogonal, the elements of {it:W} are
positive or zero, and {it:V}'{it:V}=I.


{marker examples}{...}
{title:Examples}

    {cmd:. matrix A = (1,2,9\2,7,5\2,4,18)}
    {cmd:. matrix svd U w V = A}
    {cmd:. matrix list U}
    {cmd:. matrix list w}
    {cmd:. matrix list V}
    {cmd:. matrix newA = U*diag(w)*V'}
    {cmd:. matrix list newA}
