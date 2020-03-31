{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-3] mata which" "mansection M-3 matawhich"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_which##syntax"}{...}
{viewerjumpto "Description" "mata_which##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_which##linkspdf"}{...}
{viewerjumpto "Remarks" "mata_which##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-3] mata which} {hline 2}}Identify function
{p_end}
{p2col:}({mansection M-3 matawhich:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata} {cmd:which}
{it:fcnname}{cmd:()}


{p 4 4 2}
This command is for use in Mata mode following Mata's colon prompt.
To use this command from Stata's dot prompt, type

		. {cmd:mata: mata which} ...


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata which} {it:fcnname} looks for {it:fcnname}{cmd:()} and reports
whether it is built in, stored in a {helpb mata_mlib:.mlib} library, or stored
in a {helpb mata mosave:.mo} file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matawhichRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:mata} {cmd:which} {it:fcnname}{cmd:()} looks for 
{it:fcnname}{cmd:()} and reports where it is found:

	: {cmd:mata which I()}
	  I():  built-in

	: {cmd:mata which assert()}
	  assert():  lmatabase

	: {cmd:mata which myfcn()}
	  userfunction():  .\myfcn.mo

	: {cmd:mata which nosuchfunction()}
	{err:function nosuchfunction() not found}
	r(111);

{p 4 4 2}
Function {cmd:I()} is built in; it was written in C and is a part of Mata
itself.

{p 4 4 2}
Function {cmd:assert()} is a library function and, as a matter of fact, 
its executable object code is located in the official 
function library {cmd:lmatabase.mlib}.

{p 4 4 2}
Function {cmd:myfcn()} exists and has its executable object code stored 
in file {cmd:myfcn.mo}, located in the current directory.

{p 4 4 2}
Function {cmd:nosuchfunction()} does not exist.

{p 4 4 2}
Going back to {cmd:mata} {cmd:which} {cmd:assert()}, which was found in 
lmatabase.mlib, if you wanted to know where 
lmatabase.mlib was stored, you could 
type {cmd:findfile} {cmd:lmatabase.mlib}
at the Stata prompt; see 
{bf:{help findfile:[P] findfile}}.
{p_end}
