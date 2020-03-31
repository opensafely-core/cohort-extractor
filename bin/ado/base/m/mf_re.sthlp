{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] Re()" "mansection M-5 Re()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] C()" "help mf_c"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_re##syntax"}{...}
{viewerjumpto "Description" "mf_re##description"}{...}
{viewerjumpto "Conformability" "mf_re##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_re##diagnostics"}{...}
{viewerjumpto "Source code" "mf_re##source"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[M-5] Re()} {hline 2}}Extract real or imaginary part
{p_end}
{p2col:}({mansection M-5 Re():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:Re(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:Im(}{it:numeric matrix Z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Re(}{it:Z}{cmd:)}
returns a real matrix containing the real part of {it:Z}.  {it:Z} may be
real or complex.

{p 4 4 2}
{cmd:Im(}{it:Z}{cmd:)}
returns a real matrix containing the imaginary part of {it:Z}.  {it:Z} may be
a real or complex.  If {it:Z} is real, {cmd:Im(}{it:Z}{cmd:)} returns a 
matrix of zeros.


{marker conformability}{...}
{title:Conformability}

    {cmd:Re(}{it:Z}{cmd:)}, {cmd:Im(}{it:Z}{cmd:)}:
		{it:Z}:  {it:r x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:Re(}{it:Z}{cmd:)}, if {it:Z} is real, literally returns {it:Z} and 
not a copy of {it:Z}.  This makes execution of {cmd:Re()} applied to 
real arguments instant.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
