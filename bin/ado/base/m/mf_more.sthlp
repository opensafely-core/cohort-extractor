{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] more()" "mansection M-5 more()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] more" "help more"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_more##syntax"}{...}
{viewerjumpto "Description" "mf_more##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_more##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_more##remarks"}{...}
{viewerjumpto "Conformability" "mf_more##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_more##diagnostics"}{...}
{viewerjumpto "Source code" "mf_more##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] more()} {hline 2}}Create --more-- condition
{p_end}
{p2col:}({mansection M-5 more():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:       }
{cmd:more()}


{p 8 12 2}
{it:real scalar}
{cmd:setmore()}

{p 8 12 2}
{it:void}{bind:       }
{cmd:setmore(}{it:real scalar onoff}{cmd:)}


{p 8 12 2}
{it:void}{bind:       }
{cmd:setmoreonexit(}{it:real scalar onoff}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:more()} displays {cmd:--more--} and waits for a key to be pressed.  That
is, {cmd:more()} does that if {cmd:more} is on, and it
does nothing otherwise.  {cmd:more} can be turned on and off by Stata's
{helpb set more} command or by the functions below.

{p 4 4 2}
{cmd:setmore()} returns whether {cmd:more} is on or off, encoded as 1 and 0.

{p 4 4 2}
{cmd:setmore(}{it:onoff}{cmd:)} sets {cmd:more} on if {it:onoff}!=0 and 
sets {cmd:more} off otherwise.

{p 4 4 2}
{cmd:setmoreonexit(}{it:onoff}{cmd:)} sets {cmd:more} on or off when the
current execution ends.  It has no effect on the current setting.  The
specified setting will take effect when control is passed back to the Mata
prompt or to the calling ado-file or to Stata itself, and it will take effect
regardless of whether execution ended because of a {cmd:return}, {cmd:exit()},
error, or abort.  Only the first call to {cmd:setmoreonexit()} has that
effect.  Later calls have no effect whatsoever.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 more()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:setmoreonexit()} is used to ensure that the {cmd:more} setting is restored 
if a program wants to temporarily reset it:

		{cmd:setmoreonexit(setmore())}
		{cmd:setmore(0)}

{p 4 4 2}
Only the first invocation of {cmd:setmoreonexit()} has any effect.  This 
way, a subroutine that is used in various contexts might 
also contain 

		{cmd:setmoreonexit(setmore())}
		{cmd:setmore(0)}

{p 4 4 2}
and that will not cause the wrong {cmd:more} setting to be restored if an 
earlier routine had already done that and yet still cause the right 
setting to be restored if the subroutine is the first to issue 
{cmd:setmoreonexit()}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:more()} takes no arguments and returns {it:void}.

    {cmd:setmore()}:
	   {it:result}:  1 {it:x} 1

    {cmd:setmore(}{it:onoff}{cmd:)}, {cmd:setmoreonexit(}{it:onoff}{cmd:)}:
	    {it:onoff}:  1 {it:x} 1
	   {it:result}:  {it:void}
		

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
