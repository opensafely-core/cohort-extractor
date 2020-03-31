{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] makesymmetric()" "mansection M-5 makesymmetric()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] issymmetric()" "help mf_issymmetric"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_makesymmetric##syntax"}{...}
{viewerjumpto "Description" "mf_makesymmetric##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_makesymmetric##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_makesymmetric##remarks"}{...}
{viewerjumpto "Conformability" "mf_makesymmetric##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_makesymmetric##diagnostics"}{...}
{viewerjumpto "Source code" "mf_makesymmetric##source"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[M-5] makesymmetric()} {hline 2}}Make square matrix symmetric (Hermitian)
{p_end}
{p2col:}({mansection M-5 makesymmetric():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}{bind: }
{cmd:makesymmetric(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:_makesymmetric(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:makesymmetric(}{it:A}{cmd:)} returns 
{it:A} made into a symmetric (Hermitian) matrix by reflecting the 
elements below the diagonal.

{p 4 4 2}
{cmd:_makesymmetric(}{it:A}{cmd:)} does the same thing but stores the 
result back in {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 makesymmetric()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If {it:A} is real, elements below the diagonal are copied into their
corresponding above-the-diagonal position.

{p 4 4 2}
If {it:A} is complex, the conjugate of the elements below the diagonal are 
copied into their corresponding above-the-diagonal positions, and the 
imaginary part of the diagonal is set to zero.

{p 4 4 2}
Whether {it:A} is real or complex, 
roundoff error can make matrix calculations that are supposed to produce 
symmetric matrices produce matrices that vary a little from
symmetry, and {cmd:makesymmetric()} can be used to correct the situation.


{marker conformability}{...}
{title:Conformability}

    {cmd:makesymmetric(}{it:A}{cmd:)}:
		{it:A}:  {it:n x n}
	   {it:result}:  {it:n x n}

    {cmd:_makesymmetric(}{it:A}{cmd:)}:
		{it:A}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:makesymmetric(}{it:A}{cmd:)} and {cmd:_makesymmetric(}{it:A}{cmd:)} abort
with error if {it:A} is not square.  Also, {cmd:_makesymmetric()}
aborts with error if {it:A} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view makesymmetric.mata, adopath asis:makesymmetric.mata};
{cmd:_makesymmetric()} is built in.
{p_end}
