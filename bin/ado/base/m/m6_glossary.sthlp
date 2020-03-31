{smcl}
{* *! version 1.1.24  03may2019}{...}
{vieweralsosee "[M-6] Glossary" "mansection M-6 Glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-0] Intro" "help mata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Description" "m6_glossary##description"}{...}
{viewerjumpto "Mata glossary" "m6_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-6] Glossary} {hline 2}}Mata glossary of common terms
{p_end}
{p2col:}({mansection M-6 Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Commonly used terms are defined here.


{marker glossary}{...}
{title:Mata glossary}

{* index arguments, program}{...}
{p 4 8 2}
{bf:arguments}{break}
    The values a function receives are called the function's arguments.
    For instance, in {cmd:lud(}{it:A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:)},
    {it:A}, {it:L}, and {it:U} are the arguments.

{p 4 8 2}
{bf:array}{break}
    An array is any indexed object that holds other objects as elements.
    Vectors are examples of 1-dimensional arrays.  Vector {bf:v} is an
    array, and {bf:v}[1] is its first element.  Matrices are 2-dimensional
    arrays.  Matrix {bf:X} is an array, and {bf:X}[1,1] is its first element.
    In theory, one can have 3-dimensional, 4-dimensional, and higher arrays,
    although Mata does not directly provide them.  See
    {helpb m2_subscripts:[M-2] Subscripts} for more information on arrays
    in Mata.

{p 8 8 2}
    Arrays are usually indexed by sequential integers, but in associative
    arrays, the indices are strings that have no natural ordering.
    Associative arrays can be 1-dimensional, 2-dimensional, or higher.  If
    {it:A} were an associative array, then {it:A}["first"] might be one of its
    elements.  See {helpb mf_asarray:[M-5] asarray()} for associative arrays
    in Mata.

{marker binary_operator}{...}
{p 4 8 2}
{bf:binary operator}{break}
    A binary operator is an operator applied to two arguments.  In {cmd:2-3},
    the minus sign is a binary operator, as opposed to the minus sign in
    {cmd:-9}, which is a {help m6_glossary##unary_operator:unary operator}.

{* index type, broad}{...}
{* index broad type}{...}
{p 4 8 2}
{bf:broad type}{break}
     Two matrices are said to be of the same broad type if the 
     elements in each are numeric, are string, or are pointers.
     Mata provides two numeric types, real and complex.  The term 
     {it:broad type} is used to mask the distinction within numeric
     and is often used when discussing operators or functions.
     One might say, "The comma operator can be used to join the rows of two
     matrices of the same broad type," and the implication of that is that one
     could join a real to a complex.  The result would be complex.  Also see
     {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{* index c-conformability}{...}
{marker c-conformability}{...}
{p 4 8 2}
{bf:c-conformability}{break}
        Matrix, vector, or scalar {it:A} is said to be c-conformable with
        matrix, vector, or scalar {it:B} if they have the same number of rows
        and columns (they are 
	{help m6_glossary##p-conformability:{it:p-conformable}}),
	or if they have the same
        number of rows and one is a vector,
        or if they have the same number of columns and one is a vector,
        or if one
        or the other is a scalar.  c stands for colon; c-conformable matrices
        are suitable for being used with Mata's {cmd::}{it:op} operators.
        {it:A} and {it:B} are c-conformable if and only if

			A                B
                      {hline 22}
                      {it:r x c}            {it:r x c}

                      {it:r x} 1            {it:r x c}
                      1 {it:x c}            {it:r x c}
                      1 {it:x} 1            {it:r x c}

                      {it:r x c}            {it:r x} 1
                      {it:r x c}            1 {it:x c}
                      {it:r x c}            1 {it:x} 1
                      {hline 22}

{p 8 8 2}
        The idea behind c-conformability is generalized elementwise operation.
        Consider {it:C}={it:A}:*{it:B}.  If {it:A} and {it:B}
        have the same number of rows and have the same number of columns, then
        ||{it:C}_{it:ij}|| = ||{it:A}_{it:ij}*{it:B}_{it:ij}||.  Now say that
        {it:A} is a column vector and {it:B} is a matrix. Then 
        ||{it:C}_{it:ij}|| = ||{it:A}_{it:i}*{it:B}_{it:ij}||:  each element of
        {it:A} is applied to the entire row of {it:B}.  If {it:A}
        is a row vector, each column of {it:A} is applied to the entire column
        of {it:B}.  If {it:A} is a scalar, {it:A} is applied to every element
        of {it:B}.  And then all the rules repeat, with the roles of {it:A}
        and {it:B} interchanged.  See {bf:{help m2_op_colon:[M-2] op_colon}} for
        a complete definition.

{p 4 8 2}
{bf:class programming}{break}
   See {help m6_glossary##orprog:object-oriented programming}.

{p 4 8 2}
{bf:colon operators}{break}
    Colon operators are operators preceded by a colon, and the colon 
    indicates that the operator is to be performed elementwise.
    {it:A}{cmd::*}{it:B} indicates element-by-element multiplication, whereas 
    {it:A}{cmd:*}{it:B} indicates matrix multiplication.  Colons may be placed 
    in front of any operator.  Usually one thinks of elementwise as 
    meaning c_ij = a_ij <{it:op}> b_ij, but in Mata, elementwise is also 
    generalized to include c-conformability.

{p 4 8 2}
{bf:column stripes}{break}
    See {it:{help m6_glossary##stripes:row and column stripes}}.

{p 4 8 2}
{marker column-major}{...}
{bf:column-major order}{break}
    Matrices are stored as vectors.  Column-major order specifies 
    that the vector form of a matrix is created by stacking the columns.
    For instance,

	: A
	       1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  1   4  {c |}
	  2 {c |}  2   5  {c |}
	  3 {c |}  3   6  {c |}
	    {c BLC}{hline 9}{c BRC}

{p 8 8 2}
    is stored as 

	       1   2   3   4   5   6
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  1   2   3   4   5   6  {c |}
	    {c BLC}{hline 25}{c BRC}

{p 8 8 2}
    in column-major order.  The LAPACK functions use column-major order.
    Mata uses row-major order.  See 
    {it:{help m6_glossary##row-major:row-major order}}.

{p 4 8 2}
{bf:colvector}{break}
    See {it:{help m6_glossary##vector:vector, colvector, and rowvector}}.

{* index complex tt}{...}
{p 4 8 2}
{bf:complex}{break}
    A matrix is said to be complex if its elements are complex numbers.
    Complex is one of two numeric types in Stata, the other being real.
    Complex is generally used to describe how a matrix is 
    stored and not the kind of numbers that happen to be in it:  
    complex matrix {it:Z} might contain real numbers.
    Also see {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{* index condition number}{...}
{p 4 8 2}
{bf:condition number}{break}
    The condition number associated with a numerical problem is a measure of 
    that quantity's amenability to digital computation.  A problem with a low
    condition number is said to be well conditioned, whereas a problem with a
    high condition number is said to be ill conditioned.

{p 8 8 2}
    Sometimes reciprocals of condition numbers are reported and yet authors
    will still refer to them as condition numbers.  Reciprocal
    condition numbers are often scaled between 0 and 1, with values near
    epsilon(1) indicating problems.

{* index conformability}{...}
{* index conformability, also see c-conformability}{...}
{* index conformability, also see r-conformability}{...}
{* index conformability, also see p-conformability}{...}
{p 4 8 2}
{bf:conformability}{break}
    Conformability refers to row-and-column matching between two or more
    matrices.  For instance, to multiply A*B, A must have the same number of
    columns as B has rows.  If that is not true, then the matrices are said to
    be nonconformable (for multiplication).

{p 8 8 2}
    Three kinds of conformability are often mentioned in the Mata
    documentation:  {it:p-conformability}, {it:c-conformability}, and 
    {it:r-conformability}.

{* index conjugate}{...}
{p 4 8 2}
{bf:conjugate}{break}
    If {it:z} = {it:a} + {it:b}i, the conjugate of {it:z} is conj(z) = 
    {it:a} - {it:b}i.  The conjugate is obtained by reversing the sign 
    of the imaginary part.  The conjugate of a real number is 
    the number itself.

{* index conjugate transpose}{...}
{* index transpose, also see conjugate transpose}{...}
{p 4 8 2}
{bf:conjugate transpose}{break}
    See {it:{help m6_glossary##transpose:transpose}}.

{* index data matrix}{...}
{marker datamtx}{...}
{p 4 8 2}
{bf:data matrix}{break}
    A dataset containing {it:n} observations on {it:k} variables in 
    often stored in an {it:n x k} matrix.  An observation refers to a 
    row of that matrix; a variable refers to a column.
    When the rows are observations and the columns are variables, the matrix 
    is called a data matrix.

{* index declarations}{...}
{p 4 8 2}
{bf:declarations}{break}
    Declarations state the {it:eltype} and {it:orgtype} of functions, 
    arguments, and variables.  In 

		{cmd}real matrix myfunc(real vector A, complex scalar B)
		{
			real scalar i

			{txt}...{cmd}
		}{txt}

{p 8 8 2}
     the {cmd:real matrix} is a function declaration, the {cmd:real vector} 
     and {cmd:complex scalar} are argument declarations, and 
     {cmd:real scalar i} is a variable declaration.  The {cmd:real matrix} 
     states the function returns a real matrix.  The {cmd:real vector} 
     and {cmd:complex scalar} state the kind of arguments {cmd:myfunc()} 
     expects and requires.  The {cmd:real scalar i} helps Mata to produce 
     more efficient compiled code.

{p 8 8 2}
     Declarations are optional, so the above could just as well have read
     
		{cmd}function myfunc(A, B)
		{
			{txt}...{cmd}
		}{txt}

{p 8 8 2}
     When you omit the function declaration, you must substitute the word 
     {cmd:function}.

{p 8 8 2}
     When you omit the other declarations,
     {cmd:transmorphic matrix} is 
     assumed, which is fancy jargon for a matrix that can hold anything.  
     The advantages of explicit
     declarations are that they reduce the chances you make a mistake either in
     coding or in using the function, and they assist Mata in producing more
     efficient code.  Working interactively, most people omit the declarations.

{p 8 8 2}
     See {bf:{help m2_declarations:[M-2] Declarations}} for more information.

{* index defective matrix}{...}
{p 4 8 2}
{bf:defective matrix}{break}
    An {it:n x n} matrix is defective if it does not have {it:n} 
    linearly independent eigenvectors.

{p 4 8 2}
{bf:dereference}{break}
    Dereferencing is an action performed on pointers.  Pointers contain
    memory addresses, such as 0x2a1228.  One assumes something of interest
    is stored at 0x2a1228, say, a real scalar equal to 2.  When one accesses
    that 2 via the pointer by coding {cmd:*}{it:p}, one is said to be
    dereferencing the pointer.  Unary {cmd:*} is the dereferencing operator.

{* index diagonal matrix}{...}
{p 4 8 2}
{bf:diagonal matrix}{break}
    A matrix is diagonal if its off-diagonal elements are zero; {it:A} is
    diagonal if {it:A}[{it:i},{it:j}]==0 for {it:i}!={it:j}.  Usually,
    diagonal matrices are also {it:square}.  Some definitions require that a
    diagonal matrix also be a square matrix.

{* index diagonal}{...}
{p 4 8 2}
{bf:diagonal of a matrix}{break}
    The diagonal of a matrix is the set of elements {it:A}[{it:i},{it:j}].

{p 4 8 2}
{bf:dyadic operator}{break}
    Synonym for {help m6_glossary##binary_operator:binary operator}.

{* index eigenvalues}{...}
{marker eigenvalues}{...}
{p 4 8 2}
{bf:eigenvalues} and {bf:eigenvectors}{break}
    A scalar, {it:l} (usually denoted by {it:lambda}), is said to be an
    eigenvalue of square matrix {bf:A}: {it:n x n} if there is a nonzero 
    column vector {bf:x}: {it:n x} 1 (called an eigenvector) such that

			{bf:A}{bf:x} = {it:l}{bf:x}{right:(1)   }

{p 8 8 2}
Equation (1) can also be written as

			({bf:A} - {it:l}{bf:I}){bf:x} = 0

{p 8 8 2}
where {bf:I} is the {it:n x n} identity matrix. A nontrivial solution 
to this system of {it:n} linear homogeneous equations exists if and only if 

			det({bf:A} - {it:l}{bf:I}) = 0{right:(2)   }

{p 8 8 2}
This {it:n}th-degree polynomial in {it:l} is called the characteristic 
polynomial or characteristic equation of {bf:A}, and the eigenvalues {it:l}
are its roots, also known as the characteristic roots.

{p 8 8 2}
The eigenvector defined by (1) is also known as the right 
eigenvector, because matrix {bf:A} is postmultiplied by eigenvector 
{bf:x}.  See {bf:{help mf_eigensystem:[M-5] eigensystem()}} and
{it:{help m6_glossary##lefteigen:left eigenvectors}}.

{p 4 8 2}
{bf:eltype}{break}
    See {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{* index machine precision}{...}
{* index epsilon}{...}
{marker epsilon}{...}
{p 4 8 2}
{bf:epsilon(1)}, etc.{break}
epsilon(1) refers to the unit roundoff error associated with a computer, 
also informally called machine precision.  It is the smallest amount 
by which a number may differ from 1.  For IEEE double-precision variables, 
epsilon(1) is approximately 2.22045e-16.  

{p 8 8 2}
epsilon({it:x}{cmd:)} is the smallest amount by which a real number 
can differ from {it:x}, or an approximation thereof; see 
{bf:{help mf_epsilon:[M-5] epsilon()}}.

{* index exp it}{...}
{p 4 8 2}
{bf:exp}{break}
    {it:exp} is used in syntax diagrams to mean "any valid expression may 
    appear here"; see {bf:{help m2_exp:[M-2] exp}}.

{* index externals}{...}
{p 4 8 2}
{bf:external variable}{break}
    See {it:{help m6_glossary##globalvar:global variable}}.

INCLUDE help glossary_frames

{* index function}{...}
{p 4 8 2}
{bf:function}{break}
    The words program and function are used interchangeably.  The programs
    that you write in Mata are in fact functions.  Functions receive arguments
    and optionally return results.

{p 8 8 2}
    Examples of functions that are included with Mata are {cmd:sqrt()},
    {cmd:ttail()}, and {cmd:substr()}.  Such functions are often referred to as
    the built-in functions or the library functions.  Built-in functions refer
    to functions implemented in the C code that implements Mata, and library
    functions refer to functions written in the Mata programming language, but
    many users use the words interchangeably because how functions are
    implemented is of little importance.  If you have a choice between using a
    built-in function and a library function, however, the built-in function
    will usually execute more quickly and the library function will be
    easier to use.  Mostly, however, features are implemented one way or the
    other and you have no choice.

{p 8 8 2}
    Also see {it:{help m6_glossary##underscorefcns:underscore functions}}.

{p 8 8 2}
    For a list of the functions that Mata provides, see 
    {bf:{help m4_intro:[M-4] Intro}}.

{* index generalized eigenvalues}{...}
{marker geigenvalues}{...}
{p 4 8 2}
{bf:generalized eigenvalues}{break}

{p 8 8 2}
A scalar {it:l} (usually denoted by {it:lambda}) is said to be a
generalized eigenvalue of a pair of {it:n x n} square, numeric matrices
{bf:A}, {bf:B} if there is a nonzero column vector {bf:x}: {it:n x} 1
(called a generalized eigenvector) such that

		{bf:A}{bf:x} = {it:l}{bf:B}{bf:x}{right:(1)}

{p 8 8 2}
Equation (1) can also be written as

		({bf:A} - {it:l}{bf:B}){bf:x} = 0

{p 8 8 2}
A nontrivial solution to this system of {it:n} linear homogeneous equations
exists if and only if

		det({bf:A} - {it:l}{bf:B}) = 0 {right:    (2)}

{p 8 8 2}
In practice, the generalized eigenvalue problem for the matrix pair ({bf:A},
{bf:B}) is usually formulated as finding a pair of scalars ({it:w}, {it:b})
and a nonzero column vector {bf:x} such that

                {it:w}{bf:A}{bf:x} = {it:b}{bf:B}{bf:x}

{p 8 8 2}
The scalar {it:w}/{it:b} is a generalized eigenvalue if {it:b} is not zero.

{p 8 8 2}
Infinity is a generalized eigenvalue if {it:b} is zero or numerically close
to zero.  This situation may arise if {bf:B} is singular.

{p 8 8 2}
The Mata functions that compute generalized eigenvalues return them in two 
complex vectors, {bf:w} and {bf:b} of length {it:n}.  If
{bf:b}[{it:i}]=0, the {it:i}th generalized eigenvalue is infinite,
otherwise the {it:i}th generalized eigenvalue is   
{bf:w}[{it:i}]/{bf:b}[{it:i}].

{* index global variable}{...}
{marker globalvar}{...}
{p 4 8 2}
{bf:global variable}{break}
    Global variables, also known as external variables and as global external
    variables, refer to variables that are common across programs and which 
    programs may access without the variable being passed as an argument.  

{p 8 8 2}
    The variables you create interactively are global variables.  Even so, 
    programs cannot access those variables without engaging in another step, 
    and global variables can be created without your creating them
    interactively.

{p 8 8 2}
    To access (and create if necessary) global external variables, you 
    declare the variable in the body of your program:

		{cmd:function myfunction(}...{cmd})
		{
			external real scalar globalvar
		
			{txt}...{cmd}
		}{txt}

{p 8 8 2}
    See {bf:Linking to external globals} in 
    {bf:{help m2_declarations:[M-2] Declarations}}.

{p 8 8 2}
    There are other ways of creating and accessing global variables, but 
    the declaration method is recommended.  The alternatives are
    {cmd:crexternal()}, {cmd:findexternal()}, and {cmd:rmexternal()} 
    documented in {bf:{help mf_findexternal:[M-5] findexternal()}}
    and {cmd:valofexternal()} documented in 
    {bf:{help mf_valofexternal:[M-5] valofexternal()}}.

{p 4 8 2}
{bf:hashing}, {bf:hash functions}, and {bf:hash tables}{break}
    Hashing refers to a technique for quickly finding information
    corresponding to an identifier.  The identifier might be a name, a
    Social Security number, fingerprints, or anything else on which the
    information is said to be indexed.  The hash function returns a
    many-to-one mapping of identifiers onto a dense subrange of the integers.
    Those integers, called hashes, are then used to index a hash table.  The
    selected element of the hash table specifies a list containing identifiers
    and information.  The list is then searched for the particular identifier
    desired.  The advantage is that rather than searching a single large
    list, one need only search one of {it:K} smaller lists.  For this to be
    fast, the hash function must be quick to compute and produce roughly
    equal frequencies of hashes over the range of identifiers likely to
    be observed.

{* index Hermitian matrices}{...}
{marker hermitianmtx}{...}
{p 4 8 2}
{bf:Hermitian matrix}{break}
    Matrix {it:A} is Hermitian if it is equal to its conjugate transpose;
    {it:A}={it:A}{cmd:'}; see 
    {it:{help m6_glossary##transpose:transpose}}.
    This means that each off-diagonal element {it:a_ij} must equal the 
    conjugate of {it:a_ji} and that the diagonal elements must be real.  The 
    following matrix is Hermitian:

			{c TLC}            {c TRC}
			{c |}  2    4+5i {c |}
			{c |} 4-5i   6   {c |}
			{c BLC}            {c BRC}

{p 8 8 2}
    The definition {it:A}={it:A}{cmd:'} is the same as the
    definition for a symmetric matrix, although usually the word symmetric is
    reserved for real matrices and Hermitian, for complex matrices.  In this
    manual, we use the word symmetric for both; see
    {it:{help m6_glossary##symmetricmatrices:symmetric matrices}}.

{* index Hessenberg decomposition}{...}
{p 4 8 2}
{bf:Hessenberg decomposition}{break}
    The Hessenberg decomposition of a matrix, {bf:A}, can be written as

                {bf:Q}'{bf:A}{bf:Q} = {bf:H}

{p 8 8 2}
where {bf:H} is in upper {help m6_glossary##hessform:Hessenberg form} 
and {bf:Q} is orthogonal if {bf:A} is real or unitary if {bf:A} is 
complex.  See {bf:{help mf_hessenbergd:[M-5] hessenbergd()}}. 

{* index Hessenberg decomposition}{...}
{marker hessform}
{p 4 8 2}
{bf:Hessenberg form}{break}
    A matrix, {bf:A}, is in upper Hessenberg form if all entries below the 
    first subdiagonal are zero: {it:A_ij} = 0 for all {it:i} > {it:j}+1.

{p 8 8 2}
A matrix, {bf:A}, is in lower Hessenberg form if all entries above the
first superdiagonal are zero: {it:A_ij} = 0 for all {it:j} > {it:i}+1.

{marker instance}{...}
{p 4 8 2}
{bf:instance} and {bf:realization}{break}
    Instance and realization are synonyms for variable, as in
    {help m6_glossary##variable:Mata variable}.
    For instance, consider a real scalar variable {it:X}.  One can equally well
    say that {it:X} is an instance of a real scalar or a realization of a real
    scalar.  Authors represent a variable this way when they wish to emphasize
    that {it:X} is not representative of all real scalars but is just one of
    many real scalars.  Instance is often used with structures and classes
    when the writer wishes to emphasize the difference between the values
    contained in the variable and the definition of the structure or the
    class.  It is confusing to say that {it:V} is a class {it:C}, even though
    it is commonly said, because the reader might confuse the definition of
    {it:C} with the specific values contained in {it:V}.  Thus careful authors
    say that {it:V} is an instance of class {it:C}.

{* index istmt it}{...}
{p 4 8 2}
{bf:istmt}{break}
    An {it:istmt} is an interactive statement, a statement typed at
    Mata's colon prompt.  

{* index J()}{...}
{p 4 8 2}
{bf:J(r, c, value)}{break}
    {cmd:J()} is the function that returns an {it:r} {it:x} {it:c} matrix with
    all elements set to {it:value}; see 
    {bf:{help mf_j:[M-5] J()}}.  Also, {cmd:J()}
    is often used in the documentation to describe the various types of
    {it:void} matrices; see 
    {it:{help m6_glossary##voidmatrix:void matrix}}.  Thus the documentation
    might say that such-and-such returns {cmd:J(0, 0, .)} under certain
    conditions.  That is another way of saying that such-and-such returns a 0
    {it:x} 0 real matrix.

{p 8 8 2}
    When {it:r} or {it:c} is 0, there are no elements to be filled in with
    {it:value}, but even so, {it:value} is used to determine the type 
    of the matrix.  Thus {cmd:J(0, 0, 1i)} refers to a 0 {it:x} 0 complex
    matrix, {cmd:J(0, 0, "")} refers to a 0 {it:x} 0 string matrix, and 
    {cmd:J(0, 0, NULL)} refers to a 0 x 0 {it:pointer} matrix.

{p 8 8 2}
    In the documentation, {cmd:J()} is used for more than describing 0 {it:x} 0 
    matrices.  Sometimes, the matrices being described are {it:r} {it:x}
    0 or are 0 {it:x} {it:c}.  Say that a function {cmd:example(}{it:X}{cmd:)}
    is supposed to return a column vector; perhaps it returns the last 
    column of {it:X}.  Now say that {it:X} is 0 {it:x} 0.  Function 
    {cmd:example()} still should return a column vector, and so it 
    returns a 0 {it:x} 1 matrix.  This would be documented by noting that
    {cmd:example()} returns {cmd:J(0, 1, .)} when {it:X} is 0 {it:x} 0.

{* index LAPACK}{...}
{p 4 8 2}
{bf:LAPACK}{break}
    LAPACK stands for Linear Algebra PACKage and 
    forms the basis for many of Mata's linear algebra capabilities; 
    see {bf:{help m1_lapack:[M-1] LAPACK}}.

{* index left eigenvector}{...}
{marker lefteigen}{...}
{p 4 8 2}
{bf:left eigenvectors}{break}
    A vector {bf:x}: {it:n x} 1 is said to be a left eigenvector of square 
    matrix {bf:A}: {it:n x n} if there is a nonzero scalar, {it:l} 
    (usually denoted by {it:lambda}), such that

			{bf:x}{bf:A} = {it:l}{bf:x}

{p 8 8 2}
See {it:{help m6_glossary##eigenvalues:eigenvalues and eigenvectors}}.

{* index lval it}{...}
{p 4 8 2}
{bf:lval}{break}
    {it:lval} stands for left-hand-side value and is defined as the property
    of being able to appear on the left-hand side of an equal-sign
    assignment operator.  Matrices are {it:lvals} in Mata, and thus

		{cmd:X =} ...

{p 8 8 2}
    is valid.  Functions are not {it:lvals}; thus, you cannot 
    code 

		{cmd:substr(mystr,1,3) = "abc"}

{p 8 8 2}
    {it:lvals} would be easy to describe except that {it:pointers} can also
    be lvals.  Few people ever use pointers.  See 
    {bf:{help m2_op_assignment:[M-2] op_assignment}} for a complete definition.

{* index machine precision}{...}
{p 4 8 2}
{bf:machine precision}{break}
    See {it:{help m6_glossary##epsilon:epsilon(1), etc.}}

{* index .mata file}{...}
{p 4 8 2}
{bf:.mata source code file}{break}
    By convention, we store the Mata source code for function 
    {it:function()} in file {it:function}{cmd:.mata}; see 
    {bf:{help m1_source:[M-1] Source}}.

{* index matrix}{...}
{p 4 8 2}
{bf:matrix}{break}
    The most general organization of data, containing {it:r} rows and {it:c}
    columns.  Vectors, column vectors, row vectors, and scalars are special
    cases of matrices.

{* index .mlib library files}{...}
{p 4 8 2}
{bf:.mlib library}{break}
    The object code of functions can be collected and stored in a 
    library.  Most Mata functions, in fact, are located in the official 
    libraries provided with Stata.  You can create your own libraries.
    See {bf:{help m1_how:[M-1] How}} and {bf:{help mata_mlib:[M-3] mata mlib}}.

{* index .mo file}{...}
{p 4 8 2}
{bf:.mo file}{break}
    The object code of a function can be stored in a {cmd:.mo} file, where it 
    can be later reused.  See {bf:{help m1_how:[M-1] How}} and 
    {bf:{help mata_mosave:[M-3] mata mosave}}.

{p 4 8 2}
{bf:monadic operator}{break}
    Synonym for {help m6_glossary##unary_operator:unary operator}.

{p 4 8 2}
{bf:NaN}{break}
    NaN stands for Not a Number and is a special computer floating-point code
    used for results that cannot be calculated.  Mata (and Stata) do not use
    NaNs.  When NaNs arise, they are converted into {cmd:.} (missing value).

{* index norm}{...}
{marker norm}{...}
{p 4 8 2}
{bf:norm}{break}
A norm is a real-valued function f({it:x}) satisfying 

			f(0)   =  0 

			f({it:x})   >  0         for all  {it:x} != 0

			f({it:c}{it:x})  =  |{it:c}|*f({it:x})

			f({it:x}+{it:y}) <= f({it:x}) + f({it:y})

{p 8 8 2}
The word norm applied to a vector {it:x} usually refers to its 
Euclidean norm, {it:p}=2 norm, or length:  the square root of the sum of its 
squared elements.  The are other norms, the popular ones being {it:p}=1 (the
sum of the absolute values of its elements) and {it:p}=infinity (the maximum
element).  Norms can also be generalized to deal with matrices.  
See {bf:{help mf_norm:[M-5] norm()}}.

{* index NULL tt}{...}
{p 4 8 2} 
{bf:NULL}{break}
    A special value for a {it:pointer} that means "points to nothing".  If you
    list the contents of a pointer variable that contains NULL, the address
    will show as 0x0.  See {it:{help m6_glossary##pointer:pointer}}.

{* index numeric tt}{...}
{p 4 8 2}
{bf:numeric}{break}
    A matrix is said to be numeric if its elements are real or complex;
    see {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{* index object code}{...}
{p 4 8 2}
{bf:object code}{break}
    Object code refers to the binary code that Mata produces from the 
    source code you type as input.  See {bf:{help m1_how:[M-1] How}}.

{p 4 8 2}
{marker orprog}{...}
{bf:object-oriented programming}{break}
    Object-oriented programming is a programming concept that treats
    programming elements as objects and concentrates on actions affecting
    those objects rather than merely on lists of instructions.  Object-oriented
    programming uses classes to describe objects.  Classes are much
    like structures with a primary difference being that classes can contain
    functions (known as methods) as well as variables.  Unlike structures,
    however, classes may inherit variables and functions from other classes,
    which in theory makes object-oriented programs easier to extend and modify
    than non-object-oriented programs.

{p 4 8 2}
{bf:observations and variables}{break}
    A dataset containing {it:n} observations on {it:k} variables in 
    often stored in an {it:n x k} matrix.  An observation refers to a 
    row of that matrix; a variable refers to a column.

{p 4 8 2}
{bf:operator}{break}
    An operator is {cmd:+}, {cmd:-}, and the like.  Most operators are binary
    (or dyadic), such as {cmd:+} in {it:A}{cmd:+}{it:B} and {cmd:*} in
    {it:C}{cmd:*}{it:D}.  Binary operators also include logical operators
    such as {cmd:&} and {cmd:|} ("and" and "or") in {it:E}{cmd:&}{it:F} and
    {it:G}{cmd:|}{it:H}.  Other operators are
    unary (or monadic), such as {cmd:!} (not) in {cmd:!}{it:J}, or both unary
    and binary, such as {cmd:-} in {cmd:-}{it:K} and in {it:L}{cmd:-}{it:M}.
    When we say "operator" without specifying which, we mean binary
    operator.  Thus colon operators are in fact colon binary operators.

{* index optimization}{...}
{p 4 8 2}
{bf:optimization}{break}
    Mata compiles the code that you write.  After compilation, Mata 
    performs an {it:optimization} step, the purpose of which is to make 
    the compiled code execute more quickly.  You can turn off the optimization
    step -- see {bf:{help mata_set:[M-3] mata set}} -- but doing so is not 
    recommended.  

{p 4 8 2}
{bf:orgtype}{break}
    See {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{* index orthogonal matrix}{...}
{* index unitary matrix}{...}
{marker orthomtx}{...}
{p 4 8 2}
{bf:orthogonal matrix} and {bf:unitary matrix}{break}
    {it:A} is orthogonal if {it:A} is {it:square} and
    {it:A}{bf:'}{it:A}=={it:I}.
    The word orthogonal is usually reserved for real matrices; 
    if the matrix is complex, it is said to be unitary (and then 
    transpose means conjugate-transpose).  We use the word orthogonal
    for both real and complex matrices.

{p 8 8 2}
    If {it:A} is orthogonal, then det({it:A}) == +/- 1.

{* index p-conformability}{...}
{marker p-conformability}{...}
{p 4 8 2}
{bf:p-conformability}{break}
        Matrix, vector, or scalar {it:A} is said to be p-conformable with
        matrix, vector, or scalar {it:B} if rows({it:A})==rows({it:B}) and
        cols({it:A})==cols({it:B}).  p stands for plus; p-conformability is
        one of the properties necessary to be able to add matrices together.
	p-conformability, however, does not imply that the matrices are of the
	same type.  Thus (1,2,3) is p-conformable with (4,5,6) and with
	("this","that","what") but not with (4\5\6).

{* index permutation vector}{...}
{* index permutation matrix}{...}
{marker permutation_matrix}{...}
{marker permutation_vector}{...}
{p 4 8 2}
{bf:permutation matrix} and {bf:permutation vector}{break}
    A {it:permutation matrix} is an {it:n x n} matrix that is a row (or column)
    permutation of the identity matrix.  If {it:P} is a permutation matrix, 
    then {it:P}{cmd:*}{it:A} permutes the rows of {it:A} and 
    {it:A}{cmd:*}{it:P} permutes the columns of {it:A}.  Permutation matrices
    also have the property that {it:P}^(-1) = {it:P}{bf:'}.
    
{p 8 8 2}
    A {it:permutation vector} is a 1 {it:x} {it:n} or {it:n} {it:x} 1 
    vector that contains a permutation of the integers 1, 2, ..., {it:n}.
    Permutation vectors can be used with subscripting to reorder the rows or
    columns of a matrix.  Permutation vectors are a memory-conserving way of
    recording permutation matrices; see 
    {bf:{help m1_permutation:[M-1] Permutation}}.

{* index pointers}{...}
{marker pointer}{...}
{p 4 8 2}
{bf:pointer}{break}
    A matrix is said to be a pointer matrix if its elements are pointers.

{p 8 8 2}
    A pointer is the address of a {it:variable}.  Say that variable
    {it:X} contains a matrix.  Another variable {it:p} might contain
    137,799,016 and, if 137,799,016 were the address at which {it:X} were
    stored, then {it:p} would be said to point to {it:X}.  Addresses are
    seldom written in base 10, and so rather than saying {it:p} contains
    137,799,016, we would be more likely to say that {it:p} contains
    0x836a568, which is the way we write numbers in base 16.  Regardless of
    how we write addresses, however, {it:p} contains a number and that number
    corresponds to the address of another variable.

{p 8 8 2}
    In our program, if we refer to {it:p}, we are referring to {it:p}'s
    contents, the number 0x836a568.  The monadic operator {it:*} is 
    defined as "refer to the address" or "dereference":  {cmd:*}{it:p}
    means {it:X}.  We could code {cmd:Y = *p} or {cmd:Y = X}, and either way,
    we would obtain the same result.  In our program, we could refer to
    {it:X}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} or
    {cmd:(*}{it:p}{cmd:)[}{it:i}{cmd:,}{it:j}{cmd:]}, and either way, we would
    obtain the {it:i}, {it:j} element of {it:X}.

{p 8 8 2}
    The monadic operator {it:&} is how we put addresses into {it:p}.
    To load {it:p} with the address of {it:X}, we code {it:p} {cmd:=} 
    {cmd:&}{it:X}.

{p 8 8 2}
    The special address 0 (zero, written in hexadecimal as 0x0), 
    also known as NULL, is how we record that a pointer variable 
    points to nothing.  A pointer variable contains NULL or it 
    contains a valid address of another variable.

{p 8 8 2}
    See {bf:{help m2_pointers:[M-2] pointers}} for a complete description of 
    pointers and their use.

{* index pragma tt}{...}
{p 4 8 2}
{bf:pragma}{break}
   "(Pragmatic information) A standardized form of comment which has meaning to
   a compiler. It may use a special syntax or a specific form within the
   normal comment syntax. A pragma usually conveys non-essential information,
   often intended to help the compiler to optimize the program." -- 
   {it:The Free On-line Dictionary of Computing}, 
   {browse "http://foldoc.org"}, Editor Denis Howe.
   For Mata, see {bf:{help m2_pragma:[M-2] pragma}}.

{* index rank}{...}
{p 4 8 2}
{bf:rank}{break}
    Terms in common use are rank, row rank, and column rank.  The row rank of
    a matrix {it:A}: {it:m} {it:x} {it:n} is the number of rows of {it:A} that
    are linearly independent.  The column rank is defined similarly, as the
    number of columns that are linearly independent.  The terms row rank and
    column rank, however, are used merely for emphasis; the ranks are equal
    and the result is simply called the rank of A.

{p 8 8 2}
    For a square matrix {it:A} (where {it:m}=={it:n}),
    the matrix is invertible if and only if rank({it:A})=={it:n}.  One often
    hears that A is of full rank in this case and rank deficient in the
    other.  See {bf:{help mf_rank:[M-5] rank()}}.

{* index r-conformability}{...}
{marker r-conformability}{...}
{p 4 8 2}
{bf:r-conformability}{break}
       A set of two or more matrices, vectors, or scalars {it:A}, {it:B}, 
       ..., are said to be r-conformable if each is {it:c-conformable} with 
       a matrix of max(rows({it:A}), rows({it:B}), ...) rows and 
       max(cols({it:A}), cols({it:B}), ...) columns.

{p 8 8 2}
       r-conformability is a more relaxed form of {it:c-conformability} in that, 
       if two matrices are c-conformable, they are r-conformable, but 
       not vice versa.  For instance, {it:A}: 1 {it:x} 3 and 
       {it:B}: 3 {it:x} 1 are r-conformable but not c-conformable.
       Also, {help m6_glossary##c-conformability:c-conformability}
       is defined with respect to a pair 
       of matrices only; r-conformability can be applied to a set of
       matrices.

{p 8 8 2}
       r-conformability is often required of the arguments for functions that
       would otherwise naturally be expected to require scalars.  
       See {bf:r-conformability} in {bf:{help mf_normal:[M-5] normal()}}
       for an example.

{* index real tt}{...}
{p 4 8 2}
{bf:real}{break}
    A matrix is said to be a real matrix if its elements are all reals
    and it is stored in a {cmd:real} matrix.  
    Real is one of the two numeric types in Mata, the other being 
    complex.  Also see {it:{help m6_glossary##type:type, eltype, and orgtype}}.

{p 4 8 2}
{marker stripes}{...}
{bf:row and column stripes}{break}
    Stripes refer to the labels associated with the rows and columns
    of a Stata matrix; see
    {it:{help m6_glossary##Stata_matrix:Stata matrix}}.

{p 4 8 2}
{marker row-major}{...}
{bf:row-major order}{break}
    Matrices are stored as vectors.  Row-major order specifies that the
    vector form of a matrix is created by stacking the rows.  For
    instance,

	: A
	       1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  1   2   3  {c |}
	  2 {c |}  4   5   6  {c |}
	    {c BLC}{hline 13}{c BRC}

{p 8 8 2}
    is stored as 

	       1   2   3   4   5   6
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  1   2   3   4   5   6  {c |}
	    {c BLC}{hline 25}{c BRC}

{p 8 8 2}
    in row-major order.  Mata uses row-major order.  The
    LAPACK functions use column-major order.  See
    {it:{help m6_glossary##column-major:column-major order}}.

{p 4 8 2}
{bf:rowvector}{break}
    See {it:{help m6_glossary##vector:vector, colvector, and rowvector}}.

{* index scalar tt}{...}
{p 4 8 2}
{bf:scalar}{break}
    A special case of a {it:matrix} with one row and one column.  
    A scalar may be substituted anywhere a matrix, vector, column vector, or
    row vector is required, but not vice versa.

{* index schur decomposition tt}{...}
{marker schurdecomp}{...}
{p 4 8 2}
{bf:Schur decomposition}{break}
    The Schur decomposition of a matrix, {bf:A}, can be written as

                {bf:Q}'{bf:A}{bf:Q} = {bf:T}

{p 8 8 2}
where {bf:T} is in {help m6_glossary##schurform:Schur form} and {bf:Q}, 
the matrix of Schur vectors, is orthogonal if {bf:A} is real or unitary 
if {bf:A} is complex.  See {bf:{help mf_schurd:[M-5] schurd()}}.

{* index schur form tt}{...}
{marker schurform}{...}
{p 4 8 2}
{bf:Schur form}{break}

{p 8 8 2}
There are two Schur forms: real Schur form and complex Schur form.

{p 8 8 2}
A real matrix is in Schur form if it is block upper triangular with 1 {it:x} 1
and 2 {it:x} 2 diagonal blocks.  Each 2 {it:x} 2 diagonal block has equal
diagonal elements and opposite sign off-diagonal elements.  The real
eigenvalues are on the diagonal, and complex eigenvalues can be obtained from
the 2 {it:x} 2 diagonal blocks.

{p 8 8 2}
A complex, square matrix is in Schur form if it is upper triangular with the
eigenvalues on the diagonal.

{* index source code}{...}
{p 4 8 2}
{bf:source code}{break}
    Source code refers to the human-readable code that you type into 
    Mata to define a function.  Source code is compiled into object 
    code, which is binary.  See {bf:{help m1_how:[M-1] How}}.

{* index square matrix}{...}
{p 4 8 2}
{bf:square matrix}{break}
    A matrix is square if it has the same number of rows and columns.
    A 3 {it:x} 3 matrix is square; a 3 {it:x} 4 matrix is not.

{marker Stata_matrix}{...}
{p 4 8 2}
{bf:Stata matrix}{break}
    Stata itself, separate from Mata, has matrix capabilities.
    Stata matrices are separate from those of Mata, although
    Stata matrices can be gotten from and put into Mata matrices;
    see {helpb mf_st_matrix:[M-5] st_matrix()}.  Stata matrices are described in
    {manhelp matrix P} and {findalias frmatexp}.

{p 8 8 2}
    Stata matrices are exclusively numeric and contain real elements only.
    Stata matrices also differ from Mata matrices in that, in addition
    to the matrix itself, a Stata matrix has text labels on the rows and
    columns.  These labels are called row stripes and column stripes.
    One can think of rows and columns as having names.  The purpose of these
    names is discussed in {findalias frmatrow}.  Mata matrices
    have no such labels.  Thus three steps are required to get or to
    put all the information recorded in a Stata matrix:  1) getting or
    putting the matrix itself; 2) getting or putting the row stripe from or
    into a string matrix; and 3) getting or putting the column stripe
    from or into a string matrix.  These steps are discussed in
    {helpb mf_st_matrix:[M-5] st_matrix()}.

{* index string}{...}
{p 4 8 2}
{bf:string}{break}
    A matrix is said to be a string matrix if its elements are strings (text); 
    see {it:{help m6_glossary##type:type, eltype, and orgtype}}.
    In Mata, a string may be text or binary and may be up to 
    2,147,483,647 characters (bytes) long.

{* index structure}{...}
{p 4 8 2}
{bf:structure}{break}
    A structure is an {it:eltype}, indicating a set of variables tied 
    together under one name. 
    {cmd:struct} {cmd:mystruct} might be 

		{cmd}struct mystruct {c -(}
			real scalar     n1, n2
			real matrix     X
		{c )-}{txt}

{pmore}
    If variable {cmd:a} was declared a {cmd:struct} {cmd:mystruct}
    {cmd:scalar},  then the scalar {cmd:a} would contain three pieces: 
    two real scalars and one real matrix.  The pieces would be referred to as
    {cmd:a.n1}, {cmd:a.n2}, and {cmd:a.X}.  If variable {cmd:b} 
    were also declared a {cmd:struct} {cmd:mystruct} {cmd:scalar}, 
    it too would contain three pieces, {cmd:b.n1}, {cmd:b.n2}, and {cmd:b.X}.
    The advantage of structures is that they can be referred to as a whole.
    You can code {cmd:a.n1=b.n1} to copy one piece, or you can code
    {cmd:a=b} if you wanted to copy all three pieces.  In all ways, {cmd:a}
    and {cmd:b} are variables.  You may pass {cmd:a} to a subroutine, for
    instance, which amounts to passing all three values.

{pmore}
    Structures variables are usually scalar, but they are not limited to being
    so.  If {cmd:A} were a {cmd:struct} {cmd:mystruct} {cmd:matrix}, then each
    element of {cmd:A} would contain three pieces, and one could refer, for
    instance, to {cmd:A[2,3].n1}, {cmd:A[2,3].n2}, and {cmd:A[2,3].X}, and
    even to {cmd:A[2,3].X[3,2]}.

{pmore}
    See {bf:{help m2_struct:[M-2] struct}}.
  
{* index subscripts}{...}
{* index range subscripts, see subscripts}{...}
{* index list subscripts, see subscripts}{...}
{p 4 8 2}
{bf:subscripts}{break}
    Subscripts are how you refer to an element or even a submatrix of a matrix.

{p 8 8 2}
     Mata provides two kinds of subscripts, known as list subscripts and 
     range subscripts.

{p 8 8 2}
    In list subscripts, {it:A}{cmd:[2,3]} refers to the (2,3) element 
    of {it:A}.  {it:A}{cmd:[(2\3), (4,6)]} refers to the submatrix made up 
    of the second and third rows, fourth and sixth columns, of {it:A}.

{p 8 8 2}
    In range subscripts, {it:A}{cmd:[|2,3|]} also refers to the (2,3)
    element of {it:A}.  {it:A}{cmd:[|2,3\4,6|]} refers to the submatrix 
    beginning at the (2,3) element and ending at the (4,6) element.

{p 8 8 2}
    See {bf:{help m2_subscripts:[M-2] Subscripts}} for more information.

{* index symmetric matrices}{...}
{marker symmetricmatrices}
{p 4 8 2}
{bf:symmetric matrices}{break}
    Matrix {it:A} is symmetric if {it:A}={it:A}{bf:'}.  The word symmetric
    is usually reserved for real matrices, and in that case, a 
    symmetric matrix is a square matrix with 
    {it:a_ij}=={it:a_ji}.

{p 8 8 2}
    Matrix {it:A} is said to be Hermitian if {it:A}={it:A}{bf:'}, where 
    the transpose operator is understood to mean the conjugate-transpose 
    operator; see {it:{help m6_glossary##hermitianmtx:Hermitian matrix}}.  In
    Mata, the {bf:'} operator is the conjugate-transpose operator, and thus, in
    this manual, we will use the word symmetric both to refer to real,
    symmetric matrices and to refer to complex, Hermitian matrices.

{p 8 8 2}
    Sometimes, you will see us follow the word symmetric with a parenthesized
    Hermitian, as in, "the resulting matrix is symmetric (Hermitian)".  
    That is done only for emphasis.

{p 8 8 2}
    The inverse of a symmetric (Hermitian) matrix is symmetric (Hermitian).

{* index symmetriconly}{...}
{marker symmetriconly}{...}
{p 4 8 2}
{bf:symmetriconly}{break}
    Symmetriconly is a word we have coined to refer to a square matrix 
    whose corresponding off-diagonal elements are equal to each other, 
    whether the matrix is real or complex.  Symmetriconly matrices have 
    no mathematical significance, but sometimes, in data-processing and 
    memory-management routines, it is useful to be able to distinguish 
    such matrices.

{* index stata time-series--operated variable}{...}
{* index stata op.varname, see time-series--operated variable}{...}
{p 4 8 2}
{bf:time-series-operated variable}{break}
    Time-series-operated variables are a Stata concept.  The term refers to
    {it:op}{cmd:.}{it:varname} combinations such as {cmd:L.gnp} to mean the
    lagged value of variable {cmd:gnp}.  Mata's 
    {bf:{help mf_st_data:[M-5] st_data()}} function works with
    time-series-operated variables just as it works with other variables, but
    many other Stata-interface functions do not allow {it:op}{cmd:.}{it:varname}
    combinations.  In those cases, you must use 
    {bf:{help mf_st_tsrevar:[M-5] st_tsrevar()}}.

{p 4 8 2}
{bf:titlecase}{break}
     Titlecasing is a Unicode concept implemented in Mata in the
     {helpb mf_ustrupper:ustrtitle()} function.  To "titlecase" a phrase means
     to convert to Unicode titlecase the first letter of each Unicode word.
     This is almost, but not exactly, like capitalizing the first letter of
     each Unicode word.  Like capitalization, titlecasing letters is
     locale-dependent, which means that the same letter might have different
     titlecase forms in different locales.  In some locales, the titlecase
     form of a letter is different than the capital form of that same letter.
     For example, in some locales, capital letters at the beginning of words
     are not supposed to have accents on them, even if that capital letter by
     itself would have an accent.
    
{* index traceback log}{...}
{p 4 8 2}
{bf:traceback log}{break}
    When a function fails -- either because of a programming error or because
    it was used incorrectly -- it produces a traceback log:

		: {cmd:myfunction(2,3)}
			     {err}solve():  3200  conformability error
		             mysub():     -  function returned error
		        myfunction():     -  function returned error
		             <istmt>:     -  function returned error{txt}
		r(3200);

{p 8 8 2}
    The log says that {cmd:solve()} detected the problem -- arguments are 
    not conformable -- and that {cmd:solve()} was called by {cmd:mysub()} was
    called by {cmd:myfunction()} was called by what you typed at the keyboard.
    See {bf:{help m2_errors:[M-2] Errors}} for more information.

{* index transmorphic}{...}
{marker transmorphic}{...}
{p 4 8 2}
{bf:transmorphic}{break}
    Transmorphic is an {it:eltype}.  A scalar, vector, or matrix can be
    transmorphic, which indicates that its elements may be real, complex,
    string, pointer, or even a structure.  The elements are all the same
    type; you are just not saying which they are.  Variables that are not
    declared are assumed to be transmorphic, or a variable can be explicitly
    declared to be {cmd:transmorphic}.  Transmorphic is just fancy jargon for
    saying that the elements of the scalar, vector, or matrix can be anything
    and that, from one instant to the next, the scalar, vector, or matrix
    might change from holding elements of one type to elements of another.

{pmore}
    See {bf:{help m2_declarations:[M-2] Declarations}}.

{p 4 8 2}
{marker transpose}{...}
{bf:transpose}{break}
    The transpose operator is written different ways in different books, 
    including {bf:'}, superscript {it:*}, superscript {it:T}, 
    and superscript {it:H}.  Here we use the {bf:'} notation:  
    {it:A}{bf:'} means the transpose of {it:A}, {it:A} with its rows 
    and columns interchanged.  

{p 8 8 2}
    In complex analysis, the transpose operator, however it is written, is
    usually defined to mean the conjugate transpose; that is, one interchanges
    the rows and columns of the matrix and then one takes the conjugate of
    each element, or one does it in the opposite order -- it makes no
    difference.  Conjugation simply means reversing the sign of the imaginary
    part of a complex number:  the conjugate of 1+2i is 1-2i.  The conjugate
    of a real is the number itself; the conjugate of 2 is 2.

{p 8 8 2}
    In Mata, {cmd:'} is defined to mean conjugate transpose.
    Since the conjugate of a real is the number itself, {it:A}{cmd:'} 
    is regular transposition when {it:A} is real.  Similarly, we have 
    defined {it:'} so that it performs regular transposition for string and
    pointer matrices.  For complex matrices, however, {cmd:'} also performs
    conjugation.

{p 8 8 2}
    If you have a complex matrix and simply want to transpose it without 
    taking the conjugate of its elements, see 
    {bf:{help mf_transposeonly:[M-5] transposeonly()}}.
    Or code {cmd:conj(}{it:A}{cmd:')}.  The extra {cmd:conj()} will undo 
    the undesired conjugation performed by the transpose operator.

{p 8 8 2}
    Usually, however, you want transposition and conjugation to 
    go hand in hand.  Most mathematical formulas, generalized to complex
    values, work that way.

{* index triangular matrix}{...}
{* index lower triangular matrix, see triangular matrix}{...}
{* index upper triangular matrix, see triangular matrix}{...}
{p 4 8 2}
{bf:triangular matrix}{break}
    A triangular matrix is a matrix with all elements equal to zero above the
    diagonal or all elements equal to zero below the diagonal.

{p 8 8 2}
    A matrix {it:A} is {it:lower triangular} if all elements are zero above
    the diagonal, that is, if {it:A}[{it:i},{it:j}]==0, {it:j}>{it:i}.

{p 8 8 2}
    A matrix {it:A} is {it:upper triangular} if all elements are zero below
    the diagonal, that is, if {it:A}[{it:i},{it:j}]==0, {it:j}<{it:i}.

{p 8 8 2}
    A {it:diagonal matrix} is both lower and upper triangular.  That is worth
    mentioning because any function suitable for use with triangular matrices
    is suitable for use with diagonal matrices.

{p 8 8 2}
    A triangular matrix is usually {it:square}.

{p 8 8 2}
    The inverse of a triangular matrix is a triangular matrix.  The
    determinant of a triangular matrix is the product of the diagonal
    elements.  The eigenvalues of a triangular matrix are the diagonal
    elements.

{* index eltype it}{...}
{* index orgtype it}{...}
{* index type it}{...}
{marker type}{...}
{p 4 8 2}
{bf:type}, {bf:eltype}, and {bf:orgtype}{break}
    The {it:type} of a matrix (or vector or scalar) is formally defined as the
    matrix's {it:eltype} and {it:orgtype}, listed one after the other -- such
    as {cmd:real} {cmd:vector} -- but it can also mean just one or the other
    -- such as the {it:eltype} {cmd:real} or the {it:orgtype} {cmd:vector}.

{p 8 8 2}
    {it:eltype} refers to the type of the elements.  The {it:eltypes} are

	    {cmd:real}            numbers such as 1, 2, 3.4
	    {cmd:complex}         numbers such as 1+2i, 3+0i 
	    {cmd:string}          strings such as "bill"
	    {cmd:pointer}         pointers such as {cmd:&}{it:varname}
	    {cmd:struct}          structures 

            {cmd:numeric}         meaning {cmd:real} or {cmd:complex}
            {cmd:transmorphic}    meaning any of the above
	
{p 8 8 2}
    {it:orgtype} refers to the organizational type.
    {it:orgtype} specifies how the elements are organized.  The {it:orgtypes}
    are

	    {cmd:matrix}        two-dimensional arrays
	    {cmd:vector}        one-dimensional arrays
	    {cmd:colvector}     one-dimensional column arrays
	    {cmd:rowvector}     one-dimensional row arrays
	    {cmd:scalar}        single items

{p 8 8 2}
    The fully specified type is the element and organization types combined,
    as in {cmd:real} {cmd:vector}.

{marker unary_operator}{...}
{p 4 8 2}
{bf:unary operator}{break}
    A unary operator is an operator applied to one argument. In {cmd:-2}, the
    minus sign is a unary operator.  In
    {cmd:!(}{it:a}{cmd:==}{it:b} {cmd:|} {it:a}{cmd:==}{it:c}{cmd:)},
    {cmd:!} is a unary operator.

{* index underscore functions}{...}
{* index functions, underscore}{...}
{marker underscorefcns}{...}
{p 4 8 2}
{bf:underscore functions}{break}
    {it:Functions} whose names start with an underscore are called 
    underscore functions, and when an underscore function exists, 
    usually a function without the underscore prefix also exists.
    In those cases, the function is usually implemented in terms of the 
    underscore function, and the underscore function is harder 
    to use but is faster or provides greater control.  Usually, the 
    difference is in the handling of errors.

{p 8 8 2}
    For instance, function {cmd:fopen()} opens a file.  If the file does not
    exist, execution of your program is aborted.  Function {cmd:_fopen()} does
    the same thing, but if the file cannot be opened, it returns a special 
    value indicating failure, and it is the responsibility of your program to
    check the indicator and to take the appropriate action.  This can be
    useful when the file might not exist, and if it does not, you wish to take
    a different action.  Usually, however, if the file does not exist,
    you will wish to abort, and use of {cmd:fopen()} will allow you to write
    less code.

{p 4 8 2}
{bf:unitary matrix}{break}
    See {it:{help m6_glossary##orthomtx:orthogonal matrix}}.

{marker utf8}{...}
{phang}
{bf:UTF-8}{break}
   UTF-8 is the way of encoding Unicode characters chosen by Stata for its
   strings.  It is backward compatible with ASCII encoding in the sense that
   plain ASCII characters are encoded the same in UTF-8 as in ASCII and that
   strings are still null terminated.  Characters beyond plain ASCII are
   encoded using two to four bytes per character.  As with other Unicode
   encodings, all possible Unicode characters (code points) can be represented
   by UTF-8.

{* index variable}{...}
{marker variable}{...}
{p 4 8 2}
{bf:variable}{break}
    In a program, the entities that store values ({it:a}, {it:b}, {it:c}, ...,
    {it:x}, {it:y}, {it:z}) are called variables.  Variables are given names
    of 1 to 32 characters long.  To be terribly formal about it: a
    variable is a container; it contains a matrix, vector, or scalar and is
    referred to by its variable name or by another variable containing a
    {it:pointer} to it.

{p 8 8 2}
    Also, {it:variable} is sometimes used to refer to columns of
    data matrices; see {it:{help m6_glossary##datamtx:data matrix}}.

{* index vector tt}{...}
{* index rowvector tt}{...}
{* index colvector tt}{...}
{marker vector}{...}
{p 4 8 2}
{bf:vector}, {bf:colvector}, and {bf:rowvector}{break}
    A special case of a matrix with either one row or one column.  A vector
    may be substituted anywhere a matrix is required.  A matrix, however, may
    not be substituted for a vector.  

{p 8 8 2}
    A {cmd:colvector} is a vector with one column.  

{p 8 8 2}
    A {cmd:rowvector} is a vector with one row.  

{p 8 8 2}
    A {cmd:vector} is either a {cmd:rowvector} or {cmd:colvector}, 
    without saying which.

{* index view matrix}{...}
{marker view}{...}
{p 4 8 2}
{bf:view}{break}
    A view is a special type of matrix that appears to be an ordinary matrix,
    but in fact the values in the matrix are the values of certain or all
    variables and observations in the Stata dataset that is currently in
    memory.  Its values are not just equal to the dataset's values; they 
    are the dataset's values:  if an element of the matrix is changed, 
    the corresponding variable and observation in the Stata dataset also 
    changes.  Views are obtained by {cmd:st_view()} and are efficient;
    see {bf:{help mf_st_view:[M-5] st_view()}}.

{* index void function}{...}
{p 4 8 2}
{bf:void function}{break}
    A function is said to be void if it returns nothing.  For instance, the
    function {bf:{help mf_printf:[M-5] printf()}} is a void function; it
    prints results, but it does not return anything in the sense that, say,
    {bf:{help mf_sqrt:[M-5] sqrt()}} does.  It would not make any sense to
    code {cmd:x} {cmd:=} {cmd:printf("hi there")}, but coding {cmd:x}
    {cmd:=} {cmd:sqrt(2)} is perfectly logical.

{* index void matrix}{...}
{marker voidmatrix}{...}
{p 4 8 2}
{bf:void matrix}{break}
    A matrix is said to be void if it is 0 {it:x} 0, {it:r} {it:x} 0, or
    0 {it:x} {it:c}; see {bf:{help m2_void:[M-2] void}}.
{p_end}
