{smcl}
{* *! version 1.2.1  18sep2018}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "matmacfunc##syntax"}{...}
{viewerjumpto "Description" "matmacfunc##description"}{...}
{viewerjumpto "Option" "matmacfunc##option"}{...}
{viewerjumpto "Examples" "matmacfunc##examples"}{...}
{title:Title}

{phang}
Macro functions regarding matrices


{marker syntax}{...}
{title:Syntax}

{pstd}
The following macro functions are allowed with {cmd:local} and
{cmd:global}:

	{cmd:: rowfullnames} {it:A}
	{cmd:: colfullnames} {it:A}

	{cmd:: rownames} {it:A}
	{cmd:: colnames} {it:A}

	{cmd:: roweq} {it:A} {cmd:,} {cmdab:q:uoted}
	{cmd:: coleq} {it:A} {cmd:,} {cmdab:q:uoted}

	{cmd:: rownumb} {it:A} {it:s}
	{cmd:: colnumb} {it:A} {it:s}

	{cmd:: roweqnumb} {it:A} {it:s}
	{cmd:: coleqnumb} {it:A} {it:s}

	{cmd:: rownfreeparms} {it:A}
	{cmd:: colnfreeparms} {it:A}

	{cmd:: rownlfs} {it:A}
	{cmd:: colnlfs} {it:A}

	{cmd:: rowsof} {it:A}
	{cmd:: colsof} {it:A}

	{cmd:: rowvarlist} {it:A}
	{cmd:: colvarlist} {it:A}

	{cmd:: rowlfnames} {it:A} {cmd:,} {cmdab:q:uoted}
	{cmd:: collfnames} {it:A} {cmd:,} {cmdab:q:uoted}


{marker description}{...}
{title:Description}

{pstd}
These macro functions work with the row and column names of a matrix.
See {manhelp matrix_rownames P:matrix rownames} for
setting the names.  See {manhelp macro P} for information on macro
functions.  See {manhelp matrix P} for information on matrices in Stata.

{pstd}
{cmd:rowfullnames} and {cmd:colfullnames} obtain the full specification
of the current row and column names of a matrix.

{pstd}
{cmd:rownames} and {cmd:colnames} obtain the current row and column
names of a matrix.

{pstd}
{cmd:roweq} and {cmd:coleq} obtain the current row and column
equation names of a matrix.

{pstd}
{cmd:rownumb} and {cmd:colnumb} obtain the row and column number of
{it:A} associated with {it:s}; numeric missing "{cmd:.}" is returned if
{it:s} is not found.

{pstd}
{cmd:roweqnumb} and {cmd:coleqnumb} obtain the row and column equation
number of {it:A} associated with {it:s}; numeric missing "{cmd:.}" is
returned if {it:s} is not found.

{pstd}
{cmd:rownfreeparms} and {cmd:colnfreeparms} obtain the number of free
parameters in rows and columns of {it:A}.

{pstd}
{cmd:rownlfs} and {cmd:colnlfs} obtain the number of linear forms
in rows and columns of {it:A}.

{pstd}
{cmd:rowsof} and {cmd:colsof} obtain the number of rows and columns of
{it:A}.

{pstd}
{cmd:rowvarlist} and {cmd:colvarlist} obtain the variable list
corresponding to the rows and columns of {it:A}.

{pstd}
{cmd:rowlfnames} and {cmd:collfnames} obtain the list
of names corresponding to the linear forms in rows and columns of {it:A}.


{marker option}{...}
{title:Option}

{phang}
{cmd:quoted} encloses each equation name in double quotes.  Some Stata
estimation commands can create matrices with equation
names containing spaces when the dependent variable has value labels
containing spaces.  The {cmd:quoted} option makes it possible to correctly
determine each equation name.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. local names : rownames mymat}{p_end}
{phang}{cmd:. local names : rowfullnames mymat}{p_end}
{phang}{cmd:. local names : colfullnames e(b)}{p_end}
