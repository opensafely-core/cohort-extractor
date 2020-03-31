{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] ustrfix()" "mansection M-5 ustrfix()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrto()" "help mf_ustrto"}{...}
{vieweralsosee "[M-5] ustrunescape()" "help mf_ustrunescape"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrfix##syntax"}{...}
{viewerjumpto "Description" "mf_ustrfix##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrfix##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrfix##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrfix##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrfix##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrfix##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] ustrfix()} {hline 2}}Replace invalid UTF-8 sequences in Unicode
string
{p_end}
{p2col:}({mansection M-5 ustrfix():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:string matrix}
{cmd:ustrfix(}{it:string matrix s} [{cmd:,} {it:string scalar rep}]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrfix(}{it:s} [{cmd:,} {it:rep}]{cmd:)}
replaces each invalid UTF-8 sequence with a Unicode character.  If {it:rep} 
is specified and it starts with a Unicode character, the Unicode character 
is used.  Otherwise, the Unicode replacement character {bf:\ufffd} is used.  

{p 4 4 2}
When arguments are not scalar, the function returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrfix()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
An invalid UTF-8 sequence may contain one byte or multiple bytes.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrfix(}{it:string matrix s} [{cmd:,} {it:string scalar r}]{cmd:)}
{p_end}
		{it:s}:  {it:r x c}
	      {it:rep}:  1 {it:x} 1
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrfix(}{it:matrix s} [{cmd:,} {it:r}]{cmd:)}
returns an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
