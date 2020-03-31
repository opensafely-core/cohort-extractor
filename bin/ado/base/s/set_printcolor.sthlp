{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[G-2] set printcolor" "mansection G-2 setprintcolor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{viewerjumpto "Syntax" "set_printcolor##syntax"}{...}
{viewerjumpto "Description" "set_printcolor##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_printcolor##linkspdf"}{...}
{viewerjumpto "Option" "set_printcolor##option"}{...}
{viewerjumpto "Remarks" "set_printcolor##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-2] set printcolor} {hline 2}}Set how colors are treated when graphs are printed{p_end}
{p2col:}({mansection G-2 setprintcolor:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:q:uery}
{cmdab:graph:ics}

{p 8 16 2}
{cmd:set}
{cmd:printcolor}
{c -(}{cmdab:auto:matic} |
	{cmd:asis} |
	{cmd:gs1} |
	{cmd:gs2} |
	{cmd:gs3}{c )-}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:copycolor}{space 2}{c -(}{cmdab:auto:matic} |
	{cmd:asis} |
	{cmd:gs1} |
	{cmd:gs2} |
	{cmd:gs3}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:query} {cmd:graphics} shows the graphics settings.

{pstd}
{cmd:set} {cmd:printcolor} determines how colors are handled when graphs
are printed.

{pstd}
{cmd:set} {cmd:copycolor} (Mac and Windows only) determines how
colors are handled when graphs are copied to the clipboard.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 setprintcolorQuickstart:Quick start}

        {mansection G-2 setprintcolorRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently}
specifies that, in addition to making the change right now, the setting 
be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:printcolor} and {cmd:copycolor} can be set one of five
ways:  {cmd:automatic}, {cmd:asis}, and {cmd:gs1}, {cmd:gs2}, or {cmd:gs3}.
Four of the settings -- {cmd:asis} and {cmd:gs1}, {cmd:gs2}, and {cmd:gs3} --
specify how colors should be rendered when graphs are printed or copied.
The remaining setting -- {cmd:automatic} -- specifies that Stata
determine by context whether {cmd:asis} or {cmd:gs1} is used.

{pstd}
In the remarks below, {cmd:copycolor} can be used interchangeably with
{cmd:printcolor}, the only difference being the ultimate destination of the
graph.

{pstd}
Remarks are presented under the following headings:

	{help set printcolor##remarks1:What set printcolor affects}
	{help set printcolor##remarks2:The problem set printcolor solves}
	{help set printcolor##remarks3:set printcolor automatic}
	{help set printcolor##remarks4:set printcolor asis}
	{help set printcolor##remarks5:set printcolor gs1, gs2, and gs3}
	{help set printcolor##remarks6:The scheme matters, not the background color you set}


{marker remarks1}{...}
{title:What set printcolor affects}

{pstd}
{cmd:set} {cmd:printcolor} affects how graphs are printed when you select
{bf:File} > {bf:Print graph} or when you use the {cmd:graph}
{cmd:print} command; see {manhelp graph_print G-2:graph print}.

{pstd}
{cmd:set} {cmd:printcolor} also affects the behavior of the {cmd:graph}
{cmd:export} command when you use it to translate {cmd:.gph} files into
another format such as PostScript; see {manhelp graph_export G-2:graph export}.

{pstd}
We will refer to all the above in what follows as "printing graphs"
or, equivalently, as "rendering graphs".


{marker remarks2}{...}
{title:The problem set printcolor solves}

{pstd}
If you should choose a scheme with a black background -- see
{manhelp schemes G-4:Schemes intro} -- and if you were then to print that graph,
do you really want black ink poured onto the page so that what you get is
exactly what you saw?  Probably not.  The purpose of {cmd:set printcolor} is
to avoid such results.


{marker remarks3}{...}
{title:set printcolor automatic}

{pstd}
{cmd:set} {cmd:printcolor}'s default
setting -- {cmd:automatic} -- looks at the graph to be printed and
determines whether it should be rendered exactly as you see it on the screen
or if instead the colors should be reversed and the graph printed in a
monochrome gray scale.

{pstd}
{cmd:set printcolor} {cmd:automatic} bases its decision on the background
color used by the scheme.  If it is white (or light), the graph is printed
{cmd:asis}.  If it is black (or dark), the graph is printed {cmd:grayscale}.


{marker remarks4}{...}
{title:set printcolor asis}

{pstd}
If you specify {cmd:set printcolor asis}, all graphs will be rendered just
as you see them on the screen, regardless of the background color of the
scheme.


{marker remarks5}{...}
{title:set printcolor gs1, gs2, and gs3}

{pstd}
If you specify {cmd:set printcolor gs1}, {cmd:gs2}, or {cmd:gs3}, all graphs
will be rendered according to a gray scale.
If the scheme sets a black or dark background, the
gray scale will be reversed (black becomes white and white becomes black).

{pstd}
{cmd:gs1}, {cmd:gs2}, and {cmd:gs3} vary how colors are mapped to grays.
{cmd:gs1} bases its mapping on the average RGB value, {cmd:gs2} on "true
grayscale", and {cmd:gs3} on the maximum RGB value.  In theory, true grayscale
should work best, but we have found that average generally works better with
Stata graphs.


{marker remarks6}{...}
{title:The scheme matters, not the background color you set}

{pstd}
In all the above, the background color you set using the
{it:{help region_options}}
{cmd:graphregion(fcolor())} and
{cmd:plotregion(fcolor())} plays no role in the decision that is made.
Decisions are made based exclusively on whether the scheme naturally has a
light or dark background.

{pstd}
You may set background colors but remember to start with the appropriate
scheme.  Set light background colors with light-background schemes and dark
background colors with dark-background schemes.
{p_end}
