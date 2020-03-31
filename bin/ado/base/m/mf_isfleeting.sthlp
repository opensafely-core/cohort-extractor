{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] isfleeting()" "mansection M-5 isfleeting()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_isfleeting##syntax"}{...}
{viewerjumpto "Description" "mf_isfleeting##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_isfleeting##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_isfleeting##remarks"}{...}
{viewerjumpto "Conformability" "mf_isfleeting##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_isfleeting##diagnostics"}{...}
{viewerjumpto "Source code" "mf_isfleeting##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] isfleeting()} {hline 2}}Whether argument is temporary
{p_end}
{p2col:}({mansection M-5 isfleeting():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}
{cmd:isfleeting(}{it:polymorphic matrix A}{cmd:)}


{p 4 4 2}
where {it:A} is an argument passed to your function.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:isfleeting(}{it:A}{cmd:)} returns 1 if {it:A} was constructed 
for the sole purpose of passing to your function, and returns 0 otherwise.
If an argument is fleeting, then you may change its contents and be 
assured that the caller will not care or even know.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 isfleeting()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Let us assume that you have written function {cmd:myfunc(}{it:A}{cmd:)} 
that takes {it:A}: {it:r x c} and returns an {it:r x c} matrix.
Just to fix ideas, we will pretend that the code for {cmd:myfunc()} reads

	{cmd}real matrix myfunc(real matrix A)
	{c -(}
		real scalar	i
		real matrix	B

		B=A
		for (i=1; i<=rows(B); i++) B[i,i] = 1
		return(B)
	{c )-}{txt}

{p 4 4 2}
Function {cmd:myfunc(}{it:A}{cmd:)} returns a matrix equal to {it:A}, but 
with ones along the diagonal.  Now let's imagine {cmd:myfunc()} in use.  
A snippet of the code might read

		...
		{cmd:C = A*myfunc(D)*C}
		...

{p 4 4 2}
Here {cmd:D} is passed to {cmd:myfunc()}, and the argument {cmd:D} is
said not to be fleeting.  Now consider another code snippet:

		...
		{cmd:D = A*myfunc(D+E)*D}
		...

{p 4 4 2}
In this code snippet, the argument passed to {cmd:myfunc()} is {cmd:D+E}
and that argument is fleeting.  It is fleeting because it 
was constructed for the sole purpose of being passed to {cmd:myfunc()}, 
and once {cmd:myfunc()} concludes, the matrix 
containing {cmd:D+E} will be discarded.

{p 4 4 2}
Arguments that are fleeting can be reused to save memory.

{p 4 4 2}
Look carefully at the code for {cmd:myfunc()}.  It makes a 
copy of the matrix that it was passed.  It did that to avoid damaging the
matrix that it was passed.  Making that copy, however, is unnecessary if the
argument received was fleeting, because damaging something that would have
been discarded anyway does not matter.  Had we not made the copy, 
we would have saved not only computer time but also memory.
Function {cmd:myfunc()} could be recoded to read

	{cmd}real matrix myfunc(real matrix A)
	{c -(}
		real scalar	i
		real matrix	B

		if (isfleeting(A)) {c -(}
			for (i=1; i<=rows(A); i++) A[i,i] = 1
			return(A)
		}
		B=A
		for (i=1; i<=rows(B); i++) B[i,i] = 1
		return(B)
	{c )-}{txt}

{p 4 4 2}
Here we wrote separate code for the fleeting and nonfleeting cases.
That is not always necessary.  We could use a pointer here to 
combine the two code blocks:

	{cmd}real matrix myfunc(real matrix A)
	{c -(}
		real scalar	i
		real matrix	B
		pointer scalar	p

		if (isfleeting(A)) p = &A
		else {c -(}
			B = A
			p = &B
		{c )-}
		for (i=1; i<=rows(*p); i++) (*p)[i,i] = 1
		return(*p)
	{c )-}{txt}

{p 4 4 2}
Many official library functions come in two varieties:
{cmd:_foo(}{it:A}{cmd:,} ...{cmd:)}, which replaces {it:A} with the
calculated result, and {cmd:foo(}{it:A}{cmd:,} ...{cmd:)}, which returns
the result leaving {it:A} unmodified.  Invariably, the code for 
{cmd:foo()} reads

	{cmd}function foo(A, {txt:...})
	{c -(}
		matrix B

		if (isfleeting(A)) {c -(}
			_foo(A, {txt:...})
			return(A)
		{c )-}
		_foo(B=A, ...)
		return(B)
	{c )-}{txt}

{p 4 4 2}
This makes function {cmd:foo()} whoppingly efficient.  If {cmd:foo()} is 
called with a temporary argument -- an argument that could be modified
without the caller being aware of it -- then no extra copy of the matrix 
is ever made.
	

{marker conformability}{...}
{title:Conformability}

    {cmd:isfleeting(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:isfleeting(}{it:A}{cmd:)} returns 1 if {it:A} is fleeting and not a view.
The value returned is indeterminate if {it:A} is not an argument of the
function in which it appears, and therefore the value of {cmd:isfleeting()} is
also indeterminate when used interactively.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
