{smcl}
{* *! version 1.2.6  07dec2018}{...}
{vieweralsosee "[G-4] colorstyle" "mansection G-4 colorstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] palette" "help palette"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{viewerjumpto "Syntax" "colorstyle##syntax"}{...}
{viewerjumpto "Description" "colorstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "colorstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "colorstyle##remarks"}{...}
{viewerjumpto "Video example" "colorstyle##video"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-4]} {it:colorstyle} {hline 2}}Choices for color{p_end}
{p2col:}({mansection G-4 colorstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Set color of <{it:object}> to {it:colorstyle}

{p 8 16 2}
<{it:object}>{opth color:(colorstyle##colorstyle:colorstyle)}


{pstd}
Set color of all affected objects to {it:colorstyle}

{p 8 16 2}
{opth color:(colorstyle##colorstyle:colorstyle)}


{pstd}
Set opacity of <{it:object}> to {it:#}, where {it:#} is a percentage
of 100% opacity

{p 8 16 2}
<{it:object}>{opt color(%#)}


{pstd}
Set opacity for all affected objects colors to {it:#}

{p 8 16 2}
{opt color(%#)}


{pstd}
Set both color and opacity of <{it:object}>

{p 8 16 2}
<{it:object}>{cmd:color(}{it:{help colorstyle##colorstyle:colorstyle}}{cmd:%}{it:#}{cmd:)}


{pstd}
Set both color and opacity of all affected objects

{p 8 16 2}
<{it:object}>{cmd:color(}{it:{help colorstyle##colorstyle:colorstyle}}{cmd:%}{it:#}{cmd:)}


{marker colorstyle}{...}
{synoptset 20}{...}
{p2col:{it:colorstyle}}Description{p_end}
{p2line}
{p2col:{cmd:black}}{p_end}
{p2col:{cmd:gs0}}gray scale:  0 = {cmd:black}{p_end}
{p2col:{cmd:gs1}}gray scale:  very dark gray{p_end}
{p2col:{cmd:gs2}}{p_end}
{p2col:.}{p_end}
{p2col:.}{p_end}
{p2col:{cmd:gs15}}gray scale:  very light gray{p_end}
{p2col:{cmd:gs16}}gray scale:  16 = {cmd:white}{p_end}
{p2col:{cmd:white}}{p_end}

{p2col:{cmd:blue}}{p_end}
{p2col:{cmd:bluishgray}}{p_end}
{p2col:{cmd:brown}}{p_end}
{p2col:{cmd:cranberry}}{p_end}
{p2col:{cmd:cyan}}{p_end}
{p2col:{cmd:dimgray}}between {cmd:gs14} and {cmd:gs15}{p_end}
{p2col:{cmd:dkgreen}}dark green{p_end}
{p2col:{cmd:dknavy}}dark navy blue{p_end}
{p2col:{cmd:dkorange}}dark orange{p_end}
{p2col:{cmd:eggshell}}{p_end}
{p2col:{cmd:emerald}}{p_end}
{p2col:{cmd:forest_green}}{p_end}
{p2col:{cmd:gold}}{p_end}
{p2col:{cmd:gray}}equivalent to {cmd:gs8}{p_end}
{p2col:{cmd:green}}{p_end}
{p2col:{cmd:khaki}}{p_end}
{p2col:{cmd:lavender}}{p_end}
{p2col:{cmd:lime}}{p_end}
{p2col:{cmd:ltblue}}light blue{p_end}
{p2col:{cmd:ltbluishgray}}light blue-gray, used by scheme {cmd:s2color}{p_end}
{p2col:{cmd:ltkhaki}}light khaki{p_end}
{p2col:{cmd:magenta}}{p_end}
{p2col:{cmd:maroon}}{p_end}
{p2col:{cmd:midblue}}{p_end}
{p2col:{cmd:midgreen}}{p_end}
{p2col:{cmd:mint}}{p_end}
{p2col:{cmd:navy}}{p_end}
{p2col:{cmd:olive}}{p_end}
{p2col:{cmd:olive_teal}}{p_end}
{p2col:{cmd:orange}}{p_end}
{p2col:{cmd:orange_red}}{p_end}
{p2col:{cmd:pink}}{p_end}
{p2col:{cmd:purple}}{p_end}
{p2col:{cmd:red}}{p_end}
{p2col:{cmd:sand}}{p_end}
{p2col:{cmd:sandb}}bright sand{p_end}
{p2col:{cmd:sienna}}{p_end}
{p2col:{cmd:stone}}{p_end}
{p2col:{cmd:teal}}{p_end}
{p2col:{cmd:yellow}}{p_end}

{p2col:}colors used by {it:The Economist} magazine:{p_end}
{p2col 5 35 37 2:{cmd:ebg}}background color{p_end}
{p2col 5 35 37 2:{cmd:ebblue}}bright blue{p_end}
{p2col 5 35 37 2:{cmd:edkblue}}dark blue{p_end}
{p2col 5 35 37 2:{cmd:eltblue}}light blue{p_end}
{p2col 5 35 37 2:{cmd:eltgreen}}light green{p_end}
{p2col 5 35 37 2:{cmd:emidblue}}midblue{p_end}
{p2col 5 35 37 2:{cmd:erose}}rose{p_end}

{p2col:{cmd:none}}no color; invisible; draws nothing{p_end}
{p2col:{cmd:background} or {cmd:bg}}same color as background{p_end}
{p2col:{cmd:foreground} or {cmd:fg}}same color as foreground{p_end}

{p2col:{cmd:"}{it:# # #}{cmd:"}}RGB value; {cmd:white} = {cmd:"255 255 255"}{p_end}

{p2col:{cmd:"}{it:# # # #}{cmd:"}}CMYK value; {cmd:yellow} = {cmd:"0 0 255 0"}{p_end}

{p2col:{cmd:"hsv} {it:# # #}{cmd:"}}HSV value; {cmd:white} = {cmd:"hsv 0 0 1"}{p_end}

{p2col:{it:color}{cmd:*}{it:#}}color with adjusted intensity{p_end}

{p2col:{cmd:*}{it:#}}default color with adjusted intensity{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
When specifying RGB, CMYK, or HSV values, it is best to enclose the values in
quotes; type {cmd:"128} {cmd:128} {cmd:128"} not {cmd:128} {cmd:128} {cmd:128}.


{marker description}{...}
{title:Description}

{pstd}
{it:colorstyle} sets the color and opacity of graph components such as
lines, backgrounds, and bars.  Some options allow a sequence of
{it:colorstyle}s with {it:colorstylelist}; see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 colorstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:colorstyle} sets the color and opacity of graph components such as
lines, backgrounds, and bars.  Colors can be specified with a named color,
such as {cmd:black}, {cmd:olive}, and {cmd:yellow}, or with a color value in
the RGB, CMYK, or HSV format.  {it:colorstyle} can
also set a component to match the background color or foreground
color.  Additionally, {it:colorstyle} can modify color intensity, making
the color lighter or darker.  Some options allow a sequence of
{it:colorstyle}s with {it:colorstylelist}; see {manhelpi stylelists G-4}.

{pstd}
To see a list of named colors, use {cmd:graph query colorstyle}.  See
{manhelp graph_query G-2:graph query}.  For a color palette showing an
individual color or comparing two colors, use {cmd:palette color}.  See
{manhelp palette G-2}.

{pstd}
Remarks are presented under the following headings:

	{help colorstyle##opacity:Adjust opacity}
	{help colorstyle##intensity:Adjust intensity}
	{help colorstyle##rgb:Specify RGB values}
	{help colorstyle##cmyk:Specify CMYK values}
	{help colorstyle##hsv:Specify HSV values}
	{help colorstyle##export:Export custom colors}


{marker opacity}{...}
{title:Adjust opacity}

{pstd}
Opacity is the percentage of a color that covers the background color.
That is, {cmd:100%} means that the color fully hides the background, and
{cmd:0%} means that the color has no coverage and is fully transparent.
If you prefer to think about transparency, opacity is the inverse of
transparency.  Adjust opacity with the {cmd:%} modifier.  For example, type

	{cmd:green%50}
	{cmd:"0 255 0%50"}
	{cmd:%30}

{pstd}
Omitting the color specification in the command adjusts the opacity of the
object while retaining the default color.  For instance, specify
{cmd:mcolor(%30)} with {cmd:graph} {cmd:twoway} {cmd:scatter} to use the
default fill color at 30% opacity.

{pstd}
Specifying {it:color}{cmd:%0} makes the object completely transparent and is
equivalent to color {cmd:none}.


{marker intensity}{...}
{title:Adjust intensity}

{pstd}
Color intensity (brightness) can be modified by specifying a color, {cmd:*},
and a multiplier value.  For example, type

	{cmd:green*.8}
	{cmd:purple*1.5}
	{cmd:"0 255 255*1.2"}
	{cmd:"hsv 240 1 1*.5"}

{pstd}
A value of 1 leaves the color unchanged, a value greater than 1 makes the
color darker, and a value less than 1 makes the color lighter.  Note that
there is no space between {it:color} and {cmd:*}, even when {it:color}
is a numerical value for RGB or CMYK.

{pstd}
Omitting the color specification in the command adjusts the intensity of the
object's default color.  For instance, specify {cmd:bcolor(*.7)} with
{cmd:graph} {cmd:twoway} {cmd:bar} to use the default fill color at reduced
brightness, or specify {cmd:bcolor(*2)} to increase the brightness of the
default color.

{pstd}
Specifying {it:color}{cmd:*0} makes the color as light as possible, but it is
not equivalent to color {cmd:none}.  {it:color}{cmd:*255} makes the color
as dark as possible, although values much smaller than 255 usually achieve the
same result.

{pstd}
For an example using the intensity adjustment, see
{help twoway kdensity##remarks1:{it:Typical use}} in
{manhelp twoway_kdensity G-2:graph twoway kdensity}.


{marker rgb}{...}
{title:RGB values}

{pstd}
In addition to specifying named colors such as {cmd:yellow}, you can specify
colors with RGB values.  An RGB value is a triplet of numbers ranging from 0
to 255 that describes the level of red, green, and blue light that must be
emitted to produce a given color.  RGB is used to define colors for on-screen
display and in nonprofessional printing.  Examples of RGB values are

	{cmd:red}     =   {cmd:255    0    0}
	{cmd:green}   =   {cmd:  0  255    0}
	{cmd:blue}    =   {cmd:  0    0  255}
	{cmd:white}   =   {cmd:255  255  255}
	{cmd:black}   =   {cmd:  0    0    0}
	{cmd:gray}    =   {cmd:128  128  128}
	{cmd:navy}    =   {cmd: 26   71  111}


{marker cmyk}{...}
{title:CMYK values}

{pstd}
You can specify colors using CMYK values.  You will probably only use CMYK
values when they are provided by a journal or publisher.  You can specify CMYK
values either as integers from 0 to 255 or as proportions of ink using real
numbers from 0.0 to 1.0.  If all four values are 1 or less, the numbers are
taken to be proportions of ink.  For example,

	{cmd:red}     =   {cmd:  0  255  255    0}   or, equivalently,  {cmd:   0     1  1     0}
	{cmd:green}   =   {cmd:255    0  255    0}   or, equivalently,  {cmd:   1     0  1     0}
	{cmd:blue}    =   {cmd:255  255    0    0}   or, equivalently,  {cmd:   1     1  0     0}
	{cmd:white}   =   {cmd:  0    0    0    0}   or, equivalently,  {cmd:   0     0  0     0}
	{cmd:black}   =   {cmd:  0    0    0  255}   or, equivalently,  {cmd:   0     0  0     1}
	{cmd:gray}    =   {cmd:  0    0    0  128}   or, equivalently,  {cmd:   0     0  0    .5}
	{cmd:navy}    =   {cmd: 85   40    0  144}   or, equivalently,  {cmd:.334  .157  0  .565}


{marker hsv}{...}
{title:HSV values}

{pstd}
You can specify colors with HSV (hue, saturation, and value), also called HSL
(hue, saturation, and luminance) and HSB (hue, saturation, and brightness).
HSV is often used in image editing software.  An HSV value is a triplet of
numbers.  So that Stata can differentiate them from RGB values, HSV colors
must be prefaced with {cmd:hsv}.  The first number specifies the hue from 0 to
360, the second number specifies the saturation from 0 to 1, and the third
number specifies the value (luminance or brightness) from 0 to 1.  For
example,

	{cmd:red}     =   {cmd:hsv   0     1     1}
	{cmd:green}   =   {cmd:hsv 120     1  .502}
	{cmd:blue}    =   {cmd:hsv 240     1     1}
	{cmd:white}   =   {cmd:hsv   0     0     1}
	{cmd:black}   =   {cmd:hsv   0     0     0}
	{cmd:navy}    =   {cmd:hsv 209  .766  .435}


{marker export}{...}
{title:Export custom colors}

{pstd}
{cmd:graph export} stores all colors as RGB+opacity values, that is, RGB
values 0-255 and opacity values 0-1.  If you need color values from Stata in
CMYK format, use the {cmd:graph export} command with the {cmd:cmyk(on)}
option, and save the graph in one of the following formats: PostScript,
Encapsulated PostScript, or PDF.

{pstd}
You can set Stata to permanently use CMYK colors for PostScript export
files by typing {cmd:translator set Graph2ps cmyk on} and for
EPS export files by typing {cmd:translator set Graph2eps cmyk on}.

{pstd}
The CMYK values returned in {cmd:graph export} may differ from the
CMYK values that you entered.  This is because Stata normalizes
CMYK values by reducing all CMY values until one value is 0.
The difference is added to the K (black) value.  For example, Stata
normalizes the CMYK value {cmd:10 10 5 0} to {cmd:5 5 0 5}.  Stata
subtracts 5 from the CMY values so that Y is 0 and then adds 5 to K.


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=2bK-WZAcGMo":Transparency in Stata graphs}
{p_end}
