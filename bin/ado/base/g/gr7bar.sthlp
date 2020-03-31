{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7bar}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph bar charts ({cmd:graph7, bar} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:ba:r} [{it:common_options}
[{cmd:no}]{cmdab:al:t} {cmdab:me:ans} {cmdab:st:ack}]


{center:{it:common_options}                                See help}
{center:{hline 54}}
{center:title and axes options                        {help gr7axes} }
{center:symbol and line options                       {help gr7sym}  }
{center:color and shading options                     {help gr7color}}
{center:saving, printing, & multiple image options    {help gr7other}}
{center:{hline 54}}


{p 4 4 2}
{cmd:by} is allowed; see {helpb by}.


{title:Description}

{p 4 4 2}
{cmd:graph7} {it:...} {cmd:, bar} {it:...} specifies a bar chart.  Sums or
means (see {cmd:means} option below) of the variables determine the height of
the bars.  For an introduction to {cmd:graph7}, see {helpb graph7}.


{title:Options unique to {cmd:bar}}

{p 4 8 2}[{cmd:no}]{cmd:alt} forces the labeling of groups to be on single or
multiple lines.  {cmd:graph7} chooses whether the text labeling each box should
be on the same line or instead alternative between two lines.  If you do not
like {cmd:graph7}'s choice, [{cmd:no}]{cmd:alt} allows you to enforce your
preferences.  {cmd:alt} forces the staggered look whereas {cmd:noalt} forces
the single-line approach.

{p 4 8 2}{cmd:means} scales the bars according to the means of the variables
rather than their sums.  "{cmd:graph7 cost revenue, bar by(region)}" graphs
total cost and revenues for each region.  "{cmd:graph7 cost revenue, bar by(region) means}" graphs average cost and revenues.

{p 4 8 2}{cmd:stack} stacks the bars for each variable rather than placing them
side-by-side.


{title:Examples}

{p 4 8 2}{cmd:. graph7 a b c, bar}{p_end}
{p 4 8 2}{cmd:. graph7 a b c, bar means}{p_end}
{p 4 8 2}{cmd:. graph7 a, bar by(category)}{p_end}
{p 4 8 2}{cmd:. graph7 a b, bar by(category) stack}

{p 4 8 2}{cmd:. graph7 labor parts advert oh, bar by(year) shading(3124) ylabel yline ti("Costs by Fiscal Year") l1("(Thousands of Dollars)")}


{title:Also see}

{pstd}
The eight {cmd:graph7} types are specified as options.  The other seven
types are

{center:Option       Graph type                    See help }
{center:{hline 52}}
{center:{cmdab:hi:stogram}    histogram                     {help gr7hist}  }
{center:{cmdab:t:woway}       Two-way scatterplot           {help gr7twoway}}
{center:{cmdab:m:atrix}       Two-way scatterplot matrix    {help gr7matrix}}
{center:{cmdab:o:neway}       One-way scatterplot           {help gr7oneway}}
{center:{cmdab:b:ox}          Box-and-whisker plot          {help gr7box}   }
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}; {manhelp histogram R}
{p_end}
