{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7color}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:{cmd:graph7} command common options -- color and shading options}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}] [{cmd:,} {it:graph_type} {it:specific_options}
{it:common_options}]


{p 4 4 2}The color and shading {it:common_options} are

{p 8 8 2}
{cmdab:pe:n:(}{it:#...#}{cmd:)}
{cmdab:sh:ading:(}{it:#...#}{cmd:)}


{p 4 4 2}
{cmd:by} is allowed; see {helpb by}.

{p 4 4 2}
Information on the {cmd:graph7} command and the different {it:graph_types}
is found in {helpb graph7}.  This entry details the color and shading
{it:common_options}.  Help for the other {it:common_options} is also
available.  See {help gr7axes} for title and axes; {help gr7sym} for
symbols and lines; {help gr7other} for saving, printing, and multiple
images.


{title:Options}

{p 4 8 2}{cmd:pen(}{it:#...#}{cmd:)} specifies the pen to be used for each
graphical element.  Spaces are not allowed between specified pen numbers.  All
graphs are drawn with a theoretical concept called a pen.  On color monitors,
different pens are mapped to different colors.  On monochrome monitors, all
pens look alike (except pen 1 is sometimes dimmer than the others).  When you
print a graph on monochrome devices, the thicknesses of the pens can be
altered.  On color printers, different colors can be assigned.

{p 8 8 2}Pens are numbered 1 through 9.  {cmd:graph7} uses pen 1 for labeling.
Thereafter, each graphical element, corresponding to the variables in the
{it:varlist}, are graphed using successively higher numbered pens, wrapping
back to pen 2 after pen 9.

	Examples:
{p 12 16 2}"{cmd:graph7 y1 y2 x}" graphs y1 vs. x using pen 2 and y2 vs. x using
pen 3.{p_end}
{p 12 16 2}"{cmd:graph7 y1 y2 x, pen(23)}" does the same thing.{p_end}
{p 12 16 2}"{cmd:graph7 y1 y2 x, pen(22)}" graphs both series using the same pen.

{p 4 8 2}{cmd:shading(}{it:#...#}{cmd:)} specifies the amount of shading on a
scale of 1 to 4, with 1 being the lightest and 4 the darkest.  Spaces are not
allowed between specified shading numbers.  {cmd:shading()} is allowed with
{cmd:histogram} (see {help gr7hist}), {cmd:bar} (see {help gr7bar}),
and {cmd:pie} (see {help gr7pie}).  For {cmd:histogram}, only one number
is specified and the default value is {cmd:3}.  For {cmd:bar} and {cmd:pie}, a
shading value is specified for each variable.  The default is
{cmd:31423142}{it:...}

	Examples:
{p 12 16 2}{cmd:. graph7 x, hist shading(4)}{p_end}
{p 12 16 2}{cmd:. graph7 a b c, bar shading(413)}{p_end}
{p 12 16 2}{cmd:. graph7 a b c d e, pie shading(41324)}


{title:Also see}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7bar},
{help gr7box}, {help gr7hist}, {help gr7matrix},
{help gr7oneway}, {help gr7other},
{help gr7pie}, {help gr7star}, {help gr7sym}, {help gr7twoway}
{p_end}
