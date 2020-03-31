{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] matrix define" "mansection P matrixdefine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix define (subscripting)" "help matrix_subscripting"}{...}
{vieweralsosee "[P] matrix define (substitution)" "help matrix_substitution"}{...}
{viewerjumpto "Syntax" "matrix_extraction##syntax"}{...}
{viewerjumpto "Examples" "matrix_extraction##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] matrix define} {hline 2}}Submatrix extraction
{p_end}
{p2col:}({mansection P matrixdefine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmdab:mat:rix} {it:A} {cmd:=} {it:...} {it:B}{cmd:[}{it:r0}{cmd:..}{it:r1}{cmd:,}
				{it:c0}{cmd:..}{it:c1}{cmd:]} {it:...}

{pstd}
where {it:r0}, {it:r1}, {it:c0}, and {it:c1} are numeric or string scalar
expressions.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. matrix A = B[2..4, 3..6]}{p_end}
{phang}{cmd:. matrix A = B[2..., 2...]}{p_end}
{phang}{cmd:. matrix A = B[1, "price".."mpg"]}{p_end}
{phang}{cmd:. matrix A = B["eq1:", "eq1:"]}{p_end}
