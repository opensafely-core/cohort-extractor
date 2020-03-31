{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[G-4] alignmentstyle" "mansection G-4 alignmentstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{vieweralsosee "[G-4] justificationstyle" "help justificationstyle"}{...}
{viewerjumpto "Syntax" "alignmentstyle##syntax"}{...}
{viewerjumpto "Description" "alignmentstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "alignmentstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "alignmentstyle##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-4]} {it:alignmentstyle} {hline 2}}Choices for vertical alignment of text{p_end}
{p2col:}({mansection G-4 alignmentstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col : {it:alignmentstyle}}Description{p_end}
{p2line}
{p2col : {cmd:baseline}}bottom of textbox = baseline of letters{p_end}
{p2col : {cmd:bottom}}bottom of textbox = bottom of letters{p_end}
{p2col : {cmd:middle}}middle of textbox = middle of letters{p_end}
{p2col : {cmd:top}}top of textbox = top of letters{p_end}
{p2line}
{p2colreset}{...}

{p 4 6 2}
Other {it:alignmentstyles} may be available; type

	    {cmd:.} {bf:{stata graph query alignmentstyle}}

{p 4 6 2}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
See {manhelpi textbox_options G-3} for a description of textboxes.
{it:alignmentstyle} specifies how the text is vertically aligned in a
textbox.  Think of the textbox as being horizontal, even if it is vertical when
specifying this option.

{pstd}
{it:alignmentstyle} is specified inside options such as the
{cmd:alignment()} suboption of {cmd:title()}
(see {manhelpi title_options G-3}):

{pin}
	{cmd:. graph} ...{cmd:, title("My title", alignment(}{it:alignmentstyle}{cmd:))} ...

{pstd}
Sometimes an {it:alignmentstylelist} is allowed.  An
{it:alignmentstylelist} is a sequence of {it:alignmentstyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier; see 
{manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 alignmentstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Think of the text as being horizontal, even if it is not, and think of
the textbox as containing one line, such as

	{cmd:Hpqgxyz}

{pstd}
{cmd:alignment()} specifies how the bottom of the textbox aligns with the
bottom of the text.

{pstd}
{cmd:alignment(baseline)} specifies that the bottom of the textbox
be the baseline of the letters in the box.  That would result in something
like

	{cmd:....Hpqgxyz....}

{pstd}
where dots represent the bottom of the textbox.  Periods in most fonts are
located on the baseline of letters.  Note how the letters {cmd:p}, {cmd:q},
{cmd:g}, and {cmd:y} extend below the baseline.

{pstd}
{cmd:alignment(bottom)} specifies that the bottom of the textbox be
the bottom of the letters, which would be below the dots in the above example,
lining up with the lowest part of the {cmd:p}, {cmd:q}, {cmd:g} and {cmd:y}.

{pstd}
{cmd:alignment(middle)} specifies that the middle of the textbox line
up with the middle of a capital {cmd:H}.  This is useful when you want to
align text with a line.

{pstd}
{cmd:alignment(top)} specifies that the top of the textbox line up
with the top of a capital {cmd:H}.
{p_end}
