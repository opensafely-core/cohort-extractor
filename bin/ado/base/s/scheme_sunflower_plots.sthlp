{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Sunflower plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb sunflower} plots.  See
{it:{help scheme_files##remarks3:Plot entries}} in {help scheme files} for a
general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_sunflower_plots##remarks1:Primary sunflower plot entries}{p_end}
{p 8 12 0}{help scheme_sunflower_plots##remarks1:Composite entries for sunflower plots}{p_end}


{marker remarks1}{...}
{title:Primary sunflower plot entries}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
Entries most often used to change the look of sunflower plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}sunflower}         {space 2}{it:{help colorstyle}}}
	sunflower marker color{p_end}
{p2col:{cmd:symbol      {space 5}sunflower}         {space 2}{it:{help symbolstyle}}}
	sunflower marker symbols{p_end}
{p2col:{cmd:symbolsize  {space 1}sunflower}         {space 2}{it:{help markersizestyle}}}
	sunflower plot marker size{p_end}

{p2col:{cmd:linewidth   {space 2}sunflower}         {space 2}{it:{help linewidthstyle:linewidth}}}
	sunflower petal thickness{p_end}

{p2col:{cmd:color       {space 6}sunflowerlb}       {space 0}{it:{help colorstyle}}}
	light sunflower background color{p_end}
{p2col:{cmd:color       {space 6}sunflowerdb}       {space 0}{it:{help colorstyle}}}
	dark sunflower background color{p_end}
{p2col:{cmd:color       {space 6}sunflowerlf}       {space 0}{it:{help colorstyle}}}
	light sunflower line color{p_end}
{p2col:{cmd:color       {space 6}sunflowerdf}       {space 0}{it:{help colorstyle}}}
	dark sunflower line color{p_end}
{p2col:{cmd:intensity   {space 2}sunflower}         {space 2}{it:{help intensitystyle}}}
	intensity of sunflower plots{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the sunflower-plot-specific entries
above, the look of those elements of sunflower plots will be determined
by default entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for sunflower plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
The entries in the table above assume that the following entries are not
changed.  If, however, the styles for the composite entries are changed, 
the individual attribute entries affecting sunflower plots may also change.
See the discussion in {it:{help scheme_files##remarks4:Composite entries}} of
{help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:markerstyle  {space 1}sunflower}             {space 2}{it:{help markerstyle}}}
	sunflower plot markers{p_end}
{p2col:{cmd:shadestyle   {space 2}sunflowerlb}           {space 0}{it:{help shadestyle}}}
	light sunflower background {it:shadestyle}{p_end}
{p2col:{cmd:shadestyle   {space 2}sunflowerdb}           {space 0}{it:{help shadestyle}}}
	dark sunflower background {it:shadestyle}{p_end}
{p2col:{cmd:areastyle    {space 3}sunflowerlb}           {space 0}{it:{help areastyle}}}
	light sunflower background {it:areastyle}{p_end}
{p2col:{cmd:areastyle    {space 3}sunflowerdb}           {space 0}{it:{help areastyle}}}
	dark sunflower background {it:areastyle}{p_end}
{p2col:{cmd:linestyle    {space 3}sunflower}             {space 2}{it:{help linestyle}}}
	line style for sunflower markers{p_end}
{p2col:{cmd:linestyle    {space 3}sunflowerlf}           {space 0}{it:{help linestyle}}}
	line style for light sunflower petals{p_end}
{p2col:{cmd:linestyle    {space 3}sunflowerdf}           {space 0}{it:{help linestyle}}}
	line style for dark sunflower petals{p_end}
{p2col:{cmd:linestyle    {space 3}sunflowerlb}           {space 0}{it:{help linestyle}}}
	outline style for light sunflower background{p_end}
{p2col:{cmd:linestyle    {space 3}sunflowerdb}           {space 0}{it:{help linestyle}}}
	outline style for dark sunflower background{p_end}
{p2col:{cmd:sunflower    {space 3}sunflower}             {space 0}{it:{help sunflowerstyle}}}
	overall {it:sunflowerstyle} for sunflower plots{p_end}
{p2col:{cmd:sunflower    {space 3}p}{it:#}               {space 7}{it:{help sunflowerstyle}}}
	overall {it:sunflowerstyle} for the #th sunflower plot, rarely 
	used{p_end}
{p2line}
{p2colreset}{...}
