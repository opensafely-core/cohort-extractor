{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] abs()" "mansection M-5 abs()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_abs##syntax"}{...}
{viewerjumpto "Description" "mf_abs##description"}{...}
{viewerjumpto "Conformability" "mf_abs##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_abs##diagnostics"}{...}
{viewerjumpto "Source code" "mf_abs##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] abs()} {hline 2}}Absolute value (length)
{p_end}
{p2col:}({mansection M-5 abs():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:abs(}{it:numeric matrix Z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
For {it:Z} real, {cmd:abs(}{it:Z}{cmd:)} returns the elementwise absolute
values of {it:Z}.

{p 4 4 2}
For {it:Z} complex, {cmd:abs(}{it:Z}{cmd:)} returns the elementwise length of
each element.  If {it:Z}={it:a}+{it:b}i, returned is 
{cmd:sqrt(}{it:a}^2+{it:b}^2{cmd:)}, although the 
calculation is not made in that way.  The method actually used prevents 
overflow.


{marker conformability}{...}
{title:Conformability}

    {cmd:abs(}{it:Z}{cmd:)}:
		{it:Z}:  {it:r x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:abs(.)} returns {cmd:.} (missing).


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
