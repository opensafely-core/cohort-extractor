{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] ustrtoname()" "mansection M-5 ustrtoname()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strtoname()" "help mf_strtoname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrtoname##syntax"}{...}
{viewerjumpto "Description" "mf_ustrtoname##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrtoname##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrtoname##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrtoname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrtoname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrtoname##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] ustrtoname()} {hline 2}}Convert a Unicode string to a Stata name
{p_end}
{p2col:}({mansection M-5 ustrtoname():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:string matrix}
{cmd:ustrtoname(}{it:string matrix s} [{cmd:,} {it:real scalar p}]{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ustrtoname(}{it:s} [{cmd:,} {it:p}]{cmd:)} converts a Unicode string to a
Stata name.  Each character in {it:s} that is not allowed in a Stata
name is converted to an underscore character, {cmd:_}.  If the first
character in {it:s} is a numeric character and {it:p} is specified and not
zero, then the result is prefixed with an underscore.  The result is truncated
to {ccl namelenchar} Unicode characters. 

{pstd}
When arguments are not scalar, {cmd:ustrtoname()} returns element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrtoname()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
An invalid UTF-8 sequence is converted to an underscore character, {cmd:_}.

{p 4 4 2}
Use {helpb mf_strtoname:strtoname()} if you need to produce a Stata 13
compatible name. 


{marker conformability}{...}
{title:Conformability}

    {cmd:ustrtoname(}{it:s} [{cmd:,} {it:p}]{cmd:)}:
            {it:s}:  {it:r x c}
            {it:p}:  1 {it:x} 1
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:ustrtoname(}{it:s} [{cmd:,} {it:p}]{cmd:)}
returns an empty string if an error occurs.


{marker source}{...}
{title:Source code}

{pstd}
Function is built in.
{p_end}
