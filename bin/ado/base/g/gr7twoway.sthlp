{smcl}
{* *! version 1.0.5  14may2018}{...}
{cmd:help gr7twoway}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:Graph two-way scatterplots ({cmd:graph7, twoway} command)}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}]{cmd:,} {cmdab:t:woway} [{it:common_options}
{cmdab:j:itter:(}{it:#}{cmd:)} {cmdab:r:escale} {cmdab:rb:ox}
{c -(}{cmdab:y:}|{cmdab:x:}|{cmdab:r:}{c )-}{cmdab:r:everse}]


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
{cmd:graph7} {it:...} {cmd:, twoway} {it:...} specifies a two-way
scatterplot; this is the default for {cmd:graph7} when more than one variable
is specified.  {cmd:twoway} may be combined with {cmd:oneway} (see
{help gr7oneway}) or {cmd:box} (see {help gr7box}), but in that case, you must
specify {cmd:twoway} explicitly.

{p 4 4 2}
For an introduction to {cmd:graph7}, see {helpb graph7}.


{title:Options unique to {cmd:twoway}}

{p 4 8 2}{cmd:jitter(}{it:#}{cmd:)} adds spherical random noise to each point
before graphing, where {it:#} represents the magnitude of the noise as a
percent of graphical area.  The default is {cmd:jitter(0)}.  {cmd:jitter(5)}
is a large amount.  (This is useful to keep categorical data from
overplotting.)

{p 4 8 2}{cmd:rescale} scales each y-variable independently.  If there are two
y-variables, the scale of the first is presented on the left (x) axis and the
scale for the second on the right (r) axis.  If there are more than two
y-variables, no vertical scale is labeled.

{p 4 8 2}{cmd:rbox} places a rangefinder box plot on the graph.

{p 4 8 2}{c -(}{cmd:y}|{cmd:x}|{cmd:r}{c )-}{cmd:reverse} reverses the indicated
scale to run from high-to-low.


{title:Examples}

{p 4 4 2}
Since {cmd:twoway} is the default for {helpb graph7} with more than one
variable:

{p 8 12 2}{cmd:. graph7 y x} {space 7} (graphs y against x)

{p 8 12 2}{cmd:. graph7 y1 y2 x} {space 3} (graphs y1 and y2 against x)

{p 4 4 2}
Here are more involved examples:

{p 8 12 2}{cmd:. gr7 mpgfor mpgdom weight, xlog ylab xlab l1("Mileage (mpg)")}

{p 8 12 2}{cmd:. gr7 clnsl herd time, c(ll) rescale ysca(2000,3500) rsca(700,1100) ylab(2500(250)3500) rlab(700(50)900) xlab(1967(1)1975) t1(U.K. Pig Production)}

{p 4 4 2}
This one additionally uses the {cmd:box} style:

{p 8 12 2}{cmd:. gr7 mpg displ, two box rbox ylab xlab border}


{title:Also see}

{pstd}
The eight {cmd:graph7} types are specified as options.  The other seven
types are

{center:Option       Graph type                    See help }
{center:{hline 52}}
{center:{cmdab:hi:stogram}    histogram                     {help gr7hist}  }
{center:{cmdab:m:atrix}       Two-way scatterplot matrix    {help gr7matrix}}
{center:{cmdab:o:neway}       One-way scatterplot           {help gr7oneway}}
{center:{cmdab:b:ox}          Box-and-whisker plot          {help gr7box}   }
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7color},
{help gr7other}, {help gr7sym}; {manhelp diagnostic_plots R:Diagnostic plots}
{p_end}
