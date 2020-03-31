{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] strtoreal()" "mansection M-5 strtoreal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strofreal()" "help mf_strofreal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strtoreal##syntax"}{...}
{viewerjumpto "Description" "mf_strtoreal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strtoreal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strtoreal##remarks"}{...}
{viewerjumpto "Conformability" "mf_strtoreal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strtoreal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strtoreal##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] strtoreal()} {hline 2}}Convert string to real
{p_end}
{p2col:}({mansection M-5 strtoreal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind: }
{cmd:strtoreal(}{it:string matrix S}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:_strtoreal(}{it:string matrix S}{cmd:,} 
{it:R}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strtoreal(}{it:S}{cmd:)} returns {it:S} converted to real.  Elements of
{it:S} that cannot be converted are returned as {cmd:.} (missing value).

{p 4 4 2}
{cmd:_strtoreal(}{it:S}{cmd:,} {it:R}{cmd:)} 
does the same as above -- it returns
the converted values in {it:R} -- and it returns
the number of elements that could not be converted.  In such cases, the 
corresponding value of {it:R} contains {cmd:.} (missing). 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strtoreal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:strtoreal("1.5")} returns (numeric) 1.5.  

{p 4 4 2}
{cmd:strtoreal("-2.5e+1")} returns (numeric) -25.

{p 4 4 2}
{cmd:strtoreal("not a number")} returns (numeric) {cmd:.} (missing).  

{p 4 4 2}
Typically, 
{cmd:strtoreal(}{it:S}{cmd:)} and 
{cmd:_strtoreal(}{it:S}{cmd:,} {it:R}{cmd:)} 
are used with scalars, but if applied to a vector or matrix {it:S}, 
element-by-element results are returned.

{p 4 4 2}
In performing the conversion, leading and trailing blanks are ignored:  "1.5"
and {bind:" 1.5 "} both convert to (numeric) 1.5, but "1.5 kilometers"
converts to {cmd:.} (missing).  Use {cmd:strtoreal(tokens(}{it:S}{cmd:)[1])}
to convert just the first space-delimited part.

{p 4 4 2}
All Stata numeric formats are understood, such as 0, 1, -2, 1.5, 1.5e+2, 
and -1.0x+8, as well as the missing-value codes {cmd:.},
{cmd:.a}, {cmd:.b}, ..., {cmd:.z}.

{p 4 4 2}
Thus
using {cmd:strtoreal(}{it:S}{cmd:)}, 
if an element of {it:S} converts to {cmd:.} (missing), you cannot tell
whether the element was valid and equal
to "{cmd:.}" or the element was invalid and so defaulted to
{cmd:.} (missing), such as if {it:S} contained "cat" or 
"dog" or "1.5 kilometers".

{p 4 4 2}
When it is important to distinguish between these cases, use 
{cmd:_strtoreal(}{it:S}{cmd:,} {it:R}{cmd:)}.
The conversion is returned in {it:R} and the function returns 
the number of elements that were invalid.
If {cmd:_strtoreal()} returns 0, then all values were valid.


{marker conformability}{...}
{title:Conformability}

    {cmd:strtoreal(}{it:S}{cmd:)}:
	{it:input:}
               {it:S}:  {it:r x c}
	{it:output:}
          {it:result}:  {it:r x c}

    {cmd:_strtoreal(}{it:S}{cmd:,} {it:R}{cmd:)}:
	{it:input:}
               {it:S}:  {it:r x c}
	{it:output:}
               {it:R}:  {it:r x c}
          {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:strtoreal(}{it:S}{cmd:)}
returns a missing value wherever an element of {it:S} cannot be converted 
to a number.  

{p 4 4 2}
{cmd:_strtoreal(}{it:S}{cmd:,} {it:R}{cmd:)}
does the same, but the result is returned in {it:R}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view strtoreal.mata, adopath asis:strtoreal.mata}; 
{cmd:_strtoreal()} is built in.
{p_end}
