{smcl}
{* *! version 1.0.0  23jan2019}{...}
{vieweralsosee "[M-5] isascii()" "mansection M-5 isascii()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ascii()" "help mf_ascii"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_isascii##syntax"}{...}
{viewerjumpto "Description" "mf_isascii##description"}{...}
{viewerjumpto "Conformability" "mf_isascii##conformability"}{...}
{viewerjumpto "Source code" "mf_isascii##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] isascii()} {hline 2}}Whether string scalar contains only ASCII codes
{p_end}
{p2col:}({mansection M-5 isascii():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:isascii(}{it:string scalar s}{cmd:)}


{marker description}{...}
{title:Description} 

{p 4 4 2}
{cmd:isascii(}{it:s}{cmd:)} returns 1 if string scalar {it:s} contains only
ASCII codes (0-127) and 0 otherwise.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:isascii(}{it:s}{cmd:)}:
{p_end}
		{it:s}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
