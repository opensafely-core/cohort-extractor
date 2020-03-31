{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Box plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb graph box} and 
{helpb graph hbox} plots.  See {it:{help scheme_files##remarks3:Plot entries}}
in {help scheme files} for a general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_box_plots##remarks1:Primary box plot entries}{p_end}
{p 8 12 0}{help scheme_box_plots##remarks2:Composite entries for box plots}{p_end}
{p 8 12 0}{help scheme_box_plots##remarks3:Custom median and whisker entries}{p_end}
{p 8 12 0}{help scheme_box_plots##remarks4:Overall look of boxes}{p_end}


{marker remarks1}{...}
{title:Primary box plot entries}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
These entries are most often used to change the look of box plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:box}     {space 5}{it:{help colorstyle}}}
	fill color for #th box plot{p_end}
{p2col:{cmd:intensity   {space 2}}{cmd:box}            {space 7}{it:{help intensitystyle}}}
	fill intensity for all box plots{p_end}

{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:box}     {space 5}{it:{help linewidthstyle:linewidth}}}
	outline thickness for #th box plot{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:box}     {space 5}{it:{help linepatternstyle}}}
	outline pattern for #th box plot (whiskers and median value){p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:boxline} {space 1}{it:{help colorstyle}}}
	outline color for #th box plot{p_end}
{p2col:{cmd:intensity   {space 2}}{cmd:box_line}       {space 2}{it:{help intensitystyle}}}
	outline intensity for all box plots{p_end}

{p2col:{cmd:symbol      {space 5}p}{it:#}{cmd:box}      {space 5}{it:{help symbolstyle}}}
	symbol of outside value markers for #th box plot{p_end}
{p2col:{cmd:symbolsize  {space 1}p}{it:#}{cmd:box}      {space 5}{it:{help markersizestyle}}}
	symbol size of outside value markers for #th box plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:boxmark}     {space 4}{it:{help linewidthstyle:linewidth}}}
	outline thickness of outside value markers for #th box plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:boxmarkfill} {space 0}{it:{help colorstyle}}}
	fill color of outside value markers for #th box plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:boxmarkline} {space 0}{it:{help colorstyle}}}
	outline color of outside value markers for #th box plot{p_end}

{p2col:{cmd:gsize       {space 6}p}{cmd:boxlabel}         {space 4}{it:{help textsizestyle}}}
	default text size of labels on outside value markers for all box 
	plots{p_end}
{p2col:{cmd:gsize       {space 6}p}{it:#}{cmd:boxlabel}    {space 3}{it:{help textsizestyle}}}
	text size of labels on outside value markers for #th box plot{p_end}
{p2col:{cmd:color       {space 6}p}{cmd:boxlabel}          {space 4}{it:{help colorstyle}}}
	default text color of labels on outside value markers for all 
	box plots{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:boxlabel}    {space 3}{it:{help colorstyle}}}
	text color of labels on outside value markers for #th box plot{p_end}
{p2col:{cmd:clockdir    {space 3}p}{it:#}{cmd:box}         {space 8}{it:{help clockpos}}}
	position of labels on outside value markers for #th box plot{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the box-plot-specific entries above, then
the look of those elements of box plots will be determined by default entries
that are shared among all plottypes; see {help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for box plots}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:box} (where {it:#} is the plot number); in
that case, the individual attribute entries shown in the table above control
the characteristics of box plots.  If, however, the styles for the composite
entries are changed, the individual attribute entries affecting
box plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle    {space 3}p}{it:#}{cmd:box}      {space 5}{it:{help linestyle}}}
	{it:linestyle} of box, whiskers, and median for the #th box plot{p_end}
{p2col:{cmd:linestyle    {space 3}p}{it:#}{cmd:boxmark}  {space 1}{it:{help linestyle}}}
	marker outline {it:linestyle} for the #th box plot{p_end}
{p2col:{cmd:shadestyle   {space 2}p}{it:#}{cmd:box}      {space 5}{it:{help shadestyle}}}
	{it:shadestyle} of box fills for #th box plot{p_end}
{p2col:{cmd:areastyle    {space 3}p}{it:#}{cmd:box}      {space 5}{it:{help areastyle}}}
	{it:areastyle} of box fills for the #th box plot{p_end}
{p2col:{cmd:textboxstyle {space 0}p}{it:#}{cmd:boxlabel} {space 0}{it:{help textstyle}}}
	{it:textstyle} of marker labels for the #th box plot{p_end}
{p2col:{cmd:labelstyle   {space 2}p}{it:#}{cmd:box}      {space 5}{it:{help textstyle}}}
	{it:labelstyle} of marker labels for the #th box plot{p_end}
{p2col:{cmd:markerstyle  {space 1}p}{it:#}{cmd:box}      {space 5}{it:{help markerstyle}}}
	marker style for the #th box plot{p_end}
{p2col:{cmd:seriesstyle  {space 1}p}{it:#}{cmd:box}      {space 5}{it:{help pstyle}}}
	overall {it:pstyle} for the #th box plot{p_end}
{p2line}


{marker remarks3}{...}
{title:Custom median and whisker entries}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
These entries determine whether so-called custom whiskers or median
designations are shown and how those custom elements look.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:medtypestyle {space 0}boxplot}               {space 5}{it:medstyle}} 
	how the median values are shown; {it:medstyle} may be {cmd:line},
	{cmd:cline}, or {cmd:dot}; other styles may be available; type{break}
	{stata graph query medtypestyle} to see the complete list{p_end}
{p2col:{cmd:yesno        {space 1}custom_whiskers}       {space 3}{{cmd:yes}|{cmd:no}}}
        use one custom linestyle for all whiskers{p_end}

{p2col:{cmd:linestyle    {space 3}box_whiskers}          {space 0}{it:{help linestyle}}}
	whisker {it:linestyle} when custom whisker lines are 
	specified (*){p_end}
{p2col:{cmd:linestyle    {space 3}box_median}            {space 2}{it:{help linestyle}}}
	median {it:linestyle} when custom median lines are 
	specified (*){p_end}
{p2col:{cmd:markerstyle  {space 1}box_marker}            {space 0}{it:{help markerstyle}}}
	marker style for median markers (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks4}{...}
{title:Overall look of boxes}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
This composite entry controls the overall look of boxes drawn with 
{helpb graph box} and {helpb graph hbox}.  It should rarely be changed; instead
change the individual components available in other entries.  The one possible
exception is setting{break} {cmd:barstyle box tukey}.

{p 3 3 2}
Type {stata graph query barstyle} to see available options for {it:barstyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:barstyle box}       {space 2}{it:barstyle}}
	overall style for boxes{p_end}
{p2line}
{p2colreset}{...}
