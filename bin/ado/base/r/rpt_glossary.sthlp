{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] Glossary" "mansection RPT Glossary"}{...}
{viewerjumpto "Description" "rpt_glossary##description"}{...}
{viewerjumpto "Glossary" "rpt_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[RPT] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection RPT Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:dynamic document}.
A dynamic document contains both static narrative and dynamic tags. Any
changes in the data or in Stata will change the output as the document is
created. The main advantages of using dynamic documents are 1)
results in the document come from executing commands instead of being copied
from Stata and pasted into the document; 2)
no need to maintain parallel do-files; and 3)
any changes in data or in Stata are reflected in the final document when it is
created.

{phang}
{bf:dynamic tags}.
Dynamic tags are instructions that appear in the source files from 
which dynamic documents are created. These dynamic tags specify 
actions to be taken when source files are processed by Stata's 
dynamic documents commands, {helpb dyndoc} and
{helpb dyntext}. For instance, dynamic tags
can indicate that a block of Stata code be run, that the result of a Stata 
expression be inserted in text, and that a Stata graph be exported to an 
image file and a link to the image file be included in the dynamic 
document; see {helpb dynamic tags:[RPT] Dynamic tags} for a complete list of
available dynamic tags.

{phang}
{bf:dynamic text file}.
A dynamic text file contains both plain text and dynamic tags.  A 
dynamic text file can be processed by {helpb dyntext}
to create a text file that incorporates Stata results.

{phang}
{bf:Markdown}.
Markdown is an easy-to-read, plain-text, lightweight markup language.
For a detailed discussion and the syntax of Markdown, see the
{browse "https://en.wikipedia.org/wiki/Markdown":Markdown Wikipedia page}.

{pmore}
Markdown is easily converted to an output format such as HTML.
Stata uses Flexmark's Pegdown emulation as its default Markdown document
processing engine.  For information on Pegdown's flavor of Markdown, see the
{browse "https://github.com/sirthias/pegdown":Pegdown GitHub page}.
{p_end}
