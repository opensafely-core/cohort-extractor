{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-2] if" "mansection M-2 if"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_if##syntax"}{...}
{viewerjumpto "Description" "m2_if##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_if##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_if##remarks"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[M-2] if} {hline 2}}if (exp) ... else ...
{p_end}
{p2col:}({mansection M-2 if:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:if (}{it:exp}{cmd:)} {it:stmt1}


	{cmd:if (}{it:exp}{cmd:)} {it:stmt1}
	{cmd:else} {it:stmt2}


	{cmd:if (}{it:exp}{cmd:) {c -(}}
		{it:stmts1}
	{cmd:{c )-}}
	{cmd:else {c -(}}
		{it:stmts2}
	{cmd:{c )-}}


	{cmd:if (}{it:exp1}{cmd:)} ...
	{cmd:else if (}{it:exp2}{cmd:)} ...
	{cmd:else if (}{it:exp3}{cmd:)} ...
	...
	{cmd:else} ...


{p 4 4 2}
where {it:exp}, {it:exp1}, {it:exp2}, {it:exp3}, ... must evaluate to real
scalars.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:if} evaluates the expression, and if it is true (evaluates to a nonzero 
number), {cmd:if} executes the statement or statement block that immediately
follows it; otherwise, {cmd:if} skips the statement or block.

{p 4 4 2}
{cmd:if} ... {cmd:else} 
evaluates the expression, and if it is true (evaluates to a nonzero 
number), {cmd:if} executes the statement or statement block that immediately
follows it and skips the statement or statement block following the 
{cmd:else}; otherwise, it skips the statement or statement block immediately
following it and executes the statement or statement block following the 
{cmd:else}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 ifRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:if} followed by multiple {cmd:else}s is interpreted as being nested, 
that is, 

	{cmd:if (}{it:exp1}{cmd:)} ...
	{cmd:else if (}{it:exp2}{cmd:)} ...
	{cmd:else if (}{it:exp3}{cmd:)} ...
	...
	{cmd:else} ...

{p 4 4 2}
is equivalent to

	{cmd:if (}{it:exp1}{cmd:)} ...
	{cmd:else {c -(}}
		{cmd:if (}{it:exp2}{cmd:)} ...
		{cmd:else {c -(}}
			{cmd:if (}{it:exp3}{cmd:)} ...
			{cmd:else {c -(}}
				...
			{cmd:{c )-}}
		{cmd:{c )-}}
	{cmd:{c )-}}
