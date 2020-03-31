{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] ustrunescape()" "mansection M-5 ustrunescape()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrfix()" "help mf_ustrfix"}{...}
{vieweralsosee "[M-5] ustrto()" "help mf_ustrto"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrunescape##syntax"}{...}
{viewerjumpto "Description" "mf_ustrunescape##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrunescape##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrunescape##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrunescape##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrunescape##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrunescape##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] ustrunescape()} {hline 2}}Convert escaped hex sequences to Unicode strings
{p_end}
{p2col:}({mansection M-5 ustrunescape():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:ustrunescape(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:string matrix}{space 4}{cmd:ustrtohex(}{it:string matrix s}[{cmd:,} {it:real scalar n}]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrunescape(}{it:s}{cmd:)} returns a string of 
Unicode characters corresponding to the escaped sequences in {it:s}.

{p 4 4 2}
{cmd:ustrtohex(}{it:s}[{cmd:,} {it:n}]{cmd:)} returns a string of escaped hex
digit Unicode characters, up to 200, specified in {it:s}.  If {it:n} is
specified and is larger than one, the result starts at the {it:n}th Unicode
character of {it:s}; otherwise, it starts at the first Unicode character.   

{p 4 4 2}
When {it:s} is not a scalar, these functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrunescape()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The following escape sequences are recognized by {cmd:ustrunescape()}: 

        4 hex digit form      {bf:\uhhhh}
	8 hex digit form      {bf:\Uhhhhhhhh}
	1-2 hex digit form    {bf:\xhh}
	1-3 octal digit form  {bf:\ooo}

{pstd}
where {bf:h} is in {bf:[0-9A-Fa-f]} and {bf:o} is in {bf:[0-7]}.
The standard ANSI C escape sequences {bf:\a}, {bf:\b}, {bf:\t}, {bf:\n},
{bf:\v}, {bf:\f}, {bf:\r}, {bf:\e}, {bf:\"}, {bf:\'}, {bf:\?}, and {bf:\\} are
recognized as well.  The function returns an empty string if an escape
sequence is badly formed.  Note that the 8 hex digit form {bf:\Uhhhhhhhh}
starts with a capital "U".

{p 4 4 2}
{cmd:ustrtohex()} converts each Unicode character in string {it:s} 
to an escaped hex string.  Unicode code points in the range 
{bf:\u0000–\uffff} are converted to 4 hex digit form {bf:\uhhhh}.  
Unicode code points greater than {bf:\uffff} are converted to 8 hex 
digit form {bf:\Uhhhhhhhh}.

{p 4 4 2}
{cmd:ustrtohex()} converts an invalid UTF-8 sequence to the Unicode replacement 
character {bf:\ufffd}.

{p 4 4 2}
The null terminator {bf:char(0)} is a valid Unicode character and its escaped 
form is {bf:\u0000}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrunescape(}{it:s}{cmd:)},
{cmd:ustrtohex(}{it:s}[{cmd:,} {it:n}]{cmd:)}:
{p_end}
	    {it:s}:  {it:r x c}
            {it:n}:  1 {it:x} 1 
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
