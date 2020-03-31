{smcl}
{* *! version 1.0.6  11feb2011}{...}
{cmd:help graph7}, {cmd:help gr7}{right:{help prdocumented:previously documented}}
{hline}

{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{hi:[G-2] graph7} {hline 2}}The old graph command{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}]
[{it:weight}]
[{cmd:if} {it:exp}]
[{cmd:in} {it:range}]
[{cmd:,} ...]

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
{cmd:using}
{it:filename}
[{it:filename} ...]
[{cmd:,} ...]


{title:Description}

{pstd}
Stata's {cmd:graph} command changed markedly as of Stata 8.  {cmd:graph7}, or
{cmd:gr7}, provides access to the old {cmd:graph} command.

{pstd}
{cmd:graph}, run under version control, is also the old {cmd:graph} command,
and thus old ado-files and commands continue to work although they 
do not pick up the new features available under Stata 8.

{pstd}
See {helpb graph} for the modern version of {cmd:graph}.


{title:Details of the old {cmd:graph} command}

	{cmdab:vers:ion} {cmd:7:} {cmdab:gr:aph} ...

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}] [{cmd:,} {it:graph_type} {it:specific_options}
{it:common_options}]

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
{cmd:using} {it:filename}
[{it:filename} {it:...}] [{cmd:,} {it:graph_using_options}]

	{cmd:set} {cmdab:te:xtsize} {it:#}


{pstd}
where {it:graph_type} is specified using one of the following eight options:

{center:Option       Graph type                    See help }
{center:{hline 52}}
{center:{cmdab:hi:stogram}    Histogram                     {help gr7hist}  }
{center:{cmdab:t:woway}       Two-way scatterplot           {help gr7twoway}}
{center:{cmdab:m:atrix}       Two-way scatterplot matrix    {help gr7matrix}}
{center:{cmdab:o:neway}       One-way scatterplot           {help gr7oneway}}
{center:{cmdab:b:ox}          Box-and-whisker plot          {help gr7box}   }
{center:{cmdab:st:ar}         Star chart                    {help gr7star}  }
{center:{cmdab:ba:r}          Bar chart                     {help gr7bar}   }
{center:{cmdab:p:ie}          Pie chart                     {help gr7pie}   }
{center:{hline 52}}

{pstd}
and {it:specific_options} are documented with the help file for the
particular graph type.  The {it:common_options} are documented as shown below.

{center:{it:common_options}                                See help}
{center:{hline 54}}
{center:title and axes options                        {help gr7axes} }
{center:symbol and line options                       {help gr7sym}  }
{center:color and shading options                     {help gr7color}}
{center:saving, printing, & multiple image options    {help gr7other}}
{center:{hline 54}}

{pstd}
The {it:graph_using_options} are documented in {help gr7other}.

{pstd}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:aweight}s are allowed; all are
treated identically; see {help weight}.

{pstd}
{cmd:graph7}'s {it:varlist} may contain time-series operators; see 
{varlist}.

{pstd}
The old {cmd:set textsize} command controls the size of all text appearing on
the graph.  {cmd:textsize} is originally {cmd:100}, meaning 100% of normal
size.  {cmd:set textsize 125} will make the text 25% larger than normal.
{cmd:set textsize 75} will make it smaller.


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp graph G-2};
{help gr7axes}, {help gr7color}, {help gr7oneway},
{help gr7star}, {help gr7bar}, {help gr7hist}, {help gr7other}, {help gr7sym},
{help gr7box}, {help gr7matrix}, {help gr7pie}, {help gr7twoway}, {help gph},
{help gprefs}
{p_end}
