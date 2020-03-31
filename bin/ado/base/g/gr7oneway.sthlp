{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7oneway}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph one-way scatterplots ({cmd:graph7, oneway} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:o:neway} [{it:common_options}
{cmdab:j:itter:(}{it:#}{cmd:)}]


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
{cmd:graph7} {it:...} {cmd:, oneway} {it:...} specifies a one-way
scatterplot and may be combined with {cmd:box} (see {help gr7box}).  For
an introduction to {cmd:graph7}, see {helpb graph7}.


{title:Options unique to {cmd:oneway}}

{p 4 8 2}{cmd:jitter(}{it:#}{cmd:)} turns on {it:#} randomly selected points
along the vertical line at the location of the data rather than display the
entire line.


{title:Examples}

{p 4 8 2}{cmd:. graph7 x, oneway} {space 8} (graphs a one-way scatterplot of x)

{p 4 8 2}{cmd:. graph7 x y, oneway} {space 6} (graphs one-way scatterplots of x and y)

{p 4 8 2}{cmd:. graph7 tempjuly, by(region) oneway} {space 6} (using {cmd:by()} option)

{p 4 8 2}{cmd:. graph7 tempjuly, by(region) oneway box} {space 2} (combined with {cmd:box} graph)


{title:Also see}

{pstd}
The eight {cmd:graph7} types are specified as options.  The other seven
types are

{center:Option       Graph type                    See help }
{center:{hline 52}}
{center:{cmdab:hi:stogram}    histogram                     {help gr7hist}  }
{center:{cmdab:t:woway}       Two-way scatterplot           {help gr7twoway}}
{center:{cmdab:m:atrix}       Two-way scatterplot matrix    {help gr7matrix}}
{center:{cmdab:b:ox}          Box-and-whisker plot          {help gr7box}   }
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}
{p_end}
