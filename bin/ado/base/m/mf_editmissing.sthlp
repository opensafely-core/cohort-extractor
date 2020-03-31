{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] editmissing()" "mansection M-5 editmissing()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] editvalue()" "help mf_editvalue"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_editmissing##syntax"}{...}
{viewerjumpto "Description" "mf_editmissing##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_editmissing##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_editmissing##remarks"}{...}
{viewerjumpto "Conformability" "mf_editmissing##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_editmissing##diagnostics"}{...}
{viewerjumpto "Source code" "mf_editmissing##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] editmissing()} {hline 2}}Edit matrix for missing values
{p_end}
{p2col:}({mansection M-5 editmissing():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:numeric matrix}
{cmd:editmissing(}{it:numeric matrix A}{cmd:,}
{it:numeric scalar v}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_editmissing(}{it:numeric matrix a}{cmd:,}
{it:numeric scalar v}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:editmissing(}{it:A}{cmd:,} {it:v}{cmd:)}
returns {it:A} with any missing values changed to {it:v}.

{p 4 4 2}
{cmd:_editmissing(}{it:A}{cmd:,} {it:v}{cmd:)}
replaces all missing values in {it:A} with {it:v}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 editmissing()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:editmissing()} and {cmd:_editmissing()} are very fast.

{p 4 4 2}
If you want to change nonmissing values to other values, including missing,
see {bf:{help mf_editvalue:[M-5] editvalue()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:editmissing(}{it:A}{cmd:,} {it:v}{cmd:)}:
		{it:A}:  {it:r x c}
		{it:v}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_editmissing(}{it:A}{cmd:,} {it:v}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
		{it:v}:  1 {it:x} 1
	{it:output:}
		{it:A}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:editmissing(}{it:A}{cmd:,} {it:v}{cmd:)} and 
{cmd:_editmissing(}{it:A}{cmd:,} {it:v}{cmd:)}
change all missing elements to {it:v}, including not only {cmd:.} but also 
{cmd:.a}, {cmd:.b}, ..., {cmd:.z}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view editmissing.mata, adopath asis:editmissing.mata};
{cmd:_editmissing()} is built in.
{p_end}
