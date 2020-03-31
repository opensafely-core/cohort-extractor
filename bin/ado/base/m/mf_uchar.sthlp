{smcl}
{* *! version 1.0.7  15may2018}{...}
{vieweralsosee "[M-5] uchar()" "mansection M-5 uchar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ascii()" "help mf_ascii"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_uchar##syntax"}{...}
{viewerjumpto "Description" "mf_uchar##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_uchar##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_uchar##remarks"}{...}
{viewerjumpto "Conformability" "mf_uchar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_uchar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_uchar##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] uchar()} {hline 2}}Convert code point to Unicode character 
{p_end}
{p2col:}({mansection M-5 uchar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:uchar(}{it:real matrix c}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:uchar(c)} returns the Unicode character 
in UTF-8 encoding corresponding to Unicode code point {it:c}.  It returns 
an empty string if {it:c} is beyond the Unicode code-point range. 

{p 4 4 2}
When {it:c} is not a scalar, this function returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 uchar()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:uchar()} returns the same results as {helpb mf_char:char()} for 
code points 0-127.  


{marker conformability}{...}
{title:Conformability}

    {cmd:uchar(}{it:c}{cmd:)}:
	    {it:c}:  {it:r x c}
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
