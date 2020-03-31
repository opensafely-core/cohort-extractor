{smcl}
{* *! version 1.0.0  13may2019}{...}
{vieweralsosee "[RPT] Dynamic documents intro" "mansection RPT Dynamicdocumentsintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] Dynamic tags" "help dynamic tags"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] dyntext" "help dyntext"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{viewerjumpto "Description" "dynamic_intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "dynamic_intro##linkspdf"}{...}
{p2colset 1 34 31 2}{...}
{p2col:{bf:[RPT] Dynamic documents intro} {hline 2}}Introduction to dynamic documents{p_end}
{p2col:}({mansection RPT Dynamicdocumentsintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Stata's dynamic document commands create text files, Word ({cmd:.docx})
documents, and HTML files that include Stata results.  With these commands,
you can create documents that combine text with summary statistics, regression
results, graphs, and other Stata results.  You can include the full output of
Stata commands or incorporate individual values from the results of commands.
Word documents and HTML files can easily be customized using the Markdown
text-formatting language.

{pstd}
See the following manual entries for details on dynamic documents:

{synoptset 22 tabbed}{...}
{synopt :{manhelp Dynamic_tags RPT:Dynamic tags}}Dynamic tags for text files{p_end}

{synopt :{manhelp dyndoc RPT}}Convert dynamic Markdown document to HTML or Word (.docx) document{p_end}

{synopt :{manhelp dyntext RPT}}Process Stata dynamic tags in text file{p_end}

{synopt :{manhelp markdown RPT}}Convert Markdown document to HTML file or
Word (.docx) document{p_end}
{p2colreset}{...}

{pstd}
These documents are dynamic because, as your data change, you simply 
rerun the {cmd:dyndoc} or {cmd:dyntext} command that creates your dynamic 
document, and the HTML file, Word document, or text file is updated 
with the new results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT DynamicdocumentsintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
