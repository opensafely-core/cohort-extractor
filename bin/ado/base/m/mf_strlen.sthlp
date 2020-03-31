{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] strlen()" "mansection M-5 strlen()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fmtwidth()" "help mf_fmtwidth"}{...}
{vieweralsosee "[M-5] strpos()" "help mf_strpos"}{...}
{vieweralsosee "[M-5] udstrlen()" "help mf_udstrlen"}{...}
{vieweralsosee "[M-5] ustrlen()" "help mf_ustrlen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strlen##syntax"}{...}
{viewerjumpto "Description" "mf_strlen##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strlen##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strlen##remarks"}{...}
{viewerjumpto "Conformability" "mf_strlen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strlen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strlen##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] strlen()} {hline 2}}Length of string in bytes
{p_end}
{p2col:}({mansection M-5 strlen():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:strlen(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strlen(}{it:s}{cmd:)} returns the length of -- the number of bytes 
contained in -- the string {it:s}.

{p 4 4 2}
When {it:s} is not a scalar, {cmd:strlen()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strlen()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Stata understands {cmd:length()} as a synonym for its {helpb strlen()}
function.  Do not, however, use {cmd:length()} in Mata when you mean
{cmd:strlen()}.  Mata's {cmd:length()} function returns the length (number of
elements) of a vector.

{p 4 4 2}
Use {helpb mf_ustrlen:ustrlen()} to obtain the length of a string in Unicode
characters.  Use {helpb mf_udstrlen:udstrlen()} to obtain the length of a
string in display columns. 
 

{marker conformability}{...}
{title:Conformability}

    {cmd:strlen(}{it:s}{cmd:)}:
	{it:s}:  {it:r x c}
   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:strlen(}{it:s}{cmd:)}, when {it:s} is a binary string (a string
containing binary 0), returns the overall length of the string, not the
location of the binary 0.  Use {cmd:strpos(}{it:s}{cmd:, char(0))} if you want
the location of the binary 0; see {helpb mf_strpos:[M-5] strpos()}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
