{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] quadcross()" "mansection M-5 quadcross()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cross()" "help mf_cross"}{...}
{vieweralsosee "[M-5] crossdev()" "help mf_crossdev"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_quadcross##syntax"}{...}
{viewerjumpto "Description" "mf_quadcross##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_quadcross##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_quadcross##remarks"}{...}
{viewerjumpto "Conformability" "mf_quadcross##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_quadcross##diagnostics"}{...}
{viewerjumpto "Source code" "mf_quadcross##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] quadcross()} {hline 2}}Quad-precision cross products
{p_end}
{p2col:}({mansection M-5 quadcross():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:quadcross(}{it:X}{cmd:,}
{it:Z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcross(}{it:X}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcross(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:)}


{p 8 12 2}
{it:real matrix}
{cmd:quadcrossdev(}{it:X}{cmd:,}
{it:x}{cmd:,}
{it:Z}{cmd:,}
{it:z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcrossdev(}{it:X}{cmd:,}
{it:x}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcrossdev(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:x}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:,}
{it:z}{cmd:)}

{p 8 12 2}
{it:real matrix}
{cmd:quadcrossdev(}{it:X}{cmd:,}
{it:xc}{cmd:,}
{it:x}{cmd:,}
{it:w}{cmd:,}
{it:Z}{cmd:,}
{it:zc}{cmd:,}
{it:z}{cmd:)}


{p 4 8 2}
where

	             {it:X}:  {it:real matrix X}
	            {it:xc}:  {it:real scalar xc}
	             {it:x}:  {it:real rowvector x}

	             {it:w}:  {it:real vector w}

	             {it:Z}:  {it:real matrix Z}
	            {it:zc}:  {it:real scalar zc}
	             {it:z}:  {it:real rowvector z}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:quadcross()} makes calculations of the form

		{it:X}'{it:X} 

		{it:X}'{it:Z} 

		{it:X}{cmd:'diag(}{it:w}{cmd:)}{it:X}

		{it:X}{cmd:'diag(}{it:w}{cmd:)}{it:Z}

{p 4 4 2}
This function mirrors {cmd:cross()} (see
{bf:{help mf_cross:[M-5] cross()}}), the difference 
being that sums are formed in quad precision rather than in double precision,
so 
{cmd:quadcross()} is more accurate.

{p 4 4 2}
{cmd:quadcrossdev()} makes calculations of the form 

		({it:X}:-{it:x})'({it:X}:-{it:x})
		({it:X}:-{it:x})'({it:Z}:-{it:z})
		({it:X}:-{it:x})'{cmd:diag(}{it:w})({it:X}:-{it:x})
		({it:X}:-{it:x})'{cmd:diag(}{it:w})({it:Z}:-{it:z})

{p 4 4 2}
This function mirrors {cmd:crossdev()} (see
{bf:{help mf_crossdev:[M-5] crossdev()}}), the difference 
being that sums are formed in quad precision rather than in double precision, 
so 
{cmd:quadcrossdev()} is more accurate.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 quadcross()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The returned result is double precision, but the sum calculations made in 
creating that double-precision result were made in quad precision.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:quadcross()} has the same conformability requirements
as {cmd:cross()}; see 
{bf:{help mf_cross:[M-5] cross()}}. 

{p 4 4 2}
{cmd:quadcrossdev()} has the same conformability requirements
as {cmd:crossdev()}; see 
{bf:{help mf_crossdev:[M-5] crossdev()}}.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
See
{it:{help mf_cross##diagnostics:Diagnostics}} in 
{bf:{help mf_cross:[M-5] cross()}} and 
{it:{help mf_crossdev##diagnostics:Diagnostics}} in 
{bf:{help mf_crossdev:[M-5] crossdev()}}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
