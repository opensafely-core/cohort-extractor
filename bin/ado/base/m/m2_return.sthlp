{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] return" "mansection M-2 return"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] exit()" "help mf_exit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_return##syntax"}{...}
{viewerjumpto "Description" "m2_return##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_return##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_return##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-2] return} {hline 2}}return and return(exp)
{p_end}
{p2col:}({mansection M-2 return:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:return}

	{cmd:return(}{it:exp}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:return} causes the function to stop execution and return to the 
caller, returning nothing.

{p 4 4 2}
{cmd:return(}{it:exp}{cmd:)} causes the function to stop execution and return
to the caller, returning the evaluation of {it:exp}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 returnRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_return##remarks1:Functions that return results}
	{help m2_return##remarks2:Functions that return nothing (void functions)}


{marker remarks1}{...}
{title:Functions that return results}

{p 4 4 2}
{cmd:return(}{it:exp}{cmd:)} specifies the value to be returned.
For instance, you have written a program to return the sum of two numbers:

	{cmd}function mysum(a, b)
	{
		return(a+b)
	}{txt}

{p 4 4 2}
{cmd:return(}{it:exp}{cmd:)} may appear multiple times in the program.  The
following program calculates {it:x} factorial; it assumes {it:x} is an integer
greater than 0:

	{cmd}real scalar myfactorial(real scalar x)
	{
		if (x<=0) return(1)
		return(x*factorial(x-1))
	}{txt}

{p 4 4 2}
If {it:x}<=0, the function returns 1; execution does not 
continue to the next line.

{p 4 4 2}
Functions that return a result always include one or more 
{cmd:return(}{it:exp}{cmd:)} statements.


{marker remarks2}{...}
{title:Functions that return nothing (void functions)}

{p 4 4 2}
A function is said to be void if it returns nothing.  The following 
program changes the diagonal of a matrix to be 1:

	{cmd}function fixdiag(matrix A)
	{
		real scalar     i

		for (i=1; i<=rows(A); i++) A[i,i] = 1
	}{txt}

{p 4 4 2}
This function does not even include a {cmd:return} statement;
execution just ends.  That is fine, although the function could just 
as well read

	{cmd}function fixdiag(matrix A)
	{
		real scalar     i

		for (i=1; i<=rows(A); i++) A[i,i] = 1
		return
	}{txt}

{p 4 4 2}
The use of {cmd:return} is when the function has reason to end early:

	{cmd}void fixmatrix(matrix A, scalar how)
	{
		real scalar     i, j

		for (i=1; i<=rows(A); i++) A[i,i] = 1
		if (how==0) return
		for (i=1; i<=rows(A); i++) {
			for (j=1; j<i; j++) A[i,j] = 0
		}
	}{txt}
