{smcl}
{* *! version 1.2.13  15may2018}{...}
{vieweralsosee "[M-3] mata mlib" "mansection M-3 matamlib"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] lmbuild" "help lmbuild"}{...}
{vieweralsosee "[M-3] mata mosave" "help mata_mosave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_mlib##syntax"}{...}
{viewerjumpto "Description" "mata_mlib##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_mlib##linkspdf"}{...}
{viewerjumpto "Options" "mata_mlib##options"}{...}
{viewerjumpto "Remarks" "mata_mlib##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-3] mata mlib} {hline 2}}Create function library
{p_end}
{p2col:}({mansection M-3 matamlib:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata mlib create}
{it:libname}{bind:          }
[{cmd:,} 
{cmd:dir(}{it:path}{cmd:)} 
{cmd:replace}
{cmd:size(}{it:#}{cmd:)}
]

{p 8 16 2}
: {cmd:mata mlib add}{bind:   }
{it:libname}
{it:fcnlist}{cmd:()}
[{cmd:,} 
{cmd:dir(}{it:path}{cmd:)} 
{cmd:complete}
]

{p 8 17 2}
: {cmd:mata mlib index}

{p 8 17 2}
: {cmd:mata mlib} {cmdab:q:uery}


{p 4 4 2}
where {it:fcnlist}{cmd:()} is a {it:namelist} containing only function names, such 
as 

		{it:fcnlist}{cmd:()} examples
		{hline 41}
		{cmd:myfunc()}
		{cmd:myfunc()} {cmd:myotherfunc()} {cmd:foo()}
		{cmd:f*() g*()}
		{cmd:*()}
		{hline 41}
		see {bf:{help m3_namelists:[M-3] namelists}} 


{p 4 4 2}
and where {it:libname} is the name of a library.  You must start {it:libname}
with the letter {cmd:l} and do not add the {cmd:.mlib} suffix as it will be
added for you.  Examples of {it:libnames} include

		{it:libname}           Corresponding filename
		{hline 41}
		{cmd:lmath}                  {cmd:lmath.mlib}
		{cmd:lmoremath}              {cmd:lmoremath.mlib}
		{cmd:lnjc}                   {cmd:lnjc.mlib}
		{hline 41}

{p 4 4 2}
Also {it:libnames} that begin with the letters {cmd:lmata}, 
such as {cmd:lmatabase}, are reserved for the names of official libraries.

{p 4 4 2}
This command is for use in Mata mode following Mata's colon prompt.
To use this command from Stata's dot prompt, type

		. {cmd:mata: mata mlib} ...


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata libraries are useful.  You can put your functions in them.  If you
do that, you can use your functions just as if they were built in to
Mata.  Your functions and Mata's are put on equal footing.  The footing
really is equal because Mata's built-in functions are also stored in
libraries.  The only difference is that those libraries are created
and maintained by StataCorp.

{p 4 4 2}
{cmd:mata} {cmd:mlib} creates, adds to, and causes Mata to index
{cmd:.mlib} files, which are libraries containing the object-code
functions.  The {cmd:lmbuild} command also creates and maintains
Mata function libraries, but {cmd:lmbuild} is easier to use than
{cmd:mata mlib create} or {cmd:mata mlib add}.  Therefore, we
suggest you use {cmd:lmbuild} (see {manhelp lmbuild M-3:lmbuild})
instead of these commands.

{p 4 4 2}
{cmd:mata} {cmd:mlib} has two other features that are sometimes
useful. Mata maintains a list for itself of the libraries it is to search when
looking for functions.  Mata builds that list when Stata is launched.  Type
{cmd:mata} {cmd:mlib} {cmd:query} to see the list.  Mata tries to keep the
list up to date as you work, but if you create a new library and do not use
{cmd:lmbuild}, Mata will not know about it.  Or if you copy a library from a
colleague, Mata will not know about it until Stata is relaunched.  Type
{cmd:mata} {cmd:mlib} {cmd:index} in such cases, and Mata will rebuild the
list.

{p 4 4 2}
{cmd:mata mlib create} creates a new, empty library.

{p 4 4 2}
{cmd:mata mlib add} adds new members to a library.

{p 4 4 2}
{cmd:mata mlib index} causes Mata to build a new list of libraries to be 
searched.

{p 4 4 2}
{cmd:mata mlib query} lists the libraries to be searched.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matamlibRemarksandexamples:Remarks and examples}

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
    {cmd:SITE} {cmd:PLUS}, {cmd:PERSONAL}, or {cmd:OLDPLACE}; see 
    {bf:{help sysdir:[P] sysdir}}.
    {cmd:dir(PERSONAL)} is recommended.

{p 4 8 2}
{cmd:complete} is for use when saving class definitions.  It specifies 
     that the definition be saved only if it is complete;
     otherwise, an error message is to be issued.
     See {bf:{help m2_class:[M-2] class}}.

{p 4 8 2}
{cmd:replace} specifies that the file may be replaced if it already exists.

{p 4 8 2}
{cmd:size(}{it:#}{cmd:)}, used with {cmd:mlib} {cmd:create}, 
    specifies the maximum number of members the newly created library 
    will be able to contain, 2 <= {it:#} <= 2048.  
    The default is {cmd:size(1024)}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mata_mlib##remarks1:Background}
	{help mata_mlib##remarks2:Outline of the procedure for dealing with libraries}
	{help mata_mlib##remarks3:Creating a .mlib library}
	{help mata_mlib##remarks4:Adding members to a .mlib library}
	{help mata_mlib##remarks5:Listing the contents of a library}
	{help mata_mlib##remarks6:Making it so Mata knows to search your libraries}
	{help mata_mlib##remarks7:Advice on organizing your source code}

{p 4 4 2}
Also see {bf:{help m1_how:[M-1] How}} for an
explanation of object code.


{marker remarks1}{...}
{title:Background}

{p 4 4 2}
{cmd:.mlib} files contain the object code for one or more functions.
Functions which happen to be stored in libraries are called 
library functions, and 
Mata's library functions are also stored in {cmd:.mlib} libraries.
You can create your own libraries, too.

{p 4 4 2}
Mata provides two ways to store object code:

{p 8 12 2}
    1.  In a {cmd:.mo} file, which contains the code for one function

{p 8 12 2}
    2.  In a {cmd:.mlib} library file, which may contain the code for
        up to 2,048 functions

{p 4 4 2}
{cmd:.mo} files are easier to use and work just as well as {cmd:.mlib}
libraries; see {bf:{help mata_mosave:[M-3] mata mosave}}.  {cmd:.mlib}
libraries, however, are easier to distribute to others when you have many 
functions, because they are combined into one file.


{marker remarks2}{...}
{title:Outline of the procedure for dealing with libraries}

{p 4 4 2}
Working with libraries is easy:

{p 8 12 2}
    1.  First, choose a name for your library.  We will choose the 
        name {cmd:lpersonal}.

{p 8 12 2}
    2.  Next, create an empty library by using the {cmd:mata} {cmd:mlib}
        {cmd:create} command.

{p 8 12 2}
    3.  After that, you can add new members to the library at any time,
        using {cmd:mata} {cmd:mlib} {cmd:add}.

{p 4 4 2}
{cmd:.mlib} libraries contain object code, not the 
original source code, so you need to keep track of the source code yourself.
Also, if you want to update the object code in a function stored in a
library, you must re-create the entire library; there is no way to
replace or delete a member once it is added.

{p 4 4 2}
We begin by showing you the mechanical steps, and then we will tell you
how we manage libraries and source code.


{marker remarks3}{...}
{title:Creating a .mlib library}

{p 4 4 2}
If you have not read {bf:{help mata_mosave:[M-3] mata mosave}}, 
please do so.

{p 4 4 2}
To create a new, empty library named {cmd:lpersonal.mlib} in the current 
directory, type 

	: {cmd:mata mlib create lpersonal}
	(file lpersonal.mlib created)

{p 4 4 2}
If {cmd:lpersonal.mlib} already exists and you want to replace it, either 
erase the existing file first or type 

	: {cmd:mata mlib create lpersonal, replace}
	(file lpersonal.mlib created)

{p 4 4 2}
To create a new, empty library named {cmd:lpersonal.mlib} in your 
{cmd:PERSONAL} (see {bf:{help sysdir:[P] sysdir}}) directory, type 

	: {cmd:mata mlib create lpersonal, dir(PERSONAL)}
	(file c:\ado\personal\lpersonal.mlib created)

{p 4 4 2}
or 

	: {cmd:mata mlib create lpersonal, dir(PERSONAL) replace}
	(file c:\ado\personal\lpersonal.mlib created)


{marker remarks4}{...}
{title:Adding members to a .mlib library}

{p 4 4 2}
Once a library exists, whether you have just created it and it is 
empty, or it already existed and contains some functions, 
you can add new functions to it by typing 

	: {cmd:mata mlib add} {it:libname} {it:fcnname}{cmd:()}

{p 4 4 2}
So, if we wanted to add function {cmd:example()} to library {cmd:lpersonal.mlib}, 
we would type 

	: {cmd:mata mlib add lpersonal example()}
	(1 function added)

{p 4 4 2}
In doing this, we do not have to say where {cmd:lpersonal.mlib} is stored;
Mata searches for it along the ado-path.

{p 4 4 2}
Before you can add {cmd:example()} to the library, however, you 
must compile it:

	: {cmd:function} {cmd:example}{cmd:(}...{cmd:)}
	> {cmd:{c -(}}
	>        ...
	> {cmd:{c )-}}

	: {cmd:mata mlib add lpersonal example()}
	(1 function added)

{p 4 4 2}
You can add many functions to a library in one command:

	: {cmd:mata mlib add lpersonal example2() example3()}
	(2 functions added)

{p 4 4 2}
You can add all the functions currently in memory by typing 

	: {cmd:mata mlib add lanother *()}
	(3 functions added)

{p 4 4 2}
In the above example, we added to {cmd:lanother.mlib} because 
we had already added {cmd:example()}, {cmd:example2()}, and 
{cmd:example3()} to {cmd:lpersonal.mlib} and trying to add them again 
would result in an error.  (Before adding {cmd:*()}, we could 
verify that we are adding what we want to add by typing 
{cmd:mata} {cmd:describe} {cmd:*()}; see help 
{bf:{help mata_describe:[M-3] mata describe}}.)


{marker remarks5}{...}
{title:Listing the contents of a library}

{p 4 4 2}
Once a library exists, you can list its contents (the names of the 
functions it contains) by typing 

	: {cmd:mata describe using} {it:libname}

{p 4 4 2}
Here we would type 

	: {cmd:mata describe using lpersonal}

              {txt}# bytes   type                       name and extent
        {hline 69}
        {res}           24   {txt}auto transmorphic matrix   {res}example{txt}()
        {res}           24   {txt}auto transmorphic matrix   {res}example2{txt}()
        {res}           24   {txt}auto transmorphic matrix   {res}example3{txt}()
        {hline 69}{txt}

{p 4 4 2}
{cmd:mata} {cmd:describe} usually lists the contents of memory, but 
{cmd:mata} {cmd:describe} {cmd:using} lists the contents of a library.


{marker remarks6}{...}
{title:Making it so Mata knows to search your libraries}

{p 4 4 2}
Mata automatically finds the {cmd:.mlib} libraries on your computer.  It does
this when Mata is invoked for the first time during a session.  Thus
everything is automatic except that Mata will know nothing about any new
libraries created during the Stata session, so after creating a new library,
you must tell Mata about it.  You do this by asking Mata to rebuild its
library index:

	: {cmd:mata mlib index}

{p 4 4 2}
You do not specify the name of your new library.  That name 
does not matter because Mata rebuilds its entire library index.  

{p 4 4 2}
You can issue the {cmd:mata mlib index} command right after creating the
new library

	: {cmd:mata mlib create lpersonal, dir(PERSONAL)}

	: {cmd:mata mlib index}

{p 4 4 2}
or after you have created and added to the library:

	: {cmd:mata mlib create lpersonal, dir(PERSONAL)}

	: {cmd:mata mlib add lpersonal *()}

	: {cmd:mata mlib index}

{p 4 4 2}
It does not matter.  Mata does not need to rebuild its index after a 
known library is updated; Mata needs to be told to rebuild only
when a new library is added during the session.  


{marker remarks7}{...}
{title:Advice on organizing your source code}

{p 4 4 2}
Say you wish to create and maintain {cmd:lpersonal.mlib}.  Our preferred 
way is to use a do-file:

	{hline 43} begin lpersonal.do {hline 6}
	{cmd}mata:
	mata clear

	{txt}{it:function definitions appear here}{cmd}

	mata mlib create lpersonal, dir(PERSONAL) replace
	mata mlib add lpersonal *()
	mata mlib index
	end{txt}
	{hline 43} end lpersonal.do {hline 8}

{p 4 4 2}
This way, 
all we have to do to create or re-create the library is 
enter Stata, change to the directory containing our source code, and 
type

	. {cmd:do lpersonal}

{p 4 4 2}
For large libraries, we like to put the source code for different parts in
different files:

	{hline 43} begin lpersonal.do {hline 6}
	{cmd}mata: mata clear

	do function1.mata
	do function2.mata
	{txt}...{cmd}

	mata:
	mata mlib create lpersonal, dir(PERSONAL) replace
	mata mlib add lpersonal *()
	mata mlib index
	end{txt}
	{hline 43} end lpersonal.do {hline 8}

{p 4 4 2}
The function files contain the source code, which might include
one function, or it might include more than one function if the primary function 
had subroutines:

	{hline 42} begin function1.mata {hline 6}
	{cmd:mata:}
	{it:function definitions appear here}
	{cmd:end}
	{hline 42} end function1.mata {hline 8}

{p 4 4 2}
We name our component files ending in {cmd:.mata}, but they are still just 
do-files.
{p_end}
