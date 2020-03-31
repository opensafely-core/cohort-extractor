{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-1] Source" "mansection M-1 Source"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] viewsource" "help viewsource"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Syntax" "m1_source##syntax"}{...}
{viewerjumpto "Description" "m1_source##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_source##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_source##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-1] Source} {hline 2}}Viewing the source code
{p_end}
{p2col:}({mansection M-1 Source:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 8 2}
{cmd:viewsource}
{it:functionname}{cmd:.mata}


{marker description}{...}
{title:Description}

{p 4 4 2}
Many Mata functions are written in Mata.  
{cmd:viewsource} will allow you to examine their source code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 SourceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Some Mata functions are implemented in C (they are part of Mata itself), and
others are written in Mata.

{p 4 4 2}
{cmd:viewsource} allows you to look at the official source code written in
Mata.  Reviewing this code is a great way to learn Mata.

{p 4 4 2}
The official source code is stored in {cmd:.mata} files.  To see the source
code for {cmd:diag()} (see {helpb mf_diag:[M-5] diag()}), for instance, type

	. {cmd:viewsource diag.mata}

{p 4 4 2}
You type this at Stata's dot prompt, not at Mata's colon prompt.

{p 4 4 2}
If a function is built in, such as 
{cmd:abs()} (see {helpb mf_abs:[M-5] abs()}), here is what will happen when you
attempt to view the source code:

	. {cmd:viewsource abs.mata}
	{err:file "abs.mata" not found}
	r(601);

{p 4 4 2}
You can verify that {cmd:abs()} is built in by using the 
{cmd:mata which} (see {bf:{help mata_which:[M-3] mata which}}) command:

	. {cmd:mata: mata which abs()}
	  abs():  built-in

{p 4 4 2}
{cmd:viewsource} can be also used to look at source code of
community-contributed functions if the distribution included the source code
(it might not).
{p_end}
