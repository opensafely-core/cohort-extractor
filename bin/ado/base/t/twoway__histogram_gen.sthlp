{smcl}
{* *! version 1.0.9  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "help twoway_histogram"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{viewerjumpto "Syntax" "twoway__histogram_gen##syntax"}{...}
{viewerjumpto "Description" "twoway__histogram_gen##description"}{...}
{viewerjumpto "Options" "twoway__histogram_gen##options"}{...}
{viewerjumpto "Stored results" "twoway__histogram_gen##results"}{...}
{title:Title}

{p 4 35 2}
{hi:[G-2] twoway__histogram_gen} {hline 2} Histogram subroutine


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:twoway__histogram_gen}
	{it:varname}
	[{it:weight}]
	[{cmd:if} {it:exp}]
	[{cmd:in} {it:range}]
	[{cmd:,}
	{c -(}{it:discrete_options}|{it:continuous_options}{c )-}
	{it:common_options}]

{pstd}
where {it:discrete_options} are

	{it:discrete_options}{col 42}Description
	{hline 65}
	{cmdab:d:iscrete}{...}
{col 42}specify data are discrete
	{cmd:width(}{it:#}{cmd:)}{...}
{col 42}width of bins in {it:varname} units
	{cmd:start(}{it:#}{cmd:)}{...}
{col 42}theoretical minimum value
	{hline 65}

{pstd}
and where {it:continuous_options} are

	{it:continuous_options}{col 42}Description
	{hline 65}
	{cmd:bin(}{it:#}{cmd:)}{...}
{col 42}{it:#} of bins
	{cmd:width(}{it:#}{cmd:)}{...}
{col 42}width of bins in {it:varname} units
	{cmd:start(}{it:#}{cmd:)}{...}
{col 42}lower limit of first bin
	{hline 65}

{pstd}
and where {it:common_options} are

	{it:common_options}{col 42}Description
	{hline 65}
	{cmdab:den:sity}{...}
{col 42}draw as density (default)
	{cmdab:frac:tion}{...}
{col 42}draw as fractions
	{cmdab:freq:uency}{...}
{col 42}draw as frequencies

	{cmdab:gen:erate:(}{it:h x} [, {cmd:replace} ]{cmd:)}{...}
{col 42}generate variables

	{cmd:display}{...}
{col 42}display (bin) start and width
	{hline 64}

{pstd}
{cmd:fweight}s are allowed; see {help weights}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway__histogram_gen} generates a variable containing densities,
frequencies, or fractions of the occurrence of bins (class intervals) of
{it:varname}.

{pstd}
This tool was written for generating histograms, see
{manhelp twoway_histogram G-2:graph twoway histogram}.


{marker options}{...}
{title:Options}

{phang}
{it:discrete_options} affect the parameters needed to draw a discrete
histogram.  See {manhelp histogram R} for more details.

{phang}
{it:continuous_options} affect the parameters needed to draw a continuous
histogram.  See {manhelp histogram R} for more details.

{phang}
{cmd:density},
{cmd:fraction}, and
{cmd:frequency}
    are alternatives.  They specify whether you want the histogram scaled to
    density units, fractional units, or frequency.  {cmd:density} is the
    default.  See {manhelp histogram R} for more details.

{phang}
{cmd:generate(}{it:h} {it:x} [{cmd:,} {cmd:replace}]{cmd:)} specifies the
names of the variables to generate.  The height of each bin will be placed in
{it:h}, and the center of each bin will be placed in {it:x}.  The
{cmd:replace} option indicates that these variables may be replaced if they
already exist.

{phang}
{cmd:display} indicates that a short note be displayed indicating the number of
bins, the lower limit of the first bin, and the width of the bins.  The output
displayed is determined by whether the {cmd:discrete} option was specified.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:twoway__histogram_gen} stores the following in {cmd:r()}:

{pstd}
Scalars:

	 {cmd:r(N)}      number of observations
	 {cmd:r(bin)}    number of bins
	 {cmd:r(width)}  common width of the bins
	 {cmd:r(start)}  {cmd:start()} value or minimum value of {it:varname}
	 {cmd:r(min)}    lower limit of the first non-empty bin
	 {cmd:r(max)}    upper limit of the last bin
	 {cmd:r(area)}   area of the bars

{pstd}
Macros:

	 {cmd:r(type)}   "density", "fraction" or "frequency"
