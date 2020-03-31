{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] indexnot()" "mansection M-5 indexnot()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_indexnot##syntax"}{...}
{viewerjumpto "Description" "mf_indexnot##description"}{...}
{viewerjumpto "Conformability" "mf_indexnot##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_indexnot##diagnostics"}{...}
{viewerjumpto "Source code" "mf_indexnot##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] indexnot()} {hline 2}}Find byte not in list
{p_end}
{p2col:}({mansection M-5 indexnot():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:indexnot(}{it:string matrix s1}{cmd:,}
{it:string matrix s2}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:indexnot(}{it:s1}{cmd:,} {it:s2}{cmd:)} returns the position of the first
byte of {it:s1} not found in {it:s2}, or it returns 0 if all bytes of
{it:s1} are found in {it:s2}.  Note that a Unicode character may contain multiple
bytes.  Use {helpb mf_strlen:strlen()} or {helpb mf_ustrlen:ustrlen()} to check
if {it:s1} or {it:s2} has more bytes than its number of Unicode characters.


{marker conformability}{...}
{title:Conformability}

    {cmd:indexnot(}{it:s1}{cmd:,} {it:s2}{cmd:)}:
	       {it:s1}:  {it:r1 x c1}
	       {it:s2}:  {it:r2 x c2}, {it:s1} and {it:s2} r-conformable
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:indexnot(}{it:s1}{cmd:,} {it:s2}{cmd:)}
returns 0 if all bytes of {it:s1} are found in {it:s2}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
