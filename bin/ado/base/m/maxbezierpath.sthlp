{smcl}
{* *! version 1.0.0  31jul2019}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "maxbezierpath##syntax"}{...}
{viewerjumpto "Description" "maxbezierpath##description"}{...}
{viewerjumpto "Option" "maxbezierpath##option"}{...}
{title:Title}

{phang}
Set the maximum number of lines that can be added to a B{c e'}zier path
(Mac only)


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:set} {opt maxbez:ierpath}
{it:#}
[{cmd:,}
{opt perm:anently}
]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set maxbezierpath} sets the maximum number of lines that can be added to
a B{c e'}zier path when rendering a Stata graph to the screen.  This command
applies only to Macs and will be of interest to users who plot connected lines
with thousands of points.  
{cmd:maxbezierpath} also affects exporting to PDF and PNG formats; it does not
affect exporting to EPS and SVG formats.

{pstd}
When graphing a plot with a connected line, Stata adds all the points from the
line to a B{c e'}zier path and then renders the path.  This allows the line to
be rendered in a single color, which is important if the color has
transparency.  The line can also be selected as a single object when exported
into a third-party editor.  However, rendering a path containing many
points to the screen can be extremely slow on Macs.  It is much
faster to render the connected line as a series of separate lines rather than
as a single path, but if the line color has transparency, you will see color
artifacts where the separate lines overlap.

{pstd}
To improve the performance of rendering a connected line, Stata for Mac can
render the connected line as a series of small B{c e'}zier paths that contain
{cmd:maxbezierpath} number of lines.  However, the connected line will no
longer be selectable as a single object in third-party editors, and you may see
color artifacts where the smaller B{c e'}zier paths overlap if the connected
line color has transparency.

{pstd}
You can set {cmd:maxbezierpath} to a small value, such as 1, to draw connected
lines at maximum performance, but it is not recommended when using a
transparent line color.  Stata for Mac will always use this faster method for
rendering a connected line to the screen if the line has no transparency, regardless of the value of
{cmd:maxbezierpath}.  

{pstd}
Setting
{cmd:maxbezierpath} to 0 will render the connected line as a single B{c e'}zier
path and is appropriate for most graphs.  The default value for
{cmd:maxbezierpath} is 0.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
