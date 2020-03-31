{smcl}
{* *! version 1.1.3  20sep2014}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix define" "help matrix_define"}{...}
{vieweralsosee "[FN] Matrix functions" "help matrix_functions"}{...}
{viewerjumpto "Description" "matrix_operators##description"}{...}
{viewerjumpto "Examples" "matrix_operators##examples"}{...}
{title:Title}

    Matrix operators


{marker description}{...}
{title:Description}

{pstd}
Matrix operators are outlined here.  See {manhelp matrix P} for background
information and links to more matrix help.

{pstd}
Let {it:B} and {it:C} represent matrix names or matrix expressions.  Let
{it:z} represent numbers or scalar expressions.

{pstd}
The matrix monadic operators are

	{cmd:-}{it:B}      negation
	{it:B}{cmd:'}      transpose

{pstd}
The matrix dyadic operators are

{p 8 18 2}{it:B} {cmd:\} {it:C} {space 1} add rows of {it:C} below rows of
	{it:B} (row join){p_end}
{p 8 18 2}{it:B} {cmd:,} {it:C} {space 1} add columns of {it:C} to the right of
	{it:B} (column join){p_end}
{p 8 18 2}{it:B} {cmd:+} {it:C} {space 1} addition{p_end}
{p 8 18 2}{it:B} {cmd:-} {it:C} {space 1} subtraction{p_end}
{p 8 18 2}{it:B} {cmd:*} {it:C} {space 1} multiplication (including mult. by
	scalar){p_end}
{p 8 18 2}{it:B} {cmd:/} {it:z} {space 1} division by scalar{p_end}
{p 8 18 2}{it:B} {cmd:#} {it:C} {space 1} Kronecker product

{pstd}
Parentheses may be used to control order of evaluation.  The
default order of precedence for the matrix operators (from highest to lowest)
is

            Operator               Symbol
	    {hline 29}
	    parentheses            {cmd:()}
	    transpose              {cmd:'}
	    negation               {cmd:-}
	    Kronecker product      {cmd:#}
	    division by scalar     {cmd:/}
	    multiplication         {cmd:*}
	    subtraction            {cmd:-}
	    addition               {cmd:+}
	    column join            {cmd:,}
	    row join               {cmd:\}
	    {hline 29}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. matrix A = (1,2\3,4)}{p_end}
{phang}{cmd:. matrix B = (5,7\9,2)}{p_end}
{phang}{cmd:. matrix C = A+B}{p_end}
{phang}{cmd:. matrix list C}

{phang}{cmd:. matrix B = A-B}{p_end}
{phang}{cmd:. matrix list B}

{phang}{cmd:. matrix X = (1,1\2,5\8,0\4,5)}{p_end}
{phang}{cmd:. matrix C = 3*X*A'*B}{p_end}
{phang}{cmd:. matrix list C}

{phang}{cmd:. matrix D = (X'*X - A'*A)/4}{p_end}
{phang}{cmd:. matrix rownames D = dog cat}{p_end}
{phang}{cmd:. matrix colnames D = bark meow}{p_end}
{phang}{cmd:. matrix list D}{p_end}

{phang}{cmd:. matrix rownames A = aa bb}{p_end}
{phang}{cmd:. matrix colnames A = alpha beta}{p_end}
{phang}{cmd:. matrix list A}

{phang}{cmd:. matrix D=A#D}{p_end}
{phang}{cmd:. matrix list D}

{phang}{cmd:. matrix G=A,B\D}{p_end}
{phang}{cmd:. matrix list G}

{phang}{cmd:. matrix Z = (B - A)'*(B + A'*-B)/4}{p_end}
{phang}{cmd:. matrix list Z}{p_end}
