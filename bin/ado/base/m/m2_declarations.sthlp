{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[M-2] Declarations" "mansection M-2 Declarations"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_declarations##syntax"}{...}
{viewerjumpto "Description" "m2_declarations##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_declarations##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_declarations##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-2] Declarations} {hline 2}}Declarations and types
{p_end}
{p2col:}({mansection M-2 Declarations:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:declaration1} {it:fcnname}{cmd:(}{it:declaration2}{cmd:)}
	{cmd:{c -(}}
		{it:declaration3}

		...
	{cmd:{c )-}}

{p 4 4 2}
such as 

	{cmd:real matrix} myfunction({cmd:real matrix X, real scalar i})
	{
		{cmd:real scalar     j, k}
		{cmd:real vector     v}
		
		...
	}

{p 4 4 2}
{it:declaration1} is one of

		{cmd:function}
		{it:type} [{cmd:function}]
		{cmd:void} [{cmd:function}]

{p 4 4 2}
{it:declaration2} is

		[{it:type}] {it:argname} [{cmd:,} [{it:type}] {it:argname} [{cmd:,} ...]]

{p 4 4 2}
where {it:argname} is the name you wish to assign to the argument.  

{p 4 4 2}
{it:declaration3} are lines of the form of either of

		{it:type}             {varname} [{cmd:,} {varname} [{cmd:,} ...]]
		{cmd:external} [{it:type}]  {varname} [{cmd:,} {varname} [{cmd:,} ...]]

{p 4 4 2}
{it:type} is defined as one of 

		{it:eltype} {it:orgtype}{col 40}such as {cmd:real vector}
		{it:eltype} {col 40}such as {cmd:real}
		{it:orgtype}{col 40}such as {cmd:vector}

{p 4 4 2}
{it:{help m2_declarations##remarks4:eltype}} and
{it:{help m2_declarations##remarks5:orgtype}} are each one of

		{it:eltype              orgtype}
		{hline 12}        {hline 10}{cmd}
		transmorphic        matrix
		numeric             vector 
		real                rowvector
		complex             colvector
		string              scalar
		pointer{txt}             {hline 10}
		{hline 12}

{p 4 4 2}
If {it:eltype}{bind:  }is not specified, {cmd:transmorphic} is assumed.{break}
If {it:orgtype} is not specified,{bind:    }{cmd:matrix}{bind:    }is assumed.


{marker description}{...}
{title:Description}

{p 4 4 2}
The type and the use of declarations are explained.
Also discussed is the calling convention (functions are called by address, 
not by value, and so may change the caller's arguments), and the use 
of external globals.

{pstd}
Mata also has structures -- the {it:eltype} is {cmd:struct} {it:name} -- but
these are not discussed here.  For a discussion
of structures, see {helpb m2_struct:[M-2] struct}.

{pstd}
Mata also has classes -- the {it:eltype} is {cmd:class} {it:name} -- but
these are not discussed here.  For a discussion
of classes, see {helpb m2_class:[M-2] class}.

{p 4 4 2}
Declarations are optional but, for careful work, their use is recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 DeclarationsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_declarations##remarks1:The purpose of declarations}
	{help m2_declarations##remarks2:Types, element types, and organizational types}
	{help m2_declarations##remarks3:Implicit declarations}
	{help m2_declarations##remarks4:Element types}
	{help m2_declarations##remarks5:Organizational types}
	{help m2_declarations##remarks6:Function declarations}
	{help m2_declarations##remarks7:Argument declarations}
	{help m2_declarations##remarks8:The by-address calling convention}
	{help m2_declarations##remarks9:Variable declarations}
	{help m2_declarations##remarks10:Linking to external globals}


{marker remarks1}{...}
{title:The purpose of declarations}

{p 4 4 2}
Declarations occur in three places:  in front of function definitions, inside
the parentheses defining the function's arguments, and at the top of the body
of the function, defining private variables the function will use.  For
instance, consider the function

	{cmd}real matrix swaprows(real matrix A, real scalar i1, real scalar i2)
	{c -(}
		real matrix     B
		real rowvector  v

		B = A
		v = B[i1, .]
		B[i1, .] = B[i2, .]
		B[i2, .] = v
		return(B)
	{c )-}{txt}

{p 4 4 2}
This function returns a copy of matrix {cmd:A} with rows {cmd:i1} and 
{cmd:i2} swapped.

{p 4 4 2}
There are three sets of declarations in the above function.  First, there is 
a declaration in front of the function name:

	{cmd:real matrix} swaprows(...)
	{
		...
	}

{p 4 4 2}
That declaration states that this function will return a real matrix.

{p 4 4 2}
The second set of declarations occur inside the parentheses:

	... swaprows({cmd:real matrix A, real scalar i1, real scalar i2})
	{c -(}
		...
	{c )-}

{p 4 4 2}
Those declarations state that this function expects to receive three
arguments, which we chose to call {cmd:A}, {cmd:i1}, and {cmd:i2}, and which
we expect to be a real matrix, a real scalar, and a real scalar, respectively.

{p 4 4 2}
The third set of declarations occur at the top of the body of the function:

	... swaprows(...)
	{c -(}
		{cmd:real matrix     B}
		{cmd:real rowvector  v}

		...
	{c )-}

{p 4 4 2}
Those declarations state that we will use variables {cmd:B} and {cmd:v} inside
our function and that, as a matter of fact, {cmd:B} will be a real matrix and
{cmd:v} a real row vector.

{p 4 4 2}
We could have omitted all those declarations.  Our function could have read

	{cmd}function swaprows(A, i1, i2)
	{c -(}
		B = A
		v = B[i1, .]
		B[i1, .] = B[i2, .]
		B[i2, .] = v
		return(B)
	{c )-}{txt}

{p 4 4 2}
and it would have worked just fine.  So why include the declarations?

{p 8 12 2}
    1.  By including the outside declaration, we announced to other 
        programs what to expect.  They can depend on {cmd:swaprows()} 
        returning a real matrix because, when {cmd:swaprows()} is done, Mata 
        will verify that the function really is returning a real matrix and, 
        if it is not, abort execution.

{p 12 12 2}
        Without the outside declaration, anything goes.  Our function 
        could return a real scalar in one case, a complex rowvector in 
        another, and nothing at all in yet another case.

{p 12 12 2}
        Including the outside declaration makes debugging easier.

{p 8 12 2}
    2.  By including the argument declaration, we announced to other 
        programmers what they are expected to pass to our function. 
        We have made it easier to understand our function.

{p 12 12 2}
        We have also told Mata what to expect and, if some other program 
        attempts to use our function incorrectly, Mata will stop execution.

{p 12 12 2}
        Just as in (1), we have made debugging easier.

{p 8 12 2}
    3.  By including the inside declaration, we have told Mata what 
        variables we will need and how we will be using them.  Mata
        can do two things with that information:  first, it can make 
        sure that we are using the variables correctly (making debugging 
        easier again), and second, Mata can produce more efficient code
        (making our function run faster).

{p 4 4 2}
Interactively, we admit that we sometimes define functions without
declarations.  For more careful work, however, we include them.


{marker remarks2}{...}
{title:Types, element types, and organizational types}

{p 4 4 2}
When you use Mata interactively, you just willy-nilly create new variables:

	: {cmd:n = 2}
	: {cmd:A = (1,2 \ 3,4)}
	: {cmd:z = (sqrt(-4+0i), sqrt(4))}

{p 4 4 2}
When you create a variable, you may not think about the type, but Mata does.
{cmd:n} above is, to Mata, a real scalar.  {cmd:A} is a real matrix.
{cmd:z} is a complex row vector.

{p 4 4 2}
Mata thinks of the type of a variable as having two parts: 

{p 8 12 2}
    1.  the type of the elements the variable contains (such as real or
        complex) and

{p 8 12 2}
    2.  how those elements are organized (such as a row vector or a matrix).

{p 4 4 2}
We call those two types the {it:eltype} -- element type -- and {it:orgtype} --
organizational type.  The {it:eltypes} and {it:orgtypes} are

		{it:eltype              orgtype}
		{hline 12}        {hline 10}{cmd}
		transmorphic        matrix
		numeric             vector 
		real                rowvector
		complex             colvector
		string              scalar
		pointer{txt}             {hline 10}
		{hline 12}

{p 4 4 2}
You may choose one of each and so describe all the types Mata understands.


{marker remarks3}{...}
{title:Implicit declarations}

{p 4 4 2} When you do not declare an object, Mata behaves as if you declared
it to be {cmd:transmorphic} {cmd:matrix}:

{p 8 12 2}
    1.  {cmd:transmorphic} means that the matrix can be {cmd:real},
        {cmd:complex}, {cmd:string}, or {cmd:pointer}.

{p 8 12 2}
    2.  {cmd:matrix} means that the organization is to be {it:r} {it:x}
        {it:c}, {it:r}>=0 and {it:c}>=0.

{p 4 4 2}
At one point in your function, a {cmd:transmorphic} matrix might be a
{cmd:real} {cmd:scalar} ({cmd:real} being a special case of
{cmd:transmorphic} and {cmd:scalar} being a special case of a {cmd:matrix}
when {it:r}={it:c}=1), and at another point, it might be a {cmd:string}
{cmd:colvector} ({cmd:string} being a special case of {cmd:transmorphic}, and
{cmd:colvector} being a special case of a {cmd:matrix} when c=1).

{p 4 4 2}
Consider our {cmd:swaprows()} function without declarations, 

	{cmd}function swaprows(A, i1, i2)
	{c -(}
		B = A
		v = B[i1, .]
		B[i1, .] = B[i2, .]
		B[i2, .] = v
		return(B)
	{c )-}{txt}

{p 4 4 2}
The result of compiling this function is just as if the function read

	{cmd}transmorphic matrix swaprows(transmorphic matrix A, 
				     transmorphic matrix i1, 
				     transmorphic matrix i2)
	{c -(}
		transmorphic matrix     B
		transmorphic matrix     v

		B = A
		v = B[i1, .]
		B[i1, .] = B[i2, .]
		B[i2, .] = v
		return(B)
	{c )-}{txt}

{p 4 4 2}
When we declare a variable, we put restrictions on it.


{marker remarks4}{...}
{title:Element types}

{p 4 4 2}
There are six {it:eltypes}, or element types:

{p 8 12 2}
    1.  {cmd:transmorphic}, which means {cmd:real}, {cmd:complex},
        {cmd:string}, or {cmd:pointer}.

{p 8 12 2}
    2.  {cmd:numeric}, which means {cmd:real} or {cmd:complex}.

{p 8 12 2}
    3.  {cmd:real}, which means that the elements are real numbers, such as 1,
         3, -50, and 3.14159.

{p 8 12 2}
    4.  {cmd:complex}, which means that each element is a pair of numbers,
        which are given the interpretation {it:a}+{it:b}i.  
        {cmd:complex} is a storage type; the number stored in a {cmd:complex}
        might be real, such as 2+0i.

{p 8 12 2}
    5.  {cmd:string}, which means the elements are strings of text.  Each
        element may contain up to 2,147,483,647 bytes and strings 
        may (need not) contain binary 0; that is, strings may be binary strings
	or text strings.  Mata strings are similar to the {cmd:strL} type in
	Stata in that they can be very long and may contain binary 0.
	Mata strings, like all other strings in Stata, can contain Unicode
	characters and are stored in UTF-8 encoding.

{p 8 12 2}
    6.  {cmd:pointer} means the elements are pointers to (addresses of) other
        Mata matrices, vectors, scalars, or even functions; see 
        {bf:{help m2_pointers:[M-2] pointers}}.


{marker remarks5}{...}
{title:Organizational types}

{p 4 4 2}
There are five {it:orgtypes}, or organizational types:

{p 8 12 2}
    1.  {cmd:matrix}, which means {it:r x c}, {it:r}>=0 and {it:c}>=0.

{p 8 12 2}
    2.  {cmd:vector}, which means 1 {it:x} {it:n} or {it:n} {it:x} 1, 
        {it:n}>=0.

{p 8 12 2}
    3.  {cmd:rowvector}, which means 1 {it:x} {it:n}, {it:n}>=0.

{p 8 12 2}
    4.  {cmd:colvector}, which means {it:n} {it:x} 1, {it:n}>=0.

{p 8 12 2}
    5.  {cmd:scalar}, which means 1 {it:x} 1.

{p 4 4 2}
Sharp-eyed readers will note that vectors and matrices can have zero rows 
or columns!  See {bf:{help m2_void:[M-2] void}} for more information.


{marker remarks6}{...}
{title:Function declarations}

{p 4 4 2}
Function declarations are the declarations that appear in front of the 
function name, such as 

	{cmd:real matrix} swaprows(...)
	{
		...
	}

{p 4 4 2} 
The syntax for what may appear there is 

		{cmd:function}
		{it:type} [{cmd:function}]
		{cmd:void} [{cmd:function}]

{p 4 4 2}
Something must appear in front of the name, and if you do not want 
to declare the type (which makes the type {cmd:transmorphic}
{cmd:matrix}), you just put the word {cmd:function}:

	{cmd:function} swaprows(...)
	{
		...
	}

{p 4 4 2}
You may also declare the type and include the word {cmd:function}
if you wish, 

	{cmd:real matrix function} swaprows(...)
	{
		...
	}

{p 4 4 2}
but most programmers omit the word {cmd:function}; it makes no difference.

{p 4 4 2}
In addition to all the usual types, {cmd:void} is a type allowed only with
functions -- it states that the function returns nothing:

	{cmd:void} _swaprows(real matrix A, real scalar i1, real scalar i2)
	{c -(}
		real rowvector  v

		v = A[i1, .]
		A[i1, .] = A[i2, .]
		A[i2, .] = v
	{c )-}{txt}

{p 4 4 2}
The function above returns nothing; it instead modifies the matrix it is 
passed.  That might be useful to save memory, especially if every use 
of the original {cmd:swaprows()} was going to be 

	{cmd:A = swaprows(A, i1, i2)}

{p 4 4 2}
In any case, we named this new function {cmd:_swaprows()} (note the underscore),
to flag the user that there is something odd and deserving caution concerning
the use of this function.

{p 4 4 2}
{cmd:void}, that is to say, returning nothing, is also considered a special
case of a {cmd:transmorphic} {cmd:matrix} because Mata secretly returns a 
0 {it:x} 0 real matrix, which the caller just discards.


{marker remarks7}{...}
{title:Argument declarations}

{p 4 4 2}
Argument declarations are the declarations that appear 
inside the parentheses, such as 

	... swaprows({cmd:real matrix A, real scalar i1, real scalar i2})
	{c -(}
		...
	{c )-}{txt}

{p 4 4 2}
The syntax for what may appear there is

		[{it:type}] {it:argname} [{cmd:,} [{it:type}] {it:argname} [{cmd:,} ...]]

{p 4 4 2}
The names are required -- they specify how we will refer to the argument -- 
and the types are optional.  Omit the type and {cmd:transmorphic} {cmd:matrix}
is assumed.  Specify the type, and it will be checked when your function is 
called.  If the caller attempts to use your function incorrectly, Mata 
will stop the execution and complain.


{marker remarks8}{...}
{title:The by-address calling convention}

{p 4 4 2}
Arguments are passed to functions by address, not by value. 
If you change the value of an argument, you will change the caller's 
argument.  That is what made {cmd:_swaprows()} (above) work.  The 
caller passed us {cmd:A} and we changed it.  And that is why in the original 
version of {cmd:swaprows()}, the first line read 

	{cmd:B = A}

{p 4 4 2}
we did our work on {cmd:B}, and returned {cmd:B}.  We did 
not want to modify the caller's original matrix.

{p 4 4 2}
You do not ordinarily have to make copies of the caller's arguments, but you
do have to be careful if you do not want to change the argument.  That is why
in all the official functions (with the single exception of 
{cmd:st_view()} -- see {bf:{help mf_st_view:[M-5] st_view()}}), if a function
changes the caller's argument, the function's name starts with an underscore.
The reverse logic does not hold:  some functions start with an underscore and
do not change the caller's argument.  The underscore signifies caution, and
you need to read the function's documentation to find out what it is you need
to be cautious about.


{marker remarks9}{...}
{title:Variable declarations}

{p 4 4 2}
The variable declarations are the declarations that appear at the 
top of the body of a function:

	... swaprows(...)
	{
		{cmd:real matrix     B}
		{cmd:real rowvector  v}

		...
	}

{p 4 4 2}
These declarations are optional.  If you omit them, Mata will observe
that you are using {cmd:B} and {cmd:v} in your code, and then Mata will
compile your code just as if you had declared the variables to be 
{cmd:transmorphic} {cmd:matrix}, meaning that the resulting compiled code 
might be a little more inefficient than it could be, but that is all.

{* index matastrict tt}{...}
{p 4 4 2}
The variable declarations are optional as long as you have not {cmd:mata}
{cmd:set} {cmd:matastrict} {cmd:on}; see {bf:{help mata_set:[M-3] mata set}}.
Some programmers believe so strongly that variables really ought to be
declared that Mata provides a provision to issue an error when they forget.

{p 4 4 2}
In any case, these declarations -- explicit or implicit -- define
the variables we will use.  The variables 
we use in our function are private -- it does not matter if there are other
variables named {cmd:B} and {cmd:v} floating around somewhere.  Private
variables are created when a function is invoked and destroyed when the
function ends.  The variables are private but, as explained above, if we pass
our variables to another function, that function may change their values.
Most functions do not.

{p 4 4 2}
The syntax for declaring variables is

		{it:type}             {varname} [{cmd:,} {it:varname} [{cmd:,} ...]]

		{cmd:external} [{it:type}]  {it:varname} [{cmd:,} {it:varname} [{cmd:,} ...]]

{p 4 4 2}
{cmd:real matrix B} and {cmd:real rowvector v} match the first syntax.


{marker remarks10}{...}
{title:Linking to external globals}

{p 4 4 2}
The second syntax has to do with linking to global variables.  When you 
use Mata interactively and type

	: {cmd:n = 2}

{p 4 4 2}
you create a variable named {cmd:n}.  That variable is global.  When you 
code inside a function

	... myfunction(...)
	{
		{cmd:external n}

		...
	}

{p 4 4 2}
The {cmd:n} variable your function will use is the global variable named
{cmd:n}.  If your function were to examine the value of {cmd:n} right now, it
would discover that it contained 2.

{p 4 4 2}
If the variable does not already exist, the statement {cmd:external} {cmd:n}
will create it.  Pretend that we had not previously defined {cmd:n}.  If
{cmd:myfunction()} were to examine the contents of {cmd:n}, it would discover
that {cmd:n} is a 0 {it:x} 0 matrix.  That is because we coded

		{cmd:external n}

{p 4 4 2}
and Mata behaved as if we had coded

		{cmd:external transmorphic matrix n}

{p 4 4 2}
Let's modify {cmd:myfunction()} to read:

	... myfunction(...)
	{
		{cmd:external real scalar n}

		...
	}

{p 4 4 2}
Let's consider the possibilities:

{p 8 12 2}
    1.  {cmd:n} does not exist.{break}
	Here {cmd:external} {cmd:real} {cmd:scalar} {cmd:n} will
        create {cmd:n} -- as a real scalar, of course -- and set its value 
        to missing.  

{p 12 12 2}
	If {cmd:n} had been declared a {cmd:rowvector}, a 1 {it:x} 0 vector 
        would have been created.

{p 12 12 2}
	If {cmd:n} had been declared a {cmd:colvector}, a 0 {it:x} 1 vector 
        would have been created.

{p 12 12 2}
	If {cmd:n} had been declared a {cmd:vector}, a 0 {it:x} 1 vector 
        would have been created.  Mata could just as well have created 
        a 1 {it:x} 0 vector, but it creates a 0 {it:x} 1.

{p 12 12 2}
        If {cmd:n} had been declared a {cmd:matrix}, a 0 {it:x} 0 matrix 
        would have been created.

{p 8 12 2}
    2.  {cmd:n} exists, and it is a {cmd:real scalar}.{break}
        Our function executes, using the global {cmd:n}.

{p 8 12 2}
    3.  {cmd:n} exists, and it is a {cmd:real} 1 {it:x} 1 
        {cmd:rowvector}, {cmd:colvector}, or {cmd:matrix}.{break}
        The important thing is that it is 1 {it:x} 1; our function executes, 
        using the global {cmd:n}.

{p 8 12 2}
    4.  {cmd:n} exists, but it is {cmd:complex} or {cmd:string} or
        {cmd:pointer}, or it is {cmd:real} but not 1 {it:x} 1.{break}
        Mata issues an error message and aborts execution of our function.

{p 4 4 2}
    Complicated systems of programs sometimes find it convenient to 
    communicate via globals.  Because globals are globals, we recommend 
    that you give your globals long names.  A good approach is to put the name
    of your system as a prefix:

	... myfunction(...)
	{
		{cmd:external real scalar mysystem_n}

		...
	}

{p 4 4 2}
For another approach to globals, see 
{bf:{help mf_findexternal:[M-5] findexternal()}}
and 
{bf:{help mf_valofexternal:[M-5] valofexternal()}}.
{p_end}
