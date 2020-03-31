{smcl}
{* *! version 1.1.10  15may2018}{...}
{vieweralsosee "[M-2] Syntax" "mansection M-2 Syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_syntax##syntax"}{...}
{viewerjumpto "Description" "m2_syntax##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_syntax##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_syntax##remarks"}{...}
{viewerjumpto "Reference" "m2_syntax##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-2] Syntax} {hline 2}}Mata language grammar and syntax
{p_end}
{p2col:}({mansection M-2 Syntax:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
The basic language syntax is

	{it:istmt} 

{p 4 4 2} where

{col 9}{it:istmt} :={col 25}{it:stmt}
{col 25}{cmd:function} {it:name}{cmd:(}{it:farglist}{cmd:)} {it:fstmt}
{col 25}{it:ftype} {it:name}{cmd:(}{it:farglist}{cmd:)} {it:fstmt}
{col 25}{it:ftype} {cmd:function} {it:name}{cmd:(}{it:farglist}{cmd:)} {it:fstmt}

{col 9}{it:stmt} :={col 25}{it:nothing}
{col 25}{cmd:;}{col 55}(meaning {it:nothing})
{col 25}{cmd:version} {it:number}
{col 25}{cmd:{c -(}} {it:stmt} ... {cmd:{c )-}}
{col 25}{it:exp}
{col 25}{cmd:pragma} {it:pstmt}
{col 25}{cmd:if (}{it:exp}{cmd:)} {it:stmt} 
{col 25}{cmd:if (}{it:exp}{cmd:)} {it:stmt} {cmd:else} {it:stmt}
{col 25}{cmd:for (}{it:exp}{cmd:;}{it:exp}{cmd:;}{it:exp}{cmd:)} {it:stmt}
{col 25}{cmd:while (}{it:exp}{cmd:)} {it:stmt} 
{col 25}{cmd:do} {it:stmt} {cmd:while (}{it:exp}{cmd:)}
{col 25}{cmd:break}
{col 25}{cmd:continue}
{col 25}{it:label}{cmd::}
{col 25}{cmd:goto} {it:label}
{col 25}{cmd:return} 
{col 25}{cmd:return(}{it:exp}{cmd:)}
			
{col 9}{it:fstmt} :={col 25}{it:stmt}
{col 25}{it:type} {it:arglist}
{col 25}{cmd:external} {it:type} {it:arglist}

{col 9}{it:arglist} :={col 25}{it:name}
{col 25}{it:name}{cmd:()}
{col 25}{it:name}{cmd:,} {it:arglist}
{col 25}{it:name}{cmd:(),} {it:arglist}

{col 9}{it:farglist} :={col 25}{it:nothing}
{col 25}{it:efarglist}
		
{col 9}{it:efarglist} :={col 25}{it:felement}
{col 25}{it:felement}{cmd:,} {it:efarglist}
{col 25}{cmd:|} {it:felement}
{col 25}{cmd:|} {it:felement}{cmd:,} {it:efarglist}

{col 9}{it:felement} :={col 25}{it:name}
{col 25}{it:type} {it:name}
{col 25}{it:name}{cmd:()}
{col 25}{it:type} {it:name}{cmd:()}

{col 9}{it:ftype} :={col 25}{it:type}
{col 25}{cmd:void}

{col 9}{it:type} :={col 25}{it:eltype}
{col 25}{it:orgtype}
{col 25}{it:eltype orgtype}

{col 9}{it:eltype} :={col 25}{cmd:transmorphic}
{col 25}{cmd:string}
{col 25}{cmd:numeric}
{col 25}{cmd:real}
{col 25}{cmd:complex}
{col 25}{cmd:pointer}
{col 25}{cmd:pointer(}{it:ptrtype}{cmd:)}

{col 9}{it:orgtype} :={col 25}{cmd:matrix}
{col 25}{cmd:vector}
{col 25}{cmd:rowvector}
{col 25}{cmd:colvector}
{col 25}{cmd:scalar}

{col 9}{it:ptrtype} :={col 25}{it:nothing}
{col 25}{it:type}
{col 25}{it:type} {cmd:function}
{col 25}{cmd:function}

{col 9}{it:pstmt} :={col 25}{cmd:unset} {it:name}
{col 25}{cmd:unused} {it:name}

{col 9}{it:name} :={col 25}identifier up to 32 characters long

{col 9}{it:label} :={col 25}identifier up to 8 characters long

{col 9}{it:exp} :={col 25}expression as defined in {bf:{help m2_exp:[M-2] exp}}


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata is a C-like compiled-into-pseudocode language with matrix extensions 
and run-time linking.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 SyntaxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_syntax##remarks1:Treatment of semicolons}
	{help m2_syntax##remarks2:Types and declarations}
	{help m2_syntax##remarks3:Void matrices}
	{help m2_syntax##remarks4:Void functions}
	{help m2_syntax##remarks5:Operators}
	{help m2_syntax##remarks6:Subscripts}
	{help m2_syntax##remarks7:Implied input tokens}
	{help m2_syntax##remarks8:Function argument-passing convention}
	{help m2_syntax##remarks9:Passing functions to functions}
	{help m2_syntax##remarks10:Optional arguments}

{pstd}After reading {bf:{help m2_syntax:[M-2] Syntax}}, see
{bf:{help m2_intro:[M-2] Intro}} for a list of entries that give more
explanation of what is discussed here.


{marker remarks1}{...}
{title:Treatment of semicolons}

{p 4 4 2}
Semicolon ({cmd:;}) is treated as a line separator.  It is not required, but
it may be used to place two statements on the same physical line:

{col 9}{cmd:x = 1 ; y = 2 ;}

{p 4 4 2}
The last semicolon in the above example is unnecessary but allowed.

{p 4 4 2}
Single statements may continue onto more than one line if the continuation is
obvious.  Take "obvious" to mean that there is a hanging open parenthesis or
a hanging dyadic operator; for example,

	{cmd:x = (}
	       {cmd:3)}

	{cmd:x = x +}
		{cmd: 2}

{p 4 4 2}
See {bf:{help m2_semicolons:[M-2] Semicolons}} for more information.
			

{marker remarks2}{...}
{title:Types and declarations}

{p 4 4 2}
The {it:type} of a variable or function is described by 

		{it:eltype} {it:orgtype} 

{p 4 4 2}
where {it:eltype} and {it:orgtype} are each one of

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
For example, a variable might be {cmd:real} {cmd:scalar}, or 
{cmd:complex} {cmd:matrix}, or {cmd:string} {cmd:vector}.

{pstd}
Mata also has structures -- the {it:eltype} is {cmd:struct} {it:name} -- but
these are not discussed here.  For a discussion
of structures, see {helpb m2_struct:[M-2] struct}.

{pstd}
Mata also has classes -- the {it:eltype} is {cmd:class} {it:name} -- but
these are not discussed here.  For a discussion
of classes, see {helpb m2_class:[M-2] class}.

{p 4 4 2}
Declarations are optional.  When the {it:type} of a variable or function is
not declared, it is assumed to be a {cmd:transmorphic matrix}.  In particular:

{p 8 12 2}
1.  {it:eltype} specifies the type of the elements.
    When {it:eltype} is not specified, {cmd:transmorphic} is assumed.  

{p 8 12 2}
2.  {it:orgtype} specifies the organization of the elements.
    When {it:orgtype} is not specified, {cmd:matrix} is assumed.  

{p 4 4 2}
All {it:types} are special cases of {cmd:transmorphic} {cmd:matrix}.

{p 4 4 2}
The nesting of {it:eltypes} is

			           {cmd:transmorphic}
		                        {c |}
			{c TLC}{hline 15}{c +}{hline 13}{c TRC}
			{c |}               {c |}             {c |}
		     {cmd:numeric         string        pointer}
	                {c |}
		{c TLC}{hline 13}{c TRC}
		{c |}             {c |}
	      {cmd:real         complex}

{p 4 4 2}
{it:orgtypes} amount to nothing more than a constraint on the number of 
rows and columns of a matrix:

		{it:orgtype}            Constraint
		{hline 49}
		{cmd:matrix}             {it:r}>=0 & {it:c}>=0
		{cmd:vector}             {it:r}=1  & {it:c}>=0  -or-  {it:r}>=0 & {it:c}=1
		{cmd:rowvector}          {it:r}=1  & {it:c}>=0 
		{cmd:colvector}          {it:r}>=0 & {it:c}=1
		{cmd:scalar}             {it:r}=1  & {it:c}=1
		{hline 49}

{p 4 4 2}
See {bf:{help m2_declarations:[M-2] Declarations}}.


{marker remarks3}{...}
{title:Void matrices}

{p 4 4 2}
A matrix (vector, row vector, or column vector) that is 0 {it:x} 0, 
{it:r} {it:x} 0, or 0 {it:x} {it:c} is said to be void;
see {bf:{help m2_void:[M-2] void}}.

{p 4 4 2}
The function {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)} 
returns an {it:r} {it:x} {it:c} matrix with each element containing 
{it:val}; see {bf:{help mf_j:[M-5] J()}}.

{p 4 4 2}
{cmd:J()} can be used to create void matrices.

{p 4 4 2}
See {bf:{help m2_void:[M-2] void}}.


{marker remarks4}{...}
{title:Void functions}

{p 4 4 2}
Rather than {it:eltype} {it:orgtype}, a function can be declared to return 
nothing by being declared to return {cmd:void}:

	{cmd}void function example(matrix A)
	{
		real scalar	i

		for (i=1; i<=rows(A); i++) A[i,i] = 1
	}{txt}

{p 4 4 2}
A function that returns nothing (does not include a
{cmd:return(}{it:exp}{cmd:)} statement), in fact returns {cmd:J(0, 0, .)}, and
the above function could equally well be coded as

	{cmd}void function example(matrix A)
	{
		real scalar	i

		for (i=1; i<=rows(A); i++) A[i,i] = 1
		return(J(0, 0, .))
	}{txt}

{p 4 4 2}
or

	{cmd}void function example(matrix A)
	{
		real scalar	i

		for (i=1; i<=rows(A); i++) A[i,i] = 1
		return(J(0,0,.))
	}{txt}

{p 4 4 2}
Therefore, {cmd:void} also is a special case of {cmd:transmorphic} {cmd:matrix} 
(it is in fact a {bind:0 {it:x} 0} {cmd:real} {cmd:matrix}).  Because
declarations are optional (but recommended both for reasons of style and for
reasons of efficiency), the above function could also be coded as

	{cmd}function example(A)
	{
		for (i=1; i<=rows(A); i++) A[i,i] = 1
	}{txt}

{p 4 4 2}
See {bf:{help m2_declarations:[M-2] Declarations}}.


{marker remarks5}{...}
{title:Operators}

{p 4 4 2}
Mata provides the usual assortment of operators; see 
{bf:{help m2_exp:[M-2] exp}}.

{p 4 4 2}
The monadic prefix operators are

	{cmd:-    !    ++    --    &    *}

{p 4 4 2}
Prefix operators {cmd:&} and {cmd:*} have to do with pointers; 
see {bf:{help m2_pointers:[M-2] pointers}}.

{p 4 4 2}
The monadic postfix operators are

	{cmd:'    ++   --}

{p 4 4 2}
Note the inclusion of postfix operator {cmd:'} for transposition.  
Also, for {it:Z} complex, {it:Z}{cmd:'} returns 
the conjugate transpose.  If you want the transposition without 
conjugation, see 
{bf:{help mf_transposeonly:[M-5] transposeonly()}}.

{p 4 4 2}
The dyadic operators are

	{cmd:= ?  \  ::  ,  ..  |  &  ==  >=  <=  <  >  !=  +  -  *  #  ^}

{p 4 8 2}
Also, {cmd:&&} and {cmd:||} are included as synonyms for
{cmd:&} and {cmd:|}.

{p 4 4 2}
The operators {cmd:==} and {cmd:!=} do not require conformability, nor do they
require that the matrices be of the same type.  In such cases, the matrices
are unequal ({cmd:==} is false and {cmd:!=} is true).  For complex arguments,
{cmd:<}, {cmd:<=}, {cmd:>}, and {cmd:>=} refer to length of the complex vector.
{cmd:==} and {cmd:!=}, however, refer not to length but to actual components.
See {bf:{help m2_op_logical:[M-2] op_logical}}.

{p 4 4 2}
The operators {cmd:,} and {cmd:\} are the row-join and column-join operators.
{cmd:(1,2,3)} constructs the row vector (1,2,3).
{cmd:(1\2\3)} constructs the column vector (1,2,3){cmd:'}.
{cmd:(1,2\3,4)} constructs the matrix with first row (1,2) and second row (3,4).
{it:a}{cmd:,}{it:b} joins two scalars, vectors, or matrices rowwise.
{it:a}{cmd:\}{it:b} joins two scalars, vectors, or matrices columnwise.
See {bf:{help m2_op_join:[M-2] op_join}}.

{p 4 4 2}
{cmd:..} and {cmd:::} refer to the row-to and column-to operators.
    {cmd:1..5} is (1,2,3,4,5).
    {cmd:1::5} is (1\2\3\4\5).
    {cmd:5..1} is (5,4,3,2,1).
    {cmd:5::1} is (5\4\3\2\1).
    See {bf:{help m2_op_range:[M-2] op_range}}.

{p 4 4 2}
For 
{cmd:|}, 
{cmd:&}, 
{cmd:==}, 
{cmd:>=}, 
{cmd:<=}, 
{cmd:<}, 
{cmd:>}, 
{cmd:!=}, 
{cmd:+}, 
{cmd:-}, 
{cmd:*}, 
{cmd:/}, and
{cmd:^}, 
there is {cmd:}{it::op} at precedence just below {it:op}. 
These operators perform the elementwise operation.  For instance, 
{it:A}{cmd:*}{it:B} refers to matrix multiplication; 
{it:A}{cmd::*}{it:B} refers to elementwise multiplication.
Moreover, "elementwise" is generalized to cases where {it:A} and {it:B} 
do not have the same number of rows and the same number of columns.  For
instance, if {it:A} is a 1 x {it:c} row vector and {it:B} is a 
{it:r} {it:x} {it:c} matrix, then
{it:C}[{it:i},{it:j}] = A[{it:j}]*B[{it:i},{it:j}] is returned.  
See {bf:{help m2_op_colon:[M-2] op_colon}}.


{marker remarks6}{...}
{title:Subscripts}

{p 4 4 2}
{it:A}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]}
returns the {it:i},{it:j} element of {it:A}.

{p 4 4 2}
{it:A}{cmd:[}{it:k}{cmd:]} returns 
{it:A}{cmd:[1,}{it:k}{cmd:]} if {it:A} is 1 {it:x} {it:c} and 
{it:A}{cmd:[}{it:k}{cmd:,1]} if {it:A} is {it:r} {it:x} 1.
That is, in addition to declared vectors, any 
1 {it:x} {it:c} matrix or
{it:r} {it:x} 1 matrix may be subscripted by one index.
Similarly, any vector can be subscripted by two indices.

{p 4 4 2}
{it:i}, {it:j}, and {it:k} may be vectors as well as scalars.
For instance, 
{it:A}{cmd:[(3\4\5), 4]} returns a 3 {it:x} 1 column vector containing rows 3
to 5 of the 4th column.  

{p 4 4 2}
{it:i}, {it:j}, and {it:k} may be missing value.
{it:A}{cmd:[., 4]} returns a column vector of the 4th column of {it:A}.

{p 4 4 2}
The above subscripts are called list-style subscripts.  Mata provides 
a second format called range-style subscripts that is especially useful
for selecting submatrices.  
{it:A}{cmd:[|3,3\5,5|]} returns the 3 {it:x} 3 submatrix of {it:A} starting at
{it:A}{cmd:[3,3]}.

{p 4 4 2}
See {bf:{help m2_subscripts:[M-2] Subscripts}}.


{marker remarks7}{...}
{title:Implied input tokens}

{p 4 4 2}
Before interpreting and compiling a line, Mata makes the following substitutions
to what it sees:

	Input sequence		Interpretation
	{hline 39}
	{cmd:'}{it:name}                   {cmd:'*}{it:name}
	{cmd:[,}                       {cmd:[.,}
	{cmd:,]}                       {cmd:,.]}
	{hline 39}

{p 4 4 2}
Hence, coding {cmd:X'Z} is equivalent to coding {cmd:X'*Z}, and 
coding {cmd:x = z[1,]} is equivalent to coding {cmd:x = z[1,.]}.


{marker remarks8}{...}
{title:Function argument-passing convention}

{p 4 4 2}
Arguments are passed to functions by address, also known as by name or by 
reference.  They are not passed by value.  When you code 

		... {cmd:f(A)} ...

{p 4 4 2}
it is the address of {cmd:A} that is passed to {cmd:f()}, not a copy of the
values in {cmd:A}.  {cmd:f()} can modify {cmd:A}.

{p 4 4 2}
Most functions do not modify their arguments, but some do.
{cmd:lud(}{it:A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:,} {it:p}{cmd:)},
for instance, calculates
the LU decomposition of {it:A}.  The function replaces the contents of {it:L},
{it:U}, and {it:p}
with matrices such that {it:L}{cmd:[}{it:p}{cmd:,]*}{it:U}={it:A}.

{p 4 4 2}
Oldtimers will have heard of the FORTRAN programmer who called 
a subroutine and passed to it a second argument of 1.  Unbeknownst 
to him, the subroutine changed its second argument, with the result that 
the constant 1 was changed throughout the rest of his code.
That cannot happen in Mata.  When an expression is passed as an argument 
(and constants are expressions), a temporary variable containing the 
evaluation is passed to the function.  Modifications to the temporary variable
are irrelevant because the temporary variable is discarded once the function
returns.  Thus if {cmd:f()} modifies its second argument and you call 
it by coding {cmd:f(A,2)}, because 2 is copied to a temporary variable, 
the value of the literal 2 will remain unchanged on the next call. 

{p 4 4 2}
If you call a function with an expression that includes the assignment 
operator, it is the left-hand side of the expression that is passed.
That is, coding 

	{cmd:f(a, b=c)}

{p 4 4 2}
has the same result as coding 

	{cmd:b = c}
	{cmd:f(a, b)}

{p 4 4 2}
If function {cmd:f()} changes its second argument, it will be {cmd:b} and 
not {cmd:c} that is modified.

{p 4 4 2}
Also, Mata attempts not to create unnecessary copies of matrices.  
For instance, consider 

	{cmd:function changearg(x) x[1,1] = 1}

{p 4 4 2}
{cmd:changearg(mymat)} changes the 1,1 element of {cmd:mymat} to 1.
Now let us define

	{cmd:function cp(x) return(x)}

{p 4 4 2}
Coding {cmd:changearg(cp(mymat))} would still change {cmd:mymat} 
because {cmd:cp()} returned {cmd:x} itself.  On the other hand, 
if we defined {cmd:cp()} as 

	{cmd}function cp(x)
	{c -(}
		matrix	t

		t = x
		return(t)
	{c )-}{txt}

{p 4 4 2}
then coding 
{cmd:changearg(cp(mymat))} would not change {cmd:mymat}.  It would change 
a temporary matrix which would be discarded once {cmd:changearg()} returned.


{marker remarks9}{...}
{title:Passing functions to functions}

{p 4 4 2}
One function may receive another function as an argument using pointers.
One codes

	{cmd}function myfunc(pointer(function) f, a, b)
	{c -(}
		{txt:...} (*f)(a) {txt:...} (*f)(b) {txt:...}
	{c )-}{txt}
	
{p 4 4 2}
although the {cmd:pointer(function)} declaration, like all declarations, is
optional.  To call {cmd:myfunc()} and tell it to use function {cmd:prima()}
for {cmd:f()}, and 2 and 3 for {cmd:a} and {cmd:b}, one codes

	{cmd:myfunc(&prima(), 2, 3)}

{p 4 4 2}
See {bf:{help m2_ftof:[M-2] ftof}}
and
{bf:{help m2_pointers:[M-2] pointers}}.


{marker remarks10}{...}
{title:Optional arguments}

{p 4 4 2}
Functions may be coded to allow receiving a variable number of arguments.
This is done by placing a vertical or bar ({cmd:|}) in front of the
first argument that is optional.  For instance, 

	{cmd:function mynorm(matrix A, |scalar power)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
The above function may be called with one matrix or with a matrix 
followed by a scalar.

{p 4 4 2}
The function {cmd:args()} (see {bf:{help mf_args:[M-5] args()}}) can be used
to determine the number of arguments received and set defaults:


	{cmd:function mynorm(matrix A, |scalar power)}
	{cmd:{c -(}}
		...
		{cmd:if (args()==1) power = 2}
		...
	{cmd:{c )-}}

{p 4 4 2}
See {bf:{help m2_optargs:[M-2] optargs}}.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2005.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0017":Mata Matters: Translating Fortran}.
{it:Stata Journal} 5: 421-441.
{p_end}
