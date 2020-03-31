{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7matrix}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph scatterplot matrices ({cmd:graph, matrix} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:m:atrix} [{it:common_options}
{cmdab:h:alf} {cmdab:j:itter:(}{it:#}{cmd:)}]


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
{cmd:graph7} {it:...} {cmd:, matrix} {it:...} specifies a scatterplot
matrix.  Up to 30 variables may be specified.  For an introduction to
{cmd:graph7}, see {helpb graph7}.


{title:Options unique to {cmd:matrix}}

{p 4 8 2}{cmd:half} draws only the lower half of the matrix

{p 4 8 2}{cmd:jitter(}{it:#}{cmd:)} adds spherical random noise to each point
before graphing, where {it:#} represents the magnitude of the noise as a
percent of graphical area.  The default is {cmd:jitter(0)}.  {cmd:jitter(5)}
is a large amount.  (This is useful to keep categorical data from
overplotting.)


{title:Examples}

{p 4 8 2}{cmd:. graph7 w x y z, matrix}

{p 4 8 2}{cmd:. graph7 tempjan tempjuly heatdd cooldd, matrix label sy(.)}

{p 4 8 2}{cmd:. graph7 mpg-gear_ratio, matrix half nolabel sy(.)}

{p 4 8 2}{cmd:. graph7 mpg rep78 weight displ, mat lab s(.) c(s) bands(9)}


{title:Also see}

{pstd}
The eight {cmd:graph7} types are specified as options.  The other seven
types are

{center:Option       Graph type              See help }
{center:{hline 46}}
{center:{cmdab:hi:stogram}    histogram               {help gr7hist}  }
{center:{cmdab:t:woway}       Two-way scatterplot     {help gr7twoway}}
{center:{cmdab:o:neway}       One-way scatterplot     {help gr7oneway}}
{center:{cmdab:b:ox}          Box-and-whisker plot    {help gr7box}   }
{center:{cmdab:st:ar}         Star chart              {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart               {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart               {help gr7pie}   }
{center:{hline 46}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}
{p_end}
