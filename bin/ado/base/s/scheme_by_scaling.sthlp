{smcl}
{* *! version 1.0.3  01mar2017}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scaling for by graphs, graph combine, and graph matrix}

{p 3 3 2}
These entries control the rate at which the size of text, markers, and line
widths are scaled (decreased) as the number of graphs plotted increases for 
{helpb by_option:graph, by()}; {helpb graph combine}; and {helpb graph matrix}.

{p 3 3 2}
These are advanced and rarely used scheme file entries.{p_end}

{p2colset 4 29 32 0}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:special by_slope1}      {space 5}{it:#}}
	rate of scaling before the knot for {cmd:by} graphs (1){p_end}
{p2col:{cmd:special by_knot1}      {space 6}{it:#}}
	point at which scaling changes from slope1 to slope2 for {cmd:by}
	graphs(3){p_end}
{p2col:{cmd:special by_slope2}      {space 5}{it:#}}
	rate of scaling after the knot for {cmd:by} graphs (1){p_end}
{p2col:{cmd:special combine_slope1}  {space 0}{it:#}}
	rate of scaling before the knot for {cmd:graph combine} (1){p_end}
{p2col:{cmd:special combine_knot1}   {space 1}{it:#}}
	point at which scaling changes from slope1 to slope2 for 
	{cmd:graph combine}(1){p_end}
{p2col:{cmd:special combine_slope2}  {space 0}{it:#}}
	rate of scaling after the knot for {cmd:graph combine} (1){p_end}
{p2col:{cmd:special matrix_slope1}   {space 1}{it:#}}
	rate of scaling before the knot for {cmd:graph matrix} (1){p_end}
{p2col:{cmd:special matrix_knot1}    {space 2}{it:#}}
	point at which scaling changes from slope1 to slope2 for 
	{cmd:graph matrix}(2){p_end}
{p2col:{cmd:special matrix_slope2}   {space 1}{it:#}}
	rate of scaling after the knot for {cmd:graph matrix} (1){p_end}
{p2line}
{p 3 7 2}
(1) Generally, 0<{it:#}<1 for slopes, with 0 being no scaling and 1 scaling in
nearly direct proportion to the ceiling of the square root of the number of
graphs.{p_end}
{p 3 7 2}
(2) When the ceiling of the square root of the exceeds the value of the knot,
the rate of scaling moves from slope1 to slope2.{p_end}
{p2colreset}{...}

{p 3 3 2}
The formula for the scaling factor is a spline based on the slopes and knots.
Let

	s1 = slope1
	s2 = slope2
	k  = knot
	n  = ceiling(sqrt(number_of_graphs))

{p 3 3 2}
The scaling factor is then

{p 8 12 4}
	s = 1 - s1(n-1)/n + indicator(n>k)(s2-s1)(n-k)/n

{p 3 3 2}
where s is the proportion of the unscaled size.  s close to 0 implies very
small sizes, and s=1 implies no scaling.
{p_end}
