{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-3] end" "mansection M-3 end"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "m3_end##syntax"}{...}
{viewerjumpto "Description" "m3_end##description"}{...}
{viewerjumpto "Links to PDF documentation" "m3_end##linkspdf"}{...}
{viewerjumpto "Remarks" "m3_end##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-3] end} {hline 2}}Exit Mata and return to Stata
{p_end}
{p2col:}({mansection M-3 end:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
	: {cmd:end}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:end} exits Mata and returns to Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 endRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
When you exit from Mata back into Stata, Mata does not clear itself; so 
if you later return to Mata, you will be right back where you were.        
See {bf:{help m3_mata:[M-3] mata}}.
{p_end}
