{smcl}
{* *! version 2.0.3  25sep2018}{...}
{vieweralsosee "[M-3] lmbuild" "mansection M-3 lmbuild"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata mlib" "help mata mlib"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "lmbuild##syntax"}{...}
{viewerjumpto "Description" "lmbuild##description"}{...}
{viewerjumpto "Links to PDF documentation" "lmbuild##linkspdf"}{...}
{viewerjumpto "Options" "lmbuild##options"}{...}
{viewerjumpto "Remarks" "lmbuild##remarks"}{...}
{viewerjumpto "Source code" "lmbuild##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-3] lmbuild} {hline 2}}Easily create function library
{p_end}
{p2col:}({mansection M-3 lmbuild:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 29 2}
{cmd:.} {cmd:lmbuild}
{it:libname}
[{cmd:,}
[{cmd:new}|{cmd:replace}|{cmd:add}]
{opth dir:(lmbuild##dirname:dirname)}
{cmd:size(}{it:#}{cmd:)}]

{p 4 8 2}
    {it:libname} is the name of a Mata library, such as 
    {bf:lexample.mlib}.  Library names must start with {cmd:l} and end
    in {cmd:.mlib}.  Library names may be specified with or without the
    extension.

{p 4 8 2}
{cmd:lmbuild} is a Stata command that you use from Stata's dot prompt,
not from  Mata's colon prompt.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:lmbuild} builds Mata function libraries just as 
{helpb mata_mlib:mata mlib} does.  Even though {cmd:lmbuild}
virtually requires the creation of a do-file, it is easier to use and
is therefore a better alternative than {cmd:mata mlib}.

{p 4 4 2}
Why two commands to do the same thing?  {cmd:mata mlib} existed first to
create Mata libraries, but it was complicated to use.  {cmd:lmbuild} was
added later and makes it easier to create those libraries.

{p 4 4 2}
You type {cmd:lmbuild} after Stata's dot prompt, not Mata's colon prompt.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 lmbuildRemarksandexamples:Remarks and examples}


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:new}, {cmd:replace}, and {cmd:add} are alternatives and indicate
     whether the library file is new, should be replaced,
     or should be added to.

{p 8 8 2}
    {cmd:new} is the default.  It specifies that {it:libname} does not
    already exist and is to be created.

{p 8 8 2}
    {cmd:replace} specifies that {it:libname} might already exist, and
    if it does, the library is to be replaced.

{p 8 8 2}
    {cmd:add} specifies that {it:libname} already exists and functions
    are to be added to the existing library.  We advise you not to use
    this option except in carefully constructed do-files that create
    the library from start to finish.  If you choose to use {cmd:add}
    interactively, you run the risk of
    creating irreproducible libraries.

{marker dirname}{...}
{p 4 8 2}
{opt dir(dirname)} specifies the directory in which {it:libname} exists 
    or is to be created.  {it:dirname} may be one of the following:

{p 8 8 2}
    {cmd:dir(PERSONAL)} is the default.  Libraries will be created or
    updated in your personal directory.  You can type the
    {helpb sysdir} command to find out where your personal directory is.
    Libraries in your personal directory will be automatically found
    by Mata.  If you do not already have a personal directory,
    {cmd:lmbuild} will create one for you.

{p 8 8 2}
    {cmd:dir(SITE)} specifies that the library be created or updated in
    the site directory.  This directory is shared across Stata users at
    your location.  You can type the {helpb sysdir} command to find out
    where your site directory is.  You will probably need administrator
    privileges to write to this directory.

{p 8 8 2}
    {cmd:dir(.)} specifies that the library exists or is to be created
    in the current directory.  The only reasons to specify {cmd:dir(.)}
    are that you intend to copy the library to another directory later,
    to send the library to someone, or to include the library in a 
    {help usersite:package} for distribution to other users.

{p 8 8 2}
    {cmd:dir(}{it:directory}{cmd:)} specifies that the library exists or
    is to be created in {it:directory}.  Specifying this option is not
    recommended because Mata will not find such libraries unless they
    are added to Mata's {help mata set:search path}.

{p 4 8 2}
{cmd:size(}{it:#}{cmd:)} specifies the maximum number of functions
    to be allowed in the library.  Libraries allow up to 1,024
    functions by default.  {it:#} may be a number from 2 to 2,048.
    {cmd:size()} may be specified only with new libraries or libraries
    that are being replaced.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Mata functions that you write and then store in libraries are placed on
the same footing as Mata's built-in functions.  They can be used in
code that you write without being preloaded, whether that code is in
do-files, ado-files, or Mata.

{p 4 4 2}
You can have as many Mata libraries as you wish.  Each library may
contain up to 1,024 functions, or up to 2,048 if you specify
{cmd:lmbuild}'s {cmd:size()} option.

{p 4 4 2}
Libraries store the compiled version of functions, not the source code.
We recommend that you place your source code in do-files that look like 
the following:

	{hline 47} hello.mata {hline 3}
        {cmd:version} {it:#}

        {cmd:mata:}
        {cmd:void hello()}
        {cmd:{c -(}}
                {cmd:printf("hello world\n")}
        {cmd:{c )-}}
        {cmd:end}
	{hline 62}

{p 4 4 2}
You can load the function into Mata by typing {cmd:do hello.mata} at
the Stata prompt.  You can test the function.  When you want to place
the function in a library, you type

        . {cmd:clear all}

        . {cmd:do hello.mata}

        . {cmd:lmbuild lmylib}

{p 4 4 2}
{cmd:lmbuild} {cmd:lmylib} creates a Mata library named 
{cmd:lmylib.mlib} containing all the Mata functions loaded into memory
since the last {helpb clear:clear all}.  Thus, this library will
contain just one function, namely, {cmd:hello()}.

{p 4 4 2}
If you had other functions stored in other {cmd:.mata} files, you could
load each of them and then create the library:

        . {cmd:clear all}

        . {cmd:do hello.mata}

        . {cmd:do havelunch.mata}

        . {cmd:do goodbye.mata}

        . {cmd:lmbuild lmylib}

{p 4 4 2}
The Mata library would contain three functions, assuming the three
{cmd:.mata} files defined three Mata functions.  The three functions
defined are probably named {cmd:hello()}, {cmd:havelunch()}, and
{cmd:goodbye()}, but it is not required that the function name match
the filename.
Each {cmd:.mata} file, in fact, can define as many functions as you
wish.  If the file {cmd:hello.mata} contained

	{hline 47} hello.mata {hline 3}
        {cmd:version} {it:#}

        {cmd:mata:}

        {cmd:void hello()}
        {cmd:{c -(}}
                {cmd:printf("hello world\n")}
        {cmd:{c )-}}

        {cmd:void goodbye()}
        {cmd:{c -(}}
                {cmd:printf("good-bye world\n")}
        {cmd:{c )-}}

        {cmd:end}
	{hline 62}

{p 4 4 2}
and you typed 

        . {cmd:clear all}

        . {cmd:do hello.mata}

        . {cmd:lmbuild lmylib}

{p 4 4 2}
then there would be two functions in the library:  {cmd:hello()} and
{cmd:goodbye()}.

{p 4 4 2}
Usually, you will have multiple {cmd:.mata} files and define multiple
functions in some of them.  Each file will define a function and its
subroutines.  Sometimes, however, you will define related functions 
in the same file.  Regardless of the situation, libraries should not 
be built interactively because someday code will change and you will need
to rebuild the library.  The right way to proceed is to make a 
do-file that will make it easy for you to create and re-create the 
library:  

	{hline 43} make_lmylib.do {hline 3}
        {cmd:* version number intentionally omitted}

        {cmd:clear all}
        {cmd:do hello.mata}
        {cmd:do bigfcn.mata}
        {cmd:do utilityfunctions.mata}
        .
        .
        {cmd:lmbuild lmylib, replace}
	{hline 62}

{p 4 4 2}
With this do-file written, all we have to type to create the library 
for the first time is 

        . {cmd:do make_lmylib}

{p 4 4 2}
All we have to type to re-create the library later is 

        . {cmd:do make_lmylib}

{p 4 4 2}
Why would we need to re-create the library?  One reason would be that we
need to re-create the library after fixing a bug in {cmd:bigfcn.mata}.

{p 4 4 2}
Notice the comment at the top of {cmd:make_lmylib.do},

        {cmd:* version number intentionally omitted}

{p 4 4 2}
and notice that we included version numbers in each of the {cmd:.mata}
files.  That is how you handle version control with libraries.


{title:Version control}

{p 4 4 2}
The version number appearing in each {cmd:.mata} file is the version
number under which the code was written.  If {cmd:hello.mata} was written
back in the days of Stata 11, it would read

	{hline 47} hello.mata {hline 3}
        {cmd:version 11}

        {cmd:mata:}
        {cmd:void hello()}
        {cmd:{c -(}}
                {cmd:printf("hello world\n")}
        {cmd:{c )-}}
        {cmd:end}
	{hline 62}

{p 4 4 2}
The first line of the file sets the version of Mata in which
the code is written.  It is called the compile-time version number.
Specifying the compile-time version number ensures that the code is backdated
to retain its original behavior should the meaning or requirements of some
aspect of Mata's programming language or some feature of Mata's compiler
change.

{p 4 4 2}
In file {cmd:make_mylib.do}, there is nothing we want
backdated.  The entire purpose of {cmd:make_mylib.do} is to make a
modern Mata library, even as new versions of Stata are released.  Thus,
the version number is intentionally omitted.

{p 4 4 2}
One more type of version number where Mata is concerned is
called the run-time version number.  It is not directly relevant for
building libraries, but it is relevant when you want to change the way
functions work for different versions of Stata just as we do at
StataCorp with the functions we write.  We do not preserve bugs, of
course, but we do add features, and sometimes new features get in
the way of old ones.  If we did not write our code in a certain way, old
do-files would not continue to work until the user had updated them to
new syntax and calling sequences.  We write code in such a way that users do 
not have to do that.

{p 4 4 2}
Let's consider a case where you wrote {cmd:bigfcn()} back in the days 
of Stata 13.  In Stata 18, you rewrote the function, changed what 
the arguments did, and increased the number of arguments from one 
to two.  Your original code looked like this:

	{hline 47} bigfcn.mata {hline 3}
        {cmd:version 13}
        {cmd:mata:}

        {cmd:real matrix bigfcn(real matrix A)}
        {cmd:{c -(}}
                ...
        {cmd:{c )-}}

        {cmd:end}
	{hline 62}

{p 4 4 2}
Here is how your updated code might look if you wanted to preserve 
old behavior and allow new features: 

	{hline 47} bigfcn.mata {hline 3}
        {cmd:version 18}
        // -------------------------------------- version 18 starts here
        {cmd:mata:}

        {cmd:real matrix bigfcn(real matrix A, |real scalar style)}
        {cmd:{c -(}}
                {cmd:if (callersversion()>=18) return(bigfcn_new(A, style))}
                {cmd:else                      return(bigfcn_old(A))}
        {cmd:{c )-}}

        {cmd:real matrix bigfcn_new(real matrix A, real scalar style)}
        {cmd:{c -(}}
                ... {it:new code} ...
        {cmd:{c )-}}
        {cmd:end}
        // ----------------------------------------------- and ends here

        {cmd:version 13}
        // -------------------------------------- version 13 starts here
        {cmd:mata:}

        {cmd:real matrix bigfcn_old(real matrix A)}
        {cmd:{c -(}}
                ... {it:old code} ...
        {cmd:{c )-}}

        {cmd:end}
        // ----------------------------------------------- and ends here
	{hline 62}

{p 4 4 2}
    Notice that we specified {cmd:version} {cmd:18} for part of 
    the file and {cmd:version} {cmd:13} for the other part.  That
    is how we made sure that the old code compiled as intended, 
    just in case the compiler changed.

{p 4 4 2}
    In the new {cmd:bigfcn()} function, we make the second argument 
    optional by specifying {cmd:|real scalar style}.  Notice the 
    vertical bar and see {helpb m2_optargs:[M-2] optargs}.

{p 4 4 2}
    Finally, notice that we used Mata built-in function 
    {helpb mata callersversion():callersversion()}
    to call the new or old code as appropriate.

{p 4 4 2}
    With {cmd:bigfcn()} defined this way, old do-files continue to 
    work, such as 

	{hline 47} oldfile.do {hline 3}
        {cmd:version 13}
        ...
        ...   {cmd:bigfcn(X)} ...
        ...
	{hline 62}

{p 4 4 2}
    Do-files specifying version 14 through 17 would continue to work, too.

{p 4 4 2}
    A modern do-file set to version 18 or later, however, 
    would use the improved {cmd:bigfcn()} and its two arguments: 

	{hline 47} modernfile.do {hline 3}
        {cmd:version 18}
        ...
        ...   {cmd:bigfcn(X, 1)} ...
        ...
	{hline 62}

{p 4 4 2}
    The version number specified in the do-file is known as its 
    run-time setting.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view lmbuild.ado, adopath asis:lmbuild.ado}
{p_end}
