{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] strpos()" "mansection M-5 strpos()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "[M-5] ustrpos()" "help mf_ustrpos"}{...}
{viewerjumpto "Syntax" "mf_strpos##syntax"}{...}
{viewerjumpto "Description" "mf_strpos##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strpos##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strpos##remarks"}{...}
{viewerjumpto "Conformability" "mf_strpos##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strpos##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strpos##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] strpos()} {hline 2}}Find substring in string
{p_end}
{p2col:}({mansection M-5 strpos():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:strpos(}{it:string matrix haystack}{cmd:,}
{it:string matrix needle}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:strrpos(}{it:string matrix haystack}{cmd:,}
{it:string matrix needle}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)} returns the location of
the first occurrence of {it:needle} in {it:haystack} or 0 if {it:needle} does
not occur.

{p 4 4 2}
{cmd:strrpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)} returns the location of
the last occurrence of {it:needle} in {it:haystack} or 0 if {it:needle} does
not occur.

{p 4 4 2}
When arguments are not scalar, {cmd:strpos()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strpos()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
When working with binary strings, one can find the first or last location of 
the binary 0 using {cmd:strpos(}{it:s}{cmd:, char(0))} or
{cmd:strrpos(}{it:s}{cmd:, char(0))}.

{p 4 4 2}
Use {helpb mf_ustrpos:ustrpos()} or
{helpb mf_ustrrpos:ustrrpos()} to search
based on characters rather than on bytes. 


{marker conformability}{...}
{title:Conformability}

    {cmd:strpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)}, {cmd:strrpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)}:
        {it:haystack}:  {it:r1 x c1}
          {it:needle}:  {it:r2 x c2}, {it:haystack} and {it:needle} r-conformable
          {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:strpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)} and
{cmd:strrpos(}{it:haystack}{cmd:,} {it:needle}{cmd:)}
return 0 if {it:needle} is not found in {it:haystack}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
