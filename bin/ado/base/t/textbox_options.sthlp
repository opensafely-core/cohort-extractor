{smcl}
{* *! version 1.1.13  16apr2019}{...}
{vieweralsosee "[G-3] textbox_options" "mansection G-3 textbox_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] alignmentstyle" "help alignmentstyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] compassdirstyle" "help compassdirstyle"}{...}
{vieweralsosee "[G-4] justificationstyle" "help justificationstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] marginstyle" "help marginstyle"}{...}
{vieweralsosee "[G-4] orientationstyle" "help orientationstyle"}{...}
{vieweralsosee "[G-4] size" "help size"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{vieweralsosee "[G-4] textboxstyle" "help textboxstyle"}{...}
{vieweralsosee "[G-4] textsizestyle" "help textsizestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "textbox_options##syntax"}{...}
{viewerjumpto "Description" "textbox_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "textbox_options##linkspdf"}{...}
{viewerjumpto "Options" "textbox_options##options"}{...}
{viewerjumpto "Remarks" "textbox_options##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-3]} {it:textbox_options} {hline 2}}Options for textboxes and concept definition{p_end}
{p2col:}({mansection G-3 textbox_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Textboxes contain one or more lines of text.
The appearance of textboxes is controlled by the following options:

{synoptset 35}{...}
{p2col:{it:textbox_options}}Description{p_end}
{p2line}
{p2col:{cmdab:tsty:le:(}{it:{help textboxstyle}}{cmd:)}}overall style{p_end}

{p2col:{cmdab:orient:ation:(}{it:{help orientationstyle}}{cmd:)}}whether
      vertical or horizontal{p_end}
{p2col:{cmdab:si:ze:(}{it:{help textsizestyle}}{cmd:)}}size of text{p_end}
{p2col:{cmdab:c:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of text{p_end}
{p2col:{cmdab:j:ustification:(}{it:{help justificationstyle}}{cmd:)}}text left,
      centered, right-justified{p_end}
{p2col:{cmdab:al:ignment:(}{it:{help alignmentstyle}}{cmd:)}}text top, middle,
      bottom baseline{p_end}
{p2col:{cmdab:m:argin:(}{it:{help marginstyle}}{cmd:)}}margin from text to
      border{p_end}
{p2col:{cmd:linegap(}{it:{help size}}{cmd:)}}space between lines{p_end}
{p2col:{cmd:width(}{it:{help size}}{cmd:)}}width of textbox override
      {p_end}
{p2col:{cmd:height(}{it:{help size}}{cmd:)}}height of textbox
       override{p_end}

{p2col:{cmd:box} or {cmd:nobox}}whether border is drawn around box{p_end}
{p2col:{cmdab:bc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of background and
      border{p_end}
{p2col:{cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of background{p_end}
{p2col:{cmdab:ls:tyle:(}{it:{help linestyle}}{cmd:)}}overall style of border
     {p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}line pattern of
      border{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of border
     {p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of border{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}border
	alignment (inside, outside, center){p_end}

{p2col:{cmdab:bm:argin:(}{it:{help marginstyle}}{cmd:)}}margin from border
      outwards{p_end}
{p2col:{cmdab:bex:pand}}expand box in direction of text{p_end}

{p2col:{cmdab:place:ment:(}{it:{help compassdirstyle}}{cmd:)}}location of
      textbox override{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The above options invariably occur inside other options.  For instance,
the syntax of {cmd:title()} (see {manhelpi title_options G-3}) is

{phang2}
{cmd:title("}{it:string}{cmd:"}
[{cmd:"}{it:string}{cmd:"} [...]]
[{cmd:,}
{it:title_options}
{it:textbox_options}]{cmd:)}

{pstd}
so any of the options above can appear inside the {cmd:title()} option:

{phang2}
{cmd:. graph}
...
{cmd:,}
...
{cmd:title("My title", color(green) box)}
...


{marker description}{...}
{title:Description}

{pstd}
A textbox contains one or more lines of text.  The textbox options
listed above specify how the text and textbox should appear.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 textbox_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:tstyle(}{it:textboxstyle}{cmd:)}
    specifies the overall style of the textbox.  Think of a textbox as a set
    of characteristics that include, in addition to the text, the size of
    font, the color, whether lines are drawn around the box, etc.
    The {it:textboxstyle} you choose specifies all of those things, and
    it is from there that the changes you make by specifying the other
    operations take effect.

{pmore}
    The default is determined by the overall context of the text (such
    as whether it is due to {cmd:title()}, {cmd:subtitle()}, etc.), and that in
    turn is specified by the scheme (see {manhelp schemes G-4:Schemes intro}).
    That is, identifying the name of the default style in a
    context is virtually impossible.

{pmore}
    Option {cmd:tstyle()} is rarely specified.  Usually, you simply let
    the overall style be whatever it is and specify the other textbox
    options to modify it.  Do not, however, dismiss the idea of
    looking for a better overall style that more closely matches your
    desires.

{pmore}
    See {manhelpi textboxstyle G-4}.

{phang}
{cmd:orientation(}{it:orientationstyle}{cmd:)}
    specifies whether the text and box are to be oriented horizontally or
    vertically (text reading from bottom to top or text reading from
    top to bottom).  See {manhelpi orientationstyle G-4}.

{phang}
{cmd:size(}{it:textsizestyle}{cmd:)}
    specifies the size of the text that appears inside the textbox.
    See {manhelpi textsizestyle G-4}.

{phang}
{cmd:color(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the text that appears inside the textbox.
    See {manhelpi colorstyle G-4}.

{phang}
{cmd:justification(}{it:justificationstyle}{cmd:)}
    specifies how the text is to be "horizontally" aligned in the box.  Choices
    include {cmd:left}, {cmd:right}, and {cmd:center}.
    Think of the textbox
    as being horizontal, even if it is vertical when specifying this option.
    See {manhelpi justificationstyle G-4}.

{phang}
{cmd:alignment(}{it:alignmentstyle}{cmd:)}
    specifies how the text is to be "vertically" aligned in the box.
    Choices include {cmd:baseline}, {cmd:middle}, and {cmd:top}.
    Think of the textbox
    as being horizontal, even if it is vertical when specifying this option.
    See {manhelpi alignmentstyle G-4}.

{phang}
{cmd:margin(}{it:marginstyle}{cmd:)}
    specifies the margin around the text (the distance from the text to
    the borders of the box).  The text that appears in a box, plus
    {cmd:margin()}, determine the overall size of the box.
    See {manhelpi marginstyle G-4}.

{pmore}
    When dealing with rotated textboxes, textboxes for which
    {cmd:orientation(vertical)} or
    {cmd:orientation(rvertical)} has been specified -- the margins for the
    left, right, bottom, and top refer to the margins before rotation.

{phang}
{cmd:linegap(}{it:size}{cmd:)}
    specifies the distance between lines.
    See {manhelpi size G-4} for argument choices.

{phang}
{cmd:width(}{it:size}{cmd:)}
and
{cmd:height(}{it:size}{cmd:)}
    override Stata's usual determination of the width and height of the textbox
    on the basis of its contents.
    See {it:{help textbox_options##remarks6:Width and height}} under
    {it:Remarks} below.  See {manhelpi size G-4} for argument choices.

{phang}
{cmd:box} and {cmd:nobox}
    specify whether a box is to be drawn outlining the border of the
    textbox.  The default is determined by the {cmd:tstyle()}, which
    in turn is determined by context, etc.  In general, the default
    is not to outline boxes, so the option to outline boxes is
    {cmd:box}.  If an outline appears by default, {cmd:nobox}
    is the option to suppress the outlining of the border.  No matter
    what the default, you can specify {cmd:box} or {cmd:nobox}.

{phang}
{cmd:bcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of both the background of the box and
    the outlined border.  This option is typically not specified
    because it results in the border disappearing into the background of the
    textbox; see options {cmd:fcolor()} and {cmd:lcolor()} below for
    alternatives.
    The color matters only if {cmd:box} is also specified;
    otherwise, {cmd:bcolor()} is ignored.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the background of the box.
    The background of the box is filled with the {cmd:fcolor()} only if
    {cmd:box} is also specified; otherwise, {cmd:fcolor()} is ignored.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line used to outline the border.
    The style includes the line's pattern (solid, dashed, etc.),
    thickness, and color.

{pmore}
    You need not specify {cmd:lstyle()} just because there is something
    you want to change about the look of the line.  Options
    {cmd:lpattern}, {cmd:lwidth()}, {cmd:lcolor()}, and {cmd:lalign()} will
    allow you to change the attributes individually.  You specify
    {cmd:lstyle()} when there is a style that is exactly what you desire or
    when another style would allow you to specify fewer changes.

{pmore}
    See {manhelpi linestyle G-4} for a list of style choices and
    see {help lines} for a discussion of lines in general.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies the pattern of the line outlining the border.
    See {manhelpi linepatternstyle G-4}.
    Also see {help lines} for a discussion of lines in general.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line outlining the border.
    See {manhelpi linewidthstyle G-4}.
    Also see {help lines} for a discussion of lines in general.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the border of the box.
    The border color matters only if {cmd:box} is also specified;
    otherwise, the {cmd:lcolor()} is ignored.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line outlining the border is drawn inside,
    is drawn outside, or is centered.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:bmargin(}{it:marginstyle}{cmd:)}
    specifies the margin between the border and the containing box.  See 
    {manhelpi marginstyle G-4}.

{phang}
{cmd:bexpand}
    specifies that the textbox be expanded in the direction of the text,
    made wider if the text is horizontal, and made longer if the text is
    vertical.  It is expanded to the borders of its containing box.
    See {manhelpi title_options G-3} for a demonstration of this option.

{phang}
{cmd:placement(}{it:compassdirstyle}{cmd:)}
    overrides default placement; see
    {it:{help textbox_options##remarks7:Appendix: Overriding default or context-specified positioning}}
    below.
    See {manhelpi compassdirstyle G-4} for argument choices.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help textbox_options##remarks1:Definition of a textbox}
	{help textbox_options##remarks2:Position}
	{help textbox_options##remarks3:Justification}
	{help textbox_options##remarks4:Position and justification combined}
	{help textbox_options##remarks5:Margins}
	{help textbox_options##remarks6:Width and height}
	{help textbox_options##remarks7:Appendix:  Overriding default or context-specified positioning}


{marker remarks1}{...}
{title:Definition of a textbox}

{pstd}
A textbox is one or more lines of text

	{c TLC}{hline 19}{c TRC}        {c TLC}{hline 33}{c TRC}
	{c |}single-line textbox{c |}        {c |}1st line of multiple-line textbox{c |}
	{c BLC}{hline 19}{c BRC}        {c |}2nd line of multiple-line textbox{c |}
				     {c BLC}{hline 33}{c BRC}

{pstd}
for which the borders may or may not be visible (controlled by the
{cmd:box}/{cmd:nobox} option).
Textboxes can be horizontal or vertical

	{c TLC}{hline 10}{c TRC}              {c TLC}{c -}{c TRC}         {c TLC}{c -}{c TRC}
	{c |}horizontal{c |}              {c |}l{c |}         {c |}r{c |}
	{c BLC}{hline 10}{c BRC}              {c |}a{c |}         {c |}v{c |}
				  {c |}c{c |}         {c |}e{c |}
				  {c |}i{c |}         {c |}r{c |}
				  {c |}t{c |}         {c |}t{c |}
				  {c |}r{c |}         {c |}i{c |}
				  {c |}e{c |}         {c |}c{c |}
				  {c |}v{c |}         {c |}a{c |}
				  {c BLC}{c -}{c BRC}         {c |}l{c |}
					      {c BLC}{c -}{c BRC}

	{it:in an} {cmd:orientation(vertical)}            {it:in an} {cmd:orientation(rvertical)}
	{it:textbox, letters are rotated}           {it:textbox, letters are rotated}
	{it:90 degrees counterclockwise;}           {it:90 degrees clockwise;}
	{cmd:orientation(vertical)} {it:reads}            {cmd:orientation(rvertical)} {it:reads}
	{it:bottom to top}                          {it:top to bottom}

{pstd}
Even in vertical textboxes, options are stated in horizontal terms of
left and right.  Think horizontally, and imagine the rotation as being
performed at the end.


{marker remarks2}{...}
{title:Position}

{pstd}
Textboxes are first formed and second positioned on the graph.  The
{it:textbox_options} affect the construction of the textbox, not its positioning.
The options that control its positioning are provided by the context in which
the textbox is used.  For instance, the syntax of the {cmd:title()}
option -- see {manhelpi title_options G-3} -- is

{p 8 31 2}
{cmd:title("}{it:string}{cmd:"} ...
[{cmd:,}
{cmd:position(}...{cmd:)}
{cmd:ring(}...{cmd:)}
{cmd:span(}...{cmd:)}
...
{it:textbox_options}]{cmd:)}

{pstd}
{cmd:title()}'s {cmd:position()}, {cmd:ring()}, and {cmd:span()} options
determine where the title (that is, textbox) is positioned.
Once the textbox is formed, its contents no longer matter; it is just a box
to be positioned on the graph.

{pstd}
Textboxes are positioned inside other boxes.  For instance, the textbox might
be

	{c TLC}{hline 5}{c TRC}
	{c |}{it:title}{c |}
	{c BLC}{hline 5}{c BRC}

{pstd}
and, because of the {cmd:position()}, {cmd:ring()}, and {cmd:span()} options
specified, {cmd:title()} might position that box somewhere
on the top "line":

	{c TLC}{hline 50}{c TRC}
	{c |}{space 50}{c |}
	{c BLC}{hline 50}{c BRC}

{pstd}
There are many ways the smaller box could be fit into the larger box,
which is the usual case, and forgive us for combining two discussions:
how boxes fit into each other and the controlling of placement.
If you specified {cmd:title()}'s {cmd:position(11)} option, the
result would be

	{c TLC}{hline 5}{c TT}{hline 44}{c TRC}
	{c |}{it:title}{c |}{space 44}{c |}
	{c BLC}{hline 5}{c BT}{hline 44}{c BRC}

{pstd}
If you specified {cmd:title()}'s {cmd:position(12)} option, the result
would be

	{c TLC}{hline 21}{c TT}{hline 5}{c TT}{hline 21}{c TRC}
	{c |}{space 21}{c |}{it:title}{c |}{space 21}{c |}
	{c BLC}{hline 21}{c BT}{hline 5}{c BT}{hline 21}{c BRC}

{pstd}
If you specified {cmd:title()}'s {cmd:position(1)} option, the result
would be

	{c TLC}{hline 44}{c TT}{hline 5}{c TRC}
	{c |}{space 44}{c |}{it:title}{c |}
	{c BLC}{hline 44}{c BT}{hline 5}{c BRC}


{marker remarks3}{...}
{title:Justification}

{pstd}
An implication of the above is that it is not the textbox option
{cmd:justification()} that determines whether the title is centered; it
is {cmd:title()}'s {cmd:position()} option.

{pstd}
Remember, textbox options describe the construction of textboxes, not their
use.
{cmd:justification(left}|{cmd:right}|{cmd:center)} determines how text is
placed in multiple-line textboxes:

	{c TLC}{hline 32}{c TRC}
	{c |}Example of multiple-line textbox{c |}
	{c |}{cmd:justification(left)}             {c |}
	{c BLC}{hline 32}{c BRC}

	{c TLC}{hline 32}{c TRC}
	{c |}Example of multiple-line textbox{c |}
	{c |}            {cmd:justification(right)}{c |}
	{c BLC}{hline 32}{c BRC}


	{c TLC}{hline 32}{c TRC}
	{c |}Example of multiple-line textbox{c |}
	{c |}     {cmd:justification(center)}      {c |}
	{c BLC}{hline 32}{c BRC}

{pstd}
Textboxes are no wider than the text of their longest line.
{cmd:justification()} determines how lines shorter than the longest are placed
inside the box.  In a one line textbox,

	{c TLC}{hline 19}{c TRC}
	{c |}{it:single-line textbox}{c |}
	{c BLC}{hline 19}{c BRC}

{pstd}
it does not matter how the text is justified.


{marker remarks4}{...}
{title:Position and justification combined}

{pstd}
With positioning options provided by the context in which the textbox
is being used, and the {cmd:justification()} option, you can create many
different effects in the presentation of multiple-line textboxes.  For
instance, considering {cmd:title()}, you could produce

	{c TLC}{hline 14}{c TT}{hline 19}{c TT}{hline 15}{c TRC}
	{c |}{space 14}{c |}First line of title{c |}{space 15}{c |}          (1)
	{c |}{space 14}{c |}Second line        {c |}{space 15}{c |}
	{c BLC}{hline 14}{c BT}{hline 19}{c BT}{hline 15}{c BRC}

{pstd}
or

	{c TLC}{hline 14}{c TT}{hline 19}{c TT}{hline 15}{c TRC}
	{c |}{space 14}{c |}First line of title{c |}{space 15}{c |}          (2)
	{c |}{space 14}{c |}    Second line    {c |}{space 15}{c |}
	{c BLC}{hline 14}{c BT}{hline 19}{c BT}{hline 15}{c BRC}

{pstd}
or

	{c TLC}{hline 14}{c TT}{hline 19}{c TT}{hline 15}{c TRC}
	{c |}{space 14}{c |}First line of title{c |}{space 15}{c |}          (3)
	{c |}{space 14}{c |}        Second line{c |}{space 15}{c |}
	{c BLC}{hline 14}{c BT}{hline 19}{c BT}{hline 15}{c BRC}

{pstd}
or

	{c TLC}{hline 30}{c TT}{hline 19}{c TRC}
	{c |}{space 30}{c |}First line of title{c |}          (4)
	{c |}{space 30}{c |}Second line        {c |}
	{c BLC}{hline 30}{c BT}{hline 19}{c BRC}

{pstd}
or

	{c TLC}{hline 30}{c TT}{hline 19}{c TRC}
	{c |}{space 30}{c |}First line of title{c |}          (5)
	{c |}{space 30}{c |}    Second line    {c |}
	{c BLC}{hline 30}{c BT}{hline 19}{c BRC}

{pstd}
or

	{c TLC}{hline 30}{c TT}{hline 19}{c TRC}
	{c |}{space 30}{c |}First line of title{c |}          (6)
	{c |}{space 30}{c |}        Second line{c |}
	{c BLC}{hline 30}{c BT}{hline 19}{c BRC}

{pstd}
or many others.   The corresponding commands would be

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (1)
				{cmd:position(12) justification(left))}

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (2)
				{cmd:position(12) justification(center))}

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (3)
				{cmd:position(12) justification(right))}

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (4)
				{cmd:position(1) justification(left))}

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (5)
				{cmd:position(1) justification(center))}

	{cmd:. graph} ...{cmd:, title("First line of title" "Second line",}       (6)
				{cmd:position(1) justification(right))}


{marker remarks5}{...}
{title:Margins}

{pstd}
There are two margins:  {cmd:margin()} and {cmd:bmargin()}.
{cmd:margin()} specifies the margin between the text and the border.
{cmd:bmargin()} specifies the margin between the border and the
containing box.

{pstd}
By default, textboxes are the smallest rectangle that will just contain
the text.  If you specify {cmd:margin()}, you add space between the text
and the borders of the bounding rectangle:

	{c TLC}{hline 20}{c TRC}
	{c |}{cmd:margin(zero)} textbox{c |}
	{c BLC}{hline 20}{c BRC}

	{c TLC}{hline 51}{c TRC}
	{c |}                                                   {c |}
	{c |}   textbox with ample margin on all four sides     {c |}
	{c |}                                                   {c |}
	{c BLC}{hline 51}{c BRC}

{pstd}
{cmd:margin(}{it:marginstyle}{cmd:)} allows different amounts of padding to be
specified above, below, left, and right of the text; see 
{manhelpi marginstyle G-4}.  {cmd:margin()} margins make the textbox look better
when the border is outlined via the {cmd:box} option and/or the box is shaded
via the {cmd:bcolor()} or {cmd:bfcolor()} option.

{pstd}
{cmd:bmargin()} margins are used to move the textbox a little or a lot
when the available positioning options are inadequate.
Consider specifying the {cmd:caption()}
option (see {manhelpi title_options G-3}) so that it is inside the plot
region:

{p 8 16 2}
{cmd:. graph} ...{cmd:,}
{cmd:caption("My caption", ring(0) position(7))}

{pstd}
Seeing the result, you decide that you want to shift the box up and to the right
a bit:

{p 8 30 2}
{cmd:. graph} ...{cmd:,}
{cmd:caption("My caption", ring(0) position(7)}{break}
{cmd:bmargin("2 0 2 0"))}

{pstd}
The {cmd:bmargin()} numbers (and {cmd:margin()} numbers) are the top, bottom,
left, and right amounts, and the amounts are specified as sizes
(see {manhelpi size G-4}).  We specified a 2% bottom margin and a 2%
left margin, thus pushing the caption box up and to the right.


{marker remarks6}{...}
{title:Width and height}

{pstd}
The width and the height of a textbox are determined by its contents (the text
width and number of lines) plus the margins just discussed.
The width calculation, however, is based on an approximation, with the result
that the textbox that should look like this

	{c TLC}{hline 41}{c TRC}
	{c |}Stata approximates the width of textboxes{c |}
	{c BLC}{hline 41}{c BRC}

{pstd}
can end up looking like this

	{c TLC}{hline 43}{c TRC}
	{c |}Stata approximates the width of textboxes  {c |}
	{c BLC}{hline 43}{c BRC}

{pstd}
or like this

	{c TLC}{hline 39}{c TRC}
	{c |}Stata approximates the width of textbox{c |}es
	{c BLC}{hline 39}{c BRC}

{pstd}
You will not notice this problem unless the borders are being drawn
(option {cmd:box}) because, without borders, in all three cases you would see

	 Stata approximates the width of textboxes

{pstd}
For an example of this problem and the solution, see
{it:{help added_text_option##remarks3:Use of the textbox option width()}}
in {manhelpi added_text_option G-3}.
If the problem arises, use {cmd:width(}{it:size}{cmd:)} to work
around it.  Getting the {cmd:width()} right is a matter of trial and error.
The correct width will nearly always be between 0 and 100.

{pstd}
Corresponding to {cmd:width(}{it:size}{cmd:)}, there is
{cmd:height(}{it:size}{cmd:)}.  This option is less useful because
Stata never gets the height incorrect.


{marker remarks7}{...}
{title:Appendix:  Overriding default or context-specified positioning}

{pstd}
What follows is really a footnote.  We said previously that where a
textbox is located is determined by the context in which it is used and by the
positioning options provided by that context.  Sometimes you
wish to override that default, or the context may not provide such
control.  In such cases, the option {cmd:placement()} allows you to take
control.

{pstd}
Let us begin by correcting a misconception we introduced.  We previously
said that textboxes are fit inside other boxes when they are positioned.
That is not exactly true.  For instance, what happens when the textbox
is bigger than the box into which it is being placed?  Say that we have the
textbox

	{c TLC}{hline 20}{c TRC}
	{c |}{space 20}{c |}
	{c BLC}{hline 20}{c BRC}

{pstd}
and we need to put it "in" the box

			{c TLC}{hline 6}{c TRC}
			{c |}{space 6}{c |}
			{c |}{space 6}{c |}
			{c |}{space 6}{c |}
			{c BLC}{hline 6}{c BRC}

{pstd}
The way things work, textboxes are not put inside other boxes; they are merely
positioned so that they align a certain way with the preexisting box.
Those alignment rules are such that, if the preexisting box is larger than
the textbox, the result will be what is commonly meant by "inside".
The alignment rules are either to align one of the four corners or to align
and center on one of the four edges.

{pstd}
In the example just given, the textbox could be positioned so that its
northwest corner is coincident with the northwest corner of the preexisting
box,

			{c TLC}{hline 6}{c TT}{hline 13}{c TRC}
			{c |}{space 6}{c |}{space 13}{c |}{...}
{col 60}{cmd:placement(nw)}
			{c LT}{hline 6}{c +}{hline 13}{c BRC}
			{c |}{space 6}{c |}
			{c BLC}{hline 6}{c BRC}

{pstd}
or so that their northeast corners are coincident,

	  {c TLC}{hline 13}{c TT}{hline 6}{c TRC}
	  {c |}{space 13}{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(ne)}
	  {c BLC}{hline 13}{c +}{hline 6}{c RT}
			{c |}{space 6}{c |}
			{c BLC}{hline 6}{c BRC}

{pstd}
or so that their southwest corners are coincident,

			{c TLC}{hline 6}{c TRC}
			{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(sw)}
			{c LT}{hline 6}{c +}{hline 13}{c TRC}
			{c |}{space 6}{c |}{space 13}{c |}
			{c BLC}{hline 6}{c BT}{hline 13}{c BRC}

{pstd}
or so that their southeast corners are coincident,

			{c TLC}{hline 6}{c TRC}
			{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(se)}
	  {c TLC}{hline 13}{c +}{hline 6}{c RT}
	  {c |}{space 13}{c |}{space 6}{c |}
	  {c BLC}{hline 13}{c BT}{hline 6}{c BRC}

{pstd}
or so that the midpoint of the top edges are the same,

		 {c TLC}{hline 6}{c TT}{hline 6}{c TT}{hline 6}{c TRC}
		 {c |}{space 6}{c |}{space 6}{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(n)}
		 {c BLC}{hline 6}{c +}{hline 6}{c +}{hline 6}{c BRC}
			{c |}{space 6}{c |}
			{c BLC}{hline 6}{c BRC}

{pstd}
or so that the midpoint of the left edges are the same,

			{c TLC}{hline 6}{c TRC}
			{c LT}{hline 6}{c +}{hline 13}{c TRC}
			{c |}{space 6}{c |}{space 13}{c |}{...}
{col 60}{cmd:placement(w)}
			{c LT}{hline 6}{c +}{hline 13}{c BRC}
			{c BLC}{hline 6}{c BRC}

{pstd}
or so that the midpoint of the right edges are the same,

			{c TLC}{hline 6}{c TRC}
	  {c TLC}{hline 13}{c +}{hline 6}{c RT}
	  {c |}{space 13}{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(e)}
	  {c BLC}{hline 13}{c +}{hline 6}{c RT}
			{c BLC}{hline 6}{c BRC}

{pstd}
or so that the midpoint of the bottom edges are the same,

			{c TLC}{hline 6}{c TRC}
			{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(s)}
		 {c TLC}{hline 6}{c +}{hline 6}{c +}{hline 6}{c TRC}
		 {c |}{space 6}{c |}{space 6}{c |}{space 6}{c |}
		 {c BLC}{hline 6}{c BT}{hline 6}{c BT}{hline 6}{c BRC}

{pstd}
or so that the center point of the boxes are the same:

			{c TLC}{hline 6}{c TRC}
		 {c TLC}{hline 6}{c +}{hline 6}{c +}{hline 6}{c TRC}
		 {c |}{space 6}{c |}{space 6}{c |}{space 6}{c |}{...}
{col 60}{cmd:placement(c)}
		 {c BLC}{hline 6}{c +}{hline 6}{c +}{hline 6}{c BRC}
			{c BLC}{hline 6}{c BRC}

{pstd}
If you have trouble seeing any of the above, consider what you would obtain
if the preexisting box were larger than the textbox.  Below we show
the preexisting box with eight different textboxes:

	{c TLC}{hline 13}{c TT}{hline 7}{c TT}{...}
{hline 12}{c TT}{hline 7}{c TT}{hline 13}{c TRC}
{...}
{...}
	{c |}{cmd:placement(nw)}{c |}{space 7}{...}
{c |}{cmd:placement(n)}{c |}{space 7}{...}
{c |}{cmd:placement(ne)}{c |}
{...}
{...}
	{c LT}{hline 13}{c BRC}{space 7}{...}
{c BLC}{hline 12}{c BRC}{space 7}{...}
{c BLC}{hline 13}{c RT}
{...}
{...}
{...}
	{c |}{space 56}{c |}
{...}
{...}
{...}
	{c LT}{hline 12}{c TRC}{...}
{space 8}{c TLC}{hline 12}{c TRC}{space 8}{...}
{c TLC}{hline 12}{c RT}
{...}
{...}
	{c |}{cmd:placement(w)}{c |}{...}
{space 8}{c |}{cmd:placement(c)}{c |}{space 8}{...}
{c |}{cmd:placement(e)}{c |}
{...}
{...}
	{c LT}{hline 12}{c BRC}{...}
{space 8}{c BLC}{hline 12}{c BRC}{space 8}{...}
{c BLC}{hline 12}{c RT}
{...}
{...}
{...}
	{c |}{space 56}{c |}
{...}
{...}
{...}
	{c LT}{hline 13}{c TRC}{space 7}{c TLC}{...}
{hline 12}{c TRC}{space 7}{c TLC}{hline 13}{c RT}
{...}
{...}
	{c |}{cmd:placement(sw)}{c |}{...}
{space 7}{c |}{cmd:placement(s)}{c |}{space 7}{...}
{c |}{cmd:placement(se)}{c |}
{...}
{...}
	{c BLC}{hline 13}{c BT}{hline 7}{c BT}{...}
{hline 12}{c BT}{hline 7}{c BT}{hline 13}{c BRC}
