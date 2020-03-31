{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7pie}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph pie charts ({cmd:graph7, pie} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:p:ie} [{it:common_options}]


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
{cmd:graph7} {it:...} {cmd:, pie} {it:...} specifies a pie chart.  Sums of
the variables determine the area of the slice.  You may specify up to 16
variables and Stata will place up to 64 pie charts in one image.  For an
introduction to {cmd:graph7}, see {helpb graph7}.


{title:Examples}

{p 4 8 2}{cmd:. graph7 a b c, pie}

{p 4 8 2}{cmd:. graph7 a b c, pie by(category)}

{p 4 8 2}{cmd:. graph7 dlabor ilabor parts advert oh, pie by(year) sh(31324) title("Distribution of Costs, XYZ Company")}


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
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}
{p_end}
