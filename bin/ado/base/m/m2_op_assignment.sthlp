{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-2] op_assignment" "mansection M-2 op_assignment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] swap()" "help mf_swap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_assignment##syntax"}{...}
{viewerjumpto "Description" "m2_op_assignment##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_assignment##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_assignment##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_assignment##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_assignment##diagnostics"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-2] op_assignment} {hline 2}} Assignment operator
{p_end}
{p2col:}({mansection M-2 op_assignment:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:lval} {cmd:=} {it:exp}

{p 4 4 2}
where {it:exp} is any valid expression and where {it:lval} is

	{it:name}
	{it:name}{cmd:[}{it:exp}{cmd:]}
	{it:name}{cmd:[}{it:exp}, {it:exp}{cmd:]}
	{it:name}{cmd:[|}{it:exp}{cmd:|]}

{p 4 4 2}
In pointer use (advanced), {it:name} may be

	{cmd:*}{it:lval}
	{cmd:*(}{it:lval}{cmd:)}
	{cmd:*(}{it:lval}{cmd:[}{it:exp}{cmd:]}{cmd:)}
	{cmd:*(}{it:lval}{cmd:[}{it:exp}, {it:exp}{cmd:]}{cmd:)}
	{cmd:*(}{it:lval}{cmd:[|}{it:exp}{cmd:|]}{cmd:)}

{p 4 4 2}
in addition to being a variable name.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:=} assigns the evaluation of {it:exp} to {it:lval}.

{p 4 4 2}
Do not confuse the {cmd:=} assignment operator with the {cmd:==} equality 
operator.  Coding 

		{cmd: x = y}

{p 4 4 2}
assigns the value of {cmd:y} to {cmd:x}.  Coding 

		{cmd:if (x==y)} ...{col 50}{it:(note doubled equal signs)}

{p 4 4 2}
performs the action if the value of {it:x} is equal to the value of {it:y}.
See {bf:{help m2_op_logical:[M-2] op_logical}} for a description of the 
{cmd:==} equality operator.

{p 4 4 2}
If the result of an expression is not assigned to a variable, then the 
result is displayed at the terminal; see {bf:{help m2_exp:[M-2] exp}}.
 

{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_assignmentRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_op_assignment##remarks1:Assignment suppresses display}
	{help m2_op_assignment##remarks2:The equal-assignment operator}
	{help m2_op_assignment##remarks3:lvals, what appears on the left-hand side}
	{help m2_op_assignment##remarks4:Row, column, and element lvals}
	{help m2_op_assignment##remarks5:Pointer lvals}


{marker remarks1}{...}
{title:Assignment suppresses display}

{p 4 4 2}
When you interactively enter an expression or code an expression in a 
program without the equal-assignment operator, the result of the 
expression is displayed at the terminal:

	: {cmd:2+3}
	  5

{p 4 4 2}
When you assign the expression to a variable, the result is not displayed:

	: {cmd:x = 2+3}


{marker remarks2}{...}
{title:The equal-assignment operator}

{p 4 4 2}
Equals is an operator, so in addition to coding

		{cmd:a = 2 + 3}

{p 4 4 2}
you can code 

		{cmd:a = b = 2 + 3}

{p 4 4 2}
or 

		{cmd:y = x / (denominator = sqrt(a+b))}

{p 4 4 2}
or even

		{cmd:y1 = y2 = x / (denominator = sqrt(sum=a+b))}

{p 4 4 2}
This last is equivalent to

		{cmd:sum = a + b}
		{cmd:denominator = sqrt(sum)}
		{cmd:y2 = x / denominator}
		{cmd:y1 = y2}

{p 4 4 2}
Equals binds weakly, so 

		{cmd:a = b = 2 + 3}

{p 4 4 2}
is interpreted as 

		{cmd:a = b = (2 + 3)}

{p 4 4 2}
and not 

		{cmd:a = (b=2) + 3}


{marker remarks3}{...}
{title:lvals, what appears on the left-hand side}

{p 4 4 2}
What appears to the left of the equals is called an {it:lval}, short for
left-hand-side value.  It would make no sense, for instance, to code 

		{cmd:sqrt(4) = 3}

{p 4 4 2}
and, as a matter of fact, you are not allowed to code that because 
{cmd:sqrt(4)} is not an {it:lval}:

	: {cmd:sqrt(4) = 3}
	{err:invalid lval}
	r(3000);

{p 4 4 2}
An {it:lval} is anything that can hold values.  A scalar can hold values

		{cmd:a = 3}

		{cmd:x = sqrt(4)}

{p 4 4 2}
a matrix can hold values

		{cmd:A = (1,2\3,4)}

		{cmd:B = invsym(C)}

{p 4 4 2}
a matrix row can hold values

		{cmd:A[1,.] = (7,8)}

{p 4 4 2}
a matrix column can hold values

		{cmd:A[.,2] = (9\10)}

{p 4 4 2}
and finally, a matrix element can hold a value

		{cmd:A[1,2] = 7}

{p 4 4 2}
{it:lvals} are usually one of the above forms.  The other forms 
have to do with pointer variables, which most programmers never use; 
they are discussed under
{help m2_op_assignment##remarks5:Pointer lvals} below.


{marker remarks4}{...}
{title:Row, column, and element lvals}

{p 4 4 2}
When you assign to a row, column, or element of a matrix, 

		{cmd:A[1,.] = (7,8)}
		{cmd:A[.,2] = (9\10)}
		{cmd:A[1,2] = 7}

{p 4 4 2}
the row, column, or element must already exist:

	: {cmd:A = (1, 2 \ 3, 4)}

	: {cmd:A[3,4] = 4}
	{err:        <istmt>:  3301  subscript invalid}
	r(3301);

{p 4 4 2}
This is usually not an issue because, by the time you are assigning to 
a row, column, or element, the matrix has already been created, but in 
the event you need to create it first, use the {cmd:J()} function; see
{bf:{help mf_j:[M-5] J()}}.  The following code fragment 
creates a 3 {it:x} 4 matrix containing the sum of its indices:

		{cmd}A = J(3, 4, .)
		for (i=1; i<=3; i++) {
			for (j=1; j<=4; j++) A[i,j] = i + j
		}{txt}


{marker remarks5}{...}
{title:Pointer lvals}

{p 4 4 2}
In addition to the standard {it:lvals}

		{cmd}A = (1, 2 \ 3, 4)
		A[1,.] = (7,8)
		A[.,2] = (9\10)
		A[1,2] = 7{txt}

{p 4 4 2}
pointer {it:lvals} are allowed.  For instance, 

		{cmd:*p = 3}

{p 4 4 2}
stores 3 in the address pointed to by pointer scalar {cmd:p}.

		{cmd:(*q)[1,2] = 4}

{p 4 4 2}
stores 4 in the (1,2) element of the address pointed to by pointer scalar 
{cmd:q}, whereas  

		{cmd:*Q[1,2] = 4}

{p 4 4 2}
stores 4 in the address pointed to by the (1,2) element of pointer matrix 
{cmd:Q}.  

		{cmd:*Q[2,1][1,3] = 5}

{p 4 4 2}
is equivalent to

		{cmd:*(Q[2,1])[1,3] = 5}

{p 4 4 2}
and stores 5 in the (1,3) element of the address pointed to by the (2,1)
element of pointer matrix {cmd:Q}.

{p 4 4 2}
Pointers to pointers, pointers to pointers to pointers, etc., are also 
allowed.  For instance, 

		{cmd:**r} = 3

{p 4 4 2}
stores 3 in the address pointed to by the address pointed to by pointer scalar 
{cmd:r}, whereas 

		{cmd:*((*(Q[1,2]))[2,1])[3,4] = 7}

{p 4 4 2}
stores 7 in the (3,4) address pointed to by the (2,1) address pointed to 
by the (1,2) address of pointer matrix {cmd:Q}.


{marker conformability}{...}
{title:Conformability}

    {it:a} {cmd:=} {it:b}:
	{it:input}:
		{it:b}:  {it:r x c}
	{it:output}:
		{it:a}:  {it:r x c}
		

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{it:a} {cmd:=} {it:b} aborts with error if there is insufficient memory
to store a copy of {it:b} in {it:a}.
{p_end}
