{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] setbreakintr()" "mansection M-5 setbreakintr()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] error()" "help mf_error"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_setbreakintr##syntax"}{...}
{viewerjumpto "Description" "mf_setbreakintr##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_setbreakintr##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_setbreakintr##remarks"}{...}
{viewerjumpto "Conformability" "mf_setbreakintr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_setbreakintr##diagnostics"}{...}
{viewerjumpto "Source code" "mf_setbreakintr##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] setbreakintr()} {hline 2}}Break-key processing
{p_end}
{p2col:}({mansection M-5 setbreakintr():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:setbreakintr(}{it:real scalar val}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:querybreakintr()}

{p 8 12 2}
{it:real scalar}
{cmd:breakkey()}

{p 8 12 2}
{it:void}{bind:       }
{cmd:breakkeyreset()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:setbreakintr(}{it:val}{cmd:)} turns the break-key interrupt off ({it:val}==0)
or on ({it:val}!=0) and returns the value of the previous break-key mode, 
1, it was on, or 0, it was off.

{p 4 4 2}
{cmd:querybreakintr()} returns 1 if the break-key interrupt is on and 0 otherwise.

{p 4 4 2}
{cmd:breakkey()} (for use in {cmd:setbreakintr(0)} mode) 
returns 1 if the break key has been pressed since it was last reset.

{p 4 4 2}
{cmd:breakkeyreset()} (for use in {cmd:setbreakintr(0)} mode) 
resets the break key.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 setbreakintr()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_setbreakintr##remarks1:Default break-key processing}
	{help mf_setbreakintr##remarks2:Suspending the break-key interrupt}
	{help mf_setbreakintr##remarks3:Break-key polling}


{marker remarks1}{...}
{title:Default break-key processing}

{p 4 4 2}
By default, if the user presses {hi:Break}, Mata stops execution and returns 
control to the console, setting the return code to 1.

{p 4 4 2}
To obtain this behavior, there is nothing you need do.  You do not need to 
use these functions.


{marker remarks2}{...}
{title:Suspending the break-key interrupt}

{p 4 4 2}
The default behavior is known as interrupt-on-break and is also known as
{cmd:setbreakintr(1)} mode.

{p 4 4 2}
The alternative is break-key suspension, also known as {cmd:setbreakintr(0)} mode.

{p 4 4 2}
For instance, you have several steps that must be performed in their 
entirety or not at all.  The way to do this is

		{cmd:val = setbreakintr(0)}
		...
		...{it:(critical code)}...
		...
		{cmd:(void) setbreakintr(val)}

{p 4 4 2}
The first line stores in {it:val} the current break-key processing mode and
then sets the mode to break-key suspension.  The critical code then runs.  If
the user presses {hi:Break} during the execution of the critical code, that
will be ignored.  Finally, the code restores the previous break-key processing
mode.


{marker remarks3}{...}
{title:Break-key polling}

{p 4 4 2}
In coding large, interactive systems, you may wish to adopt the break-key 
polling style of coding rather than interrupt-on-break.  In this
alternative style of coding, you turn off interrupt-on-break:

		{cmd:val = setbreakintr(0)}

{p 4 4 2}
and, from then on in your code, wherever you are willing to interrupt your
code, you ask (poll whether) the break key has been pressed:

		...
		{cmd:if (breakkey()) {c -(}}
			...
		{cmd:{c )-}}
		...

{p 4 4 2}
In this style of coding, you must decide where and when you are going to 
reset the break key, because once the break key has been pressed, 
{cmd:breakkey()} will continue to return 1 every time it is called.
To reset the break key, code, 

		{cmd:breakkeyreset()}

{p 4 4 2}
You can also adopt a mixed style of coding, using interrupt-on-break in some
places and polling in others.  Function {cmd:querybreakintr()} can then
be used to determine the current mode.


{marker conformability}{...}
{title:Conformability}

    {cmd:setbreakintr(}{it:val}{cmd:)}:
	      {it:val}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:querybreakintr()}, {cmd:breakkey()}:
	   {it:result}:  1 {it:x} 1

    {cmd:breakkeyreset()}:
	   {it:result}:  {it:void}
	

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:setbreakintr(1)} aborts with break if the break key has been pressed 
since the last {cmd:setbreakintr(0)} or {cmd:breakkeyreset()}.  Code 
{cmd:breakkeyreset()} before {cmd:setbreakintr(1)} if you do not want this behavior.

{p 4 4 2}
After coding {cmd:setbreakintr(1)}, remember to restore {cmd:setbreakintr(0)} mode.
It is not, however, necessary, to restore the original mode if 
{cmd:exit()} or {cmd:_error()} is about to be executed.

{p 4 4 2}
{cmd:breakkey()}, once the break key has been pressed, continues to return 1 
until {cmd:breakkeyreset()} is executed.

{p 4 4 2}
There is absolutely no reason to use {cmd:breakkey()} in 
{cmd:setbreakintr(0)} mode, because the only value it could return is 0. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
