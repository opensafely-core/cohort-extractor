{smcl}
{* *! version 1.0.7  15may2018}{...}
{vieweralsosee "[M-5] _negate()" "mansection M-5 _negate()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf__negate##syntax"}{...}
{viewerjumpto "Description" "mf__negate##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf__negate##linkspdf"}{...}
{viewerjumpto "Remarks" "mf__negate##remarks"}{...}
{viewerjumpto "Conformability" "mf__negate##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__negate##diagnostics"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] _negate()} {hline 2}}Negate real matrix
{p_end}
{p2col:}({mansection M-5 _negate():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:_negate(}{it:real matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_negate(}{it:X}{cmd:)} speedily replaces {it:X} = -{it:X}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 _negate()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Coding {cmd:_negate(X)} executes more quickly than coding 
{cmd:X = -X}.

{p 4 4 2}
However, coding 

	{cmd:B = A}
	{cmd:_negate(B)}

{p 4 4 2}
does not execute more quickly than coding

	{cmd:B = -A}


{marker conformability}{...}
{title:Conformability}

    {cmd:_negate(}{it:X}{cmd:)}:
		{it:X}:  {it:r} {it:x} {it:c}
           {it:result}:  {it:void}

		
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.  {it:X} may be a view.
{p_end}
