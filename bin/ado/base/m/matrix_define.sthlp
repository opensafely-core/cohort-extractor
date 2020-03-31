{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog "matrix define" "dialog matrix_define"}{...}
{viewerdialog "matrix input" "dialog matrix_input"}{...}
{vieweralsosee "[P] matrix define" "mansection P matrixdefine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix get" "help matrix get"}{...}
{vieweralsosee "[P] matrix utility" "help matrix utility"}{...}
{vieweralsosee "[P] scalar" "help scalar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FN] Matrix functions" "help matrix_functions"}{...}
{vieweralsosee "[U] 13 Functions and expressions (expressions)" "help exp"}{...}
{vieweralsosee "matrix operators" "help matrix operators"}{...}
{viewerjumpto "Syntax" "matrix_define##syntax"}{...}
{viewerjumpto "Menu" "matrix_define##menu"}{...}
{viewerjumpto "Description" "matrix_define##description"}{...}
{viewerjumpto "Links to PDF documentation" "matrix_define##linkspdf"}{...}
{viewerjumpto "Remarks" "matrix_define##remarks"}{...}
{viewerjumpto "Examples" "matrix_define##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] matrix define} {hline 2}}Matrix definition{p_end}
{p2col:}({mansection P matrixdefine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Perform matrix computations

	{cmdab:mat:rix} [{cmdab:def:ine}] {it:A} = {it:matrix_expression}


    Input matrices

{p 8 24 2}{cmdab:mat:rix} [{cmdab:in:put}]{space 2}{it:A}
		{cmd:= (}{it:#}[{cmd:,}{it:#...}]
		[{cmd:\} {it:#}[{cmd:,}{it:#...}] [{cmd:\} [{it:...}]]]{cmd:)}


{marker menu}{...}
{title:Menu}

    {title:matrix define}

{phang2}
{bf:Data > Matrices, ado language > Define matrix from expression}

    {title:matrix input}

{phang2}
{bf:Data > Matrices, ado language > Input matrix by hand}


{marker description}{...}
{title:Description}

{pstd}
{cmd:matrix define} performs matrix computations.  The word {cmd:define} may
be omitted.

{pstd}
{cmd:matrix input} provides a method for inputting matrices.  The word
{cmd:input} may be omitted (see the discussion that follows).

{pstd}
See {manhelp matrix P} for background information and links to more matrix
help.

{pstd}See {manhelp exp M-2} for matrix expressions in Mata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixdefineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:matrix define} calculates matrix results from other matrices.  For
instance,

{phang2}{cmd:. matrix define D = A + B + C}

{pstd}
creates {cmd:D} containing the sum of {cmd:A}, {cmd:B}, and {cmd:C}.  The
word {cmd:define} may be omitted, 

{phang2}{cmd:. matrix D = A + B + C}

{pstd}
and the command may be further abbreviated:

{phang2}{cmd:. mat D = A + B + C}

{pstd}
The same matrix may appear on both the left and the right of the equals
sign in all contexts, and Stata will not become confused.  Complicated
matrix expressions are allowed; see {help matrix operators} and
{help matrix functions}.

{pstd}
With {cmd:matrix input}, you define the matrix elements rowwise; commas are
used to separate elements within a row, and backslashes are used to separate
the rows.  Spacing does not matter.

{phang2}{cmd:. matrix input A = (1,2\3,4)}{p_end}

{pstd}
The above would also work if you omitted the {cmd:input} subcommand:

{phang2}{cmd:. matrix A = (1,2\3,4)}{p_end}

{pstd}There is a subtle difference:  the first method uses the {cmd:matrix}
{cmd:input} command, and the second uses the matrix expression parser.
Omitting {cmd:input} allows expressions in the command.  For instance,

{phang2}{cmd:. matrix X = (1+1, 2*3/4 \ 5/2, 3)}{p_end}

{pstd}
is understood but

{phang2}{cmd:. matrix input X = (1+1, 2*3/4 \ 5/2, 3)}{p_end}

{pstd}
would produce an error.

{pstd}
{cmd:matrix input}, however, has two other advantages. First, it allows input 
of large matrices.  (The expression parser is limited because it must
"compile" the expression and, if it is too long, will produce an error.)
Second, {cmd:matrix input} allows you to omit the commas.


{marker examples}{...}
{title:Examples}

{pstd}Create 2 x 2 matrix {cmd:mymat}{p_end}
{phang2}{cmd:. matrix input mymat = (1,2\ 3, 4)}

{pstd}List the contents of {cmd:mymat}{p_end}
{phang2}{cmd:. mat list mymat}

{pstd}Drop matrix {cmd:mymat}{p_end}
{phang2}{cmd:. mat drop mymat}

{pstd}Create 2 x 2 matrix {cmd:mymat}{p_end}
{phang2}{cmd:. matrix mymat = (1,2\ 3, 4)}

{pstd}Create 1 x 4 row vector {cmd:myrvec}{p_end}
{phang2}{cmd:. matrix input myrvec = (1.7, 2.93, -5, 3)}

{pstd}List the contents of {cmd:myrvec}{p_end}
{phang2}{cmd:. mat list myrvec}

{pstd}Create 4 x 1 column vector {cmd:mycvec}{p_end}
{phang2}{cmd:. matrix mycvec = (1.7 \ 2.93 \ -5 \ 3)}

{pstd}List the contents of {cmd:mycvec}{p_end}
{phang2}{cmd:. mat list mycvec}{p_end}
