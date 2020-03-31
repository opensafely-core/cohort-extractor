{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that are shared across graph families}

{p 3 3 2}
A few settings that affect how all graphs are constructed appear in
the table below.  In addition, see the following common and shared composite
entry definitions that are used by many schemes.

{p 8 12 4}{help scheme plotregion def:Areastyle for plot regions}{p_end}
{p 8 12 4}{help scheme labels:Labels and small labels}{p_end}
{p 8 12 4}{help scheme textbox common:Text boxing}{p_end}
{p 8 12 4}{help scheme foreground def:Foreground style definitions}{p_end}
{p 8 12 4}{help scheme background def:Background style definitions}{p_end}

{p2colset 4 41 44 0}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:graphsize   {space 2}y}            {space 11}{it:#}}
	height of available graph area (in inches){p_end}
{p2col:{cmd:graphsize   {space 2}x}            {space 11}{it:#}}
	width of available graph area (in inches){p_end}

{p2col:{cmd:margin      {space 5}graph}        {space 7}{it:{help marginstyle}}}
	margin around graphs{p_end}

{p2col:{cmd:areastyle   {space 2}graph}        {space 7}{it:{help areastyle}}}
	overall graph region for graphs other than 
	{helpb graph combine:combine}, {helpb by_option:by}, and
	{helpb graph pie:pie}; usual default is 
	{helpb scheme background def:background}.{p_end}
{p2col:{cmd:areastyle   {space 2}inner_graph}  {space 1}{it:{help areastyle}}}
	inner graph region for graphs other than 
	{helpb graph combine:combine}, {helpb by_option:by}, and
	{helpb graph pie:pie}; usual default is {cmd:none}{p_end}

{p2col:{cmd:numstyle    {space 3}graph_aspect} {space 0}{it:#}}
        the aspect ratio of the graph's plot region, where aspect ratio is
        defined as the height of the plot region divided by the width of the
        plot region (so, 1 would imply a square plot region); 0 is the usual 
	default and specifies that the aspect will adjust to maximize the
        height and width of the plot region{p_end}
{p2col:{cmd:compass2dir {space 0}graph_aspect} {space 0}{it:{help compassdirstyle}}}
	position of the plot region when the aspect ratio leaves extra space in the
	horizontal or vertical dimension; usual default is {cmd:center}{p_end}

{p2col:{cmd:numstyle    {space 3}pcycle}       {space 7}{it:#}}
        the {help pstyle} of plots is recycled and started again with {cmd:p1}
        when more than {it:#} plots are drawn; default {it:#} for most 
        {help schemes} is 15{p_end}
{p2line}
