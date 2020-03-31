{smcl}
{* *! version 1.1.12  15may2018}{...}
{viewerdialog mkmat "dialog mkmat"}{...}
{viewerdialog svmat "dialog svmat"}{...}
{vieweralsosee "[P] matrix mkmat" "mansection P matrixmkmat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix accum" "help matrix_accum"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mkmat##syntax"}{...}
{viewerjumpto "Menu" "mkmat##menu"}{...}
{viewerjumpto "Description" "mkmat##description"}{...}
{viewerjumpto "Links to PDF documentation" "mkmat##linkspdf"}{...}
{viewerjumpto "Options" "mkmat##options"}{...}
{viewerjumpto "Remarks on mkmat" "mkmat##remarks"}{...}
{viewerjumpto "Examples" "mkmat##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[P] matrix mkmat} {hline 2}}Convert variables to matrix and vice versa{p_end}
{p2col:}({mansection P matrixmkmat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Create matrix from variables

{p 8 14 2}{cmd:mkmat} {varlist} {ifin}
[{cmd:,} {cmdab:mat:rix:(}{it:matname}{cmd:)} {cmdab:nomis:sing} 
 {opth rown:ames(varname)} 
 {opth rowe:q(varname)} 
 {opth rowpre:fix(strings:string)} 
 {opt obs}
 {opt nch:ar(#)}]


    Create variables from matrix

{p 8 14 2}{cmd:svmat} {dtype} {it:A} [{cmd:,}
{cmdab:n:ames:(col}|{cmd:eqcol}|{cmd:matcol}|{it:{help strings:string}}{cmd:)}]


    Rename rows and columns of matrix

{p 8 16 2}{cmd:matname} {it:A} {it:namelist} [{cmd:,}
{cmdab:r:ows:(}{it:range}{cmd:)} {cmdab:c:olumns:(}{it:range}{cmd:)}
{cmdab:e:xplicit}]


{pstd}
where {it:A} is the name of an existing matrix, {it:type} is a storage type
for new variables, and {it:namelist} is one of

{phang2}1){space 2}a {it:varlist}, that is, names of existing variables possibly
	abbreviated;

{phang2}2){space 2}{cmd:_cons} and the names of existing variables possibly
	abbreviated;

{phang2}3){space 2}arbitrary names when the {cmd:explicit} option is specified.


{marker menu}{...}
{title:Menu}

    {title:mkmat}

{phang2}
{bf:Data > Matrices, ado language > Convert variables to matrix}

    {title:svmat}

{phang2}
{bf:Data > Matrices, ado language > Convert matrix to variables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mkmat} stores the variables listed in {varlist} in column vectors of
the same name, that is, N x 1 matrices, where N = {cmd:_N}, the number of
observations in the dataset.  Optionally, they can be stored as an N x k
matrix, where k is the number of variables in {it:varlist}.  The variable
names are used as column names.  By default, the rows are named {cmd:r1},
{cmd:r2}, ....

{pstd}
{cmd:svmat} takes a matrix and stores its columns as new variables.  It is
the reverse of the {cmd:mkmat} command, which creates a matrix from existing
variables.

{pstd}
{cmd:matname} renames the rows and columns of a matrix.  {cmd:matname}
differs from the {cmd:matrix rownames} and {cmd:matrix colnames} commands in
that {cmd:matname} expands varlist abbreviations and allows a
restricted range for the rows and columns.  See
{manhelp matrix_rownames P:matrix rownames}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P matrixmkmatRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:matrix(}{it:matname}{cmd:)} requests that the vectors be combined
in a matrix instead of creating the column vectors.

{phang}
{cmd:nomissing} specifies that observations with missing values in any of 
the variables be excluded ("listwise deletion").

{phang}
{opth rownames(varname)} and {opt roweq(varname)} 
specify that the row names and row equations of the created matrix or 
vectors be taken from {it:varname}.  {it:varname} should be a string 
variable or an integer positive-valued numeric variable.  (Value labels 
are ignored; use {helpb decode} if you want to use value labels.)  Within 
the names, spaces and periods are replaced by an underscore ({cmd:_}).  

{phang}
{opth rowprefix:(strings:string)} specifies that the string {it:string} be
prefixed to the row names of the created matrix or column vectors.  In the
prefix, spaces and periods are replaced by an underscore ({cmd:_}).  If
{cmd:rownames()} is not specified, {cmd:rowprefix()} defaults to {cmd:r}, and
to nothing otherwise. 

{phang}
{opt obs} specifies that the observation numbers be used as row names.
This option may not be combined with {cmd:rownames()}.

{phang}
{opt nchar(#)} specifies that row names be truncated to {it:#} characters,
1<={it:#}<=32.  The default is {cmd:nchar(32)}.

{phang}
{cmd:names(}{cmd:col}|{cmd:eqcol}|{cmd:matcol}|{it:{help strings:string}}{cmd:)}
specifies how the new variables are to be named.

{pmore}
{cmd:names(col)} uses the column names of the matrix to name the variables.

{pmore}
{cmd:names(eqcol)} uses the equation names prefixed to the column names.

{pmore}
{cmd:names(matcol)} uses the matrix name prefixed to the column names.

{pmore}
{cmd:names(}{it:string}{cmd:)} names the variables
    {it:string}{hi:1}, {it:string}{hi:2}, ..., {it:string}n, where {it:string}
    is a user-specified {it:string} and n is the number of columns of the
    matrix.

{pmore}
If {cmd:names()} is not specified, the variables are named
    {it:A}{hi:1}, {it:A}{hi:2}, ..., {it:An}, where {it:A} is the name of the
    matrix.

{phang}
{cmd:rows(}{it:range}{cmd:)} and {cmd:columns(}{it:range}{cmd:)}
specify the rows and columns of the matrix to rename.  The number of rows
or columns specified must be equal to the number of names in
{it:namelist}.  If both {cmd:rows()} and {cmd:columns()} are given, the
specified rows are named {it:namelist}, and the specified columns are also
named {it:namelist}.  The range must be given in one of the following forms:

{p 12 26 2}{cmd:rows(.)}{space 5}renames all the rows{p_end}
{p 12 26 2}{cmd:rows(2..8)}{space 2}renames rows 2 through 8{p_end}
{p 12 26 2}{cmd:rows(3)}{space 5}renames only row 3{p_end}
{p 12 26 2}{cmd:rows(4...)}{space 2}renames row 4 to the last row

{pmore}If neither {cmd:rows()} nor {cmd:columns()} is given,
    {cmd:rows(.)} {cmd:columns(.)} is the default.  That is, the matrix must
    be square, and both the rows and the columns are named {it:namelist}.

{phang}{cmd:explicit} suppresses the expansion of varlist abbreviations
and omits the verification that the names are those of existing variables.
That is, the names in {it:namelist} are used explicitly and can be any valid
row or column names.


{marker remarks}{...}
{title:Remarks on mkmat}

{pstd}
Although cross-products of variables can be loaded into a matrix with the
{helpb matrix accum} command, programmers may sometimes find it more
convenient to work with the variables in their datasets as vectors instead of
as cross-products.  {cmd:mkmat} allows the user a simple way to load specific
variables into matrices in Stata's memory.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Store {cmd:mpg} in column vector {cmd:mpg}{p_end}
{phang2}{cmd:. mkmat mpg}{p_end}

{pstd}List the contents of vector {cmd:mpg}{p_end}
{phang2}{cmd:. matrix list mpg}{p_end}

{pstd}Create matrix {cmd:X} with columns consisting of the values for
{cmd:foreign}, {cmd:weight}, and {cmd:displacement}{p_end}
{phang2}{cmd:. mkmat foreign weight displacement, matrix(X)}{p_end}

{pstd}List the contents of matrix {cmd:X}{p_end}
{phang2}{cmd:. matrix list X}{p_end}

{pstd}Create vector {cmd:b}{p_end}
{phang2}{cmd:. matrix b = invsym(X'*X) * X'*mpg}

{pstd}Run a linear regression{p_end}
{phang2}{cmd:. regress mpg foreign weight displacement, noconstant}{p_end}

{pstd}Create matrix {cmd:c} containing the transpose of the coefficient
vector{p_end}
{phang2}{cmd:. matrix c = e(b)'}{p_end}

{pstd}List the vectors {cmd:b} and {cmd:c}{p_end}
{phang2}{cmd:. matrix list b}{p_end}
{phang2}{cmd:. matrix list c}{p_end}

{pstd}Create matrix {cmd:D}, where the first column contains vector
{cmd:b}{p_end}
{phang2}{cmd:. matrix D = b, c}{p_end}

{pstd}List the contents of matrix {cmd:D}{p_end}
{phang2}{cmd:. matrix list D}{p_end}

{pstd}Save the columns of {cmd:D} as variables in the dataset with names
{cmd:reg1} and {cmd:reg2}{p_end}
{phang2}{cmd:. svmat D, names(reg)}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list make price reg1 reg2 in 1/5}

{pstd}Create vector {cmd:f} by appending vector {cmd:c} to the end of vector
{cmd:b}{p_end}
{phang2}{cmd:. matrix f = b\c}

{pstd}Rename row two of {cmd:f} "wgt", where "wgt" does not currently exist as
a variable{p_end}
{phang2}{cmd:. matname f wgt, rows(2) explicit}

{pstd}List the contents of vector {cmd:f}{p_end}
{phang2}{cmd:. matrix list f}


    {title:Correspondence analysis of indicator matrix}
    
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ca_smoking, clear}

{pstd}Create indicator variables {cmd:S1} and {cmd:S2} for
{cmd:smoking}{p_end}
{phang2}{cmd:. tab smoking, gen(S)}{p_end}

{pstd}Create indicator variables for {cmd:rank}{p_end}
{phang2}{cmd:. tab rank, gen(R)}{p_end}

{pstd}Create matrix {cmd:ISR} with columns consisting of the values of the
indicator variables{p_end}
{phang2}{cmd:. mkmat S* R*, matrix(ISR)}{p_end}

{pstd}List the contents of matrix {cmd:ISR}{p_end}
{phang2}{cmd:. mat list ISR}

{pstd}Perform simple correspondence analysis on {cmd:ISR}{p_end}
{phang2}{cmd:. camat ISR, dim(3)}{p_end}
