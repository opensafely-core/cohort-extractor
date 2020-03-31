{smcl}
{* *! version 1.1.0  02dec2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4 intro"}{...}
{vieweralsosee "[M-5] normal()" "help mf_normal"}{...}
{viewerjumpto "Syntax" "mf___lnmvnormalden##syntax"}{...}
{viewerjumpto "Description" "mf___lnmvnormalden##description"}{...}
{viewerjumpto "Conformability" "mf___lnmvnormalden##conformability"}{...}
{viewerjumpto "Source code" "mf___lnmvnormalden##source"}{...}
{title:Title}

{p2colset 4 31 33 2}{...}
{p2col:{bf:[M-5] __lnmvnormalden()} {hline 2}}Log-multivariate-normal
density for multivariate samples{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:real matrix}{bind:  }
{cmd:__lnmvnormalden(}{it:real matrix M}{cmd:,} {it:real matrix V}{cmd:,} {it:real matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{marker __lnmvnormalden}{...}
{p 4 4 2}
This function efficiently computes the natural logarithm of the
{it:p}-variate normal density for a sample of {it:n} {it:p}-variate
observations stored in the data matrix {it:X}.  Each row of {it:X} is a
{it:p}-variate random vector, each row of matrix {it:M} is the corresponding
{it:p}-variate mean vector, and matrix {it:V} is the {it:p} x {it:p}
covariance matrix.  If the same mean vector is to be used for every random
vector in {it:X}, then {it:M} can be a 1 x {it:p} row vector.

{p 4 4 2}
The {it:i}th row of the returned vector contains the natural logarithm of the
multivariate normal density for the mean vector in the {it:i}th row of {it:M}
and the random vector in the {it:i}th row of {it:X}.


{marker conformability}{...}
{title:Conformability}

    {cmd:__lnmvnormalden(}{it:M}{cmd:,} {it:V}{cmd:,} {it:X}{cmd:)}
                {it:M}:  {it:n x p} or {it:1 x p}
		{it:V}:  {it:p x p}
		{it:X}:  {it:n x p}
           {it:result}:  {it:n x} 1


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
