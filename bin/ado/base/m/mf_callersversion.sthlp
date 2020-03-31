{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] callersversion()" "mansection M-5 callersversion()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] version" "help m2_version"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_callersversion##syntax"}{...}
{viewerjumpto "Description" "mf_callersversion##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_callersversion##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_callersversion##remarks"}{...}
{viewerjumpto "Conformability" "mf_callersversion##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_callersversion##diagnostics"}{...}
{viewerjumpto "Source code" "mf_callersversion##source"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[M-5] callersversion()} {hline 2}}Obtain version number of caller
{p_end}
{p2col:}({mansection M-5 callersversion():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar} 
{cmd:callersversion()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:callersversion()} returns the version set by the caller 
(see {bf:{help m2_version:[M-2] version}}),
or if the caller did not set the version, it returns the version of Stata
under which the caller was compiled.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 callersversion()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:callersversion()} is how {bf:{help m2_version:[M-2] version}}
is made to work.
Say that you have written function 

		{it:real matrix} {cmd:useful(}{it:real matrix A}{cmd:,} {it:real scalar k}{cmd:)}

{p 4 4 2}
and assume that {cmd:useful()} aborts with error if {it:A} is void.
You wrote {cmd:useful()} in the days of Stata 12.  For Stata 13, you want 
to change {cmd:useful()} so that it returns {cmd:J(0,0,.)} if {it:A} is 
void, but you want to maintain the current behavior for old Stata 12
callers and programs.  You do that as follows:

	{cmd}real matrix useful(real matrix A, real scalar k)
	{
		...

		if (callersversion()>=13) {
			if (rows(A)==0 | cols(A)==0) return(J(0,0,.))
		}
		...
	}{txt}


{marker conformability}{...}
{title:Conformability}

    {cmd:callersversion()}:
	   {it:result}:  1 {it:x} 1

	
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
