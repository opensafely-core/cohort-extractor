{smcl}
{* *! version 1.1.8  15may2018}{...}
{viewerdialog "matrix symeigen" "dialog matrix_symeigen"}{...}
{vieweralsosee "[P] matrix symeigen" "mansection P matrixsymeigen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix eigenvalues" "help matrix_eigenvalues"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "matrix_symeigen##syntax"}{...}
{viewerjumpto "Menu" "matrix_symeigen##menu"}{...}
{viewerjumpto "Description" "matrix_symeigen##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_symeigen##linkspdf"}{...}
{viewerjumpto "Examples" "matrix_symeigen##examples"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[P] matrix symeigen} {hline 2}}Eigenvalues and eigenvectors of symmetric matrices{p_end}
{p2col:}({mansection P matrixsymeigen:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:mat:rix} {cmdab:syme:igen} {it:X} {it:v} {cmd:=} {it:A}

{phang}
where {it:A} is an n x n symmetric matrix.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Matrices, ado language > Eigenvalues and eigenvectors of symmetric matrices}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix symeigen} returns the
eigenvectors in the columns of {it:X}: n x n and the corresponding eigenvalues
in {it:v}: 1 x n.  The eigenvalues are sorted: {it:v}[1,1] contains the
largest eigenvalue (and {it:X}[1...,1] its corresponding eigenvector), and
{it:v}[1,{it:n}] contains the smallest eigenvalue (and {it:X}[1...,{it:n}] its
corresponding eigenvector).

{pstd}
If you want the eigenvalues for a nonsymmetric matrix, see
{manhelp matrix_eigenvalues P:matrix eigenvalues}.

{pstd}
Also see {bf:{help mf_eigensystem:[M-5] eigensystem()}} for other routines for
obtaining eigenvalues and eigenvectors.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixsymeigenRemarksandexamples:Remarks and examples}

        {mansection P matrixsymeigenMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Form cross-product matrix{p_end}
{phang2}{cmd:. matrix accum A = weight mpg length, noconstant deviation}

{pstd}List the contents of {cmd:A}{p_end}
{phang2}{cmd:. mat list A}

{pstd}Create matrix X containing the eigenvectors of A and vector {cmd:lambda} 
containing the eigenvalues of A{p_end}
{phang2}{cmd:. matrix symeigen X lambda = A}

{pstd}List the contents of {cmd:lambda}{p_end}
{phang2}{cmd:. mat list lambda}

{pstd}List the contents of {cmd:X}{p_end}
{phang2}{cmd:. mat list X}

{pstd}Create matrix {cmd:AX} equal to {cmd:A*X}{p_end}
{phang2}{cmd:. matrix AX = A*X}

{pstd}Create matrix {cmd:Xlambda} equal to {cmd:X*diag(lambda)}{p_end}
{phang2}{cmd:. matrix Xlambda = X*diag(lambda)}

{pstd}List the contents of {cmd:AX}{p_end}
{phang2}{cmd:. mat list AX}

{pstd}List the contents of {cmd:Xlambda}{p_end}
{phang2}{cmd:. mat list Xlambda}{p_end}
