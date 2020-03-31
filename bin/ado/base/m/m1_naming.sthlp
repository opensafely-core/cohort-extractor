{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-1] Naming" "mansection M-1 Naming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] reswords" "help m2_reswords"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Syntax" "m1_naming##syntax"}{...}
{viewerjumpto "Description" "m1_naming##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_naming##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_naming##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-1] Naming} {hline 2}}Advice on naming functions and variables
{p_end}
{p2col:}({mansection M-1 Naming:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
A {it:name} is 1-32 characters long, the first character of 
which must be

		{cmd:A} - {cmd:Z}     {cmd:a} - {cmd:z}     {cmd:_}

{p 4 4 2}
and the remaining characters of which may be 

		{cmd:A} - {cmd:Z}     {cmd:a} - {cmd:z}     {cmd:_}    {cmd:0} - {cmd:9}

{p 4 4 2}
except that names may not be a word reserved by Mata
(see {helpb m2_reswords:[M-2] reswords} for a list).

{p 4 4 2}
Examples of names include

		{cmd:x}
		{cmd:x2}
		{cmd:alpha}
		{cmd:logarithm_of_x}
		{cmd:LogOfX}

{p 4 4 2}
Case matters:  {cmd:alpha}, {cmd:Alpha}, and {cmd:ALPHA} are different names.

{p 4 4 2}
Variables and functions have separate name spaces, which means a variable and
a function can have the same name, such as {cmd:value} and {cmd:value()}, and
Mata will not confuse them.


{marker description}{...}
{title:Description}

{p 4 4 2}
Advice is offered on how to name variables and functions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 NamingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m1_naming##remarks1:Interactive use}
	{help m1_naming##remarks2:Naming variables}
	{help m1_naming##remarks3:Naming functions}
	{help m1_naming##remarks4:What happens when functions have the same names}
	{help m1_naming##remarks5:How to determine if a function name has been taken}


{marker remarks1}{...}
{title:Interactive use}

{p 4 4 2}
Use whatever names you find convenient:  Mata will tell you if there is 
a problem.

{p 4 4 2}
The following sections are for programmers who want to write code that 
will require the minimum amount of maintenance in the future.


{marker remarks2}{...}
{title:Naming variables}

{p 4 4 2}
Mostly, you can name variables however you please.  Variables are local 
to the program in which they appear, so one function can have a variable 
or argument named {cmd:x} and another function can have a variable or 
argument of the same name, and there is no confusion.

{p 4 4 2}
If you are writing a large system of programs that has global variables, on the 
other hand, we recommend that you give the global variables long names, 
preferably with a common prefix identifying your system.  For instance, 

		{cmd:multeq_no_of_equations}
		{cmd:multeq_eq}
		{cmd:multeq_inuse}

{p 4 4 2}
This way, you variables will not become confused with variables from other
systems.


{marker remarks3}{...}
{title:Naming functions}

{p 4 4 2}
Our first recommendation is that, for the most part, you give functions
all-lowercase names:  {cmd:foo()} rather than {cmd:Foo()} or {cmd:FOO()}.  If
you have a function with one or more capital letters in the name, and if you
want to save the function's object code, you must do so in
{helpb mata mlib:.mlib} libraries; {helpb mata mosave:.mo} files are not
sufficient.  {cmd:.mo} files require that filename be the same as the function
name, which means {cmd:Foo.mo} for {cmd:Foo()}.  Not all operating systems
respect case in filenames.  Even if your operating system does respect case,
you will not be able to share your {cmd:.mo} files with others whose operating
system do not.

{p 4 4 2}
We have no strong recommendation against mixed case; we merely remind you 
to use {cmd:.mlib} library files if you use it.

{p 4 4 2}
Of greater importance is the name you choose.  Mata provides many 
functions and more will be added over time.  You will find it more 
convenient if you choose names that StataCorp and other users do not choose.

{p 4 4 2}
That means to avoid words that appear in the English-language dictionary, and
to avoid short names, say, those four characters or fewer.  You might have
guessed that {cmd:svd()} would be taken, but who would have guessed
{cmd:lud()}?  Or {cmd:qrd()}?  Or {cmd:e()}?

{p 4 4 2}
Your best defense against new official functions, and other
community-contributed functions, is to choose long function names.


{marker remarks4}{...}
{title:What happens when functions have the same names}

{p 4 4 2}
There are two kinds of official functions: built-in functions and library 
functions.  Community-contributed functions are invariably library functions
(here we draw no distinction between functions supplied in {cmd:.mo} files and
those supplied in {cmd:.mlib} files).

{p 4 4 2}
Mata will issue an error message if you attempt to define a function with 
the same name as a built-in function.

{p 4 4 2}
Mata will let you define a new function with the same name as a library
function if the library function is not currently in memory.  If you store
your function in a {cmd:.mo} file or a {cmd:.mlib} library, however, in the
future the official Mata library function will take precedence over your
function:  your function will never be loaded.  This feature works nicely for
interactive users, but for long-term programming, you will want to avoid
naming your functions after Mata functions.

{p 4 4 2}
A similar result is obtained if you name your function after a
community-contributed function that is installed on your computer.  You can do
so if the community-contributed function is not currently in memory.  In the
future, however, one or the other function will take precedence and, no matter
which, something will break.


{marker remarks5}{...}
{title:How to determine if a function name has been taken}

{p 4 4 2}
Use {cmd:mata which} (see {bf:{help mata_which:[M-3] mata which}}):

	: {cmd:mata which det_of_triangular()}
	{err:function det_of_triangular() not found}
	r(111);

	: {cmd:mata which det()}
	  det():  lmatabase
