{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control graphs drawn by graph matrix}

{p 3 3 2}
These settings control the overall look of graphs drawn with 
{helpb graph matrix}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_matrix##remarks1:Markers}{p_end}
{p 8 12 0}{help scheme_graph_matrix##remarks2:Markers labels}{p_end}
{p 8 12 0}{help scheme_graph_matrix##remarks3:Diagonal titles}{p_end}
{p 8 12 0}{help scheme_graph_matrix##remarks4:Plot region}{p_end}
{p 8 12 0}{help scheme_graph_matrix##remarks5:Advanced axis options}

{p 3 3 2}
Some characteristics of the appearance of scatter plot matrices are shared
with all other graphs; see {help scheme graph shared} to change these
settings.


{marker remarks1}{...}
{space 3}{title:Markers}

{p2colset 4 47 50 0}{...}
{p 3 3 2}
These entries specify the look of markers plotted by {cmd:graph matrix}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:symbol      {space 5}matrix}         {space 8}{it:{help symbolstyle}}}
	marker symbol{p_end}
{p2col:{cmd:symbolsize  {space 1}matrix}         {space 8}{it:{help markersizestyle}}}
	marker size{p_end}
{p2col:{cmd:color       {space 6}matrix}         {space 8}{it:{help colorstyle}}}
	fill color of markers{p_end}
{p2col:{cmd:color       {space 6}matrixmarkline} {space 0}{it:{help colorstyle}}}
	outline color of markers{p_end}
{p2col:{cmd:linewidth   {space 2}matrixmark}     {space 4}{it:{help linewidthstyle:linewidth}}}
	marker outline thickness{p_end}

{p2col:{cmd:linestyle   {space 2}matrixmark}     {space 4}{it:{help linestyle}}}
	marker outline style (*){p_end}
{p2col:{cmd:markerstyle {space 0}matrix}         {space 8}{it:{help markerstyle}}}
	marker style (*){p_end}
{p2col:{cmd:seriesstyle {space 0}matrix}         {space 8}{it:{help pstyle}}}
	overall {it:pstyle} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{space 3}{title:Marker labels}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of marker labels plotted by 
{cmd:graph matrix}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize       {space 7}matrix_marklbl} {space 0}{it:{help textsizestyle}}}
	text size{p_end}
{p2col:{cmd:color       {space 7}matrix_marklbl} {space 0}{it:{help colorstyle}}}
	text color{p_end}
{p2col:{cmd:clockdir    {space 4}matrix_marklbl} {space 0}{it:{help clockpos}}}
	position of labels on markers{p_end}
{p2col:{cmd:gsize       {space 7}matrix_mlblgap} {space 0}{it:{help textsizestyle}}}
	gap between marker and label{p_end}

{p2col:{cmd:textboxstyle {space 0}matrix_marklbl} {space 0}{it:{help textstyle}}}
	{it:textstyle} of marker labels (*){p_end}
{p2col:{cmd:labelstyle   {space 2}matrix}         {space 8}{it:{help labelstyle}}}
	{it:labelstyle} of marker labels (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{space 3}{title:Diagonal titles}

{p2colset 4 47 50 0}{...}
{p 3 3 2}
These entries specify the look of the variable titles, or labels, that are
shown on the diagonal of a scatter plot matrix.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize      {space 5}matrix_label}    {space 3}{it:{help textsizestyle}}}
	text size{p_end}
{p2col:{cmd:color      {space 5}matrix_label}    {space 3}{it:{help colorstyle}}}
	text color{p_end}
{p2col:{cmd:margin     {space 4}matrix_label}    {space 3}{it:{help marginstyle}}}
	margin around text{p_end}
{p2col:{cmd:margin     {space 4}matrix_lab_box}  {space 1}{it:{help marginstyle}}}
	outer margin around text box{p_end}
{p2col:{cmd:color      {space 5}mat_label_box} {space 2}{it:{help colorstyle}}}
	background fill color{p_end}
{p2col:{cmd:vertical_text matrix_label} {space 0}{it:{help alignmentstyle}}}
	vertical alignment of text{p_end}
{p2col:{cmd:horizontal {space 0}matrix_label} {space 0}{it:{help justificationstyle}}}
	text justification{p_end}

{p2col:{cmd:linestyle  {space 1}mat_label_box} {space 2}{it:{help linestyle}}}
	outline style for textbox; rarely used; usual default is {cmd:foreground}{p_end}
{p2col:{cmd:textboxstyle matrix_label} {space 1}{it:{help textboxstyle}}}
	overall text box style (*){p_end}
{p2col:{cmd:plotregionstyle matrix_label} {space 0}{it:{help plotregionstyle}} {space 1}overall {it:plotregionstyle}}{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:matrix_label}, and the entries in the table will affect the titles.  If a
scheme specifies a different composite style for {it:textboxstyle}, entries 
associated with that composite style must be used to change the look
of diagonal titles.{p_end}


{marker remarks4}{...}
{space 3}{title:Plot region}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {cmd:graph matrix}.
Separate entries control the appearance of overall plot region into which
individual scatter graphs are drawn, and others control the plot regions of the
individual scatter graphs.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color     {space 4}matrix_plotregion}   {space 2}{it:{help colorstyle}}}
	plot region fill color{p_end}
{p2col:{cmd:intensity {space 0}matrix_plotregion}   {space 2}{it:{help intensitystyle}}}
	plot region {it:intensitystyle}{p_end}
{p2col:{cmd:margin    {space 3}matrixgraph}         {space 8}{it:{help marginstyle}}}
	outer margin around area where individual graphs are drawn{p_end}
{p2col:{cmd:margin    {space 3}matrix_plotreg}      {space 5}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:linewidth {space 0} matrix_plotregion}  {space 2}{it:{help linewidthstyle:linewidth}}}
	plot region outline thickness{p_end}
{p2col:{cmd:color     {space 4}matplotregion_line}  {space 1}{it:{help colorstyle}}}
	plot region outline color{p_end}
{p2colset 4 51 52 0}{...}
{p2col:{cmd:linepattern {space 0}matrix_plotregion} {space 0}{it:{help linepatternstyle}}}
	outline pattern for plot region{p_end}

{p2colset 4 49 52 0}{...}
{p2col:{cmd:shadestyle {space 0} matrix_plotregion}      {space 5}{it:{help shadestyle}}}
	plot region {it:shadestyle}{p_end}
{p2col:{cmd:linestyle  {space  1}matrix_plotregion}       {space 6}{it:{help linestyle}}}
	plot region outline style{p_end}
{p2col:{cmd:areastyle  {space 1}matrixgraph_plotregion}  {space 1}{it:{help areastyle}}}
	overall plot region areastyle (*){p_end}
{p2col:{cmd:areastyle  {space 1}matrixgraph_iplotregion} {space 0}{it:{help areastyle}}}
	inner plot region areastyle (*){p_end}
{p2col:{cmd:plotregionstyle {space 1}matrixgraph} {space 0}{it:{help plotregionstyle}}}
	overall plot region style (*){p_end}
{p2col:{cmd:plotregionstyle {space 1}matrix}      {space 5}{it:{help plotregionstyle}}}
	interior plot region style (*){p_end}

{p2col:{cmd:areastyle       {space 0}matrix_plotregion}  {space 1}{it:{help areastyle}}}
	{it:areastyle} of individual graph's overall graph region{p_end}
{p2col:{cmd:areastyle       {space 0}matrix_iplotregion} {space 0}{it:{help areastyle}}}
	{it:areastyle} of individual graph's inner graph region{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks5}{...}
{title:Advanced axis options}

{p2colset 4 41 44 0}{...}
{p 3 3 2}
These rarely used entries supply additional options to scatterplot matrices.
For example,

	{cmd:special matrix yaxis "ylabels(#2, angle(horizontal) axis(Y)"}

{p 3 3 2}
specifies that approximately two ticks be used on scatterplot matrices and
that the labels be horizontal.  Note that the {cmd:axis(Y)} directive is
required for {it:y} axes and, similarly, that {cmd:axis(X)} would be required
for {it:x} axes.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:special matrix_yaxis} {space 0}{help axis_options}}
	additional options for the {it:y} axes{p_end}
{p2col:{cmd:special matrix_xaxis} {space 0}{help axis_options}}
	additional options for the {it:x} axes{p_end}
{p2line}
{p2colreset}{...}
