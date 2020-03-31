{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] designmatrix()" "mansection M-5 designmatrix()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_designmatrix##syntax"}{...}
{viewerjumpto "Description" "mf_designmatrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_designmatrix##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_designmatrix##remarks"}{...}
{viewerjumpto "Conformability" "mf_designmatrix##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_designmatrix##diagnostics"}{...}
{viewerjumpto "Source code" "mf_designmatrix##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] designmatrix()} {hline 2}}Design matrices
{p_end}
{p2col:}({mansection M-5 designmatrix():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:designmatrix(}{it:real colvector v}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:designmatrix(}{it:v}{cmd:)}
returns a {cmd:rows(}{it:v}{cmd:)}
{it:x}
{cmd:colmax(}{it:v}{cmd:)} matrix with ones in the 
indicated columns and zero everywhere else.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 designmatrix()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:designmatrix((1\2\3))} is equal to {cmd:I(3)}, the 3 {it:x} 3 identity
matrix.


{marker conformability}{...}
{title:Conformability}

    {cmd:designmatrix(}{it:v}{cmd:)}:
		{it:v}:  {it:r} {it:x} 1
	   {it:result}:  {it:r} {it:x} {cmd:colmax(}{it:v}{cmd:)} (0 {it:x} 0 if {it:r}=0)


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:designmatrix(}{it:v}{cmd:)}
aborts with error if any element of {it:v} is <1.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view designmatrix.mata, adopath asis:designmatrix.mata}
{p_end}
