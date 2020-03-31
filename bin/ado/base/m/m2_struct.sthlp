{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[M-2] struct" "mansection M-2 struct"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Declarations" "help m2_declarations"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_struct##syntax"}{...}
{viewerjumpto "Description" "m2_struct##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_struct##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_struct##remarks"}{...}
{viewerjumpto "References" "m2_struct##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-2] struct} {hline 2}}Structures
{p_end}
{p2col:}({mansection M-2 struct:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:struct} {it:structname} {cmd:{c -(}}
		{it:declaration(s)}
	{cmd:{c )-}}

{p 4 4 2}
such as 

	{cmd:struct mystruct {c -(}}
		{cmd:real scalar    n1, n2}
		{cmd:real matrix    X}
	{cmd:{c )-}}


{marker description}{...}
{title:Description}

{p 4 4 2}
A structure contains a set of variables tied together under one name.
For a more detailed description of structures and how they are used, see
{help m2_struct##gould2018sp:Gould (2018)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 structRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_struct##tagintro:Introduction}
	{help m2_struct##tagdifnames:Structures and functions must have different names}
	{help m2_struct##tagexplicit:Structure variables must be explicitly declared}
	{help m2_struct##tagscalar:Declare structure variables to be scalars whenever possible}

	{help m2_struct##tagmatrices:Vectors and matrices of structures}
	{help m2_struct##tagstructstruct:Structures of structures}
	{help m2_struct##tagpointer:Pointers to structures}

	{help m2_struct##tagoper1:Operators and functions for use with structure members}
	{help m2_struct##tagoper2:Operators and functions for use with entire structures}

	{help m2_struct##taglisting:Listing structures}

	{help m2_struct##tagpassthru:Use of transmorphics as passthrus}
	{help m2_struct##tagsavdef:Saving compiled structure definitions}
	{help m2_struct##tagsavvar:Saving structure variables}


{marker tagintro}{...}
{title:Introduction}

{p 4 4 2}
Here is an overview of the use of structures:

	{cmd}struct mystruct {c -(}
		real scalar    n1, n2
		real matrix    X
	{c )-}

	function myfunc()
	{
		struct mystruct scalar	e

		{txt:...}
		e.n1 = {txt:...}
		e.n2 = {txt:...}
		e.X  = {txt:...}
		{txt:...}
		{txt:...} mysubroutine(e, {txt:...})
		{txt:...}
	}

	function mysubroutine(struct mystruct scalar x, {txt:...})
	{
		struct mystruct scalar   y
		{txt:...}
		{txt:...} x.n1 {txt:...} x.n2 {txt:...} x.X {txt:...}
		{txt:...}
                y = mysubfcn(x)
		{txt:...}
		{txt:...} y.n1 {txt:...} y.n2 {txt:...} y.X {txt:...}
		{txt:...} x.n1 {txt:...} x.n2 {txt:...} x.X {txt:...}
		{txt:...}
	}

	{cmd}struct mystruct scalar mysubfcn(struct mystruct scalar x)
	{
		struct mystruct scalar   result

		result = x
		{txt:...} result.n1 {txt:...} result.n2 {txt:...} result.X {txt:...}
		return(result)
	}{txt}

{p 4 4 2}
Note the following:

{p 8 12 2}
    1.  We first defined the structure.  Definition does not create 
        variables; definition defines what we mean when we refer to
        a {cmd:struct} {cmd:mystruct} in the future.  This definition is done
        outside and separately from the definition of the functions that
        will use it.  The structure is defined before the functions.

{p 8 12 2}
    2.  In {cmd:myfunc()}, we declared that variable {cmd:e} is a 
        {cmd:struct} {cmd:mystruct} {cmd:scalar}.
        We then used variables {cmd:e.n1}, {cmd:e.n2}, and {cmd:e.X} 
        just as we would use any other variable.  In the call to 
        {cmd:mysubroutine()}, however, we passed the entire {cmd:e}
        structure.

{p 8 12 2}
     3.  In {cmd:mysubroutine()}, we declared that the first argument 
         received is a {cmd:struct} {cmd:mystruct} {cmd:scalar}.  We
         chose to call it {cmd:x} rather than {cmd:e} to
         emphasize that names are not important.  {cmd:y}
         is also a {cmd:struct} {cmd:mystruct} {cmd:scalar}.

{p 8 12 2}
     4.  {cmd:mysubfcn()} not only accepts a {cmd:struct} {cmd:mystruct}
         as an argument but also returns a {cmd:struct} {cmd:mystruct}.
         One of the best uses of structures is as a way to return 
         multiple, related values.  

{p 12 12 2}
         The line {cmd:result=x} copied all the values in the structure; 
         we did not need to code 
         {cmd:result.n1=x.n1}, 
         {cmd:result.n2=x.n2}, 
         and
         {cmd:result.X=x.X}. 


{marker tagdifnames}{...}
{title:Structures and functions must have different names}

{p 4 4 2}
You define structures much as you define functions, 
at the colon prompt, with the definition enclosed in braces:

	: {cmd:struct twopart {c -(}}
	>         {cmd:real scalar    n1, n2}
	> {cmd:{c )-}}

	: {cmd:function setuphistory()}
	> {cmd:{c -(}}
	>         ...
	> {cmd:{c )-}}

{p 4 4 2}
Structures and functions may not have the same names.  If you call a structure
{cmd:twopart}, then you cannot have a function named {cmd:twopart()}, and vice
versa.


{marker tagexplicit}{...}
{title:Structure variables must be explicitly declared}

{p 4 4 2}
Declarations are usually optional in Mata.  You can code 

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
or you can code 

	{cmd}function swaprows(A, i1, i2)
	{c -(}
		B = A
		v = B[i1, .]
		B[i1, .] = B[i2, .]
		B[i2, .] = v
		return(B)
	{c )-}{txt}

{p 4 4 2}
When a variable, argument, or returned value is a structure, however, you must
explicitly declare it:

	{cmd}function makecalc()
	{
		struct twopart scalar   t

		t.n1 = t.n2 = 0 
		{txt:...}
	}

	function clear_twopart(struct twopart scalar t)
	{
		t.n1 = t.n2 = 0
	}

	struct twopart scalar new_twopart()
	{
		struct twopart scalar   t

		t.n1 = t.n2 = 0
		return(t)
	}{txt}

{p 4 4 2}
In the functions above, we refer to variables {cmd:t.n1} and {cmd:t.n2}.
The Mata compiler cannot interpret those names unless it knows the
definition of the structure.

{p 4 4 2}
Aside:  
All structure references are resolved at compile time, not run time.  That is,
terms like {cmd:t.n1} are not stored in the compiled code and resolved during
execution.  Instead, the Mata compiler accesses the structure definition when
it compiles your code.  The compiler knows that {cmd:t.n1} refers to the first
element of the structure and generates efficient code to access it.


{marker tagscalar}{...}
{title:Declare structure variables to be scalars whenever possible}

{p 4 4 2}
In our declarations, we code things like 

		{cmd:struct twopart scalar   t}

{p 4 4 2}
and do not simply code 

		{cmd:struct twopart          t}

{p 4 4 2}
although the simpler statement would be valid.

{p 4 4 2}
Structure variables can be scalars, vectors, or matrices; when you 
do not say which, matrix is assumed.

{p 4 4 2}
Most uses of structures are as scalars, and the compiler will
generate more efficient code if you tell it that the structures are scalars.
Also, when you use structure vectors or matrices, there is an 
extra step you need to fill in, as described in the next section.


{marker tagmatrices}{...}
{title:Vectors and matrices of structures}

{p 4 4 2}
Just as you can have {cmd:real} scalars, vectors, or matrices, you can have
structure scalars, vectors, or matrices.  The following are all valid:

		{cmd}struct twopart scalar     t
		struct twopart vector     t
		struct twopart rowvector  t
		struct twopart colvector  t
		struct twopart matrix     t{txt}

{p 4 4 2}
In a {cmd:struct} {cmd:twopart} {cmd:matrix}, every element of the matrix 
is a separate structure.  Say that the matrix were 2 {it:x} 3.  Then you 
could refer to any of the following variables,

		{cmd}t[1,1].n1
		t[1,2].n1
		t[1,3].n1
		t[2,1].n1
		t[2,2].n1
		t[2,3].n1{txt}

{p 4 4 2}
and similarly for {cmd:t[}{it:i}{cmd:,}{it:j}{cmd:].n2}.

{p 4 4 2}
If {cmd:struct} {cmd:twopart} also contained a matrix {cmd:X}, then

		{cmd:t[}{it:i}{cmd:,}{it:j}{cmd:].X}

{p 4 4 2}
would refer to the ({it:i},{it:j})th matrix.

		{cmd:t[}{it:i}{cmd:,}{it:j}{cmd:].X[}{it:k}{cmd:,}{it:l}{cmd:]}

{p 4 4 2} would refer to the ({it:k},{it:l})th element of the
({it:i},{it:j})th matrix.


{p 4 4 2}
If {cmd:t} is to be a 2 {it:x} 3 matrix, you must arrange to make it 2 {it:x}
3.  After the declaration 

		{cmd:struct} {cmd:twopart} {cmd:matrix}   {cmd:t}

{p 4 4 2}
{cmd:t} is 0 {it:x} 0.  This result
is no different from the situation where {cmd:t} is a
{cmd:real} {cmd:matrix} and after declaration, {cmd:t} is 0 {it:x} 0.

{p 4 4 2}
Whether {cmd:t} is a {cmd:real} {cmd:matrix} or a {cmd:struct} {cmd:twopart}
{cmd:matrix}, you allocate {cmd:t} by assignment.
Let's pretend that {cmd:t} is a {cmd:real} {cmd:matrix}.  There are 
three solutions to the allocation problem:

		(1)  {cmd:t = x}

		(2)  {cmd:t = somefunction(}...{cmd:)}

		(3)  {cmd:t = J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:v}{cmd:)}

{p 4 4 2}
All three are so natural that you do not even think of them as allocation; you 
think of them as definition.  

{p 4 4 2}
The situation with structures is the same.

{p 4 4 2}
Let's take each in turn.

{p 8 12 2}
    1.  {cmd:x} contains a 2 {it:x} 3 {cmd:struct} {cmd:twopart}.  You code 

		     {cmd:t = x}

{p 12 12 2}
        and now {cmd:t} contains a copy of {cmd:x}.  {cmd:t} is 2 {it:x} 3.

{p 8 12 2}
    2.  {cmd:somefunction(}...{cmd:)} returns a 2 {it:x} 3 {cmd:struct} 
        {cmd:twopart}.  You code 

		     {cmd:t = somefunction(}...{cmd:)}

{p 12 12 2}
        and now {cmd:t} contains the 2 {it:x} 3 result.

{p 8 12 2}
    3.  Mata function {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:v}{cmd:)}
        returns an {it:r} {it:x} {it:c} matrix, 
        every element of which is set to {it:v}.  So pretend that variable 
        {cmd:tpc} contains a {cmd:struct} {cmd:twopart} {cmd:scalar}.
        You code 

		     {cmd:t = J(2, 3, tpc)}

{p 12 12 2}
        and now {cmd:t} is 2 {it:x} 3, every element of which is a copy of 
        {cmd:tpc}.
        Here is how you might do that:

		     {cmd:function} ...{cmd:(}...{cmd:)}
		     {cmd}{
		             struct twopart scalar   tpc
			     struct twopart matrix   t

			     {txt:...}
			     t = J(2, 3, tpc)
			     {txt:...}
		     }{txt}

{p 4 4 2}
Finally, there is a fourth way to create structure vectors and matrices.
When you defined 
				
		{cmd:struct twopart {c -(}}
			{cmd:real scalar    n1, n2}
		{cmd:{c )-}}

{p 4 4 2}
Mata not only recorded the structure definition but also created a function
named {cmd:twopart()} that returns a {cmd:struct} {cmd:twopart}.  Thus, rather
than enduring all the rigamarole of creating a matrix from a preallocated
scalar, you could simply code

		{cmd:t = J(2, 3, twopart())}

{p 4 4 2}
In fact, the function {cmd:twopart()} that Mata creates for you allows 
zero, one, or two arguments:

		{cmd:twopart()}{col 35}{...}
returns a{bind:  }1 {it:x} 1 {cmd:struct twopart}

		{cmd:twopart(}{it:r}{cmd:)}{col 35}{...}
returns an {it:r x} 1 {cmd:struct twopart}

		{cmd:twopart(}{it:r}{cmd:,} {it:c}{cmd:)}{col 35}{...}
returns an {it:r x c} {cmd:struct twopart}

{p 4 4 2}
so you could code 

		{cmd:t = twopart(2, 3)}

{p 4 4 2}
or you could code 

		{cmd:t = J(2, 3, twopart())}

{p 4 4 2}
and whichever you code makes no difference.

{p 4 4 2}
Either way, 
what is in {cmd:t}?  Each element contains a separate {cmd:struct}
{cmd:twopart}.  In each {cmd:struct} {cmd:twopart}, the scalars have been set
to missing ({cmd:.}, {cmd:""}, or {cmd:NULL}, as appropriate), the vectors and
row vectors have been made 1 {it:x} 0, the column vectors 0 {it:x} 1, and
the matrices 0 {it:x} 0.


{marker tagstructstruct}{...}
{title:Structures of structures}

{p 4 4 2}
Structures may contain other structures:

		{cmd:struct twopart {c -(}}
			{cmd:real scalar    n1, n2}
		{cmd:{c )-}}

		{cmd:struct pair_of_twoparts {c -(}}
			{cmd:struct twopart scalar  t1, t2}
		{cmd:{c )-}}

{p 4 4 2}
If {cmd:t} were a {cmd:struct} {cmd:pair_of_twoparts} {cmd:scalar}, then the
members of {cmd:t} would be

		{cmd:t.t1}{col 35}a {cmd:struct twopart scalar}
		{cmd:t.t2}{col 35}a {cmd:struct twopart scalar}

		{cmd:t.t1.n1}{col 35}a {cmd:real scalar}
		{cmd:t.t1.n2}{col 35}a {cmd:real scalar}
		{cmd:t.t2.n1}{col 35}a {cmd:real scalar}
		{cmd:t.t2.n2}{col 35}a {cmd:real scalar}

{p 4 4 2}
You may also create structures of structures of structures,
structures of structures of structures of structures, and so on.
You may not, however, include a structure in itself:

		{cmd:struct recursive {c -(}}
			...
			{cmd:struct recursive scalar  r}
			...
		{cmd:{c )-}}

{p 4 4 2}
Do you see how, even in the scalar case, {cmd:struct} {cmd:recursive} would
require an infinite amount of memory to store?


{marker tagpointer}{...}
{title:Pointers to structures}

{p 4 4 2}
What you can do is this: 

		{cmd:struct recursive {c -(}}
			...
			{cmd:pointer(struct recursive scalar) scalar  r}
			...
		{cmd:{c )-}}

{p 4 4 2}
Thus, if {cmd:r} were a {cmd:struct} {cmd:recursive} {cmd:scalar}, then
{cmd:*r.r} would be the next structure, or {cmd:r.r} would be {cmd:NULL} if
there were no next structure.  Immediately after allocation, {cmd:r.r} would
equal {cmd:NULL}.

{p 4 4 2}
In this way, you may create linked lists.

{p 4 4 2}
Mata provides operator {cmd:->} for accessing members of 
pointers to structures.

{p 4 4 2}
Let {cmd:rec} be a {cmd:struct} {cmd:recursive}, and assume that {cmd:struct}
{cmd:recursive} also had member {cmd:real} {cmd:scalar} {cmd:n}, 
so that {cmd:rec.n} would be {cmd:rec}'s {cmd:n} value.  The value of the
next structure's {cmd:n} would be {cmd:rec.r->n} (assuming {cmd:rec.r!=NULL}).

{p 4 4 2}
The syntax of {cmd:->} is 

		{it:exp1}->{it:exp2}

{p 4 4 2}
where {it:exp1} evaluates to a structure pointer and {it:exp2} indexes the
structure.


{marker tagoper1}{...}
{title:Operators and functions for use with structure members}

{p 4 4 2}
All operators, all functions, and all features of Mata work with 
members of structures.  That is, given

	{cmd}struct example {
		real scalar	n
		real matrix	X
	}{txt}

	{cmd:function} ...{cmd:(}...{cmd:)}
	{cmd}{
		real scalar		rs
		real matrix		rm
		struct example scalar	ex

		{txt:...}
	}{txt}

{p 4 4 2}
then {cmd:ex.n} and {cmd:ex.X} may be used anyplace {cmd:rs} and {cmd:rm}
would be valid.


{marker tagoper2}{...}
{title:Operators and functions for use with entire structures}

{p 4 4 2}
Some operators and functions can be used with entire structures, not just the
structure's elements.  Given

		{cmd:struct mystruct scalar    ex1, ex2, ex3, ex4}
		{cmd:struct mystruct matrix    E, F, G}

{p 8 12 2}
1.
You may use {cmd:==} and {cmd:!=} to test for equality:

		{cmd:if (ex1==ex2)} ...

		{cmd:if (ex1!=ex2)} ...

{p 12 12 2}
Two structures are equal if their members are equal.  

{p 12 12 2}
In the example, 
{cmd:struct} {cmd:mystruct} itself contains no substructures.  If it did, the
definition of equality would include checking the equality of substructures,
sub-substructures, etc.

{p 12 12 2}
In the example, {cmd:ex1} and {cmd:ex2} are scalars.  If they
were matrices, each element would be compared, and the matrices 
would be equal if the corresponding elements were equal.

{p 8 12 2}
2.  
You may use 
{help m2_op_colon:{bf::==} and {bf:!=}} to form
pattern matrices of equality and inequality.

{p 8 12 2}
3.
You may use the {help m2_op_join:comma and backslash}
operators to form vectors and matrices of structures:

		{cmd:ex = ex1, ex2 \ ex3, ex4}

{p 8 12 2}
4.
You may use {cmd:&} to obtain pointers to structures:

		{cmd:ptr_to_ex1 = &ex1}

{p 8 12 2}
5.
You may use {help m2_subscripts:subscripting} to access and copy structure
members:

		{cmd:ex1 = E[1,2]}

		{cmd:E[1,2] = ex1}

		{cmd:F = E[2,.]}

		{cmd:E[2,.] = F}

		{cmd:G = E[|1,1\2,2|]}

		{cmd:E[|1,1\2,2|] = G}

{p 8 12 2}
6.
You may use the {help mf_rows:{bf:rows()} and {bf:cols()}} functions to
obtain the number of rows and columns of a matrix of structures.

{p 8 12 2}
7.
You may use {help mf_eltype:{bf:eltype()} and {bf:orgtype()}} with
structures.  {cmd:eltype()} returns {cmd:struct}; {cmd:orgtype()} returns the
usual results.

{p 8 12 2}
8.
You may use most functions that start with the letters {it:is}, as 
in {help mf_isreal:{bf:isreal()}, {bf:iscomplex()}, {bf:isstring()}}, etc.
These functions return 1 if true and 0 if false and with structures, usually
return 0.  

{p 8 12 2}
9.
You may use {helpb mf_swap:swap()} with structures.


{marker taglisting}{...}
{title:Listing structures}

{p 4 4 2}
To list the contents of a structure variable,
as for debugging purposes, use 
function {cmd:liststruct()}; see 
{bf:{help mf_liststruct:[M-5] liststruct()}}.

{p 4 4 2}
Using the default, unassigned-expression method to list structures
is not recommended, 
because all that is shown is a pointer value instead of the structure 
itself.


{marker tagpassthru}{...}
{title:Use of transmorphics as passthrus}

{p 4 4 2}
A {cmd:transmorphic} {cmd:matrix} can theoretically hold anything, so 
when we told you that structures had to be explicitly declared, that 
was not exactly right.  Say that function {cmd:twopart()} returns a 
{cmd:struct} {cmd:twopart} {cmd:scalar}.  You could code 

		{cmd:x = twopart()}

{p 4 4 2}
without declaring {cmd:x} (or declaring it {cmd:transmorphic}), and that 
would not be an error.  What you could not do would be
to then refer to {cmd:x.n1} or {cmd:x.n2}, because the compiler would not 
know that {cmd:x} contains a {cmd:struct} {cmd:twopart} and so would have no 
way of interpreting the variable references.

{p 4 4 2}
This property can be put to good use in implementing handles and passthrus.

{p 4 4 2}
Say that you are implementing a complicated system.  Just to fix ideas, we'll
pretend that the
system finds the maximum of user-specified functions and that the
system has many bells and whistles.  To track a given problem, let's assume
that your system needs many variables.  One variable records the method to
be used.  Another records whether numerical derivatives are to be used.
Another records the current gradient vector.  Another records the iteration
count,  and so on.  There might be hundreds of these variables.

{p 4 4 2}
You bind all of these variables together in one structure:

	{cmd}struct maxvariables {
		real scalar  method
		real scalar  use_numeric_d
		real vector  gradient
		real scalar  iteration
		{txt:...}
	}{txt}

{p 4 4 2}
You design a system with many functions, and some functions call others,
but because all the status variables are bound together in one structure,
it is easy to pass the values from one function to another.

{p 4 4 2}
You also design a system that is easy to use.  It starts
by the user "opening" a problem,

	{cmd:handle = maximize_open()}

{p 4 4 2}
and from that point on the user passes the handle around to the other 
maximize routines:

	{cmd:maximize_set_use_numeric_d(handle, 1)}
	{cmd:maximize_set_function_to_max(handle, &myfunc())}
	...
	{cmd:maximize_maximize_my_function(handle)}

{p 4 4 2}
In this way, you, the programmer of this system, can hold on to values from one
call to the next, and you can change the values, too.

{p 4 4 2}
What you never do, however, is tell the user that the handle is a 
{cmd:struct} {cmd:maxvariables}.  You just tell the user to open a 
problem by typing 

	{cmd:handle = maximize_open()}

{p 4 4 2}
and then to pass the handle returned to the other {cmd:maximize_*()} 
routines.  If the user feels that he must explicitly declare 
the handle, you tell him to declare it:

	{cmd:transmorphic scalar handle}

{p 4 4 2}
What is the advantage of this secrecy?  You can be certain 
that the user never changes any of the values in your {cmd:struct} 
{cmd:maxvariables} because the compiler does not even know what they are.

{p 4 4 2}
Thus you have made your system more robust to user errors.


{marker tagsavdef}{...}
{title:Saving compiled structure definitions}

{p 4 4 2}
You save compiled structure definitions just as you save compiled 
function definitions; see {bf:{help mata_mosave:[M-3] mata mosave}}
and {bf:{help mata_mlib:[M-3] mata mlib}}.

{p 4 4 2}
When you define a structure, such as {cmd:twopart}, 

		{cmd:struct twopart {c -(}}
			{cmd:real scalar    n1, n2}
		{cmd:{c )-}}

{p 4 4 2}
that also creates a function, {cmd:twopart()}, that creates instances 
of the structure.  

{p 4 4 2}
Saving {cmd:twopart()} in a {cmd:.mo} file, or in a {cmd:.mlib} library, 
saves the compiled definition as well.  Once {cmd:twopart()} has been 
saved, you may write future programs without bothering to define 
{cmd:struct} {cmd:twopart}.  The definition will be automatically found.


{marker tagsavvar}{...}
{title:Saving structure variables}

{p 4 4 2}
Variables containing structures may be saved on disk just as you 
would save any other variable.  No special action is required.
See {bf:{help mata_matsave:[M-3] mata matsave}}
and see the function {cmd:fputmatrix()} in 
{bf:{help mf_fopen:[M-5] fopen()}}.
{cmd:mata matsave} and {cmd:fputmatrix()} both work with structure variables,
although their entries do not mention them.
{p_end}


{marker references}{...}
{title:References}

{marker gould2018sp}{...}
{phang}
Gould, W. W. 2018.
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}}.
College Station, TX: Stata Press.

{phang}
------. 2007.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0035":Mata Matters: Structures}.
{it:Stata Journal} 7: 556-570.
{p_end}
