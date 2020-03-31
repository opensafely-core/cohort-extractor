{smcl}
{* *! version 1.1.12  08may2019}{...}
{vieweralsosee "[P] matrix" "mansection P matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "[P] matrix define" "help matrix define"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] matrix} {hline 2}}Summary of matrix commands{p_end}
{p2col:}({mansection P matrix:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Comments are provided below under the following headings.

	 Subject{col 57}Also see help
    {hline 72}
     1.  Inputting matrices by hand{col 57}{helpb matrix define}
     
     2.  Matrix expressions
	   Matrix operators{col 57}{help matrix operators}
	   Matrix functions{col 57}{help matrix functions}
	   
     3.  Matrix subscripting{col 57}{help matrix subscripting}

     4.  Submatrix extraction{col 57}{help matrix extraction}

     5.  Submatrix substitution{col 57}{help matrix substitution}

     6.  Data <{hline 3}> Matrix conversion{col 57}{helpb mkmat}

     7.  Obtaining copies of system matrices{col 57}{helpb get():matrix get}

     8.  Matrix decomposition
	   Eigenvalues & vectors of symmetric matrices{col 57}{helpb matrix symeigen}
	   Eigenvalues of nonsymmetric matrices{col 57}{helpb matrix eigenvalues}
	   Singular value decomposition{col 57}{helpb matrix svd}

     9.  Setting row and column names{col 57}{helpb matrix rownames}

    10.  Macro functions regarding matrices{col 57}{help matmacfunc}

    11.  Accumulating cross-product matrices{col 57}{helpb matrix accum}
    
    12.  Generating scores from coefficient vectors{col 57}{helpb matrix score}
    
    13.  (Dis)similarity measures{col 57}{helpb matrix dissimilarity}

    14.  Constraint processing{col 57}{helpb makecns}

    15.  Matrix join
           Matrix row name{col 57}{helpb matrix rowjoinbyname}
           Matrix column name{col 57}{helpb matrix coljoinbyname}

    16.  Matrix utilities{col 57}{help matrix utility}
    {hline 72}


{pstd}
In the syntax diagrams, capital letters {it:A}, {it:B}, ..., {it:Z} stand
for matrix names.  Full details can be found in {manlink P matrix}.

{pstd}
Beyond the {cmd:matrix} commands, Stata has a complete matrix programming
language, Mata, that provides more advanced matrix functions, support for
complex matrices, fast execution speed, and the ability to directly
access Stata's data, macros, matrices, and returned results.  Mata can be
used interactively as a matrix calculator, but it is even more useful for
programming; see {helpb mata:[M-0] Intro}. 


{title:1.  Inputting matrices by hand}{...}
{right:(see {manhelp matrix_define P:matrix define})  }

{p 8 19 2}{cmdab:mat:rix} {cmdab:in:put} {it:A} {cmd:= (}{it:#}[{cmd:,}{it:#...}]
		[{cmd:\} {it:#}[{cmd:,}{it:#...}] [{cmd:\} [{it:...}]]]{cmd:)}

    Examples:
{phang2}{cmd:. matrix input mymat = (1,2\3,4)}{p_end}
{phang2}{cmd:. matrix input myvec = (1.7, 2.93, -5, 3)}{p_end}
{phang2}{cmd:. matrix input mycol = (1.7\ 2.93\ -5\ 3)}

{pstd}
The above would also work if you omitted the {cmd:input} subcommand:

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


{title:2.  Matrix expressions}{right:(see {manlink P matrix define};  }
{right:{help matrix operators}   }
{right:and {help matrix functions})  }

{pstd}
Complex matrix expressions are allowed within Stata.

{p 8 14 2}{cmdab:mat:rix} {it:A} {cmd:=} {it:matrix_expression}

    Examples:
{phang2}{cmd:. matrix D {space 2} = B}{p_end}
{phang2}{cmd:. matrix beta = invsym(X'*X)*X'*y}{p_end}
{phang2}{cmd:. matrix C {space 2} = (C+C')/2}{p_end}
{phang2}{cmd:. matrix sub{space 2}= x[1..., 2..5]/2}{p_end}
{phang2}{cmd:. matrix L = cholesky(0.1*I(rowsof(X)) + 0.9*X)}

{pstd}
The available matrix operators and functions are detailed in
{manlink P matrix define}; see {help matrix operators} and
{help matrix functions}.


{title:3.  Matrix subscripting}{right:(see {manlink P matrix define};  }
{right:{help matrix subscripting})  }

{p 8 14 2}
{cmdab:mat:rix} {it:A} {cmd:=} {it:...} {it:B}{cmd:[}{it:r}{cmd:,}{it:c}{cmd:]} {it:...}

{pstd}
where {it:r} and {it:c} are numeric or string scalar expressions.

    Examples:
{phang2}{cmd:. matrix A = A/A[1,1]}{p_end}
{phang2}{cmd:. matrix B = A["weight","displ"]}{p_end}
{phang2}{cmd:. matrix D = G[1,"eq1:l1.gnp"]}

{pstd}
Subscripting with numeric expressions may be used in any expression context
(such as {cmd:generate} and {cmd:replace}).  Subscripting by row/column
name may be used only in a matrix context.  (This latter is not a constraint;
see the
{mansection P matrixdefineRemarksandexamplesMatrixfunctionsreturningscalars:{bf:rownumb()}} and
{mansection P matrixdefineRemarksandexamplesMatrixfunctionsreturningscalars:{bf:colnumb()}}
matrix functions returning scalar
in {bf:[P] matrix define} and {help matrix functions}; they may be used
in any expression context.)


{title:4.  Submatrix extraction}{right:(see {mansection P matrixdefineRemarksandexamplesSubscriptingandelement-by-elementdefinition:{bf:[P] matrix define}};  }
{right:{help matrix extraction})  }

{p 8 14 2}{cmdab:mat:rix} {it:A} {cmd:=} {it:...} {it:B}{cmd:[}{it:r0}{cmd:..}{it:r1}{cmd:,}
				{it:c0}{cmd:..}{it:c1}{cmd:]} {it:...}

{pstd}
where {it:r0}, {it:r1}, {it:c0}, and {it:c1} are numeric or string scalar
expressions.

    Examples:
{phang2}{cmd:. matrix A = B[2..4, 3..6]}{p_end}
{phang2}{cmd:. matrix A = B[2..., 2...]}{p_end}
{phang2}{cmd:. matrix A = B[1, "price".."mpg"]}{p_end}
{phang2}{cmd:. matrix A = B["eq1:", "eq1:"]}


{title:5.  Submatrix substitution}{right:(see {mansection P matrixdefineRemarksandexamplesSubscriptingandelement-by-elementdefinition:{bf:[P] matrix define}};  }
{right:{help matrix substitution})  }

{p 8 14 2}{cmdab:mat:rix} {it:A}{cmd:[}{it:r}{cmd:,}{it:c}{cmd:]} {cmd:=} {it:...}

{pstd}
where {it:r} and {it:c} are numeric scalar expressions.

{pstd}
If the matrix expression to the right of the equal sign evaluates to a
scalar or 1 x 1 matrix, the indicated element of {it:A} is replaced.  If the
matrix expression evaluates to a matrix, the resulting matrix is placed in
{it:A} with its upper left corner at ({it:r},{it:c}).

    Examples:
{phang2}{cmd:. matrix A[2,2] = B}{p_end}
{phang2}{cmd:. matrix A[rownumb(A,"price"), colnumb(A,"mpg")] = sqrt(2)}


{title:6.  Data <{hline 3}> Matrix conversion}{right:(see {manhelp mkmat P:matrix mkmat})  }

{pstd}
Variables can be converted into matrices and likewise matrices can be
converted into variables.  The details are found in
{manhelp mkmat P:matrix mkmat}. 


{title:7.  Obtaining copies of system matrices}{right:(see {manhelp get() P:matrix get})  }

{pstd}
The usual way to obtain matrices after a command that produces matrices is
simply to refer to the returned matrix in the standard way.  For instance all
estimation commands return

{p 8 20 2}{hi:e(b)} {space 6} coefficient vector{p_end}
{p 8 20 2}{hi:e(V)} {space 6} variance-covariance matrix of the estimates (VCE)

{pstd}
And these matrices can be referenced directly.

    Examples:
{phang2}{cmd:. matrix list e(b)}{p_end}
{phang2}{cmd:. matrix myV = e(V)}

{pstd}
Other matrices are returned by various commands.  They are obtained in the
same way.  The {cmd:get()} function also obtains matrices
after certain commands; see {manhelp get() P:matrix get}.


{title:8.  Matrix decomposition}{right:(see {manhelp matrix_symeigen P:matrix symeigen},     }
{right:{manhelp matrix_eigenvalues P:matrix eigenvalues},  }
{right:and {manhelp matrix_svd P:matrix svd})          }

{pstd}
Obtaining the eigenvalues and eigenvectors from a symmetric matrix is
detailed in {manhelp matrix_symeigen P:matrix symeigen}.
Obtaining the real and imaginary parts of the eigenvalues of a square matrix is
detailed in {manhelp matrix_eigenvalues P:matrix eigenvalues}.
Obtaining the singular value decomposition of a matrix is detailed in
{manhelp matrix_svd P:matrix svd}.  If you desire the Cholesky
factorization or the matrix sweep function, then see the
{mansection P matrixdefineRemarksandexamplescholesky():{bf:cholesky()}} and
{mansection P matrixdefineRemarksandexamplessweep():{bf:sweep()}}
matrix functions returning matrices in {bf:[P] matrix define}; 
also see {help matrix functions}.


{title:9.  Setting row and column names}{right:(see {manhelp matrix_rownames P:matrix rownames})  }

{pstd}
Row and column names of matrices in Stata have special meaning -- they tell
the names of the variables, equations, and time-series operators that helped
create the matrix.  Stata automatically carries these names along during
matrix operations and uses the names to produce appropriately labeled
command output.

{pstd}
In most cases you do not need to worry about setting matrix row and column
names yourself.  See {manhelp matrix_rownames P:matrix rownames}
for details of how to manually set matrix row and column names.


{title:10.  Macro functions regarding matrices}{...}
{right:(see {mansection P matrixdefineRemarksandexamplesMacrofunctions:{bf:[P] matrix define}};  }
{right:{help matmacfunc})  }

{pstd}
The following macro functions are allowed with {cmd:local} and
{cmd:global}:

	{cmd:: rowfullnames} {it:A}
	{cmd:: colfullnames} {it:A}

	{cmd:: rownames} {it:A}
	{cmd:: colnames} {it:A}

	{cmd:: roweq} {it:A}
	{cmd:: coleq} {it:A}

    Examples:
{phang2}{cmd:. local names : rownames mymat}{p_end}
{phang2}{cmd:. local names : rowfullnames mymat}{p_end}
{phang2}{cmd:. local names : colfullnames e(b)}


{title:11.  Accumulating cross-product matrices}{...}
{right:(see {manhelp matrix_accum P:matrix accum})  }

{pstd}
Most statistical computations involve matrix operations such as X'X or
X'WX.  In these cases X may have a very large number of rows and usually a
small to moderate number of columns.  W usually takes on a restricted form
(diagonal, block diagonal, or is known in some functional form and need not be
stored).  Computing X'X or X'WX by storing the matrices and then directly
performing the matrix multiplications is inefficient and wasteful.  Stata has
matrix cross-product accumulation commands that will compute these results
efficiently.  See {manhelp matrix_accum P:matrix accum}.


{title:12.  Generating scores from coefficient vectors}{...}
{right:(see {manhelp matrix_score P:matrix score})  }

{pstd}
Scoring refers to forming linear combinations of variables in the data with
respect to a coefficient vector.  This is easily accomplished using the
{cmd:matrix score} command; see {manhelp matrix_score P:matrix score}.


{title:13.  (Dis)similarity measures}{...}
{right:(see {manhelp matrix_dissimilarity P:matrix dissimilarity})  }

{pstd}
Many similarity, dissimilarity, and distance measures for continuous or binary
data are available; see {manhelpi measure_option MV}.
{cmd:matrix dissimilarity} allows you to compute these (dis)similarities
between observations or variables; see
{manhelp matrix_dissimilarity P:matrix dissimilarity}.


{title:14.  Constraint processing}{...}
{right:(see {manhelp makecns P})  }

{pstd}
Estimation commands that allow constrained estimation define constraints
using the {helpb constraint} command.  Program writers can incorporate these
same features using the commands in {manhelp makecns P}.


{title:15.  Matrix join}{right:(see {manhelp matrix_rowjoinbyname P:matrix rowjoinbyname})  }

{pstd}
Sometimes you need to join rows while matching on column names or join
columns while matching on row names.  The commands {cmd:matrix rowjoinbyname}
and {cmd:matrix coljoinbyname} allow this.


{title:16.  Matrix utilities}{right:(see {manhelp matrix_utility P:matrix utility})  }

{pstd}
There are matrix utilities to

{p 8 27 2}{cmd:matrix dir} {space 6} List the currently defined matrices{p_end}
{p 8 27 2}{cmd:matrix list} {space 5} Display the contents of a matrix{p_end}
{p 8 27 2}{cmd:matrix rename} {space 3} Rename a matrix{p_end}
{p 8 27 2}{cmd:matrix drop} {space 5} Drop a matrix

{pstd}
See {manhelp matrix_utility P:matrix utility} for details.
{p_end}
