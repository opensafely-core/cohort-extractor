{smcl}
{* *! version 1.2.6  15may2018}{...}
{vieweralsosee "[M-5] cat()" "mansection M-5 cat()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_cat##syntax"}{...}
{viewerjumpto "Description" "mf_cat##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cat##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cat##remarks"}{...}
{viewerjumpto "Conformability" "mf_cat##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cat##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cat##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] cat()} {hline 2}}Load file into string matrix
{p_end}
{p2col:}({mansection M-5 cat():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string colvector}
{cmd:cat(}{it:string scalar {help filename}} [{cmd:,}
{it:real scalar line1} [{cmd:,}
{it:real scalar line2}]]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cat(}{it:{help filename}}{cmd:)} returns a column vector containing the 
lines from text file {it:filename}.

{p 4 4 2}
{cmd:cat(}{it:filename}{cmd:,} {it:line1}{cmd:)} returns a column
vector containing the lines from text file {it:filename} starting
with line number {it:line1}.

{p 4 4 2}
{cmd:cat(}{it:filename}{cmd:,} {it:line1}{cmd:,} {it:line2}{cmd:)}
returns a column vector containing the lines from text file
{it:filename} starting with line number {it:line1} and ending
with line number {it:line2}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cat()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:cat(}{it:filename}{cmd:)} removes new-line characters at the end 
of lines.


{marker conformability}{...}
{title:Conformability}

    {cmd:cat(}{it:filename}{cmd:,} {it:line1}{cmd:,} {it:line2}{cmd:)}:
	 {it:filename}:  1 {it:x} 1
	    {it:line1}:  1 {it:x} 1        (optional)
	    {it:line2}:  1 {it:x} 1        (optional)
	   {it:result}:  {it:r x} 1, {it:r}>=0


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:cat(}{it:filename}{cmd:)} aborts with error if {it:filename} does not 
exist.

{p 4 4 2}
{cmd:cat()} returns a 0 {it:x} 1 result if {it:filename} contains 0 bytes.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view cat.mata, adopath asis:cat.mata}
{p_end}
