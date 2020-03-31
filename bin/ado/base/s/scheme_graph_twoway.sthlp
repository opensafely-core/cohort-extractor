{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme area plots" "help scheme area plots"}{...}
{vieweralsosee "scheme bar plots" "help scheme bar plots"}{...}
{vieweralsosee "scheme connected plots" "help scheme connected plots"}{...}
{vieweralsosee "scheme histogram plots" "help scheme histogram plots"}{...}
{vieweralsosee "scheme line plots" "help scheme line plots"}{...}
{vieweralsosee "scheme scatter plots" "help scheme scatter plots"}{...}
{vieweralsosee "scheme sunflower plots" "help scheme sunflower plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control graphs drawn by twoway}

{p 3 3 2}
These settings control the overall look of graphs drawn with {helpb twoway}.

{p 3 3 2}
For entries that control the appearance of scatter, line, and other plots
plotted by {cmd:twoway}, see one of the following: 

{p 16 20 4}{help scheme scatter plots:Scatter plots}{p_end}
{p 16 20 4}{help scheme connected plots:Connected marker plots}{p_end}
{p 16 20 4}{help scheme line plots:Line plots}{p_end}
{p 16 20 4}{help scheme area plots:Area plots}{p_end}
{p 16 20 4}{help scheme bar plots:Bar plots}{p_end}
{p 16 20 4}{help scheme sunflower plots:Sunflower plots}{p_end}
{p 16 20 4}{help scheme histogram plots:Histogram plots}{p_end}

{p 3 3 2}
In addition, some characteristics of the appearance of twoway graphs are
shared with all other graphs; see {help scheme graph shared} to change
these settings.


{space 3}{title:Plot regions for twoway}
{p2colset 4 49 52 0}
{p 3 3 2}
These entries specify the look of plot regions for {helpb twoway}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}twoway_plotregion}  {space 1}{it:{help areastyle}}}
	overall plot region areastyle; 
	usual default {it:areastyle} is 
	{helpb scheme plotregion def:plotregion} (*){p_end}
{p2col:{cmd:areastyle       {space 0}twoway_iplotregion} {space 0}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 10}plotregion}       {space 1}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 1}twoway}      {space 5}{it:{help plotregionstyle}}}
	plot region overall style; usual default is {cmd:plotregion} (*){p_end}
{p2col:{cmd:plotregionstyle {space 1}transparent} {space 0}{it:{help plotregionstyle}}}
	plot region style for overlaid plot regions; rarely changed (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.{p_end}
{p2colreset}{...}
