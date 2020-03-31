{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] recast" "help recast"}{...}
{viewerjumpto "Syntax" "_recast##syntax"}{...}
{viewerjumpto "Description" "_recast##description"}{...}
{viewerjumpto "Remarks" "_recast##remarks"}{...}
{title:Title}

{p 4 30 2}
{hi:[P] _recast} {hline 2} Change storage type of variable


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_recast}
{it:{help data types:type}}
{varname}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_recast} changes the storage type of the variable to the specified 
storage type.


{marker remarks}{...}
{title:Remarks}

{pstd}
Coding 
{p_end}
		{cmd:_recast} {it:type} {it:varname} 

{pstd}
does the same as 

		{cmd:recast} {it:type} {it:varname}{cmd:,} {cmd:force}

{pstd}
{cmd:_recast} is faster than {cmd:recast}.

{pstd}
{cmd:_recast} performs the requested change in storage type 
even if that results in rounding or truncation.

{pstd}
{cmd:_recast} produces no output.

{pstd}
With {cmd:_recast}, the only errors possible are that {it:varname} is not
found, that {it:type} is invalid, or that {it:type} and {it:varname} result in
a type mismatch.
{p_end}
