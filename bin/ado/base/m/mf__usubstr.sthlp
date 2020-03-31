{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] _usubstr()" "mansection M-5 _usubstr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf__usubstr##syntax"}{...}
{viewerjumpto "Description" "mf__usubstr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf__usubstr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf__usubstr##remarks"}{...}
{viewerjumpto "Conformability" "mf__usubstr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__usubstr##diagnostics"}{...}
{viewerjumpto "Source code" "mf__usubstr##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] _usubstr()} {hline 2}}Substitute into Unicode string
{p_end}
{p2col:}({mansection M-5 _usubstr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:_usubstr(}{it:string scalar s}{cmd:,}
{it:string scalar tosub}{cmd:,}
{it:real scalar pos}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_usubstr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
substitutes {it:tosub} into {it:s} at Unicode character position {it:pos}.
The first Unicode character position of {it:s} is {it:pos}=1.
{cmd:_usubstr()} may be used with text or binary strings.

{p 4 4 2}
Do not confuse {cmd:_usubstr()} with {cmd:usubstr()}, which extracts 
Unicode substrings; see {bf:{help mf_substr:[M-5] usubstr()}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 _usubstr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If {it:s} contains "café", then 
{cmd:_usubstr(}{it:s}{cmd:,} {cmd:"fe",} {cmd:3)} changes {it:s} to 
contain "{cmd:cafe}".

{p 4 4 2}
Invalid UTF-8 sequences in both {it:s} and {it:tosub} are replaced with
the Unicode replacement character {bf:\ufffd} before substitution. 


{marker conformability}{...}
{title:Conformability}

    {cmd:_usubstr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}:
	{it:input:}
		{it:s}:  1 {it:x} 1
	    {it:tosub}:  1 {it:x} 1
	      {it:pos}:  1 {it:x} 1
	{it:output:}
		{it:s}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_usubstr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
does nothing if {it:tosub}{cmd:==""}.

{p 4 4 2}
{cmd:_usubstr()} aborts with an error message if substituting {it:tosub} into
{it:s} would result in a string longer than the original {it:s} in Unicode
characters.  {cmd:_usubstr()} also aborts with an error message if {it:pos}<=0
or {it:pos}>={cmd:.} unless {it:tosub}{cmd:==""}.  

{p 4 4 2}
{cmd:_usubstr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
aborts with an error if {it:s} or {it:tosub} are views.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
