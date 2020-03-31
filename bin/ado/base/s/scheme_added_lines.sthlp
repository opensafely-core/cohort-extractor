{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries for added lines}

{p 3 3 2}
These entries specify the look of lines added with the 
{helpb added_line_options:yline()} or {helpb added_line_options:xline()}
options.  They also define the {cmd:xyline} {help linestyle} that you may
apply to any lines drawn by {helpb graph}.

{p 3 3 2}
The scheme entries are presented under the following headings:

{p 8 12 0}{help scheme_added_lines##remarks1:Definition of xyline linestyle}{p_end}
{p 8 12 0}{help scheme_added_lines##remarks2:Constructing added lines}{p_end}


{marker remarks1}{...}
{title:Definition of {cmd:xyline} linestyle}

{p2colset 4 43 47 0}{...}
{p 3 3 2}
These entries define the look of the {cmd:xyline} {help linestyle}.  

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}xyline}  {space 1}{it:{help colorstyle}}}
	line color{p_end}
{p2col:{cmd:linewidth   {space 2}xyline}  {space 1}{it:{help linewidthstyle:linewidth}}}
	line thickness{p_end}
{p2col:{cmd:linepattern {space 0}xyline}  {space 1}{it:{help linepatternstyle}}}
	line pattern{p_end}
{p2line}


{marker remarks2}{...}
{title:Constructing added lines}

{p2colset 4 41 44 0}{...}
{p 3 3 2}
These entries specify how added lines created by the 
{helpb added_line_options:yline()} or {helpb added_line_options:xline()} options
are constructed and what {help linestyle} is used to draw the lines.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno {space 1}xyline_extend_low}  {space 1}{{cmd:yes}|{cmd:no}}}
        extend added lines (see {manhelpi added_line_options G-3}) through the
        plot region margin to the bounding box of the plot region ({cmd:yes}), 
	or only to the lower inner margin of the plot region
        ({cmd:no}){p_end}
{p2col:{cmd:yesno {space 1}xyline_extend_high} {space 0}{{cmd:yes}|{cmd:no}}}
        extend added lines (see {manhelpi added_line_options G-3}), through the
        plot region margin to the bounding box of the plot region ({cmd:yes}), 
	or only to the upper inner margin of the plot region
        ({cmd:no}){p_end}

{p2col:{cmd:linestyle  {space 2}xyline}      {space 5}{it:{help linestyle}}}
	{it:linestyle} of lines drawn using the {cmd:xline()} and {cmd:yline()}
	options; see {manhelpi added_line_options G-3}; the default is 
	{cmd:xyline}{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.
{p_end}
{p2colreset}{...}
