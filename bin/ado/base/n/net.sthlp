{smcl}
{* *! version 1.1.14  17may2019}{...}
{viewerdialog net "net from https://www.stata.com/"}{...}
{viewerdialog dir "ado dir"}{...}
{viewerdialog "ado find()" "ado_d"}{...}
{vieweralsosee "[R] net" "mansection R net"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ado update" "help ado update"}{...}
{vieweralsosee "[D] checksum" "help checksum"}{...}
{vieweralsosee "[R] net search" "help net_search"}{...}
{vieweralsosee "[R] netio" "help netio"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Syntax" "help net##syntax"}{...}
{viewerjumpto "Description" "help net##description"}{...}
{viewerjumpto "Links to PDF documentation" "help net##linkspdf"}{...}
{viewerjumpto "Options for net install and net get" "help net##options_net_install"}{...}
{viewerjumpto "Options for ado commands" "help net##options_ado"}{...}
{viewerjumpto "Examples" "help net##examples"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] net} {hline 2}}Install and manage community-contributed additions from the net{p_end}
{p2col:}({mansection R net:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Set current location for net

{p 8 19 2}{cmd:net} {cmd:from} {it:directory_or_url}{p_end}


{pstd}
Change to a different net directory

{p 8 19 2}{cmd:net} {cmd:cd} {it:path_or_url}{p_end}


{pstd}
Change to a different net site

{p 8 19 2}{cmd:net} {cmd:link} {it:linkname}{p_end}


{pstd}
Search for installed packages

        {cmd:net} {cmd:search}        (see {manhelp net_search R:net search})


{pstd}
Report current net location

{p 8 21 2}{cmd:net} 


{pstd}
Describe a package

{p 8 21 2}{cmd:net} {opt d:escribe} {it:pkgname}
		[{cmd:,} {opt fr:om(directory_or_url)}]


{pstd}
Set location where packages will be installed

{p 8 16 2}{cmd:net} {cmd:set} {cmd:ado} {it:dirname}{p_end}


{pstd}
Set location where ancillary files will be installed

{p 8 16 2}{cmd:net} {cmd:set} {cmd:other} {it:dirname}{p_end}


{pstd}
Report net 'from', 'ado', and 'other' settings

{p 8 16 2}{cmd:net} {opt q:uery}


{pstd}
Install ado-files and help files from a package

{p 8 20 2}{cmd:net} {opt ins:tall} {it:pkgname} [{cmd:, all replace force}
		{opt fr:om(directory_or_url)}]


{pstd}
Install ancillary files from a package

{p 8 20 2}{cmd:net} {cmd:get} {it:pkgname} [{cmd:, all replace force}
		{opt fr:om(directory_or_url)}]


{pstd}
Shortcut to access Stata Journal (SJ) net site

{p 8 20 2}{cmd:net} {cmd:sj} {it:vol}{cmd:-}{it:issue} [{it:insert}]{p_end}


{pstd}
Shortcut to access Stata Technical Bulletin (STB) net site

{p 8 20 2}{cmd:net} {cmd:stb} {it:issue} [{it:insert}]


{pstd}
List installed packages

{p 8 20 2}{cmd:ado} [{cmd:,} {opth f:ind(strings:string)} {opt fr:om(dirname)}]

{p 8 16 2}{cmd:ado} {cmd:dir} [{it:pkgid}]
           [{cmd:,} {opth f:ind(strings:string)} {opt fr:om(dirname)}]{p_end}


{pstd}
Describe installed packages

{p 8 21 2}{cmd:ado} {opt d:escribe} [{it:pkgid}]
[{cmd:,} {opth f:ind(strings:string)} {opt fr:om(dirname)}]{p_end}


{pstd}
Update installed packages

        {cmd:ado} {cmd:update}        (see {manhelp ado_update R:ado update})


{pstd}
Uninstall an installed package

{p 8 22 2}{cmd:ado} {opt uninstall} {it:pkgid}
[{cmd:,} {opt fr:om(dirname)}]{p_end}


    where
        {it:pkgname} is   name of a package
{p 8 23}{it:pkgid} {space 1} is {space 1} name of a package{p_end}
{p 16 23}or {space 1} a number in square brackets: {cmd:[}{it:#}{cmd:]}{p_end}
{p 8 23}{it:dirname} is {space 1} a directory name{p_end}
{p 16 23}or {space 1} {cmd:PLUS} {space 4} (default){p_end}
{p 16 23}or {space 1} {cmd:PERSONAL}{p_end}
{p 16 23}or {space 1} {cmd:SITE}


{marker description}{...}
{title:Description}

{pstd}
{cmd:net} downloads and installs additions to Stata.  The additions can be
obtained from the Internet or from physical media.  The additions can be
ado-files (new commands), help files, or even datasets.  Collections of files
that may be installed as a group are bound together into a
{mansection R netRemarksandexamplesDefinitionofapackage:package}.

{pstd}
{cmd:net from}
moves you to a location and displays the content page.

{pstd}
{cmd:net cd} and {cmd:net link}
change from your current location to other locations.
{cmd:net cd} enters subdirectories of
the original location.  {cmd:net link} jumps from one location to another,
depending on the code on the content page.

{pstd}
{cmd:net describe}
lists a package-description page.  Packages are named, and you type
{cmd:net describe} {it:pkgname}.

{pstd}
{cmd:net set}
controls where {cmd:net} installs files.  By default, {cmd:net}
installs in the {cmd:PLUS} directory (see {manhelp sysdir P}).
{cmd:net set ado SITE} would cause subsequent {cmd:net} commands to install in
the {cmd:SITE} directory.  {cmd:net set other} sets where ancillary files,
such as {cmd:.dta} files, are installed.  The default is the current
directory.

{pstd}
{cmd:net query}
displays the current {cmd:net from}, {cmd:net set ado}, and
{cmd:net set other} settings.

{pstd}
{cmd:net install}
installs a package into your copy of Stata.

{pstd}
{cmd:net get}
copies any additional files (ancillary files) to your current directory (or
location determined by {cmd:net set other}).

{pstd}
{cmd:net sj} and {cmd:net stb} simplify loading files from the
{it:{browse "https://www.stata-journal.com":Stata Journal}}
and its predecessor, the
{it:{browse "https://www.stata.com/products/stb/":Stata Technical Bulletin}}.

{phang2}{cmd:net sj} {it:vol}{cmd:-}{it:issue}

{pstd}
is a synonym for typing

{phang2}{cmd:net from https://www.stata-journal.com/software/sj}{it:vol}{cmd:-}{it:issue}

{pstd}
whereas

{phang2}{cmd:net sj} {it:vol}{cmd:-}{it:issue} {it:insert}

{pstd}
is a synonym for typing

{phang2}{cmd:net from https://www.stata-journal.com/software/sj}{it:vol}{cmd:-}{it:issue}{p_end}
	{cmd:net describe} {it:insert}

{pstd}
{cmd:ado} manages the packages you have installed by using {cmd:net}.  The
{cmd:ado} command lets you list and uninstall previously installed packages.

{pstd}
{cmd:ado dir} (same as typing {cmd:ado} without arguments)
lists the names and titles of the packages that you have installed.

{pstd}
{cmd:ado describe}
lists full package-description pages.

{pstd}
{cmd:ado uninstall}
removes packages from your computer.

{pstd}
Users can also access the {cmd:net} and {cmd:ado} features by selecting
{bf:Help > SJ and community-contributed commands}.

{pstd}
Details for those wishing to produce their own package files and download
sites are provided in {help usersite}, with more examples found in
{bind:{bf:[R] net}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R netRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_net_install}{...}
{title:Options for net install and net get}

{phang}
{opt all} typed with either {cmd:net install} or {cmd:net get} is equivalent
to typing {cmd:net install} followed by {cmd:net get}.

{phang}
{opt replace} specifies that the downloaded files replace existing files
if any of the files already exists.

{phang}
{opt force} specifies that the downloaded files replace existing files
if any of the files already exists, even if Stata thinks all the
files are the same.  {cmd:force} implies {cmd:replace}.

{phang}
{opt from(directory_or_url)},
when used with {cmd:net}, specifies the directory or URL where installable
packages may be found.  The directory or URL is the same as the one that would
have been specified with {cmd:net from}.


{marker options_ado}{...}
{title:Options for ado commands}

{phang}
{opth find:(strings:string)} specifies that the descriptions of the packages
installed on your computer be searched and that the package descriptions
containing {it:string} be listed.

{phang}
{opt from(dirname)} specifies where the packages are installed.  The default
is {cmd:from(PLUS)}.  {opt PLUS} is a codeword that Stata understands to
correspond to a particular directory that was set at
installation time.  On Windows computers, {opt PLUS} probably means the
directory {cmd:c:\ado\plus}, but it might mean something else.  You can find
out what it means by typing {helpb sysdir}, but doing so is irrelevant if you
use the defaults.


{marker examples}{...}
{title:Examples}

{pstd}
To view the main Stata net downloading content page, type{p_end}

{phang2}{cmd:. net from https://www.stata.com}

{pstd}
Type{p_end}

{p2colset 9 35 37 2}{...}
{p2col :{cmd:. net link sj}}to see main SJ page{p_end}
{p2col :{cmd:. net cd software}}to see main page for software associated with SJ articles{p_end}
{p2col :{cmd:. net cd sj6-3}}to then see the SJ volume 6, number 3 contents
page{p_end}
{p2col :{cmd:. net describe st0109}}to see a description of package st0109{p_end}
{p2col :{cmd:. net install st0109}}to install package st0109{p_end}
{p2col :{cmd:. net get st0109}}to obtain ancillary files for st0109{p_end}
{p2colreset}{...}

{pstd}
To see what you have installed, type{p_end}

{p2colset 9 35 37 2}{...}
{p2col :{cmd:. ado}}to list packages that you have installed{p_end}
{p2col :{cmd:. ado describe st0109}}to describe package st0109 that you
installed{p_end}
{p2col :{cmd:. ado, find("partial")}}to find packages by using keyword
search{p_end}
{p2col :{cmd:. ado uninstall st0109}}to uninstall package st0109{p_end}
{p2colreset}{...}
