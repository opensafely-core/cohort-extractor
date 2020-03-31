{smcl}
{* *! version 1.3.2  14may2019}{...}
{findalias asgsmprofile}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] do" "help do"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{viewerjumpto "Description" "profilem##description"}{...}
{viewerjumpto "Examples" "profilem##examples"}{...}
{title:Title}

{p 4 16 2}
{findalias gsmprofile}


{marker description}{...}
{title:Description}

{pstd}
Stata first looks for the file sysprofile.do when it is invoked.  After
that, Stata looks for the file profile.do.  If either of these files are
found, Stata executes the commands they contain.  Stata looks first in
the directory where Stata is installed, then in the current directory,
then along your path, and finally along the ado-path (see
{helpb adopath}). We recommend that you put profile.do in ~/Documents/Stata.

{pstd}
sysprofile.do is intended for system administrators.  This file is
handled in the same way as profile.do, except that Stata first looks for
sysprofile.do. If that file is found, Stata will execute any commands it
contains. After that, Stata will look for profile.do and, if that
file is found, execute the commands in it.  We recommend that
sysprofile.do be placed in the directory where Stata is installed.


{marker examples}{...}
{title:Examples}

{pstd}
Say that every time you started Stata you wanted {cmd:niceness} set to 6
(see {helpb memory}).

{p 8 12 2}Create profile.do in ~/Documents/Stata containing

{p 8 12 2}{cmd:set niceness 6}

{p 8 12 2}When you invoke Stata, this command will be executed:

{p 8 12 2}{res:running ~/Documents/Stata/profile.do ...}{p_end}
	{cmd:. _ }

{pstd}
If a system administrator wanted to change the path to Stata's SITE directory,
then {cmd:sysprofile.do} could be created in the Stata directory and contain
the command

{p 8 12 2}{cmd:sysdir set SITE "~/Documents/Stata}

{p 8 12 2}When you invoke Stata, this command will be executed:

{p 8 12 2}{res:running /Applications/Stata/sysprofile.do ...}{p_end}
        {cmd:. _ }

{p 8 12 2}If profile.do exists, Stata would run that after sysprofile.do
finished.

{pstd}
sysprofile.do and profile.do are treated just as any other do-files once they
are executed; results are literally as if you started Stata and then typed
{cmd:run sysprofile.do} or {cmd:run profile.do}.  The only special thing about
these do-files is that Stata looks for them and runs them automatically.  If
sysprofile.do or profile.do do not already exist, then you will have to create
them.  This can be done just as you would create any other do-file.

{pstd}
See {findalias gsmprofile} for a full discussion of these startup files.

{pstd}
See {findalias frdofiles} for an explanation of do-files.  They are nothing
more than text (ASCII) files containing a sequence of commands for Stata to
execute.
{p_end}
