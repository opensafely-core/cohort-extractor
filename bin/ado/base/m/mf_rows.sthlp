{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] rows()" "mansection M-5 rows()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_rows##syntax"}{...}
{viewerjumpto "Description" "mf_rows##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_rows##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_rows##remarks"}{...}
{viewerjumpto "Conformability" "mf_rows##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_rows##diagnostics"}{...}
{viewerjumpto "Source code" "mf_rows##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] rows()} {hline 2}}Number of rows and number of columns
{p_end}
{p2col:}({mansection M-5 rows():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}
{cmd:rows(}{it:transmorphic matrix P}{cmd:)}

{p 8 8 2}
{it:real scalar}
{cmd:cols(}{it:transmorphic matrix P}{cmd:)}

{p 8 8 2}
{it:real scalar}
{cmd:length(}{it:transmorphic matrix P}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:rows(}{it:P}{cmd:)} returns the number of rows of {it:P}.

{p 4 4 2}
{cmd:cols(}{it:P}{cmd:)} returns the number of columns of {it:P}.

{p 4 4 2}
{cmd:length(}{it:P}{cmd:)} returns 
{cmd:rows(}{it:P}{cmd:)}*{cmd:cols(}{it:P}{cmd:)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 rows()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:length(}{it:P}{cmd:)}
is typically used with vectors, as in 

	{cmd:for (i=1; i<=length(x); i++) {c -(}}
		... {cmd:x[i]} ...
	{cmd:{c )-}}


{marker conformability}{...}
{title:Conformability}

    {cmd:rows(}{it:P}{cmd:)}, {cmd:cols(}{it:P}{cmd:)}, {cmd:length(}{it:P}{cmd:)}:
		{it:P}:  {it:r} {it:x} {it:c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:rows(}{it:P}{cmd:)}, {cmd:cols(}{it:P}{cmd:)}, and 
{cmd:length(}{it:P}{cmd:)} return a result that is
greater than or equal to zero.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
