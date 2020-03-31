{smcl}
{* *! version 1.0.5  11feb2011}{...}
{viewerjumpto "Set graphics preferences" "gprefs##prefs"}{...}
{viewerjumpto "Description" "gprefs##description"}{...}
{viewerjumpto "Examples" "gprefs##examples"}{...}
{title:Out-of-date command}

{pstd}
This help file is related to the {hi:old} version of Stata's {cmd:graph}
command.  See {manhelp graph G-2} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {manhelp version P}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{marker prefs}{...}
{title:Set graphics preferences}

{p 8 15 2}{cmd:gprefs} {cmdab:q:uery} {cmd:window}

{p 8 15 2}{cmd:gprefs} {cmd:set} {cmd:window} {cmd:scheme}
{c -(} {cmdab:black:bg} | {cmdab:white:bg} | {cmdab:mono:chrome} |
{cmd:custom1} | {cmd:custom2} | {cmd:custom3} {c )-}

{p 8 15 2}{cmd:gprefs} {cmd:set} {cmd:window} {cmd:usegphsize}
{c -(} {cmd:on} | {cmd:off} {c )-}

{p 8 15 2}{cmd:gprefs} {cmd:set} {cmd:window}
{c -(} {cmd:ysize} | {cmd:xsize} {c )-}
{it:#}{cmd:.}{it:#}

{p 8 15 2}{cmd:gprefs} {cmd:set} {cmd:window} {cmd:displaythick}
{c -(} {cmd:off} | {cmd:on} {c )-}

{p 8 15 2}{cmd:gprefs} {cmd:set} {cmd:window} {cmd:update}


{p 8 15 2}{cmd:gprefs} {cmdab:q:uery} {it:scheme}

{p 8 15 2}{cmd:gprefs} {cmd:set} {it:scheme} {cmd:background_color}
{it:#r #g #b}

{p 8 15 2}{cmd:gprefs} {cmd:set} {it:scheme} {cmd:pen}{it:#}{cmd:_color}
{it:#r #g #b}

{p 8 15 2}{cmd:gprefs} {cmd:set} {it:scheme} {cmd:pen}{it:#}{cmd:_thick}
{it:#t}

{p 8 15 2}{cmd:gprefs} {cmd:set} {it:scheme}
{c -(} {cmd:symmag_}{it:sym} | {cmd:symmag_all} {c )-} {it:#m}


{p 4 12 2}{it:#}{cmd:.}{it:#} is measured in inches.{p_end}
{p 4 12 2}{it:scheme} stands for {cmd:custom1}, {cmd:custom2}, or
	{cmd:custom3}.{p_end}
{p 4 12 2}{it:#r #g #b} stand for red, green, and blue intensity values,
	0 <= {it:#} <= 255.{p_end}
{p 4 12 2}{it:#t} stands for a thickness, 1 <= {it:#} <= 9, for which 1 is the
	usual and default value.{p_end}
{p 4 12 2}{it:#m} stands for a magnification value, 1 <= {it:#} <= 500, for
	which 100 is the usual and default value.{p_end}


{marker description}{...}
{title:Description}

{p 4 4 2}
See {helpb graph7} for an overview of Stata's old graphics system and the
old {cmd:graph} command.  See {manhelp graph G-2} for the modern version of
{cmd:graph}.

{p 4 4 2}
{cmd:gprefs} sets graph preferences for the old graphics system.  Set
preferences will be remembered from one Stata session to the next.

{p 4 4 2}
The graphs that appear on your monitor appear in a certain rendition.  The
rendition determines things such as background color, plotting symbol size
relative to the rest of the graph, etc.  The {cmd:gprefs set window scheme}
command specifies the rendition scheme to be used when graphs are rendered.

{p 4 4 2}
There are six schemes to choose from: three that are prerecorded and fixed
({cmd:blackbg}, {cmd:whitebg}, and {cmd:monochrome}) and three more that you
can tailor to your taste ({cmd:custom1}, {cmd:custom2}, and {cmd:custom3}).

{p 4 4 2}
If you choose {cmd:custom1}, {cmd:custom2}, or {cmd:custom3}, there are
lots more settings you can specify with the {cmd:gprefs set} {it:scheme}
command, where {it:scheme} stands for {cmd:custom1}, {cmd:custom2}, or
{cmd:custom3}.  How many settings there are is truly impressive and perhaps
a little overwhelming.  The {cmd:gprefs query} {it:scheme} command will
show all the settable parameters.  Each of these parameters is customizable.

{p 4 4 2}
These customizable parameters fall into four categories.

{p 4 4 2}
First, there is the background color for the graph, set by
{cmd:gprefs set} {it:scheme} {cmd:background_color} {it:#r #g #b}.  The three
numbers refer to red, green, and blue values (RGB values) and are coded on a
scale of 0 to 255, fully off to fully on.

{p 4 4 2}
Second, there is the color of the nine graphics pens, set by
{cmd:gprefs set} {it:scheme} {cmd:pen}{it:#}{cmd:_color} {it:#r #g #b}.
The three numbers are, just as before, RGB values.  Remember that Stata draws
graphs using pen 1 for text, pen 2 for the first variable, pen 3 for the
second, and so on.

{p 4 4 2}
Third, there is the thickness of the nine graphic pens, set by
{cmd:gprefs set} {it:scheme} {cmd:pen}{it:#}{cmd:_thick} {it:#t}.
The number {it:#t} is a thickness value measured from 1 to 9, thinnest to
thickest.

{p 4 4 2}
Fourth and finally, there is the size of the plotting symbols relative to
the rest of the graph, set by
{cmd:gprefs set} {it:scheme} {cmd:symmag_}{it:sym} {it:#m}.
The number {it:#m} is a magnification factor recorded in percent; 100 means
"usual" size, 200 means twice that size, and 50 means half that size.  You
can set the sizes for the symbols individually, and you can set an overall
symbol size using
{cmd:gprefs set} {it:scheme} {cmd:symmag_all} {it:#m}.
Both are applied.  For instance, if the overall symbol size were set to 200
and an individual symbol scaled at 50, then the result would be to show the
symbol at size 100.

{p 4 4 2}
In addition, there are four settings you make outside of the schemes,
known as {cmd:usegphsize}, {cmd:xsize}, {cmd:ysize}, and {cmd:displaythick},
which group into two categories: ({cmd:usegphsize}, {cmd:xsize}, {cmd:ysize})
and ({cmd:displaythick}).

{p 4 4 2}
{cmd:usegphsize}, set by
{cmd:gprefs set window usegphsize}, determines whether the "size" of the
graph is to be determined by the graph itself or if you are going to override
it with your own size.  Setting {cmd:xsize} and {cmd:ysize} gives you that
control.

{p 4 4 2}
Finally, there is {cmd:displaythick}, which is set to {cmd:off} by default.
The scheme records the thicknesses associated with each pen -- a very useful
feature when it comes to printing.  Given the relatively low resolutions of
screens, however, we have found that graphs look better on monitors if those
thicknesses are ignored and all pens are set to be one screen pixel wide.  If
you set {cmd:displaythick on}, Stata will honor the thickness settings you
have made.


{marker examples}{...}
{title:Examples}

{p 4 4 2}
Set your graphics rendition scheme to {cmd:blackbg} (our favorite).

{p 8 12 2}{cmd:. gprefs set window scheme blackbg}{p_end}
{p 8 12 2}{cmd:. gprefs set window update}

{p 4 4 2}
Look at a custom scheme without setting it.

{p 8 12 2}{cmd:. gprefs query custom1}{p_end}
