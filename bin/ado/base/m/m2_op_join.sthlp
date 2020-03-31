{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-2] op_join" "mansection M-2 op_join"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_join##syntax"}{...}
{viewerjumpto "Description" "m2_op_join##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_join##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_join##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_join##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_join##diagnostics"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-2] op_join} {hline 2}}Row- and column-join operators
{p_end}
{p2col:}({mansection M-2 op_join:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:a} {cmd:,} {it:b}

	{it:a} {cmd:\} {it:b}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:,} and {cmd:\} are Mata's row-join and column-join operators.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_joinRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_op_join##remarks1:Comma and backslash are operators}
	{help m2_op_join##remarks2:Comma as a separator}
	{help m2_op_join##remarks3:Warning about the misuse of comma and backslash operators}


{marker remarks1}{...}
{title:Comma and backslash are operators}

{p 4 4 2}
That {cmd:,} and {cmd:\} are operators cannot be emphasized enough.
When one types

	: {cmd:(1,2 \ 3,4)}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{p 4 4 2}
one is tempted to think, "Ah, comma and backslash are how you separate 
elements when you enter a matrix."  If you think like that, you will 
not appreciate the power of {cmd:,} and {cmd:\}.

{p 4 4 2}
{cmd:,} and {cmd:\} are operators in the same way that {cmd:*} and {cmd:+} 
are operators.  

{p 4 4 2}
{cmd:,} is the operator that takes a {it:r x c1} matrix and a 
{it:r x c2} matrix, and returns a {it:r x} ({it:c1}+{it:c2}) matrix.

{p 4 4 2}
{cmd:\} is the operator that takes a {it:r1 x c} matrix and a 
{it:r2 x c} matrix, and returns a ({it:r1}+{it:r2}) {it:x c} matrix.

{p 4 4 2}
{cmd:,} and {cmd:\} may be used with scalars, vectors, or matrices:

	: {cmd:a = (1\2)}
	: {cmd:b = (3\4)}
	: {cmd:a,b}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   3{txt}  {c |}
          2 {c |}  {res}2   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

	: {cmd:c = (1,2)}
	: {cmd:d = (3,4)}
	: {cmd:c\d}
        {res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}{txt}

{p 4 4 2}
{cmd:,} binds more tightly than {cmd:\}, meaning that 
{it:e}{cmd:,}{it:f}{cmd:\}{it:g}{cmd:,}{it:h} is
interpreted as 
{cmd:(}{it:e}{cmd:,}{it:f}{cmd:)\(}{it:g}{cmd:,}{it:h}{cmd:)}.
In this, {cmd:,} and {cmd:\} are no
different from {cmd:*} and {cmd:+} operators:  {cmd:*} binds more tightly than
{cmd:+} and {it:e}{cmd:*}{it:f}{cmd:+}{it:g}{cmd:*}{it:h} is interpreted as
{cmd:(}{it:e}{cmd:*}{it:f}{cmd:)+(}{it:g}{cmd:*}{it:h}{cmd:)}.

{p 4 4 2}
Just as it sometimes makes sense to type 
{it:e}{cmd:*(}{it:f}{cmd:+}{it:g}{cmd:)*}{it:h},
it can make sense to type 
{it:e}{cmd:,(}{it:f}{cmd:\}{it:g}{cmd:),}{it:h}: 

	: {cmd:e = 1\2}
	: {cmd:f = 5\6}
	: {cmd:g = 3}
	: {cmd:h = 4}
	: {cmd:e,(g\h),f}
        {res}       {txt}1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  {res}1   3   5{txt}  {c |}
          2 {c |}  {res}2   4   6{txt}  {c |}
            {c BLC}{hline 13}{c BRC}{txt}


{marker remarks2}{...}
{title:Comma as a separator}

{p 4 4 2}
{cmd:,} has a second meaning in Mata:  it is the argument separator for
functions.  When you type

	: {cmd:myfunc(a, b)}

{p 4 4 2}
the comma that appears inside the parentheses is not the comma row-join
operator; it is the comma argument separator.  If you wanted to call 
{cmd:myfunc()} with second argument equal to row vector (1,2), you must 
type 

	: {cmd:myfunc(a, (1,2))}

{p 4 4 2}
and not 

	: {cmd:myfunc(a, 1,2)}

{p 4 4 2} 
because otherwise Mata will think you are trying to pass three arguments
to {cmd:myfunc()}.  When you open another set of parentheses inside a
function's argument list, comma reverts to its usual row-join meaning.


{marker remarks3}{...}
{title:Warning about the misuse of comma and backslash operators}

{p 4 4 2}
Misuse or mere overuse of {cmd:,} and {cmd:\} can substantially reduce the 
speed with which your code executes.  Consider the actions Mata must take 
when you code, say, 

		{it:a} {cmd:\} {it:b}

{p 4 4 2}
First, Mata must allocate a matrix or vector containing 
rows({it:a})+rows({it:b}) rows, then it must copy {it:a} into the 
new matrix or vector, and then it must copy {it:b}.  Nothing inefficient 
has happened yet, but now consider

		{cmd:(}{it:a} {cmd:\} {it:b}{cmd:)} {cmd:\} {it:c}

{p 4 4 2}
Picking up where we left off, Mata must allocate a matrix or vector 
containing 
rows({it:a})+rows({it:b})+rows({it:c}) rows, then it must copy 
{cmd:(}{it:a}{cmd:\}{it:b}{cmd:)} into the new matrix or vector, and then it
must copy {it:c}.  Something inefficient just happened:  {it:a} was copied 
twice!

{p 4 4 2}
Coding 

		{it:res} {cmd:= (}{it:a} {cmd:\} {it:b}{cmd:)} {cmd:\} {it:c}

{p 4 4 2}
is convenient, but execution would be quicker if we coded

		{it:res} {cmd:= J(rows(}{it:a}{cmd:)+rows(}{it:b}{cmd:)+rows(}{it:c}{cmd:), cols(}{it:a}{cmd:), .)}
		{it:res}{cmd:[1,.] =} {it:a}
		{it:res}{cmd:[2,.] =} {it:b}
		{it:res}{cmd:[3,.] =} {it:c}

{p 4 4 2}
We do not want to cause you concern where none is due.  In general, you would
not be able to measure the difference between the more efficient code and
coding {it:res} {cmd:= (}{it:a} {cmd:\} {it:b}{cmd:)} {cmd:\} {it:c}.  But as
the number of row or column operators stack up, the combined result becomes
more and more inefficient.  Even that is not much of a concern.  If the
inefficient construction itself is buried in a loop, however, 
and that loop is executed thousands of times, the inefficiency can become
important.

{p 4 4 2}
With a little thought, you can always substitute predeclaration using 
{cmd:J()} (see {bf:{help mf_j:[M-5] J()}}) and assignment via subscripting.  


{marker conformability}{...}
{title:Conformability}

    {it:a}{cmd:,}{it:b}:
		{it:a}:  {it:r x c1}
		{it:b}:  {it:r x c2}
	   {it:result}:  {it:r x} ({it:c1}+{it:c2})

    {it:a}{cmd:\}{it:b}:
		{it:a}:  {it:r1 x c}
		{it:b}:  {it:r2 x c}
	   {it:result}:  ({it:r1}+{it:r2}) {it:x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:,} and {cmd:\} abort with error if {it:a} and {it:b} are not of the 
same broad type.
{p_end}
