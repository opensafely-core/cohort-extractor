{smcl}
{* *! version 1.1.13  15oct2018}{...}
{vieweralsosee "[G-4] Schemes intro" "mansection G-4 Schemesintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] set scheme" "help set_scheme"}{...}
{vieweralsosee "[G-3] scheme_option" "help scheme_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Scheme economist" "help scheme_economist"}{...}
{vieweralsosee "[G-4] Scheme s1" "help scheme_s1"}{...}
{vieweralsosee "[G-4] Scheme s2" "help scheme_s2"}{...}
{vieweralsosee "[G-4] Scheme sj" "help scheme_sj"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{viewerjumpto "Syntax" "schemes_intro##syntax"}{...}
{viewerjumpto "Description" "schemes_intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "schemes##linkspdf"}{...}
{viewerjumpto "Remarks" "schemes_intro##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-4] Schemes intro} {hline 2}}Introduction to schemes{p_end}
{p2col:}({mansection G-4 Schemesintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:scheme}
{it:schemename}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmdab:gr:aph}
...
[{cmd:,}
...
{cmd:scheme(}{it:schemename}{cmd:)}
...]

	{it:schemename}{col 21}Foreground{col 34}Background{col 46}Description
	{hline 71}
	{bf:{help scheme s2:s2color}}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}{bf:factory setting}
{...}
	{bf:{help scheme s2:s2mono}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{cmd:s2color} in monochrome
{...}
	{bf:{help scheme s2:s2gcolor}}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}used in the Stata manuals
	{bf:{help scheme s2:s2manual}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{cmd:s2gcolor} in monochrome
	{bf:{help scheme s2:s2gmanual}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}previously used in the [G] manual


	{bf:{help scheme s1:s1rcolor}}{...}
{col 21}color{...}
{col 34}black{...}
{col 46}a plain look on black background
{...}
	{bf:{help scheme s1:s1color}}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}a plain look
{...}
	{bf:{help scheme s1:s1mono}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}a plain look in monochrome
{...}
	{bf:{help scheme s1:s1manual}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{cmd:s1mono} but smaller

	{help scheme economist:{bf:economist}}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}{it:The Economist} magazine
	{help scheme sj:{bf:sj}}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{it:Stata Journal}
	{hline 71}

{pin}
Other {it:schemenames} may be available; type

	    {cmd:.} {bf:{stata graph query, schemes}}

{pin}
to obtain the complete list of schemes installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A scheme specifies the overall look of the graph.

{pstd}
{cmd:set} {cmd:scheme} sets the default scheme; see
{manhelp set_scheme G-2:set scheme} for more information about this command.

{pstd}
Option {cmd:scheme()} specifies the graphics scheme to be used with this
particular {cmd:graph} command without changing the default.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 SchemesintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help schemes##remarks1:The role of schemes}
	{help schemes##remarks2:Finding out about other schemes}
	{help schemes##remarks3:Setting your default scheme}
	{help schemes##remarks4:The scheme is applied at display time}
	{help schemes##remarks5:Background color}
	{help schemes##remarks6:Foreground color}
	{help schemes##remarks7:Obtaining new schemes}
	{help schemes##remarks8:Examples of schemes}

{pstd}
See {help scheme files} for a discussion of how to create your own schemes.


{marker remarks1}{...}
{title:The role of schemes}

{pstd}
When you type, for instance,

	{cmd:. scatter yvar xvar}

{pstd}
results are the same as if you typed

{phang2}
	{cmd:. scatter yvar xvar, scheme(}{it:your_default_scheme}{cmd:)}

{pstd}
If you have not used the {cmd:set scheme} command to change your default
scheme, {it:your_default_scheme} is {cmd:s2color}.

{pstd}
The scheme specifies the overall look for the graph, and by that
we mean just about everything you can imagine.  It determines such 
things as whether {it:y} axes are on the left or the right, how many 
values are by default labeled on the axes, and the colors that are 
used.  In fact, almost every statement made in other parts of this manual
stating how something appears, or the relationship between how things
appear, must not be taken too literally.  How things appear is in fact
controlled by the scheme:

{p 8 11 2}
o{space 2}In {manhelpi symbolstyle G-4}, we state that markers -- the
ink that denotes the position of points on a plot -- have a default size
of {cmd:msize(medium)} and that small symbols have a size of
{cmd:msize(small)}.  That is generally true, but the size of the markers is in
fact set by the scheme, and a scheme might specify different default sizes.

{p 8 11 2}
o{space 2}In {manhelpi axis_choice_options G-3}, we state that when
there is one {it:y axis}, which appears on the left, and when there are two,
the second appears on the right.  What is in fact true is that where axes
appear is controlled by the scheme and that most schemes work the way
described.  Another scheme named {cmd:economist}, however, displays things
differently.

{p 8 11 2}
o{space 2}In {manhelpi title_options G-3}, we state where the titles,
subtitles, etc., appear, and we provide a diagram so that there can be no
confusion.  But where the titles, subtitles, etc., appear is in fact 
controlled by the scheme, and what we have described is what is true for 
the scheme named {cmd:s2color}.

{pstd}
The list goes on and on.
If it has to do with the look of the result, it is controlled by the scheme.

{pstd}
To understand just how much difference the
scheme can make, you should type

	{cmd:. scatter yvar xvar, scheme(economist)}

{pstd}
{cmd:scheme(economist)} specifies a look similar to that used by
{it:{browse "https://www.economist.com":The Economist}}
magazine (https://www.economist.com) , whose graphs we believe to be worthy of
emulation.  By comparison with the {cmd:c2color} scheme, the {cmd:economist}
scheme moves {it:y} axes to the right, makes titles left justified, defaults
grid lines to be on, sets a background color, and moves the note to the top
right and expects it to be a number.


{marker remarks2}{...}
{title:Finding out about other schemes}

{pstd}
A list of schemes is provided in the syntax diagram above, but do not
rely on the list being up to date.  Instead, type

	{cmd:.} {bf:{stata graph query, schemes}}

{pstd}
to obtain the complete list of schemes installed on your computer.

{pstd}
Try drawing a few graphs with each:

{phang2}
	{cmd:. graph} ... {cmd:,} ... {cmd:scheme(}{it:schemename}{cmd:)}


{marker remarks3}{...}
{title:Setting your default scheme}

{pstd}
If you want to set your default scheme to, say, {cmd:economist}, type

	{cmd:. set scheme economist}

{pstd}
The {cmd:economist} scheme will now be your default scheme for the rest of this
session, but the next time you use Stata, you will be back to using your old
default scheme.  If you type

	{cmd:. set scheme economist, permanently}

{pstd}
{cmd:economist} will become your default scheme both for the rest of
this session and in future sessions.

{pstd}
If you want to change your scheme back to {cmd:s2color} -- the default
scheme in Stata as originally shipped -- type

	{cmd:. set scheme default, permanently}

{pstd}
See {manhelp set_scheme G-2:set scheme}.


{marker remarks4}{...}
{title:The scheme is applied at display time}

{pstd}
Say that you type

	{cmd:. graph mpg weight, saving(mygraph)}

{pstd}
to create and save the file {cmd:mygraph.gph} (see 
{manhelpi saving_option G-3}).
If later you redisplay the graph by typing

	{cmd:. graph use mygraph}

{pstd}
the graph will reappear as you originally drew it.  It will be displayed
using the same scheme with which it was originally drawn, regardless of
your current {cmd:set scheme} setting.  If you type

	{cmd:. graph use mygraph, scheme(economist)}

{pstd}
the graph will be displayed using the {cmd:economist} scheme.  It will be
the same graph but will look different.  You can change the scheme with
which a graph is drawn beforehand, on the original {cmd:graph}
command, or later.


{marker remarks5}{...}
{title:Background color}

{pstd}
In the table at the beginning of the entry, we characterize the background
color as being white or black, although actually what we mean is light or
dark because some of the schemes set background tinting.  We mean that 
"white" background schemes are suitable for printing.  Printers (both the
mechanical ones and the human ones) prefer that you avoid dark backgrounds
because of the large amounts of ink required and the corresponding
problems with bleed-through.  On the other hand, dark backgrounds look 
good on monitors.

{pstd}
In any case, you may change the background color of a scheme by using the
{it:region_options}
{cmd:graphregion(fcolor())},
{cmd:graphregion(ifcolor())},
{cmd:plotregion(fcolor())}, and
{cmd:plotregion(ifcolor())}; see
{manhelpi region_options G-3}.
When overriding the background color, choose light colors for schemes that
naturally have white backgrounds and dark colors for regions that 
naturally have black backgrounds.

{pstd}
Schemes that naturally have a black background are by default printed in
monochrome.  See {manhelp set_printcolor G-2: set printcolor} if you wish to
override this.

{pstd}
If you are producing graphs for printing on white paper, we suggest that you
choose a scheme with a naturally white background.


{marker remarks6}{...}
{title:Foreground color}

{pstd}
In the table at the beginning of this entry, we categorized the foreground as
being color or monochrome.  This refers to whether lines, markers, fills, etc.,
are presented by default in color or monochrome.  Regardless of the scheme you
choose, you can specify options such as {cmd:mcolor()} and {cmd:lcolor()},
to control the color for each item on the graph.

{pstd}
Just because we categorized the foreground as monochrome, this does not mean that
you cannot specify colors in the options.


{marker remarks7}{...}
{title:Obtaining new schemes}

{pstd}
Your copy of Stata may already have schemes other than those documented in
this help file.  To find out, type

	{cmd:.} {bf:{stata graph query, schemes}}

{pstd}
Also, new schemes are added and existing schemes updated along with
all the rest of Stata, so if you are connected to the Internet, type

	{cmd:.} {bf:{stata update query}}

{pstd}
and follow any instructions given; see {manhelp update R}.

{pstd}
Finally, other users may have created schemes that could be of interest
to you.  To search the Internet, type

	{cmd:.} {bf:{search scheme:search scheme}}
	  {it:(will display results in Viewer;}
	  {it: use Back button to return to this help file)}

{pstd}
From there, you will be able to click to install any schemes that interest
you; see {manhelp search R}.

{pstd}
Once a scheme is installed, which can be determined by verifying that it appears
in the list shown by

	{cmd:.} {bf:{stata graph query, schemes}}

{pstd}
you can use it with the {cmd:scheme()} option

{phang2}
	{cmd:. graph} ...{cmd:,} ... {cmd:scheme(}{it:newscheme}{cmd:)}

{pstd}
or you can set it as your default, temporarily

	{cmd:. set scheme} {it:newscheme}

{pstd}
or permanently

	{cmd:. set scheme} {it:newscheme}{cmd:, permanently}


{marker remarks8}{...}
{title:Examples of schemes}

{pstd}
See
{mansection G-4 SchemesintroRemarksandexamplesExamplesofschemes:{it:Examples of schemes}}
in {it:Remarks and examples} of {bf:[G-4] Schemes intro} for graphs with
the various schemes.
{p_end}
