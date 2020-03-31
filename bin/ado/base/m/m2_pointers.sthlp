{smcl}
{* *! version 1.1.11  26sep2018}{...}
{vieweralsosee "[M-2] pointers" "mansection M-2 pointers"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_pointers##syntax"}{...}
{viewerjumpto "Description" "m2_pointers##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_pointers##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_pointers##remarks"}{...}
{viewerjumpto "Diagnostics" "m2_pointers##diagnostics"}{...}
{viewerjumpto "References" "m2_pointers##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] pointers} {hline 2}}Pointers
{p_end}
{p2col:}({mansection M-2 pointers:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:pointer}[{cmd:(}{it:totype}{cmd:)}]
[{it:orgtype}]
[{cmd:function}]
...


{p 4 4 2}
where {it:totype} is 

	[{it:eltype}] [{it:orgtype}] [{cmd:function}] 

{p 4 4 2}
and where {it:eltype} and {it:orgtype} are 

		{it:eltype                   orgtype}
		{hline 17}        {hline 10}{cmd}
		transmorphic             matrix
		numeric                  vector 
		real                     rowvector
		complex                  colvector
		string                   scalar{txt}
		{cmd:pointer}[{cmd:(}{it:towhat}{cmd:)}]        {hline 10}
		{hline 17}


{p 4 4 2}
{cmd:pointer}[{cmd:(}{it:totype}{cmd:)}]
[{it:orgtype}]
can be used in front of declarations, be they function declarations, argument 
declarations, or variable definitions.


{marker description}{...}
{title:Description}

{p 4 4 2}
Pointers are objects that contain the addresses of other objects.
The {cmd:*} prefix operator obtains the contents of an address.
Thus if {it:p} is a pointer, {cmd:*}{it:p} refers to the contents of 
the object to which {it:p} points.
Pointers are an advanced programming concept.  Most programs,
including involved and complicated ones, can be written without them.

{p 4 4 2}
In Mata, pointers are commonly used to

{p 8 12 2}
1.  put a collection of objects under one name and

{p 8 12 2}
2.  pass functions to functions.

{p 4 4 2}
One need not understand everything about pointers merely to pass 
functions to functions; see {bf:{help m2_ftof:[M-2] ftof}}.  

{pstd}
For a more detailed description of pointers, see
{help m2_pointers##gould2018sp:Gould (2018)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 pointersRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_pointers##remarks1:What is a pointer?}
	{help m2_pointers##remarks2:Pointers to variables}
	{help m2_pointers##remarks3:Pointers to expressions}
	{help m2_pointers##remarks4:Pointers to functions}
	{help m2_pointers##remarks5:Pointers to pointers}
	{help m2_pointers##remarks6:Pointer arrays}
	{help m2_pointers##remarks7:Mixed pointer arrays}
	{help m2_pointers##remarks8:Definition of NULL}
	{help m2_pointers##remarks9:Use of parentheses}
	{help m2_pointers##remarks10:Pointer arithmetic}
	{help m2_pointers##remarks11:Listing pointers}
	{help m2_pointers##remarks12:Declaration of pointers}
	{help m2_pointers##remarks13:Use of pointers to collect objects}
	{help m2_pointers##remarks14:Efficiency}


{marker remarks1}{...}
{title:What is a pointer?}

{p 4 4 2}
A pointer is the address of a variable or a function.  Say that
variable {it:X} contains a matrix.  Another variable {it:p} might contain
137,799,016, and if 137,799,016 were the address at which {it:X} were stored,
then {it:p} would be said to point to {it:X}.  Addresses are seldom written in
base 10, so rather than saying {it:p} contains 137,799,016, we would be
more likely to say that {it:p} contains 0x836a568, which is the way we write
numbers in base 16.  Regardless of how we write addresses, however, {it:p}
contains a number and that number corresponds to the address of another
variable.

{p 4 4 2}
In our program, if we refer to {it:p}, we are referring to {it:p}'s contents,
the number 0x836a568.  The monadic operator {cmd:*} is defined as "refer to the
contents of the address" or "dereference":  {cmd:*}{it:p} means {it:X}.  We
could code {cmd:Y = *p} or {cmd:Y = X}, and either way, we would obtain the
same result.  In our program, we could refer to
{it:X}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} or
{cmd:(*}{it:p}{cmd:)[}{it:i}{cmd:,}{it:j}{cmd:]}, and either way, we would
obtain the {it:i}, {it:j} element of {it:X}.

{p 4 4 2}
The monadic operator {cmd:&} is how we put addresses into {it:p}.  To load
{it:p} with the address of {it:X}, we code {it:p} {cmd:=} {cmd:&}{it:X}.

{p 4 4 2}
The special address 0 (zero, written in hexadecimal as 0x0), also known as
{cmd:NULL}, is how we record that a pointer variable points to nothing.  A
pointer variable contains {cmd:NULL} or it contains the address of another
variable.

{p 4 4 2}
Or it contains the address of a function.  Say that {it:p} contains
0x836a568 and that 0x836a568, rather than being the address of matrix {it:X},
is the address of function {it:f}().  To get the address of {it:f}() into
{it:p}, just as we coded {it:p} {cmd:=} {cmd:&}{it:X} previously, we code
{it:p} {cmd:=} {cmd:&}{it:f}{cmd:()}.  The {cmd:()} at the end tells {cmd:&}
that we want the address of a function.  We code {cmd:()} on the 
end regardless of the number of arguments {it:f}() requires because we are 
not executing {it:f}(), we are just obtaining its address.

{p 4 4 2}
To execute the function at 
0x836a568 -- now we will assume that {it:f}() takes two arguments and 
call them {it:i} and {it:j} -- 
we code {cmd:(*}{it:p}{cmd:)(}{it:i}{cmd:,}{it:j}{cmd:)}
just as we coded
{cmd:(*}{it:p}{cmd:)[}{it:i}{cmd:,}{it:j}{cmd:]} 
when {it:p} contained the address of matrix {it:X}.


{marker remarks2}{...}
{title:Pointers to variables}

{p 4 4 2}
To create a pointer {it:p} to a variable, you code

	{it:p} {cmd:=} {cmd:&}{it:varname}

{p 4 4 2}
For instance, if {it:X} is a matrix, 

	{it:p} {cmd:=} {cmd:&}{it:X}

{p 4 4 2}
stores in {it:p} the address of {it:X}.  Subsequently, referring to 
{cmd:*}{it:p} and referring to {it:X} amount to the same thing.  
That is, if {it:X} contained a 3 {it:x} 3 identity matrix and you 
coded 

	{cmd:*}{it:p}{cmd: = Hilbert(4)}

{p 4 4 2}
then after that you would find that {it:X} contained the 4 {it:x} 4 Hilbert
matrix.  {it:X} and {cmd:*}{it:p} are the same matrix.

{p 4 4 2}
If {it:X} contained a 3 {it:x} 3 identity matrix and you coded

	{cmd:(*}{it:p}{cmd:)[2,3] = 4} 

{p 4 4 2}
you would then find {it:X}{cmd:[2,3]} equal to 4.

{p 4 4 2}
You cannot, however, point to the interior of objects.  That is, you cannot
code

	{it:p} {cmd:=} {cmd:&}{it:X}{cmd:[2,3]}

{p 4 4 2}
and get a pointer that is equivalent to {it:X}{cmd:[2,3]} in the 
sense that if you later coded {cmd:*}{it:p}{cmd:=2}, you would see the change
reflected in {it:X}{cmd:[2,3]}.  The statement {it:p} {cmd:=}
{cmd:&}{it:X}{cmd:[2,3]} is valid, but what it does, we will explain in
{it:{help m2_pointers##remarks3:Pointers to expressions}} below.

{p 4 4 2}
By the way, variables can be sustained by being pointed to.
Consider the program 

	{cmd}pointer(real matrix) scalar example(real scalar n) 
	{
		real matrix	tmp

		tmp = I(3)
		return(&tmp)
	}{txt}

{p 4 4 2}
Ordinarily, variable {cmd:tmp} would be destroyed when {cmd:example()} 
concluded execution.  Here, however, {cmd:tmp}'s existence 
will be sustained because of the pointer to it.  We might code 

	{it:p}{cmd: = example(3)}

{p 4 4 2}
and the result will be to create {cmd:*}{it:p} containing the 3 {it:x} 3
identity matrix.  The memory consumed by that matrix will be freed when 
it is no longer being pointed to, which will occur when {it:p} itself 
is freed, or, before that, when the value of {it:p} is changed, perhaps by

	{it:p} {cmd:= NULL}

{pstd}
For a discussion of pointers to structures, see
{helpb m2_struct:[M-2] struct}.
For a discussion of pointers to classes, see
{helpb m2_class:[M-2] class}.

{marker remarks3}{...}
{title:Pointers to expressions}

{p 4 4 2}
You can code 

	{it:p} {cmd:= &(2+3)}

{p 4 4 2}
and the result will be to create {cmd:*}{it:p} containing 5.  
Mata creates a temporary variable to contain the evaluation of the 
expression and sets {it:p} to the address of the temporary variable.
That temporary variable will be freed when {it:p} is freed or, before 
that, when the value of {it:p} is changed, just as {cmd:tmp} was 
freed in the example in the previous section.

{p 4 4 2}
When you code 

	{it:p} {cmd:=} {cmd:&}{it:X}{cmd:[2,3]}

{p 4 4 2}
the result is the same.  The expression is evaluated and the result of the
expression stored in a temporary variable.  That is why subsequently coding
{cmd:*}{it:p}{cmd:=2} does not change {it:X}{cmd:[2,3]}.  All
{cmd:*}{it:p}{cmd:=2} does is change the value of the temporary variable.

{p 4 4 2}
Setting pointers equal to the value of expressions can be useful.
In the following code fragment, we create {it:n} 5 {it:x} 5 matrices
for later use:

	{cmd}pvec = J(1, n, NULL)
	for (i=1; i<=n; i++) pvec[i] = &(J(5, 5, .)){txt}


{marker remarks4}{...}
{title:Pointers to functions}

{p 4 4 2}
When you code 

	{it:p} {cmd:= &}{it:functionname}{cmd:()}

{p 4 4 2}
the address of the function is stored in {it:p}.  You can later execute 
the function by coding 

	... {cmd:(*}{it:p}{cmd:)(}...{cmd:)}

{p 4 4 2}
Distinguish carefully between 

	{it:p} {cmd:= &}{it:functionname}{cmd:()}

{p 4 4 2}
and 

	{it:p} {cmd:= &(}{it:functionname}{cmd:())}

{p 4 4 2}
The latter would execute {it:functionname}() with no arguments and then 
assign the returned result to a temporary variable.

{p 4 4 2}
For instance, assume that you wish to write a function {cmd:neat()} that will
calculate the derivative of another function, which function you will pass to
{cmd:neat()}.  Your function, we will pretend, returns a real scalar.

{p 4 4 2}
You could do that as follows

	{cmd:real scalar neat(pointer(function) p,} {it:other args}...{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
although you could be more explicit as to the characteristics of the 
function you are passed:

	{cmd:real scalar neat(pointer(real scalar function) p,} {it:other args}...{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
In any case, inside the body of your function, where you want to call 
the passed function, you code 

		{cmd:(*p)(}{it:arguments}{cmd:)}

{p 4 4 2}
For instance, you might code 

		{cmd:approx = ( (*p)(x+delta)-(*p)(x) ) / delta}

{p 4 4 2}
The caller of your {cmd:neat()} function, wanting to use it with, say, 
function {cmd:zeta_i_just_wrote()}, would code

		{it:result} {cmd:= neat(&zeta_i_just_wrote(),} {it:other args}...{cmd:)}


{marker remarks5}{...}
{title:Pointers to pointers}

{p 4 4 2}
Pointers to pointers (to pointers ...) are allowed, for instance, 
if {it:X} is a matrix

	{it:p1}{cmd: = &X}
	{it:p2}{cmd: = &p1}

{p 4 4 2}
Here {cmd:*}{it:p2} is equivalent to {it:p1}, and 
{cmd:**}{it:p2} is equivalent to {it:X}.

{p 4 4 2}
Similarly, we can construct a pointer to a pointer to a function:

	{it:q1}{cmd: = &}{it:f}{cmd:()}
	{it:q2}{cmd: = &q1}

{p 4 4 2}
Here {cmd:*}{it:q2} is equivalent to {it:q1}, and 
{cmd:**}{it:q2} is equivalent to {it:f}().
	
{p 4 4 2}
When constructing pointers to pointers, never type {cmd:&&} -- such as
{cmd:&&}{it:x} -- to obtain the address of the address of {it:x}.  Type
{cmd:&(&}{it:x}{cmd:)} or {cmd:& &}{it:x}.  {cmd:&&} is a synonym for {cmd:&},
included for those used to coding in C.


{marker remarks6}{...}
{title:Pointer arrays}

{p 4 4 2}
You may create an array of pointers, such as 

	{it:P}{cmd: = (&}{it:X1}{cmd:, &}{it:X2}{cmd:, &}{it:X3}{cmd:)}

{p 4 4 2}
or

	{it:Q}{cmd: = (&}{it:f1}{cmd:(), &}{it:f2}{cmd:(), &}{it:f3}{cmd:())}

{p 4 4 2}
Here 
{cmd:*}{it:P}{cmd:[2]} is equivalent to {it:X2} and 
{cmd:*}{it:Q}{cmd:[2]} is equivalent to {it:f2}().


{marker remarks7}{...}
{title:Mixed pointer arrays}

{p 4 4 2}
You may create mixed pointer arrays, such as 

	{it:R}{cmd: = (&}{it:X}{cmd:, &}{it:f}{cmd:())}

{p 4 4 2}
Here 
{cmd:*}{it:R}{cmd:[2]} is equivalent to {it:f}().

{p 4 4 2}
You may not, however, create arrays of pointers mixed with real, complex,
or string elements.  Mata will abort with a type-mismatch error.


{marker remarks8}{...}
{title:Definition of NULL}

{p 4 4 2}
{cmd:NULL} is the special pointer value that means "points to nothing" or 
undefined.  {cmd:NULL} is like 0 in many ways -- for instance, coding 
{cmd:if (X)} is equivalent to coding {cmd:if (X!=NULL)}, but {cmd:NULL}
is distinct from zero in other ways.  0 is a numeric value; {cmd:NULL} is 
a pointer value.


{marker remarks9}{...}
{title:Use of parentheses}

{p 4 4 2}
Use parentheses to make your meaning clear.  

{p 4 4 2}
In the table below, we assume 

	{it:p} {cmd:= &}{it:X}

	{it:P} {cmd:= (&}{it:X11}{cmd:, &}{it:X12}{cmd: \ &}{it:X21}{cmd:, &}{it:X22}{cmd:)}

	{it:q} {cmd:= &}{it:f}{cmd:()}

	{it:Q} {cmd:= (&}{it:f11}{cmd:(), &}{it:f12}{cmd:() \ &}{it:f21}{cmd:(), &}{it:f22}{cmd:())}

{p 4 4 2}
where 
{it:X}, 
{it:X11}, 
{it:X12}, 
{it:X21}, and
{it:X22} 
are matrices and 
{it:f}(), 
{it:f11}(), 
{it:f12}(), 
{it:f21}(), and
{it:f22}() 
are functions.


	Expression        Meaning
	{hline 64}
	{cmd:*}{it:p}                {it:X}
	{cmd:*}{it:p}{cmd:[1,1]}           {it:X}
	{cmd:(*}{it:p}{cmd:)[1,1]}         {it:X}{cmd:[1,1]}

	{cmd:*}{it:P}{cmd:[1,2]}           {it:X12}
	{cmd:(*}{it:P}{cmd:[1,2])[3,4]}    {it:X12}{cmd:[3,4]}

	{cmd:*}{it:q}{cmd:(a,b)}           execute function {it:q}{cmd:()} of {cmd:a}, {cmd:b}; dereference that
	{cmd:(*}{it:q}{cmd:)(a,b)}         {it:f}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}
	{cmd:(*}{it:q}{cmd:[1,1])(a,b)}    {it:f}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}

	{cmd:*}{it:Q}{cmd:[1,2](a,b)}      nonsense
	{cmd:(*}{it:Q}{cmd:[1,2])(a,b)}    {it:f12}{cmd:(}{it:a}{cmd:,}{it:b}{cmd:)}
	{hline 64}


{marker remarks10}{...}
{title:Pointer arithmetic}

{p 4 4 2}
Arithmetic with pointers (which is to say, with addresses) is not allowed:

	: {cmd:y = 2}
	: {cmd:x = &y}
	: {cmd:x+2}
                  {err:<stmt>:  3212  undefined operation on pointer}

{p 4 4 2}
Do not confuse the expression {cmd:x+2} with the expression {cmd:*x+2}, which
is allowed and in fact evaluates to 4.

{p 4 4 2}
You may use the equality and inequality operators {cmd:==} and {cmd:!=} with
pairs of pointer values:

	{cmd}if (p1 == p2) {c -(} 
		...
	{c )-}

	if (p1 != p2) {c -(}
		...
	{c )-}{txt}

{p 4 4 2}
Also pointer values may be assigned and compared with the value
{cmd:NULL}, which is much like, but still different from, zero:  {cmd:NULL} is
a 1 {it:x} 1 scalar containing an address value of 0.  An unassigned pointer
has the value {cmd:NULL}, and you may assign the value {cmd:NULL} to pointers:

	{cmd:p = NULL}

{p 4 4 2}
Pointer values may be compared with {cmd:NULL}, 

	{cmd}if (p1 == NULL) {c -(} 
		...
	{c )-}

	if (p1 != NULL) {c -(}
		...
	{c )-}{txt}

{p 4 4 2}
but if you attempt to dereference a {cmd:NULL} pointer, you will get an error:

	: {cmd:x = NULL}
	: {cmd:*x + 2}
                  {err:<stmt>:  3120  attempt to dereference NULL pointer}

{p 4 4 2}
Concerning logical expressions, you may directly examine pointer values:

	{cmd}if (p1) {c -(} 
		...
	{c )-}{txt}

{p 4 4 2}
The above is interpreted as if {cmd:if (p1!=NULL)} were coded.


{marker remarks11}{...}
{title:Listing pointers}

{p 4 4 2}
You may list pointers:

	: {cmd:y = 2}
	: {cmd:x = &y}
	: {cmd:x}
	  {cmd:0x8359e80}

{p 4 4 2}
What is shown, 0x8359e80, is the memory address of {cmd:y} during our 
Stata session.  If you typed the above lines, the address you would see could
differ, but that does not matter.

{p 4 4 2}
Listing the value of pointers often helps in debugging because, by comparing
addresses, you can determine where pointers are pointing and whether some 
are pointing to the same thing.

{p 4 4 2}
In listings, {cmd:NULL} is presented as 0x0.


{marker remarks12}{...}
{title:Declaration of pointers}

{p 4 4 2}
Declaration of pointers, as with all declarations (see 
{bf:{help m2_declarations:[M-2] Declarations}}),
is optional.  That basic syntax is 

{p 8 12 2}
{cmd:pointer}[{cmd:(}{it:totype}{cmd:)}]
{it:orgtype}
[{cmd:function}]
...

{p 4 4 2}
For instance, 

	{cmd:pointer(real matrix) scalar} {it:p1}

{p 4 4 2}
declares that {it:p1} is a pointer scalar and that it points to a 
real matrix, and     

	{cmd:pointer(complex colvector) rowvector} {it:p2}

{p 4 4 2}
declares that {it:p2} is a rowvector of pointers and that each 
pointer points to a complex colvector, and

	{cmd:pointer(real scalar function) scalar} {it:p3}

{p 4 4 2}
declares that {it:p3} is a pointer scalar and that it points to a 
function that returns a real scalar, and 

	{cmd:pointer(pointer(real matrix function) rowvector) colvector} {it:p4}

{p 4 4 2}
declares that {it:p4} is a colvector of pointers to pointers, the pointers
to which each element points are rowvectors, and each of those elements 
points to a function returning a real matrix.

{p 4 4 2}
You can omit the pieces you wish.

	{cmd:pointer() scalar} {it:p5}

{p 4 4 2}
declares that {it:p5} is a pointer scalar -- to what being uncertain.

	{cmd:pointer scalar} {it:p5}

{p 4 4 2}
means the same thing.

	{cmd:pointer} {it:p6}

{p 4 4 2}
declares that {it:p6} is a pointer, but whether it is a matrix, vector, or 
scalar, is unsaid.


{marker remarks13}{...}
{title:Use of pointers to collect objects}

{p 4 4 2}
Assume that you wish to write a function in two parts:  {cmd:result_setup()} and
{cmd:repeated_result()}.

{p 4 4 2}
In the first part, {cmd:result_setup()}, you will be passed a matrix and a
function by the user, and you will make a private calculation that you will
use later, each time {cmd:repeated_result()} is called.
When {cmd:repeated_result()} is called, you will need to know the matrix, 
the function, and the value of the private calculation that you previously
made.

{p 4 4 2}
One solution is to adopt the follow design.  You request the user code

	{cmd:resultinfo = result_setup(}{it:setup args}...{cmd:)}

{p 4 4 2}
on the first call, and 

	{it:value} {cmd:= repeated_result(resultinfo,} {it:other args}...{cmd:)}

{p 4 4 2}
on subsequent calls.  The design is that you will pass the information between
the two functions in {cmd:resultinfo}.  
Here {cmd:resultinfo} will need to contain three things:  the
original matrix, the original function, and the private result you
calculated.  The user, however, never need know the details, and you will
simply request that the user declare {cmd:resultinfo} as a pointer vector.

{p 4 4 2}
Filling in the details, you code

	{cmd}pointer vector result_setup(real matrix X, pointer(function) f)
	{c -(}
		real matrix     privmat
		pointer vector  info

		...
		privmat = ...
		...
		info = (&X, f, &privmat)
		return(info)
	{c )-}

	real matrix repeated_result(pointer vector info, ...)
	{c -(}
		pointer(function) scalar   f
		pointer(matrix)   scalar   X
		pointer(matrix)   scalar   privmat

		f = info[2]
		X = info[1]
		privmat = info[3]
		
		... 
		... (*f)(...) ...
		... (*X) ...
		... (*privmat) ...
		...
	{c )-}{txt}

{p 4 4 2}
It was not necessary to unload {cmd:info[]} into the 
individual scalars.  The lines using the passed values could just as well 
have read

		... {cmd:(*info[2])(}...{cmd:)} ...
		... {cmd:(*info[1])} ...
		... {cmd:(*info[3])} ...


{marker remarks14}{...}
{title:Efficiency}

{p 4 4 2}
When calling subroutines, it is better to pass the evaluation of pointer
scalar arguments rather than the pointer scalar itself, because then the
subroutine can run a little faster.  Say that {cmd:p} points to 
a real matrix.  It is better to code 

		... {cmd:mysub(*p)} ...

{p 4 4 2}
rather than 

		... {cmd:mysub(p)} ...

{p 4 4 2}
and then to write {cmd:mysub()} as 

	{cmd:function mysub(real matrix X)}
	{cmd:{c -(}}
		... {cmd:X} ...
	{cmd:{c )-}}

{p 4 4 2}
rather than 

	{cmd:function mysub(pointer(real matrix) scalar p)}
	{cmd:{c -(}}
		... {cmd:(*p)} ...
	{cmd:{c )-}}

{p 4 4 2}
Dereferencing a pointer (obtaining {cmd:*}{it:p} from {it:p}) does not 
take long, but it does take time.
Passing {cmd:*}{it:p} rather than {it:p} can be important if 
{cmd:mysub()} loops and performs the evaluation of {cmd:*}{it:p} 
hundreds of thousands or millions of times.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The prefix operator {cmd:*} 
(called the dereferencing operator) aborts with error if it is applied to a
nonpointer object.

{p 4 4 2}
Arithmetic may not be performed on undereferenced pointers.  Arithmetic 
operators abort with error.

{p 4 4 2}
The prefix operator {cmd:&} aborts with error if it is applied to a
built-in function.
{p_end}


{marker references}{...}
{title:References}

{marker gould2018sp}{...}
{phang}
Gould, W. W. 2018.
{browse "http://www.stata-press.com/books/mata-book/":{it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}}.
College Station, TX: Stata Press.

{phang}
St{c o/}vring, H. 2007.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0034":A generic function evaluator implemented in Mata}.
{it:Stata Journal} 7: 542-555.
{p_end}
