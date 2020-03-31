{smcl}
{* *! version 1.4.3  15may2018}{...}
{vieweralsosee "[M-5] stataversion()" "mansection M-5 stataversion()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] bufio()" "help mf_bufio"}{...}
{vieweralsosee "[M-5] byteorder()" "help mf_byteorder"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_stataversion##syntax"}{...}
{viewerjumpto "Description" "mf_stataversion##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_stataversion##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_stataversion##remarks"}{...}
{viewerjumpto "Conformability" "mf_stataversion##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_stataversion##diagnostics"}{...}
{viewerjumpto "Source code" "mf_stataversion##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] stataversion()} {hline 2}}Version of Stata being used
{p_end}
{p2col:}({mansection M-5 stataversion():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:stataversion()}


{p 8 12 2}
{it:real scalar}
{cmd:statasetversion()}

{p 8 12 2}
{it:void}{bind:       }
{cmd:statasetversion(}{it:real scalar version}{cmd:)}


{p 4 11 2}
Note: The version number is multiplied by 100:  Stata 2.0 is 200, Stata 5.1 is
510, and Stata 16.0 is 1600.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:stataversion()} returns the version 
of Stata/Mata that is running, multiplied by 100.
For instance, if you have Stata 16.0 installed on your computer, 
{cmd:stataversion()} returns 1600.

{p 4 4 2}
{cmd:statasetversion()} returns the version 
of Stata that has been set by the user -- the version of Stata that Stata 
is currently emulating -- multiplied by 100.  
Usually
{cmd:stataversion()} == 
{cmd:statasetversion()}.
If the user has set a previous version -- say, version 8 
by typing {cmd:version} {cmd:8} in Stata -- 
{cmd:statasetversion()} will return a number less than 
{cmd:stataversion()}.

{p 4 4 2}
{cmd:statasetversion(}{it:version}{cmd:)} allows you to reset the 
version being emulated.  Results are the same as using Stata's {helpb version} 
command.  {it:version}, however, is specified as an integer equal to 
100 times the version you want.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 stataversion()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
It is usually not necessary to reset {cmd:statasetversion()}.  If you 
do reset {cmd:statasetversion()}, good form is to set it back when 
you are finished:

	{cmd:current_version = statasetversion()}
	{cmd:statasetversion(}{it:desired_version}{cmd:)}
	...
	{cmd:statasetversion(current_version)}


{marker conformability}{...}
{title:Conformability}

    {cmd:stataversion()}:
          {it:result}:  1 {it:x} 1

    {cmd:statasetversion()}:
          {it:result}:  1 {it:x} 1

    {cmd:statasetversion(}{it:version}{cmd:)}
         {it:version}:  1 {it:x} 1
          {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:statasetversion(}{it:version}{cmd:)}
aborts with error if {it:version} is less than 100 or greater 
than {cmd:stataversion()}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
