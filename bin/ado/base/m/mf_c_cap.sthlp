{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] C()" "mansection M-5 C()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Re()" "help mf_re"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_c_cap##syntax"}{...}
{viewerjumpto "Description" "mf_c_cap##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_c_cap##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_c_cap##remarks"}{...}
{viewerjumpto "Conformability" "mf_c_cap##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_c_cap##diagnostics"}{...}
{viewerjumpto "Source code" "mf_c_cap##source"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-5] C()} {hline 2}}Make complex
{p_end}
{p2col:}({mansection M-5 C():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:complex matrix}{bind: }
{cmd:C(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:complex matrix}{bind: }
{cmd:C(}{it:real matrix R}{cmd:,}
{it:real matrix I}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:C(}{it:A}{cmd:)}
returns {it:A} converted to complex.  
{cmd:C(}{it:A}{cmd:)} returns {it:A} if {it:A} is already complex.
If {it:A} is real, 
{cmd:C(}{it:A}{cmd:)} returns {it:A}+0i -- {it:A} cast up to complex.
Coding {cmd:C(}{it:A}{cmd:)} is thus how you ensure 
that the matrix is treated as complex.

{p 4 4 2}
{cmd:C(}{it:R}{cmd:,} {it:I}{cmd:)} 
returns 
the complex matrix
{it:R}+{it:I}i 
and is faster than the alternative 
{bind:{it:R} {cmd:+} {it:I}{cmd::*1i}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 C()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Many of Mata's functions are overloaded, meaning they return a real when
given real arguments and a complex when given complex arguments.  Given
real arguments, if the result cannot be expressed as a real, missing value is
returned.  Thus {cmd:sqrt(-1)} evaluates to missing, whereas {cmd:sqrt(-1+0i)}
is 1i.

{p 4 4 2}
{cmd:C()} is the fast way to make arguments that might be real into complex.
You can code 

		{cmd:result = sqrt(C(}{it:x}{cmd:))}

{p 4 4 2}
If {it:x} already is complex, {cmd:C()} does nothing; if {it:x} is 
real, {cmd:C(}{it:x}{cmd:)} returns the complex equivalent.

{p 4 4 2}
The two-argument version of {cmd:C()} is less frequently used.  
{cmd:C(}{it:R}{cmd:,} {it:I}{cmd:)} is literally equivalent to 
{it:R} {cmd::+} {it:I}{cmd:*1i}, meaning that {it:R} and {it:I} need only 
be c-conformable.  For instance, {cmd:C(1, (1,2,3))}
evaluates to (1+1i, 1+2i, 1+3i).


{marker conformability}{...}
{title:Conformability}

    {cmd:C(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:C(}{it:R}{cmd:,} {it:I}{cmd:)}:
		{it:R}:  {it:r1 x c1}
		{it:I}:  {it:r2 x c2}, {it:R} and {it:I} c-conformable
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})



{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:C(}{it:Z}{cmd:)}, if {it:Z} is complex, literally returns {it:Z} and 
not a copy of {it:Z}.  This makes execution of {cmd:C()} applied to 
complex arguments instant.

{p 4 4 2}
In 
{cmd:C(}{it:R}{cmd:,} {it:I}{cmd:)},
the {it:i},{it:j} element of the result will be missing anywhere
{it:R}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} or 
{it:I}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} is missing.
For instance, {cmd:C((1,3,.), (.,2,4))} results in (., 3+2i, .).
If 
{it:R}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} and 
{it:I}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} are both missing, then 
the 
{it:R}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:]} 
value will be used; for example, {cmd:C(.a, .b)} results in {cmd:.a}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
