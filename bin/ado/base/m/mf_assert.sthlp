{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] assert()" "mansection M-5 assert()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_assert##syntax"}{...}
{viewerjumpto "Description" "mf_assert##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_assert##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_assert##remarks"}{...}
{viewerjumpto "Conformability" "mf_assert##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_assert##diagnostics"}{...}
{viewerjumpto "Source code" "mf_assert##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] assert()} {hline 2}}Abort execution if false
{p_end}
{p2col:}({mansection M-5 assert():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void} 
{cmd:assert(}{it:real scalar r}{cmd:)}

{p 8 8 2}
{it:void} 
{cmd:asserteq(}{it:transmorphic matrix A}{cmd:,}
{it:transmorphic matrix B}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:assert(}{it:r}{cmd:)} produces the error message 
"{err:assertion is false}" and aborts with error if {it:r}{cmd:==0}.

{p 4 4 2}
{cmd:asserteq(}{it:A}{cmd:,} {it:B}{cmd:)} is logically equivalent to 
{cmd:assert(}{it:A}{cmd:==}{it:B}{cmd:)}.  If the assertion is false,
however, information is presented on the number of mismatches.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 assert()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
In the midst of complicated code, you know that a certain calculation 
must produce a result greater than 0, but you worry that perhaps you 
have an error in your code:

	...
	{cmd:assert(n>0)}
	...

{p 4 4 2}
In another spot, you have produced matrix {cmd:A} and know every element 
of {cmd:A} should be positive or zero:

	...
	{cmd:assert(all(A:>=0))}
	...

{p 4 4 2}
Once you are convinced that your function works, these verifications should be
removed.  In a third part of your code, however, the problem is different 
if the number of rows {it:r} exceed the number of columns {it:c}.  In all the
cases you need to use it, however, {it:r} will be less than {it:c}, so you 
are not much interested in programming the alternative solution:

	...
	{cmd:assert(rows(PROBLEM) < cols(PROBLEM))}
	...

{p 4 4 2}
Leave that one in.


{marker conformability}{...}
{title:Conformability}

    {cmd:assert(}{it:r}{cmd:)}:
		{it:r}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:asserteq(}{it:A}{cmd:,} {it:B}{cmd:)}:
		{it:A}:  {it:r1 x c1}
		{it:B}:  {it:r2 x c2}
	   {it:result}:  {it:void}

	
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:assert(}{it:r}{cmd:)} aborts with error if {it:r}{cmd:==0}.

{p 4 4 2}
{cmd:asserteq(}{it:A}{cmd:,} {it:B}{cmd:)} aborts with error if 
{it:A}!={it:B}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view assert.mata, adopath asis:assert.mata},
{view asserteq.mata, adopath asis:asserteq.mata}
{p_end}
