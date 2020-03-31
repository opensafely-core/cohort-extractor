{smcl}
{* *! version 1.1.11  16apr2019}{...}
{vieweralsosee "[G-3] blabel_option" "mansection G-3 blabel_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{viewerjumpto "Syntax" "blabel_option##syntax"}{...}
{viewerjumpto "Description" "blabel_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "blabel_option##linkspdf"}{...}
{viewerjumpto "Option" "blabel_option##option"}{...}
{viewerjumpto "Suboptions" "blabel_option##suboptions"}{...}
{viewerjumpto "Remarks" "blabel_option##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:blabel_option} {hline 2}}Option for labeling bars{p_end}
{p2col:}({mansection G-3 blabel_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph}
{c -(}{cmd:bar}|{cmd:hbar}{c )-}
...{cmd:,}
...
{cmdab:blab:el:(}{it:what} [{cmd:,} {it:where_and_how}]{cmd:)} ...

{synoptset 20}{...}
{synopt:{it:what}}Description{p_end}
{synoptline}
{synopt:{cmd:none}}no label; the default{p_end}
{synopt:{cmd:bar}}label is bar height{p_end}
{synopt:{cmd:total}}label is cumulative bar height{p_end}
{synopt:{cmd:name}}label is name of {it:yvar}{p_end}
{synopt:{cmd:group}}label is first {cmd:over()} group{p_end}
{synoptline}

{synopt:{it:where_and_how}}Description{p_end}
{synoptline}
{synopt:{cmdab:pos:ition:(}{cmd:outside}{cmd:)}}place label just above the
        bar ({cmd:bar}) or just to its right ({cmd:hbar}){p_end}
{synopt:{cmdab:pos:ition:(}{cmd:inside}{cmd:)}}place label inside the bar at
        the top ({cmd:bar}) or at rightmost extent ({cmd:hbar}){p_end}
{synopt:{cmdab:pos:ition:(}{cmd:base}{cmd:)}}place label inside the bar at
        the bar's base{p_end}
{synopt:{cmdab:pos:ition:(}{cmd:center}{cmd:)}}place label inside the bar at
        the bar's center{p_end}
{synopt:{cmd:gap(}{it:{help size}}{cmd:)}}distance from
        position{p_end}
{synopt:{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}}format if {cmd:bar}
        or {cmd:total}{p_end}
{synopt:{it:{help textbox_options}}}look of label{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:blabel()} is for use with {helpb graph bar} and
{helpb graph hbar}.  It adds a label on top of or inside each bar.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 blabel_optionQuickstart:Quick start}

        {mansection G-3 blabel_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:blabel(}{it:what}{cmd:,} {it:where_and_how}{cmd:)}
    specifies the label and where it is to be located relative to the bar.
    {it:where_and_how} is optional and is documented under
    {it:{help blabel_option##suboptions:Suboptions}}
     below.  {it:what} specifies the contents of the label.

{pmore}
    {cmd:blabel(bar)} specifies that the label be the height of the bar.  In

{phang3}
	    {cmd:. graph bar (mean) empcost, over(division) blabel(bar)}

{pmore}
    the labels would be the mean employee cost.

{pmore}
    {cmd:blabel(total)} specifies that the label be the cumulative height
    of the bar.  {cmd:blabel(total)} is for use with {cmd:graph} {cmd:bar}'s
    {cmd:stack} option.  In

{phang3}
	    {cmd:. graph bar (sum) cost1 cost2, stack over(group) blabel(total)}

{pmore}
    the labels would be the total height of the stacked bar -- the sum of
    costs.  Also, the {cmd:cost1} part of the stack bar would be
    labeled with its height.

{pmore}
    {cmd:blabel(name)} specifies that the label be the name of the
    {it:yvar}.  In

{phang3}
	    {cmd:. graph bar (mean) y1 y2 y3 y4, blabel(name)}

{pmore}
     The labels would be "mean of y1", "mean of y2", ..., "mean of y4".
     Usually, you would also want to suppress the legend here and
     so would type

{phang3}
	    {cmd:. graph bar (mean) y1 y2 y3 y4, blabel(name) legend(off)}

{pmore}
    {cmd:blabel(group)} specifies that the label be the name of the
    first {cmd:over()} group.  In

{phang3}
	    {cmd:. graph bar cost, over(division) over(year) blabel(group)}

{pmore}
    the labels would be the name of the divisions.  Usually, you would also
    want to suppress the appearance of the division labels on the axis:

{phang3}
	    {cmd:. graph bar cost, over(division, axis(off)) over(year) blabel(group)}


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:position()}
    specifies where the label is to appear.

{pmore}
    {cmd:position(outside)} is the default.  The label appears just above
    the bar ({cmd:graph} {cmd:bar}) or just to its right ({cmd:graph}
    {cmd:hbar}).

{pmore}
    {cmd:position(inside)} specifies that the label appear inside the
    bar, at the top ({cmd:graph} {cmd:bar}) or at its rightmost extent
    ({cmd:graph} {cmd:hbar}).

{pmore}
    {cmd:position(base)} specifies that the label appear inside the bar, at
    the bar's base; at the bottom of the bar ({cmd:graph} {cmd:bar}); or at
    the left of the bar ({cmd:graph} {cmd:hbar}).

{pmore}
    {cmd:position(center)} specifies that the label appear inside the bar, at
    its center.

{phang}
{cmd:gap(}{it:size}{cmd:)}
    specifies a distance by which the label is to be offset from its location
    ({cmd:outside}, {cmd:inside}, {cmd:base}, or {cmd:center}).
    The default is usually {cmd:gap(1.7)}.  The {cmd:gap()} may be
    positive or negative, and you can specify, for instance,
    {cmd:gap(*1.2)} and {cmd:gap(*.8)} to increase or decrease the gap by
    20%; see {manhelpi size G-4}.

{phang}
{cmd:format(%}{it:fmt}{cmd:)}
    is for use with {cmd:blabel(bar)} and {cmd:blabel(total)}; it specifies
    the display format to be used to format the height value.  See
    {manhelp format D}.

{phang}
{it:textbox_options}
    are any of the options allowed with a textbox.  Important options include
    {cmd:size()}, which determines the size of the text; {cmd:box}, which
    draws a box around the text; and {cmd:color()}, which determines the color
    and opacity of the text.  See {manhelpi textbox_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:blabel()} serves two purposes:  to increase the information content of
the chart ({cmd:blabel(bar)} and {cmd:blabel(total)}) or to change how
bars are labeled ({cmd:blabel(name)} and {cmd:blabel(group)}).  

{pstd}
Remarks are presented under the following headings:

	{help blabel_option##remarks1:Increasing the information content}
	{help blabel_option##remarks2:Changing how bars are labeled}


{marker remarks1}{...}
{title:Increasing the information content}

{pstd}
Under the heading
{it:{help graph bar##remarks5:Multiple bars (overlapping the bars)}} in
{manhelp graph_bar G-2:graph bar}, 
the following graph was drawn:

	{cmd}. graph bar (mean) tempjuly tempjan, over(region)
		bargap(-30)
		legend(label(1 "July") label(2 "January"))
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar1:click to run})}
{* graph grbar1, but do not represent in manual}{...}

{pstd}
To the above, we now add

		{cmd:blabel(bar, position(inside) format(%9.1f))}

{pstd}
which will add the average temperature to the bar, position the average
inside the bar, at the top, and format its value by using {cmd:%9.1f}:

	{cmd}. graph bar (mean) tempjuly tempjan, over(region)
		bargap(-30)
		legend(label(1 "July") label(2 "January"))
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce")
  {txt:{it:new} ->}        blabel(bar, position(inside) format(%9.1f) color(white)){txt}
	  {it:({stata gr_example2 grbar1lab:click to run})}
{* graph grbar1lab}{...}

{pstd}
We also specified the {it:textbox_option} {cmd:color(white)} to change the
color of the text; see {manhelpi textbox_options G-3}.  Dark text on a dark
bar would have blended too much.


{marker remarks2}{...}
{title:Changing how bars are labeled}

{pstd}
Placing the labels on the bars works especially well with horizontal bar
charts:

	{cmd}. sysuse nlsw88, clear

	. graph hbar (mean) wage,
		 over(occ, axis(off) sort(1))
	       blabel(group, position(base) color(bg))
	       ytitle("")
		   by(union,
		       title("Average Hourly Wage, 1988, Women Aged 34-46")
		       note("Source:  1988 data from NLS, U.S. Dept. of Labor,
			     Bureau of Labor Statistics")
		     ){txt}
	  {it:({stata gr_example2 grblab1:click to run})}
{* graph grblab1}{...}

{pstd}
What makes moving the labels from the axis to the bars work so well
here is that it saves so much horizontal space.

{pstd}
In the above command, note the first two option lines:

		 {cmd}over(occ, axis(off) sort(1))
	       blabel(group, position(base) color(bg)){txt}

{pstd}
{cmd:blabel(group)} puts the occupation labels on top of the bars, and suboption
{cmd:position(base)} located the labels at the base of each bar.  We specified
{cmd:over(,axis(off))} to prevent the labels from appearing on the axis.
Let us run through all the options:

{phang2}
{cmd:over(occ, axis(off) sort(1))}{break}
     Specified that the chart be done over occupation, that the occupation
     labels not be shown on the axis, and that the bars be sorted by
     the first (and only) {it:yvar}, namely, {cmd:(mean)} {cmd:wage}.

{phang2}
{cmd:ytitle("")}{break}
     Specified that the title on the numerical {it:y} axis (the horizontal
     axis in this horizontal case) be suppressed.

{phang2}
{cmd:by(union, title(...) note(...))}{break}
     Specified that the entire graph be repeated by values of variable 
     {cmd:union}, and specified that the title and note be added to the
     overall graph.  Had we specified the {cmd:title()} and {cmd:note()}
     options outside the {cmd:by()}, they would have been placed on each
     graph.
{p_end}
