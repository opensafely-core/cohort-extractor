{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] udstrlen()" "mansection M-5 udstrlen()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strlen()" "help mf_strlen"}{...}
{vieweralsosee "[M-5] ustrlen()" "help mf_udstrlen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrdiunicode}{...}
{viewerjumpto "Syntax" "mf_udstrlen##syntax"}{...}
{viewerjumpto "Description" "mf_udstrlen##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_udstrlen##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_udstrlen##remarks"}{...}
{viewerjumpto "Conformability" "mf_udstrlen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_udstrlen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_udstrlen##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] udstrlen()} {hline 2}}Length of Unicode string in display columns
{p_end}
{p2col:}({mansection M-5 udstrlen():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:udstrlen(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)} returns the number of columns needed to display 
the Unicode string {it:s} in Stata's Results window.

{p 4 4 2}
When {it:s} is not a scalar, {cmd:udstrlen()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 udstrlen()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Unicode characters from the Chinese, Japanese, and Korean languages usually 
require two display columns.  A Latin character usually requires one column.  
Any invalid UTF-8 sequence requires one column.
See {findalias frdiunicode} for details.

{p 4 4 2}
Use {helpb mf_ustrlen:ustrlen()} to obtain the length of a string in Unicode 
characters.  Use {helpb mf_strlen:strlen()} to obtain the length of a string
in bytes.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)}:
{p_end}
            {it:s}:  {it:r x c}
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)} returns a negative error code if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
