{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_isfmt()" "mansection M-5 st_isfmt()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_isfmt##syntax"}{...}
{viewerjumpto "Description" "mf_st_isfmt##description"}{...}
{viewerjumpto "Conformability" "mf_st_isfmt##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_isfmt##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_isfmt##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] st_isfmt()} {hline 2}}Whether valid %fmt
{p_end}
{p2col:}({mansection M-5 st_isfmt():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:st_isfmt(}{it:string scalar s}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:st_isnumfmt(}{it:string scalar s}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:st_isstrfmt(}{it:string scalar s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_isfmt(}{it:s}{cmd:)}
returns 1 if {it:s} contains a valid Stata {help format:{bf:%}{it:fmt}} and 0
otherwise.

{p 4 4 2}
{cmd:st_isnumfmt(}{it:s}{cmd:)}
returns 1 if {it:s} contains a valid Stata numeric {cmd:%}{it:fmt} and 0
otherwise.

{p 4 4 2}
{cmd:st_isstrfmt(}{it:s}{cmd:)}
returns 1 if {it:s} contains a valid Stata string {cmd:%}{it:fmt} and 0
otherwise.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_isfmt(}{it:s}{cmd:)},
{cmd:st_isnumfmt(}{it:s}{cmd:)},
{cmd:st_isstrfmt(}{it:s}{cmd:)}:
{p_end}
		{it:s}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_isfmt(}{it:s}{cmd:)},
{cmd:st_isnumfmt(}{it:s}{cmd:)}, and
{cmd:st_isstrfmt(}{it:s}{cmd:)}
abort with error if {it:s} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
