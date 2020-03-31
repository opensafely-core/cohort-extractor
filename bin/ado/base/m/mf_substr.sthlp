{smcl}
{* *! version 1.1.12  15may2018}{...}
{vieweralsosee "[M-5] substr()" "mansection M-5 substr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] subinstr()" "help mf_subinstr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_substr##syntax"}{...}
{viewerjumpto "Description" "mf_substr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_substr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_substr##remarks"}{...}
{viewerjumpto "Conformability" "mf_substr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_substr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_substr##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] substr()} {hline 2}}Extract substring
{p_end}
{p2col:}({mansection M-5 substr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix}
{cmd:substr(}{it:string matrix s}{cmd:,}
{it:real matrix b}{cmd:,}
{it:real matrix l}{cmd:)}

{p 8 12 2}
{it:string matrix}
{cmd:substr(}{it:string matrix s}{cmd:,}
{it:real matrix b}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}
returns the substring of ASCII string {it:s} starting at position {it:b} and 
continuing for a length of {it:l} characters.

{pstd}
For non-ASCII strings, {it:b} and {it:l} are interpreted as byte
positions.  To obtain character-based substrings of Unicode strings,
see {helpb mf_usubstr:[M-5] usubstr()}.

{p 4 4 2}
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:)}
is equivalent to 
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {cmd:.)}
for strings that do not contain binary 0.  If there is a binary 0 to
the right of {it:b}, the substring from {it:b} up to but not including the
binary 0 is returned.

{p 4 4 2}
When arguments are not scalar, {cmd:substr()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 substr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}
returns the substring of ASCII string {it:s} starting at position {it:b} and 
continuing for a length of {it:l}, where

{p 8 12 2}
1.  {it:b} specifies the starting position; 
    the first character of the string is {it:b}=1.

{p 8 12 2}
2.  {it:b}>0 is interpreted as distance from the start of the string; 
    {it:b}=2 means starting at the second character.

{p 8 12 2}
3.  {it:b}<0 is interpreted as distance from the end of string; {it:b} = -1
    means starting at the last character; 
    {it:b} = -2 means starting at the second from the last character.

{p 8 12 2}
4.  {it:l} specifies the length; {it:l}=2 means for two characters.

{p 8 12 2}
5.  {it:l}<0 is treated the same as {it:l}=0:  no characters are copied.

{p 8 12 2}
6.  {it:l}>={cmd:.} is interpreted to mean to the end of the string.

{p 4 4 2}
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:)}
is equivalent to 
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {cmd:.)}
for strings that do not contain binary 0.  If there is a binary 0 to
the right of {it:b}, the substring from {it:b} up to but not including the
binary 0 is returned.

{p 4 4 2}
If your string contains Unicode characters, see
{helpb mf_usubstr:[M-5] usubstr()} and
{helpb mf_udsubstr:[M-5] udsubstr()}.


{marker conformability}{...}
{title:Conformability}

    {cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}:
            {it:s}:  {it:r1 x c1}
            {it:b}:  {it:r2 x c2}
            {it:l}:  {it:r3 x c3}; {it:s}, {it:b}, and {it:l} r-conformable
       {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})

    {cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:)}:
            {it:s}:  {it:r1 x c1}
            {it:b}:  {it:r2 x c2}; {it:s} and {it:b} r-conformable
       {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
In 
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:,} {it:l}{cmd:)}
and 
{cmd:substr(}{it:s}{cmd:,} {it:b}{cmd:)}, 
if {it:b} describes a position before the beginning of the string or 
after the end, {cmd:""} is returned.
If {it:b}+{it:l} describes a position to the right of the end of the 
string, results are as if a smaller value for {it:l} were specified.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
