{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] sign()" "mansection M-5 sign()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] dsign()" "help mf_dsign"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_sign##syntax"}{...}
{viewerjumpto "Description" "mf_sign##description"}{...}
{viewerjumpto "Conformability" "mf_sign##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_sign##diagnostics"}{...}
{viewerjumpto "Source code" "mf_sign##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] sign()} {hline 2}}Sign and complex quadrant functions
{p_end}
{p2col:}({mansection M-5 sign():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind:     }{cmd:sign(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind: }{cmd:quadrant(}{it:complex matrix Z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:sign(}{it:R}{cmd:)} returns the elementwise sign of {it:R}.  
{cmd:sign()} is defined

	Argument range      {cmd:sign(}{it:arg}{cmd:)}
	{hline 31}
        {it:arg} >= .                .
        {it:arg} <  0               -1
        {it:arg} =  0                0
        {it:arg} >  0                1
	{hline 31}

{p 4 4 2}
{cmd:quadrant(}{it:Z}{cmd:)} returns a real matrix recording the 
quadrant of each complex entry in {it:Z}.  
{cmd:quadrant()} is defined

	  Argument range
        Re({it:arg})    Im({it:arg})      {cmd:quadrant(}{it:arg}{cmd:)}
	{hline 37}
	Re >= .                        .
        Re =  0    Im =  0             .
        Re >  0    Im >= 0             1
        Re <= 0    Im >  0             2
        Re <  0    Im <= 0             3
        Re >= 0    Im <  0             4
	{hline 37}
        {cmd:quadrant(}1+0i{cmd:)==1}, {cmd:quadrant(}-1+0i{cmd:)==3}
        {cmd:quadrant(}0+1i{cmd:)==2}, {cmd:quadrant(} 0-1i{cmd:)==4}


{marker conformability}{...}
{title:Conformability}

    {cmd:sign(}{it:R}{cmd:)}:
                {it:R}:  {it:r x c}
           {it:result}:  {it:r x c}

    {cmd:quadrant(}{it:Z}{cmd:)}:
                {it:Z}:  {it:r x c}
           {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:sign(}{it:R}{cmd:)} returns missing when {it:R} is missing.

{p 4 4 2}
{cmd:quadrant(}{it:Z}{cmd:)} returns missing when {it:Z} is missing.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view quadrant.mata, adopath asis:quadrant.mata};
{cmd:sign()} is built in.
{p_end}
