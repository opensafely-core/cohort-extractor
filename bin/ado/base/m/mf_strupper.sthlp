{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] strupper()" "mansection M-5 strupper()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrupper()" "help mf_ustrupper"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strupper##syntax"}{...}
{viewerjumpto "Description" "mf_strupper##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strupper##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strupper##remarks"}{...}
{viewerjumpto "Conformability" "mf_strupper##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strupper##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strupper##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] strupper()} {hline 2}}Convert ASCII string to uppercase (lowercase)
{p_end}
{p2col:}({mansection M-5 strupper():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:strupper(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:strlower(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:strproper(}{it:string matrix s}{cmd:)}



{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strupper(}{it:s}{cmd:)} returns {it:s}, converted to uppercase.

{p 4 4 2}
{cmd:strlower(}{it:s}{cmd:)} returns {it:s}, converted to lowercase.

{p 4 4 2}
{cmd:strproper(}{it:s}{cmd:)} returns a string with the first ASCII letter
capitalized and any other ASCII letters capitalized that immediately follow
characters that are not letters; all other letters are converted to lowercase.

{p 4 4 2}
When {it:s} is not a scalar, these functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strupper()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:strproper("mR. joHn a. sMitH")} returns "Mr. John A. Smith".

{p 4 4 2}
{cmd:strproper("jack o'reilly")} returns "Jack O'Reilly".

{p 4 4 2}
{cmd:strproper("2-cent's worth")} returns "2-Cent'S Worth".

{p 4 4 2}
Use {helpb mf_ustrupper:ustrupper()} and {helpb mf_ustrupper:ustrlower()} to 
convert Unicode characters in a string to uppercase and lowercase.
 

{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:strupper(}{it:s}{cmd:)},
{cmd:strlower(}{it:s}{cmd:)},
{cmd:strproper(}{it:s}{cmd:)}:
{p_end}
	    {it:s}:  {it:r x c}
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
