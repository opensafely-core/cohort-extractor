{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] usubstr()" "mansection M-5 usubstr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_usubstr##syntax"}{...}
{viewerjumpto "Description" "mf_usubstr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_usubstr##linkspdf"}{...}
{viewerjumpto "Remark" "mf_usubstr##remark"}{...}
{viewerjumpto "Conformability" "mf_usubstr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_usubstr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_usubstr##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] usubstr()} {hline 2}}Extract Unicode substring
{p_end}
{p2col:}({mansection M-5 usubstr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 32 2}
{it:string matrix}{space 3}{cmd:usubstr(}{it:string matrix s}{cmd:,} {it:real matrix n1}{cmd:,}{break}
{it:real matrix n2}{cmd:)}

{p 8 32 2}
{it:string matrix}{space 2}{cmd:ustrleft(}{it:string matrix s}{cmd:,} {it:real matrix n}{cmd:)}

{p 8 32 2}
{it:string matrix} {cmd:ustrright(}{it:string matrix s}{cmd:,} {it:real matrix n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:usubstr(}{it:s}{cmd:,} {it:n1}{cmd:,} {it:n2}{cmd:)}
returns the Unicode substring of {it:s}, starting at Unicode character
{it:n1}, for a length of {it:n2}.  If {it:n1} < 0, {it:n1} is interpreted as
the distance from the last Unicode character of {it:s}; if {it:n2} =
{cmd:.} ({it:missing}), the remaining portion of the Unicode string is
returned. 

{p 4 4 2}
{cmd:ustrleft(}{it:s}{cmd:,} {it:n}{cmd:)}
returns the first {it:n} Unicode characters of the Unicode string {it:s}. 

{p 4 4 2}
{cmd:ustrright(}{it:s}{cmd:,} {it:n}{cmd:)}
returns the last {it:n} Unicode characters of the Unicode string {it:s}.

{p 4 4 2}
When arguments are not scalar, the functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 usubstr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remark}{...}
{title:Remarks}

{p 4 4 2}
{it:n} < 0 is interpreted as the distance from the end of the Unicode 
string; {bind:{it:n} = -1} means the distance starting at the last Unicode
character. 

{p 4 4 2}
An invalid UTF-8 sequence is replaced with a Unicode replacement character 
{bf:\ufffd}.  Null terminator {cmd:char(0)} in a binary string is a valid
UTF-8 character and will be counted and treated as such. 

{p 4 4 2}
Use {helpb mf_udsubstr:udsubstr()} to extract a substring based on display 
columns.  Use {helpb mf_substr:substr()} to extract a substring based on bytes.


{marker conformability}{...}
{title:Conformability}

    {cmd:usubstr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}:
            {it:s}:  {it:r x c}
            {it:b}:  {it:r x c} or 1 {it:x} 1
            {it:l}:  {it:r x c} or 1 {it:x} 1
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:usubstr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)},
{cmd:ustrleft(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}, and
{cmd:ustrright(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}
return an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
