{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] subinstr()" "mansection M-5 subinstr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] substr()" "help mf_substr"}{...}
{vieweralsosee "[M-5] _substr()" "help mf__substr"}{...}
{vieweralsosee "[M-5] usubinstr()" "help mf_usubinstr"}{...}
{vieweralsosee "[M-5] usubstr()" "help mf_usubstr"}{...}
{vieweralsosee "[M-5] _usubstr()" "help mf__usubstr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_subinstr##syntax"}{...}
{viewerjumpto "Description" "mf_subinstr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_subinstr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_subinstr##remarks"}{...}
{viewerjumpto "Conformability" "mf_subinstr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_subinstr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_subinstr##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] subinstr()} {hline 2}}Substitute text
{p_end}
{p2col:}({mansection M-5 subinstr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:string matrix}
{cmd:subinstr(}{it:string matrix s}{cmd:,}{break}
{it:string matrix old}{cmd:,}
{it:string matrix new}{cmd:)}

{p 8 31 2}
{it:string matrix}
{cmd:subinstr(}{it:string matrix s}{cmd:,}{break}
{it:string matrix old}{cmd:,}
{it:string matrix new}{cmd:,}{break}
{it:real matrix cnt}{cmd:)}


{p 8 32 2}
{it:string matrix}
{cmd:subinword(}{it:string matrix s}{cmd:,}{break}
{it:string matrix old}{cmd:,}
{it:string matrix new}{cmd:)}

{p 8 32 2}
{it:string matrix}
{cmd:subinword(}{it:string matrix s}{cmd:,}{break}
{it:string matrix old}{cmd:,}
{it:string matrix new}{cmd:,}{break}
{it:real matrix cnt}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:subinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:)} 
returns {it:s} with all occurrences of {it:old} changed to 
{it:new}.  

{p 4 4 2}
{cmd:subinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
returns {it:s} with the first {it:cnt} occurrences of {it:old} changed to 
{it:new}.  All occurrences are changed if {it:cnt} contains missing.

{p 4 4 2}
{cmd:subinword(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:)}
returns {it:s} with all occurrences of {it:old} on word boundaries
changed to {it:new}. 

{p 4 4 2}
{cmd:subinword(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
returns {it:s} with the first {it:cnt} occurrences of {it:old} on word
boundaries changed to {it:new}.  All occurrences are changed if {it:cnt}
contains missing.

{p 4 4 2}
When arguments are not scalar, these functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 subinstr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:subinstr("th thin man", "th", "the")} returns "the thein man".

{p 4 4 2}
{cmd:subinword("th thin man", "th", "the")} returns "the thin man".

{pstd}
See {helpb mf_usubinstr:[M-5] usubinstr()} if your string contains Unicode
characters.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:subinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)},
{cmd:subinword(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}:
{p_end}
		{it:s}:  {it:r1 x c1}
	      {it:old}:  {it:r2 x c2}
	      {it:new}:  {it:r3 x c3}
	      {it:cnt}:  {it:r4 x c4}  (optional); {it:s}, {it:old}, {it:new}, {it:cnt} r-conformable
	   {it:result}:  max({it:r1},{it:r2},{it:r3},{it:r4}) {it:x} max({it:c1},{it:c2},{it:c3},{it:c4})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:subinstr(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
and
{cmd:subinword(}{it:s}{cmd:,} {it:old}{cmd:,} {it:new}{cmd:,} {it:cnt}{cmd:)}
treat {it:cnt}<0 as if {it:cnt}=0 was specified; the original string {it:s}
is returned.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
