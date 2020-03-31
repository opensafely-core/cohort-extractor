{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] missing()" "mansection M-5 missing()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] editmissing()" "help mf_editmissing"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_missing##syntax"}{...}
{viewerjumpto "Description" "mf_missing##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_missing##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_missing##remarks"}{...}
{viewerjumpto "Conformability" "mf_missing##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_missing##diagnostics"}{...}
{viewerjumpto "Source code" "mf_missing##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] missing()} {hline 2}}Count missing and nonmissing values
{p_end}
{p2col:}({mansection M-5 missing():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real rowvector} {cmd:colmissing(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real colvector} {cmd:rowmissing(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:       }{cmd:missing(}{it:numeric matrix X}{cmd:)}


{p 8 8 2}
{it:real rowvector} {cmd:colnonmissing(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real colvector} {cmd:rownonmissing(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:       }{cmd:nonmissing(}{it:numeric matrix X}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:       }{cmd:hasmissing(}{it:numeric matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions return the indicated count of missing or nonmissing values.

{p 4 4 2}
{cmd:colmissing(}{it:X}{cmd:)}
returns the count of missing values of each column of {it:X},
{cmd:rowmissing(}{it:X}{cmd:)}
returns the count of missing values of each row, 
and {cmd:missing(}{it:X}{cmd:)}
returns the overall count.

{p 4 4 2}
{cmd:colnonmissing(}{it:X}{cmd:)}
returns the count of nonmissing values of each column of {it:X},
{cmd:rownonmissing(}{it:X}{cmd:)}
returns the count of nonmissing values of each row, 
and {cmd:nonmissing(}{it:X}{cmd:)}
returns the overall count.

{p 4 4 2}
{cmd:hasmissing(}{it:X}{cmd:)}
returns 1 if {it:X} has a missing value or 0 if {it:X} does not 
have a missing value.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 missing()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

	    {cmd:colnonmissing(}{it:X}{cmd:)}  =  {cmd:rows(}{it:X}{cmd:) :- colmissing(}{it:X}{cmd:)}

	    {cmd:rownonmissing(}{it:X}{cmd:)}  =  {cmd:cols(}{it:X}{cmd:) :- rowmissing(}{it:X}{cmd:)}

	       {cmd:nonmissing(}{it:X}{cmd:)}  =  {cmd:rows(}{it:X}{cmd:)*cols(}{it:X}{cmd:) - missing(}{it:X}{cmd:)}



{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:colmissing(}{it:X}{cmd:)},
    {cmd:colnonmissing(}{it:X}{cmd:)}:
{p_end}
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x c}

{p 4 4 2}
    {cmd:rowmissing(}{it:X}{cmd:)},
    {cmd:rownonmissing(}{it:X}{cmd:)}:
{p_end}
		{it:X}:  {it:r x c}
	   {it:result}:  {it:r x} 1

{p 4 4 2}
    {cmd:missing(}{it:X}{cmd:)},
    {cmd:nonmissing(}{it:X}{cmd:)},
    {cmd:hasmissing(}{it:X}{cmd:)}:
{p_end}
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
