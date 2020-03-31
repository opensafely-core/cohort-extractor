{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] transposeonly()" "mansection M-5 transposeonly()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] op_transpose" "help m2_op_transpose"}{...}
{vieweralsosee "[M-5] _transpose()" "help mf__transpose"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_transposeonly##syntax"}{...}
{viewerjumpto "Description" "mf_transposeonly##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_transposeonly##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_transposeonly##remarks"}{...}
{viewerjumpto "Conformability" "mf_transposeonly##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_transposeonly##diagnostics"}{...}
{viewerjumpto "Source code" "mf_transposeonly##source"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[M-5] transposeonly()} {hline 2}}Transposition without conjugation
{p_end}
{p2col:}({mansection M-5 transposeonly():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:numeric matrix}
{cmd:transposeonly(}{it:numeric matrix A}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_transposeonly(}{it:numeric matrix} {it:A}{cmd:)}



{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:transposeonly(}{it:A}{cmd:)} 
returns {it:A} with its rows and columns interchanged.
When {it:A} is real, the actions of {cmd:transposeonly(}{it:A}{cmd:)} are 
indistinguishable from coding {it:A}{cmd:'}; see 
{bf:{help m2_op_transpose:[M-2] op_transpose}}.  The returned result is 
the same, and the execution time is the same, too.
When {it:A} is complex, however, 
{cmd:transposeonly(}{it:A}{cmd:)} is equivalent to coding 
{cmd:conj(}{it:A}{cmd:')}, but {cmd:transposeonly()} obtains the result 
more quickly.

{p 4 4 2}
{cmd:_transposeonly(}{it:A}{cmd:)} 
interchanges the rows and columns of {it:A} in place -- without use of 
additional memory -- and returns the transposed (but not conjugated) 
result in {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 transposeonly()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:transposeonly()} is useful when you are coding in the programming,
rather than the mathematical, sense.  Say that you have two row vectors, 
{cmd:a} and {cmd:b}, and you want to place the two vectors together in a
matrix {cmd:R}, and you want to turn them into column vectors.  If {cmd:a}
and {cmd:b} were certain to be real, you could just code

		{cmd:R = (a', b')}

{p 4 4 2}
The above line, however, would result in not just the organization but also the
values recorded in {cmd:R} changing if {cmd:a} or {cmd:b} were complex.  The
solution is to code

		{cmd:R = (transposeonly(a), transposeonly(b))}

{p 4 4 2}
The above line will work for real or complex {cmd:a} and {cmd:b}.
If you were concerned about memory consumption, you could instead code

		{cmd:R = (a \ b)}
		{cmd:_transposeonly(R)}
	

{marker conformability}{...}
{title:Conformability}

    {cmd:transposeonly(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  {it:c x r}

    {cmd:_transposeonly(}{it:A}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
	{it:output:}
		{it:A}:  {it:c x r}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_transposeonly(}{it:A}{cmd:)}
aborts with error if {it:A} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view transposeonly.mata, adopath asis:transposeonly.mata};
{cmd:_transposeonly()} is built in.
{p_end}
