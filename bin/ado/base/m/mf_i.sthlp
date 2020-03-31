{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] I()" "mansection M-5 I()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_i##syntax"}{...}
{viewerjumpto "Description" "mf_i##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_i##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_i##remarks"}{...}
{viewerjumpto "Conformability" "mf_i##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_i##diagnostics"}{...}
{viewerjumpto "Source code" "mf_i##source"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-5] I()} {hline 2}}Identity matrix
{p_end}
{p2col:}({mansection M-5 I():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:I(}{it:real scalar n}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:I(}{it:real scalar m}{cmd:,} {it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:I(}{it:n}{cmd:)} 
returns the {it:n x n} identity matrix.

{p 4 4 2}
{cmd:I(}{it:m}{cmd:,} {it:n}{cmd:)} 
returns an {it:m x n} matrix with 1s down its principal diagonal and 0s 
elsewhere.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 I()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:I()} must be typed in uppercase.


{marker conformability}{...}
{title:Conformability}

    {cmd:I(}{it:n}{cmd:)}:
		{it:n}:  1 {it:x} {it:1}
	   {it:result}:  {it:n x n}

    {cmd:I(}{it:m}{cmd:,} {it:n}{cmd:)}:
		{it:m}:  1 {it:x} {it:1}
		{it:n}:  1 {it:x} {it:1}
	   {it:result}:  {it:m x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:I(}{it:n}{cmd:)} aborts with error if {it:n} is less than 0 or is
missing.
{it:n} is interpreted as {cmd:trunc(}{it:n}{cmd:)}.

{p 4 4 2}
{cmd:I(}{it:m}{cmd:,} {it:n}{cmd:)} 
aborts with error if {it:m} or {it:n} are less than 0
or if they are missing.
{it:m} and {it:n} are interpreted as 
{cmd:trunc(}{it:m}{cmd:)} and 
{cmd:trunc(}{it:n}{cmd:)}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
