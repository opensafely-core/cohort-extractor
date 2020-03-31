{smcl}
{* *! version 1.3.3  15may2018}{...}
{vieweralsosee "[M-3] mata mosave" "mansection M-3 matamosave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata mlib" "help mata_mlib"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_mosave##syntax"}{...}
{viewerjumpto "Description" "mata_mosave##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_mosave##linkspdf"}{...}
{viewerjumpto "Options" "mata_mosave##options"}{...}
{viewerjumpto "Remarks" "mata_mosave##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-3] mata mosave} {hline 2}}Save function's compiled code in object file
{p_end}
{p2col:}({mansection M-3 matamosave:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata} {cmd:mosave}
{it:fcnname}{cmd:()}
[{cmd:,}
{cmd:dir(}{it:path}{cmd:)}
{cmd:complete}
{cmd:replace}]


{p 4 4 2}
This command is for use in Mata mode following Mata's colon prompt.
To use this command from Stata's dot prompt, type

		. {cmd:mata: mata mosave} ...


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata} {cmd:mosave} saves the object code for the specified 
function in the file {it:fcnname}{cmd:.mo}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matamosaveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:dir(}{it:path}{it:)} specifies the directory (folder) into which the file
    should be written.  {cmd:dir(.)} is the default, meaning that 
    if {cmd:dir()} is not specified, the file is written
    into the current (working) directory.  {it:path} may be a directory name
    or may be the sysdir shorthand {cmd:STATA}, {cmd:BASE},
    {cmd:SITE}, {cmd:PLUS}, {cmd:PERSONAL}, or {cmd:OLDPLACE}; see 
    {bf:{help sysdir:[P] sysdir}}.
    {cmd:dir(PERSONAL)} is recommended.

{p 4 8 2}
{cmd:complete} is for use when saving class definitions.  It specifies 
     that the definition be saved only if it is complete;
     otherwise, an error message is to be issued.
     See {bf:{help m2_class:[M-2] class}}.

{p 4 8 2}
{cmd:replace} specifies that the file may be replaced if it already exists.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help m1_how:[M-1] How}} for an explanation of 
object code.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mata_mosave##remarks1:Example of use}
	{help mata_mosave##remarks2:Where to store .mo files}
	{help mata_mosave##remarks3:Use of .mo files versus .mlib files}


{marker remarks1}{...}
{title:Example of use} 

{p 4 4 2}
{cmd:.mo} files contain the object code for one function.  If you store a
function's object code in a {cmd:.mo} file, then in future Mata sessions, you
can use the function without recompiling the source.  The function will
appear to become a part of Mata just as all the other functions documented in
this manual are.  The function can be used because the object code will be
automatically found and loaded when needed.

{p 4 4 2}
For example, 

	: {cmd:function add(a,b) return(a+b)}

	: {cmd:add(1,2)}
	  3

	: {cmd:mata mosave add()}
	(file add.mo created)

	: {cmd:mata clear}

	: {cmd:add(1,2)}
	  3

{p 4 4 2}
In the example above, function {cmd:add()} was saved in file {cmd:add.mo}
stored in the current directory.  After clearing Mata, we could still use the
function because Mata found the stored object code.


{marker remarks2}{...}
{title:Where to store .mo files}

{p 4 4 2}
Mata could find {cmd:add()} because file {cmd:add.mo} was in the current 
directory, and our ado-path included {cmd:.}:

	. {cmd:adopath}
	{txt}  [1]  (BASE)      "{res}C:\Program Files\Stata16\ado\base\{txt}"
	  [2]  (SITE)      "{res}C:\Program Files\Stata16\ado\site\{txt}"
	  [3]              "{res}.{txt}"
	  [4]  (PERSONAL)  "{res}C:\ado\personal\{txt}"
	  [5]  (PLUS)      "{res}C:\ado\plus\{txt}"
	  [6]  (OLDPLACE)  "{res}C:\ado\{txt}"

{p 4 4 2}
If later we were to change our current directory, 

	. {cmd:cd ..\otherdir}

{p 4 4 2}
Mata would no longer be able to find the file {cmd:add.mo}.  Thus
the best place to store your personal {cmd:.mo} files is in your 
{cmd:PERSONAL} directory.  Thus rather than typing 

	: {cmd:mata mosave example()}

{p 4 4 2}
we would have been better off typing

	: {cmd:mata mosave example(), dir(PERSONAL)}


{marker remarks3}{...}
{title:Use of .mo files versus .mlib files}

{p 4 4 2}
Use of {cmd:.mo} files is heartily recommended.  The alternative for saving 
compiled object code are {cmd:.mlib} libraries; see 
{bf:{help mata_mlib:[M-3] mata mlib}}
and 
{bf:{help m1_ado:[M-1] Ado}}.

{p 4 4 2}
Libraries are useful when you have many functions and want to tie them 
together into one file, especially if you want to share those functions
with others, because then you have only one file to distribute.  The
disadvantage of libraries is that you must rebuild them whenever you wish to
remove or change the code of one function.  If you have only a few object
files, or if you have many but sharing is not an issue, {cmd:.mo} libraries are
easier to manage.
{p_end}
