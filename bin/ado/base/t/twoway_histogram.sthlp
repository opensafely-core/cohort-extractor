{smcl}
{* *! version 1.1.12  28aug2018}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "mansection G-2 graphtwowayhistogram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway kdensity" "help twoway_kdensity"}{...}
{viewerjumpto "Syntax" "twoway_histogram##syntax"}{...}
{viewerjumpto "Menu" "twoway_histogram##menu"}{...}
{viewerjumpto "Description" "twoway_histogram##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_histogram##linkspdf"}{...}
{viewerjumpto "Options for use in the discrete case" "twoway_histogram##options_discrete"}{...}
{viewerjumpto "Options for use in the continuous case" "twoway_histogram##options_continuous"}{...}
{viewerjumpto "Options for use in both cases" "twoway_histogram##options_both"}{...}
{viewerjumpto "Remarks" "twoway_histogram##remarks"}{...}
{viewerjumpto "References" "twoway_histogram##references"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[G-2] graph twoway histogram} {hline 2}}Histogram plots{p_end}
{p2col:}({mansection G-2 graphtwowayhistogram:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:tw:oway}
{cmdab:hist:ogram}
{varname}
{ifin}
[{it:{help twoway histogram##weight:weight}}]
[{cmd:,}
[{it:discrete_options}|{it:continuous_options}]
{it:common_options}]

{synoptset 25}{...}
{p2col:{it:discrete_options}}Description{p_end}
{p2line}
{p2col:{cmdab:disc:rete}}specify that data are discrete{p_end}
{p2col:{cmdab:w:idth:(}{it:#}{cmd:)}}width of bins in {varname} units{p_end}
{p2col:{cmd:start(}{it:#}{cmd:)}}theoretical minimum value{p_end}
{p2line}

{p2col:{it:continuous_options}}Description{p_end}
{p2line}
{p2col:{cmd:bin(}{it:#}{cmd:)}}{it:#} of bins{p_end}
{p2col:{cmdab:w:idth:(}{it:#}{cmd:)}}width of bins in {varname} units{p_end}
{p2col:{cmd:start(}{it:#}{cmd:)}}lower limit of first bin{p_end}
{p2line}

{p2col:{it:common_options}}Description{p_end}
{p2line}
{p2col:{cmdab:den:sity}}draw as density; the default{p_end}
{p2col:{cmdab:frac:tion}}draw as fractions{p_end}
{p2col:{cmdab:freq:uency}}draw as frequencies{p_end}
{p2col:{cmdab:percent}}draw as percents{p_end}

{p2col:{cmdab:vert:ical}}vertical bars; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal bars{p_end}
{p2col:{cmd:gap(}{it:#}{cmd:)}}reduce width of bars, 0{ul:<}{it:#}<100{p_end}

INCLUDE help gr_baropt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}

{marker weight}{...}
{phang}
{cmd:fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:histogram} draws histograms of {varname}.
Also see {manhelp histogram R} for an easier-to-use alternative.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayhistogramQuickstart:Quick start}

        {mansection G-2 graphtwowayhistogramRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_discrete}{...}
{title:Options for use in the discrete case}

{phang}
{cmd:discrete}
    specifies that {varname} is discrete and that each unique
    value of {it:varname} be given its own bin (bar of histogram).

{phang}
{cmd:width(}{it:#}{cmd:)}
    is rarely specified in the discrete case; it specifies the width of the
    bins.  The default is {cmd:width(}{it:d}{cmd:)}, where {it:d} is the
    observed minimum difference between the unique values of {varname}.

{pmore}
    Specify {cmd:width()} if you are concerned that your data are sparse.  For
    example, {it:varname} could in theory take on the values 1, 2, 3, ..., 9,
    but because of sparseness, perhaps only the values 2, 4, 7, and 8 are
    observed.  Here the default width calculation would produce
    {cmd:width(2)}, and you would want to specify {cmd:width(1)}.

{phang}
{cmd:start(}{it:#}{cmd:)}
    is also rarely specified in the discrete case; it specifies the
    theoretical minimum value of {varname}.  The default is
    {cmd:start(}{it:m}{cmd:)}, where {it:m} is the observed minimum
    value.

{pmore}
    As with {cmd:width()}, specify {cmd:start()} when you are concerned
    about sparseness.  In the previous example, you would also
    want to specify {cmd:start(1)}.  {cmd:start()} does nothing
    more than add white space to the left side of the graph.

{pmore}
    {cmd:start()}, if specified, must be less than or equal to {it:m},
    or an error will be issued.


{marker options_continuous}{...}
{title:Options for use in the continuous case}

{phang}
{cmd:bin(}{it:#}{cmd:)}
and
{cmd:width(}{it:#}{cmd:)}
    are alternatives that specify how the data are to be aggregated into
    bins.  {cmd:bin()} specifies the number of bins (from which the width
    can be derived), and {cmd:width()} specifies the bin width (from which
    the number of bins can be derived).

{pmore}
    If neither option is specified, the
    results are the same as if {cmd:bin(}{it:k}{cmd:)} were specified, where

{phang3}
{it:k} = min(sqrt({it:N}), 10*ln({it:N})/ln(10))

{pmore}
    and where {it:N} is the number of nonmissing observations of {varname}.

{phang}
{cmd:start(}{it:#}{cmd:)}
    specifies the theoretical minimum of {varname}.  The default is
    {cmd:start(}{it:m}{cmd:)}, where {it:m} is the observed minimum value of
    {it:varname}.

{pmore}
    Specify {cmd:start()} when you are concerned about sparse data.
    For instance, you might know that {it:varname} can go down to 0, but you
    are concerned that 0 may not be observed.

{pmore}
    {cmd:start()}, if specified, must be less than or equal to {it:m},
    or an error will be issued.


{marker options_both}{...}
{title:Options for use in both cases}

{phang}
{cmd:density},
{cmd:fraction},
{cmd:frequency}, and
{cmd:percent}
    are alternatives that specify whether you want the histogram scaled to
    density, fractional, or frequency units, or percentages.  {cmd:density} is
    the default.

{pmore}
    {cmd:density} scales the height of the bars so that the sum of their areas
    equals 1.

{pmore}
    {cmd:fraction} scales the height of the bars so that the sum of their
    heights equals 1.

{pmore}
    {cmd:frequency} scales the height of the bars so that each bar's
    height is equal to the number of observations in the category, and thus
    the sum of the heights is equal to the total number of nonmissing
    observations of {varname}.

{pmore}
    {cmd:percent} scales the height of the bars so that the sum of their
    heights equals 100.

{phang}
{cmd:vertical}
and
{cmd:horizontal}
    specify whether the bars are to be drawn
    vertically (the default) or horizontally.

{phang}
{cmd:gap(}{it:#}{cmd:)}
    specifies that the bar width be reduced by {it:#} percent.
    {cmd:gap(0)} is the default; {cmd:histogram} sets the width so that
    adjacent bars just touch.  If you wanted gaps between the bars, you 
    would specify, for instance, {cmd:gap(5)}.

{pmore}
    Also see {manhelp twoway_rbar G-2:graph twoway rbar} for other ways to set
    the display width of the bars.  Histograms are actually drawn using
    {cmd:twoway rbar} with a restriction that 0 be included in the bars;
    {cmd:twoway histogram} will accept any options allowed by
    {cmd:twoway rbar}.

{* fill areas, dimming and brightening}{...}
{* index colors, dimming and brightening}{...}
{* index color() tt option}{...}
{* index color intensity adjustment}{...}
{* index intensity, color, adjustment}{...}
INCLUDE help gr_baroptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help twoway histogram##remarks1:Relationship between graph twoway histogram and histogram}
        {help twoway histogram##remarks2:Typical use}
        {help twoway histogram##remarks3:Use with by()}
        {help twoway histogram##remarks4:History}


{marker remarks1}{...}
{title:Relationship between graph twoway histogram and histogram}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:histogram} -- documented here -- and
{cmd:histogram} -- documented in {manhelp histogram R} -- are almost the
same command.  {cmd:histogram} has the advantages that

{phang2}
    1.  it allows overlaying of a normal density or a kernel estimate of the
	density;

{phang2}
    2.  if a density estimate is overlaid, it scales the density to reflect
	the scaling of the bars.

{pstd}
{cmd:histogram} is implemented in terms of {cmd:graph}
{cmd:twoway} {cmd:histogram}.


{marker remarks2}{...}
{title:Typical use}

{pstd}
When you do not specify otherwise, {cmd:graph} {cmd:twoway} {cmd:histogram}
assumes that the variable is continuous:

	{cmd:. sysuse lifeexp}

	{cmd:. twoway histogram le}
	  {it:({stata "gr_example lifeexp: tw histogram le":click to run})}
{* graph gthist1}{...}

{pstd}
Even with a continuous variable, you may specify the {cmd:discrete} option
to see the individual values:

	{cmd:. twoway histogram le, discrete}
	  {it:({stata "gr_example lifeexp: tw histogram le, discrete":click to run})}
{* graph gthist2}{...}


{marker remarks3}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:histogram} may be used with {cmd:by()}:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. twoway histogram le, discrete by(region, total)}
	  {it:({stata "gr_example lifeexp: tw histogram le, discrete by(region, total)":click to run})}
{* graph gthist3}{...}

{pstd}
Here specifying {cmd:frequency} is a good way to show both the
distribution and the overall contribution to the total:

{phang2}
	{cmd:. twoway histogram le, discrete freq by(region, total)}
{p_end}
	  {it:({stata "gr_example lifeexp: tw histogram le, discrete freq by(region, total)":click to run})}
{* graph gthist4}{...}

{pstd}
The height of the bars reflects the number of countries.
Here -- and in all the above examples -- we would do better
by obtaining population data on the countries and then typing

{phang2}
	{cmd:. twoway histogram le [fw=pop], discrete freq by(region, total)}

{pstd}
so that bar height reflected total population.


{* index histories}{...}
{* index Beniger and Robyn}{...}
{* index Guerry, A. M.}{...}
{* index Pearson, Karl}{...}
{marker remarks4}{...}
{title:History}

{pstd}
According to {help twoway histogram##BR1978:Beniger and Robyn (1978, 4)},
although A. M. Guerry published a histogram in
{help twoway histogram##G1833:1833}, the word "histogram" was
first used by Karl Pearson in {help twoway histogram##P1895:1895}.


{marker references}{...}
{title:References}

{marker BR1978}{...}
{phang}
Beniger, J. R., and D. L. Robyn. 1978 Quantitative graphics in statistics:
A brief history. {it:American Statistician} 32: 1-11.

{marker G1833}{...}
{phang}
Guerry, A.-M. 1833. {it:Essai sur la Statique Morale de la France}.
Paris: Crochard.

{marker P1895}{...}
{phang}
Pearson, K. 1895. Contributions to the mathematical theory of evolution -- II.
Skew variation in homogeneous material.
{it:Philosophical Transactions of the Royal Society in London, Series A} 186:
343-414.
{p_end}
