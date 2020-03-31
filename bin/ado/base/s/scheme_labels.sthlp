{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:labels and small_labels textboxstyle definitions}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
{cmd:label} and {cmd:small_label} are {help textboxstyle:textboxstyles} used
for a number of graph text elements.  They share a common definition with the
only difference being that small labels have a smaller text size {c -} by 
default it is smaller, but you can make it larger.

{p 3 3 2}
A scheme can change the look of labels and small labels using the following
entries.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize         {space 5}label}       {space 6}{it:{help textsizestyle}}}
	size of text for {cmd:label} {help textstyle}{p_end}
{p2col:{cmd:gsize         {space 5}small_label} {space 0}{it:{help textsizestyle}}}
	size of text for {cmd:small_label} {help textstyle}{p_end}
{p2col:{cmd:color       {space 5}label}         {space 6}{it:{help colorstyle}}}
	color of text{p_end}
{p2col:{cmd:margin        {space 4}label}       {space 6}{it:{help marginstyle}}}
	margin around text{p_end}
{p2col:{cmd:horizontal    {space 0}label}       {space 6}{it:{help justificationstyle}}}
	text justification{p_end}
{p2col:{cmd:vertical_text {space 0}label}       {space 3}{it:{help alignmentstyle}}}
	text alignment{p_end}
{p2line}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
A scheme may also change the following definitions about the box around the
text and whether that box is drawn, but this is rarely done.  These entries
are shared by a number of other {help textboxstyle:textboxstyles}, and changing
them will also change the look of any other text using those styles.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno       {space 5}textbox}       {space 2}{{cmd:yes}|{cmd:no}}}
	whether box is drawn around text {cmd:yes}, or not {cmd:no}{p_end}
{p2col:{cmd:color       {space 5}textbox}       {space 2}{it:{help colorstyle}}}
	fill color of box{p_end}
{p2col:{cmd:margin        {space 4}textbox}     {space 2}{it:{help marginstyle}}}
	outer margin around box{p_end}

{p2col:{cmd:linestyle   {space 1}textbox}      {space 2}{it:{help linestyle}}}
	style of line drawn around box, composite style{p_end}
{p2line}
{p2colreset}{...}
