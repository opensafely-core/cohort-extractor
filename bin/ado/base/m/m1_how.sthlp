{smcl}
{* *! version 1.1.7  11may2018}{...}
{vieweralsosee "[M-1] How" "mansection M-1 How"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Description" "m1_how##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_how##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_how##remarks"}{...}
{viewerjumpto "Reference" "m1_how##reference"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-1] How} {hline 2}}How Mata works
{p_end}
{p2col:}({mansection M-1 How:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Below we take away some of the mystery and show you how Mata works.  Everyone,
we suspect, will find this entertaining, and advanced users will find the
description useful for predicting what Mata will do when faced 
with unusual situations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 HowRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m1_how##remarks1:What happens when you define a program}
	{help m1_how##remarks2:What happens when you work interactively}
	{help m1_how##remarks3:What happens when you type a mata environment command}
	{help m1_how##remarks4:Working with object code I:  .mo files}
	{help m1_how##remarks5:Working with object code II: .mlib libraries}
	{help m1_how##remarks6:The Mata environment}

{pstd}If you are reading the entries in the order suggested in
{bf:{help mata:[M-0] Intro}}, browse
{bf:{help m1_intro:[M-1] Intro}} next for sections that interest you, and then
see {bf:{help m2_syntax:[M-2] Syntax}}.


{marker remarks1}{...}
{title:What happens when you define a program}

{p 4 4 2}
Let's say you fire up Mata and type 

	: {cmd:function tryit()}
	> {cmd:{c -(}}
	>         {cmd:real scalar i}
	>
	>         {cmd:for (i=1; i<=10; i++) i}
	> {cmd:{c )-}}

{p 4 4 2}
Mata compiles the program:  it reads what you type and produces binary codes
that tell Mata exactly what it is to do when the time comes to execute the
program.  In fact, given the above program, Mata produces the binary code

	00b4 3608 4000 0000 0100 0000 2000 0000 
	0000 0000 ffff ffff 0300 0000 0000 0000 
	0100 7472 7969 7400 1700 0100 1f00 0700 
	0000 0800 0000 0200 0100 0800 2a00 0300 
	1e00 0300 

{p 4 4 2}
which looks meaningless to you and me, but Mata knows exactly what to make of
it.  The compiled version of the program is called object code, and it is the
object code, not the original source code, that Mata stores in memory.
In fact, the original source is discarded once the object code has been 
stored.

{p 4 4 2}
It is this compilation step -- the conversion of text into object code --
that makes Mata able to execute programs so quickly.

{p 4 4 2}
Later, when the time comes to execute the program, Stata follows the 
instructions it has previously recorded:

	: {cmd:tryit()}
	  1
	  2
	  3
	  4
	  5
	  6
	  7
	  8
	  9
	  10


{marker remarks2}{...}
{title:What happens when you work interactively}

{p 4 4 2}
Let's say you type 

	: {bf:x = 3}

{p 4 4 2}
In the jargon of Mata, that is called an {it:istmt} -- an interactive 
statement.  Obviously, Mata stores 3 in {cmd:x}, but how?

{p 4 4 2}
Mata first compiles the single statement and stores the 
resulting object code under the name {cmd:<istmt>}.  The result is 
much as if you had typed  

	: {cmd:function <istmt>()}
	> {cmd:{c -(}}
	>         {cmd:x = 3}
	> {cmd:{c )-}}

{p 4 4 2}
except, of course, you could not define a program named {cmd:<istmt>} 
because the name is invalid.  Mata has ways of getting around that.

{p 4 4 2} 
At this point, Mata has discarded the source code {cmd:x=3} and has 
stored the corresponding object code.  Next, Mata executes 
{cmd:<istmt>}.  The result is much as if you had typed 

	: {cmd:<istmt>()}

{p 4 4 2}
That done, there is only one thing left to do, which is to discard the 
object code.  The result is much as if you typed 

	: {cmd:mata drop <istmt>()}

{p 4 4 2}
So there you have it:  you type 

	: {cmd:x = 3}

{p 4 4 2} 
and Mata executes

	: {cmd:function <istmt>()}
	> {cmd:{c -(}}
	>         {cmd:x = 3}
	> {cmd:{c )-}}

	: {cmd:<istmt>()}

	: {cmd:mata drop <istmt>()}


    {hline}
    {it:Technical note:}

{p 8 8 2}
The above story is not exactly true because, as told, variable {cmd:x} 
would be local to function {cmd:<istmt>()} so, when {cmd:<istmt>()}
concluded execution, variable {cmd:x} would be discarded.  To prevent 
that from happening, Mata makes all variables defined by {cmd:<istmt>()} 
global.  Thus you can type 

		: {cmd:x = 3}

{p 8 8 2}
followed by 

		: {cmd:y = x + 2}

{p 8 8 2}
and all works out just as you expect:  {cmd:y} is set to 5.
{p_end}
    {hline}


{marker remarks3}{...}
{title:What happens when you type a mata environment command}

{p 4 4 2}
When you are at a colon prompt and type something that begins with 
the word {cmd:mata}, such as 

	: {cmd:mata describe}

{p 4 4 2}
or

	: {cmd:mata clear}


{p 4 4 2}
something completely different happens:  Mata 
freezes itself and 
temporarily transfers control to a command interpreter like 
Stata's.  The command interpreter accesses Mata's
environment and reports on it or changes it.  Once done, the interpreter
returns to Mata, which comes back to life, and issues a new colon 
prompt:

	: {cmd:_}

{p 4 4 2}
Once something is typed at the prompt, Mata will examine it to determine 
if it begins with the word {cmd:mata} (in which case the interpretive 
process repeats), or if it is the beginning of a function definition 
(in which case the program will be compiled but not executed), or 
anything else (in which case Mata will try to compile and execute it 
as an {cmd:<istmt>()}).


{marker remarks4}{...}
{title:Working with object code I:  .mo files}

{p 4 4 2}
Everything hinges on the object code that Mata produces, and, if you wish, you
can save the object code on disk.  The advantage of doing this is that, at
some future date, your program can be executed without compilation, which
saves time.  If you send the object code to others, they can use your program
without ever seeing the source code behind it.

{p 4 4 2}
After you type, say, 

	: {cmd:function tryit()}
	> {cmd:{c -(}}
	>         {cmd:real scalar i}
	>
	>         {cmd:for (i=1; i<=10; i++) i}
	> {cmd:{c )-}}

{p 4 4 2}
Mata has created the object code and discarded the source.  If you now type

	: {cmd:mata mosave tryit()}

{p 4 4 2}
the Mata interpreter will create file {cmd:tryit.mo} in the current directory;
see {bf:{help mata_mosave:[M-3] mata mosave}}.
The new file will contain the object code. 

{p 4 4 2}
At some future date, were you to type 

	: {cmd:tryit()}

{p 4 4 2}
without having first defined the program, Mata would look along the 
ado-path (see help {helpb adopath} and {findalias fradolook})
for a file named {cmd:tryit.mo}.  Finding the file, Mata loads
it (so Mata now has the object code and executes it in the usual way).


{* index .mlib library files}{...}
{* index libraries}{...}
{marker remarks5}{...}
{title:Working with object code II:  .mlib libraries}

{p 4 4 2}
Object code can be saved in {cmd:.mlib} libraries (files) instead of {cmd:.mo}
files.  {cmd:.mo} files contain the object code for one program.  {cmd:.mlib}
files contain the object code for a group of files.  

{p 4 4 2}
The first step is to choose a name (we will choose {cmd:lmylib} -- library names
are required to start with the lowercase letter {it:l}) and 
create an empty library of that name:

	: {cmd:mata mlib create lmylib}

{p 4 4 2}
Once created, new functions can be added to the library:

	: {cmd:mata mlib add lmylib tryit()}

{p 4 4 2}
New functions can be added at any time, either immediately after creation 
or later -- even much later; 
see {bf:{help mata_mlib:[M-3] mata mlib}}.

{p 4 4 2}
We mentioned that when Mata needs to execute a function that it does not find
in memory, Mata looks for a {cmd:.mo} file of the same name.  Before Mata does
that, however, Mata thumbs through its libraries to see if it can find the
function there.


{marker remarks6}{...}
{title:The Mata environment}

{p 4 4 2}
Certain settings of Mata affect how it behaves.  You can see those 
settings by typing {cmd:mata query} at the Mata prompt:

	: {cmd:mata query}
	{txt}{hline}
	    Mata settings
	{col 18}set matastrict{col 36}{res}off
	{txt}{col 18}set matalnum{col 36}{res}off
	{txt}{col 18}set mataoptimize{col 36}{res}on
	{txt}{col 18}set matafavor{col 36}{res}space{txt}{col 49}may be {res:space} or {res:speed}
	{col 18}set matacache{col 36}{res}2000{txt}{col 49}kilobytes
	{col 18}set matalibs{col 36}{res}lmatabase;lmatapss;lmatapostest;lmataerm;
	>lmatapath;lmatagsem;lmataopt;lmatasem;lmataado;lmatafc;lmatasp;
	>lmatamcmc;lmatamixlog{txt}
	{col 18}set matamofirst{col 36}{res}off{txt}

	: _

{p 4 4 2}
You can change these settings by using {cmd:mata set};
see {bf:{help mata_set:[M-3] mata set}}.
We recommend the default settings, except that we admit to being partial 
to {cmd:mata set matastrict on}.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2006.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0025":Mata Matters: Precision}.
{it:Stata Journal} 6: 550-560.
{p_end}
