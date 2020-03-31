{smcl}
{* *! version 1.1.11  23mar2018}{...}
{vieweralsosee "[P] findfile" "mansection P findfile"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] sysdir" "help adopath"}{...}
{vieweralsosee "[D] sysuse" "help sysuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _getfilename" "help _getfilename"}{...}
{vieweralsosee "[P] unabcmd" "help unabcmd"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "findfile##syntax"}{...}
{viewerjumpto "Description" "findfile##description"}{...}
{viewerjumpto "Links to PDF documentation" "findfile##linkspdf"}{...}
{viewerjumpto "Options" "findfile##options"}{...}
{viewerjumpto "Remarks" "findfile##remarks"}{...}
{viewerjumpto "Stored results" "findfile##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] findfile} {hline 2}}Find file in path{p_end}
{p2col:}({mansection P findfile:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:findfile}
{it:{help filename}}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:nodes:cend}
{cmd:all}]

{pstd}
where {it:filename} and {it:path} may optionally be enclosed in quotes, and
the default is to look over the ado-path if option {cmd:path()}
is not specified.


{marker description}{...}
{title:Description}

{pstd}
{cmd:findfile} looks for a file along a specified path and, if the file is
found, displays the fully qualified name and returns the name in {cmd:r(fn)}.
If the file is not found, the file-not-found error, r(601), is issued.

{pstd}
Unless told otherwise, {cmd:findfile} looks along the ado-path,
the same path that Stata uses for searching for ado-files, help files, etc.

{pstd}
In programming contexts, {cmd:findfile} is usually preceded
by {cmd:quietly}; see {helpb quietly:[P] quietly}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P findfileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:path(}{it:path}{cmd:)} specifies the path over which {cmd:findfile} is to
    search.  Not specifying this option is equivalent to specifying
    {cmd:path(`"`c(adopath)'"')}.

{pmore}
    If specified, {it:path} should be a list of directory (folder) names
    separated by semicolons; for example,

	    {cmd:path(`".;~/bin;"~/data/my data";~"')}
	    {cmd:path(`".;\bin;"\data\my data";~"')}

{pmore}
    The individual directory names may be enclosed in quotes, but if any are,
    remember to enclose the entire path argument in compound quotes.

{pmore}
    Also any of the directory names may be specified as {cmd:STATA},
    {cmd:BASE}, {cmd:SITE}, {cmd:PLUS}, {cmd:PERSONAL}, or
    {cmd:OLDPLACE}, which are indirect references to directories recorded by
    {helpb sysdir}:

	    {cmd:path(BASE;SITE;.;PERSONAL;PLUS)}
	    {cmd:path(\bin:SITE;.;PERSONAL;PLUS)}
	    {cmd:path(`"\bin;.;"\data\my data";PERSONAL;PLUS"')}
	    {cmd:path(`".;`c(adopath)'"')}

{phang}
{cmd:nodescend} specifies that {cmd:findfile} not follow Stata's
    normal practice of searching in letter subdirectories of directories in
    the path, as well as in the directories themselves.  {cmd:nodescend} is
    rarely specified, and, if it is specified, {cmd:path()} would usually be
    specified, too.

{phang}
{cmd:all} specifies that all files along the path with the specified name are
    to be found and then listed and stored in {cmd:r(fn)}.  When {cmd:all} is
    not specified, the default is to stop the search when the first instance of
    the specified name is found.

{pmore}
    When {cmd:all} is specified, the fully qualified names of the files
    found are returned in {cmd:r(fn)}, listed one after the other, and
    each enclosed in quotes.  Thus when {cmd:all} is specified, if you
    later need to quote the returned list, you must use compound double
    quotes.  Also remember that {cmd:findfile} issues a file-not-found
    error if no files are found.  If you wish to suppress that and want
    {cmd:r(fn)} returned containing nothing, precede {cmd:findfile} with
    {helpb capture}.  Thus typical usage of {cmd:findfile, all} is

	    {cmd:capture findfile} {it:filename}{cmd:, all}
	    {cmd:local filelist `"`r(fn)'"'}


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:findfile} is not a utility to search everywhere for a file you have lost.
{cmd:findfile} is for use in those rare ado-files that use prerecorded
datasets and for which you wish to place the datasets along the ado-path,
along with the ado-file itself.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:findfile} stores the following in {cmd:r()}:

{synoptset 30 tabbed}{...}
{p2col 5 30 34 2: Macros}{p_end}
{synopt:{cmd:r(fn)} ({cmd:all} not specified)}name of the file found; name not enclosed in quotes{p_end}
{synopt:{space 8}({cmd:all} specified)}names of the files found, listed one after the other, each enclosed in quotes{p_end}
{p2colreset}{...}
