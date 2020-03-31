{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] comb()" "mansection M-5 comb()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_comb##syntax"}{...}
{viewerjumpto "Description" "mf_comb##description"}{...}
{viewerjumpto "Conformability" "mf_comb##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_comb##diagnostics"}{...}
{viewerjumpto "Source code" "mf_comb##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] comb()} {hline 2}}Combinatorial function
{p_end}
{p2col:}({mansection M-5 comb():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:comb(}{it:real matrix n}{cmd:,} {it:real matrix k}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:comb(}{it:n}{cmd:,} {it:k}{cmd:)}
returns the elementwise combinatorial function {it:n}-choose-{it:k}, the
number of ways to choose {it:k} items from {it:n} items, regardless of order.


{marker conformability}{...}
{title:Conformability}

    {cmd:comb(}{it:n}{cmd:,} {it:k}{cmd:)}:
		{it:n}:  {it:r1 x c1}
		{it:k}:  {it:r2 x c2}, {it:n} and {it:k} r-conformable
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:comb(}{it:n}{cmd:,} {it:k}{cmd:)} returns missing when either argument is
missing or when the result would be larger than 10^300.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
