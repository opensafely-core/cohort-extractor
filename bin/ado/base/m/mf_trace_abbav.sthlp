{smcl}
{* *! version 1.1.3  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] trace()" "help mf_trace"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_trace_abbav##syntax"}{...}
{viewerjumpto "Description" "mf_trace_abbav##description"}{...}
{viewerjumpto "Remarks" "mf_trace_abbav##remarks"}{...}
{viewerjumpto "Conformability" "mf_trace_abbav##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_trace_abbav##diagnostics"}{...}
{viewerjumpto "Source code" "mf_trace_abbav##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] trace_ABBAV()} {hline 2} Obtain trace of a special-purpose matrix


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:trace_ABBAV(}{it:real matrix A}, {it:real matrix B}, 
{it:real colvector v}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:trace_ABBAV(}{it:A}{cmd:,} {it:B}{cmd:,} {it:v}{cmd:)} returns
{cmd:trace(}{it:A}{cmd:'*}{it:B}{cmd:'*}{it:B}{cmd:*}{it:A}{cmd:*diag(}{it:v}{cmd:))}

{p 4 4 2}
{cmd:trace_ABBAV()} is an {help undocumented} function.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
This calculation arises in certain spatial statistical calculations.


{marker conformability}{...}
{title:Conformability}

    {cmd:trace_ABBAV(}{it:A}, {it:B}, {it:v}{cmd:)}:
		{it:A}:  {it:n x n} 
		{it:B}:  {it:n x n} 
		{it:v}:  {it:n x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:trace_ABBAV(}{it:A}{cmd:,} {it:B}{cmd:,} {it:v}{cmd:)} 
aborts with error if {it:A}, {it:B}, or {it:v} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
