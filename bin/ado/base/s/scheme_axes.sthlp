{smcl}
{* *! version 1.0.7  01mar2017}{...}
{vieweralsosee "scheme by graphs" "help scheme by graphs"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control axes}

{p 3 3 2}
These graphics scheme entries control the look of graph axes.  Most
characteristics of axes are shared across all graph families; unless
specifically noted, you can assume that entries are shared.

{p 3 3 2}
Some characteristics of axes for by graphs are controlled with the settings
documented in {help scheme by graphs:by graphs}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_axes##remarks1:Axis ticks}{p_end}
{p 8 12 0}{help scheme_axes##remarks2:Axis tick labels}{p_end}
{p 8 12 0}{help scheme_axes##remarks3:Axis titles}{p_end}
{p 8 12 0}{help scheme_axes##remarks4:Number of ticks}{p_end}
{p 8 12 0}{help scheme_axes##remarks5:Axis line}{p_end}
{p 8 12 0}{help scheme_axes##remarks6:Axis line extent}{p_end}
{p 8 12 0}{help scheme_axes##remarks7:Axis positioning}{p_end}
{p 8 12 0}{help scheme_axes##remarks8:Axis positioning and scaling for graph bar and graph hbar}{p_end}
{p 8 12 0}{help scheme_axes##remarks9:Axis positioning and scaling for graph box and graph hbox}{p_end}
{p 8 12 0}{help scheme_axes##remarks10:Axis positioning and scaling for graph dot}{p_end}
{p 8 12 0}{help scheme_axes##remarks11:Overall tick and label styles}{p_end}
{p 8 12 0}{help scheme_axes##remarks12:Overall tickset styles}{p_end}
{p 8 12 0}{help scheme_axes##remarks13:Overall axis styles}{p_end}

{p 3 3 2}
Most of the important entries appear in the first five sections -- you can change
most characteristics of axes using the settings in these sections.


{marker remarks1}{...}
{title:Axis ticks}

{p2colset 4 44 47 0}{...}
{p 3 3 2}
These entries control the look of axis ticks.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize        {space 7}tick}      {space 5}{it:{help textsizestyle}}}
	length of major ticks{p_end}
{p2col:{cmd:color        {space 7}tick}      {space 5}{it:{help colorstyle}}}
	color of major ticks{p_end}
{p2col:{cmd:linewidth    {space 3}tick}      {space 5}{it:{help linewidthstyle:linewidth}}}
	line thickness of major ticks{p_end}
{p2col:{cmd:linepattern  {space 1}tick}      {space 5}{it:{help linepatternstyle}}}
	line pattern of major ticks{p_end}

{p2col:{cmd:gsize        {space 7}minortick} {space 0}{it:{help textsizestyle}}}
	length of minor ticks{p_end}
{p2col:{cmd:color        {space 7}minortick} {space 0}{it:{help colorstyle}}}
	color of minor ticks{p_end}
{p2col:{cmd:linewidth    {space 3}minortick} {space 0}{it:{help linewidthstyle:linewidth}}}
	line thickness of minor ticks{p_end}
{p2col:{cmd:linepattern  {space 1}minortick} {space 0}{it:{help linepatternstyle}}}
	line pattern of minor ticks{p_end}
{p2col:{cmd:linestyle    {space 3}minortick} {space 0}{it:{help linestyle}}}
	minor tick {it:linestyle} (*){p_end}

{p2col:{cmd:tickposition {space 0}axis_tick} {space 0}{it:tickpos}} 
        whether axis ticks are inside the plot region, outside the plot region,
        or crossing the axis; {it:tickpos} may be one of {cmd:inside},
        {cmd:outside}, or {cmd:crossing}{p_end}
{p2col:{cmd:linestyle    {space 3}tick}      {space 5}{it:{help linestyle}}}
	major tick {it:linestyle} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{title:Axis tick labels}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
These entries control the look of labels on axis ticks.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize      {space 5}tick_label}       {space 6}{it:{help textsizestyle}}}
	text size for major ticks}{p_end}
{p2col:{cmd:gsize      {space 5}minortick_label}  {space 1}{it:{help textsizestyle}}}
	text size for minor ticks}{p_end}
{p2col:{cmd:color      {space 5}tick_label}       {space 6}{it:{help colorstyle}}}
	text color{p_end}

{p2col:{cmd:anglestyle {space 0}horizontal_tick}  {space 1}{it:{help anglestyle}}}
	text angle for horizontal (x) axes{p_end}
{p2col:{cmd:anglestyle {space 0}vertical_tick}    {space 3}{it:{help anglestyle}}}
	text angle for vertical (y) axes{p_end}

{p2col:{cmd:gsize      {space 5}tickgap}          {space 9}{it:{help textsizestyle}}}
	added distance between a tick and its label{p_end}
{p2col:{cmd:gsize      {space 5}notickgap}        {space 7}{it:{help textsizestyle}}}
	added distance between axis line and labels for axis styles that do 
        not draw ticks{p_end}

{p2col:{cmd:yesno      {space 5}alternate_labels} {space 0}{{cmd:yes}|{cmd:no}}}
        alternate the distance of every other tick label from the axis{p_end}
{p2col:{cmd:gsize      {space 5}alternate_gap}    {space 3}{it:{help textsizestyle}}}
	additional gap between ticks and labels previous entry is
	{cmd:yes}{p_end}

{p2col:{cmd:yesno      {space 5}use_labels_on_ticks} {space 0}{{cmd:yes}|{cmd:no}}}
        use value labels to label ticks whenever they match a tick value{p_end}

{p2col:{cmd:textboxstyle {space 0}tick}          {space 10}{it:{help textboxstyle}}}
	overall text style for major tick labels (*){p_end}
{p2col:{cmd:textboxstyle {space 0}minortick}     {space 5}{it:{help textboxstyle}}}
	overall text style for minor tick labels (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Axis titles}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
These entries control the look of axis titles.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize        {space 7}axis_title}      {space 4}{it:{help textsizestyle}}}
	text size{p_end}
{p2col:{cmd:color        {space 7}axis_title}      {space 4}{it:{help colorstyle}}}
	text color{p_end}

{p2col:{cmd:margin       {space 6}axis_title}      {space 4}{it:{help marginstyle}}}
	margin around title text{p_end}
{p2col:{cmd:gsize        {space 7}axis_title_gap} {space 0}{it:{help textsizestyle}}}
	added distance between tick labels axis title{p_end}

{p2col:{cmd:textboxstyle {space 0}axis_title}      {space 4}{it:{help textboxstyle}}}
	overall text style for axis titles (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks4}{...}
{title:Number of ticks}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
These entries specify the suggested number of axis ticks.  For a discussion of
the suggested number of ticks; see the {cmd:#} rule in
{manhelpi axis_label_options G-3}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:numticks_g horizontal_major} {space 1}{it:#}}
	major ticks for horizontal axes{p_end}
{p2col:{cmd:numticks_g vertical_major}   {space 3}{it:#}}
	major ticks for vertical axes{p_end}
{p2col:{cmd:numticks_g horizontal_minor} {space 1}{it:#}}
	minor ticks for horizontal axes{p_end}
{p2col:{cmd:numticks_g vertical_minor}   {space 3}{it:#}}
	minor ticks for vertical axes{p_end}
{p2col:{cmd:numticks_g horizontal_tmajor} {space 0}{it:#}}
	major ticks for horizontal axes that do not by
	default show tick labels{p_end}
{p2col:{cmd:numticks_g vertical_tmajor}   {space 2}{it:#}}
	major ticks for vertical axes that do not by
	default show tick labels{p_end}
{p2col:{cmd:numticks_g horizontal_tminor} {space 0}{it:#}}
	minor ticks for horizontal axes that do not by
	default show tick labels{p_end}
{p2col:{cmd:numticks_g vertical_tminor}   {space 2}{it:#}}
	minor ticks for vertical axes that do not by
	default show tick labels{p_end}
{p2col:{cmd:numticks_g major}      {space 12}{it:#}}
	default suggested number of major ticks, if other not specified{p_end}
{p2line}


{marker remarks5}{...}
{title:Axis line}

{p2colset 4 44 47 0}{...}
{p 3 3 2}
These entries control the look of the axis line.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}tickline}   {space 2}{it:{help colorstyle}}}
	color of axis line{p_end}
{p2col:{cmd:linewidth   {space 2}tickline}   {space 2}{it:{help linewidthstyle:linewidth}}}
	line thickness of axis line{p_end}
{p2col:{cmd:linepattern {space 0}tickline}   {space 2}{it:{help linepatternstyle}}}
	line pattern of axis line{p_end}

{p2col:{cmd:linestyle   {space 2}axisline}      {space 5}{it:{help linestyle}}}
	overall {it:linestyle} for most axes{p_end}
{p2col:{cmd:linestyle   {space 2}axis_withgrid} {space 0}{it:{help linestyle}}}
	overall {it:linestyle} for axes that by default have a grid{p_end}
{p2line}


{marker remarks6}{...}
{title:Axis line extent}

{p2colset 4 41 44 0}{...}
{p 3 3 2}
These entries control how the extent of axes interacts with the plot region's
margin.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno extend_axes_low}       {space 6}{{cmd:yes}|{cmd:no}}}
	extend axis lines to the inner margin of the plot region ({cmd:yes})
	or to the smallest major tick mark ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_axes_high}      {space 5}{{cmd:yes}|{cmd:no}}}
	extend axis lines to the inner margin of the plot region ({cmd:yes})
	or to the largest major tick mark ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_axes_full_low}  {space 1}{{cmd:yes}|{cmd:no}}}
        extend axis lines through the plot region margin to the bounding box of
        the plot region ({cmd:yes}) or to the smallest major tick mark
        ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_axes_full_high} {space 0}{{cmd:yes}|{cmd:no}}}
        extend axis lines through the plot region margin to the bounding box of
        the plot region ({cmd:yes}) or to the largest major tick mark
        ({cmd:no}){p_end}
{p2line}


{marker remarks7}{...}
{title:Axis positioning}

{p2colset 4 39 42 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno    {space 3}alt_xaxes}      {space 5}{{cmd:yes}|{cmd:no}}}
	change the default side of the graph where {it:x} axes are drawn{p_end}
{p2col:{cmd:yesno    {space 3}alt_yaxes}      {space 5}{{cmd:yes}|{cmd:no}}}
	change the default side of the graph where {it:y} axes are drawn{p_end}

{p2col:{cmd:yesno    {space 3}x2axis_ontop}   {space 2}{{cmd:yes}|{cmd:no}}}
	display a second {it:x} axis, created using the {cmd:xaxis(2)} option of
	{helpb graph twoway}, at the top of the graph ({cmd:yes}) or
	below the first {it:x} axis ({cmd:no}){p_end}
{p2col:{cmd:yesno    {space 3}y2axis_ontop}   {space 2}{{cmd:yes}|{cmd:no}}}
        display  a second {it:y} axis, created using the {cmd:yaxis(2)} option
	of {helpb graph twoway} to the right of the plot region ({cmd:yes})
	or to the left of the first {it:y} axis ({cmd:no}){p_end}

{p2col:{cmd:gsize    {space 4}axis_space}     {space 0}{it:{help textsizestyle}}}
	space placed outside an axis{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks8}{...}
{title:Axis positioning and scaling for graph bar and graph hbar}

{p2colset 4 40 43 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno {space 0}swap_bar_scaleaxis} {space 0}{{cmd:yes}|{cmd:no}}}
        change the default side of the graph where the scale axis ({it:y} axis)
	is drawn{p_end}
{p2col:{cmd:yesno {space 0}swap_bar_groupaxis} {space 0}{{cmd:yes}|{cmd:no}}}
	change the default side of the graph where the group axis is 
	drawn{p_end}

{p2col:{cmd:yesno {space 0}bar_reverse_scale} {space 1}{{cmd:yes}|{cmd:no}}}
	reverse the scale axis ({it:y} axis){p_end}

{p2line}


{marker remarks9}{...}
{title:Axis positioning and scaling for graph box and graph hbox}

{p2colset 4 40 43 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno {space 0}swap_box_scaleaxis} {space 0}{{cmd:yes}|{cmd:no}}}
        change the default side of the graph where the scale axis ({it:y} axis)
	is drawn for {helpb graph box} and {helpb graph hbox}{p_end}
{p2col:{cmd:yesno {space 0}swap_box_groupaxis} {space 0}{{cmd:yes}|{cmd:no}}}
	change the default side of the graph where the group axis is 
	drawn {p_end}

{p2col:{cmd:yesno {space 0}box_reverse_scale} {space 1}{{cmd:yes}|{cmd:no}}}
	reverse the scale axis ({it:y} axis){p_end}
{p2line}


{marker remarks10}{...}
{title:Axis positioning and scaling for graph dot}

{p2colset 4 40 43 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno {space 0}swap_dot_scaleaxis} {space 0}{{cmd:yes}|{cmd:no}}}
        change the default side of the graph where the scale axis ({it:y} axis)
	is drawn{p_end}
{p2col:{cmd:yesno {space 0}swap_dot_groupaxis} {space 0}{{cmd:yes}|{cmd:no}}}
	change the default side of the graph where the group axis is 
	drawn{p_end}

{p2col:{cmd:yesno {space 0}dot_reverse_scale} {space 1}{{cmd:yes}|{cmd:no}}}
	reverse the scale axis ({it:y} axis){p_end}
{p2line}


{marker remarks11}{...}
{title:Overall tick and label styles}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
These composite entries specify the overall look of axis ticks and axis tick
labels; see {manhelpi tickstyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:tickstyle major}         {space 8}{it:{help tickstyle}}}
	major ticks and labels{p_end}
{p2col:{cmd:tickstyle major_nolabel} {space 0}{it:{help tickstyle}}}
	major ticks with no labels{p_end}
{p2col:{cmd:tickstyle major_notick}  {space 1}{it:{help tickstyle}}}
	major labels with no ticks{p_end}

{p2col:{cmd:tickstyle minor}         {space 8}{it:{help tickstyle}}}
	minor ticks and labels{p_end}
{p2col:{cmd:tickstyle minor_nolabel} {space 0}{it:{help tickstyle}}}
	minor ticks with no labels{p_end}
{p2col:{cmd:tickstyle minor_notick}  {space 1}{it:{help tickstyle}}}
	minor labels with no ticks{p_end}
{p2line}


{marker remarks12}{...}
{title:Overall tickset styles}

{p2colset 4 51 43 0}{...}
{p 3 3 2}
These composite entries specify the overall look of a collection (or set) of
axis ticks, axis tick labels, and possibly an associated grid; see
{manhelpi ticksetstyle G-4}.  These entries should rarely be changed; instead
consider changing the entries for the specific attributes of axes {c -} for
example, the {help colorstyle} of ticks, the {help textsizestyle} of tick
labels, etc.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:ticksetstyle major_horiz_default}{space 2}{it:{help ticksetstyle}}} 
	default major tickset for horizontal axes, including both ticks and 
	labels but not a grid{p_end}
{p2col:{cmd:ticksetstyle major_horiz_withgrid}{space 1}{it:{help ticksetstyle}}} 
	major tickset for horizontal axes, including a grid{p_end}
{p2col:{cmd:ticksetstyle major_horiz_nolabel}{space 2}{it:{help ticksetstyle}}} 
	major tickset for horizontal axes, including ticks but not labels{p_end}
{p2col:{cmd:ticksetstyle major_horiz_notick}{space 3}{it:{help ticksetstyle}}} 
	major tickset for horizontal axes, including labels but not ticks{p_end}

{p2col:{cmd:ticksetstyle major_vert_default}{space 3}{it:{help ticksetstyle}}} 
	default major tickset for vertical axes, including both ticks and 
	labels but not a grid{p_end}
{p2col:{cmd:ticksetstyle major_vert_withgrid}{space 2}{it:{help ticksetstyle}}} 
	major tickset for vertical axes, including a grid{p_end}
{p2col:{cmd:ticksetstyle major_vert_nolabel}{space 3}{it:{help ticksetstyle}}} 
	major tickset for vertical axes, including ticks but not labels{p_end}
{p2col:{cmd:ticksetstyle major_vert_notick}{space 4}{it:{help ticksetstyle}}} 
	major tickset for vertical axes, including labels but not ticks{p_end}

{p2col:{cmd:ticksetstyle minor_horiz_default}{space 2}{it:{help ticksetstyle}}} 
	default minor tickset for horizontal axes, including both ticks and 
	labels but not grid{p_end}
{p2col:{cmd:ticksetstyle minor_horiz_nolabel}{space 2}{it:{help ticksetstyle}}} 
	minor tickset for horizontal axes, including ticks but not labels{p_end}
{p2col:{cmd:ticksetstyle minor_horiz_notick}{space 3}{it:{help ticksetstyle}}} 
	minor tickset for horizontal axes, including labels but not ticks{p_end}

{p2col:{cmd:ticksetstyle minor_vert_default}{space 3}{it:{help ticksetstyle}}} 
	vertical axes default, having both ticks and labels but not a grid{p_end}
{p2col:{cmd:ticksetstyle minor_vert_nolabel}{space 3}{it:{help ticksetstyle}}} 
	minor tickset for vertical axes, including ticks but not labels{p_end}
{p2col:{cmd:ticksetstyle minor_vert_notick}{space 4}{it:{help ticksetstyle}}} 
	minor tickset for vertical axes, including labels but not ticks{p_end}
{p2line}


{marker remarks13}{...}
{title:Overall axis styles}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These composite entries specify the overall look of axes; see
{manhelpi justificationstyle G-4}.  These entries should rarely be changed;
instead consider changing the entries for the specific attributes of axes
{c -} for example, the {help colorstyle} of ticks, the {help textsizestyle} of
tick labels, etc.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:axisstyle horizontal_default} {space 0}{it:{help axisstyle}}}
	default horizontal axis{p_end}
{p2col:{cmd:axisstyle vertical_default}   {space 2}{it:{help axisstyle}}}
	default vertical axis{p_end}

{p2col:{cmd:axisstyle horizontal_nogrid}  {space 1}{it:{help axisstyle}}}
	horizontal axis without grids{p_end}
{p2col:{cmd:axisstyle vertical_nogrid}    {space 3}{it:{help axisstyle}}}
	vertical axis without grids{p_end}

{p2col:{cmd:axisstyle bar_super}          {space 9}{it:{help axisstyle}}}
	supergroup component of {helpb graph bar} axis{p_end}
{p2col:{cmd:axisstyle bar_group}          {space 9}{it:{help axisstyle}}}
	group component of {helpb graph bar} axis{p_end}
{p2col:{cmd:axisstyle bar_var}            {space 11}{it:{help axisstyle}}}
	yvar component of {helpb graph bar} axis{p_end}

{p2col:{cmd:axisstyle dot_super}          {space 9}{it:{help axisstyle}}}
	supergroup component of {helpb graph dot} axis{p_end}
{p2col:{cmd:axisstyle dot_group}          {space 9}{it:{help axisstyle}}}
	group component of {helpb graph dot} axis{p_end}
{p2col:{cmd:axisstyle dot_var}            {space 11}{it:{help axisstyle}}}
	yvar component of {helpb graph dot} axis{p_end}

{p2col:{cmd:axisstyle bar_scale_horiz}    {space 3}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph hbar}{p_end}
{p2col:{cmd:axisstyle bar_scale_vert}     {space 4}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph bar}{p_end}

{p2col:{cmd:axisstyle box_scale_horiz}    {space 3}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph hbox}{p_end}
{p2col:{cmd:axisstyle box_scale_vert}     {space 4}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph box}{p_end}

{p2col:{cmd:axisstyle dot_scale_horiz}    {space 3}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph dot}{p_end}
{p2col:{cmd:axisstyle bar_scale_vert}     {space 4}{it:{help axisstyle}}}
	{it:y} axis of {helpb graph dot}, if {it:y} axis is vertical{p_end}

{p2col:{cmd:axisstyle matrix_horiz}       {space 6}{it:{help axisstyle}}}
	horizontal axis for {helpb graph matrix}{p_end}
{p2col:{cmd:axisstyle matrix_vert}        {space 7}{it:{help axisstyle}}}
	vertical axis for {helpb graph matrix}{p_end}
{p2line}
{p2colreset}{...}
