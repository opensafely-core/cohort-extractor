{smcl}
{* *! version 1.2.13  12feb2019}{...}
{vieweralsosee "[R] ssc" "mansection R ssc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ado update" "help ado update"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{viewerjumpto "Syntax" "ssc##syntax"}{...}
{viewerjumpto "Description" "ssc##description"}{...}
{viewerjumpto "Links to PDF documentation" "ssc##linkspdf"}{...}
{viewerjumpto "Command overview" "ssc##overview"}{...}
{viewerjumpto "Options for use with ssc new" "ssc##options_ssc_new"}{...}
{viewerjumpto "Options for use with ssc hot" "ssc##options_ssc_hot"}{...}
{viewerjumpto "Option for use with ssc describe" "ssc##option_ssc_describe"}{...}
{viewerjumpto "Options for use with ssc install" "ssc##options_ssc_install"}{...}
{viewerjumpto "Option for use with ssc type" "ssc##option_ssc_type"}{...}
{viewerjumpto "Options for use with ssc copy" "ssc##options_ssc_copy"}{...}
{viewerjumpto "Remarks" "ssc##remarks"}{...}
{viewerjumpto "Examples" "ssc##examples"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] ssc} {hline 2}}Install and uninstall packages from SSC{p_end}
{p2col:}({mansection R ssc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Summary of packages most recently added or updated at SSC

{p 8 12 2}
{cmd:ssc}
{cmd:new}
[{cmd:,}
{opt sav:ing}{cmd:(}{it:{help filename}}[{cmd:,} {opt replace}]{cmd:)}
{opt type}]


{phang}
Summary of most popular packages at SSC

{p 8 12 2}
{cmd:ssc}
{cmd:hot}
[{cmd:,}
{cmd:n(}{it:#}{cmd:)}
{cmdab:auth:or}{cmd:(}{it:name}{cmd:)}]



{phang}
Describe a specified package at SSC

{p 8 12 2}
{cmd:ssc}
{opt d:escribe}
{c -(} {it:pkgname} | {it:letter} {c )-}
[{cmd:,}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)}]



{phang}
Install a specified package from SSC

{p 8 12 2}
{cmd:ssc}
{opt inst:all}
{it:pkgname}
[{cmd:,}
{opt all}
{opt replace}]


{phang}
Uninstall from your computer a previously installed package from SSC

{p 8 12 2}
{cmd:ssc}
{opt uninstall}
{it:pkgname}


{phang}
Type a specific file stored at SSC

{p 8 12 2}
{cmd:ssc}
{opt type}
{it:{help filename}}
[{cmd:, asis}]


{phang}
Copy a specific file from SSC to your computer

{p 8 12 2}
{cmd:ssc}
{opt copy}
{it:{help filename}}
[{cmd:,}
{opt pl:us}
{opt p:ersonal}
{opt replace}
{opt pub:lic}
{opt bin:ary}]


{p 4 6 2}
where {it:letter} in {opt ssc describe} is {opt a}-{opt z} or {opt _}.


{marker description}{...}
{title:Description}

{pstd}
{opt ssc} works with packages (and files) from the Statistical Software
Components (SSC) archive, which is often called the Boston College Archive and
is provided by {browse "http://www.repec.org"}.

{pstd}
The SSC has become the premier Stata download site for community-contributed
software on the web.  {opt ssc} provides a convenient interface to the
resources available there.  For example, on
{browse "http://www.statalist.org/":Statalist}, users will often
write

{p 8 8 4}
The program can be found by typing {cmd:ssc install newprogramname}.

{pstd}
Typing that would load everything associated with {cmd:newprogramname},
including the help files.

{pstd}
If you are searching for what is available, 
type {cmd:ssc} {cmd:new} and {cmd:ssc} {cmd:hot}, and
see {manhelp search R}.
{opt search} searches the SSC and other places, too.
{cmd:search}
provides a GUI interface from which programs can be
installed, including the programs at the SSC archive.

{pstd}
You can uninstall particular packages by using {cmd:ssc} {cmd:uninstall}.
For the packages that you keep, 
see {helpb ado update:[R] ado update}
for an automated way of keeping those packages up to date.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R sscQuickstart:Quick start}

        {mansection R sscRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker overview}{...}
{title:Command overview}

{phang}
{opt ssc new} summarizes the packages made available or
    updated recently.   Output is presented in the Stata Viewer, and from
    there you may click to find out more about individual packages or 
    to install them.

{phang}
{opt ssc hot} 
    lists the most popular packages -- popular based on a moving 
    average of the number of downloads in the past three months.
    By default, 10 packages are listed.

{phang}
{opt ssc describe} {it:pkgname} describes, but does not install, the specified
    package.  Use {cmd:search} to find packages; see {manhelp search R}.  If
    you know the package name but do not know the exact spelling, type
    {opt ssc describe} followed by one letter, {opt a}-{opt z} or {opt _}
    (underscore), to list all the packages starting with that letter.

{phang}
{opt ssc install} {it:pkgname} installs the specified package.  You do not
    have to describe a package before installing it.  (You may also
    install a package by using {cmd:net} {cmd:install}; see {manhelp net R}.)

{phang}
{opt ssc uninstall} {it:pkgname} removes the previously installed
    package from your computer.  It does not matter how the package was
    installed.  ({opt ssc uninstall} is a synonym for {opt ado uninstall}, so
    either may be used to uninstall any package.)

{phang}
{opt ssc type} {it:{help filename}} types a specific file stored at SSC.
    {opt ssc cat} is a synonym for {opt ssc type}, which may appeal to those
    familiar with Unix.

{phang}
{opt ssc copy} {it:filename} copies a specific file stored at SSC to your
    computer.  By default, the file is copied to the current directory, but
    you can use options to change this.  {opt ssc copy} is a rarely used
    alternative to {opt ssc install} ...{cmd:, all}.  {opt ssc cp} is a
    synonym for {opt ssc copy}.


{marker options_ssc_new}{...}
{title:Options for use with ssc new}

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} specifies that the
    "what's new" summary be saved in {it:filename}.  If {it:filename} is
    specified without a suffix, {it:filename}{cmd:.smcl} is assumed.  If
    {opt saving()} is not specified, {cmd:saving(ssc_result.smcl)} is assumed.

{phang}
{opt type} specifies that the "what's new" results be displayed in the
    Results window rather than in the Viewer.


{marker options_ssc_hot}{...}
{title:Options for use with ssc hot}

{phang}
{cmd:n(}{it:#}{cmd:)} 
    specifies the number of packages to list; {cmd:n(10)} is the default.
    Specify {cmd:n(.)} to list all packages in order of popularity.

{phang}
{cmd:author(}{it:name}{cmd:)} 
     lists the 10 most popular packages by the specified author.
     If {cmd:n(}{it:#}{cmd:)} is also specified, the top {it:#} 
     packages are listed.


{marker option_ssc_describe}{...}
{title:Option for use with ssc describe}

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} specifies that, in
     addition to the description's being displayed on your screen, it be saved
     in the specified file.

{pmore}
    If {it:filename} is specified without an extension, {opt .smcl} will be
    assumed, and the file will be saved as a {help smcl:SMCL} file.

{pmore}
    If {it:filename} is specified with an extension, no default extension
    is added.  If the extension is {opt .log}, the file will be stored as
    a text file.

{pmore}
    If {opt replace} is specified, {it:filename} is replaced if it already
    exists.


{marker options_ssc_install}{...}
{title:Options for use with ssc install}

{phang}
{opt all} specifies that any ancillary files associated with the
    package be downloaded to your current directory, in addition
    to the program and help files being installed.  Ancillary files are files
    that do not end in {opt .ado} or {opt .sthlp} and typically contain
    datasets or examples of the use of the new command.

{pmore}
    You can find out which files are associated with the package by typing
    {cmd:ssc describe} {it:pkgname} before or after installing.  If you
    install without using the {opt all} option and then want the ancillary
    files, you can {opt ssc install} again.

{phang}
{opt replace} specifies that any files being downloaded that already exist
    on your computer be replaced by the downloaded files.  If
    {opt replace} is not specified and any files already exist, none of the
    files from the package is downloaded or installed.

{pmore}
    It is better not to specify the {opt replace} option and wait to see if
    there is a problem.  If there is a problem, it is usually better to
    uninstall the old package by using {opt ssc uninstall} or
    {opt ado uninstall} (which are, in fact, the same command).


{marker option_ssc_type}{...}
{title:Option for use with ssc type}

{phang}
{opt asis} affects how files with the suffixes {cmd:.smcl} 
    and {cmd:.sthlp} are displayed.  The default is to interpret SMCL
    directives the file might contain.  {cmd:asis} specifies that the file be
    displayed in raw, uninterpreted form.


{marker options_ssc_copy}{...}
{title:Options for use with ssc copy}

{phang}
{opt plus} specifies that the
    file be copied to the {cmd:PLUS} directory, the directory where
    community-contributed additions are installed.  Typing {helpb sysdir}
    will display the identity of the {cmd:PLUS} directory on your computer.

{phang}
{opt personal} specifies that the file be copied to your {cmd:PERSONAL}
    directory as reported by {helpb sysdir}.

{pmore}
    If neither {opt plus} nor {opt personal} is specified,
    the default is to copy the file to the current directory.

{phang}
{opt replace} specifies that, if the file already exists on your computer,
    the new file replace it.

{phang}
{opt public} specifies that the new file be made readable by everyone;
    otherwise, the file will be created according to the default permission you
    have set with your operating system.

{phang}
{opt binary} specifies that the file being copied is a binary file and that it
    is to be copied as is.  The default is to assume that the file is a text
    file and change the end-of-line characters to those appropriate for your
    computer/operating system.


{marker remarks}{...}
{title:Remarks}

{pstd}
Users can add new features to Stata, and some users choose to make new features
that they have written available to others via the web.  The files that
comprise a new feature are called a package, and a package usually consists of
one or more ado-files and help files.  The {helpb net} command makes it
reasonably easy to install and uninstall packages regardless of where
they are on the web.  One site, the SSC, has become particularly
popular as a repository for additions to Stata.  Command {cmd:ssc} is an
easier to use version of {cmd:net} designed especially for the SSC.

{pstd}
Many packages are available at the SSC.  Packages are named, such as
{hi:oaxaca}, {hi:estout}, or {hi:egenmore}.  At SSC, capitalization is not
significant, so {hi:Oaxaca}, {hi:ESTOUT}, and {hi:EGENmore} are
ways of writing the same package names.

{pstd}
When you type

	{cmd:. ssc install oaxaca}

{pstd}
the files associated with the package are downloaded and
installed on your computer.  Package names usually correspond to the names of
the commands being added to Stata, so one would expect that installing the
package {hi:oaxaca} will add command {cmd:oaxaca} to Stata on your
computer, and expect that typing {cmd:help oaxaca} will provide the
documentation.  That is the situation here, but that is not
always so.  Before or after installing a package, type {cmd:ssc describe}
{it:pkgname} to obtain the details.


{marker examples}{...}
{title:Examples}

{pstd}Describe most recently added or updated packages at SSC{p_end}
{phang2}{cmd:. ssc new}

{pstd}Describe the most popular packages at SSC{p_end}
{phang2}{cmd:. ssc hot}

{pstd}Describe the package {cmd:oaxaca}{p_end}
{phang2}{cmd:. ssc describe oaxaca}

{pstd}Describe the package {cmd:oaxaca} and save the description to the
file {cmd:oaxaca.log}{p_end}
{phang2}{cmd:. ssc describe oaxaca, saving(oaxaca.log)}

{pstd}List all packages, along with a brief description, that begin with the
letter {cmd:o}{p_end}
{phang2}{cmd:. ssc describe o}

{pstd}Same as above, but also save the listing to the file {cmd:o.index}{p_end}
{phang2}{cmd:. ssc describe o, saving(o.index)}

{pstd}Install package {cmd:oaxaca}{p_end}
{phang2}{cmd:. ssc install oaxaca}

{pstd}Uninstall previously installed package {cmd:oaxaca}{p_end}
{phang2}{cmd:. ssc uninstall oaxaca}

{pstd}Type file {cmd:whitetst.hlp} that is stored at SSC{p_end}
{phang2}{cmd:. ssc type whitetst.hlp}

{pstd}Copy file {cmd:whitetst.ado} from SSC to your computer{p_end}
{phang2}{cmd:. ssc copy whitetst.ado}{p_end}
