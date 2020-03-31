{smcl}
{* *! version 1.0.4  13mar2015}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Legend scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of graph legends across all graph families.{p_end}

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_legends##remarks1:Legend positioning}{p_end}
{p 8 12 0}{help scheme_legends##remarks2:Legend key labels}{p_end}
{p 8 12 0}{help scheme_legends##remarks3:Legend construction}{p_end}
{p 8 12 0}{help scheme_legends##remarks4:Legend titles, subtitles, captions, and notes}{p_end}
{p 8 12 0}{help scheme_legends##remarks5:Legend areas}{p_end}
{p 8 12 0}{help scheme_legends##remarks6:Overall setting}{p_end}


{marker remarks1}{...}
{title:Legend positioning}

{p2colset 4 47 50 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno         {space 8}legend_span}         {space 7}{{cmd:yes}|{cmd:no}}}
	{help scmd_ttlspan:centering/spanning}{p_end}
{p2col:{cmd:gridringstyle {space 0}legend_ring}         {space 7}{it:{help ringpos}}}
	{help scmd_ttlring:distance from plot region}{p_end}
{p2col:{cmd:clockdir       {space 5}legend_position}    {space 3}{it:{help clockpos}}}
	position with respect to plot region{p_end}

{p2col:{cmd:gridringstyle {space 0}by_legend_ring}      {space 4}{it:{help ringpos}}}
	{help scmd_ttlring:distance from plot region} for {help by_option:by graphs}{p_end}
{p2col:{cmd:clockdir       {space 5}by_legend_position} {space 0}{it:{help clockpos}}}
	position with respect to plot region for {help by_option:by graphs}{p_end}
{p2line}


{marker remarks2}{...}
{title:Legend key labels}

{p2colset 4 48 51 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize          {space 8}key_label}  {space 1}{it:{help textsizestyle}}}
	key-label text size{p_end}
{p2col:{cmd:color          {space 8}key_label}  {space 1}{it:{help textsizestyle}}}
	key-label text color{p_end}
{p2col:{cmd:margin         {space 7}key_label}  {space 1}{it:{help textsizestyle}}}
	margin around key-label text{p_end}
{p2col:{cmd:compass2dir    {space 2}key_label}  {space 1}{it:{help compassdirstyle}}}
	label position for legend keys{p_end}
{p2col:{cmd:horizontal     {space 3}key_label}  {space 1}{it:{help justificationstyle}}}
	key-label justification; rarely used; use 
	{cmd:compass2dir key_label} instead{p_end}
{p2col:{cmd:vertical_text  {space 0}key_label}  {space 1}{it:{help alignmentstyle}}}
	key-label alignment; rarely used; use 
	{cmd:compass2dir key_label} instead{p_end}
{p2col:{cmd:textboxstyle   {space 1}legend_key} {space 0}{it:{help textboxstyle}}}
	overall look of labels on legend keys (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:legend_key}, and the entries in the table that identify {cmd:key_label}
as the graph element will affect key labels.  If a scheme specifies a
different composite style for {it:textboxstyle}, entries associated with
that composite style must be used to change the look of key labels.{p_end}


{marker remarks3}{...}
{title:Legend construction}

{p2colset 4 44 47 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:numstyle {space 0}legend_rows}         {space 5}{it:#}}
	number of columns for the keys{p_end}
{p2col:{cmd:numstyle {space 0}legend_rows}         {space 5}{it:#}}
	number of rows for the keys{p_end}

{p2col:{cmd:gsize    {space 3}legend_row_gap}      {space 2}{it:{help textsizestyle}}}
	distance between rows of keys{p_end}
{p2col:{cmd:gsize    {space 3}legend_col_gap}      {space 2}{it:{help textsizestyle}}}
	distance between columns of keys{p_end}
{p2col:{cmd:gsize    {space 3}legend_key_gap}      {space 2}{it:{help textsizestyle}}}
	gap between key marker and label for most 
	{help legendstyle:legendstyles}{p_end}
{p2col:{cmd:gsize    {space 3}key_gap}             {space 9}{it:{help textsizestyle}}}
	gap between key marker and label for other 
	{help legendstyle:legendstyles}{p_end}
{p2col:{cmd:gsize    {space 3}legend_key_xsize}    {space 0}{it:{help textsizestyle}}}
	length of keys other than markers, e.g., lines and boxes{p_end}
{p2col:{cmd:gsize    {space 3}legend_key_ysize}    {space 0}{it:{help textsizestyle}}}
	height of keys{p_end}

{p2col:{cmd:yesno    {space 3}legend_col_first}    {space 5}{{cmd:yes}|{cmd:no}}}
	order keys down the columns first ({cmd:yes}) or across the rows first
	({cmd:no}){p_end}
{p2col:{cmd:yesno    {space 3}legend_text_first}   {space 4}{{cmd:yes}|{cmd:no}}}
	place key labels before keys{p_end}
{p2col:{cmd:yesno    {space 3}legend_stacked}      {space 7}{{cmd:yes}|{cmd:no}}}
	place key labels over or under keys rather than beside the
	keys{p_end}
{p2col:{cmd:yesno    {space 3}legend_force_keysz}  {space 3}{{cmd:yes}|{cmd:no}}}
	always respect the default or specified x- and y-size of keys and
	never compress the size{p_end}

{p2col:{cmd:yesno    {space 3}legend_force_draw}   {space 4}{{cmd:yes}|{cmd:no}}}
	force a legend to be drawn, even when there is only one plot{p_end}
{p2col:{cmd:yesno    {space 3}legend_force_nodraw} {space 2}{{cmd:yes}|{cmd:no}}}
	never draw a legend{p_end}
{p2line}


{marker remarks4}{...}
{title:Legend titles, subtitles, captions, and notes}

{p2colset 4 52 56 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:textboxstyle  {space 1}leg_title}                {space 11}{it:{help textboxstyle}}}
	overall text style of legend subtitle (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}leg_subtitle}             {space 8}{it:{help textboxstyle}}}
	overall text style of legend subtitle (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}leg_caption}              {space 9}{it:{help textboxstyle}}}
	overall text style of legend subtitle (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}leg_note}                 {space 12}{it:{help textboxstyle}}}
	overall text style of legend subtitle (*){p_end}

{p2col:{cmd:clockdir      {space 5}legend_title_position}    {space 3}{it:{help clockpos}}}
	position of legend title{p_end}
{p2col:{cmd:clockdir      {space 5}legend_subtitle_position} {space 0}{it:{help clockpos}}}
	position of legend subtitle{p_end}
{p2col:{cmd:clockdir      {space 5}legend_caption_position}  {space 1}{it:{help clockpos}}}
	position of legend caption{p_end}
{p2col:{cmd:clockdir      {space 5}legend_note_position}     {space 4}{it:{help clockpos}}}
	position of legend note{p_end}

{p2col:{cmd:gridringstyle {space 0}legend_title_ring}    {space 7}{it:{help ringpos}}}
	legend title {help scmd_legttlring:distance from keys and labels}{p_end}
{p2col:{cmd:gridringstyle {space 0}legend_subtitle_ring} {space 4}{it:{help ringpos}}}
	legend subtitle {help scmd_legttlring:distance from keys and labels}{p_end}
{p2col:{cmd:gridringstyle {space 0}legend_caption_ring}  {space 5}{it:{help ringpos}}}
	legend caption {help scmd_legttlring:distance from keys and labels}{p_end}
{p2col:{cmd:gridringstyle {space 0}legend_note_ring}     {space 8}{it:{help ringpos}}}
	legend note {help scmd_legttlring:distance from keys and labels}{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:heading} for legend titles, {cmd:subheading} for legend subtitles,
{cmd:body} for legend captions, and {cmd:small_body} for legend notes; that
means these titles share the attributes of graph titles, subtitles, captions,
and notes, respectively; see {help scheme titles}, 
{help scheme subtitles}, {help scheme captions}, and
{help scheme notes} for setting these attributes.  If a scheme
specifies a different composite style for {it:textboxstyle} in one of these
entries, entries associated with that composite style must be used to
change the look of text.{p_end}


{marker remarks5}{...}
{title:Legend areas}

{p2colset 4 51 54 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}legend}              {space 13}{it:{help colorstyle}}}
	legend fill color{p_end}
{p2col:{cmd:intensity   {space 2}legend}              {space 13}{it:{help intensitystyle}}}
	legend background {it:intensitystyle}{p_end}
{p2col:{cmd:shadestyle   {space 1}legend}             {space 13}{it:{help shadestyle}}}
	legend background {it:shadestyle} (*){p_end}
{p2col:{cmd:linewidth   {space 2}legend}              {space 13}{it:{help linewidthstyle:linewidth}}}
	legend outline thickness, if drawn{p_end}
{p2col:{cmd:linepattern {space 0}legend}              {space 13}{it:{help linepatternstyle}}}
	outline pattern for legends{p_end}
{p2col:{cmd:color       {space  6}legend_line}        {space 8}{it:{help colorstyle}}}
	legend outline color{p_end}

{p2col:{cmd:linestyle   {space 2}legend}              {space 13}{it:{help linestyle}}}
	legend outline style (*){p_end}

{p2col:{cmd:margin      {space  5}legend}             {space 13}{it:{help marginstyle}}}
	margin around legends and inside the legend box{p_end}
{p2col:{cmd:margin      {space 5}legend_boxmargin}    {space 3}{it:{help marginstyle}}}
	margin around outside of a legend's box{p_end}
{p2col:{cmd:margin      {space 5}legend_key_region}   {space 2}{it:{help marginstyle}}}
	margin around the area of the legend where keys are drawn{p_end}
{p2col:{cmd:areastyle   {space 2}legend}              {space 13}{it:{help areastyle}}}
	overall legend area (*){p_end}
{p2col:{cmd:areastyle   {space 2}inner_legend}        {space  7}{it:{help areastyle}}}
	inner legend area (*){p_end}
{p2col:{cmd:areastyle   {space 2}legend_key_region}   {space  2}{it:{help areastyle}}}
	keys and labels region, overall (*){p_end}
{p2col:{cmd:areastyle   {space 2}legend_inkey_region} {space  0}{it:{help areastyle}}}
	keys and labels region, inner (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.{p_end}


{marker remarks6}{...}
{title:Overall setting}

{p2colset 4 40 43 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:legendstyle}  {space  10}{it:{help legendstyle}}}
	overall legend style; note that there is no graph element in this entry{p_end}
{p2line}
{p2colreset}{...}
