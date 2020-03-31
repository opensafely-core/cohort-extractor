{smcl}
{* *! version 1.0.1  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf__gauss_hermite_nodes##syntax"}{...}
{viewerjumpto "Description" "mf__gauss_hermite_nodes##description"}{...}
{viewerjumpto "Conformability" "mf__gauss_hermite_nodes##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__gauss_hermite_nodes##diagnostics"}{...}
{viewerjumpto "Source code" "mf__gauss_hermite_nodes##source"}{...}
{title:Title}

{phang}
{bf:[M-5] _gauss_hermite_nodes()} {hline 2} Gauss-Hermite quadrature


{marker syntax}{...}
{title:Syntax}

{pmore}
{it:real matrix} 
{cmd:_gauss_hermite_nodes(}{it:real} {it:scalar} {it:k}{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_gauss_hermite_nodes()} returns a 2 {it:x k} matrix.  The first row
contains the abscissa, and the second row contains the corresponding weights
for use in performing Gauss-Hermite quadrature.


{marker conformability}{...}
{title:Conformability}

    {cmd:_gauss_hermite_nodes(}{it:k}{cmd:)}:
		{it:k}:  1 {it:x} 1
	   {it:result}:  2 {it:x k}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:_gauss_hermite_nodes()} aborts with error if {it:k} is not an integer
in the range 1 to {ccl max_intpoints}.


{marker source}{...}
{title:Source code}

{pstd}
Function is built in.
{p_end}
