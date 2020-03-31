{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] _substr()" "mansection M-5 _substr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf__substr##syntax"}{...}
{viewerjumpto "Description" "mf__substr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf__substr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf__substr##remarks"}{...}
{viewerjumpto "Conformability" "mf__substr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__substr##diagnostics"}{...}
{viewerjumpto "Source code" "mf__substr##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] _substr()} {hline 2}}Substitute into string
{p_end}
{p2col:}({mansection M-5 _substr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:_substr(}{it:string scalar s}{cmd:,}
{it:string scalar tosub}{cmd:,}
{it:real scalar pos}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_substr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
substitutes {it:tosub} into {it:s} at byte position {it:pos}.
The first byte position of {it:s} is {it:pos}=1.
{cmd:_substr()} may be used with text or binary strings.

{p 4 4 2}
Do not confuse {cmd:_substr()} with {cmd:substr()}, which extracts 
substrings; see {bf:{help mf_substr:[M-5] substr()}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 _substr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If {it:s} contains "abcdef", then 
{cmd:_substr(}{it:s}{cmd:,} {cmd:"XY",} {cmd:2)} changes {it:s} to 
contain "{cmd:aXYdef}".


{marker conformability}{...}
{title:Conformability}

    {cmd:_substr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}:
	{it:input:}
		{it:s}:  1 {it:x} 1
	    {it:tosub}:  1 {it:x} 1
	      {it:pos}:  1 {it:x} 1
	{it:output:}
		{it:s}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_substr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
does nothing if {it:tosub}{cmd:==""}.

{p 4 4 2}
{cmd:_substr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
may not be used to extend {it:s}:  {cmd:_substr()} aborts with error 
if substituting {it:tosub} into {it:s} would result in a string
longer than the original {it:s}.  {cmd:_substr()} also aborts with 
error if {it:pos}<=0 or {it:pos}>={cmd:.} unless {it:tosub} is {cmd:""}.  

{p 4 4 2}
{cmd:_substr(}{it:s}{cmd:,} {it:tosub}{cmd:,} {it:pos}{cmd:)}
aborts with error if {it:s} or {it:tosub} are views.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
