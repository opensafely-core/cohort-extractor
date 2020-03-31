{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_isname()" "mansection M-5 st_isname()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_isname##syntax"}{...}
{viewerjumpto "Description" "mf_st_isname##description"}{...}
{viewerjumpto "Conformability" "mf_st_isname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_isname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_isname##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_isname()} {hline 2}}Whether valid Stata name
{p_end}
{p2col:}({mansection M-5 st_isname():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:st_isname(}{it:string scalar s}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:st_islmname(}{it:string scalar s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_isname(}{it:s}{cmd:)}
returns 1 if {it:s} contains a valid Stata name and 0 otherwise.

{p 4 4 2}
{cmd:st_islmname(}{it:s}{cmd:)}
returns 1 if {it:s} contains a valid Stata local-macro name and 0 otherwise.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_isname(}{it:s}{cmd:)}, {cmd:st_islmname(}{it:s}{cmd:)}:
		{it:s}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_isname(}{it:s}{cmd:)}
aborts with error if {it:s} is a view
(but {cmd:st_islmname()} does not).


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_islmname.mata, adopath asis:st_islmname.mata};
{cmd:st_isname()} is built in.
{p_end}
