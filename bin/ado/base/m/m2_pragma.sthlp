{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] pragma" "mansection M-2 pragma"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_pragma##syntax"}{...}
{viewerjumpto "Description" "m2_pragma##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_pragma##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_pragma##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-2] pragma} {hline 2}}Suppressing warning messages
{p_end}
{p2col:}({mansection M-2 pragma:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:pragma} 
{cmd:unset}
{it:varname}

{p 8 12 2}
{cmd:pragma} 
{cmd:unused}
{it:varname}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:pragma} informs the compiler of your intentions so that 
the compiler can avoid presenting misleading warning messages and 
so that the compiler can better optimize the code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 pragmaRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_pragma##remarks1:pragma unset}
	{help m2_pragma##remarks2:pragma unused}


{marker remarks1}{...}
{title:pragma unset}

{p 4 4 2}
The pragma

	{cmd:pragma unset} {it:X}

{p 4 4 2}
suppresses the warning message 

	{cmd:note: variable} {it:X} {cmd:may be used before set}

{p 4 4 2}
The pragma has no effect on the resulting compiled code.

{p 4 4 2}
In general, the warning message flags logical errors in your program, 
such as 

	: {cmd:function problem(real matrix a, real scalar j)}
	> {cmd:{c -(}}
	>       {cmd:real scalar i}
	>
	>       {cmd:j = i}
	>	...
	> {cmd:{c )-}}
	note: variable i may be used before set

{p 4 4 2}
Sometimes, however, the message is misleading:

	: {cmd:function notaproblem(real matrix a, real scalar j)}
	> {cmd:{c -(}}
	>       {cmd:real matrix V}
	>
	>       {cmd:st_view(V,} ...{cmd:)}
	>	...
	> {cmd:{c )-}}
	note: variable V may be used before set

{p 4 4 2}
In the above, function {cmd:st_view()} (see
{bf:{help mf_st_view:[M-5] st_view()}}) defines
{cmd:V}, but the compiler does not know that.

{p 4 4 2}
The warning message causes no problem but, if you wish to suppress it, change
the code to read

	: {cmd:function notaproblem(real matrix a, real scalar j)}
	> {cmd:{c -(}}
	>       {cmd:real matrix V}
	>
	>	{cmd:pragma unset V}
	>       {cmd:st_view(V,} ...{cmd:)}
	>	...
	> {cmd:{c )-}}

{p 4 4 2}
{cmd:pragma unset V} states that you know {cmd:V} is unset and that, 
for warning messages, the compiler should act as 
if {cmd:V} were set at this point in your code.


{marker remarks2}{...}
{title:pragma unused}

{p 4 4 2}
The pragma

	{cmd:pragma unused} {it:X}

{p 4 4 2}
suppresses the warning messages

	{cmd:note: argument} {it:X} {cmd:unused}
	{cmd:note: variable} {it:X} {cmd:unused}
	{cmd:note: variable} {it:X} {cmd:set but not used}

{p 4 4 2}
The pragma has no effect on the resulting compiled code.

{p 4 4 2}
Intentionally unused variables most often arise with respect to 
function arguments.  You code 

	: {cmd:function resolve(A, B, C)}
	> {cmd:{c -(}}
	>	...
	> {cmd:{c )-}}
	note: argument C unused

{p 4 4 2}
and you know well that you are not using {cmd:C}.  You include the 
unnecessary argument because you are attempting to fit into a standard or 
you know that, later, you may wish to change the function to include {cmd:C}.
To suppress the warning message, change the code to read

	: {cmd:function resolve(A, B, C)}
	> {cmd:{c -(}}
	>	...
	>       {cmd:pragma unused C}
	>	...
	> {cmd:{c )-}}

{p 4 4 2}
The pragma states that you know {cmd:C} is unused and, for the purposes of 
warning messages, the compiler should act as if {it:C} were used at this 
point in your code.

{p 4 4 2}
Unused variables can also arise, and in general, they should simply be 
removed, 

	: {cmd:function resin(X, Y)}
	> {cmd:{c -(}}
	>       {cmd:real scalar i}
	>	...
	>       ... {it:code in which} {cmd:i} {it:never appears}
	>	...
	> {cmd:{c )-}}
	note: variable i unused

{p 4 4 2}
Rather than using the pragma to suppress the message, you should remove 
the line {cmd:real scalar i}.

{p 4 4 2}
Warnings are also given for variables that are set and not used:

	: {cmd:function thwart(X, Y)}
	> {cmd:{c -(}}
	>       {cmd:real scalar i}
	>	...
	>	{cmd:i = 1}
	>	...
	>       ... {it:code in which} {cmd:i} {it:never appears}
	>	...
	> {cmd:{c )-}}
	note: variable i set but unused

{p 4 4 2}
Here you should remove both the {cmd:real scalar i} and {cmd:i}
{cmd:=} {cmd:1} lines.

{p 4 4 2}
It is possible, however, that the set-but-unused variable was intentional:

	: {cmd:function thwart(X, Y)}
	> {cmd:{c -(}}
	>       {cmd:real scalar i}
	>	...
	>	{cmd:i = somefunction(}...{cmd:)}
	>	...
	>       ... {it:code in which} {cmd:i} {it:never appears}
	>	...
	> {cmd:{c )-}}
	note: variable i set but not used

{p 4 4 2}
You assigned the value of {cmd:somefunction()} to {cmd:i} to prevent the
result from being displayed.  Here you could use {cmd:pragma}
{cmd:unused} {cmd:i} to suppress the warning message, but a better alternative
would be

	: {cmd:function thwart(X, Y)}
	> {cmd:{c -(}}
	>	...
	>	{cmd:(void) somefunction(}...{cmd:)}
	>	...
	> {cmd:{c )-}}

{p 4 4 2}
See
{it:{help m2_exp##remarks2:Assignment suppresses display, as does (void)}} in 
{bf:{help m2_exp:[M-2] exp}}.
{p_end}
