{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] continue" "mansection M-2 continue"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] break" "help m2_break"}{...}
{vieweralsosee "[M-2] do" "help m2_do"}{...}
{vieweralsosee "[M-2] for" "help m2_for"}{...}
{vieweralsosee "[M-2] while" "help m2_while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_continue##syntax"}{...}
{viewerjumpto "Description" "m2_continue##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_continue##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_continue##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] continue} {hline 2}}Continue with next iteration of for, while, or do loop
{p_end}
{p2col:}({mansection M-2 continue:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:for}, {cmd:while}, {it:or} {cmd:do {c -(}}
		...
		{cmd:if (}...{cmd:) {c -(}}
			...
			{cmd:continue}
		{cmd:{c )-}}
		...
	{cmd:{c )-}}
	...


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:continue} restarts the innermost {cmd:for}, {cmd:while}, or {cmd:do}
loop.  Execution continues just as if the loop had reached its logical end.

{p 4 4 2}
{cmd:continue} nearly always occurs following an {cmd:if}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 continueRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The following two code fragments are equivalent:

	{cmd}for (i=1; i<=rows(A); i++) {
		for (j=1; j<=cols(A); j++) {
			if (i==j) continue
			{txt}... action to be performed on A[i,j] ...{cmd}
		}
	}{txt}

{p 4 4 2}
and

	{cmd}for (i=1; i<=rows(A); i++) {
		for (j=1; j<=cols(A); j++) {
			if (i!=j) {
				{txt}... action to be performed on A[i,j] ...{cmd}
			}
		}
	}{txt}

{p 4 4 2}
{cmd:continue} operates on the innermost {cmd:for} or {cmd:while} 
loop, and even when the {cmd:continue} action is taken, standard 
end-of-loop processing takes place (which is {cmd:j++} here).
{p_end}
