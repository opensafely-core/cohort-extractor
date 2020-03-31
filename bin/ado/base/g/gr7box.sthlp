{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7box}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph box-and-whisker plots ({cmd:graph, box} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:b:ox} [{it:common_options}
[{cmd:no}]{cmdab:al:t} {cmdab:v:width} {cmdab:r:oot}]


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
{cmd:graph7} {it:...} {cmd:, box} {it:...} specifies a box-and-whisker plot.
Up to 6 variables may be specified. For an introduction to {cmd:graph7}, see
{helpb graph7}.


{title:Options unique to {cmd:box}}

{p 4 8 2}[{cmd:no}]{cmd:alt} forces the labeling of groups to be on single or
multiple lines.  {cmd:graph7} chooses whether the text labeling each box should
be on the same line or instead alternative between two lines.  If you do not
like {cmd:graph7}'s choice, [{cmd:no}]{cmd:alt} allows you to enforce your
preferences.  {cmd:alt} forces the staggered look, whereas {cmd:noalt} forces
the single-line approach.

{p 4 8 2}{cmd:vwidth} makes the width of each box proportional to the number of
observations.

{p 4 8 2}{cmd:root} is used only with {cmd:vwidth}; it specifies the width of
the box is to be made proportional to the square root of the number of
observations.


{title:Examples}

{p 4 8 2}{cmd:. graph7 y x, box} {space 8} (graphs box-and-whiskers for y and x)

{p 4 8 2}{cmd:. graph7 y, box by(id)} {space 3} (graphs box-and-whiskers for y by id groups)

{p 4 8 2}{cmd:. graph7 y x, box by(id)} {space 1} (graphs it by id for both y and x)

{p 4 8 2}{cmd}. gr7 tempjan, box by(region) total ylabel s(o) vwidth yline(32)
	ylabel(0 16 to 80) t2("width proportional to # of cities")
	ti(Box Plots by Census Division) l1(Jan. temp. in Fahrenheit){txt}


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
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}; {manhelp lv R}
{p_end}
