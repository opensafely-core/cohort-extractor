{smcl}
{* *! version 1.2.13  01apr2019}{...}
{vieweralsosee "[R] net" "mansection R net"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] checksum" "help checksum"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Creating your own site" "usersite##own_site"}{...}
{viewerjumpto "Remarks" "usersite##remarks"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] net} {hline 2}}Install and manage community-contributed additions from the net{p_end}
{p2col:}({mansection R net:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker own_site}{...}
{title:Creating your own site}

{pstd}
Below we provide instructions on how to create your own site to distribute
do-files, ado-files, help files, datasets, ... that other users can fetch
using the {helpb net} command.  Also see {manlink R net} for examples.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{hi:{help usersite##intro:Introduction}}
	{hi:{help usersite##remarks1:1.  Place the files on your homepage}}
	{hi:{help usersite##remarks2:2.  Make a site}}
	{hi:{help usersite##remarks3:3.  Make a package}}
	{hi:{help usersite##remarks4:4.  Improve your site}}
	{hi:{help usersite##remarks5:Types of files you can deliver}}
	{hi:{help usersite##remarks6:The full details of package files}}
	{hi:{help usersite##remarks7:The full details of content files}}
	{hi:{help usersite##remarks8:SMCL in content and package-description files}}
	{hi:{help usersite##remarks9:Error-free file delivery}}


{marker intro}{...}
{title:Introduction}

{pstd}
If you have not tried {cmd:net}, do that first.  From the command line, type

	{cmd:. net}

{pstd}
or pull down {hi:Help} and choose {hi:SJ and community-contributed commands}.

{pstd}
Additions to Stata are available from Stata and from other users.  This
help file provides the information necessary for constructing a site to
provide additions to Stata.

{pstd}
To do this, you must have access to a homepage on the World Wide Web.
Let's pretend that your home page is {hi:http://www.zzz.edu/users/~me}, and
you wish to make the following files available:

	myprog.ado
	myprog.sthlp
	mydata.dta

{pstd}
Basically, you can place these files in the directory containing your home
page, and Stata can access them.  By adding a few more files, you can make
accessing them easier.  The files do not interfere with the normal operation
of HTML pages.


{marker remarks1}{...}
{title:1.  Place the files on your homepage}

{pstd}
Copy the files to the directory containing your home page.  After that,
users all over the world can access them from inside Stata by simply typing

	{cmd:. copy  http://www.zzz.edu/users/~me/myprog.ado  myprog.ado}
	{cmd:. copy  http://www.zzz.edu/users/~me/myprog.sthlp  myprog.sthlp}
	{cmd:. copy  http://www.zzz.edu/users/~me/mydata.dta  mydata.dta}

{pstd}
Users would still need to "install" (copy) {cmd:myprog.ado} and
{cmd:myprog.sthlp} to the appropriate place.

{pstd}
The dataset would, of course, be ready to use.  Actually, the dataset need
not even be copied down by users; they could use it directly by typing

	{cmd:. use http://www.zzz.edu/users/~me/mydata.dta, clear}


{marker remarks2}{...}
{title:2.  Make a site}

{pstd}
Stata's {cmd:net} command and corresponding pulldown is the way users want
to fetch your materials.  Right now, that will not work with your site:

	{cmd:. net from http://www.zzz.edu/users/~me}
	{err}file from http://www.zzz.edu/users/~me not found
	http://www.zzz.edu/users/~me/ either
	  1)  is not a valid URL, or
	  2)  could not be contacted, or
	  3)  is not a Stata download site (has no stata.toc file).{txt}
	{search r(601):r(601);}

{pstd}
To make a download site, create another new file, {cmd:stata.toc}, on your
home page.

{pstd}
If you leave {cmd:stata.toc} empty, the following will happen when someone
links to your site:

	{cmd:. net from http://www.zzz.edu/users/~me}

	{hline 60}
	http://www.zzz.edu/users/~me
	{hi:(no title)}
	{hline 60}
{p 8 8 12}This site provides additions and other materials for use with Stata
	but provides no table of contents.  No doubt you have a memo from
	somebody telling you what you can {hi:net install} and {hi:net get}.
	{p_end}
	{hline 60}

{pstd}
It is the presence of this file that tells Stata that your URL provides
Stata materials as well as HTML pages.

{pstd}
We will discuss making a pretty site shortly.


{marker remarks3}{...}
{title:3.  Make a package}

{pstd}
A package is a collection of files; the files

	myprog.ado
	myprog.sthlp
	mydata.dta

{pstd}
form a package.  A package file lists the files in a package.  Package files
end in the suffix {cmd:.pkg}.  If you created {cmd:myprog.pkg} describing the
above three files, users could type

	{cmd:. net from http://www.zzz.edu/users/~me/}
	<output omitted>

	{cmd:. net describe myprog}
	{hline 60}
	package {hi:myprog} from http://www.zzz.edu/users/~me
	{hline 60}

	{hi:TITLE}
	    myprog.  Package to analyze data.

	{hi:DESCRIPTION/AUTHORS}
	    Program by me.
	    Other lines describing the package could appear here.

	{hi:INSTALLATION FILES}                 (type {hi:net install myprog})
	    myprog.ado
	    myprog.sthlp

	{hi:ANCILLARY FILES}                    (type {hi:net get myprog})
	    mydata.dta
	{hline 60}

{pstd}
and, if they wanted to install your package, they could type

	{cmd:. net install myprog}

{pstd}
The package file that would cause all this to happen is

	{hline 3} BEGIN {hline 3} myprog.pkg {hline 35}
	{cmd:v 3}
	{cmd:d myprog.  Package to analyze data.}
	{cmd:d Program by me.}
	{cmd:d Other lines describing the package could appear here.}

	{cmd:* I can also insert comments; these will not be displayed.}
	{cmd:* f lines name the files that comprise your package:}

	{cmd:f myprog.ado}
	{cmd:f myprog.sthlp}
	{cmd:f mydata.dta}
	{hline 3} END {hline 5} myprog.pkg {hline 35}

{pstd}
This file does not look like much, but looks pretty when the user asks
Stata about it.


{marker remarks4}{...}
{title:4.  Improve your site}

{pstd}
The problem now is that nobody knows to type "{cmd:net install myprog}"
unless you tell them.  Go back and change your {cmd:stata.toc} file:


	{hline 3} BEGIN {hline 3} stata.toc {hline 36}
	{cmd:v 3}
	{cmd:d Materials by me}

	{cmd:d Here are some useful things I have written}

	{cmd:p myprog A program to analyze data}
	{hline 3} END {hline 5} stata.toc {hline 36}

{pstd}
Now when users type,

	{cmd:. net from http://www.zzz.edu/users/~me/}

	{hline 60}
	http://www.zzz.edu/users/~me/
	{hi:Materials by me}
	{hline 60}

	Here are some useful things I have written

	PACKAGES you could -{hi:net describe}-
	    {hi:myprog}          A program to analyze data
	{hline 60}

{pstd}
they will see what you have to offer.


{marker remarks5}{...}
{title:Types of files you can deliver}

{pstd}
Most packages contain ado-files and help files and, sometimes, a dataset that
is used for demonstration purposes.  By default, the ado-files and help files
are installed and the data file is made available to the user should he or she
wish to load it.

{pstd}
Stata determines whether a file is installable or is instead simply ancillary
based on its suffix.  The following filetypes are automatically installed:

	File suffix{col 30}Description
	{hline 62}
	{cmd:.ado}{...}
{col 30}executable code
	{cmd:.class}{...}
{col 30}executable code
	{cmd:.sthlp}{...}
{col 30}explanation to be displayed by {cmd:help}
	{cmd:.key}{...}
{col 30}keyword information to be used by {cmd:search}
	{cmd:.mnu}{...}
{col 30}contents of menu
	{cmd:.dlg}{...}
{col 30}code describing dialog box
	{cmd:.idlg}{...}
{col 30}include file sometimes used by {cmd:.dlg} files
	{cmd:.jar}{...}
{col 30}Java archive package file
	{cmd:.mata}{...}
{col 30}Mata source code
	{cmd:.mlib}{...}
{col 30}Mata function library
	{cmd:.mo}{...}
{col 30}Mata object file (compiled code for one function)
	{cmd:.plugin}{...}
{col 30}executable plugin sometimes called by {cmd:.ado} files
	{cmd:.py}{...}
{col 30}Python code
	{cmd:.scheme}{...}
{col 30}graphics scheme used by {cmd:graph}
	{cmd:.stbcal}{...}
{col 30}business calendar
	{cmd:.style}{...}
{col 30}graphics style used by {cmd:graph}
	{hline 62}

{pstd}
In addition, you can force other filetypes to be installed rather than
categorized as ancillary by coding {cmd:F} rather than {cmd:f} in the
package file.  This is sometimes done with {cmd:.dta} datasets that are
used by the ado-files.


{marker remarks6}{...}
{title:The full details of package files}

    {cmd:v 3} line:
{p 8 8 2}{cmd:v} indicates version -- specify {cmd:v 3}; old-style pkg files do
not have this.

    blank lines:
{p 8 8 2}Put in as many as you wish; they are ignored.

    {cmd:*} lines:
{p 8 12 2}Lines starting with {cmd:*} are comment lines.{p_end}
{p 8 12 2}They are also ignored.

    {cmd:d} lines:
{p 8 12 2}Lines starting with {cmd:d} are description lines.{p_end}
{p 8 12 2}The first {cmd:d} line is considered the title.{p_end}
{p 8 12 2}Subsequent {cmd:d} lines are considered to be the description text.{p_end}
{p 8 12 2}You may code {cmd:d} followed by nothing to display a blank line.

    {cmd:f} lines:
{p 8 8 2}Lines starting with {cmd:f} name the files that the package is to
provide.  The syntax is

{p 16 35 2}First type {space 7} {cmd:f}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} the name of a file

{pmore}For instance, you might code

		{cmd:f myprog.ado}
		{cmd:f myprog.sthlp}
		{cmd:f myprog.dta}

{pmore}or you might organize your files into subdirectories:

		{cmd:f myprog/myprog.ado}
		{cmd:f myprog/myprog.sthlp}
		{cmd:f myprog/myprog.dta}

    {cmd:F} lines:
{p 8 8 2}Lines starting with {cmd:F} are a variation on {cmd:f} lines.  The
difference is that, when the file is installed, it will be copied to the
system directories (and not the current directory) in all cases.

{pmore}With {cmd:f} lines, the determination on where the file is to be
installed is made on the basis of the file's suffix.  For instance, xyz.ado
would be installed in the system directories whereas xyz.dta would be
installed in the current directory.

{pmore}Coding "{cmd:F xyz.ado}" would have the same result as
"{cmd:f xyz.ado}".  Coding "{cmd:F xyz.dta}", however, would state xyz.dta is
to be installed in the system directories.

    {cmd:g} lines:
{pmore}Lines starting with {cmd:g} are also a variation of {cmd:f} lines.
The syntax is

{p 16 35 2}First type {space 7} {cmd:g}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}then type {space 8} a {it:platformname}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} the name of a file

{pmore}{cmd:g} specifies that the file be installed only if the user's
computer is of type {it:platformname}; otherwise, the file is ignored.  
The platform names are 
{cmd:WIN64} (64-bit x86-64)
for Windows;
{cmd:MACINTEL64} (64-bit Intel, GUI) and
{cmd:OSX.X8664} (64-bit Intel, console)
for Mac; and
{cmd:LINUX64} (64-bit x86-64)
for Unix.

{pmore}Additionally, a second filename may be specified.  In this case, the
first filename is the name of the file on the server (the file to be copied),
and the second filename is to be the name of the file on the user's system.
For example, you might code

		{cmd:g WIN64 mydll.forwin mydll.plugin}
		{cmd:g LINUX64 mydll.forlinux mydll.plugin}

{pmore}When you specify one filename, the result is the same as specifying
two identical filenames.

    {cmd:G} lines:
{pmore}{cmd:G} is a variation on {cmd:g} in the same way that {cmd:F} is a
variation of {cmd:f}.  The file, if not ignored, is to be installed in the
system directories.

    {cmd:h} lines:
{pmore}Lines beginning with {cmd:h} are used to indicate that a file must
be loaded or else the entire package is not to be installed.  The syntax is

{p 16 35 2}First type {space 7} {cmd:h}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} the name of a file

{pmore}For instance, you might code

		{cmd:G WIN64 mydll.forwin mydll.plugin}
		{cmd:G LINUX64 mydll.forlinux mydll.plugin}
		{cmd:h mydll.plugin}

{pmore}if you were offering the plugin mydll.plugin for Windows and Linux
only.

    {cmd:e} lines:
{p 8 12 2}A line starting with {cmd:e} means stop reading input from the file.{p_end}
{p 8 12 2}An {cmd:e} line is optional.


{marker remarks7}{...}
{title:The full details of content files}

    {cmd:v 3} line:
{pmore}{cmd:v} indicates version -- specify {cmd:v 3}; old-style pkg files do
not have this.

    blank lines:
{pmore}Put in as many as you wish; they are ignored.

    {cmd:*} lines:
{phang2}Lines starting with {cmd:*} are comment lines.{p_end}
{phang2}They are also ignored.

    {cmd:d} lines:
{phang2}Lines starting with {cmd:d} are description lines.{p_end}
{phang2}The first {cmd:d} line is considered the title.{p_end}
{phang2}Subsequent {cmd:d} lines are considered to be the description text.{p_end}
{phang2}You may code {cmd:d} followed by nothing to display a blank line.

    {cmd:t} lines:
{pmore}Lines starting with {cmd:t} are links to other subdirectories
containing other stata.toc lines.  The syntax is

{p 16 35 2}First type {space 7} {cmd:t}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}then type {space 8} the name of the subdirectory{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} any description you wish

{pmore}For instance, you might code:

		{cmd:t stats Statistics programs I have written}
		{cmd:t dm    Data management programs}

{pmore}To understand what this does, pretend X is the directory containing
your home page.  Then directory X/stats contains another stata.toc file, and
presumably other things, and directory X/dm contains a stata.toc file along
with its associated pieces.

{pmore}The idea here is to nest pieces into categories if you have a large
site.

    {cmd:l} lines
{pmore}Lines starting with {cmd:l} are links to other sites or links to other
places on your site that are not just subdirectories.  The syntax is

{p 16 35 2}First type {space 7} {cmd:l}  (lowercase letter ell){p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}then type {space 8} a short name of your choosing{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}then type {space 8} the full URL of the link{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} any description you wish

{pmore}For instance, you could include a link to StataCorp by coding

		{cmd:l stata http://www.stata.com StataCorp}

    {cmd:p} lines
{pmore}Lines starting with {cmd:p} describe a package or, more technically,
plant a link to a package file.  The syntax is

{p 16 35 2}First type {space 7} {cmd:p}{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}next type {space 8} the name of the .pkg file{p_end}
{p 16 35 2}next type {space 8} one or more blanks{p_end}
{p 16 35 2}finally type {space 5} any description you wish

	For example,

		{cmd:p xyregression xyreg.pkg XY-style regression}
	or
		{cmd:p xyregression xyreg XY-style regression}

{phang2}Stata will understand xyreg to mean xyreg.pkg.{p_end}
{phang2}Package files must be in the same directory as the contents file.{p_end}
{phang2}Do NOT code "f xyregression xyreg/xyreg.pkg XY-style regression"


{marker remarks8}{...}
{title:SMCL in content and package-description files}

{pstd}
The text listed on the second and subsequent {cmd:d} lines in both stata.toc
and {it:pkgname}.pkg may contain SMCL as long as you include {cmd:v 3}
(or {cmd:v 2}); see {manhelp smcl P}.


{marker remarks9}{...}
{title:Error-free file delivery}

{pstd}
Most people transport files over the Internet and never worry about the
file being corrupted in the process.  They do that because corruption rarely
occurs.  If, however, it is of great importance to you that the files be
delivered perfectly or not at all, you can include checksum files in the
directory.

{pstd}
For instance, say that included in your package is {hi:big.dta} and it is
of great importance that it be sent perfectly.  First use Stata to make the
checksum file for {hi:big.dta}:

	{cmd:. checksum big.dta, save}

{pstd}
That creates a small file called {hi:big.sum}; see {manhelp checksum D}.
Then copy both {hi:big.dta} and {hi:big.sum} to your homepage.  That is all
there is to do.  Stata will now automatically verify that when {hi:big.dta}
is copied it is copied without error.

{pstd}
Whenever you change {hi:big.dta} remember to also create a new
{hi:big.sum}.
{p_end}
