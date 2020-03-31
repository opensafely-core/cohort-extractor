{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_nvar()" "mansection M-5 st_nvar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_nvar##syntax"}{...}
{viewerjumpto "Description" "mf_st_nvar##description"}{...}
{viewerjumpto "Conformability" "mf_st_nvar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_nvar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_nvar##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] st_nvar()} {hline 2}}Numbers of variables and observations
{p_end}
{p2col:}({mansection M-5 st_nvar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar} {cmd:st_nvar()}

{p 8 12 2}
{it:real scalar} {cmd:st_nobs()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_nvar()} returns the number of variables defined in the dataset
currently loaded in Stata.

{p 4 4 2}
{cmd:st_nobs()} returns the number of observations defined in the dataset
currently loaded in Stata.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_nvar()}, {cmd:st_nobs()}:
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
