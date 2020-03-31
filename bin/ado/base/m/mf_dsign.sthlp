{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] dsign()" "mansection M-5 dsign()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] sign()" "help mf_sign"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_dsign##syntax"}{...}
{viewerjumpto "Description" "mf_dsign##description"}{...}
{viewerjumpto "Conformability" "mf_dsign##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_dsign##diagnostics"}{...}
{viewerjumpto "Source code" "mf_dsign##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] dsign()} {hline 2}}FORTRAN-like DSIGN() function
{p_end}
{p2col:}({mansection M-5 dsign():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:dsign(}{it:real scalar a}{cmd:,}
{it:real scalar b}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:dsign(}{it:a}{cmd:,} {it:b}{cmd:)} returns {it:a} with the sign of
{it:b}, defined as |{it:a}| if {it:b}>=0 and -|{it:a}| otherwise.

{p 4 4 2}
This function is useful when translating FORTRAN programs.

{p 4 4 2}
The in-line construction

	{cmd:(}{it:b}{cmd:>=0 ? abs(}{it:a}{cmd:) : -abs(}{it:a}{cmd:))}

{p 4 4 2}
is clearer.  Also, differentiate carefully between what {cmd:dsign()} 
returns (equivalent to the above construction) and 
{cmd:signum(}{it:b}{cmd:)}*{cmd:abs(}{it:a}{cmd:)}, which is almost 
equivalent but returns 0 when {it:b} is 0 rather than 
{cmd:abs(}{it:a}{cmd:)}.  (Message:  {cmd:dsign()} is not one of our 
favorite functions.)


{marker conformability}{...}
{title:Conformability}

    {cmd:dsign(}{it:a}{cmd:,} {it:b}{cmd:)}:
		{it:a}:  1 {it:x} 1
		{it:b}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:dsign(.,} {it:b}{cmd:)} returns {cmd:.} for all {it:b}.

{p 4 4 2}
{cmd:dsign(}{it:a}{cmd:, .)} returns abs({it:a}) for all {it:a}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view dsign.mata, adopath asis:dsign.mata}
{p_end}
