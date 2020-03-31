{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] errprintf()" "mansection M-5 errprintf()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] displayas()" "help mf_displayas"}{...}
{vieweralsosee "[M-5] printf()" "help mf_printf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_errprintf##syntax"}{...}
{viewerjumpto "Description" "mf_errprintf##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_errprintf##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_errprintf##remarks"}{...}
{viewerjumpto "Conformability" "mf_errprintf##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_errprintf##diagnostics"}{...}
{viewerjumpto "Source code" "mf_errprintf##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] errprintf()} {hline 2}}Format output and display as error message
{p_end}
{p2col:}({mansection M-5 errprintf():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:errprintf(}{it:string scalar fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:errprintf()} is a convenience tool for displaying an error message.

{p 4 4 2}
{cmd:errprintf(}...{cmd:)} is equivalent to
{cmd:printf(}{it:...}{cmd:)} 
except that it executes
{cmd:displayas("error")}
before the {cmd:printf()} is executed;
see
{bf:{help mf_printf:[M-5] printf()}}
and 
{bf:{help mf_displayas:[M-5] displayas()}}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 errprintf()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
You have written a program.  At one point in the code, you have variable 
{cmd:fn} that should contain the name of an existing file:  

		{cmd:if (!fileexists(fn)) {c -(}}
			// {it:you wish to display the error message}
			// {it:file ____ not found}
			{cmd:exit(601)}
		{cmd:{c )-}}

{p 4 4 2}
One solution is

		{cmd:if (!fileexists(fn)) {c -(}}
			{cmd:displayas("error")}
			{cmd:printf("file %s not found\n", fn)}
			{cmd:exit(601)}
		{cmd:{c )-}}

{p 4 4 2}
Equivalent is

		{cmd:if (!fileexists(fn)) {c -(}}
			{cmd:errprintf("file %s not found\n", fn)}
			{cmd:exit(601)}
		{cmd:{c )-}}

{p 4 4 2}
It is important that you either {cmd:displayas("error")} before using 
{cmd:printf()} or that you use {cmd:errprintf()}, to ensure 
that you error message is displayed (is not suppressed by a 
{helpb quietly}) and that it is displayed in red; see 
{bf:{help mf_displayas:[M-5] displayas()}}.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:errprintf(}{it:fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}
{p_end}
	      {it:fmt}:  1 {it:x} 1
	       {it:r1}:  1 {it:x} 1
	       {it:r2}:  1 {it:x} 1
	       ...
	       {it:rN}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:errprintf()} aborts with error if 
a {helpb format:%{it:fmt}} is misspecified, if a numeric {cmd:%}{it:fmt} 
corresponds to a string result or a string {cmd:%}{it:fmt} 
corresponds to a numeric result, or there are too few or too many 
{cmd:%}{it:fmts} in {it:fmt} relative 
to the number of {it:results} specified.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
