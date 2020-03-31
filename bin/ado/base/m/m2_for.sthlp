{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] for" "mansection M-2 for"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] break" "help m2_break"}{...}
{vieweralsosee "[M-2] continue" "help m2_continue"}{...}
{vieweralsosee "[M-2] do" "help m2_do"}{...}
{vieweralsosee "[M-2] Semicolons" "help m2_semicolons"}{...}
{vieweralsosee "[M-2] while" "help m2_while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_for##syntax"}{...}
{viewerjumpto "Description" "m2_for##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_for##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_for##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-2] for} {hline 2}}for (exp1; exp2; exp3) stmt
{p_end}
{p2col:}({mansection M-2 for:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:for (}{it:exp1}{cmd:;} {it:exp2}{cmd:;} {it:exp3}{cmd:)} {it:stmt}


	{cmd:for (}{it:exp1}{cmd:;} {it:exp2}{cmd:;} {it:exp3}{cmd:) {c -(}}
		{it:stmts}
	{cmd:{c )-}}


{p 4 4 2}
where {it:exp1} and {it:exp3} are optional, and 
{it:exp2} must evaluate to a real scalar.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:for} is equivalent to

	{it:exp1}
	{cmd:while (}{it:exp2}{cmd:)} {cmd:{c -(}}
		{it:stmt(s)}
		{it:exp3}
	{cmd:{c )-}}

{p 4 4 2}
{it:stmt(s)} is executed zero or more times.  The loop continues as long as
{it:exp2} is not equal to zero.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 forRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}


{p 4 4 2}
To understand {cmd:for}, enter the following program

	{cmd}function example(n)
	{
		for (i=1; i<=n; i++) {
			printf("i=%g\n", i)
		}
		printf("done\n")
	}{txt}

{p 4 4 2}
and run {cmd:example(3)}, {cmd:example(2)}, {cmd:example(1)}, 
{cmd:example(0)}, and {cmd:example(-1)}.

{p 4 4 2}
Common uses of {cmd:for} include

	{cmd:for (i=1; i<=rows(A); i++) {c -(}}
		{cmd:for (j=1; j<=cols(A); j++) {c -(}}
			...
		{cmd:{c )-}}
	{cmd:{c )-}}
