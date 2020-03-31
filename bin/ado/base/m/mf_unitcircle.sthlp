{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] unitcircle()" "mansection M-5 unitcircle()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_unitcircle##syntax"}{...}
{viewerjumpto "Description" "mf_unitcircle##description"}{...}
{viewerjumpto "Conformability" "mf_unitcircle##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_unitcircle##diagnostics"}{...}
{viewerjumpto "Source code" "mf_unitcircle##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] unitcircle()} {hline 2}}Complex vector containing unit circle
{p_end}
{p2col:}({mansection M-5 unitcircle():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:complex colvector} 
{cmd:unitcircle(}{it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:unitcircle(}{it:n}{cmd:)}
returns a column vector containing 
{cmd:C(cos(}{it:theta}{cmd:), sin(}{it:theta}{cmd:))} for
0<={it:theta}<=2*{cmd:pi()} in {it:n} points.


{marker conformability}{...}
{title:Conformability}

    {cmd:unitcircle(}{it:n}{cmd:)}:
		{it:n}:  1 {it:x} 1
	   {it:result}:  {it:n} {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view unitcircle.mata, adopath asis:unitcircle.mata}
{p_end}
