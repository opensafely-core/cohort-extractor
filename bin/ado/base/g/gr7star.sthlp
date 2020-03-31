{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7star}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph star charts ({cmd:graph7, star} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:st:ar} [{it:common_options}
{cmdab:la:bel:(}{it:varname}{cmd:)}
{cmdab:s:elect:(}{it:#}{cmd:,}{it:#}{cmd:)}]


{center:{it:common_options}                                See help}
{center:{hline 54}}
{center:title and axes options                        {help gr7axes} }
{center:symbol and line options                       {help gr7sym}  }
{center:color and shading options                     {help gr7color}}
{center:saving, printing, & multiple image options    {help gr7other}}
{center:{hline 54}}


{p 4 4 2}
{cmd:by}  is allowed; see {helpb by}.


{title:Description}

{p 4 4 2}
{cmd:graph7} {it:...} {cmd:, star} {it:...} specifies a star chart.  Up to
16 variables may be specified.  For an introduction to {cmd:graph7}, see
{helpb graph7}.


{title:Options unique to {cmd:star}}

{p 4 8 2}{cmd:label(}{it:varname}{cmd:)} specifies that the contents of
{it:varname} should be used to label each star.  {it:varname} may be either
string or numeric.  By default, {cmd:graph7} labels each star with its
observation number.

{p 4 8 2}{cmd:select(}{it:#1}{cmd:,}{it:#2}{cmd:)} selects observations {it:#1}
through {it:#2} for graphing.  {cmd:graph7} still examines all the data to set
the scaling.  The scaling of a star chart is a function of all the stars to be
graphed.  {cmd:select()} allows you to magnify one or a few stars in the
data while maintaining the same scaling.


{title:Examples}

{p 4 8 2}{cmd:. graph7 x1 x2 x3 x4, star}

{p 4 8 2}{cmd:. graph7 headroom-gear_ratio, star bsize(125) label(make)}

{p 4 8 2}{cmd:. graph7 headroom-gear_ratio, star bsize(125) label(make) select(1,9)}


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
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}
{p_end}
