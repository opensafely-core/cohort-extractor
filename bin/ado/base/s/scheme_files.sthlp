{smcl}
{* *! version 1.1.6  16apr2019}{...}
{vieweralsosee "scheme entries" "help scheme entries"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] set scheme" "help set_scheme"}{...}
{vieweralsosee "[G-3] scheme_option" "help scheme_option"}{...}
{title:Description of scheme file format}

{p 3 3 2}
A {help scheme} specifies the overall look of a graph and is defined by a
scheme file.  Each entry in a scheme file specifies the look for a specific
attribute of a specific graph element, such as the color of a symbol or the
size of text.

{p 3 3 2}
This information is provided primarily for those creating their own
graphics schemes.  We describe the format of scheme files and the effect
entries in the scheme file have on graphs.  For an overview of graphics
schemes, see {manhelp schemes G-4:Schemes intro}.


{title:Remarks}

{p 3 3 2}
Remarks are presented under the following headings:

	{help scheme_files##remarks1:Creating your own schemes}
 	{help scheme_files##remarks2:What is a scheme-file entry?}
	{help scheme_files##remarks3:Plot entries} 
	{help scheme_files##remarks4:Composite entries} 
 	{help scheme_files##remarks5:Example scheme file}
 	{help scheme_files##remarks6:Suggestions}

{p 3 3 2}
See {help scheme entries} for the full list of scheme file entry definitions,
but first read the rest of this help file.


{marker remarks1}{...}
{title:Creating your own schemes}

{p 3 3 2}
Scheme {it:schemename} is stored in file 
{cmd:scheme-}{it:schemename}{cmd:.scheme}.
For example, scheme {bf:{help scheme_s2:s2color}} is stored in file
{cmd:scheme-s2color.scheme}.  You can find where a scheme file is located by
typing

	{cmd:. which} {cmd:scheme-}{it:schemename}{cmd:.scheme}

{p 3 3 2}
To create a new scheme, say {cmd:mine}, you need only create a file with
the name {cmd:scheme-mine.scheme} in your PERSONAL directory (see 
{manhelp sysdir P}).  You should always base your scheme on a scheme shipped
with Stata or on another scheme based on an official scheme shipped with
Stata.  You do that by putting the line

{p 8 8 0}{cmd:#include {it:schemename}}

{p 3 3 2}
before any scheme-file entries in your scheme.  If you want to base your
scheme on the scheme Stata uses by default when shipped, the line should
read

{p 8 8 0}{cmd:#include s2color}

{p 3 3 2}
Graphs drawn with your scheme will start out looking just like those drawn
with {cmd:s2color}, and the entries that you make in your scheme file will
serve as edits to the {cmd:s2color} scheme.

{p 3 3 2}
For the adventurous, that may be sufficient information.  Look at the file
containing the {cmd:s2color} scheme {c -} type 
{cmd:which scheme-s2color.scheme} to locate that file.  You will find the
lines in the file very readable, and you can often guess what effect a line
has.  When you want to change something, simply create a similar line in your
own file and change the {it:style} (the last word on the line) to whatever you
prefer; for example, for a {cmd:color} entry change {cmd:green} to {cmd:red}.
For the less adventurous, read on.


{marker remarks2}{...}
{title:What is a scheme-file entry?} 

{p 3 3 2}
Each entry in a scheme file specifies how a particular attribute of a
graph element looks.  For example, 

	{cmd:symbolsize matrix medium}

{p 3 3 2}
specifies that the size of symbols used in scatterplot matrices is to be
{cmd:medium}.  We know this because the first word of the entry specifies the
styletype, or attribute affected; the second word is the graph element, or
the part affected (here {cmd:matrix} is short for scatterplot matrix); and
the third word is the style to be applied to the specific attribute of the
element.

{p 3 3 2}
We could change {cmd:medium} to {cmd:small} or {cmd:large} or any of the
predefined styles for {help markersizestyle}, or we could specify a number for
the size.  This number is scaled so that 100 represents the full height of the
graph (or width if the width is smaller than the height); see
{manhelpi size G-4}.  The available options for each style that may be 
specified, the 3rd word, are documented in the tables of entries in 
{help scheme entries}.

{p 3 3 2}
As a second example, we could change the text color for axis titles from
{cmd:black} to {cmd:red} by changing the line,

	{cmd:color axis_title black}
{p 3 3 2}
to{p_end}
	{cmd:color axis_title red}

{p 3 3 2}
The available styles for {cmd:color} entries are the {it:colorstyles}, which
include explicit RGB values, rather than just named colors; see
{manhelpi colorstyle G-4} for more information and a discussion of
RGB values.  This means that we could have changed the entry to

	{cmd:color axis_title "255 0 0"}

{p 3 3 2}
a bright red.  Note that the RGB values and any style using more than one
token or word must be enclosed in quotes.


{marker remarks3}{...}
{title:Plot entries} 

{p 3 3 2}
In addition to standard entries, scheme files have many entries for plots.

{p 3 3 2}
What is a plot?  When you type

	{cmd:. scatter y1 y2 x}

{p 3 3 2}
the set of plotted markers for y1 versus x is the first plot and y2 versus x
is the second plot.  The markers for the first plot look different from those
for the second plot {c -}, with perhaps different colors, or sizes, or both.  With
different graph commands, we might have two lines that differ, or two sets of
bars, or two pie slices, but in all cases we refer to these as plot1 and plot2,
and their looks are controlled by {it:pstyles} (short for plot styles); see
{manhelpi pstyle G-4}.  The official scheme files have entries for 15 plots.

{p 3 3 2}
An entry to set the marker size for the second plot might be

	{cmd:symbolsize p2 medium}
	
{p 3 3 2}
where {cmd:p2} specifies plot2.  

{p 3 3 2}
As it turns out, most of Stata's official schemes use the same size markers
for all plots.  Rather than having 15 entries to set the same marker size, we
simply omit the plot number and use the following single entry that applies
to all plots:

	{cmd:symbolsize p medium}

{p 3 3 2}
We saw earlier how to base your own scheme on another scheme, such as the
official {bf:{help scheme_s2:s2color}} scheme, and in that case we must take some
care using just {cmd:p}.  Because {cmd:s2color} defines only one symbolsize for
all plots, we could change the size of all symbols to {cmd:large} by adding
the line

	{cmd:symbolsize p large}

{p 3 3 2}
If {cmd:s2color} had been more specific and included entries to separately
define marker sizes for plot1 - plot15, then those more specific entries would
take precedence over our entry that did not specify a plot number.  We would
need to make individual entries for {cmd:p1}, {cmd:p2}, etc., for each plot.

{p 3 3 2}
Note that there are many attributes for plot elements, so there are
many plot entries.  In addition to marker size, there are entries for marker
color,

	{cmd:color p1 navy}

{p 3 3 2}
marker symbol (shape),

	{cmd:symbol p circle}
 
{p 3 3 2}
and sets of entries for lines, boxes, and other plot elements.

{p 3 3 2}
We pulled these two examples from the {cmd:s2color} scheme, and you can see
that the marker colors are different for each plot, whereas the marker symbols
are all circles.

{p 3 3 2}
Plot entries can be even more specific than plot number.  Some entries can be
directed at a particular kind of plot.  For example, the entry

	{cmd:color p3line yellow}

{p 3 3 2}
will make the third line plot yellow but will not affect the color of scatters,
bars, or other plottypes.  While the {cmd:s2color} scheme does not take
advantage of this, you can create schemes with different colors and
intensities for each plottype -- scatter, line, bar, pie slice, etc.

 
{marker remarks4}{...}
{title:Composite entries} 

{p 3 3 2}
When we said that each entry specifies a particular attribute, that was an
oversimplification.  Some entries designate how the specific attributes will be
assigned for a collection of attributes for a graph element.  We will call the
entries for these collections composite entries.

{p 3 3 2}
Textboxes, for example, are used for titles, captions, and many other graph
text elements.  There are 11 attributes associated with a textbox, for example,
the size of the text, the color of the text, the color of the background, and
more; see {manhelpi textboxstyle G-4} for the full list.  Changing a
{it:textboxstyle} entry, which is a composite entry, can potentially change all
11 of these attributes.

{p 3 3 2}
Let's look at two composite entries for textboxstyles:

	{cmd:textboxstyle axis_title axis_title}
	{cmd:textboxstyle title      heading}

{p 3 3 2}
The first entry specifies that the {it:textboxstyle} for axis titles is to be
the {cmd:axis_title} style, which seems like a good default.  Similarly, the
second line specifies that the {it:textboxstyle} for graph titles is to be the
{cmd:heading} style.  

{p 3 3 2}
We could make axis titles look just like graph titles by changing the
specified {it:textboxstyle} of the first entry from {cmd:axis_title} to
{cmd:heading}:

	{cmd:textboxstyle axis_title heading}

{p 3 3 2}
Now, all axis titles will look like graph titles {c -} they will have the same
text size, the same text color, etc.

{p 3 3 2}
Note that changes to composite entries can interact with the effects of other
entries.  In section 2, we changed the color of axis title text by changing the
{cmd:color axis_title black} entry to {cmd:color axis_title red}.  Now that
the composite {it:textboxstyle} entry for axis titles no longer specifies the
{cmd:axis_title} style, but rather the {cmd:heading} style, our color change
will have no effect.  We would need to change the {cmd:color heading black}
entry to {cmd:color heading red} to change the color of axis titles.  This
would also change the color of graph titles because the two now share
the {cmd:heading} {it:textboxstyle}.

 
{marker remarks5}{...}
{title:Example scheme file}

{p 3 3 2}
As discussed in section 1, you can create your own schemes by creating a file
in your PERSONAL director called {cmd:scheme-}{it:schemename}{cmd:.scheme}.
Let's look at a very simple example of such a scheme and name the scheme
{cmd:simple}.


	{hline 3} Begin scheme-simple.scheme {hline 24}
	{cmd:#include s2color}
	{cmd:color background  white}
	{hline 3} End scheme-simple.scheme {hline 26}

{p 3 3 2}
This scheme is based on the {bf:{help scheme_s2:s2color}} scheme; and we can
tell that because of the {cmd:#include s2color} line (see section 1). It
changes only one thing -- the background color is set to {cmd:white}.  
If we use {cmd:simple} by including {cmd:scheme(simple)} option on
our graph command (see {manhelp schemes G-4:Schemes intro} for more ways to set
the scheme), then the graph region will no longer be bluish gray, but will be
white.  Any other graph element that references the background color will also
be white.

{p 3 3 2}
Now, let's look at a slightly more complicated example, which we will call
{cmd:mine}.

	{hline 3} Begin scheme-mine.scheme {hline 26}
	{cmd:* This is our better demonstration scheme.}
	{cmd:* We should probably go on to describe it further here.}

	{cmd:*! version 1.0.0   12nov2004}

	{cmd:#include s2color}

	{cmd:color background  white}
	{cmd:color major_grid  "200 200 200"}

	{cmd:color p1          "  0 255   0"}
	{cmd:color p2          magenta}

	{cmd:anglestyle vertical_tick    horizontal}

	{cmd:clockdir   legend_position  4}
	{cmd:numstyle   legend_cols      1}
	{cmd:linestyle  legend           none}
	{cmd:margin     legend           "5 0 0 0"}
	{hline 3} End scheme-mine.scheme {hline 28}

{p 3 3 2}
The first two lines are simply comments to help us identify our scheme later.
Note that in scheme files, comments can only be entered as entire lines and
the lines must begin with a "*".  The third line is just a fancy comment that
identifies the version number of our scheme and the date it was last updated.

{p 3 3 2}
The line {cmd:#include s2color} includes the entire contents of the official
{cmd:s2color} scheme in our scheme.  Again, this is just the starting point
for our changes.

{p 3 3 2}
As in {cmd:simple}, the line {cmd:color background  white} sets the background
color to white.  Similarly, the line 
{bind:{cmd:color major_grid "200 200 200"}} specifies that grid lines be drawn
in a light shade of gray.  Here we are using an RGB value rather than a named
{help colorstyle}; see section 2.  For more entries relating to grid lines, see
{help scheme grids}.

{p 3 3 2}
The next two entries,

	{cmd:color p1          "  0 255   0"}
	{cmd:color p2          magenta}

{p 3 3 2}
change how the first two plots look.  The first entry changes the color of the
first plot to a bright green using the RGB value {cmd:"0 255 0"}.  Note that
the extra spacing is not required in the RGB value; it is only there to make
the entries align nicely in the file.  The second entry changes the color of
the second plot to magenta using the named {help colorstyle} {cmd:magenta}.

{p 3 3 2}
The {cmd:anglestyle vertical_tick horizontal} entry changes the angle of text
used to label the ticks on the y axis (designated by {cmd:vertical_tick}) to
be {cmd:horizontal} so that they are not turned "sideways" as they are in the
{cmd:s2color} scheme.  See {help scheme axes} for more entries relating to
axes.

{p 3 3 2}
The last four entries change where and how legends are displayed.  The 
{bind:{cmd:clockdir legend_position 4}} entry moves the legend from its
default position at the bottom of the graph to 4 o'clock {c -} the right of the
graph and aligned with the bottom of the graph.  
{bind:{cmd:numstyle legend_cols 1}} changes the default number of columns in
the legend from 2 to 1, while {bind:{cmd:linestyle legend none}} turns off the
outlining around the legend.  Finally, {bind:{cmd:margin legend "5 0 0 0"}},
designates a small margin, {cmd:5}% of the graph size, to the left of the legend
with no margin ({cmd:0}) to the right, top, or bottom.  Find out more about
these entries and other legend settings at {help scheme legends}.

{p 3 3 2}
In 10 lines, we have changed quite a bit about how graphs drawn with our
scheme will look.  You can click {stata scm_mine:here} to create a copy of
{cmd:scheme-mine.scheme} in your current working directory, and then you
can draw some graphs using the new scheme.  For starters try

{p 8 10 0}. {stata sysuse auto}{p_end}
{p 8 10 0}. {stata scatter trunk turn weight, scheme(s2color)}{p_end}
{p 8 10 0}. {stata scatter trunk turn weight, scheme(mine)}{p_end}

{p 3 3 2}
and compare the difference.  Try drawing some other bar graphs or others with
the new scheme.


{marker remarks6}{...}
{title:Suggestions}

{p 3 3 2}
The first and best suggestion is to try it.  The base scheme file for graphics, 
{cmd:scheme-s2color.scheme} has over 1,700 entries.  Because composite entries 
often change the effect of other entries (see section 4), the entry 
descriptions in {help scheme entries} at best indicate what 
will happen if you base your new scheme on {cmd:s2color}; if you base it on
another scheme, you may need to experiment to get the desired effects.

{p 3 3 2}
It is also a good idea to build your new scheme in small steps while checking 
the results on a graph.  Draw a graph that has all the elements you want 
to control: perhaps axes, legends, or even the third scatter plot.  Then
create your scheme file and place a {cmd:#include} statement to base your
scheme on an existing scheme.  Now redraw your graph using your new, but
empty, scheme using the {cmd:scheme({it:your_scheme})} option.  Now add
one entry to your scheme, issue the {cmd:discard} command, redraw 
the graph by reissuing the graph command, and observe the result.  Then, 
make changes to the entry, if desired; or, move on to the next element you 
want to change.  This is how {cmd:scheme-mine.scheme} was created.  In 
particular, we did not know exactly how all the changes to the legends 
would look, and we altered several entries after seeing the initial results.

{p 3 3 2}
It is critical that you issue the {cmd:discard} command each time before you
reissue your graph command.  {cmd:discard} reinitializes the graphics
system, and that includes clearing the graphics scheme.  If you do not
type {cmd:discard}, {cmd:graph} will note that you are using the
same scheme each time and will use the already loaded scheme {c -} 
ignoring the changes you made in the scheme file.
{p_end}
