{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7hist}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph histograms ({cmd:graph7, histogram} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:variable}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:hi:stogram} [{it:common_options}
{cmdab:b:in:(}{it:#}{cmd:)}
{c -(}{cmdab:f:req} | {cmd:percent}{c )-}
{cmdab:norm:al}[{cmd:(}{it:#}{cmd:,}{it:#}{cmd:)}]
{cmdab:d:ensity:(}{it:#}{cmd:)}]


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
{cmd:graph7} {it:...} {cmd:, histogram} {it:...} specifies a histogram is to
be drawn; this is the default for {cmd:graph7} when only one variable is
specified and so the {cmd:histogram} option is seldom typed.  For an
introduction to {cmd:graph7}, see {helpb graph7}.


{title:Options unique to {cmd:histogram}}

{p 4 8 2}{cmd:bin(}{it:#}{cmd:)} specifies the number of intervals to use for
accumulating the histogram.  The default is {cmd:bin(5)}.

{p 4 8 2}
{cmd:freq} and {cmd:percent} affect how the vertical axis is labeled.
{cmd:freq} labels the vertical axis in frequency rather than fractional
units.  {cmd:percent} labels the axis in percent.

{p 4 8 2}{cmd:normal}[{cmd:(}{it:#}{cmd:,}{it:#}{cmd:)}] draws a normal density
over the histogram.  {cmd:normal} by itself will calculate and use the
observed mean and standard deviation.  {cmd:normal(1,2)} would overlay a
normal with mean 1 and standard deviation 2.

{p 4 8 2}{cmd:density(}{it:#}{cmd:)} is used only with {cmd:normal}; it
specifies the number of points along the density to be calculated.  Default is
{cmd:density(100)}.


{title:Examples}

{p 4 4 2}
Since {cmd:histogram} is the default for {cmd:graph7} with one variable

{p 8 35 2}{cmd:. graph7 x} {space 16} (draws a histogram of x)

{p 8 35 2}{cmd:. graph7 x, bin(11)} {space 7} (uses 11 bins for histogram)

{p 8 35 2}{cmd:. graph7 x, normal(10,3)} {space 2} (overdraws a normal mean 10
s.d. 3 density)

{p 4 4 2}
A more involved example:

{p 8 12 2}{cmd:. gr7 tempjuly, bin(9) log normal xlabel noxaxis yline ylabel xline(58,100) t1("(Based on 956 U.S. Cities)") by(region) total}


{title:Also see}

{pstd}
The eight {cmd:graph7} types are specified as options.  The other seven
types are

{center:Option       Graph type                    See help }
{center:{hline 52}}
{center:{cmdab:t:woway}       Two-way scatterplot           {help gr7twoway}}
{center:{cmdab:m:atrix}       Two-way scatterplot matrix    {help gr7matrix}}
{center:{cmdab:o:neway}       One-way scatterplot           {help gr7oneway}}
{center:{cmdab:b:ox}          Box-and-whisker plot          {help gr7box}   }
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym};
{manhelp cumul R}, {manhelp histogram R}, {manhelp stem R}
{p_end}
