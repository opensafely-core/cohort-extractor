{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] strtoname()" "mansection M-5 strtoname()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrtoname()" "help mf_ustrtoname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strtoname##syntax"}{...}
{viewerjumpto "Description" "mf_strtoname##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_strtoname##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_strtoname##remarks"}{...}
{viewerjumpto "Conformability" "mf_strtoname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strtoname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strtoname##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] strtoname()} {hline 2}}Convert a string to a Stata 13 compatible name
{p_end}
{p2col:}({mansection M-5 strtoname():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:string matrix}
{cmd:strtoname(}{it:string matrix s}{cmd:,} {it:real scalar p}{cmd:)}

{phang2}
{it:string matrix}
{cmd:strtoname(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:strtoname(}{it:s}{cmd:,} {it:p}{cmd:)}
returns {it:s} translated into a Stata name.  Each 
	character in {it:s} that is not allowed in a Stata name is converted
	to an underscore character, {cmd:_}.
	If the first character in {it:s} is a numeric character and {it:p} is
	not {cmd:0}, then the result is prefixed with an underscore.
	The result is truncated to {ccl namelenchar} bytes.

{pstd}
{cmd:strtoname(}{it:s}{cmd:)}
is equivalent to {cmd:strtoname(}{it:s}{cmd:,} {cmd:1)}.

{pstd}
When arguments are not scalar, {cmd:strtoname()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 strtoname()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:strtoname()} handles strings with only ASCII characters.  Use
{helpb mf_ustrtoname:ustrtoname()} to produce Stata names with Unicode
characters.

{pstd}
{cmd:strtoname("StataName")} returns "StataName".

{pstd}
{cmd:strtoname("not a Stata name")} returns "not_a_Stata_name".

{pstd}
{cmd:strtoname("0 is off")} returns "_0_is_off".

{pstd}
{cmd:strtoname("0 is off", 0)} returns "0_is_off".


{marker conformability}{...}
{title:Conformability}

    {cmd:strtoname(}{it:s}{cmd:,} {it:p}{cmd:)}:
            {it:s}:  {it:r x c}
            {it:p}:  1 {it:x} 1
       {it:result}:  {it:r x c}

    {cmd:strtoname(}{it:s}{cmd:)}:
            {it:s}:  {it:r x c}
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
None.


{marker source}{...}
{title:Source code}

{pstd}
Function is built in.
{p_end}
