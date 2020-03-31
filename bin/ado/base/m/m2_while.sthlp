{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] while" "mansection M-2 while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] break" "help m2_break"}{...}
{vieweralsosee "[M-2] continue" "help m2_continue"}{...}
{vieweralsosee "[M-2] do" "help m2_do"}{...}
{vieweralsosee "[M-2] for" "help m2_for"}{...}
{vieweralsosee "[M-2] Semicolons" "help m2_semicolons"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_while##syntax"}{...}
{viewerjumpto "Description" "m2_while##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_while##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_while##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-2] while} {hline 2}}while (exp) stmt
{p_end}
{p2col:}({mansection M-2 while:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:while (}{it:exp}{cmd:)} {it:stmt}


	{cmd:while (}{it:exp}{cmd:) {c -(}}
		{it:stmts}
	{cmd:{c )-}}


{p 4 4 2}
where {it:exp} must evaluate to a real scalar.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:while} executes {it:stmt} or {it:stmts} zero or more times.  The loop
continues as long as {it:exp} is not equal to zero.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 whileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To understand {cmd:while}, enter the following program

	{cmd}function example(n)
	{
		i = 1
		while (i<=n) {
			printf("i=%g\n", i)
			i++
		}
		printf("done\n")
	}{txt}

{p 4 4 2}
and run {cmd:example(3)}, {cmd:example(2)}, {cmd:example(1)}, 
{cmd:example(0)}, and {cmd:example(-1)}.

{p 4 4 2}
One common use of {cmd:while} is to loop until convergence:

	{cmd}while (mreldif(a, lasta)>1e-10) {
			lasta = a 
			a = {txt}...
	{cmd:{c )-}}
