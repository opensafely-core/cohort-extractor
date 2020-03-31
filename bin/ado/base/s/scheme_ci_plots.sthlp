{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Confidence interval plot scheme entries}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
These entries control the look of confidence intervals (CIs) for those graphs
or plots that use CIs, such as {helpb twoway lfitci}.  More accurately, they
specify the attributes of the {cmd:ci} and {cmd:ci2} {help pstyle:pstyles}
that are the default {cmd:pstyle}s for CIs.  Generally, the {cmd:ci} entries
control the look of the first plot used to show a CI, and the {cmd:ci2} entries
control the look of a second plot used to show a CI, if a second CI plot is
required.  Users, however, may choose to apply the {cmd:ci} or {cmd:ci2}
pstyles to any plot.  

{p 3 3 2}
Note that how the CI is drawn -- for example, as a filled area ({cmd:rarea}
plottype), two lines ({cmd:rline} plottype), or other plottype -- will
determine which of the scheme entries takes effect.

{p2col:Entry} Description{p_end}
{p2line}

{p2col:{cmd:color       {space 6}ci_line}      {space 5}{it:{help colorstyle}}}
	line color for {cmd:ci}{p_end}
{p2col:{cmd:color       {space 6}ci2_line}     {space 4}{it:{help colorstyle}}}
	line color for {cmd:ci2}{p_end}
{p2col:{cmd:color       {space 6}ci_area}      {space 5}{it:{help colorstyle}}}
	fill color of areas for {cmd:ci}{p_end}
{p2col:{cmd:color       {space 6}ci2_area}     {space 4}{it:{help colorstyle}}}
	fill color of areas for {cmd:ci2}{p_end}
{p2col:{cmd:color       {space 6}ci_arealine}  {space 1}{it:{help colorstyle}}}
	outline color of areas for {cmd:ci}{p_end}
{p2col:{cmd:color       {space 6}ci2_arealine} {space 0}{it:{help colorstyle}}}
	outline color of areas for {cmd:ci}{p_end}
{p2col:{cmd:color       {space 6}ci_symbol}    {space 3}{it:{help colorstyle}}}
	marker color for {cmd:ci}{p_end}
{p2col:{cmd:color       {space 6}ci2_symbol}   {space 2}{it:{help colorstyle}}}
	marker color for {cmd:ci2}{p_end}
{p2col:{cmd:linewidth   {space 2}ci}           {space 10}{it:{help linewidthstyle:linewidth}}}
	line thickness for {cmd:ci} when drawn as a line{p_end}
{p2col:{cmd:linewidth   {space 2}ci2}          {space 9}{it:{help linewidthstyle:linewidth}}}
	line thickness for {cmd:ci2} when drawn as a line{p_end}
{p2col:{cmd:linewidth   {space 2}ci_area}      {space 5}{it:{help linewidthstyle:linewidth}}}
	line thickness for {cmd:ci} when drawn as an area{p_end}
{p2col:{cmd:linewidth   {space 2}ci2_area}     {space 4}{it:{help linewidthstyle:linewidth}}}
	line thickness for {cmd:ci2} when drawn as an area{p_end}
{p2col:{cmd:linepattern {space 0}ci_area}      {space 5}{it:{help linepatternstyle}}}
	line and outline pattern for {cmd:ci} and {cmd:ci2}{p_end}
{p2col:{cmd:linepattern {space 0}ci}           {space 10}{it:{help linepatternstyle}}}
	connecting line pattern for {cmd:ci} and {cmd:ci2}; rarely used{p_end}
{p2col:{cmd:intensity   {space 2}ci}           {space 10}{it:{help intensitystyle}}}
	{it:intensitystyle} for {cmd:ci} and {cmd:ci2}{p_end}
{p2col:{cmd:symbol       {space 5}ci}           {space 10}{it:{help symbolstyle}}}
	marker symbol for {cmd:ci}; rarely used{p_end}
{p2col:{cmd:symbol       {space 5}ci2}          {space 9}{it:{help symbolstyle}}}
	marker symbol for {cmd:ci2}; rarely used{p_end}
{p2col:{cmd:symbolsize   {space 1}ci}           {space 10}{it:{help markersizestyle}}}
	marker size for {cmd:ci}; rarely used{p_end}
{p2col:{cmd:symbolsize   {space 1}ci2}          {space 9}{it:{help markersizestyle}}}
        marker size for {cmd:ci2}; rarely used{p_end}

{p2col:{cmd:areastyle    {space 2}ci}           {space 10}{it:{help areastyle}}}
	{it:areastyle} for confidence interval ({cmd:ci}) (*){p_end}
{p2col:{cmd:areastyle    {space 2}ci2}           {space 9}{it:{help areastyle}}}
	{it:areastyle} for second confidence interval ({cmd:ci2}) (*){p_end}
{p2col:{cmd:linestyle    {space 2}ci}           {space 10}{it:{help linestyle}}}
	{it:linestyle} for confidence intervals when drawn as lines (*){p_end}
{p2col:{cmd:linestyle    {space 2}ci2}          {space 9}{it:{help linestyle}}}
	{it:linestyle} for second confidence intervals when drawn as
	lines (*){p_end}
{p2col:{cmd:linestyle    {space 2}ci_area}      {space 5}{it:{help linestyle}}}
	{it:linestyle} for confidence interval outlines when drawn as an 
	area (*){p_end}
{p2col:{cmd:linestyle    {space 2}ci2_area}     {space 4}{it:{help linestyle}}}
	{it:linestyle} for second confidence interval outlines when drawn as
	an area (*){p_end}
{p2col:{cmd:marker       {space 5}ci}           {space 10}{it:{help markerstyle}}}
	marker for confidence interval ({cmd:ci}) (*){p_end}
{p2col:{cmd:marker       {space 5}ci2}          {space 9}{it:{help markerstyle}}}
	marker for second confidence interval ({cmd:ci2}) (*){p_end}
{p2col:{cmd:shadestyle   {space 1}ci}           {space 10}{it:{help shadestyle}}}
	{it:shadestyle} for confidence interval ({cmd:ci}) (*){p_end}
{p2col:{cmd:shadestyle   {space 1}ci2}          {space 9}{it:{help shadestyle}}}
	{it:shadestyle} for second confidence interval ({cmd:ci2}) (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.{p_end}
{p2colreset}{...}
