{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] op_conditional" "mansection M-2 op_conditional"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_conditional##syntax"}{...}
{viewerjumpto "Description" "m2_op_conditional##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_conditional##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_conditional##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_conditional##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_conditional##diagnostics"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-2] op_conditional} {hline 2}}Conditional operator
{p_end}
{p2col:}({mansection M-2 op_conditional:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:a} {cmd:?} {it:b} : {it:c}


{p 4 4 2}
where {it:a} must evaluate to a real scalar, and {it:b} and {it:c} may 
be of any type whatsoever.


{marker description}{...}
{title:Description}

{p 4 4 2}
The conditional operator returns {it:b} if {it:a} is true ({it:a} is 
not equal to 0) and {it:c} otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_conditionalRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Conditional operators

	{cmd:dof = (k==0 ? n-1 : n-k)}

{p 4 4 2}
are more compact than the {cmd:if}-{cmd:else} alternative

	{cmd:if (k==0) dof = n-1}
	{cmd:else      dof = n-k}

{p 4 4 2} and they can be used as parts of expressions:

	{cmd:mse = ess/(k==0 ? n-1 : n-k)}


{marker conformability}{...}
{title:Conformability}

    {it:a} {cmd:?} {it:b} : {it:c}:
		{it:a}:  1 {it:x} 1
		{it:b}:  {it:r1 x c1}
		{it:c}:  {it:r2 x c2}
	   {it:result}:  {it:r1 x c1}  or  {it:r2 x c2}
	

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
In {it:a} {cmd:?} {it:b} : {it:c}, only the necessary parts are evaluated:
{it:a} and {it:b} if {it:a} is true, or {it:a} and {it:c} if {it:a} is false.
However, the {cmd:++} and {cmd:--} operators are always evaluated:

	{cmd:(}{it:k}{cmd:==0 ?} {it:i}{cmd:++ :} {it:j}{cmd:++)}

{p 4 4 2}
increments both {it:i} and {it:j}, regardless of the value of {it:k}.
{p_end}
