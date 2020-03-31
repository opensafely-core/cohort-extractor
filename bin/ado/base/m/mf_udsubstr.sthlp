{smcl}
{* *! version 1.0.5  15may2018}{...}
{vieweralsosee "[M-5] udsubstr()" "mansection M-5 udsubstr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_udsubstr##syntax"}{...}
{viewerjumpto "Description" "mf_udsubstr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_udsubstr##linkspdf"}{...}
{viewerjumpto "Remark" "mf_udsubstr##remark"}{...}
{viewerjumpto "Conformability" "mf_udsubstr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_udsubstr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_udsubstr##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] udsubstr()} {hline 2}}Extract Unicode substring based on display columns
{p_end}
{p2col:}({mansection M-5 udsubstr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 52 2}
{it:string matrix}
{cmd:udsubstr(}{it:string matrix s}{cmd:,}
{it:real matrix n1}{cmd:,}{break}
{it:real matrix n2}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:udsubstr(}{it:s}{cmd:,} {it:n1}{cmd:,} {it:n2}{cmd:)}
returns the Unicode substring of {it:s}, starting at Unicode character
{it:n1}, for {it:n2} display columns.  If {it:n2} = {cmd:.}
({it:missing}), the remaining portion of the Unicode string is returned.  If
{it:n2} display columns from Unicode character {it:n1} is in the middle of a
Unicode character, the substring stops at the previous Unicode character.

{p 4 4 2}
When arguments are not scalar, {cmd:udsubstr()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 udsubstr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remark}{...}
{title:Remark}

{p 4 4 2}
{it:n1} < 0 is interpreted as distance from the end of the Unicode 
string; {bind:{it:n1} = -1} means starting at the last Unicode character. 

{p 4 4 2}
An invalid UTF-8 sequence is replaced with a Unicode replacement character
{bf:\ufffd}.  Null terminator {cmd:char(0)} in a binary string is a valid
UTF-8 character and will be counted and treated as such. 

{p 4 4 2}
Use {helpb mf_usubstr:usubstr()} to extract a substring based on Unicode
characters.  Use {helpb mf_substr:substr()} to extract a substring based on
bytes.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:udsubstr(}{it:s}{cmd:,} {it:n1}{cmd:,} {it:n2}{cmd:)}:
{p_end}
            {it:s}:  {it:r x c}
           {it:n1}:  {it:r x c} or 1 {it:x} 1
           {it:n2}:  {it:r x c} or 1 {it:x} 1
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:udsubstr(}{it:s}{cmd:,} {it:n1}{cmd:,} {it:n2}{cmd:)}
returns an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
