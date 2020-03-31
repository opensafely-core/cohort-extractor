{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] missingof()" "mansection M-5 missingof()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_missingof##syntax"}{...}
{viewerjumpto "Description" "mf_missingof##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_missingof##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_missingof##remarks"}{...}
{viewerjumpto "Conformability" "mf_missingof##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_missingof##diagnostics"}{...}
{viewerjumpto "Source code" "mf_missingof##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] missingof()} {hline 2}}Appropriate missing value
{p_end}
{p2col:}({mansection M-5 missingof():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:transmorphic scalar}
{cmd:missingof(}{it:transmorphic matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:missingof(}{it:A}{cmd:)} returns a missing of the same element type 
as {it:A}:

{p 8 12 2}
o{bind:  }if {it:A} is real, a real missing is returned;

{p 8 12 2}
o{bind:  }if {it:A} is complex, a complex missing is returned;

{p 8 12 2}
o{bind:  }if {it:A} is pointer, {cmd:NULL} is returned;

{p 8 12 2}
o{bind:  }if {it:A} is string, "" is returned.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 missingof()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:missingof()} is useful when creating empty matrices of the same type as
another matrix; for example,

		{cmd:newmat = J(rows(x), cols(x), missingof(x))}


{marker conformability}{...}
{title:Conformability}

    {cmd:missingof(}{it:A}{it:)}
		{it:A}:  {it:r x c}
	   {it:result}:  1 {it:x 1}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
