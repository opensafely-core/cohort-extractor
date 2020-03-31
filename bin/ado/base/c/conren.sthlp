{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[GSU] conren" "mansection GSU conren"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[GSU] B.1 Executing commands every time Stata is started" "help profile"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{viewerjumpto "Syntax" "conren##syntax"}{...}
{viewerjumpto "Description" "conren##description"}{...}
{viewerjumpto "Finding a color scheme" "conren##color_scheme"}{...}
{viewerjumpto "Can your terminal underline" "conren##underline"}{...}
{viewerjumpto "If you had success..." "conren##success"}{...}
{viewerjumpto "If you did not have success..." "conren##nosuccess"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[GSU] conren} {hline 2}}Set the console rendition attributes of Stata for Unix(console){p_end}
{p2col:}({mansection GSU conren:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    High-level commands:

	{cmd:conren}

{p 8 15 2}{cmd:conren} {cmdab:s:tyle} {it:#}

{p 8 15 2}{cmd:conren} {cmd:ul} {it:#}

{p 8 15 2}{cmd:conren} {cmdab:t:est}

{p 8 15 2}{cmd:conren} {cmd:clear}


    Low-level commands:

{p 8 19 2}{cmd:set} {cmd:conren}

{p 8 19 2}{cmd:set} {cmd:conren} {cmd:clear}

{p 8 19 2}{cmd:set} {cmd:conren} [ {cmd:sf} | {cmd:bf} | {cmd:it} ]
	{c -(} {cmdab:res:ult} | [{cmd:txt}|{cmd:text}] |
	{cmdab:inp:ut} | {cmdab:err:or} | {cmdab:li:nk} |
	{cmdab:hi:lite} {c )-} [ {it:char} [ {it:char ...} ] ]

{p 8 19 2}{cmd:set} {cmd:conren} {char -(} {cmd:ulon} | {cmdab:ulof:f} {char )-}
	[ {it:char} [ {it:char ...} ] ]

{p 8 19 2}{cmd:set} {cmd:conren} {cmd:reset} [ {it:char} [ {it:char ...} ] ]


{pstd}where {it:char} is

{p 8 10 2}{char -(} {it:any_character} | {cmd:<}{it:#}{cmd:>} {char )-}

{p 4 11 2}
Note:  This command is designed for Stata for Unix and, in particular, the
Stata you launch by typing {cmd:stata}, not {cmd:xstata}; also known as
Stata(console) or the non-GUI version of Stata.  However, in windowed versions
of Stata, {cmd:conren} produces the current rendition table (the output
from {cmd:conren test}) in the Results window.


{marker description}{...}
{title:Description}

{pstd}
{cmd:conren} and {cmd:set} {cmd:conren} can possibly improve the display of
the output on your screen.  Some monitors, for instance, {hi:can}
{err:display} {res:colors}, but Stata may not know that your monitor has that
capability.  Some monitors have {bf:multiple} intensities or {bf:boldface}.
Some monitors can {ul:underline}.

{pstd}
The high-level {cmd:conren} command lets you set a display style and/or
underlining scheme from among a selection of predefined settings.

{p 8 8 6}{cmd:conren} {cmd:style} followed by a scheme number sets color and
font codes based on the underlying scheme.

{p 8 8 6}{cmd:conren} {cmd:ul} followed by an underlining scheme number sets
the codes allowing underlining.

{p 8 8 6}{cmd:conren} with no arguments displays a message explaining the
command and telling the range of style and underlining scheme numbers
available.

{p 8 8 6}{cmd:conren} {cmd:test} displays three columns of output in sf
(standard face) font, {bf:bf (bold face) font}, and {it:it (italics) font}
showing the assignment of colors with and without underlining.

{p 8 8 6}{cmd:conren} {cmd:clear} clears all the currently defined display
styles and underlining definitions.

{pstd}
The low-level {cmd:set} {cmd:conren} command lets you view and set specific
display and underlining codes.

{p 8 8 6}{cmd:set} {cmd:conren} displays a list of the currently defined
display codes.

{p 8 8 6}{cmd:set} {cmd:conren} {cmd:clear} clears all codes.

{p 8 8 6}{cmd:set} {cmd:conren} followed by a font type ({cmd:bf}, {cmd:sf},
or {cmd:it}) and display context ({cmd:result}, {cmd:text}, {cmd:input},
{cmd:error}, {cmd:link}, or {cmd:hilite}) and then followed by a series of
space-separated characters sets the code for the specified font type and
display context.  If the font type is omitted, the code is set to the same
specified code for all three font types.

{p 8 8 6}{cmd:set} {cmd:conren} {cmd:ulon} and
{cmd:set} {cmd:conren} {cmd:uloff} set the codes for turning on and off
underlining.

{p 8 8 6}{cmd:set} {cmd:conren} {cmd:reset} sets the code that will turn off
all display and underlining codes.

{pstd}When Stata comes up, it is as if you have typed

{p 8 12 2}{cmd:. conren clear}

{pstd}which is equivalent to the low-level command

{p 8 12 2}{cmd:. set conren clear}

{pstd}
meaning that Stata is to assume that your monitor cannot display different
colors, intensities, or underlining.  Stata makes this assumption because,
if Stata assumed otherwise and your terminal could not provide that
capability, the result could look really bad.  Thus, a few minutes of playing
around can be well worth the effort, and you do not have to be a computer
expert to do this.  You cannot hurt anything permanently by typing the wrong
command.

{pstd}
The next-to-worst thing that can happen is that Stata's output will look so
bad that you cannot even read it; in that case, just {helpb exit} Stata.  Stata
will be fine next time.

{pstd}
The worst thing that can happen is that your window/screen/terminal will be
so garbled that you will have to close it and open a new one (or, if it really
is a separate terminal, turn it off and turn it back on).


{marker color_scheme}{...}
{title:Finding a color scheme}

{pstd}
First let's try various color schemes.  What will work and look good
depends on your terminal/monitor and whether you are using a white or black
background.  (Personally, we prefer a black background for Stata and,
if you are using a white background, we recommend that you try black someday.
We prefer a black background for Stata since, by default, it uses green and
yellow for most output and these colors do not show up well on a light-colored
background.  Switching the background color, however, is something that you
will have to take up with Unix, not Stata.)

{pstd}
First, type the following:

	{cmd:. conren}

{pstd}
The first thing this tells you is the number of possible display
schemes and underlining schemes available.  There are a few underlining
schemes and many more display schemes.  Some of these schemes were designed
for black backgrounds, while others were designed for white backgrounds.  We
suggest that you first select a display style scheme and then 
explore the possible underlining schemes.

{pstd}
You would type

{p 8 12 2}{cmd:. conren style 1}

{pstd}
to try display style scheme 1.  {cmd:conren} {cmd:style} and {cmd:conren}
{cmd:ul} automatically run {cmd:conren} {cmd:test} so that you can see the
result on your screen.  If the result is obviously bad, try
another scheme.  If the resulting color scheme might be reasonable, try 
Stata and see what you think.  Try several commands and look at a few help
files to see if the selected display style scheme is appropriate.  You can
always return to the default with

	{cmd:. conren clear}

{pstd}
which may be easier said than done if you cannot even see what you are
typing.  Remember, if things are really bad, just type {cmd:exit} and then
restart Stata.


{marker underline}{...}
{title:Can your terminal underline?}

{pstd}
Look at the title above.  Is it underlined -- the underlining being on the
same line and actually touching the characters -- or is it instead more
crudely rendered with a string of dashes underneath on a second line?

{pstd}
If the title is underlined, skip this section; evidently Stata has already
figured out that your terminal can underline and is doing that.

{pstd}
Sometimes Stata cannot figure that out for itself.  Let's see if you can
underline.  Type

{p 8 12 2}{cmd:. conren ul 1}

{pstd}
Did the output have underlines or just a mess?  If it's a mess, you can
remove the underlining codes (while leaving the display style codes untouched)
by typing

{p 8 12 2}{cmd:. conren ul 0}

{pstd}
You can try the other available underlining schemes to see if they work any
better for you.


{marker success}{...}
{title:If you had success...}

{pstd}
Let's say that you discovered that what works best for you is

{p 8 12 2}{cmd:. conren style 4}{p_end}
{p 8 12 2}{cmd:. conren ul 1}

{pstd}
The next time you enter Stata, if you want the prettier look, you will have
to type those two commands.  To avoid that, create a file {hi:profile.do}, and
put those two lines in that file; see {help profile}.  Actually, we
suggest that you put the lines in the file as

{p 8 12 2}{cmd:quietly conren style 4}{p_end}
{p 8 12 2}{cmd:quietly conren ul 1}

{pstd}
because this will prevent the output test from appearing.


{marker nosuccess}{...}
{title:If you did not have success...}

{pstd}
Now you really need to be technical.  Stata's output can still be made to look
prettier if you know the "escape sequences" to cause special effects on your
terminal.

{pstd}
For instance, say that the codes for your terminal to turn underlining on
and off are Esc-[4m and Esc-[24m.  You could tell Stata that by typing

{p 8 12 2}{cmd:. set conren ulon  <27> [ 4 m}{p_end}
{p 8 12 2}{cmd:. set conren uloff <27> [ 2 4 m}

{pstd}
27 is the decimal code for Escape, and you can type decimal codes by
enclosing them in less-than and greater-than signs.  Regular characters, you
can just type.  Remember, however, you must type at least one blank between
each character.

{pstd}
All the features can be set in this way.  If you type

	{cmd:. set conren}

{pstd}
Stata will report what is currently set.
{p_end}
