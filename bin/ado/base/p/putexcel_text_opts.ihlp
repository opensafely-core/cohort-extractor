{* *! version 1.0.3  30may2019}{...}
{* *! This ihlp is for putexcel. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcela_text_opts.ihlp.}{...}
{marker font}{...}
{phang}
{cmd:font(}{it:fontname} [{cmd:,} {it:size} [{cmd:,} {it:color}]]{cmd:)} sets
the font, font size, and font color for each cell in a cell range.  If
{opt font()} is not specified, the Excel defaults are preserved.

{phang2}
{it:fontname} may be any valid Excel font.  If {it:fontname} includes spaces,
then it must be enclosed in double quotes.  What constitutes a valid Excel
font is determined by the version of Excel that is installed on the user's
computer.

{phang2}
{it:size} is a numeric value that represents any valid Excel font size.  The
default is {cmd:12}.

{phang2}
{it:color} may be 
one of the colors listed in the table of colors in the 
{help putexcel##Colors:{it:Appendix}} in {bf:[RPT] putexcel} or may be a valid
RGB value in the form {cmd:"}{it:### ### ###}{cmd:"}.  If no {it:color} is
specified, then Excel workbook defaults are used.

{phang}
{opt italic} and {opt noitalic} specify whether to italicize or unitalicize
the text in a cell or range of cells.  The default is for text to be
unitalicized.  {opt noitalic} has an effect only if the cell or cells were
previously italicized.

{phang}
{opt bold} and {opt nobold} specify whether to bold or unbold the text in a
cell or range of cells.  The default is for text to be unbold.  {opt nobold}
has an effect only if the cell or cells were previously formatted as bold.

{phang}
{opt underline} and {opt nounderline} specify whether to underline the text or
remove the underline from the text in a cell or range of cells.  The default
is for text not to be underlined.  {opt nounderline} has an effect only if the
cell or cells previously contained underlined text.

{phang}
{opt strikeout} and {opt nostrikeout} specify whether to strikeout the text or
remove the strikeout from the text in a cell or range of cells.  The default
is for text not to have a strikeout mark.  {opt nostrikeout} has an effect
only if the cell or cells previously had a strikeout mark.

{phang}
{cmd:script(sub}|{cmd:super}|{cmd:none)} changes the script style of the cell.
{cmd:script(sub)} makes all text in a cell or range of cells a subscript.
{cmd:script(super)} makes all text in a cell or range of cells a superscript.
{cmd:script(none)} removes all subscript or superscript formatting from a cell
or range of cells.  Specifying {cmd:script(none)} has an effect only if the
cell or cells were previously formatted as subscript or superscript.
{p_end}
