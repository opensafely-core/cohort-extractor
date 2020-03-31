{smcl}
{* *! version 1.0.0  15oct2019}{...}
{vieweralsosee "[RPT] set docx" "mansection RPT setdocx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{viewerjumpto "Syntax" "set_docx##syntax"}{...}
{viewerjumpto "Description" "set_docx##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_docx##linkspdf"}{...}
{viewerjumpto "Remarks/example" "set_docx##remarks"}{...}
{p2colset 1 19 20 2}{...}
{p2col:{bf:[RPT] set docx} {hline 2}}Format settings for blocks of text{p_end}
{p2col:}({mansection RPT setdocx:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Set whether spaces are added after hard line breaks

{p 8 16 2}
{cmd:set}
{cmd:docx_hardbreak}
{c -(}{cmd:on} | {cmd:off}{c )-}


{pstd}
Set whether empty lines signal the beginning of a new paragraph

{p 8 16 2}
{cmd:set}
{cmd:docx_paramode}
{c -(}{cmd:on} | {cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:docx_hardbreak} specifies whether {cmd:putdocx} {cmd:textblock}
inserts a space at the beginning of lines or respects spaces exactly as they
are typed.  {cmd:set docx_hardbreak off}, the default, respects spaces at the
beginning and end of lines exactly as they are typed in the text block.
{cmd:set docx_hardbreak on} inserts a space at the beginning of all nonempty
lines, excluding the first line in the block of text and the first line of
each paragraph.  Thus, {cmd:set docx_hardbreak on} adds a space after hard
line breaks.

{pstd}
{cmd:set} {cmd:docx_paramode} specifies whether {cmd:putdocx} {cmd:textblock}
treats blank lines in a text block as an indication of a new paragraph.
{cmd:set docx_paramode off}, the default exports the block of text as a
single paragraph, treating blank lines as if they were not there.
{cmd:set docx_paramode on} specifies that a blank line signals a new
paragraph.  The text following each blank line will begin a new paragraph.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setdocxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:set} {cmd:docx_hardbreak} and {cmd:set} {cmd:docx_paramode}
commands control the spacing of paragraph content added with {cmd:putdocx}
{cmd:textblock} commands.

{pstd}
By default, the content enclosed within a set of {cmd:putdocx} {cmd:textblock}
commands is added to the {cmd:.docx} file with the beginning and end of line
spaces respected exactly as they are typed and with any empty lines removed.
To avoid having to include a space between the last word on each line and the
first word on the following line, you can type

            {cmd:set docx_hardbreak on}

{pstd}
This setting tells Stata to add an extra space at the beginning of all
nonempty lines in the text block, except for the first line in the text block
and the first line of each paragraph.

{pstd}
To insert paragraph breaks within a text block, you can type

            {cmd:set docx_paramode on}

{pstd}
This setting tells Stata to begin a new paragraph with the content following
an empty line.  Empty lines refer to lines without any text, spaces, or tab
characters.

{pstd}
When specified interactively, these settings will apply throughout the Stata
session.  When used within a do-file, Stata automatically restores the
previous {cmd:set} {cmd:docx_hardbreak} and {cmd:set} {cmd:docx_paramode}
settings when the do-file concludes.
{p_end}
