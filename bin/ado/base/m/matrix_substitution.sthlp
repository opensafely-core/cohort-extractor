{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] matrix define" "mansection P matrixdefine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix define (extraction)" "help matrix_extraction"}{...}
{vieweralsosee "[P] matrix define (subscripting)" "help matrix_subscripting"}{...}
{viewerjumpto "Syntax" "matrix_substitution##syntax"}{...}
{viewerjumpto "Description" "matrix_substitution##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_substitution##linkspdf"}{...}
{viewerjumpto "Examples" "matrix_substitution##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] matrix define} {hline 2}}Submatrix substitution
{p_end}
{p2col:}({mansection P matrixdefine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmdab:mat:rix} {it:A}{cmd:[}{it:r}{cmd:,}{it:c}{cmd:]} {cmd:=} {it:...}

{pstd}
where {it:r} and {it:c} are numeric scalar expressions.


{marker description}{...}
{title:Description}

{pstd}
If the matrix expression to the right of the equal sign evaluates to a
scalar or 1 x 1 matrix, the indicated element of {it:A} is replaced.  If the
matrix expression evaluates to a matrix, the resulting matrix is placed in
{it:A} with its upper left corner at ({it:r},{it:c}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixdefineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. matrix A[2,2] = B}{p_end}
{phang}{cmd:. matrix A[rownumb(A,"price"), colnumb(A,"mpg")] = sqrt(2)}{p_end}
