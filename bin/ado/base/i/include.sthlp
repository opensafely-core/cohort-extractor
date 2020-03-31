{smcl}
{* *! version 1.4.3  10may2018}{...}
{vieweralsosee "[P] include" "mansection P include"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] do" "help do"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{viewerjumpto "Syntax" "include##syntax"}{...}
{viewerjumpto "Description" "include##description"}{...}
{viewerjumpto "Links to PDF documentation" "include##linkspdf"}{...}
{viewerjumpto "Option" "include##option"}{...}
{viewerjumpto "Remarks" "include##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] include} {hline 2}}Include commands from file
{p_end}
{p2col:}({mansection P include:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:include}
{it:{help filename}} [{cmd:,} {opt ado:path}]

{pstd}
If {it:filename} is specified without an extension, {cmd:.do} is assumed.


{marker description}{...}
{title:Description}

{pstd}
{cmd:include} is a variation on {cmd:do} and {cmd:run} that causes Stata to
execute the commands stored in the specified file as if they were entered from
the keyboard.  {cmd:include} is for advanced programming to share common
definitions among several do-files.  {cmd:include} may also be used in Mata
to create a library of routines with shared concepts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P includeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt adopath} indicates to search {help adopath:Stata's system directories} for
{it:{help filename}} if it is not found in the default location.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help include##remarks1:Use with do-files}
	{help include##remarks2:Use with Mata}
	{help include##remarks3:Warning}


{marker remarks1}{...}
{title:Use with do-files}

{pstd}
{cmd:include} can be used in advanced programming situations where you have
several do-files among which you wish to share common definitions.  {cmd:include} differs from
{helpb do} and {cmd:run} in that any local macros (changed settings, etc.)
created by executing the file are not dropped or reset when execution of the
file concludes.  Rather, results are as if the commands in {it:filename}
appeared in the session or file that included {it:filename}.

{pstd}
Say that you have do-files {cmd:step1.do}, {cmd:step2.do}, and {cmd:step3.do}
that perform a data management task.  You want the do-files to include a
common definition of the local macros {cmd:`inname'} and {cmd:`outname'},
which are, respectively, the names of the files to be read and created.  One
way to do this is

	{hline 30} begin {cmd:step1.do} {hline 4}
	...
	{cmd:include common.doh}
	...
	{hline 30} end {cmd:step1.do} {hline 6}


	{hline 30} begin {cmd:step2.do} {hline 4}
	...
	{cmd:include common.doh}
	...
	{hline 30} end {cmd:step2.do} {hline 6}


	{hline 30} begin {cmd:step3.do} {hline 4}
	...
	{cmd:include common.doh}
	...
	{hline 30} end {cmd:step3.do} {hline 6}


	{hline 28} begin {cmd:common.doh} {hline 4}
	{cmd}local inname  "inputdata.dta"
	local outname "outputdata.dta"{txt}
	{hline 28} end {cmd:common.doh} {hline 6}


{pstd}
Presumably, files {cmd:step1.do}, {cmd:step2.do}, and {cmd:step3.do} include
lines such as

		{cmd:use `inname', clear}

{pstd}
and 

		{cmd:save `outname', replace}

{pstd}
Our use of the {cmd:.doh} suffix in naming file {cmd:common.doh} is not a
typo.  We called the file {cmd:.doh} to emphasize that it is a header for
do-files, but you can name the file as you wish, including {cmd:common.do}.

{pstd}
You could call the file {cmd:common.do}, but you could not use the {cmd:do}
command to run it because the local macros that the file defines would
automatically be dropped when the file finished executing; thus in
{cmd:step1.do}, {cmd:step2.do}, and {cmd:step3.do}, the macros would be
undefined.


{marker remarks2}{...}
{title:Use with Mata}

{pstd}
{cmd:include} is sometimes used in advanced Mata situations where you are 
creating a library of routines with shared concepts:

	{hline 40} begin {cmd:inpivot.mata} {hline 4}
	{cmd}version {ccl stata_version}
	include limits.matah

	mata:
	real matrix inpivot(real matrix X)
	{
		real matrix	y1, yz
		real scalar	n

		if (rows(X)>`MAXDIM' | cols(X)>`MAXDIM') {
			errprintf("inpivot:  matrix too large\n")
			exit(1000)
		}
		...
	}
	end{txt}
	{hline 40} end {cmd:inpivot.mata} {hline 6}


	{hline 40} begin {cmd:limits.matah} {hline 4}
	...
	{cmd:local MAXDIM   800}
	...
	{hline 40} end {cmd:limits.matah} {hline 6}


{pstd}
Presumably, many {cmd:.mata} files include {cmd:limits.matah}.


{marker remarks3}{...}
{title:Warning}

{pstd}
Do not use {cmd:include} in the body of a Stata program:

		{cmd:program} ...
			...
			{cmd:include} ...
			...
		{cmd:end}

{pstd}
{cmd:include} will not be executed, as you might have hoped, when the
program is compiled.  Instead, {cmd:include} will be stored in your
program and executed every time your program runs.  The result will be the
same as if the lines had been included at compile time, but the execution will
be slower.
{p_end}
