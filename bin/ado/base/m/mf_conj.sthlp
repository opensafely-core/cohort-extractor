{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] conj()" "mansection M-5 conj()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _transpose()" "help mf__transpose"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_conj##syntax"}{...}
{viewerjumpto "Description" "mf_conj##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_conj##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_conj##remarks"}{...}
{viewerjumpto "Conformability" "mf_conj##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_conj##diagnostics"}{...}
{viewerjumpto "Source code" "mf_conj##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] conj()} {hline 2}}Complex conjugate
{p_end}
{p2col:}({mansection M-5 conj():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:conj(}{it:numeric matrix Z}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_conj(}{it:numeric matrix} {it:A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:conj(}{it:Z}{cmd:)} returns the elementwise complex conjugate of 
{it:Z}, that is, {cmd:conj(}{it:a}+{it:b}i{cmd:)} = {it:a}-{it:b}i.
{cmd:conj()} may be used with real or complex matrices.  If {it:Z} is 
real, {it:Z} is returned unmodified.

{p 4 4 2}
{cmd:_conj(}{it:A}{cmd:)} replaces {it:A} with {cmd:conj(}{it:A}{cmd:)}.
Coding {cmd:_conj(}{it:A}{cmd:)} is equivalent to coding 
{bind:{it:A} {cmd:=} {cmd:conj(}{it:A}{cmd:)}},
except that less memory is used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 conj()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Given {it:m} {it:x} {it:n} matrix {it:Z}, {cmd:conj(}{it:Z}{cmd:)}
returns an {it:m} {it:x} {it:n} matrix; it does not return the transpose.  To
obtain the conjugate transpose matrix, also known as the adjoint matrix,
adjugate matrix, Hermitian adjoin, or Hermitian transpose, code

		{it:Z}{cmd:'}

{p 4 4 2}
See {bf:{help m2_op_transpose:[M-2] op_transpose}}.

{p 4 4 2}
A matrix equal to its conjugate transpose is called Hermitian or self-adjoint
although, in this manual, we often use the term symmetric.


{marker conformability}{...}
{title:Conformability}

    {cmd:conj(}{it:Z}{cmd:)}:
		{it:Z}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:_conj(}{it:A}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
	{it:output:}
		{it:A}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:conj(}{it:Z}{cmd:)} returns a real matrix if {it:Z} is real and a complex
matrix if {it:Z} is complex.

{p 4 4 2}
{cmd:conj(}{it:Z}{cmd:)}, if {it:Z} is real, 
returns {it:Z} itself and not a copy.  This makes {cmd:conj()} execute 
instantly when applied to real matrices.

{p 4 4 2}
{cmd:_conj(}{it:A}{cmd:)} 
does nothing if {it:A} is real (and hence, does not abort if {it:A} 
is a view).


{marker source}{...}
{title:Source code}

{pstd}
Functions are built in.
{p_end}
