{smcl}
{* *! version 1.1.6  19dec2012}{...}
{viewerdialog hsearch "dialog hsearch"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net search" "help net_search"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{viewerjumpto "Syntax" "hsearch##syntax"}{...}
{viewerjumpto "Description" "hsearch##description"}{...}
{viewerjumpto "Option" "hsearch##option"}{...}
{viewerjumpto "Remarks" "hsearch##remarks"}{...}
{pstd}
{cmd:hsearch} continues to work but, as of Stata 12, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 20 22 2}{...}
{p2col:{hi:[R] hsearch} {hline 2}}Search help files{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:hsearch} 
{it:word(s)}

{p 8 8 2}
{cmd:hsearch} 
{it:word(s)}{cmd:,}
{cmd:build}

{p 8 8 2}
{cmd:hsearch,} 
{cmd:build}


{marker description}{...}
{title:Description}

{pstd}
{cmd:hsearch} {it:word(s)} searches the help files for {it:word(s)} and
presents a clickable list in the Viewer.

{pstd}
{cmd:hsearch} {it:word(s)}{cmd:, build} does the same thing but builds 
a new index first.

{pstd}
{cmd:hsearch,} {cmd:build} rebuilds the index but performs no search.


{marker option}{...}
{title:Option}

{phang}
{opt build} 
    forces the index that {cmd:hsearch} uses to be built or
    rebuilt.

{pmore}
    The index is automatically built the first time you use
    {cmd:hsearch}, and it is automatically rebuilt if you have recently
    installed an ado-file update by using {cmd:update}; see
    {manhelp update R}.  
    Thus the {cmd:build} option is rarely specified.

{pmore}
    You should specify
    {cmd:build} if you have recently installed 
    user-written ado-files by using {cmd:net install} (see 
    {manhelp net R}) or {cmd:ssc} (see {manhelp ssc R}), or if you have
    recently updated any of your own help files.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help hsearch##remarks1:Using hsearch}
	{help hsearch##remarks2:Alternatives to hsearch}
	{help hsearch##remarks3:Recommendations}
	{help hsearch##remarks4:How hsearch works}


{marker remarks1}{...}
{title:Using hsearch}

{pstd}
You use {cmd:hsearch} to find help for commands and features installed on your
computer.  If you wanted to find commands related to Mills' ratio, you would
type

	. {cmd:hsearch Mills' ratio}

{pstd}
You could just as well type 

	. {cmd:hsearch Mill's ratio}

{pstd}
or type any of

	. {cmd:hsearch Mills ratio}

	. {cmd:hsearch mills ratio}

{pstd}
or even 

	. {cmd:hsearch ratio mills}

{pstd}
because word order, capitalization, and punctuation do not matter.


{marker remarks2}{...}
{title:Alternatives to hsearch}

{pstd}
Alternatives to {cmd:hsearch} are {cmd:search} and {cmd:findit}:

	. {cmd:search mills ratio}

	. {cmd:findit mills ratio}

{pstd}
{helpb search}, like {cmd:hsearch}, searches commands already installed on
your computer.  {cmd:search} searches the keywords; {cmd:hsearch} searches the
help files themselves.  Hence, {cmd:hsearch} usually finds everything that
{cmd:search} finds and more.  The fewer things that {cmd:search} finds should
be more relevant.

{pstd}
{helpb findit}
searches keywords just as {cmd:search} does, but {cmd:findit} searches the web
as well as your computer and so may find commands that you might wish to
install.


{marker remarks3}{...}
{title:Recommendations}

{phang2}
o
In general, {cmd:hsearch} is better than {cmd:search}.  {cmd:hsearch} finds
more and better organizes the list of what it finds.

{phang2}
o
When you know that Stata can do what you are looking for but you cannot
remember the command name or when you know that you installed a 
relevant user-written package, use {cmd:hsearch}.

{phang2}
o
When you are unsure whether Stata can do a certain
task, use {cmd:hsearch} first and then use {cmd:findit}.


{marker remarks4}{...}
{title:How hsearch works}

{pstd}
{cmd:hsearch} searches the {cmd:.sthlp} files.

{pstd}
Finding all those files and then looking through them would take a long
time if {cmd:hsearch} did that every time you used it.  Instead,
{cmd:hsearch} builds an index of the {cmd:.sthlp} files and then searches that.

{pstd}
That file is called {cmd:sthlpindex.idx} and is stored in your 
{help sysdir:PERSONAL} directory.

{pstd}
Every so often, {cmd:hsearch} automatically rebuilds the index so that it
accurately reflects what is installed on your computer.  You
can force {cmd:hsearch} to rebuild the index at any time by typing

	. {cmd:hsearch, build}
