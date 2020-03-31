{smcl}
{* *! version 1.1.7  11may2018}{...}
{vieweralsosee "[M-3] Intro" "mansection M-3 Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-0] Intro" "help mata"}{...}
{viewerjumpto "Contents" "m3_intro##contents"}{...}
{viewerjumpto "Description" "m3_intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "m3_intro##linkspdf"}{...}
{viewerjumpto "Remarks" "m3_intro##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-3] Intro} {hline 2}}Commands for controlling Mata
{p_end}
{p2col:}({mansection M-3 Intro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{p 4 4 2}
Command for invoking Mata from Stata:

{col 5}   [M-3]
{col 5}Manual entry{col 20}Command{col 40}Description
{col 5}{hline}
{col 5}{helpb m3 mata}{...}
{col 20}{cmd:. mata}{...}
{col 40}invoke Mata
{col 5}{hline}

{p 4 4 2}
Once you are running Mata, you can use the following commands from the 
colon prompt:

{col 5}   [M-3]
{col 5}Manual entry{col 20}Command{col 40}Description
{col 5}{hline}
{col 5}{helpb mata help}{...}
{col 20}{cmd:: mata help}{...}
{col 40}execute {cmd:help} command

{col 5}{helpb mata clear}{...}
{col 20}{cmd:: mata clear}{...}
{col 40}clear Mata
{col 5}{helpb mata describe}{...}
{col 20}{cmd:: mata describe}{...}
{col 40}describe contents of Mata's memory
{col 5}{helpb mata memory}{...}
{col 20}{cmd:: mata memory}{...}
{col 40}display memory-usage report
{col 5}{helpb mata rename}{...}
{col 20}{cmd:: mata rename}{...}
{col 40}rename matrix or function
{col 5}{helpb mata drop}{...}
{col 20}{cmd:: mata drop}{...}
{col 40}remove from memory matrix or function

{col 5}{helpb mata mosave}{...}
{col 20}{cmd:: mata mosave}{...}
{col 40}create object file
{col 5}{helpb mata mlib}{...}
{col 20}{cmd:: mata mlib}{...}
{col 40}create function library
{col 5}{helpb lmbuild}{...}
{col 20}{cmd:. lmbuild}{...}
{col 40}easily create function library

{col 5}{helpb mata matsave}{...}
{col 20}{cmd:: mata matsave}{...}
{col 40}save matrices
{col 5}{helpb mata matsave}{...}
{col 20}{cmd:: mata matuse}{...}
{col 40}restore matrices
{col 5}{helpb mata matsave}{...}
{col 20}{cmd:: mata matdescribe}{...}
{col 40}describe contents of matrix file

{col 5}{helpb mata which}{...}
{col 20}{cmd:: mata which}{...}
{col 40}identify function

{col 5}{helpb mata set}{...}
{col 20}{cmd:: mata query}{...}
{col 40}display values of settable parameters
{col 5}{helpb mata set}{...}
{col 20}{cmd:: mata set}{...}
{col 40}set parameters

{col 5}{helpb mata stata}{...}
{col 20}{cmd:: mata stata}{...}
{col 40}execute Stata command

{col 5}{helpb m3_end:end}{...}
{col 20}{cmd:: end}{...}
{col 40}exit Mata and return to Stata
{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
When you type something at the Mata prompt, it is assumed to be a Mata 
statement -- something that can be compiled and executed -- such as

	: {cmd:2+3}
	  5

{p 4 4 2}
The {cmd:mata} command, however, is different.  When what you type is prefixed
by the word {cmd:mata}, think of yourself as standing outside of Mata and
giving an instruction that affects the Mata environment and the way Mata
works.  For instance, typing

	: {cmd:mata clear}

{p 4 4 2}
says that Mata is to be cleared.  Typing 

	: {cmd:mata set matastrict on}

{p 4 4 2}
says that Mata is to require that programs explicitly declare their
arguments and their working variables; see 
{bf:{help m2_declarations:[M-2] Declarations}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 IntroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The {cmd:mata} command cannot be used inside functions.  It would make 
no sense to code

	{cmd:function foo(}...{cmd:)}
	{cmd:{c -(}}
		...
		{cmd:mata query}
		...
	{cmd:{c )-}}

{p 4 4 2}
because {cmd:mata query} is something that can be typed only at the Mata colon
prompt:

	: {cmd:mata query}
	{it:(output omitted)}

{p 4 4 2}
See {bf:{help m1_how:[M-1] How}}.
{p_end}
