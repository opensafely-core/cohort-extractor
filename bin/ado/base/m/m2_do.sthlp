{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] do" "mansection M-2 do"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] break" "help m2_break"}{...}
{vieweralsosee "[M-2] continue" "help m2_continue"}{...}
{vieweralsosee "[M-2] for" "help m2_for"}{...}
{vieweralsosee "[M-2] while" "help m2_while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_do##syntax"}{...}
{viewerjumpto "Description" "m2_do##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_do##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_do##remarks"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[M-2] do} {hline 2}}do ... while (exp)
{p_end}
{p2col:}({mansection M-2 do:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:do} {it:stmt} {cmd:while (}{it:exp}{cmd:)}


	{cmd:do} {cmd:{c -(}}
		{it:stmts}
	{cmd:{c )-} while (}{it:exp}{cmd:)}


{p 4 4 2}
where {it:exp} must evaluate to a real scalar.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:do} executes {it:stmt} or {it:stmts} one or more times, until {it:exp} is
zero.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 doRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
One common use of {cmd:do} is to loop until convergence:


	{cmd}do {
		lasta = a
		a = get_new_a(lasta)
	} while (mreldif(a, lasta)>1e-10){txt}

{p 4 4 2}
The loop is executed at least once, and the conditioning 
expression is not executed until the loop's body has been executed.
{p_end}
