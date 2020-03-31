{smcl}
{* *! version 1.0.4  15may2018}{...}
{vieweralsosee "[M-5] usubinstr()" "mansection M-5 usubinstr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_usubinstr##syntax"}{...}
{viewerjumpto "Description" "mf_usubinstr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_usubinstr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_usubinstr##remarks"}{...}
{viewerjumpto "Conformability" "mf_usubinstr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_usubinstr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_usubinstr##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] usubinstr()} {hline 2}}Replace Unicode substring
{p_end}
{p2col:}({mansection M-5 usubinstr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 34 2}
{it:string matrix}
{cmd:usubinstr(}{it:string matrix s}{cmd:,}
                  {it:string matrix old}{cmd:,}{break} 
                  {it:string matrix new}{cmd:,} {it:real matrix cnt}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:usubinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
replaces the first {it:cnt} occurrences of the Unicode string {it:old} with 
the Unicode string {it:new} in {it:s}.  If {it:cnt} is {it:missing}, all 
occurrences are replaced. 

{p 4 4 2}
When arguments are not scalar, this function returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 usubinstr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
An invalid UTF-8 sequence in {it:s}, {it:old}, or {it:new} is replaced with
the Unicode replacement character {bf:\ufffd} before replacement is performed.

{p 4 4 2}
Use {helpb mf_subinstr:subinstr()} if your string does not contain Unicode
characters or if you want to replace the substring based on bytes. 


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:usubinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c}
	      {it:old}:  {it:r x c} or 1 {it:x} 1
	      {it:new}:  {it:r x c} or 1 {it:x} 1
	      {it:cnt}:  {it:r x c} or 1 {it:x} 1
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:usubinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
returns an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
