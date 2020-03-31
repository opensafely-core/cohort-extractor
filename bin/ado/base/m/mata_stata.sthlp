{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-3] mata stata" "mansection M-3 matastata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] stata()" "help mf_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_stata##syntax"}{...}
{viewerjumpto "Description" "mata_stata##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_stata##linkspdf"}{...}
{viewerjumpto "Remarks" "mata_stata##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-3] mata stata} {hline 2}}Execute Stata command
{p_end}
{p2col:}({mansection M-3 matastata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata} {cmd:stata} {it:stata_command}


{p 4 4 2}
This command is for use in Mata mode following Mata's colon prompt.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata stata} {it:stata_command}
passes {it:stata_command} to Stata for execution.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matastataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:mata} {cmd:stata} is a convenience tool to keep you from having to 
exit Mata:

	: {cmd:st_view(V=., 1\5, ("mpg", "weight"))}
		{error:st_view():  3598  Stata returned error}
		{error:  <istmt>:     -  function returned error}
	r(3598);

	: {cmd:mata stata sysuse auto}
	(1978 Automobile Data)

	: {cmd:st_view(V=., 1\5, ("mpg", "weight"))}

{p 4 4 2}
{cmd:mata stata} is for interactive use.  If you wish to execute a Stata 
command from a function, see 
{bf:{help mf_stata:[M-5] stata()}}.
{p_end}
