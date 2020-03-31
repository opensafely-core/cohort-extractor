{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] favorspeed()" "mansection M-5 favorspeed()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata set" "help mata_set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_favorspeed##syntax"}{...}
{viewerjumpto "Description" "mf_favorspeed##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_favorspeed##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_favorspeed##remarks"}{...}
{viewerjumpto "Conformability" "mf_favorspeed##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_favorspeed##diagnostics"}{...}
{viewerjumpto "Source code" "mf_favorspeed##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] favorspeed()} {hline 2}}Whether speed or space is to be favored
{p_end}
{p2col:}({mansection M-5 favorspeed():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar} 
{cmd:favorspeed()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:favorspeed()} returns 
1 if the user has 
{cmd:mata} {cmd:set} {cmd:matafavor} {cmd:speed}
and 0 if the user has 
{cmd:mata} {cmd:set} {cmd:matafavor} {cmd:space} or has not set
{cmd:matafavor} at all; see 
{bf:{help mata_set:[M-3] mata set}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 favorspeed()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Sometimes in programming you can choose between writing code 
that runs faster but consumes more memory or writing code that conserves 
memory at the cost of execution speed.  {cmd:favorspeed()} tells you 
the user's preference:

	{cmd}if (favorspeed()) {c -(}
		/* code structured for speed over memory */
	{c )-}
	else {c -(}
		/* code structured for memory over speed */
	{c )-}{txt}


{marker conformability}{...}
{title:Conformability}

    {cmd:favorspeed()}:
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
