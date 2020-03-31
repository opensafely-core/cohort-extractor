{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] strmatch()" "mansection M-5 strmatch()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strmatch##syntax"}{...}
{viewerjumpto "Description" "mf_strmatch##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strmatch##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strmatch##remarks"}{...}
{viewerjumpto "Conformability" "mf_strmatch##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strmatch##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strmatch##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] strmatch()} {hline 2}}Determine whether string matches pattern
{p_end}
{p2col:}({mansection M-5 strmatch():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:strmatch(}{it:string matrix s}{cmd:,} 
{it:string matrix pattern}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strmatch(}{it:s}{cmd:,} {it:pattern}{cmd:)} returns 1 if {it:s} matches
{it:pattern} and 0 otherwise.  

{p 4 4 2}
When arguments are not scalar, {cmd:strmatch()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strmatch()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
In {it:pattern}, {cmd:*} means that 0 or more characters go here and 
{cmd:?} means that exactly one Unicode character goes here.
Thus {it:pattern}{cmd:="*"} matches anything and 
{it:pattern}{cmd:="?p*x"} matches all strings whose second character is
{it:p} and whose last character is {it:x}.


{marker conformability}{...}
{title:Conformability}

    {cmd:strmatch(}{it:s}{cmd:,} {it:pattern}{cmd:)}:
	    {it:s}:  {it:r1 x c1} 
      {it:pattern}:  {it:r2 x c2}, {it:s} and {it:pattern} r-conformable
       {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
In {cmd:strmatch(}{it:s}{cmd:,} {it:pattern}{cmd:)}, if {it:s} or {it:pattern}
contain a binary 0 (they usually would not), the strings are considered to end
at that point.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
