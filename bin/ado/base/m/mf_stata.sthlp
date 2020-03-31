{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] stata()" "mansection M-5 stata()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata stata" "help mata_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_stata##syntax"}{...}
{viewerjumpto "Description" "mf_stata##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_stata##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_stata##remarks"}{...}
{viewerjumpto "Conformability" "mf_stata##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_stata##diagnostics"}{...}
{viewerjumpto "Source code" "mf_stata##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] stata()} {hline 2}}Execute Stata command
{p_end}
{p2col:}({mansection M-5 stata():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:        }
{cmd:stata(}{it:cmd}{cmd:)}

{p 8 12 2}
{it:void}{bind:        }
{cmd:stata(}{it:cmd}{cmd:,}
{it:nooutput}{cmd:)}

{p 8 12 2}
{it:void}{bind:        }
{cmd:stata(}{it:cmd}{cmd:,}
{it:nooutput}{cmd:,}
{it:nomacroexpand}{cmd:)}


{p 8 12 2}
{it:real scalar}
{cmd:_stata(}{it:cmd}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:_stata(}{it:cmd}{cmd:,}
{it:nooutput}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:_stata(}{it:cmd}{cmd:,}
{it:nooutput}{cmd:,}
{it:nomacroexpand}{cmd:)}


{p 4 4 2}
where

		{it:cmd}:  {it:string scalar}

           {it:nooutput}:  {it:real scalar}

      {it:nomacroexpand}:  {it:real scalar}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:stata(}{it:cmd}{cmd:)}
executes the Stata command contained in the string scalar {it:cmd}.
Output from the command appears at the terminal, and any macros 
contained in {it:cmd} are expanded.

{p 4 4 2}
{cmd:stata(}{it:cmd}{cmd:,} {it:nooutput}{cmd:)}
does the same thing, but if {it:nooutput}!=0, 
output produced by the execution is not displayed.
{cmd:stata(}{it:cmd}{cmd:,} {cmd:0)} is equivalent to 
{cmd:stata(}{it:cmd}{cmd:)}.

{p 4 4 2}
{cmd:stata(}{it:cmd}{cmd:,} {it:nooutput}{cmd:,} 
{it:nomacroexpand}{cmd:)}
does the same thing but, before execution, suppresses expansion of any macros 
contained in {it:cmd} if 
{it:nomacroexpand}!=0.
{cmd:stata(}{it:cmd}{cmd:,} {cmd:0,} {cmd:0)} is equivalent to 
{cmd:stata(}{it:cmd}{cmd:)}.

{p 4 4 2}
{cmd:_stata()} repeats the syntaxes of {cmd:stata()}.  The difference 
is that, whereas {cmd:stata()} aborts with error if the execution results in a 
nonzero return code, {cmd:_stata()} returns the resulting return code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 stata()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The command you execute may invoke a process that causes another instance
of Mata to be invoked.  For instance, Stata program {it:A} calls Mata 
function {it:m1()}, which executes {cmd:stata()} to invoke Stata program 
{it:B}, which in turn calls Mata function {it:m2()}, which ...

{p 4 4 2}
{cmd:stata(}{it:cmd}{cmd:)} and {cmd:_stata(}{it:cmd}{cmd:)}
execute {it:cmd} at the current run level.  This means that any
local macros refer to local macros in the caller's space.  Consider the
following:

	{cmd:program example}
		...
		{cmd:local x = "value from A"}
		{cmd:mata: myfunc()}
		{cmd:display "`x'"}
		...
	{cmd:end}

	{cmd}mata void myfunc()
	{c -(}
		stata(`"local x = "new value""')
	{c )-}{txt}

{p 4 4 2}
After {cmd:example} executes {cmd:mata: myfunc()}, {cmd:`x'} will be
{cmd:"new value"}.

{p 4 4 2}
That {cmd:stata()} and {cmd:_stata()} work that way was intentional:  Mata
functions can modify the caller's environment so that they may
create temporary variables for the caller's use, etc., and you only have to
exercise a little caution.  Executing {cmd:stata()} functions to run other
ado-files and programs will cause no problems because other ado-files and
programs create their own new environment in which temporary variables, 
local macros, etc., are private.

{p 4 4 2}
Also, do not use {cmd:stata()} or {cmd:_stata()} to execute a
multiline command or to execute the first line of what could be 
considered a multiline command.  Once the first line is executed, 
Stata will fetch the remaining lines from the caller's environment.
For instance, consider 

	{hline 43} begin myfile.do {hline 4}
	{cmd}mata void myfunc()
	{c -(}
		stata("if (1==1) {")
	{c )-}

	mata: myfunc()
	display "hello"
	{c )-}{txt}
	{hline 43} end myfile.do {hline 6}

{p 4 4 2}
In the example above, {cmd:myfunc()} will consume the {cmd:display}
{cmd:"hello"} and {cmd:{c )-}} lines.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:stata(}{it:cmd}{cmd:,} {it:nooutput}{cmd:,} 
{it:nomacroexpand}{cmd:)}:
{p_end}
                        {it:cmd}:  1 {it:x} 1
                   {it:nooutput}:  1 {it:x} 1  (optional)
              {it:nomacroexpand}:  1 {it:x} 1  (optional)
                     {it:result}:  {it:void}

{p 4 8 2}
{cmd:_stata(}{it:cmd}{cmd:,} {it:nooutput}{cmd:,} 
{it:nomacroexpand}{cmd:)}:
{p_end}
                        {it:cmd}:  1 {it:x} 1
                   {it:nooutput}:  1 {it:x} 1  (optional)
              {it:nomacroexpand}:  1 {it:x} 1  (optional)
                     {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:stata()} aborts with error if {it:cmd} is too long (exceedingly 
unlikely), if macro expansion fails, or if execution results in a 
nonzero return code.

{p 4 4 2}
{cmd:_stata()} aborts with error if {it:cmd} is too long.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
