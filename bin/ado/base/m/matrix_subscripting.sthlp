{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] matrix define" "mansection P matrixdefine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix define (extraction)" "help matrix_extraction"}{...}
{vieweralsosee "[P] matrix define (substitution)" "help matrix_substitution"}{...}
{viewerjumpto "Syntax" "matrix_subscripting##syntax"}{...}
{viewerjumpto "Description" "matrix_subscripting##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_subscripting##linkspdf"}{...}
{viewerjumpto "Examples" "matrix_subscripting##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] matrix define} {hline 2}}Matrix subscripting
{p_end}
{p2col:}({mansection P matrixdefine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmdab:mat:rix} {it:A} {cmd:=} {it:...} {it:B}{cmd:[}{it:r}{cmd:,}{it:c}{cmd:]} {it:...}

{pstd}
where {it:r} and {it:c} are numeric or string scalar expressions.


{marker description}{...}
{title:Description}

{pstd}
Subscripting with numeric expressions may be used in any expression context
(such as {helpb generate} and {helpb replace})  Subscripting by row/column
name may only be used in a matrix context.  (This latter is not a constraint;
see the {cmd:rownumb()} and {cmd:colnumb()} matrix functions returning scalar
in {hi:[P] matrix define} and {help matrix functions}; they may be used
in any expression context.)


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixdefineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. matrix A = A/A[1,1]}{p_end}
{phang}{cmd:. matrix B = A["weight","displ"]}{p_end}
{phang}{cmd:. matrix D = G[1,"eq1:l1.gnp"]}{p_end}
