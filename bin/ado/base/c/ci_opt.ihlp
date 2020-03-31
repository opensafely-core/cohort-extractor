{* *! version 1.0.1  15oct2015}{...}
{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt separator(#)} specifies how often separation lines should be inserted
into the output.  The default is {cmd:separator(5)}, meaning that a line is
drawn after every five variables.  {cmd:separator(10)} would draw the line
after every 10 variables. {cmd:separator(0)} suppresses the separation line.

{phang}
{opt total} is used with the {opt by} prefix. It requests that in addition
to output for each by-group, output be added for all groups combined.
{p_end}
