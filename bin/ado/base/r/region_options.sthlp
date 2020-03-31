{smcl}
{* *! version 1.2.0  07oct2019}{...}
{vieweralsosee "[G-3] region_options" "mansection G-3 region_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] marginstyle" "help marginstyle"}{...}
{viewerjumpto "Syntax" "region_options##syntax"}{...}
{viewerjumpto "Description" "region_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "region_options##linkspdf"}{...}
{viewerjumpto "Options" "region_options##options"}{...}
{viewerjumpto "Suboptions" "region_options##suboptions"}{...}
{viewerjumpto "Remarks" "region_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:region_options} {hline 2}}Options for shading and outlining regions and controlling graph size{p_end}
{p2col:}({mansection G-3 region_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:region_options}}Description{p_end}
{p2line}
{p2col:{cmdab:ysiz:e:(}{it:{help region_options##graphsize:graphsize}}{cmd:)}}height of {it:available area}{p_end}
{p2col:{cmdab:xsiz:e:(}{it:{help region_options##graphsize:graphsize}}{cmd:)}}width of {it:available area}{p_end}
{p2col:{cmdab:graphr:egion:(}{it:suboptions}{cmd:)}}attributes of
     {it:graph region}{p_end}
{p2col:{cmdab:plotr:egion:(}{it:suboptions}{cmd:)}}attributes of
     {it:plot region}{p_end}
{p2line}
{p 4 6 2}
Options {cmd:ysize()} and {cmd:xsize()} are {it:unique};
options {cmd:graphregion()} and {cmd:plotregion()} are
{it:merged-implicit}; see {help repeated options}.


{p2col:{it:suboptions}}Description{p_end}
{p2line}
{p2col:{cmdab:sty:le:(}{it:{help areastyle}}{cmd:)}}overall style of outer
        region{p_end}
{p2col:{cmdab:c:olor:(}{it:{help colorstyle}}{cmd:)}}line and fill color and
	opacity of outer region{p_end}
{p2col:{cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and opacity
	of outer region{p_end}
{p2col:{cmdab:ls:tyle:(}{it:{help linestyle}}{cmd:)}}overall style of outline
       {p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of outline{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of outline
       {p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}outline pattern
       (solid, dashed, etc.){p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}outline
	alignment (inside, outside, center){p_end}

{p2col:{cmdab:isty:le:(}{it:{help areastyle}}{cmd:)}}overall style of inner
      region{p_end}
{p2col:{cmdab:ic:olor:(}{it:{help colorstyle}}{cmd:)}}line and fill color and
	opacity of inner region{p_end}
{p2col:{cmdab:ifc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and opacity
	of inner region{p_end}
{p2col:{cmdab:ils:tyle:(}{it:{help linestyle}}{cmd:)}}overall style of
       outline{p_end}
{p2col:{cmdab:ilc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of outline{p_end}
{p2col:{cmdab:ilw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of outline
      {p_end}
{p2col:{cmdab:ilp:attern:(}{it:{help linepatternstyle}}{cmd:)}}outline pattern
      (solid, dashed, etc.){p_end}
{p2col : {cmdab:ila:lign:(}{it:{help linealignmentstyle}}{cmd:)}}outline
	alignment (inside, outside, center){p_end}

{p2col:{cmdab:m:argin:(}{it:{help marginstyle}}{cmd:)}}margin between inner
       and outer regions{p_end}
{p2line}
{p2colreset}{...}


{marker regions_image}{...}
{pstd}
The {it:available area}, {it:graph region}, and {it:plot region} are defined

	{c TLC}{hline 41}{c TRC}
	{c |}{it:(outer graph region)}             {it:margin}  {c |}
	{c |} {c TLC}{hline 37}{c TRC} {c |}
	{c |} {c |}{it:(inner graph region)}                 {c |} {c |}    {it:titles appear outside}
	{c |} {c |}                                     {c |} {c |}      {it:the borders of outer}
	{c |} {c |}   {c TLC}{hline 28}{c TRC}    {c |} {c |}      {it:plot region}
	{c |} {c |}   {c |}{it:(outer plot region)}  {it:margin} {c |}    {c |} {c |}
	{c |} {c |}   {c |} {c TLC}{hline 24}{c TRC} {c |}    {c |} {c |}{...}
{col 56}{it:axes appear on the}
	{c |} {c |}   {c |} {c |}                        {c |} {c |}    {c |} {c |}      {it:borders of the outer}
	{c |}m{c |}   {c |}m{c |}                        {c |}m{c |}    {c |}m{c |}      {it:plot region}
	{c |}a{c |}   {c |}a{c |}                        {c |}a{c |}    {c |}a{c |}
	{c |}r{c |}   {c |}r{c |}    {it:(inner plot}         {c |}r{c |}    {c |}r{c |}{...}
{col 56}{it:plot appears in inner}
	{c |}g{c |}   {c |}g{c |}             {it:region)}    {c |}g{c |}    {c |}g{c |}      {it:plot region}
	{c |}i{c |}   {c |}i{c |}                        {c |}i{c |}    {c |}i{c |}
	{c |}n{c |}   {c |}n{c |}                        {c |}n{c |}    {c |}n{c |}
	{c |} {c |}   {c |} {c |}                        {c |} {c |}    {c |} {c |}
	{c |} {c |}   {c |} {c BLC}{hline 24}{c BRC} {c |}    {c |} {c |}{...}
{col 56}{it:Note: What are called}
	{c |} {c |}   {c |}            {it:margin}          {c |}    {c |} {c |}{...}
{col 58}{it:the "graph region" and}
	{c |} {c |}   {c BLC}{hline 28}{c BRC}    {c |} {c |}{...}
{col 58}{it:the "plot region" are}
	{c |} {c |}                                     {c |} {c |}{...}
{col 58}{it:sometimes the inner}
	{c |} {c |}                                     {c |} {c |}{...}
{col 58}{it:and sometimes the}
	{c |} {c BLC}{hline 37}{c BRC} {c |}{...}
{col 58}{it:outer regions.}
	{c |}                  {it:margin}                 {c |}{...}
{col 58}
	{c BLC}{hline 41}{c BRC}{txt}{...}
{col 58}

	{it:The available area and outer graph region}
	{it:are almost coincident; they differ only by}
	{it:the width of the border.}

	{it:The borders of the outer plot or graph}
	{it:region are sometimes called the outer}
	{it:borders of the plot or graph region.}


{marker description}{...}
{title:Description}

{pstd}
The {it:region_options} set the size, margins, and color of the area in which
the graph appears.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 region_optionsQuickstart:Quick start}

        {mansection G-3 region_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker graphsize}{...}
{phang}
{cmd:ysize(}{it:graphsize}{cmd:)} and {cmd:xsize(}{it:graphsize}{cmd:)}
    specify the height and width of the {it:available area}.
    {it:graphsize} is a numeric value followed by units {cmd:in},
    {cmd:pt}, or {cmd:cm}.  For example,

{pmore2}
{cmd:1in} = {cmd:72pt} = {cmd:2.54cm}

{pmore}
    When units are not specified, {cmd:in} is assumed.
    The defaults are usually {cmd:ysize(4)} and {cmd:xsize(5.5)},
    but this, of course, is controlled by the scheme; see
    {manhelp schemes G-4:Schemes intro}.  These two
    options can be used to control the overall aspect ratio of a graph.  See
    {it:{help region_options##remarks2:Controlling the aspect ratio}} below.

{pmore}
The minimum {it:graphsize} is {bf:{ccl min_graphsize}in}.
The maximum {it:graphsize} is {bf:{ccl max_graphsize}in}.

{phang}
{cmd:graphregion(}{it:suboptions}{cmd:)} and
{cmd:plotregion(}{it:suboptions}{cmd:)}
    specify attributes for the {it:graph region} and {it:plot region}.


{marker suboptions}{...}
{title:Suboptions}

{marker style()}{...}
{phang}
{cmd:style(}{it:areastyle}{cmd:)} and
{cmd:istyle(}{it:areastyle}{cmd:)}
    specify the overall style of the outer and inner regions.
    The other suboptions allow you to change the region's attributes
    individually, but {cmd:style()} and {cmd:istyle()} provide the
    starting points.
    See {manhelpi areastyle G-4} for a list of choices.

{phang}
{cmd:color(}{it:colorstyle}{cmd:)} and
{cmd:icolor(}{it:colorstyle}{cmd:)}
    specify the color and opacity of the line used to outline the outer and
    inner regions; see {manhelpi colorstyle G-4} for a list of choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)} and
{cmd:ifcolor(}{it:colorstyle}{cmd:)}
    specify the fill color and opacity for the outer and inner regions;
    see {manhelpi colorstyle G-4} for a list of choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)} and
{cmd:ilstyle(}{it:linestyle}{cmd:)}
    specify the overall style of the line used to outline the outer and inner
    regions, which includes its pattern (solid, dashed, etc.), thickness,
    and color.  The other suboptions listed below allow you to change the
    line's attributes individually, but {cmd:lstyle()} and {cmd:ilstyle()} are
    the starting points.  See {manhelpi linestyle G-4} for a list of choices.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)} and
{cmd:ilcolor(}{it:colorstyle}{cmd:)}
    specify the color and opacity of the line used to outline the outer and
    inner regions; see {manhelpi colorstyle G-4} for a list of choices.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)} and
{cmd:ilwidth(}{it:linewidthstyle}{cmd:)}
    specify the thickness of the line used to outline the outer and inner
    regions; see {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)} and
{cmd:ilpattern(}{it:linepatternstyle}{cmd:)}
    specify whether the line used to outline the outer and inner regions is
    solid, dashed, etc.; see {manhelpi linepatternstyle G-4} for a list of
    choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)} and
{cmd:ilalign(}{it:linealignmentstyle}{cmd:)}
    specify whether the line used to outline the outer and inner regions is
    drawn inside, is drawn outside, or is centered;
    see {manhelpi linealignmentstyle G-4} for a list of choices.

{phang}
{cmd:margin(}{it:marginstyle}{cmd:)}
    specifies the margin between the outer and inner regions;
    see {manhelpi marginstyle G-4}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help region_options##remarks1:Setting the offset between the axes and the plot region}
	{help region_options##remarks2:Controlling the aspect ratio}
	{help region_options##remarks3:Suppressing the border around the plot region}
	{help region_options##remarks4:Setting background and fill colors}
	{help region_options##remarks5:How graphs are constructed}


{marker remarks1}{...}
{title:Setting the offset between the axes and the plot region}

{* index offset between axes and data, setting}{...}
{pstd}
By default, most schemes (see {manhelp schemes G-4:Schemes intro}) offset the
axes from the region in which the data are plotted.  This offset is specified
{cmd:plotregion(margin(}{it:marginstyle}{cmd:))}; see
{manhelpi marginstyle G-4}.

{pstd}
If you do not want the axes offset from the contents of the plot,
specify {cmd:plotregion(margin(zero))}.  Compare

	{cmd:. sysuse auto}

	{cmd:. scatter price mpg}
	  {it:({stata "gr_example auto: scatter price mpg":click to run})}
{* graph regopts1}{...}

{pstd}
with

	{cmd:. scatter price mpg, plotr(m(zero))}
	  {it:({stata "gr_example auto: scatter price mpg, plotr(m(zero))":click to run})}
{* graph regopts2}{...}


{marker remarks2}{...}
{title:Controlling the aspect ratio}

{* index aspect ratio, controlling}{...}
{pstd}
Here we discuss controlling the overall aspect ratio of a graph.  To control
the aspect ratio of a plot region for {helpb twoway}, {helpb graph bar}, 
{helpb graph box}, or {helpb graph dot}, see {manhelpi aspect_option G-3}.

{pstd}
The way to control the aspect ratio of the overall graph is by specifying
the {cmd:xsize()} or {cmd:ysize()} options.  For instance, you draw a graph
and find that the graph is too wide given its height.  To address the problem,
either increase {cmd:ysize()} or decrease {cmd:xsize()}.  The usual defaults
(which of course are determined by the scheme; see
{manhelp schemes G-4:Schemes intro}) are
{cmd:ysize(4)} and {cmd:xsize(5.5)}, so you might try

	{cmd:. graph} ...{cmd:,} ... {cmd:ysize(5)}

{pstd}
or

	{cmd:. graph} ...{cmd:,} ... {cmd:xsize(4.5)}

{pstd}
For instance, compare

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight":click to run})}
{* graph mpgweight}{...}

{pstd}
with

	{cmd:. scatter mpg weight, ysize(5)}
	  {it:({stata "gr_example auto: scatter mpg weight, ysize(5)":click to run})}
{* graph regopts3}{...}

{pstd}
Another way to control the aspect ratio is to add to the outer margin
of the {it:graph area}.  This will keep the overall size of the graph
the same while using less of the {it:available area}.  For instance,

	{cmd:. scatter mpg weight, graphregion(margin(l+10 r+10))}
	  {it:({stata "gr_example auto: scatter mpg weight, graphregion(margin(l+10 r+10))":click to run})}
{* graph regopts4}{...}

{pstd}
This method is especially useful when using {cmd:graph,} {cmd:by()}, but
remember to specify the {cmd:graphregion(margin())} option inside the
{cmd:by()} so that it affects the entire graph:

	{cmd:. scatter mpg weight, by(foreign, total graphr(m(l+10 r+10)))}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total graphr(m(l+10 r+10)))":click to run})}
{* graph regopts5}{...}

{pstd}
Compare the above with

	{cmd:. scatter mpg weight, by(foreign, total)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total)":click to run})}
{* graph regopts6}{...}

{pstd}
A similar, and often preferable, effect can be obtained by constraining the
aspect ratio of the plot region itself; see {manhelpi aspect_option G-3}.

{pstd}
You do not have to get the aspect ratio or size right the first time you
draw a graph; using {cmd:graph} {cmd:display}, you can change the aspect
ratio of an already drawn graph -- even a graph saved in a {cmd:.gph} file.
See {it:{help graph display##remarks1:Changing the size and aspect ratio}} in
{manhelp graph_display G-2:graph display}.


{marker remarks3}{...}
{title:Suppressing the border around the plot region}

{* index border around plot region, suppressing}{...}
{pstd}
To eliminate the border around the plot region, specify
{cmd:plotregion(style(none))}:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, plotregion(style(none))}
	  {it:({stata "gr_example auto: scatter mpg weight, plotregion(style(none))":click to run})}
{* graph regopts7}{...}


{marker remarks4}{...}
{title:Setting background and fill colors}

{* index background color, setting}{* index fill color, setting}{...}
{pstd}
The background color of a graph is determined by default by the scheme you
choose -- see {manhelp schemes G-4:Schemes intro} -- and is usually black or
white, perhaps with a tint.  Option
{cmd:graphregion(fcolor(}{it:colorstyle}{cmd:))} allows you to override the
scheme's selection.  When doing this, choose a light background color for
schemes that are naturally white and a dark background color for schemes that
are naturally black, or you will have to type many options to make
your graph look good.

{pstd}
Below we draw a graph, using a light gray background:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, graphregion(fcolor(gs13))}
	  {it:({stata `"gr_example auto: scatter mpg weight, graphregion(fcolor(gs13))"':click to run})}
{* graph regopts8}{...}

{pstd}
See {manhelpi colorstyle G-4} for information on what you may specify
inside the {cmd:graphregion(fcolor())} option.

{pstd}
In addition to {cmd:graphregion(fcolor())}, there are three other fill-color
options:

	{cmd:graphregion(ifcolor())}{col 34}{...}
fills {it:inner graph region}   <-- {it:of little use}
{...}
	{cmd:plotregion(fcolor())}{col 34}{...}
fills {it:outer plot region}    <-- {it:useful}
{...}
	{cmd:plotregion(ifcolor())}{col 34}{...}
fills {it:inner plot region}    <-- {it:could be useful}

{pstd}
{cmd:plotregion(fcolor())} is worth remembering.  Below we make
the plot region a light gray:

	{cmd:. scatter mpg weight, plotr(fcolor(gs13))}
	  {it:({stata `"gr_example auto: scatter mpg weight, plotr(fc(gs13))"':click to run})}
{* graph regopts9}{...}

{pstd}
The other two options -- {cmd:graphregion(ifcolor())}
and
{cmd:plotregion(ifcolor())} -- fill the {it:inner graph region} and
{it:inner plot region}.
Filling the {it:inner graph region} serves little purpose.
Filling the {it:inner plot region} -- which is the same as the
{it:outer plot region} except that it omits the margin between
the {it:inner plot region} and the axes -- generally makes graphs appear
too busy.


{marker remarks5}{...}
{title:How graphs are constructed}

{pstd}
{cmd:graph} works from the outside in, with the result that the dimensions of
the {it:plot region} are what are left over.

{pstd}
{cmd:graph} begins with the {it:available area}, the size of which is
determined by the {cmd:xsize()} and {cmd:ysize()} options.
{cmd:graph} indents on all four sides by
{cmd:graphregion(margin())}, so it defines the outer border of the
{it:graph region}, the interior of which is the
{it:inner graph region}.

{pstd}
Overall titles (if any) are now placed on the graph, and on each of the four
sides, those titles are allocated whatever space they require.  Next are
placed any axis titles and labels, and they too are allocated whatever space
necessary.  That then determines the outer border of the {it:plot region}
(or, more properly, the border of the {it:outer plot region}).

{pstd}
The axis (if any) is placed right on top of that border.  {cmd:graph} now
indents on all four sides by {cmd:plotregion(margin())}, and that determines the
inner border of the plot region, meaning the border of the
({it:inner}) {it:plot region}.  It is inside this that the data are plotted.

{pstd}
An implication of the above is that, if {cmd:plotregion(margin(zero))},
the axes are not offset from the region in which the data are plotted.

{pstd}
Now consider the lines used to outline the regions and the fill colors
used to shade their interiors.

{pstd}
Starting once again with the {it:available area}, {cmd:graph} outlines its
borders by using {cmd:graphregion(lstyle())} -- which is usually
{cmd:graphregion(lstyle(none))} -- and fills the area
with the {cmd:graphregion(fcolor())}.

{pstd}
{cmd:graph} now moves to the inner border of the {it:graph region}, outlines
it using {cmd:graphregion(ilstyle())}, and fills the {it:graph region} with
{cmd:graphregion(ifcolor())}.

{pstd}
{cmd:graph} moves to the outer border of the {it:plot region}, outlines it
using {cmd:plotregion(lstyle())}, and fills the {it:outer plot region}
with {cmd:plotregion(fcolor())}.

{pstd}
Finally, {cmd:graph} moves to the inner border of the {it:plot region},
outlines it using {cmd:plotregion(ilstyle())}, and fills the ({it:inner})
{it:plot region} with {cmd:plotregion(ifcolor())}.
{p_end}
