{smcl}
{* *! version 1.1.1  31oct2019}{...}
{vieweralsosee "[RPT] Dynamic tags" "mansection RPT Dynamictags"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] dyntext" "help dyntext"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{viewerjumpto "Description" "dynamic_tags##description"}{...}
{viewerjumpto "Remarks" "dynamic_tags##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[RPT] Dynamic tags} {hline 2}}Dynamic tags for text files{p_end}
{p2col:}({mansection RPT Dynamictags:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Dynamic tags are instructions used by Stata's dynamic documents commands,
{helpb dyndoc} and {helpb dyntext}, to perform a certain action, such as run a
block of Stata code, insert the result of a Stata expression in text, export a
Stata graph to an image file, or include a link to the image file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help dynamic tags##tagsdesc:Descriptions of dynamic tags}
        {help dynamic tags##version:Version control}
        {help dynamic tags##code:Execute and include output from a block of Stata code}
        {help dynamic tags##incltext:Include strings and values of scalar expressions in text}
        {help dynamic tags##inclval:Include values of scalar expressions and formatted text in a .docx file}
        {help dynamic tags##graph:Export and include a Stata graph}
        {help dynamic tags##text:Include a text file}
        {help dynamic tags##disable:Disable dynamic text processing}
        {help dynamic tags##if:Process contents based on condition}
        {help dynamic tags##skip:Skip contents based on condition}
        {help dynamic tags##remove:Remove contents}


{marker tagsdesc}{...}
{title:Descriptions of dynamic tags}

{pstd}
Here is a list of available dynamic tags and a short description for each.

{* In the documentation, we show the minimum abbreviation.}{...}
{* Do not show here because the underscore would be lost in the underline.}{...}
{marker exptopts}{...}
{synoptset 20}{...}
{synopt:Dynamic tag}Description{p_end}
{synoptline}
{synopt :{cmd:<<dd_version>>}}specify the minimum version required to convert
the dynamic document{p_end}
{synopt :{cmd:<<dd_do>>}}execute a block of Stata code and optionally include
its output{p_end}
{synopt :{cmd:<</dd_do>>}}end {cmd:<<dd_do>>}{p_end}
{synopt :{cmd:<<dd_display>>}}include output of Stata expression as shown by
Stata's {cmd:display} command{p_end}
{synopt :{cmd:<<dd_docx_display>>}}include output of Stata expression in a
{cmd:.docx} file as shown by Stata's {cmd:display} command and format text
within a block{p_end}
{synopt :{cmd:<<dd_graph>>}}export a Stata graph and include a link to the
file{p_end}
{synopt :{cmd:<<dd_ignore>>}}disable processing of dynamic tags except
{cmd:<<dd_remove>>}{p_end}
{synopt :{cmd:<</dd_ignore>>}}end {cmd:<<dd_ignore>>}{p_end}
{synopt :{cmd:<<dd_include>>}}include the contents of a text file{p_end}
{synopt :{cmd:<<dd_remove>>}}remove the following text until
{cmd:<</dd_remove>>} is specified{p_end}
{synopt :{cmd:<</dd_remove>>}}end {cmd:<<dd_remove>>}{p_end}
{synopt :{cmd:<<dd_if>>}}process text based on condition{p_end}
{synopt :{cmd:<<dd_else>>}}process text based on condition{p_end}
{synopt :{cmd:<<dd_endif>>}}end {cmd:<<dd_if>>} block{p_end}
{synopt :{cmd:<<dd_skip_if>>}}skip text based on condition{p_end}
{synopt :{cmd:<<dd_skip_else>>}}skip text based on condition{p_end}
{synopt :{cmd:<<dd_skip_end>>}}end {cmd:<<dd_skip_if>>} block{p_end}
{synoptline}
{p 4 6 2}
{cmd:<<dd_docx_display>>} is only for use with {cmd:putdocx textblock}
commands in a do-file.

{pstd}
Some tags must start at the beginning of a line, and the text in the same line
after the tag is simply ignored.  Other tags can be written in the middle of a
line.  The following table lists the required position in text for all tags.

{marker exptopts}{...}
{synopt:Dynamic tag}Description{p_end}
{synoptline}
{synopt :{cmd:<<dd_version>>}}beginning of a line, recommended at the start of
a file{p_end}
{synopt :{cmd:<<dd_do>>}}beginning of a line{p_end}
{synopt :{cmd:<</dd_do>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_display>>}}within a line{p_end}
{synopt :{cmd:<<dd_docx_display>>}}within a line{p_end}
{synopt :{cmd:<<dd_graph>>}}within a line{p_end}
{synopt :{cmd:<<dd_ignore>>}}beginning of a line{p_end}
{synopt :{cmd:<</dd_ignore>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_include>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_remove>>}}within a line{p_end}
{synopt :{cmd:<</dd_remove>>}}within a line{p_end}
{synopt :{cmd:<<dd_if>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_else>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_endif>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_skip_if>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_skip_else>>}}beginning of a line{p_end}
{synopt :{cmd:<<dd_skip_end>>}}beginning of a line{p_end}
{synoptline}

{pstd}
Tags can have attributes.  Attributes are modifiers of a
tag's behavior.  Attributes can be repeated, and the last one will take 
effect.  For example, if you specify
{bind:{cmd:<<dd_do:} {it:commands nocommands}{cmd:>>}}, the commands will not
be displayed because the attribute {cmd:nocommands} supersedes the previously
specified attribute {cmd:commands}.  This is useful when you experiment with
the behavior of attributes for the best output.  Some attributes have values;
for example, {cmd:graphname()} requires the name of the graph to be exported.
If a tag has only one attribute and that attribute requires a value, then the
attribute name is omitted and only the value is required; for example,
the {cmd:dd_version} tag is used as
{bind:{cmd:<<dd_version:} {it:an integer number}{cmd:>>}}.


{marker version}{...}
{title:Version control}

        {cmd:<<dd_version:} {it:version}{cmd:_}{it:number}{cmd:>>}

{pstd}
The {cmd:<<dd_version>>} tag specifies the minimum version required to convert
the source file.  The version number is independent of Stata's {helpb version}
command.  The tag must be at the beginning of a new line.  We recommend that
the tag be placed at the beginning of the {it:srcfile}.
  
{pstd} The current version, and the default, is 2, and it is introduced as of
the release of Stata 16.  The current version number is also stored in
{cmd:c(dyndoc_version)}.


{marker code}{...}
{title:Execute and include output from a block of Stata code}

        {cmd:<<dd_do:} {it:attribute}{cmd:>>}
        {it:block of Stata code} ...
        {cmd:<</dd_do>>}

{pstd}
The {cmd:<<dd_do>>} tag runs the block of Stata code, replacing the lines
between {cmd:<<dd_do>>} and {cmd:<</dd_do>>} with Stata output.  Both the
start tag, {cmd:<<dd_do>>}, and the end tag, {cmd:<</dd_do>>}, must be at the
beginning of new lines.

{marker exptopts}{...}
{synopthdr:attribute}
{synoptline}
{synopt :{opt qui:etly}}suppress all output{p_end}
{synopt :{opt nocom:mands}}suppress printing of command{p_end}
{synopt :{opt noout:put}}suppress command output{p_end}
{synopt :{opt noprom:pt}}suppress the dot prompt{p_end}
{synoptline}


{marker incltext}{...}
{title:Include strings and values of scalar expressions in text}

        {cmd:<<dd_display:} {it:display}{cmd:_}{it:directive}{cmd:>>}

{pstd}
The {cmd:<<dd_display>>} tag executes Stata's {helpb display} command and
then replaces the tag with its output.  The tag cannot contain a line 
break or {cmd:>>}.  Use {cmd:>} {cmd:>} (with a space in between) instead if
you need to include {cmd:>>} in the {it:display_directive}.

{pstd}
The {cmd:<<dd_display>>} tag can be used multiple times inside a line of text.
For example, say that we want to display the circumference of a circle of
radius 1 up to the two digits after the decimal.  Instead of computing the
number and then copying and pasting the result into the text, we can write   

{phang2}
{cmd:2*1*<<dd_display:%4.2f c(pi)>> = <<dd_display:%4.2f 2*1*c(pi)>>}

{pstd}
which produces

{phang2}
{cmd:2*1*3.14 = 6.28}


{marker inclval}{...}
{title:Include values of scalar expressions and formatted text in a .docx file}

        {cmd:<<dd_docx_display} {it:text_options}{cmd::} {it:display_directive}{cmd:>>}

{pstd}
This tag includes expressions and formatted text within a block of text in a
{cmd:.docx} file.  It can only be used with text enclosed in
{cmd:putdocx textblock} commands, as follows:

        {cmd:putdocx textblock begin}
        ... {it:text} {cmd:<<dd_docx_display}{cmd::} {it:display_directive}{cmd:>>} {it:text} ...
        {cmd:putdocx textblock end}

{pstd}
The {cmd:<<dd_docx_display>>} tag executes Stata's {helpb display} command and
then replaces the tag with its output.  The output is formatted according to
the {help putdocx_paragraph##opt_putdocx_text:{it:text options}}
available with {cmd:putdocx text}.  The tag cannot contain a line break or
{cmd:>>}. If you need to include {cmd:>>} in the {it:display_directive}, use
the symbols with a space in between ({cmd:> >}).

{pstd}
The {cmd:<<dd_docx_display>>} tag can be used multiple times inside a line of
text.  For example, say that we want to display the circumference of a circle
with radius 1 up to the two digits after the decimal.  Instead of computing
the number and then copying and pasting the result into a block of text, we
can write

        {cmd:putdocx textblock begin}
{phang2}{cmd:2*1*<<dd_docx_display bold:%4.2f c(pi)>> = <<dd_docx_display bold:%4.2f 2*1*c(pi)>>}{p_end}
        {cmd:putdocx textblock end}

{pstd}
which formats the value of pi and the product in bold and produces the
following in the {cmd:.docx} file being created.

        2*1*{bf:3.14} = {bf:6.28}

{pstd}
For another example demonstrating the use of this dynamic tag, see
{mansection RPT putdocxparagraphRemarksandexamplesWorkingwithblocksoftext:{it:Working with blocks of text}}
in {bf:[RPT] putdocx paragraph}.


{marker graph}{...}
{title:Export and include a Stata graph}

        {cmd:<<dd_graph:} {it:attribute}{cmd:>>}

{pstd}
The {cmd:<<dd_graph>>} tag exports a Stata graph and then includes a link to
the exported image file in the target file.

{marker exptopts}{...}
{synopthdr:attribute}
{synoptline}
{synopt :{opt saving(filename)}}export graph to {it:filename}{p_end}
{synopt :{opt rep:lace}}replace the file if it already exists{p_end}
{synopt :{opt gr:aphname(name)}}name of graph to be exported{p_end}
{synopt :{opt svg}}export graph as SVG{p_end}
{synopt :{opt png}}export graph as PNG{p_end}
{synopt :{opt pdf}}export graph as PDF{p_end}
{synopt :{opt eps}}export graph as EPS{p_end}
{synopt :{opt ps}}export graph as PS{p_end}
{synopt :{opt html}}output an HTML link{p_end}
{synopt :{opt markd:own}}output a Markdown link; default is {cmd:html}{p_end}
{synopt :{opt path:only}}output the path of the file; default is {cmd:html}{p_end}
{synopt :{opt alt(text)}}alternative text for the graph to be read by voice
software; ignored if {cmd:pathonly} in effect{p_end}
{synopt :{opt h:eight(#)}}height in pixels of the graph in HTML; ignored if
{cmd:markdown} or {cmd:pathonly} in effect{p_end}
{synopt :{opt w:idth(#)}}width in pixels of the graph in HTML; ignored if
{cmd:markdown} or {cmd:pathonly} in effect{p_end}
{synopt :{opt rel:ative}}use file path relative to the {it:targetfile} path
specified in {helpb dyndoc} or {helpb dyntext}; this is the default{p_end}
{synopt :{opt abs:olute}}use absolute path in the link; default is
{cmd:relative}{p_end}
{synopt :{opt basepath(path)}}use {it:path} as base directory where graph files
will be exported; default is the current working directory if it is not
specified{p_end}
{synopt :{opt nourl:encode}}do not encode the path to a percent-encoded
URL; ignored if {cmd:html} or {cmd:markdown} in effect{p_end}
{synoptline}

{pstd}
If {opt graphname(name)} is not specified, the topmost graph is used.
You can use the default name "Graph" to export the graph without the name.

{pstd}
For paths specified in the {cmd:saving()} or {cmd:basepath()} attributes, a
single backslash ({cmd:\}) is interpreted as an escape character rather than
as the directory separator character.  When working on Windows, we recommend
using a forward slash ({cmd:/}) as the directory separator character (for
example, {cmd:C:/mypath/myfile}); otherwise, you must use a double backslash
(for example, {cmd:C:\\mypath\\myfile}).

{pstd}
If {opt saving(filename)} is not specified, a filename will be constructed
based on the graph name.

{pstd}
If none of {cmd:.svg}, {cmd:.png}, or {cmd:.pdf} is specified, the
{opt saving(filename)} is checked first; if the name specified in
{opt saving(filename)} has the extension of {cmd:.svg}, {cmd:.png}, or
{cmd:.pdf}, then the graph will be exported in the format corresponding to
the extension.  For example, the dynamic tag

        {cmd:<<dd_graph:saving(gr1.png) graphname(gr1)>>}

{pstd}
produces

        {cmd:<img src="gr1.png">}

{pstd}
Otherwise, the type {cmd:.svg} will be used as in

        {cmd:<<dd_graph:saving(gr1.pgg) graphname(gr1)>>}

{pstd}
which produces

        {cmd:<img src="gr1.pgg.svg">}

{pstd}
If {cmd:markdown} is specified, a Markdown link will be produced.  For example,
the dynamic tag

        {cmd:<<dd_graph:saving(gr1.svg) graphname(gr1) markdown>>}

{pstd}
produces

        {cmd:![](gr1.svg)}

{pstd}
You may use {cmd:pathonly} if you want an HTML link with more attributes than
{cmd:html} or {cmd:markdown} can provide or if you want to use the path in a
different target file type such as LaTeX.

{pstd}
By default, the path is outputted as a percent-encoded URL.  For
example, the dynamic tag

       {cmd:<<dd_graph:saving("gr 1.svg") graphname(gr1) pathonly>>}

{pstd}
produces

        {cmd:gr%201.svg}

{pstd}
You may use {cmd:nourlencode} to disable the encoding process as in

        {cmd:"<<dd_graph:saving("gr 1.svg") graphname(gr1) pathonly nourlencode>>"}

{pstd}
which produces

        {cmd:"gr 1.svg"}

{pstd}
The {cmd:<<dd_graph>>} tag can be used inside a line of text.


{marker text}{...}
{title:Include a text file}

        {cmd:<<dd_include:} {it:filename}{cmd:>>}

{pstd}
The {cmd:<<dd_include>>} tag replaces the tag with the contents of the 
specified text file.  The text file is included as is.  The tag must be at 
the beginning of a new line.  The {it:filename} itself may contain Stata
macros, but not the file contents.


{marker disable}{...}
{title:Disable dynamic text processing}

        {cmd:<<dd_ignore>>} and {cmd:<</dd_ignore>>} 

{pstd}
The {cmd:<<dd_ignore>>} tag causes {cmd:dyntext} and {cmd:dyndoc} to ignore
the dynamic tag processing, starting from the next line until the line right
before a {cmd:<</dd_ignore>>} tag.  Both the beginning and ending tags must
be at the beginning of a line.  The only tag it does not affect is the
{cmd:<<dd_remove>>} tag.


{marker if}{...}
{title:Process contents based on condition}

        {cmd:<<dd_if:} {it:Stata expression}{cmd:>>}
        {it:lines of text} ...
        {cmd:<<dd_endif>>}

{pstd}
or

        {cmd:<<dd_if:} {it:Stata expression}{cmd:>>}
        {it:lines of text} ...
        {cmd:<<dd_else>>}
        {it:lines of text} ...
        {cmd:<<dd_endif>>}

{pstd}
{cmd:<<dd_if:} {it:Stata expression}{cmd:>>} evaluates 
the {it:Stata expression}; if it evaluates to true (anything but {cmd:0} or
{cmd:"0"}),  the lines before the next {cmd:<<dd_endif>>} are processed.  If
there is a {cmd:<<dd_else>>}, the lines before {cmd:<<dd_else>>} are
processed, and the lines between {cmd:<<dd_else>>} and {cmd:<<dd_endif>>} are
skipped.

{pstd}
If the Stata expression evaluates to false ({cmd:0} or {cmd:"0"}),  
the lines before the next {cmd:<<dd_endif>>} are skipped.  If there is
a {cmd:<<dd_else>>}, the lines before {cmd:<<dd_else>>} are 
skipped, and the lines between {cmd:<<dd_else>>} and 
{cmd:<<dd_endif>>} are processed.



{marker skip}{...}
{title:Skip contents based on condition}

        {cmd:<<dd_skip_if:} {it:Stata expression}{cmd:>>}
        {it:lines of text} ...
        {cmd:<<dd_skip_end>>}

{pstd}
or

        {cmd:<<dd_skip_if:} {it:Stata expression}{cmd:>>}
        {it:lines of text} ...
        {cmd:<<dd_skip_else>>}
        {it:lines of text} ...
        {cmd:<<dd_skip_end>>}

{pstd}
{cmd:<<dd_skip_if:} {it:Stata expression}{cmd:>>} evaluates 
the {it:Stata expression}; if it evaluates to true (anything but {cmd:0}),  
the lines before the next {cmd:<<dd_skip_end>>} are skipped.  If there is
a {cmd:<<dd_skip_else>>}, the lines before {cmd:<<dd_skip_else>>} are 
skipped, and the lines between {cmd:<<dd_skip_else>>} and 
{cmd:<<dd_skip_end>>} are processed as usual.

{pstd}
If the Stata expression evaluates to false ({cmd:0}),  
the lines before the next {cmd:<<dd_skip_end>>} are not skipped.  If there is
a {cmd:<<dd_skip_else>>}, the lines before {cmd:<<dd_skip_else>>} are 
not skipped, and the lines between {cmd:<<dd_skip_else>>} and 
{cmd:<<dd_skip_end>>} are skipped.


{marker remove}{...}
{title:Remove contents}

        ... {cmd:<<dd_remove>>}{it:text to remove} ...
        {it:lines of text to remove} ...
        {it:text to remove} ... {cmd:<</dd_remove>>} ...

{pstd}
The {cmd:<<dd_remove>>} and {cmd:<</dd_remove>>} tags remove all the contents 
between the two tags from the resulting target file.  The tags can be used 
inside a line of text.

{pstd}
{cmd:<<dd_remove>>} is a postprocessing tag, which means it is
processed after all other tags.
{p_end}
