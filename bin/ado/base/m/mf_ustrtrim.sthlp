{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] ustrtrim()" "mansection M-5 ustrtrim()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strtrim()" "help mf_strtrim"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrtrim##syntax"}{...}
{viewerjumpto "Description" "mf_ustrtrim##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrtrim##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrtrim##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrtrim##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrtrim##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrtrim##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] ustrtrim()} {hline 2}}Remove Unicode whitespace characters
{p_end}
{p2col:}({mansection M-5 ustrtrim():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:ustrltrim(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:ustrrtrim(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:string matrix}{space 2}{cmd:ustrtrim(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrltrim(}{it:s}{cmd:)}
returns {it:s} with leading Unicode whitespaces removed.

{p 4 4 2}
{cmd:ustrrtrim(}{it:s}{cmd:)}
returns {it:s} with trailing Unicode whitespaces removed.

{p 4 4 2}
{cmd:ustrtrim(}{it:s}{cmd:)}
returns {it:s} with leading and trailing Unicode whitespaces removed.

{p 4 4 2}
When {it:s} is not a scalar, these functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrtrim()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The functions remove all Unicode whitespace characters.  Unicode considers an 
additional set of whitespace characters besides the ASCII space character 
{cmd:char(32)}.  For example, ASCII character {cmd:9} (horizontal tab) is a
Unicode whitespace character.  Hence, {cmd:ustrtrim(char(9))=""} but 
{cmd:strtrim(char(9))=char(9)}.  ASCII codes {cmd:char(10)}, {cmd:char(11)}, 
{cmd:char(12)}, and {cmd:char(13)} are also Unicode whitespace characters.  
See {browse "http://unicode.org/charts/collation/chart_Whitespace.html"}
for the list of all Unicode whitespace characters.

{p 4 4 2}
Use functions {helpb mf_strtrim:strtrim()}, {helpb mf_strtrim:strltrim()}, 
{helpb mf_strtrim:strrtrim()}, and {helpb mf_strtrim:stritrim()} to trim only 
the ASCII space character {cmd:char(32)} in a string. 


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrltrim(}{it:s}{cmd:)},
{cmd:ustrrtrim(}{it:s}{cmd:)},
{cmd:ustrtrim(}{it:s}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrltrim(}{it:s}{cmd:)},
{cmd:ustrrtrim(}{it:s}{cmd:)}, and
{cmd:ustrtrim(}{it:s}{cmd:)}
return an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
