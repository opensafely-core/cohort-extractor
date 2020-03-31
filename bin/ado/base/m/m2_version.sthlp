{smcl}
{* *! version 1.3.3  10may2018}{...}
{vieweralsosee "[M-2] version" "mansection M-2 version"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] callersversion()" "help mf_callersversion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_version##syntax"}{...}
{viewerjumpto "Description" "m2_version##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_version##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_version##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-2] version} {hline 2}}Version control
{p_end}
{p2col:}({mansection M-2 version:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Syntax 1:

	. {cmd:version} {it:#}[{cmd:.}{it:#}]

	. {cmd:mata:}
	: ...
	: {cmd:function} {it:name}{cmd:(}...{cmd:)} 
	: {cmd:{c -(}}
	:         ...
	: {cmd:{c )-}}
	: ...
	: {cmd:end}


{p 4 4 2}
Syntax 2:

	: {cmd:function} {it:name}{cmd:(}...{cmd:)} 
	: {cmd:{c -(}}
	:         {cmd:version} {it:#}[{cmd:.}{it:#}]
	:         ...
	: {cmd:{c )-}}


{marker description}{...}
{title:Description}

{p 4 4 2}
In syntax 1, Stata's {cmd:version} command (see
{bf:{help version:[P] version}}) sets the version before entering Mata.  This
specifies both the compiler and library versions to be used.  Syntax 1 is
recommended.

{p 4 4 2}
In syntax 2, Mata's {cmd:version} command sets the version of the library
functions that are to be used.  Syntax 2 is rarely used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 versionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_version##remarks1:Purpose of version control}
	{help m2_version##remarks2:Recommendations for do-files}
	{help m2_version##remarks3:Recommendations for ado-files}
	{help m2_version##remarks4:Compile-time and run-time versioning}


{marker remarks1}{...}
{title:Purpose of version control}

{p 4 4 2}
Mata is under continual development, which means not only that new features 
are being added but also that old features sometimes change how they work.
Old features changing how they work is supposedly an improvement -- it
generally is -- but that also means old programs might
stop working or, worse, work differently.

{p 4 4 2}
{cmd:version} provides the solution.

{p 4 4 2}
If you are working interactively, nothing said here matters.

{p 4 4 2}
If you use Mata in do-files or ado-files, we recommend that you set
{cmd:version} before entering Mata.


{marker remarks2}{...}
{title:Recommendations for do-files}

{p 4 4 2}
The recommendation for do-files that use Mata is the same as for do-files that
do not use Mata:  specify the version number of the Stata you are using on the
top line:

	{hline 43} begin myfile.do {hline 4}
	{cmd:version {ccl stata_version}}
	...
	{hline 43} end myfile.do {hline 6}

{p 4 4 2}
To determine the number that should appear after {cmd:version}, type 
{cmd:about} at the Stata prompt:

	. {cmd:about}
	Stata/SE {ccl stata_version}
	[{it:remaining output omitted}]

{p 4 4 2}
We are using Stata {ccl stata_version}.

{p 4 4 2}
Coding {cmd:version} {cmd:{ccl stata_version}} will not benefit us today but, in the 
future, we will be able to rerun our do-file and obtain the same results.

{p 4 4 2}
By the way, a do-file is any file that you intend to execute using 
Stata's {cmd:do} or {cmd:run} commands (see {helpb do:[R] do}), regardless of
the file suffix.  Many users (us included) save Mata source code in {cmd:.mata}
files and then type {cmd:do} {it:myfile}{cmd:.mata} to compile.  {cmd:.mata}
files are do-files; we include the {cmd:version} line:

	{hline 41} begin myfile.mata {hline 4}
	{cmd:version {ccl stata_version}}
	{cmd:mata:}
	...
	{cmd:end}
	{hline 41} end myfile.mata {hline 6}


{marker remarks3}{...}
{title:Recommendations for ado-files}

{p 4 4 2}
Mata functions may be included in ado-files; see {bf:{help m1_ado:[M-1] Ado}}.
In such files, set {cmd:version} before entering Mata along with, as usual, 
setting the version at the top of your program:

	{hline 42} begin myfile.ado {hline 4}
	program myfile 
		{cmd:version {ccl stata_version}}      <- {it:as usual}
		...
	end

	{cmd:version {ccl stata_version}}              <- {it:new}
	{cmd:mata:}
	...
	{cmd:end}
	{hline 42} end myfile.ado {hline 6}


{marker remarks4}{...}
{title:Compile-time and run-time versioning}

{p 4 4 2}
What follows is detail.  We recommend always following the recommendations 
above.

{p 4 4 2}
There are actually two version numbers that matter -- the version number 
set at the time of compilation, which affects how the source code is 
interpreted, and the version of the libraries used to supply subroutines
at the time of execution.

{p 4 4 2}
The {cmd:version} command that we used in the previous sections is 
in fact Stata's {cmd:version} command (see
{bf:{help version:[P] version}}), and it sets both versions:

	. {cmd:version {ccl stata_version}}
	. {cmd:mata:}
	: {cmd:function example()}
	: {cmd:{c -(}}
	:         ...
	: {cmd:{c )-}}
	: {cmd:end}

{p 4 4 2}
In the above, we compile {cmd:example()} by using the version
{ccl stata_version} syntax of the Mata language,
and any functions {cmd:example()} calls will be the {ccl stata_version}
version of those functions.  Setting
{cmd:version} {cmd:{ccl stata_version}}
before entering Mata ensured all of that.

{p 4 4 2}
In the following example, we compile using version {ccl stata_version} syntax
and use version 16.2 functions:
{* hypothetical example; # above and below in #.2 should be current version}

	. {cmd:version {ccl stata_version}}
	. {cmd:mata:}
	: {cmd:function example()}
	: {cmd:{c -(}}
	:         {cmd:version 16.2}
	:         ...
	: {cmd:{c )-}}
	: {cmd:end}

{p 4 4 2}
In the following example, we compile using version 16.2 syntax 
and use version {ccl stata_version} functions:

	. {cmd:version 16.2}
	. {cmd:mata:}
	: {cmd:function example()}
	: {cmd:{c -(}}
	:         {cmd:version {ccl stata_version}}
	:         ...
	: {cmd:{c )-}}
	: {cmd:end}

{p 4 4 2}
It is, however, very rare that you will want to compile and execute at 
different version levels.
{p_end}
