{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-1] First" "mansection M-1 First"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Description" "m1_first##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_first##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_first##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-1] First} {hline 2}}Introduction and first session
{p_end}
{p2col:}({mansection M-1 First:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Mata is a component of Stata.  It is a matrix programming language that
can be used interactively or as an extension for do-files and ado-files.
Thus

{phang2}
  1.  Mata can be used by users who want to think in matrix terms and
      perform (not necessarily simple) matrix calculations interactively, and

{phang2}
  2.  Mata can be used by advanced Stata programmers who want to add features
      to Stata.

{pstd}
Mata has something for everybody.  

{pstd}
Primary features of Mata are that it is fast and that it is C-like.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 FirstRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
This introduction is presented under the following headings:

	{help m1_first##remarks1:Invoking Mata}
	{help m1_first##remarks2:Using Mata}
	{help m1_first##remarks3:Making mistakes:  Interpreting error messages}
	{help m1_first##remarks4:Working with real numbers, complex numbers, and strings}
	{help m1_first##remarks5:Working with scalars, vectors, and matrices}
	{help m1_first##remarks6:Working with functions}
	{help m1_first##remarks7:Distinguishing real and complex values}
	{help m1_first##remarks8:Working with matrix and scalar functions}
	{help m1_first##remarks9:Performing element-by-element calculations:  Colon operators}
	{help m1_first##remarks10:Writing programs}
	{help m1_first##remarks11:More functions}
	{help m1_first##remarks12:Mata environment commands}
	{help m1_first##remarks13:Exiting Mata}
	
{pstd}If you are reading the entries in the order suggested in
{bf:{help mata:[M-0] Intro}}, see {bf:{help m1_interactive:[M-1] Interactive}}
next.


{marker remarks1}{...}
{title:Invoking Mata}

{pstd}
To enter Mata, type {cmd:mata} at Stata's dot prompt and press enter; to exit
Mata, type {cmd:end} at Mata's colon prompt:

	. {cmd:mata}{col 48}<- type {cmd:mata} to enter Mata
	{hline 10} mata (type {cmd:end} to exit} {hline 3}
        : {cmd:2+2}{col 48}<- type Mata statements at the
          {res:4}{col 48}   colon prompt

	: {cmd:end}{col 48}<- type {cmd:end} to return to Stata
	{hline 38}

	. _{col 48}<- you are back to Stata


{marker remarks2}{...}
{title:Using Mata}

{pstd}
When you type a statement into Mata, Mata compiles what you typed and, if 
it compiled without error, executes it:

{pstd}

	: {cmd:2+2}
	  4

	: _

{pstd}
We typed {cmd:2+2}, a particular example from the general class of
expressions.  Mata responded with 4, the evaluation of the expression.

{pstd}
Often what you type are expressions, although you will probably choose
more complicated examples.  When an expression is not assigned to a variable,
the result of the expression is displayed.  Assignment is performed by the
{cmd:=} operator:

	: {cmd:x = 2 + 2}

	: {cmd:x}
	  4

	: _

{pstd}
When we type "{cmd:x=2+2}", the expression is evaluated and stored in the
variable we just named {cmd:x}.  The result is not displayed.  We can look at
the contents of {cmd:x}, however, simply by typing "{cmd:x}".  From Mata's
perspective, {cmd:x} is not only a variable but also an expression, albeit
a rather simple one.  Just as {cmd:2+2} says to load 2, load another 2, and
add them, the expression {cmd:x} says to load {cmd:x} and stop there.

{pstd}
As an aside, Mata distinguishes uppercase and lowercase.  {cmd:X} is not
the same as {cmd:x}:

	: {cmd:X = 2 + 3}

	: {cmd:x}
	  4

	: {cmd:X}
	  5


{marker remarks3}{...}
{title:Making mistakes:  Interpreting error messages}

{pstd}
If you make a mistake, Mata complains, and then you continue on your way.
For instance, 

	: {cmd:2,,3}
	{err:invalid expression}
	r(3000);

	: _

{pstd}
"{cmd:2,,3}" makes no sense to Mata, so Mata complained.  This is an example 
of what is called a compile-time error; Mata could not make sense out
of what we typed.

{pstd}
The other kind of error is called a run-time error.  For example, we have no
variable called {cmd:y}.  Let us ask Mata to show us the contents of {cmd:y}:

	: {cmd:y}
	         {err:<istmt>:   3499  y not found}
	r(3499);

	: _

{pstd}
Here what we typed made perfect sense -- show me {cmd:y} -- but
{cmd:y} has never been defined.
This ugly message is called a run-time error message -- see 
{bf:{help m2_errors:[M-2] Errors}}
for a complete description -- but all that's 
important is to understand the difference between

	{err:invalid expression}

{pstd}
    and

	{err:<istmt>:   3499  y not found}

{pstd}
The run-time message is prefixed by an identity ({cmd:<istmt>} here)
and a number (3499 here).  Mata is telling us, "I was executing
your {it:istmt} [that's what everything you type is called] and I got error
3499, the details of which are that I was unable to find {cmd:y}."

{pstd}
The compile-time error message is of a simpler form:  "invalid expression".
When you get such unprefixed error messages, that means Mata could not 
understand what you typed.  When you get the more complicated error 
message, that means Mata understood what you typed, but there was a problem 
performing your request.

{pstd}
Another way to tell the difference between compile-time errors 
and run-time errors is to look at the return code.  Compile-time errors have a
return code of 3000:

	: {cmd:2,,3}
	{err:invalid expression}
	r(3000);

{pstd}
Run-time errors have a return code that might be in the 3000s, but is never 
3000 exactly:

	: {cmd:y}
	         {err:<istmt>:   3499  y not found}
	r(3499);


{pstd}
Whether the error is compile-time or run-time, once the error message is
issued, Mata is ready to continue just as if the error never happened.


{marker remarks4}{...}
{title:Working with real numbers, complex numbers, and strings}

{pstd}
As we have seen, Mata works with real numbers:

	: {cmd:2+3}
	  5

{pstd}
Mata also understands complex numbers; you write the imaginary part 
by suffixing a lowercase {cmd:i}:

	: {cmd:1+2i + 4-1i}
	  5+1i

{pstd}
For imaginary numbers, you can omit the real part:

	: {cmd:1+2i - 2i}
	  1

{pstd}
Whether a number is real or complex, you can use the same computer 
notation for the imaginary part as you would for the real part:

	: {cmd:2.5e+3i}
	  2500i

	: {cmd:1.25e+2+2.5e+3i}              /* i.e., 1.25e+02 + 2.5e+03i */
	 125 + 2500i

{pstd}
We purposely wrote the last example in nearly unreadable form just to 
emphasize that Mata could interpret it.  


{pstd}
Mata also understands strings, which you write enclosed in double quotes:

	: {cmd:"Alpha"+"Beta"}
	  AlphaBeta

{pstd}
Just like Stata, Mata understands simple and compound double quotes:

	: {cmd:`"Alpha"'+`"Beta"'}
	  AlphaBeta

{pstd}
You can add complex and reals,

	: {cmd:1+2i + 3}
	  4+2i

{pstd}
but you may not add reals or complex to strings:

	: {cmd:2 + "alpha"}
	{err:type mismatch:  real + string now allowed}
	r(3000);

{pstd}
We got a run-time error.  Mata understood {cmd:2 + "alpha"}
all right; it just could not perform our request. 


{marker remarks5}{...}
{title:Working with scalars, vectors, and matrices}

{pstd}
In addition to understanding scalars -- be they real, complex, or string --
Mata understands vectors and matrices of real, complex, and string elements:

	: {cmd:x = (1,2)}

	: {cmd:x}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{pstd}
{cmd:x} now contains the row vector (1,2).  We can add vectors:

	: {cmd:x + (3,4)}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}4   6{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{pstd}
The "{cmd:,}" is the
{help m2_op_join:column-join operator}; things like {cmd:(1,2)} are
expressions, just as {cmd:(1+2)} is an expression:

	: {cmd:y = (3,4)}

	: {cmd:z = (x,y)}

	: {cmd:z}
        {res}       {txt}1   2   3   4
            {c TLC}{hline 17}{c TRC}
          1 {c |}  {res}1   2   3   4{txt}  {c |}
            {c BLC}{hline 17}{c BRC}{txt}

{pstd}
In the above, we could have dispensed with the parentheses and typed
"{cmd:y=3,4}" followed by "{cmd:z=x,y}", just as we could using the {cmd:+}
operator, although most people find vectors more readable when enclosed in 
parentheses.

{pstd}
{cmd:\} is the {help m2_op_join:row-join operator}:

	: {cmd:a = (1\2)}

	: {cmd:a}
            {c TLC}{hline 5}{c TRC}
          1 {c |}  {res}1{txt}  {c |}
          2 {c |}  {res}2{txt}  {c |}
            {c BLC}{hline 5}{c BRC}{txt}

	: {cmd:b = (3\4)}

	: {cmd:c = (a\b)}

	: {cmd:c}
        {res}       {txt}1
            {c TLC}{hline 5}{c TRC}
          1 {c |}  {res}1{txt}  {c |}
          2 {c |}  {res}2{txt}  {c |}
          3 {c |}  {res}3{txt}  {c |}
          4 {c |}  {res}4{txt}  {c |}
            {c BLC}{hline 5}{c BRC}

{pstd}
Using the column-join and row-join operators, we can enter matrices:

	: {cmd:A = (1,2 \ 3,4)}

	: {cmd:A}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{pstd}
The use of these operators is not limited to scalars.  Remember,
{cmd:x} is the row vector (1,2), {cmd:y} is the row vector (3,4), {cmd:a} is
the column vector (1\2), and {cmd:b} is the column vector (3\4).  Therefore,

	: {cmd:x\y}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

	: {cmd:a,b}
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   3{txt}  {c |}
          2 {c |}  {res}2   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{pstd}
But if we try something nonsensical, we get an error:

	: {cmd:a,x}
	         {err:<istmt>:  3200  conformability error}


{pstd}
We create complex vectors and matrices just as we create real ones, 
the only difference being that their elements are complex:

	: {cmd:Z = (1+1i, 2+3i \ 3-2i , -1-1i)}

	: {cmd:Z}
        {res}       {txt}      1         2
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 1 + 1i    2 + 3i{txt}  {c |}
          2 {c |}  {res} 3 - 2i   -1 - 1i{txt}  {c |}
            {c BLC}{hline 21}{c BRC}{txt}

{pstd}
Similarly, we can create string vectors and matrices, which are vectors and
matrices with string elements:

        : {cmd:S = ("1st element", "2nd element" \ "another row", "last element")}

	: {cmd:S}
        {res}       {txt}           1              2
            {c TLC}{hline 31}{c TRC}
          1 {c |}  {res} 1st element    2nd element{txt}  {c |}
          2 {c |}  {res} another row   last element{txt}  {c |}
            {c BLC}{hline 31}{c BRC}{txt}

{pstd}
For strings, the individual elements can be up to 2,147,483,647
bytes long.


{marker remarks6}{...}
{title:Working with functions}

{pstd}
Mata's expressions also include functions:

	: {cmd:sqrt(4)}
	  2

	: {cmd:sqrt(-4)}
	  .

{pstd}
When we ask for the square root of -4, Mata replies "{cmd:.}" Further,
{cmd:.} can be stored just like any other number:

	: {cmd:findout = sqrt(-4)}
	
	: {cmd:findout}
	  .

{pstd}
"{cmd:.}" means missing, that there is no answer to our calculation.  Taking
the square root of a negative number is not an error; 
it merely produces missing.  To Mata, missing is a number
like any other number, and the rules for all the operators have been
generalized to understand missing.  For instance, the addition rule is
generalized such that missing plus anything is missing:

	: {cmd:2 + .}
	  .

{pstd}
Still, it should surprise you that Mata produced missing for the
{cmd:sqrt(-4)}.  We said that Mata understands complex numbers, so should
not the answer be 2i?  The answer is that is should be if you are working on
the complex plane, but otherwise, missing is probably a better answer.
Mata attempts to intuit the kind of answer you want by context, and
in particular, uses inheritance rules.  If you ask for the square root of a
real number, you get a real number back.  If you ask for the square root of a
complex number, you get a complex number back:

	: {cmd:sqrt(-4+0i)}
	  2i

{pstd}
Here complex means multipart:  {cmd:-4+0i} is a complex number; it merely
happens to have 0 imaginary part.  Thus:

	: {cmd:areal = -4}

	: {cmd:acomplex = -4 + 0i}

	: {cmd:sqrt(areal)}
	 .

	: {cmd:sqrt(acomplex)}
	  2i

{pstd}
If you ever have a real scalar, vector, or matrix, and want to make it 
complex, use the {cmd:C()} function, which means "convert to complex":

	: {cmd:sqrt(C(areal))}
	  2i

{pstd}
{cmd:C()} is documented in {bf:{help mf_c:[M-5] C()}}.
{cmd:C()} allows one or two arguments.  With one argument, it casts to complex.
With two arguments, it makes a complex out of the two real arguments.  
Thus you could type 

	: {cmd:sqrt(-4+2i)}
	  .485868272 + 2.05817103i

{pstd}
or you could type 

	: {cmd:sqrt(C(-4,2))}
	  .485868272 + 2.05817103i

{pstd}
By the way, used with one argument, {cmd:C()} also allows complex, and then
it does nothing:

	: {cmd:sqrt(C(acomplex))}
	  2i


{marker remarks7}{...}
{title:Distinguishing real and complex values}

{pstd}
It is virtually impossible to tell the difference between a real value 
and a complex value with zero imaginary part:

	: {cmd:areal = -4}

	: {cmd:acomplex = -4 + 0i}

	: {cmd:areal}
	  -4

	: {cmd:acomplex}
	  -4

{pstd}
Yet, as we have seen, the difference is important:  {cmd:sqrt(areal)} is 
missing, {cmd:sqrt(acomplex)} is 2i.  
One solution is the {helpb mf_eltype:eltype()} function:

	: {cmd:eltype(areal)}
	  real

	: {cmd:eltype(acomplex)}
	  complex

{pstd}
{cmd:eltype()} can also be used with strings, 

	: astring = "hello"

	: {cmd:eltype(astring)}
	  string

{pstd}
but this is useful mostly in programming contexts.


{marker remarks8}{...}
{title:Working with matrix and scalar functions}

{pstd}
Some functions are matrix functions:  they require a matrix and 
return a matrix.  Mata's {helpb mf_invsym:invsym({it:X})} is an example of 
such a function.  It returns the matrix that is the inverse of 
symmetric, real matrix {it:X}:

	: {cmd:X = (76, 53, 48 \ 53, 88, 46 \ 48, 46, 63)}

	: {cmd:Xi = invsym(X)}

	: {cmd:Xi}
        {res}{txt}[symmetric]
                          1              2              3
            {c TLC}{hline 46}{c TRC}
          1 {c |}  {res} .0298458083                              {txt}  {c |}
          2 {c |}  {res}-.0098470272    .0216268926               {txt}  {c |}
          3 {c |}  {res}-.0155497706   -.0082885675    .0337724301{txt}  {c |}
            {c BLC}{hline 46}{c BRC}{txt}

	: {cmd:Xi*X}
        {res}       {txt}           1              2              3
            {c TLC}{hline 46}{c TRC}
          1 {c |}  {res}           1   -8.67362e-17   -8.50015e-17{txt}  {c |}
          2 {c |}  {res}-1.38778e-16              1   -1.02349e-16{txt}  {c |}
          3 {c |}  {res}           0    1.11022e-16              1{txt}  {c |}
            {c BLC}{hline 46}{c BRC}{txt}

{pstd}
The last matrix, {cmd:Xi*X}, differs just a little from the identity matrix 
because of unavoidable computational roundoff error.

{pstd}
Other functions are, mathematically speaking, scalar functions.  {cmd:sqrt()}
is an example in that it makes no sense to speak of {cmd:sqrt(}{it:X}{cmd:)}.
(That is, it makes no sense to speak of {cmd:sqrt(}{it:X}{cmd:)} unless we
were speaking of the Cholesky square-root decomposition. Mata has such a
matrix 
function; see {bf:{help mf_cholesky:[M-5] cholesky()}}.)

{pstd}
When a function is, mathematically speaking, a scalar function, 
the corresponding Mata function will usually allow vector and matrix 
arguments and, then, the Mata function makes the calculation 
on each element individually:

	: {cmd:M = (1,2 \ 3,4 \ 5,6)}

	: {cmd:M}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
          3 {c |}  {res}5   6{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

	: {cmd:S = sqrt(M)}

	: {cmd:S}
        {res}       {txt}          1             2
            {c TLC}{hline 29}{c TRC}
          1 {c |}  {res}          1   1.414213562{txt}  {c |}
          2 {c |}  {res}1.732050808             2{txt}  {c |}
          3 {c |}  {res}2.236067977   2.449489743{txt}  {c |}
            {c BLC}{hline 29}{c BRC}{txt}

	: {cmd:S[1,2]*S[1,2]}
	  2

	: {cmd:S[2,1]*S[2,1]}
	  3

{pstd}
When a function returns a result calculated in this way, it is said to 
return an element-by-element result.


{marker remarks9}{...}
{title:Performing element-by-element calculations:  Colon operators}

{pstd}
Mata's operators, such as {cmd:+} (addition) and {cmd:*} (multiplication), 
work as you would expect.  In particular, {cmd:*} performs matrix 
multiplication:


	: {cmd:A = (1, 2 \ 3, 4)}

	: {cmd:B = (5, 6 \ 7, 8)}

	: {cmd:A*B}
        {res}       {txt} 1    2
            {c TLC}{hline 11}{c TRC}
          1 {c |}  {res}19   22{txt}  {c |}
          2 {c |}  {res}43   50{txt}  {c |}
            {c BLC}{hline 11}{c BRC}{txt}

{pstd}
The first element of the result was calculated as 1*5+2*7=19.

{pstd}
Sometimes, you really want the element-by-element result.  When you do, 
place a colon in front of the operator:  Mata's {cmd::*} operator performs 
element-by-element multiplication:


	: {cmd:A:*B}
        {res}       {txt} 1    2
            {c TLC}{hline 11}{c TRC}
          1 {c |}  {res} 5   12{txt}  {c |}
          2 {c |}  {res}21   32{txt}  {c |}
            {c BLC}{hline 11}{c BRC}{txt}

{pstd}
See {bf:{help m2_op_colon:[M-2] op_colon}} for more information.


{marker remarks10}{...}
{title:Writing programs}

{pstd}
Mata is a complete programming language; it will allow you to create 
your own functions:

	: {cmd:function add(a,b) return(a+b)}

{pstd}
That single statement creates a new function, although perhaps you would
prefer if we typed it as

	: {cmd:function add(a, b)}
	> {cmd:{c -(}}
	>         {cmd:return(a+b)}
	> {cmd:{c )-}}

{pstd} 
because that makes it obvious that a program can contain many lines.
In either case, once defined, we can use the function:

	: {cmd:add(1,2)}
	  3

	: {cmd:add(1+2i,4-1i)}
	  5+1i

	: {cmd:add( (1,2), (3,4) )}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}4   6{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

	: {cmd:add(x,y)}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}4   6{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}
	
	: {cmd:add(A,A)}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}2   4{txt}  {c |}
          2 {c |}  {res}6   8{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

	: {cmd:Z1 = (1+1i, 1+1i \ 2, 2i)}
	: {cmd:Z2 = (1+2i, -3+3i \ 6i, -2+2i)}
	: {cmd:add(Z1, Z2)}
        {res}       {txt}      1         2
            {c TLC}{hline 21}{c TRC}
          1 {c |}  {res} 2 + 3i   -2 + 4i{txt}  {c |}
          2 {c |}  {res} 2 + 6i   -2 + 4i{txt}  {c |}
            {c BLC}{hline 21}{c BRC}{txt}


	: {cmd:add("Alpha","Beta")}
	  AlphaBeta

	: {cmd:S1 = ("one", "two" \ "three", "four")}
	: {cmd:S2 = ("abc", "def" \ "ghi", "jkl")}
	: {cmd:add(S1, S2)}
        {res}       {txt}       1          2
            {c TLC}{hline 23}{c TRC}
          1 {c |}  {res}  oneabc     twodef{txt}  {c |}
          2 {c |}  {res}threeghi    fourjkl{txt}  {c |}
            {c BLC}{hline 23}{c BRC}{txt}

{pstd}
Of course, our little function {cmd:add()} does not do anything that the 
{cmd:+} operator does not already do, but we could write a program that 
did do something different.  The following program will allow us to make 
{it:n} {it:x} {it:n} identity matrices:

	: {cmd:real matrix id(real scalar n)}
	> {cmd:{c -(}}
	>         {cmd:real scalar i}
	>         {cmd:real matrix res}
	>
	>         {cmd:res = J(n, n, 0)}
	>         {cmd:for (i=1; i<=n; i++) {c -(}}
        >                 {cmd:res[i,i] = 1}
	>         {cmd:{c )-}}
        >         {cmd:return(res)}
	> {cmd:{c )-}}

	: {cmd:I3 = id(3)}

	: {cmd:I3}
        {res}{txt}[symmetric]
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  {res}1        {txt}  {c |}
          2 {c |}  {res}0   1    {txt}  {c |}
          3 {c |}  {res}0   0   1{txt}  {c |}
            {c BLC}{hline 13}{c BRC}{txt}

{pstd}
The function {cmd:J()} in the program line {cmd:res = J(n, n, 0)} is a Mata
built-in function 
that returns an {cmd:n} {it:x} {cmd:n} matrix
containing 0s ({cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)} returns an
{it:r} {it:x} {it:c} matrix, the elements of which are all equal to {it:val});
see {bf:{help mf_j:[M-5] J()}}.

{pstd}
{cmd:for (i=1; i<=n; i++)} says that starting with i=1 and so long as
{cmd:i<=n} do what is inside the braces (set {cmd:res[i,i]} equal to 1) and
then (we are back to the {cmd:for} part again), increment i.  

{pstd}
The final line -- {cmd:return(res)} -- says to return the matrix we have just
created.

{pstd}
Actually, just as with {cmd:add()}, we do not need {cmd:id()} because 
Mata has a built-in function {cmd:I(}{it:n}{cmd:)} that makes identity 
matrices, but it is interesting to see how the problem could be programmed.


{marker remarks11}{...}
{title:More functions}

{pstd}
Mata has many functions already and much of this manual concerns
documenting what those functions do; see {bf:{help m4_intro:[M-4] Intro}}.
But right now, what is important is that many of the functions 
are themselves written in Mata!

{pstd}
One of those functions is {cmd:pi()};it takes no arguments and returns 
the value of {it:pi}.  The code for it reads

	{cmd:real scalar pi() return(3.141592653589793238462643)}

{pstd}
There is no reason to type the above function because it is already 
included as part of Mata:

	: {cmd:pi()}
	  3.141592654

{pstd}
When Mata lists a result, it does not show as many digits, but we 
could ask to see more:

	: {cmd:printf("%17.0g", pi())}
	  3.14159265358979

{pstd}
Other Mata functions include the hyperbolic function {cmd:tanh(}{it:u}{cmd:)}.
The code for {cmd:tanh(}{it:u}{cmd:)} reads

        {cmd}numeric matrix tanh(numeric matrix u)
        {c -(}
                numeric matrix  eu, emu

                eu = exp(u)
                emu = exp(-u)
                return( (eu-emu):/(eu+emu) )
        {c )-}{txt}

{pstd}
See for yourself:  at the Stata dot prompt (not the Mata colon prompt), type

	. {cmd:viewsource tanh.mata}

{pstd}
When the code for a function was written in Mata (as opposed to having been
written in C), {cmd:viewsource} can show you the code; see 
{bf:{help m1_source:[M-1] Source}}.

{pstd}
Returning to the function {cmd:tanh()}, 

        {cmd}numeric matrix tanh(numeric matrix u)
        {c -(}
                numeric matrix  eu, emu

                eu = exp(u)
                emu = exp(-u)
                return( (eu-emu):/(eu+emu) )
        {c )-}{txt}

{pstd}
this is the first time we have seen the word {cmd:numeric}:  it means real or 
complex.  Built-in (previously written) function {cmd:exp()} works like
{cmd:sqrt()} in that it allows a real or complex argument and correspondingly
returns a real or complex result.  Said in Mata jargon: {cmd:exp()} allows a
{cmd:numeric} argument and correspondingly returns a {cmd:numeric} result.
{cmd:tanh()} will also work like {cmd:sqrt()} and {cmd:exp()}.

{pstd}
Another characteristic {cmd:tanh()} shares with {cmd:sqrt()} and {cmd:exp()} is
element-by-element operation.  {cmd:tanh()} is element-by-element because
{cmd:exp()} is element-by-element and because we were careful to use the
{cmd::/} (element-by-element) divide operator.

{pstd}
In any case, 
there is no need to type the above functions because they are already
part of Mata.  You could learn more about them by seeing their manual 
entry, {bf:{help mf_sin:[M-5] sin()}}.

{pstd}
At the other extreme, Mata functions can become long.  Here is 
Mata's function to solve {it:AX}={it:B} for {it:X} when {it:A} is 
lower triangular, placing the result {it:X} back into {it:A}:

	{cmd}real scalar _solvelower(
			numeric matrix A, numeric matrix b, 
			|real scalar usertol, numeric scalar userd)
	{
		real scalar             tol, rank, a_t, b_t, d_t
		real scalar             n, m, i, im1, complex_case
		numeric rowvector       sum
		numeric scalar          zero, d

		d  = userd

		if ((n=rows(A))!=cols(A)) _error(3205)
		if (n != rows(b))         _error(3200)
		if (isview(b))            _error(3104)
		m = cols(b)
		rank = n

		a_t = iscomplex(A)
		b_t = iscomplex(b)
		d_t = d<. ? iscomplex(d) : 0

		complex_case = a_t | b_t | d_t

		if (complex_case) {
			if (!a_t) A = C(A)
			if (!b_t) b = C(b)
			if (d<. & !d_t) d = C(d)
			zero = 0i
		}
		else zero = 0 

		if (n==0 | m==0) return(0)

		tol = solve_tol(A, usertol)

		if (abs(d) >=. ) {
			if (abs(d=A[1,1])<=tol) {
				b[1,.] = J(1, m, zero)
				--rank
			}
			else {
				b[1,.] = b[1,.] :/ d
				if (missing(d)) rank = .
			}
	
			for (i=2; i<=n; i++) {
				im1 = i - 1 
				sum = A[|i,1\i,im1|] * b[|1,1\im1,m|]
				if (abs(d=A[i,i])<=tol) {
					b[i,.] = J(1, m, zero)
					--rank
				}
				else {
					b[i,.] = (b[i,.]-sum) :/ d
					if (missing(d)) rank = .
				}
			}
		}
		else {
			if (abs(d)<=tol) {
				rank = 0
				b = J(rows(b), cols(b), zero)
			}
			else {
				b[1,.] = b[1,.] :/ d

				for (i=2; i<=n; i++) {
					im1 = i - 1 
					sum = A[|i,1\i,im1|] * b[|1,1\im1,m|]
					b[i,.] = (b[i,.]-sum) :/ d
				}
			}
	
		}
		return(rank)
	}{txt}
	

{pstd}
If the function were not already part of Mata and you wanted to use it, 
you could type 
it into a do-file or onto the end of an ado-file (especially good if
you just want to use {helpb mf_solvelower:_solvelower()} as a subroutine).  In
those cases, do not forget to enter and exit Mata:

        {hline 41} begin ado-file {hline 5}
	{cmd:program} {it:mycommand} 
		...
		{it:ado-file code appears here}
		...
	{cmd:end}

	{cmd:mata:}
		{it:_solvelower() code appears here}
	{cmd:end}
        {hline 42} end ado-file {hline 5}

{pstd}
Sharp-eyed readers will notice that we put a colon on the end of the Mata
command.  That's a detail, and why we did that is explained in 
{bf:{help m3_mata:[M-3] mata}}.

{pstd}
In addition to loading functions by putting their code in do- and ado-files, 
you can also save the compiled versions of functions in {cmd:.mo} files 
(see {bf:{help mata_mosave:[M-3] mata mosave}}) or into {cmd:.mlib} Mata
libraries (see {bf:{help mata_mlib:[M-3] mata mlib}}).

{pstd}
For {cmd:_solvelower()}, it has already been saved into a 
library, namely, Mata's official library, so you need not do any of 
this.


{marker remarks12}{...}
{title:Mata environment commands}

{pstd}
When you are using Mata, there is a set of commands that will tell you about
and manipulate Mata's environment.

{pstd}
The most useful such command is {cmd:mata} {cmd:describe};
see {helpb mata describe:[M-3] mata describe}:

	: {cmd:mata describe}
	
              {txt}# bytes   type                       name and extent
	{hline 70}
	{res}           76   {txt}transmorphic matrix        {res}add{txt}()
	{res}          200   {txt}real matrix                {res}id{txt}()
	{res}           32   {txt}real matrix                {res}A{txt}[2,2]
	{res}           32   {txt}real matrix                {res}B{txt}[2,2]
	{res}           72   {txt}real matrix                {res}I3{txt}[3,3]
	{res}           48   {txt}real matrix                {res}M{txt}[3,2]
	{res}           48   {txt}real matrix                {res}S{txt}[3,2]
	{res}           47   {txt}string matrix              {res}S1{txt}[2,2]
	{res}           44   {txt}string matrix              {res}S2{txt}[2,2]
	{res}           72   {txt}real matrix                {res}X{txt}[3,3]
	{res}           72   {txt}real matrix                {res}Xi{txt}[3,3]
	{res}           64   {txt}complex matrix             {res}Z{txt}[2,2]
	{res}           64   {txt}complex matrix             {res}Z1{txt}[2,2]
	{res}           64   {txt}complex matrix             {res}Z2{txt}[2,2]
	{res}           16   {txt}real colvector             {res}a{txt}[2]
	{res}           16   {txt}complex scalar             {res}acomplex
                    8   {txt}real scalar                {res}areal
                   16   {txt}real colvector             {res}b{txt}[2]
        {res}           32   {txt}real colvector             {res}c{txt}[4]
        {res}            8   {txt}real scalar                {res}findout
                   16   {txt}real rowvector             {res}x{txt}[2]
        {res}           16   {txt}real rowvector             {res}y{txt}[2]
        {res}           32   {txt}real rowvector             {res}z{txt}[4]
        {hline 70}{txt}

	: {cmd:_}

{pstd}
Another useful command is {cmd:mata} {cmd:clear} (see
{helpb mata clear:[M-3] mata clear}), which will clear Mata 
without disturbing Stata:

	: {cmd:mata clear}

	: {cmd:mata describe}

              {txt}# bytes   type                       name and extent
        {hline 70}
        {hline 70}

{pstd}
There are other useful {cmd:mata} commands; see 
{bf:{help m3_intro:[M-3] Intro}}.
Do not confuse this command {cmd:mata}, which you type at Mata's 
colon prompt, with Stata's command {cmd:mata}, which you type at Stata's 
dot prompt and which invokes Mata.


{marker remarks13}{...}
{title:Exiting Mata}

{pstd}
When you are done using Mata, type {cmd:end} to Mata's colon prompt:

	: {cmd:end}
	{hline 70}

	. {cmd:_}

{pstd}
Exiting Mata does not clear it:

	. {cmd:mata}
	{hline 35} mata (type {cmd:end} to exit} {hline 10}
	: {cmd:x = 2}

	: {cmd:y = (3+2i)}

	: {cmd:function add(a,b) return(a+b)}

	: {cmd:end}
	{hline 70}

	. ...

	. {cmd:mata}
	{hline 35} mata (type {cmd:end} to exit} {hline 10}
	: {cmd:mata describe}
	
              {txt}# bytes   type                       name and extent
        {hline 70}
        {res}           76   {txt}transmorphic matrix        {res}add{txt}()
        {res}            8   {txt}real scalar                {res}x
                   16   {txt}complex scalar             {res}y
        {txt}{hline 70}

	: {cmd:end}

{pstd}
Exiting Stata clears Mata, as does Stata's {cmd:clear mata} command;
see {bf:{help clear:[D] clear}}.
{p_end}
