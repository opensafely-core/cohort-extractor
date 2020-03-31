{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] op_increment" "mansection M-2 op_increment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_increment##syntax"}{...}
{viewerjumpto "Description" "m2_op_increment##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_increment##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_increment##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_increment##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_increment##diagnostics"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-2] op_increment} {hline 2}}Increment and decrement operators
{p_end}
{p2col:}({mansection M-2 op_increment:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:++}{it:i}                        increment before

	{cmd:--}{it:i}                        decrement before

	{it:i}{cmd:++}                        increment after

	{it:i}{cmd:--}                        decrement after


{p 4 4 2}
where {it:i} must be a real scalar.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:++}{it:i} and {it:i}{cmd:++}
increment {it:i}; they perform the operation {it:i}={it:i}+1.  
{cmd:++}{it:i} performs the operation before the evaluation of the expression
in which it appears, whereas {it:i}{cmd:++} performs the operation afterward.

{p 4 4 2}
{cmd:--}{it:i} and {it:i}{cmd:--}
decrement {it:i}; they perform the operation {it:i}={it:i}-1.  
{cmd:--}{it:i} performs the operation before the evaluation of the expression
in which it appears, whereas {it:i}{cmd:--} performs the operation afterward.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_incrementRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These operators are used in code, such as 

	{cmd:x[i++] = 2}


	{cmd:x[--i] = 3}


	{cmd:for (i=0; i<100; i++) {c -(}}
		...
	{cmd:{c )-}}


	{cmd:if (++n > 10) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
Where these expressions appear, results are as if the current value of
{cmd:i} were substituted, and in addition, {cmd:i} is incremented, either
before or after the expression is evaluated.  For instance,

	{cmd:x[i++] = 2}

{p 4 4 2} is equivalent to

	{cmd:x[i] = 2} {cmd:;} {cmd:i = i + 1}

{p 4 4 2}
and 

	{cmd:x[++i] = 3}

{p 4 4 2} is equivalent to

	{cmd:i = i + 1} {cmd:;} {cmd:x[i] = 3}


{p 4 4 2}
Coding 

	{cmd:for (i=0; i<100; i++) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
or

	{cmd:for (i=0; i<100; ++i) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2} is equivalent to

	{cmd:for (i=0; i<100; i=i+1) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
because it does not matter whether the incrementation is performed 
before or after the otherwise null expression.

	{cmd:if (++n > 10) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2} is equivalent to

	{cmd:n = n + 1}
	{cmd:if (n > 10) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
whereas 

	{cmd:if (n++ > 10) {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
is equivalent to

	{cmd:if (n > 10) {c -(}}
		{cmd:n = n + 1}
		...
	{cmd:{c )-}}
	{cmd:else    n = n + 1}

{p 4 4 2}
The {cmd:++} and {cmd:--} operators may be used only with real scalars 
and are usually associated with indexing or counting.  They result in 
fast and readable code.


{marker conformability}{...}
{title:Conformability}

	{cmd:++}{it:i}, {cmd:--}{it:i}, {it:i}{cmd:++}, and {it:i}{cmd:--}:
		{it:i}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:++} and {cmd:--} are allowed with real scalars only.  That is, 
{cmd:++i} or {cmd:i++} is valid, assuming {cmd:i} is a real scalar, but
{cmd:x[i,j]++} is not valid.

{p 4 4 2}
{cmd:++} and {cmd:--} abort with error if applied to a variable that is not 
a real scalar.

{p 4 4 2}
{cmd:++i}, {cmd:i++}, {cmd:--i}, and {cmd:i--} should be the only reference 
to {cmd:i} in the expression.  Do not code, for instance,

	{cmd:x[i++] = y[i]}

	{cmd:x[++i] = y[i]}

	{cmd:x[i] = y[i++]}

	{cmd:x[i] = y[++i]}

{p 4 4 2}
The value of {cmd:i} in the above expressions is formally undefined;
whatever is its value, you cannot depend on that value 
being obtained by earlier or later versions of the compiler.
Instead code 

	{cmd:i++ ; x[i] = y[i]}

{p 4 4 2}
or code 

	{cmd:x[i] = y[i] ; i++}

{p 4 4 2}
according to the desired outcome.

{p 4 4 2}
It is, however, perfectly reasonable to code 

	{cmd:x[i++] = y[j++]}

{p 4 4 2}
That is, multiple {cmd:++} and {cmd:--} operators may occur in the same 
expression, it is multiple references to the target of the {cmd:++} and 
{cmd:--} that must be avoided.
{p_end}
