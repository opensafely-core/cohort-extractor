{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] spline3()" "mansection M-5 spline3()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_spline3##syntax"}{...}
{viewerjumpto "Description" "mf_spline3##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_spline3##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_spline3##remarks"}{...}
{viewerjumpto "Conformability" "mf_spline3##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_spline3##diagnostics"}{...}
{viewerjumpto "Source code" "mf_spline3##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] spline3()} {hline 2}}Cubic spline interpolation
{p_end}
{p2col:}({mansection M-5 spline3():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind:    }
{cmd:spline3(}{it:real vector x}{cmd:,} 
{it:real vector y}{cmd:)}

{p 8 12 2}
{it:real vector}
{cmd:spline3eval(}{it:real matrix spline_info}{cmd:,}
{it:real vector x}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:spline3(}{it:x}{cmd:,} {it:y}{cmd:)}
returns the coefficients of a cubic natural spline S({it:x}).
The elements of {it:x} must be strictly monotone increasing.

{p 4 4 2}
{cmd:spline3eval(}{it:spline_info}{cmd:,} {it:x}{cmd:)} 
uses the information returned by {cmd:spline3()}
to evaluate and return the spline at the abscissas {it:x}.  
Elements of the returned result are set to missing if outside the range of the
spline.  {it:x} is assumed to be monotonically increasing.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 spline3()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:spline3()} and {cmd:spline3eval()}
is a translation into Mata of 

	Algorithm CUBNATSPLINE, 472-P 5-0
	Collected Algorithms from CACM
	Procedures for Natural Spline Interpolation [E1]
	John G. Herriot, Computer Science Department, Stanford Univ.
	Christian H. Reinsch, Mathematisches Institut der Technischen
	Universit{c a:}t, 8 M{c u:}nchen 2, Germany.

{p 4 4 2}
For {it:xx} in [{it:x}_{it:i}, {it:x}_[{it:i}+1]):

		S({it:xx}) = {c -(}({it:d}_{it:i}*{it:t} + {it:c}_{it:i})*{it:t} + {it:b}_{it:i}{c )-}*{it:t} + {it:y}_{it:i}

{p 4 4 2}
with {it:t} = {it:xx} - {it:x}_{it:i}.
{cmd:spline3()} returns 
({it:b}, {it:c}, {it:d}, {it:x}, {it:y})
or, if x and y are row vectors, 
({it:b}, {it:c}, {it:d}, {it:x}{bf:'}, {it:y}{bf:'}).


{marker conformability}{...}
{title:Conformability}

    {cmd:spline3(}{it:x}{cmd:,} {it:y}{cmd:)}:
		{it:x}:  {it:n x} 1  or  1 {it:x n}
		{it:y}:  {it:n x} 1  or  1 {it:x n}
	   {it:result}:  {it:n x} 5

    {cmd:spline3eval(}{it:spline_info}{cmd:,} {it:x}{cmd:)}:
      {it:spline_info}:  {it:n x} 5
		{it:x}:  {it:m x} 1  or  1 {it:x m}
	   {it:result}:  {it:m x} 1  or  1 {it:x m}
	

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:spline3(}{it:x}{cmd:,} {it:y}{cmd:)}
    requires that {it:x} be in ascending order.

{p 4 4 2}
    {cmd:spline3eval(}{it:spline_info}{cmd:,} {it:x}{cmd:)}
    requires that {it:x} be in ascending order.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view spline3.mata, adopath asis:spline3.mata},
{view spline3eval.mata, adopath asis:spline3eval.mata}
{p_end}
