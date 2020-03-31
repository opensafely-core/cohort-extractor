{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7other}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:{cmd:graph7} command -- saving, printing, and multiple image options}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}] [{cmd:,} {it:graph_type} {it:specific_options}
{it:common_options}]

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-} {cmd:using}
{it:filename} [{it:filename ...}] [{cmd:,} {it:graph_using_options}]


{p 4 4 2}
{cmd:by} is allowed; see {helpb by}.

{p 4 4 2}
The saving, printing, and multiple image {it:common_options} for
{cmd:graph7} are

{p 8 8 2}
{cmdab:sa:ving:(}{it:filename}[{cmd:,replace}]{cmd:)}
{cmd:by(}{it:varname}{cmd:)}
{cmdab:to:tal}
{cmdab:bs:ize:(}{it:#}{cmd:)}
{cmdab:R:escale}
{cmdab:xsiz:e:(}{it:#}{cmd:)}
{cmdab:ysiz:e:(}{it:#}{cmd:)}

{p 4 4 2}
The {it:graph_using_options} for {cmd:graph7 using} are

{p 8 8 2}
{cmdab:sa:ving:(}{it:filename}[{cmd:,replace}]{cmd:)}
{cmd:margin(}{it:#}{cmd:)}
{cmdab:ti:tle:("}{it:text}{cmd:")}
{cmdab:t1:title:("}{it:text}{cmd:")}
{cmdab:t2:title:("}{it:text}{cmd:")}
{cmdab:b1:title:("}{it:text}{cmd:")}
{cmdab:b2:title:("}{it:text}{cmd:")}
{cmdab:l1:title:("}{it:text}{cmd:")}
{cmdab:l2:title:("}{it:text}{cmd:")}
{cmdab:r1:title:("}{it:text}{cmd:")}
{cmdab:r2:title:("}{it:text}{cmd:")}


{p 4 4 2}
Information on the {cmd:graph7} command and the different {it:graph_types}
is found in {helpb graph7}.  this entry details the saving, printing, and
multiple image {it:common_options} and {it:graph_using_options}.  Help for the
other {it:common_options} is also available.  See {help gr7axes} for title
and axes; {help gr7sym} for symbols and lines; {help gr7color} for
color and shading.


{title:Options}

{p 4 8 2}{cmd:saving(}{it:filename}[{cmd:,replace}]{cmd:)} saves the graph in a
file that can be reviewed by {cmd:graph7 using} (see {helpb graph7}) and
printed with {cmd:print}.  If you do not specify an extension, {cmd:.gph} will
be assumed.

{p 4 8 2}{cmd:by(}{it:varname}{cmd:)} is allowed with all styles except
{cmd:matrix} and {cmd:star}.  It requests that graphs be drawn separately for
the groups defined by {it:varname} and combined in one image.
"{cmd:graph7 y x, by(region)}" would draw one graph for each value of region
and array them on the screen.

{p 8 8 2}With {cmd:bar} (see {help gr7bar}) and {cmd:box} (see
{help gr7box}), {cmd:by()} draws one axis and then groups the bars or
boxes according to {it:varname}.  "{cmd:graph7 y x, by(region) box}" would draw
8 boxes if region took on four different values.

{p 4 8 2}{cmd:total} may be specified only with {cmd:by()}.  It requests that an
additional group be added reflecting all the data.  If region takes on four
values, "{cmd:graph7 y x, by(region) total}" would draw 5 graphs in one image,
one for each region and one more for all four regions combined.

{p 4 8 2}{cmd:bsize(}{it:#}{cmd:)} specifies the size of the text to be used to
label the by-groups, with 100 (meaning 100% of normal) being the
default.  {cmd:bsize(150)} would increase the size of the labels, whereas
{cmd:bsize(75)} would decrease them.  {cmd:bsize()} is also used with
{cmd:star} (see {help gr7star}) to set the text size of the observation
titles.  Also see the {cmd:set textsize} command in {helpb graph7}.

{p 4 8 2}{cmd:Rescale} (note capitalization) is used only in combination with
{cmd:by()}.  It requests that each by-group graph have its own scale.  The
default is to use the same scale across all graphs.

{p 4 8 2}{cmd:xsize(}{it:#}{cmd:)} specifies the width, in inches, for printing
the image.  The default is 6 inches and can range from 1 to 20.

{p 4 8 2}{cmd:ysize(}{it:#}{cmd:)} specifies the height, in inches, for printing
the image.  The default is 4 inches and can range from 1 to 20.

{p 4 8 2}{cmd:margin(}{it:#}{cmd:)} is unique to {cmd:graph7 using} and
specifies the margin to be placed around each graph as a percent of graphical
area.  The default is 0.  {cmd:margin(15)} is generally a good selection.

{p 4 8 2}{cmd:title("}{it:text}{cmd:")}, {cmd:t1title("}{it:text}{cmd:")},
{cmd:t2title("}{it:text}{cmd:")}, {cmd:b1title("}{it:text}{cmd:")},
{cmd:b2title("}{it:text}{cmd:")}, {cmd:l1title("}{it:text}{cmd:")},
{cmd:l2title("}{it:text}{cmd:")}, {cmd:r1title("}{it:text}{cmd:")}, and
{cmd:r2title("}{it:text}{cmd:")} add titles to the graph and are detailed in
{help gr7axes}.  With {cmd:graph7 using} these options can add titles to a
graph after it is originally produced.  They also provide marginal titles when
combining several graphs.


{title:Also see}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7bar},
{help gr7box}, {help gr7color}, {help gr7hist},
{help gr7matrix}, {help gr7oneway},
{help gr7pie}, {help gr7star}, {help gr7sym}, {help gr7twoway}
{p_end}
