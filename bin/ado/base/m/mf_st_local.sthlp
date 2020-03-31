{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] st_local()" "mansection M-5 st_local()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_local##syntax"}{...}
{viewerjumpto "Description" "mf_st_local##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_local##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_local##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_local##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_local##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_local##source"}{...}
{viewerjumpto "Reference" "mf_st_local##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] st_local()} {hline 2}}Obtain strings from and put strings into Stata macros
{p_end}
{p2col:}({mansection M-5 st_local():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar} 
{cmd:st_local(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_local(}{it:string scalar name}{cmd:,} 
{it:string scalar contents}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_local(}{it:name}{cmd:)} returns the contents of the specified local
macro.

{p 4 4 2}
{cmd:st_local(}{it:name}{cmd:,} {it:contents}{cmd:)} sets or resets the
contents of the specified local macro.  If the macro did not previously exist,
a new macro is created.  If it did previously exist, the new contents replace
the old.  To remove a local macro from Mata, type
{cmd:st_local(}{it:name}{cmd:, "")}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_local()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help mf_st_global:[M-5] st_global()}}
and
{bf:{help mf_st_rclear:[M-5] st_rclear()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_local(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_local(}{it:name}{cmd:,} {it:contents}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	 {it:contents}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_local(}{it:name}{cmd:)} returns "" if the name contained in 
{it:name} is not defined.  {cmd:st_local(}{it:name}{cmd:)} aborts with
error if the name is malformed.

{p 4 4 2}
{cmd:st_local(}{it:name}{cmd:,} {it:contents}{cmd:)} aborts with error if
the name contained in {it:name} is malformed.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2008.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0040":Mata Matters: Macros}.
{it:Stata Journal} 8: 401-412.
{p_end}
