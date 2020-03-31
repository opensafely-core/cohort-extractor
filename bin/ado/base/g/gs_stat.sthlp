{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] gs_graphinfo" "help gs_graphinfo"}{...}
{viewerjumpto "Syntax" "gs_stat##syntax"}{...}
{viewerjumpto "Description" "gs_stat##description"}{...}
{viewerjumpto "Remarks" "gs_stat##remarks"}{...}
{title:Title}

{p 4 21 2}
{hi:[G-2] gs_stat} {hline 2} Subroutine to verify (non)existence of graph


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:gs_stat}
{c -(} {cmd:exists} | {cmd:!exists} {c )-}
{it:name}

{p 8 16 2}
{cmd:gs_stat}
{it:lmac}
{cmd::}
{it:name}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gs_stat}'s first syntax verifies that graph {it:name} either exists or
does not exist.

{pstd}
{cmd:gs_stat}'s second syntax returns in local macro {it:lmac}
"{cmd:exists}" or "{cmd:!exists}".


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:gs_stat}'s first syntax returns nothing and is silent if {it:name} is as
asserted; otherwise, it issues the appropriate error message:

	{err:___ invalid name}
	r(198);

	{err:graph ___ already exists}
	r(110);

	{err:graph ___ not found}
	r(111);

	{err:class object ___ exists but is not a graph}
	r(110);

	{err:class object ___ (not a graph) already exists}
	r(110);

{pstd}
{cmd:gs_stat}'s second syntax returns in {it:lmac} whether the
file exists, but it still might issue the error messages

	{err:___ invalid name}
	r(198);

	{err:class object ___ (not a graph) exists:}
	      {err:___ cannot be used as a graph name}
	r(110);
