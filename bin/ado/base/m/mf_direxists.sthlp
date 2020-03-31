{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] direxists()" "mansection M-5 direxists()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_direxists##syntax"}{...}
{viewerjumpto "Description" "mf_direxists##description"}{...}
{viewerjumpto "Conformability" "mf_direxists##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_direxists##diagnostics"}{...}
{viewerjumpto "Source code" "mf_direxists##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] direxists()} {hline 2}}Whether directory exists
{p_end}
{p2col:}({mansection M-5 direxists():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}
{cmd:direxists(}{it:string scalar dirname}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:direxists(}{it:dirname}{cmd:)}
returns 1 if {it:dirname} contains a valid path to a directory and returns 
0 otherwise.


{marker conformability}{...}
{title:Conformability}

    {cmd:direxists(}{it:dirname}{cmd:)}:
	  {it:dirname}:  1 {it:x} 1
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
