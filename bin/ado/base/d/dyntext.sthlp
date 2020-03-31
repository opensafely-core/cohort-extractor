{smcl}
{* *! version 1.2.0  08may2019}{...}
{vieweralsosee "[RPT] dyntext" "mansection RPT dyntext"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] Dynamic documents intro" "help dynamic documents intro"}{...}
{vieweralsosee "[RPT] Dynamic tags" "help dynamic tags"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{viewerjumpto "Syntax" "dyntext##syntax"}{...}
{viewerjumpto "Description" "dyntext##description"}{...}
{viewerjumpto "Links to PDF documentation" "dyntext##linkspdf"}{...}
{viewerjumpto "Options" "dyntext##options"}{...}
{viewerjumpto "Remarks" "dyntext##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[RPT] dyntext} {hline 2}}Process Stata dynamic tags in text file{p_end}
{p2col:}({mansection RPT dyntext:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:dyntext} {it:srcfile} [{it:arguments}]{cmd:,}
{opth sav:ing(filename:targetfile)}
[{it:options}]

{phang}
{it:srcfile} is a plain text file containing
{help dynamic tags:Stata dynamic tags}.  {it:srcfile} and {it:targetfile} may
be any text format ({cmd:.txt}, {cmd:.html}, {cmd:.do}).

{phang}
{it:arguments} are stored in the local macros {cmd:`1'}, {cmd:`2'}, and so
on for use in {it:srcfile}; see {findalias frarg}.

{phang}
You may enclose {it:srcfile} and {it:targetfile} in double quotes and
must do so if they contain blanks or other special characters.


{marker dyntext_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opth sav:ing(filename:targetfile)}}specify the target file to
be saved{p_end}
{synopt :{opt rep:lace}}replaces the target file if it already exists{p_end}
{synopt :{opt norem:ove}}do not process {cmd:<<dd_remove>>} and
{cmd:<</dd_remove>>} {help dynamic tags:dynamic tags}{p_end}
{synopt :{cmd:nostop}}do not stop when an error occurs{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt saving(targetfile)} is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:dyntext} converts a dynamic text file -- a file containing both plain
text and Stata commands -- to an output file in text format.  Stata processes
the Stata dynamic tags (see {helpb dynamic tags:[RPT] Dynamic tags}) in the
dynamic text file and creates the output text file.

{pstd}
If you want to convert a dynamic text file to an HTML or Word ({cmd:.docx})
document, see {manhelp dyndoc RPT}.  If you want to convert a Markdown
document to an HTML or Word document, see {manhelp markdown RPT}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT dyntextQuickstart:Quick start}
        {mansection RPT dyntextRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang} 
{opth saving:(filename:targetfile)} specifies the target file to be saved.
{cmd:saving()} is required.

{phang}
{opt replace} specifies that the target file be replaced if it already
exists.

{phang}
{opt noremove} specifies that {cmd:<<dd_remove>>} and {cmd:<</dd_remove>>}
tags not be processed.  

{phang}
{opt nostop} allows the document to continue being processed even if an error
occurs.  By default, {cmd:dyntext} stops processing the document if an error
occurs. The error can be caused either by a malformed dynamic tag or by
executing Stata code within the tag.  


{marker remarks}{...}
{title:Remarks}

{pstd}
A dynamic document contains both static narrative and dynamic tags.  Dynamic
tags are instructions for {cmd:dyntext} to perform a certain action, such as run
a block of Stata code, insert the result of a Stata expression in text, export
a Stata graph to an image file, or include a link to the image file. Any
changes in the data or in Stata will change the output as the document is
created. The main advantages of using dynamic documents are

{phang2}o results in the document come from executing commands instead of
being copied from Stata and pasted into the document;

{phang2}o no need to maintain parallel do-files; and

{phang2}o any changes in data or in Stata are reflected in the final document
when it is created. 

{pstd}
Suppose we have the file {cmd:dyntext_ex.txt} containing text that
includes {help dynamic tags:Stata dynamic tags}.

{pstd}
To generate the output file in Stata, we type

{phang2}
{cmd:. dyntext dyntext_ex.txt, saving(dyntext_res.txt)}

{pstd}
The file {cmd:dyntext_res.txt} is saved.

{pstd}
You can see these files at
{browse "https://www.stata-press.com/data/r16/reporting/"}.
{p_end}
