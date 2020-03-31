{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] justificationstyle" "mansection G-4 justificationstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{vieweralsosee "[G-4] alignmentstyle" "help alignmentstyle"}{...}
{viewerjumpto "Syntax" "justificationstyle##syntax"}{...}
{viewerjumpto "Description" "justificationstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "justificationstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "justificationstyle##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-4]} {it:justificationstyle} {hline 2}}Choices for how text is justified{p_end}
{p2col:}({mansection G-4 justificationstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:justificationstyle}}Description{p_end}
{p2line}
{p2col:{cmd:left}}left-justified{p_end}
{p2col:{cmd:center}}centered{p_end}
{p2col:{cmd:right}}right-justified{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:justificationstyles} may be available; type

	    {cmd:.} {bf:{stata graph query justificationstyle}}

{p 4 4 2}
to obtain the complete list of {it:justificationstyles} installed on your
computer.


{marker description}{...}
{title:Description}

{pstd}
{it:justificationstyle} specifies how the text is "horizontally" aligned
in the textbox.  Choices include {cmd:left}, {cmd:right}, and {cmd:center}.
Think of the textbox as being horizontal, even if it is vertical when
specifying this option.

{pstd}
{it:justificationstyle} is specified in the {cmd:justification()} option
nested within another option, such as {cmd:title()}:

{p 8 21 2}
{cmd:. graph}
...{cmd:, title("Line 1" "Line 2", justification(}{it:justificationstyle}{cmd:))} ...

{pstd}
See {manhelpi textbox_options G-3} for more information on textboxes.

{pstd}
Sometimes you will see that a {it:justificationstylelist} is allowed.  A
{it:justificationstylelist} is a sequence of {it:justificationstyles}
separated by spaces.  Shorthands are allowed to make specifying the list
easier; see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 justificationstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:justificationstyle} typically affects the alignment of multiline text
within a textbox and not the justification of the placement of the
textbox itself; see {it:{help textbox_options##remarks3:Justification}} in
{manhelpi textbox_options G-3}.
{p_end}
