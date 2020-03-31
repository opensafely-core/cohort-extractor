{smcl}
{* *! version 1.3.2  19oct2017}{...}
{vieweralsosee "[P] viewsource" "mansection P viewsource"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] copysource" "help copysource"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[R] view" "help view"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "viewsource##syntax"}{...}
{viewerjumpto "Description" "viewsource##description"}{...}
{viewerjumpto "Links to PDF documentation" "viewsource##linkspdf"}{...}
{viewerjumpto "Remarks" "viewsource##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] viewsource} {hline 2}}View source code
{p_end}
{p2col:}({mansection P viewsource:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
{cmd:viewsource} 
{it:{help filename}}


{marker description}{...}
{title:Description}

{pstd}
{cmd:viewsource} searches for {it:{help filename}} along the
{help sysdir:ado-path}
and displays the file in the Viewer.  No default file extension is provided;
if you want to see, for example, {cmd:kappa.ado}, type {cmd:viewsource}
{cmd:kappa.ado}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P viewsourceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Say that you wish to look at the source for {helpb ml}.  You know that
{cmd:ml} is an ado-file, and therefore the filename is {cmd:ml.ado}.  You type

	. {cmd:viewsource ml.ado}

{pstd}
{helpb program} is not implemented as an ado-file:

	. {cmd:viewsource program.ado}
	{err:file "program.ado" not found}
	r(601);

{pstd}
By the way, you can find out where the file is stored by typing 

	. {cmd:findfile ml.ado}
	C:\Program Files\Stata16\ado\base/m/ml.ado

{phang}
See {manhelp findfile P}.

{pstd}
{cmd:viewsource} is not limited to displaying ado-files.  If you wish to see,
for example, {cmd:panelsetup.mata}, type

	. {cmd:viewsource panelsetup.mata}
