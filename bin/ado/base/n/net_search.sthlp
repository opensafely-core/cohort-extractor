{smcl}
{* *! version 1.0.1  12feb2019}{...}
{viewerdialog "net search" "net_d"}{...}
{vieweralsosee "[R] net search" "mansection R netsearch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ado update" "help ado update"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Syntax" "help net_search##syntax"}{...}
{viewerjumpto "Description" "help net_search##description"}{...}
{viewerjumpto "Links to PDF documentation" "help net_search##linkspdf"}{...}
{viewerjumpto "Options" "help net_search##options_net_search"}{...}
{viewerjumpto "Examples" "help net_search##examples"}{...}
{p2colset 1 19 14 2}{...}
{p2col:{bf:[R] net search} {hline 2}}Search Internet for installable packages{p_end}
{p2col:}({mansection R netsearch:View complete PDF manual entry}){p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:net} {cmd:search} {it:word} [{it:word} {it:...}]
		[{cmd:,} {it:{help net_search##search_options:options}}]

{synoptset 16}{...}
{marker search_options}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt or}}list packages that contain any of the keywords; default is all{p_end}
{synopt :{opt nosj}}search non-SJ and non-STB sources{p_end}
{synopt :{opt tocpkg}}search both tables of contents and packages; the default{p_end}
{synopt :{opt toc}}search table of contents only{p_end}
{synopt :{opt pkg}}search packages only{p_end}
{synopt :{opt e:verywhere}}search packages for match{p_end}
{synopt :{opt f:ilenames}}search filenames associated with package for match{p_end}
{synopt :{opt errnone}}make return code 111 instead of 0 when no matches found{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:net search} searches the Internet for community-contributed additions to
Stata, including, but not limited to, community-contributed additions
published in the
{browse "http://www.stata-journal.com":{it:Stata Journal}} (SJ) and in the
{browse "http://www.stata.com/products/stb/":{it:Stata Technical Bulletin}}
(STB).  {cmd:net search} lists the available additions that contain the
specified keywords.

{pstd}
The community-contributed materials found are available for immediate download
by using the {cmd:net} command or by clicking on the link.

{pstd}
In addition to typing {cmd:net search}, you may select
{bf:Help > Search...} and choose {bf:Search net resources}.
This is the recommended way to search for community-contributed additions to
Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R netsearchRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_net_search}{...}
{title:Options}

{phang}
{opt or} is relevant only when multiple keywords are specified.  By default,
{cmd:net search} lists
only packages that include all the keywords.  {opt or} changes the command
to list packages that contain any of the keywords.

{phang}
{opt nosj} specifies that {cmd:net search} not list matches that were published in the Stata Journal or in the Stata Technical Bulletin.

{phang}
{opt tocpkg}, {opt toc}, and {opt pkg} determine what is searched.  
{opt tocpkg} is the default, meaning that both tables of contents (tocs) and
packages (pkgs) are searched.  {opt toc} restricts the search to tables of
contents.  {opt pkg} restricts the search to packages.

{phang}
{opt everywhere} and {opt filenames} determine where in packages 
{cmd:net search} looks for {it:keywords}.  The default is {opt everywhere}.
{opt filename} restricts {cmd:net search} to search for matches only in the
filenames associated with a package.  Specifying {opt everywhere} implies 
{opt pkg}.

{phang}
{opt errnone} is a programmer's option that causes the return code to be 111
instead of 0 when no matches are found.


{marker examples}{...}
{title:Examples}

{pstd}
To search the net for what is available about "random effects", type{p_end}
{phang2}{cmd:. net search random effect}{p_end}

{pstd}
To search the net for what is available about "random effects" only
within the {it:Stata Journal}, type{p_end}
{phang2}{cmd:. net search random effect, sj}{p_end}
